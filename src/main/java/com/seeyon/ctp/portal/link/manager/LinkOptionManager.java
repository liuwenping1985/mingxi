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
import java.util.Map;

import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.portal.po.PortalLinkOptionValue;
import com.seeyon.ctp.util.FlipInfo;

/**
 * <p>Title: 关联系统参数及参数值管理器</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public interface LinkOptionManager {
    /**
     * 导入关联系统参数
     * @return 导入结果（跳过、覆盖）
     */
    String importLinkOptinValue(Long linkSystemId, List<List<String>> linkOptionValueList, String repeat) throws BusinessException;

    /**
     * 导出关联系统参数模板
     */
    DataRecord exportLinkOptionTemplate(List<PortalLinkOption> linkOptionList) throws BusinessException;

    /**
     * 根据参数名称和关联系统id获取参数
     * @param linkSystemId 关联系统id
     * @param paramName 参数名称
     * @return
     * @throws BusinessException
     */
    public PortalLinkOption findLinkOptionBy(Long linkSystemId, String paramName) throws BusinessException;

    /**
     * @param linkSystemId
     * @throws BusinessException
     */
    public void deleteParamValuesByLinkSystemId(Long linkSystemId) throws BusinessException;

    /**
     * 根据关联系统id获取关联系统参数
     */
    public List<PortalLinkOption> selectLinkOptions(Long linkSystemId);

    /**
     * 获取某个关联系统的参数值
     */
    @SuppressWarnings("rawtypes")
    FlipInfo selectLinkOptionValues(FlipInfo fi, Map params) throws BusinessException;

    /**
     * 根据关联系统参数id和人员id获取关联系统参数值
     * @param linkOptionId
     * @param userId
     * @return
     * @throws BusinessException
     */
    public List<PortalLinkOptionValue> selectLinkOptionValues(List<Long> linkOptionId, long userId)
            throws BusinessException;

    /**
     * 删除关联系统参数值
     */
    public void deleteParamValues(List<String> linkOptionIds, List<String> userIds);

    /**
     * 根据一个参数的id和人员id获取参数值
     * @param linkOptionId 关联系统参数id
     * @param userId 人员id
     * @return
     */
    public PortalLinkOptionValue selectLinkOptionValue(long linkOptionId, long userId);

    /**
     * 获取当前人员设置的参数值
     * @param linkOptionId 参数id
     * @return
     */
    public PortalLinkOptionValue selectLinkOptionValueCurrent(long linkOptionId);

    /**
     * @param linkOptionValue
     * @throws BusinessException
     */
    public void saveLinkOptionValue(List<Map<String, Object>> linkOptionValue) throws BusinessException;
}
