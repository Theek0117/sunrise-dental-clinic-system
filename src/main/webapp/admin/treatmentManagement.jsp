<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>

<%

    String contextPath =
            request.getContextPath();

    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null
            || staffName.isBlank()) {

        staffName = "Administrator";
    }


    List<TreatmentType> treatmentTypes =
            (List<TreatmentType>)
                    request.getAttribute(
                            "treatmentTypes"
                    );


    if (treatmentTypes == null) {

        treatmentTypes =
                new java.util.ArrayList<>();
    }


    String searchKeyword =
            (String) request.getAttribute(
                    "searchKeyword"
            );


    String successMessage =
            request.getParameter("success");

    String errorMessage =
            request.getParameter("error");


    String adminInitials = "AD";


    if (staffName != null
            && !staffName.isBlank()) {

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
        Treatment Management | Sunrise Dental Clinic
    </title>


    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">


    <link rel="stylesheet"
          href="<%= contextPath %>/css/reception.css">


    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <style>

        .management-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            gap: 20px;

            margin-bottom: 25px;
        }


        .management-title h2 {

            margin: 0;

            color: #0c3d4f;

            font-size: 24px;

            font-weight: 700;
        }


        .management-title p {

            margin: 5px 0 0;

            color: #78909c;

            font-size: 13px;
        }


        .primary-button {

            border: none;

            background: #0ea5b4;

            color: white;

            padding: 12px 18px;

            border-radius: 10px;

            font-family: Poppins, sans-serif;

            font-size: 13px;

            font-weight: 600;

            cursor: pointer;

            display: inline-flex;

            align-items: center;

            gap: 8px;

            text-decoration: none;

            transition: 0.2s ease;
        }


        .primary-button:hover {

            background: #0c8f9d;

            transform: translateY(-1px);
        }


        .search-card {

            background: white;

            border-radius: 14px;

            padding: 18px;

            margin-bottom: 20px;

            border: 1px solid #e5eef2;

            box-shadow: 0 5px 18px rgba(12, 61, 79, 0.05);
        }


        .search-form {

            display: flex;

            gap: 10px;

            width: 100%;
        }


        .search-wrapper {

            position: relative;

            flex: 1;
        }


        .search-wrapper i {

            position: absolute;

            left: 14px;

            top: 50%;

            transform: translateY(-50%);

            color: #8aa0aa;
        }


        .search-input {

            width: 100%;

            box-sizing: border-box;

            border: 1px solid #d9e6eb;

            border-radius: 10px;

            padding: 12px 15px 12px 42px;

            outline: none;

            font-family: Poppins, sans-serif;

            font-size: 13px;

            color: #294653;
        }


        .search-input:focus {

            border-color: #0ea5b4;

            box-shadow:
                0 0 0 3px
                rgba(14, 165, 180, 0.08);
        }


        .search-button {

            border: none;

            border-radius: 10px;

            padding: 0 20px;

            background: #0c3d4f;

            color: white;

            font-family: Poppins, sans-serif;

            font-weight: 600;

            cursor: pointer;
        }


        .table-card {

            background: white;

            border-radius: 14px;

            border: 1px solid #e5eef2;

            box-shadow:
                0 5px 18px
                rgba(12, 61, 79, 0.05);

            overflow: hidden;
        }


        .table-header {

            padding: 20px 22px;

            border-bottom: 1px solid #edf3f5;

            display: flex;

            justify-content: space-between;

            align-items: center;
        }


        .table-header h3 {

            margin: 0;

            color: #0c3d4f;

            font-size: 16px;

            font-weight: 700;
        }


        .table-header span {

            color: #8aa0aa;

            font-size: 12px;
        }


        .treatment-table {

            width: 100%;

            border-collapse: collapse;
        }


        .treatment-table th {

            text-align: left;

            padding: 14px 20px;

            background: #f7fafb;

            color: #6d8791;

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.4px;
        }


        .treatment-table td {

            padding: 16px 20px;

            border-top: 1px solid #edf3f5;

            color: #45616d;

            font-size: 13px;
        }


        .treatment-name {

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .treatment-icon {

            width: 40px;

            height: 40px;

            border-radius: 10px;

            background: #e8f8fa;

            color: #0ea5b4;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 17px;
        }


        .treatment-name strong {

            color: #0c3d4f;

            font-weight: 600;
        }


        .treatment-name small {

            display: block;

            margin-top: 2px;

            color: #9aadb5;

            font-size: 11px;
        }


        .price {

            color: #0c3d4f;

            font-size: 14px;

            font-weight: 700;
        }


        .status-badge {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            padding: 6px 10px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 600;
        }


        .status-badge.active {

            background: #e8f8ef;

            color: #17804c;
        }


        .status-badge.inactive {

            background: #fceced;

            color: #b64048;
        }


        .status-dot {

            width: 6px;

            height: 6px;

            border-radius: 50%;

            background: currentColor;
        }


        .action-group {

            display: flex;

            gap: 7px;
        }


        .action-button {

            width: 34px;

            height: 34px;

            border: none;

            border-radius: 8px;

            display: flex;

            align-items: center;

            justify-content: center;

            cursor: pointer;

            font-size: 14px;

            transition: 0.2s ease;
        }


        .edit-button {

            background: #eaf5ff;

            color: #2774b8;
        }


        .edit-button:hover {

            background: #d8edff;
        }


        .activate-button {

            background: #e8f8ef;

            color: #17804c;
        }


        .activate-button:hover {

            background: #d6f2e2;
        }


        .deactivate-button {

            background: #fceced;

            color: #b64048;
        }


        .deactivate-button:hover {

            background: #f8dfe1;
        }


        .empty-state {

            text-align: center;

            padding: 55px 20px;

            color: #8da4ae;
        }


        .empty-state i {

            display: block;

            font-size: 40px;

            color: #b7cbd3;

            margin-bottom: 10px;
        }


        .alert {

            padding: 13px 16px;

            border-radius: 10px;

            margin-bottom: 20px;

            font-size: 13px;

            font-weight: 500;
        }


        .alert-success {

            background: #e9f8ef;

            color: #18794e;

            border: 1px solid #ccefdc;
        }


        .alert-error {

            background: #fff0f1;

            color: #b43f47;

            border: 1px solid #f3d0d3;
        }


        .modal-overlay {

            position: fixed;

            inset: 0;

            background: rgba(8, 40, 51, 0.48);

            display: none;

            align-items: center;

            justify-content: center;

            z-index: 9999;

            padding: 20px;
        }


        .modal-overlay.show {

            display: flex;
        }


        .modal {

            width: 100%;

            max-width: 480px;

            background: white;

            border-radius: 16px;

            box-shadow:
                0 20px 60px
                rgba(0, 0, 0, 0.2);

            overflow: hidden;
        }


        .modal-header {

            padding: 20px 22px;

            border-bottom: 1px solid #edf3f5;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .modal-header h3 {

            margin: 0;

            color: #0c3d4f;

            font-size: 18px;
        }


        .modal-close {

            width: 34px;

            height: 34px;

            border: none;

            border-radius: 8px;

            background: #f1f5f6;

            color: #67818b;

            cursor: pointer;

            font-size: 17px;
        }


        .modal-body {

            padding: 22px;
        }


        .form-group {

            margin-bottom: 17px;
        }


        .form-group label {

            display: block;

            margin-bottom: 7px;

            color: #45616d;

            font-size: 12px;

            font-weight: 600;
        }


        .form-group input {

            width: 100%;

            box-sizing: border-box;

            padding: 12px 13px;

            border: 1px solid #d9e6eb;

            border-radius: 9px;

            outline: none;

            font-family: Poppins, sans-serif;

            font-size: 13px;
        }


        .form-group input:focus {

            border-color: #0ea5b4;

            box-shadow:
                0 0 0 3px
                rgba(14, 165, 180, 0.08);
        }


        .modal-footer {

            padding: 16px 22px;

            background: #f9fbfc;

            border-top: 1px solid #edf3f5;

            display: flex;

            justify-content: flex-end;

            gap: 10px;
        }


        .secondary-button {

            border: 1px solid #d7e4e8;

            background: white;

            color: #607985;

            border-radius: 9px;

            padding: 10px 17px;

            font-family: Poppins, sans-serif;

            font-size: 12px;

            font-weight: 600;

            cursor: pointer;
        }


        .modal-submit {

            border: none;

            background: #0ea5b4;

            color: white;

            border-radius: 9px;

            padding: 10px 17px;

            font-family: Poppins, sans-serif;

            font-size: 12px;

            font-weight: 600;

            cursor: pointer;
        }


        @media (max-width: 768px) {

            .management-header {

                align-items: flex-start;

                flex-direction: column;
            }


            .search-form {

                flex-direction: column;
            }


            .search-button {

                height: 42px;
            }


            .table-card {

                overflow-x: auto;
            }


            .treatment-table {

                min-width: 700px;
            }
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
                class="nav-item">

                <i class="bi bi-people-fill"></i>

                <span>Staff Management</span>

            </a>


            <a
                href="<%= contextPath %>/admin/patients"
                class="nav-item">

                <i class="bi bi-person-lines-fill"></i>

                <span>Patients</span>

            </a>


            <a
                href="<%= contextPath %>/admin/appointments"
                class="nav-item">

                <i class="bi bi-calendar2-week"></i>

                <span>Appointments</span>

            </a>


            <a
                href="<%= contextPath %>/admin/treatments"
                class="nav-item active">

                <i class="bi bi-journal-medical"></i>

                <span>Treatments</span>

            </a>


            <p class="navigation-title clinic-title">
                ANALYTICS
            </p>


            <a
                href="<%= contextPath %>/admin/reports"
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


    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->

    <main class="main-content">


        <!-- TOPBAR -->

        <header class="topbar">

            <div class="topbar-left">

                <h1>
                    Treatment Management
                </h1>

                <p>
                    Manage treatment types and basic pricing
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


        <!-- ========================================= -->
        <!-- PAGE CONTENT -->
        <!-- ========================================= -->

        <section class="dashboard-content">


            <!-- ALERTS -->

            <% if (successMessage != null
                    && !successMessage.isBlank()) { %>

                <div class="alert alert-success">

                    <i class="bi bi-check-circle-fill"></i>

                    <%= successMessage %>

                </div>

            <% } %>


            <% if (errorMessage != null
                    && !errorMessage.isBlank()) { %>

                <div class="alert alert-error">

                    <i class="bi bi-exclamation-circle-fill"></i>

                    <%= errorMessage %>

                </div>

            <% } %>


            <!-- PAGE HEADER -->

            <div class="management-header">

                <div class="management-title">

                    <h2>
                        Treatment Types
                    </h2>

                    <p>
                        Maintain the clinic's treatment catalogue
                        and standard treatment costs.
                    </p>

                </div>


                <button
                    type="button"
                    class="primary-button"
                    onclick="openAddModal()">

                    <i class="bi bi-plus-lg"></i>

                    Add Treatment

                </button>

            </div>


            <!-- SEARCH -->

            <div class="search-card">

                <form
                    method="get"
                    action="<%= contextPath %>/admin/treatments"
                    class="search-form">

                    <div class="search-wrapper">

                        <i class="bi bi-search"></i>

                        <input
                            type="text"
                            name="search"
                            class="search-input"
                            placeholder="Search treatment types..."
                            value="<%= searchKeyword != null
                                    ? searchKeyword
                                    : "" %>">

                    </div>


                    <button
                        type="submit"
                        class="search-button">

                        Search

                    </button>

                </form>

            </div>


            <!-- TABLE -->

            <div class="table-card">

                <div class="table-header">

                    <h3>
                        Treatment Catalogue
                    </h3>

                    <span>
                        <%= treatmentTypes.size() %>
                        treatment type(s)
                    </span>

                </div>


                <table class="treatment-table">

                    <thead>

                    <tr>

                        <th>
                            Treatment
                        </th>

                        <th>
                            Basic Cost
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

                        boolean found = false;

                        String search =
                                searchKeyword != null
                                        ? searchKeyword
                                                .trim()
                                                .toLowerCase()
                                        : "";

                        for (
                            TreatmentType treatmentType
                                : treatmentTypes
                        ) {

                            String treatmentName =
                                    treatmentType
                                            .getTreatmentName();

                            if (!search.isEmpty()
                                    && (
                                        treatmentName == null
                                        ||
                                        !treatmentName
                                            .toLowerCase()
                                            .contains(search)
                                    )) {

                                continue;
                            }

                            found = true;

                            String status =
                                    treatmentType.getStatus();

                            String statusClass =
                                    "ACTIVE".equalsIgnoreCase(status)
                                    ? "active"
                                    : "inactive";

                    %>

                    <tr>

                        <td>

                            <div class="treatment-name">

                                <div class="treatment-icon">

                                    <i class="bi bi-tooth"></i>

                                </div>

                                <div>

                                    <strong>
                                        <%= treatmentName %>
                                    </strong>

                                    <small>
                                        Treatment Type
                                    </small>

                                </div>

                            </div>

                        </td>


                        <td>

                            <span class="price">

                                Rs.
                                <%= treatmentType
                                        .getBasicCost() %>

                            </span>

                        </td>


                        <td>

                            <span
                                class="status-badge <%= statusClass %>">

                                <span
                                    class="status-dot">
                                </span>

                                <%= status %>

                            </span>

                        </td>


                        <td>

                            <div class="action-group">


                                <!-- EDIT -->

                                <button
                                    type="button"
                                    class="action-button edit-button"
                                    title="Edit Treatment"
                                    onclick="openEditModal(
                                        '<%= treatmentType
                                                .getTreatmentTypeId() %>',
                                        '<%= escapeJs(
                                                treatmentType
                                                        .getTreatmentName()
                                        ) %>',
                                        '<%= treatmentType
                                                .getBasicCost() %>'
                                    )">

                                    <i class="bi bi-pencil"></i>

                                </button>


                                <!-- STATUS -->

                                <form
                                    method="post"
                                    action="<%= contextPath %>/admin/treatments"
                                    style="display:inline;">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="changeStatus">

                                    <input
                                        type="hidden"
                                        name="treatmentTypeId"
                                        value="<%= treatmentType
                                                .getTreatmentTypeId() %>">


                                    <% if ("ACTIVE".equalsIgnoreCase(status)) { %>

                                        <button
                                            type="submit"
                                            class="action-button deactivate-button"
                                            title="Deactivate"
                                            onclick="return confirm(
                                                'Are you sure you want to deactivate this treatment type?'
                                            );">

                                            <i class="bi bi-pause-circle"></i>

                                        </button>

                                    <% } else { %>

                                        <button
                                            type="submit"
                                            class="action-button activate-button"
                                            title="Activate">

                                            <i class="bi bi-play-circle"></i>

                                        </button>

                                    <% } %>

                                </form>

                            </div>

                        </td>

                    </tr>


                    <% } %>


                    <% if (!found) { %>

                    <tr>

                        <td
                            colspan="4"
                            class="empty-state">

                            <i class="bi bi-search"></i>

                            No treatment types found.

                        </td>

                    </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>


<!-- ========================================= -->
<!-- ADD MODAL -->
<!-- ========================================= -->

<div
    class="modal-overlay"
    id="addModal">

    <div class="modal">

        <div class="modal-header">

            <h3>
                Add Treatment Type
            </h3>

            <button
                type="button"
                class="modal-close"
                onclick="closeAddModal()">

                <i class="bi bi-x-lg"></i>

            </button>

        </div>


        <form
            method="post"
            action="<%= contextPath %>/admin/treatments">

            <input
                type="hidden"
                name="action"
                value="add">


            <div class="modal-body">

                <div class="form-group">

                    <label>
                        Treatment Name
                    </label>

                    <input
                        type="text"
                        name="treatmentName"
                        placeholder="e.g. Dental Cleaning"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Basic Cost (Rs.)
                    </label>

                    <input
                        type="number"
                        name="basicCost"
                        min="0"
                        step="0.01"
                        placeholder="0.00"
                        required>

                </div>

            </div>


            <div class="modal-footer">

                <button
                    type="button"
                    class="secondary-button"
                    onclick="closeAddModal()">

                    Cancel

                </button>


                <button
                    type="submit"
                    class="modal-submit">

                    <i class="bi bi-check-lg"></i>

                    Save Treatment

                </button>

            </div>

        </form>

    </div>

</div>


<!-- ========================================= -->
<!-- EDIT MODAL -->
<!-- ========================================= -->

<div
    class="modal-overlay"
    id="editModal">

    <div class="modal">

        <div class="modal-header">

            <h3>
                Edit Treatment Type
            </h3>

            <button
                type="button"
                class="modal-close"
                onclick="closeEditModal()">

                <i class="bi bi-x-lg"></i>

            </button>

        </div>


        <form
            method="post"
            action="<%= contextPath %>/admin/treatments">

            <input
                type="hidden"
                name="action"
                value="edit">


            <input
                type="hidden"
                name="treatmentTypeId"
                id="editTreatmentTypeId">


            <div class="modal-body">

                <div class="form-group">

                    <label>
                        Treatment Name
                    </label>

                    <input
                        type="text"
                        name="treatmentName"
                        id="editTreatmentName"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Basic Cost (Rs.)
                    </label>

                    <input
                        type="number"
                        name="basicCost"
                        id="editBasicCost"
                        min="0"
                        step="0.01"
                        required>

                </div>

            </div>


            <div class="modal-footer">

                <button
                    type="button"
                    class="secondary-button"
                    onclick="closeEditModal()">

                    Cancel

                </button>


                <button
                    type="submit"
                    class="modal-submit">

                    <i class="bi bi-check-lg"></i>

                    Update Treatment

                </button>

            </div>

        </form>

    </div>

</div>


<script>

    function openAddModal() {

        document
            .getElementById("addModal")
            .classList.add("show");
    }


    function closeAddModal() {

        document
            .getElementById("addModal")
            .classList.remove("show");
    }


    function openEditModal(
        id,
        name,
        cost
    ) {

        document
            .getElementById(
                "editTreatmentTypeId"
            )
            .value = id;


        document
            .getElementById(
                "editTreatmentName"
            )
            .value = name;


        document
            .getElementById(
                "editBasicCost"
            )
            .value = cost;


        document
            .getElementById("editModal")
            .classList.add("show");
    }


    function closeEditModal() {

        document
            .getElementById("editModal")
            .classList.remove("show");
    }


    document
        .getElementById("addModal")
        .addEventListener(
            "click",
            function(event) {

                if (event.target === this) {

                    closeAddModal();
                }
            }
        );


    document
        .getElementById("editModal")
        .addEventListener(
            "click",
            function(event) {

                if (event.target === this) {

                    closeEditModal();
                }
            }
        );

</script>


<%!

    private String escapeJs(String value) {

        if (value == null) {

            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

%>


</body>

</html>