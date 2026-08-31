package com.sunrise.dental.model;

public class Receptionist {

    private int receptionistId;
    private int staffId;
    private String receptionistNumber;
    private String name;
    private String contactNumber;
    private String email;
    private String status;

    public Receptionist() {
    }

    public Receptionist(
            int receptionistId,
            int staffId,
            String receptionistNumber,
            String name,
            String contactNumber,
            String email,
            String status) {

        this.receptionistId = receptionistId;
        this.staffId = staffId;
        this.receptionistNumber = receptionistNumber;
        this.name = name;
        this.contactNumber = contactNumber;
        this.email = email;
        this.status = status;
    }

    public int getReceptionistId() {
        return receptionistId;
    }

    public void setReceptionistId(int receptionistId) {
        this.receptionistId = receptionistId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getReceptionistNumber() {
        return receptionistNumber;
    }

    public void setReceptionistNumber(String receptionistNumber) {
        this.receptionistNumber = receptionistNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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