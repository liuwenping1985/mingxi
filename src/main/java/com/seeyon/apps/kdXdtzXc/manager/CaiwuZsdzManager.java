package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.seeyon.apps.kdXdtzXc.po.CaiwuZsdz;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface CaiwuZsdzManager {

	public abstract List<CaiwuZsdz> getAll() throws BusinessException;

	public abstract List<CaiwuZsdz> getDataByIds(Long[] ids);

	public CaiwuZsdz getDataById(Long id) throws BusinessException;

	public abstract void add(CaiwuZsdz caiwuZsdz) throws BusinessException;

	public void update(CaiwuZsdz caiwuZsdz) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListCaiwuZsdzData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	/**修改支付——住宿**/
	public void updateZhifu(Long id) throws BusinessException;
	/**
	 * 财务住宿poi导出
	 * @return
	 */
	public List<CaiwuZsdz> getPoiZs(String dateState);
	
	public void updateHeguiZS(Long id);
	@AjaxAccess
	public abstract FlipInfo getListCaiwuZsdzDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException;
	
	public String getZsSum(String bigDate)throws ParseException;
}
