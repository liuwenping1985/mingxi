package com.seeyon.ctp.portal.link.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.po.PortalLinkSection;
import com.seeyon.ctp.portal.po.PortalLinkSectionSecurity;
import com.seeyon.ctp.util.DBAgent;

public class LinkSectionManagerImpl implements LinkSectionManager {
    private OrgManager orgManager;

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    @Override
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public boolean checkSameLinkSection(Long linkSectionId, String sname, Integer sectionType) {
        PortalLinkSection pls = DBAgent.get(PortalLinkSection.class, linkSectionId);
        if (pls != null) {
            if (pls.getSname().equals(sname) && pls.getType().equals(sectionType)) {
                return false;
            }
        }
        StringBuffer hql = new StringBuffer(
                "select count(id) from PortalLinkSection where id != :id and sname = :sname and type = :type");
        Map params = new HashMap();
        params.put("id", linkSectionId);
        params.put("sname", sname);
        params.put("type", sectionType);
        List list = DBAgent.find(hql.toString(), params);
        Long count = (Long) list.get(0);
        return count > 0;
    }

    @Override
    public PortalLinkSection selectLinkSection(long linkSectionId) {
        return DBAgent.get(PortalLinkSection.class, linkSectionId);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSection> selectLinkSectionByType(Integer sectionType) {
        StringBuffer hql = new StringBuffer("from PortalLinkSection where type = :type");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("type", sectionType);
        List<PortalLinkSection> list = DBAgent.find(hql.toString(), params);
        return list;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSectionSecurity> selectLinkSectionSecurityBySection(long linkSectionId) {
        String hql = "from PortalLinkSectionSecurity as security where security.sectionDefinitionId=:sectionDefinitionId";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("sectionDefinitionId", linkSectionId);
        return DBAgent.find(hql, params);
    }

    @SuppressWarnings("unchecked")
    public List<PortalLinkSection> getSectionsByUserId(long userId, Integer sectionType) throws BusinessException {
        List<PortalLinkSectionSecurity> linkSections = selectLinkSectionSecurity(userId);
        List<Long> sectionId = new ArrayList<Long>();
        for (PortalLinkSectionSecurity sectionSecurity : linkSections) {
            sectionId.add(sectionSecurity.getSectionDefinitionId());
        }
        if (!CollectionUtils.isEmpty(sectionId)) {
            StringBuffer hql = new StringBuffer("from PortalLinkSection where type = :type and id in(:id)");
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("type", sectionType);
            params.put("id", sectionId);
            return DBAgent.find(hql.toString(), params);
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkSectionSecurity> selectLinkSectionSecurity(long userId) throws BusinessException {
        List<Long> userInfo = orgManager.getAllUserDomainIDs(userId);
        String hql = "from PortalLinkSectionSecurity as security where security.entityId in(:entityId)";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("entityId", userInfo);
        return DBAgent.find(hql, params);
    }
}
