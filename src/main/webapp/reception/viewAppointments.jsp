<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }

    List<Appointment> appointments =
            (List<Appointment>) request.getAttribute("appointments");

    Map<Integer, Patient> patients =
            (Map<Integer, Patient>) request.getAttribute("patients");

    Map<Integer, Dentist> dentists =
            (Map<Integer, Dentist>) request.getAttribute("dentists");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String email = request.getParameter("email");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Appointments | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .filter-toolbar-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 22px;
            flex-wrap: wrap;
        }

        .search-input-wrap {
            position: relative;
            flex: 1;
            min-width: 280px;
            max-width: 480px;
        }

        .search-input-wrap i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 15px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .search-input-wrap input {
            width: 100%;
            height: 44px;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            padding: 0 16px 0 42px;
            font-size: 13.5px;
            color: #123847;
            background: #ffffff;
            outline: none;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .search-input-wrap input:hover {
            border-color: #a4cddc;
        }

        .search-input-wrap input:focus {
            border-color: #0ea5b4 !important;
            background: #ffffff !important;
            box-shadow: 0 0 0 3.5px rgba(14, 165, 180, 0.14) !important;
        }

        .search-input-wrap:focus-within i {
            color: #0ea5b4;
        }

        .filter-controls {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .filter-controls select, .filter-controls input[type="date"] {
            height: 44px;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            padding: 0 16px;
            font-size: 13.5px;
            color: #123847;
            background: #ffffff;
            outline: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-controls select:hover, .filter-controls input[type="date"]:hover {
            border-color: #a4cddc;
        }

        .filter-controls select:focus, .filter-controls input[type="date"]:focus {
            border-color: #0ea5b4 !important;
            box-shadow: 0 0 0 3.5px rgba(14, 165, 180, 0.14) !important;
        }

        .action-link-btn {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s ease;
            border: 1px solid transparent;
        }

        .action-link-btn.reschedule {
            background: #fff8e6;
            color: #d48e0c;
            border-color: #fbe3b5;
        }
        .action-link-btn.reschedule:hover {
            background: #fde8b7;
        }

        .action-link-btn.cancel {
            background: #feecee;
            color: #c92a2a;
            border-color: #f8c8cb;
            cursor: pointer;
        }
        .action-link-btn.cancel:hover {
            background: #fad2d6;
        }

        .alert-box {
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }
        .alert-box.success { background: #e8f8f0; color: #0d8248; border: 1px solid #c2eed5; }
        .alert-box.error { background: #feecee; color: #c92a2a; border: 1px solid #f9c6cb; }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- ========================================= -->
    <!-- SIDEBAR -->
    <!-- ========================================= -->
    <aside class="sidebar" id="sidebar">

        <div class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/images/logo1.png" alt="Sunrise Dental Clinic Logo">
            <div class="brand-text">
                <h2>Sunrise</h2>
                <span>Dental Clinic</span>
            </div>
        </div>

        <nav class="sidebar-navigation">
            <p class="navigation-title">MAIN</p>

            <a href="${pageContext.request.contextPath}/reception/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/reception/schedule" class="nav-item">
                <i class="bi bi-calendar3"></i>
                <span>Today's Schedule</span>
            </a>

            <div class="nav-dropdown open">
                <button type="button" class="nav-item nav-dropdown-toggle" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-calendar-check"></i>
                        <span>Appointments</span>
                    </span>
                    <i class="bi bi-chevron-down dropdown-arrow"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/book-appointment" class="nav-subitem">
                        <i class="bi bi-calendar-plus"></i>
                        <span>Book Appointment</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/view-appointments" class="nav-subitem active">
                        <i class="bi bi-calendar3"></i>
                        <span>View Appointments</span>
                    </a>
                </div>
            </div>

            <div class="nav-group">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/register-patient" class="nav-subitem">
                        <i class="bi bi-person-plus"></i>
                        <span>Register New Patient</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/manage-patients" class="nav-subitem">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Manage Patients</span>
                    </a>
                </div>
            </div>

            <p class="navigation-title clinic-title">CLINIC</p>

            <div class="nav-group">
                <button type="button" class="nav-item nav-toggle" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-person-badge"></i>
                        <span>Dentists</span>
                    </span>
                    <i class="bi bi-chevron-down nav-arrow"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/dentists" class="nav-subitem">
                        <i class="bi bi-people"></i>
                        <span>View Dentists</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/dentist-availability" class="nav-subitem">
                        <i class="bi bi-calendar2-week"></i>
                        <span>Check Availability</span>
                    </a>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/reception/profile" class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>

            <a href="${pageContext.request.contextPath}/reception/helpdesk.jsp" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>

            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </nav>

    </aside>

    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <a href="${pageContext.request.contextPath}/reception/dashboard" class="menu-button">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h1>Appointments Directory</h1>
                    <p>View, search, reschedule, and manage patient clinic bookings</p>
                </div>
            </div>

            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/reception/profile" class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Receptionist</span>
                    </div>
                </a>
            </div>
        </header>

        <!-- DASHBOARD CONTENT -->
        <section class="dashboard-content">

            <!-- Welcome / Hero Banner -->
            <div class="welcome-section">
                <div>
                    <h2>Patient Appointments</h2>
                    <p>Complete record of all upcoming, confirmed, and past clinic bookings.</p>
                </div>
                <div class="current-date">
                    <i class="bi bi-calendar3"></i>
                    <span id="liveDateDisplay">All Records</span>
                </div>
            </div>

            <!-- Notifications -->
            <% if ("cancelled".equals(success)) { %>
                <div class="alert-box success">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>The appointment has been cancelled successfully. The time slot is now available.</span>
                </div>
            <% } else if ("rescheduled".equals(success)) { %>
                <div class="alert-box success">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>The appointment has been rescheduled successfully.</span>
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="alert-box error">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span>An error occurred while processing the request (<%= error %>).</span>
                </div>
            <% } %>

            <!-- Appointments Table Section -->
            <section class="appointments-section">

                <div class="filter-toolbar-row">
                    <div class="search-input-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" id="appointmentSearch" placeholder="Search appointment #, patient name, contact, or dentist...">
                    </div>

                    <div class="filter-controls">
                        <select id="statusFilter">
                            <option value="ALL">All Statuses</option>
                            <option value="CONFIRMED">Confirmed</option>
                            <option value="RESCHEDULED">Rescheduled</option>
                            <option value="PENDING">Pending</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>

                        <input type="date" id="dateFilter" title="Filter by date">
                    </div>
                </div>

                <div class="table-container">
                    <table class="appointments-table" id="appointmentsTable">
                        <thead>
                            <tr>
                                <th>Appointment #</th>
                                <th>Patient</th>
                                <th>Dentist</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (appointments == null || appointments.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-calendar-x" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    No appointments found in the system.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (Appointment appointment : appointments) {
                                    Patient patient = (patients != null) ? patients.get(appointment.getPatientId()) : null;
                                    Dentist dentist = (dentists != null) ? dentists.get(appointment.getDentistId()) : null;
                                    String pName = (patient != null && patient.getName() != null) ? patient.getName() : "Patient #" + appointment.getPatientId();
                                    String pPhone = (patient != null && patient.getContactNumber() != null) ? patient.getContactNumber() : "-";
                                    String dName = (dentist != null && dentist.getName() != null) ? dentist.getName() : "Dentist #" + appointment.getDentistId();
                                    String dSpec = (dentist != null && dentist.getSpecialization() != null) ? dentist.getSpecialization() : "Surgeon";
                                    String status = appointment.getStatus() != null ? appointment.getStatus() : "PENDING";
                                    String statusClass = status.trim().toLowerCase().replace(" ", "-");
                        %>
                            <tr data-search="<%= (appointment.getAppointmentNumber() + " " + pName + " " + pPhone + " " + dName + " " + dSpec).toLowerCase() %>"
                                data-status="<%= status %>"
                                data-date="<%= appointment.getAppointmentDate() %>">
                                <td>
                                    <strong style="color: #0c3d4f;"><%= appointment.getAppointmentNumber() != null ? appointment.getAppointmentNumber() : "APT-" + appointment.getAppointmentId() %></strong>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="patient-avatar">
                                            <%= pName.length() >= 1 ? pName.substring(0, 1).toUpperCase() : "P" %>
                                        </div>
                                        <div>
                                            <strong><%= pName %></strong>
                                            <span><%= pPhone %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <strong style="color: #0ea5b4;">Dr. <%= dName %></strong>
                                    <small style="display: block; font-size: 11px; color: #7a94a2;"><%= dSpec %></small>
                                </td>
                                <td>
                                    <span style="font-weight: 500; color: #1a3b47;"><%= appointment.getAppointmentDate() %></span>
                                </td>
                                <td>
                                    <span style="color: #557280; font-weight: 500;"><%= appointment.getStartTime() %> - <%= appointment.getEndTime() %></span>
                                </td>
                                <td>
                                    <span class="status <%= statusClass %>"><%= status %></span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px; align-items: center;">
                                        <% if (!"CANCELLED".equalsIgnoreCase(status) && !"COMPLETED".equalsIgnoreCase(status)) { %>
                                            <a class="action-link-btn reschedule"
                                               href="${pageContext.request.contextPath}/reception/reschedule-appointment?appointmentId=<%= appointment.getAppointmentId() %>">
                                                <i class="bi bi-arrow-repeat"></i> Reschedule
                                            </a>

                                            <form method="post" action="${pageContext.request.contextPath}/reception/cancel-appointment"
                                                  onsubmit="return confirm('Are you sure you want to cancel appointment <%= appointment.getAppointmentNumber() %>?');"
                                                  style="display:inline; margin: 0;">
                                                <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                                                <button type="submit" class="action-link-btn cancel">
                                                    <i class="bi bi-x-circle"></i> Cancel
                                                </button>
                                            </form>
                                        <% } else if ("CANCELLED".equalsIgnoreCase(status)) { %>
                                            <span style="font-size: 12px; color: #c92a2a; font-weight: 500;"><i class="bi bi-slash-circle"></i> Cancelled</span>
                                        <% } else { %>
                                            <span style="font-size: 12px; color: #129c5b; font-weight: 500;"><i class="bi bi-check-circle"></i> Completed</span>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>

            </section>

        </section>

    </main>

</div>

<script>
const searchInput = document.getElementById("appointmentSearch");
const statusFilter = document.getElementById("statusFilter");
const dateFilter = document.getElementById("dateFilter");
const rows = document.querySelectorAll("#appointmentsTable tbody tr[data-search]");

function filterAppointments() {
    const search = (searchInput.value || "").toLowerCase().trim();
    const status = statusFilter.value;
    const date = dateFilter.value;

    rows.forEach(row => {
        const rowSearch = (row.dataset.search || "");
        const rowStatus = (row.dataset.status || "");
        const rowDate = (row.dataset.date || "");

        const searchMatch = !search || rowSearch.includes(search);
        const statusMatch = status === "ALL" || rowStatus.toUpperCase() === status.toUpperCase();
        const dateMatch = !date || rowDate === date;

        row.style.display = (searchMatch && statusMatch && dateMatch) ? "" : "none";
    });
}

if (searchInput) searchInput.addEventListener("input", filterAppointments);
if (statusFilter) statusFilter.addEventListener("change", filterAppointments);
if (dateFilter) dateFilter.addEventListener("change", filterAppointments);
</script>

</body>
</html>