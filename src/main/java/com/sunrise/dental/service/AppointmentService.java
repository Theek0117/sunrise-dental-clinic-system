package com.sunrise.dental.service;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.List;

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.dao.AppointmentDAOImpl;
import com.sunrise.dental.dao.DentistAvailabilityDAO;
import com.sunrise.dental.dao.DentistAvailabilityDAOImpl;
import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.model.Patient;

public class AppointmentService {

    private final AppointmentDAO appointmentDAO;
    private final PatientDAO patientDAO;
    private final DentistDAO dentistDAO;
    private final DentistAvailabilityDAO availabilityDAO;

    public AppointmentService() {

        appointmentDAO =
                new AppointmentDAOImpl();

        patientDAO =
                new PatientDAOImpl();

        dentistDAO =
                new DentistDAOImpl();

        availabilityDAO =
                new DentistAvailabilityDAOImpl();
    }

    public boolean bookAppointment(
            Appointment appointment) {

        if (appointment == null) {
            return false;
        }

        if (appointment.getPatientId() <= 0
                || appointment.getDentistId() <= 0
                || appointment.getAvailabilityId() <= 0) {

            return false;
        }

        if (appointment.getAppointmentDate() == null
                || appointment.getStartTime() == null
                || appointment.getEndTime() == null) {

            return false;
        }

        if (!isThirtyMinuteSlot(appointment)) {
            return false;
        }

        Patient patient =
                patientDAO.findById(
                        appointment.getPatientId()
                );

        if (patient == null
                || !"ACTIVE".equalsIgnoreCase(
                        patient.getStatus())) {

            return false;
        }

        Dentist dentist =
                dentistDAO.findById(
                        appointment.getDentistId()
                );

        if (dentist == null) {
            return false;
        }

        DentistAvailability availability =
                availabilityDAO.findById(
                        appointment.getAvailabilityId()
                );

        if (!validAvailability(
                appointment,
                availability)) {

            return false;
        }

        if (!isFutureSlot(
                appointment.getAppointmentDate(),
                appointment.getStartTime())) {

            return false;
        }

        int capacity =
                availability.getSlotCapacity();

        if (capacity <= 0) {
            return false;
        }

        int currentBookings =
                appointmentDAO.getSlotBookingCount(
                        appointment.getAvailabilityId(),
                        appointment.getAppointmentDate(),
                        appointment.getStartTime(),
                        appointment.getEndTime()
                );

        if (currentBookings >= capacity) {
            return false;
        }

        appointment.setAppointmentNumber(
                appointmentDAO.generateAppointmentNumber()
        );

        appointment.setStatus(
                "CONFIRMED"
        );

        return appointmentDAO.save(
                appointment
        );
    }

    public List<Appointment> getAllAppointments() {
        return appointmentDAO.findAll();
    }

    public List<Appointment> getActiveAppointments() {
        return appointmentDAO.findActiveAppointments();
    }

    public Appointment getAppointment(
            int appointmentId) {

        if (appointmentId <= 0) {
            return null;
        }

        return appointmentDAO.findById(
                appointmentId
        );
    }

    public boolean cancelAppointment(
            int appointmentId) {

        if (appointmentId <= 0) {
            return false;
        }

        Appointment appointment =
                appointmentDAO.findById(
                        appointmentId
                );

        if (appointment == null) {
            return false;
        }

        if (!isActiveStatus(
                appointment.getStatus())) {

            return false;
        }

        return appointmentDAO.cancelAppointment(
                appointmentId
        );
    }

    public boolean rescheduleAppointment(
            int appointmentId,
            int dentistId,
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime,
            String reason) {

        /*
         * ==========================================
         * GET EXISTING APPOINTMENT
         * ==========================================
         */

        Appointment existing =
                appointmentDAO.findById(
                        appointmentId
                );

        if (existing == null) {
            return false;
        }

        /*
         * ==========================================
         * CHECK STATUS
         * ==========================================
         */

        if (!isActiveStatus(
                existing.getStatus())) {

            return false;
        }

        /*
         * ==========================================
         * BASIC VALIDATION
         * ==========================================
         */

        if (dentistId <= 0
                || availabilityId <= 0
                || appointmentDate == null
                || startTime == null
                || endTime == null) {

            return false;
        }

        /*
         * ==========================================
         * MUST BE EXACTLY 30 MINUTES
         * ==========================================
         */

        long duration =
                endTime.getTime()
                - startTime.getTime();

        long minutes =
                duration / (60 * 1000);

        if (minutes != 30) {
            return false;
        }

        /*
         * ==========================================
         * CHECK DENTIST
         * ==========================================
         */

        Dentist dentist =
                dentistDAO.findById(
                        dentistId
                );

        if (dentist == null) {
            return false;
        }

        /*
         * ==========================================
         * CHECK AVAILABILITY
         * ==========================================
         */

        DentistAvailability availability =
                availabilityDAO.findById(
                        availabilityId
                );

        if (!validAvailability(
                dentistId,
                appointmentDate,
                startTime,
                endTime,
                availability)) {

            return false;
        }

        /*
         * ==========================================
         * CHECK FUTURE SLOT
         * ==========================================
         */

        if (!isFutureSlot(
                appointmentDate,
                startTime)) {

            return false;
        }

        /*
         * ==========================================
         * CAPACITY
         * ==========================================
         */

        int capacity =
                availability.getSlotCapacity();

        if (capacity <= 0) {
            return false;
        }

        /*
         * ==========================================
         * IMPORTANT
         *
         * Exclude the appointment currently being
         * rescheduled.
         * ==========================================
         */

        int currentBookings =
                appointmentDAO
                        .getSlotBookingCountExcludingAppointment(
                                availabilityId,
                                appointmentDate,
                                startTime,
                                endTime,
                                appointmentId
                        );

        if (currentBookings >= capacity) {
            return false;
        }

        /*
         * ==========================================
         * REASON
         * ==========================================
         */

        if (reason == null || reason.isBlank()) {
            reason = existing.getReason();
        }

        if (reason == null) {
            reason = "";
        }

        /*
         * ==========================================
         * UPDATE
         * ==========================================
         */

        return appointmentDAO.rescheduleAppointment(
                appointmentId,
                dentistId,
                availabilityId,
                appointmentDate,
                startTime,
                endTime,
                reason.trim()
        );
    }

    public Patient getPatient(
            int patientId) {

        if (patientId <= 0) {
            return null;
        }

        return patientDAO.findById(
                patientId
        );
    }

    public Dentist getDentist(
            int dentistId) {

        if (dentistId <= 0) {
            return null;
        }

        return dentistDAO.findById(
                dentistId
        );
    }

    private boolean isThirtyMinuteSlot(
            Appointment appointment) {

        long duration =
                appointment.getEndTime().getTime()
                - appointment.getStartTime().getTime();

        return duration / (60 * 1000) == 30;
    }

    private boolean validAvailability(
            Appointment appointment,
            DentistAvailability availability) {

        if (availability == null) {
            return false;
        }

        return validAvailability(
                appointment.getDentistId(),
                appointment.getAppointmentDate(),
                appointment.getStartTime(),
                appointment.getEndTime(),
                availability
        );
    }

    private boolean validAvailability(
            int dentistId,
            Date date,
            Time start,
            Time end,
            DentistAvailability availability) {

        if (availability == null) {
            return false;
        }

        /*
         * Dentist must match availability
         */

        if (availability.getDentistId()
                != dentistId) {

            return false;
        }

        /*
         * Date must match availability
         */

        if (availability.getAvailableDate() == null
                || !availability.getAvailableDate()
                        .equals(date)) {

            return false;
        }

        /*
         * Slot must be inside availability
         */

        if (start.before(
                availability.getStartTime())) {

            return false;
        }

        if (end.after(
                availability.getEndTime())) {

            return false;
        }

        /*
         * Slot must start on a 30-minute boundary
         * relative to the availability start.
         */

        int startMinutes =
                start.toLocalTime().getHour() * 60
                + start.toLocalTime().getMinute();

        int availabilityStartMinutes =
                availability.getStartTime()
                        .toLocalTime()
                        .getHour() * 60
                + availability.getStartTime()
                        .toLocalTime()
                        .getMinute();

        int relative =
                startMinutes
                - availabilityStartMinutes;

        return relative >= 0
                && relative % 30 == 0;
    }

    private boolean isFutureSlot(
            Date date,
            Time startTime) {

        LocalDateTime now =
                LocalDateTime.now();

        LocalDateTime slot =
                LocalDateTime.of(
                        date.toLocalDate(),
                        startTime.toLocalTime()
                );

        return slot.isAfter(now);
    }

    private boolean isActiveStatus(
            String status) {

        return "PENDING".equalsIgnoreCase(status)
                || "CONFIRMED".equalsIgnoreCase(status)
                || "RESCHEDULED".equalsIgnoreCase(status);
    }
    
    
    public List<Appointment> getDentistAppointmentsForDate(
            int dentistId,
            Date date) {

        if (dentistId <= 0 || date == null) {

            return List.of();
        }

        return appointmentDAO.findByDentistAndDate(
                dentistId,
                date
        );
    }
    
    public List<Appointment> getDentistAppointments(
            int dentistId) {

        if (dentistId <= 0) {

            return List.of();
        }

        return appointmentDAO.findByDentist(
                dentistId
        );
    }
    
    public Appointment getDentistAppointment(
            int appointmentId,
            int dentistId) {

        if (appointmentId <= 0
                || dentistId <= 0) {

            return null;
        }

        return appointmentDAO.findByIdAndDentist(
                appointmentId,
                dentistId
        );
    }
    
    public List<Appointment> getAppointmentsByDentistAndDate(
            int dentistId,
            Date appointmentDate) {

        if (dentistId <= 0 || appointmentDate == null) {
            return List.of();
        }

        return appointmentDAO.findByDentistAndDate(
                dentistId,
                appointmentDate
        );
    }
    
    public int countConfirmedAppointments(
            List<Appointment> appointments) {

        int count = 0;

        for (Appointment appointment : appointments) {

            if ("CONFIRMED".equalsIgnoreCase(
                    appointment.getStatus())) {

                count++;
            }
        }

        return count;
    }


    public int countCompletedAppointments(
            List<Appointment> appointments) {

        int count = 0;

        for (Appointment appointment : appointments) {

            if ("COMPLETED".equalsIgnoreCase(
                    appointment.getStatus())) {

                count++;
            }
        }

        return count;
    }


    public int countPendingAppointments(
            List<Appointment> appointments) {

        int count = 0;

        for (Appointment appointment : appointments) {

            if ("PENDING".equalsIgnoreCase(
                    appointment.getStatus())) {

                count++;
            }
        }

        return count;
    }
}