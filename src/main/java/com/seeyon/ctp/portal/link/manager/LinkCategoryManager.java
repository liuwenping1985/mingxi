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
import com.seeyon.ctp.portal.po.PortalLinkCategory;

/**
 * <p>Title: 关联系统类型管理器</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkCategoryManager {

    /**
     * 系统管理员获取所有的关联系统类别
     */
    List<PortalLinkCategory> getCategoriesByAdmin() throws BusinessException;

    /**
     * 系统管理员获取所有的关联系统类别
     */
    List<PortalLinkCategory> getAllCategories() throws BusinessException;

    /**
     * 获取用户自定义的关联系统类别（用于知识链接）
     */
    List<PortalLinkCategory> getCategoriesByUser() throws BusinessException;

    /**
     * 保存关联系统类别
     * @param id，类别id
     * @param cname 类别名称
     * @param isSystem 是否系统管理
     * @param parentId 父类别名称
     * @return PortalLinkCategory
     */
    PortalLinkCategory saveCategory(Long id, String cname, boolean isSystemAdmin, Long parentId)
            throws BusinessException;

    /**
     * 删除关联系统类别
     * @param id，类别id
     */
    void deleteCategory(Long id) throws BusinessException;

    /**
     * 根据ID获取一个类别
     * @param categoryId
     * @return
     */
    public PortalLinkCategory selectCategoryById(long categoryId) throws BusinessException;

    /**
     * 获取数据库中最大的sort
     */
    public long selectMaxSort(String entityName) throws BusinessException;

}
