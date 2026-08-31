package com.sunrise.dental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.model.TreatmentType;
import com.sunrise.dental.service.TreatmentTypeService;

@WebServlet("/admin/treatments")
public class TreatmentManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TreatmentTypeService treatmentTypeService;


    @Override
    public void init() {

        treatmentTypeService =
                new TreatmentTypeService();
    }


    /*
     * ==========================================
     * GET
     * ==========================================
     *
     * Loads Treatment Management page.
     *
     * Supports:
     *
     * /admin/treatments
     * /admin/treatments?search=cleaning
     *
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * ==========================================
         * ADMIN SESSION CHECK
         * ==========================================
         */

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * ==========================================
         * ROLE CHECK
         * ==========================================
         */

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * ==========================================
         * SEARCH
         * ==========================================
         */

        String keyword =
                request.getParameter("search");


        List<TreatmentType> treatmentTypes;


        if (keyword == null
                || keyword.trim().isEmpty()) {

            treatmentTypes =
                    treatmentTypeService
                            .getAllTreatmentTypes();

        } else {

            /*
             * We currently load all records here
             * and filter them in the JSP.
             *
             * A dedicated DAO search method can
             * be added later if required.
             */

            treatmentTypes =
                    treatmentTypeService
                            .getAllTreatmentTypes();
        }


        /*
         * ==========================================
         * SEND DATA TO JSP
         * ==========================================
         */

        request.setAttribute(
                "treatmentTypes",
                treatmentTypes
        );

        request.setAttribute(
                "searchKeyword",
                keyword
        );


        /*
         * ==========================================
         * FORWARD
         * ==========================================
         */

        request.getRequestDispatcher(
                "/admin/treatmentManagement.jsp"
        ).forward(
                request,
                response
        );
    }


    /*
     * ==========================================
     * POST
     * ==========================================
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * ==========================================
         * ADMIN SESSION CHECK
         * ==========================================
         */

        if (session == null
                || session.getAttribute("staffId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * ==========================================
         * ROLE CHECK
         * ==========================================
         */

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * ==========================================
         * ACTION
         * ==========================================
         */

        String action =
                request.getParameter("action");


        if (action == null
                || action.isBlank()) {

            redirectToTreatmentPage(
                    request,
                    response
            );

            return;
        }


        /*
         * ==========================================
         * ADD
         * ==========================================
         */

        if ("add".equalsIgnoreCase(action)) {

            addTreatmentType(
                    request,
                    response
            );

            return;
        }


        /*
         * ==========================================
         * EDIT
         * ==========================================
         */

        if ("edit".equalsIgnoreCase(action)) {

            editTreatmentType(
                    request,
                    response
            );

            return;
        }


        /*
         * ==========================================
         * CHANGE STATUS
         * ==========================================
         */

        if ("changeStatus".equalsIgnoreCase(action)) {

            changeTreatmentStatus(
                    request,
                    response
            );

            return;
        }


        /*
         * ==========================================
         * UNKNOWN ACTION
         * ==========================================
         */

        redirectWithMessage(
                request,
                response,
                "error",
                "Invalid treatment management action."
        );
    }


    /*
     * ==========================================
     * ADD TREATMENT TYPE
     * ==========================================
     */

    private void addTreatmentType(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String treatmentName =
                request.getParameter("treatmentName");

        String basicCostParameter =
                request.getParameter("basicCost");


        /*
         * ==========================================
         * VALIDATE NAME
         * ==========================================
         */

        if (treatmentName == null
                || treatmentName.trim().isEmpty()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Treatment name is required."
            );

            return;
        }


        /*
         * ==========================================
         * VALIDATE COST
         * ==========================================
         */

        if (basicCostParameter == null
                || basicCostParameter.trim().isEmpty()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Basic cost is required."
            );

            return;
        }


        BigDecimal basicCost;

        try {

            basicCost =
                    new BigDecimal(
                            basicCostParameter.trim()
                    );

        } catch (NumberFormatException e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Please enter a valid treatment cost."
            );

            return;
        }


        if (basicCost.compareTo(
                BigDecimal.ZERO) < 0) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Treatment cost cannot be negative."
            );

            return;
        }


        /*
         * ==========================================
         * SAVE
         * ==========================================
         */

        boolean success =
                treatmentTypeService
                        .addTreatmentType(
                                treatmentName,
                                basicCost
                        );


        if (success) {

            redirectWithMessage(
                    request,
                    response,
                    "success",
                    "Treatment type added successfully."
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Unable to add treatment type. "
                    + "The treatment name may already exist."
            );
        }
    }


    /*
     * ==========================================
     * EDIT TREATMENT TYPE
     * ==========================================
     */

    private void editTreatmentType(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String idParameter =
                request.getParameter(
                        "treatmentTypeId"
                );

        String treatmentName =
                request.getParameter(
                        "treatmentName"
                );

        String basicCostParameter =
                request.getParameter(
                        "basicCost"
                );


        /*
         * ==========================================
         * VALIDATE ID
         * ==========================================
         */

        int treatmentTypeId;

        try {

            treatmentTypeId =
                    Integer.parseInt(
                            idParameter
                    );

        } catch (Exception e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Invalid treatment type ID."
            );

            return;
        }


        /*
         * ==========================================
         * VALIDATE NAME
         * ==========================================
         */

        if (treatmentName == null
                || treatmentName.trim().isEmpty()) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Treatment name is required."
            );

            return;
        }


        /*
         * ==========================================
         * VALIDATE COST
         * ==========================================
         */

        BigDecimal basicCost;

        try {

            basicCost =
                    new BigDecimal(
                            basicCostParameter.trim()
                    );

        } catch (Exception e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Please enter a valid treatment cost."
            );

            return;
        }


        if (basicCost.compareTo(
                BigDecimal.ZERO) < 0) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Treatment cost cannot be negative."
            );

            return;
        }


        /*
         * ==========================================
         * UPDATE
         * ==========================================
         */

        boolean success =
                treatmentTypeService
                        .updateTreatmentType(
                                treatmentTypeId,
                                treatmentName,
                                basicCost
                        );


        if (success) {

            redirectWithMessage(
                    request,
                    response,
                    "success",
                    "Treatment type updated successfully."
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Unable to update treatment type. "
                    + "The name may already be in use."
            );
        }
    }


    /*
     * ==========================================
     * CHANGE STATUS
     * ==========================================
     */

    private void changeTreatmentStatus(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String idParameter =
                request.getParameter(
                        "treatmentTypeId"
                );


        int treatmentTypeId;

        try {

            treatmentTypeId =
                    Integer.parseInt(
                            idParameter
                    );

        } catch (Exception e) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Invalid treatment type ID."
            );

            return;
        }


        /*
         * Get current status from database
         */

        TreatmentType treatmentType =
                treatmentTypeService
                        .getTreatmentTypeById(
                                treatmentTypeId
                        );


        if (treatmentType == null) {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Treatment type could not be found."
            );

            return;
        }


        /*
         * ==========================================
         * DETERMINE NEW STATUS
         * ==========================================
         */

        String currentStatus =
                treatmentType.getStatus();

        String newStatus;


        if ("ACTIVE".equalsIgnoreCase(
                currentStatus)) {

            newStatus = "INACTIVE";

        } else {

            newStatus = "ACTIVE";
        }


        /*
         * ==========================================
         * UPDATE STATUS
         * ==========================================
         */

        boolean success =
                treatmentTypeService.changeStatus(
                        treatmentTypeId,
                        newStatus
                );


        if (success) {

            String message;

            if ("ACTIVE".equals(newStatus)) {

                message =
                        "Treatment type activated successfully.";

            } else {

                message =
                        "Treatment type deactivated successfully.";
            }


            redirectWithMessage(
                    request,
                    response,
                    "success",
                    message
            );

        } else {

            redirectWithMessage(
                    request,
                    response,
                    "error",
                    "Unable to change treatment status."
            );
        }
    }


    /*
     * ==========================================
     * REDIRECT
     * ==========================================
     */

    private void redirectToTreatmentPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/treatments"
        );
    }


    /*
     * ==========================================
     * REDIRECT WITH MESSAGE
     * ==========================================
     */

    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String type,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/treatments?"
                + type
                + "="
                + URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }

}