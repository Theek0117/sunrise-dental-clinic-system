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
                SELECT staff_id,
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
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Staff> findAll() {

        List<Staff> staffList = new ArrayList<>();

        String sql = """
                SELECT staff_id,
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
                staffList.add(mapStaff(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    @Override
    public List<Staff> findAllActive() {

        List<Staff> staffList = new ArrayList<>();

        String sql = """
                SELECT staff_id,
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
                staffList.add(mapStaff(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    @Override
    public List<Staff> search(String keyword) {

        List<Staff> staffList = new ArrayList<>();

        String sql = """
                SELECT staff_id,
                       name,
                       username,
                       password,
                       contact_number,
                       role,
                       status
                FROM staff
                WHERE name LIKE ?
                   OR username LIKE ?
                   OR contact_number LIKE ?
                   OR role LIKE ?
                ORDER BY staff_id DESC
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            String searchValue =
                    "%" + keyword.trim() + "%";

            statement.setString(1, searchValue);
            statement.setString(2, searchValue);
            statement.setString(3, searchValue);
            statement.setString(4, searchValue);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                while (resultSet.next()) {
                    staffList.add(mapStaff(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    @Override
    public Staff findById(int staffId) {

        String sql = """
                SELECT staff_id,
                       name,
                       username,
                       password,
                       contact_number,
                       role,
                       status
                FROM staff
                WHERE staff_id = ?
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
                    return mapStaff(resultSet);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean existsByUsername(String username) {

        String sql = """
                SELECT staff_id
                FROM staff
                WHERE LOWER(username) = LOWER(?)
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, username.trim());

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean save(Staff staff) {

        String sql = """
                INSERT INTO staff
                (
                    name,
                    username,
                    password,
                    contact_number,
                    role,
                    status
                )
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, staff.getName());
            statement.setString(2, staff.getUsername());
            statement.setString(3, staff.getPassword());
            statement.setString(4, staff.getContactNumber());
            statement.setString(5, staff.getRole());
            statement.setString(6, staff.getStatus());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean update(Staff staff) {

        String sql = """
                UPDATE staff
                SET
                    name = ?,
                    username = ?,
                    contact_number = ?,
                    role = ?
                WHERE staff_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, staff.getName());
            statement.setString(2, staff.getUsername());
            statement.setString(3, staff.getContactNumber());
            statement.setString(4, staff.getRole());
            statement.setInt(5, staff.getStaffId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateStatus(
            int staffId,
            String status) {

        String sql = """
                UPDATE staff
                SET status = ?
                WHERE staff_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, status);
            statement.setInt(2, staffId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
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