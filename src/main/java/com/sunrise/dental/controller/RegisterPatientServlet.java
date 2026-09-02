package com.sunrise.dental.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.PatientService;

@WebServlet("/reception/register-patient")
public class RegisterPatientServlet extends HttpServlet {

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

        request.getRequestDispatcher(
                "/reception/registerPatient.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


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

        String dateOfBirth =
                request.getParameter("dateOfBirth");

        /*
         * Clean email.
         */

        if (email != null) {

            email = email.trim();

            if (email.isEmpty()) {
                email = null;
            }
        }

        /*
         * Create Patient object.
         */

        Patient patient =
                new Patient();

        patient.setName(
                name != null
                        ? name.trim()
                        : ""
        );

        if (dateOfBirth != null && !dateOfBirth.isBlank()) {
            patient.setDateOfBirth(dateOfBirth.trim());
        }

        patient.setAddress(
                address != null
                        ? address.trim()
                        : ""
        );

        patient.setContactNumber(
                contactNumber != null
                        ? contactNumber.trim()
                        : ""
        );

        patient.setEmail(email);


        /*
         * Register patient.
         */

        boolean registered =
                patientService.registerPatient(
                        patient
                );


        if (registered) {

            request.setAttribute(
                    "success",
                    "Patient registered successfully."
            );

            request.setAttribute(
                    "patientNumber",
                    patient.getPatientNumber()
            );

        } else {

            request.setAttribute(
                    "error",
                    "Unable to register patient. The information may already exist or may be invalid."
            );
        }


        request.getRequestDispatcher(
                "/reception/registerPatient.jsp"
        ).forward(
                request,
                response
        );
    }
}