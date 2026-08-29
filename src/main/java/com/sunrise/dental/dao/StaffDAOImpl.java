package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    Staff staff = new Staff();

                    staff.setStaffId(resultSet.getInt("staff_id"));
                    staff.setName(resultSet.getString("name"));
                    staff.setUsername(resultSet.getString("username"));
                    staff.setPassword(resultSet.getString("password"));
                    staff.setContactNumber(
                            resultSet.getString("contact_number")
                    );
                    staff.setRole(resultSet.getString("role"));
                    staff.setStatus(resultSet.getString("status"));

                    return staff;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }
}