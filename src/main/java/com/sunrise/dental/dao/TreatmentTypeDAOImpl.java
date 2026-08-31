package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.TreatmentType;
import com.sunrise.dental.util.DBConnection;

public class TreatmentTypeDAOImpl implements TreatmentTypeDAO {

    @Override
    public List<TreatmentType> findAll() {

        List<TreatmentType> treatmentTypes =
                new ArrayList<>();

        String sql = """
                SELECT
                    treatment_type_id,
                    treatment_name,
                    basic_cost,
                    status,
                    created_at,
                    updated_at
                FROM treatment_type
                ORDER BY treatment_type_id DESC
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

                treatmentTypes.add(
                        mapTreatmentType(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return treatmentTypes;
    }


    @Override
    public List<TreatmentType> findAllActive() {

        List<TreatmentType> treatmentTypes =
                new ArrayList<>();

        String sql = """
                SELECT
                    treatment_type_id,
                    treatment_name,
                    basic_cost,
                    status,
                    created_at,
                    updated_at
                FROM treatment_type
                WHERE status = 'ACTIVE'
                ORDER BY treatment_name
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

                treatmentTypes.add(
                        mapTreatmentType(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return treatmentTypes;
    }


    @Override
    public TreatmentType findById(
            int treatmentTypeId) {

        String sql = """
                SELECT
                    treatment_type_id,
                    treatment_name,
                    basic_cost,
                    status,
                    created_at,
                    updated_at
                FROM treatment_type
                WHERE treatment_type_id = ?
                LIMIT 1
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    treatmentTypeId
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapTreatmentType(
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
    public TreatmentType findByName(
            String treatmentName) {

        String sql = """
                SELECT
                    treatment_type_id,
                    treatment_name,
                    basic_cost,
                    status,
                    created_at,
                    updated_at
                FROM treatment_type
                WHERE LOWER(treatment_name) =
                      LOWER(?)
                LIMIT 1
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    treatmentName
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapTreatmentType(
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
    public boolean existsByName(
            String treatmentName) {

        String sql = """
                SELECT treatment_type_id
                FROM treatment_type
                WHERE LOWER(treatment_name) =
                      LOWER(?)
                LIMIT 1
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    treatmentName
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                return resultSet.next();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean save(
            TreatmentType treatmentType) {

        String sql = """
                INSERT INTO treatment_type
                (
                    treatment_name,
                    basic_cost,
                    status
                )
                VALUES (?, ?, ?)
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    treatmentType.getTreatmentName()
            );

            statement.setBigDecimal(
                    2,
                    treatmentType.getBasicCost()
            );

            statement.setString(
                    3,
                    treatmentType.getStatus()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean update(
            TreatmentType treatmentType) {

        String sql = """
                UPDATE treatment_type
                SET
                    treatment_name = ?,
                    basic_cost = ?
                WHERE treatment_type_id = ?
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    treatmentType.getTreatmentName()
            );

            statement.setBigDecimal(
                    2,
                    treatmentType.getBasicCost()
            );

            statement.setInt(
                    3,
                    treatmentType.getTreatmentTypeId()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateStatus(
            int treatmentTypeId,
            String status) {

        String sql = """
                UPDATE treatment_type
                SET status = ?
                WHERE treatment_type_id = ?
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
                    treatmentTypeId
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    private TreatmentType mapTreatmentType(
            ResultSet resultSet)
            throws Exception {

        TreatmentType treatmentType =
                new TreatmentType();

        treatmentType.setTreatmentTypeId(
                resultSet.getInt(
                        "treatment_type_id"
                )
        );

        treatmentType.setTreatmentName(
                resultSet.getString(
                        "treatment_name"
                )
        );

        treatmentType.setBasicCost(
                resultSet.getBigDecimal(
                        "basic_cost"
                )
        );

        treatmentType.setStatus(
                resultSet.getString(
                        "status"
                )
        );

        treatmentType.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        treatmentType.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        return treatmentType;
    }

}