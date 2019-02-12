package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;

public abstract interface XieChenXinXiQueRenManager {

	/**
	 * 功能：携程人事对接查询全部
	 * @return
	 * @throws BusinessException
	 */
	public List<Map<String, Object>> getDataByMemberWhole(String AccountId) throws BusinessException;
	/**
	 * 功能：查询当天添加修改的org_member表数据
	 * @return
	 * @throws BusinessException
	 */
	public List<Map<String, Object>> getDataByMemberTime(String AccountId) throws BusinessException;
    
}
