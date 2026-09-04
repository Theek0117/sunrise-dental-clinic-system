package com.sunrise.dental.test;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrise.dental.dao.PaymentDAO;
import com.sunrise.dental.dao.PaymentDAOImpl;
import com.sunrise.dental.model.Payment;

/**
 * J09: Payment DAO Database Test
 * Layer: DAO / Database Integration
 */
public class J09_PaymentDaoTest {

    private PaymentDAO paymentDAO;

    @BeforeEach
    void setUp() {
        paymentDAO = new PaymentDAOImpl();
    }

    @Test
    @DisplayName("Test finding payment record with invalid appointment ID returns null")
    void testFindByInvalidAppointmentId() {
        Payment payment = paymentDAO.findByAppointmentId(-999);
        assertNull(payment, "Non-existent appointment payment should return null");
    }

    @Test
    @DisplayName("Test generating unique payment invoice number starts with 'INV'")
    void testGeneratePaymentNumber() {
        String receiptNumber = paymentDAO.generatePaymentNumber();
        assertNotNull(receiptNumber, "Generated payment receipt number should not be null");
        assertTrue(receiptNumber.startsWith("INV"), "Receipt number should follow clinic prefix convention 'INV'");
    }
}

