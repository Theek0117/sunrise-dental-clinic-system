package com.sunrise.dental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.dao.AppointmentDAOImpl;
import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PatientDAOImpl;
import com.sunrise.dental.dao.PaymentDAO;
import com.sunrise.dental.dao.PaymentDAOImpl;
import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.model.TreatmentType;

@WebServlet("/admin/reports")
public class AdminReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;
    private PaymentDAO paymentDAO;
    private DentistDAO dentistDAO;
    private TreatmentTypeDAO treatmentTypeDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAOImpl();
        appointmentDAO = new AppointmentDAOImpl();
        paymentDAO = new PaymentDAOImpl();
        dentistDAO = new DentistDAOImpl();
        treatmentTypeDAO = new TreatmentTypeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String staffName = (String) session.getAttribute("staffName");
        if (staffName == null || staffName.isBlank()) {
            staffName = "Administrator";
        }
        request.setAttribute("staffName", staffName);

        // ==========================================
        // PARSE FILTERS
        // ==========================================
        String activeTab = request.getParameter("tab");
        if (activeTab == null || activeTab.isBlank()) {
            activeTab = "analytics";
        }
        request.setAttribute("activeTab", activeTab);

        String period = request.getParameter("period");
        if (period == null || period.isBlank()) {
            period = "all";
        }
        request.setAttribute("period", period);

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String dentistIdStr = request.getParameter("dentistId");
        String statusFilter = request.getParameter("status");

        int filterDentistId = 0;
        if (dentistIdStr != null && !dentistIdStr.isBlank()) {
            try {
                filterDentistId = Integer.parseInt(dentistIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }
        request.setAttribute("filterDentistId", filterDentistId);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter.trim() : "all");

        LocalDate today = LocalDate.now();
        LocalDate filterStart = null;
        LocalDate filterEnd = null;
        String periodLabel = "All Time";

        if ("today".equalsIgnoreCase(period)) {
            filterStart = today;
            filterEnd = today;
            periodLabel = "Today (" + today.toString() + ")";
        } else if ("this_month".equalsIgnoreCase(period)) {
            YearMonth ym = YearMonth.from(today);
            filterStart = ym.atDay(1);
            filterEnd = ym.atEndOfMonth();
            periodLabel = "This Month (" + ym.getMonth().name() + " " + ym.getYear() + ")";
        } else if ("this_year".equalsIgnoreCase(period)) {
            filterStart = LocalDate.of(today.getYear(), 1, 1);
            filterEnd = LocalDate.of(today.getYear(), 12, 31);
            periodLabel = "This Year (" + today.getYear() + ")";
        } else if ("custom".equalsIgnoreCase(period)) {
            if (startDateStr != null && !startDateStr.isBlank()) {
                try {
                    filterStart = LocalDate.parse(startDateStr.trim());
                } catch (Exception ignored) {}
            }
            if (endDateStr != null && !endDateStr.isBlank()) {
                try {
                    filterEnd = LocalDate.parse(endDateStr.trim());
                } catch (Exception ignored) {}
            }
            if (filterStart != null && filterEnd != null) {
                periodLabel = "Custom: " + filterStart + " to " + filterEnd;
            } else if (filterStart != null) {
                periodLabel = "From " + filterStart;
            } else if (filterEnd != null) {
                periodLabel = "Up to " + filterEnd;
            }
        }

        request.setAttribute("periodLabel", periodLabel);
        request.setAttribute("startDateStr", startDateStr != null ? startDateStr : (filterStart != null ? filterStart.toString() : ""));
        request.setAttribute("endDateStr", endDateStr != null ? endDateStr : (filterEnd != null ? filterEnd.toString() : ""));

        // ==========================================
        // LOAD RAW DATA
        // ==========================================
        List<Patient> allPatients = patientDAO.findAll();
        List<Appointment> allAppointments = appointmentDAO.findAll();
        List<Payment> allPayments = paymentDAO.findAll();
        List<Dentist> activeDentists = dentistDAO.findAllActive();
        List<TreatmentType> treatmentTypes = treatmentTypeDAO.findAll();

        Map<Integer, Patient> patientMap = new HashMap<>();
        for (Patient p : allPatients) {
            patientMap.put(p.getPatientId(), p);
        }

        Map<Integer, Dentist> dentistMap = new HashMap<>();
        for (Dentist d : activeDentists) {
            dentistMap.put(d.getDentistId(), d);
        }

        Map<Integer, TreatmentType> treatmentTypeMap = new HashMap<>();
        for (TreatmentType tt : treatmentTypes) {
            treatmentTypeMap.put(tt.getTreatmentTypeId(), tt);
        }

        Map<Integer, Appointment> appointmentMap = new HashMap<>();
        for (Appointment a : allAppointments) {
            appointmentMap.put(a.getAppointmentId(), a);
        }

        // ==========================================
        // APPLY FILTERS TO APPOINTMENTS
        // ==========================================
        List<Appointment> filteredAppointments = new ArrayList<>();
        int completedCount = 0;
        int confirmedCount = 0;
        int cancelledCount = 0;

        for (Appointment a : allAppointments) {
            LocalDate appDate = (a.getAppointmentDate() != null) ? a.getAppointmentDate().toLocalDate() : null;

            // Date filtering
            if (filterStart != null && (appDate == null || appDate.isBefore(filterStart))) {
                continue;
            }
            if (filterEnd != null && (appDate == null || appDate.isAfter(filterEnd))) {
                continue;
            }

            // Dentist filtering
            if (filterDentistId > 0 && a.getDentistId() != filterDentistId) {
                continue;
            }

            // Status filtering
            String status = a.getStatus() != null ? a.getStatus().toUpperCase() : "";
            if (statusFilter != null && !statusFilter.equalsIgnoreCase("all") && !statusFilter.isBlank()) {
                if (!status.equalsIgnoreCase(statusFilter.trim())) {
                    continue;
                }
            }

            filteredAppointments.add(a);

            if ("COMPLETED".equals(status)) {
                completedCount++;
            } else if ("CONFIRMED".equals(status)) {
                confirmedCount++;
            } else if ("CANCELLED".equals(status)) {
                cancelledCount++;
            }
        }

        // ==========================================
        // APPLY FILTERS TO PAYMENTS & FINANCIALS
        // ==========================================
        List<Payment> filteredPayments = new ArrayList<>();
        BigDecimal totalGrossRevenue = BigDecimal.ZERO;
        BigDecimal totalBasicRevenue = BigDecimal.ZERO;
        BigDecimal totalDoctorFees = BigDecimal.ZERO;
        BigDecimal totalTaxAmount = BigDecimal.ZERO;
        BigDecimal totalAdditionalCharges = BigDecimal.ZERO;

        Map<String, Integer> methodCount = new HashMap<>();
        Map<String, BigDecimal> methodAmount = new HashMap<>();
        methodCount.put("CASH", 0);
        methodCount.put("CARD", 0);
        methodCount.put("BANK_TRANSFER", 0);
        methodAmount.put("CASH", BigDecimal.ZERO);
        methodAmount.put("CARD", BigDecimal.ZERO);
        methodAmount.put("BANK_TRANSFER", BigDecimal.ZERO);

        Map<Integer, DoctorAnalytics> doctorStats = new HashMap<>();
        for (Dentist d : activeDentists) {
            doctorStats.put(d.getDentistId(), new DoctorAnalytics(d.getDentistId(), d.getName(), d.getSpecialization()));
        }

        Map<String, TreatmentAnalytics> treatmentStats = new HashMap<>();
        for (TreatmentType tt : treatmentTypes) {
            treatmentStats.put(tt.getTreatmentName(), new TreatmentAnalytics(tt.getTreatmentName(), tt.getBasicCost()));
        }

        for (Payment p : allPayments) {
            LocalDate payDate = null;
            if (p.getPaidAt() != null) {
                payDate = p.getPaidAt().toLocalDateTime().toLocalDate();
            } else if (p.getCreatedAt() != null) {
                payDate = p.getCreatedAt().toLocalDateTime().toLocalDate();
            }

            // Link appointment for dentist filter
            Appointment linkedApp = appointmentMap.get(p.getAppointmentId());
            int docId = (linkedApp != null) ? linkedApp.getDentistId() : 0;

            // Date filtering
            if (filterStart != null && (payDate == null || payDate.isBefore(filterStart))) {
                continue;
            }
            if (filterEnd != null && (payDate == null || payDate.isAfter(filterEnd))) {
                continue;
            }

            // Dentist filtering
            if (filterDentistId > 0 && docId != filterDentistId) {
                continue;
            }

            filteredPayments.add(p);

            if ("PAID".equalsIgnoreCase(p.getPaymentStatus())) {
                BigDecimal gross = p.getTotalAmount() != null ? p.getTotalAmount() : BigDecimal.ZERO;
                BigDecimal basic = p.getBasicAmount() != null ? p.getBasicAmount() : BigDecimal.ZERO;
                BigDecimal docFee = p.getDoctorFee() != null ? p.getDoctorFee() : BigDecimal.ZERO;
                BigDecimal tax = p.getTaxAmount() != null ? p.getTaxAmount() : BigDecimal.ZERO;
                BigDecimal addl = p.getAdditionalAmount() != null ? p.getAdditionalAmount() : BigDecimal.ZERO;

                totalGrossRevenue = totalGrossRevenue.add(gross);
                totalBasicRevenue = totalBasicRevenue.add(basic);
                totalDoctorFees = totalDoctorFees.add(docFee);
                totalTaxAmount = totalTaxAmount.add(tax);
                totalAdditionalCharges = totalAdditionalCharges.add(addl);

                String method = p.getPaymentMethod() != null ? p.getPaymentMethod().toUpperCase() : "CASH";
                methodCount.put(method, methodCount.getOrDefault(method, 0) + 1);
                methodAmount.put(method, methodAmount.getOrDefault(method, BigDecimal.ZERO).add(gross));

                DoctorAnalytics da = doctorStats.get(docId);
                if (da != null) {
                    da.totalDoctorFees = da.totalDoctorFees.add(docFee);
                    da.totalRevenueGenerated = da.totalRevenueGenerated.add(gross);
                }
            }
        }

        // Aggregate Appointments into Doctor and Treatment Analytics
        for (Appointment a : filteredAppointments) {
            String status = a.getStatus() != null ? a.getStatus().toUpperCase() : "";

            DoctorAnalytics da = doctorStats.get(a.getDentistId());
            if (da != null) {
                da.totalAppointments++;
                if ("COMPLETED".equals(status)) {
                    da.completedAppointments++;
                }
            }

            TreatmentType tt = treatmentTypeMap.get(a.getTreatmentTypeId());
            if (tt != null) {
                TreatmentAnalytics ta = treatmentStats.computeIfAbsent(tt.getTreatmentName(), k -> new TreatmentAnalytics(tt.getTreatmentName(), tt.getBasicCost()));
                ta.timesBooked++;
                if ("COMPLETED".equals(status)) {
                    ta.timesCompleted++;
                    if (tt.getBasicCost() != null) {
                        ta.totalRevenueGenerated = ta.totalRevenueGenerated.add(tt.getBasicCost());
                    }
                }
            }
        }

        // Calculate doctor contribution %
        for (DoctorAnalytics da : doctorStats.values()) {
            if (totalGrossRevenue.compareTo(BigDecimal.ZERO) > 0) {
                da.contributionPercentage = da.totalRevenueGenerated.multiply(new BigDecimal(100))
                        .divide(totalGrossRevenue, 1, RoundingMode.HALF_UP).doubleValue();
            }
        }

        request.setAttribute("patients", allPatients);
        request.setAttribute("appointments", filteredAppointments);
        request.setAttribute("payments", filteredPayments);
        request.setAttribute("activeDentists", activeDentists);
        request.setAttribute("patientMap", patientMap);
        request.setAttribute("dentistMap", dentistMap);
        request.setAttribute("treatmentTypeMap", treatmentTypeMap);

        request.setAttribute("totalGrossRevenue", totalGrossRevenue);
        request.setAttribute("totalBasicRevenue", totalBasicRevenue);
        request.setAttribute("totalDoctorFees", totalDoctorFees);
        request.setAttribute("totalTaxAmount", totalTaxAmount);
        request.setAttribute("totalAdditionalCharges", totalAdditionalCharges);

        request.setAttribute("totalPatientsCount", allPatients.size());
        request.setAttribute("totalAppointmentsCount", filteredAppointments.size());
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("confirmedCount", confirmedCount);
        request.setAttribute("cancelledCount", cancelledCount);

        request.setAttribute("methodCount", methodCount);
        request.setAttribute("methodAmount", methodAmount);
        request.setAttribute("doctorAnalyticsList", new ArrayList<>(doctorStats.values()));
        request.setAttribute("treatmentAnalyticsList", new ArrayList<>(treatmentStats.values()));

        request.getRequestDispatcher("/admin/adminReports.jsp").forward(request, response);
    }

    public static class DoctorAnalytics {
        public int dentistId;
        public String dentistName;
        public String specialization;
        public int totalAppointments;
        public int completedAppointments;
        public BigDecimal totalDoctorFees = BigDecimal.ZERO;
        public BigDecimal totalRevenueGenerated = BigDecimal.ZERO;
        public double contributionPercentage = 0.0;

        public DoctorAnalytics(int dentistId, String dentistName, String specialization) {
            this.dentistId = dentistId;
            this.dentistName = dentistName;
            this.specialization = specialization != null ? specialization : "General Dentist";
        }
    }

    public static class TreatmentAnalytics {
        public String treatmentName;
        public BigDecimal baseCost;
        public int timesBooked;
        public int timesCompleted;
        public BigDecimal totalRevenueGenerated = BigDecimal.ZERO;

        public TreatmentAnalytics(String treatmentName, BigDecimal baseCost) {
            this.treatmentName = treatmentName;
            this.baseCost = baseCost != null ? baseCost : BigDecimal.ZERO;
        }
    }
}
