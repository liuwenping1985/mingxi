package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

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
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.alibaba.fastjson.JSONArray;
import com.seeyon.apps.kdXdtzXc.manager.CaiwuJtdzManager;
import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.apps.kdXdtzXc.scheduled.XieChengJiPiaoZhuSu;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.apps.kdXdtzXc.util.SoapRequest;
import com.seeyon.apps.kdXdtzXc.util.XmlConvertUtil;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class CaiwuJtdzController extends BaseController {

    private static final Log LOGGER = LogFactory.getLog(CaiwuJtdzController.class);
    private CaiwuJtdzManager caiwuJtdzManager;

    public CaiwuJtdzManager getCaiwuJtdzManager() {
		return caiwuJtdzManager;
	}

	public void setCaiwuJtdzManager(CaiwuJtdzManager caiwuJtdzManager) {
		this.caiwuJtdzManager = caiwuJtdzManager;
	}


	/**
     * 功能: 列表页面
     */
    @NeedlessCheckLogin
    public ModelAndView listCaiwuJtdz(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("listCaiwuJtdz");
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listCaiwuJtdz");
        return modelAndView;
    }
    /**
     * 功能: 合规弹出页面 
     */
    @NeedlessCheckLogin
    public ModelAndView duizhangDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String parameter = request.getParameter("bigDate");
    	String jtSum = caiwuJtdzManager.getJtSum(parameter);
    	ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/duizhangDialog").addObject("jtSum", jtSum);
        return modelAndView;
    }
    public void heguiGoJT(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String parameter = request.getParameter("id");
    	String[] split = parameter.split(",");
    	if(split != null && split.length >0){
    		for (int j = 0; j < split.length; j++) {
    			Long ids=Long.valueOf(split[j]);
        		caiwuJtdzManager.updateHeguiJT(ids);
			}
    	}
    	
    }
    
    /**
     * 功能: poi
     */
    @NeedlessCheckLogin
    public void ListPoiCaiWu(HttpServletRequest request, HttpServletResponse response){
    	try {
    		String dateState=request.getParameter("dateS");
    	List<CaiwuJtdz> poiCaiwuJtdz = caiwuJtdzManager.getPoiCaiwuJtdz(dateState);
    	HSSFWorkbook workbook = new HSSFWorkbook();
    	HSSFSheet sheet = workbook.createSheet("交通");
    	HSSFRow row = sheet.createRow(0);
    	row.createCell(0).setCellValue("申请单编号");
    	row.createCell(1).setCellValue("部门");
    	row.createCell(2).setCellValue("乘机人姓名");
    	row.createCell(3).setCellValue("职务");
    	row.createCell(4).setCellValue("起飞时间");
    	row.createCell(5).setCellValue("到达时间");
    	row.createCell(6).setCellValue("出发城市");
    	row.createCell(7).setCellValue("到达城市");
    	row.createCell(8).setCellValue("航班号");
    	row.createCell(9).setCellValue("航位");
    	row.createCell(10).setCellValue("费用");
    	row.createCell(11).setCellValue("费用类型");
    	row.createCell(12).setCellValue("备注");
    	row.createCell(13).setCellValue("员工行程确认");
    	row.createCell(14).setCellValue("支付确认");
    	row.createCell(15).setCellValue("合规校验");
    	row.createCell(16).setCellValue("手动合规校验");
    	row.createCell(17).setCellValue("创建时间");
    	for (int i = 1; i <= poiCaiwuJtdz.size(); i++) {
			row=sheet.createRow(i);
			row.createCell(0).setCellValue(poiCaiwuJtdz.get(i-1).getJourneyId());
			row.createCell(1).setCellValue(poiCaiwuJtdz.get(i-1).getDept());
			row.createCell(2).setCellValue(poiCaiwuJtdz.get(i-1).getPassengerName());
			row.createCell(3).setCellValue(poiCaiwuJtdz.get(i-1).getZw());
			row.createCell(4).setCellValue(poiCaiwuJtdz.get(i-1).getTakeoffTime());
			row.createCell(5).setCellValue(poiCaiwuJtdz.get(i-1).getArrivalTime());
			row.createCell(6).setCellValue(poiCaiwuJtdz.get(i-1).getDcityName());
			row.createCell(7).setCellValue(poiCaiwuJtdz.get(i-1).getAcityName());
			row.createCell(8).setCellValue(poiCaiwuJtdz.get(i-1).getFlight());
			row.createCell(9).setCellValue(poiCaiwuJtdz.get(i-1).getClassName());
			row.createCell(10).setCellValue(poiCaiwuJtdz.get(i-1).getAmount());
			row.createCell(11).setCellValue(poiCaiwuJtdz.get(i-1).getFeeType());
			row.createCell(12).setCellValue(poiCaiwuJtdz.get(i-1).getRemark());
			row.createCell(13).setCellValue(poiCaiwuJtdz.get(i-1).getYgxcQr());
			row.createCell(14).setCellValue(poiCaiwuJtdz.get(i-1).getZfQr());
			row.createCell(15).setCellValue(poiCaiwuJtdz.get(i-1).getHgjx());
			row.createCell(16).setCellValue(poiCaiwuJtdz.get(i-1).getsGhgjx());
			row.createCell(17).setCellValue(poiCaiwuJtdz.get(i-1).getCreateTime());
		}
    	response.setContentType("application/vnd.ms-excel");
    	
			response.setHeader("Content-Disposition", "attachment;fileName="+URLEncoder.encode("交通对账数据.xls", "UTF-8"));
			ServletOutputStream outputStream = response.getOutputStream();
			workbook.write(outputStream);
			workbook.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

    
    /**
     * 功能: 修改为支付
     */
    public void updateZhifu(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            String ids = request.getParameter("id");
            if (StringUtils.isEmpty(ids))
                throw new BusinessException("请先选择记录！");
            String[] id_ary = ids.split(",");
            for (int i = 0; i < id_ary.length; i++) {
                Long id = Long.valueOf(id_ary[i]);
                caiwuJtdzManager.updateZhifu(id);
            }
            String info = JSONUtils.objects2json("success", true, "message", "修改成功!");
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "修改失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    
    /**
     * 功能: 同步交通数据
     */
    public void syncData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
        	LOGGER.info("**********进入getXieChengAll 测试携程是否可以访问");
        	
        	User user = AppContext.getCurrentUser();
            Long account = user.getAccountId();
            String accountId = String.valueOf(account);
        	
        	//String jiPiao=HttpClientUtil.post("http://100.21.76.2:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do",accountId);
           Map<String,Object> map= new HashMap<String, Object>();
           map.put("accountId", accountId);
            String jiPiao=HttpClientUtil.post("http://96.21.76.24:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do",map);
            //String jiPiao=HttpClientUtil.post("http://100.21.76.2:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do",map);
        	JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
        	String xiechengXML  = jsonObject2.optString("xml");
        	LOGGER.info("** 携程接口"+xiechengXML);
            String url="http://zjckebs.zc.cinda.ccb/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  
            //String url="http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  

            String setXieCheng = setXieCheng(url,xiechengXML,"");
            LOGGER.info("** 携程日志"+setXieCheng);
            Map<String, String> newXmltoMap = XmlConvertUtil.newXmltoMap(setXieCheng);
    		String status="";
    		String data="";
    		if(newXmltoMap != null && newXmltoMap.size() > 0){
    			status = newXmltoMap.get("X_RETURN_STATUS");
    			data = newXmltoMap.get("X_MSG_DATA");
    		}
    		if(!"E".equals(status) && newXmltoMap != null){
          //获取系统时间作为创建时间
    		SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd");
    		String ex = format.format(new Date());
    		String createTime = format.format(new Date());
    		Calendar calendar = Calendar.getInstance();
    		calendar.add(Calendar.MONTH, -1);
    		String time = format.format(calendar.getTime());
    		String year = time.substring(0,4);
    		String month = time.substring(time.length()-5,time.length()-3);
    		caiwuJtdzManager.updateXieChengfqdzxxjt(year,month);
    		}
    		
            /* String ids = request.getParameter("id");
            if (StringUtils.isEmpty(ids))
                throw new BusinessException("请先选择记录！");
            String[] id_ary = ids.split(",");
            for (int i = 0; i < id_ary.length; i++) {
                Long id = Long.valueOf(id_ary[i]);
                CaiwuJtdz caiwuJtdz = caiwuJtdzManager.getDataById(id);
                String journeyId = caiwuJtdz.getJourneyId();  //审批单号
                String oaLoginname = caiwuJtdz.getExtAttr1(); //oa登录名
                getXieChengJiPiao(journeyId,oaLoginname);
            }*/
            String info = JSONUtils.objects2json("success", true, "message", "同步成功!","status",status,"data",data);
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "同步失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    /**
     * 功能: 获取是否同步
     */
    public void getTypeCaiWu(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
        	SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd");
        
           String getDate = request.getParameter("datas");
          //获取系统时间作为创建时间
    		Calendar calendar = Calendar.getInstance();
    		calendar.setTime(format.parse(getDate));
    		calendar.add(Calendar.MONTH, 0);
    		String time = format.format(calendar.getTime());
    		String year = time.substring(0,4);
    		String month = time.substring(time.length()-5,time.length()-3);
    		List<XiechengFqdzxxJt> xieChengfqdzxxjt = caiwuJtdzManager.getXieChengfqdzxxjt(year, month);
    		String zbcw = "";
			String bfcw = "";
			String hbcw = "";
			String jscw = "";
    		if(xieChengfqdzxxjt != null && xieChengfqdzxxjt.size() > 0){
    			 zbcw = xieChengfqdzxxjt.get(0).getZbcw();
    			 bfcw = xieChengfqdzxxjt.get(0).getBfcw();
    			 hbcw = xieChengfqdzxxjt.get(0).getHbcw();
    			 jscw = xieChengfqdzxxjt.get(0).getJscw();
    		}
           
            String info = JSONUtils.objects2json("zbcw",zbcw,"bfcw",bfcw,"hbcw",hbcw,"jscw",jscw,"success", true, "message", "同步成功!","xieChengfqdzxxjt",xieChengfqdzxxjt);
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "同步失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
  //
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


    /**
	 * 功能：向携程发送机票结算数据
	 * 
	 * @throws BusinessException
	 */
	public void getXieChengJiPiao(String journeyID,String memberCode) throws BusinessException {
		System.out.println("----------------向财务发送携程机票结算数据开始--------------------------------");
		String result = "";
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
			result = SoapRequest.sendSoapRequest(url,xiechengXML,"");
			System.out.println("接口返回数据"+result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("----------------向财务发送携程机票结算数据结束--------------------------------");
	}
	
	
	 /**
		 * 功能：向携程发送机票结算数据
		 * 
		 * @throws BusinessException
		 */
		public void getJtJsonAndJdJson(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
			String result = "";
			try {
				Long accountId2 = AppContext.getCurrentUser().getAccountId();
				String accountId = String.valueOf(accountId2);
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("accountId", accountId);
		    	String jiPiao = HttpClientUtil.post("http://96.21.76.24:8044/xiecheng/xiecheng/jpjs/flightOrderSettlementInfo/getjpJson.do",map);
		    	JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
		    	List<Map<String,Object>> jtJsonData = (List) jsonObject2.optJSONArray("list");
		    	List<Map<String,Object>> jdJsonData = (List) jsonObject2.optJSONArray("jdList");
		    	String jipiao= caiwuJtdzManager.getJsonJT(jtJsonData);
		    	String jiudian =caiwuJtdzManager.getJsonJD(jdJsonData);
		    	StringBuffer buf = new StringBuffer();
		    	buf.append("<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">\n");
		    	buf.append("<soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:mustUnderstand=\"1\"><wsse:UsernameToken xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\"><wsse:Username>xxt_soa</wsse:Username><wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">00000000</wsse:Password></wsse:UsernameToken></wsse:Security></soap:Header>\n");
		    	buf.append("<soap:Body xmlns:ns1=\"http://xmlns.oracle.com/apps/xxt/soaprovider/plsql/xxt_soa_capital_travel_pkg/process_travel_api/\">");
				
		    	buf.append("<ns1:InputParameters>");
		    	buf.append(jipiao);
		    	buf.append(jiudian);
		    	buf.append("</ns1:InputParameters>");
		    	buf.append("</soap:Body>");
		    	buf.append("</soap:Envelope>");
		    	
		    	System.out.println(buf.toString());
		    	
		    	String url="http://zjckebs.zc.cinda.ccb/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  
		    	//String url="http://c1-zjckweb1.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  

	            String setXieCheng = setXieCheng(url,buf.toString(),"");
	            LOGGER.info("** 携程日志"+setXieCheng);
	            Map<String, String> newXmltoMap = XmlConvertUtil.newXmltoMap(setXieCheng);
	    		String status="";
	    		String data="";
	    		if(newXmltoMap != null && newXmltoMap.size() > 0){
	    			status = newXmltoMap.get("X_RETURN_STATUS");
	    			data = newXmltoMap.get("X_MSG_DATA");
	    		}
	    		if("S".equals(status)){
	          //获取系统时间作为创建时间
	    		SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd");
	    		String ex = format.format(new Date());
	    		String createTime = format.format(new Date());
	    		Calendar calendar = Calendar.getInstance();
	    		calendar.add(Calendar.MONTH, -1);
	    		String time = format.format(calendar.getTime());
	    		String year = time.substring(0,4);
	    		String month = time.substring(time.length()-5,time.length()-3);
	    		
	    		Calendar cal=Calendar.getInstance();
	    		cal.setTime(new Date());
	    		int years=cal.get(Calendar.YEAR);
	    		int months=cal.get(Calendar.MONTH)+1;
	    		
	    		if(months == 12){
	    			caiwuJtdzManager.updateXieChengfqdzxxjt(String.valueOf(years),String.valueOf(months));
	    		}else{
	    			caiwuJtdzManager.updateXieChengfqdzxxjt(year,month);
	    			}
	    		}
	    		   String info = JSONUtils.objects2json("success", true, "message", "同步成功!","status",status,"data",data);
	               this.write(info, response);
		    	System.out.println(buf.toString());
			} catch (Exception e) {
				 try {
					this.write(JSONUtils.objects2json("success", false, "message", "同步失败:" + e.getMessage()), response);
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("----------------向财务发送携程  机票结算数据结束--------------------------------");
		}
    
    
    protected void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }
}
