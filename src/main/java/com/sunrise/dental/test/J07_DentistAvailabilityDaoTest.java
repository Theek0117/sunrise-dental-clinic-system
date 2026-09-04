package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Date;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.DentistAvailabilityDAO;
import com.sunrise.dental.dao.DentistAvailabilityDAOImpl;
import com.sunrise.dental.model.DentistAvailability;

/**
 * J07: Dentist Availability Schedule DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J07_DentistAvailabilityDaoTest {

    private DentistAvailabilityDAO availabilityDAO;

    @BeforeEach
    void setUp() {
        availabilityDAO = new DentistAvailabilityDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving all dentist availability schedules from database")
    void testFindAllAvailabilitySchedules() {
        List<DentistAvailability> list = availabilityDAO.findAll();
        assertNotNull(list, "Availability schedule list should not be null");
    }

    @Test
    @DisplayName("Test querying schedule slots for dentist on date")
    void testFindAvailabilityByDentistAndDate() {
        Date queryDate = Date.valueOf("2026-12-31");
        List<DentistAvailability> slots = availabilityDAO.findByDentistAndDate(1, queryDate);
        assertNotNull(slots, "Queried dentist availability schedule list should not be null");
    }
}
