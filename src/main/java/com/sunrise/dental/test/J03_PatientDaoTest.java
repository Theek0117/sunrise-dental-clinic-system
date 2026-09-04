package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.model.Patient;

/**
 * J03: Patient DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J03_PatientDaoTest {

    private PatientDAO patientDAO;

    @BeforeEach
    void setUp() {
        patientDAO = new PatientDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving all active patients from database")
    void testFindAllActivePatients() {
        List<Patient> patients = patientDAO.findAllActive();
        assertNotNull(patients, "Active patients list should not be null");
    }

    @Test
    @DisplayName("Test checking non-existent patient email returns false")
    void testExistsByNonExistentEmail() {
        boolean exists = patientDAO.existsByEmail("non_existent_sunrise_patient_999@test.com");
        assertFalse(exists, "Non-existent patient email should return false");
    }
}
