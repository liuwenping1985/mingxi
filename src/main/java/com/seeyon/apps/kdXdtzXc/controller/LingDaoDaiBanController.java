package com.seeyon.apps.kdXdtzXc.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.kdXdtzXc.manager.LingDaoDaiBanManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.DBAgent;

public class LingDaoDaiBanController extends BaseController {
	private LingDaoDaiBanManager lingDaoDaiBanManager;

	public LingDaoDaiBanManager getLingDaoDaiBanManager() {
		return lingDaoDaiBanManager;
	}

	public void setLingDaoDaiBanManager(LingDaoDaiBanManager lingDaoDaiBanManager) {
		this.lingDaoDaiBanManager = lingDaoDaiBanManager;
	}
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 * 领导待办
	 */
	public ModelAndView listXdtzLindao(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Map<String, Object>> listCtpAffair = lingDaoDaiBanManager.listCtpAffairmanage();
		request.setAttribute("listCtpAffair", listCtpAffair);
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/lingdaodaiban/listLingDaoDaiBan").addObject("listCtpAffair", listCtpAffair);
		return modelAndView;
	}
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 *领导待办   列表更多
	 */
	public ModelAndView listallaffair(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/lingdaodaiban/listLingDaoGenduo");
		User user = AppContext.getCurrentUser();
		modelAndView.addObject("currentLoginName", user.getLoginName());
		return modelAndView;
	}

	public ModelAndView zhuanTiImg(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/imgDaoHan");
		User user = AppContext.getCurrentUser();
		modelAndView.addObject("currentLoginName", user.getLoginName());
		return modelAndView;
	}
		//专题
	public ModelAndView listZhuangTi(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/zhuanti/listZhuangTi");
		User user = AppContext.getCurrentUser();
		modelAndView.addObject("currentLoginName", user.getLoginName());
		String parentFrId = request.getParameter("parentFrId");
		
		
		
		if(!StringUtils.isEmpty(parentFrId)){
		String hql = "from DocResourcePO where parentFrId = :parentFrId";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parentFrId", Long.valueOf(parentFrId));
		//List<String> username=new ArrayList<String>();
		List<DocResourcePO> listDocResourcePO = DBAgent.find(hql, params);
		
		modelAndView.addObject("secondFenleiData", listDocResourcePO);
		}
		return modelAndView;

	}
	
	
	/**
	 *领导已办   列表更多
	 */
	public ModelAndView listallDoneAffair(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("kdXdtzXc/lingdaodaiban/listLingDaoDoneGenduo");
		return modelAndView;
	}

}
