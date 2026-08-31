package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.AppointmentService;

@WebServlet({"/reception/view-appointments", "/reception/view-appointment"})
public class ViewAppointmentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> appointments =
                appointmentService.getAllAppointments();

        Map<Integer, Patient> patients = new HashMap<>();
        Map<Integer, Dentist> dentists = new HashMap<>();

        for (Appointment appointment : appointments) {
            int patientId = appointment.getPatientId();
            int dentistId = appointment.getDentistId();

            if (!patients.containsKey(patientId)) {
                Patient patient = appointmentService.getPatient(patientId);
                if (patient != null) {
                    patients.put(patientId, patient);
                }
            }

            if (!dentists.containsKey(dentistId)) {
                Dentist dentist = appointmentService.getDentist(dentistId);
                if (dentist != null) {
                    dentists.put(dentistId, dentist);
                }
            }
        }

        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.setAttribute("dentists", dentists);

        request.getRequestDispatcher(
                "/reception/viewAppointments.jsp"
        ).forward(request, response);
    }
}