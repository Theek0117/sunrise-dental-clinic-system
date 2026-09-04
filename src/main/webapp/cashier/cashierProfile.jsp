<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String staffName = (String) session.getAttribute("staffName");
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("staffEmail");
    String phone = (String) session.getAttribute("staffPhone");
    String staffId = String.valueOf(session.getAttribute("staffId"));

    if (staffName == null || staffName.isBlank()) {
        staffName = "Clinic Cashier";
    }
    if (role == null || role.isBlank()) {
        role = "CASHIER";
    }
    if (username == null || username.isBlank()) {
        username = "cashier";
    }
    if (email == null || email.isBlank()) {
        email = "cashier@sunrisedental.com";
    }
    if (phone == null || phone.isBlank()) {
        phone = "+94 11 234 5678";
    }
    if (staffId == null || staffId.equals("null") || staffId.isBlank()) {
        staffId = "001";
    }

    /* Initials */
    String initials = "CC";
    String[] parts = staffName.trim().split("\\s+");
    if (parts.length >= 2 && parts[0].length() > 0 && parts[parts.length - 1].length() > 0) {
        initials = ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
    } else if (staffName.length() >= 2) {
        initials = staffName.substring(0, 2).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .profile-container-grid {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 28px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .profile-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 35px 25px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            border: 1px solid #edf3f5;
        }

        .profile-avatar-large {
            width: 100px;
            height: 100px;
            border-radius: 28px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 38px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 18px;
            box-shadow: 0 8px 25px rgba(8, 140, 155, 0.3);
        }

        .profile-card h2 {
            font-size: 20px;
            font-weight: 700;
            color: #0c3d4f;
            margin: 0;
        }

        .profile-badge {
            display: inline-block;
            background: #e6f7f9;
            color: #078c9b;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin: 8px 0 18px;
        }

        .profile-meta-list {
            list-style: none;
            padding: 0;
            margin: 20px 0 0;
            border-top: 1px solid #f0f4f6;
            text-align: left;
        }

        .profile-meta-item {
            padding: 14px 0;
            border-bottom: 1px solid #f0f4f6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }

        .profile-meta-item span {
            color: #839ca7;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .profile-meta-item strong {
            color: #1a3b47;
            font-weight: 600;
        }

        .details-column {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .details-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            border: 1px solid #edf3f5;
        }

        .details-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
            padding-bottom: 14px;
            border-bottom: 1.5px solid #f0f4f6;
        }

        .details-card-header i {
            font-size: 20px;
            color: #0ea5b4;
        }

        .details-card-header h3 {
            font-size: 17px;
            font-weight: 700;
            color: #0c3d4f;
            margin: 0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .info-item {
            background: #f8fafb;
            padding: 16px;
            border-radius: 12px;
            border: 1px solid #eef2f5;
        }

        .info-item label {
            display: block;
            font-size: 11.5px;
            color: #829ca7;
            font-weight: 500;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-item span {
            display: block;
            font-size: 14px;
            color: #133a49;
            font-weight: 600;
            word-break: break-word;
        }

        .privilege-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .privilege-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 18px;
            background: #f8fafc;
            border-radius: 12px;
            border: 1px solid #eef2f5;
        }

        .privilege-item .priv-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: #e0f2fe;
            color: #0284c7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
        }

        .privilege-item strong {
            display: block;
            font-size: 13.5px;
            color: #0f172a;
            font-weight: 600;
        }

        .privilege-item span {
            display: block;
            font-size: 12px;
            color: #64748b;
        }

        .guidelines-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        .guideline-box {
            background: #f0fdfa;
            border: 1px solid #ccfbf1;
            border-radius: 12px;
            padding: 16px;
        }

        .guideline-box h4 {
            margin: 0 0 6px;
            font-size: 13.5px;
            font-weight: 700;
            color: #0f766e;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .guideline-box p {
            margin: 0;
            font-size: 12px;
            color: #334155;
            line-height: 1.5;
        }

        @media (max-width: 992px) {
            .profile-container-grid {
                grid-template-columns: 1fr;
            }
            .info-grid, .guidelines-grid {
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
            <a href="<%= contextPath %>/cashier/profile" class="nav-item active">
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

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1>Cashier Profile</h1>
                <p>Staff Credentials, Station Authorizations & Terminal Settings</p>
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

        <!-- CONTENT BODY -->
        <div class="content-body" style="padding: 30px;">

            <div class="profile-container-grid">

                <!-- LEFT COLUMN: AVATAR & BASIC DETAILS -->
                <div class="profile-card">
                    <div class="profile-avatar-large">
                        <%= initials %>
                    </div>

                    <h2><%= staffName %></h2>
                    <span class="profile-badge">
                        <i class="bi bi-shield-lock-fill" style="margin-right: 4px;"></i> Clinic Cashier
                    </span>

                    <ul class="profile-meta-list">
                        <li class="profile-meta-item">
                            <span><i class="bi bi-person-badge"></i> Staff ID</span>
                            <strong>#CSH-<%= staffId %></strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-building"></i> Department</span>
                            <strong>Finance & Accounts</strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-laptop"></i> Work Station</span>
                            <strong>Billing Counter 01</strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-briefcase"></i> Employment</span>
                            <strong>Full-Time Staff</strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-clock-history"></i> Shift Timing</span>
                            <strong>08:30 AM - 05:30 PM</strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-patch-check-fill" style="color:#10b981;"></i> Status</span>
                            <strong style="color: #10b981;">Active & Verified</strong>
                        </li>
                    </ul>
                </div>

                <!-- RIGHT COLUMN: DETAILED INFO CARDS -->
                <div class="details-column">

                    <!-- CARD 1: ACCOUNT & CONTACT INFO -->
                    <div class="details-card">
                        <div class="details-card-header">
                            <i class="bi bi-person-lines-fill"></i>
                            <h3>Personal & Account Credentials</h3>
                        </div>

                        <div class="info-grid">
                            <div class="info-item">
                                <label>Full Name</label>
                                <span><%= staffName %></span>
                            </div>
                            <div class="info-item">
                                <label>System Username</label>
                                <span>@<%= username %></span>
                            </div>
                            <div class="info-item">
                                <label>Official Email Address</label>
                                <span><%= email %></span>
                            </div>
                            <div class="info-item">
                                <label>Contact Telephone</label>
                                <span><%= phone %></span>
                            </div>
                            <div class="info-item">
                                <label>Assigned Medical Facility</label>
                                <span>Sunrise Dental Headquarters</span>
                            </div>
                            <div class="info-item">
                                <label>Terminal Role</label>
                                <span>Cashier & Invoicing Specialist</span>
                            </div>
                        </div>
                    </div>

                    <!-- CARD 2: PRIVILEGES & CLEARANCES -->
                    <div class="details-card">
                        <div class="details-card-header">
                            <i class="bi bi-shield-check"></i>
                            <h3>Cashier Station Privileges & Clearances</h3>
                        </div>

                        <div class="privilege-list">
                            <div class="privilege-item">
                                <div class="priv-icon"><i class="bi bi-calculator"></i></div>
                                <div>
                                    <strong>Bill Generation & Charge Itemization</strong>
                                    <span>Compute treatment costs, doctor consultation fees, and procedural extras.</span>
                                </div>
                            </div>
                            <div class="privilege-item">
                                <div class="priv-icon"><i class="bi bi-percent"></i></div>
                                <div>
                                    <strong>Automated 5% Tax Computation</strong>
                                    <span>System-locked healthcare tax calculation and legal financial ledger entry.</span>
                                </div>
                            </div>
                            <div class="privilege-item">
                                <div class="priv-icon"><i class="bi bi-credit-card"></i></div>
                                <div>
                                    <strong>Multi-Channel Payment Settlement</strong>
                                    <span>Process and record Cash, POS Debit/Credit Card, and Direct Bank Transfers.</span>
                                </div>
                            </div>
                            <div class="privilege-item">
                                <div class="priv-icon"><i class="bi bi-printer"></i></div>
                                <div>
                                    <strong>Print Receipts & Dispatch Soft Copies</strong>
                                    <span>Generate thermal/A4 invoices and dispatch automated PDF bills to patient emails.</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- CARD 3: CASHIER STATION DIRECTIVES -->
                    <div class="details-card">
                        <div class="details-card-header">
                            <i class="bi bi-info-circle-fill"></i>
                            <h3>Station Directives & Financial Compliance</h3>
                        </div>

                        <div class="guidelines-grid">
                            <div class="guideline-box">
                                <h4><i class="bi bi-shield-lock"></i> Session Security</h4>
                                <p>Always lock your workstation terminal or logout whenever stepping away from the cashier counter.</p>
                            </div>
                            <div class="guideline-box">
                                <h4><i class="bi bi-receipt"></i> Mandatory Receipt Delivery</h4>
                                <p>Issue a printed soft receipt or confirm email delivery for every completed transaction before patient exit.</p>
                            </div>
                            <div class="guideline-box">
                                <h4><i class="bi bi-cash"></i> Daily Drawer Balancing</h4>
                                <p>Reconcile cash float and POS batch receipts with the system Payment History at shift conclusion.</p>
                            </div>
                            <div class="guideline-box">
                                <h4><i class="bi bi-file-earmark-lock"></i> Patient Confidentiality</h4>
                                <p>Ensure patient contact and billing numbers are strictly safeguarded according to clinic compliance.</p>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </div>

    </main>

</div>

<script src="<%= contextPath %>/js/notifications.js"></script>
</body>
</html>
