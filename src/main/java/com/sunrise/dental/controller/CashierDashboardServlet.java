package com.sunrise.dental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.TreatmentType;
import com.sunrise.dental.service.AppointmentService;

@WebServlet("/cashier/dashboard")
public class CashierDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private TreatmentTypeDAO treatmentTypeDAO;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        treatmentTypeDAO = new TreatmentTypeDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
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

        String staffName = (String) session.getAttribute("staffName");
        if (staffName == null || staffName.isBlank()) {
            staffName = "Cashier";
        }

        List<Appointment> appointments = appointmentService.getCompletedAppointments();
        Date today = Date.valueOf(LocalDate.now());

        int totalCompleted = appointments.size();
        int todayCompleted = 0;
        BigDecimal todayBasicAmount = BigDecimal.ZERO;

        Map<Integer, TreatmentType> treatmentTypes = new HashMap<>();
        Map<Integer, Patient> patients = new HashMap<>();
        Map<Integer, Dentist> dentists = new HashMap<>();

        for (Appointment appointment : appointments) {
            int patientId = appointment.getPatientId();
            int dentistId = appointment.getDentistId();
            int treatmentTypeId = appointment.getTreatmentTypeId();

            if (patientId > 0 && !patients.containsKey(patientId)) {
                Patient p = appointmentService.getPatient(patientId);
                if (p != null) {
                    patients.put(patientId, p);
                }
            }

            if (dentistId > 0 && !dentists.containsKey(dentistId)) {
                Dentist d = appointmentService.getDentist(dentistId);
                if (d != null) {
                    dentists.put(dentistId, d);
                }
            }

            if (treatmentTypeId > 0) {
                TreatmentType treatmentType = treatmentTypeDAO.findById(treatmentTypeId);
                if (treatmentType != null) {
                    treatmentTypes.put(appointment.getAppointmentId(), treatmentType);
                }
            }

            if (appointment.getAppointmentDate() != null
                    && appointment.getAppointmentDate().equals(today)) {
                todayCompleted++;

                if (treatmentTypeId > 0) {
                    TreatmentType treatmentType = treatmentTypes.get(appointment.getAppointmentId());
                    if (treatmentType != null && treatmentType.getBasicCost() != null) {
                        todayBasicAmount = todayBasicAmount.add(treatmentType.getBasicCost());
                    }
                }
            }
        }

        request.setAttribute("staffName", staffName);
        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.setAttribute("dentists", dentists);
        request.setAttribute("today", today);
        request.setAttribute("totalCompleted", totalCompleted);
        request.setAttribute("todayCompleted", todayCompleted);
        request.setAttribute("todayBasicAmount", todayBasicAmount);
        request.setAttribute("treatmentTypes", treatmentTypes);

        request.getRequestDispatcher("/cashier/cashierDashboard.jsp").forward(request, response);
    }
}