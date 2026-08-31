<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    String staffName = (String) session.getAttribute("staffName");

    if (staffName == null) {
        staffName = "Receptionist";
    }

    List<Patient> patients =
            (List<Patient>) request.getAttribute("patients");

    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");

    if (patients == null) {
        patients = java.util.Collections.emptyList();
    }

    if (dentists == null) {
        dentists = java.util.Collections.emptyList();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Book Appointment | Sunrise Dental Clinic</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/book-appointment.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="booking-page">

    <!-- ==========================================
         HEADER
         ========================================== -->

    <header class="booking-header">

        <div class="header-left">

            <a href="${pageContext.request.contextPath}/reception/receptionDashboard.jsp"
               class="back-button">

                <i class="bi bi-arrow-left"></i>

            </a>

            <div>

                <h1>Book Appointment</h1>

                <p>Schedule a new patient appointment</p>

            </div>

        </div>


        <div class="header-user">

            <div class="user-avatar">
                <i class="bi bi-person-fill"></i>
            </div>

            <div>

                <strong><%= staffName %></strong>

                <span>Receptionist</span>

            </div>

        </div>

    </header>


    <!-- ==========================================
         MAIN
         ========================================== -->

    <main class="booking-content">

        <!-- PAGE INTRO -->

        <section class="page-introduction">

            <div class="intro-icon">

                <i class="bi bi-calendar-plus"></i>

            </div>

            <div>

                <h2>Create New Appointment</h2>

                <p>
                    Select a patient, dentist, date and available
                    appointment time.
                </p>

            </div>

        </section>


       <!-- ==========================================
     SUCCESS MESSAGE
     ========================================== -->

<% if (request.getAttribute("success") != null) { %>

    <div class="message success-message">

        <i class="bi bi-check-circle-fill"></i>

        <div>

            <strong>
                Appointment Booked Successfully
            </strong>

            <p>
                <%= request.getAttribute("success") %>
            </p>

            <% if (request.getAttribute("appointmentNumber") != null) { %>

                <span class="appointment-number">

                    Appointment Number:

                    <strong>
                        <%= request.getAttribute("appointmentNumber") %>
                    </strong>

                </span>

            <% } %>

            <% if (request.getAttribute("emailMessage") != null) { %>

                <p class="email-status">

                    <i class="bi bi-envelope-check"></i>

                    <%= request.getAttribute("emailMessage") %>

                </p>

            <% } %>

        </div>

    </div>

<% } %>

       <!-- ==========================================
     ERROR MESSAGE
     ========================================== -->

<% if (request.getAttribute("error") != null) { %>

    <div class="message error-message">

        <i class="bi bi-exclamation-circle-fill"></i>

        <div>

            <strong>
                Unable to Book Appointment
            </strong>

            <p>
                <%= request.getAttribute("error") %>
            </p>

        </div>

    </div>

<% } %>


        <!-- ==========================================
             BOOKING FORM
             ========================================== -->

        <form
            action="${pageContext.request.contextPath}/reception/book-appointment"
            method="post"
            class="booking-form"
            id="bookingForm">


            <!-- ======================================
                 STEP 1 PATIENT
                 ====================================== -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">1</div>

                    <div>

                        <h3>Patient Information</h3>

                        <p>
                            Search and select the patient for this appointment.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label>
                        Patient
                        <span class="required">*</span>
                    </label>


                    <!-- SEARCHABLE PATIENT -->

                    <div class="search-select"
                         id="patientSearchSelect">

                        <div class="search-input-wrapper">

                            <i class="bi bi-search"></i>

                            <input
                                type="text"
                                id="patientSearch"
                                placeholder="Search by patient name, number, contact or email..."
                                autocomplete="off">

                            <i class="bi bi-chevron-down search-arrow"></i>

                        </div>


                        <div class="search-results"
                             id="patientResults">

                            <% for (Patient patient : patients) { %>

                                <div
                                    class="search-result patient-result"
                                    data-id="<%= patient.getPatientId() %>"
                                    data-name="<%= patient.getName() %>"
                                    data-number="<%= patient.getPatientNumber() %>"
                                    data-email="<%= patient.getEmail() != null ? patient.getEmail() : "" %>"
                                    data-contact="<%= patient.getContactNumber() != null ? patient.getContactNumber() : "" %>"
                                    data-search="<%= (
                                            patient.getPatientNumber()
                                            + " "
                                            + patient.getName()
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
                                            <%= patient.getPatientNumber() %>
                                            -
                                            <%= patient.getName() %>
                                        </strong>

                                        <span>
                                            <%= patient.getContactNumber() != null
                                                    ? patient.getContactNumber()
                                                    : "No contact number" %>

                                            <% if (patient.getEmail() != null
                                                    && !patient.getEmail().isBlank()) { %>

                                                &nbsp; • &nbsp;

                                                <%= patient.getEmail() %>

                                            <% } %>
                                        </span>

                                    </div>

                                </div>

                            <% } %>


                            <% if (patients.isEmpty()) { %>

                                <div class="no-results">
                                    <i class="bi bi-person-x"></i>
                                    <span>No active patients found.</span>
                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- REAL VALUE SUBMITTED TO SERVLET -->

                    <input
                        type="hidden"
                        id="patientId"
                        name="patientId"
                        value="">


                    <small>
                        Search by patient name, patient number,
                        contact number or email.
                    </small>

                </div>


                <!-- SELECTED PATIENT -->

                <div
                    class="selected-record"
                    id="selectedPatient">

                    <div class="selected-record-icon">
                        <i class="bi bi-person-check"></i>
                    </div>

                    <div class="selected-record-info">

                        <span>Selected Patient</span>

                        <strong id="selectedPatientName">
                            No patient selected
                        </strong>

                    </div>

                    <button
                        type="button"
                        class="clear-selection"
                        id="clearPatient">

                        <i class="bi bi-x"></i>

                    </button>

                </div>


                <!-- PATIENT PREVIEW -->

                <div
                    class="patient-preview"
                    id="patientPreview">

                    <div class="preview-item">

                        <i class="bi bi-envelope"></i>

                        <div>

                            <span>Email</span>

                            <strong id="patientEmail">
                                -
                            </strong>

                        </div>

                    </div>


                    <div class="preview-item">

                        <i class="bi bi-telephone"></i>

                        <div>

                            <span>Contact Number</span>

                            <strong id="patientContact">
                                -
                            </strong>

                        </div>

                    </div>

                </div>

            </section>


            <!-- ======================================
                 STEP 2 DENTIST
                 ====================================== -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">2</div>

                    <div>

                        <h3>Dentist</h3>

                        <p>
                            Search and select the dentist for the appointment.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label>
                        Dentist
                        <span class="required">*</span>
                    </label>


                    <!-- SEARCHABLE DENTIST -->

                    <div class="search-select"
                         id="dentistSearchSelect">

                        <div class="search-input-wrapper">

                            <i class="bi bi-search"></i>

                            <input
                                type="text"
                                id="dentistSearch"
                                placeholder="Search dentist by name, number or specialization..."
                                autocomplete="off">

                            <i class="bi bi-chevron-down search-arrow"></i>

                        </div>


                        <div class="search-results"
                             id="dentistResults">

                            <% for (Dentist dentist : dentists) { %>

                                <div
                                    class="search-result dentist-result"
                                    data-id="<%= dentist.getDentistId() %>"
                                    data-name="<%= dentist.getName() %>"
                                    data-number="<%= dentist.getDentistNumber() %>"
                                    data-specialization="<%= dentist.getSpecialization() != null
                                            ? dentist.getSpecialization()
                                            : "" %>"
                                    data-search="<%= (
                                            dentist.getDentistNumber()
                                            + " "
                                            + dentist.getName()
                                            + " "
                                            + (dentist.getSpecialization() != null
                                                ? dentist.getSpecialization()
                                                : "")
                                    ).toLowerCase() %>">

                                    <div class="result-icon dentist-result-icon">

                                        <i class="bi bi-person-badge"></i>

                                    </div>

                                    <div class="result-information">

                                        <strong>
                                            <%= dentist.getName() %>
                                        </strong>

                                        <span>

                                            <%= dentist.getDentistNumber() %>

                                            <% if (dentist.getSpecialization() != null
                                                    && !dentist.getSpecialization().isBlank()) { %>

                                                &nbsp; • &nbsp;

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


                    <!-- REAL VALUE SUBMITTED -->

                    <input
                        type="hidden"
                        id="dentistId"
                        name="dentistId"
                        value="">


                    <small>
                        Search by dentist name, dentist number
                        or specialization.
                    </small>

                </div>


                <!-- SELECTED DENTIST -->

                <div
                    class="selected-record"
                    id="selectedDentist">

                    <div class="selected-record-icon">

                        <i class="bi bi-person-check"></i>

                    </div>

                    <div class="selected-record-info">

                        <span>Selected Dentist</span>

                        <strong id="selectedDentistName">
                            No dentist selected
                        </strong>

                    </div>

                    <button
                        type="button"
                        class="clear-selection"
                        id="clearDentist">

                        <i class="bi bi-x"></i>

                    </button>

                </div>

            </section>


            <!-- ======================================
                 STEP 3 DATE
                 ====================================== -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">3</div>

                    <div>

                        <h3>Appointment Date</h3>

                        <p>
                            Select a date when the dentist is available.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label for="appointmentDate">

                        Date

                        <span class="required">*</span>

                    </label>

                    <div class="date-input-wrapper">

                        <i class="bi bi-calendar3"></i>

                        <input
                            type="date"
                            id="appointmentDate"
                            name="appointmentDate"
                            required>

                    </div>

                </div>

            </section>


            <!-- ======================================
                 STEP 4 AVAILABLE TIME
                 ====================================== -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">4</div>

                    <div>

                        <h3>Available Time</h3>

                        <p>
                            Select an available appointment period.
                        </p>

                    </div>

                </div>


                <div
                    class="availability-message"
                    id="availabilityMessage">

                    <i class="bi bi-info-circle"></i>

                    <span>
                        Select a dentist and date to view available times.
                    </span>

                </div>


                <div
                    class="time-slots"
                    id="timeSlots">
                </div>


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


            <!-- ======================================
                 STEP 5 REASON
                 ====================================== -->

            <section class="form-section">

                <div class="section-title">

                    <div class="step-number">5</div>

                    <div>

                        <h3>Appointment Details</h3>

                        <p>
                            Provide the reason for the visit.
                        </p>

                    </div>

                </div>


                <div class="form-group">

                    <label for="reason">

                        Reason for Visit

                        <span class="required">*</span>

                    </label>


                    <select
                        id="reason"
                        name="reason"
                        required>

                        <option value="">
                            Select reason
                        </option>

                        <option value="Consultation">
                            Consultation
                        </option>

                        <option value="Dental Cleaning">
                            Dental Cleaning
                        </option>

                        <option value="Scaling">
                            Scaling
                        </option>

                        <option value="Root Canal Treatment">
                            Root Canal Treatment
                        </option>

                        <option value="Tooth Extraction">
                            Tooth Extraction
                        </option>

                        <option value="Dental Filling">
                            Dental Filling
                        </option>

                        <option value="Follow-up">
                            Follow-up
                        </option>

                        <option value="Other">
                            Other
                        </option>

                    </select>

                </div>


                <div
                    class="form-group other-reason-group"
                    id="otherReasonGroup">

                    <label for="otherReason">
                        Specify Reason
                    </label>

                    <textarea
                        id="otherReason"
                        name="otherReason"
                        rows="3"
                        placeholder="Enter the reason for the appointment"></textarea>

                </div>

            </section>


            <!-- ======================================
                 SUMMARY
                 ====================================== -->

            <section class="booking-summary">

                <div class="summary-header">

                    <i class="bi bi-clipboard-check"></i>

                    <div>

                        <h3>Appointment Summary</h3>

                        <p>
                            Review the details before booking.
                        </p>

                    </div>

                </div>


                <div class="summary-grid">

                    <div class="summary-item">

                        <span>Patient</span>

                        <strong id="summaryPatient">
                            Not selected
                        </strong>

                    </div>


                    <div class="summary-item">

                        <span>Dentist</span>

                        <strong id="summaryDentist">
                            Not selected
                        </strong>

                    </div>


                    <div class="summary-item">

                        <span>Date</span>

                        <strong id="summaryDate">
                            Not selected
                        </strong>

                    </div>


                    <div class="summary-item">

                        <span>Time</span>

                        <strong id="summaryTime">
                            Not selected
                        </strong>

                    </div>

                </div>

            </section>


            <!-- ACTIONS -->

            <div class="form-actions">

                <a
				    href="${pageContext.request.contextPath}/reception/receptionDashboard.jsp"
				    class="cancel-button">

                    Cancel

                </a>


                <button
                    type="submit"
                    class="book-button"
                    id="bookButton">

                    <i class="bi bi-calendar-check"></i>

                    Book Appointment

                </button>

            </div>

        </form>

    </main>

</div>


<script>

/* =========================================================
   ELEMENTS
   ========================================================= */

const patientSearch =
    document.getElementById("patientSearch");

const patientId =
    document.getElementById("patientId");

const patientResults =
    document.getElementById("patientResults");

const patientSearchSelect =
    document.getElementById("patientSearchSelect");


const dentistSearch =
    document.getElementById("dentistSearch");

const dentistId =
    document.getElementById("dentistId");

const dentistResults =
    document.getElementById("dentistResults");

const dentistSearchSelect =
    document.getElementById("dentistSearchSelect");


const appointmentDate =
    document.getElementById("appointmentDate");

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

const bookingForm =
    document.getElementById("bookingForm");

const reasonSelect =
    document.getElementById("reason");

const otherReasonGroup =
    document.getElementById("otherReasonGroup");

const otherReason =
    document.getElementById("otherReason");


/* =========================================================
   MINIMUM DATE
   ========================================================= */

const today = new Date();

const year =
    today.getFullYear();

const month =
    String(today.getMonth() + 1)
        .padStart(2, "0");

const day =
    String(today.getDate())
        .padStart(2, "0");

appointmentDate.min =
    year + "-" + month + "-" + day;


/* =========================================================
   SEARCH PATIENTS
   ========================================================= */

patientSearch.addEventListener("focus", function () {

    patientSearchSelect.classList.add("active");

    filterPatients();

});


patientSearch.addEventListener("input", function () {

    patientSearchSelect.classList.add("active");

    filterPatients();

});


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

    results.forEach(function (result) {

        const searchText =
            result.dataset.search || "";

        if (
            keyword === "" ||
            searchText.includes(keyword)
        ) {

            result.style.display = "flex";

            visibleCount++;

        } else {

            result.style.display = "none";

        }

    });

    const noResults =
        patientResults.querySelector(
            ".dynamic-no-results"
        );

    if (noResults) {
        noResults.remove();
    }

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


/* =========================================================
   SELECT PATIENT
   ========================================================= */

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

        patientId.value =
            result.dataset.id;

        patientSearch.value =
            result.dataset.number
            + " - "
            + result.dataset.name;

        document.getElementById(
            "selectedPatientName"
        ).textContent =
            result.dataset.number
            + " - "
            + result.dataset.name;

        document.getElementById(
            "patientEmail"
        ).textContent =
            result.dataset.email || "-";

        document.getElementById(
            "patientContact"
        ).textContent =
            result.dataset.contact || "-";

        document.getElementById(
            "summaryPatient"
        ).textContent =
            result.dataset.number
            + " - "
            + result.dataset.name;

        document.getElementById(
            "selectedPatient"
        ).classList.add("visible");

        document.getElementById(
            "patientPreview"
        ).classList.add("visible");

        patientSearchSelect.classList.remove(
            "active"
        );

    }
);


/* =========================================================
   CLEAR PATIENT
   ========================================================= */

document.getElementById(
    "clearPatient"
).addEventListener(
    "click",
    function () {

        patientId.value = "";

        patientSearch.value = "";

        document.getElementById(
            "selectedPatientName"
        ).textContent =
            "No patient selected";

        document.getElementById(
            "patientEmail"
        ).textContent = "-";

        document.getElementById(
            "patientContact"
        ).textContent = "-";

        document.getElementById(
            "summaryPatient"
        ).textContent =
            "Not selected";

        document.getElementById(
            "selectedPatient"
        ).classList.remove("visible");

        document.getElementById(
            "patientPreview"
        ).classList.remove("visible");

    }
);


/* =========================================================
   SEARCH DENTISTS
   ========================================================= */

dentistSearch.addEventListener("focus", function () {

    dentistSearchSelect.classList.add("active");

    filterDentists();

});


dentistSearch.addEventListener("input", function () {

    dentistSearchSelect.classList.add("active");

    filterDentists();

});


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

    results.forEach(function (result) {

        const searchText =
            result.dataset.search || "";

        if (
            keyword === "" ||
            searchText.includes(keyword)
        ) {

            result.style.display = "flex";

            visibleCount++;

        } else {

            result.style.display = "none";

        }

    });

    const noResults =
        dentistResults.querySelector(
            ".dynamic-no-results"
        );

    if (noResults) {
        noResults.remove();
    }

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


/* =========================================================
   SELECT DENTIST
   ========================================================= */

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

        dentistId.value =
            result.dataset.id;

        dentistSearch.value =
            result.dataset.name;

        document.getElementById(
            "selectedDentistName"
        ).textContent =
            result.dataset.name
            + (
                result.dataset.specialization
                    ? " - "
                    + result.dataset.specialization
                    : ""
            );

        document.getElementById(
            "summaryDentist"
        ).textContent =
            result.dataset.name
            + (
                result.dataset.specialization
                    ? " - "
                    + result.dataset.specialization
                    : ""
            );

        document.getElementById(
            "selectedDentist"
        ).classList.add("visible");

        dentistSearchSelect.classList.remove(
            "active"
        );

        loadAvailability();

    }
);


/* =========================================================
   CLEAR DENTIST
   ========================================================= */

document.getElementById(
    "clearDentist"
).addEventListener(
    "click",
    function () {

        dentistId.value = "";

        dentistSearch.value = "";

        document.getElementById(
            "selectedDentistName"
        ).textContent =
            "No dentist selected";

        document.getElementById(
            "summaryDentist"
        ).textContent =
            "Not selected";

        document.getElementById(
            "selectedDentist"
        ).classList.remove("visible");

        clearAvailability();

    }
);


/* =========================================================
   DATE
   ========================================================= */

appointmentDate.addEventListener(
    "change",
    function () {

        document.getElementById(
            "summaryDate"
        ).textContent =
            appointmentDate.value
                ? formatDate(appointmentDate.value)
                : "Not selected";

        loadAvailability();

    }
);


/* =========================================================
LOAD AVAILABILITY
========================================================= */

function loadAvailability() {

 clearAvailability();

 /*
  * ==========================================
  * CHECK REQUIRED VALUES
  * ==========================================
  */

 if (
     !dentistId.value ||
     !appointmentDate.value
 ) {

     availabilityMessage.className =
         "availability-message";

     availabilityMessage.innerHTML = `
         <i class="bi bi-info-circle"></i>

         <span>
             Select a dentist and date to view available times.
         </span>
     `;

     return;
 }

 /*
  * ==========================================
  * SHOW LOADING
  * ==========================================
  */

 availabilityMessage.className =
     "availability-message loading";

 availabilityMessage.innerHTML = `
     <i class="bi bi-arrow-repeat loading-icon"></i>

     <span>
         Checking dentist availability...
     </span>
 `;

 /*
  * ==========================================
  * CONTEXT PATH
  * ==========================================
  */

 const contextPath =
     "${pageContext.request.contextPath}";

 /*
  * ==========================================
  * URL
  * ==========================================
  */

 const url =
     contextPath
     + "/reception/dentist-availability"
     + "?dentistId="
     + encodeURIComponent(
         dentistId.value
     )
     + "&date="
     + encodeURIComponent(
         appointmentDate.value
     )
     + "&ajax=true";

 console.log(
     "Loading dentist availability:",
     url
 );

 /*
  * ==========================================
  * FETCH JSON
  * ==========================================
  */

 fetch(url, {
     method: "GET",
     headers: {
         "Accept": "application/json"
     }
 })

 .then(function(response) {

     console.log(
         "Availability response:",
         response.status
     );

     if (!response.ok) {

         throw new Error(
             "Server returned HTTP "
             + response.status
         );
     }

     return response.json();
 })

 .then(function(data) {

     console.log(
         "Availability JSON:",
         data
     );

     displayTimeSlots(data);
 })

 .catch(function(error) {

     console.error(
         "Availability loading error:",
         error
     );

     availabilityMessage.className =
         "availability-message error";

     availabilityMessage.innerHTML = `
         <i class="bi bi-exclamation-circle"></i>

         <span>
             Unable to load available times.
             Please try again.
         </span>
     `;
 });
}


/* =========================================================
CLEAR AVAILABILITY
========================================================= */

function clearAvailability() {

 timeSlots.innerHTML = "";

 availabilityId.value = "";

 startTime.value = "";

 endTime.value = "";

 document.getElementById(
     "summaryTime"
 ).textContent =
     "Not selected";
}


/* =========================================================
DISPLAY TIME SLOTS
========================================================= */

function displayTimeSlots(data) {

 timeSlots.innerHTML = "";

 /*
  * ==========================================
  * NO AVAILABILITY
  * ==========================================
  */

 if (
     !Array.isArray(data) ||
     data.length === 0
 ) {

     availabilityMessage.className =
         "availability-message warning";

     availabilityMessage.innerHTML = `
         <i class="bi bi-calendar-x"></i>

         <span>
             No availability found for this dentist
             on the selected date.
         </span>
     `;

     return;
 }

 /*
  * ==========================================
  * AVAILABLE
  * ==========================================
  */

 availabilityMessage.className =
     "availability-message available";

 availabilityMessage.innerHTML = `
     <i class="bi bi-check-circle"></i>

     <span>
         Available dentist time periods
     </span>
 `;

 /*
  * ==========================================
  * CREATE TIME BUTTONS
  * ==========================================
  */

 data.forEach(function(item) {

     const button =
         document.createElement(
             "button"
         );

     button.type =
         "button";

     button.className =
         "time-slot";

     /*
      * Convert the database time.
      *
      * Example:
      * 09:00:00
      * 12:00:00
      */

     const start =
         formatTime(
             item.startTime
         );

     const end =
         formatTime(
             item.endTime
         );

     console.log(
         "Time slot:",
         item.startTime,
         item.endTime,
         "=>",
         start,
         end
     );

     /*
      * ======================================
      * BUTTON CONTENT
      * ======================================
      */

     button.innerHTML = `
         <i class="bi bi-clock"></i>

         <span>
             ${start} - ${end}
         </span>
     `;

     /*
      * ======================================
      * STORE VALUES
      * ======================================
      */

     button.dataset.availabilityId =
         item.availabilityId;

     button.dataset.startTime =
         item.startTime;

     button.dataset.endTime =
         item.endTime;

     /*
      * ======================================
      * CLICK
      * ======================================
      */

     button.addEventListener(
         "click",
         function() {

             document
                 .querySelectorAll(
                     ".time-slot"
                 )
                 .forEach(
                     function(slot) {

                         slot.classList.remove(
                             "selected"
                         );
                     }
                 );

             button.classList.add(
                 "selected"
             );

             availabilityId.value =
                 button.dataset.availabilityId;

             startTime.value =
                 button.dataset.startTime;

             endTime.value =
                 button.dataset.endTime;

             document.getElementById(
                 "summaryTime"
             ).textContent =
                 start + " - " + end;

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
     );

     timeSlots.appendChild(
         button
     );
 });
}


/* =========================================================
TIME FORMATTER
========================================================= */

function formatTime(timeValue) {

 if (!timeValue) {
     return "";
 }

 /*
  * Convert anything such as:
  *
  * 09:00:00
  * 09:00
  *
  * into:
  *
  * 9:00 AM
  */

 const value =
     String(timeValue).trim();

 const parts =
     value.split(":");

 if (parts.length < 2) {

     return value;
 }

 let hours =
     parseInt(
         parts[0],
         10
     );

 const minutes =
     parts[1];

 if (Number.isNaN(hours)) {

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
     String(hours)
     + ":"
     + minutes
     + " "
     + period
 );
}


</script>

</body>
</html>