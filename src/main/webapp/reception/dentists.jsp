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
            grid-template-columns: repeat(auto-fill, minmax(330px, 1fr));
            gap: 22px;
            margin-top: 15px;
        }

        .doctor-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(6, 38, 50, 0.08);
            padding: 24px;
            border: 1px solid #edf3f5;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .doctor-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 40px rgba(6, 38, 50, 0.14);
            border-color: #0ea5b4;
        }

        .doctor-card-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .avatar-info-group {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .doctor-avatar-wrapper {
            position: relative;
            width: 60px !important;
            height: 60px !important;
            min-width: 60px !important;
            min-height: 60px !important;
            max-width: 60px !important;
            max-height: 60px !important;
            border-radius: 16px;
            overflow: hidden !important;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(14, 165, 180, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .doctor-avatar-wrapper img {
            width: 60px !important;
            height: 60px !important;
            min-width: 60px !important;
            min-height: 60px !important;
            max-width: 60px !important;
            max-height: 60px !important;
            object-fit: cover !important;
            display: block !important;
            border-radius: 16px;
        }

        .doctor-avatar-fallback {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            color: #0e7490;
            background: linear-gradient(135deg, #e0f2fe, #cffafe);
        }

        .active-status-dot {
            position: absolute;
            bottom: -1px;
            right: -1px;
            width: 14px;
            height: 14px;
            background: #22c55e;
            border: 2.5px solid #ffffff;
            border-radius: 50%;
        }

        .doc-header-badges {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 6px;
        }

        .badge-doc-id {
            background: #f1f5f9;
            color: #475569;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            letter-spacing: 0.5px;
        }

        .badge-available {
            background: #ecfdf5;
            color: #16a34a;
            font-size: 11px;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .badge-available::before {
            content: '';
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #22c55e;
        }

        .doctor-name-title {
            margin-bottom: 12px;
        }

        .doctor-name-title h3 {
            font-size: 16.5px;
            font-weight: 700;
            color: #0f2e3d;
            margin: 0 0 5px 0;
            line-height: 1.3;
        }

        .doc-spec-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #f0fdfa;
            color: #0d9488;
            border: 1px solid #ccfbf1;
            font-size: 11.5px;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .doctor-info-list {
            list-style: none;
            padding: 12px 0 0 0;
            margin: 0 0 16px 0;
            border-top: 1px dashed #e2e8f0;
            display: flex;
            flex-direction: column;
            gap: 9px;
        }

        .doctor-info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 12.5px;
            color: #475569;
        }

        .doctor-info-item i {
            color: #0ea5b4;
            font-size: 14px;
            width: 16px;
            flex-shrink: 0;
        }

        .doctor-info-item a {
            color: #475569;
            text-decoration: none;
            transition: color 0.2s;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .doctor-info-item a:hover {
            color: #0ea5b4;
            text-decoration: underline;
        }

        .card-actions-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 8px;
        }

        .btn-view-slots {
            background: #0ea5b4;
            color: #ffffff;
            border: none;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            width: 100%;
            box-sizing: border-box;
            box-shadow: 0 3px 10px rgba(14, 165, 180, 0.25);
            transition: all 0.2s ease;
        }

        .btn-view-slots:hover {
            background: #0c8c99;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .search-input-wrap {
            position: relative;
            flex: 1;
            min-width: 320px;
            max-width: 480px;
        }

        .search-input-wrap i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 15px;
        }

        .search-input-wrap input {
            width: 100%;
            height: 44px;
            border: 1.5px solid rgba(255, 255, 255, 0.35);
            border-radius: 12px;
            padding: 0 16px 0 42px;
            font-size: 13px;
            color: #0f2e3d;
            background: rgba(255, 255, 255, 0.95);
            outline: none;
            box-sizing: border-box;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
        }

        .search-input-wrap input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(14, 165, 180, 0.2);
        }

        @media (max-width: 768px) {
            .dentist-cards-grid {
                grid-template-columns: 1fr;
            }
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
                    <p>View clinic dentist profiles, specializations, and schedule availability.</p>
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

            <!-- Toolbar Section -->
            <div style="display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 22px; flex-wrap: wrap;">
                <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap; flex: 1;">
                    <div class="search-input-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" id="dentistSearch" placeholder="Search doctor name or specialization...">
                    </div>
                    <a href="${pageContext.request.contextPath}/reception/dentist-availability" class="view-all-link" style="background: rgba(14, 165, 180, 0.22); border: 1px solid rgba(14, 165, 180, 0.45); padding: 11px 18px; border-radius: 12px; color: #ffffff; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; text-decoration: none;">
                        <i class="bi bi-calendar2-week"></i> Check Availability
                    </a>
                </div>

                <span style="font-size: 12.5px; color: #ffffff; background: rgba(14, 165, 180, 0.3); border: 1px solid rgba(14, 165, 180, 0.45); padding: 6px 14px; border-radius: 20px; font-weight: 600;">
                    <i class="bi bi-person-check-fill" style="color:#67e8f9;"></i> <%= dentists != null ? dentists.size() : 0 %> Active Dentists
                </span>
            </div>

            <!-- Dentist Grid -->
            <div class="dentist-cards-grid" id="dentistGrid">
                <% 
                String[] docPhotos = {
                    "https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80",
                    "https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80",
                    "https://images.unsplash.com/photo-1594824813590-389602e1c981?w=400&auto=format&fit=crop&q=80",
                    "https://images.unsplash.com/photo-1622902046580-2b47f47f5471?w=400&auto=format&fit=crop&q=80"
                };
                int photoIdx = 0;

                if (dentists != null && !dentists.isEmpty()) {
                    for (Dentist dentist : dentists) {
                        String rawName = dentist.getName() != null ? dentist.getName().trim() : "Specialist";
                        String cleanName = rawName.replaceAll("^(?i)dr\\.?\\s*", "").trim();
                        String displayName = "Dr. " + cleanName;

                        String initials = "DR";
                        String[] parts = cleanName.split("\\s+");
                        if (parts.length >= 2) {
                            initials = (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
                        } else if (!cleanName.isEmpty()) {
                            initials = cleanName.substring(0, Math.min(2, cleanName.length())).toUpperCase();
                        }

                        String photoUrl = docPhotos[photoIdx % docPhotos.length];
                        photoIdx++;

                        String spec = dentist.getSpecialization() != null && !dentist.getSpecialization().isBlank() 
                                ? dentist.getSpecialization() : "General Dentistry";
                        String room = dentist.getRoomNumber() != null && !dentist.getRoomNumber().isBlank()
                                ? dentist.getRoomNumber() : "Room 101";
                %>
                    <article class="doctor-card" data-name="<%= cleanName.toLowerCase() %>" data-specialization="<%= spec.toLowerCase() %>">
                        <div>
                            <div class="doctor-card-top">
                                <div class="avatar-info-group">
                                    <div class="doctor-avatar-wrapper">
                                        <img src="<%= photoUrl %>" alt="<%= displayName %>" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="doctor-avatar-fallback" style="display:none;"><%= initials %></div>
                                        <span class="active-status-dot"></span>
                                    </div>
                                    <div>
                                        <span class="badge-doc-id">#<%= dentist.getDentistNumber() %></span>
                                    </div>
                                </div>
                                <div class="doc-header-badges">
                                    <span class="badge-available">Available</span>
                                </div>
                            </div>

                            <div class="doctor-name-title">
                                <h3><%= displayName %></h3>
                                <span class="doc-spec-pill"><i class="bi bi-patch-check-fill"></i> <%= spec %></span>
                            </div>

                            <ul class="doctor-info-list">
                                <li class="doctor-info-item">
                                    <i class="bi bi-geo-alt-fill"></i>
                                    <span>Assigned: <strong><%= room %></strong></span>
                                </li>
                                <li class="doctor-info-item">
                                    <i class="bi bi-telephone-fill"></i>
                                    <% if (dentist.getContactNumber() != null && !dentist.getContactNumber().isBlank()) { %>
                                        <a href="tel:<%= dentist.getContactNumber() %>"><%= dentist.getContactNumber() %></a>
                                    <% } else { %>
                                        <span style="color:#94a3b8;">No contact on file</span>
                                    <% } %>
                                </li>
                                <li class="doctor-info-item">
                                    <i class="bi bi-envelope-fill"></i>
                                    <% if (dentist.getEmail() != null && !dentist.getEmail().isBlank()) { %>
                                        <a href="mailto:<%= dentist.getEmail() %>" title="<%= dentist.getEmail() %>"><%= dentist.getEmail() %></a>
                                    <% } else { %>
                                        <span style="color:#94a3b8;">No email on file</span>
                                    <% } %>
                                </li>
                            </ul>
                        </div>

                        <div class="card-actions-row">
                            <a href="${pageContext.request.contextPath}/reception/dentist-availability?dentistId=<%= dentist.getDentistId() %>" class="btn-view-slots">
                                <i class="bi bi-calendar-check-fill"></i> View Available Slots
                            </a>
                        </div>
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
<script src="${pageContext.request.contextPath}/js/notifications.js"></script>

</body>
</html>