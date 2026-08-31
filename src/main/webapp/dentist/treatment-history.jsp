<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.Treatment" %>

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

    List<Treatment> treatmentHistory = (List<Treatment>) request.getAttribute("treatmentHistory");
    if (treatmentHistory == null) {
        treatmentHistory = java.util.Collections.emptyList();
    }

    String errorMessage = (String) request.getAttribute("errorMessage");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    int totalTreatments = treatmentHistory.size();
    long followUpCount = treatmentHistory.stream().filter(t -> t.getNextAppointmentDate() != null).count();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatment History | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .treatment-header-card {
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

        .treatment-header-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .treatment-header-text p {
            font-size: 13.5px;
            color: #d6f4f8;
            margin: 0;
        }

        .history-main-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 28px 30px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            border: 1px solid #edf3f5;
        }

        .history-toolbar {
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

        .diagnosis-tag {
            display: inline-block;
            background: #e8f4fd;
            color: #0b7ad1;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .procedure-text {
            color: #294b5c;
            font-size: 13px;
            font-weight: 500;
        }

        .notes-box {
            background: #f8fafb;
            border: 1px solid #edf2f5;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 12px;
            color: #557280;
            margin-top: 4px;
            max-width: 380px;
        }

        .followup-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #fff8e6;
            color: #b57a09;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11.5px;
            font-weight: 600;
        }

        .empty-history-box {
            text-align: center;
            padding: 60px 20px;
            color: #8da4ae;
        }

        .empty-history-box i {
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

            <div class="nav-group open">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>My Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>
                <div class="nav-submenu open">
                    <a href="${pageContext.request.contextPath}/dentist/patients" class="nav-subitem">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Patient Records</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dentist/treatment-history" class="nav-subitem active">
                        <i class="bi bi-clock-history"></i>
                        <span>Treatment History</span>
                    </a>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/dentist/availability" class="nav-item">
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
                <h1>Treatment History</h1>
                <p>Comprehensive record of dental diagnoses, procedures, and patient notes</p>
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
            <div class="treatment-header-card">
                <div class="treatment-header-text">
                    <h2>Clinical Treatment Archives</h2>
                    <p>
                        Review all documented dental treatments, medications prescribed, and scheduled patient follow-up sessions.
                    </p>
                </div>
                <i class="bi bi-journal-medical" style="font-size: 55px; opacity: 0.85;"></i>
            </div>

            <!-- Stats Grid -->
            <section class="statistics-grid">
                <div class="stat-card">
                    <div class="stat-icon appointment-icon">
                        <i class="bi bi-file-earmark-medical"></i>
                    </div>
                    <div class="stat-information">
                        <span>Total Treatments Logged</span>
                        <strong><%= totalTreatments %></strong>
                        <small>Clinical records</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon confirmed-icon">
                        <i class="bi bi-check-circle"></i>
                    </div>
                    <div class="stat-information">
                        <span>Follow-Ups Scheduled</span>
                        <strong><%= followUpCount %></strong>
                        <small>Next visits noted</small>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon availability-icon">
                        <i class="bi bi-shield-plus"></i>
                    </div>
                    <div class="stat-information">
                        <span>Attending Surgeon</span>
                        <strong>Dr. <%= dentistName %></strong>
                        <small><%= specialization %></small>
                    </div>
                </div>
            </section>

            <!-- Treatments Table Card -->
            <div class="history-main-card">

                <div class="history-toolbar">
                    <div class="search-bar-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" id="treatmentSearch" placeholder="Search by patient name, diagnosis, or treatment notes..." onkeyup="filterTreatments()">
                    </div>
                </div>

                <% if (treatmentHistory.isEmpty()) { %>
                    <div class="empty-history-box">
                        <i class="bi bi-folder-x"></i>
                        <strong style="font-size: 16px; color: #355360; display: block; margin-bottom: 5px;">No Treatment Records Found</strong>
                        <p style="font-size: 13px; margin: 0;">Completed patient consultations and logged medical records will be archived here.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table id="treatmentsTable">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Patient</th>
                                    <th>Diagnosis</th>
                                    <th>Treatment & Notes</th>
                                    <th>Next Follow-Up</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Treatment t : treatmentHistory) { %>
                                    <tr data-search="<%= (t.getPatientName() != null ? t.getPatientName() : "") + " " + (t.getDiagnosis() != null ? t.getDiagnosis() : "") + " " + (t.getTreatmentProvided() != null ? t.getTreatmentProvided() : "") + " " + (t.getTreatmentNotes() != null ? t.getTreatmentNotes() : "") %>">
                                        <td>
                                            <strong style="color: #0c3d4f; font-size: 13px;">
                                                <%= t.getCreatedAt() != null ? dateFormat.format(t.getCreatedAt()) : "-" %>
                                            </strong>
                                            <% if (t.getAppointmentNumber() != null && !t.getAppointmentNumber().isBlank()) { %>
                                                <small style="display: block; color: #8da4ae; font-size: 11px;"><%= t.getAppointmentNumber() %></small>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="patient-cell">
                                                <div class="patient-avatar">
                                                    <%= t.getPatientName() != null && !t.getPatientName().isBlank() ? t.getPatientName().substring(0, 1).toUpperCase() : "P" %>
                                                </div>
                                                <div>
                                                    <strong><%= t.getPatientName() != null ? t.getPatientName() : "Patient #" + t.getPatientId() %></strong>
                                                    <span>ID: #<%= t.getPatientId() %></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="diagnosis-tag">
                                                <%= t.getDiagnosis() != null && !t.getDiagnosis().isBlank() ? t.getDiagnosis() : "General Consultation" %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="procedure-text">
                                                <%= t.getTreatmentProvided() != null && !t.getTreatmentProvided().isBlank() ? t.getTreatmentProvided() : "-" %>
                                            </div>
                                            <% if (t.getTreatmentNotes() != null && !t.getTreatmentNotes().isBlank()) { %>
                                                <div class="notes-box">
                                                    <i class="bi bi-chat-left-text" style="margin-right: 4px; color: #0ea5b4;"></i>
                                                    <%= t.getTreatmentNotes() %>
                                                </div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (t.getNextAppointmentDate() != null) { %>
                                                <span class="followup-pill">
                                                    <i class="bi bi-calendar-check"></i>
                                                    <%= dateFormat.format(t.getNextAppointmentDate()) %>
                                                </span>
                                            <% } else { %>
                                                <span style="color: #9cb0ba; font-size: 12px;">None Scheduled</span>
                                            <% } %>
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
function filterTreatments() {
    const input = document.getElementById("treatmentSearch").value.toLowerCase();
    const rows = document.querySelectorAll("#treatmentsTable tbody tr");

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

</body>
</html>