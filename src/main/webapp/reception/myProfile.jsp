<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    String staffName =
            (String)
                    session.getAttribute(
                            "staffName"
                    );


    String role =
            (String)
                    session.getAttribute(
                            "role"
                    );


    String username =
            (String)
                    session.getAttribute(
                            "username"
                    );


    String email =
            (String)
                    session.getAttribute(
                            "staffEmail"
                    );


    String phone =
            (String)
                    session.getAttribute(
                            "staffPhone"
                    );


    String staffId =
            String.valueOf(
                    session.getAttribute(
                            "staffId"
                    )
            );


    if (
        staffName == null
        || staffName.isBlank()
    ) {

        staffName =
                "Receptionist";
    }


    if (
        role == null
        || role.isBlank()
    ) {

        role =
                "RECEPTION";
    }


    if (
        username == null
        || username.isBlank()
    ) {

        username =
                "Not available";
    }


    if (
        email == null
        || email.isBlank()
    ) {

        email =
                "Not available";
    }


    if (
        phone == null
        || phone.isBlank()
    ) {

        phone =
                "Not available";
    }


    if (
        staffId == null
        || staffId.equals("null")
    ) {

        staffId =
                "Not available";
    }


    /*
     * Generate initials.
     */

    String initials =
            "ST";


    String[] nameParts =
            staffName
                    .trim()
                    .split("\\s+");


    if (nameParts.length >= 2) {

        initials =
                ""
                + nameParts[0].charAt(0)
                + nameParts[
                        nameParts.length - 1
                ].charAt(0);

    } else if (
            staffName.length() >= 2
    ) {

        initials =
                staffName.substring(
                        0,
                        2
                );
    }

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
        My Profile | Sunrise Dental Clinic
    </title>


    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/reception.css"
    >


    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    >


    <style>

        .profile-content {
            padding: 30px;
            max-width: 1100px;
            margin: 0 auto;
        }


        .profile-hero {
            background: linear-gradient(
                135deg,
                #2563eb,
                #1d4ed8
            );
            border-radius: 20px;
            padding: 32px;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 24px;
            margin-bottom: 25px;
            box-shadow: 0 12px 30px rgba(
                37,
                99,
                235,
                0.18
            );
        }


        .profile-avatar-large {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: rgba(
                255,
                255,
                255,
                0.18
            );
            border: 3px solid rgba(
                255,
                255,
                255,
                0.4
            );
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 800;
            flex-shrink: 0;
        }


        .profile-hero-text h2 {
            margin: 0 0 7px;
            font-size: 28px;
        }


        .profile-hero-text p {
            margin: 0;
            opacity: 0.88;
        }


        .profile-role-badge {
            display: inline-flex;
            margin-top: 12px;
            padding: 7px 13px;
            border-radius: 999px;
            background: rgba(
                255,
                255,
                255,
                0.15
            );
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.04em;
        }


        .profile-grid {
            display: grid;
            grid-template-columns:
                minmax(0, 1.5fr)
                minmax(300px, 0.8fr);
            gap: 24px;
        }


        .profile-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            padding: 26px;
            box-shadow: 0 6px 20px rgba(
                15,
                23,
                42,
                0.05
            );
        }


        .profile-card h3 {
            margin: 0;
            color: #172554;
            font-size: 19px;
        }


        .profile-card-description {
            margin: 7px 0 22px;
            color: #64748b;
            font-size: 14px;
        }


        .profile-information-grid {
            display: grid;
            grid-template-columns:
                repeat(2, minmax(0, 1fr));
            gap: 18px;
        }


        .profile-field {
            padding: 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 13px;
        }


        .profile-field span {
            display: block;
            font-size: 12px;
            color: #64748b;
            margin-bottom: 6px;
        }


        .profile-field strong {
            display: block;
            color: #172554;
            font-size: 15px;
            word-break: break-word;
        }


        .permission-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }


        .permission-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 14px;
            border-radius: 12px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }


        .permission-item i {
            width: 32px;
            height: 32px;
            border-radius: 9px;
            background: #dbeafe;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
        }


        .permission-item span {
            font-size: 14px;
            color: #334155;
            font-weight: 600;
        }


        .security-box {
            margin-top: 24px;
            padding: 18px;
            border-radius: 14px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }


        .security-box strong {
            display: block;
            color: #1e3a8a;
            margin-bottom: 6px;
        }


        .security-box span {
            color: #475569;
            font-size: 13px;
            line-height: 1.6;
        }


        .profile-actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }


        .profile-action {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 12px 18px;
            border-radius: 11px;
            text-decoration: none;
            font-weight: 700;
            font-size: 14px;
        }


        .profile-action.primary {
            background: #2563eb;
            color: #ffffff;
        }


        .profile-action.secondary {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #e2e8f0;
        }


        @media (max-width: 850px) {

            .profile-grid {
                grid-template-columns: 1fr;
            }

        }


        @media (max-width: 600px) {

            .profile-content {
                padding: 18px;
            }


            .profile-hero {
                padding: 24px;
                flex-direction: column;
                align-items: flex-start;
            }


            .profile-information-grid {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>


<body>


<div class="dashboard-container">


    <!-- SIDEBAR -->

    <aside class="sidebar">

        <div class="sidebar-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
                alt="Sunrise Dental Clinic Logo"
            >

            <div class="brand-text">

                <h2>
                    Sunrise
                </h2>

                <span>
                    Dental Clinic
                </span>

            </div>

        </div>


        <nav class="sidebar-navigation">


            <p class="navigation-title">
                MAIN
            </p>


            <a
                href="${pageContext.request.contextPath}/reception/dashboard"
                class="nav-item"
            >

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="${pageContext.request.contextPath}/reception/schedule"
                class="nav-item"
            >

                <i class="bi bi-calendar3"></i>

                <span>
                    Today's Schedule
                </span>

            </a>


            <div class="nav-dropdown">

                <button
                    type="button"
                    class="nav-item nav-dropdown-toggle"
                    id="appointmentsToggle"
                >

                    <span class="nav-item-left">

                        <i class="bi bi-calendar-check"></i>

                        <span>
                            Appointments
                        </span>

                    </span>

                    <i class="bi bi-chevron-down dropdown-arrow"></i>

                </button>


                <div
                    class="nav-submenu"
                    id="appointmentsSubmenu"
                >

                    <a
                        href="${pageContext.request.contextPath}/reception/book-appointment"
                        class="nav-subitem"
                    >

                        <i class="bi bi-calendar-plus"></i>

                        <span>
                            Book Appointment
                        </span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/view-appointments"
                        class="nav-subitem"
                    >

                        <i class="bi bi-calendar3"></i>

                        <span>
                            View Appointments
                        </span>

                    </a>

                </div>

            </div>


            <div class="nav-group">

                <button
                    type="button"
                    class="nav-item nav-parent"
                    onclick="this.parentElement.classList.toggle('open')"
                >

                    <span class="nav-item-left">

                        <i class="bi bi-people"></i>

                        <span>
                            Patients
                        </span>

                    </span>

                    <i class="bi bi-chevron-down nav-chevron"></i>

                </button>


                <div class="nav-submenu">

                    <a
                        href="${pageContext.request.contextPath}/reception/register-patient"
                        class="nav-subitem"
                    >

                        <i class="bi bi-person-plus"></i>

                        <span>
                            Register New Patient
                        </span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/manage-patients"
                        class="nav-subitem"
                    >

                        <i class="bi bi-person-lines-fill"></i>

                        <span>
                            Manage Patients
                        </span>

                    </a>

                </div>

            </div>


            <p class="navigation-title clinic-title">
                CLINIC
            </p>


            <div class="nav-group">

                <button
                    type="button"
                    class="nav-item nav-toggle"
                    onclick="this.parentElement.classList.toggle('open')"
                >

                    <span class="nav-item-left">

                        <i class="bi bi-person-badge"></i>

                        <span>
                            Dentists
                        </span>

                    </span>

                    <i class="bi bi-chevron-down nav-arrow"></i>

                </button>


                <div class="nav-submenu">

                    <a
                        href="${pageContext.request.contextPath}/reception/dentists"
                        class="nav-subitem"
                    >

                        <i class="bi bi-people"></i>

                        <span>
                            View Dentists
                        </span>

                    </a>


                    <a
                        href="${pageContext.request.contextPath}/reception/dentist-availability"
                        class="nav-subitem"
                    >

                        <i class="bi bi-calendar2-week"></i>

                        <span>
                            Check Availability
                        </span>

                    </a>

                </div>

            </div>


            <a
                href="${pageContext.request.contextPath}/reception/profile"
                class="nav-item active"
            >

                <i class="bi bi-person-circle"></i>

                <span>
                    My Profile
                </span>

            </a>


            <a
                href="${pageContext.request.contextPath}/reception/helpdesk.jsp"
                class="nav-item"
            >

                <i class="bi bi-question-circle"></i>

                <span>
                    Help Desk
                </span>

            </a>


            <a
                href="${pageContext.request.contextPath}/logout"
                class="nav-item logout-item"
            >

                <i class="bi bi-box-arrow-right"></i>

                <span>
                    Logout
                </span>

            </a>

        </nav>

    </aside>


    <!-- MAIN -->

    <main class="main-content">


        <header class="topbar">

            <div class="topbar-left">

                <a
                    href="${pageContext.request.contextPath}/reception/dashboard"
                    class="menu-button"
                >

                    <i class="bi bi-arrow-left"></i>

                </a>


                <div>

                    <h1>
                        My Profile
                    </h1>

                    <p>
                        Account Information
                    </p>

                </div>

            </div>


            <div class="topbar-right">

                <a
                    href="${pageContext.request.contextPath}/reception/profile"
                    class="user-profile"
                >

                    <div class="user-avatar">

                        <i class="bi bi-person-fill"></i>

                    </div>

                    <div class="user-information">

                        <strong>
                            <%= staffName %>
                        </strong>

                        <span>
                            Receptionist
                        </span>

                    </div>

                </a>

            </div>

        </header>


        <section class="profile-content">


            <!-- PROFILE HERO -->

            <div class="profile-hero">

                <div class="profile-avatar-large">

                    <%= initials.toUpperCase() %>

                </div>


                <div class="profile-hero-text">

                    <h2>
                        <%= staffName %>
                    </h2>

                    <p>
                        Reception staff member at
                        Sunrise Dental Clinic
                    </p>

                    <span class="profile-role-badge">

                        <i class="bi bi-shield-check"></i>

                        &nbsp;
                        <%= role %>

                    </span>

                </div>

            </div>


            <div class="profile-grid">


                <!-- ACCOUNT INFORMATION -->

                <div class="profile-card">

                    <h3>
                        Account Information
                    </h3>

                    <p class="profile-card-description">
                        Your current staff account information.
                    </p>


                    <div class="profile-information-grid">


                        <div class="profile-field">

                            <span>
                                Full Name
                            </span>

                            <strong>
                                <%= staffName %>
                            </strong>

                        </div>


                        <div class="profile-field">

                            <span>
                                Role
                            </span>

                            <strong>
                                Receptionist
                            </strong>

                        </div>


                        <div class="profile-field">

                            <span>
                                Username
                            </span>

                            <strong>
                                <%= username %>
                            </strong>

                        </div>


                        <div class="profile-field">

                            <span>
                                Email
                            </span>

                            <strong>
                                <%= email %>
                            </strong>

                        </div>


                        <div class="profile-field">

                            <span>
                                Contact Number
                            </span>

                            <strong>
                                <%= phone %>
                            </strong>

                        </div>


                        <div class="profile-field">

                            <span>
                                Staff ID
                            </span>

                            <strong>
                                <%= staffId %>
                            </strong>

                        </div>

                    </div>


                    <div class="security-box">

                        <strong>
                            <i class="bi bi-shield-lock"></i>
                            Account Security
                        </strong>

                        <span>
                            Your receptionist account is protected
                            by the clinic authentication system.
                            Never share your login credentials with
                            another staff member.
                        </span>

                    </div>


                    <div class="profile-actions">

                        <a
                            href="${pageContext.request.contextPath}/logout"
                            class="profile-action secondary"
                        >

                            <i class="bi bi-box-arrow-right"></i>

                            Logout

                        </a>

                    </div>

                </div>


                <!-- PERMISSIONS -->

                <div class="profile-card">

                    <h3>
                        Receptionist Access
                    </h3>

                    <p class="profile-card-description">
                        Functions available to your account.
                    </p>


                    <div class="permission-list">


                        <div class="permission-item">

                            <i class="bi bi-calendar-check"></i>

                            <span>
                                Appointment Management
                            </span>

                        </div>


                        <div class="permission-item">

                            <i class="bi bi-calendar-plus"></i>

                            <span>
                                Book Appointments
                            </span>

                        </div>


                        <div class="permission-item">

                            <i class="bi bi-calendar2-week"></i>

                            <span>
                                Reschedule Appointments
                            </span>

                        </div>


                        <div class="permission-item">

                            <i class="bi bi-calendar-x"></i>

                            <span>
                                Cancel Appointments
                            </span>

                        </div>


                        <div class="permission-item">

                            <i class="bi bi-people"></i>

                            <span>
                                Patient Management
                            </span>

                        </div>


                        <div class="permission-item">

                            <i class="bi bi-person-badge"></i>

                            <span>
                                Dentist Information
                            </span>

                        </div>


                        <div class="permission-item">

                            <i class="bi bi-clock-history"></i>

                            <span>
                                Dentist Availability
                            </span>

                        </div>

                    </div>

                </div>

            </div>

        </section>

    </main>

</div>


<script>

    const appointmentsToggle =
        document.getElementById(
            "appointmentsToggle"
        );


    const appointmentsSubmenu =
        document.getElementById(
            "appointmentsSubmenu"
        );


    if (
        appointmentsToggle
        && appointmentsSubmenu
    ) {

        appointmentsToggle.addEventListener(
            "click",
            function () {

                appointmentsSubmenu.classList.toggle(
                    "submenu-open"
                );

            }
        );

    }

</script>


</body>

</html>