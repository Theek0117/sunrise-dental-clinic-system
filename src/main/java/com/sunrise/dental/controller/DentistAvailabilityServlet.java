package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.dao.AppointmentDAOImpl;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.DentistAvailabilityService;

@WebServlet("/reception/dentist-availability")
public class DentistAvailabilityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DentistAvailabilityService availabilityService;
    private AppointmentDAO appointmentDAO;
    private AppointmentService appointmentService;

    @Override
    public void init() {

        availabilityService =
                new DentistAvailabilityService();

        appointmentDAO =
                new AppointmentDAOImpl();

        appointmentService =
                new AppointmentService();
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

        String appointmentIdParameter =
                request.getParameter("appointmentId");

        String ajaxParameter =
                request.getParameter("ajax");

        /*
         * ==========================================
         * DENTIST ID
         * ==========================================
         */

        int dentistId = 0;

        if (dentistIdParameter != null
                && !dentistIdParameter.isBlank()) {

            try {

                dentistId =
                        Integer.parseInt(
                                dentistIdParameter.trim()
                        );

            } catch (NumberFormatException e) {

                dentistId = 0;
            }
        }

        /*
         * ==========================================
         * APPOINTMENT ID
         *
         * During rescheduling we exclude the
         * current appointment from the count.
         * ==========================================
         */

        int appointmentId = 0;

        if (appointmentIdParameter != null
                && !appointmentIdParameter.isBlank()) {

            try {

                appointmentId =
                        Integer.parseInt(
                                appointmentIdParameter.trim()
                        );

            } catch (NumberFormatException e) {

                appointmentId = 0;
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
                                dateParameter.trim()
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
         * AJAX RESPONSE
         * ==========================================
         */

        if ("true".equalsIgnoreCase(
                ajaxParameter)) {

            response.setContentType(
                    "application/json"
            );

            response.setCharacterEncoding(
                    "UTF-8"
            );

            StringBuilder json =
                    new StringBuilder();

            json.append("[");

            boolean firstSlot = true;

            /*
             * ==========================================
             * DENTIST ROOM
             * ==========================================
             */

            Dentist dentist =
                    appointmentService.getDentist(
                            dentistId
                    );

            String roomNumber =
                    dentist != null
                            ? dentist.getRoomNumber()
                            : "";

            /*
             * ==========================================
             * CREATE 30 MINUTE SLOTS
             * ==========================================
             */

            for (DentistAvailability availability
                    : availabilityList) {

                LocalTime slotStart =
                        availability
                                .getStartTime()
                                .toLocalTime();

                LocalTime availabilityEnd =
                        availability
                                .getEndTime()
                                .toLocalTime();

                while (
                        slotStart
                                .plusMinutes(30)
                                .compareTo(
                                        availabilityEnd
                                ) <= 0
                ) {

                    LocalTime slotEnd =
                            slotStart.plusMinutes(30);

                    Time sqlStartTime =
                            Time.valueOf(
                                    slotStart
                            );

                    Time sqlEndTime =
                            Time.valueOf(
                                    slotEnd
                            );

                    /*
                     * ======================================
                     * BOOKING COUNT
                     *
                     * Exclude the current appointment
                     * while rescheduling.
                     * ======================================
                     */

                    int bookedCount;

                    if (appointmentId > 0) {

                        bookedCount =
                                appointmentDAO
                                        .getSlotBookingCountExcludingAppointment(
                                                availability
                                                        .getAvailabilityId(),
                                                Date.valueOf(
                                                        selectedDate
                                                ),
                                                sqlStartTime,
                                                sqlEndTime,
                                                appointmentId
                                        );

                    } else {

                        bookedCount =
                                appointmentDAO
                                        .getSlotBookingCount(
                                                availability
                                                        .getAvailabilityId(),
                                                Date.valueOf(
                                                        selectedDate
                                                ),
                                                sqlStartTime,
                                                sqlEndTime
                                        );
                    }

                    /*
                     * ======================================
                     * CAPACITY
                     * ======================================
                     */

                    int capacity =
                            availability
                                    .getSlotCapacity();

                    boolean full =
                            capacity <= 0
                            || bookedCount >= capacity;

                    /*
                     * ======================================
                     * PAST SLOT
                     * ======================================
                     */

                    boolean past = false;

                    if (selectedDate.equals(
                            LocalDate.now())) {

                        LocalTime now =
                                LocalTime.now();

                        past =
                                !slotStart.isAfter(now);
                    }

                    /*
                     * ======================================
                     * JSON
                     * ======================================
                     */

                    if (!firstSlot) {
                        json.append(",");
                    }

                    firstSlot = false;

                    json.append("{");

                    json.append(
                            "\"availabilityId\":"
                    ).append(
                            availability
                                    .getAvailabilityId()
                    );

                    json.append(",");

                    json.append(
                            "\"dentistId\":"
                    ).append(
                            availability
                                    .getDentistId()
                    );

                    json.append(",");

                    json.append(
                            "\"availableDate\":\""
                    ).append(
                            availability
                                    .getAvailableDate()
                    ).append("\"");

                    json.append(",");

                    json.append(
                            "\"startTime\":\""
                    ).append(
                            sqlStartTime
                    ).append("\"");

                    json.append(",");

                    json.append(
                            "\"endTime\":\""
                    ).append(
                            sqlEndTime
                    ).append("\"");

                    json.append(",");

                    json.append(
                            "\"slotCapacity\":"
                    ).append(
                            capacity
                    );

                    json.append(",");

                    json.append(
                            "\"bookedCount\":"
                    ).append(
                            bookedCount
                    );

                    json.append(",");

                    json.append(
                            "\"remainingCapacity\":"
                    ).append(
                            Math.max(
                                    capacity - bookedCount,
                                    0
                            )
                    );

                    json.append(",");

                    json.append(
                            "\"full\":"
                    ).append(
                            full
                    );

                    json.append(",");

                    json.append(
                            "\"past\":"
                    ).append(
                            past
                    );

                    json.append(",");

                    json.append(
                            "\"roomNumber\":\""
                    ).append(
                            escapeJson(roomNumber)
                    ).append("\"");

                    json.append(",");

                    json.append(
                            "\"status\":\""
                    ).append(
                            escapeJson(
                                    availability.getStatus()
                            )
                    ).append("\"");

                    json.append("}");

                    slotStart =
                            slotEnd;
                }
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