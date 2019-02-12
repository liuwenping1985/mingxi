package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public interface XiechengJtdzManager {
	/** 查看全部内容 **/
	public abstract List<XiechengJtdz> getAll() throws BusinessException;
	/** 根据ids查找多条记录 **/
	public abstract List<XiechengJtdz> getDataByIds(Long[] ids);
	/** 根据id查找一条记录 **/
	public XiechengJtdz getDataById(Long id) throws BusinessException;
	/** 修改记录 **/
	public void update(XiechengJtdz xiechengJtdz) throws BusinessException;
	/** 删除多条记录 **/
	public void deleteAll(Long[] ids) throws BusinessException;
	/** 根据ID删除 **/
	public void deleteById(Long id) throws BusinessException;
	/** 根据对象删除 **/
	public void delete(XiechengJtdz xiechengjtdz)throws BusinessException;
	
	public void xieChengDuiZhang() throws BusinessException;
	/** 列表显示界面 **/
	@AjaxAccess
	public abstract FlipInfo getListXiechengJtdzData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	
	//从中间区获取交通对账数据插入到OA数据库
	public abstract void add(XiechengJtdz xiechengjtdz) throws BusinessException;
	//查询OA数据库是否已经存在相同数据，避免重复插入
	public List<Map<String, Object>> getOaList(String journeyid,String passengername,String takeofftime,String arrivaltime,String orderDetailType,String amound);

	public void xiechengJiaoTongJieShuan() throws  BusinessException ;
	
	/** 根据id查找多条记录 **/
	public List<XiechengJtdz> getDataByJiaoTongId(Long id,String extAttr3)throws BusinessException;
	@AjaxAccess
	public abstract FlipInfo getListXiechengJtDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException;

}
