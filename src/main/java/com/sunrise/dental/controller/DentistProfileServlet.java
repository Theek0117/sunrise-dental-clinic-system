package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.DentistAvailabilityService;
import com.sunrise.dental.service.DentistService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/dentist/profile", "/dentist/myProfile"})
public class DentistProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DentistService dentistService;
    private DentistAvailabilityService availabilityService;
    private AppointmentService appointmentService;

    @Override
    public void init() {
        dentistService = new DentistService();
        availabilityService = new DentistAvailabilityService();
        appointmentService = new AppointmentService();
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
        if (role == null || !"DENTIST".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer staffId = (Integer) session.getAttribute("staffId");
        Dentist dentist = dentistService.getDentistByStaffId(staffId);

        if (dentist == null) {
            // Fallback lookup by name
            String staffName = (String) session.getAttribute("staffName");
            if (staffName != null && !staffName.isBlank()) {
                List<Dentist> allDentists = dentistService.getActiveDentists();
                for (Dentist d : allDentists) {
                    if (d != null && d.getName() != null && d.getName().equalsIgnoreCase(staffName.trim())) {
                        dentist = d;
                        break;
                    }
                }
            }
        }

        if (dentist != null) {
            Date today = Date.valueOf(LocalDate.now());
            List<DentistAvailability> upcomingAvailability = availabilityService.getAvailability(dentist.getDentistId(), today);
            List<Appointment> allAppointments = appointmentService.getDentistAppointments(dentist.getDentistId());

            request.setAttribute("loggedInDentist", dentist);
            request.setAttribute("upcomingAvailability", upcomingAvailability);
            request.setAttribute("totalAppointmentsCount", allAppointments != null ? allAppointments.size() : 0);
        }

        request.getRequestDispatcher("/dentist/myProfile.jsp").forward(request, response);
    }
}
