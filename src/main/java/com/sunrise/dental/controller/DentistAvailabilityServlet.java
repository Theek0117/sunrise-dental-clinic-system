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

        String ajaxParameter =
                request.getParameter("ajax");

        int dentistId = 0;

        /*
         * ==========================================
         * DENTIST ID
         * ==========================================
         */

        if (dentistIdParameter != null
                && !dentistIdParameter.isBlank()) {

            try {

                dentistId =
                        Integer.parseInt(
                                dentistIdParameter
                        );

            } catch (NumberFormatException e) {

                dentistId = 0;
            }
        }

        /*
         * ==========================================
         * DATE
         * ==========================================
         */

        LocalDate selectedDate =
                LocalDate.now();

        if (dateParameter != null
                && !dateParameter.isBlank()) {

            try {

                selectedDate =
                        LocalDate.parse(
                                dateParameter
                        );

            } catch (Exception e) {

                selectedDate =
                        LocalDate.now();
            }
        }

        /*
         * ==========================================
         * GET AVAILABILITY
         * ==========================================
         */

        List<DentistAvailability> availabilityList =
                List.of();

        if (dentistId > 0) {

            availabilityList =
                    availabilityService.getAvailability(
                            dentistId,
                            Date.valueOf(selectedDate)
                    );
        }

        /*
         * ==========================================
         * AJAX REQUEST
         * ==========================================
         *
         * The booking page expects JSON.
         *
         * Example:
         *
         * [
         *   {
         *      "availabilityId":1,
         *      "dentistId":1,
         *      "availableDate":"2026-09-01",
         *      "startTime":"09:00:00",
         *      "endTime":"12:00:00",
         *      "status":"AVAILABLE"
         *   }
         * ]
         *
         */

        if ("true".equalsIgnoreCase(ajaxParameter)) {

            response.setContentType(
                    "application/json"
            );

            response.setCharacterEncoding(
                    "UTF-8"
            );

            StringBuilder json =
                    new StringBuilder();

            json.append("[");

            for (int i = 0;
                 i < availabilityList.size();
                 i++) {

                DentistAvailability availability =
                        availabilityList.get(i);

                if (i > 0) {
                    json.append(",");
                }

                json.append("{");

                json.append("\"availabilityId\":")
                        .append(
                                availability.getAvailabilityId()
                        );

                json.append(",");

                json.append("\"dentistId\":")
                        .append(
                                availability.getDentistId()
                        );

                json.append(",");

                json.append("\"availableDate\":\"")
                        .append(
                                availability.getAvailableDate()
                                        .toLocalDate()
                        )
                        .append("\"");

                json.append(",");

                json.append("\"startTime\":\"")
                        .append(
                                availability.getStartTime()
                        )
                        .append("\"");

                json.append(",");

                json.append("\"endTime\":\"")
                        .append(
                                availability.getEndTime()
                        )
                        .append("\"");

                json.append(",");

                json.append("\"status\":\"")
                        .append(
                                escapeJson(
                                        availability.getStatus()
                                )
                        )
                        .append("\"");

                json.append("}");
            }

            json.append("]");

            response.getWriter().write(
                    json.toString()
            );

            return;
        }

        /*
         * ==========================================
         * NORMAL JSP REQUEST
         * ==========================================
         *
         * Keep this for direct browser access.
         *
         */

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
        ).forward(
                request,
                response
        );
    }

    /*
     * ==========================================
     * JSON ESCAPE
     * ==========================================
     */

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}