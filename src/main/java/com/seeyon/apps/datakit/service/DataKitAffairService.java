package com.seeyon.apps.datakit.service;

import com.seeyon.ctp.common.content.affair.AffairDao;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.organization.manager.OrgManager;

/**
 * Created by liuwenping on 2018/4/4.
 */
public class DataKitAffairService {

    private AffairManager affairManager;
    private AffairDao affairDao;
    private OrgManager orgManager;

    public AffairManager getAffairManager() {
        return affairManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public AffairDao getAffairDao() {
        return affairDao;
    }

    public void setAffairDao(AffairDao affairDao) {
        this.affairDao = affairDao;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
}
