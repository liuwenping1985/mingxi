package com.seeyon.apps.kdXdtzXc.scheduled;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.manager.XiechengFqdzxxJtManager;
import com.seeyon.apps.kdXdtzXc.manager.XiechengJtdzManager;
import com.seeyon.apps.kdXdtzXc.manager.XiechengZsdzManager;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPFlight;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPHotel;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.UUIDLong;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class XieChengDuiZhang {
	
	
	private static final Log LOGGER = LogFactory.getLog(XieChengDuiZhang.class);
	
	private JdbcTemplate jdbcTemplate;
	
	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}
	
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	private XiechengJtdzManager xiechengJtdzManager;

	public XiechengJtdzManager getXiechengJtdzManager() {
		return xiechengJtdzManager;
	}

	public void setXiechengJtdzManager(XiechengJtdzManager xiechengJtdzManager) {
		this.xiechengJtdzManager = xiechengJtdzManager;
	}
	    
    private XiechengZsdzManager xiechengZsdzManager;

    public XiechengZsdzManager getXiechengZsdzManager() {
		return xiechengZsdzManager;
	}

	public void setXiechengZsdzManager(XiechengZsdzManager xiechengZsdzManager) {
		this.xiechengZsdzManager = xiechengZsdzManager;
	}
	
	public void xieChengDuiZhang()throws BusinessException, NumberFormatException, ParseException {
		//获取系统时间作为创建时间
		SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd");
		String ex = format.format(new Date());
		String createTime = format.format(new Date());
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		String time = format.format(calendar.getTime());
		String year = time.substring(0,4);
		String month = time.substring(time.length()-5,time.length()-3);

		LOGGER.info(ex+"：执行同步携*程结算数据。。。。");
		
		Calendar cal=Calendar.getInstance();
		cal.setTime(new Date());
		int years=cal.get(Calendar.YEAR);
		int months=cal.get(Calendar.MONTH)+1;
		
		
        //在携程发起对帐信息添加一条信息（每月添加一次）
        System.out.println("+++++++++++++++++++++++++++++++++++++++++++");
		XiechengFqdzxxJtManager xiechengFqdzxxJtManager = (XiechengFqdzxxJtManager)AppContext.getBean("xiechengFqdzxxJtManager");
		
		if(months == 12){
			//携程发起对帐信息住宿
			XiechengFqdzxxJt xiechengFqdzxxJt = new XiechengFqdzxxJt();
			String id = null;
			id = String.valueOf(UUIDLong.longUUID());
			xiechengFqdzxxJt.setId(Long.valueOf(id));	//Id
			xiechengFqdzxxJt.setYear(String.valueOf(years));	//年
			xiechengFqdzxxJt.setMonth(String.valueOf(months));//月
			Calendar calendar2 = Calendar.getInstance();
			calendar2.add(Calendar.MONTH, 1);
			String time2 = format.format(calendar2.getTime());
			xiechengFqdzxxJt.setTqTime(time2);//提取时间
			xiechengFqdzxxJt.setExtAttr1("未发起");//总部状态
			xiechengFqdzxxJt.setBfType("未发起");
			xiechengFqdzxxJt.setHbType("未发起");
			xiechengFqdzxxJt.setJsType("未发起");
			List<Map<String, Object>>  xiangxiList = xiechengFqdzxxJtManager.getByTime(Integer.valueOf(years),Integer.valueOf(months));
			Map<String, Object> map = new HashMap<String, Object>();
			if(xiangxiList.size()==0 || xiangxiList==null){
				xiechengFqdzxxJtManager.add(xiechengFqdzxxJt);//添加携程发起对帐信息住宿表数据
			}else{
				map=xiangxiList.get(0);
				id = map.get("id").toString();
			}
			
			String [] arr ={"-1792902092017745579","2662344410291130278","1755267543710320898","-5358952287431081185"};
			for (int i = 0; i < arr.length; i++) {
			getFlightInfo(calendar,createTime,Long.valueOf(id),format.format(new Date()),arr[i]);
			getHotelInfo(calendar,createTime,Long.valueOf(id),format.format(new Date()),arr[i]);
			}
		}
		
		
		
		
		//携程发起对帐信息住宿
		XiechengFqdzxxJt xiechengFqdzxxJt = new XiechengFqdzxxJt();
		String id = null;
		id = String.valueOf(UUIDLong.longUUID());
		xiechengFqdzxxJt.setId(Long.valueOf(id));	//Id
		xiechengFqdzxxJt.setYear(String.valueOf(year));	//年
		xiechengFqdzxxJt.setMonth(String.valueOf(month));//月
		xiechengFqdzxxJt.setTqTime(createTime);//提取时间
		xiechengFqdzxxJt.setExtAttr1("未发起");//总部状态
		xiechengFqdzxxJt.setBfType("未发起");
		xiechengFqdzxxJt.setHbType("未发起");
		xiechengFqdzxxJt.setJsType("未发起");
		List<Map<String, Object>>  xiangxiList = xiechengFqdzxxJtManager.getByTime(Integer.valueOf(year),Integer.valueOf(month));
		Map<String, Object> map = new HashMap<String, Object>();
		if(xiangxiList.size()==0 || xiangxiList==null){
			xiechengFqdzxxJtManager.add(xiechengFqdzxxJt);//添加携程发起对帐信息住宿表数据
		}else{
			map=xiangxiList.get(0);
			id = map.get("id").toString();
		}
		
		String [] arr ={"-1792902092017745579","2662344410291130278","1755267543710320898","-5358952287431081185"};
		for (int i = 0; i < arr.length; i++) {
			getFlightInfo(calendar,createTime,Long.valueOf(id),time,arr[i]);
			getHotelInfo(calendar,createTime,Long.valueOf(id),time,arr[i]);
		}
	}
	
	/**
	 * 功能：获取交通机票数据        
	 * @param calendar
	 * @throws ParseException 
	 */
	public void getFlightInfo(Calendar calendar,String createTime,long id,String month,String accountIds)throws BusinessException, ParseException {

        System.out.println("====================同步携程交通结算数据_开始====================");
        //xiechengJtdzManager.xiechengJiaoTongJieShuan();//添加携程交通对账数据
        XiechengJtdzManager xiechengJtdzManager = (XiechengJtdzManager) AppContext.getBean("xiechengJtdzManager");
		// 机票接口URL
		String xieChengJiPiao_Url = (String) PropertiesUtils.getInstance().get("xieChengJiPiao");
		if(jdbcTemplate == null){
			 jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		}
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("month", month);
		map.put("accountId", accountIds);
		// 根据URL获取接口返回的json串
		String responseResult = HttpClientUtil.post(xieChengJiPiao_Url, map);

		JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);
		//拿到中间区机票结算数据
		String jsonJipiao = jsonObject.optString("jipiaojsList");
		XiechengERPFlight[] xiechengJipiaoList = (XiechengERPFlight[]) JSONArray.toArray(JSONArray.fromObject(jsonJipiao), XiechengERPFlight.class);
		XiechengJtdz xiechengjtdz = new XiechengJtdz();
		if (xiechengJipiaoList.length > 0 && xiechengJipiaoList != null) {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar1 = Calendar.getInstance();
			calendar1.setTime(dateFormat.parse(month));
			calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMinimum(Calendar.DAY_OF_MONTH));
		Date beginTo = calendar1.getTime();
			
	            calendar1.setTime(dateFormat.parse(month));
	            calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMaximum(Calendar.DAY_OF_MONTH));
	            Date endTo = calendar1.getTime();
			
			/*String deleteSql="DELETE FROM XIECHENG_JTDZ WHERE CREATE_TIME >='"+dateFormat.format(beginTo)+"' AND CREATE_TIME <='"+dateFormat.format(endTo)+"'";
			jdbcTemplate.update(deleteSql);*/
			
			
			//遍历数据往XiechengJtdz赋值
			for (XiechengERPFlight xiechengERPFlight : xiechengJipiaoList) {
				Long uuid = UUIDLong.longUUID();
				String journeyid = xiechengERPFlight.getJourneyID();
				String passengername = xiechengERPFlight.getPassengerName();
				String takeofftime = xiechengERPFlight.getTakeoffTime();
				takeofftime = takeofftime.substring(0, 10);
				String arrivaltime = xiechengERPFlight.getArrivalTime();
				arrivaltime = arrivaltime.substring(0, 10);
				String orderDetailType = xiechengERPFlight.getOrderDetailType();
				String employeeID = xiechengERPFlight.getEmployeeID();
				Double amount = xiechengERPFlight.getAmount();
				String createTime2 = xiechengERPFlight.getCreateTime();//携程创建日期
				createTime2 = createTime2.substring(0, 10);
				
				String sql="SELECT m.ORG_ACCOUNT_ID AS ORGACCOUNTID FROM ORG_MEMBER m LEFT JOIN ORG_PRINCIPAL p ON m.ID = p.MEMBER_ID WHERE p.LOGIN_NAME = '"+employeeID+"'";
				List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
				String orgAccountId="";
				if(queryForList != null && queryForList.size() > 0){
					 orgAccountId=queryForList.get(0).get("ORGACCOUNTID")+"";
				}
				if(amount == null){
					amount=0.00;

				}
				String amountS="";
				if(amount != null){
					amountS=String.valueOf(amount);
				}
				String recordid=xiechengERPFlight.getRecordId();
				String accCheckBatchNo = xiechengERPFlight.getAccCheckBatchNo();
				//申请单编号journeyid乘机人姓名passengername起飞时间takeofftime到达时间arrivaltime判断OA数据库中是否已经存在这条数据
				List<Map<String, Object>> oaList = xiechengJtdzManager.getOaList(recordid, accCheckBatchNo, takeofftime, arrivaltime,orderDetailType,amountS);
				//如果已经存在该条数据，则跳出本次循环，不添加数据
				if(oaList.size()>0 && oaList !=null){
					continue;
				}
				
				xiechengjtdz.setId(uuid);
				xiechengjtdz.setJourneyId(journeyid);
				xiechengjtdz.setPassengerName(passengername);
				xiechengjtdz.setTakeoffTime(takeofftime);
				xiechengjtdz.setArrivalTime(arrivaltime);
				xiechengjtdz.setDcityName(xiechengERPFlight.getdCityName());
				xiechengjtdz.setAcityName(xiechengERPFlight.getaCityName());
				xiechengjtdz.setFlight(xiechengERPFlight.getFlight());
				xiechengjtdz.setClassName(xiechengERPFlight.getClassName());
				xiechengjtdz.setAmount(String.valueOf(xiechengERPFlight.getAmount()));
				xiechengjtdz.setFeeType("机票");
				xiechengjtdz.setRemark(orderDetailType);
				xiechengjtdz.setExtAttr1(orderDetailType);//退改签
				xiechengjtdz.setEmployeeID(employeeID);//员工编号
				xiechengjtdz.setExtAttr3(orgAccountId);//组织机构类别
				//获取系统时间作为创建时间
				xiechengjtdz.setCreateTime(createTime2);
				xiechengjtdz.setXiechengFqdzxxJtId(id);
				xiechengjtdz.setOrderId(xiechengERPFlight.getOrderId());
				xiechengjtdz.setRecordId(xiechengERPFlight.getRecordId());
				xiechengjtdz.setAccCheckBatchNo(xiechengERPFlight.getAccCheckBatchNo());
				//调用manager层中的添加方法
				xiechengJtdzManager.add(xiechengjtdz);
			}
		}
        System.out.println("====================同步携程交通结算数据_结束====================");
	}

	
	
	public void getHotelInfo(Calendar calendar,String createTime,long id,String month,String accountIds)throws BusinessException, ParseException {

        System.out.println("====================同步携程酒店结算数据_开始====================");
        
        XiechengZsdzManager xiechengZsdzManager = (XiechengZsdzManager)AppContext.getBean("xiechengZsdzManager");
        //xiechengZsdzManager.xiechengJiudianJieShuan();
        //酒店接口URL
		String xieChengJiudian_Url = (String) PropertiesUtils.getInstance().get("xieChengJiudian");
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("month", month);
		map.put("accountId", accountIds);
		//根据URL获取接口返回的json串
		String responseResult2 = HttpClientUtil.post(xieChengJiudian_Url,map);
		JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(responseResult2);
		String jsonJiudian  = jsonObject2.optString("zhusujsList");
		XiechengERPHotel[] xiechengERPHotel =(XiechengERPHotel[])JSONArray.toArray(JSONArray.fromObject(jsonJiudian),XiechengERPHotel.class);
		XiechengZsdz xiechengZsdz = new XiechengZsdz();
		if(xiechengERPHotel != null && xiechengERPHotel.length >0){
			//获取系统时间作为创建时间
			SimpleDateFormat sdft = new SimpleDateFormat("yyyy-MM-dd");
			String createTime2 = sdft.format(new Date());
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar1 = Calendar.getInstance();
			calendar1.setTime(dateFormat.parse(month));
			calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMinimum(Calendar.DAY_OF_MONTH));
		Date beginTo = calendar1.getTime();
			
	            calendar1.setTime(dateFormat.parse(month));
	            calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMaximum(Calendar.DAY_OF_MONTH));
	            Date endTo = calendar1.getTime();
			
			 /*String deleteSql="DELETE FROM XIECHENG_ZSDZ WHERE CREATE_TIME >='"+dateFormat.format(beginTo)+"' AND CREATE_TIME <='"+dateFormat.format(endTo)+"'";
			 jdbcTemplate.update(deleteSql);*/
			
			for (XiechengERPHotel entity : xiechengERPHotel) {
				Long uuid =  UUIDLong.longUUID();//创建一个随机ID
				
				String joruneyId = String.valueOf(entity.getHotelRelatedJourneyNo());
				String passengerName = entity.getClientName();
				String startTime2 = entity.getStartTime();
				String endTime2 = entity.getEndTime();
				String detailType = entity.getRemarks();
				String employeeID = entity.getEmployeeID();
				startTime2 = startTime2.substring(0, 10);
				endTime2 = endTime2.substring(0, 10);
				String createTime3 = entity.getCreateTime();//携程创建日期
				createTime3 = createTime3.substring(0, 10);
				if(jdbcTemplate == null){
					 jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
				}
				String sql="SELECT m.ORG_ACCOUNT_ID AS ORGACCOUNTID FROM ORG_MEMBER m LEFT JOIN ORG_PRINCIPAL p ON m.ID = p.MEMBER_ID WHERE p.LOGIN_NAME = '"+employeeID+"'";
				List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
				String orgAccountId="";
				if(queryForList != null && queryForList.size() > 0){
					 orgAccountId=queryForList.get(0).get("ORGACCOUNTID")+"";
				}
				//携程住宿对账表
				xiechengZsdz.setId(uuid);//id
				xiechengZsdz.setJourneyId(joruneyId);//申请单编号
				xiechengZsdz.setClientName(passengerName);//预住人姓名
				xiechengZsdz.setCityName(entity.getCityName());//酒店所在城市
				xiechengZsdz.setHotelName(entity.getHotelName());//酒店名称
				//会员酒店--H；协议酒店--X
				xiechengZsdz.setHotelType(entity.getHotelType());//酒店类型
				xiechengZsdz.setRoomName(entity.getRoomName());//房间类型
				xiechengZsdz.setStartTime(startTime2);//预入住日期
				xiechengZsdz.setEndTime(endTime2);//预离店日期
				xiechengZsdz.setQuantity(String.valueOf(entity.getQuantity()));//夜间数
				xiechengZsdz.setPrice(String.valueOf(entity.getPrice()));//单价
				xiechengZsdz.setAmount(String.valueOf(entity.getAmount()));//费用
				xiechengZsdz.setFeeType("酒店");//费用类型
				String remarkType=entity.getRemarks();
				if("O".equals(remarkType)){
					xiechengZsdz.setRemarks("出票");//备注
				}else if("R".equals(remarkType)){
					xiechengZsdz.setRemarks("退票");
				}
				String amount =String.valueOf(entity.getAmount());
				xiechengZsdz.setCreateTime(createTime3);//创建时间
				xiechengZsdz.setEmployeeID(employeeID);//员工编号
				xiechengZsdz.setXiechengFqdzxxZsId(id);
				xiechengZsdz.setExtAttr3(orgAccountId);
				xiechengZsdz.setOrderId(entity.getOrderID());
				xiechengZsdz.setRecordId(entity.getRecordId());
				xiechengZsdz.setAccCheckBatchNo(entity.getAccCheckBatchNo());
				String recordId=entity.getRecordId();
				String accCheckBatchNo= entity.getAccCheckBatchNo();
				//申请单编号journeyid预住人姓名passengername预入住日期startTime离店日期endTime判断OA数据库中是否已经存在这条数据
				List<Map<String, Object>> oaHotelList = xiechengZsdzManager.getOaList(recordId, accCheckBatchNo, startTime2, endTime2,detailType,amount);
				//如果已经存在该条数据，则跳出本次循环，不添加数据
				if(oaHotelList.size()>0 && oaHotelList !=null){
					continue;
				}
				xiechengZsdzManager.add(xiechengZsdz);
			}
		}
        System.out.println("====================同步携程酒店结算数据_结束====================");
	}
}
