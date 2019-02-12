package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.seeyon.apps.kdXdtzXc.po.XieChengJiaoTong;
import com.seeyon.apps.kdXdtzXc.po.XiechengJiaotongQx;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface XiechengJiaotongQxManager {

	public abstract List<XiechengJiaotongQx> getAll() throws BusinessException;

	public abstract List<XiechengJiaotongQx> getDataByIds(Long[] ids);

	public XiechengJiaotongQx getDataById(Long id) throws BusinessException;

	public abstract void add(XiechengJiaotongQx xiechengJiaotongQx) throws BusinessException;

	public void update(XiechengJiaotongQx xiechengJiaotongQx) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListXiechengJiaotongQxData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	//新增
	public void saveByAdd(HttpServletRequest request) throws  BusinessException ;
	//修改
	public void updateByJiaoTongQx(HttpServletRequest request) throws  BusinessException ;
	/**
	 * 生成交通对账数据
	 * @param id
	 * @throws BusinessException
	 */
	public void jiaoTongById(Long id) throws BusinessException;
	/**
	 * 根据登录名称得到 职级
	 * @param EmployeeID
	 * @return
	 * @throws BusinessException
	 */
	public Map<String, Object> getEmployeeID(String EmployeeID)throws BusinessException;
	/**
	 * 根据登录名称得到人员 部门
	 * @param EmployeeID
	 * @return
	 * @throws BusinessException
	 */
	public Map<String, Object> getDepartment(String EmployeeID)throws BusinessException;
	
	public Map<String, Object> getDataByJourneyId(String journeyId) throws BusinessException;
	
	/**
	 * 保存出差人员实际出差信息
	 * @param memberIds
	 * @param approvalNumber
	 * @param mainId
	 * @param formshiji
	 */
	public void saveShijiXinxin(String memberIds,String approvalNumber,Long mainId,String formshiji);

}
