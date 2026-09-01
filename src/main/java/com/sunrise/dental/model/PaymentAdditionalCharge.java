package com.sunrise.dental.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PaymentAdditionalCharge {

    private int additionalChargeId;
    private int paymentId;
    private String chargeName;
    private BigDecimal amount;
    private Timestamp createdAt;

    public PaymentAdditionalCharge() {
    }

    public PaymentAdditionalCharge(int paymentId, String chargeName, BigDecimal amount) {
        this.paymentId = paymentId;
        this.chargeName = chargeName;
        this.amount = amount;
    }

    public int getAdditionalChargeId() {
        return additionalChargeId;
    }

    public void setAdditionalChargeId(int additionalChargeId) {
        this.additionalChargeId = additionalChargeId;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public String getChargeName() {
        return chargeName;
    }

    public void setChargeName(String chargeName) {
        this.chargeName = chargeName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
