<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.Treatment" %>
<%@ page import="com.sunrise.dental.model.PatientReport" %>

<%

    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Dentist";
    }

    Dentist loggedInDentist =
            (Dentist) request.getAttribute(
                    "loggedInDentist"
            );

    Appointment appointment =
            (Appointment) request.getAttribute(
                    "appointment"
            );

    Patient patient =
            (Patient) request.getAttribute(
                    "patient"
            );

    Treatment treatment =
            (Treatment) request.getAttribute(
                    "treatment"
            );

    List<Treatment> treatmentHistory =
            (List<Treatment>) request.getAttribute(
                    "treatmentHistory"
            );

    List<PatientReport> reports =
            (List<PatientReport>) request.getAttribute(
                    "reports"
            );

    if (treatmentHistory == null) {
        treatmentHistory =
                java.util.Collections.emptyList();
    }

    if (reports == null) {
        reports =
                java.util.Collections.emptyList();
    }

    if (appointment == null || patient == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/dentist/appointments"
        );

        return;
    }

    String dentistName =
            loggedInDentist != null
                    && loggedInDentist.getName() != null
                    ? loggedInDentist.getName()
                    : staffName;

    String status =
            appointment.getStatus() != null
                    ? appointment.getStatus()
                    : "UNKNOWN";

    String statusClass =
            status.toLowerCase()
                    .replace(" ", "-");

    SimpleDateFormat dateFormat =
            new SimpleDateFormat(
                    "EEEE, MMMM d, yyyy"
            );

    SimpleDateFormat timeFormat =
            new SimpleDateFormat(
                    "hh:mm a"
            );

    String appointmentDate =
            appointment.getAppointmentDate() != null
                    ? dateFormat.format(
                            appointment.getAppointmentDate()
                    )
                    : "-";

    String appointmentTime =
            appointment.getStartTime() != null
                    && appointment.getEndTime() != null
                    ? timeFormat.format(
                            appointment.getStartTime()
                    )
                    + " - "
                    + timeFormat.format(
                            appointment.getEndTime()
                    )
                    : "-";

    String diagnosis =
            treatment != null
                    && treatment.getDiagnosis() != null
                    ? treatment.getDiagnosis()
                    : "";

    String treatmentProvided =
            treatment != null
                    && treatment.getTreatmentProvided() != null
                    ? treatment.getTreatmentProvided()
                    : "";

    String treatmentNotes =
            treatment != null
                    && treatment.getTreatmentNotes() != null
                    ? treatment.getTreatmentNotes()
                    : "";

    String nextAppointmentDate =
            treatment != null
                    && treatment.getNextAppointmentDate() != null
                    ? treatment.getNextAppointmentDate()
                            .toString()
                    : "";

    String success =
            request.getParameter("success");

    String error =
            request.getParameter("error");

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        Appointment Details | Sunrise Dental Clinic
    </title>

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/reception.css"
    >

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    >

    <link
        rel="preconnect"
        href="https://fonts.googleapis.com"
    >

    <link
        rel="preconnect"
        href="https://fonts.gstatic.com"
        crossorigin
    >

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <style>

        .details-page {
            padding-bottom: 40px;
        }

        .details-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 22px;
        }

        .details-header h2 {
            margin: 0;
            color: #173b4d;
            font-size: 24px;
            font-weight: 700;
        }

        .details-header p {
            margin: 5px 0 0;
            color: #78909c;
            font-size: 13px;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 10px 15px;
            border-radius: 10px;
            background: #edfafd;
            color: #079eb5;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
        }

        .back-button:hover {
            background: #079eb5;
            color: #ffffff;
        }

        .alert {
            padding: 13px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .alert-success {
            background: #eaf8ef;
            color: #16844a;
            border: 1px solid #c9ecd7;
        }

        .alert-error {
            background: #fdecec;
            color: #d53a3a;
            border: 1px solid #f5caca;
        }

        .appointment-summary {
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .details-card {
            background: #ffffff;
            border: 1px solid #edf2f4;
            border-radius: 16px;
            padding: 23px;
            box-shadow:
                0 6px 22px rgba(
                    35,
                    82,
                    101,
                    0.06
                );
        }

        .card-heading {
            display: flex;
            align-items: center;
            gap: 11px;
            margin-bottom: 19px;
        }

        .card-heading-icon {
            width: 39px;
            height: 39px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 11px;
            background: #edfafd;
            color: #079eb5;
        }

        .card-heading h3 {
            margin: 0;
            color: #173b4d;
            font-size: 16px;
            font-weight: 650;
        }

        .card-heading span {
            display: block;
            margin-top: 2px;
            color: #91a4ad;
            font-size: 10px;
        }

        .patient-profile {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 18px;
            border-bottom: 1px solid #edf2f4;
        }

        .patient-avatar-large {
            width: 58px;
            height: 58px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #eaf8fb;
            color: #079eb5;
            font-weight: 700;
            font-size: 18px;
        }

        .patient-profile h3 {
            margin: 0;
            color: #294b5c;
            font-size: 17px;
        }

        .patient-profile span {
            display: block;
            margin-top: 3px;
            color: #91a4ad;
            font-size: 11px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .info-item label {
            display: block;
            margin-bottom: 4px;
            color: #91a4ad;
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: .4px;
            font-weight: 600;
        }

        .info-item strong {
            color: #45606e;
            font-size: 12px;
            font-weight: 600;
            white-space: pre-line;
        }

        .appointment-hero {
            padding: 23px;
            border-radius: 16px;
            background:
                linear-gradient(
                    135deg,
                    rgba(14,157,179,.96),
                    rgba(55,91,105,.96)
                );
            color: #ffffff;
            box-shadow:
                0 10px 25px rgba(
                    20,
                    87,
                    103,
                    .14
                );
        }

        .appointment-hero-top {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            align-items: flex-start;
            margin-bottom: 22px;
        }

        .appointment-hero small {
            opacity: .75;
            font-size: 10px;
        }

        .appointment-hero h3 {
            margin: 3px 0 0;
            font-size: 20px;
        }

        .hero-status {
            padding: 7px 11px;
            border-radius: 20px;
            background: rgba(255,255,255,.16);
            font-size: 10px;
            font-weight: 600;
        }

        .hero-time {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 15px;
            border-radius: 12px;
            background: rgba(255,255,255,.10);
            margin-bottom: 15px;
        }

        .hero-time i {
            font-size: 20px;
        }

        .hero-time strong {
            display: block;
            font-size: 14px;
        }

        .hero-time span {
            display: block;
            margin-top: 2px;
            opacity: .7;
            font-size: 10px;
        }

        .hero-reason {
            padding-top: 15px;
            border-top: 1px solid rgba(255,255,255,.16);
        }

        .hero-reason span {
            display: block;
            opacity: .65;
            font-size: 10px;
            margin-bottom: 3px;
        }

        .hero-reason strong {
            font-size: 12px;
        }

        .details-two-column {
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #45606e;
            font-size: 11px;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            box-sizing: border-box;
            padding: 11px 12px;
            border: 1px solid #dce7eb;
            border-radius: 9px;
            outline: none;
            font-family: Poppins, sans-serif;
            font-size: 11px;
            color: #294b5c;
            background: #fbfdfe;
            resize: vertical;
        }

        .form-control:focus {
            border-color: #079eb5;
            box-shadow:
                0 0 0 3px rgba(
                    7,
                    158,
                    181,
                    .08
                );
        }

        textarea.form-control {
            min-height: 88px;
        }

        .treatment-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .primary-button {
            border: none;
            border-radius: 9px;
            padding: 11px 17px;
            background: #079eb5;
            color: #ffffff;
            font-family: Poppins, sans-serif;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
        }

        .primary-button:hover {
            background: #078ba0;
        }

        .status-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 9px;
        }

        .status-button {
            border: none;
            padding: 10px;
            border-radius: 9px;
            background: #edfafd;
            color: #079eb5;
            font-family: Poppins, sans-serif;
            font-size: 10px;
            font-weight: 600;
            cursor: pointer;
        }

        .status-button:hover {
            background: #079eb5;
            color: #ffffff;
        }

        .status-button.completed {
            background: #eaf8ef;
            color: #16844a;
        }

        .status-button.completed:hover {
            background: #16844a;
            color: #ffffff;
        }

        .status-button.cancelled {
            background: #fdecec;
            color: #d53a3a;
        }

        .status-button.cancelled:hover {
            background: #d53a3a;
            color: #ffffff;
        }

        .history-table {
            width: 100%;
            border-collapse: collapse;
        }

        .history-table th {
            padding: 10px;
            text-align: left;
            background: #f7fafb;
            color: #78909c;
            font-size: 9px;
            text-transform: uppercase;
        }

        .history-table td {
            padding: 12px 10px;
            border-bottom: 1px solid #edf2f4;
            color: #45606e;
            font-size: 10px;
            vertical-align: top;
        }

        .report-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 13px 0;
            border-bottom: 1px solid #edf2f4;
        }

        .report-item:last-child {
            border-bottom: none;
        }

        .report-icon {
            width: 37px;
            height: 37px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background: #edfafd;
            color: #079eb5;
            flex-shrink: 0;
        }

        .report-content {
            flex: 1;
        }

        .report-content strong {
            display: block;
            color: #294b5c;
            font-size: 11px;
        }

        .report-content span {
            display: block;
            margin-top: 3px;
            color: #91a4ad;
            font-size: 9px;
        }

        .report-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 7px 10px;
            border-radius: 7px;
            background: #f1f7f9;
            color: #079eb5;
            text-decoration: none;
            font-size: 9px;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 30px 10px;
            color: #91a4ad;
            font-size: 11px;
        }

        .empty-state i {
            display: block;
            margin-bottom: 8px;
            font-size: 28px;
            color: #bdcdd3;
        }

        .danger-zone {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #edf2f4;
        }

        .danger-button {
            width: 100%;
            border: none;
            border-radius: 9px;
            padding: 11px;
            background: #fdecec;
            color: #d53a3a;
            font-family: Poppins, sans-serif;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
        }

        .danger-button:hover {
            background: #d53a3a;
            color: #ffffff;
        }

        @media (max-width: 900px) {

            .appointment-summary,
            .details-two-column {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {

            .details-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .info-grid,
            .treatment-grid {
                grid-template-columns: 1fr;
            }

            .details-card,
            .appointment-hero {
                padding: 17px;
            }
        }




/* =========================================================
   PATIENT REPORTS
   ========================================================= */

.reports-card {
    overflow: hidden;
}


/* ---------------------------------------------------------
   HEADER
   --------------------------------------------------------- */

.details-card-title {
    display: flex;
    align-items: center;
    gap: 14px;
}


.details-card-icon {
    width: 42px;
    height: 42px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 12px;

    background: #eaf9fc;
    color: #159bb1;

    flex-shrink: 0;
}


.details-card-icon i {
    font-size: 19px;
}


.details-card-title h3 {
    margin: 0;

    color: #17324d;

    font-size: 16px;
    font-weight: 700;
}


.details-card-title p {
    margin: 3px 0 0;

    color: #78909c;

    font-size: 12px;
}


/* ---------------------------------------------------------
   MESSAGES
   --------------------------------------------------------- */

.report-message {
    display: flex;

    align-items: flex-start;

    gap: 11px;

    margin: 0 0 18px;

    padding: 13px 15px;

    border-radius: 10px;
}


.report-message > i {
    font-size: 17px;

    margin-top: 1px;
}


.report-message div {
    display: flex;

    flex-direction: column;

    gap: 2px;
}


.report-message strong {
    font-size: 13px;
}


.report-message span {
    font-size: 12px;
}


.report-success {
    background: #edf9f3;

    border: 1px solid #ccebd9;

    color: #19794d;
}


.report-error {
    background: #fff1f1;

    border: 1px solid #f0cccc;

    color: #c23d3d;
}


/* ---------------------------------------------------------
   UPLOAD BOX
   --------------------------------------------------------- */

.report-upload-box {
    display: flex;

    align-items: flex-start;

    gap: 18px;

    padding: 20px;

    margin-bottom: 24px;

    background: #f7fcfd;

    border: 1px solid #d9eef3;

    border-radius: 13px;
}


.report-upload-icon {
    width: 46px;
    height: 46px;

    display: flex;

    align-items: center;
    justify-content: center;

    flex-shrink: 0;

    border-radius: 12px;

    background: #e4f7fa;

    color: #159bb1;
}


.report-upload-icon i {
    font-size: 21px;
}


.report-upload-content {
    flex: 1;

    min-width: 0;
}


.report-upload-content h4 {
    margin: 0 0 4px;

    color: #17324d;

    font-size: 14px;

    font-weight: 700;
}


.report-upload-content p {
    margin: 0 0 14px;

    color: #78909c;

    font-size: 12px;

    line-height: 1.5;
}


/* ---------------------------------------------------------
   FILE INPUT
   --------------------------------------------------------- */

.report-file-row {
    display: flex;

    align-items: center;

    gap: 10px;
}


.report-file-label {
    flex: 1;

    min-width: 0;

    height: 42px;

    display: flex;

    align-items: center;

    gap: 9px;

    padding: 0 13px;

    border: 1px solid #d5e5eb;

    border-radius: 9px;

    background: #ffffff;

    color: #607d8b;

    cursor: pointer;

    font-size: 12px;

    transition: 0.2s ease;
}


.report-file-label:hover {
    border-color: #159bb1;

    background: #fbfeff;

    color: #159bb1;
}


.report-file-label i {
    font-size: 16px;

    flex-shrink: 0;
}


.report-file-label span {
    overflow: hidden;

    text-overflow: ellipsis;

    white-space: nowrap;
}


.report-upload-form input[type="file"] {
    display: none;
}


.report-upload-button {
    height: 42px;

    padding: 0 17px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    border: none;

    border-radius: 9px;

    background: #159bb1;

    color: #ffffff;

    font-size: 12px;

    font-weight: 700;

    cursor: pointer;

    transition: 0.2s ease;
}


.report-upload-button:hover {
    background: #11889c;

    transform: translateY(-1px);
}


.report-upload-help {
    display: flex;

    align-items: center;

    gap: 5px;

    margin-top: 8px;

    color: #91a0ad;

    font-size: 10.5px;
}


/* ---------------------------------------------------------
   UPLOADED REPORTS
   --------------------------------------------------------- */

.uploaded-reports-heading {
    display: flex;

    align-items: center;

    justify-content: space-between;

    margin-bottom: 10px;
}


.uploaded-reports-heading h4 {
    margin: 0;

    color: #17324d;

    font-size: 13px;

    font-weight: 700;
}


.uploaded-reports-heading span {
    display: inline-flex;

    margin-left: 7px;

    padding: 3px 7px;

    border-radius: 20px;

    background: #edf8fa;

    color: #159bb1;

    font-size: 10px;

    font-weight: 700;
}


/* ---------------------------------------------------------
   EMPTY STATE
   --------------------------------------------------------- */

.reports-empty {
    display: flex;

    align-items: center;

    justify-content: center;

    flex-direction: column;

    min-height: 130px;

    padding: 25px 20px;

    border: 1px dashed #d7e7ec;

    border-radius: 11px;

    background: #fbfdfe;

    text-align: center;
}


.reports-empty-icon {
    width: 42px;
    height: 42px;

    display: flex;

    align-items: center;
    justify-content: center;

    margin-bottom: 8px;

    border-radius: 11px;

    background: #f0f7f9;

    color: #9bb0ba;
}


.reports-empty-icon i {
    font-size: 19px;
}


.reports-empty strong {
    margin-bottom: 3px;

    color: #607d8b;

    font-size: 12px;
}


.reports-empty span {
    color: #9aaab2;

    font-size: 10.5px;
}


/* ---------------------------------------------------------
   REPORT LIST
   --------------------------------------------------------- */

.report-list {
    display: flex;

    flex-direction: column;

    gap: 8px;
}


.report-item {
    display: flex;

    align-items: center;

    gap: 12px;

    padding: 12px 13px;

    border: 1px solid #e3edf1;

    border-radius: 10px;

    background: #ffffff;

    transition: 0.2s ease;
}


.report-item:hover {
    border-color: #c9e5eb;

    box-shadow: 0 4px 14px rgba(20, 80, 100, 0.06);
}


.report-item-icon {
    width: 39px;
    height: 39px;

    display: flex;

    align-items: center;
    justify-content: center;

    flex-shrink: 0;

    border-radius: 9px;

    background: #edf8fa;

    color: #159bb1;
}


.report-item-icon i {
    font-size: 17px;
}


.report-item-information {
    flex: 1;

    min-width: 0;

    display: flex;

    flex-direction: column;

    gap: 3px;
}


.report-item-information strong {
    overflow: hidden;

    text-overflow: ellipsis;

    white-space: nowrap;

    color: #304d5e;

    font-size: 12px;

    font-weight: 700;
}


.report-item-information > span {
    color: #91a0ad;

    font-size: 10px;
}


.report-dot {
    margin: 0 5px;

    color: #c2cdd2;
}


.report-item-actions {
    flex-shrink: 0;
}


.report-action {
    min-width: 68px;

    height: 32px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 5px;

    padding: 0 10px;

    border-radius: 8px;

    text-decoration: none;

    font-size: 10.5px;

    font-weight: 700;
}


.report-view {
    background: #edf8fa;

    color: #159bb1;
}


.report-view:hover {
    background: #159bb1;

    color: #ffffff;
}


/* ---------------------------------------------------------
   RESPONSIVE
   --------------------------------------------------------- */

@media (max-width: 700px) {

    .report-upload-box {
        flex-direction: column;
    }


    .report-file-row {
        flex-direction: column;

        align-items: stretch;
    }


    .report-file-label {
        width: 100%;
    }


    .report-upload-button {
        width: 100%;
    }


    .report-item {
        align-items: flex-start;
    }


    .report-item-actions {
        margin-left: auto;
    }


    .report-action span {
        display: none;
    }


    .report-action {
        min-width: 34px;

        width: 34px;

        padding: 0;
    }
}
    </style>

</head>

<body>

<div class="dashboard-container">

    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside
        class="sidebar"
        id="sidebar"
    >

        <div class="sidebar-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
                alt="Sunrise Dental Clinic Logo"
            >

            <div class="brand-text">

                <h2>Sunrise</h2>

                <span>Dental Clinic</span>

            </div>

        </div>

        <nav class="sidebar-navigation">

            <p class="navigation-title">
                MAIN
            </p>

            <a
                href="${pageContext.request.contextPath}/dentist/dashboard"
                class="nav-item"
            >
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a
                href="${pageContext.request.contextPath}/dentist/appointments"
                class="nav-item active"
            >
                <i class="bi bi-calendar-check"></i>
                <span>My Appointments</span>
            </a>

            <div class="nav-group">

                <button
                    type="button"
                    class="nav-item nav-parent"
                    onclick="this.parentElement.classList.toggle('open')"
                >

                    <span class="nav-item-left">

                        <i class="bi bi-people"></i>

                        <span>My Patients</span>

                    </span>

                    <i class="bi bi-chevron-down nav-chevron"></i>

                </button>

                <div class="nav-submenu">

                    <a
                        href="${pageContext.request.contextPath}/dentist/patients"
                        class="nav-subitem"
                    >
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Patient Records</span>
                    </a>

                    <a
                        href="${pageContext.request.contextPath}/dentist/treatment-history"
                        class="nav-subitem"
                    >
                        <i class="bi bi-clock-history"></i>
                        <span>Treatment History</span>
                    </a>

                </div>

            </div>

            <a
                href="${pageContext.request.contextPath}/dentist/availability"
                class="nav-item"
            >
                <i class="bi bi-calendar2-week"></i>
                <span>My Availability</span>
            </a>

            <p class="navigation-title clinic-title">
                CLINIC
            </p>

            <a
                href="${pageContext.request.contextPath}/dentist/helpdesk.jsp"
                class="nav-item"
            >
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>

        </nav>

        <div class="sidebar-bottom">

            <p class="navigation-title">
                ACCOUNT
            </p>

            <a
                href="${pageContext.request.contextPath}/dentist/profile"
                class="nav-item"
            >
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>

            <a
                href="${pageContext.request.contextPath}/logout"
                class="nav-item logout-item"
            >
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>

        </div>

    </aside>

    <!-- =====================================================
         MAIN
         ===================================================== -->

    <main class="main-content">

        <header class="topbar">

            <div class="topbar-left">

                <button
                    type="button"
                    class="menu-button"
                    id="menuButton"
                >
                    <i class="bi bi-list"></i>
                </button>

                <div>

                    <h1>
                        Appointment Details
                    </h1>

                    <p>
                        Review the patient's appointment and clinical information.
                    </p>

                </div>

            </div>

            <div class="topbar-right">

                <button
                    type="button"
                    class="icon-button"
                    title="Notifications"
                >
                    <i class="bi bi-bell"></i>
                </button>

                <div class="user-profile">

                    <div class="user-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>

                    <div class="user-information">

                        <strong>
                            <%= dentistName %>
                        </strong>

                        <span>
                            Dentist
                        </span>

                    </div>

                    <i class="bi bi-chevron-down profile-arrow"></i>

                </div>

            </div>

        </header>

        <section class="dashboard-content details-page">

           

            <% if ("status".equalsIgnoreCase(success)) { %>

                <div class="alert alert-success">
                    Appointment status updated successfully.
                </div>

            <% } else if ("treatment".equalsIgnoreCase(success)) { %>

                <div class="alert alert-success">
                    Treatment record saved successfully and the appointment was marked as completed.
                </div>

            <% } else if ("status".equalsIgnoreCase(error)) { %>

                <div class="alert alert-error">
                    Unable to update the appointment status.
                </div>

            <% } else if ("treatment".equalsIgnoreCase(error)) { %>

                <div class="alert alert-error">
                    Unable to save the treatment record.
                </div>

            <% } else if ("cancel".equalsIgnoreCase(error)) { %>

                <div class="alert alert-error">
                    Unable to cancel this appointment.
                </div>

            <% } %>


            <!-- =================================================
                 APPOINTMENT + PATIENT
                 ================================================= -->

            <div class="appointment-summary">

                <!-- PATIENT -->

                <section class="details-card">

                    <div class="card-heading">

                        <div class="card-heading-icon">
                            <i class="bi bi-person"></i>
                        </div>

                        <div>

                            <h3>
                                Patient Information
                            </h3>

                            <span>
                                Registered patient details
                            </span>

                        </div>

                    </div>

                    <div class="patient-profile">

                        <div class="patient-avatar-large">

                            <%
                                String[] nameParts =
                                        patient.getName()
                                                .trim()
                                                .split("\\s+");

                                String initials = "P";

                                if (nameParts.length >= 2) {

                                    initials =
                                            (
                                                nameParts[0]
                                                    .substring(0, 1)
                                                +
                                                nameParts[
                                                    nameParts.length - 1
                                                ].substring(0, 1)
                                            ).toUpperCase();

                                } else if (
                                        patient.getName().length() >= 2
                                ) {

                                    initials =
                                            patient.getName()
                                                .substring(0, 2)
                                                .toUpperCase();
                                }
                            %>

                            <%= initials %>

                        </div>

                        <div>

                            <h3>
                                <%= patient.getName() %>
                            </h3>

                            <span>
                                <%= patient.getPatientNumber() %>
                            </span>

                        </div>

                    </div>

                    <div class="info-grid">

                        <div class="info-item">

                            <label>
                                Date of Birth
                            </label>

                            <strong>
                                <i class="bi bi-calendar2-date" style="color: #0ea5b4; margin-right: 4px;"></i>
                                <%= (patient.getDateOfBirth() != null)
                                        ? patient.getDateOfBirth().toString()
                                        : "<span style='color:#94a3b8; font-weight:normal;'>Not provided</span>" %>
                            </strong>

                        </div>

                        <div class="info-item">

                            <label>
                                Contact Number
                            </label>

                            <strong>
                                <%= patient.getContactNumber() %>
                            </strong>

                        </div>

                        <div class="info-item">

                            <label>
                                Email
                            </label>

                            <strong>
                                <%= patient.getEmail() != null
                                        ? patient.getEmail()
                                        : "-" %>
                            </strong>

                        </div>

                        <div class="info-item">

                            <label>
                                Address
                            </label>

                            <strong>
                                <%= patient.getAddress() %>
                            </strong>

                        </div>

                        <div class="info-item">

                            <label>
                                Patient Status
                            </label>

                            <strong>
                                <%= patient.getStatus() %>
                            </strong>

                        </div>

                    </div>

                </section>


                <!-- APPOINTMENT -->

                <section class="appointment-hero">

                    <div class="appointment-hero-top">

                        <div>

                            <small>
                                APPOINTMENT NUMBER
                            </small>

                            <h3>
                                <%= appointment.getAppointmentNumber() %>
                            </h3>

                        </div>

                        <span class="hero-status">
                            <%= status %>
                        </span>

                    </div>

                    <div class="hero-time">

                        <i class="bi bi-calendar-check"></i>

                        <div>

                            <strong>
                                <%= appointmentDate %>
                            </strong>

                            <span>
                                <%= appointmentTime %>
                            </span>

                        </div>

                    </div>

                    <div class="hero-reason">

                        <span>
                            APPOINTMENT REASON
                        </span>

                        <strong>
                            <%= appointment.getReason() != null
                                    ? appointment.getReason()
                                    : "General Appointment" %>
                        </strong>

                    </div>

                </section>

            </div>


            <!-- =================================================
                 TREATMENT + STATUS
                 ================================================= -->

            <div class="details-two-column">

                <!-- TREATMENT -->

                <section class="details-card">

                    <div class="card-heading">

                        <div class="card-heading-icon">
                            <i class="bi bi-journal-medical"></i>
                        </div>

                        <div>

                            <h3>
                                Clinical Treatment
                            </h3>

                            <span>
                                Add or update treatment information
                            </span>

                        </div>

                    </div>

                    <form
                        method="post"
                        action="${pageContext.request.contextPath}/dentist/appointment-details"
                    >

                        <input
                            type="hidden"
                            name="action"
                            value="treatment"
                        >

                        <input
                            type="hidden"
                            name="appointmentId"
                            value="<%= appointment.getAppointmentId() %>"
                        >

                        <div class="form-group">

                            <label>
                                Diagnosis
                            </label>

                            <textarea
                                class="form-control"
                                name="diagnosis"
                                placeholder="Enter diagnosis..."
                            ><%= diagnosis %></textarea>

                        </div>

                        <div class="form-group">

                            <label>
                                Treatment Provided
                            </label>

                            <textarea
                                class="form-control"
                                name="treatmentProvided"
                                placeholder="Describe the treatment provided..."
                            ><%= treatmentProvided %></textarea>

                        </div>

                        <div class="form-group">

                            <label>
                                Clinical Notes
                            </label>

                            <textarea
                                class="form-control"
                                name="treatmentNotes"
                                placeholder="Enter additional clinical notes..."
                            ><%= treatmentNotes %></textarea>

                        </div>

                        <div class="form-group">

                            <label>
                                Next Appointment Date
                            </label>

                            <input
                                type="date"
                                class="form-control"
                                name="nextAppointmentDate"
                                value="<%= nextAppointmentDate %>"
                            >

                        </div>

                        <button
                            type="submit"
                            class="primary-button"
                        >
                            <i class="bi bi-save"></i>
                            Save Treatment Record
                        </button>

                    </form>

                </section>


                <!-- STATUS -->

                <section class="details-card">

                    <div class="card-heading">

                        <div class="card-heading-icon">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>

                        <div>

                            <h3>
                                Appointment Status
                            </h3>

                            <span>
                                Update the current clinical status
                            </span>

                        </div>

                    </div>

                    <div class="status-actions">

                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/dentist/appointment-details"
                        >

                            <input
                                type="hidden"
                                name="action"
                                value="status"
                            >

                            <input
                                type="hidden"
                                name="appointmentId"
                                value="<%= appointment.getAppointmentId() %>"
                            >

                            <input
                                type="hidden"
                                name="status"
                                value="PENDING"
                            >

                            <button
                                type="submit"
                                class="status-button"
                            >
                                Pending
                            </button>

                        </form>


                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/dentist/appointment-details"
                        >

                            <input
                                type="hidden"
                                name="action"
                                value="status"
                            >

                            <input
                                type="hidden"
                                name="appointmentId"
                                value="<%= appointment.getAppointmentId() %>"
                            >

                            <input
                                type="hidden"
                                name="status"
                                value="CONFIRMED"
                            >

                            <button
                                type="submit"
                                class="status-button"
                            >
                                Confirmed
                            </button>

                        </form>


                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/dentist/appointment-details"
                        >

                            <input
                                type="hidden"
                                name="action"
                                value="status"
                            >

                            <input
                                type="hidden"
                                name="appointmentId"
                                value="<%= appointment.getAppointmentId() %>"
                            >

                            <input
                                type="hidden"
                                name="status"
                                value="IN-PROGRESS"
                            >

                            <button
                                type="submit"
                                class="status-button"
                            >
                                In Progress
                            </button>

                        </form>


                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/dentist/appointment-details"
                        >

                            <input
                                type="hidden"
                                name="action"
                                value="status"
                            >

                            <input
                                type="hidden"
                                name="appointmentId"
                                value="<%= appointment.getAppointmentId() %>"
                            >

                            <input
                                type="hidden"
                                name="status"
                                value="COMPLETED"
                            >

                            <button
                                type="submit"
                                class="status-button completed"
                            >
                                Completed
                            </button>

                        </form>

                    </div>

                    <div class="danger-zone">

                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/dentist/appointment-details"
                            onsubmit="return confirmCancel();"
                        >

                            <input
                                type="hidden"
                                name="action"
                                value="cancel"
                            >

                            <input
                                type="hidden"
                                name="appointmentId"
                                value="<%= appointment.getAppointmentId() %>"
                            >

                            <button
                                type="submit"
                                class="danger-button"
                            >
                                <i class="bi bi-x-circle"></i>
                                Cancel Appointment
                            </button>

                        </form>

                    </div>

                </section>

            </div>


            <!-- =================================================
                 TREATMENT HISTORY
                 ================================================= -->

            <section class="details-card">

                <div class="card-heading">

                    <div class="card-heading-icon">
                        <i class="bi bi-clock-history"></i>
                    </div>

                    <div>

                        <h3>
                            Patient Treatment History
                        </h3>

                        <span>
                            Previous treatment records for this patient
                        </span>

                    </div>

                </div>

                <% if (treatmentHistory.isEmpty()) { %>

                    <div class="empty-state">

                        <i class="bi bi-journal-x"></i>

                        No previous treatment records found.

                    </div>

                <% } else { %>

                    <div style="overflow-x:auto;">

                        <table class="history-table">

                            <thead>

                            <tr>

                                <th>
                                    Date
                                </th>

                                <th>
                                    Diagnosis
                                </th>

                                <th>
                                    Treatment
                                </th>

                                <th>
                                    Notes
                                </th>

                            </tr>

                            </thead>

                            <tbody>

                            <% for (
                                    Treatment history :
                                    treatmentHistory
                            ) { %>

                                <tr>

                                    <td>
                                        <%= history.getCreatedAt() != null
                                                ? history.getCreatedAt()
                                                : "-" %>
                                    </td>

                                    <td>
                                        <%= history.getDiagnosis() != null
                                                ? history.getDiagnosis()
                                                : "-" %>
                                    </td>

                                    <td>
                                        <%= history.getTreatmentProvided() != null
                                                ? history.getTreatmentProvided()
                                                : "-" %>
                                    </td>

                                    <td>
                                        <%= history.getTreatmentNotes() != null
                                                ? history.getTreatmentNotes()
                                                : "-" %>
                                    </td>

                                </tr>

                            <% } %>

                            </tbody>

                        </table>

                    </div>

                <% } %>

            </section>


            <!-- ========================================================= -->
<!-- PATIENT REPORTS -->
<!-- ========================================================= -->

<section class="details-card reports-card">

    <div class="details-card-header">

        <div class="details-card-title">

            <div class="details-card-icon">
                <i class="bi bi-file-earmark-medical"></i>
            </div>

            <div>

                <h3>
                    Patient Reports
                </h3>

                <p>
                    Upload and manage reports attached to this appointment
                </p>

            </div>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SUCCESS MESSAGE -->
    <!-- ===================================================== -->

   <% if ("report".equalsIgnoreCase(success)) { %>

    <div class="report-message report-success">

        <i class="bi bi-check-circle-fill"></i>

        <div>

            <strong>
                Report uploaded successfully
            </strong>

            <span>
                The report has been attached to this appointment.
            </span>

        </div>

    </div>

<% } %>


    <!-- ===================================================== -->
    <!-- ERROR MESSAGE -->
    <!-- ===================================================== -->

    <% if (error != null
        && error.startsWith("report-")) { %>

    <div class="report-message report-error">

        <i class="bi bi-exclamation-circle-fill"></i>

        <div>

            <strong>
                Unable to upload report
            </strong>

            <span>

                <% if ("report-nofile".equals(error)) { %>

                    Please select a report file.

                <% } else if ("report-type".equals(error)) { %>

                    Only PDF, JPG, JPEG and PNG files are allowed.

                <% } else if ("report-size".equals(error)) { %>

                    The selected file is too large. Maximum size is 10 MB.

                <% } else if ("report-database".equals(error)) { %>

                    The file could not be saved to the database.

                <% } else if ("report-notfound".equals(error)) { %>

                    The appointment could not be found.

                <% } else { %>

                    Something went wrong while uploading the report.

                <% } %>

            </span>

        </div>

    </div>

<% } %>


    <!-- ===================================================== -->
    <!-- UPLOAD REPORT -->
    <!-- ===================================================== -->

    <div class="report-upload-box">

        <div class="report-upload-icon">

            <i class="bi bi-cloud-arrow-up"></i>

        </div>


        <div class="report-upload-content">

            <h4>
                Upload Patient Report
            </h4>

            <p>
                Add X-rays, laboratory reports, scans or other
                supporting medical documents for this appointment.
            </p>


            <form
                action="${pageContext.request.contextPath}/dentist/upload-report"
                method="post"
                enctype="multipart/form-data"
                class="report-upload-form"
            >

                <input
                    type="hidden"
                    name="appointmentId"
                    value="<%= appointment.getAppointmentId() %>"
                >


                <div class="report-file-row">

                    <label
                        for="reportFile"
                        class="report-file-label"
                    >

                        <i class="bi bi-file-earmark-arrow-up"></i>

                        <span id="reportFileName">
                            Choose report file
                        </span>

                    </label>


                    <input
                        type="file"
                        id="reportFile"
                        name="reportFile"
                        accept=".pdf,.jpg,.jpeg,.png"
                        required
                    >


                    <button
                        type="submit"
                        class="report-upload-button"
                    >

                        <i class="bi bi-cloud-upload"></i>

                        Upload Report

                    </button>

                </div>


                <small class="report-upload-help">

                    <i class="bi bi-info-circle"></i>

                    Accepted formats: PDF, JPG, JPEG and PNG.
                    Maximum file size: 10 MB.

                </small>

            </form>

        </div>

    </div>


   <!-- ===================================================== -->
<!-- UPLOADED REPORTS -->
<!-- ===================================================== -->

<div class="uploaded-reports">

    <div class="uploaded-reports-heading">

        <div>

            <h4>
                Attached Reports
            </h4>

            <span>
                <%= reports.size() %>
                report<%= reports.size() == 1 ? "" : "s" %>
            </span>

        </div>

    </div>


    <% if (reports.isEmpty()) { %>

        <div class="reports-empty">

            <div class="reports-empty-icon">

                <i class="bi bi-file-earmark-x"></i>

            </div>

            <strong>
                No reports attached yet
            </strong>

            <span>
                Uploaded reports will appear here.
            </span>

        </div>

    <% } else { %>

        <div class="report-list">

            <% for (PatientReport report : reports) { %>

                <div class="report-item">

                    <div class="report-item-icon">

                        <%
                            String reportIcon =
                                    "bi-file-earmark-medical";

                            String reportType =
                                    report.getFileType();

                            if (reportType != null) {

                                if (
                                    reportType.equalsIgnoreCase(
                                        "application/pdf"
                                    )
                                ) {

                                    reportIcon =
                                            "bi-file-earmark-pdf";

                                } else if (
                                    reportType.startsWith("image/")
                                ) {

                                    reportIcon =
                                            "bi-file-earmark-image";
                                }
                            }
                        %>

                        <i class="bi <%= reportIcon %>"></i>

                    </div>


                    <div class="report-item-information">

                        <strong>
                            <%= report.getOriginalFileName() %>
                        </strong>


                        <span>

                            <%
                                long size =
                                        report.getFileSize();

                                String sizeText;

                                if (size < 1024) {

                                    sizeText =
                                            size + " B";

                                } else if (
                                        size < 1024 * 1024
                                ) {

                                    sizeText =
                                            String.format(
                                                    "%.1f KB",
                                                    size / 1024.0
                                            );

                                } else {

                                    sizeText =
                                            String.format(
                                                    "%.1f MB",
                                                    size /
                                                    (1024.0 * 1024.0)
                                            );
                                }
                            %>

                            <%= sizeText %>

                            <span class="report-dot">
                                •
                            </span>

                            Uploaded

                            <% if (report.getUploadedAt() != null) { %>

                                <%= report.getUploadedAt() %>

                            <% } %>

                        </span>

                    </div>


                    <div class="report-item-actions">

                        <a
                            href="${pageContext.request.contextPath}/dentist/view-report?reportId=<%= report.getReportId() %>"
                            target="_blank"
                            class="report-action report-view"
                            title="View report"
                        >

                            <i class="bi bi-eye"></i>

                            <span>
                                View
                            </span>

                        </a>

                    </div>

                </div>

            <% } %>

        </div>

    <% } %>

</div>

        </section>

    </main>

</div>


<script>

    const menuButton =
        document.getElementById("menuButton");

    const sidebar =
        document.getElementById("sidebar");

    if (menuButton && sidebar) {

        menuButton.addEventListener(
            "click",
            function () {

                sidebar.classList.toggle(
                    "sidebar-open"
                );

            }
        );
    }


    function confirmCancel() {

        return confirm(
            "Are you sure you want to cancel this appointment?"
        );
    }

</script>

<script>
    const reportFile =
        document.getElementById("reportFile");

    const reportFileName =
        document.getElementById("reportFileName");


    if (reportFile && reportFileName) {

        reportFile.addEventListener(
            "change",
            function () {

                if (this.files.length > 0) {

                    reportFileName.textContent =
                        this.files[0].name;

                } else {

                    reportFileName.textContent =
                        "Choose report file";
                }
            }
        );
    }
</script>

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>

</body>

</html>