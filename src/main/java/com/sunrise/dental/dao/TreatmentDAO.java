package com.sunrise.dental.dao;

import com.sunrise.dental.model.Treatment;

import java.util.List;

public interface TreatmentDAO {

    Treatment findByAppointmentId(
            int appointmentId,
            int dentistId
    );

    boolean saveOrUpdate(
            Treatment treatment
    );

    List<Treatment> findByPatientId(
            int patientId
    );

    List<Treatment> findByPatientIdAndDentist(
            int patientId,
            int dentistId
    );
}