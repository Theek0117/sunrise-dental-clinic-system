package com.sunrise.dental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.model.Staff;
import com.sunrise.dental.service.StaffService;

@WebServlet("/admin/staff")
public class StaffManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffService staffService;

    @Override
    public void init() {

        staffService = new StaffService();
    }

    /*
     * ==========================================
     * GET
     * ==========================================
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * ==========================================
         * ADMIN SESSION CHECK
         * ==========================================
         */

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        /*
         * ==========================================
         * ROLE CHECK
         * ==========================================
         */

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        /*
         * ==========================================
         * SEARCH
         * ==========================================
         */

        String keyword =
                request.getParameter("search");

        List<Staff> staffList;

        if (keyword == null
                || keyword.trim().isEmpty()) {

            staffList =
                    staffService.getAllStaff();

        } else {

            staffList =
                    staffService.searchStaff(keyword);
        }

        /*
         * ==========================================
         * SEND DATA TO JSP
         * ==========================================
         */

        request.setAttribute(
                "staffList",
                staffList
        );

        request.setAttribute(
                "searchKeyword",
                keyword
        );

        /*
         * ==========================================
         * FORWARD
         * ==========================================
         */

        request.getRequestDispatcher(
                "/admin/staffManagement.jsp"
        ).forward(
                request,
                response
        );
    }

    /*
     * ==========================================
     * POST
     * ==========================================
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * ==========================================
         * ADMIN SESSION CHECK
         * ==========================================
         */

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        /*
         * ==========================================
         * ROLE CHECK
         * ==========================================
         */

        String sessionRole =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(sessionRole)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        /*
         * ==========================================
         * ACTION
         * ==========================================
         */

        String action =
                request.getParameter("action");

        if (action == null
                || action.isBlank()) {

            redirectToStaffPage(
                    request,
                    response
            );

            return;
        }

        /*
         * ==========================================
         * ADD
         * ==========================================
         */

        if ("add".equalsIgnoreCase(action)) {

            addStaff(
                    request,
                    response
            );

            return;
        }

        /*
         * ==========================================
         * EDIT
         * ==========================================
         */

        if ("edit".equalsIgnoreCase(action)) {

            editStaff(
                    request,
                    response
            );

            return;
        }

        /*
         * ==========================================
         * CHANGE STATUS
         * ==========================================
         */

        if ("changeStatus".equalsIgnoreCase(action)) {

            changeStaffStatus(
                    request,
                    response
            );

            return;
        }

        /*
         * ==========================================
         * RESET PASSWORD
         * ==========================================
         */

        if ("resetPassword".equalsIgnoreCase(action)) {

            resetStaffPassword(
                    request,
                    response
            );

            return;
        }

        /*
         * ==========================================
         * UNKNOWN ACTION
         * ==========================================
         */

        redirectWithMessage(
                request,
                response,
                "error",
                "Invalid staff management action."
        );
    }

    /*
     * ==========================================
     * ADD STAFF
     * ==========================================
     */

    private void addStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String role =
                request.getParameter("role");

        String name =
                request.getParameter("name");

        String username =
                request.getParameter("username");

        String contactNumber =
                request.getParameter("contactNumber");

        String email =
                request.getParameter("email");

        /*
         * Validate role
         */

        if (role == null
                || role.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Please select a staff role."
            );

            return;
        }

        role =
                role.trim().toUpperCase();

        boolean success = false;

        /*
         * RECEPTIONIST
         */

        if ("RECEPTION".equals(role)
                || "RECEPTIONIST".equals(role)) {

            success =
                    staffService.addReceptionist(
                            name,
                            username,
                            contactNumber,
                            email
                    );
        }

        /*
         * CASHIER
         */

        else if ("CASHIER".equals(role)) {

            success =
                    staffService.addCashier(
                            name,
                            username,
                            contactNumber,
                            email
                    );
        }

        /*
         * DENTIST
         */

        else if ("DENTIST".equals(role)) {

            String nic =
                    request.getParameter("nic");

            String specialization =
                    request.getParameter(
                            "specialization"
                    );

            String roomNumber =
                    request.getParameter(
                            "roomNumber"
                    );

            success =
                    staffService.addDentist(
                            name,
                            username,
                            contactNumber,
                            email,
                            nic,
                            specialization,
                            roomNumber
                    );
        }

        /*
         * INVALID ROLE
         */

        else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Invalid staff role selected."
            );

            return;
        }

        /*
         * RESULT
         */

        if (success) {

            redirectWithMessage(
                    request,
                    response,
                    "success",
                    "Staff member added successfully."
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Unable to add staff member. "
                    + "Please check the entered details "
                    + "and make sure the username is not already in use."
            );
        }
    }

    /*
     * ==========================================
     * EDIT STAFF
     * ==========================================
     */

    private void editStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String staffIdParameter =
                request.getParameter("staffId");

        if (staffIdParameter == null
                || staffIdParameter.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Staff ID is required."
            );

            return;
        }

        int staffId;

        try {

            staffId =
                    Integer.parseInt(
                            staffIdParameter
                    );

        } catch (NumberFormatException e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Invalid staff ID."
            );

            return;
        }

        /*
         * Make sure staff exists
         */

        Staff staff =
                staffService.getStaffById(staffId);

        if (staff == null) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Staff member could not be found."
            );

            return;
        }

        /*
         * Get edited values
         */

        String name =
                request.getParameter("name");

        String username =
                request.getParameter("username");

        String contactNumber =
                request.getParameter("contactNumber");

        String email =
                request.getParameter("email");

        /*
         * Update staff
         */

        boolean success =
                staffService.updateStaffDetails(
                        staffId,
                        name,
                        username,
                        contactNumber,
                        email
                );

        /*
         * Result
         */

        if (success) {

            redirectWithMessage(
                    request,
                    response,
                    "success",
                    "Staff member updated successfully."
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Unable to update staff member. "
                    + "Please check the entered details."
            );
        }
    }

    /*
     * ==========================================
     * CHANGE STAFF STATUS
     * ==========================================
     */

    private void changeStaffStatus(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String staffIdParameter =
                request.getParameter("staffId");

        if (staffIdParameter == null
                || staffIdParameter.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Staff ID is required."
            );

            return;
        }

        int staffId;

        try {

            staffId =
                    Integer.parseInt(
                            staffIdParameter
                    );

        } catch (NumberFormatException e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Invalid staff ID."
            );

            return;
        }

        /*
         * Get current staff record
         */

        Staff staff =
                staffService.getStaffById(staffId);

        if (staff == null) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Staff member could not be found."
            );

            return;
        }

        /*
         * Determine new status from database
         */

        String currentStatus =
                staff.getStatus();

        String newStatus;

        if ("ACTIVE".equalsIgnoreCase(
                currentStatus)) {

            newStatus = "INACTIVE";

        } else {

            newStatus = "ACTIVE";
        }

        /*
         * Change status
         */

        boolean success =
                staffService.changeStaffStatus(
                        staffId,
                        newStatus
                );

        /*
         * Result
         */

        if (success) {

            String message;

            if ("ACTIVE".equals(newStatus)) {

                message =
                        "Staff member activated successfully.";

            } else {

                message =
                        "Staff member deactivated successfully.";
            }

            redirectWithMessage(
                    request,
                    response,
                    "success",
                    message
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Unable to change staff status."
            );
        }
    }

    /*
     * ==========================================
     * RESET STAFF PASSWORD
     * ==========================================
     */

    private void resetStaffPassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String staffIdParam =
                request.getParameter("staffId");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (staffIdParam == null
                || staffIdParam.isBlank()
                || newPassword == null
                || newPassword.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Please provide a new password."
            );

            return;
        }

        if (confirmPassword != null
                && !newPassword.equals(confirmPassword)) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Passwords do not match."
            );

            return;
        }

        if (newPassword.trim().length() < 6) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Password must be at least 6 characters long."
            );

            return;
        }

        int staffId;

        try {

            staffId = Integer.parseInt(
                    staffIdParam.trim()
            );

        } catch (NumberFormatException e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Invalid staff member selected."
            );

            return;
        }

        Staff staff =
                staffService.getStaffById(staffId);

        if (staff == null) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Staff member not found."
            );

            return;
        }

        boolean success =
                staffService.resetPassword(
                        staffId,
                        newPassword.trim()
                );

        if (success) {

            redirectWithMessage(
                    request,
                    response,
                    "success",
                    "Password has been reset successfully for "
                            + staff.getName()
                            + " (@" + staff.getUsername() + ")."
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Failed to reset password. Please try again."
            );
        }
    }

    /*
     * ==========================================
     * REDIRECT TO STAFF PAGE
     * ==========================================
     */

    private void redirectToStaffPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/staff"
        );
    }

    /*
     * ==========================================
     * REDIRECT WITH MESSAGE
     * ==========================================
     */

    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String type,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/staff?"
                + type
                + "="
                + URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }
}