package com.seeyon.apps.kdXdtzXc.scheduled;

import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
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

import com.seeyon.apps.kdXdtzXc.manager.GeRenZhiFuXinXi;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.ctp.common.exceptions.BusinessException;

/**
 * 查询补助信息
 */
public class FeiXieChengQuartz {
	private static Log log = LogFactory.getLog(FeiXieChengQuartz.class);
private static GeRenZhiFuXinXi geRenZhiFuXinXi;
	
	public GeRenZhiFuXinXi getGeRenZhiFuXinXi() {
		return geRenZhiFuXinXi;
	}

	public void setGeRenZhiFuXinXi(GeRenZhiFuXinXi geRenZhiFuXinXi) {
		this.geRenZhiFuXinXi = geRenZhiFuXinXi;
	}

	/**
	 * 功能：非携程信息接口定时器
	 * 
	 * @throws BusinessException
	 */
	public void setFeiXieChenImpl() throws BusinessException {
		System.out.println("----------------通过定时器向财务发送非携程数据开始--------------------------------");
		try {
			System.out.println("进入 getCaiWu 数据接口");
			String getDayDate = (String) PropertiesUtils.getInstance().get("dayDate");
			int dayDate= 5;
			if(!StringUtils.isEmpty(getDayDate)){
				dayDate=Integer.valueOf(getDayDate);
			}
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			
			Calendar instance = Calendar.getInstance();
			instance.setTime(new Date());
			int day = instance.get(Calendar.DAY_OF_MONTH);
			if(day <= dayDate){
				log.info("财务系统正在合账，1-"+dayDate+"号数据统一在"+(dayDate+1)+"号全部推送");
			}else{
			List<Map<String, Object>> feiXieChen = geRenZhiFuXinXi.getFeiXcXmlTou();
			 log.info("非携程feiXieChen"+feiXieChen.size());
			if(feiXieChen != null && feiXieChen.size() > 0){
			for (Map<String, Object> map : feiXieChen) {
			String application_number = map.get("application_number")+"";
			String cheChuan = geRenZhiFuXinXi.getCheChuan(application_number);
			String zhusu = geRenZhiFuXinXi.getZhusu(application_number);
			//优化使用  StringBuffer s=new StringBuffer();
			String  salf_pay=map.get("salf_pay")+"";
			if("null".equals(map.get("salf_pay")+"") || StringUtils.isEmpty(map.get("salf_pay")+"")){
				salf_pay="0.00";
			}
			String runxml="<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">\n" +
			                "    <soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:mustUnderstand=\"1\"><wsse:UsernameToken xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\"><wsse:Username>xxt_soa</wsse:Username><wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">00000000</wsse:Password></wsse:UsernameToken></wsse:Security></soap:Header>\n" +
			                "    <soap:Body xmlns:ns1=\"http://xmlns.oracle.com/apps/xxt/soaprovider/plsql/xxt_soa_capital_personal_pkg/process_personal_api/\">\n" +
			                "        <ns1:InputParameters>";
				runxml+=" <ns1:P_TBL_PERSONAL_INFO>\n" +
		            "                <ns1:P_TBL_PERSONAL_INFO_ITEM>\n" +
		            "                    <ns1:BATCH_ID></ns1:BATCH_ID>\n" +
		            "                    <ns1:PROCESS_STATUS></ns1:PROCESS_STATUS>\n" +
		            "                    <ns1:ERROR_MSG></ns1:ERROR_MSG>\n" +
		            "                    <ns1:SOURCE_CODE>OA_FXC</ns1:SOURCE_CODE>\n" +
		            "                    <ns1:SOURCE_NAME>OA非携程</ns1:SOURCE_NAME>\n" +
		            "                    <ns1:DATA_DATE>"+sdf.format(new Date())+"</ns1:DATA_DATE>\n" +
		            "                    <ns1:TOGL_DATE>"+sdf.format(new Date())+"</ns1:TOGL_DATE>\n" +
		            "                    <ns1:INVOICE_NUMBER></ns1:INVOICE_NUMBER>\n" +
		            "                    <ns1:APPLICATION_NUMBER>"+map.get("application_number")+"</ns1:APPLICATION_NUMBER>\n" + //申请单号
		            "                    <ns1:APPL_USER_CODE>"+map.get("appl_user_code")+"</ns1:APPL_USER_CODE>\n" +   	//申请人编号
		            "                    <ns1:APPL_USER_NAME>"+map.get("appl_user_name")+"</ns1:APPL_USER_NAME>\n" +   	//申请人姓名
		            "                    <ns1:COM_CODE>"+map.get("com_code")+"</ns1:COM_CODE>\n" +			  			//机构编码
		            "                    <ns1:COM_DESC>"+map.get("com_desc")+"</ns1:COM_DESC>\n" +                  	    //机构名称
		            "                    <ns1:DEPT_CODE>"+map.get("dept_code")+"</ns1:DEPT_CODE>\n" +		  			//受益部门编码
		            "                    <ns1:DEPT_DESC>"+map.get("dept_desc")+"</ns1:DEPT_DESC>\n" +				  	//受益部门名称
		            "                    <ns1:COST_CENTER>"+map.get("cost_center")+"</ns1:COST_CENTER>\n" +   			//成本中心编码 
		            "                    <ns1:COST_CENTER_DESC>"+map.get("cost_center_desc")+"</ns1:COST_CENTER_DESC>\n" + //成本中心名称
		            "                    <ns1:PROJECT_CODE>"+map.get("project_code")+"</ns1:PROJECT_CODE>\n" +     		//项目编码
		            "                    <ns1:PROJECT_DESC>"+map.get("project_desc")+"</ns1:PROJECT_DESC>\n" +           //项目名称
		            "                    <ns1:DS_FLAG>"+map.get("ds_flag")+"</ns1:DS_FLAG>\n" +					  		//董监事标识
		            "                    <ns1:BUSINESS_TRIP_SITE></ns1:BUSINESS_TRIP_SITE>\n" + 						//出差地区类型
		            "                    <ns1:CURRENCY_CODE>CNY</ns1:CURRENCY_CODE>\n" +      							//币种
		            "                    <ns1:ATTACHMENT_NUM>"+map.get("attachmentNum")+"</ns1:ATTACHMENT_NUM>\n" +     //附件张数
		            "                    <ns1:SALF_PAY>"+salf_pay+"</ns1:SALF_PAY>\n" +
		            "                    <ns1:DESCRIPTION>"+map.get("description")+"报销差旅费</ns1:DESCRIPTION>\n" +
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
		            "                    <ns1:URL_LINE>\n" +
		            "                        <ns1:URL_LINE_ITEM>\n" +
		            "                            <ns1:SEQ_NUM>1</ns1:SEQ_NUM>\n" +
		            "                            <ns1:TITLE>TITLE"+map.get("application_number")+"</ns1:TITLE>\n" +
		            "                            <ns1:DOCUMENT_DESCRIPTION>4</ns1:DOCUMENT_DESCRIPTION>\n" +
		            "                            <ns1:URL>http://80.0.36.3:7001/itms_sme_xinda/systemfile.json?filePath=d8f34187-4533-4a8a-bfe3-757cd45e3a0f</ns1:URL>\n" +
		            "                        </ns1:URL_LINE_ITEM>\n" +
		            "                    </ns1:URL_LINE>\n" +
		            "                </ns1:P_TBL_PERSONAL_INFO_ITEM>\n" +
		            "            </ns1:P_TBL_PERSONAL_INFO>";
			  runxml+="<ns1:P_TBL_EXPENSE_LINES>";
	          runxml += cheChuan;
	          runxml += zhusu;
	          runxml+="</ns1:P_TBL_EXPENSE_LINES>";
	          runxml+=  "</ns1:InputParameters>\n" +
	        		  "</soap:Body>\n" +
	        		  "</soap:Envelope>";
	          log.info("非携程"+runxml);
	         // String url="http://zjckebs.zc.cinda.ccb/webservices/SOAProvider/plsql/xxt_soa_capital_personal_pkg/?wsdl";
	          
	          String url = (String) PropertiesUtils.getInstance().get("zBFXCurl");
	          // String url="http://c3-jtcwebs1.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_personal_pkg/?wsdl";
	          String setFeiXieChengxml = setFeiXieCheng(url,runxml,"");
	          log.info("非携程接口返回数据"+setFeiXieChengxml);
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("----------------通过定时器向财务发送非携程数据开始--------------------------------");
	}
	//携程接口定时器方法
	public static String setFeiXieCheng(String postUrl, String soapXml,  
            String soapAction) {  
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
