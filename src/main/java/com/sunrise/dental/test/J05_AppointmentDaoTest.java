package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.dao.AppointmentDAOImpl;
import com.sunrise.dental.model.Appointment;

/**
 * J05: Appointment DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J05_AppointmentDaoTest {

    private AppointmentDAO appointmentDAO;

    @BeforeEach
    void setUp() {
        appointmentDAO = new AppointmentDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving scheduled appointments from database")
    void testFindActiveAppointments() {
        List<Appointment> activeList = appointmentDAO.findActiveAppointments();
        assertNotNull(activeList, "Active appointments list should not be null");
    }

    @Test
    @DisplayName("Test generating next unique appointment reference number")
    void testGenerateAppointmentNumber() {
        String appointmentNumber = appointmentDAO.generateAppointmentNumber();
        assertNotNull(appointmentNumber, "Generated appointment number should not be null");
        assertTrue(appointmentNumber.startsWith("A"), "Appointment number should follow clinic prefix convention 'A'");
    }
}

