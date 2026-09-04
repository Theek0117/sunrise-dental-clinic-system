<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Clinic Cashier";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cashier Help Desk & Financial Guide | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .helpdesk-content {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .help-hero-card {
            background: linear-gradient(135deg, rgba(14, 165, 180, 0.95), rgba(8, 127, 140, 1));
            border-radius: 20px;
            padding: 35px 40px;
            color: #ffffff;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(8, 127, 140, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px;
        }

        .help-hero-text h2 {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .help-hero-text p {
            font-size: 14px;
            color: #d6f4f8;
            max-width: 700px;
            line-height: 1.6;
            margin: 0;
        }

        .quick-actions-bar {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 35px;
        }

        .action-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 22px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 8px 24px rgba(7, 43, 56, 0.07);
            border: 1px solid #edf3f5;
            transition: all 0.25s ease;
        }

        .action-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(7, 43, 56, 0.12);
            border-color: #0ea5b4;
        }

        .action-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: #e6f7f9;
            color: #078c9b;
            font-size: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .action-text strong {
            display: block;
            font-size: 14px;
            color: #123948;
            font-weight: 600;
        }

        .action-text span {
            display: block;
            font-size: 11.5px;
            color: #7d96a2;
            margin-top: 2px;
        }

        .procedures-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 25px;
        }

        .procedure-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 10px 30px rgba(7, 43, 56, 0.08);
            border: 1px solid #edf3f5;
        }

        .procedure-header {
            display: flex;
            align-items: center;
            gap: 14px;
            padding-bottom: 18px;
            margin-bottom: 22px;
            border-bottom: 1.5px solid #f0f4f6;
        }

        .procedure-header .badge-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: #e8f8fa;
            color: #0ea5b4;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .procedure-header h3 {
            font-size: 18px;
            font-weight: 700;
            color: #0d3e50;
            margin: 0;
        }

        .steps-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .step-item {
            display: flex;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 22px;
        }

        .step-item:last-child {
            margin-bottom: 0;
        }

        .step-badge {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(8, 140, 155, 0.25);
        }

        .step-content strong {
            display: block;
            font-size: 14px;
            color: #123847;
            font-weight: 600;
            margin-bottom: 3px;
        }

        .step-content p {
            font-size: 13px;
            color: #557280;
            line-height: 1.6;
            margin: 0;
        }

        .step-tip {
            background: #f0fdfa;
            border-left: 4px solid #0ea5b4;
            padding: 10px 15px;
            border-radius: 4px 8px 8px 4px;
            margin-top: 8px;
            font-size: 12px;
            color: #0f766e;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .policies-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
            margin-top: 25px;
        }

        .policy-card {
            background: #f8fafb;
            border-radius: 14px;
            padding: 22px;
            border: 1px solid #eef2f5;
        }

        .policy-card h4 {
            font-size: 15px;
            font-weight: 600;
            color: #0c3c4e;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
        }

        .policy-card p {
            font-size: 12.5px;
            color: #5b7582;
            line-height: 1.6;
            margin: 0;
        }

        .support-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-top: 20px;
        }

        .support-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 18px;
            text-align: center;
        }

        .support-box i {
            font-size: 26px;
            color: #0ea5b4;
            margin-bottom: 8px;
            display: block;
        }

        .support-box strong {
            display: block;
            font-size: 14px;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .support-box span {
            font-size: 12px;
            color: #64748b;
        }

        @media (max-width: 1024px) {
            .quick-actions-bar {
                grid-template-columns: repeat(2, 1fr);
            }
            .policies-grid, .support-grid {
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
            <a href="<%= contextPath %>/cashier/billing" class="nav-item">
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
            <a href="<%= contextPath %>/cashier/helpdesk.jsp" class="nav-item active">
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

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1>Cashier Help Desk</h1>
                <p>Billing Operations, Tax Regulations & Financial Desk Manual</p>
            </div>
            <div class="topbar-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Clinic Cashier</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- HELPDESK CONTENT -->
        <section class="helpdesk-content">

            <!-- Hero Help Banner -->
            <div class="help-hero-card">
                <div class="help-hero-text">
                    <h2>Cashier Financial Operations & Billing Handbook</h2>
                    <p>
                        Welcome to the Cashier Help Desk. Follow the standard accounting and invoicing protocols below to compute itemized bills, process multi-channel payments, and issue legal patient invoices.
                    </p>
                </div>
                <i class="bi bi-receipt" style="font-size: 55px; opacity: 0.85;"></i>
            </div>

            <!-- Quick Action Jump Shortcuts -->
            <div class="quick-actions-bar">
                <a href="<%= contextPath %>/cashier/dashboard" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-grid-1x2-fill"></i>
                    </div>
                    <div class="action-text">
                        <strong>Dashboard</strong>
                        <span>Completed Queue</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/cashier/billing" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-receipt-cutoff"></i>
                    </div>
                    <div class="action-text">
                        <strong>Billing Desk</strong>
                        <span>Generate Bills</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/cashier/payments" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-credit-card-fill"></i>
                    </div>
                    <div class="action-text">
                        <strong>Payments</strong>
                        <span>Payment History</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/cashier/appointments" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-calendar2-week"></i>
                    </div>
                    <div class="action-text">
                        <strong>Appointments</strong>
                        <span>Clinic Schedule</span>
                    </div>
                </a>
            </div>

            <!-- Standard Operating Procedures -->
            <div class="procedures-grid">

                <!-- SOP 1: Generating Patient Invoices -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-calculator"></i></div>
                        <h3>SOP 1: Generating Invoices & Computing Charges</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Select a Completed Appointment</strong>
                                <p>Navigate to <strong>Billing &rarr; Completed Appointments</strong> or the <strong>Cashier Dashboard</strong> table. Click the <strong>Generate Bill</strong> button on the target appointment row.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Review Base Treatment & Enter Doctor Fee</strong>
                                <p>The system automatically retrieves the base procedure cost. Enter the doctor's consultation or specialized surgical fee into the designated input field.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Add Additional Medication & Supply Items</strong>
                                <p>Click <strong>+ Add Charge Item</strong> to itemize any prescribed antibiotics, dental mouthwashes, specialized anesthetics, or surgical materials with their respective prices.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">4</div>
                            <div class="step-content">
                                <strong>Verify 5% Statutory Tax & Grand Total</strong>
                                <p>The interactive bill workspace automatically computes the subtotal, calculates the statutory 5% healthcare tax, and presents the locked grand total in real-time.</p>
                                <div class="step-tip">
                                    <i class="bi bi-info-circle-fill"></i>
                                    <span><strong>Formula:</strong> Total = Base Treatment + Doctor Fee + Additional Items + (Subtotal &times; 5%).</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SOP 2: Payment Processing -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-credit-card-2-front"></i></div>
                        <h3>SOP 2: Payment Method Handling & Settlement</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Choose Settlement Method</strong>
                                <p>Select the patient's payment method from the settlement options: <strong>Cash</strong>, <strong>Credit/Debit Card (POS)</strong>, or <strong>Bank Transfer</strong>.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Execute Transaction & Confirm</strong>
                                <p>Verify receipt of cash in the drawer or approval response code from the card POS machine before finalizing.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Generate & Issue Permanent Invoice</strong>
                                <p>Click <strong>Generate Bill</strong>. The invoice is permanently committed to the ledger with a unique sequence number (e.g. <code>INV000004</code>).</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SOP 3: Printing Soft Copies & Email Receipts -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-printer"></i></div>
                        <h3>SOP 3: Printing Soft Copies & Email Invoicing</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Instant Thermal & A4 Print</strong>
                                <p>On the invoice presentation screen, click <strong>Print Invoice</strong>. The browser print dialog triggers optimized print styles without sidebar or website navigation.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Email Soft Copy to Patient</strong>
                                <p>Click <strong>Email Invoice to Patient</strong>. An itemized digital receipt is delivered to the patient's registered email with date, doctor, treatment, and itemized fee breakdown.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Clinic Financial Policies -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-shield-check"></i></div>
                        <h3>Clinic Financial Policies & Compliance</h3>
                    </div>
                    <div class="policies-grid">
                        <div class="policy-card">
                            <h4><i class="bi bi-check2-circle"></i> Mandatory Discharge Settlement</h4>
                            <p>Patients must be billed and marked completed prior to leaving the clinic. No medical files may be closed without an associated invoice number.</p>
                        </div>
                        <div class="policy-card">
                            <h4><i class="bi bi-percent"></i> Automated 5% Tax Policy</h4>
                            <p>Statutory healthcare tax is fixed at 5% clinic-wide and cannot be waived manually. All audits reconcile total tax against the government ledger.</p>
                        </div>
                        <div class="policy-card">
                            <h4><i class="bi bi-file-earmark-ruled"></i> Prescribed Item Transparency</h4>
                            <p>Every additional item charged must have a clear description (e.g. "Amoxicillin 500mg (15 Capsules)" or "Dental Mouthwash 250ml") for patient transparency.</p>
                        </div>
                        <div class="policy-card">
                            <h4><i class="bi bi-cash-stack"></i> Shift End Cashier Reconciliation</h4>
                            <p>At the end of each shift, cashier cash drawer totals and card terminal batch summaries must match the Payment History revenue summary.</p>
                        </div>
                    </div>
                </div>

                <!-- Emergency Support & IT Assistance -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-headset"></i></div>
                        <h3>Financial Support & POS Technical Assistance</h3>
                    </div>
                    <p style="color: #64748b; font-size: 13.5px; margin: 0 0 15px;">If you experience POS terminal communication failures, card payment chargeback requests, or system printer errors, reach out directly to the clinic support channels below:</p>
                    
                    <div class="support-grid">
                        <div class="support-box">
                            <i class="bi bi-telephone-inbound-fill"></i>
                            <strong>Internal Finance Desk</strong>
                            <span>Extension: 104 / 105</span>
                        </div>
                        <div class="support-box">
                            <i class="bi bi-credit-card-2-back-fill"></i>
                            <strong>POS & Card Gateway Help</strong>
                            <span>Toll-Free: +94 11 234 5670</span>
                        </div>
                        <div class="support-box">
                            <i class="bi bi-envelope-at-fill"></i>
                            <strong>IT & System Admin</strong>
                            <span>admin@sunrisedental.com</span>
                        </div>
                    </div>
                </div>

            </div>

        </section>

    </main>

</div>

<script src="<%= contextPath %>/js/notifications.js"></script>
</body>
</html>
