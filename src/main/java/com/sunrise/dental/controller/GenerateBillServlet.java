package com.sunrise.dental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.dao.AppointmentDAOImpl;
import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.dao.PaymentDAO;
import com.sunrise.dental.dao.PaymentDAOImpl;
import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.model.PaymentAdditionalCharge;
import com.sunrise.dental.model.TreatmentType;
import com.sunrise.dental.service.PaymentService;

@WebServlet("/cashier/generate-bill")
public class GenerateBillServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private DentistDAO dentistDAO;
    private TreatmentTypeDAO treatmentTypeDAO;
    private PaymentDAO paymentDAO;
    private PaymentService paymentService;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAOImpl();
        patientDAO = new PatientDAOImpl();
        dentistDAO = new DentistDAOImpl();
        treatmentTypeDAO = new TreatmentTypeDAOImpl();
        paymentDAO = new PaymentDAOImpl();
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"CASHIER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String appointmentIdParameter = request.getParameter("appointmentId");
        if (appointmentIdParameter == null || appointmentIdParameter.isBlank()) {
            request.setAttribute("error", "Please select an appointment to generate a bill.");
            forwardToPage(request, response);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdParameter.trim());
            Appointment appointment = appointmentDAO.findById(appointmentId);

            if (appointment == null) {
                request.setAttribute("error", "The selected appointment could not be found.");
                forwardToPage(request, response);
                return;
            }

            if (!"COMPLETED".equalsIgnoreCase(appointment.getStatus())) {
                request.setAttribute("error", "A bill can only be generated for a completed appointment.");
                forwardToPage(request, response);
                return;
            }

            Payment existingPayment = paymentDAO.findByAppointmentId(appointmentId);
            if (existingPayment != null) {
                response.sendRedirect(request.getContextPath() + "/cashier/invoice?paymentId=" + existingPayment.getPaymentId());
                return;
            }

            loadBillingData(request, appointment);
            forwardToPage(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid appointment information.");
            forwardToPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"CASHIER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String appointmentIdParameter = request.getParameter("appointmentId");
        String doctorFeeParameter = request.getParameter("doctorFee");
        String paymentMethod = request.getParameter("paymentMethod");

        String[] chargeNames = request.getParameterValues("chargeName");
        String[] chargeAmounts = request.getParameterValues("chargeAmount");

        if (appointmentIdParameter == null || appointmentIdParameter.isBlank()) {
            request.setAttribute("error", "Invalid appointment ID.");
            forwardToPage(request, response);
            return;
        }

        if (paymentMethod == null || paymentMethod.isBlank()) {
            request.setAttribute("error", "Please select a payment method.");
            reloadBillingPage(request, response, appointmentIdParameter);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdParameter.trim());
            Appointment appointment = appointmentDAO.findById(appointmentId);

            if (appointment == null) {
                request.setAttribute("error", "Appointment not found.");
                forwardToPage(request, response);
                return;
            }

            if (!"COMPLETED".equalsIgnoreCase(appointment.getStatus())) {
                request.setAttribute("error", "Billing is only available for completed appointments.");
                reloadBillingPage(request, response, appointmentIdParameter);
                return;
            }

            Payment existingPayment = paymentDAO.findByAppointmentId(appointmentId);
            if (existingPayment != null) {
                response.sendRedirect(request.getContextPath() + "/cashier/invoice?paymentId=" + existingPayment.getPaymentId());
                return;
            }

            TreatmentType treatmentType = treatmentTypeDAO.findById(appointment.getTreatmentTypeId());
            BigDecimal basicAmount = (treatmentType != null && treatmentType.getBasicCost() != null)
                    ? treatmentType.getBasicCost()
                    : BigDecimal.ZERO;

            BigDecimal doctorFee = BigDecimal.ZERO;
            if (doctorFeeParameter != null && !doctorFeeParameter.isBlank()) {
                doctorFee = new BigDecimal(doctorFeeParameter.trim());
                if (doctorFee.compareTo(BigDecimal.ZERO) < 0) {
                    doctorFee = BigDecimal.ZERO;
                }
            }

            List<PaymentAdditionalCharge> additionalCharges = new ArrayList<>();
            BigDecimal totalAdditional = BigDecimal.ZERO;

            if (chargeNames != null && chargeAmounts != null) {
                for (int i = 0; i < chargeNames.length && i < chargeAmounts.length; i++) {
                    String name = chargeNames[i];
                    String amtStr = chargeAmounts[i];
                    if (name != null && !name.trim().isEmpty() && amtStr != null && !amtStr.trim().isEmpty()) {
                        try {
                            BigDecimal amt = new BigDecimal(amtStr.trim());
                            if (amt.compareTo(BigDecimal.ZERO) > 0) {
                                additionalCharges.add(new PaymentAdditionalCharge(0, name.trim(), amt));
                                totalAdditional = totalAdditional.add(amt);
                            }
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }

            Payment payment = new Payment();
            payment.setInvoiceNumber(paymentService.generatePaymentNumber());
            payment.setAppointmentId(appointment.getAppointmentId());
            payment.setPatientId(appointment.getPatientId());
            payment.setTreatmentTypeId(appointment.getTreatmentTypeId());
            payment.setBasicAmount(basicAmount);
            payment.setDoctorFee(doctorFee);
            payment.setAdditionalAmount(totalAdditional);
            payment.setPaymentMethod(paymentMethod.trim().toUpperCase());
            payment.setPaymentStatus("PAID");

            boolean saved = paymentService.savePaymentWithCharges(payment, additionalCharges);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/cashier/invoice?paymentId=" + payment.getPaymentId());
                return;
            }

            request.setAttribute("error", "Unable to generate the bill. Please try again.");
            reloadBillingPage(request, response, appointmentIdParameter);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Please check all amounts entered. Numeric values only.");
            reloadBillingPage(request, response, appointmentIdParameter);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred while generating the bill.");
            reloadBillingPage(request, response, appointmentIdParameter);
        }
    }

    private void loadBillingData(HttpServletRequest request, Appointment appointment) {
        request.setAttribute("appointment", appointment);

        Patient patient = patientDAO.findById(appointment.getPatientId());
        request.setAttribute("patient", patient);

        Dentist dentist = (appointment.getDentistId() > 0) ? dentistDAO.findById(appointment.getDentistId()) : null;
        request.setAttribute("dentist", dentist);

        TreatmentType treatmentType = treatmentTypeDAO.findById(appointment.getTreatmentTypeId());
        request.setAttribute("treatmentType", treatmentType);

        BigDecimal basicAmount = (treatmentType != null && treatmentType.getBasicCost() != null)
                ? treatmentType.getBasicCost()
                : BigDecimal.ZERO;
        request.setAttribute("basicAmount", basicAmount);
    }

    private void reloadBillingPage(HttpServletRequest request, HttpServletResponse response, String appointmentIdParameter)
            throws ServletException, IOException {
        try {
            if (appointmentIdParameter != null && !appointmentIdParameter.isBlank()) {
                int appointmentId = Integer.parseInt(appointmentIdParameter.trim());
                Appointment appointment = appointmentDAO.findById(appointmentId);
                if (appointment != null) {
                    loadBillingData(request, appointment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        forwardToPage(request, response);
    }

    private void forwardToPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/cashier/generateBill.jsp").forward(request, response);
    }
}