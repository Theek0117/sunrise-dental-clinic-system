package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
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
import com.sunrise.dental.service.DentistService;

@WebServlet("/dentist/appointments")
public class DentistDailyAppointmentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private DentistService dentistService;

    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ISO_LOCAL_DATE;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        dentistService = new DentistService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * =====================================================
         * SESSION VALIDATION
         * =====================================================
         */

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }


        /*
         * =====================================================
         * GET LOGGED-IN STAFF ID
         * =====================================================
         */

        Object staffIdObject =
                session.getAttribute("staffId");

        int staffId;

        if (staffIdObject instanceof Integer) {

            staffId = (Integer) staffIdObject;

        } else {

            try {

                staffId = Integer.parseInt(
                        String.valueOf(staffIdObject)
                );

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath() + "/login.jsp"
                );

                return;
            }
        }

        if (staffId <= 0) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }


        /*
         * =====================================================
         * FIND LOGGED-IN DENTIST
         * =====================================================
         */

        Dentist dentist =
                dentistService.getDentistByStaffId(staffId);

        if (dentist == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Dentist profile could not be found."
            );

            return;
        }


        /*
         * =====================================================
         * SELECTED DATE
         *
         * No date parameter:
         *     Show today.
         *
         * date=2026-09-05:
         *     Show September 5, 2026.
         *
         * Invalid date:
         *     Return HTTP 400 instead of silently
         *     changing the requested date to today.
         * =====================================================
         */

        String dateParameter =
                request.getParameter("date");

        LocalDate selectedLocalDate;

        if (dateParameter == null
                || dateParameter.isBlank()) {

            selectedLocalDate = LocalDate.now();

        } else {

            dateParameter = dateParameter.trim();

            try {

                selectedLocalDate =
                        LocalDate.parse(
                                dateParameter,
                                DATE_FORMATTER
                        );

            } catch (DateTimeParseException e) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid appointment date. "
                        + "Please use the format yyyy-MM-dd."
                );

                return;
            }
        }


        /*
         * =====================================================
         * CONVERT LOCAL DATE TO SQL DATE
         * =====================================================
         */

        Date selectedDate =
                Date.valueOf(selectedLocalDate);


        /*
         * =====================================================
         * GET APPOINTMENTS
         *
         * IMPORTANT:
         * This uses the selected date, not always today.
         * =====================================================
         */

        List<Appointment> appointments =
                appointmentService
                        .getAppointmentsByDentistAndDate(
                                dentist.getDentistId(),
                                selectedDate
                        );


        /*
         * =====================================================
         * LOAD PATIENTS
         * =====================================================
         */

        Map<Integer, Patient> patients =
                new HashMap<>();

        for (Appointment appointment : appointments) {

            Patient patient =
                    appointmentService.getPatient(
                            appointment.getPatientId()
                    );

            if (patient != null) {

                patients.put(
                        patient.getPatientId(),
                        patient
                );
            }
        }


        /*
         * =====================================================
         * STATISTICS
         *
         * Statistics are also based on the selected date.
         * =====================================================
         */

        int appointmentCount =
                appointments.size();

        int confirmedCount =
                appointmentService
                        .countConfirmedAppointments(
                                appointments
                        );

        int pendingCount =
                appointmentService
                        .countPendingAppointments(
                                appointments
                        );

        int completedCount =
                appointmentService
                        .countCompletedAppointments(
                                appointments
                        );


        /*
         * =====================================================
         * SEND DATA TO JSP
         * =====================================================
         */

        request.setAttribute(
                "loggedInDentist",
                dentist
        );

        request.setAttribute(
                "selectedDate",
                selectedDate
        );

        /*
         * IMPORTANT:
         * This exact yyyy-MM-dd value is placed into
         * the HTML date input.
         */

        request.setAttribute(
                "selectedLocalDate",
                selectedLocalDate.format(DATE_FORMATTER)
        );

        request.setAttribute(
                "appointments",
                appointments
        );

        request.setAttribute(
                "patients",
                patients
        );

        request.setAttribute(
                "appointmentCount",
                appointmentCount
        );

        request.setAttribute(
                "confirmedCount",
                confirmedCount
        );

        request.setAttribute(
                "pendingCount",
                pendingCount
        );

        request.setAttribute(
                "completedCount",
                completedCount
        );


        /*
         * =====================================================
         * FORWARD TO JSP
         * =====================================================
         */

        request.getRequestDispatcher(
                "/dentist/dailyAppointments.jsp"
        ).forward(
                request,
                response
        );
    }
}