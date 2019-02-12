/**
 * 
 * Author: xiaolin
 * Date: 2016年12月8日
 *
 * Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.apps.attendance.manager;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.seeyon.apps.attendance.AttendanceConstants;
import com.seeyon.apps.attendance.AttendanceConstants.AttendancePerfosnStatistTable;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceQueryParam;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStaffStatistTable;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStateEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStatistDetailTable;
import com.seeyon.apps.attendance.dao.AttendanceCollectorDao;
import com.seeyon.apps.attendance.po.RptAttendance;
import com.seeyon.apps.attendance.po.RptWorkTime;
import com.seeyon.apps.attendance.utils.AttendanceUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title:实现调度接口manager </p>
 * <p>Description:关于调度表的接口都放在这儿 </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: com.seeyon.apps.attendance.manager</p>
 * <p>since Seeyon V6.1</p>
 */
public class AttendanceCollectorManagerImpl implements AttendanceCollectorManager{
	private static final Log LOGGER = CtpLogFactory.getLog(AttendanceCollectorManagerImpl.class);

	private AttendanceCollectorDao attendanceCollectorDao;
	
	private OrgManager orgManager;
	
	@Override
	public void saveAttendanceList(List<RptAttendance> data) {
		attendanceCollectorDao.saveList(data);
	}
	
	@Override
	public FlipInfo findStaffAttendanceCount(FlipInfo fi,Map<String, Object> params) throws ParseException, BusinessException {
		String selectRange = ParamUtil.getString(params, AttendanceQueryParam.selectRange.name());
		params.remove(AttendanceQueryParam.selectRange.name());
		//选择的单位
		params.put(AttendanceQueryParam.accountId.name(), AppContext.getCurrentUser().getLoginAccount());
		
		/**
		 * 选择的是部门
		 */
		String departmentId = ParamUtil.getString(params,AttendanceQueryParam.departmentId.name());
		LOGGER.info("考勤部门查询id="+departmentId);
		params.remove(AttendanceQueryParam.departmentId.name());
		//客开 wfj  2018-9-19 start
		if(departmentId!=null&&!"".equals(departmentId)){
			String[] deptIdArray = departmentId.split(",");
			List<String> deptIdlist=new ArrayList<String>();
			for (int i = 0; i < deptIdArray.length; i++) {
				String deptId=deptIdArray[i];
				if(!deptIdlist.contains(deptId)) {
					List<V3xOrgDepartment> departments = orgManager.getChildDepartments(Long.valueOf(deptId.split("\\|")[1]),false);
					if(departments!=null&&departments.size()>0) {
						for (V3xOrgDepartment v3xOrgDepartment : departments) {
							if(!deptIdlist.contains("Department|"+v3xOrgDepartment.getId())) {
							deptIdlist.add("Department|"+v3xOrgDepartment.getId());
							}
						}
					}
					deptIdlist.add(deptId);
				}
			}
			if(deptIdlist!=null&&deptIdlist.size()>0) {
				departmentId=deptIdlist.get(0);
				for (int i = 1; i < deptIdlist.size(); i++) {
					departmentId +=","+deptIdlist.get(i);
				}
			}
			
		}
		//客开 wfj  2018-9-19 end
		if(AttendanceQueryParam.selectDept.name().equals(selectRange)){
			params.put(AttendanceQueryParam.departmentId.name(), AttendanceUtil.parseStringToList(departmentId));
		}
		
		/**
		 * 选择全部, 部门管理员
		 */
		boolean isDept = Boolean.parseBoolean(ParamUtil.getString(params,"isDept"));
		if(isDept && AttendanceQueryParam.selectAll.name().equals(selectRange)){
			String departmentsEle = ParamUtil.getString(params, "departmentEle");
			params.remove("departmentEle");
			params.remove("isDept");
			List<Long> departmentIds = AttendanceUtil.parseStringToList(departmentsEle);
			/**
			 * 查询所有子部门
			 */
			List<Long> depts = new ArrayList<Long>();
			depts.addAll(departmentIds);
			for(int i = 0;i<departmentIds.size();i++){
				List<V3xOrgDepartment> childDept = orgManager.getChildDepartments(departmentIds.get(i), false);
				if(CollectionUtils.isNotEmpty(childDept)){
					for(int j = 0;j<childDept.size();j++){
						depts.add(childDept.get(j).getId());
					}
				}
			}
			params.put(AttendanceQueryParam.departmentId.name(),depts);
		}
		
		/**
		 * 选择的是人员
		 */
		String memberId = ParamUtil.getString(params,AttendanceQueryParam.memberId.name());
		params.remove(AttendanceQueryParam.memberId.name());
		if(AttendanceQueryParam.selectMember.name().equals(selectRange)){
			params.put(AttendanceQueryParam.memberId.name(), AttendanceUtil.parseStringToList(memberId));
		}
		/**
		 * 开始时间
		 */
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		params.remove(AttendanceQueryParam.startTime.name());
		if(StringUtils.isNotEmpty(startTime)){
			params.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(Datetimes.getFirstTimeStr(startTime.replaceAll("/", "-")), Datetimes.datetimeStyle));
		}
		/**
		 * 结束时间
		 */
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		params.remove(AttendanceQueryParam.endTime.name());
		if(StringUtils.isNotEmpty(endTime)){
			params.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(Datetimes.getLastTimeStr(endTime.replaceAll("/", "-")),Datetimes.datetimeStyle));
		}
		
		/**
		 * 表格内容
		 */
		List<Map<String, Object>> detail = attendanceCollectorDao.findAttendanceCountByState(fi, params);
		/**
		 * 计算未打卡数,通过工作日天数-所有打卡记录的天数计算每个人的未打卡数
		 */
		Map<Long,Integer> workdayMap = attendanceCollectorDao.getWorkDayNum(params.get(AttendanceQueryParam.startTime.name()),
				params.get(AttendanceQueryParam.endTime.name()));
		if (CollectionUtils.isNotEmpty(detail)) {
			for (Map<String, Object> map : detail) {
				Long accountId = ParamUtil.getLong(map, AttendanceQueryParam.accountId.name().toLowerCase());
				//获取部门名称
				Long deptId = ParamUtil.getLong(map, AttendanceQueryParam.departmentId.name().toLowerCase());
				//客开  wfj 20180919  部门列只显示一级部门名称 start
				V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
				V3xOrgAccount account=orgManager.getAccountById(accountId);
				if(dept != null){
//					account.getPath().length()+4
					if(dept.getPath().length()==(account.getPath().length()+4)) {
						map.put(AttendanceQueryParam.departmentName.name().toLowerCase(), dept.getName());
					}else {
						if(dept.getPath().length()>(account.getPath().length()+4)) {
							String yjpath=dept.getPath().substring(0, account.getPath().length()+4);
							
							V3xOrgDepartment parentdept=orgManager.getDepartmentByPath(yjpath);
							
							map.put(AttendanceQueryParam.departmentName.name().toLowerCase(), parentdept.getName());
						}
//						V3xOrgDepartment parentdept=orgManager.getParentDepartment(deptId);
//						if(parentdept!=null&&parentdept.getPath()!=null) {
//							if(parentdept.getPath().length()==16) {
//							}else {
//								
//							}
//							
//						}else {
//							
//							map.put(AttendanceQueryParam.departmentName.name().toLowerCase(), dept.getName());
//						}
					}
					
				}
				//客开  wfj 20180919  部门列只显示一级部门名称 end
				//未打卡
				int ndk = 0;
				if(workdayMap.containsKey(accountId)){
					int num = workdayMap.get(accountId);
					int attendNdk = ParamUtil.getInt(map, AttendanceStateEnum.attendndk.name());
					int leaveNdk = ParamUtil.getInt(map, AttendanceStateEnum.leavendk.name());
					int attendLate = ParamUtil.getInt(map, AttendanceStateEnum.attendlate.name());
					int leaveEarly = ParamUtil.getInt(map, AttendanceStateEnum.leaveearly.name());
					int attendLateAndleaveEarly = ParamUtil.getInt(map, AttendanceStateEnum.attendlateandleaveearly.name());
					int normal = ParamUtil.getInt(map, AttendanceStateEnum.normal.name());
					int attendNdkAndleaveEarly = ParamUtil.getInt(map, AttendanceStateEnum.attendndkandleaveearly.name());
					int attendLateAndLeaveNdk = ParamUtil.getInt(map, AttendanceStateEnum.attendlateandleavendk.name());
					/**
					 * 未打卡 = 工作日 - 其他打卡的记录
					 */
					int subNum = num-attendNdk-leaveNdk-attendLate-leaveEarly-
					attendLateAndleaveEarly-normal-attendNdkAndleaveEarly-attendLateAndLeaveNdk;
					ndk = subNum>0?subNum:0;
				}
				map.put(AttendanceStateEnum.ndk.name(),ndk);
				this.convertToStaffStatisRowCells(map,params);
			}
		}
		fi.setData(detail);
		return fi;
	}
	
	@Override
	public FlipInfo findRptAttendanceDetail(FlipInfo fi,Map<String, Object> params) throws ParseException{
		/**
		 * 获得单位id
		 */
		Long accountId = ParamUtil.getLong(params, AttendanceQueryParam.accountId.name());
		params.remove(AttendanceQueryParam.accountId.name());
		if(accountId != null){
			params.put(AttendanceQueryParam.accountId.name(), accountId);
		}
		/**
		 * 获得状态
		 */
		String columnName = ParamUtil.getString(params, AttendanceQueryParam.columnName.name());
		AttendanceStateEnum attendanceState = AttendanceStateEnum.getAttendanceState(columnName);
		params.put(AttendanceQueryParam.state.name(),attendanceState.getKey());
		
		/**
		 * 开始时间
		 */
		Date startTime = DateUtil.parse(ParamUtil.getString(params, AttendanceQueryParam.startTime.name()));
		params.put(AttendanceQueryParam.startTime.name(), startTime);
		/**
		 * 结束时间
		 */
		Date endTime = DateUtil.parse(ParamUtil.getString(params, AttendanceQueryParam.endTime.name()));
		params.put(AttendanceQueryParam.endTime.name(), endTime);
		/**
		 * 签到人员
		 */
		Long memberId = ParamUtil.getLong(params, AttendanceQueryParam.memberId.name());
		params.put(AttendanceQueryParam.memberId.name(), memberId);
		/**
		 * 表格内容
		 */
		List<Map<String, Object>> detail = attendanceCollectorDao.findRptAttendanceDetail(fi, params);
		if (CollectionUtils.isNotEmpty(detail)) {
			for (Map<String, Object> map : detail) {
				Date attendTime = (Date) map.get(AttendanceStatistDetailTable.attendTime.name().toLowerCase());
				if(attendTime != null){
					map.put(AttendanceStatistDetailTable.attendTime.name().toLowerCase(), AttendanceUtil.getClientDayWeek(attendTime));
				}
				Date leaveTime = (Date) map.get(AttendanceStatistDetailTable.leaveTime.name().toLowerCase());
				if(leaveTime != null){
					map.put(AttendanceStatistDetailTable.leaveTime.name().toLowerCase(), AttendanceUtil.getClientDayWeek(leaveTime));
				}
				this.convertToDetailRowCells(map);
			}
			fi.setData(detail);
		}
		return fi;
	}
	/**
	 * 考勤统计-穿透表格数据组装
	 * @param 
	 * @return		
	*/
	private void convertToDetailRowCells(Map<String, Object> map) {
		for(AttendanceStatistDetailTable e:AttendanceStatistDetailTable.values()){
			String displayStr = ParamUtil.getString(map, e.name().toLowerCase());
			displayStr = StringUtils.defaultString(displayStr, ResourceUtil.getString(e.getDefaultText()));
			map.put(e.name(), displayStr);
		}
	}

	/**
	 * 考勤统计表格数据组装
	 * @param 
	 * @return		
	*/
	private void convertToStaffStatisRowCells(Map<String, Object> m,Map<String,Object> params) {
		Map<String,Object> conditions = new HashMap<String,Object>();
		for(AttendanceStaffStatistTable e:AttendanceStaffStatistTable.values()){
			String displayStr = ParamUtil.getString(m, e.name());
			displayStr = StringUtils.defaultString(displayStr, ResourceUtil.getString(e.getDefaultText()));
			if(e.isClick() && !String.valueOf(AttendanceConstants.DATA_TYPE_NUMERIC).equals(displayStr.toString())){
				String memeberId = AttendanceQueryParam.memberId.name();
				conditions.put(memeberId, ParamUtil.getLong(m, memeberId.toLowerCase()));
				String startTime = AttendanceQueryParam.startTime.name();
				conditions.put(startTime,params.get(startTime));
				String endTime = AttendanceQueryParam.endTime.name();
				conditions.put(endTime,params.get(endTime));
				Long accountId = ParamUtil.getLong(m, AttendanceQueryParam.accountId.name().toLowerCase());
				/**
				 * 如果是在兼职单位打卡,应该传递兼职单位的id
				 */
				Object attendAccountIdStr = m.get("attend_accountid");
				if(attendAccountIdStr != null){
					Long attendAccountId = Long.parseLong(attendAccountIdStr.toString());
					if(!accountId.equals(attendAccountId)){
						accountId = attendAccountId;
					}
				}
				conditions.put(AttendanceQueryParam.accountId.name(), accountId);
				m.put("condition", JSONUtil.toJSONString(conditions));
			}
		}
	}

	@Override
	public FlipInfo findPersonAttendanceCount(FlipInfo fi,Map<String, Object> params) throws ParseException,
			BusinessException {		
		Long memberId = ParamUtil.getLong(params,AttendanceQueryParam.memberId.name());
		List<Long> memberIds = new ArrayList<Long>();
		memberIds.add(memberId);
		params.put(AttendanceQueryParam.memberId.name(), memberIds);
		params.put(AttendanceQueryParam.accountId.name(), AppContext.getCurrentUser().getLoginAccount());
		/**
		 * 开始时间
		 */
		String startTime = ParamUtil.getString(params, AttendanceQueryParam.startTime.name());
		if(StringUtils.isNotBlank(startTime)){
			params.put(AttendanceQueryParam.startTime.name(), Datetimes.parseNoTimeZone(Datetimes.getFirstTimeStr(startTime.replaceAll("/", "-")), Datetimes.datetimeStyle));
		}
		/**
		 * 结束时间
		 */
		String endTime = ParamUtil.getString(params, AttendanceQueryParam.endTime.name());
		if(StringUtils.isNotBlank(endTime)){
			params.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(Datetimes.getLastTimeStr(endTime.replaceAll("/", "-")),Datetimes.datetimeStyle));
		}
		
		/**
		 * 表格内容
		 */
		List<Map<String, Object>> detail = attendanceCollectorDao.findAttendanceCountByState(fi, params);
		/**
		 * 计算未打卡数,通过工作日天数-所有打卡记录的天数计算每个人的未打卡数
		 */
		Map<Long,Integer> workdayMap = attendanceCollectorDao.getWorkDayNum(params.get(AttendanceQueryParam.startTime.name()),
				params.get(AttendanceQueryParam.endTime.name()));
		if (CollectionUtils.isNotEmpty(detail)) {
			for (Map<String, Object> map : detail) {
				Long accountId = ParamUtil.getLong(map, AttendanceQueryParam.accountId.name().toLowerCase());
				int ndk = 0;
				if(workdayMap.containsKey(accountId)){
					int num = workdayMap.get(accountId);
					int attendNdk = ParamUtil.getInt(map, AttendanceStateEnum.attendndk.name());
					int leaveNdk = ParamUtil.getInt(map, AttendanceStateEnum.leavendk.name());
					int attendLate = ParamUtil.getInt(map, AttendanceStateEnum.attendlate.name());
					int leaveEarly = ParamUtil.getInt(map, AttendanceStateEnum.leaveearly.name());
					int attendLateAndleaveEarly = ParamUtil.getInt(map, AttendanceStateEnum.attendlateandleaveearly.name());
					int normal = ParamUtil.getInt(map, AttendanceStateEnum.normal.name());
					int attendNdkAndleaveEarly = ParamUtil.getInt(map, AttendanceStateEnum.attendndkandleaveearly.name());
					int attendLateAndLeaveNdk = ParamUtil.getInt(map, AttendanceStateEnum.attendlateandleavendk.name());
					/**
					 * 未打卡 = 工作日 - 其他打卡的记录
					 */
					int subNum = num-attendNdk-leaveNdk-attendLate-leaveEarly-
					attendLateAndleaveEarly-normal-attendNdkAndleaveEarly-attendLateAndLeaveNdk;
					ndk = subNum>0?subNum:0;
				}
				map.put(AttendanceStateEnum.ndk.name(),ndk);
				this.convertToPersonStatisRowCells(map,params);
			}
			fi.setData(detail);
		}
		return fi;
	}
	
	/**
	 * 考勤统计表格数据组装
	 * @param 
	 * @return		
	*/
	private void convertToPersonStatisRowCells(Map<String, Object> m,Map<String,Object> params) {
		for(AttendancePerfosnStatistTable e:AttendancePerfosnStatistTable.values()){
			String displayStr = ParamUtil.getString(m, e.name());
			displayStr = StringUtils.defaultString(displayStr, ResourceUtil.getString(e.getDefaultText()));
			if(e.isClick() && !String.valueOf(AttendanceConstants.DATA_TYPE_NUMERIC).equals(displayStr.toString())){
				Map<String,Object> conditions=new HashMap<String,Object>();
				String memeberId = AttendanceQueryParam.memberId.name();
				conditions.put(memeberId, ParamUtil.getLong(m, memeberId.toLowerCase()));
				String startTime = AttendanceQueryParam.startTime.name();
				conditions.put(startTime,params.get(startTime));
				String endTime = AttendanceQueryParam.endTime.name();
				conditions.put(endTime,params.get(endTime));
				m.put("condition", JSONUtil.toJSONString(conditions));
			}
		}
	}
	
	@Override
	public Map<Long,Boolean> isWorkDayInCurrency(List<Long> accountIds, int year, int day) {
		return attendanceCollectorDao.isWorkDayInCurrency(accountIds,year,day);
	}
	
	@Override
	public Map<Long,Boolean> isWorkDayInSpecial(List<Long> accountIds,
			String dateNum) {
		return attendanceCollectorDao.isWorkDayInSpecial(accountIds,dateNum);
	}
	
	@Override
	public Map<Long, Boolean> isSetInCurrency(List<Long> accountIds) {
		return attendanceCollectorDao.isSetInCurrency(accountIds);
	}
	
	@Override
	public void saveWorktimeList(List<RptWorkTime> time) {
		attendanceCollectorDao.saveWorktimeList(time);
	}
	
	public AttendanceCollectorDao getAttendanceCollectorDao() {
		return attendanceCollectorDao;
	}

	public void setAttendanceCollectorDao(
			AttendanceCollectorDao attendanceCollectorDao) {
		this.attendanceCollectorDao = attendanceCollectorDao;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

}
