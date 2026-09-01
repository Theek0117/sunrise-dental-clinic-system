package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.ArrayList;
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

@WebServlet("/cashier/billing")
public class CashierBillingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private TreatmentTypeDAO treatmentTypeDAO;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        treatmentTypeDAO = new TreatmentTypeDAOImpl();
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

        String search = request.getParameter("search");
        List<Appointment> allCompleted = appointmentService.getCompletedAppointments();

        Map<Integer, Patient> patients = new HashMap<>();
        Map<Integer, Dentist> dentists = new HashMap<>();
        Map<Integer, TreatmentType> treatmentTypes = new HashMap<>();

        for (Appointment app : allCompleted) {
            int patientId = app.getPatientId();
            int dentistId = app.getDentistId();
            int treatmentTypeId = app.getTreatmentTypeId();

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

            if (treatmentTypeId > 0 && !treatmentTypes.containsKey(app.getAppointmentId())) {
                TreatmentType tt = treatmentTypeDAO.findById(treatmentTypeId);
                if (tt != null) {
                    treatmentTypes.put(app.getAppointmentId(), tt);
                }
            }
        }

        List<Appointment> filteredList = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            String query = search.trim().toLowerCase();
            for (Appointment app : allCompleted) {
                boolean matchNumber = app.getAppointmentNumber() != null && app.getAppointmentNumber().toLowerCase().contains(query);
                boolean matchId = String.valueOf(app.getAppointmentId()).equals(query);

                Patient p = patients.get(app.getPatientId());
                boolean matchPatient = p != null && p.getName() != null && p.getName().toLowerCase().contains(query);

                Dentist d = dentists.get(app.getDentistId());
                boolean matchDentist = d != null && d.getName() != null && d.getName().toLowerCase().contains(query);

                if (matchNumber || matchId || matchPatient || matchDentist) {
                    filteredList.add(app);
                }
            }
        } else {
            filteredList = allCompleted;
        }

        request.setAttribute("appointments", filteredList);
        request.setAttribute("patients", patients);
        request.setAttribute("dentists", dentists);
        request.setAttribute("treatmentTypes", treatmentTypes);
        request.setAttribute("searchQuery", search != null ? search.trim() : "");

        request.getRequestDispatcher("/cashier/billing.jsp").forward(request, response);
    }
}
