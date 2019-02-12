package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface XiechengFqdzxxJtManager {

	public abstract List<XiechengFqdzxxJt> getAll() throws BusinessException;

	public abstract List<XiechengFqdzxxJt> getDataByIds(Long[] ids);

	public XiechengFqdzxxJt getDataById(Long id) throws BusinessException;

	public abstract void add(XiechengFqdzxxJt xiechengFqdzxxJt) throws BusinessException;

	public void update(XiechengFqdzxxJt xiechengFqdzxxJt) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListXiechengFqdzxxJtData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException , ParseException;
	
	public List<Map<String, Object>> getByTime(int year,int month);
	
	/**根据Id修改**/
	public void updateById(Long id) throws BusinessException;
}
