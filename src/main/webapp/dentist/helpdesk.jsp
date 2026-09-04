<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }
    String docStaffLabel = "Dr. " + staffName.replaceAll("^(?i)dr\\.?\\s*", "").trim();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dentist Help Desk & Clinical Handbook | Sunrise Dental Clinic</title>

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

            <a href="${pageContext.request.contextPath}/dentist/helpdesk.jsp" class="nav-item active">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="${pageContext.request.contextPath}/dentist/profile" class="nav-item">
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
                <h1>Dentist Help Desk & Clinical Guide</h1>
                <p>Clinical Operating Protocols & Doctor Workflow Documentation</p>
            </div>
            <div class="topbar-right">
                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= docStaffLabel %></strong>
                        <span>Dental Specialist</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- HELPDESK CONTENT -->
        <section class="helpdesk-content">

            <!-- Hero Help Banner -->
            <div class="help-hero-card">
                <div class="help-hero-text">
                    <h2>Clinical Practitioner System Handbook</h2>
                    <p>
                        Comprehensive reference manual for dental surgeons. Follow these standard clinical operating procedures to manage your consultation schedule, access patient diagnostic histories, and log treatment records efficiently.
                    </p>
                </div>
                <i class="bi bi-hospital" style="font-size: 55px; opacity: 0.85;"></i>
            </div>

            <!-- Quick Action Jump Shortcuts -->
            <div class="quick-actions-bar">
                <a href="${pageContext.request.contextPath}/dentist/appointments" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-calendar-check-fill"></i>
                    </div>
                    <div class="action-text">
                        <strong>Today's Schedule</strong>
                        <span>View patient queue</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/dentist/availability" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <div class="action-text">
                        <strong>My Availability</strong>
                        <span>Configure consultation hours</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/dentist/patients" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-person-lines-fill"></i>
                    </div>
                    <div class="action-text">
                        <strong>Patient Records</strong>
                        <span>Medical files & X-rays</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/dentist/treatment-history" class="action-card">
                    <div class="action-icon">
                        <i class="bi bi-journal-medical"></i>
                    </div>
                    <div class="action-text">
                        <strong>Treatment Log</strong>
                        <span>Review clinical cases</span>
                    </div>
                </a>
            </div>

            <!-- Standard Operating Procedures -->
            <div class="procedures-grid">

                <!-- 1. Availability Management -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-calendar2-range"></i></div>
                        <h3>SOP 1: Configuring Doctor Consultation Hours & Working Slots</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Access the Availability Manager</strong>
                                <p>Click <strong>My Availability</strong> from the main navigation sidebar.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Define Consultation Windows</strong>
                                <p>Select the date, start time (e.g. 09:00 AM), end time (e.g. 01:00 PM), slot capacity (usually 1 patient per 30-minute block), and assigned room number.</p>
                                <div class="step-tip">
                                    <i class="bi bi-info-circle-fill"></i>
                                    <span><strong>Clinic Rule:</strong> Configured slots automatically break down into 30-minute appointment slots for the front-desk booking system.</span>
                                </div>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Save & Publish to Reception Roster</strong>
                                <p>Click <strong>Save Availability Slot</strong>. The front desk can instantly book appointments during your newly configured hours.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 2. Patient Consultations & Appointment Status -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-person-check"></i></div>
                        <h3>SOP 2: Managing Daily Appointments & Patient Flow</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Review Today's Patient Queue</strong>
                                <p>Go to <strong>My Appointments</strong> to view all scheduled patients for today sorted chronologically.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Start Consultation</strong>
                                <p>Click the appointment card or action button to open the consultation workspace and view the patient's medical history.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Complete Session</strong>
                                <p>Once treatment is finished, mark the appointment as <strong>COMPLETED</strong> so the billing department can generate the invoice.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3. Logging Treatments and Prescriptions -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-prescription2"></i></div>
                        <h3>SOP 3: Documenting Diagnosis, Procedures & Prescriptions</h3>
                    </div>
                    <div class="steps-list">
                        <div class="step-item">
                            <div class="step-badge">1</div>
                            <div class="step-content">
                                <strong>Enter Clinical Diagnosis</strong>
                                <p>Select the primary condition (e.g. Dental Caries, Pulpitis, Gingivitis, Malocclusion) and specify tooth quadrant numbers.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">2</div>
                            <div class="step-content">
                                <strong>Prescribe Medications</strong>
                                <p>Input required pharmaceutical items with exact dosages (e.g., Amoxicillin 500mg TDS, Ibuprofen 400mg PRN) and treatment duration.</p>
                            </div>
                        </div>
                        <div class="step-item">
                            <div class="step-badge">3</div>
                            <div class="step-content">
                                <strong>Save to Patient Treatment History</strong>
                                <p>Submit the record. It is archived permanently under <strong>Treatment History</strong> and linked to the patient's file.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Clinical Guidelines -->
                <div class="procedure-card">
                    <div class="procedure-header">
                        <div class="badge-icon"><i class="bi bi-shield-check"></i></div>
                        <h3>Clinical Safety & Protocol Reminders</h3>
                    </div>
                    <div class="policies-grid">
                        <div class="policy-card">
                            <h4><i class="bi bi-heart-pulse-fill"></i> Pre-Existing Medical Alerts</h4>
                            <p>Always review cardiac histories, hypertension, and drug allergies (e.g. Penicillin, NSAIDs) before administering local anesthesia.</p>
                        </div>
                        <div class="policy-card">
                            <h4><i class="bi bi-clipboard2-pulse"></i> Post-Operative Follow-Ups</h4>
                            <p>For surgical extractions or endodontic treatments, advise patients on standard follow-up checkup windows (typically 7-14 days).</p>
                        </div>
                    </div>
                </div>

            </div>

        </section>

    </main>

</div>

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>
</body>
</html>
