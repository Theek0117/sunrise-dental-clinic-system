package com.sunrise.dental.dao;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import com.sunrise.dental.model.Payment;

public interface PaymentDAO {

    List<Payment> findAll();

    List<Payment> findByDate(Date date);

    Payment findById(int paymentId);

    Payment findByAppointmentId(int appointmentId);

    String generatePaymentNumber();

    boolean save(Payment payment);

    boolean update(Payment payment);

    int getTodayBillCount();

    int getPendingPaymentCount();

    int getCompletedPaymentCount();

    BigDecimal getTodayRevenue();
}