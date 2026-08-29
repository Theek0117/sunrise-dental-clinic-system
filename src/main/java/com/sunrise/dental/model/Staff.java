package com.sunrise.dental.model;

public class Staff {

    private int staffId;
    private String name;
    private String username;
    private String password;
    private String contactNumber;
    private String role;
    private String status;

    public Staff() {
    }

    public Staff(int staffId, String name, String username, String password,
                 String contactNumber, String role, String status) {

        this.staffId = staffId;
        this.name = name;
        this.username = username;
        this.password = password;
        this.contactNumber = contactNumber;
        this.role = role;
        this.status = status;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}