<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%

    /*
     * =========================================================
     * SESSION INFORMATION
     * =========================================================
     */

    String staffName =
            (String) session.getAttribute("staffName");

    String role =
            (String) session.getAttribute("role");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }

    if (role == null || role.isBlank()) {
        role = "RECEPTION";
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

    Map<Integer, Dentist> dentists =
            (Map<Integer, Dentist>) request.getAttribute(
                    "dentists"
            );


    if (todayAppointments == null) {
        todayAppointments = java.util.Collections.emptyList();
    }

    if (patients == null) {
        patients = java.util.Collections.emptyMap();
    }

    if (dentists == null) {
        dentists = java.util.Collections.emptyMap();
    }


    Integer todayAppointmentCount =
            (Integer) request.getAttribute(
                    "todayAppointmentCount"
            );

    Integer confirmedAppointmentCount =
            (Integer) request.getAttribute(
                    "confirmedAppointmentCount"
            );

    Integer availableSlotCount =
            (Integer) request.getAttribute(
                    "availableSlotCount"
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

    if (availableSlotCount == null) {
        availableSlotCount = 0;
    }

    if (totalPatientCount == null) {
        totalPatientCount = 0;
    }

%>

<%!
    private String formatTime(java.sql.Time time) {

        if (time == null) {
            return "-";
        }

        java.time.LocalTime localTime = time.toLocalTime();

        int hour = localTime.getHour();
        int minute = localTime.getMinute();

        String suffix = hour >= 12 ? "PM" : "AM";

        int displayHour = hour % 12;

        if (displayHour == 0) {
            displayHour = 12;
        }

        return String.format(
            "%02d:%02d %s",
            displayHour,
            minute,
            suffix
        );
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Receptionist Dashboard | Sunrise Dental Clinic
    </title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/reception.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>


<body>


<div class="dashboard-container">


    <!-- ================================================= -->
    <!-- SIDEBAR -->
    <!-- ================================================= -->

    <!--
         SIDEBAR IS LEFT UNCHANGED
         KEEP YOUR EXISTING SIDEBAR HERE
    -->

    <aside class="sidebar" id="sidebar">

        <div class="sidebar-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
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
                href="${pageContext.request.contextPath}/reception/dashboard"
                class="nav-item active">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>Dashboard</span>

            </a>


            <a
                href="${pageContext.request.contextPath}/reception/schedule"
                class="nav-item">

                <i class="bi bi-calendar3"></i>

                <span>Schedule</span>

            </a>


            <div class="nav-dropdown">

                <button
                    type="button"
                    class="nav-item nav-dropdown-toggle"
                    onclick="this.parentElement.classList.toggle('open')">

                    <span class="nav-item-left">

                        <i class="bi bi-calendar-check"></i>

                        <span>Appointments</span>

                    </span>

                    <i class="bi bi-chevron-down dropdown-arrow"></i>

                </button>


                <div
                    class="nav-submenu"
                    id="appointmentsSubmenu">

                    <a
                        href="${pageContext.request.contextPath}/reception/book-appointment"
                        class="nav-subitem">

                        <i class="bi bi-calendar-plus"></i>

                        <span>Book Appointment</span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/view-appointments"
                        class="nav-subitem">

                        <i class="bi bi-calendar3"></i>

                        <span>View Appointments</span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/view-appointments"
                        class="nav-subitem">

                        <i class="bi bi-calendar2-week"></i>

                        <span>Reschedule Appointment</span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/view-appointments"
                        class="nav-subitem">

                        <i class="bi bi-calendar-x"></i>

                        <span>Cancel Appointment</span>

                    </a>

                </div>

            </div>


            <div class="nav-group">

                <button
                    type="button"
                    class="nav-item nav-parent"
                    onclick="this.parentElement.classList.toggle('open')">

                    <span class="nav-item-left">

                        <i class="bi bi-people"></i>

                        <span>Patients</span>

                    </span>

                    <i class="bi bi-chevron-down nav-chevron"></i>

                </button>


                <div
                    class="nav-submenu"
                    id="patientsSubmenu">

                    <a
                        href="${pageContext.request.contextPath}/reception/register-patient"
                        class="nav-subitem">

                        <i class="bi bi-person-plus"></i>

                        <span>Register New Patient</span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/manage-patients"
                        class="nav-subitem">

                        <i class="bi bi-person-lines-fill"></i>

                        <span>Manage Patients</span>

                    </a>

                </div>

            </div>


            <p class="navigation-title clinic-title">
                CLINIC
            </p>


            <div class="nav-group">

                <button
                    type="button"
                    class="nav-item nav-toggle"
                    onclick="this.parentElement.classList.toggle('open')">

                    <span class="nav-item-left">

                        <i class="bi bi-person-badge"></i>

                        <span>Dentists</span>

                    </span>

                    <i class="bi bi-chevron-down nav-arrow"></i>

                </button>


                <div
                    class="nav-submenu"
                    id="dentistMenu">

                    <a
                        href="${pageContext.request.contextPath}/reception/dentists"
                        class="nav-subitem">

                        <i class="bi bi-people"></i>

                        <span>View Dentists</span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/dentist-availability"
                        class="nav-subitem">

                        <i class="bi bi-calendar2-week"></i>

                        <span>Check Availability</span>

                    </a>

                </div>

            </div>


            <a
                href="${pageContext.request.contextPath}/reception/helpdesk.jsp"
                class="nav-item">

                <i class="bi bi-question-circle"></i>

                <span>Help Desk</span>

            </a>

        </nav>


        <div class="sidebar-bottom">

            <p class="navigation-title">
                ACCOUNT
            </p>


            <a
                href="${pageContext.request.contextPath}/reception/profile"
                class="nav-item">

                <i class="bi bi-person-circle"></i>

                <span>My Profile</span>

            </a>


            <a
                href="${pageContext.request.contextPath}/logout"
                class="nav-item logout-item">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </aside>



    <!-- ================================================= -->
    <!-- MAIN CONTENT -->
    <!-- ================================================= -->

    <main class="main-content">


        <!-- TOP BAR -->

        <header class="topbar">

            <div class="topbar-left">

                <button
                    type="button"
                    class="menu-button"
                    id="menuButton">

                    <i class="bi bi-list"></i>

                </button>


                <div>

                    <h1>
                        Dashboard
                    </h1>

                    <p>
                        Reception Management
                    </p>

                </div>

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
                            Receptionist
                        </span>

                    </div>


                    <i class="bi bi-chevron-down profile-arrow"></i>

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

                <div>

                    <h2 id="welcomeMessage">
                        Welcome, <%= staffName %>
                    </h2>

                    <p>
                        Here's what's happening at
                        Sunrise Dental Clinic today.
                    </p>

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


                <!-- Today's Appointments -->

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
                            Scheduled today
                        </small>

                    </div>

                </div>



                <!-- Confirmed -->

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



                <!-- Available Slots -->

                <div class="stat-card">

                    <div class="stat-icon availability-icon">

                        <i class="bi bi-clock"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Available Slots
                        </span>

                        <strong>
                            <%= availableSlotCount %>
                        </strong>

                        <small>
                            Remaining slots today
                        </small>

                    </div>

                </div>



                <!-- Total Patients -->

                <div class="stat-card">

                    <div class="stat-icon patient-icon">

                        <i class="bi bi-people"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Total Patients
                        </span>

                        <strong>
                            <%= totalPatientCount %>
                        </strong>

                        <small>
                            Active registered patients
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
                            Common receptionist tasks
                        </p>

                    </div>

                </div>


                <div class="quick-actions-grid">


                    <a
                        href="${pageContext.request.contextPath}/reception/register-patient"
                        class="quick-action-card">

                        <div class="quick-action-icon">

                            <i class="bi bi-person-plus"></i>

                        </div>


                        <div>

                            <strong>
                                Register New Patient
                            </strong>

                            <span>
                                Add a new patient
                            </span>

                        </div>


                        <i class="bi bi-arrow-right"></i>

                    </a>



                    <a
                        href="${pageContext.request.contextPath}/reception/book-appointment"
                        class="quick-action-card">

                        <div class="quick-action-icon">

                            <i class="bi bi-calendar-plus"></i>

                        </div>


                        <div>

                            <strong>
                                Book Appointment
                            </strong>

                            <span>
                                Schedule an appointment
                            </span>

                        </div>


                        <i class="bi bi-arrow-right"></i>

                    </a>



                    <a
                        href="${pageContext.request.contextPath}/reception/manage-patients"
                        class="quick-action-card">

                        <div class="quick-action-icon">

                            <i class="bi bi-people"></i>

                        </div>


                        <div>

                            <strong>
                                Manage Patients
                            </strong>

                            <span>
                                Search and update patient records
                            </span>

                        </div>


                        <i class="bi bi-arrow-right"></i>

                    </a>

                </div>

            </section>



            <!-- ================================================= -->
            <!-- TODAY'S APPOINTMENTS -->
            <!-- ================================================= -->

            <section class="appointments-section">


                <div class="section-heading">

                    <div>

                        <h3>
                            Today's Appointments
                        </h3>

                        <p>
                            Overview of today's scheduled appointments
                        </p>

                    </div>


                    <a
                        href="${pageContext.request.contextPath}/reception/view-appointments"
                        class="view-all-link">

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
                                Dentist
                            </th>

                            <th>
                                Treatment
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
                                    style="text-align:center; padding:35px;">

                                    <div>

                                        <i
                                            class="bi bi-calendar-x"
                                            style="font-size:28px; display:block; margin-bottom:8px;">
                                        </i>

                                        <strong>
                                            No appointments scheduled for today.
                                        </strong>

                                        <div style="margin-top:5px;">

                                            Your schedule is currently clear.

                                        </div>

                                    </div>

                                </td>

                            </tr>


                        <% } else { %>


                            <% for (Appointment appointment
                                    : todayAppointments) {


                                Patient patient =
                                        patients.get(
                                                appointment.getPatientId()
                                        );


                                Dentist dentist =
                                        dentists.get(
                                                appointment.getDentistId()
                                        );


                                String patientName =
                                        patient != null
                                                && patient.getName() != null
                                                ? patient.getName()
                                                : "Unknown Patient";


                                String patientNumber =
                                        patient != null
                                                && patient.getPatientNumber() != null
                                                ? patient.getPatientNumber()
                                                : "-";


                                String dentistName =
                                        dentist != null
                                                && dentist.getName() != null
                                                ? dentist.getName()
                                                : "Unknown Dentist";


                                String reason =
                                        appointment.getReason() != null
                                                && !appointment.getReason().isBlank()
                                                ? appointment.getReason()
                                                : "Appointment";


                                String status =
                                        appointment.getStatus() != null
                                                ? appointment.getStatus()
                                                : "UNKNOWN";


                                String initials = "P";


                                if (patientName.length() >= 2) {

                                    String[] nameParts =
                                            patientName.trim().split("\\s+");

                                    if (nameParts.length >= 2) {

                                        initials =
                                                (
                                                    nameParts[0].substring(0, 1)
                                                    +
                                                    nameParts[nameParts.length - 1]
                                                            .substring(0, 1)
                                                ).toUpperCase();

                                    } else {

                                        initials =
                                                patientName
                                                        .substring(0, 2)
                                                        .toUpperCase();
                                    }
                                }


                                String statusClass =
                                        status.toLowerCase();

                            %>


                            <tr>


                                <!-- TIME -->

                                <td>

                                    <strong>
                                        <%= formatTime(appointment.getStartTime()) %>
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



                                <!-- DENTIST -->

                                <td>

                                    Dr.
                                    <%= dentistName %>

                                </td>



                                <!-- TREATMENT -->

                                <td>

                                    <%= reason %>

                                </td>



                                <!-- STATUS -->

                                <td>

                                    <span
                                        class="status <%= statusClass %>">

                                        <%= status %>

                                    </span>

                                </td>



                                <!-- ACTION -->

                                <td>

                                    <a
                                        class="table-action"
                                        title="View appointment"
                                        href="${pageContext.request.contextPath}/reception/view-appointment?appointmentId=<%= appointment.getAppointmentId() %>">

                                        <i class="bi bi-three-dots"></i>

                                    </a>

                                </td>


                            </tr>


                            <% } %>


                        <% } %>


                        </tbody>

                    </table>

                </div>

            </section>


        </section>

    </main>

</div>



<!-- ================================================= -->
<!-- DASHBOARD JAVASCRIPT -->
<!-- ================================================= -->

<script>


    /*
     * =========================================================
     * CURRENT DATE
     * =========================================================
     */

    const currentDateElement =
        document.getElementById("currentDate");


    const welcomeMessage =
        document.getElementById("welcomeMessage");


    const today =
        new Date();


    const dateOptions = {

        weekday: "long",

        year: "numeric",

        month: "long",

        day: "numeric"

    };


    currentDateElement.textContent =
        today.toLocaleDateString(
            "en-US",
            dateOptions
        );



    /*
     * =========================================================
     * GREETING
     * =========================================================
     */

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


    welcomeMessage.textContent =
        greeting + ", <%= staffName %>";



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