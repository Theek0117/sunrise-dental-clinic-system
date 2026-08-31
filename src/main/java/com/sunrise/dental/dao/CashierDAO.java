package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.Cashier;

public interface CashierDAO {

    List<Cashier> findAll();

    List<Cashier> findAllActive();

    Cashier findById(int cashierId);

    Cashier findByStaffId(int staffId);

    String generateCashierNumber();

    boolean save(Cashier cashier);

    boolean update(Cashier cashier);

    boolean updateStatus(int cashierId, String status);
}