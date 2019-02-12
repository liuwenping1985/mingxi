package com.seeyon.apps.kdXdtzXc.manager;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.dao.XiechengJiaotongQxDao;
import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.CaiwuZsdz;
import com.seeyon.apps.kdXdtzXc.po.XieChengJiaoTong;
import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.apps.kdXdtzXc.po.XiechengJiaotongQx;
import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengZhusuQx;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.UUIDLong;
public class XiechengJiaotongQxManagerImpl implements XiechengJiaotongQxManager {

	private static final Log LOGGER = LogFactory.getLog(XiechengJiaotongQxManagerImpl.class);
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	
	private XiechengJiaotongQxDao xiechengJiaotongQxDao;
	
	public XiechengJiaotongQxDao getXiechengJiaotongQxDao() {
		return xiechengJiaotongQxDao;
	}

	public void setXiechengJiaotongQxDao(XiechengJiaotongQxDao xiechengJiaotongQxDao) {
		this.xiechengJiaotongQxDao = xiechengJiaotongQxDao;
	}

	
	public List<XiechengJiaotongQx> getAll() throws BusinessException {
		return xiechengJiaotongQxDao.getAll();
	}

	public List<XiechengJiaotongQx> getDataByIds(Long[] ids) {
		return xiechengJiaotongQxDao.getDataByIds(ids);
	}
	/**
	 * 根据id 查询全部数据
	 * @param id
	 * @return
	 */
	public List<XiechengJiaotongQx> getDataByJiaoTongId(Long id) {
		return xiechengJiaotongQxDao.getDataByJiaoTongId(id);
	}

	public XiechengJiaotongQx getDataById(Long id) throws BusinessException {
		return xiechengJiaotongQxDao.getDataById(id);
	}

	public void add(XiechengJiaotongQx xiechengJiaotongQx) throws BusinessException {
		xiechengJiaotongQxDao.add(xiechengJiaotongQx);
	}

	public void update(XiechengJiaotongQx xiechengJiaotongQx) throws BusinessException {
		xiechengJiaotongQxDao.update(xiechengJiaotongQx);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		xiechengJiaotongQxDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		xiechengJiaotongQxDao.deleteById(id);
	}
	
	/**显示列表数据**/
	public FlipInfo getListXiechengJiaotongQxData(FlipInfo fi, Map<String, Object> params) throws BusinessException {
		String hql = "from XiechengJiaotongQx as xiechengJiaotongQx order by numbers asc";
		List<XiechengJiaotongQx> dataList = DBAgent.find(hql, params, fi);
		fi.setData(dataList);
		return fi;
	}

	@Override
	public void saveByAdd(HttpServletRequest request) throws BusinessException {
		try {
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			Map<String, Object> map = JSONUtilsExt.parseMap(jsonStr);
			XiechengJiaotongQx jiaotong = new XiechengJiaotongQx();
			String number = map.get("numbers") == null ? "0" :(String) map.get("numbers") == "" ? "0" :(String) map.get("numbers");
			String level = (String) map.get("levelName");
			String className = (String) map.get("className");
			Timestamp time = new Timestamp(System.currentTimeMillis());//得到当前时间
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String str = sdf.format(time);
			Long uuid = UUIDLong.longUUID() ;
			//添加
			jiaotong.setId(uuid);
			jiaotong.setLevelName(level);//职级
			jiaotong.setClassName(className);//舱位
			jiaotong.setNumbers(Long.valueOf(number));//序号
			jiaotong.setCreateTime(str);//创建时间
			xiechengJiaotongQxDao.add(jiaotong);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public void updateByJiaoTongQx(HttpServletRequest request) throws BusinessException {
		try {
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			Map<String, Object> map = JSONUtilsExt.parseMap(jsonStr);
			XiechengJiaotongQx jiaotong = new XiechengJiaotongQx();
			
			String number = map.get("numbers") == null ? "0" :(String) map.get("numbers") == "" ? "0" :(String) map.get("numbers");
			String id =(String) map.get("id");
			String level = (String) map.get("levelName");
			String className = (String) map.get("className");
			String createTime =(String) map.get("createTime");
			Timestamp time = new Timestamp(System.currentTimeMillis());//得到当前时间
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String str = sdf.format(time);
	        if(id ==  null )
	        throw new BusinessException("id 参数丢失");
	        
	        jiaotong.setId(Long.valueOf(id));
	        jiaotong.setLevelName(level);//职级
			jiaotong.setClassName(className);//舱位
			jiaotong.setNumbers(Long.valueOf(number));//序号
			jiaotong.setCreateTime(createTime);
			jiaotong.setUpdateTime(str);//创建时间
			xiechengJiaotongQxDao.update(jiaotong);
	        
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	/**
	 * 生成对账数据交通，住宿
	 */
	@Override
	public void jiaoTongById(Long id) throws BusinessException {
		try {
			if(id == null)
				throw new BusinessException("id 参数丢失");
			//交通权限
			XiechengJiaotongQxManager xiechengJiaotongQxManager = (XiechengJiaotongQxManager) AppContext.getBean("xiechengJiaotongQxManager");
			//携程交通对账表
			XiechengJtdzManager xiechengJtdzManager = (XiechengJtdzManager) AppContext.getBean("xiechengJtdzManager");
			//携程发起对帐信息交通住宿表（舍弃了携程发起对帐信息住宿表）公用携程发起对帐信息交通表
			CaiwuJtdzManager caiwuJtdzManager = (CaiwuJtdzManager)AppContext.getBean("caiwuJtdzManager");
			//携程住宿对账表
			XiechengZsdzManager xiechengZsdzManager = (XiechengZsdzManager)AppContext.getBean("xiechengZsdzManager");
			XiechengZhusuQxManager xiechengZhusuQxManager = (XiechengZhusuQxManager)AppContext.getBean("xiechengZhusuQxManager");
			CaiwuZsdzManager caiwuZsdzManager = (CaiwuZsdzManager)AppContext.getBean("caiwuZsdzManager");
			XiechengFqdzxxJtManager xiechengFqdzxxJtManager = (XiechengFqdzxxJtManager)AppContext.getBean("xiechengFqdzxxJtManager");
			
			User user = AppContext.getCurrentUser();
	        Long account = user.getAccountId();
            String accountId = String.valueOf(account);
			String xcClassName = null ;
			String EmployeeID = null;
			String levelName = null;//根据登录名称查询得到的 级职
			String level = null;//交通权限及配置中的级职
			String className = null; //
			String hgjx = null;//合规效验
			String sdHgjy=null;//手动合规校验
			String zfQr = null;//支付确认
			String ZsEmployeeID = null;//住宿员工编号
			String HotelType = null;//酒店类型
			String Department = null ;//部门
			String journeyId = null;
			String finishedflag = null;
			String feeTypeJt = null; //费用类型_交通
			String feeTypeZs = null; //费用类型_住宿
			String type = "\\";
			Timestamp time = new Timestamp(System.currentTimeMillis());//得到当前时间
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String str = sdf.format(time);
			String passengerName = "";
			
			//1、根据 携程发起对帐信息交通ID 得到携程交通对账表的关联数据 
			List<XiechengJtdz> xiechengJtdzList =  xiechengJtdzManager.getDataByJiaoTongId(id,accountId);
			if(xiechengJtdzList != null && xiechengJtdzList.size() >0 ){
				for (int i = 0; i < xiechengJtdzList.size(); i++) {
					XiechengJtdz XiechengJtdz = xiechengJtdzList.get(i);
					xcClassName = XiechengJtdz.getClassName();		//舱位
					EmployeeID = XiechengJtdz.getEmployeeID();	//员工编号（OA中登录名称）
					journeyId = XiechengJtdz.getJourneyId();
					passengerName = XiechengJtdz.getPassengerName();
					
					String getLongNameSql="SELECT m.NAME as mName,p.LOGIN_NAME as pLoginName FROM org_member m LEFT JOIN org_principal p ON m.ID = p.MEMBER_ID WHERE m.NAME = '"+passengerName+"'";
					List<Map<String, Object>> getLongNameList = jdbcTemplate.queryForList(getLongNameSql);
					if(getLongNameList!= null && getLongNameList.size() > 0){
						EmployeeID=getLongNameList.get(0).get("pLoginName")+"";
					}
					
					/*if(xcClassName.equals("头等舱")){
						xcClassName = "3";//头等舱
					}else if(xcClassName.equals("商务舱")){
						xcClassName = "2";//商务舱
					}else if(xcClassName.equals("经济舱")){
						xcClassName = "1";//经济舱
					}else{
						xcClassName = "1";//经济舱
					}*/
					//2、根据员工编号（OA中登录名称）得到职级
					Map<String, Object> xcJiaoTong = xiechengJiaotongQxManager.getEmployeeID(EmployeeID);
					if(xcJiaoTong != null && xcJiaoTong.size() >0 )
						levelName =  (String) xcJiaoTong.get("name");//得到职级
					else
						throw new BusinessException("职级是否丢失");
					//得到部门
					Map<String, Object> zsDepartment = xiechengJiaotongQxManager.getDepartment(EmployeeID);
					if(zsDepartment != null && zsDepartment.size() > 0 )
						Department = (String) zsDepartment.get("name");
					else
						throw new BusinessException("部门丢失！");
					String sql="SELECT m.is_dgj FROM org_principal p LEFT JOIN org_member m on m.ID=p.member_id WHERE p.login_name='"+EmployeeID+"'";
					List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
					String dgj="";
					if(queryForList != null && queryForList.size() > 0){
						dgj=queryForList.get(0).get("IS_DGJ")+"";
					}
					 
					String depaZhiji="SELECT m.NAME as mName ,u.NAME as uname FROM org_principal o LEFT JOIN org_member M ON o.member_id = M . ID LEFT JOIN ORG_UNIT U ON M .ORG_DEPARTMENT_ID = U . ID WHERE o.login_name = '"+EmployeeID+"'";
					List<Map<String, Object>> rankList = jdbcTemplate.queryForList(depaZhiji);
					String uName="";
					if(rankList != null && rankList.size()>0){
						uName = rankList.get(0).get("uname")+"";
					}
					if("董事".equals(dgj) || "高管".equals(dgj) || "监事".equals(dgj)){
						dgj="dgj";
						String hegui="";
						List<XieChengJiaoTong> heGuiJiaoTong = xiechengJiaotongQxDao.getHeGuiJiaoTong(dgj);
						for (XieChengJiaoTong xieChengJiaoTong : heGuiJiaoTong) {
							String position = xieChengJiaoTong.getPosition();
							//boolean pos = position.contains(xcClassName); //判断交通类别是否在规定类别下
							if(position.contains(xcClassName)){
								hgjx="合规";
								sdHgjy="合规";
								zfQr="支付";
							}
							if(StringUtils.isEmpty(hgjx)){
								hgjx="不在合规配置范围内";
								sdHgjy="不在合规配置范围内";
								zfQr="未支付";
							}
						}
					}

					else if("专职审批人".equals(uName) || "分公司领导".equals(uName) || "部门领导".equals(uName) || "分公司巡视员".equals(levelName) || "巡视员".equals(levelName)){
						dgj="depa";
						List<XieChengJiaoTong> heGuiJiaoTong = xiechengJiaotongQxDao.getHeGuiJiaoTong(dgj);
						for (XieChengJiaoTong xieChengJiaoTong : heGuiJiaoTong) {
							String position = xieChengJiaoTong.getPosition();
							if(position.contains(xcClassName)){
								hgjx="合规";
								sdHgjy="合规";
								zfQr="支付";
							}
							if(StringUtils.isEmpty(hgjx)){
								hgjx="舱位超标";
								sdHgjy="舱位超标";
								zfQr="未支付";
							}
						
						}
					}
					
					else if("员工".equals(levelName) || "处长".equals(levelName) || "其他".equals(levelName) || "其他".equals(levelName)){
						dgj="yg";
						List<XieChengJiaoTong> heGuiJiaoTong = xiechengJiaotongQxDao.getHeGuiJiaoTong(dgj);
						for (XieChengJiaoTong xieChengJiaoTong : heGuiJiaoTong) {
							String position = xieChengJiaoTong.getPosition();
							//boolean pos = position.contains(xcClassName); //判断交通类别是否在规定类别下
							if(position.contains(xcClassName)){
								hgjx="合规";
								sdHgjy="合规";
								zfQr="支付";
							}
							if(StringUtils.isEmpty(hgjx)){
								hgjx="舱位超标";
								sdHgjy="舱位超标";
								zfQr="未支付";
							}
						}
					}else{
						dgj="yg";
						List<XieChengJiaoTong> heGuiJiaoTong = xiechengJiaotongQxDao.getHeGuiJiaoTong(dgj);
						for (XieChengJiaoTong xieChengJiaoTong : heGuiJiaoTong) {
							String position = xieChengJiaoTong.getPosition();
							//boolean pos = position.contains(xcClassName); //判断交通类别是否在规定类别下
							if(position.contains(xcClassName)){
								hgjx="合规";
								sdHgjy="合规";
								zfQr="支付";
							}
							if(StringUtils.isEmpty(hgjx)){
								hgjx="舱位超标";
								sdHgjy="舱位超标";
								zfQr="未支付";
							}
						}
					}
					
					//3、查询全部交通权限及配置
				
					
					/*List<XiechengJiaotongQx>JiaotongQxList  = xiechengJiaotongQxManager.getAll();
					if(JiaotongQxList != null && JiaotongQxList.size()>0 ){
						for (int j = 0; j < JiaotongQxList.size(); j++) {
							XiechengJiaotongQx JiaotongQx=  JiaotongQxList.get(j);
							level = JiaotongQx.getLevelName();//职级
							className = JiaotongQx.getClassName();//3头等舱，2商务舱，1经济舱
							feeTypeJt = XiechengJtdz.getFeeType();//费用类型
							
							if(level.equals(levelName)){//判断职级是否相等
								if(Long.valueOf(xcClassName) <= Long.valueOf(className)){//判断
									hgjx = "合格";
									zfQr = "支付";
									break;
								}else{
									hgjx = "舱位超标";
									zfQr = "不支付";
									break;
								}
							}else{
								hgjx = "职级不对应";
								zfQr = "不支付";
							}
						}
						if(feeTypeJt.equals(type)){
							zfQr = "\\";
						}
					}*/
					//根据审批单号查询 数据 ， 判断员工行程是否确认
					/*
					Map<String, Object> JourneyIdMap = xiechengJiaotongQxManager.getDataByJourneyId(journeyId);
					if(JourneyIdMap != null && JourneyIdMap.size()>0 ){
						 finishedflag = JourneyIdMap.get("finishedflag")+"";
						if(finishedflag.equals("0")){
							finishedflag = "未确认";
						}else if(finishedflag.equals("1")){
							finishedflag = "已确认";
						}
					}
					*/
					//4、添加生成财务对帐表——交通
					String dhId=XiechengJtdz.getJourneyId(); //单号id
					if(StringUtils.isEmpty(dhId)){
						hgjx="无对应申请审批单";
						sdHgjy="无对应申请审批单";
						zfQr="未支付";
					}
		            
					CaiwuJtdz caiwuJtdz = new CaiwuJtdz();
					Long uuid = UUIDLong.longUUID();
					caiwuJtdz.setId(uuid);//id
					caiwuJtdz.setJourneyId(XiechengJtdz.getJourneyId());//申请单编号
					caiwuJtdz.setDept(Department);//部门
					caiwuJtdz.setPassengerName(XiechengJtdz.getPassengerName());//乘机人姓名
					caiwuJtdz.setZw(levelName);//职务
					caiwuJtdz.setTakeoffTime(XiechengJtdz.getTakeoffTime());//起飞时间
					caiwuJtdz.setArrivalTime(XiechengJtdz.getArrivalTime());//到达时间
					caiwuJtdz.setDcityName(XiechengJtdz.getDcityName());//出发城市
					caiwuJtdz.setAcityName(XiechengJtdz.getAcityName());//到达城市
					caiwuJtdz.setFlight(XiechengJtdz.getFlight());//航班号
					caiwuJtdz.setClassName(XiechengJtdz.getClassName());//航位
					caiwuJtdz.setAmount(XiechengJtdz.getAmount());//费用
					caiwuJtdz.setFeeType(feeTypeJt);//费用类型
					caiwuJtdz.setRemark(XiechengJtdz.getRemark());//备注
					caiwuJtdz.setYgxcQr(finishedflag);//员工行程确认
					caiwuJtdz.setZfQr(zfQr);//支付确认
					caiwuJtdz.setHgjx(hgjx);//合规校验
					caiwuJtdz.setsGhgjx(sdHgjy);//手动合规校验
					caiwuJtdz.setCreateTime(XiechengJtdz.getCreateTime());//创建时间
					caiwuJtdz.setExtAttr3(accountId);
					caiwuJtdz.setRecordId(XiechengJtdz.getRecordId());
					caiwuJtdz.setOrderId(XiechengJtdz.getOrderId());
					caiwuJtdz.setAccCheckBatchNo(XiechengJtdz.getAccCheckBatchNo());
					
					caiwuJtdz.setExtAttr1(EmployeeID); //乘机人登录名
					System.out.println("**************************************----------------------------------"+i);
					caiwuJtdzManager.add(caiwuJtdz);
					hgjx="";
					sdHgjy="";
				}
			}
			
			/******************生成住宿对账信息*******************/
			//5、根据外键id查询数据
			String fyAmount ="";
			String clientName="";
			List<XiechengZsdz>  xiechengZsdzList  = xiechengZsdzManager.getDataByZhuSuId(id,accountId);
			if(xiechengZsdzList !=null && xiechengZsdzList.size()>0){
				XiechengZsdz xiechengZsdz = new XiechengZsdz();
				for (int i = 0; i < xiechengZsdzList.size(); i++) {
					xiechengZsdz = xiechengZsdzList.get(i);
					
					ZsEmployeeID = xiechengZsdz.getEmployeeID();//员工编号
					HotelType = xiechengZsdz.getHotelType();//酒店类型
					feeTypeZs = xiechengZsdz.getFeeType();//费用类型
					String hotelName=xiechengZsdz.getHotelName();//酒店名称
					String startTime = xiechengZsdz.getStartTime();
					String endTime = xiechengZsdz.getEndTime();
					fyAmount=xiechengZsdz.getAmount();//费用
					clientName=xiechengZsdz.getClientName();//入住人
					String[] dinpiaomemberAry = clientName.split(",");
					if(dinpiaomemberAry != null && dinpiaomemberAry.length > 0){
					//for (int j = 0; j < dinpiaomemberAry.length; j++) {
						String dinpiaomem= dinpiaomemberAry[0];
						String getLongNameSql="SELECT m.NAME as mName,p.LOGIN_NAME as pLoginName FROM org_member m LEFT JOIN org_principal p ON m.ID = p.MEMBER_ID WHERE m.NAME = '"+dinpiaomem+"'";
						List<Map<String, Object>> getLongNameList = jdbcTemplate.queryForList(getLongNameSql);
						if(getLongNameList!= null && getLongNameList.size() > 0){
							EmployeeID=getLongNameList.get(0).get("pLoginName")+"";
						}
					//}
				}
					if("null".equals(fyAmount)){
						fyAmount="0.0";
					}
					String chengshi=xiechengZsdz.getCityName();//城市
					String roomtName=xiechengZsdz.getRoomName();
					//6、得到职级
					Map<String, Object> xcJiaoTong = xiechengJiaotongQxManager.getEmployeeID(ZsEmployeeID);
					if(xcJiaoTong != null && xcJiaoTong.size() >0 )
						levelName =  (String) xcJiaoTong.get("name");//得到职级
					else
						throw new BusinessException("职级丢失！");
					//得到部门
					Map<String, Object> zsDepartment = xiechengJiaotongQxManager.getDepartment(ZsEmployeeID);
					if(zsDepartment != null && zsDepartment.size() > 0 ){
						Department = (String) zsDepartment.get("name");
					}else{
						throw new BusinessException("部门丢失！");
					}
					//7、查询全部住宿权限及配置
					/*List<XiechengZhusuQx> ZhusuQxList = xiechengZhusuQxManager.getAll();
					XiechengZhusuQx ZhusuQx = new XiechengZhusuQx();
					if(ZhusuQxList != null && ZhusuQxList.size()>0 ){
						for (int j = 0; j < ZhusuQxList.size(); j++) {
							ZhusuQx = ZhusuQxList.get(j);
							String zsLevel =  ZhusuQx.getLevelName();
							String zsHotelType = ZhusuQx.getHotelType();
							if(zsLevel.equals(levelName)){
								if(zsHotelType.equals(HotelType)){
									hgjx = "合格";
									zfQr = "支付";
									break;
								}else{
									hgjx = "房型超标";
									zfQr = "不支付";
									break;
								}
							}else{
								hgjx = "职级不对应";
								zfQr = "不支付";
							}
						}
						if(feeTypeZs.equals(type)){
							zfQr = "\\";
						}
					}else{
						System.out.println("住宿权限及配置为空！！！");
					}*/
					List<XieChengVipJiuDianPo> gethrGui =new ArrayList<XieChengVipJiuDianPo>();
					List<XieChengXieYiJiuDiangPo> gethrGuiXieyi =new ArrayList<XieChengXieYiJiuDiangPo>();
					String sql="SELECT m.is_dgj FROM org_principal p LEFT JOIN org_member m on m.ID=p.member_id WHERE p.login_name='"+EmployeeID+"'";
					List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
					String dgj="";
					if(queryForList != null && queryForList.size() > 0){
						dgj=queryForList.get(0).get("IS_DGJ")+"";
					}
					String depaZhiji="SELECT m.NAME as mName ,u.NAME as uname FROM org_principal o LEFT JOIN org_member M ON o.member_id = M . ID LEFT JOIN ORG_UNIT U ON M .ORG_DEPARTMENT_ID = U . ID WHERE o.login_name = '"+ZsEmployeeID+"'";
					List<Map<String, Object>> rankList = jdbcTemplate.queryForList(depaZhiji);
					String uName="";
					if(rankList != null && rankList.size()>0){
						uName = rankList.get(0).get("uname")+"";
					}
					//H 会员酒店
					if("H".equals(HotelType)){
						if("董事".equals(dgj) || "高管".equals(dgj) || "监事".equals(dgj)){
							dgj="dgj";
							gethrGui=xiechengZhusuQxManager.gethrGui(chengshi, dgj, startTime, endTime);
							if(gethrGui != null && gethrGui.size() > 0){
								for (XieChengVipJiuDianPo vip : gethrGui) {
									if(Double.valueOf(fyAmount) < vip.getRoom()){
										hgjx="合规";
										zfQr="支付";
										sdHgjy="合规";
									}else{
										hgjx="房间金额超出范围";
										sdHgjy="房间金额超出范围";
										zfQr="未支付";
									}	
								}								
							}else{
								hgjx="房间出发地出发时间不在范围内";
								sdHgjy="房间出发地出发时间不在范围内";
								zfQr="未支付";
							}
						}
						else if("专职审批人".equals(uName) || "部门领导".equals(uName) || "分公司巡视员".equals(levelName) || "巡视员".equals(levelName)){
							dgj="depa";
							gethrGui=xiechengZhusuQxManager.gethrGui(chengshi, dgj, startTime, endTime);
							if(gethrGui != null && gethrGui.size() > 0){
								for (XieChengVipJiuDianPo vip : gethrGui) {
									if(Double.valueOf(fyAmount) < vip.getRoom()){
										hgjx="合规";
										zfQr="支付";
										sdHgjy="合规";
									}else{
										hgjx="房间金额超出范围";
										sdHgjy="房间金额超出范围";
										zfQr="未支付";
									}
									
									if(HotelType.contains("套")){
										hgjx ="房型不符";
										sdHgjy ="房型不符";
										zfQr="未支付";
									}
									if(Double.valueOf(fyAmount) > vip.getRoom() && !HotelType.contains("套")){
										hgjx ="房间金额超出范围,房型不符";
										sdHgjy ="房间金额超出范围,房型不符";
										zfQr="未支付";
									}
								}								
							}
						}
						else if("员工".equals(levelName) || "处长".equals(levelName) || "其他".equals(levelName)){
							dgj="yg";
							gethrGui=xiechengZhusuQxManager.gethrGui(chengshi, dgj, startTime, endTime);
							if(gethrGui != null && gethrGui.size() > 0){
								for (XieChengVipJiuDianPo vip : gethrGui) {
									if(Double.valueOf(fyAmount) < vip.getRoom()){
										hgjx="合规";
										zfQr="支付";
										sdHgjy="合规";
									}else{
										hgjx="房间金额超出范围";
										sdHgjy="房间金额超出范围";
										zfQr="未支付";
									}
									if(HotelType.contains("套")){
										hgjx ="房型不符";
										sdHgjy ="房型不符";
										zfQr="未支付";
									}
									if(Double.valueOf(fyAmount) > vip.getRoom() && !HotelType.contains("套")){
										hgjx ="房间金额超出范围,房型不符";
										sdHgjy ="房间金额超出范围,房型不符";
										zfQr="未支付";
									}
								}								
							}
						}else{
							dgj="yg";
							gethrGui=xiechengZhusuQxManager.gethrGui(chengshi, dgj, startTime, endTime);
							if(gethrGui != null && gethrGui.size() > 0){
								for (XieChengVipJiuDianPo vip : gethrGui) {
									if(Double.valueOf(fyAmount) < vip.getRoom()){
										hgjx="合规";
										zfQr="支付";
										sdHgjy="合规";
									}else{
										hgjx="房间金额超出范围";
										sdHgjy="房间金额超出范围";
										zfQr="未支付";
									}
									if(HotelType.contains("套")){
										hgjx ="房型不符";
										sdHgjy ="房型不符";
										zfQr="未支付";
									}
									if(Double.valueOf(fyAmount) > vip.getRoom() && !HotelType.contains("套")){
										hgjx ="房间金额超出范围,房型不符";
										sdHgjy ="房间金额超出范围,房型不符";
										zfQr="未支付";
									}
								}								
							}
						}
					}
					
					if("X".equals(HotelType)){
						
						if("董事".equals(dgj) || "高管".equals(dgj) || "监事".equals(dgj)){
							dgj="dgj";
							gethrGuiXieyi=xiechengZhusuQxManager.gethrGuiXieYi(chengshi, dgj, hotelName, startTime, endTime);
							if(gethrGuiXieyi != null && gethrGuiXieyi.size() > 0){
								for (XieChengXieYiJiuDiangPo xieyi : gethrGuiXieyi) {
									if(xieyi.getRoomType().equals(roomtName)){
										hgjx="合规";
										zfQr="支付";
										sdHgjy="合规";
									}else{
										hgjx="房型不符";
										sdHgjy="房型不符";
										zfQr="未支付";
									}	
								}								
							}else{
								hgjx="未匹配协议酒店信息";
								sdHgjy="未匹配协议酒店信息";
								zfQr="未支付";
							}
						}
						else if("专职审批人".equals(uName) || "部门领导".equals(uName) || "分公司巡视员".equals(levelName) || "巡视员".equals(levelName)){
							dgj="depa";
							gethrGuiXieyi=xiechengZhusuQxManager.gethrGuiXieYi(chengshi, dgj, hotelName, startTime, endTime);
							if(gethrGuiXieyi != null && gethrGuiXieyi.size() > 0){
								for (XieChengXieYiJiuDiangPo xieyi : gethrGuiXieyi) {
									if(xieyi.getRoomType().equals(roomtName)){
										hgjx="合规";
										zfQr="支付";
										sdHgjy="合规";
									}else{
										hgjx="房型不符";
										sdHgjy="房型不符";
										zfQr="未支付";
									}	
								}								
							}else{
								hgjx="未匹配协议酒店信息";
								sdHgjy="未匹配协议酒店信息";
								zfQr="未支付";
							}
						}
						else if("员工".equals(levelName) || "处长".equals(levelName) || "其它".equals(levelName) || "其他".equals(levelName)){
							dgj="yg";
							gethrGuiXieyi=xiechengZhusuQxManager.gethrGuiXieYi(chengshi, dgj, hotelName, startTime, endTime);
							if(gethrGuiXieyi != null && gethrGuiXieyi.size() > 0){
								for (XieChengXieYiJiuDiangPo xieyi : gethrGuiXieyi) {
									if(xieyi.getRoomType().equals(roomtName)){
										hgjx="合规";
										zfQr="支付";
									}else{
										hgjx="房型不符";
										sdHgjy="房型不符";
										zfQr="未支付";
									}	
								}								
							}else{
								hgjx="未匹配协议酒店信息";
								sdHgjy="未匹配协议酒店信息";
								zfQr="未支付";
							}
						}else{
							dgj="yg";
							gethrGuiXieyi=xiechengZhusuQxManager.gethrGuiXieYi(chengshi, dgj, hotelName, startTime, endTime);
							if(gethrGuiXieyi != null && gethrGuiXieyi.size() > 0){
								for (XieChengXieYiJiuDiangPo xieyi : gethrGuiXieyi) {
									if(xieyi.getRoomType().equals(roomtName)){
										hgjx="合规";
										zfQr="支付";
									}else{
										hgjx="房型不符";
										sdHgjy="房型不符";
										zfQr="未支付";
									}	
								}								
							}else{
								hgjx="未匹配协议酒店信息";
								sdHgjy="未匹配协议酒店信息";
								zfQr="未支付";
							}
						}
					}
					//根据审批单号查询 数据 ， 判断员工行程是否确认
					/*
					Map<String, Object> JourneyIdMap = xiechengJiaotongQxManager.getDataByJourneyId(journeyId);
					if(JourneyIdMap != null && JourneyIdMap.size()>0 ){
						finishedflag = (String) JourneyIdMap.get("finishedflag");
						if(finishedflag.equals("0")){
							finishedflag = "未确认";
						}else if(finishedflag.equals("1")){
							finishedflag = "已确认";
						}
					}*/
					//8、添加生成财务对帐表——住宿
					String dhId=xiechengZsdz.getJourneyId();
					if(StringUtils.isEmpty(dhId)){
						hgjx="无对应申请审批单";
						sdHgjy="无对应申请审批单";
						zfQr="未支付";
					}
					
					CaiwuZsdz caiwuZsdz = new CaiwuZsdz();
					Long uuid = UUIDLong.longUUID();
					caiwuZsdz.setId(uuid);
					caiwuZsdz.setJourneyId(xiechengZsdz.getJourneyId());//申请单编号
					caiwuZsdz.setClientName(xiechengZsdz.getClientName());//预住人姓名
					caiwuZsdz.setCityName(xiechengZsdz.getCityName());//酒店所在城市
					caiwuZsdz.setHotelName(xiechengZsdz.getHotelName());//酒店名称
					caiwuZsdz.setHotelType(xiechengZsdz.getHotelType());//酒店类型
					caiwuZsdz.setRoomName(xiechengZsdz.getRoomName());//房间类型
					caiwuZsdz.setStartTime(startTime);//预入住日期
					caiwuZsdz.setEndTime(endTime);//预离店日期
					caiwuZsdz.setQuantity(xiechengZsdz.getQuantity());//夜间数
					caiwuZsdz.setPrice(xiechengZsdz.getPrice());//单价
					caiwuZsdz.setAmount(xiechengZsdz.getAmount());//费用
					caiwuZsdz.setFeeType(xiechengZsdz.getFeeType());//费用类型
					caiwuZsdz.setRemarks(xiechengZsdz.getRemarks());//备注
					caiwuZsdz.setDept(Department);//部门
					caiwuZsdz.setZw(levelName);//职级
					caiwuZsdz.setYgxcQr(finishedflag);//员工行程确认
					caiwuZsdz.setZfQr(zfQr);//支付确认
					caiwuZsdz.setHgjx(hgjx);//合规校验
					caiwuZsdz.setsDhgjy(sdHgjy); //手动合规校验
					caiwuZsdz.setCreateTime(xiechengZsdz.getCreateTime());//创建时间
					caiwuZsdz.setExtAttr1(ZsEmployeeID); //入住人登录名
					caiwuZsdz.setExtAttr3(accountId);
					caiwuZsdz.setRecordId(xiechengZsdz.getRecordId());
					caiwuZsdz.setOrderId(xiechengZsdz.getOrderId());
					caiwuZsdz.setAccCheckBatchNo(xiechengZsdz.getAccCheckBatchNo());
					caiwuZsdzManager.add(caiwuZsdz);
					hgjx="";
					sdHgjy="";
				}
			}
			
			/**修改 根据id修改   携程发起对帐信息交通表**/
			xiechengFqdzxxJtManager.updateById(id);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 根据员工编号（登录名称）得到职级
	 */
	@Override
	public Map<String, Object> getEmployeeID(String EmployeeID) throws BusinessException {
		String sql = "SELECT NAME FROM org_level WHERE id = (SELECT t2.org_level_id FROM org_principal t LEFT JOIN org_member t2 ON t.member_id = t2.id WHERE t.login_name = '"+EmployeeID+"')";
		Map<String, Object> Level = jdbcTemplate.queryForMap(sql);
		return Level;
	}
	/**
	 * 根据员工编号（登录名称）得到部门
	 */
	@Override
	public Map<String, Object> getDepartment(String EmployeeID) throws BusinessException {
		if(EmployeeID ==null){
			throw new BusinessException("登录名丢失！！！");
		}
		String sql = "SELECT NAME FROM org_unit  WHERE id = (SELECT t2.org_department_ID FROM org_principal t LEFT JOIN org_member t2 ON t.member_id = t2.id WHERE t.login_name = '"+EmployeeID+"')";
		Map<String, Object> Department = jdbcTemplate.queryForMap(sql);
		return Department;
	}

	/**
	 * 员工形成确认，根据流程表单进行判断
	 */
	@Override
	public Map<String, Object> getDataByJourneyId(String journeyId) throws BusinessException {
		String zbID = (String) PropertiesUtils.getInstance().get("zbID");
		User user = AppContext.getCurrentUser();
        Long account = user.getAccountId();
		String formman = (String) PropertiesUtils.getInstance().get("formman");
		if(!zbID.equals(String.valueOf(account))){
			formman = (String) PropertiesUtils.getInstance().get("fGsformman");
		}
		String sql = "SELECT * FROM  "+formman+" WHERE field0002 ="+journeyId;
		Map<String, Object> Department = jdbcTemplate.queryForMap(sql);
		if(Department != null && Department.size() > 0){
			return Department;
		}
		return null;
	}

	@Override
	public void saveShijiXinxin(String memberIds, String approvalNumber, Long mainId, String formshiji) {
		xiechengJiaotongQxDao.saveShijiXinxin(memberIds, approvalNumber, mainId, formshiji);
	}
}
