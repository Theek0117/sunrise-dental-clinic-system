package com.sunrise.dental.service;

import com.sunrise.dental.dao.StaffDAO;
import com.sunrise.dental.dao.StaffDAOImpl;
import com.sunrise.dental.model.Staff;
import com.sunrise.dental.util.PasswordUtil;

public class AuthenticationService {

    private final StaffDAO staffDAO;

    public AuthenticationService() {
        this.staffDAO = new StaffDAOImpl();
    }

    public Staff authenticate(
            String username,
            String password) {

        if (username == null ||
            password == null ||
            username.trim().isEmpty() ||
            password.isEmpty()) {

            return null;
        }

        Staff staff =
                staffDAO.findByUsername(username.trim());

        if (staff == null) {
            return null;
        }

        if (!"ACTIVE".equalsIgnoreCase(staff.getStatus())) {
            return null;
        }

        boolean validPassword =
                PasswordUtil.verifyPassword(
                        password,
                        staff.getPassword()
                );

        if (!validPassword) {
            return null;
        }

        return staff;
    }
}