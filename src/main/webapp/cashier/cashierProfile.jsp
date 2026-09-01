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
    if (username == null) {
        username = "cashier";
    }
    if (email == null) {
        email = "cashier@sunrisedental.com";
    }
    if (phone == null) {
        phone = "+94 11 234 5678";
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <style>
        .profile-card-custom {
            background: #ffffff;
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            max-width: 650px;
            margin: 0 auto;
        }
        .profile-header-badge {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f1f5f9;
        }
        .profile-avatar-big {
            width: 70px;
            height: 70px;
            border-radius: 20px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 26px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .profile-info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px dashed #f1f5f9;
            font-size: 14px;
        }
        .profile-info-row span {
            color: #64748b;
        }
        .profile-info-row strong {
            color: #0f172a;
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

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-left">
                <div class="topbar-title">
                    <h1 style="font-size: 20px; font-weight: 700; margin: 0;">Cashier Profile</h1>
                    <span style="font-size: 12px; color: #64748b;">Staff credentials and clinic station details</span>
                </div>
            </div>
        </header>

        <div class="content-body" style="padding: 30px;">
            <div class="profile-card-custom">
                <div class="profile-header-badge">
                    <div class="profile-avatar-big">CC</div>
                    <div>
                        <h2 style="margin:0; font-size:22px; font-weight:700; color:#0f172a;"><%= staffName %></h2>
                        <span style="background:#e0f2fe; color:#0369a1; padding:4px 10px; border-radius:12px; font-size:12px; font-weight:600;"><%= role %></span>
                    </div>
                </div>

                <div class="profile-info-row">
                    <span>Staff ID:</span>
                    <strong>#<%= staffId %></strong>
                </div>
                <div class="profile-info-row">
                    <span>Username:</span>
                    <strong><%= username %></strong>
                </div>
                <div class="profile-info-row">
                    <span>Email Address:</span>
                    <strong><%= email %></strong>
                </div>
                <div class="profile-info-row">
                    <span>Contact Number:</span>
                    <strong><%= phone %></strong>
                </div>
                <div class="profile-info-row">
                    <span>Department:</span>
                    <strong>Billing & Finance Station</strong>
                </div>
                <div class="profile-info-row">
                    <span>Clinic Facility:</span>
                    <strong>Sunrise Dental Clinic Main Center</strong>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
