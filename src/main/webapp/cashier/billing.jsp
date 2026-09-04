<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>

<%
    String contextPath = request.getContextPath();
    String staffName = (String) request.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Cashier";
    }

    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    Map<Integer, Patient> patients = (Map<Integer, Patient>) request.getAttribute("patients");
    Map<Integer, Dentist> dentists = (Map<Integer, Dentist>) request.getAttribute("dentists");
    Map<Integer, TreatmentType> treatmentTypes = (Map<Integer, TreatmentType>) request.getAttribute("treatmentTypes");

    String searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) {
        searchQuery = "";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing & Invoice Desk | Sunrise Dental Clinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">

    <style>
        .search-hero-bar {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
        }

        .search-input-box {
            position: relative;
            flex: 1;
            max-width: 500px;
        }

        .search-input-box i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 16px;
        }

        .search-input-box input {
            width: 100%;
            padding: 12px 14px 12px 42px;
            border: 1.5px solid #d2e4ea;
            border-radius: 12px;
            font-size: 13.5px;
            outline: none;
            transition: 0.2s;
        }

        .search-input-box input:focus {
            border-color: #0ea5b4;
            box-shadow: 0 0 0 3px rgba(14, 165, 180, 0.15);
        }

        .btn-search {
            padding: 12px 20px;
            background: #0ea5b4;
            color: #ffffff;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .btn-search:hover { background: #087f8c; }

        .billing-table-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            overflow-x: auto;
            border: 1px solid #e2e8f0;
        }

        .table-custom {
            width: 100%;
            min-width: 1050px;
            border-collapse: collapse;
        }

        .table-custom th {
            padding: 16px 20px;
            text-align: left;
            font-size: 11.5px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            white-space: nowrap;
        }

        .table-custom td {
            padding: 18px 20px;
            font-size: 13.5px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            white-space: nowrap;
        }

        .table-custom tr:hover td {
            background: #f8fafc;
        }

        .btn-gen-bill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 10px;
            background: #0ea5b4;
            color: #ffffff;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.2s;
            box-shadow: 0 4px 12px rgba(14, 165, 180, 0.25);
        }

        .btn-gen-bill:hover {
            background: #087f8c;
            transform: translateY(-1px);
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
            <a href="<%= contextPath %>/cashier/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a href="<%= contextPath %>/cashier/billing" class="nav-item active">
                <i class="bi bi-receipt-cutoff"></i>
                <span>Billing</span>
            </a>
            <a href="<%= contextPath %>/cashier/payments" class="nav-item">
                <i class="bi bi-credit-card-fill"></i>
                <span>Payments</span>
            </a>

            <p class="navigation-title clinic-title">CLINIC</p>
            <a href="<%= contextPath %>/cashier/appointments" class="nav-item">
                <i class="bi bi-calendar2-week"></i>
                <span>Appointments</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="<%= contextPath %>/cashier/profile" class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>
            <a href="<%= contextPath %>/cashier/helpdesk.jsp" class="nav-item">
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
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Billing & Invoice Desk</h1>
                    <span style="font-size: 12px; color: #64748b;">Search by Appointment ID or select a completed appointment to generate a bill</span>
                </div>
            </div>
            <div class="topbar-right">
                <div class="user-profile-badge" style="display:flex; align-items:center; gap:10px;">
                    <div style="width:38px; height:38px; border-radius:50%; background:#0ea5b4; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700;">CC</div>
                    <div>
                        <strong style="display:block; font-size:13px;"><%= staffName %></strong>
                        <span style="font-size:11px; color:#64748b;">Clinic Cashier</span>
                    </div>
                </div>
            </div>
        </header>

        <div class="content-body" style="padding: 24px;">

            <!-- SEARCH HERO BAR -->
            <form action="<%= contextPath %>/cashier/billing" method="GET" class="search-hero-bar">
                <div class="search-input-box">
                    <i class="bi bi-search"></i>
                    <input type="text" name="search" value="<%= searchQuery %>" placeholder="Search by Appointment # (e.g. A000004), Patient Name, or ID...">
                </div>
                <button type="submit" class="btn-search">
                    <i class="bi bi-filter"></i> Search Appointments
                </button>
                <% if (!searchQuery.isEmpty()) { %>
                    <a href="<%= contextPath %>/cashier/billing" style="color:#64748b; font-size:13px; text-decoration:none;">
                        <i class="bi bi-x-circle"></i> Clear Filter
                    </a>
                <% } %>
            </form>

            <!-- COMPLETED APPOINTMENTS TABLE -->
            <div class="billing-table-card">
                <div style="padding: 20px 24px; border-bottom: 1px solid #e2e8f0; display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <h3 style="margin:0; font-size:16px; font-weight:700; color:#0f172a;">Completed Appointments Ready for Billing</h3>
                        <p style="margin:2px 0 0; font-size:12px; color:#64748b;">Select an appointment to compute doctor fees, additional items, and 5% tax.</p>
                    </div>
                    <span style="background:#f0fdfa; color:#0f766e; font-size:12px; font-weight:700; padding:6px 12px; border-radius:8px;">
                        <%= appointments != null ? appointments.size() : 0 %> Records
                    </span>
                </div>

                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Appointment #</th>
                            <th>Patient</th>
                            <th>Dentist</th>
                            <th>Treatment</th>
                            <th>Base Cost</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (appointments != null && !appointments.isEmpty()) {
                                for (Appointment app : appointments) {
                                    String appNo = (app.getAppointmentNumber() != null && !app.getAppointmentNumber().isBlank())
                                            ? app.getAppointmentNumber() : "APT-" + app.getAppointmentId();

                                    Patient p = (patients != null) ? patients.get(app.getPatientId()) : null;
                                    String pName = (p != null && p.getName() != null) ? p.getName() : "Patient #" + app.getPatientId();

                                    Dentist d = (dentists != null) ? dentists.get(app.getDentistId()) : null;
                                    String rawDName = (d != null && d.getName() != null) ? d.getName().trim() : ("#" + app.getDentistId());
                                    String dentistLabel = "Dr. " + rawDName.replaceAll("^(?i)dr\\.?\\s*", "").trim();

                                    TreatmentType tt = (treatmentTypes != null) ? treatmentTypes.get(app.getAppointmentId()) : null;
                                    String treatName = (tt != null && tt.getTreatmentName() != null) ? tt.getTreatmentName() : "General Treatment";
                                    BigDecimal cost = (tt != null && tt.getBasicCost() != null) ? tt.getBasicCost() : BigDecimal.ZERO;
                        %>
                        <tr>
                            <td><strong style="color:#0f172a;"><%= appNo %></strong></td>
                            <td>
                                <div style="display:flex; align-items:center; gap:8px;">
                                    <div style="width:32px; height:32px; border-radius:8px; background:#e0f2fe; color:#0369a1; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:12px;">
                                        P
                                    </div>
                                    <div>
                                        <strong style="display:block; font-size:13px; color:#1e293b;"><%= pName %></strong>
                                        <span style="font-size:11px; color:#94a3b8;">ID: #<%= app.getPatientId() %></span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span style="color:#0ea5b4; font-weight:600;"><%= dentistLabel %></span>
                            </td>
                            <td><%= treatName %></td>
                            <td><strong>Rs. <%= String.format("%.2f", cost) %></strong></td>
                            <td><%= app.getAppointmentDate() %></td>
                            <td>
                                <span style="background:#dcfce7; color:#15803d; padding:4px 10px; border-radius:20px; font-size:11.5px; font-weight:600;">
                                    <i class="bi bi-circle-fill" style="font-size:8px;"></i> Completed
                                </span>
                            </td>
                            <td>
                                <a href="<%= contextPath %>/cashier/generate-bill?appointmentId=<%= app.getAppointmentId() %>" class="btn-gen-bill">
                                    <i class="bi bi-receipt"></i> Generate Bill
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="8" style="text-align:center; padding: 50px 20px; color:#94a3b8;">
                                <i class="bi bi-inbox" style="font-size:38px; display:block; margin-bottom:10px;"></i>
                                <strong style="display:block; font-size:15px; color:#475569;">No completed appointments found</strong>
                                <span>All completed appointments have either been billed or no records match your search.</span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

        </div>
    </main>

</div>

<script src="<%= contextPath %>/js/notifications.js"></script>
</body>
</html>
