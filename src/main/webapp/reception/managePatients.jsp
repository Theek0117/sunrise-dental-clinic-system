<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.Patient" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Patient editPatient = (Patient) request.getAttribute("editPatient");

    String success = request.getParameter("success");
    String error = (String) request.getAttribute("error");
    String search = request.getParameter("search");
    if (search == null) {
        search = "";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Patients | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .filter-toolbar-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 22px;
            flex-wrap: wrap;
        }

        .search-form-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
            max-width: 520px;
        }

        .search-input-field {
            position: relative;
            flex: 1;
        }

        .search-input-field i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 15px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .search-input-field input {
            width: 100%;
            height: 44px;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            padding: 0 16px 0 42px;
            font-size: 13.5px;
            color: #123847;
            background: #ffffff;
            outline: none;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .search-input-field input:hover {
            border-color: #a4cddc;
        }

        .search-input-field input:focus {
            border-color: #0ea5b4 !important;
            background: #ffffff !important;
            box-shadow: 0 0 0 3.5px rgba(14, 165, 180, 0.14) !important;
        }

        .search-input-field:focus-within i {
            color: #0ea5b4;
        }

        .search-btn {
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            border: none;
            padding: 0 22px;
            height: 44px;
            border-radius: 11px;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(8, 127, 140, 0.25);
            transition: all 0.2s ease;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(8, 127, 140, 0.35);
        }

        .clear-btn {
            color: #d9534f;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            padding: 0 6px;
        }

        .action-link-btn {
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            background: #eaf5ff;
            color: #2774b8;
            border: 1px solid #c9e4ff;
        }

        .action-link-btn:hover {
            background: #d8edff;
            transform: translateY(-1px);
        }

        .alert-box {
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }
        .alert-box.success { background: #e8f8f0; color: #0d8248; border: 1px solid #c2eed5; }
        .alert-box.error { background: #feecee; color: #c92a2a; border: 1px solid #f9c6cb; }

        /* Edit Form Card */
        .edit-patient-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(6, 38, 50, 0.09);
            padding: 30px 34px;
            margin-bottom: 30px;
            border: 1px solid #edf3f5;
        }

        .edit-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
            border-bottom: 1px solid #f0f4f6;
            padding-bottom: 16px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }
        .form-group.full-width { grid-column: 1 / -1; }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #2c4a57;
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            height: 44px;
            border: 1.5px solid #d2e4ea;
            border-radius: 11px;
            padding: 0 16px;
            font-size: 13.5px;
            color: #123847;
            background: #ffffff;
            outline: none;
            font-family: inherit;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .form-group textarea {
            height: auto !important;
            min-height: 90px;
            padding: 12px 16px;
        }

        .form-group input:hover, .form-group textarea:hover, .form-group select:hover {
            border-color: #a4cddc;
        }

        .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
            border-color: #0ea5b4 !important;
            background: #ffffff !important;
            box-shadow: 0 0 0 3.5px rgba(14, 165, 180, 0.14) !important;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 20px;
        }

        .save-btn {
            padding: 10px 22px;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(8, 127, 140, 0.25);
        }

        .cancel-btn {
            padding: 10px 18px;
            border-radius: 10px;
            border: 1px solid #dce8ec;
            background: #ffffff;
            color: #557280;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- ========================================= -->
    <!-- SIDEBAR -->
    <!-- ========================================= -->
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

            <div class="nav-dropdown">
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
                    <a href="${pageContext.request.contextPath}/reception/view-appointments" class="nav-subitem">
                        <i class="bi bi-calendar3"></i>
                        <span>View Appointments</span>
                    </a>
                </div>
            </div>

            <div class="nav-group open">
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
                    <a href="${pageContext.request.contextPath}/reception/manage-patients" class="nav-subitem active">
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

    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <a href="${pageContext.request.contextPath}/reception/dashboard" class="menu-button">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h1>Manage Patients</h1>
                    <p>Search, review, and update registered patient profiles</p>
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
                    <h2>Patient Directory</h2>
                    <p>Comprehensive patient records with contact details and registration numbers.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/reception/register-patient" class="view-all-link" style="background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 10px; color: #ffffff;">
                        <i class="bi bi-person-plus"></i> Register Patient
                    </a>
                </div>
            </div>

            <!-- Notifications -->
            <% if ("updated".equals(success)) { %>
                <div class="alert-box success">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>Patient details updated successfully.</span>
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="alert-box error">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span><%= error %></span>
                </div>
            <% } %>

            <!-- EDIT PATIENT SECTION (IF ACTIVE) -->
            <% if (editPatient != null) { %>
                <section class="edit-patient-card">
                    <div class="edit-header">
                        <div>
                            <span style="font-size: 11px; font-weight: 700; color: #0ea5b4; text-transform: uppercase; letter-spacing: 0.5px;">Editing Record</span>
                            <h2 style="font-size: 20px; font-weight: 700; color: #0c3d4f; margin: 2px 0 0;"><%= editPatient.getName() %> (<%= editPatient.getPatientNumber() %>)</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/reception/manage-patients" style="color: #8da4ae; font-size: 18px;">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </div>

                    <form action="${pageContext.request.contextPath}/reception/manage-patients" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="patientId" value="<%= editPatient.getPatientId() %>">

                        <div class="form-grid">
                            <div class="form-group">
                                <label>Patient Number</label>
                                <input type="text" value="<%= editPatient.getPatientNumber() %>" disabled style="background: #f1f6f8;">
                            </div>

                            <div class="form-group">
                                <label>Full Name <span style="color: #d9534f;">*</span></label>
                                <input type="text" name="name" value="<%= editPatient.getName() %>" required>
                            </div>

                            <div class="form-group full-width">
                                <label>Address <span style="color: #d9534f;">*</span></label>
                                <textarea name="address" rows="2" required><%= editPatient.getAddress() %></textarea>
                            </div>

                            <div class="form-group">
                                <label>Contact Number <span style="color: #d9534f;">*</span></label>
                                <input type="text" name="contactNumber" value="<%= editPatient.getContactNumber() %>" required>
                            </div>

                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="email" value="<%= editPatient.getEmail() != null ? editPatient.getEmail() : "" %>">
                            </div>

                            <div class="form-group">
                                <label>Status</label>
                                <select name="status">
                                    <option value="ACTIVE" <%= "ACTIVE".equalsIgnoreCase(editPatient.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(editPatient.getStatus()) ? "selected" : "" %>>Inactive</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/reception/manage-patients" class="cancel-btn">Cancel</a>
                            <button type="submit" class="save-btn"><i class="bi bi-check-lg"></i> Save Changes</button>
                        </div>
                    </form>
                </section>
            <% } %>

            <!-- PATIENTS TABLE SECTION -->
            <section class="appointments-section">

                <div class="filter-toolbar-row">
                    <form action="${pageContext.request.contextPath}/reception/manage-patients" method="get" class="search-form-wrap">
                        <div class="search-input-field">
                            <i class="bi bi-search"></i>
                            <input type="search" name="search" value="<%= search %>" placeholder="Search by patient number, name, contact or email..." autocomplete="off">
                        </div>
                        <button type="submit" class="search-btn">Search</button>
                        <% if (!search.isBlank()) { %>
                            <a href="${pageContext.request.contextPath}/reception/manage-patients" class="clear-btn">Clear</a>
                        <% } %>
                    </form>

                    <span style="font-size: 13px; color: #7a94a2; font-weight: 500;">
                        <%= patients != null ? patients.size() : 0 %> patient record(s) found
                    </span>
                </div>

                <div class="table-container">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th>Patient Number</th>
                                <th>Patient Name</th>
                                <th>Contact Number</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (patients != null && !patients.isEmpty()) {
                                for (Patient patient : patients) {
                                    String status = patient.getStatus() != null ? patient.getStatus() : "ACTIVE";
                                    String statusClass = "ACTIVE".equalsIgnoreCase(status) ? "status-confirmed" : "status-cancelled";
                        %>
                            <tr>
                                <td>
                                    <strong style="color: #0c3d4f;"><%= patient.getPatientNumber() %></strong>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="patient-avatar">
                                            <%= patient.getName().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <div>
                                            <strong><%= patient.getName() %></strong>
                                            <span>ID: #<%= patient.getPatientId() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span style="color: #1a3b47; font-weight: 500;"><%= patient.getContactNumber() %></span>
                                </td>
                                <td>
                                    <span style="color: #557280; font-size: 12.5px;"><%= patient.getEmail() != null && !patient.getEmail().isBlank() ? patient.getEmail() : "Not provided" %></span>
                                </td>
                                <td>
                                    <span class="status <%= statusClass %>"><%= status %></span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/reception/manage-patients?edit=<%= patient.getPatientId() %>" class="action-link-btn">
                                        <i class="bi bi-pencil-square"></i> Edit
                                    </a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-person-x" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    No patients found matching your query.
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