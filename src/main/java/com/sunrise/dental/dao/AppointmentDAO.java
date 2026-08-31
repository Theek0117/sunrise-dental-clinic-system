package com.sunrise.dental.dao;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import com.sunrise.dental.model.Appointment;

public interface AppointmentDAO {

    boolean save(Appointment appointment);

    String generateAppointmentNumber();

    boolean isTimeSlotBooked(
            int dentistId,
            Date appointmentDate,
            Time startTime,
            Time endTime
    );

    int getSlotBookingCount(
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime
    );

    List<Appointment> findAll();

    List<Appointment> findActiveAppointments();

    Appointment findById(int appointmentId);

    boolean cancelAppointment(
            int appointmentId
    );

    boolean rescheduleAppointment(
            int appointmentId,
            int dentistId,
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime,
            String reason
    );

    int getSlotBookingCountExcludingAppointment(
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime,
            int appointmentId
    );
    
    List<Appointment> findByDentistAndDate(
            int dentistId,
            Date appointmentDate
    );

    List<Appointment> findByDentist(
            int dentistId
    );

    Appointment findByIdAndDentist(
            int appointmentId,
            int dentistId
    );
}