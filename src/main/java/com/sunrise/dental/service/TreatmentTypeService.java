package com.sunrise.dental.service;

import java.math.BigDecimal;
import java.util.List;

import com.sunrise.dental.dao.TreatmentTypeDAO;
import com.sunrise.dental.dao.TreatmentTypeDAOImpl;
import com.sunrise.dental.model.TreatmentType;

public class TreatmentTypeService {

    private final TreatmentTypeDAO treatmentTypeDAO;


    public TreatmentTypeService() {

        this.treatmentTypeDAO =
                new TreatmentTypeDAOImpl();
    }


    /*
     * ==========================================
     * GET ALL TREATMENT TYPES
     * ==========================================
     */

    public List<TreatmentType> getAllTreatmentTypes() {

        return treatmentTypeDAO.findAll();
    }


    /*
     * ==========================================
     * GET ACTIVE TREATMENT TYPES
     * ==========================================
     */

    public List<TreatmentType> getActiveTreatmentTypes() {

        return treatmentTypeDAO.findAllActive();
    }


    /*
     * ==========================================
     * GET BY ID
     * ==========================================
     */

    public TreatmentType getTreatmentTypeById(
            int treatmentTypeId) {

        if (treatmentTypeId <= 0) {

            return null;
        }

        return treatmentTypeDAO.findById(
                treatmentTypeId
        );
    }


    /*
     * ==========================================
     * CHECK NAME
     * ==========================================
     */

    public boolean treatmentNameExists(
            String treatmentName) {

        if (isBlank(treatmentName)) {

            return false;
        }

        return treatmentTypeDAO.existsByName(
                treatmentName.trim()
        );
    }


    /*
     * ==========================================
     * ADD TREATMENT TYPE
     * ==========================================
     */

    public boolean addTreatmentType(
            String treatmentName,
            BigDecimal basicCost) {

        if (isBlank(treatmentName)
                || basicCost == null
                || basicCost.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

            return false;
        }

        treatmentName =
                treatmentName.trim();

        if (treatmentTypeDAO.existsByName(
                treatmentName)) {

            return false;
        }

        TreatmentType treatmentType =
                new TreatmentType();

        treatmentType.setTreatmentName(
                treatmentName
        );

        treatmentType.setBasicCost(
                basicCost
        );

        treatmentType.setStatus(
                "ACTIVE"
        );

        return treatmentTypeDAO.save(
                treatmentType
        );
    }


    /*
     * ==========================================
     * UPDATE TREATMENT TYPE
     * ==========================================
     */

    public boolean updateTreatmentType(
            int treatmentTypeId,
            String treatmentName,
            BigDecimal basicCost) {

        if (treatmentTypeId <= 0
                || isBlank(treatmentName)
                || basicCost == null
                || basicCost.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

            return false;
        }

        treatmentName =
                treatmentName.trim();

        TreatmentType existing =
                treatmentTypeDAO.findById(
                        treatmentTypeId
                );

        if (existing == null) {

            return false;
        }

        if (!treatmentName.equalsIgnoreCase(
                existing.getTreatmentName())) {

            if (treatmentTypeDAO.existsByName(
                    treatmentName)) {

                return false;
            }
        }

        existing.setTreatmentName(
                treatmentName
        );

        existing.setBasicCost(
                basicCost
        );

        return treatmentTypeDAO.update(
                existing
        );
    }


    /*
     * ==========================================
     * CHANGE STATUS
     * ==========================================
     */

    public boolean changeStatus(
            int treatmentTypeId,
            String status) {

        if (treatmentTypeId <= 0
                || isBlank(status)) {

            return false;
        }

        String normalizedStatus =
                status.trim().toUpperCase();

        if (!normalizedStatus.equals("ACTIVE")
                && !normalizedStatus.equals("INACTIVE")) {

            return false;
        }

        TreatmentType existing =
                treatmentTypeDAO.findById(
                        treatmentTypeId
                );

        if (existing == null) {

            return false;
        }

        return treatmentTypeDAO.updateStatus(
                treatmentTypeId,
                normalizedStatus
        );
    }


    /*
     * ==========================================
     * VALIDATION
     * ==========================================
     */

    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }

}