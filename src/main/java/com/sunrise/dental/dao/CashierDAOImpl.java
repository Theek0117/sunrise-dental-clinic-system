package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Cashier;
import com.sunrise.dental.util.DBConnection;

public class CashierDAOImpl implements CashierDAO {

    @Override
    public List<Cashier> findAll() {

        List<Cashier> cashierList = new ArrayList<>();

        String sql = """
                SELECT
                    cashier_id,
                    staff_id,
                    cashier_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM cashier
                ORDER BY cashier_id DESC
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                cashierList.add(
                        mapCashier(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return cashierList;
    }

    @Override
    public List<Cashier> findAllActive() {

        List<Cashier> cashierList = new ArrayList<>();

        String sql = """
                SELECT
                    cashier_id,
                    staff_id,
                    cashier_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM cashier
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

                cashierList.add(
                        mapCashier(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return cashierList;
    }

    @Override
    public Cashier findById(int cashierId) {

        String sql = """
                SELECT
                    cashier_id,
                    staff_id,
                    cashier_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM cashier
                WHERE cashier_id = ?
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, cashierId);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapCashier(resultSet);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Cashier findByStaffId(int staffId) {

        String sql = """
                SELECT
                    cashier_id,
                    staff_id,
                    cashier_number,
                    name,
                    contact_number,
                    email,
                    status
                FROM cashier
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

                    return mapCashier(resultSet);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public String generateCashierNumber() {

        String sql = """
                SELECT cashier_number
                FROM cashier
                ORDER BY cashier_id DESC
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
                        resultSet.getString("cashier_number");

                if (lastNumber != null
                        && lastNumber.matches("C\\d+")) {

                    int number =
                            Integer.parseInt(
                                    lastNumber.substring(1)
                            );

                    return String.format(
                            "C%03d",
                            number + 1
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return "C001";
    }

    @Override
    public boolean save(Cashier cashier) {

        String sql = """
                INSERT INTO cashier
                (
                    staff_id,
                    cashier_number,
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
                    cashier.getStaffId()
            );

            statement.setString(
                    2,
                    cashier.getCashierNumber()
            );

            statement.setString(
                    3,
                    cashier.getName()
            );

            statement.setString(
                    4,
                    cashier.getContactNumber()
            );

            statement.setString(
                    5,
                    cashier.getEmail()
            );

            statement.setString(
                    6,
                    cashier.getStatus()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean update(Cashier cashier) {

        String sql = """
                UPDATE cashier
                SET
                    name = ?,
                    contact_number = ?,
                    email = ?
                WHERE cashier_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    cashier.getName()
            );

            statement.setString(
                    2,
                    cashier.getContactNumber()
            );

            statement.setString(
                    3,
                    cashier.getEmail()
            );

            statement.setInt(
                    4,
                    cashier.getCashierId()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateStatus(
            int cashierId,
            String status) {

        String sql = """
                UPDATE cashier
                SET status = ?
                WHERE cashier_id = ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, status);
            statement.setInt(2, cashierId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    private Cashier mapCashier(
            ResultSet resultSet)
            throws Exception {

        Cashier cashier = new Cashier();

        cashier.setCashierId(
                resultSet.getInt("cashier_id")
        );

        cashier.setStaffId(
                resultSet.getInt("staff_id")
        );

        cashier.setCashierNumber(
                resultSet.getString("cashier_number")
        );

        cashier.setName(
                resultSet.getString("name")
        );

        cashier.setContactNumber(
                resultSet.getString("contact_number")
        );

        cashier.setEmail(
                resultSet.getString("email")
        );

        cashier.setStatus(
                resultSet.getString("status")
        );

        return cashier;
    }
}