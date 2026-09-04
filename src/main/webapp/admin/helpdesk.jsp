<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Help Desk & System Operations Guide | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap Icons & Reception CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">

    <style>
        .help-hero-banner {
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            border-radius: 20px;
            padding: 32px 36px;
            color: #ffffff;
            margin-bottom: 28px;
            box-shadow: 0 12px 35px rgba(14, 165, 180, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .help-hero-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin: 0 0 6px;
        }

        .help-hero-text p {
            font-size: 13.5px;
            color: #e0f7fa;
            margin: 0;
            line-height: 1.5;
            max-width: 700px;
        }

        .quick-nav-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 30px;
        }

        .quick-nav-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 8px 24px rgba(7, 43, 56, 0.06);
            border: 1.5px solid #edf2f7;
            transition: all 0.25s ease;
        }

        .quick-nav-card:hover {
            transform: translateY(-3px);
            border-color: #0ea5b4;
            box-shadow: 0 12px 30px rgba(14, 165, 180, 0.15);
        }

        .nav-card-icon {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            background: #f0fdfa;
            color: #0d9488;
            font-size: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .nav-card-info strong {
            display: block;
            font-size: 13.5px;
            color: #0f172a;
            font-weight: 700;
        }

        .nav-card-info span {
            font-size: 11.5px;
            color: #64748b;
        }

        .guide-section {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            padding: 28px;
            margin-bottom: 26px;
            border: 1px solid #edf2f7;
        }

        .guide-section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f1f5f9;
        }

        .guide-section-header i {
            font-size: 22px;
            color: #0ea5b4;
        }

        .guide-section-header h3 {
            margin: 0;
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
        }

        .workflow-step-box {
            display: flex;
            gap: 16px;
            padding: 16px;
            background: #f8fafc;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            margin-bottom: 14px;
        }

        .step-number-badge {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #0ea5b4;
            color: #ffffff;
            font-weight: 700;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .step-content h4 {
            margin: 0 0 4px;
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
        }

        .step-content p {
            margin: 0;
            font-size: 12.5px;
            color: #475569;
            line-height: 1.6;
        }

        .step-content .step-tags {
            display: flex;
            gap: 6px;
            margin-top: 8px;
            flex-wrap: wrap;
        }

        .step-tag {
            background: #e0f2fe;
            color: #0369a1;
            font-size: 11px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 6px;
        }

        .faq-accordion-item {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            margin-bottom: 12px;
            overflow: hidden;
        }

        .faq-accordion-header {
            padding: 16px 20px;
            background: #f8fafc;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            font-size: 13.5px;
            color: #0f172a;
            user-select: none;
            transition: 0.2s;
        }

        .faq-accordion-header:hover {
            background: #f1f5f9;
            color: #0ea5b4;
        }

        .faq-accordion-body {
            padding: 16px 20px;
            background: #ffffff;
            font-size: 13px;
            color: #475569;
            line-height: 1.6;
            border-top: 1px solid #e2e8f0;
            display: block;
        }

        @media (max-width: 1024px) {
            .quick-nav-grid { grid-template-columns: 1fr 1fr; }
        }

        @media (max-width: 640px) {
            .quick-nav-grid { grid-template-columns: 1fr; }
            .help-hero-banner { flex-direction: column; align-items: flex-start; }
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
            <a href="<%= contextPath %>/admin/reports" class="nav-item">
                <i class="bi bi-bar-chart-line-fill"></i>
                <span>Reports</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="<%= contextPath %>/admin/helpdesk" class="nav-item active">
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
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Help Desk & System Working Methods</h1>
                    <span style="font-size: 12px; color: #64748b;">Complete standard operating procedures, module guides, and administration manuals</span>
                </div>
            </div>
            <div class="topbar-right">
                <div class="user-profile-badge" style="display:flex; align-items:center; gap:10px;">
                    <div style="width:38px; height:38px; border-radius:50%; background:#0ea5b4; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700;">AD</div>
                    <div>
                        <strong style="display:block; font-size:13px;"><%= staffName %></strong>
                        <span style="font-size:11px; color:#64748b;">System Administrator</span>
                    </div>
                </div>
            </div>
        </header>

        <div class="content-body" style="padding: 24px;">

            <!-- HERO BANNER -->
            <div class="help-hero-banner">
                <div class="help-hero-text">
                    <h2>Clinic Administration & Operations Knowledgebase</h2>
                    <p>
                        This manual outlines the working methods and operational lifecycle across all 4 system roles: Administrator, Receptionist, Dentist, and Cashier. Use this guide to ensure smooth clinic management and troubleshoot everyday workflows.
                    </p>
                </div>
                <i class="bi bi-mortarboard-fill" style="font-size: 55px; opacity: 0.9;"></i>
            </div>

            <!-- QUICK JUMP CARDS -->
            <div class="quick-nav-grid">
                <a href="#admin-guide" class="quick-nav-card">
                    <div class="nav-card-icon"><i class="bi bi-shield-lock-fill"></i></div>
                    <div class="nav-card-info">
                        <strong>Admin Module</strong>
                        <span>Staff, Slots, Treatments</span>
                    </div>
                </a>

                <a href="#reception-guide" class="quick-nav-card">
                    <div class="nav-card-icon"><i class="bi bi-calendar2-plus-fill"></i></div>
                    <div class="nav-card-info">
                        <strong>Reception Module</strong>
                        <span>Patients & Appointments</span>
                    </div>
                </a>

                <a href="#dentist-guide" class="quick-nav-card">
                    <div class="nav-card-icon"><i class="bi bi-heart-pulse-fill"></i></div>
                    <div class="nav-card-info">
                        <strong>Dentist Module</strong>
                        <span>Treatments, X-Rays, Status</span>
                    </div>
                </a>

                <a href="#cashier-guide" class="quick-nav-card">
                    <div class="nav-card-icon"><i class="bi bi-receipt-cutoff"></i></div>
                    <div class="nav-card-info">
                        <strong>Cashier Module</strong>
                        <span>Doctor Fee, 5% Tax, Invoices</span>
                    </div>
                </a>
            </div>

            <!-- ========================================================= -->
            <!-- 1. COMPLETE CLINICAL LIFECYCLE OVERVIEW -->
            <!-- ========================================================= -->
            <div class="guide-section" id="lifecycle-guide">
                <div class="guide-section-header">
                    <i class="bi bi-arrow-repeat"></i>
                    <h3>1. End-to-End Clinic Workflow Lifecycle</h3>
                </div>

                <div class="workflow-step-box">
                    <div class="step-number-badge">1</div>
                    <div class="step-content">
                        <h4>Patient Registration & Scheduling (Reception Desk)</h4>
                        <p>The Receptionist searches existing records or registers a new patient with auto-generated ID (<code>P000001</code>). They check doctor availability in 30-minute intervals and book the appointment. The system automatically dispatches an appointment confirmation email with the time, dentist name, and appointment number.</p>
                        <div class="step-tags">
                            <span class="step-tag">Receptionist</span>
                            <span class="step-tag">Email Notification</span>
                            <span class="step-tag">30-Min Slot Lock</span>
                        </div>
                    </div>
                </div>

                <div class="workflow-step-box">
                    <div class="step-number-badge">2</div>
                    <div class="step-content">
                        <h4>Doctor Consultation & Clinical Procedures (Dentist Suite)</h4>
                        <p>The assigned Dentist views their daily schedule. During the visit, the dentist reviews the patient's medical history, updates appointment status to <strong>IN-PROGRESS</strong>, attaches X-Ray imaging reports, records treatment notes, and upon completion marks the appointment as <strong>COMPLETED</strong>.</p>
                        <div class="step-tags">
                            <span class="step-tag">Dentist</span>
                            <span class="step-tag">X-Ray Upload</span>
                            <span class="step-tag">Clinical Notes</span>
                        </div>
                    </div>
                </div>

                <div class="workflow-step-box">
                    <div class="step-number-badge">3</div>
                    <div class="step-content">
                        <h4>Billing, Doctor Fees & Soft Copy Receipt (Cashier Desk)</h4>
                        <p>The Cashier accesses the Completed Appointments queue. The system pulls base procedure prices. The cashier enters the specialist Doctor Fee, appends any extra medications or consumable items, and the system automatically applies the <strong>5% Government/Clinic Tax</strong>. Once generated, an official soft copy bill (<code>INV000001</code>) is issued, and an invoice email is sent to the patient.</p>
                        <div class="step-tags">
                            <span class="step-tag">Cashier</span>
                            <span class="step-tag">Doctor Fee</span>
                            <span class="step-tag">5% Tax Auto-Calc</span>
                            <span class="step-tag">Soft Copy PDF</span>
                        </div>
                    </div>
                </div>

                <div class="workflow-step-box">
                    <div class="step-number-badge">4</div>
                    <div class="step-content">
                        <h4>Executive Audits & Periodic Reporting (Administrator)</h4>
                        <p>The Administrator monitors clinic health via real-time analytics. They filter operational reports across Daily, Monthly, Yearly, and Custom periods to audit gross earnings, doctor consultation payouts, tax collections, and master patient logs.</p>
                        <div class="step-tags">
                            <span class="step-tag">Administrator</span>
                            <span class="step-tag">Doctor Fee Payouts</span>
                            <span class="step-tag">Daily / Monthly Audits</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ========================================================= -->
            <!-- 2. ADMINISTRATOR WORKING METHODS -->
            <!-- ========================================================= -->
            <div class="guide-section" id="admin-guide">
                <div class="guide-section-header">
                    <i class="bi bi-shield-lock-fill"></i>
                    <h3>2. Administrator Working Methods & System Controls</h3>
                </div>

                <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div style="background:#f8fafc; padding:20px; border-radius:14px; border:1px solid #e2e8f0;">
                        <h4 style="margin:0 0 10px; font-size:14px; color:#0f172a;"><i class="bi bi-people" style="color:#0ea5b4;"></i> Staff Account Administration</h4>
                        <ul style="margin:0; padding-left:18px; font-size:12.5px; color:#475569; line-height:1.7;">
                            <li><strong>Add Staff:</strong> Register Dentists, Receptionists, and Cashiers with dedicated credentials.</li>
                            <li><strong>Doctor Specialization:</strong> When adding a Dentist, specify their clinical specialty (Orthodontics, Periodontics, etc.).</li>
                            <li><strong>Account Status:</strong> Toggle accounts between <code>ACTIVE</code> and <code>INACTIVE</code> to control system access without data deletion.</li>
                        </ul>
                    </div>

                    <div style="background:#f8fafc; padding:20px; border-radius:14px; border:1px solid #e2e8f0;">
                        <h4 style="margin:0 0 10px; font-size:14px; color:#0f172a;"><i class="bi bi-clock-history" style="color:#0ea5b4;"></i> Dentist Time Slots Inspection</h4>
                        <ul style="margin:0; padding-left:18px; font-size:12.5px; color:#475569; line-height:1.7;">
                            <li><strong>Slot Directory:</strong> View scheduled consultation hours across all doctors.</li>
                            <li><strong>Filters:</strong> Search slots by Doctor Name, specific date, or day of the week.</li>
                            <li><strong>Capacity Limits:</strong> Audit max patient limits and active consultation windows.</li>
                        </ul>
                    </div>

                    <div style="background:#f8fafc; padding:20px; border-radius:14px; border:1px solid #e2e8f0;">
                        <h4 style="margin:0 0 10px; font-size:14px; color:#0f172a;"><i class="bi bi-journal-medical" style="color:#0ea5b4;"></i> Treatment Procedures & Fees</h4>
                        <ul style="margin:0; padding-left:18px; font-size:12.5px; color:#475569; line-height:1.7;">
                            <li><strong>Base Cost Setup:</strong> Manage procedural fees (Cleaning, Root Canal, Extraction, Whitening, etc.).</li>
                            <li><strong>Catalog Updates:</strong> Add new dental procedures with default descriptions.</li>
                            <li><strong>Active Pricing:</strong> Updated prices immediately reflect on the cashier billing calculator.</li>
                        </ul>
                    </div>

                    <div style="background:#f8fafc; padding:20px; border-radius:14px; border:1px solid #e2e8f0;">
                        <h4 style="margin:0 0 10px; font-size:14px; color:#0f172a;"><i class="bi bi-bar-chart-line" style="color:#0ea5b4;"></i> Executive Reports & Audits</h4>
                        <ul style="margin:0; padding-left:18px; font-size:12.5px; color:#475569; line-height:1.7;">
                            <li><strong>Time Range:</strong> Switch between Daily, Monthly, Yearly, and Custom ranges.</li>
                            <li><strong>Doctor Fee Payouts:</strong> Audit exact consultation fee earnings per practitioner.</li>
                            <li><strong>Soft Copy Bills:</strong> Click "View Bill" on any invoice entry to inspect patient soft copies.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- ========================================================= -->
            <!-- 3. RECEPTIONIST WORKING METHODS -->
            <!-- ========================================================= -->
            <div class="guide-section" id="reception-guide">
                <div class="guide-section-header">
                    <i class="bi bi-person-workspace"></i>
                    <h3>3. Receptionist Desk Working Methods</h3>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> How to Register a New Patient</span>
                    </div>
                    <div class="faq-accordion-body">
                        Navigate to <strong>Patients &rarr; Register New Patient</strong>. Enter Full Name, Contact Number, Address, and Email. The system enforces email uniqueness and auto-assigns an incremental patient identifier (e.g. <code>P000012</code>).
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> How to Book an Appointment & 30-Minute Slot Rules</span>
                    </div>
                    <div class="faq-accordion-body">
                        Go to <strong>Book Appointment</strong>. Select the Patient, Attending Dentist, Procedure, and Date. Choose an available 30-minute interval (e.g. <code>09:00 - 09:30</code>). Once submitted, the slot is locked, status is set to <code>CONFIRMED</code>, and an automated email confirmation is dispatched to the patient.
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Rescheduling & Cancellation Protocol</span>
                    </div>
                    <div class="faq-accordion-body">
                        Under <strong>Appointments Overview</strong>, locate the appointment. Clicking <strong>Reschedule</strong> allows selecting a new doctor slot and sends an updated itinerary email. Clicking <strong>Cancel</strong> immediately releases the slot for other patients and sends a cancellation alert.
                    </div>
                </div>
            </div>

            <!-- ========================================================= -->
            <!-- 4. DENTIST WORKING METHODS -->
            <!-- ========================================================= -->
            <div class="guide-section" id="dentist-guide">
                <div class="guide-section-header">
                    <i class="bi bi-heart-pulse-fill"></i>
                    <h3>4. Dentist Clinical Working Methods</h3>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Managing Weekly Available Consultation Windows</span>
                    </div>
                    <div class="faq-accordion-body">
                        Under <strong>My Available Time Slots</strong>, dentists can define recurring weekly shifts (e.g. Mondays 09:00 - 13:00) or specific date slots with maximum patient capacities.
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Adding Clinical Notes & X-Ray Reports</span>
                    </div>
                    <div class="faq-accordion-body">
                        Open the patient appointment from the <strong>Dentist Dashboard</strong>. Record findings, prescribed medications, and clinical notes. Upload diagnostic X-Ray images (JPG, PNG, PDF) for permanent archiving in the patient's medical history.
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Releasing Appointments for Cashier Billing</span>
                    </div>
                    <div class="faq-accordion-body">
                        When the clinical treatment is finished, change the status to <strong>COMPLETED</strong>. This unlocks the appointment in the Cashier desk for fee compilation and invoice generation.
                    </div>
                </div>
            </div>

            <!-- ========================================================= -->
            <!-- 5. CASHIER WORKING METHODS -->
            <!-- ========================================================= -->
            <div class="guide-section" id="cashier-guide">
                <div class="guide-section-header">
                    <i class="bi bi-receipt-cutoff"></i>
                    <h3>5. Cashier & Billing Working Methods</h3>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Invoice Calculation Formula & 5% Tax</span>
                    </div>
                    <div class="faq-accordion-body">
                        The billing calculator automatically computes:
                        <br><code>Subtotal = Treatment Base Price + Doctor Consultation Fee + Additional Charges</code>
                        <br><code>5% Tax Amount = Subtotal × 0.05</code>
                        <br><code>Final Total Amount = Subtotal + Tax Amount</code>
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Adding Dynamic Additional Medication / Line Items</span>
                    </div>
                    <div class="faq-accordion-body">
                        On the <strong>Generate Bill</strong> page, click <strong>"+ Add Charge Item"</strong> to append anesthesia, medications, antibiotics, or special sterile items with item names and prices.
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-check2-circle" style="color:#0ea5b4; margin-right:8px;"></i> Printing Soft Copy Bills & Sending Emails</span>
                    </div>
                    <div class="faq-accordion-body">
                        Once submitted, the system redirects to the printable soft-copy invoice (<code>INV000001</code>). The cashier can click <strong>"Print Invoice"</strong> (for thermal/A4 print) or <strong>"Email Invoice to Patient"</strong> to send an itemized receipt to the patient's registered email address.
                    </div>
                </div>
            </div>

            <!-- ========================================================= -->
            <!-- 6. SYSTEM TROUBLESHOOTING & FAQ -->
            <!-- ========================================================= -->
            <div class="guide-section" id="troubleshooting-guide">
                <div class="guide-section-header">
                    <i class="bi bi-tools"></i>
                    <h3>6. System Troubleshooting & Administrator FAQ</h3>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-question-diamond-fill" style="color:#0ea5b4; margin-right:8px;"></i> Patient not receiving automated notification emails?</span>
                    </div>
                    <div class="faq-accordion-body">
                        Check that the patient's email address is correctly spelled without trailing spaces. Verify SMTP credentials in <code>EmailService.java</code> (default port 587 with TLS).
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-question-diamond-fill" style="color:#0ea5b4; margin-right:8px;"></i> Doctor not appearing on the appointment booking list?</span>
                    </div>
                    <div class="faq-accordion-body">
                        Confirm that the doctor's staff account is set to <code>ACTIVE</code> under <strong>Staff Management</strong>, and that they have at least one active consultation window configured.
                    </div>
                </div>

                <div class="faq-accordion-item">
                    <div class="faq-accordion-header">
                        <span><i class="bi bi-question-diamond-fill" style="color:#0ea5b4; margin-right:8px;"></i> How are Doctor Fees tracked for monthly payroll?</span>
                    </div>
                    <div class="faq-accordion-body">
                        Go to <strong>Reports &rarr; Financial & Doctor Fees Analytics &rarr; Select "This Month"</strong>. The Doctor Consultation Fees Summary table displays the exact accumulated consultation earnings for each doctor.
                    </div>
                </div>
            </div>

        </div>
    </main>

</div>

<script src="<%= contextPath %>/js/notifications.js"></script>
</body>
</html>
