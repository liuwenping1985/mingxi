package com.seeyon.apps.kdXdtzXc.scheduled;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.UUIDLong;

/**
 * 携程信息确认通过到携程获取数据更新表
 */
public class XieChengXinXiQueRenQuartz {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	/**
	 * 功能：获取出差人行程订单信息
	 * 1.定时查询当天（申请人出差信息确认）确认数据。条件：出差人不为空，其他出差信息为空的数据。
	 * 2.根据出差人登录名和审批单号查询DMZ数据库中出差人实际的出差日期
	 * 3.向表单中填充 确认信息数据 
	 */
	public void xinXiQueRen() {
		System.out.println("-----携程信息确认定时添加数据开始......");
		try {
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			String formman = (String) PropertiesUtils.getInstance().get("formman");
			String fromQueren = (String) PropertiesUtils.getInstance().get("formmanQuerenXinxi");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	        String date = format.format(new Date());
	        //(1)查询确认的数据
			// 信息确认表("+fromQueren+") 出差人id(field0031)不为空 | 出差日期(field0041 field0038)为空| 结束日期(field0042 field0039)为空| 总出差天数(field0043 field0040)为空 | 详细信息(field0036 field0033)为空
			String sql = "select main.ID as id,son.ID as sonId,son.field0031 as chuchairen,main.field0002 as orderId from "+formman+" AS main ";
			sql += "LEFT JOIN "+fromQueren+" AS son ON son.formmain_id = main.ID ";
			sql += "where main.start_date like '"+date+"%' and ";
			sql += "son.field0031 is not null and ";
			sql += "son.field0038 is null and ";
			sql += "son.field0039 is null and ";
			sql += "son.field0040 is null and ";
			sql += "son.field0033 is null ";
			List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
			for (Map<String, Object> map : queryForList) {
				Long id = map.get("id") == null ? 0: Long.valueOf(map.get("id")+"");
				Long sonId = map.get("sonId") == null ? 0: Long.valueOf(map.get("sonId")+"");
				String memberId = map.get("chuchairen") == null ? "": (String) map.get("chuchairen");
				String dingdanghao = map.get("orderId") == null ? "": (String) map.get("orderId");
				if (!memberId.equals("") && !dingdanghao.equals("")) {
					Long longnameID = Long.valueOf(memberId);
					String getLongName = "SELECT LOGIN_NAME FROM org_principal WHERE MEMBER_ID ="+ longnameID;
					List<Map<String, Object>> longName = jdbcTemplate.queryForList(getLongName);
					String loginName = longName.get(0).get("LOGIN_NAME") + "";
					Map<String, Object> cmap = new HashMap<String, Object>();
					cmap.put("memberName", loginName);
					cmap.put("dingdanghao", dingdanghao);
					
					// (2)根据出差人登录名和审批单号查询DMZ数据库中出差人实际的出差日期
					String getShijiRiqiURL = (String) PropertiesUtils.getInstance().get("getShijiRiqi");
					String res = HttpClientUtil.post(getShijiRiqiURL,cmap);
					JSONObject obj = new JSONObject(res);
					String message = obj.getString("success");
					if (message.equals("true")) {
						String begindate = obj.getString("beginDate");
						String endDate = obj.getString("endDate");
						String number = obj.getString("num");
						
						//出发日期(field0041  field0038 ) 结束日期(field0042 field0039) 出发总天数(field0043 field0040) 查询详情地址(field0036 field0033)  主表id(formmain_id) 出差人id(field0026) 
						//(3)向表单中填充 确认信息数据 
						String chuchaixiangqing = (String) PropertiesUtils.getInstance().get("chuchaixiangqing");
						String url = chuchaixiangqing + "&name="+ memberId + "&bianhao=" + dingdanghao + "";  //dingdanghao
						String updatesql = "update "+fromQueren+" set field0038='"+ begindate+ "',field0039='"+ endDate+ "',field0040="+ number+" ,field0033 ='"+ url+ "' where formmain_id = "+id+" and field0031="+memberId;
						jdbcTemplate.update(updatesql);
					}else{
						System.out.println("查询DMZ数据库中出差人实际的出差日期失败！");
						continue;
					}
				}
				//添加实际出差信息
				//addShijiXixin(sonId);
			}
			System.out.println("-----携程信息确认定时添加数据结束......");
		} catch (Exception e) {
			System.out.println("xinXiQueRen出现异常："+e.getMessage());
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 功能：将携程确认信息插入到实际信息表中
	 * @param xiechengId 携程信息确认表id
	 * @throws BusinessException
	 */
	public void addShijiXixin(Long xiechengId) {
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String formshiji = (String) PropertiesUtils.getInstance().get("formsonShijiXinxi");
		String fromQueren = (String) PropertiesUtils.getInstance().get("formmanQuerenXinxi");
		//信息确认表(formson_0099) 主表id(formmain_id)、排序(sort)、
		//序号(field0030)、出差人id(field0031)、出差日期(field0038)、返回日期(field0039)、总天数(field0040)
		String sql = "select * from "+fromQueren+" where id = " + xiechengId;
		List<Map<String, Object>> xiechengList = jdbcTemplate.queryForList(sql);
		if(xiechengList != null && xiechengList.size() > 0){
			for (Map<String, Object> map : xiechengList) {
				Long mianid = map.get("formmain_id") == null ? 0 : Long.valueOf(map.get("formmain_id")+"");
				int sort = map.get("sort") == null ? 0 : Integer.parseInt(map.get("sort")+"");
				int num = map.get("field0030") == null ? 0 : Integer.parseInt(map.get("field0030")+"");
				Long memberid = map.get("field0031") == null ? 0 : Long.valueOf(map.get("field0031")+"");
				String begin = map.get("field0038") == null ? "" : map.get("field0038")+"";
				String end = map.get("field0039") == null ? "" : map.get("field0039")+"";
				String count = map.get("field0040") == null ? "" : map.get("field0040")+"";
				
				//实际出差信息表（formson_0099）：主表id（formmain_id）、排序（sort）、序号（field0030）、出差人（field0031）、开始时间（field0038）、结束时间（field0039）、总天数（field0040）
				//检查如果存在相同的主表id和人员id则修改(回退的情况)
				String querysql = "select id from "+formshiji+" where 1=1 and formmain_id ="+mianid+" and field0026="+memberid;
				List<Map<String, Object>> shijiList = jdbcTemplate.queryForList(querysql);
				if(shijiList != null && shijiList.size()==0){
					//添加实际信息     formson_0099
					String insertxc = "INSERT INTO "+formshiji+" (id,formmain_id,sort,field0030,field0023,field0024,field0025,field0031) " +
							"VALUES ("+UUIDLong.longUUID()+","+mianid+","+sort+","+num+","+memberid+",'"+begin+"','"+end+"',"+count+")";
					jdbcTemplate.update(insertxc);
				}
				String deletenull = "delete from "+formshiji+" where 1=1 and field0023 is null and field0024 is null and field0025 is null and field0026 is null";
				jdbcTemplate.update(deletenull);
			}
		}
	}

}
