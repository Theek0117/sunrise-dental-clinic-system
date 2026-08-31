package com.sunrise.dental.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class TreatmentType {

    private int treatmentTypeId;

    private String treatmentName;

    private BigDecimal basicCost;

    private String status;

    private Timestamp createdAt;

    private Timestamp updatedAt;


    public TreatmentType() {

    }


    public int getTreatmentTypeId() {

        return treatmentTypeId;
    }

    public void setTreatmentTypeId(int treatmentTypeId) {

        this.treatmentTypeId = treatmentTypeId;
    }


    public String getTreatmentName() {

        return treatmentName;
    }

    public void setTreatmentName(String treatmentName) {

        this.treatmentName = treatmentName;
    }


    public BigDecimal getBasicCost() {

        return basicCost;
    }

    public void setBasicCost(BigDecimal basicCost) {

        this.basicCost = basicCost;
    }


    public String getStatus() {

        return status;
    }

    public void setStatus(String status) {

        this.status = status;
    }


    public Timestamp getCreatedAt() {

        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {

        this.createdAt = createdAt;
    }


    public Timestamp getUpdatedAt() {

        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {

        this.updatedAt = updatedAt;
    }

}