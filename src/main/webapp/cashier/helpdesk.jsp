<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Cashier";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help Desk & Support | Sunrise Dental Clinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <style>
        .helpdesk-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            max-width: 900px;
            margin: 0 auto;
        }
        .help-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 26px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
            border: 1px solid #eef2f5;
        }
        .help-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: #f0fdfa;
            color: #0d9488;
            font-size: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
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

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-left">
                <div class="topbar-title">
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Cashier Help Desk</h1>
                    <span style="font-size: 12px; color: #64748b;">Billing workflows, tax calculation guide, and IT assistance</span>
                </div>
            </div>
        </header>

        <div class="content-body" style="padding: 24px;">
            <div class="helpdesk-grid">
                <div class="help-card">
                    <div class="help-icon"><i class="bi bi-receipt-cutoff"></i></div>
                    <h3 style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0 0 8px;">Generating Patient Bills</h3>
                    <p style="font-size: 13px; color: #64748b; line-height: 1.6; margin: 0;">Navigate to the Billing tab or Cashier Dashboard. Select any completed appointment, add attending doctor fees and extra medication/procedure charges, and click Generate Bill.</p>
                </div>

                <div class="help-card">
                    <div class="help-icon"><i class="bi bi-percent"></i></div>
                    <h3 style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0 0 8px;">5% Tax Automation</h3>
                    <p style="font-size: 13px; color: #64748b; line-height: 1.6; margin: 0;">Government and service tax is automatically calculated as 5% of the total subtotal (Base treatment + Doctor fee + Additional charges) and recorded in the financial system.</p>
                </div>

                <div class="help-card">
                    <div class="help-icon"><i class="bi bi-printer"></i></div>
                    <h3 style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0 0 8px;">Printing & PDF Soft Copies</h3>
                    <p style="font-size: 13px; color: #64748b; line-height: 1.6; margin: 0;">Once an invoice is generated or viewed in the Payments tab, click the Print button to print a thermal/A4 receipt or save a soft copy PDF directly.</p>
                </div>

                <div class="help-card">
                    <div class="help-icon"><i class="bi bi-envelope-check"></i></div>
                    <h3 style="font-size: 16px; font-weight: 700; color: #0f172a; margin: 0 0 8px;">Emailing Invoices</h3>
                    <p style="font-size: 13px; color: #64748b; line-height: 1.6; margin: 0;">Click 'Send Invoice to Patient Email' on any invoice page to immediately email an itemized payment receipt to the patient's registered email address.</p>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
