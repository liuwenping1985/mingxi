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
package com.seeyon.apps.calendar.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.calendar.bo.CalEventInfoVO;
import com.seeyon.apps.calendar.enums.ShareTypeEnum;
import com.seeyon.apps.calendar.manager.CalEventManager;
import com.seeyon.apps.calendar.manager.CalEventManagerImpl;
import com.seeyon.apps.calendar.po.CalEvent;
import com.seeyon.apps.calendar.po.CalTimeLine;
import com.seeyon.apps.calendar.po.TimeCompare;
import com.seeyon.apps.custom.manager.CustomManager;
import com.seeyon.apps.peoplerelate.enums.RelationType;
import com.seeyon.apps.performancereport.enums.ReportsEnum;
import com.seeyon.apps.taskmanage.util.MenuPurviewUtil;
import com.seeyon.apps.taskmanage.util.ProductEditionUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.timeline.TimeLineManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.peoplerelate.domain.PeopleRelate;
/**
 * Title: 日程、事件的Controller，整个日程事件所有的操作几乎全是通过这个类开始的
 * Description: 代码描述
 * Copyright: Copyright (c) 2012
 * Company: seeyon.com
 */
public class CalEventController extends BaseController {
	private static final Logger log = Logger.getLogger(CalEventController.class);
	
    private CalEventManager calEventManager; // 日程事件manager类
    private TimeLineManager timeLineManager; // 时间线manager类
    
    public void setCalEventManager(CalEventManager calEventManager) {
        this.calEventManager = calEventManager;
    }
    public void setTimeLineManager(TimeLineManager timeLineManager) {
        this.timeLineManager = timeLineManager;
    }

	/**
     * 用到这个方法有两大类
     * （一）点击目标管理——日程事件 
     * （二）点击他人事件、部门事件、日程事件几个portal更多的方法
     * @param request request请求
     * @param response response请求
     * @return 所有的点击都在先跳转到calendar_Iframe.jsp中,然后由calendar_Iframe.jsp中的js再跳转到其他页面中
     * 原因是：这几个页面都是分页框架统一连接起来的。跳转到具体某个分页的时候，还需要将对应的分页选中处理。
     * （这个方法的重点就在于要想办法将对应页签处于选中状态）
     * @throws BusinessException 异常
     */
    public ModelAndView calEventIndex(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        // 原因是https下。编码方式不一定。会导致异常。只能显示设置一下
        response.setContentType("text/html;charset=UTF-8");
        // 这个是日程事件月视图poratal用到的
        if (Strings.isNotBlank(request.getParameter("otherMore"))) {// 他人事件portal更多
            request.setAttribute("curTab", "other"); // 他人事件
        } else if (Strings.isNotBlank(request.getParameter("departMentMore"))) {// 部门事件portal更多
            request.setAttribute("curTab", "department"); // 部门事件
        } else if (Strings.isNotBlank(request.getParameter("calEventViewSetion"))) {// 日程事件portal更多
            request.setAttribute("curTab", "calEventView"); // 日程事件
            // 这个是日程事件月视图poratal用到的
            String curDate = request.getParameter("curDate"); // 当前时间
            request.setAttribute("curDate", curDate); // 当前时间
        } else { // 日程事件portal月视图点击更多到事件视图月视图中
            request.setAttribute("curTab", "all"); // 日程事件整个模块，默认跳转到个人事件视图
        }
        return new ModelAndView("apps/calendar/event/calendar_Iframe");
    }

    /**
     * <P>项目事件的更多页面</p>
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * ModelAndView
     */
    public ModelAndView moreProjectCalEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
    	ModelAndView mav = new ModelAndView("apps/calendar/event/moreProjectCalEvent");
    	mav.addObject("projectId", request.getParameter("projectId"));
    	mav.addObject("phaseId", request.getParameter("phaseId"));
    	return mav;
    }
    
    /**  
     * 用户点击新增事件操作的方法，包括四个地方。
     * 一：日程事件-个人事件-新增
     * 二：计划转事件
     * 三：协同转事件
     * 四：关联项目-新建事件
     * @param request request请求
     * @param response response请求
     * @return 返回一个已经赋值好的新建事件页面
     * @throws BusinessException 异常
     */
    public ModelAndView createCalEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String beginDate = request.getParameter("beginDate"); // 开始时间
        String shareType = request.getParameter("shareType"); // 关联项目，默认会回填一个共享类型为项目类型
        String projectID = request.getParameter("projectID"); // 关联项目ID
        String fromId = request.getParameter("fromId"); // 协同那边、或者计划那边默认回传一个ID
        String fromType = request.getParameter("appID"); // 协同的应用ID、计划的应用 15关联人员 14关联项目
        String endDate = request.getParameter("endDate"); // 计划——转事件结束时间
        String subject = request.getParameter("subject"); // 计划——转事件标题
        String signifyType = request.getParameter("signifyType"); // 计划——转事件重要程度ApplicationCategoryEnumID
        String receiveMemberId = request.getParameter("receiveMemberId"); // 关联人员---月视图--安排他人
        String dateType = request.getParameter("dateType"); //时间的数据类型(1日期2时间)
        String from_record_id = request.getParameter("recordid"); //计划转事件的计划中具体的项的id
        
        CalEvent calEvent = new CalEvent();
        if(!StringUtils.isEmpty(projectID)){
        	//OA-70510.目标管理--关联项目--选择任一项目--关联项目空间--新建事件，没有关联项目项.
        	AppContext.putRequestContext("isProjectSpace", "1");
        	AppContext.putRequestContext("relateProjectId", projectID);
        }
        if (Strings.isNotBlank(fromId)) {
            calEvent.setFromId(Long.valueOf(fromId)); // 应用对象ID
        }
        if (Strings.isNotBlank(fromType)) { //计划是5 协同是1 事件是11 关联项目15 关联人员14
            calEvent.setFromType(Integer.valueOf(fromType)); // 应用模块ApplicationCategoryEnumID
        }
        if (Strings.isNotBlank(shareType)) { // 关联项目那边的默认共享类型
            calEvent.setShareType(Integer.valueOf(shareType));
        } else { //默认为私人事件
            calEvent.setShareType(0); // 共享类型 ——默认共享类型
        }
        if (Strings.isNotBlank(projectID)) { // 关联项目
            calEvent.setShareTarget(projectID);
        }
        if (Strings.isNotBlank(receiveMemberId)) { // 关联人员---月视图--安排他人
            calEvent.setReceiveMemberId(receiveMemberId);
        }
        if (Strings.isNotBlank(subject)) { // 计划——转事件标题
            calEvent.setSubject(subject.replaceAll("\n", " "));
        }
        if (Strings.isNotBlank(signifyType)) { // 计划——转事件重要程度
            calEvent.setSignifyType(Integer.valueOf(signifyType));
        } else { //默认为重要紧急
            calEvent.setSignifyType(0);
        }
        if (Strings.isNotBlank(from_record_id)) {
            calEvent.setFromRecordId(Long.valueOf(from_record_id)); // 应用对象ID
        }
        String productId = SystemProperties.getInstance().getProperty("system.ProductId");
        if(ProductEditionUtil.isG6Verson(productId)) {
            AppContext.putRequestContext("isG6Version", 1);
        }
        try {
            this.calEventManager.getDateForTypeAndModule(fromType, beginDate, endDate, dateType, calEvent);
        } catch (Exception e) {
            this.calEventManager.setHalfMinite(beginDate, calEvent);
        }
        CalEventInfoVO calEventInfoBO = calEventManager.getAEmptyCalEvent(calEvent); // 初始化新增事件上的参数
        AppContext.putRequestContext("calEventInfoBO", calEventInfoBO);
        
        AppContext.getCurrentUser().getDepartmentId();
        AppContext.putRequestContext("DepartmentID", "Department|"+AppContext.getCurrentUser().getDepartmentId());
        String week_plan_type = request.getParameter("weekPlanType"); //周计划类型
        AppContext.putRequestContext("week_plan_type", week_plan_type);
        return new ModelAndView("apps/calendar/event/calEvent_Create");
    }

    /**
     * 查看当前个人事件 关联项目接口那边点击日程时，会传过来一个flagV3x这个属性用于区分日程、关联项目
     * 
     * @param request request请求
     * @param response response请求
     * @return 返回编辑页面
     * @throws BusinessException 异常
     */
    public ModelAndView editCalEvent(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id"); // 当前操作对象的id
        String meg = calEventManager.isHasDeleteByType(id, "event");
        if (Strings.isNotBlank(meg)) { //这样做的原因是：用户提取url（提权）。如果用户没有权限查看事件的话。就应该直接提示
            throw new BusinessException(meg);
        } else {
            String objectFlag = request.getParameter("flagV3x"); // 关联项目那边与日程之间的
            // 这个标示产生的原因主要是关联项目是老代码,自己写的弹出框
            request.setAttribute("objectFlag", objectFlag); // 用於区分关联项目标示
			 if(!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.calendar, AppContext.getCurrentUser(), Long.valueOf(id), null, null)){
				return null;
			 }
            CalEvent calEvent = this.calEventManager.getCalEventById(Long.valueOf(id)); // 根据ID得到事件对象
            this.calEventManager.toCalEventVO(calEvent); //根据事件对象封装页面edit、修改、查看页面
            String projectId=calEvent.getTranMemberIds();
            if(!StringUtil.checkNull(projectId)&&calEvent.getShareType()==ShareTypeEnum.projectOfEvent.getKey()){
            	//项目事件
            	//注释理由:project_select.js.jsp项目选择组件会自动填充项目名称
            	//ProjectBO summary=projectApi.getProject(Long.valueOf(projectId));
            	AppContext.putRequestContext("relateProjectId", projectId);
            	//AppContext.putRequestContext("relateProjectName", summary.getProjectName());
            }
            if (Strings.isNotBlank(id)) {
                String attachments = this.calEventManager.getAttsByCalId(Long.parseLong(id));
                AppContext.putRequestContext("attachmentJSON", attachments);
            }
            String productId = SystemProperties.getInstance().getProperty("system.ProductId");
            if(ProductEditionUtil.isG6Verson(productId)) {
                AppContext.putRequestContext("isG6Version", 1);
            }
            String week_plan_type = request.getParameter("weekPlanType"); //周计划类型
            AppContext.putRequestContext("week_plan_type", week_plan_type);
            AppContext.getCurrentUser().getDepartmentId();
            AppContext.putRequestContext("DepartmentID", "Department|"+AppContext.getCurrentUser().getDepartmentId());
            return new ModelAndView("apps/calendar/event/calEvent_Create");
        }
    }

    /**
     * 根据事件ID查看事件名称---应用模块（消息）
     * @param id 事件ID
     * @return 事件名称
     * @throws BusinessException
     */
    public String ajaxGetEventName(long id) throws BusinessException {
        CalEvent calEvent = calEventManager.getCalEventById(id);
        return calEvent.getSubject();
    }

    /**
     * 保存个人事件 ----根据用户输入的事件值map,执行保存操作
     * 
     * @param request request请求
     * @param response response请求
     * @return null
     * @throws BusinessException 异常
     */
    public ModelAndView saveCalEvent(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        // 之所以采用getJsonDomain这种方式来得到页面参数，主要是由于附件要求必须要采用Domain分区的方式
        Map<String, Object> params = ParamUtil.getJsonDomain("domaincalEvent"); // calevent_create的form
        
        /**
         * 此段用于判断用户是否有事件的修改权限
         */
        Long calEventId = MapUtils.getLong(params, "calEventID", -1L);
        if (!calEventId.equals(-1L)) {
        	CalEvent calEvent = calEventManager.getCalEventById(calEventId);
        	if (calEvent != null) {
        		if (!calEvent.getCreateUserId().equals(AppContext.currentUserId())) {
        			boolean isAuth = false;
        			if (StringUtils.isNotEmpty(calEvent.getReceiveMemberId())) {
        				isAuth = CommonTools.parseTypeAndIdStr2Ids(calEvent.getReceiveMemberId()).contains(AppContext.currentUserId());
        			}
        			if (!isAuth) {
    					throw new BusinessException(ResourceUtil.getString("calendar.event.modify.noauth"));
    				}
        		}
        	} else {
        		throw new BusinessException(ResourceUtil.getString("calendar.msg.hasDelete"));
        	}
        }
        String type = params.get("calEventType")+"";
        if(type.equals("业务")){
        	params.replace("calEventType", 0);
        }
        if(type.equals("管理")){
        	params.replace("calEventType", 1);
        }
        if(type.equals("个人")){
        	params.replace("calEventType", 2);
        }
        //客开 guoxueyan 公布范围人员也要创建日程 start
        String otherID = params.get("otherID")+"";
        String tranMemberIdsOther = params.get("tranMemberIdsOther")+"";
        String tranMemberIdsDep = params.get("tranMemberIdsDep")+"";
        if(!Strings.isBlank(tranMemberIdsOther) && !"null".equals(tranMemberIdsOther)){
        	String[] arr = tranMemberIdsOther.split(",");
            for(String str:arr){
            	if(!otherID.contains(str)){
            		otherID+=","+str;
            	}
            }
        }
        
        if(!Strings.isBlank(tranMemberIdsDep) && !"null".equals(tranMemberIdsDep)){
        	OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            String[] arr = tranMemberIdsDep.split(",");
            for(String str:arr){
            	String[] sss = str.split("\\|");
            	long l = Long.valueOf(sss[1]);
            	List<V3xOrgMember> members = orgManager.getAllMembersByDepartmentId(l, true, 1, true, true, null, null, null);
            	for(V3xOrgMember member:members){
            		if(!otherID.contains(member.getId()+"")){
                		otherID+=",Member|"+member.getId();
                	}
            	}
            }
        }
        params.replace("otherID", otherID);
        //客开 guoxueyan 公布范围人员也要创建日程 start
        // ID 整合页面传过参数
        this.calEventManager.saveCalEvent(params);
        return null;
    }

    /**
     * 目标管理---日程事件--个人事件---获取所有的个人事件，用于个人事件列表展示
     * 
     * @param request request请求
     * @param response response请求
     * @return 个人事件列表页面
     * @throws BusinessException 异常
     */
    public ModelAndView listCalEvent(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        // 列表页面
        return new ModelAndView("apps/calendar/event/calEvent_List");
    }

    /**
     * 周期事件点击删除要提示。是删除当前事件还是所选事件及其后续事件，只有周期事件，且只选中一个周期事件的时候才会进入这个方法
     * 原因是：其他方式选择的事件组合都默认只删除当前事件
     *  
     * @param request request请求
     * @param response response请求
     * @return 周期事件删除tip页面
     * @throws BusinessException 异常
     */
    public ModelAndView deleteCalEventTip(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id"); // ID
        request.setAttribute("calEvent", this.calEventManager.getCalEventById(Long.valueOf(id)));
        return new ModelAndView("apps/calendar/event/calEvent_DeleteTip");
    }

    /**
     * 新建事件-高级设置
     * 
     * @param request request请求
     * @param response response请求
     * @return 事件高级设置页面
     * @throws BusinessException 异常
     */
    public ModelAndView createCalEventState(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        // 当前操作对象的id
        String id = request.getParameter("id"); // 这里的id并不是一个对象的ID，而是拼接着一个对象的所有属性
        String isNew = request.getParameter("isNew"); //新建还是修改
        this.calEventManager.findCalEventState(id,isNew); // 不管是用户操作的是新增，还是修改，默认加载高级设置的值都是这个方法
        return new ModelAndView("apps/calendar/event/calEvent_CreateCalEventState");
    }

    /**
     * 周期事件点击修改
     * 
     * @param request request请求
     * @param response response请求
     * @return 周期事件修改提示页面
     * @throws BusinessException 异常
     */
    public ModelAndView updateTip(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id"); // ID
        request.setAttribute("title", this.calEventManager.getCalEventById(Long.valueOf(id))
                .getSubject()); // 這個提示也是区分周期性事件还是非周期性事件
        return new ModelAndView("apps/calendar/event/calEvent_UpdateTip");
    }

    /**
     * 个人事件--委托
     * @param request request请求
     * @param response response请求
     * @return 委托页面
     * @throws BusinessException 异常
     */
    public ModelAndView entrustCalEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id");
        this.calEventManager.saveCalEventEntrust(id); // 委托
        return new ModelAndView("apps/calendar/event/entrust_CalEvent");
    }

    /**
     * 执行保存委托事件
     * @param request request请求
     * @param response response请求
     * @return null
     * @throws BusinessException 异常
     */
    public ModelAndView entrustSaveCalEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        List<CalEvent> calEvents = ParamUtil.getJsonParamsGroupToBeanList(CalEvent.class); // 赋初值
        if (CollectionUtils.isEmpty(calEvents)) {
            CalEvent calEvent = new CalEvent();
            ParamUtil.getJsonParamsToBean(calEvent); // 页面赋值
            calEvents = new ArrayList<CalEvent>();
            calEvents.add(calEvent);
        }
        this.calEventManager.saveEntrustCalEvent(calEvents); // 保存委托事件
        return null;
    }

    /**
     * 个人事件-删除--确认删除(执行删除操作)
     * @param request request请求
     * @param response response请求
     * @return null
     * @throws BusinessException 异常
     */
    public ModelAndView deleteCalEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        Map map = ParamUtil.getJsonParams();
        String periodicalStyle = "1";
        String idStr = "";
        for (Object entryObj : map.entrySet()) {
            if (entryObj instanceof Map.Entry) {
                Map.Entry entry = (Map.Entry) entryObj;
                if (entry.getValue() != null && entry.getKey() != null) {
                    String value = entry.getValue().toString();
                    String key = entry.getKey().toString();
                    if (("checkVal").equals(key)) { // 类型+id列表（人的id或是部门的id以逗号分隔）
                        periodicalStyle = value;
                    } else if (("id").equals(key)) {
                        idStr = value;
                    } else if (("formId").equals(key)) {
                        idStr = value;
                    }
                }
            }
        }
        this.calEventManager.deleteCalEvent(idStr, periodicalStyle);
        return null;
    }

    /**
     * 日程事件--共享事件
     * @param request request请求
     * @param response response请求
     * @return 共享事件列表
     * @throws BusinessException 异常
     */
    public ModelAndView listShareAllEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        return new ModelAndView("apps/calendar/event/shareEvent_Iframe");
    }

    /**
     * 日程事件——个人事件——导出excel
     * 
     * @param request request请求
     * @param response response请求
     * @return null
     * @throws BusinessException 异常
     */
    public ModelAndView exportToExcel(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        Map map = request.getParameterMap();
        String continueValue = ParamUtil.getString(map, "continueValue");// 保留用户的条件导出excel
        String curTab = ParamUtil.getString(map, "curTab");
        String EventListtype = ParamUtil.getString(map, "EventListtype");
        String curPeople = ParamUtil.getString(map, "curPeople");
        String str = continueValue+":"+curPeople; 
        this.calEventManager.saveEventToExcel(curTab,EventListtype,str);
        return null;
    }

    /**
     * 日程事件——统计
     * 
     * @param request request请求
     * @param response response请求
     * @return 统计页面
     * @throws BusinessException 异常
     */
    public ModelAndView statisticsCalEvent(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        CalEvent calEvent = new CalEvent();
        Date curDay = Calendar.getInstance().getTime();
        String curDate = DateFormatUtils.ISO_DATE_FORMAT.format(curDay);
        String beginDate = curDate + " 00:00";
        String endDate = curDate + " 23:59";
        try {
            calEvent.setBeginDate(DateUtils.parseDate(beginDate, CalEventManagerImpl.getAllAndSDateDFormat()));
            calEvent.setEndDate(DateUtils.parseDate(endDate, CalEventManagerImpl.getAllAndSDateDFormat()));
        } catch (ParseException e) {
            logger.error(e.getLocalizedMessage(),e);
        }
        calEvent.setStates(5);
        request.setAttribute("ffstatistics", calEvent);
        calEventManager.initStatisticsDate();
        return new ModelAndView("apps/calendar/event/statistics_CalEvent");
    }

    /**
     * 日程事件——统计，点击确定后，就结果的list展示
     * 
     * @param request request请求
     * @param response response请求
     * @return 展示事件统计详细列表页面
     * @throws BusinessException 异常
     */
    public ModelAndView listShowCalEventByStatis(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id");
        FlipInfo flipInfo = new FlipInfo();
        Map<String, String> params = new HashMap<String, String>();
        id = id.substring(1, id.length() - 1);
        String[] paramArray = id.split(",");
        for (String curParams : paramArray) {
            String[] keyArray = curParams.split("\"");
            try {
                request.setAttribute(keyArray[1], keyArray[3]);
                params.put(keyArray[1], keyArray[3]);
            } catch (Exception e) {
                request.setAttribute(keyArray[1], keyArray[2].split(":")[1]);
                params.put(keyArray[1], keyArray[2].split(":")[1]);
            }

        }
        this.calEventManager.getStatisticsCalEventInfoBO(flipInfo, params);
        request.setAttribute("ffmyEvent", flipInfo);
        return new ModelAndView("apps/calendar/event/showCalEventByStatis");
    }

    /**
     * 日程事件--事件视图
     * 
     * @param request request请求
     * @param response response请求
     * @return 事件视图页面
     * @throws BusinessException 异常
     */
    public ModelAndView calEventView(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        this.calEventManager.findCalEventViewData();
        return new ModelAndView("apps/calendar/event/calEvent_View");
    }
    /**
     * 日程事件--领导日程视图
     * 
     * @param request request请求
     * @param response response请求
     * @return 事件视图页面
     * @throws BusinessException 异常
     */
    public ModelAndView calEventViewforLeader(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String tagetid = request.getParameter("tagetid"); // 指定人员id
        this.calEventManager.findCalEventViewDataforLeader(tagetid);
        V3xOrgMember orgMember = Functions.getMember(Long.valueOf(tagetid));
        AppContext.putRequestContext("userName", orgMember.getName());
        AppContext.putRequestContext("tagetid", tagetid);
        return new ModelAndView("apps/calendar/event/calEvent_ViewForLeaderSchedule");
    }
    /**
     * 时间视图
     * 
     * @param request request请求
     * @param response response请求
     * @return 时间安排页面
     * @throws BusinessException 异常
     */
    public ModelAndView arrangeTime(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("isView", Boolean.TRUE); //是视图。视图上不显示图标
        
        String week_plan_type = request.getParameter("weekPlanType"); //周计划类型
        if("1".equals(week_plan_type)){
        	User user = CurrentUser.get();
	        CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
	        List<Long> secretary = customManager.queryallSecretary();
	        for(long l:secretary){
	        	if(user.getId()==l){
     				AppContext.putRequestContext("menuflag",true);
     				break;
     			}
	        }
	        
        }else{
        	AppContext.putRequestContext("menuflag",true);
        }
        AppContext.putRequestContext("week_plan_type",week_plan_type);
         
        // 获得显示数据
    	List<TimeCompare> compareEvent = calEventManager.findArrangeTimeDate(map);
    	AppContext.putRequestContext("calevents", JSONUtil.toJSONString(compareEvent));
        
        // 用于区分跨日显示条数
        request.setAttribute("arrangePage", "arrangeTime");
        //是否有新建任务的权限
        AppContext.putRequestContext("hasNewTaskPurview",MenuPurviewUtil.isHaveNewTask(AppContext.getCurrentUser()));
       	//是否有查看任务权限
        AppContext.putRequestContext("hasViewTaskPurview",MenuPurviewUtil.isHaveProjectAndTask(AppContext.getCurrentUser()));
        
        return new ModelAndView("apps/calendar/arrangeTime/arrangeTime");
    }

    /**
     * 时间安排portal周视图
     * 
     * @param request request请求
     * @param response response请求
     * @return 时间安排portal周视图页面
     * @throws BusinessException 异常
     */
    public ModelAndView arrangeWeeKTime(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("isView", Boolean.TRUE); //是视图。视图上不显示图标
        // 获得显示数据
        List<TimeCompare> compareEvent = calEventManager.findArrangeTimeDate(map);
        request.setAttribute("calevents", JSONUtil.toJSONString(compareEvent));
        request.setAttribute("arrangePage", "arrangeWeeKTime"); // 周视图，有时间切换的时候，需要传入刷新那个页面
        return new ModelAndView("apps/calendar/arrangeTime/arrangeWeeKTime");
    }

    /**
     * 日程事件portal，时间视图portal的月视图
     * 
     * @param request request请求
     * @param response response请求
     * @return 时间安排portal或者日程事件portal月视图页面
     * @throws BusinessException 异常
     */
    public ModelAndView arrangeMonthTime(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("isView", Boolean.TRUE); //是视图。视图上不显示图标
        if (Strings.isNotBlank(request.getParameter("source")) && ("timearrange").equals(request.getParameter("source"))) {
            request.setAttribute("source", "timearrange"); // 时间安排 月视图
        } else {
        	request.setAttribute("source", "arrangeMonthTimeForView"); // 日程事件月视图
            map.put("source", "arrangeMonthTimeForView");
        }
        // 获得显示数据
        List<TimeCompare> compareEvent = calEventManager.findArrangeTimeDate(map);
        request.setAttribute("calevents", JSONUtil.toJSONString(compareEvent));
        request.setAttribute("arrangePage", "arrangeMonthTime"); // 月视图，有时间切换的时候，需要传入刷新那个页面
        return new ModelAndView("apps/calendar/arrangeTime/arrangeMonthTime");
    }

    /**
     * 编辑时间线
     * 
     * @param request request请求
     * @param response response请求
     * @return 时间线编辑页面
     * @throws BusinessException 页面
     */
    public ModelAndView editTimeLine(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        CalTimeLine calTimeLine = this.timeLineManager.getTimeLine();
        String beginTime = "8", endTime = "18";
        if (calTimeLine != null) {
            beginTime = calTimeLine.getBeginTime().toString(); // 从数据库中取出的开始时间
            endTime = calTimeLine.getEndTime().toString(); // 从数据库中取出的结束时间
        }
        request.setAttribute("beginTime", beginTime); // 默认8点开始
        request.setAttribute("endTime", endTime); // 默认18点结束
        List<Integer> eventType = this.timeLineManager.getTimeLineType();
        request.setAttribute("eventType", JSONUtil.toJSONString(eventType)); // 时间线编辑默认选中那些模块对应的数据
        return new ModelAndView("apps/calendar/timeLine/editTimeLine");
    }

    /**
     * 保存时间线数据
     * 
     * @param request request请求
     * @param response response请求
     * @return null
     * @throws BusinessException 异常
     */
    public ModelAndView saveTimeLine(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String timeLineType = request.getParameter("timeLineType"); // 模块ID
        // 计划1，会议2.任务3.事件4
        // 协同5.公文6
        this.timeLineManager.saveTimeLineByType(timeLineType);
        return null;
    }

    /**
     * 日程事件portal 列表展示中有状态的编辑,默认点击状态时打开页面 主要有状态、完成率。实际耗时
     * 
     * @param request request请求
     * @param response response请求
     * @return 日程事件portal编辑状态页面
     * @throws BusinessException 异常
     */
    public ModelAndView openDialogCalEventState(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id"); // 得到事件ID
        CalEvent calEvent = this.calEventManager.getCalEventById(Long.valueOf(id)); // 根据事件ID得到事件对象。然后赋值到前台。主要有状态、完成率。实际耗时
       //OA-90552事件管理：日程事件栏目--点击完成情况--弹出界面--已完成就标红提示
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("id", calEvent.getId());
        m.put("completeRate", calEvent.getCompleteRate().intValue());
        m.put("states", calEvent.getStates());
        m.put("realEstimateTime", calEvent.getRealEstimateTime());
        request.setAttribute("ffstateInitDate", m);
        return new ModelAndView("apps/calendar/event/calEventStateForPortal");
    }

    /**
     * 日程事件portal 保存状态操作
     * 
     * @param request request请求
     * @param response response请求
     * @return null
     * @throws BusinessException 异常
     */
    public ModelAndView saveCalEventState(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        CalEvent calEvent = new CalEvent();
        ParamUtil.getJsonParamsToBean(calEvent); // 根据弹出框将状态、完成率、实际耗时赋值到时间对象中，执行保存
        this.calEventManager.saveCalEventState(calEvent);
        return null;
    }

    /**
     * f8模块穿透查看事件数据 主要搜索某人某天的个人事件数据
     * 
     * @param request request请求
     * @param response response请求
     * @return 个人事件分页对象
     * @throws BusinessException 异常
     */
    public ModelAndView findForStatisticDates(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        String createUserID = request.getParameter("createUserId"); // 搜索那个人
        String beginDate = request.getParameter("beginDate"); // 所搜那一天
        Long userID = Long.valueOf(createUserID);
        Boolean isHasView = this.calEventManager.chackReportAuthReportIdAndViewId(userID,
                ReportsEnum.EventStatistics.getKey());
        // 验证是否有权限查看数据
        if (AppContext.hasPlugin("performanceReport") && isHasView) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("createUserId", userID);
            map.put("beginDate", beginDate);
            FlipInfo fi = new FlipInfo();
            this.calEventManager.getStatisticCalEventInfoBOF8(fi, map);
            request.setAttribute("ffmyEvent", fi);
            request.setAttribute("createUserId", createUserID);
            request.setAttribute("beginDate", beginDate);
            return new ModelAndView("apps/calendar/event/show_calEventByStatisForF8");
        }
        return null;
    }

    /**
     * 关联人员点击月视图中某个日期穿透到事件视图进行查看
     * 
     * @param request request请求
     * @param response response请求
     * @return 关联人员视图查看页面
     * @throws BusinessException 异常
     */
    public ModelAndView calEventView4RelateMember(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        this.calEventManager.findCalEventViewData();
        return new ModelAndView("apps/calendar/arrangeTime/calEventView4RelateMember");
    }

    /**
     * 日程事件--领导人员列表
     * @param request request请求
     * @param response response请求
     * @return 共享事件列表
     * @throws Exception 
     */
    public ModelAndView leaderScheduleMemberList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	Map map = request.getParameterMap();
    	V3xOrgMember member =   Functions.getMember(Long.parseLong(StringUtil.filterNullObject(AppContext.getCurrentUser().getId())));
        map.put("userId", AppContext.getCurrentUser().getId() + "," + member.getOrgAccountId() + "," + member.getOrgDepartmentId());
    	Map<RelationType, List<PeopleRelate>> peopleRelatesList = new HashMap<RelationType, List<PeopleRelate>>();
    	peopleRelatesList = this.calEventManager.getLeaderScheduleUsertransforrelate(this.calEventManager.getLeaderScheduleUser(map));
    	List<PeopleRelate> leaderlist = peopleRelatesList.get(RelationType.leader);
    	ModelAndView mav = new ModelAndView("apps/calendar/event/moreLeader");
    	mav.addObject("leaderlist", leaderlist);
    	return mav;
    }
    
    /**
     * 日程事件--共享事件
     * @param request request请求
     * @param response response请求
     * @return 共享事件列表
     * @throws Exception 
     */
    public ModelAndView leaderScheduleMore(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	return new ModelAndView("apps/calendar/event/moreLeaderSchedule"); //列表更多
    }

}