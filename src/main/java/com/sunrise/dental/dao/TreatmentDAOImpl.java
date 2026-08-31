package com.sunrise.dental.dao;

import com.sunrise.dental.model.Treatment;
import com.sunrise.dental.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class TreatmentDAOImpl implements TreatmentDAO {

    @Override
    public Treatment findByAppointmentId(
            int appointmentId,
            int dentistId) {

        String sql =
                "SELECT t.*, " +
                "p.name AS patient_name, " +
                "d.name AS dentist_name, " +
                "a.appointment_number " +
                "FROM treatment t " +
                "INNER JOIN patient p " +
                "ON t.patient_id = p.patient_id " +
                "INNER JOIN dentist d " +
                "ON t.dentist_id = d.dentist_id " +
                "INNER JOIN appointment a " +
                "ON t.appointment_id = a.appointment_id " +
                "WHERE t.appointment_id = ? " +
                "AND t.dentist_id = ? " +
                "ORDER BY t.created_at DESC " +
                "LIMIT 1";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, appointmentId);
            statement.setInt(2, dentistId);

            try (ResultSet rs = statement.executeQuery()) {

                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public boolean saveOrUpdate(
            Treatment treatment) {

        if (treatment == null) {
            return false;
        }

        try {

            Treatment existing =
                    findByAppointmentId(
                            treatment.getAppointmentId(),
                            treatment.getDentistId()
                    );

            if (existing == null) {
                return insert(treatment);
            }

            return update(treatment);

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    private boolean insert(
            Treatment treatment) {

        String sql =
                "INSERT INTO treatment " +
                "(appointment_id, patient_id, dentist_id, " +
                "diagnosis, treatment_provided, " +
                "treatment_notes, next_appointment_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    treatment.getAppointmentId()
            );

            statement.setInt(
                    2,
                    treatment.getPatientId()
            );

            statement.setInt(
                    3,
                    treatment.getDentistId()
            );

            statement.setString(
                    4,
                    treatment.getDiagnosis()
            );

            statement.setString(
                    5,
                    treatment.getTreatmentProvided()
            );

            statement.setString(
                    6,
                    treatment.getTreatmentNotes()
            );

            if (treatment.getNextAppointmentDate() != null) {

                statement.setDate(
                        7,
                        treatment.getNextAppointmentDate()
                );

            } else {

                statement.setNull(
                        7,
                        Types.DATE
                );
            }

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    private boolean update(
            Treatment treatment) {

        String sql =
                "UPDATE treatment SET " +
                "diagnosis = ?, " +
                "treatment_provided = ?, " +
                "treatment_notes = ?, " +
                "next_appointment_date = ? " +
                "WHERE treatment_id = ? " +
                "AND appointment_id = ? " +
                "AND dentist_id = ?";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    treatment.getDiagnosis()
            );

            statement.setString(
                    2,
                    treatment.getTreatmentProvided()
            );

            statement.setString(
                    3,
                    treatment.getTreatmentNotes()
            );

            if (treatment.getNextAppointmentDate() != null) {

                statement.setDate(
                        4,
                        treatment.getNextAppointmentDate()
                );

            } else {

                statement.setNull(
                        4,
                        Types.DATE
                );
            }

            statement.setInt(
                    5,
                    treatment.getTreatmentId()
            );

            statement.setInt(
                    6,
                    treatment.getAppointmentId()
            );

            statement.setInt(
                    7,
                    treatment.getDentistId()
            );

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    @Override
    public List<Treatment> findByPatientId(
            int patientId) {

        List<Treatment> treatments =
                new ArrayList<>();

        String sql =
                "SELECT t.*, " +
                "p.name AS patient_name, " +
                "d.name AS dentist_name, " +
                "a.appointment_number " +
                "FROM treatment t " +
                "INNER JOIN patient p " +
                "ON t.patient_id = p.patient_id " +
                "INNER JOIN dentist d " +
                "ON t.dentist_id = d.dentist_id " +
                "INNER JOIN appointment a " +
                "ON t.appointment_id = a.appointment_id " +
                "WHERE t.patient_id = ? " +
                "ORDER BY t.created_at DESC";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, patientId);

            try (ResultSet rs = statement.executeQuery()) {

                while (rs.next()) {

                    treatments.add(
                            mapResultSet(rs)
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return treatments;
    }


    @Override
    public List<Treatment> findByPatientIdAndDentist(
            int patientId,
            int dentistId) {

        List<Treatment> treatments =
                new ArrayList<>();

        String sql =
                "SELECT t.*, " +
                "p.name AS patient_name, " +
                "d.name AS dentist_name, " +
                "a.appointment_number " +
                "FROM treatment t " +
                "INNER JOIN patient p " +
                "ON t.patient_id = p.patient_id " +
                "INNER JOIN dentist d " +
                "ON t.dentist_id = d.dentist_id " +
                "INNER JOIN appointment a " +
                "ON t.appointment_id = a.appointment_id " +
                "WHERE t.patient_id = ? " +
                "AND t.dentist_id = ? " +
                "ORDER BY t.created_at DESC";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, patientId);
            statement.setInt(2, dentistId);

            try (ResultSet rs = statement.executeQuery()) {

                while (rs.next()) {

                    treatments.add(
                            mapResultSet(rs)
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return treatments;
    }


    private Treatment mapResultSet(
            ResultSet rs)
            throws SQLException {

        Treatment treatment =
                new Treatment();

        treatment.setTreatmentId(
                rs.getInt("treatment_id")
        );

        treatment.setAppointmentId(
                rs.getInt("appointment_id")
        );

        treatment.setPatientId(
                rs.getInt("patient_id")
        );

        treatment.setDentistId(
                rs.getInt("dentist_id")
        );

        treatment.setDiagnosis(
                rs.getString("diagnosis")
        );

        treatment.setTreatmentProvided(
                rs.getString("treatment_provided")
        );

        treatment.setTreatmentNotes(
                rs.getString("treatment_notes")
        );

        treatment.setNextAppointmentDate(
                rs.getDate("next_appointment_date")
        );

        treatment.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        treatment.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );

        treatment.setPatientName(
                rs.getString("patient_name")
        );

        treatment.setDentistName(
                rs.getString("dentist_name")
        );

        treatment.setAppointmentNumber(
                rs.getString("appointment_number")
        );

        return treatment;
    }
}