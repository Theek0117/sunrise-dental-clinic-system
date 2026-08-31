package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Receptionist;
import com.sunrise.dental.util.DBConnection;

public class ReceptionistDAOImpl implements ReceptionistDAO {

    @Override
    public List<Receptionist> findAll() {

        List<Receptionist> receptionistList = new ArrayList<>();

        String sql = """
                SELECT
                    receptionist_id,
                    staff_id,
                    receptionist_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM receptionist
                ORDER BY receptionist_id DESC
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                receptionistList.add(
                        mapReceptionist(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return receptionistList;
    }

    @Override
    public List<Receptionist> findAllActive() {

        List<Receptionist> receptionistList = new ArrayList<>();

        String sql = """
                SELECT
                    receptionist_id,
                    staff_id,
                    receptionist_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM receptionist
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

                receptionistList.add(
                        mapReceptionist(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return receptionistList;
    }

    @Override
    public Receptionist findById(int receptionistId) {

        String sql = """
                SELECT
                    receptionist_id,
                    staff_id,
                    receptionist_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM receptionist
                WHERE receptionist_id = ?
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, receptionistId);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapReceptionist(resultSet);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Receptionist findByStaffId(int staffId) {

        String sql = """
                SELECT
                    receptionist_id,
                    staff_id,
                    receptionist_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM receptionist
                WHERE staff_id = ?
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, staffId);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapReceptionist(resultSet);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public String generateReceptionistNumber() {

        String sql = """
                SELECT receptionist_number
                FROM receptionist
                ORDER BY receptionist_id DESC
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
                        resultSet.getString("receptionist_number");

                if (lastNumber != null
                        && lastNumber.matches("R\\d+")) {

                    int number =
                            Integer.parseInt(
                                    lastNumber.substring(1)
                            );

                    return String.format(
                            "R%03d",
                            number + 1
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return "R001";
    }

    @Override
    public boolean save(Receptionist receptionist) {

        String sql = """
                INSERT INTO receptionist
                (
                    staff_id,
                    receptionist_number,
                    name,
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

            statement.setInt(
                    1,
                    receptionist.getStaffId()
            );

            statement.setString(
                    2,
                    receptionist.getReceptionistNumber()
            );

            statement.setString(
                    3,
                    receptionist.getName()
            );

            statement.setString(
                    4,
                    receptionist.getContactNumber()
            );

            statement.setString(
                    5,
                    receptionist.getEmail()
            );

            statement.setString(
                    6,
                    receptionist.getStatus()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean update(Receptionist receptionist) {

        String sql = """
                UPDATE receptionist
                SET
                    name = ?,
                    contact_number = ?,
                    email = ?
                WHERE receptionist_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    receptionist.getName()
            );

            statement.setString(
                    2,
                    receptionist.getContactNumber()
            );

            statement.setString(
                    3,
                    receptionist.getEmail()
            );

            statement.setInt(
                    4,
                    receptionist.getReceptionistId()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateStatus(
            int receptionistId,
            String status) {

        String sql = """
                UPDATE receptionist
                SET status = ?
                WHERE receptionist_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, status);
            statement.setInt(2, receptionistId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    private Receptionist mapReceptionist(
            ResultSet resultSet)
            throws Exception {

        Receptionist receptionist =
                new Receptionist();

        receptionist.setReceptionistId(
                resultSet.getInt("receptionist_id")
        );

        receptionist.setStaffId(
                resultSet.getInt("staff_id")
        );

        receptionist.setReceptionistNumber(
                resultSet.getString("receptionist_number")
        );

        receptionist.setName(
                resultSet.getString("name")
        );

        receptionist.setContactNumber(
                resultSet.getString("contact_number")
        );

        receptionist.setEmail(
                resultSet.getString("email")
        );

        receptionist.setStatus(
                resultSet.getString("status")
        );

        return receptionist;
    }
}