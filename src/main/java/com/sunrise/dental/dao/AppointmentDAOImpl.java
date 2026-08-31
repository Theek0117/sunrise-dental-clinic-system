package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.util.DBConnection;

public class AppointmentDAOImpl implements AppointmentDAO {

    @Override
    public boolean save(
            Appointment appointment) {

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
                Connection connection =
                        DBConnection.getConnection();

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
                Connection connection =
                        DBConnection.getConnection();

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

                if (lastNumber != null
                        && lastNumber.length() > 1) {

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

        return getBookingCountByDentist(
                dentistId,
                appointmentDate,
                startTime,
                endTime
        ) > 0;
    }

    @Override
    public int getSlotBookingCount(
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime) {

        String sql = """
                SELECT COUNT(*)
                FROM appointment
                WHERE availability_id = ?
                  AND appointment_date = ?
                  AND start_time = ?
                  AND end_time = ?
                  AND status IN (
                      'PENDING',
                      'CONFIRMED',
                      'RESCHEDULED'
                  )
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    availabilityId
            );

            statement.setDate(
                    2,
                    appointmentDate
            );

            statement.setTime(
                    3,
                    startTime
            );

            statement.setTime(
                    4,
                    endTime
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return resultSet.getInt(1);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int getSlotBookingCountExcludingAppointment(
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime,
            int appointmentId) {

        String sql = """
                SELECT COUNT(*)
                FROM appointment
                WHERE availability_id = ?
                  AND appointment_date = ?
                  AND start_time = ?
                  AND end_time = ?
                  AND appointment_id <> ?
                  AND status IN (
                      'PENDING',
                      'CONFIRMED',
                      'RESCHEDULED'
                  )
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    availabilityId
            );

            statement.setDate(
                    2,
                    appointmentDate
            );

            statement.setTime(
                    3,
                    startTime
            );

            statement.setTime(
                    4,
                    endTime
            );

            statement.setInt(
                    5,
                    appointmentId
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return resultSet.getInt(1);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public List<Appointment> findAll() {

        List<Appointment> appointments =
                new ArrayList<>();

        String sql = """
                SELECT
                    appointment_id,
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                FROM appointment
                ORDER BY appointment_date DESC,
                         start_time DESC
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            while (resultSet.next()) {

                appointments.add(
                        mapAppointment(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }

    @Override
    public List<Appointment> findActiveAppointments() {

        List<Appointment> appointments =
                new ArrayList<>();

        String sql = """
                SELECT
                    appointment_id,
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                FROM appointment
                WHERE status IN (
                    'PENDING',
                    'CONFIRMED',
                    'RESCHEDULED'
                )
                ORDER BY appointment_date ASC,
                         start_time ASC
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            while (resultSet.next()) {

                appointments.add(
                        mapAppointment(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }

    @Override
    public Appointment findById(
            int appointmentId) {

        String sql = """
                SELECT
                    appointment_id,
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                FROM appointment
                WHERE appointment_id = ?
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapAppointment(
                            resultSet
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean cancelAppointment(
            int appointmentId) {

        String sql = """
                UPDATE appointment
                SET status = 'CANCELLED'
                WHERE appointment_id = ?
                  AND status IN (
                      'PENDING',
                      'CONFIRMED',
                      'RESCHEDULED'
                  )
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }

    @Override
    public boolean rescheduleAppointment(
            int appointmentId,
            int dentistId,
            int availabilityId,
            Date appointmentDate,
            Time startTime,
            Time endTime,
            String reason) {

        String sql = """
                UPDATE appointment
                SET
                    dentist_id = ?,
                    availability_id = ?,
                    appointment_date = ?,
                    start_time = ?,
                    end_time = ?,
                    reason = ?,
                    status = 'RESCHEDULED'
                WHERE appointment_id = ?
                  AND status IN (
                      'PENDING',
                      'CONFIRMED',
                      'RESCHEDULED'
                  )
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    dentistId
            );

            statement.setInt(
                    2,
                    availabilityId
            );

            statement.setDate(
                    3,
                    appointmentDate
            );

            statement.setTime(
                    4,
                    startTime
            );

            statement.setTime(
                    5,
                    endTime
            );

            statement.setString(
                    6,
                    reason
            );

            statement.setInt(
                    7,
                    appointmentId
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }

    private int getBookingCountByDentist(
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
                Connection connection =
                        DBConnection.getConnection();

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

                    return resultSet.getInt(1);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }

    private Appointment mapAppointment(
            ResultSet resultSet)
            throws Exception {

        Appointment appointment =
                new Appointment();

        appointment.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        appointment.setAppointmentNumber(
                resultSet.getString(
                        "appointment_number"
                )
        );

        appointment.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        appointment.setDentistId(
                resultSet.getInt(
                        "dentist_id"
                )
        );

        appointment.setAvailabilityId(
                resultSet.getInt(
                        "availability_id"
                )
        );

        appointment.setAppointmentDate(
                resultSet.getDate(
                        "appointment_date"
                )
        );

        appointment.setStartTime(
                resultSet.getTime(
                        "start_time"
                )
        );

        appointment.setEndTime(
                resultSet.getTime(
                        "end_time"
                )
        );

        appointment.setReason(
                resultSet.getString(
                        "reason"
                )
        );

        appointment.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        return appointment;
    }
    
    @Override
    public List<Appointment> findByDentistAndDate(
            int dentistId,
            Date appointmentDate) {

        List<Appointment> appointments =
                new ArrayList<>();

        String sql = """
                SELECT
                    appointment_id,
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                FROM appointment
                WHERE dentist_id = ?
                  AND appointment_date = ?
                ORDER BY start_time ASC
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

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

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    appointments.add(
                            mapAppointment(resultSet)
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }
    
    @Override
    public List<Appointment> findByDentist(
            int dentistId) {

        List<Appointment> appointments =
                new ArrayList<>();

        String sql = """
                SELECT
                    appointment_id,
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                FROM appointment
                WHERE dentist_id = ?
                  AND status <> 'CANCELLED'
                ORDER BY appointment_date DESC,
                         start_time DESC
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    dentistId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    appointments.add(
                            mapAppointment(resultSet)
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }
    
    @Override
    public Appointment findByIdAndDentist(
            int appointmentId,
            int dentistId) {

        String sql = """
                SELECT
                    appointment_id,
                    appointment_number,
                    patient_id,
                    dentist_id,
                    availability_id,
                    appointment_date,
                    start_time,
                    end_time,
                    reason,
                    status
                FROM appointment
                WHERE appointment_id = ?
                  AND dentist_id = ?
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    appointmentId
            );

            statement.setInt(
                    2,
                    dentistId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapAppointment(
                            resultSet
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }
    
    @Override
    public boolean updateStatus(
            int appointmentId,
            int dentistId,
            String status) {

        String sql = """
                UPDATE appointment
                SET status = ?
                WHERE appointment_id = ?
                  AND dentist_id = ?
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    status
            );

            statement.setInt(
                    2,
                    appointmentId
            );

            statement.setInt(
                    3,
                    dentistId
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }
}