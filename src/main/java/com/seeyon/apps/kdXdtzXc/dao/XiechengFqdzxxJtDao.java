package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;

public interface XiechengFqdzxxJtDao {
	public List<XiechengFqdzxxJt> getAll();

	public List<XiechengFqdzxxJt> getDataByIds(Long[] ids);

	public XiechengFqdzxxJt getDataById(Long id);

	public void add(XiechengFqdzxxJt xiechengFqdzxxJt);

	public void update(XiechengFqdzxxJt xiechengFqdzxxJt);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(XiechengFqdzxxJt xiechengFqdzxxJt);
	
	public List<XiechengFqdzxxJt> getAllByFglyId();
	
	public List<Map<String, Object>> getByTime(int year,int month);
}
