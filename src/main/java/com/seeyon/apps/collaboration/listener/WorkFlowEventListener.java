////
//// Source code recreated from a .class file by IntelliJ IDEA
//// (powered by Fernflower decompiler)
////
//
//package com.seeyon.apps.collaboration.listener;
//
//import com.alibaba.fastjson.JSONArray;
//import com.seeyon.apps.agent.bo.AgentModel;
//import com.seeyon.apps.agent.bo.MemberAgentBean;
//import com.seeyon.apps.collaboration.bo.DateSharedWithWorkflowEngineThreadLocal;
//import com.seeyon.apps.collaboration.bo.SendCollResult;
//import com.seeyon.apps.collaboration.constants.ColConstant.SendType;
//import com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState;
//import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
//import com.seeyon.apps.collaboration.manager.ColManager;
//import com.seeyon.apps.collaboration.manager.ColMessageManager;
//import com.seeyon.apps.collaboration.manager.ColPubManager;
//import com.seeyon.apps.collaboration.po.ColSummary;
//import com.seeyon.apps.collaboration.po.WorkflowTracePO;
//import com.seeyon.apps.collaboration.trace.dao.TraceDao;
//import com.seeyon.apps.collaboration.trace.enums.WorkflowTraceEnums.workflowTrackType;
//import com.seeyon.apps.collaboration.trace.manager.TraceWorkflowDataManager;
//import com.seeyon.apps.collaboration.util.ColUtil;
//import com.seeyon.apps.doc.api.DocApi;
//import com.seeyon.apps.doc.constants.DocConstants.PigeonholeType;
//import com.seeyon.ctp.common.AppContext;
//import com.seeyon.ctp.common.ModuleType;
//import com.seeyon.ctp.common.appLog.AppLogAction;
//import com.seeyon.ctp.common.appLog.manager.AppLogManager;
//import com.seeyon.ctp.common.authenticate.domain.User;
//import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
//import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
//import com.seeyon.ctp.common.content.affair.AffairData;
//import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
//import com.seeyon.ctp.common.content.affair.AffairManager;
//import com.seeyon.ctp.common.content.affair.AffairUtil;
//import com.seeyon.ctp.common.content.affair.constants.StateEnum;
//import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
//import com.seeyon.ctp.common.content.comment.Comment;
//import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
//import com.seeyon.ctp.common.content.mainbody.MainbodyType;
//import com.seeyon.ctp.common.exceptions.BusinessException;
//import com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE;
//import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
//import com.seeyon.ctp.common.filemanager.manager.FileManager;
//import com.seeyon.ctp.common.i18n.ResourceUtil;
//import com.seeyon.ctp.common.po.affair.CtpAffair;
//import com.seeyon.ctp.common.po.content.CtpContentAll;
//import com.seeyon.ctp.common.po.filemanager.Attachment;
//import com.seeyon.ctp.common.po.filemanager.V3XFile;
//import com.seeyon.ctp.common.po.template.CtpTemplate;
//import com.seeyon.ctp.common.quartz.QuartzHolder;
//import com.seeyon.ctp.common.supervise.enums.SuperviseEnum.EntityType;
//import com.seeyon.ctp.common.supervise.enums.SuperviseEnum.superviseState;
//import com.seeyon.ctp.common.supervise.manager.SuperviseManager;
//import com.seeyon.ctp.common.template.manager.TemplateManager;
//import com.seeyon.ctp.common.track.manager.CtpTrackMemberManager;
//import com.seeyon.ctp.common.usermessage.MessageContent;
//import com.seeyon.ctp.common.usermessage.MessageReceiver;
//import com.seeyon.ctp.common.usermessage.UserMessageManager;
//import com.seeyon.ctp.event.EventDispatcher;
//import com.seeyon.ctp.form.service.FormManager;
//import com.seeyon.ctp.form.service.FormService;
//import com.seeyon.ctp.organization.manager.OrgManager;
//import com.seeyon.ctp.util.DBAgent;
//import com.seeyon.ctp.util.DateUtil;
//import com.seeyon.ctp.util.FlipInfo;
//import com.seeyon.ctp.util.Strings;
//import com.seeyon.ctp.workflow.event.AbstractEventListener;
//import com.seeyon.ctp.workflow.event.EventDataContext;
//import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
//import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;
//import java.sql.SQLException;
//import java.sql.Timestamp;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.HashMap;
//import java.util.HashSet;
//import java.util.Iterator;
//import java.util.List;
//import java.util.Map;
//import java.util.Set;
//import net.joinwork.bpm.engine.wapi.WorkItem;
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//import org.json.JSONException;
//import org.json.JSONObject;
//import org.springframework.util.CollectionUtils;
//
//public class WorkFlowEventListener extends AbstractEventListener {
//    private static Log log = LogFactory.getLog(WorkFlowEventListener.class);
//    public static final Integer WITHDRAW = 1;
//    public static final Integer TAKE_BACK = 2;
//    public static final Integer ADD_INFORM = 3;
//    public static final Integer COL_ASSIGN = 4;
//    public static final Integer INSERT = 5;
//    public static final Integer DELETE = 6;
//    public static final Integer ASSIGN = 7;
//    public static final Integer STETSTOP = 8;
//    public static final Integer COMMONDISPOSAL = 9;
//    public static final Integer CANCEL = 10;
//    public static final Integer ZCDB = 11;
//    public static final Integer AUTODELETE = 12;
//    public static final Integer AUTOSKIP = 13;
//    public static final Integer SPECIAL_BACK_RERUN = 100;
//    public static final Integer SPECIAL_BACK_SUBMITTO = 101;
//    public static final String OPERATION_TYPE = "operationType";
//    public static final String COLSUMMARY_CONSTANT = "ColSummary";
//    public static final String CTPAFFAIR_CONSTANT = "CtpAffair";
//    public static final String AFFAIR_SUB_STATE = "subState";
//    public static final String CURRENT_OPERATE_AFFAIR_ID = "CURRENT_OPERATE_AFFAIR_ID";
//    public static final String CURRENT_OPERATE_MEMBER_ID = "CURRENT_OPERATE_MEMBER_ID";
//    public static final String CURRENT_OPERATE_COMMENT_CONTENT = "CURRENT_OPERATE_COMMENT_CONTENT";
//    public static final String CURRENT_OPERATE_COMMENT_ID = "CURRENT_OPERATE_COMMENT_ID";
//    public static final String CURRENT_OPERATE_SUMMARY_ID = "CURRENT_OPERATE_SUMMARY_ID";
//    public static final String CURRENT_OPERATE_TRACK_FLOW = "CURRENT_OPERATE_TRACK_FLOW";
//    private ColManager colManager;
//    private AffairManager affairManager;
//    private SuperviseManager superviseManager;
//    private WorkTimeManager workTimeManager;
//    private OrgManager orgManager;
//    private UserMessageManager userMessageManager;
//    private ColMessageManager colMessageManager;
//    private CtpTrackMemberManager trackManager;
//    private TemplateManager templateManager;
//    private ColPubManager colPubManager;
//    private AttachmentManager attachmentManager;
//    private WorkflowApiManager wapi;
//    private TraceWorkflowDataManager colTraceWorkflowManager;
//    private TraceDao traceDao;
//    private FormManager formManager;
//    private MainbodyManager contentManager = (MainbodyManager)AppContext.getBean("ctpMainbodyManager");
//    private DocApi docApi;
//    private FileManager fileManager;
//    private AppLogManager appLogManager;
//
//    public WorkFlowEventListener() {
//    }
//
//    public void setDocApi(DocApi docApi) {
//        this.docApi = docApi;
//    }
//
//    public void setAttachmentManager(AttachmentManager attachmentManager) {
//        this.attachmentManager = attachmentManager;
//    }
//
//    public void setContentManager(MainbodyManager contentManager) {
//        this.contentManager = contentManager;
//    }
//
//    public void setFormManager(FormManager formManager) {
//        this.formManager = formManager;
//    }
//
//    public TraceDao getTraceDao() {
//        return this.traceDao;
//    }
//
//    public void setTraceDao(TraceDao traceDao) {
//        this.traceDao = traceDao;
//    }
//
//    public TraceWorkflowDataManager getColTraceWorkflowManager() {
//        return this.colTraceWorkflowManager;
//    }
//
//    public void setColTraceWorkflowManager(TraceWorkflowDataManager colTraceWorkflowManager) {
//        this.colTraceWorkflowManager = colTraceWorkflowManager;
//    }
//
//    public WorkflowApiManager getWapi() {
//        return this.wapi;
//    }
//
//    public void setWapi(WorkflowApiManager wapi) {
//        this.wapi = wapi;
//    }
//
//    public void setUserMessageManager(UserMessageManager userMessageManager) {
//        this.userMessageManager = userMessageManager;
//    }
//
//    public ColMessageManager getColMessageManager() {
//        return this.colMessageManager;
//    }
//
//    public void setColMessageManager(ColMessageManager colMessageManager) {
//        this.colMessageManager = colMessageManager;
//    }
//
//    public void setColManager(ColManager colManager) {
//        this.colManager = colManager;
//    }
//
//    public void setAffairManager(AffairManager affairManager) {
//        this.affairManager = affairManager;
//    }
//
//    public void setSuperviseManager(SuperviseManager superviseManager) {
//        this.superviseManager = superviseManager;
//    }
//
//    public void setWorkTimeManager(WorkTimeManager workTimeManager) {
//        this.workTimeManager = workTimeManager;
//    }
//
//    public void setOrgManager(OrgManager orgManager) {
//        this.orgManager = orgManager;
//    }
//
//    public void setTrackManager(CtpTrackMemberManager trackManager) {
//        this.trackManager = trackManager;
//    }
//
//    public void setTemplateManager(TemplateManager templateManager) {
//        this.templateManager = templateManager;
//    }
//
//    public void setColPubManager(ColPubManager colPubManager) {
//        this.colPubManager = colPubManager;
//    }
//
//    public void setFileManager(FileManager fileManager) {
//        this.fileManager = fileManager;
//    }
//
//    public void setAppLogManager(AppLogManager appLogManager) {
//        this.appLogManager = appLogManager;
//    }
//
//    public String getModuleName() {
//        return "collaboration";
//    }
//
//    public boolean onWorkitemReadyToWait(EventDataContext context) {
//        try {
//            List<WorkItem> workitems = context.getWorkitemLists();
//            Long currentAffairID = (Long)context.getBusinessData("CURRENT_OPERATE_AFFAIR_ID");
//            Iterator var4 = workitems.iterator();
//
//            while(var4.hasNext()) {
//                WorkItem workItem = (WorkItem)var4.next();
//                CtpAffair affair = this.affairManager.getAffairBySubObjectId(workItem.getId());
//                if (affair.getId().equals(currentAffairID)) {
//                    affair.setState(StateEnum.col_pending.getKey());
//                    if (affair.getSubState() == SubStateEnum.col_pending_specialBacked.getKey()) {
//                        affair.setSubState(SubStateEnum.col_pending_specialBackCenter.getKey());
//                    } else {
//                        affair.setSubState(SubStateEnum.col_pending_specialBack.getKey());
//                    }
//
//                    affair.setUpdateDate(new Date());
//                    this.affairManager.updateAffair(affair);
//                }
//            }
//        } catch (Throwable var7) {
//            log.error(var7.getMessage(), var7);
//        }
//
//        return true;
//    }
//
//    public boolean onWorkitemTakeBack(EventDataContext context) {
//        try {
//            CtpAffair affair = this.eventData2ExistingAffair(context);
//            if (affair == null) {
//                return false;
//            }
//        } catch (BusinessException var4) {
//            log.error("", var4);
//        }
//
//        return true;
//    }
//
//    public boolean onWorkitemFinished(EventDataContext eventData) {
//        try {
//            log.info(AppContext.currentUserLoginName() + ",workfloweventliserter.onWorkitemFinished start....  ");
//            CtpAffair affair = (CtpAffair)eventData.getBusinessData("CtpAffair");
//            System.out.println("-----------affairData1--------:"+affair);
//            String subState = (String)eventData.getBusinessData("subState");
//            if (affair == null) {
//                affair = this.affairManager.getAffairBySubObjectId(eventData.getWorkItem().getId());
//            }
//            System.out.println("-----------affairData2--------:"+affair);
//            if (affair == null) {
//                log.error("事项处理WorkFlowEventListener.onWorkitemFinished 获取affair为空，workitemid:" + eventData.getWorkItem().getId());
//                throw new RuntimeException();
//            }
//            System.out.println("-----------flag1--------");
//            boolean isSepicalBackedSubmit = Integer.valueOf(SubStateEnum.col_pending_specialBacked.getKey()).equals(affair.getSubState());
//            User user = AppContext.getCurrentUser();
//            Timestamp now = new Timestamp(System.currentTimeMillis());
//            System.out.println("-----------flag2--------");
//            this.logInfo4WorkItemFinished(affair, user, now);
//
//            affair.setCompleteTime(now);
//            affair.setUpdateDate(now);
//            affair.setState(StateEnum.col_done.key());
//            System.out.println("-----------flag3--------");
//            if (Strings.isNotBlank(subState)) {
//                affair.setSubState(Integer.valueOf(subState));
//            } else {
//                affair.setSubState(SubStateEnum.col_normal.key());
//            }
//            System.out.println("-----------flag3--------");
//            if(AppContext.getCurrentUser()!=null) {
//                if (!affair.getMemberId().equals(AppContext.getCurrentUser().getId())) {
//                    affair.setTransactorId(AppContext.getCurrentUser().getId());
//                }
//            }
//
//            ColSummary summary = null;
//            if (null != eventData.getAppObject()) {
//                summary = (ColSummary)eventData.getAppObject();
//            } else {
//                summary = this.colManager.getColSummaryById(affair.getObjectId());
//            }
//
//            this.setTime2Affair(affair, summary);
//            this.affairManager.updateAffair(affair);
//            ColUtil.deleteCycleRemindQuartzJob(affair, true);
//            Long summaryId = affair.getObjectId();
//            int operationType = (Integer)((Integer)((Integer)eventData.getBusinessData().get("operationType") == null ? -1 : eventData.getBusinessData().get("operationType")));
//            if (operationType == 8) {
//                return true;
//            }
//
//            if (!isSepicalBackedSubmit) {
//                Comment c = (Comment)eventData.getBusinessData().get("comment");
//                if (null != c) {
//                    this.colMessageManager.workitemFinishedMessage(c, affair, summaryId);
//                }
//            }
//        } catch (Throwable var11) {
//            log.error("事项处理WorkFlowEventListener.onWorkitemFinished：", var11);
//            throw new RuntimeException();
//        }
//
//        log.info("workfloweventliserter.onWorkitemFinished end....");
//        return true;
//    }
//
//    private void logInfo4WorkItemFinished(CtpAffair affair, User user, Timestamp now) {
//        StringBuilder sb = new StringBuilder();
//        sb.append("事项ID：").append(affair.getId());
//        sb.append("，WorkItemFinished处理协同时间：").append(now);
//        if (null == user) {
//            sb.append("，处理客户端：pc");
//        } else {
//            sb.append("，处理客户端：").append(user.isFromM1() ? "m1" : "pc");
//            sb.append("，当前用户：").append(user.getName());
//            if (!user.getId().equals(affair.getMemberId())) {
//                List<Long> ownerIds = MemberAgentBean.getInstance().getAgentToMemberId(ModuleType.collaboration.getKey(), user.getId());
//                if (Strings.isNotEmpty(ownerIds) && ownerIds.contains(affair.getMemberId())) {
//                    sb.append("代理校验：True");
//                } else {
//                    sb.append("代理校验：False");
//                }
//            }
//        }
//
//        log.info(sb.toString());
//    }
//
//    public void setTime2Affair(CtpAffair affair, ColSummary summary) throws BusinessException {
//        long runWorkTime = 0L;
//        long orgAccountId = summary.getOrgAccountId();
//        runWorkTime = this.workTimeManager.getDealWithTimeValue(affair.getReceiveTime(), new Date(), orgAccountId);
//        runWorkTime /= 60000L;
//        Long deadline = 0L;
//        Long workDeadline = 0L;
//        if (affair.getDeadlineDate() != null && !Long.valueOf(0L).equals(affair.getDeadlineDate())) {
//            deadline = affair.getDeadlineDate();
//            workDeadline = this.workTimeManager.convert2WorkTime(deadline, orgAccountId);
//        }
//
//        Long overWorkTime = 0L;
//        long runTime;
//        if (workDeadline != null && !Long.valueOf(0L).equals(workDeadline)) {
//            runTime = runWorkTime - workDeadline;
//            overWorkTime = runTime > 0L ? runTime : 0L;
//        }
//
//        runTime = (System.currentTimeMillis() - affair.getReceiveTime().getTime()) / 60000L;
//        Long overTime = 0L;
//        if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
//            Long o = runTime - affair.getDeadlineDate();
//            overTime = o > 0L ? o : 0L;
//        }
//
//        if (affair.getExpectedProcessTime() != null && (new Date()).after(affair.getExpectedProcessTime())) {
//            affair.setCoverTime(true);
//        }
//
//        if (affair.isCoverTime() != null && affair.isCoverTime()) {
//            if (Long.valueOf(0L).equals(overTime)) {
//                overTime = 1L;
//            }
//
//            if (Long.valueOf(0L).equals(overWorkTime)) {
//                overWorkTime = 1L;
//            }
//        }
//
//        affair.setOverTime(overTime);
//        affair.setOverWorktime(overWorkTime);
//        affair.setRunTime(runTime == 0L ? 1L : runTime);
//        affair.setRunWorktime(runWorkTime == 0L ? 1L : runWorkTime);
//    }
//
//    public void setTime2Summary(ColSummary summary) throws BusinessException {
//        if (summary != null) {
//            Long orgAccountId = summary.getOrgAccountId();
//            Date deadLine = summary.getDeadlineDatetime();
//            Long overWorkTime = 0L;
//            Long overTime = 0L;
//            long runTime;
//            if (deadLine != null) {
//                runTime = this.workTimeManager.getDealWithTimeValue(deadLine, new Date(), orgAccountId);
//                overWorkTime = runTime > 0L ? runTime : null;
//                Long o = (System.currentTimeMillis() - deadLine.getTime()) / 60000L;
//                overTime = o > 0L ? o : null;
//            }
//
//            if (summary.isCoverTime() != null && summary.isCoverTime()) {
//                if (Long.valueOf(0L).equals(overTime)) {
//                    overTime = 1L;
//                }
//
//                if (Long.valueOf(0L).equals(overWorkTime)) {
//                    overWorkTime = 1L;
//                }
//            }
//
//            runTime = 0L;
//            long runWorkTime = 0L;
//            Date startDate = summary.getCreateDate();
//            if (null != startDate) {
//                runTime = (System.currentTimeMillis() - startDate.getTime()) / 60000L;
//                runWorkTime = this.workTimeManager.getDealWithTimeValue(startDate, new Date(), orgAccountId);
//                runWorkTime /= 60000L;
//            }
//
//            summary.setOverTime(overTime);
//            summary.setOverWorktime(overWorkTime);
//            summary.setRunTime(runTime == 0L ? 1L : runTime);
//            summary.setRunWorktime(runWorkTime == 0L ? 1L : runWorkTime);
//        }
//    }
//
//    public boolean onProcessFinished(EventDataContext context) {
//        ColSummary colSummary = null;
//
//        try {
//            if (context.getAppObject() != null) {
//                colSummary = (ColSummary)context.getAppObject();
//            }
//
//            if (null == colSummary) {
//                Object o = DateSharedWithWorkflowEngineThreadLocal.getColSummary();
//                if (o != null) {
//                    colSummary = (ColSummary)o;
//                }
//            }
//
//            if (colSummary == null) {
//                colSummary = this.colManager.getColSummaryByProcessId(Long.valueOf(context.getProcessId()));
//            }
//
//            if (colSummary == null && context.getBusinessData("ColSummary") != null) {
//                colSummary = (ColSummary)context.getBusinessData("ColSummary");
//            }
//
//            Integer operationType = (Integer)((Integer)(context.getBusinessData().get("operationType") == null ? -1 : context.getBusinessData().get("operationType")));
//            flowState summaryState = STETSTOP.equals(operationType) ? flowState.terminate : flowState.finish;
//            colSummary.setState(summaryState.ordinal());
//            this.setTime2Summary(colSummary);
//            this.colManager.transSetFinishedFlag(colSummary);
//            this.affairManager.updateFinishFlag(colSummary.getId());
//            User user = AppContext.getCurrentUser();
//            boolean isTemplateHasPrePigholePath = this.colManager.isTemplateHasPrePigholePath(colSummary.getTempleteId());
//            if (colSummary.getArchiveId() != null && !isTemplateHasPrePigholePath) {
//                this.affairManager.updateSentPigeonholeInfo(colSummary.getId(), colSummary.getArchiveId());
//                this.appLogManager.insertLog(user, AppLogAction.Coll_Pigeonhole_delete, new String[]{colSummary.getSubject()});
//            }
//
//            if (Strings.isNotBlank(colSummary.getAdvancePigeonhole())) {
//                try {
//                    JSONObject jo = new JSONObject(colSummary.getAdvancePigeonhole());
//                    String archiveFolder = jo.optString("archiveField", "");
//                    String archiveFieldValue = jo.optString("archiveFieldValue", "");
//                    String isCereateNew = jo.optString("archiveIsCreate", "");
//                    String archiveText = jo.optString("archiveText", "");
//                    boolean isCreateFloder = "true".equals(isCereateNew);
//                    CtpAffair affair = this.affairManager.getSenderAffair(colSummary.getId());
//                    Long archievId = colSummary.getArchiveId();
//                    String StrArchiveFolder = "";
//                    Long realFolderId = archievId;
//                    if (Strings.isNotBlank(archiveFolder)) {
//                        log.error("archiveFolder=" + archiveFolder);
//
//                        try {
//                            StrArchiveFolder = this.formManager.getMasterFieldValue(colSummary.getFormAppid(), colSummary.getFormRecordid(), archiveFolder, true).toString();
//                        } catch (SQLException var24) {
//                            log.error("", var24);
//                        }
//
//                        log.error("StrArchiveFolder=" + StrArchiveFolder);
//                        if (Strings.isNotBlank(StrArchiveFolder)) {
//                            realFolderId = this.docApi.getPigeonholeFolder(archievId, StrArchiveFolder, isCreateFloder);
//                        }
//
//                        if (Strings.isBlank(StrArchiveFolder)) {
//                            StrArchiveFolder = "Temp";
//                            realFolderId = this.docApi.getPigeonholeFolder(archievId, StrArchiveFolder, true);
//                        }
//
//                        if (!archiveFieldValue.equals(StrArchiveFolder) && !"true".equals(archiveText)) {
//                            this.docApi.updatePigehole(Long.parseLong(context.getCurrentUserId()), affair.getId(), ApplicationCategoryEnum.form.key());
//                            this.docApi.moveWithoutAcl(Long.parseLong(context.getCurrentUserId()), affair.getId(), realFolderId);
//                            jo.put("archiveFieldValue", StrArchiveFolder);
//                            colSummary.setAdvancePigeonhole(jo.toString());
//                            ColUtil.addOneReplyCounts(colSummary);
//                            this.colManager.updateColSummary(colSummary);
//                        }
//                    }
//
//                    log.error("realFolderId=" + realFolderId);
//                    if ("true".equals(archiveText)) {
//                        List<CtpContentAll> ctpContentAll = this.contentManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, colSummary.getId());
//                        String archiveTextName = jo.optString("archiveTextName", "");
//                        String archiveKeyword = jo.optString("archiveKeyword", "");
//                        if (((CtpContentAll)ctpContentAll.get(0)).getContent() != null && !"".equals(((CtpContentAll)ctpContentAll.get(0)).getContent())) {
//                            String keyword = null;
//                            if (Strings.isNotBlank(archiveKeyword)) {
//                                keyword = this.formManager.getCollSubjuet(colSummary.getFormAppid(), archiveKeyword, colSummary.getFormRecordid(), (Long)null, 0L, false);
//                            }
//
//                            if (keyword != null && keyword.length() > 85) {
//                                keyword = keyword.substring(0, 85);
//                            }
//
//                            String archiveName = this.makeSubject(archiveTextName, colSummary);
//                            if (archiveName.length() > 85) {
//                                archiveName = archiveName.substring(0, 85) + ".doc";
//                            }
//
//                            List<Attachment> attachment = this.attachmentManager.getByReference(((CtpContentAll)ctpContentAll.get(0)).getContentDataId(), Long.parseLong(((CtpContentAll)ctpContentAll.get(0)).getContent()));
//                            if (!attachment.isEmpty()) {
//                                V3XFile file = this.fileManager.getV3XFile(((Attachment)attachment.get(0)).getFileUrl());
//                                file.setFilename(archiveName);
//                                if (null != realFolderId) {
//                                    this.docApi.attachmentPigeonhole(file, realFolderId, user.getId(), user.getLoginAccount(), true, keyword, PigeonholeType.edoc_account.ordinal());
//                                }
//                            }
//                        }
//                    }
//                } catch (JSONException var25) {
//                    log.error("", var25);
//                }
//            }
//
//            List nodeIds;
//            if (colSummary.getAttachmentArchiveId() != null) {
//                List<Attachment> attachment = this.attachmentManager.getByReference(colSummary.getId(), colSummary.getId());
//                nodeIds = FormService.getAllFormAttsByModuleId(colSummary.getId());
//                Iterator var32;
//                Attachment _Att;
//                V3XFile file;
//                if (Strings.isNotEmpty(nodeIds)) {
//                    var32 = nodeIds.iterator();
//
//                    while(var32.hasNext()) {
//                        _Att = (Attachment)var32.next();
//                        if (_Att.getType() == ATTACHMENT_TYPE.FILE.ordinal()) {
//                            file = this.fileManager.getV3XFile(_Att.getFileUrl());
//                            this.docApi.attachmentPigeonhole(file, colSummary.getAttachmentArchiveId(), user.getId(), user.getLoginAccount(), false, "", PigeonholeType.edoc_account.ordinal());
//                        }
//                    }
//                }
//
//                if (Strings.isNotEmpty(attachment)) {
//                    var32 = attachment.iterator();
//
//                    while(var32.hasNext()) {
//                        _Att = (Attachment)var32.next();
//                        if (_Att.getType() == ATTACHMENT_TYPE.FILE.ordinal()) {
//                            file = this.fileManager.getV3XFile(_Att.getFileUrl());
//                            this.docApi.attachmentPigeonhole(file, colSummary.getAttachmentArchiveId(), user.getId(), user.getLoginAccount(), true, "", PigeonholeType.edoc_account.ordinal());
//                        }
//                    }
//                }
//            }
//
//            this.superviseManager.updateStatusBySummaryIdAndType(superviseState.supervised, colSummary.getId(), EntityType.summary);
//            this.trackManager.deleteTrackMembers(colSummary.getId());
//            String mainCaseId = context.getMainCaseId();
//            nodeIds = context.getMainNextNodeIds();
//            if (Strings.isNotBlank(mainCaseId)) {
//                this.colMessageManager.sendNextPendingNodeMessage(Long.parseLong(mainCaseId), nodeIds);
//            }
//
//            if (!STETSTOP.equals(operationType)) {
//                CollaborationFinishEvent finishEvent = new CollaborationFinishEvent(this);
//                finishEvent.setSummaryId(colSummary.getId());
//                CtpAffair affair = (CtpAffair)context.getBusinessData("CtpAffair");
//                log.info("流程结束触发表单高级事件：affair.getsubject=" + affair.getSubject() + ";" + affair.getId() + ";summaryID=" + colSummary.getId());
//                finishEvent.setAffairId(affair.getId());
//                finishEvent.setBodyType(affair.getBodyType());
//                EventDispatcher.fireEvent(finishEvent);
//            }
//        } catch (NumberFormatException var26) {
//            log.error("", var26);
//        } catch (BusinessException var27) {
//            log.error("", var27);
//        }
//
//        return true;
//    }
//
//    public boolean onWorkitemStoped(EventDataContext context) {
//        WorkItem workitem = context.getWorkItem();
//        CtpAffair affair = (CtpAffair)context.getBusinessData("CtpAffair");
//
//        try {
//            Timestamp now = new Timestamp(System.currentTimeMillis());
//            ColSummary colSummary = this.colManager.getColSummaryByProcessId(Long.valueOf(context.getProcessId()));
//            colSummary.setState(flowState.terminate.ordinal());
//            colSummary.setFinishDate(now);
//            this.colManager.updateColSummary(colSummary);
//            if (affair == null) {
//                affair = this.affairManager.getAffairBySubObjectId(workitem.getId());
//            }
//
//            List<CtpAffair> trackingAndPendingAffairs = this.affairManager.getTrackAndPendingAffairs(affair.getObjectId(), affair.getApp());
//            List<CtpAffair> pendingAffairs = this.affairManager.getAffairs(colSummary.getId());
//            if (!CollectionUtils.isEmpty(pendingAffairs)) {
//                Iterator var8 = pendingAffairs.iterator();
//
//                label91:
//                while(true) {
//                    CtpAffair ctpAffair;
//                    do {
//                        if (!var8.hasNext()) {
//                            break label91;
//                        }
//
//                        ctpAffair = (CtpAffair)var8.next();
//                    } while(ctpAffair.getSubState() != SubStateEnum.col_pending_specialBack.getKey() && ctpAffair.getSubState() != SubStateEnum.col_pending_specialBacked.getKey() && ctpAffair.getSubState() != SubStateEnum.col_pending_specialBackCenter.getKey());
//
//                    trackingAndPendingAffairs.add(ctpAffair);
//                }
//            }
//
//            this.colMessageManager.terminateCancel(workitem, affair, trackingAndPendingAffairs);
//            this.setTime2Affair(affair, colSummary);
//            Map<String, Object> columns = new HashMap();
//            columns.put("state", StateEnum.col_done.key());
//            columns.put("subState", SubStateEnum.col_done_stepStop.key());
//            columns.put("completeTime", now);
//            columns.put("updateDate", now);
//            columns.put("finish", true);
//            columns.put("overWorktime", affair.getOverWorktime());
//            columns.put("runWorktime", affair.getRunWorktime());
//            columns.put("overTime", affair.getOverTime());
//            columns.put("runTime", affair.getRunTime());
//            if (!affair.getMemberId().equals(AppContext.getCurrentUser().getId())) {
//                columns.put("transactorId", AppContext.getCurrentUser().getId());
//            }
//
//            List<CtpAffair> affairsByObjectIdAndState = this.affairManager.getAffairs(affair.getObjectId(), StateEnum.col_pending);
//            Map<String, Map<String, Object>> valueMap = new HashMap();
//            Map<String, List<Long>> whereMap = new HashMap();
//            Iterator var12 = affairsByObjectIdAndState.iterator();
//
//            String key="";
//            while(var12.hasNext()) {
//                CtpAffair _m = (CtpAffair)var12.next();
//                key = _m.getReceiveTime() == null ? "" : _m.getReceiveTime().toString();
//                String expectTime = _m.getExpectedProcessTime() == null ? "" : _m.getExpectedProcessTime().toString();
//                 key = key + expectTime;
//                if (valueMap.get(key) == null) {
//                    this.setTime2Affair(_m, colSummary);
//                    Map<String, Object> v = new HashMap();
//                    v.put("overWorktime", _m.getOverWorktime());
//                    v.put("runWorktime", _m.getRunWorktime());
//                    v.put("overTime", _m.getOverTime());
//                    v.put("runTime", _m.getRunTime());
//                    valueMap.put(key, v);
//                }
//
//                List<Long> ids = (List)whereMap.get(key);
//                if (ids == null) {
//                    ids = new ArrayList();
//                }
//
//                ((List)ids).add(_m.getId());
//                whereMap.put(key, ids);
//            }
//
//            Set<String> s = whereMap.keySet();
//            if (Strings.isNotEmpty(s)) {
//                Iterator var26 = s.iterator();
//
//                label69:
//                while(true) {
//                    List affairIds;
//                    do {
//                        if (!var26.hasNext()) {
//                            break label69;
//                        }
//
//                        key = (String)var26.next();
//                        Map<String, Object> v = (Map)valueMap.get(key);
//                        columns.put("overWorktime", v.get("overWorktime"));
//                        columns.put("runWorktime", v.get("runWorktime"));
//                        columns.put("overTime", v.get("overTime"));
//                        columns.put("runTime", v.get("runTime"));
//                        affairIds = (List)whereMap.get(key);
//                    } while(!Strings.isNotEmpty(affairIds));
//
//                    List<Long>[] affairIdsArray = Strings.splitList(affairIds, 900);
//                    List[] var18 = affairIdsArray;
//                    int var19 = affairIdsArray.length;
//
//                    for(int var20 = 0; var20 < var19; ++var20) {
//                        List<Long> ids = var18[var20];
//                        this.affairManager.update(columns, new Object[][]{{"id", ids}, {"state", StateEnum.col_pending.key()}, {"app", affair.getApp()}});
//                    }
//                }
//            }
//
//            Map<String, Object> columns2 = new HashMap();
//            columns2.put("state", StateEnum.col_sent.key());
//            columns2.put("finish", true);
//            columns2.put("updateDate", now);
//            this.affairManager.update(columns2, new Object[][]{{"objectId", affair.getObjectId()}, {"state", StateEnum.col_waitSend.key()}, {"app", affair.getApp()}});
//            ColUtil.deleteCycleRemindQuartzJob(affair, false);
//        } catch (BusinessException var22) {
//            log.error("更新affair事项出错  " + var22.getMessage(), var22);
//        }
//
//        return true;
//    }
//
//    public boolean onWorkflowAssigned(List<EventDataContext> contextList) {
//        if (Strings.isNotEmpty(contextList)) {
//            AffairData affairData = (AffairData)((EventDataContext)contextList.get(0)).getBusinessData("CTP_AFFAIR_DATA");
//            if (affairData == null) {
//                return true;
//            }
//
//            Timestamp now = DateUtil.currentTimestamp();
//            Boolean isCover = false;
//            ColSummary summary = null;
//            Object summaryObj = ((EventDataContext)contextList.get(0)).getBusinessData("ColSummary");
//            if (summaryObj != null) {
//                summary = (ColSummary)summaryObj;
//            } else {
//                try {
//                    summary = this.colManager.getColSummaryById(affairData.getModuleId());
//                } catch (Exception var52) {
//                    log.error("", var52);
//                }
//            }
//
//            if (null != summary.getAutoRun() && summary.getAutoRun()) {
//                String subject = ResourceUtil.getString("collaboration.newflow.fire.subject", summary.getSubject());
//                affairData.setSubject(subject);
//            } else {
//                affairData.setSubject(summary.getSubject());
//            }
//
//            CtpAffair currentAffair = null;
//            Object currentAffairObj = ((EventDataContext)contextList.get(0)).getBusinessData("CtpAffair");
//            if (currentAffairObj != null) {
//                currentAffair = (CtpAffair)currentAffairObj;
//            }
//
//            isCover = summary.isCoverTime();
//            Boolean isSendMessageContext = ((EventDataContext)contextList.get(0)).isSendMessage();
//            Boolean isSendMessage = true;
//            if (isSendMessageContext != null && !isSendMessageContext) {
//                isSendMessage = false;
//            }
//
//            List<MessageReceiver> receivers = new ArrayList();
//            List<MessageReceiver> receivers1 = new ArrayList();
//            Long currentMemberId = 0L;
//            Object obj = ((EventDataContext)contextList.get(0)).getBusinessData("CURRENT_OPERATE_MEMBER_ID");
//            if (obj != null) {
//                currentMemberId = (Long)obj;
//            } else {
//                currentMemberId = null != AppContext.getCurrentUser() ? AppContext.getCurrentUser().getId() : null;
//            }
//
//            HashSet currentNodesInfoSet = new HashSet();
//
//            try {
//                List<Long> isRepeatAutoSkipAffairIds = new ArrayList();
//                JSONArray autoSkipArray = new JSONArray();
//                Set<Long> colDoneMemberIds = new HashSet();
//                boolean canAnyMerge = summary.getCanAnyMerge() == null ? false : summary.getCanAnyMerge();
//                if (canAnyMerge) {
//                    List<StateEnum> states = new ArrayList();
//                    states.add(StateEnum.col_sent);
//                    states.add(StateEnum.col_done);
//                    List<CtpAffair> affairList = this.affairManager.getAffairs(summary.getId(), states);
//                    Iterator var22 = affairList.iterator();
//
//                    while(var22.hasNext()) {
//                        CtpAffair ctpAffair = (CtpAffair)var22.next();
//                        colDoneMemberIds.add(ctpAffair.getMemberId());
//                    }
//                }
//
//                Date nodeDeaLineRunTime;
//                CtpAffair affair;
//                Date advanceRemindTime;
//                for(Iterator var55 = contextList.iterator(); var55.hasNext(); ColUtil.affairExcuteRemind4Node(affair, affairData.getSummaryAccountId(), nodeDeaLineRunTime, advanceRemindTime)) {
//                    EventDataContext context = (EventDataContext)var55.next();
//                    List<WorkItem> workitems = context.getWorkitemLists();
//                    Long deadline = null;
//                    Long remindTime = null;
//                    int dealTermType = 0;
//                    long dealTermUserId = -1L;
//                    nodeDeaLineRunTime = null;
//                    if (ColUtil.isNotBlank(context.getDealTerm())) {
//                        if (context.getDealTerm().matches("^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d$")) {
//                            nodeDeaLineRunTime = DateUtil.parse(context.getDealTerm(), "yyyy-MM-dd HH:mm");
//                            deadline = this.workTimeManager.getDealWithTimeValue(now, nodeDeaLineRunTime, affairData.getSummaryAccountId());
//                            deadline = deadline / 1000L / 60L;
//                        } else if (context.getDealTerm().matches("^-?\\d+$")) {
//                            deadline = Long.parseLong(context.getDealTerm());
//                            if (null != deadline && 0L != deadline) {
//                                nodeDeaLineRunTime = this.workTimeManager.getCompleteDate4Nature(now, deadline, affairData.getSummaryAccountId());
//                            }
//                        }
//
//                        if (ColUtil.isNotBlank(context.getDealTermType())) {
//                            dealTermType = Integer.parseInt(context.getDealTermType().trim());
//                        }
//
//                        if (ColUtil.isNotBlank(context.getDealTermUserId()) && ColUtil.isLong(context.getDealTermUserId())) {
//                            dealTermUserId = Long.parseLong(context.getDealTermUserId().trim());
//                        }
//                    }
//
//                    if (ColUtil.isNotBlank(context.getRemindTerm())) {
//                        remindTime = Long.parseLong(context.getRemindTerm().trim());
//                    }
//
//                    List<CtpAffair> affairs = new ArrayList(workitems.size());
//                    Long activetyId = null;
//                    int affairCountOneNode = workitems.size();
//                    Iterator var32 = workitems.iterator();
//
//                    while(var32.hasNext()) {
//                        WorkItem workitem = (WorkItem)var32.next();
//                        Long memberId = Long.parseLong(workitem.getPerformer());
//                        if (!"zhihui".equals(context.getPolicyId()) && !"inform".equals(context.getPolicyId()) && currentNodesInfoSet.size() < 10) {
//                            currentNodesInfoSet.add(memberId);
//                        }
//
//                         affair = new CtpAffair();
//                        affair.setPreApprover(currentMemberId);
//                        affair.setIdIfNew();
//                        affair.setTrack(0);
//                        affair.setDelete(false);
//                        affair.setSubObjectId(workitem.getId());
//                        affair.setMemberId(memberId);
//                        affair.setSenderId(affairData.getSender());
//                        affair.setSubject(summary.getSubject());
//                        affair.setAutoRun(summary.getAutoRun());
//                        String policyId = context.getPolicyId();
//                        if (policyId != null) {
//                            policyId = policyId.replaceAll(new String(new char[]{' '}), " ");
//                        }
//
//                        affair.setNodePolicy(policyId);
//                        affair.setFromId(ColUtil.isNotBlank(context.getAddedFromId()) ? Long.valueOf(context.getAddedFromId()) : null);
//                        affair.setFromType(ColUtil.isNotBlank(context.getAddedFromType()) ? Integer.valueOf(context.getAddedFromType()) : null);
//                        int operationType = (Integer)((Integer)((Integer)context.getBusinessData().get("operationType") == null ? 12 : context.getBusinessData().get("operationType")));
//                        if (operationType == WITHDRAW || operationType == SPECIAL_BACK_RERUN) {
//                            affair.setBackFromId(AppContext.getCurrentUser().getId());
//                        }
//
//                        AffairUtil.setHasAttachments(affair, affairData.getIsHasAttachment() == null ? false : affairData.getIsHasAttachment());
//                        AffairUtil.setFormReadonly(affair, "1".equals(context.getfR()));
//                        boolean isCompetition = "competition".equals(context.getProcessMode()) && affairCountOneNode > 1;
//                        boolean isSelectPeople = context.isSelectPeople();
//                        boolean isSystemAdd = context.isSystemAdd();
//                        boolean isNeedAutoSkip = DateSharedWithWorkflowEngineThreadLocal.isNeedAutoSkip();
//                        boolean isCanAutoDeal = true;
//                        boolean isBacked = affair.getBackFromId() != null;
//                        boolean isAddNode = affair.getFromId() != null;
//                        boolean isSummaryCanNotMerge = summary.getCanMergeDeal() == null || !summary.getCanMergeDeal();
//                        boolean isModifyWorkflowModel = context.isModifyWorkflowModel();
//                        boolean isHandDeal = isAddNode || isSelectPeople || isSystemAdd || isBacked || isCompetition || !isNeedAutoSkip || isSummaryCanNotMerge || isModifyWorkflowModel;
//                        Long agentId = null;
//                        if (!isSummaryCanNotMerge || canAnyMerge) {
//                            agentId = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.collaboration.getKey(), memberId, summary.getTempleteId());
//                        }
//
//                        StringBuilder sb = new StringBuilder();
//                        if (!currentMemberId.equals(memberId) && !currentMemberId.equals(agentId) || isHandDeal) {
//                            sb.append("_________________________不能自動跳過>isHandDeal:" + isHandDeal);
//                            isCanAutoDeal = false;
//                        }
//
//                        Boolean isAnyMergeAgentSkip = false;
//                        if (!isHandDeal && canAnyMerge && !colDoneMemberIds.isEmpty()) {
//                            isCanAutoDeal = colDoneMemberIds.contains(memberId);
//                            if (!isCanAutoDeal && agentId != null) {
//                                isCanAutoDeal = colDoneMemberIds.contains(agentId);
//                                if (isCanAutoDeal) {
//                                    isAnyMergeAgentSkip = true;
//                                }
//                            }
//
//                            sb.append("_________________________contains:" + isCanAutoDeal);
//                        }
//
//                        if (!isCanAutoDeal && (canAnyMerge || !isSummaryCanNotMerge && currentMemberId.equals(memberId))) {
//                            sb.append("isCanAutoDeal：").append(isCanAutoDeal).append("\r\n");
//                            sb.append("affairId:").append(affair.getId()).append("\r\n");
//                            sb.append("PARAMETER:").append("\r\n");
//                            sb.append("isAddNode:").append(isAddNode).append("\r\n");
//                            sb.append("isSelectPeople:").append(isSelectPeople).append("\r\n");
//                            sb.append("isSystemAdd:").append(isSystemAdd).append("\r\n");
//                            sb.append("isBacked:").append(isBacked).append("\r\n");
//                            sb.append("isCompetition:").append(isCompetition).append("\r\n");
//                            sb.append("!isNeedAutoSkip:").append(!isNeedAutoSkip).append("\r\n");
//                            sb.append("isSummaryCanMerge:").append(isSummaryCanNotMerge).append("\r\n");
//                            sb.append("canAnyMerge:").append(!canAnyMerge).append("\r\n");
//                            sb.append("isModifyWorkflowModel:").append(isModifyWorkflowModel).append("\r\n");
//                            log.info(sb.toString());
//                        }
//
//                        if (isCanAutoDeal) {
//                            com.alibaba.fastjson.JSONObject jo = new com.alibaba.fastjson.JSONObject();
//                            jo.put("affairId", affair.getId().toString());
//                            isRepeatAutoSkipAffairIds.add(affair.getId());
//                            if ((isSummaryCanNotMerge || !currentMemberId.equals(agentId)) && !isAnyMergeAgentSkip) {
//                                jo.put("skipAgentId", "0");
//                            } else {
//                                jo.put("skipAgentId", agentId.toString());
//                            }
//
//                            autoSkipArray.add(jo);
//                        }
//
//                        affair.setState(isCanAutoDeal ? StateEnum.col_pending_repeat_auto_deal.getKey() : affairData.getState());
//                        affair.setSubState(SubStateEnum.col_pending_unRead.key());
//                        affair.setObjectId(affairData.getModuleId());
//                        affair.setDeadlineDate(deadline);
//                        affair.setFormRelativeQueryIds(context.getQueryIds());
//                        affair.setFormRelativeStaticIds(context.getStatisticsIds());
//                        String dr = context.getDR();
//                        affair.setRelationDataId(Strings.isBlank(dr) ? null : Long.valueOf(dr));
//                        affair.setDealTermType(dealTermType);
//                        affair.setDealTermUserid(dealTermUserId);
//                        affair.setRemindDate(remindTime);
//                        affair.setReceiveTime(now);
//                        affair.setApp(affairData.getModuleType());
//                        if (Strings.equals(affair.getApp(), ApplicationCategoryEnum.collaboration.key())) {
//                            affair.setSubApp(affairData.getTemplateId() == null ? ApplicationSubCategoryEnum.collaboration_self.key() : ApplicationSubCategoryEnum.collaboration_tempate.key());
//                        }
//
//                        affair.setCreateDate((Date)(affairData.getCreateDate() == null ? now : affairData.getCreateDate()));
//                        affair.setExpectedProcessTime(nodeDeaLineRunTime);
//                        affair.setTempleteId(affairData.getTemplateId());
//                        affair.setImportantLevel(affairData.getImportantLevel());
//                        affair.setResentTime(affairData.getResentTime());
//                        affair.setForwardMember(affairData.getForwardMember());
//                        affair.setBodyType(affairData.getContentType());
//                        affair.setMultiViewStr(context.getOperationm());
//                        activetyId = Long.parseLong(workitem.getActivityId());
//                        affair.setActivityId(activetyId);
//                        affair.setProcessId(workitem.getProcessId());
//                        affair.setCaseId(workitem.getCaseId());
//                        affair.setOrgAccountId(affairData.getOrgAccountId());
//                        if (String.valueOf(MainbodyType.FORM.getKey()).equals(affairData.getContentType())) {
//                            if (ColUtil.isNotBlank(context.getFormApp())) {
//                                affair.setFormAppId(Long.valueOf(context.getFormApp()));
//                            }
//
//                            if (ColUtil.isNotBlank(context.getForm())) {
//                                affair.setFormId(Long.valueOf(context.getForm()));
//                            }
//
//                            affair.setFormRecordid(summary.getFormRecordid());
//                            if (ColUtil.isNotBlank(context.getOperationName())) {
//                                affair.setFormOperationId(Long.valueOf(context.getOperationName()));
//                            }
//                        }
//
//                        if (!isSendMessage) {
//                            DateSharedWithWorkflowEngineThreadLocal.addToAffairMap(memberId, affair.getId());
//                        }
//
//                        affair.setFinish(false);
//                        affair.setCoverTime(false);
//                        affair.setDueRemind(false);
//                        if (affairData.getProcessDeadlineDatetime() != null) {
//                            AffairUtil.addExtProperty(affair, AffairExtPropEnums.processPeriod, affairData.getProcessDeadlineDatetime());
//                        }
//
//                        affairs.add(affair);
//                        if (isSendMessage && !isCanAutoDeal) {
//                            this.colMessageManager.getReceiver(affair, affair.getApp(), receivers, receivers1);
//                        }
//                    }
//
//                    affairData.setIsSendMessage(isSendMessage);
//                    if (affairData.getAffairList() != null) {
//                        affairData.getAffairList().addAll(affairs);
//                    } else {
//                        affairData.setAffairList(affairs);
//                    }
//
//                    affair = (CtpAffair)affairs.get(0);
//                    advanceRemindTime = null;
//                    if (remindTime != null && !Long.valueOf(-1L).equals(remindTime) && affair.getExpectedProcessTime() != null) {
//                        advanceRemindTime = this.workTimeManager.getRemindDate(nodeDeaLineRunTime, remindTime);
//                    }
//                }
//
//                this.saveListMap(affairData, now, isCover, receivers, receivers1);
//                Long currentCommentId = 0L;
//                Object commentObj = ((EventDataContext)contextList.get(0)).getBusinessData("CURRENT_OPERATE_COMMENT_ID");
//                if (commentObj != null && !summary.getCanAnyMerge()) {
//                    currentCommentId = (Long)commentObj;
//                }
//
//                if (Strings.isNotEmpty(isRepeatAutoSkipAffairIds)) {
//                    String policyName = "";
//                    if (currentAffair != null) {
//                        policyName = ColUtil.getPolicyByAffair(currentAffair).getName();
//                    }
//
//                    DateSharedWithWorkflowEngineThreadLocal.addRepeatAffairs("_commentId", String.valueOf(currentCommentId));
//                    DateSharedWithWorkflowEngineThreadLocal.addRepeatAffairs("_policyName", policyName);
//                    DateSharedWithWorkflowEngineThreadLocal.addRepeatAffairs("isAnyMerge", String.valueOf(canAnyMerge));
//                    DateSharedWithWorkflowEngineThreadLocal.addRepeatAffairs("count", "0");
//                    DateSharedWithWorkflowEngineThreadLocal.addRepeatAffairs("_isAffairAutotSkip", "1");
//                    String skipJsonString = autoSkipArray.toJSONString();
//                    DateSharedWithWorkflowEngineThreadLocal.addRepeatAffairs("skipJsonString", skipJsonString);
//                }
//
//                if (summaryObj == null) {
//                    ColUtil.updateCurrentNodesInfo(summary);
//                    this.colManager.updateColSummary(summary);
//                }
//            } catch (Exception var53) {
//                log.error("DATA_FORMAT_ERROR", var53);
//                throw new RuntimeException();
//            }
//        }
//
//        return true;
//    }
//
//    public boolean onWorkitemCanceled(EventDataContext context) {
//        Object reMeToReGoOperationType = context.getBusinessData().get("_ReMeToReGo_operationType");
//        boolean isReToRego = false;
//        if (reMeToReGoOperationType != null) {
//            isReToRego = true;
//        }
//
//        Integer type = (Integer)context.getBusinessData().get("operationType");
//        int operationType = type == null ? 12 : type;
//        WorkItem workitem = context.getWorkItem();
//        if (workitem == null) {
//            DateSharedWithWorkflowEngineThreadLocal.setOperationType(AUTODELETE);
//            operationType = 12;
//        } else if ((operationType == 9 || operationType == 11) && !"competition".equals(context.getProcessMode())) {
//            DateSharedWithWorkflowEngineThreadLocal.setOperationType(AUTODELETE);
//            operationType = 12;
//        }
//
//        if (isReToRego) {
//            operationType = (Integer)reMeToReGoOperationType;
//        }
//
//        Timestamp now = new Timestamp(System.currentTimeMillis());
//        List normalStepBackTargetNodes = context.getNormalStepBackTargetNodes();
//
//        try {
//            if (operationType == TAKE_BACK || operationType == WITHDRAW || operationType == SPECIAL_BACK_RERUN) {
//                List<WorkItem> workItems = context.getWorkitemLists();
//                log.info("[onWorkitemCanceled]进入分支1,workItems.size():" + workItems.size());
//                if (Strings.isNotEmpty(workItems)) {
//                    CtpAffair affair = (CtpAffair)context.getBusinessData("CtpAffair");
//                    if (affair == null) {
//                        affair = this.affairManager.getAffairBySubObjectId(((WorkItem)workItems.get(0)).getId());
//                    }
//
//                    if (affair == null) {
//                        log.info("====affair is null========workItems.get(0).getId():" + ((WorkItem)workItems.get(0)).getId());
//                        return false;
//                    }
//
//                    int maxCommitNumber = 300;
//                    int length = workItems.size();
//                    List<Long> workitemIds = new ArrayList();
//                    List<Long> cancelAffairIds4Doc = new ArrayList();
//                    List<CtpAffair> cancelAffairs = new ArrayList();
//                    int i = 0;
//                    int state = operationType == TAKE_BACK ? StateEnum.col_takeBack.key() : StateEnum.col_stepBack.key();
//                    List<CtpAffair> affairs = this.affairManager.getValidAffairs(ApplicationCategoryEnum.collaboration, affair.getObjectId());
//                    Map<Long, CtpAffair> m = new HashMap();
//                    Iterator var20 = affairs.iterator();
//
//                    while(var20.hasNext()) {
//                        CtpAffair af = (CtpAffair)var20.next();
//                        if (af.getSubObjectId() != null) {
//                            m.put(af.getSubObjectId(), af);
//                        }
//                    }
//
//                    Object currentNodeId = context.getBusinessData().get("CURRENT_OPERATE_AFFAIR_ID");
//                    List<Long> traceList = new ArrayList();
//                    List<CtpAffair> dynamicOldDataAffairList = new ArrayList();
//                    List<WorkflowTracePO> dynamicNewDataWorkflowTraceList = new ArrayList();
//                    Iterator var24 = workItems.iterator();
//
//                    while(true) {
//                        do {
//                            if (!var24.hasNext()) {
//                                if (Strings.isNotEmpty(dynamicOldDataAffairList)) {
//                                    this.colTraceWorkflowManager.deleteBatch(dynamicOldDataAffairList);
//                                }
//
//                                if (Strings.isNotEmpty(dynamicNewDataWorkflowTraceList)) {
//                                    this.colTraceWorkflowManager.saveBatch(dynamicNewDataWorkflowTraceList);
//                                }
//
//                                DateSharedWithWorkflowEngineThreadLocal.addToTraceDataMap("traceData_affair", traceList);
//                                DateSharedWithWorkflowEngineThreadLocal.addToTraceDataMap("traceData_traceType", workflowTrackType.step_back_normal.getKey());
//                                if (!CollectionUtils.isEmpty(cancelAffairIds4Doc) && this.docApi != null) {
//                                    Long userId = 0L;
//                                    if (AppContext.getCurrentUser() != null) {
//                                        userId = AppContext.getCurrentUser().getId();
//                                    }
//
//                                    this.docApi.deleteDocResources(userId, cancelAffairIds4Doc);
//                                }
//
//                                if (Strings.isNotEmpty(cancelAffairs)) {
//                                    ColUtil.deleteQuartzJobForNodes(cancelAffairs);
//                                }
//
//                                return false;
//                            }
//
//                            WorkItem workItem0 = (WorkItem)var24.next();
//                            if (m.keySet().contains(workItem0.getId())) {
//                                CtpAffair af = (CtpAffair)m.get(workItem0.getId());
//                                if (af.getArchiveId() != null) {
//                                    cancelAffairIds4Doc.add(af.getId());
//                                }
//
//                                cancelAffairs.add(af);
//                                boolean isDoneNode = Integer.valueOf(StateEnum.col_done.getKey()).equals(af.getState());
//                                boolean isZCDBNode = Integer.valueOf(StateEnum.col_pending.key()).equals(af.getState()) && Integer.valueOf(SubStateEnum.col_pending_ZCDB.key()).equals(af.getSubState());
//                                boolean isBackNode = af.getId().equals((Long)currentNodeId);
//                                if (isReToRego) {
//                                    Object reMeToReGoStepBackAffair = context.getBusinessData().get("_ReMeToReGo_stepBackAffair");
//                                    if (reMeToReGoStepBackAffair != null) {
//                                        isBackNode = af.getId().equals(((CtpAffair)reMeToReGoStepBackAffair).getId());
//                                    }
//                                }
//
//                                boolean isBackedNode = af.getActivityId() == null ? true : normalStepBackTargetNodes.contains(String.valueOf(af.getActivityId())) || String.valueOf(af.getActivityId()).equals(context.getSelectTargetNodeId());
//                                if (operationType == WITHDRAW || operationType == SPECIAL_BACK_RERUN) {
//                                    dynamicOldDataAffairList.add(af);
//                                }
//
//                                if ((operationType == WITHDRAW || operationType == SPECIAL_BACK_RERUN) && "1".equals(context.getBusinessData("CURRENT_OPERATE_TRACK_FLOW")) && !isBackedNode && (isDoneNode || isBackNode || isZCDBNode)) {
//                                    String isCircleBack = (String)context.getBusinessData("isCircleBack");
//                                    workflowTrackType trackType = workflowTrackType.step_back_normal;
//                                    if (operationType != WITHDRAW) {
//                                        trackType = workflowTrackType.special_step_back_normal;
//                                        if ("1".equals(isCircleBack)) {
//                                            trackType = workflowTrackType.circle_step_back_normal;
//                                        }
//                                    }
//
//                                    WorkflowTracePO workflowTracePO = this.colTraceWorkflowManager.createWorkflowTracePO(af, af.getSenderId(), AppContext.getCurrentUser().getId(), trackType);
//                                    dynamicNewDataWorkflowTraceList.add(workflowTracePO);
//                                    traceList.add(af.getId());
//                                }
//
//                                DateSharedWithWorkflowEngineThreadLocal.addToAllStepBackAffectAffairMap(af.getMemberId(), af.getId());
//                                Long[] arr = new Long[]{af.getId(), (long)af.getState()};
//                                DateSharedWithWorkflowEngineThreadLocal.addToAllSepcialStepBackCanceledAffairMap(af.getMemberId(), arr);
//                            }
//
//                            workitemIds.add(workItem0.getId());
//                            ++i;
//                        } while(i % maxCommitNumber != 0 && i != length);
//
//                        Map<String, Object> params = new HashMap();
//                        params.put("state", state);
//                        params.put("subState", SubStateEnum.col_normal.key());
//                        params.put("updateDate", now);
//                        Object[][] wheres = new Object[][]{{"objectId", affair.getObjectId()}, {"subObjectId", workitemIds}};
//                        this.affairManager.update(params, wheres);
//                        this.logCancelIds(workitemIds);
//                        workitemIds = new ArrayList();
//                    }
//                }
//            }
//
//            CtpAffair affair = this.eventData2ExistingAffair(context);
//            if (affair == null) {
//                log.info("工作流回调，事项被取消onWorkitemCanceled，affair is null");
//                return false;
//            }
//
//            boolean executeSingleUpdate = true;
//            boolean isCompetition = "competition".equals(context.getProcessMode());
//            boolean operationSo = operationType == COMMONDISPOSAL || operationType == ZCDB || operationType == AUTOSKIP || operationType == SPECIAL_BACK_SUBMITTO;
//            String logInfo = "记录删除竞争事项的日志：affair.id:" + affair.getId() + "affair.getObjectId()=" + affair.getObjectId() + ",operationType=" + operationType + ",affair.getActivityId()=" + affair.getActivityId();
//            if (isCompetition && !operationSo) {
//                log.info(logInfo);
//            }
//
//            if (isCompetition && operationSo) {
//                if (isCompetition) {
//                    DateSharedWithWorkflowEngineThreadLocal.setIsProcessCompetion("1");
//                }
//
//                log.info("___IN Competition:" + logInfo);
//                List<CtpAffair> affairs = this.affairManager.getAffairsByObjectIdAndNodeId(affair.getObjectId(), affair.getActivityId());
//                if (!affairs.isEmpty()) {
//                    log.info("___IN Competition Not Empty:size:" + affairs.size() + "," + logInfo);
//                    StringBuilder hql = new StringBuilder();
//                    hql.append("update CtpAffair set state=:state,subState=:subState,updateDate=:updateDate where app=:app and objectId=:objectId and activityId=:activityId AND subObjectId<>:subObjectId");
//                    Map<String, Object> params = new HashMap();
//                    params.put("state", StateEnum.col_competeOver.key());
//                    params.put("subState", SubStateEnum.col_normal.key());
//                    params.put("updateDate", new Date());
//                    params.put("app", affair.getApp());
//                    params.put("objectId", affair.getObjectId());
//                    params.put("app", affair.getApp());
//                    params.put("activityId", affair.getActivityId());
//                    params.put("subObjectId", workitem.getId());
//                    this.affairManager.update(hql.toString(), params);
//                    this.colMessageManager.transCompetitionCancel(workitem, affairs, affair);
//                }
//
//                ColSummary summary = null;
//                Object appObject = context.getAppObject();
//                if (null != appObject) {
//                    summary = (ColSummary)appObject;
//                }
//
//                if (null == summary) {
//                    summary = (ColSummary)DateSharedWithWorkflowEngineThreadLocal.getColSummary();
//                }
//
//                if (summary == null) {
//                    summary = this.colManager.getColSummaryById(affair.getObjectId());
//                }
//
//                if (summary == null) {
//                    return true;
//                }
//
//                if (affair.getState().equals(StateEnum.col_pending.getKey())) {
//                    summary.setCurrentNodesInfo(affair.getMemberId() + "");
//                } else {
//                    summary.setCurrentNodesInfo("");
//                }
//
//                DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
//                return true;
//            }
//
//            if (operationType == 8) {
//                throw new UnsupportedOperationException(affair.getId() + ", " + affair.getSubject());
//            }
//
//            if (operationType == 12) {
//                List<CtpAffair> affairs = new ArrayList();
//                if (context.getWorkitemLists() != null) {
//                    affairs = this.superviseCancel(context.getWorkitemLists(), now);
//                    executeSingleUpdate = false;
//                }
//
//                if (((List)affairs).isEmpty()) {
//                    ((List)affairs).add(affair);
//                }
//
//                this.colMessageManager.superviseDelete(workitem, (List)affairs);
//            }
//
//            if (executeSingleUpdate) {
//                affair.setUpdateDate(now);
//                this.affairManager.updateAffair(affair);
//            }
//        } catch (BusinessException var34) {
//            log.error("", var34);
//        }
//
//        return true;
//    }
//
//    private void logCancelIds(List<Long> workitemIds) {
//        StringBuilder sbItems = new StringBuilder();
//        Long wid;
//        if (Strings.isNotEmpty(workitemIds)) {
//            for(Iterator var3 = workitemIds.iterator(); var3.hasNext(); sbItems.append(wid)) {
//                wid = (Long)var3.next();
//                if (sbItems.length() != 0) {
//                    sbItems.append(",");
//                }
//            }
//        }
//
//        log.info("[onWorkitemCanceled],实际设置为Cancel状态的数据Id:" + sbItems);
//    }
//
//    protected List<CtpAffair> superviseCancel(List<WorkItem> workitems, Timestamp now) throws BusinessException {
//        List<CtpAffair> affair4Message = new ArrayList();
//        if (workitems != null && workitems.size() != 0) {
//            List<Long> ids = new ArrayList();
//            Map<String, Object> nameParameters = new HashMap();
//
//            for(int i = 0; i < workitems.size(); ++i) {
//                ids.add(((WorkItem)workitems.get(i)).getId());
//                if ((i + 1) % 300 == 0 || i == workitems.size() - 1) {
//                    nameParameters.put("subObjectId", ids);
//                    StringBuilder hql = new StringBuilder();
//                    hql.append("update CtpAffair as a set a.state=:state,a.subState=:subState,a.updateDate=:updateDate,a.delete=1 where a.subObjectId in (:subObjectIds)");
//                    Map<String, Object> params = new HashMap();
//                    params.put("state", StateEnum.col_cancel.key());
//                    params.put("subState", SubStateEnum.col_normal.key());
//                    params.put("updateDate", now);
//                    params.put("subObjectIds", ids);
//                    DBAgent.bulkUpdate(hql.toString(), params);
//                    List<CtpAffair> affairs = this.affairManager.getByConditions((FlipInfo)null, nameParameters);
//                    affair4Message.addAll(affairs);
//                    ids.clear();
//                }
//            }
//
//            return affair4Message;
//        } else {
//            return affair4Message;
//        }
//    }
//
//    protected CtpAffair eventData2ExistingAffair(EventDataContext eventData) throws BusinessException {
//        WorkItem workitem = eventData.getWorkItem();
//        CtpAffair affair = null;
//        if (null != eventData.getBusinessData("CtpAffair")) {
//            affair = (CtpAffair)eventData.getBusinessData("CtpAffair");
//        } else {
//            affair = this.affairManager.getAffairBySubObjectId(workitem.getId());
//        }
//
//        return affair;
//    }
//
//    public boolean onWorkitemDoneToReady(EventDataContext context) {
//        List<WorkItem> workItems = context.getWorkitemLists();
//        Timestamp now = new Timestamp(System.currentTimeMillis());
//
//        try {
//            Iterator var4 = workItems.iterator();
//
//            while(var4.hasNext()) {
//                WorkItem wi = (WorkItem)var4.next();
//                CtpAffair affair = this.affairManager.getAffairBySubObjectId(wi.getId());
//                affair.setState(StateEnum.col_pending.key());
//                affair.setSubState(SubStateEnum.col_pending_specialBacked.key());
//                affair.setArchiveId((Long)null);
//                affair.setUpdateDate(now);
//                affair.setCompleteTime((Date)null);
//                affair.setReceiveTime(now);
//                affair.setBackFromId(AppContext.getCurrentUser().getId());
//                affair.setCoverTime(false);
//                affair.setDelete(false);
//                affair.setPreApprover(null == AppContext.getCurrentUser() ? null : AppContext.getCurrentUser().getId());
//                this.affairManager.updateAffair(affair);
//                if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
//                    QuartzHolder.deleteQuartzJob("Remind" + affair.getId());
//                    QuartzHolder.deleteQuartzJob("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
//                }
//
//                if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
//                    QuartzHolder.deleteQuartzJob("DeadLine" + affair.getId());
//                    QuartzHolder.deleteQuartzJob("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
//                }
//
//                ColUtil.deleteCycleRemindQuartzJob(affair, false);
//                Long accountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), (ColSummary)context.getAppObject());
//                ColUtil.affairExcuteRemind(affair, accountId);
//            }
//        } catch (BusinessException var8) {
//            log.error("", var8);
//        }
//
//        return true;
//    }
//
//    public boolean onWorkitemWaitToReady(EventDataContext context) {
//        try {
//            ColSummary summary = (ColSummary)context.getAppObject();
//            List<WorkItem> workItems = context.getWorkitemLists();
//            Iterator var4 = workItems.iterator();
//
//            while(var4.hasNext()) {
//                WorkItem wi = (WorkItem)var4.next();
//                this.transDeal4SepcailSubmit(wi, SubStateEnum.col_pending_unRead, summary);
//            }
//        } catch (Exception var6) {
//            log.error("", var6);
//        }
//
//        return true;
//    }
//
//    public boolean onSubProcessStarted(EventDataContext context) {
//        try {
//            String processTemplateId = context.getProcessTemplateId();
//            String sendId = context.getStartUserId();
//            AffairData affairData = (AffairData)context.getBusinessData("CTP_AFFAIR_DATA");
//            CtpTemplate templete = this.templateManager.getCtpTemplateByWorkFlowId(Long.parseLong(processTemplateId));
//            if (templete == null) {
//                log.error("发起新流程失败，原因：触发的表单模板已被删除。NewflowRunningId=" + processTemplateId);
//                return false;
//            } else {
//                SendCollResult sendCollResult = this.colPubManager.transSendColl(SendType.child, templete.getId(), Long.parseLong(sendId), affairData.getFormRecordId(), affairData.getModuleId());
//                CtpAffair childSenderAffair = sendCollResult.getSentAffair();
//                ColSummary newSummary = sendCollResult.getSummary();
//                this.wapi.updateSubProcessRunning(context.getSubProcessRunningId(), newSummary.getProcessId(), newSummary.getCaseId(), context.getStartUserId(), context.getStartUserName());
//                Set<MessageReceiver> receivers = new HashSet();
//                CtpAffair senderAffair = this.affairManager.getSenderAffair(affairData.getModuleId());
//                Integer importantLevel = ColUtil.getImportantLevel(senderAffair);
//                boolean isCanViewByMainFlow = false;
//                Object canViewByMainFlowObject = context.getBusinessData("CTP_SUB_WORKFLOW_CAN_VIEW_BY_MAIN_FLOW");
//                if (null != canViewByMainFlowObject) {
//                    isCanViewByMainFlow = (Boolean)canViewByMainFlowObject;
//                }
//
//                List<AgentModel> agentModelList = MemberAgentBean.getInstance().getAgentModelToList(senderAffair.getSenderId());
//                if (isCanViewByMainFlow) {
//                    Object relativeProcessId = context.getBusinessData("CTP_WORKFLOW_MAIN_PROCESSID");
//                    Long relativeProcessIdl = relativeProcessId == null ? 0L : Long.valueOf(relativeProcessId.toString());
//                    receivers.add(new MessageReceiver(senderAffair.getId(), senderAffair.getSenderId(), "message.link.col.done.newflow", new Object[]{childSenderAffair.getId(), 0, affairData.getModuleId(), newSummary.getProcessId(), relativeProcessIdl}));
//                    Iterator var17 = agentModelList.iterator();
//
//                    while(var17.hasNext()) {
//                        AgentModel am = (AgentModel)var17.next();
//                        Long agentId = am.getAgentId();
//                        receivers.add(new MessageReceiver(senderAffair.getId(), agentId, "message.link.col.done.newflow", new Object[]{childSenderAffair.getId(), 0, affairData.getModuleId(), newSummary.getProcessId(), relativeProcessIdl}));
//                    }
//                } else {
//                    receivers.add(new MessageReceiver(senderAffair.getId(), senderAffair.getSenderId()));
//                    Iterator var21 = agentModelList.iterator();
//
//                    while(var21.hasNext()) {
//                        AgentModel am = (AgentModel)var21.next();
//                        Long agentId = am.getAgentId();
//                        receivers.add(new MessageReceiver(senderAffair.getId(), agentId));
//                    }
//                }
//
//                String mesSubject = newSummary.getSubject();
//                if (null != newSummary.getAutoRun() && newSummary.getAutoRun()) {
//                    mesSubject = ResourceUtil.getString("collaboration.newflow.fire.subject", mesSubject);
//                }
//
//                this.userMessageManager.sendSystemMessage((new MessageContent("collaboration.msg.workflow.new.start", new Object[]{affairData.getSubject(), mesSubject})).setImportantLevel(senderAffair.getImportantLevel()), ApplicationCategoryEnum.collaboration, Long.parseLong(sendId), receivers, new Object[]{importantLevel});
//                return true;
//            }
//        } catch (Throwable var20) {
//            log.error(var20.getMessage(), var20);
//            return false;
//        }
//    }
//
//    public boolean onProcessStarted(EventDataContext context) {
//        return true;
//    }
//
//    private void saveListMap(AffairData affairData, Date receiveTime, Boolean isCover, List<MessageReceiver> receivers, List<MessageReceiver> receivers1) {
//        if (affairData != null) {
//            try {
//                List<CtpAffair> affairList = affairData.getAffairList();
//                Boolean isSendMessage = affairData.getIsSendMessage();
//                if (affairList != null && !affairList.isEmpty()) {
//                    CtpAffair aff = (CtpAffair)affairList.get(0);
//                    if (affairList.size() <= 50) {
//                        DBAgent.saveAll(affairList);
//                    } else {
//                        DBAgent.saveAllForceFlush(affairList);
//                    }
//
//                    DateSharedWithWorkflowEngineThreadLocal.setWorkflowAssignedAllAffairs(affairList);
//                    if (isSendMessage) {
//                        this.colMessageManager.sendMessage(affairData, receivers, receivers1, receiveTime);
//                    }
//
//                    if (isCover != null && isCover) {
//                        this.colMessageManager.transSendMsg4ProcessOverTime(aff, receivers, receivers1);
//                    }
//
//                    if (affairList.size() != 0) {
//                        ;
//                    }
//                }
//            } catch (Exception var9) {
//                log.error("", var9);
//                throw new RuntimeException();
//            }
//        }
//    }
//
//    public boolean onSubProcessCanceled(EventDataContext context) {
//        long subCaseId = context.getCaseId();
//        User user = AppContext.getCurrentUser();
//        String operationType = (String)context.getBusinessData("operationType");
//
//        try {
//            this.colManager.recallNewflowSummary(subCaseId, user, operationType);
//        } catch (Throwable var7) {
//            log.error("子流程撤销发生异常", var7);
//        }
//
//        return true;
//    }
//
//    public boolean onWorkitemWaitToLastTimeStatus(EventDataContext context) {
//        try {
//            List<WorkItem> workItems = context.getWorkitemLists();
//            ColSummary summary = (ColSummary)context.getAppObject();
//            Iterator var4 = workItems.iterator();
//
//            while(var4.hasNext()) {
//                WorkItem wi = (WorkItem)var4.next();
//                this.transDeal4SepcailSubmit(wi, SubStateEnum.col_pending_specialBacked, summary);
//            }
//        } catch (Exception var6) {
//            log.error("", var6);
//        }
//
//        return true;
//    }
//
//    private void transDeal4SepcailSubmit(WorkItem wi, SubStateEnum subState, ColSummary summary) {
//        try {
//            Timestamp now = new Timestamp(System.currentTimeMillis());
//            CtpAffair affair = this.affairManager.getAffairBySubObjectId(wi.getId());
//            if (Integer.valueOf(SubStateEnum.col_pending_specialBack.key()).equals(affair.getSubState())) {
//                affair.setSubState(SubStateEnum.col_pending_unRead.key());
//            } else {
//                if (!SubStateEnum.col_pending_specialBacked.equals(subState)) {
//                    affair.setPreApprover(AppContext.getCurrentUser() == null ? null : AppContext.getCurrentUser().getId());
//                    this.affairManager.updateAffair(affair);
//                    return;
//                }
//
//                affair.setSubState(SubStateEnum.col_pending_specialBacked.key());
//            }
//
//            affair.setState(StateEnum.col_pending.key());
//            affair.setUpdateDate(now);
//            affair.setPreApprover(AppContext.getCurrentUser() == null ? null : AppContext.getCurrentUser().getId());
//            this.affairManager.updateAffair(affair);
//            if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
//                QuartzHolder.deleteQuartzJob("Remind" + affair.getId());
//                QuartzHolder.deleteQuartzJob("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
//            }
//
//            if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
//                QuartzHolder.deleteQuartzJob("DeadLine" + affair.getId());
//                QuartzHolder.deleteQuartzJob("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
//            }
//
//            ColUtil.deleteCycleRemindQuartzJob(affair, false);
//
//            try {
//                Long accountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), summary);
//                ColUtil.affairExcuteRemind(affair, accountId);
//            } catch (BusinessException var12) {
//                log.error("", var12);
//            }
//
//            Set<MessageReceiver> receiversPending = new HashSet();
//            receiversPending.add(new MessageReceiver(affair.getId(), affair.getMemberId(), "message.link.col.pending", new Object[]{affair.getId(), ""}));
//            Set<MessageReceiver> receiversPendingAgent = new HashSet();
//            Long agentMemberId = this.colMessageManager.isAgent(affair.getTempleteId(), affair.getMemberId(), affair.getReceiveTime());
//            if (agentMemberId != null) {
//                receiversPendingAgent.add(new MessageReceiver(affair.getId(), agentMemberId, "message.link.col.pending", new Object[]{affair.getId(), ""}));
//            }
//
//            Integer importantLevel = ColUtil.getImportantLevel(affair);
//            String name = this.orgManager.getMemberById(affair.getSenderId()).getName();
//            this.userMessageManager.sendSystemMessage((new MessageContent("collaboration.appointStepBack.send", new Object[]{name, affair.getSubject()})).setImportantLevel(affair.getImportantLevel()), ApplicationCategoryEnum.collaboration, AppContext.getCurrentUser().getId(), receiversPending, new Object[]{importantLevel});
//            if (receiversPendingAgent.size() > 0) {
//                this.userMessageManager.sendSystemMessage((new MessageContent("collaboration.appointStepBack.send", new Object[]{name, affair.getSubject()})).add("col.agent", new Object[0]).setImportantLevel(affair.getImportantLevel()), ApplicationCategoryEnum.collaboration, AppContext.getCurrentUser().getId(), receiversPendingAgent, new Object[]{importantLevel});
//            }
//        } catch (Exception var13) {
//            log.error("", var13);
//        }
//
//    }
//
//    public boolean onProcessCanceled(EventDataContext context) {
//        try {
//            Long affairId = null;
//            if (null != context.getBusinessData("CURRENT_OPERATE_AFFAIR_ID")) {
//                affairId = (Long)context.getBusinessData("CURRENT_OPERATE_AFFAIR_ID");
//            }
//
//            String repealComment = "";
//            if (null != context.getBusinessData("CURRENT_OPERATE_COMMENT_CONTENT")) {
//                repealComment = (String)context.getBusinessData("CURRENT_OPERATE_COMMENT_CONTENT");
//            }
//
//            Long summaryId = null;
//            if (null != context.getBusinessData("CURRENT_OPERATE_SUMMARY_ID")) {
//                summaryId = (Long)context.getBusinessData("CURRENT_OPERATE_SUMMARY_ID");
//            }
//
//            String trackWorkflowType = "";
//            if (null != context.getBusinessData("CURRENT_OPERATE_TRACK_FLOW")) {
//                trackWorkflowType = (String)context.getBusinessData("CURRENT_OPERATE_TRACK_FLOW");
//            }
//
//            if (affairId == null && null != context.getCurrentWorkitemId()) {
//                CtpAffair currentAffair = this.affairManager.getAffairBySubObjectId(context.getCurrentWorkitemId());
//                affairId = currentAffair.getId();
//                summaryId = currentAffair.getObjectId();
//            }
//
//            Integer operationType = (Integer)context.getBusinessData().get("operationType");
//            this.colManager.transRepalBackground(summaryId, affairId, repealComment, trackWorkflowType, operationType);
//        } catch (Exception var7) {
//            log.error("", var7);
//        }
//
//        return true;
//    }
//
//    private String makeSubject(String archiveName, ColSummary summary) throws BusinessException {
//        if (Strings.isNotBlank(archiveName)) {
//            archiveName = this.formManager.getCollSubjuet(summary.getFormAppid(), archiveName, summary.getFormRecordid(), (Long)null, 0L, false);
//        }
//
//        return archiveName;
//    }
//}
