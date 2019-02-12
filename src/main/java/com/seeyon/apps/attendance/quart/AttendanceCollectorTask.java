/**
 * 
 * Author: xiaolin
 * Date: 2016年12月6日
 *
 * Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.apps.attendance.quart;

import java.text.MessageFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.attendance.AttendanceConstants.AttendanceQueryParam;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceStateEnum;
import com.seeyon.apps.attendance.AttendanceConstants.AttendanceType;
import com.seeyon.apps.attendance.manager.AttendanceCollectorManager;
import com.seeyon.apps.attendance.manager.AttendanceManager;
import com.seeyon.apps.attendance.po.AttendanceInfo;
import com.seeyon.apps.attendance.po.RptAttendance;
import com.seeyon.apps.attendance.po.RptWorkTime;
import com.seeyon.apps.attendance.utils.AttendanceUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.report.collector.manager.RptCollectorLogManager;
import com.seeyon.ctp.report.collector.manager.RptCollectorTask;
import com.seeyon.ctp.report.collector.po.RptCollectorLog;
import com.seeyon.ctp.report.enums.RptTypeEnum;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.v3x.worktimeset.domain.WorkTimeCurrency;

/**
 * <p>Title:考勤签到调度 </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: com.seeyon.apps.attendance.collect</p>
 * <p>since Seeyon V6.1</p>
 */
public class AttendanceCollectorTask implements RptCollectorTask{
	private Log logger = LogFactory.getLog(AttendanceCollectorTask.class);
	
	private AttendanceManager attendanceManager;
	
	private AttendanceCollectorManager attendanceCollectorManager;
	
	private OrgManager orgManager;
	
	private RptCollectorLogManager rptCollectorLogManager;
	
	private ConfigManager configManager;
	
	@Override
	public void runDayTask(Calendar endTime) {
		//系统管理员--是否启用考勤管理,启用才调度,未启用不进行调度
		String configValue = configManager.getConfigItem("system_switch", "card_enable").getConfigValue();
		if("enable".equals(configValue)){
			//调度存储签到信息
			attendanceAddTask();
			//调度存储工作时间情况
			workTimeAddTask();
		}
	}
	
	/**
	 *<p>存储调度信息到rpt_attendance,记录调度日志</p>
	 * @param  
	 * @return
	 * @throws
	 */
	private void attendanceAddTask() {
		try {
			if(isUpgrade("attendance")){
				//升级调度
				doAttendanceUpgrade();
			}else if(isQuart("attendance")){
				//日常调度
				doAttendanceRecently();
			}
		} catch (Exception e) {
			logger.error("存储考勤管理调度日志异常...",e);
		}
	}
	
	/**
	 * 升级调度
	 * @param 
	 * @return		
	 * @throws Exception 
	*/
	private void doAttendanceUpgrade() throws BusinessException {
		logger.info("***开始进行考勤升级调度...");
		//升级范围：从最早的签到时间开始到昨天，如果没有历史签到则取昨天1天做一次记录
		Date earlistDate = attendanceManager.getEarliestSigntime(null);
		Date today = Datetimes.getTodayFirstTimeNoTimeZone();
		if(earlistDate != null){
			while(earlistDate.compareTo(today) < 0){
				runAttendanceTask(earlistDate);
				earlistDate = DateUtil.addDay(earlistDate, 1);
			}
		}else{
			runAttendanceTask(DateUtil.addDay(today, -1));
		}
		logger.info("***完成考勤升级调度...");
	}

	/**
	 *<b>更新最近的数据</b><br>
	 *@since 6.1
	 *@date  2017年2月23日
	 *@throws Exception
	 */
	private void doAttendanceRecently() throws BusinessException{
		logger.info("***开始例行日常考勤调度...");
		RptCollectorLog log = rptCollectorLogManager.getLatestLog("attendance", null);
		Date recentTime = DateUtil.addDay(log.getQueryEndTime(), 1);
		Date today = Datetimes.getTodayFirstTimeNoTimeZone();
		while(recentTime.compareTo(today) < 0){
			runAttendanceTask(recentTime);
			recentTime = DateUtil.addDay(recentTime, 1);
		}
		logger.info("***完成例行日常考勤调度...");
	}
	
	/**
	 *<p>调度存储工作时间信息,记录调度日志</p>
	 * @param  
	 * @return
	 * @throws
	 */
	private void workTimeAddTask() {
		try {
			if(isUpgrade("worktime")){
				//升级调度
				doWorktimeUpgrade();
			}else if(isQuart("worktime")){
				//日常调度
				doWorktimeRecently();
			}
		} catch (Exception e) {
			logger.error("调度工作时间异常",e);
		}
	}
	
	/**
	 * 工作日升级调度,补全最早登录日期到现在的数据
	 * 全部按照当前升级时的工作时间进行升级
	 * @param 
	 * @return		
	 * @throws BusinessException 
	*/
	private void doWorktimeUpgrade() throws BusinessException {
		logger.info("...开始进行工作日升级调度...");
		
		//逻辑是 ： 从第一次签到开始升级工作时间
		Date earlistDate = attendanceManager.getEarliestSigntime(null);
		if(earlistDate == null){
			//如果从未签到，则至少把昨天的工作时间记录一个
			earlistDate = DateUtil.addDay(new Date(), -1);
		}
		
		runWorktimeTask(earlistDate);
		logger.info("...完成工作日升级调度...");
	}

	/**
	 *<b>调度最近的工作时间信息</b><br>
	 *@since 6.1
	 *@date  2017年2月23日
	 *@throws BusinessException
	 */
	private void doWorktimeRecently() throws BusinessException{
		logger.info("...开始日常考勤工作日调度");
		RptCollectorLog log = rptCollectorLogManager.getLatestLog("worktime", null);
		if(log != null){
			runWorktimeTask(DateUtil.addDay(log.getQueryEndTime(), 1));
		}
		logger.info("...完成日常考勤工作日调度");
	}
	
	/**
	 *<p>执行工作时间调度</p>
	 * @param  
	 * @return
	 * @throws
	 */
	private void runWorktimeTask(Date queryDate) throws BusinessException {
		String beginDateString = Datetimes.formatNoTimeZone(queryDate, Datetimes.dateStyle);
		logger.info(MessageFormat.format(">>>开始{0}到昨天的工作时间信息调度！", beginDateString));
		/**
    	 * 获取开始时间-结束时间中的所有日期
    	 */
    	try {
			List<Date> date = AttendanceUtil.getStartToEndDate(DateUtil.format(queryDate,DateUtil.YEAR_MONTH_DAY_PATTERN), 
					DateUtil.format(DateUtil.currentDate(),DateUtil.YEAR_MONTH_DAY_PATTERN));
			List<V3xOrgAccount> accounts = orgManager.getAllAccounts();
			//获取每个单位的工作时间设置,放在一个Map中
			Map<Long,WorkTimeCurrency> timeMap = new HashMap<Long,WorkTimeCurrency>();
			List<Long> accountIds = new ArrayList<Long>();
			if(CollectionUtils.isNotEmpty(accounts)){
				for(V3xOrgAccount account : accounts){
					if(!account.getIsGroup()){
						//非集团单位
						Long accountId = account.getId();
						accountIds.add(accountId);
						timeMap.put(accountId, AttendanceUtil.getWorkTime(accountId));
					}
				}
			}
			
			if(CollectionUtils.isNotEmpty(date)){
				RptCollectorLog log = getCollectLog(date.get(0));
				Long start = DateUtil.currentTimestamp().getTime();
				int success = RptCollectorLog.IS_FAIL;
				for(int i = 0;i<date.size();i++){
					try {
						List<RptWorkTime> data = new ArrayList<RptWorkTime>();
						String nowTimeString = Datetimes.formatNoTimeZone(date.get(i), Datetimes.dateStyle);
						logger.info(MessageFormat.format("正在记录{0}的工作时间！", nowTimeString));
						Date nowTime = Datetimes.parseNoTimeZone(nowTimeString, Datetimes.dateStyle);
						Map<Long,Boolean> isWorkDay = AttendanceUtil.isWorkDay(nowTime,accountIds);
						if(CollectionUtils.isNotEmpty(accounts)){
							for(V3xOrgAccount account : accounts){
								if(!account.getIsGroup()){
									//非集团单位
									RptWorkTime time = new RptWorkTime();
									time.setIdIfNew();
									Long accountId = account.getId();
									//获取单位的工作时间设置
									WorkTimeCurrency workTime = timeMap.get(accountId);
									//上班时间
									String amWorkTimeBeginTime = "09:00";
									//下班时间
									String pmWorkTimeEndTime = "18:00";
									if(workTime != null){
										amWorkTimeBeginTime = workTime.getAmWorkTimeBeginTime();
										pmWorkTimeEndTime = workTime.getPmWorkTimeEndTime();
									}
									time.setFixWorkTime(amWorkTimeBeginTime);;
									time.setFixEndTime(pmWorkTimeEndTime);
									time.setNowTime(nowTime);
									time.setAccountId(accountId);
									time.setWorkDay(isWorkDay.get(accountId));
									data.add(time);
								}
							}
						}
						attendanceCollectorManager.saveWorktimeList(data);
						success = RptCollectorLog.IS_SUCCESS;
					} catch (Exception e) {
						logger.error("调度工作时间异常",e);
					}
				}
				
				/**
				 * 记录工作时间调度日志
				 */
				Long end = DateUtil.currentTimestamp().getTime();
				log.setSpendTime(end-start);
				log.setQueryState(success);
				log.setQueryEndTime(date.get(date.size()-1));
				log.setCategory("worktime");
				log.setRptType(RptTypeEnum.DAY.name());
				rptCollectorLogManager.save(log);
			}
			logger.info(MessageFormat.format("<<<完成{0}到昨天的工作时间信息调度！", beginDateString));
    	} catch (ParseException e) {
    		logger.error("考勤工作日升级调度异常", e);
    	} catch (BusinessException e) {
    		logger.error("考勤工作日升级调度异常", e);
		}
	}




	
	/**
	 * <p>初始化调度数据</p>
	 * @param 
	 * @return		
	 * @throws Exception 
	*/
	private RptAttendance initRptAttendance(AttendanceInfo attendInfo,AttendanceInfo leaveInfo) throws Exception {
		RptAttendance rpt = new RptAttendance();
		Date attendTime = null,leaveTime = null;
		AttendanceInfo info = attendInfo;
		String attendFixTime = null;
		if(attendInfo != null ){
			/**
			 * 拥有签到信息,得到签到时间
			 */
			attendTime = attendInfo.getSignTime();
			//签到地址
			rpt.setAttendAddress(attendInfo.getSign());
			attendFixTime = attendInfo.getFixTime();
			info = attendInfo;
		}
		String leaveFixTime = "";
		if(leaveInfo != null){
			/**
			 * 拥有签退信息,得到签退时间
			 */
			leaveTime = leaveInfo.getSignTime();
			//签退地址
			rpt.setLeaveAddress(leaveInfo.getSign());
			leaveFixTime = leaveInfo.getFixTime();
			info = leaveInfo;
		}
		rpt.setIdIfNew();
		rpt.setAttendTime(attendTime);
		rpt.setLeaveTime(leaveTime);
		Date time = attendTime != null?attendTime:leaveTime;
		List<Long> accountIds = new ArrayList<Long>();
		accountIds.add(info.getAccountId());
		boolean isWorktime = AttendanceUtil.isWorkDay(time,accountIds).get(info.getAccountId());
		if(!isWorktime){
			//非工作日打卡
			rpt.setState(AttendanceStateEnum.restdk.getKey());
		}else{
			//计算打卡状态
			rpt.setState(state(info,attendTime,leaveTime,attendFixTime,leaveFixTime));
		}
		rpt.setAttendId(info.getOwnerId());
		rpt.setDeptId(info.getDeptId());
		rpt.setAccountId(info.getAccountId());
		rpt.setYear(info.getYear());
		rpt.setMonth(info.getMonth());
		rpt.setDay(info.getDay());
		rpt.setQueryTime(DateUtil.parse(DateUtil.format(info.getSignTime(),DateUtil.YEAR_MONTH_DAY_PATTERN)));
		rpt.setWorkDay(isWorktime);
		return rpt;
	}

	/**
	 * <p>Description: 检查是否已经从v6.0SP1升级到v6.1</p>
	 * <p>Description: 判断逻辑是：判断今年1月份是否执行过调度，如果是今年安装的系统就看安装月是否有调度，如果没有就做升级调度</p>
	 * @return 是否已经升级
	 * @throws BusinessException
	 * @since v5 v6.0
	 */
	private boolean isUpgrade(String category) throws BusinessException {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("category", category);
		return rptCollectorLogManager.checkExistLogByCategory(params);
	}
	
	/**
	 * 判断是否进行过调度,如果有则不再进行调度
	 * @param 
	 * @return
	 * @throws BusinessException 
	 * @throws ParseException 
	 */
	private boolean isQuart(String category) throws BusinessException, ParseException{
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("category", category);
		Calendar cal = Calendar.getInstance();
		cal.setTime(DateUtil.currentDate());
		params.put("year", cal.get(Calendar.YEAR));
		params.put("month", cal.get(Calendar.MONTH)+1);
		params.put("day", cal.get(Calendar.DAY_OF_MONTH)-1);
		return rptCollectorLogManager.checkExistLogByCategory(params);
	}
	
	
	/**
	 *<p>初始化log对象</p>
	 * @param  
	 * @return
	 * @throws
	 */
	private RptCollectorLog getCollectLog(Date queryDate) {
		RptCollectorLog log = new RptCollectorLog();
		log.setIdIfNew();
		log.setQueryDate(DateUtil.currentDate());
		log.setRunTime(DateUtil.currentDate());
		log.setQueryBeginTime(queryDate);
		log.setRptMonth(DateUtil.getMonth(queryDate));
		log.setRptYear(DateUtil.getYear(queryDate));
		log.setRptDay(DateUtil.getDay(queryDate));
		return log;
	}
	
	/**
	 *<p>执行考勤签到调度,需要区分单位,兼职人员在A单位签到,在B单位签退,A单位统计签到无签退,B单位统计签退无签到</p>
	 * @param  
	 * @return
	 * @throws
	 */
	private void runAttendanceTask(Date dateTime) throws BusinessException {
		//时间标记用于记录调度花费的时间 
		Long start = DateUtil.currentTimestamp().getTime();
		String dateString = Datetimes.formatNoTimeZone(dateTime, Datetimes.dateStyle);
		logger.info(MessageFormat.format(">>>开始{0}的考勤数据调度...", dateString));
		Date firsTime = Datetimes.parseNoTimeZone(Datetimes.getFirstTimeStr(dateString), Datetimes.datetimeStyle);
		Date lastTime = Datetimes.parseNoTimeZone(Datetimes.getLastTimeStr(dateString),Datetimes.datetimeStyle);
		RptCollectorLog log = getCollectLog(dateTime);
		int success = RptCollectorLog.IS_FAIL;
		try {
			Map<String,Object> params = new HashMap<String,Object>();
			
			params.put("startTime", firsTime);
			params.put("endTime", lastTime);
			/**
			 * 获取当天的签到信息,包含pc端签到,移动端签到
			 */
			List<Integer> type = new ArrayList<Integer>();
			type.add(AttendanceType.attend.getKey());
			params.put(AttendanceQueryParam.type.name(), type);
			List<AttendanceInfo> attendData = attendanceManager.findAttendanceInfo(params);
			Map<String,AttendanceInfo> attendMap = new HashMap<String,AttendanceInfo>();
			if(CollectionUtils.isNotEmpty(attendData)){
				for(AttendanceInfo info :attendData){
					attendMap.put(info.getOwnerId()+"|"+info.getAccountId(), info);
				}
			}
			/**
			 * 获取当天的签退信息,包含pc端签退和移动端签退
			 */
			type.clear();
			type.add(AttendanceType.leave.getKey());
			params.put(AttendanceQueryParam.type.name(), type);
			List<AttendanceInfo> leaveData = attendanceManager.findAttendanceInfo(params);
			Map<String,AttendanceInfo> leaveMap = new HashMap<String,AttendanceInfo>();
			if(CollectionUtils.isNotEmpty(leaveData)){
				for(AttendanceInfo info :leaveData){
					leaveMap.put(info.getOwnerId()+"|"+info.getAccountId(), info);
				}
			}
			List<RptAttendance> data = new ArrayList<RptAttendance>();
			/**
			 * 遍历签到的记录,初始化调度对象,如果存在签到人员的签退记录就清理掉,返回有签退但无签到的记录
			 */
			if(MapUtils.isNotEmpty(attendMap)){
				for(Map.Entry<String, AttendanceInfo> m : attendMap.entrySet()){
					String keyId = m.getKey();
					//签到
					AttendanceInfo attendInfo = m.getValue();
					//签退
					AttendanceInfo leaveInfo = null;
					if(leaveMap.containsKey(keyId)){
						//如果签到人员有签退记录
						leaveInfo = leaveMap.get(keyId);
						leaveMap.remove(keyId);
					}
					data.add(initRptAttendance(attendInfo,leaveInfo));
				}
			}
			/**
			 * 遍历有签退但无签到的记录
			 */
			if(MapUtils.isNotEmpty(leaveMap)){
				for(Map.Entry<String, AttendanceInfo> m : leaveMap.entrySet()){
					AttendanceInfo leaveInfo = m.getValue();
					data.add(initRptAttendance(null,leaveInfo));
				}
			}
			//批量存储
			attendanceCollectorManager.saveAttendanceList(data);
			//成功
			success = RptCollectorLog.IS_SUCCESS;
		} catch (Exception e) {
			logger.error("考勤管理调度异常...",e);
		}
		//时间标记用于记录调度花费的时间 
		Long end = DateUtil.currentTimestamp().getTime();
		log.setSpendTime(end-start);
		log.setQueryState(success);
		log.setQueryBeginTime(firsTime);
		log.setQueryEndTime(lastTime);
		log.setCategory("attendance");
		log.setRptType(RptTypeEnum.DAY.name());
		rptCollectorLogManager.save(log);
		logger.info(MessageFormat.format("<<<完成{0}的考勤数据调度...", dateString));
	}

	/**
	 * @throws Exception 
	 *<p>根据上下班打卡时间计算打卡状态</p>
	 * @param  
	 * @return
	 * @throws 
	 */
	private int state(AttendanceInfo info,Date attendTime, Date leaveTime,String attendFixTime,String leaveFixTime) throws Exception {
		int state = 0;
		int min=5;
		String kqmin=AppContext.getSystemProperty("kqsection.min");
		if(kqmin!=null&&!"".equals(kqmin)) {
			min=Integer.parseInt(kqmin);
		}
		if(attendTime != null && leaveTime == null){ //没有签退
			Date fixTime = DateUtil.parse(DateUtil.format(attendTime,DateUtil.YEAR_MONTH_DAY_PATTERN)+" "+attendFixTime);
			//客开  wfj 20180919  考勤工作正负几分钟 start
			 fixTime = new Date(fixTime.getTime() + min*60*1000);
			//客开  wfj 20180919  考勤工作正负几分钟 end
			int attend = attendTime.compareTo(fixTime);
			if(attend > 0){
				//迟到并下班未打卡
				state = AttendanceStateEnum.attendlateandleavendk.getKey();
			}else if(attend <= 0){
				//下班未打卡
				state = AttendanceStateEnum.leavendk.getKey();
			}
		}else if(attendTime == null && leaveTime != null){//没有签到
			Date fixTime = DateUtil.parse(DateUtil.format(leaveTime,DateUtil.YEAR_MONTH_DAY_PATTERN)+" "+leaveFixTime);
			//客开  wfj 20180919  考勤工作正负几分钟 start
			 fixTime = new Date(fixTime.getTime() - min*60*1000);
			//客开  wfj 20180919  考勤工作正负几分钟 end
			int leave = leaveTime.compareTo(fixTime);
			if(leave < 0){
				//上班未打卡并早退
				state = AttendanceStateEnum.attendndkandleaveearly.getKey();
			}else if(leave >= 0){
				//上班未打卡
				state = AttendanceStateEnum.attendndk.getKey();
			}
		}else{
			Date fixTime = DateUtil.parse(DateUtil.format(attendTime,DateUtil.YEAR_MONTH_DAY_PATTERN)+" "+attendFixTime);
			//客开  wfj 20180919  考勤工作正负几分钟 start
			fixTime = new Date(fixTime.getTime() + min*60*1000);
			int attend = attendTime.compareTo(fixTime);
			fixTime = DateUtil.parse(DateUtil.format(leaveTime,DateUtil.YEAR_MONTH_DAY_PATTERN)+" "+leaveFixTime);
			fixTime = new Date(fixTime.getTime() - min*60*1000);
			//客开  wfj 20180919  考勤工作正负几分钟 end
			int leave = leaveTime.compareTo(fixTime);
			if(attend <= 0 && leave < 0){
				//下班早退
				state = AttendanceStateEnum.leaveearly.getKey();
			}else if(attend <= 0 && leave >= 0){
				//正常上班
				state = AttendanceStateEnum.normal.getKey();
			}else if(attend > 0 && leave < 0){
				//上班迟到并早退
				state = AttendanceStateEnum.attendlateandleaveearly.getKey();
			}else if(attend > 0 && leave >= 0){
				//上班迟到
				state = AttendanceStateEnum.attendlate.getKey();
			}
		}
		return state;
	}

	@Override
	public void runMonthTask(Calendar endTime) {
		//考勤没有按月调度,无需实现
	}

	@Override
	public void runYearTask(Calendar endTime) {
		//考勤没有按年调度,无需实现
	}

	@Override
	public void runHalfOfYearTask(Calendar endTime) {
		//考勤没有按半年调度,无需实现
	}

	@Override
	public void runQuarterTask(Calendar endTime) {
		//考勤没有按季度调度,无需实现
	}

	@Override
	public int getOrder() {
		return -1;
	}

	public void setAttendanceManager(AttendanceManager attendanceManager) {
		this.attendanceManager = attendanceManager;
	}

	public void setAttendanceCollectorManager(
			AttendanceCollectorManager attendanceCollectorManager) {
		this.attendanceCollectorManager = attendanceCollectorManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setRptCollectorLogManager(
			RptCollectorLogManager rptCollectorLogManager) {
		this.rptCollectorLogManager = rptCollectorLogManager;
	}

	public void setConfigManager(ConfigManager configManager) {
		this.configManager = configManager;
	}

}
