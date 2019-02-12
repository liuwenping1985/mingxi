package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;

public interface CaiwuJtdzDao {
	public List<CaiwuJtdz> getAll();

	public List<CaiwuJtdz> getDataByIds(Long[] ids);

	public CaiwuJtdz getDataById(Long id);

	public void add(CaiwuJtdz caiwuJtdz);

	public void update(CaiwuJtdz caiwuJtdz);

	public void deleteAll(Long[] ids);

	public void deleteById(Long id);

	public void delete(CaiwuJtdz caiwuJtdz);
	
}
