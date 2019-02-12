package com.seeyon.apps.kdXdtzXc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.City;
import com.seeyon.apps.kdXdtzXc.po.CityEntity;
import com.seeyon.ctp.util.DBAgent;

public class CityDaoImpl  implements CityDao{

	@Override
	public void insertCity(City city) {
		DBAgent.save(city);
		
	}

	@Override
	public List<City> getAllCity() {
		String hql="from City ";//ORDER BY NLSSORT(CityEName, 'NLS_SORT=SCHINESE_PINYIN_M')";
		List<City> cityList = DBAgent.find(hql);
		return cityList;
	}

	@Override
	public void insertCityEntity(CityEntity cityEntity) {
		DBAgent.save(cityEntity);
		
	}

	@Override
	public List<CityEntity> getAllCityEntity() {
		String hql="from CityEntity where countryName = :countryName ORDER BY NLSSORT(name_En, 'NLS_SORT=SCHINESE_PINYIN_M')";
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("countryName", "中国");
		List<CityEntity> cityEntityList = DBAgent.find(hql,map);
		return cityEntityList;
	}

}
