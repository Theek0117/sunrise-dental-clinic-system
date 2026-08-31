package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.PatientReport;

public interface PatientReportDAO {

    boolean save(
            PatientReport report
    );

    List<PatientReport> findByAppointmentId(
            int appointmentId
    );

    PatientReport findById(
            int reportId
    );

    PatientReport findByIdAndDentist(
            int reportId,
            int dentistId
    );
}