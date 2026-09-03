<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.sunrise.dental.model.Staff"%>

<%
    String contextPath = request.getContextPath();

    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }

    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    if (staffList == null) {
        staffList = new java.util.ArrayList<>();
    }

    String searchKeyword = (String) request.getAttribute("searchKeyword");
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");

    int totalStaff = staffList.size();
    int activeStaff = 0;
    int dentistCount = 0;
    int receptionistCount = 0;
    int cashierCount = 0;

    for (Staff staff : staffList) {
        if ("ACTIVE".equalsIgnoreCase(staff.getStatus())) {
            activeStaff++;
        }
        if ("DENTIST".equalsIgnoreCase(staff.getRole())) {
            dentistCount++;
        } else if ("RECEPTION".equalsIgnoreCase(staff.getRole()) || "RECEPTIONIST".equalsIgnoreCase(staff.getRole())) {
            receptionistCount++;
        } else if ("CASHIER".equalsIgnoreCase(staff.getRole())) {
            cashierCount++;
        }
    }

    String adminInitials = "AD";
    if (staffName != null && !staffName.isBlank()) {
        String[] parts = staffName.trim().split("\\s+");
        if (parts.length >= 2) {
            adminInitials = (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
        } else if (staffName.length() >= 2) {
            adminInitials = staffName.substring(0, 2).toUpperCase();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .staff-header-card {
            background: linear-gradient(135deg, rgba(14, 165, 180, 0.9), rgba(8, 127, 140, 0.95));
            border-radius: 20px;
            padding: 28px 32px;
            color: #ffffff;
            margin-bottom: 25px;
            box-shadow: 0 15px 35px rgba(8, 127, 140, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .staff-header-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .staff-header-text p {
            font-size: 13.5px;
            color: #d6f4f8;
            margin: 0;
        }

        .add-staff-btn {
            background: #ffffff;
            color: #078c9b;
            border: none;
            padding: 12px 22px;
            border-radius: 12px;
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            transition: all 0.2s ease;
        }

        .add-staff-btn:hover {
            transform: translateY(-2px);
            background: #f0fbfe;
            color: #056b77;
        }

        .staff-table-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(6, 38, 50, 0.09);
            padding: 28px 30px;
            margin-bottom: 30px;
            border: 1px solid #edf3f5;
        }

        .staff-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
            flex-wrap: wrap;
        }

        .search-box-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            max-width: 400px;
        }

        .search-input-field {
            position: relative;
            flex: 1;
        }

        .search-input-field i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 14px;
        }

        .search-input-field input {
            width: 100%;
            height: 40px;
            border: 1.5px solid #dce8ec;
            border-radius: 10px;
            padding: 0 14px 0 38px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            box-sizing: border-box;
        }

        .search-input-field input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .search-submit-btn {
            background: #0c3d4f;
            color: #ffffff;
            border: none;
            padding: 0 18px;
            height: 40px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .clear-search-btn {
            color: #d9534f;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
        }

        /* Role Badges */
        .role-pill {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.3px;
            text-transform: uppercase;
        }

        .role-dentist { background: #e8f4fd; color: #0b7ad1; }
        .role-reception { background: #e8f8f0; color: #129c5b; }
        .role-cashier { background: #fff8e6; color: #d48e0c; }
        .role-admin { background: #f3e8fd; color: #7b2cbf; }
        .role-default { background: #eef2f5; color: #5c6f84; }

        /* Action Buttons */
        .action-btn-circle {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: 1px solid #e1ecef;
            background: #fbfdfe;
            color: #557280;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .action-btn-circle:hover {
            background: #e6f7f9;
            color: #078c9b;
            border-color: #0ea5b4;
        }

        .action-btn-circle.status-toggle:hover {
            background: #fff5ed;
            color: #d48e0c;
        }

        .action-btn-circle.password-reset-btn:hover {
            background: #fefce8;
            color: #ca8a04;
            border-color: #eab308;
        }

        .password-input-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .password-input-wrap input {
            width: 100%;
            padding-right: 42px !important;
        }

        .toggle-password-icon {
            position: absolute;
            right: 14px;
            cursor: pointer;
            color: #8da4ae;
            font-size: 15px;
            transition: color 0.2s;
        }

        .toggle-password-icon:hover {
            color: #0ea5b4;
        }

        .btn-generate-pwd {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f0fdfa;
            color: #0d9488;
            border: 1px dashed #0d9488;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 6px;
            width: fit-content;
        }

        .btn-generate-pwd:hover {
            background: #0d9488;
            color: #ffffff;
        }

        /* Alerts */
        .alert {
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }
        .success-alert { background: #e8f8f0; color: #0d8248; border: 1px solid #c2eed5; }
        .error-alert { background: #feecee; color: #c92a2a; border: 1px solid #f9c6cb; }

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(7, 43, 56, 0.65);
            backdrop-filter: blur(5px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 2000;
            padding: 20px;
        }
        .modal-overlay.show { display: flex; }

        .modal {
            background: #ffffff;
            border-radius: 20px;
            width: 100%;
            max-width: 620px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            animation: modalFadeIn 0.2s ease;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(15px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .modal-header {
            padding: 22px 28px;
            border-bottom: 1px solid #edf3f5;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafcfe;
        }
        .modal-header h3 { font-size: 18px; font-weight: 700; color: #0c3d4f; margin: 0; }
        .modal-header p { font-size: 12.5px; color: #7a94a2; margin: 3px 0 0; }

        .close-modal {
            border: none; background: transparent; font-size: 18px; color: #8da4ae; cursor: pointer;
        }
        .close-modal:hover { color: #d9534f; }

        .modal-body {
            padding: 26px 28px;
            overflow-y: auto;
            flex: 1;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-group.full-width { grid-column: 1 / -1; }

        .form-group label {
            font-size: 12.5px;
            font-weight: 600;
            color: #3b5663;
        }
        .form-group label .required { color: #d9534f; }

        .form-group input, .form-group select {
            height: 42px;
            border: 1.5px solid #dce8ec;
            border-radius: 10px;
            padding: 0 14px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .form-help { font-size: 11px; color: #8da4ae; }

        .dentist-fields {
            display: none;
            grid-column: 1 / -1;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            background: #f3fafb;
            padding: 16px;
            border-radius: 12px;
            border: 1px solid #d8eef2;
        }
        .dentist-fields.show { display: grid; }
        .dentist-section-title {
            grid-column: 1 / -1;
            font-size: 13px;
            font-weight: 700;
            color: #087f8c;
            border-bottom: 1px solid #d2ebef;
            padding-bottom: 6px;
        }

        .password-information {
            margin-top: 18px;
            background: #f8fafb;
            border: 1px solid #eef3f5;
            padding: 14px;
            border-radius: 12px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        .password-information i { font-size: 20px; color: #0ea5b4; margin-top: 2px; }
        .password-information strong { display: block; font-size: 12.5px; color: #0c3d4f; }
        .password-information span { font-size: 11.5px; color: #7a94a2; }

        .modal-footer {
            padding: 18px 28px;
            border-top: 1px solid #edf3f5;
            background: #fafcfe;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .cancel-button {
            padding: 10px 18px;
            border-radius: 10px;
            border: 1px solid #dce8ec;
            background: #ffffff;
            color: #557280;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }
        .save-button {
            padding: 10px 22px;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(8, 127, 140, 0.25);
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- ========================================= -->
    <!-- SIDEBAR -->
    <!-- ========================================= -->
    <aside class="sidebar" id="sidebar">

        <div class="sidebar-brand">
            <img src="<%= contextPath %>/images/logo1.png" alt="Sunrise Dental Clinic Logo">
            <div class="brand-text">
                <h2>Sunrise</h2>
                <span>Dental Clinic</span>
            </div>
        </div>

        <nav class="sidebar-navigation">
            <p class="navigation-title">MAIN</p>

            <a href="<%= contextPath %>/admin/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/staff" class="nav-item active">
                <i class="bi bi-people-fill"></i>
                <span>Staff Management</span>
            </a>

            <a href="<%= contextPath %>/admin/dentist-slots" class="nav-item">
                <i class="bi bi-clock-history"></i>
                <span>Dentist Time Slots</span>
            </a>

            <a href="<%= contextPath %>/admin/treatments" class="nav-item">
                <i class="bi bi-journal-medical"></i>
                <span>Treatments</span>
            </a>

            <p class="navigation-title clinic-title">ANALYTICS</p>

            <a href="<%= contextPath %>/admin/reports" class="nav-item">
                <i class="bi bi-bar-chart-line-fill"></i>
                <span>Reports</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="<%= contextPath %>/admin/helpdesk" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>
            <a href="<%= contextPath %>/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </div>

    </aside>

    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1>Staff Management</h1>
                <p>Manage clinic staff accounts and operational roles</p>
            </div>

            <div class="topbar-right">
                <button type="button" class="icon-button" title="Notifications">
                    <i class="bi bi-bell"></i>
                    <span class="notification-dot"></span>
                </button>

                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-gear"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Administrator</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- DASHBOARD CONTENT -->
        <section class="dashboard-content">

            <!-- Hero Banner -->
            <div class="staff-header-card">
                <div class="staff-header-text">
                    <h2>Clinic Staff Directory</h2>
                    <p>Create, update, and manage doctor, receptionist, and cashier accounts.</p>
                </div>
                <button type="button" class="add-staff-btn" onclick="openAddStaffModal()">
                    <i class="bi bi-person-plus-fill"></i> Add New Staff
                </button>
            </div>

            <!-- Messages -->
            <% if (successMessage != null && !successMessage.isBlank()) { %>
                <div class="alert success-alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <span><%= successMessage %></span>
                </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                <div class="alert error-alert">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <!-- Statistics Grid -->
            <section class="statistics-grid">
                <div class="stat-card">
                    <div class="stat-icon patient-icon">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div class="stat-information">
                        <span>Total Staff</span>
                        <strong><%= totalStaff %></strong>
                        <small>Registered accounts</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon confirmed-icon">
                        <i class="bi bi-person-check-fill"></i>
                    </div>
                    <div class="stat-information">
                        <span>Active Staff</span>
                        <strong><%= activeStaff %></strong>
                        <small>Operational</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon appointment-icon">
                        <i class="bi bi-hospital"></i>
                    </div>
                    <div class="stat-information">
                        <span>Dentists</span>
                        <strong><%= dentistCount %></strong>
                        <small>Clinical doctors</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon availability-icon">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <div class="stat-information">
                        <span>Reception / Cashiers</span>
                        <strong><%= receptionistCount + cashierCount %></strong>
                        <small>Front desk staff</small>
                    </div>
                </div>
            </section>

            <!-- Staff Table Section -->
            <section class="staff-table-card">
                <div class="staff-card-header">
                    <div>
                        <h3 style="font-size: 17px; font-weight: 700; color: #0c3d4f; margin: 0;">Personnel Accounts</h3>
                        <p style="font-size: 12.5px; color: #7a94a2; margin: 2px 0 0;">All personnel accounts registered in the clinic database</p>
                    </div>

                    <!-- Search Form -->
                    <form method="get" action="<%= contextPath %>/admin/staff" class="search-box-wrap">
                        <div class="search-input-field">
                            <i class="bi bi-search"></i>
                            <input type="text" name="search" placeholder="Search staff name or username..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
                        </div>
                        <button type="submit" class="search-submit-btn">Search</button>
                        <% if (searchKeyword != null && !searchKeyword.isBlank()) { %>
                            <a href="<%= contextPath %>/admin/staff" class="clear-search-btn">Clear</a>
                        <% } %>
                    </form>
                </div>

                <div class="table-container">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Staff Member</th>
                                <th>Username</th>
                                <th>Contact</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (!staffList.isEmpty()) {
                                for (Staff staff : staffList) {
                                    String role = staff.getRole() != null ? staff.getRole() : "";
                                    String status = staff.getStatus() != null ? staff.getStatus() : "";
                                    String roleClass = "role-default";
                                    String roleLabel = role;

                                    if ("DENTIST".equalsIgnoreCase(role)) {
                                        roleClass = "role-dentist";
                                        roleLabel = "Dentist";
                                    } else if ("RECEPTION".equalsIgnoreCase(role) || "RECEPTIONIST".equalsIgnoreCase(role)) {
                                        roleClass = "role-reception";
                                        roleLabel = "Receptionist";
                                    } else if ("CASHIER".equalsIgnoreCase(role)) {
                                        roleClass = "role-cashier";
                                        roleLabel = "Cashier";
                                    } else if ("ADMIN".equalsIgnoreCase(role)) {
                                        roleClass = "role-admin";
                                        roleLabel = "Administrator";
                                    }

                                    String statusClass = "ACTIVE".equalsIgnoreCase(status) ? "status-confirmed" : "status-cancelled";
                                    String statusLabel = "ACTIVE".equalsIgnoreCase(status) ? "Active" : "Inactive";

                                    String initials = "ST";
                                    if (staff.getName() != null && !staff.getName().isBlank()) {
                                        String[] nameParts = staff.getName().trim().split("\\s+");
                                        if (nameParts.length >= 2) {
                                            initials = (nameParts[0].substring(0, 1) + nameParts[nameParts.length - 1].substring(0, 1)).toUpperCase();
                                        } else {
                                            initials = nameParts[0].substring(0, Math.min(2, nameParts[0].length())).toUpperCase();
                                        }
                                    }
                        %>
                            <tr>
                                <td>
                                    <strong style="color: #0c3d4f; font-size: 13px;">#<%= staff.getStaffId() %></strong>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="patient-avatar">
                                            <%= initials %>
                                        </div>
                                        <div>
                                            <strong><%= staff.getName() %></strong>
                                            <span>Staff ID: #<%= staff.getStaffId() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span style="font-weight: 500; color: #1a3b47;"><%= staff.getUsername() %></span>
                                </td>
                                <td>
                                    <span style="color: #557280; font-size: 12.5px;"><%= staff.getContactNumber() %></span>
                                </td>
                                <td>
                                    <span class="role-pill <%= roleClass %>"><%= roleLabel %></span>
                                </td>
                                <td>
                                    <span class="status <%= statusClass %>"><%= statusLabel %></span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <button type="button" class="action-btn-circle" title="Edit Staff"
                                                data-staff-id="<%= staff.getStaffId() %>"
                                                data-name="<%= staff.getName() == null ? "" : staff.getName().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                                                data-username="<%= staff.getUsername() == null ? "" : staff.getUsername().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                                                data-contact="<%= staff.getContactNumber() == null ? "" : staff.getContactNumber().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                                                data-role="<%= staff.getRole() == null ? "" : staff.getRole() %>"
                                                onclick="editStaff(this)">
                                            <i class="bi bi-pencil"></i>
                                        </button>

                                        <button type="button" class="action-btn-circle password-reset-btn"
                                                title="Reset Password"
                                                data-staff-id="<%= staff.getStaffId() %>"
                                                data-name="<%= staff.getName() == null ? "" : staff.getName().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                                                data-username="<%= staff.getUsername() == null ? "" : staff.getUsername().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                                                data-role="<%= staff.getRole() == null ? "" : staff.getRole() %>"
                                                onclick="openResetPasswordModal(this)">
                                            <i class="bi bi-key-fill"></i>
                                        </button>

                                        <button type="button" class="action-btn-circle status-toggle"
                                                title="<%= "ACTIVE".equalsIgnoreCase(status) ? "Deactivate Staff" : "Activate Staff" %>"
                                                onclick="changeStatus(<%= staff.getStaffId() %>, '<%= status %>')">
                                            <i class="bi <%= "ACTIVE".equalsIgnoreCase(status) ? "bi-person-dash" : "bi-person-check" %>"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-people" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    No staff members found matching your search.
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>

        </section>

    </main>

</div>

<!-- ========================================== -->
<!-- ADD STAFF MODAL -->
<!-- ========================================== -->
<div class="modal-overlay" id="addStaffModal">
    <div class="modal">
        <div class="modal-header">
            <div>
                <h3>Add Staff Member</h3>
                <p>Create a new clinic staff account</p>
            </div>
            <button type="button" class="close-modal" onclick="closeAddStaffModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <form method="post" action="<%= contextPath %>/admin/staff" id="addStaffForm">
            <input type="hidden" name="action" value="add">

            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="role">Staff Role <span class="required">*</span></label>
                        <select name="role" id="role" required onchange="handleRoleChange()">
                            <option value="">Select staff role</option>
                            <option value="DENTIST">Dentist</option>
                            <option value="RECEPTIONIST">Receptionist</option>
                            <option value="CASHIER">Cashier</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="name">Full Name <span class="required">*</span></label>
                        <input type="text" name="name" id="name" placeholder="Enter full name" required>
                    </div>

                    <div class="form-group">
                        <label for="username">Username <span class="required">*</span></label>
                        <input type="text" name="username" id="username" placeholder="Enter username" pattern="[A-Za-z]+" title="Letters only" required>
                        <span class="form-help">Letters only. Used for system login.</span>
                    </div>

                    <div class="form-group">
                        <label for="contactNumber">Contact Number <span class="required">*</span></label>
                        <input type="text" name="contactNumber" id="contactNumber" placeholder="07XXXXXXXX" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" name="email" id="email" placeholder="example@email.com">
                    </div>

                    <!-- DENTIST FIELDS -->
                    <div class="dentist-fields" id="dentistFields">
                        <div class="dentist-section-title">Doctor Credentials</div>
                        <div class="form-group">
                            <label for="nic">NIC <span class="required">*</span></label>
                            <input type="text" name="nic" id="nic" placeholder="Enter NIC number">
                        </div>
                        <div class="form-group">
                            <label for="specialization">Specialization <span class="required">*</span></label>
                            <input type="text" name="specialization" id="specialization" placeholder="e.g. Orthodontics">
                        </div>
                        <div class="form-group full-width">
                            <label for="roomNumber">Room Number <span class="required">*</span></label>
                            <input type="text" name="roomNumber" id="roomNumber" placeholder="e.g. Room 01">
                        </div>
                    </div>
                </div>

                <div class="password-information">
                    <i class="bi bi-shield-lock-fill"></i>
                    <div>
                        <strong>Default credentials assigned automatically</strong>
                        <span>The system assigns a standard default password for the role. Credentials can be managed by the administrator.</span>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="cancel-button" onclick="closeAddStaffModal()">Cancel</button>
                <button type="submit" class="save-button"><i class="bi bi-person-plus"></i> Create Account</button>
            </div>
        </form>
    </div>
</div>

<!-- ========================================== -->
<!-- EDIT STAFF MODAL -->
<!-- ========================================== -->
<div class="modal-overlay" id="editStaffModal">
    <div class="modal">
        <div class="modal-header">
            <div>
                <h3>Edit Staff Member</h3>
                <p>Update personnel details</p>
            </div>
            <button type="button" class="close-modal" onclick="closeEditStaffModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <form method="post" action="<%= contextPath %>/admin/staff" id="editStaffForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="staffId" id="editStaffId">

            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Staff Role</label>
                        <input type="text" id="editRole" readonly style="background: #f1f6f8; cursor: not-allowed;">
                        <span class="form-help">Staff role cannot be changed after creation.</span>
                    </div>

                    <div class="form-group">
                        <label for="editName">Full Name <span class="required">*</span></label>
                        <input type="text" name="name" id="editName" placeholder="Enter full name" required>
                    </div>

                    <div class="form-group">
                        <label for="editUsername">Username <span class="required">*</span></label>
                        <input type="text" name="username" id="editUsername" pattern="[A-Za-z]+" title="Letters only" placeholder="Enter username" required>
                    </div>

                    <div class="form-group">
                        <label for="editContactNumber">Contact Number <span class="required">*</span></label>
                        <input type="text" name="contactNumber" id="editContactNumber" placeholder="07XXXXXXXX" maxlength="10" required>
                    </div>

                    <div class="form-group">
                        <label for="editEmail">Email Address</label>
                        <input type="email" name="email" id="editEmail" placeholder="example@email.com">
                        <span class="form-help">Leave blank to keep existing email.</span>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="cancel-button" onclick="closeEditStaffModal()">Cancel</button>
                <button type="submit" class="save-button"><i class="bi bi-check-lg"></i> Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- ========================================== -->
<!-- RESET PASSWORD MODAL -->
<!-- ========================================== -->
<div class="modal-overlay" id="resetPasswordModal">
    <div class="modal">
        <div class="modal-header">
            <div>
                <h3 style="display: flex; align-items: center; gap: 8px;">
                    <i class="bi bi-shield-lock-fill" style="color: #0ea5b4;"></i> Reset Staff Password
                </h3>
                <p>Set a new secure login password for this staff member</p>
            </div>
            <button type="button" class="close-modal" onclick="closeResetPasswordModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <form method="post" action="<%= contextPath %>/admin/staff" id="resetPasswordForm" onsubmit="return validatePasswordReset()">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="staffId" id="resetStaffId">

            <div class="modal-body">
                <div style="background: #f8fafc; border-left: 4px solid #0ea5b4; padding: 12px 16px; border-radius: 0 10px 10px 0; margin-bottom: 20px;">
                    <span style="font-size: 11px; color: #64748b; text-transform: uppercase; font-weight: 700; display: block;">Target Staff Account</span>
                    <strong id="resetTargetInfo" style="color: #0f172a; font-size: 13.5px; display: block; margin-top: 2px;"></strong>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="newPassword">New Password <span class="required">*</span></label>
                    <div class="password-input-wrap">
                        <input type="password" name="newPassword" id="newPassword" placeholder="Enter new password (min. 6 characters)" minlength="6" required>
                        <i class="bi bi-eye toggle-password-icon" id="toggleNewPwd" onclick="togglePasswordVisibility('newPassword', 'toggleNewPwd')"></i>
                    </div>
                    <button type="button" class="btn-generate-pwd" onclick="generateRandomPassword()">
                        <i class="bi bi-dice-5-fill"></i> Generate Strong Temporary Password
                    </button>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password <span class="required">*</span></label>
                    <div class="password-input-wrap">
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter new password" minlength="6" required>
                        <i class="bi bi-eye toggle-password-icon" id="toggleConfirmPwd" onclick="togglePasswordVisibility('confirmPassword', 'toggleConfirmPwd')"></i>
                    </div>
                    <span class="form-help" id="passwordMatchMessage" style="color: #64748b; font-size: 11.5px; margin-top: 5px; display: block;">
                        Minimum 6 characters. Must match the password above.
                    </span>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="cancel-button" onclick="closeResetPasswordModal()">Cancel</button>
                <button type="submit" class="save-button" style="background: linear-gradient(135deg, #0ea5b4, #087f8c);">
                    <i class="bi bi-key-fill"></i> Reset Password
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openAddStaffModal() {
    document.getElementById("addStaffModal").classList.add("show");
    document.getElementById("role").focus();
}

function closeAddStaffModal() {
    document.getElementById("addStaffModal").classList.remove("show");
    const form = document.getElementById("addStaffForm");
    if (form) form.reset();
    handleRoleChange();
}

function handleRoleChange() {
    const role = document.getElementById("role").value;
    const dentistFields = document.getElementById("dentistFields");
    const nic = document.getElementById("nic");
    const specialization = document.getElementById("specialization");
    const roomNumber = document.getElementById("roomNumber");

    if (role === "DENTIST") {
        dentistFields.classList.add("show");
        nic.required = true;
        specialization.required = true;
        roomNumber.required = true;
    } else {
        dentistFields.classList.remove("show");
        nic.required = false;
        specialization.required = false;
        roomNumber.required = false;
    }
}

function editStaff(button) {
    if (!button) return;
    const staffId = button.dataset.staffId;
    const name = button.dataset.name || "";
    const username = button.dataset.username || "";
    const contact = button.dataset.contact || "";
    const role = button.dataset.role || "";

    document.getElementById("editStaffId").value = staffId;
    document.getElementById("editName").value = name;
    document.getElementById("editUsername").value = username;
    document.getElementById("editContactNumber").value = contact;
    document.getElementById("editRole").value = formatRole(role);
    document.getElementById("editEmail").value = "";

    document.getElementById("editStaffModal").classList.add("show");
    document.getElementById("editName").focus();
}

function formatRole(role) {
    if (!role) return "";
    role = role.toUpperCase();
    if (role === "DENTIST") return "Dentist";
    if (role === "RECEPTION" || role === "RECEPTIONIST") return "Receptionist";
    if (role === "CASHIER") return "Cashier";
    if (role === "ADMIN") return "Administrator";
    return role;
}

function closeEditStaffModal() {
    document.getElementById("editStaffModal").classList.remove("show");
}

function openResetPasswordModal(button) {
    if (!button) return;
    const staffId = button.dataset.staffId;
    const name = button.dataset.name || "";
    const username = button.dataset.username || "";
    const role = button.dataset.role || "";

    document.getElementById("resetStaffId").value = staffId;
    document.getElementById("resetTargetInfo").textContent = name + " (@" + username + ") • " + formatRole(role);
    document.getElementById("newPassword").value = "";
    document.getElementById("confirmPassword").value = "";

    const msg = document.getElementById("passwordMatchMessage");
    if (msg) {
        msg.textContent = "Minimum 6 characters. Must match the password above.";
        msg.style.color = "#64748b";
    }

    document.getElementById("resetPasswordModal").classList.add("show");
    document.getElementById("newPassword").focus();
}

function closeResetPasswordModal() {
    document.getElementById("resetPasswordModal").classList.remove("show");
}

function togglePasswordVisibility(fieldId, iconId) {
    const field = document.getElementById(fieldId);
    const icon = document.getElementById(iconId);
    if (!field || !icon) return;
    if (field.type === "password") {
        field.type = "text";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    } else {
        field.type = "password";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    }
}

function generateRandomPassword() {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$";
    let password = "Sun#";
    for (let i = 0; i < 6; i++) {
        password += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    password += "26";

    const p1 = document.getElementById("newPassword");
    const p2 = document.getElementById("confirmPassword");
    p1.value = password;
    p2.value = password;

    p1.type = "text";
    p2.type = "text";

    const icon1 = document.getElementById("toggleNewPwd");
    const icon2 = document.getElementById("toggleConfirmPwd");
    if (icon1) icon1.className = "bi bi-eye-slash toggle-password-icon";
    if (icon2) icon2.className = "bi bi-eye-slash toggle-password-icon";

    const msg = document.getElementById("passwordMatchMessage");
    if (msg) {
        msg.textContent = "Generated: " + password + " (Remember to share with staff member)";
        msg.style.color = "#0ea5b4";
    }
}

function validatePasswordReset() {
    const p1 = document.getElementById("newPassword").value;
    const p2 = document.getElementById("confirmPassword").value;
    if (p1.length < 6) {
        alert("Password must be at least 6 characters long.");
        return false;
    }
    if (p1 !== p2) {
        alert("Passwords do not match. Please re-enter.");
        return false;
    }
    return true;
}

function changeStatus(staffId, currentStatus) {
    if (!staffId) return;
    const isActive = String(currentStatus).toUpperCase() === "ACTIVE";
    const actionText = isActive ? "deactivate" : "activate";

    if (window.showConfirmDialog) {
        window.showConfirmDialog({
            title: (isActive ? "Deactivate" : "Activate") + " Staff Member?",
            message: "Are you sure you want to " + actionText + " this staff member's login access?",
            confirmText: isActive ? "Yes, Deactivate" : "Yes, Activate",
            type: isActive ? "danger" : "primary",
            onConfirm: () => {
                const form = document.createElement("form");
                form.method = "POST";
                form.action = "<%= contextPath %>/admin/staff";

                const actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "changeStatus";

                const staffIdInput = document.createElement("input");
                staffIdInput.type = "hidden";
                staffIdInput.name = "staffId";
                staffIdInput.value = staffId;

                form.appendChild(actionInput);
                form.appendChild(staffIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    } else {
        if (!confirm("Are you sure you want to " + actionText + " this staff member?")) return;
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "<%= contextPath %>/admin/staff";

        const actionInput = document.createElement("input");
        actionInput.type = "hidden";
        actionInput.name = "action";
        actionInput.value = "changeStatus";

        const staffIdInput = document.createElement("input");
        staffIdInput.type = "hidden";
        staffIdInput.name = "staffId";
        staffIdInput.value = staffId;

        form.appendChild(actionInput);
        form.appendChild(staffIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// Modal Click Outside & ESC key
document.getElementById("addStaffModal").addEventListener("click", function(e) { if (e.target === this) closeAddStaffModal(); });
document.getElementById("editStaffModal").addEventListener("click", function(e) { if (e.target === this) closeEditStaffModal(); });
document.getElementById("resetPasswordModal").addEventListener("click", function(e) { if (e.target === this) closeResetPasswordModal(); });
document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        closeAddStaffModal();
        closeEditStaffModal();
        closeResetPasswordModal();
    }
});

// Auto Hide Alerts
setTimeout(function() {
    document.querySelectorAll(".alert").forEach(function(alert) {
        alert.style.transition = "opacity 0.4s ease";
        alert.style.opacity = "0";
        setTimeout(function() { alert.remove(); }, 400);
    });
}, 5000);
</script>

<script src="<%= contextPath %>/js/notifications.js"></script>

</body>
</html>