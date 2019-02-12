package com.seeyon.apps.testsection.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.meeting.constants.MeetingPathConstant;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

public class InfoUrlController extends BaseController {
	
	private static final Log LOGGER = LogFactory.getLog(InfoUrlController.class);

	
	/**
	 * 录入信息
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView inputinfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("plugin/inputinfo");

		return mav;
	}
	
	
}