<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Staff Login | Sunrise Dental Clinic</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/login.css">

</head>


<body>

<main class="login-page">

    <!-- Background -->
    <div class="background-overlay"></div>


    <!-- Login Card -->
    <section class="login-card">


        <!-- ==========================
             BRAND
        =========================== -->

        <div class="login-brand">

            <img
                src="${pageContext.request.contextPath}/images/logo1.png"
                alt="Sunrise Dental Clinic Logo"
                class="login-logo">

            <h1>Sunrise Dental Clinic</h1>

            <p>Clinic Management System</p>

        </div>


        <!-- ==========================
             LOGIN HEADING
        =========================== -->

        <div class="login-heading">

            <h2>Welcome Back</h2>

            <p>
                Sign in to access the clinic management system.
            </p>

        </div>


        <!-- ==========================
             ERROR MESSAGE
        =========================== -->

        <% if (request.getAttribute("error") != null) { %>

            <div class="error-message" role="alert">

                <svg
                    class="error-icon"
                    viewBox="0 0 24 24"
                    aria-hidden="true">

                    <circle cx="12" cy="12" r="10"></circle>

                    <line x1="12" y1="7" x2="12" y2="13"></line>

                    <circle
                        cx="12"
                        cy="16.5"
                        r="0.7"
                        fill="currentColor"
                        stroke="none">
                    </circle>

                </svg>

                <span>
                    <%= request.getAttribute("error") %>
                </span>

            </div>

        <% } %>


        <!-- ==========================
             LOGIN FORM
        =========================== -->

        <form
            action="${pageContext.request.contextPath}/login"
            method="post"
            class="login-form"
            id="loginForm"
            autocomplete="on">


            <!-- ==========================
                 USERNAME
            =========================== -->

            <div class="form-group">

                <label for="username">
                    Username
                </label>


                <div class="input-wrapper">

                    <!-- User icon -->

                    <svg
                        class="input-icon"
                        viewBox="0 0 24 24"
                        aria-hidden="true">

                        <circle cx="12" cy="8" r="4"></circle>

                        <path
                            d="M4 21c0-4.2 3.6-7 8-7s8 2.8 8 7">
                        </path>

                    </svg>


                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        autocomplete="username"
                        minlength="3"
                        maxlength="50"
                        required
                        spellcheck="false"
                        autocapitalize="none">

                </div>

            </div>


            <!-- ==========================
                 PASSWORD
            =========================== -->

            <div class="form-group">

                <label for="password">
                    Password
                </label>


                <div class="password-wrapper">

                    <!-- Lock icon -->

                    <svg
                        class="input-icon"
                        viewBox="0 0 24 24"
                        aria-hidden="true">

                        <rect
                            x="5"
                            y="10"
                            width="14"
                            height="10"
                            rx="2">
                        </rect>

                        <path
                            d="M8 10V7a4 4 0 0 1 8 0v3">
                        </path>

                    </svg>


                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        minlength="8"
                        maxlength="100"
                        required>


                    <!-- Password visibility toggle -->

                    <button
                        type="button"
                        class="password-toggle"
                        id="passwordToggle"
                        aria-label="Show password"
                        title="Show password">

                        <!-- Eye -->

                        <svg
                            id="eyeOpen"
                            class="eye-svg"
                            viewBox="0 0 24 24"
                            aria-hidden="true">

                            <path
                                d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12z">
                            </path>

                            <circle
                                cx="12"
                                cy="12"
                                r="2.5">
                            </circle>

                        </svg>


                        <!-- Eye slash -->

                        <svg
                            id="eyeClosed"
                            class="eye-svg hidden"
                            viewBox="0 0 24 24"
                            aria-hidden="true">

                            <path
                                d="M3 3l18 18">
                            </path>

                            <path
                                d="M10.6 6.2A9.7 9.7 0 0 1 12 6c6.5 0 10 6 10 6a17.7 17.7 0 0 1-4.2 4.3">
                            </path>

                            <path
                                d="M6.2 6.3C3.5 8.2 2 12 2 12s3.5 6 10 6c1.3 0 2.5-.3 3.6-.7">
                            </path>

                        </svg>

                    </button>

                </div>

            </div>


            <!-- ==========================
                 LOGIN BUTTON
            =========================== -->

            <button
                type="submit"
                class="login-button"
                id="loginButton">

                <span id="loginButtonText">
                    Sign In
                </span>

                <svg
                    class="button-arrow"
                    viewBox="0 0 24 24"
                    aria-hidden="true">

                    <line
                        x1="5"
                        y1="12"
                        x2="18"
                        y2="12">
                    </line>

                    <polyline
                        points="13,7 18,12 13,17">
                    </polyline>

                </svg>

            </button>

        </form>


        <!-- ==========================
             SECURITY INFORMATION
        =========================== -->

        <div class="security-note">

            <svg
                class="security-icon"
                viewBox="0 0 24 24"
                aria-hidden="true">

                <path
                    d="M12 3l7 3v5c0 4.8-3 8.3-7 10-4-1.7-7-5.2-7-10V6l7-3z">
                </path>

                <polyline
                    points="8.5,12 11,14.5 15.5,9.5">
                </polyline>

            </svg>

            <span>
                Secure staff authentication
            </span>

        </div>


        <!-- ==========================
             FOOTER
        =========================== -->

        <div class="login-footer">

            <span>
                Authorized Staff Only
            </span>


            <a href="${pageContext.request.contextPath}/index.jsp">

                <svg
                    class="back-icon"
                    viewBox="0 0 24 24"
                    aria-hidden="true">

                    <line
                        x1="19"
                        y1="12"
                        x2="5"
                        y2="12">
                    </line>

                    <polyline
                        points="10,7 5,12 10,17">
                    </polyline>

                </svg>

                Return to Website

            </a>

        </div>


    </section>

</main>


<!-- ==========================
     JAVASCRIPT
=========================== -->

<script>

    /* =========================================
       USERNAME RESTRICTION
    ========================================= */

    const usernameInput =
        document.getElementById("username");


    usernameInput.addEventListener("input", function () {

        this.value =
            this.value.replace(/[^a-zA-Z]/g, "");

    });


    /* =========================================
       PASSWORD VISIBILITY
    ========================================= */

    const passwordInput =
        document.getElementById("password");

    const passwordToggle =
        document.getElementById("passwordToggle");

    const eyeOpen =
        document.getElementById("eyeOpen");

    const eyeClosed =
        document.getElementById("eyeClosed");


    passwordToggle.addEventListener("click", function () {

        if (passwordInput.type === "password") {

            passwordInput.type = "text";

            eyeOpen.classList.add("hidden");

            eyeClosed.classList.remove("hidden");

            passwordToggle.setAttribute(
                "aria-label",
                "Hide password"
            );

            passwordToggle.setAttribute(
                "title",
                "Hide password"
            );

        } else {

            passwordInput.type = "password";

            eyeClosed.classList.add("hidden");

            eyeOpen.classList.remove("hidden");

            passwordToggle.setAttribute(
                "aria-label",
                "Show password"
            );

            passwordToggle.setAttribute(
                "title",
                "Show password"
            );

        }

    });


    /* =========================================
       LOGIN BUTTON
    ========================================= */

    const loginForm =
        document.getElementById("loginForm");

    const loginButton =
        document.getElementById("loginButton");

    const loginButtonText =
        document.getElementById("loginButtonText");


    loginForm.addEventListener("submit", function () {

        loginButton.disabled = true;

        loginButton.classList.add("loading");

        loginButtonText.textContent =
            "Signing In...";

    });

</script>


</body>

</html>