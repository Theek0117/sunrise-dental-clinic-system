package com.sunrise.dental.service;

import java.util.List;

import com.sunrise.dental.dao.DentistDAO;
import com.sunrise.dental.dao.DentistDAOImpl;
import com.sunrise.dental.model.Dentist;

public class DentistService {

    private final DentistDAO dentistDAO;

    public DentistService() {

        this.dentistDAO =
                new DentistDAOImpl();
    }


    public List<Dentist> getActiveDentists() {

        return dentistDAO.findAllActive();
    }


    public Dentist getDentistById(int dentistId) {

        return dentistDAO.findById(dentistId);
    }
}