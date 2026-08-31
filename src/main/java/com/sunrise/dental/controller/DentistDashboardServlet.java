package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.DentistService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dentist/dashboard")
public class DentistDashboardServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private DentistService dentistService;

    @Override
    public void init() {

        appointmentService =
                new AppointmentService();

        dentistService =
                new DentistService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        Integer staffId =
                (Integer) session.getAttribute(
                        "staffId"
                );

        if (staffId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        /*
         * Resolve the authenticated staff account
         * to its dentist record.
         */
        Dentist dentist =
                dentistService.getDentistByStaffId(
                        staffId
                );

        if (dentist == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Dentist profile could not be found."
            );

            return;
        }

        int dentistId =
                dentist.getDentistId();

        Date today =
                Date.valueOf(
                        LocalDate.now()
                );

        /*
         * ONLY this dentist's appointments.
         */
        List<Appointment> todayAppointments =
                appointmentService
                        .getDentistAppointmentsForDate(
                                dentistId,
                                today
                        );

        List<Appointment> allDentistAppointments =
                appointmentService
                        .getDentistAppointments(
                                dentistId
                        );

        /*
         * Load patients referenced by today's
         * appointment list.
         */
        Map<Integer, Patient> patients =
                new LinkedHashMap<>();

        for (Appointment appointment
                : todayAppointments) {

            int patientId =
                    appointment.getPatientId();

            if (!patients.containsKey(
                    patientId)) {

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
            }
        }

        /*
         * Dashboard statistics.
         */
        int todayAppointmentCount =
                todayAppointments.size();

        int confirmedCount = 0;
        int completedCount = 0;

        for (Appointment appointment
                : todayAppointments) {

            String status =
                    appointment.getStatus();

            if ("CONFIRMED".equalsIgnoreCase(
                    status)) {

                confirmedCount++;
            }

            if ("COMPLETED".equalsIgnoreCase(
                    status)) {

                completedCount++;
            }
        }

        /*
         * Unique patients associated with this
         * dentist across their appointments.
         */
        long myPatientCount =
                allDentistAppointments
                        .stream()
                        .map(
                            Appointment::getPatientId
                        )
                        .distinct()
                        .count();

        /*
         * Data for JSP.
         */
        request.setAttribute(
                "dentist",
                dentist
        );

        request.setAttribute(
                "todayAppointments",
                todayAppointments
        );

        request.setAttribute(
                "patients",
                patients
        );

        request.setAttribute(
                "todayAppointmentCount",
                todayAppointmentCount
        );

        request.setAttribute(
                "confirmedAppointmentCount",
                confirmedCount
        );

        request.setAttribute(
                "completedAppointmentCount",
                completedCount
        );

        request.setAttribute(
                "myPatientCount",
                myPatientCount
        );

        request.getRequestDispatcher(
                "/dentist/dentistDashboard.jsp"
        ).forward(
                request,
                response
        );
    }
}