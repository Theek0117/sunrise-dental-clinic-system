package com.sunrise.dental.dao;

import com.sunrise.dental.model.Staff;

public interface StaffDAO {

    Staff findByUsername(String username);

}