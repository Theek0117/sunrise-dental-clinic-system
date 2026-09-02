package com.sunrise.dental.model;

import java.sql.Date;

public class Patient {

    private int patientId;
    private String patientNumber;
    private String name;
    private Date dateOfBirth;
    private String address;
    private String contactNumber;
    private String email;
    private String status;

    public Patient() {
    }

    public Patient(
            int patientId,
            String patientNumber,
            String name,
            String address,
            String contactNumber,
            String email,
            String status) {

        this.patientId = patientId;
        this.patientNumber = patientNumber;
        this.name = name;
        this.address = address;
        this.contactNumber = contactNumber;
        this.email = email;
        this.status = status;
    }

    public Patient(
            int patientId,
            String patientNumber,
            String name,
            Date dateOfBirth,
            String address,
            String contactNumber,
            String email,
            String status) {

        this.patientId = patientId;
        this.patientNumber = patientNumber;
        this.name = name;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.contactNumber = contactNumber;
        this.email = email;
        this.status = status;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getPatientNumber() {
        return patientNumber;
    }

    public void setPatientNumber(String patientNumber) {
        this.patientNumber = patientNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public void setDateOfBirth(String dobStr) {
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                this.dateOfBirth = Date.valueOf(dobStr.trim());
            } catch (IllegalArgumentException e) {
                this.dateOfBirth = null;
            }
        } else {
            this.dateOfBirth = null;
        }
    }

    public String getDateOfBirthString() {
        return dateOfBirth != null ? dateOfBirth.toString() : "";
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}