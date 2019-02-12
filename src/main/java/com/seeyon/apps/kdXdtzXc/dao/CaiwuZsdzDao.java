package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.CaiwuZsdz;

public interface CaiwuZsdzDao {
	public List<CaiwuZsdz> getAll();

	public List<CaiwuZsdz> getDataByIds(Long[] ids);

	public CaiwuZsdz getDataById(Long id);

	public void add(CaiwuZsdz caiwuZsdz);

	public void update(CaiwuZsdz caiwuZsdz);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(CaiwuZsdz caiwuZsdz);
	
}
