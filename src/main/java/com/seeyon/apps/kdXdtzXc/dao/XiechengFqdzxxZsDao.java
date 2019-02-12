package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxZs;

public interface XiechengFqdzxxZsDao {
	public List<XiechengFqdzxxZs> getAll();

	public List<XiechengFqdzxxZs> getDataByIds(Long[] ids);

	public XiechengFqdzxxZs getDataById(Long id);

	public void add(XiechengFqdzxxZs xiechengFqdzxxZs);

	public void update(XiechengFqdzxxZs xiechengFqdzxxZs);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(XiechengFqdzxxZs xiechengFqdzxxZs);
	
	public List<XiechengFqdzxxZs> getAllByFglyId();
	
	public List<Map<String, Object>> getByTime(int year,int month);
}
