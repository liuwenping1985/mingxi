/**
 * $Author: wangchw $
 * $Rev: 49107 $
 * $Date:: 2015-04-28 15:01:07 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.link.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.po.PortalLinkSystem;
import com.seeyon.ctp.util.FlipInfo;

/**
 * <p>Title: 关联系统数据访问接口</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkSystemDao {
	/**
	 * 查询所有关联系统
	 * @return
	 */
	List<PortalLinkSystem> findAll();
    /**
     * 查找关联系统（主要按类别查找）
     * @param fi
     * @param params
     * @return
     */
    @SuppressWarnings("rawtypes")
    FlipInfo selectLinkSystem(FlipInfo fi, Map params) throws BusinessException;

    /**
     * 查找某一类型中所有关联系统
     * @param list
     * @param size
     * @param CategoryId
     * @return
     */
    public List<PortalLinkSystem> selectLinkSystem(List<Long> linkSystemId, int size, long linkCategoryId)
            throws BusinessException;

    /**
     * 根据关联系统id和系统类型查找关联系统
     * @param linkSystemId
     * @param includeKnowledge TODO
     * @param userId TODO
     * @param typeId
     * @return
     */
    public List<PortalLinkSystem> findLinkSystemBySharerType(List<Long> linkSystemId, int creatorType,
            boolean includeKnowledge, long userId);

    /**
     * 是否有空间使用权限
     * @param systemId
     * @param systemCategoryId
     * @param domainIds
     * @return
     */
    public boolean isUseTheSystem(Long systemId, Long systemCategoryId, List<Long> domainIds);

    /**
     * 根据关联系统id获取关联系统
     * @param linkSystemId 关联系统id
     * @return
     */
    public PortalLinkSystem selectLinkSystemById(long linkSystemId);

    /**
     * 获取自定义的关联系统（知识中心可以自定义）
     * @param userId
     * @param creatorType TODO
     * @return
     */
    public List<PortalLinkSystem> findLinkSystemByCreator(long userId, int creatorType, int size);

    /**
     * 获取自定义的关联系统
     * @param userId
     * @param systemCategoryId
     * @return
     */
    public List<PortalLinkSystem> findLinkSystemByCreator(long userId, long linkCategoryId);

    /**
     * 获取能够访问的所有关联系统，包含系统创建和自定义的
     * @param linkSystemId
     * @return
     */
    public List<PortalLinkSystem> findAllLinkSystem(List<Long> linkSystemId);

    /**
     * 获取可访问的所有知识链接，包括系统创建和他人创建共享的
     * @param userId
     * @return
     */
    public List<PortalLinkSystem> findAllShareKnowledge(List<Long> linkSystemId, long userId, int size);

    /**
     * @param linkSystemId
     * @return
     */
    @SuppressWarnings("rawtypes")
    public FlipInfo findMemberShareKnowledge(FlipInfo fi, Map params);

    @SuppressWarnings("rawtypes")
    public FlipInfo findLinkSystemByCreator(FlipInfo fi, Map params);

    public boolean checkLinkSytemByCategory(Long categoryId);

    public PortalLinkSystem selectLinkSystem(String lname, Long categoryId);
    
    public PortalLinkSystem findLinkSystemByUrl(String linkSystemUrl);
}
