package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxZs;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface XiechengFqdzxxZsManager {

	public abstract List<XiechengFqdzxxZs> getAll() throws BusinessException;

	public abstract List<XiechengFqdzxxZs> getDataByIds(Long[] ids);

	public XiechengFqdzxxZs getDataById(Long id) throws BusinessException;

	public abstract void add(XiechengFqdzxxZs xiechengFqdzxxZs) throws BusinessException;

	public void update(XiechengFqdzxxZs xiechengFqdzxxZs) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListXiechengFqdzxxZsData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	
	public List<Map<String, Object>> getByTime(int year,int month);
}
