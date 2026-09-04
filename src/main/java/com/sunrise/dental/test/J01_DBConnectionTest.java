package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Connection;
import java.sql.SQLException;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.util.DBConnection;

/**
 * J01: Database Connection Integration Test
 * Layer: Utility / Database Connectivity
 */
public class J01_DBConnectionTest {

    @Test
    @DisplayName("Test establishing active MySQL database connection")
    void testDatabaseConnection() throws SQLException {
        Connection connection = DBConnection.getConnection();
        assertNotNull(connection, "Database connection should not be null");
        assertFalse(connection.isClosed(), "Database connection should be active and open");
        connection.close();
    }
}
