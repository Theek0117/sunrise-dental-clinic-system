<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.sunrise.dental.model.Payment" %>

<%
    String contextPath = request.getContextPath();
    String staffName = (String) request.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Cashier";
    }

    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    if (totalRevenue == null) {
        totalRevenue = BigDecimal.ZERO;
    }

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
    <title>Payments & Receipts History | Sunrise Dental Clinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">

    <style>
        .stats-overview-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 24px;
        }

        .stat-card-custom {
            background: #ffffff;
            border-radius: 18px;
            padding: 22px 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .stat-icon-custom {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

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
            overflow: hidden;
        }

        .table-custom {
            width: 100%;
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
        }

        .table-custom td {
            padding: 16px 20px;
            font-size: 13.5px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .table-custom tr:hover td {
            background: #f8fafc;
        }

        .btn-view-invoice {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 10px;
            background: #e0f2fe;
            color: #0284c7;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.2s;
        }

        .btn-view-invoice:hover {
            background: #0284c7;
            color: #ffffff;
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
            <a href="<%= contextPath %>/cashier/billing" class="nav-item">
                <i class="bi bi-receipt-cutoff"></i>
                <span>Billing</span>
            </a>
            <a href="<%= contextPath %>/cashier/payments" class="nav-item active">
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
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Payment History & Invoices</h1>
                    <span style="font-size: 12px; color: #64748b;">View and print soft copies of all issued patient bills</span>
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

            <!-- STATS OVERVIEW -->
            <div class="stats-overview-grid">
                <div class="stat-card-custom">
                    <div class="stat-icon-custom" style="background:#f0fdfa; color:#0d9488;">
                        <i class="bi bi-receipt"></i>
                    </div>
                    <div>
                        <span style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase;">Total Invoices</span>
                        <h3 style="margin:2px 0 0; font-size:22px; font-weight:800; color:#0f172a;"><%= payments != null ? payments.size() : 0 %></h3>
                    </div>
                </div>

                <div class="stat-card-custom">
                    <div class="stat-icon-custom" style="background:#f0fdf4; color:#16a34a;">
                        <i class="bi bi-cash-coin"></i>
                    </div>
                    <div>
                        <span style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase;">Total Revenue</span>
                        <h3 style="margin:2px 0 0; font-size:22px; font-weight:800; color:#16a34a;">Rs. <%= String.format("%.2f", totalRevenue) %></h3>
                    </div>
                </div>

                <div class="stat-card-custom">
                    <div class="stat-icon-custom" style="background:#eff6ff; color:#2563eb;">
                        <i class="bi bi-check-all"></i>
                    </div>
                    <div>
                        <span style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase;">Status</span>
                        <h3 style="margin:2px 0 0; font-size:22px; font-weight:800; color:#2563eb;">100% Settled</h3>
                    </div>
                </div>
            </div>

            <!-- SEARCH BAR -->
            <form action="<%= contextPath %>/cashier/payments" method="GET" class="search-hero-bar">
                <div class="search-input-box">
                    <i class="bi bi-search"></i>
                    <input type="text" name="search" value="<%= searchQuery %>" placeholder="Search by Invoice # (e.g. INV000001), Appointment #, Patient...">
                </div>
                <button type="submit" class="btn-search">
                    <i class="bi bi-filter"></i> Search Invoices
                </button>
                <% if (!searchQuery.isEmpty()) { %>
                    <a href="<%= contextPath %>/cashier/payments" style="color:#64748b; font-size:13px; text-decoration:none;">
                        <i class="bi bi-x-circle"></i> Clear Filter
                    </a>
                <% } %>
            </form>

            <!-- PAYMENTS TABLE -->
            <div class="billing-table-card">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Invoice #</th>
                            <th>App #</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Treatment</th>
                            <th>Doctor Fee</th>
                            <th>5% Tax</th>
                            <th>Total (Rs.)</th>
                            <th>Method</th>
                            <th>Paid At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (payments != null && !payments.isEmpty()) {
                                for (Payment p : payments) {
                        %>
                        <tr>
                            <td><strong style="color:#0ea5b4;"><%= p.getInvoiceNumber() %></strong></td>
                            <td><span style="font-weight:600; color:#334155;"><%= p.getAppointmentNumber() != null ? p.getAppointmentNumber() : "-" %></span></td>
                            <td>
                                <div>
                                    <strong style="display:block; font-size:13px; color:#1e293b;"><%= p.getPatientName() != null ? p.getPatientName() : "Patient #" + p.getPatientId() %></strong>
                                    <span style="font-size:11px; color:#94a3b8;"><%= p.getPatientContact() != null ? p.getPatientContact() : "" %></span>
                                </div>
                            </td>
                            <td><span style="color:#0f766e; font-weight:500;">Dr. <%= p.getDentistName() != null ? p.getDentistName() : "-" %></span></td>
                            <td><%= p.getTreatmentName() != null ? p.getTreatmentName() : "Dental Service" %></td>
                            <td>Rs. <%= String.format("%.2f", p.getDoctorFee() != null ? p.getDoctorFee() : BigDecimal.ZERO) %></td>
                            <td style="color:#0284c7; font-weight:600;">Rs. <%= String.format("%.2f", p.getTaxAmount() != null ? p.getTaxAmount() : BigDecimal.ZERO) %></td>
                            <td><strong style="color:#0f172a; font-size:14px;">Rs. <%= String.format("%.2f", p.getTotalAmount() != null ? p.getTotalAmount() : BigDecimal.ZERO) %></strong></td>
                            <td>
                                <span style="background:#f1f5f9; color:#475569; padding:4px 8px; border-radius:6px; font-size:11px; font-weight:700;">
                                    <%= p.getPaymentMethod() %>
                                </span>
                            </td>
                            <td style="font-size:12px; color:#64748b;"><%= p.getPaidAt() != null ? p.getPaidAt() : p.getCreatedAt() %></td>
                            <td>
                                <a href="<%= contextPath %>/cashier/invoice?paymentId=<%= p.getPaymentId() %>" class="btn-view-invoice">
                                    <i class="bi bi-file-earmark-pdf"></i> View & Print
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="11" style="text-align:center; padding: 50px 20px; color:#94a3b8;">
                                <i class="bi bi-credit-card-2-front" style="font-size:38px; display:block; margin-bottom:10px;"></i>
                                <strong style="display:block; font-size:15px; color:#475569;">No payment records found</strong>
                                <span>No payment transactions have been logged yet or no records match your query.</span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

        </div>
    </main>

</div>

</body>
</html>
