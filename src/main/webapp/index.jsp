<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <meta name="description"
        content="Sunrise Dental Clinic Management System">

    <title>Sunrise Dental Clinic | Dental Care Management</title>

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

    <!-- ================= NAVIGATION ================= -->

    <header class="navbar">

        <div class="nav-container">

            <a href="${pageContext.request.contextPath}/"
               class="brand">

                <div class="brand-icon">
                    <span>✦</span>
                </div>

                <div class="brand-text">
                    <strong>Sunrise</strong>
                    <span>Dental Clinic</span>
                </div>

            </a>


            <nav class="nav-links">

                <a href="#home" class="active">Home</a>

                <a href="#services">Services</a>

                <a href="#about">About</a>

                <a href="#contact">Contact</a>

            </nav>


            <a href="#staff-login"
               class="nav-login">

                Staff Login
                <span>→</span>

            </a>

        </div>

    </header>


    <main>

        <!-- ================= HERO ================= -->

        <section class="hero" id="home">

            <div class="hero-container">

                <div class="hero-content">

                    <div class="eyebrow">
                        <span class="eyebrow-dot"></span>
                        SUNRISE DENTAL CLINIC
                    </div>


                    <h1>
                        Better Care Starts
                        <span>With a Better Smile.</span>
                    </h1>


                    <p class="hero-description">
                        A modern dental clinic management system designed
                        to help our team manage appointments, patient
                        information, treatments and billing efficiently.
                    </p>


                    <div class="hero-actions">

                        <a href="#appointment-lookup"
                           class="btn btn-primary">

                            View My Appointment

                            <span>→</span>

                        </a>


                        <a href="#staff-login"
                           class="btn btn-secondary">

                            Staff Login

                        </a>

                    </div>


                    <div class="hero-features">

                        <div class="feature-item">
                            <span class="feature-check">✓</span>
                            <span>Efficient Appointments</span>
                        </div>

                        <div class="feature-item">
                            <span class="feature-check">✓</span>
                            <span>Secure Records</span>
                        </div>

                        <div class="feature-item">
                            <span class="feature-check">✓</span>
                            <span>Accurate Billing</span>
                        </div>

                    </div>

                </div>


                <!-- HERO VISUAL -->

                <div class="hero-visual">

                    <div class="visual-glow"></div>

                    <div class="dental-card">

                        <div class="card-top">

                            <div>
                                <span class="small-label">
                                    YOUR SMILE
                                </span>

                                <h3>
                                    Our Priority
                                </h3>
                            </div>

                            <div class="card-status">
                                <span></span>
                                Caring
                            </div>

                        </div>


                        <div class="tooth-illustration">

                            <div class="tooth">
                                <div class="tooth-shine"></div>
                            </div>

                        </div>


                        <div class="card-bottom">

                            <div>
                                <span class="small-label">
                                    PATIENT CARE
                                </span>

                                <strong>
                                    Professional & Reliable
                                </strong>
                            </div>

                            <div class="plus-icon">
                                +
                            </div>

                        </div>

                    </div>


                    <div class="floating-card appointment-card">

                        <div class="floating-icon">
                            ✓
                        </div>

                        <div>
                            <span>Appointment</span>
                            <strong>Managed Efficiently</strong>
                        </div>

                    </div>


                    <div class="floating-card record-card">

                        <div class="floating-icon">
                            +
                        </div>

                        <div>
                            <span>Patient Records</span>
                            <strong>Organized & Secure</strong>
                        </div>

                    </div>

                </div>

            </div>

        </section>


        <!-- ================= TRUST BAR ================= -->

        <section class="trust-bar">

            <div class="trust-container">

                <div class="trust-item">
                    <strong>01</strong>
                    <span>Patient Management</span>
                </div>

                <div class="trust-divider"></div>

                <div class="trust-item">
                    <strong>02</strong>
                    <span>Appointment Management</span>
                </div>

                <div class="trust-divider"></div>

                <div class="trust-item">
                    <strong>03</strong>
                    <span>Treatment Records</span>
                </div>

                <div class="trust-divider"></div>

                <div class="trust-item">
                    <strong>04</strong>
                    <span>Billing & Payments</span>
                </div>

            </div>

        </section>


        <!-- ================= SERVICES ================= -->

        <section class="services-section" id="services">

            <div class="section-container">

                <div class="section-heading">

                    <div class="eyebrow">
                        <span class="eyebrow-dot"></span>
                        WHAT WE MANAGE
                    </div>

                    <h2>
                        Everything your clinic needs,
                        <span>in one place.</span>
                    </h2>

                    <p>
                        The Sunrise Dental Clinic system brings essential
                        clinic operations together into one organized
                        application.
                    </p>

                </div>


                <div class="service-grid">

                    <article class="service-card">

                        <div class="service-number">
                            01
                        </div>

                        <div class="service-icon">
                            ♙
                        </div>

                        <h3>
                            Patient Management
                        </h3>

                        <p>
                            Register and maintain accurate patient
                            information for efficient clinic operations.
                        </p>

                        <span class="service-arrow">
                            →
                        </span>

                    </article>


                    <article class="service-card featured">

                        <div class="service-number">
                            02
                        </div>

                        <div class="service-icon">
                            ◷
                        </div>

                        <h3>
                            Appointment Management
                        </h3>

                        <p>
                            Register, update, reschedule and cancel
                            appointments while checking dentist availability.
                        </p>

                        <span class="service-arrow">
                            →
                        </span>

                    </article>


                    <article class="service-card">

                        <div class="service-number">
                            03
                        </div>

                        <div class="service-icon">
                            ✚
                        </div>

                        <h3>
                            Treatment Records
                        </h3>

                        <p>
                            Dentists can view treatment history and maintain
                            treatment records and clinical notes.
                        </p>

                        <span class="service-arrow">
                            →
                        </span>

                    </article>


                    <article class="service-card">

                        <div class="service-number">
                            04
                        </div>

                        <div class="service-icon">
                            ◫
                        </div>

                        <h3>
                            Billing & Payments
                        </h3>

                        <p>
                            Calculate treatment costs, consultation fees,
                            total amounts and record patient payments.
                        </p>

                        <span class="service-arrow">
                            →
                        </span>

                    </article>

                </div>

            </div>

        </section>


        <!-- ================= APPOINTMENT LOOKUP ================= -->

        <section class="lookup-section" id="appointment-lookup">

            <div class="lookup-container">

                <div class="lookup-content">

                    <div class="eyebrow light-eyebrow">
                        <span class="eyebrow-dot"></span>
                        PATIENT ACCESS
                    </div>

                    <h2>
                        Check your appointment
                        <span>details easily.</span>
                    </h2>

                    <p>
                        Enter the unique appointment number provided by
                        Sunrise Dental Clinic to view your appointment
                        information.
                    </p>

                </div>


                <div class="lookup-box">

                    <div class="lookup-icon">
                        #
                    </div>

                    <div class="lookup-text">

                        <span>
                            Appointment Number
                        </span>

                        <strong>
                            Your unique appointment number
                        </strong>

                    </div>

                    <button type="button"
                            class="lookup-button"
                            onclick="showLookupMessage()">

                        View Details
                        <span>→</span>

                    </button>

                </div>

            </div>

        </section>


        <!-- ================= ABOUT ================= -->

        <section class="about-section" id="about">

            <div class="section-container about-container">

                <div class="about-visual">

                    <div class="about-box">

                        <span class="about-symbol">
                            ✦
                        </span>

                        <strong>
                            SUNRISE
                        </strong>

                        <span>
                            DENTAL CLINIC
                        </span>

                    </div>

                </div>


                <div class="about-content">

                    <div class="eyebrow">
                        <span class="eyebrow-dot"></span>
                        ABOUT THE SYSTEM
                    </div>

                    <h2>
                        Designed for a
                        <span>busy dental clinic.</span>
                    </h2>

                    <p>
                        Sunrise Dental Clinic uses this system to improve
                        the way patient appointments, treatment information,
                        billing and administrative activities are managed.
                    </p>

                    <p>
                        By bringing these activities into one application,
                        clinic staff can work more efficiently while
                        maintaining accurate and organized information.
                    </p>


                    <div class="about-points">

                        <div>
                            <span>✓</span>
                            Organized patient information
                        </div>

                        <div>
                            <span>✓</span>
                            Efficient appointment handling
                        </div>

                        <div>
                            <span>✓</span>
                            Accurate billing information
                        </div>

                    </div>

                </div>

            </div>

        </section>


        <!-- ================= CONTACT ================= -->

        <section class="contact-section" id="contact">

            <div class="section-container contact-container">

                <div>

                    <div class="eyebrow">
                        <span class="eyebrow-dot"></span>
                        CONTACT
                    </div>

                    <h2>
                        Need assistance?
                    </h2>

                    <p>
                        Contact Sunrise Dental Clinic for appointment
                        assistance or further information.
                    </p>

                </div>


                <div class="contact-details">

                    <div class="contact-item">

                        <span class="contact-icon">
                            ☎
                        </span>

                        <div>
                            <span>Call Us</span>
                            <strong>Clinic Reception</strong>
                        </div>

                    </div>


                    <div class="contact-item">

                        <span class="contact-icon">
                            @
                        </span>

                        <div>
                            <span>Email</span>
                            <strong>info@sunrisedental.lk</strong>
                        </div>

                    </div>


                    <div class="contact-item">

                        <span class="contact-icon">
                            +
                        </span>

                        <div>
                            <span>Location</span>
                            <strong>Colombo, Sri Lanka</strong>
                        </div>

                    </div>

                </div>

            </div>

        </section>

    </main>


    <!-- ================= FOOTER ================= -->

    <footer class="footer">

        <div class="footer-container">

            <div class="footer-brand">

                <div class="brand-icon">
                    <span>✦</span>
                </div>

                <div class="brand-text">
                    <strong>Sunrise</strong>
                    <span>Dental Clinic</span>
                </div>

            </div>


            <p>
                © 2026 Sunrise Dental Clinic Management System.
                All rights reserved.
            </p>


            <div class="footer-links">

                <a href="#home">Home</a>

                <a href="#services">Services</a>

                <a href="#contact">Contact</a>

            </div>

        </div>

    </footer>


    <!-- ================= JAVASCRIPT ================= -->

    <script>

        function showLookupMessage() {

            alert(
                "Appointment lookup will be available in the next module."
            );

        }

    </script>

</body>

</html>