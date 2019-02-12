package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.dao.CwTravelAllowanceDao;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwTravelAllowanceManagerImpl implements CwTravelAllowanceManager {
    private CwTravelAllowanceDao cwTravelAllowanceDao;

    public CwTravelAllowanceDao getCwTravelAllowanceDao() {
        return cwTravelAllowanceDao;
    }

    public void setCwTravelAllowanceDao(CwTravelAllowanceDao cwTravelAllowanceDao) {
        this.cwTravelAllowanceDao = cwTravelAllowanceDao;
    }
}
