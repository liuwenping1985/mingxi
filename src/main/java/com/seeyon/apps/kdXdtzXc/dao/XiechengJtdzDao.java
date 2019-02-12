package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;

public interface XiechengJtdzDao {
	
	public List<XiechengJtdz> getAll();

	public List<XiechengJtdz> getDataByIds(Long[] ids);

	public XiechengJtdz getDataById(Long id);

	public void update(XiechengJtdz xiechengJtdz);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(XiechengJtdz xiechengJtdz);
	
	
	//从中间区获取交通对账数据插入到OA数据库
	void add(XiechengJtdz xiechengjtdz);
	//查询OA数据库是否已经存在相同数据，避免重复插入
	public List<Map<String, Object>> getOaList(String journeyid,String passengername,String takeofftime,String arrivaltime,String orderDetailType,String amount);
	/**
	 * 根据外键id查询关联数据
	 * @param id
	 * @return
	 */
	public List<XiechengJtdz> getDataByJiaoTongId(Long id,String extAttr3);
	
}
