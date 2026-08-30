package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.Patient;

public interface PatientDAO {

    boolean save(Patient patient);

    boolean existsByEmail(String email);

    boolean existsByEmailExceptPatient(
            String email,
            int patientId
    );

    List<Patient> findAll();

    List<Patient> search(String keyword);

    Patient findById(int patientId);

    boolean update(Patient patient);

    String generatePatientNumber();
}