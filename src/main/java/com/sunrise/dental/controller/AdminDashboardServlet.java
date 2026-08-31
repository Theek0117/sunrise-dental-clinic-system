package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
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
import com.sunrise.dental.service.PatientService;
import com.sunrise.dental.service.StaffService;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientService patientService;
    private DentistService dentistService;
    private AppointmentService appointmentService;
    private StaffService staffService;

    @Override
    public void init() {

        patientService = new PatientService();
        dentistService = new DentistService();
        appointmentService = new AppointmentService();
        staffService = new StaffService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        /*
         * ==========================================
         * BASIC DASHBOARD COUNTS
         * ==========================================
         */

        List<Patient> patients =
                patientService.getAllPatients();

        List<Dentist> dentists =
                dentistService.getActiveDentists();

        List<Appointment> appointments =
                appointmentService.getAllAppointments();

        /*
         * ==========================================
         * STAFF
         * ==========================================
         */

        int totalStaff =
                staffService.getTotalStaff();

        int activeStaff =
                staffService.getActiveStaffCount();

        /*
         * ==========================================
         * PATIENT COUNT
         * ==========================================
         */

        int totalPatients =
                patients.size();

        /*
         * ==========================================
         * DENTIST COUNT
         * ==========================================
         */

        int activeDentists =
                dentists.size();

        /*
         * ==========================================
         * TODAY'S APPOINTMENTS
         * ==========================================
         */

        Date today =
                Date.valueOf(
                        LocalDate.now()
                );

        List<Appointment> todayAppointments =
                appointments.stream()
                        .filter(appointment ->
                                today.equals(
                                        appointment.getAppointmentDate()
                                )
                        )
                        .toList();

        /*
         * ==========================================
         * APPOINTMENT STATISTICS
         * ==========================================
         */

        int todayConfirmed = 0;
        int todayCompleted = 0;
        int todayPending = 0;

        for (Appointment appointment
                : todayAppointments) {

            String status =
                    appointment.getStatus();

            if ("CONFIRMED".equalsIgnoreCase(status)) {

                todayConfirmed++;

            } else if ("COMPLETED".equalsIgnoreCase(status)) {

                todayCompleted++;

            } else if ("PENDING".equalsIgnoreCase(status)) {

                todayPending++;
            }
        }

        /*
         * ==========================================
         * PATIENT NAME MAP
         * ==========================================
         */

        Map<Integer, String> patientNames =
                new HashMap<>();

        for (Patient patient : patients) {

            patientNames.put(
                    patient.getPatientId(),
                    patient.getName()
            );
        }

        /*
         * ==========================================
         * DENTIST NAME MAP
         * ==========================================
         */

        Map<Integer, String> dentistNames =
                new HashMap<>();

        for (Dentist dentist : dentists) {

            dentistNames.put(
                    dentist.getDentistId(),
                    dentist.getName()
            );
        }

        /*
         * ==========================================
         * SEND DATA TO JSP
         * ==========================================
         */

        request.setAttribute(
                "totalPatients",
                totalPatients
        );

        request.setAttribute(
                "activeDentists",
                activeDentists
        );

        request.setAttribute(
                "totalStaff",
                totalStaff
        );

        request.setAttribute(
                "activeStaff",
                activeStaff
        );

        request.setAttribute(
                "todayAppointments",
                todayAppointments
        );

        request.setAttribute(
                "todayConfirmed",
                todayConfirmed
        );

        request.setAttribute(
                "todayCompleted",
                todayCompleted
        );

        request.setAttribute(
                "todayPending",
                todayPending
        );

        request.setAttribute(
                "patientNames",
                patientNames
        );

        request.setAttribute(
                "dentistNames",
                dentistNames
        );

        request.setAttribute(
                "today",
                today
        );

        /*
         * ==========================================
         * FORWARD TO JSP
         * ==========================================
         */

        request.getRequestDispatcher(
                "/admin/adminDashboard.jsp"
        ).forward(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}