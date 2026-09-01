package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.PaymentAdditionalCharge;
import com.sunrise.dental.util.DBConnection;

public class PaymentAdditionalChargeDAOImpl implements PaymentAdditionalChargeDAO {

    @Override
    public boolean save(PaymentAdditionalCharge charge) {
        String sql = """
                INSERT INTO payment_additional_charge
                (
                    payment_id,
                    charge_name,
                    amount
                )
                VALUES (?, ?, ?)
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            statement.setInt(1, charge.getPaymentId());
            statement.setString(2, charge.getChargeName());
            statement.setBigDecimal(3, charge.getAmount());

            int rows = statement.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (keys.next()) {
                        charge.setAdditionalChargeId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean saveAll(List<PaymentAdditionalCharge> charges) {
        if (charges == null || charges.isEmpty()) {
            return true;
        }

        String sql = """
                INSERT INTO payment_additional_charge
                (
                    payment_id,
                    charge_name,
                    amount
                )
                VALUES (?, ?, ?)
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            for (PaymentAdditionalCharge charge : charges) {
                statement.setInt(1, charge.getPaymentId());
                statement.setString(2, charge.getChargeName());
                statement.setBigDecimal(3, charge.getAmount());
                statement.addBatch();
            }
            statement.executeBatch();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<PaymentAdditionalCharge> findByPaymentId(int paymentId) {
        List<PaymentAdditionalCharge> charges = new ArrayList<>();
        String sql = """
                SELECT
                    additional_charge_id,
                    payment_id,
                    charge_name,
                    amount,
                    created_at
                FROM payment_additional_charge
                WHERE payment_id = ?
                ORDER BY additional_charge_id ASC
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, paymentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    PaymentAdditionalCharge charge = new PaymentAdditionalCharge();
                    charge.setAdditionalChargeId(resultSet.getInt("additional_charge_id"));
                    charge.setPaymentId(resultSet.getInt("payment_id"));
                    charge.setChargeName(resultSet.getString("charge_name"));
                    charge.setAmount(resultSet.getBigDecimal("amount"));
                    charge.setCreatedAt(resultSet.getTimestamp("created_at"));
                    charges.add(charge);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return charges;
    }
}
