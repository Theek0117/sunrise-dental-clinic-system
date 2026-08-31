<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.sunrise.dental.model.Patient" %>

<%
    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }

    List<Patient> patients =
            (List<Patient>) request.getAttribute("patients");

    if (patients == null) {
        patients = Collections.emptyList();
    }

    String contextPath =
            request.getContextPath();
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Patient Records | Sunrise Dental Clinic
    </title>

    <link
        rel="stylesheet"
        href="<%= contextPath %>/css/reception.css"
    >

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    >

    <style>

        .patients-page {
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-header h2 {
            margin: 0;
            color: #17324d;
            font-size: 25px;
        }

        .page-header p {
            margin: 7px 0 0;
            color: #78909c;
            font-size: 14px;
        }

        .record-count {
            padding: 9px 16px;
            border-radius: 20px;
            background: #edfafd;
            color: #079eb5;
            font-size: 13px;
            font-weight: 600;
        }

        .patients-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(30, 70, 90, 0.08);
            overflow: hidden;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        .patients-table {
            width: 100%;
            border-collapse: collapse;
        }

        .patients-table th {
            padding: 15px 18px;
            background: #f7fafb;
            text-align: left;
            color: #78909c;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: .4px;
            white-space: nowrap;
        }

        .patients-table td {
            padding: 16px 18px;
            border-bottom: 1px solid #edf2f4;
            color: #45606e;
            font-size: 13px;
            vertical-align: middle;
        }

        .patients-table tr:last-child td {
            border-bottom: none;
        }

        .patient-cell {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 200px;
        }

        .patient-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #edfafd;
            color: #079eb5;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .patient-name {
            color: #294b5c;
            font-weight: 600;
        }

        .patient-number {
            display: block;
            margin-top: 3px;
            color: #91a4ad;
            font-size: 11px;
        }

        .status {
            display: inline-flex;
            padding: 6px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .status-active {
            background: #eaf8ef;
            color: #16844a;
        }

        .status-inactive {
            background: #fdecec;
            color: #d53a3a;
        }

        .empty-state {
            padding: 65px 20px;
            text-align: center;
            color: #78909c;
        }

        .empty-state i {
            display: block;
            font-size: 42px;
            margin-bottom: 15px;
            color: #b5cbd4;
        }

        .empty-state strong {
            display: block;
            margin-bottom: 5px;
            color: #45606e;
            font-size: 15px;
        }

        @media (max-width: 768px) {

            .patients-page {
                padding: 20px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

        }

    </style>

</head>


<body>

<div class="dashboard-container">

    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside
        class="sidebar"
        id="sidebar"
    >

        <div class="sidebar-brand">

            <img
                src="<%= contextPath %>/images/logo1.png"
                alt="Sunrise Dental Clinic Logo"
            >

            <div class="brand-text">

                <h2>Sunrise</h2>

                <span>
                    Dental Clinic
                </span>

            </div>

        </div>


        <nav class="sidebar-navigation">

            <p class="navigation-title">
                MAIN
            </p>


            <a
                href="<%= contextPath %>/dentist/dashboard"
                class="nav-item"
            >

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="<%= contextPath %>/dentist/appointments"
                class="nav-item"
            >

                <i class="bi bi-calendar-check"></i>

                <span>
                    My Appointments
                </span>

            </a>


            <div class="nav-group open">

                <button
                    type="button"
                    class="nav-item nav-parent"
                    onclick="this.parentElement.classList.toggle('open')"
                >

                    <span class="nav-item-left">

                        <i class="bi bi-people"></i>

                        <span>
                            My Patients
                        </span>

                    </span>

                    <i class="bi bi-chevron-down nav-chevron"></i>

                </button>


                <div class="nav-submenu">

                    <a
                        href="<%= contextPath %>/dentist/patients"
                        class="nav-subitem active"
                    >

                        <i class="bi bi-person-lines-fill"></i>

                        <span>
                            Patient Records
                        </span>

                    </a>


                    <a
                        href="<%= contextPath %>/dentist/treatment-history"
                        class="nav-subitem"
                    >

                        <i class="bi bi-clock-history"></i>

                        <span>
                            Treatment History
                        </span>

                    </a>

                </div>

            </div>


            <a
                href="<%= contextPath %>/dentist/availability"
                class="nav-item"
            >

                <i class="bi bi-calendar2-week"></i>

                <span>
                    My Availability
                </span>

            </a>


            <p class="navigation-title clinic-title">
                CLINIC
            </p>


            <a
                href="#"
                class="nav-item"
            >

                <i class="bi bi-question-circle"></i>

                <span>
                    Help Desk
                </span>

            </a>

        </nav>

    </aside>


    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">

        <header class="topbar">

            <div class="topbar-left">

                <button
                    type="button"
                    class="menu-button"
                    id="menuButton"
                >

                    <i class="bi bi-list"></i>

                </button>


                <div>

                    <strong>
                        Patient Records
                    </strong>

                    <span>
                        Registered patients
                    </span>

                </div>

            </div>


            <div class="topbar-right">

                <button
                    type="button"
                    class="icon-button"
                    title="Notifications"
                >

                    <i class="bi bi-bell"></i>

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
                            Dentist
                        </span>

                    </div>

                    <i class="bi bi-chevron-down profile-arrow"></i>

                </div>

            </div>

        </header>


        <section class="patients-page">


            <div class="page-header">

                <div>

                    <h2>
                        Patient Records
                    </h2>

                    <p>
                        View registered patient information.
                    </p>

                </div>


                <div class="record-count">

                    <i class="bi bi-people"></i>

                    <%= patients.size() %>

                    Patient<%= patients.size() == 1 ? "" : "s" %>

                </div>

            </div>


            <div class="patients-card">

                <% if (patients.isEmpty()) { %>

                    <div class="empty-state">

                        <i class="bi bi-person-x"></i>

                        <strong>
                            No patient records found
                        </strong>

                        <span>
                            There are currently no patients registered.
                        </span>

                    </div>

                <% } else { %>


                    <div class="table-wrapper">

                        <table class="patients-table">

                            <thead>

                            <tr>

                                <th>
                                    Patient
                                </th>

                                <th>
                                    Contact Number
                                </th>

                                <th>
                                    Email
                                </th>

                                <th>
                                    Address
                                </th>

                                <th>
                                    Status
                                </th>

                            </tr>

                            </thead>


                            <tbody>

                            <% for (Patient patient : patients) { %>

                                <%
                                    String initials = "P";

                                    if (patient.getName() != null
                                            && !patient.getName().trim().isEmpty()) {

                                        String[] parts =
                                                patient.getName()
                                                        .trim()
                                                        .split("\\s+");

                                        if (parts.length >= 2) {

                                            initials =
                                                    (
                                                        parts[0].substring(0, 1)
                                                        +
                                                        parts[parts.length - 1]
                                                                .substring(0, 1)
                                                    ).toUpperCase();

                                        } else {

                                            initials =
                                                    parts[0]
                                                            .substring(
                                                                    0,
                                                                    Math.min(
                                                                            2,
                                                                            parts[0].length()
                                                                    )
                                                            )
                                                            .toUpperCase();

                                        }

                                    }

                                    String status =
                                            patient.getStatus() != null
                                                    ? patient.getStatus()
                                                    : "UNKNOWN";

                                    boolean active =
                                            "ACTIVE".equalsIgnoreCase(status);
                                %>


                                <tr>

                                    <td>

                                        <div class="patient-cell">

                                            <div class="patient-avatar">
                                                <%= initials %>
                                            </div>


                                            <div>

                                                <div class="patient-name">

                                                    <%= patient.getName() != null
                                                            ? patient.getName()
                                                            : "-" %>

                                                </div>


                                                <span class="patient-number">

                                                    <%= patient.getPatientNumber() != null
                                                            ? patient.getPatientNumber()
                                                            : "-" %>

                                                </span>

                                            </div>

                                        </div>

                                    </td>


                                    <td>

                                        <%= patient.getContactNumber() != null
                                                ? patient.getContactNumber()
                                                : "-" %>

                                    </td>


                                    <td>

                                        <%= patient.getEmail() != null
                                                ? patient.getEmail()
                                                : "-" %>

                                    </td>


                                    <td>

                                        <%= patient.getAddress() != null
                                                ? patient.getAddress()
                                                : "-" %>

                                    </td>


                                    <td>

                                        <span class="status <%= active
                                                ? "status-active"
                                                : "status-inactive" %>">

                                            <%= status %>

                                        </span>

                                    </td>

                                </tr>


                            <% } %>

                            </tbody>

                        </table>

                    </div>


                <% } %>

            </div>

        </section>

    </main>

</div>


<script>

    const menuButton =
        document.getElementById("menuButton");

    const sidebar =
        document.getElementById("sidebar");

    if (menuButton && sidebar) {

        menuButton.addEventListener(
            "click",
            function () {

                sidebar.classList.toggle(
                    "sidebar-open"
                );

            }
        );

    }

</script>

</body>

</html>