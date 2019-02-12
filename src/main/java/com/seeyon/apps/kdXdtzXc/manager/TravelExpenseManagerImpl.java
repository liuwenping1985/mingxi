package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.dao.*;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class TravelExpenseManagerImpl implements TravelExpenseManager {
    private TravelExpenseDao travelExpenseDao;
    private TravelExpenseJiChuDao travelExpenseJiChuDao;
    private TravelExpenseShiJiChuChaiDao travelExpenseShiJiChuChaiDao;
    private TravelExpenseXieChengQueRenDao travelExpenseXieChengQueRenDao;
    private TravelExpenseXinChengDetailDao travelExpenseXinChengDetailDao;

    public TravelExpenseDao getTravelExpenseDao() {
        return travelExpenseDao;
    }

    public void setTravelExpenseDao(TravelExpenseDao travelExpenseDao) {
        this.travelExpenseDao = travelExpenseDao;
    }

    public TravelExpenseJiChuDao getTravelExpenseJiChuDao() {
        return travelExpenseJiChuDao;
    }

    public void setTravelExpenseJiChuDao(TravelExpenseJiChuDao travelExpenseJiChuDao) {
        this.travelExpenseJiChuDao = travelExpenseJiChuDao;
    }

    public TravelExpenseShiJiChuChaiDao getTravelExpenseShiJiChuChaiDao() {
        return travelExpenseShiJiChuChaiDao;
    }

    public void setTravelExpenseShiJiChuChaiDao(TravelExpenseShiJiChuChaiDao travelExpenseShiJiChuChaiDao) {
        this.travelExpenseShiJiChuChaiDao = travelExpenseShiJiChuChaiDao;
    }

    public TravelExpenseXieChengQueRenDao getTravelExpenseXieChengQueRenDao() {
        return travelExpenseXieChengQueRenDao;
    }

    public void setTravelExpenseXieChengQueRenDao(TravelExpenseXieChengQueRenDao travelExpenseXieChengQueRenDao) {
        this.travelExpenseXieChengQueRenDao = travelExpenseXieChengQueRenDao;
    }

    public TravelExpenseXinChengDetailDao getTravelExpenseXinChengDetailDao() {
        return travelExpenseXinChengDetailDao;
    }

    public void setTravelExpenseXinChengDetailDao(TravelExpenseXinChengDetailDao travelExpenseXinChengDetailDao) {
        this.travelExpenseXinChengDetailDao = travelExpenseXinChengDetailDao;
    }
}
