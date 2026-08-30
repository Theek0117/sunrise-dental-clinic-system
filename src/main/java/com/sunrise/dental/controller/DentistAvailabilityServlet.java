package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.service.DentistAvailabilityService;

@WebServlet("/reception/dentist-availability")
public class DentistAvailabilityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DentistAvailabilityService availabilityService;

    @Override
    public void init() {

        availabilityService =
                new DentistAvailabilityService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String dentistIdParameter =
                request.getParameter("dentistId");

        String dateParameter =
                request.getParameter("date");

        int dentistId = 0;

        if (dentistIdParameter != null
                && !dentistIdParameter.isBlank()) {

            try {
                dentistId =
                        Integer.parseInt(dentistIdParameter);

            } catch (NumberFormatException e) {
                dentistId = 0;
            }
        }

        LocalDate selectedDate =
                LocalDate.now();

        if (dateParameter != null
                && !dateParameter.isBlank()) {

            try {
                selectedDate =
                        LocalDate.parse(dateParameter);

            } catch (Exception e) {
                selectedDate =
                        LocalDate.now();
            }
        }

        List<DentistAvailability> availabilityList =
                List.of();

        if (dentistId > 0) {

            availabilityList =
                    availabilityService.getAvailability(
                            dentistId,
                            Date.valueOf(selectedDate)
                    );
        }

        request.setAttribute(
                "selectedDentistId",
                dentistId
        );

        request.setAttribute(
                "selectedDate",
                selectedDate.toString()
        );

        request.setAttribute(
                "availabilityList",
                availabilityList
        );

        request.getRequestDispatcher(
                "/reception/dentistAvailability.jsp"
        ).forward(request, response);
    }
}