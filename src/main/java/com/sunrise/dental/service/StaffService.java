package com.sunrise.dental.service;

import java.util.List;

import com.sunrise.dental.dao.StaffDAO;
import com.sunrise.dental.dao.StaffDAOImpl;
import com.sunrise.dental.model.Staff;

public class StaffService {

    private final StaffDAO staffDAO;

    public StaffService() {
        this.staffDAO = new StaffDAOImpl();
    }

    public Staff getStaffByUsername(String username) {

        if (username == null || username.isBlank()) {
            return null;
        }

        return staffDAO.findByUsername(username.trim());
    }

    public List<Staff> getAllStaff() {
        return staffDAO.findAll();
    }

    public List<Staff> getActiveStaff() {
        return staffDAO.findAllActive();
    }

    public int getTotalStaff() {
        return staffDAO.countAll();
    }

    public int getActiveStaffCount() {
        return staffDAO.countActive();
    }
}