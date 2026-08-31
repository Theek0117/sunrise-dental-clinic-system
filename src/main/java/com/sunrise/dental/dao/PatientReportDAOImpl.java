package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.PatientReport;
import com.sunrise.dental.util.DBConnection;


public class PatientReportDAOImpl
        implements PatientReportDAO {


    @Override
    public boolean save(
            PatientReport report) {

        String sql = """
                INSERT INTO patient_report
                (
                    appointment_id,
                    patient_id,
                    dentist_id,
                    original_file_name,
                    stored_file_name,
                    file_path,
                    file_type,
                    file_size
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    report.getAppointmentId()
            );

            statement.setInt(
                    2,
                    report.getPatientId()
            );

            statement.setInt(
                    3,
                    report.getDentistId()
            );

            statement.setString(
                    4,
                    report.getOriginalFileName()
            );

            statement.setString(
                    5,
                    report.getStoredFileName()
            );

            statement.setString(
                    6,
                    report.getFilePath()
            );

            statement.setString(
                    7,
                    report.getFileType()
            );

            statement.setLong(
                    8,
                    report.getFileSize()
            );


            return statement.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    @Override
    public List<PatientReport>
    findByAppointmentId(
            int appointmentId) {

        List<PatientReport> reports =
                new ArrayList<>();


        String sql = """
                SELECT
                    report_id,
                    appointment_id,
                    patient_id,
                    dentist_id,
                    original_file_name,
                    stored_file_name,
                    file_path,
                    file_type,
                    file_size,
                    uploaded_at
                FROM patient_report
                WHERE appointment_id = ?
                ORDER BY uploaded_at DESC
                """;


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );


            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    reports.add(
                            mapReport(resultSet)
                    );
                }
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return reports;
    }


    @Override
    public PatientReport findById(
            int reportId) {

        String sql = """
                SELECT
                    report_id,
                    appointment_id,
                    patient_id,
                    dentist_id,
                    original_file_name,
                    stored_file_name,
                    file_path,
                    file_type,
                    file_size,
                    uploaded_at
                FROM patient_report
                WHERE report_id = ?
                """;


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    reportId
            );


            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapReport(
                            resultSet
                    );
                }
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return null;
    }


    @Override
    public PatientReport findByIdAndDentist(
            int reportId,
            int dentistId) {

        String sql = """
                SELECT
                    report_id,
                    appointment_id,
                    patient_id,
                    dentist_id,
                    original_file_name,
                    stored_file_name,
                    file_path,
                    file_type,
                    file_size,
                    uploaded_at
                FROM patient_report
                WHERE report_id = ?
                  AND dentist_id = ?
                """;


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    reportId
            );

            statement.setInt(
                    2,
                    dentistId
            );


            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapReport(
                            resultSet
                    );
                }
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return null;
    }


    private PatientReport mapReport(
            ResultSet resultSet)
            throws Exception {

        PatientReport report =
                new PatientReport();


        report.setReportId(
                resultSet.getInt(
                        "report_id"
                )
        );


        report.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );


        report.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );


        report.setDentistId(
                resultSet.getInt(
                        "dentist_id"
                )
        );


        report.setOriginalFileName(
                resultSet.getString(
                        "original_file_name"
                )
        );


        report.setStoredFileName(
                resultSet.getString(
                        "stored_file_name"
                )
        );


        report.setFilePath(
                resultSet.getString(
                        "file_path"
                )
        );


        report.setFileType(
                resultSet.getString(
                        "file_type"
                )
        );


        report.setFileSize(
                resultSet.getLong(
                        "file_size"
                )
        );


        Timestamp uploadedAt =
                resultSet.getTimestamp(
                        "uploaded_at"
                );


        report.setUploadedAt(
                uploadedAt
        );


        return report;
    }
}