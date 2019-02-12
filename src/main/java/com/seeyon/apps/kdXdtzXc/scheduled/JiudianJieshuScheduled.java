package com.seeyon.apps.kdXdtzXc.scheduled;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.manager.XiechengFqdzxxJtManager;
import com.seeyon.apps.kdXdtzXc.manager.XiechengFqdzxxZsManager;
import com.seeyon.apps.kdXdtzXc.manager.XiechengJtdzManager;
import com.seeyon.apps.kdXdtzXc.manager.XiechengZsdzManager;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPFlight;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPHotel;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxZs;
import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.UUIDLong;

/**
 * 查询DMZ区中的酒店结算数据，插入到OA表中
 */
public class JiudianJieshuScheduled {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	/**
	 * 功能：查询DMZ区中的酒店结算数据，插入到OA表中
	 * @throws BusinessException
	 */
	public void getJiudianDateToOa()throws BusinessException {
		XiechengZsdzManager xiechengZsdzManager = (XiechengZsdzManager) AppContext.getBean("xiechengZsdzManager");
		XiechengFqdzxxZsManager xiechengFqdzxxZsManager = (XiechengFqdzxxZsManager) AppContext.getBean("xiechengFqdzxxZsManager");
		try {
			//酒店接口URL
			String xieChengJiudian_Url = (String) PropertiesUtils.getInstance().get("xieChengJiudian");
			//根据URL获取接口返回的json串
			String responseResult = HttpClientUtil.post(xieChengJiudian_Url,"");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);
			String jsonJipiao  = jsonObject.optString("zhusujsList");
			XiechengERPHotel[] xiechengERPHotel =(XiechengERPHotel[])JSONArray.toArray(JSONArray.fromObject(jsonJipiao),XiechengERPHotel.class);
			XiechengZsdz xiechengZsdz = new XiechengZsdz();
			XiechengFqdzxxZs xiechengFqdzxxZs = new XiechengFqdzxxZs();
			if(xiechengERPHotel != null && xiechengERPHotel.length >0){
				//获取系统时间作为创建时间
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				String createTime = sdf.format(new Date());
				Calendar calendar=Calendar.getInstance();
				//获得当前时间的年份
				int year=calendar.get(Calendar.YEAR);
				//获得当前时间的月份，月份从0开始所以结果要加1
				int month=calendar.get(Calendar.MONTH)+1;
				//携程发起对帐信息住宿
				xiechengFqdzxxZs.setId(UUIDLong.longUUID());	//Id
				xiechengFqdzxxZs.setYear(String.valueOf(year));	//年
				xiechengFqdzxxZs.setMonth(String.valueOf(month));//月
				xiechengFqdzxxZs.setTqTime(createTime);//提取时间
				//xiechengFqdzxxZs.setDzTime("");//对账时间
				xiechengFqdzxxZsManager.add(xiechengFqdzxxZs);//添加携程发起对帐信息住宿表数据
				
				for (XiechengERPHotel entity : xiechengERPHotel) {
					Long uuid =  UUIDLong.longUUID();//创建一个随机ID
					
					String joruneyId = entity.getOrderID();
					String passengerName = entity.getClientName();
					String startTime = entity.getStartTime();
					String endTime = entity.getEndTime();
					String detailType = entity.getRemarks();
					
					//携程住宿对账表
					xiechengZsdz.setId(uuid);//id
					xiechengZsdz.setJourneyId(entity.getHotelRelatedJourneyNo());//申请单编号
					xiechengZsdz.setClientName(passengerName);//预住人姓名
					xiechengZsdz.setCityName(entity.getCityName());//酒店所在城市
					xiechengZsdz.setHotelName(entity.getHotelName());//酒店名称
					xiechengZsdz.setHotelType(entity.getHotelType());//酒店类型
					xiechengZsdz.setRoomName(entity.getRoomName());//房间类型
					xiechengZsdz.setStartTime(startTime);//预入住日期
					xiechengZsdz.setEndTime(endTime);//预离店日期
					xiechengZsdz.setQuantity(String.valueOf(entity.getQuantity()));//夜间数
					xiechengZsdz.setPrice(String.valueOf(entity.getPrice()));//单价
					xiechengZsdz.setAmount(String.valueOf(entity.getAmount()));//费用
					xiechengZsdz.setFeeType("");//费用类型
					xiechengZsdz.setRemarks(entity.getRemarks());//备注
					xiechengZsdz.setCreateTime(createTime);//创建时间
					
					//申请单编号journeyid预住人姓名passengername预入住日期startTime离店日期endTime判断OA数据库中是否已经存在这条数据
					List<Map<String, Object>> oaList = xiechengZsdzManager.getOaList(joruneyId, passengerName, startTime, endTime,detailType,String.valueOf(entity.getAmount()));
					//如果已经存在该条数据，则跳出本次循环，不添加数据
					if(oaList.size()>0 && oaList !=null){
						continue;
					}
					xiechengZsdzManager.add(xiechengZsdz);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
}
