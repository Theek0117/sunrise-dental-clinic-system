package com.sunrise.dental.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.PatientReport;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.PatientReportService;


@WebServlet("/dentist/upload-report")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 12 * 1024 * 1024
)
public class UploadPatientReportServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;

    private PatientReportService reportService;


    @Override
    public void init() {

        appointmentService =
                new AppointmentService();

        reportService =
                new PatientReportService();
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        request.setCharacterEncoding(
                "UTF-8"
        );


        try {

            // =====================================================
            // APPOINTMENT ID
            // =====================================================

            String appointmentIdParameter =
                    request.getParameter(
                            "appointmentId"
                    );


            if (appointmentIdParameter == null
                    || appointmentIdParameter.isBlank()) {

                redirectError(
                        request,
                        response,
                        "invalid"
                );

                return;
            }


            int appointmentId =
                    Integer.parseInt(
                            appointmentIdParameter.trim()
                    );


            if (appointmentId <= 0) {

                redirectError(
                        request,
                        response,
                        "invalid"
                );

                return;
            }


            // =====================================================
            // GET APPOINTMENT
            // =====================================================

            Appointment appointment =
                    appointmentService.getAppointment(
                            appointmentId
                    );


            if (appointment == null) {

                redirectError(
                        request,
                        response,
                        "notfound"
                );

                return;
            }


            // =====================================================
            // FILE
            // =====================================================

            Part filePart =
                    request.getPart(
                            "reportFile"
                    );


            if (filePart == null
                    || filePart.getSize() <= 0) {

                redirectError(
                        request,
                        response,
                        "nofile"
                );

                return;
            }


            // =====================================================
            // ORIGINAL FILE NAME
            // =====================================================

            String originalFileName =
                    Paths.get(
                            filePart.getSubmittedFileName()
                    )
                    .getFileName()
                    .toString();


            if (originalFileName.isBlank()) {

                redirectError(
                        request,
                        response,
                        "invalidfile"
                );

                return;
            }


            // =====================================================
            // EXTENSION
            // =====================================================

            String extension =
                    getExtension(
                            originalFileName
                    );


            if (!isAllowedExtension(
                    extension)) {

                redirectError(
                        request,
                        response,
                        "type"
                );

                return;
            }


            // =====================================================
            // CONTENT TYPE
            // =====================================================

            String contentType =
                    filePart.getContentType();


            if (contentType == null) {
                contentType =
                        "application/octet-stream";
            }


            // =====================================================
            // SAFE STORED FILE NAME
            // =====================================================

            String storedFileName =

                    UUID.randomUUID()
                            .toString()
                            .replace("-", "")

                    + extension;


            // =====================================================
            // UPLOAD DIRECTORY
            // =====================================================

            String uploadDirectory =
                    getServletContext()
                            .getRealPath(
                                    "/uploads/patient-reports"
                            );


            if (uploadDirectory == null) {

                redirectError(
                        request,
                        response,
                        "storage"
                );

                return;
            }


            Path uploadPath =
                    Paths.get(
                            uploadDirectory
                    );


            Files.createDirectories(
                    uploadPath
            );


            // =====================================================
            // SAVE FILE
            // =====================================================

            Path targetPath =
                    uploadPath.resolve(
                            storedFileName
                    );


            filePart.write(
                    targetPath.toString()
            );


            // =====================================================
            // DATABASE PATH
            // =====================================================

            String databasePath =
                    "uploads/patient-reports/"
                    + storedFileName;


            // =====================================================
            // CREATE REPORT
            // =====================================================

            PatientReport report =
                    new PatientReport();


            report.setAppointmentId(
                    appointment.getAppointmentId()
            );


            report.setPatientId(
                    appointment.getPatientId()
            );


            /*
             * IMPORTANT:
             *
             * The dentist ID is taken from the appointment,
             * not from a hidden form field.
             */
            report.setDentistId(
                    appointment.getDentistId()
            );


            report.setOriginalFileName(
                    originalFileName
            );


            report.setStoredFileName(
                    storedFileName
            );


            report.setFilePath(
                    databasePath
            );


            report.setFileType(
                    contentType
            );


            report.setFileSize(
                    filePart.getSize()
            );


            // =====================================================
            // SAVE DATABASE RECORD
            // =====================================================

            boolean saved =
                    reportService.saveReport(
                            report
                    );


            if (!saved) {

                Files.deleteIfExists(
                        targetPath
                );


                redirectError(
                        request,
                        response,
                        "database"
                );

                return;
            }


            // =====================================================
            // SUCCESS
            // =====================================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/dentist/appointment-details"
                    + "?appointmentId="
                    + appointmentId
                    + "&success=report"
            );


        } catch (NumberFormatException e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "invalid"
            );


        } catch (IllegalStateException e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "size"
            );


        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "server"
            );
        }
    }


    // =========================================================
    // FILE EXTENSION
    // =========================================================

    private String getExtension(
            String fileName) {

        int lastDot =
                fileName.lastIndexOf(".");


        if (lastDot < 0) {
            return "";
        }


        return fileName
                .substring(lastDot)
                .toLowerCase();
    }


    // =========================================================
    // ALLOWED FILE TYPES
    // =========================================================

    private boolean isAllowedExtension(
            String extension) {

        return ".pdf".equals(extension)

                || ".jpg".equals(extension)

                || ".jpeg".equals(extension)

                || ".png".equals(extension);
    }


    // =========================================================
    // ERROR REDIRECT
    // =========================================================

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String error)
            throws IOException {

        String appointmentId =
                request.getParameter(
                        "appointmentId"
                );


        response.sendRedirect(
                request.getContextPath()
                + "/dentist/appointment-details"
                + "?appointmentId="
                + (appointmentId != null
                        ? appointmentId
                        : "")
                + "&error=report-"
                + error
        );
    }
}