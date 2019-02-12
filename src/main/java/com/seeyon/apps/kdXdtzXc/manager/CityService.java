package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.City;
import com.seeyon.apps.kdXdtzXc.po.CityEntity;

public interface CityService {
	
	public void insertCity(City city);
	
	public List<City> getAllCity();
	
	
	//插入城市名称机票
	public void insertCityEntity(CityEntity cityEntity);
	//插入城市机票
	public List<CityEntity> getAllCityEntity();

}
