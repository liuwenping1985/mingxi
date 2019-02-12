/**
 * Author shuqi
 * Rev 
 * Date: Feb 8, 2017 5:41:13 PM
 *
 * Copyright (C) 2017 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 * @since v5 v6.1
 */
package com.seeyon.apps.calendar.manager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.calendar.enums.ArrangeTimeEnum;
import com.seeyon.apps.calendar.enums.ArrangeTimeStatus;
import com.seeyon.apps.calendar.enums.TemplateEventEnum;
import com.seeyon.apps.calendar.po.CalEvent;
import com.seeyon.apps.calendar.po.TimeCompare;
import com.seeyon.apps.calendar.util.TimeArrangeUtil;
import com.seeyon.apps.calendar.vo.SyncTimeArrange;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.EdocSummaryComplexBO;
import com.seeyon.apps.meeting.api.MeetingApi;
import com.seeyon.apps.meeting.bo.MeetingBO;
import com.seeyon.apps.plan.api.PlanApi;
import com.seeyon.apps.plan.bo.PlanBO;
import com.seeyon.apps.taskmanage.api.TaskmanageApi;
import com.seeyon.apps.taskmanage.bo.TaskInfoBO;
import com.seeyon.apps.taskmanage.enums.TaskStatus;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.Strings;

/**
 * 时间安排（主要是时间视图、时间线取数据使用）
 * @Copyright 	Copyright (c) 2017
 * @Company 	seeyon.com
 * @since 		v5 v6.1
 * @author		shuqi
 */
public class TimeArrangeManagerImpl implements TimeArrangeManager{
	
	private static final Log logger = LogFactory.getLog(TimeArrangeManagerImpl.class);
    private TaskmanageApi                 	taskmanageApi;              	// 任务manager类
    private PlanApi                       	planApi;                  		// 计划manager
    private MeetingApi                    	meetingApi;               		// 会议manager
    private CollaborationApi              	collaborationApi;              	// 协同操作类
    private EdocApi                   		edocApi;                  		// 公文manager类
    private CalEventManager					calEventManager;
    
	public void setTaskmanageApi(TaskmanageApi taskmanageApi) {
		this.taskmanageApi = taskmanageApi;
	}
	public void setPlanApi(PlanApi planApi) {
		this.planApi = planApi;
	}
	public void setMeetingApi(MeetingApi meetingApi) {
		this.meetingApi = meetingApi;
	}
	public void setCollaborationApi(CollaborationApi collaborationApi) {
		this.collaborationApi = collaborationApi;
	}
	public void setEdocApi(EdocApi edocApi) {
		this.edocApi = edocApi;
	}
	public void setCalEventManager(CalEventManager calEventManager) {
		this.calEventManager = calEventManager;
	}
	
	@Override
	public List<TimeCompare> findTimeArrange(Date startDate, Date endDate, Long userId, List<ArrangeTimeEnum> apps, List<ArrangeTimeStatus> status, boolean isView) throws BusinessException {
		
		// 时间线会以配置的形式存在。可选数据。
		List<EdocSummaryComplexBO> edocs = Collections.emptyList(); // 公文
		List<PlanBO> plans = Collections.emptyList(); // 计划
		List<MeetingBO> meetings = Collections.emptyList(); // 会议
		List<TaskInfoBO> taskInfos = Collections.emptyList(); // 任务
		List<CalEvent> calEvents = Collections.emptyList(); // 事件
		List<ColSummaryVO> colSummaryVOs = Collections.emptyList(); // 协同
		for (ArrangeTimeEnum app : apps) {
			try {
				switch (app) {
					case plan:// 计划
						plans = findOtherPlan(startDate, endDate, userId,status);
						break;
					case meeting: // 会议
						meetings = findOtherMeeting(startDate, endDate, userId,status);
						break;
					case task: // 任务
						taskInfos = findOtherTask(startDate, endDate, userId,status);
						break;
					case calEvent:// 事件
						Map<String, Object> map = getViewORTimeLineMap(startDate, endDate, userId);
						map.put("status", status);
						calEvents = calEventManager.getAllCaleventView(map);
						break;
					case collaboration:// 协同
						colSummaryVOs = findOtherCollaboration(startDate, endDate, userId,status);
						break;
					case edoc:// 公文
						if(AppContext.hasPlugin("edoc")){
							edocs = findOtherEdoc(startDate, endDate, userId,status);
						}
						break;
					default:
						break;
				}
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
		}
		return TimeArrangeUtil.covert2TimeCompareAndSort(plans, taskInfos, meetings, calEvents, colSummaryVOs, edocs, isView);
	}
    private Map<String, Object> getViewORTimeLineMap(Date beginDate, Date endDate, Long curUserID) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("beginDate", beginDate);
        map.put("endDate", endDate);
        map.put("currentUserID", curUserID);
        return map;
    }
    
    /**
     *<p>获取计划数据</p>
     * @param startDate
     * @param endDate
     * @param userId
     * @param status
     * @return
     * @throws BusinessException
     * @date   Feb 9, 2017
     * @author shuqi
     * @since  v5 v6.1
     */
	private List<PlanBO> findOtherPlan(Date startDate,Date endDate,Long userId,List<ArrangeTimeStatus> status) throws BusinessException {
    	boolean isResourceCode = true;
    	if(AppContext.getCurrentUser() != null) {
    		isResourceCode = AppContext.getCurrentUser().hasResourceCode("F02_planListHome"); 
    	}
        if (AppContext.hasPlugin("plan") && isResourceCode) {
        	List<String> ss = new ArrayList<String>();
        	for (ArrangeTimeStatus s : status) {
        		ss.addAll(s.getPlanStatus());
			}
            return planApi.findPlans4Calendar(userId, startDate, endDate,ss);
        }
        return Collections.emptyList();
    }

	/**
	 *<p>获取任务数据</p>
	 * @param startDate
	 * @param endDate
	 * @param userId
	 * @param status
	 * @return
	 * @throws BusinessException
	 * @date   Feb 9, 2017
	 * @author shuqi
	 * @since  v5 v6.1
	 */
    private List<TaskInfoBO> findOtherTask(Date startDate, Date endDate, Long userId,List<ArrangeTimeStatus> status) throws BusinessException {
        boolean isResourceCode = true;
    	if(AppContext.getCurrentUser() != null) {
    		isResourceCode = AppContext.getCurrentUser().hasResourceCode("F02_taskPage"); 
    	}
        if (AppContext.hasPlugin("taskmanage") && isResourceCode) {
        	List<TaskStatus> ss = new ArrayList<TaskStatus>();
        	for (ArrangeTimeStatus s : status) {
        		ss.addAll(s.getTaskStatus());
			}
            return taskmanageApi.findTaskInfos(userId,startDate, endDate,ss);
        }
        return Collections.emptyList();
    }
    /**
     *<p>协同数据获取</p>
     * @param startDate
     * @param endDate
     * @param userId
     * @param status
     * @return
     * @throws BusinessException
     * @date   Feb 9, 2017
     * @author shuqi
     * @since  v5 v6.1
     */
    private List<ColSummaryVO> findOtherCollaboration(Date startDate, Date endDate, Long userId, List<ArrangeTimeStatus> status) throws BusinessException {
        if( (status.size() == 1 && status.get(0).equals(ArrangeTimeStatus.finshed)) || status.size() == 0){
        	return Collections.emptyList();
        }
    	if (AppContext.hasPlugin(TemplateEventEnum.COLLABORATION)) {
    		Map<String, Object> map = new HashMap<String, Object>();
			map.put("beginDate", startDate);
			map.put("endDate", endDate);
			map.put("currentUserID", userId);
            map.put("timeLineFlag", Boolean.TRUE);
            return collaborationApi.findMyPendingColByExpectedProcessTime(map);
        }
        return Collections.emptyList();
    }
    
    /**
     *<p>获取会议数据</p>
     * @param startDate
     * @param endDate
     * @param userId
     * @param status
     * @return
     * @throws BusinessException
     * @date   Feb 9, 2017
     * @author shuqi
     * @since  v5 v6.1
     */
	private List<MeetingBO> findOtherMeeting(Date startDate, Date endDate, Long userId, List<ArrangeTimeStatus> status) throws BusinessException {
		if (AppContext.hasPlugin(TemplateEventEnum.MEETING) && AppContext.getCurrentUser().hasResourceCode("F09_meetingPending")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("beginDate", startDate);
			map.put("endDate", endDate);
			map.put("currentUserID", userId);
			map.put("_notUserPage", "true");
			List<Integer> mtStates = new ArrayList<Integer>();
			for (ArrangeTimeStatus s : status) {
				mtStates.addAll(s.getMeetingStatus());
			}
			List<Integer> replystateList = new ArrayList<Integer>();
			replystateList.add(SubStateEnum.col_pending_unRead.key());
			replystateList.add(SubStateEnum.col_pending_read.key());
			replystateList.add(SubStateEnum.meeting_pending_join.key());
			replystateList.add(SubStateEnum.meeting_pending_pause.key());
			map.put("replystateList", replystateList);
			map.put("mtStates", mtStates);
			return meetingApi.findMeetings(ApplicationCategoryEnum.calendar, map);
		}
		return Collections.emptyList();
	}
    /**
     *<p>获取公文数据</p>
     * @param startDate
     * @param endDate
     * @param userId
     * @param status
     * @return
     * @throws BusinessException
     * @date   Feb 9, 2017
     * @author shuqi
     * @since  v5 v6.1
     */
    private List<EdocSummaryComplexBO> findOtherEdoc(Date startDate, Date endDate, Long userId, List<ArrangeTimeStatus> status) throws BusinessException {
        if( (status.size() == 1 && status.get(0).equals(ArrangeTimeStatus.finshed)) || status.size() == 0){
        	return Collections.emptyList();
        }
    	if (AppContext.hasPlugin(TemplateEventEnum.DOC)) {
    		Map<String, Object> map = new HashMap<String, Object>();
			map.put("beginDate", startDate);
			map.put("endDate", endDate);
			map.put("currentUserID", userId);
            return this.edocApi.findMyPendingEdocByExpectedProcessTime(map);
        }
        return Collections.emptyList();
    }
	@Override
	public List<SyncTimeArrange> syncTimeArrange(Date preSyncTime, Date endDate, long userId, List<ArrangeTimeEnum> apps,boolean isFirst) {
		// 时间线会以配置的形式存在。可选数据。
		List<ArrangeTimeStatus> status = ArrangeTimeStatus.findAll();
		//List<EdocSummaryComplexBO> edocs = Collections.emptyList(); // 公文
		List<PlanBO> plans = Collections.emptyList(); // 计划
		List<MeetingBO> meetings = Collections.emptyList(); // 会议
		List<TaskInfoBO> taskInfos = Collections.emptyList(); // 任务
		List<CalEvent> calEvents = Collections.emptyList(); // 事件
		//List<ColSummaryVO> colSummaryVOs = Collections.emptyList(); // 协同
		for (ArrangeTimeEnum app : apps) {
			try {
				switch (app) {
					case plan:// 计划
						plans = findOtherPlan(preSyncTime, endDate, userId,status);
						break;
					case meeting: // 会议
						meetings = findOtherMeeting(preSyncTime, endDate, userId,status);
						break;
					case task: // 任务
						taskInfos = findOtherTask(preSyncTime, endDate, userId,status);
						break;
					case calEvent:// 事件
						Map<String, Object> map = getViewORTimeLineMap(preSyncTime, endDate, userId);
						map.put("status", status);
						calEvents = calEventManager.getAllCaleventView(map);
						break;
					case collaboration:// 协同
						//colSummaryVOs = findOtherCollaboration(preSyncTime, endDate, userId,status);
						break;
					case edoc:// 公文
						if(AppContext.hasPlugin("edoc")){
							//edocs = findOtherEdoc(preSyncTime, endDate, userId,status);
						}
						break;
					default:
						break;
				}
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
		}
		//公文和协同的数据不同步
		return TimeArrangeUtil.covert2SyncTimeArrange(plans, taskInfos, meetings, calEvents, /*colSummaryVOs, edocs,*/preSyncTime,isFirst);
	}
	@Override
	public List<TimeCompare> findTimeArrange(Date startDate, Date endDate, Long userId, List<ArrangeTimeEnum> apps,
			List<ArrangeTimeStatus> status, boolean isView, String weekPlanType) throws BusinessException {
		// 时间线会以配置的形式存在。可选数据。
		List<EdocSummaryComplexBO> edocs = Collections.emptyList(); // 公文
		List<PlanBO> plans = Collections.emptyList(); // 计划
		List<MeetingBO> meetings = Collections.emptyList(); // 会议
		List<TaskInfoBO> taskInfos = Collections.emptyList(); // 任务
		List<CalEvent> calEvents = Collections.emptyList(); // 事件
		List<ColSummaryVO> colSummaryVOs = Collections.emptyList(); // 协同
		for (ArrangeTimeEnum app : apps) {
			try {
				switch (app) {
					case plan:// 计划
						plans = findOtherPlan(startDate, endDate, userId,status);
						break;
					case meeting: // 会议
						meetings = findOtherMeeting(startDate, endDate, userId,status);
						break;
					case task: // 任务
						taskInfos = findOtherTask(startDate, endDate, userId,status);
						break;
					case calEvent:// 事件
						Map<String, Object> map = getViewORTimeLineMap(startDate, endDate, userId);
						map.put("status", status);
						calEvents = calEventManager.getAllCaleventView(map);
						List<CalEvent> tempList = new ArrayList<CalEvent>(); 
						if(calEvents != null){
			        		for(CalEvent cal:calEvents){
			        			if(cal.getCalEventType()!=Integer.parseInt(weekPlanType)){
			        				tempList.add(cal);
			        			}
			        		}
			        	}
			        	calEvents.removeAll(tempList);
						break;
					case collaboration:// 协同
						colSummaryVOs = findOtherCollaboration(startDate, endDate, userId,status);
						break;
					case edoc:// 公文
						if(AppContext.hasPlugin("edoc")){
							edocs = findOtherEdoc(startDate, endDate, userId,status);
						}
						break;
					default:
						break;
				}
			} catch (Exception e) {
				logger.error(e.getLocalizedMessage(), e);
			}
		}
		return TimeArrangeUtil.covert2TimeCompareAndSort(plans, taskInfos, meetings, calEvents, colSummaryVOs, edocs, isView);
	}
    
    
}
