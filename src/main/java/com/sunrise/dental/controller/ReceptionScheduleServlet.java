package com.sunrise.dental.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.service.AppointmentService;

@WebServlet("/reception/schedule")
public class ReceptionScheduleServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentService appointmentService;

    @Override
    public void init() {

        appointmentService =
                new AppointmentService();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            LocalDate today =
                    LocalDate.now();

            Date todayDate =
                    Date.valueOf(today);


            List<Appointment> allAppointments =
                    appointmentService
                            .getAllAppointments();


            List<Appointment> todayAppointments =
                    new ArrayList<>();


            for (Appointment appointment
                    : allAppointments) {

                if (appointment.getAppointmentDate() != null
                        && appointment
                                .getAppointmentDate()
                                .equals(todayDate)) {

                    todayAppointments.add(
                            appointment
                    );
                }
            }


            todayAppointments.sort(
                    Comparator.comparing(
                            Appointment::getStartTime,
                            Comparator.nullsLast(
                                    Comparator.naturalOrder()
                            )
                    )
            );


            request.setAttribute(
                    "todayAppointments",
                    todayAppointments
            );

            request.setAttribute(
                    "todayDate",
                    todayDate
            );


            request.getRequestDispatcher(
                    "/reception/schedule.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load today's schedule."
            );

            request.getRequestDispatcher(
                    "/reception/schedule.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}