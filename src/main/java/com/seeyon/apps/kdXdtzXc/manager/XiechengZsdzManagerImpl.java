package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.dao.XiechengZsdzDao;
import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPHotel;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxZs;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.UUIDLong;
public class XiechengZsdzManagerImpl implements XiechengZsdzManager {

	private static final Log LOGGER = LogFactory.getLog(XiechengZsdzManagerImpl.class);
	
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	
	private XiechengZsdzDao xiechengZsdzDao;
	
	public XiechengZsdzDao getXiechengZsdzDao() {
		return xiechengZsdzDao;
	}

	public void setXiechengZsdzDao(XiechengZsdzDao xiechengZsdzDao) {
		this.xiechengZsdzDao = xiechengZsdzDao;
	}

	
	public List<XiechengZsdz> getAll() throws BusinessException {
		return xiechengZsdzDao.getAll();
	}

	public List<XiechengZsdz> getDataByIds(Long[] ids) {
		return xiechengZsdzDao.getDataByIds(ids);
	}

	public XiechengZsdz getDataById(Long id) throws BusinessException {
		return xiechengZsdzDao.getDataById(id);
	}

	public void add(XiechengZsdz xiechengZsdz) throws BusinessException {
		xiechengZsdzDao.add(xiechengZsdz);
	}

	public void update(XiechengZsdz xiechengZsdz) throws BusinessException {
		xiechengZsdzDao.update(xiechengZsdz);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		xiechengZsdzDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		xiechengZsdzDao.deleteById(id);
	}
	
	public FlipInfo getListXiechengZsdzData(FlipInfo fi, Map<String, Object> params) throws BusinessException {
		String hql = "from XiechengZsdz as xiechengZsdz order by xiechengZsdz.journeyId desc";
		List<XiechengZsdz> dataList = DBAgent.find(hql, params, fi);
		fi.setData(dataList);
		return fi;
	}
	
	
	public FlipInfo getListXiechengZsDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException {
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			String beginStr = params.get("bigdate")+"";
			Date beginTo;
			Date endTo;
			
			SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(dateFormat.parse(beginStr));
			calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
			beginTo = calendar.getTime();
			
			    calendar.setTime(dateFormat.parse(beginStr));
			    calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
			    endTo = calendar.getTime();
			    
			    User user = AppContext.getCurrentUser();
			    Long account = user.getAccountId();
			    String accountId = String.valueOf(account);
			    
			    String accCheckBatchNo = "";
				if("-1792902092017745579".equals(accountId)){
					accCheckBatchNo="cindaAsset_173907_"+dateFormat2.format(beginTo);
				}else if("2662344410291130278".equals(accountId)){
					accCheckBatchNo="cindaAssetBJ_182465_"+dateFormat2.format(beginTo);
				}if("1755267543710320898".equals(accountId)){
					accCheckBatchNo="cindaAssetHB_179331_"+dateFormat2.format(beginTo);
				}else if("-5358952287431081185".equals(accountId)){
					accCheckBatchNo="cindaAssetJS_179336_"+dateFormat2.format(beginTo);
				}
			    
				String hql = "from XiechengZsdz as xiechengZsdz where xiechengZsdz.accCheckBatchNo = :accCheckBatchNo order by NLSSORT(xiechengZsdz.clientName,'NLS_SORT=SCHINESE_PINYIN_M')";
			    String beg=dateFormat.format(beginTo);
			    String end=dateFormat.format(endTo);
			    Map<String, Object>map=new HashMap<String, Object>();
			   /* map.put("createTime1", beg);
			    map.put("createTime2", end);*/
			    map.put("accCheckBatchNo", accCheckBatchNo);
			    
				List<CaiwuJtdz> dataList = DBAgent.find(hql,map,fi);
				fi.setData(dataList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		return fi;
	}

	@Override
	public void xiechengJiudianJieShuan() throws BusinessException {
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
			if(xiechengERPHotel != null && xiechengERPHotel.length >0){
				//获取系统时间作为创建时间
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				String createTime = sdf.format(new Date());
				for (XiechengERPHotel entity : xiechengERPHotel) {
					Long uuid =  UUIDLong.longUUID();//创建一个随机ID
					
					String joruneyId = String.valueOf(entity.getHotelRelatedJourneyNo());
					String passengerName = entity.getClientName();
					String startTime = entity.getStartTime();
					String endTime = entity.getEndTime();
					String detailType = entity.getRemarks();
					String employeeID = entity.getEmployeeID();
					
					//携程住宿对账表
					xiechengZsdz.setId(uuid);//id
					xiechengZsdz.setJourneyId(joruneyId);//申请单编号
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
					xiechengZsdz.setEmployeeID(employeeID);//员工编号
					String amount=String.valueOf(entity.getAmount());
					//申请单编号journeyid预住人姓名passengername预入住日期startTime离店日期endTime判断OA数据库中是否已经存在这条数据
					List<Map<String, Object>> oaList = xiechengZsdzManager.getOaList(joruneyId, passengerName, startTime, endTime,detailType,amount);
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

	@Override
	public List<Map<String, Object>> getOaList(String journeyid,
			String passengername, String start, String end,
			String orderType,String amount) {
		List<Map<String, Object>> xiechengjtdzList = xiechengZsdzDao.getOaList(journeyid, passengername,start , end,orderType,amount);
		return xiechengjtdzList;
	}
	@Override
	public void saveXiechengFqdzxx() throws BusinessException {
		XiechengFqdzxxZsManager xiechengFqdzxxZsManager = (XiechengFqdzxxZsManager) AppContext.getBean("xiechengFqdzxxZsManager");
		//获取系统时间作为创建时间
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String createTime = sdf.format(new Date());
		Calendar calendar=Calendar.getInstance();
		//获得当前时间的年份
		int year=calendar.get(Calendar.YEAR);
		//获得当前时间的月份，月份从0开始所以结果要加1
		int month=calendar.get(Calendar.MONTH)+1;
		XiechengFqdzxxZs xiechengFqdzxxZs = new XiechengFqdzxxZs();
		//携程发起对帐信息住宿
		xiechengFqdzxxZs.setId(UUIDLong.longUUID());	//Id
		xiechengFqdzxxZs.setYear(String.valueOf(year));	//年
		xiechengFqdzxxZs.setMonth(String.valueOf(month));//月
		xiechengFqdzxxZs.setTqTime(createTime);//提取时间
		//xiechengFqdzxxZs.setDzTime("");//对账时间
		List<Map<String, Object>>  xiangxiList = xiechengFqdzxxZsManager.getByTime(year, month);
		if(xiangxiList.size()>0 && xiangxiList!=null){
			
		}else{
			xiechengFqdzxxZsManager.add(xiechengFqdzxxZs);//添加携程发起对帐信息住宿表数据
		}
		
	}

	/**
	 * 根据外键id查询
	 */
	@Override
	public List<XiechengZsdz> getDataByZhuSuId(Long id,String accountId) throws BusinessException {
		return xiechengZsdzDao.getDataByZhuSuId(id,accountId);
	}

	/**
	 * 功能：根据审批单号查询机票所需信息
	 */
	@Override
	public Map<String, Object> getProjectInfoByOrderId(String journeyID,String loginName) throws BusinessException {
		Map<String, Object>  dataMap = new HashMap<String,Object>();	
		String miansql = "select t.field0003 as memberId,t.field0005 as departmentId, t.field0017 as proname ,t.field0018 as proorg,t.field0019 as procode,t.field0020 as prodep from formmain_0108 t where t.field0002 = '"+journeyID+"'";
		List<Map<String,Object>> listMap = jdbcTemplate.queryForList(miansql);
		if(listMap != null && listMap.size() == 1){
			for (int i = 0; i < listMap.size(); i++) {
				Map<String,Object> map = listMap.get(i);
				String proname = map.get("proname")==null?"": map.get("proname")+"";   //项目名称
				String esbrogcode = map.get("proorg")==null?"": map.get("proorg")+"";      //所属机构编码
				String procode = map.get("procode")==null?"": map.get("procode")+"";   //项目编码
				String oaDepId = map.get("prodep")==null?"": map.get("prodep")+"";      //受益部门编码
				String oaDepCode = getDepCode(oaDepId);  //受益部门：oa部门编号
				
				Map<String, Object> orgMap = getEsbOrgInfo(esbrogcode);
				String esbrogname = orgMap.get("esbrogname")==null?"": orgMap.get("esbrogname")+"";   //ebs机构名称
				String oaorgcode = orgMap.get("oaorgcode")==null?"": orgMap.get("oaorgcode")+"";      //OA机构编号
				String oaorgname = orgMap.get("oaorgname")==null?"": orgMap.get("oaorgname")+"";      //OA机构名称
				
				Map<String, Object> depMap = getEsbDepInfo(oaDepCode);
				String ebsdepcode = depMap.get("ebsdepcode")==null?"": depMap.get("ebsdepcode")+"";   //ebs部门编号
				String esbdepname = depMap.get("esbdepname")==null?"": depMap.get("esbdepname")+"";   //ebs部门名称
				String oadepname = depMap.get("oadepname")==null?"": depMap.get("oadepname")+"";      //OA部门名称
				
				String memberId = depMap.get("memberId")==null?"": depMap.get("memberId")+"";      //申请人
				String departmentId = depMap.get("departmentId")==null?"": depMap.get("departmentId")+""; //申请人所在部门
				String memebrCode = getMemberCodeById(memberId);
				String depCode = getDepCode(departmentId);                                              //oa成本中心编号
				Map<String, Object> dep2Map =  getEsbDepInfo(depCode);
				String ebsdep2Code = dep2Map.get("ebsdepcode")==null?"": dep2Map.get("ebsdepcode")+"";   //ebs成本中心编号
				
				String isDgj = getDGJ(loginName);  //是否董高监
				
				dataMap.put("esbrogcode", esbrogcode);
				dataMap.put("esbrogname", esbrogname);
				dataMap.put("ebsdepcode", ebsdepcode);
				dataMap.put("esbdepname", esbdepname);
				dataMap.put("oaorgcode", oaorgcode);
				dataMap.put("oaorgname", oaorgname);
				dataMap.put("oaDepCode", oaDepCode);
				dataMap.put("oadepname", oadepname);
				dataMap.put("procode", procode);
				dataMap.put("proname", proname);
				dataMap.put("oadep2Code", depCode);
				dataMap.put("ebsdep2Code", ebsdep2Code);
				dataMap.put("memebrCode", memebrCode);
				dataMap.put("isDgj", isDgj);
			}
		}else{
			System.out.println("财务接口获取项目信息：["+journeyID+"]没有对应的审批单号");
			LOGGER.error("财务接口获取项目信息：["+journeyID+"]没有对应的审批单号");
		}
		return dataMap;
	}
	

	/**
	 * 功能：根据ebs项目所属机构编码得到ebs机构名称、OA机构编号、OA机构名称
	 */
	public Map<String,Object> getEsbOrgInfo(String esborgCode) throws BusinessException {
		Map<String,Object> datamap = new HashMap<String,Object>();
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String miansql = "select t.field0002 as esbrogname,field0003 as oaorgcode, field0004 as oaorgname  from formmain_0102 t where t.field0001 = '"+esborgCode+"'";
		List<Map<String,Object>> listMap = jdbcTemplate.queryForList(miansql);
		if(listMap != null && listMap.size() == 1){
			for (int i = 0; i < listMap.size(); i++) {
				Map<String,Object> map = listMap.get(i);
				String esborgname = map.get("esbrogname")==null?"": map.get("esbrogname")+"";
				String oaorgcode = map.get("oaorgcode")==null?"": map.get("oaorgcode")+"";
				String oaorgname = map.get("oaorgname")==null?"": map.get("oaorgname")+"";
				datamap.put("esbrogname", esborgname);
				datamap.put("oaorgcode", oaorgcode);
				datamap.put("oaorgname", oaorgname);
			}
		}else{
			System.out.println("财务接口获取项目信息：["+esborgCode+"]没有对应的EBS系统项目名称");
			LOGGER.error("财务接口获取项目信息：["+esborgCode+"]没有对应的EBS系统项目名称");
		}
		return datamap;
	}
	
	
	/**
	 * 功能：根据oa部门id获取部门编号
	 */
	public String getDepCode(String oaDepId) throws BusinessException {
		String depCode =  "";
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String miansql = "select t.code as code from org_unit t where t.deleted = 0 and t.id = " + Long.valueOf(oaDepId);
		List<Map<String,Object>> listMap = jdbcTemplate.queryForList(miansql);
		if(listMap != null && listMap.size() == 1){
			for (int i = 0; i < listMap.size(); i++) {
				Map<String,Object> map = listMap.get(i);
				depCode = map.get("code")==null?"": map.get("code")+"";
			}
		}else{
			System.out.println("财务接口获取项目信息：["+oaDepId+"]没有对应的部门编号");
			LOGGER.error("财务接口获取项目信息：["+oaDepId+"]没有对应的部门编号");
		}
		return depCode;
	}
	
	/**
	 * 功能：根据oa受益部门编号 得到ebs收益部门名称、ebs收益部门编号、OA收益部门名称
	 */
	public Map<String,Object> getEsbDepInfo(String oadepCode) throws BusinessException {
		Map<String,Object> datamap = new HashMap<String,Object>();
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String miansql = "select  field0001 as ebsdepcode,t.field0002 as esbdepname, field0004 as oadepname  from formmain_0101 t where t.field0003 = '"+oadepCode+"'";
		List<Map<String,Object>> listMap = jdbcTemplate.queryForList(miansql);
		if(listMap != null && listMap.size() == 1){
			for (int i = 0; i < listMap.size(); i++) {
				Map<String,Object> map = listMap.get(i);
				String ebsdepcode = map.get("ebsdepcode")==null?"": map.get("ebsdepcode")+"";
				String esbdepname = map.get("esbdepname")==null?"": map.get("esbdepname")+"";
				String oadepname = map.get("oadepname")==null?"": map.get("oadepname")+"";
				datamap.put("ebsdepcode", ebsdepcode);
				datamap.put("esbdepname", esbdepname);
				datamap.put("oadepname", oadepname);
			}
		}else{
			System.out.println("财务接口获取项目信息：["+oadepCode+"]没有对应的EBS系统受益部门信息");
			LOGGER.error("财务接口获取项目信息：["+oadepCode+"]没有对应的EBS系统受益部门信息");
		}
		return datamap;
	}
	
	
	/**
	 * 功能：人员id得到人员code
	 */
	public String getMemberCodeById(String memberId) throws BusinessException {
		String memberCode = "";
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String miansql = "select t.code as code from org_member t where t.id = " + Long.valueOf(memberId);
		List<Map<String,Object>> listMap = jdbcTemplate.queryForList(miansql);
		if(listMap != null && listMap.size() == 1){
			for (int i = 0; i < listMap.size(); i++) {
				Map<String,Object> map = listMap.get(i);
				memberCode = map.get("code")==null?"": map.get("code")+"";
			}
		}else{
			System.out.println("财务接口获取项目信息：["+memberId+"]没有对应的员工编号信息");
			LOGGER.error("财务接口获取项目信息：["+memberId+"]没有对应的员工编号信息");
		}
		return memberCode;
	}
	
	/**
	 * 功能：根据人员登录名得到董高监标识
	 */
	public String getDGJ(String loginName) throws BusinessException {
		String dgj = "";
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String sql ="SELECT m.IS_DGJ as dgj FROM org_member m LEFT JOIN org_principal p ON p.member_Id = m.id WHERE p.LOGIN_NAME = '"+loginName+"'";
		List<Map<String,Object>> listMap = jdbcTemplate.queryForList(sql);
		if(listMap != null && listMap.size() == 1){
			for (int i = 0; i < listMap.size(); i++) {
				Map<String,Object> map = listMap.get(i);
				dgj = map.get("dgj")==null?"N": map.get("dgj")+"";
			}
		}else{
			System.out.println("财务接口获取项目信息：["+loginName+"]没有对应的员工信息");
			LOGGER.error("财务接口获取项目信息：["+loginName+"]没有对应的员工信息");
		}
		return dgj;
	}

	@Override
	public Map<String,Object> getCtpAffairId(String formId) {
		String sql="SELECT c.app as capp,c.ID as aid , c.OBJECT_ID as cobjectid FROM formmain_0108 f LEFT JOIN ctp_affair c ON f.ID = c.FORM_RECORDID  WHERE f.field0002 ='"+formId+"' AND c.COMPLETE_TIME is not null ORDER BY c.COMPLETE_TIME DESC";
		List<Map<String, Object>> queryAffairId = jdbcTemplate.queryForList(sql);
		Map<String,Object> map=new HashMap<String, Object>();
		if(queryAffairId != null && queryAffairId.size() >0){
			String capp = queryAffairId.get(0).get("capp")+"";
			String aid = queryAffairId.get(0).get("aid")+"";
			String cobjectid = queryAffairId.get(0).get("cobjectid")+"";
			map.put("capp",capp);
			map.put("aid",aid);
			map.put("cobjectid",cobjectid);
			}
		return map;
	}
}
