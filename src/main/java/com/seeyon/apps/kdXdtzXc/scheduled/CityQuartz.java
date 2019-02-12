package com.seeyon.apps.kdXdtzXc.scheduled;

import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.manager.CityService;
import com.seeyon.apps.kdXdtzXc.po.City;
import com.seeyon.apps.kdXdtzXc.po.CityEntity;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.util.UUIDLong;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * 查询补助信息
 */
public class CityQuartz {
	private static Log log = LogFactory.getLog(XieChengJiPiaoZhuSu.class);
	private JdbcTemplate jdbcTemplate;
	private CityService cityService;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	public CityService getCityService() {
		return cityService;
	}

	public void setCityService(CityService cityService) {
		this.cityService = cityService;
	}

	public void getXieChengAll(){ 
		try {
			System.out.println("jingru");
			log.info("**********进入getXieChengAll 测试携程是否可以访问");
				//http://100.21.76.2:8044/xiecheng/cityApi/getJDcityName.do
			String getCityAll=HttpClientUtil.post("http://96.19.170.24:8044/xiecheng/cityApi/getJDcityName.do","");
			String geiData =((JSONObject)JSONSerializer.toJSON(getCityAll)).optString("postData");
			String getCity=((JSONObject)JSONSerializer.toJSON(geiData)).optString("Data");
			List<City> cityList = JSONUtilsExt.fromListJson(getCity, City.class);
			if(cityList != null && cityList.size() > 0){
			for (City city : cityList) {
				String uId=String.valueOf(UUIDLong.longUUID());
				city.setId(uId);
				cityService.insertCity(city);
			}
		}
			/*String getCityEntityAll=HttpClientUtil.post("http://localhost:8080/teaglepf/cityApi/getJPcityName.do","");
			String datas =((JSONObject)JSONSerializer.toJSON(getCityEntityAll)).optString("postData");
			String geiCityEntity =((JSONObject)JSONSerializer.toJSON(datas)).optString("datas");
			List<CityEntity> CityEntityList = JSONUtilsExt.fromListJson(geiCityEntity, CityEntity.class);
			if(CityEntityList != null && CityEntityList.size() > 0){
			for (CityEntity cityEntity : CityEntityList) {
				String uId=String.valueOf(UUIDLong.longUUID());
				cityEntity.setId(uId);
				cityService.insertCityEntity(cityEntity);
			}
		}*/
			//用不到了只要酒店的
		/*	Callable<Integer> callable1 = new Callable<Integer>(){

				@Override
				public Integer call() throws Exception {
					log.info("**********携程城市添加");
					//http://100.21.76.2:8044/xiecheng/cityApi/getJDcityName.do
				String getCityAll=HttpClientUtil.post("http://localhost:8080/teaglepf/cityApi/getJDcityName.do","");
				String geiData =((JSONObject)JSONSerializer.toJSON(getCityAll)).optString("postData");
				String getCity=((JSONObject)JSONSerializer.toJSON(geiData)).optString("Data");
				List<City> cityList = JSONUtilsExt.fromListJson(getCity, City.class);
				if(cityList != null && cityList.size() > 0){
				for (City city : cityList) {
					String uId=String.valueOf(UUIDLong.longUUID());
					city.setId(uId);
					cityService.insertCity(city);
				}
			}
					return 1;
				}};
			
				Callable<Integer> call=new Callable<Integer>(){

					@Override
					public Integer call() throws Exception {
						String getCityEntityAll=HttpClientUtil.post("http://localhost:8080/teaglepf/cityApi/getJPcityName.do","");
						String datas =((JSONObject)JSONSerializer.toJSON(getCityEntityAll)).optString("postData");
						String geiCityEntity =((JSONObject)JSONSerializer.toJSON(datas)).optString("datas");
						List<CityEntity> CityEntityList = JSONUtilsExt.fromListJson(geiCityEntity, CityEntity.class);
						if(CityEntityList != null && CityEntityList.size() > 0){
						for (CityEntity cityEntity : CityEntityList) {
							String uId=String.valueOf(UUIDLong.longUUID());
							cityEntity.setId(uId);
							cityService.insertCityEntity(cityEntity);
						}
					}
						return 1;
					}};
			FutureTask<Integer> futureTask = new FutureTask<Integer>(callable1);
			FutureTask<Integer> callFutureTask = new FutureTask<Integer>(call);
			//最好线程池
			new Thread(futureTask).start();//酒店
			new Thread(callFutureTask).start();//飞机
			Integer integer = futureTask.get();
			Integer integer2 = callFutureTask.get();
			log.info(integer+"携程数据插入完成"+integer2);*/
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
	
}
