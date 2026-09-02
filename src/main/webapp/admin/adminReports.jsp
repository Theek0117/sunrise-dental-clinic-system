<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Payment" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>
<%@ page import="com.sunrise.dental.controller.AdminReportsServlet.DoctorAnalytics" %>
<%@ page import="com.sunrise.dental.controller.AdminReportsServlet.TreatmentAnalytics" %>

<%
    String contextPath = request.getContextPath();
    String staffName = (String) request.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }

    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) activeTab = "analytics";

    String period = (String) request.getAttribute("period");
    if (period == null) period = "all";

    String periodLabel = (String) request.getAttribute("periodLabel");
    String startDateStr = (String) request.getAttribute("startDateStr");
    String endDateStr = (String) request.getAttribute("endDateStr");
    Integer filterDentistId = (Integer) request.getAttribute("filterDentistId");
    if (filterDentistId == null) filterDentistId = 0;

    String statusFilter = (String) request.getAttribute("statusFilter");
    if (statusFilter == null) statusFilter = "all";

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    List<Dentist> activeDentists = (List<Dentist>) request.getAttribute("activeDentists");

    Map<Integer, Patient> patientMap = (Map<Integer, Patient>) request.getAttribute("patientMap");
    Map<Integer, Dentist> dentistMap = (Map<Integer, Dentist>) request.getAttribute("dentistMap");
    Map<Integer, TreatmentType> treatmentTypeMap = (Map<Integer, TreatmentType>) request.getAttribute("treatmentTypeMap");

    BigDecimal totalGrossRevenue = (BigDecimal) request.getAttribute("totalGrossRevenue");
    BigDecimal totalBasicRevenue = (BigDecimal) request.getAttribute("totalBasicRevenue");
    BigDecimal totalDoctorFees = (BigDecimal) request.getAttribute("totalDoctorFees");
    BigDecimal totalTaxAmount = (BigDecimal) request.getAttribute("totalTaxAmount");
    BigDecimal totalAdditionalCharges = (BigDecimal) request.getAttribute("totalAdditionalCharges");

    Integer totalPatientsCount = (Integer) request.getAttribute("totalPatientsCount");
    Integer totalAppointmentsCount = (Integer) request.getAttribute("totalAppointmentsCount");
    Integer completedCount = (Integer) request.getAttribute("completedCount");
    Integer confirmedCount = (Integer) request.getAttribute("confirmedCount");
    Integer cancelledCount = (Integer) request.getAttribute("cancelledCount");

    Map<String, Integer> methodCount = (Map<String, Integer>) request.getAttribute("methodCount");
    Map<String, BigDecimal> methodAmount = (Map<String, BigDecimal>) request.getAttribute("methodAmount");
    List<DoctorAnalytics> doctorAnalyticsList = (List<DoctorAnalytics>) request.getAttribute("doctorAnalyticsList");
    List<TreatmentAnalytics> treatmentAnalyticsList = (List<TreatmentAnalytics>) request.getAttribute("treatmentAnalyticsList");

    if (totalGrossRevenue == null) totalGrossRevenue = BigDecimal.ZERO;
    if (totalDoctorFees == null) totalDoctorFees = BigDecimal.ZERO;
    if (totalTaxAmount == null) totalTaxAmount = BigDecimal.ZERO;
    if (totalAdditionalCharges == null) totalAdditionalCharges = BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Reports & Analytics | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">

    <style>
        .filter-control-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 20px 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            margin-bottom: 24px;
            border: 1px solid #edf2f7;
        }

        .filter-period-pills {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 18px;
            padding-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
        }

        .period-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            color: #64748b;
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            transition: 0.2s;
        }

        .period-pill:hover {
            border-color: #0ea5b4;
            color: #0ea5b4;
        }

        .period-pill.active {
            background: #0ea5b4;
            color: #ffffff;
            border-color: #0ea5b4;
            box-shadow: 0 4px 12px rgba(14, 165, 180, 0.25);
        }

        .filter-form-row {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .filter-input-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .filter-input-group label {
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filter-input-group input, .filter-input-group select {
            padding: 8px 14px;
            border: 1.5px solid #d2e4ea;
            border-radius: 10px;
            font-size: 13px;
            outline: none;
            background: #ffffff;
            transition: 0.2s;
            height: 38px;
            box-sizing: border-box;
        }

        .filter-input-group input:focus, .filter-input-group select:focus {
            border-color: #0ea5b4;
            box-shadow: 0 0 0 3px rgba(14, 165, 180, 0.15);
        }

        .btn-apply-filter {
            background: #0ea5b4;
            color: #ffffff;
            border: none;
            padding: 9px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 18px;
            transition: 0.2s;
        }

        .btn-apply-filter:hover { background: #087f8c; }

        .btn-reset-filter {
            color: #64748b;
            text-decoration: none;
            font-size: 13px;
            margin-top: 18px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-reset-filter:hover { color: #0f172a; }

        .reports-main-nav {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            background: #ffffff;
            padding: 8px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05);
            width: fit-content;
            flex-wrap: wrap;
        }

        .report-nav-item {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            font-weight: 600;
            text-decoration: none;
            color: #64748b;
            transition: 0.2s;
        }

        .report-nav-item.active {
            background: #0ea5b4;
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(14, 165, 180, 0.3);
        }

        .report-nav-item:hover:not(.active) {
            background: #f1f5f9;
            color: #0f172a;
        }

        .kpi-grid-4 {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 26px;
        }

        .kpi-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 22px 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            gap: 16px;
            border: 1px solid #eef2f5;
        }

        .kpi-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }

        .kpi-content span {
            display: block;
            font-size: 11.5px;
            color: #64748b;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .kpi-content strong {
            display: block;
            font-size: 20px;
            font-weight: 800;
            color: #0f172a;
            margin-top: 3px;
        }

        .report-section-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            padding: 26px;
            margin-bottom: 28px;
            border: 1px solid #eef2f5;
        }

        .section-heading-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f1f5f9;
        }

        .section-heading-flex h3 {
            margin: 0;
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-heading-flex p {
            margin: 3px 0 0;
            font-size: 12px;
            color: #64748b;
        }

        .custom-report-table {
            width: 100%;
            border-collapse: collapse;
        }

        .custom-report-table th {
            padding: 14px 16px;
            text-align: left;
            font-size: 11.5px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .custom-report-table td {
            padding: 14px 16px;
            font-size: 13px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .custom-report-table tr:hover td {
            background: #f8fafc;
        }

        .btn-view-soft-bill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            background: #0ea5b4;
            color: #ffffff;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.2s;
        }

        .btn-view-soft-bill:hover {
            background: #087f8c;
            transform: translateY(-1px);
        }

        .progress-bar-wrap {
            width: 100%;
            height: 7px;
            background: #e2e8f0;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 5px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #0ea5b4, #087f8c);
            border-radius: 10px;
        }

        .channels-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-top: 10px;
        }

        .channel-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 18px;
            text-align: center;
        }

        .channel-box i {
            font-size: 26px;
            color: #0ea5b4;
            display: block;
            margin-bottom: 8px;
        }

        .channel-box h4 {
            margin: 0 0 4px;
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
        }

        .channel-box span {
            font-size: 12px;
            color: #64748b;
            display: block;
        }

        .channel-box strong {
            font-size: 16px;
            color: #0ea5b4;
            display: block;
            margin-top: 6px;
        }

        .btn-print-report {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #0ea5b4;
            color: #ffffff;
            border: none;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 13.5px;
            cursor: pointer;
            transition: 0.2s;
            box-shadow: 0 4px 12px rgba(14, 165, 180, 0.25);
        }

        .btn-print-report:hover { background: #087f8c; }

        @media (max-width: 1024px) {
            .kpi-grid-4 { grid-template-columns: 1fr 1fr; }
        }

        @media (max-width: 640px) {
            .kpi-grid-4 { grid-template-columns: 1fr; }
        }

        @media print {
            body { background: #ffffff !important; color: #000 !important; }
            .sidebar, .topbar, .filter-control-card, .reports-main-nav, .btn-print-report, .btn-view-soft-bill { display: none !important; }
            .main-content { margin: 0 !important; padding: 0 !important; width: 100% !important; }
            .report-section-card { box-shadow: none !important; border: 1px solid #ccc !important; page-break-inside: avoid; }
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
            <a href="<%= contextPath %>/admin/dashboard" class="nav-item">
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
            <a href="<%= contextPath %>/admin/reports" class="nav-item active">
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

    <!-- MAIN CONTENT -->
    <main class="main-content">
        <header class="topbar">
            <div class="topbar-left">
                <div class="topbar-title">
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Clinic Reports & Financial Analytics</h1>
                    <span style="font-size: 12px; color: #64748b;">Filtering: <strong><%= periodLabel %></strong></span>
                </div>
            </div>
            <div class="topbar-right">
                <button type="button" onclick="window.print()" class="btn-print-report">
                    <i class="bi bi-printer-fill"></i> Print / Export Report
                </button>
            </div>
        </header>

        <div class="content-body" style="padding: 24px;">

            <!-- ========================================================= -->
            <!-- PERIOD & TIME RANGE FILTER CONTROL -->
            <!-- ========================================================= -->
            <div class="filter-control-card">
                <!-- QUICK PERIOD PILLS -->
                <div class="filter-period-pills">
                    <span style="font-size:12px; font-weight:700; color:#64748b; text-transform:uppercase; margin-right:6px;">Time Range:</span>
                    <a href="<%= contextPath %>/admin/reports?tab=<%= activeTab %>&period=all" class="period-pill <%= "all".equalsIgnoreCase(period) ? "active" : "" %>">
                        <i class="bi bi-infinity"></i> All Time
                    </a>
                    <a href="<%= contextPath %>/admin/reports?tab=<%= activeTab %>&period=today" class="period-pill <%= "today".equalsIgnoreCase(period) ? "active" : "" %>">
                        <i class="bi bi-calendar-event"></i> Today (Daily)
                    </a>
                    <a href="<%= contextPath %>/admin/reports?tab=<%= activeTab %>&period=this_month" class="period-pill <%= "this_month".equalsIgnoreCase(period) ? "active" : "" %>">
                        <i class="bi bi-calendar-month"></i> This Month
                    </a>
                    <a href="<%= contextPath %>/admin/reports?tab=<%= activeTab %>&period=this_year" class="period-pill <%= "this_year".equalsIgnoreCase(period) ? "active" : "" %>">
                        <i class="bi bi-calendar-year"></i> This Year (Annual)
                    </a>
                </div>

                <!-- CUSTOM FILTER FORM -->
                <form action="<%= contextPath %>/admin/reports" method="GET" class="filter-form-row">
                    <input type="hidden" name="tab" value="<%= activeTab %>">
                    <input type="hidden" name="period" value="custom">

                    <div class="filter-input-group">
                        <label>Start Date</label>
                        <input type="date" name="startDate" value="<%= startDateStr %>">
                    </div>

                    <div class="filter-input-group">
                        <label>End Date</label>
                        <input type="date" name="endDate" value="<%= endDateStr %>">
                    </div>

                    <div class="filter-input-group">
                        <label>Attending Doctor</label>
                        <select name="dentistId">
                            <option value="0">All Doctors</option>
                            <%
                                if (activeDentists != null) {
                                    for (Dentist d : activeDentists) {
                            %>
                                <option value="<%= d.getDentistId() %>" <%= filterDentistId == d.getDentistId() ? "selected" : "" %>>
                                    Dr. <%= d.getName() %> (<%= d.getSpecialization() %>)
                                </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <% if ("appointments".equals(activeTab)) { %>
                    <div class="filter-input-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>All Statuses</option>
                            <option value="COMPLETED" <%= "COMPLETED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Completed</option>
                            <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Confirmed</option>
                            <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Cancelled</option>
                        </select>
                    </div>
                    <% } %>

                    <button type="submit" class="btn-apply-filter">
                        <i class="bi bi-funnel-fill"></i> Filter Data
                    </button>

                    <% if (!"all".equalsIgnoreCase(period) || filterDentistId > 0) { %>
                        <a href="<%= contextPath %>/admin/reports?tab=<%= activeTab %>&period=all" class="btn-reset-filter">
                            <i class="bi bi-x-circle"></i> Reset Filter
                        </a>
                    <% } %>
                </form>
            </div>

            <!-- ========================================================= -->
            <!-- MAIN REPORT CATEGORY TABS -->
            <!-- ========================================================= -->
            <div class="reports-main-nav">
                <a href="<%= contextPath %>/admin/reports?tab=analytics&period=<%= period %>&startDate=<%= startDateStr %>&endDate=<%= endDateStr %>&dentistId=<%= filterDentistId %>" class="report-nav-item <%= "analytics".equals(activeTab) ? "active" : "" %>">
                    <i class="bi bi-graph-up-arrow"></i> Financial & Doctor Fees Analytics
                </a>
                <a href="<%= contextPath %>/admin/reports?tab=patients&period=<%= period %>" class="report-nav-item <%= "patients".equals(activeTab) ? "active" : "" %>">
                    <i class="bi bi-people-fill"></i> Patients List (<%= patients != null ? patients.size() : 0 %>)
                </a>
                <a href="<%= contextPath %>/admin/reports?tab=appointments&period=<%= period %>&startDate=<%= startDateStr %>&endDate=<%= endDateStr %>&dentistId=<%= filterDentistId %>" class="report-nav-item <%= "appointments".equals(activeTab) ? "active" : "" %>">
                    <i class="bi bi-calendar-check-fill"></i> Appointments List (<%= appointments != null ? appointments.size() : 0 %>)
                </a>
                <a href="<%= contextPath %>/admin/reports?tab=payments&period=<%= period %>&startDate=<%= startDateStr %>&endDate=<%= endDateStr %>&dentistId=<%= filterDentistId %>" class="report-nav-item <%= "payments".equals(activeTab) ? "active" : "" %>">
                    <i class="bi bi-receipt-cutoff"></i> Payment Invoices & Bills (<%= payments != null ? payments.size() : 0 %>)
                </a>
            </div>

            <!-- ========================================================= -->
            <!-- TAB 1: FINANCIAL & DOCTOR FEES ANALYTICS -->
            <!-- ========================================================= -->
            <% if ("analytics".equals(activeTab)) { %>

            <!-- KPI SUMMARY CARDS (DYNAMIC FOR FILTERED PERIOD) -->
            <div class="kpi-grid-4">
                <div class="kpi-card">
                    <div class="kpi-icon" style="background:#f0fdf4; color:#16a34a;">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                    <div class="kpi-content">
                        <span>Gross Revenue</span>
                        <strong style="color:#16a34a;">Rs. <%= String.format("%.2f", totalGrossRevenue) %></strong>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon" style="background:#f0fdfa; color:#0d9488;">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <div class="kpi-content">
                        <span>Total Doctor Fees</span>
                        <strong style="color:#0ea5b4;">Rs. <%= String.format("%.2f", totalDoctorFees) %></strong>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon" style="background:#eff6ff; color:#2563eb;">
                        <i class="bi bi-percent"></i>
                    </div>
                    <div class="kpi-content">
                        <span>5% Tax Collected</span>
                        <strong style="color:#2563eb;">Rs. <%= String.format("%.2f", totalTaxAmount) %></strong>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon" style="background:#fefce8; color:#ca8a04;">
                        <i class="bi bi-capsule"></i>
                    </div>
                    <div class="kpi-content">
                        <span>Extra Medications / Items</span>
                        <strong style="color:#ca8a04;">Rs. <%= String.format("%.2f", totalAdditionalCharges) %></strong>
                    </div>
                </div>
            </div>

            <!-- DOCTOR PERFORMANCE & FEES TABLE -->
            <div class="report-section-card">
                <div class="section-heading-flex">
                    <div>
                        <h3><i class="bi bi-person-check-fill" style="color:#0ea5b4;"></i> Doctor Consultation Fees & Revenue Performance (<%= periodLabel %>)</h3>
                        <p>Analysis of doctor consultation fees earned, completed appointments, and clinic revenue contribution.</p>
                    </div>
                </div>

                <table class="custom-report-table">
                    <thead>
                        <tr>
                            <th>Doctor / Specialist</th>
                            <th>Specialization</th>
                            <th>Appointments</th>
                            <th>Completed</th>
                            <th>Doctor Fee Earned (Rs.)</th>
                            <th>Total Revenue (Rs.)</th>
                            <th>Contribution %</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (doctorAnalyticsList != null && !doctorAnalyticsList.isEmpty()) {
                                for (DoctorAnalytics da : doctorAnalyticsList) {
                        %>
                        <tr>
                            <td><strong style="color:#0f172a;"><%= da.dentistName %></strong></td>
                            <td><span style="background:#e0f2fe; color:#0369a1; padding:3px 8px; border-radius:6px; font-size:11px; font-weight:600;"><%= da.specialization %></span></td>
                            <td><%= da.totalAppointments %></td>
                            <td><strong style="color:#16a34a;"><%= da.completedAppointments %></strong></td>
                            <td><strong style="color:#0ea5b4;">Rs. <%= String.format("%.2f", da.totalDoctorFees) %></strong></td>
                            <td><strong>Rs. <%= String.format("%.2f", da.totalRevenueGenerated) %></strong></td>
                            <td style="width: 160px;">
                                <div style="display:flex; align-items:center; gap:8px;">
                                    <span style="font-weight:700; font-size:12px;"><%= da.contributionPercentage %>%</span>
                                    <div class="progress-bar-wrap">
                                        <div class="progress-bar-fill" style="width: <%= da.contributionPercentage %>%;"></div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align:center; padding: 24px; color:#94a3b8;">No doctor performance records for the selected period.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- PROCEDURE & PAYMENT SPLIT -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">

                <!-- TREATMENT POPULARITY -->
                <div class="report-section-card" style="margin-bottom:0;">
                    <div class="section-heading-flex">
                        <div>
                            <h3><i class="bi bi-bandaid-fill" style="color:#0ea5b4;"></i> Procedure Revenue</h3>
                            <p>Revenue distribution across dental treatments for <%= periodLabel %>.</p>
                        </div>
                    </div>

                    <table class="custom-report-table">
                        <thead>
                            <tr>
                                <th>Treatment</th>
                                <th>Base Cost</th>
                                <th>Completed</th>
                                <th>Revenue (Rs.)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (treatmentAnalyticsList != null && !treatmentAnalyticsList.isEmpty()) {
                                    for (TreatmentAnalytics ta : treatmentAnalyticsList) {
                            %>
                            <tr>
                                <td><strong><%= ta.treatmentName %></strong></td>
                                <td>Rs. <%= String.format("%.2f", ta.baseCost) %></td>
                                <td><span style="background:#f0fdf4; color:#15803d; padding:2px 8px; border-radius:12px; font-weight:600;"><%= ta.timesCompleted %></span></td>
                                <td><strong style="color:#0f172a;">Rs. <%= String.format("%.2f", ta.totalRevenueGenerated) %></strong></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- PAYMENT CHANNELS -->
                <div class="report-section-card" style="margin-bottom:0;">
                    <div class="section-heading-flex">
                        <div>
                            <h3><i class="bi bi-credit-card-2-front-fill" style="color:#0ea5b4;"></i> Payment Method Split</h3>
                            <p>Transaction channels breakdown for <%= periodLabel %>.</p>
                        </div>
                    </div>

                    <div class="channels-grid">
                        <div class="channel-box">
                            <i class="bi bi-cash"></i>
                            <h4>Cash Payments</h4>
                            <span><%= methodCount != null ? methodCount.getOrDefault("CASH", 0) : 0 %> Invoices</span>
                            <strong>Rs. <%= String.format("%.2f", methodAmount != null ? methodAmount.getOrDefault("CASH", BigDecimal.ZERO) : BigDecimal.ZERO) %></strong>
                        </div>

                        <div class="channel-box">
                            <i class="bi bi-credit-card-2-front"></i>
                            <h4>Card POS</h4>
                            <span><%= methodCount != null ? methodCount.getOrDefault("CARD", 0) : 0 %> Invoices</span>
                            <strong>Rs. <%= String.format("%.2f", methodAmount != null ? methodAmount.getOrDefault("CARD", BigDecimal.ZERO) : BigDecimal.ZERO) %></strong>
                        </div>

                        <div class="channel-box">
                            <i class="bi bi-bank"></i>
                            <h4>Bank Transfer</h4>
                            <span><%= methodCount != null ? methodCount.getOrDefault("BANK_TRANSFER", 0) : 0 %> Invoices</span>
                            <strong>Rs. <%= String.format("%.2f", methodAmount != null ? methodAmount.getOrDefault("BANK_TRANSFER", BigDecimal.ZERO) : BigDecimal.ZERO) %></strong>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ========================================================= -->
            <!-- TAB 2: PATIENTS DIRECTORY -->
            <!-- ========================================================= -->
            <% } else if ("patients".equals(activeTab)) { %>

            <div class="report-section-card">
                <div class="section-heading-flex">
                    <div>
                        <h3><i class="bi bi-people-fill" style="color:#0ea5b4;"></i> Clinic Patients Master Directory</h3>
                        <p>Complete directory of all registered patients in the system.</p>
                    </div>
                    <span style="background:#e0f2fe; color:#0369a1; padding:4px 12px; border-radius:8px; font-weight:700; font-size:12px;">
                        <%= patients != null ? patients.size() : 0 %> Patients Registered
                    </span>
                </div>

                <table class="custom-report-table">
                    <thead>
                        <tr>
                            <th>Patient ID</th>
                            <th>Patient #</th>
                            <th>Full Name</th>
                            <th>Date of Birth</th>
                            <th>Contact Phone</th>
                            <th>Email Address</th>
                            <th>Address</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (patients != null && !patients.isEmpty()) {
                                for (Patient p : patients) {
                        %>
                        <tr>
                            <td>#<%= p.getPatientId() %></td>
                            <td><strong><%= p.getPatientNumber() != null ? p.getPatientNumber() : "-" %></strong></td>
                            <td><strong style="color:#0f172a;"><%= p.getName() %></strong></td>
                            <td><%= p.getDateOfBirth() != null ? p.getDateOfBirth().toString() : "-" %></td>
                            <td><%= p.getContactNumber() != null ? p.getContactNumber() : "-" %></td>
                            <td><%= p.getEmail() != null ? p.getEmail() : "-" %></td>
                            <td><%= p.getAddress() != null ? p.getAddress() : "-" %></td>
                            <td>
                                <span style="background:#dcfce7; color:#15803d; padding:3px 8px; border-radius:12px; font-size:11px; font-weight:600;">
                                    <%= p.getStatus() != null ? p.getStatus() : "ACTIVE" %>
                                </span>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="8" style="text-align:center; padding: 30px; color:#94a3b8;">No registered patients found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- ========================================================= -->
            <!-- TAB 3: APPOINTMENTS LIST -->
            <!-- ========================================================= -->
            <% } else if ("appointments".equals(activeTab)) { %>

            <div class="report-section-card">
                <div class="section-heading-flex">
                    <div>
                        <h3><i class="bi bi-calendar-check-fill" style="color:#0ea5b4;"></i> Appointments Roster (<%= periodLabel %>)</h3>
                        <p>Complete record of patient bookings, clinical consultations, and statuses.</p>
                    </div>
                    <div style="display:flex; gap:8px;">
                        <span style="background:#dcfce7; color:#15803d; padding:4px 10px; border-radius:8px; font-weight:700; font-size:11.5px;">
                            <%= completedCount %> Completed
                        </span>
                        <span style="background:#eff6ff; color:#2563eb; padding:4px 10px; border-radius:8px; font-weight:700; font-size:11.5px;">
                            <%= confirmedCount %> Confirmed
                        </span>
                        <span style="background:#fff1f2; color:#e11d48; padding:4px 10px; border-radius:8px; font-weight:700; font-size:11.5px;">
                            <%= cancelledCount %> Cancelled
                        </span>
                    </div>
                </div>

                <table class="custom-report-table">
                    <thead>
                        <tr>
                            <th>Appointment #</th>
                            <th>Patient</th>
                            <th>Attending Doctor</th>
                            <th>Treatment</th>
                            <th>Date</th>
                            <th>Time Slot</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (appointments != null && !appointments.isEmpty()) {
                                for (Appointment a : appointments) {
                                    Patient p = patientMap != null ? patientMap.get(a.getPatientId()) : null;
                                    Dentist d = dentistMap != null ? dentistMap.get(a.getDentistId()) : null;
                                    TreatmentType tt = treatmentTypeMap != null ? treatmentTypeMap.get(a.getTreatmentTypeId()) : null;

                                    String status = a.getStatus() != null ? a.getStatus().toUpperCase() : "SCHEDULED";
                                    String stBg = "#eff6ff"; String stColor = "#2563eb";
                                    if ("COMPLETED".equals(status)) { stBg = "#dcfce7"; stColor = "#15803d"; }
                                    else if ("CANCELLED".equals(status)) { stBg = "#fff1f2"; stColor = "#e11d48"; }
                        %>
                        <tr>
                            <td><strong style="color:#0f172a;"><%= a.getAppointmentNumber() != null ? a.getAppointmentNumber() : "APT-" + a.getAppointmentId() %></strong></td>
                            <td><%= p != null ? p.getName() : "Patient #" + a.getPatientId() %></td>
                            <td><span style="color:#0ea5b4; font-weight:600;">Dr. <%= d != null ? d.getName() : "#" + a.getDentistId() %></span></td>
                            <td><%= tt != null ? tt.getTreatmentName() : "General Treatment" %></td>
                            <td><%= a.getAppointmentDate() %></td>
                            <td><%= a.getStartTime() %> - <%= a.getEndTime() %></td>
                            <td>
                                <span style="background:<%= stBg %>; color:<%= stColor %>; padding:3px 8px; border-radius:12px; font-size:11px; font-weight:600;">
                                    <%= status %>
                                </span>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align:center; padding: 30px; color:#94a3b8;">No appointments found for the selected period / doctor filter.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- ========================================================= -->
            <!-- TAB 4: PAYMENT INVOICES & GENERATED BILLS -->
            <!-- ========================================================= -->
            <% } else if ("payments".equals(activeTab)) { %>

            <div class="report-section-card">
                <div class="section-heading-flex">
                    <div>
                        <h3><i class="bi bi-receipt-cutoff" style="color:#0ea5b4;"></i> Payment Invoices & Generated Bills (<%= periodLabel %>)</h3>
                        <p>Complete ledger of all generated bills with itemized doctor fees, 5% tax, and soft copy view.</p>
                    </div>
                    <span style="background:#fefce8; color:#ca8a04; padding:4px 12px; border-radius:8px; font-weight:700; font-size:12px;">
                        <%= payments != null ? payments.size() : 0 %> Invoices
                    </span>
                </div>

                <table class="custom-report-table">
                    <thead>
                        <tr>
                            <th>Invoice #</th>
                            <th>App #</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Base (Rs.)</th>
                            <th>Doc Fee (Rs.)</th>
                            <th>Tax 5% (Rs.)</th>
                            <th>Total (Rs.)</th>
                            <th>Method</th>
                            <th>Date Paid</th>
                            <th>Soft Copy</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (payments != null && !payments.isEmpty()) {
                                for (Payment pay : payments) {
                        %>
                        <tr>
                            <td><strong style="color:#0ea5b4;"><%= pay.getInvoiceNumber() %></strong></td>
                            <td><%= pay.getAppointmentNumber() != null ? pay.getAppointmentNumber() : "-" %></td>
                            <td><strong><%= pay.getPatientName() != null ? pay.getPatientName() : "Patient #" + pay.getPatientId() %></strong></td>
                            <td>Dr. <%= pay.getDentistName() != null ? pay.getDentistName() : "-" %></td>
                            <td>Rs. <%= String.format("%.2f", pay.getBasicAmount() != null ? pay.getBasicAmount() : BigDecimal.ZERO) %></td>
                            <td style="color:#0ea5b4; font-weight:600;">Rs. <%= String.format("%.2f", pay.getDoctorFee() != null ? pay.getDoctorFee() : BigDecimal.ZERO) %></td>
                            <td style="color:#2563eb;">Rs. <%= String.format("%.2f", pay.getTaxAmount() != null ? pay.getTaxAmount() : BigDecimal.ZERO) %></td>
                            <td><strong style="color:#16a34a; font-size:13.5px;">Rs. <%= String.format("%.2f", pay.getTotalAmount() != null ? pay.getTotalAmount() : BigDecimal.ZERO) %></strong></td>
                            <td><span style="background:#f1f5f9; padding:2px 6px; border-radius:6px; font-size:11px; font-weight:600;"><%= pay.getPaymentMethod() %></span></td>
                            <td style="font-size:11.5px; color:#64748b;"><%= pay.getPaidAt() != null ? pay.getPaidAt() : pay.getCreatedAt() %></td>
                            <td>
                                <a href="<%= contextPath %>/cashier/invoice?paymentId=<%= pay.getPaymentId() %>" target="_blank" class="btn-view-soft-bill">
                                    <i class="bi bi-file-earmark-pdf"></i> View Bill
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="11" style="text-align:center; padding: 30px; color:#94a3b8;">No payment invoices found for the selected period.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <% } %>

        </div>
    </main>

</div>

</body>
</html>
