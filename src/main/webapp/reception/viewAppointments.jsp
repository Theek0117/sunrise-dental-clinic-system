<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    List<Appointment> appointments =
            (List<Appointment>) request.getAttribute("appointments");

    Map<Integer, Patient> patients =
            (Map<Integer, Patient>) request.getAttribute("patients");

    Map<Integer, Dentist> dentists =
            (Map<Integer, Dentist>) request.getAttribute("dentists");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>View Appointments | Sunrise Dental Clinic</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/viewAppointments.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="appointments-page">

    <!-- HEADER -->

    <header class="appointments-header">

        <div class="header-left">

            <a href="<%= request.getContextPath() %>/reception/dashboard"
               class="back-button" title="Back to Dashboard">

                <i class="bi bi-arrow-left"></i>

            </a>

            <div class="header-title">

                <h1>Appointments</h1>

                <p>View and manage patient appointments</p>

            </div>

        </div>

        <div class="header-user">

            <div class="user-avatar">
                <i class="bi bi-person-fill"></i>
            </div>

            <div class="user-information">

                <strong>Front Desk Reception</strong>

                <span>Receptionist</span>

            </div>

        </div>

    </header>


    <!-- MAIN -->

    <main class="appointments-content">

        <div class="page-introduction">

            <div class="intro-icon">
                <i class="bi bi-calendar2-check-fill"></i>
            </div>

            <div>

                <h2>Appointment Management</h2>

                <p>
                    View, reschedule and cancel patient appointments.
                </p>

            </div>

        </div>


        <!-- MESSAGE -->

        <%
            String success =
                    request.getParameter("success");

            String error =
                    request.getParameter("error");

            String email =
                    request.getParameter("email");
        %>

        <% if ("cancelled".equals(success)) { %>

            <div class="alert success">

                <strong>Appointment cancelled</strong>

                <span>
                    The appointment has been cancelled successfully.
                    The time slot is now available again.
                </span>

                <% if ("failed".equals(email)) { %>

                    <small>
                        The cancellation email could not be sent.
                    </small>

                <% } %>

            </div>

        <% } %>


        <% if ("rescheduled".equals(success)) { %>

            <div class="alert success">

                <strong>Appointment rescheduled</strong>

                <span>
                    The appointment has been updated successfully.
                </span>

                <% if ("failed".equals(email)) { %>

                    <small>
                        The reschedule email could not be sent.
                    </small>

                <% } %>

            </div>

        <% } %>


        <% if (error != null) { %>

            <div class="alert error">

                <strong>Unable to complete request</strong>

                <span>

                    <%
                        switch (error) {

                            case "invalid":
                                out.print(
                                    "The appointment information is invalid."
                                );
                                break;

                            case "notfound":
                                out.print(
                                    "The appointment could not be found."
                                );
                                break;

                            case "cancel":
                                out.print(
                                    "The appointment could not be cancelled."
                                );
                                break;

                            case "cancelled":
                                out.print(
                                    "A cancelled appointment cannot be rescheduled."
                                );
                                break;

                            default:
                                out.print(
                                    "An unexpected error occurred."
                                );
                        }
                    %>

                </span>

            </div>

        <% } %>


        <!-- TOOLBAR -->

        <section class="appointments-card">

            <div class="toolbar">

                <div class="search-box">

                    <i class="bi bi-search"></i>

                    <input
                        type="text"
                        id="appointmentSearch"
                        placeholder="Search appointment, patient or dentist..."
                    >

                </div>

                <div class="filter-group">

                    <select id="statusFilter">

                        <option value="ALL">
                            All Status
                        </option>

                        <option value="CONFIRMED">
                            Confirmed
                        </option>

                        <option value="RESCHEDULED">
                            Rescheduled
                        </option>

                        <option value="PENDING">
                            Pending
                        </option>

                        <option value="CANCELLED">
                            Cancelled
                        </option>

                    </select>

                    <input
                        type="date"
                        id="dateFilter"
                    >

                </div>

            </div>


            <!-- TABLE -->

            <div class="table-wrapper">

                <table id="appointmentsTable">

                    <thead>

                    <tr>

                        <th>Appointment</th>

                        <th>Patient</th>

                        <th>Dentist</th>

                        <th>Date</th>

                        <th>Time</th>

                        <th>Status</th>

                        <th>Actions</th>

                    </tr>

                    </thead>

                    <tbody>

                    <% if (appointments == null
                            || appointments.isEmpty()) { %>

                        <tr>

                            <td colspan="7"
                                class="empty-state">

                                <div>
                                    No appointments found.
                                </div>

                            </td>

                        </tr>

                    <% } else { %>

                        <% for (Appointment appointment
                                : appointments) {

                            Patient patient =
                                    patients.get(
                                            appointment.getPatientId()
                                    );

                            Dentist dentist =
                                    dentists.get(
                                            appointment.getDentistId()
                                    );
                        %>

                            <tr
                                data-search="<%= (
                                    appointment.getAppointmentNumber()
                                    + " "
                                    + (patient != null
                                        ? patient.getName()
                                        : "")
                                    + " "
                                    + (dentist != null
                                        ? dentist.getName()
                                        : "")
                                ).toLowerCase() %>"

                                data-status="<%= appointment.getStatus() %>"

                                data-date="<%= appointment.getAppointmentDate() %>"
                            >

                                <td>

                                    <strong>
                                        <%= appointment.getAppointmentNumber() %>
                                    </strong>

                                </td>


                                <td>

                                    <div class="person-cell">

                                        <strong>
                                            <%= patient != null
                                                ? patient.getName()
                                                : "Unknown Patient" %>
                                        </strong>

                                        <small>

                                            <%= patient != null
                                                ? patient.getContactNumber()
                                                : "-" %>

                                        </small>

                                    </div>

                                </td>


                                <td>

                                    <div class="person-cell">

                                        <strong>

                                            <%= dentist != null
                                                ? dentist.getName()
                                                : "Unknown Dentist" %>

                                        </strong>

                                        <small>

                                            <%= dentist != null
                                                ? dentist.getSpecialization()
                                                : "-" %>

                                        </small>

                                    </div>

                                </td>


                                <td>

                                    <%= appointment.getAppointmentDate() %>

                                </td>


                                <td>

                                    <strong>

                                        <%= appointment.getStartTime() %>

                                    </strong>

                                    <span class="time-end">

                                        -
                                        <%= appointment.getEndTime() %>

                                    </span>

                                </td>


                                <td>

                                    <span class="status status-<%= appointment.getStatus().toLowerCase() %>">

                                        <%= appointment.getStatus() %>

                                    </span>

                                </td>


                                <td>

                                    <div class="action-buttons">

                                        <a
                                            class="action-button view"
                                            href="<%= request.getContextPath() %>/reception/view-appointment?appointmentId=<%= appointment.getAppointmentId() %>"
                                        >
                                            <i class="bi bi-eye"></i> View
                                        </a>


                                        <% if (!"CANCELLED".equalsIgnoreCase(
                                                appointment.getStatus())) { %>

                                            <a
                                                class="action-button reschedule"
                                                href="<%= request.getContextPath() %>/reception/reschedule-appointment?appointmentId=<%= appointment.getAppointmentId() %>"
                                            >
                                                <i class="bi bi-arrow-repeat"></i> Reschedule
                                            </a>


                                            <form
                                                method="post"
                                                action="<%= request.getContextPath() %>/reception/cancel-appointment"
                                                onsubmit="return confirmCancellation('<%= appointment.getAppointmentNumber() %>');"
                                                style="display:inline;"
                                            >

                                                <input
                                                    type="hidden"
                                                    name="appointmentId"
                                                    value="<%= appointment.getAppointmentId() %>"
                                                >

                                                <button
                                                    type="submit"
                                                    class="action-button cancel"
                                                >
                                                    <i class="bi bi-x-circle"></i> Cancel
                                                </button>

                                            </form>

                                        <% } else { %>

                                            <span class="cancelled-label">
                                                <i class="bi bi-slash-circle"></i> Cancelled
                                            </span>

                                        <% } %>

                                    </div>

                                </td>

                            </tr>

                        <% } %>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>


<script>

const searchInput =
    document.getElementById("appointmentSearch");

const statusFilter =
    document.getElementById("statusFilter");

const dateFilter =
    document.getElementById("dateFilter");

const rows =
    document.querySelectorAll(
        "#appointmentsTable tbody tr[data-search]"
    );


function filterAppointments() {

    const search =
        searchInput.value
            .toLowerCase()
            .trim();

    const status =
        statusFilter.value;

    const date =
        dateFilter.value;

    rows.forEach(row => {

        const rowSearch =
            row.dataset.search || "";

        const rowStatus =
            row.dataset.status || "";

        const rowDate =
            row.dataset.date || "";

        const searchMatch =
            !search
            || rowSearch.includes(search);

        const statusMatch =
            status === "ALL"
            || rowStatus === status;

        const dateMatch =
            !date
            || rowDate === date;

        row.style.display =
            searchMatch
            && statusMatch
            && dateMatch
                ? ""
                : "none";
    });
}


searchInput.addEventListener(
    "input",
    filterAppointments
);

statusFilter.addEventListener(
    "change",
    filterAppointments
);

dateFilter.addEventListener(
    "change",
    filterAppointments
);


function confirmCancellation(
    appointmentNumber) {

    return confirm(
        "Are you sure you want to cancel appointment "
        + appointmentNumber
        + "?\n\n"
        + "The appointment will be cancelled and "
        + "the time slot will become available again."
    );
}

</script>

</body>

</html>