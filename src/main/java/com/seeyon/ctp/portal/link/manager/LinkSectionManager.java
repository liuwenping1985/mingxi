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
import com.seeyon.ctp.portal.po.PortalLinkSection;
import com.seeyon.ctp.portal.po.PortalLinkSectionSecurity;

/**
 * <p>Title: 关联系统栏目及栏目授权管理器</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkSectionManager {
    /**
     * 检查是否存在相同的扩展栏目（名称和类型都相同则认为相同）
     * @param linkSectionId 关联系统栏目id
     * @param sname 关联系统名称
     * @param sectionType 关联系统栏目类型
     * @return
     * @throws BusinessException
     */
    public boolean checkSameLinkSection(Long linkSectionId, String sname, Integer sectionType) throws BusinessException;

    /**
     * 根据关联系统栏目id获取关联系统栏目
     * @param linkSectionId
     * @return
     */
    public PortalLinkSection selectLinkSection(long linkSectionId) throws BusinessException;

    /**
     * 根据关联系统栏目类型获取关联系统栏目
     * @param sectionType
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSection> selectLinkSectionByType(Integer sectionType) throws BusinessException;

    /**
     * 根据关联系统栏目id获取关联系统授权信息
     * @param linkSectionId
     * @return
     */
    public List<PortalLinkSectionSecurity> selectLinkSectionSecurityBySection(long linkSectionId) throws BusinessException;

    /**
     * 获取能够访问的栏目
     * @param domainIds
     * @param type
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSection> getSectionsByUserId(long userId, Integer sectionType) throws BusinessException;

    /**
     * 获取能够访问的栏目授权
     * @param userId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSectionSecurity> selectLinkSectionSecurity(long userId) throws BusinessException;
}
