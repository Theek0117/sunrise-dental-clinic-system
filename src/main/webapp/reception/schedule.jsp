<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%

    List<Appointment> appointments =
            (List<Appointment>)
                    request.getAttribute(
                            "todayAppointments"
                    );


    Map<Integer, Patient> patients =
            new HashMap<>();


    Map<Integer, Dentist> dentists =
            new HashMap<>();


    /*
     * Load related information.
     *
     * We use AppointmentService here because
     * your existing appointment structure already
     * works with patientId and dentistId.
     */

    com.sunrise.dental.service.AppointmentService service =
            new com.sunrise.dental.service.AppointmentService();


    if (appointments != null) {

        for (Appointment appointment
                : appointments) {

            int patientId =
                    appointment.getPatientId();

            int dentistId =
                    appointment.getDentistId();


            if (!patients.containsKey(patientId)) {

                Patient patient =
                        service.getPatient(
                                patientId
                        );

                if (patient != null) {

                    patients.put(
                            patientId,
                            patient
                    );
                }
            }


            if (!dentists.containsKey(dentistId)) {

                Dentist dentist =
                        service.getDentist(
                                dentistId
                        );

                if (dentist != null) {

                    dentists.put(
                            dentistId,
                            dentist
                    );
                }
            }
        }
    }


    String staffName =
            (String)
                    session.getAttribute(
                            "staffName"
                    );


    if (staffName == null) {
        staffName = "Receptionist";
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
        Today's Schedule | Sunrise Dental Clinic
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
                class="nav-item active"
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
                class="nav-item"
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
                        Today's Schedule
                    </h1>

                    <p>
                        Daily Reception Schedule
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


        <section class="dashboard-content">


            <div class="welcome-section">

                <div>

                    <h2>
                        Today's Schedule
                    </h2>

                    <p>
                        Complete appointment schedule for today.
                    </p>

                </div>


                <div class="current-date">

                    <i class="bi bi-calendar3"></i>

                    <span id="scheduleDate"></span>

                </div>

            </div>

            <% 
                String schedSuccess = request.getParameter("success");
                String schedError = request.getParameter("error");
                String schedEmail = request.getParameter("email");
                if ("resent".equals(schedSuccess)) {
            %>
                <div style="background:#e8f8f0; color:#0d8248; border:1px solid #c2eed5; padding:14px 20px; border-radius:12px; margin-bottom:20px; display:flex; align-items:center; gap:10px; font-size:13.5px;">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>Appointment details have been resent successfully to <strong><%= schedEmail != null ? schedEmail : "the patient" %></strong>.</span>
                </div>
            <% } else if ("noemail".equals(schedError)) { %>
                <div style="background:#feecee; color:#c92a2a; border:1px solid #f9c6cb; padding:14px 20px; border-radius:12px; margin-bottom:20px; display:flex; align-items:center; gap:10px; font-size:13.5px;">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span>Cannot resend details: The patient does not have an email address on file.</span>
                </div>
            <% } else if ("email_failed".equals(schedError)) { %>
                <div style="background:#feecee; color:#c92a2a; border:1px solid #f9c6cb; padding:14px 20px; border-radius:12px; margin-bottom:20px; display:flex; align-items:center; gap:10px; font-size:13.5px;">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span>Failed to send email. Please verify mail configuration or try again later.</span>
                </div>
            <% } %>

            <section class="appointments-section">


                <div class="section-heading">

                    <div>

                        <h3>
                            Appointment Timeline
                        </h3>

                        <p>
                            Appointments are displayed from earliest
                            to latest.
                        </p>

                    </div>


                    <a
                        href="${pageContext.request.contextPath}/reception/book-appointment"
                        class="view-all-link"
                    >

                        <i class="bi bi-plus-circle"></i>

                        Book Appointment

                    </a>

                </div>


                <div class="table-container">

                    <table class="appointments-table">

                        <thead>

                        <tr>

                            <th>
                                Time
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
                                Status
                            </th>

                            <th>
                                Action
                            </th>

                        </tr>

                        </thead>


                        <tbody>


                        <%
                            if (
                                appointments == null
                                || appointments.isEmpty()
                            ) {
                        %>

                            <tr>

                                <td
                                    colspan="6"
                                    class="empty-state"
                                >

                                    <div>

                                        <i class="bi bi-calendar2-check"></i>

                                        <strong>
                                            No appointments scheduled today
                                        </strong>

                                        <span>
                                            The schedule is currently clear.
                                        </span>

                                    </div>

                                </td>

                            </tr>

                        <%
                            } else {

                                for (
                                    Appointment appointment
                                    : appointments
                                ) {

                                    Patient patient =
                                            patients.get(
                                                    appointment.getPatientId()
                                            );

                                    Dentist dentist =
                                            dentists.get(
                                                    appointment.getDentistId()
                                            );


                                    String patientName =
                                            patient != null
                                                    ? patient.getName()
                                                    : "Unknown Patient";


                                    String dentistName =
                                            dentist != null
                                                    ? dentist.getName()
                                                    : "Unknown Dentist";


                                    String reason =
                                            appointment.getReason() != null
                                                    ? appointment.getReason()
                                                    : "-";


                                    String status =
                                            appointment.getStatus() != null
                                                    ? appointment.getStatus()
                                                    : "UNKNOWN";

                        %>

                            <tr>

                                <td>

                                    <strong>
                                        <%= appointment.getStartTime() %>
                                    </strong>

                                    <span>
                                        -
                                        <%= appointment.getEndTime() %>
                                    </span>

                                </td>


                                <td>

                                    <div class="patient-cell">

                                        <div class="patient-avatar">

                                            <%
                                                String[] parts =
                                                        patientName
                                                                .trim()
                                                                .split("\\s+");

                                                String initials =
                                                        parts.length >= 2
                                                                ? ""
                                                                + parts[0].charAt(0)
                                                                + parts[parts.length - 1]
                                                                        .charAt(0)
                                                                : patientName
                                                                        .substring(
                                                                                0,
                                                                                Math.min(
                                                                                        2,
                                                                                        patientName.length()
                                                                                )
                                                                        );
                                            %>

                                            <%= initials.toUpperCase() %>

                                        </div>


                                        <div>

                                            <strong>
                                                <%= patientName %>
                                            </strong>

                                            <span>

                                                <%= patient != null
                                                        ? patient.getContactNumber()
                                                        : "-" %>

                                            </span>

                                        </div>

                                    </div>

                                </td>


                                <td>
                                    <%= dentistName %>
                                </td>


                                <td>
                                    <%= reason %>
                                </td>


                                <td>

                                    <span
                                        class="status <%= status.toLowerCase() %>"
                                    >

                                        <%= status %>

                                    </span>

                                </td>


                                <td>
                                    <div style="display: flex; gap: 8px; align-items: center;">
                                        <a
                                            href="${pageContext.request.contextPath}/reception/view-appointment?appointmentId=<%= appointment.getAppointmentId() %>"
                                            class="table-action"
                                            title="View appointment"
                                        >
                                            <i class="bi bi-eye"></i>
                                        </a>

                                        <% if (!"CANCELLED".equalsIgnoreCase(status)) { %>
                                            <form method="post" action="${pageContext.request.contextPath}/reception/resend-appointment"
                                                  data-confirm="Resend appointment details to <%= (patient != null && patient.getEmail() != null) ? patient.getEmail() : "the patient" %>?"
                                                  data-confirm-title="Resend Appointment Email"
                                                  data-confirm-type="primary"
                                                  data-confirm-btn="Yes, Send Email"
                                                  style="display:inline; margin: 0;">
                                                <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                                                <input type="hidden" name="returnTo" value="schedule">
                                                <button type="submit" class="table-action" style="border:none; cursor:pointer; background:none; padding:0;" title="Resend confirmation email to patient">
                                                    <i class="bi bi-send-check" style="color: #0ea5b4;"></i>
                                                </button>
                                            </form>
                                        <% } %>
                                    </div>
                                </td>

                            </tr>

                        <%
                                }
                            }
                        %>

                        </tbody>

                    </table>

                </div>

            </section>

        </section>

    </main>

</div>


<script>

    const dateElement =
        document.getElementById(
            "scheduleDate"
        );


    const today =
        new Date();


    dateElement.textContent =
        today.toLocaleDateString(
            "en-US",
            {
                weekday: "long",
                year: "numeric",
                month: "long",
                day: "numeric"
            }
        );


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

<script src="${pageContext.request.contextPath}/js/notifications.js"></script>

</body>

</html>