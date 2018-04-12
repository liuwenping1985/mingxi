package com.seeyon.apps.datakit.service;

import com.seeyon.ctp.common.content.affair.AffairDao;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.util.CollectionUtils;

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

    public List<CtpAffair> getCtpAffairByBizId(String bizId){
        DetachedCriteria cri = DetachedCriteria.forClass(CtpAffair.class);
        cri.add(Restrictions.eq("identifier",bizId));
        cri.add(Restrictions.eq("objectId",0L));
        List<CtpAffair> list = DBAgent.findByCriteria(cri);
        if(CollectionUtils.isEmpty(list)){
            return null;
        }
        return list;
    }

    public CtpAffair getCtpAffairById(Long affId){
        DetachedCriteria cri = DetachedCriteria.forClass(CtpAffair.class);
        cri.add(Restrictions.eq("id",affId));
        List<CtpAffair> list = DBAgent.findByCriteria(cri);
        if(CollectionUtils.isEmpty(list)){
            return null;
        }
        return list.get(0);
    }



    public void deleteImportAffair() throws BusinessException {
       List<CtpAffair> affairs =  affairManager.getAffairs(0L, StateEnum.col_pending);
       for(CtpAffair affair:affairs){
           String outSide = (String)affair.getExtraAttr("outside_affair");
           if("YES".equals(outSide)){
               affairManager.deletePhysical(affair.getId());
           }
       }
    }
}
