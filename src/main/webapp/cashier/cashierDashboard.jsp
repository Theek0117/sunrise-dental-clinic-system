<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>

<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    /*
     * ==========================================
     * BASIC INFORMATION
     * ==========================================
     */

    String contextPath =
            request.getContextPath();

    String staffName =
            (String) request.getAttribute("staffName");

    if (staffName == null
            || staffName.isBlank()) {

        staffName = "Cashier";
    }


    /*
     * ==========================================
     * DASHBOARD DATA
     * ==========================================
     */

    Integer totalCompleted =
            (Integer) request.getAttribute(
                    "totalCompleted"
            );

    Integer todayCompleted =
            (Integer) request.getAttribute(
                    "todayCompleted"
            );

    BigDecimal todayBasicAmount =
            (BigDecimal) request.getAttribute(
                    "todayBasicAmount"
            );

    Date today =
            (Date) request.getAttribute("today");


    if (totalCompleted == null) {
        totalCompleted = 0;
    }

    if (todayCompleted == null) {
        todayCompleted = 0;
    }

    if (todayBasicAmount == null) {
        todayBasicAmount = BigDecimal.ZERO;
    }

    if (today == null) {
        today =
                Date.valueOf(
                        LocalDate.now()
                );
    }


    /*
     * ==========================================
     * APPOINTMENTS
     * ==========================================
     */

    List<Appointment> appointments =
            (List<Appointment>) request.getAttribute(
                    "appointments"
            );


    /*
     * ==========================================
     * MAPS
     * ==========================================
     */

    Map<Integer, TreatmentType> treatmentTypes =
            (Map<Integer, TreatmentType>)
                    request.getAttribute(
                            "treatmentTypes"
                    );

    Map<Integer, Patient> patients =
            (Map<Integer, Patient>)
                    request.getAttribute(
                            "patients"
                    );

    Map<Integer, Dentist> dentists =
            (Map<Integer, Dentist>)
                    request.getAttribute(
                            "dentists"
                    );


    /*
     * ==========================================
     * GREETING
     * ==========================================
     */

    String greeting;

    int currentHour =
            java.time.LocalTime
                    .now()
                    .getHour();

    if (currentHour < 12) {

        greeting = "Good Morning";

    } else if (currentHour < 17) {

        greeting = "Good Afternoon";

    } else {

        greeting = "Good Evening";
    }


    /*
     * ==========================================
     * CASHIER INITIALS
     * ==========================================
     */

    String cashierInitials = "CA";

    if (staffName != null
            && !staffName.isBlank()) {

        String[] parts =
                staffName
                        .trim()
                        .split("\\s+");

        if (parts.length >= 2) {

            cashierInitials =
                    (
                        parts[0].substring(0, 1)
                        +
                        parts[parts.length - 1]
                                .substring(0, 1)
                    ).toUpperCase();

        } else if (staffName.length() >= 2) {

            cashierInitials =
                    staffName
                            .substring(0, 2)
                            .toUpperCase();
        }
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Cashier Dashboard | Sunrise Dental Clinic
    </title>


    <!-- Google Fonts -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- Existing Clinic CSS -->

    <link rel="stylesheet"
          href="<%= contextPath %>/css/reception.css">


    <style>

        /*
         * ==========================================
         * CASHIER DASHBOARD
         * ==========================================
         */

        .cashier-profile-card {

            display: flex;

            align-items: center;

            gap: 18px;
        }


        .cashier-avatar-large {

            width: 62px;

            height: 62px;

            border-radius: 18px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: rgba(255, 255, 255, 0.18);

            border: 1px solid
                rgba(255, 255, 255, 0.25);

            color: #ffffff;

            font-size: 20px;

            font-weight: 700;
        }


        .cashier-welcome-name {

            margin: 0;

            font-size: 24px;

            font-weight: 700;
        }


        .cashier-section-note {

            margin-top: 4px;

            color: #d6f0f5;

            font-size: 13.5px;
        }


        /*
         * ==========================================
         * BILLING STATISTICS
         * ==========================================
         */

        .billing-icon {

            background: rgba(14, 165, 180, 0.12);

            color: #0ea5b4;
        }


        .completed-icon {

            background: rgba(34, 197, 94, 0.12);

            color: #16a34a;
        }


        .amount-icon {

            background: rgba(245, 158, 11, 0.12);

            color: #d97706;
        }


        .pending-billing-icon {

            background: rgba(99, 102, 241, 0.12);

            color: #6366f1;
        }


        /*
         * ==========================================
         * BILLING SECTION
         * ==========================================
         */

        .billing-section {

            margin-top: 28px;
        }


        .billing-table-container {

            width: 100%;

            overflow-x: auto;

            background: #ffffff;

            border-radius: 16px;

            border: 1px solid #e7eef2;

            box-shadow:
                0 5px 20px rgba(15, 55, 70, 0.05);
        }


        .billing-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 1050px;
        }


        .billing-table th {

            padding: 16px 18px;

            text-align: left;

            font-size: 11px;

            font-weight: 700;

            color: #718894;

            text-transform: uppercase;

            letter-spacing: 0.5px;

            background: #f8fbfc;

            border-bottom: 1px solid #e5edf0;
        }


        .billing-table td {

            padding: 16px 18px;

            border-bottom: 1px solid #edf2f4;

            font-size: 13px;

            color: #405762;

            vertical-align: middle;
        }


        .billing-table tbody tr:last-child td {

            border-bottom: none;
        }


        .billing-table tbody tr {

            transition: background 0.2s ease;
        }


        .billing-table tbody tr:hover {

            background: #f9fcfd;
        }


        /*
         * ==========================================
         * APPOINTMENT NUMBER
         * ==========================================
         */

        .appointment-number {

            font-weight: 700;

            color: #0c3d4f;
        }


        /*
         * ==========================================
         * PATIENT CELL
         * ==========================================
         */

        .patient-cell {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .patient-avatar-small {

            width: 38px;

            height: 38px;

            border-radius: 12px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #e8f6f8;

            color: #0c7c8a;

            font-size: 13px;

            font-weight: 700;

            flex-shrink: 0;
        }


        .patient-details strong {

            display: block;

            color: #173d4a;

            font-size: 13px;
        }


        .patient-details span {

            display: block;

            margin-top: 2px;

            color: #91a5ae;

            font-size: 11px;
        }


        /*
         * ==========================================
         * DENTIST
         * ==========================================
         */

        .dentist-name {

            color: #0c8291;

            font-weight: 600;
        }


        /*
         * ==========================================
         * TREATMENT
         * ==========================================
         */

        .treatment-name {

            color: #294d5a;

            font-weight: 600;
        }


        .treatment-cost {

            color: #0c3d4f;

            font-weight: 700;

            white-space: nowrap;
        }


        /*
         * ==========================================
         * STATUS
         * ==========================================
         */

        .completed-status {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            padding: 6px 11px;

            border-radius: 20px;

            background: #eaf8ef;

            color: #18864b;

            font-size: 11px;

            font-weight: 700;
        }


        .completed-status i {

            font-size: 8px;
        }


        /*
         * ==========================================
         * BILL BUTTON
         * ==========================================
         */

        .generate-bill-button {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            padding: 9px 13px;

            border-radius: 9px;

            border: 1px solid #0ea5b4;

            background: #0ea5b4;

            color: #ffffff;

            text-decoration: none;

            font-size: 11px;

            font-weight: 600;

            transition:
                background 0.2s ease,
                transform 0.2s ease;
        }


        .generate-bill-button:hover {

            background: #087f8c;

            color: #ffffff;

            transform: translateY(-1px);
        }


        /*
         * ==========================================
         * EMPTY STATE
         * ==========================================
         */

        .empty-billing-state {

            text-align: center;

            padding: 60px 20px;

            color: #8da4ae;
        }


        .empty-billing-state i {

            display: block;

            margin-bottom: 12px;

            font-size: 42px;

            color: #b8cbd2;
        }


        .empty-billing-state strong {

            display: block;

            margin-bottom: 5px;

            color: #557280;

            font-size: 15px;
        }


        .empty-billing-state span {

            font-size: 12px;
        }


        /*
         * ==========================================
         * SECTION HEADER
         * ==========================================
         */

        .billing-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            margin-bottom: 15px;
        }


        .billing-heading h3 {

            margin: 0;

            color: #123e4e;

            font-size: 18px;
        }


        .billing-heading p {

            margin: 4px 0 0;

            color: #8ca1aa;

            font-size: 12px;
        }


        .billing-count {

            padding: 8px 13px;

            border-radius: 10px;

            background: #eef8fa;

            color: #0c8291;

            font-size: 12px;

            font-weight: 700;
        }


        /*
         * ==========================================
         * RESPONSIVE
         * ==========================================
         */

        @media (max-width: 768px) {

            .cashier-welcome-name {

                font-size: 19px;
            }


            .billing-heading {

                align-items: flex-start;

                flex-direction: column;
            }

        }

    </style>

</head>


<body>

<div class="dashboard-container">


    <!-- ========================================= -->
    <!-- SIDEBAR -->
    <!-- ========================================= -->

    <aside class="sidebar"
           id="sidebar">

        <div class="sidebar-brand">

            <img src="<%= contextPath %>/images/logo1.png"
                 alt="Sunrise Dental Clinic Logo">

            <div class="brand-text">

                <h2>Sunrise</h2>

                <span>Dental Clinic</span>

            </div>

        </div>


        <nav class="sidebar-navigation">

            <p class="navigation-title">
                MAIN
            </p>


            <a href="<%= contextPath %>/cashier/dashboard"
               class="nav-item active">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>Dashboard</span>

            </a>


            <a href="<%= contextPath %>/cashier/billing"
               class="nav-item">

                <i class="bi bi-receipt-cutoff"></i>

                <span>Billing</span>

            </a>


            <a href="<%= contextPath %>/cashier/payments"
               class="nav-item">

                <i class="bi bi-credit-card-fill"></i>

                <span>Payments</span>

            </a>


            <p class="navigation-title clinic-title">
                CLINIC
            </p>

            <a href="<%= contextPath %>/cashier/appointments"
               class="nav-item">
                <i class="bi bi-calendar2-week"></i>
                <span>Appointments</span>
            </a>

        </nav>

        <!-- ACCOUNT -->
        <div class="sidebar-bottom">
            <p class="navigation-title">
                ACCOUNT
            </p>

            <a href="<%= contextPath %>/cashier/profile"
               class="nav-item">
                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>
            </a>

            <a href="<%= contextPath %>/cashier/helpdesk.jsp"
               class="nav-item">
                <i class="bi bi-question-circle"></i>
                <span>Help Desk</span>
            </a>

            <a href="<%= contextPath %>/logout"
               class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>



    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->

    <main class="main-content">


        <!-- TOPBAR -->

        <header class="topbar">

            <div class="topbar-left">

                <h1>
                    Cashier Dashboard
                </h1>

                <p>
                    Billing and payment overview
                </p>

            </div>


            <div class="topbar-right">

                <button type="button"
                        class="icon-button"
                        title="Notifications">

                    <i class="bi bi-bell"></i>

                    <span class="notification-dot"></span>

                </button>


                <div class="user-profile">

                    <div class="user-avatar">

                        <i class="bi bi-person-fill"></i>

                    </div>


                    <div class="user-information">

                        <strong>
                            <%= staffName %>
                        </strong>

                        <span>
                            Cashier
                        </span>

                    </div>

                </div>

            </div>

        </header>



        <!-- ========================================= -->
        <!-- DASHBOARD BODY -->
        <!-- ========================================= -->

        <section class="dashboard-content">


            <!-- ========================================= -->
            <!-- WELCOME BANNER -->
            <!-- ========================================= -->

            <div class="welcome-section">

                <div class="cashier-profile-card">

                    <div class="cashier-avatar-large">

                        <%= cashierInitials %>

                    </div>


                    <div>

                        <h2 class="cashier-welcome-name">

                            <%= greeting %>,
                            <%= staffName %>!

                        </h2>


                        <p class="cashier-section-note">

                            Manage completed appointments,
                            billing and patient payments.

                        </p>

                    </div>

                </div>


                <div class="current-date">

                    <i class="bi bi-calendar3"></i>

                    <span>

                        <%= today.toLocalDate()
                                .format(
                                    DateTimeFormatter.ofPattern(
                                        "dd MMMM yyyy"
                                    )
                                )
                        %>

                    </span>

                </div>

            </div>



            <!-- ========================================= -->
            <!-- STATISTICS -->
            <!-- ========================================= -->

            <section class="statistics-grid">


                <!-- TOTAL COMPLETED -->

                <div class="stat-card">

                    <div class="stat-icon completed-icon">

                        <i class="bi bi-check2-circle"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Completed Appointments
                        </span>

                        <strong>
                            <%= totalCompleted %>
                        </strong>

                        <small>
                            Ready for billing
                        </small>

                    </div>

                </div>



                <!-- TODAY COMPLETED -->

                <div class="stat-card">

                    <div class="stat-icon billing-icon">

                        <i class="bi bi-calendar-check"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Today's Completed
                        </span>

                        <strong>
                            <%= todayCompleted %>
                        </strong>

                        <small>
                            Completed today
                        </small>

                    </div>

                </div>



                <!-- TODAY BASIC AMOUNT -->

                <div class="stat-card">

                    <div class="stat-icon amount-icon">

                        <i class="bi bi-cash-stack"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Today's Basic Charges
                        </span>

                        <strong>
                            Rs.
                            <%= todayBasicAmount
                                    .setScale(
                                        2
                                    )
                            %>
                        </strong>

                        <small>
                            Treatment basic costs
                        </small>

                    </div>

                </div>



                <!-- BILLING -->

                <div class="stat-card">

                    <div class="stat-icon pending-billing-icon">

                        <i class="bi bi-receipt"></i>

                    </div>


                    <div class="stat-information">

                        <span>
                            Billing Queue
                        </span>

                        <strong>
                            <%= totalCompleted %>
                        </strong>

                        <small>
                            Appointments available
                        </small>

                    </div>

                </div>

            </section>



            <!-- ========================================= -->
            <!-- COMPLETED APPOINTMENTS -->
            <!-- ========================================= -->

            <section class="billing-section">


                <div class="billing-heading">

                    <div>

                        <h3>
                            Completed Appointments
                        </h3>

                        <p>
                            Select a completed appointment
                            to generate its bill.
                        </p>

                    </div>


                    <div class="billing-count">

                        <i class="bi bi-receipt"></i>

                        <%= totalCompleted %>
                        Records

                    </div>

                </div>



                <div class="billing-table-container">

                    <table class="billing-table">


                        <thead>

                            <tr>

                                <th>
                                    Appointment #
                                </th>

                                <th>
                                    Patient
                                </th>

                                <th>
                                    Dentist
                                </th>

                                <th>
                                    Treatment
                                </th>

                                <th>
                                    Basic Cost
                                </th>

                                <th>
                                    Date
                                </th>

                                <th>
                                    Time
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Action
                                </th>

                            </tr>

                        </thead>



                        <tbody>


                        <%

                            if (appointments != null
                                    && !appointments.isEmpty()) {

                                for (Appointment appointment
                                        : appointments) {


                                    /*
                                     * ======================================
                                     * TREATMENT TYPE
                                     * ======================================
                                     */

                                    TreatmentType treatmentType = null;

                                    if (treatmentTypes != null) {

                                        treatmentType =
                                                treatmentTypes.get(
                                                        appointment
                                                                .getAppointmentId()
                                                );
                                    }


                                    String treatmentName =
                                            "Not Assigned";

                                    BigDecimal basicCost =
                                            BigDecimal.ZERO;


                                    if (treatmentType != null) {

                                        if (treatmentType
                                                .getTreatmentName() != null) {

                                            treatmentName =
                                                    treatmentType
                                                            .getTreatmentName();
                                        }


                                        if (treatmentType
                                                .getBasicCost() != null) {

                                            basicCost =
                                                    treatmentType
                                                            .getBasicCost();
                                        }
                                    }


                                    /*
                                     * ======================================
                                     * PATIENT DISPLAY
                                     *
                                     * For now patient ID is displayed.
                                     * We will add patient names using JOIN
                                     * when we build the billing page.
                                     * ======================================
                                     */

                                    Patient p = (patients != null) ? patients.get(appointment.getPatientId()) : null;
                                    String patientLabel = (p != null && p.getName() != null) ? p.getName() : "Patient #" + appointment.getPatientId();
                                    String patientInitial = (p != null && p.getName() != null && !p.getName().isBlank())
                                            ? p.getName().substring(0, 1).toUpperCase() : "P";

                                    Dentist d = (dentists != null) ? dentists.get(appointment.getDentistId()) : null;
                                    String dentistLabel = (d != null && d.getName() != null) ? "Dr. " + d.getName() : "Dr. #" + appointment.getDentistId();

                                    /*
                                     * ======================================
                                     * APPOINTMENT NUMBER
                                     * ======================================
                                     */

                                    String appointmentNumber =
                                            appointment
                                                    .getAppointmentNumber();

                                    if (appointmentNumber == null
                                            || appointmentNumber.isBlank()) {

                                        appointmentNumber =
                                                "APT-"
                                                + appointment
                                                        .getAppointmentId();
                                    }

                        %>


                            <tr>


                                <!-- APPOINTMENT -->

                                <td>

                                    <span class="appointment-number">

                                        <%= appointmentNumber %>

                                    </span>

                                </td>



                                <!-- PATIENT -->

                                <td>

                                    <div class="patient-cell">

                                        <div class="patient-avatar-small">

                                            <%= patientInitial %>

                                        </div>


                                        <div class="patient-details">

                                            <strong>
                                                <%= patientLabel %>
                                            </strong>

                                            <span>
                                                ID:
                                                <%= appointment.getPatientId() %>
                                            </span>

                                        </div>

                                    </div>

                                </td>



                                <!-- DENTIST -->

                                <td>

                                    <span class="dentist-name">

                                        <%= dentistLabel %>

                                    </span>

                                </td>



                                <!-- TREATMENT -->

                                <td>

                                    <span class="treatment-name">

                                        <%= treatmentName %>

                                    </span>

                                </td>



                                <!-- BASIC COST -->

                                <td>

                                    <span class="treatment-cost">

                                        Rs.
                                        <%= basicCost.setScale(2) %>

                                    </span>

                                </td>



                                <!-- DATE -->

                                <td>

                                    <%= appointment
                                            .getAppointmentDate() %>

                                </td>



                                <!-- TIME -->

                                <td>

                                    <%= appointment.getStartTime() %>

                                    -

                                    <%= appointment.getEndTime() %>

                                </td>



                                <!-- STATUS -->

                                <td>

                                    <span class="completed-status">

                                        <i class="bi bi-circle-fill"></i>

                                        Completed

                                    </span>

                                </td>



                                <!-- ACTION -->

                                <td>

                                    <a href="<%= contextPath %>/cashier/generate-bill?appointmentId=<%= appointment.getAppointmentId() %>"
										   class="generate-bill-button">
										
										    <i class="bi bi-receipt"></i>
										
										    Generate Bill
										
										</a>

                                </td>


                            </tr>


                        <%

                                }

                            } else {

                        %>


                            <tr>

                                <td colspan="9">

                                    <div class="empty-billing-state">

                                        <i class="bi bi-receipt-cutoff"></i>

                                        <strong>
                                            No completed appointments
                                        </strong>

                                        <span>
                                            Completed appointments will
                                            appear here when they are ready
                                            for billing.
                                        </span>

                                    </div>

                                </td>

                            </tr>


                        <%

                            }

                        %>


                        </tbody>

                    </table>

                </div>

            </section>


        </section>

    </main>

</div>

</body>

</html>