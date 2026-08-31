package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Patient;
import com.sunrise.dental.util.DBConnection;

public class PatientDAOImpl implements PatientDAO {

    @Override
    public boolean save(Patient patient) {

        String sql = """
                INSERT INTO patient
                (
                    patient_number,
                    name,
                    address,
                    contact_number,
                    email,
                    status
                )
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    patient.getPatientNumber()
            );

            statement.setString(
                    2,
                    patient.getName()
            );

            statement.setString(
                    3,
                    patient.getAddress()
            );

            statement.setString(
                    4,
                    patient.getContactNumber()
            );

            if (patient.getEmail() == null
                    || patient.getEmail().isBlank()) {

                statement.setNull(
                        5,
                        java.sql.Types.VARCHAR
                );

            } else {

                statement.setString(
                        5,
                        patient.getEmail()
                );
            }

            statement.setString(
                    6,
                    patient.getStatus()
            );

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    @Override
    public boolean existsByEmail(String email) {

        if (email == null || email.isBlank()) {
            return false;
        }

        String sql = """
                SELECT patient_id
                FROM patient
                WHERE LOWER(TRIM(email)) = LOWER(TRIM(?))
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    email.trim()
            );

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                return resultSet.next();
            }

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    @Override
    public boolean existsByEmailExceptPatient(
            String email,
            int patientId) {

        if (email == null || email.isBlank()) {
            return false;
        }

        String sql = """
                SELECT patient_id
                FROM patient
                WHERE LOWER(TRIM(email)) = LOWER(TRIM(?))
                  AND patient_id <> ?
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    email.trim()
            );

            statement.setInt(
                    2,
                    patientId
            );

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                return resultSet.next();
            }

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    @Override
    public List<Patient> findAll() {

        List<Patient> patients =
                new ArrayList<>();

        String sql = """
                SELECT
                    patient_id,
                    patient_number,
                    name,
                    address,
                    contact_number,
                    email,
                    status
                FROM patient
                ORDER BY patient_id DESC
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                patients.add(
                        mapPatient(resultSet)
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return patients;
    }
    
    
    @Override
    public List<Patient> findAllActive() {

        List<Patient> patients = new ArrayList<>();

        String sql = """
                SELECT
                    patient_id,
                    patient_number,
                    name,
                    address,
                    contact_number,
                    email,
                    status
                FROM patient
                WHERE status = 'ACTIVE'
                ORDER BY name
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                patients.add(
                        mapPatient(resultSet)
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return patients;
    }


    @Override
    public List<Patient> search(
            String keyword) {

        List<Patient> patients =
                new ArrayList<>();

        String sql = """
                SELECT
                    patient_id,
                    patient_number,
                    name,
                    address,
                    contact_number,
                    email,
                    status
                FROM patient
                WHERE patient_number LIKE ?
                   OR name LIKE ?
                   OR contact_number LIKE ?
                   OR email LIKE ?
                ORDER BY patient_id DESC
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            String searchValue =
                    "%" + keyword.trim() + "%";

            statement.setString(
                    1,
                    searchValue
            );

            statement.setString(
                    2,
                    searchValue
            );

            statement.setString(
                    3,
                    searchValue
            );

            statement.setString(
                    4,
                    searchValue
            );

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                while (resultSet.next()) {

                    patients.add(
                            mapPatient(resultSet)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return patients;
    }


    @Override
    public Patient findById(
            int patientId) {

        String sql = """
                SELECT
                    patient_id,
                    patient_number,
                    name,
                    address,
                    contact_number,
                    email,
                    status
                FROM patient
                WHERE patient_id = ?
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    patientId
            );

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapPatient(
                            resultSet
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }


    @Override
    public boolean update(
            Patient patient) {

        String sql = """
                UPDATE patient
                SET
                    name = ?,
                    address = ?,
                    contact_number = ?,
                    email = ?,
                    status = ?
                WHERE patient_id = ?
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    patient.getName()
            );

            statement.setString(
                    2,
                    patient.getAddress()
            );

            statement.setString(
                    3,
                    patient.getContactNumber()
            );

            if (patient.getEmail() == null
                    || patient.getEmail().isBlank()) {

                statement.setNull(
                        4,
                        java.sql.Types.VARCHAR
                );

            } else {

                statement.setString(
                        4,
                        patient.getEmail()
                );
            }

            statement.setString(
                    5,
                    patient.getStatus()
            );

            statement.setInt(
                    6,
                    patient.getPatientId()
            );

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    private Patient mapPatient(
            ResultSet resultSet)
            throws SQLException {

        Patient patient =
                new Patient();

        patient.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        patient.setPatientNumber(
                resultSet.getString(
                        "patient_number"
                )
        );

        patient.setName(
                resultSet.getString(
                        "name"
                )
        );

        patient.setAddress(
                resultSet.getString(
                        "address"
                )
        );

        patient.setContactNumber(
                resultSet.getString(
                        "contact_number"
                )
        );

        patient.setEmail(
                resultSet.getString(
                        "email"
                )
        );

        patient.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        return patient;
    }


    @Override
    public String generatePatientNumber() {

        String sql = """
                SELECT patient_number
                FROM patient
                ORDER BY patient_id DESC
                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                String lastNumber =
                        resultSet.getString(
                                "patient_number"
                        );

                int number =
                        Integer.parseInt(
                                lastNumber.substring(1)
                        );

                number++;

                return String.format(
                        "P%06d",
                        number
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return "P000001";
    }
}