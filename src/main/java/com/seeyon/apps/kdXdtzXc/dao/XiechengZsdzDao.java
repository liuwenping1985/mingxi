package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;

public interface XiechengZsdzDao {
	public List<XiechengZsdz> getAll();

	public List<XiechengZsdz> getDataByIds(Long[] ids);

	public XiechengZsdz getDataById(Long id);

	public void add(XiechengZsdz xiechengZsdz);

	public void update(XiechengZsdz xiechengZsdz);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(XiechengZsdz xiechengZsdz);
	
	//查询OA数据库是否已经存在相同数据，避免重复插入
	public List<Map<String, Object>> getOaList(String journeyid,String passengername,String takeofftime,String arrivaltime,String orderType,String amount);

	/**
	 * 根据外键id查询关联数据
	 * @param id
	 * @return
	 */
	public List<XiechengZsdz> getDataByZhuSuId(Long id,String extAttr3);
}
