package com.sunrise.dental.service;

import java.sql.Date;
import java.util.List;

import com.sunrise.dental.dao.DentistAvailabilityDAO;
import com.sunrise.dental.dao.DentistAvailabilityDAOImpl;
import com.sunrise.dental.model.DentistAvailability;

public class DentistAvailabilityService {

    private final DentistAvailabilityDAO availabilityDAO;

    public DentistAvailabilityService() {

        this.availabilityDAO =
                new DentistAvailabilityDAOImpl();
    }

    public List<DentistAvailability> getAvailability(
            int dentistId,
            Date availableDate) {

        if (dentistId <= 0) {

            return List.of();
        }

        if (availableDate == null) {

            return List.of();
        }

        return availabilityDAO.findByDentistAndDate(
                dentistId,
                availableDate
        );
    }

    public DentistAvailability getAvailabilityById(
            int availabilityId) {

        if (availabilityId <= 0) {

            return null;
        }

        return availabilityDAO.findById(
                availabilityId
        );
    }
}