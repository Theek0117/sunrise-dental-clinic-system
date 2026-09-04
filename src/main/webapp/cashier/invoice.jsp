<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrise.dental.model.Payment" %>
<%@ page import="com.sunrise.dental.model.PaymentAdditionalCharge" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>

<%
    String contextPath = request.getContextPath();

    Payment payment = (Payment) request.getAttribute("payment");
    List<PaymentAdditionalCharge> additionalCharges = (List<PaymentAdditionalCharge>) request.getAttribute("additionalCharges");
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Patient patient = (Patient) request.getAttribute("patient");
    Dentist dentist = (Dentist) request.getAttribute("dentist");
    TreatmentType treatmentType = (TreatmentType) request.getAttribute("treatmentType");

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    if (flashSuccess != null) {
        session.removeAttribute("flashSuccess");
    }

    String flashError = (String) session.getAttribute("flashError");
    if (flashError != null) {
        session.removeAttribute("flashError");
    }

    if (payment == null) {
        response.sendRedirect(contextPath + "/cashier/billing");
        return;
    }

    String patientName = (patient != null && patient.getName() != null) ? patient.getName() : (payment.getPatientName() != null ? payment.getPatientName() : "Patient #" + payment.getPatientId());
    String patientEmail = (patient != null && patient.getEmail() != null) ? patient.getEmail() : (payment.getPatientEmail() != null ? payment.getPatientEmail() : "N/A");
    String patientContact = (patient != null && patient.getContactNumber() != null) ? patient.getContactNumber() : (payment.getPatientContact() != null ? payment.getPatientContact() : "N/A");
    String rawDentist = (dentist != null && dentist.getName() != null) ? dentist.getName().trim() : (payment.getDentistName() != null ? payment.getDentistName().trim() : ("Dentist #" + (appointment != null ? appointment.getDentistId() : "")));
    String dentistLabel = "Dr. " + rawDentist.replaceAll("^(?i)dr\\.?\\s*", "").trim();
    String dentistSpec = (dentist != null && dentist.getSpecialization() != null) ? dentist.getSpecialization() : "Dental Surgeon";

    String treatmentName = (treatmentType != null && treatmentType.getTreatmentName() != null) ? treatmentType.getTreatmentName() : (payment.getTreatmentName() != null ? payment.getTreatmentName() : "Dental Procedure");
    String appointmentNo = (appointment != null && appointment.getAppointmentNumber() != null) ? appointment.getAppointmentNumber() : (payment.getAppointmentNumber() != null ? payment.getAppointmentNumber() : "APT-" + payment.getAppointmentId());

    BigDecimal basic = payment.getBasicAmount();
    BigDecimal doctorFee = payment.getDoctorFee();
    BigDecimal additional = payment.getAdditionalAmount();
    BigDecimal subtotal = basic.add(doctorFee).add(additional);
    BigDecimal tax = payment.getTaxAmount();
    BigDecimal total = payment.getTotalAmount();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice <%= payment.getInvoiceNumber() %> | Sunrise Dental Clinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">

    <style>
        .invoice-wrapper {
            max-width: 820px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            border: 1px solid #eef2f5;
            padding: 40px;
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding-bottom: 25px;
            border-bottom: 2px solid #f1f5f9;
        }

        .clinic-brand-invoice {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .clinic-brand-invoice img {
            width: 48px;
            height: 48px;
            object-fit: contain;
        }

        .clinic-brand-invoice h2 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: #0ea5b4;
        }

        .clinic-brand-invoice span {
            font-size: 11.5px;
            color: #64748b;
            display: block;
        }

        .invoice-meta-box {
            text-align: right;
        }

        .invoice-meta-box h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
        }

        .invoice-badge-paid {
            display: inline-block;
            background: #dcfce7;
            color: #15803d;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            margin-top: 5px;
            letter-spacing: 0.5px;
        }

        .info-columns-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin: 25px 0;
            padding: 20px;
            background: #f8fafc;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
        }

        .info-col h4 {
            margin: 0 0 8px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
        }

        .info-col p {
            margin: 0 0 4px;
            font-size: 13.5px;
            color: #334155;
        }

        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
        }

        .invoice-table th {
            text-align: left;
            padding: 12px 14px;
            background: #f1f5f9;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            border-radius: 6px;
        }

        .invoice-table td {
            padding: 14px;
            font-size: 13.5px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        .invoice-totals {
            margin-left: auto;
            max-width: 320px;
            margin-top: 15px;
        }

        .totals-row {
            display: flex;
            justify-content: space-between;
            padding: 7px 0;
            font-size: 13.5px;
            color: #475569;
        }

        .totals-grand {
            border-top: 2px solid #0ea5b4;
            padding-top: 10px;
            margin-top: 8px;
            font-size: 17px;
            font-weight: 800;
            color: #0f172a;
        }

        .action-bar-invoice {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn-act {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 20px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: 0.2s;
        }

        .btn-print { background: #0ea5b4; color: #fff; }
        .btn-print:hover { background: #087f8c; color: #fff; }

        .btn-email { background: #0284c7; color: #fff; }
        .btn-email:hover { background: #0369a1; color: #fff; }

        .btn-back-inv { background: #e2e8f0; color: #334155; }
        .btn-back-inv:hover { background: #cbd5e1; }

        @media print {
            body {
                background: #ffffff !important;
                color: #000000 !important;
            }
            .sidebar, .topbar, .action-bar-invoice, .alert {
                display: none !important;
            }
            .main-content {
                margin: 0 !important;
                padding: 0 !important;
                width: 100% !important;
            }
            .invoice-wrapper {
                box-shadow: none !important;
                border: none !important;
                padding: 0 !important;
                max-width: 100% !important;
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
                <a href="<%= contextPath %>/cashier/payments" class="back-link" style="width:38px; height:38px; border-radius:10px; background:#e0f2fe; color:#0369a1; display:flex; align-items:center; justify-content:center; text-decoration:none;">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div class="topbar-title">
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Payment Receipt & Soft Copy</h1>
                    <span style="font-size: 12px; color: #64748b;">Official tax invoice for payment #<%= payment.getInvoiceNumber() %></span>
                </div>
            </div>
        </header>

        <div class="content-body" style="padding: 24px;">

            <% if (flashSuccess != null) { %>
                <div class="alert alert-success" style="max-width:820px; margin:0 auto 20px; background:#dcfce7; border:1px solid #bbf7d0; color:#15803d; padding:12px 18px; border-radius:12px; display:flex; align-items:center; gap:10px;">
                    <i class="bi bi-check-circle-fill"></i>
                    <span><%= flashSuccess %></span>
                </div>
            <% } %>

            <% if (flashError != null) { %>
                <div class="alert alert-error" style="max-width:820px; margin:0 auto 20px; background:#fff1f2; border:1px solid #fecdd3; color:#e11d48; padding:12px 18px; border-radius:12px; display:flex; align-items:center; gap:10px;">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span><%= flashError %></span>
                </div>
            <% } %>

            <div class="invoice-wrapper">

                <!-- INVOICE HEADER -->
                <div class="invoice-header">
                    <div class="clinic-brand-invoice">
                        <img src="<%= contextPath %>/images/logo1.png" alt="Logo">
                        <div>
                            <h2>Sunrise Dental Clinic</h2>
                            <span>Modern Dental Care & Implant Center</span>
                            <span>123 Health Ave, Colombo 03 | +94 11 234 5678</span>
                        </div>
                    </div>
                    <div class="invoice-meta-box">
                        <h1><%= payment.getInvoiceNumber() %></h1>
                        <span class="invoice-badge-paid"><i class="bi bi-check2"></i> PAID (<%= payment.getPaymentMethod() %>)</span>
                        <p style="margin: 6px 0 0; font-size: 12px; color: #64748b;">
                            Date: <%= payment.getCreatedAt() != null ? payment.getCreatedAt() : "N/A" %>
                        </p>
                    </div>
                </div>

                <!-- INFO GRID -->
                <div class="info-columns-grid">
                    <div class="info-col">
                        <h4>Billed To (Patient)</h4>
                        <p><strong><%= patientName %></strong></p>
                        <p><i class="bi bi-person-badge"></i> Patient ID: #<%= payment.getPatientId() %></p>
                        <p><i class="bi bi-envelope"></i> <%= patientEmail %></p>
                        <p><i class="bi bi-telephone"></i> <%= patientContact %></p>
                    </div>
                    <div class="info-col">
                        <h4>Appointment Details</h4>
                        <p><strong><%= appointmentNo %></strong></p>
                        <p><i class="bi bi-person-heart"></i> Attending: <%= dentistLabel %></p>
                        <p><i class="bi bi-award"></i> <%= dentistSpec %></p>
                        <p><i class="bi bi-bandaid"></i> <%= treatmentName %></p>
                    </div>
                </div>

                <!-- CHARGES TABLE -->
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th style="width: 50%;">Description / Procedure</th>
                            <th style="text-align: center;">Category</th>
                            <th style="text-align: right; width: 25%;">Amount (Rs.)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong><%= treatmentName %></strong>
                                <span style="display:block; font-size:12px; color:#64748b;">Standard Treatment Base Procedure Fee</span>
                            </td>
                            <td style="text-align: center; color:#0ea5b4; font-weight:600;">Base Procedure</td>
                            <td style="text-align: right; font-weight:600;">Rs. <%= String.format("%.2f", basic) %></td>
                        </tr>

                        <% if (doctorFee.compareTo(BigDecimal.ZERO) > 0) { %>
                        <tr>
                            <td>
                                <strong>Doctor Consultation & Specialist Fee</strong>
                                <span style="display:block; font-size:12px; color:#64748b;">Attending Doctor Clinical Fee</span>
                            </td>
                            <td style="text-align: center; color:#0ea5b4; font-weight:600;">Doctor Fee</td>
                            <td style="text-align: right; font-weight:600;">Rs. <%= String.format("%.2f", doctorFee) %></td>
                        </tr>
                        <% } %>

                        <% if (additionalCharges != null && !additionalCharges.isEmpty()) {
                            for (PaymentAdditionalCharge charge : additionalCharges) { %>
                            <tr>
                                <td>
                                    <strong><%= charge.getChargeName() %></strong>
                                </td>
                                <td style="text-align: center; color:#64748b;">Additional Item</td>
                                <td style="text-align: right; font-weight:600;">Rs. <%= String.format("%.2f", charge.getAmount()) %></td>
                            </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>

                <!-- TOTALS SECTION -->
                <div class="invoice-totals">
                    <div class="totals-row">
                        <span>Base Treatment</span>
                        <span>Rs. <%= String.format("%.2f", basic) %></span>
                    </div>
                    <% if (doctorFee.compareTo(BigDecimal.ZERO) > 0) { %>
                    <div class="totals-row">
                        <span>Doctor Fee</span>
                        <span>Rs. <%= String.format("%.2f", doctorFee) %></span>
                    </div>
                    <% } %>
                    <% if (additional.compareTo(BigDecimal.ZERO) > 0) { %>
                    <div class="totals-row">
                        <span>Additional Charges</span>
                        <span>Rs. <%= String.format("%.2f", additional) %></span>
                    </div>
                    <% } %>
                    <div class="totals-row" style="font-weight: 600; border-top: 1px dashed #e2e8f0; padding-top: 8px;">
                        <span>Subtotal</span>
                        <span>Rs. <%= String.format("%.2f", subtotal) %></span>
                    </div>
                    <div class="totals-row" style="color: #0369a1; font-weight: 600;">
                        <span>Government Tax (5%)</span>
                        <span>Rs. <%= String.format("%.2f", tax) %></span>
                    </div>
                    <div class="totals-row totals-grand">
                        <span>Total Paid</span>
                        <span style="color: #0ea5b4;">Rs. <%= String.format("%.2f", total) %></span>
                    </div>
                </div>

                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #f1f5f9; text-align: center; font-size: 12px; color: #94a3b8;">
                    <p style="margin: 0;">Thank you for trusting Sunrise Dental Clinic. For inquiries, please call +94 11 234 5678 or email billing@sunrisedental.com.</p>
                </div>

            </div>

            <!-- ACTION BAR -->
            <div class="action-bar-invoice">
                <button type="button" onclick="window.print()" class="btn-act btn-print">
                    <i class="bi bi-printer-fill"></i> Print Soft Copy / PDF
                </button>

                <form action="<%= contextPath %>/cashier/send-invoice-email" method="POST" style="display:inline;">
                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                    <button type="submit" class="btn-act btn-email" <%= (patientEmail.equals("N/A") || patientEmail.isBlank()) ? "disabled title='No email available'" : "" %>>
                        <i class="bi bi-envelope-paper-fill"></i> Send Invoice to Patient Email
                    </button>
                </form>

                <a href="<%= contextPath %>/cashier/billing" class="btn-act btn-back-inv">
                    <i class="bi bi-receipt"></i> Back to Billing
                </a>

                <a href="<%= contextPath %>/cashier/dashboard" class="btn-act btn-back-inv">
                    <i class="bi bi-house-door-fill"></i> Dashboard
                </a>
            </div>

        </div>
    </main>
</div>

</body>
</html>
