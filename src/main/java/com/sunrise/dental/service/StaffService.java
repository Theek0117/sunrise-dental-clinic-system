package com.sunrise.dental.service;

import java.util.List;

import com.sunrise.dental.dao.CashierDAO;
import com.sunrise.dental.dao.CashierDAOImpl;
import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.dao.ReceptionistDAO;
import com.sunrise.dental.dao.ReceptionistDAOImpl;
import com.sunrise.dental.dao.StaffDAO;
import com.sunrise.dental.dao.StaffDAOImpl;

import com.sunrise.dental.model.Cashier;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Receptionist;
import com.sunrise.dental.model.Staff;

public class StaffService {

    private final StaffDAO staffDAO;
    private final DentistDAO dentistDAO;
    private final ReceptionistDAO receptionistDAO;
    private final CashierDAO cashierDAO;

    public StaffService() {

        this.staffDAO = new StaffDAOImpl();
        this.dentistDAO = new DentistDAOImpl();
        this.receptionistDAO = new ReceptionistDAOImpl();
        this.cashierDAO = new CashierDAOImpl();
    }

    /*
     * ==========================================
     * GET ALL STAFF
     * ==========================================
     */

    public List<Staff> getAllStaff() {

        return staffDAO.findAll();
    }

    /*
     * ==========================================
     * SEARCH STAFF
     * ==========================================
     */

    public List<Staff> searchStaff(String keyword) {

        if (keyword == null || keyword.isBlank()) {

            return staffDAO.findAll();
        }

        return staffDAO.search(keyword.trim());
    }

    /*
     * ==========================================
     * GET STAFF BY ID
     * ==========================================
     */

    public Staff getStaffById(int staffId) {

        if (staffId <= 0) {

            return null;
        }

        return staffDAO.findById(staffId);
    }

    /*
     * ==========================================
     * CHECK USERNAME
     * ==========================================
     */

    public boolean usernameExists(String username) {

        if (username == null || username.isBlank()) {

            return false;
        }

        return staffDAO.existsByUsername(
                username.trim()
        );
    }

    /*
     * ==========================================
     * ADD RECEPTIONIST
     * ==========================================
     */

    public boolean addReceptionist(
            String name,
            String username,
            String contactNumber,
            String email) {

        if (!isValidStaffInput(
                name,
                username,
                contactNumber)) {

            return false;
        }

        if (usernameExists(username)) {

            return false;
        }

        Staff staff = new Staff();

        staff.setName(name.trim());
        staff.setUsername(username.trim());
        staff.setPassword("receptionist@123");
        staff.setContactNumber(contactNumber.trim());
        staff.setRole("RECEPTION");
        staff.setStatus("ACTIVE");

        if (!staffDAO.save(staff)) {

            return false;
        }

        Staff savedStaff =
                staffDAO.findByUsername(
                        username.trim()
                );

        if (savedStaff == null) {

            return false;
        }

        Receptionist receptionist =
                new Receptionist();

        receptionist.setStaffId(
                savedStaff.getStaffId()
        );

        receptionist.setReceptionistNumber(
                receptionistDAO.generateReceptionistNumber()
        );

        receptionist.setName(
                name.trim()
        );

        receptionist.setContactNumber(
                contactNumber.trim()
        );

        receptionist.setEmail(
                cleanNullable(email)
        );

        receptionist.setStatus("ACTIVE");

        return receptionistDAO.save(
                receptionist
        );
    }

    /*
     * ==========================================
     * ADD CASHIER
     * ==========================================
     */

    public boolean addCashier(
            String name,
            String username,
            String contactNumber,
            String email) {

        if (!isValidStaffInput(
                name,
                username,
                contactNumber)) {

            return false;
        }

        if (usernameExists(username)) {

            return false;
        }

        Staff staff = new Staff();

        staff.setName(name.trim());
        staff.setUsername(username.trim());
        staff.setPassword("cashier@123");
        staff.setContactNumber(contactNumber.trim());
        staff.setRole("CASHIER");
        staff.setStatus("ACTIVE");

        if (!staffDAO.save(staff)) {

            return false;
        }

        Staff savedStaff =
                staffDAO.findByUsername(
                        username.trim()
                );

        if (savedStaff == null) {

            return false;
        }

        Cashier cashier =
                new Cashier();

        cashier.setStaffId(
                savedStaff.getStaffId()
        );

        cashier.setCashierNumber(
                cashierDAO.generateCashierNumber()
        );

        cashier.setName(
                name.trim()
        );

        cashier.setContactNumber(
                contactNumber.trim()
        );

        cashier.setEmail(
                cleanNullable(email)
        );

        cashier.setStatus("ACTIVE");

        return cashierDAO.save(
                cashier
        );
    }

    /*
     * ==========================================
     * ADD DENTIST
     * ==========================================
     */

    public boolean addDentist(
            String name,
            String username,
            String contactNumber,
            String email,
            String nic,
            String specialization,
            String roomNumber) {

        if (!isValidStaffInput(
                name,
                username,
                contactNumber)) {

            return false;
        }

        if (isBlank(nic)
                || isBlank(specialization)
                || isBlank(roomNumber)) {

            return false;
        }

        if (usernameExists(username)) {

            return false;
        }

        Staff staff = new Staff();

        staff.setName(name.trim());
        staff.setUsername(username.trim());
        staff.setPassword("dentist@123");
        staff.setContactNumber(contactNumber.trim());
        staff.setRole("DENTIST");
        staff.setStatus("ACTIVE");

        if (!staffDAO.save(staff)) {

            return false;
        }

        Staff savedStaff =
                staffDAO.findByUsername(
                        username.trim()
                );

        if (savedStaff == null) {

            return false;
        }

        Dentist dentist = new Dentist();

        dentist.setStaffId(
                savedStaff.getStaffId()
        );

        dentist.setDentistNumber(
                dentistDAO.generateDentistNumber()
        );

        dentist.setName(
                name.trim()
        );

        dentist.setRoomNumber(
                roomNumber.trim()
        );

        dentist.setNic(
                nic.trim()
        );

        dentist.setSpecialization(
                specialization.trim()
        );

        dentist.setContactNumber(
                contactNumber.trim()
        );

        dentist.setEmail(
                cleanNullable(email)
        );

        dentist.setStatus("ACTIVE");

        return dentistDAO.save(dentist);
    }

    /*
     * ==========================================
     * UPDATE STAFF DETAILS
     * ==========================================
     */

    public boolean updateStaffDetails(
            int staffId,
            String name,
            String username,
            String contactNumber,
            String email) {

        if (staffId <= 0
                || isBlank(name)
                || isBlank(username)
                || isBlank(contactNumber)) {

            return false;
        }

        name = name.trim();
        username = username.trim();
        contactNumber = contactNumber.trim();
        email = cleanNullable(email);

        /*
         * Validate username
         */

        if (!username.matches("[A-Za-z]+")) {

            return false;
        }

        /*
         * Get existing staff
         */

        Staff existingStaff =
                staffDAO.findById(staffId);

        if (existingStaff == null) {

            return false;
        }

        /*
         * Check username duplication
         */

        if (!username.equalsIgnoreCase(
                existingStaff.getUsername())) {

            if (staffDAO.existsByUsername(username)) {

                return false;
            }
        }

        /*
         * Update staff table
         */

        existingStaff.setName(name);
        existingStaff.setUsername(username);
        existingStaff.setContactNumber(contactNumber);

        if (!staffDAO.update(existingStaff)) {

            return false;
        }

        /*
         * Update role-specific table
         */

        String role = existingStaff.getRole();

        /*
         * DENTIST
         */

        if ("DENTIST".equalsIgnoreCase(role)) {

            Dentist dentist =
                    dentistDAO.findByStaffId(staffId);

            if (dentist == null) {

                return false;
            }

            dentist.setName(name);
            dentist.setContactNumber(contactNumber);
            dentist.setEmail(email);

            return dentistDAO.update(dentist);
        }

        /*
         * RECEPTIONIST
         */

        if ("RECEPTION".equalsIgnoreCase(role)
                || "RECEPTIONIST".equalsIgnoreCase(role)) {

            Receptionist receptionist =
                    receptionistDAO.findByStaffId(staffId);

            if (receptionist == null) {

                return false;
            }

            receptionist.setName(name);
            receptionist.setContactNumber(contactNumber);
            receptionist.setEmail(email);

            return receptionistDAO.update(
                    receptionist
            );
        }

        /*
         * CASHIER
         */

        if ("CASHIER".equalsIgnoreCase(role)) {

            Cashier cashier =
                    cashierDAO.findByStaffId(staffId);

            if (cashier == null) {

                return false;
            }

            cashier.setName(name);
            cashier.setContactNumber(contactNumber);
            cashier.setEmail(email);

            return cashierDAO.update(cashier);
        }

        /*
         * ADMIN
         *
         * Staff table has already been updated.
         */

        return true;
    }

    /*
     * ==========================================
     * CHANGE STAFF STATUS
     * ==========================================
     */

    public boolean changeStaffStatus(
            int staffId,
            String status) {

        if (staffId <= 0
                || isBlank(status)) {

            return false;
        }

        String normalizedStatus =
                status.trim().toUpperCase();

        if (!normalizedStatus.equals("ACTIVE")
                && !normalizedStatus.equals("INACTIVE")) {

            return false;
        }

        /*
         * Get staff
         */

        Staff staff =
                staffDAO.findById(staffId);

        if (staff == null) {

            return false;
        }

        /*
         * Update main staff table
         */

        if (!staffDAO.updateStatus(
                staffId,
                normalizedStatus)) {

            return false;
        }

        String role = staff.getRole();

        /*
         * DENTIST
         */

        if ("DENTIST".equalsIgnoreCase(role)) {

            Dentist dentist =
                    dentistDAO.findByStaffId(staffId);

            if (dentist == null) {

                return false;
            }

            return dentistDAO.updateStatus(
                    dentist.getDentistId(),
                    normalizedStatus
            );
        }

        /*
         * RECEPTIONIST
         */

        if ("RECEPTION".equalsIgnoreCase(role)
                || "RECEPTIONIST".equalsIgnoreCase(role)) {

            Receptionist receptionist =
                    receptionistDAO.findByStaffId(staffId);

            if (receptionist == null) {

                return false;
            }

            return receptionistDAO.updateStatus(
                    receptionist.getReceptionistId(),
                    normalizedStatus
            );
        }

        /*
         * CASHIER
         */

        if ("CASHIER".equalsIgnoreCase(role)) {

            Cashier cashier =
                    cashierDAO.findByStaffId(staffId);

            if (cashier == null) {

                return false;
            }

            return cashierDAO.updateStatus(
                    cashier.getCashierId(),
                    normalizedStatus
            );
        }

        /*
         * ADMIN
         */

        return true;
    }

    /*
     * ==========================================
     * RESET PASSWORD
     * ==========================================
     */

    public boolean resetPassword(
            int staffId,
            String newPassword) {

        if (staffId <= 0
                || isBlank(newPassword)) {

            return false;
        }

        if (newPassword.trim().length() < 6) {

            return false;
        }

        Staff staff =
                staffDAO.findById(staffId);

        if (staff == null) {

            return false;
        }

        return staffDAO.updatePassword(
                staffId,
                newPassword.trim()
        );
    }

    /*
     * ==========================================
     * DEFAULT PASSWORD
     * ==========================================
     */

    public String generateDefaultPassword(
            String role) {

        if (role == null) {

            return null;
        }

        return switch (
                role.trim().toUpperCase()) {

            case "DENTIST" ->
                    "dentist@123";

            case "CASHIER" ->
                    "cashier@123";

            case "RECEPTION",
                 "RECEPTIONIST" ->
                    "receptionist@123";

            default ->
                    null;
        };
    }

    /*
     * ==========================================
     * STAFF COUNTS
     * ==========================================
     */

    public int getTotalStaff() {

        return staffDAO.findAll().size();
    }

    public int getActiveStaffCount() {

        return staffDAO.findAllActive().size();
    }

    /*
     * ==========================================
     * VALIDATION
     * ==========================================
     */

    private boolean isValidStaffInput(
            String name,
            String username,
            String contactNumber) {

        if (isBlank(name)
                || isBlank(username)
                || isBlank(contactNumber)) {

            return false;
        }

        if (!username.trim().matches("[A-Za-z]+")) {

            return false;
        }

        return true;
    }

    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }

    private String clean(String value) {

        if (value == null) {

            return "";
        }

        return value.trim();
    }

    private String cleanNullable(String value) {

        if (value == null) {

            return null;
        }

        value = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }
}