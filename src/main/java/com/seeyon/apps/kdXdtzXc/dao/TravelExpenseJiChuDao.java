package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.TravelExpenseJiChu;

import java.util.List;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface TravelExpenseJiChuDao {
    public List<TravelExpenseJiChu> getTravelExpenseJiChu(String formmain_id) throws Exception;
}
