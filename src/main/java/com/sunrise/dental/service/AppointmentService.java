package com.sunrise.dental.service;

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

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.patientDAO =
                new PatientDAOImpl();

        this.dentistDAO =
                new DentistDAOImpl();

        this.availabilityDAO =
                new DentistAvailabilityDAOImpl();
    }

    public boolean bookAppointment(
            Appointment appointment) {

        if (appointment == null) {
            return false;
        }

        if (appointment.getPatientId() <= 0) {
            return false;
        }

        if (appointment.getDentistId() <= 0) {
            return false;
        }

        if (appointment.getAvailabilityId() <= 0) {
            return false;
        }

        if (appointment.getAppointmentDate() == null) {
            return false;
        }

        if (appointment.getStartTime() == null
                || appointment.getEndTime() == null) {

            return false;
        }

        /*
         * ==========================================
         * TIME VALIDATION
         * ==========================================
         */

        if (!appointment.getStartTime()
                .before(
                        appointment.getEndTime()
                )) {

            return false;
        }

        /*
         * ==========================================
         * VERIFY PATIENT
         * ==========================================
         */

        Patient patient =
                patientDAO.findById(
                        appointment.getPatientId()
                );

        if (patient == null) {
            return false;
        }

        if (!"ACTIVE".equalsIgnoreCase(
                patient.getStatus()
        )) {

            return false;
        }

        /*
         * ==========================================
         * VERIFY DENTIST
         * ==========================================
         */

        Dentist dentist =
                dentistDAO.findById(
                        appointment.getDentistId()
                );

        if (dentist == null) {
            return false;
        }

        /*
         * ==========================================
         * VERIFY AVAILABILITY
         * ==========================================
         */

        DentistAvailability availability =
                availabilityDAO.findById(
                        appointment.getAvailabilityId()
                );

        if (availability == null) {
            return false;
        }

        /*
         * Availability must belong
         * to selected dentist.
         */

        if (availability.getDentistId()
                != appointment.getDentistId()) {

            return false;
        }

        /*
         * ==========================================
         * VERIFY DATE
         * ==========================================
         */

        if (!availability.getAvailableDate()
                .equals(
                        appointment.getAppointmentDate()
                )) {

            return false;
        }

        /*
         * ==========================================
         * VERIFY TIME RANGE
         * ==========================================
         */

        if (appointment.getStartTime()
                .before(
                        availability.getStartTime()
                )) {

            return false;
        }

        if (appointment.getEndTime()
                .after(
                        availability.getEndTime()
                )) {

            return false;
        }

        /*
         * ==========================================
         * PREVENT DOUBLE BOOKING
         * ==========================================
         */

        if (appointmentDAO.isTimeSlotBooked(
                appointment.getDentistId(),
                appointment.getAppointmentDate(),
                appointment.getStartTime(),
                appointment.getEndTime()
        )) {

            return false;
        }

        /*
         * ==========================================
         * GENERATE APPOINTMENT NUMBER
         * ==========================================
         */

        String appointmentNumber =
                appointmentDAO
                        .generateAppointmentNumber();

        appointment.setAppointmentNumber(
                appointmentNumber
        );

        /*
         * ==========================================
         * STATUS
         * ==========================================
         */

        appointment.setStatus(
                "CONFIRMED"
        );

        /*
         * ==========================================
         * SAVE
         * ==========================================
         */

        return appointmentDAO.save(
                appointment
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
}