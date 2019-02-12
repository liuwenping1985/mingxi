package com.seeyon.v3x.meeting.controller;

import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.custom.manager.CustomManager;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.bo.DocResourceBO;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.apps.meeting.api.MeetingVideoManager;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingNatureEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.MeetingStateEnum;
import com.seeyon.apps.meeting.constants.MeetingConstant.SummaryStateEnum;
import com.seeyon.apps.meeting.manager.MeetingApplicationHandler;
import com.seeyon.apps.meeting.manager.MeetingManager;
import com.seeyon.apps.meeting.manager.MeetingResourcesManager;
import com.seeyon.apps.meeting.manager.MeetingSummaryManager;
import com.seeyon.apps.meeting.manager.MeetingTypeManager;
import com.seeyon.apps.meeting.manager.MeetingTypeRecordManager;
import com.seeyon.apps.meeting.manager.PublicResourceManager;
import com.seeyon.apps.meeting.po.MeetingResources;
import com.seeyon.apps.meeting.po.MeetingSummary;
import com.seeyon.apps.meeting.po.MeetingType;
import com.seeyon.apps.meeting.po.PublicResource;
import com.seeyon.apps.meeting.util.MeetingDateUtil;
import com.seeyon.apps.meeting.util.MeetingHelper;
import com.seeyon.apps.meeting.util.MeetingOrgHelper;
import com.seeyon.apps.meeting.util.MeetingUtil;
import com.seeyon.apps.meeting.vo.MeetingMemberStateVO;
import com.seeyon.apps.meeting.vo.MeetingMemberVO;
import com.seeyon.apps.meetingroom.manager.MeetingRoomManager;
import com.seeyon.apps.performancereport.enums.ReportsEnum;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.apps.taskmanage.api.TaskmanageApi;
import com.seeyon.apps.videoconference.util.VideoConferenceConfig;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.meeting.MeetingException;
import com.seeyon.v3x.meeting.contants.MeetingContentEnum;
import com.seeyon.v3x.meeting.domain.MtComment;
import com.seeyon.v3x.meeting.domain.MtMeeting;
import com.seeyon.v3x.meeting.domain.MtReply;
import com.seeyon.v3x.meeting.domain.MtReplyWithAgentInfo;
import com.seeyon.v3x.meeting.manager.MtMeetingManager;
import com.seeyon.v3x.meeting.manager.MtReplyManager;
import com.seeyon.v3x.meeting.util.Constants;
import com.seeyon.v3x.meeting.util.MeetingMsgHelper;

/**
 * 会议的Controller
 * @author wolf
 * @editer xut、Rookie Young
 */
public class MtMeetingController extends BaseController {

    private final static Log log = LogFactory.getLog(MtMeetingController.class);

    private MtMeetingManager mtMeetingManager;
    private MeetingManager meetingManager;
    private AffairManager affairManager;
    private AttachmentManager attachmentManager;
    private MtReplyManager replyManager;
    private ProjectApi projectApi;
    private OrgManager orgManager;
    private AppLogManager appLogManager;
    private DocApi docApi;
    private MeetingRoomManager meetingRoomManager;
    private MeetingTypeManager meetingTypeManager;
    private FileToExcelManager fileToExcelManager;
    private EdocApi edocApi;
    private com.seeyon.ctp.common.ctpenumnew.manager.EnumManager enumManagerNew;
    private MeetingApplicationHandler meetingApplicationHandler;
    private MeetingTypeRecordManager meetingTypeRecordManager;
    private MeetingSummaryManager meetingSummaryManager;
    private TaskmanageApi taskmanageApi;
    private MeetingResourcesManager meetingResourcesManager;
    private PublicResourceManager publicResourceManager;
    
    /**
     * 显示会议详细页面，或预览会议
     */
    public ModelAndView detail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("id");
        MtMeeting bean = null;
        Long meetingId = null;
        String proxyId = request.getParameter("proxyId");
        boolean isImpart =  Boolean.valueOf(request.getParameter("isImpart"));
        boolean fromPigeonhole = "true".equals(request.getParameter("fromPigeonhole"))? true:false;
        User user = AppContext.getCurrentUser();
        ModelAndView mav = null;
        List<Attachment> attachments = null;
        if(request.getParameter("preview") != null) {
            mav = new ModelAndView("meeting/user/template_preview");
        } else {
            if(Strings.isNotBlank(idStr)) {
                meetingId = Long.parseLong(idStr);
                bean = meetingManager.getMeetingById(meetingId);
            } else {
                bean = new MtMeeting();
            }

            //入口-关联项目-会议
            boolean canVisit = false;
            boolean isQuote = Strings.isBlank(request.getParameter("isQuote")) ? false : Boolean.parseBoolean(request.getParameter("isQuote"));
            if(isQuote) {
                int baseApp = Strings.isBlank(request.getParameter("baseApp")) ? 6 : Integer.parseInt(request.getParameter("baseApp"));
                long baseObjectId = Strings.isBlank(request.getParameter("baseObjectId")) ? -1 : Long.parseLong(request.getParameter("baseObjectId"));
                if(baseApp == ApplicationCategoryEnum.taskManage.key()) {//任务模块中的关联文档-会议
                    if(baseObjectId != -1) {
                    	//TODO DEV 2015-08-20 还没有给这个接口
                        /*canVisit = taskmanageApi.validateTask(request.getParameter("baseObjectId"));*/
                    }
                }
            }

            // 如果是从文档中心打开，则不验证是否为与会人员
            if(Strings.isNotBlank(request.getParameter("fromdoc"))) {//xiangfan 修改为 isNotBlank GOV-4924
                if(bean == null) {
                    super.rendJavaScript(response, "parent.refreshIfInvalid();");
                    return null;
                } else {
                    if((bean.getState() == Constants.DATA_STATE_SAVE && "10".equals(request.getParameter("state"))) || (!this.mtMeetingManager.isStillInConferees(user.getId(), bean) && Strings.isBlank(request.getParameter("eventId")))) {
                        if(Strings.isNotBlank(proxyId) && !"0".equals(proxyId) && !"-1".equals(proxyId) && Strings.isDigits(proxyId)) {
                            if(!this.mtMeetingManager.isStillInConferees(Long.valueOf(proxyId), bean)) {
                                super.rendJavaScript(response, "parent.refreshIfInvalid();");
                                return null;
                            }
                        }
                    }
                }
            }
            
			// 客开
            Map<String, Object> map = new HashMap<String, Object>();
            CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
            map = customManager.isSecretary();
            boolean fff = Boolean.valueOf(map.get("flag")+"");
            
            if(!canVisit) { 
                //当前人是否在改会议中，会议创建人排除掉 （fromPigeonhole:不是来自于借阅文档）
                if(null != bean && !fromPigeonhole && !isQuote && !AppContext.getCurrentUser().getId().equals(bean.getCreateUser())
                        && !this.mtMeetingManager.isStillInConferees(AppContext.getCurrentUser().getId(), bean) && fff){
                    Locale local = LocaleContext.getLocale(request);
                    String label = ResourceBundleUtil.getString("com.seeyon.v3x.meeting.resources.i18n.MeetingResources", local, "meeting.cancel",bean.getTitle());
                    StringBuilder sb = new StringBuilder();
                    sb.append("alert('"+ label +"');");
                    sb.append("if(parent.parent.window.dialogArguments && parent.parent.window.dialogArguments.callback){\n");
                    sb.append("  parent.parent.window.dialogArguments.callback();\n");//从栏目打开，关闭窗口并刷新对应栏目
                    sb.append("} else {parent.parent.window.close();}");
                    super.rendJavaScript(response, sb.toString());
                    return null;
                }
                // SECURITY 访问安全检查
                if(!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.meeting, user, meetingId, null, null) && fff) {
                    return null;
                }
            }
            /*********************** 只读状态修改为已读 start ****************************/
            // 查看会议时，写入会议阅读信息
            if(bean != null && bean.getState() != 0 && bean.getCreateUser() != null) {
                long affairId = Strings.isBlank(request.getParameter("affairId")) ? -1 : Long.parseLong(request.getParameter("affairId"));
                //首页待办事项入口、首页代理事项入口
                if(affairId != -1) {
                    CtpAffair affair = affairManager.get(affairId);
                    if(affair != null) {
                        if(!"inform".equals(affair.getNodePolicy())) {//非告知人
                            isImpart = false;
                        }
                    }
                }
            }
            /*********************** 只读状态修改为已读 end ****************************/
            if(request.getParameter("oper") != null) { // 只显示正文
                mav = new ModelAndView("meeting/user/showContent");
                
                mav.addObject("language", AppContext.getLocale().getLanguage());

                List<MtReply> replyList = replyManager.getReceiptOpinion(bean.getId(), bean);//xiangfan 修改为getReceiptOpinion不需要查询出回执状态为-100的，点击查看 状态为-100，这里回执意见是需要过滤掉的
                mav.addObject("replySize", replyList.size());
                mav.addObject("replyList", replyList);
                mav.addObject("proxyId", proxyId);
                
                boolean hasEdoc = AppContext.hasPlugin("edoc");
                
                mav.addObject("hasEdocPlugin", hasEdoc);
                mav.addObject("hasNewCollMenu", AppContext.getCurrentUser().hasResourceCode("F01_newColl"));
                mav.addObject("hasSendEdocMenu", AppContext.getCurrentUser().hasResourceCode("F07_sendManager"));
                
                boolean isEdocCreateRole = false;
                if(hasEdoc){
                    isEdocCreateRole = edocApi.isEdocCreateRole(user.getId(), user.getLoginAccount(), EdocEnum.edocType.sendEdoc.ordinal());
                }
                mav.addObject("isEdocCreateRole", isEdocCreateRole);
                
                attachments = attachmentManager.getByReference(bean.getId());
                List<MtComment> mtComments = this.mtMeetingManager.getAllCommentByMeetingId(meetingId);
                Map<Long, List<MtComment>> commentsMap = new HashMap<Long, List<MtComment>>();
                MeetingHelper.modulateCommentOpinion(commentsMap, replyList, mtComments);
                mav.addObject("comments", commentsMap);
                mav.addObject("MtCreateUserId", bean.getCreateUser());
                mav.addObject("meetingState", bean.getState());
                mav.addObject("curUserName", orgManager.getMemberById(user.getId()).getName());
                //获得会议纪要
                if(bean.getRecordState() == MtMeeting.SUMMARY_RECORDSTATE_YES){
                    MeetingSummary summary =  meetingSummaryManager.getSummaryById(bean.getRecordId());
                    //xiangfan 添加MtSummary.SUMMARY_STATE_PASSED，MtSummary.SUMMARY_STATE_PUBLISH等条件 修复GOV-2376，只有纪要审核通过或直接发布的才能在会议的下方显示
                    if(null != summary && (summary.getState()==SummaryStateEnum.passed.key() || summary.getState()==SummaryStateEnum.publish.key())){
                        List<Attachment> summarySattachments = attachmentManager.getByReference(summary.getId(), summary.getId());
                        if(summarySattachments != null){
                            attachments.addAll(summarySattachments);
                        }
                        mav.addObject("summary", summary);
                    }
                }
                if(AppContext.hasPlugin("videoconference")) {
                	if(MeetingNatureEnum.video.key().equals(bean.getMeetingType())) {
		                if("HTML".equals(bean.getDataFormat())) {
		                	MeetingVideoManager meetingVideoManager = meetingApplicationHandler.getMeetingVideoHandler();
		                	List<Long> list = CommonTools.getMemberIdsByTypeAndId(bean.getConferees(), orgManager);
		                	long userId = AppContext.currentUserId();
		                	if(meetingVideoManager != null && (list.contains(userId) || bean.getEmceeId() == userId || bean.getRecorderId() == userId) &&
		                			MeetingHelper.isPending(bean.getState()) && MeetingHelper.isRoomPass(bean.getRoomState())) {
		                		
		                		String content = Strings.isEmpty(bean.getContent()) ? "" : bean.getContent();
		                		bean.setContent(content + meetingVideoManager.getVideoUrlContent(bean.getVideoMeetingId()));
		                	}
		                }
                	}
                }
                
                //获取会议任务(已经结束的会议才能新建任务和查看任务)
                if(AppContext.hasPlugin("taskmanage") && (bean.getState() == 20 //已开始
        				|| bean.getState() == 30 //已结束
        				|| bean.getState() == 31 //提前结束
        				|| bean.getState() == 40 //已总结
        				|| bean.getState() == -10)){ //已归档
                	mav.addObject("task_all", taskmanageApi.countTaskSource(ApplicationCategoryEnum.meeting.getKey(), bean.getId(), null, -1));
                	mav.addObject("task_unfinished", taskmanageApi.countTaskSource(ApplicationCategoryEnum.meeting.getKey(), bean.getId(), null, -2));
                	mav.addObject("task_overdue", taskmanageApi.countTaskSource(ApplicationCategoryEnum.meeting.getKey(), bean.getId(), null, 6));
                	mav.addObject("task_finished", taskmanageApi.countTaskSource(ApplicationCategoryEnum.meeting.getKey(), bean.getId(), null, 4));
                	mav.addObject("task_canceled", taskmanageApi.countTaskSource(ApplicationCategoryEnum.meeting.getKey(), bean.getId(), null, 5));
                	mav.addObject("showMeetingTask",true);
                }else{
                	mav.addObject("showMeetingTask",false);
                }
                
            } else {// 只显示标题时间
                mav = new ModelAndView("meeting/user/meeting_list_detail_iframe");
                String statType = request.getParameter("statType");
                boolean showJoinButtom = true;
                // 处理会议室
                if(bean != null) {
                    
                    String roomName = meetingRoomManager.getRoomNameById(bean.getRoom(), bean.getMeetPlace());
                    //当前时间晚于会议结束时间，不能参会
                    if(MeetingDateUtil.compareDate(new Date(), bean.getEndDate())){
                    	showJoinButtom = false;
                    }
                    mav.addObject("roomName", roomName);
                    mav.addObject("proxyId", proxyId);
                    attachments = attachmentManager.getByReference(bean.getId(), bean.getId());
                    //重要会议的六项要根据会议分类的设置来显示
                    mav.addObject("mtch", meetingTypeRecordManager.getTypeRecordByMeetingId(bean.getId()));
                    mav.addObject("statType", statType);
                }
                mav.addObject("showJoinButtom", showJoinButtom);
                
                if(AppContext.hasPlugin("videoconference")) {
                	boolean joinFlag = (user.getId().longValue()==bean.getEmceeId().longValue() || (bean.getRecorderId()!=null && user.getId().longValue()==bean.getRecorderId().longValue()));
	                Map<String, Object> paramMap = new HashMap<String, Object>();
	                paramMap.put("joinType", joinFlag ? 1 : 2 );
	                paramMap.put("password", bean.getMeetingPassword());
	                paramMap.put("confKey", bean.getConfKey());
	                paramMap.put("url", "/mtMeeting.do?method=listMain&stateStr=10");
	                paramMap.put("meetingId", bean.getId());
	                
	                MeetingVideoManager meetingVideoManager = meetingApplicationHandler.getMeetingVideoHandler();
	                if(meetingVideoManager != null) {
		                mav.addObject("joinImportUrl", meetingVideoManager.getJoinImportUrl());
		                mav.addObject("joinButtonClkFunName", meetingVideoManager.getJoinButtonClkFunName());
		                mav.addObject("joinButtonClkFunParmas", meetingVideoManager.getJoinButtonClkFunParmas(paramMap));
	                }
                }
            }
        }
        mav.addObject("fromPigeonhole", fromPigeonhole);
        /******************************** 视频会议 start **********************************/
        if(bean!=null && Constants.VIDEO_MEETING.equals(bean.getMeetingType())){
            mav.addObject("videoConfStatus", VideoConferenceConfig.VIDEO_CONF_STATUS);
        }
        if(VideoConferenceConfig.MULTIPLE_MASTER_SERVER_ENABLE){
            mav.addObject("multipleMasterServerEnable", "enable");
        }
        /******************************** 视频会议 end **********************************/

        boolean mtHoldTimeInSameDay = false;
        if(bean!=null && bean.getBeginDate()!=null && bean.getEndDate()!=null) {
            mtHoldTimeInSameDay = Datetimes.format(bean.getBeginDate(), Datetimes.dateStyle).equals(Datetimes.format(bean.getEndDate(), Datetimes.dateStyle));
        }
        //添加判断告知
        mav.addObject("isImpart",isImpart);
        return mav.addObject("bean", bean).addObject("attachments", attachments).addObject("mtHoldTimeInSameDay", mtHoldTimeInSameDay);
    }

    public MeetingSummaryManager getMeetingSummaryManager() {
		return meetingSummaryManager;
	}

	public void setMeetingSummaryManager(MeetingSummaryManager meetingSummaryManager) {
		this.meetingSummaryManager = meetingSummaryManager;
	}

	/**
     * 查看会议Frame页面
     */
    public ModelAndView myDetailFrame(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("meeting/user/showMeetingFrame");
        String id = request.getParameter("id");
        Long meetingId = Long.parseLong(id);
        MtMeeting bean = meetingManager.getMeetingById(meetingId);
        StringBuilder sb = new StringBuilder();
        User user = AppContext.getCurrentUser();
        
		// 客开
        Map<String, Object> map = new HashMap<String, Object>();
        CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
        map = customManager.isSecretary();
        boolean fff = Boolean.valueOf(map.get("flag")+"");
        
        /* xiangfan 添加，被撤销后参会人不允许再次冲消息弹出框打开会议 GOV-4902*/
        response.setContentType("text/html;charset=UTF-8");
        if(bean == null || bean.getRoomState() == MtMeeting.MEETING_ROOM_STATE_ROOM_APP_WAIT || 
                bean.getRoomState() == MtMeeting.MEETING_ROOM_STATE_ROOM_APP_NOT_PASS){
            sb.append("alert('"+ResourceUtil.getString("meeting.status.cancel")+"');");
            sb.append("if(window.dialogArguments && window.dialogArguments.callback){\n");
            sb.append("  window.dialogArguments.callback();\n");
            sb.append("} else {parent.window.close();}");
            super.rendJavaScript(response, sb.toString());
            return null;
        } else if(null != bean && bean.getState() == Constants.DATA_STATE_SAVE && bean.getCreateUser().longValue() != user.getId() && fff){
            String label = ResourceUtil.getString("meeting.cancel",bean.getTitle());
            sb.append("alert('"+StringEscapeUtils.escapeJavaScript(label)+"');");
            sb.append("if(window.dialogArguments && window.dialogArguments.callback){\n");
            sb.append("  window.dialogArguments.callback();\n");
            sb.append("} else {parent.window.close();}");
            super.rendJavaScript(response, sb.toString());
            return null;
        } else if(bean != null) {
            //如果是点老G6领导查阅的消息链接打开，则提示不能打开
            long userId = AppContext.currentUserId();
            String lookLeaders = bean.getLookLeaders();
            if(Strings.isNotBlank(lookLeaders) && lookLeaders.indexOf(String.valueOf(userId))>-1){
                sb.append("alert('"+ResourceUtil.getString("meeting.view.nofunction")+"');");
                sb.append("parent.window.close();");
                super.rendJavaScript(response, sb.toString());
                return null;
            }
        }
        if(bean != null){
            mav.addObject("meetingTitle", bean.getTitle());
        }
        mav.addObject("affairId", request.getParameter("affairId"));
        return mav;
    }

    /**
     * 查看会议详细内容页面
     */
    public ModelAndView mydetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView mav = new ModelAndView("meeting/user/meeting_detail_chrome37_iframe");
        return mav;
    }

    /**
     * 解决Chrome37问题，在中间加一层iframe
     * @Author      : xuqiangwei
     * @Date        : 2014年11月22日下午4:01:39
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView mydetailChrome37(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView mav = new ModelAndView("meeting/user/meeting_detail_iframe");
        String fisearch = request.getParameter("fisearch");
        String proxy = request.getParameter("proxy");//是否被代理
        String proxyId = request.getParameter("proxyId");//被代理人的Id
        String fromdoc = request.getParameter("fromdoc");
        String eventId = request.getParameter("eventId");
        String affairId = request.getParameter("affairId");
        String statType = request.getParameter("statType");
        String id = request.getParameter("id");//会议ID
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        mav.addObject("fisearch", fisearch == null ? 0 : fisearch);
        Long meetingId = Long.parseLong(id);
        MtMeeting bean = meetingManager.getMeetingById(meetingId);
        if(bean == null){
            String label = ResourceUtil.getString("meeting.not.exist");
            String sb = createRendJs(label, true);
            super.rendJavaScript(response, sb);
            return null;
        }
        String isCollCube = request.getParameter("isCollCube");
        String isColl360  = request.getParameter("isColl360");
        mav.addObject("isCollCube", isCollCube);
        mav.addObject("isColl360", isColl360);
        mav.addObject("statType", statType);
        
        boolean toCloseWin = true;//设置JS是否关闭窗口标识
        
        if("1".equals(isCollCube)){
            
            toCloseWin = false;
            
            String _senderId  = request.getParameter("senderId");//发起人
            String _dealer_Id = request.getParameter("dealerId");//处理人
            boolean viewFlag = false;
            List<CtpAffair> allAffair = affairManager.getAffairs(ApplicationCategoryEnum.meeting, bean.getId());
            if(null != allAffair && allAffair.size()>0){
                for(int a=0; a < allAffair.size(); a++){
                    CtpAffair cAffair = allAffair.get(a);
                    if(Strings.isNotBlank(_dealer_Id) && cAffair.getMemberId().equals(Long.parseLong(_dealer_Id))){
                        viewFlag = true;
                        break;
                    }
                    if(Strings.isNotBlank(_senderId) && cAffair.getSenderId().equals(Long.parseLong(_senderId))){
                        viewFlag = true;
                        break;
                    }
                }
                if(!viewFlag){
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('"+ResourceUtil.getString("collaboration.alert.chuantou.label2")+"')");
                    out.println("</script>");
                    out.flush();
                    return null;
                }
            }else if(Strings.isNotBlank(_dealer_Id) && (null == allAffair || allAffair.size() == 0)){
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('"+ResourceUtil.getString("collaboration.alert.chuantou.label2")+"')");
                    out.println("</script>");
                    out.flush();
                    return null;
            }
        }
        if("1".equals(isColl360)){//360过来
            
            toCloseWin = false;
            
            String _senderId  = request.getParameter("senderId");//发起人
            String _dealer_Id = request.getParameter("dealerId");//处理人
            boolean viewFlag = false;
            List<CtpAffair> allAffair = affairManager.getAffairs(ApplicationCategoryEnum.meeting, bean.getId());
            if(null != allAffair && allAffair.size()>0){
                for(int a=0; a < allAffair.size(); a++){
                    CtpAffair cAffair = allAffair.get(a);
                    if(Strings.isNotBlank(_dealer_Id) && cAffair.getMemberId().equals(Long.parseLong(_dealer_Id))){
                        viewFlag = true;
                        break;
                    }
                    if(Strings.isNotBlank(_senderId) && cAffair.getSenderId().equals(Long.parseLong(_senderId)) &&
                            (StateEnum.col_done.getKey()==cAffair.getState().intValue()||StateEnum.col_sent.getKey() == cAffair.getState().intValue()
                                    ||StateEnum.col_pending.getKey() == cAffair.getState().intValue())){
                        viewFlag = true;
                        break;
                    }
                }
                if(!viewFlag){
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('"+ResourceUtil.getString("collaboration.alert.chuantou.label2")+"')");
                    out.println("</script>");
                    out.flush();
                    return null;
                }
            }else if(Strings.isNotBlank(_senderId) && (null == allAffair || allAffair.size() == 0)){
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('"+ResourceUtil.getString("collaboration.alert.chuantou.label2")+"')");
                    out.println("</script>");
                    out.flush();
                    return null;
            }
        }
        
        CtpAffair affair = null;
        if(Strings.isNotBlank(affairId)) {
            affair = affairManager.get(Long.valueOf(affairId));
        }else if(Strings.isNotBlank(id)){
        	//判断代理。获取代理的事项
        	Long affairUserId = userId;
        	if (!MeetingUtil.isIdBlank(proxyId)) {
        		affairUserId =  Long.parseLong(proxyId);
        	}
            List<CtpAffair> list = this.affairManager.getAffairs(ApplicationCategoryEnum.meeting, Long.parseLong(id), affairUserId);
            if(CollectionUtils.isNotEmpty(list)){
                affair = list.get(0);
            }
        }
        
        if(affair != null) {
            if(affair.getMemberId().longValue() != userId.longValue()) {
                proxyId = String.valueOf(affair.getMemberId());
            }
            //由‘未读’标记为 ‘已读’
            if(affair.getSubState() == null || affair.getSubState() == SubStateEnum.col_pending_unRead.key()){
                //发起人既是主持人或记录人，默认更新为参加状态
                if((bean.getEmceeId().longValue()==affair.getMemberId() && bean.getCreateUser().longValue()==affair.getMemberId()) ||
                        (bean.getRecorderId().longValue()==affair.getMemberId() && bean.getCreateUser().longValue()==affair.getMemberId()))
                    affair.setSubState(SubStateEnum.meeting_pending_join.key());
                else
                    affair.setSubState(SubStateEnum.col_pending_read.key());
                this.affairManager.updateAffair(affair);
            }
            if ("inform".equals(affair.getNodePolicy())) {
                mav.addObject("isImpart", true);
            } else {
                mav.addObject("isImpart", false);
            }
        }
        
        // 从代理事项里过来的
        mav.addObject("fagent", MeetingUtil.isIdBlank(proxyId) ? 0 : 1 );

        //入口-关联项目-会议
        boolean canVisit = false;
        boolean isQuote = Strings.isBlank(request.getParameter("isQuote")) ? false : Boolean.parseBoolean(request.getParameter("isQuote"));
        if(isQuote) {
            int baseApp = Strings.isBlank(request.getParameter("baseApp")) ? 6 : Integer.parseInt(request.getParameter("baseApp"));
            long baseObjectId = Strings.isBlank(request.getParameter("baseObjectId")) ? -1 : Long.parseLong(request.getParameter("baseObjectId"));
            if(baseApp == ApplicationCategoryEnum.taskManage.key()) {//任务模块中的关联文档-会议
                if(baseObjectId != -1) {
                    if(null!=bean && bean.getState()==Constants.DATA_STATE_SAVE) {//待发
                        Locale local = LocaleContext.getLocale(request);
                        String label = ResourceBundleUtil.getString("com.seeyon.v3x.meeting.resources.i18n.MeetingResources", local, "meeting.view.permission",new Object[]{});
                        StringBuilder sb = new StringBuilder();
                        sb.append("alert('"+ label +"');\n");
                        sb.append("if(window.dialogArguments && window.dialogArguments.callback){\n");
                        sb.append("  window.dialogArguments.callback();\n");
                        sb.append("}else if(parent.window.dialogArguments && parent.window.dialogArguments.callback){\n");
                        sb.append("  parent.window.dialogArguments.callback();\n");//从栏目打开，关闭窗口并刷新对应栏目
                        sb.append("} else {");
                        if(toCloseWin){
                            sb.append("parent.window.close();");
                        }
                        sb.append("}");
                        super.rendJavaScript(response, sb.toString());
                        return null;
                    }
                    //TODO DEV 2015-08-20 还没有给这个接口
                    /*canVisit = taskmanageApi.validateTask(request.getParameter("baseObjectId"));*/
                }
            }
        }

        // 如果是从文档中心打开，则不验证是否为与会人员
        if(Strings.isNotBlank(fromdoc)) {//xiangfan 修改为 isNotBlank GOV-4924
            if(bean == null) {
                super.rendJavaScript(response, "parent.refreshIfInvalid();");
                return null;
            } else {
                if((bean.getState() == Constants.DATA_STATE_SAVE && "10".equals(request.getParameter("state"))) || (!this.mtMeetingManager.isStillInConferees(userId, bean) && Strings.isBlank(eventId))) {
                    if(Strings.isNotBlank(proxyId) && !"0".equals(proxyId) && !"-1".equals(proxyId) && Strings.isDigits(proxyId)) {
                        if(!this.mtMeetingManager.isStillInConferees(Long.valueOf(proxyId), bean)) {
                            super.rendJavaScript(response, "parent.refreshIfInvalid();");
                            return null;
                        }
                    }
                }
            }
        }

        // 客开
        Map<String, Object> map = new HashMap<String, Object>();
        CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
        map = customManager.isSecretary();
        boolean fff = Boolean.valueOf(map.get("flag")+"");
        
        // SECURITY 访问安全检查
        if(!canVisit) {
            //撤销重新发起，查看会议，需要判断当前人是否依旧在该会议中
            if(null != bean && !isQuote && !AppContext.getCurrentUser().getId().equals(bean.getCreateUser())
                    && !this.mtMeetingManager.isStillInConferees(AppContext.getCurrentUser().getId(), bean) && fff){
                Locale local = LocaleContext.getLocale(request);
                String label = ResourceBundleUtil.getString("com.seeyon.v3x.meeting.resources.i18n.MeetingResources", local, "meeting.view.permission",new Object[]{});
                if(bean.getState() == Constants.DATA_STATE_SAVE && bean.getCreateUser().longValue() != user.getId()){
                    label = ResourceBundleUtil.getString("com.seeyon.v3x.meeting.resources.i18n.MeetingResources", local, "meeting.cancel",bean.getTitle());
                }

                
                String sb = createRendJs(label, toCloseWin);
                super.rendJavaScript(response, sb);
                return null;
            }
            if(!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.meeting, user, meetingId, null, null) && fff) {
                return null;
            }
        }
        if(!MeetingUtil.isIdBlank(proxyId)) {
        	proxy = "1";
        }
        if(bean != null) {
            String feedBack = request.getParameter("feedback");
            String feedBackFlag = request.getParameter("feedbackFlag");
            //会议通知回执
            String msg = mtMeetingManager.replyMeetingFeedBack(bean,feedBack,feedBackFlag,user,proxy,proxyId,request);
            if("myReplyNotEmpty".equals(msg)){
                super.rendJavaScript(response, "parent.closeMtWindow('saveMtReply');try{parent.doMeeetingSign_pending('"+id+"')}catch(e){}");
                return null;
            }
        }
        if(bean != null) {
        	mav.addObject("meetingTitle", bean.getTitle());
        }
        mav.addObject("id", id);
        mav.addObject("proxy", proxy);
        mav.addObject("proxyId", proxyId);
        return mav;
    }

    private String createRendJs(String label, boolean closeWin){
        StringBuilder sb = new StringBuilder();
        sb.append("alert('"+ label +"');\n");
        sb.append("if(window.dialogArguments && window.dialogArguments.callback){\n");
        sb.append("  window.dialogArguments.callback();\n");
        sb.append("}else if(parent.window.dialogArguments && parent.window.dialogArguments.callback){\n");
        sb.append("  parent.window.dialogArguments.callback();\n");//从栏目打开，关闭窗口并刷新对应栏目
        sb.append("} else if(parent.window.listFrame){parent.window.listFrame.location.reload();");
        //sb.append("} else if(parent && parent.parent){parent.parent.window.close();}");
        sb.append("} else {");
        if(closeWin){
            sb.append("parent.window.getA8Top().close();"); 
        }
        sb.append("}");
        return sb.toString();
    }

    /**
     * 查看会议时，对会议回执表添加数据
     * @Author      : xuqw
     * @Date        : 2015年4月10日下午1:12:17
     * @param bean 会议对象
     * @param userId 需要添加回执记录的人员ID
     * @throws BusinessException 
     */
    private void addReplyRecord(MtMeeting bean, Map<Long, MtReply> replys, Long userId) throws BusinessException{
        if(replys.get(userId) == null){
        	MtReply mtReply = new MtReply();
            mtReply.setMeetingId(bean.getId());
            mtReply.setUserId(userId);
            
            if(bean.getCreateUser().equals(Long.valueOf(userId))){
                mtReply.setFeedbackFlag(1);
                mtReply.setLookState(1);
            }else{
                mtReply.setFeedbackFlag(-100);
                mtReply.setLookState(2);
            }
            mtReply.setLookTime(new java.sql.Timestamp(new Date().getTime()));
            replyManager.save(mtReply);
        }
    }
    
    /**
     * 人员是否在会议的参会人或参会领导中
     * @Author      : xuqw
     * @Date        : 2015年4月10日下午1:47:35
     * @return
     * @throws BusinessException 
     */
    private boolean isInMeetingRole(Long meetingId, Long userId) throws BusinessException{
        
        boolean ret = false;
        
        MeetingMemberVO vo = meetingManager.getAllTypeMember(meetingId, null);
        List<Long> leaders = vo.getLeader(); //参会领导
        List<Long> conferees = vo.getConferees(); //与会人
        
        //是否在参会领导中
        for (Long leader : leaders) {
            if (leader.equals(userId)) {
                ret = true;
            }
        }
        //是否在与会人中
        for (Long conferee : conferees) {
            if (conferee.equals(userId)) {
                ret = true;
            }
        }
        
        return ret;
    }

    public ModelAndView showMtDiagram(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("meeting/user/showMtDiagram");
        mav.addObject("fisearch", StringUtils.defaultString(request.getParameter("fisearch"), "0"));
        String idStr = request.getParameter("id");
        String proxy = request.getParameter("proxy");
        String proxyId = request.getParameter("proxyId");
        String openfrom = request.getParameter("openfrom");
        MtMeeting bean = meetingManager.getMeetingById(Long.valueOf(idStr));
        mav.addObject("conferee", bean.getConferees());
        boolean isImpart = Boolean.valueOf(request.getParameter("isImpart"));
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        boolean flag = true;
        //当前用户在会议中角色仅仅只是发起者
        if(bean.getCreateUser().longValue() == userId) {
            if(bean.getRecorderId().longValue() == userId || bean.getEmceeId().longValue() == userId){//发起人兼主持人或记录人，也要插入reply记录，不然无法显示状态OA-28524
                flag = true;
            }else {
                flag = isInMeetingRole(bean.getId(), user.getId());
            }
        }

        Map<String, Object> conditions = new HashMap<String, Object>();
        conditions.put("app", ApplicationCategoryEnum.meeting.key());
        conditions.put("objectId", Long.valueOf(idStr));
        List<CtpAffair> affairList = affairManager.getByConditions(null, conditions);
        
        Map<Long, MtReply> list_allReply = replyManager.findAllByMeetingId(bean.getId());
        
        if(flag) {
            //新增回执记录
            addReplyRecord(bean, list_allReply, userId);
            
            if(!userId.equals(bean.getCreateUser())){//其他人查看，如果发起人有参会角色需要为发起人添加回执记录
                
                Long createUserId = bean.getCreateUser();
                if(createUserId.equals(bean.getRecorderId()) || createUserId.equals(bean.getEmceeId().longValue())){
                    //创建人是发起人，或记录人
                    addReplyRecord(bean, list_allReply, bean.getCreateUser());
                }else {
                    boolean isAttendMeeting = isInMeetingRole(bean.getId(), bean.getCreateUser());
                    //创建人是参会人员或参会领导
                    if(isAttendMeeting){
                        addReplyRecord(bean, list_allReply, bean.getCreateUser());
                    }
                }
            }
            
            for(CtpAffair affair : affairList){
            	if(affair.getMemberId() != null && affair.getMemberId().equals(userId)){
            		if(affair.getState()==StateEnum.col_pending.key() && affair.getSubState()==SubStateEnum.col_pending_unRead.key()) {
            			affair.setSubState(SubStateEnum.col_pending_read.key());
            			affairManager.updateAffair(affair);
            		}
            	}
            }
        }

        List<Long> leaderIdList = new ArrayList<Long>();//存放参会领导ID
        List<MtReplyWithAgentInfo> replyLeaderExList = mtMeetingManager.getMtReplyInfoByLeader(bean, leaderIdList);
        List<MtReplyWithAgentInfo> replyExList = mtMeetingManager.getMtReplyInfo(bean, leaderIdList, list_allReply);
        if(Strings.isNotEmpty(replyLeaderExList) && Strings.isNotEmpty(replyExList)){
            List<MtReplyWithAgentInfo> leaderInfoList = new ArrayList<MtReplyWithAgentInfo>();
            for (MtReplyWithAgentInfo mtReplyWithAgentInfo : replyExList) {
                if(mtReplyWithAgentInfo.getReplyUserId()!=null && leaderIdList.contains(mtReplyWithAgentInfo.getReplyUserId())){
                    leaderInfoList.add(mtReplyWithAgentInfo);
                }
            }
            replyExList.removeAll(leaderInfoList);
        }
        //添加告知
        Map<String,String> impartMap = new HashMap<String,String>();
        impartMap.put("creatUser", String.valueOf(bean.getCreateUser()));
        impartMap.put("emcee", String.valueOf(bean.getEmceeId()));
        impartMap.put("recorder",String.valueOf(bean.getRecorderId()));
        List<Long> conferees = mtMeetingManager.getConfereeIds(bean.getConferees(), bean.getCreateUser(), bean.getEmceeId(), bean.getRecorderId());
        List<MtReplyWithAgentInfo> impartExList =  getImpartMemberIds(bean.getImpart(), conferees, impartMap);
        // 邀请时选人界面过滤人员
        List<MtReplyWithAgentInfo> excludeReplyExList = new ArrayList<MtReplyWithAgentInfo>();
        if(replyExList != null)
            excludeReplyExList.addAll(replyExList);
        if(replyLeaderExList != null)
            excludeReplyExList.addAll(replyLeaderExList);
        if (impartExList.size() > 0) {
            excludeReplyExList.addAll(impartExList);
        }
        MtReplyWithAgentInfo emcee = new MtReplyWithAgentInfo();
        emcee.setReplyUserId(bean.getEmceeId());
        excludeReplyExList.add(emcee);
        if(bean.getRecorderId() != null && !bean.getEmceeId().equals(bean.getRecorderId())){
            MtReplyWithAgentInfo recorder = new MtReplyWithAgentInfo();
            recorder.setReplyUserId(bean.getRecorderId());
            excludeReplyExList.add(recorder);
        }
        // 会议类型
        MeetingType mt = meetingTypeManager.getMeetingTypeById(bean.getMeetingTypeId());
        mav.addObject("meetingTypeName", mt == null ? "" : mt.getName());
        Object[] feedbackUsers = mtMeetingManager.getMtReplyUsersByFeedback(bean, replyExList);
        String affairId = request.getParameter("affairId");
        if(Strings.isNotBlank(affairId)) {
            CtpAffair affair = affairManager.get(Long.valueOf(affairId));
            if(affair != null) {
                if(affair.getMemberId().longValue() != userId.longValue()) {
                    proxy = Constants.PASSIVE_AGENT_FLAG;
                    proxyId = String.valueOf(affair.getMemberId());
                }
            }
        } 
        boolean viewAsAgent = Constants.PASSIVE_AGENT_FLAG.equals(proxy) && Strings.isNotBlank(proxyId);
        MtReply reply_1 = null;
        Long memberId = viewAsAgent ? NumberUtils.toLong(proxyId) : userId;
        list_allReply.get(memberId);
        if(list_allReply.get(memberId) != null) {
            mav.addObject("myReply", list_allReply.get(memberId) );
        }
        // 当创建人为与会人时，允许创建人又回执选项
        String replyFlag = "false"; // 标志创建人是否可以回执

        //添加告知
        List<Long> imparts = mtMeetingManager.getCurrentMemberIds(bean.getImpart(),conferees,impartMap);
        List<Long> impartAgents = new ArrayList<Long>();
        if (imparts != null) {
            for(Long member : imparts) {
                Long agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), member);
                if(agentId != null && !impartAgents.contains(agentId)){
                    impartAgents.add(agentId);
                }
            }
        }
        if((bean.getState()==Constants.DATA_STATE_SEND || bean.getState()==Constants.DATA_STATE_START )&& conferees != null) {
            if(!userId.equals(bean.getCreateUser()) ) {
                if(userId.longValue() == bean.getEmceeId().longValue() 
                		|| userId.longValue()==bean.getRecorderId().longValue()) {
                    replyFlag = "true";
                } else {
                	for(CtpAffair affair : affairList){
                		if(affair.getMemberId() != null && affair.getMemberId().equals(memberId)){
                			if(!affair.isDelete() && !"inform".equals(affair.getNodePolicy())) {
                				replyFlag = "true";
                			}
                		}
                	}
                }
            }
            //判断当前是与会人或者告知人(无代理人判断)
            boolean isConferesOrImpart = (conferees.contains(userId) || imparts.contains(userId) || impartAgents.contains(userId));
            //by wuxiaoju OA-109695会议发起人作为与会人员，查看待开会议的时候不能回执
            if("false".equals(replyFlag) && isConferesOrImpart) {   // && userId.longValue() !=  bean.getCreateUser().longValue()
                replyFlag = "true";
            }else if(!"-1".equals(proxyId) && NumberUtils.isNumber(proxyId) &&
                    "false".equals(replyFlag) && userId.equals(bean.getCreateUser())){//特殊情况：如果会议的发起人也是某个人的代理人，那么他也可以回执 OA-22517
                Long agent = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.meeting.key(), Long.parseLong(proxyId));
                if(null != agent && agent.equals(userId))
                    replyFlag = "true";
            }else if(!"-1".equals(proxyId) && NumberUtils.isNumber(proxyId) &&
                    Long.parseLong(proxyId)==bean.getRecorderId().longValue() &&
                    !bean.getRecorderId().equals(bean.getCreateUser())){//修复记录人的代理人不能回执的错误。（记录人是单独的，不是发起人）OA-51450
                replyFlag = "true";
            }else if(!"-1".equals(proxyId) && NumberUtils.isNumber(proxyId) &&
                    Long.parseLong(proxyId)==bean.getEmceeId().longValue() &&
                    !bean.getEmceeId().equals(bean.getCreateUser())){//修复主持人的代理人不能回执的错误。（主持人是单独的，不是发起人）OA-51450
                replyFlag = "true";
            }

            //特殊情况：代理的是会议的发起人（是主持人或记录人），这个被代理的发起人如果不是参会人，代理人也是不能回执的OA-23881
            if(!"-1".equals(proxyId) && NumberUtils.isNumber(proxyId) &&  "true".equals(replyFlag) &&
                    bean.getCreateUser().longValue()==Long.parseLong(proxyId) && !conferees.contains(Long.parseLong(proxyId))){
                replyFlag = "false";
            }
        }
        
        //前端是否可以回执标识
        if("true".equals(request.getParameter("isQuote"))
                || "report".equals(openfrom)
                //协同立方
                || "1".equals(request.getParameter("isCollCube"))) {
            
            replyFlag = "false";
        }
        mav.addObject("replyFlag", replyFlag);

        // 获取与会资源信息，将其拼起传到前台显示。(公共资源插件判断)
        List<String> recourceNameList = new ArrayList<String>();
       
        List<MeetingMemberStateVO> list_resultMember = new ArrayList<MeetingMemberStateVO>();
        if(bean.getState() != null && bean.getState().intValue() == MeetingStateEnum.save.key()){//待发
        	mav.addObject("waitSendImparts",imparts);
        }else{
        	//获取告知人列表
        	MeetingMemberStateVO memberStateVo;
        	MeetingMemberVO memberVo = meetingManager.getAllTypeMember(bean.getId(), bean);
        	List<Long> meetingImparts = memberVo.getImpart();
        	
        	for(Long impart : meetingImparts){
        		memberStateVo = new MeetingMemberStateVO();
        		memberStateVo.setUserId(impart);
        		if(list_allReply.get(impart) != null){
        			if (list_allReply.get(impart).getFeedbackFlag() == Constants.FEEDBACKFLAG_IMPART) {//已处理
        				memberStateVo.setLookState("3");
        			} else {
        				memberStateVo.setLookState("1");
        			}
        		}else{
        			memberStateVo.setLookState("0");
        		}
        		list_resultMember.add(memberStateVo);
        		
        		if(isImpart && Strings.isNotBlank(proxyId) && proxyId.equals(String.valueOf(impart))){
        			isImpart = false;
                }  
        	}
        	mav.addObject("affairImparts", list_resultMember);
        }

        if(bean.getProjectId() != null && !com.seeyon.ctp.common.constants.Constants.GLOBAL_NULL_ID.equals(bean.getProjectId())) {
            
            if(AppContext.hasPlugin("project")){
                ProjectBO project = projectApi.getProject(bean.getProjectId());
                if(project != null && ProjectBO.STATE_DELETE != project.getProjectState()){
                    mav.addObject("projectName", project.getProjectName());
                }
            }
        }

        for(CtpAffair affair : affairList){
        	if(affair.getMemberId() != null && affair.getMemberId().equals(bean.getRecorderId())){
        		mav.addObject("recorderAffair", affair);
        	}else if(affair.getMemberId() != null && affair.getMemberId().equals(bean.getEmceeId())){
        		mav.addObject("emceeAffair", affair);
        	}
        }
        
        //当发起人不在会议过滤人员中时，添加过滤掉会议发起人 by wuxiaoju
        List<Long> memberIdList = new ArrayList<Long>();
        for (MtReplyWithAgentInfo excludeReplyEx : excludeReplyExList) {
            memberIdList.add(excludeReplyEx.getReplyUserId());
        }
        if (!memberIdList.contains(bean.getCreateUser())) {
            MtReplyWithAgentInfo create = new MtReplyWithAgentInfo();
            create.setReplyUserId(bean.getCreateUser());
            create.setReplyUserName(bean.getCreateUserName());
            excludeReplyExList.add(create);
        }
        //当发起人不在会议过滤人员中时，添加过滤掉会议发起人 end

        //添加会议资源
        List<MeetingResources> recourceList = meetingResourcesManager.getMeetingResourceListByMeetingId(bean.getId());
        if(Strings.isNotEmpty(recourceList)) {
            List<Long> resourceIdList = new ArrayList<Long>();
            for(MeetingResources resources : recourceList) {
                resourceIdList.add(resources.getResourceId());
            }
            Map<Long, PublicResource> resourceMap = publicResourceManager.getResourceMapById(resourceIdList);
            String resourcesName="";
            for (PublicResource resourcesNameVo : resourceMap.values()){
                resourcesName += resourcesNameVo.getName() + ",";
            }
            bean.setResourcesName(resourcesName.substring(0, resourcesName.length() - 1));
        }
        
        //重要会议的六项要根据会议分类的设置来显示
        mav.addObject("mtch", meetingTypeRecordManager.getTypeRecordByMeetingId(bean.getId()));

        //会议告知人没有被排除
        Set<Long> impartUserId = new HashSet<Long>();
        for (MeetingMemberStateVO impartEx : list_resultMember) {
        	impartUserId.add(impartEx.getUserId());
        }
        for(Iterator<MtReplyWithAgentInfo> it = replyExList.iterator();it.hasNext();){
        	MtReplyWithAgentInfo r = it.next();
        	if(impartUserId.contains(r.getReplyUserId())){
        		it.remove();
        	}
        }
        mav.addObject("recourceNameList", recourceNameList);
        mav.addObject("bean", bean);
        mav.addObject("id", idStr);
        mav.addObject("replyExList", replyExList);
        mav.addObject("replyLeaderExList", replyLeaderExList);
        mav.addObject("excludeReplyExList", excludeReplyExList);

        mav.addObject("feedbackUsers", feedbackUsers);

        //参会情况计数
        int[] itemCount = new int[feedbackUsers.length];
        for(int i=0;i<feedbackUsers.length;i++){
            List<?> fl = (List<?>)feedbackUsers[i];
            itemCount[i] = fl.size();
        }
        mav.addObject("itemCount", itemCount);
        if(bean != null) {
            List<Attachment> sattachments = attachmentManager.getByReference(bean.getId(), reply_1 != null ? reply_1.getId() : 0L);
            if(sattachments != null && sattachments.size() != 0) {
                mav.addObject("attachments", sattachments);
            }
        }
        //会议类型中的具体项
        MeetingType meetingType = meetingTypeManager.getMeetingTypeById(bean.getMeetingTypeId());
        String content = "";
        if(meetingType != null)
            content = meetingType.getContent();
        if(Strings.isNotBlank(content)){
            String[] ids = content.split(",");
            for(int i=0;i<ids.length;i++){
                int key = Integer.parseInt(ids[i]);

                MeetingContentEnum[] enums = MeetingContentEnum.values();
                if (enums != null) {
                    for (MeetingContentEnum enum1 : enums) {
                        if (enum1.getKey() == key) {
                            mav.addObject(enum1.name(), "true");
                        }
                    }
                }
            }
        }
        //参会领导
        if(Strings.isNotBlank(bean.getLeader())){
            //bu wuxiaoju 存在参会领导时，会议详情页面右边查看栏报错
            String leaderName = MeetingOrgHelper.getMemberNames(bean.getLeader());
            if (Strings.isNotBlank(leaderName)) {
                String[] leaders = leaderName.split(",");
                mav.addObject("leaders", leaders);
            }
        }

        mav.addObject("proxy", proxy);
        mav.addObject("proxyId", proxyId);
        mav.addObject("isImpart",isImpart);
        
        boolean showInviting = false;
        boolean isQuote = "true".equals(request.getParameter("isQuote"));
        boolean isConferees = bean.getConferees().contains(String.valueOf(user.getId()));
        if(!isImpart && !isQuote && (bean.getState() == 10 || bean.getState() == 20) && bean.getRoomState() != 0 && bean.getRoomState() != 2){
        	//发起人、主持人、记录人、处理代理人
        	boolean isInMeeting = (bean.getCreateUser().longValue() == userId) || (bean.getEmceeId().longValue() == userId) || (bean.getRecorderId()!=null && bean.getRecorderId().longValue() == userId) || (!MeetingUtil.isIdBlank(proxyId) && Long.parseLong(proxyId) == userId);
        	if(isConferees || isInMeeting) {
        		showInviting = true;
        	}
        	if(!showInviting) {
        		for(CtpAffair affair : affairList){
        			if(affair.getMemberId() != null && affair.getMemberId().equals(userId)){
        				//非告知人 && 会议中一员
        				if(!"inform".equals(affair.getNodePolicy()) && affair.getMemberId().longValue() == userId.longValue()) {
        					showInviting = true;
        				}
        			}
        		}
        	}
        }
        mav.addObject("showInviting", showInviting);
        
        return mav;
    }

    /**
     *  获取会议目标为除otherMemberIds 的全体与会人员ID集合，未对代理人进行处理
     * @param currentMemberIds Type|Ids
     * @param otherMemberIds
     * @return
     */
    public List<MtReplyWithAgentInfo> getImpartMemberIds(String currentMemberIds,List<Long> conferees,Map<String,String> otherMemberIds) {

        List<MtReplyWithAgentInfo> memberIds = new ArrayList<MtReplyWithAgentInfo>();
        if (Strings.isNotBlank(currentMemberIds)) {
            Set<V3xOrgMember> orgMember = null;
            try {
                orgMember = this.orgManager.getMembersByTypeAndIds(currentMemberIds);
                if(orgMember!=null && orgMember.size()>0) {
                    for(V3xOrgMember member : orgMember) {
                        Long memberId = member.getId();
                        if(otherMemberIds.containsValue(memberId) && conferees.contains(memberId)) {
                            continue;
                        }
                        MtReplyWithAgentInfo exMr = new MtReplyWithAgentInfo();
                        exMr.setReplyUserId(member.getId());
                        memberIds.add(exMr);
                    }
                }
            } catch(Exception e) {
                log.error("获取会议目标为除otherMemberIds 的全体与会人员ID集合，未对代理人进行处理", e);
            }
        }
        return memberIds;
    }

    //private static MtMeetingComparator mtMeetingComparator = new MtMeetingComparator();

    // 一个部门、组...根据sortId排序
    /*private static class MtMeetingComparator implements Comparator<V3xOrgMember> {

        public int compare(V3xOrgMember m1, V3xOrgMember m2) {
            return m1.getSortId().compareTo(m2.getSortId());
        }
    }*/

    /**
     * 获取会议的参会领导,不包括主持人、记录人
     */
    private List<V3xOrgMember> getReplyLeader(MtMeeting meeting) {
        return mtMeetingManager.getMtMembersByStrValue(meeting.getEmceeId(), meeting.getRecorderId(), meeting.getLeader());
    }

    /**
     * 获取参会人员和参会领导集合，不包括会议主持和会议记录人
     * @Author      : xuqiangwei
     * @Date        : 2014年10月14日下午7:29:34
     * @param meeting
     * @return
     
    private List<V3xOrgMember> getReplyMemberAndLeader(MtMeeting meeting) {

        String typeAndIds = meeting.getConferees();
        if(Strings.isNotBlank(meeting.getLeader())){
            typeAndIds = typeAndIds + "," +meeting.getLeader();
            if(typeAndIds.endsWith(",")){
                typeAndIds = typeAndIds.substring(0, typeAndIds.length()-1);
            }
        }
        return mtMeetingManager.getMtMembersByStrValue(meeting.getEmceeId(), meeting.getRecorderId(), typeAndIds);
    }*/

    public ModelAndView showSummary(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("meeting/user/showSummary");
        //String idStr = request.getParameter("id");
        /*MtSummaryTemplate summary = null;
        List<Attachment> attachments = new ArrayList<Attachment>();
        List<MtSummaryTemplate> list = mtSummaryTemplateManager.findByProperty("meetingId", Long.valueOf(idStr));
        if(list.size() > 0) {
            summary = list.get(0);
            attachments = attachmentManager.getByReference(summary.getId(), summary.getId());
        }
        mav.addObject("attachments", attachments);
        mav.addObject("summary", summary);*/
        return mav;
    }

    public ModelAndView pigeonhole(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String listMethod = request.getParameter("listMethod") == null ? "listMyMeeting" : request.getParameter("listMethod");
        String listType = request.getParameter("listType") == null ? "listMyPublishOpenedMeeting" : request.getParameter("listType");
        String menuId = request.getParameter("menuId") == null ? "2102" : request.getParameter("menuId");
        String ids = request.getParameter("id");
        String folders = request.getParameter("folders");
        MtMeeting bean = null;
        boolean result = true;
        if(StringUtils.isNotBlank(ids)) {
            String[] idA = ids.split(",");
            List<Long> idList = new ArrayList<Long>();
            List<MtMeeting> beans = new ArrayList<MtMeeting>();
            for(String id : idA) {
                if(StringUtils.isNotBlank(id)) {
                    idList.add(Long.valueOf(id));
                }
                bean = meetingManager.getMeetingById(Long.valueOf(id));
                beans.add(bean);
                if(bean.getState() == Constants.DATA_STATE_SAVE || bean.getState() == Constants.DATA_STATE_SEND || bean.getState() == Constants.DATA_STATE_START) {
                    result = false;
                    break;
                }
            }
            if(result) {
                this.mtMeetingManager.pigeonhole(idList);
                if(Strings.isNotBlank(folders)) {
                    User user = AppContext.getCurrentUser();
                    String[] folderArray = folders.split(",");
                    for(int i = 0; i < beans.size(); i++) {
                        Long fid = Long.parseLong(folderArray[i]);
                        DocResourceBO res = docApi.getDocResource(fid);
                        String forderName = docApi.getDocResourceName(res.getParentFrId());
                        appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Meeting_Document, user.getName(), beans.get(i).getTitle(), forderName);
                    }
                }
                // 归档后删除原来的全文检索信息
                //for(Long id : idList) {}
                    //this.indexManager.deleteFromIndex(com.seeyon.ctp.common.constants.ApplicationCategoryEnum.meeting, id);
            } else {
                MeetingException e = new MeetingException("meeting_no_pigeonhole", bean.getTitle());
                request.getSession().setAttribute("_my_exception", e);
                return this.redirectModelAndView("/mtMeeting.do?method=listMain&listMethod=" + listMethod + "&listType=" + listType+"&menuId="+menuId);
            }
        }
        return this.redirectModelAndView("/mtMeeting.do?method=listMain&listMethod=" + listMethod + "&listType=" + listType+"&menuId="+menuId);
    }

    /**
     * 进入关联文档添加页面框架
     */
    public ModelAndView list4QuoteFrame(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("collaboration/list4QuoteFrame");
    }

    /**
     * 我的会议列表左侧菜单页面
     */
    public ModelAndView mymtListLeft(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("meeting/user/mymt_meeting_list_left");
    }

    /**
     * 我的会议列表主页面
     */
    public ModelAndView mymtListHome(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("meeting/user/mymt_homeEntry");
    }

    /**
     * 我的会议列表主页面
     */
    public ModelAndView mymtListMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String from = request.getParameter("from");
        ModelAndView mavin = new ModelAndView("meeting/user/mymt_meeting_list_main");
        mavin.addObject("from", from);
        return mavin;
    }

    /**
     * 意见震荡回复 --xiangfan
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView doComment(HttpServletRequest request, HttpServletResponse response) throws Exception{
        String meetingId = request.getParameter("meetingId");
        String replyId = request.getParameter("replyId");
        String proxyId = Strings.isBlank(request.getParameter("proxyId"))? "" : request.getParameter("proxyId");
        String proxy = "";//格式 '名称|id'
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        
        boolean isHidden = request.getParameterValues("isHidden") != null;
        
        if(Strings.isBlank(replyId)) {
        	String[] replyIds = request.getParameterValues("replyId");
        	if(replyIds.length > 1) {
        		replyId = replyIds[replyIds.length - 1]; 
        	}
        }
        if(Strings.isBlank(replyId) || Strings.isBlank(meetingId)){
            super.rendJavaScript(response, "alert('"+ResourceUtil.getString("meeting.exception.replyError")+"');");
            return null;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());
        MtComment mtComment = new MtComment();
        mtComment.setIdIfNew();
        mtComment.setIsHidden(isHidden);
        if(isHidden){
            String showToIds = request.getParameter("showToId");
            mtComment.setShowToId(showToIds);
        }
        mtComment.setCreateDate(now);
        mtComment.setMeetingId(Long.parseLong(meetingId));
        mtComment.setReplyId(Long.parseLong(replyId));
        mtComment.setContent(request.getParameter("content"));
        
        if(Strings.isNotBlank(proxyId) && NumberUtils.isNumber(proxyId) && !"-1".equals(proxyId)){
            Long lProxyId = Long.parseLong(proxyId);
            if(!userId.equals(lProxyId)){
                V3xOrgMember member = this.orgManager.getMemberById(lProxyId);
                if(member != null){
                    proxy = member.getName() + "|" + proxyId;
                    mtComment.setProxyId(proxyId);
                }
            }
        }
        mtComment.setCreateUserId(userId);
        this.mtMeetingManager.saveComment(mtComment);
        this.attachmentManager.create(ApplicationCategoryEnum.meeting, Long.parseLong(meetingId), mtComment.getId(), request);
        //发送消息所需参数准备
        boolean sendMsg = request.getParameterValues("sendMsg") != null;
        MtReply reply = replyManager.getById(Long.parseLong(replyId));
        MtMeeting meeting = meetingManager.getMeetingById(Long.parseLong(meetingId));
        String messageReceiverStr = "";
        //消息推送人
        if (sendMsg) {
            messageReceiverStr = request.getParameterValues("messageReceiver")[0];
            //给消息推送人、发起人和被回复人发送消息
            MeetingMsgHelper.sendMessage(messageReceiverStr, mtComment, reply, meeting, AppContext.getCurrentUser());
        }
        
        super.rendJavaScript(response, "parent.MtReplyCommentOK('" + Datetimes.formateToLocaleDatetime(now) + "','" + proxy + "')");
        return null;
    }

    /**
     * 会议统计
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView meetingStat(HttpServletRequest request, HttpServletResponse response)throws Exception {
        ModelAndView mav = new ModelAndView("meeting/user/meeting_stat");
        String listType = request.getParameter("listType");
        Long reportId = ReportsEnum.MeetingJoinStatistics.getKey();
        if("meetingRoleStat".equals(listType))
            reportId = ReportsEnum.MeetingJoinRoleStatistics.getKey();
        /*if("meetingReplyStat".equals(listType)) {//统计回执情况
        } else {//统计参与角色
        }*/
        mav.addObject("listType", listType);
        mav.addObject("reportId", reportId);
        return mav;
    }


    public ModelAndView showCommenter(HttpServletRequest request,HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("meeting/user/pushMessageList");
        Long meetingId = Long.parseLong(request.getParameter("meetingId"));
        List<MtReply> lists = new ArrayList<MtReply>();
        List<MtReply> replies = this.replyManager.findByPropertyNoInit("meetingId", meetingId);
        try {
			List<MtReply> meetingPerson = meetingManager.getAllMeetingPersonByMId(meetingId);
			Map<Long,MtReply> replyMap = new HashMap<Long,MtReply>();
			boolean containCreateUser = false;
			MtMeeting meeting = meetingManager.getMeetingById(meetingId);
			for(MtReply reply : replies){
				replyMap.put(reply.getUserId(), reply);
			}
			for(MtReply mr : replies){
			    if(mr.getUserId().longValue() == meeting.getCreateUser().longValue()){
			        containCreateUser = true;
			        break;
			    }
			}
			
			for(MtReply mr : meetingPerson){
				if(!containCreateUser && mr.getUserId().longValue() == meeting.getCreateUser().longValue()){
			        containCreateUser = true;
			    }
				MtReply mtReply = replyMap.get(mr.getUserId());
				if(null!=mtReply){
					lists.add(mtReply);
				}else{
					lists.add(mr);
				}
			}
			
			if(!containCreateUser){
			    MtReply mr = new MtReply(UUIDLong.longUUID(), meeting.getCreateUser(), meetingId, Constants.FEEDBACKFLAG_ATTEND);
			    if(mr.getUserId().longValue() != meeting.getEmceeId() && mr.getUserId().longValue() != meeting.getRecorderId())
			        mr.setType("createUser");//如果只是发起人，需要标注一下，便于前段展示
			    lists.add(mr);
			}
			mav.addObject("meetingCreateUserId", meeting.getCreateUser());
			mav.addObject("meetingRecorderId", meeting.getRecorderId());
			mav.addObject("meetingEmceeId", meeting.getEmceeId());
		//} catch (BusinessException e) {
        } catch (Exception e) {
			log.error("获取会议所有人出错", e);
		}
        return mav.addObject("replyList", lists);
    }

    /**
     * 获取参会领导的信息，不包括记录人和主持人
     * @param bean
     * @param leaderIdList
     * @return  replyExList
     */

    private List<MtReplyWithAgentInfo> getInfoByLeader(MtMeeting bean, List<Long> leaderIdList) {
        List<MtReplyWithAgentInfo> replyExList = new ArrayList<MtReplyWithAgentInfo>();
        List<V3xOrgMember> list = getReplyLeader(bean);
        if(list != null && list.size() != 0) {
            for(V3xOrgMember m : list) {
                if(m == null || m.getIsDeleted())
                    continue;
                leaderIdList.add(m.getId());//保存参会领导ID
                Long agentId = Constants.getAgentId(m.getId());
                if(agentId != null) {
                    V3xOrgMember agentMember = null;
                    try {
                        agentMember = orgManager.getMemberById(agentId);
                    } catch(BusinessException e) {
                        logger.error("", e);
                    }
                    List<MtReply> replys = replyManager.findByMeetingIdAndUserId(bean.getId(), m.getId());
                    MtReplyWithAgentInfo exMr = new MtReplyWithAgentInfo();
                    exMr.setReplyUserId(m.getId());
                    exMr.setReplyUserName(m.getName());
                    if(CollectionUtils.isNotEmpty(replys)) {
                        MtReply reply = replys.get(0);
                        exMr.setFeedbackFlag(reply.getFeedbackFlag());
                        if(Constants.PASSIVE_AGENT_FLAG.equals(reply.getExt1())) {
                            exMr.setAgentId(agentId);
                            exMr.setAgentName(agentMember != null ? agentMember.getName() : "");
                        }
                    } else {
                        exMr.setFeedbackFlag(Constants.FEEDBACKFLAG_NOREPLY);
                        exMr.setAgentId(agentId);
                        exMr.setAgentName(agentMember != null ? agentMember.getName() : "");
                    }
                    replyExList.add(exMr);
                } else {
                    List<MtReply> l = replyManager.findByMeetingIdAndUserId(bean.getId(), m.getId());
                    MtReplyWithAgentInfo exMr = new MtReplyWithAgentInfo();
                    exMr.setFeedbackFlag((l != null && l.size() != 0 && l.get(0).getFeedbackFlag() != null) ? l.get(0).getFeedbackFlag() : Constants.FEEDBACKFLAG_NOREPLY);
                    exMr.setReplyUserId(m.getId());
                    exMr.setReplyUserName(m.getName());
                    replyExList.add(exMr);
                }
            }
        }
        return replyExList;
    }
    /**
     * 会议导出Excel的表头信息
     * @param dr
     * @param bean
     * @return
     * @throws BusinessException
     */
    private String[] getColumnNamesByListType(DataRecord dr,MtMeeting bean,String exportNames) throws BusinessException {

        // 获取本单位ID
        Long currentAccountId = bean.getAccountId();
        // 获取导出用户单位ID
        StringBuilder sb = new StringBuilder();
        Long orgAccountId=null;
        String foreignUnits="";
        String[] split = exportNames.split(",");
        for(int x =0;x<split.length;x++){
            String names = split[x];
            String[] name = names.split("\\|");
            for(int y =0;y<name.length;y++){
                if("Department".equals(name[0])){
                    String id = name[1];
                    List<V3xOrgMember> v3xOrgMember = orgManager.getMembersByDepartment(Long.valueOf(id),false);
                    for(int z =0;z<v3xOrgMember.size();z++){
                        orgAccountId = v3xOrgMember.get(z).getOrgAccountId();
                        sb.append(orgAccountId+",");
                    }
                    break;
                }else if("Account".equals(name[0])){
                    String id = name[1];
                     List<V3xOrgMember> allMembers = orgManager.getAllMembers(Long.valueOf(id));
                    for(int z =0;z<allMembers.size();z++){
                        orgAccountId = allMembers.get(z).getOrgAccountId();
                        sb.append(orgAccountId+",");
                    }
                    break;
                }else if("Post".equals(name[0])){
                    String id = name[1];
                    List<V3xOrgMember> v3xOrgMember = orgManager.getMembersByPost(Long.valueOf(id));
                    for(int z =0;z<v3xOrgMember.size();z++){
                        orgAccountId = v3xOrgMember.get(z).getOrgAccountId();
                        sb.append(orgAccountId+",");
                    }
                    break;
                }else if("Level".equals(name[0])){
                    String id = name[1];
                    List<V3xOrgMember> v3xOrgMember = orgManager.getMembersByLevel(Long.valueOf(id));
                    for(int z =0;z<v3xOrgMember.size();z++){
                        orgAccountId = v3xOrgMember.get(z).getOrgAccountId();
                        sb.append(orgAccountId+",");
                    }
                    break;
                }else if("Team".equals(name[0])){
                    String id = name[1];
                    List<V3xOrgMember> v3xOrgMember = orgManager.getMembersByTeam(Long.valueOf(id));
                    for(int z =0;z<v3xOrgMember.size();z++){
                        orgAccountId = v3xOrgMember.get(z).getOrgAccountId();
                        sb.append(orgAccountId+",");
                    }
                    break;
                }else{
                    String id = name[1];
                    orgAccountId = orgManager.getMemberById(Long.valueOf(id)).getOrgAccountId();
                    sb.append(orgAccountId+",");
                  }
                    break;
                }
        }
        String stringIds = sb.toString();
        String accountIds = stringIds.substring(0, stringIds.length()-1);
        for(String n :accountIds.split(",")){
             //遍历所有人员单位，取出单位ID
             if(!n.equals(String.valueOf(currentAccountId))){
                // 如果不等于当前单位，说明是外单位，跳出循环
                foreignUnits = n;
                break;
             }else{
                 //如果是当前单位，取出单位ID
                foreignUnits = n;
             }
        }
         String[] colNames =null;
         // 如果取出人员的单位名不等于当前单位，说明是外单位，则要显示外单位列
         if(!foreignUnits.equals(String.valueOf(currentAccountId))){
             colNames = new String[8];
          }else{
              //当是当前单位人员的时候，不导出单位列
              colNames = new String[7];
          }

        colNames[0] = ResourceUtil.getString("meeting.export.serialNumber"); // 序号
        colNames[1] = ResourceUtil.getString("meeting.export.name"); // 姓名
        colNames[2] = ResourceUtil.getString("meeting.export.sex"); // 性别
        
        // 如果当前用户和导出用户的单位是一致的，则不导出单位列
        if(!foreignUnits.equals(String.valueOf(currentAccountId))){
            colNames[3] = ResourceUtil.getString("meeting.export.unit"); // 所属单位
            colNames[4] = ResourceUtil.getString("meeting.export.department"); // 所属部门
            colNames[5] = ResourceUtil.getString("meeting.export.phone"); // 手机
            colNames[6] = ResourceUtil.getString("meeting.export.email"); // 邮箱
            colNames[7] = ResourceUtil.getString("meeting.export.workplace"); // 工作地
        }else{
            colNames[3] = ResourceUtil.getString("meeting.export.department"); // 所属部门
            colNames[4] = ResourceUtil.getString("meeting.export.phone"); // 手机
            colNames[5] = ResourceUtil.getString("meeting.export.email"); // 邮箱
            colNames[6] = ResourceUtil.getString("meeting.export.workplace"); // 工作地
        }

        // 会议日期开始时间
        Date beginDate = bean.getBeginDate();
        String meetingDate = Datetimes.formatDate(beginDate);
        String[] date = meetingDate.split("-");
        // 会议日期：
        dr.setSubTitle(ResourceUtil.getString("meeting.export.createDate")+date[0]+ResourceUtil.getString("meeting.export.year")+
                                date[1]+ResourceUtil.getString("meeting.export.month")+date[2]+ResourceUtil.getString("meeting.export.day"));
        //会议名称+参会人名单
        dr.setTitle(bean.getTitle()+ResourceUtil.getString("meeting.export.participants"));
        //会议名称+参会人名单
        dr.setSheetName(bean.getTitle()+ResourceUtil.getString("meeting.export.participants"));

        return colNames;
    }

    /**
     * 导出参会人员（不包括不参加）
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView transExportExcelMeeting(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("id");
        MtMeeting bean = meetingManager.getMeetingById(Long.valueOf(idStr));
        List<Long> leaderIdList = new ArrayList<Long>();// 存放参会领导ID
        // 获取参会领导的信息，不包括主持人和记录人
        List<MtReplyWithAgentInfo> replyLeaderExList = getInfoByLeader(bean, leaderIdList);
        // 获取参会人员 包括主持人和记录人
        List<MtReplyWithAgentInfo> replyExList = mtMeetingManager.getMtReplyInfo2(bean, false);

        DataRecord dr = new DataRecord();

        StringBuilder sb = new StringBuilder();
        
        List<Long> memberIds = new ArrayList<Long>();
        // 遍历所有的参会领导
        for (int x = 0; x < replyLeaderExList.size(); x++) {
            MtReplyWithAgentInfo mtReplyWithAgentInfo = replyLeaderExList.get(x);
            // 去除不参加的参会领导
            if (mtReplyWithAgentInfo.getFeedbackFlag() != 0) {
                // 得到参会人员名字和ID，再拼接
                String replyUserName = mtReplyWithAgentInfo.getReplyUserName();
                Long replyUserId = mtReplyWithAgentInfo.getReplyUserId();
                sb.append(replyUserName + "|" + replyUserId + ",");
                memberIds.add(replyUserId);
            }
        }
        
        // 遍历所有的参会人员
        for (int x = 0; x < replyExList.size(); x++) {
            MtReplyWithAgentInfo mtReplyWithAgentInfo = replyExList.get(x);
            // 去除不参加的参会人员
            if (mtReplyWithAgentInfo.getFeedbackFlag() != 0) {
                // 得到参会人员名字和ID，再拼接
                String replyUserName = mtReplyWithAgentInfo.getReplyUserName();
                Long replyUserId = mtReplyWithAgentInfo.getReplyUserId();
                if (!memberIds.contains(replyUserId)) {
                	sb.append(replyUserName + "|" + replyUserId + ",");
                	memberIds.add(replyUserId);
                }
            }
        }
        
        // 遍历数据，给相应的“单位”赋值
        if (!"".equals(sb.toString())) {
            String exportNames = sb.toString().substring(0, sb.toString().length() - 1);
            String[] colNames = this.getColumnNamesByListType(dr, bean, exportNames);
            dr.setColumnName(colNames);
            String exportName = "";
            // 张三|xxxxx，张三|xxxxx 以“，”分隔
            String[] split = exportNames.split(",");
            if (split.length > 0) {
                DataRow[] datarow = new DataRow[split.length];
                for (int i = 0; i < split.length; i++) {
                    DataRow row = new DataRow();
                    exportName = split[i];
                    // 以“|”分隔，获取每个参会人名字和id
                    String[] split2 = exportName.split("\\|");
                    String name = split2[0];
                    String id = split2[1];
                    
                    V3xOrgMember member = orgManager.getMemberById(Long.valueOf(id));
                    // 遍历标题
                    for (int j = 0; j < colNames.length; j++) {
                        String label = colNames[j];
                        // 序号
                        if (ResourceUtil.getString("meeting.export.serialNumber").equals(label)) {
                            row.addDataCell(String.valueOf(i + 1), 7);
                            // 姓名
                        } else if (ResourceUtil.getString("meeting.export.name").equals(label)) {
                            row.addDataCell(name, 1);
                            // 所属单位
                        } else if (ResourceUtil.getString("meeting.export.unit").equals(label)) {
                            
                            String productFlag = String.valueOf(
                                    SystemProperties.getInstance().getIntegerProperty("system.ProductId"));
                            
                            // 判断是不是集团版
                            Boolean isGroup = "4".equals(productFlag)
                                    || "2".equals(productFlag);
                            if (isGroup) {
                                // 获取导出用户的单位
                                Long departMentId = member.getOrgDepartmentId();
                                Long orgAccountId = orgManager.getDepartmentById(departMentId).getOrgAccountId();
                                String accountName = orgManager.getAccountById(orgAccountId).getName();
                                row.addDataCell(accountName, 1);
                            }
                            // 所属部门
                        } else if (ResourceUtil.getString("meeting.export.department").equals(label)) {
                            Long departMentId = member.getOrgDepartmentId();
                            String departName = orgManager.getDepartmentById(departMentId).getName();
                            row.addDataCell(departName, 1);
                        } else if (ResourceUtil.getString("meeting.export.sex").equals(label)) { //性别
                        	String sex ="";
            				if(member.getGender()!=null){
            					if(V3xOrgEntity.MEMBER_GENDER_MALE==member.getGender()){
            						sex=ResourceUtil.getString("meeting.export.male"); 
            					} else if(V3xOrgEntity.MEMBER_GENDER_FEMALE==member.getGender()){
            						sex=ResourceUtil.getString("meeting.export.female");  
            					}					
            				}
            				row.addDataCell(sex, 1);
                        } else if (ResourceUtil.getString("meeting.export.workplace").equals(label)) {
                        	String workplace = "";
                        	// 工作地
                        	if (member.getLocation() != null ){
                        		workplace = enumManagerNew.parseToName(member.getLocation());
                        	}
                            row.addDataCell(workplace, 1); 
                        } else if (ResourceUtil.getString("meeting.export.phone").equals(label)) {
                        	row.addDataCell(member.getTelNumber(), 1);//手机号
                        } else if (ResourceUtil.getString("meeting.export.email").equals(label)) {
                        	row.addDataCell(member.getEmailAddress(), 1);//email   
                        }
                    }
                    datarow[i] = row;
                }

                dr.addDataRow(datarow);
            }
        }
        // 导出文件名：参会人员名单
        this.fileToExcelManager.save(response, ResourceUtil.getString("meeting.export.participantsName"),
                new DataRecord[] { dr });
        return null;

    }
    
    /****************************** 依赖注入 **********************************/
    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }
    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }
    public void setMtMeetingManager(MtMeetingManager mtMeetingManager) {
        this.mtMeetingManager = mtMeetingManager;
    }
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
    public void setMeetingRoomManager(MeetingRoomManager meetingRoomManager) {
        this.meetingRoomManager = meetingRoomManager;
    }
    
    public void setReplyManager(MtReplyManager replyManager) {
        this.replyManager = replyManager;
    }
    public void setMeetingTypeManager(MeetingTypeManager meetingTypeManager) {
        this.meetingTypeManager = meetingTypeManager;
    }
	public void setMeetingApplicationHandler(MeetingApplicationHandler meetingApplicationHandler) {
		this.meetingApplicationHandler = meetingApplicationHandler;
	}
	public void setMeetingManager(MeetingManager meetingManager) {
		this.meetingManager = meetingManager;
	}
	public void setEnumManagerNew(com.seeyon.ctp.common.ctpenumnew.manager.EnumManager enumManagerNew) {
		this.enumManagerNew = enumManagerNew;
	}
    public void setEdocApi(EdocApi edocApi) {
        this.edocApi = edocApi;
    }
    public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }    
    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }
    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }
	public void setMeetingTypeRecordManager(MeetingTypeRecordManager meetingTypeRecordManager) {
		this.meetingTypeRecordManager = meetingTypeRecordManager;
	}
	public void setTaskmanageApi(TaskmanageApi taskmanageApi) {
		this.taskmanageApi = taskmanageApi;
	}
	public MeetingResourcesManager getMeetingResourcesManager() {
        return meetingResourcesManager;
    }
    public void setMeetingResourcesManager(MeetingResourcesManager meetingResourcesManager) {
        this.meetingResourcesManager = meetingResourcesManager;
    }
    public PublicResourceManager getPublicResourceManager() {
        return publicResourceManager;
    }
    public void setPublicResourceManager(PublicResourceManager publicResourceManager) {
        this.publicResourceManager = publicResourceManager;
    }
	
}
