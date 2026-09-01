package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@WebServlet({"/admin/dentist-slots", "/admin/view-dentist-slots"})
public class AdminDentistTimeSlotsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DentistAvailabilityService availabilityService;
    private DentistService dentistService;

    @Override
    public void init() {
        availabilityService = new DentistAvailabilityService();
        dentistService = new DentistService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Dentist> dentists = dentistService.getActiveDentists();
        Map<Integer, Dentist> dentistMap = new HashMap<>();
        for (Dentist d : dentists) {
            dentistMap.put(d.getDentistId(), d);
        }

        List<DentistAvailability> allSlots = availabilityService.getAllAvailability();

        // Optional filtering by dentist ID
        String dentistIdParam = request.getParameter("dentistId");
        Integer filterDentistId = null;
        if (dentistIdParam != null && !dentistIdParam.isBlank()) {
            try {
                filterDentistId = Integer.parseInt(dentistIdParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        // Optional filtering by date
        String dateParam = request.getParameter("date");
        Date filterDate = null;
        if (dateParam != null && !dateParam.isBlank()) {
            try {
                filterDate = Date.valueOf(LocalDate.parse(dateParam.trim()));
            } catch (Exception ignored) {}
        }

        List<DentistAvailability> filteredSlots = allSlots;
        if (filterDentistId != null || filterDate != null) {
            final Integer finalDentistId = filterDentistId;
            final Date finalDate = filterDate;
            filteredSlots = allSlots.stream().filter(slot -> {
                boolean match = true;
                if (finalDentistId != null && finalDentistId > 0) {
                    match = match && (slot.getDentistId() == finalDentistId);
                }
                if (finalDate != null) {
                    match = match && finalDate.equals(slot.getAvailableDate());
                }
                return match;
            }).toList();
        }

        request.setAttribute("availabilityList", filteredSlots);
        request.setAttribute("dentists", dentists);
        request.setAttribute("dentistMap", dentistMap);
        request.setAttribute("selectedDentistId", filterDentistId);
        request.setAttribute("selectedDate", dateParam);

        request.getRequestDispatcher("/admin/viewDentistSlots.jsp").forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
