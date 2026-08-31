<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    String staffName = (String) session.getAttribute("staffName");

    if (staffName == null) {
        staffName = "Receptionist";
    }

    List<Dentist> dentists =
            (List<Dentist>) request.getAttribute("dentists");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>View Dentists | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dentists.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="page-container">

    <!-- HEADER -->

    <header class="page-header">

        <div class="header-left">

            <div class="page-icon">
                <i class="bi bi-person-badge"></i>
            </div>

            <div>

                <h1>Our Dentists</h1>

                <p>
                    View dentists and check their availability.
                </p>

            </div>

        </div>

        <a href="${pageContext.request.contextPath}/reception/dashboard"
           class="back-button">

            <i class="bi bi-arrow-left"></i>

            Dashboard

        </a>

    </header>


    <!-- SEARCH -->

    <section class="toolbar">

        <div class="search-box">

            <i class="bi bi-search"></i>

            <input
                type="text"
                id="dentistSearch"
                placeholder="Search dentist or specialization...">

        </div>

        <div class="dentist-count">

            <i class="bi bi-people"></i>

            <span>
                <%= dentists != null ? dentists.size() : 0 %>
            </span>

            Active Dentists

        </div>

    </section>


    <!-- DENTIST LIST -->

    <section class="dentist-grid" id="dentistGrid">

        <% if (dentists != null && !dentists.isEmpty()) { %>

            <% for (Dentist dentist : dentists) { %>

                <article
                    class="dentist-card"
                    data-name="<%= dentist.getName().toLowerCase() %>"
                    data-specialization="<%= dentist.getSpecialization().toLowerCase() %>">

                    <div class="dentist-card-header">

                        <div class="dentist-avatar">

                            <i class="bi bi-person-fill"></i>

                        </div>

                        <span class="active-badge">

                            <span></span>

                            Active

                        </span>

                    </div>


                    <div class="dentist-information">

                        <span class="dentist-number">

                            <%= dentist.getDentistNumber() %>

                        </span>

                        <h2>

                            <%= dentist.getName() %>

                        </h2>

                        <p class="specialization">

                            <i class="bi bi-award"></i>

                            <%= dentist.getSpecialization() %>

                        </p>

                    </div>


                    <div class="dentist-contact">

                        <div>

                            <i class="bi bi-telephone"></i>

                            <span>
                                <%= dentist.getContactNumber() %>
                            </span>

                        </div>

                        <div>

                            <i class="bi bi-envelope"></i>

                            <span>
                                <%= dentist.getEmail() %>
                            </span>

                        </div>

                    </div>


                    <div class="dentist-actions">

                        <a
                            href="${pageContext.request.contextPath}/reception/dentist-availability?dentistId=<%= dentist.getDentistId() %>"
                            class="availability-button">

                            <i class="bi bi-calendar-week"></i>

                            View Availability

                        </a>

                        <button
                            type="button"
                            class="details-button"
                            title="View dentist details">

                            <i class="bi bi-three-dots"></i>

                        </button>

                    </div>

                </article>

            <% } %>

        <% } else { %>

            <div class="empty-state">

                <div class="empty-icon">

                    <i class="bi bi-person-x"></i>

                </div>

                <h2>No Active Dentists</h2>

                <p>
                    There are currently no active dentists registered
                    in the system.
                </p>

            </div>

        <% } %>

    </section>

</div>


<script>

    const searchInput =
        document.getElementById("dentistSearch");

    const dentistCards =
        document.querySelectorAll(".dentist-card");

    searchInput.addEventListener("input", function () {

        const searchValue =
            this.value.toLowerCase().trim();

        dentistCards.forEach(function (card) {

            const name =
                card.dataset.name;

            const specialization =
                card.dataset.specialization;

            const matches =
                name.includes(searchValue) ||
                specialization.includes(searchValue);

            card.style.display =
                matches ? "" : "flex";

        });

    });

</script>

</body>

</html>