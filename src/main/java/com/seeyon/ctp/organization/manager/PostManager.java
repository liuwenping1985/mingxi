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


public interface PostManager {
	/**
	 * 部门管理进入页面
	 * @return
	 * @throws Exception
	 */
	public HashMap addPost(String accountId) throws BusinessException;
	/**
	 * 新建一个部门
	 * @param dept
	 * @return
	 * @throws Exception
	 */
	public Long createPost(String accountId, Map post) throws BusinessException;
	/**
	 * 删除一个岗位
	 * @param dept
	 * @return
	 * @throws Exception
	 */
	public String deletePost(List<Map<String,Object>> post) throws BusinessException;
	/**
	 * 读取某个部门的详细信息
	 * @param dept
	 * @return
	 * @throws Exception
	 */
	public HashMap viewPost(Long postId) throws BusinessException;
	/**
	 * 获取岗位列表
	 * @param fi
	 * @param params
	 * @return
	 * @throws BusinessException
	 */
	FlipInfo showPostList(FlipInfo fi, Map params) throws BusinessException;
	/**
	 * 获取集团ID
	 * @return
	 * @throws BusinessException
	 */
	HashMap getRootAccountId() throws BusinessException;
	/**
	 * 获取要删除的岗位的名称
	 * @param post
	 * @return
	 * @throws Exception
	 */
	public String getdeletePostnames(List<Map<String,Object>> post) throws BusinessException;
	/**
	 * 绑定集团标准岗
	 * @param postId
	 * @return
	 * @throws BusinessException
	 */
	public String bdingBasePost(String accountId, List<Map<String,Object>> post) throws BusinessException;
	/**
	 * 引用集团标准岗
	 * @param posts
	 * @throws BusinessException
	 */
	void createPostFormBase(String accountId, String posts) throws BusinessException;
	
	/**
	 * 是否是集团
	 * @return
	 * @throws BusinessException
	 */
	public boolean isGroup() throws BusinessException;

}