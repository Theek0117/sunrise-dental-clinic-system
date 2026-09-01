package com.sunrise.dental.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Payment;
import com.sunrise.dental.util.DBConnection;

public class PaymentDAOImpl implements PaymentDAO {

    // ==========================================
    // FIND ALL PAYMENTS
    // ==========================================
    @Override
    public List<Payment> findAll() {
        List<Payment> payments = new ArrayList<>();
        String sql = """
                SELECT
                    p.payment_id,
                    p.invoice_number,
                    p.appointment_id,
                    p.patient_id,
                    p.treatment_type_id,
                    p.basic_amount,
                    p.doctor_fee,
                    p.tax_amount,
                    p.additional_amount,
                    p.total_amount,
                    p.payment_method,
                    p.payment_status,
                    p.paid_at,
                    p.created_at,
                    p.updated_at,
                    a.appointment_number,
                    pt.name AS patient_name,
                    pt.email AS patient_email,
                    pt.contact_number AS patient_contact,
                    d.name AS dentist_name,
                    tt.treatment_name
                FROM payment p
                INNER JOIN appointment a ON p.appointment_id = a.appointment_id
                INNER JOIN patient pt ON p.patient_id = pt.patient_id
                INNER JOIN dentist d ON a.dentist_id = d.dentist_id
                INNER JOIN treatment_type tt ON p.treatment_type_id = tt.treatment_type_id
                ORDER BY p.payment_id DESC
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {
            while (resultSet.next()) {
                payments.add(mapPayment(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    // ==========================================
    // FIND PAYMENTS BY DATE
    // ==========================================
    @Override
    public List<Payment> findByDate(Date date) {
        List<Payment> payments = new ArrayList<>();
        String sql = """
                SELECT
                    p.payment_id,
                    p.invoice_number,
                    p.appointment_id,
                    p.patient_id,
                    p.treatment_type_id,
                    p.basic_amount,
                    p.doctor_fee,
                    p.tax_amount,
                    p.additional_amount,
                    p.total_amount,
                    p.payment_method,
                    p.payment_status,
                    p.paid_at,
                    p.created_at,
                    p.updated_at,
                    a.appointment_number,
                    pt.name AS patient_name,
                    pt.email AS patient_email,
                    pt.contact_number AS patient_contact,
                    d.name AS dentist_name,
                    tt.treatment_name
                FROM payment p
                INNER JOIN appointment a ON p.appointment_id = a.appointment_id
                INNER JOIN patient pt ON p.patient_id = pt.patient_id
                INNER JOIN dentist d ON a.dentist_id = d.dentist_id
                INNER JOIN treatment_type tt ON p.treatment_type_id = tt.treatment_type_id
                WHERE DATE(p.created_at) = ?
                ORDER BY p.payment_id DESC
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setDate(1, date);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    payments.add(mapPayment(resultSet));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    // ==========================================
    // FIND BY PAYMENT ID
    // ==========================================
    @Override
    public Payment findById(int paymentId) {
        String sql = """
                SELECT
                    p.payment_id,
                    p.invoice_number,
                    p.appointment_id,
                    p.patient_id,
                    p.treatment_type_id,
                    p.basic_amount,
                    p.doctor_fee,
                    p.tax_amount,
                    p.additional_amount,
                    p.total_amount,
                    p.payment_method,
                    p.payment_status,
                    p.paid_at,
                    p.created_at,
                    p.updated_at,
                    a.appointment_number,
                    pt.name AS patient_name,
                    pt.email AS patient_email,
                    pt.contact_number AS patient_contact,
                    d.name AS dentist_name,
                    tt.treatment_name
                FROM payment p
                INNER JOIN appointment a ON p.appointment_id = a.appointment_id
                INNER JOIN patient pt ON p.patient_id = pt.patient_id
                INNER JOIN dentist d ON a.dentist_id = d.dentist_id
                INNER JOIN treatment_type tt ON p.treatment_type_id = tt.treatment_type_id
                WHERE p.payment_id = ?
                LIMIT 1
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, paymentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapPayment(resultSet);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==========================================
    // FIND BY APPOINTMENT
    // ==========================================
    @Override
    public Payment findByAppointmentId(int appointmentId) {
        String sql = """
                SELECT
                    p.payment_id,
                    p.invoice_number,
                    p.appointment_id,
                    p.patient_id,
                    p.treatment_type_id,
                    p.basic_amount,
                    p.doctor_fee,
                    p.tax_amount,
                    p.additional_amount,
                    p.total_amount,
                    p.payment_method,
                    p.payment_status,
                    p.paid_at,
                    p.created_at,
                    p.updated_at,
                    a.appointment_number,
                    pt.name AS patient_name,
                    pt.email AS patient_email,
                    pt.contact_number AS patient_contact,
                    d.name AS dentist_name,
                    tt.treatment_name
                FROM payment p
                INNER JOIN appointment a ON p.appointment_id = a.appointment_id
                INNER JOIN patient pt ON p.patient_id = pt.patient_id
                INNER JOIN dentist d ON a.dentist_id = d.dentist_id
                INNER JOIN treatment_type tt ON p.treatment_type_id = tt.treatment_type_id
                WHERE p.appointment_id = ?
                LIMIT 1
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, appointmentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapPayment(resultSet);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==========================================
    // GENERATE INVOICE NUMBER
    // ==========================================
    @Override
    public String generatePaymentNumber() {
        String sql = """
                SELECT invoice_number
                FROM payment
                ORDER BY payment_id DESC
                LIMIT 1
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {
            if (resultSet.next()) {
                String lastNumber = resultSet.getString("invoice_number");
                if (lastNumber != null && lastNumber.matches("INV\\d+")) {
                    int number = Integer.parseInt(lastNumber.substring(3));
                    return String.format("INV%06d", number + 1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "INV000001";
    }

    // ==========================================
    // SAVE PAYMENT
    // ==========================================
    @Override
    public boolean save(Payment payment) {
        String sql = """
                INSERT INTO payment
                (
                    invoice_number,
                    appointment_id,
                    patient_id,
                    treatment_type_id,
                    basic_amount,
                    doctor_fee,
                    tax_amount,
                    additional_amount,
                    total_amount,
                    payment_method,
                    payment_status,
                    paid_at
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            statement.setString(1, payment.getInvoiceNumber());
            statement.setInt(2, payment.getAppointmentId());
            statement.setInt(3, payment.getPatientId());
            statement.setInt(4, payment.getTreatmentTypeId());
            statement.setBigDecimal(5, payment.getBasicAmount() != null ? payment.getBasicAmount() : BigDecimal.ZERO);
            statement.setBigDecimal(6, payment.getDoctorFee() != null ? payment.getDoctorFee() : BigDecimal.ZERO);
            statement.setBigDecimal(7, payment.getTaxAmount() != null ? payment.getTaxAmount() : BigDecimal.ZERO);
            statement.setBigDecimal(8, payment.getAdditionalAmount() != null ? payment.getAdditionalAmount() : BigDecimal.ZERO);
            statement.setBigDecimal(9, payment.getTotalAmount() != null ? payment.getTotalAmount() : BigDecimal.ZERO);
            statement.setString(10, payment.getPaymentMethod());
            statement.setString(11, payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "PAID");

            int rows = statement.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (keys.next()) {
                        payment.setPaymentId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==========================================
    // UPDATE PAYMENT
    // ==========================================
    @Override
    public boolean update(Payment payment) {
        String sql = """
                UPDATE payment
                SET
                    doctor_fee = ?,
                    tax_amount = ?,
                    additional_amount = ?,
                    total_amount = ?,
                    payment_method = ?,
                    payment_status = ?
                WHERE payment_id = ?
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setBigDecimal(1, payment.getDoctorFee() != null ? payment.getDoctorFee() : BigDecimal.ZERO);
            statement.setBigDecimal(2, payment.getTaxAmount() != null ? payment.getTaxAmount() : BigDecimal.ZERO);
            statement.setBigDecimal(3, payment.getAdditionalAmount() != null ? payment.getAdditionalAmount() : BigDecimal.ZERO);
            statement.setBigDecimal(4, payment.getTotalAmount() != null ? payment.getTotalAmount() : BigDecimal.ZERO);
            statement.setString(5, payment.getPaymentMethod());
            statement.setString(6, payment.getPaymentStatus());
            statement.setInt(7, payment.getPaymentId());

            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==========================================
    // TODAY BILL COUNT
    // ==========================================
    @Override
    public int getTodayBillCount() {
        String sql = """
                SELECT COUNT(*)
                FROM payment
                WHERE DATE(created_at) = CURDATE()
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==========================================
    // PENDING PAYMENT COUNT
    // ==========================================
    @Override
    public int getPendingPaymentCount() {
        String sql = """
                SELECT COUNT(*)
                FROM payment
                WHERE payment_status = 'PENDING'
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==========================================
    // COMPLETED PAYMENT COUNT
    // ==========================================
    @Override
    public int getCompletedPaymentCount() {
        String sql = """
                SELECT COUNT(*)
                FROM payment
                WHERE payment_status = 'PAID'
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==========================================
    // TODAY REVENUE
    // ==========================================
    @Override
    public BigDecimal getTodayRevenue() {
        String sql = """
                SELECT COALESCE(SUM(total_amount), 0)
                FROM payment
                WHERE DATE(paid_at) = CURDATE() AND payment_status = 'PAID'
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {
            if (resultSet.next()) {
                BigDecimal revenue = resultSet.getBigDecimal(1);
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // ==========================================
    // MAP PAYMENT
    // ==========================================
    private Payment mapPayment(ResultSet resultSet) throws Exception {
        Payment payment = new Payment();
        payment.setPaymentId(resultSet.getInt("payment_id"));
        payment.setInvoiceNumber(resultSet.getString("invoice_number"));
        payment.setAppointmentId(resultSet.getInt("appointment_id"));
        payment.setPatientId(resultSet.getInt("patient_id"));
        payment.setTreatmentTypeId(resultSet.getInt("treatment_type_id"));
        payment.setBasicAmount(resultSet.getBigDecimal("basic_amount"));
        payment.setDoctorFee(resultSet.getBigDecimal("doctor_fee"));
        payment.setTaxAmount(resultSet.getBigDecimal("tax_amount"));
        payment.setAdditionalAmount(resultSet.getBigDecimal("additional_amount"));
        payment.setTotalAmount(resultSet.getBigDecimal("total_amount"));
        payment.setPaymentMethod(resultSet.getString("payment_method"));
        payment.setPaymentStatus(resultSet.getString("payment_status"));
        payment.setPaidAt(resultSet.getTimestamp("paid_at"));
        payment.setCreatedAt(resultSet.getTimestamp("created_at"));
        payment.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        payment.setAppointmentNumber(resultSet.getString("appointment_number"));
        payment.setPatientName(resultSet.getString("patient_name"));
        payment.setPatientEmail(resultSet.getString("patient_email"));
        payment.setPatientContact(resultSet.getString("patient_contact"));
        payment.setDentistName(resultSet.getString("dentist_name"));
        payment.setTreatmentName(resultSet.getString("treatment_name"));

        return payment;
    }
}