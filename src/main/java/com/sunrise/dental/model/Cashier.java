package com.sunrise.dental.model;

public class Cashier {

    private int cashierId;
    private int staffId;
    private String cashierNumber;
    private String name;
    private String contactNumber;
    private String email;
    private String status;

    public Cashier() {
    }

    public Cashier(
            int cashierId,
            int staffId,
            String cashierNumber,
            String name,
            String contactNumber,
            String email,
            String status) {

        this.cashierId = cashierId;
        this.staffId = staffId;
        this.cashierNumber = cashierNumber;
        this.name = name;
        this.contactNumber = contactNumber;
        this.email = email;
        this.status = status;
    }

    public int getCashierId() {
        return cashierId;
    }

    public void setCashierId(int cashierId) {
        this.cashierId = cashierId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getCashierNumber() {
        return cashierNumber;
    }

    public void setCashierNumber(String cashierNumber) {
        this.cashierNumber = cashierNumber;
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