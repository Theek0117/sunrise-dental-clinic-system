package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.model.Patient;

@WebServlet("/dentist/patients")
public class PatientRecordsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {

        patientDAO = new PatientDAOImpl();

    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Patient> patients =
                patientDAO.findAll();

        request.setAttribute(
                "patients",
                patients
        );

        request.getRequestDispatcher(
                "/dentist/patientRecords.jsp"
        ).forward(
                request,
                response
        );
    }
}