package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.TreatmentDAO;
import com.sunrise.dental.dao.TreatmentDAOImpl;
import com.sunrise.dental.model.Treatment;

/**
 * J10: Clinical Treatment DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J10_TreatmentDaoTest {

    private TreatmentDAO treatmentDAO;

    @BeforeEach
    void setUp() {
        treatmentDAO = new TreatmentDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving clinical treatment records for patient from database")
    void testFindByPatientId() {
        List<Treatment> list = treatmentDAO.findByPatientId(1);
        assertNotNull(list, "Patient treatment records list should not be null");
    }

    @Test
    @DisplayName("Test retrieving clinical treatment records by dentist from database")
    void testFindByDentistId() {
        List<Treatment> list = treatmentDAO.findByDentistId(1);
        assertNotNull(list, "Dentist clinical treatments list should not be null");
    }
}

