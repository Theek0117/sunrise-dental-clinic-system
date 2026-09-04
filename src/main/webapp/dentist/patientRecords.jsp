<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    String contextPath = request.getContextPath();
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }

    Dentist loggedInDentist = (Dentist) request.getAttribute("loggedInDentist");
    String rawDentistName = (loggedInDentist != null && loggedInDentist.getName() != null && !loggedInDentist.getName().isBlank())
            ? loggedInDentist.getName() : staffName;
    String dentistName = "Dr. " + rawDentistName.replaceAll("^(?i)dr\\.?\\s*", "").trim();
    String specialization = (loggedInDentist != null && loggedInDentist.getSpecialization() != null)
            ? loggedInDentist.getSpecialization() : "Dental Specialist";

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    if (patients == null) {
        patients = Collections.emptyList();
    }

    int totalPatients = patients.size();
    long activePatients = patients.stream().filter(p -> p.getStatus() == null || "ACTIVE".equalsIgnoreCase(p.getStatus())).count();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Records | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .statistics-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
            margin-bottom: 25px;
            width: 100%;
        }

        @media (max-width: 900px) {
            .statistics-grid {
                grid-template-columns: 1fr;
            }
        }

        .patients-header-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .patients-header-text p {
            font-size: 13.5px;
            color: #d6f4f8;
            margin: 0;
        }

        .patients-main-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 28px 30px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            border: 1px solid #edf3f5;
        }

        .patients-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }

        .search-bar-wrap {
            position: relative;
            flex: 1;
            min-width: 280px;
        }

        .search-bar-wrap i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 16px;
        }

        .search-bar-wrap input {
            width: 100%;
            height: 46px;
            border: 1.5px solid #dce8ec;
            border-radius: 12px;
            padding: 0 16px 0 44px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            transition: border-color 0.2s;
        }

        .search-bar-wrap input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .contact-info-block {
            display: flex;
            flex-direction: column;
            gap: 3px;
            font-size: 12px;
            color: #557280;
        }

        .contact-info-block span {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .contact-info-block i {
            color: #0ea5b4;
            font-size: 13px;
        }

        .action-pill-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            background: #edfafd;
            color: #078c9b;
            border: 1px solid rgba(7, 140, 155, 0.15);
            transition: all 0.2s ease;
        }

        .action-pill-btn:hover {
            background: #0ea5b4;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .empty-patients-box {
            text-align: center;
            padding: 60px 20px;
            color: #8da4ae;
        }

        .empty-patients-box i {
            font-size: 48px;
            color: #b8d2dc;
            margin-bottom: 12px;
            display: block;
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
            <img src="<%= contextPath %>/images/logo1.png" alt="Sunrise Dental Clinic Logo">
            <div class="brand-text">
                <h2>Sunrise</h2>
                <span>Dental Clinic</span>
            </div>
        </div>

        <nav class="sidebar-navigation">
            <p class="navigation-title">MAIN</p>

            <a href="<%= contextPath %>/dentist/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/dentist/appointments" class="nav-item">
                <i class="bi bi-calendar-check"></i>
                <span>My Appointments</span>
            </a>

            <div class="nav-group open">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>My Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>
                <div class="nav-submenu open">
                    <a href="<%= contextPath %>/dentist/patients" class="nav-subitem active">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Patient Records</span>
                    </a>
                    <a href="<%= contextPath %>/dentist/treatment-history" class="nav-subitem">
                        <i class="bi bi-clock-history"></i>
                        <span>Treatment History</span>
                    </a>
                </div>
            </div>

            <a href="<%= contextPath %>/dentist/availability" class="nav-item">
                <i class="bi bi-calendar2-week"></i>
                <span>My Availability</span>
            </a>

            <p class="navigation-title clinic-title">CLINIC</p>

            <a href="<%= contextPath %>/dentist/helpdesk.jsp" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="<%= contextPath %>/dentist/profile" class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>
            <a href="<%= contextPath %>/logout" class="nav-item logout-item">
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
                <div>
                    <h1>Patient Clinical Directory</h1>
                    <p>Search registered patients to review contact details, clinical history, diagnostic notes, and past appointments.</p>
                </div>
            </div>
            <div class="topbar-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= dentistName %></strong>
                        <span><%= specialization %></span>
                    </div>
                </div>
            </div>
        </header>

        <!-- CONTENT -->
        <section class="dashboard-content">

            <!-- Stats Grid -->
            <section class="statistics-grid">
                <div class="stat-card">
                    <div class="stat-icon patient-icon">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <div class="stat-information">
                        <span>Total Registered Patients</span>
                        <strong><%= totalPatients %></strong>
                        <small>Active clinical roster</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon confirmed-icon">
                        <i class="bi bi-person-check-fill"></i>
                    </div>
                    <div class="stat-information">
                        <span>Active Patients</span>
                        <strong><%= activePatients %></strong>
                        <small>Eligible for consultations</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon availability-icon">
                        <i class="bi bi-hospital"></i>
                    </div>
                    <div class="stat-information">
                        <span>Dental Clinic</span>
                        <strong>Sunrise Health</strong>
                        <small>Patient Records Unit</small>
                    </div>
                </div>
            </section>

            <!-- Patients Table Card -->
            <div class="patients-main-card">

                <div class="patients-toolbar">
                    <div class="search-bar-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" id="patientSearch" placeholder="Search by patient name, patient #, phone number, or email..." onkeyup="filterPatients()">
                    </div>
                </div>

                <% if (patients.isEmpty()) { %>
                    <div class="empty-patients-box">
                        <i class="bi bi-people"></i>
                        <strong style="font-size: 16px; color: #355360; display: block; margin-bottom: 5px;">No Patient Records Found</strong>
                        <p style="font-size: 13px; margin: 0;">Patients registered through reception will be listed in this clinical directory.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table id="patientsTable">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Contact Information</th>
                                    <th>Address</th>
                                    <th>Status</th>
                                    <th>Clinical History</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Patient p : patients) { %>
                                    <tr data-search="<%= (p.getName() != null ? p.getName() : "") + " " + (p.getPatientNumber() != null ? p.getPatientNumber() : "") + " " + (p.getContactNumber() != null ? p.getContactNumber() : "") + " " + (p.getEmail() != null ? p.getEmail() : "") + " " + (p.getAddress() != null ? p.getAddress() : "") %>">
                                        <td>
                                            <div class="patient-cell">
                                                <div class="patient-avatar">
                                                    <%= p.getName() != null && !p.getName().isBlank() ? p.getName().substring(0, 1).toUpperCase() : "P" %>
                                                </div>
                                                <div>
                                                    <strong><%= p.getName() != null ? p.getName() : "Patient #" + p.getPatientId() %></strong>
                                                    <span>#<%= p.getPatientNumber() != null ? p.getPatientNumber() : "PAT-" + p.getPatientId() %></span>
                                                    <% if (p.getDateOfBirth() != null) { %>
                                                        <small style="color: #64748b; font-size: 11px; display: block; margin-top: 2px;">
                                                            <i class="bi bi-calendar2-date" style="color: #0ea5b4;"></i> DOB: <%= p.getDateOfBirth() %>
                                                        </small>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="contact-info-block">
                                                <span><i class="bi bi-telephone-fill"></i> <%= p.getContactNumber() != null && !p.getContactNumber().isBlank() ? p.getContactNumber() : "N/A" %></span>
                                                <span><i class="bi bi-envelope-fill"></i> <%= p.getEmail() != null && !p.getEmail().isBlank() ? p.getEmail() : "N/A" %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="color: #455a64; font-size: 12.5px;">
                                                <%= p.getAddress() != null && !p.getAddress().isBlank() ? p.getAddress() : "N/A" %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="status <%= p.getStatus() == null || "ACTIVE".equalsIgnoreCase(p.getStatus()) ? "status-confirmed" : "status-cancelled" %>">
                                                <%= p.getStatus() != null ? p.getStatus() : "ACTIVE" %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="<%= contextPath %>/dentist/treatment-history" class="action-pill-btn">
                                                <i class="bi bi-clock-history"></i> View Treatments
                                            </a>
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
function filterPatients() {
    const input = document.getElementById("patientSearch").value.toLowerCase();
    const rows = document.querySelectorAll("#patientsTable tbody tr");

    rows.forEach(row => {
        const text = row.getAttribute("data-search").toLowerCase();
        if (text.includes(input)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
}
</script>
<script src="${pageContext.request.contextPath}/js/notifications.js"></script>

</body>
</html>