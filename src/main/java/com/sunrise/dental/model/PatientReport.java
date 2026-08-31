package com.sunrise.dental.model;

import java.sql.Timestamp;


public class PatientReport {

    private int reportId;

    private int appointmentId;

    private int patientId;

    private int dentistId;

    private String originalFileName;

    private String storedFileName;

    private String filePath;

    private String fileType;

    private long fileSize;

    private Timestamp uploadedAt;


    public PatientReport() {
    }


    public int getReportId() {
        return reportId;
    }


    public void setReportId(int reportId) {
        this.reportId = reportId;
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


    public int getDentistId() {
        return dentistId;
    }


    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }


    public String getOriginalFileName() {
        return originalFileName;
    }


    public void setOriginalFileName(
            String originalFileName) {

        this.originalFileName =
                originalFileName;
    }


    public String getStoredFileName() {
        return storedFileName;
    }


    public void setStoredFileName(
            String storedFileName) {

        this.storedFileName =
                storedFileName;
    }


    public String getFilePath() {
        return filePath;
    }


    public void setFilePath(
            String filePath) {

        this.filePath =
                filePath;
    }


    public String getFileType() {
        return fileType;
    }


    public void setFileType(
            String fileType) {

        this.fileType =
                fileType;
    }


    public long getFileSize() {
        return fileSize;
    }


    public void setFileSize(
            long fileSize) {

        this.fileSize =
                fileSize;
    }


    public Timestamp getUploadedAt() {
        return uploadedAt;
    }


    public void setUploadedAt(
            Timestamp uploadedAt) {

        this.uploadedAt =
                uploadedAt;
    }
}