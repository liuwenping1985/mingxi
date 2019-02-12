package com.seeyon.apps.kdXdtzXc.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XieChenXinXiQueRenManager;
import com.seeyon.apps.kdXdtzXc.po.XiangxiEntity;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPFlight;
import com.seeyon.apps.kdXdtzXc.po.XiechengERPHotel;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class XieChenXinXiQueRenController  extends BaseController{
	
	private XieChenXinXiQueRenManager xieChenXinXiQueRenManager;
	
	public XieChenXinXiQueRenManager getXieChenXinXiQueRenManager() {
		return xieChenXinXiQueRenManager;
	}

	public void setXieChenXinXiQueRenManager(XieChenXinXiQueRenManager xieChenXinXiQueRenManager) {
		this.xieChenXinXiQueRenManager = xieChenXinXiQueRenManager;
	}

	/**
	 * 功能：获取出差详情
	 * @param request
	 * @param response
	 * @return
	 */
	
	public ModelAndView getXieChengXianQing(HttpServletRequest request,HttpServletResponse response){
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/xiecheng_view");
		String employeeID = request.getParameter("name");
		String bianhao = request.getParameter("bianhao");
		Long nameLongID = null;
		if(bianhao != null && employeeID != null){
			nameLongID = Long.valueOf(employeeID);
		}

		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		String getLongName ="SELECT LOGIN_NAME FROM org_principal WHERE MEMBER_ID ="+nameLongID;
		List<Map<String, Object>> longName = jdbcTemplate.queryForList(getLongName);
	    String loginName = longName.get(0).get("LOGIN_NAME")+"";
	    String memberName = Functions.showMemberName(nameLongID);
	    
	    User user = AppContext.getCurrentUser();
        Long account = user.getAccountId();
        String accountId = String.valueOf(account);
		
		//查询条件
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("memberName", memberName);
		map.put("bianhao", bianhao);
		map.put("accountId", accountId);
		//出差申请审批中间区Url地址
		String ChuChaiShenQing_Url = (String) PropertiesUtils.getInstance().get("ChuChaiShenQing");
		
		//post请求中间区地址将条件传入中间区信息查询反馈
		String responseResult = HttpClientUtil.post(ChuChaiShenQing_Url, map);
		//获取中间区返回的酒店机票详情信息
		JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);
		String jsonJipiao  = jsonObject.optString("jipiaoList");
		String jsonJiudian  = jsonObject.optString("jiudianList");
		//机票
		List<XiangxiEntity> jipiaolist = new ArrayList<XiangxiEntity>();
		//将json转换成Array 进行循环
		XiangxiEntity[] xiangxiEntity =(XiangxiEntity[])JSONArray.toArray(JSONArray.fromObject(jsonJipiao),XiangxiEntity.class);
		for (XiangxiEntity entity : xiangxiEntity) {
			jipiaolist.add(entity);
			
		}
		//酒店
		List<XiangxiEntity> jiudianlist = new ArrayList<XiangxiEntity>();
		XiangxiEntity[] xiangxijiudianEntity =(XiangxiEntity[])JSONArray.toArray(JSONArray.fromObject(jsonJiudian),XiangxiEntity.class);
		for (XiangxiEntity xiangxiEntity2 : xiangxijiudianEntity) {
			jiudianlist.add(xiangxiEntity2);
		}
		//根据机票，酒店来的数据来修改标签样式
		int zong=jipiaolist.size()+jiudianlist.size()+2;  //页面的 rowspan 的值
		int jipiao=jipiaolist.size()+1;
		int jiud=jiudianlist.size()+1;
		
		mav.addObject("jipiaolist", jipiaolist).addObject("jiudianlist",jiudianlist)
		.addObject("zong",zong).addObject("jipiao",jipiao).addObject("jiud",jiud)
		.addObject("bianhao",bianhao).addObject("memberName",memberName);
		
		return mav;
	}
	
    /**
     * 功能: 携程结算数据界面显示tabs界面
     */
    @NeedlessCheckLogin
    public ModelAndView listXiecheng_tabs(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiecheng_tabs");
        return modelAndView;
    }
    public ModelAndView listXiechengysDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String bigDate=request.getParameter("bigDate");
    	ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengDialog").addObject("bigDate",bigDate);
        return modelAndView;
    }
    /**
     * 功能: 携程结算数据界面显示tabs界面 
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengDuizhang_tabs(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengDuizhang_tabs");
        return modelAndView;
    }
    
    /**
     * 功能: 携程结算数据界面弹出框
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengDuizhangDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String bigDate=request.getParameter("bigDate");
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengDuizhangDialog");
        modelAndView.addObject("big", bigDate);
        return modelAndView;
    }
    
    /**
     * 功能: 携程结算-机票
     */
    @NeedlessCheckLogin
    public ModelAndView xiecheng_jipiaojiesuan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiecheng_jipiaojiesuan");
        //机票接口URL
        String xieChengJiPiao_Url = (String) PropertiesUtils.getInstance().get("xieChengJiPiao");
        //根据URL获取接口返回的json串
        String responseResult = HttpClientUtil.post(xieChengJiPiao_Url,"");
        
		//String hotelAccountSettlementInfoJson =((JSONObject)JSONSerializer.toJSON(responseResult)).optString("jipiaojsList");
		//List<XiechengERPFlight> xiechengJipiaoList = JSONUtilsExt.fromListJson(hotelAccountSettlementInfoJson, XiechengERPFlight.class);
        JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);
        String jsonJipiao  = jsonObject.optString("jipiaojsList");
		List<XiechengERPFlight> xiechengERPHotelList = new ArrayList<XiechengERPFlight>();
		XiechengERPFlight[] xiechengJipiaoList =(XiechengERPFlight[])JSONArray.toArray(JSONArray.fromObject(jsonJipiao),XiechengERPFlight.class);
		if(xiechengJipiaoList != null && xiechengJipiaoList.length > 0){
			for (XiechengERPFlight xiechengERPFlight : xiechengJipiaoList) {
				xiechengERPHotelList.add(xiechengERPFlight);
			}
		}
		modelAndView.addObject("xiechengJipiaoList", xiechengERPHotelList);
        return modelAndView;
    }
    
    /**
     * 功能: 携程结算-酒店
     */
    @NeedlessCheckLogin
    public ModelAndView xiecheng_jiudianjiesuan(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiecheng_jiudianjiesuan");
    	//酒店接口URL
    	String xieChengJiudian_Url = (String) PropertiesUtils.getInstance().get("xieChengJiudian");
    	//根据URL获取接口返回的json串
    	//根据URL获取接口返回的json串
        String responseResult = HttpClientUtil.post(xieChengJiudian_Url,"");
        JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);
		String jsonJipiao  = jsonObject.optString("zhusujsList");
		List<XiechengERPHotel> xiechengJiudianList = new ArrayList<XiechengERPHotel>();
		XiechengERPHotel[] xiechengERPHotel =(XiechengERPHotel[])JSONArray.toArray(JSONArray.fromObject(jsonJipiao),XiechengERPHotel.class);
		if(xiechengERPHotel != null && xiechengERPHotel.length >0){
			for (XiechengERPHotel entity : xiechengERPHotel) {
				xiechengJiudianList.add(entity);
			}
		}
		modelAndView.addObject("xiechengJiudianList", xiechengJiudianList);
        return modelAndView;
    }
    
    
    /**
     * 功能：人事对接
     * 获取所需的人员信息封装为json格式串给中间区
     * @param request
     * @param response
     * @throws Exception
     */
    @NeedlessCheckLogin
    public void EmployeeDuijie(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            String message = "操作成功！";

            String type = request.getParameter("type");
            if(type == null && type == "")
            	throw new Exception("type 参数丢失");
            
            // 查询人员信息
            List<Map<String, Object>> memberList = null;
            if("Whole".equals(type)){
            	memberList = null;//xieChenXinXiQueRenManager.getDataByMemberWhole();
            }else if("Time".equals(type)){
            	memberList = null;// xieChenXinXiQueRenManager.getDataByMemberTime();
            }else{
            	throw new Exception("type 参数丢失,或参数错误");
            }
            if(memberList != null && memberList.size() > 0){
            	String subAccount="cindaAsset-中国信达资产管理股份有限公司-提前审批";
            	StringBuilder builder = new StringBuilder();
            	//builder.append("{");
        		//builder.append("\"Member\":[ ");
            	for (int i =0;i<memberList.size();i++) {
            		Map<String, Object> map = memberList.get(i);
            		Long id = map.get("id") == null ? 0 :(Long) map.get("id");
            		String EmployeeID = map.get("LOGIN_NAME") == null ? "" : (String) map.get("LOGIN_NAME");//员工编码	LOGIN_NAME为登录人员名称
            		String Name = map.get("NAME") == null ? "" : (String) map.get("NAME");//姓名
            		String Dept1 = map.get("ORG_ACCOUNT_ID").toString() == null ? "" : (String) map.get("ORG_ACCOUNT_ID").toString();//信达机构编码	ORG_ACCOUNT_ID为公司ID
            		//String Account = Functions.showOrgAccountNameByMemberid(Long.valueOf(id));//单位
            		String Dept2 = map.get("ORG_DEPARTMENT_ID").toString() == null ? "" : (String) map.get("ORG_DEPARTMENT_ID").toString();//部门编码	ORG_DEPARTMENT_ID部门ID
            		//Dept2 = Functions.showDepartmentName(Long.valueOf(Dept2));//部门
            		String Email = map.get("EXT_ATTR_2") == null ? "" : (String) map.get("EXT_ATTR_2");//Email 
            		String Is_deleted = map.get("IS_DELETED").toString() == null ? "" : (String) map.get("IS_DELETED").toString();//是否删除
            		String IsSendEMail = "False";	//是否发送开通邮件
            		String Valid = null;			//在职状态（ A-在职,I-离职）
            		String IsBookClass = null;		//国内机票两舱是否可预订
            		String RankName = null;			//职级
            		String IntlBookClassBlock = null;//国际屏蔽舱位控制
            		if(Is_deleted != "1" ){
            			Valid = "A";
            		}else{
            			Valid = "I";
            		}
            		//判断是否是第一个（从0开始）如果是不添加“，”号。
            		if(i != 0)
            			builder.append(",");
            		builder.append("{\"Authentication\":{");
            		builder.append("\"EmployeeID\": \""+EmployeeID+"\"");		//员工编号
            		builder.append(",\"Name\": \""+Name+"\"");		//用户姓名
            		builder.append(",\"Dept1\": \""+Dept1+"\"");	//部门1
            		builder.append(",\"Dept2\": \""+Dept2+"\"");	//部门2
            		builder.append(",\"Email\": \""+Email+"\"");	//联系邮箱
            		builder.append(",\"IsSendEMail\": \""+IsSendEMail+"\"");	//是否发送开通邮件默认为false
            		builder.append(",\"SubAccountName\": \""+subAccount+"\"");	//
            		builder.append(",\"Valid\": \""+Valid+"\"");	//在职情况
            		//builder.append(",\"RankName\": \""+RankName+"\"");	//职级
            		//builder.append(",\"IsBookClass\": \""+IsBookClass+"\"");	//关联信达员工国内机票差标设置，是否可预订高舱等。T:是，F：否。
            		builder.append(",\"IntlBookClassBlock\": \""+IntlBookClassBlock+"\"");	//职级
            		builder.append("}}");
            	}
            		//builder.append(",\"Sequence\": \""+0+"\"");
            	//builder.append("]}");
            	String Renshiduijie = builder.toString();
            	//post将人员的信息传入中间区
            	Map<String,Object> map=new HashMap<String,Object>();
            	map.put("Renshiduijie", Renshiduijie);
            	//从配置文件中获取要post到中间区的地址
            	String RenShiDuiJie = (String) PropertiesUtils.getInstance().get("RenShiDuiJie");
        		String responseResult = HttpClientUtil.post(RenShiDuiJie, map);
        		JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);//返回
        		String jsonJipiao  = jsonObject.optString("message");
        		
        		this.write(JSONUtils.objects2json("success", true, "message",jsonJipiao), response);
            }
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "操作失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    
    
    protected void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }
}
