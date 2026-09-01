<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.sunrise.dental.model.Dentist"%>
<%@ page import="com.sunrise.dental.model.DentistAvailability"%>

<%
    String contextPath = request.getContextPath();

    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }

    List<DentistAvailability> availabilityList =
            (List<DentistAvailability>) request.getAttribute("availabilityList");
    if (availabilityList == null) {
        availabilityList = java.util.Collections.emptyList();
    }

    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");
    if (dentists == null) {
        dentists = java.util.Collections.emptyList();
    }

    Map<Integer, Dentist> dentistMap =
            (Map<Integer, Dentist>) request.getAttribute("dentistMap");
    if (dentistMap == null) {
        dentistMap = java.util.Collections.emptyMap();
    }

    Integer selectedDentistId = (Integer) request.getAttribute("selectedDentistId");
    String selectedDate = (String) request.getAttribute("selectedDate");

    SimpleDateFormat dayDateFormat = new SimpleDateFormat("EEEE, dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat createdFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    int totalSlots = availabilityList.size();
    LocalDate today = LocalDate.now();
    long todaySlots = availabilityList.stream().filter(s -> s.getAvailableDate() != null && s.getAvailableDate().toString().equals(today.toString())).count();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dentist Time Slots | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .slots-header-card {
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

        .slots-header-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .slots-header-text p {
            font-size: 13.5px;
            color: #d6f4f8;
            margin: 0;
        }

        .filter-container-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 22px 26px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(7, 43, 56, 0.08);
            border: 1px solid #edf3f5;
        }

        .filter-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .filter-form-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .filter-label {
            font-size: 12.5px;
            font-weight: 600;
            color: #617c88;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .filter-select, .filter-input {
            border: 1.5px solid #dce8ec;
            padding: 9px 14px;
            border-radius: 10px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            cursor: pointer;
            transition: border-color 0.2s;
        }

        .filter-select:focus, .filter-input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .reset-filter-btn {
            padding: 9px 16px;
            border-radius: 10px;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            background: #f0f4f7;
            color: #557280;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .reset-filter-btn:hover {
            background: #e1ebf0;
            color: #078c9b;
        }

        .search-bar-wrap {
            position: relative;
            flex: 1;
            min-width: 280px;
        }

        .search-bar-wrap i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 15px;
        }

        .search-bar-wrap input {
            width: 100%;
            height: 42px;
            border: 1.5px solid #dce8ec;
            border-radius: 10px;
            padding: 0 14px 0 38px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }

        .search-bar-wrap input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .slots-table-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(6, 38, 50, 0.09);
            padding: 28px 30px;
            margin-bottom: 30px;
            border: 1px solid #edf3f5;
        }

        .empty-slots-box {
            text-align: center;
            padding: 55px 20px;
            color: #8da4ae;
        }

        .empty-slots-box i {
            font-size: 42px;
            color: #b0c9d4;
            margin-bottom: 10px;
            display: block;
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

            <a href="<%= contextPath %>/admin/staff" class="nav-item">
                <i class="bi bi-people-fill"></i>
                <span>Staff Management</span>
            </a>

            <a href="<%= contextPath %>/admin/dentist-slots" class="nav-item active">
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
                <h1>Dentist Available Time Slots</h1>
                <p>Overview of doctor consultation hours and available clinical schedules</p>
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

        <!-- CONTENT -->
        <section class="dashboard-content">

            <!-- Hero Banner -->
            <div class="slots-header-card">
                <div class="slots-header-text">
                    <h2>Doctor Time Slot Directory</h2>
                    <p>
                        Review configured consultation windows, capacity limits, and doctor availability across all clinical dates.
                    </p>
                </div>
                <i class="bi bi-calendar2-range" style="font-size: 55px; opacity: 0.85;"></i>
            </div>

            <!-- Stats Grid -->
            <section class="statistics-grid">
                <div class="stat-card">
                    <div class="stat-icon appointment-icon">
                        <i class="bi bi-calendar-check"></i>
                    </div>
                    <div class="stat-information">
                        <span>Total Configured Slots</span>
                        <strong><%= totalSlots %></strong>
                        <small>Records in database</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon patient-icon">
                        <i class="bi bi-hospital"></i>
                    </div>
                    <div class="stat-information">
                        <span>Active Dentists</span>
                        <strong><%= dentists.size() %></strong>
                        <small>Practitioners on roster</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon confirmed-icon">
                        <i class="bi bi-check-circle"></i>
                    </div>
                    <div class="stat-information">
                        <span>Today's Available Slots</span>
                        <strong><%= todaySlots %></strong>
                        <small>Consultation windows</small>
                    </div>
                </div>
            </section>

            <!-- Filter & Search Toolbar -->
            <div class="filter-container-card">
                <div class="filter-row">

                    <!-- Filter Form -->
                    <form method="get" action="<%= contextPath %>/admin/dentist-slots" class="filter-form-group">
                        <div>
                            <span class="filter-label">Dentist:</span>
                            <select name="dentistId" class="filter-select" onchange="this.form.submit()">
                                <option value="">-- All Dentists --</option>
                                <% for (Dentist d : dentists) { %>
                                    <option value="<%= d.getDentistId() %>" <%= selectedDentistId != null && selectedDentistId == d.getDentistId() ? "selected" : "" %>>
                                        Dr. <%= d.getName() %> (<%= d.getSpecialization() %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div>
                            <span class="filter-label">Date:</span>
                            <input type="date" name="date" class="filter-input" value="<%= selectedDate != null ? selectedDate : "" %>" onchange="this.form.submit()">
                        </div>

                        <% if (selectedDentistId != null || (selectedDate != null && !selectedDate.isBlank())) { %>
                            <a href="<%= contextPath %>/admin/dentist-slots" class="reset-filter-btn">
                                <i class="bi bi-x-circle"></i> Clear Filters
                            </a>
                        <% } %>
                    </form>

                    <!-- Instant Search Bar -->
                    <div class="search-bar-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" id="slotSearch" placeholder="Search by dentist, day (e.g. Tuesday), date, or time..." onkeyup="filterSlots()">
                    </div>

                </div>
            </div>

            <!-- Slots Table Card -->
            <div class="slots-table-card">
                <div class="section-heading">
                    <div>
                        <h3>Configured Dentist Availability Table</h3>
                        <p>Showing doctor working hours from sunrise_dental_clinic.dentist_availability</p>
                    </div>
                </div>

                <div class="table-container">
                    <table class="appointments-table" id="slotsTable">
                        <thead>
                            <tr>
                                <th>Slot ID</th>
                                <th>Dentist</th>
                                <th>Available Date & Day</th>
                                <th>Working Time Window</th>
                                <th>Slot Capacity</th>
                                <th>Status</th>
                                <th>Created At</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (!availabilityList.isEmpty()) {
                                for (DentistAvailability slot : availabilityList) {
                                    Dentist d = dentistMap.get(slot.getDentistId());
                                    String dName = (d != null && d.getName() != null) ? d.getName() : "Dentist #" + slot.getDentistId();
                                    String dSpec = (d != null && d.getSpecialization() != null) ? d.getSpecialization() : "Dental Surgeon";
                                    String dayName = slot.getAvailableDate() != null ? dayDateFormat.format(slot.getAvailableDate()) : "-";
                                    String timeRange = (slot.getStartTime() != null ? timeFormat.format(slot.getStartTime()) : "-")
                                            + " - " + (slot.getEndTime() != null ? timeFormat.format(slot.getEndTime()) : "-");
                                    String status = slot.getStatus() != null ? slot.getStatus() : "AVAILABLE";
                                    String statusClass = "AVAILABLE".equalsIgnoreCase(status) || "ACTIVE".equalsIgnoreCase(status) ? "status-confirmed" : "status-cancelled";
                        %>
                            <tr data-search="<%= slot.getAvailabilityId() + " " + dName + " " + dSpec + " " + dayName + " " + timeRange + " " + status %>">
                                <td>
                                    <strong style="color: #0c3d4f; font-size: 13px;">#<%= slot.getAvailabilityId() %></strong>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="patient-avatar">
                                            <%= dName.length() >= 1 ? dName.substring(0, 1).toUpperCase() : "D" %>
                                        </div>
                                        <div>
                                            <strong>Dr. <%= dName %></strong>
                                            <span>ID: #<%= slot.getDentistId() %> • <%= dSpec %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <strong style="color: #1a3b47; font-size: 13px;"><%= dayName %></strong>
                                </td>
                                <td>
                                    <span style="color: #078c9b; font-weight: 600; font-size: 13px;">
                                        <i class="bi bi-clock" style="margin-right: 4px;"></i> <%= timeRange %>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #557280;">
                                        <%= slot.getSlotCapacity() %> patient / 30m
                                    </span>
                                </td>
                                <td>
                                    <span class="status <%= statusClass %>">
                                        <%= status %>
                                    </span>
                                </td>
                                <td>
                                    <span style="color: #8da4ae; font-size: 11.5px;">
                                        <%= slot.getCreatedAt() != null ? createdFormat.format(slot.getCreatedAt()) : "-" %>
                                    </span>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" class="empty-slots-box">
                                    <i class="bi bi-calendar-x"></i>
                                    <strong style="font-size: 15px; color: #355360; display: block; margin-bottom: 5px;">No Availability Time Slots Found</strong>
                                    <p style="font-size: 13px; margin: 0;">No dentist availability records match your selected filter.</p>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

        </section>

    </main>

</div>

<script>
function filterSlots() {
    const input = (document.getElementById("slotSearch").value || "").toLowerCase();
    const rows = document.querySelectorAll("#slotsTable tbody tr");

    rows.forEach(row => {
        const text = (row.getAttribute("data-search") || "").toLowerCase();
        if (!text) return;
        if (text.includes(input)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
}
</script>

</body>
</html>
