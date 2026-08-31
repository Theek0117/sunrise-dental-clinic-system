package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.dao.PatientReportDAO;
import com.sunrise.dental.dao.PatientReportDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.PatientReport;
import com.sunrise.dental.model.Treatment;
import com.sunrise.dental.service.AppointmentService;
import com.sunrise.dental.service.DentistService;

@WebServlet("/dentist/appointment-details")
public class DentistAppointmentDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;
    private DentistService dentistService;
    private PatientReportDAO patientReportDAO;

    @Override
    public void init() {

        appointmentService =
                new AppointmentService();

        dentistService =
                new DentistService();

        patientReportDAO =
                new PatientReportDAOImpl();
    }

    // =========================================================
    // GET APPOINTMENT DETAILS
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

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

            String appointmentIdParameter =
                    request.getParameter(
                            "appointmentId"
                    );

            if (appointmentIdParameter == null
                    || appointmentIdParameter.isBlank()) {

                redirectToAppointments(
                        request,
                        response,
                        "error=invalid"
                );

                return;
            }

            int appointmentId;

            try {

                appointmentId =
                        Integer.parseInt(
                                appointmentIdParameter.trim()
                        );

            } catch (NumberFormatException e) {

                redirectToAppointments(
                        request,
                        response,
                        "error=invalid"
                );

                return;
            }

            // -------------------------------------------------
            // FIND LOGGED-IN DENTIST
            // -------------------------------------------------

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

            // -------------------------------------------------
            // SECURITY:
            // ONLY THIS DENTIST'S APPOINTMENT
            // -------------------------------------------------

            Appointment appointment =
                    appointmentService
                            .getDentistAppointment(
                                    appointmentId,
                                    dentistId
                            );

            if (appointment == null) {

                redirectToAppointments(
                        request,
                        response,
                        "error=notfound"
                );

                return;
            }

            // -------------------------------------------------
            // PATIENT
            // -------------------------------------------------

            Patient patient =
                    appointmentService.getPatient(
                            appointment.getPatientId()
                    );

            if (patient == null) {

                redirectToAppointments(
                        request,
                        response,
                        "error=patient"
                );

                return;
            }

            // -------------------------------------------------
            // TREATMENT
            // -------------------------------------------------

            Treatment treatment =
                    appointmentService
                            .getTreatmentForAppointment(
                                    appointmentId,
                                    dentistId
                            );

            // -------------------------------------------------
            // PATIENT TREATMENT HISTORY
            // -------------------------------------------------

            List<Treatment> treatmentHistory =
                    appointmentService
                            .getDentistPatientTreatmentHistory(
                                    appointment.getPatientId(),
                                    dentistId
                            );

            // -------------------------------------------------
            // PATIENT REPORTS
            // -------------------------------------------------

            List<PatientReport> reports =
                    patientReportDAO
                            .findByAppointmentId(
                                    appointmentId
                            );

            // -------------------------------------------------
            // SEND DATA TO JSP
            // -------------------------------------------------

            request.setAttribute(
                    "loggedInDentist",
                    loggedInDentist
            );

            request.setAttribute(
                    "appointment",
                    appointment
            );

            request.setAttribute(
                    "patient",
                    patient
            );

            request.setAttribute(
                    "treatment",
                    treatment
            );

            request.setAttribute(
                    "treatmentHistory",
                    treatmentHistory
            );

            request.setAttribute(
                    "reports",
                    reports
            );

            request.getRequestDispatcher(
                    "/dentist/appointmentDetails.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectToAppointments(
                    request,
                    response,
                    "error=server"
            );
        }
    }

    // =========================================================
    // POST ACTIONS
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {

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

            String appointmentIdParameter =
                    request.getParameter(
                            "appointmentId"
                    );

            String action =
                    request.getParameter("action");

            if (appointmentIdParameter == null
                    || appointmentIdParameter.isBlank()
                    || action == null
                    || action.isBlank()) {

                redirectToAppointments(
                        request,
                        response,
                        "error=invalid"
                );

                return;
            }

            int appointmentId =
                    Integer.parseInt(
                            appointmentIdParameter.trim()
                    );

            // -------------------------------------------------
            // SECURITY CHECK
            // -------------------------------------------------

            Appointment appointment =
                    appointmentService
                            .getDentistAppointment(
                                    appointmentId,
                                    dentistId
                            );

            if (appointment == null) {

                redirectToAppointments(
                        request,
                        response,
                        "error=notfound"
                );

                return;
            }

            // =================================================
            // UPDATE STATUS
            // =================================================

            if ("status".equalsIgnoreCase(action)) {

                String status =
                        request.getParameter("status");

                if (status == null
                        || status.isBlank()) {

                    redirectToDetails(
                            request,
                            response,
                            appointmentId,
                            "error=status"
                    );

                    return;
                }

                boolean updated =
                        appointmentService
                                .updateAppointmentStatus(
                                        appointmentId,
                                        dentistId,
                                        status
                                );

                if (updated) {

                    redirectToDetails(
                            request,
                            response,
                            appointmentId,
                            "success=status"
                    );

                } else {

                    redirectToDetails(
                            request,
                            response,
                            appointmentId,
                            "error=status"
                    );
                }

                return;
            }

            // =================================================
            // SAVE TREATMENT
            // =================================================

            if ("treatment".equalsIgnoreCase(action)) {

                String diagnosis =
                        request.getParameter("diagnosis");

                String treatmentProvided =
                        request.getParameter(
                                "treatmentProvided"
                        );

                String treatmentNotes =
                        request.getParameter(
                                "treatmentNotes"
                        );

                String nextAppointmentDate =
                        request.getParameter(
                                "nextAppointmentDate"
                        );

                Treatment treatment =
                        appointmentService
                                .getTreatmentForAppointment(
                                        appointmentId,
                                        dentistId
                                );

                if (treatment == null) {

                    treatment =
                            new Treatment();

                    treatment.setAppointmentId(
                            appointmentId
                    );

                    treatment.setPatientId(
                            appointment.getPatientId()
                    );

                    treatment.setDentistId(
                            dentistId
                    );
                }

                treatment.setDiagnosis(
                        safeValue(diagnosis)
                );

                treatment.setTreatmentProvided(
                        safeValue(treatmentProvided)
                );

                treatment.setTreatmentNotes(
                        safeValue(treatmentNotes)
                );

                if (nextAppointmentDate != null
                        && !nextAppointmentDate.isBlank()) {

                    treatment.setNextAppointmentDate(
                            java.sql.Date.valueOf(
                                    nextAppointmentDate.trim()
                            )
                    );

                } else {

                    treatment.setNextAppointmentDate(
                            null
                    );
                }

                boolean saved =
                        appointmentService
                                .saveTreatment(
                                        treatment
                                );

                if (saved) {

                    // Automatically mark appointment
                    // as completed after treatment is saved.

                    appointmentService
                            .updateAppointmentStatus(
                                    appointmentId,
                                    dentistId,
                                    "COMPLETED"
                            );

                    redirectToDetails(
                            request,
                            response,
                            appointmentId,
                            "success=treatment"
                    );

                } else {

                    redirectToDetails(
                            request,
                            response,
                            appointmentId,
                            "error=treatment"
                    );
                }

                return;
            }

            // =================================================
            // CANCEL APPOINTMENT
            // =================================================

            if ("cancel".equalsIgnoreCase(action)) {

                boolean cancelled =
                        appointmentService
                                .cancelAppointment(
                                        appointmentId
                                );

                if (cancelled) {

                    redirectToAppointments(
                            request,
                            response,
                            "success=cancelled"
                    );

                } else {

                    redirectToDetails(
                            request,
                            response,
                            appointmentId,
                            "error=cancel"
                    );
                }

                return;
            }

            redirectToDetails(
                    request,
                    response,
                    appointmentId,
                    "error=invalid"
            );

        } catch (NumberFormatException e) {

            e.printStackTrace();

            redirectToAppointments(
                    request,
                    response,
                    "error=invalid"
            );

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            redirectToDetails(
                    request,
                    response,
                    request.getParameter("appointmentId"),
                    "error=invalid"
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectToAppointments(
                    request,
                    response,
                    "error=server"
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

                if (dentist.getName() != null
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

    // =========================================================
    // SAFE STRING
    // =========================================================

    private String safeValue(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    // =========================================================
    // REDIRECT
    // =========================================================

    private void redirectToAppointments(
            HttpServletRequest request,
            HttpServletResponse response,
            String query)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/dentist/appointments?"
                        + query
        );
    }

    private void redirectToDetails(
            HttpServletRequest request,
            HttpServletResponse response,
            int appointmentId,
            String query)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/dentist/appointment-details"
                        + "?appointmentId="
                        + appointmentId
                        + "&"
                        + query
        );
    }

    private void redirectToDetails(
            HttpServletRequest request,
            HttpServletResponse response,
            String appointmentId,
            String query)
            throws IOException {

        if (appointmentId == null
                || appointmentId.isBlank()) {

            redirectToAppointments(
                    request,
                    response,
                    query
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/dentist/appointment-details"
                        + "?appointmentId="
                        + appointmentId
                        + "&"
                        + query
        );
    }
}