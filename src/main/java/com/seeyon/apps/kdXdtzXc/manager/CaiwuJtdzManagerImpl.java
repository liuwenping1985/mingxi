package com.seeyon.apps.kdXdtzXc.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.dao.CaiwuJtdzDao;
import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
public class CaiwuJtdzManagerImpl implements CaiwuJtdzManager {

	private static final Log LOGGER = LogFactory.getLog(CaiwuJtdzManagerImpl.class);
	
	private CaiwuJtdzDao caiwuJtdzDao;
	
	public CaiwuJtdzDao getCaiwuJtdzDao() {
		return caiwuJtdzDao;
	}

	public void setCaiwuJtdzDao(CaiwuJtdzDao caiwuJtdzDao) {
		this.caiwuJtdzDao = caiwuJtdzDao;
	}

	
	public List<CaiwuJtdz> getAll() throws BusinessException {
		return caiwuJtdzDao.getAll();
	}

	public List<CaiwuJtdz> getDataByIds(Long[] ids) {
		return caiwuJtdzDao.getDataByIds(ids);
	}

	public CaiwuJtdz getDataById(Long id) throws BusinessException {
		return caiwuJtdzDao.getDataById(id);
	}

	public void add(CaiwuJtdz caiwuJtdz) throws BusinessException {
		caiwuJtdzDao.add(caiwuJtdz);
	}

	public void update(CaiwuJtdz caiwuJtdz) throws BusinessException {
		caiwuJtdzDao.update(caiwuJtdz);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		caiwuJtdzDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		caiwuJtdzDao.deleteById(id);
	}
	
	public FlipInfo getListCaiwuJtdzData(FlipInfo fi, Map<String, Object> params) throws BusinessException {
		String hql = "from CaiwuJtdz as caiwuJtdz ";
		List<CaiwuJtdz> dataList = DBAgent.find(hql, params, fi);
		fi.setData(dataList);
		return fi;
	}
	
	/***
	 * 修改支付
	 */
	@Override
	public void updateZhifu(Long ids) throws BusinessException {
		String sql = "update CAIWU_JTDZ  set CAIWU_JTDZ.ZF_QR = '支付' where CAIWU_JTDZ.ID ="+ids;	
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		jdbcTemplate.update(sql);
	}

	@Override
	public List<CaiwuJtdz> getPoiCaiwuJtdz(String date) {
		try {
			User user = AppContext.getCurrentUser();
	        Long account = user.getAccountId();
	        String accountid = String.valueOf(account);
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			 	Date beginTo;
			    Date endTo;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(dateFormat.parse(date));
				calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
				beginTo = calendar.getTime();
				
			    calendar.setTime(dateFormat.parse(date));
			    calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
			    endTo = calendar.getTime();
			        
			    String hql = "from CaiwuJtdz as caiwuJtdz where caiwuJtdz.createTime >= :createTime and caiwuJtdz.createTime <= :createTime1 and caiwuJtdz.extAttr3 = :extAttr3";
			    String beg=dateFormat.format(beginTo);
			    String end=dateFormat.format(endTo);
			    Map<String, Object>map=new HashMap<String, Object>();
			    map.put("createTime", beg);
			    map.put("createTime1", end);
			    map.put("extAttr3", accountid);
			List<CaiwuJtdz> dataList = DBAgent.find(hql,map);
			return dataList;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void updateHeguiJT(Long id) {
		String updateSql="UPDATE CAIWU_JTDZ SET SGHGJX='合规' WHERE ID="+id;
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		jdbcTemplate.update(updateSql);
	}
	
	/**
	 * 弹出框 合规
	 * @param fi
	 * @param params
	 * @return
	 * @throws BusinessException
	 * @throws ParseException 
	 */
	public FlipInfo getListCaiwuJtdzDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String beginStr = params.get("bigdate")+"";
        String texValue = params.get("texValue")+""; //文本框
        String val = params.get("val")+""; //选择框
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
            
            String hql = "from CaiwuJtdz as caiwuJtdz where caiwuJtdz.accCheckBatchNo = :accCheckBatchNo order by NLSSORT(caiwuJtdz.passengerName,'NLS_SORT=SCHINESE_PINYIN_M')";
            String beg=dateFormat.format(beginTo);
            String end=dateFormat.format(endTo);
            Map<String, Object>map=new HashMap<String, Object>();
            /*map.put("createTime", beg);
            map.put("createTime1", end);*/
            map.put("accCheckBatchNo", accCheckBatchNo);
            if(!StringUtils.isEmpty(val) && "cjrxm".equals(val)){//乘机人姓名
            	hql+=" and caiwuJtdz.passengerName like :passengerName";
            	map.put("passengerName", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "bm".equals(val)){//部门
            	hql+=" and caiwuJtdz.dept like :dept";
            	map.put("dept", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "hgjy".equals(val)){//合规校验
            	if("未合规".equals(texValue)){
            		hql+=" and caiwuJtdz.sGhgjx != :hgjx";
                	map.put("hgjx", "合规");
            	}else{
            		hql+=" and caiwuJtdz.sGhgjx like :hgjx";
                	map.put("hgjx", texValue+"%");	
            	}
            	
            }
            if(!StringUtils.isEmpty(val) && "ygxcqr".equals(val)){//员工行程确认
            	hql+=" and caiwuJtdz.ygxcQr like :ygxcQr";
            	map.put("ygxcQr", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "cw".equals(val)){//舱位
            	hql+=" and caiwuJtdz.className like :className";
            	map.put("className", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "zfQr".equals(val)){//舱位
            	hql+=" and caiwuJtdz.zfQr = :zfQr";
            	map.put("zfQr", texValue);
            }
            hql+=" ORDER BY caiwuJtdz.journeyId DESC";
    		List<CaiwuJtdz> dataList = DBAgent.find(hql,map,fi);
    		fi.setData(dataList);
    		return fi;
	}

	@Override
	public String getJtSum(String bigDate) throws ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		
		SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		Date beginTo;
        Date endTo;
		
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(dateFormat.parse(bigDate));
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
		beginTo = calendar.getTime();
		
            calendar.setTime(dateFormat.parse(bigDate));
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
            
            String sql="SELECT NVL(SUM(AMOUNT), 0) as AMOUNTCWJT FROM CAIWU_JTDZ WHERE ZF_QR ='支付' accCheckBatchNo = '"+accCheckBatchNo+"' order by NLSSORT(PASSENGER_NAME,'NLS_SORT=SCHINESE_PINYIN_M')";
            List<Map<String, Object>> Listcwjt = jdbcTemplate.queryForList(sql);
            if(Listcwjt != null && Listcwjt.size() >0){
            	String sum=Listcwjt.get(0).get("AMOUNTCWJT")+"";
            	return sum;
            }
            return null;
	}

	@Override
	public void updateXieChengfqdzxxjt(String year, String month) {
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		User user = AppContext.getCurrentUser();
        Long account = user.getAccountId();
        String accountid = String.valueOf(account);
        String sql ="";
		if("-1792902092017745579".equals(accountid)){ //总部
   		 sql = "UPDATE XIECHENG_FQDZXX_JT  SET zbcw = '已传送' WHERE XIECHENG_FQDZXX_JT.YEAR='"+year+"' and XIECHENG_FQDZXX_JT.MONTH='"+month+"'";	
		}
		if("2662344410291130278".equals(accountid)){ //北分
			 sql = "UPDATE XIECHENG_FQDZXX_JT  SET bfcw = '已传送' WHERE XIECHENG_FQDZXX_JT.YEAR='"+year+"' and XIECHENG_FQDZXX_JT.MONTH='"+month+"'";	
		 }
		if("1755267543710320898".equals(accountid)){//湖北
			 sql = "UPDATE XIECHENG_FQDZXX_JT  SET hbcw = '已传送' WHERE XIECHENG_FQDZXX_JT.YEAR='"+year+"' and XIECHENG_FQDZXX_JT.MONTH='"+month+"'";
		}
		if("-5358952287431081185".equals(accountid)){//江苏
			 sql = "UPDATE XIECHENG_FQDZXX_JT  SET jscw = '已传送' WHERE XIECHENG_FQDZXX_JT.YEAR='"+year+"' and XIECHENG_FQDZXX_JT.MONTH='"+month+"'";
		}
		jdbcTemplate.update(sql);
	}

	@Override
	public List<XiechengFqdzxxJt> getXieChengfqdzxxjt(String year, String month) {
		String hql="from XiechengFqdzxxJt c where c.year= :year and c.month= :month";
		Map<String, Object> map =new HashMap<String, Object>();
		map.put("year", year);
		map.put("month", month);
		List<XiechengFqdzxxJt> xiechengFqdzxxJtList = DBAgent.find(hql, map);
		return xiechengFqdzxxJtList;
	}
	public static String getcode(String userName) {
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String CODEsql = "SELECT ID,CODE FROM org_member WHERE name='" + userName+"'"; // 查询申请人code
		List<Map<String, Object>> orgName = jdbcTemplate.queryForList(CODEsql);
		String id = "";
		String userCode = "";
		if (orgName.size() > 0 && orgName != null) {
			id = orgName.get(0).get("ID") + "";
			userCode = orgName.get(0).get("CODE") + "";

		}
		return userCode;
	}
	
	public static String getAccountAndDepa(String AccountAndDepa){
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String sql="SELECT ID,NAME,CODE FROM ORG_UNIT WHERE ID = '"+AccountAndDepa+"'";
		List<Map<String, Object>> listAccountAndDepa = jdbcTemplate.queryForList(sql);
		if(listAccountAndDepa != null && listAccountAndDepa.size() > 0){
			String code=listAccountAndDepa.get(0).get("CODE")+"";
			return code;
		}
		return "";
	}

	@Override
	public String getJsonJT(List<Map<String, Object>> jtList) throws ParseException {
		StringBuffer buf = new StringBuffer();
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		SimpleDateFormat datesdf = new SimpleDateFormat("yyyy-MM-dd");
		User user = AppContext.getCurrentUser();
        Long account = user.getAccountId();
        String accountid = String.valueOf(account);
		String OAformman=""; //获取总部和分公司的表名
		if("-1792902092017745579".equals(accountid)){
			 OAformman = (String) PropertiesUtils.getInstance().get("formman");
		}else{
			OAformman = (String) PropertiesUtils.getInstance().get("fGsformman");
		}
		String accountForm = (String) PropertiesUtils.getInstance().get("accountForm");//财务机构表
    	String deptForm = (String) PropertiesUtils.getInstance().get("deptForm"); //财务部门表
    	String accountNumber  = "";
		String accountName  = "";
		String deptNumber  = "";
		String deptName  = "";
		String projectNumber  = "";
		String projectName  = "";
		String shenqingrendeptNumber  = "";
		String shenqingrendeptName  = "";
		String userCodeSqr  = "";
		String userCode ="";
		String deptNumbersqr="";
		String deptNamesqr="";
		String IsDgj="";
		if(jtList != null && jtList.size() > 0){
			buf.append("<ns1:P_TBL_FLIGHT_TRX>");
			for (int i=0;i<jtList.size();i++) {
				Map<String, Object> map = jtList.get(i);
				String danhao=map.get("APPLICATION_NUMBER")+"";
				String passengerName = map.get("PASSENGER_NAME") == null ? "" : (map.get("PASSENGER_NAME")+"");//乘机人
				String card_owner = map.get("CARD_OWNER") == null ? "" : (map.get("CARD_OWNER")+"");//申请人
				String userSql = "SELECT ID,CODE , IS_DGJ FROM org_member WHERE NAME='" + passengerName + "'";
				List<Map<String, Object>> orgName = jdbcTemplate.queryForList(userSql);
				if (orgName.size() > 0 && orgName != null) {
					String IsDgjType = orgName.get(0).get("IS_DGJ") + "";

					if(!StringUtils.isEmpty(IsDgjType) && !"null".equals(IsDgjType)){
						IsDgj="Y";
					}else{
						IsDgj="N";
					}
				}
				LOGGER.info("开始调用"+danhao);
				String jTzfqr  = "";
				String zhiFuSql = "SELECT * FROM CAIWU_JTDZ WHERE JOURNEY_ID ='"+danhao+"'"; // 申请人的部门
				List<Map<String, Object>> zhifu = jdbcTemplate.queryForList(zhiFuSql);
				if(zhifu != null && zhifu.size() > 0){
					jTzfqr=zhifu.get(0).get("ZF_QR")+"";
				}else{
					jTzfqr="未支付";
				}
				if("未支付".equals(jTzfqr)){
					continue;
				}
				
				String sql = "SELECT * FROM "+OAformman+" where field0002='" + danhao+"'";
				List<Map<String, Object>> yuanDanHao = jdbcTemplate.queryForList(sql);
				if(yuanDanHao != null && yuanDanHao.size() > 0){
					Map<String, Object> yuanDanHaoMap = yuanDanHao.get(0);
					String biaodan = (String) yuanDanHaoMap.get("field0002") == null ? "" : (String) yuanDanHaoMap.get("field0002");
					String shenQingRen = (String) yuanDanHaoMap.get("field0003") == null ? "" : (String) yuanDanHaoMap.get("field0003");// 申请人
					String accountId = (String) yuanDanHaoMap.get("field0004") == null ? "" : (String) yuanDanHaoMap.get("field0004");// 申请人机构
					String shenQingRenDept = (String) yuanDanHaoMap.get("field0005") == null ? "" : (String) yuanDanHaoMap.get("field0005");// 申请人所在部门
					String dinPiaoRen = (String) yuanDanHaoMap.get("field0021") == null ? "" : (String) yuanDanHaoMap.get("field0021");// 订票人
					 projectName = (String) yuanDanHaoMap.get("field0022") == null ? "" : (String) yuanDanHaoMap.get("field0022");// 项目名称
					 projectNumber = (String) yuanDanHaoMap.get("field0024") == null ? "" : (String) yuanDanHaoMap.get("field0024");// 项目编号
					String shouYiBuMen = (String) yuanDanHaoMap.get("field0025") == null ? "" : (String) yuanDanHaoMap.get("field0025");// 受益部门
					 userCode = getcode(passengerName); // 获取乘机人code
					 userCodeSqr = getcode(card_owner); // 获取申请人code
					
					String accountIDDpr = getAccountAndDepa(accountId);
					String orgsql = "select * from "+accountForm+" WHERE field0003 ='" + accountIDDpr + "'";
					List<Map<String, Object>> accountidList = jdbcTemplate.queryForList(orgsql);
					if(accountidList != null && accountidList.size() >0){
						accountNumber = accountidList.get(0).get("field0001") + "";// 财务机构编码
						accountName = accountidList.get(0).get("field0002") + "";// 财务机构名称	
						}
					
					String shouYiBuMenCode = getAccountAndDepa(shouYiBuMen);
					String bumensql = "SELECT * FROM "+deptForm+" WHERE field0003='" + shouYiBuMenCode + "'"; // 受益部门
					List<Map<String, Object>> deapid = jdbcTemplate.queryForList(bumensql);
					if(deapid != null && deapid.size() > 0){
						deptNumber = deapid.get(0).get("field0001") + "";// 财务受益部门编码
						deptName = deapid.get(0).get("field0002") + "";// 财务受益部门名称
					}
					
					String shenQingRenDeptCode = getAccountAndDepa(shenQingRenDept);
					String bumensqlSqr = "SELECT * FROM "+deptForm+" WHERE field0003='" + shenQingRenDeptCode + "'"; // 申请人部门
					List<Map<String, Object>> deapidList = jdbcTemplate.queryForList(bumensqlSqr);
					if(deapidList != null && deapidList.size() > 0){
						deptNumbersqr = deapidList.get(0).get("field0001") + "";// 申请人部门编码
						deptNamesqr = deapidList.get(0).get("field0002") + "";// 申请人部门名称
					}
				
				}
				
				String order_number = map.get("ORDER_NUMBER") == null ? "" : (map.get("ORDER_NUMBER")+"");
				String caad_id = map.get("CARD_ID") == null ? "" : (map.get("CARD_ID")+"");
				
				String PASSENGER_NUMBER = map.get("PASSENGER_NUMBER") == null ? "" : (map.get("PASSENGER_NUMBER")+"");
				String REFUND_FEE = map.get("REFUND_FEE") == null ? "" : (map.get("REFUND_FEE")+"");
				String AMOUNT = map.get("AMOUNT") == null ? "" : (map.get("AMOUNT")+"");
				buf.append("<ns1:P_TBL_FLIGHT_TRX_ITEM>");
		        buf.append("<ns1:ORDER_NUMBER>"+order_number+"</ns1:ORDER_NUMBER>");
		        buf.append("<ns1:CARD_ID>"+(String)map.get("CARD_ID")+"</ns1:CARD_ID>");
		        buf.append("<ns1:CARD_OWNER>"+(String)map.get("CARD_OWNER")+"</ns1:CARD_OWNER>");
		        buf.append("<ns1:PASSENGER_NAME>"+(String)map.get("PASSENGER_NAME")+"</ns1:PASSENGER_NAME>");
		        buf.append("<ns1:PASSENGER_NUMBER>"+userCode+"</ns1:PASSENGER_NUMBER>");
		        buf.append("<ns1:BOOK_EMP_NAME/>");
		        buf.append("<ns1:BOOK_EMP_ID/>");
		        buf.append("<ns1:COMPANY_CODE1>"+accountNumber+"</ns1:COMPANY_CODE1>");
		        buf.append("<ns1:COMPANY_NAME1/>");
		        buf.append("<ns1:DEPT_NUMBER1>"+deptNumber+"</ns1:DEPT_NUMBER1>");
		        buf.append("<ns1:DEPT_NAME1/>");
		        buf.append("<ns1:COMPANY_CODE2/>");
		        buf.append("<ns1:COMPANY_NAME2/>");
		        buf.append("<ns1:DEPT_NUMBER2/>");
		        buf.append("<ns1:DEPT_NAME2/>");
		        buf.append("<ns1:PROJECT_NUMBER>"+projectNumber+"</ns1:PROJECT_NUMBER>");
		        buf.append("<ns1:PROJECT_NAME/>");
		        buf.append("<ns1:COST_CENTER>"+deptNumbersqr+"</ns1:COST_CENTER>");
		        buf.append("<ns1:COST_CENTER2/>");
		        buf.append("<ns1:SOURCE_CODE>OA_XC</ns1:SOURCE_CODE>");
		        buf.append("<ns1:SOURCE_NAME>OA携程</ns1:SOURCE_NAME>");
		        buf.append("<ns1:TAKE_OFF_TIME>"+datesdf.format(datesdf.parse((String)map.get("TAKE_OFF_TIME")))+"</ns1:TAKE_OFF_TIME>");
		        buf.append("<ns1:ARRIVAL_TIME>"+datesdf.format(datesdf.parse((String)map.get("ARRIVAL_TIME")))+"</ns1:ARRIVAL_TIME>");
		        buf.append("<ns1:FLIGHT_CLASS>"+(String)map.get("FLIGHT_CLASS")+"</ns1:FLIGHT_CLASS>");
		        buf.append("<ns1:FLIGHT_RANGE>"+String.valueOf(map.get("FLIGHT_RANGE"))+"</ns1:FLIGHT_RANGE>");
		        buf.append("<ns1:FLIGHT_NO>"+(String)map.get("FLIGHT_NO")+"</ns1:FLIGHT_NO>");
		        buf.append("<ns1:CLASS_NAME>"+(String)map.get("CLASS_NAME")+"</ns1:CLASS_NAME>");
		        buf.append("<ns1:CLASS_REASON>"+(String)map.get("CLASS_REASON")+"</ns1:CLASS_REASON>");
		        buf.append("<ns1:PRINT_TICKET_TIME>"+datesdf.format(datesdf.parse((String)map.get("PRINT_TICKET_TIME")))+"</ns1:PRINT_TICKET_TIME>");
		        buf.append("<ns1:BUSINESS_TRIP_SITE>"+(String)map.get("BUSINESS_TRIP_SITE")+"</ns1:BUSINESS_TRIP_SITE>");
		        buf.append("<ns1:AIRPORT_NAME>"+(String)map.get("AIRPORT_NAME")+"</ns1:AIRPORT_NAME>");
		        buf.append("<ns1:ORDER_TYPE>"+Integer.valueOf(map.get("ORDER_TYPE")+"")+"</ns1:ORDER_TYPE>");
		        buf.append("<ns1:CURRENCY_CODE>"+(String)map.get("CURRENCY_CODE")+"</ns1:CURRENCY_CODE>");
		        buf.append("<ns1:CIVIL_AVIATION_FUND>"+(map.get("CIVIL_AVIATION_FUND")+"")+"</ns1:CIVIL_AVIATION_FUND>");
		        buf.append("<ns1:DISCOUNT>"+Double.valueOf(map.get("DISCOUNT")+"")+"</ns1:DISCOUNT>");
		        buf.append("<ns1:STANDARD_PRICE>"+Integer.valueOf(map.get("STANDARD_PRICE")+"")+"</ns1:STANDARD_PRICE>");
		        buf.append("<ns1:LOW_RATE>"+Double.valueOf(map.get("LOW_RATE")+"")+"</ns1:LOW_RATE>");
		        buf.append("<ns1:LOW_PRICE>"+Integer.valueOf(map.get("LOW_PRICE")+"")+"</ns1:LOW_PRICE>");
		        buf.append("<ns1:DEAL_NET_PRICE>"+Integer.valueOf(map.get("DEAL_NET_PRICE")+"")+"</ns1:DEAL_NET_PRICE>");
		        buf.append("<ns1:OIL_FEE>"+Integer.valueOf(map.get("OIL_FEE")+"")+"</ns1:OIL_FEE>");
		        buf.append("<ns1:SEND_TICKET_FEE>"+Integer.valueOf(map.get("SEND_TICKET_FEE")+"")+"</ns1:SEND_TICKET_FEE>");
		        buf.append("<ns1:INSURANCE_FEE>"+Integer.valueOf(map.get("INSURANCE_FEE")+"")+"</ns1:INSURANCE_FEE>");
		        buf.append("<ns1:SERVICE_FEE>"+Integer.valueOf(map.get("SERVICE_FEE")+"")+"</ns1:SERVICE_FEE>");
		        buf.append("<ns1:DISCOUNT_COUPON>"+Integer.valueOf(map.get("DISCOUNT_COUPON")+"")+"</ns1:DISCOUNT_COUPON>");
		        buf.append("<ns1:REBOOK_FEE>"+Integer.valueOf(map.get("REBOOK_FEE")+"")+"</ns1:REBOOK_FEE>");
		        buf.append("<ns1:REBOOKING_SERVICE_FEE>"+Integer.valueOf(map.get("REBOOKING_SERVICE_FEE")+"")+"</ns1:REBOOKING_SERVICE_FEE>");
		        buf.append("<ns1:BASE_SERVICE_FEE>"+Integer.valueOf(map.get("BASE_SERVICE_FEE")+"")+"</ns1:BASE_SERVICE_FEE>");
		        buf.append("<ns1:UNWORKTIME_SERVICE_FEE>"+Integer.valueOf(map.get("UNWORKTIME_SERVICE_FEE")+"")+"</ns1:UNWORKTIME_SERVICE_FEE>");
		        buf.append("<ns1:VIP_SERVICE_FEE>"+Integer.valueOf(map.get("VIP_SERVICE_FEE")+"")+"</ns1:VIP_SERVICE_FEE>");
		        buf.append("<ns1:BIND_SERVICE_FEE>"+Integer.valueOf(map.get("BIND_SERVICE_FEE")+"")+"</ns1:BIND_SERVICE_FEE>");
		        buf.append("<ns1:REFUND_SERVICE_FEE/>");
		        buf.append("<ns1:REFUND_FEE>"+REFUND_FEE+"</ns1:REFUND_FEE>");
		        buf.append("<ns1:AMOUNT>"+AMOUNT+"</ns1:AMOUNT>");
		        buf.append("<ns1:OUT_OF_POCKET>"+AMOUNT+"</ns1:OUT_OF_POCKET>");
		        buf.append("<ns1:COMMENTS/>");
		        buf.append("<ns1:EXPENSE_TYPE_CODE>JP</ns1:EXPENSE_TYPE_CODE>");
		        buf.append("<ns1:EXPENSE_TYPE>携程-机票</ns1:EXPENSE_TYPE>");
		        buf.append("<ns1:APPLICATION_NUMBER>"+(String)map.get("APPLICATION_NUMBER")+"</ns1:APPLICATION_NUMBER>");
		        buf.append("<ns1:APPLICATION_PERSON>"+userCodeSqr+"</ns1:APPLICATION_PERSON>");
		        buf.append("<ns1:ORG_ID>81</ns1:ORG_ID>");
		        buf.append("<ns1:STATUS/>");
		        buf.append("<ns1:MESSAGES/>");
		        buf.append("<ns1:CARDTYPE_NAME/>");
		        buf.append("<ns1:CARDTYPE_NUMBER/>");
		        buf.append("<ns1:DS_FLAG>"+IsDgj+"</ns1:DS_FLAG>");
		        buf.append("<ns1:BATCH_ID/>");
		        buf.append("<ns1:ATTRIBUTE1/>");
		        buf.append("<ns1:ATTRIBUTE2/>");
		        buf.append("<ns1:ATTRIBUTE3/>");
		        buf.append("<ns1:ATTRIBUTE4/>");
		        buf.append("<ns1:ATTRIBUTE5/>");
		        buf.append("<ns1:ATTRIBUTE6/>");
		        buf.append("<ns1:URL_LINE>");
		        buf.append("<ns1:URL_LINE_ITEM>");
		        buf.append("<ns1:SEQ_NUM/>");
		        buf.append("<ns1:TITLE/>");
		        buf.append("<ns1:DOCUMENT_DESCRIPTION/>");
		        buf.append("<ns1:URL/>");
		        buf.append("</ns1:URL_LINE_ITEM>");
		        buf.append("</ns1:URL_LINE>");
		        buf.append("</ns1:P_TBL_FLIGHT_TRX_ITEM>");
			
	}
			buf.append("</ns1:P_TBL_FLIGHT_TRX>");
			return buf.toString();
		}else{
			return"<ns1:P_TBL_FLIGHT_TRX/>"; 
		}
	}

	@Override
	public String getJsonJD(List<Map<String, Object>> jdList) throws ParseException {
		StringBuffer buf = new StringBuffer();
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		SimpleDateFormat datesdf = new SimpleDateFormat("yyyy-MM-dd");
		User user = AppContext.getCurrentUser();
        Long account = user.getAccountId();
        String accountid = String.valueOf(account);
        String accountNumber  = "";
		String accountName  = "";
		String deptNumber  = "";
		String deptName  = "";
		String projectNumber  = "";
		String projectName  = "";
		String shenqingrendeptNumber  = "";
		String shenqingrendeptName  = "";
		String memberName  = "";
		String dinpiaorencode  = "";
		String userCodeSqr  = "";
		String zSzfqr  = "";
		String IsDgj = "";
		String userCode="";
		String deptNumbersqr="";
		String deptNamesqr="";
		
		
		String OAformman=""; //获取总部和分公司的表名
		if("-1792902092017745579".equals(accountid)){
			 OAformman = (String) PropertiesUtils.getInstance().get("formman");
		}else{
			OAformman = (String) PropertiesUtils.getInstance().get("fGsformman");
		}
		String accountForm = (String) PropertiesUtils.getInstance().get("accountForm");//财务机构表
    	String deptForm = (String) PropertiesUtils.getInstance().get("deptForm"); //财务部门表
    	
		if(jdList != null && jdList.size() > 0){
			buf.append("<ns1:P_TBL_HOTEL_TRX>");
			for (int i=0;i<jdList.size();i++) {
				Map<String, Object> map = jdList.get(i);
				String danhao=map.get("APPLICATION_NUMBER")+""; //10.40.144.2:80
				String checkInPerson=map.get("CHECK_IN_PERSON")+"";
				String chuChaiRen="";
				String sql = "SELECT * FROM "+OAformman+" where field0002='" + danhao+"'";
				List<Map<String, Object>> yuanDanHao = jdbcTemplate.queryForList(sql);
				if(yuanDanHao != null && yuanDanHao.size() > 0){
					Map<String, Object> yuanDanHaoMap = yuanDanHao.get(0);
					String biaodan = (String) yuanDanHaoMap.get("field0002") == null ? "" : (String) yuanDanHaoMap.get("field0002");
					String shenQingRen = (String) yuanDanHaoMap.get("field0003") == null ? "" : (String) yuanDanHaoMap.get("field0003");// 申请人
					String accountId = (String) yuanDanHaoMap.get("field0004") == null ? "" : (String) yuanDanHaoMap.get("field0004");// 申请人机构
					String shenQingRenDept = (String) yuanDanHaoMap.get("field0005") == null ? "" : (String) yuanDanHaoMap.get("field0005");// 申请人所在部门
					String dinPiaoRen = (String) yuanDanHaoMap.get("field0021") == null ? "" : (String) yuanDanHaoMap.get("field0021");// 订票人
					 projectName = (String) yuanDanHaoMap.get("field0022") == null ? "" : (String) yuanDanHaoMap.get("field0022");// 项目名称
					 projectNumber = (String) yuanDanHaoMap.get("field0024") == null ? "" : (String) yuanDanHaoMap.get("field0024");// 项目编号
					String shouYiBuMen = (String) yuanDanHaoMap.get("field0025") == null ? "" : (String) yuanDanHaoMap.get("field0025");// 受益部门
					String[] dinpiaomemberAry = checkInPerson.split(",");
					if(dinpiaomemberAry != null && dinpiaomemberAry.length > 0){chuChaiRen=dinpiaomemberAry[0];}
					userCode = getcode(chuChaiRen); // 获取入住人code
					String memberNamesqr = Functions.showMemberName(Long.valueOf(shenQingRen));
					userCodeSqr = getcode(memberNamesqr); // 获取申请人code
					
					String accountIDDpr = getAccountAndDepa(accountId);
					String orgsql = "select * from "+accountForm+" WHERE field0003 ='" + accountIDDpr + "'";
					List<Map<String, Object>> accountidList = jdbcTemplate.queryForList(orgsql);
					if(accountidList != null && accountidList.size() >0){
						accountNumber = accountidList.get(0).get("field0001") + "";// 财务机构编码
						accountName = accountidList.get(0).get("field0002") + "";// 财务机构名称	
						}
					
					String shouYiBuMenCode = getAccountAndDepa(shouYiBuMen);
					String bumensql = "SELECT * FROM "+deptForm+" WHERE field0003='" + shouYiBuMenCode + "'"; // 受益部门
					List<Map<String, Object>> deapid = jdbcTemplate.queryForList(bumensql);
					if(deapid != null && deapid.size() > 0){
						deptNumber = deapid.get(0).get("field0001") + "";// 财务受益部门编码
						deptName = deapid.get(0).get("field0002") + "";// 财务受益部门名称
					}
					
					String shenQingRenDeptCode = getAccountAndDepa(shenQingRenDept);
					String bumensqlSqr = "SELECT * FROM "+deptForm+" WHERE field0003='" + shenQingRenDeptCode + "'"; // 申请人部门
					List<Map<String, Object>> deapidList = jdbcTemplate.queryForList(bumensqlSqr);
					if(deapidList != null && deapidList.size() > 0){
						deptNumbersqr = deapidList.get(0).get("field0001") + "";// 申请人部门编码
						deptNamesqr = deapidList.get(0).get("field0002") + "";// 申请人部门名称
					}
				
				}
				
				String userSql = "SELECT ID,CODE , IS_DGJ FROM org_member WHERE NAME='" + chuChaiRen + "'";
				List<Map<String, Object>> orgName = jdbcTemplate.queryForList(userSql);
				if (orgName.size() > 0 && orgName != null) {
					String IsDgjType = orgName.get(0).get("IS_DGJ") + "";

					if(!StringUtils.isEmpty(IsDgjType) && !"null".equals(IsDgjType)){
						IsDgj="Y";
					}else{
						IsDgj="N";
					}
				}
				String zhiFuSql = "SELECT * FROM CAIWU_ZSDZ WHERE JOURNEY_ID ='"+danhao+"'"; // 申请人的部门
				List<Map<String, Object>> zhifu = jdbcTemplate.queryForList(zhiFuSql);
				if(zhifu != null && zhifu.size() > 0){
					zSzfqr=zhifu.get(0).get("ZF_QR")+"";
				}else{
					zSzfqr="未支付";
				}
				
				if("未支付".equals(zSzfqr)){
					continue;
				}
				
				buf.append("<ns1:P_TBL_HOTEL_TRX_ITEM>");
		        buf.append("<ns1:ORDER_NUMBER>"+Long.valueOf(map.get("ORDER_NUMBER")+"")+"</ns1:ORDER_NUMBER>");
		        buf.append("<ns1:CARD_ID>"+(String)map.get("CARD_ID")+"</ns1:CARD_ID>");
		        buf.append("<ns1:CARD_OWNER/>");
		        buf.append("<ns1:CHECK_IN_PERSON>"+(String)map.get("CHECK_IN_PERSON")+"</ns1:CHECK_IN_PERSON>");
		        buf.append("<ns1:EMPLOYEE_NUMBER>"+userCode+"</ns1:EMPLOYEE_NUMBER>");
		        buf.append("<ns1:EMPLOYEE_ID/>");
		        buf.append("<ns1:BOOK_EMP_NAME>"+memberName+"</ns1:BOOK_EMP_NAME>");
		        buf.append("<ns1:BOOK_EMP_ID>"+dinpiaorencode+"</ns1:BOOK_EMP_ID>");
		        buf.append("<ns1:COMPANY_CODE1>"+accountNumber+"</ns1:COMPANY_CODE1>");
		        buf.append("<ns1:COMPANY_NAME1/>");
		        buf.append("<ns1:DEPT_NUMBER1>"+deptNumber+"</ns1:DEPT_NUMBER1>");
		        buf.append("<ns1:DEPT_NAME1/>");
		        buf.append("<ns1:COMPANY_CODE2/>");
		        buf.append("<ns1:COMPANY_NAME2/>");
		        buf.append("<ns1:DEPT_NUMBER2/>");
		        buf.append("<ns1:DEPT_NAME2/>");
		        buf.append("<ns1:PROJECT_NUMBER>"+projectNumber+"</ns1:PROJECT_NUMBER>");
		        buf.append("<ns1:PROJECT_NAME/>");
		        buf.append("<ns1:COST_CENTER>"+deptNumbersqr+"</ns1:COST_CENTER>");
		        buf.append("<ns1:COST_CENTER2/>");
		        buf.append("<ns1:SOURCE_CODE>OA_XC</ns1:SOURCE_CODE>");
		        buf.append("<ns1:SOURCE_NAME/>");
		        buf.append("<ns1:ORDER_DATE>"+datesdf.format(datesdf.parse((String)map.get("ORDER_DATE")))+"</ns1:ORDER_DATE>");
		        buf.append("<ns1:CHECK_IN_TIME>"+datesdf.format(datesdf.parse((String)map.get("CHECK_IN_TIME")))+"</ns1:CHECK_IN_TIME>");
		        buf.append("<ns1:CHECK_OUT_TIME>"+datesdf.format(datesdf.parse((String)map.get("CHECK_OUT_TIME")))+"</ns1:CHECK_OUT_TIME>");
		        buf.append("<ns1:HOTEL_CITY>"+(String)map.get("HOTEL_CITY")+"</ns1:HOTEL_CITY>");
		        buf.append("<ns1:HOTEL_NAME>"+(String)map.get("HOTEL_NAME")+"</ns1:HOTEL_NAME>");
		        buf.append("<ns1:HOUSE_TYPE>"+(String)map.get("HOUSE_TYPE")+"</ns1:HOUSE_TYPE>");
		        buf.append("<ns1:QUANTITY_OF_ROOM>"+Integer.valueOf(map.get("QUANTITY_OF_ROOM")+"")+"</ns1:QUANTITY_OF_ROOM>");
		        buf.append("<ns1:STAR_LEVEL>"+String.valueOf(map.get("STAR_LEVEL"))+"</ns1:STAR_LEVEL>");
		        buf.append("<ns1:ROOM_NIGHT>"+Integer.valueOf(map.get("ROOM_NIGHT")+"")+"</ns1:ROOM_NIGHT>");
		        buf.append("<ns1:CURRENCY_CODE>"+(String)map.get("CURRENCY_CODE")+"</ns1:CURRENCY_CODE>");
		        buf.append("<ns1:UNIT_PRICE>"+String.valueOf(map.get("UNIT_PRICE")+"")+"</ns1:UNIT_PRICE>");
		        buf.append("<ns1:SERVICE_FEE>"+Double.valueOf(map.get("SERVICE_FEE")+"")+"</ns1:SERVICE_FEE>");
		        buf.append("<ns1:EXTRA_CHARGE>"+Double.valueOf(map.get("EXTRA_CHARGE")+"")+"</ns1:EXTRA_CHARGE>");
		        buf.append("<ns1:AMOUNT>"+Double.valueOf(map.get("AMOUNT")+"")+"</ns1:AMOUNT>");
		        buf.append("<ns1:TOTAL_PRICE>"+Double.valueOf(map.get("TOTAL_PRICE")+"")+"</ns1:TOTAL_PRICE>");
		        buf.append("<ns1:ORDER_TYPE>"+Integer.valueOf(map.get("ORDER_TYPE")+"")+"</ns1:ORDER_TYPE>");
		        buf.append("<ns1:COMMENTS>"+(String)map.get("COMMENTS")+"</ns1:COMMENTS>");
		        buf.append("<ns1:EXPENSE_TYPE_CODE>ZS</ns1:EXPENSE_TYPE_CODE>");
		        buf.append("<ns1:EXPENSE_TYPE>携程-住宿</ns1:EXPENSE_TYPE>");
		        buf.append("<ns1:APPLICATION_NUMBER>"+(String)map.get("APPLICATION_NUMBER")+"</ns1:APPLICATION_NUMBER>");
		        buf.append("<ns1:APPLICATION_PERSON>"+userCodeSqr+"</ns1:APPLICATION_PERSON>");
		        buf.append("<ns1:ORG_ID>81</ns1:ORG_ID>");
		       // buf.append("<ns1:DS_FLAG>"+IsDgj+"</ns1:DS_FLAG>");
		        buf.append("<ns1:STATUS/>");
		        buf.append("<ns1:MESSAGES/>");
		        buf.append("<ns1:BATCH_ID/>");
		        buf.append("<ns1:ATTRIBUTE1/>");
		        buf.append("<ns1:ATTRIBUTE2/>");
		        buf.append("<ns1:ATTRIBUTE3/>");
		        buf.append("<ns1:ATTRIBUTE4/>");
		        buf.append("<ns1:ATTRIBUTE5/>");
		        buf.append("<ns1:ATTRIBUTE6/>");
		        buf.append("<ns1:URL_LINE>");
		        buf.append("<ns1:URL_LINE_ITEM>");
		        buf.append("<ns1:SEQ_NUM/>");
		        buf.append("<ns1:TITLE/>");
		        buf.append("<ns1:DOCUMENT_DESCRIPTION/>");
		        buf.append("<ns1:URL/>");
		        buf.append("</ns1:URL_LINE_ITEM>");
		        buf.append("</ns1:URL_LINE>");
		        buf.append("</ns1:P_TBL_HOTEL_TRX_ITEM>");
			}
			buf.append("</ns1:P_TBL_HOTEL_TRX>");
			return buf.toString();
		}
		else{
			return "<ns1:P_TBL_HOTEL_TRX/>";
		}
		
	}


}
