package com.seeyon.apps.kdXdtzXc.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.sso.LoginXieCheng;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class LoginXieChengController extends BaseController{
	
	
	public static String appKey = "obk_cindaAsset";      //总部
	public static String BJappKey = "obk_cindaAssetBJ";  //北京
	public static String HBappKey = "obk_cindaAssetHB";  // 湖北
	public static String JSappKey = "obk_cindaAssetJS";  //江苏
	
	public static String appSecurity = "obk_cindaAsset";     //总部
	public static String BJappSecurity = "obk_cindaAssetBJ"; //北京
	public static String HBappSecurity = "obk_cindaAssetHB"; //湖北
	public static String JSappSecurity = "obk_cindaAssetJS"; //江苏
	public static String accountId = "173907";		// 公司编号
	public static String BJaccountId = "182465";	// 北京
	public static String HBaccountId = "179331";	// 湖北
	public static String JSaccountId = "179336";	// 江苏
	public static String subAccountName = "cindaAsset-中国信达资产管理股份有限公司";// 人事接口
	public static String cindaasset = "CINDAASSET"; //人事信息接口
	public static String BJcindaasset = "CINDAASSETBJ"; //人事信息接口
	public static String HBcindaasset = "CINDAASSETHB"; //人事信息接口
	public static String JScindaasset = "CINDAASSETJS"; //人事信息接口
	private static Log LOGGER = LogFactory.getLog(LoginXieCheng.class);
	/**
	 * 携程单点
	 * @return
	 */
	@NeedlessCheckLogin
	public void toXieCheng(HttpServletRequest request, HttpServletResponse response){
			try {
				String employeeID = AppContext.getCurrentUser().getLoginName();
				Long accountId2 = AppContext.getCurrentUser().getAccountId();
				String accountZBId=String.valueOf(accountId2);
				String appKey = "";// 接入账号 携程提供  
				String appSecurity = "";// 接入密码 携程提供
				String cindaasset ="";
				String xieChengType="";
				
				if(StringUtils.isEmpty(employeeID)){
					throw new RuntimeException("未登录");
				}
				
				if("-1792902092017745579".equals(accountZBId)){
					appKey=LoginXieCheng.appKey;// 携程提供
					appSecurity=LoginXieCheng.appSecurity;// 携程提供
					cindaasset=LoginXieCheng.cindaasset;
					xieChengType="ZB";
					
				}else if("2662344410291130278".equals(accountZBId)){
					appKey=LoginXieCheng.BJappKey;// 携程提供
					appSecurity=LoginXieCheng.BJappSecurity;// 携程提供
					cindaasset=LoginXieCheng.BJcindaasset;
					xieChengType="BF";
				}if("1755267543710320898".equals(accountZBId)){
					appKey=LoginXieCheng.HBappKey;// 携程提供
					appSecurity=LoginXieCheng.HBappSecurity;// 携程提供
					cindaasset=LoginXieCheng.HBcindaasset;
					xieChengType="HB";
				}else if("-5358952287431081185".equals(accountZBId)){
					appKey=LoginXieCheng.JSappKey;// 携程提供
					appSecurity=LoginXieCheng.JSappSecurity;// 携程提供
					cindaasset=LoginXieCheng.JScindaasset;
					xieChengType="JS";
				}
				String url="http://96.21.76.24:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/RenShiToken.do";
				//String url="http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/RenShiToken.do";
				Map<String,Object> map=new HashMap<String, Object>();
				map.put("xieChengType", xieChengType);
				String responseResult = HttpClientUtil.post(url, map);
				JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);//返回
				String ticket  = jsonObject.optString("ticket");
				
				String md5Hex = DigestUtils.md5Hex(appKey+employeeID+"public"+DigestUtils.md5Hex(appSecurity));
				
				this.write(JSONUtilsExt.objects2json("success", true, "message1", "成功", "Token", ticket,"employeeID",employeeID,"appKey", appKey,"appSecurity", appSecurity,"appid", cindaasset,"signature", md5Hex), response);
			} catch (Exception e) {
				this.write(JSONUtilsExt.objects2json("success", false, "message1", "失败"), response);
				e.printStackTrace();
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
