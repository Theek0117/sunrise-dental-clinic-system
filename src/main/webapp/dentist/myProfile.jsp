<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.DentistAvailability" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }

    Dentist dentist = (Dentist) request.getAttribute("loggedInDentist");
    String rawName = (dentist != null && dentist.getName() != null) ? dentist.getName() : staffName;
    String dentistName = "Dr. " + rawName.replaceAll("^(?i)dr\\.?\\s*", "").trim();
    String specialization = (dentist != null && dentist.getSpecialization() != null) ? dentist.getSpecialization() : "Dental Specialist";
    String dentistNumber = (dentist != null && dentist.getDentistNumber() != null) ? dentist.getDentistNumber() : "DEN-001";
    String roomNumber = (dentist != null && dentist.getRoomNumber() != null) ? dentist.getRoomNumber() : "Room 101";
    String contactPhone = (dentist != null && dentist.getContactNumber() != null) ? dentist.getContactNumber() : "+94 11 234 5678";
    String email = (dentist != null && dentist.getEmail() != null) ? dentist.getEmail() : "dentist@sunrisedental.com";

    Integer totalAppointments = (Integer) request.getAttribute("totalAppointmentsCount");
    if (totalAppointments == null) totalAppointments = 0;

    List<DentistAvailability> availability = (List<DentistAvailability>) request.getAttribute("upcomingAvailability");

    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .profile-container-grid {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 28px;
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
            font-size: 42px;
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
            gap: 20px;
        }

        .info-group label {
            display: block;
            font-size: 11.5px;
            color: #839ca7;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .info-group p {
            margin: 0;
            font-size: 14.5px;
            font-weight: 600;
            color: #123847;
            background: #f8fafb;
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid #eef3f6;
        }

        @media (max-width: 1024px) {
            .profile-container-grid {
                grid-template-columns: 1fr;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- =========================================================
         SIDEBAR
         ========================================================= -->
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

            <a href="${pageContext.request.contextPath}/dentist/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/dentist/appointments" class="nav-item">
                <i class="bi bi-calendar-check"></i>
                <span>My Appointments</span>
            </a>

            <div class="nav-group">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>My Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/dentist/patients" class="nav-subitem">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Patient Records</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dentist/treatment-history" class="nav-subitem">
                        <i class="bi bi-clock-history"></i>
                        <span>Treatment History</span>
                    </a>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/dentist/availability" class="nav-item">
                <i class="bi bi-calendar2-week"></i>
                <span>My Availability</span>
            </a>

            <p class="navigation-title clinic-title">CLINIC</p>

            <a href="${pageContext.request.contextPath}/dentist/helpdesk.jsp" class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="${pageContext.request.contextPath}/dentist/profile" class="nav-item active">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- =========================================================
         MAIN CONTENT
         ========================================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1>My Profile</h1>
                <p>Dentist credentials and clinical account details</p>
            </div>
            <div class="topbar-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= dentistName %></strong>
                        <span><%= specialization %></span>
                    </div>
                </div>
            </div>
        </header>

        <!-- PROFILE CONTENT -->
        <section class="profile-content">

            <div class="profile-container-grid">

                <!-- Left Profile Summary Card -->
                <div class="profile-card">
                    <div class="profile-avatar-large">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <h2><%= dentistName %></h2>
                    <span class="profile-badge"><%= specialization %></span>

                    <ul class="profile-meta-list">
                        <li class="profile-meta-item">
                            <span><i class="bi bi-hash"></i> Registration #</span>
                            <strong><%= dentistNumber %></strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-hospital"></i> Assigned Room</span>
                            <strong><%= roomNumber %></strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-calendar-check"></i> Total Consultations</span>
                            <strong><%= totalAppointments %> Cases</strong>
                        </li>
                        <li class="profile-meta-item">
                            <span><i class="bi bi-patch-check-fill" style="color: #129c5b;"></i> Account Status</span>
                            <strong style="color: #129c5b;">Active Clinical Staff</strong>
                        </li>
                    </ul>
                </div>

                <!-- Right Detailed Info Cards -->
                <div class="details-column">

                    <!-- Professional Information -->
                    <div class="details-card">
                        <div class="details-card-header">
                            <i class="bi bi-person-lines-fill"></i>
                            <h3>Professional Information</h3>
                        </div>

                        <div class="info-grid">
                            <div class="info-group">
                                <label>Full Legal Name</label>
                                <p><%= dentistName %></p>
                            </div>

                            <div class="info-group">
                                <label>Dental Specialization</label>
                                <p><%= specialization %></p>
                            </div>

                            <div class="info-group">
                                <label>Official Email Address</label>
                                <p><%= email %></p>
                            </div>

                            <div class="info-group">
                                <label>Clinic Contact Phone</label>
                                <p><%= contactPhone %></p>
                            </div>

                            <div class="info-group">
                                <label>Clinic Consultation Room</label>
                                <p><%= roomNumber %></p>
                            </div>

                            <div class="info-group">
                                <label>Staff Category</label>
                                <p>Licensed Dental Surgeon</p>
                            </div>
                        </div>
                    </div>

                    <!-- Today's Active Schedule -->
                    <div class="details-card">
                        <div class="details-card-header">
                            <i class="bi bi-clock-history"></i>
                            <h3>Today's Configured Schedule</h3>
                        </div>

                        <% if (availability != null && !availability.isEmpty()) { %>
                            <div class="info-grid">
                                <% for (DentistAvailability a : availability) { %>
                                    <div class="info-group">
                                        <label>Hours Window (Capacity: <%= a.getSlotCapacity() %>)</label>
                                        <p><%= a.getStartTime() %> - <%= a.getEndTime() %> (<%= a.getStatus() %>)</p>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <p style="color: #7994a0; font-size: 13.5px; margin: 0;">
                                No consultation slots configured for today. <a href="${pageContext.request.contextPath}/dentist/availability" style="color: #078c9b; font-weight: 600;">Manage Availability &rarr;</a>
                            </p>
                        <% } %>
                    </div>

                    <!-- Security & System Notice -->
                    <div class="details-card">
                        <div class="details-card-header">
                            <i class="bi bi-shield-lock"></i>
                            <h3>Account Security</h3>
                        </div>
                        <p style="color: #557280; font-size: 13px; line-height: 1.6; margin: 0;">
                            To update your personal contact details, license numbers, or reset your login credentials, please contact the Clinic IT Administrator or Reception Management.
                        </p>
                    </div>

                </div>

            </div>

        </section>

    </main>

</div>

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>
</body>
</html>
