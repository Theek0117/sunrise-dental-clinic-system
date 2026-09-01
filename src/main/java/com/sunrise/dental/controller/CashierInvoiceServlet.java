package com.sunrise.dental.controller;

import java.io.IOException;
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
import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.model.PaymentAdditionalCharge;
import com.sunrise.dental.model.TreatmentType;
import com.sunrise.dental.service.EmailService;
import com.sunrise.dental.service.PaymentService;

@WebServlet({"/cashier/invoice", "/cashier/send-invoice-email"})
public class CashierInvoiceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PaymentService paymentService;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private DentistDAO dentistDAO;
    private TreatmentTypeDAO treatmentTypeDAO;
    private EmailService emailService;

    @Override
    public void init() {
        paymentService = new PaymentService();
        appointmentDAO = new AppointmentDAOImpl();
        patientDAO = new PatientDAOImpl();
        dentistDAO = new DentistDAOImpl();
        treatmentTypeDAO = new TreatmentTypeDAOImpl();
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String staffName = (String) session.getAttribute("staffName");
        if (staffName == null || staffName.isBlank()) {
            staffName = "Cashier";
        }
        request.setAttribute("staffName", staffName);

        String paymentIdParam = request.getParameter("paymentId");
        String appointmentIdParam = request.getParameter("appointmentId");

        Payment payment = null;
        if (paymentIdParam != null && !paymentIdParam.isBlank()) {
            try {
                payment = paymentService.getPaymentById(Integer.parseInt(paymentIdParam.trim()));
            } catch (NumberFormatException ignored) {}
        } else if (appointmentIdParam != null && !appointmentIdParam.isBlank()) {
            try {
                payment = paymentService.getPaymentByAppointmentId(Integer.parseInt(appointmentIdParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        if (payment == null) {
            request.setAttribute("error", "The requested invoice could not be found.");
            request.getRequestDispatcher("/cashier/dashboard").forward(request, response);
            return;
        }

        List<PaymentAdditionalCharge> additionalCharges = paymentService.getAdditionalChargesByPaymentId(payment.getPaymentId());
        Appointment appointment = appointmentDAO.findById(payment.getAppointmentId());
        Patient patient = patientDAO.findById(payment.getPatientId());
        Dentist dentist = (appointment != null && appointment.getDentistId() > 0) ? dentistDAO.findById(appointment.getDentistId()) : null;
        TreatmentType treatmentType = treatmentTypeDAO.findById(payment.getTreatmentTypeId());

        request.setAttribute("payment", payment);
        request.setAttribute("additionalCharges", additionalCharges);
        request.setAttribute("appointment", appointment);
        request.setAttribute("patient", patient);
        request.setAttribute("dentist", dentist);
        request.setAttribute("treatmentType", treatmentType);

        request.getRequestDispatcher("/cashier/invoice.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String paymentIdParam = request.getParameter("paymentId");
        if (paymentIdParam != null && !paymentIdParam.isBlank()) {
            try {
                int paymentId = Integer.parseInt(paymentIdParam.trim());
                Payment payment = paymentService.getPaymentById(paymentId);
                if (payment != null) {
                    Patient patient = patientDAO.findById(payment.getPatientId());
                    Appointment appointment = appointmentDAO.findById(payment.getAppointmentId());
                    Dentist dentist = (appointment != null && appointment.getDentistId() > 0) ? dentistDAO.findById(appointment.getDentistId()) : null;
                    TreatmentType treatmentType = treatmentTypeDAO.findById(payment.getTreatmentTypeId());
                    List<PaymentAdditionalCharge> additionalCharges = paymentService.getAdditionalChargesByPaymentId(payment.getPaymentId());

                    String dentistName = dentist != null ? dentist.getName() : payment.getDentistName();
                    String treatmentName = treatmentType != null ? treatmentType.getTreatmentName() : payment.getTreatmentName();

                    boolean emailSent = emailService.sendInvoiceEmail(patient, payment, additionalCharges, dentistName, treatmentName);
                    if (emailSent) {
                        request.getSession().setAttribute("flashSuccess", "Invoice successfully sent to patient email: " + patient.getEmail());
                    } else {
                        request.getSession().setAttribute("flashError", "Unable to send email. Please verify patient email or SMTP settings.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("flashError", "Error sending invoice email.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/cashier/invoice?paymentId=" + paymentIdParam);
    }
}
