package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.Receptionist;

public interface ReceptionistDAO {

    List<Receptionist> findAll();

    List<Receptionist> findAllActive();

    Receptionist findById(int receptionistId);

    Receptionist findByStaffId(int staffId);

    String generateReceptionistNumber();

    boolean save(Receptionist receptionist);

    boolean update(Receptionist receptionist);

    boolean updateStatus(int receptionistId, String status);
}