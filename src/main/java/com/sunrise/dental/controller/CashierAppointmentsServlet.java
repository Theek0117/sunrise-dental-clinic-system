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

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.AppointmentService;

@WebServlet("/cashier/appointments")
public class CashierAppointmentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
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
        List<Appointment> allAppointments = appointmentService.getAllAppointments();

        Map<Integer, Patient> patients = new HashMap<>();
        Map<Integer, Dentist> dentists = new HashMap<>();

        for (Appointment a : allAppointments) {
            int patientId = a.getPatientId();
            int dentistId = a.getDentistId();

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
        }

        List<Appointment> filteredList = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            String query = search.trim().toLowerCase();
            for (Appointment a : allAppointments) {
                boolean matchNumber = a.getAppointmentNumber() != null && a.getAppointmentNumber().toLowerCase().contains(query);
                boolean matchStatus = a.getStatus() != null && a.getStatus().toLowerCase().contains(query);

                Patient p = patients.get(a.getPatientId());
                boolean matchPatient = p != null && p.getName() != null && p.getName().toLowerCase().contains(query);

                Dentist d = dentists.get(a.getDentistId());
                boolean matchDentist = d != null && d.getName() != null && d.getName().toLowerCase().contains(query);

                if (matchNumber || matchStatus || matchPatient || matchDentist) {
                    filteredList.add(a);
                }
            }
        } else {
            filteredList = allAppointments;
        }

        request.setAttribute("appointments", filteredList);
        request.setAttribute("patients", patients);
        request.setAttribute("dentists", dentists);
        request.setAttribute("searchQuery", search != null ? search.trim() : "");

        request.getRequestDispatcher("/cashier/appointments.jsp").forward(request, response);
    }
}
