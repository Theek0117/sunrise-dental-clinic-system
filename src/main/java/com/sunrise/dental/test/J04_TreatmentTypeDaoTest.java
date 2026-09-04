package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;
import com.sunrise.dental.model.TreatmentType;

/**
 * J04: Treatment Type DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J04_TreatmentTypeDaoTest {

    private TreatmentTypeDAO treatmentTypeDAO;

    @BeforeEach
    void setUp() {
        treatmentTypeDAO = new TreatmentTypeDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving active treatment catalog types")
    void testFindAllActiveTreatmentTypes() {
        List<TreatmentType> types = treatmentTypeDAO.findAllActive();
        assertNotNull(types, "Active treatment types list should not be null");
    }

    @Test
    @DisplayName("Test finding treatment type by invalid ID returns null")
    void testFindTreatmentTypeByInvalidId() {
        TreatmentType type = treatmentTypeDAO.findById(-999);
        assertNull(type, "Non-existent treatment type ID should return null");
    }
}
