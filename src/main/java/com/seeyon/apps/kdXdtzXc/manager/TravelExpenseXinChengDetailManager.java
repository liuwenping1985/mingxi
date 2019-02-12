package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.po.TravelExpenseXinChengDetail;

/**
 * Created by tap-pcng43 on 2017-10-17.
 */
public interface TravelExpenseXinChengDetailManager {
    void save(TravelExpenseXinChengDetail travelExpenseXinChengDetail);

    void delete(Long id);

    TravelExpenseXinChengDetail getTravelExpenseXinChengDetail(Long id);
}
