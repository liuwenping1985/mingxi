package com.seeyon.apps.kdXdtzXc.scheduled;

import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.exceptions.BusinessException;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * 查询补助信息
 */
public class XieChengJiPiaoZhuSu {
	private static Log log = LogFactory.getLog(XieChengJiPiaoZhuSu.class);
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
public void getXieChengAll(){
	log.info("**********进入getXieChengAll 测试携程是否可以访问");
	String jiPiao=HttpClientUtil.post("http://96.19.170.24:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do","");
	JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
	String xiechengXML  = jsonObject2.optString("xml");
	log.info("** 携程接口"+xiechengXML);
    String url="http://c3-jtcwebs1.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  

    String setXieCheng = setXieCheng(url,xiechengXML,"");
    log.info("** 携程日志"+setXieCheng);
}
	/**
	 * 功能：向携程发送机票结算数据
	 * 
	 * @throws BusinessException
	 */
	
	public void getXieChengJiPiao(String journeyID,String memberCode) throws BusinessException {
		System.out.println("----------------向财务发送携程机票结算数据开始--------------------------------");
		try {
			if(journeyID == null || journeyID.isEmpty())
				throw new Exception("journeyID 参数缺失！");
			
			if(memberCode == null || memberCode.isEmpty())
				throw new Exception("memberCode 参数缺失！");
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("journeyID", journeyID);
			map.put("memberCode", memberCode);
	    	String jiPiao = HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getJipiaoJiesuanData.do",map);
	    	JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
			String xiechengXML  = jsonObject2.optString("xml");
			String url="http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  
			String setXieCheng = setXieCheng(url,xiechengXML,"");
			System.out.println("接口返回数据"+setXieCheng);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("----------------向财务发送携程机票结算数据结束--------------------------------");
	}
	
	
	/**
	 * 功能：向携程发送酒店结算数据 
	 * @throws BusinessException
	 */
	public void getXieChengJiuDian(String journeyID,String memberCode) throws BusinessException {
		System.out.println("----------------向财务发送携程酒店结算数据开始--------------------------------");
		try {
			if(journeyID == null || journeyID.isEmpty())
				throw new Exception("journeyID 参数缺失！");
			
			if(memberCode == null || memberCode.isEmpty())
				throw new Exception("memberCode 参数缺失！");
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("journeyID", journeyID);
			map.put("memberCode", memberCode);
	    	String jiudian = HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getJiudiaoJiesuanData.do",map);
	    	JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiudian);
			String xiechengXML  = jsonObject2.optString("xml");
			String url="http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  
			String setXieCheng = setXieCheng(url,xiechengXML,"");
			System.out.println("接口返回数据"+setXieCheng);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("----------------向财务发送携程酒店结算数据结束--------------------------------");
	}
	
	
	
	//携程接口定时器方法
	public static String setXieCheng(String postUrl, String soapXml, String soapAction) {    
        String retStr = "";  
        // 创建HttpClientBuilder  
        HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();  
        // HttpClient  
        CloseableHttpClient closeableHttpClient = httpClientBuilder.build();  
        HttpPost httpPost = new HttpPost(postUrl);  
                //  设置请求和传输超时时间  
        RequestConfig requestConfig = RequestConfig.custom()  
                .setSocketTimeout(30000)  
                .setConnectTimeout(30000).build();  
        httpPost.setConfig(requestConfig);  
        try {  
            httpPost.setHeader("Content-Type", "text/xml;charset=UTF-8");  
            httpPost.setHeader("SOAPAction", soapAction);  
            StringEntity data = new StringEntity(soapXml,  
                    Charset.forName("UTF-8"));  
            httpPost.setEntity(data);  
            CloseableHttpResponse response = closeableHttpClient  
                    .execute(httpPost);  
            HttpEntity httpEntity = response.getEntity();  
            if (httpEntity != null) {  
                // 打印响应内容  
                retStr = EntityUtils.toString(httpEntity, "UTF-8");  
               System.out.println("response:" + retStr);  
            }  
            // 释放资源  
            closeableHttpClient.close();  
        } catch (Exception e) {  
           e.printStackTrace();
        }  
        return retStr;  
    }

	
}
