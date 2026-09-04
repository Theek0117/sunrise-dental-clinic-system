package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.PatientReportDAO;
import com.sunrise.dental.dao.PatientReportDAOImpl;
import com.sunrise.dental.model.PatientReport;

/**
 * J08: Patient Medical Report DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J08_PatientReportDaoTest {

    private PatientReportDAO patientReportDAO;

    @BeforeEach
    void setUp() {
        patientReportDAO = new PatientReportDAOImpl();
    }

    @Test
    @DisplayName("Test retrieving patient medical reports by appointment ID from database")
    void testFindByAppointmentId() {
        List<PatientReport> reports = patientReportDAO.findByAppointmentId(1);
        assertNotNull(reports, "Medical reports query should not return null");
    }

    @Test
    @DisplayName("Test finding patient report by non-existent report ID returns null")
    void testFindReportByInvalidId() {
        PatientReport report = patientReportDAO.findById(-999);
        assertNull(report, "Non-existent report ID should return null");
    }
}
