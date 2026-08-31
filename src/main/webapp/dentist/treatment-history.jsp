<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="com.sunrise.dental.model.Dentist" %>
<%@ page import="com.sunrise.dental.model.Treatment" %>

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

    String dentistName = staffName;

    if (loggedInDentist != null
            && loggedInDentist.getName() != null
            && !loggedInDentist.getName().isBlank()) {

        dentistName =
                loggedInDentist.getName();
    }

    List<Treatment> treatmentHistory =
            (List<Treatment>) request.getAttribute(
                    "treatmentHistory"
            );

    if (treatmentHistory == null) {
        treatmentHistory =
                java.util.Collections.emptyList();
    }

    String errorMessage =
            (String) request.getAttribute(
                    "errorMessage"
            );

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd MMM yyyy");

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Treatment History | Sunrise Dental Clinic
    </title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Poppins", sans-serif;
            background: #f6fafc;
            color: #455a64;
        }

        .page-container {
            width: 100%;
            min-height: 100vh;
            padding: 35px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 28px;
        }

        .page-title h1 {
            margin: 0;
            font-size: 28px;
            color: #159bb1;
            font-weight: 600;
        }

        .page-title p {
            margin: 6px 0 0;
            color: #78909c;
            font-size: 14px;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 18px;
            border-radius: 10px;
            background: #ffffff;
            border: 1px solid #dcecef;
            color: #159bb1;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s ease;
        }

        .back-button:hover {
            background: #159bb1;
            color: #ffffff;
        }

        .dentist-card {
            display: flex;
            align-items: center;
            gap: 15px;
            background: #ffffff;
            border: 1px solid #e5f0f3;
            border-radius: 16px;
            padding: 18px 22px;
            margin-bottom: 24px;
        }

        .dentist-avatar {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            background: #eaf8fb;
            color: #159bb1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 600;
        }

        .dentist-info strong {
            display: block;
            color: #37474f;
            font-size: 15px;
        }

        .dentist-info span {
            display: block;
            margin-top: 3px;
            color: #90a4ae;
            font-size: 12px;
        }

        .history-card {
            background: #ffffff;
            border: 1px solid #e5f0f3;
            border-radius: 18px;
            overflow: hidden;
        }

        .card-header {
            padding: 23px 26px;
            border-bottom: 1px solid #edf3f5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-heading {
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .card-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: #eaf8fb;
            color: #159bb1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
        }

        .card-heading h2 {
            margin: 0;
            font-size: 18px;
            color: #37474f;
            font-weight: 600;
        }

        .card-heading span {
            display: block;
            margin-top: 3px;
            font-size: 12px;
            color: #90a4ae;
        }

        .record-count {
            font-size: 13px;
            color: #78909c;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .history-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        .history-table th {
            text-align: left;
            padding: 15px 20px;
            background: #f8fbfc;
            color: #607d8b;
            font-size: 12px;
            font-weight: 600;
            border-bottom: 1px solid #e8f0f2;
            white-space: nowrap;
        }

        .history-table td {
            padding: 17px 20px;
            border-bottom: 1px solid #edf3f5;
            vertical-align: top;
            font-size: 13px;
            color: #546e7a;
        }

        .history-table tbody tr:hover {
            background: #fbfdfe;
        }

        .patient-name {
            font-weight: 600;
            color: #37474f;
        }

        .patient-number {
            display: block;
            margin-top: 3px;
            font-size: 11px;
            color: #90a4ae;
        }

        .appointment-number {
            font-weight: 600;
            color: #159bb1;
        }

        .date-value {
            white-space: nowrap;
            color: #546e7a;
        }

        .diagnosis-text {
            color: #455a64;
            font-weight: 500;
        }

        .treatment-text {
            color: #546e7a;
        }

        .notes-text {
            max-width: 260px;
            line-height: 1.6;
            color: #78909c;
        }

        .next-date {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 9px;
            border-radius: 8px;
            background: #edfafd;
            color: #159bb1;
            font-size: 11px;
            white-space: nowrap;
        }

        .empty-state {
            padding: 70px 20px;
            text-align: center;
        }

        .empty-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 18px;
            border-radius: 20px;
            background: #f0f8fa;
            color: #8db6c0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
        }

        .empty-state strong {
            display: block;
            color: #455a64;
            font-size: 15px;
            margin-bottom: 7px;
        }

        .empty-state span {
            color: #90a4ae;
            font-size: 13px;
        }

        .error-message {
            margin-bottom: 20px;
            padding: 14px 17px;
            border-radius: 10px;
            background: #fff0f0;
            border: 1px solid #ffd5d5;
            color: #d33d3d;
            font-size: 13px;
        }

        @media (max-width: 768px) {

            .page-container {
                padding: 20px;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .page-title h1 {
                font-size: 23px;
            }

            .card-header {
                align-items: flex-start;
                gap: 10px;
                flex-direction: column;
            }

        }

    </style>

</head>


<body>

<div class="page-container">


    <!-- PAGE HEADER -->

    <div class="page-header">

        <div class="page-title">

            <h1>
                Treatment History
            </h1>

            <p>
                Review treatment records for your patients.
            </p>

        </div>


        <a
            href="${pageContext.request.contextPath}/dentist/dashboard"
            class="back-button"
        >

            <i class="bi bi-arrow-left"></i>

            Back to Dashboard

        </a>

    </div>


    <!-- DENTIST -->

    <div class="dentist-card">

        <div class="dentist-avatar">

            <i class="bi bi-person-badge"></i>

        </div>

        <div class="dentist-info">

            <strong>
                Dr. <%= dentistName %>
            </strong>

            <span>
                Dentist | Sunrise Dental Clinic
            </span>

        </div>

    </div>


    <!-- ERROR -->

    <% if (errorMessage != null
            && !errorMessage.isBlank()) { %>

        <div class="error-message">

            <i class="bi bi-exclamation-circle"></i>

            <%= errorMessage %>

        </div>

    <% } %>


    <!-- HISTORY CARD -->

    <div class="history-card">


        <div class="card-header">

            <div class="card-heading">

                <div class="card-icon">

                    <i class="bi bi-clock-history"></i>

                </div>

                <div>

                    <h2>
                        Treatment Records
                    </h2>

                    <span>
                        Previous clinical treatment information
                    </span>

                </div>

            </div>


            <div class="record-count">

                <%= treatmentHistory.size() %>
                record<%= treatmentHistory.size() == 1 ? "" : "s" %>

            </div>

        </div>


        <% if (treatmentHistory.isEmpty()) { %>


            <!-- EMPTY -->

            <div class="empty-state">

                <div class="empty-icon">

                    <i class="bi bi-journal-x"></i>

                </div>

                <strong>
                    No Treatment Records Found
                </strong>

                <span>
                    Treatment records for your patients will appear here.
                </span>

            </div>


        <% } else { %>


            <!-- TABLE -->

            <div class="table-wrapper">

                <table class="history-table">

                    <thead>

                    <tr>

                        <th>
                            Patient
                        </th>

                        <th>
                            Appointment
                        </th>

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

                        <th>
                            Next Appointment
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <%
                        for (Treatment treatment :
                                treatmentHistory) {

                            String patientName =
                                    treatment.getPatientName();

                            if (patientName == null
                                    || patientName.isBlank()) {

                                patientName =
                                        "Unknown Patient";
                            }

                            String patientNumber = "-";

                            String appointmentNumber =
                                    treatment.getAppointmentNumber();

                            if (appointmentNumber == null
                                    || appointmentNumber.isBlank()) {

                                appointmentNumber = "-";
                            }

                            String diagnosis =
                                    treatment.getDiagnosis();

                            if (diagnosis == null
                                    || diagnosis.isBlank()) {

                                diagnosis = "-";
                            }

                            String treatmentProvided =
                                    treatment.getTreatmentProvided();

                            if (treatmentProvided == null
                                    || treatmentProvided.isBlank()) {

                                treatmentProvided = "-";
                            }

                            String notes =
                                    treatment.getTreatmentNotes();

                            if (notes == null
                                    || notes.isBlank()) {

                                notes = "-";
                            }
                    %>


                        <tr>

                            <!-- PATIENT -->

                            <td>

                                <div class="patient-name">
                                    <%= patientName %>
                                </div>

                                <span class="patient-number">

                                    Patient ID:
                                    <%= treatment.getPatientId() %>

                                </span>

                            </td>


                            <!-- APPOINTMENT -->

                            <td>

                                <span class="appointment-number">

                                    <%= appointmentNumber %>

                                </span>

                            </td>


                            <!-- DATE -->

                            <td>

                                <span class="date-value">

                                    <%
                                        if (treatment.getCreatedAt()
                                                != null) {

                                    %>

                                        <%= dateTimeFormat.format(
                                                treatment.getCreatedAt()
                                        ) %>

                                    <%
                                        } else {
                                    %>

                                        -

                                    <%
                                        }
                                    %>

                                </span>

                            </td>


                            <!-- DIAGNOSIS -->

                            <td>

                                <span class="diagnosis-text">

                                    <%= diagnosis %>

                                </span>

                            </td>


                            <!-- TREATMENT -->

                            <td>

                                <span class="treatment-text">

                                    <%= treatmentProvided %>

                                </span>

                            </td>


                            <!-- NOTES -->

                            <td>

                                <div class="notes-text">

                                    <%= notes %>

                                </div>

                            </td>


                            <!-- NEXT APPOINTMENT -->

                            <td>

                                <%
                                    if (treatment.getNextAppointmentDate()
                                            != null) {
                                %>

                                    <span class="next-date">

                                        <i class="bi bi-calendar-check"></i>

                                        <%= dateFormat.format(
                                                treatment.getNextAppointmentDate()
                                        ) %>

                                    </span>

                                <%
                                    } else {
                                %>

                                    -

                                <%
                                    }
                                %>

                            </td>

                        </tr>


                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>


        <% } %>


    </div>


</div>

</body>

</html>