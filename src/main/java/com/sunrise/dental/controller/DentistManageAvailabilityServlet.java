package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;
import java.util.List;

import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.service.DentistAvailabilityService;
import com.sunrise.dental.service.DentistService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dentist/availability")
public class DentistManageAvailabilityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DentistService dentistService;
    private DentistAvailabilityService availabilityService;

    @Override
    public void init() {

        dentistService = new DentistService();

        availabilityService =
                new DentistAvailabilityService();
    }

    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // -----------------------------------------------------
        // CHECK SESSION
        // -----------------------------------------------------

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // -----------------------------------------------------
        // CHECK ROLE
        // -----------------------------------------------------

        String role =
                (String) session.getAttribute("role");

        if (role == null
                || !"DENTIST".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // -----------------------------------------------------
        // GET STAFF ID
        // -----------------------------------------------------

        Integer staffId =
                (Integer) session.getAttribute("staffId");

        if (staffId == null || staffId <= 0) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // -----------------------------------------------------
        // FIND LOGGED-IN DENTIST
        // -----------------------------------------------------

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

        // -----------------------------------------------------
        // SELECTED DATE
        // -----------------------------------------------------

        LocalDate selectedDate =
                LocalDate.now();

        String dateParameter =
                request.getParameter("date");

        if (dateParameter != null
                && !dateParameter.isBlank()) {

            try {

                selectedDate =
                        LocalDate.parse(
                                dateParameter.trim()
                        );

            } catch (Exception e) {

                selectedDate =
                        LocalDate.now();
            }
        }

        // -----------------------------------------------------
        // PREVENT PAST DATE
        // -----------------------------------------------------

        if (selectedDate.isBefore(
                LocalDate.now())) {

            selectedDate =
                    LocalDate.now();
        }

        Date sqlDate =
                Date.valueOf(selectedDate);

        // -----------------------------------------------------
        // GET DENTIST AVAILABILITY
        // -----------------------------------------------------

        List<DentistAvailability> availabilityList =
                availabilityService.getAvailability(
                        dentistId,
                        sqlDate
                );

        if (availabilityList == null) {

            availabilityList =
                    Collections.emptyList();
        }

        // -----------------------------------------------------
        // SEND DATA TO JSP
        // -----------------------------------------------------

        request.setAttribute(
                "loggedInDentist",
                dentist
        );

        request.setAttribute(
                "selectedDate",
                sqlDate
        );

        request.setAttribute(
                "availabilityList",
                availabilityList
        );

        // -----------------------------------------------------
        // LOAD JSP
        // -----------------------------------------------------

        request.getRequestDispatcher(
                "/dentist/dentistAvailability.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // -----------------------------------------------------
        // CHECK SESSION
        // -----------------------------------------------------

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // -----------------------------------------------------
        // CHECK ROLE
        // -----------------------------------------------------

        String role =
                (String) session.getAttribute("role");

        if (role == null
                || !"DENTIST".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // -----------------------------------------------------
        // GET STAFF ID
        // -----------------------------------------------------

        Integer staffId =
                (Integer) session.getAttribute("staffId");

        if (staffId == null || staffId <= 0) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // -----------------------------------------------------
        // FIND LOGGED-IN DENTIST
        // -----------------------------------------------------

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

        // -----------------------------------------------------
        // GET FORM DATA
        // -----------------------------------------------------

        String dateParameter =
                request.getParameter("availableDate");

        String startTimeParameter =
                request.getParameter("startTime");

        String endTimeParameter =
                request.getParameter("endTime");

        // -----------------------------------------------------
        // VALIDATE DATE
        // -----------------------------------------------------

        if (dateParameter == null
                || dateParameter.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    "Please select an availability date."
            );

            return;
        }

        // -----------------------------------------------------
        // VALIDATE START TIME
        // -----------------------------------------------------

        if (startTimeParameter == null
                || startTimeParameter.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    "Please select a start time."
            );

            return;
        }

        // -----------------------------------------------------
        // VALIDATE END TIME
        // -----------------------------------------------------

        if (endTimeParameter == null
                || endTimeParameter.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    "Please select an end time."
            );

            return;
        }

        LocalDate availableDate;
        LocalTime startTime;
        LocalTime endTime;

        try {

            availableDate =
                    LocalDate.parse(
                            dateParameter.trim()
                    );

            startTime =
                    LocalTime.parse(
                            startTimeParameter.trim()
                    );

            endTime =
                    LocalTime.parse(
                            endTimeParameter.trim()
                    );

        } catch (Exception e) {

            redirectWithError(
                    request,
                    response,
                    "Invalid date or time selected."
            );

            return;
        }

        // -----------------------------------------------------
        // DATE CANNOT BE IN THE PAST
        // -----------------------------------------------------

        if (availableDate.isBefore(
                LocalDate.now())) {

            redirectWithError(
                    request,
                    response,
                    "Availability date cannot be in the past."
            );

            return;
        }

        // -----------------------------------------------------
        // END TIME MUST BE AFTER START TIME
        // -----------------------------------------------------

        if (!endTime.isAfter(startTime)) {

            redirectWithError(
                    request,
                    response,
                    "End time must be later than start time."
            );

            return;
        }

        // -----------------------------------------------------
        // CONVERT TO SQL TYPES
        // -----------------------------------------------------

        Date sqlDate =
                Date.valueOf(availableDate);

        Time sqlStartTime =
                Time.valueOf(startTime);

        Time sqlEndTime =
                Time.valueOf(endTime);

        // -----------------------------------------------------
        // CREATE AVAILABILITY
        // -----------------------------------------------------

        DentistAvailability availability =
                new DentistAvailability();

        availability.setDentistId(
                dentistId
        );

        availability.setAvailableDate(
                sqlDate
        );

        availability.setStartTime(
                sqlStartTime
        );

        availability.setEndTime(
                sqlEndTime
        );

        /*
         * Default slot capacity.
         *
         * The current JSP does not ask the dentist
         * to enter a capacity, so use 1.
         */
        availability.setSlotCapacity(1);

        availability.setStatus(
                "AVAILABLE"
        );

        // -----------------------------------------------------
        // SAVE
        // -----------------------------------------------------

        boolean saved =
                availabilityService.saveAvailability(
                        availability
                );

        if (saved) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/dentist/availability?date="
                    + availableDate
                    + "&success=1"
            );

            return;
        }

        // -----------------------------------------------------
        // SAVE FAILED
        // -----------------------------------------------------

        redirectWithError(
                request,
                response,
                "Unable to add availability. "
                + "The selected time may overlap "
                + "with an existing availability."
        );
    }

    // =========================================================
    // ERROR REDIRECT
    // =========================================================

    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        String date =
                request.getParameter("availableDate");

        if (date == null || date.isBlank()) {

            date =
                    LocalDate.now().toString();
        }

        response.sendRedirect(
                request.getContextPath()
                + "/dentist/availability?date="
                + date
                + "&error="
                + java.net.URLEncoder.encode(
                        message,
                        java.nio.charset.StandardCharsets.UTF_8
                )
        );
    }
}