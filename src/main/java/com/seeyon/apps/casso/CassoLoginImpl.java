package com.seeyon.apps.casso;

import com.alibaba.fastjson.JSON;
import com.seeyon.ctp.portal.sso.SSOLoginHandshakeAbstract;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by taoan on 2017-1-21.
 */
public class CassoLoginImpl extends SSOLoginHandshakeAbstract {
    private static Log log = LogFactory.getLog(CassoLoginImpl.class);
    
    private Map<String,String> MEMBER_MAP= new HashMap<String,String>();
    
    private boolean IS_INIT = false;
    

    public String handshake(String ticket) 
    {
    	try
    	{
//    		if (!IS_INIT)
//    		{
//    			System.out.println("需要初始化map");
//    			OrgManager orgManager =  (OrgManager) AppContext.getBean("orgManager");
//   	         	List<V3xOrgMember> list = orgManager.getAllMembers(-1730833917365171641l);
//   	         	for(V3xOrgMember member : list)
//   	         	{
//   	         		if (member.getCode() !=null)
//   	         		{
//   	         			MEMBER_MAP.put(member.getCode(), member.getLoginName());
//   	         		}
//   	         	}
//   	         	IS_INIT = Boolean.TRUE;
//    		}
//	        // String nameStr = new Base64Encrypt().encodeString();
//	         System.out.println("加密后字符串:" + ticket);
//	         String code = new Base64Encrypt().decode2String(ticket);
//	         System.out.println("解密后字符串:" + code);
	         
//	         OrgManager orgManager =  (OrgManager) AppContext.getBean("orgManager");
//	         List<V3xOrgMember> list = orgManager.getAllMembers(-1730833917365171641l);
//	         V3xOrgMember member1= null;
//	         for(V3xOrgMember member : list)
//	         {
//	        	 if (member.getCode().equals("code"))
//	        	 {
//	        		 member1 = member;
//	        		 break;
//	        	 }
//	        	 
//	         }
	//        String username = CeiecPwdDecryption.getUserName(ticket);
	     //    System.out.println("sso单点登录=" + MEMBER_MAP.get(code));
			String url = "http://127.0.0.1:7080/cgi/identify?token="+ticket;
			HttpClient httpClient = new DefaultHttpClient();
			// 设置超时时间
			httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 5000);
			httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 5000);

			HttpGet httpGet = new HttpGet(url);
			HttpResponse response = null;
			try {
				response = httpClient.execute(httpGet);

			} catch (IOException e) {
				e.printStackTrace();
			}
			int statusCode = response.getStatusLine().getStatusCode();
			System.out.println("statusCode:"+statusCode);
			if(statusCode == HttpStatus.SC_OK){
				String str = EntityUtils.toString(response.getEntity(),"UTF-8");
				System.out.println("content:"+str);
				Map map = JSON.parseObject(str,HashMap.class);
				Object obj = map.get("userInfo");
				String stringDataMap = JSON.toJSONString(obj);
				Map dpMap = JSON.parseObject(stringDataMap,HashMap.class);
				String loginName =  String.valueOf(dpMap.get("account"));
				System.out.println(":::::::::::::::::::::loginName::::::::::::::::::::::::"+loginName);
				return loginName;

			}else {
				String str = EntityUtils.toString(response.getEntity(),"UTF-8");
				System.out.println("content:"+str);


			}
			//client.set
	         return null;
    	}
    	catch(Exception ex)
    	{
    		ex.printStackTrace();
    	}
    	return null;
    }


    public void logoutNotify(String ticket) {
    }

//    public static void main(String[] args) {
//        
//        System.out.println("原始字符串：" + test);
//        try {
//            String nameStr = new Base64Encrypt().encodeString(test);
//            System.out.println("加密后字符串:" + nameStr);
//            String nameStrde = new Base64Encrypt().decode2String(nameStr);
//            System.out.println("解密后字符串:" + nameStrde);
//
//            String url = "http://localhost/seeyon/login/sso?from=ceiec&ticket=" + nameStr + "&random=" + System.currentTimeMillis();
//            System.out.println(url);
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
//
//    }

}
