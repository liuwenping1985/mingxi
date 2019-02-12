package com.seeyon.apps.checkin.aberrant;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jfree.util.Log;

import com.seeyon.apps.checkin.client.CheckUtils;
import com.seeyon.apps.checkin.client.DocumentServiceStub;
import com.seeyon.apps.checkin.dao.CheckInInstallDao;
import com.seeyon.apps.checkin.dao.FormDataExportDao;
import com.seeyon.apps.checkin.domain.InitCheckIn;
import com.seeyon.apps.checkin.domain.WorkDaySet;
import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;
import com.seeyon.apps.collaboration.manager.ColManagerImpl;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.oainterface.ExternalUse;
//import com.seeyon.oainterface.exportData.commons.TextExport;
import com.seeyon.oainterface.exportData.flow.FlowExport;
//import com.seeyon.oainterface.exportData.form.ValueExport;
//import com.seeyon.v3x.services.form.bean.FormExport;
//import com.seeyon.v3x.services.flow.bean.TextExport;
//import com.seeyon.v3x.services.form.bean.FormExport;
//import com.seeyon.v3x.services.form.bean.;
//import com.seeyon.v3x.services.form.bean.ValueExport;
//import com.seeyon.v3x.collaboration.manager.impl.ColManagerImpl;

public class CheckHandler {

	private FormDataExportDao exportDao;

	private CheckInInstallDao checkininstalldao;

	private ColManagerImpl colManagerImpl;
	
	public ColManagerImpl getColManagerImpl() {
		return colManagerImpl;
	}

	public void setColManagerImpl(ColManagerImpl colManagerImpl) {
		this.colManagerImpl = colManagerImpl;
	}

	public FormDataExportDao getExportDao() {
		return exportDao;
	}

	public void setExportDao(FormDataExportDao exportDao) {
		this.exportDao = exportDao;
	}

	public CheckInInstallDao getCheckininstalldao() {
		return checkininstalldao;
	}

	public void setCheckininstalldao(CheckInInstallDao checkininstalldao) {
		this.checkininstalldao = checkininstalldao;                      
	}

	/**
	 * 表单审批事件(同时监听3个表单的审批情况)
	 * 
	 * @param event
	 */
//	@ListenEvent(event = CollaborationFormApprovalEvent.class)
//	@ListenEvent(event = CollaborationProcessEvent.class)
//	@com.seeyon.ctp.util.annotation.ListenEvent(event = CollaborationProcessEvent.class)
//	@com.seeyon.ctp.util.annotation.ListenEvent(event = CollaborationProcessEvent.class)
//	public void onFormApproval(CollaborationProcessEvent event) 
//	{
//		System.out.println("------------yl----------");
//		String tempCode1 = "A001";// 考勤异常处理
//		String tempCode2 = "A002";// 告知请假流程
//		String tempCode3 = "A003";// 告知公出流程
//		String code = "";
//		try {
//			code = event.getTemplateCode();
//		} catch (BusinessException e2) {
//			e2.printStackTrace();
//		}// 当前监听的表单模板编号
//
//		// 应用配置查看器->系统参数设置
//		if (tempCode1.equals(code) || tempCode2.equals(code) || tempCode3.equals(code)) {
////			int state = event.get.getState();
//			int state = 0;
//			try {
//				state = event.getAffair().getState();
//			} catch (BusinessException e2) {
//				e2.printStackTrace();
//			}
//			// 审批通过
//			if (state == 2) {
//				Long summaryId = event.getSummaryId(); // 流程Id
//				BPMUtils utils = new BPMUtils();
//				String tokenId = null;
//				try {
//					tokenId = utils.getTokenId();
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//				DocumentServiceStub.ExportFlow2 ef = new DocumentServiceStub.ExportFlow2();
//				ef.setFlowId(summaryId);
//				ef.setToken(tokenId);
//				exportDao = (FormDataExportDao) AppContext.getBean("exportDao");
//
//				// 判断是否为配置文件对应的请假单
//				boolean isSyncFormData = false;
//				isSyncFormData = exportDao.isSyncFormData(summaryId, code);
//
//				if (isSyncFormData) {
//					FlowExport flowExport = null;
//					try {
//						// 获取表单数据结构
//						flowExport = ExternalUse.getInstance().getDataExportUtils().findFlowExportById(summaryId, -1L);
//					} catch (Exception e1) {
//						e1.printStackTrace();
//					}
//dddd
//					FormExport export = (FormExport) flowExport.getFlowContent();
//					List<com.seeyon.v3x.services.form.bean.ValueExport> list = export.getValues();
//
//					// A001考勤异常处理
//					if (tempCode1.equals(code)) {
//						onFormApprovalA001(list);
//					}
//					// A002告知请假流程
//					else if (tempCode2.equals(code)) {
//						onFormApprovalA002(list);
//					}
//					// A003告知公出流程
//					else if (tempCode3.equals(code)) {
//						onFormApprovalA003(list);
//					}
//				}
//			} 
//			// 审批不通过
//			else if (state == 3) {
//				System.out.println("审批不通过");
//			}
//		}
//	}
//	
	/**
	 * 考勤异常表单
	 */
	public void onFormApprovalA001(List<com.seeyon.v3x.services.form.bean.ValueExport> list)
	{
		try
		{
			String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
			System.out.println("methodName:" + methodName);
			
			String leavetype = "";// 考勤异常类型
			String checkdate = "";// 考勤日期
			String usercode = "";//考勤卡号
			
			System.out.println("list:" + list.size());
			
			
			for (int i = 0; i < list.size(); i++) 
			{
				//ValueExport ve = list.get(i);
				
				String disName =  list.get(i).getDisplayName();
				String disValue =  list.get(i).getDisplayValue();
				String value =  list.get(i).getValue();
	
				if(disName.equals("考勤卡号"))
				{
					usercode = value;
				}
				else if (disName.equals("考勤异常类型")) 
				{
					if("1".equals(value)){//病假
						leavetype = "1";
					}else if("2".equals(value)){//事假
						leavetype = "2";
					}else if("3".equals(value)){//年休
						leavetype = "3";
					}else if("4".equals(value)){//婚假
						leavetype = "4";
					}else if("5".equals(value)){//丧假
						leavetype = "5";
					}else if("6".equals(value)){//产假
						leavetype = "6";
					}else if("7".equals(value)){//其他
						leavetype = "7";
					}else if("10".equals(value)){//探亲假
						leavetype = "10";
					}
				} 
				else if (disName.equals("上午上班")) 
				{
				} 
				else if (disName.equals("下午下班")) 
				{
				} 
				else if (disName.equals("考勤日期")) 
				{
//					SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
//					checkdate = sdfd.parse(value).get;//永远永远
					checkdate = value.substring(0,value.indexOf(" "));
					System.out.println(checkdate);
				}
			}
			
			System.out.println("leavetype:" + leavetype);
			//根据员工编号，取得员工id
			String userid = checkininstalldao.getuserid(usercode);
			
			System.out.println("userid:" + userid);
			
			//考勤打卡时间表当天数据为正常，则不进行下面操作
			if(checkininstalldao.checkisok(userid, checkdate))
			{
				System.out.println("111111111");
				return;
			}
			
			System.out.println("2222222222");
			// 删除异常待处理表
			checkininstalldao.deletecheckabnormal(userid, checkdate);
	
			boolean cb = checkininstalldao.checkischeck(userid, checkdate);
			if(cb)
			{
				// 修改个人打卡时间表
				checkininstalldao.updateinitcheck(userid,checkdate, "0", leavetype);
				System.out.println("333333333333333333");
			}
			else
			{
				InitCheckIn init = new InitCheckIn();
				init.setCheckStartTime(null);
				init.setCheckEndTime(null);
				init.setFlag("0");
				init.setUserId(userid);
				init.setLeaveType("");
				SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
				try 
				{
					init.setWeek(CheckUtils.getWeekCodeOfDate(sdfd.parse(checkdate)));
					init.setCheckdate(sdfd.parse(checkdate));
				} 
				catch (ParseException e) 
				{
					e.printStackTrace();
				}
				init.setDebugday(1);
				List<InitCheckIn> initListU = new ArrayList<InitCheckIn>();
				initListU.add(init);
				checkininstalldao.insertcheckin(initListU);
				System.out.println("44444444444444");
			}
	
			// 查询个人打卡时间表
			double debugnum = 0;
			List<InitCheckIn> initc = checkininstalldao.selectinitcheckin(userid,checkdate);
			for(InitCheckIn init:initc)
			{
				//请假类型天数
				debugnum = init.getDebugday();
			}
			
			if(!checkininstalldao.existsDepCheck(userid,checkdate))
			{
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				Date date1;
				try 
				{
					date1 = df.parse(checkdate);
					checkininstalldao.insertdepcheck(userid,date1,"0",leavetype,debugnum);
				} 
				catch (ParseException e) 
				{
					e.printStackTrace();
				}
			}
			else
			{
				checkininstalldao.updatedepcheck("0", userid, checkdate, leavetype, debugnum);
			}
		
			System.out.println("555555555555555");
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	/**
	 * 告知请假
	 */
	public void onFormApprovalA002(List<com.seeyon.v3x.services.form.bean.ValueExport> list)
	{
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		
		String userid = "";// 申请人id
		String leavetype = "";// 请假类型
		String startdate = "";// 请假开始日期
		String enddate = "";// 请假结束日期
		double amf = 1;// 开始第一天是从上午开始
		double pmf = 1;// 结束最后一天截止到下午

		for (int i = 0; i < list.size(); i++) {

			com.seeyon.v3x.services.form.bean.ValueExport ve = list.get(i);
			String disName = ve.getDisplayName();
			String disValue = ve.getDisplayValue();
			String value = ve.getValue();

			if (disName.equals("申请人")) {
				userid = value;
			} else if (disName.equals("请假类型")) {
				if ("1".equals(value)) {// 病假
					leavetype = "1";
				} else if ("2".equals(value)) {// 事假
					leavetype = "2";
				} else if ("3".equals(value)) {// 年休
					leavetype = "3";
				} else if ("4".equals(value)) {// 婚假
					leavetype = "4";
				} else if ("5".equals(value)) {// 丧假
					leavetype = "5";
				} else if ("6".equals(value)) {// 产假
					leavetype = "6";
				} else if ("7".equals(value)) {// 其他
					leavetype = "7";
				} else if("10".equals(value)){//探亲假
					leavetype = "10";
				}
			} else if (disName.equals("请假开始日期")) {
				startdate = value;
			} else if (disName.equals("请假结束日期")) {
				enddate = value;
			} else if (disName.equals("上午")) {
				if ("下午".equals(disValue)) {
					amf = 0.5;
				}
			} else if (disName.equals("下午")) {
				if ("上午".equals(disValue)) {
					pmf = 0.5;
				}
			}
		}
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

			String dateStr1 = df.format(df.parse(startdate));
			String dateStr2 = df.format(df.parse(enddate));
			Date dateBegin = df.parse(dateStr1);
			Date dateEnd = df.parse(dateStr2);
			Calendar ca = Calendar.getInstance();
			// 从请假开始日期----到请假结束日期，进行循环
			while (dateBegin.compareTo(dateEnd) <= 0) {
				String tmpdate = df.format(dateBegin);
				double debugnum = 0;
				if (tmpdate.equals(dateStr1)) {	debugnum = amf;	} 
				else if (tmpdate.equals(dateStr2)) {debugnum = amf;}
				else {debugnum = 1;}
				
				boolean workb = workNeed(dateBegin,userid);
				// 不需要打卡，继续执行循环的下一次
				if(!workb){
					ca.setTime(dateBegin);   
					ca.add(ca.DATE,1);//把dateBegin加上1天然后重新赋值给date1   
					dateBegin=ca.getTime();  
					continue;
				}
				
				// 删除异常待处理表
				checkininstalldao.deletecheckabnormal(userid, tmpdate);
				
				//考勤查询表
				if(checkininstalldao.existsDepCheck(userid,tmpdate)){
					checkininstalldao.updatedepcheck("0", userid, tmpdate, leavetype, debugnum);
				}else{
					checkininstalldao.insertdepcheck(userid,dateBegin,"0",leavetype,debugnum);
				}
				
				// 考勤打卡时间表当天数据为正常，则不插入。
				//checkininstalldao.checkisok(userid, tmpdate)
				
				// 查询个人打卡时间表
				List<InitCheckIn> initc = checkininstalldao.selectinitcheckin(userid,tmpdate);
				
				if(initc!=null && initc.size()>0){					
					// 修改个人打卡时间表
					checkininstalldao.updateinitcheck(userid, tmpdate, "0",	leavetype);
				}else{
					//插入考勤打开时间表
					InitCheckIn init = new InitCheckIn();
					init.setCheckStartTime(null);
					init.setCheckEndTime(null);
					init.setFlag("0");
					init.setUserId(userid);
					init.setLeaveType(leavetype);
					SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
					try {
						init.setWeek(CheckUtils.getWeekCodeOfDate(sdfd.parse(tmpdate)));
						init.setCheckdate(sdfd.parse(tmpdate));
					} catch (ParseException e) {
						e.printStackTrace();
					}
					init.setDebugday(1);
					List<InitCheckIn> initListU = new ArrayList<InitCheckIn>();
					initListU.add(init);
					checkininstalldao.insertcheckin(initListU);
				}
				
				ca.setTime(dateBegin);   
				ca.add(ca.DATE,1);//把dateBegin加上1天然后重新赋值给date1   
				dateBegin=ca.getTime();  
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 告知公出
	 */
	public void onFormApprovalA003(List<com.seeyon.v3x.services.form.bean.ValueExport> list){
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		
		String userid = "";//申请人id
		String startdate = "";// 出差开始时间
		String enddate = "";// 出差结束时间
		String am = "";// 上午
		String pm = "";// 下午
		double amf = 1;//开始第一天是从上午开始
		double pmf = 1;//结束最后一天截止到下午
		String leavetype="";

		for (int i = 0; i < list.size(); i++) {

			com.seeyon.v3x.services.form.bean.ValueExport ve = list.get(i);
			String disName = ve.getDisplayName();
			String disValue = ve.getDisplayValue();
			String value = ve.getValue();

			if (disName.equals("申请人")) {
				userid = value;
			}  else if (disName.equals("出差开始时间")) {
				startdate = value;
			} else if (disName.equals("出差结束时间")) {
				enddate = value;
			} else if (disName.equals("上午")) {
				if("下午".equals(disValue)){
					amf = 0.5;
				}
			} else if (disName.equals("下午")) {
				if("上午".equals(disValue)){
					pmf = 0.5;
				}
			}else if (disName.equals("出差性质")) {
				if("8".equals(value)){//出差
					leavetype="8";
				}else if("9".equals(value)){//外出培训
					leavetype="9";
				}
			}
		}
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String dateStr1 = df.format(df.parse(startdate));
			String dateStr2 = df.format(df.parse(enddate));
			Date dateBegin = df.parse(dateStr1);
			Date dateEnd = df.parse(dateStr2);
			Calendar ca = Calendar.getInstance();
			while(dateBegin.compareTo(dateEnd)<=0){
				String tmpdate = df.format(dateBegin);
				double debugnum = 0;
				if(tmpdate.equals(dateStr1)){
					debugnum = amf ;
				}else if(tmpdate.equals(dateStr2)){
					debugnum = amf ;
				}else{
					debugnum = 1;
				}
				
				boolean workb = workNeed(dateBegin,userid);
				// 不需要打卡，继续执行循环的下一次
				if(!workb){
					ca.setTime(dateBegin);   
					ca.add(ca.DATE,1);//把dateBegin加上1天然后重新赋值给date1   
					dateBegin=ca.getTime();  
					continue;
				}
				
				// 删除异常待处理表
				checkininstalldao.deletecheckabnormal(userid, tmpdate);
				// 更新考勤查询表
				checkininstalldao.deletedepcheck(userid, tmpdate);
				
				//考勤打卡时间表当天数据为正常，则不插入。
//				if(checkininstalldao.checkisok(userid, tmpdate)){
			
				// 查询个人打卡时间表
				List<InitCheckIn> initc = checkininstalldao.selectinitcheckin(userid,tmpdate);
				
				if (initc != null && initc.size() > 0) {
					// 修改个人打卡时间表
					checkininstalldao.updateinitcheck(userid, tmpdate, "0", leavetype);
				} else {
					//插入考勤打开时间表
					InitCheckIn init = new InitCheckIn();
					init.setCheckStartTime(null);
					init.setCheckEndTime(null);
					init.setFlag("0");
					init.setUserId(userid);
					init.setLeaveType(leavetype);
					SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
					try {
						init.setWeek(CheckUtils.getWeekCodeOfDate(sdfd.parse(tmpdate)));
						init.setCheckdate(sdfd.parse(tmpdate));
					} catch (ParseException e) {
						e.printStackTrace();
					}
					init.setDebugday(1);
					List<InitCheckIn> initListU = new ArrayList<InitCheckIn>();
					initListU.add(init);
					checkininstalldao.insertcheckin(initListU);
				}
					
				ca.setTime(dateBegin);
				ca.add(ca.DATE, 1);//把dateBegin加上1天，然后重新复制给date1
				dateBegin = ca.getTime();
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	
	//出差txf
	public void onFormApprovalA004(List<com.seeyon.v3x.services.form.bean.ValueExport> list)
	{
		String methodName = Thread.currentThread().getStackTrace()[1].getMethodName();
		System.out.println("methodName:" + methodName);
		
		String userid = "";//申请人id
		String startdate = "";// 出差开始时间
		String enddate = "";// 出差结束时间
//		String am = "";// 上午
//		String pm = "";// 下午
		double amf = 1;//开始第一天是从上午开始
		double pmf = 1;//结束最后一天截止到下午
		String leavetype="";

		for (int i = 0; i < list.size(); i++) 
		{
			com.seeyon.v3x.services.form.bean.ValueExport ve = list.get(i);
			String disName = ve.getDisplayName();
			String disValue = ve.getDisplayValue();
			String value = ve.getValue();

			System.out.println(disName);
			System.out.println(disValue);
			
			if (disName.equals("员工姓名")) 
			{
				userid = value;
			}  
			else if (disName.equals("出发日")) 
			{
				startdate = value;
			} 
			else if (disName.equals("返回日")) 
			{
				enddate = value;
			} 
//			else if (disName.equals("上午")) 
//			{
//				if("下午".equals(disValue)){
//					amf = 0.5;
//				}
//			} else if (disName.equals("下午")) {
//				if("上午".equals(disValue)){
//					pmf = 0.5;
//				}
//			}else if (disName.equals("出差性质")) {
//				if("8".equals(value)){//出差
					leavetype="8";
//				}else if("9".equals(value)){//外出培训
//					leavetype="9";
//				}
//			}
		}
		try 
		{
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String dateStr1 = df.format(df.parse(startdate));
			String dateStr2 = df.format(df.parse(enddate));
			Date dateBegin = df.parse(dateStr1);
			Date dateEnd = df.parse(dateStr2);
			Calendar ca = Calendar.getInstance();
			while(dateBegin.compareTo(dateEnd)<=0){
				String tmpdate = df.format(dateBegin);
				double debugnum = 0;
				if(tmpdate.equals(dateStr1)){
					debugnum = amf ;
				}else if(tmpdate.equals(dateStr2)){
					debugnum = amf ;
				}else{
					debugnum = 1;
				}
				
				boolean workb = workNeed(dateBegin,userid);
				// 不需要打卡，继续执行循环的下一次
				if(!workb){
					ca.setTime(dateBegin);   
					ca.add(ca.DATE,1);//把dateBegin加上1天然后重新赋值给date1   
					dateBegin=ca.getTime();  
					continue;
				}
				
				// 删除异常待处理表
				checkininstalldao.deletecheckabnormal(userid, tmpdate);
				// 更新考勤查询表
				checkininstalldao.deletedepcheck(userid, tmpdate);
				
				//考勤打卡时间表当天数据为正常，则不插入。
				//if(checkininstalldao.checkisok(userid, tmpdate)){
			
				// 查询个人打卡时间表
				List<InitCheckIn> initc = checkininstalldao.selectinitcheckin(userid,tmpdate);
				
				if (initc != null && initc.size() > 0) {
					// 修改个人打卡时间表
					checkininstalldao.updateinitcheck(userid, tmpdate, "0", leavetype);
				} else {
					//插入考勤打开时间表
					InitCheckIn init = new InitCheckIn();
					init.setCheckStartTime(null);
					init.setCheckEndTime(null);
					init.setFlag("0");
					init.setUserId(userid);
					init.setLeaveType(leavetype);
					SimpleDateFormat sdfd = new SimpleDateFormat("yyyy-MM-dd");
					try {
						init.setWeek(CheckUtils.getWeekCodeOfDate(sdfd.parse(tmpdate)));
						init.setCheckdate(sdfd.parse(tmpdate));
					} catch (ParseException e) {
						e.printStackTrace();
					}
					init.setDebugday(1);
					List<InitCheckIn> initListU = new ArrayList<InitCheckIn>();
					initListU.add(init);
					checkininstalldao.insertcheckin(initListU);
				}
					
				ca.setTime(dateBegin);
				ca.add(ca.DATE, 1);//把dateBegin加上1天，然后重新复制给date1
				dateBegin = ca.getTime();
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 是否需要打卡
	 * @param date
	 * @return
	 * 		  false:不需要打卡（休息日）
	 * 		  true:需要打卡（工作日）
	 */
	public boolean workNeed(Date date,String userId){
		boolean workB = false;
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String year = df.format(date).substring(0,4);// 年份2013
		String month = df.format(date).substring(5,7);// 月份07
		String accountId = checkininstalldao.getAccountId(userId);
		String week = getWeekCodeOfDate(date);
		//判断前一天是休息，还是工作日。
		if ("0".equals(week) || "6".equals(week)) {
			workB = false;
		} else {
			workB = true;
		}
		
		//查询工作时间设置表
		List<WorkDaySet> rsspecialday = checkininstalldao.getspecialday(toDate1(df.format(date)));
		//查询工作日、休息日设置表
		List<WorkDaySet>  rscurrency = checkininstalldao.getcurrency(df.format(date));
		
		for(WorkDaySet wds:rscurrency){
			String org_account_id1 = wds.getOrg_account_id();//单位id
			String week_day_name = wds.getWeek_num();//工作日0,1,2,3,4,5,6
			String is_work = wds.getIs_work();//是否工作0:休息1:工作
			String year1 = wds.getYear();//年	
			if(year.equals(year1) && accountId.equals(org_account_id1) && week.equals(week_day_name)){
				if("0".equals(is_work)){
					workB = false;
				}else{
					workB = true;
				}
				break;
			}
		}
		
		for(WorkDaySet wds:rsspecialday){
			String org_account_id = wds.getOrg_account_id();//单位id
			String date_num = wds.getDate_num();//日期2013/06/24
			String is_rest = wds.getIs_rest();//休息类型0:工作 1:休息 2:法定休息
			String week_num = wds.getWeek_num();//周几0,1,2,3,4,5,6
			String year1 = wds.getYear();
			String month1 = wds.getMonth();
			if(accountId.equals(org_account_id) && date_num.equals(toDate1(df.format(date))) && year.equals(year1) && month.equals(toMonth(month1)) /*&& week.equals(week_num)*/){
				if(is_rest.equals("0")){//工作
					workB = true;
				}else if(is_rest.equals("1")){//休息
					workB = false;
				}else{//法定休息
					workB = false;
				}
				break;
			}
		}
		
		return workB;
	}
	
	/**
	 * 转化字符串日期的格式
	 * @param s 2013-09-01
	 * @return 2013/09/01
	 */
	public String toDate1(String s){
		return s.substring(0, 4) + "/" + s.substring(5,7) + "/" + s.substring(8,10) ;
	}
	
	/**
	 * 转化字符串日期的格式
	 * @param s 2013/09/01
	 * @return 2013-09-01
	 */
	public String toDate2(String s){
		return s.substring(0, 4) + "-" + s.substring(5,7) + "-" + s.substring(8,10) ;
	}
	
	/**
	 * 转化字符串月份的格式
	 * @param month
	 * @return
	 */
	public String toMonth(String month) {
		if(month.length()==1)
			month = "0" + month;
		return month;
	}
	
	/**
	 * 计算日期提前多少天
	 * 
	 * @param d
	 * @param day
	 * @return
	 */
	public Date getDateBefore(Date d, int day) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		now.set(Calendar.DATE, now.get(Calendar.DATE) - day);
		return now.getTime();
	}

	/**
	 * 计算日期推迟多少天
	 * 
	 * @param d
	 * @param day
	 * @return
	 */
	public Date getDateAfter(Date d, int day) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		now.set(Calendar.DATE, now.get(Calendar.DATE) + day);
		return now.getTime();
	}
	
	/**
	 * 根据日期获得星期(0,1,2,3,4,5,6)
	 * @param date
	 * @return
	 */
	public String getWeekCodeOfDate(Date date) {
		String[] weekDaysCode = { "0", "1", "2", "3", "4", "5", "6" };
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int intWeek = calendar.get(Calendar.DAY_OF_WEEK) - 1;
		return weekDaysCode[intWeek];
	}
	
//	//流程发起事件
//	@ListenEvent(event = CollaborationStartEvent.class)
//	public void onFormApproval2(CollaborationStartEvent event) {
//		System.out.println("流程发起事件");
//	}
	
	//流程处理事件
	@com.seeyon.ctp.util.annotation.ListenEvent(event = CollaborationProcessEvent.class,mode=EventTriggerMode.afterCommit) 
	public void onFormApproval3(CollaborationProcessEvent event) throws BusinessException 
	{
		try
		{
			Log.error("流程处理事件Start");
			
			if (event.getTemplateCode()== null)
			{
				return;
			}
			
			if (!event.isTemplate("A001")&&!event.isTemplate("A002")&&!event.isTemplate("A003")&&!event.isTemplate("A004"))
			{
				Log.error("====return====");
				return;
			}
		
			if (!event.isFormAudited()&&!event.isVouched()) 
			{
				Log.error("没有审批/审核......");
				return;
			}

			Long summaryId = event.getSummaryId(); // 流程Id
			
			BPMUtils utils = new BPMUtils();
			String tokenId = null;
			try 
			{
				tokenId = utils.getTokenId();
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			DocumentServiceStub.ExportFlow2 ef = new DocumentServiceStub.ExportFlow2();
			ef.setFlowId(summaryId);
			ef.setToken(tokenId);
			
			exportDao = (FormDataExportDao) AppContext.getBean("exportDao");
			
			// 判断是否为配置文件对应的请假单
			boolean isSyncFormData = false;
			FlowExport flowExport = null;
			try 
			{
				// 获取表单数据结构
				flowExport = ExternalUse.getInstance().getDataExportUtils().findFlowExportById(summaryId, -1L);
//				System.out.println("3333");
			} 
			catch (Exception e1) 
			{
				e1.printStackTrace();
			}
	
		
			com.seeyon.oainterface.exportData.form.FormExport export = (com.seeyon.oainterface.exportData.form.FormExport) flowExport.getFlowContent();
			
			List<?> list = export.getValues();
			List<com.seeyon.v3x.services.form.bean.ValueExport> list2 = new ArrayList<com.seeyon.v3x.services.form.bean.ValueExport> ();
			for (Object o:list)
			{
				list2.add((com.seeyon.v3x.services.form.bean.ValueExport)o);
			}
			
			
			//获取表单的表头
			String flowTitle = flowExport.getFlowTitle();
			System.out.println("flowTitle:"+flowTitle);
		
			// A001考勤异常处理
			if (event.isTemplate("A001"))
			{
				onFormApprovalA001(list2); 
			}
			// A002告知请假流程
			else if (event.isTemplate("A002")) 
			{
				onFormApprovalA002(list2);
			}
			// A003告知公出流程
			else if (event.isTemplate("A003"))
			{
				onFormApprovalA003(list2);
			}
			else if (event.isTemplate("A004")) 
			{
				onFormApprovalA004(list2);
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
//	//流程结束事件
//	@ListenEvent(event = CollaborationFinishEvent.class)
//	public void onFormApproval4(CollaborationFinishEvent event) {
//		System.out.println("流程结束事件");
//	}
//	
//	//流程撤销事件
//	@ListenEvent(event = CollaborationCancelEvent.class)
//	public void onFormApproval5(CollaborationCancelEvent event) {
//		System.out.println("流程撤销事件");
//	}
//	
//	//流程回退事件
//	@ListenEvent(event = CollaborationStepBackEvent.class)
//	public void onFormApproval6(CollaborationStepBackEvent event) {
//		System.out.println("流程回退事件");
//	}
//	
//	//流程取回事件
//	@ListenEvent(event = CollaborationTakeBackEvent.class)
//	public void onFormApproval7(CollaborationTakeBackEvent event) {
//		System.out.println("流程取回事件");
//	}
//	
//	//流程终止事件
//	@ListenEvent(event = CollaborationStopEvent.class)
//	public void onFormApproval8(CollaborationStopEvent event) {
//		System.out.println("流程终止事件");
//	}
}
