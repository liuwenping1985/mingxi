/**
 * $Author: $
 * $Rev: $
 * $Date:: 2012-06-05 15:14:56#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */

package com.seeyon.ctp.organization.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;


public interface LevelManager {
	/**
	 * 新建一个职务级别
	 * @param dept
	 * @return
	 * @throws Exception
	 */
	public Long saveLevel(String accountId, Map level) throws BusinessException;
	/**
	 * 删除职务级别
	 * @param dept
	 * @return
	 * @throws Exception
	 */
	public String deleteLevel(List<Map<String,Object>> post) throws BusinessException;
	/**
	 * 读取某个职务级别的详细信息
	 * @param dept
	 * @return
	 * @throws Exception
	 */
	public HashMap viewLevel(Long postId) throws BusinessException;
	
	/**
	 * 获取职务级别列表
	 * @param fi
	 * @param params
	 * @return
	 * @throws BusinessException
	 */
	FlipInfo showLevelList(FlipInfo fi, Map params) throws BusinessException;
	

}