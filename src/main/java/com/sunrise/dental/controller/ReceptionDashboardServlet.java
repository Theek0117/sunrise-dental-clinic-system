package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
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

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.dao.AppointmentDAOImpl;
import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.DentistAvailabilityService;
import com.sunrise.dental.service.DentistService;

@WebServlet("/reception/dashboard")
public class ReceptionDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private DentistService dentistService;
    private DentistAvailabilityService availabilityService;

    @Override
    public void init() {

        appointmentDAO =
                new AppointmentDAOImpl();

        patientDAO =
                new PatientDAOImpl();

        dentistService =
                new DentistService();

        availabilityService =
                new DentistAvailabilityService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            /*
             * ==========================================
             * CURRENT DATE
             * ==========================================
             */

            LocalDate today =
                    LocalDate.now();

            Date sqlToday =
                    Date.valueOf(today);


            /*
             * ==========================================
             * GET ALL APPOINTMENTS
             * ==========================================
             */

            List<Appointment> allAppointments =
                    appointmentDAO.findAll();


            /*
             * ==========================================
             * TODAY'S APPOINTMENTS
             * ==========================================
             */

            List<Appointment> todayAppointments =
                    new ArrayList<>();

            int confirmedCount = 0;

            for (Appointment appointment
                    : allAppointments) {

                if (appointment.getAppointmentDate() == null) {
                    continue;
                }

                if (!appointment.getAppointmentDate()
                        .equals(sqlToday)) {
                    continue;
                }

                todayAppointments.add(appointment);

                if ("CONFIRMED".equalsIgnoreCase(
                        appointment.getStatus())) {

                    confirmedCount++;
                }
            }


            /*
             * ==========================================
             * SORT TODAY'S APPOINTMENTS
             * ==========================================
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
             * ==========================================
             * TOTAL PATIENTS
             * ==========================================
             */

            List<Patient> activePatients =
                    patientDAO.findAllActive();

            int totalPatients =
                    activePatients != null
                            ? activePatients.size()
                            : 0;


            /*
             * ==========================================
             * AVAILABLE APPOINTMENT SLOTS TODAY
             * ==========================================
             *
             * Count each available 30-minute slot
             * that still has capacity.
             */

            int availableSlots =
                    calculateAvailableSlotsToday(
                            today
                    );


            /*
             * ==========================================
             * PATIENT CACHE
             * ==========================================
             */

            Map<Integer, Patient> patients =
                    new HashMap<>();

            /*
             * ==========================================
             * DENTIST CACHE
             * ==========================================
             */

            Map<Integer, Dentist> dentists =
                    new HashMap<>();


            /*
             * ==========================================
             * LOAD PATIENT + DENTIST DETAILS
             * ==========================================
             */

            for (Appointment appointment
                    : todayAppointments) {

                int patientId =
                        appointment.getPatientId();

                int dentistId =
                        appointment.getDentistId();


                /*
                 * Patient
                 */

                if (!patients.containsKey(patientId)) {

                    Patient patient =
                            patientDAO.findById(
                                    patientId
                            );

                    if (patient != null) {

                        patients.put(
                                patientId,
                                patient
                        );
                    }
                }


                /*
                 * Dentist
                 */

                if (!dentists.containsKey(dentistId)) {

                    Dentist dentist =
                            dentistService.getDentistById(
                                    dentistId
                            );

                    if (dentist != null) {

                        dentists.put(
                                dentistId,
                                dentist
                        );
                    }
                }
            }


            /*
             * ==========================================
             * DASHBOARD ATTRIBUTES
             * ==========================================
             */

            request.setAttribute(
                    "todayAppointments",
                    todayAppointments
            );

            request.setAttribute(
                    "patients",
                    patients
            );

            request.setAttribute(
                    "dentists",
                    dentists
            );

            request.setAttribute(
                    "todayAppointmentCount",
                    todayAppointments.size()
            );

            request.setAttribute(
                    "confirmedAppointmentCount",
                    confirmedCount
            );

            request.setAttribute(
                    "availableSlotCount",
                    availableSlots
            );

            request.setAttribute(
                    "totalPatientCount",
                    totalPatients
            );

            request.setAttribute(
                    "dashboardDate",
                    sqlToday.toString()
            );


            /*
             * ==========================================
             * FORWARD TO DASHBOARD
             * ==========================================
             */

            request.getRequestDispatcher(
                    "/reception/receptionDashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            /*
             * Prevent dashboard from completely
             * crashing if one database operation fails.
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
                    "todayAppointmentCount",
                    0
            );

            request.setAttribute(
                    "confirmedAppointmentCount",
                    0
            );

            request.setAttribute(
                    "availableSlotCount",
                    0
            );

            request.setAttribute(
                    "totalPatientCount",
                    0
            );

            request.getRequestDispatcher(
                    "/reception/receptionDashboard.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }


    /*
     * =========================================================
     * CALCULATE TODAY'S AVAILABLE SLOTS
     * =========================================================
     */

    private int calculateAvailableSlotsToday(
            LocalDate today) {

        int availableSlots = 0;

        LocalTime now =
                LocalTime.now();

        try {

            /*
             * Get all active dentists.
             */

            List<Dentist> dentists =
                    dentistService.getActiveDentists();

            if (dentists == null
                    || dentists.isEmpty()) {

                return 0;
            }


            /*
             * Check every active dentist.
             */

            for (Dentist dentist : dentists) {

                if (dentist == null) {
                    continue;
                }

                List<DentistAvailability> availabilityList =
                        availabilityService.getAvailability(
                                dentist.getDentistId(),
                                Date.valueOf(today)
                        );

                if (availabilityList == null
                        || availabilityList.isEmpty()) {

                    continue;
                }


                /*
                 * Check every availability period.
                 */

                for (DentistAvailability availability
                        : availabilityList) {

                    if (availability == null
                            || availability.getStartTime() == null
                            || availability.getEndTime() == null) {

                        continue;
                    }

                    LocalTime slotStart =
                            availability
                                    .getStartTime()
                                    .toLocalTime();

                    LocalTime availabilityEnd =
                            availability
                                    .getEndTime()
                                    .toLocalTime();


                    /*
                     * Create 30-minute slots.
                     */

                    while (
                            slotStart
                                    .plusMinutes(30)
                                    .compareTo(
                                            availabilityEnd
                                    ) <= 0
                    ) {

                        LocalTime slotEnd =
                                slotStart.plusMinutes(30);


                        /*
                         * Ignore slots that have already
                         * started.
                         */

                        if (slotStart.isAfter(now)) {

                            Time sqlStart =
                                    Time.valueOf(
                                            slotStart
                                    );

                            Time sqlEnd =
                                    Time.valueOf(
                                            slotEnd
                                    );


                            /*
                             * Get existing bookings.
                             */

                            int bookedCount =
                                    appointmentDAO
                                            .getSlotBookingCount(
                                                    availability
                                                            .getAvailabilityId(),
                                                    Date.valueOf(today),
                                                    sqlStart,
                                                    sqlEnd
                                            );


                            /*
                             * Check capacity.
                             */

                            int capacity =
                                    availability
                                            .getSlotCapacity();


                            if (capacity > bookedCount) {

                                availableSlots++;
                            }
                        }


                        /*
                         * Move to next 30-minute slot.
                         */

                        slotStart =
                                slotEnd;
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return availableSlots;
    }
}