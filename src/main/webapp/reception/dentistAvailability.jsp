<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.DentistAvailability" %>

<%
    String selectedDentistId =
            request.getAttribute("selectedDentistId") != null
                    ? request.getAttribute("selectedDentistId").toString()
                    : "";

    String selectedDate =
            request.getAttribute("selectedDate") != null
                    ? request.getAttribute("selectedDate").toString()
                    : "";

    List<DentistAvailability> availabilityList =
            (List<DentistAvailability>)
                    request.getAttribute("availabilityList");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dentist Availability | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dentistAvailability.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="availability-page">

    <div class="availability-container">

        <!-- HEADER -->

        <div class="page-header">

            <div class="header-icon">
                <i class="bi bi-calendar2-week"></i>
            </div>

            <div>

                <h1>Dentist Availability</h1>

                <p>
                    Check dentist availability before booking an appointment.
                </p>

            </div>

        </div>


        <!-- FILTER -->

        <section class="availability-card">

            <div class="section-title">

                <h2>
                    <i class="bi bi-search"></i>
                    Check Availability
                </h2>

                <span class="view-only">
                    <i class="bi bi-eye"></i>
                    View Only
                </span>

            </div>


            <form
                method="get"
                action="${pageContext.request.contextPath}/reception/dentist-availability"
                class="availability-form">

                <div class="form-group">

                    <label for="dentistId">
                        Dentist
                    </label>

                    <select
                        id="dentistId"
                        name="dentistId"
                        required>

                        <option value="">
                            Select Dentist
                        </option>

                        <!--
                            Dentist options will be loaded
                            from the database.
                        -->

                        <option value="1"
                            <%= "1".equals(selectedDentistId) ? "selected" : "" %>>
                            Dr. Sarah Fernando
                        </option>

                        <option value="2"
                            <%= "2".equals(selectedDentistId) ? "selected" : "" %>>
                            Dr. Shin Tamu
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label for="date">
                        Date
                    </label>

                    <div class="date-input-wrapper">

                        <i class="bi bi-calendar3"></i>

                        <input
                            type="date"
                            id="date"
                            name="date"
                            value="<%= selectedDate %>"
                            required>

                    </div>

                </div>


                <button
                    type="submit"
                    class="check-button">

                    <i class="bi bi-search"></i>

                    Check Availability

                </button>

            </form>

        </section>


        <!-- RESULTS -->

        <section class="availability-card">

            <div class="results-header">

                <div>

                    <h2>
                        Available Time Slots
                    </h2>

                    <p>
                        <%= selectedDate %>
                    </p>

                </div>

            </div>


            <%
                if (selectedDentistId.isEmpty()) {
            %>

                <div class="empty-state">

                    <div class="empty-icon">
                        <i class="bi bi-calendar-plus"></i>
                    </div>

                    <h3>Select a Dentist and Date</h3>

                    <p>
                        Choose a dentist and date above
                        to view available time slots.
                    </p>

                </div>

            <%
                } else if (
                        availabilityList == null
                        || availabilityList.isEmpty()
                ) {
            %>

                <div class="empty-state">

                    <div class="empty-icon unavailable">
                        <i class="bi bi-calendar-x"></i>
                    </div>

                    <h3>No Availability</h3>

                    <p>
                        This dentist has no available
                        time slots on the selected date.
                    </p>

                </div>

            <%
                } else {
            %>

                <div class="availability-grid">

                    <%
                        for (DentistAvailability availability
                                : availabilityList) {
                    %>

                        <div class="time-slot">

                            <div class="time-icon">

                                <i class="bi bi-clock"></i>

                            </div>

                            <div class="time-information">

                                <strong>

                                    <%= availability.getStartTime() %>

                                    -

                                    <%= availability.getEndTime() %>

                                </strong>

                                <span>
                                    Available
                                </span>

                            </div>

                            <div class="available-indicator">

                                <i class="bi bi-check-circle-fill"></i>

                            </div>

                        </div>

                    <%
                        }
                    %>

                </div>

            <%
                }
            %>

        </section>


        <!-- INFORMATION -->

        <div class="availability-note">

            <i class="bi bi-info-circle"></i>

            <span>
                Receptionists can view dentist availability only.
                Availability is managed by authorized dentist or administrator accounts.
            </span>

        </div>


        <!-- BACK -->

        <a
            href="${pageContext.request.contextPath}/reception/dashboard"
            class="back-link">

            <i class="bi bi-arrow-left"></i>

            Back to Dashboard

        </a>

    </div>

</div>

</body>

</html>