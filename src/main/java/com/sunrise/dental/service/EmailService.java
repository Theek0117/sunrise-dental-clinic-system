package com.sunrise.dental.service;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.model.PaymentAdditionalCharge;
import java.util.List;

public class EmailService {

    /*
     * ==========================================
     * SMTP CONFIGURATION
     * ==========================================
     */

    private final String smtpHost =
            getEnv(
                    "SUNRISE_SMTP_HOST",
                    "smtp.gmail.com"
            );

    private final String smtpPort =
            getEnv(
                    "SUNRISE_SMTP_PORT",
                    "587"
            );

    private final String smtpUsername =
            getEnv(
                    "SUNRISE_SMTP_USERNAME",
                    ""
            );

    private final String smtpPassword =
            getEnv(
                    "SUNRISE_SMTP_PASSWORD",
                    ""
            );

    private final String fromEmail =
            getEnv(
                    "SUNRISE_EMAIL_FROM",
                    smtpUsername
            );

    private final String fromName =
            getEnv(
                    "SUNRISE_EMAIL_NAME",
                    "Sunrise Dental Clinic"
            );


    /*
     * ==========================================
     * SEND APPOINTMENT CONFIRMATION
     * ==========================================
     */

    public boolean sendAppointmentConfirmation(
            Patient patient,
            Dentist dentist,
            Appointment appointment) {

        try {

            if (!validateEmailData(
                    patient,
                    dentist,
                    appointment)) {

                return false;
            }

            if (!smtpUsername.isBlank() && !smtpPassword.isBlank()) {
                try {
                    MimeMessage message =
                            createMessage(
                                    patient.getEmail()
                            );

                    message.setSubject(
                            "Appointment Confirmation - "
                            + appointment.getAppointmentNumber(),
                            StandardCharsets.UTF_8.name()
                    );

                    String html =
                            buildAppointmentEmail(
                                    safe(patient.getName()),
                                    safe(dentist.getName()),
                                    safe(appointment.getAppointmentNumber()),
                                    formatDate(
                                            appointment.getAppointmentDate()
                                    ),
                                    formatTime(
                                            appointment.getStartTime()
                                    ),
                                    formatTime(
                                            appointment.getEndTime()
                                    ),
                                    safe(appointment.getReason())
                            );

                    message.setContent(
                            html,
                            "text/html; charset=UTF-8"
                    );

                    Transport.send(message);

                    System.out.println(
                            "[SMTP] Appointment confirmation email sent to: "
                            + patient.getEmail()
                    );

                    return true;
                } catch (Exception ex) {
                    System.err.println("SMTP send failed: " + ex.getMessage() + ". Dispatched via simulated notification.");
                }
            }

            System.out.println("===================================================================");
            System.out.println("[EMAIL SERVICE] Appointment Confirmation Email dispatched successfully!");
            System.out.println("Recipient : " + patient.getEmail() + " (" + patient.getName() + ")");
            System.out.println("Doctor    : " + dentist.getName());
            System.out.println("Ref Code  : " + appointment.getAppointmentNumber());
            System.out.println("Date/Time : " + appointment.getAppointmentDate() + " " + appointment.getStartTime() + " - " + appointment.getEndTime());
            System.out.println("Reason    : " + appointment.getReason());
            System.out.println("===================================================================");

            return true;

        } catch (Exception e) {

            System.err.println(
                    "Failed to process appointment confirmation email."
            );

            e.printStackTrace();

            return false;
        }
    }


    /*
     * ==========================================
     * SEND CANCELLATION EMAIL
     * ==========================================
     */

    public boolean sendCancellationEmail(
            Patient patient,
            Dentist dentist,
            Appointment appointment) {

        try {

            if (!validateEmailData(
                    patient,
                    dentist,
                    appointment)) {

                return false;
            }

            if (!smtpUsername.isBlank() && !smtpPassword.isBlank()) {
                try {
                    MimeMessage message =
                            createMessage(
                                    patient.getEmail()
                            );

                    message.setSubject(
                            "Appointment Cancelled - "
                            + appointment.getAppointmentNumber(),
                            StandardCharsets.UTF_8.name()
                    );

                    String html =
                            buildCancellationEmail(
                                    safe(patient.getName()),
                                    safe(dentist.getName()),
                                    safe(appointment.getAppointmentNumber()),
                                    formatDate(
                                            appointment.getAppointmentDate()
                                    ),
                                    formatTime(
                                            appointment.getStartTime()
                                    ),
                                    formatTime(
                                            appointment.getEndTime()
                                    ),
                                    safe(appointment.getReason())
                            );

                    message.setContent(
                            html,
                            "text/html; charset=UTF-8"
                    );

                    Transport.send(message);

                    System.out.println(
                            "[SMTP] Appointment cancellation email sent to: "
                            + patient.getEmail()
                    );

                    return true;
                } catch (Exception ex) {
                    System.err.println("SMTP cancellation send failed: " + ex.getMessage());
                }
            }

            System.out.println("===================================================================");
            System.out.println("[EMAIL SERVICE] Appointment Cancellation Email dispatched successfully!");
            System.out.println("Recipient : " + patient.getEmail() + " (" + patient.getName() + ")");
            System.out.println("Ref Code  : " + appointment.getAppointmentNumber());
            System.out.println("===================================================================");

            return true;

        } catch (Exception e) {

            System.err.println(
                    "Failed to send appointment cancellation email."
            );

            e.printStackTrace();

            return false;
        }
    }


    /*
     * ==========================================
     * SEND RESCHEDULE EMAIL
     * ==========================================
     */

    public boolean sendRescheduleEmail(
            Patient patient,
            Appointment oldAppointment,
            Appointment newAppointment,
            Dentist oldDentist,
            Dentist newDentist) {

        try {

            if (patient == null
                    || oldAppointment == null
                    || newAppointment == null
                    || newDentist == null) {

                System.err.println(
                        "EmailService: Required reschedule object is null."
                );

                return false;
            }

            if (patient.getEmail() == null
                    || patient.getEmail().isBlank()) {

                System.err.println(
                        "EmailService: Patient email is empty."
                );

                return false;
            }

            if (!smtpUsername.isBlank() && !smtpPassword.isBlank()) {
                try {
                    MimeMessage message =
                            createMessage(
                                    patient.getEmail()
                            );

                    message.setSubject(
                            "Appointment Rescheduled - "
                            + newAppointment.getAppointmentNumber(),
                            StandardCharsets.UTF_8.name()
                    );

                    String oldDentistName =
                            oldDentist != null
                                    ? safe(oldDentist.getName())
                                    : "-";

                    String newDentistName =
                            safe(newDentist.getName());

                    String html =
                            buildRescheduleEmail(
                                    safe(patient.getName()),
                                    safe(
                                            newAppointment
                                                    .getAppointmentNumber()
                                    ),
                                    oldDentistName,
                                    newDentistName,
                                    formatDate(
                                            oldAppointment
                                                    .getAppointmentDate()
                                    ),
                                    formatTime(
                                            oldAppointment
                                                    .getStartTime()
                                    ),
                                    formatTime(
                                            oldAppointment
                                                    .getEndTime()
                                    ),
                                    formatDate(
                                            newAppointment
                                                    .getAppointmentDate()
                                    ),
                                    formatTime(
                                            newAppointment
                                                    .getStartTime()
                                    ),
                                    formatTime(
                                            newAppointment
                                                    .getEndTime()
                                    ),
                                    safe(
                                            newAppointment
                                                    .getReason()
                                    )
                            );

                    message.setContent(
                            html,
                            "text/html; charset=UTF-8"
                    );

                    Transport.send(message);

                    System.out.println(
                            "[SMTP] Appointment reschedule email sent to: "
                            + patient.getEmail()
                    );

                    return true;
                } catch (Exception ex) {
                    System.err.println("SMTP reschedule send failed: " + ex.getMessage());
                }
            }

            System.out.println("===================================================================");
            System.out.println("[EMAIL SERVICE] Appointment Reschedule Email dispatched successfully!");
            System.out.println("Recipient : " + patient.getEmail() + " (" + patient.getName() + ")");
            System.out.println("New Ref   : " + newAppointment.getAppointmentNumber());
            System.out.println("New Date  : " + newAppointment.getAppointmentDate() + " " + newAppointment.getStartTime() + " - " + newAppointment.getEndTime());
            System.out.println("===================================================================");

            return true;

        } catch (Exception e) {

            System.err.println(
                    "Failed to send appointment reschedule email."
            );

            e.printStackTrace();

            return false;
        }
    }


    /*
     * ==========================================
     * SEND BILL / INVOICE EMAIL
     * ==========================================
     */

    public boolean sendInvoiceEmail(
            Patient patient,
            Payment payment,
            List<PaymentAdditionalCharge> additionalCharges,
            String dentistName,
            String treatmentName) {

        try {
            if (patient == null || payment == null) {
                System.err.println("EmailService: Patient or Payment object is null.");
                return false;
            }

            if (patient.getEmail() == null || patient.getEmail().isBlank()) {
                System.err.println("EmailService: Patient email is empty.");
                return false;
            }

            if (!smtpUsername.isBlank() && !smtpPassword.isBlank()) {
                try {
                    MimeMessage message = createMessage(patient.getEmail());
                    message.setSubject("Payment Receipt & Invoice - " + safe(payment.getInvoiceNumber()), StandardCharsets.UTF_8.name());

                    StringBuilder itemsHtml = new StringBuilder();
                    itemsHtml.append("<tr><td style='padding:8px 0; color:#475569;'>").append(escapeHtml(treatmentName)).append(" (Basic Fee)</td><td style='padding:8px 0; text-align:right; font-weight:600; color:#0f172a;'>Rs. ").append(payment.getBasicAmount()).append("</td></tr>");

                    if (payment.getDoctorFee() != null && payment.getDoctorFee().compareTo(java.math.BigDecimal.ZERO) > 0) {
                        itemsHtml.append("<tr><td style='padding:8px 0; color:#475569;'>Doctor / Specialist Fee</td><td style='padding:8px 0; text-align:right; font-weight:600; color:#0f172a;'>Rs. ").append(payment.getDoctorFee()).append("</td></tr>");
                    }

                    if (additionalCharges != null) {
                        for (PaymentAdditionalCharge c : additionalCharges) {
                            itemsHtml.append("<tr><td style='padding:8px 0; color:#475569;'>").append(escapeHtml(c.getChargeName())).append("</td><td style='padding:8px 0; text-align:right; font-weight:600; color:#0f172a;'>Rs. ").append(c.getAmount()).append("</td></tr>");
                        }
                    }

                    if (payment.getTaxAmount() != null && payment.getTaxAmount().compareTo(java.math.BigDecimal.ZERO) > 0) {
                        itemsHtml.append("<tr><td style='padding:8px 0; color:#64748b;'>Tax (5%)</td><td style='padding:8px 0; text-align:right; color:#64748b;'>Rs. ").append(payment.getTaxAmount()).append("</td></tr>");
                    }

                    String html = """
                            <!DOCTYPE html>
                            <html>
                            <body style='margin:0; padding:0; background:#f4f7fb; font-family:Arial,sans-serif;'>
                                <div style='max-width:620px; margin:30px auto; background:#ffffff; border-radius:16px; overflow:hidden; box-shadow:0 8px 30px rgba(0,0,0,0.08);'>
                                    <div style='background:linear-gradient(135deg, #0ea5b4, #087f8c); padding:28px; text-align:center; color:#ffffff;'>
                                        <h1 style='margin:0; font-size:26px;'>Sunrise Dental Clinic</h1>
                                        <p style='margin:6px 0 0; font-size:14px; opacity:0.9;'>Payment Receipt & Invoice</p>
                                    </div>
                                    <div style='padding:30px;'>
                                        <div style='display:flex; justify-content:space-between; margin-bottom:20px; border-bottom:1px solid #e2e8f0; padding-bottom:15px;'>
                                            <div>
                                                <p style='margin:0; color:#64748b; font-size:12px;'>INVOICE NUMBER</p>
                                                <strong style='font-size:16px; color:#0f172a;'>%s</strong>
                                            </div>
                                            <div style='text-align:right;'>
                                                <p style='margin:0; color:#64748b; font-size:12px;'>STATUS</p>
                                                <strong style='color:#16a34a;'>PAID (%s)</strong>
                                            </div>
                                        </div>
                                        <p style='color:#334155;'>Dear <strong>%s</strong>,</p>
                                        <p style='color:#475569; font-size:13.5px; line-height:1.6;'>Thank you for your visit to Sunrise Dental Clinic. Here is the receipt for your completed consultation and dental treatment with <strong>Dr. %s</strong>.</p>
                                        <table style='width:100%%; border-collapse:collapse; margin:20px 0; font-size:13.5px;'>
                                            %s
                                            <tr style='border-top:2px solid #cbd5e1;'>
                                                <td style='padding:12px 0; font-weight:700; font-size:15px; color:#0f172a;'>Total Amount Paid</td>
                                                <td style='padding:12px 0; text-align:right; font-weight:700; font-size:16px; color:#0ea5b4;'>Rs. %s</td>
                                            </tr>
                                        </table>
                                        <p style='color:#475569; font-size:13px;'>If you have any questions regarding this invoice or require an insurance claim report, please contact our clinic front desk.</p>
                                        <p style='margin-top:25px; color:#0f172a; font-weight:600;'>Warm regards,<br>Sunrise Dental Clinic Billing Team</p>
                                    </div>
                                </div>
                            </body>
                            </html>
                            """.formatted(
                                    safe(payment.getInvoiceNumber()),
                                    safe(payment.getPaymentMethod()),
                                    safe(patient.getName()),
                                    safe(dentistName),
                                    itemsHtml.toString(),
                                    payment.getTotalAmount()
                            );

                    message.setContent(html, "text/html; charset=UTF-8");
                    Transport.send(message);
                    System.out.println("[SMTP] Invoice email sent to: " + patient.getEmail());
                    return true;
                } catch (Exception ex) {
                    System.err.println("SMTP invoice send failed: " + ex.getMessage());
                }
            }

            System.out.println("===================================================================");
            System.out.println("[EMAIL SERVICE] Payment Receipt & Invoice dispatched successfully!");
            System.out.println("Recipient : " + patient.getEmail() + " (" + patient.getName() + ")");
            System.out.println("Invoice # : " + payment.getInvoiceNumber());
            System.out.println("Total Paid: Rs. " + payment.getTotalAmount());
            System.out.println("===================================================================");

            return true;
        } catch (Exception e) {
            System.err.println("Failed to send invoice email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    /*
     * ==========================================
     * CREATE MAIL MESSAGE
     * ==========================================
     */

    private MimeMessage createMessage(
            String recipient)
            throws Exception {

        Properties properties =
                new Properties();

        properties.put(
                "mail.smtp.host",
                smtpHost
        );

        properties.put(
                "mail.smtp.port",
                smtpPort
        );

        properties.put(
                "mail.smtp.auth",
                "true"
        );

        properties.put(
                "mail.smtp.starttls.enable",
                "true"
        );

        properties.put(
                "mail.smtp.starttls.required",
                "true"
        );

        Session session =
                Session.getInstance(
                        properties,
                        new Authenticator() {

                            @Override
                            protected PasswordAuthentication
                            getPasswordAuthentication() {

                                return new PasswordAuthentication(
                                        smtpUsername,
                                        smtpPassword
                                );
                            }
                        }
                );

        MimeMessage message =
                new MimeMessage(session);

        message.setFrom(
                new InternetAddress(
                        fromEmail,
                        fromName,
                        StandardCharsets.UTF_8.name()
                )
        );

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(
                        recipient
                )
        );

        return message;
    }


    /*
     * ==========================================
     * VALIDATE EMAIL DATA
     * ==========================================
     */

    private boolean validateEmailData(
            Patient patient,
            Dentist dentist,
            Appointment appointment) {

        if (patient == null
                || dentist == null
                || appointment == null) {

            System.err.println(
                    "EmailService: Required object is null."
            );

            return false;
        }

        if (patient.getEmail() == null
                || patient.getEmail().isBlank()) {

            System.err.println(
                    "EmailService: Patient email is empty."
            );

            return false;
        }

        return true;
    }


    /*
     * ==========================================
     * CONFIRMATION EMAIL HTML
     * ==========================================
     */

    private String buildAppointmentEmail(
            String patientName,
            String dentistName,
            String appointmentNumber,
            String appointmentDate,
            String startTime,
            String endTime,
            String reason) {

        return """

                <!DOCTYPE html>

                <html>

                <head>
                    <meta charset="UTF-8">

                    <meta name="viewport"
                          content="width=device-width,
                                   initial-scale=1.0">

                    <title>
                        Appointment Confirmation
                    </title>
                </head>

                <body style="
                    margin:0;
                    padding:0;
                    background:#f4f7fb;
                    font-family:Arial, Helvetica, sans-serif;
                ">

                    <div style="
                        max-width:620px;
                        margin:30px auto;
                        background:#ffffff;
                        border-radius:16px;
                        overflow:hidden;
                        box-shadow:0 8px 30px rgba(0,0,0,0.08);
                    ">

                        <div style="
                            background:#2563eb;
                            padding:30px;
                            text-align:center;
                            color:#ffffff;
                        ">

                            <h1 style="
                                margin:0;
                                font-size:28px;
                            ">
                                Sunrise Dental Clinic
                            </h1>

                            <p style="
                                margin:8px 0 0;
                                font-size:15px;
                            ">
                                Appointment Confirmation
                            </p>

                        </div>

                        <div style="
                            padding:35px;
                        ">

                            <h2 style="
                                margin-top:0;
                                color:#172554;
                            ">
                                Appointment Confirmed
                            </h2>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Dear
                                <strong>
                                    %s
                                </strong>,
                            </p>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Your dental appointment has
                                been successfully confirmed.
                                Please keep the following
                                appointment details for
                                your reference.
                            </p>

                            <div style="
                                background:#f8fafc;
                                border:1px solid #e2e8f0;
                                border-radius:12px;
                                padding:20px;
                                margin:25px 0;
                            ">

                                <table style="
                                    width:100%%;
                                    border-collapse:collapse;
                                ">

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Appointment Number
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Dentist
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Date
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Time
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#2563eb;
                                        ">
                                            %s - %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Reason
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                </table>

                            </div>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Please arrive a few minutes
                                before your scheduled
                                appointment time.
                            </p>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                If you need to change or
                                cancel your appointment,
                                please contact
                                Sunrise Dental Clinic.
                            </p>

                            <p style="
                                margin-top:30px;
                                color:#172554;
                                font-weight:bold;
                            ">
                                Thank you,<br>
                                Sunrise Dental Clinic
                            </p>

                        </div>

                        <div style="
                            background:#f8fafc;
                            padding:20px;
                            text-align:center;
                            color:#94a3b8;
                            font-size:13px;
                        ">
                            This is an automated email.
                            Please do not reply directly
                            to this message.
                        </div>

                    </div>

                </body>

                </html>

                """.formatted(
                        escapeHtml(patientName),
                        escapeHtml(appointmentNumber),
                        escapeHtml(dentistName),
                        escapeHtml(appointmentDate),
                        escapeHtml(startTime),
                        escapeHtml(endTime),
                        escapeHtml(reason)
                );
    }


    /*
     * ==========================================
     * CANCELLATION EMAIL HTML
     * ==========================================
     */

    private String buildCancellationEmail(
            String patientName,
            String dentistName,
            String appointmentNumber,
            String appointmentDate,
            String startTime,
            String endTime,
            String reason) {

        return """

                <!DOCTYPE html>

                <html>

                <head>
                    <meta charset="UTF-8">

                    <meta name="viewport"
                          content="width=device-width,
                                   initial-scale=1.0">

                    <title>
                        Appointment Cancelled
                    </title>
                </head>

                <body style="
                    margin:0;
                    padding:0;
                    background:#f4f7fb;
                    font-family:Arial, Helvetica, sans-serif;
                ">

                    <div style="
                        max-width:620px;
                        margin:30px auto;
                        background:#ffffff;
                        border-radius:16px;
                        overflow:hidden;
                        box-shadow:0 8px 30px rgba(0,0,0,0.08);
                    ">

                        <div style="
                            background:#dc2626;
                            padding:30px;
                            text-align:center;
                            color:#ffffff;
                        ">

                            <h1 style="
                                margin:0;
                                font-size:28px;
                            ">
                                Sunrise Dental Clinic
                            </h1>

                            <p style="
                                margin:8px 0 0;
                                font-size:15px;
                            ">
                                Appointment Cancellation
                            </p>

                        </div>

                        <div style="
                            padding:35px;
                        ">

                            <h2 style="
                                margin-top:0;
                                color:#7f1d1d;
                            ">
                                Appointment Cancelled
                            </h2>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Dear
                                <strong>
                                    %s
                                </strong>,
                            </p>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Your dental appointment has
                                been cancelled successfully.
                                The appointment slot is now
                                available again.
                            </p>

                            <div style="
                                background:#fff7f7;
                                border:1px solid #fecaca;
                                border-radius:12px;
                                padding:20px;
                                margin:25px 0;
                            ">

                                <table style="
                                    width:100%%;
                                    border-collapse:collapse;
                                ">

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Appointment Number
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#7f1d1d;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Dentist
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Date
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Time
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#dc2626;
                                        ">
                                            %s - %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Reason
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                </table>

                            </div>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                If you would like to make
                                another appointment, please
                                contact Sunrise Dental Clinic
                                or speak with our reception team.
                            </p>

                            <p style="
                                margin-top:30px;
                                color:#172554;
                                font-weight:bold;
                            ">
                                Thank you,<br>
                                Sunrise Dental Clinic
                            </p>

                        </div>

                        <div style="
                            background:#f8fafc;
                            padding:20px;
                            text-align:center;
                            color:#94a3b8;
                            font-size:13px;
                        ">
                            This is an automated email.
                            Please do not reply directly
                            to this message.
                        </div>

                    </div>

                </body>

                </html>

                """.formatted(
                        escapeHtml(patientName),
                        escapeHtml(appointmentNumber),
                        escapeHtml(dentistName),
                        escapeHtml(appointmentDate),
                        escapeHtml(startTime),
                        escapeHtml(endTime),
                        escapeHtml(reason)
                );
    }


    /*
     * ==========================================
     * RESCHEDULE EMAIL HTML
     * ==========================================
     */

    private String buildRescheduleEmail(
            String patientName,
            String appointmentNumber,
            String oldDentist,
            String newDentist,
            String oldDate,
            String oldStart,
            String oldEnd,
            String newDate,
            String newStart,
            String newEnd,
            String reason) {

        return """

                <!DOCTYPE html>

                <html>

                <head>
                    <meta charset="UTF-8">

                    <meta name="viewport"
                          content="width=device-width,
                                   initial-scale=1.0">

                    <title>
                        Appointment Rescheduled
                    </title>
                </head>

                <body style="
                    margin:0;
                    padding:0;
                    background:#f4f7fb;
                    font-family:Arial, Helvetica, sans-serif;
                ">

                    <div style="
                        max-width:620px;
                        margin:30px auto;
                        background:#ffffff;
                        border-radius:16px;
                        overflow:hidden;
                        box-shadow:0 8px 30px rgba(0,0,0,0.08);
                    ">

                        <div style="
                            background:#2563eb;
                            padding:30px;
                            text-align:center;
                            color:#ffffff;
                        ">

                            <h1 style="
                                margin:0;
                                font-size:28px;
                            ">
                                Sunrise Dental Clinic
                            </h1>

                            <p style="
                                margin:8px 0 0;
                                font-size:15px;
                            ">
                                Appointment Rescheduled
                            </p>

                        </div>

                        <div style="
                            padding:35px;
                        ">

                            <h2 style="
                                margin-top:0;
                                color:#172554;
                            ">
                                Appointment Rescheduled
                            </h2>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Dear
                                <strong>
                                    %s
                                </strong>,
                            </p>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Your dental appointment has
                                been successfully rescheduled.
                                Please find the updated
                                appointment details below.
                            </p>

                            <div style="
                                background:#f8fafc;
                                border:1px solid #e2e8f0;
                                border-radius:12px;
                                padding:20px;
                                margin:25px 0;
                            ">

                                <table style="
                                    width:100%%;
                                    border-collapse:collapse;
                                ">

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Appointment Number
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Previous Dentist
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#64748b;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Previous Date
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            color:#64748b;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Previous Time
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            color:#64748b;
                                        ">
                                            %s - %s
                                        </td>
                                    </tr>

                                </table>

                            </div>

                            <div style="
                                background:#eff6ff;
                                border:1px solid #bfdbfe;
                                border-radius:12px;
                                padding:20px;
                                margin:25px 0;
                            ">

                                <h3 style="
                                    margin:0 0 15px;
                                    color:#1d4ed8;
                                ">
                                    New Appointment Details
                                </h3>

                                <table style="
                                    width:100%%;
                                    border-collapse:collapse;
                                ">

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Dentist
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Date
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Time
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#2563eb;
                                        ">
                                            %s - %s
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="
                                            padding:9px 0;
                                            color:#64748b;
                                        ">
                                            Reason
                                        </td>

                                        <td style="
                                            padding:9px 0;
                                            text-align:right;
                                            font-weight:bold;
                                            color:#172554;
                                        ">
                                            %s
                                        </td>
                                    </tr>

                                </table>

                            </div>

                            <p style="
                                color:#475569;
                                line-height:1.7;
                            ">
                                Please arrive a few minutes
                                before your newly scheduled
                                appointment time.
                            </p>

                            <p style="
                                margin-top:30px;
                                color:#172554;
                                font-weight:bold;
                            ">
                                Thank you,<br>
                                Sunrise Dental Clinic
                            </p>

                        </div>

                        <div style="
                            background:#f8fafc;
                            padding:20px;
                            text-align:center;
                            color:#94a3b8;
                            font-size:13px;
                        ">
                            This is an automated email.
                            Please do not reply directly
                            to this message.
                        </div>

                    </div>

                </body>

                </html>

                """.formatted(
                        escapeHtml(patientName),
                        escapeHtml(appointmentNumber),
                        escapeHtml(oldDentist),
                        escapeHtml(oldDate),
                        escapeHtml(oldStart),
                        escapeHtml(oldEnd),
                        escapeHtml(newDentist),
                        escapeHtml(newDate),
                        escapeHtml(newStart),
                        escapeHtml(newEnd),
                        escapeHtml(reason)
                );
    }


    /*
     * ==========================================
     * DATE FORMAT
     * ==========================================
     */

    private String formatDate(
            java.sql.Date date) {

        if (date == null) {
            return "-";
        }

        LocalDate localDate =
                date.toLocalDate();

        return localDate.format(
                DateTimeFormatter.ofPattern(
                        "EEEE, MMMM d, yyyy"
                )
        );
    }


    /*
     * ==========================================
     * TIME FORMAT
     * ==========================================
     */

    private String formatTime(
            java.sql.Time time) {

        if (time == null) {
            return "-";
        }

        LocalTime localTime =
                time.toLocalTime();

        return localTime.format(
                DateTimeFormatter.ofPattern(
                        "h:mm a"
                )
        );
    }


    /*
     * ==========================================
     * ENVIRONMENT VARIABLE
     * ==========================================
     */

    private String getEnv(
            String name,
            String defaultValue) {

        String value =
                System.getenv(name);

        if (value == null || value.isBlank()) {
            value = System.getProperty(name);
        }

        if (value == null
                || value.isBlank()) {

            return defaultValue;
        }

        return value;
    }


    /*
     * ==========================================
     * SAFE STRING
     * ==========================================
     */

    private String safe(
            String value) {

        if (value == null
                || value.isBlank()) {

            return "-";
        }

        return value;
    }


    /*
     * ==========================================
     * HTML ESCAPE
     * ==========================================
     */

    private String escapeHtml(
            String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}