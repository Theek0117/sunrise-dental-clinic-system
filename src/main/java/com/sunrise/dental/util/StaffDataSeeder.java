package com.sunrise.dental.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class StaffDataSeeder {

    public static void main(String[] args) {

        String sql = """
                INSERT INTO staff
                (name, username, password, contact_number, role, status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            // =========================================
            // ADMIN
            // Username: admin
            // Password: Admin@123
            // =========================================

            statement.setString(
                    1,
                    "System Administrator"
            );

            statement.setString(
                    2,
                    "admin"
            );

            statement.setString(
                    3,
                    PasswordUtil.hashPassword("Admin@123")
            );

            statement.setString(
                    4,
                    "0770000001"
            );

            statement.setString(
                    5,
                    "ADMIN"
            );

            statement.setString(
                    6,
                    "ACTIVE"
            );

            statement.executeUpdate();


            // =========================================
            // RECEPTIONIST
            // Username: reception
            // Password: Reception@123
            // =========================================

            statement.setString(
                    1,
                    "Front Desk Reception"
            );

            statement.setString(
                    2,
                    "reception"
            );

            statement.setString(
                    3,
                    PasswordUtil.hashPassword(
                            "Reception@123"
                    )
            );

            statement.setString(
                    4,
                    "0770000002"
            );

            statement.setString(
                    5,
                    "RECEPTION"
            );

            statement.setString(
                    6,
                    "ACTIVE"
            );

            statement.executeUpdate();


            // =========================================
            // CASHIER
            // Username: cashier
            // Password: Cashier@123
            // =========================================

            statement.setString(
                    1,
                    "Clinic Cashier"
            );

            statement.setString(
                    2,
                    "cashier"
            );

            statement.setString(
                    3,
                    PasswordUtil.hashPassword(
                            "Cashier@123"
                    )
            );

            statement.setString(
                    4,
                    "0770000003"
            );

            statement.setString(
                    5,
                    "CASHIER"
            );

            statement.setString(
                    6,
                    "ACTIVE"
            );

            statement.executeUpdate();


            System.out.println(
                    "================================="
            );

            System.out.println(
                    "Staff accounts created successfully."
            );

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "ADMIN     : admin / Admin@123"
            );

            System.out.println(
                    "RECEPTION : reception / Reception@123"
            );

            System.out.println(
                    "CASHIER   : cashier / Cashier@123"
            );

        } catch (Exception e) {

            System.err.println(
                    "Failed to create staff accounts."
            );

            e.printStackTrace();
        }
    }
}