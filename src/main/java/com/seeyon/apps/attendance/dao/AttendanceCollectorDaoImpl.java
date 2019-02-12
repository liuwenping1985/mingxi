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
package com.seeyon.apps.attendance.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.log.CtpLogFactory;
import org.apache.commons.collections.CollectionUtils;

import com.seeyon.apps.attendance.AttendanceConstants.AttendanceQueryParam;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStateEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStatistDetailTable;
import com.seeyon.apps.attendance.po.RptAttendance;
import com.seeyon.apps.attendance.po.RptWorkTime;
import com.seeyon.apps.attendance.utils.AttendanceUtil;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import org.apache.commons.logging.Log;

/**
 * <p>Title:调度表dao层 </p>
 * <p>Description:调度表-统计查询业务层 </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: com.seeyon.apps.attendance.dao</p>
 * <p>since Seeyon V6.1</p>
 */
public class AttendanceCollectorDaoImpl implements AttendanceCollectorDao{

	private static final Log LOGGER = CtpLogFactory.getLog(AttendanceCollectorDaoImpl.class);

	@Override
	public void saveList(List<RptAttendance> data) {
		DBAgent.saveAll(data);
	}

	@Override
	public List<Map<String, Object>> findAttendanceCountByState(FlipInfo fi,Map<String, Object> params) {
		StringBuilder sql = new StringBuilder(50);
		sql.append("select ");
		sql.append("mem.id as ").append(AttendanceQueryParam.memberId.name()).append(",");
		sql.append("mem.name as ").append(AttendanceQueryParam.memberName.name()).append(",");
		sql.append("mem.org_department_id as ").append(AttendanceQueryParam.departmentId.name()).append(",");
		sql.append("mem.org_account_id as ").append(AttendanceQueryParam.accountId.name()).append(",");
		sql.append("attend.account_id as attend_accountid").append(",");
		sql.append(getNullSQL(AttendanceStateEnum.attendndk)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.leavendk)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.attendlate)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.leaveearly)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.attendlateandleaveearly)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.normal)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.attendndkandleaveearly)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.restdk)).append(",");
		sql.append(getNullSQL(AttendanceStateEnum.attendlateandleavendk));
		//客开  wfj 20180919 start
		
		sql.append(",(CASE WHEN length(ou.path)<(length(ou2.path)+4) THEN ou.sort_id ELSE (select ou1.sort_id from org_unit ou1 where ou1.is_enable=1 and is_deleted=0 and ou1.path=substr(ou.path,0,(length(ou3.path)+4))) END) AS deptsortid");
		//客开  wfj 20180919 end
		sql.append(" from org_member mem left join (select ");
		sql.append("rpt.attend_id as ").append(AttendanceQueryParam.memberId.name()).append(",");
		sql.append("max(rpt.dept_id) as dept_id").append(",");
		sql.append("rpt.account_id as account_id ").append(",");
		sql.append(getCountSQL(AttendanceStateEnum.attendndk)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.leavendk)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.attendlate)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.leaveearly)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.attendlateandleaveearly)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.normal)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.attendndkandleaveearly)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.restdk)).append(",");
		sql.append(getCountSQL(AttendanceStateEnum.attendlateandleavendk));
		sql.append(" from rpt_attendance rpt ");
		sql.append(" where 1=1 ");
		if(params.containsKey(AttendanceQueryParam.memberId.name())){
			sql.append(" and rpt.attend_id in (:").append(AttendanceQueryParam.memberId.name()).append(")");
		}
		if(params.containsKey(AttendanceQueryParam.startTime.name())){
			sql.append(" and rpt.query_time >= :").append(AttendanceQueryParam.startTime.name());
		}
		if(params.containsKey(AttendanceQueryParam.endTime.name())){
			sql.append(" and rpt.query_time <= :").append(AttendanceQueryParam.endTime.name());
		}
		if(params.containsKey(AttendanceQueryParam.departmentId.name())){
			sql.append(" and rpt.dept_id in (:").append(AttendanceQueryParam.departmentId.name()).append(")");
		}
		if(params.containsKey(AttendanceQueryParam.accountId.name())){
			sql.append(" and rpt.account_id in (:").append(AttendanceQueryParam.accountId.name()).append(")");
		}
		sql.append(" group by rpt.attend_id,rpt.account_id");
		sql.append(") attend on mem.id = attend. ").append(AttendanceQueryParam.memberId.name());
		//客开  wfj   2018-9-18  增加部门排序 start
		sql.append(" left join org_unit ou on mem.org_department_id=ou.id ");
		sql.append(" left join org_unit ou2 on ou2.id=ou.org_account_id ");
		sql.append(" left join org_unit ou3 on ou3.id=ou.org_account_id ");
		//客开  wfj   2018-9-18  增加部门排序 end
		sql.append(" where 1=1 ");
		if(params.containsKey(AttendanceQueryParam.memberId.name())){
			sql.append(" and mem.id in (:").append(AttendanceQueryParam.memberId.name()).append(")");
		}
		if(params.containsKey(AttendanceQueryParam.departmentId.name())){
			sql.append(" and (mem.org_department_id in (:").append(AttendanceQueryParam.departmentId.name()).append(")");
			sql.append(" or attend.dept_id in (:").append(AttendanceQueryParam.departmentId.name()).append("))");
		}
		if(params.containsKey(AttendanceQueryParam.accountId.name())){
			sql.append(" and (mem.org_account_id in (:").append(AttendanceQueryParam.accountId.name()).append(")");
			sql.append(" or attend.account_id in (:").append(AttendanceQueryParam.accountId.name()).append("))");
		}
		sql.append(" and ((mem.is_internal = 1 and mem.is_admin = 0 and mem.is_enable=1 and mem.is_deleted = 0 and mem.state = 1 and mem.is_assigned = 1) or (attend.memberId is not null))");
		//客开  wfj   2018-9-18  增加部门排序 start
		sql.append(" order by deptsortid,mem.sort_id");
		LOGGER.info("考勤sql:"+sql.toString());
		//客开  wfj   2018-9-18  增加部门排序 end
		return AttendanceUtil.doQuery(sql.toString(), params,fi);
	}
	
	private String getCountSQL(AttendanceStateEnum e){
		StringBuilder sql = new StringBuilder(20);
		sql.append(" sum(case when rpt.state = ").append(e.getKey());
		sql.append(" then 1 else 0 end) as ").append(e.name());
		return sql.toString();
	}
	
	private String getNullSQL(AttendanceStateEnum e){
		StringBuilder sql = new StringBuilder(20);
		sql.append(" (case when attend.").append(e.name()).append(" is null ");
		sql.append(" then 0 else ").append(e.name()).append(" end) as ").append(e.name());
		return sql.toString();
	}
	
	@Override
	public List<Map<String,Object>> findRptAttendanceDetail(FlipInfo fi,Map<String, Object> params) {
		StringBuilder sql = new StringBuilder(50);
		sql.append("select ");
		sql.append(" rpt.attend_time as ").append(AttendanceStatistDetailTable.attendTime.name()).append(",");
		sql.append(" rpt.attend_address as ").append(AttendanceStatistDetailTable.attendAddress.name()).append(",");
		sql.append(" rpt.leave_time as ").append(AttendanceStatistDetailTable.leaveTime.name()).append(",");
		sql.append(" rpt.leave_address as ").append(AttendanceStatistDetailTable.leaveAddress.name());
		sql.append(" from rpt_attendance rpt");
		sql.append(" where 1=1");
		if(params.containsKey(AttendanceQueryParam.startTime.name())){
			sql.append(" and rpt.query_time >= :").append(AttendanceQueryParam.startTime.name());
		}
		if(params.containsKey(AttendanceQueryParam.endTime.name())){
			sql.append(" and rpt.query_time <= :").append(AttendanceQueryParam.endTime.name());
		}
		if(params.containsKey(AttendanceQueryParam.memberId.name())){
			sql.append(" and rpt.attend_id =:").append(AttendanceQueryParam.memberId.name());
		}
		if(params.containsKey(AttendanceQueryParam.state.name())){
			sql.append(" and rpt.state =:").append(AttendanceQueryParam.state.name());
		}
		if(params.containsKey(AttendanceQueryParam.accountId.name())){
			sql.append(" and rpt.account_id =:").append(AttendanceQueryParam.accountId.name());
		}
		sql.append(" order by rpt.query_time desc");
		return AttendanceUtil.doQuery(sql.toString(), params,fi);
	}
	
	@Override
	public void saveWorktimeList(List<RptWorkTime> time) {
		DBAgent.saveAll(time);
	}

	@Override
	public Map<Long,Integer> getWorkDayNum(Object startTime, Object endTime) {
		Map<String,Object> params = new HashMap<String,Object>();
		StringBuilder sql = new StringBuilder(50);
		sql.append("select count(rpt.id) as num,rpt.account_id as account_id from rpt_worktime rpt ");
		sql.append("where 1=1 ");
		if(startTime != null){
			sql.append(" and rpt.now_time >=:startTime ");
			params.put(AttendanceQueryParam.startTime.name(), startTime);
		}
		if(endTime != null){
			sql.append(" and rpt.now_time <=:endTime ");
			Date d = (Date) endTime;
			params.put(AttendanceQueryParam.endTime.name(), Datetimes.parseNoTimeZone(Datetimes.format(d, Datetimes.datetimeStyle), Datetimes.datetimeStyle));
		}
		sql.append(" and rpt.is_work_day = 1");
		sql.append(" group by rpt.account_id");
		List<Map<String,Object>> result = AttendanceUtil.doQuery(sql.toString(), params,new FlipInfo(-1,-1));
		Map<Long,Integer> map = new HashMap<Long,Integer>();
		if(CollectionUtils.isNotEmpty(result)){
			for(int i = 0;i<result.size();i++){
				Map<String,Object> m = result.get(i);
				Long accountId = ParamUtil.getLong(m, "account_id");
				Integer num = ParamUtil.getInt(m, "num");
				map.put(accountId, num);
			}
		}
		return map;
	}

	@Override
	public Map<Long,Boolean> isWorkDayInCurrency(List<Long> accountId, int year, int day) {
		String sql = "select wtc.ORG_ACCOUNT_ID as account_id,count(wtc.id) as total from Worktime_Currency wtc where wtc.ORG_ACCOUNT_ID in(:orgAcconutID) and wtc.year between 2010 and :year and wtc.week_Day_Name=:day and wtc.is_Work='1' group by wtc.ORG_ACCOUNT_ID";
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("orgAcconutID", accountId);
		params.put("year",year);
		params.put("day",day);
		List<Map<String,Object>> result = AttendanceUtil.doQuery(sql.toString(), params,new FlipInfo(-1,-1));
		Map<Long,Boolean> retMap = new HashMap<Long,Boolean>();
		for(int i = 0;i<accountId.size();i++){
			retMap.put(accountId.get(i), false);
		}
		if(CollectionUtils.isNotEmpty(result)){
			for(int i = 0;i<result.size();i++){
				Map<String,Object> m = result.get(0);
				int size = ParamUtil.getInt(m, "total");
				retMap.put(ParamUtil.getLong(m, "account_id"), size > 0 ? true:false);
			}
		}
		return retMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<Long,Boolean> isWorkDayInSpecial(List<Long> accountIds,String dateNum) {
		 String hql = "select new Map(wts.orgAcconutID as account_id ,wts.isRest as is_rest) from WorkTimeSpecial as wts where wts.orgAcconutID in(:orgAcconutID) and wts.dateNum=:dateNum";
		 Map<String,Object> params = new HashMap<String,Object>();
		 params.put("orgAcconutID", accountIds);
		 params.put("dateNum", dateNum);

		 List<Map<String,Object>> result = DBAgent.find(hql.toString(),params);
		 Map<Long,Boolean> retMap = new HashMap<Long,Boolean>();
		 if(CollectionUtils.isNotEmpty(result)){
			 for(int i = 0;i<result.size();i++){
				Map<String,Object> m = result.get(0);
				int size = ParamUtil.getInt(m, "is_rest");
				retMap.put(ParamUtil.getLong(m, "account_id"), size > 0 ? true:false);
			}
		 }
		 return retMap;
	}

	@Override
	public Map<Long, Boolean> isSetInCurrency(List<Long> accountIds) {
		String hql = "select new Map(wtc.orgAcconutID as account_id,count(wtc.id) as total) from WorkTimeCurrency wtc where wtc.orgAcconutID in(:orgAcconutID) and wtc.isWork='1' group by wtc.orgAcconutID";
		Map<String,Object> params= new HashMap<String,Object>();
		params.put("orgAcconutID", accountIds);
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> result = DBAgent.find(hql.toString(),params);
		Map<Long,Boolean> retMap = new HashMap<Long,Boolean>();
		for(int i = 0;i<accountIds.size();i++){
			retMap.put(accountIds.get(i), false);
		}
		if(CollectionUtils.isNotEmpty(result)){
			for(int i = 0;i<result.size();i++){
				Map<String,Object> m = result.get(0);
				int size = ParamUtil.getInt(m, "total");
				retMap.put(ParamUtil.getLong(m, "account_id"), size > 0 ? true:false);
			}
		}
		return retMap;
	}

}
