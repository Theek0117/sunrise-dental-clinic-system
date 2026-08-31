package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.util.DBConnection;

public class DentistDAOImpl implements DentistDAO {

    @Override
    public List<Dentist> findAllActive() {

        List<Dentist> dentists = new ArrayList<>();

        String sql = """
                SELECT
                    d.dentist_id,
                    d.staff_id,
                    d.dentist_number,
                    d.name,
                    d.room_number,
                    d.nic,
                    d.specialization,
                    d.contact_number,
                    d.email,
                    d.status
                FROM dentist d
                INNER JOIN staff s
                    ON d.staff_id = s.staff_id
                WHERE d.status = 'ACTIVE'
                  AND s.role = 'DENTIST'
                  AND s.status = 'ACTIVE'
                ORDER BY d.name
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {
                dentists.add(mapDentist(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dentists;
    }

    @Override
    public Dentist findById(int dentistId) {

        String sql = """
                SELECT
                    d.dentist_id,
                    d.staff_id,
                    d.dentist_number,
                    d.name,
                    d.room_number,
                    d.nic,
                    d.specialization,
                    d.contact_number,
                    d.email,
                    d.status
                FROM dentist d
                INNER JOIN staff s
                    ON d.staff_id = s.staff_id
                WHERE d.dentist_id = ?
                  AND d.status = 'ACTIVE'
                  AND s.role = 'DENTIST'
                  AND s.status = 'ACTIVE'
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, dentistId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapDentist(resultSet);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private Dentist mapDentist(ResultSet resultSet)
            throws Exception {

        Dentist dentist = new Dentist();

        dentist.setDentistId(
                resultSet.getInt("dentist_id")
        );

        dentist.setStaffId(
                resultSet.getInt("staff_id")
        );

        dentist.setDentistNumber(
                resultSet.getString("dentist_number")
        );

        dentist.setName(
                resultSet.getString("name")
        );

        dentist.setRoomNumber(
                resultSet.getString("room_number")
        );

        dentist.setNic(
                resultSet.getString("nic")
        );

        dentist.setSpecialization(
                resultSet.getString("specialization")
        );

        dentist.setContactNumber(
                resultSet.getString("contact_number")
        );

        dentist.setEmail(
                resultSet.getString("email")
        );

        dentist.setStatus(
                resultSet.getString("status")
        );

        return dentist;
    }
    
    @Override
    public Dentist findByStaffId(int staffId) {

        String sql = """
                SELECT
                    d.dentist_id,
                    d.staff_id,
                    d.dentist_number,
                    d.name,
                    d.room_number,
                    d.nic,
                    d.specialization,
                    d.contact_number,
                    d.email,
                    d.status
                FROM dentist d
                INNER JOIN staff s
                    ON d.staff_id = s.staff_id
                WHERE d.staff_id = ?
                  
                  AND s.role = 'DENTIST'
                  
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, staffId);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapDentist(resultSet);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }
    
    
    @Override
    public String generateDentistNumber() {

        String sql = """
                SELECT dentist_number
                FROM dentist
                ORDER BY dentist_id DESC
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                String lastNumber =
                        resultSet.getString("dentist_number");

                if (lastNumber != null
                        && lastNumber.matches("D\\d+")) {

                    int number =
                            Integer.parseInt(
                                    lastNumber.substring(1)
                            );

                    return String.format(
                            "D%03d",
                            number + 1
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "D001";
    }
    
    @Override
    public boolean save(Dentist dentist) {

        String sql = """
                INSERT INTO dentist
                (
                    staff_id,
                    dentist_number,
                    name,
                    room_number,
                    nic,
                    specialization,
                    contact_number,
                    email,
                    status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    dentist.getStaffId()
            );

            statement.setString(
                    2,
                    dentist.getDentistNumber()
            );

            statement.setString(
                    3,
                    dentist.getName()
            );

            statement.setString(
                    4,
                    dentist.getRoomNumber()
            );

            statement.setString(
                    5,
                    dentist.getNic()
            );

            statement.setString(
                    6,
                    dentist.getSpecialization()
            );

            statement.setString(
                    7,
                    dentist.getContactNumber()
            );

            statement.setString(
                    8,
                    dentist.getEmail()
            );

            statement.setString(
                    9,
                    dentist.getStatus()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
    
    @Override
    public boolean update(Dentist dentist) {

        String sql = """
                UPDATE dentist
                SET
                    name = ?,
                    room_number = ?,
                    nic = ?,
                    specialization = ?,
                    contact_number = ?,
                    email = ?
                WHERE dentist_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    dentist.getName()
            );

            statement.setString(
                    2,
                    dentist.getRoomNumber()
            );

            statement.setString(
                    3,
                    dentist.getNic()
            );

            statement.setString(
                    4,
                    dentist.getSpecialization()
            );

            statement.setString(
                    5,
                    dentist.getContactNumber()
            );

            statement.setString(
                    6,
                    dentist.getEmail()
            );

            statement.setInt(
                    7,
                    dentist.getDentistId()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
    
    @Override
    public boolean updateStatus(
            int dentistId,
            String status) {

        String sql = """
                UPDATE dentist
                SET status = ?
                WHERE dentist_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, status);
            statement.setInt(2, dentistId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
    
}