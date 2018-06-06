//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.calendar.manager;

import com.seeyon.apps.agent.bo.AgentDetailModel;
import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.calendar.bo.CalEventInfoBO;
import com.seeyon.apps.calendar.dao.CalEventDao;
import com.seeyon.apps.calendar.enums.AlarmDateEnum;
import com.seeyon.apps.calendar.enums.ArrangeTimeEnum;
import com.seeyon.apps.calendar.enums.CalEvent4Message;
import com.seeyon.apps.calendar.enums.EventSourceEnum;
import com.seeyon.apps.calendar.enums.IcomEnumForCalendar;
import com.seeyon.apps.calendar.enums.NumberEnum;
import com.seeyon.apps.calendar.enums.PeriodicalEnum;
import com.seeyon.apps.calendar.enums.ShareTypeEnum;
import com.seeyon.apps.calendar.enums.StatesEnum;
import com.seeyon.apps.calendar.enums.TemplateEventEnum;
import com.seeyon.apps.calendar.enums.WeekEnum;
import com.seeyon.apps.calendar.event.CalEventTOEvent;
import com.seeyon.apps.calendar.po.CalContent;
import com.seeyon.apps.calendar.po.CalEvent;
import com.seeyon.apps.calendar.po.CalEventPeriodicalInfo;
import com.seeyon.apps.calendar.po.CalEventTran;
import com.seeyon.apps.calendar.po.CalReply;
import com.seeyon.apps.calendar.po.TimeCalEvent;
import com.seeyon.apps.calendar.po.TimeCompare;
import com.seeyon.apps.calendar.util.CalendarNotifier;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.apps.index.bo.AuthorizationInfo;
import com.seeyon.apps.index.bo.IndexInfo;
import com.seeyon.apps.index.manager.IndexEnable;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.index.util.IndexUtil;
import com.seeyon.apps.performanceReport.enums.ReportsEnum;
import com.seeyon.apps.performanceReport.manager.ReportAuthManager;
import com.seeyon.apps.plan.enums.TransferTypeEnum;
import com.seeyon.apps.plan.manager.PlanManager;
import com.seeyon.apps.plan.po.Plan;
import com.seeyon.apps.project.manager.ProjectQueryManager;
import com.seeyon.apps.taskmanage.bo.TaskInfoBO;
import com.seeyon.apps.taskmanage.dao.TaskInfoDao;
import com.seeyon.apps.taskmanage.enums.TaskPurviewEnums;
import com.seeyon.apps.taskmanage.manager.TaskInfoManager;
import com.seeyon.apps.taskmanage.po.TaskInfo;
import com.seeyon.apps.taskmanage.util.ConvertUtil;
import com.seeyon.apps.taskmanage.util.MenuPurviewUtil;
import com.seeyon.apps.taskmanage.util.TaskPurviewUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
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
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.edoc.webmodel.EdocSummaryModel;
import com.seeyon.v3x.isearch.model.ConditionModel;
import com.seeyon.v3x.meeting.bo.Meeting;
import com.seeyon.v3x.meeting.manager.MeetingManager;
import com.seeyon.v3x.peoplerelate.RelationType;
import com.seeyon.v3x.peoplerelate.domain.PeopleRelate;
import com.seeyon.v3x.peoplerelate.manager.PeopleRelateManager;
import com.seeyon.v3x.project.domain.ProjectPhaseEvent;
import com.seeyon.v3x.project.domain.ProjectSummary;
import com.seeyon.v3x.project.manager.ProjectManager;
import com.seeyon.v3x.project.manager.ProjectPhaseEventManager;
import com.seeyon.v3x.worktimeset.domain.WorkTimeCurrency;
import com.seeyon.v3x.worktimeset.exception.WorkTimeSetExecption;
import com.seeyon.v3x.worktimeset.manager.WorkTimeSetManager;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CalEventManagerImpl implements CalEventManager, IndexEnable {
    private static final Log logger = LogFactory.getLog(CalEventManagerImpl.class);
    private EnumManager enumManagerNew;
    private EdocManager edocManager;
    private EdocSummaryManager edocSummaryManager;
    private CalEventDao calEventDao;
    private ProjectManager projectManager;
    private IndexManager indexManager;
    private ColManager colManager;
    private CalendarNotifier calendarNotifier;
    private OrgManager orgManager;
    private AttachmentManager attachmentManager;
    private AppLogManager appLogManager;
    private ProjectPhaseEventManager projectPhaseEventManager;
    private PeopleRelateManager peopleRelateManager;
    private CalContentManager calContentManager;
    private CalReplyManager calReplyManager;
    private CalEventTranManager calEventTranManager;
    private CalEventPeriodicalInfoManager calEventPeriodicalInfoManager;
    private FileToExcelManager fileToExcelManager;
    private TaskInfoManager taskInfoManager;
    private PlanManager planManager;
    private MeetingManager meetingManager;
    private WorkTimeSetManager workTimeSetManager;
    private ReportAuthManager reportAuthManager;
    private ProjectQueryManager projectQueryManager;
    private TaskInfoDao taskInfoDao;
    private int dataCount = 0;

    public CalEventManagerImpl() {
    }

    public void setReportAuthManager(ReportAuthManager reportAuthManager) {
        this.reportAuthManager = reportAuthManager;
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

    public void setMeetingManager(MeetingManager meetingManager) {
        this.meetingManager = meetingManager;
    }

    public void setCalendarNotifier(CalendarNotifier calendarNotifier) {
        this.calendarNotifier = calendarNotifier;
    }

    public void setPlanManager(PlanManager planManager) {
        this.planManager = planManager;
    }

    public void setTaskInfoManager(TaskInfoManager taskInfoManager) {
        this.taskInfoManager = taskInfoManager;
    }

    public void setProjectPhaseEventManager(ProjectPhaseEventManager projectPhaseEventManager) {
        this.projectPhaseEventManager = projectPhaseEventManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public void setEdocManager(EdocManager edocManager) {
        this.edocManager = edocManager;
    }

    public void setEdocSummaryManager(EdocSummaryManager edocSummaryManager) {
        this.edocSummaryManager = edocSummaryManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setCalEventPeriodicalInfoManager(CalEventPeriodicalInfoManager calEventPeriodicalInfoManager) {
        this.calEventPeriodicalInfoManager = calEventPeriodicalInfoManager;
    }

    public void setColManager(ColManager colManager) {
        this.colManager = colManager;
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

    public void setProjectManager(ProjectManager projectManager) {
        this.projectManager = projectManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setWorkTimeSetManager(WorkTimeSetManager workTimeSetManager) {
        this.workTimeSetManager = workTimeSetManager;
    }

    public void setProjectQueryManager(ProjectQueryManager projectQueryManager) {
        this.projectQueryManager = projectQueryManager;
    }

    public void setTaskInfoDao(TaskInfoDao taskInfoDao) {
        this.taskInfoDao = taskInfoDao;
    }

    public static String[] getAllAndSDateDFormat() {
        String[] dateFormate = new String[]{"yyyy-MM-dd", "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss.S"};
        return dateFormate;
    }

    public String ajaxGetEventName(long id) throws BusinessException {
        return this.getCalEventById(Long.valueOf(id), Boolean.FALSE).getSubject();
    }

    public void getDateForTypeAndModule(String appID, String beginDate, String endDate, String dateType, CalEvent calEvent) throws WorkTimeSetExecption, Exception {
        if(Strings.isNotBlank(appID) && appID.equals(ModuleType.plan.getValue())) {
            String workBeginTime = "8";
            String workEndTime = "18";
            if(AppContext.hasPlugin("worktimeset")) {
                WorkTimeCurrency workTimeCurrency = this.workTimeSetManager.findComnWorkTimeSet(AppContext.getCurrentUser().getLoginAccount());
                workBeginTime = workTimeCurrency.getAmWorkTimeBeginTime();
                workEndTime = workTimeCurrency.getPmWorkTimeEndTime();
            }

            if("1".equals(dateType)) {
                String endTime;
                String startTime;
                if(Strings.isNotBlank(beginDate) && Strings.isNotBlank(endDate)) {
                    beginDate = DateFormatUtils.ISO_DATE_FORMAT.format(DateUtils.parseDate(beginDate, getAllAndSDateDFormat()));
                    endDate = DateFormatUtils.ISO_DATE_FORMAT.format(DateUtils.parseDate(endDate, getAllAndSDateDFormat()));
                    startTime = beginDate + " " + workBeginTime;
                    calEvent.setBeginDate(DateUtils.parseDate(startTime, getAllAndSDateDFormat()));
                    endTime = endDate + " " + workEndTime;
                    calEvent.setEndDate(DateUtils.parseDate(endTime, getAllAndSDateDFormat()));
                } else if(Strings.isBlank(beginDate) && Strings.isBlank(endDate)) {
                    this.getDateWithNull(calEvent, workBeginTime, workEndTime);
                } else if(Strings.isBlank(endDate)) {
                    beginDate = DateFormatUtils.ISO_DATE_FORMAT.format(DateUtils.parseDate(beginDate, getAllAndSDateDFormat()));
                    startTime = beginDate + " " + workBeginTime;
                    endTime = beginDate + " " + workEndTime;
                    calEvent.setBeginDate(DateUtils.parseDate(startTime, getAllAndSDateDFormat()));
                    calEvent.setEndDate(DateUtils.parseDate(endTime, getAllAndSDateDFormat()));
                } else {
                    endDate = DateFormatUtils.ISO_DATE_FORMAT.format(DateUtils.parseDate(endDate, getAllAndSDateDFormat()));
                    startTime = endDate + " " + workBeginTime;
                    endTime = endDate + " " + workEndTime;
                    calEvent.setBeginDate(DateUtils.parseDate(startTime, getAllAndSDateDFormat()));
                    calEvent.setEndDate(DateUtils.parseDate(endTime, getAllAndSDateDFormat()));
                }
            } else {
                Date startDate;
                Date endCurDate;
                if(Strings.isNotBlank(beginDate) && Strings.isNotBlank(endDate)) {
                    startDate = DateUtil.parse(beginDate, "yyyy-MM-dd HH:mm");
                    calEvent.setBeginDate(startDate);
                    endCurDate = DateUtil.parse(endDate, "yyyy-MM-dd HH:mm");
                    calEvent.setEndDate(endCurDate);
                } else if(Strings.isBlank(beginDate) && Strings.isBlank(endDate)) {
                    this.getDateWithNull(calEvent, workBeginTime, workEndTime);
                } else if(Strings.isBlank(beginDate)) {
                    endCurDate = DateUtil.parse(endDate, "yyyy-MM-dd HH:mm");
                    calEvent.setEndDate(endCurDate);
                    calEvent.setBeginDate(Datetimes.addMinute(endCurDate, -30));
                } else {
                    startDate = DateUtil.parse(beginDate, "yyyy-MM-dd HH:mm");
                    calEvent.setBeginDate(startDate);
                    calEvent.setEndDate(Datetimes.addMinute(startDate, 30));
                }
            }
        } else {
            this.setHalfMinite(beginDate, calEvent);
        }

    }

    public void setHalfMinite(String beginDate, CalEvent calEvent) throws BusinessException {
        Calendar calendar = new GregorianCalendar();
        Date curDate = calendar.getTime();
        if(Strings.isNotBlank(beginDate)) {
            try {
                curDate = DateUtil.parse(beginDate);
            } catch (Exception var7) {
                logger.error(var7.getLocalizedMessage(), var7);
            }
        }

        calendar.setTime(curDate);
        int minute = calendar.get(12);
        if(minute <= 15) {
            calendar.set(12, 15);
        } else if(minute > 15 && minute <= 30) {
            calendar.set(12, 30);
        } else if(minute > 30 && minute <= 45) {
            calendar.set(12, 45);
        } else {
            int hour = calendar.get(10);
            calendar.set(10, hour + 1);
            calendar.set(12, 0);
        }

        calEvent.setBeginDate(calendar.getTime());
        calEvent.setEndDate(Datetimes.addMinute(calEvent.getBeginDate(), 30));
    }

    private void getDateWithNull(CalEvent calEvent, String workBeginTime, String workEndTime) {
        Plan plan = null;
        if(calEvent.getFromType().intValue() == ApplicationCategoryEnum.plan.getKey()) {
            if(AppContext.hasPlugin(TemplateEventEnum.PLAN)) {
                plan = this.planManager.selectById(calEvent.getFromId());
            }

            if(plan != null && (calEvent.getBeginDate() == null || calEvent.getEndDate() == null)) {
                try {
                    String startTime = DateFormatUtils.format(plan.getStartTime(), getAllAndSDateDFormat()[0]);
                    startTime = startTime + " " + workBeginTime;
                    calEvent.setBeginDate(DateUtils.parseDate(startTime, getAllAndSDateDFormat()));
                    String endTime = DateFormatUtils.format(plan.getEndTime(), getAllAndSDateDFormat()[0]);
                    endTime = endTime + " " + workEndTime;
                    calEvent.setEndDate(DateUtils.parseDate(endTime, getAllAndSDateDFormat()));
                } catch (ParseException var7) {
                    logger.error(var7.getLocalizedMessage(), var7);
                }
            }
        }

    }

    private Long save(CalEvent calEvent, CalEvent oldCalEvent) throws BusinessException {
        this.toSendCalEventMessage(calEvent, oldCalEvent);
        if(oldCalEvent == null) {
            this.calEventDao.saveCalEvent(calEvent);
        } else {
            this.calEventDao.updateCalEvent(calEvent);
        }

        return calEvent.getId();
    }

    private void toSendCalEventMessage(CalEvent calEvent, CalEvent oldCalEvent) throws BusinessException {
        AppLogAction appLogAction = AppLogAction.Calendar_New;
        if(oldCalEvent != null) {
            appLogAction = AppLogAction.Calendar_Update;
        }

        this.appLogManager.insertLog(AppContext.getCurrentUser(), appLogAction, new String[]{AppContext.getCurrentUser().getName(), calEvent.getSubject()});
        if(AppContext.hasPlugin("index")) {
            if(oldCalEvent == null) {
                this.indexManager.add(calEvent.getId(), Integer.valueOf(ApplicationCategoryEnum.calendar.getKey()));
            } else {
                this.indexManager.update(calEvent.getId(), Integer.valueOf(ApplicationCategoryEnum.calendar.getKey()));
            }
        }

        String messageType = this.getCalEventMegStr(calEvent, oldCalEvent).toString();
        this.calendarNotifier.sendNotifierMessageInsert(messageType, oldCalEvent, calEvent);
    }

    public CalEvent getCalEventById(Long calEventID, Boolean isToBeACalEventBO) throws BusinessException {
        CalEvent calEvent = this.calEventDao.getCalEvent(calEventID);
        if(isToBeACalEventBO.booleanValue()) {
            this.toCalEventVO(calEvent);
        }

        return calEvent;
    }

    private void deleteCalEventByIds(List<CalEvent> calEvents) throws BusinessException {
        String messageType = String.valueOf(CalEvent4Message.P_ON_DELETE.getKey());
        AppContext.getCurrentUser().getName();
        Iterator var4 = calEvents.iterator();

        while(var4.hasNext()) {
            CalEvent calEvent = (CalEvent)var4.next();
            this.calendarNotifier.sendNotifierMessageInsert(messageType, (CalEvent)null, calEvent);
            QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + calEvent.getId());
        }

        this.calEventDao.deleteCalEvent(calEvents);
    }

    private List<CalEvent> getCalEventByIds(List<Long> calEventIds) throws BusinessException {
        return this.calEventDao.getCalEventByIds(calEventIds);
    }

    private CalEventPeriodicalInfo getPeriodicalInfoByCalEventId(Long calEventID) throws BusinessException {
        return this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(calEventID);
    }

    private FlipInfo getMyOwnList(CalEvent calEvent, FlipInfo fi) throws BusinessException {
        return this.calEventDao.getMyOwnList(calEvent, fi);
    }

    public FlipInfo getMyOwnCalEventInfoBO(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException {
        FlipInfo calEvents = new FlipInfo();
        String search = (String)params.get("search");
        CalEvent calEvent = new CalEvent();
        String subject = (String)params.get("subject");
        if(Strings.isNotBlank(subject)) {
            calEvent.setSubject(subject);
        }

        String signifyType = (String)params.get("signifyType");
        if(Strings.isNotBlank(signifyType)) {
            calEvent.setSignifyType(Integer.valueOf(signifyType));
        }

        String beginDate = (String)params.get("beginDate");
        String endDate = (String)params.get("endDate");

        try {
            if(Strings.isNotBlank(beginDate)) {
                calEvent.setBeginDate(DateUtils.parseDate(beginDate, getAllAndSDateDFormat()));
            }

            if(Strings.isNotBlank(endDate)) {
                calEvent.setEndDate(DateUtils.addSeconds(DateUtils.addDays(DateUtils.parseDate(endDate, getAllAndSDateDFormat()), 1), -1));
            }
        } catch (ParseException var16) {
            logger.error(var16.getLocalizedMessage(), var16);
        }

        String states = (String)params.get("states");
        if(Strings.isNotBlank(states)) {
            calEvent.setStates(Integer.valueOf(states));
        }

        String createUserID = String.valueOf(params.get("createUserID"));
        String receiveMemberName;
        if(Strings.isNotBlank(search)) {
            receiveMemberName = null;
            if(params.get("createUsername") != null) {
                receiveMemberName = params.get("createUsername").toString();
                if(Strings.isNotBlank(receiveMemberName)) {
                    calEvent.setReceiveMemberName(receiveMemberName);
                }
            }

            if("all".equals(search)) {
                calEvents.setData(this.getAllShareEvent(flipInfo, calEvent));
            } else if("project".equals(search)) {
                calEvents.setData(this.getAllProjectEvents(flipInfo, calEvent));
            } else if("department".equals(search)) {
                if(params.get("swithDepartMentID") != null && Strings.isNotBlank(params.get("swithDepartMentID").toString())) {
                    calEvent.setFromId(Long.valueOf(params.get("swithDepartMentID").toString()));
                }

                this.getAllDepartMentEvents(flipInfo, AppContext.getCurrentUser(), calEvent);
                calEvents = flipInfo;
            } else {
                Integer count = null;
                if(!"other".equals(search)) {
                    calEvent.setCreateUserId(Long.valueOf(search));
                }

                String tranMemberIds = (String)params.get("tranMemberIds");
                if(Strings.isNotBlank(tranMemberIds)) {
                    calEvent.setTranMemberIds(tranMemberIds);
                }

                String dataSource = (String)params.get("dataSource");
                if(Strings.isNotBlank(dataSource) && params.get("fiCount") != null && Strings.isNotBlank(params.get("fiCount").toString())) {
                    count = Integer.valueOf(params.get("fiCount").toString());
                }

                this.getAllOtherEvent(flipInfo, calEvent, count);
                calEvents = flipInfo;
            }
        } else {
            if(Strings.isNotBlank(createUserID)) {
                calEvent.setCreateUserId(Long.valueOf(createUserID));
            }

            receiveMemberName = (String)params.get("workType");
            if(Strings.isNotBlank(receiveMemberName)) {
                calEvent.setWorkType(Integer.valueOf(receiveMemberName));
            }

            String calEventType = (String)params.get("calEventType");
            if(Strings.isNotBlank(calEventType)) {
                calEvent.setCalEventType(Integer.valueOf(calEventType));
            }

            calEvents = this.getMyOwnList(calEvent, flipInfo);
        }

        List<CalEventInfoBO> calEventInfoBOs = this.getCalEventInfoBO(calEvents.getData());
        flipInfo.setData(calEventInfoBOs);
        return flipInfo;
    }

    private List<CalEventInfoBO> getCalEventInfoBO(List<CalEvent> calEvents) throws BusinessException {
        List<CalEventInfoBO> calEventInfoBOs = new ArrayList();
        if(CollectionUtils.isNotEmpty(calEvents)) {
            Iterator var4 = calEvents.iterator();

            while(var4.hasNext()) {
                CalEvent calEvent = (CalEvent)var4.next();
                CalEventInfoBO calEventInfoBO = new CalEventInfoBO();
                if(Strings.isBlank(calEvent.getReceiveMemberId())) {
                    calEvent.setReceiveMemberId((String)null);
                }

                calEventInfoBO.setCalEvent(calEvent);
                calEventInfoBO.setSignifyType(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType, calEvent.getSignifyType().toString()));
                calEventInfoBO.setCalEventType(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_type, calEvent.getCalEventType().toString()));
                V3xOrgMember orgMember = Functions.getMember(calEvent.getCreateUserId());
                calEventInfoBO.setAccountName(Functions.showOrgAccountName(calEvent.getAccountID()));
                if(orgMember != null) {
                    V3xOrgDepartment department = Functions.getDepartment(orgMember.getOrgDepartmentId());
                    calEventInfoBO.setDepartMentName(department != null?department.getName():"");
                }

                calEventInfoBO.setPostName(Functions.showMemberLeave(calEvent.getCreateUserId()));
                calEventInfoBOs.add(calEventInfoBO);
            }
        }

        return calEventInfoBOs;
    }

    public CalEventInfoBO toCalEventVO(CalEvent calEvent) throws BusinessException {
        CalEvent calEventDB = null;
        CalEventInfoBO calEventInfoBO = new CalEventInfoBO();

        try {
            calEventDB = (CalEvent)BeanUtils.cloneBean(calEvent);
        } catch (Exception var12) {
            logger.error(var12.getLocalizedMessage(), var12);
        }

        if(calEventDB != null) {
            if(Strings.isBlank(calEventDB.getReceiveMemberId())) {
                calEventDB.setReceiveMemberName(ResourceUtil.getString("calendar.event.create.person"));
            }

            calEventInfoBO.setCalEvent(calEventDB);
            CalContent calContent = this.calContentManager.getCalContentByEventId(calEventDB.getId());
            calEventInfoBO.setCalContent(calContent);
            CalEventPeriodicalInfo calEventPeriodicalInfo = this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(calEventDB.getId());
            if(calEventDB.getPeriodicalChildId() != null && calEventPeriodicalInfo == null) {
                calEventPeriodicalInfo = this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(calEventDB.getPeriodicalChildId());
            }

            List<Attachment> attachments = calEventDB.getAttachmentsFlag().booleanValue()?this.attachmentManager.getByReference(calEventDB.getId(), calEventDB.getId()):null;
            if(CollectionUtils.isNotEmpty(attachments)) {
                calEventInfoBO.setSize(Integer.valueOf(attachments.size()));
            }

            if(calEventPeriodicalInfo == null) {
                calEventPeriodicalInfo = new CalEventPeriodicalInfo();
                calEventPeriodicalInfo.setBeginTime(Calendar.getInstance().getTime());
                calEventPeriodicalInfo.setEndTime(Calendar.getInstance().getTime());
            }

            calEventInfoBO.setCalEventPeriodicalInfo(calEventPeriodicalInfo);
            calEventInfoBO.setAttachmentsJSON(this.attachmentManager.getAttListJSON4JS(calEventDB.getId()));
            ProjectSummary calPrj = null;
            if(calEventDB.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey()) {
                calEventDB.setShareTarget(calEventDB.getTranMemberIds());
                Long ProjectId = Long.valueOf(Long.parseLong(calEventDB.getShareTarget()));
                calPrj = this.projectManager.getProject(ProjectId.longValue());
                calEventDB.setTranMemberIds((String)null);
                AppContext.putRequestContext("calPrj", calPrj);
            }

            List<ProjectSummary> pSummaries = this.getAllProject();
            calEventInfoBO.setProjectList(pSummaries);
            List<CalReply> cReplies = this.calReplyManager.getReplyListByEventId(calEventDB.getId());
            Iterator var11 = cReplies.iterator();

            while(var11.hasNext()) {
                CalReply calReply = (CalReply)var11.next();
                calReply.setReplyUserName(Functions.showMemberName(calReply.getReplyUserId()));
            }

            calEventInfoBO.setCalReplies(cReplies);
            if(calEventDB.getFromId() != null && calEventDB.getFromType() != null) {
                if(calEventDB.getFromType().intValue() == ApplicationCategoryEnum.collaboration.getKey()) {
                    this.hanaleCtpAffair(calEventDB, calEventInfoBO, Boolean.TRUE, Boolean.FALSE);
                } else if(!Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocSend.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocRec.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocSign.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.exSend.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.exSign.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocRegister.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocRecDistribute.getKey()))) {
                    if(calEventDB.getFromType().intValue() == ApplicationCategoryEnum.plan.getKey() && AppContext.hasPlugin("plan")) {
                        Plan plan = this.planManager.selectById(calEventDB.getFromId());
                        if(plan == null) {
                            calEventInfoBO.setHasDeletePlan("yes");
                        } else {
                            calEventInfoBO.setPlan(plan);
                        }
                    }
                } else {
                    this.hanaleCtpAffair(calEvent, calEventInfoBO, Boolean.TRUE, Boolean.TRUE);
                    AppContext.putRequestContext("isEdoc", "1");
                }
            }
        }

        AppContext.putRequestContext("calEventInfoBO", calEventInfoBO);
        return calEventInfoBO;
    }

    private void hanaleCtpAffair(CalEvent calEventDB, CalEventInfoBO calEventInfoBO, Boolean isView, Boolean isEdoc) throws BusinessException {
        if(AppContext.hasPlugin(TemplateEventEnum.COLLABORATION) || AppContext.hasPlugin(TemplateEventEnum.DOC)) {
            CtpAffair ctpAffair = this.colManager.getAffairById(calEventDB.getFromId().longValue());
            if(isView.booleanValue() && ctpAffair != null) {
                if(!this.isValid(calEventDB.getCreateUserId(), ctpAffair, isEdoc)) {
                    calEventInfoBO.setHasDeleteAffair("cancelAgent");
                }

                if(ctpAffair.isDelete().booleanValue() || ctpAffair.getState().intValue() == 5 || ctpAffair.getState().intValue() == 6 || ctpAffair.getState().intValue() == 7) {
                    calEventInfoBO.setHasDeleteAffair("yes");
                }
            }

            if(ctpAffair != null) {
                calEventInfoBO.setCtpAffair(ctpAffair);
                String showTitle = "";
                if(isEdoc.booleanValue()) {
                    showTitle = ctpAffair.getSubject();
                } else {
                    ColSummary summaryObj = this.colManager.getColSummaryById(ctpAffair.getObjectId());
                    showTitle = ColUtil.showSubjectOfSummary(summaryObj, Boolean.FALSE, -1, (String)null);
                }

                AppContext.putRequestContext("showTitle", showTitle);
            } else {
                calEventInfoBO.setHasDeleteAffair("yes");
            }
        }

    }

    private void hanaleEdoc(CalEvent calEventDB, CalEventInfoBO calEventInfoBO, Boolean isView) throws BusinessException {
        if(AppContext.hasPlugin(TemplateEventEnum.DOC)) {
            EdocSummary edocSummary = this.edocSummaryManager.findById(calEventDB.getFromId().longValue());
            if(edocSummary != null) {
                AppContext.putRequestContext("showTitle", edocSummary.getSubject());
            }
        }

    }

    public boolean isValid(Long createUserID, CtpAffair affair, Boolean isEdoc) {
        if(createUserID.equals(affair.getMemberId())) {
            return true;
        } else {
            List<AgentModel> agentModelList = MemberAgentBean.getInstance().getAgentModelToList(affair.getMemberId().longValue());
            Long curAgentIDLong = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.collaboration.ordinal(), affair.getMemberId());
            if(isEdoc.booleanValue()) {
                curAgentIDLong = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.ordinal(), affair.getMemberId());
            }

            if(!createUserID.equals(curAgentIDLong)) {
                return false;
            } else {
                Long templateId = affair.getTempleteId();
                AgentModel model = null;
                Iterator var9 = agentModelList.iterator();

                while(var9.hasNext()) {
                    AgentModel m = (AgentModel)var9.next();
                    if(m.getAgentId().equals(createUserID)) {
                        model = m;
                    }
                }

                List<AgentDetailModel> details = model.getAgentDetail();
                if(model.isHasCol() && model.isHasTemplate() && CollectionUtils.isEmpty(details)) {
                    return true;
                } else {
                    boolean c = model.isHasCol();
                    boolean t = model.isHasTemplate();
                    if(c && !t) {
                        return templateId == null;
                    } else {
                        ArrayList templateIds;
                        AgentDetailModel agentDetailModel;
                        Iterator var13;
                        if(t && !c) {
                            if(Strings.isEmpty(details)) {
                                return templateId != null;
                            } else {
                                templateIds = new ArrayList();
                                var13 = details.iterator();

                                while(var13.hasNext()) {
                                    agentDetailModel = (AgentDetailModel)var13.next();
                                    templateIds.add(agentDetailModel.getEntityId());
                                }

                                return templateId == null?false:templateIds.contains(templateId);
                            }
                        } else if(t && c) {
                            templateIds = new ArrayList();
                            if(Strings.isNotEmpty(details)) {
                                var13 = details.iterator();

                                while(var13.hasNext()) {
                                    agentDetailModel = (AgentDetailModel)var13.next();
                                    templateIds.add(agentDetailModel.getEntityId());
                                }
                            }

                            return templateId == null?true:templateIds.contains(templateId);
                        } else {
                            return true;
                        }
                    }
                }
            }
        }
    }

    public CalEventInfoBO getAEmptyCalEvent(CalEvent calEvent) throws BusinessException {
        CalEventInfoBO calEventInfoBO = new CalEventInfoBO();
        CalEventPeriodicalInfo calEventPeriodicalInfo = new CalEventPeriodicalInfo();
        calEvent.setCalEventType(Integer.valueOf(5));
        calEvent.setId(Long.valueOf(-1L));
        calEvent.setStates(Integer.valueOf(0));
        calEvent.setWorkType(Integer.valueOf(1));
        calEvent.setAlarmDate(Long.valueOf(0L));
        calEvent.setBeforendAlarm(Long.valueOf(0L));
        calEvent.setRealEstimateTime(Float.valueOf(0.0F));
        List receiveMemberIds;
        if(Strings.isNotBlank(calEvent.getReceiveMemberId())) {
            receiveMemberIds = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId());
            StringBuilder receiveMemberNameSBuffer = new StringBuilder();
            int i = 0;

            for(int receiveMemberIdInt = receiveMemberIds.size(); i < receiveMemberIdInt; ++i) {
                receiveMemberNameSBuffer.append(Functions.showMemberName((Long)receiveMemberIds.get(i)));
                if(i != receiveMemberIdInt - 1) {
                    receiveMemberNameSBuffer.append("、");
                }
            }

            calEvent.setReceiveMemberName(receiveMemberNameSBuffer.toString());
        }

        calEventInfoBO.setCalEvent(calEvent);
        calEventPeriodicalInfo.setPeriodicalType(Integer.valueOf(0));
        calEventInfoBO.setCalEventPeriodicalInfo(calEventPeriodicalInfo);
        calEventPeriodicalInfo.setBeginTime(calEvent.getBeginDate());
        calEventPeriodicalInfo.setEndTime(calEventPeriodicalInfo.getBeginTime());
        receiveMemberIds = this.getAllProject();
        calEventInfoBO.setProjectList(receiveMemberIds);
        if(calEvent.getFromId() != null) {
            if(Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.collaboration.getKey()))) {
                this.hanaleCtpAffair(calEvent, calEventInfoBO, Boolean.FALSE, Boolean.FALSE);
            } else if(!Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocSend.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocRec.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocSign.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.exSend.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.exSign.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocRegister.getKey())) && !Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.edocRecDistribute.getKey()))) {
                if(Strings.equals(calEvent.getFromType(), Integer.valueOf(ApplicationCategoryEnum.plan.getKey())) && AppContext.hasPlugin("plan")) {
                    calEventInfoBO.setPlan(this.planManager.selectById(calEvent.getFromId()));
                }
            } else {
                this.hanaleCtpAffair(calEvent, calEventInfoBO, Boolean.FALSE, Boolean.TRUE);
                AppContext.putRequestContext("isEdoc", "1");
            }
        }

        AppContext.putRequestContext("calEventInfoBO", calEventInfoBO);
        return calEventInfoBO;
    }

    private List<ProjectSummary> getAllProject() throws BusinessException {
        List<ProjectSummary> pSummaries = new ArrayList();
        ProjectSummary pSummary = new ProjectSummary();
        pSummary.setId(Long.valueOf(0L));
        pSummary.setProjectName(ResourceUtil.getString("calendar.event.create.project.name"));
        pSummaries.add(pSummary);
        if(AppContext.hasPlugin("project")) {
            pSummaries.addAll(this.projectManager.getProjectList());
        }

        return pSummaries;
    }

    private void saveCalContent(CalContent calContent) throws BusinessException {
        this.calContentManager.save(calContent);
    }

    private Long saveCalEventPeriodicalInfo(CalEventPeriodicalInfo calEventPeriodicalInfo) throws BusinessException {
        return this.calEventPeriodicalInfoManager.saveOrUpdate(calEventPeriodicalInfo, Boolean.TRUE);
    }

    private String getProjectNameByID(String projectId) throws BusinessException {
        try {
            long projectID = Long.parseLong(projectId != null?projectId:"0");
            if(AppContext.hasPlugin("project")) {
                return this.projectManager.getProject(projectID).getProjectName();
            }
        } catch (Exception var4) {
            logger.error(var4.getLocalizedMessage(), var4);
        }

        return null;
    }

    private void eventRemind(Date today, Long alartDate, Date compareDate, String jobName, List<CalEvent> calEvents, CalEventPeriodicalInfo cInfo) throws BusinessException {
        if(alartDate != null && alartDate.longValue() >= (long)AlarmDateEnum.enum1.getKey() && (DateUtils.isSameDay(compareDate, today) || compareDate.after(today))) {
            QuartzHolder.deleteQuartzJob(jobName);
            Map<String, String> parameters = new HashMap();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            List<Long> calEventIdList = new ArrayList();
            Iterator var11 = calEvents.iterator();

            while(var11.hasNext()) {
                CalEvent calEvent = (CalEvent)var11.next();
                Date begin = calEvent.getBeginDate();
                Date end = calEvent.getBeginDate();
                parameters.put(sdf.format(begin), String.valueOf(calEvent.getId()));
                parameters.put(sdf.format(end), String.valueOf(calEvent.getId()));
                calEventIdList.add(calEvent.getId());
            }

            parameters.put("calEventIdList", StringUtils.join(calEventIdList, ","));
            Date temp = Datetimes.addMinute(compareDate, -alartDate.intValue());
            int hours = temp.getHours();
            int min = temp.getMinutes();
            if(cInfo.getPeriodicalType().intValue() == 0) {
                QuartzHolder.newQuartzJob(jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), "eventRemind", parameters);
            } else {
                String week;
                String month;
                String dayweek;
                if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()) {
                    if(cInfo.getSwithMonth() == 2) {
                        dayweek = cInfo.getDayWeek().toString();
                        week = cInfo.getWeek().toString();
                        month = "0 " + min + " " + hours + " ? * " + dayweek + "#" + week;
                        QuartzHolder.newCronQuartzJob("NULL", jobName, month, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                    } else {
                        QuartzHolder.newQuartzJobPerMonth("NULL", jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                    }
                } else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()) {
                    if(cInfo.getSwithYear() == 2) {
                        dayweek = cInfo.getDayWeek().toString();
                        week = cInfo.getWeek().toString();
                        month = cInfo.getMonth().toString();
                        String cronStr = "0 " + min + " " + hours + " ? " + month + " " + dayweek + "#" + week;
                        QuartzHolder.newCronQuartzJob("NULL", jobName, cronStr, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                    } else {
                        QuartzHolder.newQuartzJobPerYear("NULL", jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                    }
                } else {
                    QuartzHolder.newQuartzJobPerDay("NULL", jobName, Datetimes.addMinute(compareDate, -alartDate.intValue()), cInfo.getEndTime(), "eventRemind", parameters);
                }
            }
        }

    }

    private void deleteTranEventByEventId(Long calEventId) throws BusinessException {
        this.calEventTranManager.deleteByEventId(calEventId);
    }

    private void deleteTranEventByEventId(List<Long> eventIds) throws BusinessException {
        this.calEventTranManager.deleteByEventId(eventIds);
    }

    private void saveProject(CalEvent calEvent) throws BusinessException {
        if(AppContext.hasPlugin("project")) {
            try {
                ProjectSummary projectSummary = this.projectManager.getProject(NumberUtils.toLong(calEvent.getTranMemberIds()));
                if(projectSummary != null) {
                    ProjectPhaseEvent projectPhaseEvent = new ProjectPhaseEvent(Integer.valueOf(ApplicationCategoryEnum.calendar.key()), calEvent.getId(), Long.valueOf(projectSummary.getPhaseId()));
                    this.projectPhaseEventManager.save(projectPhaseEvent);
                }
            } catch (Exception var4) {
                logger.error(var4.getLocalizedMessage(), var4);
            }
        }

    }

    private void saveProject(List<CalEvent> calEvents) throws BusinessException {
        if(AppContext.hasPlugin("project")) {
            ArrayList projectPhaseEvents = new ArrayList();

            try {
                Iterator var4 = calEvents.iterator();

                while(var4.hasNext()) {
                    CalEvent calEvent = (CalEvent)var4.next();
                    ProjectSummary projectSummary = this.projectManager.getProject(NumberUtils.toLong(calEvent.getTranMemberIds()));
                    if(projectSummary != null) {
                        ProjectPhaseEvent projectPhaseEvent = new ProjectPhaseEvent(Integer.valueOf(ApplicationCategoryEnum.calendar.key()), calEvent.getId(), Long.valueOf(projectSummary.getPhaseId()));
                        projectPhaseEvents.add(projectPhaseEvent);
                    }
                }

                this.projectPhaseEventManager.saveAll(projectPhaseEvents);
            } catch (Exception var7) {
                logger.error(var7.getLocalizedMessage(), var7);
            }
        }

    }

    private void saveAttachment(CalEvent calEvent, Long calEventId) throws BusinessException {
        try {
            this.attachmentManager.deleteByReference(calEventId);
            this.attachmentManager.create(ApplicationCategoryEnum.calendar, calEventId, calEventId);
            List<Attachment> attachments = this.attachmentManager.getByReference(calEventId);
            if(CollectionUtils.isNotEmpty(attachments)) {
                calEvent.setAttachmentsFlag(Boolean.TRUE);
            }
        } catch (Exception var4) {
            logger.error(var4.getLocalizedMessage(), var4);
        }

    }

    private void deleteAttachmentByEventID(List<Long> calEventIds) throws BusinessException {
        this.attachmentManager.deleteByReference(calEventIds);
    }

    private void deleteCalContentByEventId(Long calEventId) throws BusinessException {
        this.calContentManager.deleteByEventId(calEventId);
    }

    private void deleteCalContentByEventId(List<Long> calEventIds) throws BusinessException {
        this.calContentManager.deleteByEventId(calEventIds);
    }

    public CalEvent compareDate(CalEvent calEvent) throws BusinessException {
        Date beginDate = calEvent.getBeginDate();
        Date endDate = calEvent.getEndDate();
        if(calEvent.getReceiveMemberName() != null && "endDate".equals(calEvent.getReceiveMemberName())) {
            if(beginDate.getTime() >= endDate.getTime()) {
                calEvent.setBeginDate(Datetimes.addHour(calEvent.getEndDate(), -1));
            }
        } else if(beginDate.getTime() >= endDate.getTime()) {
            calEvent.setEndDate(Datetimes.addHour(calEvent.getBeginDate(), 1));
        }

        return calEvent;
    }

    private void deleteCalReplyByEventID(List<Long> calEventIds) throws BusinessException {
        this.calReplyManager.deleteByEventId(calEventIds);
    }

    private List<CalEvent> getAllShareEvent(FlipInfo fi, CalEvent calEvent) throws BusinessException {
        List<Long> ids = this.getDepartMentIDs(AppContext.getCurrentUser(), calEvent);
        this.getAllProjectIDByUser(ids);
        ids.add(AppContext.getCurrentUser().getId());
        ids.add(Long.valueOf(AppContext.currentAccountId()));
        List<List<Long>> relationPeoson = new ArrayList();
        List<Long> shareTypeLeaderJunior = new ArrayList();
        List<Long> shareTypeLeaderAsstant = new ArrayList();
        List<Long> shareTypeJunior = new ArrayList();
        this.getRelatePersonIDS(Long.valueOf(AppContext.currentUserId()), shareTypeLeaderJunior, shareTypeLeaderAsstant, shareTypeJunior);
        relationPeoson.add(shareTypeLeaderJunior);
        relationPeoson.add(shareTypeLeaderAsstant);
        relationPeoson.add(shareTypeJunior);
        this.calEventDao.getAllShareEvent(fi, ids, calEvent, relationPeoson);
        return fi.getData();
    }

    private Long getShareSize(Map params) throws BusinessException {
        CalEvent calEvent = new CalEvent();
        String subject = (String)params.get("subject");
        if(Strings.isNotBlank(subject)) {
            calEvent.setSubject(subject);
        }

        String signifyType = (String)params.get("signifyType");
        if(Strings.isNotBlank(signifyType)) {
            calEvent.setSignifyType(Integer.valueOf(signifyType));
        }

        String beginDate = "";
        String endDate = "";
        if(params.get("beginDate") != null && params.get("endDate") != null) {
            beginDate = DateFormatUtils.ISO_DATE_FORMAT.format(params.get("beginDate"));
            endDate = DateFormatUtils.ISO_DATE_FORMAT.format(params.get("endDate"));
        }

        try {
            if(Strings.isNotBlank(beginDate)) {
                calEvent.setBeginDate(DateUtils.parseDate(beginDate, getAllAndSDateDFormat()));
            }

            if(Strings.isNotBlank(endDate)) {
                endDate = endDate + " 23:59";
                calEvent.setEndDate(DateUtils.parseDate(endDate, getAllAndSDateDFormat()));
            }
        } catch (ParseException var14) {
            logger.error(var14.getLocalizedMessage(), var14);
        }

        String states = (String)params.get("states");
        if(Strings.isNotBlank(states)) {
            calEvent.setStates(Integer.valueOf(states));
        }

        String receiveMemberName = null;
        if(params.get("createUsername") != null) {
            receiveMemberName = params.get("createUsername").toString();
            if(Strings.isNotBlank(receiveMemberName)) {
                calEvent.setReceiveMemberName(receiveMemberName);
            }
        }

        List<Long> ids = this.getDepartMentIDs(AppContext.getCurrentUser(), calEvent);
        this.getAllProjectIDByUser(ids);
        ids.add(AppContext.getCurrentUser().getId());
        ids.add(Long.valueOf(AppContext.currentAccountId()));
        List<List<Long>> relationPeoson = new ArrayList();
        List<Long> shareTypeLeaderJunior = new ArrayList();
        List<Long> shareTypeLeaderAsstant = new ArrayList();
        List<Long> shareTypeJunior = new ArrayList();
        this.getRelatePersonIDS(Long.valueOf(AppContext.currentUserId()), shareTypeLeaderJunior, shareTypeLeaderAsstant, shareTypeJunior);
        relationPeoson.add(shareTypeLeaderJunior);
        relationPeoson.add(shareTypeLeaderAsstant);
        relationPeoson.add(shareTypeJunior);
        return this.calEventDao.geShareSize(ids, calEvent, relationPeoson);
    }

    private void getAllProjectIDByUser(List<Long> projectSummaryIDs) throws BusinessException {
        if(AppContext.hasPlugin("project")) {
            List<ProjectSummary> pp = this.projectManager.getAllProjectListByMemberId(AppContext.getCurrentUser().getId());
            if(CollectionUtils.isNotEmpty(pp)) {
                int i = 0;

                for(int p = pp.size(); i < p; ++i) {
                    projectSummaryIDs.add(((ProjectSummary)pp.get(i)).getId());
                }
            }
        }

    }

    private List<CalEvent> getAllOtherEvent(FlipInfo fi, CalEvent calEvent, Integer count) throws BusinessException {
        User user = AppContext.getCurrentUser();
        List<Long> calEventRelatUserIDs = new ArrayList();
        calEventRelatUserIDs.add(Long.valueOf(AppContext.currentAccountId()));
        calEventRelatUserIDs.addAll(this.getDepartMentIDs(user, calEvent));
        calEventRelatUserIDs.add(user.getId());
        List<Long> shareTypeLeaderJunior = new ArrayList();
        List<Long> shareTypeLeaderAsstant = new ArrayList();
        List<Long> shareTypejunior = new ArrayList();
        this.getRelatePersonIDS(user.getId(), shareTypeLeaderJunior, shareTypeLeaderAsstant, shareTypejunior);
        List<List<Long>> otherID = new ArrayList();
        otherID.add(calEventRelatUserIDs);
        otherID.add(shareTypeLeaderJunior);
        otherID.add(shareTypeLeaderAsstant);
        otherID.add(shareTypejunior);
        Date curDate = this.getCurDate();
        if(count != null) {
            fi.setData(this.getDate4portal(count.intValue(), (String)null, "caleventOther", fi, calEvent, otherID, curDate));
        } else {
            this.calEventDao.getAllOtherEvent(fi, calEvent, (Integer)null, (List)null, Boolean.FALSE, otherID);
        }

        return fi.getData();
    }

    private void getRelatePersonIDS(Long createUserID, List<Long> shareTypeLeaderForJunior, List<Long> shareTypeLeaderForAsstant, List<Long> shareTypejunior) {
        if(AppContext.hasPlugin("relateMember")) {
            try {
                List<V3xOrgMember> v3xOrgMembers = new ArrayList();
                v3xOrgMembers.addAll((Collection)this.peopleRelateManager.getAllRelateMembersWithFix(createUserID).get(RelationType.leader));
                List<V3xOrgMember> v3xOrgMembersAsstant = new ArrayList();
                List<V3xOrgMember> v3xOrgMembersJunior = new ArrayList();
                Iterator var9 = v3xOrgMembers.iterator();

                V3xOrgMember v3xOrgMember;
                while(var9.hasNext()) {
                    v3xOrgMember = (V3xOrgMember)var9.next();
                    v3xOrgMembersAsstant.addAll((Collection)this.peopleRelateManager.getAllRelateMembersWithFix(v3xOrgMember.getId()).get(RelationType.assistant));
                    Iterator var11 = v3xOrgMembersAsstant.iterator();

                    V3xOrgMember temMember;
                    while(var11.hasNext()) {
                        temMember = (V3xOrgMember)var11.next();
                        if(temMember.getId().equals(createUserID)) {
                            shareTypeLeaderForAsstant.add(v3xOrgMember.getId());
                        }
                    }

                    v3xOrgMembersJunior.addAll((Collection)this.peopleRelateManager.getAllRelateMembersWithFix(v3xOrgMember.getId()).get(RelationType.junior));
                    var11 = v3xOrgMembersJunior.iterator();

                    while(var11.hasNext()) {
                        temMember = (V3xOrgMember)var11.next();
                        if(temMember.getId().equals(createUserID)) {
                            shareTypeLeaderForJunior.add(v3xOrgMember.getId());
                        }
                    }
                }

                v3xOrgMembers.clear();
                v3xOrgMembers.addAll((Collection)this.peopleRelateManager.getAllRelateMembersWithFix(createUserID).get(RelationType.junior));
                v3xOrgMembers.addAll((Collection)this.peopleRelateManager.getAllRelateMembersWithFix(createUserID).get(RelationType.assistant));
                var9 = v3xOrgMembers.iterator();

                while(var9.hasNext()) {
                    v3xOrgMember = (V3xOrgMember)var9.next();
                    shareTypejunior.add(v3xOrgMember.getId());
                }
            } catch (Exception var12) {
                logger.error(var12.getLocalizedMessage(), var12);
            }
        }

    }

    private List<Long> getAllDepartMentEvents(FlipInfo fi, User user, CalEvent calEvent) throws BusinessException {
        List<Long> ids = this.getDepartMentIDs(user, calEvent);
        this.calEventDao.getAllDePartMentEvents(ids, fi, calEvent);
        return ids;
    }

    private List<Long> getDepartMentIDs(User user, CalEvent calEvent) throws BusinessException {
        List<Long> ids = new ArrayList();
        List<V3xOrgDepartment> departments = new ArrayList();
        V3xOrgDepartment v3xOrgDepartment = null;
        if(calEvent.getFromId() != null && Strings.isNotBlank(calEvent.getFromId().toString())) {
            v3xOrgDepartment = this.orgManager.getDepartmentById(calEvent.getFromId());
        }

        if(v3xOrgDepartment != null) {
            ids.add(v3xOrgDepartment.getId());
            List<V3xOrgDepartment> parentDepartments = this.orgManager.getAllParentDepartments(v3xOrgDepartment.getId());
            Iterator var8 = parentDepartments.iterator();

            while(var8.hasNext()) {
                V3xOrgDepartment parentDepartment = (V3xOrgDepartment)var8.next();
                ids.add(parentDepartment.getId());
            }
        } else {
            departments.addAll(this.orgManager.getDepartmentsByUser(user.getId()));
            Iterator var12 = departments.iterator();

            while(var12.hasNext()) {
                V3xOrgDepartment department = (V3xOrgDepartment)var12.next();
                ids.add(department.getId());
                List<V3xOrgDepartment> parentDepartments = this.orgManager.getAllParentDepartments(department.getId());
                Iterator var10 = parentDepartments.iterator();

                while(var10.hasNext()) {
                    V3xOrgDepartment parentDepartment = (V3xOrgDepartment)var10.next();
                    ids.add(parentDepartment.getId());
                }
            }
        }

        return ids;
    }

    public List<CalEvent> getAllProjectEvents(FlipInfo fi, CalEvent calEvent) throws BusinessException {
        List<Long> projectIDs = new ArrayList();
        this.getAllProjectIDByUser(projectIDs);
        if(CollectionUtils.isNotEmpty(projectIDs)) {
            if(calEvent.getFromId() != null) {
                return this.getAllProjectEvents(calEvent, -1);
            }

            this.calEventDao.getAllProjectEvents(projectIDs, fi, calEvent);
        } else {
            fi.setData((List)null);
        }

        return fi.getData();
    }

    public List<CalEvent> getSizeProjectEvents(FlipInfo fi, CalEvent calEvent, int size) throws BusinessException {
        return this.getAllProjectEvents(calEvent, size);
    }

    private List<CalEvent> getAllProjectEvents(CalEvent calEvent, int size) throws BusinessException {
        Map<String, Object> map = new HashMap();
        map.put("fromId", calEvent.getFromId());
        map.put("subject", calEvent.getSubject());
        if(calEvent.getTranMemberName() != null) {
            map.put("tranMemberName", calEvent.getTranMemberName());
        }

        map.put("createDate", calEvent.getCreateDate());
        map.put("tranMemberIds", calEvent.getTranMemberIds());
        map.put("endCreateDate", calEvent.getEndDate());
        map.put("size", Integer.valueOf(size));
        return this.calEventDao.getAllProjectEventsByProjectCon(map);
    }

    private void saveTranEvents(CalEvent calEvent) throws BusinessException {
        List<CalEventTran> calEventTransDB = this.getTranEventsByEvent(calEvent);
        this.calEventTranManager.saveAll(calEventTransDB);
        if(calEvent != null && Strings.equals(calEvent.getIsEntrust(), Integer.valueOf(1))) {
            this.appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Calendar_Commission, new String[]{AppContext.getCurrentUser().getName(), calEvent.getSubject(), calEvent.getReceiveMemberName()});
        }

    }

    private List<CalEventTran> getTranEventsByEvent(CalEvent calEvent) {
        List<CalEventTran> calEventTransDB = new ArrayList();
        List<CalEventTran> calEventTrans = new ArrayList();
        CalEventTran calEventTran = null;
        if(calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
            List<Long> tranMemberMembers = new ArrayList();
            List<V3xOrgMember> v3xOrgMembers = new ArrayList();
            Iterator var8;
            if(AppContext.hasPlugin("relateMember")) {
                try {
                    if(calEvent.getShareType().intValue() == ShareTypeEnum.openToSuperior.getKey()) {
                        v3xOrgMembers = (List)this.peopleRelateManager.getAllRelateMembersWithFix(Long.valueOf(AppContext.currentUserId())).get(RelationType.leader);
                    } else if(calEvent.getShareType().intValue() == ShareTypeEnum.openToLower.getKey()) {
                        v3xOrgMembers = (List)this.peopleRelateManager.getAllRelateMembersWithFix(Long.valueOf(AppContext.currentUserId())).get(RelationType.junior);
                    } else if(calEvent.getShareType().intValue() == ShareTypeEnum.openToSecretary.getKey()) {
                        v3xOrgMembers = (List)this.peopleRelateManager.getAllRelateMembersWithFix(Long.valueOf(AppContext.currentUserId())).get(RelationType.assistant);
                    } else {
                        tranMemberMembers = CommonTools.parseTypeAndIdStr2Ids(calEvent.getTranMemberIds());
                    }

                    if(CollectionUtils.isNotEmpty((Collection)v3xOrgMembers)) {
                        var8 = ((List)v3xOrgMembers).iterator();

                        while(var8.hasNext()) {
                            V3xOrgMember orgMem = (V3xOrgMember)var8.next();
                            ((List)tranMemberMembers).add(orgMem.getId());
                        }
                    }
                } catch (Exception var10) {
                    logger.error(var10.getLocalizedMessage(), var10);
                }

                int i = 0;

                for(int tranMemberMemberInt = ((List)tranMemberMembers).size(); i < tranMemberMemberInt; ++i) {
                    Long tranMemberID = (Long)((List)tranMemberMembers).get(i);
                    calEventTran = new CalEventTran();
                    calEventTran.setType(calEvent.getShareType());
                    calEventTran.setEntityId(tranMemberID);
                    calEventTrans.add(calEventTran);
                }
            }

            var8 = calEventTrans.iterator();

            while(var8.hasNext()) {
                CalEventTran cEventTran = (CalEventTran)var8.next();
                cEventTran.setIdIfNew();
                cEventTran.setEventId(calEvent.getId());
                cEventTran.setSourceRecordId(calEvent.getCreateUserId());
                calEventTransDB.add(cEventTran);
            }
        }

        return calEventTransDB;
    }

    private void saveTranEvents(List<CalEvent> calEvents) throws BusinessException {
        List<CalEventTran> calEventTrans = new ArrayList();

        List calEventTransDB;
        for(Iterator var4 = calEvents.iterator(); var4.hasNext(); calEventTrans.addAll(calEventTransDB)) {
            CalEvent calEvent = (CalEvent)var4.next();
            calEventTransDB = this.getTranEventsByEvent(calEvent);
            if(calEvent != null && Strings.equals(calEvent.getIsEntrust(), Integer.valueOf(1))) {
                this.appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Calendar_Commission, new String[]{AppContext.getCurrentUser().getName(), calEvent.getSubject(), calEvent.getReceiveMemberName()});
            }
        }

        this.calEventTranManager.saveAll(calEventTrans);
    }

    private DataRecord getDataRecordForLeaderSchedule(String curTab, String eventListtype, String continueValue) throws BusinessException {
        Map<String, Object> map = new HashMap();
        DataRecord dataRecord = new DataRecord();
        map.put("userId", AppContext.getCurrentUser().getId().toString());
        if(!Strings.isEmpty(continueValue)) {
            String searchType = continueValue.split(":")[0];
            String serachValue = continueValue.split(":")[1];
            if(!"beginDate".equals(searchType) && !"endDate".equals(searchType)) {
                map.put("condition", searchType);
                map.put("queryValue", serachValue);
            } else {
                map.put("condition", searchType);
                String[] time = serachValue.split(",");
                if(time != null && time.length > 0) {
                    try {
                        if(Strings.isNotBlank(time[0])) {
                            map.put("queryValue", time[0]);
                        }

                        if(time.length >= 2 && !Strings.isBlank(time[1])) {
                            map.put("queryValue1", time[1]);
                        }
                    } catch (Exception var15) {
                        logger.error(var15.getLocalizedMessage(), var15);
                    }
                }
            }
        }

        FlipInfo flipinfo = new FlipInfo();
        String[] columnNames = new String[]{ResourceUtil.getString("calendar.event.create.beginDate"), ResourceUtil.getString("plan.initdata.endTime"), ResourceUtil.getString("member.list.find.name"), ResourceUtil.getString("calendar.event.create.subject"), ResourceUtil.getString("import.type.account"), ResourceUtil.getString("import.type.dept"), ResourceUtil.getString("calendar.level.label"), null};
        List<CalEventInfoBO> calEventInfoBOs = new ArrayList();
        this.getLeaderSchedule(flipinfo, map);
        if(flipinfo != null && flipinfo.getData() != null && flipinfo.getData().size() > 0) {
            Iterator var10 = flipinfo.getData().iterator();

            while(var10.hasNext()) {
                Object obj = var10.next();
                if(obj != null && obj instanceof CalEventInfoBO) {
                    calEventInfoBOs.add((CalEventInfoBO)obj);
                }
            }
        }

        dataRecord.setColumnName(columnNames);
        short[] width = new short[]{30, 30, 30, 30, 30, 30, 20, 30};
        dataRecord.setColumnWith(width);
        dataRecord.setTitle(ResourceUtil.getString("calendar.learder.label"));
        dataRecord.setSheetName("sheet1");
        if(CollectionUtils.isEmpty(calEventInfoBOs)) {
            return dataRecord;
        } else {
            DataRow[] rows = new DataRow[calEventInfoBOs.size()];
            int i = 0;

            for(int calEventInfoBOInt = calEventInfoBOs.size(); i < calEventInfoBOInt; ++i) {
                CalEventInfoBO calEventInfoBO = (CalEventInfoBO)calEventInfoBOs.get(i);
                DataRow row = new DataRow();
                row.addDataCell(DateFormatUtils.format(calEventInfoBO.getCalEvent().getBeginDate(), getAllAndSDateDFormat()[1]), 1);
                row.addDataCell(DateFormatUtils.format(calEventInfoBO.getCalEvent().getEndDate(), getAllAndSDateDFormat()[1]), 1);
                row.addDataCell(calEventInfoBO.getCreateUserName(), 1);
                row.addDataCell(calEventInfoBO.getCalEvent().getSubject(), 1);
                row.addDataCell(calEventInfoBO.getAccountName(), 1);
                row.addDataCell(calEventInfoBO.getDepartMentName(), 1);
                row.addDataCell(calEventInfoBO.getPostName(), 1);
                rows[i] = row;
            }

            dataRecord.addDataRow(rows);
            return dataRecord;
        }
    }

    private DataRecord getDataRecord(String curTab, String eventListtype, String continueValue) throws BusinessException {
        Map<String, Object> map = new HashMap();
        CalEvent calEvent = new CalEvent();
        List<CalEvent> calEvents = null;
        DataRecord dataRecord = new DataRecord();
        if(continueValue.indexOf("createUserIDF8") >= 0) {
            String[] temp = continueValue.split("!");
            map.put("createUserID", Long.valueOf(Long.parseLong(temp[0].split(":")[1])));
            continueValue = temp[1];
        } else {
            map.put("createUserID", AppContext.getCurrentUser().getId().toString());
        }

        String[] time;
        if(!Strings.isEmpty(continueValue)) {
            String searchType = continueValue.split(":")[0];
            String serachValue = continueValue.split(":")[1];
            if("beginDate".equals(searchType)) {
                time = serachValue.split(",");
                if(time != null && time.length > 0) {
                    try {
                        if(Strings.isNotBlank(time[0])) {
                            calEvent.setBeginDate(DateUtils.parseDate(time[0], getAllAndSDateDFormat()));
                            map.put("beginDate", DateUtils.parseDate(time[0], getAllAndSDateDFormat()));
                        }

                        if(time.length >= 2 && !Strings.isBlank(time[1])) {
                            calEvent.setEndDate(DateUtils.addSeconds(DateUtils.addDays(DateUtils.parseDate(time[1], getAllAndSDateDFormat()), 1), -1));
                            map.put("endDate", DateUtils.addSeconds(DateUtils.addDays(DateUtils.parseDate(time[1], getAllAndSDateDFormat()), 1), -1));
                        }
                    } catch (Exception var18) {
                        logger.error(var18.getLocalizedMessage(), var18);
                    }
                }
            } else {
                map.put(searchType, serachValue);
            }

            if("subject".equals(searchType)) {
                calEvent.setSubject(serachValue);
            } else if("signifyType".equals(searchType)) {
                calEvent.setSignifyType(Integer.valueOf(serachValue));
            } else if("states".equals(searchType)) {
                calEvent.setStates(Integer.valueOf(serachValue));
            } else if("createUsername".equals(searchType)) {
                calEvent.setReceiveMemberName(serachValue);
            }
        }

        FlipInfo flipinfo = new FlipInfo();
        Long size = this.getShareSize(map);
        flipinfo.setSize(size.intValue());
        time = new String[8];
        time[0] = ResourceUtil.getString("calendar.event.create.calEventType");
        time[1] = ResourceUtil.getString("calendar.event.create.subject");
        time[2] = ResourceUtil.getString("calendar.event.create.signifyType");
        time[3] = ResourceUtil.getString("calendar.event.create.beginDate");
        if("all".equals(curTab)) {
            if(!Strings.isEmpty(eventListtype) && !"all".equals(eventListtype)) {
                if("department".equals(eventListtype)) {
                    this.getAllDepartMentEvents(flipinfo, AppContext.getCurrentUser(), calEvent);
                } else if("project".equals(eventListtype)) {
                    this.getAllProjectEvents(flipinfo, calEvent);
                } else if("other".equals(eventListtype)) {
                    String curPeopleId = continueValue.split(":")[2];
                    if(!Strings.isEmpty(curPeopleId) && !"other".equals(curPeopleId)) {
                        calEvent.setCreateUserId(Long.valueOf(Long.parseLong(curPeopleId)));
                    }

                    this.getAllOtherEvent(flipinfo, calEvent, (Integer)null);
                }
            } else {
                this.getAllShareEvent(flipinfo, calEvent);
            }

            time[4] = ResourceUtil.getString("calendar.event.create.shareType");
            time[5] = ResourceUtil.getString("calendar.event.create.createUserName");
            time[6] = ResourceUtil.getString("calendar.event.create.eventSource");
            time[7] = ResourceUtil.getString("calendar.event.create.states");
            calEvents = flipinfo.getData();
        } else {
            time[4] = ResourceUtil.getString("calendar.event.create.createUserName");
            time[5] = ResourceUtil.getString("calendar.event.create.eventSource");
            time[6] = ResourceUtil.getString("calendar.event.create.states");
            time[7] = ResourceUtil.getString("calendar.event.create.state.periodical");
            calEvents = this.calEventDao.getMyOwnListForExcel(map);
        }

        dataRecord.setColumnName(time);
        List<CalEventInfoBO> calEventInfoBOs = this.getCalEventInfoBO(calEvents);
        short[] width = new short[]{30, 30, 30, 30, 30, 30, 20, 30};
        dataRecord.setColumnWith(width);
        dataRecord.setTitle(ResourceUtil.getString("calendar.event.list.toexcel.title"));
        dataRecord.setSheetName("sheet1");
        if(CollectionUtils.isEmpty(calEventInfoBOs)) {
            return dataRecord;
        } else {
            DataRow[] rows = new DataRow[calEventInfoBOs.size()];
            int i = 0;

            for(int calEventInfoBOInt = calEventInfoBOs.size(); i < calEventInfoBOInt; ++i) {
                CalEventInfoBO calEventInfoBO = (CalEventInfoBO)calEventInfoBOs.get(i);
                DataRow row = new DataRow();
                row.addDataCell(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_type, calEventInfoBO.getCalEvent().getCalEventType().toString()), 1);
                row.addDataCell(calEventInfoBO.getCalEvent().getSubject(), 1);
                row.addDataCell(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType, calEventInfoBO.getCalEvent().getSignifyType().toString()), 1);
                row.addDataCell(DateFormatUtils.format(calEventInfoBO.getCalEvent().getBeginDate(), getAllAndSDateDFormat()[1]), 1);
                if("all".equals(curTab)) {
                    row.addDataCell(calEventInfoBO.getShareType(), 1);
                    row.addDataCell(calEventInfoBO.getCreateUserName(), 1);
                    row.addDataCell(calEventInfoBO.getEventSource(), 1);
                    row.addDataCell(StatesEnum.findByKey(calEventInfoBO.getCalEvent().getStates().intValue()).getText(), 1);
                } else {
                    row.addDataCell(calEventInfoBO.getCreateUserName(), 1);
                    row.addDataCell(calEventInfoBO.getEventSource(), 1);
                    row.addDataCell(StatesEnum.findByKey(calEventInfoBO.getCalEvent().getStates().intValue()).getText(), 1);
                    row.addDataCell(calEventInfoBO.getCalEvent().getPeriodicalStyle().intValue() == 0?ResourceUtil.getString("calendar.event.create.state.no"):PeriodicalEnum.findByKey(calEventInfoBO.getCalEvent().getPeriodicalStyle().intValue()).getText(), 1);
                }

                rows[i] = row;
            }

            dataRecord.addDataRow(rows);
            return dataRecord;
        }
    }

    public void saveEventToExcel(String curTab, String EventListtype, String continueValue) throws BusinessException {
        HttpServletResponse response = AppContext.getRawResponse();

        try {
            new DataRecord();
            String curTabStr = StringUtil.checkNull(curTab)?"":curTab;
            DataRecord dataRecord;
            if(!curTabStr.equals("leaderSchedule")) {
                dataRecord = this.getDataRecord(curTabStr, EventListtype, continueValue);
            } else {
                dataRecord = this.getDataRecordForLeaderSchedule(curTabStr, EventListtype, continueValue);
            }

            this.fileToExcelManager.save(response, dataRecord.getTitle(), new DataRecord[]{dataRecord});
        } catch (Exception var7) {
            logger.error(var7.getLocalizedMessage(), var7);
        }

    }

    public List<List<String>> getStatistics(Map<String, Object> map) throws BusinessException {
        CalEvent calEvent = new CalEvent();
        String statisticsSumType = map.get("statisticsSumType").toString();
        String statisticsType = map.get("statisticsType").toString();
        String states = map.get("states").toString();
        String endDate = map.get("endDate").toString();
        String beginDate = map.get("beginDate").toString();
        calEvent.setStates(Integer.valueOf(states));
        calEvent.setCreateUserId(AppContext.getCurrentUser().getId());

        try {
            calEvent.setBeginDate(DateUtils.parseDate(beginDate, getAllAndSDateDFormat()));
            calEvent.setEndDate(DateUtils.parseDate(endDate, getAllAndSDateDFormat()));
        } catch (ParseException var23) {
            logger.error(var23.getLocalizedMessage(), var23);
        }

        if("2".equals(statisticsSumType)) {
            calEvent.setReceiveMemberId("realEstimateTime");
        }

        if("1".equals(statisticsType)) {
            calEvent.setReceiveMemberName("signifyType");
        }

        List<List<String>> list = new ArrayList();
        List<Object[]> objects = this.calEventDao.getStatistics(calEvent);
        List<String> mapSum = new ArrayList();
        List<String> mapCount = new ArrayList();
        List<String> mapKey = new ArrayList();
        List<String> enumKey = new ArrayList();
        List<CtpEnumItem> ctpEnumItems = this.enumManagerNew.getEnumItemByProCode(EnumNameEnum.cal_event_signifyType);
        int count = ctpEnumItems.size();
        if("2".equals(statisticsType)) {
            ctpEnumItems = this.enumManagerNew.getEnumItemByProCode(EnumNameEnum.cal_event_type);
            count = ctpEnumItems.size();
        }

        int i;
        int j;
        for( i = 0; i < count; ++i) {
            Boolean isHasCount = Boolean.FALSE;
            CtpEnumItem ctpEnumItem = (CtpEnumItem)ctpEnumItems.get(i);
            enumKey.add(ctpEnumItem.getEnumvalue());
            if("1".equals(statisticsType)) {
                mapKey.add(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType, ctpEnumItem.getEnumvalue()));
            } else {
                mapKey.add(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_type, ctpEnumItem.getEnumvalue()));
            }

            i = 0;

            for(j = objects.size(); i < j; ++i) {
                if(ctpEnumItem.getEnumvalue().equals(((Object[])objects.get(i))[2].toString())) {
                    mapSum.add(((Object[])objects.get(i))[0].toString());
                    mapCount.add(((Object[])objects.get(i))[1].toString());
                    isHasCount = Boolean.TRUE;
                    break;
                }
            }

            if(!isHasCount.booleanValue()) {
                mapSum.add("0");
                mapCount.add("0");
            }
        }

        Integer sumCount = Integer.valueOf(0);
        Float sumHour = Float.valueOf(0.0F);
         i = 0;

        for(i = mapCount.size(); i < i; ++i) {
            sumCount = Integer.valueOf(sumCount.intValue() + Integer.parseInt((String)mapCount.get(i)));
            sumHour = Float.valueOf(sumHour.floatValue() + Float.parseFloat((String)mapSum.get(i)));
        }

        List<String> result = new ArrayList();
        i = 0;

        for(j = mapKey.size(); i < j; ++i) {
            StringBuffer stringBuffer = new StringBuffer();
            if((Integer.parseInt(statisticsSumType) != 1 || Integer.parseInt((String)mapCount.get(i)) != 0) && (Integer.parseInt(statisticsSumType) != 2 || Float.parseFloat((String)mapSum.get(i)) != 0.0F)) {
                stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.proportion"));
                if(Integer.parseInt(statisticsSumType) == 2) {
                    stringBuffer.append((new BigDecimal((double)(Float.parseFloat((String)mapSum.get(i)) / sumHour.floatValue() * 100.0F))).setScale(2, 4).floatValue());
                } else {
                    stringBuffer.append((new BigDecimal((double)(Float.parseFloat((String)mapCount.get(i)) / (float)sumCount.intValue() * 100.0F))).setScale(2, 4).floatValue());
                }

                stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.toSum"));
                stringBuffer.append((String)mapCount.get(i));
                stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.resultStr1"));
                if(mapSum.get(i) != null) {
                    float sum = Float.parseFloat((String)mapSum.get(i));
                    stringBuffer.append(String.format("%.2f", new Object[]{Float.valueOf(sum)}));
                }

                stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.hour"));
                result.add(stringBuffer.toString());
            } else {
                stringBuffer.append(ResourceUtil.getString("calendar.event.create.state.no"));
                result.add(stringBuffer.toString());
            }
        }

        list.add(mapKey);
        list.add(result);
        if(Integer.parseInt(statisticsSumType) == 2) {
            list.add(mapSum);
        } else {
            list.add(mapCount);
        }

        list.add(enumKey);
        return list;
    }

    public FlipInfo getStatisticsCalEventInfoBO(FlipInfo flipInfo, Map<String, String> params) throws BusinessException {
        CalEvent calEvent = new CalEvent();
        String statisticsType = ((String)params.get("statisticsType")).toString();
        String states = ((String)params.get("states")).toString();
        String endDate = ((String)params.get("endDate")).toString();
        String beginDate = ((String)params.get("beginDate")).toString();
        calEvent.setStates(Integer.valueOf(states));
        calEvent.setCreateUserId(AppContext.getCurrentUser().getId());

        try {
            calEvent.setBeginDate(DateUtils.parseDate(beginDate, getAllAndSDateDFormat()));
            calEvent.setEndDate(DateUtils.parseDate(endDate, getAllAndSDateDFormat()));
        } catch (ParseException var10) {
            logger.error(var10.getLocalizedMessage(), var10);
        }

        String testSearch = ((String)params.get("testSearch")).toString();
        calEvent.setCalEventType(Integer.valueOf(testSearch));
        if("1".equals(statisticsType)) {
            calEvent.setReceiveMemberName("signifyType");
        }

        this.calEventDao.getStatisticsCalEventInfoBO(flipInfo, calEvent);
        List<CalEventInfoBO> calEventInfoBOs = this.getCalEventInfoBO(flipInfo.getData());
        flipInfo.setData(calEventInfoBOs);
        return flipInfo;
    }

    public List<CalEvent> getViewDateByCon(Map<String, Object> map) throws BusinessException {
        return this.calEventDao.getViewDateByCon(map);
    }

    public List<CalEvent> getAllCaleventView(Map<String, Object> map) throws BusinessException {
        boolean isResourceCode = true;
        if(AppContext.getCurrentUser() != null) {
            isResourceCode = AppContext.getCurrentUser().hasResourceCode("F02_eventlist");
        }

        if(isResourceCode) {
            HttpServletRequest request = AppContext.getRawRequest();
            String columnsource = request.getParameter("columnsource");
            if(Strings.isNotBlank(columnsource)) {
                map.put("columnsource", columnsource);
            } else {
                map.put("columnsource", "0,1");
            }

            return this.calEventDao.getAllCaleventView(map);
        } else {
            return null;
        }
    }

    public List<CalEvent> getAllCaleventViewforleader(Map<String, Object> map) throws BusinessException {
        if(AppContext.getCurrentUser().hasResourceCode("F02_eventlist")) {
            HttpServletRequest request = AppContext.getRawRequest();
            String columnsource = request.getParameter("columnsource");
            if(Strings.isNotBlank(columnsource)) {
                map.put("columnsource", columnsource);
            } else {
                map.put("columnsource", "0,1");
            }

            return this.calEventDao.selectLeaderScheduleForEvent(map);
        } else {
            return null;
        }
    }

    public List<V3xOrgMember> getPeopleRelateList() throws BusinessException {
        ArrayList orgMembers = new ArrayList();

        try {
            if(AppContext.hasPlugin("relateMember")) {
                Map<RelationType, List<V3xOrgMember>> peopleRelates = this.peopleRelateManager.getAllRelateMembers(AppContext.getCurrentUser().getId());
                orgMembers.addAll((Collection)peopleRelates.get(RelationType.junior));
                orgMembers.addAll((Collection)peopleRelates.get(RelationType.assistant));
                orgMembers.addAll((Collection)peopleRelates.get(RelationType.leader));
                orgMembers.addAll((Collection)peopleRelates.get(RelationType.confrere));
            }

            return orgMembers;
        } catch (Exception var3) {
            logger.error(var3.getLocalizedMessage(), var3);
            return null;
        }
    }

    public List<Plan> getAllOtherPlan(Map<String, Object> map) throws BusinessException {
        boolean isResourceCode = true;
        if(AppContext.getCurrentUser() != null) {
            isResourceCode = AppContext.getCurrentUser().hasResourceCode("F02_planListHome");
        }

        return AppContext.hasPlugin("plan") && isResourceCode?this.planManager.getPlanForCalendar(map):null;
    }

    public List<TaskInfoBO> getAllOtherTask(Map<String, Object> map) throws BusinessException {
        SystemProperties.getInstance().getProperty("system.ProductId");
        Map<String, Object> paramsMap = new HashMap();
        boolean isResourceCode = true;
        if(map != null) {
            if(AppContext.getCurrentUser() != null) {
                isResourceCode = MenuPurviewUtil.isHaveProjectAndTask(AppContext.getCurrentUser());
            }

            if(AppContext.hasPlugin("taskmanage") && isResourceCode) {
                paramsMap.put("plannedStartTime", map.get("beginDate"));
                paramsMap.put("plannedEndTime", map.get("endDate"));
                paramsMap.put("userId", map.get("currentUserID"));
                paramsMap.put("status", "1,2,3,4");
                paramsMap.put("source", "timeView");
                return this.taskInfoManager.selectTaskInfoList(paramsMap);
            }
        }

        return null;
    }

    public List<ColSummaryVO> getAllOtherCollaboration(Map<String, Object> map) throws BusinessException {
        if(AppContext.hasPlugin(TemplateEventEnum.COLLABORATION)) {
            map.put("timeLineFlag", Boolean.TRUE);
            return this.colManager.getMyCollDeadlineNotEmpty(map);
        } else {
            return null;
        }
    }

    public List<Meeting> getAllOtherMeeting(Map<String, Object> map) throws BusinessException {
        if(AppContext.hasPlugin(TemplateEventEnum.MEETING)) {
            List<Integer> replystateList = new ArrayList();
            replystateList.add(Integer.valueOf(SubStateEnum.col_pending_unRead.key()));
            replystateList.add(Integer.valueOf(SubStateEnum.col_pending_read.key()));
            replystateList.add(Integer.valueOf(SubStateEnum.meeting_pending_join.key()));
            replystateList.add(Integer.valueOf(SubStateEnum.meeting_pending_pause.key()));
            map.put("replystateList", replystateList);
            return this.meetingManager.findMeetingListForExternalCalls(ApplicationCategoryEnum.calendar.key(), map);
        } else {
            return null;
        }
    }

    public String getBeginTime() throws BusinessException {
        if(AppContext.hasPlugin("worktimeset")) {
            WorkTimeCurrency workTimeCurrency = this.workTimeSetManager.findComnWorkTimeSet(AppContext.getCurrentUser().getLoginAccount());
            double beginTime = Double.parseDouble(workTimeCurrency.getAmWorkTimeBeginTime().replace(":", "."));
            Date curDate = Calendar.getInstance().getTime();
            double curBeginTime = Double.parseDouble((new SimpleDateFormat("HH")).format(curDate));
            if(beginTime < curBeginTime) {
                beginTime = curBeginTime;
            }

            return String.valueOf(beginTime);
        } else {
            return "8";
        }
    }

    public List<EdocSummaryModel> getAllOtherEdoc(Map<String, Object> map) throws BusinessException {
        return AppContext.hasPlugin(TemplateEventEnum.DOC)?this.edocManager.getMyEdocDeadlineNotEmpty(map):null;
    }

    public List<CalEventInfoBO> getCalEventViewSetion(int count, String columnsource) throws BusinessException {
        List<CalEvent> calEvents = this.getDate4portal(count, columnsource, "caleventView", (FlipInfo)null, (CalEvent)null, (List)null, this.getCurDate());
        return this.getCalEventInfoBO(calEvents);
    }

    public Date getCurDate() {
        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();
        int year = calendar.get(1);
        int month = calendar.get(2) + 1;
        int day = calendar.get(5);
        String curDayStr = year + "-" + month + "-" + day;

        try {
            date = DateUtil.parse(curDayStr, "yyyy-MM-dd");
        } catch (ParseException var8) {
            logger.error(var8.getLocalizedMessage(), var8);
        }

        return date;
    }

    private List<CalEvent> getDate4portal(int count, String columnsource, String source, FlipInfo fi, CalEvent calEvent, List<List<Long>> otherID, Date curDate) throws BusinessException {
        List<Date> curDates = new ArrayList();
        List<CalEvent> calEvents = new ArrayList();
        int i = 0;
        Boolean isKuaRi = Boolean.FALSE;
        int curCount = count - calEvents.size();

        do {
            if(i == 0) {
                curDates.add(curDate);
                curDates.add(Datetimes.addDate(curDate, 1));
            } else if(i == 1) {
                isKuaRi = Boolean.TRUE;
                curDates.add(Datetimes.addDate(curDate, 1));
                curDates.add(curDate);
            } else if(i == 2) {
                curDates.add(Datetimes.addDate(curDate, 1));
                curDates.add(Datetimes.addDate(curDate, 2));
            } else if(i == 3) {
                curDates.add(Datetimes.addDate(curDate, -7));
                curDates.add(curDate);
            } else if(i == 4) {
                curDates.add(Datetimes.addDate(curDate, 2));
                curDates.add(Datetimes.addDate(curDate, 9));
            }

            if("caleventView".equals(source)) {
                calEvents.addAll(this.calEventDao.getCalEventViewSetion(curCount, columnsource, curDates, isKuaRi));
            } else {
                this.calEventDao.getAllOtherEvent(fi, calEvent, Integer.valueOf(curCount), curDates, isKuaRi, otherID);
                calEvents.addAll(fi.getData());
            }

            curDates.clear();
            isKuaRi = Boolean.FALSE;
            curCount = count - calEvents.size();
            ++i;
        } while(calEvents.size() < count && i < 5);

        return calEvents;
    }

    private Map<String, Object> getMap(Boolean isTimeLine) throws BusinessException {
        Map<String, Object> map = null;
        if(isTimeLine.booleanValue()) {
            map = this.getMap(DateFormatUtils.ISO_DATE_FORMAT.format(Calendar.getInstance().getTime()));
        } else {
            map = this.getCalEventViewDate();
        }

        return map;
    }

    private Map<String, Object> getMap(String curDateStr) throws BusinessException {
        Map<String, Object> map = new HashMap();
        Date date = Calendar.getInstance().getTime();

        try {
            if(Strings.isNotBlank(curDateStr)) {
                date = DateUtils.parseDate(curDateStr, getAllAndSDateDFormat());
            }

            String beginDateStr = DateFormatUtils.ISO_DATE_FORMAT.format(date);
            map.put("beginDate", DateUtils.parseDate(beginDateStr, getAllAndSDateDFormat()));
            map.put("endDate", DateUtils.addSeconds(DateUtils.addDays(DateUtils.parseDate(beginDateStr, getAllAndSDateDFormat()), 1), -1));
        } catch (ParseException var6) {
            logger.error(var6.getLocalizedMessage(), var6);
        }

        map.put("currentUserID", AppContext.getCurrentUser().getId());
        return map;
    }

    public void getTimeCompareSort(List<Plan> plans, List<TaskInfoBO> taskInfos, List<Meeting> meetings, Map<String, Object> curMap, List<ColSummaryVO> colSummaryVOs, List<EdocSummaryModel> edocList, List<TimeCompare> compareEvent) throws BusinessException {
        if(CollectionUtils.isNotEmpty(meetings)) {
            this.getCalEventBOByMeeting(meetings, compareEvent);
        }

        this.getCalEventView((List)curMap.get("calEvents"), compareEvent, (Boolean)curMap.get("isView"));

        try {
            if(CollectionUtils.isNotEmpty(plans)) {
                this.getCalEventBOByPlan(plans, compareEvent);
            }

            if(CollectionUtils.isNotEmpty(taskInfos)) {
                this.getCalEventBOByTaskInfo(taskInfos, compareEvent, (Boolean)curMap.get("isView"));
            }

            if(CollectionUtils.isNotEmpty(colSummaryVOs)) {
                this.getCalEventBOByColSum(colSummaryVOs, compareEvent);
            }

            if(CollectionUtils.isNotEmpty(edocList)) {
                this.getCalEventBOByEdoc(edocList, compareEvent);
            }
        } catch (ParseException var9) {
            logger.error(var9.getLocalizedMessage(), var9);
        }

        Collections.sort(compareEvent);
    }

    public List<TimeCompare> findTimeCompare(String curDateStr, Long currentUserID) throws BusinessException {
        Date date = Calendar.getInstance().getTime();
        Date beginDate = null;
        Date endDate = null;

        String beginDateStr;
        try {
            if(!StringUtil.checkNull(curDateStr)) {
                date = DateUtils.parseDate(curDateStr, getAllAndSDateDFormat());
            }

            beginDateStr = DateFormatUtils.ISO_DATE_FORMAT.format(date);
            beginDate = DateUtils.parseDate(beginDateStr, getAllAndSDateDFormat());
            endDate = DateUtils.addSeconds(DateUtils.addDays(DateUtils.parseDate(beginDateStr, getAllAndSDateDFormat()), 1), -1);
        } catch (ParseException var14) {
            logger.error(var14.getLocalizedMessage(), var14);
        }

        beginDateStr = null;
        List<Plan> plans = null;
        List<Meeting> meetings = null;
        List<TaskInfoBO> taskInfos = null;
        List<CalEvent> calEvents = null;
        List<ColSummaryVO> colSummaryVOs = null;
        plans = this.getAllOtherPlan(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
        meetings = this.getAllOtherMeeting(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
        taskInfos = this.getAllOtherTask(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
        calEvents = this.getAllCaleventView(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
        colSummaryVOs = this.getAllOtherCollaboration(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
        List<EdocSummaryModel> edocList = this.getAllOtherEdoc(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
        List<TimeCompare> compareEvent = new ArrayList();
        Map<String, Object> map = new HashMap();
        map.put("isView", Boolean.FALSE);
        map.put("calEvents", calEvents);
        this.getTimeCompareSort(plans, taskInfos, meetings, map, colSummaryVOs, edocList, compareEvent);
        this.dataCount = compareEvent.size();
        return compareEvent;
    }

    public FlipInfo getPageData(List objList, int pageNo, int pageSize) throws BusinessException {
        FlipInfo flp = new FlipInfo();
        if(CollectionUtils.isNotEmpty(objList)) {
            if(pageNo != 0 && pageSize != 0) {
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

    private void getCalEventBOByPlan(List<Plan> plans, List<TimeCompare> compareEvent) throws ParseException {
        SimpleDateFormat sDateFormat = new SimpleDateFormat("HH:mm");
        Iterator var5 = plans.iterator();

        while(var5.hasNext()) {
            Plan plan = (Plan)var5.next();
            TimeCalEvent timeCalEvent = new TimeCalEvent();
            timeCalEvent.setBeginDate(plan.getStartTime());
            if("23:59".equals(sDateFormat.format(plan.getEndTime()))) {
                timeCalEvent.setEndDate(plan.getEndTime());
            } else {
                timeCalEvent.setEndDate(Datetimes.addDate(DateUtil.parse(DateFormatUtils.format(plan.getEndTime(), "yyyy-MM-dd")), 1));
            }

            timeCalEvent.setId(plan.getId());
            timeCalEvent.setStates(plan.getPlanStatus());
            timeCalEvent.setType(TemplateEventEnum.PLAN);
            timeCalEvent.setTitle(ArrangeTimeEnum.plan.getText());
            timeCalEvent.setSubject(this.getPlanContent(plan));
            timeCalEvent.setContent(Functions.toHTML(plan.getTitle()));
            timeCalEvent.setCreateUserId(plan.getCreateUserId());
            compareEvent.add(new TimeCompare(timeCalEvent));
        }

    }

    private void getCalEventBOByTaskInfo(List<TaskInfoBO> taskInfos, List<TimeCompare> compareEvent, Boolean isView) throws BusinessException, ParseException {
        Iterator var5 = taskInfos.iterator();

        while(var5.hasNext()) {
            TaskInfoBO taskInfo = (TaskInfoBO)var5.next();
            TimeCalEvent timeCalEvent = new TimeCalEvent();
            timeCalEvent.setBeginDate(DateUtils.parseDate(taskInfo.getPlannedStartTime(), getAllAndSDateDFormat()));
            timeCalEvent.setEndDate(DateUtils.parseDate(taskInfo.getPlannedEndTime(), getAllAndSDateDFormat()));
            timeCalEvent.setId(Long.valueOf(taskInfo.getId()));
            timeCalEvent.setStates(String.valueOf(taskInfo.getStatus()));
            timeCalEvent.setType(TemplateEventEnum.TASK);
            timeCalEvent.setTitle(ArrangeTimeEnum.task.getText());
            timeCalEvent.setSubject(this.getTaskInfoContent(taskInfo));
            timeCalEvent.setContent(Functions.toHTML(taskInfo.getSubject()));
            timeCalEvent.setMilestone(Integer.valueOf(taskInfo.getMilestone()));
            timeCalEvent.setCreateUserId(Long.valueOf(taskInfo.getCreateUser()));
            compareEvent.add(new TimeCompare(timeCalEvent));
        }

    }

    private void getCalEventBOByMeeting(List<Meeting> meetings, List<TimeCompare> compareEvent) throws BusinessException {
        Iterator var4 = meetings.iterator();

        while(var4.hasNext()) {
            Meeting meeting = (Meeting)var4.next();
            TimeCalEvent timeCalEvent = new TimeCalEvent();
            timeCalEvent.setBeginDate(meeting.getMtMeeting().getBeginDate());
            timeCalEvent.setEndDate(meeting.getMtMeeting().getEndDate());
            timeCalEvent.setId(meeting.getMtMeeting().getId());
            timeCalEvent.setStates(String.valueOf(meeting.getMtMeeting().getState()));
            timeCalEvent.setType(TemplateEventEnum.MEETING);
            timeCalEvent.setTitle(ArrangeTimeEnum.meeting.getText());
            timeCalEvent.setSubject(this.getMtMeetingContent(meeting));
            timeCalEvent.setContent(Functions.toHTML(meeting.getMtMeeting().getTitle()));
            timeCalEvent.setMeetingNature(meeting.getMtMeeting().getMeetingType());
            timeCalEvent.setAccount(this.orgManager.getMemberById(meeting.getMtMeeting().getCreateUser()).getName());
            timeCalEvent.setCanView(Boolean.TRUE);
            timeCalEvent.setCreateUserId(meeting.getMtMeeting().getCreateUser());
            compareEvent.add(new TimeCompare(timeCalEvent));
        }

    }

    private void getCalEventBOByColSum(List<ColSummaryVO> colSummaryVOs, List<TimeCompare> compareEvent) throws ParseException {
        Iterator var4 = colSummaryVOs.iterator();

        while(var4.hasNext()) {
            ColSummaryVO colSummaryVO = (ColSummaryVO)var4.next();
            TimeCalEvent timeCalEvent = new TimeCalEvent();
            timeCalEvent.setBeginDate(colSummaryVO.getDeadLineDateTime1());
            timeCalEvent.setEndDate(colSummaryVO.getDeadLineDateTime());
            timeCalEvent.setId(colSummaryVO.getAffairId());
            timeCalEvent.setStates(String.valueOf(colSummaryVO.getAffair().getState()));
            timeCalEvent.setType(TemplateEventEnum.COLLABORATION);
            timeCalEvent.setTitle(ArrangeTimeEnum.collaboration.getText());
            timeCalEvent.setSubject(this.getSubjectIncludeIcon(colSummaryVO));
            timeCalEvent.setContent(Functions.toHTML(colSummaryVO.getSubject()));
            timeCalEvent.setAccount(colSummaryVO.getStartMemberName());
            timeCalEvent.setCreateUserId(colSummaryVO.getStartMemberId());
            compareEvent.add(new TimeCompare(timeCalEvent));
        }

    }

    private void getCalEventBOByEdoc(List<EdocSummaryModel> edocList, List<TimeCompare> compareEvent) throws ParseException {
        Iterator var4 = edocList.iterator();

        while(var4.hasNext()) {
            EdocSummaryModel edocSummaryModel = (EdocSummaryModel)var4.next();
            TimeCalEvent timeCalEvent = new TimeCalEvent();
            timeCalEvent.setBeginDate(edocSummaryModel.getDeadLineDisplayDate());
            timeCalEvent.setEndDate(edocSummaryModel.getDeadLineDate());
            timeCalEvent.setId(edocSummaryModel.getAffairId());
            timeCalEvent.setStates(String.valueOf(edocSummaryModel.getState()));
            timeCalEvent.setType(TemplateEventEnum.DOC);
            timeCalEvent.setTitle(ArrangeTimeEnum.edoc.getText());
            timeCalEvent.setSubject(this.getEdocSummaryContent(edocSummaryModel));
            timeCalEvent.setContent(Functions.toHTML(edocSummaryModel.getSubject()));
            timeCalEvent.setAccount(edocSummaryModel.getEdocUnit());
            Long createUserId = Long.valueOf(-1L);
            if(edocSummaryModel.getSummary() != null && edocSummaryModel.getSummary().getStartUserId() != null) {
                createUserId = edocSummaryModel.getSummary().getStartUserId();
            }

            timeCalEvent.setCreateUserId(createUserId);
            compareEvent.add(new TimeCompare(timeCalEvent));
        }

    }

    private String getPlanContent(Plan plan) {
        StringBuilder content = new StringBuilder();
        content.append(Functions.toHTML(ConvertUtil.cutString(plan.getTitle(), 70)));
        if(plan.isHasAttachments()) {
            content.append(IcomEnumForCalendar.Attachment.getIcon());
        }

        if(plan.getContentType() != MainbodyType.HTML.getKey()) {
            content.append(MainbodyType.getEnumByKey(plan.getContentType()).getIcon());
        }

        return content.toString();
    }

    private String getEdocSummaryContent(EdocSummaryModel edocSummaryModel) {
        StringBuilder content = new StringBuilder();
        if(!Integer.valueOf(0).equals(Integer.valueOf(edocSummaryModel.getEdocStatus()))) {
            content.append("<span class='ico16  flow").append(edocSummaryModel.getEdocStatus()).append("_16 '></span>");
        }

        if(Strings.equals(edocSummaryModel.getSummary().getUrgentLevel(), "2")) {
            content.append(IcomEnumForCalendar.ImportantLevel2.getIcon());
        } else if(Strings.equals(edocSummaryModel.getSummary().getUrgentLevel(), "3")) {
            content.append(IcomEnumForCalendar.ImportantLevel3.getIcon());
        }

        content.append(Functions.toHTML(ConvertUtil.cutString(edocSummaryModel.getSubject(), 70)));
        if(edocSummaryModel.getBodyType() != null && !"HTML".equals(edocSummaryModel.getBodyType())) {
            if(edocSummaryModel.getBodyType().equals(MainbodyType.OfficeWord.name())) {
                content.append(MainbodyType.OfficeWord.getIcon());
            } else if(edocSummaryModel.getBodyType().equals(MainbodyType.OfficeExcel.name())) {
                content.append(MainbodyType.OfficeExcel.getIcon());
            } else if(edocSummaryModel.getBodyType().equals(MainbodyType.Pdf.name())) {
                content.append(MainbodyType.Pdf.getIcon());
            } else if(edocSummaryModel.getBodyType().equals(MainbodyType.WpsWord.name())) {
                content.append(MainbodyType.WpsWord.getIcon());
            } else if(edocSummaryModel.getBodyType().equals(MainbodyType.WpsExcel.name())) {
                content.append(MainbodyType.WpsExcel.getIcon());
            } else {
                content.append("");
            }
        }

        if(edocSummaryModel.isHasAttachments()) {
            content.append(IcomEnumForCalendar.Attachment.getIcon());
        }

        return content.toString();
    }

    private String getTaskInfoContent(TaskInfoBO taskInfo) {
        StringBuilder content = new StringBuilder();
        if(taskInfo.getImportantLevel() == 2) {
            content.append(IcomEnumForCalendar.ImportantLevel2.getIcon());
        } else if(taskInfo.getImportantLevel() == 3) {
            content.append(IcomEnumForCalendar.ImportantLevel3.getIcon());
        }

        if(taskInfo.getMilestone() == 1) {
            content.append(IcomEnumForCalendar.Milestone.getIcon());
        }

        if(taskInfo.getRiskLevel() == 1) {
            content.append(IcomEnumForCalendar.RiskLevel1.getIcon());
        } else if(taskInfo.getRiskLevel() == 2) {
            content.append(IcomEnumForCalendar.RiskLevel2.getIcon());
        } else if(taskInfo.getRiskLevel() == 3) {
            content.append(IcomEnumForCalendar.RiskLevel3.getIcon());
        }

        content.append(Functions.toHTML(ConvertUtil.cutString(taskInfo.getSubject(), 70)));
        if(taskInfo.isHas_attachments()) {
            content.append(IcomEnumForCalendar.Attachment.getIcon());
        }

        return content.toString();
    }

    private String getMtMeetingContent(Meeting meeting) {
        StringBuilder content = new StringBuilder();
        content.append(Functions.toHTML(ConvertUtil.cutString(meeting.getMtMeeting().getTitle(), 70)));
        if("2".equals(meeting.getMtMeeting().getMeetingType())) {
            content.append(IcomEnumForCalendar.VIDEO_MEETING.getIcon());
        }

        if(meeting.getMtMeeting().isHasAttachments()) {
            content.append(IcomEnumForCalendar.Attachment.getIcon());
        }

        if(meeting.getMtMeeting().getDataFormat() != null && !"HTML".equals(meeting.getMtMeeting().getDataFormat())) {
            if(meeting.getMtMeeting().getDataFormat().equals(MainbodyType.OfficeWord.name())) {
                content.append(MainbodyType.OfficeWord.getIcon());
            } else if(meeting.getMtMeeting().getDataFormat().equals(MainbodyType.OfficeExcel.name())) {
                content.append(MainbodyType.OfficeExcel.getIcon());
            } else if(meeting.getMtMeeting().getDataFormat().equals(MainbodyType.Pdf.name())) {
                content.append(MainbodyType.Pdf.getIcon());
            } else if(meeting.getMtMeeting().getDataFormat().equals(MainbodyType.WpsWord.name())) {
                content.append(MainbodyType.WpsWord.getIcon());
            } else if(meeting.getMtMeeting().getDataFormat().equals(MainbodyType.WpsExcel.name())) {
                content.append(MainbodyType.WpsExcel.getIcon());
            } else {
                content.append("");
            }
        }

        return content.toString();
    }

    private String getSubjectIncludeIcon(ColSummaryVO colSummaryVO) {
        StringBuilder sb = new StringBuilder();
        if(!Integer.valueOf(0).equals(colSummaryVO.getState())) {
            sb.append("<span class='ico16  flow").append(colSummaryVO.getState()).append("_16 '></span>");
        }

        if(colSummaryVO.getImportantLevel() != null && colSummaryVO.getImportantLevel().intValue() != 1) {
            sb.append("<span class='ico16 important").append(colSummaryVO.getImportantLevel()).append("_16 '></span>");
        }

        sb.append(Functions.toHTML(ConvertUtil.cutString(colSummaryVO.getSubject(), 70)));
        if(colSummaryVO.getHasAttsFlag() != null && colSummaryVO.getHasAttsFlag().booleanValue()) {
            sb.append(IcomEnumForCalendar.Attachment.getIcon());
        }

        if(!String.valueOf(MainbodyType.HTML.getKey()).equals(colSummaryVO.getBodyType()) && !String.valueOf(MainbodyType.TXT.getKey()).equals(colSummaryVO.getBodyType())) {
            sb.append("<span class='ico16 office").append(colSummaryVO.getBodyType()).append("_16'></span>");
        }

        return sb.toString();
    }

    private void getCalEventView(List<CalEvent> calEvents, List<TimeCompare> compareEvent, Boolean isView) throws BusinessException {
        if(CollectionUtils.isNotEmpty(calEvents)) {
            Iterator var6 = calEvents.iterator();

            while(var6.hasNext()) {
                CalEvent calEvent = (CalEvent)var6.next();
                TimeCalEvent timeCalEvent = new TimeCalEvent();
                timeCalEvent.setBeginDate(calEvent.getBeginDate());
                timeCalEvent.setEndDate(calEvent.getEndDate());
                timeCalEvent.setId(calEvent.getId());
                timeCalEvent.setReceiveMemberId(calEvent.getReceiveMemberId());
                timeCalEvent.setShareType(calEvent.getShareType());
                timeCalEvent.setStates(String.valueOf(calEvent.getStates()));
                timeCalEvent.setType(TemplateEventEnum.CALEVENT);
                timeCalEvent.setTitle(ArrangeTimeEnum.calEvent.getText());
                if(isView.booleanValue()) {
                    timeCalEvent.setSubject(Strings.toHTML(calEvent.getSubject()));
                } else {
                    StringBuilder subjectStr = new StringBuilder();
                    subjectStr.append(Functions.toHTML(ConvertUtil.cutString(calEvent.getSubject(), 70)));
                    if(calEvent.getAttachmentsFlag().booleanValue()) {
                        subjectStr.append(IcomEnumForCalendar.Attachment.getIcon());
                    }

                    timeCalEvent.setSubject(subjectStr.toString());
                }

                timeCalEvent.setContent(Strings.toHTML(calEvent.getSubject()));
                timeCalEvent.setCreateUserId(calEvent.getCreateUserId());
                compareEvent.add(new TimeCompare(timeCalEvent));
            }
        }

    }

    private void toNewCalEventState(CalEventInfoBO calEventInfoBO, CalEvent calEvent, CalEventPeriodicalInfo calEventPeriodicalInfo, String[] params) throws BusinessException {
        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();
        Date curBeginDate = null;

        try {
            if(Strings.isNotBlank(params[15])) {
                curBeginDate = DateUtils.parseDate(params[15], getAllAndSDateDFormat());
            } else {
                curBeginDate = (new GregorianCalendar()).getTime();
            }

            calendar.setTime(curBeginDate);
            AppContext.putRequestContext("curDayDate", Integer.valueOf(calendar.get(5)));
            if(Strings.isNotBlank(params[0])) {
                date = DateUtils.parseDate(params[0], getAllAndSDateDFormat());
            }

            calEventPeriodicalInfo.setBeginTime(date);
            if(Strings.isNotBlank(params[1])) {
                date = DateUtils.parseDate(params[1], getAllAndSDateDFormat());
            }

            calEventPeriodicalInfo.setEndTime(date);
        } catch (ParseException var16) {
            logger.error(var16.getLocalizedMessage(), var16);
        }

        Integer periodical = Integer.valueOf(0);
        if(Strings.isNotBlank(params[2])) {
            periodical = Integer.valueOf(params[2]);
        }

        calEventPeriodicalInfo.setPeriodicalType(periodical);
        Float realEstimate = Float.valueOf(0.0F);
        if(Strings.isNotBlank(params[3])) {
            realEstimate = Float.valueOf(params[3]);
        }

        calEvent.setRealEstimateTime(realEstimate);
        if(Strings.isNotBlank(params[4])) {
            calEvent.setWorkType(Integer.valueOf(params[4]));
        }

        if(Strings.isNotBlank(params[5])) {
            calEventPeriodicalInfo.setDayDate(Integer.valueOf(params[5]));
        }

        if(Strings.isNotBlank(params[6])) {
            calEventPeriodicalInfo.setSwithMonth(Integer.parseInt(params[6]));
        }

        if(Strings.isNotBlank(params[7])) {
            calEventPeriodicalInfo.setSwithYear(Integer.parseInt(params[7]));
        }

        if(Strings.isNotBlank(params[8])) {
            calEventPeriodicalInfo.setDayWeek(Integer.valueOf(params[8]));
        } else {
            calEventPeriodicalInfo.setDayWeek(Integer.valueOf(calendar.get(7)));
        }

        calEventInfoBO.getWeeks().add(calEventPeriodicalInfo.getDayWeek().toString());
        if(Strings.isNotBlank(params[9])) {
            calEventPeriodicalInfo.setWeek(Integer.valueOf(params[9]));
        } else {
            calEventPeriodicalInfo.setWeek(Integer.valueOf(calendar.get(8)));
        }

        if(Strings.isNotBlank(params[10])) {
            calEventPeriodicalInfo.setMonth(Integer.valueOf(params[10]));
        } else {
            calEventPeriodicalInfo.setMonth(Integer.valueOf(calendar.get(2) + 1));
        }

        if(Strings.isNotBlank(params[11])) {
            String curweeks = params[11];
            String[] weeks = curweeks.split(",");
            calEventInfoBO.getWeeks().clear();
            String[] var15 = weeks;
            int var14 = weeks.length;

            for(int var13 = 0; var13 < var14; ++var13) {
                String week = var15[var13];
                calEventInfoBO.getWeeks().add(week);
            }
        }

    }

    public long saveCalEventForM1(Map<String, Object> params) throws BusinessException {
        CalEventPeriodicalInfo cInfo = new CalEventPeriodicalInfo();
        CalEvent calEvent = new CalEvent();
        CalContent calContent = new CalContent();
        CalEvent oldCalEvent = null;
        if(params.get("calEventID") != null && !"-1".equals(params.get("calEventID"))) {
            oldCalEvent = this.getCalEventById(Long.valueOf(params.get("calEventID").toString()), Boolean.FALSE);
        }

        Long recordid = null;
        if(Strings.isNotBlank((String)params.get("fromRecordId")) && !"-1".equals(params.get("fromRecordId"))) {
            recordid = Long.valueOf(params.get("fromRecordId").toString());
        }

        calEvent.setFromRecordId(recordid);
        Boolean isNew = this.initCalEventFromPage(params, calEvent, calContent, cInfo);
        this.initCalEventByShareType(params, calEvent);
        this.initCalEventByHasVal(calEvent, isNew);
        Date endate = calEvent.getEndDate();
        Date beginDate = calEvent.getBeginDate();
        String updateTip = params.get("updateTip") == null?"0":params.get("updateTip").toString();
        CalEventPeriodicalInfo oldCalEventPeriodicalInfo = null;
        if(!DateUtils.isSameDay(endate, beginDate) && (cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType().intValue() == 1 || cInfo.getPeriodicalType().intValue() == 2) && !"1".equals(updateTip)) {
            throw new BusinessException(ResourceUtil.getString("calendar.event.priorityType.kuaRi"));
        } else if(calEvent.getBeginDate().after(calEvent.getEndDate())) {
            throw new BusinessException(ResourceUtil.getString("calendar.event.date.compare"));
        } else {
            Boolean isFanWei = Boolean.FALSE;
            Long eventID = calEvent.getPeriodicalChildId() == null?calEvent.getId():calEvent.getPeriodicalChildId();
            if("2".equals(updateTip)) {
                oldCalEventPeriodicalInfo = this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(eventID);
                isFanWei = Boolean.valueOf(cInfo.getBeginTime().before(oldCalEventPeriodicalInfo.getEndTime()) && cInfo.getBeginTime().after(oldCalEventPeriodicalInfo.getBeginTime()) || DateUtils.isSameDay(cInfo.getBeginTime(), oldCalEventPeriodicalInfo.getBeginTime()) || DateUtils.isSameDay(cInfo.getEndTime(), oldCalEventPeriodicalInfo.getEndTime()));
                Date endTimeDate = Datetimes.addDate(calEvent.getBeginDate(), -1);
                if(isFanWei.booleanValue() && endTimeDate.after(oldCalEventPeriodicalInfo.getBeginTime()) && endTimeDate.before(oldCalEventPeriodicalInfo.getEndTime())) {
                    oldCalEventPeriodicalInfo.setEndTime(endTimeDate);
                } else {
                    this.calEventPeriodicalInfoManager.deleteByEventId(eventID);
                    oldCalEventPeriodicalInfo = null;
                }

                this.deleteOldPeriodical(calEvent, oldCalEventPeriodicalInfo);
            }

            this.enumManagerNew.updateEnumItemRef("cal_event_type", calEvent.getCalEventType().toString());
            this.enumManagerNew.updateEnumItemRef("cal_event_signifyType", calEvent.getSignifyType().toString());
            this.saveCalEventTOEvent(calEvent, oldCalEvent);
            if(cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType().intValue() != 0 && !"1".equals(updateTip)) {
                if(calEvent != null && calEvent.getId() != null) {
                    this.calEventDao.deleteCalEventById(calEvent.getId());
                }

                QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + eventID);
                calEvent.setIdIfNew();
                this.saveAttachment(calEvent, calEvent.getId());
                this.toSendCalEventMessage(calEvent, oldCalEvent);
                this.getPeriodicalCalEventList(calContent, updateTip, calEvent, cInfo, oldCalEventPeriodicalInfo);
                if("2".equals(updateTip) && oldCalEventPeriodicalInfo == null) {
                    CalEvent parentCalEvent = this.calEventDao.getCalEvent(eventID);
                    if(parentCalEvent != null) {
                        parentCalEvent.setPeriodicalStyle(Integer.valueOf(0));
                        this.calEventDao.saveCalEvent(parentCalEvent);
                    }
                }
            } else {
                Long eventId = calEvent.getId();
                calContent.setEventId(eventId);
                this.deleteCalContentByEventId(eventId);
                if(Strings.isNotBlank(calContent.getContent())) {
                    this.saveCalContent(calContent);
                }

                this.deleteTranEventByEventId(calEvent.getId());
                this.saveTranEvents(calEvent);
                if(calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey() && Strings.isNotBlank(calEvent.getTranMemberIds())) {
                    this.saveProject(calEvent);
                }

                calEvent.setAttachmentsFlag(Boolean.valueOf((String)params.get("attachmentsFlag")));
                this.save(calEvent, oldCalEvent);
            }

            try {
                if(calEvent.getFromId().longValue() != -1L && calEvent.getFromId() != null && isNew.booleanValue()) {
                    String repeatTitle = ParamUtil.getString(params, "repeat_title");
                    this.planManager.sendMessageForTran(TransferTypeEnum.transferCal.getKey(), calEvent.getFromId(), calEvent.getId(), repeatTitle);
                }
            } catch (Exception var15) {
                ;
            }

            if(calEvent.getPeriodicalStyle().intValue() == 0) {
                List<CalEvent> calEvents = new ArrayList();
                calEvents.add(calEvent);
                this.eventRemind(Calendar.getInstance().getTime(), calEvent.getAlarmDate(), calEvent.getBeginDate(), "job_" + calEvent.getId(), calEvents, cInfo);
                this.eventRemind(Calendar.getInstance().getTime(), calEvent.getBeforendAlarm(), calEvent.getEndDate(), calEvent.getId() + "beforEnd_job", calEvents, cInfo);
            }

            return calEvent.getId().longValue();
        }
    }

    public void saveCalEvent(Map<String, Object> params) throws BusinessException {
        CalEventPeriodicalInfo cInfo = new CalEventPeriodicalInfo();
        CalEvent calEvent = new CalEvent();
        CalContent calContent = new CalContent();
        CalEvent oldCalEvent = null;
        if(params.get("calEventID") != null && !"-1".equals(params.get("calEventID"))) {
            oldCalEvent = this.getCalEventById(Long.valueOf(params.get("calEventID").toString()), Boolean.FALSE);
        }

        Long recordid = null;
        if(Strings.isNotBlank((String)params.get("fromRecordId")) && !"-1".equals(params.get("fromRecordId"))) {
            recordid = Long.valueOf(params.get("fromRecordId").toString());
        }

        calEvent.setFromRecordId(recordid);
        Boolean isNew = this.initCalEventFromPage(params, calEvent, calContent, cInfo);
        this.initCalEventByShareType(params, calEvent);
        this.initCalEventByHasVal(calEvent, isNew);
        Date endate = calEvent.getEndDate();
        Date beginDate = calEvent.getBeginDate();
        String updateTip = params.get("updateTip") == null?"0":params.get("updateTip").toString();
        CalEventPeriodicalInfo oldCalEventPeriodicalInfo = null;
        if(!DateUtils.isSameDay(endate, beginDate) && (cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType().intValue() == 1 || cInfo.getPeriodicalType().intValue() == 2) && !"1".equals(updateTip)) {
            throw new BusinessException(ResourceUtil.getString("calendar.event.priorityType.kuaRi"));
        } else if(calEvent.getBeginDate().after(calEvent.getEndDate())) {
            throw new BusinessException(ResourceUtil.getString("calendar.event.date.compare"));
        } else {
            Boolean isFanWei = Boolean.FALSE;
            Long eventID = calEvent.getPeriodicalChildId() == null?calEvent.getId():calEvent.getPeriodicalChildId();
            if("2".equals(updateTip)) {
                oldCalEventPeriodicalInfo = this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(eventID);
                if(oldCalEventPeriodicalInfo != null) {
                    isFanWei = Boolean.valueOf(cInfo.getBeginTime().before(oldCalEventPeriodicalInfo.getEndTime()) && cInfo.getBeginTime().after(oldCalEventPeriodicalInfo.getBeginTime()) || DateUtils.isSameDay(cInfo.getBeginTime(), oldCalEventPeriodicalInfo.getBeginTime()) || DateUtils.isSameDay(cInfo.getEndTime(), oldCalEventPeriodicalInfo.getEndTime()));
                    Date endTimeDate = Datetimes.addDate(calEvent.getBeginDate(), -1);
                    if(isFanWei.booleanValue() && endTimeDate.after(oldCalEventPeriodicalInfo.getBeginTime()) && endTimeDate.before(oldCalEventPeriodicalInfo.getEndTime())) {
                        oldCalEventPeriodicalInfo.setEndTime(endTimeDate);
                    } else {
                        this.calEventPeriodicalInfoManager.deleteByEventId(eventID);
                        oldCalEventPeriodicalInfo = null;
                    }

                    this.deleteOldPeriodical(calEvent, oldCalEventPeriodicalInfo);
                }
            }

            this.enumManagerNew.updateEnumItemRef("cal_event_type", calEvent.getCalEventType().toString());
            this.enumManagerNew.updateEnumItemRef("cal_event_signifyType", calEvent.getSignifyType().toString());
            this.saveCalEventTOEvent(calEvent, oldCalEvent);
            if(cInfo.getPeriodicalType() != null && cInfo.getPeriodicalType().intValue() != 0 && !"1".equals(updateTip)) {
                if(calEvent != null && calEvent.getId() != null) {
                    this.calEventDao.deleteCalEventById(calEvent.getId());
                }

                QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + eventID);
                calEvent.setIdIfNew();
                this.saveAttachment(calEvent, calEvent.getId());
                this.toSendCalEventMessage(calEvent, oldCalEvent);
                this.getPeriodicalCalEventList(calContent, updateTip, calEvent, cInfo, oldCalEventPeriodicalInfo);
                if("2".equals(updateTip) && oldCalEventPeriodicalInfo == null) {
                    CalEvent parentCalEvent = this.calEventDao.getCalEvent(eventID);
                    if(parentCalEvent != null) {
                        parentCalEvent.setPeriodicalStyle(Integer.valueOf(0));
                        this.calEventDao.saveCalEvent(parentCalEvent);
                    }
                }
            } else {
                Long eventId = calEvent.getId();
                calContent.setEventId(eventId);
                this.deleteCalContentByEventId(eventId);
                if(Strings.isNotBlank(calContent.getContent())) {
                    this.saveCalContent(calContent);
                }

                this.deleteTranEventByEventId(calEvent.getId());
                this.saveTranEvents(calEvent);
                if(calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey() && Strings.isNotBlank(calEvent.getTranMemberIds())) {
                    this.saveProject(calEvent);
                }

                this.saveAttachment(calEvent, calEvent.getId());
                this.save(calEvent, oldCalEvent);
            }

            try {
                if(calEvent.getFromId().longValue() != -1L && calEvent.getFromId() != null && isNew.booleanValue()) {
                    String repeatTitle = ParamUtil.getString(params, "repeat_title");
                    this.planManager.sendMessageForTran(TransferTypeEnum.transferCal.getKey(), calEvent.getFromId(), calEvent.getId(), repeatTitle);
                }
            } catch (Exception var15) {
                ;
            }

            if(calEvent.getPeriodicalStyle().intValue() == 0) {
                List<CalEvent> calEvents = new ArrayList();
                calEvents.add(calEvent);
                this.eventRemind(Calendar.getInstance().getTime(), calEvent.getAlarmDate(), calEvent.getBeginDate(), "job_" + calEvent.getId(), calEvents, cInfo);
                this.eventRemind(Calendar.getInstance().getTime(), calEvent.getBeforendAlarm(), calEvent.getEndDate(), calEvent.getId() + "beforEnd_job", calEvents, cInfo);
            }

        }
    }

    private void getPeriodicalCalEventList(CalContent calContent, String updateTip, CalEvent calEvent, CalEventPeriodicalInfo cInfo, CalEventPeriodicalInfo oldCalEventPeriodicalInfo) throws BusinessException {
        List<CalEvent> calEvents = new ArrayList();
        List<Long> eventIDs = new ArrayList();
        List<List<Date>> daList = new ArrayList();
        cInfo.setMemberId(calEvent.getCreateUserId());
        cInfo.setCalEventId(calEvent.getId());
        Long periodicalId = this.saveCalEventPeriodicalInfo(cInfo);
        calEvent.setPeriodicalId(periodicalId);
        calEvent.setPeriodicalStyle(cInfo.getPeriodicalType());
        Map<String, Integer> dayMegMap = this.getCurPeriocalMeg(calEvent, cInfo);
        String hourStart = DateFormatUtils.format(calEvent.getBeginDate(), "HH:mm");
        String hourEnd = DateFormatUtils.format(calEvent.getEndDate(), "HH:mm");
        if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.dayCycle.getKey()) {
            daList = this.getPeriodicalEventByDay(calEvent, cInfo, hourStart, hourEnd);
        } else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.weekCycle.getKey()) {
            daList = this.getPeriodicalEventByWeek(calEvent, cInfo, hourStart, hourEnd);
        } else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()) {
            daList = this.getPeriodicalEventByMonth(calEvent, cInfo, hourStart, hourEnd, dayMegMap);
        } else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()) {
            daList = this.getPeriodicalEventByYear(calEvent, cInfo, hourStart, hourEnd, dayMegMap);
        }

        List<Date> curDates = new ArrayList();
        curDates.add(calEvent.getBeginDate());
        curDates.add(calEvent.getEndDate());
        ((List)daList).add(curDates);
        int i = 0;

        for(int j = ((List)daList).size(); i < j; ++i) {
             curDates = (List)((List)daList).get(i);

            try {
                this.getPeriodicalEvent(calEvent, calEvents, (Date)curDates.get(0), (Date)curDates.get(1), eventIDs);
            } catch (ParseException var17) {
                logger.error(var17.getLocalizedMessage(), var17);
            }
        }

        this.savePeriodicalInfoMeg(calContent, oldCalEventPeriodicalInfo, calEvents, calEvent, cInfo);
    }

    private void savePeriodicalInfoMeg(CalContent content, CalEventPeriodicalInfo oldCalEventPeriodicalInfo, List<CalEvent> calEvents, CalEvent calEvent, CalEventPeriodicalInfo cInfo) throws BusinessException {
        List<CalContent> calContents = new ArrayList();
        List<String[]> calEventLogs = new ArrayList();
        List<Long> eventIDs = new ArrayList();
        Date today = Calendar.getInstance().getTime();
        StringBuilder messageTypes = this.getCalEventMegStr((CalEvent)calEvents.get(0), (CalEvent)null);
        Iterator var12 = calEvents.iterator();

        while(var12.hasNext()) {
            CalEvent cEvent = (CalEvent)var12.next();
            String[] LogStr = new String[]{AppContext.getCurrentUser().getName(), cEvent.getSubject(), cEvent.getBeginDate().toString()};
            calEventLogs.add(LogStr);
            eventIDs.add(cEvent.getId());
            if(Strings.isNotBlank(content.getContent())) {
                try {
                    CalContent temp = (CalContent)BeanUtils.cloneBean(content);
                    temp.setIdIfNew();
                    temp.setEventId(cEvent.getId());
                    calContents.add(temp);
                } catch (Exception var15) {
                    logger.error(var15.getLocalizedMessage(), var15);
                }
            }
        }

        this.eventRemind(today, calEvent.getAlarmDate(), calEvent.getBeginDate(), "job_" + calEvent.getId(), calEvents, cInfo);
        this.eventRemind(today, calEvent.getBeforendAlarm(), calEvent.getEndDate(), calEvent.getId() + "beforEnd_job", calEvents, cInfo);
        this.eventPeriodicalInfoRemind(calEvents, messageTypes.toString(), calEvent, cInfo);
        this.appLogManager.insertLogs(AppContext.getCurrentUser(), AppLogAction.Calendar_New, calEventLogs);
        if(AppContext.hasPlugin("index")) {
            this.indexManager.add(eventIDs, Integer.valueOf(ApplicationCategoryEnum.calendar.getKey()));
        }

        this.saveTranEvents(calEvents);
        if(CollectionUtils.isNotEmpty(calEvents) && calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey() && Strings.isNotBlank(calEvent.getTranMemberIds())) {
            this.saveProject(calEvents);
        }

        if(oldCalEventPeriodicalInfo != null) {
            this.calEventPeriodicalInfoManager.updateCalEventPeriodicalInfo(oldCalEventPeriodicalInfo);
        }

        this.calContentManager.saveAllContent(calContents);
        this.calEventDao.saveAllCalEvent(calEvents);
    }

    private void eventPeriodicalInfoRemind(List<CalEvent> calEvents, String messageTypes, CalEvent calEvent, CalEventPeriodicalInfo cInfo) throws BusinessException {
        String jobName = "jobPeriodicalInfo_" + calEvent.getId();
        QuartzHolder.deleteQuartzJob(jobName);
        Map<String, String> parameters = new HashMap();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Iterator var9 = calEvents.iterator();

        while(var9.hasNext()) {
            CalEvent cal = (CalEvent)var9.next();
            Date dateKey = cal.getBeginDate();
            parameters.put(sdf.format(dateKey), String.valueOf(cal.getId()));
        }

        parameters.put("createUserID", String.valueOf(calEvent.getCreateUserId()));
        parameters.put("type", messageTypes);
        Date temp = calEvent.getBeginDate();
        int hours = temp.getHours();
        int min = temp.getMinutes();
        String dayweek;
        String week;
        String month;
        if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey()) {
            if(cInfo.getSwithMonth() == 2) {
                dayweek = cInfo.getDayWeek().toString();
                week = cInfo.getWeek().toString();
                month = "0 " + min + " " + hours + " ? * " + dayweek + "#" + week;
                QuartzHolder.newCronQuartzJob("NULL", jobName, month, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
            } else {
                QuartzHolder.newQuartzJobPerMonth("NULL", jobName, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
            }
        } else if(cInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()) {
            if(cInfo.getSwithYear() == 2) {
                dayweek = cInfo.getDayWeek().toString();
                week = cInfo.getWeek().toString();
                month = cInfo.getMonth().toString();
                String cronStr = "0 " + min + " " + hours + " ? " + month + " " + dayweek + "#" + week;
                QuartzHolder.newCronQuartzJob("NULL", jobName, cronStr, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
            } else {
                QuartzHolder.newQuartzJobPerYear("NULL", jobName, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
            }
        } else {
            QuartzHolder.newQuartzJobPerDay("NULL", jobName, calEvent.getBeginDate(), cInfo.getEndTime(), "eventRemind", parameters);
        }

    }

    private StringBuilder getCalEventMegStr(CalEvent calEvent, CalEvent oldCalEvent) {
        StringBuilder messageTypes = new StringBuilder();
        if(Strings.isNotBlank(calEvent.getReceiveMemberId())) {
            if(calEvent.getIsEntrust().intValue() == 1) {
                messageTypes.append(CalEvent4Message.P_ON_TRANS.getKey());
            } else {
                messageTypes.append(CalEvent4Message.P_ON_PLAN.getKey());
            }
        }

        if(calEvent.getShareType().intValue() > ShareTypeEnum.personal.getKey()) {
            if(Strings.isNotBlank(calEvent.getReceiveMemberId())) {
                messageTypes.append(",");
            }

            messageTypes.append(CalEvent4Message.P_ON_SHARE.getKey());
        }

        if(oldCalEvent != null && (Strings.isNotBlank(oldCalEvent.getReceiveMemberId()) || oldCalEvent.getShareType().intValue() > ShareTypeEnum.personal.getKey())) {
            messageTypes.append(",");
            messageTypes.append(CalEvent4Message.P_ON_CHANG.getKey());
        }

        return messageTypes;
    }

    private Map<String, Integer> getCurPeriocalMeg(CalEvent calEvent, CalEventPeriodicalInfo cInfo) {
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(cInfo.getBeginTime());
        Integer startYear = Integer.valueOf(calendar.get(1));
        Integer startMonth = Integer.valueOf(calendar.get(2) + 1);
        calendar.setTime(cInfo.getEndTime());
        Integer endYear = Integer.valueOf(calendar.get(1));
        calendar.setTime(calEvent.getBeginDate());
        Integer messageDay = Integer.valueOf(calendar.get(5));
        Integer intervalDays = Integer.valueOf(this.getIntervalDays(calEvent.getBeginDate(), calEvent.getEndDate()));
        Map<String, Integer> dayMegMap = new HashMap();
        dayMegMap.put("startYear", startYear);
        dayMegMap.put("endYear", endYear);
        dayMegMap.put("startMonth", startMonth);
        dayMegMap.put("messageDay", messageDay);
        dayMegMap.put("intervalDays", intervalDays);
        return dayMegMap;
    }

    private void deleteOldPeriodical(CalEvent calEvent, CalEventPeriodicalInfo oldCalEventPeriodicalInfo) throws BusinessException {
        List<String[]> calEventLogs = new ArrayList();
        List<Long> oldEventIDs = new ArrayList();
        List<CalEvent> calEventsFormDB = this.calEventDao.getAllCalEvent(calEvent, Boolean.FALSE);
        if(CollectionUtils.isNotEmpty(calEventsFormDB)) {
            Iterator var7 = calEventsFormDB.iterator();

            while(var7.hasNext()) {
                CalEvent calEventsFormDBTemp = (CalEvent)var7.next();
                oldEventIDs.add(calEventsFormDBTemp.getId());
                String[] LogStr = new String[]{AppContext.getCurrentUser().getName(), calEventsFormDBTemp.getSubject(), calEventsFormDBTemp.getBeginDate().toString()};
                calEventLogs.add(LogStr);
                QuartzHolder.deleteQuartzJob("jobPeriodicalInfo_" + calEventsFormDBTemp.getId());
            }

            this.deleteCalReplyByEventID(oldEventIDs);
            this.deleteCalContentByEventId((List)oldEventIDs);
            this.deleteTranEventByEventId((List)oldEventIDs);
            if(AppContext.hasPlugin("project")) {
                this.projectPhaseEventManager.deleteAll(oldEventIDs);
            }

            this.deleteAttachmentByEventID(oldEventIDs);
            if(AppContext.hasPlugin("index")) {
                this.indexManager.delete(oldEventIDs, Integer.valueOf(ApplicationCategoryEnum.calendar.getKey()));
            }

            this.calEventDao.deleteCalEvent(calEventsFormDB);
            this.appLogManager.insertLogs(AppContext.getCurrentUser(), AppLogAction.Calendar_Delete, calEventLogs);
        }

    }

    private int getIntervalDays(Date beginDate, Date endDate) {
        int days = 0;
        Calendar oneCalendar = Calendar.getInstance();
        Calendar twoCalendar = Calendar.getInstance();
        oneCalendar.setTime(beginDate);
        twoCalendar.setTime(endDate);

        while(oneCalendar.before(twoCalendar)) {
            ++days;
            oneCalendar.add(6, 1);
        }

        return days - 1;
    }

    private List<List<Date>> getPeriodicalEventByMonth(CalEvent calEvent, CalEventPeriodicalInfo calEventPeriodicalInfo, String hourStart, String hourEnd, Map<String, Integer> dayMegMap) throws BusinessException {
        List<List<Date>> periodicalDateList = new ArrayList();
        if(calEventPeriodicalInfo.getSwithMonth() == 1) {
            this.getSomeMonthOrYearDayNumber(dayMegMap, hourStart, hourEnd, periodicalDateList, calEvent, calEventPeriodicalInfo, Boolean.TRUE);
        } else {
            this.getSomeMonthSomeWeekNumber(calEvent, calEventPeriodicalInfo, dayMegMap, hourStart, hourEnd, periodicalDateList, Boolean.TRUE);
        }

        return periodicalDateList;
    }

    private List<List<Date>> getPeriodicalEventByYear(CalEvent calEvent, CalEventPeriodicalInfo calEventPeriodicalInfo, String hourStart, String hourEnd, Map<String, Integer> dayMegMap) throws BusinessException {
        List<List<Date>> periodicalDateList = new ArrayList();
        if(calEventPeriodicalInfo.getSwithYear() == 1) {
            this.getSomeMonthOrYearDayNumber(dayMegMap, hourStart, hourEnd, periodicalDateList, calEvent, calEventPeriodicalInfo, Boolean.FALSE);
        } else {
            this.getSomeMonthSomeWeekNumber(calEvent, calEventPeriodicalInfo, dayMegMap, hourStart, hourEnd, periodicalDateList, Boolean.FALSE);
        }

        return periodicalDateList;
    }

    private void getSomeMonthSomeWeekNumber(CalEvent calEvent, CalEventPeriodicalInfo cInfo, Map<String, Integer> dayMegMap, String hourStart, String hourEnd, List<List<Date>> temList, Boolean isMonth) throws BusinessException {
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(calEvent.getBeginDate());
        int numberWeeK = calendar.get(8);
        int lastNumber = numberWeeK;
        int weeK = calendar.get(7);
        Integer endMonth = (Integer)dayMegMap.get("startMonth");
        if(isMonth.booleanValue()) {
            endMonth = Integer.valueOf(12);
        }

        int startMonth = ((Integer)dayMegMap.get("startMonth")).intValue();

        for(int i = ((Integer)dayMegMap.get("startYear")).intValue(); i <= ((Integer)dayMegMap.get("endYear")).intValue(); ++i) {
            if(!String.valueOf(i).equals(DateFormatUtils.format(calEvent.getBeginDate(), "yyyy"))) {
                startMonth = 1;
            }

            for(int j = startMonth; j <= endMonth.intValue(); ++j) {
                Date monthLastDay = null;

                Date curDate;
                do {
                    calendar.clear();
                    calendar.set(1, i);
                    calendar.set(2, j - 1);
                    calendar.set(8, lastNumber);
                    calendar.set(7, weeK);
                    curDate = calendar.getTime();
                    calendar = new GregorianCalendar(i, j, 1);
                    calendar.add(5, -1);
                    int endday = calendar.get(5);

                    try {
                        monthLastDay = DateUtils.parseDate(i + "-" + j + "-" + endday, getAllAndSDateDFormat());
                    } catch (ParseException var21) {
                        logger.error(var21.getLocalizedMessage(), var21);
                    }

                    --lastNumber;
                } while(curDate.after(monthLastDay) && numberWeeK == NumberEnum.lastWeek.getKey());

                lastNumber = numberWeeK;
                if(!DateUtils.isSameDay(curDate, calEvent.getBeginDate()) && !curDate.before(cInfo.getBeginTime()) && (curDate.before(cInfo.getEndTime()) || curDate.equals(cInfo.getEndTime())) && !curDate.after(monthLastDay)) {
                    ArrayList temDates = new ArrayList();

                    try {
                        temDates.add(DateUtils.parseDate(DateFormatUtils.ISO_DATE_FORMAT.format(curDate) + " " + hourStart, getAllAndSDateDFormat()));
                        temDates.add(DateUtils.parseDate(DateFormatUtils.ISO_DATE_FORMAT.format(Datetimes.addDate(curDate, ((Integer)dayMegMap.get("intervalDays")).intValue())) + " " + hourEnd, getAllAndSDateDFormat()));
                    } catch (ParseException var20) {
                        logger.error(var20.getLocalizedMessage(), var20);
                    }

                    temList.add(temDates);
                }
            }
        }

    }

    private void getSomeMonthOrYearDayNumber(Map<String, Integer> dayMegMap, String hourStart, String hourEnd, List<List<Date>> temList, CalEvent calEvent, CalEventPeriodicalInfo cInfo, Boolean isMonth) throws BusinessException {
        Calendar calendar = new GregorianCalendar();
        Integer endMonth = (Integer)dayMegMap.get("startMonth");
        if(isMonth.booleanValue()) {
            endMonth = Integer.valueOf(12);
        }

        int j = ((Integer)dayMegMap.get("startMonth")).intValue();

        for(int i = ((Integer)dayMegMap.get("startYear")).intValue(); i <= ((Integer)dayMegMap.get("endYear")).intValue(); ++i) {
            j = ((Integer)dayMegMap.get("startMonth")).intValue();
            if(i != ((Integer)dayMegMap.get("startYear")).intValue() && isMonth.booleanValue()) {
                j = 1;
            }

            for(; j <= endMonth.intValue(); ++j) {
                try {
                    String curDateStr = i + "-" + j + "-" + dayMegMap.get("messageDay");
                    Date curDate = DateUtils.parseDate(curDateStr, getAllAndSDateDFormat());
                    if(!DateUtils.isSameDay(curDate, calEvent.getBeginDate())) {
                        calendar.clear();
                        calendar.set(1, i);
                        calendar.set(2, j - 1);
                        calendar = new GregorianCalendar(i, j, 1);
                        calendar.add(5, -1);
                        int endday = calendar.get(5);
                        Date monthLastDay = DateUtils.parseDate(i + "-" + j + "-" + endday, getAllAndSDateDFormat());
                        if((curDate.after(cInfo.getBeginTime()) || curDate.equals(cInfo.getBeginTime())) && (curDate.before(cInfo.getEndTime()) || curDate.equals(cInfo.getEndTime())) && !curDate.after(monthLastDay)) {
                            List<Date> temDates = new ArrayList();
                            temDates.add(DateUtils.parseDate(DateFormatUtils.ISO_DATE_FORMAT.format(curDate) + " " + hourStart, getAllAndSDateDFormat()));
                            temDates.add(DateUtils.parseDate(DateFormatUtils.ISO_DATE_FORMAT.format(Datetimes.addDate(curDate, ((Integer)dayMegMap.get("intervalDays")).intValue())) + " " + hourEnd, getAllAndSDateDFormat()));
                            temList.add(temDates);
                        }
                    }
                } catch (ParseException var17) {
                    logger.error(var17.getLocalizedMessage(), var17);
                }
            }
        }

    }

    private List<List<Date>> getPeriodicalEventByDay(CalEvent calEvent, CalEventPeriodicalInfo cInfo, String hourStart, String hourEnd) throws BusinessException {
        String beginTime = hourStart;
        String endTime = hourEnd;
        Date date = cInfo.getBeginTime();
        ArrayList temList = new ArrayList();

        while((date.after(cInfo.getBeginTime()) || date.equals(cInfo.getBeginTime())) && (date.before(cInfo.getEndTime()) || date.equals(cInfo.getEndTime()))) {
            beginTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + beginTime;
            endTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + endTime;

            try {
                if(DateUtils.isSameDay(calEvent.getBeginDate(), DateUtils.parseDate(beginTime, getAllAndSDateDFormat()))) {
                    beginTime = hourStart;
                    endTime = hourEnd;
                    date = Datetimes.addDate(date, cInfo.getDayDate().intValue());
                    continue;
                }

                List<Date> curDates = new ArrayList();
                curDates.add(DateUtils.parseDate(beginTime, getAllAndSDateDFormat()));
                curDates.add(DateUtils.parseDate(endTime, getAllAndSDateDFormat()));
                temList.add(curDates);
            } catch (ParseException var10) {
                logger.error(var10.getLocalizedMessage(), var10);
            }

            beginTime = hourStart;
            endTime = hourEnd;
            date = Datetimes.addDate(date, cInfo.getDayDate().intValue());
        }

        return temList;
    }

    private List<List<Date>> getPeriodicalEventByWeek(CalEvent calEvent, CalEventPeriodicalInfo cInfo, String hourStart, String hourEnd) throws BusinessException {
        String[] dayNames = new String[]{"1", "2", "3", "4", "5", "6", "7"};
        String[] weeks = cInfo.getWeeks().split(",");
        Calendar calendar = Calendar.getInstance();
        List<List<Date>> temList = new ArrayList();
        String beginTime = hourStart;
        String endTime = hourEnd;
        Date date = cInfo.getBeginTime();

        while(!cInfo.getBeginTime().equals(cInfo.getEndTime()) && (date.after(cInfo.getBeginTime()) || date.equals(cInfo.getBeginTime())) && (date.before(cInfo.getEndTime()) || date.equals(cInfo.getEndTime()))) {
            calendar.setTime(date);
            int dayOfWeek = calendar.get(7);
            if(DateUtils.isSameDay(calEvent.getBeginDate(), date)) {
                date = Datetimes.addDate(date, 1);
            } else {
                for(int i = 0; i < weeks.length; ++i) {
                    if(weeks[i].equals(dayNames[dayOfWeek - 1])) {
                        beginTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + beginTime;
                        endTime = DateFormatUtils.ISO_DATE_FORMAT.format(date) + " " + endTime;

                        try {
                            List<Date> curDates = new ArrayList();
                            curDates.add(DateUtils.parseDate(beginTime, getAllAndSDateDFormat()));
                            curDates.add(DateUtils.parseDate(endTime, getAllAndSDateDFormat()));
                            temList.add(curDates);
                        } catch (ParseException var15) {
                            logger.error(var15.getLocalizedMessage(), var15);
                        }

                        beginTime = hourStart;
                        endTime = hourEnd;
                    }
                }

                date = Datetimes.addDate(date, 1);
            }
        }

        return temList;
    }

    private void getPeriodicalEvent(CalEvent calEvent, List<CalEvent> calEvents, Date beginDate, Date endDate, List<Long> eventIDs) throws ParseException, BusinessException {
        try {
            CalEvent cInfoCalEvent = (CalEvent)BeanUtils.cloneBean(calEvent);
            if(DateUtils.isSameDay(calEvent.getBeginDate(), beginDate)) {
                cInfoCalEvent.setId(calEvent.getId());
                cInfoCalEvent.setAttachmentsFlag(calEvent.getAttachmentsFlag());
                cInfoCalEvent.setPeriodicalChildId((Long)null);
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
        } catch (Exception var8) {
            logger.error(var8.getLocalizedMessage(), var8);
        }

    }

    private void initCalEventByHasVal(CalEvent calEvent, Boolean isNew) throws BusinessException {
        if(calEvent.getStates().intValue() == StatesEnum.completed.getKey()) {
            calEvent.setCompleteRate(Float.valueOf(100.0F));
        }

        if(Strings.isNotBlank(calEvent.getReceiveMemberId())) {
            if(calEvent.getIsEntrust().intValue() == 0) {
                calEvent.setEventflag(Integer.valueOf(1));
                calEvent.setEventType(Integer.valueOf(EventSourceEnum.arrangeEvent.getKey()));
            } else {
                calEvent.setEventflag(Integer.valueOf(2));
                calEvent.setEventType(Integer.valueOf(EventSourceEnum.entrustEvent.getKey()));
            }

            if(calEvent.getStates().intValue() == StatesEnum.toBeArranged.getKey()) {
                calEvent.setStates(Integer.valueOf(StatesEnum.hasBeenArranged.getKey()));
            }
        }

        CalEvent calEventOld;
        if(calEvent.getReceiveMemberId() == null && calEvent.getShareType().intValue() == ShareTypeEnum.personal.getKey() && calEvent.getStates().intValue() == StatesEnum.hasBeenArranged.getKey()) {
            calEventOld = this.calEventDao.getCalEvent(calEvent.getId());
            if(calEventOld != null && (calEventOld.getReceiveMemberId() != null || calEventOld.getShareType().intValue() != ShareTypeEnum.personal.getKey())) {
                calEvent.setStates(Integer.valueOf(StatesEnum.toBeArranged.getKey()));
            }
        }

        if(calEvent.getAlarmDate().intValue() < AlarmDateEnum.enum1.getKey() && calEvent.getBeforendAlarm().longValue() < (long)AlarmDateEnum.enum1.getKey()) {
            calEvent.setAlarmFlag(Boolean.FALSE);
        } else {
            calEvent.setAlarmFlag(Boolean.TRUE);
        }

        calEventOld = this.getCalEventById(calEvent.getId(), Boolean.FALSE);
        if(!isNew.booleanValue() && calEventOld != null) {
            calEvent.setCreateDate(calEventOld.getCreateDate());
            calEvent.setUpdateDate(Calendar.getInstance().getTime());
            calEvent.setPeriodicalChildId(calEventOld.getPeriodicalChildId());
            calEvent.setCreateUserId(calEventOld.getCreateUserId());
            calEvent.setAccountID(calEventOld.getAccountID());
        } else {
            calEvent.setCreateDate(Calendar.getInstance().getTime());
            calEvent.setCreateUserId(AppContext.getCurrentUser().getId());
            calEvent.setAccountID(Long.valueOf(AppContext.currentAccountId()));
        }

    }

    private void initCalEventByShareType(Map<String, Object> params, CalEvent calEvent) throws BusinessException {
        Iterator var4 = params.entrySet().iterator();

        while(true) {
            while(true) {
                Entry entry;
                String key;
                String value;
                do {
                    do {
                        Object entryObj;
                        do {
                            if(!var4.hasNext()) {
                                return;
                            }

                            entryObj = var4.next();
                        } while(!(entryObj instanceof Entry));

                        entry = (Entry)entryObj;
                        key = null;
                        value = null;
                        if(entry.getKey() != null && entry.getValue() != null) {
                            key = entry.getKey().toString();
                            value = entry.getValue().toString();
                        }
                    } while(!Strings.isNotBlank(key));
                } while(!Strings.isNotBlank(value));

                if(calEvent.getShareType().intValue() == ShareTypeEnum.departmentOfEvents.getKey() && "shareTargetDep".equals(key)) {
                    calEvent.setShareTarget(value);
                } else if(calEvent.getShareType().intValue() == ShareTypeEnum.departmentOfEvents.getKey() && "tranMemberIdsDep".equals(key)) {
                    calEvent.setTranMemberIds(value);
                } else if((calEvent.getShareType().intValue() == ShareTypeEnum.disclosedToOthers.getKey() || calEvent.getShareType().intValue() == ShareTypeEnum.publicToLearder.getKey()) && "shareTargetOther".equals(key)) {
                    calEvent.setShareTarget(value);
                } else if((calEvent.getShareType().intValue() == ShareTypeEnum.disclosedToOthers.getKey() || calEvent.getShareType().intValue() == ShareTypeEnum.publicToLearder.getKey()) && "tranMemberIdsOther".equals(key)) {
                    calEvent.setTranMemberIds(value);
                } else if(calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey() && "projectID".equals(key) && !"0".equals(value)) {
                    calEvent.setTranMemberIds(value);
                    String projectName = this.getProjectNameByID(calEvent.getTranMemberIds());
                    calEvent.setShareTarget(projectName);
                } else if("other".equals(key)) {
                    if(ResourceUtil.getString("calendar.event.create.person").equals(value)) {
                        calEvent.setEventflag(Integer.valueOf(0));
                        calEvent.setIsEntrust(Integer.valueOf(0));
                        calEvent.setEventType(Integer.valueOf(EventSourceEnum.selfArrange.getKey()));
                    } else if(calEvent.getReceiveMemberId() != null) {
                        calEvent.setReceiveMemberName(entry.getValue().toString());
                    }
                }
            }
        }
    }

    private Boolean initCalEventFromPage(Map<String, Object> params, CalEvent calEvent, CalContent content, CalEventPeriodicalInfo cInfo) throws BusinessException {
        calEvent.setPeriodicalStyle(Integer.valueOf(0));
        if(params.get("swithMonth") != null && Strings.isNotBlank(params.get("swithMonth").toString())) {
            cInfo.setSwithMonth(Integer.parseInt(params.get("swithMonth").toString()));
        }

        if(params.get("calEventID") != null && Strings.isNotBlank(params.get("calEventID").toString())) {
            if(!"-1".equals(params.get("calEventID").toString())) {
                calEvent.setId(Long.valueOf(params.get("calEventID").toString()));
                calEvent.setUpdateDate(Calendar.getInstance().getTime());
            } else {
                calEvent.setIdIfNew();
            }
        }

        if(params.get("swithYear") != null && Strings.isNotBlank(params.get("swithYear").toString())) {
            cInfo.setSwithYear(Integer.parseInt(params.get("swithYear").toString()));
        }

        if(params.get("subject") != null && Strings.isNotBlank(params.get("subject").toString())) {
            calEvent.setSubject(params.get("subject").toString());
        }

        if(params.get("fromId") != null && Strings.isNotBlank(params.get("fromId").toString())) {
            calEvent.setFromId(Long.valueOf(params.get("fromId").toString()));
        }

        if(params.get("fromType") != null && Strings.isNotBlank(params.get("fromType").toString())) {
            calEvent.setFromType(Integer.valueOf(params.get("fromType").toString()));
        }

        if(params.get("isEntrust") != null && Strings.isNotBlank(params.get("isEntrust").toString())) {
            calEvent.setIsEntrust(Integer.valueOf(params.get("isEntrust").toString()));
        }

        if(params.get("shareType") != null && Strings.isNotBlank(params.get("shareType").toString())) {
            calEvent.setShareType(Integer.valueOf(params.get("shareType").toString()));
        }

        if(params.get("calEventType") != null && Strings.isNotBlank(params.get("calEventType").toString())) {
            calEvent.setCalEventType(Integer.valueOf(params.get("calEventType").toString()));
        } else {
            calEvent.setCalEventType(Integer.valueOf(-1));
        }

        if(params.get("beginDate") != null && Strings.isNotBlank(params.get("beginDate").toString()) || params.get("endDate") != null && Strings.isNotBlank(params.get("endDate").toString())) {
            try {
                calEvent.setBeginDate(DateUtils.parseDate(params.get("beginDate").toString(), getAllAndSDateDFormat()));
                calEvent.setEndDate(DateUtils.parseDate(params.get("endDate").toString(), getAllAndSDateDFormat()));
            } catch (ParseException var11) {
                logger.error(var11.getLocalizedMessage(), var11);
            }
        }

        if(params.get("signifyType") != null && Strings.isNotBlank(params.get("signifyType").toString())) {
            Integer signifyType = Integer.valueOf(params.get("signifyType").toString());
            if(signifyType.intValue() <= 1) {
                calEvent.setPriorityType(Integer.valueOf(1));
            } else if(signifyType.intValue() >= 4) {
                calEvent.setPriorityType(Integer.valueOf(3));
            } else {
                calEvent.setPriorityType(Integer.valueOf(2));
            }

            calEvent.setSignifyType(signifyType);
        } else {
            calEvent.setSignifyType(Integer.valueOf(-1));
        }

        if(params.get("states") != null && Strings.isNotBlank(params.get("states").toString())) {
            calEvent.setStates(Integer.valueOf(params.get("states").toString()));
        }

        if(params.get("alarmDate") != null && Strings.isNotBlank(params.get("alarmDate").toString())) {
            calEvent.setAlarmDate(Long.valueOf(params.get("alarmDate").toString()));
        }

        if(params.get("completeRate") != null && Strings.isNotBlank(params.get("completeRate").toString())) {
            calEvent.setCompleteRate(Float.valueOf(params.get("completeRate").toString()));
        }

        if(params.get("beforendAlarm") != null && Strings.isNotBlank(params.get("beforendAlarm").toString())) {
            calEvent.setBeforendAlarm(Long.valueOf(params.get("beforendAlarm").toString()));
        }

        if(params.get("content") != null && Strings.isNotBlank(params.get("content").toString())) {
            content.setCreateDate(Calendar.getInstance().getTime());
            content.setContentType("HTML");
            String contentStr = params.get("content").toString();
            content.setContent(Strings.nobreakSpaceToSpace(contentStr));
        }

        if(params.get("periodicalType") != null && Strings.isNotBlank(params.get("periodicalType").toString()) && !"0".equals(params.get("periodicalType").toString())) {
            cInfo.setPeriodicalType(Integer.valueOf(params.get("periodicalType").toString()));
            calEvent.setPeriodicalStyle(cInfo.getPeriodicalType());
        }

        if(params.get("dayDate") != null && Strings.isNotBlank(params.get("dayDate").toString())) {
            cInfo.setDayDate(Integer.valueOf(params.get("dayDate").toString()));
        }

        if(params.get("dayWeek") != null && Strings.isNotBlank(params.get("dayWeek").toString())) {
            try {
                cInfo.setDayWeek(Integer.valueOf(params.get("dayWeek").toString()));
            } catch (NumberFormatException var10) {
                cInfo.setDayWeek(Integer.valueOf(WeekEnum.valueOfByText(params.get("dayWeek").toString()).getKey()));
            }
        }

        if(params.get("week") != null && Strings.isNotBlank(params.get("week").toString())) {
            try {
                cInfo.setWeek(Integer.valueOf(params.get("week").toString()));
            } catch (NumberFormatException var9) {
                cInfo.setDayWeek(Integer.valueOf(NumberEnum.valueOfByText(params.get("week").toString()).getKey()));
            }
        }

        if(params.get("month") != null && Strings.isNotBlank(params.get("month").toString())) {
            cInfo.setMonth(Integer.valueOf(params.get("month").toString()));
        }

        if(params.get("weeks") != null && Strings.isNotBlank(params.get("weeks").toString())) {
            cInfo.setWeeks(params.get("weeks").toString());
        }

        if(params.get("periodicalChildId") != null && Strings.isNotBlank(params.get("periodicalChildId").toString())) {
            calEvent.setPeriodicalChildId(Long.valueOf(params.get("periodicalChildId").toString()));
        }

        if(params.get("beginTime") != null && Strings.isNotBlank(params.get("beginTime").toString()) || params.get("endTime") != null && Strings.isNotBlank(params.get("endTime").toString())) {
            try {
                cInfo.setBeginTime(DateUtils.parseDate(params.get("beginTime").toString(), getAllAndSDateDFormat()));
                if(!"1".equals(params.get("endTime").toString())) {
                    Date endTime = DateUtils.parseDate(params.get("endTime").toString(), getAllAndSDateDFormat());
                    Date temp1 = DateUtils.addDays(endTime, 1);
                    Date temp2 = DateUtils.addSeconds(temp1, -1);
                    cInfo.setEndTime(temp2);
                }
            } catch (ParseException var8) {
                logger.error(var8.getLocalizedMessage(), var8);
            }
        }

        if(params.get("realEstimateTime") != null && Strings.isNotBlank(params.get("realEstimateTime").toString())) {
            calEvent.setRealEstimateTime(Float.valueOf(params.get("realEstimateTime").toString()));
        }

        if(params.get("workType") != null && Strings.isNotBlank(params.get("workType").toString())) {
            calEvent.setWorkType(Integer.valueOf(params.get("workType").toString()));
        }

        if(params.get("otherID") != null && Strings.isNotBlank(params.get("otherID").toString())) {
            calEvent.setReceiveMemberId(params.get("otherID").toString());
        }

        return params.get("calEventID") != null && Strings.isNotBlank(params.get("calEventID").toString()) && "-1".equals(params.get("calEventID").toString())?Boolean.TRUE:Boolean.FALSE;
    }

    public void deleteCalEvent(String idStr, String periodicalStyle) throws BusinessException {
        List<Long> ids = CommonTools.parseTypeAndIdStr2Ids(idStr);
        if(CollectionUtils.isEmpty((Collection)ids)) {
            throw new BusinessException("CalEventManagerImpl deleteCalEvent ids is null");
        } else {
            List<CalEvent> calEvents = new ArrayList();
            List<String[]> calEventLogs = new ArrayList();
            CalEventPeriodicalInfo oldCalEventPeriodicalInfo = null;
            List<Long> periodicalChildIdsList = new ArrayList();
            Iterator var9 = ((List)ids).iterator();

            while(var9.hasNext()) {
                Long id = (Long)var9.next();
                CalEvent calEvent = this.getCalEventById(id, Boolean.FALSE);
                if(calEvent == null) {
                    throw new BusinessException(ResourceUtil.getString("calendar.event.create.had.delete"));
                }

                Long periodicalChildId = calEvent.getPeriodicalChildId() == null?id:calEvent.getPeriodicalChildId();
                if(calEvent.getPeriodicalStyle().intValue() != 0) {
                    oldCalEventPeriodicalInfo = this.calEventPeriodicalInfoManager.getPeriodicalEventBycalEventID(periodicalChildId);
                }

                List<CalEvent> temCalEvents = this.calEventDao.getAllCalEvent(calEvent, Boolean.FALSE);
                int allSize = this.calEventDao.getAllCalEvent(calEvent, Boolean.TRUE).size();
                if(((List)ids).size() == 1 && "2".equals(periodicalStyle)) {
                    Iterator var15 = temCalEvents.iterator();

                    while(var15.hasNext()) {
                        CalEvent temCalEvent = (CalEvent)var15.next();
                        periodicalChildIdsList.add(temCalEvent.getId());
                        String[] LogStr = new String[]{AppContext.getCurrentUser().getName(), temCalEvent.getSubject(), temCalEvent.getBeginDate().toString()};
                        calEventLogs.add(LogStr);
                    }

                    calEvents.addAll(temCalEvents);
                    if(oldCalEventPeriodicalInfo != null) {
                        if(allSize <= temCalEvents.size()) {
                            this.calEventPeriodicalInfoManager.deleteByEventId(periodicalChildId);
                        } else {
                            oldCalEventPeriodicalInfo.setEndTime(Datetimes.addDate(calEvent.getBeginDate(), -1));
                            this.calEventPeriodicalInfoManager.updateCalEventPeriodicalInfo(oldCalEventPeriodicalInfo);
                        }
                    }
                } else {
                    calEvents.add(calEvent);
                    String[] LogStr = new String[]{AppContext.getCurrentUser().getName(), calEvent.getSubject(), calEvent.getBeginDate().toString()};
                    calEventLogs.add(LogStr);
                    if(calEvent.getPeriodicalStyle().intValue() != 0 && oldCalEventPeriodicalInfo != null && allSize <= temCalEvents.size()) {
                        this.calEventPeriodicalInfoManager.deleteByEventId(periodicalChildId);
                    }
                }
            }

            if(CollectionUtils.isNotEmpty(periodicalChildIdsList)) {
                ids = periodicalChildIdsList;
            }

            this.deleteCalReplyByEventID((List)ids);
            this.deleteCalContentByEventId((List)ids);
            this.deleteTranEventByEventId((List)ids);
            this.deleteAttachmentByEventID((List)ids);
            if(AppContext.hasPlugin("project")) {
                this.projectPhaseEventManager.deleteAll((List)ids);
            }

            this.appLogManager.insertLogs(AppContext.getCurrentUser(), AppLogAction.Calendar_Delete, calEventLogs);
            if(AppContext.hasPlugin("index")) {
                this.indexManager.delete((List)ids, Integer.valueOf(ApplicationCategoryEnum.calendar.getKey()));
            }

            this.deleteCalEventByIds(calEvents);
        }
    }

    public void saveCalEventState(CalEvent calEvent) throws BusinessException {
        CalEvent curCalEvent = this.getCalEventById(calEvent.getId(), Boolean.FALSE);
        CalEvent oldCalEvent = null;

        try {
            oldCalEvent = (CalEvent)BeanUtils.cloneBean(curCalEvent);
        } catch (Exception var5) {
            logger.error(var5.getLocalizedMessage(), var5);
        }

        curCalEvent.setStates(calEvent.getStates());
        curCalEvent.setCompleteRate(calEvent.getCompleteRate());
        curCalEvent.setRealEstimateTime(calEvent.getRealEstimateTime());
        this.save(curCalEvent, oldCalEvent);
    }

    public void saveEntrustCalEvent(List<CalEvent> calEvents) throws BusinessException {
        if(CollectionUtils.isNotEmpty(calEvents)) {
            int i = 0;

            for(int j = calEvents.size(); i < j; ++i) {
                CalEvent calEvent = this.getCalEventById(((CalEvent)calEvents.get(i)).getId(), Boolean.FALSE);
                CalEvent oldCalEvent = null;

                try {
                    oldCalEvent = (CalEvent)BeanUtils.cloneBean(calEvent);
                } catch (Exception var7) {
                    logger.error(var7.getLocalizedMessage(), var7);
                }

                if(calEvent != null) {
                    calEvent.setEventflag(Integer.valueOf(2));
                    calEvent.setEventType(Integer.valueOf(EventSourceEnum.entrustEvent.getKey()));
                    calEvent.setReceiveMemberName(((CalEvent)calEvents.get(j - 1)).getReceiveMemberName());
                    calEvent.setReceiveMemberId(((CalEvent)calEvents.get(j - 1)).getReceiveMemberId());
                    if(calEvent.getStates().intValue() == StatesEnum.toBeArranged.getKey()) {
                        calEvent.setStates(Integer.valueOf(StatesEnum.hasBeenArranged.getKey()));
                    }

                    calEvent.setIsEntrust(Integer.valueOf(1));
                    this.saveCalEventTOEvent(calEvent, oldCalEvent);
                    this.deleteTranEventByEventId(calEvent.getId());
                    this.save(calEvent, oldCalEvent);
                    this.saveTranEvents(calEvent);
                }
            }
        }

    }

    public void findCalEventState(String id, String isNew) throws BusinessException {
        CalEventInfoBO cBo = new CalEventInfoBO();
        CalEvent calEvent = new CalEvent();
        Long curUserId = AppContext.getCurrentUser().getId();
        CalEventPeriodicalInfo cinInfo = new CalEventPeriodicalInfo();
        String[] params = id.split("/");
        if(Strings.isNotBlank(params[12])) {
            if(Strings.isNotBlank(isNew) && isNew.equals("0")) {
                cBo.setIsNew(isNew);
            } else if(Strings.isNotBlank(isNew) && isNew.equals(curUserId.toString())) {
                cBo.setIsNew(params[12]);
            } else {
                cBo.setIsNew("1");
            }
        }

        if(Strings.isNotBlank(params[13])) {
            long eventID = Long.parseLong(params[13]);
            calEvent = this.calEventDao.getCalEvent(Long.valueOf(eventID));
            if(calEvent == null) {
                calEvent = new CalEvent();
                calEvent.setId(Long.valueOf(eventID));
            }
        }

        CalEventPeriodicalInfo oldInfo = this.getPeriodicalInfoByCalEventId(calEvent.getPeriodicalChildId() == null?calEvent.getId():calEvent.getPeriodicalChildId());
        Date beginDateFirst = null;
        Date beginDate = null;
        Date endDate = null;

        try {
            if(oldInfo == null && calEvent.getId().longValue() != -1L && "0".equals(cBo.getIsNew())) {
                cBo.setIsNew("1");
            }

            beginDateFirst = DateUtils.parseDate(params[15], getAllAndSDateDFormat());
            beginDate = DateUtils.parseDate(params[15], getAllAndSDateDFormat());
            endDate = DateUtils.parseDate(params[16], getAllAndSDateDFormat());
        } catch (ParseException var13) {
            beginDateFirst = (new GregorianCalendar()).getTime();
        }

        AppContext.putRequestContext("beginDateFirst", beginDateFirst);
        AppContext.putRequestContext("beginDate", beginDate);
        AppContext.putRequestContext("endDate", endDate);
        this.toNewCalEventState(cBo, calEvent, cinInfo, params);
        cBo.setCalEvent(calEvent);
        cBo.setCalEventPeriodicalInfo(cinInfo);
        if(WeekEnum.valueOf(cinInfo.getDayWeek().intValue()) != null) {
            AppContext.putRequestContext("dayWeek", WeekEnum.valueOf(cinInfo.getDayWeek().intValue()).getText());
        }

        if(NumberEnum.valueOf(cinInfo.getWeek().intValue()) != null) {
            AppContext.putRequestContext("numberWeek", NumberEnum.valueOf(cinInfo.getWeek().intValue()).getText());
        }

        boolean canUpdateWorkType = true;
        if(this.isReceiveMember(String.valueOf(AppContext.currentUserId()), calEvent.getId()) && calEvent.getCreateUserId().longValue() != AppContext.currentUserId()) {
            canUpdateWorkType = false;
        }

        AppContext.putRequestContext("calEventInfoBO", cBo);
        AppContext.putRequestContext("canUpdateWorkType", Boolean.valueOf(canUpdateWorkType));
    }

    private Map<String, Object> getCalEventViewDate() throws BusinessException {
        HttpServletRequest request = AppContext.getRawRequest();
        String beginTime = this.getBeginTime();
        AppContext.putRequestContext("iniHour", beginTime);
        String type = request.getParameter("type");
        String curTab = request.getParameter("curTab");
        String curDate = request.getParameter("curDate");
        String selectedDate = request.getParameter("selectedDate");
        String curDay = request.getParameter("curDay");
        if(type != null && !"week".equals(type)) {
            AppContext.putRequestContext("type", type);
        } else if(curTab == null || !"calEventView".equals(curTab) && !"timeArrange".equals(curTab) && !"relateMember".equals(curTab)) {
            AppContext.putRequestContext("type", "week");
        } else if(Strings.isNotBlank(curDate)) {
            type = "day";
            AppContext.putRequestContext("type", type);
            selectedDate = curDate;
            curDay = curDate;
        } else {
            AppContext.putRequestContext("type", "month");
        }

        Map<String, Object> map = new HashMap();
        StringBuilder beginDateStr = new StringBuilder();
        StringBuilder endDateStr = new StringBuilder();
        if(Strings.isBlank(selectedDate)) {
            Calendar calendar = Calendar.getInstance();
            AppContext.putRequestContext("day", Integer.valueOf(calendar.get(5)));
            AppContext.putRequestContext("month", Integer.valueOf(calendar.get(2)));
            AppContext.putRequestContext("year", Integer.valueOf(calendar.get(1)));
            if(curTab == null || !"calEventView".equals(curTab) && !"timeArrange".equals(curTab)) {
                calendar.setFirstDayOfWeek(2);
                calendar.set(7, 2);
                beginDateStr.append(DateFormatUtils.format(calendar.getTime(), getAllAndSDateDFormat()[0]));
                endDateStr.append(DateFormatUtils.format(Datetimes.addDate(calendar.getTime(), 6), getAllAndSDateDFormat()[0]));
            } else {
                calendar.set(5, 1);
                beginDateStr.append(DateFormatUtils.format(calendar.getTime(), getAllAndSDateDFormat()[0]));
                calendar.add(2, 1);
                calendar.add(5, -1);
                endDateStr.append(DateFormatUtils.format(calendar.getTime(), getAllAndSDateDFormat()[0]));
            }
        } else {
            String[] dateArr = selectedDate.split("-");
            AppContext.putRequestContext("day", dateArr[2]);
            AppContext.putRequestContext("month", String.valueOf(Integer.parseInt(dateArr[1]) - 1));
            AppContext.putRequestContext("year", dateArr[0]);
        }

        if(type != null && "day".equals(type)) {
            beginDateStr.append(curDay);
            endDateStr.append(curDay);
        } else if(type != null && "month".equals(type) && (curTab == null || !"calEventView".equals(curTab))) {
            beginDateStr.append(request.getParameter("monthStart"));
            endDateStr.append(request.getParameter("monthEnd"));
        } else if(type != null && "week".equals(type)) {
            beginDateStr.append(request.getParameter("weekStart"));
            endDateStr.append(request.getParameter("weekEnd"));
        }

        try {
            map.put("beginDate", DateUtils.parseDate(beginDateStr.toString(), getAllAndSDateDFormat()));
            map.put("endDate", DateUtils.addSeconds(DateUtils.addDays(DateUtils.parseDate(endDateStr.toString(), getAllAndSDateDFormat()), 1), -1));
        } catch (ParseException var12) {
            logger.error(var12.getLocalizedMessage(), var12);
        }

        if(Strings.isNotBlank(request.getParameter("relateMemberID"))) {
            curTab = "relateMember";
            Long relateMemberID = Long.valueOf(request.getParameter("relateMemberID"));
            map.put("currentUserID", relateMemberID);
            request.setAttribute("relateMemberName", this.orgManager.getMemberById(relateMemberID).getName());
            request.setAttribute("relateMemberID", relateMemberID);
            request.setAttribute("curMemberID", Long.valueOf(AppContext.currentUserId()));
            request.setAttribute("curDate", curDate);
        } else {
            map.put("currentUserID", Long.valueOf(AppContext.currentUserId()));
        }

        map.put("curTab", curTab);
        if(!"relateMember".equals(curTab)) {
            map.remove("curTab");
        }

        return map;
    }

    public List<TimeCompare> findArrangeTimeDate(Map<String, Object> curMap) throws BusinessException {
        HttpServletRequest request = AppContext.getRawRequest();
        Map<String, Object> map = this.getMap((Boolean)curMap.get("isTimeLine"));
        List<Plan> plans = null;
        List<TaskInfoBO> taskInfos = null;
        List<Meeting> meetings = null;
        List<CalEvent> calEvents = null;
        List<ColSummaryVO> colSummaryVOs = null;
        List<EdocSummaryModel> edocList = null;
        List<TimeCompare> compareEvent = new ArrayList();
        List<CalEvent> tempList = new ArrayList();
        if((request.getParameter("curTab") == null || !"calEventView".equals(request.getParameter("curTab")) || request.getParameter("type") != null) && (request.getParameter("source") == null || !"arrangeMonthTimeForView".equals(request.getParameter("source")))) {
            Long currentUserID = (Long)map.get("currentUserID");
            Date endDate = (Date)map.get("endDate");
            Date beginDate = (Date)map.get("beginDate");

            try {
                plans = this.getAllOtherPlan(map);
                taskInfos = this.getAllOtherTask(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
                meetings = this.getAllOtherMeeting(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
                calEvents = this.getAllCaleventView(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
                colSummaryVOs = this.getAllOtherCollaboration(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
                edocList = this.getAllOtherEdoc(this.getViewORTimeLineMap(beginDate, endDate, currentUserID));
            } catch (Exception var16) {
                logger.error(var16.getLocalizedMessage(), var16);
            }
        } else {
            calEvents = this.getAllCaleventView(map);
            if(Strings.isNotEmpty(curMap.get("source").toString()) && calEvents != null) {
                Iterator var13 = calEvents.iterator();

                while(var13.hasNext()) {
                    CalEvent cal = (CalEvent)var13.next();
                    if(cal.getStates().intValue() == 4) {
                        tempList.add(cal);
                    }
                }
            }

            calEvents.removeAll(tempList);
        }

        curMap.put("calEvents", calEvents);
        this.getTimeCompareSort(plans, taskInfos, meetings, curMap, colSummaryVOs, edocList, compareEvent);
        AppContext.putRequestContext("calevents", JSONUtil.toJSONString(compareEvent));
        return compareEvent;
    }

    private Map<String, Object> getViewORTimeLineMap(Date beginDate, Date endDate, Long curUserID) {
        Map<String, Object> map = new HashMap();
        map.put("beginDate", beginDate);
        map.put("endDate", endDate);
        map.put("currentUserID", curUserID);
        return map;
    }

    private void saveCalEventTOEvent(CalEvent calEvent, CalEvent oldCalEvent) throws BusinessException {
        HashSet<V3xOrgMember> membersSet = this.calendarNotifier.getMembers(calEvent, Boolean.TRUE);
        List<V3xOrgMember> members = new ArrayList();
        members.addAll(membersSet);
        CalEventTOEvent calEventTOEvent;
        if(oldCalEvent != null) {
            if(Strings.isNotBlank(calEvent.getReceiveMemberId())) {
                calEventTOEvent = new CalEventTOEvent(this);
                List<Long> curMemberList = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId());
                List<Long> oldMemberList = CommonTools.parseTypeAndIdStr2Ids(oldCalEvent.getReceiveMemberId());
                calEventTOEvent.setIsforUpdate(true);
                calEventTOEvent.setCurMemberList(curMemberList);
                calEventTOEvent.setOldMemberList(oldMemberList);
                calEventTOEvent.setCalEvent(calEvent);
                EventDispatcher.fireEvent(calEventTOEvent);
            }

            if(calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
                HashSet<V3xOrgMember> oldRelatedUserSet = this.calendarNotifier.getMembers(oldCalEvent, Boolean.TRUE);
                HashSet<V3xOrgMember> newRelatedUserSet = this.calendarNotifier.getMembers(calEvent, Boolean.TRUE);
                List<V3xOrgMember> oldRelatedUser = new ArrayList();
                oldRelatedUser.addAll(oldRelatedUserSet);
                List<V3xOrgMember> newRelatedUser = new ArrayList();
                newRelatedUser.addAll(newRelatedUserSet);
                calEventTOEvent = new CalEventTOEvent(this);
                calEventTOEvent.setIsforUpdate(true);
                calEventTOEvent.setNewRelatedUser(newRelatedUser);
                calEventTOEvent.setOldRelatedUser(oldRelatedUser);
                calEventTOEvent.setCalEvent(calEvent);
                calEventTOEvent.setIsArrangeAndShare("yes");
                EventDispatcher.fireEvent(calEventTOEvent);
            }
        } else {
            if(Strings.isNotBlank(calEvent.getReceiveMemberId())) {
                calEventTOEvent = new CalEventTOEvent(this);
                calEventTOEvent.setCalEvent(calEvent);
                EventDispatcher.fireEvent(calEventTOEvent);
            }

            if(calEvent.getShareType().intValue() != ShareTypeEnum.personal.getKey()) {
                calEventTOEvent = new CalEventTOEvent(this);
                calEventTOEvent.setMembers(members);
                calEventTOEvent.setCalEvent(calEvent);
                calEventTOEvent.setIsArrangeAndShare("yes");
                EventDispatcher.fireEvent(calEventTOEvent);
            }
        }

    }

    public void saveCalEventEntrust(String id) throws BusinessException {
        List<Long> ids = CommonTools.parseTypeAndIdStr2Ids(id);
        List<CalEvent> calEvents = this.getCalEventByIds(ids);
        AppContext.putRequestContext("calEvents", calEvents);
    }

    public void findCalEventViewData() throws BusinessException {
        Map<String, Object> map = this.getMap(Boolean.FALSE);
        List<CalEvent> calEvents = this.getAllCaleventView(map);
        List<TimeCompare> compareEvent = new ArrayList();
        this.getCalEventView(calEvents, compareEvent, Boolean.TRUE);
        AppContext.putRequestContext("calevents", JSONUtil.toJSONString(compareEvent));
        if(Strings.isNotBlank(AppContext.getRawRequest().getParameter("relateMemberID"))) {
            AppContext.putRequestContext("arrangePage", "calEventView4RelateMember");
        } else {
            AppContext.putRequestContext("arrangePage", "calEventView");
        }

    }

    public void findCalEventViewDataforLeader(String targetId) throws BusinessException {
        Map<String, Object> map = this.getMap(Boolean.FALSE);
        map.put("userId", targetId);
        List<CalEvent> calEvents = this.getAllCaleventViewforleader(map);
        List<TimeCompare> compareEvent = new ArrayList();
        this.getCalEventView(calEvents, compareEvent, Boolean.TRUE);
        AppContext.putRequestContext("calevents", JSONUtil.toJSONString(compareEvent));
        AppContext.putRequestContext("arrangePage", "calEventView");
    }

    public String toSureIsRightDate(CalEventPeriodicalInfo calEventPeriodicalInfo) throws BusinessException {
        if(calEventPeriodicalInfo.getPeriodicalType().intValue() != PeriodicalEnum.dayCycle.getKey() && calEventPeriodicalInfo.getPeriodicalType().intValue() != PeriodicalEnum.weekCycle.getKey()) {
            if((calEventPeriodicalInfo.getPeriodicalType().intValue() == PeriodicalEnum.monthCycle.getKey() || calEventPeriodicalInfo.getPeriodicalType().intValue() == PeriodicalEnum.yearCycle.getKey()) && Datetimes.addYear(calEventPeriodicalInfo.getBeginTime(), 10).before(calEventPeriodicalInfo.getEndTime())) {
                return ResourceUtil.getString("calendar.event.priorityType.month.tip");
            }
        } else if(Datetimes.addYear(calEventPeriodicalInfo.getBeginTime(), 1).before(calEventPeriodicalInfo.getEndTime())) {
            return ResourceUtil.getString("calendar.event.priorityType.day.tip");
        }

        return "";
    }

    public FlipInfo getStatisticCalEventInfoBOF8(FlipInfo flipInfo, Map<String, Object> map) throws BusinessException {
        Long userID = AppContext.getCurrentUser().getId();
        if(map.get("createUserId") != null && Strings.isNotBlank(map.get("createUserId").toString())) {
            userID = Long.valueOf(map.get("createUserId").toString());
        }

        map.put("createUserId", userID);
        Date beginDate = Calendar.getInstance().getTime();

        try {
            if(map.get("beginDate") != null && Strings.isNotBlank(map.get("beginDate").toString())) {
                beginDate = DateUtils.parseDate(map.get("beginDate").toString(), getAllAndSDateDFormat());
            }
        } catch (ParseException var6) {
            logger.error(var6.getLocalizedMessage(), var6);
        }

        map.put("beginDate", beginDate);
        map.put("endDate", Datetimes.addDate(beginDate, 1));
        List<CalEventInfoBO> calEventInfoBOs = this.getCalEventInfoBO(this.calEventDao.getStatisticCalEventInfoBOF8(flipInfo, map).getData());
        flipInfo.setData(calEventInfoBOs);
        return flipInfo;
    }

    public Integer findIndexResumeCount(Date beginDate, Date endDate) throws BusinessException {
        return this.calEventDao.findIndexResumeCount(beginDate, endDate);
    }

    public List<Long> findIndexResumeIDList(Date beginDate, Date endDate, Integer firstRow, Integer pageSize) throws BusinessException {
        FlipInfo fi = new FlipInfo();
        fi.setPage(firstRow.intValue());
        fi.setSize(pageSize.intValue());
        return this.calEventDao.findIndexResumeIDList(beginDate, endDate, fi);
    }

    public Map<String, Object> findSourceInfo(Long arg0) throws BusinessException {
        return null;
    }

    public Integer getAppEnumKey() {
        return Integer.valueOf(ApplicationCategoryEnum.calendar.getKey());
    }

    public IndexInfo getIndexInfo(Long calEventID) throws BusinessException {
        CalEvent calEvent = this.calEventDao.getCalEvent(calEventID);
        if(calEvent == null) {
            return null;
        } else {
            CalContent calContent = this.calContentManager.getCalContentByEventId(calEventID);
            List<CalReply> replys = this.calReplyManager.getReplyListByEventId(calEventID);
            IndexInfo indexInfo = new IndexInfo();
            indexInfo.setTitle(calEvent.getSubject());
            indexInfo.setStartMemberId(calEvent.getCreateUserId());
            indexInfo.setHasAttachment(calEvent.getAttachmentsFlag().booleanValue());
            StringBuilder replyContent = new StringBuilder();
            if(CollectionUtils.isNotEmpty(replys)) {
                Iterator var8 = replys.iterator();

                while(var8.hasNext()) {
                    CalReply reply = (CalReply)var8.next();
                    replyContent.append(Functions.showMemberName(reply.getReplyUserId()));
                    replyContent.append(reply.getReplyInfo());
                }
            }

            indexInfo.setComment(replyContent.toString());
            indexInfo.setStartTime(calEvent.getBeginDate());
            indexInfo.setEndTime(calEvent.getEndDate());
            StringBuilder peiorityType = new StringBuilder("calendar.event.priorityType.");
            peiorityType.append(calEvent.getPriorityType());
            indexInfo.setPriority(ResourceUtil.getString(peiorityType.toString()));
            indexInfo.setState(StatesEnum.findByKey(calEvent.getStates().intValue()).getText());
            List<String> personalCalEvent = new ArrayList();
            List<String> departmentCalEvent = new ArrayList();
            List<String> projectCalEvent = new ArrayList();
            if(ShareTypeEnum.valueOf(calEvent.getShareType().intValue()) != ShareTypeEnum.personal) {
                List<V3xOrgMember> curMembers = new ArrayList();
                curMembers.addAll(this.calendarNotifier.getMembers(calEvent, Boolean.TRUE));
                List<String> curList = new ArrayList();
                if(CollectionUtils.isNotEmpty(curMembers)) {
                    Iterator var14 = curMembers.iterator();

                    while(var14.hasNext()) {
                        V3xOrgMember curMember = (V3xOrgMember)var14.next();
                        curList.add(curMember.getId().toString());
                    }

                    if(calEvent.getShareType().intValue() == ShareTypeEnum.departmentOfEvents.getKey()) {
                        departmentCalEvent.addAll(curList);
                    } else if(calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey()) {
                        projectCalEvent.addAll(curList);
                    } else {
                        personalCalEvent.addAll(curList);
                    }
                }
            }

            List<Long> receiveMemberIds = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId());
            if(CollectionUtils.isNotEmpty(receiveMemberIds)) {
                Iterator var23 = receiveMemberIds.iterator();

                while(var23.hasNext()) {
                    Long receiveMemberId = (Long)var23.next();
                    String receiveMemberIdStr = String.valueOf(receiveMemberId);
                    if(!personalCalEvent.contains(receiveMemberIdStr)) {
                        personalCalEvent.add(receiveMemberIdStr);
                    }
                }
            }

            AuthorizationInfo authorizationInfo = new AuthorizationInfo();
            personalCalEvent.add(String.valueOf(calEvent.getCreateUserId()));
            if(CollectionUtils.isNotEmpty(personalCalEvent)) {
                authorizationInfo.setOwner(personalCalEvent);
            }

            authorizationInfo.setDepartment(departmentCalEvent);
            authorizationInfo.setProject(projectCalEvent);
            indexInfo.setAuthorizationInfo(authorizationInfo);
            StringBuilder calContentStr = new StringBuilder();
            calContentStr.append(calContent != null?calContent.getContent():"");

            try {
                if(Strings.isNotBlank(calEvent.getTranMemberIds()) && calEvent.getShareType().intValue() == ShareTypeEnum.projectOfEvent.getKey()) {
                    long projectID = Long.parseLong(calEvent.getTranMemberIds());
                    if(AppContext.hasPlugin("project")) {
                        ProjectSummary project = this.projectManager.getProject(projectID);
                        if(project != null) {
                            calContentStr.append(project.getProjectName());
                        }
                    }
                }
            } catch (Exception var17) {
                logger.error(var17.getLocalizedMessage(), var17);
            }

            indexInfo.setContent(calContentStr.toString());
            indexInfo.setContentType(13);
            indexInfo.setAuthor(Functions.showMemberName(calEvent.getCreateUserId()));
            indexInfo.setCreateDate(calEvent.getCreateDate());
            indexInfo.setAppType(ApplicationCategoryEnum.calendar);
            indexInfo.setEntityID(calEvent.getId().longValue());
            IndexUtil.convertToAccessory(indexInfo);
            return indexInfo;
        }
    }

    public String isOnePerson(String id) throws BusinessException {
        CalEvent calEvent = this.getCalEventById(Long.valueOf(id), Boolean.FALSE);
        return AppContext.getCurrentUser().getId().equals(calEvent.getCreateUserId())?"yes":"no";
    }

    public List<CalEvent> iSearch(ConditionModel cModel) throws BusinessException {
        String title = cModel.getTitle();
        Date beginDate = cModel.getBeginDate();
        Date endDate = cModel.getEndDate();
        Long fromUserId = cModel.getFromUserId();
        List<Long> projectSummaryIDs = new ArrayList();
        this.getAllProjectIDByUser(projectSummaryIDs);
        return this.calEventDao.getISearch(fromUserId, beginDate, endDate, title, projectSummaryIDs);
    }

    public void initStatisticsDate() throws BusinessException {
        List<CtpEnumItem> calEventSignifys = this.enumManagerNew.getEnumItemByProCode(EnumNameEnum.cal_event_signifyType);
        List<CalEvent> calEvents = new ArrayList();
        int i = 0;
        int calEventSignify = calEventSignifys.size();

        for(int j = calEventSignify; i < j; ++i) {
            CalEvent calEvent = new CalEvent();
            CtpEnumItem ctpEnumItem = (CtpEnumItem)calEventSignifys.get(i);
            calEvent.setReceiveMemberName(this.enumManagerNew.getEnumItemLabel(EnumNameEnum.cal_event_signifyType, ctpEnumItem.getEnumvalue()));
            calEvent.setReceiveMemberId(ctpEnumItem.getEnumvalue());
            calEvents.add(calEvent);
        }

        AppContext.putRequestContext("calEvents", calEvents);
    }

    public String isHasDeleteByType(String id, String type) throws BusinessException {
        long idLong = Long.parseLong(id);
        if(TemplateEventEnum.CALEVENT.equals(type)) {
            CalEvent calEvent = this.calEventDao.getCalEvent(Long.valueOf(idLong));
            if(calEvent == null) {
                if(AppContext.getCurrentUser() != null && this.orgManager.getMemberById(Long.valueOf(AppContext.currentUserId())) != null) {
                    return ResourceUtil.getString("calendar.event.create.had.delete");
                }
            } else {
                String curUserID = String.valueOf(AppContext.currentUserId());
                HashSet<V3xOrgMember> v3xOrgMembers = this.calendarNotifier.getMembers(calEvent, Boolean.FALSE);
                V3xOrgMember curMember = this.orgManager.getMemberById(Long.valueOf(curUserID));
                Boolean isTranMemberId = Boolean.valueOf(v3xOrgMembers.contains(curMember));
                if(!curUserID.equals(calEvent.getCreateUserId().toString()) && calEvent.getReceiveMemberId() != null && !calEvent.getReceiveMemberId().contains(curUserID) && !isTranMemberId.booleanValue()) {
                    return ResourceUtil.getString("calendar.event.create.have.no.power.to.hand", Functions.showMemberName(calEvent.getCreateUserId()));
                }

                Boolean isCreateUser = Boolean.valueOf(curUserID.equals(calEvent.getCreateUserId().toString()));
                Boolean isReceiveMember = Boolean.valueOf(calEvent.getReceiveMemberId() == null?Boolean.FALSE.booleanValue():calEvent.getReceiveMemberId().contains(curUserID));
                if(!isCreateUser.booleanValue() && !isReceiveMember.booleanValue() && !isTranMemberId.booleanValue()) {
                    return ResourceUtil.getString("calendar.event.create.have.no.power.to.hand");
                }
            }
        } else if(TemplateEventEnum.TASK.equals(type) && AppContext.hasPlugin("taskmanage")) {
            TaskInfo taskInfo = this.taskInfoManager.selectTaskInfoByTaskId(Long.valueOf(idLong));
            if(taskInfo == null) {
                return ResourceUtil.getString("taskmanage.task_deleted");
            }

            List<Integer> purviewList = TaskPurviewUtil.getCurrentUserTaskPurview(taskInfo, this.projectQueryManager, this.taskInfoDao, taskInfo.getProjectId(), Long.valueOf(AppContext.currentUserId()));
            if(!purviewList.contains(Integer.valueOf(TaskPurviewEnums.View.key()))) {
                return ResourceUtil.getString("taskmanage.alert.no_auth_view_task");
            }
        } else if(TemplateEventEnum.PLAN.equals(type) && AppContext.hasPlugin(TemplateEventEnum.PLAN)) {
            return this.planManager.checkPotent(id);
        }

        return "";
    }

    public String entrustMeg(String ids) throws BusinessException {
        List<Long> idList = CommonTools.parseTypeAndIdStr2Ids(ids);
        List<CalEvent> calEvents = this.getCalEventByIds(idList);
        Iterator var5 = calEvents.iterator();

        while(var5.hasNext()) {
            CalEvent calEvent = (CalEvent)var5.next();
            if(calEvent.getStates().intValue() == StatesEnum.completed.getKey()) {
                return ResourceUtil.getString("calendar.event.list.cancel.event.authorized.end");
            }

            if(!calEvent.getCreateUserId().equals(Long.valueOf(AppContext.currentUserId()))) {
                return ResourceUtil.getString("calendar.event.list.cancel.event.authorized.other");
            }
        }

        return "";
    }

    public String getAttsByCalId(Long calEventID) {
        return this.attachmentManager.getAttListJSON(calEventID);
    }

    public Boolean chackReportAuthReportIdAndViewId(Long userID, Long key) throws BusinessException {
        return this.reportAuthManager.chackReportAuthReportIdAndViewId(userID, ReportsEnum.EventStatistics.getKey());
    }

    public List<CalEvent> getCalEventByPlanId(Long PlanId) throws BusinessException {
        List<CalEvent> result = this.calEventDao.getCalEventByPlanId(PlanId);
        return result;
    }

    public FlipInfo getCalEventByRecordId(FlipInfo fi, String params) throws BusinessException {
        new FlipInfo();
        long calEventId = Long.parseLong(params);
        fi.setSize(1000);
        FlipInfo calEvents = this.calEventDao.getCalEventByRecordIds(fi, Long.valueOf(calEventId));
        List<CalEventInfoBO> calEventInfoBOs = this.getCalEventInfoBO(calEvents.getData());
        fi.setData(calEventInfoBOs);
        return fi;
    }

    public boolean isReceiveMember(String userid, Long calEventID) throws BusinessException {
        boolean flag = false;
        CalEvent calEvent = this.calEventDao.getCalEvent(calEventID);
        if(calEvent != null) {
            String receiveMemberId = calEvent.getReceiveMemberId();
            if(receiveMemberId != null && !"".equals(receiveMemberId)) {
                String[] receiveList = receiveMemberId.split(",");

                for(int i = 0; i < receiveList.length; ++i) {
                    receiveList[i] = receiveList[i].substring(7);
                    if(userid.equals(receiveList[i])) {
                        flag = true;
                    }
                }
            }
        }

        return flag;
    }

    public void updateCalProName(Long projectId, String newProName) throws BusinessException {
        this.calEventDao.updateCalProName(projectId, newProName);
    }

    public FlipInfo getLeaderSchedulePage(FlipInfo fi, Map<String, Object> params) throws BusinessException {
        List<CalEvent> calEvents = new ArrayList();
        List<CalEventInfoBO> calInfoBOs = null;
        int index = 1;
        if(params != null && params.size() > 0) {
            Long currentUserId = Long.valueOf(-1L);
            if(StringUtil.checkNull(StringUtil.filterNullObject(params.get("userId")))) {
                currentUserId = Long.valueOf(Long.parseLong(StringUtil.filterNullObject(params.get("createUserID"))));
            } else {
                currentUserId = Long.valueOf(Long.parseLong(StringUtil.filterNullObject(params.get("userId"))));
            }

            V3xOrgMember member = Functions.getMember(currentUserId);
            params.put("userId", member.getId() + "," + member.getOrgAccountId() + "," + member.getOrgDepartmentId());
            if(fi != null) {
                fi.setParams(params);
            }

            while(index < 5) {
                params.putAll(this.getLearderDate(index));
                calEvents.addAll(this.calEventDao.selectLeaderSchedule((FlipInfo)null, params));
                ++index;
            }

            calInfoBOs = this.convertToCalEventInfoBO(calEvents);
            if(fi != null && CollectionUtils.isNotEmpty(calInfoBOs)) {
                DBAgent.memoryPaging(calInfoBOs, fi);
            }
        }

        return fi;
    }

    public FlipInfo getLeaderSchedule(FlipInfo fi, Map<String, Object> params) throws BusinessException {
        int total = 0;
        if(params.size() > 0 && fi != null) {
            if(!StringUtil.checkNull(StringUtil.filterNullObject(params.get("total")))) {
                total = Integer.parseInt(StringUtil.filterNullObject(params.get("total")));
            } else {
                total = this.calEventDao.selectLeaderSchedulegetcount(params);
            }

            if(!StringUtil.checkNull(StringUtil.filterNullObject(params.get("userId")))) {
                V3xOrgMember member = Functions.getMember(Long.valueOf(Long.parseLong(StringUtil.filterNullObject(params.get("userId")))));
                params.put("userId", member.getId() + "," + member.getOrgAccountId() + "," + member.getOrgDepartmentId());
            } else {
                total = this.calEventDao.selectLeaderSchedulegetcount(params);
            }

            fi.setParams(params);
        }

        List<CalEvent> calEvents = new ArrayList();
        List<CalEventInfoBO> calInfoBOs = null;
        int index = 1;

        for(int count = total - calEvents.size(); count > 0 && index < 5; ++index) {
            if(params != null) {
                params.putAll(this.getLearderDate(index));
            }

            if(fi != null) {
                fi.setSize(count);
            }

            calEvents.addAll(this.calEventDao.selectLeaderSchedule(fi, params));
            count = total - calEvents.size();
        }

        calInfoBOs = this.convertToCalEventInfoBO(calEvents);
        if(fi != null && CollectionUtils.isNotEmpty(calInfoBOs)) {
            fi.setData(calInfoBOs);
        }

        return fi;
    }

    public List<V3xOrgMember> getLeaderScheduleUser(Map<String, Object> params) throws BusinessException {
        List<V3xOrgMember> resultList = new ArrayList();
        if(params != null && params.size() > 0) {
            List<OrgMember> orgMemberList = this.calEventDao.selectLeaderScheduleUser(params);
            if(CollectionUtils.isNotEmpty(orgMemberList)) {
                Iterator var5 = orgMemberList.iterator();

                while(var5.hasNext()) {
                    OrgMember orgMember = (OrgMember)var5.next();
                    V3xOrgMember v3xOrgMember = Functions.getMember(orgMember.getId());
                    resultList.add(v3xOrgMember);
                }
            }
        }

        return resultList;
    }

    public Map<RelationType, List<PeopleRelate>> getLeaderScheduleUsertransforrelate(List<V3xOrgMember> peoplelist) throws Exception {
        Map<RelationType, List<PeopleRelate>> relateMemberMap = new HashMap();
        List<PeopleRelate> leaderList = new ArrayList();

        for(int i = 0; i < peoplelist.size(); ++i) {
            PeopleRelate peopleRelate = new PeopleRelate();
            V3xOrgMember vm = (V3xOrgMember)peoplelist.get(i);
            if(vm != null && vm.getEnabled().booleanValue() && !vm.getIsDeleted().booleanValue()) {
                String relateMemberName = vm.getName();
                V3xOrgAccount account = this.orgManager.getAccountById(vm.getOrgAccountId());
                if(!vm.getOrgAccountId().equals(CurrentUser.get().getLoginAccount())) {
                    relateMemberName = relateMemberName + "(" + account.getShortName() + ")";
                    peopleRelate.setRelateMemberAccount(account.getShortName());
                }

                peopleRelate.setRelateMemberName(relateMemberName);
                if(vm.getEmailAddress() != null) {
                    peopleRelate.setRelateMemberEmail(vm.getEmailAddress());
                }

                if(vm.getTelNumber() != null) {
                    peopleRelate.setRelateMemberHandSet(vm.getTelNumber());
                }

                Long deptId = vm.getOrgDepartmentId();
                V3xOrgDepartment dept = this.orgManager.getDepartmentById(deptId);
                if(dept != null) {
                    peopleRelate.setRelateMemberDept(dept.getName());
                }

                Long postId = vm.getOrgPostId();
                V3xOrgPost post = this.orgManager.getPostById(postId);
                if(post != null) {
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

    private List<CalEventInfoBO> convertToCalEventInfoBO(List<CalEvent> calEvents) throws BusinessException {
        List<CalEventInfoBO> calEventInfoBOs = new ArrayList();
        if(CollectionUtils.isNotEmpty(calEvents)) {
            Iterator var4 = calEvents.iterator();

            while(var4.hasNext()) {
                CalEvent calEvent = (CalEvent)var4.next();
                CalEventInfoBO calEventInfoBO = new CalEventInfoBO();
                if(Strings.isBlank(calEvent.getReceiveMemberId())) {
                    calEvent.setReceiveMemberId((String)null);
                }

                calEventInfoBO.setCalEvent(calEvent);
                V3xOrgMember orgMember = Functions.getMember(calEvent.getCreateUserId());
                calEventInfoBO.setAccountName(Functions.showOrgAccountName(calEvent.getAccountID()));
                if(orgMember != null) {
                    V3xOrgDepartment department = Functions.getDepartment(orgMember.getOrgDepartmentId());
                    calEventInfoBO.setDepartMentName(department != null?department.getName():"");
                }

                calEventInfoBO.setPostName(Functions.showMemberLeave(calEvent.getCreateUserId()));
                calEventInfoBOs.add(calEventInfoBO);
            }
        }

        return calEventInfoBOs;
    }

    private Map<String, Object> getLearderDate(int chooseIndex) {
        Map<String, Object> params = new HashMap();
        Date currentDate = this.getCurDate();
        switch(chooseIndex) {
            case 1:
                params.put("isKuaRi", Boolean.valueOf(false));
                params.put("curBeginDate", currentDate);
                params.put("curEndDate", Datetimes.addDate(currentDate, 1));
                break;
            case 2:
                params.put("isKuaRi", Boolean.valueOf(true));
                params.put("curBeginDate", Datetimes.addDate(currentDate, 1));
                params.put("curEndDate", currentDate);
                break;
            case 3:
                params.put("isKuaRi", Boolean.valueOf(false));
                params.put("curBeginDate", Datetimes.addDate(currentDate, 1));
                params.put("curEndDate", Datetimes.addDate(currentDate, 2));
                break;
            case 4:
                params.put("isKuaRi", Boolean.valueOf(false));
                params.put("curBeginDate", Datetimes.addDate(currentDate, 2));
                params.put("curEndDate", "");
        }

        return params;
    }

    public List<CalEventInfoBO> getCalEventForREST(String curTab, long userId) throws BusinessException {
        Map<String, Object> map = new HashMap();
        CalEvent calEvent = new CalEvent();
        List<CalEvent> calEvents = null;
        map.put("createUserID", Long.valueOf(userId));
        FlipInfo flipinfo = new FlipInfo();
        Long size = this.getShareSize(map);
        flipinfo.setSize(size.intValue());
        if("all".equals(curTab)) {
            this.getAllShareEvent(flipinfo, calEvent);
            calEvents = flipinfo.getData();
        } else {
            calEvents = this.calEventDao.getMyOwnListForExcel(map);
        }

        List<CalEventInfoBO> calEventInfoBOs = this.getCalEventInfoBO(calEvents);
        return calEventInfoBOs;
    }
}
