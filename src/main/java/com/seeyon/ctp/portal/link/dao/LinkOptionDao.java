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

import com.seeyon.ctp.portal.po.PortalLinkOption;

/**
 * <p>Title: 关联系统参数接口</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkOptionDao {
    /**
     * 根据关联系统id获取关联系统参数
     * @param linkSystemId 关联系统id
     * @return
     */
    public List<PortalLinkOption> getLinkOptionBySystemId(long linkSystemId);

    /**
     * 根据关联系统id和关联系统参数名称获取关联系统参数
     * @param linkSystemId 关联系统id
     * @param paramName 参数名称
     * @return
     */
    public PortalLinkOption findLinkOptionBy(final long linkSystemId, final String paramName);
}
