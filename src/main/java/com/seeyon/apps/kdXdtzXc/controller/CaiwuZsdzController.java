package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.CaiwuZsdzManager;
import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.CaiwuZsdz;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.apps.kdXdtzXc.util.SoapRequest;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class CaiwuZsdzController extends BaseController {

    private static final Log LOGGER = LogFactory.getLog(CaiwuZsdzController.class);
    
    private CaiwuZsdzManager caiwuZsdzManager ;

    public CaiwuZsdzManager getCaiwuZsdzManager() {
		return caiwuZsdzManager;
	}

	public void setCaiwuZsdzManager(CaiwuZsdzManager caiwuZsdzManager) {
		this.caiwuZsdzManager = caiwuZsdzManager;
	}

	/**
     * 功能: 列表页面
     */
    @NeedlessCheckLogin
    public ModelAndView listCaiwuZsdz(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("listCaiwuZsdz");
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listCaiwuZsdz");
        return modelAndView;
    }
   /**
    * 弹出合规页面 
    * @param request
    * @param response
    * @return
    * @throws Exception
    */
    public ModelAndView listCaiwuZsdzDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("listCaiwuZsdz");
    	String parameter = request.getParameter("bigDate");
    	String zsSum = caiwuZsdzManager.getZsSum(parameter);
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listCaiwuZsdzDialog").addObject("zsSum", zsSum);
        return modelAndView;
    }
    
    public void heguiGoZS(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String parameter = request.getParameter("id");
    	String[] split = parameter.split(",");
    	if(split != null && split.length >0){
    		for (int j = 0; j < split.length; j++) {
    			Long ids=Long.valueOf(split[j]);
    			caiwuZsdzManager.updateHeguiZS(ids);
			}
    	}
    }
    
    /**
     * 功能: poi 住宿
     */
    @NeedlessCheckLogin
    public void getpoiZsAll(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	try {
    		String dateState=request.getParameter("dateS");
        	List<CaiwuZsdz> poiZs = caiwuZsdzManager.getPoiZs(dateState);
        	HSSFWorkbook workbook = new HSSFWorkbook();
        	HSSFSheet sheet = workbook.createSheet("住宿");
        	HSSFRow row = sheet.createRow(0);
        	row.createCell(0).setCellValue("申请单编号");
        	row.createCell(1).setCellValue("部门");
        	row.createCell(2).setCellValue("预住人姓名");
        	row.createCell(3).setCellValue("职务");
        	row.createCell(4).setCellValue("酒店所在城市");
        	row.createCell(5).setCellValue("酒店名称");
        	row.createCell(6).setCellValue("酒店类型");
        	row.createCell(7).setCellValue("房间类型");
        	row.createCell(8).setCellValue("预入住日期");
        	row.createCell(9).setCellValue("预离店日期");
        	row.createCell(10).setCellValue("夜间数");
        	row.createCell(11).setCellValue("单价");
        	row.createCell(12).setCellValue("费用");
        	row.createCell(13).setCellValue("费用类型");
        	row.createCell(14).setCellValue("备注");
        	row.createCell(15).setCellValue("员工行程确认");
        	row.createCell(16).setCellValue("支付确认");
        	row.createCell(17).setCellValue("合规校验");
        	row.createCell(18).setCellValue("手动合规校验");
        	row.createCell(19).setCellValue("创建时间");
        	for (int i = 1; i <= poiZs.size(); i++) {
    			row=sheet.createRow(i);
    			row.createCell(0).setCellValue(poiZs.get(i-1).getJourneyId());
    			row.createCell(1).setCellValue(poiZs.get(i-1).getDept());
    			row.createCell(2).setCellValue(poiZs.get(i-1).getClientName());
    			row.createCell(3).setCellValue(poiZs.get(i-1).getZw());
    			row.createCell(4).setCellValue(poiZs.get(i-1).getCityName());
    			row.createCell(5).setCellValue(poiZs.get(i-1).getHotelName());
    			row.createCell(6).setCellValue(poiZs.get(i-1).getHotelType());
    			row.createCell(7).setCellValue(poiZs.get(i-1).getRoomName());
    			row.createCell(8).setCellValue(poiZs.get(i-1).getStartTime());
    			row.createCell(9).setCellValue(poiZs.get(i-1).getEndTime());
    			row.createCell(10).setCellValue(poiZs.get(i-1).getQuantity());
    			row.createCell(11).setCellValue(poiZs.get(i-1).getPrice());
    			row.createCell(12).setCellValue(poiZs.get(i-1).getAmount());
    			row.createCell(13).setCellValue(poiZs.get(i-1).getFeeType());
    			row.createCell(14).setCellValue(poiZs.get(i-1).getRemarks());
    			row.createCell(15).setCellValue(poiZs.get(i-1).getYgxcQr());
    			row.createCell(16).setCellValue(poiZs.get(i-1).getZfQr());
    			row.createCell(17).setCellValue(poiZs.get(i-1).getHgjx());
    			row.createCell(18).setCellValue(poiZs.get(i-1).getsDhgjy());
    			row.createCell(19).setCellValue(poiZs.get(i-1).getCreateTime());
    		}
        	response.setContentType("application/vnd.ms-excel");
        	
    			response.setHeader("Content-Disposition", "attachment;fileName="+URLEncoder.encode("住宿对账数据.xls", "UTF-8"));
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
                caiwuZsdzManager.updateZhifu(id);
            }
            String info = JSONUtils.objects2json("success", true, "message", "修改成功!");
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "修改失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    
    /**
     * 功能: 同步住宿数据
     */
    public void syncData(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	try {
            String ids = request.getParameter("id");
            if (StringUtils.isEmpty(ids))
                throw new BusinessException("请先选择记录！");
            String[] id_ary = ids.split(",");
            for (int i = 0; i < id_ary.length; i++) {
                Long id = Long.valueOf(id_ary[i]);
                CaiwuZsdz caiwuZsdz = caiwuZsdzManager.getDataById(id);
                String journeyId = caiwuZsdz.getJourneyId();  //审批单号
                String oaLoginname = caiwuZsdz.getExtAttr1(); //oa登录名
                getXieChengJiuDian(journeyId,oaLoginname);
            }
            String info = JSONUtils.objects2json("success", true, "message", "修改成功!");
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "修改失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
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
			String setXieCheng = SoapRequest.sendSoapRequest(url,xiechengXML,"");
			System.out.println("接口返回数据"+setXieCheng);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("----------------向财务发送携程酒店结算数据结束--------------------------------");
	}
    
    protected void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }
}
