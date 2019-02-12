package com.seeyon.apps.checkin.controller;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.checkin.domain.Department;
import com.seeyon.apps.checkin.domain.ManagerDetail;
import com.seeyon.apps.checkin.domain.PostionLevel;
import com.seeyon.apps.checkin.domain.depCheckIn;
import com.seeyon.apps.checkin.manager.depCheckInManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.v3x.common.dao.paginate.Pagination;
/**
 * @author 
 *
 */
public class depCheckInController extends BaseController {
	
	private depCheckInManager manger;
	
	public depCheckInManager getManger() {
		return manger;
	}

	public void setManger(depCheckInManager manger) {
		this.manger = manger;
	}
	/**
	 * 考勤管理
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView checkInMangeList(HttpServletRequest request,HttpServletResponse response) throws Exception {
		System.out.println("考勤管理画面=====================================");
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/checkinMange");
		//查询表单
		String stime = request.getParameter("stime"); //开始时间
		String etime = request.getParameter("etime"); //结束时间
		String name = request.getParameter("name");  //姓名
		String gender = request.getParameter("gender"); //性别
		String usercode = request.getParameter("usercode"); //员工编号
		String positionlevel = request.getParameter("positionlevel"); //职务级别
		String department = request.getParameter("department");  //部门
		String cdepartment = request.getParameter("cdepartment"); //二级部门
		
		request.getSession().setAttribute("stime", stime);
		request.getSession().setAttribute("etime", etime);
		
		List<depCheckIn> depcheckIn = this.manger.getdepCheckInManage(stime, etime, name,gender,usercode,positionlevel,department,cdepartment);
		request.setAttribute("stime", stime);
		request.setAttribute("etime",etime );
		request.setAttribute("name", name);
		request.setAttribute("gender", gender);
		request.setAttribute("usercode", usercode);
		request.setAttribute("positionlevel", positionlevel);
		request.setAttribute("department", department);
		request.setAttribute("cdepartment", cdepartment);
		
		modelAndView.addObject("depcheckIn", pagenate(depcheckIn));
		request.getSession().setAttribute("depcheckInList",depcheckIn);
		
		List<PostionLevel>  levellist = this.manger.getlevels();
		request.setAttribute("levellist", levellist);
		
		List<Department> dmplist = this.manger.getDeparts();
		if (dmplist != null) {
			System.out.println("查询出来的部门数量：" + dmplist.size());
		}
		request.setAttribute("dmplist", dmplist);
		
		List<Department> childdmplist =this.manger.getchilddeparts();
		if(childdmplist!=null) {
			System.out.println("查询出来的子部门数量：" + childdmplist.size());
		}
		Department childdpm = new Department();
		String str="";
		if(childdmplist!=null) {
			for(int j=0;j<childdmplist.size();j++){
				 childdpm = childdmplist.get(j);
			 	String childdpmname = childdpm.getDmname();
			 	String cpath = childdpm.getPath();
			 	str = str+cpath+","+childdpmname+";";
			 }
		}
		System.out.println("childdmplist:" + str);
		request.setAttribute("childdmplist", str);
		return modelAndView;
	}
	
	/**
	 * 查询相应的子部门
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectChildDeparts(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/checkinMange");
		String fpath = request.getParameter("fpath");
		PrintWriter writer = response.getWriter();
		writer.print("</select>");
		writer.close();
		return modelAndView;
	}
	
	/**
	 * 获取迟到或早退的详细列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getlatedetails(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView  andView = new ModelAndView("plugin/checkin/managerdetail");
		String stime = request.getParameter("stime1"); //开始时间
		String etime = request.getParameter("etime1"); //结束时间
		stime = null == stime ? "":stime;
		etime = null == etime ? "":etime;
		String userid = request.getParameter("userid");
		List<ManagerDetail> latedetailslist = this.manger.getlateDetails(stime,etime,userid);
		andView.addObject("detailslist", pagenate(latedetailslist));
		return andView;
	}

	/**
	 * 异常明细查询
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getbugdetails(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView  andView = new ModelAndView("plugin/checkin/managerdetail");
		String userid = request.getParameter("userid");
		String startdate = request.getParameter("stime1");
		String enddate = request.getParameter("etime1");
		startdate = null == startdate ? "":startdate;
		enddate = null == enddate ? "":enddate;
		List<ManagerDetail> bugdetailslist =this.manger.getbugdetails(startdate,enddate,userid);
		andView.addObject("detailslist", pagenate(bugdetailslist));
		return andView;
	}

	/**
	 * 请假信息明细查询
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getleavedetails(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView  andView = new ModelAndView("plugin/checkin/managerdetail");
		String startdate = request.getParameter("stime1");
		String enddate = request.getParameter("etime1");
		startdate = null == startdate ? "":startdate;
		enddate = null == enddate ? "":enddate;
		String userid = request.getParameter("userid");
		String type = request.getParameter("levetype");
		List<ManagerDetail> leavedetailslist = this.manger.getleavedetails(startdate,enddate,userid, type);
		andView.addObject("detailslist", pagenate(leavedetailslist));
		return andView;
	}
	
	/**
	 * 导出excel
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView toExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/checkinMange");
		String stime1 = request.getParameter("stime1"); //开始时间
		String etime1 = request.getParameter("etime1"); //结束时间
		String name1 = request.getParameter("name1");  //姓名
		String gender1 = request.getParameter("gender1"); //性别
		String usercode1 = request.getParameter("usercode1"); //员工编号
		String positionlevel1 = request.getParameter("positionlevel1"); //职务级别
		String department1 = request.getParameter("department1");  //部门
		String cdepartment1 = request.getParameter("cdepartment1"); //二级部门
		List<depCheckIn> datalist = this.manger.getdepCheckInManage(stime1, etime1, name1,gender1,usercode1,positionlevel1,department1,cdepartment1);
		
		request.setCharacterEncoding("utf-8");
		String department=request.getParameter("department");
		String cdepartment=request.getParameter("cdepartment");
		String name=request.getParameter("name");
		String gender=request.getParameter("gender");
		String code=request.getParameter("code");
		String leavel=request.getParameter("leavel");
		String bugnum=request.getParameter("bugnum");
		String latenum=request.getParameter("latenum");
		String illnum=request.getParameter("illnum");
		String thingnum=request.getParameter("thingnum");
		String yearnum=request.getParameter("yearnum");
		String other=request.getParameter("other");
		String marry=request.getParameter("marry");
		String dienum=request.getParameter("dienum");
		String gohomenum=request.getParameter("gohomenum");
		
		String fname = "DataList";// Excel文件名
		OutputStream os = response.getOutputStream();// 取得输出流
		response.reset();// 清空输出流
		response.setHeader("Content-disposition", "attachment; filename="
		+ fname + ".xls");
		// 设定输出文件头,该方法有两个参数，分别表示应答头的名字和值。
		response.setContentType("application/msexcel");
		// 定义输出类型
		manger.toExcel(datalist, department, cdepartment, name, gender, code, leavel, bugnum, latenum, illnum, thingnum, yearnum, other, marry, dienum, gohomenum,os);
       
		modelAndView.addObject("depcheckIn", pagenate(datalist));
		return modelAndView;
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
