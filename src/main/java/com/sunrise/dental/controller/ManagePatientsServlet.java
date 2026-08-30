package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.PatientService;

@WebServlet("/reception/manage-patients")
public class ManagePatientsServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientService patientService;


    @Override
    public void init() {

        patientService =
                new PatientService();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword =
                request.getParameter("search");

        List<Patient> patients =
                patientService.searchPatients(
                        keyword
                );

        request.setAttribute(
                "patients",
                patients
        );

        /*
         * If an edit request exists,
         * load that patient.
         */

        String editId =
                request.getParameter("edit");

        if (editId != null) {

            try {

                int patientId =
                        Integer.parseInt(editId);

                Patient patient =
                        patientService.getPatientById(
                                patientId
                        );

                request.setAttribute(
                        "editPatient",
                        patient
                );

            } catch (NumberFormatException e) {

                request.setAttribute(
                        "error",
                        "Invalid patient ID."
                );
            }
        }


        request.getRequestDispatcher(
                "/reception/managePatients.jsp"
        ).forward(
                request,
                response
        );
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        String action =
                request.getParameter("action");


        if (!"update".equals(action)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/reception/manage-patients"
            );

            return;
        }


        try {

            int patientId =
                    Integer.parseInt(
                            request.getParameter(
                                    "patientId"
                            )
                    );


            String name =
                    request.getParameter("name");

            String address =
                    request.getParameter("address");

            String contactNumber =
                    request.getParameter(
                            "contactNumber"
                    );

            String email =
                    request.getParameter("email");

            String status =
                    request.getParameter("status");


            Patient patient =
                    new Patient();


            patient.setPatientId(
                    patientId
            );

            patient.setName(
                    name
            );

            patient.setAddress(
                    address
            );

            patient.setContactNumber(
                    contactNumber
            );

            patient.setEmail(
                    email
            );

            patient.setStatus(
                    status
            );


            boolean updated =
                    patientService.updatePatient(
                            patient
                    );


            if (updated) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/reception/manage-patients"
                        + "?success=updated"
                );

                return;

            } else {

                request.setAttribute(
                        "error",
                        "Unable to update patient. The email may already belong to another patient."
                );

                request.setAttribute(
                        "editPatient",
                        patient
                );
            }


        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Invalid patient ID."
            );
        }


        String keyword =
                request.getParameter("search");

        List<Patient> patients =
                patientService.searchPatients(
                        keyword
                );

        request.setAttribute(
                "patients",
                patients
        );


        request.getRequestDispatcher(
                "/reception/managePatients.jsp"
        ).forward(
                request,
                response
        );
    }
}