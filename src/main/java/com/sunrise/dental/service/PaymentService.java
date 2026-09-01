package com.sunrise.dental.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.util.List;

import com.sunrise.dental.dao.PaymentAdditionalChargeDAO;
import com.sunrise.dental.dao.PaymentAdditionalChargeDAOImpl;
import com.sunrise.dental.dao.PaymentDAO;
import com.sunrise.dental.dao.PaymentDAOImpl;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.model.PaymentAdditionalCharge;

public class PaymentService {

    private final PaymentDAO paymentDAO;
    private final PaymentAdditionalChargeDAO additionalChargeDAO;

    public PaymentService() {
        this.paymentDAO = new PaymentDAOImpl();
        this.additionalChargeDAO = new PaymentAdditionalChargeDAOImpl();
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.findAll();
    }

    public List<Payment> getPaymentsByDate(Date date) {
        if (date == null) {
            return List.of();
        }
        return paymentDAO.findByDate(date);
    }

    public Payment getPaymentById(int paymentId) {
        if (paymentId <= 0) {
            return null;
        }
        return paymentDAO.findById(paymentId);
    }

    public Payment getPaymentByAppointmentId(int appointmentId) {
        if (appointmentId <= 0) {
            return null;
        }
        return paymentDAO.findByAppointmentId(appointmentId);
    }

    public List<PaymentAdditionalCharge> getAdditionalChargesByPaymentId(int paymentId) {
        if (paymentId <= 0) {
            return List.of();
        }
        return additionalChargeDAO.findByPaymentId(paymentId);
    }

    public String generatePaymentNumber() {
        return paymentDAO.generatePaymentNumber();
    }

    public boolean savePayment(Payment payment) {
        return savePaymentWithCharges(payment, null);
    }

    public boolean savePaymentWithCharges(Payment payment, List<PaymentAdditionalCharge> charges) {
        if (payment == null) {
            return false;
        }

        if (payment.getAppointmentId() <= 0
                || payment.getPatientId() <= 0
                || payment.getTreatmentTypeId() <= 0) {
            return false;
        }

        if (payment.getBasicAmount() == null) {
            payment.setBasicAmount(BigDecimal.ZERO);
        }
        if (payment.getDoctorFee() == null) {
            payment.setDoctorFee(BigDecimal.ZERO);
        }

        BigDecimal additionalTotal = BigDecimal.ZERO;
        if (charges != null && !charges.isEmpty()) {
            for (PaymentAdditionalCharge c : charges) {
                if (c.getAmount() != null && c.getAmount().compareTo(BigDecimal.ZERO) > 0) {
                    additionalTotal = additionalTotal.add(c.getAmount());
                }
            }
        } else if (payment.getAdditionalAmount() != null) {
            additionalTotal = payment.getAdditionalAmount();
        }
        payment.setAdditionalAmount(additionalTotal);

        // Subtotal = basicAmount + doctorFee + additionalAmount
        BigDecimal subtotal = payment.getBasicAmount()
                .add(payment.getDoctorFee())
                .add(payment.getAdditionalAmount());

        // 5% Tax calculation
        BigDecimal taxRate = new BigDecimal("0.05");
        BigDecimal taxAmount = subtotal.multiply(taxRate).setScale(2, RoundingMode.HALF_UP);
        payment.setTaxAmount(taxAmount);

        // Total = Subtotal + Tax
        BigDecimal totalAmount = subtotal.add(taxAmount).setScale(2, RoundingMode.HALF_UP);
        payment.setTotalAmount(totalAmount);

        if (payment.getPaymentStatus() == null || payment.getPaymentStatus().isBlank()) {
            payment.setPaymentStatus("PAID");
        }

        if (payment.getPaymentMethod() == null || payment.getPaymentMethod().isBlank()) {
            payment.setPaymentMethod("CASH");
        }

        if (payment.getInvoiceNumber() == null || payment.getInvoiceNumber().isBlank()) {
            payment.setInvoiceNumber(paymentDAO.generatePaymentNumber());
        }

        boolean saved = paymentDAO.save(payment);
        if (saved && charges != null && !charges.isEmpty()) {
            for (PaymentAdditionalCharge c : charges) {
                c.setPaymentId(payment.getPaymentId());
            }
            additionalChargeDAO.saveAll(charges);
        }

        return saved;
    }

    public int getTodayBillCount() {
        return paymentDAO.getTodayBillCount();
    }

    public int getPendingPaymentCount() {
        return paymentDAO.getPendingPaymentCount();
    }

    public int getCompletedPaymentCount() {
        return paymentDAO.getCompletedPaymentCount();
    }

    public BigDecimal getTodayRevenue() {
        BigDecimal revenue = paymentDAO.getTodayRevenue();
        return revenue != null ? revenue : BigDecimal.ZERO;
    }
}