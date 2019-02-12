package com.seeyon.apps.checkin.controller;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.checkin.aberrant.CheckTask;
import com.seeyon.apps.checkin.client.CheckUtils;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.LeaveType;
import com.seeyon.apps.checkin.manager.InitCheckInManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.v3x.common.dao.paginate.Pagination;


/**
 * 考勤打卡处理类
 * 
 * @author yangli
 * @since 2013-06-13
 */
public class CheckInController extends BaseController {
	
	static 
	{
		System.out.println("监听线程启动===========");
		//定义任务类
		Runnable work = new CheckTask();
		Thread thread = new Thread(work);
		thread.start();
	}
	
	private InitCheckInManager manger;

	public InitCheckInManager getManger() 
	{
		return manger;
	}

	public void setManger(InitCheckInManager manger) 
	{
		this.manger = manger;
	}
	
	public ModelAndView testme(HttpServletRequest request, HttpServletResponse response) throws Exception 
	{
		Runnable work = new CheckTask();
		Thread thread = new Thread(work);
		thread.start();
		
//		OrgManager orgManager=(OrgManager)AppContext.getBean("orgManager");
//		V3xOrgMember member1 = orgManager.getMemberByLoginName("txf77");
//		V3xOrgMember member2 = orgManager.getMemberByLoginName("qinjiao");
//		
//		if (member1 == null)
//		{
//			System.out.println("member1 is null");
//		}
//		else
//		{
//			System.out.println(member1.getLoginName());
//		}
//		
//		if (member2 == null)
//		{
//			System.out.println("member2 is null");
//		}
//		else
//		{
//			System.out.println(member2.getLoginName());
//		}
		return null;
	}
	
	public String getIpAddr(HttpServletRequest request) 
	{
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}
	
	/**
	 * 首页TOP打卡
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView addInitCheckIn(HttpServletRequest request, HttpServletResponse response) throws Exception 
	{
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		//用户id
		User user = AppContext.getCurrentUser();
	    Long memberId = user.getId();
//		String userid = request.getParameter("userid");
		String userid = String.valueOf(memberId);
		System.out.println("当前登录用户ID：" + userid);
		if(null==userid || userid.equals(""))
		{
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().print("打卡失败！");
			return null;
		}
		String userip = getIpAddr(request);
		boolean flg = false;
		if(null==userip)
		{
			flg = true;
		}
		else if("".equals(userip))
		{
			flg = true;
		}
		else
		{
			flg = manger.chenkIp(userip);
		}
		
		if(flg)
		{
			// 根据ip地址取得mac地址
			String mac = getMACAddress(userip);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = new Date();
			String time = df.format(date);
			//打卡时间
			Timestamp checkTime = Timestamp.valueOf(time);
			String tempWeek = CheckUtils.getWeekCodeOfDate(date);
			
			InitCheckIn checkIn = new InitCheckIn();
			//用户id
			checkIn.setUserId(userid);
			//打卡时间
			checkIn.setCheckTime(checkTime);
			//打卡标识（0:正常 1：异常）
			//checkIn.setFlag("0");
			//星期
			checkIn.setWeek(tempWeek);
			//请假类型(0:空，不显示)
			checkIn.setLeaveType("0");
			//IP
			checkIn.setIp(userip);
			//mac
			checkIn.setMac(mac);
			//返回打卡状态
			String checkStatus = manger.saveInit(checkIn);
			//打卡完成后，设置打卡状态
			//            -1:打卡失败
			//            0:正常打卡
			//            1:异常打卡
			//            2:不打卡部门
			//            3:不打卡人
			//            4:休息日，无需打卡
			request.setAttribute("checkStatus", checkStatus);
			String str ="";
			if(checkStatus.equals("-1"))
			{
				str = "打卡失败！";
			}
			else if(checkStatus.equals("0"))
			{
				str = "打卡成功！\n"+time.toString();
			}
			else if(checkStatus.equals("2"))
			{
				str = "不打卡部门！";
			}
			else if(checkStatus.equals("3"))
			{
				str = "不打卡人";
			}
			else if(checkStatus.equals("4"))
			{
				str = "休息日无需打卡！";
			}
			else
			{
				str = "打卡失败！";
			}
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().print(str);   
		}
		else
		{
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().print("该IP地址不在打卡范围内");  
		}
		return null;
	}
	
	public String getMACAddress(String ipAddress) {
		String str = "", strMAC = "", macAddress = "";
		try {
			Process pp = Runtime.getRuntime().exec("nbtstat -a " + ipAddress);
			InputStreamReader ir = new InputStreamReader(pp.getInputStream());
			LineNumberReader input = new LineNumberReader(ir);
			for (int i = 1; i < 100; i++) {
				str = input.readLine();
				if (str != null) {
					if (str.indexOf("MAC Address") > 1) {
						strMAC = str.substring(str.indexOf("MAC Address") + 14,
								str.length());
						break;
					}
					
					if (str.indexOf("MAC 地址") > 1) {
						strMAC = str.substring(str.indexOf("MAC 地址") + 9,
								str.length());
						break;
					}
				}
			}
		} catch (IOException ex) {
			return "Can't Get MAC Address!";
		}
		//
		if (strMAC.length() < 17) {
			return "Error!";
		}

		macAddress = strMAC.substring(0, 2) + ":" + strMAC.substring(3, 5)
				+ ":" + strMAC.substring(6, 8) + ":" + strMAC.substring(9, 11)
				+ ":" + strMAC.substring(12, 14) + ":"
				+ strMAC.substring(15, 17);
		//
		return macAddress;
	}

	/**
	 * 点击“个人考勤”菜单，显示“个人考勤”画面，默认不查询数据。
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView initcheckInList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		System.out.println("个人考勤画面=====================================");
		
		//开始时间
		request.setAttribute("sstime", "");
		//结束时间
		request.setAttribute("setime", "");
		//状态
		request.setAttribute("sflag", "");
		//请假类型
		request.setAttribute("showvalue", "");
		
		//加载请假类别
		HashMap<String , String> map =  manger.findLeaveType();
		List<LeaveType> list = new ArrayList<LeaveType>();
		Iterator<String> iter = null;
		if(map!=null) iter = map.keySet().iterator();
		while(iter.hasNext()){
			String key = iter.next();
			String value = map.get(key);
			LeaveType leave = new LeaveType();
			leave.setLeaveId(key);
			leave.setLeaveType(value);
			list.add(leave);
		}
		request.setAttribute("leave", list);
		
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/dataList");

		User user = AppContext.getCurrentUser();
	    Long memberId = user.getId();
		List<InitCheckIn>  lis = manger.findInitAll(memberId.toString());
		modelAndView.addObject("icklist", pagenate(lis));
		return modelAndView;
	}

	/**
	 * 根据条件,查询个人考勤
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getSearchData(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		// 自定义跳转页面jsp
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/dataList");
		// 开始时间
		String stime = request.getParameter("sstime");
		request.setAttribute("sstime", stime);
		// 结束时间
		String etime = request.getParameter("setime");
		request.setAttribute("setime", etime);
		// 状态
		String flag = request.getParameter("sflag");
		request.setAttribute("sflag", flag);
		// 用户id
		String userid = request.getParameter("userid");
		request.setAttribute("userid", userid);
		// 请假类型
		String showvalue = request.getParameter("showvalue");
		request.setAttribute("showvalue", showvalue);
		
		User user = AppContext.getCurrentUser(); 
	    Long memberId = user.getId();
		List<InitCheckIn> icklist = manger.findInitAll(stime, etime,flag, memberId.toString(),showvalue);
		request.setAttribute("sstime", stime); //开始时间
		request.setAttribute("setime", etime); //结束时间
		request.setAttribute("sflag", flag);  // 状态
		request.setAttribute("showvalue", showvalue);  //请假类型
		modelAndView.addObject("icklist", pagenate(icklist));
		
		// 加载请假类别
		HashMap<String, String> map = manger.findLeaveType();
		List<LeaveType> list = new ArrayList<LeaveType>();
		Iterator<String> iter = map.keySet().iterator();
		while (iter.hasNext()) {
			String key = iter.next();
			String value = map.get(key);
			LeaveType leave = new LeaveType();
			leave.setLeaveId(key);
			leave.setLeaveType(value);
			list.add(leave);
		}
		request.setAttribute("leave", list);
		return modelAndView;
	}

	/**
	 * 用户打卡详细信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchDeatail(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		ModelAndView modelAndView = new ModelAndView("plugin/checkin/checktimedetail");
		// 用户id
		String userid = request.getParameter("userid");
		// 打卡日期
		String checkdate = request.getParameter("checkdate");
		SimpleDateFormat sdfx = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdfh = new SimpleDateFormat("yyyy年MM月dd日");
		String cdate = sdfh.format(sdfx.parse(checkdate));
		String ddate = cdate + "打卡记录";
		request.setAttribute("cdate", ddate);
		List<InitCheckIn> initdetai = manger.findDetail(checkdate, userid);
		modelAndView.addObject("checkDetail", pagenate(initdetai));
		
		System.out.println("显示用户打卡信息");
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
