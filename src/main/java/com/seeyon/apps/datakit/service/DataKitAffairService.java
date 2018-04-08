package com.seeyon.apps.datakit.service;

import com.seeyon.ctp.common.content.affair.AffairDao;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;

import java.util.List;

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

    public CtpAffair saveCtpAffair(CtpAffair affair) throws BusinessException {
         affairManager.save(affair);
         return affair;
    }



    public void deleteImportAffair() throws BusinessException {
       List<CtpAffair> affairs =  affairManager.getAffairs(0L, StateEnum.col_pending);
       for(CtpAffair affair:affairs){
           String outSide = (String)affair.getExtraAttr("outside");
           if("YES".equals(outSide)){
               affairManager.deletePhysical(affair.getId());
           }
       }
    }
}
