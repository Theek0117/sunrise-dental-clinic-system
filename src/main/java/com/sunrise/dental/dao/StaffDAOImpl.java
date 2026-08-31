package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Staff;
import com.sunrise.dental.util.DBConnection;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public Staff findByUsername(String username) {

        String sql = """
                SELECT
                    staff_id,
                    name,
                    username,
                    password,
                    contact_number,
                    role,
                    status
                FROM staff
                WHERE username = ?
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, username);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapStaff(resultSet);
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "ERROR: Unable to find staff by username."
            );

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Staff> findAll() {

        List<Staff> staffList = new ArrayList<>();

        String sql = """
                SELECT
                    staff_id,
                    name,
                    username,
                    password,
                    contact_number,
                    role,
                    status
                FROM staff
                ORDER BY staff_id DESC
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {
                staffList.add(
                        mapStaff(resultSet)
                );
            }

        } catch (Exception e) {

            System.err.println(
                    "ERROR: Unable to retrieve staff."
            );

            e.printStackTrace();
        }

        return staffList;
    }

    @Override
    public List<Staff> findAllActive() {

        List<Staff> staffList = new ArrayList<>();

        String sql = """
                SELECT
                    staff_id,
                    name,
                    username,
                    password,
                    contact_number,
                    role,
                    status
                FROM staff
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
                staffList.add(
                        mapStaff(resultSet)
                );
            }

        } catch (Exception e) {

            System.err.println(
                    "ERROR: Unable to retrieve active staff."
            );

            e.printStackTrace();
        }

        return staffList;
    }

    @Override
    public int countAll() {

        String sql = """
                SELECT COUNT(*)
                FROM staff
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }

        } catch (Exception e) {

            System.err.println(
                    "ERROR: Unable to count staff."
            );

            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int countActive() {

        String sql = """
                SELECT COUNT(*)
                FROM staff
                WHERE status = 'ACTIVE'
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }

        } catch (Exception e) {

            System.err.println(
                    "ERROR: Unable to count active staff."
            );

            e.printStackTrace();
        }

        return 0;
    }

    private Staff mapStaff(ResultSet resultSet)
            throws Exception {

        Staff staff = new Staff();

        staff.setStaffId(
                resultSet.getInt("staff_id")
        );

        staff.setName(
                resultSet.getString("name")
        );

        staff.setUsername(
                resultSet.getString("username")
        );

        staff.setPassword(
                resultSet.getString("password")
        );

        staff.setContactNumber(
                resultSet.getString("contact_number")
        );

        staff.setRole(
                resultSet.getString("role")
        );

        staff.setStatus(
                resultSet.getString("status")
        );

        return staff;
    }
}