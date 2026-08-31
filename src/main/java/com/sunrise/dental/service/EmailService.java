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

public class EmailService {

    /*
     * ==========================================
     * SMTP CONFIGURATION
     * ==========================================
     *
     * These values are read from environment
     * variables.
     *
     * DO NOT put your real Gmail password
     * directly into this Java file.
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

            /*
             * Validate objects
             */

            if (patient == null
                    || dentist == null
                    || appointment == null) {

                System.err.println(
                        "EmailService: Required object is null."
                );

                return false;
            }


            /*
             * Validate patient email
             */

            if (patient.getEmail() == null
                    || patient.getEmail().isBlank()) {

                System.err.println(
                        "EmailService: Patient email is empty."
                );

                return false;
            }


            /*
             * Validate SMTP configuration
             */

            if (smtpUsername.isBlank()
                    || smtpPassword.isBlank()) {

                System.err.println(
                        "EmailService: SMTP username/password "
                        + "has not been configured."
                );

                return false;
            }


            /*
             * ======================================
             * SMTP PROPERTIES
             * ======================================
             */

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


            /*
             * ======================================
             * MAIL SESSION
             * ======================================
             */

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


            /*
             * ======================================
             * CREATE EMAIL
             * ======================================
             */

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
                            patient.getEmail()
                    )
            );


            message.setSubject(
                    "Appointment Confirmation - "
                    + appointment.getAppointmentNumber(),
                    StandardCharsets.UTF_8.name()
            );


            /*
             * ======================================
             * FORMAT DATE
             * ======================================
             */

            LocalDate appointmentDate =
                    appointment
                            .getAppointmentDate()
                            .toLocalDate();

            String formattedDate =
                    appointmentDate.format(
                            DateTimeFormatter.ofPattern(
                                    "EEEE, MMMM d, yyyy"
                            )
                    );


            /*
             * ======================================
             * FORMAT TIME
             * ======================================
             */

            LocalTime appointmentStart =
                    appointment
                            .getStartTime()
                            .toLocalTime();

            LocalTime appointmentEnd =
                    appointment
                            .getEndTime()
                            .toLocalTime();


            String formattedStart =
                    appointmentStart.format(
                            DateTimeFormatter.ofPattern(
                                    "h:mm a"
                            )
                    );


            String formattedEnd =
                    appointmentEnd.format(
                            DateTimeFormatter.ofPattern(
                                    "h:mm a"
                            )
                    );


            /*
             * ======================================
             * PATIENT / DENTIST INFORMATION
             * ======================================
             */

            String patientName =
                    safe(
                            patient.getName()
                    );

            String dentistName =
                    safe(
                            dentist.getName()
                    );

            String reason =
                    safe(
                            appointment.getReason()
                    );

            String appointmentNumber =
                    safe(
                            appointment.getAppointmentNumber()
                    );


            /*
             * ======================================
             * BUILD HTML EMAIL
             * ======================================
             */

            String html =
                    buildAppointmentEmail(
                            patientName,
                            dentistName,
                            appointmentNumber,
                            formattedDate,
                            formattedStart,
                            formattedEnd,
                            reason
                    );


            message.setContent(
                    html,
                    "text/html; charset=UTF-8"
            );


            /*
             * ======================================
             * SEND EMAIL
             * ======================================
             */

            Transport.send(message);


            System.out.println(
                    "Appointment confirmation email sent to: "
                    + patient.getEmail()
            );


            return true;

        } catch (Exception e) {

            System.err.println(
                    "Failed to send appointment confirmation email."
            );

            e.printStackTrace();

            return false;
        }
    }


    /*
     * ==========================================
     * BUILD HTML EMAIL
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
     * ENVIRONMENT VARIABLE
     * ==========================================
     */

    private String getEnv(
            String name,
            String defaultValue) {

        String value =
                System.getenv(name);

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

    private String safe(String value) {

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