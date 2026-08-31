package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.List;

import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Treatment;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.DentistService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dentist/treatment-history")
public class TreatmentHistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private DentistService dentistService;

    @Override
    public void init() {

        appointmentService =
                new AppointmentService();

        dentistService =
                new DentistService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp"
            );

            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (role == null
                || !"DENTIST".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN
            );

            return;
        }

        Dentist loggedInDentist =
                findLoggedInDentist(session);

        if (loggedInDentist == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN
            );

            return;
        }

        int dentistId =
                loggedInDentist.getDentistId();

        try {

            /*
             * Get all treatment records for this dentist.
             *
             * We first get all patients and then retrieve
             * this dentist's treatment records for each patient.
             */

            List<com.sunrise.dental.model.Patient> patients =
                    appointmentService
                            .getAllPatients();

            List<Treatment> treatmentHistory =
                    new java.util.ArrayList<>();

            if (patients != null) {

                for (
                        com.sunrise.dental.model.Patient patient :
                        patients
                ) {

                    if (patient == null) {
                        continue;
                    }

                    List<Treatment> patientTreatments =
                            appointmentService
                                    .getDentistPatientTreatmentHistory(
                                            patient.getPatientId(),
                                            dentistId
                                    );

                    if (patientTreatments != null
                            && !patientTreatments.isEmpty()) {

                        treatmentHistory.addAll(
                                patientTreatments
                        );
                    }
                }
            }

            request.setAttribute(
                    "loggedInDentist",
                    loggedInDentist
            );

            request.setAttribute(
                    "treatmentHistory",
                    treatmentHistory
            );

            request.getRequestDispatcher(
                    "/dentist/treatment-history.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "treatmentHistory",
                    java.util.Collections.emptyList()
            );

            request.setAttribute(
                    "errorMessage",
                    "Unable to load treatment history."
            );

            request.getRequestDispatcher(
                    "/dentist/treatment-history.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }


    // =========================================================
    // FIND LOGGED-IN DENTIST
    // =========================================================

    private Dentist findLoggedInDentist(
            HttpSession session) {

        String staffName =
                (String) session.getAttribute(
                        "staffName"
                );

        if (staffName == null
                || staffName.isBlank()) {

            return null;
        }

        try {

            List<Dentist> dentists =
                    dentistService.getActiveDentists();

            for (Dentist dentist : dentists) {

                if (dentist != null
                        && dentist.getName() != null
                        && dentist.getName()
                                .equalsIgnoreCase(
                                        staffName.trim()
                                )) {

                    return dentist;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }
}