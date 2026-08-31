package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.TreatmentType;

public interface TreatmentTypeDAO {

    List<TreatmentType> findAll();

    List<TreatmentType> findAllActive();

    TreatmentType findById(int treatmentTypeId);

    TreatmentType findByName(String treatmentName);

    boolean existsByName(String treatmentName);

    boolean save(TreatmentType treatmentType);

    boolean update(TreatmentType treatmentType);

    boolean updateStatus(
            int treatmentTypeId,
            String status
    );

}