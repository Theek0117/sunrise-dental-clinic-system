package com.sunrise.dental.service;

import com.sunrise.dental.dao.StaffDAO;
import com.sunrise.dental.dao.StaffDAOImpl;
import com.sunrise.dental.model.Staff;

public class AuthenticationService {

    private final StaffDAO staffDAO;

    public AuthenticationService() {
        this.staffDAO = new StaffDAOImpl();
    }

    public Staff authenticate(String username, String password) {

        // Basic validation
        if (username == null || password == null) {
            return null;
        }

        username = username.trim();

        if (username.isEmpty() || password.isEmpty()) {
            return null;
        }

        // Username must contain letters only
        if (!username.matches("[A-Za-z]+")) {
            return null;
        }

        // Find staff account
        Staff staff = staffDAO.findByUsername(username);

        if (staff == null) {
            return null;
        }

        // Only ACTIVE accounts can login
        if (!"ACTIVE".equalsIgnoreCase(staff.getStatus())) {
            return null;
        }

        // Plain-text password comparison
        if (!password.equals(staff.getPassword())) {
            return null;
        }

        return staff;
    }
}