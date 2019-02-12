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
package com.seeyon.ctp.portal.link.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.po.PortalLinkSystem;
import com.seeyon.ctp.util.FlipInfo;

/**
 * <p>Title: 关联系统管理器</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkSystemManager {
    /**
     * 查找关联系统（主要按类别查找（列表查找））
     */
    @SuppressWarnings("rawtypes")
    FlipInfo selectLinkSystem(FlipInfo fi, Map params) throws BusinessException;
    /**
     * 获取关联系统的图标
     * @param linkSystemId
     * @return
     */
    String getLinkSytemIconById(Long linkSystemId);

    /**
     * 删除关联系统
     * @param id，关联系统id
     */
    public void deleteLinkSystemByIds(List<String> linkSystemIds) throws BusinessException;

    /**
     * 查找关联系统
     * @param linkSystemId，关联系统id
     */
    public PortalLinkSystem selectLinkSystem(Long linkSystemId) throws BusinessException;
    
    /**
     * 查找关联系统
     * @param linkSystemId
     * @return 返回带PortalLinkOption集合的关联系统
     * @throws BusinessException
     */
    public PortalLinkSystem selectLinkSystemWithOptions(Long linkSystemId) throws BusinessException;

    /**
     * 添加/修改关联系统
     */
    public void saveLinkSystem(PortalLinkSystem linkSystem) throws BusinessException;

    /**
     * 检查是否存在相同的关联系统（名称和类型相同则认为相同）
     * @param lname 关联系统名称
     * @param categoryId 关联系统类型
     * @param linkSystemId 关联系统id，新建时直接传入0
     * @return
     */
    public PortalLinkSystem selectLinkSystem(String lname, Long categoryId) throws BusinessException;

    /**
     * 检查类别下是否存在关联系统
     * @param categoryId 关联系统类别id
     * @return
     */
    public boolean checkLinkSytemByCategory(Long categoryId) throws BusinessException;

    /**
     * 根据人员获取关联系统id
     * @param params
     * @return
     * @throws BusinessException
     */
    @SuppressWarnings("rawtypes")
    public FlipInfo selectLinkSystemByUser(FlipInfo fi, Map params) throws BusinessException;

    /**
     * 获取用户再具体类型中的关联系统
     * @param userId
     * @param size
     * @param categoryId
     * @return
     * @throws Exception
     */
    public List<PortalLinkSystem> findLinkSystemBySize(long userId, int size, long categoryId) throws BusinessException;

    /**
     * 判断是否拥有关联系统的访问
     * @param userId
     * @param systemId
     * @param systemCategoryId
     * @return
     * @throws BusinessException
     */
    public boolean isUseTheSystem(Long userId, Long systemId, Long categoryId) throws BusinessException;

    /**
     * 获取关联系统授权
     * @param userId 用户id
     * @return
     */
    public List<Long> findLinkSystemAcl(long userId) throws BusinessException;

    /**
     * 获取所有关联系统
     * @return
     * @throws BusinessException
     */
    public List<List<PortalLinkSystem>> findAllLinkSystem(int doType) throws BusinessException;

    /**
     * 获取所有的知识链接：1，系统；2，别人分享的；3，自己新建的；排序规则待定
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findAllKnowledgeSystem(long userId, int size) throws BusinessException;

    /**
     * 更新关联系统自定义排序规则
     * @param linkSystemIds 关联系统id
     * @param userId 用户id
     * @throws Exception
     */
    public void saveLinkMember(List<Map<String, Object>> linkMember) throws BusinessException;

    /**
     * 根据知识链接创建者查询
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findKnowledgeSystemByCreator(long userId) throws BusinessException;

    /**
     * 根据人员类型和关联系统创建者类型获取关联系统
     * @param userId
     * @param creatorType
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findLinkSystemBySharerType(long userId, int creatorType, boolean includeKnowledge)
            throws BusinessException;

    /**
     * 获取能够访问的所有关联系统，包含系统创建授权和其他人员新建授权的知识链接
     * @param userId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findAllLinkSystem(long userId) throws BusinessException;

    /**
     * 根据人员id获取系统管理员创建并分享关联系统
     * @param userId 人员id
     * @return
     * @throws Exception
     */
    public List<PortalLinkSystem> findSysLinkSystem(long userId) throws BusinessException;

    /**
     * 根据人员id获取其他人员创建并分享关联系统
     * @param userId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findShareLinkSystem(long userId) throws BusinessException;

    /**根据人员id获取常用链接
     * @param userId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findCommonLinkSystem(long userId) throws BusinessException;

    /**
     * 根据人员获取系统管理员创建的知识链接
     * @param userId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findSysKnowledgeSystem(long userId) throws BusinessException;

    /**
     * 根据创建人员和类型获取知识链接
     * @param userId
     * @param linkCategoryId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkSystem> findLinkSystemByCreator(long userId, long linkCategoryId) throws BusinessException;

    /**
     * @param userId
     * @param linkSystem
     * @param ssoTargetUrl
     * @return
     * @throws BusinessException
     */
    public String magerSsourl(long userId, PortalLinkSystem linkSystem, String ssoTargetUrl) throws BusinessException;

    /**
     * 获取一个新的UUID
     * @return
     * @throws BusinessException
     */
    public String getUUID() throws BusinessException;
    
    /**
     * 获取数据库中最大的sort
     */
    public long selectMaxSort(long categoryId) throws BusinessException;

    /**
     * 根据url查找关联系统
     * @param linkSystemUrl
     * @return
     */
    PortalLinkSystem selectLinkSystemByUrl(String linkSystemUrl) throws BusinessException;
}
