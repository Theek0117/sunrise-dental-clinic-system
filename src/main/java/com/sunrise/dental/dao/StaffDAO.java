package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.Staff;

public interface StaffDAO {

    Staff findByUsername(String username);

    List<Staff> findAll();

    List<Staff> findAllActive();

    List<Staff> search(String keyword);

    Staff findById(int staffId);

    boolean existsByUsername(String username);

    boolean save(Staff staff);

    boolean update(Staff staff);

    boolean updateStatus(int staffId, String status);

    boolean updatePassword(int staffId, String newPassword);
}