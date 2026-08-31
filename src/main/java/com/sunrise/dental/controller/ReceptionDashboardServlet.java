package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Comparator;
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


/**
 * ============================================================
 * RECEPTION DASHBOARD SERVLET
 * ============================================================
 *
 * URL:
 *
 *     /reception/dashboard
 *
 * Responsibilities:
 *
 *     1. Load today's appointments
 *     2. Calculate appointment statistics
 *     3. Load patient information
 *     4. Load dentist information
 *     5. Send all information to receptionDashboard.jsp
 *
 * ============================================================
 */

@WebServlet("/reception/dashboard")
public class ReceptionDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * ========================================================
     * SERVICES
     * ========================================================
     */

    private AppointmentService appointmentService;



    /*
     * ========================================================
     * INITIALIZE SERVLET
     * ========================================================
     */

    @Override
    public void init() throws ServletException {

        appointmentService =
                new AppointmentService();

    }



    /*
     * ========================================================
     * GET DASHBOARD
     * ========================================================
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        try {


            /*
             * =================================================
             * 1. GET TODAY
             * =================================================
             *
             * Use Sri Lanka time explicitly.
             *
             * This prevents the server timezone from causing
             * appointments to appear under the wrong date.
             */

            LocalDate today =
                    LocalDate.now(
                            ZoneId.of("Asia/Colombo")
                    );


            Date todayDate =
                    Date.valueOf(today);



            /*
             * =================================================
             * 2. GET ALL APPOINTMENTS
             * =================================================
             */

            List<Appointment> allAppointments =
                    appointmentService.getAllAppointments();


            /*
             * Never allow a null list to break the dashboard.
             */

            if (allAppointments == null) {

                allAppointments =
                        new ArrayList<>();

            }



            /*
             * =================================================
             * 3. FILTER TODAY'S APPOINTMENTS
             * =================================================
             *
             * IMPORTANT:
             *
             * Do NOT use:
             *
             *     appointmentDate.equals(todayDate)
             *
             * Instead convert the database date to LocalDate
             * and compare LocalDate values.
             */

            List<Appointment> todayAppointments =
                    new ArrayList<>();


            for (
                    Appointment appointment
                    : allAppointments
            ) {


                if (appointment == null) {
                    continue;
                }


                Date appointmentDate =
                        appointment.getAppointmentDate();


                if (appointmentDate == null) {
                    continue;
                }


                LocalDate appointmentLocalDate =
                        appointmentDate.toLocalDate();


                if (
                        appointmentLocalDate.equals(today)
                ) {

                    todayAppointments.add(
                            appointment
                    );

                }

            }



            /*
             * =================================================
             * 4. SORT BY START TIME
             * =================================================
             */

            todayAppointments.sort(

                    Comparator.comparing(
                            Appointment::getStartTime,
                            Comparator.nullsLast(
                                    Comparator.naturalOrder()
                            )
                    )

            );



            /*
             * =================================================
             * 5. STATISTICS
             * =================================================
             */

            int totalToday =
                    todayAppointments.size();


            int confirmedToday =
                    0;


            int rescheduledToday =
                    0;


            int cancelledToday =
                    0;


            int pendingToday =
                    0;



            /*
             * =================================================
             * COUNT STATUSES
             * =================================================
             */

            for (
                    Appointment appointment
                    : todayAppointments
            ) {


                String status =
                        appointment.getStatus();


                if (
                        status == null
                        || status.isBlank()
                ) {

                    continue;

                }


                /*
                 * Normalize status.
                 *
                 * Example:
                 *
                 * "confirmed"
                 * "Confirmed"
                 * " CONFIRMED "
                 *
                 * all become:
                 *
                 * CONFIRMED
                 */

                status =
                        status
                                .trim()
                                .toUpperCase();


                switch (status) {


                    case "CONFIRMED":

                        confirmedToday++;

                        break;



                    case "RESCHEDULED":

                        rescheduledToday++;

                        break;



                    case "CANCELLED":

                        cancelledToday++;

                        break;



                    case "CANCELED":

                        /*
                         * Support both spellings.
                         */

                        cancelledToday++;

                        break;



                    case "PENDING":

                        pendingToday++;

                        break;



                    default:

                        /*
                         * Unknown status.
                         *
                         * Do not crash the dashboard.
                         */

                        break;

                }

            }



            /*
             * =================================================
             * 6. PATIENT CACHE
             * =================================================
             *
             * Key:
             *
             *     patientId
             *
             * Value:
             *
             *     Patient object
             */

            Map<Integer, Patient> patients =
                    new HashMap<>();



            /*
             * =================================================
             * 7. DENTIST CACHE
             * =================================================
             */

            Map<Integer, Dentist> dentists =
                    new HashMap<>();



            /*
             * =================================================
             * 8. LOAD PATIENTS AND DENTISTS
             * =================================================
             */

            for (
                    Appointment appointment
                    : todayAppointments
            ) {


                /*
                 * ---------------------------------------------
                 * PATIENT
                 * ---------------------------------------------
                 */

                int patientId =
                        appointment.getPatientId();


                if (
                        patientId > 0
                        && !patients.containsKey(
                                patientId
                        )
                ) {


                    try {

                        Patient patient =
                                appointmentService.getPatient(
                                        patientId
                                );


                        if (patient != null) {

                            patients.put(
                                    patientId,
                                    patient
                            );

                        }

                    } catch (Exception patientException) {

                        /*
                         * Do not allow one missing patient
                         * record to destroy the dashboard.
                         */

                        patientException.printStackTrace();

                    }

                }



                /*
                 * ---------------------------------------------
                 * DENTIST
                 * ---------------------------------------------
                 */

                int dentistId =
                        appointment.getDentistId();


                if (
                        dentistId > 0
                        && !dentists.containsKey(
                                dentistId
                        )
                ) {


                    try {

                        Dentist dentist =
                                appointmentService.getDentist(
                                        dentistId
                                );


                        if (dentist != null) {

                            dentists.put(
                                    dentistId,
                                    dentist
                            );

                        }

                    } catch (Exception dentistException) {

                        dentistException.printStackTrace();

                    }

                }

            }



            /*
             * =================================================
             * 9. SEND DATA TO JSP
             * =================================================
             */

            request.setAttribute(
                    "todayAppointments",
                    todayAppointments
            );


            request.setAttribute(
                    "totalToday",
                    totalToday
            );


            request.setAttribute(
                    "confirmedToday",
                    confirmedToday
            );


            request.setAttribute(
                    "rescheduledToday",
                    rescheduledToday
            );


            request.setAttribute(
                    "cancelledToday",
                    cancelledToday
            );


            request.setAttribute(
                    "pendingToday",
                    pendingToday
            );


            request.setAttribute(
                    "todayDate",
                    todayDate
            );


            request.setAttribute(
                    "patients",
                    patients
            );


            request.setAttribute(
                    "dentists",
                    dentists
            );



            /*
             * =================================================
             * 10. CLEAR OLD ERROR
             * =================================================
             */

            request.removeAttribute(
                    "dashboardError"
            );



            /*
             * =================================================
             * 11. FORWARD TO JSP
             * =================================================
             */

            request.getRequestDispatcher(
                    "/reception/receptionDashboard.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {


            /*
             * =================================================
             * ERROR HANDLING
             * =================================================
             */

            e.printStackTrace();


            /*
             * Send a real error message to JSP.
             *
             * This is much better than silently displaying
             * zero appointments.
             */

            request.setAttribute(
                    "dashboardError",
                    "Unable to load dashboard information. "
                    + e.getClass().getSimpleName()
                    + ": "
                    + e.getMessage()
            );


            /*
             * Send empty values so JSP does not crash.
             */

            request.setAttribute(
                    "todayAppointments",
                    new ArrayList<Appointment>()
            );


            request.setAttribute(
                    "patients",
                    new HashMap<Integer, Patient>()
            );


            request.setAttribute(
                    "dentists",
                    new HashMap<Integer, Dentist>()
            );


            request.setAttribute(
                    "totalToday",
                    0
            );


            request.setAttribute(
                    "confirmedToday",
                    0
            );


            request.setAttribute(
                    "rescheduledToday",
                    0
            );


            request.setAttribute(
                    "cancelledToday",
                    0
            );


            request.setAttribute(
                    "pendingToday",
                    0
            );


            /*
             * Forward to dashboard.
             */

            request.getRequestDispatcher(
                    "/reception/receptionDashboard.jsp"
            ).forward(
                    request,
                    response
            );

        }

    }

}