package com.sunrise.dental.service;

import java.sql.Date;
import java.sql.Time;
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


    // =========================================================
    // GET AVAILABILITY
    // =========================================================

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


    // =========================================================
    // GET BY ID
    // =========================================================

    public DentistAvailability getAvailabilityById(
            int availabilityId) {

        if (availabilityId <= 0) {
            return null;
        }

        return availabilityDAO.findById(
                availabilityId
        );
    }


    // =========================================================
    // SAVE AVAILABILITY
    // =========================================================

    public boolean saveAvailability(
            DentistAvailability availability) {

        if (availability == null) {
            return false;
        }

        if (availability.getDentistId() <= 0) {
            return false;
        }

        if (availability.getAvailableDate() == null) {
            return false;
        }

        if (availability.getStartTime() == null
                || availability.getEndTime() == null) {
            return false;
        }

        if (!availability.getEndTime()
                .after(availability.getStartTime())) {
            return false;
        }

        if (availability.getSlotCapacity() <= 0) {
            return false;
        }

        if (availabilityDAO.hasOverlap(
                availability.getDentistId(),
                availability.getAvailableDate(),
                availability.getStartTime(),
                availability.getEndTime()
        )) {
            return false;
        }

        availability.setStatus("AVAILABLE");

        return availabilityDAO.save(
                availability
        );
    }

    public List<DentistAvailability> getAllAvailability() {
        return availabilityDAO.findAll();
    }
}