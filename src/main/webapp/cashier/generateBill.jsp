<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>
<%@ page import="java.math.BigDecimal" %>

<%
    String contextPath = request.getContextPath();

    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Cashier";
    }

    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Patient patient = (Patient) request.getAttribute("patient");
    Dentist dentist = (Dentist) request.getAttribute("dentist");
    TreatmentType treatmentType = (TreatmentType) request.getAttribute("treatmentType");
    BigDecimal basicAmount = (BigDecimal) request.getAttribute("basicAmount");
    if (basicAmount == null) {
        basicAmount = BigDecimal.ZERO;
    }

    String error = (String) request.getAttribute("error");

    if (appointment == null) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Bill | Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <style>
        .error-page-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px;
        }
        .error-box-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 45px 35px;
            text-align: center;
            max-width: 480px;
            width: 100%;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
        }
        .error-icon-circle {
            width: 75px;
            height: 75px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: #fff1f2;
            color: #e11d48;
            font-size: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-return {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: #0ea5b4;
            color: #ffffff;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            margin-top: 20px;
            transition: 0.2s;
        }
        .btn-return:hover { background: #087f8c; color: #fff; }
    </style>
</head>
<body>
<div class="error-page-container">
    <div class="error-box-card">
        <div class="error-icon-circle">
            <i class="bi bi-exclamation-triangle-fill"></i>
        </div>
        <h2 style="font-size: 22px; font-weight: 700; color: #1e293b; margin-bottom: 8px;">Unable to Load Appointment</h2>
        <p style="color: #64748b; font-size: 14px; margin-bottom: 20px;">
            <%= error != null ? error : "The requested appointment for billing was not found or is not completed." %>
        </p>
        <a href="<%= contextPath %>/cashier/dashboard" class="btn-return">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>
</body>
</html>
<%
        return;
    }

    String patientName = (patient != null && patient.getName() != null) ? patient.getName() : "Patient #" + appointment.getPatientId();
    String patientEmail = (patient != null && patient.getEmail() != null) ? patient.getEmail() : "N/A";
    String patientContact = (patient != null && patient.getContactNumber() != null) ? patient.getContactNumber() : "N/A";
    String doctorName = (dentist != null && dentist.getName() != null) ? dentist.getName() : "Dentist #" + appointment.getDentistId();
    String doctorSpecialization = (dentist != null && dentist.getSpecialization() != null) ? dentist.getSpecialization() : "Dental Surgeon";
    String treatmentTitle = (treatmentType != null && treatmentType.getTreatmentName() != null) ? treatmentType.getTreatmentName() : "General Dental Treatment";
%>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Bill | <%= appointment.getAppointmentNumber() %> | Sunrise Dental Clinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">

    <style>
        .bill-workspace {
            display: grid;
            grid-template-columns: 1fr 390px;
            gap: 26px;
            align-items: start;
            margin-top: 22px;
        }

        .bill-form-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            border: 1px solid #eef3f6;
        }

        .patient-summary-banner {
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            border-radius: 16px;
            padding: 22px 26px;
            color: #ffffff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .patient-summary-banner h3 {
            margin: 0 0 4px;
            font-size: 20px;
            font-weight: 700;
        }

        .patient-summary-banner p {
            margin: 0;
            font-size: 13px;
            opacity: 0.9;
        }

        .form-section-title {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            margin: 24px 0 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding-bottom: 8px;
            border-bottom: 1px solid #f1f5f9;
        }

        .form-section-title i {
            color: #0ea5b4;
            font-size: 17px;
        }

        .field-group {
            margin-bottom: 18px;
        }

        .field-label {
            display: block;
            font-size: 12.5px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
        }

        .charge-row {
            display: grid;
            grid-template-columns: 1fr 150px 42px;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
            animation: fadeIn 0.2s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .btn-add-charge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f0fdfa;
            color: #0d9488;
            border: 1.5px dashed #99f6e4;
            padding: 9px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 4px;
        }

        .btn-add-charge:hover {
            background: #ccfbf1;
            border-color: #0d9488;
        }

        .btn-del-row {
            width: 40px;
            height: 42px;
            border-radius: 10px;
            background: #fff1f2;
            color: #e11d48;
            border: 1px solid #fecdd3;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }

        .btn-del-row:hover {
            background: #ffe4e6;
            color: #be123c;
        }

        .summary-side-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 26px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            border: 1px solid #eef3f6;
            position: sticky;
            top: 24px;
        }

        .breakdown-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            font-size: 13.5px;
            color: #475569;
            border-bottom: 1px dashed #f1f5f9;
        }

        .breakdown-row strong {
            color: #0f172a;
        }

        .tax-highlight-row {
            background: #f8fafc;
            padding: 10px 12px;
            border-radius: 10px;
            margin: 6px 0;
            border: 1px solid #e2e8f0;
        }

        .total-amount-box {
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            border-radius: 16px;
            padding: 18px 20px;
            margin: 18px 0;
            text-align: center;
        }

        .total-amount-box span {
            display: block;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.9;
        }

        .total-amount-box strong {
            font-size: 26px;
            font-weight: 800;
        }

        .payment-method-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .method-card {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px 8px;
            text-align: center;
            cursor: pointer;
            transition: 0.2s;
            background: #ffffff;
        }

        .method-card:hover {
            border-color: #0ea5b4;
        }

        .method-card input {
            display: none;
        }

        .method-card.selected {
            border-color: #0ea5b4;
            background: #f0fdfa;
            color: #0f766e;
        }

        .method-card i {
            font-size: 20px;
            display: block;
            margin-bottom: 4px;
        }

        .method-card span {
            font-size: 11.5px;
            font-weight: 600;
        }

        .btn-submit-bill {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            background: #0ea5b4;
            color: #ffffff;
            border: none;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 6px 20px rgba(14, 165, 180, 0.35);
            transition: 0.2s;
        }

        .btn-submit-bill:hover {
            background: #087f8c;
            transform: translateY(-1px);
        }

        @media (max-width: 950px) {
            .bill-workspace {
                grid-template-columns: 1fr;
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
                <a href="<%= contextPath %>/cashier/billing" class="back-link" style="width:38px; height:38px; border-radius:10px; background:#e0f2fe; color:#0369a1; display:flex; align-items:center; justify-content:center; text-decoration:none;">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div class="topbar-title">
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Generate Patient Bill</h1>
                    <span style="font-size: 12px; color: #64748b;">Create official invoice for completed appointment</span>
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

            <% if (error != null) { %>
                <div class="alert alert-error" style="background:#fff1f2; border:1px solid #fecdd3; color:#e11d48; padding:14px; border-radius:12px; margin-bottom:20px; display:flex; align-items:center; gap:10px;">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span><%= error %></span>
                </div>
            <% } %>

            <form action="<%= contextPath %>/cashier/generate-bill" method="POST" id="billingForm">
                <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">

                <div class="bill-workspace">

                    <!-- LEFT COLUMN: APPOINTMENT INFO & CHARGES INPUTS -->
                    <div class="bill-form-card">

                        <!-- PATIENT BANNER -->
                        <div class="patient-summary-banner">
                            <div>
                                <h3><%= patientName %></h3>
                                <p><i class="bi bi-envelope"></i> <%= patientEmail %> &nbsp;|&nbsp; <i class="bi bi-telephone"></i> <%= patientContact %></p>
                            </div>
                            <div style="text-align: right;">
                                <span style="background:rgba(255,255,255,0.2); padding:5px 12px; border-radius:8px; font-weight:700; font-size:13px;">
                                    <%= appointment.getAppointmentNumber() %>
                                </span>
                                <p style="margin-top:5px; font-size:12px;"><i class="bi bi-calendar3"></i> <%= appointment.getAppointmentDate() %></p>
                            </div>
                        </div>

                        <!-- TREATMENT & DENTIST DETAILS -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px;">
                            <div style="background:#f8fafc; padding:14px 16px; border-radius:12px; border:1px solid #e2e8f0;">
                                <span style="display:block; font-size:11.5px; color:#64748b; font-weight:600; text-transform:uppercase;">Attending Doctor</span>
                                <strong style="color:#0f172a; font-size:14px;">Dr. <%= doctorName %></strong>
                                <span style="display:block; color:#0ea5b4; font-size:12px; font-weight:500;"><%= doctorSpecialization %></span>
                            </div>
                            <div style="background:#f8fafc; padding:14px 16px; border-radius:12px; border:1px solid #e2e8f0;">
                                <span style="display:block; font-size:11.5px; color:#64748b; font-weight:600; text-transform:uppercase;">Treatment Performed</span>
                                <strong style="color:#0f172a; font-size:14px;"><%= treatmentTitle %></strong>
                                <span style="display:block; color:#16a34a; font-size:12px; font-weight:600;">Status: Completed</span>
                            </div>
                        </div>

                        <!-- 1. BASE TREATMENT FEE -->
                        <div class="form-section-title">
                            <i class="bi bi-cash-stack"></i> 1. Base Treatment Fee
                        </div>
                        <div class="field-group">
                            <label class="field-label">Treatment Standard Cost (Rs.)</label>
                            <input type="text" id="basicAmountInput" value="<%= basicAmount %>" readonly
                                   style="background:#f1f5f9; color:#334155; font-weight:700;" class="form-control">
                        </div>

                        <!-- 2. DOCTOR / SPECIALIST FEE -->
                        <div class="form-section-title">
                            <i class="bi bi-person-badge"></i> 2. Doctor Consultation & Specialist Fee
                        </div>
                        <div class="field-group">
                            <label class="field-label" for="doctorFee">Doctor's Clinical Fee (Rs.)</label>
                            <input type="number" step="0.01" min="0" name="doctorFee" id="doctorFee" value="0.00"
                                   placeholder="0.00" class="form-control" style="font-weight:600;">
                            <span style="font-size:11.5px; color:#64748b; margin-top:4px; display:block;">Enter any doctor consultation or specialist procedure charge.</span>
                        </div>

                        <!-- 3. ADDITIONAL CHARGES / MEDICATIONS / SERVICES -->
                        <div class="form-section-title">
                            <i class="bi bi-plus-circle-dotted"></i> 3. Additional Charges & Medications
                        </div>
                        <p style="font-size:12.5px; color:#64748b; margin-bottom:12px;">Add extra items like X-Rays, surgical kits, anesthesia, or prescribed medications with descriptions.</p>

                        <div id="additionalChargesContainer">
                            <!-- Dynamic rows will be inserted here -->
                        </div>

                        <button type="button" class="btn-add-charge" id="btnAddCharge">
                            <i class="bi bi-plus-lg"></i> Add Additional Charge / Item
                        </button>

                    </div>

                    <!-- RIGHT COLUMN: LIVE SUMMARY BREAKDOWN & PAYMENT METHOD -->
                    <div class="summary-side-card">
                        <h3 style="margin: 0 0 16px; font-size: 17px; font-weight: 700; color: #0f172a;">Billing Summary</h3>

                        <div class="breakdown-row">
                            <span>Base Treatment Fee</span>
                            <strong>Rs. <span id="summaryBasic"><%= String.format("%.2f", basicAmount) %></span></strong>
                        </div>

                        <div class="breakdown-row">
                            <span>Doctor Fee</span>
                            <strong>Rs. <span id="summaryDoctor">0.00</span></strong>
                        </div>

                        <div class="breakdown-row">
                            <span>Additional Charges</span>
                            <strong>Rs. <span id="summaryAdditional">0.00</span></strong>
                        </div>

                        <div class="breakdown-row" style="border-top: 1px solid #e2e8f0; font-weight: 600; padding-top: 12px;">
                            <span>Subtotal</span>
                            <strong>Rs. <span id="summarySubtotal"><%= String.format("%.2f", basicAmount) %></span></strong>
                        </div>

                        <div class="breakdown-row tax-highlight-row">
                            <span style="color: #0369a1; font-weight: 600;"><i class="bi bi-percent"></i> Tax (5%)</span>
                            <strong style="color: #0369a1;">Rs. <span id="summaryTax">0.00</span></strong>
                        </div>

                        <!-- GRAND TOTAL DISPLAY -->
                        <div class="total-amount-box">
                            <span>Total Payable Amount</span>
                            <strong>Rs. <span id="summaryGrandTotal"><%= String.format("%.2f", basicAmount) %></span></strong>
                        </div>

                        <!-- PAYMENT METHOD -->
                        <label class="field-label" style="margin-bottom: 8px;">Select Payment Method</label>
                        <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="CASH">

                        <div class="payment-method-selector">
                            <div class="method-card selected" data-method="CASH">
                                <i class="bi bi-cash"></i>
                                <span>Cash</span>
                            </div>
                            <div class="method-card" data-method="CARD">
                                <i class="bi bi-credit-card-2-front"></i>
                                <span>Card</span>
                            </div>
                            <div class="method-card" data-method="BANK_TRANSFER">
                                <i class="bi bi-bank"></i>
                                <span>Transfer</span>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit-bill">
                            <i class="bi bi-receipt"></i> Generate & Save Bill
                        </button>
                    </div>

                </div>
            </form>

        </div>
    </main>

</div>

<script>
    const basicAmountVal = parseFloat('<%= basicAmount %>') || 0;
    const doctorFeeInput = document.getElementById('doctorFee');
    const chargesContainer = document.getElementById('additionalChargesContainer');
    const btnAddCharge = document.getElementById('btnAddCharge');

    const summaryBasic = document.getElementById('summaryBasic');
    const summaryDoctor = document.getElementById('summaryDoctor');
    const summaryAdditional = document.getElementById('summaryAdditional');
    const summarySubtotal = document.getElementById('summarySubtotal');
    const summaryTax = document.getElementById('summaryTax');
    const summaryGrandTotal = document.getElementById('summaryGrandTotal');

    function calculateTotals() {
        const docFee = parseFloat(doctorFeeInput.value) || 0;

        let additionalTotal = 0;
        const amtInputs = chargesContainer.querySelectorAll('.charge-amt-input');
        amtInputs.forEach(input => {
            const val = parseFloat(input.value) || 0;
            additionalTotal += val;
        });

        const subtotal = basicAmountVal + docFee + additionalTotal;
        const tax = subtotal * 0.05;
        const grandTotal = subtotal + tax;

        summaryBasic.textContent = basicAmountVal.toFixed(2);
        summaryDoctor.textContent = docFee.toFixed(2);
        summaryAdditional.textContent = additionalTotal.toFixed(2);
        summarySubtotal.textContent = subtotal.toFixed(2);
        summaryTax.textContent = tax.toFixed(2);
        summaryGrandTotal.textContent = grandTotal.toFixed(2);
    }

    function addChargeRow(name = '', amount = '') {
        const row = document.createElement('div');
        row.className = 'charge-row';
        row.innerHTML = `
            <input type="text" name="chargeName" value="\${name}" placeholder="e.g. X-Ray, Antibiotics, Dressing" class="form-control" required>
            <input type="number" step="0.01" min="0" name="chargeAmount" value="\${amount}" placeholder="Amount (Rs.)" class="form-control charge-amt-input" required>
            <button type="button" class="btn-del-row" title="Remove"><i class="bi bi-trash3"></i></button>
        `;

        row.querySelector('.btn-del-row').addEventListener('click', () => {
            row.remove();
            calculateTotals();
        });

        row.querySelector('.charge-amt-input').addEventListener('input', calculateTotals);
        chargesContainer.appendChild(row);
        calculateTotals();
    }

    btnAddCharge.addEventListener('click', () => addChargeRow());
    doctorFeeInput.addEventListener('input', calculateTotals);

    // Payment Method selection
    const methodCards = document.querySelectorAll('.method-card');
    const hiddenMethodInput = document.getElementById('selectedPaymentMethod');

    methodCards.forEach(card => {
        card.addEventListener('click', () => {
            methodCards.forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            hiddenMethodInput.value = card.getAttribute('data-method');
        });
    });

    // Initial calculation
    calculateTotals();
</script>

</body>
</html>