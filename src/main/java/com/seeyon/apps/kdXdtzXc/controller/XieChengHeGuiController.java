package com.seeyon.apps.kdXdtzXc.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XieChengHeGuiManager;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class XieChengHeGuiController  extends BaseController{
	private XieChengHeGuiManager xieChengHeGuiManager;
	
	  public XieChengHeGuiManager getXieChengHeGuiManager() {
		return xieChengHeGuiManager;
	}
	public void setXieChengHeGuiManager(XieChengHeGuiManager xieChengHeGuiManager) {
		this.xieChengHeGuiManager = xieChengHeGuiManager;
	}
	/**
     * 功能: 携程合规校验页面
     */
    @NeedlessCheckLogin
    public ModelAndView xieChengHeGuiJsp(HttpServletRequest request, HttpServletResponse response){
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengHeGui");
        return modelAndView;
    }
    /**
     * 功能: 携程合规校验会员酒店  
     */
    @NeedlessCheckLogin
    public ModelAndView xieChengHeGuiDongShi(HttpServletRequest request, HttpServletResponse response){
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengDongShi");
        return modelAndView;
    }
    /**
     * 不同的类别显示不同的数据
     * @param request
     * @param response
     */
    @NeedlessCheckLogin
    public void xieChengVipJiuDianDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
			String typeVip = request.getParameter("type");
			List<Map<String, Object>> dgjVipJiuDian = xieChengHeGuiManager.getDgjVipJiuDian(typeVip);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!","dgjVipJiuDian",dgjVipJiuDian), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       
    }
    /**
     * dgj调出添加页面
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView addVipJiuDianDgjJsp(HttpServletRequest request, HttpServletResponse response){
    		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengInsertVip");
    		 return modelAndView;
    }
    /**
     * 添加方法
     * @param request
     * @param response
     */
    public void addVipJiuDianDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
    		SimpleDateFormat foemat = new SimpleDateFormat("yyyy-MM-dd");
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(jsonStr);
			String carName = (String) jsonObject.get("carName");
			JSONArray jsonArray = jsonObject.getJSONArray("room");
			String roomtype = (String) jsonObject.get("roomtype");
			JSONArray bigDate = jsonObject.getJSONArray("bigDate");
			JSONArray endDate = jsonObject.getJSONArray("endDate");
			String type = (String) jsonObject.get("type");
			SimpleDateFormat foemat2 = new SimpleDateFormat("MM-dd");
			Map<String,String>map=new HashMap<String, String>();
			if(jsonArray != null && jsonArray.size() >0){
			for (int i = 0; i < jsonArray.size(); i++) {
				
				String room=(String)jsonArray.get(i);
				String bigDateo = (String)bigDate.get(i);
				String endDateo = (String)endDate.get(i);
				if(!StringUtils.isEmpty(room) && !StringUtils.isEmpty(bigDateo) && !StringUtils.isEmpty(endDateo)){
				/*Date bigDated = foemat.parse(bigDateo);
				Date endDated = foemat.parse(endDateo);
				String bigDates = foemat2.format(bigDated);
				String endDates = foemat2.format(endDated);*/
				
				map.put("carName",carName);
				map.put("room", room);
				map.put("roomtype",roomtype);
				map.put("bigDate",bigDateo);
				map.put("endDate",endDateo);
				map.put("type",type);
				xieChengHeGuiManager.InsertHeGui(map);
					}
				}
			}
			//carName=carName == "" ? "" : carName;
			
		
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    @NeedlessCheckLogin
    //根据id更新
    public ModelAndView updateVipJiuDianDgjJsp(HttpServletRequest request, HttpServletResponse response){
    	String id=request.getParameter("id");
    	List<Map<String, Object>> vipJiuDianId = xieChengHeGuiManager.getVipJiuDianId(id);
    		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengupdatetVip");
    		modelAndView.addObject("vipJiuDianId",vipJiuDianId);
    		 return modelAndView;
    }
    @NeedlessCheckLogin
    //根据id更新
    public void updateVipJiuDianDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
    		SimpleDateFormat foemat = new SimpleDateFormat("MM-dd");
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(jsonStr);
			String carName = (String) jsonObject.get("carName");
			String room = (String) jsonObject.get("room");
			String roomtype = (String) jsonObject.get("roomtype");
			String bigDate = (String) jsonObject.get("bigDate");
			String endDate = (String) jsonObject.get("endDate");
			/*if(!StringUtils.isEmpty(bigDate) && bigDate.length() >5){
				bigDate=bigDate.substring(bigDate.indexOf("-")+1);
			}
			String endDate = (String) jsonObject.get("endDate");
			if(!StringUtils.isEmpty(endDate) && endDate.length() >5){
				endDate=endDate.substring(endDate.indexOf("-")+1);
			}*/
			String type = (String) jsonObject.get("type");
			String id = (String) jsonObject.get("id");
			
			/*Date bigDate1 = foemat.parse(bigDate);
			Date endDate1 = foemat.parse(endDate);
			SimpleDateFormat foemat2 = new SimpleDateFormat("MM-dd");
			bigDate = foemat2.format(bigDate1);
			endDate = foemat2.format(endDate1);*/
			
			Map<String,String>map=new HashMap<String, String>();
			//carName=carName == "" ? "" : carName;
			map.put("id",id);
			map.put("carName",carName);
			map.put("room", room);
			map.put("roomtype",roomtype);
			map.put("bigDate",bigDate);
			map.put("endDate",endDate);
			map.put("type",type);
			xieChengHeGuiManager.getUpdateVipJiuDianId(map);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
  public void deleteVip(HttpServletRequest request, HttpServletResponse response){
	  try {
		String parameter = request.getParameter("id");
		  String[] ids = parameter.split(",");
		  if(ids != null && ids.length >0){
			  for (int j = 0; j < ids.length; j++) {
				  xieChengHeGuiManager.deleteVipJiuDianId(ids[j]);
			}
		  }
		  this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
	} catch (Exception e) {
		this.write(JSONUtilsExt.objects2json("success", true, "message", "操作失败!"), response);
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
  }
    /**---------------------------------------------------------
     * 功能: 携程合规校验协议酒店
     */
    @NeedlessCheckLogin
    public ModelAndView xieChengHeGuiXieYi(HttpServletRequest request, HttpServletResponse response){
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengXieYi");
        return modelAndView;
    }
    /**
     * 协议调出添加页面
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView addXIEYiJiuDianDgjJsp(HttpServletRequest request, HttpServletResponse response){
    		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengInsertxieyi");
    		 return modelAndView;
    }
    /**
     * 不同的类别显示不同的数据协议酒店
     * @param request
     * @param response
     */
    @NeedlessCheckLogin
    public void xieChengXieYiJiuDian(HttpServletRequest request, HttpServletResponse response){
    	try {
			String typeVip = request.getParameter("type");
			List<Map<String, Object>> dgjVipJiuDian = xieChengHeGuiManager.getXieYiJiuDian(typeVip);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!","dgjVipJiuDian",dgjVipJiuDian), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       
    }
    
    
    /**
     * 添加方法协议
     * @param request
     * @param response
     */
    public void addXieYiJiuDianDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
    		SimpleDateFormat foemat = new SimpleDateFormat("yyyy-MM-dd");
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(jsonStr);
			String carName = (String) jsonObject.get("carName");
			JSONArray jsonArray = jsonObject.getJSONArray("room");
			String roomtype = (String) jsonObject.get("roomtype");
			JSONArray bigDate = jsonObject.getJSONArray("bigDate");
			JSONArray endDate = jsonObject.getJSONArray("endDate");
			
			String type = (String) jsonObject.get("type");
			String jiudianmingcheng = (String) jsonObject.get("jiudianmingcheng");
			SimpleDateFormat foemat2 = new SimpleDateFormat("MM-dd");
			Map<String,String>map=new HashMap<String, String>();
			
			if(jsonArray != null && jsonArray.size() >0){
				for (int i = 0; i < jsonArray.size(); i++) {
					String room=(String)jsonArray.get(i);
					String bigDateo = (String)bigDate.get(i);
					String endDateo = (String)endDate.get(i);
					if(!StringUtils.isEmpty(room) && !StringUtils.isEmpty(bigDateo) && !StringUtils.isEmpty(endDateo)){
					/*Date bigDated = foemat.parse(bigDateo);
					Date endDated = foemat.parse(endDateo);
					String bigDates = foemat2.format(bigDated);
					String endDates = foemat2.format(endDated);*/
					//carName=carName == "" ? "" : carName;
					map.put("carName",carName);
					map.put("room", room);
					map.put("roomtype",roomtype);
					map.put("bigDate",bigDateo);
					map.put("endDate",endDateo);
					map.put("type",type);
					map.put("jiudianmingcheng",jiudianmingcheng);
					xieChengHeGuiManager.InsertXieYiHeGui(map);
						}
					}
				}
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    @NeedlessCheckLogin
    //根据id更新 协议
    public ModelAndView updateXieYiJiuDianDgjJsp(HttpServletRequest request, HttpServletResponse response){
    	String id=request.getParameter("id");
    	List<Map<String, Object>> vipJiuDianId = xieChengHeGuiManager.getXieYiDianId(id);
    		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengupdatetXieyi");
    		modelAndView.addObject("vipJiuDianId",vipJiuDianId);
    		 return modelAndView;
    }
    @NeedlessCheckLogin
    //根据id更新 协议
    public void updateXieYiJiuDianDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
    		SimpleDateFormat foemat = new SimpleDateFormat("MM-dd");
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(jsonStr);
			String carName = (String) jsonObject.get("carName");
			String room = (String) jsonObject.get("room");
			String roomtype = (String) jsonObject.get("roomtype");
			String bigDate = (String) jsonObject.get("bigDate");
			String endDate = (String) jsonObject.get("endDate");
			/*if(!StringUtils.isEmpty(bigDate) && bigDate.length() >5){
				bigDate=bigDate.substring(bigDate.indexOf("-")+1);
			}
			String endDate = (String) jsonObject.get("endDate");
			if(!StringUtils.isEmpty(endDate) && endDate.length() >5){
				endDate=endDate.substring(endDate.indexOf("-")+1);
			}*/
			String type = (String) jsonObject.get("type");
			String id = (String) jsonObject.get("id");
			/*Date bigDate1 = foemat.parse(bigDate);
			Date endDate1 = foemat.parse(endDate);
			SimpleDateFormat foemat2 = new SimpleDateFormat("MM-dd");
			bigDate = foemat2.format(bigDate1);
			endDate = foemat2.format(endDate1);*/
			String jiudianmingcheng = (String) jsonObject.get("jiudianmingcheng");
			Map<String,String>map=new HashMap<String, String>();
			//carName=carName == "" ? "" : carName;
			map.put("id",id);
			map.put("carName",carName);
			map.put("room", room);
			map.put("roomtype",roomtype);
			map.put("bigDate",bigDate);
			map.put("endDate",endDate);
			map.put("type",type);
			map.put("jiudianmingcheng",jiudianmingcheng);
			xieChengHeGuiManager.getUpdateXieYiJiuDianId(map);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    public void deleteXieYi(HttpServletRequest request, HttpServletResponse response){
    	String parameter = request.getParameter("id");
		  String[] ids = parameter.split(",");
		  if(ids != null && ids.length >0){
			  for (int j = 0; j < ids.length; j++) {
					xieChengHeGuiManager.deleteXieYiJiuDianId(ids[j]);
			}
		  }
    	}
    /**---------------------------------------------------------------
     * 功能: 携程合规校验协议交通
     */
    @NeedlessCheckLogin
    public ModelAndView xieChengHeGuiJiaoTong(HttpServletRequest request, HttpServletResponse response){
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengJiaoTon");
        return modelAndView;
    }
    /**
     * 交通调出添加页面
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView addJiaoTongDgjJsp(HttpServletRequest request, HttpServletResponse response){
    		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengInsertJiaoTong");
    		 return modelAndView;
    }
    /**
     * 不同的类别显示不同的数交通
     * @param request
     * @param response
     */
    @NeedlessCheckLogin
    public void xieChengJiaoTong(HttpServletRequest request, HttpServletResponse response){
    	try {
			String typeVip = request.getParameter("type");
			List<Map<String, Object>> dgjVipJiuDian = xieChengHeGuiManager.getJiaoTong(typeVip);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!","dgjVipJiuDian",dgjVipJiuDian), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       
    }
    
    
    /**
     * 添加方法交通
     * @param request
     * @param response
     */
    public void addJiaoTongDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(jsonStr);
			String position = (String) jsonObject.get("position");
			String type = (String) jsonObject.get("type");
			
			Map<String,String>map=new HashMap<String, String>();
			//carName=carName == "" ? "" : carName;
			map.put("position",position);
			map.put("type",type);
			xieChengHeGuiManager.InsertJiaoTong(map);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    @NeedlessCheckLogin
    //根据id更新 交通
    public ModelAndView updateJiaoTongDgjJsp(HttpServletRequest request, HttpServletResponse response){
    	String id=request.getParameter("id");
    	List<Map<String, Object>> vipJiuDianId = xieChengHeGuiManager.getJiaoTongId(id);
    		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/xiechengupdatetJiaoTong");
    		modelAndView.addObject("vipJiuDianId",vipJiuDianId);
    		 return modelAndView;
    }
    @NeedlessCheckLogin
    //根据id更新 交通
    public void updateJiaoTongDgj(HttpServletRequest request, HttpServletResponse response){
    	try {
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(jsonStr);
			String position = (String) jsonObject.get("position");
			String type = (String) jsonObject.get("type");
			String id = (String) jsonObject.get("id");
			String jiudianmingcheng = (String) jsonObject.get("jiudianmingcheng");
			Map<String,String>map=new HashMap<String, String>();
			//carName=carName == "" ? "" : carName;
			map.put("id",id);
			map.put("position",position);
			map.put("type",type);
			map.put("jiudianmingcheng",jiudianmingcheng);
			xieChengHeGuiManager.getUpdateJiaoTongId(map);
			this.write(JSONUtilsExt.objects2json("success", true, "message", "操作成功!"), response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    public void deleteJiaoTong(HttpServletRequest request, HttpServletResponse response){
    	String parameter = request.getParameter("id");
		  String[] ids = parameter.split(",");
		  if(ids != null && ids.length >0){
			  for (int j = 0; j < ids.length; j++) {
				  xieChengHeGuiManager.deleteJiaoTongId(ids[j]);
			}
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
