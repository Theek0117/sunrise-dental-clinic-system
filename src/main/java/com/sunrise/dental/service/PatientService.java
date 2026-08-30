package com.sunrise.dental.service;

import java.util.List;

import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.model.Patient;

public class PatientService {

    private final PatientDAO patientDAO;


    public PatientService() {

        this.patientDAO =
                new PatientDAOImpl();
    }


    public boolean registerPatient(
            Patient patient) {

        if (patient == null) {
            return false;
        }

        String name =
                clean(patient.getName());

        String address =
                clean(patient.getAddress());

        String contactNumber =
                clean(patient.getContactNumber());

        String email =
                cleanNullable(patient.getEmail());


        if (name.isEmpty()
                || address.isEmpty()
                || contactNumber.isEmpty()) {

            return false;
        }


        if (email != null
                && !isValidEmail(email)) {

            return false;
        }


        /*
         * Prevent duplicate email.
         */

        if (email != null
                && patientDAO.existsByEmail(email)) {

            return false;
        }


        patient.setName(name);

        patient.setAddress(address);

        patient.setContactNumber(
                contactNumber
        );

        patient.setEmail(email);


        patient.setPatientNumber(
                patientDAO.generatePatientNumber()
        );

        patient.setStatus("ACTIVE");


        return patientDAO.save(patient);
    }


    public List<Patient> getAllPatients() {

        return patientDAO.findAll();
    }


    public List<Patient> searchPatients(
            String keyword) {

        if (keyword == null
                || keyword.isBlank()) {

            return patientDAO.findAll();
        }

        return patientDAO.search(
                keyword.trim()
        );
    }


    public Patient getPatientById(
            int patientId) {

        return patientDAO.findById(
                patientId
        );
    }


    public boolean updatePatient(
            Patient patient) {

        if (patient == null
                || patient.getPatientId() <= 0) {

            return false;
        }


        String name =
                clean(patient.getName());

        String address =
                clean(patient.getAddress());

        String contactNumber =
                clean(patient.getContactNumber());

        String email =
                cleanNullable(patient.getEmail());


        if (name.isEmpty()
                || address.isEmpty()
                || contactNumber.isEmpty()) {

            return false;
        }


        if (email != null
                && !isValidEmail(email)) {

            return false;
        }


        /*
         * Prevent using another patient's email.
         */

        if (email != null
                && patientDAO.existsByEmailExceptPatient(
                        email,
                        patient.getPatientId()
                )) {

            return false;
        }


        patient.setName(name);

        patient.setAddress(address);

        patient.setContactNumber(
                contactNumber
        );

        patient.setEmail(email);


        return patientDAO.update(
                patient
        );
    }


    private String clean(
            String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    private String cleanNullable(
            String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }


    private boolean isValidEmail(
            String email) {

        return email.matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
        );
    }
}