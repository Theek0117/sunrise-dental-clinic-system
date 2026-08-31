package com.sunrise.dental.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.PatientReport;
import com.sunrise.dental.service.PatientReportService;


@WebServlet("/dentist/view-report")
public class ViewPatientReportServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientReportService reportService;


    @Override
    public void init() {

        reportService =
                new PatientReportService();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        try {

            String reportIdParameter =
                    request.getParameter(
                            "reportId"
                    );


            if (reportIdParameter == null
                    || reportIdParameter.isBlank()) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                return;
            }


            int reportId =
                    Integer.parseInt(
                            reportIdParameter
                    );


            PatientReport report =
                    reportService.getReport(
                            reportId
                    );


            if (report == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );

                return;
            }


            String realPath =
                    getServletContext()
                            .getRealPath(
                                    "/"
                            );


            if (realPath == null) {

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );

                return;
            }


            Path filePath =
                    Paths.get(
                            realPath,
                            report.getFilePath()
                    );


            if (!Files.exists(filePath)
                    || !Files.isRegularFile(filePath)) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );

                return;
            }


            String contentType =
                    report.getFileType();


            if (contentType == null
                    || contentType.isBlank()) {

                contentType =
                        "application/octet-stream";
            }


            response.setContentType(
                    contentType
            );


            response.setHeader(
                    "Content-Disposition",
                    "inline; filename=\""
                    + sanitizeFileName(
                            report.getOriginalFileName()
                    )
                    + "\""
            );


            response.setContentLengthLong(
                    Files.size(filePath)
            );


            try (
                    InputStream input =
                            Files.newInputStream(
                                    filePath
                            );

                    OutputStream output =
                            response.getOutputStream()
            ) {

                byte[] buffer =
                        new byte[8192];

                int bytesRead;


                while (
                        (bytesRead =
                                input.read(buffer))
                                != -1
                ) {

                    output.write(
                            buffer,
                            0,
                            bytesRead
                    );
                }
            }


        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
        }
    }


    private String sanitizeFileName(
            String fileName) {

        if (fileName == null
                || fileName.isBlank()) {

            return "report";
        }


        return fileName
                .replace("\"", "")
                .replace("\r", "")
                .replace("\n", "");
    }
}