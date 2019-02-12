package com.seeyon.apps.kdXdtzXc.scheduled;

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
import com.seeyon.apps.kdXdtzXc.manager.XiechengJtdzManager;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPFlight;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.UUIDLong;

/**
 * 查询DMZ区中的机票结算数据，插入到OA表中
 */
public class JipiaoJieshuScheduled {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	/**
	 * 功能：查询DMZ区中的机票结算数据，插入到OA表中
	 * @throws BusinessException
	 */
	public void getJipiaoDateToOa()throws BusinessException {
		try {
			XiechengJtdzManager xiechengJtdzManager = (XiechengJtdzManager) AppContext.getBean("xiechengJtdzManager");
			XiechengFqdzxxJtManager xiechengFqdzxxJtManager = (XiechengFqdzxxJtManager)AppContext.getBean("xiechengFqdzxxJtManager");
			// 机票接口URL
			String xieChengJiPiao_Url = (String) PropertiesUtils.getInstance().get("xieChengJiPiao");
			// 根据URL获取接口返回的json串
			String responseResult = HttpClientUtil.post(xieChengJiPiao_Url, "");

			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);
			//拿到中间区机票结算数据
			String jsonJipiao = jsonObject.optString("jipiaojsList");
			XiechengERPFlight[] xiechengJipiaoList = (XiechengERPFlight[]) JSONArray.toArray(JSONArray.fromObject(jsonJipiao), XiechengERPFlight.class);
			XiechengJtdz xiechengjtdz = new XiechengJtdz();
			XiechengFqdzxxJt xiechengFqdzxxJt = new XiechengFqdzxxJt();
			if (xiechengJipiaoList.length > 0 && xiechengJipiaoList != null) {
				
				//获取系统时间作为创建时间
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				String createTime = sdf.format(new Date());
				Calendar calendar=Calendar.getInstance();
				//获得当前时间的年份
				int year=calendar.get(Calendar.YEAR);
				//获得当前时间的月份，月份从0开始所以结果要加1
				int month=calendar.get(Calendar.MONTH)+1;
				//携程发起对帐信息住宿
				xiechengFqdzxxJt.setId(UUIDLong.longUUID());	//Id
				xiechengFqdzxxJt.setYear(String.valueOf(year));	//年
				xiechengFqdzxxJt.setMonth(String.valueOf(month));//月
				xiechengFqdzxxJt.setTqTime(createTime);//提取时间
				//xiechengFqdzxxZs.setDzTime("");//对账时间
				xiechengFqdzxxJtManager.add(xiechengFqdzxxJt);//添加携程发起对帐信息住宿表数据
				
				//遍历数据往XiechengJtdz赋值
				for (XiechengERPFlight xiechengERPFlight : xiechengJipiaoList) {
					Long uuid = UUIDLong.longUUID();
					String journeyid = xiechengERPFlight.getJourneyID();
					String passengername = xiechengERPFlight.getPassengerName();
					String takeofftime = xiechengERPFlight.getTakeoffTime();
					String arrivaltime = xiechengERPFlight.getArrivalTime();
					String orderDetailType = xiechengERPFlight.getOrderDetailType();
					Double amount = xiechengERPFlight.getAmount();
					String amountS="";
					if(amount != null){
						amountS=String.valueOf(amount);
					}
					//申请单编号journeyid乘机人姓名passengername起飞时间takeofftime到达时间arrivaltime判断OA数据库中是否已经存在这条数据
					List<Map<String, Object>> oaList = xiechengJtdzManager.getOaList(journeyid, passengername, takeofftime, arrivaltime,orderDetailType,amountS);
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
					xiechengjtdz.setFeeType(xiechengERPFlight.getFeeType());
					xiechengjtdz.setRemark(xiechengERPFlight.getRemark());
					xiechengjtdz.setExtAttr1(orderDetailType);//退改签
					//获取系统时间作为创建时间
					xiechengjtdz.setCreateTime(createTime);
					//调用manager层中的添加方法
					xiechengJtdzManager.add(xiechengjtdz);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
}
