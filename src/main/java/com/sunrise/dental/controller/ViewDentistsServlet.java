package com.sunrise.dental.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.service.DentistService;

@WebServlet("/reception/dentists")
public class ViewDentistsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DentistService dentistService;

    @Override
    public void init() {
        dentistService = new DentistService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Dentist> dentists =
                dentistService.getActiveDentists();

        request.setAttribute(
                "dentists",
                dentists
        );

        request.getRequestDispatcher(
                "/reception/dentists.jsp"
        ).forward(request, response);
    }
}