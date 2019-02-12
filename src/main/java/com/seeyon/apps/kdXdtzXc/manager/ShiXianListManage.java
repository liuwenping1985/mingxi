package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public interface ShiXianListManage {
	
	//获取待办
	@AjaxAccess
	 public abstract FlipInfo getAllDaiBan(FlipInfo paramFlipInfo, Map<String, Object> params)throws BusinessException;

	public List<Map<String, Object>> getAllDaiBanShiXian();
	
	public List<Map<String, Object>> getAllYiBanShiXian();
	
	public List<Map<String, Object>> getAllYiFaShiXian();
}
