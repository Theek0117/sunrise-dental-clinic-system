<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.sunrise.dental.model.Staff"%>

<%
    String contextPath = request.getContextPath();

    /*
     * ==========================================
     * SESSION INFORMATION
     * ==========================================
     */

    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }

    /*
     * ==========================================
     * STAFF LIST
     * ==========================================
     */

    List<Staff> staffList =
            (List<Staff>) request.getAttribute("staffList");

    if (staffList == null) {
        staffList = new java.util.ArrayList<>();
    }

    String searchKeyword =
            (String) request.getAttribute("searchKeyword");

    /*
     * ==========================================
     * MESSAGES
     * ==========================================
     */

    String successMessage =
            request.getParameter("success");

    String errorMessage =
            request.getParameter("error");

    /*
     * ==========================================
     * STATISTICS
     * ==========================================
     */

    int totalStaff = staffList.size();

    int activeStaff = 0;
    int dentistCount = 0;
    int receptionistCount = 0;
    int cashierCount = 0;

    for (Staff staff : staffList) {

        if ("ACTIVE".equalsIgnoreCase(
                staff.getStatus())) {

            activeStaff++;
        }

        if ("DENTIST".equalsIgnoreCase(
                staff.getRole())) {

            dentistCount++;

        } else if ("RECEPTION".equalsIgnoreCase(
                staff.getRole())
                || "RECEPTIONIST".equalsIgnoreCase(
                staff.getRole())) {

            receptionistCount++;

        } else if ("CASHIER".equalsIgnoreCase(
                staff.getRole())) {

            cashierCount++;
        }
    }

    /*
     * ==========================================
     * ADMIN INITIALS
     * ==========================================
     */

    String adminInitials = "AD";

    if (staffName != null && !staffName.isBlank()) {

        String[] parts =
                staffName.trim().split("\\s+");

        if (parts.length >= 2) {

            adminInitials =
                    (
                        parts[0].substring(0, 1)
                        +
                        parts[parts.length - 1]
                                .substring(0, 1)
                    ).toUpperCase();

        } else if (staffName.length() >= 2) {

            adminInitials =
                    staffName.substring(0, 2)
                            .toUpperCase();
        }
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Staff Management | Sunrise Dental Clinic
    </title>

    <!-- Google Fonts -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">

    <!-- Bootstrap Icons -->

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #f4f8fa;
            color: #163b4a;
        }

        a {
            text-decoration: none;
        }

        button,
        input,
        select {
            font-family: inherit;
        }

        /*
         * ==========================================
         * LAYOUT
         * ==========================================
         */

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /*
         * ==========================================
         * SIDEBAR
         * ==========================================
         */

        .sidebar {
            width: 255px;
            min-height: 100vh;
            background: #ffffff;
            border-right: 1px solid #e2edf1;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            height: 88px;
            display: flex;
            align-items: center;
            padding: 18px 22px;
            border-bottom: 1px solid #edf3f5;
        }

        .sidebar-brand img {
            width: 48px;
            height: 48px;
            object-fit: contain;
        }

        .brand-text {
            margin-left: 12px;
        }

        .brand-text h2 {
            font-size: 20px;
            color: #0c566c;
            font-weight: 800;
            line-height: 1;
        }

        .brand-text span {
            display: block;
            margin-top: 5px;
            color: #78929d;
            font-size: 11px;
            font-weight: 500;
        }

        .sidebar-navigation {
            padding: 25px 15px;
            flex: 1;
        }

        .navigation-title {
            font-size: 10px;
            font-weight: 700;
            color: #9aafb7;
            letter-spacing: 1.2px;
            padding: 0 12px;
            margin-bottom: 10px;
        }

        .clinic-title {
            margin-top: 24px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 12px 14px;
            margin-bottom: 5px;
            border-radius: 10px;
            color: #68838e;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s ease;
        }

        .nav-item i {
            font-size: 17px;
        }

        .nav-item:hover {
            background: #edf8fa;
            color: #0c7587;
        }

        .nav-item.active {
            background: #e7f6f8;
            color: #087b8c;
            font-weight: 600;
        }

        .sidebar-bottom {
            padding: 0 15px 22px;
        }

        .logout-item:hover {
            background: #fff1f1;
            color: #d95353;
        }

        /*
         * ==========================================
         * MAIN CONTENT
         * ==========================================
         */

        .main-content {
            margin-left: 255px;
            width: calc(100% - 255px);
            min-height: 100vh;
        }

        /*
         * ==========================================
         * TOPBAR
         * ==========================================
         */

        .topbar {
            height: 88px;
            background: #ffffff;
            border-bottom: 1px solid #e4eef1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 35px;
        }

        .topbar-left h1 {
            font-size: 22px;
            color: #123f50;
            font-weight: 700;
        }

        .topbar-left p {
            margin-top: 3px;
            color: #839aa3;
            font-size: 12px;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .icon-button {
            width: 40px;
            height: 40px;
            border: 1px solid #e1ecef;
            background: #ffffff;
            border-radius: 10px;
            color: #67818b;
            cursor: pointer;
            position: relative;
            font-size: 17px;
        }

        .notification-dot {
            position: absolute;
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #ef6464;
            top: 8px;
            right: 8px;
            border: 2px solid #ffffff;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: #e8f5f7;
            color: #087889;
            border-radius: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-information strong {
            display: block;
            font-size: 13px;
            color: #244b59;
        }

        .user-information span {
            display: block;
            font-size: 10px;
            color: #91a5ad;
            margin-top: 2px;
        }

        /*
         * ==========================================
         * CONTENT
         * ==========================================
         */

        .dashboard-content {
            padding: 30px 35px 45px;
        }

        /*
         * ==========================================
         * PAGE HEADER
         * ==========================================
         */

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-title h2 {
            font-size: 24px;
            font-weight: 700;
            color: #123f50;
        }

        .page-title p {
            margin-top: 5px;
            font-size: 13px;
            color: #8198a2;
        }

        .add-staff-button {
            border: none;
            background: #087d8e;
            color: #ffffff;
            padding: 12px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 5px 15px rgba(8, 125, 142, 0.18);
            transition: 0.2s ease;
        }

        .add-staff-button:hover {
            background: #076c7b;
            transform: translateY(-1px);
        }

        /*
         * ==========================================
         * STATISTICS
         * ==========================================
         */

        .statistics-grid {
            display: grid;
            grid-template-columns:
                repeat(4, minmax(0, 1fr));
            gap: 17px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: #ffffff;
            border: 1px solid #e3edf0;
            border-radius: 14px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .stat-icon {
            width: 46px;
            height: 46px;
            flex-shrink: 0;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
        }

        .stat-icon.staff {
            background: #e9f7f8;
            color: #078294;
        }

        .stat-icon.active {
            background: #eaf8f0;
            color: #26945a;
        }

        .stat-icon.dentist {
            background: #edf1fb;
            color: #536eb5;
        }

        .stat-icon.other {
            background: #fff4e9;
            color: #d88936;
        }

        .stat-information span {
            display: block;
            font-size: 11px;
            color: #8298a1;
            font-weight: 500;
        }

        .stat-information strong {
            display: block;
            font-size: 23px;
            color: #183f4e;
            margin-top: 1px;
        }

        /*
         * ==========================================
         * ALERTS
         * ==========================================
         */

        .alert {
            border-radius: 10px;
            padding: 13px 16px;
            margin-bottom: 20px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .success-alert {
            background: #eaf8f0;
            border: 1px solid #ccebd9;
            color: #27734b;
        }

        .error-alert {
            background: #fff0f0;
            border: 1px solid #f2d0d0;
            color: #a94343;
        }

        /*
         * ==========================================
         * STAFF TABLE SECTION
         * ==========================================
         */

        .staff-section {
            background: #ffffff;
            border: 1px solid #e1ecef;
            border-radius: 15px;
            overflow: hidden;
        }

        .section-header {
            padding: 21px 23px;
            border-bottom: 1px solid #edf2f4;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .section-heading h3 {
            font-size: 16px;
            color: #173f4e;
            font-weight: 700;
        }

        .section-heading p {
            font-size: 11px;
            color: #91a5ad;
            margin-top: 3px;
        }

        /*
         * ==========================================
         * SEARCH
         * ==========================================
         */

        .search-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-box {
            position: relative;
        }

        .search-box i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #9bb0b8;
            font-size: 14px;
        }

        .search-box input {
            width: 240px;
            height: 39px;
            border: 1px solid #dce8eb;
            border-radius: 9px;
            outline: none;
            padding: 0 12px 0 35px;
            color: #355662;
            font-size: 12px;
        }

        .search-box input:focus {
            border-color: #72bbc5;
        }

        .search-button {
            height: 39px;
            padding: 0 15px;
            border: none;
            background: #e9f6f8;
            color: #087789;
            border-radius: 9px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
        }

        .clear-search {
            height: 39px;
            padding: 0 12px;
            display: flex;
            align-items: center;
            border: 1px solid #dce8eb;
            color: #6e8790;
            border-radius: 9px;
            font-size: 12px;
        }

        /*
         * ==========================================
         * TABLE
         * ==========================================
         */

        .table-wrapper {
            overflow-x: auto;
        }

        .staff-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        .staff-table thead {
            background: #f7fafb;
        }

        .staff-table th {
            text-align: left;
            padding: 13px 20px;
            font-size: 10px;
            font-weight: 700;
            color: #78919b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #e8eff1;
        }

        .staff-table td {
            padding: 15px 20px;
            border-bottom: 1px solid #edf2f4;
            font-size: 12px;
            color: #526f79;
            vertical-align: middle;
        }

        .staff-table tbody tr:hover {
            background: #fbfdfe;
        }

        .staff-table tbody tr:last-child td {
            border-bottom: none;
        }

        .staff-number {
            color: #94aab2;
            font-size: 11px;
        }

        .staff-person {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .staff-avatar {
            width: 37px;
            height: 37px;
            flex-shrink: 0;
            border-radius: 10px;
            background: #e9f6f8;
            color: #08798a;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 12px;
        }

        .staff-person strong {
            display: block;
            color: #244b59;
            font-size: 12px;
        }

        .staff-person span {
            display: block;
            color: #98aab1;
            font-size: 10px;
            margin-top: 2px;
        }

        .username {
            color: #456571;
            font-weight: 500;
        }

        .contact {
            color: #58737d;
        }

        /*
         * ==========================================
         * ROLE BADGES
         * ==========================================
         */

        .role-badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
        }

        .role-dentist {
            background: #edf1fb;
            color: #536eb5;
        }

        .role-reception {
            background: #eaf8f8;
            color: #087e8d;
        }

        .role-cashier {
            background: #fff4e9;
            color: #c77724;
        }

        .role-admin {
            background: #f0ecfb;
            color: #7357aa;
        }

        .role-default {
            background: #f1f4f5;
            color: #71858d;
        }

        /*
         * ==========================================
         * STATUS
         * ==========================================
         */

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 600;
        }

        .status-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .status-active {
            background: #eaf8f0;
            color: #27734b;
        }

        .status-active .status-dot {
            background: #32a465;
        }

        .status-inactive {
            background: #fff0f0;
            color: #a94343;
        }

        .status-inactive .status-dot {
            background: #dc6262;
        }

        /*
         * ==========================================
         * ACTIONS
         * ==========================================
         */

        .action-buttons {
            display: flex;
            gap: 6px;
        }

        .action-button {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: 1px solid #dfeaec;
            background: #ffffff;
            color: #68828c;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 13px;
        }

        .action-button:hover {
            background: #edf7f8;
            color: #087789;
        }

        /*
         * ==========================================
         * EMPTY STATE
         * ==========================================
         */

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #91a6ae;
        }

        .empty-state i {
            display: block;
            font-size: 38px;
            color: #bfd0d6;
            margin-bottom: 10px;
        }

        .empty-state strong {
            display: block;
            color: #607a84;
            font-size: 13px;
        }

        .empty-state span {
            display: block;
            font-size: 11px;
            margin-top: 4px;
        }

        /*
         * ==========================================
         * MODAL
         * ==========================================
         */

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 44, 55, 0.48);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            z-index: 1000;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal {
            width: 100%;
            max-width: 650px;
            max-height: 92vh;
            overflow-y: auto;
            background: #ffffff;
            border-radius: 17px;
            box-shadow: 0 25px 70px rgba(17, 54, 65, 0.25);
        }

        .modal-header {
            padding: 22px 25px;
            border-bottom: 1px solid #e9f0f2;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h3 {
            font-size: 18px;
            color: #163f4e;
        }

        .modal-header p {
            margin-top: 3px;
            font-size: 11px;
            color: #8aa0a8;
        }

        .close-modal {
            width: 35px;
            height: 35px;
            border: none;
            border-radius: 9px;
            background: #f2f6f7;
            color: #718790;
            cursor: pointer;
            font-size: 16px;
        }

        .close-modal:hover {
            background: #edf0f1;
        }

        .modal-body {
            padding: 24px 25px;
        }

        /*
         * ==========================================
         * FORM
         * ==========================================
         */

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 17px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-size: 11px;
            color: #536f79;
            font-weight: 600;
        }

        .required {
            color: #df6262;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            height: 43px;
            border: 1px solid #dce8eb;
            border-radius: 9px;
            padding: 0 12px;
            outline: none;
            color: #355762;
            background: #ffffff;
            font-size: 12px;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #72bbc5;
            box-shadow: 0 0 0 3px rgba(8, 125, 142, 0.06);
        }

        .form-help {
            font-size: 10px;
            color: #96aab1;
            line-height: 1.5;
        }

        /*
         * ==========================================
         * PASSWORD INFORMATION
         * ==========================================
         */

        .password-information {
            margin-top: 19px;
            padding: 13px 15px;
            border-radius: 10px;
            background: #f1f8fa;
            border: 1px solid #d9ecef;
            display: flex;
            gap: 10px;
            align-items: flex-start;
        }

        .password-information i {
            color: #08798a;
            margin-top: 1px;
        }

        .password-information strong {
            display: block;
            font-size: 11px;
            color: #35616d;
        }

        .password-information span {
            display: block;
            margin-top: 3px;
            font-size: 10px;
            color: #78929b;
            line-height: 1.5;
        }

        /*
         * ==========================================
         * DENTIST FIELDS
         * ==========================================
         */

        .dentist-fields {
            display: none;
            grid-column: 1 / -1;
            padding: 17px;
            margin-top: 2px;
            border-radius: 12px;
            background: #f8fbfc;
            border: 1px solid #e4eef1;
        }

        .dentist-fields.show {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 17px;
        }

        .dentist-section-title {
            grid-column: 1 / -1;
            font-size: 12px;
            font-weight: 700;
            color: #285968;
            margin-bottom: -4px;
        }

        /*
         * ==========================================
         * MODAL FOOTER
         * ==========================================
         */

        .modal-footer {
            padding: 18px 25px;
            border-top: 1px solid #e9f0f2;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .cancel-button {
            height: 40px;
            padding: 0 17px;
            border: 1px solid #dce8eb;
            background: #ffffff;
            color: #718891;
            border-radius: 9px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
        }

        .save-button {
            height: 40px;
            padding: 0 19px;
            border: none;
            background: #087d8e;
            color: #ffffff;
            border-radius: 9px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
        }

        .save-button:hover {
            background: #076c7b;
        }

        /*
         * ==========================================
         * RESPONSIVE
         * ==========================================
         */

        @media (max-width: 1100px) {

            .statistics-grid {
                grid-template-columns:
                    repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 850px) {

            .sidebar {
                width: 75px;
            }

            .sidebar-brand {
                justify-content: center;
                padding: 15px;
            }

            .sidebar-brand img {
                width: 43px;
            }

            .brand-text,
            .navigation-title,
            .nav-item span {
                display: none;
            }

            .nav-item {
                justify-content: center;
                padding: 13px;
            }

            .sidebar-bottom {
                padding-left: 10px;
                padding-right: 10px;
            }

            .main-content {
                margin-left: 75px;
                width: calc(100% - 75px);
            }

            .topbar {
                padding: 0 20px;
            }

            .dashboard-content {
                padding: 25px 20px;
            }

            .user-information {
                display: none;
            }

            .section-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .search-form {
                width: 100%;
            }

            .search-box {
                flex: 1;
            }

            .search-box input {
                width: 100%;
            }
        }

        @media (max-width: 600px) {

            .statistics-grid {
                grid-template-columns: 1fr;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
                gap: 15px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .dentist-fields.show {
                grid-template-columns: 1fr;
            }

            .form-group.full-width,
            .dentist-section-title {
                grid-column: auto;
            }

            .modal {
                max-height: 95vh;
            }

            .topbar-left h1 {
                font-size: 18px;
            }
        }
        
        /* =========================================================
   EDIT MODAL
========================================================= */

#editStaffModal {
    display: none;
}

#editStaffModal.show {
    display: flex;
}

#editStaffModal .modal {
    animation: modalOpen 0.18s ease;
}

@keyframes modalOpen {

    from {
        opacity: 0;
        transform: translateY(12px) scale(0.98);
    }

    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

#editRole {
    background: #f5f8f9;
    color: #6f858d;
    cursor: not-allowed;
}

.action-button.status-button:hover {
    background: #fff5ed;
    color: #c77724;
}

.action-button.edit-button:hover {
    background: #edf7f8;
    color: #087789;
}

    </style>

</head>

<body>

<div class="dashboard-container">

    <!-- ========================================== -->
    <!-- SIDEBAR -->
    <!-- ========================================== -->

    <aside class="sidebar">

        <div class="sidebar-brand">

            <img
                src="<%= contextPath %>/images/logo1.png"
                alt="Sunrise Dental Clinic Logo">

            <div class="brand-text">

                <h2>Sunrise</h2>

                <span>Dental Clinic</span>

            </div>

        </div>

        <nav class="sidebar-navigation">

            <p class="navigation-title">
                MAIN
            </p>

            <a
                href="<%= contextPath %>/admin/dashboard"
                class="nav-item">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>Dashboard</span>

            </a>

            <a
                href="<%= contextPath %>/admin/staff"
                class="nav-item active">

                <i class="bi bi-people-fill"></i>

                <span>Staff Management</span>

            </a>


            <a
                href="<%= contextPath %>/admin/dashboard"
                class="nav-item">

                <i class="bi bi-person-lines-fill"></i>

                <span>Patients</span>

            </a>

            <a
                href="<%= contextPath %>/admin/dashboard"
                class="nav-item">

                <i class="bi bi-calendar2-week"></i>

                <span>Appointments</span>

            </a>

            <a
                href="<%= contextPath %>/admin/dashboard"
                class="nav-item">

                <i class="bi bi-journal-medical"></i>

                <span>Treatments</span>

            </a>

            <p class="navigation-title clinic-title">
                ANALYTICS
            </p>

            <a
                href="<%= contextPath %>/admin/dashboard"
                class="nav-item">

                <i class="bi bi-bar-chart-line-fill"></i>

                <span>Reports</span>

            </a>

        </nav>

        <div class="sidebar-bottom">

            <p class="navigation-title">
                ACCOUNT
            </p>

            <a
                href="<%= contextPath %>/logout"
                class="nav-item logout-item">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </aside>


    <!-- ========================================== -->
    <!-- MAIN CONTENT -->
    <!-- ========================================== -->

    <main class="main-content">

        <!-- TOPBAR -->

        <header class="topbar">

            <div class="topbar-left">

                <h1>
                    Staff Management
                </h1>

                <p>
                    Manage clinic personnel and staff accounts
                </p>

            </div>

            <div class="topbar-right">

                <button
                    type="button"
                    class="icon-button"
                    title="Notifications">

                    <i class="bi bi-bell"></i>

                    <span class="notification-dot"></span>

                </button>

                <div class="user-profile">

                    <div class="user-avatar">

                        <i class="bi bi-person-fill"></i>

                    </div>

                    <div class="user-information">

                        <strong>
                            <%= staffName %>
                        </strong>

                        <span>
                            Administrator
                        </span>

                    </div>

                </div>

            </div>

        </header>


        <!-- ========================================== -->
        <!-- CONTENT -->
        <!-- ========================================== -->

        <section class="dashboard-content">


            <!-- PAGE HEADER -->

            <div class="page-header">

               

                <button
                    type="button"
                    class="add-staff-button"
                    onclick="openAddStaffModal()">

                    <i class="bi bi-person-plus-fill"></i>

                    Add Staff

                </button>

            </div>


            <!-- ========================================== -->
            <!-- MESSAGES -->
            <!-- ========================================== -->

            <% if (successMessage != null
                    && !successMessage.isBlank()) { %>

                <div class="alert success-alert">

                    <i class="bi bi-check-circle-fill"></i>

                    <span>
                        <%= successMessage %>
                    </span>

                </div>

            <% } %>


            <% if (errorMessage != null
                    && !errorMessage.isBlank()) { %>

                <div class="alert error-alert">

                    <i class="bi bi-exclamation-circle-fill"></i>

                    <span>
                        <%= errorMessage %>
                    </span>

                </div>

            <% } %>


            <!-- ========================================== -->
            <!-- STATISTICS -->
            <!-- ========================================== -->

            <section class="statistics-grid">

                <div class="stat-card">

                    <div class="stat-icon staff">

                        <i class="bi bi-people-fill"></i>

                    </div>

                    <div class="stat-information">

                        <span>Total Staff</span>

                        <strong>
                            <%= totalStaff %>
                        </strong>

                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon active">

                        <i class="bi bi-person-check-fill"></i>

                    </div>

                    <div class="stat-information">

                        <span>Active Staff</span>

                        <strong>
                            <%= activeStaff %>
                        </strong>

                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon dentist">

                        <i class="bi bi-hospital"></i>

                    </div>

                    <div class="stat-information">

                        <span>Dentists</span>

                        <strong>
                            <%= dentistCount %>
                        </strong>

                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon other">

                        <i class="bi bi-person-badge-fill"></i>

                    </div>

                    <div class="stat-information">

                        <span>Receptionists / Cashiers</span>

                        <strong>
                            <%= receptionistCount + cashierCount %>
                        </strong>

                    </div>

                </div>

            </section>


            <!-- ========================================== -->
            <!-- STAFF TABLE -->
            <!-- ========================================== -->

            <section class="staff-section">

                <div class="section-header">

                    <div class="section-heading">

                        <h3>
                            Clinic Staff
                        </h3>

                        <p>
                            All staff accounts registered in the system
                        </p>

                    </div>


                    <!-- SEARCH -->

                    <form
                        method="get"
                        action="<%= contextPath %>/admin/staff"
                        class="search-form">

                        <div class="search-box">

                            <i class="bi bi-search"></i>

                            <input
                                type="text"
                                name="search"
                                placeholder="Search staff..."
                                value="<%= searchKeyword != null
                                        ? searchKeyword
                                        : "" %>">

                        </div>

                        <button
                            type="submit"
                            class="search-button">

                            Search

                        </button>

                        <% if (searchKeyword != null
                                && !searchKeyword.isBlank()) { %>

                            <a
                                href="<%= contextPath %>/admin/staff"
                                class="clear-search">

                                Clear

                            </a>

                        <% } %>

                    </form>

                </div>


                <!-- TABLE -->

                <div class="table-wrapper">

                    <table class="staff-table">

                        <thead>

                            <tr>

                                <th>
                                    #
                                </th>

                                <th>
                                    Staff Member
                                </th>

                                <th>
                                    Username
                                </th>

                                <th>
                                    Contact
                                </th>

                                <th>
                                    Role
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Actions
                                </th>

                            </tr>

                        </thead>

                        <tbody>

                        <%
                            if (!staffList.isEmpty()) {

                                for (Staff staff : staffList) {

                                    String role =
                                            staff.getRole() != null
                                            ? staff.getRole()
                                            : "";

                                    String status =
                                            staff.getStatus() != null
                                            ? staff.getStatus()
                                            : "";

                                    String roleClass =
                                            "role-default";

                                    String roleLabel =
                                            role;

                                    if ("DENTIST".equalsIgnoreCase(role)) {

                                        roleClass = "role-dentist";
                                        roleLabel = "Dentist";

                                    } else if (
                                            "RECEPTION".equalsIgnoreCase(role)
                                            ||
                                            "RECEPTIONIST".equalsIgnoreCase(role)) {

                                        roleClass = "role-reception";
                                        roleLabel = "Receptionist";

                                    } else if ("CASHIER".equalsIgnoreCase(role)) {

                                        roleClass = "role-cashier";
                                        roleLabel = "Cashier";

                                    } else if ("ADMIN".equalsIgnoreCase(role)) {

                                        roleClass = "role-admin";
                                        roleLabel = "Administrator";
                                    }

                                    String statusClass =
                                            "ACTIVE".equalsIgnoreCase(status)
                                            ? "status-active"
                                            : "status-inactive";

                                    String statusLabel =
                                            "ACTIVE".equalsIgnoreCase(status)
                                            ? "Active"
                                            : "Inactive";

                                    String initials = "ST";

                                    if (staff.getName() != null
                                            && !staff.getName().isBlank()) {

                                        String[] nameParts =
                                                staff.getName()
                                                        .trim()
                                                        .split("\\s+");

                                        if (nameParts.length >= 2) {

                                            initials =
                                                    (
                                                        nameParts[0]
                                                                .substring(0, 1)
                                                        +
                                                        nameParts[
                                                            nameParts.length - 1
                                                        ].substring(0, 1)
                                                    ).toUpperCase();

                                        } else {

                                            initials =
                                                    nameParts[0]
                                                            .substring(
                                                                    0,
                                                                    Math.min(
                                                                        2,
                                                                        nameParts[0].length()
                                                                    )
                                                            )
                                                            .toUpperCase();
                                        }
                                    }
                        %>

                            <tr>

                                <td>

                                    <span class="staff-number">

                                        #<%= staff.getStaffId() %>

                                    </span>

                                </td>


                                <td>

                                    <div class="staff-person">

                                        <div class="staff-avatar">

                                            <%= initials %>

                                        </div>

                                        <div>

                                            <strong>
                                                <%= staff.getName() %>
                                            </strong>

                                            <span>
                                                Staff ID:
                                                <%= staff.getStaffId() %>
                                            </span>

                                        </div>

                                    </div>

                                </td>


                                <td>

                                    <span class="username">

                                        <%= staff.getUsername() %>

                                    </span>

                                </td>


                                <td>

                                    <span class="contact">

                                        <%= staff.getContactNumber() %>

                                    </span>

                                </td>


                                <td>

                                    <span class="role-badge <%= roleClass %>">

                                        <%= roleLabel %>

                                    </span>

                                </td>


                                <td>

                                    <span class="status-badge <%= statusClass %>">

                                        <span class="status-dot"></span>

                                        <%= statusLabel %>

                                    </span>

                                </td>


                                <td>

                                    <div class="action-buttons">

                                        <button
										    type="button"
										    class="action-button edit-button"
										    title="Edit Staff"
										
										    data-staff-id="<%= staff.getStaffId() %>"
										    data-name="<%= staff.getName() == null ? "" : staff.getName().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
										    data-username="<%= staff.getUsername() == null ? "" : staff.getUsername().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
										    data-contact="<%= staff.getContactNumber() == null ? "" : staff.getContactNumber().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
										    data-role="<%= staff.getRole() == null ? "" : staff.getRole() %>"
										
										    onclick="editStaff(this)">
										
										    <i class="bi bi-pencil"></i>
										
										</button>

                                        <button
											    type="button"
											    class="action-button status-button"
											    title="<%= "ACTIVE".equalsIgnoreCase(status)
											            ? "Deactivate Staff"
											            : "Activate Staff" %>"
											
											    onclick="changeStatus(
											        <%= staff.getStaffId() %>,
											        '<%= status %>'
											    )">
											
											    <i class="bi
											        <%= "ACTIVE".equalsIgnoreCase(status)
											                ? "bi-person-dash"
											                : "bi-person-check" %>">
											    </i>
											
											</button>

                                    </div>

                                </td>

                            </tr>

                        <%
                                }

                            } else {
                        %>

                            <tr>

                                <td colspan="7">

                                    <div class="empty-state">

                                        <i class="bi bi-people"></i>

                                        <strong>
                                            No staff members found
                                        </strong>

                                        <span>
                                            Add a staff member or try another search.
                                        </span>

                                    </div>

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

<div
    class="modal-overlay"
    id="addStaffModal">

    <div class="modal">

        <div class="modal-header">

            <div>

                <h3>
                    Add Staff Member
                </h3>

                <p>
                    Create a new clinic staff account.
                </p>

            </div>

            <button
                type="button"
                class="close-modal"
                onclick="closeAddStaffModal()">

                <i class="bi bi-x-lg"></i>

            </button>

        </div>


        <form
            method="post"
            action="<%= contextPath %>/admin/staff"
            id="addStaffForm">

            <input
                type="hidden"
                name="action"
                value="add">


            <div class="modal-body">

                <div class="form-grid">


                    <!-- ROLE -->

                    <div class="form-group full-width">

                        <label for="role">

                            Staff Role
                            <span class="required">*</span>

                        </label>

                        <select
                            name="role"
                            id="role"
                            required
                            onchange="handleRoleChange()">

                            <option value="">
                                Select staff role
                            </option>

                            <option value="DENTIST">
                                Dentist
                            </option>

                            <option value="RECEPTIONIST">
                                Receptionist
                            </option>

                            <option value="CASHIER">
                                Cashier
                            </option>

                        </select>

                    </div>


                    <!-- NAME -->

                    <div class="form-group">

                        <label for="name">

                            Full Name
                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            name="name"
                            id="name"
                            placeholder="Enter full name"
                            required>

                    </div>


                    <!-- USERNAME -->

                    <div class="form-group">

                        <label for="username">

                            Username
                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            name="username"
                            id="username"
                            placeholder="Enter username"
                            pattern="[A-Za-z]+"
                            title="Username must contain letters only"
                            required>

                        <span class="form-help">
                            Letters only. This will be used for login.
                        </span>

                    </div>


                    <!-- CONTACT -->

                    <div class="form-group">

                        <label for="contactNumber">

                            Contact Number
                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            name="contactNumber"
                            id="contactNumber"
                            placeholder="07XXXXXXXX"
                            required>

                    </div>


                    <!-- EMAIL -->

                    <div class="form-group">

                        <label for="email">

                            Email Address

                        </label>

                        <input
                            type="email"
                            name="email"
                            id="email"
                            placeholder="example@email.com">

                    </div>


                    <!-- ====================================== -->
                    <!-- DENTIST ONLY FIELDS -->
                    <!-- ====================================== -->

                    <div
                        class="dentist-fields"
                        id="dentistFields">

                        <div class="dentist-section-title">

                            Dentist Information

                        </div>


                        <!-- NIC -->

                        <div class="form-group">

                            <label for="nic">

                                NIC
                                <span class="required">*</span>

                            </label>

                            <input
                                type="text"
                                name="nic"
                                id="nic"
                                placeholder="Enter NIC number">

                        </div>


                        <!-- SPECIALIZATION -->

                        <div class="form-group">

                            <label for="specialization">

                                Specialization
                                <span class="required">*</span>

                            </label>

                            <input
                                type="text"
                                name="specialization"
                                id="specialization"
                                placeholder="e.g. Orthodontics">

                        </div>


                        <!-- ROOM -->

                        <div class="form-group full-width">

                            <label for="roomNumber">

                                Room Number
                                <span class="required">*</span>

                            </label>

                            <input
                                type="text"
                                name="roomNumber"
                                id="roomNumber"
                                placeholder="e.g. Room 01">

                        </div>

                    </div>

                </div>


                <!-- PASSWORD INFORMATION -->

                <div class="password-information">

                    <i class="bi bi-shield-lock-fill"></i>

                    <div>

                        <strong>
                            Default password is generated automatically
                        </strong>

                        <span>
                            The system automatically assigns a default
                            password based on the selected role.
                            The password is not entered or changed here.
                            Password changes must be handled by the administrator.
                        </span>

                    </div>

                </div>

            </div>


            <!-- MODAL FOOTER -->

            <div class="modal-footer">

                <button
                    type="button"
                    class="cancel-button"
                    onclick="closeAddStaffModal()">

                    Cancel

                </button>

                <button
                    type="submit"
                    class="save-button">

                    <i class="bi bi-person-plus"></i>
                    Create Staff Account

                </button>

            </div>

        </form>

    </div>

</div>


<!-- =========================================================
     EDIT STAFF MODAL
========================================================= -->

<div
    class="modal-overlay"
    id="editStaffModal">

    <div class="modal">

        <div class="modal-header">

            <div>

                <h3>
                    Edit Staff Member
                </h3>

                <p>
                    Update staff account information.
                </p>

            </div>

            <button
                type="button"
                class="close-modal"
                onclick="closeEditStaffModal()">

                <i class="bi bi-x-lg"></i>

            </button>

        </div>


        <form
            method="post"
            action="<%= contextPath %>/admin/staff"
            id="editStaffForm">

            <input
                type="hidden"
                name="action"
                value="edit">

            <input
                type="hidden"
                name="staffId"
                id="editStaffId">


            <div class="modal-body">

                <div class="form-grid">

                    <!-- ROLE -->

                    <div class="form-group full-width">

                        <label>
                            Staff Role
                        </label>

                        <input
                            type="text"
                            id="editRole"
                            readonly>

                        <span class="form-help">
                            Staff role cannot be changed after the account is created.
                        </span>

                    </div>


                    <!-- NAME -->

                    <div class="form-group">

                        <label for="editName">
                            Full Name
                            <span class="required">*</span>
                        </label>

                        <input
                            type="text"
                            name="name"
                            id="editName"
                            placeholder="Enter full name"
                            required>

                    </div>


                    <!-- USERNAME -->

                    <div class="form-group">

                        <label for="editUsername">
                            Username
                            <span class="required">*</span>
                        </label>

                        <input
                            type="text"
                            name="username"
                            id="editUsername"
                            pattern="[A-Za-z]+"
                            title="Username must contain letters only"
                            placeholder="Enter username"
                            required>

                        <span class="form-help">
                            Letters only. Used for login.
                        </span>

                    </div>


                    <!-- CONTACT -->

                    <div class="form-group">

                        <label for="editContactNumber">
                            Contact Number
                            <span class="required">*</span>
                        </label>

                        <input
                            type="text"
                            name="contactNumber"
                            id="editContactNumber"
                            placeholder="07XXXXXXXX"
                            maxlength="10"
                            required>

                    </div>


                    <!-- EMAIL -->

                    <div class="form-group">

                        <label for="editEmail">
                            Email Address
                        </label>

                        <input
                            type="email"
                            name="email"
                            id="editEmail"
                            placeholder="example@email.com">

                        <span class="form-help">
                            Leave blank if you do not want to change the existing email.
                        </span>

                    </div>

                </div>

            </div>


            <div class="modal-footer">

                <button
                    type="button"
                    class="cancel-button"
                    onclick="closeEditStaffModal()">

                    Cancel

                </button>


                <button
                    type="submit"
                    class="save-button">

                    <i class="bi bi-check-lg"></i>

                    Save Changes

                </button>

            </div>

        </form>

    </div>

</div>


<script>

    /*
     * ==========================================
     * ADD STAFF MODAL
     * ==========================================
     */

    function openAddStaffModal() {

        document
            .getElementById("addStaffModal")
            .classList.add("show");

        document
            .getElementById("role")
            .focus();
    }


    function closeAddStaffModal() {

        document
            .getElementById("addStaffModal")
            .classList.remove("show");

        document
            .getElementById("addStaffForm")
            .reset();

        handleRoleChange();
    }


    /*
     * ==========================================
     * ROLE CHANGE
     * ==========================================
     */

    function handleRoleChange() {

        const role =
            document.getElementById("role").value;

        const dentistFields =
            document.getElementById("dentistFields");

        const nic =
            document.getElementById("nic");

        const specialization =
            document.getElementById("specialization");

        const roomNumber =
            document.getElementById("roomNumber");


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


    /*
     * ==========================================
     * CLOSE MODAL WHEN CLICKING OUTSIDE
     * ==========================================
     */

    document
        .getElementById("addStaffModal")
        .addEventListener(
            "click",
            function(event) {

                if (event.target === this) {

                    closeAddStaffModal();
                }
            }
        );


    /*
     * ==========================================
     * ESC KEY
     * ==========================================
     */

    document.addEventListener(
        "keydown",
        function(event) {

            if (event.key === "Escape") {

                closeAddStaffModal();
            }
        }
    );


  

</script>

<script>

/* =========================================================
   ADD STAFF MODAL
========================================================= */

function openAddStaffModal() {

    const modal =
        document.getElementById("addStaffModal");

    modal.classList.add("show");

    document
        .getElementById("role")
        .focus();
}


function closeAddStaffModal() {

    const modal =
        document.getElementById("addStaffModal");

    modal.classList.remove("show");

    const form =
        document.getElementById("addStaffForm");

    if (form) {
        form.reset();
    }

    handleRoleChange();
}


/* =========================================================
   ROLE CHANGE
========================================================= */

function handleRoleChange() {

    const role =
        document.getElementById("role").value;

    const dentistFields =
        document.getElementById("dentistFields");

    const nic =
        document.getElementById("nic");

    const specialization =
        document.getElementById("specialization");

    const roomNumber =
        document.getElementById("roomNumber");


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


/* =========================================================
   EDIT STAFF
========================================================= */

function editStaff(button) {

    if (!button) {
        return;
    }

    const staffId =
        button.dataset.staffId;

    const name =
        button.dataset.name || "";

    const username =
        button.dataset.username || "";

    const contact =
        button.dataset.contact || "";

    const role =
        button.dataset.role || "";


    document
        .getElementById("editStaffId")
        .value = staffId;


    document
        .getElementById("editName")
        .value = name;


    document
        .getElementById("editUsername")
        .value = username;


    document
        .getElementById("editContactNumber")
        .value = contact;


    document
        .getElementById("editRole")
        .value = formatRole(role);


    /*
     * Email is intentionally left empty.
     * The service preserves the existing email
     * when this field is empty.
     */

    document
        .getElementById("editEmail")
        .value = "";


    document
        .getElementById("editStaffModal")
        .classList.add("show");


    document
        .getElementById("editName")
        .focus();
}


/* =========================================================
   FORMAT ROLE
========================================================= */

function formatRole(role) {

    if (!role) {
        return "";
    }

    role =
        role.toUpperCase();


    if (role === "DENTIST") {
        return "Dentist";
    }

    if (
        role === "RECEPTION"
        ||
        role === "RECEPTIONIST"
    ) {
        return "Receptionist";
    }

    if (role === "CASHIER") {
        return "Cashier";
    }

    if (role === "ADMIN") {
        return "Administrator";
    }

    return role;
}


/* =========================================================
   CLOSE EDIT MODAL
========================================================= */

function closeEditStaffModal() {

    document
        .getElementById("editStaffModal")
        .classList.remove("show");
}


/* =========================================================
   CHANGE STAFF STATUS
========================================================= */

function changeStatus(
    staffId,
    currentStatus
) {

    if (!staffId) {
        return;
    }


    const isActive =
        String(currentStatus)
            .toUpperCase() === "ACTIVE";


    const actionText =
        isActive
            ? "deactivate"
            : "activate";


    const confirmed =
        confirm(
            "Are you sure you want to "
            + actionText
            + " this staff member?"
        );


    if (!confirmed) {
        return;
    }


    /*
     * Create a POST form dynamically.
     * The server checks the actual database
     * status before changing it.
     */

    const form =
        document.createElement("form");

    form.method = "POST";

    form.action =
        "<%= contextPath %>/admin/staff";


    const actionInput =
        document.createElement("input");

    actionInput.type = "hidden";

    actionInput.name = "action";

    actionInput.value = "changeStatus";


    const staffIdInput =
        document.createElement("input");

    staffIdInput.type = "hidden";

    staffIdInput.name = "staffId";

    staffIdInput.value = staffId;


    form.appendChild(actionInput);

    form.appendChild(staffIdInput);


    document.body.appendChild(form);

    form.submit();
}


/* =========================================================
   CLOSE MODALS WHEN CLICKING OUTSIDE
========================================================= */

const addModal =
    document.getElementById("addStaffModal");

if (addModal) {

    addModal.addEventListener(
        "click",
        function(event) {

            if (event.target === this) {

                closeAddStaffModal();
            }
        }
    );
}


const editModal =
    document.getElementById("editStaffModal");

if (editModal) {

    editModal.addEventListener(
        "click",
        function(event) {

            if (event.target === this) {

                closeEditStaffModal();
            }
        }
    );
}


/* =========================================================
   ESC KEY
========================================================= */

document.addEventListener(
    "keydown",
    function(event) {

        if (event.key !== "Escape") {
            return;
        }


        const addModal =
            document.getElementById("addStaffModal");

        const editModal =
            document.getElementById("editStaffModal");


        if (
            addModal
            &&
            addModal.classList.contains("show")
        ) {

            closeAddStaffModal();

            return;
        }


        if (
            editModal
            &&
            editModal.classList.contains("show")
        ) {

            closeEditStaffModal();
        }
    }
);


/* =========================================================
   CONTACT NUMBER VALIDATION
========================================================= */

const editContact =
    document.getElementById(
        "editContactNumber"
    );

if (editContact) {

    editContact.addEventListener(
        "input",
        function() {

            this.value =
                this.value
                    .replace(/\D/g, "")
                    .substring(0, 10);
        }
    );
}


const addContact =
    document.getElementById(
        "contactNumber"
    );

if (addContact) {

    addContact.addEventListener(
        "input",
        function() {

            this.value =
                this.value
                    .replace(/\D/g, "")
                    .substring(0, 10);
        }
    );
}


/* =========================================================
   AUTO HIDE SUCCESS / ERROR MESSAGES
========================================================= */

setTimeout(
    function() {

        const alerts =
            document.querySelectorAll(
                ".alert"
            );

        alerts.forEach(
            function(alert) {

                alert.style.transition =
                    "opacity 0.4s ease";

                alert.style.opacity = "0";

                setTimeout(
                    function() {

                        alert.remove();

                    },
                    400
                );
            }
        );

    },
    5000
);

</script>

</body>

</html>