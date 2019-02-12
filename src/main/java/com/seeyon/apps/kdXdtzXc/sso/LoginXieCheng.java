package com.seeyon.apps.kdXdtzXc.sso;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;

import com.seeyon.apps.cip.api.ThirdpartyAuthenticationPortal;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class LoginXieCheng implements ThirdpartyAuthenticationPortal{
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
	public String getpageUrl(long memberId, long loginAccountId) {
		try {
			LOGGER.info("*****"+memberId+"************"+loginAccountId+"*****************");
			String employeeID = AppContext.getCurrentUser().getLoginName();
			Long accountId2 = AppContext.getCurrentUser().getAccountId();
			String accountZBId=String.valueOf(accountId2);
			String appKey = "";// 接入账号 携程提供  
			String appSecurity = "";// 接入密码 携程提供
			String cindaasset ="";
			String xieChengType="";
			
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
			String url="http://100.21.76.2:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/RenShiToken.do";
			//String url="http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/RenShiToken.do";
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("xieChengType", xieChengType);
			String responseResult = HttpClientUtil.post(url, map);
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);//返回
			String ticket  = jsonObject.optString("ticket");
			
			String md5Hex = DigestUtils.md5Hex(appKey+employeeID+"public"+DigestUtils.md5Hex(appSecurity));
			
			List arrayList = new ArrayList();
			arrayList.add(new BasicNameValuePair("employeeID",employeeID));
			arrayList.add(new BasicNameValuePair("ticket",ticket));
			arrayList.add(new BasicNameValuePair("appKey",appKey));
			arrayList.add(new BasicNameValuePair("appSecurity",appSecurity));
			arrayList.add(new BasicNameValuePair("appid",cindaasset));
			arrayList.add(new BasicNameValuePair("signature",md5Hex));
			String aa=URLEncodedUtils.format(arrayList, HTTP.UTF_8);
			return URLEncodedUtils.format(arrayList, HTTP.UTF_8);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}


	@Override
	public String registerCode() {
		// TODO Auto-generated method stub
		return "3002";
	}

}
