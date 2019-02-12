/**
 * $Author: leikj $
 * $Rev: 6983 $
 * $Date:: 2012-11-05 10:40:41 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.link.dao;

import java.util.List;

import com.seeyon.ctp.portal.po.PortalLinkSpace;
/**
 * <p>Title: 关联系统空间接口</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkSpaceDao {

    /**
     * 获取当前用户可以访问的扩展空间
     * @param domainIds 用户所属组织机构
     * @return
     */
    public List<PortalLinkSpace> getLinkSpacesCanAccess(List<Long> domainIds);

    /**
     * 校验当前用户是否能够继续使用扩展空间
     * @param domainIds 用户所属组织机构
     * @param linkSpaceId 关联系统空间id
     * @return
     */
    public boolean isUseTheLinkSpace(List<Long> domainIds, Long linkSpaceId);

}
