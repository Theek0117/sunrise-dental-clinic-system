package com.sunrise.dental.dao;

import java.util.List;
import com.sunrise.dental.model.PaymentAdditionalCharge;

public interface PaymentAdditionalChargeDAO {

    boolean save(PaymentAdditionalCharge charge);

    boolean saveAll(List<PaymentAdditionalCharge> charges);

    List<PaymentAdditionalCharge> findByPaymentId(int paymentId);
}
