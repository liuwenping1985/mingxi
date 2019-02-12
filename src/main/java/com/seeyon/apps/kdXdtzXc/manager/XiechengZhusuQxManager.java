package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.apps.kdXdtzXc.po.XiechengZhusuQx;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface XiechengZhusuQxManager {

	public abstract List<XiechengZhusuQx> getAll() throws BusinessException;

	public abstract List<XiechengZhusuQx> getDataByIds(Long[] ids);

	public XiechengZhusuQx getDataById(Long id) throws BusinessException;

	public abstract void add(XiechengZhusuQx xiechengZhusuQx) throws BusinessException;

	public void update(XiechengZhusuQx xiechengZhusuQx) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListXiechengZhusuQxData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	
	//新增
	public void saveByAdd(HttpServletRequest request) throws  BusinessException ;
	
	//修改
	public void updateByZhusuQx(HttpServletRequest request) throws  BusinessException ;
	/*
	 * 根据城市名称和类别状态查找对应的合规  规则  vip酒店
	 */
	public List<XieChengVipJiuDianPo> gethrGui(String carName,String Type,String bigDate,String endDate);
	/*
	 * 根据城市名称和类别状态查找对应的合规  规则  协议酒店
	 */
	public List<XieChengXieYiJiuDiangPo> gethrGuiXieYi(String carName, String Type,String jiuDianName,String bigDate,String endDate);
}
