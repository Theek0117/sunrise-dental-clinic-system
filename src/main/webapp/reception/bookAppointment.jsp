<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>

<%
    /*
     * =========================================================
     * SESSION / REQUEST DATA
     * =========================================================
     */

    String staffName = (String) session.getAttribute("staffName");

    if (staffName == null || staffName.trim().isEmpty()) {
        staffName = "Receptionist";
    }

    List<Patient> patients =
            (List<Patient>) request.getAttribute("patients");

    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");

    List<TreatmentType> treatmentTypes =
            (List<TreatmentType>) request.getAttribute("treatmentTypes");

    if (patients == null) {
        patients = Collections.emptyList();
    }

    if (dentists == null) {
        dentists = Collections.emptyList();
    }

    if (treatmentTypes == null) {
        treatmentTypes = Collections.emptyList();
    }

    String contextPath = request.getContextPath();

    /*
     * =========================================================
     * MESSAGE DATA
     * =========================================================
     */

    Object successMessage = request.getAttribute("success");
    Object errorMessage = request.getAttribute("error");
    Object appointmentNumber = request.getAttribute("appointmentNumber");
    Object emailMessage = request.getAttribute("emailMessage");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <meta name="description"
          content="Book a new patient appointment at Sunrise Dental Clinic">

    <title>Book Appointment | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Main page stylesheet -->
    <link rel="stylesheet"
          href="<%= contextPath %>/css/book-appointment.css">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="booking-page">

    <!-- =====================================================
         HEADER
         ===================================================== -->

    <header class="booking-header">

        <div class="header-left">

            <a href="<%= contextPath %>/reception/dashboard"
               class="back-button"
               aria-label="Back to reception dashboard"
               title="Back to Dashboard">

                <i class="bi bi-arrow-left"></i>

            </a>

            <div class="header-title">

                <h1>Book Appointment</h1>

                <p>Schedule a new patient appointment</p>

            </div>

        </div>


        <div class="header-user">

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

        </div>

    </header>


    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="booking-content">


        <!-- =================================================
             PAGE INTRODUCTION
             ================================================= -->

        <section class="page-introduction">

            <div class="intro-icon">
                <i class="bi bi-calendar-plus"></i>
            </div>

            <div class="intro-content">

                <h2>Create New Appointment</h2>

                <p>
                    Select a patient, dentist, date and available
                    appointment time.
                </p>

            </div>

        </section>


        <!-- =================================================
             SUCCESS MESSAGE
             ================================================= -->

        <% if (successMessage != null) { %>

            <div class="message success-message"
                 role="alert">

                <div class="message-icon">
                    <i class="bi bi-check-circle-fill"></i>
                </div>

                <div class="message-content">

                    <strong>
                        Appointment Booked Successfully
                    </strong>

                    <p>
                        <%= successMessage %>
                    </p>


                    <% if (appointmentNumber != null) { %>

                        <div class="appointment-number">

                            <span>
                                Appointment Number
                            </span>

                            <strong>
                                <%= appointmentNumber %>
                            </strong>

                        </div>

                    <% } %>


                    <% if (emailMessage != null) { %>

                        <p class="email-status">

                            <i class="bi bi-envelope-check"></i>

                            <span>
                                <%= emailMessage %>
                            </span>

                        </p>

                    <% } %>

                </div>

            </div>

        <% } %>


        <!-- =================================================
             ERROR MESSAGE
             ================================================= -->

        <% if (errorMessage != null) { %>

            <div class="message error-message"
                 role="alert">

                <div class="message-icon">

                    <i class="bi bi-exclamation-circle-fill"></i>

                </div>

                <div class="message-content">

                    <strong>
                        Unable to Book Appointment
                    </strong>

                    <p>
                        <%= errorMessage %>
                    </p>

                </div>

            </div>

        <% } %>


        <!-- =================================================
             BOOKING FORM
             ================================================= -->

        <form
            action="<%= contextPath %>/reception/book-appointment"
            method="post"
            class="booking-form"
            id="bookingForm"
            autocomplete="off">


            <!-- =================================================
                 STEP 1: PATIENT
                 ================================================= -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">
                        1
                    </div>

                    <div class="section-heading">

                        <h3>
                            Patient Information
                        </h3>

                        <p>
                            Search and select the patient for this appointment.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label for="patientSearch">

                        Patient

                        <span class="required"
                              aria-hidden="true">*</span>

                    </label>


                    <!-- SEARCHABLE PATIENT -->

                    <div class="search-select"
                         id="patientSearchSelect">

                        <div class="search-input-wrapper">

                            <i class="bi bi-search search-icon"
                               aria-hidden="true"></i>

                            <input
                                type="text"
                                id="patientSearch"
                                placeholder="Search by patient name, number, contact or email..."
                                autocomplete="off"
                                aria-label="Search patient"
                                aria-controls="patientResults"
                                aria-expanded="false">

                            <button
                                type="button"
                                class="search-toggle"
                                id="patientSearchToggle"
                                aria-label="Show patients"
                                tabindex="-1">

                                <i class="bi bi-chevron-down search-arrow"></i>

                            </button>

                        </div>


                        <div
                            class="search-results"
                            id="patientResults"
                            role="listbox"
                            aria-label="Patient search results">

                            <% for (Patient patient : patients) { %>

                                <div
                                    class="search-result patient-result"
                                    role="option"
                                    tabindex="0"

                                    data-id="<%= patient.getPatientId() %>"
                                    data-name="<%= patient.getName() != null ? patient.getName() : "" %>"
                                    data-number="<%= patient.getPatientNumber() != null ? patient.getPatientNumber() : "" %>"
                                    data-email="<%= patient.getEmail() != null ? patient.getEmail() : "" %>"
                                    data-contact="<%= patient.getContactNumber() != null ? patient.getContactNumber() : "" %>"

                                    data-search="<%= (
                                            (patient.getPatientNumber() != null ? patient.getPatientNumber() : "")
                                            + " "
                                            + (patient.getName() != null ? patient.getName() : "")
                                            + " "
                                            + (patient.getContactNumber() != null ? patient.getContactNumber() : "")
                                            + " "
                                            + (patient.getEmail() != null ? patient.getEmail() : "")
                                    ).toLowerCase() %>">

                                    <div class="result-icon">

                                        <i class="bi bi-person"></i>

                                    </div>


                                    <div class="result-information">

                                        <strong>

                                            <%= patient.getPatientNumber() != null
                                                    ? patient.getPatientNumber()
                                                    : "No patient number" %>

                                            <span class="result-separator">
                                                -
                                            </span>

                                            <%= patient.getName() != null
                                                    ? patient.getName()
                                                    : "Unnamed Patient" %>

                                        </strong>


                                        <span class="result-details">

                                            <%= patient.getContactNumber() != null
                                                    && !patient.getContactNumber().isBlank()
                                                    ? patient.getContactNumber()
                                                    : "No contact number" %>


                                            <% if (patient.getEmail() != null
                                                    && !patient.getEmail().isBlank()) { %>

                                                <span class="result-dot">
                                                    •
                                                </span>

                                                <%= patient.getEmail() %>

                                            <% } %>

                                        </span>

                                    </div>

                                </div>

                            <% } %>


                            <% if (patients.isEmpty()) { %>

                                <div class="no-results">

                                    <i class="bi bi-person-x"></i>

                                    <span>
                                        No active patients found.
                                    </span>

                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- REAL PATIENT ID SENT TO SERVLET -->

                    <input
                        type="hidden"
                        id="patientId"
                        name="patientId"
                        value="">


                    <small class="form-help">

                        <i class="bi bi-info-circle"></i>

                        Search by patient name, patient number,
                        contact number or email.

                    </small>

                </div>


                <!-- =================================================
                     SELECTED PATIENT
                     ================================================= -->

                <div
                    class="selected-record"
                    id="selectedPatient"
                    aria-live="polite">

                    <div class="selected-record-icon">

                        <i class="bi bi-person-check"></i>

                    </div>


                    <div class="selected-record-info">

                        <span>
                            Selected Patient
                        </span>

                        <strong id="selectedPatientName">
                            No patient selected
                        </strong>

                    </div>


                    <button
                        type="button"
                        class="clear-selection"
                        id="clearPatient"
                        aria-label="Clear selected patient"
                        title="Clear patient">

                        <i class="bi bi-x"></i>

                    </button>

                </div>


                <!-- =================================================
                     PATIENT PREVIEW
                     ================================================= -->

                <div
                    class="patient-preview"
                    id="patientPreview">

                    <div class="preview-item">

                        <i class="bi bi-envelope"></i>

                        <div>

                            <span>
                                Email
                            </span>

                            <strong id="patientEmail">
                                -
                            </strong>

                        </div>

                    </div>


                    <div class="preview-item">

                        <i class="bi bi-telephone"></i>

                        <div>

                            <span>
                                Contact Number
                            </span>

                            <strong id="patientContact">
                                -
                            </strong>

                        </div>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 STEP 2: DENTIST
                 ================================================= -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">
                        2
                    </div>

                    <div class="section-heading">

                        <h3>
                            Dentist
                        </h3>

                        <p>
                            Search and select the dentist for the appointment.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label for="dentistSearch">

                        Dentist

                        <span class="required"
                              aria-hidden="true">*</span>

                    </label>


                    <!-- SEARCHABLE DENTIST -->

                    <div class="search-select"
                         id="dentistSearchSelect">

                        <div class="search-input-wrapper">

                            <i class="bi bi-search search-icon"
                               aria-hidden="true"></i>

                            <input
                                type="text"
                                id="dentistSearch"
                                placeholder="Search dentist by name, number or specialization..."
                                autocomplete="off"
                                aria-label="Search dentist"
                                aria-controls="dentistResults"
                                aria-expanded="false">

                            <button
                                type="button"
                                class="search-toggle"
                                id="dentistSearchToggle"
                                aria-label="Show dentists"
                                tabindex="-1">

                                <i class="bi bi-chevron-down search-arrow"></i>

                            </button>

                        </div>


                        <div
                            class="search-results"
                            id="dentistResults"
                            role="listbox"
                            aria-label="Dentist search results">

                            <% for (Dentist dentist : dentists) { %>

                                <div
                                    class="search-result dentist-result"
                                    role="option"
                                    tabindex="0"

                                    data-id="<%= dentist.getDentistId() %>"
                                    data-name="<%= dentist.getName() != null ? dentist.getName() : "" %>"
                                    data-number="<%= dentist.getDentistNumber() != null ? dentist.getDentistNumber() : "" %>"
                                    data-room="<%= dentist.getRoomNumber() != null ? dentist.getRoomNumber() : "" %>"
                                    data-specialization="<%= dentist.getSpecialization() != null ? dentist.getSpecialization() : "" %>"

                                    data-search="<%= (
                                            (dentist.getDentistNumber() != null ? dentist.getDentistNumber() : "")
                                            + " "
                                            + (dentist.getName() != null ? dentist.getName() : "")
                                            + " "
                                            + (dentist.getRoomNumber() != null ? dentist.getRoomNumber() : "")
                                            + " "
                                            + (dentist.getSpecialization() != null ? dentist.getSpecialization() : "")
                                    ).toLowerCase() %>">

                                    <div class="result-icon dentist-result-icon">

                                        <i class="bi bi-person-badge"></i>

                                    </div>


                                    <div class="result-information">

                                        <strong>

                                            <%= dentist.getName() != null
                                                    ? dentist.getName()
                                                    : "Unnamed Dentist" %>

                                        </strong>


                                        <span class="result-details">

                                            <%= dentist.getDentistNumber() != null
                                                    ? dentist.getDentistNumber()
                                                    : "No dentist number" %>


                                            <% if (dentist.getRoomNumber() != null
                                                    && !dentist.getRoomNumber().isBlank()) { %>

                                                <span class="result-dot">
                                                    •
                                                </span>

                                                <i class="bi bi-door-open"></i>

                                                <%= dentist.getRoomNumber() %>

                                            <% } %>


                                            <% if (dentist.getSpecialization() != null
                                                    && !dentist.getSpecialization().isBlank()) { %>

                                                <span class="result-dot">
                                                    •
                                                </span>

                                                <%= dentist.getSpecialization() %>

                                            <% } %>

                                        </span>

                                    </div>

                                </div>

                            <% } %>


                            <% if (dentists.isEmpty()) { %>

                                <div class="no-results">

                                    <i class="bi bi-person-x"></i>

                                    <span>
                                        No active dentists found.
                                    </span>

                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- REAL DENTIST ID SENT TO SERVLET -->

                    <input
                        type="hidden"
                        id="dentistId"
                        name="dentistId"
                        value="">


                    <small class="form-help">

                        <i class="bi bi-info-circle"></i>

                        Search by dentist name, dentist number,
                        room or specialization.

                    </small>

                </div>


                <!-- =================================================
                     SELECTED DENTIST
                     ================================================= -->

                <div
                    class="selected-record"
                    id="selectedDentist"
                    aria-live="polite">

                    <div class="selected-record-icon">

                        <i class="bi bi-person-check"></i>

                    </div>


                    <div class="selected-record-info">

                        <span>
                            Selected Dentist
                        </span>

                        <strong id="selectedDentistName">
                            No dentist selected
                        </strong>

                        <span id="selectedDentistRoom">
                            Room not assigned
                        </span>

                    </div>


                    <button
                        type="button"
                        class="clear-selection"
                        id="clearDentist"
                        aria-label="Clear selected dentist"
                        title="Clear dentist">

                        <i class="bi bi-x"></i>

                    </button>

                </div>

            </section>


            <!-- =================================================
                 STEP 3: DATE
                 ================================================= -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">
                        3
                    </div>

                    <div class="section-heading">

                        <h3>
                            Appointment Date
                        </h3>

                        <p>
                            Select a date when the dentist is available.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label for="appointmentDate">

                        Date

                        <span class="required"
                              aria-hidden="true">*</span>

                    </label>


                    <div class="date-input-wrapper">

                        <i class="bi bi-calendar3"></i>

                        <input
                            type="date"
                            id="appointmentDate"
                            name="appointmentDate"
                            required>

                    </div>


                    <small class="form-help">

                        <i class="bi bi-info-circle"></i>

                        Select a dentist first or choose a date,
                        then available periods will be checked automatically.

                    </small>

                </div>

            </section>


            <!-- =================================================
                 STEP 4: AVAILABLE TIME
                 ================================================= -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">
                        4
                    </div>

                    <div class="section-heading">

                        <h3>
                            Available Time
                        </h3>

                        <p>
                            Select an available appointment period.
                        </p>

                    </div>

                </div>


                <!-- AVAILABILITY STATUS -->

                <div
                    class="availability-message"
                    id="availabilityMessage"
                    role="status"
                    aria-live="polite">

                    <i class="bi bi-info-circle"></i>

                    <span>
                        Select a dentist and date to view available times.
                    </span>

                </div>


                <!-- TIME SLOTS -->

                <div
                    class="time-slots"
                    id="timeSlots"
                    aria-live="polite">
                </div>


                <!-- REAL AVAILABILITY VALUES SENT TO SERVLET -->

                <input
                    type="hidden"
                    id="availabilityId"
                    name="availabilityId"
                    value="">


                <input
                    type="hidden"
                    id="startTime"
                    name="startTime"
                    value="">


                <input
                    type="hidden"
                    id="endTime"
                    name="endTime"
                    value="">

            </section>


            <!-- =================================================
                 STEP 5: APPOINTMENT REASON
                 ================================================= -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">
                        5
                    </div>

                    <div class="section-heading">

                        <h3>
                            Appointment Details
                        </h3>

                        <p>
                            Provide the reason for the visit.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label for="reason">

                        Reason for Visit

                        <span class="required"
                              aria-hidden="true">*</span>

                    </label>


                    <select
					    id="reason"
					    name="reason"
					    required>
					
					    <option value="">
					        Select Appointment Reason
					    </option>
					
					    <% for (TreatmentType treatmentType : treatmentTypes) { %>
					
					        <option
					            value="<%= treatmentType.getTreatmentName() %>">
					
					            <%= treatmentType.getTreatmentName() %>
					
					        </option>
					
					    <% } %>
					
					</select>
                </div>


                <!-- =================================================
                     OTHER REASON
                     ================================================= -->

                <div
                    class="form-group other-reason-group"
                    id="otherReasonGroup">

                    <label for="otherReason">

                        Specify Reason

                        <span class="required"
                              id="otherReasonRequired"
                              aria-hidden="true">*</span>

                    </label>


                    <textarea
                        id="otherReason"
                        name="otherReason"
                        rows="3"
                        placeholder="Enter the reason for the appointment"
                        maxlength="500"></textarea>


                    <small class="form-help">

                        <i class="bi bi-info-circle"></i>

                        Please provide a short description of the reason.

                    </small>

                </div>

            </section>


            <!-- =================================================
                 APPOINTMENT SUMMARY
                 ================================================= -->

            <section class="booking-summary">

                <div class="summary-header">

                    <div class="summary-icon">

                        <i class="bi bi-clipboard-check"></i>

                    </div>

                    <div>

                        <h3>
                            Appointment Summary
                        </h3>

                        <p>
                            Review the details before booking.
                        </p>

                    </div>

                </div>


                <div class="summary-grid">


                    <!-- PATIENT -->

                    <div class="summary-item">

                        <span>
                            Patient
                        </span>

                        <strong id="summaryPatient">
                            Not selected
                        </strong>

                    </div>


                    <!-- DENTIST -->

                    <div class="summary-item">

                        <span>
                            Dentist
                        </span>

                        <strong id="summaryDentist">
                            Not selected
                        </strong>

                    </div>


                    <!-- DATE -->

                    <div class="summary-item">

                        <span>
                            Date
                        </span>

                        <strong id="summaryDate">
                            Not selected
                        </strong>

                    </div>


                    <!-- TIME -->

                    <div class="summary-item">

                        <span>
                            Time
                        </span>

                        <strong id="summaryTime">
                            Not selected
                        </strong>

                    </div>


                    <!-- REASON -->

                    <div class="summary-item summary-reason">

                        <span>
                            Reason
                        </span>

                        <strong id="summaryReason">
                            Not selected
                        </strong>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 FORM ERROR
                 ================================================= -->

            <div
                class="form-validation-message"
                id="formValidationMessage"
                role="alert"
                aria-live="assertive">

                <i class="bi bi-exclamation-circle"></i>

                <span id="formValidationText"></span>

            </div>


            <!-- =================================================
                 ACTION BUTTONS
                 ================================================= -->

            <div class="form-actions">

                <a
                    href="<%= contextPath %>/reception/dashboard"
                    class="cancel-button">

                    <i class="bi bi-arrow-left"></i>

                    <span>
                        Cancel
                    </span>

                </a>


                <button
                    type="submit"
                    class="book-button"
                    id="bookButton">

                    <i class="bi bi-calendar-check"></i>

                    <span>
                        Book Appointment
                    </span>

                </button>

            </div>


        </form>

    </main>

</div>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>

document.addEventListener("DOMContentLoaded", function () {

    /*
     * =========================================================
     * ELEMENTS
     * =========================================================
     */

    const bookingForm =
        document.getElementById("bookingForm");

    /* Patient */

    const patientSearch =
        document.getElementById("patientSearch");

    const patientId =
        document.getElementById("patientId");

    const patientResults =
        document.getElementById("patientResults");

    const patientSearchSelect =
        document.getElementById("patientSearchSelect");

    const patientSearchToggle =
        document.getElementById("patientSearchToggle");

    const selectedPatient =
        document.getElementById("selectedPatient");

    const selectedPatientName =
        document.getElementById("selectedPatientName");

    const patientEmail =
        document.getElementById("patientEmail");

    const patientContact =
        document.getElementById("patientContact");

    const patientPreview =
        document.getElementById("patientPreview");

    const clearPatient =
        document.getElementById("clearPatient");

    /* Dentist */

    const dentistSearch =
        document.getElementById("dentistSearch");

    const dentistId =
        document.getElementById("dentistId");

    const dentistResults =
        document.getElementById("dentistResults");

    const dentistSearchSelect =
        document.getElementById("dentistSearchSelect");

    const dentistSearchToggle =
        document.getElementById("dentistSearchToggle");

    const selectedDentist =
        document.getElementById("selectedDentist");

    const selectedDentistName =
        document.getElementById("selectedDentistName");

    const selectedDentistRoom =
        document.getElementById("selectedDentistRoom");

    const clearDentist =
        document.getElementById("clearDentist");

    /* Date */

    const appointmentDate =
        document.getElementById("appointmentDate");

    /* Availability */

    const availabilityId =
        document.getElementById("availabilityId");

    const startTime =
        document.getElementById("startTime");

    const endTime =
        document.getElementById("endTime");

    const timeSlots =
        document.getElementById("timeSlots");

    const availabilityMessage =
        document.getElementById("availabilityMessage");

    /* Reason */

    const reasonSelect =
        document.getElementById("reason");

    const otherReasonGroup =
        document.getElementById("otherReasonGroup");

    const otherReason =
        document.getElementById("otherReason");

    /* Summary */

    const summaryPatient =
        document.getElementById("summaryPatient");

    const summaryDentist =
        document.getElementById("summaryDentist");

    const summaryDate =
        document.getElementById("summaryDate");

    const summaryTime =
        document.getElementById("summaryTime");

    const summaryReason =
        document.getElementById("summaryReason");

    /* Form validation */

    const formValidationMessage =
        document.getElementById("formValidationMessage");

    const formValidationText =
        document.getElementById("formValidationText");

    const bookButton =
        document.getElementById("bookButton");


    /*
     * =========================================================
     * CONTEXT PATH
     * =========================================================
     */

    const contextPath =
        "<%= contextPath %>";


    /*
     * =========================================================
     * AVAILABILITY REQUEST CONTROL
     *
     * Prevents an older AJAX response from replacing a newer
     * response when the user changes dentist/date quickly.
     * =========================================================
     */

    let availabilityRequestNumber = 0;


    /*
     * =========================================================
     * MINIMUM DATE
     * =========================================================
     */

    const today = new Date();

    const year =
        today.getFullYear();

    const month =
        String(today.getMonth() + 1).padStart(2, "0");

    const day =
        String(today.getDate()).padStart(2, "0");

    const todayString =
        year + "-" + month + "-" + day;

    appointmentDate.min =
        todayString;


    /*
     * =========================================================
     * HELPER: OPEN PATIENT DROPDOWN
     * =========================================================
     */

    function openPatientDropdown() {

        patientSearchSelect.classList.add("active");

        patientSearch.setAttribute(
            "aria-expanded",
            "true"
        );

        filterPatients();

    }


    /*
     * =========================================================
     * HELPER: CLOSE PATIENT DROPDOWN
     * =========================================================
     */

    function closePatientDropdown() {

        patientSearchSelect.classList.remove("active");

        patientSearch.setAttribute(
            "aria-expanded",
            "false"
        );

    }


    /*
     * =========================================================
     * HELPER: OPEN DENTIST DROPDOWN
     * =========================================================
     */

    function openDentistDropdown() {

        dentistSearchSelect.classList.add("active");

        dentistSearch.setAttribute(
            "aria-expanded",
            "true"
        );

        filterDentists();

    }


    /*
     * =========================================================
     * HELPER: CLOSE DENTIST DROPDOWN
     * =========================================================
     */

    function closeDentistDropdown() {

        dentistSearchSelect.classList.remove("active");

        dentistSearch.setAttribute(
            "aria-expanded",
            "false"
        );

    }


    /*
     * =========================================================
     * PATIENT SEARCH
     * =========================================================
     */

    patientSearch.addEventListener(
        "focus",
        function () {

            openPatientDropdown();

        }
    );


    patientSearch.addEventListener(
        "click",
        function () {

            openPatientDropdown();

        }
    );


    patientSearch.addEventListener(
        "input",
        function () {

            /*
             * If the receptionist changes the selected text
             * manually, remove the previously selected ID.
             */

            if (
                patientId.value &&
                patientSearch.value !==
                selectedPatientName.textContent
            ) {

                patientId.value = "";

                selectedPatient.classList.remove(
                    "visible"
                );

                patientPreview.classList.remove(
                    "visible"
                );

                summaryPatient.textContent =
                    "Not selected";
            }

            openPatientDropdown();

        }
    );


    /*
     * =========================================================
     * PATIENT SEARCH TOGGLE
     * =========================================================
     */

    patientSearchToggle.addEventListener(
        "click",
        function () {

            if (
                patientSearchSelect.classList.contains(
                    "active"
                )
            ) {

                closePatientDropdown();

            } else {

                patientSearch.focus();

                openPatientDropdown();

            }

        }
    );


    /*
     * =========================================================
     * FILTER PATIENTS
     * =========================================================
     */

    function filterPatients() {

        const keyword =
            patientSearch.value
                .trim()
                .toLowerCase();

        const results =
            patientResults.querySelectorAll(
                ".patient-result"
            );

        let visibleCount = 0;


        results.forEach(
            function (result) {

                const searchText =
                    result.dataset.search || "";

                const matches =
                    keyword === "" ||
                    searchText.includes(keyword);


                if (matches) {

                    result.style.display = "flex";

                    visibleCount++;

                } else {

                    result.style.display = "none";

                }

            }
        );


        /*
         * Remove previous dynamic message.
         */

        const oldMessage =
            patientResults.querySelector(
                ".dynamic-no-results"
            );

        if (oldMessage) {

            oldMessage.remove();

        }


        /*
         * Display matching result message.
         */

        if (visibleCount === 0) {

            const message =
                document.createElement("div");

            message.className =
                "no-results dynamic-no-results";

            message.innerHTML = `
                <i class="bi bi-search"></i>
                <span>No matching patient found.</span>
            `;

            patientResults.appendChild(message);

        }

    }


    /*
     * =========================================================
     * SELECT PATIENT
     * =========================================================
     */

    function selectPatient(result) {

        const id =
            result.dataset.id || "";

        const name =
            result.dataset.name || "Unnamed Patient";

        const number =
            result.dataset.number || "No patient number";

        const email =
            result.dataset.email || "";

        const contact =
            result.dataset.contact || "";


        patientId.value =
            id;


        patientSearch.value =
            number + " - " + name;


        selectedPatientName.textContent =
            number + " - " + name;


        patientEmail.textContent =
            email || "-";


        patientContact.textContent =
            contact || "-";


        summaryPatient.textContent =
            number + " - " + name;


        selectedPatient.classList.add(
            "visible"
        );


        patientPreview.classList.add(
            "visible"
        );


        closePatientDropdown();

    }


    /*
     * =========================================================
     * PATIENT RESULT CLICK
     * =========================================================
     */

    patientResults.addEventListener(
        "click",
        function (event) {

            const result =
                event.target.closest(
                    ".patient-result"
                );

            if (!result) {
                return;
            }

            selectPatient(result);

        }
    );


    /*
     * =========================================================
     * PATIENT KEYBOARD SELECTION
     * =========================================================
     */

    patientResults.addEventListener(
        "keydown",
        function (event) {

            const result =
                event.target.closest(
                    ".patient-result"
                );

            if (!result) {
                return;
            }


            if (
                event.key === "Enter" ||
                event.key === " "
            ) {

                event.preventDefault();

                selectPatient(result);

            }

        }
    );


    /*
     * =========================================================
     * CLEAR PATIENT
     * =========================================================
     */

    clearPatient.addEventListener(
        "click",
        function () {

            patientId.value = "";

            patientSearch.value = "";

            selectedPatientName.textContent =
                "No patient selected";

            patientEmail.textContent =
                "-";

            patientContact.textContent =
                "-";

            summaryPatient.textContent =
                "Not selected";

            selectedPatient.classList.remove(
                "visible"
            );

            patientPreview.classList.remove(
                "visible"
            );

            patientSearch.focus();

            openPatientDropdown();

        }
    );


    /*
     * =========================================================
     * DENTIST SEARCH
     * =========================================================
     */

    dentistSearch.addEventListener(
        "focus",
        function () {

            openDentistDropdown();

        }
    );


    dentistSearch.addEventListener(
        "click",
        function () {

            openDentistDropdown();

        }
    );


    dentistSearch.addEventListener(
        "input",
        function () {

            /*
             * If dentist text is changed manually after selection,
             * clear the selected dentist ID and availability.
             */

            if (
                dentistId.value &&
                dentistSearch.value !==
                selectedDentistName.textContent
            ) {

                dentistId.value = "";

                selectedDentist.classList.remove(
                    "visible"
                );

                summaryDentist.textContent =
                    "Not selected";

                clearAvailability();

            }

            openDentistDropdown();

        }
    );


    /*
     * =========================================================
     * DENTIST SEARCH TOGGLE
     * =========================================================
     */

    dentistSearchToggle.addEventListener(
        "click",
        function () {

            if (
                dentistSearchSelect.classList.contains(
                    "active"
                )
            ) {

                closeDentistDropdown();

            } else {

                dentistSearch.focus();

                openDentistDropdown();

            }

        }
    );


    /*
     * =========================================================
     * FILTER DENTISTS
     * =========================================================
     */

    function filterDentists() {

        const keyword =
            dentistSearch.value
                .trim()
                .toLowerCase();

        const results =
            dentistResults.querySelectorAll(
                ".dentist-result"
            );

        let visibleCount = 0;


        results.forEach(
            function (result) {

                const searchText =
                    result.dataset.search || "";

                const matches =
                    keyword === "" ||
                    searchText.includes(keyword);


                if (matches) {

                    result.style.display = "flex";

                    visibleCount++;

                } else {

                    result.style.display = "none";

                }

            }
        );


        /*
         * Remove previous dynamic message.
         */

        const oldMessage =
            dentistResults.querySelector(
                ".dynamic-no-results"
            );

        if (oldMessage) {

            oldMessage.remove();

        }


        /*
         * Display no-match message.
         */

        if (visibleCount === 0) {

            const message =
                document.createElement("div");

            message.className =
                "no-results dynamic-no-results";

            message.innerHTML = `
                <i class="bi bi-search"></i>
                <span>No matching dentist found.</span>
            `;

            dentistResults.appendChild(message);

        }

    }


    /*
     * =========================================================
     * SELECT DENTIST
     * =========================================================
     */

    function selectDentist(result) {

        const id =
            result.dataset.id || "";

        const name =
            result.dataset.name || "Unnamed Dentist";

        const number =
            result.dataset.number || "";

        const room =
            result.dataset.room || "";

        const specialization =
            result.dataset.specialization || "";


        dentistId.value =
            id;


        dentistSearch.value =
            name;


        /*
         * Selected dentist display.
         */

        selectedDentistName.textContent =
            name;


        /*
         * Room display.
         */

        if (room.trim() !== "") {

            selectedDentistRoom.innerHTML =
                '<i class="bi bi-door-open"></i> ' +
                "Room " +
                escapeHtml(room);

        } else {

            selectedDentistRoom.textContent =
                "Room not assigned";

        }


        /*
         * Summary.
         */

        let dentistSummary =
            name;

        if (specialization.trim() !== "") {

            dentistSummary +=
                " - " +
                specialization;

        }

        summaryDentist.textContent =
            dentistSummary;


        selectedDentist.classList.add(
            "visible"
        );


        closeDentistDropdown();


        /*
         * Changing dentist always means that the
         * previously selected availability must be removed.
         */

        clearAvailability();


        /*
         * If a date already exists, load availability.
         */

        if (appointmentDate.value) {

            loadAvailability();

        }

    }


    /*
     * =========================================================
     * DENTIST RESULT CLICK
     * =========================================================
     */

    dentistResults.addEventListener(
        "click",
        function (event) {

            const result =
                event.target.closest(
                    ".dentist-result"
                );

            if (!result) {
                return;
            }

            selectDentist(result);

        }
    );


    /*
     * =========================================================
     * DENTIST KEYBOARD SELECTION
     * =========================================================
     */

    dentistResults.addEventListener(
        "keydown",
        function (event) {

            const result =
                event.target.closest(
                    ".dentist-result"
                );

            if (!result) {
                return;
            }


            if (
                event.key === "Enter" ||
                event.key === " "
            ) {

                event.preventDefault();

                selectDentist(result);

            }

        }
    );


    /*
     * =========================================================
     * CLEAR DENTIST
     * =========================================================
     */

    clearDentist.addEventListener(
        "click",
        function () {

            dentistId.value = "";

            dentistSearch.value = "";

            selectedDentistName.textContent =
                "No dentist selected";

            selectedDentistRoom.textContent =
                "Room not assigned";

            summaryDentist.textContent =
                "Not selected";

            selectedDentist.classList.remove(
                "visible"
            );

            clearAvailability();

            dentistSearch.focus();

            openDentistDropdown();

        }
    );


    /*
     * =========================================================
     * DATE CHANGE
     * =========================================================
     */

    appointmentDate.addEventListener(
        "change",
        function () {

            const selectedDate =
                appointmentDate.value;


            if (!selectedDate) {

                summaryDate.textContent =
                    "Not selected";

                clearAvailability();

                return;

            }


            /*
             * Prevent past dates.
             */

            if (selectedDate < todayString) {

                appointmentDate.value = "";

                summaryDate.textContent =
                    "Not selected";

                clearAvailability();

                showFormError(
                    "Please select today or a future date."
                );

                return;

            }


            summaryDate.textContent =
                formatDate(selectedDate);


            /*
             * Clear previous time selection.
             */

            clearAvailability();


            /*
             * Load new availability only when a dentist
             * has already been selected.
             */

            if (dentistId.value) {

                loadAvailability();

            } else {

                setAvailabilityMessage(
                    "info",
                    "bi-info-circle",
                    "Select a dentist to view available times."
                );

            }

        }
    );


    /*
     * =========================================================
     * REASON CHANGE
     * =========================================================
     */

    reasonSelect.addEventListener(
        "change",
        function () {

            updateReason();

        }
    );


    /*
     * =========================================================
     * UPDATE REASON
     * =========================================================
     */

    function updateReason() {

        const reason =
            reasonSelect.value;


        if (reason === "Other") {

            otherReasonGroup.classList.add(
                "visible"
            );

            otherReason.required =
                true;

            summaryReason.textContent =
                otherReason.value.trim()
                    ? "Other: " + otherReason.value.trim()
                    : "Other";

        } else {

            otherReasonGroup.classList.remove(
                "visible"
            );

            otherReason.required =
                false;

            otherReason.value =
                "";

            summaryReason.textContent =
                reason || "Not selected";

        }

    }


    /*
     * =========================================================
     * OTHER REASON INPUT
     * =========================================================
     */

    otherReason.addEventListener(
        "input",
        function () {

            if (reasonSelect.value !== "Other") {
                return;
            }


            const value =
                otherReason.value.trim();


            summaryReason.textContent =
                value
                    ? "Other: " + value
                    : "Other";

        }
    );


    /*
     * =========================================================
     * LOAD DENTIST AVAILABILITY
     * =========================================================
     */

    function loadAvailability() {

        /*
         * Clear previous availability.
         */

        clearAvailability();


        /*
         * Required values.
         */

        if (
            !dentistId.value ||
            !appointmentDate.value
        ) {

            setAvailabilityMessage(
                "info",
                "bi-info-circle",
                "Select a dentist and date to view available times."
            );

            return;

        }


        /*
         * New request number.
         */

        availabilityRequestNumber++;

        const currentRequest =
            availabilityRequestNumber;


        /*
         * Loading message.
         */

        setAvailabilityMessage(
            "loading",
            "bi-arrow-repeat loading-icon",
            "Checking dentist availability..."
        );


        /*
         * Build URL.
         */

        const url =
            contextPath +
            "/reception/dentist-availability" +
            "?dentistId=" +
            encodeURIComponent(
                dentistId.value
            ) +
            "&date=" +
            encodeURIComponent(
                appointmentDate.value
            ) +
            "&ajax=true";


        console.log(
            "Loading dentist availability:",
            url
        );


        /*
         * Fetch availability.
         */

        fetch(
            url,
            {
                method: "GET",

                headers: {
                    "Accept": "application/json"
                },

                cache: "no-store"
            }
        )

        .then(
            function (response) {

                console.log(
                    "Availability response:",
                    response.status
                );


                if (!response.ok) {

                    throw new Error(
                        "Server returned HTTP " +
                        response.status
                    );

                }


                return response.json();

            }
        )

        .then(
            function (data) {

                /*
                 * Ignore old response.
                 */

                if (
                    currentRequest !==
                    availabilityRequestNumber
                ) {

                    return;

                }


                console.log(
                    "Availability JSON:",
                    data
                );


                displayTimeSlots(data);

            }
        )

        .catch(
            function (error) {

                /*
                 * Ignore errors from an old request.
                 */

                if (
                    currentRequest !==
                    availabilityRequestNumber
                ) {

                    return;

                }


                console.error(
                    "Availability loading error:",
                    error
                );


                setAvailabilityMessage(
                    "error",
                    "bi-exclamation-circle",
                    "Unable to load available times. Please try again."
                );

            }
        );

    }


    /*
     * =========================================================
     * CLEAR AVAILABILITY
     * =========================================================
     */

    function clearAvailability() {

        /*
         * Invalidate previous requests.
         */

        availabilityRequestNumber++;


        timeSlots.innerHTML =
            "";


        availabilityId.value =
            "";


        startTime.value =
            "";


        endTime.value =
            "";


        summaryTime.textContent =
            "Not selected";

    }


    /*
     * =========================================================
     * AVAILABILITY MESSAGE
     * =========================================================
     */

    function setAvailabilityMessage(
        type,
        iconClass,
        message
    ) {

        availabilityMessage.className =
            "availability-message " + type;


        availabilityMessage.innerHTML =
            '<i class="bi ' + escapeHtml(iconClass) + '"></i>' +
            '<span>' + escapeHtml(message) + '</span>';

    }


    /*
     * =========================================================
     * DISPLAY TIME SLOTS
     * =========================================================
     */

    function displayTimeSlots(data) {

        timeSlots.innerHTML =
            "";


        /*
         * Your current servlet returns an array.
         *
         * This keeps that structure as the primary format.
         */

        let availabilityData =
            data;


        /*
         * Small compatibility handling if the servlet
         * wraps the array inside an "availability" or
         * "data" property.
         */

        if (
            !Array.isArray(availabilityData) &&
            data &&
            Array.isArray(data.availability)
        ) {

            availabilityData =
                data.availability;

        }


        if (
            !Array.isArray(availabilityData) &&
            data &&
            Array.isArray(data.data)
        ) {

            availabilityData =
                data.data;

        }


        /*
         * No availability.
         */

        if (
            !Array.isArray(availabilityData) ||
            availabilityData.length === 0
        ) {

            setAvailabilityMessage(
                "warning",
                "bi-calendar-x",
                "No availability found for this dentist on the selected date."
            );

            return;

        }


        /*
         * Available.
         */

        setAvailabilityMessage(
            "available",
            "bi-check-circle",
            "Available dentist time periods"
        );


        /*
         * Create buttons.
         */

        availabilityData.forEach(
            function (item) {

                if (!item) {
                    return;
                }


                const rawStartTime =
                    item.startTime;

                const rawEndTime =
                    item.endTime;


                /*
                 * Do not create broken slots.
                 */

                if (
                    !rawStartTime ||
                    !rawEndTime
                ) {

                    return;

                }


                const button =
                    document.createElement(
                        "button"
                    );


                button.type =
                    "button";


                button.className =
                    "time-slot";


                button.setAttribute(
                    "aria-label",
                    "Select " +
                    formatTime(rawStartTime) +
                    " to " +
                    formatTime(rawEndTime)
                );


                const start =
                    formatTime(
                        rawStartTime
                    );


                const end =
                    formatTime(
                        rawEndTime
                    );


                /*
                 * Button content.
                 */

                 button.innerHTML =
                	    '<i class="bi bi-clock"></i>' +
                	    '<span class="time-slot-content">' +
                	        '<strong>' +
                	            escapeHtml(start) +
                	            ' - ' +
                	            escapeHtml(end) +
                	        '</strong>' +
                	        '<small>Available</small>' +
                	    '</span>';


                /*
                 * Store values.
                 */

                button.dataset.availabilityId =
                    item.availabilityId != null
                        ? item.availabilityId
                        : "";


                button.dataset.startTime =
                    rawStartTime;


                button.dataset.endTime =
                    rawEndTime;


                /*
                 * Click.
                 */

                button.addEventListener(
                    "click",
                    function () {

                        selectTimeSlot(
                            button,
                            start,
                            end
                        );

                    }
                );


                timeSlots.appendChild(
                    button
                );

            }
        );


        /*
         * If all records were invalid.
         */

        if (
            timeSlots.children.length === 0
        ) {

            setAvailabilityMessage(
                "warning",
                "bi-calendar-x",
                "No valid appointment periods are available for this date."
            );

        }

    }


    /*
     * =========================================================
     * SELECT TIME SLOT
     * =========================================================
     */

    function selectTimeSlot(
        button,
        start,
        end
    ) {

        /*
         * Remove selection from all slots.
         */

        timeSlots
            .querySelectorAll(".time-slot")
            .forEach(
                function (slot) {

                    slot.classList.remove(
                        "selected"
                    );

                    slot.setAttribute(
                        "aria-pressed",
                        "false"
                    );

                }
            );


        /*
         * Select current slot.
         */

        button.classList.add(
            "selected"
        );


        button.setAttribute(
            "aria-pressed",
            "true"
        );


        /*
         * Set hidden values.
         */

        availabilityId.value =
            button.dataset.availabilityId || "";


        startTime.value =
            button.dataset.startTime || "";


        endTime.value =
            button.dataset.endTime || "";


        /*
         * Update summary.
         */

        summaryTime.textContent =
            start + " - " + end;


        /*
         * Remove form error if the missing item
         * was the time slot.
         */

        hideFormError();


        console.log(
            "Selected availability:",
            availabilityId.value
        );

        console.log(
            "Selected start:",
            startTime.value
        );

        console.log(
            "Selected end:",
            endTime.value
        );

    }


    /*
     * =========================================================
     * TIME FORMATTER
     * =========================================================
     */

    function formatTime(timeValue) {

        if (!timeValue) {

            return "";

        }


        let value =
            String(timeValue).trim();


        /*
         * Handle Java LocalTime style values.
         *
         * Examples:
         * 09:00:00
         * 09:00
         * 14:30:00
         */


        /*
         * If a full date-time is accidentally returned,
         * extract the time section.
         */

        if (value.includes("T")) {

            value =
                value.split("T")[1];

        }


        /*
         * Remove timezone or trailing text.
         */

        value =
            value.split(".")[0];


        const parts =
            value.split(":");


        if (
            parts.length < 2
        ) {

            return value;

        }


        let hours =
            parseInt(
                parts[0],
                10
            );


        const minutes =
            String(parts[1]).padStart(
                2,
                "0"
            );


        if (
            Number.isNaN(hours)
        ) {

            return value;

        }


        const period =
            hours >= 12
                ? "PM"
                : "AM";


        if (hours === 0) {

            hours = 12;

        } else if (hours > 12) {

            hours -= 12;

        }


        return (
            String(hours) +
            ":" +
            minutes +
            " " +
            period
        );

    }


    /*
     * =========================================================
     * DATE FORMATTER
     *
     * This fixes the missing formatDate() function in
     * the original file.
     * =========================================================
     */

    function formatDate(dateValue) {

        if (!dateValue) {

            return "Not selected";

        }


        const parts =
            dateValue.split("-");


        if (
            parts.length !== 3
        ) {

            return dateValue;

        }


        const year =
            parseInt(
                parts[0],
                10
            );


        const month =
            parseInt(
                parts[1],
                10
            );


        const day =
            parseInt(
                parts[2],
                10
            );


        if (
            Number.isNaN(year) ||
            Number.isNaN(month) ||
            Number.isNaN(day)
        ) {

            return dateValue;

        }


        const date =
            new Date(
                year,
                month - 1,
                day
            );


        return date.toLocaleDateString(
            "en-US",
            {
                weekday: "short",
                year: "numeric",
                month: "short",
                day: "numeric"
            }
        );

    }


    /*
     * =========================================================
     * FORM ERROR
     * =========================================================
     */

    function showFormError(message) {

        formValidationText.textContent =
            message;


        formValidationMessage.classList.add(
            "visible"
        );


        /*
         * Scroll the error into view.
         */

        formValidationMessage.scrollIntoView(
            {
                behavior: "smooth",
                block: "center"
            }
        );

    }


    /*
     * =========================================================
     * HIDE FORM ERROR
     * =========================================================
     */

    function hideFormError() {

        formValidationMessage.classList.remove(
            "visible"
        );

        formValidationText.textContent =
            "";

    }


    /*
     * =========================================================
     * FORM VALIDATION
     * =========================================================
     */

    bookingForm.addEventListener(
        "submit",
        function (event) {

            hideFormError();


            /*
             * Patient.
             */

            if (!patientId.value) {

                event.preventDefault();

                showFormError(
                    "Please select a patient before booking the appointment."
                );

                patientSearch.focus();

                return;

            }


            /*
             * Dentist.
             */

            if (!dentistId.value) {

                event.preventDefault();

                showFormError(
                    "Please select a dentist before booking the appointment."
                );

                dentistSearch.focus();

                return;

            }


            /*
             * Date.
             */

            if (!appointmentDate.value) {

                event.preventDefault();

                showFormError(
                    "Please select an appointment date."
                );

                appointmentDate.focus();

                return;

            }


            /*
             * Past date.
             */

            if (
                appointmentDate.value <
                todayString
            ) {

                event.preventDefault();

                showFormError(
                    "The appointment date cannot be in the past."
                );

                appointmentDate.focus();

                return;

            }


            /*
             * Availability.
             */

            if (
                !availabilityId.value ||
                !startTime.value ||
                !endTime.value
            ) {

                event.preventDefault();

                showFormError(
                    "Please select an available appointment time."
                );

                return;

            }


            /*
             * Reason.
             */

            if (!reasonSelect.value) {

                event.preventDefault();

                showFormError(
                    "Please select a reason for the appointment."
                );

                reasonSelect.focus();

                return;

            }


            /*
             * Other reason.
             */

            if (
                reasonSelect.value === "Other" &&
                !otherReason.value.trim()
            ) {

                event.preventDefault();

                showFormError(
                    "Please specify the reason for the appointment."
                );

                otherReason.focus();

                return;

            }


            /*
             * Trim the Other Reason value.
             */

            if (
                reasonSelect.value === "Other"
            ) {

                otherReason.value =
                    otherReason.value.trim();

            }


            /*
             * Prevent double submission.
             */

            bookButton.disabled =
                true;


            bookButton.classList.add(
                "loading"
            );


            bookButton.innerHTML =
                `
                    <i class="bi bi-arrow-repeat loading-icon"></i>

                    <span>
                        Booking Appointment...
                    </span>
                `;

        }
    );


    /*
     * =========================================================
     * CLICK OUTSIDE SEARCH DROPDOWNS
     * =========================================================
     */

    document.addEventListener(
        "click",
        function (event) {

            /*
             * Patient.
             */

            if (
                !patientSearchSelect.contains(
                    event.target
                )
            ) {

                closePatientDropdown();

            }


            /*
             * Dentist.
             */

            if (
                !dentistSearchSelect.contains(
                    event.target
                )
            ) {

                closeDentistDropdown();

            }

        }
    );


    /*
     * =========================================================
     * ESCAPE KEY
     * =========================================================
     */

    document.addEventListener(
        "keydown",
        function (event) {

            if (event.key !== "Escape") {
                return;
            }


            closePatientDropdown();

            closeDentistDropdown();

        }
    );


    /*
     * =========================================================
     * INITIAL REASON STATE
     * =========================================================
     */

    updateReason();


    /*
     * =========================================================
     * INITIAL AVAILABILITY STATE
     * =========================================================
     */

    setAvailabilityMessage(
        "info",
        "bi-info-circle",
        "Select a dentist and date to view available times."
    );


    /*
     * =========================================================
     * BASIC HTML ESCAPING FOR DYNAMIC JS CONTENT
     * =========================================================
     */

    function escapeHtml(value) {

        if (value === null || value === undefined) {

            return "";

        }


        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");

    }

});

</script>


</body>
</html>