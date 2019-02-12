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

import com.seeyon.ctp.portal.po.PortalLinkCategory;

/**
 * <p>Title: 关联系统类别接口</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkCategoryDao {
    /**
     * 根据名称获取关联系统类别
     * @param name 关联系统类别名称
     * @return
     */
    public List<PortalLinkCategory> getLinkCategorys(String name);

    /**
     * 获取最大排序号
     * @return
     */
    public int getMaxOrderNumber();

    /**
     * 根据类别id删除关联系统类型
     * @param linkCategoryIds 关联系统id
     */
    public void deleteCategorys(String linkCategoryIds);
}
