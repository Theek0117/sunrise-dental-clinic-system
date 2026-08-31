package com.sunrise.dental.controller;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
        "/admin/*",
        "/reception/*",
        "/cashier/*",
        "/dentist/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        /*
         * No session means the user is not logged in.
         */
        if (session == null
                || session.getAttribute("staffId") == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (role == null) {

            session.invalidate();

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String requestURI =
                httpRequest.getRequestURI();

        String contextPath =
                httpRequest.getContextPath();

        String requestedArea =
                requestURI.substring(
                        contextPath.length()
                );


        /*
         * ADMIN AREA
         */
        if (requestedArea.startsWith("/admin/")
                && !"ADMIN".equalsIgnoreCase(role)) {

            redirectToOwnDashboard(
                    httpRequest,
                    httpResponse,
                    role
            );

            return;
        }


        /*
         * RECEPTION AREA
         */
        if (requestedArea.startsWith("/reception/")
                && !("RECEPTION".equalsIgnoreCase(role)
                || "RECEPTIONIST".equalsIgnoreCase(role))) {

            redirectToOwnDashboard(
                    httpRequest,
                    httpResponse,
                    role
            );

            return;
        }


        /*
         * CASHIER AREA
         */
        if (requestedArea.startsWith("/cashier/")
                && !"CASHIER".equalsIgnoreCase(role)) {

            redirectToOwnDashboard(
                    httpRequest,
                    httpResponse,
                    role
            );

            return;
        }


        /*
         * DENTIST AREA
         */
        if (requestedArea.startsWith("/dentist/")
                && !"DENTIST".equalsIgnoreCase(role)) {

            redirectToOwnDashboard(
                    httpRequest,
                    httpResponse,
                    role
            );

            return;
        }


        /*
         * Access allowed.
         */
        chain.doFilter(
                request,
                response
        );
    }


    private void redirectToOwnDashboard(
            HttpServletRequest request,
            HttpServletResponse response,
            String role)
            throws IOException {

        String contextPath =
                request.getContextPath();

        if ("ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    contextPath
                    + "/admin/adminDashboard.jsp"
            );

        } else if ("RECEPTION".equalsIgnoreCase(role)
                || "RECEPTIONIST".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    contextPath
                    + "/reception/dashboard"
            );

        } else if ("CASHIER".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    contextPath
                    + "/cashier/cashierDashboard.jsp"
            );

        } else if ("DENTIST".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    contextPath
                    + "/dentist/dentistDashboard.jsp"
            );

        } else {

            response.sendRedirect(
                    contextPath
                    + "/login.jsp"
            );
        }
    }
}