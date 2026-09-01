<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Receptionist";
    }

    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Dentists | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .dentist-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 22px;
            margin-top: 25px;
        }

        .doctor-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            padding: 24px;
            border: 1px solid #edf3f5;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .doctor-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 36px rgba(6, 38, 50, 0.13);
            border-color: #0ea5b4;
        }

        .doctor-card-top {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .doctor-avatar-box {
            width: 54px;
            height: 54px;
            border-radius: 14px;
            background: #e6f7f9;
            color: #078c9b;
            font-size: 22px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .doctor-name-title h3 {
            font-size: 16px;
            font-weight: 700;
            color: #0c3d4f;
            margin: 0;
        }

        .doctor-name-title span {
            font-size: 11.5px;
            color: #0ea5b4;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .doctor-details-list {
            list-style: none;
            padding: 0;
            margin: 0 0 18px 0;
            border-top: 1px solid #f0f4f6;
            padding-top: 14px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            font-size: 12.5px;
            color: #557280;
        }

        .doctor-details-list li {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .doctor-details-list li i {
            color: #8da4ae;
            font-size: 14px;
            width: 16px;
        }

        .doctor-action-btn {
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            border: none;
            padding: 10px 16px;
            border-radius: 10px;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            box-sizing: border-box;
            box-shadow: 0 4px 12px rgba(8, 127, 140, 0.25);
            transition: opacity 0.2s;
        }

        .doctor-action-btn:hover {
            opacity: 0.95;
            color: #ffffff;
        }

        .search-input-wrap {
            position: relative;
            flex: 1;
            max-width: 450px;
        }

        .search-input-wrap i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 14px;
        }

        .search-input-wrap input {
            width: 100%;
            height: 42px;
            border: 1.5px solid #dce8ec;
            border-radius: 10px;
            padding: 0 14px 0 38px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            box-sizing: border-box;
        }

        .search-input-wrap input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
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

            <div class="nav-group open">
                <button type="button" class="nav-item nav-toggle" onclick="this.parentElement.classList.toggle('open')">
                    <span class="nav-item-left">
                        <i class="bi bi-person-badge"></i>
                        <span>Dentists</span>
                    </span>
                    <i class="bi bi-chevron-down nav-arrow"></i>
                </button>

                <div class="nav-submenu">
                    <a href="${pageContext.request.contextPath}/reception/dentists" class="nav-subitem active">
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
                    <h1>Dentist Specialists</h1>
                    <p>Clinical practitioners roster and assigned rooms</p>
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
                    <h2>Doctor Directory</h2>
                    <p>View clinic dentist profiles, specializations, and schedule availability.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/reception/dentist-availability" class="view-all-link" style="background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 10px; color: #ffffff;">
                        <i class="bi bi-calendar2-week"></i> Check Availability
                    </a>
                </div>
            </div>

            <!-- Toolbar Section -->
            <div style="display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 22px; flex-wrap: wrap;">
                <div class="search-input-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" id="dentistSearch" placeholder="Search doctor name or specialization...">
                </div>

                <span style="font-size: 13px; color: #d6f4f8; font-weight: 500;">
                    <%= dentists != null ? dentists.size() : 0 %> active dentist(s) on roster
                </span>
            </div>

            <!-- Dentist Grid -->
            <div class="dentist-cards-grid" id="dentistGrid">
                <% if (dentists != null && !dentists.isEmpty()) {
                    for (Dentist dentist : dentists) {
                        String initials = "DR";
                        if (dentist.getName() != null && !dentist.getName().isBlank()) {
                            String[] parts = dentist.getName().trim().split("\\s+");
                            if (parts.length >= 2) {
                                initials = (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
                            } else {
                                initials = dentist.getName().substring(0, Math.min(2, dentist.getName().length())).toUpperCase();
                            }
                        }
                %>
                    <article class="doctor-card" data-name="<%= dentist.getName().toLowerCase() %>" data-specialization="<%= (dentist.getSpecialization() != null ? dentist.getSpecialization() : "").toLowerCase() %>">
                        <div>
                            <div class="doctor-card-top">
                                <div class="doctor-avatar-box">
                                    <%= initials %>
                                </div>
                                <div class="doctor-name-title">
                                    <h3>Dr. <%= dentist.getName() %></h3>
                                    <span><%= dentist.getSpecialization() != null ? dentist.getSpecialization() : "Dental Surgeon" %></span>
                                </div>
                            </div>

                            <ul class="doctor-details-list">
                                <li>
                                    <i class="bi bi-person-badge"></i>
                                    <span>Dentist Number: <strong><%= dentist.getDentistNumber() %></strong></span>
                                </li>
                                <li>
                                    <i class="bi bi-telephone"></i>
                                    <span><%= dentist.getContactNumber() != null ? dentist.getContactNumber() : "No contact provided" %></span>
                                </li>
                                <li>
                                    <i class="bi bi-envelope"></i>
                                    <span><%= dentist.getEmail() != null ? dentist.getEmail() : "No email provided" %></span>
                                </li>
                            </ul>
                        </div>

                        <a href="${pageContext.request.contextPath}/reception/dentist-availability?dentistId=<%= dentist.getDentistId() %>" class="doctor-action-btn">
                            <i class="bi bi-calendar-check"></i> View Available Slots
                        </a>
                    </article>
                <%
                    }
                } else {
                %>
                    <div style="grid-column: 1 / -1; background: #ffffff; border-radius: 18px; text-align: center; padding: 50px 20px; color: #8da4ae;">
                        <i class="bi bi-person-x" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                        No active dentists currently registered in the clinic roster.
                    </div>
                <% } %>
            </div>

        </section>

    </main>

</div>

<script>
const searchInput = document.getElementById("dentistSearch");
const dentistCards = document.querySelectorAll(".doctor-card");

if (searchInput) {
    searchInput.addEventListener("input", function () {
        const searchValue = this.value.toLowerCase().trim();
        dentistCards.forEach(function (card) {
            const name = card.dataset.name || "";
            const spec = card.dataset.specialization || "";
            const matches = name.includes(searchValue) || spec.includes(searchValue);
            card.style.display = matches ? "flex" : "none";
        });
    });
}
</script>

</body>
</html>