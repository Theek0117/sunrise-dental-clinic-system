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

@WebServlet({"/reception/dentists", "/reception/view-dentists"})
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

        String ajaxParameter = request.getParameter("ajax");

        if ("true".equalsIgnoreCase(ajaxParameter)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < dentists.size(); i++) {
                Dentist d = dentists.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{");
                json.append("\"dentistId\":").append(d.getDentistId()).append(",");
                json.append("\"dentistNumber\":\"").append(escapeJson(d.getDentistNumber())).append("\",");
                json.append("\"name\":\"").append(escapeJson(d.getName())).append("\",");
                json.append("\"specialization\":\"").append(escapeJson(d.getSpecialization())).append("\",");
                json.append("\"roomNumber\":\"").append(escapeJson(d.getRoomNumber())).append("\"");
                json.append("}");
            }

            json.append("]");
            response.getWriter().write(json.toString());
            return;
        }

        request.setAttribute(
                "dentists",
                dentists
        );

        request.getRequestDispatcher(
                "/reception/dentists.jsp"
        ).forward(request, response);
    }

    private String escapeJson(String val) {
        if (val == null) {
            return "";
        }
        return val.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\r", "\\r")
                  .replace("\n", "\\n");
    }
}