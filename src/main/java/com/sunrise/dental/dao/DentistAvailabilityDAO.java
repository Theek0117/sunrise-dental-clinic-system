package com.sunrise.dental.dao;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import com.sunrise.dental.model.DentistAvailability;

public interface DentistAvailabilityDAO {

    List<DentistAvailability> findByDentistAndDate(
            int dentistId,
            Date availableDate
    );

    DentistAvailability findById(
            int availabilityId
    );

    boolean save(
            DentistAvailability availability
    );

    boolean hasOverlap(
            int dentistId,
            Date availableDate,
            Time startTime,
            Time endTime
    );
}