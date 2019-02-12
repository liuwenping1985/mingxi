package com.seeyon.ctp.portal.link.dao;

import java.util.List;

import com.seeyon.ctp.portal.po.PortalLinkAcl;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;

public class LinkAclDaoImpl implements LinkAclDao {

    @Override
    @SuppressWarnings("unchecked")
    public List<Long> findLinkByAcl(List<Long> orgIds) {
        String hql = "select distinct linkAlc.linkSystemId from " + PortalLinkAcl.class.getName()
                + " as linkAlc where linkAlc.userId in (:ids)";
        return DBAgent.find(hql, CommonTools.newHashMap("ids", orgIds));
    }
}