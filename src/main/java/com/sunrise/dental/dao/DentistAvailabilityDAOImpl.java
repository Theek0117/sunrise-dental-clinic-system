package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.DentistAvailability;
import com.sunrise.dental.util.DBConnection;

public class DentistAvailabilityDAOImpl
        implements DentistAvailabilityDAO {

    @Override
    public DentistAvailability findById(
            int availabilityId) {

        String sql = """
                SELECT
                    availability_id,
                    dentist_id,
                    available_date,
                    start_time,
                    end_time,
                    status,
                    created_at
                FROM dentist_availability
                WHERE availability_id = ?
                  AND status = 'AVAILABLE'
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

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapAvailability(
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
    public List<DentistAvailability>
    findByDentistAndDate(
            int dentistId,
            Date availableDate) {

        List<DentistAvailability>
                availabilityList =
                new ArrayList<>();

        String sql = """
                SELECT
                    availability_id,
                    dentist_id,
                    available_date,
                    start_time,
                    end_time,
                    status,
                    created_at
                FROM dentist_availability
                WHERE dentist_id = ?
                  AND available_date = ?
                  AND status = 'AVAILABLE'
                ORDER BY start_time
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
                    availableDate
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    availabilityList.add(
                            mapAvailability(
                                    resultSet
                            )
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return availabilityList;
    }

    /*
     * ==========================================
     * MAP RESULT
     * ==========================================
     */

    private DentistAvailability mapAvailability(
            ResultSet resultSet)
            throws Exception {

        DentistAvailability availability =
                new DentistAvailability();

        availability.setAvailabilityId(
                resultSet.getInt(
                        "availability_id"
                )
        );

        availability.setDentistId(
                resultSet.getInt(
                        "dentist_id"
                )
        );

        availability.setAvailableDate(
                resultSet.getDate(
                        "available_date"
                )
        );

        availability.setStartTime(
                resultSet.getTime(
                        "start_time"
                )
        );

        availability.setEndTime(
                resultSet.getTime(
                        "end_time"
                )
        );

        availability.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        availability.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        return availability;
    }
}