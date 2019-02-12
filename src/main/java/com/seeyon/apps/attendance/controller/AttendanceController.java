/**
 * Author: het
 * Date:: 2016年12月1日:
 * Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.apps.attendance.controller;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.attendance.AttendanceConstants.AttendanceQueryParam;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceRemindEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceRemindTimeEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStaffInfoTable;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceType;
import com.seeyon.apps.attendance.manager.AttendanceManager;
import com.seeyon.apps.attendance.po.AttendanceInfo;
import com.seeyon.apps.attendance.po.AttendanceRemind;
import com.seeyon.apps.attendance.utils.AttendanceUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.v3x.common.taglibs.functions.Functions;

/**
 * <p>
 * 考勤签到MVC控制器
 * </p>
 * <p>
 * Copyright: Copyright (c) 2016
 * </p>
 * <p>
 * Company: seeyon.com
 * </p>
 */
public class AttendanceController extends BaseController {
    private OrgManager orgManager;
    private AttendanceManager attendanceManager;
    private FileToExcelManager fileToExcelManager;
    public void setAttendanceManager(AttendanceManager attendanceManager) {
    	this.attendanceManager = attendanceManager;
    }
    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
    	this.fileToExcelManager = fileToExcelManager;
    }
    public void setOrgManager(OrgManager orgManager) {
    	this.orgManager = orgManager;
    }

    /**
     * 一个全局变量，用于跟踪是否正在导出员工考勤的excel
     * 同一时间只能一个用户导出，防止数据量过大宕机，以及防止连续点击
     */
    private Boolean isExporting = false;
    private static final String       PREFIX = "apps/attendance/";


    /**
     * 进入个人考勤主页
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return ModelAndView
     * @throws BusinessException BusinessException
     */
    public ModelAndView intoMyAttendance(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView(PREFIX + "person/myAttendance");
        //打开消息
        String from = request.getParameter("from");
        String target = request.getParameter("target");
        mav.addObject("from",from);
        mav.addObject("target",target);
        
        //判断是否可以打卡 (外部人员不能打开)
        boolean canPunchcard = AppContext.getCurrentUser().isInternal();
        mav.addObject("canPunchcard", canPunchcard);
        
        return mav;
    }

    /**
     * 获取打卡数据
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return ModelAndView
     * @throws BusinessException BusinessException
     */
    public ModelAndView punchCard(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView(PREFIX + "person/punchCard");
        if(!AppContext.getCurrentUser().isInternal()){
        	//OA-127412 外部人员通过签到@的消息，越权实现打卡功能
        	try {
				super.rendText(response, ResourceUtil.getString("attendance.common.noauthrize"));
			} catch (IOException e) {
				logger.error("",e);
			}
        	return null;
        }
        Long ownerId = AppContext.currentUserId();
        
        List<AttendanceInfo> attendList = attendanceManager.getTodayAttendanceInfo(ownerId, AttendanceType.attend);
        List<AttendanceInfo> leaveList = attendanceManager.getTodayAttendanceInfo(ownerId, AttendanceType.leave);
        
        if(CollectionUtils.isEmpty(attendList) && CollectionUtils.isEmpty(leaveList)){
        	mav.addObject("canAttend",true);
        }else{
        	mav.addObject("canAttend",false);
        }
        if(CollectionUtils.isEmpty(leaveList)){
        	mav.addObject("canLeave",true);
        }else{
        	mav.addObject("canLeave",false);
        }
        
        AttendanceInfo signin = null;
        if(CollectionUtils.isNotEmpty(attendList)){
        	signin = attendList.get(0);
        }else{
        	signin = new AttendanceInfo();
        }
        mav.addObject("signin", signin);
        
        AttendanceInfo signout = null;
        if(CollectionUtils.isNotEmpty(leaveList)){
        	signout = leaveList.get(0);
        }else{
        	signout = new AttendanceInfo();
        }
        mav.addObject("signout", signout);
        
        String requiredSignin = AttendanceUtil.getWorkBeginTime(AppContext.getCurrentUser().getLoginAccount());
        String nowStr = Datetimes.formatNoTimeZone(new Date(),Datetimes.dateStyle);
		Date clientSigninDate = Datetimes.parseNoTimeZone(nowStr+ " " +requiredSignin, Datetimes.datetimeWithoutSecondStyle);
		mav.addObject("requiredSignin", Datetimes.formatNoTimeZone(clientSigninDate,"HH:mm"));
        
		String requiredsignout = AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount());
        Date clientSignoutDate = Datetimes.parseNoTimeZone(nowStr+ " " +requiredsignout, Datetimes.datetimeWithoutSecondStyle);
		mav.addObject("requiredsignout", Datetimes.formatNoTimeZone(clientSignoutDate,"HH:mm"));
        
		int week = DateUtil.getWeek(DateUtil.newDate());
        String today = MessageFormat.format("{0} {1}",DateUtil.getDate(DateUtil.YEAR_MONTH_DAY_PATTERN),ResourceUtil.getString("attendance.common.week"+week));
        mav.addObject("today",today);
        mav.addObject("userAccountId",AppContext.getCurrentUser().getAccountId());
        return mav;
    }
    
    public ModelAndView punchCardPortal(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView(PREFIX + "person/punchCardPortal");
        if(!AppContext.getCurrentUser().isInternal()){
        	//OA-127412 外部人员通过签到@的消息，越权实现打卡功能
        	try {
				super.rendText(response, ResourceUtil.getString("attendance.common.noauthrize"));
			} catch (IOException e) {
				logger.error("",e);
			}
        	return null;
        }
        Long ownerId = AppContext.currentUserId();
        
        List<AttendanceInfo> attendList = attendanceManager.getTodayAttendanceInfo(ownerId, AttendanceType.attend);
        List<AttendanceInfo> leaveList = attendanceManager.getTodayAttendanceInfo(ownerId, AttendanceType.leave);
        
        if(CollectionUtils.isEmpty(attendList) && CollectionUtils.isEmpty(leaveList)){
        	mav.addObject("canAttend",true);
        }else{
        	mav.addObject("canAttend",false);
        }
        if(CollectionUtils.isEmpty(leaveList)){
        	mav.addObject("canLeave",true);
        }else{
        	mav.addObject("canLeave",false);
        }
        
        AttendanceInfo signin = null;
        if(CollectionUtils.isNotEmpty(attendList)){
        	signin = attendList.get(0);
        }else{
        	signin = new AttendanceInfo();
        }
        mav.addObject("signin", signin);
        
        AttendanceInfo signout = null;
        if(CollectionUtils.isNotEmpty(leaveList)){
        	signout = leaveList.get(0);
        }else{
        	signout = new AttendanceInfo();
        }
        mav.addObject("signout", signout);
        
        String requiredSignin = AttendanceUtil.getWorkBeginTime(AppContext.getCurrentUser().getLoginAccount());
        String nowStr = Datetimes.formatNoTimeZone(new Date(),Datetimes.dateStyle);
		Date clientSigninDate = Datetimes.parseNoTimeZone(nowStr+ " " +requiredSignin, Datetimes.datetimeWithoutSecondStyle);
		mav.addObject("requiredSignin", Datetimes.formatNoTimeZone(clientSigninDate,"HH:mm"));
        
		String requiredsignout = AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount());
        Date clientSignoutDate = Datetimes.parseNoTimeZone(nowStr+ " " +requiredsignout, Datetimes.datetimeWithoutSecondStyle);
		mav.addObject("requiredsignout", Datetimes.formatNoTimeZone(clientSignoutDate,"HH:mm"));
        
		int week = DateUtil.getWeek(DateUtil.newDate());
        String today = MessageFormat.format("{0} {1}",DateUtil.getDate(DateUtil.YEAR_MONTH_DAY_PATTERN),ResourceUtil.getString("attendance.common.week"+week));
        mav.addObject("today",today);
        mav.addObject("userAccountId",AppContext.getCurrentUser().getAccountId());
        return mav;
    }
    
    /**
     * 个人明细
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return ModelAndView
     * @throws BusinessException BusinessException
     */
    public ModelAndView personalDetails(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView(PREFIX + "person/personalDetails");
        Date date = DateUtil.currentDate();
        String startTime = Datetimes.formatNoTimeZone(Datetimes.getFirstDayInMonth(date,Locale.getDefault()),DateUtil.YEAR_MONTH_DAY_PATTERN);
        mav.addObject(AttendanceQueryParam.startTime.name(),startTime);
        String endTime = Datetimes.formatNoTimeZone(Datetimes.getLastDayInMonth(date,Locale.getDefault()),DateUtil.YEAR_MONTH_DAY_PATTERN);
        mav.addObject(AttendanceQueryParam.endTime.name(),endTime);
        mav.addObject("begin", AttendanceUtil.getWorkBeginTime(AppContext.getCurrentUser().getLoginAccount()));
        mav.addObject("end", AttendanceUtil.getWorkEndTime(AppContext.getCurrentUser().getLoginAccount()));
        return mav;
    }

	/**
	 * 获取授权我的授权范围
	 * @param request
	 * @param response
	 * @return
	 * @throws BusinessException
	 */
    public ModelAndView authScope(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
		ModelAndView mav = new ModelAndView(PREFIX + "person/authScope");
		return mav;
	}

    /**
     * 个人统计
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return ModelAndView
     * @throws BusinessException BusinessException
     */
    public ModelAndView personalStatistic(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mav = new ModelAndView(PREFIX + "person/personalStatistic");
        Date date = DateUtil.currentDate();
        String startTime = Datetimes.formatNoTimeZone(Datetimes.getFirstDayInMonth(date,Locale.getDefault()),
                DateUtil.YEAR_MONTH_DAY_PATTERN).replaceAll("-", "/");
        mav.addObject(AttendanceQueryParam.startTime.name(),startTime);
        String endTime = Datetimes.formatNoTimeZone(Datetimes.getLastDayInMonth(date,Locale.getDefault()),
                DateUtil.YEAR_MONTH_DAY_PATTERN).replaceAll("-", "/");
        mav.addObject(AttendanceQueryParam.endTime.name(),endTime);
        return mav;
    }
    
    /**
     *<b>提及我的（＠）</b><br>
     *@since 6.1
     *@date  2017年3月22日
     *@param request
     *@param response
     *@return
     *@throws BusinessException
     */
    public ModelAndView personalAt(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException{
    	ModelAndView mav = new ModelAndView(PREFIX + "person/personalAt");
    	Date date = DateUtil.currentDate();
        String startTime = Datetimes.formatNoTimeZone(Datetimes.getFirstDayInMonth(date,Locale.getDefault()),
                DateUtil.YEAR_MONTH_DAY_PATTERN);
        mav.addObject(AttendanceQueryParam.startTime.name(),startTime);
        String endTime = Datetimes.formatNoTimeZone(Datetimes.getLastDayInMonth(date,Locale.getDefault()),
                DateUtil.YEAR_MONTH_DAY_PATTERN);
        mav.addObject(AttendanceQueryParam.endTime.name(),endTime);
    	return mav;
    }
    
    /**
     * 统计详情
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return ModelAndView
     * @throws BusinessException BusinessException
     */
    public ModelAndView statisticDetails(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView(PREFIX + "person/statisticlDetails");
        String type = ReqUtil.getString(request, "type");
        String startTime = ReqUtil.getString(request, "startTime");
        String endTime = ReqUtil.getString(request, "endTime");
        mav.addObject("type", type);
        mav.addObject("startTime", startTime);
        mav.addObject("endTime", endTime);
        return mav;
    }
    
    /**
     *<p>考勤管理员-考勤管理入口</p>
     * @param  
     * @return
     * @throws
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AttendanceAdmin,Role_NAME.HrAdmin})
    public ModelAndView staffAttendanceManagerHome(HttpServletRequest request, HttpServletResponse response){
    	ModelAndView mav = new ModelAndView(PREFIX + "staff/attendanceManager");
    	boolean isAttendanceAdmin = Functions.hasRoleName("AttendanceAdmin");
    	mav.addObject("isAttendanceAdmin",isAttendanceAdmin);
    	mav.addObject("isDept",false);
        return mav;
    }
    /**
     *<p>考勤管理员-考勤管理入口</p>
     * @param  
     * @return
     * @throws
     */
    @CheckRoleAccess(roleTypes={Role_NAME.DepAdmin})
    public ModelAndView deptAttendanceManagerHome(HttpServletRequest request, HttpServletResponse response){
    	ModelAndView mav = new ModelAndView(PREFIX + "staff/attendanceManager");
    	mav.addObject("isDept",true);
    	mav.addObject("isAttendanceAdmin",false);
        return mav;
    }
    /**
     * @throws BusinessException 
     * <p>员工考勤</p>
     * @param  
     * @return
     * @throws
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AttendanceAdmin,Role_NAME.HrAdmin,Role_NAME.DepAdmin})
    public ModelAndView staffAttendance(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
    	ModelAndView mav = new ModelAndView(PREFIX + "staff/staffAttendance");
    	boolean isDept = Boolean.parseBoolean(request.getParameter("isDept").toString()); 
    	if(isDept){
    		/**
    	     * 部门管理员范围设定
    	     **/
    		 List<V3xOrgDepartment> departments= orgManager.getDeptsByAdmin(AppContext.currentUserId(),AppContext.getCurrentUser().getLoginAccount());
    		 StringBuilder deptList = new StringBuilder(50);
			 for(V3xOrgDepartment department : departments){
				 deptList.append("Department|"+department.getId()+",");
			 }
			 mav.addObject("deptList",deptList.substring(0, deptList.length()-1));
    	}
    	mav.addObject("isDept",isDept);
    	Date date = DateUtil.currentDate();
    	String startTime = Datetimes.formatNoTimeZone(Datetimes.getFirstDayInMonth(date,Locale.getDefault()),
    			DateUtil.YEAR_MONTH_DAY_PATTERN);
    	mav.addObject(AttendanceQueryParam.startTime.name(),startTime);
    	String endTime = Datetimes.formatNoTimeZone(Datetimes.getLastDayInMonth(date,Locale.getDefault()),
    			DateUtil.YEAR_MONTH_DAY_PATTERN);
    	mav.addObject(AttendanceQueryParam.endTime.name(),endTime);
        return mav;
    }
    
    
    /**
     * @throws BusinessException 
     * <p>考勤统计</p>
     * @param  
     * @return
     * @throws
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AttendanceAdmin,Role_NAME.HrAdmin,Role_NAME.DepAdmin})
    public ModelAndView staffStatics(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
    	ModelAndView mav = new ModelAndView(PREFIX+"staff/staffStatist");
    	Boolean isDept = Boolean.parseBoolean(request.getParameter("isDept"));
    	if(isDept){
    		mav.addObject("isDept",isDept);
    		/**
    	     * 部门管理员范围设定
    	     **/
    		 List<V3xOrgDepartment> departments= orgManager.getDeptsByAdmin(AppContext.currentUserId(),AppContext.getCurrentUser().getLoginAccount());
    		 StringBuilder deptList = new StringBuilder(50);
			 for(V3xOrgDepartment department : departments){
				 deptList.append("Department|"+department.getId()+",");
			 }
			 mav.addObject("deptList",deptList.substring(0, deptList.length()-1));
    	}
    	Date date = DateUtil.currentDate();
    	String startTime = Datetimes.formatNoTimeZone(Datetimes.getFirstDayInMonth(date,Locale.getDefault()),
    			DateUtil.YEAR_MONTH_DAY_PATTERN);
    	mav.addObject(AttendanceQueryParam.startTime.name(),startTime);
    	String endTime = Datetimes.formatNoTimeZone(Datetimes.getLastDayInMonth(date,Locale.getDefault()),
    			DateUtil.YEAR_MONTH_DAY_PATTERN);
    	mav.addObject(AttendanceQueryParam.endTime.name(),endTime);
    	return mav;
    }
    
    /**
     * @throws Exception 
     * @throws ParseException 
     * @throws BusinessException 
     * <p>员工考勤导出</p>
     * @param  
     * @return
     * @throws
     */
	@SuppressWarnings("unchecked")
	@CheckRoleAccess(roleTypes={Role_NAME.AttendanceAdmin,Role_NAME.HrAdmin,Role_NAME.DepAdmin})
	public ModelAndView exportToExcel(HttpServletRequest request, HttpServletResponse response) throws Exception{
		if(isExporting == true){
			super.rendText(response, "is exporting");
			return null;
		}else{
			logger.info(AppContext.currentUserName()+" 正在导出员工考勤！");
			isExporting = true;
		}
		try {
			DataRecord dataRecord = new DataRecord() ;
			Map<String,Object> params = ParamUtil.getJsonParams();
			String title = ResourceUtil.getString("attendance.common.staffexcel.title");
			dataRecord.setSheetName(title) ;
			dataRecord.setTitle(title);
			String[] headList = new String[AttendanceStaffInfoTable.values().length];
			for (int i = 0; i < AttendanceStaffInfoTable.values().length; i++) {
				if(AttendanceStaffInfoTable.modifynum.name().equals(AttendanceStaffInfoTable.values()[i].name())){
					//OA-128285 员工考勤页面导出excel，显示了多余的列“更新次数”，且这列没有数据
					continue;
				}
				AttendanceStaffInfoTable head = AttendanceStaffInfoTable.values()[i];
				headList[i] = ResourceUtil.getString(head.getText());
			}
			dataRecord.setColumnName(headList);
			
			FlipInfo fi = new FlipInfo(-1,-1);
			fi = attendanceManager.findStaffAttendanceInfoData(fi, params);
			List<Map<String,Object>> result = fi.getData();
			if(CollectionUtils.isNotEmpty(result)){
				for(int i = 0;i<result.size();i++){
					Map<String,Object> info = result.get(i);
					DataRow dataRow = new DataRow();
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.membername.name()), DataCell.DATA_TYPE_TEXT) ;
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.departmentname.name()), DataCell.DATA_TYPE_TEXT);
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.signtime.name()),  DataCell.DATA_TYPE_TEXT);
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.fixtime.name()), DataCell.DATA_TYPE_TEXT);
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.signtype.name()),  DataCell.DATA_TYPE_TEXT);
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.sign.name()), DataCell.DATA_TYPE_TEXT);
					dataRow.addDataCell((String) info.get(AttendanceStaffInfoTable.remark.name()), DataCell.DATA_TYPE_TEXT);
					dataRecord.addDataRow(dataRow);
				}
			}
			
			fileToExcelManager.save(response,title,dataRecord);
		} catch (Exception e) {	
			logger.error("", e);
		} finally{
			isExporting = false;			
		}
    	
    	return null;
    }
	
	/**
	 * @throws BusinessException 
	 *<p>员工考勤-删除界面</p>
	 * @param  
	 * @return
	 * @throws
	 */
    @CheckRoleAccess(roleTypes={Role_NAME.AttendanceAdmin,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
	public ModelAndView showDeletePage(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
		ModelAndView mav = new ModelAndView(PREFIX+"staff/showDeletePage");
		//第一次考勤时间
		Date earlistDate = attendanceManager.getEarliestSigntime(AppContext.currentAccountId());
		mav.addObject("earlySign",Datetimes.formatNoTimeZone(earlistDate, "yyyy-MM"));
		return mav;
	}
	/**
	 * 考勤统计-穿透详情
	 * 注：普通用户也有一个统计页面，穿透也走的这个逻辑，所以暂时就不用控制权限
	 * @param 
	 * @return
	 */
	public ModelAndView staffStatistDetail(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView(PREFIX+"staff/staffStatistDetail");
		return mav;
	}
//    
//	/**
//	 * 考勤管理-手工调度
//	 * @param 
//	 * @return
//	 */
//	public ModelAndView runTask(HttpServletRequest request, HttpServletResponse response){
//		RptCollectorTask task = (RptCollectorTask) AppContext.getBean("attendanceCollectorTask");
//		task.runDayTask(null);
//		return null;
//	}
	/**
	 * 消息提醒设置页面
	 * @param 
	 * @return
	 */
    @CheckRoleAccess(roleTypes={Role_NAME.AttendanceAdmin/*,Role_NAME.HrAdmin*/})//考勤提醒只有考勤管理能设置
	public ModelAndView attendanceRemind(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView(PREFIX+"attendanceRemind");
		List<Long> accountId = new ArrayList<Long>();
		accountId.add(AppContext.getCurrentUser().getLoginAccount());
		Map<String,Object> params = new HashMap<String,Object>();
		params.put(AttendanceQueryParam.accountId.name(), accountId);
		List<AttendanceRemind> list = attendanceManager.findAttendanceRemind(params);
		int attend = AttendanceRemindEnum.noRemind.getKey();
		int leave = AttendanceRemindEnum.noRemind.getKey();
		if(CollectionUtils.isNotEmpty(list)){
			AttendanceRemind remind = list.get(0);
			attend = remind.getAttendRemind();
			if(attend != AttendanceRemindEnum.noRemind.getKey()){
				/**
				 * 设置的提醒,取设置值
				 */
				attend = AttendanceRemindTimeEnum.getByTime(remind.getAttendRemindTime()).getKey();
			}
			leave = remind.getLeaveRemind();
		}
		//上班签到html
		StringBuilder attendRemindHtml = new StringBuilder(50);
		attendRemindHtml.append("<select id='remindAttend'  name='remindAttend' style='width:185px;'>");
		AttendanceRemindEnum remindEnum = AttendanceRemindEnum.noRemind;
		if(attend == remindEnum.getKey()){
			attendRemindHtml.append("<option value='"+remindEnum.getKey()+"' selected>"+ResourceUtil.getString(remindEnum.getValue())+"</option>");
		}else{
			attendRemindHtml.append("<option value='"+remindEnum.getKey()+"'>"+ResourceUtil.getString(remindEnum.getValue())+"</option>");
		}
		AttendanceRemindTimeEnum[] timeEnum = AttendanceRemindTimeEnum.values();
		for(AttendanceRemindTimeEnum time : timeEnum){
			if(time.getKey() != AttendanceRemindTimeEnum.before0.getKey()){
				if(attend == time.getKey()){
					attendRemindHtml.append("<option value='"+time.getKey()+"' selected>"+ResourceUtil.getString(time.getValue())+"</option>");
				}else{
					attendRemindHtml.append("<option value='"+time.getKey()+"'>"+ResourceUtil.getString(time.getValue())+"</option>");
				}
			}
		}
		attendRemindHtml.append("</select>");
		//下班签退html
		StringBuilder leaveRemindHtml = new StringBuilder(50);
		AttendanceRemindEnum[] remindEnums = AttendanceRemindEnum.values();
		leaveRemindHtml.append("<select id='remindLeave' name='remindLeave' style='width:185px;'>");
		for(AttendanceRemindEnum re :remindEnums){
			if(leave == re.getKey()){
				leaveRemindHtml.append("<option value='"+re.getKey()+"' selected>"+ResourceUtil.getString(re.getValue())+"</option>");
			}else{
				leaveRemindHtml.append("<option value='"+re.getKey()+"'>"+ResourceUtil.getString(re.getValue())+"</option>");
			}
		}
		leaveRemindHtml.append("</select>");
		mav.addObject("attendRemindHtml",attendRemindHtml);
		mav.addObject("leaveRemindHtml",leaveRemindHtml);
		mav.addObject("attendRemind",attend);
		mav.addObject("leaveRemind",leave);
		return mav;
	}
    
	public ModelAndView doPressureData(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
		return new ModelAndView(PREFIX+"doPressureData");
	}
	
	public ModelAndView showDeleteRate(HttpServletRequest request, HttpServletResponse response){
		return new ModelAndView(PREFIX+"showDeleteRate");
	}
	
	
	public ModelAndView attendanceHistory(HttpServletRequest request, HttpServletResponse response){
		return new ModelAndView(PREFIX+"attendanceHistory");
	}
}
