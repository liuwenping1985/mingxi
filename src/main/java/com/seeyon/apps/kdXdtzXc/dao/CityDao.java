package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.po.City;
import com.seeyon.apps.kdXdtzXc.po.CityEntity;

public interface CityDao {
	//插入酒店携程接口获取的城市名称
	public void insertCity(City city);
	//获取城市名称酒店
	public List<City> getAllCity();
	//插入城市名称机票
	public void insertCityEntity(CityEntity cityEntity);
	//插入城市机票
	public List<CityEntity> getAllCityEntity();

}
