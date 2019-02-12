package com.seeyon.ctp.portal.link.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.portal.po.PortalLinkMenu;
import com.seeyon.ctp.util.DBAgent;

public class LinkMenuDaoImpl implements LinkMenuDao {

    @Override
    public PortalLinkMenu selectLinkMenu(long menuId) {
        return DBAgent.get(PortalLinkMenu.class, menuId);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkMenu> selectLinkMenuBySystemId(long linkSystemId) {
        String sql = "from PortalLinkMenu where linkSystemId = :linkSystemId";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkSystemId", linkSystemId);
        return DBAgent.find(sql, params);
    }

    @Override
    public boolean checkSameLinkMenu(long linkSystemId, String mname) {
        String hql = "from PortalLinkMenu where linkSystemId = :linkSystemId and mname = :mname";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkSystemId", linkSystemId);
        params.put("mname", mname);
        return DBAgent.exists(hql, params);
    }
}
