<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.DentistAvailability" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }

    String selectedDentistId =
            request.getAttribute("selectedDentistId") != null
                    ? request.getAttribute("selectedDentistId").toString()
                    : "";

    String selectedDate =
            request.getAttribute("selectedDate") != null
                    ? request.getAttribute("selectedDate").toString()
                    : "";

    List<DentistAvailability> availabilityList =
            (List<DentistAvailability>) request.getAttribute("availabilityList");

    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Dentist Availability | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .filter-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            padding: 26px 30px;
            margin-bottom: 25px;
            border: 1px solid #edf3f5;
        }

        .filter-form-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr auto;
            gap: 18px;
            align-items: flex-end;
        }

        .form-group-item {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .form-group-item label {
            font-size: 13px;
            font-weight: 600;
            color: #2c4a57;
        }

        .form-group-item select, .form-group-item input {
            height: 44px;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            padding: 0 16px;
            font-size: 13.5px;
            color: #123847;
            background: #ffffff;
            outline: none;
            cursor: pointer;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .form-group-item select:hover, .form-group-item input:hover {
            border-color: #a4cddc;
        }

        .form-group-item select:focus, .form-group-item input:focus {
            border-color: #0ea5b4 !important;
            background: #ffffff !important;
            box-shadow: 0 0 0 3.5px rgba(14, 165, 180, 0.14) !important;
        }

        .submit-search-btn {
            height: 44px;
            padding: 0 26px;
            border-radius: 11px;
            border: none;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 14px rgba(8, 127, 140, 0.25);
            transition: all 0.2s ease;
        }

        .submit-search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(8, 127, 140, 0.35);
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

            <div class="nav-dropdown">
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
                    <a href="${pageContext.request.contextPath}/reception/view-appointments" class="nav-subitem">
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

            <div class="nav-group open">
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
                    <a href="${pageContext.request.contextPath}/reception/dentist-availability" class="nav-subitem active">
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
                    <h1>Doctor Schedule Query</h1>
                    <p>Select a dentist and consultation date to see working windows and available appointment capacity.</p>
                </div>
            </div>

            <div class="topbar-right" style="display: flex; align-items: center; gap: 14px;">
                <div class="current-date" style="background: rgba(14, 165, 180, 0.18); border: 1px solid rgba(14, 165, 180, 0.35); padding: 7px 14px; border-radius: 9px; font-size: 13px; color: #ffffff; display: flex; align-items: center; gap: 8px;">
                    <i class="bi bi-calendar3" style="color: #67e8f9;"></i>
                    <span><%= selectedDate != null && !selectedDate.isBlank() ? selectedDate : "Today" %></span>
                </div>

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

            <!-- Filter Card -->
            <div class="filter-card">
                <form method="get" action="${pageContext.request.contextPath}/reception/dentist-availability" class="filter-form-grid">
                    <div class="form-group-item">
                        <label for="dentistId">Doctor / Specialist</label>
                        <select id="dentistId" name="dentistId" required>
                            <option value="">-- Choose a Dentist --</option>
                            <% if (dentists != null) {
                                for (Dentist d : dentists) { 
                                    String dClean = d.getName() != null ? d.getName().replaceAll("^(?i)dr\\.?\\s*", "").trim() : "";
                                %>
                                    <option value="<%= d.getDentistId() %>" <%= String.valueOf(d.getDentistId()).equals(selectedDentistId) ? "selected" : "" %>>
                                        Dr. <%= dClean %> (<%= d.getSpecialization() %>)
                                    </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <div class="form-group-item">
                        <label for="date">Consultation Date</label>
                        <input type="date" id="date" name="date" value="<%= selectedDate %>" required>
                    </div>

                    <button type="submit" class="submit-search-btn">
                        <i class="bi bi-search"></i> Query Availability
                    </button>
                </form>
            </div>

            <!-- Results Section -->
            <section class="appointments-section">
                <div class="section-heading">
                    <div>
                        <h3>Available Working Hours & Time Slots</h3>
                        <p><%= selectedDate != null && !selectedDate.isBlank() ? "Consultation windows for " + selectedDate : "Select doctor and date to view working hours" %></p>
                    </div>
                </div>

                <div class="table-container">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th># Slot ID</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Slot Capacity</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (availabilityList != null && !availabilityList.isEmpty()) {
                                for (DentistAvailability slot : availabilityList) {
                        %>
                            <tr>
                                <td>
                                    <strong style="color: #0c3d4f;">#<%= slot.getAvailabilityId() %></strong>
                                </td>
                                <td>
                                    <strong style="color: #0ea5b4;"><%= slot.getStartTime() %></strong>
                                </td>
                                <td>
                                    <strong style="color: #0ea5b4;"><%= slot.getEndTime() %></strong>
                                </td>
                                <td>
                                    <span style="color: #557280; font-weight: 500;"><%= slot.getSlotCapacity() %> patient(s) / 30 min</span>
                                </td>
                                <td>
                                    <span class="status status-confirmed"><%= slot.getStatus() %></span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/reception/book-appointment?dentistId=<%= slot.getDentistId() %>&date=<%= slot.getAvailableDate() %>" class="view-all-link">
                                        <i class="bi bi-calendar-plus"></i> Book Here
                                    </a>
                                </td>
                            </tr>
                        <%
                                }
                            } else if (selectedDentistId != null && !selectedDentistId.isEmpty() && !"0".equals(selectedDentistId)) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-calendar-x" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    No available working slots found for the selected doctor on <%= selectedDate %>.
                                </td>
                            </tr>
                        <%
                            } else {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-search" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    Please select a doctor and date from the filter above to inspect schedule availability.
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

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>
</body>
</html>