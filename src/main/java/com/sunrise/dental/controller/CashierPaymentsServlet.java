package com.sunrise.dental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.model.Payment;
import com.sunrise.dental.service.PaymentService;

@WebServlet("/cashier/payments")
public class CashierPaymentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PaymentService paymentService;

    @Override
    public void init() {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String staffName = (String) session.getAttribute("staffName");
        if (staffName == null || staffName.isBlank()) {
            staffName = "Cashier";
        }
        request.setAttribute("staffName", staffName);

        String search = request.getParameter("search");
        List<Payment> payments = paymentService.getAllPayments();

        if (search != null && !search.trim().isEmpty()) {
            String query = search.trim().toLowerCase();
            payments = payments.stream().filter(p -> {
                boolean matchInvoice = p.getInvoiceNumber() != null && p.getInvoiceNumber().toLowerCase().contains(query);
                boolean matchApp = p.getAppointmentNumber() != null && p.getAppointmentNumber().toLowerCase().contains(query);
                boolean matchPatient = p.getPatientName() != null && p.getPatientName().toLowerCase().contains(query);
                boolean matchDentist = p.getDentistName() != null && p.getDentistName().toLowerCase().contains(query);
                return matchInvoice || matchApp || matchPatient || matchDentist;
            }).collect(Collectors.toList());
        }

        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (Payment p : payments) {
            if ("PAID".equalsIgnoreCase(p.getPaymentStatus()) && p.getTotalAmount() != null) {
                totalRevenue = totalRevenue.add(p.getTotalAmount());
            }
        }

        request.setAttribute("payments", payments);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("searchQuery", search != null ? search.trim() : "");

        request.getRequestDispatcher("/cashier/payments.jsp").forward(request, response);
    }
}
