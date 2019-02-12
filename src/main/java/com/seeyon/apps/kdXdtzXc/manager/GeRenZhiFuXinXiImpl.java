package com.seeyon.apps.kdXdtzXc.manager;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.CarAndShip;
import com.seeyon.apps.kdXdtzXc.po.JiuDianFaPiao;
import com.seeyon.apps.kdXdtzXc.po.TrafficFeiXieCheng;
import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.UUIDLong;

public class GeRenZhiFuXinXiImpl implements GeRenZhiFuXinXi{
	private static JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	@Override
	public int addcarAndship(CarAndShip carAndShip) {
		// TODO Auto-generated method stub
		try {
			String sql="INSERT INTO carandship VALUES('"+carAndShip.getId()+"','"+carAndShip.getXHnumber()+"','"+carAndShip.getJTType()+"',"+carAndShip.getCjFee()+","+carAndShip.getQTfee()+",'"+carAndShip.getFeeType()+"','"+carAndShip.getBeizhu()+"',"+carAndShip.getCczong()+","+carAndShip.getQtzong()+",'"+carAndShip.getFormrecid()+"')";
			int addcarAndshipint = jdbcTemplate.update(sql);
			return addcarAndshipint;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int addzhusu(JiuDianFaPiao jdfp) {
		try {
			String sql ="INSERT INTO zhusu VALUES('"+jdfp.getId()+"','"+jdfp.getXuhao()+"','"+jdfp.getZhuanpiao()+"',"+jdfp.getJsheji()+","+jdfp.getJine()+","+jdfp.getShuie()+",'"+jdfp.getShuil()+"','"+jdfp.getFapiaohao()+"',"+jdfp.getHeji()+",'"+jdfp.getFormid()+"')";
			int addzhusuint = jdbcTemplate.update(sql);
			return addzhusuint;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int addtongji(String pjnumber, BigDecimal zheji, String formid) {
		try {
			String sql ="INSERT INTO shujutongji VALUES('"+String.valueOf(UUIDLong.longUUID())+"','"+pjnumber+"',"+zheji+",'"+formid+"')";
			int addtongji = jdbcTemplate.update(sql);
			return addtongji;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}
	@Override
	public List<Map<String, Object>> queryCarAndShip(String danhaoid) {
		String carandship="SELECT * FROM carandship WHERE formrecid='"+danhaoid+"'"; //车船机票费
		List<Map<String, Object>> carandshipList = jdbcTemplate.queryForList(carandship);
		return carandshipList;
	}

	@Override
	public List<Map<String, Object>> queryZhuSu(String danhaoid) {
		String zhusu="SELECT * FROM zhusu WHERE formid='"+danhaoid+"'";              //住宿
		List<Map<String, Object>> zhuSuList = jdbcTemplate.queryForList(zhusu);
		return zhuSuList;
	}

	@Override
	public int addTraffic(TrafficFeiXieCheng tar) {
		try {
			String trafficSql="INSERT INTO traffic VALUES('"+tar.getId()+"','"+tar.getXuhao()+"','"+tar.getBaoxiaofangshi()+"','"+tar.getShifoupaiche()+"','"+tar.getJine()+"','"+tar.getBeizhu()+"','"+tar.getDanhao()+"',"+tar.getZheji()+")";
			int tra = jdbcTemplate.update(trafficSql);
			return tra;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public List<Map<String, Object>> queryTongJi(String danhaoid) {
		String shujutongji="SELECT * FROM shujutongji WHERE formid='"+danhaoid+"'";  //总计
		List<Map<String, Object>> shujutongjiList = jdbcTemplate.queryForList(shujutongji);
		return shujutongjiList;
	}

	@Override
	public void insertXinXiQR(Long id, Long formmain_id, Integer sort, Integer xuhao, Long chuchairen, String url) {
			JdbcTemplate jdbcTemplate1 = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			String formshiji = (String) PropertiesUtils.getInstance().get("formsonShijiXinxi");
			String insertxc = "INSERT INTO "+formshiji+" (id,formmain_id,sort,field0030,field0031,field0033) " +
					"VALUES ("+id+","+formmain_id+","+sort+","+xuhao+","+chuchairen+",'"+url+"')";
				
			int update = jdbcTemplate1.update(insertxc);
			
		
	}
	public static String getcode(String userId){
    	String CODEsql="SELECT ID,CODE FROM org_member WHERE ID="+userId; //查询申请人code
		List<Map<String, Object>> orgName = jdbcTemplate.queryForList(CODEsql);
		String id="";
		String userCode="";
		if(orgName.size()>0 && orgName !=null){
			id=orgName.get(0).get("ID")+"";
			userCode=orgName.get(0).get("CODE")+"";
			
		}
		return userCode;
    }
	
	   
    public static Map<String,Object> getAccountDept(String account,String dept){
    	String accountForm = (String) PropertiesUtils.getInstance().get("accountForm");
    	String deptForm = (String) PropertiesUtils.getInstance().get("deptForm");
    	Map<String, Object> hashMap = new HashMap<String, Object>();
    	if(!StringUtils.isEmpty(account)){
    		String orgsql="select * from "+accountForm+" WHERE field0003 ='"+account+"'";
    		List<Map<String, Object>> accountid = jdbcTemplate.queryForList(orgsql);
    		String accountNumber ="";
    		String accountName ="";
    		if(accountid != null && accountid.size() >0){
    			 accountNumber = accountid.get(0).get("field0001")+"";//财务机构编码
        		 accountName = accountid.get(0).get("field0002")+"";//财务机构名称	
    		}
    		
    		hashMap.put("accountNumber", accountNumber);
    		hashMap.put("accountName", accountName);
    	}
    	if(!StringUtils.isEmpty(dept)){
		String bumensql="SELECT * FROM "+deptForm+" WHERE field0003='"+dept+"'"; //出差人的
		List<Map<String, Object>> deapid = jdbcTemplate.queryForList(bumensql);
		if(deapid != null && deapid.size() > 0){
			String deptNumber = deapid.get(0).get("field0001")+"";//财务部门编码
			String deptName = deapid.get(0).get("field0002")+"";//财务部门名称
			hashMap.put("deptNumber", deptNumber);
			hashMap.put("deptName", deptName);
			}
    	}
    	return hashMap;
    }
	@Override
	public List<Map<String, Object>> getFeiXcXmlTou() {
		//String zhubiaosql="SELECT * FROM formmain_0108 where field0015=817151701516569968"; //这里sql 需要移动到配置文件中
		String formman = (String) PropertiesUtils.getInstance().get("formman"); 
		String getDayDate = (String) PropertiesUtils.getInstance().get("dayDate");
		int dayDate= 5;
		if(!StringUtils.isEmpty(getDayDate)){
			dayDate=Integer.valueOf(getDayDate);
		}
		Calendar instance = Calendar.getInstance();
		instance.setTime(new Date());
		int day = instance.get(Calendar.DAY_OF_MONTH);
		if(day <= dayDate){
			return null;
		}
		String zhubiaosql = (String) PropertiesUtils.getInstance().get("zhubiaosql");
		int a=(dayDate+1);
		if(day == (dayDate+1)){
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
			String format = sdf.format(new Date());
			zhubiaosql="SELECT * FROM "+formman+" WHERE TO_CHAR(APPROVE_DATE,'yyyy-MM-dd') >= '"+format+"-01' AND TO_CHAR(APPROVE_DATE,'yyyy-MM-dd') <= '"+format+"-"+(dayDate+1)+"' AND FINISHEDFLAG ='1'";
		}
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(zhubiaosql);
		if(queryForList.size() > 0 && queryForList != null){
	
		List<Map<String, Object>> addList= new ArrayList<Map<String,Object>>();
		for (Map<String, Object> map : queryForList) {
			String formid = String.valueOf(map.get("ID"));
			String danhao = String.valueOf(map.get("field0002"));
			Map<String,Object> zMap=new HashMap<String,Object>();
			//String invoice_number
			String application_number=(String)map.get("field0002")== null ? "" :(String)map.get("field0002");
			String appl_user_code=(String)map.get("field0003")== null ? "": (String)map.get("field0003");
			String accountid=(String)map.get("field0003")== null ? "": (String)map.get("field0003"); //申请人
			String chuChaiRen=(String)map.get("field0006")== null ? "": (String)map.get("field0006"); //出差人
			String description="";
			if(!StringUtils.isEmpty(chuChaiRen)){
				String[] split = chuChaiRen.split(",");
				for (int i = 0; i < split.length; i++) {
					String desMemberName = Functions.showMemberName(Long.valueOf(split[i]));//人员id
					description += desMemberName+",";
				}
				description=description.substring(0, description.length()-1);
			}
			appl_user_code=getcode(appl_user_code); // 获取申请人code
			String memberName = Functions.showMemberName(Long.valueOf(accountid));//人员id
			String appl_user_name=memberName;
			String com_code =(String)map.get("field0004")==null ? "" :(String)map.get("field0004");// 机构编码
			String salf_pay =map.get("field0027")+"";//==null ? "" :(String)map.get("field0022");// SALF_PAY
			//BigDecimal zheji1 =new BigDecimal();
			String accountCode = getAccountAndDepa(com_code);
			//String Account = Functions.showOrgAccountNameByMemberid(Long.valueOf(accountid));//单位
			String com_desc="";
			
			Map<String, Object> accountDept = getAccountDept(accountCode,"");
			if(accountDept.size() > 0){
			com_code=accountDept.get("accountNumber")+"";
			com_desc=accountDept.get("accountName")+"";
			}
			String dept_code=(String)map.get("field0025")==null ? "" :(String)map.get("field0025"); //受益部门
			
			String dept="";
			if(dept_code!= null && dept_code!=""){
			//dept = Functions.showDepartmentName(Long.valueOf(dept_code));//部门
			 dept = getAccountAndDepa(dept_code);
			}
			String dept_desc="";
			Map<String, Object> aDept = getAccountDept("",dept);
			if(aDept.size() > 0){
			dept_code=aDept.get("deptNumber")+"";
			dept_desc=aDept.get("deptName")+"";
			}
			String shenqingDept=(String)map.get("field0005")==null ? "" :(String)map.get("field0005");
			String sqDeptName="";
			if(shenqingDept != null && shenqingDept != ""){
			sqDeptName = Functions.showDepartmentName(Long.valueOf(shenqingDept));
			sqDeptName = getAccountAndDepa(shenqingDept);
			}
			Map<String, Object> deptMap = getAccountDept("",sqDeptName);
			String cost_center="";
			String cost_center_desc="";
			if(deptMap.size() > 0){
			cost_center=deptMap.get("deptNumber")+"";//编号
			cost_center_desc=deptMap.get("deptName")+"";//民称
			}
			String project_code = (String)map.get("field0024")==null ? "" :(String)map.get("field0024");
			String project_desc = (String)map.get("field0022")==null ? "" :(String)map.get("field0022");
			String[] split2 = chuChaiRen.split(",");
			String isDGJ="";
			if(split2 != null && split2.length > 0){
				String	chuChaiDgj=split2[0];
			
			String orgMemberdgj = "SELECT ORG_ACCOUNT_ID as com,is_DGJ as dgj FROM org_member WHERE ID=" +Long.valueOf(chuChaiDgj);
			// 根据id 取一条数据 人员的董高监
			List<Map<String, Object>> memberlist = jdbcTemplate.queryForList(orgMemberdgj);
			
			if(memberlist.size() >0 && memberlist != null){
				isDGJ = memberlist.get(0).get("dgj") == null ? "" : memberlist.get(0).get("dgj")+"";
				}
			}
			if(StringUtils.isEmpty(isDGJ)){
				isDGJ ="N";
			}else
			if(!StringUtils.isEmpty(isDGJ)){
				isDGJ ="Y";
			}
			String ds_flag=isDGJ;
			
			String shujutongji="SELECT * FROM shujutongji WHERE formid='"+danhao+"'";  //总计
			List<Map<String, Object>> shujutongjiList = jdbcTemplate.queryForList(shujutongji);
			String attachmentNum="";
			if(shujutongjiList != null && shujutongjiList.size() > 0){
				attachmentNum = shujutongjiList.get(0).get("piaonumber")+"";
			}
			
			zMap.put("application_number",application_number);
			zMap.put("appl_user_code",appl_user_code);
			zMap.put("appl_user_name",appl_user_name);
			zMap.put("com_code",com_code);
			zMap.put("com_desc",com_desc);
			zMap.put("dept_code",dept_code );
			zMap.put("dept_desc", dept_desc);
			zMap.put("cost_center",cost_center );
			zMap.put("cost_center_desc",cost_center_desc);
			zMap.put("project_code",project_code);
			zMap.put("project_desc",project_desc);
			zMap.put("ds_flag",ds_flag );
			zMap.put("salf_pay",salf_pay );
			zMap.put("attachmentNum",attachmentNum );
			zMap.put("description",description );
			addList.add(zMap);
			}
		return addList;
	}
		return null;
	}
	
	@Override
	public List<Map<String, Object>> getFenGonSiFeiXcXmlTou() {
		//String zhubiaosql="SELECT * FROM formmain_0108 where field0015=817151701516569968"; //这里sql 
		String fGsformman = (String) PropertiesUtils.getInstance().get("fGsformman"); 
		String getDayDate = (String) PropertiesUtils.getInstance().get("dayDate");
		int dayDate= 5;
		if(!StringUtils.isEmpty(getDayDate)){
			dayDate=Integer.valueOf(getDayDate);
		}
		Calendar instance = Calendar.getInstance();
		instance.setTime(new Date());
		int day = instance.get(Calendar.DAY_OF_MONTH);
		if(day <= dayDate){
			return null;
		}
		String zhubiaosql = (String) PropertiesUtils.getInstance().get("FenGonSizhubiaosql");
		if(day == (dayDate+1)){
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
			String format = sdf.format(new Date());
			zhubiaosql="SELECT * FROM "+fGsformman+" WHERE TO_CHAR(APPROVE_DATE,'yyyy-MM-dd') >= '"+format+"-01' AND TO_CHAR(APPROVE_DATE,'yyyy-MM-dd') <= '"+format+"-"+(dayDate+1)+"' AND FINISHEDFLAG ='1'";
		}
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(zhubiaosql);
		if(queryForList != null && queryForList.size() > 0){
		String formid = String.valueOf(queryForList.get(0).get("ID"));
		String danhao = String.valueOf(queryForList.get(0).get("field0002"));
		List<Map<String, Object>> addList= new ArrayList<Map<String,Object>>();
		for (Map<String, Object> map : queryForList) {
			Map<String,Object> zMap=new HashMap<String,Object>();
			//String invoice_number
			String application_number=(String)map.get("field0002")== null ? "" :(String)map.get("field0002");
			String appl_user_code=(String)map.get("field0003")== null ? "": (String)map.get("field0003");//申请人
			String accountid=(String)map.get("field0003")== null ? "": (String)map.get("field0003"); 
			appl_user_code=getcode(appl_user_code); // 获取申请人code
			String memberName = Functions.showMemberName(Long.valueOf(accountid));//人员id
			String appl_user_name=memberName;
			String com_code =(String)map.get("field0004")==null ? "" :(String)map.get("field0004");// 机构编码
			String salf_pay =map.get("field0027")+"";//==null ? "" :(String)map.get("field0022");// SALF_PAY
			String chuChaiRen=(String)map.get("field0006")== null ? "": (String)map.get("field0006"); //出差人
			String description="";
			if(!StringUtils.isEmpty(chuChaiRen)){
				String[] split = chuChaiRen.split(",");
				for (int i = 0; i < split.length; i++) {
					String desMemberName = Functions.showMemberName(Long.valueOf(split[i]));//人员id
					description += desMemberName+",";
				}
				description=description.substring(0, description.length()-1);
			}
			
			String accountCode = getAccountAndDepa(com_code);
			
			
			//String Account = Functions.showOrgAccountNameByMemberid(Long.valueOf(accountid));//单位
			String com_desc="";
			
			Map<String, Object> accountDept = getAccountDept(accountCode,"");
			if(accountDept != null && accountDept.size() > 0){
				com_code=accountDept.get("accountNumber")+"";
				com_desc=accountDept.get("accountName")+"";
				}
			
			String dept_code=(String)map.get("field0025")==null ? "" :(String)map.get("field0025"); //受益部门
			
			String dept="";
			if(dept_code!= null && dept_code!=""){
			//dept = Functions.showDepartmentName(Long.valueOf(dept_code));//部门
			 dept = getAccountAndDepa(dept_code);
			}
			String dept_desc="";
			Map<String, Object> aDept = getAccountDept("",dept);
			if(aDept != null && aDept.size() > 0){
				dept_code=aDept.get("deptNumber")+"";
				dept_desc=aDept.get("deptName")+"";
			}
			
			String shenqingDept=(String)map.get("field0005")==null ? "" :(String)map.get("field0005");
			String sqDeptName="";
			if(shenqingDept != null && shenqingDept != ""){
			//sqDeptName = Functions.showDepartmentName(Long.valueOf(shenqingDept));
				sqDeptName = getAccountAndDepa(shenqingDept);
			}
			Map<String, Object> deptMap = getAccountDept("",sqDeptName);
			String cost_center="";
			String cost_center_desc="";
			if(deptMap != null && deptMap.size() > 0){
			cost_center=deptMap.get("deptNumber")+"";//编号
			cost_center_desc=deptMap.get("deptName")+"";//民称
			}
			String project_code = (String)map.get("field0024")==null ? "" :(String)map.get("field0024");
			String project_desc = (String)map.get("field0022")==null ? "" :(String)map.get("field0022");
			String[] split2 = chuChaiRen.split(",");
			String isDGJ="";
			if(split2 != null && split2.length > 0){
				String	chuChaiDgj=split2[0];
			
			String orgMemberdgj = "SELECT ORG_ACCOUNT_ID as com,is_DGJ as dgj FROM org_member WHERE ID=" +Long.valueOf(chuChaiDgj);
			// 根据id 取一条数据 人员的董高监
			List<Map<String, Object>> memberlist = jdbcTemplate.queryForList(orgMemberdgj);
			
			
			if(memberlist != null && memberlist.size() >0){
				isDGJ = memberlist.get(0).get("dgj") == null ? "" : memberlist.get(0).get("dgj")+"";
				}
			}
			if(StringUtils.isEmpty(isDGJ)){
				isDGJ ="N";
			}else
			if(!StringUtils.isEmpty(isDGJ)){
				isDGJ ="Y";
			}
			
			String ds_flag=isDGJ;
			
			String shujutongji="SELECT * FROM feixiechengshujutongji WHERE FORMID='"+danhao+"'";  //总计
			List<Map<String, Object>> shujutongjiList = jdbcTemplate.queryForList(shujutongji);
			String attachmentNum="";
			if(shujutongjiList != null && shujutongjiList.size() > 0){
				 attachmentNum = shujutongjiList.get(0).get("piaonumber")+"";
			}
			zMap.put("application_number",application_number);
			zMap.put("appl_user_code",appl_user_code);
			zMap.put("appl_user_name",appl_user_name);
			zMap.put("com_code",com_code);
			zMap.put("com_desc",com_desc);
			zMap.put("dept_code",dept_code );
			zMap.put("dept_desc", dept_desc);
			zMap.put("cost_center",cost_center );
			zMap.put("cost_center_desc",cost_center_desc);
			zMap.put("project_code",project_code);
			zMap.put("project_desc",project_desc);
			zMap.put("ds_flag",ds_flag );
			zMap.put("salf_pay",salf_pay );
			zMap.put("attachmentNum",attachmentNum );
			zMap.put("description",description );
			addList.add(zMap);
			}
		return addList;
		}return null;
	}
	
	public static String getAccountAndDepa(String AccountAndDepa){
		String sql="SELECT ID,NAME,CODE FROM ORG_UNIT WHERE ID = '"+AccountAndDepa+"'";
		List<Map<String, Object>> listAccountAndDepa = jdbcTemplate.queryForList(sql);
		if(listAccountAndDepa != null && listAccountAndDepa.size() > 0){
			String code=listAccountAndDepa.get(0).get("CODE")+"";
			return code;
		}
		return "";
	}
	public String getShiNeiJiaoTong(String daohao){
		String carandship="SELECT * FROM traffic WHERE danhao='"+daohao+"'"; //车船机票费
		List<Map<String, Object>> trafficList = jdbcTemplate.queryForList(carandship);
		String shiNeiJiaoTongXML="";
		for (Map<String, Object> map : trafficList) {
			String baoxiaofangshi= map.get("baoxiaofangshi")+"";
			String shifoupaiche= map.get("shifoupaiche")+"";
			String jine= map.get("jine")+"";
			if("null".equals(jine)){
				jine ="";
			}
			String beizhu= map.get("beizhu")+"";
			if("SBSX".equals(baoxiaofangshi)){
				shiNeiJiaoTongXML +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>SNJT-SBSX</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>市内交通费-实报实销</ns1:TYPE_>\n" +      				 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+jine+"</ns1:EXPENSE_AMOUNT>\n" + 			//费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" + 			//是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beizhu+"</ns1:DESCRIPTION>\n" +             			 //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
		   if("BG".equals(baoxiaofangshi)){
			   shiNeiJiaoTongXML +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>SNJT-BG</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>市内交通费-包干</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+jine+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR>"+shifoupaiche+"</ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beizhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
		}
		return shiNeiJiaoTongXML;
	}
	@Override
	public String getCheChuan(String biaodanhao) {
		String carandship="SELECT * FROM carandship WHERE formrecid='"+biaodanhao+"'"; //车船机票费
		List<Map<String, Object>> carandshipList = jdbcTemplate.queryForList(carandship);
		
		String zhubiaosql="SELECT * FROM formmain_3604 f LEFT JOIN formson_3605 c ON  f.ID=c.formmain_id WHERE f.field0002 ="+biaodanhao; //这里sql 需要移动到配置文件中
		//List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(zhubiaosql);
		String formman = (String) PropertiesUtils.getInstance().get("formman");  			 //主表
		String formshiji = (String) PropertiesUtils.getInstance().get("formsonShijiXinxi");  //实际信息表 
		String diQuTypesql="SELECT * FROM "+formman+" f LEFT JOIN "+formshiji+" c ON  f.ID=c.formmain_id WHERE f.field0002 ='"+biaodanhao+"'"; //查询出差地区类型和时间 这里sql 需要移动到配置文件中
		List<Map<String, Object>> diQuList = jdbcTemplate.queryForList(diQuTypesql);
		String cheChuan="";
		String businesstTrip=""; // 一般地区
		Double allowNum=0.0;
		
		String xinZangType=""; //新疆西藏地区
		Double xinJianXiZang=0.0; 
		if(diQuList.size() >0 && diQuList != null){
		for (Map<String, Object> map2 : diQuList) {
			String string = map2.get("field0055")+"";
			if("null".equals(string)){
				string="0";
			}
			BigDecimal bigD= new BigDecimal(string);
			String yiBang=bigD.toString(); //一般地区
			if(!StringUtils.isEmpty(yiBang)){
			Double yiBangDiQu=Double.valueOf(yiBang);
			allowNum=allowNum+yiBangDiQu;
			businesstTrip="General";
			}
			String string2 = map2.get("field0059")+"";
			if("null".equals(string2)){
				string2="0";
			}
			BigDecimal bigD1= new BigDecimal(string2);
			String xinXiDiQu=bigD1.toString(); //新疆西藏地区
			if(!StringUtils.isEmpty(xinXiDiQu)){
			Double xinXi=Double.valueOf(xinXiDiQu);
				xinJianXiZang=xinJianXiZang+xinXi;
				xinZangType="Special";
			}
		}
		}
			if(!StringUtils.isEmpty(businesstTrip)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>HSBT</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>伙食补贴</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT></ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE>"+businesstTrip+"</ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM>"+allowNum+"</ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
			
			if(!StringUtils.isEmpty(xinZangType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>HSBT</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>伙食补贴</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT></ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE>"+xinZangType+"</ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM>"+xinJianXiZang+"</ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
		
		
		if(carandshipList != null && carandshipList.size() > 0){
		for (Map<String, Object> map : carandshipList) {
			String JTType=(String)map.get("JTType");
			
			BigDecimal cjFeebig=(BigDecimal)map.get("cjFee");
			String cjFee=cjFeebig.toString();
			String type=(String)map.get("FeeType"); //其他差旅费类型
			
			BigDecimal QTfeebig=(BigDecimal)map.get("QTfee"); //其他差旅费
			String QTfee =QTfeebig.toString();
			String beiZhu=(String)map.get("beizhu");
			
			if("火车".equals(JTType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>CCJP-HC</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>车船机票费-火车票</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+cjFee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}if("飞机".equals(JTType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>CCJP-FJ</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>车船机票费-机票</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+cjFee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}if("其它".equals(JTType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>CCJP-OTH</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>车船机票费-其他交通工具</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+cjFee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			
			
			if("T".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-TP</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-退票费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			if("D".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-DP</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-订票费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}		
			if("G".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-GQ</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-改签费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			if("QT".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-QT</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-其他费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			
						}
					}
		return cheChuan;
	}

	@Override
	public String getZhusu(String biaodanhao) {
		String zhusu="SELECT * FROM zhusu WHERE formid='"+biaodanhao+"'";              //住宿
		List<Map<String, Object>> zhuSuList = jdbcTemplate.queryForList(zhusu);
		if(zhuSuList != null && zhuSuList.size() > 0){
		String zhuSuXml="";
		for (Map<String, Object> map : zhuSuList) {
			String zhuanpiao= map.get("zhuanpiao")+""; //是否专票
			String fapiaohao=map.get("fapiaohao")+"";
			String jssum=map.get("jssum")+""; //价税合计
			String shuie=map.get("shuie")+"";
			String shuil=map.get("shuil")+"";
			String jine=map.get("jine")+"";
			if("Y".equals(zhuanpiao)){
				zhuSuXml +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>ZS</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>住宿费</ns1:TYPE_>\n" +      				   					  //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+jine+"</ns1:EXPENSE_AMOUNT>\n" +   		 		  //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +      			  //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM>"+fapiaohao+"</ns1:HOTEL_INVOICE_NUM>\n" + 		  //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG>"+zhuanpiao+"</ns1:SPECIAL_INVOICE_FLAG>\n" +  //是否专票
		                "                    <ns1:TAX_AMOUNT>"+shuie+"</ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE>"+shuil+"</ns1:TAX_RATE>\n" + 						      //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					  		      //补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +                     			  //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
			if("N".equals(zhuanpiao)){
				zhuSuXml +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>ZS</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>住宿费</ns1:TYPE_>\n" +      				   						 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+jssum+"</ns1:EXPENSE_AMOUNT>\n" +   		 			//费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +      			    //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		  			    //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG>"+zhuanpiao+"</ns1:SPECIAL_INVOICE_FLAG>\n" +    //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          			//税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						      			//税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					  		      	//补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +                     			 	//备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
			
			
		}
		return zhuSuXml;
	}
		return null;		
	}

	@Override
	public int addFenGonSiCarAndship(CarAndShip carAndShip) {
		try {
			String sql="INSERT INTO feixiechengcarandship VALUES('"+carAndShip.getId()+"','"+carAndShip.getXHnumber()+"','"+carAndShip.getJTType()+"',"+carAndShip.getCjFee()+","+carAndShip.getQTfee()+",'"+carAndShip.getFeeType()+"','"+carAndShip.getBeizhu()+"',"+carAndShip.getCczong()+","+carAndShip.getQtzong()+",'"+carAndShip.getFormrecid()+"')";
			int FenGonSiCarAndshipint = jdbcTemplate.update(sql);
			return FenGonSiCarAndshipint;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int addFenGonSiZhusu(JiuDianFaPiao jiuDianFaPiao) {
		try {
			String sql ="INSERT INTO feixiechengzhusu VALUES('"+jiuDianFaPiao.getId()+"','"+jiuDianFaPiao.getXuhao()+"','"+jiuDianFaPiao.getZhuanpiao()+"',"+jiuDianFaPiao.getJsheji()+","+jiuDianFaPiao.getJine()+","+jiuDianFaPiao.getShuie()+",'"+jiuDianFaPiao.getShuil()+"','"+jiuDianFaPiao.getFapiaohao()+"',"+jiuDianFaPiao.getHeji()+",'"+jiuDianFaPiao.getFormid()+"')";
			int FenGonSiZhusuint = jdbcTemplate.update(sql);
			return FenGonSiZhusuint;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int addFenGonSiTongji(String pjnumber, BigDecimal zheji, String formid) {
		try {
			String sql ="INSERT INTO feixiechengshujutongji VALUES('"+String.valueOf(UUIDLong.longUUID())+"','"+pjnumber+"',"+zheji+",'"+formid+"')";
			int FenGonSiTongji = jdbcTemplate.update(sql);
			return FenGonSiTongji;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}
	
	public String getFenGonSiCheChuan(String biaodanhao) {
		String carandship="SELECT * FROM feixiechengcarandship WHERE formrecid='"+biaodanhao+"'"; //车船机票费
		List<Map<String, Object>> carandshipList = jdbcTemplate.queryForList(carandship);
		String fGsformman = (String) PropertiesUtils.getInstance().get("fGsformman");  			 //主表
		String fGsFormson = (String) PropertiesUtils.getInstance().get("fGsFormson");  			 //主表

		String zhubiaosql="SELECT * FROM formmain_0108 f LEFT JOIN formson_0109 c ON  f.ID=c.formmain_id WHERE f.field0002 ="+biaodanhao; //这里sql 需要移动到配置文件中
		//List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(zhubiaosql);
		
		String diQuTypesql="SELECT * FROM 	"+fGsformman+" f LEFT JOIN "+fGsFormson+" c ON  f.ID=c.formmain_id WHERE f.field0002 ='"+biaodanhao+"'"; //查询出差地区类型和时间 这里sql 需要移动到配置文件中
		List<Map<String, Object>> diQuList = jdbcTemplate.queryForList(diQuTypesql);
		String cheChuan="";
		String businesstTrip=""; // 一般地区
		Double allowNum=0.0;
		
		String xinZangType=""; //新疆西藏地区
		Double xinJianXiZang=0.0; 
		if(diQuList.size() >0 && diQuList != null){
		for (Map<String, Object> map2 : diQuList) {
			String string = map2.get("field0055")+"";
			if("null".equals(string)){
				string="0";
			}
			BigDecimal bigD= new BigDecimal(string);
			String yiBang=bigD.toString(); //一般地区
			if(!StringUtils.isEmpty(yiBang)){
			Double yiBangDiQu=Double.valueOf(yiBang);
			allowNum=allowNum+yiBangDiQu;
			businesstTrip="General";
			}
			String string2 = map2.get("field0059")+"";
			if("null".equals(string2)){
				string2="0";
			}
			BigDecimal bigD1= new BigDecimal(string2);
			String xinXiDiQu=bigD1.toString(); //新疆西藏地区
			if(!StringUtils.isEmpty(xinXiDiQu)){
			Double xinXi=Double.valueOf(xinXiDiQu);
				xinJianXiZang=xinJianXiZang+xinXi;
				xinZangType="Special";
			}
		}
		}
			if(!StringUtils.isEmpty(businesstTrip)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>HSBT</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>伙食补贴</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT></ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE>"+businesstTrip+"</ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM>"+allowNum+"</ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
			
			if(!StringUtils.isEmpty(xinZangType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>HSBT</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>伙食补贴</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT></ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE>"+xinZangType+"</ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM>"+xinJianXiZang+"</ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
		
		
		if(carandshipList != null && carandshipList.size() > 0){
		for (Map<String, Object> map : carandshipList) {
			String JTType=(String)map.get("JTType");
			
			BigDecimal cjFeebig=(BigDecimal)map.get("cjFee");
			String cjFee=cjFeebig.toString();
			String type=(String)map.get("FeeType"); //其他差旅费类型
			
			BigDecimal QTfeebig=(BigDecimal)map.get("QTfee"); //其他差旅费
			String QTfee =QTfeebig.toString();
			String beiZhu=(String)map.get("beizhu");
			
			if("火车".equals(JTType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>CCJP-HC</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>车船机票费-火车票</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+cjFee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}if("飞机".equals(JTType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>CCJP-FJ</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>车船机票费-机票</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+cjFee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}if("其它".equals(JTType)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>CCJP-OTH</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>车船机票费-其他交通工具</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+cjFee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			
			
			if("T".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-TP</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-退票费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			if("D".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-DP</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-订票费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}		
			if("G".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-GQ</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-改签费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			if("QT".equals(type)){
				cheChuan +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>OTHER-QT</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>其他差旅费-其他费</ns1:TYPE_>\n" +      				   		 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+QTfee+"</ns1:EXPENSE_AMOUNT>\n" + //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +          //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		     //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG></ns1:SPECIAL_INVOICE_FLAG>\n" +      //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						     //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					     //补助天数
		                "                    <ns1:DESCRIPTION>"+beiZhu+"</ns1:DESCRIPTION>\n" +              //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
							}
			
						}
				}
		return cheChuan;
	}
	@Override
	public String getFenGongSiZhusuXml(String biaodanhao) {
		String zhusu="SELECT * FROM feixiechengzhusu WHERE formid='"+biaodanhao+"'";              //住宿
		List<Map<String, Object>> zhuSuList = jdbcTemplate.queryForList(zhusu);
		if(zhuSuList != null && zhuSuList.size() >0){
		String zhuSuXml="";
		for (Map<String, Object> map : zhuSuList) {
			String zhuanpiao= map.get("zhuanpiao")+""; //是否专票
			String fapiaohao=map.get("fapiaohao")+"";
			String jssum=map.get("jssum")+""; //价税合计
			String shuie=map.get("shuie")+"";
			String shuil=map.get("shuil")+"";
			String jine=map.get("jine")+"";
			if("Y".equals(zhuanpiao)){
				zhuSuXml +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>ZS</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>住宿费</ns1:TYPE_>\n" +      				   					  //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+jine+"</ns1:EXPENSE_AMOUNT>\n" +   		 		  //费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +      			  //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM>"+fapiaohao+"</ns1:HOTEL_INVOICE_NUM>\n" + 		  //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG>"+zhuanpiao+"</ns1:SPECIAL_INVOICE_FLAG>\n" +  //是否专票
		                "                    <ns1:TAX_AMOUNT>"+shuie+"</ns1:TAX_AMOUNT>\n" +                          //税额
		                "                    <ns1:TAX_RATE>"+shuil+"</ns1:TAX_RATE>\n" + 						      //税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					  		      //补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +                     			  //备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
			if("N".equals(zhuanpiao)){
				zhuSuXml +="<ns1:P_TBL_EXPENSE_LINES_ITEM>\n" +
		                "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		                "                    <ns1:TYPE_CODE>ZS</ns1:TYPE_CODE>\n" +
		                "                    <ns1:TYPE_>住宿费</ns1:TYPE_>\n" +      				   						 //费用类型
		                "                    <ns1:EXPENSE_AMOUNT>"+jssum+"</ns1:EXPENSE_AMOUNT>\n" +   		 			//费用金额
		                "                    <ns1:WHETHER_TO_USE_CAR></ns1:WHETHER_TO_USE_CAR>\n" +      			    //是否派车
		                "                    <ns1:HOTEL_INVOICE_NUM></ns1:HOTEL_INVOICE_NUM>\n" + 		  			    //住宿发票号
		                "                    <ns1:SPECIAL_INVOICE_FLAG>"+zhuanpiao+"</ns1:SPECIAL_INVOICE_FLAG>\n" +    //是否专票
		                "                    <ns1:TAX_AMOUNT></ns1:TAX_AMOUNT>\n" +                          			//税额
		                "                    <ns1:TAX_RATE></ns1:TAX_RATE>\n" + 						      			//税率
		                "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" +
		                "                    <ns1:ALLOW_NUM></ns1:ALLOW_NUM>\n" +     					  		      	//补助天数
		                "                    <ns1:DESCRIPTION></ns1:DESCRIPTION>\n" +                     			 	//备注
		                "                    <ns1:ATTRIBUTE1></ns1:ATTRIBUTE1>\n" +
		                "                    <ns1:ATTRIBUTE2></ns1:ATTRIBUTE2>\n" +
		                "                    <ns1:ATTRIBUTE3></ns1:ATTRIBUTE3>\n" +
		                "                    <ns1:ATTRIBUTE4></ns1:ATTRIBUTE4>\n" +
		                "                    <ns1:ATTRIBUTE5></ns1:ATTRIBUTE5>\n" +
		                "                    <ns1:ATTRIBUTE6></ns1:ATTRIBUTE6>\n" +
		                "                    <ns1:ATTRIBUTE7></ns1:ATTRIBUTE7>\n" +
		                "                    <ns1:ATTRIBUTE8></ns1:ATTRIBUTE8>\n" +
		                "                    <ns1:ATTRIBUTE9></ns1:ATTRIBUTE9>\n" +
		                "                    <ns1:ATTRIBUTE10></ns1:ATTRIBUTE10>\n" +
		                "                    <ns1:ATTRIBUTE11></ns1:ATTRIBUTE11>\n" +
		                "                    <ns1:ATTRIBUTE12></ns1:ATTRIBUTE12>\n" +
		                "                    <ns1:ATTRIBUTE13></ns1:ATTRIBUTE13>\n" +
		                "                    <ns1:ATTRIBUTE14></ns1:ATTRIBUTE14>\n" +
		                "                    <ns1:ATTRIBUTE15></ns1:ATTRIBUTE15>\n" +
		                "                    <ns1:ATTRIBUTE16></ns1:ATTRIBUTE16>\n" +
		                "                    <ns1:ATTRIBUTE17></ns1:ATTRIBUTE17>\n" +
		                "                    <ns1:ATTRIBUTE18></ns1:ATTRIBUTE18>\n" +
		                "                    <ns1:ATTRIBUTE19></ns1:ATTRIBUTE19>\n" +
		                "                    <ns1:ATTRIBUTE20></ns1:ATTRIBUTE20>\n" +
		                "                </ns1:P_TBL_EXPENSE_LINES_ITEM>";
			}
			
			
		}
		return zhuSuXml;
		
	}
	return null;
}

	@Override
	public void updateCarAndShip(CarAndShip carAndShip) {
		try {
			String updateSql="update carandship SET JTType ='"+carAndShip.getJTType()+"',cjFee="+carAndShip.getCjFee()+",QTfee="+carAndShip.getQTfee()+",FeeType='"+carAndShip.getFeeType()+"',beizhu='"+carAndShip.getBeizhu()+"',cczong= "+carAndShip.getCczong()+" , qtzong= "+carAndShip.getQtzong()+" WHERE id='"+carAndShip.getId()+"' and formrecid='"+carAndShip.getFormrecid()+"'";
			jdbcTemplate.update(updateSql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Override
	public void updateFgsCarAndShip(CarAndShip carAndShip) {
		try {
			String updateSql="update feixiechengcarandship SET JTType ='"+carAndShip.getJTType()+"',cjFee="+carAndShip.getCjFee()+",QTfee="+carAndShip.getQTfee()+",FeeType='"+carAndShip.getFeeType()+"',beizhu='"+carAndShip.getBeizhu()+"',cczong= "+carAndShip.getCczong()+" , qtzong= "+carAndShip.getQtzong()+" WHERE id='"+carAndShip.getId()+"' and formrecid='"+carAndShip.getFormrecid()+"'";
			jdbcTemplate.update(updateSql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void updateZhuSu(JiuDianFaPiao jiuDianFaPiao) {
		try {
			String updateZhusuSql ="UPDATE zhusu SET zhuanpiao ='"+jiuDianFaPiao.getZhuanpiao()+"' ,jssum ="+jiuDianFaPiao.getJsheji()+" ,jine="+jiuDianFaPiao.getJine()+" , shuie="+jiuDianFaPiao.getShuie()+" , shuil='"+jiuDianFaPiao.getShuil()+"' , fapiaohao ='"+jiuDianFaPiao.getFapiaohao()+"',jszonghe= "+jiuDianFaPiao.getHeji()+" WHERE id ='"+jiuDianFaPiao.getId()+"' and formid='"+jiuDianFaPiao.getFormid()+"'";
			jdbcTemplate.update(updateZhusuSql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Override
	public void updateFgsZhuSu(JiuDianFaPiao jiuDianFaPiao) {
		try {
			String updateZhusuSql ="UPDATE feixiechengzhusu SET zhuanpiao ='"+jiuDianFaPiao.getZhuanpiao()+"' ,jssum ="+jiuDianFaPiao.getJsheji()+" ,jine="+jiuDianFaPiao.getJine()+" , shuie="+jiuDianFaPiao.getShuie()+" , shuil='"+jiuDianFaPiao.getShuil()+"' , fapiaohao ='"+jiuDianFaPiao.getFapiaohao()+"',jszonghe= "+jiuDianFaPiao.getHeji()+" WHERE id ='"+jiuDianFaPiao.getId()+"' and formid='"+jiuDianFaPiao.getFormid()+"'";
			jdbcTemplate.update(updateZhusuSql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void updateTongJi(String id,String pjnumber, BigDecimal zheji, String formid) {
		try {
			String updateTongJi="UPDATE shujutongji SET piaonumber = '"+pjnumber+"',jineheji = "+zheji+" WHERE id = '"+id+"' and formid ='"+formid+"'";
			jdbcTemplate.update(updateTongJi);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Override
	public void updateFgsTongJi(String id,String pjnumber, BigDecimal zheji, String formid) {
		try {
			String updateTongJi="UPDATE feixiechengshujutongji SET piaonumber = '"+pjnumber+"',jineheji = "+zheji+" WHERE id = '"+id+"' and formid ='"+formid+"'";
			jdbcTemplate.update(updateTongJi);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public List<Map<String, Object>> queryShiNeiJiaoTong(String danhaoid) {
		String carandship="SELECT * FROM traffic WHERE danhao='"+danhaoid+"'"; //
		List<Map<String, Object>> trafficList = jdbcTemplate.queryForList(carandship);
		return trafficList;
	}

	@Override
	public void updateNeiJiaoTong(TrafficFeiXieCheng traffic) {
		try {
			String updateSql="UPDATE traffic SET baoxiaofangshi = '"+traffic.getBaoxiaofangshi()+"' ,shifoupaiche='"+traffic.getShifoupaiche()+"',jine='"+traffic.getJine()+"',beizhu='"+traffic.getBeizhu()+"',zheji="+traffic.getZheji()+" WHERE id='"+traffic.getId()+"' AND danhao='"+traffic.getDanhao()+"'";
			jdbcTemplate.update(updateSql);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public List<Map<String, Object>> getFenGongSiZhusuDh(String biaodanhao) {
		String zhusu="SELECT * FROM feixiechengzhusu WHERE formid='"+biaodanhao+"'";              //住宿
		List<Map<String, Object>> zhuSuList = jdbcTemplate.queryForList(zhusu);
		return zhuSuList;
	}

	@Override
	public List<Map<String, Object>> getFenGonSiCheChuanDh(String biaodanhao) {
		String carandship="SELECT * FROM feixiechengcarandship WHERE formrecid='"+biaodanhao+"'"; //车船机票费
		List<Map<String, Object>> carandshipList = jdbcTemplate.queryForList(carandship);
		return carandshipList;
	}
	public List<Map<String, Object>> getFenGonSiShuHuHj(String biaodanhao) {
		String shujutongji="SELECT * FROM feixiechengshujutongji WHERE formid='"+biaodanhao+"'";  //总计
		List<Map<String, Object>> shujutongjiList = jdbcTemplate.queryForList(shujutongji);
		return shujutongjiList;
	}

	@Override
	public List<Map<String, Object>> getShouYiBuMen() {
		String sql ="select * from formmain_3601";
		List<Map<String, Object>> shouYiBuMen = jdbcTemplate.queryForList(sql);
		return shouYiBuMen;
	}

	@Override
	public int deleteZBcarAndship(String id) {
		String sql="DELETE FROM carandship WHERE id='"+id+"'";
		int update = jdbcTemplate.update(sql);
		return update;
	}

	@Override
	public int deleteZBzhusu(String id) {
		String sql="DELETE FROM zhusu WHERE id='"+id+"'";
		int update = jdbcTemplate.update(sql);
		return update;
	}

	@Override
	public int deleteFgsCarAndship(String id) {
		String sql="DELETE FROM feixiechengcarandship WHERE id='"+id+"'";
		int update = jdbcTemplate.update(sql);
		return update;
	}

	@Override
	public int deleteFgsZhusu(String id) {
		String sql="DELETE FROM feixiechengzhusu WHERE id='"+id+"'";
		int update = jdbcTemplate.update(sql);
		return update;
	}

	@Override
	public int deleteFgsTraffic(String id) {
		String sql="DELETE FROM traffic WHERE id='"+id+"'";
		int update = jdbcTemplate.update(sql);
		return update;
	}
}
