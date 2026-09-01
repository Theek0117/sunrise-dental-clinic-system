<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    Appointment appointment =
            (Appointment) request.getAttribute("appointment");

    Patient patient =
            (Patient) request.getAttribute("patient");

    Dentist currentDentist =
            (Dentist) request.getAttribute("dentist");

    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");

    if (dentists == null) {
        dentists = Collections.emptyList();
    }

    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }

    String errorMessage =
            (String) request.getAttribute("error");

    String currentReason =
            appointment != null
                    ? appointment.getReason()
                    : "";

    boolean standardReason =
            "Dental Check-up".equalsIgnoreCase(currentReason)
            || "Tooth Pain".equalsIgnoreCase(currentReason)
            || "Cleaning".equalsIgnoreCase(currentReason)
            || "Filling".equalsIgnoreCase(currentReason)
            || "Extraction".equalsIgnoreCase(currentReason)
            || "Consultation".equalsIgnoreCase(currentReason);
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Reschedule Appointment | Sunrise Dental Clinic
    </title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rescheduleAppointment.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="dashboard-container">

    <!-- SIDEBAR -->
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

            <div class="nav-dropdown open">
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
                    <a href="${pageContext.request.contextPath}/reception/view-appointments" class="nav-subitem active">
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

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <a href="<%= request.getContextPath() %>/reception/view-appointments" class="menu-button">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h1>Reschedule Appointment</h1>
                    <p>Modify appointment doctor, time slot, and patient booking details</p>
                </div>
            </div>

            <div class="topbar-right">
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

            <!-- Hero Banner -->
            <div class="welcome-section">
                <div>
                    <h2>Reschedule Booking</h2>
                    <p>Select a new dentist, date and available time slot for the patient.</p>
                </div>
            </div>

        <div class="page-heading">

            <div class="heading-icon">

                <i class="bi bi-arrow-repeat"></i>

            </div>

            <div>

                <h2>
                    Change Appointment Schedule
                </h2>

                <p>
                    Modifying this appointment will release the previous
                    time slot and notify the patient via email.
                </p>

            </div>

        </div>

        <% if (errorMessage != null
                && !errorMessage.isBlank()) { %>

            <div class="alert error">

                <strong>

                    <i class="bi bi-exclamation-triangle-fill"></i>

                    Error:

                </strong>

                <%= errorMessage %>

            </div>

        <% } %>

        <% if (appointment == null) { %>

            <div class="alert error">

                Appointment details could not be found.

                <a href="<%= request.getContextPath() %>/reception/view-appointments"
                   style="color:#c92a2a; font-weight:600; text-decoration:underline;">

                    Return to Appointments

                </a>

            </div>

        <% } else { %>

        <form id="rescheduleForm"
              method="post"
              action="<%= request.getContextPath() %>/reception/reschedule-appointment">

            <input type="hidden"
                   name="appointmentId"
                   id="appointmentId"
                   value="<%= appointment.getAppointmentId() %>">

            <input type="hidden"
                   name="availabilityId"
                   id="availabilityId"
                   value="">

            <input type="hidden"
                   name="startTime"
                   id="startTime"
                   value="">

            <input type="hidden"
                   name="endTime"
                   id="endTime"
                   value="">

            <!-- STEP 1 -->

            <section class="form-section">

                <div class="section-heading">

                    <span class="step">
                        1
                    </span>

                    <div>

                        <h3>
                            Current Appointment Details
                        </h3>

                        <p>
                            Existing record before rescheduling.
                        </p>

                    </div>

                </div>

                <div class="current-appointment">

                    <div class="appointment-item">

                        <span>
                            Appointment #
                        </span>

                        <strong>
                            <%= appointment.getAppointmentNumber() %>
                        </strong>

                    </div>

                    <div class="appointment-item">

                        <span>
                            Patient
                        </span>

                        <strong>
                            <%= patient != null
                                    ? patient.getName()
                                    : "Patient #" + appointment.getPatientId() %>
                        </strong>

                    </div>

                    <div class="appointment-item">

                        <span>
                            Current Dentist
                        </span>

                        <strong>
                            <%= currentDentist != null
                                    ? "Dr. " + currentDentist.getName()
                                    : "Dentist #" + appointment.getDentistId() %>
                        </strong>

                    </div>

                    <div class="appointment-item">

                        <span>
                            Current Date
                        </span>

                        <strong>
                            <%= appointment.getAppointmentDate() %>
                        </strong>

                    </div>

                    <div class="appointment-item">

                        <span>
                            Current Time
                        </span>

                        <strong>

                            <%= appointment.getStartTime() %>
                            -
                            <%= appointment.getEndTime() %>

                        </strong>

                    </div>

                    <div class="appointment-item">

                        <span>
                            Current Status
                        </span>

                        <strong style="color:#0ea5b4;">

                            <%= appointment.getStatus() %>

                        </strong>

                    </div>

                </div>

            </section>

            <!-- STEP 2 -->

            <section class="form-section">

                <div class="section-heading">

                    <span class="step">
                        2
                    </span>

                    <div>

                        <h3>
                            Select Dentist
                        </h3>

                        <p>
                            Choose the assigned doctor for this session.
                        </p>

                    </div>

                </div>

                <div class="form-group">

                    <label for="dentistId">

                        Dentist
                        <span>*</span>

                    </label>

                    <select name="dentistId"
                            id="dentistId"
                            required>

                        <option value="">
                            -- Choose a Dentist --
                        </option>

                        <% for (Dentist d : dentists) { %>

                            <option value="<%= d.getDentistId() %>"
                                <%= appointment.getDentistId()
                                        == d.getDentistId()
                                        ? "selected"
                                        : "" %>>

                                Dr. <%= d.getName() %>

                                <%= d.getSpecialization() != null
                                        && !d.getSpecialization().isBlank()
                                        ? " • " + d.getSpecialization()
                                        : "" %>

                            </option>

                        <% } %>

                    </select>

                    <small>
                        Select a dentist to view their availability.
                    </small>

                </div>

            </section>

            <!-- STEP 3 -->

            <section class="form-section">

                <div class="section-heading">

                    <span class="step">
                        3
                    </span>

                    <div>

                        <h3>
                            Select New Date
                        </h3>

                        <p>
                            Choose an appointment date from the calendar.
                        </p>

                    </div>

                </div>

                <div class="form-group">

                    <label for="appointmentDate">

                        Appointment Date
                        <span>*</span>

                    </label>

                    <input type="date"
                           name="appointmentDate"
                           id="appointmentDate"
                           value="<%= appointment.getAppointmentDate() %>"
                           required>

                </div>

            </section>

            <!-- STEP 4 -->

            <section class="form-section">

                <div class="section-heading">

                    <span class="step">
                        4
                    </span>

                    <div>

                        <h3>
                            Available Time Slot
                        </h3>

                        <p>
                            Click on one available 30-minute consultation slot.
                        </p>

                    </div>

                </div>

                <div id="availabilityMessage"
                     class="availability-message">

                    Select a dentist and date to view available slots.

                </div>

                <div id="timeSlots"
                     class="time-slots">
                </div>

            </section>

            <!-- STEP 5 -->

            <section class="form-section">

                <div class="section-heading">

                    <span class="step">
                        5
                    </span>

                    <div>

                        <h3>
                            Appointment Reason
                        </h3>

                        <p>
                            Update the treatment reason if required.
                        </p>

                    </div>

                </div>

                <div class="form-group">

                    <label for="reasonSelect">

                        Reason
                        <span>*</span>

                    </label>

                    <select id="reasonSelect">

                        <option value="Dental Check-up"
                            <%= "Dental Check-up".equalsIgnoreCase(currentReason)
                                    ? "selected"
                                    : "" %>>

                            Dental Check-up

                        </option>

                        <option value="Tooth Pain"
                            <%= "Tooth Pain".equalsIgnoreCase(currentReason)
                                    ? "selected"
                                    : "" %>>

                            Tooth Pain

                        </option>

                        <option value="Cleaning"
                            <%= "Cleaning".equalsIgnoreCase(currentReason)
                                    ? "selected"
                                    : "" %>>

                            Cleaning

                        </option>

                        <option value="Filling"
                            <%= "Filling".equalsIgnoreCase(currentReason)
                                    ? "selected"
                                    : "" %>>

                            Filling

                        </option>

                        <option value="Extraction"
                            <%= "Extraction".equalsIgnoreCase(currentReason)
                                    ? "selected"
                                    : "" %>>

                            Extraction

                        </option>

                        <option value="Consultation"
                            <%= "Consultation".equalsIgnoreCase(currentReason)
                                    ? "selected"
                                    : "" %>>

                            Consultation

                        </option>

                        <option value="Other"
                            <%= !standardReason
                                    ? "selected"
                                    : "" %>>

                            Other (Custom Reason)

                        </option>

                    </select>

                    <textarea id="otherReason"
                              placeholder="Specify custom reason..."
                              style="display:<%= !standardReason
                                      ? "block"
                                      : "none" %>; margin-top:10px;"><%= !standardReason
                                      ? currentReason
                                      : "" %></textarea>

                    <input type="hidden"
                           name="reason"
                           id="reason"
                           value="<%= currentReason != null
                                    ? currentReason
                                    : "Dental Check-up" %>">

                </div>

            </section>

            <!-- ACTIONS -->

            <div class="form-actions">

                <a href="<%= request.getContextPath() %>/reception/view-appointments"
                   class="cancel-button">

                    <i class="bi bi-x-lg"></i>

                    Cancel

                </a>

                <button type="submit"
                        class="save-button"
                        id="saveButton"
                        disabled>

                    <i class="bi bi-calendar-check-fill"></i>

                    Confirm Reschedule

                </button>

            </div>

        </form>

        <% } %>

        </section>

    </main>

</div>

<script>

const contextPath =
    "<%= request.getContextPath() %>";

const dentistSelect =
    document.getElementById("dentistId");

const dateInput =
    document.getElementById("appointmentDate");

const appointmentIdInput =
    document.getElementById("appointmentId");

const availabilityIdInput =
    document.getElementById("availabilityId");

const startTimeInput =
    document.getElementById("startTime");

const endTimeInput =
    document.getElementById("endTime");

const timeSlots =
    document.getElementById("timeSlots");

const availabilityMessage =
    document.getElementById("availabilityMessage");

const saveButton =
    document.getElementById("saveButton");

const reasonSelect =
    document.getElementById("reasonSelect");

const otherReason =
    document.getElementById("otherReason");

const reasonInput =
    document.getElementById("reason");


/*
 * ==========================================
 * MINIMUM DATE
 * ==========================================
 */

const today =
    new Date();

const yyyy =
    today.getFullYear();

const mm =
    String(
        today.getMonth() + 1
    ).padStart(2, "0");

const dd =
    String(
        today.getDate()
    ).padStart(2, "0");

if (dateInput) {

    dateInput.min =
        yyyy + "-" + mm + "-" + dd;
}


/*
 * ==========================================
 * LOAD DENTIST AVAILABILITY
 * ==========================================
 */

async function loadSlots() {

    if (!dentistSelect
            || !dateInput
            || !timeSlots
            || !availabilityMessage
            || !saveButton) {

        return;
    }

    const dentistId =
        dentistSelect.value;

    const date =
        dateInput.value;

    /*
     * Clear old selection
     */

    timeSlots.innerHTML = "";

    availabilityIdInput.value = "";
    startTimeInput.value = "";
    endTimeInput.value = "";

    saveButton.disabled = true;

    if (!dentistId || !date) {

        availabilityMessage.textContent =
            "Select a dentist and date to view available slots.";

        availabilityMessage.className =
            "availability-message";

        return;
    }

    availabilityMessage.textContent =
        "Checking available appointment slots...";

    availabilityMessage.className =
        "availability-message";


    try {

        const appointmentId =
            appointmentIdInput
                ? appointmentIdInput.value
                : "";


        const url =
            contextPath
            + "/reception/dentist-availability"
            + "?dentistId="
            + encodeURIComponent(dentistId)
            + "&date="
            + encodeURIComponent(date)
            + "&appointmentId="
            + encodeURIComponent(appointmentId)
            + "&ajax=true";


        const response =
            await fetch(
                url,
                {
                    method: "GET",
                    headers: {
                        "Accept": "application/json"
                    },
                    cache: "no-store"
                }
            );


        if (!response.ok) {

            throw new Error(
                "Availability request failed. HTTP "
                + response.status
            );
        }


        const contentType =
            response.headers.get(
                "content-type"
            ) || "";


        if (!contentType.includes(
                "application/json")) {

            const text =
                await response.text();

            console.error(
                "Expected JSON but received:",
                text
            );

            throw new Error(
                "Server did not return JSON."
            );
        }


        const slots =
            await response.json();


        if (!Array.isArray(slots)
                || slots.length === 0) {

            availabilityMessage.textContent =
                "No availability configured for this dentist on "
                + date
                + ". Please pick another date.";

            availabilityMessage.className =
                "availability-message warning";

            return;
        }


        let availableCount = 0;


        /*
         * Current appointment information
         */

        const currentStart =
            normalizeTime(
                "<%= appointment != null
                        && appointment.getStartTime() != null
                        ? appointment.getStartTime()
                        : "" %>"
            );


        const currentEnd =
            normalizeTime(
                "<%= appointment != null
                        && appointment.getEndTime() != null
                        ? appointment.getEndTime()
                        : "" %>"
            );


        const currentDentistId =
            "<%= appointment != null
                    ? appointment.getDentistId()
                    : 0 %>";


        const currentDate =
            "<%= appointment != null
                    && appointment.getAppointmentDate() != null
                    ? appointment.getAppointmentDate()
                    : "" %>";


        slots.forEach(
            slot => {

                const button =
                    document.createElement(
                        "button"
                    );

                button.type =
                    "button";

                button.className =
                    "time-slot";


                const start =
                    formatTime(
                        slot.startTime
                    );

                const end =
                    formatTime(
                        slot.endTime
                    );


                const remaining =
                    Number(
                        slot.remainingCapacity || 0
                    );


                button.innerHTML =
                    "<strong>"
                    + start
                    + " - "
                    + end
                    + "</strong>"
                    + "<span>"
                    + remaining
                    + " slot"
                    + (
                        remaining === 1
                            ? ""
                            : "s"
                    )
                    + " left"
                    + "</span>";


                /*
                 * IMPORTANT:
                 *
                 * Database status is AVAILABLE.
                 *
                 * The old code incorrectly checked
                 * for ACTIVE here.
                 */

                const status =
                    slot.status
                        ? String(
                                slot.status
                          ).toUpperCase()
                        : "";


                const unavailable =
                    Boolean(slot.full)
                    || Boolean(slot.past)
                    || (
                        status
                        && status !== "AVAILABLE"
                    );


                if (unavailable) {

                    button.disabled =
                        true;

                    button.classList.add(
                        "disabled"
                    );

                } else {

                    availableCount++;


                    button.addEventListener(
                        "click",
                        () => {

                            document
                                .querySelectorAll(
                                    ".time-slot.selected"
                                )
                                .forEach(
                                    selected => {

                                        selected.classList.remove(
                                            "selected"
                                        );
                                    }
                                );


                            button.classList.add(
                                "selected"
                            );


                            availabilityIdInput.value =
                                slot.availabilityId;


                            startTimeInput.value =
                                normalizeTime(
                                    slot.startTime
                                );


                            endTimeInput.value =
                                normalizeTime(
                                    slot.endTime
                                );


                            saveButton.disabled =
                                false;
                        }
                    );
                }


                timeSlots.appendChild(
                    button
                );


                /*
                 * ======================================
                 * AUTO SELECT CURRENT SLOT
                 * ======================================
                 */

                const slotStart =
                    normalizeTime(
                        slot.startTime
                    );


                const slotEnd =
                    normalizeTime(
                        slot.endTime
                    );


                const sameCurrentSlot =
                    dentistId === currentDentistId
                    && date === currentDate
                    && slotStart === currentStart
                    && slotEnd === currentEnd;


                if (sameCurrentSlot
                        && !unavailable) {

                    button.classList.add(
                        "selected"
                    );


                    availabilityIdInput.value =
                        slot.availabilityId;


                    startTimeInput.value =
                        slotStart;


                    endTimeInput.value =
                        slotEnd;


                    saveButton.disabled =
                        false;
                }
            }
        );


        if (availableCount > 0) {

            availabilityMessage.textContent =
                availableCount
                + " slot(s) available. Click a slot to select.";

            availabilityMessage.className =
                "availability-message";

        } else {

            availabilityMessage.textContent =
                "All appointment slots for this date are fully booked or in the past.";

            availabilityMessage.className =
                "availability-message warning";
        }


    } catch (error) {

        console.error(
            "Dentist availability error:",
            error
        );


        availabilityMessage.textContent =
            "Unable to check appointment availability.";

        availabilityMessage.className =
            "availability-message error";
    }
}


/*
 * ==========================================
 * FORMAT TIME
 * ==========================================
 */

function formatTime(value) {

    if (!value) {
        return "-";
    }


    const parts =
        String(value).split(":");


    if (parts.length < 2) {
        return value;
    }


    const hour =
        parseInt(
            parts[0],
            10
        );


    const minute =
        parts[1];


    const suffix =
        hour >= 12
            ? "PM"
            : "AM";


    const displayHour =
        hour % 12 || 12;


    return displayHour
        + ":"
        + minute
        + " "
        + suffix;
}


/*
 * ==========================================
 * NORMALIZE TIME
 *
 * Converts:
 *
 * 09:00
 * 09:00:00
 * 09:00:00.0
 *
 * to:
 *
 * 09:00:00
 * ==========================================
 */

function normalizeTime(value) {

    if (!value) {
        return "";
    }


    const parts =
        String(value).split(":");


    if (parts.length < 2) {
        return "";
    }


    const hour =
        parts[0].padStart(
            2,
            "0"
        );


    const minute =
        parts[1].padStart(
            2,
            "0"
        );


    const second =
        parts.length >= 3
            ? parts[2]
                    .substring(0, 2)
                    .padStart(2, "0")
            : "00";


    return hour
        + ":"
        + minute
        + ":"
        + second;
}


/*
 * ==========================================
 * REASON
 * ==========================================
 */

function updateReason() {

    if (!reasonSelect
            || !reasonInput
            || !otherReason) {

        return;
    }


    if (reasonSelect.value === "Other") {

        otherReason.style.display =
            "block";


        reasonInput.value =
            otherReason.value.trim();

    } else {

        otherReason.style.display =
            "none";


        reasonInput.value =
            reasonSelect.value;
    }
}


if (reasonSelect) {

    reasonSelect.addEventListener(
        "change",
        updateReason
    );
}


if (otherReason) {

    otherReason.addEventListener(
        "input",
        updateReason
    );
}


if (dentistSelect) {

    dentistSelect.addEventListener(
        "change",
        loadSlots
    );
}


if (dateInput) {

    dateInput.addEventListener(
        "change",
        loadSlots
    );
}


/*
 * ==========================================
 * FORM SUBMIT
 * ==========================================
 */

const form =
    document.getElementById(
        "rescheduleForm"
    );


if (form) {

    form.addEventListener(
        "submit",
        function(event) {

            updateReason();


            if (!availabilityIdInput.value
                    || !startTimeInput.value
                    || !endTimeInput.value) {

                event.preventDefault();

                alert(
                    "Please click and select an available time slot before submitting."
                );

                return;
            }


            if (!reasonInput.value.trim()) {

                event.preventDefault();

                alert(
                    "Please provide the appointment reason."
                );

                return;
            }


            saveButton.disabled =
                true;


            saveButton.innerHTML =
                '<i class="bi bi-hourglass-split"></i> Rescheduling...';
        }
    );
}


/*
 * ==========================================
 * INITIALIZATION
 * ==========================================
 */

updateReason();


if (dentistSelect
        && dentistSelect.value
        && dateInput
        && dateInput.value) {

    loadSlots();
}

</script>

</body>
</html>