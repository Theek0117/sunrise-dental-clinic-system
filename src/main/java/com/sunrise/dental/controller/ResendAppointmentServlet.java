package com.sunrise.dental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.EmailService;

@WebServlet("/reception/resend-appointment")
public class ResendAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private EmailService emailService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        emailService = new EmailService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("appointmentId");
        String returnTo = request.getParameter("returnTo");

        String redirectTarget = (returnTo != null && "schedule".equalsIgnoreCase(returnTo))
                ? "/reception/schedule"
                : "/reception/view-appointments";

        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + redirectTarget + "?error=invalid");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(idParam.trim());
            Appointment appointment = appointmentService.getAppointment(appointmentId);

            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + redirectTarget + "?error=notfound");
                return;
            }

            Patient patient = appointmentService.getPatient(appointment.getPatientId());
            Dentist dentist = appointmentService.getDentist(appointment.getDentistId());

            if (patient == null || patient.getEmail() == null || patient.getEmail().isBlank()) {
                response.sendRedirect(request.getContextPath() + redirectTarget + "?error=noemail");
                return;
            }

            if (dentist == null) {
                dentist = new Dentist();
                dentist.setName("Clinical Specialist");
                dentist.setSpecialization("Dental Care");
            }

            boolean emailSent = emailService.sendAppointmentConfirmation(patient, dentist, appointment);

            if (emailSent) {
                String encodedEmail = URLEncoder.encode(patient.getEmail(), StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + redirectTarget + "?success=resent&email=" + encodedEmail);
            } else {
                response.sendRedirect(request.getContextPath() + redirectTarget + "?error=email_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + redirectTarget + "?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + redirectTarget + "?error=server");
        }
    }
}
