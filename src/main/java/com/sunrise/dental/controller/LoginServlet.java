package com.sunrise.dental.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.model.Staff;
import com.sunrise.dental.service.AuthenticationService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AuthenticationService authenticationService;

    @Override
    public void init() {
        authenticationService = new AuthenticationService();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Staff staff = authenticationService.authenticate(
                username,
                password
        );

        if (staff != null) {

            /*
             * Create a new session after successful authentication.
             */
            HttpSession session = request.getSession(true);

            session.setAttribute(
                    "staffId",
                    staff.getStaffId()
            );

            session.setAttribute(
                    "staffName",
                    staff.getName()
            );

            session.setAttribute(
                    "username",
                    staff.getUsername()
            );

            session.setAttribute(
                    "role",
                    staff.getRole()
            );

            /*
             * Session timeout:
             * 30 minutes of inactivity.
             */
            session.setMaxInactiveInterval(30 * 60);

            /*
             * Role-based dashboard redirection.
             */
            String role = staff.getRole();

            if ("ADMIN".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/adminDashboard.jsp"
                );

            } else if ("RECEPTION".equalsIgnoreCase(role)
                    || "RECEPTIONIST".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/reception/receptionDashboard.jsp"
                );

            } else if ("CASHIER".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/cashier/cashierDashboard.jsp"
                );

            } else if ("DENTIST".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/dentist/dentistDashboard.jsp"
                );

            } else {

                /*
                 * Unknown role.
                 * Destroy the session and reject the login.
                 */
                session.invalidate();

                request.setAttribute(
                        "error",
                        "Your account has an invalid role."
                );

                request.getRequestDispatcher(
                        "/login.jsp"
                ).forward(request, response);
            }

        } else {

            request.setAttribute(
                    "error",
                    "Invalid username or password."
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(request, response);
        }
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
        );
    }
}