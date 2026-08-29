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

        authenticationService =
                new AuthenticationService();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        Staff staff =
                authenticationService.authenticate(
                        username,
                        password
                );

        if (staff != null) {

            HttpSession session =
                    request.getSession(true);

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

            session.setMaxInactiveInterval(
                    30 * 60
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard.jsp"
            );

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