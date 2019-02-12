package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface XiechengZsdzManager {

	public abstract List<XiechengZsdz> getAll() throws BusinessException;

	public abstract List<XiechengZsdz> getDataByIds(Long[] ids);

	public XiechengZsdz getDataById(Long id) throws BusinessException;

	public abstract void add(XiechengZsdz xiechengZsdz) throws BusinessException;

	public void update(XiechengZsdz xiechengZsdz) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListXiechengZsdzData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	
	
	public void xiechengJiudianJieShuan() throws  BusinessException ;
	
	//查询OA数据库是否已经存在相同数据，避免重复插入
	public List<Map<String, Object>> getOaList(String journeyid,String passengername,String takeofftime,String arrivaltime,String orderType,String amount);
	
	public void saveXiechengFqdzxx() throws BusinessException;
	
	/** 根据id查找多条记录 **/
	public List<XiechengZsdz> getDataByZhuSuId(Long id,String accountId)throws BusinessException;
	
	/**
	 * 功能：根据MDZ传递的审批单号查询机票所需信息
	 * @param journeyID  审批单号
	 * @param loginName 用户登录名
	 * @return
	 * @throws BusinessException
	 */
	public Map<String,Object> getProjectInfoByOrderId(String journeyID,String loginName)throws BusinessException;
	
	/**
	 * 根据 出差申请单 单号查找出最后时间的affairId
	 * @param formId
	 * @return
	 */
	public Map<String,Object> getCtpAffairId(String formId);
	@AjaxAccess
	public FlipInfo getListXiechengZsDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException;
}
