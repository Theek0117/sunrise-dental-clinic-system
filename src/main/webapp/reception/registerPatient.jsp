<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Register Patient | Sunrise Dental Clinic</title>

    <!-- Google Font -->
    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Page CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/registerPatient.css">

</head>

<body>

<div class="page-wrapper">

    <!-- ========================================= -->
    <!-- TOP HEADER -->
    <!-- ========================================= -->

    <header class="page-header">

        <div class="header-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
                alt="Sunrise Dental Clinic Logo">

            <div>

                <h1>Sunrise Dental Clinic</h1>

                <span>Clinic Management System</span>

            </div>

        </div>

        <a href="${pageContext.request.contextPath}/reception/dashboard"
           class="back-link">

            <i class="bi bi-arrow-left"></i>

            Back to Dashboard

        </a>

    </header>


    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->

    <main class="registration-container">

        <div class="page-title">

            <div class="title-icon">

                <i class="bi bi-person-plus-fill"></i>

            </div>

            <div>

                <h2>Register New Patient</h2>

                <p>
                    Create a patient record before booking an appointment.
                </p>

            </div>

        </div>


        <!-- ========================================= -->
        <!-- SUCCESS MESSAGE -->
        <!-- ========================================= -->

        <% if (request.getAttribute("success") != null) { %>

            <div class="alert alert-success">

                <i class="bi bi-check-circle-fill"></i>

                <div>

                    <strong>Patient registered successfully.</strong>

                    <span>
                        Patient Number:
                        <%= request.getAttribute("patientNumber") %>
                    </span>

                </div>

            </div>

        <% } %>


        <!-- ========================================= -->
        <!-- ERROR MESSAGE -->
        <!-- ========================================= -->

        <% if (request.getAttribute("error") != null) { %>

            <div class="alert alert-error">

                <i class="bi bi-exclamation-circle-fill"></i>

                <div>

                    <strong>Registration unsuccessful</strong>

                    <span>
                        <%= request.getAttribute("error") %>
                    </span>

                </div>

            </div>

        <% } %>


        <!-- ========================================= -->
        <!-- REGISTRATION CARD -->
        <!-- ========================================= -->

        <section class="registration-card">

            <div class="card-header">

                <div>

                    <h3>Patient Information</h3>

                    <p>
                        Enter the patient's personal and contact details.
                    </p>

                </div>

                <span class="required-note">
                    * Required fields
                </span>

            </div>


            <form
                action="${pageContext.request.contextPath}/reception/register-patient"
                method="post"
                class="patient-form">


                <!-- ================================= -->
                <!-- PATIENT NAME -->
                <!-- ================================= -->

                <div class="form-group">

                    <label for="name">
                        Patient Name
                        <span>*</span>
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-person"></i>

                        <input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Enter patient's full name"
                            maxlength="100"
                            autocomplete="name"
                            required>

                    </div>

                </div>


                <!-- ================================= -->
                <!-- CONTACT NUMBER -->
                <!-- ================================= -->

                <div class="form-group">

                    <label for="contactNumber">
                        Contact Number
                        <span>*</span>
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-telephone"></i>

                        <input
                            type="tel"
                            id="contactNumber"
                            name="contactNumber"
                            placeholder="Enter contact number"
                            maxlength="20"
                            autocomplete="tel"
                            required>

                    </div>

                </div>


                <!-- ================================= -->
                <!-- ADDRESS -->
                <!-- ================================= -->

                <div class="form-group full-width">

                    <label for="address">
                        Address
                        <span>*</span>
                    </label>

                    <div class="textarea-wrapper">

                        <i class="bi bi-geo-alt"></i>

                        <textarea
                            id="address"
                            name="address"
                            placeholder="Enter patient's address"
                            maxlength="255"
                            required></textarea>

                    </div>

                </div>


                <!-- ================================= -->
                <!-- EMAIL -->
                <!-- ================================= -->

                <div class="form-group full-width">

                    <label for="email">
                        Email Address
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-envelope"></i>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter email address"
                            maxlength="100"
                            autocomplete="email">

                    </div>

                    <small>
                        If provided, this email must not already belong to another patient.
                    </small>

                </div>


                <!-- ================================= -->
                <!-- ACTIONS -->
                <!-- ================================= -->

                <div class="form-actions">

                    <a
                        href="${pageContext.request.contextPath}/reception/dashboard"
                        class="cancel-button">

                        <i class="bi bi-x-lg"></i>

                        Cancel

                    </a>

                    <button
                        type="submit"
                        class="register-button">

                        <i class="bi bi-person-plus-fill"></i>

                        Register Patient

                    </button>

                </div>

            </form>

        </section>

    </main>

</div>

</body>

</html>