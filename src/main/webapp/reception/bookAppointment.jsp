<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>

<%
    /*
     * =========================================================
     * SESSION / REQUEST DATA
     * =========================================================
     */
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.trim().isEmpty()) {
        staffName = "Receptionist";
    }

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    List<TreatmentType> treatmentTypes = (List<TreatmentType>) request.getAttribute("treatmentTypes");

    if (patients == null) patients = Collections.emptyList();
    if (dentists == null) dentists = Collections.emptyList();
    if (treatmentTypes == null) treatmentTypes = Collections.emptyList();

    String contextPath = request.getContextPath();

    Object successMessage = request.getAttribute("success");
    Object errorMessage = request.getAttribute("error");
    Object appointmentNumber = request.getAttribute("appointmentNumber");
    Object emailMessage = request.getAttribute("emailMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/book-appointment.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .booking-main-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.85fr) minmax(320px, 1fr);
            gap: 26px;
            align-items: flex-start;
        }

        .booking-steps-column {
            display: flex;
            flex-direction: column;
            gap: 22px;
        }

        .form-section {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.07);
            padding: 26px 28px;
            border: 1px solid #edf3f5;
            margin-bottom: 0;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
            border-bottom: 1px solid #f2f6f8;
            padding-bottom: 14px;
        }

        .step-number {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(8, 127, 140, 0.25);
        }

        .section-heading {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .section-heading h3 {
            font-size: 16px;
            font-weight: 700;
            color: #0c3d4f;
            margin: 0;
        }

        .section-heading p {
            font-size: 12.5px;
            color: #7a94a2;
            margin: 0;
        }

        .label-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .register-new-patient-link {
            font-size: 12.5px;
            font-weight: 600;
            color: #088c9a;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #e8f8fa;
            padding: 4px 10px;
            border-radius: 7px;
            transition: all 0.2s ease;
        }

        .register-new-patient-link:hover {
            background: #d4f2f6;
            color: #056b77;
        }

        /* Time Slots Grid */
        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 12px;
            margin-top: 14px;
        }

        .time-slot {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 11px 14px;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            background: #ffffff;
            cursor: pointer;
            text-align: left;
            transition: all 0.2s ease;
            outline: none;
        }

        .time-slot:hover:not(:disabled) {
            border-color: #0ea5b4;
            background: #f0f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(8, 140, 155, 0.12);
        }

        .time-slot.selected {
            border-color: #0ea5b4 !important;
            background: linear-gradient(135deg, #0ea5b4, #087f8c) !important;
            box-shadow: 0 6px 16px rgba(8, 140, 155, 0.28);
        }

        .time-slot.selected .time-slot-content strong,
        .time-slot.selected .time-slot-content small {
            color: #ffffff !important;
        }

        .time-slot.selected > i {
            background: rgba(255, 255, 255, 0.25) !important;
            color: #ffffff !important;
        }

        /* Booked Slot (Red & Disabled) */
        .time-slot.booked, .time-slot.full, .time-slot:disabled {
            background: #fff1f2 !important;
            border-color: #fca5a5 !important;
            cursor: not-allowed !important;
            opacity: 0.95;
            box-shadow: none !important;
            transform: none !important;
        }

        .time-slot.booked > i, .time-slot.full > i {
            background: #ffe4e6 !important;
            color: #e11d48 !important;
        }

        .time-slot.booked .time-slot-content strong, .time-slot.full .time-slot-content strong {
            color: #9f1239 !important;
            text-decoration: line-through;
        }

        .time-slot.booked .time-slot-content small, .time-slot.full .time-slot-content small {
            color: #e11d48 !important;
            font-weight: 700 !important;
        }

        /* Past Slot (Gray & Disabled) */
        .time-slot.past {
            background: #f8fafc !important;
            border-color: #e2e8f0 !important;
            cursor: not-allowed !important;
            opacity: 0.6;
            box-shadow: none !important;
            transform: none !important;
        }

        .time-slot.past > i {
            background: #f1f5f9 !important;
            color: #94a3b8 !important;
        }

        .time-slot.past .time-slot-content strong {
            color: #64748b !important;
        }

        .time-slot.past .time-slot-content small {
            color: #94a3b8 !important;
        }

        /* Summary Sticky Column */
        .booking-summary-sticky {
            position: sticky;
            top: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .summary-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            padding: 26px 28px;
            border: 1px solid #edf3f5;
        }

        .summary-header-box {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
            border-bottom: 1px solid #f2f6f8;
            padding-bottom: 14px;
        }

        .summary-icon-box {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: #e8f4fd;
            color: #0b7ad1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .summary-header-box h3 {
            font-size: 16px;
            font-weight: 700;
            color: #0c3d4f;
            margin: 0;
        }

        .summary-header-box p {
            font-size: 12px;
            color: #7a94a2;
            margin: 2px 0 0;
        }

        .summary-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 22px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 9px 12px;
            background: #f8fafc;
            border-radius: 9px;
            border: 1px solid #eef3f6;
            font-size: 12.5px;
        }

        .summary-row span {
            color: #728c98;
            font-weight: 500;
        }

        .summary-row strong {
            color: #0c3d4f;
            font-weight: 600;
            text-align: right;
            max-width: 60%;
            word-break: break-word;
        }

        .quick-helper-card {
            background: linear-gradient(135deg, rgba(14, 165, 180, 0.12), rgba(8, 127, 140, 0.06));
            border: 1px dashed #0ea5b4;
            border-radius: 14px;
            padding: 16px;
            text-align: center;
        }

        .quick-helper-card p {
            font-size: 12.5px;
            color: #123d50;
            margin: 0 0 10px;
            font-weight: 500;
        }

        .quick-helper-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            background: #0ea5b4;
            color: #ffffff;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(8, 127, 140, 0.2);
        }

        @media (max-width: 960px) {
            .booking-main-grid {
                grid-template-columns: 1fr;
            }
            .booking-summary-sticky {
                position: static;
            }
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- SIDEBAR -->
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

            <a href="<%= contextPath %>/reception/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/reception/schedule" class="nav-item">
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
                    <a href="<%= contextPath %>/reception/book-appointment" class="nav-subitem active">
                        <i class="bi bi-calendar-plus"></i>
                        <span>Book Appointment</span>
                    </a>
                    <a href="<%= contextPath %>/reception/view-appointments" class="nav-subitem">
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
                    <a href="<%= contextPath %>/reception/register-patient" class="nav-subitem">
                        <i class="bi bi-person-plus"></i>
                        <span>Register New Patient</span>
                    </a>
                    <a href="<%= contextPath %>/reception/manage-patients" class="nav-subitem">
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
                    <a href="<%= contextPath %>/reception/dentists" class="nav-subitem">
                        <i class="bi bi-people"></i>
                        <span>View Dentists</span>
                    </a>
                    <a href="<%= contextPath %>/reception/dentist-availability" class="nav-subitem">
                        <i class="bi bi-calendar2-week"></i>
                        <span>Check Availability</span>
                    </a>
                </div>
            </div>

            <a href="<%= contextPath %>/reception/profile" class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>

            <a href="<%= contextPath %>/reception/helpdesk.jsp" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>

            <a href="<%= contextPath %>/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </nav>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <a href="<%= contextPath %>/reception/dashboard" class="menu-button">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h1>Book Appointment</h1>
                    <p>Schedule a new clinic booking for registered patients</p>
                </div>
            </div>

            <div class="topbar-right">
                <a href="<%= contextPath %>/reception/profile" class="user-profile">
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

            <!-- SUCCESS POPUP MODAL & MESSAGE -->
            <% if (successMessage != null) { %>
                <div class="custom-confirm-overlay show" id="bookingSuccessModal" style="display:flex; z-index:99999;">
                    <div class="custom-confirm-box" style="max-width: 480px; text-align: center; padding: 28px;">
                        <div class="confirm-icon-wrap" style="background:#ecfdf5; color:#10b981; margin:0 auto 16px; width:64px; height:64px; font-size:32px; border-radius:50%; display:flex; align-items:center; justify-content:center;">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                        <h3 style="margin:0 0 8px; color:#0f2e3d; font-size:20px; font-weight:700;">Appointment Booked Successfully!</h3>
                        <p style="color:#527382; font-size:13.5px; margin:0 0 16px;"><%= successMessage %></p>
                        
                        <% if (appointmentNumber != null) { %>
                            <div style="background:#f0fdfa; border:1.5px dashed #14b8a6; padding:12px; border-radius:10px; margin-bottom:16px;">
                                <span style="font-size:11.5px; color:#0f766e; text-transform:uppercase; letter-spacing:0.5px; font-weight:600; display:block;">Appointment Reference</span>
                                <strong style="font-size:19px; color:#0f766e; letter-spacing:1px;"><%= appointmentNumber %></strong>
                            </div>
                        <% } %>

                        <% if (emailMessage != null) { %>
                            <div style="background:#f8fafc; border:1px solid #e2e8f0; padding:10px 14px; border-radius:8px; margin-bottom:20px; font-size:12.5px; color:#334155; display:flex; align-items:center; gap:8px; justify-content:center;">
                                <i class="bi bi-envelope-check-fill" style="color:#10b981;"></i>
                                <span><%= emailMessage %></span>
                            </div>
                        <% } %>

                        <div style="display:flex; gap:10px; justify-content:center; margin-top:8px;">
                            <a href="<%= contextPath %>/reception/view-appointments" class="btn-primary" style="padding:10px 18px; font-size:13.5px; text-decoration:none; border-radius:8px; display:inline-flex; align-items:center; gap:6px; background:#0ea5b4; color:#ffffff; font-weight:600;">
                                <i class="bi bi-calendar-event"></i> View Appointments
                            </a>
                            <button type="button" class="btn-secondary" onclick="document.getElementById('bookingSuccessModal').remove();" style="padding:10px 18px; font-size:13.5px; border-radius:8px; border:1px solid #cbd5e1; background:#ffffff; color:#475569; font-weight:600; cursor:pointer;">
                                <i class="bi bi-plus-lg"></i> Book Another
                            </button>
                        </div>
                    </div>
                </div>

                <div class="message success-message" role="alert">
                    <div class="message-icon">
                        <i class="bi bi-check-circle-fill"></i>
                    </div>
                    <div class="message-content">
                        <strong>Appointment Booked Successfully</strong>
                        <p><%= successMessage %></p>
                        <% if (appointmentNumber != null) { %>
                            <div class="appointment-number">
                                <span>Appointment Number</span>
                                <strong><%= appointmentNumber %></strong>
                            </div>
                        <% } %>
                        <% if (emailMessage != null) { %>
                            <p class="email-status">
                                <i class="bi bi-envelope-check"></i>
                                <span><%= emailMessage %></span>
                            </p>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <!-- ERROR MESSAGE -->
            <% if (errorMessage != null) { %>
                <div class="message error-message" role="alert">
                    <div class="message-icon">
                        <i class="bi bi-exclamation-circle-fill"></i>
                    </div>
                    <div class="message-content">
                        <strong>Unable to Book Appointment</strong>
                        <p><%= errorMessage %></p>
                    </div>
                </div>
            <% } %>

            <!-- BOOKING FORM -->
            <form action="<%= contextPath %>/reception/book-appointment" method="post" class="booking-form" id="bookingForm" autocomplete="off">

                <div class="booking-main-grid">

                    <!-- LEFT COLUMN: FORM STEPS -->
                    <div class="booking-steps-column">

                        <!-- STEP 1: PATIENT -->
                        <section class="form-section">
                            <div class="section-title">
                                <div class="step-number">1</div>
                                <div class="section-heading">
                                    <h3>Patient Information</h3>
                                    <p>Search and select the registered patient for this appointment.</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="patientSearch">Patient <span class="required" aria-hidden="true">*</span></label>

                                <div class="search-select" id="patientSearchSelect">
                                    <div class="search-input-wrapper">
                                        <i class="bi bi-search search-icon" aria-hidden="true"></i>
                                        <input type="text" id="patientSearch" placeholder="Search by patient name, number, contact or email..." autocomplete="off" aria-label="Search patient" aria-controls="patientResults" aria-expanded="false">
                                        <button type="button" class="search-toggle" id="patientSearchToggle" aria-label="Show patients" tabindex="-1">
                                            <i class="bi bi-chevron-down search-arrow"></i>
                                        </button>
                                    </div>

                                    <div class="search-results" id="patientResults" role="listbox" aria-label="Patient search results">
                                        <% for (Patient patient : patients) { %>
                                            <div class="search-result patient-result" role="option" tabindex="0"
                                                data-id="<%= patient.getPatientId() %>"
                                                data-name="<%= patient.getName() != null ? patient.getName() : "" %>"
                                                data-number="<%= patient.getPatientNumber() != null ? patient.getPatientNumber() : "" %>"
                                                data-email="<%= patient.getEmail() != null ? patient.getEmail() : "" %>"
                                                data-contact="<%= patient.getContactNumber() != null ? patient.getContactNumber() : "" %>"
                                                data-search="<%= ((patient.getPatientNumber() != null ? patient.getPatientNumber() : "") + " " + (patient.getName() != null ? patient.getName() : "") + " " + (patient.getContactNumber() != null ? patient.getContactNumber() : "") + " " + (patient.getEmail() != null ? patient.getEmail() : "")).toLowerCase() %>">
                                                <div class="result-icon">
                                                    <i class="bi bi-person"></i>
                                                </div>
                                                <div class="result-information">
                                                    <strong>
                                                        <%= patient.getPatientNumber() != null ? patient.getPatientNumber() : "No patient number" %>
                                                        <span class="result-separator">-</span>
                                                        <%= patient.getName() != null ? patient.getName() : "Unnamed Patient" %>
                                                    </strong>
                                                    <span class="result-details">
                                                        <%= patient.getContactNumber() != null && !patient.getContactNumber().isBlank() ? patient.getContactNumber() : "No contact" %>
                                                        <% if (patient.getEmail() != null && !patient.getEmail().isBlank()) { %>
                                                            <span class="result-dot">•</span>
                                                            <%= patient.getEmail() %>
                                                        <% } %>
                                                    </span>
                                                </div>
                                            </div>
                                        <% } %>

                                        <% if (patients.isEmpty()) { %>
                                            <div class="no-results">
                                                <i class="bi bi-person-x"></i>
                                                <span>No active patients found.</span>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>

                                <input type="hidden" id="patientId" name="patientId" value="">
                                <small class="form-help">
                                    <i class="bi bi-info-circle"></i>
                                    Search by patient name, patient number (#PAT-xxx), phone, or email.
                                </small>
                            </div>

                            <!-- SELECTED PATIENT BADGE -->
                            <div class="selected-record" id="selectedPatient" aria-live="polite">
                                <div class="selected-record-icon">
                                    <i class="bi bi-person-check"></i>
                                </div>
                                <div class="selected-record-info">
                                    <span>Selected Patient</span>
                                    <strong id="selectedPatientName">No patient selected</strong>
                                </div>
                                <button type="button" class="clear-selection" id="clearPatient" aria-label="Clear selected patient" title="Clear patient">
                                    <i class="bi bi-x"></i>
                                </button>
                            </div>

                            <!-- PATIENT PREVIEW -->
                            <div class="patient-preview" id="patientPreview">
                                <div class="preview-item">
                                    <i class="bi bi-envelope"></i>
                                    <div>
                                        <span>Email</span>
                                        <strong id="patientEmail">-</strong>
                                    </div>
                                </div>
                                <div class="preview-item">
                                    <i class="bi bi-telephone"></i>
                                    <div>
                                        <span>Contact Number</span>
                                        <strong id="patientContact">-</strong>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- STEP 2: DENTIST -->
                        <section class="form-section">
                            <div class="section-title">
                                <div class="step-number">2</div>
                                <div class="section-heading">
                                    <h3>Dentist Specialist</h3>
                                    <p>Select the attending doctor for this consultation.</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="dentistSearch">Dentist <span class="required" aria-hidden="true">*</span></label>

                                <div class="search-select" id="dentistSearchSelect">
                                    <div class="search-input-wrapper">
                                        <i class="bi bi-search search-icon" aria-hidden="true"></i>
                                        <input type="text" id="dentistSearch" placeholder="Search doctor by name, number or specialization..." autocomplete="off" aria-label="Search dentist" aria-controls="dentistResults" aria-expanded="false">
                                        <button type="button" class="search-toggle" id="dentistSearchToggle" aria-label="Show dentists" tabindex="-1">
                                            <i class="bi bi-chevron-down search-arrow"></i>
                                        </button>
                                    </div>

                                    <div class="search-results" id="dentistResults" role="listbox" aria-label="Dentist search results">
                                        <% for (Dentist dentist : dentists) { %>
                                            <div class="search-result dentist-result" role="option" tabindex="0"
                                                data-id="<%= dentist.getDentistId() %>"
                                                data-name="<%= dentist.getName() != null ? dentist.getName() : "" %>"
                                                data-number="<%= dentist.getDentistNumber() != null ? dentist.getDentistNumber() : "" %>"
                                                data-room="<%= dentist.getRoomNumber() != null ? dentist.getRoomNumber() : "" %>"
                                                data-specialization="<%= dentist.getSpecialization() != null ? dentist.getSpecialization() : "" %>"
                                                data-search="<%= ((dentist.getDentistNumber() != null ? dentist.getDentistNumber() : "") + " " + (dentist.getName() != null ? dentist.getName() : "") + " " + (dentist.getRoomNumber() != null ? dentist.getRoomNumber() : "") + " " + (dentist.getSpecialization() != null ? dentist.getSpecialization() : "")).toLowerCase() %>">
                                                <div class="result-icon dentist-result-icon">
                                                    <i class="bi bi-person-badge"></i>
                                                </div>
                                                <div class="result-information">
                                                    <strong><%= dentist.getName() != null ? dentist.getName() : "Dentist" %></strong>
                                                    <span class="result-details">
                                                        <%= dentist.getDentistNumber() != null ? dentist.getDentistNumber() : "" %>
                                                        <% if (dentist.getRoomNumber() != null && !dentist.getRoomNumber().isBlank()) { %>
                                                            <span class="result-dot">•</span>
                                                            <i class="bi bi-door-open"></i> Room <%= dentist.getRoomNumber() %>
                                                        <% } %>
                                                        <% if (dentist.getSpecialization() != null && !dentist.getSpecialization().isBlank()) { %>
                                                            <span class="result-dot">•</span>
                                                            <%= dentist.getSpecialization() %>
                                                        <% } %>
                                                    </span>
                                                </div>
                                            </div>
                                        <% } %>

                                        <% if (dentists.isEmpty()) { %>
                                            <div class="no-results">
                                                <i class="bi bi-person-x"></i>
                                                <span>No active dentists found.</span>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>

                                <input type="hidden" id="dentistId" name="dentistId" value="">
                                <small class="form-help">
                                    <i class="bi bi-info-circle"></i>
                                    Filter doctor by name, specialization, or assigned clinical room.
                                </small>
                            </div>

                            <!-- SELECTED DENTIST BADGE -->
                            <div class="selected-record" id="selectedDentist" aria-live="polite">
                                <div class="selected-record-icon">
                                    <i class="bi bi-person-check"></i>
                                </div>
                                <div class="selected-record-info">
                                    <span>Selected Dentist</span>
                                    <strong id="selectedDentistName">No dentist selected</strong>
                                    <span id="selectedDentistRoom">Room not assigned</span>
                                </div>
                                <button type="button" class="clear-selection" id="clearDentist" aria-label="Clear selected dentist" title="Clear dentist">
                                    <i class="bi bi-x"></i>
                                </button>
                            </div>
                        </section>

                        <!-- STEP 3: DATE & TIME SLOTS -->
                        <section class="form-section">
                            <div class="section-title">
                                <div class="step-number">3</div>
                                <div class="section-heading">
                                    <h3>Appointment Schedule</h3>
                                    <p>Select consultation date and an available 30-minute time slot.</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="appointmentDate">Date <span class="required" aria-hidden="true">*</span></label>
                                <div class="date-input-wrapper">
                                    <i class="bi bi-calendar3"></i>
                                    <input type="date" id="appointmentDate" name="appointmentDate" required>
                                </div>
                                <small class="form-help">
                                    <i class="bi bi-info-circle"></i>
                                    Available working windows are queried automatically upon selecting doctor and date.
                                </small>
                            </div>

                            <!-- AVAILABILITY STATUS & TIME SLOTS -->
                            <div class="form-group" style="margin-top: 15px;">
                                <label>Available Time Slot <span class="required" aria-hidden="true">*</span></label>
                                <div class="availability-message" id="availabilityMessage" role="status" aria-live="polite">
                                    <i class="bi bi-info-circle"></i>
                                    <span>Select a dentist and date to view available times.</span>
                                </div>

                                <div class="time-slots" id="timeSlots" aria-live="polite"></div>

                                <input type="hidden" id="availabilityId" name="availabilityId" value="">
                                <input type="hidden" id="startTime" name="startTime" value="">
                                <input type="hidden" id="endTime" name="endTime" value="">
                            </div>
                        </section>

                        <!-- STEP 4: REASON & TREATMENT -->
                        <section class="form-section">
                            <div class="section-title">
                                <div class="step-number">4</div>
                                <div class="section-heading">
                                    <h3>Treatment Details</h3>
                                    <p>Specify the required dental procedure or appointment reason.</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="reason">Reason for Visit / Treatment <span class="required" aria-hidden="true">*</span></label>
                                <select id="reason" name="reason" required>
                                    <option value="">-- Select Appointment Reason --</option>
                                    <% for (TreatmentType treatmentType : treatmentTypes) { %>
                                        <option value="<%= treatmentType.getTreatmentName() %>">
                                            <%= treatmentType.getTreatmentName() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="form-group other-reason-group" id="otherReasonGroup" style="display: none;">
                                <label for="otherReason">Specify Details <span class="required" id="otherReasonRequired" aria-hidden="true">*</span></label>
                                <textarea id="otherReason" name="otherReason" rows="3" placeholder="Enter specific symptoms or treatment details..." maxlength="500"></textarea>
                            </div>
                        </section>

                    </div>

                    <!-- RIGHT COLUMN: SUMMARY & SUBMIT -->
                    <div class="booking-summary-sticky">

                        <div class="summary-card">
                            <div class="summary-header-box">
                                <div class="summary-icon-box">
                                    <i class="bi bi-clipboard2-check"></i>
                                </div>
                                <div>
                                    <h3>Booking Summary</h3>
                                    <p>Review booking details before confirming</p>
                                </div>
                            </div>

                            <div class="summary-list">
                                <div class="summary-row">
                                    <span>Patient</span>
                                    <strong id="summaryPatient">Not selected</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Dentist</span>
                                    <strong id="summaryDentist">Not selected</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Date</span>
                                    <strong id="summaryDate">Not selected</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Time Slot</span>
                                    <strong id="summaryTime">Not selected</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Reason</span>
                                    <strong id="summaryReason">Not selected</strong>
                                </div>
                            </div>

                            <!-- VALIDATION ERROR MESSAGE -->
                            <div class="form-validation-message" id="formValidationMessage" role="alert" aria-live="assertive" style="display: none; padding: 10px 14px; border-radius: 9px; font-size: 12.5px; background: #feecee; color: #c92a2a; margin-bottom: 15px;">
                                <i class="bi bi-exclamation-circle"></i>
                                <span id="formValidationText"></span>
                            </div>

                            <!-- ACTIONS -->
                            <div style="display: flex; flex-direction: column; gap: 10px;">
                                <button type="submit" class="btn-primary" id="bookButton" style="width: 100%; justify-content: center; height: 46px; font-size: 14px; font-weight: 600;">
                                    <i class="bi bi-calendar-check-fill"></i> Confirm & Book Appointment
                                </button>
                                <a href="<%= contextPath %>/reception/dashboard" class="cancel-btn" style="width: 100%; justify-content: center; text-align: center; box-sizing: border-box; height: 42px;">
                                    <i class="bi bi-x-lg"></i> Cancel
                                </a>
                            </div>
                        </div>

                    </div>

                </div>

            </form>

        </section>

    </main>

</div>

<!-- JAVASCRIPT LOGIC -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    const bookingForm = document.getElementById("bookingForm");
    const patientSearch = document.getElementById("patientSearch");
    const patientId = document.getElementById("patientId");
    const patientResults = document.getElementById("patientResults");
    const patientSearchSelect = document.getElementById("patientSearchSelect");
    const patientSearchToggle = document.getElementById("patientSearchToggle");
    const selectedPatient = document.getElementById("selectedPatient");
    const selectedPatientName = document.getElementById("selectedPatientName");
    const patientEmail = document.getElementById("patientEmail");
    const patientContact = document.getElementById("patientContact");
    const patientPreview = document.getElementById("patientPreview");
    const clearPatient = document.getElementById("clearPatient");

    const dentistSearch = document.getElementById("dentistSearch");
    const dentistId = document.getElementById("dentistId");
    const dentistResults = document.getElementById("dentistResults");
    const dentistSearchSelect = document.getElementById("dentistSearchSelect");
    const dentistSearchToggle = document.getElementById("dentistSearchToggle");
    const selectedDentist = document.getElementById("selectedDentist");
    const selectedDentistName = document.getElementById("selectedDentistName");
    const selectedDentistRoom = document.getElementById("selectedDentistRoom");
    const clearDentist = document.getElementById("clearDentist");

    const appointmentDate = document.getElementById("appointmentDate");
    const availabilityMessage = document.getElementById("availabilityMessage");
    const timeSlots = document.getElementById("timeSlots");
    const availabilityId = document.getElementById("availabilityId");
    const startTime = document.getElementById("startTime");
    const endTime = document.getElementById("endTime");

    const reasonSelect = document.getElementById("reason");
    const otherReason = document.getElementById("otherReason");
    const otherReasonGroup = document.getElementById("otherReasonGroup");

    const summaryPatient = document.getElementById("summaryPatient");
    const summaryDentist = document.getElementById("summaryDentist");
    const summaryDate = document.getElementById("summaryDate");
    const summaryTime = document.getElementById("summaryTime");
    const summaryReason = document.getElementById("summaryReason");

    const formValidationMessage = document.getElementById("formValidationMessage");
    const formValidationText = document.getElementById("formValidationText");
    const bookButton = document.getElementById("bookButton");

    const contextPath = "<%= contextPath %>";
    let availabilityRequestNumber = 0;

    /* SET MIN DATE TO TODAY */
    const today = new Date().toISOString().split("T")[0];
    appointmentDate.min = today;
    if (!appointmentDate.value) {
        appointmentDate.value = today;
    }

    /* TIME FORMATTER */
    function formatTime(timeValue) {
        if (!timeValue) return "";
        const parts = timeValue.split(":");
        if (parts.length < 2) return timeValue;
        let hours = parseInt(parts[0], 10);
        const minutes = parts[1];
        if (Number.isNaN(hours)) return timeValue;
        const period = hours >= 12 ? "PM" : "AM";
        hours = hours % 12;
        if (hours === 0) hours = 12;
        const formattedHours = hours < 10 ? "0" + hours : String(hours);
        return formattedHours + ":" + minutes + " " + period;
    }

    /* SEARCH FILTER UTILS */
    function setupSearchDropdown(input, toggle, selectContainer, resultsContainer, onSelectCallback) {
        function openDropdown() {
            closeAllDropdowns();
            selectContainer.classList.add("active");
            input.setAttribute("aria-expanded", "true");
        }

        function closeDropdown() {
            selectContainer.classList.remove("active");
            input.setAttribute("aria-expanded", "false");
        }

        input.addEventListener("focus", openDropdown);
        if (toggle) {
            toggle.addEventListener("click", function (e) {
                e.stopPropagation();
                if (selectContainer.classList.contains("active")) {
                    closeDropdown();
                } else {
                    openDropdown();
                    input.focus();
                }
            });
        }

        input.addEventListener("input", function () {
            const query = input.value.toLowerCase().trim();
            const items = resultsContainer.querySelectorAll(".search-result");

            items.forEach(function (item) {
                const searchData = item.dataset.search || "";
                if (!query || searchData.includes(query)) {
                    item.style.display = "flex";
                } else {
                    item.style.display = "none";
                }
            });

            openDropdown();
        });

        resultsContainer.addEventListener("click", function (e) {
            const resultItem = e.target.closest(".search-result");
            if (!resultItem) return;
            onSelectCallback(resultItem);
            closeDropdown();
            updateSummary();
        });
    }

    function closeAllDropdowns() {
        if (patientSearchSelect) patientSearchSelect.classList.remove("active");
        if (dentistSearchSelect) dentistSearchSelect.classList.remove("active");
    }

    document.addEventListener("click", function (e) {
        if (!e.target.closest(".search-select")) {
            closeAllDropdowns();
        }
    });

    /* PATIENT HANDLER */
    setupSearchDropdown(patientSearch, patientSearchToggle, patientSearchSelect, patientResults, function (item) {
        const id = item.dataset.id;
        const name = item.dataset.name;
        const num = item.dataset.number;
        const email = item.dataset.email || "Not provided";
        const contact = item.dataset.contact || "Not provided";

        patientId.value = id;
        patientSearch.value = num ? (num + " - " + name) : name;
        selectedPatientName.textContent = num ? (num + " - " + name) : name;
        patientEmail.textContent = email;
        patientContact.textContent = contact;

        selectedPatient.classList.add("visible");
        patientPreview.classList.add("visible");
    });

    if (clearPatient) {
        clearPatient.addEventListener("click", function () {
            patientId.value = "";
            patientSearch.value = "";
            selectedPatient.classList.remove("visible");
            patientPreview.classList.remove("visible");
            updateSummary();
        });
    }

    /* DENTIST HANDLER */
    setupSearchDropdown(dentistSearch, dentistSearchToggle, dentistSearchSelect, dentistResults, function (item) {
        const id = item.dataset.id;
        const name = item.dataset.name;
        const room = item.dataset.room;
        const spec = item.dataset.specialization;

        dentistId.value = id;
        dentistSearch.value = " " + name;
        selectedDentistName.textContent = " " + name;
        selectedDentistRoom.textContent = room ? ("Room " + room + " (" + spec + ")") : spec;

        selectedDentist.classList.add("visible");
        loadAvailability();
    });

    if (clearDentist) {
        clearDentist.addEventListener("click", function () {
            dentistId.value = "";
            dentistSearch.value = "";
            selectedDentist.classList.remove("visible");
            clearAvailability();
            updateSummary();
        });
    }

    appointmentDate.addEventListener("change", function () {
        loadAvailability();
        updateSummary();
    });

    function setAvailabilityMessage(type, iconClass, text) {
        availabilityMessage.className = "availability-message " + type;
        availabilityMessage.innerHTML = '<i class="bi ' + iconClass + '"></i><span>' + text + '</span>';
        availabilityMessage.style.display = "flex";
    }

    function clearAvailability() {
        timeSlots.innerHTML = "";
        availabilityId.value = "";
        startTime.value = "";
        endTime.value = "";
        setAvailabilityMessage("info", "bi-info-circle", "Select a dentist and date to view available times.");
    }

    /* LOAD AVAILABILITY & RENDER TIME SLOTS (AVAILABLE, BOOKED IN RED, PAST IN GRAY) */
    function loadAvailability() {
        if (!dentistId.value || !appointmentDate.value) {
            clearAvailability();
            return;
        }

        availabilityRequestNumber++;
        const reqNum = availabilityRequestNumber;
        setAvailabilityMessage("loading", "bi-arrow-repeat loading-icon", "Checking dentist availability...");
        timeSlots.innerHTML = "";

        const url = contextPath + "/reception/dentist-availability?dentistId=" + encodeURIComponent(dentistId.value) + "&date=" + encodeURIComponent(appointmentDate.value) + "&ajax=true";

        fetch(url, {
            method: "GET",
            headers: { "Accept": "application/json" },
            cache: "no-store"
        })
        .then(res => {
            if (!res.ok) throw new Error("Server returned HTTP " + res.status);
            return res.json();
        })
        .then(data => {
            if (reqNum !== availabilityRequestNumber) return;

            let availabilityData = data;
            if (!Array.isArray(availabilityData) && data && Array.isArray(data.availability)) {
                availabilityData = data.availability;
            } else if (!Array.isArray(availabilityData) && data && Array.isArray(data.data)) {
                availabilityData = data.data;
            }

            if (!Array.isArray(availabilityData) || availabilityData.length === 0) {
                setAvailabilityMessage("warning", "bi-calendar-x", "No working schedule found for this dentist on the selected date.");
                return;
            }

            availabilityMessage.style.display = "none";
            timeSlots.innerHTML = "";

            let availableCount = 0;

            availabilityData.forEach(slot => {
                if (!slot || !slot.startTime || !slot.endTime) return;

                const isFull = (slot.full === true) || (slot.remainingCapacity !== undefined && slot.remainingCapacity <= 0);
                const isPast = slot.past === true;
                const isAvailable = !isFull && !isPast;

                if (isAvailable) availableCount++;

                const startFormatted = formatTime(slot.startTime);
                const endFormatted = formatTime(slot.endTime);

                const btn = document.createElement("button");
                btn.type = "button";
                btn.className = "time-slot";

                if (isFull) {
                    /* Booked Slot - Red and Disabled */
                    btn.classList.add("booked", "full");
                    btn.disabled = true;
                    btn.setAttribute("title", "This slot is already booked");
                    btn.innerHTML = '<i class="bi bi-x-circle-fill"></i>' +
                        '<span class="time-slot-content">' +
                            '<strong>' + startFormatted + ' - ' + endFormatted + '</strong>' +
                            '<small><i class="bi bi-lock-fill"></i> Booked</small>' +
                        '</span>';
                } else if (isPast) {
                    /* Past Slot - Gray and Disabled */
                    btn.classList.add("past");
                    btn.disabled = true;
                    btn.setAttribute("title", "This time slot has already passed");
                    btn.innerHTML = '<i class="bi bi-clock-history"></i>' +
                        '<span class="time-slot-content">' +
                            '<strong>' + startFormatted + ' - ' + endFormatted + '</strong>' +
                            '<small>Time Passed</small>' +
                        '</span>';
                } else {
                    /* Available Slot - Interactive Teal */
                    btn.innerHTML = '<i class="bi bi-clock"></i>' +
                        '<span class="time-slot-content">' +
                            '<strong>' + startFormatted + ' - ' + endFormatted + '</strong>' +
                            '<small><i class="bi bi-check-circle-fill"></i> Available</small>' +
                        '</span>';

                    btn.addEventListener("click", function () {
                        document.querySelectorAll(".time-slot").forEach(b => b.classList.remove("selected"));
                        btn.classList.add("selected");
                        availabilityId.value = slot.availabilityId || "";
                        startTime.value = slot.startTime;
                        endTime.value = slot.endTime;
                        updateSummary();
                    });
                }

                timeSlots.appendChild(btn);
            });

            if (availableCount === 0 && availabilityData.length > 0) {
                setAvailabilityMessage("warning", "bi-exclamation-triangle", "All appointment slots are fully booked for this date.");
            }
        })
        .catch(err => {
            if (reqNum !== availabilityRequestNumber) return;
            console.error("Availability loading error:", err);
            setAvailabilityMessage("error", "bi-exclamation-circle", "Unable to load dentist schedule. Please check connection.");
        });
    }

    /* REASON & SUMMARY */
    reasonSelect.addEventListener("change", function () {
        if (reasonSelect.value === "Other") {
            otherReasonGroup.style.display = "block";
            otherReason.required = true;
        } else {
            otherReasonGroup.style.display = "none";
            otherReason.required = false;
        }
        updateSummary();
    });

    if (otherReason) {
        otherReason.addEventListener("input", updateSummary);
    }

    function updateSummary() {
        summaryPatient.textContent = selectedPatientName.textContent || "Not selected";
        summaryDentist.textContent = selectedDentistName.textContent || "Not selected";
        summaryDate.textContent = appointmentDate.value || "Not selected";
        summaryTime.textContent = (startTime.value && endTime.value) ? (formatTime(startTime.value) + " - " + formatTime(endTime.value)) : "Not selected";
        
        let r = reasonSelect.value || "Not selected";
        if (r === "Other" && otherReason.value.trim()) {
            r = "Other: " + otherReason.value.trim();
        }
        summaryReason.textContent = r;
    }

    function showFormError(msg) {
        formValidationText.textContent = msg;
        formValidationMessage.style.display = "flex";
        formValidationMessage.scrollIntoView({ behavior: "smooth", block: "center" });
    }

    let isBookingConfirmed = false;

    bookingForm.addEventListener("submit", function (e) {
        formValidationMessage.style.display = "none";

        if (!patientId.value) {
            e.preventDefault();
            showFormError("Please select a patient.");
            patientSearch.focus();
            return;
        }
        if (!dentistId.value) {
            e.preventDefault();
            showFormError("Please select a dentist.");
            dentistSearch.focus();
            return;
        }
        if (!appointmentDate.value) {
            e.preventDefault();
            showFormError("Please select an appointment date.");
            appointmentDate.focus();
            return;
        }
        if (!availabilityId.value || !startTime.value || !endTime.value) {
            e.preventDefault();
            showFormError("Please select an available time slot.");
            return;
        }
        if (!reasonSelect.value) {
            e.preventDefault();
            showFormError("Please select a reason for the appointment.");
            reasonSelect.focus();
            return;
        }
        if (reasonSelect.value === "Other" && !otherReason.value.trim()) {
            e.preventDefault();
            showFormError("Please specify the appointment reason.");
            otherReason.focus();
            return;
        }

        if (!isBookingConfirmed) {
            e.preventDefault();
            const pName = (selectedPatientName && selectedPatientName.textContent.trim()) ? selectedPatientName.textContent.trim() : (summaryPatient ? summaryPatient.textContent.trim() : "Patient");
            const dName = (selectedDentistName && selectedDentistName.textContent.trim()) ? selectedDentistName.textContent.trim() : (summaryDentist ? summaryDentist.textContent.trim() : "Dentist");
            const aDate = (summaryDate && summaryDate.textContent.trim() !== "Not selected") ? summaryDate.textContent.trim() : appointmentDate.value;
            const aTime = (summaryTime && summaryTime.textContent.trim() !== "Not selected") ? summaryTime.textContent.trim() : "Selected Slot";

            if (typeof window.showConfirmDialog === "function") {
                window.showConfirmDialog({
                    title: "Confirm Appointment Booking",
                    message: "Book appointment for <strong>" + pName + "</strong> with <strong>" + dName + "</strong> on <strong>" + aDate + "</strong> (" + aTime + ")?",
                    confirmBtnText: "Yes, Book Appointment",
                    cancelBtnText: "Review Details",
                    isDanger: false,
                    onConfirm: function() {
                        isBookingConfirmed = true;
                        bookingForm.submit();
                    }
                });
            } else {
                if (confirm("Book appointment for " + pName + " with " + dName + " on " + aDate + "?")) {
                    isBookingConfirmed = true;
                    bookingForm.submit();
                }
            }
        }
    });

    updateSummary();
});
</script>

<script src="<%= contextPath %>/js/notifications.js"></script>

</body>
</html>