package com.seeyon.apps.taskcenter.Manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.po.ProSenderUrl;
import com.seeyon.ctp.common.authenticate.domain.User;

public interface TaskCenterOAManager {

	public List<TaskCenterResource> getTaskCenterResource(User user);
	
	public List<TaskCenterResource> getTaskList4Section(User user, int count);
	/**
	 * ajax获得url sso参数
	 * @param loginName
	 * @return
	 */
	public String getOpenParamsUrl(String loginName);
	public String getPortalUser(String userId);
	/**
	 * 通过webservice接口获得center机构id
	 * @param loginName
	 * @return
	 */
	public String getjtUserDeptId(String loginName);
	
	/**
	 * 获得用户所在部门的父部门ID
	 * @param loginName  用户登录帐号
	 * @return
	 */
	public String getjtUserParentDeptId(String loginName);
	
	public String getOrganizationByLoginName(String loginName);
	
	/**
	 * 通过webservice接口获得用户cindacenter id
	 * @param loginName
	 * @return
	 */
	public String getjtUserId(String loginName);
	/**
	 * 用于ajax调用前台用户点击是替换掉必须的参数
	 * @param link
	 * @param loginName
	 * @param hkdepartId
	 * @return
	 */
	public String replaceUrlParams(String link, String loginName, String hkdepartId);
	public List<ProSenderUrl> getAllLinksIndb();
	public void inportLinks(List<ProSenderUrl> list);

	public List<TaskCenterResource> findTreeNodes(Map params);

	public String addAuthorResource(List<Map> param);
}
