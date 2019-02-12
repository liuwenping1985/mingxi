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

import com.seeyon.ctp.portal.po.PortalLinkMember;

/**
 * <p>Title: 关联系统自定义排序接口</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkMemberDao {
    /**
     * 获取关联系统自定义排序
     * @param linkSystemId 关联系统id
     * @param userId 人员id
     * @return
     */
    public List<PortalLinkMember> findLinkMember(List<Long> linkSystemId, long userId);

    /**
     * 保存自定义排序
     * @param linkMember
     */
    public void saveLinkMember(List<PortalLinkMember> linkMember);

    /**
     * 删除自定义排序
     * @param linkMember
     */
    public void deleteLinkMember(List<PortalLinkMember> linkMember);

}