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

        <section class="login-card">

            <div class="login-brand">

                <img
                    src="${pageContext.request.contextPath}/images/sunrise.svg"
                    alt="Sunrise Dental Clinic">

                <h1>Sunrise Dental Clinic</h1>

                <p>Clinic Management System</p>

            </div>

            <div class="login-heading">

                <h2>Welcome Back</h2>

                <p>
                    Sign in to access the clinic management system.
                </p>

            </div>

            <% if (request.getAttribute("error") != null) { %>

                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>

            <% } %>

            <form
                action="${pageContext.request.contextPath}/login"
                method="post"
                class="login-form">

                <div class="form-group">

                    <label for="username">
                        Username
                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        autocomplete="username"
                        required>

                </div>

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                </div>

                <button type="submit" class="login-button">
                    Sign In
                </button>

            </form>

            <div class="login-footer">

                <span>Authorized Staff Only</span>

                <a href="${pageContext.request.contextPath}/index.jsp">
                    Return to Website
                </a>

            </div>

        </section>

    </main>

</body>

</html>