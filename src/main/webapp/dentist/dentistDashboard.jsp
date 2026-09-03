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
     * SESSION INFORMATION
     * =========================================================
     */

    String staffName = (String) session.getAttribute("staffName");
    String role = (String) session.getAttribute("role");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }

    if (role == null || role.isBlank()) {
        role = "DENTIST";
    }


    /*
     * =========================================================
     * DENTIST INFORMATION
     * =========================================================
     */

    Dentist loggedInDentist =
            (Dentist) request.getAttribute("loggedInDentist");

    String dentistName = staffName;

    if (loggedInDentist != null
            && loggedInDentist.getName() != null
            && !loggedInDentist.getName().isBlank()) {

        dentistName = loggedInDentist.getName();
    }


    /*
     * =========================================================
     * DASHBOARD DATA
     * =========================================================
     */

    List<Appointment> todayAppointments =
            (List<Appointment>) request.getAttribute(
                    "todayAppointments"
            );

    Map<Integer, Patient> patients =
            (Map<Integer, Patient>) request.getAttribute(
                    "patients"
            );


    if (todayAppointments == null) {
        todayAppointments = java.util.Collections.emptyList();
    }

    if (patients == null) {
        patients = java.util.Collections.emptyMap();
    }


    /*
     * =========================================================
     * STATISTICS
     * =========================================================
     */

    Integer todayAppointmentCount =
            (Integer) request.getAttribute(
                    "todayAppointmentCount"
            );

    Integer confirmedAppointmentCount =
            (Integer) request.getAttribute(
                    "confirmedAppointmentCount"
            );

    Integer completedAppointmentCount =
            (Integer) request.getAttribute(
                    "completedAppointmentCount"
            );

    Integer totalPatientCount =
            (Integer) request.getAttribute(
                    "totalPatientCount"
            );


    if (todayAppointmentCount == null) {
        todayAppointmentCount = 0;
    }

    if (confirmedAppointmentCount == null) {
        confirmedAppointmentCount = 0;
    }

    if (completedAppointmentCount == null) {
        completedAppointmentCount = 0;
    }

    if (totalPatientCount == null) {
        totalPatientCount = 0;
    }


    /*
     * =========================================================
     * DATE / TIME FORMATTERS
     * =========================================================
     */

    SimpleDateFormat timeFormat =
            new SimpleDateFormat("hh:mm a");

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd MMM yyyy");


    /*
     * =========================================================
     * HELPER VALUES
     * =========================================================
     */

    String dentistInitials = "DR";

    if (dentistName != null && !dentistName.isBlank()) {

        String[] nameParts =
                dentistName.trim().split("\\s+");

        if (nameParts.length >= 2) {

            dentistInitials =
                    (
                        nameParts[0].substring(0, 1)
                        +
                        nameParts[nameParts.length - 1]
                                .substring(0, 1)
                    ).toUpperCase();

        } else if (dentistName.length() >= 2) {

            dentistInitials =
                    dentistName.substring(0, 2).toUpperCase();
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
        Dentist Dashboard | Sunrise Dental Clinic
    </title>


    <!-- Google Fonts -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">


    <!-- Existing Sunrise Dashboard CSS -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/reception.css">


    <!-- Bootstrap Icons -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <style>

        /*
         * =====================================================
         * DENTIST DASHBOARD ADDITIONAL STYLES
         * =====================================================
         */

        .dentist-profile-card {
            display: flex;
            align-items: center;
            gap: 18px;
        }


        .dentist-avatar-large {
            width: 62px;
            height: 62px;
            border-radius: 18px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: rgba(255, 255, 255, 0.18);

            border: 1px solid rgba(255, 255, 255, 0.25);

            color: #ffffff;

            font-size: 20px;
            font-weight: 700;
        }


        .dentist-welcome-name {
            margin: 0;
        }


        .dentist-specialization {
            display: block;

            margin-top: 4px;

            font-size: 13px;

            opacity: 0.85;
        }


        .quick-action-card {
            text-decoration: none;
        }


        .appointment-number {
            display: block;

            margin-top: 3px;

            font-size: 11px;

            color: #78909c;
        }


        .status.completed {
            background: #e8f7ef;
            color: #16844a;
        }


        .status.pending {
            background: #fff6df;
            color: #b87800;
        }


        .status.confirmed {
            background: #e7f7ed;
            color: #14834a;
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
            background: #eeeafd;
            color: #6849c6;
        }


        .empty-appointments {
            text-align: center;

            padding: 50px 20px;

            color: #78909c;
        }


        .empty-appointments i {
            display: block;

            font-size: 38px;

            margin-bottom: 12px;
        }


        .empty-appointments strong {
            display: block;

            color: #455a64;

            margin-bottom: 5px;
        }


        .appointment-action-link {
            width: 34px;
            height: 34px;

            display: inline-flex;

            align-items: center;
            justify-content: center;

            border-radius: 9px;

            text-decoration: none;

            color: #159bb1;

            background: #edfafd;

            transition: all 0.2s ease;
        }


        .appointment-action-link:hover {
            background: #159bb1;

            color: #ffffff;

            transform: translateY(-1px);
        }


        .dentist-section-note {
            margin-top: 3px;

            color: #78909c;

            font-size: 13px;
        }


        @media (max-width: 768px) {

            .dentist-profile-card {
                gap: 12px;
            }

            .dentist-avatar-large {
                width: 52px;
                height: 52px;
            }

        }

    </style>

</head>


<body>


<div class="dashboard-container">


    <!-- ===================================================== -->
    <!-- SIDEBAR -->
    <!-- ===================================================== -->

    <aside class="sidebar" id="sidebar">


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
                class="nav-item active"
            >

                <i class="bi bi-grid-1x2-fill"></i>

                <span>Dashboard</span>

            </a>


            <!-- DAILY APPOINTMENTS -->

            <a
                href="${pageContext.request.contextPath}/dentist/appointments"
                class="nav-item"
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


                <div
                    class="nav-submenu"
                    id="patientsSubmenu"
                >

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



    <!-- ===================================================== -->
    <!-- MAIN CONTENT -->
    <!-- ===================================================== -->

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
                        Dashboard
                    </h1>

                    <p>
                        Dentist Management
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

                    <span class="notification-dot"></span>

                </button>


                <!-- USER -->

                <div class="user-profile">


                    <div class="user-avatar">

                        <i class="bi bi-person-fill"></i>

                    </div>


                    <div class="user-information">

                        <strong>
                             <%= dentistName %>
                        </strong>

                        <span>
                            Dentist
                        </span>

                    </div>


                    <i
                        class="bi bi-chevron-down profile-arrow"
                    ></i>

                </div>

            </div>

        </header>



        <!-- ================================================= -->
        <!-- PAGE CONTENT -->
        <!-- ================================================= -->

        <section class="dashboard-content">


            <!-- ================================================= -->
            <!-- WELCOME -->
            <!-- ================================================= -->

            <div class="welcome-section">


                <div class="dentist-profile-card">


                    <div class="dentist-avatar-large">

                        <%= dentistInitials %>

                    </div>


                    <div>

                        <h2
                            class="dentist-welcome-name"
                            id="welcomeMessage"
                        >
                            Welcome,  <%= dentistName %>
                        </h2>

                        <p class="dentist-section-note">
                            Here's your clinical schedule and patient activity for today.
                        </p>

                    </div>

                </div>


                <div class="current-date">

                    <i class="bi bi-calendar3"></i>

                    <span id="currentDate"></span>

                </div>

            </div>



            <!-- ================================================= -->
            <!-- STATISTICS -->
            <!-- ================================================= -->

            <section class="statistics-grid">


                <!-- TODAY'S APPOINTMENTS -->

                <div class="stat-card">

                    <div class="stat-icon appointment-icon">

                        <i class="bi bi-calendar-check"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Today's Appointments
                        </span>

                        <strong>
                            <%= todayAppointmentCount %>
                        </strong>

                        <small>
                            Your scheduled appointments
                        </small>

                    </div>

                </div>



                <!-- CONFIRMED -->

                <div class="stat-card">

                    <div class="stat-icon confirmed-icon">

                        <i class="bi bi-check-circle"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Confirmed
                        </span>

                        <strong>
                            <%= confirmedAppointmentCount %>
                        </strong>

                        <small>
                            Confirmed appointments today
                        </small>

                    </div>

                </div>



                <!-- COMPLETED -->

                <div class="stat-card">

                    <div class="stat-icon availability-icon">

                        <i class="bi bi-check2-all"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Completed Today
                        </span>

                        <strong>
                            <%= completedAppointmentCount %>
                        </strong>

                        <small>
                            Appointments completed
                        </small>

                    </div>

                </div>



                <!-- MY PATIENTS -->

                <div class="stat-card">

                    <div class="stat-icon patient-icon">

                        <i class="bi bi-people"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            My Patients
                        </span>

                        <strong>
                            <%= totalPatientCount %>
                        </strong>

                        <small>
                            Patients you have treated
                        </small>

                    </div>

                </div>

            </section>



            <!-- ================================================= -->
            <!-- QUICK ACTIONS -->
            <!-- ================================================= -->

            <section class="quick-actions-section">


                <div class="section-heading">

                    <div>

                        <h3>
                            Quick Actions
                        </h3>

                        <p>
                            Common clinical tasks
                        </p>

                    </div>

                </div>



                <div class="quick-actions-grid">


                    <!-- DAILY APPOINTMENTS -->

                    <a
                        href="${pageContext.request.contextPath}/dentist/appointments"
                        class="quick-action-card"
                    >

                        <div class="quick-action-icon">

                            <i class="bi bi-calendar-check"></i>

                        </div>


                        <div>

                            <strong>
                                Daily Appointments
                            </strong>

                            <span>
                                View today's patient schedule
                            </span>

                        </div>


                        <i class="bi bi-arrow-right"></i>

                    </a>



                    <!-- PATIENT RECORDS -->

                    <a
                        href="${pageContext.request.contextPath}/dentist/patients"
                        class="quick-action-card"
                    >

                        <div class="quick-action-icon">

                            <i class="bi bi-person-lines-fill"></i>

                        </div>


                        <div>

                            <strong>
                                My Patients
                            </strong>

                            <span>
                                View patients you have treated
                            </span>

                        </div>


                        <i class="bi bi-arrow-right"></i>

                    </a>



                    <!-- TREATMENT HISTORY -->

                    <a
                        href="${pageContext.request.contextPath}/dentist/treatment-history"
                        class="quick-action-card"
                    >

                        <div class="quick-action-icon">

                            <i class="bi bi-journal-medical"></i>

                        </div>


                        <div>

                            <strong>
                                Treatment History
                            </strong>

                            <span>
                                Review treatment records and notes
                            </span>

                        </div>


                        <i class="bi bi-arrow-right"></i>

                    </a>

                </div>

            </section>



            <!-- ================================================= -->
            <!-- DAILY APPOINTMENTS -->
            <!-- ================================================= -->

            <section class="appointments-section">


                <div class="section-heading">


                    <div>

                        <h3>
                            Today's Appointments
                        </h3>

                        <p>
                            Your scheduled patient appointments for today
                        </p>

                    </div>


                    <a
                        href="${pageContext.request.contextPath}/dentist/appointments"
                        class="view-all-link"
                    >

                        View All

                        <i class="bi bi-arrow-right"></i>

                    </a>

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


                        <% if (todayAppointments.isEmpty()) { %>


                            <tr>

                                <td
                                    colspan="6"
                                    class="empty-appointments"
                                >

                                    <i class="bi bi-calendar-x"></i>

                                    <strong>
                                        No appointments scheduled for today.
                                    </strong>

                                    <span>
                                        Your clinical schedule is currently clear.
                                    </span>

                                </td>

                            </tr>


                        <% } else { %>


                            <%
                                for (Appointment appointment :
                                        todayAppointments) {


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

                                    if (appointment.getStartTime() != null) {

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

                                            <% if (patient != null && patient.getDateOfBirth() != null) { %>
                                                <small style="color: #64748b; font-size: 11px; display: block; margin-top: 2px;">
                                                    <i class="bi bi-calendar2-date" style="color: #0ea5b4;"></i> DOB: <%= patient.getDateOfBirth() %>
                                                </small>
                                            <% } %>

                                        </div>

                                    </div>

                                </td>



                                <!-- APPOINTMENT -->

                                <td>

                                    <strong>
                                        <%= appointment.getAppointmentNumber() != null
                                                ? appointment.getAppointmentNumber()
                                                : "-" %>
                                    </strong>

                                    <span class="appointment-number">
                                        Appointment ID:
                                        <%= appointment.getAppointmentId() %>
                                    </span>

                                </td>



                                <!-- TREATMENT -->

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

                                        <i class="bi bi-three-dots"></i>

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



<!-- ========================================================= -->
<!-- DASHBOARD JAVASCRIPT -->
<!-- ========================================================= -->

<script>


    /*
     * =========================================================
     * CURRENT DATE
     * =========================================================
     */

    const currentDateElement =
        document.getElementById("currentDate");


    const today =
        new Date();


    const dateOptions = {

        weekday: "long",

        year: "numeric",

        month: "long",

        day: "numeric"

    };


    if (currentDateElement) {

        currentDateElement.textContent =
            today.toLocaleDateString(
                "en-US",
                dateOptions
            );
    }



    /*
     * =========================================================
     * GREETING
     * =========================================================
     */

    const welcomeMessage =
        document.getElementById("welcomeMessage");


    const hour =
        today.getHours();


    let greeting;


    if (hour < 12) {

        greeting = "Good Morning";

    } else if (hour < 17) {

        greeting = "Good Afternoon";

    } else {

        greeting = "Good Evening";
    }


    if (welcomeMessage) {

        welcomeMessage.textContent =
            greeting + ", <%= dentistName %>";
    }



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

</script>

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>

</body>

</html>