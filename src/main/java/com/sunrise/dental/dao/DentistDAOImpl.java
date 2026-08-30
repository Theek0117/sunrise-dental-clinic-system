package com.sunrise.dental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrise.dental.model.Dentist;
import com.sunrise.dental.util.DBConnection;

public class DentistDAOImpl implements DentistDAO {

    @Override
    public List<Dentist> findAllActive() {

        List<Dentist> dentists = new ArrayList<>();

        String sql = """
                SELECT
                    d.dentist_id,
                    d.staff_id,
                    d.dentist_number,
                    d.name,
                    d.nic,
                    d.specialization,
                    d.contact_number,
                    d.email,
                    d.status
                FROM dentist d
                INNER JOIN staff s
                    ON d.staff_id = s.staff_id
                WHERE d.status = 'ACTIVE'
                  AND s.role = 'DENTIST'
                  AND s.status = 'ACTIVE'
                ORDER BY d.name
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                dentists.add(mapDentist(resultSet));
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return dentists;
    }


    @Override
    public Dentist findById(int dentistId) {

        String sql = """
                SELECT
                    d.dentist_id,
                    d.staff_id,
                    d.dentist_number,
                    d.name,
                    d.nic,
                    d.specialization,
                    d.contact_number,
                    d.email,
                    d.status
                FROM dentist d
                INNER JOIN staff s
                    ON d.staff_id = s.staff_id
                WHERE d.dentist_id = ?
                  AND d.status = 'ACTIVE'
                  AND s.role = 'DENTIST'
                  AND s.status = 'ACTIVE'
                """;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, dentistId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    return mapDentist(resultSet);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }


    private Dentist mapDentist(ResultSet resultSet)
            throws Exception {

        Dentist dentist = new Dentist();

        dentist.setDentistId(
                resultSet.getInt("dentist_id")
        );

        dentist.setStaffId(
                resultSet.getInt("staff_id")
        );

        dentist.setDentistNumber(
                resultSet.getString("dentist_number")
        );

        dentist.setName(
                resultSet.getString("name")
        );

        dentist.setNic(
                resultSet.getString("nic")
        );

        dentist.setSpecialization(
                resultSet.getString("specialization")
        );

        dentist.setContactNumber(
                resultSet.getString("contact_number")
        );

        dentist.setEmail(
                resultSet.getString("email")
        );

        dentist.setStatus(
                resultSet.getString("status")
        );

        return dentist;
    }
}