package com.seeyon.apps.kdXdtzXc.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.util.DBAgent;

public class BiaoDanChaXunController  extends BaseController{
	
	public ModelAndView getAllTemplate(HttpServletRequest request, HttpServletResponse response){
		String parentId = request.getParameter("patentId");
		ModelAndView mav =new ModelAndView("ctp/form/queryResult/formQueryIndex");
		Map<String,Object> map = new HashMap<String ,Object>();
		String hql ="from CtpTemplateCategory c where c.parentId= :parentId";
		map.put("parentId", Long.valueOf(parentId));
		List<CtpTemplateCategory> templatelist = DBAgent.find(hql,map);
		for (CtpTemplateCategory c : templatelist) {
			System.err.println("名字"+c.getName());
		}
		mav.addObject("templatelist",templatelist);
		
		return mav;
		
	}

}
