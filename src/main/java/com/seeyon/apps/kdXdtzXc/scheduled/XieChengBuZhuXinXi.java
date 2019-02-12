package com.seeyon.apps.kdXdtzXc.scheduled;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.UUIDLong;

/**
 * 查询补助信息
 */
public class XieChengBuZhuXinXi {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	/**
	 * 功能：定时获取补助信息，添加到补助信息表 前一天已结束的流程数据
	 * 
	 * @throws BusinessException
	 */
	public void xieChengQueryBuZhu() throws BusinessException {
		SimpleDateFormat shortSdf = new SimpleDateFormat("yyyy-MM-dd");
		String createDate = shortSdf.format(new Date());
		
		// 主表 申请人(field0003) ,申请人所在的部门(field0005) 
		// 申请单编号(field0002),项目编号(field0019) ,受益部门(field0020),
		// 目的地(field0008),入住城市(field0009  field0050),出差性质(field0011,field0012,field0013)
		String formman = (String) PropertiesUtils.getInstance().get("formman");
		String formshiji = (String) PropertiesUtils.getInstance().get("formsonShijiXinxi");
		String sql = "SELECT id,field0002,field0003,field0005,field0006,field0008 ,field0009,field0010,field0032,field0011,field0012,field0013, field0019,field0020  FROM "+formman+" a where a.finishedflag = '1'";// 这里还要加条件where流程是否结束
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
		if (queryForList != null && queryForList.size()>0) {
			for (Map<String, Object> map : queryForList) {
				String fieldId = map.get("id") + "";
				String memberId = map.get("field0003") + ""; // 申请人
				String depaid = map.get("field0005") + ""; // 申请人所在部门
				String numberid = map.get("field0002") + ""; // 申请单编号
				String xianmunumber = map.get("field0019") + "";// 项目编号
				String shouyidepa = map.get("field0020") + ""; // 收益部门
				String memberID = map.get("field0006") + ""; // 出差人
				String mudidid = map.get("field0008") + ""; // 目的地
				String ruzhu = map.get("field0050") + ""; // 入住城市
				String startDate =shortSdf.format( (Date) map.get("field0010")); // 实际出差日期
				String endDate = shortSdf.format((Date) map.get("field0032")); // 实际结束日期
				String xingzhi = map.get("field0011") + ","+map.get("field0012")+","+map.get("field0013")+""; // 出差性质

				String isDGJ = "";
				Long comId = null;
				String[] getTravel = memberID.split(","); // 出差人
				if(getTravel != null && getTravel.length >0){
				for (int i = 0; i < getTravel.length; i++) {
					if (memberID != null) {
						String orgMember = "SELECT ORG_ACCOUNT_ID as com,is_DGJ as dgj FROM org_member WHERE ID=" + getTravel[i];
						// 根据id 取一条数据 人员的董高监
						List<Map<String, Object>> memberlist = jdbcTemplate.queryForList(orgMember);
						if (memberlist != null && memberlist.size() > 0) {
							for (Map<String, Object> membermap : memberlist) {
								comId = membermap.get("com") == null ? 0 : Long.valueOf(membermap.get("com")+""); // 获取机构id
								isDGJ = membermap.get("dgj") == null ? "" : membermap.get("dgj")+""; // 获取人员董高监
							}
						}
					}
					
					//查询补助信息
					String getDiQuLeiXin = "select * from "+formshiji+" where formmain_id=" + fieldId + " and field0031=" + getTravel[i];  //出差人
					List<Map<String, Object>> diquList = jdbcTemplate.queryForList(getDiQuLeiXin);
					String accountid = comId + "";
					if(diquList != null && diquList.size() >0){
					for (Map<String, Object> diQuListMap : diquList) {
						int YbbuzhuDay = diQuListMap.get("field0041") == null ? 0 : Integer.parseInt(diQuListMap.get("field0041") + ""); // 补助天数
							if(YbbuzhuDay != 0){
								int buzhuDayAll =diQuListMap.get("field0040") == null ? 0 : Integer.parseInt(diQuListMap.get("field0040") + ""); // 总补助天数 field0043
								int buzhuDay = diQuListMap.get("field0041") == null ? 0 : Integer.parseInt(diQuListMap.get("field0041") + ""); // 补助天数
								String beizhu = diQuListMap.get("field0042") == null ? "" : (String) diQuListMap.get("field0042")+","+(String) diQuListMap.get("field0043")+","+(String) diQuListMap.get("field0044"); // 一般地区-备注
								String oa_typr = numberid + memberID + "A";
								String quChong = "select OA_KEY from xc_buzhudate where OA_KEY = '" + oa_typr + "'";
								List<Map<String, Object>> buzhuList = jdbcTemplate.queryForList(quChong);
							if (buzhuList != null && buzhuList.size() == 0) {
								addBuzhuDate(numberid, memberId, memberID, accountid, shouyidepa, depaid, xianmunumber, startDate, endDate, buzhuDayAll, buzhuDay, 0, ruzhu, "A", "CNY", mudidid, isDGJ, oa_typr, xingzhi, beizhu, createDate);
								}
							}
							int QtbuzhuDay = diQuListMap.get("field0045") == null ? 0 : Integer.parseInt(diQuListMap.get("field0045") + ""); // 补助天数
							if(QtbuzhuDay != 0){
								int buzhuDayAll = diQuListMap.get("field0040") == null ? 0 : Integer.parseInt(diQuListMap.get("field0040") + ""); // 总补助天数
								int buzhuDay = diQuListMap.get("field0045") == null ? 0 : Integer.parseInt(diQuListMap.get("field0045") + ""); // 补助天数
								String beizhu = diQuListMap.get("field0046") == null ? "" : (String) diQuListMap.get("field0046")+","+(String) diQuListMap.get("field0047")+","+(String) diQuListMap.get("field0048"); // 其他地区-备注
								String oa_typr = numberid + memberID + "A";
								String quChong = "select OA_KEY from xc_buzhudate where OA_KEY = '" + oa_typr + "'";
								List<Map<String, Object>> buzhuList = jdbcTemplate.queryForList(quChong);
								if (buzhuList != null && buzhuList.size() == 0) {
									addBuzhuDate(numberid, memberId, memberID, accountid, shouyidepa, depaid, xianmunumber, startDate, endDate, buzhuDayAll, buzhuDay, 0, ruzhu, "A", "CNY", mudidid, isDGJ, oa_typr, xingzhi, beizhu, createDate);
									}
								}
							}
						}
					}
				}
			}
		}
	}

	// APPL_ORDER_CODE VARCHAR2(240) N 申请单编号
	// APPL_USER_CODE VARCHAR2(100) N 申请人 编码
	// EMPLOYEE_CODE VARCHAR2(100) N 出差人 编码
	// COM_CODE VARCHAR2(150) N 机构编码 编码
	// DEPT_CODE VARCHAR2(150) N 受益部门 编码
	// COST_CENTER VARCHAR2(150) N 成本中心(申请人部门) 编码
	// PROJECT_CODE VARCHAR2(150) N 项目编码
	// DATE_FROM VARCHAR2(150) N 出差日期自 YYYY-MM-DD
	// DATE_TO VARCHAR2(150) N 出差日期至 YYYY-MM-DD
	// LEAVE_NUM VARCHAR2(50) N 出差天数
	// ALLOW_NUM VARCHAR2(50) N 补贴天数
	// NON_ALLOW_NUM VARCHAR2(50) N 非补贴天数
	// LEAVE_SITE VARCHAR2(100) N 出差地点（入住酒店的城市）
	// LOCATION_TYPE VARCHAR2(50) N 出差地区类型 A、B、C 三种类型
	// CURRENCY VARCHAR2(50) N 币种 默认‘CNY’
	// LEAVE_SITE_2 VARCHAR2(100) Y 出差地点（目地的城市）
	// DS_FLAG VARCHAR2(50) N 董监事标识 Y(yes); N(no)
	// OA_KEY VARCHAR2(240) N OA主键 申请单编号+出差人员编码+地区类型
	// TRAVEL_DESCRIPTION varchar2(200) N 出差事项描述
	// DESCRIPTION VARCHAR2(500) Y 备注
	// createDate varchar2(255) Y 创建时间
	// ATTRIBUTE1 varchar2(200) y 扩展字段1 备用字段
	// ATTRIBUTE2 varchar2(200) y 扩展字段2 备用字段
	// ATTRIBUTE3 varchar2(200) y 扩展字段3 备用字段
	// ATTRIBUTE4 varchar2(200) y 扩展字段4 备用字段
	// ATTRIBUTE5 varchar2(200) y 扩展字段5 备用字段
	// ATTRIBUTE6 varchar2(200) Y 扩展字段6 备用字段
	public void addBuzhuDate(String applOrderCode, String applUserCode, String employeeCode, String comCode, String deptCode, String costCenter, String projectCode, String dateForm, String dateTo, int leaveNum, int allowNum, int nonAllowNum, String leaveSite, String locationType, String currency, String leaveSite2, String dsFlag, String oaKey, String travel_desc, String description, String createDate) throws BusinessException {
		String SOURCE = "OA系统";
		String insertxc = "INSERT INTO xc_buzhudate VALUES (" + UUIDLong.longUUID() + ",'" + SOURCE + "','" + applOrderCode + "'," + applUserCode + ",'" + employeeCode + "'," + comCode + ",'" + deptCode + "'," + costCenter + ",'" + projectCode + "','" + dateForm + "','" + dateTo + "'," + leaveNum + "," + allowNum + "," + nonAllowNum + ",'" + leaveSite + "','" + locationType + "','" + currency + "','" + leaveSite2 + "','" + dsFlag + "','" + oaKey + "','" + travel_desc + "','" + description + "','" + createDate + "','','','','','','')";
		jdbcTemplate.update(insertxc);
	}

	/**
	 * 获得指定日期的前一天
	 * 
	 * @param specifiedDay
	 * @return
	 * @throws Exception
	 */
	public static String getSpecifiedDayBefore(String specifiedDay) {
		// SimpleDateFormat simpleDateFormat = new
		// SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		Date date = null;
		try {
			date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		c.setTime(date);
		int day = c.get(Calendar.DATE);
		c.set(Calendar.DATE, day - 1);

		String dayBefore = new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
		return dayBefore;
	}

	public String getEnum(Long id) {
		String sql = "select SHOWVALUE as showvalue from ctp_enum_item where id = " + id;
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
		String showname = "";
		if (queryForList != null && queryForList.size() > 0) {
			for (Map<String, Object> map : queryForList) {
				showname = map.get("showvalue") == null ? "" : (String) map.get("showvalue");
			}
		}
		return showname;
	}
}
