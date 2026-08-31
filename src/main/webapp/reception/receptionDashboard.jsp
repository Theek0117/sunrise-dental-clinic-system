<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String staffName = (String) session.getAttribute("staffName");
    String role = (String) session.getAttribute("role");

    if (staffName == null) {
        staffName = "Receptionist";
    }

    if (role == null) {
        role = "RECEPTION";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Receptionist Dashboard | Sunrise Dental Clinic</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/reception.css">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="dashboard-container">

    <!-- ================================================= -->
    <!-- SIDEBAR -->
    <!-- ================================================= -->

    <aside class="sidebar" id="sidebar">

        <div class="sidebar-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
                alt="Sunrise Dental Clinic Logo">

            <div class="brand-text">
                <h2>Sunrise</h2>
                <span>Dental Clinic</span>
            </div>

        </div>


        <!-- MAIN NAVIGATION -->

        <nav class="sidebar-navigation">

    <p class="navigation-title">MAIN</p>

    <!-- DASHBOARD -->
    <a href="${pageContext.request.contextPath}/reception/receptionDashboard.jsp"
       class="nav-item active">

        <i class="bi bi-grid-1x2-fill"></i>

        <span>Dashboard</span>

    </a>


    <!-- SCHEDULE -->
    <a href="#"
       class="nav-item">

        <i class="bi bi-calendar3"></i>

        <span>Schedule</span>

    </a>


    <!-- APPOINTMENTS MENU -->
    <div class="nav-dropdown">

    <button type="button"
            class="nav-item nav-dropdown-toggle"
            id="appointmentsToggle">

        <span class="nav-item-left">

            <i class="bi bi-calendar-check"></i>

            <span>Appointments</span>

        </span>

        <i class="bi bi-chevron-down dropdown-arrow"></i>

    </button>

    <div class="nav-submenu" id="appointmentsSubmenu">

        <a href="${pageContext.request.contextPath}/reception/book-appointment"
           class="nav-subitem">

            <i class="bi bi-calendar-plus"></i>

            <span>Book Appointment</span>

        </a>

        <a href="#"
           class="nav-subitem">

            <i class="bi bi-calendar3"></i>

            <span>View Appointments</span>

        </a>

        <a href="#"
           class="nav-subitem">

            <i class="bi bi-calendar2-week"></i>

            <span>Reschedule Appointment</span>

        </a>

        <a href="#"
           class="nav-subitem">

            <i class="bi bi-calendar-x"></i>

            <span>Cancel Appointment</span>

        </a>

    </div>

</div>


    <!-- PATIENTS MENU -->
    <div class="nav-group">

    <button
        type="button"
        class="nav-item nav-parent"
        id="patientsMenuButton">

        <span class="nav-item-left">

            <i class="bi bi-people"></i>

            <span>Patients</span>

        </span>

        <i class="bi bi-chevron-down nav-chevron"></i>

    </button>


    <div
        class="nav-submenu"
        id="patientsSubmenu">

        <a
            href="${pageContext.request.contextPath}/reception/register-patient"
            class="nav-subitem">

            <i class="bi bi-person-plus"></i>

            <span>Register New Patient</span>

        </a>


        <a
            href="${pageContext.request.contextPath}/reception/manage-patients"
            class="nav-subitem">

            <i class="bi bi-person-lines-fill"></i>

            <span>Manage Patients</span>

        </a>

    </div>

</div>

    <p class="navigation-title clinic-title">
        CLINIC
    </p>


    <!-- DENTISTS -->
    <div class="nav-group">

    <button
        type="button"
        class="nav-item nav-toggle"
        onclick="toggleNavGroup('dentistMenu', this)">

        <span class="nav-item-left">

            <i class="bi bi-person-badge"></i>

            <span>Dentists</span>

        </span>

        <i class="bi bi-chevron-down nav-arrow"></i>

    </button>


    <div
        class="nav-submenu"
        id="dentistMenu">

        <a
            href="${pageContext.request.contextPath}/reception/dentists">

            <i class="bi bi-people"></i>

            <span>View Dentists</span>

        </a>

        <a
            href="${pageContext.request.contextPath}/reception/dentist-availability">

            <i class="bi bi-calendar2-week"></i>

            <span>Check Availability</span>

        </a>

    </div>

</div>


    <!-- HELP DESK -->
    <a href="#"
       class="nav-item">

        <i class="bi bi-question-circle"></i>

        <span>Help Desk</span>

    </a>

</nav>


        <!-- ACCOUNT -->

        <div class="sidebar-bottom">

            <p class="navigation-title">ACCOUNT</p>

            <a href="#" class="nav-item">

                <i class="bi bi-person-circle"></i>

                <span>My Profile</span>

            </a>


            <a href="${pageContext.request.contextPath}/logout"
               class="nav-item logout-item">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </aside>


    <!-- ================================================= -->
    <!-- MAIN CONTENT -->
    <!-- ================================================= -->

    <main class="main-content">

        <!-- TOP BAR -->

        <header class="topbar">

            <div class="topbar-left">

                <button
                    type="button"
                    class="menu-button"
                    id="menuButton">

                    <i class="bi bi-list"></i>

                </button>

                <div>

                    <h1>Dashboard</h1>

                    <p>Reception Management</p>

                </div>

            </div>


            <div class="topbar-right">

                <!-- Notification -->

                <button
                    type="button"
                    class="icon-button"
                    title="Notifications">

                    <i class="bi bi-bell"></i>

                    <span class="notification-dot"></span>

                </button>


                <!-- User -->

                <div class="user-profile">

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

                    <i class="bi bi-chevron-down profile-arrow"></i>

                </div>

            </div>

        </header>


        <!-- ================================================= -->
        <!-- PAGE CONTENT -->
        <!-- ================================================= -->

        <section class="dashboard-content">


            <!-- WELCOME -->

            <div class="welcome-section">

                <div>

                    <h2>
                        Good Morning, <%= staffName %>
                    </h2>

                    <p>
                        Here's what's happening at Sunrise Dental Clinic today.
                    </p>

                </div>

                <div class="current-date">

                    <i class="bi bi-calendar3"></i>

                    <span id="currentDate"></span>

                </div>

            </div>


            <!-- ================================================= -->
            <!-- STATISTICS -->
            <!-- ================================================= -->

            <section class="statistics-grid">


                <!-- Today's Appointments -->

                <div class="stat-card">

                    <div class="stat-icon appointment-icon">

                        <i class="bi bi-calendar-check"></i>

                    </div>

                    <div class="stat-information">

                        <span>Today's Appointments</span>

                        <strong>12</strong>

                        <small>
                            Scheduled today
                        </small>

                    </div>

                </div>


                <!-- Confirmed -->

                <div class="stat-card">

                    <div class="stat-icon confirmed-icon">

                        <i class="bi bi-check-circle"></i>

                    </div>

                    <div class="stat-information">

                        <span>Confirmed</span>

                        <strong>8</strong>

                        <small>
                            Confirmed appointments
                        </small>

                    </div>

                </div>


                <!-- Available Slots -->

                <div class="stat-card">

                    <div class="stat-icon availability-icon">

                        <i class="bi bi-clock"></i>

                    </div>

                    <div class="stat-information">

                        <span>Available Slots</span>

                        <strong>6</strong>

                        <small>
                            Dentist slots available
                        </small>

                    </div>

                </div>


                <!-- Total Patients -->

                <div class="stat-card">

                    <div class="stat-icon patient-icon">

                        <i class="bi bi-people"></i>

                    </div>

                    <div class="stat-information">

                        <span>Total Patients</span>

                        <strong>248</strong>

                        <small>
                            Registered patients
                        </small>

                    </div>

                </div>

            </section>


            <!-- ================================================= -->
            <!-- QUICK ACTIONS -->
            <!-- ================================================= -->

            <section class="quick-actions-section">

                <div class="section-heading">

                    <div>

                        <h3>Quick Actions</h3>

                        <p>
                            Common receptionist tasks
                        </p>

                    </div>

                </div>


                <div class="quick-actions-grid">


                    <a href="${pageContext.request.contextPath}/reception/register-patient"
						    class="quick-action-card">
						
						    <div class="quick-action-icon">
						
						        <i class="bi bi-person-plus"></i>
						
						    </div>
						
						    <div>
						
						        <strong>
						            Register New Patient
						        </strong>
						
						        <span>
						            Add a new patient
						        </span>
						
						    </div>
						
						    <i class="bi bi-arrow-right"></i>
						
						</a>


                   <a href="${pageContext.request.contextPath}/reception/book-appointment"
					   class="quick-action-card">
					
					    <div class="quick-action-icon">
					        <i class="bi bi-calendar-plus"></i>
					    </div>
					
					    <div>
					        <strong>Book Appointment</strong>
					
					        <span>
					            Schedule an appointment
					        </span>
					    </div>
					
					    <i class="bi bi-arrow-right"></i>
					
					</a>


                   <a href="${pageContext.request.contextPath}/reception/manage-patients"
					    class="quick-action-card">
					
					    <div class="quick-action-icon">
					
					        <i class="bi bi-people"></i>
					
					    </div>
					
					    <div>
					
					        <strong>
					            Manage Patients
					        </strong>
					
					        <span>
					            Search and update patient records
					        </span>
					
					    </div>
					
					    <i class="bi bi-arrow-right"></i>
					
					</a>

                </div>

            </section>


            <!-- ================================================= -->
            <!-- TODAY'S APPOINTMENTS -->
            <!-- ================================================= -->

            <section class="appointments-section">

                <div class="section-heading">

                    <div>

                        <h3>Today's Appointments</h3>

                        <p>
                            Overview of today's scheduled appointments
                        </p>

                    </div>

                    <a href="#" class="view-all-link">

                        View All

                        <i class="bi bi-arrow-right"></i>

                    </a>

                </div>


                <div class="table-container">

                    <table class="appointments-table">

                        <thead>

                        <tr>

                            <th>Time</th>

                            <th>Patient</th>

                            <th>Dentist</th>

                            <th>Treatment</th>

                            <th>Status</th>

                            <th>Action</th>

                        </tr>

                        </thead>


                        <tbody>


                        <tr>

                            <td>
                                <strong>09:00 AM</strong>
                            </td>

                            <td>

                                <div class="patient-cell">

                                    <div class="patient-avatar">
                                        RT
                                    </div>

                                    <div>
                                        <strong>Riko Tanaka</strong>
                                        <span>PT-0001</span>
                                    </div>

                                </div>

                            </td>

                            <td>
                                Dr. Shin Tamu
                            </td>

                            <td>
                                Root Canal Treatment
                            </td>

                            <td>

                                <span class="status confirmed">
                                    Confirmed
                                </span>

                            </td>

                            <td>

                                <button
                                    class="table-action"
                                    title="View appointment">

                                    <i class="bi bi-three-dots"></i>

                                </button>

                            </td>

                        </tr>


                        <tr>

                            <td>
                                <strong>10:00 AM</strong>
                            </td>

                            <td>

                                <div class="patient-cell">

                                    <div class="patient-avatar">
                                        AK
                                    </div>

                                    <div>
                                        <strong>Akiko Takahashi</strong>
                                        <span>PT-0002</span>
                                    </div>

                                </div>

                            </td>

                            <td>
                                Dr. Sarah Fernando
                            </td>

                            <td>
                                Scaling
                            </td>

                            <td>

                                <span class="status waiting">
                                    Waiting
                                </span>

                            </td>

                            <td>

                                <button
                                    class="table-action"
                                    title="View appointment">

                                    <i class="bi bi-three-dots"></i>

                                </button>

                            </td>

                        </tr>


                        <tr>

                            <td>
                                <strong>11:30 AM</strong>
                            </td>

                            <td>

                                <div class="patient-cell">

                                    <div class="patient-avatar">
                                        HC
                                    </div>

                                    <div>
                                        <strong>Hiroki Kimura</strong>
                                        <span>PT-0003</span>
                                    </div>

                                </div>

                            </td>

                            <td>
                                Dr. Shin Tamu
                            </td>

                            <td>
                                Consultation
                            </td>

                            <td>

                                <span class="status confirmed">
                                    Confirmed
                                </span>

                            </td>

                            <td>

                                <button
                                    class="table-action"
                                    title="View appointment">

                                    <i class="bi bi-three-dots"></i>

                                </button>

                            </td>

                        </tr>


                        <tr>

                            <td>
                                <strong>02:00 PM</strong>
                            </td>

                            <td>

                                <div class="patient-cell">

                                    <div class="patient-avatar">
                                        JC
                                    </div>

                                    <div>
                                        <strong>John Cooper</strong>
                                        <span>PT-0004</span>
                                    </div>

                                </div>

                            </td>

                            <td>
                                Dr. Sarah Fernando
                            </td>

                            <td>
                                Dental Cleaning
                            </td>

                            <td>

                                <span class="status cancelled">
                                    Cancelled
                                </span>

                            </td>

                            <td>

                                <button
                                    class="table-action"
                                    title="View appointment">

                                    <i class="bi bi-three-dots"></i>

                                </button>

                            </td>

                        </tr>


                        </tbody>

                    </table>

                </div>

            </section>

        </section>

    </main>

</div>


<!-- ================================================= -->
<!-- DASHBOARD JAVASCRIPT -->
<!-- ================================================= -->

<script>

    /*
     * Display current date
     */

    const currentDateElement =
        document.getElementById("currentDate");

    const today = new Date();

    const dateOptions = {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric"
    };

    currentDateElement.textContent =
        today.toLocaleDateString(
            "en-US",
            dateOptions
        );


    /*
     * Mobile sidebar
     */

    const menuButton =
        document.getElementById("menuButton");

    const sidebar =
        document.getElementById("sidebar");

    menuButton.addEventListener(
        "click",
        function () {

            sidebar.classList.toggle("sidebar-open");

        }
    );

</script>

<script>

    /* =====================================================
       SIDEBAR DROPDOWN MENUS
       ===================================================== */

    const dropdownButtons =
        document.querySelectorAll(".nav-dropdown-toggle");


    dropdownButtons.forEach(function(button) {

        button.addEventListener("click", function() {

            const targetId =
                button.getAttribute("data-target");

            const targetMenu =
                document.getElementById(targetId);

            const currentDropdown =
                button.closest(".nav-dropdown");


            /*
             * Close other dropdowns
             */
            document.querySelectorAll(".nav-dropdown")
                .forEach(function(dropdown) {

                    if (dropdown !== currentDropdown) {

                        dropdown.classList.remove("open");

                    }

                });


            /*
             * Toggle current dropdown
             */
            currentDropdown.classList.toggle("open");

        });

    });
    
    
    
    const patientsMenuButton =
        document.getElementById("patientsMenuButton");

    const patientsNavGroup =
        patientsMenuButton.closest(".nav-group");

    patientsMenuButton.addEventListener(
        "click",
        function () {

            patientsNavGroup.classList.toggle("open");

        }
    );

</script>

<script>

function toggleNavGroup(menuId, button) {

    const menu =
        document.getElementById(menuId);

    const isOpen =
        menu.classList.contains("open");

    document
        .querySelectorAll(".nav-submenu")
        .forEach(function(item) {
            item.classList.remove("open");
        });

    document
        .querySelectorAll(".nav-toggle")
        .forEach(function(item) {
            item.classList.remove("expanded");
        });

    if (!isOpen) {

        menu.classList.add("open");

        button.classList.add("expanded");
    }
}

</script>

<script>

    /*
     * ==========================================
     * APPOINTMENTS DROPDOWN
     * ==========================================
     */

    const appointmentsToggle =
        document.getElementById("appointmentsToggle");

    const appointmentsSubmenu =
        document.getElementById("appointmentsSubmenu");

    if (appointmentsToggle && appointmentsSubmenu) {

        appointmentsToggle.addEventListener(
            "click",
            function () {

                appointmentsToggle.classList.toggle(
                    "dropdown-open"
                );

                appointmentsSubmenu.classList.toggle(
                    "submenu-open"
                );

            }
        );
    }

</script>

</body>

</html>