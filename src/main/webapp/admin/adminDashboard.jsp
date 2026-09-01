<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.sunrise.dental.model.Appointment"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.LocalDate"%>

<%
    String contextPath = request.getContextPath();

    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }

    Integer totalPatients = (Integer) request.getAttribute("totalPatients");
    Integer activeDentists = (Integer) request.getAttribute("activeDentists");
    Integer totalStaff = (Integer) request.getAttribute("totalStaff");
    Integer activeStaff = (Integer) request.getAttribute("activeStaff");

    Integer todayConfirmed = (Integer) request.getAttribute("todayConfirmed");
    Integer todayCompleted = (Integer) request.getAttribute("todayCompleted");
    Integer todayPending = (Integer) request.getAttribute("todayPending");

    if (totalPatients == null) totalPatients = 0;
    if (activeDentists == null) activeDentists = 0;
    if (totalStaff == null) totalStaff = 0;
    if (activeStaff == null) activeStaff = 0;
    if (todayConfirmed == null) todayConfirmed = 0;
    if (todayCompleted == null) todayCompleted = 0;
    if (todayPending == null) todayPending = 0;

    List<Appointment> todayAppointments = (List<Appointment>) request.getAttribute("todayAppointments");
    Map<Integer, String> patientNames = (Map<Integer, String>) request.getAttribute("patientNames");
    Map<Integer, String> dentistNames = (Map<Integer, String>) request.getAttribute("dentistNames");

    Date today = (Date) request.getAttribute("today");
    if (today == null) {
        today = Date.valueOf(LocalDate.now());
    }

    String greeting;
    int currentHour = java.time.LocalTime.now().getHour();
    if (currentHour < 12) {
        greeting = "Good Morning";
    } else if (currentHour < 17) {
        greeting = "Good Afternoon";
    } else {
        greeting = "Good Evening";
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
    <title>Admin Dashboard | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .admin-profile-card {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .admin-avatar-large {
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

        .admin-welcome-name {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .admin-section-note {
            margin-top: 4px;
            color: #d6f0f5;
            font-size: 13.5px;
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

            <a href="<%= contextPath %>/admin/dashboard" class="nav-item active">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/staff" class="nav-item">
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
                <h1>Admin Dashboard</h1>
                <p>Clinic administration overview</p>
            </div>

            <div class="topbar-right">
                <button type="button" class="icon-button" title="Notifications">
                    <i class="bi bi-bell"></i>
                    <span class="notification-dot"></span>
                </button>

                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Administrator</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- DASHBOARD BODY -->
        <section class="dashboard-content">

            <!-- WELCOME BANNER -->
            <div class="welcome-section">
                <div class="admin-profile-card">
                    <div class="admin-avatar-large">
                        <%= adminInitials %>
                    </div>
                    <div>
                        <h2 class="admin-welcome-name">
                            <%= greeting %>, <%= staffName %>!
                        </h2>
                        <p class="admin-section-note">
                            Here's the clinic administration overview and daily activities for today.
                        </p>
                    </div>
                </div>

                <div class="current-date">
                    <i class="bi bi-calendar3"></i>
                    <span><%= today.toLocalDate().format(DateTimeFormatter.ofPattern("dd MMMM yyyy")) %></span>
                </div>
            </div>

            <!-- CORE METRICS (4 CARDS) -->
            <section class="statistics-grid">

                <div class="stat-card">
                    <div class="stat-icon patient-icon">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div class="stat-information">
                        <span>Total Patients</span>
                        <strong><%= totalPatients %></strong>
                        <small>Registered in clinic</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon appointment-icon">
                        <i class="bi bi-hospital"></i>
                    </div>
                    <div class="stat-information">
                        <span>Active Dentists</span>
                        <strong><%= activeDentists %></strong>
                        <small>Clinical specialists</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon confirmed-icon">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <div class="stat-information">
                        <span>Active Staff</span>
                        <strong><%= activeStaff %></strong>
                        <small><%= totalStaff %> total accounts</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon availability-icon">
                        <i class="bi bi-calendar-check"></i>
                    </div>
                    <div class="stat-information">
                        <span>Today's Appointments</span>
                        <strong><%= todayAppointments != null ? todayAppointments.size() : 0 %></strong>
                        <small>Booked for today</small>
                    </div>
                </div>

            </section>

            <!-- QUICK ACTIONS SECTION -->
            <section class="quick-actions-section">
                <div class="section-heading">
                    <div>
                        <h3>Quick Actions</h3>
                        <p>Frequently accessed clinic management functions</p>
                    </div>
                </div>

                <div class="quick-actions-grid">
                    <a href="<%= contextPath %>/admin/staff" class="quick-action-card">
                        <div class="quick-action-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div>
                            <strong>Manage Staff</strong>
                            <span>Add and manage clinic personnel</span>
                        </div>
                        <i class="bi bi-arrow-right"></i>
                    </a>

                    <a href="<%= contextPath %>/admin/treatments"
						   class="quick-action-card">
						
						    <div class="quick-action-icon">
						
						        <i class="bi bi-journal-medical"></i>
						
						    </div>
						
						    <div>
						
						        <strong>Manage Treatments</strong>
						
						        <span>
						            Treatment types and standard pricing
						        </span>
						
						    </div>
						
						    <i class="bi bi-arrow-right"></i>
						
						</a>

                    <a href="<%= contextPath %>/admin/dentist-slots" class="quick-action-card">
                        <div class="quick-action-icon">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <div>
                            <strong>Dentist Time Slots</strong>
                            <span>View doctor availability schedules</span>
                        </div>
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </section>

            <!-- TODAY'S APPOINTMENTS SECTION -->
            <section class="appointments-section">
                <div class="section-heading">
                    <div>
                        <h3>Today's Appointments</h3>
                        <p>Scheduled appointments for <%= today.toLocalDate().format(DateTimeFormatter.ofPattern("dd MMMM yyyy")) %></p>
                    </div>
                </div>

                <div class="table-container">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th>Appointment #</th>
                                <th>Time</th>
                                <th>Patient</th>
                                <th>Assigned Dentist</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (todayAppointments != null && !todayAppointments.isEmpty()) {
                                for (Appointment appointment : todayAppointments) {
                                    String pName = (patientNames != null && patientNames.get(appointment.getPatientId()) != null)
                                            ? patientNames.get(appointment.getPatientId()) : "Patient #" + appointment.getPatientId();
                                    String dName = (dentistNames != null && dentistNames.get(appointment.getDentistId()) != null)
                                            ? dentistNames.get(appointment.getDentistId()) : "Dentist #" + appointment.getDentistId();
                                    String status = appointment.getStatus() != null ? appointment.getStatus() : "PENDING";
                                    String statusClass = status.trim().toLowerCase().replace(" ", "-");
                        %>
                            <tr>
                                <td>
                                    <strong style="color: #0c3d4f;">
                                        <%= appointment.getAppointmentNumber() != null ? appointment.getAppointmentNumber() : "APT-" + appointment.getAppointmentId() %>
                                    </strong>
                                </td>
                                <td>
                                    <span style="color: #557280; font-weight: 500;">
                                        <%= appointment.getStartTime() %> - <%= appointment.getEndTime() %>
                                    </span>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="patient-avatar">
                                            <%= pName.length() >= 1 ? pName.substring(0, 1).toUpperCase() : "P" %>
                                        </div>
                                        <div>
                                            <strong><%= pName %></strong>
                                            <span>#PAT-<%= appointment.getPatientId() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span style="color: #0ea5b4; font-weight: 600;">Dr. <%= dName %></span>
                                </td>
                                <td>
                                    <span class="status <%= statusClass %>">
                                        <%= status %>
                                    </span>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-calendar-x" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    No appointments scheduled for today.
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

</body>
</html>