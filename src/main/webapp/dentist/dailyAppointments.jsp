<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    /*
     * =========================================================
     * SESSION
     * =========================================================
     */

    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }


    /*
     * =========================================================
     * DENTIST
     * =========================================================
     */

    Dentist loggedInDentist =
            (Dentist) request.getAttribute(
                    "loggedInDentist"
            );

    String dentistName = staffName;

    if (loggedInDentist != null
            && loggedInDentist.getName() != null
            && !loggedInDentist.getName().isBlank()) {

        dentistName =
                loggedInDentist.getName();
    }


    /*
     * =========================================================
     * SELECTED DATE
     *
     * IMPORTANT:
     * The servlet is responsible for deciding the date.
     * The JSP simply displays that value.
     * =========================================================
     */

    java.sql.Date selectedDate =
            (java.sql.Date) request.getAttribute(
                    "selectedDate"
            );

    String selectedLocalDate =
            (String) request.getAttribute(
                    "selectedLocalDate"
            );

    /*
     * Safety fallback only.
     * Normally the servlet will ALWAYS provide this value.
     */

    if (selectedLocalDate == null
            || selectedLocalDate.isBlank()) {

        if (selectedDate != null) {

            selectedLocalDate =
                    selectedDate.toLocalDate().toString();

        } else {

            selectedLocalDate =
                    java.time.LocalDate.now().toString();
        }
    }


    /*
     * =========================================================
     * APPOINTMENTS
     * =========================================================
     */

    List<Appointment> appointments =
            (List<Appointment>)
                    request.getAttribute(
                            "appointments"
                    );

    Map<Integer, Patient> patients =
            (Map<Integer, Patient>)
                    request.getAttribute(
                            "patients"
                    );

    if (appointments == null) {

        appointments =
                java.util.Collections.emptyList();
    }

    if (patients == null) {

        patients =
                java.util.Collections.emptyMap();
    }


    /*
     * =========================================================
     * STATISTICS
     * =========================================================
     */

    Integer appointmentCount =
            (Integer) request.getAttribute(
                    "appointmentCount"
            );

    Integer confirmedCount =
            (Integer) request.getAttribute(
                    "confirmedCount"
            );

    Integer pendingCount =
            (Integer) request.getAttribute(
                    "pendingCount"
            );

    Integer completedCount =
            (Integer) request.getAttribute(
                    "completedCount"
            );

    if (appointmentCount == null) {
        appointmentCount = 0;
    }

    if (confirmedCount == null) {
        confirmedCount = 0;
    }

    if (pendingCount == null) {
        pendingCount = 0;
    }

    if (completedCount == null) {
        completedCount = 0;
    }


    /*
     * =========================================================
     * DATE FORMATTERS
     * =========================================================
     */

    SimpleDateFormat displayDateFormat =
            new SimpleDateFormat(
                    "EEEE, MMMM d, yyyy"
            );

    SimpleDateFormat timeFormat =
            new SimpleDateFormat(
                    "hh:mm a"
            );

    String displayDate =
            selectedDate != null
                    ? displayDateFormat.format(selectedDate)
                    : "Selected Date";


    /*
     * =========================================================
     * DENTIST INITIALS
     * =========================================================
     */

    String dentistInitials = "DR";

    if (dentistName != null
            && !dentistName.isBlank()) {

        String[] nameParts =
                dentistName.trim()
                        .split("\\s+");

        if (nameParts.length >= 2) {

            dentistInitials =
                    (
                        nameParts[0].substring(0, 1)
                        +
                        nameParts[
                                nameParts.length - 1
                        ].substring(0, 1)
                    ).toUpperCase();

        } else if (dentistName.length() >= 2) {

            dentistInitials =
                    dentistName
                            .substring(0, 2)
                            .toUpperCase();
        }
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        My Appointments | Sunrise Dental Clinic
    </title>


    <!-- Google Fonts -->

    <link
        rel="preconnect"
        href="https://fonts.googleapis.com"
    >

    <link
        rel="preconnect"
        href="https://fonts.gstatic.com"
        crossorigin
    >

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet"
    >


    <!-- Sunrise Dashboard CSS -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/reception.css"
    >


    <!-- Bootstrap Icons -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    >


    <style>

        /*
         * =====================================================
         * PAGE HEADER
         * =====================================================
         */

        .appointments-page-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            gap: 25px;

            margin-bottom: 24px;
        }


        .appointments-title-area h2 {

            margin: 0;

            color: #173b4d;

            font-size: 24px;

            font-weight: 700;
        }


        .appointments-title-area p {

            margin: 5px 0 0;

            color: #78909c;

            font-size: 13px;
        }


        /*
         * =====================================================
         * DATE SELECTOR
         * =====================================================
         */

        .date-selector {

            display: flex;

            align-items: center;

            gap: 10px;

            padding: 8px;

            background: #ffffff;

            border: 1px solid #e4edf1;

            border-radius: 13px;

            box-shadow:
                0 5px 18px rgba(
                    35,
                    82,
                    101,
                    0.06
                );
        }


        .date-selector-icon {

            width: 40px;

            height: 40px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 10px;

            background: #edfafd;

            color: #079eb5;

            font-size: 18px;

            flex-shrink: 0;
        }


        .date-selector input {

            border: none;

            outline: none;

            background: transparent;

            color: #294b5c;

            font-family: Poppins, sans-serif;

            font-size: 13px;

            font-weight: 500;

            cursor: pointer;
        }


        .today-button {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 6px;

            padding: 10px 14px;

            border-radius: 9px;

            border: none;

            background: #edfafd;

            color: #079eb5;

            font-family: Poppins, sans-serif;

            font-size: 12px;

            font-weight: 600;

            text-decoration: none;

            cursor: pointer;

            transition: 0.2s ease;
        }


        .today-button:hover {

            background: #079eb5;

            color: #ffffff;
        }


        /*
         * =====================================================
         * SELECTED DATE BANNER
         * =====================================================
         */

        .selected-date-banner {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            padding: 20px 24px;

            margin-bottom: 22px;

            border-radius: 15px;

            background:
                linear-gradient(
                    135deg,
                    rgba(14, 157, 179, 0.95),
                    rgba(55, 91, 105, 0.95)
                );

            color: #ffffff;

            box-shadow:
                0 10px 25px rgba(
                    20,
                    87,
                    103,
                    0.15
                );
        }


        .selected-date-content {

            display: flex;

            align-items: center;

            gap: 15px;
        }


        .selected-date-icon {

            width: 48px;

            height: 48px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 13px;

            background: rgba(
                255,
                255,
                255,
                0.15
            );

            font-size: 21px;
        }


        .selected-date-content h3 {

            margin: 0;

            font-size: 18px;

            font-weight: 600;
        }


        .selected-date-content p {

            margin: 3px 0 0;

            font-size: 12px;

            opacity: 0.8;
        }


        /*
         * =====================================================
         * STATISTICS
         * =====================================================
         */

        .appointment-statistics {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 18px;

            margin-bottom: 24px;
        }


        .appointment-stat-card {

            background: #ffffff;

            border-radius: 15px;

            padding: 19px;

            display: flex;

            align-items: center;

            gap: 14px;

            box-shadow:
                0 6px 20px rgba(
                    35,
                    82,
                    101,
                    0.06
                );

            border: 1px solid #edf2f4;
        }


        .appointment-stat-icon {

            width: 45px;

            height: 45px;

            border-radius: 12px;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 18px;

            flex-shrink: 0;
        }


        .all-icon {

            background: #eaf7fb;

            color: #079eb5;
        }


        .confirmed-icon {

            background: #e9f8ef;

            color: #16844a;
        }


        .pending-icon {

            background: #fff6df;

            color: #b87800;
        }


        .completed-icon {

            background: #eeeafd;

            color: #6849c6;
        }


        .appointment-stat-information span {

            display: block;

            color: #78909c;

            font-size: 11px;

            font-weight: 500;

            text-transform: uppercase;

            letter-spacing: 0.3px;
        }


        .appointment-stat-information strong {

            display: block;

            margin-top: 2px;

            color: #173b4d;

            font-size: 23px;

            font-weight: 700;
        }


        /*
         * =====================================================
         * TABLE SECTION
         * =====================================================
         */

        .appointments-section {

            background: #ffffff;

            border-radius: 16px;

            padding: 24px;

            box-shadow:
                0 6px 22px rgba(
                    35,
                    82,
                    101,
                    0.06
                );

            border: 1px solid #edf2f4;
        }


        .section-heading {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 18px;
        }


        .section-heading h3 {

            margin: 0;

            color: #173b4d;

            font-size: 17px;

            font-weight: 600;
        }


        .section-heading p {

            margin: 4px 0 0;

            color: #8aa0aa;

            font-size: 12px;
        }


        .table-container {

            width: 100%;

            overflow-x: auto;
        }


        .appointments-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 850px;
        }


        .appointments-table th {

            padding: 14px 14px;

            background: #f7fafb;

            color: #78909c;

            text-align: left;

            font-size: 10px;

            font-weight: 600;

            text-transform: uppercase;

            letter-spacing: 0.5px;

            border-bottom: 1px solid #e9eff2;
        }


        .appointments-table td {

            padding: 15px 14px;

            color: #45606e;

            font-size: 12px;

            border-bottom: 1px solid #eef2f4;

            vertical-align: middle;
        }


        .appointments-table tbody tr {

            transition: 0.2s ease;
        }


        .appointments-table tbody tr:hover {

            background: #fafdfe;
        }


        .patient-cell {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .patient-avatar {

            width: 38px;

            height: 38px;

            border-radius: 11px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #eaf8fb;

            color: #079eb5;

            font-size: 11px;

            font-weight: 700;

            flex-shrink: 0;
        }


        .patient-cell strong {

            display: block;

            color: #294b5c;

            font-size: 12px;

            font-weight: 600;
        }


        .patient-cell span {

            display: block;

            margin-top: 2px;

            color: #91a4ad;

            font-size: 10px;
        }


        .appointment-number {

            display: block;

            color: #294b5c;

            font-weight: 600;
        }


        .appointment-id {

            display: block;

            margin-top: 3px;

            color: #91a4ad;

            font-size: 10px;
        }


        /*
         * =====================================================
         * STATUS
         * =====================================================
         */

        .status {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            padding: 6px 10px;

            border-radius: 20px;

            font-size: 10px;

            font-weight: 600;

            text-transform: capitalize;
        }


        .status.confirmed {

            background: #e8f7ef;

            color: #16844a;
        }


        .status.pending {

            background: #fff6df;

            color: #b87800;
        }


        .status.completed {

            background: #eeeafd;

            color: #6849c6;
        }


        .status.rescheduled {

            background: #e9f2ff;

            color: #2671c9;
        }


        .status.cancelled {

            background: #fdecec;

            color: #d53a3a;
        }


        .status.in-progress {

            background: #f0eafd;

            color: #6849c6;
        }


        .status.unknown {

            background: #f1f3f4;

            color: #68777e;
        }


        /*
         * =====================================================
         * VIEW DETAILS
         * =====================================================
         */

        .appointment-action-link {

            width: 35px;

            height: 35px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border-radius: 9px;

            text-decoration: none;

            color: #079eb5;

            background: #edfafd;

            transition: all 0.2s ease;
        }


        .appointment-action-link:hover {

            background: #079eb5;

            color: #ffffff;

            transform: translateY(-1px);
        }


        /*
         * =====================================================
         * EMPTY STATE
         * =====================================================
         */

        .empty-appointments {

            text-align: center;

            padding: 65px 20px;

            color: #78909c;
        }


        .empty-appointments i {

            display: block;

            margin-bottom: 13px;

            font-size: 42px;

            color: #b5c8cf;
        }


        .empty-appointments strong {

            display: block;

            margin-bottom: 5px;

            color: #455a64;

            font-size: 14px;
        }


        .empty-appointments span {

            font-size: 12px;
        }


        /*
         * =====================================================
         * RESPONSIVE
         * =====================================================
         */

        @media (max-width: 1100px) {

            .appointment-statistics {

                grid-template-columns:
                    repeat(2, 1fr);
            }
        }


        @media (max-width: 768px) {

            .appointments-page-header {

                flex-direction: column;

                align-items: flex-start;
            }


            .date-selector {

                width: 100%;

                box-sizing: border-box;
            }


            .date-selector input {

                flex: 1;

                width: 100%;
            }


            .selected-date-banner {

                align-items: flex-start;

                flex-direction: column;
            }


            .appointment-statistics {

                grid-template-columns: 1fr;
            }


            .appointments-section {

                padding: 16px;
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

        <!-- BRAND -->

        <div class="sidebar-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
                alt="Sunrise Dental Clinic Logo"
            >

            <div class="brand-text">

                <h2>Sunrise</h2>

                <span>Dental Clinic</span>

            </div>

        </div>


        <!-- NAVIGATION -->

        <nav class="sidebar-navigation">

            <p class="navigation-title">
                MAIN
            </p>


            <!-- DASHBOARD -->

            <a
                href="${pageContext.request.contextPath}/dentist/dashboard"
                class="nav-item"
            >

                <i class="bi bi-grid-1x2-fill"></i>

                <span>Dashboard</span>

            </a>


            <!-- APPOINTMENTS -->

            <a
                href="${pageContext.request.contextPath}/dentist/appointments"
                class="nav-item active"
            >

                <i class="bi bi-calendar-check"></i>

                <span>My Appointments</span>

            </a>


            <!-- PATIENTS -->

            <div class="nav-group">

                <button
                    type="button"
                    class="nav-item nav-parent"
                    onclick="this.parentElement.classList.toggle('open')"
                >

                    <span class="nav-item-left">

                        <i class="bi bi-people"></i>

                        <span>My Patients</span>

                    </span>

                    <i class="bi bi-chevron-down nav-chevron"></i>

                </button>


                <div class="nav-submenu">

                    <a
                        href="${pageContext.request.contextPath}/dentist/patients"
                        class="nav-subitem"
                    >

                        <i class="bi bi-person-lines-fill"></i>

                        <span>Patient Records</span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/dentist/treatment-history"
                        class="nav-subitem"
                    >

                        <i class="bi bi-clock-history"></i>

                        <span>Treatment History</span>

                    </a>

                </div>

            </div>


            <!-- AVAILABILITY -->

            <a
                href="${pageContext.request.contextPath}/dentist/availability"
                class="nav-item"
            >

                <i class="bi bi-calendar2-week"></i>

                <span>My Availability</span>

            </a>


            <p class="navigation-title clinic-title">
                CLINIC
            </p>


            <!-- HELP DESK -->

            <a
                href="${pageContext.request.contextPath}/dentist/helpdesk.jsp"
                class="nav-item"
            >

                <i class="bi bi-question-circle"></i>

                <span>Help Desk</span>

            </a>

        </nav>


        <!-- ACCOUNT -->

        <div class="sidebar-bottom">

            <p class="navigation-title">
                ACCOUNT
            </p>


            <a
                href="${pageContext.request.contextPath}/dentist/profile"
                class="nav-item"
            >

                <i class="bi bi-person-circle"></i>

                <span>My Profile</span>

            </a>


            <a
                href="${pageContext.request.contextPath}/logout"
                class="nav-item logout-item"
            >

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </aside>


    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">


        <!-- TOP BAR -->

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

                    <h1>
                        My Appointments
                    </h1>

                    <p>
                        Clinical Schedule
                    </p>

                </div>

            </div>


            <div class="topbar-right">

                <!-- NOTIFICATION -->

                <button
                    type="button"
                    class="icon-button"
                    title="Notifications"
                >

                    <i class="bi bi-bell"></i>

                </button>


                <!-- USER -->

                <div class="user-profile">

                    <div class="user-avatar">

                        <i class="bi bi-person-fill"></i>

                    </div>


                    <div class="user-information">

                        <strong>
                            Dr. <%= dentistName %>
                        </strong>

                        <span>
                            Dentist
                        </span>

                    </div>


                    <i class="bi bi-chevron-down profile-arrow"></i>

                </div>

            </div>

        </header>


        <!-- =====================================================
             PAGE CONTENT
             ===================================================== -->

        <section class="dashboard-content">


            <!-- PAGE HEADER -->

            <div class="appointments-page-header">


                <div class="appointments-title-area">

                    <h2>
                        My Appointments
                    </h2>

                    <p>
                        View and manage your clinical schedule by date.
                    </p>

                </div>


                <!-- DATE PICKER -->

                <form
                    class="date-selector"
                    method="get"
                    action="${pageContext.request.contextPath}/dentist/appointments"
                    id="dateSelectorForm"
                >

                    <div class="date-selector-icon">

                        <i class="bi bi-calendar3"></i>

                    </div>


                    <input
                        type="date"
                        name="date"
                        id="appointmentDate"
                        value="<%= selectedLocalDate %>"
                        aria-label="Select appointment date"
                        required
                    >


                    <button
                        type="submit"
                        class="today-button"
                    >

                        <i class="bi bi-search"></i>

                        View

                    </button>

                </form>

            </div>


            <!-- SELECTED DATE -->

            <div class="selected-date-banner">


                <div class="selected-date-content">

                    <div class="selected-date-icon">

                        <i class="bi bi-calendar-check"></i>

                    </div>


                    <div>

                        <h3>
                            <%= displayDate %>
                        </h3>

                        <p>
                            Your appointments for the selected date
                        </p>

                    </div>

                </div>


                <!-- TODAY BUTTON -->

                <a
                    href="${pageContext.request.contextPath}/dentist/appointments"
                    class="today-button"
                >

                    <i class="bi bi-calendar-day"></i>

                    Today

                </a>

            </div>


            <!-- =================================================
                 STATISTICS
                 ================================================= -->

            <section class="appointment-statistics">


                <!-- TOTAL -->

                <div class="appointment-stat-card">

                    <div
                        class="appointment-stat-icon all-icon"
                    >

                        <i class="bi bi-calendar-check"></i>

                    </div>


                    <div
                        class="appointment-stat-information"
                    >

                        <span>
                            Appointments
                        </span>

                        <strong>
                            <%= appointmentCount %>
                        </strong>

                    </div>

                </div>


                <!-- CONFIRMED -->

                <div class="appointment-stat-card">

                    <div
                        class="appointment-stat-icon confirmed-icon"
                    >

                        <i class="bi bi-check-circle"></i>

                    </div>


                    <div
                        class="appointment-stat-information"
                    >

                        <span>
                            Confirmed
                        </span>

                        <strong>
                            <%= confirmedCount %>
                        </strong>

                    </div>

                </div>


                <!-- PENDING -->

                <div class="appointment-stat-card">

                    <div
                        class="appointment-stat-icon pending-icon"
                    >

                        <i class="bi bi-clock"></i>

                    </div>


                    <div
                        class="appointment-stat-information"
                    >

                        <span>
                            Pending
                        </span>

                        <strong>
                            <%= pendingCount %>
                        </strong>

                    </div>

                </div>


                <!-- COMPLETED -->

                <div class="appointment-stat-card">

                    <div
                        class="appointment-stat-icon completed-icon"
                    >

                        <i class="bi bi-check2-all"></i>

                    </div>


                    <div
                        class="appointment-stat-information"
                    >

                        <span>
                            Completed
                        </span>

                        <strong>
                            <%= completedCount %>
                        </strong>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 APPOINTMENTS TABLE
                 ================================================= -->

            <section class="appointments-section">


                <div class="section-heading">

                    <div>

                        <h3>
                            Appointments for <%= displayDate %>
                        </h3>

                        <p>
                            Only appointments assigned to you are displayed.
                        </p>

                    </div>

                </div>


                <div class="table-container">


                    <table class="appointments-table">


                        <thead>

                        <tr>

                            <th>
                                Time
                            </th>

                            <th>
                                Patient
                            </th>

                            <th>
                                Appointment
                            </th>

                            <th>
                                Treatment / Reason
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Action
                            </th>

                        </tr>

                        </thead>


                        <tbody>


                        <% if (appointments.isEmpty()) { %>

                            <tr>

                                <td
                                    colspan="6"
                                    class="empty-appointments"
                                >

                                    <i class="bi bi-calendar-x"></i>

                                    <strong>
                                        No appointments scheduled.
                                    </strong>

                                    <span>
                                        You have no appointments for
                                        <%= displayDate %>.
                                    </span>

                                </td>

                            </tr>


                        <% } else { %>


                            <%

                                for (Appointment appointment :
                                        appointments) {

                                    Patient patient =
                                            patients.get(
                                                    appointment.getPatientId()
                                            );


                                    String patientName =
                                            patient != null
                                            && patient.getName() != null
                                            && !patient.getName().isBlank()

                                                    ? patient.getName()

                                                    : "Unknown Patient";


                                    String patientNumber =
                                            patient != null
                                            && patient.getPatientNumber() != null

                                                    ? patient.getPatientNumber()

                                                    : "-";


                                    String reason =
                                            appointment.getReason() != null
                                            && !appointment.getReason().isBlank()

                                                    ? appointment.getReason()

                                                    : "Appointment";


                                    String status =
                                            appointment.getStatus() != null

                                                    ? appointment.getStatus()

                                                    : "UNKNOWN";


                                    String statusClass =
                                            status
                                                    .trim()
                                                    .toLowerCase()
                                                    .replace(" ", "-");


                                    String initials = "P";


                                    if (patientName.length() >= 2) {

                                        String[] nameParts =
                                                patientName
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
                                                    patientName
                                                            .substring(0, 2)
                                                            .toUpperCase();
                                        }
                                    }


                                    String appointmentTime = "-";


                                    if (appointment.getStartTime()
                                            != null) {

                                        appointmentTime =
                                                timeFormat.format(
                                                        appointment.getStartTime()
                                                );
                                    }

                            %>


                            <tr>


                                <!-- TIME -->

                                <td>

                                    <strong>
                                        <%= appointmentTime %>
                                    </strong>

                                </td>


                                <!-- PATIENT -->

                                <td>

                                    <div class="patient-cell">


                                        <div class="patient-avatar">

                                            <%= initials %>

                                        </div>


                                        <div>

                                            <strong>
                                                <%= patientName %>
                                            </strong>

                                            <span>
                                                <%= patientNumber %>
                                            </span>

                                        </div>

                                    </div>

                                </td>


                                <!-- APPOINTMENT -->

                                <td>

                                    <span
                                        class="appointment-number"
                                    >

                                        <%= appointment
                                                .getAppointmentNumber()
                                                != null

                                                ? appointment
                                                    .getAppointmentNumber()

                                                : "-" %>

                                    </span>


                                    <span
                                        class="appointment-id"
                                    >

                                        Appointment ID:

                                        <%= appointment
                                                .getAppointmentId() %>

                                    </span>

                                </td>


                                <!-- REASON -->

                                <td>

                                    <%= reason %>

                                </td>


                                <!-- STATUS -->

                                <td>

                                    <span
                                        class="status <%= statusClass %>"
                                    >

                                        <%= status %>

                                    </span>

                                </td>


                                <!-- ACTION -->

                                <td>

                                    <a
                                        class="appointment-action-link"
                                        title="View appointment details"
                                        href="${pageContext.request.contextPath}/dentist/appointment-details?appointmentId=<%= appointment.getAppointmentId() %>"
                                    >

                                        <i
                                            class="bi bi-arrow-right"
                                        ></i>

                                    </a>

                                </td>


                            </tr>


                            <%

                                }

                            %>


                        <% } %>


                        </tbody>

                    </table>

                </div>

            </section>


        </section>

    </main>

</div>


<script>

    /*
     * =========================================================
     * MOBILE SIDEBAR
     * =========================================================
     */

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


    /*
     * =========================================================
     * DATE VALIDATION
     *
     * The browser submits exactly the selected date.
     * No JavaScript date conversion is performed here.
     * =========================================================
     */

    const dateInput =
        document.getElementById("appointmentDate");

    const dateForm =
        document.getElementById("dateSelectorForm");


    if (dateInput && dateForm) {

        dateForm.addEventListener(
            "submit",
            function (event) {

                if (!dateInput.value) {

                    event.preventDefault();

                    dateInput.focus();

                    return;
                }

            }
        );
    }

</script>


</body>

</html>