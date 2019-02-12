package com.seeyon.ctp.portal.link.manager;

import java.util.List;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.link.dao.LinkSpaceDao;
import com.seeyon.ctp.portal.po.PortalLinkSpace;
import com.seeyon.ctp.util.DBAgent;

public class LinkSpaceManagerImpl implements LinkSpaceManager {
    private OrgManager   orgManager;

    private LinkSpaceDao linkSpaceDao;

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setLinkSpaceDao(LinkSpaceDao linkSpaceDao) {
        this.linkSpaceDao = linkSpaceDao;
    }

    @Override
    public PortalLinkSpace findLinkSpaceById(Long spaceId) throws BusinessException {
        return DBAgent.get(PortalLinkSpace.class, spaceId);
    }

    @Override
    public boolean isUseTheLinkSpace(Long userId, Long linkSpaceId) throws BusinessException {
        List<Long> userInfo = orgManager.getAllUserDomainIDs(userId);
        return linkSpaceDao.isUseTheLinkSpace(userInfo, linkSpaceId);
    }

	@Override
	public List<PortalLinkSpace> findLinkSpacesCanAccess(Long userId) throws BusinessException {
		//获取组织模型IDs
		List<Long> domainIds = orgManager.getAllUserDomainIDs(userId);
		return linkSpaceDao.getLinkSpacesCanAccess(domainIds);
	}
}
