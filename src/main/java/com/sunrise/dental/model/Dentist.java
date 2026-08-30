package com.sunrise.dental.model;

public class Dentist {

    private int dentistId;
    private int staffId;
    private String dentistNumber;
    private String name;
    private String nic;
    private String specialization;
    private String contactNumber;
    private String email;
    private String status;

    public Dentist() {
    }

    public Dentist(
            int dentistId,
            int staffId,
            String dentistNumber,
            String name,
            String nic,
            String specialization,
            String contactNumber,
            String email,
            String status) {

        this.dentistId = dentistId;
        this.staffId = staffId;
        this.dentistNumber = dentistNumber;
        this.name = name;
        this.nic = nic;
        this.specialization = specialization;
        this.contactNumber = contactNumber;
        this.email = email;
        this.status = status;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getDentistNumber() {
        return dentistNumber;
    }

    public void setDentistNumber(String dentistNumber) {
        this.dentistNumber = dentistNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
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