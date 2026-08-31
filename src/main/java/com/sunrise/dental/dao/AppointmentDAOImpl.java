package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.util.DBConnection;

public class AppointmentDAOImpl implements AppointmentDAO {

    @Override
    public boolean save(Appointment appointment) {

        String sql = """
                INSERT INTO appointment
                (
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    appointment.getAppointmentNumber()
            );

            statement.setInt(
                    2,
                    appointment.getPatientId()
            );

            statement.setInt(
                    3,
                    appointment.getDentistId()
            );

            statement.setInt(
                    4,
                    appointment.getAvailabilityId()
            );

            statement.setDate(
                    5,
                    appointment.getAppointmentDate()
            );

            statement.setTime(
                    6,
                    appointment.getStartTime()
            );

            statement.setTime(
                    7,
                    appointment.getEndTime()
            );

            statement.setString(
                    8,
                    appointment.getReason()
            );

            statement.setString(
                    9,
                    appointment.getStatus()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    @Override
    public String generateAppointmentNumber() {

        String sql = """
                SELECT appointment_number
                FROM appointment
                ORDER BY appointment_id DESC
                LIMIT 1
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            if (resultSet.next()) {

                String lastNumber =
                        resultSet.getString(
                                "appointment_number"
                        );

                int number =
                        Integer.parseInt(
                                lastNumber.substring(1)
                        );

                number++;

                return String.format(
                        "A%06d",
                        number
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return "A000001";
    }


    @Override
    public boolean isTimeSlotBooked(
            int dentistId,
            Date appointmentDate,
            Time startTime,
            Time endTime) {

        String sql = """
                SELECT COUNT(*)
                FROM appointment
                WHERE dentist_id = ?
                  AND appointment_date = ?
                  AND status IN (
                      'PENDING',
                      'CONFIRMED',
                      'RESCHEDULED'
                  )
                  AND start_time < ?
                  AND end_time > ?
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    dentistId
            );

            statement.setDate(
                    2,
                    appointmentDate
            );

            statement.setTime(
                    3,
                    endTime
            );

            statement.setTime(
                    4,
                    startTime
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return resultSet.getInt(1) > 0;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }
}