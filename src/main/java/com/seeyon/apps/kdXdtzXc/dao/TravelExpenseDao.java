package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.TravelExpense;

import java.util.List;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface TravelExpenseDao {

    public List<TravelExpense> getTravelExpenseJiChu(Long id) throws Exception;
}
