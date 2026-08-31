package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.DentistService;
import com.sunrise.dental.service.EmailService;

@WebServlet({
    "/reception/reschedule-appointment",
    "/reception/rescheduleAppointment"
})
public class RescheduleAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private DentistService dentistService;
    private EmailService emailService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        dentistService = new DentistService();
        emailService = new EmailService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String idParameter =
                    request.getParameter("appointmentId");

            if (idParameter == null || idParameter.isBlank()) {
                redirect(request, response, "error=invalid");
                return;
            }

            int appointmentId =
                    Integer.parseInt(idParameter.trim());

            Appointment appointment =
                    appointmentService.getAppointment(
                            appointmentId
                    );

            if (appointment == null) {
                redirect(request, response, "error=notfound");
                return;
            }

            if ("CANCELLED".equalsIgnoreCase(
                    appointment.getStatus())) {

                redirect(request, response, "error=cancelled");
                return;
            }

            List<Dentist> dentists =
                    dentistService.getActiveDentists();

            request.setAttribute(
                    "appointment",
                    appointment
            );

            request.setAttribute(
                    "patient",
                    appointmentService.getPatient(
                            appointment.getPatientId()
                    )
            );

            request.setAttribute(
                    "dentist",
                    appointmentService.getDentist(
                            appointment.getDentistId()
                    )
            );

            request.setAttribute(
                    "dentists",
                    dentists
            );

            request.getRequestDispatcher(
                    "/reception/rescheduleAppointment.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            e.printStackTrace();

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

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Appointment oldAppointment = null;

        try {

            String appointmentIdParam =
                    request.getParameter("appointmentId");

            String dentistIdParam =
                    request.getParameter("dentistId");

            String availabilityIdParam =
                    request.getParameter("availabilityId");

            String appointmentDateParam =
                    request.getParameter("appointmentDate");

            String startTimeParam =
                    request.getParameter("startTime");

            String endTimeParam =
                    request.getParameter("endTime");

            String reason =
                    request.getParameter("reason");

            /*
             * ==========================================
             * BASIC VALIDATION
             * ==========================================
             */

            if (appointmentIdParam == null
                    || appointmentIdParam.isBlank()
                    || dentistIdParam == null
                    || dentistIdParam.isBlank()
                    || availabilityIdParam == null
                    || availabilityIdParam.isBlank()
                    || appointmentDateParam == null
                    || appointmentDateParam.isBlank()
                    || startTimeParam == null
                    || startTimeParam.isBlank()
                    || endTimeParam == null
                    || endTimeParam.isBlank()) {

                redirect(
                        request,
                        response,
                        "error=invalid"
                );

                return;
            }

            /*
             * ==========================================
             * CONVERT VALUES
             * ==========================================
             */

            int appointmentId =
                    Integer.parseInt(
                            appointmentIdParam.trim()
                    );

            int dentistId =
                    Integer.parseInt(
                            dentistIdParam.trim()
                    );

            int availabilityId =
                    Integer.parseInt(
                            availabilityIdParam.trim()
                    );

            Date appointmentDate =
                    Date.valueOf(
                            appointmentDateParam.trim()
                    );

            Time startTime =
                    parseTime(startTimeParam);

            Time endTime =
                    parseTime(endTimeParam);

            /*
             * ==========================================
             * GET CURRENT APPOINTMENT
             * ==========================================
             */

            oldAppointment =
                    appointmentService.getAppointment(
                            appointmentId
                    );

            if (oldAppointment == null) {

                redirect(
                        request,
                        response,
                        "error=notfound"
                );

                return;
            }

            if ("CANCELLED".equalsIgnoreCase(
                    oldAppointment.getStatus())) {

                redirect(
                        request,
                        response,
                        "error=cancelled"
                );

                return;
            }

            /*
             * ==========================================
             * RESCHEDULE
             * ==========================================
             */

            boolean updated =
                    appointmentService.rescheduleAppointment(
                            appointmentId,
                            dentistId,
                            availabilityId,
                            appointmentDate,
                            startTime,
                            endTime,
                            reason
                    );

            /*
             * ==========================================
             * RESCHEDULE FAILED
             * ==========================================
             */

            if (!updated) {

                request.setAttribute(
                        "error",
                        "The selected dentist, date or time slot is not available."
                );

                request.setAttribute(
                        "appointment",
                        oldAppointment
                );

                request.setAttribute(
                        "patient",
                        appointmentService.getPatient(
                                oldAppointment.getPatientId()
                        )
                );

                request.setAttribute(
                        "dentist",
                        appointmentService.getDentist(
                                oldAppointment.getDentistId()
                        )
                );

                request.setAttribute(
                        "dentists",
                        dentistService.getActiveDentists()
                );

                request.getRequestDispatcher(
                        "/reception/rescheduleAppointment.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * ==========================================
             * GET UPDATED APPOINTMENT
             * ==========================================
             */

            Appointment updatedAppointment =
                    appointmentService.getAppointment(
                            appointmentId
                    );

            if (updatedAppointment == null) {

                redirect(
                        request,
                        response,
                        "error=server"
                );

                return;
            }

            /*
             * ==========================================
             * GET PATIENT + DENTISTS
             * ==========================================
             */

            Patient patient =
                    appointmentService.getPatient(
                            updatedAppointment.getPatientId()
                    );

            Dentist oldDentist =
                    appointmentService.getDentist(
                            oldAppointment.getDentistId()
                    );

            Dentist newDentist =
                    appointmentService.getDentist(
                            updatedAppointment.getDentistId()
                    );

            /*
             * ==========================================
             * SEND RESCHEDULE EMAIL
             * ==========================================
             */

            boolean emailSent = false;

            if (patient != null
                    && newDentist != null
                    && patient.getEmail() != null
                    && !patient.getEmail().isBlank()) {

                try {

                    emailSent =
                            emailService.sendRescheduleEmail(
                                    patient,
                                    oldAppointment,
                                    updatedAppointment,
                                    oldDentist,
                                    newDentist
                            );

                } catch (Exception e) {

                    e.printStackTrace();

                    emailSent = false;
                }
            }

            /*
             * ==========================================
             * SUCCESS
             * ==========================================
             */

            if (emailSent) {

                redirect(
                        request,
                        response,
                        "success=rescheduled"
                );

            } else {

                redirect(
                        request,
                        response,
                        "success=rescheduled&email=failed"
                );
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            redirect(
                    request,
                    response,
                    "error=invalid"
            );

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

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

    /*
     * ==========================================
     * SAFE TIME PARSER
     * ==========================================
     */

    private Time parseTime(String value) {

        if (value == null || value.isBlank()) {

            throw new IllegalArgumentException(
                    "Time value is missing."
            );
        }

        String time =
                value.trim();

        /*
         * Remove milliseconds.
         *
         * Example:
         * 09:00:00.0
         * becomes
         * 09:00:00
         */

        if (time.contains(".")) {

            time =
                    time.substring(
                            0,
                            time.indexOf(".")
                    );
        }

        /*
         * Convert HH:mm to HH:mm:ss
         */

        if (time.matches("\\d{2}:\\d{2}")) {

            time += ":00";
        }

        try {

            return Time.valueOf(time);

        } catch (IllegalArgumentException e) {

            throw new IllegalArgumentException(
                    "Invalid time format: " + value
            );
        }
    }

    /*
     * ==========================================
     * REDIRECT
     * ==========================================
     */

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