//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.collaboration.controller;

import com.seeyon.apps.ai.event.AIRemindEvent;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.api.NewCollDataHandler;
import com.seeyon.apps.collaboration.bo.ColInfo;
import com.seeyon.apps.collaboration.bo.FormLockParam;
import com.seeyon.apps.collaboration.bo.LockObject;
import com.seeyon.apps.collaboration.constants.ColConstant.SendType;
import com.seeyon.apps.collaboration.enums.ColOpenFrom;
import com.seeyon.apps.collaboration.enums.ColQueryCondition;
import com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState;
import com.seeyon.apps.collaboration.manager.ColLockManager;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.manager.NewCollDataHelper;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.po.WorkflowTracePO;
import com.seeyon.apps.collaboration.quartz.CollProcessBackgroundManager;
import com.seeyon.apps.collaboration.trace.enums.WorkflowTraceEnums.workflowTrackType;
import com.seeyon.apps.collaboration.trace.manager.TraceWorkflowManager;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.collaboration.vo.AttachmentVO;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.apps.collaboration.vo.DumpDataVO;
import com.seeyon.apps.collaboration.vo.NewCollTranVO;
import com.seeyon.apps.collaboration.vo.NodePolicyVO;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.constants.DocConstants.PigeonholeType;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.taskmanage.util.MenuPurviewUtil;
import com.seeyon.ctp.cap.api.manager.CAPFormManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.ContentConfig;
import com.seeyon.ctp.common.content.ContentUtil;
import com.seeyon.ctp.common.content.ContentViewRet;
import com.seeyon.ctp.common.content.ContentUtil.OperationType;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.permission.vo.PermissionVO;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.processlog.ProcessLog;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.processlog.ProcessLogAction;
import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
import com.seeyon.ctp.common.shareMap.V3xShareMap;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.enums.TemplateEnum.Type;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.template.util.TemplateUtil;
import com.seeyon.ctp.common.track.manager.CtpTrackMemberManager;
import com.seeyon.ctp.common.track.po.CtpTrackMember;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgIndexManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.webmodel.WebEntity4QuickIndex;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.HttpSessionUtil;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.XMLCoder;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.engine.enums.BPMSeeyonPolicySetting.MergeDealType;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.peoplerelate.manager.PeopleRelateManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.joinwork.bpm.definition.BPMProcess;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.springframework.web.servlet.ModelAndView;

public class CollaborationController extends BaseController {
    private static final Log LOG = CtpLogFactory.getLog(CollaborationController.class);
    private ColManager colManager;
    private AffairManager affairManger;
    private WorkflowApiManager wapi;
    private CustomizeManager customizeManager;
    private TemplateManager templateManager;
    private OrgManager orgManager;
    private AttachmentManager attachmentManager;
    private FileToExcelManager fileToExcelManager;
    private FileManager fileManager;
    private EdocApi edocApi;
    private EnumManager enumManagerNew;
    private MainbodyManager ctpMainbodyManager;
    private CollaborationApi collaborationApi;
    private ColLockManager colLockManager;
    private PermissionManager permissionManager;
    private OrgIndexManager orgIndexManager;
    private PeopleRelateManager peopleRelateManager;
    private ProcessLogManager processLogManager;
    private SystemConfig systemConfig;
    private TraceWorkflowManager traceWorkflowManager;
    private DocApi docApi;
    private CAPFormManager capFormManager;
    private CollProcessBackgroundManager collProcessBackgroundManager;
    private CtpTrackMemberManager trackManager;
    private AffairManager affairManager;

    public CollaborationController() {
    }

    public CollProcessBackgroundManager getCollProcessBackgroundManager() {
        return this.collProcessBackgroundManager;
    }

    public void setCollProcessBackgroundManager(CollProcessBackgroundManager collProcessBackgroundManager) {
        this.collProcessBackgroundManager = collProcessBackgroundManager;
    }

    public void setCapFormManager(CAPFormManager capFormManager) {
        this.capFormManager = capFormManager;
    }

    public DocApi getDocApi() {
        return this.docApi;
    }

    public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }

    public void setSystemConfig(SystemConfig systemConfig) {
        this.systemConfig = systemConfig;
    }

    public OrgIndexManager getOrgIndexManager() {
        return this.orgIndexManager;
    }

    public void setOrgIndexManager(OrgIndexManager orgIndexManager) {
        this.orgIndexManager = orgIndexManager;
    }

    public PeopleRelateManager getPeopleRelateManager() {
        return this.peopleRelateManager;
    }

    public void setPeopleRelateManager(PeopleRelateManager peopleRelateManager) {
        this.peopleRelateManager = peopleRelateManager;
    }

    public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    public ColLockManager getColLockManager() {
        return this.colLockManager;
    }

    public void setColLockManager(ColLockManager colLockManager) {
        this.colLockManager = colLockManager;
    }

    public ColManager getColManager() {
        return this.colManager;
    }

    public CollaborationApi getCollaborationApi() {
        return this.collaborationApi;
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

    public void setEnumManagerNew(EnumManager enumManager) {
        this.enumManagerNew = enumManager;
    }

    public AffairManager getAffairManger() {
        return this.affairManger;
    }

    public void setAffairManger(AffairManager affairManger) {
        this.affairManger = affairManger;
    }

    public EdocApi getEdocApi() {
        return this.edocApi;
    }

    public void setEdocApi(EdocApi edocApi) {
        this.edocApi = edocApi;
    }

    public FileManager getFileManager() {
        return this.fileManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public void setProcessLogManager(ProcessLogManager processLogManager) {
        this.processLogManager = processLogManager;
    }

    public TraceWorkflowManager getTraceWorkflowManager() {
        return this.traceWorkflowManager;
    }

    public void setTraceWorkflowManager(TraceWorkflowManager traceWorkflowManager) {
        this.traceWorkflowManager = traceWorkflowManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public AttachmentManager getAttachmentManager() {
        return this.attachmentManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public OrgManager getOrgManager() {
        return this.orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public TemplateManager getTemplateManager() {
        return this.templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public CustomizeManager getCustomizeManager() {
        return this.customizeManager;
    }

    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }

    public void setColManager(ColManager colManager) {
        this.colManager = colManager;
    }

    public AffairManager getAffairManager() {
        return this.affairManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public CtpTrackMemberManager getTrackManager() {
        return this.trackManager;
    }

    public void setTrackManager(CtpTrackMemberManager trackManager) {
        this.trackManager = trackManager;
    }

    public ModelAndView newColl(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/newCollaboration");
        modelAndView.addObject("summarySate", Integer.valueOf(-1));
        User user = AppContext.getCurrentUser();
        NewCollTranVO vobj = new NewCollTranVO();
        vobj.setCreateDate(new Date());
        String from = request.getParameter("from");
        String summaryId = request.getParameter("summaryId");
        String templateId = request.getParameter("templateId");
        String projectID = request.getParameter("projectId");
        boolean relateProjectFlag = false;
        if(Strings.isNotBlank(projectID) && !"-1".equals(projectID)) {
            relateProjectFlag = true;
        }

        String affairId = request.getParameter("affairId");
        ColSummary summary = null;
        boolean canEditColPigeonhole = true;
        CtpTemplate template = null;
        vobj.setFrom(from);
        vobj.setSummaryId(Strings.isBlank(summaryId)?String.valueOf(UUIDLong.longUUID()):summaryId);
        vobj.setTempleteId(templateId);
        vobj.setProjectId(Strings.isNotBlank(projectID)?Long.valueOf(Long.parseLong(projectID)):null);
        vobj.setAffairId(affairId);
        vobj.setUser(user);
        vobj.setCanDeleteOriginalAtts(true);
        vobj.setCloneOriginalAtts(false);
        vobj.setArchiveName("");
        vobj.setNewBusiness("1");
        boolean showTraceWorkflows = false;
        String branch = "";
        ColSummary processColSummary;
        Long projectId;
        String rightId;
        boolean processTremTypeHasValue;
        boolean isSpecialSteped;
        if(Strings.isNotBlank(templateId)) {
            branch = "template";
            vobj.setSummaryId(String.valueOf(UUIDLong.longUUID()));

            try {
                template = this.templateManager.getCtpTemplate(Long.valueOf(templateId));
                isSpecialSteped = this.templateManager.isTemplateEnabled(template, user.getId());
                if(!user.hasResourceCode("F01_newColl") && isSpecialSteped && null != template && !TemplateUtil.isSystemTemplate(template)) {
                    isSpecialSteped = false;
                }

                if(!isSpecialSteped) {
                    if("templateNewColl".equals(from)) {
                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript(ResourceUtil.getString("collaboration.send.fromSend.templeteDelete")));
                    } else {
                        PrintWriter out = response.getWriter();
                        out.println("<script>");
                        out.println("alert('" + ResourceUtil.getString("collaboration.send.fromSend.templeteDelete") + "');");
                        out.print("parent.window.close();");
                        out.println("</script>");
                        out.flush();
                    }

                    return null;
                }

                vobj.setTemplate(template);
                vobj = this.colManager.transferTemplate(vobj);
                template = vobj.getTemplate();
                modelAndView.addObject("zwContentType", template.getBodyType());
                AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, vobj.getSummaryId(), user.getId().longValue());
            } catch (Throwable var44) {
                LOG.info("", var44);
                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript(ResourceUtil.getString("collaboration.send.fromSend.templeteDelete")));
                return null;
            }

            canEditColPigeonhole = vobj.isCanEditColPigeonhole();
        } else {
            Long referenceId;
            if("resend".equals(from)) {
                branch = "resend";
                vobj = this.colManager.transResend(vobj);
                vobj.setSummaryId(String.valueOf(UUIDLong.longUUID()));
                modelAndView.addObject("parentSummaryId", vobj.getSummary().getId());
                referenceId = vobj.getSummary().getId();
                processColSummary = this.colManager.getSummaryById(referenceId);
                vobj.getSummary().setId(Long.valueOf(vobj.getSummaryId()));
                projectId = processColSummary.getTempleteId();
                CtpTemplate ctpTemplate = null;
                if(projectId != null) {
                    ctpTemplate = this.templateManager.getCtpTemplate(projectId);
                    if(ctpTemplate != null) {
                        ColSummary tSummary = (ColSummary)XMLCoder.decoder(ctpTemplate.getSummary());
                        vobj.setTempleteHasDeadline(tSummary.getDeadline() != null && tSummary.getDeadline().longValue() != 0L);
                        vobj.setTempleteHasRemind(tSummary.getAdvanceRemind() != null && tSummary.getAdvanceRemind().longValue() != 0L && tSummary.getAdvanceRemind().longValue() != -1L);
                        vobj.setCanEditColPigeonhole(tSummary.getArchiveId() != null);
                        vobj.setTemplateHasProcessTermType(tSummary.getProcessTermType() != null);
                        vobj.setTemplateHasRemindInterval(tSummary.getRemindInterval() != null && tSummary.getRemindInterval().longValue() > 0L);
                        vobj.setParentWrokFlowTemplete(this.colManager.isParentWrokFlowTemplete(ctpTemplate.getFormParentid()));
                        vobj.setParentTextTemplete(this.colManager.isParentTextTemplete(ctpTemplate.getFormParentid()));
                        vobj.setParentColTemplete(this.colManager.isParentColTemplete(ctpTemplate.getFormParentid()));
                        vobj.setFromSystemTemplete(ctpTemplate.isSystem().booleanValue());
                        rightId = "0";
                        if(tSummary.getAttachmentArchiveId() != null && AppContext.hasPlugin("doc")) {
                            processTremTypeHasValue = this.docApi.isDocResourceExisted(tSummary.getAttachmentArchiveId());
                            if(processTremTypeHasValue) {
                                vobj.setAttachmentArchiveId(tSummary.getAttachmentArchiveId());
                                if(null != vobj.getSummary()) {
                                    vobj.getSummary().setCanArchive(Boolean.valueOf(true));
                                }
                            }
                        }

                        modelAndView.addObject("scanCodeInput", rightId);
                    }
                }

                this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
                modelAndView.addObject("isResend", "1");
            } else {
                String formTitleText;
                if(vobj.getSummaryId() != null && "waitSend".equals(from)) {
                    branch = "waitSend";
                    modelAndView.addObject("summarySate", Integer.valueOf(StateEnum.col_waitSend.key()));
                    vobj.setNewBusiness("0");
                    if(Strings.isNotBlank(affairId)) {
                        CtpAffair valAffair = this.affairManager.get(Long.valueOf(affairId));
                        if(null != valAffair && !valAffair.getMemberId().equals(user.getId())) {
                            this.newCollAlert(response, StringEscapeUtils.escapeJavaScript(ResourceUtil.getString("collaboration.error.common.permission.no")));
                            return null;
                        }
                    }

                    try {
                        vobj = this.colManager.transComeFromWaitSend(vobj);
                        formTitleText = ReqUtil.getString(request, "subState", "");
                        String oldSubState = ReqUtil.getString(request, "oldSubState", "");
                        if(Strings.isNotBlank(oldSubState) && oldSubState != "1") {
                            formTitleText = oldSubState;
                        }

                        CtpAffair vaffair = vobj.getAffair();
                        if(Strings.isBlank(formTitleText)) {
                            formTitleText = null != vaffair?String.valueOf(vaffair.getSubState().intValue()):"1";
                        }

                        modelAndView.addObject("subState", formTitleText);
                        showTraceWorkflows = this.showTraceWorkflows(formTitleText, vaffair);
                        template = vobj.getTemplate();
                        this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
                    } catch (Exception var43) {
                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript(ResourceUtil.getString("collaboration.send.fromSend.templeteDelete")));
                        return null;
                    }

                    canEditColPigeonhole = vobj.isCanEditColPigeonhole();
                    modelAndView.addObject("alertSuperviseSet", Boolean.valueOf(true));
                    formTitleText = request.getParameter("formTitleText");
                    if(Strings.isNotBlank(formTitleText)) {
                        modelAndView.addObject("_formTitleText", formTitleText);
                        vobj.setCollSubject(formTitleText);
                        if(null != vobj.getSummary()) {
                            vobj.getSummary().setSubject(formTitleText);
                        }
                    }

                    if("bizconfig".equals(request.getParameter("reqFrom"))) {
                        vobj.setFrom("bizconfig");
                    }

                    vobj.setAttachmentArchiveId(vobj.getSummary().getAttachmentArchiveId());
                } else if("relatePeople".equals(from)) {
                    branch = "relatePeople";
                    vobj.setNewBusiness("1");
                    formTitleText = request.getParameter("memberId");
                    this.setWorkFlowMember(formTitleText, user, modelAndView);
                } else if("a8genius".equals(from)) {
                    branch = "a8genius";
                    referenceId = Long.valueOf(UUIDLong.longUUID());
                    String[] attachids = request.getParameterValues("attachid");
                    if(attachids != null && attachids.length > 0) {
                        Long[] attId = new Long[attachids.length];

                        for(int count = 0; count < attachids.length; ++count) {
                            attId[count] = Long.valueOf(attachids[count]);
                        }

                        if(attId.length > 0) {
                            this.attachmentManager.create(attId, ApplicationCategoryEnum.collaboration, referenceId, referenceId);
                            String attListJSON = this.attachmentManager.getAttListJSON(referenceId);
                            vobj.setAttListJSON(attListJSON);
                        }
                    }

                    modelAndView.addObject("source", request.getParameter("source"));
                    modelAndView.addObject("from", from);
                    modelAndView.addObject("referenceId", referenceId);
                }
            }
        }

        modelAndView.addObject("showTraceWorkflows", Boolean.valueOf(showTraceWorkflows));
        if(vobj.getSummary() == null) {
            summary = new ColSummary();
            vobj.setSummary(summary);
            summary.setCanForward(Boolean.valueOf(true));
            summary.setCanArchive(Boolean.valueOf(true));
            summary.setCanDueReminder(Boolean.valueOf(true));
            summary.setCanEditAttachment(Boolean.valueOf(true));
            summary.setCanModify(Boolean.valueOf(true));
            summary.setCanTrack(Boolean.valueOf(true));
            summary.setCanEdit(Boolean.valueOf(true));
            summary.setAdvanceRemind(Long.valueOf(-1L));
        }

        this.initNewCollTranVO(vobj, summary, modelAndView, user, request);
        isSpecialSteped = vobj.getAffair() != null && vobj.getAffair().getSubState().intValue() == SubStateEnum.col_pending_specialBacked.key();
        processColSummary = null;
        BPMProcess process;
        if(template != null && template.getWorkflowId() != null && !isSpecialSteped && !"resend".equals(from)) {
            process = this.wapi.getTemplateProcess(template.getWorkflowId());
        } else {
            process = this.wapi.getBPMProcessForM1(vobj.getSummary().getProcessId());
        }

        if(vobj.isParentColTemplete() && null != vobj.getTemplate() && null != vobj.getTemplate().getProjectId()) {
            modelAndView.addObject("disabledProjectId", "1");
        }

        if(!relateProjectFlag) {
            projectId = vobj.getSummary().getProjectId();
            vobj.setProjectId(projectId);
        }

        ContentConfig config = ContentConfig.getConfig(ModuleType.collaboration);
        modelAndView.addObject("contentCfg", config);
        ContentViewRet context;
        if((summaryId != null || !Strings.isBlank(templateId)) && (!Strings.isNotBlank(templateId) || !Type.workflow.name().equals(template.getType()))) {
            Long originalContentId = null;
            rightId = null;
            if(summaryId != null) {
                originalContentId = Long.valueOf(Long.parseLong(summaryId));
            } else if(Strings.isNotBlank(templateId)) {
                originalContentId = Long.valueOf(templateId);
            }

            if(template != null && ColUtil.isForm(template.getBodyType())) {
                rightId = this.wapi.getNodeFormViewAndOperationName(process, (String)null);
            }

            ColSummary fromToSummary = vobj.getSummary();
            int viewState = 1;
            if(fromToSummary.getParentformSummaryid() != null && !fromToSummary.getCanEdit().booleanValue()) {
                ColSummary parentSummary = this.colManager.getSummaryById(fromToSummary.getParentformSummaryid());
                if(parentSummary != null && ColUtil.isForm(parentSummary.getBodyType())) {
                    viewState = 2;
                }
            }

            modelAndView.addObject("contentViewState", Integer.valueOf(viewState));
            modelAndView.addObject("uuidlong", Long.valueOf(UUIDLong.longUUID()));
            modelAndView.addObject("zwModuleId", originalContentId);
            modelAndView.addObject("zwRightId", rightId);
            modelAndView.addObject("zwIsnew", "false");
            modelAndView.addObject("zwViewState", Integer.valueOf(viewState));
            context = this.setWorkflowParam(originalContentId, ModuleType.collaboration);
            context.setCanReply(false);
            if("waitSend".equals(branch) || "resend".equals(branch)) {
                ContentUtil.findSenderCommentLists(request, config, ModuleType.collaboration, originalContentId, (Long)null);
            }
        } else {
            context = this.setWorkflowParam((Long)null, ModuleType.collaboration);
        }

        String officeOcxUploadMaxSize;
        if(context != null) {
            EnumManager em = (EnumManager)AppContext.getBean("enumManagerNew");
            Map<String, CtpEnumBean> ems = em.getEnumsMap(ApplicationCategoryEnum.collaboration);
            CtpEnumBean nodePermissionPolicy = (CtpEnumBean)ems.get(EnumNameEnum.col_flow_perm_policy.name());
            String xml = "";
            CtpTemplate t = vobj.getTemplate();
            context.setWfProcessId(vobj.getSummary().getProcessId());
            context.setWfCaseId(Long.valueOf(vobj.getCaseId() == null?-1L:vobj.getCaseId().longValue()));
            officeOcxUploadMaxSize = vobj.getSummary().getProcessId();
            if(t != null && t.getWorkflowId() != null) {
                if(!isSpecialSteped && !"resend".equals(from)) {
                    if(TemplateUtil.isSystemTemplate(vobj.getTemplate())) {
                        context.setProcessTemplateId(String.valueOf(vobj.getTemplate().getWorkflowId()));
                        context.setWfProcessId("");
                    } else {
                        modelAndView.addObject("ordinalTemplateIsSys", "no");
                        xml = this.wapi.selectWrokFlowTemplateXml(t.getWorkflowId().toString());
                    }
                } else if("resend".equals(from)) {
                    xml = this.wapi.selectWrokFlowXml(officeOcxUploadMaxSize);
                    context.setWfProcessId("");
                }
            } else {
                if(!isSpecialSteped) {
                    xml = this.wapi.selectWrokFlowXml(officeOcxUploadMaxSize);
                }

                if("resend".equals(from)) {
                    context.setWfProcessId("");
                }
            }

            String[] workflowNodesInfo = this.wapi.getWorkflowInfos(process, ModuleType.collaboration.name(), nodePermissionPolicy);
            context.setWorkflowNodesInfo(workflowNodesInfo[0]);
            modelAndView.addObject("DR", workflowNodesInfo[1]);
            vobj.setWfXMLInfo(Strings.escapeJavascript(xml));
            modelAndView.addObject("contentContext", context);
        }

        if(vobj.getSummaryId() != null) {
            AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, vobj.getSummaryId(), user.getId().longValue());
        }

        if(null != vobj.getTemplate() && !Type.text.name().equals(vobj.getTemplate().getType())) {
            modelAndView.addObject("onlyViewWF", Boolean.valueOf(true));
        }

        modelAndView.addObject("postName", Functions.showOrgPostName(user.getPostId()));
        V3xOrgDepartment department = Functions.getDepartment(user.getDepartmentId());
        if(department != null) {
            modelAndView.addObject("departName", Functions.getDepartment(user.getDepartmentId()).getName());
        }

        modelAndView.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
        AppContext.putRequestContext("moduleId", vobj.getSummaryId());
        AppContext.putRequestContext("canDeleteISigntureHtml", Boolean.valueOf(true));
        if(vobj.getSummary().getDeadlineDatetime() != null) {
            vobj.setDeadLineDateTimeHidden(Datetimes.formatDatetimeWithoutSecond(vobj.getSummary().getDeadlineDatetime()));
        }

        LOG.info("vobj.processId=" + vobj.getProcessId());
        boolean isCAP4 = false;
        if(vobj.getSummary().getFormAppid() != null) {
            isCAP4 = this.capFormManager.isCAP4Form(vobj.getSummary().getFormAppid());
        }

        modelAndView.addObject("isCAP4", Boolean.valueOf(isCAP4));
        modelAndView.addObject("vobj", vobj);
        processTremTypeHasValue = false;
        if(vobj.getSummary().getProcessTermType() != null || vobj.isTemplateHasProcessTermType()) {
            processTremTypeHasValue = true;
        }

        modelAndView.addObject("processTremTypeHasValue", Boolean.valueOf(processTremTypeHasValue));
        boolean remindIntervalHasValue = false;
        if(vobj.getSummary().getRemindInterval() != null && vobj.getSummary().getRemindInterval().longValue() > 0L || vobj.isTemplateHasRemindInterval()) {
            remindIntervalHasValue = true;
        }

        modelAndView.addObject("remindIntervalHasValue", Boolean.valueOf(remindIntervalHasValue));
        String trackValue = this.customizeManager.getCustomizeValue(user.getId().longValue(), "track_send");
        if(Strings.isBlank(trackValue)) {
            modelAndView.addObject("customSetTrack", "true");
        } else {
            modelAndView.addObject("customSetTrack", trackValue);
        }

        officeOcxUploadMaxSize = SystemProperties.getInstance().getProperty("officeFile.maxSize");
        modelAndView.addObject("officeOcxUploadMaxSize", Strings.isBlank(officeOcxUploadMaxSize)?"8192":officeOcxUploadMaxSize);
        modelAndView.addObject("canEditColPigeonhole", Boolean.valueOf(canEditColPigeonhole));
        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(user.getLoginAccount());
        modelAndView.addObject("newColNodePolicy", Strings.escapeJson(JSONUtil.toJSONString(newColNodePolicy)));
        modelAndView.addObject("newColNodePolicyVO", newColNodePolicy);
        String recentPeoplesStr = this.orgIndexManager.getRecentDataStr(user.getId(), (String)null);
        List<WebEntity4QuickIndex> list = (List)JSONUtil.parseJSONString(recentPeoplesStr, List.class);
        modelAndView.addObject("recentPeoples", list);
        modelAndView.addObject("recentPeoplesLength", Integer.valueOf(list.size()));
        PermissionVO permission = this.permissionManager.getDefaultPermissionByConfigCategory(EnumNameEnum.col_flow_perm_policy.name(), user.getLoginAccount());
        modelAndView.addObject("defaultNodeName", permission.getName());
        modelAndView.addObject("defaultNodeLable", permission.getLabel());
        Map<String, Object> jval = new HashMap();
        jval.put("hasProjectPlugin", Boolean.valueOf(AppContext.hasPlugin("project")));
        jval.put("hasDocPlugin", Boolean.valueOf(AppContext.hasPlugin("doc") && newColNodePolicy.isPigeonhole()));
        modelAndView.addObject("jval", Strings.escapeJson(JSONUtil.toJSONString(jval)));
        List<CtpEnumItem> commonImportances = this.enumManagerNew.getEnumItems(EnumNameEnum.common_importance);
        List<CtpEnumItem> collaborationDeadlines = this.enumManagerNew.getEnumItems(EnumNameEnum.collaboration_deadline);
        List<CtpEnumItem> commonRemindTimes = this.enumManagerNew.getEnumItems(EnumNameEnum.common_remind_time);
        modelAndView.addObject("comImportanceMetadata", commonImportances);
        modelAndView.addObject("collaborationDeadlines", collaborationDeadlines);
        modelAndView.addObject("commonRemindTimes", commonRemindTimes);
        Map<Long, List<String>> logDescMap = new HashMap();
        String jsonString = JSONUtil.toJSONString(logDescMap);
        modelAndView.addObject("logDescMap", jsonString);
        Boolean canPraise = Boolean.valueOf(true);
        Boolean isFormTemplete = Boolean.valueOf(false);
        if(template != null) {
            canPraise = template.getCanPraise();
            if(ColUtil.isForm(template.getBodyType())) {
                isFormTemplete = Boolean.valueOf(true);
            }
        }

        modelAndView.addObject("isFormTemplete", isFormTemplete);
        modelAndView.addObject("canPraise", canPraise);
        boolean canAnyDealMerge = ColUtil.canMergeDealByType(MergeDealType.DEAL_MERGE, vobj.getSummary());
        boolean canPreDealMerge = ColUtil.canMergeDealByType(MergeDealType.PRE_DEAL_MERGE, vobj.getSummary());
        boolean canStartMerge = ColUtil.canMergeDealByType(MergeDealType.START_MERGE, vobj.getSummary());
        modelAndView.addObject("canAnyDealMerge", Boolean.valueOf(canAnyDealMerge));
        modelAndView.addObject("canPreDealMerge", Boolean.valueOf(canPreDealMerge));
        modelAndView.addObject("canStartMerge", Boolean.valueOf(canStartMerge));
        boolean isFormOffice = false;
        if(ColUtil.isForm(vobj.getSummary().getBodyType())) {
            isFormOffice = true;
        }

        modelAndView.addObject("isFormOffice", Boolean.valueOf(isFormOffice));
        return modelAndView;
    }

    private void initNewCollTranVO(NewCollTranVO vobj, ColSummary summary, ModelAndView modelAndView, User user, HttpServletRequest request) throws BusinessException {
        String cashId = request.getParameter("cashId");
        Object object = V3xShareMap.get(cashId);
        if(object != null) {
            Map<String, String> map = (Map)object;
            String subject = map.get("subject") == null?"":(String)map.get("subject");
            String manual = map.get("manual") == null?"":(String)map.get("manual");
            String handlerName = map.get("handlerName") == null?"":(String)map.get("handlerName");
            String sourceId = map.get("sourceId") == null?"":(String)map.get("sourceId");
            String extendInfo = map.get("ext") == null?"":(String)map.get("ext");
            String bodyTypes = map.get("bodyType") == null?"":(String)map.get("bodyType");
            String bodyContent = map.get("bodyContent") == null?"":(String)map.get("bodyContent");
            String personId = map.get("personId") == null?"":(String)map.get("personId");
            String from = map.get("from") == null?"":(String)map.get("from");
            summary.setSubject(subject);
            NewCollDataHandler handler = NewCollDataHelper.getHandler(handlerName);
            Map<String, Object> params = null;
            if(handler != null) {
                params = handler.getParams(sourceId, extendInfo);
            }

            if("true".equalsIgnoreCase(manual) && handler != null) {
                if(Strings.isBlank(subject)) {
                    summary.setSubject(handler.getSubject(params));
                }

                bodyTypes = String.valueOf(handler.getBodyType(params));
                bodyContent = handler.getBodyContent(params);
            }

            int bodyType = MainbodyType.HTML.getKey();
            if(Strings.isNotBlank(bodyTypes)) {
                bodyType = Integer.parseInt(bodyTypes);
            }

            if(MainbodyType.HTML.getKey() != bodyType && !ColUtil.isForm(bodyType)) {
                modelAndView.addObject("zwContentType", Integer.valueOf(bodyType));
                modelAndView.addObject("transOfficeId", bodyContent);
            } else {
                StringBuilder buf = new StringBuilder();
                buf.append(bodyContent == null?"":Strings.toHTML(bodyContent.replace("\t", "").replace("\n", ""), false));
                bodyContent = buf.toString();
            }

            summary.setBodyType(String.valueOf(bodyType));
            modelAndView.addObject("contentTextData", bodyContent);
            modelAndView.addObject("transtoColl", "true");
            if(handler != null) {
                List<Attachment> atts = handler.getAttachments(params);
                vobj.setAtts(atts);
                if(Strings.isNotEmpty(atts)) {
                    String attListJSON = this.attachmentManager.getAttListJSON(atts);
                    vobj.setAttListJSON(attListJSON);
                }

                vobj.setCloneOriginalAtts(true);
            }

            this.setWorkFlowMember(personId, user, modelAndView);
            modelAndView.addObject("from", from);
        }
    }

    private void setWorkFlowMember(String memberId, User user, ModelAndView modelAndView) throws BusinessException {
        if(Strings.isNotBlank(memberId)) {
            V3xOrgMember sender = this.orgManager.getMemberById(Long.valueOf(memberId));
            V3xOrgAccount account = this.orgManager.getAccountById(sender.getOrgAccountId());
            modelAndView.addObject("accountObj", account);
            modelAndView.addObject("isSameAccount", String.valueOf(sender.getOrgAccountId().equals(user.getLoginAccount())));
            modelAndView.addObject("peopeleCardInfo", sender);
        }

    }

    private ContentViewRet setWorkflowParam(Long moduleId, ModuleType moduleType) {
        ContentViewRet context = new ContentViewRet();
        context.setModuleId(moduleId);
        context.setModuleType(Integer.valueOf(moduleType.getKey()));
        context.setCommentMaxPath("00");
        return context;
    }

    private void getTrackInfo(ModelAndView modelAndView, NewCollTranVO vobj, String smmaryId) throws BusinessException {
        CtpAffair affairSent = this.affairManager.getSenderAffair(Long.valueOf(smmaryId));
        if("waitSend".equals(vobj.getFrom()) && Strings.isNotBlank(vobj.getAffairId()) && !"null".equals(vobj.getAffairId())) {
            affairSent = this.affairManager.get(Long.valueOf(vobj.getAffairId()));
        }

        if(affairSent != null) {
            Integer trackType = Integer.valueOf(affairSent.getTrack().intValue());
            modelAndView.addObject("trackType", trackType);
            List<CtpTrackMember> tList = this.trackManager.getTrackMembers(affairSent.getId());
            StringBuilder trackNames = new StringBuilder();
            StringBuilder trackIds = new StringBuilder();
            if(tList.size() > 0) {
                Iterator var9 = tList.iterator();

                while(var9.hasNext()) {
                    CtpTrackMember ctpT = (CtpTrackMember)var9.next();
                    trackNames.append("Member|").append(ctpT.getTrackMemberId()).append(",");
                    trackIds.append(ctpT.getTrackMemberId() + ",");
                }

                if(trackNames.length() > 0) {
                    vobj.setForGZShow(trackNames.substring(0, trackNames.length() - 1));
                    modelAndView.addObject("forGZIds", trackIds.substring(0, trackIds.length() - 1));
                }
            }
        }

    }

    public ModelAndView checkFile(HttpServletRequest request, HttpServletResponse response) throws IOException, BusinessException {
        String userId = request.getParameter("userId");
        String docId = request.getParameter("docId");
        String isBorrow = request.getParameter("isBorrow");
        String vForDocDownload = request.getParameter("v");
        PrintWriter out;
        if(!Strings.isBlank(userId) && userId.equals(String.valueOf(AppContext.currentUserId()))) {
            out = null;
            String context = SystemEnvironment.getContextPath();
            V3XFile vf = this.fileManager.getV3XFile(Long.valueOf(docId));
            String result = "0#" + context + "/fileDownload.do?method=doDownload&viewMode=download&fileId=" + vf.getId() + "&filename=" + URLEncoder.encode(vf.getFilename(), "UTF-8") + "&createDate=" + Datetimes.formatDate(vf.getCreateDate()) + "&v=" + Strings.escapeJavascript(vForDocDownload);
             out = response.getWriter();
            out.print(result);
            out.close();
            return null;
        } else {
            out = response.getWriter();
            out.print("1");
            out.close();
            return null;
        }
    }

    private void newCollAlert(HttpServletResponse response, String msg) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('" + msg + "');");
        out.print("parent.window.history.back();");
        out.println("</script>");
        out.flush();
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public ModelAndView saveDraft(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ColInfo info = new ColInfo();
        User user = AppContext.getCurrentUser();
        Map para = ParamUtil.getJsonDomain("colMainData");
        info.setDR((String)para.get("DR"));
        ColSummary summary = (ColSummary)ParamUtil.mapToBean(para, new ColSummary(), false);
        String selectProjectId = ParamUtil.getString(para, "selectProjectId", "-1");
        if("-1".equals(selectProjectId)) {
            summary.setProjectId((Long)null);
        } else {
            summary.setProjectId(Long.valueOf(selectProjectId));
        }

        Map para1 = ParamUtil.getJsonDomain("senderOpinion");
        Comment comment = (Comment)ParamUtil.mapToBean(para1, new Comment(), false);
        boolean saveProcessFlag = true;
        CtpTemplate ct = null;
        if(Strings.isNotBlank((String)para.get("tId"))) {
            Long templateIdLong = Long.valueOf((String)para.get("tId"));
            info.settId(templateIdLong);
            ct = this.templateManager.getCtpTemplate(templateIdLong);
            if(!"text".equals(ct.getType())) {
                saveProcessFlag = false;
            }
        }

        if(Strings.isNotBlank((String)para.get("curTemId"))) {
            info.setCurTemId(Long.valueOf((String)para.get("curTemId")));
        }

        if(para.get("processTermTypeCheck") == null) {
            summary.setProcessTermType((Integer)null);
        }

        if(para.get("remindIntervalCheckBox") == null) {
            summary.setRemindInterval((Long)null);
        }

        Map<String, String> mergeDealType = new HashMap();
        String canStartMerge = (String)para.get("canStartMerge");
        if(MergeDealType.START_MERGE.getValue().equals(canStartMerge)) {
            mergeDealType.put(MergeDealType.START_MERGE.name(), canStartMerge);
        }

        String canPreDealMerge = (String)para.get("canPreDealMerge");
        if(MergeDealType.PRE_DEAL_MERGE.getValue().equals(canPreDealMerge)) {
            mergeDealType.put(MergeDealType.PRE_DEAL_MERGE.name(), canPreDealMerge);
        }

        String canAnyDealMerge = (String)para.get("canAnyDealMerge");
        if(MergeDealType.DEAL_MERGE.getValue().equals(canAnyDealMerge)) {
            mergeDealType.put(MergeDealType.DEAL_MERGE.name(), canAnyDealMerge);
        }

        summary.setMergeDealType(JSONUtil.toJSONString(mergeDealType));
        String subjectForCopy = (String)para.get("subjectForCopy");
        info.setSubjectForCopy(subjectForCopy);
        String isNewBusiness = (String)para.get("newBusiness");
        info.setNewBusiness(Boolean.valueOf("1".equals(isNewBusiness)));
        info.setSummary(summary);
        info.setCurrentUser(user);
        Object canTrack = para.get("canTrack");
        int track = 0;
        if(null != canTrack) {
            track = 1;
            if(null != para.get("radiopart")) {
                track = 2;
            }

            info.getSummary().setCanTrack(Boolean.valueOf(true));
        } else {
            info.getSummary().setCanTrack(Boolean.valueOf(false));
        }

        info.setTrackType(track);
        String newSubject = "";
        if(ct != null && "template".equals(ct.getType())) {
            ColSummary summary1 = (ColSummary)XMLCoder.decoder(ct.getSummary());
            if(summary1 != null && Boolean.TRUE.equals(summary1.getUpdateSubject())) {
                newSubject = ColUtil.makeSubject(ct, summary, user);
                if(Strings.isBlank(newSubject)) {
                    newSubject = "{" + ResourceUtil.getString("collaboration.subject.default") + "}";
                }

                info.getSummary().setSubject(newSubject);
            }
        }

        String trackMemberId = (String)para.get("zdgzry");
        info.setTrackMemberId(trackMemberId);
        String contentSaveId = (String)para.get("contentSaveId");
        info.setContentSaveId(contentSaveId);
        Map map = this.colManager.saveDraft(info, saveProcessFlag, para);

        try {
            String retJs = "parent.endSaveDraft('" + map.get("summaryId").toString() + "','" + map.get("contentId").toString() + "','" + map.get("affairId").toString() + "')";
            if(Strings.isNotBlank(newSubject)) {
                retJs = "parent.endSaveDraft('" + map.get("summaryId").toString() + "','" + map.get("contentId").toString() + "','" + map.get("affairId").toString() + "','" + newSubject + "')";
            }

            super.rendJavaScript(response, retJs);
        } catch (Exception var25) {
            LOG.error("调用js报错！", var25);
        }

        return null;
    }

    public ModelAndView send(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if(!this.checkHttpParamValid(request, response)) {
            return null;
        } else {
            Map para = ParamUtil.getJsonDomain("colMainData");
            ColSummary summary = (ColSummary)ParamUtil.mapToBean(para, new ColSummary(), false);
            String clientDeadTime = (String)para.get("deadLineDateTime");
            if(Strings.isNotBlank(clientDeadTime)) {
                Date serviceDeadTime = Datetimes.parse(clientDeadTime);
                summary.setDeadlineDatetime(serviceDeadTime);
            }

            summary.setSubject(Strings.nobreakSpaceToSpace(summary.getSubject()));
            String dls = (String)para.get("deadLineselect");
            if(Strings.isNotBlank(dls)) {
                summary.setDeadline(Long.valueOf(dls));
            }

            ColInfo info = new ColInfo();
            info.setDR((String)para.get("DR"));
            if(null != para.get("phaseId") && Strings.isNotBlank((String)para.get("phaseId"))) {
                info.setPhaseId((String)para.get("phaseId"));
            }

            if(Strings.isNotBlank((String)para.get("tId"))) {
                info.settId(Long.valueOf((String)para.get("tId")));
            }

            if(Strings.isNotBlank((String)para.get("curTemId"))) {
                info.setCurTemId(Long.valueOf((String)para.get("curTemId")));
            }

            if(Strings.isNotBlank((String)para.get("parentSummaryId"))) {
                summary.setParentformSummaryid(Long.valueOf((String)para.get("parentSummaryId")));
            }

            boolean isCap4Forward = false;
            if(Strings.isNotBlank((String)para.get("isCap4Forward"))) {
                isCap4Forward = "1".equals((String)para.get("isCap4Forward"));
            }

            if(!ColUtil.isForm(summary.getBodyType())) {
                summary.setFormRecordid((Long)null);
                if(!isCap4Forward) {
                    summary.setFormAppid((Long)null);
                }
            }

            if(para.get("processTermTypeCheck") == null) {
                summary.setProcessTermType((Integer)null);
            }

            if(para.get("remindIntervalCheckBox") == null) {
                summary.setRemindInterval((Long)null);
            }

            Map<String, String> mergeDealType = new HashMap();
            String canStartMerge = (String)para.get("canStartMerge");
            if(MergeDealType.START_MERGE.getValue().equals(canStartMerge)) {
                mergeDealType.put(MergeDealType.START_MERGE.name(), canStartMerge);
            }

            String canPreDealMerge = (String)para.get("canPreDealMerge");
            if(MergeDealType.PRE_DEAL_MERGE.getValue().equals(canPreDealMerge)) {
                mergeDealType.put(MergeDealType.PRE_DEAL_MERGE.name(), canPreDealMerge);
            }

            String canAnyDealMerge = (String)para.get("canAnyDealMerge");
            if(MergeDealType.DEAL_MERGE.getValue().equals(canAnyDealMerge)) {
                mergeDealType.put(MergeDealType.DEAL_MERGE.name(), canAnyDealMerge);
            }

            summary.setMergeDealType(JSONUtil.toJSONString(mergeDealType));
            String isNewBusiness = (String)para.get("newBusiness");
            info.setNewBusiness(Boolean.valueOf("1".equals(isNewBusiness)));
            info.setSummary(summary);
            SendType sendType = SendType.normal;
            User user = AppContext.getCurrentUser();
            info.setCurrentUser(user);
            Object canTrack = para.get("canTrack");
            int track = 0;
            if(null != canTrack) {
                track = 1;
                if(null != para.get("radiopart")) {
                    track = 2;
                }

                info.getSummary().setCanTrack(Boolean.valueOf(true));
            } else {
                info.getSummary().setCanTrack(Boolean.valueOf(false));
            }

            info.setTrackType(track);
            info.setTrackMemberId((String)para.get("zdgzry"));
            String caseId = (String)para.get("caseId");
            info.setCaseId(StringUtil.checkNull(caseId)?null:Long.valueOf(Long.parseLong(caseId)));
            String currentaffairId = (String)para.get("currentaffairId");
            info.setCurrentAffairId(StringUtil.checkNull(currentaffairId)?null:Long.valueOf(Long.parseLong(currentaffairId)));
            String currentProcessId = (String)para.get("oldProcessId");
            LOG.info("老协同的currentProcessId=" + currentProcessId);
            info.setCurrentProcessId(StringUtil.checkNull(currentProcessId)?null:Long.valueOf(Long.parseLong(currentProcessId)));
            info.setTemplateHasPigeonholePath(String.valueOf(Boolean.TRUE).equals(para.get("isTemplateHasPigeonholePath")));
            String formViewOperation = (String)para.get("formViewOperation");
            info.setFormViewOperation(formViewOperation);
            int bodyType = 0;

            try {
                bodyType = Integer.parseInt(summary.getBodyType());
            } catch (Exception var33) {
                ;
            }

            if(bodyType > 40 && bodyType < 46) {
                List<CtpContentAll> contents = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
                if(Strings.isEmpty(contents)) {
                    ColUtil.webAlertAndClose(response, "正文保存失败，请重新新建后发送!");
                    return null;
                }
            }

            boolean isLock = false;

            Entry entry;
            try {
                String msg;
                try {
                    CtpAffair sendAffair;
                    if(!this.checkHttpParamValid(request, response)) {
                        sendAffair = null;
                        return null;
                    }

                    isLock = this.colLockManager.canGetLock(summary.getId());
                    if(!isLock) {
                        LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作-send,affairId" + summary.getId());
                        sendAffair = null;
                        return null;
                    }

                    sendAffair = this.affairManager.getSenderAffair(summary.getId());
                    if(sendAffair != null && StateEnum.col_waitSend.getKey() != sendAffair.getState().intValue()) {
                        msg = null;
                        return null;
                    }

                    info.setSenderAffair(sendAffair);
                    this.colManager.transSend(info, sendType);
                } catch (Exception var34) {
                    LOG.error("", var34);
                    msg = Strings.escapeJavascript(ResourceUtil.getString("collaboration.send.error.label.js"));
                    StringBuilder successJson = new StringBuilder();
                    successJson.append("{");
                    successJson.append("'code':1");
                    successJson.append(",'message':'" + msg + "'");
                    successJson.append("}");
                    ColUtil.webWriteMsg(response, successJson.toString());
                    entry = null;
                    return null;
                }
            } finally {
                if(isLock) {
                    this.colLockManager.unlock(summary.getId());
                }

            }

            if("a8genius".equals(request.getParameter("from"))) {
                super.rendJavaScript(response, "try{parent.parent.parent.closeWindow();}catch(e){window.close()}");
                return null;
            } else {
                Map<String, Object> lshmap = (Map)request.getAttribute("lshMap");
                StringBuilder lshsb = new StringBuilder();
                if(null == lshmap) {
                    if("true".equals(para.get("isOpenWindow"))) {
                        super.rendJavaScript(response, "window.close();");
                        return null;
                    } else {
                        return this.redirectModelAndView("collaboration.do?method=listSent");
                    }
                } else {
                    response.setContentType("text/html;charset=UTF-8");
                    Iterator var40 = lshmap.entrySet().iterator();

                    while(var40.hasNext()) {
                        entry = (Entry)var40.next();
                        String key = (String)entry.getKey();
                        String value = (String)entry.getValue();
                        lshsb.append("已在{" + key + "}项上生成流水号:" + value + "\n");
                    }

                    String tslshString = lshsb.toString();
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('" + StringEscapeUtils.escapeJavaScript(tslshString) + "');");
                    out.println("window.location.href = 'collaboration.do?method=listSent';");
                    out.println("</script>");
                    out.flush();
                    return null;
                }
            }
        }
    }

    public ModelAndView sendImmediate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
        String workflowDataFlag = (String)wfdef.get("workflow_data_flag");
        if(Strings.isBlank(workflowDataFlag) || "undefined".equals(workflowDataFlag.trim()) || "null".equals(workflowDataFlag.trim())) {
            LOG.info("来自立即发送sendImmediate");
        }

        Map params = ParamUtil.getJsonParams();
        String summaryIds = (String)params.get("summaryId");
        String affairIds = (String)params.get("affairId");
        if(summaryIds != null && affairIds != null) {
            boolean sentFlag = false;
            String workflowNodePeoplesInput = "";
            String workflowNodeConditionInput = "";
            String workflowNewflowInput = "";
            String toReGo = "";
            if(null != params.get("workflow_node_peoples_input")) {
                workflowNodePeoplesInput = (String)params.get("workflow_node_peoples_input");
            }

            if(null != params.get("workflow_node_condition_input")) {
                workflowNodeConditionInput = (String)params.get("workflow_node_condition_input");
            }

            if(null != params.get("workflow_newflow_input")) {
                workflowNewflowInput = (String)params.get("workflow_newflow_input");
            }

            if(null != params.get("toReGo")) {
                toReGo = (String)params.get("toReGo");
            }

            int bodyType = 0;
            ColSummary summary = null;

            try {
                summary = this.colManager.getColSummaryById(Long.valueOf(summaryIds));
                if(null == summary) {
                    LOG.info("协同已经被删除，不能发送该协同！");
                    return this.redirectModelAndView("collaboration.do?method=listWaitSend" + Functions.csrfSuffix());
                }

                bodyType = Integer.parseInt(summary.getBodyType());
            } catch (Exception var21) {
                ;
            }

            if(bodyType > 40 && bodyType < 46 && summary != null) {
                List<CtpContentAll> contents = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
                if(Strings.isEmpty(contents)) {
                    LOG.info("正文不存在不能立即 发送，请重新编辑后发送!");
                    return this.redirectModelAndView("collaboration.do?method=listSent" + Functions.csrfSuffix());
                }
            }

            boolean isLock = false;
            if(summary != null) {
                ModelAndView var17;
                try {
                    isLock = this.colLockManager.canGetLock(summary.getId());
                    CtpAffair sendAffair;
                    if(!isLock) {
                        LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作sendImmediate,affairId" + summary.getId());
                        sendAffair = null;
                        return null;
                    }

                    sendAffair = this.affairManager.getSenderAffair(summary.getId());
                    if(sendAffair != null && StateEnum.col_waitSend.getKey() == sendAffair.getState().intValue()) {
                        this.colManager.transSendImmediate(summaryIds, sendAffair, sentFlag, workflowNodePeoplesInput, workflowNodeConditionInput, workflowNewflowInput, toReGo);
                        return this.redirectModelAndView("collaboration.do?method=listSent" + Functions.csrfSuffix());
                    }

                    var17 = this.redirectModelAndView("collaboration.do?method=listWaitSend" + Functions.csrfSuffix());
                } finally {
                    if(isLock) {
                        this.colLockManager.unlock(summary.getId());
                    }

                }

                return var17;
            } else {
                return this.redirectModelAndView("collaboration.do?method=listSent" + Functions.csrfSuffix());
            }
        } else {
            return null;
        }
    }

    public ModelAndView listSent(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listSent");
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        request.setAttribute("fflistSent", this.colManager.getSentList(fi, param));
        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(Long.valueOf(AppContext.currentAccountId()));
        boolean isHaveNewColl = MenuPurviewUtil.isHaveNewColl(AppContext.getCurrentUser());
        modelAndView.addObject("newColNodePolicy", Strings.escapeJson(JSONUtil.toJSONString(newColNodePolicy)));
        modelAndView.addObject("isHaveNewColl", Boolean.valueOf(isHaveNewColl));
        modelAndView.addObject("paramMap", param);
        modelAndView.addObject("hasDumpData", Boolean.valueOf(DumpDataVO.isHasDumpData()));
        return modelAndView;
    }

    public ModelAndView list4Quote(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/list4Quote");
        FlipInfo fi = new FlipInfo();
        this.getWebQueryCondition(fi, request);
        modelAndView.addObject("hasDumpData", Boolean.valueOf(DumpDataVO.isHasDumpData()));
        return modelAndView;
    }

    private Map<String, String> getWebQueryCondition(FlipInfo fi, HttpServletRequest request) {
        String condition = request.getParameter("condition");
        String textfield = request.getParameter("textfield");
        Map<String, String> query = new HashMap();
        if(Strings.isNotBlank(condition) && Strings.isNotBlank(textfield)) {
            query.put(condition, textfield);
            fi.setParams(query);
        }

        return query;
    }

    public ModelAndView listDone(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listDone");
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        String openFrom = request.getParameter("openFrom");
        if("aiProcess".equals(openFrom)) {
            String beginTime = request.getParameter("beginTime");
            String endTime = request.getParameter("endTime");
            String dealDate = Datetimes.formatDateStr(beginTime, "yyyy-MM-dd HH:mm:ss") + "#" + Datetimes.formatDateStr(endTime, "yyyy-MM-dd HH:mm:ss");
            param.put(ColQueryCondition.dealDate.name(), dealDate);
            param.put(ColQueryCondition.aiProcessing.name(), "true");
            param.put("openFrom", openFrom);
            modelAndView.addObject("showAIProcessing", "true");
            modelAndView.addObject("beginTime", Datetimes.formatDateStr(beginTime, "yyyy-MM-dd"));
            modelAndView.addObject("endTime", Datetimes.formatDateStr(endTime, "yyyy-MM-dd"));
        }

        request.setAttribute("fflistDone", this.colManager.getDoneList(fi, param));
        modelAndView.addObject("paramMap", param);
        modelAndView.addObject("hasDumpData", Boolean.valueOf(DumpDataVO.isHasDumpData()));
        modelAndView.addObject("hasAIPlugin", Boolean.valueOf(AppContext.hasPlugin("ai")));
        return modelAndView;
    }

    public ModelAndView listPending(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listPending");
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        if(AppContext.hasPlugin("ai")) {
            String aiSortJSON = this.customizeManager.getCustomizeValue(AppContext.currentUserId(), "pending_center_ai_sort");
            Map<String, String> aiSortMap = (Map)JSONUtil.parseJSONString(aiSortJSON, Map.class);
            if(aiSortMap != null && "true".equals(aiSortMap.get("listPending"))) {
                param.put(ColQueryCondition.aiSort.name(), "true");
                modelAndView.addObject("aiSortValue", "true");
            }

            modelAndView.addObject("hasAIPlugin", "true");
        }
        FlipInfo info = this.colManager.getPendingList(fi, param);

        request.setAttribute("fflistPending", info);
        modelAndView.addObject("paramMap", param);
        return modelAndView;
    }

    public ModelAndView listWaitSend(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listWaitSend");
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        request.setAttribute("fflistWaitSend", this.colManager.getWaitSendList(fi, param));
        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(Long.valueOf(AppContext.currentAccountId()));
        modelAndView.addObject("newColNodePolicy", Strings.escapeJson(JSONUtil.toJSONString(newColNodePolicy)));
        modelAndView.addObject("paramMap", param);
        return modelAndView;
    }

    public ModelAndView summary(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView mav = new ModelAndView("apps/collaboration/summary");
        ColSummaryVO summaryVO = new ColSummaryVO();
        User user = AppContext.getCurrentUser();
        String affairId = request.getParameter("affairId");
        if(affairId!=null){
            try {
                CtpAffair affair = this.getAffairManager().get(Long.parseLong(affairId));
                if("outside".equals(affair.getIdentifier())){
                    response.sendRedirect("/seeyon/gateway/affair.do?method=openLink&affairId="+affair.getId());
                    return null;
                }

            }catch(Exception e){
                e.printStackTrace();

            }
        }
        String summaryId = request.getParameter("summaryId");
        String processId = request.getParameter("processId");
        String operationId = request.getParameter("operationId");
        String formMutilOprationIds = request.getParameter("formMutilOprationIds");
        String openFrom = request.getParameter("openFrom");
        String type = request.getParameter("type");
        String contentAnchor = request.getParameter("contentAnchor");
        String pigeonholeType = request.getParameter("pigeonholeType");
        String sessionId = HttpSessionUtil.getSessionId(request);
        String trackTypeRecord = request.getParameter("trackTypeRecord");
        mav.addObject("trackTypeRecord", trackTypeRecord);
        String dumpData = request.getParameter("dumpData");
        boolean isHistoryFlag = "1".equals(dumpData);
        summaryVO.setHistoryFlag(isHistoryFlag);
        if(Strings.isNotBlank(affairId) && !NumberUtils.isNumber(affairId) || Strings.isNotBlank(summaryId) && !NumberUtils.isNumber(summaryId) || Strings.isNotBlank(processId) && !NumberUtils.isNumber(processId)) {
            ColUtil.webAlertAndClose(response, "传入的参数非法，你无法访问该协同！");
            return null;
        } else if(Strings.isBlank(affairId) && Strings.isBlank(summaryId) && Strings.isBlank(processId)) {
            ColUtil.webAlertAndClose(response, "无法访问该协同，请求参数中必须有affairId,summaryId,processId 三个参数中的一个！");
            LOG.info("无法访问该协同，请求参数中必须有affairId,summaryId,processId 三个参数中的一个！");
            return null;
        } else {
            summaryVO.setProcessId(processId);
            summaryVO.setSummaryId(summaryId);
            if(ColOpenFrom.subFlow.name().equals(openFrom)) {
                summaryVO.setFormViewOperation(formMutilOprationIds);
            } else {
                summaryVO.setFormViewOperation(operationId);
            }

            summaryVO.setAffairId(Strings.isBlank(affairId)?null:Long.valueOf(Long.parseLong(affairId)));
            summaryVO.setOpenFrom(openFrom);
            summaryVO.setType(type);
            summaryVO.setCurrentUser(user);
            summaryVO.setLenPotent(request.getParameter("lenPotent"));
            boolean isBlank = Strings.isBlank(pigeonholeType) || "null".equals(pigeonholeType) || "undefined".equals(pigeonholeType);
            summaryVO.setPigeonholeType(Integer.valueOf(isBlank?PigeonholeType.edoc_dept.ordinal():Integer.valueOf(pigeonholeType).intValue()));

            try {
                summaryVO = this.colManager.transShowSummary(summaryVO);
                if(summaryVO == null) {
                    return null;
                }
            } catch (Exception var30) {
                LOG.error("summary方法中summaryVO为空", var30);
                ColUtil.webAlertAndClose(response, var30.getMessage());
                return null;
            }

            if(Strings.isNotBlank(summaryVO.getErrorMsg())) {
                ColUtil.webAlertAndClose(response, summaryVO.getErrorMsg());
                return null;
            } else {
                mav.addObject("forwardEventSubject", summaryVO.getSubject());
                summaryVO.setSubject(Strings.toHTML(Strings.toText(summaryVO.getSubject())));
                summaryVO.getSummary().setSubject(Strings.toHTML(summaryVO.getSummary().getSubject()));
                mav.addObject("summaryVO", summaryVO);
                mav.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
                String messsageAnchor = "";
                if(Strings.isNotBlank(contentAnchor)) {
                    messsageAnchor = contentAnchor;
                }

                CtpAffair affair = summaryVO.getAffair();
                int superNodestatus = 0;
                if(AffairUtil.isSuperNode(affair) && null != summaryVO.getActivityId() && summaryVO.getProcessId() != null) {
                    superNodestatus = this.wapi.getSuperNodeStatus(summaryVO.getProcessId(), String.valueOf(summaryVO.getActivityId()));
                }

                if(superNodestatus != 0) {
                    mav.addObject("nodeattitude", "3");
                }

                mav.addObject("moduleId", summaryVO.getSummary().getId());
                mav.addObject("sessionId", sessionId);
                mav.addObject("moduleType", Integer.valueOf(ModuleType.collaboration.getKey()));
                mav.addObject("MainbodyType", summaryVO.getAffair().getBodyType());
                mav.addObject("superNodestatus", Integer.valueOf(superNodestatus));
                mav.addObject("contentAnchor", messsageAnchor);
                mav.addObject("nodeDesc", (String)request.getAttribute("nodeDesc"));
                mav.addObject("signetProtectInput", request.getAttribute("signetProtectInput"));
                mav.addObject("summaryArchiveId", summaryVO.getSummary().getArchiveId());
                mav.addObject("parentformSummaryid", summaryVO.getSummary().getParentformSummaryid());
                mav.addObject("summaryCanEdit", summaryVO.getSummary().getCanEdit());
                boolean canCreateMeeting = user.hasResourceCode("F09_meetingArrange");
                mav.addObject("canCreateMeeting", Boolean.valueOf(canCreateMeeting));
                boolean showTraceWorkflows = false;
                List<WorkflowTracePO> traceWorkflows = this.traceWorkflowManager.getShowDataByParams(affair.getObjectId(), affair.getActivityId(), affair.getMemberId());
                if(Strings.isNotEmpty(traceWorkflows)) {
                    showTraceWorkflows = true;
                }

                mav.addObject("showTraceWorkflows", Boolean.valueOf(showTraceWorkflows));
                boolean hasFormLock = false;
                if(ColUtil.isForm(summaryVO.getBodyType()) && Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState()) && ColOpenFrom.listPending.name().equals(openFrom)) {
                    FormLockParam lockParam = new FormLockParam();
                    lockParam.setAffairId(Long.valueOf(affairId));
                    lockParam.setAffairState(affair.getState());
                    lockParam.setFormAppId(affair.getFormAppId());
                    lockParam.setFormRecordId(affair.getFormRecordid());
                    lockParam.setNodePolicy(affair.getNodePolicy());
                    lockParam.setRightId(summaryVO.getRightId());
                    lockParam.setAffairReadOnly(Boolean.valueOf(AffairUtil.isFormReadonly(affair)));
                    LockObject lockObject = this.colManager.formAddLock(lockParam);
                    if("0".equals(lockObject.getCanSubmit())) {
                        String alertLockMsg = ResourceUtil.getString("collaboration.common.flag.editingForm", lockObject.getLoginName(), lockObject.getFrom());
                        mav.addObject("alertLockMsg", alertLockMsg);
                        hasFormLock = true;
                    }

                    mav.addObject("realFormLock", lockObject.getRealLockForm());
                    mav.addObject("isReadOnly", lockObject.getIsReadOnly());
                }

                mav.addObject("hasFormLock", Boolean.valueOf(hasFormLock));
                if(AppContext.hasPlugin("ai")) {
                    AIRemindEvent remindEvt = new AIRemindEvent(this);
                    remindEvt.setAffairId(affair.getId());
                    remindEvt.setObjectId(affair.getObjectId());
                    remindEvt.setState(affair.getState());
                    remindEvt.setSubject(affair.getSubject());
                    remindEvt.setOpenFrom(openFrom);
                    remindEvt.setTrack(affair.getTrack());
                    remindEvt.setMemberId(affair.getMemberId());
                    EventDispatcher.fireEvent(remindEvt);
                }

                return mav;
            }
        }
    }

    public ModelAndView repealDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/repealDialog");
        String affairId = request.getParameter("affairId");
        String objectId = request.getParameter("objectId");
        if(Strings.isNotBlank(affairId)) {
            CtpAffair ctpAffair = this.affairManager.get(Long.valueOf(affairId));
            if(null != ctpAffair && null != ctpAffair.getTempleteId()) {
                CtpTemplate ctpTemplate = this.templateManager.getCtpTemplate(ctpAffair.getTempleteId());
                mav.addObject("template", ctpTemplate.getCanTrackWorkflow());
            }
        }

        mav.addObject("affairId", affairId);
        mav.addObject("objectId", objectId);
        return mav;
    }

    private boolean checkHttpParamValid(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
        String workflowDataFlag = (String)wfdef.get("workflow_data_flag");
        if(!Strings.isBlank(workflowDataFlag) && !"undefined".equals(workflowDataFlag.trim()) && !"null".equals(workflowDataFlag.trim())) {
            return true;
        } else {
            PrintWriter out = null;

            try {
                out = response.getWriter();
                out.println("<script>");
                out.println("alert('" + StringEscapeUtils.escapeJavaScript("网络不稳定，从页面获取数据失败，请稍后重试！") + "');");
                out.println(" window.close();");
                out.println("</script>");
            } catch (Exception var10) {
                LOG.error("", var10);
            }

            Enumeration es = request.getHeaderNames();
            StringBuilder stringBuilder = new StringBuilder();
            if(es != null) {
                while(es.hasMoreElements()) {
                    Object name = es.nextElement();
                    String header = request.getHeader(name.toString());
                    stringBuilder.append(Strings.escapeJavascript(name + "") + ":=" + Strings.escapeJavascript(header) + ",");
                }

                LOG.warn("request header---" + stringBuilder.toString());
            }

            return false;
        }
    }

    public ModelAndView finishWorkItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String viewAffairId = request.getParameter("affairId");
        Long affairId = Long.valueOf(Strings.isBlank(viewAffairId)?0L:Long.parseLong(viewAffairId));
        ColSummary summary = null;
        boolean isLock = false;
        CtpAffair affair = null;
        affair = this.affairManager.get(affairId);
        if(affair != null) {
            summary = this.colManager.getSummaryById(affair.getObjectId());
        }

        try {
            StringBuilder errorJson;
            String checkLockMsg;
            try {
                Long templateId;
                if(!this.checkHttpParamValid(request, response)) {
                    templateId = null;
                    return null;
                } else {
                    templateId = null;
                    if(summary != null) {
                        templateId = summary.getTempleteId();
                    } else if(affair != null) {
                        templateId = affair.getTempleteId();
                    }

                    Map templateMap;
                    if(templateId == null || Long.valueOf(0L).equals(templateId) || Long.valueOf(-1L).equals(templateId)) {
                        String[] result = this.wapi.lockWorkflowProcess(summary.getProcessId(), String.valueOf(AppContext.currentUserId()), 14, "", true);
                        checkLockMsg = "";
                        if(null == result) {
                            checkLockMsg = ResourceUtil.getString("workflow.wapi.exception.msg002");
                        } else if(String.valueOf(Boolean.FALSE).equals(result[0])) {
                            checkLockMsg = result[1];
                        }

                        if(Strings.isNotBlank(checkLockMsg)) {
                            LOG.info("自由协同获取锁报错:" + checkLockMsg + ",summary.getProcessId():" + summary.getProcessId());
                             errorJson = new StringBuilder();
                            errorJson.append("{");
                            errorJson.append("'code':1");
                            errorJson.append(",'message':'" + Strings.escapeJavascript(checkLockMsg) + "'");
                            errorJson.append(",'closePage':'false'");
                            errorJson.append("}");
                            ColUtil.webWriteMsg(response, errorJson.toString());
                            templateMap = null;
                            return null;
                        }
                    }

                    isLock = this.colLockManager.canGetLock(affairId);
                    if(!isLock) {
                        LOG.error(AppContext.currentUserName() + "不能获取到map缓存锁，不能执行操作finishWorkItem,affairId" + affairId);
                        errorJson = null;
                        return null;
                    } else {
                        if(affair == null || affair.getState().intValue() != StateEnum.col_pending.key()) {
                            String msg = ColUtil.getErrorMsgByAffair(affair);
                            if(Strings.isNotBlank(msg)) {
                                ColUtil.webAlertAndClose(response, msg);
                                checkLockMsg = null;
                                return null;
                            }
                        }

                        boolean canDeal = ColUtil.checkAgent(affair, summary, true);
                        if(!canDeal) {
                            checkLockMsg = null;
                            return null;
                        } else {
                            Map<String, Object> params = new HashMap();
                            Map<String, String> trackPara = ParamUtil.getJsonDomain("trackDiv_detail");
                            params.put("trackParam", trackPara);
                            templateMap = ParamUtil.getJsonDomain("colSummaryData");
                            params.put("templateColSubject", templateMap.get("templateColSubject"));
                            params.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
                            this.colManager.transFinishWorkItem(summary, affair, params);
                            StringBuilder successJson = new StringBuilder();
                            successJson.append("{");
                            successJson.append("'code':0");
                            successJson.append(",'message':'finishworkitem success!'");
                            successJson.append("}");
                            ColUtil.webWriteMsg(response, successJson.toString());
                            return null;
                        }
                    }
                }
            } catch (BusinessException var17) {
                LOG.error("协同提交报错", var17);
                errorJson = new StringBuilder();
                errorJson.append("{");
                errorJson.append("'code':1");
                errorJson.append(",'message':'" + Strings.escapeJavascript(var17.getMessage()) + "'");
                errorJson.append(",'closePage':'true'");
                errorJson.append("}");
                ColUtil.webWriteMsg(response, errorJson.toString());
                checkLockMsg = null;
                return null;
            }
        } finally {
            if(isLock) {
                this.colLockManager.unlock(affairId);
            }

            if(summary != null) {
                this.colManager.colDelLock(summary, affair, true);
            }

        }
    }

    public ModelAndView doZCDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String viewAffairId = request.getParameter("affairId");
        Long affairId = Long.valueOf(Long.parseLong(viewAffairId));
        CtpAffair affair = this.affairManager.get(affairId);
        if(affair == null || affair.getState().intValue() != StateEnum.col_pending.key()) {
            String msg = ColUtil.getErrorMsgByAffair(affair);
            if(Strings.isNotBlank(msg)) {
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.println("alert('" + StringEscapeUtils.escapeJavaScript(msg) + "');");
                out.println(" window.close();");
                out.println("</script>");
                return null;
            }
        }

        if(affair != null) {
            ColSummary summary = this.colManager.getColSummaryById(affair.getObjectId());
            boolean canDeal = ColUtil.checkAgent(affair, summary, true);
            if(!canDeal) {
                return null;
            } else {
                Map<String, Object> params = new HashMap();
                Map<String, String> trackPara = ParamUtil.getJsonDomain("trackDiv_detail");
                params.put("trackParam", trackPara);
                Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
                params.put("templateColSubject", templateMap.get("templateColSubject"));
                params.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
                boolean isLock = false;

                Object var12;
                try {
                    isLock = this.colLockManager.canGetLock(affairId);
                    if(isLock) {
                        this.colManager.transDoZcdb(summary, affair, params);
                        return null;
                    }

                    LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作doZCDB,affairId" + affairId);
                    var12 = null;
                } finally {
                    if(isLock) {
                        this.colLockManager.unlock(affairId);
                    }

                    this.colManager.colDelLock(summary, affair);
                }

                return (ModelAndView)var12;
            }
        } else {
            return null;
        }
    }

    public ModelAndView doForward(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        Map para = ParamUtil.getJsonDomain("MainData");
        String data = (String)para.get("data");
        String[] ds = data.split("[,]");
        String[] var7 = ds;
        int var8 = ds.length;

        for(int var9 = 0; var9 < var8; ++var9) {
            String d1 = var7[var9];
            if(!Strings.isBlank(d1)) {
                String[] d1s = d1.split("[_]");
                long summaryId = Long.parseLong(d1s[0]);
                long affairId = Long.parseLong(d1s[1]);
                this.colManager.transDoForward(user, Long.valueOf(summaryId), Long.valueOf(affairId), para);
            }
        }

        return null;
    }

    public ModelAndView chooseOperation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mv = new ModelAndView("apps/collaboration/isignaturehtml/chooseOperation");
        return mv;
    }

    public ModelAndView showForward(HttpServletRequest request, HttpServletResponse response) throws Exception {
        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(Long.valueOf(AppContext.currentAccountId()));
        request.setAttribute("newColNodePolicy", newColNodePolicy);
        return new ModelAndView("apps/collaboration/forward");
    }

    public ModelAndView stepStop(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String affairId = request.getParameter("affairId");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("affairId", affairId);
        boolean isLock = false;

        try {
            isLock = this.colLockManager.canGetLock(Long.valueOf(affairId));
            Map trackPara;
            if(!isLock) {
                LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作stepStop,affairId" + affairId);
                trackPara = null;
                return null;
            }

            trackPara = ParamUtil.getJsonDomain("trackDiv_detail");
            tempMap.put("trackParam", trackPara);
            Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
            tempMap.put("templateColSubject", templateMap.get("templateColSubject"));
            tempMap.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
            this.colManager.transStepStop(tempMap);
        } finally {
            if(isLock) {
                this.colLockManager.unlock(Long.valueOf(affairId));
            }

            this.colManager.colDelLock(Long.valueOf(affairId));
        }

        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("window.parent.$('#summary').attr('src','');");
        out.println("window.parent.$('.slideDownBtn').trigger('click');");
        out.println("window.parent.$('#listPending').ajaxgridLoad();");
        out.println("</script>");
        out.close();
        return null;
    }

    public ModelAndView stepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String affairId = request.getParameter("affairId");
        String summaryId = request.getParameter("summaryId");
        String trackWorkflowType = request.getParameter("isWFTrace");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("affairId", affairId);
        tempMap.put("summaryId", summaryId);
        tempMap.put("targetNodeId", "");
        tempMap.put("isWFTrace", trackWorkflowType);
        Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
        tempMap.put("templateColSubject", templateMap.get("templateColSubject"));
        tempMap.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
        boolean isLock = false;

        label93: {
            String msg;
            try {
                isLock = this.colLockManager.canGetLock(Long.valueOf(affairId));
                if(isLock) {
                    msg = this.colManager.transStepBack(tempMap);
                    if(!Strings.isNotBlank(msg)) {
                        break label93;
                    }

                    ColUtil.webAlertAndClose(response, msg);
                    Object var10 = null;
                    return (ModelAndView)var10;
                }

                LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作stepBack,affairId:" + affairId);
                msg = null;
            } finally {
                if(isLock) {
                    this.colLockManager.unlock(Long.valueOf(affairId));
                }

                this.colManager.colDelLock(Long.valueOf(affairId));
            }

            return null;
        }

        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("window.parent.$('#summary').attr('src','');");
        out.println("window.parent.$('.slideDownBtn').trigger('click');");
        out.println("window.parent.$('#listPending').ajaxgridLoad();");
        out.println("</script>");
        out.close();
        return null;
    }

    public ModelAndView updateAppointStepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String workitemId = request.getParameter("workitemId");
        String processId = request.getParameter("processId");
        String caseId = request.getParameter("caseId");
        String activityId = request.getParameter("activityId");
        String theStepBackNodeId = request.getParameter("theStepBackNodeId");
        String submitStyle = request.getParameter("submitStyle");
        String summaryId = request.getParameter("summaryId");
        String affairId = request.getParameter("affairId");
        String isWfTrace = request.getParameter("isWFTrace");
        String isCircleBack = request.getParameter("isCircleBack");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("workitemId", workitemId);
        tempMap.put("processId", processId);
        tempMap.put("caseId", caseId);
        tempMap.put("activityId", activityId);
        tempMap.put("theStepBackNodeId", theStepBackNodeId);
        tempMap.put("submitStyle", submitStyle);
        tempMap.put("affairId", affairId);
        tempMap.put("summaryId", summaryId);
        tempMap.put("isWFTrace", isWfTrace);
        tempMap.put("isCircleBack", isCircleBack);
        User user = AppContext.getCurrentUser();
        boolean isLock = false;
        Long affairIdLong = Long.valueOf(Long.parseLong(affairId));
        ColSummary summary = null;

        CtpAffair currentAffair;
        try {
            isLock = this.colLockManager.canGetLock(affairIdLong);
            if(isLock) {
                currentAffair = this.affairManager.get(Long.valueOf(Long.parseLong(affairId)));
                Map trackPara;
                if(currentAffair == null || currentAffair.getState().intValue() != StateEnum.col_pending.key()) {
                    String msg = ColUtil.getErrorMsgByAffair(currentAffair);
                    if(Strings.isNotBlank(msg)) {
                        ColUtil.webAlertAndClose(response, msg);
                        trackPara = null;
                        return null;
                    }
                }

                summary = this.colManager.getColSummaryById(Long.valueOf(Long.parseLong(summaryId)));
                Comment comment = ContentUtil.getCommnetFromRequest(OperationType.appointStepBack, currentAffair.getMemberId(), currentAffair.getObjectId());
                comment.setModuleId(summary.getId());
                comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
                if(!user.getId().equals(currentAffair.getMemberId())) {
                    comment.setExtAtt2(user.getName());
                }

                comment.setCreateId(currentAffair.getMemberId());
                comment.setExtAtt3("collaboration.dealAttitude.rollback");
                comment.setModuleType(Integer.valueOf(ModuleType.collaboration.getKey()));
                comment.setPid(Long.valueOf(0L));
                tempMap.put("affair", currentAffair);
                tempMap.put("summary", summary);
                tempMap.put("comment", comment);
                tempMap.put("user", user);
                trackPara = ParamUtil.getJsonDomain("trackDiv_detail");
                tempMap.put("trackParam", trackPara);
                Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
                tempMap.put("templateColSubject", templateMap.get("templateColSubject"));
                tempMap.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
                this.colManager.updateAppointStepBack(tempMap);
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.println("window.parent.$('#summary').attr('src','');");
                out.println("window.parent.$('.slideDownBtn').trigger('click');");
                out.println("window.parent.$('#listPending').ajaxgridLoad();");
                out.println("</script>");
                out.close();
                return null;
            }

            LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作finishWorkItem,affairId" + affairId);
            currentAffair = null;
        } finally {
            if(isLock) {
                this.colLockManager.unlock(affairIdLong);
            }

            if(summary != null) {
                this.wapi.releaseWorkFlowProcessLock(summary.getProcessId(), user.getId().toString(), 14);
            }

        }

        return null;
    }

    public ModelAndView listRecord(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("common/supervise/superviseDetail/recordDetailList");
        String recordType = request.getParameter("record");
        String showPigonHoleBtn = request.getParameter("showPigonHoleBtn");
        String hasDumpData = request.getParameter("hasDumpData");
        String srcFrom = request.getParameter("srcFrom");
        modelAndView.addObject("recordType", recordType);
        modelAndView.addObject("showPigonHoleBtn", showPigonHoleBtn);
        modelAndView.addObject("hasDumpData", hasDumpData);
        modelAndView.addObject("openFrom", "listDone");
        modelAndView.addObject("srcFrom", srcFrom);
        modelAndView.addObject("hasAIPlugin", Boolean.valueOf(AppContext.hasPlugin("ai")));
        modelAndView.addObject("paramTemplateIds", request.getParameter("paramTemplateIds"));
        return modelAndView;
    }

    public ModelAndView repeal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String summaryId = request.getParameter("summaryId");
        String affairId = request.getParameter("affairId");
        String trackWorkflowType = request.getParameter("isWFTrace");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("summaryId", summaryId);
        tempMap.put("affairId", affairId);
        tempMap.put("repealComment", request.getParameter("repealComment"));
        tempMap.put("isWFTrace", trackWorkflowType);
        Long laffairId = Long.valueOf(affairId);

        try {
            this.colManager.transRepal(tempMap);
        } finally {
            this.colManager.colDelLock(laffairId, true);
        }

        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("window.parent.$('#summary').attr('src','');");
        out.println("window.parent.$('.slideDownBtn').trigger('click');");
        out.println("window.parent.$('#listPending').ajaxgridLoad();");
        out.println("</script>");
        out.close();
        return null;
    }

    public ModelAndView getAttributeSettingInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/showAttributeSetting");
        String affairId = request.getParameter("affairId");
        String isHistoryFlag = request.getParameter("isHistoryFlag");
        Map args = new HashMap();
        args.put("affairId", affairId);
        args.put("isHistoryFlag", isHistoryFlag);
        Map map = this.colManager.getAttributeSettingInfo(args);
        mav.addObject("remindIntervalTitle", map.get("remindIntervalTitle"));
        map.put("archiveName", map.get("archiveAllName"));
        request.setAttribute("ffattribute", map);
        mav.addObject("archiveAllName", map.get("archiveAllName"));
        mav.addObject("attachmentArchiveName", map.get("attachmentArchiveName"));
        mav.addObject("supervise", map.get("supervise"));
        mav.addObject("processTermTypeName", map.get("processTermTypeName"));
        mav.addObject("openFrom", request.getParameter("openFrom"));
        return mav;
    }

    public ModelAndView showTakebackConfirm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/takebackConfirm");
        return mav;
    }

    public ModelAndView showRepealCommentDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("common/workflowmanage/repealCommentDialog");
        return mav;
    }

    public ModelAndView showPortalCatagory(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalCatagory");
        request.setAttribute("openFrom", request.getParameter("openFrom"));
        String category = ReqUtil.getString(request, "category", "");
        if(Strings.isNotBlank(category)) {
            mav = new ModelAndView("apps/collaboration/showPortalCatagory4MyTemplate");
        }

        return mav;
    }

    public ModelAndView showPortalImportLevel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalImportLevel");
        List<CtpEnumItem> secretLevelItems = this.enumManagerNew.getEnumItems(EnumNameEnum.edoc_urgent_level);
        ColUtil.putImportantI18n2Session();
        mav.addObject("itemCount", Integer.valueOf(secretLevelItems.size()));
        return mav;
    }

    public ModelAndView disagreeDeal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/disagreeDeal");
        return mav;
    }

    public ModelAndView forwordMail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map query = new HashMap();
        query.put("summaryId", Long.valueOf(Long.parseLong(request.getParameter("summaryId"))));
        query.put("affairId", Long.valueOf(Long.parseLong(request.getParameter("affairId"))));
        query.put("formContent", String.valueOf(request.getParameter("formContent")));
        ModelAndView mv = this.colManager.getforwordMail(query);
        return mv;
    }

    public ModelAndView saveAsTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/saveAsTemplate");
        String hasWorkflow = request.getParameter("hasWorkflow");
        String subject = request.getParameter("subject");
        String tembodyType = request.getParameter("tembodyType");
        String formtitle = request.getParameter("formtitle");
        String defaultValue = request.getParameter("defaultValue");
        String ctype = request.getParameter("ctype");
        String temType = request.getParameter("temType");
        if("hasnotTemplate".equals(temType)) {
            mav.addObject("canSelectType", "all");
        } else if("template".equals(temType)) {
            mav.addObject("canSelectType", "template");
        } else if("workflow".equals(temType)) {
            mav.addObject("canSelectType", "workflow");
        } else if("text".equals(temType)) {
            mav.addObject("canSelectType", "text");
        }

        if(Strings.isNotBlank(ctype)) {
            int n = Integer.parseInt(ctype);
            if(n == 20) {
                mav.addObject("onlyTemplate", Boolean.TRUE);
            }
        }

        mav.addObject("hasWorkflow", hasWorkflow);
        mav.addObject("subject", subject);
        mav.addObject("tembodyType", tembodyType);
        mav.addObject("formtitle", formtitle);
        mav.addObject("defaultValue", defaultValue);
        return mav;
    }

    public ModelAndView detail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return this.summary(request, response);
    }

    public ModelAndView updateContentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/updateContentPage");
        String summaryId = request.getParameter("summaryId");
        ContentViewRet context = ContentUtil.contentView(ModuleType.collaboration, Long.valueOf(Long.parseLong(summaryId)), (Long)null, 1, (String)null);
        return mav;
    }

    public ModelAndView componentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/componentPage");
        String affairId = request.getParameter("affairId");
        String rightId = request.getParameter("rightId");
        String readonly = request.getParameter("readonly");
        String openFrom = request.getParameter("openFrom");
        String isHistoryFlagView = request.getParameter("isHistoryFlag");
        String canPraise = request.getParameter("canPraise");
        String subState = request.getParameter("subState");
        String summaryArchiveId = request.getParameter("summaryArchiveId");
        String parentformSummaryid = request.getParameter("parentformSummaryid");
        String summaryCanEdit = request.getParameter("summaryCanEdit");
        Long parentformSummaryidl = null;
        if(Strings.isNotBlank(parentformSummaryid)) {
            parentformSummaryidl = Long.valueOf(parentformSummaryid);
        }

        boolean summaryCanEditb = true;
        if(Strings.isNotBlank(summaryCanEdit)) {
            summaryCanEditb = Boolean.valueOf(summaryCanEdit).booleanValue();
        }

        Long summaryArchiveIdl = null;
        if(Strings.isNotBlank(summaryArchiveId)) {
            summaryArchiveIdl = Long.valueOf(summaryArchiveId);
        }

        boolean isHistoryFlag = Strings.isBlank(isHistoryFlagView)?false:Boolean.valueOf(isHistoryFlagView).booleanValue();
        canPraise = canPraise == null?"true":canPraise;
        mav.addObject("canPraise", Boolean.valueOf(canPraise));
        mav.addObject("isHasPraise", request.getParameter("isHasPraise"));
        mav.addObject("subState", subState);
        List<String> trackType = new ArrayList();
        trackType.add(String.valueOf(workflowTrackType.step_back_repeal.getKey()));
        trackType.add(String.valueOf(workflowTrackType.special_step_back_repeal.getKey()));
        trackType.add(String.valueOf(workflowTrackType.circle_step_back_repeal.getKey()));
        if(trackType.contains(request.getParameter("trackType")) && "stepBackRecord".equals(openFrom)) {
            openFrom = "repealRecord";
        }

        CtpAffair affair = null;
        if(isHistoryFlag) {
            affair = this.affairManager.getByHis(Long.valueOf(affairId));
        } else {
            affair = this.affairManager.get(Long.valueOf(affairId));
        }

        User user = AppContext.getCurrentUser();
        mav.addObject("moduleId", affair.getObjectId().toString());
        mav.addObject("affair", affair);
        boolean signatrueShowFlag = Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState()) && "listPending".equals(openFrom);
        mav.addObject("canDeleteISigntureHtml", Boolean.valueOf(signatrueShowFlag));
        mav.addObject("isShowMoveMenu", Boolean.valueOf(signatrueShowFlag));
        mav.addObject("isShowDocLockMenu", Boolean.valueOf(signatrueShowFlag));
        boolean isFormQuery = ColOpenFrom.formQuery.name().equals(openFrom);
        boolean isFormStatistical = ColOpenFrom.formStatistical.name().equals(openFrom);
        boolean ifFromstepBackRecord = ColOpenFrom.stepBackRecord.name().equalsIgnoreCase(openFrom);
        boolean isFromrepealRecord = ColOpenFrom.repealRecord.name().equalsIgnoreCase(openFrom);
        if(!isFormQuery && !isFormStatistical && !ifFromstepBackRecord && !isFromrepealRecord) {
            if(!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.collaboration, user, affair.getId(), affair, summaryArchiveIdl)) {
                return null;
            }

            AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, String.valueOf(affair.getObjectId()), user.getId().longValue());
        }

        int viewState = 2;
        if(ColUtil.isForm(affair.getBodyType()) && Integer.valueOf(StateEnum.col_pending.key()).equals(affair.getState()) && !"inform".equals(ColUtil.getPolicyByAffair(affair).getId()) && !AffairUtil.isFormReadonly(affair) && !"glwd".equals(openFrom) && !AffairUtil.isSuperNode(affair) && !"listDone".equals(openFrom)) {
            viewState = 1;
        }

        ContentUtil.contentViewForDetail_col(ModuleType.collaboration, affair.getObjectId(), affair.getId(), viewState, rightId, isHistoryFlag);
        mav.addObject("_viewState", Integer.valueOf(viewState));
        Map<String, List<String>> logDescMap = this.getCommentLog(affair.getProcessId());
        String jsonString = JSONUtil.toJSONString(logDescMap);
        mav.addObject("logDescMap", jsonString);
        List<CtpContentAllBean> contentList = (List)request.getAttribute("contentList");
        request.setAttribute("contentList", contentList);
        if(parentformSummaryidl != null && !summaryCanEditb) {
            mav.addObject("isFromTransform", Boolean.valueOf(true));
        }

        if("repealRecord".equals(openFrom)) {
            List<WorkflowTracePO> dataByParams = this.traceWorkflowManager.getDataByModuleIdAndAffairId(affair.getObjectId(), affair.getId());
            Long currentUserId = Long.valueOf(AppContext.currentUserId());
            if(null != dataByParams && dataByParams.size() > 0) {
                boolean flag = true;
                List<CtpContentAll> conList = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, affair.getObjectId());

                for(int a = 0; a < dataByParams.size(); ++a) {
                    if(((WorkflowTracePO)dataByParams.get(a)).getMemberId().equals(currentUserId)) {
                        if(Strings.isNotEmpty(conList) && Strings.isNotBlank(((WorkflowTracePO)dataByParams.get(a)).getFormContent())) {
                            ((CtpContentAll)conList.get(0)).setContent(((WorkflowTracePO)dataByParams.get(a)).getFormContent());
                            this.ctpMainbodyManager.saveOrUpdateContentAll((CtpContentAll)conList.get(0));
                            flag = false;
                        }
                        break;
                    }
                }

                if(flag && Strings.isNotEmpty(conList) && Strings.isNotBlank(((WorkflowTracePO)dataByParams.get(0)).getFormContent())) {
                    ((CtpContentAll)conList.get(0)).setContent(((WorkflowTracePO)dataByParams.get(0)).getFormContent());
                    this.ctpMainbodyManager.saveOrUpdateContentAll((CtpContentAll)conList.get(0));
                }
            }
        }

        mav.addObject("_rightId", rightId);
        mav.addObject("_moduleId", affair.getObjectId());
        mav.addObject("_moduleType", Integer.valueOf(ModuleType.collaboration.getKey()));
        mav.addObject("_contentType", affair.getBodyType());
        ContentViewRet ret = (ContentViewRet)request.getAttribute("contentContext");
        ret.setCanReply(true);
        String workflowTraceType = request.getParameter("trackType");
        Integer intWorkflowTraceType = Integer.valueOf(Strings.isNotBlank(workflowTraceType)?Integer.valueOf(workflowTraceType).intValue():0);
        if(Integer.valueOf(workflowTrackType.repeal.getKey()).equals(intWorkflowTraceType) || Integer.valueOf(workflowTrackType.step_back_repeal.getKey()).equals(intWorkflowTraceType)) {
            readonly = "true";
            ret.setCanReply(false);
        }

        if("true".equals(isHistoryFlagView) || openFrom == "newColl" || openFrom == "listWaitSend" && affair.getSubState().intValue() == 16) {
            ret.setCanReply(false);
        }

        ColSummary sum = this.colManager.getColSummaryById(affair.getObjectId());
        if(sum != null && sum.getState() != null && (sum.getState().intValue() == flowState.finish.ordinal() || sum.getState().intValue() == flowState.terminate.ordinal())) {
            String anyReply = this.systemConfig.get("anyReply_enable");
            if(Strings.isNotBlank(anyReply) && anyReply.equals("disable")) {
                ret.setCanReply(false);
            }
        }

        if(ColOpenFrom.formQuery.name().equals(openFrom) || ColOpenFrom.formStatistical.name().equals(openFrom)) {
            AppContext.putThreadContext("THREAD_CTX_NO_HIDDEN_COMMENT", "true");
        }

        AppContext.putThreadContext("THREAD_CTX_NOT_HIDE_TO_ID_KEY", affair.getSenderId());
        if(!ColOpenFrom.supervise.name().equals(openFrom) && !ColOpenFrom.repealRecord.name().equals(openFrom)) {
            AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", affair.getMemberId());
        }

        if(ColOpenFrom.glwd.name().equals(openFrom)) {
            List<Long> memberIds = this.affairManager.getAffairMemberIds(ApplicationCategoryEnum.collaboration, affair.getObjectId());
            AppContext.putThreadContext("THREAD_CTX_PROCESS_MEMBERS", Strings.isNotEmpty(memberIds)?memberIds:new ArrayList());
        }

        if(Integer.valueOf(flowState.finish.ordinal()).equals(affair.getSummaryState()) || Integer.valueOf(flowState.terminate.ordinal()).equals(affair.getSummaryState()) || ColOpenFrom.glwd.name().equals(openFrom) || Boolean.valueOf(readonly).booleanValue()) {
            mav.addObject("_isffin", "1");
        }

        mav.addObject("title", affair.getSubject());
        mav.addObject("openFrom", openFrom);
        ret.setContentSenderId(affair.getSenderId());
        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(user.getLoginAccount());
        mav.addObject("newColNodePolicy", newColNodePolicy);
        mav.addObject("isNewColNode", Boolean.valueOf((affair.getState().equals(Integer.valueOf(StateEnum.col_sent.getKey())) || affair.getState().equals(Integer.valueOf(StateEnum.col_waitSend.getKey()))) && !ColOpenFrom.supervise.name().equals(openFrom)));
        mav.addObject("isHistoryFlagView", isHistoryFlagView);
        boolean isFormOffice = false;
        if(ColUtil.isForm(affair.getBodyType())) {
            isFormOffice = true;
        }

        mav.addObject("isFormOffice", Boolean.valueOf(isFormOffice));
        return mav;
    }

    public MainbodyManager getCtpMainbodyManager() {
        return this.ctpMainbodyManager;
    }

    public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
        this.ctpMainbodyManager = ctpMainbodyManager;
    }

    public ModelAndView doDraftOpinion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long summaryId = Long.parseLong(request.getParameter("summaryId"));
        long affairId = Long.valueOf(request.getParameter("affairId")).longValue();
        this.colManager.saveOpinionDraft(Long.valueOf(affairId), Long.valueOf(summaryId));
        return null;
    }

    public ModelAndView statisticSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/colStatisticSearch");
        String bodyType = request.getParameter("bodyType");
        String collType = request.getParameter("CollType");
        String templateId = request.getParameter("templateId");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String status = request.getParameter("state");
        String userId = request.getParameter("user_id");
        String coverTime = request.getParameter("coverTime");
        String isGroup = request.getParameter("isGroup");
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getStatisticSearchCondition(fi, request);
        mav.addObject("isTeamReport", param.get("isTeamReport"));
        request.setAttribute("fflistStatistic", this.colManager.getStatisticSearchCols(fi, param));
        mav.addObject("bodyType", bodyType);
        mav.addObject("CollType", collType);
        mav.addObject("templateId", templateId);
        mav.addObject("start_time", startTime);
        mav.addObject("end_time", endTime);
        mav.addObject("state", status);
        mav.addObject("user_id", userId);
        mav.addObject("coverTime", coverTime);
        mav.addObject("isGroup", isGroup);
        return mav;
    }

    public ModelAndView openTrackDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/trackDetail");
        String objectId = request.getParameter("objectId");
        String affairId = request.getParameter("affairId");
        ColSummary summary = this.colManager.getColSummaryById(Long.valueOf(objectId));
        CtpAffair affair = this.affairManager.get(Long.valueOf(affairId));
        int trackType = affair.getTrack().intValue();
        Long startMemberId = summary.getStartMemberId();
        int state = summary.getState().intValue();
        if(trackType == 2) {
            List<CtpTrackMember> trackList = this.trackManager.getTrackMembers(Long.valueOf(affairId));
            String zdgzrStr = "";
            StringBuilder sb = new StringBuilder();
            int a = 0;

            for(int j = trackList.size(); a < j; ++a) {
                CtpTrackMember cm = (CtpTrackMember)trackList.get(a);
                sb.append("Member|" + cm.getTrackMemberId() + ",");
            }

            zdgzrStr = sb.toString();
            if(Strings.isNotBlank(zdgzrStr)) {
                mav.addObject("zdgzrStr", zdgzrStr.substring(0, zdgzrStr.length() - 1));
            }
        }

        mav.addObject("objectId", objectId);
        mav.addObject("affairId", affairId);
        mav.addObject("trackType", Integer.valueOf(trackType));
        mav.addObject("state", Integer.valueOf(state));
        mav.addObject("startMemberId", startMemberId);
        return mav;
    }

    private Map<String, String> getStatisticSearchCondition(FlipInfo fi, HttpServletRequest request) {
        Map<String, String> query = new HashMap();
        User user = AppContext.getCurrentUser();
        if(user == null) {
            return query;
        } else {
            String bodyType = request.getParameter("bodyType");
            if(Strings.isNotBlank(bodyType)) {
                query.put(ColQueryCondition.bodyType.name(), bodyType);
            }

            String collType = request.getParameter("CollType");
            if(Strings.isNotBlank(collType)) {
                query.put(ColQueryCondition.CollType.name(), collType);
            }

            String templateId = request.getParameter("templateId");
            if(Strings.isNotBlank(templateId) && !"null".equals(templateId)) {
                query.put(ColQueryCondition.templeteIds.name(), templateId);
            }

            String state = request.getParameter("state");
            List<Integer> states = new ArrayList();
            String userId;
            if(Strings.isNotBlank(state) && !"null".equals(state)) {
                String[] stateStrs = state.split(",");
                String[] var11 = stateStrs;
                int var12 = stateStrs.length;

                for(int var13 = 0; var13 < var12; ++var13) {
                    userId = var11[var13];
                    states.add(Integer.valueOf(userId));
                }

                if(states.contains(Integer.valueOf(1))) {
                    query.put(ColQueryCondition.archiveId.name(), "archived");
                    states.remove(states.indexOf(Integer.valueOf(1)));
                }

                if(states.contains(Integer.valueOf(0))) {
                    query.put(ColQueryCondition.subState.name(), String.valueOf(SubStateEnum.col_pending_ZCDB.getKey()));
                    states.remove(states.indexOf(Integer.valueOf(0)));
                }

                if(states.size() > 0) {
                    state = Functions.join(states, ",");
                    query.put(ColQueryCondition.state.name(), state);
                }
            }

            String startTime = request.getParameter("start_time");
            String endTime = request.getParameter("end_time");
            String queryTime = "";
            if(Strings.isEmpty(startTime) && Strings.isEmpty(endTime)) {
                queryTime = null;
            } else {
                queryTime = startTime + "#" + endTime;
            }

            if(Strings.isNotBlank(queryTime)) {
                if(states.size() == 1) {
                    if(Integer.valueOf(StateEnum.col_sent.getKey()).equals(states.get(0))) {
                        query.put(ColQueryCondition.createDate.name(), queryTime);
                    } else if(Integer.valueOf(StateEnum.col_pending.getKey()).equals(states.get(0))) {
                        query.put(ColQueryCondition.receiveDate.name(), queryTime);
                    } else if(Integer.valueOf(StateEnum.col_done.getKey()).equals(states.get(0))) {
                        query.put(ColQueryCondition.completeDate.name(), queryTime);
                    }
                } else if(String.valueOf(SubStateEnum.col_pending_ZCDB.getKey()).equals(query.get(ColQueryCondition.subState.name()))) {
                    query.put(ColQueryCondition.updateDate.name(), queryTime);
                }

                if("archived".equals(query.get(ColQueryCondition.archiveId.name())) || states.size() > 1) {
                    query.put("statisticDate", queryTime);
                }
            }

            String coverTime = request.getParameter("coverTime");
            if(Strings.isNotBlank(coverTime)) {
                query.put(ColQueryCondition.coverTime.name(), coverTime);
            }

            userId = request.getParameter("user_id");
            if(Strings.isNotBlank(userId)) {
                query.put(ColQueryCondition.currentUser.name(), userId);
            }

            query.put("statistic", "true");
            String isGroup = request.getParameter("isGroup");
            if(Strings.isNotBlank(isGroup)) {
                query.put("isTeamReport", isGroup);
            }

            fi.setParams(query);
            return query;
        }
    }

    public ModelAndView findAttachmentListBuSummaryId(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mv = new ModelAndView("apps/collaboration/attachmentList");
        String summaryId = request.getParameter("summaryId");
        String affairId = request.getParameter("affairId");
        CtpAffair affair = this.affairManager.get(Long.valueOf(affairId));
        if(affair == null) {
            affair = this.affairManager.getByHis(Long.valueOf(affairId));
        }

        ColSummary summary = this.colManager.getColSummaryById(affair.getObjectId());
        User user = AppContext.getCurrentUser();
        String memberId = String.valueOf(affair.getMemberId());
        if(!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.collaboration, user, affair.getId(), affair, summary.getArchiveId(), false)) {
            SecurityCheck.printInbreakTrace(AppContext.getRawRequest(), AppContext.getRawResponse(), user, ApplicationCategoryEnum.collaboration);
            return null;
        } else {
            String openFrom = request.getParameter("openFromList");
            if(!ColOpenFrom.supervise.name().equals(openFrom) && Strings.isNotBlank(memberId)) {
                AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", Long.valueOf(memberId));
            }

            List<AttachmentVO> attachmentVOs = this.colManager.getAttachmentListBySummaryId(Long.valueOf(summaryId), Long.valueOf(memberId));
            boolean canLook = false;
            Iterator var13 = attachmentVOs.iterator();

            while(var13.hasNext()) {
                AttachmentVO attachmentVO = (AttachmentVO)var13.next();
                if(attachmentVO.isCanLook()) {
                    canLook = true;
                    break;
                }

                if("jpg".equals(attachmentVO.getFileType()) || "gif".equals(attachmentVO.getFileType()) || "jpeg".equals(attachmentVO.getFileType()) || "png".equals(attachmentVO.getFileType()) || "bmp".equals(attachmentVO.getFileType()) || "pdf".equals(attachmentVO.getFileType())) {
                    canLook = true;
                    break;
                }
            }

            mv.addObject("canLook", Boolean.valueOf(canLook));
            mv.addObject("attachmentVOs", attachmentVOs);
            mv.addObject("attSize", Integer.valueOf(attachmentVOs.size()));
            mv.addObject("isHistoryFlag", request.getParameter("isHistoryFlag"));
            return mv;
        }
    }

    public ModelAndView exportColSummaryExcel(HttpServletRequest request, HttpServletResponse response) {
        new ArrayList();
        FlipInfo fi = new FlipInfo();

        try {
            Map<String, String> param = this.getStatisticSearchCondition(fi, request);
            List<ColSummaryVO> colList = this.colManager.exportDetaileExcel((FlipInfo)null, param);
            String subject = ResourceUtil.getString("common.subject.label");
            String sendUser = ResourceUtil.getString("cannel.display.column.sendUser.label");
            String sendtime = ResourceUtil.getString("common.date.sendtime.label");
            String receiveTime = ResourceUtil.getString("cannel.display.column.receiveTime.label");
            String donedate = ResourceUtil.getString("common.date.donedate.label");
            String deadlineDate = ResourceUtil.getString("pending.deadlineDate.label");
            String track = ResourceUtil.getString("collaboration.track.state");
            String[] columnName = new String[]{subject, sendUser, sendtime, receiveTime, donedate, deadlineDate, track};
            DataRecord dataRecord = new DataRecord();
            String excelName = ResourceUtil.getString("report.onelinework.through");
            dataRecord.setTitle(excelName);
            dataRecord.setSheetName(excelName);
            dataRecord.setColumnName(columnName);

            for(int i = 0; i < colList.size(); ++i) {
                ColSummaryVO data = (ColSummaryVO)colList.get(i);
                DataRow dataRow = new DataRow();
                dataRow.addDataCell(data.getSubject(), 1);
                dataRow.addDataCell(data.getStartMemberName(), 1);
                dataRow.addDataCell(data.getStartDate() != null?Datetimes.format(data.getStartDate(), "yyyy-MM-dd HH:mm").toString():"-", 5);
                dataRow.addDataCell(data.getReceiveTime() != null?Datetimes.format(data.getReceiveTime(), "yyyy-MM-dd HH:mm").toString():"-", 5);
                dataRow.addDataCell(data.getDealTime() != null?Datetimes.format(data.getDealTime(), "yyyy-MM-dd HH:mm").toString():"-", 5);
                dataRow.addDataCell(data.getDeadLineDateName(), 1);
                dataRow.addDataCell(data.getTrack().intValue() == 1?ResourceUtil.getString("message.yes.js"):ResourceUtil.getString("message.no.js"), 1);
                dataRecord.addDataRow(new DataRow[]{dataRow});
            }

            this.fileToExcelManager.save(response, dataRecord.getTitle(), new DataRecord[]{dataRecord});
        } catch (Exception var19) {
            LOG.error("为用户绩效报表穿透查询列表时出现异常:", var19);
        }

        return null;
    }

    public ModelAndView combinedQuery(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/col_com_query");
        if("templeteAll".equals(request.getParameter("condition")) && "all".equals(request.getParameter("textfield"))) {
            modelAndView.addObject("condition1", "1");
        }

        if("bizcofnig".equals(request.getParameter("srcFrom"))) {
            modelAndView.addObject("condition2", "1");
        }

        if("1".equals(request.getParameter("bisnissMap"))) {
            modelAndView.addObject("condition3", "1");
        }

        if("templeteCategorys".equals(request.getParameter("condition"))) {
            modelAndView.addObject("condition4", "1");
        }

        modelAndView.addObject("aiProcessing", request.getParameter("aiProcessing"));
        modelAndView.addObject("aiSort", request.getParameter("aiSort"));
        modelAndView.addObject("openForm", request.getParameter("openForm"));
        modelAndView.addObject("dataType", request.getParameter("dataType"));
        return modelAndView;
    }

    public ModelAndView colTansfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView();
        Map<String, String> params = new HashMap();
        String affairId = request.getParameter("affairId");
        params.put("affairId", affairId);
        params.put("transferMemberId", request.getParameter("transferMemberId"));
        boolean isLock = false;

        try {
            isLock = this.colLockManager.canGetLock(Long.valueOf(affairId));
            String message;
            if(!isLock) {
                LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作finishWorkItem,affairId" + affairId);
                message = null;
                return null;
            }

            message = this.colManager.transColTransfer(params);
            modelAndView.addObject("message", message);
        } finally {
            if(isLock) {
                this.colLockManager.unlock(Long.valueOf(affairId));
            }

        }

        return null;
    }

    public ModelAndView tabOffice(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/tabOffice");
        Locale locale = AppContext.getLocale();
        String localeStr = "zh-cn";
        if(locale.equals(Locale.ENGLISH)) {
            localeStr = "en";
        } else if(locale.equals(Locale.TRADITIONAL_CHINESE)) {
            localeStr = "zh-tw";
        }

        modelAndView.addObject("localeStr", localeStr);
        return modelAndView;
    }

    private Map<String, List<String>> getCommentLog(String processId) throws BusinessException {
        List<Integer> actionList = new ArrayList();
        actionList.add(Integer.valueOf(ProcessLogAction.insertPeople.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.colAssign.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.deletePeople.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.inform.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.processColl.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.addAttachment.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.deleteAttachment.getKey()));
        actionList.add(Integer.valueOf(ProcessLogAction.updateAttachmentOnline.getKey()));
        Map<String, List<String>> logDescStrMap = new HashMap();
        if(Strings.isBlank(processId)) {
            return logDescStrMap;
        } else {
            List<ProcessLog> processLogs = this.processLogManager.getLogsByProcessIdAndActionId(Long.valueOf(processId), actionList);
            Map<Long, List<ProcessLog>> processLogMap = new HashMap();

            Iterator var6;
            ProcessLog log;
            List<ProcessLog> logs;
            for(var6 = processLogs.iterator(); var6.hasNext();) {
                log = (ProcessLog)var6.next();
                logs = (List)processLogMap.get(log.getCommentId());
                if(null != logs) {
                    ((List)logs).add(log);
                } else {
                    logs = new ArrayList();
                    ((List)logs).add(log);
                    processLogMap.put(log.getCommentId(), logs);
                }
            }

            ArrayList logDescs;
            Long commentId;
            for(var6 = processLogMap.keySet().iterator(); var6.hasNext(); logDescStrMap.put(String.valueOf(commentId), logDescs)) {
                commentId = (Long)var6.next();
                List<ProcessLog> logs2 = (List)processLogMap.get(commentId);
                Boolean addAttachment = Boolean.valueOf(false);
                Boolean deleteAttachment = Boolean.valueOf(false);
                Boolean updateAttachment = Boolean.valueOf(false);
                logDescs = new ArrayList();
                Map<Integer, String> logDescMap = new HashMap();
                Iterator var14 = logs2.iterator();

                String logString;
                while(var14.hasNext()) {
                     log = (ProcessLog)var14.next();
                    if(actionList.contains(log.getActionId())) {
                        if(Integer.valueOf(ProcessLogAction.addAttachment.getKey()).equals(log.getActionId())) {
                            if(Strings.isNotBlank(log.getParam0()) && !addAttachment.booleanValue()) {
                                addAttachment = Boolean.valueOf(true);
                            }
                        } else if(Integer.valueOf(ProcessLogAction.deleteAttachment.getKey()).equals(log.getActionId())) {
                            if(Strings.isNotBlank(log.getParam0()) && !deleteAttachment.booleanValue()) {
                                deleteAttachment = Boolean.valueOf(true);
                            }
                        } else if(Integer.valueOf(ProcessLogAction.updateAttachmentOnline.getKey()).equals(log.getActionId())) {
                            if(Strings.isNotBlank(log.getParam0()) && !updateAttachment.booleanValue()) {
                                updateAttachment = Boolean.valueOf(true);
                            }
                        } else {
                            logString = (String)logDescMap.get(log.getActionId());
                            if(logString != null) {
                                StringBuilder desc = new StringBuilder(logString);
                                desc.append(",").append(log.getParam0());
                                logString = desc.toString();
                            } else {
                                logString = log.getActionUserDesc();
                            }

                            logDescMap.put(log.getActionId(), logString);
                        }
                    }
                }

                var14 = actionList.iterator();

                while(var14.hasNext()) {
                    Integer action = (Integer)var14.next();
                    logString = (String)logDescMap.get(action);
                    if(null != logString) {
                        logDescs.add(logString);
                    }
                }

                List<String> attachmentOperation = new ArrayList();
                if(addAttachment.booleanValue()) {
                    attachmentOperation.add(ResourceUtil.getString("processLog.action.user.attchement.add"));
                }

                if(deleteAttachment.booleanValue()) {
                    attachmentOperation.add(ResourceUtil.getString("processLog.action.user.attchement.delete"));
                }

                if(updateAttachment.booleanValue()) {
                    attachmentOperation.add(ResourceUtil.getString("processLog.action.user.attchement.update"));
                }

                if(attachmentOperation.size() != 0) {
                    logDescs.add(ResourceUtil.getString("processLog.action.user.0", Strings.join(attachmentOperation, ",")));
                }
            }

            return logDescStrMap;
        }
    }

    public ModelAndView showNodeMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView mav = new ModelAndView("apps/collaboration/showNodeMembers");
        String nodeId = request.getParameter("nodeId");
        String summaryId = request.getParameter("summaryId");
        List<CtpAffair> affairs = this.affairManager.getAffairsByObjectIdAndNodeId(Long.valueOf(summaryId), Long.valueOf(nodeId));
        List<Object[]> node2Affairs = new ArrayList();
        if(Strings.isNotEmpty(affairs)) {
            Iterator it = affairs.iterator();

            CtpAffair a;
            while(it.hasNext()) {
                a = (CtpAffair)it.next();
                if(!this.affairManager.isAffairValid(a, Boolean.valueOf(true))) {
                    it.remove();
                }
            }

            it = affairs.iterator();

            label32:
            while(true) {
                do {
                    do {
                        if(!it.hasNext()) {
                            break label32;
                        }

                        a = (CtpAffair)it.next();
                    } while(a.getActivityId() == null);
                } while(a.getState().intValue() != StateEnum.col_done.getKey() && a.getState().intValue() != StateEnum.col_pending.getKey());

                Object[] o = new Object[]{a.getMemberId(), Functions.showMemberName(a.getMemberId()), a.getState(), a.getSubState(), a.getBackFromId()};
                node2Affairs.add(o);
            }
        }

        mav.addObject("commentPushMessageToMembersList", JSONUtil.toJSONString(node2Affairs));
        mav.addObject("readSwitch", this.systemConfig.get("read_state_enable"));
        return mav;
    }

    public ModelAndView cashTransData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String cashId = String.valueOf(UUIDLong.longUUID());
        Map<String, String> paramMap = new HashMap();
        Enumeration names = request.getParameterNames();

        while(names.hasMoreElements()) {
            String name = (String)names.nextElement();
            paramMap.put(name, request.getParameter(name));
        }

        V3xShareMap.put(cashId, paramMap);
        response.getWriter().write(cashId);
        return null;
    }

    public ModelAndView collaborationSet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/collaborationSet");
        String anyReply = this.systemConfig.get("anyReply_enable");
        if(Strings.isBlank(anyReply)) {
            anyReply = "disable";
        }

        modelAndView.addObject("anyReply", anyReply);
        return modelAndView;
    }

    public ModelAndView updateCollaborationSwitch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map para = ParamUtil.getJsonDomain("submitform");
        String anyReply = (String)para.get("anyReply");
        this.systemConfig.update("anyReply_enable", anyReply);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + ResourceUtil.getString("coll.switch.lable.setSuccess") + "')");
        out.println("</script>");
        out.flush();
        return null;
    }

    private boolean showTraceWorkflows(String subState, CtpAffair affair) throws BusinessException {
        if(!Strings.isEmpty(subState) && affair != null) {
            int intSubState = Integer.parseInt(subState);
            if(SubStateEnum.col_waitSend_stepBack.key() == intSubState || SubStateEnum.col_waitSend_cancel.key() == intSubState || SubStateEnum.col_pending_specialBackToSenderCancel.key() == intSubState) {
                List<WorkflowTracePO> traceWorkflows = this.traceWorkflowManager.getShowDataByParams(affair.getObjectId(), affair.getActivityId(), affair.getMemberId());
                if(Strings.isNotEmpty(traceWorkflows)) {
                    return true;
                }
            }

            return false;
        } else {
            return false;
        }
    }
}
