<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.DentistAvailability" %>

<%
    String contextPath = request.getContextPath();
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }

    Dentist loggedInDentist = (Dentist) request.getAttribute("loggedInDentist");
    String dentistName = (loggedInDentist != null && loggedInDentist.getName() != null && !loggedInDentist.getName().isBlank())
            ? loggedInDentist.getName() : staffName;
    String specialization = (loggedInDentist != null && loggedInDentist.getSpecialization() != null)
            ? loggedInDentist.getSpecialization() : "Dental Specialist";
    String roomNumber = (loggedInDentist != null && loggedInDentist.getRoomNumber() != null)
            ? loggedInDentist.getRoomNumber() : "Room 101";

    Date selectedDate = (Date) request.getAttribute("selectedDate");
    if (selectedDate == null) {
        selectedDate = Date.valueOf(LocalDate.now());
    }

    List<DentistAvailability> availabilityList = (List<DentistAvailability>) request.getAttribute("availabilityList");
    if (availabilityList == null) {
        availabilityList = java.util.Collections.emptyList();
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Availability | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .availability-header-card {
            background: linear-gradient(135deg, rgba(14, 165, 180, 0.9), rgba(8, 127, 140, 0.95));
            border-radius: 20px;
            padding: 30px 35px;
            color: #ffffff;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(8, 127, 140, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px;
        }

        .availability-header-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .availability-header-text p {
            font-size: 13.5px;
            color: #d6f4f8;
            margin: 0;
        }

        .date-filter-bar {
            background: #ffffff;
            border-radius: 16px;
            padding: 18px 24px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 8px 25px rgba(7, 43, 56, 0.08);
            border: 1px solid #edf3f5;
            flex-wrap: wrap;
            gap: 16px;
        }

        .date-filter-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .date-filter-left span {
            font-size: 13.5px;
            font-weight: 600;
            color: #0c3d4f;
        }

        .date-filter-left input[type="date"] {
            border: 1.5px solid #dce8ec;
            padding: 9px 14px;
            border-radius: 10px;
            font-size: 13.5px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            cursor: pointer;
        }

        .date-filter-left input[type="date"]:focus {
            border-color: #0ea5b4;
        }

        .date-shortcuts {
            display: flex;
            gap: 8px;
        }

        .date-btn {
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 12.5px;
            font-weight: 600;
            color: #078c9b;
            background: #eaf7f9;
            border: 1px solid rgba(7, 140, 155, 0.15);
            transition: all 0.2s ease;
        }

        .date-btn:hover, .date-btn.active {
            background: #0ea5b4;
            color: #ffffff;
        }

        .availability-layout-grid {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 28px;
            align-items: start;
        }

        .form-card, .list-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            border: 1px solid #edf3f5;
        }

        .card-header-inner {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
            padding-bottom: 14px;
            border-bottom: 1.5px solid #f0f4f6;
        }

        .card-header-inner i {
            font-size: 20px;
            color: #0ea5b4;
        }

        .card-header-inner h3 {
            font-size: 17px;
            font-weight: 700;
            color: #0c3d4f;
            margin: 0;
        }

        .form-group-item {
            margin-bottom: 18px;
        }

        .form-group-item label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #708a96;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .form-group-item input, .form-group-item select {
            width: 100%;
            border: 1.5px solid #dce8ec;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13.5px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-group-item input:focus, .form-group-item select:focus {
            border-color: #0ea5b4;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(14, 165, 180, 0.1);
        }

        .time-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .submit-btn {
            width: 100%;
            padding: 13px;
            border-radius: 10px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 6px 18px rgba(8, 140, 155, 0.25);
            transition: all 0.2s ease;
            margin-top: 24px;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(8, 140, 155, 0.35);
        }

        .alert-banner {
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-banner.success {
            background: #eafaf1;
            color: #0e7a44;
            border: 1px solid rgba(14, 122, 68, 0.2);
        }

        .alert-banner.error {
            background: #fff0f1;
            color: #c92a2a;
            border: 1px solid rgba(201, 42, 42, 0.2);
        }

        .empty-slots-box {
            text-align: center;
            padding: 45px 20px;
            color: #8da4ae;
        }

        .empty-slots-box i {
            font-size: 42px;
            color: #b0c9d4;
            margin-bottom: 12px;
            display: block;
        }

        @media (max-width: 1024px) {
            .availability-layout-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- =========================================================
         SIDEBAR
         ========================================================= -->
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

            <a href="${pageContext.request.contextPath}/dentist/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/dentist/appointments" class="nav-item">
                <i class="bi bi-calendar-check"></i>
                <span>My Appointments</span>
            </a>

            <div class="nav-group">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>My Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/dentist/patients" class="nav-subitem">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Patient Records</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dentist/treatment-history" class="nav-subitem">
                        <i class="bi bi-clock-history"></i>
                        <span>Treatment History</span>
                    </a>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/dentist/availability" class="nav-item active">
                <i class="bi bi-calendar2-week"></i>
                <span>My Availability</span>
            </a>

            <p class="navigation-title clinic-title">CLINIC</p>

            <a href="${pageContext.request.contextPath}/dentist/helpdesk.jsp" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="${pageContext.request.contextPath}/dentist/profile" class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- =========================================================
         MAIN CONTENT
         ========================================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1>My Availability</h1>
                <p>Manage your consultation hours, active working days and slot capacities</p>
            </div>
            <div class="topbar-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong>Dr. <%= dentistName %></strong>
                        <span><%= specialization %></span>
                    </div>
                </div>
            </div>
        </header>

        <!-- CONTENT -->
        <section class="dashboard-content">

            <!-- Hero Banner -->
            <div class="availability-header-card">
                <div class="availability-header-text">
                    <h2>Doctor Consultation Roster</h2>
                    <p>
                        Configured hours are automatically published to the reception booking desk as 30-minute reservation windows.
                    </p>
                </div>
                <i class="bi bi-calendar-range" style="font-size: 55px; opacity: 0.85;"></i>
            </div>

            <!-- Alerts -->
            <% if (success != null) { %>
                <div class="alert-banner success">
                    <i class="bi bi-check-circle-fill"></i>
                    <span><strong>Success:</strong> Availability schedule has been successfully saved!</span>
                </div>
            <% } %>

            <% if (error != null && !error.isBlank()) { %>
                <div class="alert-banner error">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span><strong>Error:</strong> <%= error %></span>
                </div>
            <% } %>

            <!-- Date Selector Filter Toolbar -->
            <div class="date-filter-bar">
                <div class="date-filter-left">
                    <i class="bi bi-calendar-event" style="color: #0ea5b4; font-size: 20px;"></i>
                    <span>View Schedule For:</span>
                    <form method="get" action="<%= contextPath %>/dentist/availability" style="display: flex; gap: 10px; align-items: center;">
                        <input type="date" name="date" value="<%= selectedDate %>" onchange="this.form.submit()">
                    </form>
                </div>

                <div class="date-shortcuts">
                    <%
                        LocalDate today = LocalDate.now();
                        LocalDate tomorrow = today.plusDays(1);
                    %>
                    <a href="<%= contextPath %>/dentist/availability?date=<%= today %>"
                       class="date-btn <%= today.toString().equals(selectedDate.toString()) ? "active" : "" %>">
                        Today (<%= dateFormat.format(Date.valueOf(today)) %>)
                    </a>
                    <a href="<%= contextPath %>/dentist/availability?date=<%= tomorrow %>"
                       class="date-btn <%= tomorrow.toString().equals(selectedDate.toString()) ? "active" : "" %>">
                        Tomorrow (<%= dateFormat.format(Date.valueOf(tomorrow)) %>)
                    </a>
                </div>
            </div>

            <!-- Two-Column Form & Slot List Grid -->
            <div class="availability-layout-grid">

                <!-- Left: Add Working Hours Form -->
                <div class="form-card">
                    <div class="card-header-inner">
                        <i class="bi bi-plus-circle-fill"></i>
                        <h3>Add Working Hours</h3>
                    </div>

                    <form method="post" action="<%= contextPath %>/dentist/availability">
                        <div class="form-group-item">
                            <label>Consultation Date</label>
                            <input type="date" name="availableDate" id="availableDate" value="<%= selectedDate %>" min="<%= LocalDate.now() %>" required>
                        </div>

                        <div class="time-row">
                            <div class="form-group-item">
                                <label>Start Time</label>
                                <input type="time" name="startTime" value="09:00" required>
                            </div>
                            <div class="form-group-item">
                                <label>End Time</label>
                                <input type="time" name="endTime" value="13:00" required>
                            </div>
                        </div>

                        <div class="form-group-item">
                            <label>Assigned Operatory</label>
                            <input type="text" value="<%= roomNumber %>" readonly style="background: #f1f6f8; cursor: not-allowed;">
                        </div>

                        <button type="submit" class="submit-btn">
                            <i class="bi bi-check2-circle"></i> Save Availability Slot
                        </button>
                    </form>
                </div>

                <!-- Right: Configured Slots List -->
                <div class="list-card">
                    <div class="card-header-inner">
                        <i class="bi bi-list-check"></i>
                        <h3>Configured Slots on <%= dateFormat.format(selectedDate) %></h3>
                    </div>

                    <% if (availabilityList.isEmpty()) { %>
                        <div class="empty-slots-box">
                            <i class="bi bi-calendar-x"></i>
                            <strong>No consultation hours configured</strong>
                            <p style="font-size: 12.5px; margin: 4px 0 0;">Use the form on the left to add your available working window for this date.</p>
                        </div>
                    <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Time Window</th>
                                        <th>Capacity</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DentistAvailability a : availabilityList) { %>
                                        <tr>
                                            <td>
                                                <strong style="color: #0c3d4f; font-size: 13.5px;">
                                                    <%= timeFormat.format(a.getStartTime()) %> - <%= timeFormat.format(a.getEndTime()) %>
                                                </strong>
                                            </td>
                                            <td>
                                                <span style="font-weight: 600; color: #557280;">
                                                    <%= a.getSlotCapacity() %> patient / 30m
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status <%= "ACTIVE".equalsIgnoreCase(a.getStatus()) || "AVAILABLE".equalsIgnoreCase(a.getStatus()) ? "status-confirmed" : "status-cancelled" %>">
                                                    <%= a.getStatus() %>
                                                </span>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>

            </div>

        </section>

    </main>

</div>

<script src="<%= contextPath %>/js/notifications.js"></script>

</body>
</html>