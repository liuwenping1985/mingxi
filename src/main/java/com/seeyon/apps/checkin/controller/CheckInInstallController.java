package com.seeyon.apps.checkin.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.v3x.common.dao.paginate.Pagination;
import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.domain.NoCheckinDepart;
import com.seeyon.apps.checkin.domain.NoCheckinUser;
import com.seeyon.apps.checkin.manager.CheckInInstallManager;
import com.seeyon.ctp.common.controller.BaseController;

public class CheckInInstallController extends BaseController {
	
	private CheckInInstallManager checkInInstallManager;
	
	public CheckInInstallManager getCheckInInstallManager() {
		return checkInInstallManager;
	}
	
	public void setCheckInInstallManager(CheckInInstallManager checkInInstallManager) {
		this.checkInInstallManager = checkInInstallManager;
	}

	/**
	 * 查询考勤设置内容
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getInstall(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("考勤设置画面=====================================");
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/install");
		CheckInInstall install = checkInInstallManager.searchCheckinSet();
		modelAndView.addObject("install", install);
		return modelAndView;
	}

	/**
	 * 保存考勤设置
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveCheckInInstall(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String delflg = request.getParameter("delflg");
		if(delflg.equals("1")){
			getInstall(request,response);
		}
		
		CheckInInstall  inInstall = new CheckInInstall();
		// 上午打卡开始时间
		String amStartTimere = request.getParameter("amStartTime");
		inInstall.setAmStartTime(amStartTimere);
		// 上午打卡结束时间
		String amEndTimere = request.getParameter("amEndTime");
		inInstall.setAmEndTime(amEndTimere);
		// 下午打卡开始时间
		String pmStartTimere = request.getParameter("pmStartTime");
		inInstall.setPmStartTime(pmStartTimere);
		// 下午打卡结束时间
		String pmEndTimere = request.getParameter("pmEndTime");
		inInstall.setPmEndTime(pmEndTimere);
		// 异常处理时间
		String errorTimere = request.getParameter("errorTime");
		inInstall.setErrorTime(errorTimere);
		// 流程发起时间
		String processStartTimere = request.getParameter("processStartTime");
		inInstall.setProcessStartTime(processStartTimere);
		// 流程审批时间
		String approvalTimere = request.getParameter("approvalTime");
		inInstall.setApprovalTime(approvalTimere);
		// 不打卡部门id
		String newDepartId = request.getParameter("notCheckInDepartmentId");
		inInstall.setNotCheckInDepartmentId(newDepartId);
		// 不打卡部门名称
		String notCheckInDepartmentre = request.getParameter("notCheckInDepartment");
		inInstall.setNotCheckInDepartment(notCheckInDepartmentre);
		// 不打卡人员姓名
		String notCheckInPersonre = request.getParameter("notCheckInPerson");
		inInstall.setNotCheckInPerson(notCheckInPersonre);
		// 不打卡人员id
		String newPersonId = request.getParameter("notCheckInPersonId");
		inInstall.setNotCheckInPersonId(newPersonId);
		
		
				// nostatic打卡部门id
				String deptId = request.getParameter("notStaticCheckInDepartmentId");
				inInstall.setNotStaticCheckInDepartmentId(deptId);
				// nostatic打卡部门名称
				String notStaticCheckInDept = request.getParameter("notStaticCheckInDepartment");
				inInstall.setNotStaticCheckInDepartment(notStaticCheckInDept);
				// nostatic打卡人员姓名
				String notStaticCheckInPerson = request.getParameter("notStaticCheckInPerson");
				inInstall.setNotStaticCheckInPerson(notStaticCheckInPerson);
				// nostatic打卡人员id
				String personId = request.getParameter("notStaticCheckInPersonId");
				inInstall.setNotStaticCheckInPersonId(personId);
		
		checkInInstallManager.saveUpdateCheckinSet(inInstall);
		return getInstall(request, response);
	}
	
	/**
	 * 查询不打卡人	
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectUser(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView modelAndView = new ModelAndView("plugin/checkin/nocheckindelete");
		List<NoCheckinUser> ulist = checkInInstallManager.searchNoCheckinUsers();
		modelAndView.addObject("ulist", pagenate(ulist));
		return modelAndView;
	}

	/**
	 * 删除不打卡人	
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView delectUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uids = request.getParameter("uids");
		checkInInstallManager.deleteNoCheckinUsers(uids);
		response.setContentType("text/html; charset=UTF-8");
		response.getWriter().print("删除成功！");
		return null;
	}
	
	/**
	 * 查询不打卡部门	
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectDepart(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/nocheckindeletedepart");
		List<NoCheckinDepart> dlist = checkInInstallManager.searchNoCheckinDepartments();
		modelAndView.addObject("dlist", pagenate(dlist));
		return modelAndView;
	}
	
	/**
	 * 删除不打卡部门	
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView delectDepart(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String dids = request.getParameter("dids");
		checkInInstallManager.deleteNoCheckinDepartments(dids);
		response.setContentType("text/html; charset=UTF-8");
		response.getWriter().print("删除成功！");
		return null;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private <T> List<T> pagenate(List<T> list){
		if ((null == list) || (list.size() == 0)){
			return new ArrayList();
		}
		Integer first = Integer.valueOf(Pagination.getFirstResult());
		Integer pageSize = Integer.valueOf(Pagination.getMaxResults());
		Pagination.setRowCount(list.size());
		List subList = null;
		if (first.intValue() + pageSize.intValue() > list.size())
		  subList = list.subList(first.intValue(), list.size());
		else
		  subList = list.subList(first.intValue(), first.intValue() + pageSize.intValue());

		return subList;
	  }
}
