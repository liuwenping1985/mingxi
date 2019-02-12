package com.seeyon.apps.kdXdtzXc.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.base.util.MapWapperExt;
import com.seeyon.apps.kdXdtzXc.manager.CityService;
import com.seeyon.apps.kdXdtzXc.manager.GeRenZhiFuXinXi;
import com.seeyon.apps.kdXdtzXc.po.City;
import com.seeyon.apps.kdXdtzXc.po.CityEntity;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.WriteUtil;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

import edu.emory.mathcs.backport.java.util.TreeMap;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * @author Aaron 这个类主要是表单自定义控件
 *
 */
public class DinPiaoRenZiXinDinPiaoController extends BaseController {
	private static Log log = LogFactory.getLog(DinPiaoRenZiXinDinPiaoController.class);
	private static JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	private GeRenZhiFuXinXi geRenZhiFuXinXi;
	private CityService cityService;

	public GeRenZhiFuXinXi getGeRenZhiFuXinXi() {
		return geRenZhiFuXinXi;
	}

	public void setGeRenZhiFuXinXi(GeRenZhiFuXinXi geRenZhiFuXinXi) {
		this.geRenZhiFuXinXi = geRenZhiFuXinXi;
	}
	

	public CityService getCityService() {
		return cityService;
	}

	public void setCityService(CityService cityService) {
		this.cityService = cityService;
	}

	// 控件调用的方法返回前台获取行id
	@NeedlessCheckLogin
	public ModelAndView dinPiaoRen(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/dinPiaoren");
		return mav;
	}
	// 分公司
	@NeedlessCheckLogin
	public ModelAndView FgsdinPiaoRen(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/FgsdinPiaoRen");
		return mav;
	}

	// 通过页面拿到这条数据的行id到表中找到地址返回前台 详细信息
	public void getOrgMember(HttpServletRequest request, HttpServletResponse response) {
		String fromQueren = (String) PropertiesUtils.getInstance().get("formmanQuerenXinxi");
		String formmainid = request.getParameter("formmain_id") == null ? "" : request.getParameter("formmain_id");
		try {
			// 携程信息确认表(formson_0093):主表 id(formmain_id) ,详细信息列(field0033) ：
			String getSql = "select formmain_id, field0047 FROM " + fromQueren + "  where ID =" + formmainid;
			List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(getSql);
			String idname = "''";
			if (queryForList != null && queryForList.size() > 0) {
				idname = queryForList.get(0).get("field0047") + "";
			}
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", idname).add("success", true).add("message", "保存成功！").toMap());
			System.out.println("反馈内容=" + json);
			WriteUtil.write(json, response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	// 通过页面拿到这条数据的行id到表中找到地址返回前台 详细信息
		public void getFgsOrgMember(HttpServletRequest request, HttpServletResponse response) {
			String fromQueren = (String) PropertiesUtils.getInstance().get("fGsFormson");
			String formmainid = request.getParameter("formmain_id") == null ? "" : request.getParameter("formmain_id");
			try {
				// 携程信息确认表(formson_0093):主表 id(formmain_id) ,详细信息列(field0033) ：
				String getSql = "select formmain_id, field0047 FROM " + fromQueren + "  where ID =" + formmainid;
				List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(getSql);
				String idname = "''";
				if (queryForList != null && queryForList.size() > 0) {
					idname = queryForList.get(0).get("field0047") + "";
				}
				String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", idname).add("success", true).add("message", "保存成功！").toMap());
				System.out.println("反馈内容=" + json);
				WriteUtil.write(json, response);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	@NeedlessCheckLogin
	/**
	 * 选择城市
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getCityNameList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/cityNameSelect");
		return mav;
	}
	@NeedlessCheckLogin
	/**
	 * 机票选择城市
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getCityNameJPList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/cityNameSelectJP");
		return mav;
	}
	@NeedlessCheckLogin
	public void getCityNameAll(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sql = "select * from city_kd where 1=1";
		List<Map<String, Object>> cityList = jdbcTemplate.queryForList(sql);
		this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "cityList", cityList), response);
	}

	@NeedlessCheckLogin
	/**
	 * 合规校验 城市选择
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getCityNameListHeGui(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sql = "select id,cityname,cityjiancheng from city_kd where 1=1";
		List<Map<String, Object>> cityList = jdbcTemplate.queryForList(sql);
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/cityNameSelectHeGui");
		mav.addObject("cityList", cityList);
		return mav;
	}

	@NeedlessCheckLogin
	public ModelAndView getListXiecheng(HttpServletRequest request, HttpServletResponse response) {
		String sql = "SELECT * FROM formmain_0108";
		List<Map<String, Object>> yuanDanHao = jdbcTemplate.queryForList(sql);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> map : yuanDanHao) {
			String biaodan = (String) map.get("field0002") == null ? "" : (String) map.get("field0002");
			String memberid = (String) map.get("field0003") == null ? "" : (String) map.get("field0003");
			String memberName = Functions.showMemberName(Long.valueOf(memberid));// 人员id
			map.put("field0002", biaodan);
			map.put("field0003", memberName);
			list.add(map);
		}
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/getListXiecheng");
		mav.addObject("getListXiecheng", list);
		return mav;
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

	@NeedlessCheckLogin
	/**
	 * 获取机构部门等信息
	 * 
	 * @param request
	 * @param response
	 */
	public void getJiGou(HttpServletRequest request, HttpServletResponse response) {
		try {
			String accountForm = (String) PropertiesUtils.getInstance().get("accountForm");
	    	String deptForm = (String) PropertiesUtils.getInstance().get("deptForm");
	    	
			String danhao = request.getParameter("danhao");
			String type = request.getParameter("type");
			log.info("***getJiGou**" + danhao);
			String formman = (String) PropertiesUtils.getInstance().get("formman");
			String sql = "SELECT * FROM "+formman+" where field0002='" + danhao+"'";
			List<Map<String, Object>> yuanDanHao = jdbcTemplate.queryForList(sql);
			Map<String, Object> mapall = new HashMap<String, Object>();
			if(yuanDanHao != null && yuanDanHao.size() > 0){
			for (Map<String, Object> map : yuanDanHao) {
				String biaodan = (String) map.get("field0002") == null ? "" : (String) map.get("field0002");
				String shenQingRen = (String) map.get("field0003") == null ? "" : (String) map.get("field0003");// 申请人
				String shenQingRenDept = (String) map.get("field0005") == null ? "" : (String) map.get("field0005");// 申请人所在部门
				String dinPiaoRen = (String) map.get("field0021") == null ? "" : (String) map.get("field0021");// 订票人
				String projectName = (String) map.get("field0022") == null ? "" : (String) map.get("field0022");// 项目名称
				String projectNumber = (String) map.get("field0024") == null ? "" : (String) map.get("field0024");// 项目编号
				String shouYiBuMen = (String) map.get("field0025") == null ? "" : (String) map.get("field0025");// 受益部门
				// String bumen=(String)map.get("field0005")== null ?""
				// :(String)map.get("field0005");//申请人部门
				String accountNumber = "";
				String accountName = "";
				String[] dinpiaomemberAry = dinPiaoRen.split(",");
				if (dinpiaomemberAry.length > 0 && dinpiaomemberAry != null) {
					for (int i = 0; i < dinpiaomemberAry.length; i++) {
						//String Account = Functions.showOrgAccountNameByMemberid(Long.valueOf(dinpiaomemberAry[i]));// 单位
						//log.info("******------" + Account);
						
						String accountID="";
						String CODEsql = "SELECT * FROM org_member WHERE ID=" + String.valueOf(dinpiaomemberAry[i]); // 查询申请人code
						List<Map<String, Object>> orgName1 = jdbcTemplate.queryForList(CODEsql);
						if(orgName1 != null && orgName1.size() > 0){
							accountID = orgName1.get(0).get("ORG_ACCOUNT_ID")+""; 
						}
						String accountIDDpr = getAccountAndDepa(accountID);
						String orgsql = "select * from "+accountForm+" WHERE field0003 ='" + accountIDDpr + "'";
						List<Map<String, Object>> accountid = jdbcTemplate.queryForList(orgsql);
						if(accountid != null && accountid.size() >0){
							accountNumber = accountid.get(0).get("field0001") + "";// 财务机构编码
							accountName = accountid.get(0).get("field0002") + "";// 财务机构名称	
							}
						}
					}
				//String dept = "";
				String deptNumber = "";
				String deptName = "";
				if (!StringUtils.isEmpty(shouYiBuMen)) {
					//dept = Functions.showDepartmentName(Long.valueOf(shouYiBuMen));// 部门
					String shouYiBuMenCode = getAccountAndDepa(shouYiBuMen);
					String bumensql = "SELECT * FROM "+deptForm+" WHERE field0003='" + shouYiBuMenCode + "'"; // 受益部门
					List<Map<String, Object>> deapid = jdbcTemplate.queryForList(bumensql);
					if(deapid != null && deapid.size() > 0){
						deptNumber = deapid.get(0).get("field0001") + "";// 财务部门编码
						deptName = deapid.get(0).get("field0002") + "";// 财务部门名称
					}
				}
				//String shenqingrendept = Functions.showDepartmentName(Long.valueOf(shenQingRenDept));// 部门
				String shenqingrendept = getAccountAndDepa(shenQingRenDept);
				String shenqingrensql = "SELECT * FROM "+deptForm+" WHERE field0003='" + shenqingrendept + "'"; // 申请人的部门
				List<Map<String, Object>> shenqingrenid = jdbcTemplate.queryForList(shenqingrensql);
				String shenqingrendeptNumber = "";
				String shenqingrendeptName = "";
				if (shenqingrenid != null && shenqingrenid.size() > 0) {
					shenqingrendeptNumber = shenqingrenid.get(0).get("field0001") + "";// 财务部门编码
					shenqingrendeptName = shenqingrenid.get(0).get("field0002") + "";// 财务部门名称
				}

				String userCode = getcode(shenQingRen); // 获取申请人code
				String dinPiaoRenCode = getcode(shenQingRen); // 获取订票人code
				String memberName = Functions.showMemberName(Long.valueOf(shenQingRen));// 人员id
				String jTzfqr="";
				String zSzfqr="";
				if("jt".equals(type)){
					String zhiFuSql = "SELECT * FROM CAIWU_JTDZ WHERE JOURNEY_ID ='"+danhao+"'"; // 申请人的部门
					List<Map<String, Object>> zhifu = jdbcTemplate.queryForList(zhiFuSql);
					if(zhifu != null && zhifu.size() > 0){
						jTzfqr=zhifu.get(0).get("ZF_QR")+"";
					}else{
						jTzfqr="未支付";
					}
					
					
				}
				if("zs".equals(type)){
					String zhiFuSql = "SELECT * FROM CAIWU_ZSDZ WHERE JOURNEY_ID ='"+danhao+"'"; // 申请人的部门
					List<Map<String, Object>> zhifu = jdbcTemplate.queryForList(zhiFuSql);
					if(zhifu != null && zhifu.size() > 0){
						zSzfqr=zhifu.get(0).get("ZF_QR")+"";
					}else{
						jTzfqr="未支付";
					}
					
					
				}
				
				
				
				mapall.put("accountNumber", accountNumber);
				mapall.put("accountName", accountName);
				mapall.put("deptNumber", deptNumber);
				mapall.put("deptName", deptName);
				mapall.put("projectName", projectName);
				mapall.put("projectNumber", projectNumber);
				mapall.put("shenqingrendeptNumber", shenqingrendeptNumber);
				mapall.put("shenqingrendeptName", shenqingrendeptName);
				mapall.put("userCode", userCode);
				mapall.put("dinpiaorencode", dinPiaoRenCode);
				mapall.put("memberName", memberName);
				mapall.put("jTzhifu", jTzfqr);
				mapall.put("zSzfqr", zSzfqr);
			}
		}
			log.info("***mapall**" + mapall.toString());
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "mapall", mapall), response);
		} catch (Exception e) {

			e.printStackTrace();
		}

	}
	
	
	@NeedlessCheckLogin
	/**
	 * 获取机构部门等信息
	 * 
	 * @param request
	 * @param response
	 */
	public void getFGSJiGou(HttpServletRequest request, HttpServletResponse response) {
		try {
			String accountForm = (String) PropertiesUtils.getInstance().get("accountForm");
	    	String deptForm = (String) PropertiesUtils.getInstance().get("deptForm");
	    	
			String danhao = request.getParameter("danhao");
			String type = request.getParameter("type");
			log.info("***getJiGou**" + danhao);
			String formman = (String) PropertiesUtils.getInstance().get("fGsformman");
			String sql = "SELECT * FROM "+formman+" where field0002=" + danhao;
			List<Map<String, Object>> yuanDanHao = jdbcTemplate.queryForList(sql);
			Map<String, Object> mapall = new HashMap<String, Object>();
			if(yuanDanHao != null && yuanDanHao.size() > 0){
			for (Map<String, Object> map : yuanDanHao) {
				String biaodan = (String) map.get("field0002") == null ? "" : (String) map.get("field0002");
				String shenQingRen = (String) map.get("field0003") == null ? "" : (String) map.get("field0003");// 申请人
				String shenQingRenDept = (String) map.get("field0005") == null ? "" : (String) map.get("field0005");// 申请人所在部门
				String dinPiaoRen = (String) map.get("field0025") == null ? "" : (String) map.get("field0025");// 订票人
				String projectName = (String) map.get("field0026") == null ? "" : (String) map.get("field0026");// 项目名称
				String projectNumber = (String) map.get("field0028") == null ? "" : (String) map.get("field0028");// 项目编号
				String shouYiBuMen = (String) map.get("field0029") == null ? "" : (String) map.get("field0029");// 受益部门
				// String bumen=(String)map.get("field0005")== null ?""
				// :(String)map.get("field0005");//申请人部门
				String accountNumber = "";
				String accountName = "";
				String[] dinpiaomemberAry = dinPiaoRen.split(",");
				if (dinpiaomemberAry.length > 0 && dinpiaomemberAry != null) {
					for (int i = 0; i < dinpiaomemberAry.length; i++) {
						//String Account = Functions.showOrgAccountNameByMemberid(Long.valueOf(dinpiaomemberAry[i]));// 单位
						//log.info("******------" + Account);
						
						String accountID="";
						String CODEsql = "SELECT * FROM org_member WHERE ID=" + String.valueOf(dinpiaomemberAry[i]); // 查询申请人code
						List<Map<String, Object>> orgName1 = jdbcTemplate.queryForList(CODEsql);
						if(orgName1 != null && orgName1.size() > 0){
							accountID = orgName1.get(0).get("ORG_ACCOUNT_ID")+""; 
						}
						String accountIDDpr = getAccountAndDepa(accountID);
						String orgsql = "select * from "+accountForm+" WHERE field0003 ='" + accountIDDpr + "'";
						List<Map<String, Object>> accountid = jdbcTemplate.queryForList(orgsql);
						if(accountid != null && accountid.size() >0){
							accountNumber = accountid.get(0).get("field0001") + "";// 财务机构编码
							accountName = accountid.get(0).get("field0002") + "";// 财务机构名称	
							}
						}
					}
				//String dept = "";
				String deptNumber = "";
				String deptName = "";
				if (!StringUtils.isEmpty(shouYiBuMen)) {
					//dept = Functions.showDepartmentName(Long.valueOf(shouYiBuMen));// 部门
					String shouYiBuMenCode = getAccountAndDepa(shouYiBuMen);
					String bumensql = "SELECT * FROM "+deptForm+" WHERE field0003='" + shouYiBuMenCode + "'"; // 受益部门
					List<Map<String, Object>> deapid = jdbcTemplate.queryForList(bumensql);
					if(deapid != null && deapid.size() > 0){
						deptNumber = deapid.get(0).get("field0001") + "";// 财务部门编码
						deptName = deapid.get(0).get("field0002") + "";// 财务部门名称
					}
				}
				//String shenqingrendept = Functions.showDepartmentName(Long.valueOf(shenQingRenDept));// 部门
				String shenqingrendept = getAccountAndDepa(shenQingRenDept);
				String shenqingrensql = "SELECT * FROM "+deptForm+" WHERE field0003='" + shenqingrendept + "'"; // 申请人的部门
				List<Map<String, Object>> shenqingrenid = jdbcTemplate.queryForList(shenqingrensql);
				String shenqingrendeptNumber = "";
				String shenqingrendeptName = "";
				if (shenqingrenid != null && shenqingrenid.size() > 0) {
					shenqingrendeptNumber = shenqingrenid.get(0).get("field0001") + "";// 财务部门编码
					shenqingrendeptName = shenqingrenid.get(0).get("field0002") + "";// 财务部门名称
				}

				String userCode = getcode(shenQingRen); // 获取申请人code
				String dinPiaoRenCode = getcode(shenQingRen); // 获取订票人code
				String memberName = Functions.showMemberName(Long.valueOf(shenQingRen));// 人员id
				String jTzfqr="";
				String zSzfqr="";
				if("jt".equals(type)){
					String zhiFuSql = "SELECT * FROM CAIWU_JTDZ WHERE JOURNEY_ID ='"+danhao+"'"; // 申请人的部门
					List<Map<String, Object>> zhifu = jdbcTemplate.queryForList(zhiFuSql);
					if(zhifu != null && zhifu.size() > 0){
						jTzfqr=zhifu.get(0).get("ZF_QR")+"";
					}else{
						jTzfqr="未支付";
					}
					
					
				}
				if("zs".equals(type)){
					String zhiFuSql = "SELECT * FROM CAIWU_ZSDZ WHERE JOURNEY_ID ='"+danhao+"'"; // 申请人的部门
					List<Map<String, Object>> zhifu = jdbcTemplate.queryForList(zhiFuSql);
					if(zhifu != null && zhifu.size() > 0){
						zSzfqr=zhifu.get(0).get("ZF_QR")+"";
					}else{
						jTzfqr="未支付";
					}
					
					
				}
				
				
				
				mapall.put("accountNumber", accountNumber);
				mapall.put("accountName", accountName);
				mapall.put("deptNumber", deptNumber);
				mapall.put("deptName", deptName);
				mapall.put("projectName", projectName);
				mapall.put("projectNumber", projectNumber);
				mapall.put("shenqingrendeptNumber", shenqingrendeptNumber);
				mapall.put("shenqingrendeptName", shenqingrendeptName);
				mapall.put("userCode", userCode);
				mapall.put("dinpiaorencode", dinPiaoRenCode);
				mapall.put("memberName", memberName);
				mapall.put("jTzhifu", jTzfqr);
				mapall.put("zSzfqr", zSzfqr);
			}
		}
			log.info("***mapall**" + mapall.toString());
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "mapall", mapall), response);
		} catch (Exception e) {

			e.printStackTrace();
		}

	}

	/**
	 * 人员code
	 * 
	 * @param userId
	 * @return
	 */
	public static String getcode(String userId) {
		String CODEsql = "SELECT ID,CODE FROM org_member WHERE ID=" + userId; // 查询申请人code
		List<Map<String, Object>> orgName = jdbcTemplate.queryForList(CODEsql);
		String id = "";
		String userCode = "";
		if (orgName.size() > 0 && orgName != null) {
			id = orgName.get(0).get("ID") + "";
			userCode = orgName.get(0).get("CODE") + "";

		}
		return userCode;
	}

	@NeedlessCheckLogin
	public void getRenYuan(HttpServletRequest request, HttpServletResponse response) {
		try {
			String name = request.getParameter("orgname");
			String sql = "SELECT ID,CODE , IS_DGJ FROM org_member WHERE NAME='" + name + "'";
			List<Map<String, Object>> orgName = jdbcTemplate.queryForList(sql);
			Map<String, Object> mapname = new HashMap<String, Object>();
			String id = "";
			String userCode = "";
			String IsDgj="";
			if (orgName.size() > 0 && orgName != null) {
				id = orgName.get(0).get("ID") + "";
				userCode = orgName.get(0).get("CODE") + "";
				String IsDgjType = orgName.get(0).get("IS_DGJ") + "";

				if(!StringUtils.isEmpty(IsDgjType) && !"null".equals(IsDgjType)){
					IsDgj="Y";
				}else{
					IsDgj="N";
				}
			}

			mapname.put("id", id);
			mapname.put("userCode", userCode);
			mapname.put("IsDgj", IsDgj);

			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "mapname", mapname), response);
		} catch (Exception e) {

			e.printStackTrace();
		}

	}

	@NeedlessCheckLogin
	/**
	 * 根据单号查出已经添加的非携程数据
	 * 
	 * @param request
	 * @param response
	 */
	public void openurlListXieCheng(HttpServletRequest request, HttpServletResponse response) {
		String danhaoid = request.getParameter("danhaoid");
		if (StringUtils.isEmpty(danhaoid)) {
			throw new RuntimeException("单号不能为空");
		}
		try {
			List<Map<String, Object>> queryCarAndShip = geRenZhiFuXinXi.queryCarAndShip(danhaoid);
			String cczong = "";
			String qtzong = "";
			if (queryCarAndShip.size() > 0 && queryCarAndShip != null) {
				cczong = queryCarAndShip.get(0).get("cczong") + "";
				qtzong = queryCarAndShip.get(0).get("qtzong") + "";

			}
			List<Map<String, Object>> queryZhuSu = geRenZhiFuXinXi.queryZhuSu(danhaoid);
			String jszonghe = "";
			if (queryZhuSu.size() > 0 && queryZhuSu != null) {
				jszonghe = queryZhuSu.get(0).get("jszonghe") + "";
			}
			List<Map<String, Object>> queryTongJi = geRenZhiFuXinXi.queryTongJi(danhaoid);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "queryCarAndShip", queryCarAndShip, "cczong", cczong, "qtzong", qtzong, "danhaoid", danhaoid, "jszonghe", jszonghe, "queryZhuSu", queryZhuSu, "queryTongJi", queryTongJi), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", false, "message", "操作失败!"), response);
			e.printStackTrace();
		}

	}

	
	/**
	 * 分公司非携程
	 * 
	 * @param request
	 * @param response
	 */
	public void getFeiXieChengFGS(HttpServletRequest request, HttpServletResponse response) {
		String danhaoid = request.getParameter("danhaoid");
		if (StringUtils.isEmpty(danhaoid)) {
			throw new RuntimeException("单号不能为空");
		}
		try {
			List<Map<String, Object>> queryCarAndShip = geRenZhiFuXinXi.getFenGonSiCheChuanDh(danhaoid);
			String cczong = "";
			String qtzong = "";
			if (queryCarAndShip.size() > 0 && queryCarAndShip != null) {
				cczong = queryCarAndShip.get(0).get("cczong") + "";
				qtzong = queryCarAndShip.get(0).get("qtzong") + "";
			}
			List<Map<String, Object>> queryZhuSu = geRenZhiFuXinXi.getFenGongSiZhusuDh(danhaoid);
			String jszonghe = "";
			if (queryZhuSu.size() > 0 && queryZhuSu != null) {
				jszonghe = queryZhuSu.get(0).get("jszonghe") + "";
			}
			List<Map<String, Object>> queryShiNeiJiaoTong = geRenZhiFuXinXi.queryShiNeiJiaoTong(danhaoid);
			String shinei="";
			if(queryShiNeiJiaoTong != null && queryShiNeiJiaoTong.size() > 0){
				shinei=queryShiNeiJiaoTong.get(0).get("zheji")+"";
			}
			List<Map<String, Object>> queryTongJi = geRenZhiFuXinXi.getFenGonSiShuHuHj(danhaoid);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "queryCarAndShip", queryCarAndShip,"shinei",shinei,"queryShiNeiJiaoTong",queryShiNeiJiaoTong, "cczong", cczong, "qtzong", qtzong, "danhaoid", danhaoid, "jszonghe", jszonghe, "queryZhuSu", queryZhuSu, "queryTongJi", queryTongJi), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", false, "message", "操作失败!"), response);
			e.printStackTrace();
		}

	}
	
	
	/*
	 * 获取部门秘书
	 */
	@NeedlessCheckLogin
	public void getBumenMiShu(HttpServletRequest request, HttpServletResponse response) {
		String userGetId = request.getParameter("userGetId");
		String getSql = "SELECT * from org_member WHERE id ="+ userGetId;
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(getSql); // 
		if(queryForList != null && queryForList.size() >0){
			try {
				String depaId = queryForList.get(0).get("ORG_DEPARTMENT_ID")+"";
				if(depaId != null){
					Long deId = Long.valueOf(depaId);
					OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
					 V3xOrgDepartment parentDepartment = orgManager.getParentDepartment(deId);
					 Long id2 = 0L;
					 if(parentDepartment == null){
						 id2=deId;
					 }else{
						 id2=parentDepartment.getId();//一级部门
					 }
            		
					List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2, "部室秘书");
					List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
					for (V3xOrgMember v3xOrgMember : membersByRole) {
						Map<String,Object> map1=new HashMap<String, Object>();
						Long id = v3xOrgMember.getId();
						String ids = String.valueOf(id);
						String name = v3xOrgMember.getName();
						map1.put("id", ids);
						map1.put("name", name);
						list.add(map1);
					}
					
					this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!", "list", list), response);
				}
				
			} catch (BusinessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	@NeedlessCheckLogin
	public void xiechengTiQiangShengPi(HttpServletRequest request, HttpServletResponse response) {
		String massig = "";
		try {
			String formrecid = request.getParameter("formrecid");
			String dPmemberId = request.getParameter("memberId");//订票人
			
			User user = AppContext.getCurrentUser();
            Long account = user.getAccountId();
            String accountId = String.valueOf(account);

			if (StringUtils.isEmpty(formrecid)) {
				massig = "获取表单id失败";
				throw new RuntimeException("formmid 为空");
			}

			if (StringUtils.isEmpty(accountId)) {
				massig = "请登录后重试";
				throw new RuntimeException("accountId 为空");
			}
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

			String formman = (String) PropertiesUtils.getInstance().get("formman");

			String proCode = ""; // 审批单上项目编码
			String depart = ""; // 审批单上受益部门编码
			String code = ""; // 出差审批单申请人编码
			String fromCities = ""; // 出发城市
			String toCity = ""; // 到达城市
			String hotelToCities = ""; // 入住城市
			String beginDate = ""; // 预计出差时间
			String endDate = ""; // 预计返回时间
			String employeeID = "";
			String approvalNumber = "";
			Long shenqinren = null;
			String memberList = "";

			// 主表：申请人(field0003),申请单编号(field0002),项目编号(field0019),
			// 受益部门(field0020),出差人(field0006 **** field0016),英文名称(field0007)
			// 出发地(field0008), 目的地(field0030 field0049)
			// 入住城市(field0050),预计出差时间(field0010),预计返回时间(c),出差性质(field0011,field0012,field0013)
			//String sql = "SELECT field0002 as field0002,field0003 as field0003,field0019,field0020,field0006,field0007," + "field0008,field0049,field0050,field0010,field0016,field0051,field0011,field0012,field0013 FROM " + formman + " where id=" + formrecid;
			String sql = "SELECT field0002 as field0002,field0003 as field0003,field0024 as field0019,field0025 as field0020,field0006 as field0006,field0007 as field0007," + "field0008 as field0008,field0009 as field0049,field0011 as field0050,field0012 as field0010,field0016 as field0016,field0013 as field0051,field0011 as field0011,field0012 as field0012,field0013 as field0013 FROM " + formman + " where id=" + formrecid;
			//String sql = "SELECT field0002 as field0002,field0003 as field0003,field0019 as field0019,field0020 as field0020,field0006 as field0006,field0007 as field0007,field0008 as field0008,field0030 as field0049,field0031 as field0050,field0010 as field0010,field0016 as field0016,field0032 as field0051,field0011 as field0011,field0012 as field0012,field0013 as field0013 FROM " + formman + " where id=" + formrecid;
			/*
			 * String sql =
			 * "SELECT field0002,field0003,field0019,field0020,field0006,field0007,"
			 * +
			 * "field0008,field0010,field0016,field0011,field0012,field0013 FROM "
			 * +formman+" where id="+ formrecid;
			 */
			List<Map<String, Object>> Listsql = jdbcTemplate.queryForList(sql);
			if(Listsql != null && Listsql.size() > 0){
			for (Map<String, Object> map : Listsql) {
				shenqinren = Long.valueOf(map.get("field0003") + ""); // 申请人id
				approvalNumber = map.get("field0002") == null ? "" : (String) map.get("field0002"); // 审批单号
				String passengerList = map.get("field0006") == null ? "" : (String) map.get("field0006"); // 出差人
																											// 申请人
																											// 统一订票
				String dinpiaoren =dPmemberId; //map.get("field0016") == null ? "" : (String) map.get("field0016"); // 订票
				String passengerListEn = map.get("field0007") == null ? "" : (String) map.get("field0007"); // 出差人英文名称
				fromCities = map.get("field0008") == null ? "" : map.get("field0008").toString(); // 出发地
				toCity = map.get("field0049") == null ? "" : map.get("field0049").toString(); // 目的地
				hotelToCities = map.get("field0050") == null ? "" : map.get("field0050").toString(); // 入住城市
																										// field0050
				proCode = map.get("field0019") == null ? "" : (String) map.get("field0019"); // 项目编号
				depart = map.get("field0020") == null ? "" : (String) map.get("field0020"); // 受益部门
				beginDate = format.format((Date) map.get("field0010")); // 预计出发时间
				endDate = format.format((Date) map.get("field0051")); // 预计返回时间
																		// field0051

				// ======================拼接出差人信息开始======================
				memberList += "[";
				if (passengerList != null && !passengerList.equals("")) {
					String[] memberAry = passengerList.split(",");
					if (memberAry != null && memberAry.length > 0) {
						for (int i = 0; i < memberAry.length; i++) {
							if (i != 0)
								memberList += ",";
							Long memberId = Long.valueOf(memberAry[i]);
							String memberInfosql = "select m.name as name,p.login_name as loginname from org_member m LEFT JOIN org_principal p on p.member_Id = m.id where m.id=" + memberId;
							log.info("*********" + memberInfosql);
							List<Map<String, Object>> memberLists = jdbcTemplate.queryForList(memberInfosql);
							if (memberLists != null && memberLists.size() > 0) {
								for (int j = 0; j < memberLists.size(); j++) {
									Map<String, Object> memberMap = memberLists.get(j);
									String name = (String) memberMap.get("name");
									memberList += "{\"Name\"" + ":" + "\"" + name + "\"}";
									// employeeID
									// +=memberMap.get("loginname")+",";
								}
							}
						}
					}
				}
				if (passengerListEn != null && !passengerListEn.equals("")) {
					String[] memberEnAry = passengerListEn.split(",");
					if (memberEnAry != null && memberEnAry.length > 0) {
						memberList += ",";
						for (int i = 0; i < memberEnAry.length; i++) {
							if (i != 0)
								memberList += ",";
							Long memberId = Long.valueOf(memberEnAry[i]);
							String memberInfosql = "select m.name as name,p.login_name as loginname from org_member m LEFT JOIN org_principal p on p.member_Id = m.id where m.id=" + memberId;
							List<Map<String, Object>> memberLists = jdbcTemplate.queryForList(memberInfosql);
							if (memberLists != null && memberLists.size() > 0) {
								for (int j = 0; j < memberLists.size(); j++) {
									Map<String, Object> memberMap = memberLists.get(j);
									String name = (String) memberMap.get("name");
									memberList += "{\"Name\"" + ":" + "\"" + name + "\"}";
								}
							}
						}
					}
				}
				memberList += "]";
				// ======================拼接出差人信息结束======================
				if (dinpiaoren != null && !dinpiaoren.equals("")) {
					String[] dinpiaomemberAry = dinpiaoren.split(",");
					if (dinpiaomemberAry != null && dinpiaomemberAry.length > 0) {
						for (int i = 0; i < dinpiaomemberAry.length; i++) {
							String memberInfosql = "select LOGIN_NAME from org_principal  where MEMBER_ID=" + dinpiaomemberAry[i];
							List<Map<String, Object>> memberid = jdbcTemplate.queryForList(memberInfosql);
							employeeID += memberid.get(0).get("LOGIN_NAME") + ",";
							
						}
					}
				}
			}
		}
			employeeID = employeeID.substring(0,employeeID.length() - 1);
			StringBuilder build = new StringBuilder();
			build.append("{");
			build.append("\"ApprovalNumber\":\"" + approvalNumber + "\","); // OA审批单号
			build.append("\"EmployeeID\":\"" + employeeID + "\","); //
			build.append("\"Status\":\"1\","); // 审批状态
			build.append("\"FromCities\":\"" + fromCities + "\","); // 出发地
			build.append("\"ToCities\":\"" + toCity + "\","); // 目的地
			build.append("\"HotelToCities\" : \"" + hotelToCities + "\","); // 入住城市
			build.append("\"ToDate\"" + ":" + "\"" + beginDate + "\","); // 预计出发时间
			build.append("\"ReturnDate\"" + ":" + "\"" + endDate + "\","); // 预计返回时间
			build.append("\"PassengerList\" : " + memberList); // 出差人员信息
			build.append("}");
			log.info(build.toString());
			Map<String, Object> SetApprovalJSON = new HashMap<String, Object>();
			SetApprovalJSON.put("SetApprovalJSON", build.toString());
			SetApprovalJSON.put("accountId", accountId);
			String sendTiqianShenpi = (String) PropertiesUtils.getInstance().get("sendTiqianShenpi");
			String res = HttpClientUtil.post(sendTiqianShenpi, SetApprovalJSON);
			JSONObject jsonres = (JSONObject) JSONSerializer.toJSON(res);
			String result = jsonres.get("result").toString();// .getJSONObject("result").getString("Status").toString();
			JSONObject fromObject = JSONObject.fromObject(result);
			String success = fromObject.getString("Status");
			String successxc = fromObject.getString("success");
			log.info("[" + approvalNumber + "]提前审批发送完毕：" + res);
			this.write(JSONUtilsExt.objects2json("success", true, "message1", "" + successxc + "", "success1", success, "res", res), response);
		} catch (Exception e) {
			massig += e.getCause().getMessage();
			this.write(JSONUtilsExt.objects2json("success", false, "message1", "操作失败!" + massig), response);
			e.printStackTrace();
		}
	}
	/**
	 * 携程分公司提前审批
	 * @param request
	 * @param response
	 */
	@NeedlessCheckLogin
	public void fenGonSiTiQiangShengPi(HttpServletRequest request, HttpServletResponse response) {
		String massig = "";
		try {
			User user = AppContext.getCurrentUser();
            Long account = user.getAccountId();
            String accountId = String.valueOf(account);
			String formrecid = request.getParameter("formrecid");
			String dPmemberId = request.getParameter("memberId");//订票人
			if (StringUtils.isEmpty(formrecid) || StringUtils.isEmpty(accountId)) {
				massig = "获取表单id失败";
				throw new RuntimeException("formmid 为空");
			}
			
			if (StringUtils.isEmpty(accountId)) {
				massig = "请登录后重试";
				throw new RuntimeException("account 为空");
			}

			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

			String formman = (String) PropertiesUtils.getInstance().get("fGsformman");

			String proCode = ""; // 审批单上项目编码
			String depart = ""; // 审批单上受益部门编码
			String code = ""; // 出差审批单申请人编码
			String fromCities = ""; // 出发城市
			String toCity = ""; // 到达城市
			String hotelToCities = ""; // 入住城市
			String beginDate = ""; // 预计出差时间
			String endDate = ""; // 预计返回时间
			String employeeID = "";
			String approvalNumber = "";
			Long shenqinren = null;
			String memberList = "";

			// 主表：申请人(field0003),申请单编号(field0002),项目编号(field0019),
			// 受益部门(field0020),出差人(field0006 **** field0016),英文名称(field0007)
			// 出发地(field0008), 目的地(field0030 field0049)
			// 入住城市(field0031),预计出差时间(field0010),预计返回时间(c),出差性质(field0011,field0012,field0013)
			//String sql = "SELECT field0002 as field0002,field0003 as field0003,field0019,field0020,field0006,field0007," + "field0008,field0049,field0050,field0010,field0016,field0051,field0011,field0012,field0013 FROM " + formman + " where id=" + formrecid;
			String sql = "SELECT field0002 as field0002,field0003 as field0003,field0024 as field0019,field0025 as field0020,field0006 as field0006,field0007 as field0007," + "field0008 as field0008,field0009 as field0049,field0011 as field0050,field0012 as field0010,field0016 as field0016,field0013 as field0051,field0011 as field0011,field0012 as field0012,field0013 as field0013 FROM " + formman + " where id=" + formrecid;
			//String sql = "SELECT field0002 as field0002,field0003 as field0003,field0019 as field0019,field0020 as field0020,field0006 as field0006,field0007 as field0007,field0008 as field0008,field0030 as field0049,field0031 as field0050,field0010 as field0010,field0016 as field0016,field0032 as field0051,field0011 as field0011,field0012 as field0012,field0013 as field0013 FROM " + formman + " where id=" + formrecid;
			
			List<Map<String, Object>> Listsql = jdbcTemplate.queryForList(sql);
			if(Listsql != null && Listsql.size() > 0){
			for (Map<String, Object> map : Listsql) {
				shenqinren = Long.valueOf(map.get("field0003") + ""); // 申请人id
				approvalNumber = map.get("field0002") == null ? "" : (String) map.get("field0002"); // 审批单号
				String passengerList = map.get("field0006") == null ? "" : (String) map.get("field0006"); // 出差人
																											// 申请人
																											// 统一订票
				String dinpiaoren = dPmemberId;//= map.get("field0016") == null ? "" : (String) map.get("field0016"); // 订票
				String passengerListEn = map.get("field0007") == null ? "" : (String) map.get("field0007"); // 出差人英文名称
				fromCities = map.get("field0008") == null ? "" : map.get("field0008").toString(); // 出发地
				toCity = map.get("field0049") == null ? "" : map.get("field0049").toString(); // 目的地
				hotelToCities = map.get("field0050") == null ? "" : map.get("field0050").toString(); // 入住城市
																										// field0050
				proCode = map.get("field0019") == null ? "" : (String) map.get("field0019"); // 项目编号
				depart = map.get("field0020") == null ? "" : (String) map.get("field0020"); // 受益部门
				beginDate = format.format((Date) map.get("field0010")); // 预计出发时间
				endDate = format.format((Date) map.get("field0051")); // 预计返回时间
																		// field0051

				// ======================拼接出差人信息开始======================
				memberList += "[";
				if (passengerList != null && !passengerList.equals("")) {
					String[] memberAry = passengerList.split(",");
					if (memberAry != null && memberAry.length > 0) {
						for (int i = 0; i < memberAry.length; i++) {
							if (i != 0)
								memberList += ",";
							Long memberId = Long.valueOf(memberAry[i]);
							String memberInfosql = "select m.name as name,p.login_name as loginname from org_member m LEFT JOIN org_principal p on p.member_Id = m.id where m.id=" + memberId;
							log.info("*********" + memberInfosql);
							List<Map<String, Object>> memberLists = jdbcTemplate.queryForList(memberInfosql);
							if (memberLists != null && memberLists.size() > 0) {
								for (int j = 0; j < memberLists.size(); j++) {
									Map<String, Object> memberMap = memberLists.get(j);
									String name = (String) memberMap.get("name");
									memberList += "{\"Name\"" + ":" + "\"" + name + "\"}";
									// employeeID
									// +=memberMap.get("loginname")+",";
								}
							}
						}
					}
				}
				if (passengerListEn != null && !passengerListEn.equals("")) {
					String[] memberEnAry = passengerListEn.split(",");
					if (memberEnAry != null && memberEnAry.length > 0) {
						memberList += ",";
						for (int i = 0; i < memberEnAry.length; i++) {
							if (i != 0)
								memberList += ",";
							Long memberId = Long.valueOf(memberEnAry[i]);
							String memberInfosql = "select m.name as name,p.login_name as loginname from org_member m LEFT JOIN org_principal p on p.member_Id = m.id where m.id=" + memberId;
							List<Map<String, Object>> memberLists = jdbcTemplate.queryForList(memberInfosql);
							if (memberLists != null && memberLists.size() > 0) {
								for (int j = 0; j < memberLists.size(); j++) {
									Map<String, Object> memberMap = memberLists.get(j);
									String name = (String) memberMap.get("name");
									memberList += "{\"Name\"" + ":" + "\"" + name + "\"}";
										}
									}
								}
							}
						}
				memberList += "]";
				// ======================拼接出差人信息结束======================
				if (dinpiaoren != null && !dinpiaoren.equals("")) {
					String[] dinpiaomemberAry = dinpiaoren.split(",");
					if (dinpiaomemberAry != null && dinpiaomemberAry.length > 0) {
						for (int i = 0; i < dinpiaomemberAry.length; i++) {
							String memberInfosql = "select LOGIN_NAME from org_principal  where MEMBER_ID=" + dinpiaomemberAry[i];
							List<Map<String, Object>> memberid = jdbcTemplate.queryForList(memberInfosql);
							employeeID += memberid.get(0).get("LOGIN_NAME") + ",";
						}
					}
				}
			}
		}
			employeeID = employeeID.substring(0,employeeID.length() - 1);
			StringBuilder build = new StringBuilder();
			build.append("{");
			build.append("\"ApprovalNumber\":\"" + approvalNumber + "\","); // OA审批单号
			build.append("\"EmployeeID\":\"" + employeeID + "\","); //
			build.append("\"Status\":\"1\","); // 审批状态
			build.append("\"FromCities\":\"" + fromCities + "\","); // 出发地
			build.append("\"ToCities\":\"" + toCity + "\","); // 目的地
			build.append("\"HotelToCities\" : \"" + hotelToCities + "\","); // 入住城市
			build.append("\"ToDate\"" + ":" + "\"" + beginDate + "\","); // 预计出发时间
			build.append("\"ReturnDate\"" + ":" + "\"" + endDate + "\","); // 预计返回时间
			build.append("\"PassengerList\" : " + memberList); // 出差人员信息
			build.append("}");
			log.info(build.toString());
			Map<String, Object> SetApprovalJSON = new HashMap<String, Object>();
			SetApprovalJSON.put("SetApprovalJSON", build.toString());
			SetApprovalJSON.put("accountId", accountId);
			String sendTiqianShenpi = (String) PropertiesUtils.getInstance().get("sendTiqianShenpi");
			String res = HttpClientUtil.post(sendTiqianShenpi, SetApprovalJSON);
			JSONObject jsonres = (JSONObject) JSONSerializer.toJSON(res);
			String result = jsonres.get("result").toString();// .getJSONObject("result").getString("Status").toString();
			JSONObject fromObject = JSONObject.fromObject(result);
			String success = fromObject.getString("Status");
			String successxc = fromObject.getString("success");
			log.info("[" + approvalNumber + "]提前审批发送完毕：" + res);
			this.write(JSONUtilsExt.objects2json("success", true, "message1", "" + successxc + "", "success1", success, "res", res), response);
		} catch (Exception e) {
			massig += e.getCause().getMessage();
			this.write(JSONUtilsExt.objects2json("success", false, "message1", "操作失败!" + massig), response);
			e.printStackTrace();
		}
	}
	
    @NeedlessCheckLogin
	public void getAllJDCity(HttpServletRequest request, HttpServletResponse response){
		try {
			List<City> cityList = new ArrayList<City>();
			Map<String,List<City>> map=new TreeMap();
			String arr [] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
			for (int i = 0; i < arr.length; i++) {
				map.put(arr[i], new ArrayList<City>());
			}
			cityList = cityService.getAllCity();
			for (City ci : cityList) {
				String upperCase = ci.getCityEName().substring(0, 1).toUpperCase();
				if(map.containsKey(upperCase)){
					map.get(upperCase).add(ci);
				}
			}
			Set<Map.Entry<String, List<City>>> entrySet = map.entrySet();
			for (Map.Entry<String, List<City>> entry : entrySet) {
				if(entry.getValue() != null && entry.getValue().size() > 0){
					System.out.println("================"+entry.getKey()+"===============");
					for (City c : entry.getValue()) {
						//System.out.println(c.getCityName()); //城市名称
					}
				}
				
			}
			this.write(JSONUtilsExt.objects2json("success", true, "message1", "", "entrySet", entrySet,"cityList",cityList), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			this.write(JSONUtilsExt.objects2json("success", false, "message1", ""), response);

		}
	}
    
    @NeedlessCheckLogin
	public void getAllJPCity(HttpServletRequest request, HttpServletResponse response){
		try {
			List<CityEntity> cityList = new ArrayList<CityEntity>();
			Map<String,List<CityEntity>> map=new TreeMap();
			String arr [] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
			for (int i = 0; i < arr.length; i++) {
				map.put(arr[i], new ArrayList<CityEntity>());
			}
			cityList = cityService.getAllCityEntity();
			for (CityEntity ci : cityList) {
				String upperCase = ci.getName_En().substring(0, 1).toUpperCase();
				if(map.containsKey(upperCase)){
					map.get(upperCase).add(ci);
				}
			}
			Set<Map.Entry<String, List<CityEntity>>> entrySet = map.entrySet();
			for (Map.Entry<String, List<CityEntity>> entry : entrySet) {
				if(entry.getValue() != null && entry.getValue().size() > 0){
					System.out.println("================"+entry.getKey()+"===============");
					for (CityEntity c : entry.getValue()) {
						//System.out.println(c.getName_En()); //城市名称
					}
				}
				
			}
			this.write(JSONUtilsExt.objects2json("success", true, "message1", "", "entrySet", entrySet,"cityList",cityList), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			this.write(JSONUtilsExt.objects2json("success", false, "message1", ""), response);

		}
	}

	protected void write(String str, HttpServletResponse response) {
		try {
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write(str);
			response.getWriter().flush();
			response.getWriter().close();
		} catch (Exception e) {
		}
	}

}
