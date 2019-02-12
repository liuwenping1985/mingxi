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

import com.seeyon.ctp.portal.po.PortalLinkOptionValue;

/**
 * <p>Title: 关联系统参数值接口</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkOptionValueDao {

    /**
     * 根据用户id和参数id获取参数值
     * @param userId 用户id
     * @param linkOptionId 关联系统参数id
     * @return
     */
    public PortalLinkOptionValue findOptionValues(long userId, long linkOptionId);

    /**
     * 根据用户id和参数id获取参数值
     * @param userId 用户id
     * @param linkOptionId 关联系统参数id
     * @return
     */
    public List<PortalLinkOptionValue> selectLinkOptionValues(long userId, List<Long> linkOptionId);

    /**
     * 根据关联系统id参数名称和用户id获取参数值
     * @param linkSystemId 关联系统id
     * @param paramName 参数名称
     * @param userId 用户id
     * @return
     */
    public PortalLinkOptionValue findOptionValues(long linkSystemId, String paramName, long userId);

    /**
     * 根据关联系统参数获取参数值
     * @param linkOptionList 关联系统参数
     * @return
     */
    public List<Object[]> statisticsLinkOptionValue(final List<PortalLinkOptionValue> linkOptionList);

    /**
     * 根据关联系统参数获取参数值
     * @param linkOptionIds 关联系统参数
     * @param userIds 所在组织机构
     */
    public void deleteParamValues(final List<Long> linkOptionIds, final List<Long> userIds);

    /**
     * 保存关联系统参数值
     * @param linkOptionValue
     */
    public void saveLinkOptionValue(List<PortalLinkOptionValue> linkOptionValue);

    /**
     * @param linkOptionValue
     * @return
     */
    public void deleteLinkOptionValue(List<PortalLinkOptionValue> linkOptionValue);
}
