package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;

import com.seeyon.apps.kdXdtzXc.dao.CityDao;
import com.seeyon.apps.kdXdtzXc.po.City;
import com.seeyon.apps.kdXdtzXc.po.CityEntity;

public class CityServiceImpl  implements CityService{
	private CityDao cityDao;
	
	public CityDao getCityDao() {
		return cityDao;
	}

	public void setCityDao(CityDao cityDao) {
		this.cityDao = cityDao;
	}

	@Override
	public void insertCity(City city) {
		cityDao.insertCity(city);
		
	}

	@Override
	public List<City> getAllCity() {
		List<City> allCity = cityDao.getAllCity();
		return allCity;
	}

	@Override
	public void insertCityEntity(CityEntity cityEntity) {
		cityDao.insertCityEntity(cityEntity);
		
	}

	@Override
	public List<CityEntity> getAllCityEntity() {
		List<CityEntity> allCityEntity = cityDao.getAllCityEntity();
		return allCityEntity;
	}

}
