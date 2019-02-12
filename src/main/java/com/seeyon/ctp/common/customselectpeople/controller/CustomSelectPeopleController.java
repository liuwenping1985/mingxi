package com.seeyon.ctp.common.customselectpeople.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.customselectpeople.Manager.CustomSelectPeopleManager;
import com.seeyon.ctp.common.customselectpeople.dao.CustomSelectPeopleDao;
import com.seeyon.ctp.common.customselectpeople.po.CustomSelectPeoplePO;

public class CustomSelectPeopleController extends BaseController{
	
	private CustomSelectPeopleManager customSelectPeopleManager;
	
	public void setCustomSelectPeopleManager(CustomSelectPeopleManager customSelectPeopleManager) {
		this.customSelectPeopleManager = customSelectPeopleManager;
	}
	
	public ModelAndView showLeader(HttpServletRequest request,
	        HttpServletResponse response){
		
		ModelAndView mav = new ModelAndView("plugin/customselectpeople/customSelectPeople");
		
		List<CustomSelectPeoplePO> objLst = customSelectPeopleManager.getEnumItemByEnumId();
		mav.addObject("leaderlist", objLst);
		return mav;
	}
	

}
