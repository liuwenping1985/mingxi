package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public abstract interface CaiwuJtdzManager {

	public abstract List<CaiwuJtdz> getAll() throws BusinessException;

	public abstract List<CaiwuJtdz> getDataByIds(Long[] ids);

	public CaiwuJtdz getDataById(Long id) throws BusinessException;

	public abstract void add(CaiwuJtdz caiwuJtdz) throws BusinessException;

	public void update(CaiwuJtdz caiwuJtdz) throws BusinessException;

	public void deleteAll(Long[] ids) throws BusinessException;

	public void deleteById(Long id) throws BusinessException;
	
	@AjaxAccess
	public abstract FlipInfo getListCaiwuJtdzData(FlipInfo paramFlipInfo, Map<String, Object> paramMap) throws BusinessException;
	
	/**修改支付**/
	public void updateZhifu(Long id) throws BusinessException;
	
	public List<CaiwuJtdz> getPoiCaiwuJtdz(String date);
	
	public void updateHeguiJT(Long id);

	@AjaxAccess
	public abstract FlipInfo getListCaiwuJtdzDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException,ParseException;
	
	public String getJtSum(String bigDate)throws ParseException;
	
	
	public void updateXieChengfqdzxxjt(String year ,String month);
	
	public List<XiechengFqdzxxJt> getXieChengfqdzxxjt(String year ,String month);
	
	//携程接口
	public String getJsonJT(List<Map<String,Object>> jtList) throws ParseException;
	public String getJsonJD(List<Map<String,Object>> jdList) throws ParseException;
}
