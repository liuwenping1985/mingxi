package com.seeyon.ctp.portal.link.manager;

import java.util.List;

import com.seeyon.ctp.portal.link.dao.LinkMenuDao;
import com.seeyon.ctp.portal.po.PortalLinkMenu;

public class LinkMenuManagerImpl implements LinkMenuManager {
    LinkMenuDao linkMenuDao;

    /**
     * @param linkMenuDao the linkMenuDao to set
     */
    public void setLinkMenuDao(LinkMenuDao linkMenuDao) {
        this.linkMenuDao = linkMenuDao;
    }

    @Override
    public PortalLinkMenu selectLinkMenu(long menuId) {
        return linkMenuDao.selectLinkMenu(menuId);
    }

    @Override
    public List<PortalLinkMenu> selectLinkMenuBySystemId(long linkSystemId) {
        return linkMenuDao.selectLinkMenuBySystemId(linkSystemId);
    }

    @Override
    public boolean checkSameLinkMenu(long linkSystemId, String mname) {
        return linkMenuDao.checkSameLinkMenu(linkSystemId, mname);
    }
}
