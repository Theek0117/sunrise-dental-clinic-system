package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;

import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.EmailService;

@WebServlet("/reception/book-appointment")
public class BookAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;

    private PatientDAO patientDAO;

    private DentistDAO dentistDAO;

    private TreatmentTypeDAO treatmentTypeDAO;

    private EmailService emailService;


    /*
     * ==========================================
     * INIT
     * ==========================================
     */

    @Override
    public void init() {

        appointmentService =
                new AppointmentService();

        patientDAO =
                new PatientDAOImpl();

        dentistDAO =
                new DentistDAOImpl();

        treatmentTypeDAO =
                new TreatmentTypeDAOImpl();

        emailService =
                new EmailService();
    }


    /*
     * ==========================================
     * GET
     * ==========================================
     *
     * Loads the appointment booking page.
     *
     * Data loaded:
     * 1. Active patients
     * 2. Active dentists
     * 3. Active treatment types
     *
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        loadBookingData(request);

        request.getRequestDispatcher(
                "/reception/bookAppointment.jsp"
        ).forward(
                request,
                response
        );
    }


    /*
     * ==========================================
     * POST
     * ==========================================
     *
     * Handles appointment booking.
     *
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {

            /*
             * ======================================
             * READ FORM VALUES
             * ======================================
             */

            String patientIdParameter =
                    request.getParameter(
                            "patientId"
                    );

            String dentistIdParameter =
                    request.getParameter(
                            "dentistId"
                    );

            String availabilityIdParameter =
                    request.getParameter(
                            "availabilityId"
                    );

            String appointmentDateParameter =
                    request.getParameter(
                            "appointmentDate"
                    );

            String startTimeParameter =
                    request.getParameter(
                            "startTime"
                    );

            String endTimeParameter =
                    request.getParameter(
                            "endTime"
                    );

            String reason =
                    request.getParameter(
                            "reason"
                    );


            /*
             * ======================================
             * BASIC VALIDATION
             * ======================================
             */

            if (patientIdParameter == null
                    || patientIdParameter.isBlank()
                    || dentistIdParameter == null
                    || dentistIdParameter.isBlank()
                    || availabilityIdParameter == null
                    || availabilityIdParameter.isBlank()
                    || appointmentDateParameter == null
                    || appointmentDateParameter.isBlank()
                    || startTimeParameter == null
                    || startTimeParameter.isBlank()
                    || endTimeParameter == null
                    || endTimeParameter.isBlank()
                    || reason == null
                    || reason.isBlank()) {

                request.setAttribute(
                        "error",
                        "Please complete all required appointment information."
                );

                loadBookingData(request);

                request.getRequestDispatcher(
                        "/reception/bookAppointment.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }


            /*
             * ======================================
             * CONVERT VALUES
             * ======================================
             */

            int patientId =
                    Integer.parseInt(
                            patientIdParameter
                    );

            int dentistId =
                    Integer.parseInt(
                            dentistIdParameter
                    );

            int availabilityId =
                    Integer.parseInt(
                            availabilityIdParameter
                    );

            Date appointmentDate =
                    Date.valueOf(
                            appointmentDateParameter
                    );

            Time startTime =
                    Time.valueOf(
                            startTimeParameter
                    );

            Time endTime =
                    Time.valueOf(
                            endTimeParameter
                    );

            reason =
                    reason.trim();


            /*
             * ======================================
             * VALIDATE TREATMENT TYPE
             * ======================================
             *
             * The selected appointment reason must
             * exist as an ACTIVE treatment type.
             *
             */

            if (!isActiveTreatmentType(reason)) {

                request.setAttribute(
                        "error",
                        "Please select a valid treatment type."
                );

                loadBookingData(request);

                request.getRequestDispatcher(
                        "/reception/bookAppointment.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }


            /*
             * ======================================
             * CREATE APPOINTMENT
             * ======================================
             */

            Appointment appointment =
                    new Appointment();

            appointment.setPatientId(
                    patientId
            );

            appointment.setDentistId(
                    dentistId
            );

            appointment.setAvailabilityId(
                    availabilityId
            );

            appointment.setAppointmentDate(
                    appointmentDate
            );

            appointment.setStartTime(
                    startTime
            );

            appointment.setEndTime(
                    endTime
            );

            appointment.setReason(
                    reason
            );


            /*
             * ======================================
             * BOOK APPOINTMENT
             * ======================================
             */

            boolean booked =
                    appointmentService
                            .bookAppointment(
                                    appointment
                            );


            /*
             * ======================================
             * SUCCESS
             * ======================================
             */

            if (booked) {

                request.setAttribute(
                        "success",
                        "Appointment booked successfully."
                );

                request.setAttribute(
                        "appointmentNumber",
                        appointment.getAppointmentNumber()
                );


                /*
                 * ==================================
                 * GET PATIENT
                 * ==================================
                 */

                Patient patient =
                        appointmentService.getPatient(
                                appointment.getPatientId()
                        );


                /*
                 * ==================================
                 * GET DENTIST
                 * ==================================
                 */

                Dentist dentist =
                        appointmentService.getDentist(
                                appointment.getDentistId()
                        );


                /*
                 * ==================================
                 * SEND EMAIL
                 * ==================================
                 */

                if (patient != null
                        && dentist != null
                        && patient.getEmail() != null
                        && !patient.getEmail().isBlank()) {

                    boolean emailSent =
                            emailService
                                    .sendAppointmentConfirmation(
                                            patient,
                                            dentist,
                                            appointment
                                    );

                    if (emailSent) {

                        request.setAttribute(
                                "emailMessage",
                                "A confirmation email has been sent to "
                                + patient.getEmail()
                        );

                    } else {

                        request.setAttribute(
                                "emailMessage",
                                "Appointment booked successfully, "
                                + "but the confirmation email could not be sent."
                        );
                    }

                } else {

                    request.setAttribute(
                            "emailMessage",
                            "Appointment booked successfully. "
                            + "No email confirmation was sent because "
                            + "the patient does not have a valid email address."
                    );
                }

            } else {

                request.setAttribute(
                        "error",
                        "Unable to book the appointment. "
                        + "The selected 30-minute slot may already be full, "
                        + "expired or unavailable."
                );
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Invalid patient, dentist or availability information."
            );

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Invalid appointment date or time."
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "An unexpected error occurred while booking the appointment."
            );
        }


        /*
         * ==========================================
         * RELOAD BOOKING DATA
         * ==========================================
         */

        loadBookingData(request);

        request.getRequestDispatcher(
                "/reception/bookAppointment.jsp"
        ).forward(
                request,
                response
        );
    }


    /*
     * ==========================================
     * LOAD BOOKING DATA
     * ==========================================
     *
     * Loads all data required by the booking JSP.
     *
     */

    private void loadBookingData(
            HttpServletRequest request) {

        /*
         * Active patients
         */

        request.setAttribute(
                "patients",
                patientDAO.findAllActive()
        );


        /*
         * Active dentists
         */

        request.setAttribute(
                "dentists",
                dentistDAO.findAllActive()
        );


        /*
         * Active treatment types
         */

        request.setAttribute(
                "treatmentTypes",
                treatmentTypeDAO.findAllActive()
        );
    }


    /*
     * ==========================================
     * CHECK ACTIVE TREATMENT TYPE
     * ==========================================
     *
     * Makes sure that the treatment selected
     * from the appointment form still exists
     * and is ACTIVE.
     *
     */

    private boolean isActiveTreatmentType(
            String treatmentName) {

        if (treatmentName == null
                || treatmentName.isBlank()) {

            return false;
        }

        var treatmentType =
                treatmentTypeDAO.findByName(
                        treatmentName.trim()
                );

        if (treatmentType == null) {
            return false;
        }

        return "ACTIVE".equalsIgnoreCase(
                treatmentType.getStatus()
        );
    }
}