<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Patient | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .form-card-container {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(6, 38, 50, 0.09);
            padding: 38px 44px;
            margin-bottom: 30px;
            border: 1px solid #edf3f5;
            width: 100%;
            box-sizing: border-box;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }
        .form-group.full-width { grid-column: 1 / -1; }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #2c4a57;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .input-box-wrap {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;
        }

        .input-box-wrap i {
            position: absolute;
            left: 15px;
            color: #8da4ae;
            font-size: 16px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .input-box-wrap input, .input-box-wrap textarea {
            width: 100%;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            padding: 12px 16px 12px 44px;
            font-size: 13.5px;
            color: #123847;
            background: #ffffff;
            outline: none;
            box-sizing: border-box;
            font-family: inherit;
            transition: all 0.2s ease;
        }

        .input-box-wrap textarea {
            padding-top: 13px;
            min-height: 95px;
        }

        .input-box-wrap input:hover, .input-box-wrap textarea:hover {
            border-color: #a4cddc;
        }

        .input-box-wrap input:focus, .input-box-wrap textarea:focus {
            border-color: #0ea5b4 !important;
            background: #ffffff !important;
            box-shadow: 0 0 0 3.5px rgba(14, 165, 180, 0.14) !important;
        }

        .input-box-wrap input:focus + i, .input-box-wrap:focus-within i {
            color: #0ea5b4;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 14px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid #f0f4f6;
        }

        .cancel-btn {
            background: #ffffff;
            color: #527382;
            border: 1px solid #d2e4ea;
            padding: 12px 22px;
            border-radius: 10px;
            font-weight: 500;
            font-size: 13.5px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: all 0.2s;
        }

        .cancel-btn:hover {
            background: #f4f8fa;
            color: #2c4a57;
        }

        .submit-btn {
            background: #0ea5b4;
            color: #ffffff;
            border: none;
            padding: 12px 26px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 13.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(14, 165, 180, 0.3);
        }

        .submit-btn:hover {
            background: #0c8c99;
            transform: translateY(-1px);
        }

        .alert-box {
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
            max-width: 850px;
        }
        .alert-box.success { background: #e8f8f0; color: #0d8248; border: 1px solid #c2eed5; }
        .alert-box.error { background: #feecee; color: #c92a2a; border: 1px solid #f9c6cb; }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-card-container {
                padding: 24px 20px;
            }
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- ========================================= -->
    <!-- SIDEBAR -->
    <!-- ========================================= -->
    <aside class="sidebar" id="sidebar">

        <div class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/images/logo1.png" alt="Sunrise Dental Clinic Logo">
            <div class="brand-text">
                <h2>Sunrise</h2>
                <span>Dental Clinic</span>
            </div>
        </div>

        <nav class="sidebar-navigation">
            <p class="navigation-title">MAIN</p>

            <a href="${pageContext.request.contextPath}/reception/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/reception/schedule" class="nav-item">
                <i class="bi bi-calendar3"></i>
                <span>Today's Schedule</span>
            </a>

            <div class="nav-dropdown">
                <button type="button" class="nav-item nav-dropdown-toggle" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-calendar-check"></i>
                        <span>Appointments</span>
                    </span>
                    <i class="bi bi-chevron-down dropdown-arrow"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/book-appointment" class="nav-subitem">
                        <i class="bi bi-calendar-plus"></i>
                        <span>Book Appointment</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/view-appointments" class="nav-subitem">
                        <i class="bi bi-calendar3"></i>
                        <span>View Appointments</span>
                    </a>
                </div>
            </div>

            <div class="nav-group open">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/register-patient" class="nav-subitem active">
                        <i class="bi bi-person-plus"></i>
                        <span>Register New Patient</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/manage-patients" class="nav-subitem">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Manage Patients</span>
                    </a>
                </div>
            </div>

            <p class="navigation-title clinic-title">CLINIC</p>

            <div class="nav-group">
                <button type="button" class="nav-item nav-toggle" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-person-badge"></i>
                        <span>Dentists</span>
                    </span>
                    <i class="bi bi-chevron-down nav-arrow"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/dentists" class="nav-subitem">
                        <i class="bi bi-people"></i>
                        <span>View Dentists</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/dentist-availability" class="nav-subitem">
                        <i class="bi bi-calendar2-week"></i>
                        <span>Check Availability</span>
                    </a>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/reception/profile" class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>

            <a href="${pageContext.request.contextPath}/reception/helpdesk.jsp" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>

            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </nav>

    </aside>

    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <a href="${pageContext.request.contextPath}/reception/dashboard" class="menu-button">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h1>New Patient Intake</h1>
                    <p>Enter the patient's personal, contact, and residential information.</p>
                </div>
            </div>

            <div class="topbar-right" style="display: flex; align-items: center; gap: 14px;">
                <a href="${pageContext.request.contextPath}/reception/manage-patients" class="view-all-link" style="background: rgba(14, 165, 180, 0.22); border: 1px solid rgba(14, 165, 180, 0.45); padding: 8px 16px; border-radius: 10px; color: #ffffff; font-size: 13px; font-weight: 500; display: inline-flex; align-items: center; gap: 7px; text-decoration: none;">
                    <i class="bi bi-person-lines-fill"></i> View All Patients
                </a>

                <a href="${pageContext.request.contextPath}/reception/profile" class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Receptionist</span>
                    </div>
                </a>
            </div>
        </header>

        <!-- DASHBOARD CONTENT -->
        <section class="dashboard-content">

            <!-- Notifications -->
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert-box success">
                    <i class="bi bi-check-circle-fill"></i>
                    <div>
                        <strong>Patient registered successfully!</strong>
                        <span>Assigned Patient Number: <strong><%= request.getAttribute("patientNumber") %></strong></span>
                    </div>
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-box error">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <div>
                        <strong>Registration failed:</strong>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                </div>
            <% } %>

            <!-- Form Card -->
            <div class="form-card-container">
                <div class="section-heading" style="margin-bottom: 25px; border-bottom: 1px solid #f0f4f6; padding-bottom: 15px;">
                    <div>
                        <h3 style="font-size: 18px; font-weight: 700; color: #0c3d4f; margin: 0 0 4px;">Patient Registration Form</h3>
                        <p style="font-size: 13px; color: #64748b; margin: 0;">Fill in all required fields marked with <span style="color: #d9534f; font-weight: bold;">*</span></p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/reception/register-patient" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Full Name <span style="color: #d9534f;">*</span></label>
                            <div class="input-box-wrap">
                                <i class="bi bi-person"></i>
                                <input type="text" id="name" name="name" placeholder="Enter patient's full name" maxlength="100" pattern="^[A-Za-z\s\.\'-]{2,100}$" title="Enter a valid name (letters and spaces only, min 2 characters)" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="dateOfBirth">Date of Birth <span style="color: #d9534f;">*</span></label>
                            <div class="input-box-wrap">
                                <i class="bi bi-calendar2-date"></i>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" min="1900-01-01" max="<%= java.time.LocalDate.now() %>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="contactNumber">Contact Number <span style="color: #d9534f;">*</span></label>
                            <div class="input-box-wrap">
                                <i class="bi bi-telephone"></i>
                                <input type="tel" id="contactNumber" name="contactNumber" placeholder="07XXXXXXXX" maxlength="15" pattern="^(?:0|94|\+94)?[0-9]{9,10}$" title="Enter a valid phone number (e.g. 0712345678 or +94712345678)" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address <span style="color: #d9534f;">*</span></label>
                            <div class="input-box-wrap">
                                <i class="bi bi-envelope"></i>
                                <input type="email" id="email" name="email" placeholder="patient@example.com" maxlength="100" pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" title="Enter a valid email address" required>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Residential Address <span style="color: #d9534f;">*</span></label>
                            <div class="input-box-wrap">
                                <i class="bi bi-geo-alt" style="top: 14px;"></i>
                                <textarea id="address" name="address" rows="3" placeholder="Enter patient's address" maxlength="255" required></textarea>
                            </div>
                            <small style="color: #8da4ae; font-size: 11.5px; margin-top: 4px;">Email is required for sending automated appointment confirmations, bill invoices, and reminders.</small>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/reception/dashboard" class="cancel-btn">
                            <i class="bi bi-x-lg"></i> Cancel
                        </a>
                        <button type="submit" class="submit-btn">
                            <i class="bi bi-person-plus-fill"></i> Complete Registration
                        </button>
                    </div>
                </form>
            </div>

        </section>

    </main>

</div>

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>

</body>
</html>