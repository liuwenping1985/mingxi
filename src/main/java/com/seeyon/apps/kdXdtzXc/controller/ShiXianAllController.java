package com.seeyon.apps.kdXdtzXc.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.ShiXianListManage;
import com.seeyon.apps.kdXdtzXc.po.HomePage;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.controller.BaseController;

public class ShiXianAllController  extends BaseController{
	private ShiXianListManage shiXianListManage;
	
	
	public ShiXianListManage getShiXianListManage() {
		return shiXianListManage;
	}


	public void setShiXianListManage(ShiXianListManage shiXianListManage) {
		this.shiXianListManage = shiXianListManage;
	}

	//待办
	public ModelAndView shiXianListAll(HttpServletRequest request, HttpServletResponse response){
		System.out.println("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		ModelAndView mav = new ModelAndView("kdXdtzXc/shiXianList/shiXianListAll");
		List<Map<String, Object>> daibanList = shiXianListManage.getAllDaiBanShiXian();
		/*List<HomePage> daiBanlist = new ArrayList<HomePage>();
		for (Map<String, Object> map : allDaiBanShiXian) {
			Long afficId = (Long) map.get("id");
			String name = (String) map.get("name");
			Integer app = (Integer) map.get("app");
			String subject = (String) map.get("subject");
			Date createDate = (Date) map.get("CREATE_DATE");
			HomePage homepage = new HomePage(afficId, name, app, subject, createDate);
			daiBanlist.add(homepage);
		}

		try {
			String url = "";
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(key, value);
			String json = HttpClientUtil.get(url, map);
			List daiBanList = JSONUtilsExt.fromJson(json, List.class);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		/*
		 * Request.Get("") .execute() .returnContent()
		 * .asString(Charset.forName("utf-8"));
		 */

		mav.addObject("daibanList", daibanList);
		return mav;
	}
	//已办
	public ModelAndView shiXianYiBanListAll(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("kdXdtzXc/shiXianList/shiXianYiBanListAll");
		List<Map<String, Object>> yiBanList = shiXianListManage.getAllYiBanShiXian();
		mav.addObject("yiBanList",yiBanList);
		return mav;
	}
	//已发
	public ModelAndView shiXianYiFaListAll(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("kdXdtzXc/shiXianList/shiXianYiFaListAll");
		List<Map<String, Object>> yiFaList = shiXianListManage.getAllYiFaShiXian();
		mav.addObject("yiFaList",yiFaList);
		return mav;
	}
	//专题图片领导信箱
	public ModelAndView linDaoXinXian(HttpServletRequest request,HttpServletResponse response){
	ModelAndView mav=new ModelAndView("kdXdtzXc/zhuanti/linDaoXinXian");
	return mav;
	}
	
}
