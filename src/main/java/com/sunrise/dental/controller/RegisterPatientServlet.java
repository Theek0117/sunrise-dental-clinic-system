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
         * Validate inputs.
         */
        if (name == null || name.trim().length() < 2) {
            request.setAttribute("error", "Patient name must be at least 2 characters long.");
            request.getRequestDispatcher("/reception/registerPatient.jsp").forward(request, response);
            return;
        }

        if (contactNumber == null || !contactNumber.trim().matches("^(?:0|94|\\+94)?[0-9]{9,10}$")) {
            request.setAttribute("error", "Please provide a valid 10-digit contact number (e.g. 07XXXXXXXX).");
            request.getRequestDispatcher("/reception/registerPatient.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            request.setAttribute("error", "Please provide a valid email address (e.g. patient@example.com).");
            request.getRequestDispatcher("/reception/registerPatient.jsp").forward(request, response);
            return;
        }

        if (address == null || address.trim().isBlank()) {
            request.setAttribute("error", "Residential address cannot be empty.");
            request.getRequestDispatcher("/reception/registerPatient.jsp").forward(request, response);
            return;
        }

        /*
         * Create Patient object.
         */
        Patient patient = new Patient();
        patient.setName(name.trim());
        if (dateOfBirth != null && !dateOfBirth.isBlank()) {
            patient.setDateOfBirth(dateOfBirth.trim());
        }
        patient.setAddress(address.trim());
        patient.setContactNumber(contactNumber.trim());
        patient.setEmail(email.trim());

        /*
         * Register patient.
         */
        boolean registered = patientService.registerPatient(patient);

        if (registered) {
            request.setAttribute("success", "Patient registered successfully.");
            request.setAttribute("patientNumber", patient.getPatientNumber());
        } else {
            request.setAttribute("error", "Unable to register patient. The contact number or email may already be registered.");
        }


        request.getRequestDispatcher(
                "/reception/registerPatient.jsp"
        ).forward(
                request,
                response
        );
    }
}