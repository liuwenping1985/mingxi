package com.seeyon.apps.kdXdtzXc.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XiechengZsdzManager;
import com.seeyon.apps.kdXdtzXc.scheduled.XieChengDuiZhang;
import com.seeyon.apps.kdXdtzXc.util.GetUrl;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class XiechengController extends BaseController {
	
	
	private XiechengZsdzManager xiechengZsdzManager;

	public XiechengZsdzManager getXiechengZsdzManager() {
		return xiechengZsdzManager;
	}

	public void setXiechengZsdzManager(XiechengZsdzManager xiechengZsdzManager) {
		this.xiechengZsdzManager = xiechengZsdzManager;
	}

	/**
	 * 
	 * 功能: 携程单点
	 */
	@NeedlessCheckLogin
	public ModelAndView xiecheng_dandian(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/toXiechengSys");
		return mav;
	}

	/**
	 * 
	 * 功能：单点登录
	 * 其他地方在次调用toLogin接口是会出现错误
	 */
	@NeedlessCheckLogin
	public void toLogin(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		System.out.println("******进入单点******");
		//获取当前登录人账户
		User user = AppContext.getCurrentUser();
		String employeeID = user.getLoginName();//当前登录人账户名称
		// Ticket获取URL
		//String ticketUrl = "https://ct.ctrip.com/corpservice/authorize/getticket";
		String appKey = "obk_cindaAsset";// 接入账号 携程提供
		String appSecurity = "obk_cindaAsset";// 接入密码 携程提供
		int forCorp = 0;
		String signature = MD5(appKey+employeeID+forCorp/*+cost1+cost2+cost3*/+MD5(appSecurity));// MD5签名
		String url=(String)PropertiesUtils.getInstance().get("dandiandenglu");
		Map<String,Object> map =new HashMap<String, Object>();
		map.put("AppKey", appKey);
		map.put("EmployeeID", employeeID);
		map.put("Signature", signature);
		HttpClientUtil.post(url, map);
	}
	
	
	/**
	 * 获取项目信息接口
	 */
	@NeedlessCheckLogin
    public void getProjectInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String message ="";
		String journeyID = request.getParameter("journeyID");
		String loginName = request.getParameter("loginName");
		if(journeyID == null || journeyID.equals("")){
			message = "数据获取失败:journeyID为空！";
			throw new Exception("数据获取失败:journeyID为空！");
		}
		if(loginName == null || loginName.equals("")){
			message = "数据获取失败:loginName为空！";
			throw new Exception("数据获取失败:loginName为空！");
		}
		
    	try {
    		Map<String,Object> dataMap = xiechengZsdzManager.getProjectInfoByOrderId(journeyID,loginName);
    		String esbrogcode = dataMap.get("esbrogcode") == null ? "" : (dataMap.get("esbrogcode")+"");
			String esbrogname = dataMap.get("esbrogname") == null ? "" : (dataMap.get("esbrogname")+"");
			String ebsdepcode = dataMap.get("ebsdepcode") == null ? "" : (dataMap.get("ebsdepcode")+"");
			String esbdepname = dataMap.get("esbdepname") == null ? "" : (dataMap.get("esbdepname")+"");
			String oaorgcode = dataMap.get("oaorgcode") == null ? "" : (dataMap.get("oaorgcode")+"");
			String oaorgname = dataMap.get("oaorgname") == null ? "" : (dataMap.get("oaorgname")+"");
			String oaDepCode = dataMap.get("oaDepCode") == null ? "" : (dataMap.get("oaDepCode")+"");
			String oadepname = dataMap.get("oadepname") == null ? "" : (dataMap.get("oadepname")+"");
			String procode = dataMap.get("procode") == null ? "" : (dataMap.get("procode")+"");
			String proname = dataMap.get("proname") == null ? "" : (dataMap.get("proname")+"");
			String oadep2Code = dataMap.get("oadep2Code") == null ? "" : (dataMap.get("oadep2Code")+"");
			String ebsdep2Code = dataMap.get("ebsdep2Code") == null ? "" : (dataMap.get("ebsdep2Code")+"");
			String memebrCode = dataMap.get("memebrCode") == null ? "" : (dataMap.get("memebrCode")+"");
			String isDgj = dataMap.get("isDgj") == null ? "" : (dataMap.get("isDgj")+"");
			
            String info = JSONUtils.objects2json("success", true, 
            		"esbrogcode",esbrogcode,
            		"esbrogname",esbrogname,
            		"ebsdepcode",ebsdepcode,
            		"esbdepname",esbdepname,
            		"oaorgcode",oaorgcode,
            		"oaorgname",oaorgname,
            		"oaDepCode",oaDepCode,
            		"oadepname",oadepname,
            		"procode",procode,
            		"proname",proname,
            		"oadep2Code",oadep2Code,
            		"ebsdep2Code",ebsdep2Code,
            		"memebrCode",memebrCode,
            		"isDgj",isDgj,
            		message, "数据获取成功!");
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, message, "数据获取失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    protected void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }

	public static String sendPost(String url, String param) {
		OutputStreamWriter out = null;
		BufferedReader in = null;
		String result = "";
		try {
			URL realUrl = new URL(url);
			HttpURLConnection conn = null;
			conn = (HttpURLConnection) realUrl.openConnection();// 打开和URL之间的连接
			// 发送POST请求必须设置如下两行
			conn.setRequestMethod("POST"); // POST方法
			conn.setDoOutput(true);
			conn.setDoInput(true);
			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.connect();
			out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");// 获取URLConnection对象对应的输出流
			out.write(param);// 发送请求参数
			out.flush();// flush输出流的缓冲
			in = new BufferedReader(new InputStreamReader(conn.getInputStream()));// 定义BufferedReader输入流来读取URL的响应
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
				System.out.println("OK");
			}
		} catch (Exception e) {
			System.out.println("发送 POST 请求出现异常！" + e);
			e.printStackTrace();
		}
		// 使用finally块来关闭输出流、输入流
		finally {
			try {
				if (out != null) {
					out.close();
				}
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {

				ex.printStackTrace();
			}
		}
		return result;
	}

	public static String CallWebPagePost(String urlString,String pdata) {
        String result="";
        PrintWriter out = null;  
        BufferedReader in = null; 
        URL url=null;
        try {
            url = new URL(urlString);
            URLConnection connect = url.openConnection();
            connect.setRequestProperty("content-type","application/x-www-form-urlencoded;charset=utf-8");
            connect.setRequestProperty("method","POST");
            byte[] bytes= pdata.getBytes("utf-8") ;
            connect.setDoOutput(true);  
            connect.setDoInput(true);  
            
            out = new PrintWriter(connect.getOutputStream());  
            // 发送请求参数  
            out.print(pdata);
            out.flush();  
            // 定义BufferedReader输入流来读取URL的响应  
            in = new BufferedReader(new InputStreamReader(connect.getInputStream()));  
            String line;  
            while ((line = in.readLine()) != null) {  
                result +=  line;  
            }      
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return result;
    }
	
	
	// MD5加密
	public final static String MD5(String password) {
		char md5String[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
		try {
			byte[] btInput = password.getBytes();
			MessageDigest mdInst = MessageDigest.getInstance("MD5");
			mdInst.update(btInput);
			byte[] md = mdInst.digest();

			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = md5String[byte0 >>> 4 & 0xf];
				str[k++] = md5String[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			return null;
		}
	}

	// MD5加密测试
	public static void main(String[] arge) throws Exception {
		String content = "MD5加密测试";
		String password = "abc123a";
		String encryptResult = MD5(content + password);
		System.out.println("加密测试：[" + encryptResult + "]");
	}
	
	public void getAffId(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String aid = request.getParameter("aid");
		if(aid == null){
			throw new RuntimeException("申请单号缺失");
		}
		try {
			Map<String, Object> ctpAffairId = xiechengZsdzManager.getCtpAffairId(aid);
			String capp = ctpAffairId.get("capp")+"";
			String aid1 = ctpAffairId.get("aid")+"";
			String cobjectid = ctpAffairId.get("cobjectid")+"";
			String taskOpenUrl = GetUrl.getTaskOpenUrl(Integer.valueOf(capp),aid1,cobjectid);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!","aid1",aid1,"taskOpenUrl", taskOpenUrl), response);
		} catch (Exception e) {
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
			e.printStackTrace();
			 
		}
	}
}