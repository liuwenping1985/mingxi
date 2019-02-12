/**
 * $Author xiongfeifei$
 * $Rev$
 * $Date::                     $:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.apps.calendar.manager;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.BeanUtilsBean;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.agent.bo.AgentDetailModel;
import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.calendar.bo.CalEventBO;
import com.seeyon.apps.calendar.bo.CalEventInfoVO;
import com.seeyon.apps.calendar.dao.CalEventDao;
import com.seeyon.apps.calendar.enums.AlarmDateEnum;
import com.seeyon.apps.calendar.enums.ArrangeTimeEnum;
import com.seeyon.apps.calendar.enums.ArrangeTimeStatus;
import com.seeyon.apps.calendar.enums.CalEvent4Message;
import com.seeyon.apps.calendar.enums.EventSourceEnum;
import com.seeyon.apps.calendar.enums.NumberEnum;
import com.seeyon.apps.calendar.enums.PeriodicalEnum;
import com.seeyon.apps.calendar.enums.ShareTypeEnum;
import com.seeyon.apps.calendar.enums.StatesEnum;
import com.seeyon.apps.calendar.enums.TemplateEventEnum;
import com.seeyon.apps.calendar.enums.WeekEnum;
import com.seeyon.apps.calendar.event.CalEventAddEvent;
import com.seeyon.apps.calendar.event.CalEventUpdateEvent;
import com.seeyon.apps.calendar.po.CalContent;
import com.seeyon.apps.calendar.po.CalEvent;
import com.seeyon.apps.calendar.po.CalEventPeriodicalInfo;
import com.seeyon.apps.calendar.po.CalEventTran;
import com.seeyon.apps.calendar.po.CalReply;
import com.seeyon.apps.calendar.po.TimeCompare;
import com.seeyon.apps.calendar.util.CalendarNotifier;
import com.seeyon.apps.calendar.util.TimeArrangeUtil;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.apps.common.projectphaseevent.manager.ProjectPhaseEventManager;
import com.seeyon.apps.common.projectphaseevent.po.ProjectPhaseEvent;
import com.seeyon.apps.edoc.bo.EdocSummaryComplexBO;
import com.seeyon.apps.index.bo.AuthorizationInfo;
import com.seeyon.apps.index.bo.IndexInfo;
import com.seeyon.apps.index.manager.IndexEnable;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.index.util.IndexUtil;
import com.seeyon.apps.meeting.api.MeetingApi;
import com.seeyon.apps.meeting.bo.MeetingBO;
import com.seeyon.apps.peoplerelate.enums.RelationType;
import com.seeyon.apps.performancereport.api.PerformancereportApi;
import com.seeyon.apps.performancereport.enums.ReportsEnum;
import com.seeyon.apps.plan.api.PlanApi;
import com.seeyon.apps.plan.bo.PlanBO;
import com.seeyon.apps.plan.enums.TransferTypeEnum;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.apps.taskmanage.api.TaskmanageApi;
import com.seeyon.apps.taskmanage.bo.TaskInfoBO;
import com.seeyon.apps.taskmanage.enums.TaskStatus;
import com.seeyon.apps.taskmanage.util.MenuPurviewUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.quartz.QuartzHolder;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.report.chart2.bo.ChartBO;
import com.seeyon.ctp.report.chart2.bo.Legend;
import com.seeyon.ctp.report.chart2.bo.Title;
import com.seeyon.ctp.report.chart2.bo.Tooltip;
import com.seeyon.ctp.report.chart2.bo.serie.PieSerie;
import com.seeyon.ctp.report.chart2.bo.serie.SerieItem;
import com.seeyon.ctp.report.chart2.bo.style.ItemStyle;
import com.seeyon.ctp.report.chart2.bo.style.itemStyle.Label;
import com.seeyon.ctp.report.chart2.bo.style.itemStyle.Normal;
import com.seeyon.ctp.report.chart2.core.ChartRender;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.isearch.model.ConditionModel;
import com.seeyon.v3x.peoplerelate.domain.PeopleRelate;
import com.seeyon.v3x.peoplerelate.manager.PeopleRelateManager;
import com.seeyon.v3x.worktimeset.domain.WorkTimeCurrency;
import com.seeyon.v3x.worktimeset.exception.WorkTimeSetExecption;
import com.seeyon.v3x.worktimeset.manager.WorkTimeSetManager;

/**
 * Title: 事件对应的Manager实现类
 * Description: 代码描述
 * Copyright: Copyright (c) 2012
 * Company: seeyon.com
 */
public class CalEventManagerImpl implements CalEventManager, IndexEnable {
	private static final Log logger = LogFactory.getLog(CalEventManagerImpl.class);
	
    private EnumManager                   	enumManagerNew;               	// 系统枚举
    private CalEventDao                   	calEventDao;                  	// dao对象
    private ProjectApi                    	projectApi;               		// 调用项目对应的manager类
    private IndexManager                  	indexManager;                 	// 全文检索manager类
    private CollaborationApi              	collaborationApi;              	// 协同操作类
    private AffairManager                 	affairManager;
    private CalendarNotifier              	calendarNotifier;             	// 日程事件消息类
    private OrgManager                    	orgManager;                  	// 调用组织Manager
    private AttachmentManager             	attachmentManager;            	// 附件操作类
    private AppLogManager                 	appLogManager;                	// 日志操作类
    private PeopleRelateManager           	peopleRelateManager;          	// 关联人员
    private CalContentManager             	calContentManager;            	// 事件内容信息列表对应的Manager类——对事件的正文进行操作
    private CalReplyManager               	calReplyManager;              	// 事件回复信息列表Manager类
    private CalEventTranManager           	calEventTranManager;          	// 事件具体信息列表对应的Manager类
    private CalEventPeriodicalInfoManager 	calEventPeriodicalInfoManager; 	// 周期性事件
    private FileToExcelManager           	fileToExcelManager;           	// 导出excel Manager类
    private TaskmanageApi                 	taskmanageApi;              	// 任务manager类
    private PlanApi                       	planApi;                  		// 计划manager
    private MeetingApi                    	meetingApi;               		// 会议manager
    private WorkTimeSetManager            	workTimeSetManager;           	// 上班类manager
    private PerformancereportApi       	  	performancereportApi;      		// 穿透查询先进行权限判断
    private ProjectPhaseEventManager 		projectPhaseEventManager;       // 关联项目表操作栏
    private TimeArrangeManagerImpl			timeArrangeManager;
    
    
    public void setTimeArrangeManager(TimeArrangeManagerImpl timeArrangeManager) {
		this.timeArrangeManager = timeArrangeManager;
	}
	public void setProjectPhaseEventManager(ProjectPhaseEventManager projectPhaseEventManager) {
		this.projectPhaseEventManager = projectPhaseEventManager;
	}
	public void setPerformancereportApi(PerformancereportApi performancereportApi) {
		this.performancereportApi = performancereportApi;
	}
	public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }
    public void setPeopleRelateManager(PeopleRelateManager peopleRelateManager) {
        this.peopleRelateManager = peopleRelateManager;
    }
    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }
    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }
    public void setMeetingApi(MeetingApi meetingApi) {
        this.meetingApi = meetingApi;
    }
    public void setCalendarNotifier(CalendarNotifier calendarNotifier) {
        this.calendarNotifier = calendarNotifier;
    }
    public void setPlanApi(PlanApi planApi) {
        this.planApi = planApi;
    }
    public void setTaskmanageApi(TaskmanageApi taskmanageApi) {
        this.taskmanageApi = taskmanageApi;
    }
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }
    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }
    public void setCalEventPeriodicalInfoManager(CalEventPeriodicalInfoManager calEventPeriodicalInfoManager) {
        this.calEventPeriodicalInfoManager = calEventPeriodicalInfoManager;
    }
    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }
    public void setCalEventTranManager(CalEventTranManager calEventTranManager) {
        this.calEventTranManager = calEventTranManager;
    }
    public void setCalReplyManager(CalReplyManager calReplyManager) {
        this.calReplyManager = calReplyManager;
    }
    public void setCalContentManager(CalContentManager calContentManager) {
        this.calContentManager = calContentManager;
    }
    public void setCalEventDao(CalEventDao calEventDao) {
        this.calEventDao = calEventDao;
    }
    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }
    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
    public void setWorkTimeSetManager(WorkTimeSetManager workTimeSetManager) {
        this.workTimeSetManager = workTimeSetManager;
    }

	/**
     * 时间格式化字符串数组
     * @return
     */
    public static String[] getAllAndSDateDFormat() {
        String[] dateFormate = new String[4];
        dateFormate[0] = DateUtil.YEAR_MONTH_DAY_PATTERN;
        dateFormate[1] = DateUtil.YMDHMS_PATTERN;
        dateFormate[2] = "yyyy-MM-dd HH:mm:ss";
        dateFormate[3] = "yyyy-MM-dd HH:mm:ss.S";
        return dateFormate;
    }

    @Override
    public String ajaxGetEventName(long id) throws BusinessException {
        return getCalEventById(id).getSubject();
    }

    /**
     * 根据模块和时间类型取得开始和结束时间
     * @param appID 模块ID  计划为5 
     * @param beginDate 开始时间。
     * @param endDate 结束时间
     * @param dateType 是日期还是时间
     * @throws WorkTimeSetExecption 异常 
     * @throws Exception 异常
     */
    public void getDateForTypeAndModule(String appID, String beginDate, String endDate, String dateType,
            CalEvent calEvent) throws WorkTimeSetExecption, Exception {
        if (Strings.isNotBlank(appID) && appID.equals(ModuleType.plan.getValue())) {
            //计划
            String workBeginTime = "8", workEndTime = "18";
            if (AppContext.hasPlugin("worktimeset")) {
                WorkTimeCurrency workTimeCurrency = workTimeSetManager.findComnWorkTimeSet(AppContext.getCurrentUser()
                        .getLoginAccount());
                workBeginTime = workTimeCurrency.getAmWorkTimeBeginTime();//工作的上班时间
                workEndTime = workTimeCurrency.getPmWorkTimeEndTime();//工作的结束时间
            }
            if (("1").equals(dateType)) {
                //日期
                if (Strings.isNotBlank(beginDate) && Strings.isNotBlank(endDate)) {
                    beginDate = DateFormatUtils.ISO_DATE_FORMAT.format(beginDate);
                    endDate = DateFormatUtils.ISO_DATE_FORMAT.format(endDate);
                    //都有(去工作的上班和下班时间)
                    String startTime = beginDate + " " + workBeginTime;
                    calEvent.setBeginDate(Datetimes.parse(startTime));
                    //结束时间一致
                    String endTime = endDate + " " + workEndTime;
                    calEvent.setEndDate(Datetimes.parse(endTime));
                } else if (Strings.isBlank(beginDate) && Strings.isBlank(endDate)) {
                    getDateWithNull(calEvent, workBeginTime, workEndTime);
                } else if (Strings.isBlank(endDate)) {
                    //只有开始日期
                    beginDate = DateFormatUtils.ISO_DATE_FORMAT.format(beginDate);
                    String startTime = beginDate + " " + workBeginTime;
                    String endTime = beginDate + " " + workEndTime;
                    calEvent.setBeginDate(Datetimes.parse(startTime));
                    calEvent.setEndDate(Datetimes.parse(endTime));
                } else {
                    //只有结束日期
                    endDate = DateFormatUtils.ISO_DATE_FORMAT.format(endDate);
                    String startTime = endDate + " " + workBeginTime;
                    String endTime = endDate + " " + workEndTime;
                    calEvent.setBeginDate(Datetimes.parse(startTime));
                    calEvent.setEndDate(Datetimes.parse(endTime));
                }
            } else {
                //时间
                Date startDate, endCurDate;
                if (Strings.isNotBlank(beginDate) && Strings.isNotBlank(endDate)) {
                    //都有(直接取)
                    startDate = DateUtil.parse(beginDate, DateUtil.YMDHMS_PATTERN);//转换为年月日的时间类型
                    calEvent.setBeginDate(startDate);
                    //结束时间一致
                    endCurDate = DateUtil.parse(endDate, DateUtil.YMDHMS_PATTERN);//转换为年月日的时间类型
                    calEvent.setEndDate(endCurDate);
                } else if (Strings.isBlank(beginDate) && Strings.isBlank(endDate)) {
                    //都没有
                    getDateWithNull(calEvent, workBeginTime, workEndTime);
                } else if (Strings.isBlank(beginDate)) {
                    //只有结束日期
                    endCurDate = DateUtil.parse(endDate, DateUtil.YMDHMS_PATTERN);//转换为年月日的时间类型
                    calEvent.setEndDate(endCurDate);
                    calEvent.setBeginDate(Datetimes.addMinute(endCurDate, -30));//开始时间提前半个小时
                } else {
                    //只有开始日期
                    startDate = DateUtil.parse(beginDate, DateUtil.YMDHMS_PATTERN);//转换为年月日的时间类型
                    calEvent.setBeginDate(startDate);
                    calEvent.setEndDate(Datetimes.addMinute(startDate, 30));//开始时间提前半个小时
                }
            }
        } else { //协同转事件  ---事件本身的创建            
            setHalfMinite(beginDate, calEvent);
        }
    }

    public void setHalfMinite(String beginDate, CalEvent calEvent) throws BusinessException {
        Calendar calendar = new GregorianCalendar(); // 以下几步操作是求整半点，原因是事件只能是半点显示
        Date curDate = calendar.getTime();
        if (Strings.isNotBlank(beginDate)) {
            try {
                curDate = Datetimes.parse(beginDate, Datetimes.datetimeStyle);
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage(),e);
            }
        }
        calendar.setTime(curDate); // 得到开始时间
        int minute = calendar.get(Calendar.MINUTE); // 得到开始时间的分钟数
        if(minute <= 15) {// 如果开始时间的分钟数小于或等于15，则需要将开始时间赋值为15
            calendar.set(Calendar.MINUTE, 15);
        } else if (minute > 15 && minute <= 30) { // 如果开始时间的分钟数小于30，则需要将开始时间赋值为30
            calendar.set(Calendar.MINUTE, 30);
        } else if (minute > 30 && minute <= 45) { // 如果开始时间的分钟数小于30，则需要将开始时间赋值为30
            calendar.set(Calendar.MINUTE, 45);
        } else { // 反之，则是下一个小时整点
            int hour = calendar.get(Calendar.HOUR); // 得到开始时间的小时数
            calendar.set(Calendar.HOUR, hour + 1); // 小一个小时的整点显示
            calendar.set(Calendar.MINUTE, 0); // 设置开始时间的分钟数为0
        }
        calEvent.setBeginDate(calendar.getTime());
        calEvent.setEndDate(Datetimes.addMinute(calEvent.getBeginDate(), 30));
    }

    /**
     * 计划转事件都没有的情况  --------即都没有传开始时间也没有传结束时间 或者开始日期和结束日期都没有传
     * @param calEvent 事件对象
     * @param workBeginTime 上班时间 格式：8：00
     * @param workEndTime 下班时间 格式：18：00
     * @throws BusinessException 
     */
    private void getDateWithNull(CalEvent calEvent, String workBeginTime, String workEndTime) throws BusinessException {
        PlanBO plan = null;
        if (calEvent.getFromType().intValue() == ApplicationCategoryEnum.plan.getKey()) {
            if (AppContext.hasPlugin(TemplateEventEnum.PLAN)) {
                plan = this.planApi.getPlan(calEvent.getFromId());
            }
            if (plan != null && (calEvent.getBeginDate() == null || calEvent.getEndDate() == null)) {
                String startTime = DateFormatUtils.format(plan.getStartTime(), getAllAndSDateDFormat()[0]);
                startTime = startTime + " " + workBeginTime;
                calEvent.setBeginDate(Datetimes.parse(startTime));
                String endTime = DateFormatUtils.format(plan.getEndTime(), getAllAndSDateDFormat()[0]);
                endTime = endTime + " " + workEndTime;
                calEvent.setEndDate(Datetimes.parse(endTime));
            }
        }
    }

    /**
     * 保存个人事件 如果事件已经存在,该方法就是修改个人事件 同时这个方法在保存的时候给事件创建了对应的索引和写入的日志信息
     * 
     * @param calEvent 事件对象
     * @param isNew 是不是做保存操作有可能是修改 isNew =true 就是执行保存操作 =false 就是修改操作
     * @return 该对象的ID
     * @throws BusinessException异常
     */
    private Long save(CalEvent calEvent, CalEvent oldCalEvent) throws BusinessException {
        toSendCalEventMessage(calEvent, oldCalEvent);
        if (oldCalEvent == null) { // 是否执行的是保存操作还是修改操作
            this.calEventDao.saveCalEvent(calEvent); // 执行保存操作
        } else { // 执行修改操作
            this.calEventDao.updateCalEvent(calEvent); // 执行修改操作
        }
        return calEvent.getId(); // 保存操作后一般需要得到当前对象的ID
    }

    private void toSendCalEventMessage(CalEvent calEvent, CalEvent oldCalEvent) throws BusinessException {
        AppLogAction appLogAction = AppLogAction.Calendar_New;
        if (oldCalEvent != null) {
            appLogAction = AppLogAction.Calendar_Update; // 修改
        }
        appLogManager.insertLog(AppContext.getCurrentUser(), appLogAction, AppContext.getCurrentUser().getName(), calEvent.getSubject()); // 保存日志
        if (AppContext.hasPlugin("index")) {// 更新索引
            if (oldCalEvent == null) { // 创建索引
                indexManager.add(calEvent.getId(), ApplicationCategoryEnum.calendar.getKey());
            } else {
                indexManager.update(calEvent.getId(), ApplicationCategoryEnum.calendar.getKey());
            }
        }
        String messageType = getCalEventMegStr(calEvent, oldCalEvent).toString();
        calendarNotifier.sendNotifierMessageInsert(messageType, oldCalEvent, calEvent); // 发送消息
    }

    @Override
    public CalEvent getCalEventById(Long calEventID) throws BusinessException {
        CalEvent calEvent = calEventDao.getCalEvent(calEventID);
        return calEvent;
    }

    /**
     * 根据主键删除事件 ---同时逐个提示消息
     * 
     * @param id事件ID
     * @throws BusinessException
     *             BusinessException异常
     */
    private void deleteCalEventByIds(List<CalEvent> calEvents) throws BusinessException {
        String messageType = String.valueOf(CalEvent4Message.P_ON_DELETE.getKey());
//        String handleName = AppContext.getCurrentUser().getName();
        for (CalEvent calEvent : calEvents) {
            calendarNotifier.sendNotifierMessageInsert(messageType, null, calEvent);
            QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + calEvent.getId());
//            appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Calendar_Delete, handleName,
//                    calEvent.getSubject()); // 保存日志
        }

        this.calEventDao.deleteCalEvent(calEvents); // 执行删除操作

    }

    /**
     * 根据事件ID列表得到事件对象列表
     * 
     * @param calEventIds 事件ID列表
     * @return 根据事件ID列表得到事件对象列表
     * @throws BusinessException
     */
    private List<CalEvent> getCalEventByIds(List<Long> calEventIds) throws BusinessException {
        return this.calEventDao.getCalEventByIds(calEventIds);
    }

    /**
     * 根据事件ID得到周期性事件的周期性信息
     * 
     * @param calEventID 事件ID
     * @return
     * @throws BusinessException
     */
    private CalEventPeriodicalInfo getPeriodicalInfoByCalEventId(Long calEventID) throws BusinessException {
        return calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(calEventID);
    }

    /**
     * ----计划/会议/日程——模块主页---个人事件---获取所有的个人事件
     * 
     * @param calEvent 日程事件对象
     * @return 满足条件事件列表
     * @throws BusinessException 异常
     */
    private FlipInfo getMyOwnList(CalEvent calEvent, FlipInfo fi) throws BusinessException {
        return calEventDao.getMyOwnList(calEvent, fi);
    }
    @SuppressWarnings("unchecked")
	@Override
    public FlipInfo getMyOwnCalEventInfoBO(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException {
        FlipInfo calEvents = new FlipInfo(); // 分页对象
        String search = (String) params.get("search"); // 这个参数主要区分两种，all全部共享department部门other他人
        CalEvent calEvent = new CalEvent(); // 根据页面的选择条件拼接一个calEvent对象，传到后台
        String subject = (String) params.get("subject"); // 标题
        if (Strings.isNotBlank(subject)) {
            calEvent.setSubject(subject);
        }
        String signifyType = (String) params.get("signifyType"); // 重要程度
        if (Strings.isNotBlank(signifyType)) {
            calEvent.setSignifyType(Integer.valueOf(signifyType));
        }
        String beginDate = (String) params.get("beginDate"); // 开始时间
        String endDate = (String) params.get("endDate"); // 结束时间
        if (Strings.isNotBlank(beginDate)) { // 如果用户不输入时间，就默认一个时间，进行检索
            calEvent.setBeginDate(Datetimes.parse(beginDate));
        }

        if (Strings.isNotBlank(endDate)) { // 如果用户不输入时间，就默认一个时间，进行检索
            calEvent.setEndDate(DateUtils.addSeconds(
                    DateUtils.addDays(Datetimes.parse(endDate), 1), -1));
        }
        String states = (String) params.get("states"); // 状态
        if (Strings.isNotBlank(states)) {
            calEvent.setStates(Integer.valueOf(states));
        }
        String createUserID = String.valueOf(params.get("createUserID")); // 创建者
        if (Strings.isNotBlank(search)) { // 共享事件 这个参数主要区分两种，all全部共享department部门
            String receiveMemberName = null;
            if (params.get("createUsername") != null) {
                receiveMemberName = params.get("createUsername").toString();
                if (Strings.isNotBlank(receiveMemberName)) {
                    calEvent.setReceiveMemberName(receiveMemberName);
                }
            }
            if (("all").equals(search)) { // 全部共享
                calEvents.setData(this.getAllShareEvent(flipInfo, calEvent));
            } else if (("project").equals(search)) { // 项目共享
                calEvents.setData(this.getAllProjectEvents(flipInfo, calEvent));

            } else if (("department").equals(search)) { // 部门共享
                if (params.get("swithDepartMentID") != null
                        && Strings.isNotBlank(params.get("swithDepartMentID").toString())) {
                    calEvent.setFromId(Long.valueOf(params.get("swithDepartMentID").toString()));
                }                
                this.getAllDepartMentEvents(flipInfo, AppContext.getCurrentUser(), calEvent);
                calEvents = flipInfo;
            } else { // portal值的初始化列表
                Integer count = null; // 用于放首页portal他人事件用户选择的行数
                if (!("other").equals(search)) {
                    calEvent.setCreateUserId(Long.valueOf(search));
                }
                String tranMemberIds = (String) params.get("tranMemberIds"); // 首页portal
                if (Strings.isNotBlank(tranMemberIds)) { // 选多人查询
                    calEvent.setTranMemberIds(tranMemberIds);
                }
                String dataSource = (String) params.get("dataSource"); // 这里的这个参数是区分到底是日程事件——他人事件还是他人事件portal
                if (Strings.isNotBlank(dataSource)) {
                    if (params.get("fiCount") != null && Strings.isNotBlank(params.get("fiCount").toString())) {
                        count = Integer.valueOf(params.get("fiCount").toString()); // 将用户选择的行数放入他人事件查询sql中
                    }
                }
                this.getAllOtherEvent(flipInfo, calEvent, count);
                calEvents = flipInfo;
            }
        } else { // 个人事件列表
            if (Strings.isNotBlank(createUserID)) { // 创建者
                calEvent.setCreateUserId(Long.valueOf(createUserID));
            }
            String workType = (String) params.get("workType");// 工作类型
            if (Strings.isNotBlank(workType)) {
                calEvent.setWorkType(Integer.valueOf(workType));
            }
            String calEventType = (String) params.get("calEventType");// 事件类型(0.业务1.管理 2.个人 3.其它 )
            if (Strings.isNotBlank(calEventType)) {
                calEvent.setCalEventType(Integer.valueOf(calEventType));
            }
            calEvents = getMyOwnList(calEvent, flipInfo);// 检索列表
        }
        List<CalEventInfoVO> calEventInfoBOs = getCalEventInfoBO(calEvents.getData());
        flipInfo.setData(calEventInfoBOs);
        return flipInfo;
    }

    /**
     * 将数据库检索出来的列表封装为页面事件对象
     * 
     * @param calEvents 数据库检索列表
     * @return 页面元素列表
     */
    private List<CalEventInfoVO> getCalEventInfoBO(List<CalEvent> calEvents) throws BusinessException {
    	if (CollectionUtils.isEmpty(calEvents)) {
    		return Collections.emptyList();
    	}
        List<CalEventInfoVO> vos = new ArrayList<CalEventInfoVO>();
        for (CalEvent calEvent : calEvents) {
            CalEventInfoVO vo = new CalEventInfoVO();// 页面BO对象
            if (Strings.isBlank(calEvent.getReceiveMemberId())) {
                calEvent.setReceiveMemberId(null);
            }
            vo.setCalEvent(calEvent);
            vo.setSignifyType(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType,calEvent.getSignifyType().toString())); // 重要程度
            vo.setCalEventType(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_type, calEvent.getCalEventType().toString())); // 事件类型
            V3xOrgMember orgMember = Functions.getMember(calEvent.getCreateUserId());
            //单位
            vo.setAccountName(Functions.showOrgAccountName(calEvent.getAccountID()));
            //部门
            if(orgMember != null) {
                V3xOrgDepartment department= Functions.getDepartment(orgMember.getOrgDepartmentId());
                vo.setDepartMentName(department != null ? department.getName() : "");
            }
            //职务
            vo.setPostName(Functions.showMemberLeave(calEvent.getCreateUserId()));
            CalContent calContent = this.calContentManager.getCalContentByEventId(calEvent.getId()); // 事件内容
            vo.setCalContent(calContent);
            vos.add(vo);
        }
        return vos;
    }

    @Override
    public CalEventInfoVO toCalEventVO(CalEvent calEvent) throws BusinessException {
        CalEvent calEventDB = null;
        CalEventInfoVO calEventInfoVO = new CalEventInfoVO();
        try {
            calEventDB = (CalEvent) BeanUtils.cloneBean(calEvent); // 事件对象
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        if (calEventDB != null) {
            if (Strings.isBlank(calEventDB.getReceiveMemberId())) {
                calEventDB.setReceiveMemberName(ResourceUtil.getString("calendar.event.create.person"));
            }
            calEventInfoVO.setCalEvent(calEventDB);
            CalContent calContent = this.calContentManager.getCalContentByEventId(calEventDB.getId()); // 事件内容
            calEventInfoVO.setCalContent(calContent);
            CalEventPeriodicalInfo calEventPeriodicalInfo = this.calEventPeriodicalInfoManager
                    .getPeriodicalEventBycalEventID(calEventDB.getId());
            if (calEventDB.getPeriodicalChildId() != null && calEventPeriodicalInfo == null) {
                calEventPeriodicalInfo = this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(calEventDB
                        .getPeriodicalChildId());
            }
            List<Attachment> attachments = calEventDB.getAttachmentsFlag() ? attachmentManager.getByReference( // 附件
                    calEventDB.getId(), calEventDB.getId()) : null;
            if (CollectionUtils.isNotEmpty(attachments)) {
                calEventInfoVO.setSize(attachments.size());
            }
            if (calEventPeriodicalInfo == null) {
                calEventPeriodicalInfo = new CalEventPeriodicalInfo();
                calEventPeriodicalInfo.setBeginTime(Calendar.getInstance().getTime());
                calEventPeriodicalInfo.setEndTime(Calendar.getInstance().getTime());
            }
            calEventInfoVO.setCalEventPeriodicalInfo(calEventPeriodicalInfo);
            calEventInfoVO.setAttachmentsJSON(attachmentManager.getAttListJSON4JS(calEventDB.getId()));
            ProjectBO calPrj = null;
            if (calEventDB.getShareType() == ShareTypeEnum.projectOfEvent.getKey()) { // 项目事件 选任界面一个异常。getTranMemberIds这个参数只能以Member|xx形式存在。否则就要设置null
                calEventDB.setShareTarget(calEventDB.getTranMemberIds());
                Long ProjectId=Long.parseLong(calEventDB.getShareTarget());
                calPrj = this.projectApi.getProject(ProjectId);//suyu获取当前事件的项目事件
                calEventDB.setTranMemberIds(null);
                AppContext.putRequestContext("calPrj", calPrj);
            }
            List<ProjectBO> pSummaries = getAllProject();
            calEventInfoVO.setProjectList(pSummaries); // 关联项目列表
            List<CalReply> cReplies = this.calReplyManager.getReplyListByEventId(calEventDB.getId());
            for (CalReply calReply : cReplies) { // 加载回复信息
                calReply.setReplyUserName(Functions.showMemberName(calReply.getReplyUserId())); // 回复人
            }
            calEventInfoVO.setCalReplies(cReplies);
            if (calEventDB.getFromId() != null && calEventDB.getFromType() != null) { // 协同、计划转事件用到的属性
                if (calEventDB.getFromType().intValue() == ApplicationCategoryEnum.collaboration.getKey()) { // 协同
                    hanaleCtpAffair(calEventDB, calEventInfoVO, Boolean.TRUE,Boolean.FALSE);
                }  else if (Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocSend.getKey())
                        || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocRec.getKey())
                        || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocSign.getKey()) 
                        || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.exSend.getKey()) 
                        || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.exSign.getKey()) 
                        || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocRegister.getKey())
                        || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocRecDistribute.getKey())) {
                    hanaleCtpAffair(calEvent, calEventInfoVO, Boolean.TRUE, Boolean.TRUE);
                    AppContext.putRequestContext("isEdoc", "1");
                } else if (calEventDB.getFromType().intValue() == ApplicationCategoryEnum.plan.getKey()) { // 计划
                    if (AppContext.hasPlugin("plan")) {
                        PlanBO plan = planApi.getPlan(calEventDB.getFromId());
                        if (plan == null) {
                            calEventInfoVO.setHasDeletePlan("yes");
                        } else {
                            calEventInfoVO.setPlan(plan);
                        }
                    }
                }
            }
        }

        AppContext.putRequestContext("calEventInfoBO", calEventInfoVO);  
        return calEventInfoVO;
    }

    /**
     * 协同代理人处理逻辑
     * @param calEventDB 事件对象
     * @param calEventInfoBO
     * @param isView 用户是新建还是查看、新建即只会isView=false
     * @throws BusinessException
     */
    private void hanaleCtpAffair(CalEvent calEventDB, CalEventInfoVO calEventInfoBO, Boolean isView, Boolean isEdoc)
            throws BusinessException {
        if (AppContext.hasPlugin(TemplateEventEnum.COLLABORATION) || AppContext.hasPlugin(TemplateEventEnum.DOC)) {
            CtpAffair ctpAffair = affairManager.get(calEventDB.getFromId());
            if (isView && ctpAffair != null) {
                if (!isValid(calEventDB.getCreateUserId(), ctpAffair, isEdoc)) {
                    calEventInfoBO.setHasDeleteAffair("cancelAgent");
                }
                if (ctpAffair.isDelete() || ctpAffair.getState().intValue() == 5
                        || ctpAffair.getState().intValue() == 6 || ctpAffair.getState().intValue() == 7) {
                    calEventInfoBO.setHasDeleteAffair("yes");
                }
            }
            if (null != ctpAffair) {
                calEventInfoBO.setCtpAffair(ctpAffair);
                String showTitle = "";
                if(Boolean.TRUE.equals(isEdoc)) {
                    showTitle = ctpAffair.getSubject();
                } else {
                    ColSummary summaryObj = collaborationApi.getColSummary((Long) ctpAffair.getObjectId());
                    showTitle = ColUtil.showSubjectOfSummary(summaryObj, Boolean.FALSE, -1, null);
                }
                AppContext.putRequestContext("showTitle", showTitle);
            } else {
            	calEventInfoBO.setHasDeleteAffair("yes");
            }
        }
    }

    /**
     * 协同组提供的代理是否有效的方法--（母军）
     * @param createUserID 事件的创建人
     * @param ctpAffair 协同对象
     * @return true 代理有效 false 代理无效
     */
    public boolean isValid(Long createUserID, CtpAffair affair, Boolean isEdoc) {
        boolean flag = true;
    	if (!createUserID.equals(affair.getMemberId())) {
            List<AgentModel> agentModelList = MemberAgentBean.getInstance().getAgentModelToList(affair.getMemberId());
            Long curAgentIDLong = MemberAgentBean.getInstance().getAgentMemberId(
                    ApplicationCategoryEnum.collaboration.ordinal(), affair.getMemberId());
            if(isEdoc) {
                curAgentIDLong = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.ordinal(), affair.getMemberId());
            }
            if (createUserID.equals(curAgentIDLong)) {
                Long templateId = affair.getTempleteId();
                AgentModel model = null;
                for (AgentModel m : agentModelList) {
                    if (m.getAgentId().equals(createUserID)) {
                        model = m;
                    }
                }
                List<AgentDetailModel> details = model.getAgentDetail();
                if (!(model.isHasCol() && model.isHasTemplate() && CollectionUtils.isEmpty(details))) {
                    boolean c = model.isHasCol();
                    boolean t = model.isHasTemplate();

                    if (c && !t) { //仅自由协同
                        if (templateId != null) {
                        	flag = false;
                        }
                    } else if (t && !c) { //仅模板
                        if (Strings.isEmpty(details)) {
                            if (templateId == null) {
                            	flag = false;
                            }
                        } else {
                            //指定模板
                            List<Long> templateIds = new ArrayList<Long>();
                            for (AgentDetailModel agentDetailModel : details) {
                                templateIds.add(agentDetailModel.getEntityId());
                            }
                            if (templateId == null) {
                                flag = false;
                            } else {
                                if (!templateIds.contains(templateId)) {
                                    flag = false;
                                }
                            }
                        }
                    } else if (t && c) { //自由协同+部分模板协同
                        List<Long> templateIds = new ArrayList<Long>();
                        if (Strings.isNotEmpty(details)) {
                            for (AgentDetailModel agentDetailModel : details) {
                                templateIds.add(agentDetailModel.getEntityId());
                            }
                        }
                        if (templateId != null && !templateIds.contains(templateId)) {
                        	flag = false;
                        }
                    }
                }
            } else {
                flag = false;
            }
        }
    	return flag;
    }

    @Override
    public CalEventInfoVO getAEmptyCalEvent(CalEvent calEvent) throws BusinessException {
        CalEventInfoVO calEventInfoBO = new CalEventInfoVO();
        CalEventPeriodicalInfo calEventPeriodicalInfo = new CalEventPeriodicalInfo();
        calEvent.setCalEventType(5); // 事件类型
        calEvent.setId(-1l); // 给ID赋值
        calEvent.setStates(0); // 状态
        calEvent.setWorkType(1); // 工作类型
        calEvent.setAlarmDate(0l); // 提前提醒
        calEvent.setBeforendAlarm(0l); // 结束前提醒
        calEvent.setRealEstimateTime(0.0f); // 实际用时
        if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 事件是委托、安排事件
            List<Long> receiveMemberIds = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId());
            StringBuilder receiveMemberNameSBuffer = new StringBuilder();
            for (int i = 0, receiveMemberIdInt = receiveMemberIds.size(); i < receiveMemberIdInt; i++) {
                receiveMemberNameSBuffer.append(Functions.showMemberName(receiveMemberIds.get(i)));
                if (i != receiveMemberIdInt - 1) {
                    receiveMemberNameSBuffer.append("、");
                }
            }
            calEvent.setReceiveMemberName(receiveMemberNameSBuffer.toString()); // 被安排、被委托的人名
        }
        calEventInfoBO.setCalEvent(calEvent);
        calEventPeriodicalInfo.setPeriodicalType(0); // 周期性事件类型
        calEventInfoBO.setCalEventPeriodicalInfo(calEventPeriodicalInfo);
        calEventPeriodicalInfo.setBeginTime(calEvent.getBeginDate()); // 开始时间——周期性事件
        calEventPeriodicalInfo.setEndTime(calEventPeriodicalInfo.getBeginTime()); // 结束时间——周期性事件
        List<ProjectBO> pSummaries = getAllProject();
        calEventInfoBO.setProjectList(pSummaries); // 关联项目列表
        if (calEvent.getFromId() != null) { // 协同、计划转事件用到的页面属性
            if (Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.collaboration.getKey())) { // 协同
                hanaleCtpAffair(calEvent, calEventInfoBO, Boolean.FALSE, Boolean.FALSE);
            } else if (Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocSend.getKey())
                    || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocRec.getKey())
                    || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocSign.getKey()) 
                    || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.exSend.getKey()) 
                    || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.exSign.getKey()) 
                    || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocRegister.getKey())
                    || Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.edocRecDistribute.getKey())) {
                hanaleCtpAffair(calEvent, calEventInfoBO, Boolean.FALSE, Boolean.TRUE);
                AppContext.putRequestContext("isEdoc", "1");
            } else if (Strings.equals(calEvent.getFromType(), ApplicationCategoryEnum.plan.getKey())) { // 计划
                if (AppContext.hasPlugin("plan")) {
                    calEventInfoBO.setPlan(this.planApi.getPlan(calEvent.getFromId()));
                }
            }
        }
        return calEventInfoBO;
    }

    /**
     * 得到所有的项目事件
     * 
     * @return 得到所有的项目事件
     * @throws BusinessException
     */
    private List<ProjectBO> getAllProject() throws BusinessException {
        List<ProjectBO> pSummaries = new ArrayList<ProjectBO>();
        ProjectBO pSummary = new ProjectBO(); // 默认加上一个”请选择项目“
        pSummary.setId(0l); // 设置”请选择项目“的ID为0，这个参数是约定的
        pSummary.setProjectName(ResourceUtil.getString("calendar.event.create.project.name")); // ”请选择项目“
        pSummaries.add(pSummary); // 将”请选择项目“增加到项目列表中
        if (AppContext.hasPlugin("project")) {
            pSummaries.addAll(this.projectApi.findProjectsByMemberId(AppContext.currentUserId()));
        }
        return pSummaries;
    }

    /**
     * 保存事件内容
     * 
     * @param calContent 事件内容对象
     * @throws BusinessException
     */
    private void saveCalContent(CalContent calContent) throws BusinessException {
        this.calContentManager.save(calContent);
    }

    /**
     * 保存周期性事件对象,返回当前的对象的ID
     * 
     * @param calEventPeriodicalInfo 周期性事件对象
     * @return ID
     * @throws BusinessException
     */
    private Long saveCalEventPeriodicalInfo(CalEventPeriodicalInfo calEventPeriodicalInfo) throws BusinessException {
        return this.calEventPeriodicalInfoManager.saveOrUpdate(calEventPeriodicalInfo, Boolean.TRUE);

    }

    /**
     * 根据项目ID得到项目
     * 
     * @param projectId 项目ID
     * @return 根据项目ID得到项目名称
     * @throws BusinessException
     */
    private ProjectBO getProjectByID(String projectId) throws BusinessException {
        try {
            if (AppContext.hasPlugin("project")) {
            	long projectID = Long.parseLong(projectId != null ? projectId : "0");
                return this.projectApi.getProject(projectID);
            }
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        return null;
    }

    /**
     * 提醒消息
     * @param today 当前时间
     * @param alartDate 提醒相对比较时间相差几分钟
     * @param compareDate 比较时间
     * @param calEvents 周期性事件列表
     * @param jobName 任务名称
     * @param cInfo  周期信息
     * @throws BusinessException
     */
    private void eventRemind(Date today, Long alartDate, Date compareDate,String jobName,List<CalEvent> calEvents,CalEventPeriodicalInfo cInfo)
            throws BusinessException {
        if ((alartDate != null && alartDate >= AlarmDateEnum.enum1.getKey())
                && (DateUtils.isSameDay(compareDate, today) || compareDate.after(today))) {
            QuartzHolder.deleteQuartzJob(jobName);
            Map<String, String> parameters = new HashMap<String, String>();
            List<Long> calEventIdList = new ArrayList<Long>();
            for(CalEvent calEvent:calEvents){    
            	Date begin = calEvent.getBeginDate();
            	Date end = calEvent.getBeginDate();
            	parameters.put(Datetimes.formatDate(begin), String.valueOf(calEvent.getId()));
            	parameters.put(Datetimes.formatDate(end), String.valueOf(calEvent.getId()));
            	calEventIdList.add(calEvent.getId());
            }
            parameters.put("calEventIdList", StringUtils.join(calEventIdList, ","));
            Date temp = Datetimes.addMinute(compareDate, -alartDate.intValue());
    		int hours = temp.getHours();
    		int min = temp.getMinutes();
    		if(cInfo.getPeriodicalType().intValue()==0){
    			QuartzHolder.newQuartzJob(jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), "eventRemind", parameters);
    		}else{
    			if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()){ //按月
                	if(cInfo.getSwithMonth()==2){  //如果选择的是一月的第几个星期中的周几
                		String dayweek = cInfo.getDayWeek().toString(); //一周中的周几
                		String week = cInfo.getWeek().toString();       //一月中的第几周            	
                		String cronStr = "0 "+min+" "+hours+" ? * "+dayweek+"#"+week;
                    	QuartzHolder.newCronQuartzJob("NULL", jobName, cronStr, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                	}else{  //否则，执行这里
                    	QuartzHolder.newQuartzJobPerMonth("NULL", jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                	}
                }else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()){ //按年
                	if(cInfo.getSwithYear()==2){
                		String dayweek = cInfo.getDayWeek().toString(); //一周中的周几
                		String week = cInfo.getWeek().toString();       //一月中的第几周   
                		String month = cInfo.getMonth().toString();
                		String cronStr = "0 "+min+" "+hours+" ? "+month+" "+dayweek+"#"+week;
                    	QuartzHolder.newCronQuartzJob("NULL", jobName, cronStr, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                	}else{
                    	QuartzHolder.newQuartzJobPerYear("NULL", jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                	}
                }else{  //按天或者按周的执行这条
                	QuartzHolder.newQuartzJobPerDay("NULL", jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                }
    		}            
        }
    }

    /**
     * 根据事件ID删除CalEventTran
     * 
     * @param calEventId 事件ID
     * @throws BusinessException
     */
    private void deleteTranEventByEventId(Long calEventId) throws BusinessException {
        this.calEventTranManager.deleteByEventId(calEventId);
    }

    /**
     * 根据事件ID的list对象删除CalEventTran
     * 
     * @param eventIds 事件IDList
     * @throws BusinessException
     */
    private void deleteTranEventByEventId(List<Long> eventIds) throws BusinessException {
        this.calEventTranManager.deleteByEventId(eventIds);
    }

    /**
     * 项目事件,存入该项目下当前阶段.用于当事件共享类型是项目类型.保存到中间表中进行存储 事件和项目的中间表是 projectPhaseEvent类
     * 
     * @param calEvent 当前事件对象
     * @throws BusinessException 异常
     */
    private void saveProject(CalEvent calEvent) throws BusinessException {
        if (AppContext.hasPlugin("project")) {
            try {
                ProjectBO projectSummary = projectApi.getProject(NumberUtils.toLong(calEvent
                        .getTranMemberIds())); // 根据当前
                // 项目ID得到该项目对象
                if (projectSummary != null) { // projectSummary.getPhaseId()为阶段ID
                    projectPhaseEventManager.save(new ProjectPhaseEvent(ApplicationCategoryEnum.calendar.key(),
                            calEvent.getId(), projectSummary.getPhaseId()));
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage(),e);
            }
        }
    }

    /**
     * 项目事件,存入该项目下当前阶段.用于当事件共享类型是项目类型.保存到中间表中进行存储 事件和项目的中间表是 projectPhaseEvent类
     * 
     * @param calEvents 当前事件对象List
     * @throws BusinessException 异常
     */
    private void saveProject(List<CalEvent> calEvents) throws BusinessException {
        if (AppContext.hasPlugin("project")) {
            List<ProjectPhaseEvent> projectPhaseEvents = new ArrayList<ProjectPhaseEvent>();
            try {
                for (CalEvent calEvent : calEvents) {
                    ProjectBO projectSummary = projectApi.getProject(NumberUtils.toLong(calEvent
                            .getTranMemberIds())); // 根据当前
                    // 项目ID得到该项目对象
                    if (projectSummary != null) { // projectSummary.getPhaseId()为阶段ID
                        projectPhaseEvents.add(new ProjectPhaseEvent(
                                ApplicationCategoryEnum.calendar.key(), calEvent.getId(), projectSummary.getPhaseId()));
                    }
                }
                projectPhaseEventManager.saveAll(projectPhaseEvents); // 执行保存保证
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage(),e);
            }
        }
    }

    /**
     * 保存附件
     * 
     * @param calEvent 事件对象
     * @param calEventId 事件ID
     * @throws BusinessException 异常
     */
    private void saveAttachment(CalEvent calEvent, Long calEventId) throws BusinessException {
        try {
            attachmentManager.deleteByReference(calEventId); // 保存之前先删除
            //TODO:attachmentManager.create单元测试的时候会报下面错误：
            //org.springframework.transaction.UnexpectedRollbackException: Transaction rolled back because it has been marked as rollback-only
            attachmentManager.create(ApplicationCategoryEnum.calendar, calEventId, calEventId);
            List<Attachment> attachments = attachmentManager.getByReference(calEventId);
            // 看看用户上传附件没有
            if (CollectionUtils.isNotEmpty(attachments)) {
                calEvent.setAttachmentsFlag(Boolean.TRUE); // 保存附件，更改事件的附件标识为true
            }
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }

    }

    /**
     * 根据事件ID的list批量删除附件
     * 
     * @param calEventIds 事件ID列表
     * @throws BusinessException
     */
    private void deleteAttachmentByEventID(List<Long> calEventIds) throws BusinessException {
        attachmentManager.deleteByReference(calEventIds); // 批量删除
    }
    
    /**
     * 根据事件ID删除事件内容
     * 
     * @param calEventId 事件ID
     * @throws BusinessException
     */
    private void deleteCalContentByEventId(Long calEventId) throws BusinessException {
        this.calContentManager.deleteByEventId(calEventId);

    }

    /**
     * 根据事件ID的list对象删除事件内容
     * 
     * @param eventId 事件ID
     * @throws BusinessException
     */
    private void deleteCalContentByEventId(List<Long> calEventIds) throws BusinessException {
        this.calContentManager.deleteByEventId(calEventIds);

    }

    public CalEvent compareDate(CalEvent calEvent) throws BusinessException {
        Date beginDate = calEvent.getBeginDate(); // 得到开始时间
        Date endDate = calEvent.getEndDate(); // 得到结束时间
        if (calEvent.getReceiveMemberName() != null && ("endDate").equals(calEvent.getReceiveMemberName())) { // 如果用户操作的是结束时间
            if (beginDate.getTime() >= endDate.getTime()) { // 如果开始时间大于结束时间。则设置开始时间为结束时间前一个小时
                calEvent.setBeginDate(Datetimes.addHour(calEvent.getEndDate(), -1)); // 结束时间
            }
        } else if (beginDate.getTime() >= endDate.getTime()) { // 如果开始时间大于结束时间。则设置结束时间为结束时间前一个小时
            calEvent.setEndDate(Datetimes.addHour(calEvent.getBeginDate(), 1)); // 结束时间
        }
        return calEvent;
    }

    /**
     * 根据事件ID的List对象删除回复对象
     * 
     * @param calEventIds 事件IDList
     * @throws BusinessException
     */
    private void deleteCalReplyByEventID(List<Long> calEventIds) throws BusinessException {
        this.calReplyManager.deleteByEventId(calEventIds);

    }

    /**
     * 加载所有的共享事件 ——————共享事件（全部共享） 1.根据当前用户得到所有的项目ID，包括上级部门ID 2.得到当前人员参与的所有项目事件
     * 3.当前登陆用户 4.单位ID
     * 
     * @param fi 分页对象
     * @param calEvent 事件对象
     * @return
     * @throws BusinessException
     */
    public List<CalEvent> getAllShareEvent(FlipInfo fi, CalEvent calEvent) throws BusinessException {
        List<Long> ids = getDepartMentIDs(AppContext.getCurrentUser(), calEvent); // 根据当前用户得到所有的项目ID，包括上级部门ID
        getAllProjectIDByUser(ids); // 得到当前人员参与的所有项目事件
        ids.add(AppContext.getCurrentUser().getId()); // 当前登陆用户
        ids.add(AppContext.currentAccountId()); // 单位ID
        List<List<Long>> relationPeoson = new ArrayList<List<Long>>();
        List<Long> shareTypeLeaderJunior = new ArrayList<Long>();
        List<Long> shareTypeLeaderAsstant = new ArrayList<Long>();
        List<Long> shareTypeJunior = new ArrayList<Long>();
        getRelatePersonIDS(AppContext.currentUserId(), shareTypeLeaderJunior, shareTypeLeaderAsstant, shareTypeJunior);
        relationPeoson.add(shareTypeLeaderJunior); //秘书、上级、下级
        relationPeoson.add(shareTypeLeaderAsstant); //秘书、上级、下级
        relationPeoson.add(shareTypeJunior); //秘书、上级、下级
        this.calEventDao.getAllShareEvent(fi, ids, calEvent, relationPeoson);
        return fi.getData();

    }
    /**
     * 得到当前人员参与的所有项目事件
     * 
     * @param projectSummaryIDs 用于把得到的项目事件ID放入ids中
     * @throws BusinessException 得到当前人员参与的所有项目事件
     */
    private void getAllProjectIDByUser(List<Long> projectSummaryIDs) throws BusinessException {
        if (AppContext.hasPlugin("project")) {
            List<ProjectBO> pp = projectApi.findProjectsByMemberId(AppContext.getCurrentUser().getId()); // 取得关联项目包括我的
            if (CollectionUtils.isNotEmpty(pp)) {
                for (int i = 0, p = pp.size(); i < p; i++) {
                    projectSummaryIDs.add(pp.get(i).getId());
                }
            }
        }
    }

    /**
     * 他人事件、他人事件portal数据来源manager方法
     * 
     * @param fi 分页对象
     * @param calEvent 事件对象
     * @param count 他人事件portal用到的显示行数
     * @return
     * @throws BusinessException
     */
    private List<CalEvent> getAllOtherEvent(FlipInfo fi, CalEvent calEvent, Integer count) throws BusinessException {
        User user = AppContext.getCurrentUser(); // 得到当前登录人员对象
        List<Long> calEventRelatUserIDs = new ArrayList<Long>();
        calEventRelatUserIDs.add(AppContext.currentAccountId()); // 得到所有的单位ID
        // 添加部门内所有的人员ID。根据当前人员ID得到该人员所在部门及其兼职部门的IDList
        calEventRelatUserIDs.addAll(getDepartMentIDs(user, calEvent));
        // 将当前登录人员的ID加入到list中
        calEventRelatUserIDs.add(user.getId());
        List<Long> shareTypeLeaderJunior = new ArrayList<Long>();
        List<Long> shareTypeLeaderAsstant = new ArrayList<Long>();
        List<Long> shareTypejunior = new ArrayList<Long>();
        //公开给上级、下级、秘书
        getRelatePersonIDS(user.getId(), shareTypeLeaderJunior, shareTypeLeaderAsstant, shareTypejunior);
        List<List<Long>> otherID = new ArrayList<List<Long>>();
        otherID.add(calEventRelatUserIDs); //共享给非私人事件、非上级、非下级、非秘书
        otherID.add(shareTypeLeaderJunior); //秘书、上级、下级
        otherID.add(shareTypeLeaderAsstant); //秘书、上级、下级
        otherID.add(shareTypejunior); //秘书、上级、下级
        Date curDate = getCurDate();
        if (count != null) { // portal
            fi.setData(getDate4portal(count, null, "caleventOther", fi, calEvent, otherID, curDate));
        } else {
            this.calEventDao.getAllOtherEvent(fi, calEvent, null, null, Boolean.FALSE, otherID);
        }
        return fi.getData();
    }

    /**
     * 共享给上级、下级、秘书三种情况下的相关人员列表
     * @param user 当前用户
     * @param shareTypeLeaderForJunior 相对与下级的领导
     * @param shareTypeLeaderForAsstant 相对与秘书的领导
     * @param shareTypejunior 下级
     * @param shareTypeAsstant 秘书
     */
    private void getRelatePersonIDS(Long createUserID, List<Long> shareTypeLeaderForJunior,
            List<Long> shareTypeLeaderForAsstant, List<Long> shareTypejunior) {
        if (AppContext.hasPlugin("relateMember")) {
            try {
                List<V3xOrgMember> v3xOrgMembers = new ArrayList<V3xOrgMember>();
                v3xOrgMembers.addAll(peopleRelateManager.getAllRelateMembersWithFix(createUserID).get(
                        RelationType.leader));
                List<V3xOrgMember> v3xOrgMembersAsstant = new ArrayList<V3xOrgMember>();
                List<V3xOrgMember> v3xOrgMembersJunior = new ArrayList<V3xOrgMember>();
                for (V3xOrgMember v3xOrgMember : v3xOrgMembers) {
                    v3xOrgMembersAsstant.addAll(peopleRelateManager.getAllRelateMembersWithFix(v3xOrgMember.getId())
                            .get(RelationType.assistant));
                    for (V3xOrgMember temMember : v3xOrgMembersAsstant) {
                        if (temMember.getId().equals(createUserID)) {
                            shareTypeLeaderForAsstant.add(v3xOrgMember.getId());
                        }
                    }
                    v3xOrgMembersJunior.addAll(peopleRelateManager.getAllRelateMembersWithFix(v3xOrgMember.getId())
                            .get(RelationType.junior));
                    for (V3xOrgMember temMember : v3xOrgMembersJunior) {
                        if (temMember.getId().equals(createUserID)) {
                            shareTypeLeaderForJunior.add(v3xOrgMember.getId());
                        }
                    }
                }
                v3xOrgMembers.clear();
                v3xOrgMembers.addAll(peopleRelateManager.getAllRelateMembersWithFix(createUserID).get(
                        RelationType.junior));
                v3xOrgMembers.addAll(peopleRelateManager.getAllRelateMembersWithFix(createUserID).get(
                        RelationType.assistant));

                for (V3xOrgMember v3xOrgMember : v3xOrgMembers) {
                    shareTypejunior.add(v3xOrgMember.getId());
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage(),e);
            }
        }
    }

    /**
     * 当用户点击查看部门事件时调用这个方法
     * 
     * @param fi 分页对象
     * @param user 当前登陆用户
     * @param calEvent 事件对象（用于存储条件查询的值）
     * @return 返回所属人能看到的所有部门事件
     * @throws BusinessException
     */
    private List<Long> getAllDepartMentEvents(FlipInfo fi, User user, CalEvent calEvent) throws BusinessException {
        List<Long> ids = getDepartMentIDs(user, calEvent); // 根据当前登录人员得到他所在部门的部门IDList
        this.calEventDao.getAllDePartMentEvents(ids, fi, calEvent);
        return ids;
    }

    /**
     * 得到所有的部门事件ID （根据当前人员得到她所属的部门包括兼职部门）
     * 由于部门事件是所有的上级部门有权限看到下级部门的事件，所以在这里还得把上级部门一并检索处理
     * 
     * @param user 当前登陆人员
     * @return 得到当前人员所属部门列表
     * @throws BusinessException
     */
    private List<Long> getDepartMentIDs(User user, CalEvent calEvent) throws BusinessException {
        List<Long> ids = new ArrayList<Long>();
        List<V3xOrgDepartment> departments = new ArrayList<V3xOrgDepartment>(); // 根据当前登陆人员得到他所有的部门对象
        V3xOrgDepartment v3xOrgDepartment = null;
        if (calEvent.getFromId() != null && Strings.isNotBlank(calEvent.getFromId().toString())) {
            v3xOrgDepartment = orgManager.getDepartmentById(calEvent.getFromId());
        }
        if (v3xOrgDepartment != null) { //portal
            ids.add(v3xOrgDepartment.getId());
            List<V3xOrgDepartment> parentDepartments = orgManager.getAllParentDepartments(v3xOrgDepartment.getId());
            for (V3xOrgDepartment parentDepartment : parentDepartments) {
                ids.add(parentDepartment.getId());
            }
        } else { // 非portal。列表
            departments.addAll(orgManager.getDepartmentsByUser(user.getId())); // 根据当前登陆人员得到他所有的部门对象
            for (V3xOrgDepartment department : departments) {
                ids.add(department.getId()); // 由于部门事件是所有的上级部门有权限看到下级部门的事件，所以在这里还得把上级部门一并检索处理
                List<V3xOrgDepartment> parentDepartments = orgManager.getAllParentDepartments(department.getId());
                for (V3xOrgDepartment parentDepartment : parentDepartments) {
                    ids.add(parentDepartment.getId());
                }
            }
        }
        return ids;
    }

    @Override
    public List<CalEvent> getAllProjectEvents(FlipInfo fi, CalEvent calEvent) throws BusinessException {
        List<Long> projectIDs = new ArrayList<Long>();
        getAllProjectIDByUser(projectIDs); // 根据当前人员得到该人员参与的所有项目ID
        if (CollectionUtils.isNotEmpty(projectIDs)) {
            if (calEvent.getFromId() != null) { // 关联项目条件查询的时候调用的方法
                return getAllProjectEvents(calEvent,-1);
            } else { // 这个else方法是执行我的共享事件、项目共享的逻辑
                this.calEventDao.getAllProjectEvents(projectIDs, fi, calEvent);
            }
        } else { // 如果项目事件没有，则返回null
            fi.setData(null);
        }
        return fi.getData();
    }
    @Override
    public List<CalEvent> getSizeProjectEvents(FlipInfo fi, CalEvent calEvent, int size) throws BusinessException {
        return getAllProjectEvents(calEvent,size);
    }
    
    @Override
    public List<CalEvent> findCalEvents4Project(Long projectId, Long phaseId, int size) throws BusinessException {
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("tranMemberIds", projectId);  //项目ID
    	map.put("fromId", phaseId);  //阶段ID
    	map.put("size", size);
    	map.put("hasProject", AppContext.hasPlugin("project"));
    	return this.calEventDao.getAllProjectEventsByProjectCon(map);
    }
    
    /**
     * 关联项目条件查询的时候调用的方法——————关联项目模块进行模糊查选
     * 
     * @param calEvent
     * @param size 获取条数
     * @return 
     * @throws BusinessException
     */
    private List<CalEvent> getAllProjectEvents(CalEvent calEvent,int size) throws BusinessException {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("fromId", calEvent.getFromId()); // 关联项目阶段ID
        map.put("subject", calEvent.getSubject()); // 关联项目检索名称        
        if (calEvent.getTranMemberName() != null) {
            map.put("tranMemberName", calEvent.getTranMemberName()); // 创建人
        }
        map.put("createDate", calEvent.getCreateDate()); // 创建时间
        map.put("tranMemberIds", calEvent.getTranMemberIds()); // 接收人
//        Date date = (Date) map.get("createDate"); // 关联项目根据时间查询时默认会传入一个结束时间
        map.put("endCreateDate", calEvent.getEndDate());
        map.put("size", size);
        return this.calEventDao.getAllProjectEventsByProjectCon(map);
    }

    /**
     * 根据个人事件对象保存TranEvent对象
     * 
     * @param calEvent 事件对象
     * @throws BusinessException
     */
    private void saveTranEvents(CalEvent calEvent) throws BusinessException {
        List<CalEventTran> calEventTransDB = this.getTranEventsByEvent(calEvent);
        this.calEventTranManager.saveAll(calEventTransDB);
        if (calEvent != null && Strings.equals(calEvent.getIsEntrust(), 1)) {
            appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Calendar_Commission, AppContext
                    .getCurrentUser().getName(), calEvent.getSubject(), calEvent.getReceiveMemberName());
        }
    }

    /**
     * 根据事件对象得到该事件包含的所有共享、安排、委托等相关信息
     * 
     * @param calEvent事件对象
     * @return
     */
    private List<CalEventTran> getTranEventsByEvent(CalEvent calEvent) {
        List<CalEventTran> calEventTransDB = new ArrayList<CalEventTran>();
        List<CalEventTran> calEventTrans = new ArrayList<CalEventTran>();
        CalEventTran calEventTran = null;
        if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) { // 共享 --如果当前事件的共享类型不是私人事件
            List<Long> tranMemberMembers = new ArrayList<Long>();
            List<V3xOrgMember> v3xOrgMembers = new ArrayList<V3xOrgMember>();
            if(AppContext.hasPlugin("relateMember")){
            	try {
	                if(calEvent.getShareType().intValue() == ShareTypeEnum.openToSuperior.getKey()){ //上级    	
						v3xOrgMembers = peopleRelateManager.getAllRelateMembersWithFix(AppContext.currentUserId()).get(RelationType.leader);//上级领导                	    	
	                }else if(calEvent.getShareType().intValue() == ShareTypeEnum.openToLower.getKey()){
	                	v3xOrgMembers = peopleRelateManager.getAllRelateMembersWithFix(AppContext.currentUserId()).get(RelationType.junior);  //下级人员                	
	                }else if(calEvent.getShareType().intValue() == ShareTypeEnum.openToSecretary.getKey()){
	                	v3xOrgMembers = peopleRelateManager.getAllRelateMembersWithFix(AppContext.currentUserId()).get(RelationType.assistant);  //秘书、助手
	                }else{
	                	tranMemberMembers = CommonTools.parseTypeAndIdStr2Ids(calEvent.getTranMemberIds()); //2.3.4
	                }
	                if(CollectionUtils.isNotEmpty(v3xOrgMembers)){
	                	for(V3xOrgMember orgMem:v3xOrgMembers){
	                		tranMemberMembers.add(orgMem.getId());   
	                	}
	                }  
	            }catch (Exception e) {				
					logger.error(e.getLocalizedMessage(),e);
				}        
	        } else {
	        	if (calEvent.getTranMemberIds() != null) {
	        		tranMemberMembers = CommonTools.parseTypeAndIdStr2Ids(calEvent.getTranMemberIds()); //2.3.4
	        	}
	        }
            for (int i = 0, tranMemberMemberInt = tranMemberMembers.size(); i < tranMemberMemberInt; i++) {
                Long tranMemberID = tranMemberMembers.get(i);
                calEventTran = new CalEventTran();
                calEventTran.setType(calEvent.getShareType());
                calEventTran.setEntityId(tranMemberID);
                calEventTrans.add(calEventTran);
            }
        for (CalEventTran cEventTran : calEventTrans) {
            cEventTran.setIdIfNew();
            cEventTran.setEventId(calEvent.getId());
            cEventTran.setSourceRecordId(calEvent.getCreateUserId());
            calEventTransDB.add(cEventTran);
        } 
    }
        return calEventTransDB;
   }
    /**
     * 根据个人事件对象批量保存TranEvent对象
     * 
     * @param calEvent
     * @throws BusinessException
     */
    private void saveTranEvents(List<CalEvent> calEvents) throws BusinessException {
        List<CalEventTran> calEventTrans = new ArrayList<CalEventTran>();
        for (CalEvent calEvent : calEvents) {
            List<CalEventTran> calEventTransDB = getTranEventsByEvent(calEvent);
            if (calEvent != null && Strings.equals(calEvent.getIsEntrust(), 1)) {
                appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Calendar_Commission, AppContext
                        .getCurrentUser().getName(), calEvent.getSubject(), calEvent.getReceiveMemberName());
            }
            calEventTrans.addAll(calEventTransDB);
        }
        this.calEventTranManager.saveAll(calEventTrans);
    }
    
    /**
     * 导出excel时需要先得到一个DataRecord对象
     * @param continueValue 这个条件是来自个人事件列表的。如果个人事件列表已经按照了条件进行了查询。 那么导出的excel数据也是要根据这个结果集导出
     * @param curTab 当前选中的叶签
     * @param EventListtype选中的共享类型：部门、项目、他人
     * @return
     * @throws BusinessException
     */
    private DataRecord getDataRecordForLeaderSchedule(String curTab, String eventListtype, String continueValue)
            throws BusinessException {
        Map<String, Object> map = new HashMap<String, Object>();
        DataRecord dataRecord = new DataRecord();
        map.put("userId", AppContext.getCurrentUser().getId().toString());

        if (!Strings.isEmpty(continueValue)) {
            String searchType = continueValue.split(":")[0]; //查询时的类型
            String serachValue = continueValue.split(":")[1]; //查询时的类型“值”
            if (("beginDate").equals(searchType) || ("endDate").equals(searchType)) {
                map.put("condition", searchType);
                String[] time = serachValue.split(",");
                if (time != null && time.length > 0) {
                    try { // 开始时间
                        if (Strings.isNotBlank(time[0])) {
                            map.put("queryValue", time[0]);
                        }
                        if (!(time.length < 2 || Strings.isBlank(time[1]))) { // 结束时间
                            map.put("queryValue1", time[1]);
                        }
                    } catch (Exception e) {
                        logger.error(e.getLocalizedMessage(),e);
                    }
                }
            } else {
                map.put("condition", searchType);
                map.put("queryValue", serachValue);

            }
        }
        FlipInfo flipinfo = new FlipInfo();
        
        String[] columnNames = new String[8];
        columnNames[0] = ResourceUtil.getString("calendar.event.create.beginDate"); // 开始时间
        columnNames[1] = ResourceUtil.getString("plan.initdata.endTime"); // 结束时间
        columnNames[2] = ResourceUtil.getString("member.list.find.name"); // 姓名
        columnNames[3] = ResourceUtil.getString("calendar.event.create.subject"); // 标题
        columnNames[4] = ResourceUtil.getString("import.type.account"); // 单位
        columnNames[5] = ResourceUtil.getString("import.type.dept"); // 部门
        columnNames[6] = ResourceUtil.getString("calendar.level.label");// 职务

        List<CalEventInfoVO> calEventInfoBOs = new ArrayList<CalEventInfoVO>();
        this.getLeaderSchedule(flipinfo, map);
        if (flipinfo != null && flipinfo.getData() != null && flipinfo.getData().size() > 0) {
            for (Object obj : flipinfo.getData()) {
                if (obj != null && obj instanceof CalEventInfoVO) {
                    calEventInfoBOs.add((CalEventInfoVO) obj);
                }
            }
        }

        dataRecord.setColumnName(columnNames); // 设置列头
        //List<CalEventInfoBO> calEventInfoBOs = getCalEventInfoBO(calEvents);        
        short[] width = { 30, 30, 30, 30, 30, 30, 20, 30 }; // 每列所占的宽度        
        dataRecord.setColumnWith(width); // 设置列头宽度
        dataRecord.setTitle(ResourceUtil.getString("calendar.learder.label")); // excel页签标题---日程事件
        dataRecord.setSheetName("sheet1");
        if (CollectionUtils.isEmpty(calEventInfoBOs)) {
            return dataRecord;
        }
        DataRow[] rows = new DataRow[calEventInfoBOs.size()];
        for (int i = 0, calEventInfoBOInt = calEventInfoBOs.size(); i < calEventInfoBOInt; i++) {
            CalEventInfoVO calEventInfoBO = calEventInfoBOs.get(i);
            DataRow row = new DataRow();
            row.addDataCell(
                    DateFormatUtils.format(calEventInfoBO.getCalEvent().getBeginDate(), getAllAndSDateDFormat()[1]), // 开始时间
                    DataCell.DATA_TYPE_TEXT);
            row.addDataCell(
                    DateFormatUtils.format(calEventInfoBO.getCalEvent().getEndDate(), getAllAndSDateDFormat()[1]), // 结束时间
                    DataCell.DATA_TYPE_TEXT);
            row.addDataCell(calEventInfoBO.getCreateUserName(), DataCell.DATA_TYPE_TEXT);
            row.addDataCell(calEventInfoBO.getCalEvent().getSubject(), DataCell.DATA_TYPE_TEXT); // 标题

            row.addDataCell(calEventInfoBO.getAccountName(), DataCell.DATA_TYPE_TEXT);// 单位
            row.addDataCell(calEventInfoBO.getDepartMentName(), DataCell.DATA_TYPE_TEXT);// 部门
            row.addDataCell(calEventInfoBO.getPostName(), DataCell.DATA_TYPE_TEXT); //职务

            rows[i] = row;
        }
        dataRecord.addDataRow(rows);
        return dataRecord;
    }

    /**
     * 导出excel时需要先得到一个DataRecord对象
     * @param continueValue 这个条件是来自个人事件列表的。如果个人事件列表已经按照了条件进行了查询。 那么导出的excel数据也是要根据这个结果集导出
     * @param curTab 当前选中的叶签
     * @param EventListtype选中的共享类型：部门、项目、他人
     * @return
     * @throws BusinessException
     */
    private DataRecord getDataRecord(String curTab,String eventListtype,String continueValue) throws BusinessException {
        Map<String, Object> map = new HashMap<String, Object>();
        CalEvent calEvent = new CalEvent();
        List<CalEvent> calEvents=null;
        DataRecord dataRecord = new DataRecord();
        if (continueValue.indexOf("createUserIDF8") >= 0) {
            String[] temp = continueValue.split("!");
            map.put("createUserID", Long.parseLong(temp[0].split(":")[1]));
            continueValue = temp[1];
        } else {
            map.put("createUserID", AppContext.getCurrentUser().getId().toString());
        }
        if (!Strings.isEmpty(continueValue)) {
        	String searchType = continueValue.split(":")[0];  //查询时的类型
        	String serachValue = continueValue.split(":")[1];  //查询时的类型“值”
            if (("beginDate").equals(searchType)) {
                String[] time = serachValue.split(",");
                if (time != null && time.length > 0) {
                    try { // 开始时间
                        if (Strings.isNotBlank(time[0])) {
                        	 calEvent.setBeginDate(Datetimes.parse(time[0]));
                        	 map.put("beginDate", Datetimes.parse(time[0]));
                        }
                        if (!(time.length < 2 || Strings.isBlank(time[1]))) { // 结束时间
                        	calEvent.setEndDate(DateUtils.addSeconds(
                                  DateUtils.addDays(Datetimes.parse(time[1]), 1), -1));
                        	map.put("endDate", DateUtils.addSeconds(
                                    DateUtils.addDays(Datetimes.parse(time[1]), 1), -1));
                        }
                    } catch (Exception e) {
                        logger.error(e.getLocalizedMessage(),e);
                    }
                }
            }else{
            	map.put(searchType,serachValue);
            }
            if("subject".equals(searchType)){
            	 calEvent.setSubject(serachValue);
            }else if("signifyType".equals(searchType)){
            	calEvent.setSignifyType(Integer.valueOf(serachValue));
            }else if("states".equals(searchType)){
            	calEvent.setStates(Integer.valueOf(serachValue));
            }else if("createUsername".equals(searchType)){           
                calEvent.setReceiveMemberName(serachValue);
            }            
        }
        FlipInfo flipinfo = new FlipInfo();
//        Long size = this.getShareSize(map);  //获取共享事件的总数，作为分页对象的size
//        flipinfo.setSize(size.intValue());
        flipinfo.setSize(Integer.MAX_VALUE);
        String[] columnNames = new String[10];
        columnNames[0] = ResourceUtil.getString("calendar.event.create.calEventType"); // 事件类型
        columnNames[1] = ResourceUtil.getString("calendar.event.create.subject"); // 标题
        columnNames[2] = ResourceUtil.getString("calendar.event.create.content"); // 事件内容
        columnNames[3] = ResourceUtil.getString("calendar.event.create.signifyType"); // 重要程度
        columnNames[4] = ResourceUtil.getString("calendar.event.create.beginDate"); // 开始时间
        columnNames[5] = ResourceUtil.getString("calendar.event.create.endDate"); // 结束时间
        if("all".equals(curTab)){ //全部共享
        	if(Strings.isEmpty(eventListtype)||"all".equals(eventListtype)){
        		calEvents=this.getAllShareEvent(flipinfo, calEvent);//全部共享
        	}else if("department".equals(eventListtype)){
        		this.getAllDepartMentEvents(flipinfo, AppContext.getCurrentUser(), calEvent);  //部门
        	}else if("project".equals(eventListtype)){
        		this.getAllProjectEvents(flipinfo, calEvent);   //项目
        	}else if("other".equals(eventListtype)){
        		//共享事件-他人共享，可能选择了某个关联人员，需要在条件中设置这个关联人员的ID；
                String curPeopleId = continueValue.split(":")[2];
                if(!Strings.isEmpty(curPeopleId) && !"other".equals(curPeopleId)){
                	calEvent.setCreateUserId(Long.parseLong(curPeopleId));
                }
        		this.getAllOtherEvent(flipinfo, calEvent, null); //他人
        	}
        	columnNames[6] = ResourceUtil.getString("calendar.event.create.shareType");//共享类型
			columnNames[7] = ResourceUtil.getString("calendar.event.create.createUserName"); // 所属人
			columnNames[8] = ResourceUtil.getString("calendar.event.create.eventSource"); // 事件来源
			columnNames[9] = ResourceUtil.getString("calendar.event.create.states"); // 状态
        	calEvents = flipinfo.getData();        	       	
        }else{  //个人事件
        	columnNames[6] = ResourceUtil.getString("calendar.event.create.createUserName");// 所属人
			columnNames[7] = ResourceUtil.getString("calendar.event.create.eventSource"); // 事件来源
			columnNames[8] = ResourceUtil.getString("calendar.event.create.states"); // 状态
			columnNames[9] = ResourceUtil.getString("calendar.event.create.state.periodical");//周期类型
            calEvents = this.calEventDao.findCalEventListByUserId(map);            
        }
       dataRecord.setColumnName(columnNames); // 设置列头
       List<CalEventInfoVO> calEventInfoBOs = getCalEventInfoBO(calEvents);        
       short[] width = { 30, 30, 80, 30, 30, 30, 30, 30, 20, 30 }; // 每列所占的宽度        
       dataRecord.setColumnWith(width); // 设置列头宽度
       dataRecord.setTitle(ResourceUtil.getString("calendar.event.list.toexcel.title")); // excel页签标题---日程事件
       dataRecord.setSheetName("sheet1");
       if (CollectionUtils.isEmpty(calEventInfoBOs)) {
           return dataRecord;
       }
       DataRow[] rows = new DataRow[calEventInfoBOs.size()];
       for (int i = 0, calEventInfoBOInt = calEventInfoBOs.size(); i < calEventInfoBOInt; i++) {
           CalEventInfoVO calEventInfoBO = calEventInfoBOs.get(i);
           DataRow row = new DataRow();
           //事件类型
           row.addDataCell(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_type, calEventInfoBO.getCalEvent().getCalEventType().toString()), DataCell.DATA_TYPE_TEXT);
           //事件标题标题
           row.addDataCell(calEventInfoBO.getCalEvent().getSubject(), DataCell.DATA_TYPE_TEXT);
           //事件内容
           CalContent calContent = calEventInfoBO.getCalContent();
           row.addDataCell(calContent== null ? "" : calEventInfoBO.getCalContent().getContent(), DataCell.DATA_TYPE_TEXT);
           //重要程度
           row.addDataCell(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType, calEventInfoBO.getCalEvent().getSignifyType().toString()), DataCell.DATA_TYPE_TEXT);// 重要程度
           //事件开始时间
           row.addDataCell(DateFormatUtils.format(calEventInfoBO.getCalEvent().getBeginDate(), getAllAndSDateDFormat()[1]), DataCell.DATA_TYPE_TEXT);
           //事件结束时间
           row.addDataCell(DateFormatUtils.format(calEventInfoBO.getCalEvent().getEndDate(), getAllAndSDateDFormat()[1]), DataCell.DATA_TYPE_TEXT);
           if("all".equals(curTab)){
        	   //共享类型
        	   row.addDataCell(calEventInfoBO.getShareType(), DataCell.DATA_TYPE_TEXT);
         	   //所属人
        	   row.addDataCell(calEventInfoBO.getCreateUserName(), DataCell.DATA_TYPE_TEXT);  
               //事件来源
        	   row.addDataCell(calEventInfoBO.getEventSource(),DataCell.DATA_TYPE_TEXT);
         	   //状态
               row.addDataCell(StatesEnum.findByKey(calEventInfoBO.getCalEvent().getStates()).getText(), DataCell.DATA_TYPE_TEXT); 
           }else{
        	   //所属人
        	   row.addDataCell(calEventInfoBO.getCreateUserName(), DataCell.DATA_TYPE_TEXT);  
        	   //事件来源
        	   row.addDataCell(calEventInfoBO.getEventSource(), DataCell.DATA_TYPE_TEXT);
        	   //状态
        	   row.addDataCell(StatesEnum.findByKey(calEventInfoBO.getCalEvent().getStates()).getText(), DataCell.DATA_TYPE_TEXT); 
        	   //周期性
        	   row.addDataCell(calEventInfoBO.getCalEvent().getPeriodicalStyle() == 0 ? ResourceUtil.getString("calendar.event.create.state.no") : PeriodicalEnum.findByKey(calEventInfoBO.getCalEvent().getPeriodicalStyle()).getText(), DataCell.DATA_TYPE_TEXT); 
           }      
           rows[i] = row;
       }
       dataRecord.addDataRow(rows);
       return dataRecord;
    }

    @Override
    public void saveEventToExcel(String curTab, String EventListtype, String continueValue) throws BusinessException {
        HttpServletResponse response = AppContext.getRawResponse();
        try {
            DataRecord dataRecord = new DataRecord();
            String curTabStr = StringUtil.checkNull(curTab) ? "" : curTab;
            if (!"leaderSchedule".equals(curTabStr)) {
                dataRecord = getDataRecord(curTabStr, EventListtype, continueValue);
            } else {
                dataRecord = getDataRecordForLeaderSchedule(curTabStr, EventListtype, continueValue);
            }
            fileToExcelManager.save(response, dataRecord.getTitle(), dataRecord);
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
    }

    @Override
    public List<List<String>> getStatistics(Map<String, Object> map) throws BusinessException {
        CalEvent calEvent = new CalEvent();
        String statisticsSumType = map.get("statisticsSumType").toString();
        String statisticsType = map.get("statisticsType").toString();
        String states = map.get("states").toString();
        String endDate = map.get("endDate").toString();
        String beginDate = map.get("beginDate").toString();
        calEvent.setStates(Integer.valueOf(states));
        calEvent.setCreateUserId(AppContext.getCurrentUser().getId());
        calEvent.setBeginDate(Datetimes.parse(beginDate));
        calEvent.setEndDate(Datetimes.parse(endDate));
        if (("2").equals(statisticsSumType)) {
            calEvent.setReceiveMemberId("realEstimateTime");
        }
        if (("1").equals(statisticsType)) {
            calEvent.setReceiveMemberName("signifyType");
        }
        List<List<String>> list = new ArrayList<List<String>>();
        List<Object[]> objects = this.calEventDao.getStatistics(calEvent);
        List<String> mapSum = new ArrayList<String>();
        List<String> mapCount = new ArrayList<String>();
        List<String> mapKey = new ArrayList<String>();
        List<String> enumKey = new ArrayList<String>();
        Map graghData = new HashMap();
        List<CtpEnumItem> ctpEnumItems = enumManagerNew.getEnumItemByProCode(EnumNameEnum.cal_event_signifyType);
        int count = ctpEnumItems.size();
        if (("2").equals(statisticsType)) {
            ctpEnumItems = enumManagerNew.getEnumItemByProCode(EnumNameEnum.cal_event_type);
            count = ctpEnumItems.size();
        }
        for (int i = 0; i < count; i++) {
            Boolean isHasCount = Boolean.FALSE;
            CtpEnumItem ctpEnumItem = ctpEnumItems.get(i);
            enumKey.add(ctpEnumItem.getEnumvalue());
            if (("1").equals(statisticsType)) {
                mapKey.add(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType,
                        ctpEnumItem.getEnumvalue()));
            } else {
                mapKey.add(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_type, ctpEnumItem.getEnumvalue()));
            }
            for (int j = 0, k = objects.size(); j < k; j++) {
                if (ctpEnumItem.getEnumvalue().equals(objects.get(j)[2].toString())) {
                    mapSum.add(objects.get(j)[0].toString());
                    mapCount.add(objects.get(j)[1].toString());
                    isHasCount = Boolean.TRUE;
                    break;
                }
            }
            if (!isHasCount) {
                mapSum.add("0");
                mapCount.add("0");
            }
        }
        Integer sumCount = 0;
        Float sumHour = 0f;
        for (int i = 0, j = mapCount.size(); i < j; i++) {
            sumCount += Integer.parseInt(mapCount.get(i));
            sumHour += Float.parseFloat(mapSum.get(i));
        }
        List<String> result = new ArrayList<String>();
        for (int i = 0, j = mapKey.size(); i < j; i++) {
            StringBuffer stringBuffer = new StringBuffer();
            if ((Integer.parseInt(statisticsSumType) == 1 && Integer.parseInt(mapCount.get(i)) == 0)
                    || (Integer.parseInt(statisticsSumType) == 2 && Float.floatToRawIntBits(Float.parseFloat(mapSum.get(i))) == 0)) {
                stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.no"));
                result.add(stringBuffer.toString());
                continue;
            }
            stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.proportion"));
            if (Integer.parseInt(statisticsSumType) == 2) {
            	float per = new BigDecimal(((Float.parseFloat(mapSum.get(i)) / sumHour) * 100)).setScale(2,
                        BigDecimal.ROUND_HALF_UP).floatValue();
                stringBuffer.append(per);
                graghData.put(i,Strings.escapeNULL(per, 0));
            } else {
            	float per = new BigDecimal(((Float.parseFloat(mapCount.get(i)) / sumCount) * 100)).setScale(2,
                        BigDecimal.ROUND_HALF_UP).floatValue();
                stringBuffer.append(per);
                graghData.put(i,Strings.escapeNULL(per, 0));
            }
            stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.toSum"));
            stringBuffer.append(mapCount.get(i));
            stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.resultStr1"));
            if (mapSum.get(i) != null) {
                float sum = Float.parseFloat(mapSum.get(i));
                stringBuffer.append(String.format("%.2f", sum));
            }
            stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.hour"));
            result.add(stringBuffer.toString());
        }
        list.add(mapKey);
        list.add(result);
        if (Integer.parseInt(statisticsSumType) == 2) {
            list.add(mapSum);
        } else {
            list.add(mapCount);
        }
        list.add(enumKey);
        if("1".equals(statisticsType)){
            //-------------------开始构造图表类型1
            Title title = new Title().setText("calendar.event.create.signifyType");  //标题
            List<SerieItem> serieData = new ArrayList<SerieItem>();  //系列节点
                 if(graghData.get(0)!=null){
    	  	        serieData.add(new SerieItem(graghData.get(0))
    	  	    		.setId("import3")
    	  	    		.setName("calendar.event.signifyType.tip1"));
                 }
                 if(graghData.get(1)!=null){
    	  	        serieData.add(new SerieItem(graghData.get(1))
    	  	    		.setId("import2")
    	  	    		.setName("calendar.event.signifyType.tip2"));
                 }
                 if(graghData.get(2)!=null){
    	  	        serieData.add(new SerieItem(graghData.get(2))
    	  	    		.setId("import1")
    	  	    		.setName("calendar.event.signifyType.tip3"));
                 }
                if(graghData.get(3)!=null){
    	  	        serieData.add(new SerieItem(graghData.get(3))
    	  	        .setId("import0")
    	  	        .setName("calendar.event.signifyType.tip4"));
                }
                Legend legend = new Legend().setY("bottom");
                PieSerie pieSerie = new PieSerie().setSymbol("round").setData(serieData.toArray(new SerieItem[] {})); //系列
                Map<String, Object> params = new HashMap<String, Object>();
                params.put("formatter", "{c}%");
                pieSerie.setItemStyle(new ItemStyle().setNormal(new Normal().setLabel(new Label().setShow(true).setOthers(params))));
                ChartBO pieChartBO = new ChartBO().setTooltip(new Tooltip().setFormatter("{b} : {c}%"))
                .setTitle(title)
                .setNoDataText("calendar.event.noDataText")
                .setSeries(pieSerie)
                .setColor("#1D8BD1", "#F1683C", "#2AD62A","#DBDC25");
                pieChartBO.getOthers().put("legend",legend);
                List<String> listChartset = new ArrayList<String>();
                listChartset.add(this.toChart(pieChartBO));
                list.add(listChartset);
                //-------------------结束构造图表类型1

            }
            else{
            	//-------------------开始构造图表类型2
                Title title = new Title().setText("calendar.event.create.calEventType");  //标题
                List<SerieItem> serieData = new ArrayList<SerieItem>();  //系列节点
                     if(graghData.get(0)!=null){
        	  	        serieData.add(new SerieItem(graghData.get(0))
        	  	    		.setId("import3")
        	  	    		.setName("calendar.event.create.calEventType.tip1"));
                     }
                     if(graghData.get(1)!=null){
        	  	        serieData.add(new SerieItem(graghData.get(1))
        	  	    		.setId("import2")
        	  	    		.setName("calendar.event.create.calEventType.tip2"));
                     }
                     if(graghData.get(2)!=null){
        	  	        serieData.add(new SerieItem(graghData.get(2))
        	  	    		.setId("import1")
        	  	    		.setName("calendar.event.create.calEventType.tip3"));
                     }
                    if(graghData.get(3)!=null){
        	  	        serieData.add(new SerieItem(graghData.get(3))
        	  	        .setId("import0")
        	  	        .setName("calendar.event.create.calEventType.tip4"));
                    }
                    Legend legend = new Legend().setY("bottom");
                    PieSerie pieSerie = new PieSerie().setSymbol("round").setData(serieData.toArray(new SerieItem[] {})); //系列
                    Map<String, Object> params = new HashMap<String, Object>();
                    params.put("formatter", "{c}%");
                    pieSerie.setItemStyle(new ItemStyle().setNormal(new Normal().setLabel(new Label().setShow(true).setOthers(params))));
                    ChartBO pieChartBO = new ChartBO().setTooltip(new Tooltip().setFormatter("{b} : {c}%"))
                    .setTitle(title)
                    .setNoDataText("calendar.event.noDataText")
                    .setSeries(pieSerie)
                    .setColor("#1D8BD1", "#F1683C", "#2AD62A","#DBDC25");
                    pieChartBO.getOthers().put("legend",legend);
                    List<String> listChartset = new ArrayList<String>();
                    listChartset.add(this.toChart(pieChartBO));
                    list.add(listChartset);
                    //-------------------结束构造图表类型2
            }
        return list;
    }
    /**
     * 用于getStatistics方法
     * @param chartBO
     * @return
     */
    private String toChart(ChartBO chartBO) {
		ChartRender chartRender = (ChartRender)AppContext.getBean("chartRender");
		try {
        	return JSONUtil.toJSONString(chartRender.render(chartBO));
		} catch (BusinessException e) {
			logger.error(e.getMessage());
		}
		return "";
	}
    @Override
    public FlipInfo getStatisticsCalEventInfoBO(FlipInfo flipInfo, Map<String, String> params) throws BusinessException {
        CalEvent calEvent = new CalEvent();
        String statisticsType = params.get("statisticsType").toString();
        String states = params.get("states").toString();
        String endDate = params.get("endDate").toString();
        String beginDate = params.get("beginDate").toString();
        calEvent.setStates(Integer.valueOf(states));
        calEvent.setCreateUserId(AppContext.getCurrentUser().getId());
        calEvent.setBeginDate(Datetimes.parse(beginDate));
        calEvent.setEndDate(Datetimes.parse(endDate));
        String testSearch = params.get("testSearch").toString();
        calEvent.setCalEventType(Integer.valueOf(testSearch));
        if (("1").equals(statisticsType)) {
            calEvent.setReceiveMemberName("signifyType");
        }
        this.calEventDao.getStatisticsCalEventInfoBO(flipInfo, calEvent);
        // 将数据库检索出来的列表封装为页面元素
        List<CalEventInfoVO> calEventInfoBOs = getCalEventInfoBO(flipInfo.getData());
        // 分页对象
        flipInfo.setData(calEventInfoBOs);
        return flipInfo;
    }

    @Override
    public List<CalEvent> getViewDateByCon(Map<String, Object> map) throws BusinessException {
        return this.calEventDao.getViewDateByCon(map);

    }

    @Override
    public List<CalEvent> getAllCaleventView(Map<String, Object> map) throws BusinessException {
    	boolean isResourceCode = true;
    	/* 客开 GXY
    	if(AppContext.getCurrentUser() != null) {
    		isResourceCode = AppContext.getCurrentUser().hasResourceCode("F02_eventlist"); 
    	}*/
    	
        if (isResourceCode) {
            HttpServletRequest request = AppContext.getRawRequest();
            String columnsource = request.getParameter("columnsource");
            if (Strings.isNotBlank(columnsource)) {
                map.put("columnsource", columnsource);
            } else {
                map.put("columnsource", "0,1");
            }
            return this.calEventDao.getAllCaleventView(map);
        }
        return null;
    }
    @Override
    public List<CalEvent> getAllCaleventViewforleader(Map<String, Object> map) throws BusinessException {
        if (AppContext.getCurrentUser().hasResourceCode("F02_eventlist")) {
            HttpServletRequest request = AppContext.getRawRequest();
            String columnsource = request.getParameter("columnsource");
            if (Strings.isNotBlank(columnsource)) {
                map.put("columnsource", columnsource);
            } else {
                map.put("columnsource", "0,1");
            }
            return this.calEventDao.selectLeaderScheduleForEvent(map);
        }
        return null;
    }
    @Override
    public List<V3xOrgMember> getPeopleRelateList() throws BusinessException {
        List<V3xOrgMember> orgMembers = new ArrayList<V3xOrgMember>();
        try {
            if (AppContext.hasPlugin("relateMember")) {
                Map<RelationType, List<V3xOrgMember>> peopleRelates = this.peopleRelateManager
                        .getAllRelateMembers(AppContext.getCurrentUser().getId());
                orgMembers.addAll(peopleRelates.get(RelationType.junior));
                orgMembers.addAll(peopleRelates.get(RelationType.assistant));
                orgMembers.addAll(peopleRelates.get(RelationType.leader));
                orgMembers.addAll(peopleRelates.get(RelationType.confrere));
            }
            return orgMembers;
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        return null;
    }
    
    //目前只有M1调用
    @Override
    public List<PlanBO> getAllOtherPlan(Map<String, Object> map) throws BusinessException {
    	boolean isResourceCode = true;
    	if(AppContext.getCurrentUser() != null) {
    		isResourceCode = AppContext.getCurrentUser().hasResourceCode("F02_planListHome"); 
    	}
        if (AppContext.hasPlugin("plan") && isResourceCode) {
            return planApi.findPlans4Calendar((Long)map.get("currentUserID"), (Date)map.get("beginDate"), (Date)map.get("endDate"),Arrays.asList(new String[]{"1","2","3","5"}));
        }
        return null;
    }
    //目前只有M1调用
    @Override
    public List<TaskInfoBO> getAllOtherTask(Map<String, Object> map) throws BusinessException {
        boolean isResourceCode = true;
        if (map != null) {	
        	if(AppContext.getCurrentUser() != null) {
        		isResourceCode = MenuPurviewUtil.isHaveProjectAndTask(AppContext.getCurrentUser()); 
        	}
	        if (AppContext.hasPlugin("taskmanage") && isResourceCode) {
	            return taskmanageApi.findTaskInfos((Long)map.get("currentUserID"), (Date)map.get("beginDate"), (Date)map.get("endDate"),Arrays.asList(new TaskStatus[]{TaskStatus.notstarted,TaskStatus.marching,TaskStatus.finished}));
	        }
        }
        return null;
    }
    //目前只有M1调用
    @Override
    public List<ColSummaryVO> getAllOtherCollaboration(Map<String, Object> map) throws BusinessException {
        return null;
    }
    //目前只有M1调用
    @Override
    public List<MeetingBO> getAllOtherMeeting(Map<String, Object> map) throws BusinessException {
        if (AppContext.hasPlugin(TemplateEventEnum.MEETING)) {
            List<Integer> replystateList = new ArrayList<Integer>();
            replystateList.add(SubStateEnum.col_pending_unRead.key());
            replystateList.add(SubStateEnum.col_pending_read.key());
            replystateList.add(SubStateEnum.meeting_pending_join.key());
            replystateList.add(SubStateEnum.meeting_pending_pause.key());
            map.put("replystateList", replystateList);
            return meetingApi.findMeetings(ApplicationCategoryEnum.calendar, map);
        }
        return null;
    }

    @Override
    public String getBeginTime() throws BusinessException {
        if (AppContext.hasPlugin("worktimeset")) {
            WorkTimeCurrency workTimeCurrency = workTimeSetManager.findComnWorkTimeSet(AppContext.getCurrentUser()
                    .getLoginAccount());
            double beginTime = Double.parseDouble(workTimeCurrency.getAmWorkTimeBeginTime().replace(":", "."));
            Date curDate = Calendar.getInstance().getTime();
            double curBeginTime = Double.parseDouble(Datetimes.format(curDate,"HH"));
            if (beginTime < curBeginTime) {
                beginTime = curBeginTime;
            }
            return String.valueOf(beginTime);
        } else {
            return "8";
        }
    }
    //目前只有M1调用
    @Override
    public List<EdocSummaryComplexBO> getAllOtherEdoc(Map<String, Object> map) throws BusinessException {
        return null;
    }

    @Override
    public List<CalEventInfoVO> getCalEventViewSetion(int count, String columnsource) throws BusinessException {
        // 这个curDates主要是存时间的,然后计算得到今日的日程事件
        List<CalEvent> calEvents = getDate4portal(count, columnsource, "caleventView", null, null, null, getCurDate());
        return getCalEventInfoBO(calEvents);
    }

    public Date getCurDate() {
        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int day = calendar.get(Calendar.DATE);
        String curDayStr = year + "-" + month + "-" + day;
        try {
            date = DateUtil.parse(curDayStr, DateUtil.YEAR_MONTH_DAY_PATTERN);
        } catch (ParseException e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        return date;
    }

    /**
     * 他人事件、日程事件 中有今日、跨日、更早、更晚的显示的共同方法
     * 
     * @param count 显示行数
     * @param columnsource 日程事件所有参数
     * @param source 来源 caleventView=日程事件 caleventOther = 他人事件 FlipInfo fi,List<Long> id, CalEvent calEvent,List<Long> receiveMemberNameIDs 这些参数都是他人事件用到的参数
     * @return
     * @throws BusinessException
     */
    private List<CalEvent> getDate4portal(int count, String columnsource, String source, FlipInfo fi,
            CalEvent calEvent, List<List<Long>> otherID, Date curDate) throws BusinessException {
        List<Date> curDates = new ArrayList<Date>();
        List<CalEvent> calEvents = new ArrayList<CalEvent>();
        int i = 0;
        Boolean isKuaRi = Boolean.FALSE; // 是跨日吗？
        int curCount = count - calEvents.size();
        do {
            if (i == 0) { // 今日
                curDates.add(curDate);
                curDates.add(Datetimes.addDate(curDate, 1));
            } else if (i == 1) { // 跨日
                isKuaRi = Boolean.TRUE;
                curDates.add(Datetimes.addDate(curDate, 1));
                curDates.add(curDate);
            } else if (i == 2) { // 明日
                curDates.add(Datetimes.addDate(curDate, 1));
                curDates.add(Datetimes.addDate(curDate, 2));
            } else if (i == 3) { // 更早
                curDates.add(Datetimes.addDate(curDate, -7));
                curDates.add(curDate);
            } else if (i == 4) { // 更晚
                curDates.add(Datetimes.addDate(curDate, 2));
                curDates.add(Datetimes.addDate(curDate, 9));
            }
            if (("caleventView").equals(source)) {
                calEvents.addAll(this.calEventDao.getCalEventViewSetion(curCount, columnsource, curDates, isKuaRi)); // 加载日程事件列表
            } else {
                this.calEventDao.getAllOtherEvent(fi, calEvent, curCount, curDates, isKuaRi, otherID);
                calEvents.addAll(fi.getData()); // 加载他人事件列表
            }
            curDates.clear(); // 清空时间List
            isKuaRi = Boolean.FALSE; // 是否是跨日操作
            curCount = count - calEvents.size();
            i++;
        } while (calEvents.size() < count && i < 5);
        return calEvents;
    }


    /**
     * 得到时间线或者其他视图对应的map参数
     * 
     * @param isTimeLine 是否是时间线
     * @return
     * @throws BusinessException
     */
    private Map<String, Object> getQueryParams() throws BusinessException {
    	// 其他模块获得参数map
    	HttpServletRequest request = AppContext.getRawRequest();
        String beginTime = getBeginTime();
        AppContext.putRequestContext("iniHour", beginTime); // 默认显示时间 (事件视图上班时间）
        String type = request.getParameter("type"); // 类型 周、月、日
        String curTab = request.getParameter("curTab"); // 选中那个也签
        String curDate = request.getParameter("curDate"); // （一般情况是portal点击更多时需要的参数）,日视图中选中的日期时间。格式默认为
        String selectedDate = request.getParameter("selectedDate"); // 事件视图 yyyy-mm-dd
        String curDay = request.getParameter("curDay"); // 日视图中的日期 默认选中的天数
        if (type == null || ("week").equals(type)) {
            if (curTab != null && (("calEventView").equals(curTab) || ("timeArrange").equals(curTab) || ("relateMember").equals(curTab))) {
                if (Strings.isNotBlank(curDate)) {
                    type = "day";
                    AppContext.putRequestContext("type", type);
                    selectedDate = curDate;
                    curDay = curDate;
                } else {
                    AppContext.putRequestContext("type", "month");
                }
            } else {
                AppContext.putRequestContext("type", "week");
            }
        } else {
            AppContext.putRequestContext("type", type);
        }
        StringBuilder beginDateStr = new StringBuilder();
        StringBuilder endDateStr = new StringBuilder();
        if (Strings.isBlank(selectedDate)) {
            Calendar calendar = Calendar.getInstance();
            AppContext.putRequestContext("day", calendar.get(Calendar.DAY_OF_MONTH));
            AppContext.putRequestContext("month", calendar.get(Calendar.MONTH));
            AppContext.putRequestContext("year", calendar.get(Calendar.YEAR));
            if (curTab != null && (("calEventView").equals(curTab) || ("timeArrange").equals(curTab))) { // 日程日期、时间安排的月视图
                calendar.set(Calendar.DAY_OF_MONTH, 1); // 设置为1号,当前日期既为本月第一天
                beginDateStr.append(DateFormatUtils.format(calendar.getTime(), getAllAndSDateDFormat()[0]));
                calendar.add(Calendar.MONTH, 1); // 月增加1天
                calendar.add(Calendar.DAY_OF_MONTH, -1); // 日期倒数一日,既得到本月最后一天
                endDateStr.append(DateFormatUtils.format(calendar.getTime(), getAllAndSDateDFormat()[0]));
            } else {
                calendar.setFirstDayOfWeek(Calendar.MONDAY); // 默认周视图
                calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                beginDateStr.append(DateFormatUtils.format(calendar.getTime(), getAllAndSDateDFormat()[0])); // 周一
                endDateStr.append(DateFormatUtils.format(Datetimes.addDate(calendar.getTime(), 6),
                        getAllAndSDateDFormat()[0])); // 周天
            }
        } else {
            String[] dateArr = selectedDate.split("-");
            AppContext.putRequestContext("day", dateArr[2]);
            AppContext.putRequestContext("month", String.valueOf(Integer.parseInt(dateArr[1]) - 1));
            AppContext.putRequestContext("year", dateArr[0]);
        }
        if (type != null && ("day").equals(type)) {
            beginDateStr.append(curDay);
            endDateStr.append(curDay);
        } else if ((type != null && ("month").equals(type)) && !(curTab != null && ("calEventView").equals(curTab))) {
            beginDateStr.append(request.getParameter("monthStart"));
            endDateStr.append(request.getParameter("monthEnd"));
        } else if (type != null && ("week").equals(type)) {
            beginDateStr.append(request.getParameter("weekStart"));
            endDateStr.append(request.getParameter("weekEnd"));
        }
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("beginDate", Datetimes.parse(beginDateStr.toString())); // map的开始时间
        map.put("endDate", DateUtils.addSeconds(DateUtils.addDays(Datetimes.parse(endDateStr.toString()), 1), -1)); // map的结束日期
        if (Strings.isNotBlank(request.getParameter("relateMemberID"))) { // 关联人员
            curTab = "relateMember";
            Long relateMemberID = Long.valueOf(request.getParameter("relateMemberID"));
            map.put("currentUserID", relateMemberID);
            request.setAttribute("relateMemberName", orgManager.getMemberById(relateMemberID).getName());
            request.setAttribute("relateMemberID", relateMemberID);
            request.setAttribute("curMemberID", AppContext.currentUserId());
            request.setAttribute("curDate", curDate);
        } else {
            map.put("currentUserID", AppContext.currentUserId());
        }
        map.put("curTab", curTab);
        if (!("relateMember").equals(curTab)) { // 如果不是关联人员的话。则需要将curTab这个参数移除map
            map.remove("curTab");
        }
        return map;
    }


    
    @SuppressWarnings("rawtypes")
	public FlipInfo getPageData(List objList, int pageNo, int pageSize) throws BusinessException {
    	FlipInfo flp = new FlipInfo();
    	if (CollectionUtils.isNotEmpty(objList)) {
    		if (pageNo != 0 && pageSize != 0) {
    			flp.setPage(pageNo);
    			flp.setSize(pageSize);
    		} else {
    			flp.setPage(1);
    			flp.setSize(objList.size());
    		}
    		DBAgent.memoryPaging(objList, flp);
    	}
    	return flp;
    }

    /**
     * 用户新增时，调用高级设置，赋初始值
     * 
     * @param calEventInfoBO 页面封装的BO
     * @param calEvent 事件对象
     * @param calEventPeriodicalInfo 周期性事件对象
     * @param params 页面传过来的参数
     * @throws BusinessException
     */
    private void toNewCalEventState(CalEventInfoVO calEventInfoBO, CalEvent calEvent,
            CalEventPeriodicalInfo calEventPeriodicalInfo, String[] params) throws BusinessException {
        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();
        Date curBeginDate = null;
        if (Strings.isNotBlank(params[15])) {
            curBeginDate = Datetimes.parse(params[15]);
        } else {
            curBeginDate = new GregorianCalendar().getTime();
        }
        calendar.setTime(curBeginDate);
        // 这个参数主要是为了再按月、按年提醒时保存当前号数
        AppContext.putRequestContext("curDayDate", calendar.get(Calendar.DATE));
        if (Strings.isNotBlank(params[0])) {
            date = Datetimes.parse(params[0]);
        }
        calEventPeriodicalInfo.setBeginTime(date);
        if (Strings.isNotBlank(params[1])) {
            date = Datetimes.parse(params[1]);
        }
        calEventPeriodicalInfo.setEndTime(date);
        Integer periodical = 0; // 周期类型
        if (Strings.isNotBlank(params[2])) {
            periodical = Integer.valueOf(params[2]);
        }
        calEventPeriodicalInfo.setPeriodicalType(periodical);
        // 实际用时
        Float realEstimate = 0.0f;
        if (Strings.isNotBlank(params[3])) {
            realEstimate = Float.valueOf(params[3]);
        }
        calEvent.setRealEstimateTime(realEstimate);
        if (Strings.isNotBlank(params[4])) {
        	 calEvent.setWorkType(Integer.valueOf(params[4]));
        } 
        if (Strings.isNotBlank(params[5])) {
        	calEventPeriodicalInfo.setDayDate(Integer.valueOf(params[5]));
        }
        if (Strings.isNotBlank(params[6])) {
            calEventPeriodicalInfo.setSwithMonth(Integer.parseInt(params[6]));
        }
        if (Strings.isNotBlank(params[7])) {
            calEventPeriodicalInfo.setSwithYear(Integer.parseInt(params[7]));
        }

        if (Strings.isNotBlank(params[8])) {
            calEventPeriodicalInfo.setDayWeek(Integer.valueOf(params[8])); // 一周的星期几
        } else {
            calEventPeriodicalInfo.setDayWeek(calendar.get(Calendar.DAY_OF_WEEK)); // 一周的星期几
        }
        calEventInfoBO.getWeeks().add(calEventPeriodicalInfo.getDayWeek().toString()); // 周提醒。已勾选的天数
        if (Strings.isNotBlank(params[9])) {
            calEventPeriodicalInfo.setWeek(Integer.valueOf(params[9]));
        } else {
            calEventPeriodicalInfo.setWeek(calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH)); // 开始时间是某月的第几个星期几
        }
        if (Strings.isNotBlank(params[10])) {
            calEventPeriodicalInfo.setMonth(Integer.valueOf(params[10]));
        } else {
            calEventPeriodicalInfo.setMonth(calendar.get(Calendar.MONTH) + 1);
        }
        // 周提醒，已勾选的天数
        if (Strings.isNotBlank(params[11])) {
            String curweeks = params[11];
            String[] weeks = curweeks.split(",");
            calEventInfoBO.getWeeks().clear();
            for (String week : weeks) {
                calEventInfoBO.getWeeks().add(week);
            }
        }
    }

    public long saveCalEventForM1(Map<String, Object> params) throws BusinessException {
		CalEventPeriodicalInfo cInfo = new CalEventPeriodicalInfo();
		CalEvent calEvent = new CalEvent();
		CalContent calContent = new CalContent();
		CalEvent oldCalEvent = null;
		if (params.get("calEventID") != null && !("-1").equals(params.get("calEventID"))) {
			oldCalEvent = getCalEventById(Long.valueOf(params.get("calEventID").toString()));
		}
		Long recordid = null;
		if (Strings.isNotBlank((String) params.get("fromRecordId")) && !("-1").equals(params.get("fromRecordId"))) {
			recordid = Long.valueOf(params.get("fromRecordId").toString());
		}
		calEvent.setFromRecordId(recordid);
		Boolean isNew = initCalEventFromPage(params, calEvent, calContent, cInfo);
		initCalEventByShareType(params, calEvent); // 共享类型选择了，原本的属性要跟着变化
		initCalEventByHasVal(calEvent, isNew); // 根据已有的事件属性，得到其他联动属性
		Date endate = calEvent.getEndDate(), beginDate = calEvent.getBeginDate();
		String updateTip = params.get("updateTip") == null ? "0" : params.get("updateTip").toString();
		CalEventPeriodicalInfo oldCalEventPeriodicalInfo = null;
		if (!DateUtils.isSameDay(endate, beginDate) && (cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType().intValue() == 1 || cInfo.getPeriodicalType().intValue() == 2)
				&& !("1").equals(updateTip)) {
			throw new BusinessException(ResourceUtil.getString("calendar.event.priorityType.kuaRi"));
		}
		if (calEvent.getBeginDate().after(calEvent.getEndDate())) {
			throw new BusinessException(ResourceUtil.getString("calendar.event.date.compare"));
		}
		Boolean isFanWei = Boolean.FALSE;
		Long eventID = calEvent.getPeriodicalChildId() == null ? calEvent.getId() : calEvent.getPeriodicalChildId();
		if (("2").equals(updateTip)) {// 周期性事件判断
			// 修改前一轮的周期性事件的结束周期时间为当次时间的前一天
			oldCalEventPeriodicalInfo = calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(eventID);
			if (oldCalEventPeriodicalInfo != null) {
				isFanWei = cInfo.getBeginTime().before(oldCalEventPeriodicalInfo.getEndTime()) && cInfo.getBeginTime().after(oldCalEventPeriodicalInfo.getBeginTime())
						|| DateUtils.isSameDay(cInfo.getBeginTime(), oldCalEventPeriodicalInfo.getBeginTime()) || DateUtils.isSameDay(cInfo.getEndTime(), oldCalEventPeriodicalInfo.getEndTime());
				Date endTimeDate = Datetimes.addDate(calEvent.getBeginDate(), -1);
				if (isFanWei && endTimeDate.after(oldCalEventPeriodicalInfo.getBeginTime()) && endTimeDate.before(oldCalEventPeriodicalInfo.getEndTime())) {
					oldCalEventPeriodicalInfo.setEndTime(endTimeDate);
				} else {
					this.calEventPeriodicalInfoManager.deleteByEventId(eventID);
					oldCalEventPeriodicalInfo = null;
				}
				deleteOldPeriodical(calEvent, oldCalEventPeriodicalInfo);
			}
		}
		// 更新系统枚举状态（已启用、未启用）
		enumManagerNew.updateEnumItemRef("cal_event_type", calEvent.getCalEventType().toString());
		enumManagerNew.updateEnumItemRef("cal_event_signifyType", calEvent.getSignifyType().toString());
		// updateTip==21.用户点击了取消设置周期性事件且用户当前正在进行修改周期性行操作。 isNew 代表用户当前是新增操作
		// updateTip==1.修改周期性事件，但是不是修改周期性事件及其后续事件 updateTip==2.修改周期性事件及其后续事件
		if (cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType() != 0 && !("1").equals(updateTip)) {
			// if (isFanWei) {}
			// calEventDao.deleteCalEvent(calEvent);
			if (calEvent != null && calEvent.getId() != null) {
				calEventDao.deleteCalEventById(calEvent.getId());
			}
			QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + eventID);
			calEvent.setIdIfNew();
			// 保存附件
			saveAttachment(calEvent, calEvent.getId());
			toSendCalEventMessage(calEvent, oldCalEvent);
			getPeriodicalCalEventList(calContent, updateTip, calEvent, cInfo, oldCalEventPeriodicalInfo); // 周期性能事件处理
			if (("2").equals(updateTip) && oldCalEventPeriodicalInfo == null) {
				CalEvent parentCalEvent = calEventDao.getCalEvent(eventID);
				if (parentCalEvent != null) {
					parentCalEvent.setPeriodicalStyle(0);
					calEventDao.saveCalEvent(parentCalEvent);
				}
			}
		} else {
			Long eventId = calEvent.getId();
			calContent.setEventId(eventId); // 给事件内容对象的事件ID赋值
			deleteCalContentByEventId(eventId); // 先删除、在新增
			if (Strings.isNotBlank(calContent.getContent())) {
				saveCalContent(calContent); // 保存事件内容对象
			}
			deleteTranEventByEventId(calEvent.getId()); // 根据事件ID删除CalEventTran
			saveTranEvents(calEvent);
			// 如果是项目事件,存入该项目下当前阶段
			if (calEvent.getShareType() == ShareTypeEnum.projectOfEvent.getKey() && Strings.isNotBlank(calEvent.getTranMemberIds())) {
				saveProject(calEvent); // 保存项目事件中间表数据
			}
			
			// TODO m1设置是否有附件
			calEvent.setAttachmentsFlag(Boolean.valueOf((String)params.get("attachmentsFlag")));
			save(calEvent, oldCalEvent);
		}
		saveCalEventTOEvent(calEvent, oldCalEvent); // 保存协同立方
		try {
			if (calEvent.getFromId() != -1 && calEvent.getFromId() != null && isNew) {
				// 发送转发消息
				String repeatTitle = ParamUtil.getString(params, "repeat_title");
				planApi.sendPlanTransferOtherMessage(TransferTypeEnum.transferCal.getKey(), calEvent.getFromId(), calEvent.getId(), repeatTitle);
			}
		} catch (Exception e) {
			// System.out.println(e);
		}
		if (calEvent.getPeriodicalStyle().intValue() == 0) {// 这段代码的作用是，不是周期性事件，就只传入当前事件
			List<CalEvent> calEvents = new ArrayList<CalEvent>();
			calEvents.add(calEvent);
			eventRemind(Calendar.getInstance().getTime(), calEvent.getAlarmDate(), calEvent.getBeginDate(), ("job_" + calEvent.getId()), calEvents, cInfo);// 如果用户选择了提前时间提醒的话，要新建一个任务事件setAlarmFlag
			eventRemind(Calendar.getInstance().getTime(), calEvent.getBeforendAlarm(), calEvent.getEndDate(), (calEvent.getId() + "beforEnd_job"), calEvents, cInfo);// 结束前提醒
		}
		return calEvent.getId();
	}
    
    public void saveCalEvent(Map<String, Object> params) throws BusinessException {
        CalEventPeriodicalInfo cInfo = new CalEventPeriodicalInfo();
        CalEvent calEvent = new CalEvent();
        CalContent calContent = new CalContent();
        CalEvent oldCalEvent = null;
        if (params.get("calEventID") != null && !("-1").equals(params.get("calEventID"))) {
            oldCalEvent = getCalEventById(Long.valueOf(params.get("calEventID").toString()));
        }
        Long recordid = null;
        String fromRecordId =  ParamUtil.getString(params, "fromRecordId");
        if (Strings.isNotBlank(fromRecordId) && !("-1").equals(fromRecordId)) {
        	recordid = Long.valueOf(params.get("fromRecordId").toString());
        }
        calEvent.setFromRecordId(recordid);
        Boolean isNew = initCalEventFromPage(params, calEvent, calContent, cInfo);
        initCalEventByShareType(params, calEvent); // 共享类型选择了，原本的属性要跟着变化
        initCalEventByHasVal(calEvent, isNew); // 根据已有的事件属性，得到其他联动属性
        Date endate = calEvent.getEndDate(), beginDate = calEvent.getBeginDate();
        String updateTip = params.get("updateTip") == null ? "0" : params.get("updateTip").toString();
        CalEventPeriodicalInfo oldCalEventPeriodicalInfo = null;
        if (!DateUtils.isSameDay(endate, beginDate)
                && (cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType().intValue() == 1 || cInfo
                        .getPeriodicalType().intValue() == 2) && !("1").equals(updateTip)) {
            throw new BusinessException(ResourceUtil.getString("calendar.event.priorityType.kuaRi"));
        }
        if (calEvent.getBeginDate().after(calEvent.getEndDate())) {
            throw new BusinessException(ResourceUtil.getString("calendar.event.date.compare"));
        }
        Boolean isFanWei = Boolean.FALSE;
        Long eventID = calEvent.getPeriodicalChildId() == null ? calEvent.getId() : calEvent.getPeriodicalChildId();
        if (("2").equals(updateTip)) {// 周期性事件判断
            // 修改前一轮的周期性事件的结束周期时间为当次时间的前一天
            oldCalEventPeriodicalInfo = calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(eventID);
            isFanWei = cInfo.getBeginTime().before(oldCalEventPeriodicalInfo.getEndTime())
                    && cInfo.getBeginTime().after(oldCalEventPeriodicalInfo.getBeginTime())
                    || DateUtils.isSameDay(cInfo.getBeginTime(), oldCalEventPeriodicalInfo.getBeginTime())
                    || DateUtils.isSameDay(cInfo.getEndTime(), oldCalEventPeriodicalInfo.getEndTime());
            Date endTimeDate = Datetimes.addDate(calEvent.getBeginDate(), -1);
            if (isFanWei && endTimeDate.after(oldCalEventPeriodicalInfo.getBeginTime())
                    && endTimeDate.before(oldCalEventPeriodicalInfo.getEndTime())) {
                oldCalEventPeriodicalInfo.setEndTime(endTimeDate);
            } else {
                this.calEventPeriodicalInfoManager.deleteByEventId(eventID);
                oldCalEventPeriodicalInfo = null;
            }
            deleteOldPeriodical(calEvent, oldCalEventPeriodicalInfo);
        }
        //更新系统枚举状态（已启用、未启用）
        enumManagerNew.updateEnumItemRef("cal_event_type", calEvent.getCalEventType().toString());
        enumManagerNew.updateEnumItemRef("cal_event_signifyType", calEvent.getSignifyType().toString());
        //updateTip==21.用户点击了取消设置周期性事件且用户当前正在进行修改周期性行操作。 isNew 代表用户当前是新增操作
        //updateTip==1.修改周期性事件，但是不是修改周期性事件及其后续事件 updateTip==2.修改周期性事件及其后续事件
        if (cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType() != 0 && !("1").equals(updateTip)) {
//            if (isFanWei) {}
            //calEventDao.deleteCalEvent(calEvent);
            if(calEvent != null && calEvent.getId() != null) {
            	calEventDao.deleteCalEventById(calEvent.getId());
            }
            QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + eventID);
            calEvent.setIdIfNew();
            // 保存附件
            saveAttachment(calEvent, calEvent.getId());
            toSendCalEventMessage(calEvent, oldCalEvent);
            getPeriodicalCalEventList(calContent, updateTip, calEvent, cInfo, oldCalEventPeriodicalInfo); // 周期性能事件处理
            if (("2").equals(updateTip) && oldCalEventPeriodicalInfo == null) {
                CalEvent parentCalEvent = calEventDao.getCalEvent(eventID);
                if (parentCalEvent != null) {
                    parentCalEvent.setPeriodicalStyle(0);
                    calEventDao.saveCalEvent(parentCalEvent);
                }
            }
        } else {
            Long eventId = calEvent.getId();
            calContent.setEventId(eventId); // 给事件内容对象的事件ID赋值
            deleteCalContentByEventId(eventId); // 先删除、在新增
            if (Strings.isNotBlank(calContent.getContent())) {
                saveCalContent(calContent); // 保存事件内容对象
            }
            deleteTranEventByEventId(calEvent.getId()); // 根据事件ID删除CalEventTran
            saveTranEvents(calEvent);
            // 如果是项目事件,存入该项目下当前阶段
            if (calEvent.getShareType() == ShareTypeEnum.projectOfEvent.getKey()
                    && Strings.isNotBlank(calEvent.getTranMemberIds())) {
                saveProject(calEvent); // 保存项目事件中间表数据
            }
            // 保存附件
            saveAttachment(calEvent, calEvent.getId());
            save(calEvent, oldCalEvent);
        }
        saveCalEventTOEvent(calEvent, oldCalEvent); // 保存协同立方
        try{
            if (calEvent.getFromId() != -1 && calEvent.getFromId() != null && isNew) {
                //发送转发消息
                String repeatTitle = ParamUtil.getString(params, "repeat_title");
                planApi.sendPlanTransferOtherMessage(TransferTypeEnum.transferCal.getKey(), calEvent.getFromId(), calEvent.getId(), repeatTitle);
            }
        }catch (Exception e){
        	//System.out.println(e);
        }
        if(calEvent.getPeriodicalStyle().intValue()==0){//这段代码的作用是，不是周期性事件，就只传入当前事件
        	List<CalEvent> calEvents = new ArrayList<CalEvent>();
            calEvents.add(calEvent);
            eventRemind(Calendar.getInstance().getTime(), calEvent.getAlarmDate(), calEvent.getBeginDate(),("job_" + calEvent.getId()),calEvents,cInfo);// 如果用户选择了提前时间提醒的话，要新建一个任务事件setAlarmFlag
            eventRemind(Calendar.getInstance().getTime(), calEvent.getBeforendAlarm(), calEvent.getEndDate(), (calEvent.getId() + "beforEnd_job"),calEvents,cInfo);// 结束前提醒
        }   
    }

    /**
     * 根据事件对象得到周期性事件列表
     * 
     * @param calContent 事件内容
     * @param updateTip 修改tip
     * @param calEvent 事件对象
     * @param cInfo 周期性事件，从页面原素中新增的一个周期性事件信息对象
     * @param isNew 用户当前操作是否是新增操作
     * @param oldCalEventPeriodicalInfo 原周期性信息对象
     * @throws BusinessException
     */
    private void getPeriodicalCalEventList(CalContent calContent, String updateTip, CalEvent calEvent,
            CalEventPeriodicalInfo cInfo, CalEventPeriodicalInfo oldCalEventPeriodicalInfo) throws BusinessException {
        List<CalEvent> calEvents = new ArrayList<CalEvent>(); // 周期性事件
        List<Long> eventIDs = new ArrayList<Long>();
        List<List<Date>> daList = new ArrayList<List<Date>>();
        // 得到父id
        cInfo.setMemberId(calEvent.getCreateUserId());
        cInfo.setCalEventId(calEvent.getId()); // 给周期性事件的事件ID
        Long periodicalId = saveCalEventPeriodicalInfo(cInfo); // 保存周期性事件内容对象
        calEvent.setPeriodicalId(periodicalId); // 将周期性事件的ID保存到事件中
        calEvent.setPeriodicalStyle(cInfo.getPeriodicalType()); // 周期类型
        // 用户修改周期性事件，如果用户修改的是全部事件，才重新创建 或者用户当前是新增操作
        Map<String, Integer> dayMegMap = getCurPeriocalMeg(calEvent, cInfo); // ----根据当前用户输入的事件。周期性事件得到开始年份、结束年份、开始月份等信息
        // 取得事件本身开始时间点数 即HH：mm
        String hourStart = DateFormatUtils.format(calEvent.getBeginDate(), "HH:mm");
        // 取得事件本身结束时间点数 即HH：mm 这里取是为了按月、按年，需要跨日
        String hourEnd = DateFormatUtils.format(calEvent.getEndDate(), "HH:mm");

        if (cInfo.getPeriodicalType().intValue() == PeriodicalEnum.dayCycle.getKey()) { // 按天
            daList = getPeriodicalEventByDay(calEvent, cInfo, hourStart, hourEnd);
        } else if (cInfo.getPeriodicalType().intValue() == PeriodicalEnum.weekCycle.getKey()) { // 按周
            daList = getPeriodicalEventByWeek(calEvent, cInfo, hourStart, hourEnd);
        } else if (cInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()) { // 按月
            daList = getPeriodicalEventByMonth(calEvent, cInfo, hourStart, hourEnd, dayMegMap);
        } else if (cInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()) { // 按年
            daList = getPeriodicalEventByYear(calEvent, cInfo, hourStart, hourEnd, dayMegMap);
        }
        List<Date> curDates = new ArrayList<Date>();
        curDates.add(calEvent.getBeginDate()); // 把当前主事件的开始时间加入到列表中
        curDates.add(calEvent.getEndDate()); // 把当前主事件的结束时间加入到列表中
        daList.add(curDates);

        for (int i = 0, j = daList.size(); i < j; i++) { // 根据时间生成事件列表
            curDates = daList.get(i);
            try {
                // 根据时间生成事件列表
                getPeriodicalEvent(calEvent, calEvents, curDates.get(0), curDates.get(1), eventIDs);
            } catch (ParseException e) {
                logger.error(e.getLocalizedMessage(),e);
            }
        }
        savePeriodicalInfoMeg(calContent, oldCalEventPeriodicalInfo, calEvents, calEvent,cInfo); // 保存事件内容。日志等信息
    }

    /**
     * 根据周期性事件产生的事件保存事件对应的实践内容、发送消息、保存日志等相关信息
     * 
     * @param content 事件内容
     * @param calEvent 事件对象
     * @param oldCalEventPeriodicalInfo 原周期性信息对象
     * @param calEvents 事件对象List
     * @throws BusinessException
     */
    private void savePeriodicalInfoMeg(CalContent content, CalEventPeriodicalInfo oldCalEventPeriodicalInfo,
            List<CalEvent> calEvents, CalEvent calEvent,CalEventPeriodicalInfo cInfo) throws BusinessException {
        List<CalContent> calContents = new ArrayList<CalContent>();
        List<String[]> calEventLogs = new ArrayList<String[]>(); // 批量写入日志用到的参数
        List<Long> eventIDs = new ArrayList<Long>();
        Date today = Calendar.getInstance().getTime();
        StringBuilder messageTypes = getCalEventMegStr(calEvents.get(0), null);
        for (CalEvent cEvent : calEvents) {
            String[] LogStr = new String[3]; // 日志信息
            LogStr[0] = AppContext.getCurrentUser().getName(); // 当前操作事件的人
            LogStr[1] = cEvent.getSubject(); // 事件名称
            LogStr[2] = cEvent.getBeginDate().toString(); // 事件的开始日期
            calEventLogs.add(LogStr);
            eventIDs.add(cEvent.getId());
            if (Strings.isNotBlank(content.getContent())) {
                try {
                    CalContent temp = (CalContent) BeanUtils.cloneBean(content);
                    temp.setIdIfNew();
                    temp.setEventId(cEvent.getId());
                    calContents.add(temp);
                } catch (Exception e) {
                    logger.error(e.getLocalizedMessage(),e);
                }
            }
            
        }
     // 如果用户选择了提前时间提醒的话，要新建一个任务事件setAlarmFlag
        eventRemind(today, calEvent.getAlarmDate(), calEvent.getBeginDate(),("job_" + calEvent.getId()),calEvents,cInfo);
        eventRemind(today, calEvent.getBeforendAlarm(), calEvent.getEndDate(),(calEvent.getId() + "beforEnd_job"),calEvents,cInfo);// 结束前提醒
        eventPeriodicalInfoRemind(calEvents, messageTypes.toString(),calEvent,cInfo);
        // 批量操作日期
        appLogManager.insertLogs(AppContext.getCurrentUser(), AppLogAction.Calendar_New, calEventLogs); // 写入操作日志。
        // 新增全文检索批量操作方法还未提供
        if (AppContext.hasPlugin("index")) {
            indexManager.add(eventIDs, ApplicationCategoryEnum.calendar.getKey());
        }
        // 保存委托。安排相关数据表信息
        saveTranEvents(calEvents);
        if (CollectionUtils.isNotEmpty(calEvents)) {
            if (calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey()
                    && Strings.isNotBlank(calEvent.getTranMemberIds())) {
                saveProject(calEvents);
            }
        }
        // 如果是项目事件,存入该项目下当前阶段
        if (oldCalEventPeriodicalInfo != null) {
            calEventPeriodicalInfoManager.updateCalEventPeriodicalInfo(oldCalEventPeriodicalInfo);
        }
        // 保存事件内容
        calContentManager.saveAllContent(calContents);
        calEventDao.saveAllCalEvent(calEvents); // 保存所有的周期性事件对象列表
    }

    private void eventPeriodicalInfoRemind(List<CalEvent> calEvents, String messageTypes,CalEvent calEvent,CalEventPeriodicalInfo cInfo) throws BusinessException {
        // 提前提醒
    	String jobName = "jobPeriodicalInfo_" + calEvent.getId();
        QuartzHolder.deleteQuartzJob(jobName);
        Map<String, String> parameters = new HashMap<String, String>();
        for(CalEvent cal:calEvents){    
        	Date dateKey = cal.getBeginDate();
        	parameters.put(Datetimes.formatDate(dateKey), String.valueOf(cal.getId()));
        }
        // 增加这个参数的原因是：周期性事件产生的消息。发送人ID都为null
        parameters.put("createUserID", String.valueOf(calEvent.getCreateUserId()));
        parameters.put("type", messageTypes);
        Date temp = calEvent.getBeginDate();
		int hours = temp.getHours();
		int min = temp.getMinutes();
        if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()){ //按月
        	if(cInfo.getSwithMonth()==2){  //如果选择的是一月的第几个星期中的周几
        		String dayweek = cInfo.getDayWeek().toString(); //一周中的周几
        		String week = cInfo.getWeek().toString();       //一月中的第几周            	
        		String cronStr = "0 "+min+" "+hours+" ? * "+dayweek+"#"+week;
            	QuartzHolder.newCronQuartzJob("NULL", jobName, cronStr, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
        	}else{  //否则，执行这里
            	QuartzHolder.newQuartzJobPerMonth("NULL", jobName, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
        	}
        }else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()){ //按年
        	if(cInfo.getSwithYear()==2){
        		String dayweek = cInfo.getDayWeek().toString(); //一周中的周几
        		String week = cInfo.getWeek().toString();       //一月中的第几周   
        		String month = cInfo.getMonth().toString();
        		String cronStr = "0 "+min+" "+hours+" ? "+month+" "+dayweek+"#"+week;
            	QuartzHolder.newCronQuartzJob("NULL", jobName, cronStr, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
        	}else{
            	QuartzHolder.newQuartzJobPerYear("NULL", jobName, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
        	}
        }else{  //按天或者按周的执行这条
        	QuartzHolder.newQuartzJobPerDay("NULL", jobName, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
        }
    }

    /**
     * 消息str
     * @param calEvent 事件对象
     * @param oldCalEvent 原事件对象
     * @return
     */
    private StringBuilder getCalEventMegStr(CalEvent calEvent, CalEvent oldCalEvent) {
        StringBuilder messageTypes = new StringBuilder();
        if (Strings.isNotBlank(calEvent.getReceiveMemberId())) {
            if (calEvent.getIsEntrust() == 1) {
                messageTypes.append(CalEvent4Message.P_ON_TRANS.getKey());
            } else {
                messageTypes.append(CalEvent4Message.P_ON_PLAN.getKey());
            }
        }
        if (calEvent.getShareType() > ShareTypeEnum.personal.getKey()) {
            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) {
                messageTypes.append(",");
            }
            messageTypes.append(CalEvent4Message.P_ON_SHARE.getKey());
        }

        if (oldCalEvent != null
                && (Strings.isNotBlank(oldCalEvent.getReceiveMemberId()) || oldCalEvent.getShareType() > ShareTypeEnum.personal
                        .getKey())) {
            messageTypes.append(",");
            messageTypes.append(CalEvent4Message.P_ON_CHANG.getKey());
        }
        return messageTypes;
    }

    /**
     * 根据当前用户输入的事件。周期性事件得到开始年份、结束年份、开始月份、时间之前相隔几天、事件本身的开始号数
     * 
     * @param calEvent 事件对象
     * @param cInfo 周期性事件
     * @return
     */
    private Map<String, Integer> getCurPeriocalMeg(CalEvent calEvent, CalEventPeriodicalInfo cInfo) {
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(cInfo.getBeginTime());
        Integer startYear = calendar.get(Calendar.YEAR); // 取得事件本身重复循环的开始日期的年份.按月/按年提醒时要用
        Integer startMonth = calendar.get(Calendar.MONTH) + 1; // 取得事件本身重复循环的开始时间的月份.按月/按年提醒时要用
        calendar.setTime(cInfo.getEndTime());
        Integer endYear = calendar.get(Calendar.YEAR); // 取得事件本身的结束时间的年份.按月/按年提醒时要用
        calendar.setTime(calEvent.getBeginDate());
        Integer messageDay = calendar.get(Calendar.DATE); // 取得事件本身的开始时间的号数.按月/按年提醒时要用
        // 取得相差几天，即跨日、跨月、跨年，结束时间和开始时间相差几天
        Integer intervalDays = getIntervalDays(calEvent.getBeginDate(), calEvent.getEndDate());
        Map<String, Integer> dayMegMap = new HashMap<String, Integer>();
        dayMegMap.put("startYear", startYear);
        dayMegMap.put("endYear", endYear);
        dayMegMap.put("startMonth", startMonth);
        dayMegMap.put("messageDay", messageDay);
        dayMegMap.put("intervalDays", intervalDays);
        return dayMegMap;
    }

    /**
     * 删除之前一批时间在当前事件之后的周期性事件
     * 
     * @param calEvent 当前事件
     * @throws BusinessException
     */
    private void deleteOldPeriodical(CalEvent calEvent, CalEventPeriodicalInfo oldCalEventPeriodicalInfo)
            throws BusinessException {
        List<String[]> calEventLogs = new ArrayList<String[]>(); // 批量写入日志用到的参数
        List<Long> oldEventIDs = new ArrayList<Long>();
        List<CalEvent> calEventsFormDB = calEventDao.getAllCalEvent(calEvent, Boolean.FALSE); // 得到当前操作之后的周期性事件，然后进行删除
        if (CollectionUtils.isNotEmpty(calEventsFormDB)) {
            for (CalEvent calEventsFormDBTemp : calEventsFormDB) {
                oldEventIDs.add(calEventsFormDBTemp.getId());
                String[] LogStr = new String[3]; // 日志信息
                LogStr[0] = AppContext.getCurrentUser().getName(); // 当前操作事件的人
                LogStr[1] = calEventsFormDBTemp.getSubject(); // 事件名称
                LogStr[2] = calEventsFormDBTemp.getBeginDate().toString(); // 事件的开始日期
                calEventLogs.add(LogStr);
                QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + calEventsFormDBTemp.getId());
            }
            deleteCalReplyByEventID(oldEventIDs); // 刪除回覆信息
            deleteCalContentByEventId(oldEventIDs); // 刪除事件內容
            deleteTranEventByEventId(oldEventIDs); // 刪除事件安排/委託他人的数据
            if (AppContext.hasPlugin("project")) {
            	projectPhaseEventManager.deleteAll(oldEventIDs); // 删除项目事件中间表信息
            }
            deleteAttachmentByEventID(oldEventIDs); // 批量删除附件的方法
            // 全文检索 批量删除
            if (AppContext.hasPlugin("index")) {
                indexManager.delete(oldEventIDs, ApplicationCategoryEnum.calendar.getKey());
            }
            calEventDao.deleteCalEvent(calEventsFormDB); // 删除事件本身数据
            // 写入操作日志。 将 日程的删除
            appLogManager.insertLogs(AppContext.getCurrentUser(), AppLogAction.Calendar_Delete, calEventLogs); // 写入操作日志。
        }
    }

    /**
     * 根据开始日期，结束日期求的相差几天，包括跨月，跨年
     * 
     * @param beginDate 周期循环开始日期
     * @param endDate 周期循环结束日期
     * @return 得到---开始日期，结束日期求的相差几天
     */
    private int getIntervalDays(Date beginDate, Date endDate) {
        int days = 0;
        Calendar oneCalendar = Calendar.getInstance();
        Calendar twoCalendar = Calendar.getInstance();
        oneCalendar.setTime(beginDate);
        twoCalendar.setTime(endDate);
        while (oneCalendar.before(twoCalendar)) {
            days++;
            oneCalendar.add(Calendar.DAY_OF_YEAR, 1);
        }
        return (days - 1);
    }

    /**
     * 周期性按月提醒
     * 
     * @param calEvent 事件对象
     * @param calEventPeriodicalInfo 周期性对象
     * @param hourStart 开始点数 HH:mm
     * @param hourEnd 结束点数 HH:mm
     * @param dayMegMap 周期性事件相关信息（包括开始年份、结束年份等）；
     * @return 返回满足条件的开始时间、结束时间list
     * @throws BusinessException
     */
    private List<List<Date>> getPeriodicalEventByMonth(CalEvent calEvent,
            CalEventPeriodicalInfo calEventPeriodicalInfo, String hourStart, String hourEnd,
            Map<String, Integer> dayMegMap) throws BusinessException {
        // periodicalDateList这个属性是用于装每个周期性事件的开始时间、结束时间的。
        // 如：周期是：2.1--2.6 开始时间点是11.30结束时间点是：12：00
        // 则第一值为：2.1 11：30 & 2.1 12：00
        // 第二值为：2.2 11：30 & 2.2 12：00
        List<List<Date>> periodicalDateList = new ArrayList<List<Date>>();
        // 按照每月几号计算
        if (calEventPeriodicalInfo.getSwithMonth() == 1) {
            getSomeMonthOrYearDayNumber(dayMegMap, hourStart, hourEnd, periodicalDateList, calEvent,
                    calEventPeriodicalInfo, Boolean.TRUE);
        } else { // 按照每月某个星期几计算
            getSomeMonthSomeWeekNumber(calEvent, calEventPeriodicalInfo, dayMegMap, hourStart, hourEnd,
                    periodicalDateList, Boolean.TRUE);
        }
        return periodicalDateList;
    }

    /**
     * 周期性按年提醒
     * 
     * @param calEvent 事件对象
     * @param calEventPeriodicalInfo 周期性对象
     * @param hourStart 开始点数 HH:mm
     * @param hourEnd 结束点数 HH:mm
     * @param dayMegMap 周期性事件相关信息（包括开始年份、结束年份等）；
     * @return 返回满足条件的开始时间、结束时间list
     * @throws BusinessException
     */
    private List<List<Date>> getPeriodicalEventByYear(CalEvent calEvent, CalEventPeriodicalInfo calEventPeriodicalInfo,
            String hourStart, String hourEnd, Map<String, Integer> dayMegMap) throws BusinessException {
        // periodicalDateList这个属性是用于装每个周期性事件的开始时间、结束时间的。
        // 如：周期是：2.1--2.6 开始时间点是11.30结束时间点是：12：00
        // 则第一值为：2.1 11：30 & 2.1 12：00
        // 第二值为：2.2 11：30 & 2.2 12：00
        List<List<Date>> periodicalDateList = new ArrayList<List<Date>>();
        if (calEventPeriodicalInfo.getSwithYear() == 1) { // 按照每年的某月几日
            getSomeMonthOrYearDayNumber(dayMegMap, hourStart, hourEnd, periodicalDateList, calEvent,
                    calEventPeriodicalInfo, Boolean.FALSE);
        } else { // 按照每年某月的第几个星期几
            getSomeMonthSomeWeekNumber(calEvent, calEventPeriodicalInfo, dayMegMap, hourStart, hourEnd,
                    periodicalDateList, Boolean.FALSE);
        }
        return periodicalDateList;
    }

    /**
     * 按月--某月第几周第几日提醒.默认为当前开始时间/按年执行---某年某月第几周第几日提醒
     * 
     * @param calEvent 事件对象
     * @param cInfo 周期性对象
     * @param dayMegMap 周期性事件相关信息（包括开始年份、结束年份等）；
     * @param hourStart 开始时间点
     * @param hourEnd 结束时间点
     * @param temList 这个参数主要是保存满足条件的日期list
     * @param isMonth 当前操作是月提醒還是年提醒,如果是月提醒則true，年提醒則false
     * @throws BusinessException
     */
    private void getSomeMonthSomeWeekNumber(CalEvent calEvent, CalEventPeriodicalInfo cInfo,
            Map<String, Integer> dayMegMap, String hourStart, String hourEnd, List<List<Date>> temList, Boolean isMonth)
            throws BusinessException {
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(calEvent.getBeginDate()); // 默认日期为事件本身的开始时间
        int numberWeeK = calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH); // 开始时间是某月的第几个星期几
        int lastNumber = numberWeeK; // 如果用户选择的是最后一个星期几，则需要判断用户周期性循环的月份中最后一个星期几究竟是几号
        int weeK = calendar.get(Calendar.DAY_OF_WEEK); // 一周的星期几
        Integer endMonth = dayMegMap.get("startMonth"); // 默认为用户操作的是按年操作的月份
        if (isMonth) { // 如果用户是按月操作
            endMonth = 12; // 则将月份默认为12
        }
        int startMonth = dayMegMap.get("startMonth");
        for (int i = dayMegMap.get("startYear"); i <= dayMegMap.get("endYear"); i++) { // 遍历年份
        	if(!String.valueOf(i).equals(DateFormatUtils.format(calEvent.getBeginDate(), "yyyy"))){//add by caow 翻年后，月份从1月开始计算
        		startMonth = 1;
        	}
            for (int j = startMonth; j <= endMonth; j++) { // 遍历月份
                Date monthLastDay = null, curDate;
                do {
                    calendar.clear(); // 清空时间设置
                    calendar.set(Calendar.YEAR, i); // 设置年份
                    calendar.set(Calendar.MONTH, j - 1); // 设置月份
                    // 做这个do循环是为了用户选择的是最后一个星期几处理的，最后一个星期几按这种方式求解是有问题的，必须
                    // 把当前操作月的最大号数求出来，然后判断最后一个星期几是否大于这个最大时间，如果大于，则重新赋值，即减7天
                    // lastNumber的是意思是第几个星期几
                    calendar.set(Calendar.DAY_OF_WEEK_IN_MONTH, lastNumber);
                    calendar.set(Calendar.DAY_OF_WEEK, weeK); // 设置星期几
                    curDate = calendar.getTime(); // 根据用户设置的时间得到日期
                    calendar = new GregorianCalendar(i, j, 1); // 根据当前操作月new一个时间对象
                    calendar.add(Calendar.DATE, -1); // 设置当前操作月最大号数
                    int endday = calendar.get(Calendar.DATE); // 当前操作月最大号数
                    monthLastDay = Datetimes.parseNoTimeZone((i + "-" + j + "-" + endday), DateUtil.YEAR_MONTH_DAY_PATTERN); // 取得最大号数
                    lastNumber--;
                } while (curDate.after(monthLastDay) && numberWeeK == NumberEnum.lastWeek.getKey());
                lastNumber = numberWeeK; // 保证下一次循环进来，初始化不变
                if (DateUtils.isSameDay(curDate, calEvent.getBeginDate())) {// 如果用户操作的事件和事件本身的事件相同，则取消设置循环
                    continue;
                }
                // 如果当期操作的时间在周期性循环开始时间内，则进行添加
                if (!(curDate.before(cInfo.getBeginTime()))
                        && (curDate.before(cInfo.getEndTime()) || curDate.equals(cInfo.getEndTime()))) {
                    // 满足当前操作时间在周期性时间内还需要判断当前时间是否大于当月最大号数
                    if (!(curDate.after(monthLastDay))) {
                        List<Date> temDates = new ArrayList<Date>();
                        temDates.add(Datetimes.parseNoTimeZone(DateFormatUtils.ISO_DATE_FORMAT.format(curDate) + " " + hourStart, DateUtil.YMDHMS_PATTERN)); // 周期性时间开始时间
                        temDates.add(Datetimes.parseNoTimeZone((DateFormatUtils.ISO_DATE_FORMAT.format(Datetimes.addDate(curDate,dayMegMap.get("intervalDays"))) + " " + hourEnd), DateUtil.YMDHMS_PATTERN)); // 周期性时间结束时间
                        temList.add(temDates);
                    }
                }
            }
        }
    }

    /**
     * 按月--某月第几号提醒.默认为当前开始时间/按年执行---某年某月第几号提醒.默认为当前开始时间
     * 
     * @param dayMegMap 周期性事件相关信息（包括开始年份、结束年份等）；
     * @param hourStart 事件本身的开始时间小时数
     * @param hourEnd 事件本身的结束时间小时数
     * @param temList 这个参数主要是保存满足条件的日期list
     * @param calEvent 事件对象
     * @param cInfo 周期性对象
     * @param isMonth 用户操作的是月提醒，如果是 月，传true，如果是年，传false
     * @throws BusinessException
     */
    private void getSomeMonthOrYearDayNumber(Map<String, Integer> dayMegMap, String hourStart, String hourEnd,
            List<List<Date>> temList, CalEvent calEvent, CalEventPeriodicalInfo cInfo, Boolean isMonth)
            throws BusinessException {
        Calendar calendar = new GregorianCalendar();
        Integer endMonth = dayMegMap.get("startMonth"); // 默认情况为按年提醒的开始月份
        if (isMonth) { // 如果是按月提醒，则默认将月份定在12月
            endMonth = 12;
        }
        int j = dayMegMap.get("startMonth");
        for (int i = dayMegMap.get("startYear"); i <= dayMegMap.get("endYear"); i++) { // 遍历年份
            j = dayMegMap.get("startMonth");
            if (i != dayMegMap.get("startYear") && isMonth) {
                j = 1;
            } // --满足条件的年份
            for (; j <= endMonth; j++) { // 遍历月份
                                     // --满足条件的月份
                String curDateStr = i + "-" + j + "-" + dayMegMap.get("messageDay"); // 当前时间
                Date monthLastDay, curDate; // monthLastDay这个是当月最大号数，curDate是当前操作日期
                curDate = Datetimes.parseNoTimeZone(curDateStr, DateUtil.YEAR_MONTH_DAY_PATTERN);
                if (DateUtils.isSameDay(curDate, calEvent.getBeginDate())) {// 如果当前操作日期等于事件本身的时间，则退出当次循环
                    continue;
                }
                calendar.clear(); // 情况时间
                calendar.set(Calendar.YEAR, i); // 设置年份
                calendar.set(Calendar.MONTH, j - 1); // 设置月份
                calendar = new GregorianCalendar(i, j, 1); // 根据当前月份、年份，得到当前时间
                calendar.add(Calendar.DATE, -1); // 设置当前时间
                int endday = calendar.get(Calendar.DATE); // 得到当前月份最大的号数
                monthLastDay = Datetimes.parseNoTimeZone((i + "-" + j + "-" + endday), DateUtil.YEAR_MONTH_DAY_PATTERN); // 得到当前月份最大的号数
                // 如果当期操作的时间在周期性循环开始时间内，则进行添加
                if ((curDate.after(cInfo.getBeginTime()) || curDate.equals(cInfo.getBeginTime()))
                        && (curDate.before(cInfo.getEndTime()) || curDate.equals(cInfo.getEndTime()))) {
                    // 满足当前操作时间在周期性时间内还需要判断当前时间是否大于当月最大号数
                    if (!curDate.after(monthLastDay)) {
                        List<Date> temDates = new ArrayList<Date>();
                        temDates.add(Datetimes.parseNoTimeZone(((DateFormatUtils.ISO_DATE_FORMAT.format(curDate) + " " + hourStart)), DateUtil.YMDHMS_PATTERN)); // 开始时间
                        temDates.add(Datetimes.parseNoTimeZone((DateFormatUtils.ISO_DATE_FORMAT.format(Datetimes.addDate(curDate, dayMegMap.get("intervalDays")))+ " " + hourEnd), DateUtil.YMDHMS_PATTERN)); // 结束时间
                        temList.add(temDates);
                    }
                }
            }
        }
    }

    /**
     * 按天提醒
     * 
     * @param calEvent 事件对象
     * @param cInfo 周期性事件
     * @param hourStart 开始时间的小时数 HH：mm
     * @param hourEnd 结束时间点的小时数 HH：mm
     * @return 返回满足条件的开始时间、结束时间list
     * @throws BusinessException
     */
    private List<List<Date>> getPeriodicalEventByDay(CalEvent calEvent, CalEventPeriodicalInfo cInfo, String hourStart,
            String hourEnd) throws BusinessException {
        String beginTime = hourStart;
        String endTime = hourEnd; // 事件开始时间的格式化
        Date date = cInfo.getBeginTime();
        List<List<Date>> temList = new ArrayList<List<Date>>();
        while ((date.after(cInfo.getBeginTime()) || date.equals(cInfo.getBeginTime()))
                && (date.before(cInfo.getEndTime()) || date.equals(cInfo.getEndTime()))) { // 当前循环日期在设置的周期性循环里面
            beginTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + beginTime;
            endTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + endTime;
//            if (DateUtils.isSameDay(calEvent.getBeginDate(), Datetimes.parse(beginTime))) { // 如果事件本身的开始时间和周期性事件开始循环日期相同，则不把时间存入list中
            if (DateUtils.isSameDay(calEvent.getBeginDate(), Datetimes.parseNoTimeZone(beginTime, DateUtil.YMDHMS_PATTERN))) { // 如果事件本身的开始时间和周期性事件开始循环日期相同，则不把时间存入list中
                beginTime = hourStart;
                endTime = hourEnd;
                date = Datetimes.addDate(date, cInfo.getDayDate());
                continue;
            }
            List<Date> curDates = new ArrayList<Date>();
            curDates.add(Datetimes.parseNoTimeZone(beginTime, DateUtil.YMDHMS_PATTERN));
            curDates.add(Datetimes.parseNoTimeZone(endTime, DateUtil.YMDHMS_PATTERN));
            temList.add(curDates);
            beginTime = hourStart;
            endTime = hourEnd;
            date = Datetimes.addDate(date, cInfo.getDayDate());
        }
        return temList;
    }

    /**
     * 周期性事件是按周提醒
     * 
     * @param calEvent 事件对象
     * @param cInfo 周期性事件
     * @param hourStart 开始时间的小时数 HH：mm
     * @param hourEnd 结束时间点的小时数 HH：mm
     * @return 返回满足条件的开始时间、结束时间list
     * @throws BusinessException
     */
    private List<List<Date>> getPeriodicalEventByWeek(CalEvent calEvent, CalEventPeriodicalInfo cInfo,
            String hourStart, String hourEnd) throws BusinessException {
        String[] dayNames = { "1", "2", "3", "4", "5", "6", "7" }; // 星期天---星期六
        String[] weeks = cInfo.getWeeks().split(",");
        Calendar calendar = Calendar.getInstance();
        List<List<Date>> temList = new ArrayList<List<Date>>();
        String beginTime = hourStart;
        String endTime = hourEnd; // 事件开始时间的格式化
        Date date = cInfo.getBeginTime();
        while (!cInfo.getBeginTime().equals(cInfo.getEndTime())
                && (date.after(cInfo.getBeginTime()) || date.equals(cInfo.getBeginTime()))
                && (date.before(cInfo.getEndTime()) || date.equals(cInfo.getEndTime()))) { // 当前循环日期在设置的周期性循环里面
            calendar.setTime(date);
            int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
            if (DateUtils.isSameDay(calEvent.getBeginDate(), date)) {
                date = Datetimes.addDate(date, 1); // 每个几天加上
                continue;
            }
            for (int i = 0; i < weeks.length; i++) {
                if (weeks[i].equals(dayNames[dayOfWeek - 1])) {
                    beginTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + beginTime;
                    endTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + endTime;
                    List<Date> curDates = new ArrayList<Date>();
                    curDates.add(Datetimes.parseNoTimeZone(beginTime, DateUtil.YMDHMS_PATTERN));
                    curDates.add(Datetimes.parseNoTimeZone(endTime, DateUtil.YMDHMS_PATTERN));
                    temList.add(curDates);
                    beginTime = hourStart;
                    endTime = hourEnd;
                }
            }
            date = Datetimes.addDate(date, 1);
        }
        return temList;
    }

    /**
     * 根据calEvent 以及周期循环时间得到周期性事件
     * 
     * @param calEvent 父事件
     * @param calEvents 这个参数用于封转周期性事件list
     * @param beginDate 当前子事件的开始时间
     * @param endDate 当前子事件的结束时间
     * @param eventIDs 保存所有的子事件ID的list
     * @throws ParseException
     * @throws BusinessException
     */
    private void getPeriodicalEvent(CalEvent calEvent, List<CalEvent> calEvents, Date beginDate, Date endDate,
            List<Long> eventIDs) throws ParseException, BusinessException {
        try {
            CalEvent cInfoCalEvent = (CalEvent) BeanUtils.cloneBean(calEvent);
            if (DateUtils.isSameDay(calEvent.getBeginDate(), beginDate)) {
                cInfoCalEvent.setId(calEvent.getId());
                cInfoCalEvent.setAttachmentsFlag(calEvent.getAttachmentsFlag());
                cInfoCalEvent.setPeriodicalChildId(null);
            } else {
                cInfoCalEvent.setIdIfNew();
                cInfoCalEvent.setAttachmentsFlag(Boolean.FALSE);
                cInfoCalEvent.setPeriodicalChildId(calEvent.getId());
            }
            cInfoCalEvent.setBeginDate(beginDate);
            cInfoCalEvent.setEndDate(endDate);
            Long curEventID = cInfoCalEvent.getId();
            eventIDs.add(curEventID);
            calEvents.add(cInfoCalEvent);
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
    }

    /**
     * 根据已经赋值成功后的事件对象赋值该事件其他联动属性
     * 
     * @param calEvent 事件对象
     * @param isNew 用户是否做的是修改操作。true代表新增
     * @throws BusinessException
     */
    private void initCalEventByHasVal(CalEvent calEvent, Boolean isNew) throws BusinessException {
        if (calEvent.getStates() == StatesEnum.completed.getKey()) { // 其实个人觉得这个判断完全没有必要，但是不知道为什么，有时，明明完成率已经是100.但是传到后台确实“”
            calEvent.setCompleteRate(Float.valueOf(100));
        }
        if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 根据用户是否安排他人、委托他人，赋值事件类型
            if (calEvent.getIsEntrust().intValue() == 0) {
                calEvent.setEventflag(1);
                calEvent.setEventType(EventSourceEnum.arrangeEvent.getKey()); // 安排
            } else {
                calEvent.setEventflag(2);
                calEvent.setEventType(EventSourceEnum.entrustEvent.getKey()); // 委托
            }
            // 这里的这个判断的缘由是因为当用户做了委托、安排的时候，修改状态就会跟着状态本身的值改变
            // 一种特殊的情况下是只有在用户事件状态类型是默认状态时，才会将状态设置成已安排。当前所有的前提是，用户做了安排、委托他人的操作
            if (calEvent.getStates().intValue() == StatesEnum.toBeArranged.getKey()) {
                calEvent.setStates(StatesEnum.hasBeenArranged.getKey());
            }
        }
        // 这里的这个判断主要是用于当用户将安排、委托他人取消时，状态应该默认显示为未安排及默认状态
        if (calEvent.getReceiveMemberId() == null
                && calEvent.getShareType().intValue() == ShareTypeEnum.personal.getKey()
                && calEvent.getStates() == StatesEnum.hasBeenArranged.getKey()) {
            CalEvent oldCalEvent = calEventDao.getCalEvent(calEvent.getId());
            if (oldCalEvent != null
                    && (oldCalEvent.getReceiveMemberId() != null || oldCalEvent.getShareType().intValue() != ShareTypeEnum.personal
                            .getKey())) {
                calEvent.setStates(StatesEnum.toBeArranged.getKey());
            }
        }
        if (calEvent.getAlarmDate().intValue() >= AlarmDateEnum.enum1.getKey()
                || calEvent.getBeforendAlarm() >= AlarmDateEnum.enum1.getKey()) { // 如果用户设置了提前提醒，则提醒属性就会赋值为true
            calEvent.setAlarmFlag(Boolean.TRUE);
        } else {
            calEvent.setAlarmFlag(Boolean.FALSE);
        }
        // 这个存在的意思在于，修改的采用先删后增的模式，所以为了保证事件本身的创建时间不变而设计的。时间安排上需要根据创建时间排序
        CalEvent calEventOld = this.getCalEventById(calEvent.getId());
        if (isNew || calEventOld == null) {
            calEvent.setCreateDate(Calendar.getInstance().getTime());
            calEvent.setCreateUserId(AppContext.getCurrentUser().getId());
            calEvent.setAccountID(AppContext.currentAccountId()); // 事件创建者当前的单位ID
        } else {
            calEvent.setCreateDate(calEventOld.getCreateDate());
            calEvent.setUpdateDate(Calendar.getInstance().getTime());
            calEvent.setPeriodicalChildId(calEventOld.getPeriodicalChildId());
            calEvent.setCreateUserId(calEventOld.getCreateUserId());
            calEvent.setAccountID(calEventOld.getAccountID()); // 事件创建者当前的单位ID
        }
    }

    /**
     * 保存数据的时候需要注意一些特定的值,只有当共享类型真的赋值成功后,对共享的其他属性赋值才有意义
     * 这个方法就是在用户已经赋值共享类型成功后,对共享类型其他属性进行赋值
     * 
     * @param params 页面map对象
     * @param calEvent 事件对象
     * @throws BusinessException
     */
    private void initCalEventByShareType(Map<String, Object> params, CalEvent calEvent) throws BusinessException {
        for (Object entryObj : params.entrySet()) {
            if (entryObj instanceof Map.Entry) {
                Map.Entry entry = (Map.Entry) entryObj;
                String key = null, value = null;
                if (entry.getKey() != null && entry.getValue() != null) {
                    key = entry.getKey().toString();
                    value = entry.getValue().toString();
                }
                if (Strings.isNotBlank(key) && Strings.isNotBlank(value)) {
                    if (calEvent.getShareType().intValue() == ShareTypeEnum.departmentOfEvents.getKey()
                            && ("shareTargetDep").equals(key)) { // 共享类型_共享部门事件
                        calEvent.setShareTarget(value);
                    } else if (calEvent.getShareType().intValue() == ShareTypeEnum.departmentOfEvents.getKey()
                            && ("tranMemberIdsDep").equals(key)) { // 共享类型_共享部门事件
                        calEvent.setTranMemberIds(value);
                    } else if ((calEvent.getShareType().intValue() == ShareTypeEnum.disclosedToOthers.getKey() || calEvent.getShareType().intValue() == ShareTypeEnum.publicToLearder.getKey())
                            && ("shareTargetOther").equals(key)) { // 共享类型_公开给他人
                        calEvent.setShareTarget(value);
                    } else if ((calEvent.getShareType().intValue() == ShareTypeEnum.disclosedToOthers.getKey() || calEvent.getShareType().intValue() == ShareTypeEnum.publicToLearder.getKey())
                            && ("tranMemberIdsOther").equals(key)) { // 共享类型_公开给他人
                        calEvent.setTranMemberIds(value);
                    } else if (calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey()
                            && ("projectID").equals(key) && !("0").equals(value)) { // 共享类型_项目事件
                        calEvent.setTranMemberIds(value); // 设置项目ID
                        ProjectBO project = this.getProjectByID(calEvent.getTranMemberIds()); //根据项目ID获取项目
                        calEvent.setShareTarget(project.getProjectName()); 
//                        calEvent.setFromId(project.getPhaseId() == 1 ? null : project.getPhaseId()); //项目当前阶段
                    } else if ("other".equals(key)) { // 如果安排或委托人员为空，将事件类型改回为：自建、初始
                        if (ResourceUtil.getString("calendar.event.create.person").equals(value)) {
                            calEvent.setEventflag(0);
                            calEvent.setIsEntrust(0);
                            calEvent.setEventType(EventSourceEnum.selfArrange.getKey());
                        } else if (calEvent.getReceiveMemberId() != null) {
                            calEvent.setReceiveMemberName(entry.getValue() // 接收人
                                    .toString());
                        }
                    }

                }
            }
        }
    }

    /**
     * 这个方法主要是直接将map中的值取出来然后存入到calEvent这个对象中
     * 
     * @param params 参数map
     * @param calEvent 事件对象
     * @param content 事件内容对象
     * @param cInfo 周期性事件对象
     * @return
     * @throws BusinessException
     */
    private Boolean initCalEventFromPage(Map<String, Object> params, CalEvent calEvent, CalContent content,
            CalEventPeriodicalInfo cInfo) throws BusinessException {
        calEvent.setPeriodicalStyle(0);
        if (params.get("swithMonth") != null && Strings.isNotBlank(params.get("swithMonth").toString())) {
            cInfo.setSwithMonth(Integer.parseInt(params.get("swithMonth").toString()));
        }
        if (params.get("calEventID") != null && Strings.isNotBlank(params.get("calEventID").toString())) {
            if (!("-1").equals(params.get("calEventID").toString())) {
                calEvent.setId(Long.valueOf(params.get("calEventID").toString()));
                calEvent.setUpdateDate(Calendar.getInstance().getTime());
            } else {
                calEvent.setIdIfNew();
            }
        }
        if (params.get("swithYear") != null && Strings.isNotBlank(params.get("swithYear").toString())) {
            cInfo.setSwithYear(Integer.parseInt(params.get("swithYear").toString()));
        }
        if (params.get("subject") != null && Strings.isNotBlank(params.get("subject").toString())) {
            calEvent.setSubject(params.get("subject").toString());
        }
        if (params.get("fromId") != null && Strings.isNotBlank(params.get("fromId").toString())) {
            calEvent.setFromId(Long.valueOf(params.get("fromId").toString()));
        }
        if (params.get("fromType") != null && Strings.isNotBlank(params.get("fromType").toString())) {
            calEvent.setFromType(Integer.valueOf(params.get("fromType").toString()));
        }
        if (params.get("isEntrust") != null && Strings.isNotBlank(params.get("isEntrust").toString())) {
            calEvent.setIsEntrust(Integer.valueOf(params.get("isEntrust").toString()));
        }
        if (params.get("shareType") != null && Strings.isNotBlank(params.get("shareType").toString())) {
            calEvent.setShareType(Integer.valueOf(params.get("shareType").toString()));
        }
        if (params.get("calEventType") != null && Strings.isNotBlank(params.get("calEventType").toString())) {
            calEvent.setCalEventType(Integer.valueOf(params.get("calEventType").toString()));
        } else {
            calEvent.setCalEventType(-1);
        }
        if ((params.get("beginDate") != null && Strings.isNotBlank(params.get("beginDate").toString()))
                || (params.get("endDate") != null && Strings.isNotBlank(params.get("endDate").toString()))) {
                calEvent.setBeginDate(Datetimes.parse(params.get("beginDate").toString()));
                calEvent.setEndDate(Datetimes.parse(params.get("endDate").toString()));
        }
        if (params.get("signifyType") != null && Strings.isNotBlank(params.get("signifyType").toString())) {
            Integer signifyType = Integer.valueOf(params.get("signifyType").toString());
            if (signifyType <= 1) {
                calEvent.setPriorityType(1);
            } else if (signifyType >= 4) {
                calEvent.setPriorityType(3);
            } else {
                calEvent.setPriorityType(2);
            }
            calEvent.setSignifyType(signifyType);
        } else {
            calEvent.setSignifyType(-1);
        }
        if (params.get("states") != null && Strings.isNotBlank(params.get("states").toString())) {
            calEvent.setStates(Integer.valueOf(params.get("states").toString()));
        }
        if (params.get("alarmDate") != null && Strings.isNotBlank(params.get("alarmDate").toString())) {
            calEvent.setAlarmDate(Long.valueOf(params.get("alarmDate").toString()));
        }
        if (params.get("completeRate") != null && Strings.isNotBlank(params.get("completeRate").toString())) {
            calEvent.setCompleteRate(Float.valueOf(params.get("completeRate").toString()));
        }
        if (params.get("beforendAlarm") != null && Strings.isNotBlank(params.get("beforendAlarm").toString())) {
            calEvent.setBeforendAlarm(Long.valueOf(params.get("beforendAlarm").toString()));
        }
        if (params.get("content") != null && Strings.isNotBlank(params.get("content").toString())) {
            content.setCreateDate(Calendar.getInstance().getTime());
            content.setContentType(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
            String contentStr =  params.get("content").toString();
            content.setContent(Strings.nobreakSpaceToSpace(contentStr));
        }
        if (params.get("periodicalType") != null && Strings.isNotBlank(params.get("periodicalType").toString())) {
            if (!("0").equals(params.get("periodicalType").toString())) {
                cInfo.setPeriodicalType(Integer.valueOf(params.get("periodicalType").toString()));
                calEvent.setPeriodicalStyle(cInfo.getPeriodicalType());
            }
        }
        if (params.get("dayDate") != null && Strings.isNotBlank(params.get("dayDate").toString())) {
            cInfo.setDayDate(Integer.valueOf(params.get("dayDate").toString()));
        }
        if (params.get("dayWeek") != null && Strings.isNotBlank(params.get("dayWeek").toString())) {
            try {
                cInfo.setDayWeek(Integer.valueOf(params.get("dayWeek").toString()));
            } catch (NumberFormatException e) {
                cInfo.setDayWeek(WeekEnum.valueOfByText(params.get("dayWeek").toString()).getKey());
            }
        }
        if (params.get("week") != null && Strings.isNotBlank(params.get("week").toString())) {
            try {
                cInfo.setWeek(Integer.valueOf(params.get("week").toString()));
            } catch (NumberFormatException e) {
                cInfo.setDayWeek(NumberEnum.valueOfByText(params.get("week").toString()).getKey());
            }
        }
        if (params.get("month") != null && Strings.isNotBlank(params.get("month").toString())) {
            cInfo.setMonth(Integer.valueOf(params.get("month").toString()));
        }
        if (params.get("weeks") != null && Strings.isNotBlank(params.get("weeks").toString())) {
            cInfo.setWeeks(params.get("weeks").toString());
        }
        if (params.get("periodicalChildId") != null && Strings.isNotBlank(params.get("periodicalChildId").toString())) {
            calEvent.setPeriodicalChildId(Long.valueOf(params.get("periodicalChildId").toString()));
        }
        if ((params.get("beginTime") != null && Strings.isNotBlank(params.get("beginTime").toString()))
                || (params.get("endTime") != null && Strings.isNotBlank(params.get("endTime").toString()))) {
                cInfo.setBeginTime(Datetimes.parseNoTimeZone((params.get("beginTime").toString()), DateUtil.YEAR_MONTH_DAY_PATTERN));
                if (!("1").equals(params.get("endTime").toString())) {
                	Date endTime = Datetimes.parseNoTimeZone(params.get("endTime").toString(), DateUtil.YEAR_MONTH_DAY_PATTERN);
                	Date temp1 = DateUtils.addDays(endTime, 1);
                	Date temp2 = DateUtils.addSeconds(temp1, -1);
                    cInfo.setEndTime(temp2);
                }
        }
        if (params.get("realEstimateTime") != null && Strings.isNotBlank(params.get("realEstimateTime").toString())) {
            calEvent.setRealEstimateTime(Float.valueOf(params.get("realEstimateTime").toString()));
        }
        if (params.get("workType") != null && Strings.isNotBlank(params.get("workType").toString())) {
            calEvent.setWorkType(Integer.valueOf(params.get("workType").toString()));
        }
        if (params.get("otherID") != null && Strings.isNotBlank(params.get("otherID").toString())) {
            calEvent.setReceiveMemberId(params.get("otherID").toString());
        }
        return (params.get("calEventID") != null && Strings.isNotBlank(params.get("calEventID").toString()) && ("-1")
                .equals(params.get("calEventID").toString())) ? Boolean.TRUE : Boolean.FALSE;
    }

    @Override
    public void deleteCalEvent(String idStr, String periodicalStyle) throws BusinessException {
        List<Long> ids = CommonTools.parseTypeAndIdStr2Ids(idStr);
        if (CollectionUtils.isEmpty(ids)) {
            throw new BusinessException("CalEventManagerImpl deleteCalEvent ids is null");
        }
        List<CalEvent> calEvents = new ArrayList<CalEvent>();
        List<String[]> calEventLogs = new ArrayList<String[]>(); // 批量写入日志用到的参数
        CalEventPeriodicalInfo oldCalEventPeriodicalInfo = null;
        List<Long> periodicalChildIdsList = new ArrayList<Long>();
        for (Long id : ids) {
            CalEvent calEvent = getCalEventById(id);
            // 判断是不是有事件已经被删除
            if (calEvent == null) {
                throw new BusinessException(ResourceUtil.getString("calendar.event.create.had.delete"));
            }
            Long periodicalChildId = calEvent.getPeriodicalChildId() == null ? id : calEvent.getPeriodicalChildId();
            // 只有创建人才可能删除事件
//            if (!calEvent.getCreateUserId().equals(AppContext.getCurrentUser().getId())) { 
//                throw new BusinessException(ResourceUtil.getString("calendar.error.please.reselect.4"));
//            } by xiangq 修改提示语顺序
            if (calEvent.getPeriodicalStyle().intValue() != 0) { // 当前是周期性事件
                oldCalEventPeriodicalInfo = calEventPeriodicalInfoManager
                        .getPeriodicalEventBycalEventID(periodicalChildId);
            }
            // 用户只选择了一个事件进行删除。则这个事件有可能是周期性事件,如果用户选择删除当前事件及其后续事件
            List<CalEvent> temCalEvents = calEventDao.getAllCalEvent(calEvent, Boolean.FALSE);
            int allSize = calEventDao.getAllCalEvent(calEvent, Boolean.TRUE).size();
            if (ids.size() == 1 && ("2").equals(periodicalStyle)) {
                for (CalEvent temCalEvent : temCalEvents) { // 如果当前事件是周期性事件，则需要将起对应的子事件删除
                    periodicalChildIdsList.add(temCalEvent.getId());
                    String[] LogStr = new String[3]; // 日志信息
                    LogStr[0] = AppContext.getCurrentUser().getName(); // 当前操作事件的人
                    LogStr[1] = temCalEvent.getSubject(); // 事件名称
                    LogStr[2] = temCalEvent.getBeginDate().toString(); // 事件的开始日期
                    calEventLogs.add(LogStr);
                }
                calEvents.addAll(temCalEvents);
                // 删除所选事件，并不会删除周期性信息表。而是修改了周期性重复范围的结束时间
                if (oldCalEventPeriodicalInfo != null) {
                    if (allSize <= temCalEvents.size()) {
                        calEventPeriodicalInfoManager.deleteByEventId(periodicalChildId);
                    } else {
                        oldCalEventPeriodicalInfo.setEndTime(Datetimes.addDate(calEvent.getBeginDate(), -1));
                        calEventPeriodicalInfoManager.updateCalEventPeriodicalInfo(oldCalEventPeriodicalInfo);
                    }
                }
            } else {
                calEvents.add(calEvent);
                String[] LogStr = new String[3]; // 日志信息
                LogStr[0] = AppContext.getCurrentUser().getName(); // 当前操作事件的人
                LogStr[1] = calEvent.getSubject(); // 事件名称
                LogStr[2] = calEvent.getBeginDate().toString(); // 事件的开始日期
                calEventLogs.add(LogStr);
                if (calEvent.getPeriodicalStyle().intValue() != 0 && oldCalEventPeriodicalInfo != null) { // 当前是周期性事件
                    if (allSize <= temCalEvents.size()) {
                        //OA-98032 删除单条周期事件后，修改另一条周期重复事件，修改当前事件之后的所有事件，事件窗口点击确定后报异常
//                        calEventPeriodicalInfoManager.deleteByEventId(periodicalChildId);
                    }
                }
            }
        }
        if (CollectionUtils.isNotEmpty(periodicalChildIdsList)) {
            ids = periodicalChildIdsList;
        }
        deleteCalReplyByEventID(ids); // 刪除回覆信息
        deleteCalContentByEventId(ids); // 刪除事件內容
        deleteTranEventByEventId(ids); // 刪除事件安排/委託他人的数据
        deleteAttachmentByEventID(ids); // 批量删除附件的方法
        if (AppContext.hasPlugin("project")) {
        	projectPhaseEventManager.deleteAll(ids); // 删除项目事件中间表信息
        }
        // 写入操作日志。 将 日程的删除
        appLogManager.insertLogs(AppContext.getCurrentUser(), AppLogAction.Calendar_Delete, calEventLogs); // 写入操作日志。
        if (AppContext.hasPlugin("index")) {
            indexManager.delete(ids, ApplicationCategoryEnum.calendar.getKey()); // 全文检索批量删除
        }
        deleteCalEventByIds(calEvents);
    }

    @Override
    public void saveCalEventState(CalEvent calEvent) throws BusinessException {
        CalEvent curCalEvent = getCalEventById(calEvent.getId()); // 根据事件ID得到时间对象
        CalEvent oldCalEvent = null;//suy OA-49518 在修改事件完成率时，会给当前修改人发消息，这里需要传个oldCalEvent，表明是修改事件，而不是新建
        try {
            oldCalEvent = (CalEvent) BeanUtils.cloneBean(curCalEvent);
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        curCalEvent.setStates(calEvent.getStates()); // 设置状态
        curCalEvent.setCompleteRate(calEvent.getCompleteRate()); // 完成率
        curCalEvent.setRealEstimateTime(calEvent.getRealEstimateTime()); // 实际耗时
        save(curCalEvent, oldCalEvent);
    }

    @Override
    public void saveEntrustCalEvent(List<CalEvent> calEvents) throws BusinessException {
        if (CollectionUtils.isNotEmpty(calEvents)) {
            for (int i = 0, j = calEvents.size(); i < j; i++) {
                CalEvent calEvent = getCalEventById(calEvents.get(i).getId());
                CalEvent oldCalEvent = null;
                try {
                    oldCalEvent = (CalEvent) BeanUtils.cloneBean(calEvent);
                } catch (Exception e) {
                    logger.error(e.getLocalizedMessage(),e);
                }
                if (calEvent != null) { // 如果选择了委托事件，则设置“委托”字段，并发送消息给委托人
                    calEvent.setEventflag(2); // 事件的标识是已经委托了
                    calEvent.setEventType(EventSourceEnum.entrustEvent.getKey()); // 事件的标识是已经委托了
                    calEvent.setReceiveMemberName(calEvents.get(j - 1).getReceiveMemberName());
                    calEvent.setReceiveMemberId(calEvents.get(j - 1).getReceiveMemberId());
                    if (calEvent.getStates().intValue() == StatesEnum.toBeArranged.getKey()) {
                        calEvent.setStates(StatesEnum.hasBeenArranged.getKey());
                    }
                    calEvent.setIsEntrust(1);
                    saveCalEventTOEvent(calEvent, oldCalEvent); // 执行协同立方保存
                    deleteTranEventByEventId(calEvent.getId()); // 先删除之前的委托或安排记录，再保存新的委托记录
                    save(calEvent, oldCalEvent); // 保存委托事件
                    saveTranEvents(calEvent);
                }
            }
        }
    }

    @Override
    public void findCalEventState(String id,String isNew) throws BusinessException {
        CalEventInfoVO cBo = new CalEventInfoVO(); // 页面对象
        CalEvent calEvent = new CalEvent(); // 个人事件对象
        Long curUserId = AppContext.getCurrentUser().getId();
        CalEventPeriodicalInfo cinInfo = new CalEventPeriodicalInfo(); // 周期性事件对象
        String[] params = id.split("/"); // 将页面参数安，分隔。
        if (Strings.isNotBlank(params[12])) { // 判断用户是新增、修改,这里的判断是决定当用户点击高级设置的时候，什么该编辑周期性属性，当用户新增、或者当用户选择了修改全部事件时就能编辑了           
        	if(Strings.isNotBlank(isNew) && "0".equals(isNew)){
        		cBo.setIsNew(isNew);
        	}else if(Strings.isNotBlank(isNew) && isNew.equals(curUserId.toString())){
        		cBo.setIsNew(params[12]);
        	}else{
        		cBo.setIsNew("1");
        	}
        }
        if (Strings.isNotBlank(params[13])) { // 事件ID
            long eventID = Long.parseLong(params[13]);
            calEvent = calEventDao.getCalEvent(eventID);
            if (calEvent == null) {
                calEvent = new CalEvent(); // 个人事件对象
                calEvent.setId(eventID);
            }
        }
        CalEventPeriodicalInfo oldInfo = getPeriodicalInfoByCalEventId(calEvent.getPeriodicalChildId() == null ? calEvent
                .getId() : calEvent.getPeriodicalChildId());
        Date beginDateFirst = null, beginDate = null, endDate = null;
        if (oldInfo == null) { // 如果用户是修改非周期性属性，则不能将非周期性事件修改成周期性事件,但前提是用户当前的操作是修改而非新增
            if (calEvent.getId().longValue() != -1 && ("0").equals(cBo.getIsNew())) {
                cBo.setIsNew("1");
            }
        }
        beginDateFirst = Datetimes.parse(params[15]); // 保留第一个事件的开始时间，前台会有判断，不能设置周期性开始日期小于这个日期
        beginDate = Datetimes.parse(params[15]);
        endDate = Datetimes.parse(params[16]);
        AppContext.putRequestContext("beginDateFirst", beginDateFirst); // 保留第一个事件的开始时间，前台会有判断，不能设置周期性开始日期小于这个日期
        AppContext.putRequestContext("beginDate", beginDate);
        AppContext.putRequestContext("endDate", endDate);
        toNewCalEventState(cBo, calEvent, cinInfo, params); // 用户新增时，调用高级设置，赋初始值
        cBo.setCalEvent(calEvent);
        cBo.setCalEventPeriodicalInfo(cinInfo);

        if (WeekEnum.valueOf(cinInfo.getDayWeek()) != null) {
            AppContext.putRequestContext("dayWeek", WeekEnum.valueOf(cinInfo.getDayWeek()).getText());
        }
        if (NumberEnum.valueOf(cinInfo.getWeek()) != null) {
            AppContext.putRequestContext("numberWeek", NumberEnum.valueOf(cinInfo.getWeek()).getText());
        }
        boolean canUpdateWorkType = true;//用于判断当前人员是否可以修改事件工作状态
        if(isReceiveMember(String.valueOf(AppContext.currentUserId()), calEvent.getId())&&calEvent.getCreateUserId()!=AppContext.currentUserId()){
            canUpdateWorkType = false;
        }
        AppContext.putRequestContext("calEventInfoBO", cBo);
        AppContext.putRequestContext("canUpdateWorkType", canUpdateWorkType);
    }

    @Override
    public List<TimeCompare> findArrangeTimeDate(Map<String, Object> curMap) throws BusinessException {
        HttpServletRequest request = AppContext.getRawRequest();
        Boolean isView = (Boolean) curMap.get("isView");
        
        Map<String, Object> map = getQueryParams();
        if ((request.getParameter("curTab") != null // 事件视图
                && ("calEventView").equals(request.getParameter("curTab")) && request.getParameter("type") == null)
                || (request.getParameter("source") != null && ("arrangeMonthTimeForView").equals(request
                        .getParameter("source")))) {
        	List<CalEvent> tempList = new ArrayList<CalEvent>(); 
        	List<CalEvent> calEvents = getAllCaleventView(map); // portal日程事件视图从这个分支
        	if(Strings.isNotEmpty(curMap.get("source").toString()) && calEvents != null){ //日程事件portal && 没有事件菜单权限
        		for(CalEvent cal:calEvents){
        			if(cal.getStates().intValue()==4){
        				tempList.add(cal);
        			}
        		}
        	}
        	calEvents.removeAll(tempList);
        	List<TimeCompare> compareEvent = TimeArrangeUtil.covertCalEvents2TimeCompares(calEvents, isView);
        	Collections.sort(compareEvent);
        	return compareEvent;
        } else { // 时间视图 根据六种模块的参数得到对应的数据
            Long currentUserID = (Long) map.get("currentUserID");
            Date endDate = (Date) map.get("endDate");
            Date beginDate = (Date) map.get("beginDate");
            String weekPlanType = request.getParameter("weekPlanType");
            if(weekPlanType==null || "".equals(weekPlanType)){
                return timeArrangeManager.findTimeArrange(beginDate, endDate, currentUserID, ArrangeTimeEnum.findAll(false), ArrangeTimeStatus.findAll(),isView);
            }else{
                return timeArrangeManager.findTimeArrange(beginDate, endDate, currentUserID, ArrangeTimeEnum.findAll(false), ArrangeTimeStatus.findAll(),isView,weekPlanType);
            }

        }
    }

    /**
     * 协同立方处理---只有事件是委托、安排的情况下才会保存协同立方的数据
     * 
     * @param calEvent
     * @throws BusinessException
     */
    private void saveCalEventTOEvent(CalEvent calEvent, CalEvent oldCalEvent) throws BusinessException {
        Set<V3xOrgMember> membersSet = calendarNotifier.getMembers(calEvent, Boolean.TRUE);
        List<V3xOrgMember> members = new ArrayList<V3xOrgMember>();
        members.addAll(membersSet);
//        if (oldCalEvent != null) {
//            List<Long> createUserList = new ArrayList<Long>();
//            createUserList.add(calEvent.getCreateUserId());
//            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 即当前操作事件是安排、委托事件
//                CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//                calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//                List<Long> curMemberList = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId());
//                List<Long> oldMemberList = CommonTools.parseTypeAndIdStr2Ids(oldCalEvent.getReceiveMemberId());
//                CollCubeEvent4OldBO collCubeEvent4OldBO = new CollCubeEvent4OldBO(createUserList, createUserList,
//                        oldMemberList, curMemberList);
//                calEventTOEvent.setCollCubeEvent4OldBO(collCubeEvent4OldBO);
//                EventDispatcher.fireEvent(calEventTOEvent);
//            }
//            if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
//                HashSet<V3xOrgMember> oldRelatedUserSet = calendarNotifier.getMembers(oldCalEvent, Boolean.TRUE);
//                List<V3xOrgMember> oldRelatedUser = new ArrayList<V3xOrgMember>();
//                oldRelatedUser.addAll(oldRelatedUserSet);
//                CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//                calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//                calEventTOEvent.setIsArrangeAndShare("yes");
//                CollCubeEvent4OldBO collCubeEvent4OldBO = new CollCubeEvent4OldBO(createUserList, createUserList,
//                        oldRelatedUser, members);
//                calEventTOEvent.setCollCubeEvent4OldBO(collCubeEvent4OldBO);
//                EventDispatcher.fireEvent(calEventTOEvent);
//            }
//        } else {
//            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 即当前操作事件是安排、委托事件
//                CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//                calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//                EventDispatcher.fireEvent(calEventTOEvent);
//            }
//            if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
//                CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//                calEventTOEvent.setMembers(members);
//                calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//                calEventTOEvent.setIsArrangeAndShare("yes");
//                EventDispatcher.fireEvent(calEventTOEvent);
//            }
//        }
        //协同立方接口变化2014-03-05suy 
//        if (oldCalEvent != null){//更新事件  
//            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 即当前操作事件是安排、委托事件
//              CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//              List<Long> curMemberList = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId());
//              List<Long> oldMemberList = CommonTools.parseTypeAndIdStr2Ids(oldCalEvent.getReceiveMemberId());
//              calEventTOEvent.setIsforUpdate(true);
//              calEventTOEvent.setCurMemberList(curMemberList);
//              calEventTOEvent.setOldMemberList(oldMemberList);
//              //TODO 这个需要工作量修改 
//              //calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据         
//              EventDispatcher.fireEvent(calEventTOEvent);
//          }
//          if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {//共享事件
//              HashSet<V3xOrgMember> oldRelatedUserSet = calendarNotifier.getMembers(oldCalEvent, Boolean.TRUE);
//              HashSet<V3xOrgMember> newRelatedUserSet = calendarNotifier.getMembers(calEvent, Boolean.TRUE);
//              List<V3xOrgMember> oldRelatedUser = new ArrayList<V3xOrgMember>();
//              oldRelatedUser.addAll(oldRelatedUserSet);
//              List<V3xOrgMember> newRelatedUser = new ArrayList<V3xOrgMember>();
//              newRelatedUser.addAll(newRelatedUserSet);
//              CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//              calEventTOEvent.setIsforUpdate(true);
//              calEventTOEvent.setNewRelatedUser(newRelatedUser);
//              calEventTOEvent.setOldRelatedUser(oldRelatedUser);
//              //TODO 这个需要工作量修改 
//              //calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//              calEventTOEvent.setIsArrangeAndShare("yes");
//              EventDispatcher.fireEvent(calEventTOEvent);
//          }
//            
//        }else{//新建事件
//            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 即当前操作事件是安排、委托事件
//                CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//                //TODO 这个需要工作量修改 
//                //calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//                EventDispatcher.fireEvent(calEventTOEvent);//由于协同立方要标记是安排事件还是共享事件，[安排事件、委托事件]启用一次接口，将安排人员，委托人员送往协同立方
//            }
//            if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
//                CalEventTOEvent calEventTOEvent = new CalEventTOEvent(this);
//                calEventTOEvent.setMembers(members);
//                //TODO 这个需要工作量修改 
//                //calEventTOEvent.setCalEvent(calEvent); // 保存协同立方数据
//                calEventTOEvent.setIsArrangeAndShare("yes");//标明是共享事件
//                EventDispatcher.fireEvent(calEventTOEvent);//将共享事件的人员信息送往协同立方
//            }
//        }
        //6.0解耦要求：协同立方数据入库方式发生改变ouyp
        List<Long> shareMembersLong = this.v3xOrgMembersToLongs(members);
        if (oldCalEvent != null){//更新事件  
            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 即当前操作事件是安排、委托事件
              CalEventUpdateEvent e = new CalEventUpdateEvent(this);
              e.setCalEventBO(this.toCalEventBo(calEvent)); //将PO转换为对外的BO发送出去
              EventDispatcher.fireEvent(e);
          }
          if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {//共享事件
              Set<V3xOrgMember> newRelatedUserSet = calendarNotifier.getMembers(calEvent, Boolean.TRUE);
              CalEventUpdateEvent e = new CalEventUpdateEvent(this);
              e.setRelatedUser(v3xOrgMembersToLongs(newRelatedUserSet)); //事件接收者IDs
              e.setSharedMembers(shareMembersLong); //事件共享者IDs
              e.setCalEventBO(this.toCalEventBo(calEvent));
              EventDispatcher.fireEvent(e);
          }
        }else{//新建事件
            if (Strings.isNotBlank(calEvent.getReceiveMemberId())) { // 即当前操作事件是安排、委托事件
                CalEventAddEvent e = new CalEventAddEvent(this);
                List<Long> memberlist=new ArrayList<Long>();
                memberlist.add(AppContext.getCurrentUser().getId());
                e.setCurMemberList(memberlist);
                List<Long> shareList=new ArrayList<Long>();
                shareList.addAll(CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId()));
            	e.setSharedMembers(shareList);
                e.setCalEventBO(this.toCalEventBo(calEvent)); //保存协同立方数据
                EventDispatcher.fireEvent(e);
            }
            if (calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
            	CalEventAddEvent e = new CalEventAddEvent(this);
            	List<Long> memberlist=new ArrayList<Long>();
                memberlist.add(AppContext.getCurrentUser().getId());
                e.setCurMemberList(memberlist);
            	e.setSharedMembers(shareMembersLong); //事件共享者IDs
            	e.setCalEventBO(this.toCalEventBo(calEvent)); //保存协同立方数据
            	EventDispatcher.fireEvent(e);//将共享事件的人员信息送往协同立方
            }
        }
    }
    
	private List<Long> v3xOrgMembersToLongs(Collection<V3xOrgMember> members) {
		if (!CollectionUtils.isEmpty(members)) {
			List<Long> list = new ArrayList<Long>(members.size());
			for (V3xOrgMember m : members) {
				list.add(m.getId());
			}
			return list;
		}
		return null;
	}
    
    @Override
    public void saveCalEventEntrust(String id) throws BusinessException {
        List<Long> ids = CommonTools.parseTypeAndIdStr2Ids(id); // 用户委托操作时会选择多个人。所以会以逗号隔开
        List<CalEvent> calEvents = getCalEventByIds(ids);
        AppContext.putRequestContext("calEvents", calEvents);
    }

    @Override
    public void findCalEventViewData() throws BusinessException {
        Map<String, Object> map = getQueryParams();
        List<CalEvent> calEvents = getAllCaleventView(map); // 得到事件视图数据
        List<TimeCompare> compareEvent = new ArrayList<TimeCompare>();
        compareEvent.addAll(TimeArrangeUtil.covertCalEvents2TimeCompares(calEvents,true));// 得到事件视图数据
        AppContext.putRequestContext("calevents", JSONUtil.toJSONString(compareEvent));

        if (Strings.isNotBlank(AppContext.getRawRequest().getParameter("relateMemberID"))) { // 关联人员下连接具体某天查看关联人员安排给自己的日程
            AppContext.putRequestContext("arrangePage", "calEventView4RelateMember");
        } else {
            AppContext.putRequestContext("arrangePage", "calEventView");
        }

    }
    @Override
    public void findCalEventViewDataforLeader(String targetId) throws BusinessException {
        Map<String, Object> map = getQueryParams();
        map.put("userId", targetId);
        List<CalEvent> calEvents = getAllCaleventViewforleader(map); // 得到事件视图数据
        List<TimeCompare> compareEvent = new ArrayList<TimeCompare>();
        compareEvent.addAll(TimeArrangeUtil.covertCalEvents2TimeCompares(calEvents,true));// 得到事件视图数据
        AppContext.putRequestContext("calevents", JSONUtil.toJSONString(compareEvent));
        AppContext.putRequestContext("arrangePage", "calEventView");
    }
    @Override
    public String toSureIsRightDate(CalEventPeriodicalInfo calEventPeriodicalInfo) throws BusinessException {
        if (calEventPeriodicalInfo.getPeriodicalType().intValue() == PeriodicalEnum.dayCycle.getKey() // 如果用户选择的按天、按周循环 。则需要判断当前循环周期是否大于了一年。大于后给出提示
                || calEventPeriodicalInfo.getPeriodicalType().intValue() == PeriodicalEnum.weekCycle.getKey()) {
            if (Datetimes.addYear(calEventPeriodicalInfo.getBeginTime(), 1).before(calEventPeriodicalInfo.getEndTime())) {
                return ResourceUtil.getString("calendar.event.priorityType.day.tip");
            }
        } else if (calEventPeriodicalInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()
                || calEventPeriodicalInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()) {
            if (Datetimes.addYear(calEventPeriodicalInfo.getBeginTime(), 10) // 如果用户选择的按月、按年循环。则需要判断当前循环周期是否大于10年。大于后给出提示
                    .before(calEventPeriodicalInfo.getEndTime())) {
                return ResourceUtil.getString("calendar.event.priorityType.month.tip");
            }
        }
        return ""; // 否则返回空。
    }

    @Override
    public FlipInfo getStatisticCalEventInfoBOF8(FlipInfo flipInfo, Map<String, Object> map) throws BusinessException {
        Long userID = AppContext.getCurrentUser().getId();
        if (map.get("createUserId") != null && Strings.isNotBlank(map.get("createUserId").toString())) { // 如果搜索人为空，则默认为当前登陆人员
            userID = Long.valueOf(map.get("createUserId").toString());
        }
        map.put("createUserId", userID);
        Date beginDate = Calendar.getInstance().getTime();
        // 如果开始时间为空。则把当前时间作为开始时间
        if (map.get("beginDate") != null && Strings.isNotBlank(map.get("beginDate").toString())) { // 如果搜索时间为空，则默认为当天
            beginDate = Datetimes.parse(map.get("beginDate").toString());
        }
        map.put("beginDate", beginDate); // 得到开始时间
        map.put("endDate", Datetimes.addDate(beginDate, 1)); // 得到结束日期
        // f8模块穿透查看事件数据 主要搜索某人某天的个人事件数据
        List<CalEventInfoVO> calEventInfoBOs = getCalEventInfoBO(this.calEventDao.getStatisticCalEventInfoBOF8(flipInfo, map)
                .getData());
        flipInfo.setData(calEventInfoBOs);
        return flipInfo;
    }

    @Override
    public Integer findIndexResumeCount(Date beginDate, Date endDate) throws BusinessException { // 检索这个时间段内的事件
        return this.calEventDao.findIndexResumeCount(beginDate, endDate);
    }

    @Override
    public List<Long> findIndexResumeIDList(Date beginDate, Date endDate, Integer firstRow, Integer pageSize)
            throws BusinessException {
        FlipInfo fi = new FlipInfo();
        fi.setPage(firstRow); // 当前页码数
        fi.setSize(pageSize); // 每页显示的数量
        return this.calEventDao.findIndexResumeIDList(beginDate, endDate, fi); // 根据分页对象检索这个时间段的事件
    }

    @Override
    public Map<String, Object> findSourceInfo(Long arg0) throws BusinessException {
        return null;
    }

    @Override
    public Integer getAppEnumKey() {
        return ApplicationCategoryEnum.calendar.getKey(); // 当前应用类型
    }

    @Override
    public IndexInfo getIndexInfo(Long calEventID) throws BusinessException {
        // 按id得到事件对象
        CalEvent calEvent = calEventDao.getCalEvent(calEventID);
        if (calEvent == null) {
            return null;
        }
        CalContent calContent = this.calContentManager.getCalContentByEventId(calEventID); // 根据事件ID得到事件内容对象
        List<CalReply> replys = this.calReplyManager.getReplyListByEventId(calEventID); // 根据事件ID得到事件的回复对象列表
        IndexInfo indexInfo = new IndexInfo();
        indexInfo.setTitle(calEvent.getSubject()); // 日程的题目
        indexInfo.setStartMemberId(calEvent.getCreateUserId()); // 发起人ID
        indexInfo.setHasAttachment(calEvent.getAttachmentsFlag()); // 是否包含附件
        StringBuilder replyContent = new StringBuilder(); // 回复内容
        if (CollectionUtils.isNotEmpty(replys)) { // 如果回复对象list不为空
            for (CalReply reply : replys) { // 遍历回复对象list
                replyContent.append(Functions.showMemberName(reply.getReplyUserId())); // 回复人
                replyContent.append(reply.getReplyInfo()); // 回复内容
            }
        }
        indexInfo.setComment(replyContent.toString());
        indexInfo.setStartTime(calEvent.getBeginDate()); // 事件开始时间
        indexInfo.setEndTime(calEvent.getEndDate()); // 事件结束时间

        StringBuilder peiorityType = new StringBuilder("calendar.event.priorityType."); // 优先级
        peiorityType.append(calEvent.getPriorityType());
        indexInfo.setPriority(ResourceUtil.getString(peiorityType.toString())); // 设置优先级
        indexInfo.setState(StatesEnum.findByKey(calEvent.getStates().intValue()).getText()); // 状态
        List<String> personalCalEvent = new ArrayList<String>(); // 私人事件----事件的接受者
        List<String> departmentCalEvent = new ArrayList<String>(); // 部门事件 ----事件的接受者
        List<String> projectCalEvent = new ArrayList<String>(); // 项目事件----事件的接受者
        if (ShareTypeEnum.valueOf(calEvent.getShareType()) != ShareTypeEnum.personal) { //共享事件
            List<V3xOrgMember> curMembers = new ArrayList<V3xOrgMember>();
            curMembers.addAll(calendarNotifier.getMembers(calEvent, Boolean.TRUE));
            List<String> curList = new ArrayList<String>();
            if (CollectionUtils.isNotEmpty(curMembers)) {
                for (V3xOrgMember curMember : curMembers) {
                    curList.add(curMember.getId().toString());
                }
                if (calEvent.getShareType().intValue() == ShareTypeEnum.departmentOfEvents.getKey()) { // 部门事件
                    departmentCalEvent.addAll(curList);
                } else if (calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey()) { // 项目事件
                    projectCalEvent.addAll(curList);
                } else { // 他人事件 包括上级、下级、秘书
                    personalCalEvent.addAll(curList);
                }
            }
        }

        List<Long> receiveMemberIds = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId()); //安排、委托他人
        if (CollectionUtils.isNotEmpty(receiveMemberIds)) {
            for (Long receiveMemberId : receiveMemberIds) {
                String receiveMemberIdStr = String.valueOf(receiveMemberId);
                if (!personalCalEvent.contains(receiveMemberIdStr)) {
                    personalCalEvent.add(receiveMemberIdStr);
                }
            }
        }

        AuthorizationInfo authorizationInfo = new AuthorizationInfo();
        personalCalEvent.add(String.valueOf(calEvent.getCreateUserId()));
        if (CollectionUtils.isNotEmpty(personalCalEvent)) {
            authorizationInfo.setOwner(personalCalEvent);
        }
        authorizationInfo.setDepartment(departmentCalEvent);
        authorizationInfo.setProject(projectCalEvent);
        indexInfo.setAuthorizationInfo(authorizationInfo);

        StringBuilder calContentStr = new StringBuilder(); // 事件内容 格式：事件内容+项目名称
        calContentStr.append(calContent != null ? calContent.getContent() : ""); // 拼接事件内容
        try { // 得到项目对象
            if (Strings.isNotBlank(calEvent.getTranMemberIds())
                    && calEvent.getShareType() == ShareTypeEnum.projectOfEvent.getKey()) {
                long projectID = Long.parseLong(calEvent.getTranMemberIds());
                if (AppContext.hasPlugin("project")) {
                    ProjectBO project = projectApi.getProject(projectID);
                    if (project != null) { // 如果项目不为空
                        calContentStr.append(project.getProjectName());
                    }
                }
            }
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        indexInfo.setContent(calContentStr.toString()); // 这里的内容的格式是由事件内容+项目名称构成。。
        indexInfo.setContentType(IndexInfo.CONTENTTYPE_HTMLSTR); // 内容的类型
        indexInfo.setAuthor(Functions.showMemberName(calEvent.getCreateUserId())); // 创建者
        indexInfo.setCreateDate(calEvent.getCreateDate()); // 创建时间
        indexInfo.setAppType(ApplicationCategoryEnum.calendar); // 应用类型
        indexInfo.setEntityID(calEvent.getId()); // 事件id
        IndexUtil.convertToAccessory(indexInfo);
        return indexInfo;
    }

    @Override
    public String isOnePerson(String id) throws BusinessException {
        CalEvent calEvent = getCalEventById(Long.valueOf(id));
        if (AppContext.getCurrentUser().getId().equals(calEvent.getCreateUserId())) {
            return "yes";
        }
        return "no";
    }

    /**
     * 综合查询
     * 
     * @param cModel
     * @return
     * @throws Exception
     */
    public List<CalEvent> iSearch(ConditionModel cModel) throws BusinessException {
        String title = cModel.getTitle();
        Date beginDate = cModel.getBeginDate();
        Date endDate = cModel.getEndDate();
        Long fromUserId = cModel.getFromUserId();
        List<Long> projectSummaryIDs = new ArrayList<Long>();
        getAllProjectIDByUser(projectSummaryIDs);// 得到关联项目的 id
        return calEventDao.getISearch(fromUserId, beginDate, endDate, title, projectSummaryIDs);
    }

    public void initStatisticsDate() throws BusinessException {
        List<CtpEnumItem> calEventSignifys = enumManagerNew.getEnumItemByProCode(EnumNameEnum.cal_event_signifyType);
        List<CalEvent> calEvents = new ArrayList<CalEvent>();
        for (int i = 0, calEventSignify = calEventSignifys.size(), j = calEventSignify; i < j; i++) {
            CalEvent calEvent = new CalEvent();
            CtpEnumItem ctpEnumItem = calEventSignifys.get(i);
            calEvent.setReceiveMemberName(enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType,
                    ctpEnumItem.getEnumvalue()));
            calEvent.setReceiveMemberId(ctpEnumItem.getEnumvalue());
            calEvents.add(calEvent);
        }
        AppContext.putRequestContext("calEvents", calEvents);
    }

    @Override
    public String isHasDeleteByType(String id, String type) throws BusinessException {
        long idLong = Long.parseLong(id);
        if (TemplateEventEnum.CALEVENT.equals(type)) {
            CalEvent calEvent = calEventDao.getCalEvent(idLong);
            if (calEvent == null) {
                if (!(AppContext.getCurrentUser() == null || orgManager.getMemberById(AppContext.currentUserId()) == null)) {
                    return ResourceUtil.getString("calendar.event.create.had.delete");
                }
            } else {
                String curUserID = String.valueOf(AppContext.currentUserId());
                Set<V3xOrgMember> v3xOrgMembers = calendarNotifier.getMembers(calEvent, Boolean.FALSE);
                V3xOrgMember curMember = orgManager.getMemberById(Long.valueOf(curUserID));
                Boolean isTranMemberId = v3xOrgMembers.contains(curMember);
                if (!curUserID.equals(calEvent.getCreateUserId().toString()) && calEvent.getReceiveMemberId() != null
                        && !calEvent.getReceiveMemberId().contains(curUserID) && !isTranMemberId) {
                    return ResourceUtil.getString("calendar.event.create.have.no.power.to.hand",
                            Functions.showMemberName(calEvent.getCreateUserId()));
                }
                Boolean isCreateUser = curUserID.equals(calEvent.getCreateUserId().toString());
                Boolean isReceiveMember = calEvent.getReceiveMemberId() == null ? Boolean.FALSE : calEvent
                        .getReceiveMemberId().contains(curUserID);
                if (!(isCreateUser || isReceiveMember || isTranMemberId)) {
                    return ResourceUtil.getString("calendar.event.create.have.no.power.to.hand");
                }
            }
        } else if (TemplateEventEnum.TASK.equals(type) && AppContext.hasPlugin("taskmanage")) {
            TaskInfoBO taskInfo = taskmanageApi.getTaskInfo(idLong);
            if (taskInfo == null) {
                return ResourceUtil.getString("taskmanage.task_deleted");
            } else {
                if (!taskInfo.isCanView()) {
                    return ResourceUtil.getString("taskmanage.alert.no_auth_view_task");
                }
            }
        } else if (TemplateEventEnum.PLAN.equals(type) && AppContext.hasPlugin(TemplateEventEnum.PLAN)) {
        	PlanBO bo = planApi.getPlan(Long.parseLong(id));
        	if(bo != null){
        		return planApi.hasViewPermission(AppContext.currentUserId(), Long.parseLong(id)) + "";
        	}else{
        		return "absence";
        	}
        }
        return "";
    }

    @Override
    public String entrustMeg(String ids) throws BusinessException {
        List<Long> idList = CommonTools.parseTypeAndIdStr2Ids(ids); // 用户委托操作时会选择多个人。所以会以逗号隔开
        List<CalEvent> calEvents = getCalEventByIds(idList);
        for (CalEvent calEvent : calEvents) {
            if (calEvent.getStates() == StatesEnum.completed.getKey()) {
                return ResourceUtil.getString("calendar.event.list.cancel.event.authorized.end");
            }
            if (!calEvent.getCreateUserId().equals(AppContext.currentUserId())) {
                return ResourceUtil.getString("calendar.event.list.cancel.event.authorized.other");
            }
        }
        return "";
    }

    @Override
    public String getAttsByCalId(Long calEventID) {
        return this.attachmentManager.getAttListJSON(calEventID);
    }
    

    
    @Override
    public Boolean chackReportAuthReportIdAndViewId(Long userID, Long key) throws BusinessException{
        return performancereportApi.isAuth4Report(userID, ReportsEnum.EventStatistics.getKey());
    }
    @Override
    public List<CalEvent> getCalEventByPlanId(Long PlanId) throws BusinessException{
    	List<CalEvent> result = this.calEventDao.getCalEventByFromId(PlanId);
    	return result;
    }
    
    @Override
    public List<CalEvent> getCalEventsByFromId(Long formId) throws BusinessException{
    	List<CalEvent> result = this.calEventDao.getCalEventByFromId(formId);
    	return result;
    }
    
    /**
     * 根据事件具体项目ID列表得到事件对象列表
     * 
     * @param calEventIds 事件具体项目ID列表
     * @return 根据事件具体项目ID列表得到事件对象列表
     * @throws BusinessException
     */
    @Override
    public FlipInfo getCalEventByRecordId(FlipInfo fi,String  params) throws BusinessException {
        List<CalEvent> CalEvent = null;
        FlipInfo calEvents = new FlipInfo(); // 分页对象
        long calEventId = Long.parseLong(params);
        fi.setSize(1000);//设置1000主要考虑到有人回去转年度周期日事件，3个人转就够了，太多了，看起无意义
        calEvents = this.calEventDao.getCalEventByRecordIds(fi,calEventId);
        
        List<CalEventInfoVO> calEventInfoBOs = getCalEventInfoBO(calEvents.getData());
        fi.setData(calEventInfoBOs);
        return fi;
    }
    /**
     * 判断是否是该事件的委托人
     * @throws BusinessException 
     */
    public boolean isReceiveMember(String userid,Long calEventID) throws BusinessException{
        boolean flag = false;
        CalEvent calEvent = this.calEventDao.getCalEvent(calEventID);
        if(calEvent!=null){
            String receiveMemberId = calEvent.getReceiveMemberId();
            if(null!=receiveMemberId&&!"".equals(receiveMemberId)){
                String receiveList[] = receiveMemberId.split(",");
                for(int i=0;i<receiveList.length;i++){
                	// 客开 2018-06-20 gyz start
                	if(!"".equals(receiveList[i]) && !receiveList[i].isEmpty()){
                	// 客开 2018-06-20 gyz end
                		receiveList[i] = receiveList[i].substring(7);//去掉‘Member|’这段字符
                        if(userid.equals(receiveList[i])){
                            flag = true;
                        }
                     // 客开 2018-06-20 gyz start
                	}
                	// 客开 2018-06-20 gyz start
                }
            }
        }
        return flag;
    }
    
    @Override
    public void updateCalProName(Long projectId,String newProName) throws BusinessException{
        this.calEventDao.updateCalProName(projectId,newProName);
    }
    
    public FlipInfo getLeaderSchedulePage(FlipInfo fi, Map<String, Object> params) throws BusinessException {
        List<CalEvent> calEvents = new ArrayList<CalEvent>();
        List<CalEventInfoVO> calInfoBOs = null;
        int index = 1;
        if (params != null && params.size() > 0) {
            Long currentUserId = -1L;
            if(StringUtil.checkNull(StringUtil.filterNullObject(params.get("userId")))) {
                currentUserId = Long.parseLong(StringUtil.filterNullObject(params.get("createUserID")));
            } else {
                currentUserId = Long.parseLong(StringUtil.filterNullObject(params.get("userId")));
            }
        	V3xOrgMember member =   Functions.getMember(currentUserId);
        	params.put("userId", member.getId()+","+member.getOrgAccountId()+","+member.getOrgDepartmentId());
            
            if (fi != null) {
            	fi.setParams(params);
            }
            while (index < 5) {
                params.putAll(getLearderDate(index));
                calEvents.addAll(calEventDao.selectLeaderSchedule(null, params));
                index++;
            }
            calInfoBOs = this.convertToCalEventInfoBO(calEvents);
            if (fi != null && CollectionUtils.isNotEmpty(calInfoBOs)) {
                DBAgent.memoryPaging(calInfoBOs, fi);
            }
        }
        return fi;
    }

    public FlipInfo getLeaderSchedule(FlipInfo fi, Map<String, Object> params) throws BusinessException {
        int total = 0;
        if (params.size() > 0 && fi != null) {
        	
            if (!StringUtil.checkNull(StringUtil.filterNullObject(params.get("total")))) {
                total = Integer.parseInt(StringUtil.filterNullObject(params.get("total")));
            } else {
                total = calEventDao.selectLeaderSchedulegetcount(params);
            }
            if (!StringUtil.checkNull(StringUtil.filterNullObject(params.get("userId")))) {
            	V3xOrgMember member =   Functions.getMember(Long.parseLong(StringUtil.filterNullObject(params.get("userId"))));
            	params.put("userId", member.getId()+","+member.getOrgAccountId()+","+member.getOrgDepartmentId());
            } else {
                total = calEventDao.selectLeaderSchedulegetcount(params);
            }
            fi.setParams(params);
        }
        List<CalEvent> calEvents = new ArrayList<CalEvent>();
        List<CalEventInfoVO> calInfoBOs = null;
        int index = 1;
        int count = total - calEvents.size();
        while (count > 0 && index < 5) {
            if (params != null) {
                params.putAll(getLearderDate(index));
            }
            if (fi != null) {
                fi.setSize(count);
            }
            calEvents.addAll(calEventDao.selectLeaderSchedule(fi, params));
            count = total - calEvents.size();
            index++;
        }
        calInfoBOs = this.convertToCalEventInfoBO(calEvents);
        if (fi != null && CollectionUtils.isNotEmpty(calInfoBOs)) {
            fi.setData(calInfoBOs);
        }
        return fi;
    }
    
    public List<V3xOrgMember> getLeaderScheduleUser(Map<String, Object> params) throws BusinessException {
        List<V3xOrgMember> resultList = new ArrayList<V3xOrgMember>();
        if(params != null && params.size() > 0) {
            List<OrgMember> orgMemberList = calEventDao.selectLeaderScheduleUser(params);
            if(CollectionUtils.isNotEmpty(orgMemberList)) {
                for(OrgMember orgMember : orgMemberList) {
                    V3xOrgMember v3xOrgMember = Functions.getMember(orgMember.getId());
                    resultList.add(v3xOrgMember);
                }
            }
        }
        return resultList;
    }
    
    
    public Map<RelationType, List<PeopleRelate>>  getLeaderScheduleUsertransforrelate(List<V3xOrgMember> peoplelist) throws Exception {
        Map<RelationType, List<PeopleRelate>> relateMemberMap = new HashMap<RelationType, List<PeopleRelate>>();
        List<PeopleRelate> leaderList = new ArrayList<PeopleRelate>();

        for (int i=0;i<peoplelist.size();i++) {
            // 构造人员关联信息
        	PeopleRelate peopleRelate = new PeopleRelate();
            V3xOrgMember vm = peoplelist.get(i);
            if (vm != null && vm.getEnabled() && !vm.getIsDeleted()) {
                String relateMemberName = vm.getName();
                V3xOrgAccount account = orgManager.getAccountById(vm.getOrgAccountId());
                if (!vm.getOrgAccountId().equals(CurrentUser.get().getLoginAccount())) {
                    					relateMemberName = relateMemberName + "(" + account.getShortName() + ")";
                    					peopleRelate.setRelateMemberAccount(account.getShortName());
                }
                peopleRelate.setRelateMemberName(relateMemberName);

                if (vm.getEmailAddress() != null) {
                    peopleRelate.setRelateMemberEmail(vm.getEmailAddress());
                }
                if (vm.getTelNumber() != null) {
                	peopleRelate.setRelateMemberHandSet(vm.getTelNumber());
                }
                Long deptId = vm.getOrgDepartmentId();
                V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
                if (dept != null) {
                	peopleRelate.setRelateMemberDept(dept.getName());
                }
                Long postId = vm.getOrgPostId();
                V3xOrgPost post = orgManager.getPostById(postId);
                if (post != null) {
                	peopleRelate.setRelateMemberPost(post.getName());
                }
                peopleRelate.setRelateMemberId(vm.getId());
                peopleRelate.setRelateMemberTel(vm.getOfficeNum());
                leaderList.add(peopleRelate);

            }
        }

        relateMemberMap.put(RelationType.leader, leaderList);
        return relateMemberMap;
    }
    

    
    /**
     * 将领导日程事件数据库对象转换成页面对象
     * @param calEvents 领导日程事件列表
     * @return
     * @throws BusinessException
     */
    private List<CalEventInfoVO> convertToCalEventInfoBO(List<CalEvent> calEvents) throws BusinessException {
        List<CalEventInfoVO> vos = new ArrayList<CalEventInfoVO>();
        if (CollectionUtils.isNotEmpty(calEvents)) {
            for (CalEvent calEvent : calEvents) {
                CalEventInfoVO vo = new CalEventInfoVO();// 页面BO对象
                if (Strings.isBlank(calEvent.getReceiveMemberId())) {
                    calEvent.setReceiveMemberId(null);
                }
                vo.setCalEvent(calEvent);
                V3xOrgMember orgMember = Functions.getMember(calEvent.getCreateUserId());
                //单位
                vo.setAccountName(Functions.showOrgAccountName(calEvent.getAccountID()));
                //部门
                if(orgMember != null) {
                    V3xOrgDepartment department= Functions.getDepartment(orgMember.getOrgDepartmentId());
                    vo.setDepartMentName(department != null ? department.getName() : "");
                }
                //职务
                vo.setPostName(Functions.showMemberLeave(calEvent.getCreateUserId()));
                vos.add(vo);
            }
        }
        return vos;
    }
    
    /**
     * 获得日程事件不同时间段
     * @param chooseIndex 不同时间段索引
     * @return
     */
    private Map<String, Object> getLearderDate(int chooseIndex) {
        Map<String, Object> params = new HashMap<String, Object>();
        Date currentDate = getCurDate();
        switch (chooseIndex) {
            case 1:
                //今日
                params.put("isKuaRi", false);
                params.put("curBeginDate", currentDate);
                params.put("curEndDate", Datetimes.addDate(currentDate, 1));
                break;
            case 2:
                //跨日
                params.put("isKuaRi", true);
                params.put("curBeginDate", Datetimes.addDate(currentDate, 1));
                params.put("curEndDate", currentDate);
                break;
            case 3:
                //明日
                params.put("isKuaRi", false);
                params.put("curBeginDate", Datetimes.addDate(currentDate, 1));
                params.put("curEndDate", Datetimes.addDate(currentDate, 2));
                break;
            case 4:
                //更晚
                params.put("isKuaRi", false);
                params.put("curBeginDate", Datetimes.addDate(currentDate, 2));
                params.put("curEndDate", "");
                break;
            default:
                break;
        }
        return params;
    }
    
//    /**
//     * 获得共享或个人列表
//     * @param curTab all为共享 其他为个人事件
//     * @return
//     * @throws BusinessException
//     */
//    @Override
//    public List<CalEvent> findAllShareEventList(Long userId) throws BusinessException {
//    	//FixedMe: 直接设置为Integer的最大值，从而减少一次查询
//        //获取共享事件的总数，作为分页对象的size
//    	//Map<String, Object> map = new HashMap<String, Object>();
//        //map.put("createUserID", userId);
//        //Long size = this.getShareSize(map);
//        int size = Integer.MAX_VALUE;
//    	FlipInfo flipinfo = new FlipInfo();
//        flipinfo.setSize(size);
//        List<CalEvent> calEvents = this.getAllShareEvent(flipinfo, new CalEvent());//全部共享
//        return calEvents;
//    }
    
    @Override
	public CalEventBO toCalEventBo(CalEvent calEvent) throws BusinessException {
		if (calEvent == null) {
			return null;
		}
		// -----------------------------------PO转BO开始
		CalEventBO bo = new CalEventBO();
		bo.setId(calEvent.getId());
		bo.setSubject(calEvent.getSubject());
		bo.setAttachmentsFlag(calEvent.getAttachmentsFlag());
		bo.setCreateDate(calEvent.getCreateDate());
		bo.setCreateUserId(calEvent.getCreateUserId());
		bo.setBeginDate(calEvent.getBeginDate());
		bo.setEndDate(calEvent.getEndDate());
		bo.setEventType(calEvent.getCalEventType());
		bo.setStates(calEvent.getStates());
		bo.setTranMemberIds(calEvent.getTranMemberIds());
		bo.setShareType(calEvent.getShareType());
		bo.setShareTarget(calEvent.getShareTarget());
		bo.setReceiveMemberId(calEvent.getReceiveMemberId());
		bo.setReceiveMemberName(calEvent.getReceiveMemberName());
		bo.setFromType(calEvent.getFromType());
		bo.setFromId(calEvent.getFromId());
		bo.setFromRecordId(calEvent.getFromRecordId());
		bo.setIsEntrust(calEvent.getIsEntrust());
		// -----------------------------------PO转BO结束
		return bo;
	}
    
    @Override
	public List<CalEventBO> toCalEventBos(List<CalEvent> calEvents) throws BusinessException {
		if (calEvents == null || calEvents.size() == 0) {
			return Collections.emptyList();
		}
		List<CalEventBO> bos = new ArrayList<CalEventBO>();
		for (CalEvent calEvent : calEvents) {
			bos.add(this.toCalEventBo(calEvent));
		}
		return bos;
	}
    
    @Override
    public void updateCalEvent(CalEvent calEvent) throws BusinessException {
    	this.calEventDao.updateCalEvent(calEvent);
    }
    
    @Override
    public void deleteCalEvent(Long id) throws BusinessException {
    	this.calEventDao.deleteCalEventById(id);
    }
    
    @Override
    public void deleteCalEvents(List<Long> ids) throws BusinessException {
    	List<CalEvent> calEvents = this.calEventDao.getCalEventByIds(ids);
    	this.calEventDao.deleteCalEvent(calEvents);
    }

	@SuppressWarnings("deprecation")
	@Override
	public FlipInfo queryProjectCalEventByCondition(FlipInfo flipInfo,
			Map<String, Object> param) throws BusinessException {
		Long  projectId = ParamUtil.getLong(param, "projectId");
    	Long  phaseId = ParamUtil.getLong(param, "phaseId");
    	String condition = ParamUtil.getString(param, "condition");
        String title = ParamUtil.getString(param, "title");
        String author = ParamUtil.getString(param, "author");
        String beginTime = ParamUtil.getString(param, "beginTime","");
        String endTime = ParamUtil.getString(param, "endTime","");
        String conditionValue = null;
        if("title".equals(condition) && !StringUtil.checkNull(title)){
        	conditionValue = title;
        }else if("author".equals(condition) && !StringUtil.checkNull(author) ){
        	conditionValue = author;
        }else if("date_time".equals(condition) &&  (!StringUtil.checkNull(beginTime) ||  !StringUtil.checkNull(endTime)) ){
        	conditionValue = beginTime + "," + endTime;
        }
		List<CalEvent>	calEvents = calEventDao.queryProjectEvents(AppContext.currentUserId(), projectId, phaseId, condition, conditionValue, flipInfo);
		List<Map<String,Object>> calEventMapBeans= new ArrayList<Map<String,Object>>();
		//栏目更多页面要显示创建名称，只有先创建一个Map返回
		for(CalEvent calEvent : calEvents){
			try {
				@SuppressWarnings("unchecked")
				Map<String,Object> map = BeanUtilsBean.getInstance().describe(calEvent);
				map.put("canEdit", (calEvent.isReceiveMember(AppContext.currentUserId())|| calEvent.getCreateUserId() == AppContext.currentUserId()));
				map.put("createUserName",Functions.showMemberNameOnly(calEvent.getCreateUserId()));
				map.put("createDate",DateUtil.format(calEvent.getCreateDate(),DateUtil.YMDHMS_PATTERN));
				calEventMapBeans.add(map);
			} catch (Exception e) {
				logger.error("项目日程更多页面  javabean 装换 map出错 projectId = " + projectId +" , phaseId = " + phaseId, e);
			}
		}
		flipInfo.setData(calEventMapBeans);
		return flipInfo;
	}

	@Override
	public List<CalEvent> findCalEventListByUserId(Map<String, Object> params, User user) throws BusinessException {
		Map<String, Object> map = new HashMap<String, Object>();
		if (params != null) {
			map.putAll(params);
		}
		map.put("createUserID", user.getId());
		return this.calEventDao.findCalEventListByUserId(map);
	}

    @Override
    public boolean isShowIndexSummary(Long id, Map<String, String> extendProperties) throws BusinessException {
        return true;
    }

}
