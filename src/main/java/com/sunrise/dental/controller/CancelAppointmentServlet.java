package com.sunrise.dental.controller;

import java.io.IOException;

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

@WebServlet("/reception/cancel-appointment")
public class CancelAppointmentServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private EmailService emailService;

    @Override
    public void init() {

        appointmentService =
                new AppointmentService();

        emailService =
                new EmailService();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String idParameter =
                    request.getParameter(
                            "appointmentId"
                    );

            if (idParameter == null
                    || idParameter.isBlank()) {

                redirect(
                        request,
                        response,
                        "error=invalid"
                );

                return;
            }

            int appointmentId =
                    Integer.parseInt(
                            idParameter
                    );

            Appointment appointment =
                    appointmentService.getAppointment(
                            appointmentId
                    );

            if (appointment == null) {

                redirect(
                        request,
                        response,
                        "error=notfound"
                );

                return;
            }

            /*
             * Get patient and dentist BEFORE
             * changing the appointment status.
             */

            Patient patient =
                    appointmentService.getPatient(
                            appointment.getPatientId()
                    );

            Dentist dentist =
                    appointmentService.getDentist(
                            appointment.getDentistId()
                    );

            /*
             * Cancel appointment.
             */

            boolean cancelled =
                    appointmentService
                            .cancelAppointment(
                                    appointmentId
                            );

            if (!cancelled) {

                redirect(
                        request,
                        response,
                        "error=cancel"
                );

                return;
            }

            /*
             * Appointment is now CANCELLED
             * in the database.
             *
             * The slot is automatically released
             * because CANCELLED is not counted by
             * getSlotBookingCount().
             */

            boolean emailSent = false;

            if (patient != null
                    && dentist != null
                    && patient.getEmail() != null
                    && !patient.getEmail().isBlank()) {

                emailSent =
                        emailService
                                .sendCancellationEmail(
                                        patient,
                                        dentist,
                                        appointment
                                );
            }

            if (emailSent) {

                redirect(
                        request,
                        response,
                        "success=cancelled"
                );

            } else {

                /*
                 * Database cancellation still succeeded.
                 * Email failure should not undo the
                 * successful cancellation.
                 */

                redirect(
                        request,
                        response,
                        "success=cancelled&email=failed"
                );
            }

        } catch (NumberFormatException e) {

            redirect(
                    request,
                    response,
                    "error=invalid"
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirect(
                    request,
                    response,
                    "error=server"
            );
        }
    }

    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String query)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/reception/view-appointments?"
                + query
        );
    }
}