package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.model.Dentist;

/**
 * J02: Dentist DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J02_DentistDaoTest {

    private DentistDAO dentistDAO;

    @BeforeEach
    void setUp() {
        dentistDAO = new DentistDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving active dentists list from database")
    void testFindAllActiveDentists() {
        List<Dentist> dentists = dentistDAO.findAllActive();
        assertNotNull(dentists, "Active dentists list should not be null");
    }

    @Test
    @DisplayName("Test generating unique dentist registration number")
    void testGenerateDentistNumber() {
        String dentistNumber = dentistDAO.generateDentistNumber();
        assertNotNull(dentistNumber, "Generated dentist number should not be null");
        assertTrue(dentistNumber.startsWith("D"), "Dentist number should follow clinic prefix convention 'D'");
    }
}
