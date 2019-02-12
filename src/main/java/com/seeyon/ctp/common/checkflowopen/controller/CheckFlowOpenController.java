package com.seeyon.ctp.common.checkflowopen.controller;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.checkflowopen.manager.CheckFlowOpenManager;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;

public class CheckFlowOpenController extends BaseController{
	
	private CheckFlowOpenManager checkFlowOpenManager;
	
	public void setCheckFlowOpenManager(CheckFlowOpenManager checkFlowOpenManager) {
		this.checkFlowOpenManager = checkFlowOpenManager;
	}
	
	public ModelAndView checkFlowOpenUser(HttpServletRequest request,
	        HttpServletResponse response) throws Exception {
		
		response.setContentType("text/html;charset=UTF-8");
		AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
		String _affairId = request.getParameter("affairId");
		Long affairId = Long.parseLong(_affairId);
		CtpAffair affair = affairManager.get(affairId);
		
		if (affair == null || affair.getState() != StateEnum.col_pending.key()){
			return null;
		}
		
		User user = AppContext.getCurrentUser();
		String currentUserName = user.getName();
		String openUserName = this.checkFlowOpenManager.getCurrentOpenFlowUser(affairId,currentUserName);
		
		if (!openUserName.equals("")){
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('《" + affair.getSubject() + "》已被用户 "+ openUserName +" 打开。');");
			//out.print("parent.window.close();");
			out.println("</script>");
			out.flush();
		}

		return null;
	}
	

	public ModelAndView removeFlowOpenUser(HttpServletRequest request,
	        HttpServletResponse response) throws Exception {
		String _affairId = request.getParameter("affairId");
		Long affairId = Long.parseLong(_affairId);
		
		String openUser = request.getParameter("openUser");
		this.checkFlowOpenManager.removeFlowOpenUser(affairId, openUser);
		return null;
	}
}
