package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.Staff;

public interface StaffDAO {

    Staff findByUsername(String username);

    List<Staff> findAll();

    List<Staff> findAllActive();

    int countAll();

    int countActive();
}