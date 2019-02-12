package com.seeyon.ctp.permission.manager;

import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;

public interface LicensePermissionManager {
	/**
	 * 设置server许可形式
	 * 0：不按单位许可，1：按照单位许可
	 * @throws BusinessException
	 */
	public void setServerPermissionType(String type) throws BusinessException;
	/**
	 * 获取server许可形式
	 * @return 1：不分单位，2：分单位
	 * @throws BusinessException
	 */
	public String getServerPermissionType() throws BusinessException;
	/**
	 * 设置m1许可形式
	 * 0：不按单位许可，1：按照单位许可
	 * @throws BusinessException
	 */
	public void setM1PermissionType(String type) throws BusinessException;
	/**
	 * 获取m1许可形式
	 * @return 1：不分单位，2：分单位
	 * @throws BusinessException
	 */
	public String getM1PermissionType() throws BusinessException;
	/**
	 * 设置致信许可形式
	 * 0：不按单位许可，1：按照单位许可
	 * @throws BusinessException
	 */
	public void setZXPermissionType(String type) throws BusinessException;
	/**
	 * 获取致信许可形式
	 * @return 1：不分单位，2：分单位
	 * @throws BusinessException
	 */
	public String getZXPermissionType() throws BusinessException;
	
	/**
	 * 获取组织的许可信息
	 * @return 
	 * @throws BusinessException
	 */
	public Map getPermissionInfo(String accId) throws BusinessException;
	/**
	 * 保存单位分配信息
	 * @param perinfo
	 * @throws BusinessException
	 */
	public void savePermissionDisInfo(Map perinfo) throws BusinessException;
	/**
	 * 获取单位分配信息
	 * @return
	 * @throws BusinessException
	 */
	public Map getPermissionDisInfo() throws BusinessException;
	
	/**
	 * 获取单位的分配数
	 * @param i
	 * @param accId
	 * @return
	 */
	public Integer queryDistributionCount(Integer i, String accId);
	
}
