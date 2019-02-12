/**
 * $Author: zhout $
 * $Rev: 7863 $
 * $Date:: 2012-11-22 09:33:21 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.link.manager;

import java.util.List;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.po.PortalLinkSpace;

/**
 * <p>Title: 关联系统空间及空间授权管理器</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkSpaceManager {

    /**
     * @param userId
     * @param linkSpaceId
     * @return
     * @throws BusinessException
     */
    public boolean isUseTheLinkSpace(Long userId, Long linkSpaceId) throws BusinessException;

    /**
     * @param spaceId
     * @return
     * @throws BusinessException
     */
    public PortalLinkSpace findLinkSpaceById(Long spaceId) throws BusinessException;
    /**
     * 
     * @param userId 当前登录人员Id
     * @return 可选关联系统的列表
     * @throws BusinessException
     */
    public List<PortalLinkSpace> findLinkSpacesCanAccess(Long userId) throws BusinessException;
}
