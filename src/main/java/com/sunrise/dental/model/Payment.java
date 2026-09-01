package com.sunrise.dental.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {

    private int paymentId;
    private String invoiceNumber;
    private int appointmentId;
    private int patientId;
    private int treatmentTypeId;
    private BigDecimal basicAmount;
    private BigDecimal doctorFee;
    private BigDecimal taxAmount;
    private BigDecimal additionalAmount;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private String paymentStatus;
    private Timestamp paidAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Display / joined fields
    private String appointmentNumber;
    private String patientName;
    private String patientEmail;
    private String patientContact;
    private String dentistName;
    private String treatmentName;

    public Payment() {
        this.basicAmount = BigDecimal.ZERO;
        this.doctorFee = BigDecimal.ZERO;
        this.taxAmount = BigDecimal.ZERO;
        this.additionalAmount = BigDecimal.ZERO;
        this.totalAmount = BigDecimal.ZERO;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getTreatmentTypeId() {
        return treatmentTypeId;
    }

    public void setTreatmentTypeId(int treatmentTypeId) {
        this.treatmentTypeId = treatmentTypeId;
    }

    public BigDecimal getBasicAmount() {
        return basicAmount != null ? basicAmount : BigDecimal.ZERO;
    }

    public void setBasicAmount(BigDecimal basicAmount) {
        this.basicAmount = basicAmount;
    }

    public BigDecimal getDoctorFee() {
        return doctorFee != null ? doctorFee : BigDecimal.ZERO;
    }

    public void setDoctorFee(BigDecimal doctorFee) {
        this.doctorFee = doctorFee;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount != null ? taxAmount : BigDecimal.ZERO;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }

    public BigDecimal getAdditionalAmount() {
        return additionalAmount != null ? additionalAmount : BigDecimal.ZERO;
    }

    public void setAdditionalAmount(BigDecimal additionalAmount) {
        this.additionalAmount = additionalAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount != null ? totalAmount : BigDecimal.ZERO;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getAppointmentNumber() {
        return appointmentNumber;
    }

    public void setAppointmentNumber(String appointmentNumber) {
        this.appointmentNumber = appointmentNumber;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientEmail() {
        return patientEmail;
    }

    public void setPatientEmail(String patientEmail) {
        this.patientEmail = patientEmail;
    }

    public String getPatientContact() {
        return patientContact;
    }

    public void setPatientContact(String patientContact) {
        this.patientContact = patientContact;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getTreatmentName() {
        return treatmentName;
    }

    public void setTreatmentName(String treatmentName) {
        this.treatmentName = treatmentName;
    }
}