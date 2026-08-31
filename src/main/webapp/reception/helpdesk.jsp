<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reception Help Desk & Guide | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .help-hero-card {
            background: linear-gradient(135deg, rgba(14, 165, 180, 0.9), rgba(8, 127, 140, 0.95));
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
            max-width: 650px;
            line-height: 1.6;
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
            background: #fdf8eb;
            border-left: 4px solid #e5a110;
            padding: 10px 15px;
            border-radius: 4px 8px 8px 4px;
            margin-top: 8px;
            font-size: 12px;
            color: #8c6109;
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

        @media (max-width: 1024px) {
            .quick-actions-bar {
                grid-template-columns: repeat(2, 1fr);
            }
            .policies-grid {
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

            <div class="nav-group">
                <button type="button" class="nav-item nav-parent" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-people"></i>
                        <span>Patients</span>
                    </span>
                    <i class="bi bi-chevron-down nav-chevron"></i>
                </button>
                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/register-patient" class="nav-subitem">
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

            <a href="${pageContext.request.contextPath}/reception/helpdesk.jsp" class="nav-item active">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="${pageContext.request.contextPath}/reception/profile" class="nav-item">
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
                <h1>Reception Help Desk</h1>
                <p>Standard Operating Procedures & Clinic Workflow Guide</p>
            </div>
            <div class="topbar-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Front Desk Reception</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- HELPDESK CONTENT -->
        <section class="helpdesk-content">

            <!-- Hero Help Banner -->
            <div class="help-hero-card">
                <div class="help-hero-text">
                    <h2>Front Desk Receptionist System Handbook</h2>
                    <p>
                        Welcome to the Sunrise Dental Clinic Help Desk. Follow the standardized operational procedures below to ensure seamless patient onboarding, appointment scheduling, and calendar management.
                    </p>
                </div>
                <i class="bi bi-journal-medical" style="font-size: 55px; opacity: 0.85;"></i>
            </div>

            <!-- Quick Action Jump Shortcuts -->
            <div class="quick-actions-bar">
                <a href="${pageContext.request.contextPath}/reception/register-patient" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-person-plus-fill"></i>
                    </div>
                    <div class="action-text">
                        <strong>New Patient</strong>
                        <span>Register profile</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/reception/book-appointment" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-calendar-plus-fill"></i>
                    </div>
                    <div class="action-text">
                        <strong>Book Appointment</strong>
                        <span>Reserve a time slot</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/reception/dentist-availability" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <div class="action-text">
                        <strong>Doctor Roster</strong>
                        <span>Check available hours</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/reception/view-appointments" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-calendar3"></i>
                    </div>
                    <div class="action-text">
                        <strong>View Appointments</strong>
                        <span>Manage & Reschedule</span>
                    </div>
                </a>
            </div>

            <!-- Standard Operating Procedures -->
            <div class="procedures-grid">

                <!-- 1. Patient Registration -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-person-badge"></i></div>
                        <h3>SOP 1: Registering a New Patient</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Navigate to Registration Screen</strong>
                                <p>Click <strong>Patients &rarr; Register New Patient</strong> from the sidebar menu.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Complete the Required Information</strong>
                                <p>Enter full legal name, valid mobile contact, date of birth / age, gender, residential address, and active email.</p>
                                <div class="step-tip">
                                    <i class="bi bi-info-circle-fill"></i>
                                    <span><strong>Notice:</strong> An active email is essential because automated appointment confirmations and reminders are delivered directly to the patient inbox.</span>
                                </div>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Submit & Generate Medical File</strong>
                                <p>Click <strong>Register Patient</strong>. The system generates a permanent patient reference ID and redirects to Patient Management.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 2. Dentist Availability Check -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-calendar2-range"></i></div>
                        <h3>SOP 2: Checking Dentist Availability & Schedules</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Open Doctor Availability Module</strong>
                                <p>Go to <strong>Dentists &rarr; Check Availability</strong> in the navigation sidebar.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Filter by Doctor and Selected Date</strong>
                                <p>Pick the desired dental specialist and select the target date on the interactive calendar.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Review Active Slots</strong>
                                <p>Available time windows will be indicated in green chips, while already booked consultation slots are highlighted in gray with reserved tags.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3. Booking an Appointment -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-calendar-check"></i></div>
                        <h3>SOP 3: Booking an Appointment</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Access Booking Interface</strong>
                                <p>Click <strong>Appointments &rarr; Book Appointment</strong>.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Select Patient & Primary Dentist</strong>
                                <p>Choose the registered patient from the search dropdown, followed by the assigned dentist and desired date.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Choose Time Slot & Treatment Purpose</strong>
                                <p>Click a 30-minute available slot. Select the reason for visit (e.g. Regular Checkup, Cleaning, Root Canal, Orthodontic Consultation).</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">4</div>
                            <div class="step-content">
                                <strong>Confirm & Dispatch Notification</strong>
                                <p>Click <strong>Book Appointment</strong>. The calendar slot is locked immediately and a confirmation email is dispatched.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 4. Rescheduling and Cancellations -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-arrow-repeat"></i></div>
                        <h3>SOP 4: Rescheduling & Cancelling Patient Visits</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Search Appointment Record</strong>
                                <p>Go to <strong>Appointments &rarr; View Appointments</strong>. Use the live filter box to search by Patient Name, Phone, or Appointment ID.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>To Reschedule:</strong>
                                <p>Click the orange <strong>Reschedule</strong> button on the corresponding row. Select a new date and available slot, specify the reason, and confirm.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>To Cancel:</strong>
                                <p>Click the red <strong>Cancel</strong> button. Confirm the dialog prompt. The time slot is freed instantly and updated on the dashboard schedule.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Clinic Policies -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-shield-check"></i></div>
                        <h3>Important Clinic Policies & Guidelines</h3>
                    </div>
                    <div class="policies-grid">
                        <div class="policy-card">
                            <h4><i class="bi bi-clock-history"></i> Walk-In Patient Protocol</h4>
                            <p>Walk-in patients must first be registered in the system. Check the doctor availability roster for immediate open gaps before assigning an emergency slot.</p>
                        </div>
                        <div class="policy-card">
                            <h4><i class="bi bi-bell-fill"></i> 24-Hour Notice Policy</h4>
                            <p>Patients requesting cancellation or rescheduling are encouraged to provide at least 24 hours notice so open slots can be re-allocated to waiting patients.</p>
                        </div>
                    </div>
                </div>

            </div>

        </section>

    </main>

</div>

</body>
</html>
