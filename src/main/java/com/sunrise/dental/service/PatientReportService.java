package com.sunrise.dental.service;

import java.util.List;

import com.sunrise.dental.dao.PatientReportDAO;
import com.sunrise.dental.dao.PatientReportDAOImpl;
import com.sunrise.dental.model.PatientReport;


public class PatientReportService {

    private final PatientReportDAO reportDAO;


    public PatientReportService() {

        reportDAO =
                new PatientReportDAOImpl();
    }


    public boolean saveReport(
            PatientReport report) {

        if (report == null) {
            return false;
        }


        if (report.getAppointmentId() <= 0
                || report.getPatientId() <= 0
                || report.getDentistId() <= 0) {

            return false;
        }


        if (report.getOriginalFileName() == null
                || report.getOriginalFileName().isBlank()) {

            return false;
        }


        if (report.getStoredFileName() == null
                || report.getStoredFileName().isBlank()) {

            return false;
        }


        return reportDAO.save(report);
    }


    public List<PatientReport>
    getReportsForAppointment(
            int appointmentId) {

        if (appointmentId <= 0) {
            return List.of();
        }

        return reportDAO.findByAppointmentId(
                appointmentId
        );
    }


    public PatientReport getReport(
            int reportId) {

        if (reportId <= 0) {
            return null;
        }

        return reportDAO.findById(
                reportId
        );
    }


    public PatientReport getDentistReport(
            int reportId,
            int dentistId) {

        if (reportId <= 0
                || dentistId <= 0) {

            return null;
        }

        return reportDAO.findByIdAndDentist(
                reportId,
                dentistId
        );
    }
}