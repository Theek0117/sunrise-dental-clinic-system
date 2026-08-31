<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.Patient" %>

<%
    String staffName =
            (String) session.getAttribute("staffName");

    if (staffName == null) {
        staffName = "Receptionist";
    }

    List<Patient> patients =
            (List<Patient>) request.getAttribute("patients");

    Patient editPatient =
            (Patient) request.getAttribute("editPatient");

    String success =
            request.getParameter("success");

    String error =
            (String) request.getAttribute("error");

    String search =
            request.getParameter("search");

    if (search == null) {
        search = "";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Manage Patients | Sunrise Dental Clinic</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manage-patients.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="manage-page">

    <header class="page-header">

        <div class="header-left">

            <a href="${pageContext.request.contextPath}/reception/dashboard"
               class="back-button">

                <i class="bi bi-arrow-left"></i>

            </a>

            <div>

                <h1>Manage Patients</h1>

                <p>
                    Search, view and update registered patients.
                </p>

            </div>

        </div>


        <a href="${pageContext.request.contextPath}/reception/register-patient"
           class="add-patient-button">

            <i class="bi bi-person-plus"></i>

            Register Patient

        </a>

    </header>


    <% if ("updated".equals(success)) { %>

        <div class="alert success-alert">

            <i class="bi bi-check-circle-fill"></i>

            Patient details updated successfully.

        </div>

    <% } %>


    <% if (error != null) { %>

        <div class="alert error-alert">

            <i class="bi bi-exclamation-circle-fill"></i>

            <%= error %>

        </div>

    <% } %>


    <section class="search-card">

        <form
                action="${pageContext.request.contextPath}/reception/manage-patients"
                method="get"
                class="search-form">

            <div class="search-input-wrapper">

                <i class="bi bi-search"></i>

                <input
                        type="search"
                        name="search"
                        value="<%= search %>"
                        placeholder="Search by patient number, name, contact or email..."
                        autocomplete="off">

            </div>

            <button type="submit"
                    class="search-button">

                Search

            </button>

            <% if (!search.isBlank()) { %>

                <a href="${pageContext.request.contextPath}/reception/manage-patients"
                   class="clear-button">

                    Clear

                </a>

            <% } %>

        </form>

    </section>


    <section class="patients-card">

        <div class="card-header">

            <div>

                <h2>Patient List</h2>

                <p>
                    <%= patients != null ? patients.size() : 0 %>
                    patient(s) found
                </p>

            </div>

        </div>


        <div class="table-wrapper">

            <table class="patients-table">

                <thead>

                <tr>

                    <th>Patient Number</th>

                    <th>Patient</th>

                    <th>Contact</th>

                    <th>Email</th>

                    <th>Status</th>

                    <th>Action</th>

                </tr>

                </thead>


                <tbody>

                <% if (patients != null
                        && !patients.isEmpty()) { %>

                    <% for (Patient patient : patients) { %>

                        <tr>

                            <td>

                                <span class="patient-number">
                                    <%= patient.getPatientNumber() %>
                                </span>

                            </td>


                            <td>

                                <div class="patient-name">

                                    <div class="patient-avatar">

                                        <%= patient.getName()
                                                .substring(0, 1)
                                                .toUpperCase() %>

                                    </div>

                                    <div>

                                        <strong>
                                            <%= patient.getName() %>
                                        </strong>

                                        <small>
                                            Patient ID:
                                            <%= patient.getPatientId() %>
                                        </small>

                                    </div>

                                </div>

                            </td>


                            <td>

                                <%= patient.getContactNumber() %>

                            </td>


                            <td>

                                <%= patient.getEmail() != null
                                        ? patient.getEmail()
                                        : "Not provided" %>

                            </td>


                            <td>

                                <span class="status-badge">

                                    <%= patient.getStatus() %>

                                </span>

                            </td>


                            <td>

                                <a
                                    href="${pageContext.request.contextPath}/reception/manage-patients?edit=<%= patient.getPatientId() %>"
                                    class="edit-button">

                                    <i class="bi bi-pencil-square"></i>

                                    Edit

                                </a>

                            </td>

                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>

                        <td colspan="6"
                            class="empty-state">

                            <i class="bi bi-person-x"></i>

                            <strong>
                                No patients found
                            </strong>

                            <span>
                                Try another search or register a new patient.
                            </span>

                        </td>

                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>


    <% if (editPatient != null) { %>

        <section class="edit-card">

            <div class="edit-header">

                <div>

                    <span class="edit-label">
                        Editing Patient
                    </span>

                    <h2>
                        <%= editPatient.getName() %>
                    </h2>

                    <p>
                        <%= editPatient.getPatientNumber() %>
                    </p>

                </div>

                <a href="${pageContext.request.contextPath}/reception/manage-patients"
                   class="close-edit">

                    <i class="bi bi-x-lg"></i>

                </a>

            </div>


            <form
                    action="${pageContext.request.contextPath}/reception/manage-patients"
                    method="post"
                    class="edit-form">

                <input
                        type="hidden"
                        name="action"
                        value="update">

                <input
                        type="hidden"
                        name="patientId"
                        value="<%= editPatient.getPatientId() %>">


                <div class="form-grid">

                    <div class="form-group">

                        <label>
                            Patient Number
                        </label>

                        <input
                                type="text"
                                value="<%= editPatient.getPatientNumber() %>"
                                disabled>

                        <small>
                            Patient number cannot be changed.
                        </small>

                    </div>


                    <div class="form-group">

                        <label>
                            Patient Name
                        </label>

                        <input
                                type="text"
                                name="name"
                                value="<%= editPatient.getName() %>"
                                maxlength="100"
                                required>

                    </div>


                    <div class="form-group full-width">

                        <label>
                            Address
                        </label>

                        <textarea
                                name="address"
                                rows="3"
                                maxlength="255"
                                required><%= editPatient.getAddress() %></textarea>

                    </div>


                    <div class="form-group">

                        <label>
                            Contact Number
                        </label>

                        <input
                                type="text"
                                name="contactNumber"
                                value="<%= editPatient.getContactNumber() %>"
                                maxlength="20"
                                required>

                    </div>


                    <div class="form-group">

                        <label>
                            Email Address
                        </label>

                        <input
                                type="email"
                                name="email"
                                value="<%= editPatient.getEmail() != null
                                        ? editPatient.getEmail()
                                        : "" %>"
                                maxlength="100">

                        <small>
                            This email must not belong to another patient.
                        </small>

                    </div>


                    <div class="form-group">

                        <label>
                            Status
                        </label>

                        <select name="status">

                            <option value="ACTIVE"
                                <%= "ACTIVE".equalsIgnoreCase(
                                        editPatient.getStatus())
                                        ? "selected"
                                        : "" %>>
                                Active
                            </option>

                            <option value="INACTIVE"
                                <%= "INACTIVE".equalsIgnoreCase(
                                        editPatient.getStatus())
                                        ? "selected"
                                        : "" %>>
                                Inactive
                            </option>

                        </select>

                    </div>

                </div>


                <div class="form-actions">

                    <a href="${pageContext.request.contextPath}/reception/manage-patients"
                       class="cancel-button">

                        Cancel

                    </a>

                    <button type="submit"
                            class="save-button">

                        <i class="bi bi-check-lg"></i>

                        Save Changes

                    </button>

                </div>

            </form>

        </section>

    <% } %>

</div>

</body>

</html>