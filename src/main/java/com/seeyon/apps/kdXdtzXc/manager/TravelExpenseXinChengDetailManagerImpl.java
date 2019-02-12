package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.dao.TravelExpenseXinChengDetailDao;
import com.seeyon.apps.kdXdtzXc.po.TravelExpenseXinChengDetail;

/**
 * Created by tap-pcng43 on 2017-10-17.
 */
public class TravelExpenseXinChengDetailManagerImpl implements TravelExpenseXinChengDetailManager {
    private TravelExpenseXinChengDetailDao travelExpenseXinChengDetailDao;

    public TravelExpenseXinChengDetailDao getTravelExpenseXinChengDetailDao() {
        return travelExpenseXinChengDetailDao;
    }

    public void setTravelExpenseXinChengDetailDao(TravelExpenseXinChengDetailDao travelExpenseXinChengDetailDao) {
        this.travelExpenseXinChengDetailDao = travelExpenseXinChengDetailDao;
    }

    @Override
    public void save(TravelExpenseXinChengDetail travelExpenseXinChengDetail) {
        travelExpenseXinChengDetailDao.save(travelExpenseXinChengDetail);
    }

    @Override
    public void delete(Long id) {
        travelExpenseXinChengDetailDao.delete(id);
    }

    @Override
    public TravelExpenseXinChengDetail getTravelExpenseXinChengDetail(Long id) {
        return travelExpenseXinChengDetailDao.getTravelExpenseXinChengDetail(id);
    }
}
