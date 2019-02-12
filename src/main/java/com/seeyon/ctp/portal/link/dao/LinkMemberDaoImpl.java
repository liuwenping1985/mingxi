package com.seeyon.ctp.portal.link.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.portal.po.PortalLinkMember;
import com.seeyon.ctp.util.DBAgent;

public class LinkMemberDaoImpl implements LinkMemberDao {

    @Override
    @SuppressWarnings("unchecked")
    public List<PortalLinkMember> findLinkMember(List<Long> linkSystemId, long userId) {
        String sql = "from PortalLinkMember where memberId = :userId and linkSystemId in (:linkSystemId) order by userLinkSort";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkSystemId", linkSystemId);
        params.put("userId", userId);
        return DBAgent.find(sql, params);
    }

    @Override
    public void saveLinkMember(List<PortalLinkMember> linkMember) {
        DBAgent.saveAll(linkMember);
    }

    @Override
    public void deleteLinkMember(List<PortalLinkMember> linkMember) {
        DBAgent.deleteAll(linkMember);
    }
}