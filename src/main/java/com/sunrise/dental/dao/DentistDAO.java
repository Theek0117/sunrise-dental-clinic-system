package com.sunrise.dental.dao;

import java.util.List;

import com.sunrise.dental.model.Dentist;

public interface DentistDAO {

    List<Dentist> findAllActive();

    Dentist findById(int dentistId);

    Dentist findByStaffId(int staffId);
}