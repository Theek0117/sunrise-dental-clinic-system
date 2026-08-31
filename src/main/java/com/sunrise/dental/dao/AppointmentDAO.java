package com.sunrise.dental.dao;

import java.sql.Date;
import java.sql.Time;

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
}