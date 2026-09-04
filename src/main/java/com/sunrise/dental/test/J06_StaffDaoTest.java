package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.StaffDAO;
import com.sunrise.dental.dao.StaffDAOImpl;
import com.sunrise.dental.model.Staff;

/**
 * J06: Staff DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J06_StaffDaoTest {

    private StaffDAO staffDAO;

    @BeforeEach
    void setUp() {
        staffDAO = new StaffDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving active staff members from database")
    void testFindAllActiveStaff() {
        List<Staff> staffList = staffDAO.findAllActive();
        assertNotNull(staffList, "Active staff list should not be null");
    }

    @Test
    @DisplayName("Test retrieving complete staff directory from database")
    void testFindAllStaff() {
        List<Staff> allStaff = staffDAO.findAll();
        assertNotNull(allStaff, "Complete staff directory list should not be null");
    }
}

