////
//// Source code recreated from a .class file by IntelliJ IDEA
//// (powered by Fernflower decompiler)
////
//
//package com.seeyon.apps.collaboration.controller;
//
//import com.alibaba.fastjson.JSON;
//import com.seeyon.apps.collaboration.api.CollaborationApi;
//import com.seeyon.apps.collaboration.api.NewCollDataHandler;
//import com.seeyon.apps.collaboration.bo.ColInfo;
//import com.seeyon.apps.collaboration.constants.ColConstant.SendType;
//import com.seeyon.apps.collaboration.enums.ColOpenFrom;
//import com.seeyon.apps.collaboration.enums.ColQueryCondition;
//import com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState;
//import com.seeyon.apps.collaboration.manager.ColLockManager;
//import com.seeyon.apps.collaboration.manager.ColManager;
//import com.seeyon.apps.collaboration.manager.NewCollDataHelper;
//import com.seeyon.apps.collaboration.po.ColSummary;
//import com.seeyon.apps.collaboration.po.WorkflowTracePO;
//import com.seeyon.apps.collaboration.trace.enums.WorkflowTraceEnums.workflowTrackType;
//import com.seeyon.apps.collaboration.trace.manager.TraceWorkflowManager;
//import com.seeyon.apps.collaboration.util.ColUtil;
//import com.seeyon.apps.collaboration.vo.AttachmentVO;
//import com.seeyon.apps.collaboration.vo.ColSummaryVO;
//import com.seeyon.apps.collaboration.vo.DumpDataVO;
//import com.seeyon.apps.collaboration.vo.NewCollTranVO;
//import com.seeyon.apps.collaboration.vo.NodePolicyVO;
//import com.seeyon.apps.doc.api.DocApi;
//import com.seeyon.apps.doc.constants.DocConstants.PigeonholeType;
//import com.seeyon.apps.edoc.api.EdocApi;
//import com.seeyon.apps.taskmanage.util.MenuPurviewUtil;
//import com.seeyon.ctp.common.AppContext;
//import com.seeyon.ctp.common.ModuleType;
//import com.seeyon.ctp.common.SystemEnvironment;
//import com.seeyon.ctp.common.authenticate.domain.User;
//import com.seeyon.ctp.common.config.SystemConfig;
//import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
//import com.seeyon.ctp.common.constants.SystemProperties;
//import com.seeyon.ctp.common.content.ContentConfig;
//import com.seeyon.ctp.common.content.ContentUtil;
//import com.seeyon.ctp.common.content.ContentViewRet;
//import com.seeyon.ctp.common.content.affair.AffairManager;
//import com.seeyon.ctp.common.content.affair.AffairUtil;
//import com.seeyon.ctp.common.content.affair.constants.StateEnum;
//import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
//import com.seeyon.ctp.common.content.comment.Comment;
//import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
//import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
//import com.seeyon.ctp.common.content.mainbody.MainbodyType;
//import com.seeyon.ctp.common.controller.BaseController;
//import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
//import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
//import com.seeyon.ctp.common.customize.manager.CustomizeManager;
//import com.seeyon.ctp.common.excel.DataRecord;
//import com.seeyon.ctp.common.excel.DataRow;
//import com.seeyon.ctp.common.excel.FileToExcelManager;
//import com.seeyon.ctp.common.exceptions.BusinessException;
//import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
//import com.seeyon.ctp.common.filemanager.manager.FileManager;
//import com.seeyon.ctp.common.i18n.ResourceUtil;
//import com.seeyon.ctp.common.log.CtpLogFactory;
//import com.seeyon.ctp.common.permission.manager.PermissionManager;
//import com.seeyon.ctp.common.permission.vo.PermissionVO;
//import com.seeyon.ctp.common.po.affair.CtpAffair;
//import com.seeyon.ctp.common.po.content.CtpContentAll;
//import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
//import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
//import com.seeyon.ctp.common.po.filemanager.Attachment;
//import com.seeyon.ctp.common.po.filemanager.V3XFile;
//import com.seeyon.ctp.common.po.processlog.ProcessLog;
//import com.seeyon.ctp.common.po.template.CtpTemplate;
//import com.seeyon.ctp.common.processlog.ProcessLogAction;
//import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
//import com.seeyon.ctp.common.shareMap.V3xShareMap;
//import com.seeyon.ctp.common.taglibs.functions.Functions;
//import com.seeyon.ctp.common.template.enums.TemplateEnum.Type;
//import com.seeyon.ctp.common.template.manager.TemplateManager;
//import com.seeyon.ctp.common.template.util.TemplateUtil;
//import com.seeyon.ctp.common.track.manager.CtpTrackMemberManager;
//import com.seeyon.ctp.common.track.po.CtpTrackMember;
//import com.seeyon.ctp.form.service.FormManager;
//import com.seeyon.ctp.organization.bo.V3xOrgAccount;
//import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
//import com.seeyon.ctp.organization.bo.V3xOrgMember;
//import com.seeyon.ctp.organization.manager.OrgIndexManager;
//import com.seeyon.ctp.organization.manager.OrgManager;
//import com.seeyon.ctp.organization.webmodel.WebEntity4QuickIndex;
//import com.seeyon.ctp.util.Datetimes;
//import com.seeyon.ctp.util.FlipInfo;
//import com.seeyon.ctp.util.ParamUtil;
//import com.seeyon.ctp.util.ReqUtil;
//import com.seeyon.ctp.util.StringUtil;
//import com.seeyon.ctp.util.Strings;
//import com.seeyon.ctp.util.UUIDLong;
//import com.seeyon.ctp.util.XMLCoder;
//import com.seeyon.ctp.util.json.JSONUtil;
//import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
//import com.seeyon.v3x.common.security.AccessControlBean;
//import com.seeyon.v3x.common.security.SecurityCheck;
//import com.seeyon.v3x.peoplerelate.manager.PeopleRelateManager;
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.net.URLDecoder;
//import java.net.URLEncoder;
//import java.sql.Timestamp;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.Enumeration;
//import java.util.HashMap;
//import java.util.Iterator;
//import java.util.List;
//import java.util.Locale;
//import java.util.Map;
//import java.util.Map.Entry;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import net.joinwork.bpm.definition.BPMProcess;
//import org.apache.commons.lang.StringEscapeUtils;
//import org.apache.commons.lang.math.NumberUtils;
//import org.apache.commons.logging.Log;
//import org.springframework.web.servlet.ModelAndView;
//import www.seeyon.com.utils.UUIDUtil;
//
//public class CollaborationController extends BaseController {
//    private static final Log LOG = CtpLogFactory.getLog(CollaborationController.class);
//    private ColManager colManager;
//    private AffairManager affairManger;
//    private WorkflowApiManager wapi;
//    private CustomizeManager customizeManager;
//    private TemplateManager templateManager;
//    private OrgManager orgManager;
//    private AttachmentManager attachmentManager;
//    private FileToExcelManager fileToExcelManager;
//    private FileManager fileManager;
//    private EdocApi edocApi;
//    private EnumManager enumManagerNew;
//    private MainbodyManager ctpMainbodyManager;
//    private CollaborationApi collaborationApi;
//    private ColLockManager colLockManager;
//    private PermissionManager permissionManager;
//    private OrgIndexManager orgIndexManager;
//    private PeopleRelateManager peopleRelateManager;
//    private ProcessLogManager processLogManager;
//    private FormManager formManager;
//    private SystemConfig systemConfig;
//    private TraceWorkflowManager traceWorkflowManager;
//    private DocApi docApi;
//    private CtpTrackMemberManager trackManager;
//    private AffairManager affairManager;
//
//    public CollaborationController() {
//    }
//
//    public DocApi getDocApi() {
//        return this.docApi;
//    }
//
//    public void setDocApi(DocApi docApi) {
//        this.docApi = docApi;
//    }
//
//    public void setSystemConfig(SystemConfig systemConfig) {
//        this.systemConfig = systemConfig;
//    }
//
//    public FormManager getFormManager() {
//        return this.formManager;
//    }
//
//    public void setFormManager(FormManager formManager) {
//        this.formManager = formManager;
//    }
//
//    public OrgIndexManager getOrgIndexManager() {
//        return this.orgIndexManager;
//    }
//
//    public void setOrgIndexManager(OrgIndexManager orgIndexManager) {
//        this.orgIndexManager = orgIndexManager;
//    }
//
//    public PeopleRelateManager getPeopleRelateManager() {
//        return this.peopleRelateManager;
//    }
//
//    public void setPeopleRelateManager(PeopleRelateManager peopleRelateManager) {
//        this.peopleRelateManager = peopleRelateManager;
//    }
//
//    public void setPermissionManager(PermissionManager permissionManager) {
//        this.permissionManager = permissionManager;
//    }
//
//    public ColLockManager getColLockManager() {
//        return this.colLockManager;
//    }
//
//    public void setColLockManager(ColLockManager colLockManager) {
//        this.colLockManager = colLockManager;
//    }
//
//    public ColManager getColManager() {
//        return this.colManager;
//    }
//
//    public CollaborationApi getCollaborationApi() {
//        return this.collaborationApi;
//    }
//
//    public void setCollaborationApi(CollaborationApi collaborationApi) {
//        this.collaborationApi = collaborationApi;
//    }
//
//    public void setEnumManagerNew(EnumManager enumManager) {
//        this.enumManagerNew = enumManager;
//    }
//
//    public AffairManager getAffairManger() {
//        return this.affairManger;
//    }
//
//    public void setAffairManger(AffairManager affairManger) {
//        this.affairManger = affairManger;
//    }
//
//    public EdocApi getEdocApi() {
//        return this.edocApi;
//    }
//
//    public void setEdocApi(EdocApi edocApi) {
//        this.edocApi = edocApi;
//    }
//
//    public FileManager getFileManager() {
//        return this.fileManager;
//    }
//
//    public void setFileManager(FileManager fileManager) {
//        this.fileManager = fileManager;
//    }
//
//    public void setProcessLogManager(ProcessLogManager processLogManager) {
//        this.processLogManager = processLogManager;
//    }
//
//    public TraceWorkflowManager getTraceWorkflowManager() {
//        return this.traceWorkflowManager;
//    }
//
//    public void setTraceWorkflowManager(TraceWorkflowManager traceWorkflowManager) {
//        this.traceWorkflowManager = traceWorkflowManager;
//    }
//
//    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
//        this.fileToExcelManager = fileToExcelManager;
//    }
//
//    public AttachmentManager getAttachmentManager() {
//        return this.attachmentManager;
//    }
//
//    public void setAttachmentManager(AttachmentManager attachmentManager) {
//        this.attachmentManager = attachmentManager;
//    }
//
//    public OrgManager getOrgManager() {
//        return this.orgManager;
//    }
//
//    public void setOrgManager(OrgManager orgManager) {
//        this.orgManager = orgManager;
//    }
//
//    public TemplateManager getTemplateManager() {
//        return this.templateManager;
//    }
//
//    public void setTemplateManager(TemplateManager templateManager) {
//        this.templateManager = templateManager;
//    }
//
//    public CustomizeManager getCustomizeManager() {
//        return this.customizeManager;
//    }
//
//    public void setCustomizeManager(CustomizeManager customizeManager) {
//        this.customizeManager = customizeManager;
//    }
//
//    public void setColManager(ColManager colManager) {
//        this.colManager = colManager;
//    }
//
//    public AffairManager getAffairManager() {
//        return this.affairManager;
//    }
//
//    public void setAffairManager(AffairManager affairManager) {
//        this.affairManager = affairManager;
//    }
//
//    public CtpTrackMemberManager getTrackManager() {
//        return this.trackManager;
//    }
//
//    public void setTrackManager(CtpTrackMemberManager trackManager) {
//        this.trackManager = trackManager;
//    }
//
//    public ModelAndView newColl(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/newCollaboration");
//        User user = AppContext.getCurrentUser();
//        NewCollTranVO vobj = new NewCollTranVO();
//        vobj.setCreateDate(new Date());
//        String from = request.getParameter("from");
//        String summaryId = request.getParameter("summaryId");
//        String templateId = request.getParameter("templateId");
//        String projectID = request.getParameter("projectId");
//        boolean relateProjectFlag = Strings.isNotBlank(projectID);
//        String affairId = request.getParameter("affairId");
//        ColSummary summary = null;
//        boolean canEditColPigeonhole = true;
//        CtpTemplate template = null;
//        vobj.setFrom(from);
//        vobj.setSummaryId(Strings.isBlank(summaryId) ? String.valueOf(UUIDUtil.getUUIDLong()) : summaryId);
//        vobj.setTempleteId(templateId);
//        vobj.setProjectId(Strings.isNotBlank(projectID) ? Long.parseLong(projectID) : null);
//        vobj.setAffairId(affairId);
//        vobj.setUser(user);
//        vobj.setCanDeleteOriginalAtts(true);
//        vobj.setCloneOriginalAtts(false);
//        vobj.setArchiveName("");
//        vobj.setNewBusiness("1");
//        boolean showTraceWorkflows = false;
//        String branch = "";
//        ColSummary colSummary;
//        Long projectId;
//        String trackValue;
//        boolean isSpecialSteped;
//        if (Strings.isNotBlank(templateId)) {
//            branch = "template";
//            vobj.setSummaryId(String.valueOf(UUIDUtil.getUUIDLong()));
//
//            try {
//                template = this.templateManager.getCtpTemplate(Long.valueOf(templateId));
//                isSpecialSteped = this.templateManager.isTemplateEnabled(template, user.getId());
//                if (!user.hasResourceCode("F01_newColl") && isSpecialSteped && null != template && !TemplateUtil.isSystemTemplate(template)) {
//                    isSpecialSteped = false;
//                }
//
//                if (!isSpecialSteped) {
//                    if ("templateNewColl".equals(from)) {
//                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
//                    } else {
//                        PrintWriter out = response.getWriter();
//                        out.println("<script>");
//                        out.println("alert('模板已经被删除，或者您已经没有该模板的使用权限');");
//                        out.print("parent.window.close();");
//                        out.println("</script>");
//                        out.flush();
//                    }
//
//                    return null;
//                }
//
//                vobj.setTemplate(template);
//                vobj = this.colManager.transferTemplate(vobj);
//                template = vobj.getTemplate();
//                modelAndView.addObject("zwContentType", template.getBodyType());
//                AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, vobj.getSummaryId(), user.getId());
//            } catch (Throwable var33) {
//                LOG.info("", var33);
//                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
//                return null;
//            }
//
//            canEditColPigeonhole = vobj.isCanEditColPigeonhole();
//        } else {
//            Long referenceId;
//            if ("resend".equals(from)) {
//                branch = "resend";
//                vobj = this.colManager.transResend(vobj);
//                vobj.setSummaryId(String.valueOf(UUIDLong.longUUID()));
//                modelAndView.addObject("parentSummaryId", vobj.getSummary().getId());
//                referenceId = vobj.getSummary().getId();
//                colSummary = this.colManager.getSummaryById(referenceId);
//                vobj.getSummary().setId(Long.valueOf(vobj.getSummaryId()));
//                projectId = colSummary.getTempleteId();
//                CtpTemplate ctpTemplate = null;
//                if (projectId != null) {
//                    ctpTemplate = this.templateManager.getCtpTemplate(projectId);
//                    if (ctpTemplate != null) {
//                        ColSummary tSummary = (ColSummary)XMLCoder.decoder(ctpTemplate.getSummary());
//                        vobj.setTempleteHasDeadline(tSummary.getDeadline() != null && tSummary.getDeadline() != 0L);
//                        vobj.setTempleteHasRemind(tSummary.getAdvanceRemind() != null && tSummary.getAdvanceRemind() != 0L && tSummary.getAdvanceRemind() != -1L);
//                        vobj.setCanEditColPigeonhole(tSummary.getArchiveId() != null);
//                        vobj.setParentWrokFlowTemplete(this.colManager.isParentWrokFlowTemplete(ctpTemplate.getFormParentid()));
//                        vobj.setParentTextTemplete(this.colManager.isParentTextTemplete(ctpTemplate.getFormParentid()));
//                        vobj.setParentColTemplete(this.colManager.isParentColTemplete(ctpTemplate.getFormParentid()));
//                        vobj.setFromSystemTemplete(ctpTemplate.isSystem());
//                        trackValue = "0";
//                        if (template != null && null != template.getScanCodeInput() && template.getScanCodeInput()) {
//                            trackValue = "1";
//                        }
//
//                        if (tSummary.getAttachmentArchiveId() != null && AppContext.hasPlugin("doc")) {
//                            boolean docResourceExist = this.docApi.isDocResourceExisted(tSummary.getAttachmentArchiveId());
//                            if (docResourceExist) {
//                                vobj.setAttachmentArchiveId(tSummary.getAttachmentArchiveId());
//                                if (null != vobj.getSummary()) {
//                                    vobj.getSummary().setCanArchive(true);
//                                }
//                            }
//                        }
//
//                        modelAndView.addObject("scanCodeInput", trackValue);
//                    }
//                }
//
//                this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
//                modelAndView.addObject("isResend", "1");
//            } else {
//                String formTitleText;
//                if (vobj.getSummaryId() != null && "waitSend".equals(from)) {
//                    branch = "waitSend";
//                    vobj.setNewBusiness("0");
//                    if (Strings.isNotBlank(affairId)) {
//                        CtpAffair valAffair = this.affairManager.get(Long.valueOf(affairId));
//                        if (null != valAffair && !valAffair.getMemberId().equals(user.getId())) {
//                            this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("您无权查看该主题!"));
//                            return null;
//                        }
//                    }
//
//                    String stiitle;
//                    try {
//                        vobj = this.colManager.transComeFromWaitSend(vobj);
//                        formTitleText = ReqUtil.getString(request, "subState", "");
//                        stiitle = ReqUtil.getString(request, "oldSubState", "");
//                        if (Strings.isNotBlank(stiitle) && stiitle != "1") {
//                            formTitleText = stiitle;
//                        }
//
//                        CtpAffair vaffair = vobj.getAffair();
//                        if (Strings.isBlank(formTitleText)) {
//                            formTitleText = null != vaffair ? String.valueOf(vaffair.getSubState()) : "1";
//                        }
//
//                        modelAndView.addObject("subState", formTitleText);
//                        showTraceWorkflows = this.showTraceWorkflows(formTitleText, vaffair);
//                        template = vobj.getTemplate();
//                        this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
//                    } catch (Exception var32) {
//                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
//                        return null;
//                    }
//
//                    canEditColPigeonhole = vobj.isCanEditColPigeonhole();
//                    modelAndView.addObject("alertSuperviseSet", true);
//                    formTitleText = request.getParameter("formTitleText");
//                    if (Strings.isNotBlank(formTitleText)) {
//                        stiitle = URLDecoder.decode(formTitleText, "UTF-8");
//                        modelAndView.addObject("_formTitleText", stiitle);
//                        vobj.setCollSubject(stiitle);
//                        if (null != vobj.getSummary()) {
//                            vobj.getSummary().setSubject(stiitle);
//                        }
//                    }
//
//                    if ("bizconfig".equals(request.getParameter("reqFrom"))) {
//                        vobj.setFrom("bizconfig");
//                    }
//
//                    vobj.setAttachmentArchiveId(vobj.getSummary().getAttachmentArchiveId());
//                } else if ("relatePeople".equals(from)) {
//                    branch = "relatePeople";
//                    vobj.setNewBusiness("1");
//                    formTitleText = request.getParameter("memberId");
//                    this.setWorkFlowMember(formTitleText, user, modelAndView);
//                } else if ("a8genius".equals(from)) {
//                    branch = "a8genius";
//                    referenceId = UUIDLong.longUUID();
//                    String[] attachids = request.getParameterValues("attachid");
//                    if (attachids != null && attachids.length > 0) {
//                        Long[] attId = new Long[attachids.length];
//
//                        for(int count = 0; count < attachids.length; ++count) {
//                            attId[count] = Long.valueOf(attachids[count]);
//                        }
//
//                        if (attId.length > 0) {
//                            this.attachmentManager.create(attId, ApplicationCategoryEnum.collaboration, referenceId, referenceId);
//                            String attListJSON = this.attachmentManager.getAttListJSON(referenceId);
//                            vobj.setAttListJSON(attListJSON);
//                        }
//                    }
//
//                    modelAndView.addObject("source", request.getParameter("source"));
//                    modelAndView.addObject("from", from);
//                    modelAndView.addObject("referenceId", referenceId);
//                }
//            }
//        }
//
//        modelAndView.addObject("showTraceWorkflows", showTraceWorkflows);
//        if (vobj.getSummary() == null) {
//            summary = new ColSummary();
//            vobj.setSummary(summary);
//            summary.setCanForward(true);
//            summary.setCanArchive(true);
//            summary.setCanDueReminder(true);
//            summary.setCanEditAttachment(true);
//            summary.setCanModify(true);
//            summary.setCanTrack(true);
//            summary.setCanEdit(true);
//            summary.setAdvanceRemind(-1L);
//        }
//
//        this.initNewCollTranVO(vobj, summary, modelAndView, user, request);
//        isSpecialSteped = vobj.getAffair() != null && vobj.getAffair().getSubState() == SubStateEnum.col_pending_specialBacked.key();
//
//        BPMProcess process = null;
//        if (template != null && template.getWorkflowId() != null && !isSpecialSteped && !"resend".equals(from)) {
//            process = this.wapi.getTemplateProcess(template.getWorkflowId());
//        } else {
//            process = this.wapi.getBPMProcessForM1(vobj.getSummary().getProcessId());
//        }
//
//        if (vobj.isParentColTemplete() && null != vobj.getTemplate() && null != vobj.getTemplate().getProjectId()) {
//            modelAndView.addObject("disabledProjectId", "1");
//        }
//
//        if (!relateProjectFlag) {
//            projectId = vobj.getSummary().getProjectId();
//            vobj.setProjectId(projectId);
//        }
//
//        ContentConfig config = ContentConfig.getConfig(ModuleType.collaboration);
//        modelAndView.addObject("contentCfg", config);
//        ContentViewRet context;
//        if (summaryId == null && Strings.isBlank(templateId) || Strings.isNotBlank(templateId) && Type.workflow.name().equals(template.getType())) {
//            context = this.setWorkflowParam((Long)null, ModuleType.collaboration);
//        } else {
//            Long originalContentId = null;
//            trackValue = null;
//            if (summaryId != null) {
//                originalContentId = Long.parseLong(summaryId);
//            } else if (Strings.isNotBlank(templateId)) {
//                originalContentId = Long.valueOf(templateId);
//            }
//
//            if (template != null && MainbodyType.FORM.getKey() == Integer.parseInt(template.getBodyType())) {
//                trackValue = this.wapi.getNodeFormViewAndOperationName(process, (String)null);
//            }
//
//            ColSummary fromToSummary = vobj.getSummary();
//            int viewState = 1;
//            if (fromToSummary.getParentformSummaryid() != null && !fromToSummary.getCanEdit()) {
//                ColSummary parentSummary = this.colManager.getSummaryById(fromToSummary.getParentformSummaryid());
//                if (parentSummary != null && String.valueOf(MainbodyType.FORM.getKey()).equals(parentSummary.getBodyType())) {
//                    viewState = 2;
//                }
//            }
//
//            modelAndView.addObject("contentViewState", Integer.valueOf(viewState));
//            modelAndView.addObject("uuidlong", UUIDLong.longUUID());
//            modelAndView.addObject("zwModuleId", originalContentId);
//            trackValue = trackValue == null ? null : trackValue.replaceAll("[|]", "_");
//            modelAndView.addObject("zwRightId", trackValue);
//            modelAndView.addObject("_formOperationId", trackValue != null && trackValue.split("[.]").length == 2 ? trackValue.split("[.]")[1] : "");
//            modelAndView.addObject("zwIsnew", "false");
//            modelAndView.addObject("zwViewState", Integer.valueOf(viewState));
//            context = this.setWorkflowParam(originalContentId, ModuleType.collaboration);
//            context.setCanReply(false);
//            if ("waitSend".equals(branch) || "resend".equals(branch)) {
//                ContentUtil.commentView(request, config, ModuleType.collaboration, originalContentId, (Long)null);
//            }
//        }
//
//        if (context != null) {
//            EnumManager em = (EnumManager)AppContext.getBean("enumManagerNew");
//            Map<String, CtpEnumBean> ems = em.getEnumsMap(ApplicationCategoryEnum.collaboration);
//            CtpEnumBean nodePermissionPolicy = (CtpEnumBean)ems.get(EnumNameEnum.col_flow_perm_policy.name());
//            String xml = "";
//            CtpTemplate t = vobj.getTemplate();
//            context.setWfProcessId(vobj.getSummary().getProcessId());
//            context.setWfCaseId(vobj.getCaseId() == null ? -1L : vobj.getCaseId());
//            String processId = vobj.getSummary().getProcessId();
//            if (t != null && t.getWorkflowId() != null) {
//                if (!isSpecialSteped && !"resend".equals(from)) {
//                    if (TemplateUtil.isSystemTemplate(vobj.getTemplate())) {
//                        context.setProcessTemplateId(String.valueOf(vobj.getTemplate().getWorkflowId()));
//                        context.setWfProcessId("");
//                    } else {
//                        modelAndView.addObject("ordinalTemplateIsSys", "no");
//                        xml = this.wapi.selectWrokFlowTemplateXml(t.getWorkflowId().toString());
//                    }
//                } else if ("resend".equals(from)) {
//                    xml = this.wapi.selectWrokFlowXml(processId);
//                    context.setWfProcessId("");
//                }
//            } else {
//                if (!isSpecialSteped) {
//                    xml = this.wapi.selectWrokFlowXml(processId);
//                }
//
//                if ("resend".equals(from)) {
//                    context.setWfProcessId("");
//                }
//            }
//
//            String[] workflowNodesInfo = this.wapi.getWorkflowInfos(process, ModuleType.collaboration.name(), nodePermissionPolicy);
//            context.setWorkflowNodesInfo(workflowNodesInfo[0]);
//            modelAndView.addObject("DR", workflowNodesInfo[1]);
//            vobj.setWfXMLInfo(Strings.escapeJavascript(xml));
//            modelAndView.addObject("contentContext", context);
//        }
//
//        if (null != vobj.getTemplate() && !Type.text.name().equals(vobj.getTemplate().getType())) {
//            modelAndView.addObject("onlyViewWF", true);
//        }
//
//        modelAndView.addObject("postName", Functions.showOrgPostName(user.getPostId()));
//        V3xOrgDepartment department = Functions.getDepartment(user.getDepartmentId());
//        if (department != null) {
//            modelAndView.addObject("departName", Functions.getDepartment(user.getDepartmentId()).getName());
//        }
//
//        modelAndView.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
//        AppContext.putRequestContext("moduleId", vobj.getSummaryId());
//        AppContext.putRequestContext("canDeleteISigntureHtml", true);
//        if (vobj.getSummary().getDeadlineDatetime() != null) {
//            vobj.setDeadLineDateTimeHidden(Datetimes.formatDatetimeWithoutSecond(vobj.getSummary().getDeadlineDatetime()));
//        }
//
//        LOG.info("vobj.processId=" + vobj.getProcessId());
//        modelAndView.addObject("vobj", vobj);
//        trackValue = this.customizeManager.getCustomizeValue(user.getId(), "track_send");
//        if (Strings.isBlank(trackValue)) {
//            modelAndView.addObject("customSetTrack", "true");
//        } else {
//            modelAndView.addObject("customSetTrack", trackValue);
//        }
//
//        String officeOcxUploadMaxSize = SystemProperties.getInstance().getProperty("officeFile.maxSize");
//        modelAndView.addObject("officeOcxUploadMaxSize", Strings.isBlank(officeOcxUploadMaxSize) ? "8192" : officeOcxUploadMaxSize);
//        modelAndView.addObject("canEditColPigeonhole", canEditColPigeonhole);
//        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(user.getLoginAccount());
//        modelAndView.addObject("newColNodePolicy", Strings.escapeJson(JSONUtil.toJSONString(newColNodePolicy)));
//        modelAndView.addObject("newColNodePolicyVO", newColNodePolicy);
//        String recentPeoplesStr = this.orgIndexManager.getRecentDataStr(user.getId(), (String)null);
//        List<WebEntity4QuickIndex> list = (List)JSONUtil.parseJSONString(recentPeoplesStr, List.class);
//        modelAndView.addObject("recentPeoples", list);
//        modelAndView.addObject("recentPeoplesLength", list.size());
//        PermissionVO permission = this.permissionManager.getDefaultPermissionByConfigCategory(EnumNameEnum.col_flow_perm_policy.name(), user.getLoginAccount());
//        modelAndView.addObject("defaultNodeName", permission.getName());
//        modelAndView.addObject("defaultNodeLable", permission.getLabel());
//        Map<String, Object> jval = new HashMap();
//        jval.put("hasProjectPlugin", AppContext.hasPlugin("project"));
//        jval.put("hasDocPlugin", AppContext.hasPlugin("doc") && newColNodePolicy.isPigeonhole());
//        modelAndView.addObject("jval", Strings.escapeJson(JSONUtil.toJSONString(jval)));
//        List<CtpEnumItem> commonImportances = this.enumManagerNew.getEnumItems(EnumNameEnum.common_importance);
//        List<CtpEnumItem> collaborationDeadlines = this.enumManagerNew.getEnumItems(EnumNameEnum.collaboration_deadline);
//        List<CtpEnumItem> commonRemindTimes = this.enumManagerNew.getEnumItems(EnumNameEnum.common_remind_time);
//        modelAndView.addObject("comImportanceMetadata", commonImportances);
//        modelAndView.addObject("collaborationDeadlines", collaborationDeadlines);
//        modelAndView.addObject("commonRemindTimes", commonRemindTimes);
//        return modelAndView;
//    }
//
//    private void initNewCollTranVO(NewCollTranVO vobj, ColSummary summary, ModelAndView modelAndView, User user, HttpServletRequest request) throws BusinessException {
//        String cashId = request.getParameter("cashId");
//        Object object = V3xShareMap.get(cashId);
//        if (object != null) {
//            Map<String, String> map = (Map)object;
//            String subject = map.get("subject") == null ? "" : (String)map.get("subject");
//            String manual = map.get("manual") == null ? "" : (String)map.get("manual");
//            String handlerName = map.get("handlerName") == null ? "" : (String)map.get("handlerName");
//            String sourceId = map.get("sourceId") == null ? "" : (String)map.get("sourceId");
//            String extendInfo = map.get("ext") == null ? "" : (String)map.get("ext");
//            String bodyTypes = map.get("bodyType") == null ? "" : (String)map.get("bodyType");
//            String bodyContent = map.get("bodyContent") == null ? "" : (String)map.get("bodyContent");
//            String personId = map.get("personId") == null ? "" : (String)map.get("personId");
//            String from = map.get("from") == null ? "" : (String)map.get("from");
//            summary.setSubject(subject);
//            NewCollDataHandler handler = NewCollDataHelper.getHandler(handlerName);
//            Map<String, Object> params = null;
//            if (handler != null) {
//                params = handler.getParams(sourceId, extendInfo);
//            }
//
//            if ("true".equalsIgnoreCase(manual) && handler != null) {
//                if (Strings.isBlank(subject)) {
//                    summary.setSubject(handler.getSubject(params));
//                }
//
//                bodyTypes = String.valueOf(handler.getBodyType(params));
//                bodyContent = handler.getBodyContent(params);
//            }
//
//            int bodyType = MainbodyType.HTML.getKey();
//            if (Strings.isNotBlank(bodyTypes)) {
//                bodyType = Integer.parseInt(bodyTypes);
//            }
//
//            if (MainbodyType.HTML.getKey() != bodyType && MainbodyType.FORM.getKey() != bodyType) {
//                modelAndView.addObject("zwContentType", bodyType);
//                modelAndView.addObject("transOfficeId", bodyContent);
//            } else {
//                StringBuilder buf = new StringBuilder();
//                buf.append(bodyContent == null ? "" : Strings.toHTML(bodyContent.replace("\t", "").replace("\n", ""), false));
//                bodyContent = buf.toString();
//            }
//
//            summary.setBodyType(String.valueOf(bodyType));
//            modelAndView.addObject("contentTextData", bodyContent);
//            modelAndView.addObject("transtoColl", "true");
//            if (handler != null) {
//                List<Attachment> atts = handler.getAttachments(params);
//                vobj.setAtts(atts);
//                if (Strings.isNotEmpty(atts)) {
//                    String attListJSON = this.attachmentManager.getAttListJSON(atts);
//                    vobj.setAttListJSON(attListJSON);
//                }
//
//                vobj.setCloneOriginalAtts(true);
//            }
//
//            this.setWorkFlowMember(personId, user, modelAndView);
//            modelAndView.addObject("from", from);
//        }
//    }
//
//    private void setWorkFlowMember(String memberId, User user, ModelAndView modelAndView) throws BusinessException {
//        if (Strings.isNotBlank(memberId)) {
//            V3xOrgMember sender = this.orgManager.getMemberById(Long.valueOf(memberId));
//            V3xOrgAccount account = this.orgManager.getAccountById(sender.getOrgAccountId());
//            modelAndView.addObject("accountObj", account);
//            modelAndView.addObject("isSameAccount", String.valueOf(sender.getOrgAccountId().equals(user.getLoginAccount())));
//            modelAndView.addObject("peopeleCardInfo", sender);
//        }
//
//    }
//
//    private ContentViewRet setWorkflowParam(Long moduleId, ModuleType moduleType) {
//        ContentViewRet context = new ContentViewRet();
//        context.setModuleId(moduleId);
//        context.setModuleType(moduleType.getKey());
//        context.setCommentMaxPath("00");
//        return context;
//    }
//
//    private void getTrackInfo(ModelAndView modelAndView, NewCollTranVO vobj, String smmaryId) throws BusinessException {
//        CtpAffair affairSent = this.affairManager.getSenderAffair(Long.valueOf(smmaryId));
//        if ("waitSend".equals(vobj.getFrom()) && Strings.isNotBlank(vobj.getAffairId()) && !"null".equals(vobj.getAffairId())) {
//            affairSent = this.affairManager.get(Long.valueOf(vobj.getAffairId()));
//        }
//
//        if (affairSent != null) {
//            Integer trackType = affairSent.getTrack();
//            modelAndView.addObject("trackType", trackType);
//            List<CtpTrackMember> tList = this.trackManager.getTrackMembers(affairSent.getId());
//            StringBuilder trackNames = new StringBuilder();
//            StringBuilder trackIds = new StringBuilder();
//            if (tList.size() > 0) {
//                Iterator var9 = tList.iterator();
//
//                while(var9.hasNext()) {
//                    CtpTrackMember ctpT = (CtpTrackMember)var9.next();
//                    trackNames.append("Member|").append(ctpT.getTrackMemberId()).append(",");
//                    trackIds.append(ctpT.getTrackMemberId() + ",");
//                }
//
//                if (trackNames.length() > 0) {
//                    vobj.setForGZShow(trackNames.substring(0, trackNames.length() - 1));
//                    modelAndView.addObject("forGZIds", trackIds.substring(0, trackIds.length() - 1));
//                }
//            }
//        }
//
//    }
//
//    public ModelAndView checkFile(HttpServletRequest request, HttpServletResponse response) throws IOException, BusinessException {
//        String userId = request.getParameter("userId");
//        String docId = request.getParameter("docId");
//        String isBorrow = request.getParameter("isBorrow");
//        String vForDocDownload = request.getParameter("v");
//        PrintWriter out = null;
//        if (!Strings.isBlank(userId) && userId.equals(String.valueOf(AppContext.currentUserId()))) {
//
//            String context = SystemEnvironment.getContextPath();
//            V3XFile vf = this.fileManager.getV3XFile(Long.valueOf(docId));
//            String result = "0#" + context + "/fileDownload.do?method=doDownload&viewMode=download&fileId=" + vf.getId() + "&filename=" + URLEncoder.encode(vf.getFilename(), "UTF-8") + "&createDate=" + Datetimes.formatDate(vf.getCreateDate()) + "&v=" + vForDocDownload;
//            out = response.getWriter();
//            out.print(result);
//            out.close();
//            return null;
//        } else {
//            out = response.getWriter();
//            out.print("1");
//            out.close();
//            return null;
//        }
//    }
//
//    private void newCollAlert(HttpServletResponse response, String msg) throws IOException {
//        PrintWriter out = response.getWriter();
//        out.println("<script>");
//        out.println("alert('" + msg + "');");
//        out.print("parent.window.history.back();");
//        out.println("</script>");
//        out.flush();
//    }
//
//    public void setWapi(WorkflowApiManager wapi) {
//        this.wapi = wapi;
//    }
//
//    public ModelAndView saveDraft(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
//        ColInfo info = new ColInfo();
//        User user = AppContext.getCurrentUser();
//        Map para = ParamUtil.getJsonDomain("colMainData");
//        info.setDR((String)para.get("DR"));
//        ColSummary summary = (ColSummary)ParamUtil.mapToBean(para, new ColSummary(), false);
//        String selectProjectId = ParamUtil.getString(para, "selectProjectId", "-1");
//        if ("-1".equals(selectProjectId)) {
//            summary.setProjectId((Long)null);
//        } else {
//            summary.setProjectId(Long.valueOf(selectProjectId));
//        }
//
//        Map para1 = ParamUtil.getJsonDomain("senderOpinion");
//        Comment comment = (Comment)ParamUtil.mapToBean(para1, new Comment(), false);
//        boolean saveProcessFlag = true;
//        CtpTemplate ct = null;
//        if (Strings.isNotBlank((String)para.get("tId"))) {
//            Long templateIdLong = Long.valueOf((String)para.get("tId"));
//            info.settId(templateIdLong);
//            ct = this.templateManager.getCtpTemplate(templateIdLong);
//            if (!"text".equals(ct.getType())) {
//                saveProcessFlag = false;
//            }
//        }
//
//        if (Strings.isNotBlank((String)para.get("curTemId"))) {
//            info.setCurTemId(Long.valueOf((String)para.get("curTemId")));
//        }
//
//        String subjectForCopy = (String)para.get("subjectForCopy");
//        info.setSubjectForCopy(subjectForCopy);
//        String isNewBusiness = (String)para.get("newBusiness");
//        info.setNewBusiness("1".equals(isNewBusiness));
//        info.setSummary(summary);
//        info.setCurrentUser(user);
//        Object canTrack = para.get("canTrack");
//        int track = 0;
//        if (null != canTrack) {
//            track = 1;
//            if (null != para.get("radiopart")) {
//                track = 2;
//            }
//
//            info.getSummary().setCanTrack(true);
//        } else {
//            info.getSummary().setCanTrack(false);
//        }
//
//        info.setTrackType(track);
//        String newSubject = "";
//        if (ct != null && "template".equals(ct.getType())) {
//            ColSummary summary1 = (ColSummary)XMLCoder.decoder(ct.getSummary());
//            if (summary1 != null && Boolean.TRUE.equals(summary1.getUpdateSubject())) {
//                newSubject = ColUtil.makeSubject(ct, summary, user);
//                if (Strings.isBlank(newSubject)) {
//                    newSubject = "{" + ResourceUtil.getString("collaboration.subject.default") + "}";
//                }
//
//                info.getSummary().setSubject(newSubject);
//            }
//        }
//
//        String trackMemberId = (String)para.get("zdgzry");
//        info.setTrackMemberId(trackMemberId);
//        String contentSaveId = (String)para.get("contentSaveId");
//        info.setContentSaveId(contentSaveId);
//        Map map = this.colManager.saveDraft(info, saveProcessFlag, para);
//
//        try {
//            String retJs = "parent.endSaveDraft('" + map.get("summaryId").toString() + "','" + map.get("contentId").toString() + "','" + map.get("affairId").toString() + "')";
//            if (Strings.isNotBlank(newSubject)) {
//                retJs = "parent.endSaveDraft('" + map.get("summaryId").toString() + "','" + map.get("contentId").toString() + "','" + map.get("affairId").toString() + "','" + newSubject + "')";
//            }
//
//            super.rendJavaScript(response, retJs);
//        } catch (Exception var21) {
//            LOG.error("调用js报错！", var21);
//        }
//
//        return null;
//    }
//
//    public ModelAndView send(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        if (!this.checkHttpParamValid(request, response)) {
//            return null;
//        } else {
//            Map para = ParamUtil.getJsonDomain("colMainData");
//            System.out.println(para);
//            ColSummary summary = (ColSummary)ParamUtil.mapToBean(para, new ColSummary(), false);
//            String clientDeadTime = (String)para.get("deadLineDateTime");
//            if (Strings.isNotBlank(clientDeadTime)) {
//                Date serviceDeadTime = Datetimes.parse(clientDeadTime);
//                summary.setDeadlineDatetime(serviceDeadTime);
//            }
//
//            summary.setSubject(Strings.nobreakSpaceToSpace(summary.getSubject()));
//            String dls = (String)para.get("deadLineselect");
//            if (Strings.isNotBlank(dls)) {
//                summary.setDeadline(Long.valueOf(dls));
//            }
//
//            ColInfo info = new ColInfo();
//            info.setDR((String)para.get("DR"));
//            if (para.get("canAutostopflow") == null) {
//                summary.setCanAutostopflow(false);
//            }
//
//            if (null != para.get("phaseId") && Strings.isNotBlank((String)para.get("phaseId"))) {
//                info.setPhaseId((String)para.get("phaseId"));
//            }
//
//            if (Strings.isNotBlank((String)para.get("tId"))) {
//                info.settId(Long.valueOf((String)para.get("tId")));
//            }
//
//            if (Strings.isNotBlank((String)para.get("curTemId"))) {
//                info.setCurTemId(Long.valueOf((String)para.get("curTemId")));
//            }
//
//            if (Strings.isNotBlank((String)para.get("parentSummaryId"))) {
//                summary.setParentformSummaryid(Long.valueOf((String)para.get("parentSummaryId")));
//            }
//
//            if (!String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
//                summary.setFormRecordid((Long)null);
//                summary.setFormAppid((Long)null);
//            }
//
//            String isNewBusiness = (String)para.get("newBusiness");
//            info.setNewBusiness("1".equals(isNewBusiness));
//            info.setSummary(summary);
//            SendType sendType = SendType.normal;
//            User user = AppContext.getCurrentUser();
//            info.setCurrentUser(user);
//            Object canTrack = para.get("canTrack");
//            int track = 0;
//            if (null != canTrack) {
//                track = 1;
//                if (null != para.get("radiopart")) {
//                    track = 2;
//                }
//
//                info.getSummary().setCanTrack(true);
//            } else {
//                info.getSummary().setCanTrack(false);
//            }
//
//            info.setTrackType(track);
//            info.setTrackMemberId((String)para.get("zdgzry"));
//            String caseId = (String)para.get("caseId");
//            info.setCaseId(StringUtil.checkNull(caseId) ? null : Long.parseLong(caseId));
//            String currentaffairId = (String)para.get("currentaffairId");
//            info.setCurrentAffairId(StringUtil.checkNull(currentaffairId) ? null : Long.parseLong(currentaffairId));
//            String currentProcessId = (String)para.get("oldProcessId");
//            LOG.info("老协同的currentProcessId=" + currentProcessId);
//            info.setCurrentProcessId(StringUtil.checkNull(currentProcessId) ? null : Long.parseLong(currentProcessId));
//            info.setTemplateHasPigeonholePath(String.valueOf(Boolean.TRUE).equals(para.get("isTemplateHasPigeonholePath")));
//            String formOperationId = (String)para.get("formOperationId");
//            info.setFormOperationId(formOperationId);
//            int bodyType = 0;
//
//            try {
//                bodyType = Integer.parseInt(summary.getBodyType());
//            } catch (Exception var27) {
//                ;
//            }
//
//            if (bodyType > 40 && bodyType < 46) {
//                List<CtpContentAll> contents = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
//                if (Strings.isEmpty(contents)) {
//                    ColUtil.webAlertAndClose(response, "正文保存失败，请重新新建后发送!");
//                    return null;
//                }
//            }
//
//            boolean isLock = false;
//
//
//                try {
//                    isLock = this.colLockManager.canGetLock(summary.getId());
//                    CtpAffair sendAffair;
//                    if (!isLock) {
//                        LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作-send,affairId" + summary.getId());
//                        return null;
//                    }
//                    sendAffair = this.affairManager.getSenderAffair(summary.getId());
//                    if (sendAffair == null || StateEnum.col_waitSend.getKey() == sendAffair.getState()) {
//                        info.setSenderAffair(sendAffair);
//                        System.out.println("json::::---->>>>::::"+JSON.toJSONString(info));
//                        this.colManager.transSend(info, sendType);
//                        return null;
//                    }
//
//
//                } finally {
//                    if (isLock) {
//                        this.colLockManager.unlock(summary.getId());
//                    }
//
//                }
//            StringBuilder lshsb;
//            if ("a8genius".equals(request.getParameter("from"))) {
//                super.rendJavaScript(response, "try{parent.parent.parent.closeWindow();}catch(e){window.close()}");
//                return null;
//            } else {
//                Map<String, Object> lshmap = (Map)request.getAttribute("lshMap");
//                lshsb = new StringBuilder();
//                if (null == lshmap) {
//                    if ("true".equals(para.get("isOpenWindow"))) {
//                        super.rendJavaScript(response, "window.close();");
//                        return null;
//                    } else {
//                        return this.redirectModelAndView("collaboration.do?method=listSent");
//                    }
//                } else {
//                    response.setContentType("text/html;charset=UTF-8");
//                    Iterator var21 = lshmap.entrySet().iterator();
//
//                    while(var21.hasNext()) {
//                        Entry entry = (Entry)var21.next();
//                        String key = (String)entry.getKey();
//                        String value = (String)entry.getValue();
//                        lshsb.append("已在{" + key + "}项上生成流水号:" + value + "\n");
//                    }
//
//                    String tslshString = lshsb.toString();
//                    PrintWriter out = response.getWriter();
//                    out.println("<script>");
//                    out.println("alert('" + StringEscapeUtils.escapeJavaScript(tslshString) + "');");
//                    out.println("window.location.href = 'collaboration.do?method=listSent';");
//                    out.println("</script>");
//                    out.flush();
//                    return null;
//                }
//            }
//        }
//    }
//
//    public ModelAndView sendImmediate(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
//        String workflowDataFlag = (String)wfdef.get("workflow_data_flag");
//        if (Strings.isBlank(workflowDataFlag) || "undefined".equals(workflowDataFlag.trim()) || "null".equals(workflowDataFlag.trim())) {
//            LOG.info("来自立即发送sendImmediate");
//        }
//
//        Map params = ParamUtil.getJsonParams();
//        String summaryIds = (String)params.get("summaryId");
//        String affairIds = (String)params.get("affairId");
//        if (summaryIds != null && affairIds != null) {
//            boolean sentFlag = false;
//            String workflowNodePeoplesInput = "";
//            String workflowNodeConditionInput = "";
//            String workflowNewflowInput = "";
//            String toReGo = "";
//            if (null != params.get("workflow_node_peoples_input")) {
//                workflowNodePeoplesInput = (String)params.get("workflow_node_peoples_input");
//            }
//
//            if (null != params.get("workflow_node_condition_input")) {
//                workflowNodeConditionInput = (String)params.get("workflow_node_condition_input");
//            }
//
//            if (null != params.get("workflow_newflow_input")) {
//                workflowNewflowInput = (String)params.get("workflow_newflow_input");
//            }
//
//            if (null != params.get("toReGo")) {
//                toReGo = (String)params.get("toReGo");
//            }
//
//            int bodyType = 0;
//            ColSummary summary = null;
//
//            try {
//                summary = this.colManager.getColSummaryById(Long.valueOf(summaryIds));
//                if (null != summary) {
//                    bodyType = Integer.parseInt(summary.getBodyType());
//                }
//            } catch (Exception var21) {
//                ;
//            }
//
//            if (bodyType > 40 && bodyType < 46 && summary != null) {
//                List<CtpContentAll> contents = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
//                if (Strings.isEmpty(contents)) {
//                    this.logger.info("正文不存在不能立即 发送，请重新编辑后发送!");
//                    return this.redirectModelAndView("collaboration.do?method=listSent");
//                }
//            }
//
//            boolean isLock = false;
//
//            try {
//                isLock = this.colLockManager.canGetLock(summary.getId());
//                CtpAffair sendAffair;
//                if (!isLock) {
//                    LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作sendImmediate,affairId" + summary.getId());
//                    return null;
//                }
//
//                sendAffair = this.affairManager.getSenderAffair(summary.getId());
//                if (sendAffair == null || StateEnum.col_waitSend.getKey() != sendAffair.getState()) {
//                    Object var17 = null;
//                    return (ModelAndView)var17;
//                }
//
//                this.colManager.transSendImmediate(summaryIds, sendAffair, sentFlag, workflowNodePeoplesInput, workflowNodeConditionInput, workflowNewflowInput, toReGo);
//            } finally {
//                if (isLock) {
//                    this.colLockManager.unlock(summary.getId());
//                }
//
//            }
//
//            return this.redirectModelAndView("collaboration.do?method=listSent");
//        } else {
//            return null;
//        }
//    }
//
//    public ModelAndView listSent(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listSent");
//        FlipInfo fi = new FlipInfo();
//        Map<String, String> param = this.getWebQueryCondition(fi, request);
//        request.setAttribute("fflistSent", this.colManager.getSentList(fi, param));
//        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(AppContext.currentAccountId());
//        boolean isHaveNewColl = MenuPurviewUtil.isHaveNewColl(AppContext.getCurrentUser());
//        modelAndView.addObject("newColNodePolicy", Strings.escapeJson(JSONUtil.toJSONString(newColNodePolicy)));
//        modelAndView.addObject("isHaveNewColl", isHaveNewColl);
//        modelAndView.addObject("paramMap", param);
//        modelAndView.addObject("hasDumpData", DumpDataVO.isHasDumpData());
//        return modelAndView;
//    }
//
//    public ModelAndView list4Quote(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/list4Quote");
//        FlipInfo fi = new FlipInfo();
//        this.getWebQueryCondition(fi, request);
//        modelAndView.addObject("hasDumpData", DumpDataVO.isHasDumpData());
//        return modelAndView;
//    }
//
//    private Map<String, String> getWebQueryCondition(FlipInfo fi, HttpServletRequest request) {
//        String condition = request.getParameter("condition");
//        String textfield = request.getParameter("textfield");
//        Map<String, String> query = new HashMap();
//        if (Strings.isNotBlank(condition) && Strings.isNotBlank(textfield)) {
//            query.put(condition, textfield);
//            fi.setParams(query);
//        }
//
//        return query;
//    }
//
//    public ModelAndView listDone(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listDone");
//        FlipInfo fi = new FlipInfo();
//        Map<String, String> param = this.getWebQueryCondition(fi, request);
//        request.setAttribute("fflistDone", this.colManager.getDoneList(fi, param));
//        modelAndView.addObject("paramMap", param);
//        modelAndView.addObject("hasDumpData", DumpDataVO.isHasDumpData());
//        return modelAndView;
//    }
//
//    public ModelAndView listPending(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listPending");
//        FlipInfo fi = new FlipInfo();
//        Map<String, String> param = this.getWebQueryCondition(fi, request);
//        request.setAttribute("fflistPending", this.colManager.getPendingList(fi, param));
//        modelAndView.addObject("paramMap", param);
//        return modelAndView;
//    }
//
//    public ModelAndView listWaitSend(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/listWaitSend");
//        FlipInfo fi = new FlipInfo();
//        Map<String, String> param = this.getWebQueryCondition(fi, request);
//        request.setAttribute("fflistWaitSend", this.colManager.getWaitSendList(fi, param));
//        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(AppContext.currentAccountId());
//        modelAndView.addObject("newColNodePolicy", Strings.escapeJson(JSONUtil.toJSONString(newColNodePolicy)));
//        modelAndView.addObject("paramMap", param);
//        return modelAndView;
//    }
//
//    public ModelAndView summary(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        ModelAndView mav = new ModelAndView("apps/collaboration/summary");
//        ColSummaryVO summaryVO = new ColSummaryVO();
//        User user = AppContext.getCurrentUser();
//        String affairId = request.getParameter("affairId");
//        String summaryId = request.getParameter("summaryId");
//        String processId = request.getParameter("processId");
//        String operationId = request.getParameter("operationId");
//        String formMutilOprationIds = request.getParameter("formMutilOprationIds");
//        String openFrom = request.getParameter("openFrom");
//        String type = request.getParameter("type");
//        String contentAnchor = request.getParameter("contentAnchor");
//        String pigeonholeType = request.getParameter("pigeonholeType");
//        String trackTypeRecord = request.getParameter("trackTypeRecord");
//        mav.addObject("trackTypeRecord", trackTypeRecord);
//        String dumpData = request.getParameter("dumpData");
//        boolean isHistoryFlag = "1".equals(dumpData);
//        summaryVO.setHistoryFlag(isHistoryFlag);
//        if ((!Strings.isNotBlank(affairId) || NumberUtils.isNumber(affairId)) && (!Strings.isNotBlank(summaryId) || NumberUtils.isNumber(summaryId)) && (!Strings.isNotBlank(processId) || NumberUtils.isNumber(processId))) {
//            if (Strings.isBlank(affairId) && Strings.isBlank(summaryId) && Strings.isBlank(processId)) {
//                ColUtil.webAlertAndClose(response, "无法访问该协同，请求参数中必须有affairId,summaryId,processId 三个参数中的一个！");
//                LOG.info("无法访问该协同，请求参数中必须有affairId,summaryId,processId 三个参数中的一个！");
//                return null;
//            } else {
//                summaryVO.setProcessId(processId);
//                summaryVO.setSummaryId(summaryId);
//                if (ColOpenFrom.subFlow.name().equals(openFrom)) {
//                    summaryVO.setOperationId(formMutilOprationIds);
//                } else {
//                    summaryVO.setOperationId(operationId);
//                }
//
//                summaryVO.setAffairId(Strings.isBlank(affairId) ? null : Long.parseLong(affairId));
//                summaryVO.setOpenFrom(openFrom);
//                summaryVO.setType(type);
//                summaryVO.setCurrentUser(user);
//                summaryVO.setLenPotent(request.getParameter("lenPotent"));
//                boolean isBlank = Strings.isBlank(pigeonholeType) || "null".equals(pigeonholeType) || "undefined".equals(pigeonholeType);
//                summaryVO.setPigeonholeType(isBlank ? PigeonholeType.edoc_dept.ordinal() : Integer.valueOf(pigeonholeType));
//
//                try {
//                    summaryVO = this.colManager.transShowSummary(summaryVO);
//                    if (summaryVO == null) {
//                        return null;
//                    }
//                } catch (Exception var22) {
//                    LOG.error("summary方法中summaryVO为空", var22);
//                    ColUtil.webAlertAndClose(response, var22.getMessage());
//                    return null;
//                }
//
//                if (Strings.isNotBlank(summaryVO.getErrorMsg())) {
//                    ColUtil.webAlertAndClose(response, summaryVO.getErrorMsg());
//                    return null;
//                } else {
//                    mav.addObject("forwardEventSubject", summaryVO.getSubject());
//                    summaryVO.setSubject(Strings.toHTML(Strings.toText(summaryVO.getSubject())));
//                    summaryVO.getSummary().setSubject(Strings.toHTML(summaryVO.getSummary().getSubject()));
//                    mav.addObject("summaryVO", summaryVO);
//                    mav.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
//                    String messsageAnchor = "";
//                    if (Strings.isNotBlank(contentAnchor)) {
//                        messsageAnchor = contentAnchor;
//                    }
//
//                    int superNodestatus = 0;
//                    if (null != summaryVO.getActivityId() && summaryVO.getProcessId() != null) {
//                        superNodestatus = this.wapi.getSuperNodeStatus(summaryVO.getProcessId(), String.valueOf(summaryVO.getActivityId()));
//                    }
//
//                    mav.addObject("moduleId", summaryVO.getSummary().getId());
//                    mav.addObject("moduleType", ModuleType.collaboration.getKey());
//                    mav.addObject("MainbodyType", summaryVO.getAffair().getBodyType());
//                    mav.addObject("superNodestatus", superNodestatus);
//                    mav.addObject("contentAnchor", messsageAnchor);
//                    mav.addObject("nodeDesc", Strings.toHTML((String)request.getAttribute("nodeDesc")));
//                    mav.addObject("signetProtectInput", request.getAttribute("signetProtectInput"));
//                    boolean canCreateMeeting = user.hasResourceCode("F09_meetingArrange");
//                    mav.addObject("canCreateMeeting", canCreateMeeting);
//                    return mav;
//                }
//            }
//        } else {
//            ColUtil.webAlertAndClose(response, "传入的参数非法，你无法访问该协同！");
//            return null;
//        }
//    }
//
//    public ModelAndView repealDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/repealDialog");
//        String affairId = request.getParameter("affairId");
//        String objectId = request.getParameter("objectId");
//        if (Strings.isNotBlank(affairId)) {
//            CtpAffair ctpAffair = this.affairManager.get(Long.valueOf(affairId));
//            if (null != ctpAffair && null != ctpAffair.getTempleteId()) {
//                CtpTemplate ctpTemplate = this.templateManager.getCtpTemplate(ctpAffair.getTempleteId());
//                mav.addObject("template", ctpTemplate.getCanTrackWorkflow());
//            }
//        }
//
//        mav.addObject("affairId", affairId);
//        mav.addObject("objectId", objectId);
//        return mav;
//    }
//
//    private boolean checkHttpParamValid(HttpServletRequest request, HttpServletResponse response) {
//        response.setContentType("text/html;charset=UTF-8");
//        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
//        String workflowDataFlag = (String)wfdef.get("workflow_data_flag");
//        if (!Strings.isBlank(workflowDataFlag) && !"undefined".equals(workflowDataFlag.trim()) && !"null".equals(workflowDataFlag.trim())) {
//            return true;
//        } else {
//            PrintWriter out = null;
//
//            try {
//                out = response.getWriter();
//                out.println("<script>");
//                out.println("alert('" + StringEscapeUtils.escapeJavaScript("从前端获取数据失败，请重试！") + "');");
//                out.println(" window.close();");
//                out.println("</script>");
//            } catch (Exception var10) {
//                LOG.error("", var10);
//            }
//
//            Enumeration es = request.getHeaderNames();
//            StringBuilder stringBuilder = new StringBuilder();
//            if (es != null) {
//                while(es.hasMoreElements()) {
//                    Object name = es.nextElement();
//                    String header = request.getHeader(name.toString());
//                    stringBuilder.append(name + ":=" + header + ",");
//                }
//
//                LOG.warn("request header---" + stringBuilder.toString());
//            }
//
//            return false;
//        }
//    }
//
//    public ModelAndView finishWorkItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        String viewAffairId = request.getParameter("affairId");
//        Long affairId = Strings.isBlank(viewAffairId) ? 0L : Long.parseLong(viewAffairId);
//        User user = AppContext.getCurrentUser();
//        ColSummary summary = null;
//        boolean isLock = false;
//        CtpAffair affair = null;
//        affair = this.affairManager.get(affairId);
//        if (affair != null) {
//            summary = this.colManager.getSummaryById(affair.getObjectId());
//        }
//
//        String msg;
//        try {
//            if (this.checkHttpParamValid(request, response)) {
//                isLock = this.colLockManager.canGetLock(affairId);
//                if (!isLock) {
//                    LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作finishWorkItem,affairId" + affairId);
//                    msg = null;
//                    return null;
//                }
//
//                HashMap params;
//                if (affair == null || affair.getState() != StateEnum.col_pending.key()) {
//                    msg = ColUtil.getErrorMsgByAffair(affair);
//                    if (Strings.isNotBlank(msg)) {
//                        ColUtil.webAlertAndClose(response, msg);
//                        params = null;
//                        return null;
//                    }
//                }
//
//                boolean canDeal = ColUtil.checkAgent(affair, summary, true);
//                if (!canDeal) {
//                    params = null;
//                    return null;
//                }
//                /**
//                 * trackParam:{"zdgzry":"","trackRange_members_textbox":""}
//                 * templateColSubject:
//                 * templateWorkflowId:-3052006732260228892
//                 */
//                params = new HashMap();
//                Map<String, String> trackPara = ParamUtil.getJsonDomain("trackDiv_detail");
//                params.put("trackParam", trackPara);
//                System.out.println("trackParam:"+trackPara);
//                Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
//                params.put("templateColSubject", templateMap.get("templateColSubject"));
//                System.out.println("templateColSubject:"+templateMap.get("templateColSubject"));
//                params.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
//                System.out.println("templateWorkflowId:"+templateMap.get("templateWorkflowId"));
//                this.colManager.transFinishWorkItem(summary, affair, params);
//                return null;
//            }
//
//            msg = null;
//        } finally {
//            if (isLock) {
//                this.colLockManager.unlock(affairId);
//            }
//
//            if (summary != null) {
//                this.colManager.colDelLock(summary, affair, true);
//            }
//
//        }
//
//        return null;
//    }
//
//    public ModelAndView doZCDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        String viewAffairId = request.getParameter("affairId");
//        Long affairId = Long.parseLong(viewAffairId);
//        CtpAffair affair = this.affairManager.get(affairId);
//        if (affair == null || affair.getState() != StateEnum.col_pending.key()) {
//            String msg = ColUtil.getErrorMsgByAffair(affair);
//            if (Strings.isNotBlank(msg)) {
//                PrintWriter out = response.getWriter();
//                out.println("<script>");
//                out.println("alert('" + StringEscapeUtils.escapeJavaScript(msg) + "');");
//                out.println(" window.close();");
//                out.println("</script>");
//                return null;
//            }
//        }
//
//        ColSummary summary = this.colManager.getColSummaryById(affair.getObjectId());
//        boolean canDeal = ColUtil.checkAgent(affair, summary, true);
//        if (!canDeal) {
//            return null;
//        } else {
//            Map<String, Object> params = new HashMap();
//            Map<String, String> trackPara = ParamUtil.getJsonDomain("trackDiv_detail");
//            params.put("trackParam", trackPara);
//            Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
//            params.put("templateColSubject", templateMap.get("templateColSubject"));
//            params.put("templateWorkflowId", templateMap.get("templateWorkflowId"));
//            boolean isLock = false;
//
//            try {
//                isLock = this.colLockManager.canGetLock(affairId);
//                if (!isLock) {
//                    LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作doZCDB,affairId" + affairId);
//                    Object var12 = null;
//                    return (ModelAndView)var12;
//                }
//
//                this.colManager.transDoZcdb(summary, affair, params);
//            } finally {
//                if (isLock) {
//                    this.colLockManager.unlock(affairId);
//                }
//
//                this.colManager.colDelLock(summary, affair);
//            }
//
//            return null;
//        }
//    }
//
//    public ModelAndView doForward(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        User user = AppContext.getCurrentUser();
//        Map para = ParamUtil.getJsonDomain("MainData");
//        String data = (String)para.get("data");
//        String[] ds = data.split("[,]");
//        String[] var7 = ds;
//        int var8 = ds.length;
//
//        for(int var9 = 0; var9 < var8; ++var9) {
//            String d1 = var7[var9];
//            if (!Strings.isBlank(d1)) {
//                String[] d1s = d1.split("[_]");
//                long summaryId = Long.parseLong(d1s[0]);
//                long affairId = Long.parseLong(d1s[1]);
//                this.colManager.transDoForward(user, summaryId, affairId, para);
//            }
//        }
//
//        return null;
//    }
//
//    public ModelAndView chooseOperation(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mv = new ModelAndView("apps/collaboration/isignaturehtml/chooseOperation");
//        return mv;
//    }
//
//    public ModelAndView showForward(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(AppContext.currentAccountId());
//        request.setAttribute("newColNodePolicy", newColNodePolicy);
//        return new ModelAndView("apps/collaboration/forward");
//    }
//
//    public ModelAndView stepStop(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        String affairId = request.getParameter("affairId");
//        Map<String, Object> tempMap = new HashMap();
//        tempMap.put("affairId", affairId);
//        boolean isLock = false;
//
//        PrintWriter out;
//        try {
//            isLock = this.colLockManager.canGetLock(Long.valueOf(affairId));
//            if (!isLock) {
//                LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作stepStop,affairId" + affairId);
//                out = null;
//                return null;
//            }
//
//            this.colManager.transStepStop(tempMap);
//        } finally {
//            if (isLock) {
//                this.colLockManager.unlock(Long.valueOf(affairId));
//            }
//
//            this.colManager.colDelLock(Long.valueOf(affairId));
//        }
//
//        out = response.getWriter();
//        out.println("<script>");
//        out.println("window.parent.$('#summary').attr('src','');");
//        out.println("window.parent.$('.slideDownBtn').trigger('click');");
//        out.println("window.parent.$('#listPending').ajaxgridLoad();");
//        out.println("</script>");
//        out.close();
//        return null;
//    }
//
//    public ModelAndView stepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        String affairId = request.getParameter("affairId");
//        String summaryId = request.getParameter("summaryId");
//        String trackWorkflowType = request.getParameter("isWFTrace");
//        Map<String, Object> tempMap = new HashMap();
//        tempMap.put("affairId", affairId);
//        tempMap.put("summaryId", summaryId);
//        tempMap.put("targetNodeId", "");
//        tempMap.put("isWFTrace", trackWorkflowType);
//        boolean isLock = false;
//
//        label93: {
//            String msg;
//            try {
//                isLock = this.colLockManager.canGetLock(Long.valueOf(affairId));
//                if (isLock) {
//                    msg = this.colManager.transStepBack(tempMap);
//                    if (!Strings.isNotBlank(msg)) {
//                        break label93;
//                    }
//
//                    ColUtil.webAlertAndClose(response, msg);
//                    Object var9 = null;
//                    return (ModelAndView)var9;
//                }
//
//                LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作stepBack,affairId:" + affairId);
//                msg = null;
//            } finally {
//                if (isLock) {
//                    this.colLockManager.unlock(Long.valueOf(affairId));
//                }
//
//                this.colManager.colDelLock(Long.valueOf(affairId));
//            }
//
//            return null;
//        }
//
//        PrintWriter out = response.getWriter();
//        out.println("<script>");
//        out.println("window.parent.$('#summary').attr('src','');");
//        out.println("window.parent.$('.slideDownBtn').trigger('click');");
//        out.println("window.parent.$('#listPending').ajaxgridLoad();");
//        out.println("</script>");
//        out.close();
//        return null;
//    }
//
//    public ModelAndView updateAppointStepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        String workitemId = request.getParameter("workitemId");
//        String processId = request.getParameter("processId");
//        String caseId = request.getParameter("caseId");
//        String activityId = request.getParameter("activityId");
//        String theStepBackNodeId = request.getParameter("theStepBackNodeId");
//        String submitStyle = request.getParameter("submitStyle");
//        String summaryId = request.getParameter("summaryId");
//        String affairId = request.getParameter("affairId");
//        String isWfTrace = request.getParameter("isWFTrace");
//        String isCircleBack = request.getParameter("isCircleBack");
//        Map<String, Object> tempMap = new HashMap();
//        tempMap.put("workitemId", workitemId);
//        tempMap.put("processId", processId);
//        tempMap.put("caseId", caseId);
//        tempMap.put("activityId", activityId);
//        tempMap.put("theStepBackNodeId", theStepBackNodeId);
//        tempMap.put("submitStyle", submitStyle);
//        tempMap.put("affairId", affairId);
//        tempMap.put("summaryId", summaryId);
//        tempMap.put("isWFTrace", isWfTrace);
//        tempMap.put("isCircleBack", isCircleBack);
//        CtpAffair currentAffair = this.affairManager.get(Long.parseLong(affairId));
//        ColSummary summary = this.colManager.getColSummaryById(Long.parseLong(summaryId));
//        User user = AppContext.getCurrentUser();
//        Comment comment = new Comment();
//        ParamUtil.getJsonDomainToBean("comment_deal", comment);
//        comment.setModuleId(summary.getId());
//        comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
//        if (!user.getId().equals(currentAffair.getMemberId())) {
//            comment.setExtAtt2(user.getName());
//        }
//
//        comment.setCreateId(currentAffair.getMemberId());
//        comment.setExtAtt3("collaboration.dealAttitude.rollback");
//        comment.setModuleType(ModuleType.collaboration.getKey());
//        comment.setPid(0L);
//        tempMap.put("affair", currentAffair);
//        tempMap.put("summary", summary);
//        tempMap.put("comment", comment);
//        tempMap.put("user", user);
//
//        try {
//            this.colManager.updateAppointStepBack(tempMap);
//        } finally {
//            this.wapi.releaseWorkFlowProcessLock(summary.getProcessId(), user.getId().toString(), 14);
//        }
//
//        PrintWriter out = response.getWriter();
//        out.println("<script>");
//        out.println("window.parent.$('#summary').attr('src','');");
//        out.println("window.parent.$('.slideDownBtn').trigger('click');");
//        out.println("window.parent.$('#listPending').ajaxgridLoad();");
//        out.println("</script>");
//        out.close();
//        return null;
//    }
//
//    public ModelAndView repeal(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        String summaryId = request.getParameter("summaryId");
//        String affairId = request.getParameter("affairId");
//        String trackWorkflowType = request.getParameter("isWFTrace");
//        Map<String, Object> tempMap = new HashMap();
//        tempMap.put("summaryId", summaryId);
//        tempMap.put("affairId", affairId);
//        tempMap.put("repealComment", request.getParameter("repealComment"));
//        tempMap.put("isWFTrace", trackWorkflowType);
//        Long laffairId = Long.valueOf(affairId);
//
//        try {
//            this.colManager.transRepal(tempMap);
//        } finally {
//            this.colManager.colDelLock(laffairId, true);
//        }
//
//        PrintWriter out = response.getWriter();
//        out.println("<script>");
//        out.println("window.parent.$('#summary').attr('src','');");
//        out.println("window.parent.$('.slideDownBtn').trigger('click');");
//        out.println("window.parent.$('#listPending').ajaxgridLoad();");
//        out.println("</script>");
//        out.close();
//        return null;
//    }
//
//    public ModelAndView getAttributeSettingInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/showAttributeSetting");
//        String affairId = request.getParameter("affairId");
//        String isHistoryFlag = request.getParameter("isHistoryFlag");
//        Map args = new HashMap();
//        args.put("affairId", affairId);
//        args.put("isHistoryFlag", isHistoryFlag);
//        Map map = this.colManager.getAttributeSettingInfo(args);
//        map.put("archiveName", map.get("archiveAllName"));
//        request.setAttribute("ffattribute", map);
//        mav.addObject("archiveAllName", map.get("archiveAllName"));
//        mav.addObject("attachmentArchiveName", map.get("attachmentArchiveName"));
//        mav.addObject("supervise", map.get("supervise"));
//        mav.addObject("openFrom", request.getParameter("openFrom"));
//        return mav;
//    }
//
//    public ModelAndView showTakebackConfirm(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/takebackConfirm");
//        return mav;
//    }
//
//    public ModelAndView showRepealCommentDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("common/workflowmanage/repealCommentDialog");
//        return mav;
//    }
//
//    public ModelAndView showPortalCatagory(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalCatagory");
//        request.setAttribute("openFrom", request.getParameter("openFrom"));
//        String category = ReqUtil.getString(request, "category", "");
//        if (Strings.isNotBlank(category)) {
//            mav = new ModelAndView("apps/collaboration/showPortalCatagory4MyTemplate");
//        }
//
//        return mav;
//    }
//
//    public ModelAndView showPortalImportLevel(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalImportLevel");
//        List<CtpEnumItem> secretLevelItems = this.enumManagerNew.getEnumItems(EnumNameEnum.edoc_urgent_level);
//        ColUtil.putImportantI18n2Session();
//        mav.addObject("itemCount", secretLevelItems.size());
//        return mav;
//    }
//
//    public ModelAndView disagreeDeal(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/disagreeDeal");
//        return mav;
//    }
//
//    public ModelAndView forwordMail(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        Map query = new HashMap();
//        query.put("summaryId", Long.parseLong(request.getParameter("id")));
//        query.put("formContent", String.valueOf(request.getParameter("formContent")));
//        ModelAndView mv = this.colManager.getforwordMail(query);
//        return mv;
//    }
//
//    public ModelAndView saveAsTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/saveAsTemplate");
//        String hasWorkflow = request.getParameter("hasWorkflow");
//        String subject = request.getParameter("subject");
//        String tembodyType = request.getParameter("tembodyType");
//        String formtitle = request.getParameter("formtitle");
//        String defaultValue = request.getParameter("defaultValue");
//        String ctype = request.getParameter("ctype");
//        String temType = request.getParameter("temType");
//        if ("hasnotTemplate".equals(temType)) {
//            mav.addObject("canSelectType", "all");
//        } else if ("template".equals(temType)) {
//            mav.addObject("canSelectType", "template");
//        } else if ("workflow".equals(temType)) {
//            mav.addObject("canSelectType", "workflow");
//        } else if ("text".equals(temType)) {
//            mav.addObject("canSelectType", "text");
//        }
//
//        if (Strings.isNotBlank(ctype)) {
//            int n = Integer.parseInt(ctype);
//            if (n == 20) {
//                mav.addObject("onlyTemplate", Boolean.TRUE);
//            }
//        }
//
//        mav.addObject("hasWorkflow", hasWorkflow);
//        mav.addObject("subject", subject);
//        mav.addObject("tembodyType", tembodyType);
//        mav.addObject("formtitle", formtitle);
//        mav.addObject("defaultValue", defaultValue);
//        return mav;
//    }
//
//    public ModelAndView detail(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        return this.summary(request, response);
//    }
//
//    public ModelAndView updateContentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/updateContentPage");
//        String summaryId = request.getParameter("summaryId");
//        ContentViewRet context = ContentUtil.contentView(ModuleType.collaboration, Long.parseLong(summaryId), (Long)null, 1, (String)null);
//        return mav;
//    }
//
//    public ModelAndView componentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/componentPage");
//        String affairId = request.getParameter("affairId");
//        String rightId = request.getParameter("rightId");
//        String readonly = request.getParameter("readonly");
//        String openFrom = request.getParameter("openFrom");
//        String isHistoryFlagView = request.getParameter("isHistoryFlag");
//        String canPraise = request.getParameter("canPraise");
//        boolean isHistoryFlag = Strings.isBlank(isHistoryFlagView) ? false : Boolean.valueOf(isHistoryFlagView);
//        canPraise = canPraise == null ? "true" : canPraise;
//        mav.addObject("canPraise", Boolean.valueOf(canPraise));
//        mav.addObject("isHasPraise", request.getParameter("isHasPraise"));
//        List<String> trackType = new ArrayList();
//        trackType.add(String.valueOf(workflowTrackType.step_back_repeal.getKey()));
//        trackType.add(String.valueOf(workflowTrackType.special_step_back_repeal.getKey()));
//        trackType.add(String.valueOf(workflowTrackType.circle_step_back_repeal.getKey()));
//        if (trackType.contains(request.getParameter("trackType")) && "stepBackRecord".equals(openFrom)) {
//            openFrom = "repealRecord";
//        }
//
//        CtpAffair affair = null;
//        ColSummary summary = null;
//        if (isHistoryFlag) {
//            affair = this.affairManager.getByHis(Long.valueOf(affairId));
//            summary = this.colManager.getColSummaryByIdHistory(affair.getObjectId());
//        } else {
//            affair = this.affairManager.get(Long.valueOf(affairId));
//            summary = this.colManager.getColSummaryById(affair.getObjectId());
//        }
//
//        User user = AppContext.getCurrentUser();
//        mav.addObject("moduleId", summary.getId().toString());
//        mav.addObject("affair", affair);
//        boolean signatrueShowFlag = Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState()) && "listPending".equals(openFrom);
//        mav.addObject("canDeleteISigntureHtml", signatrueShowFlag);
//        mav.addObject("isShowMoveMenu", signatrueShowFlag);
//        mav.addObject("isShowDocLockMenu", signatrueShowFlag);
//        boolean isFormQuery = ColOpenFrom.formQuery.name().equals(openFrom);
//        boolean isFormStatistical = ColOpenFrom.formStatistical.name().equals(openFrom);
//        boolean ifFromstepBackRecord = ColOpenFrom.stepBackRecord.name().equalsIgnoreCase(openFrom);
//        boolean isFromrepealRecord = ColOpenFrom.repealRecord.name().equalsIgnoreCase(openFrom);
//        if (!isFormQuery && !isFormStatistical && !ifFromstepBackRecord && !isFromrepealRecord) {
//            if (!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.collaboration, user, affair.getId(), affair, summary.getArchiveId())) {
//                return null;
//            }
//
//            AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, String.valueOf(affair.getObjectId()), user.getId());
//        }
//
//        int viewState = 2;
//        if (String.valueOf(MainbodyType.FORM.getKey()).equals(String.valueOf(affair.getBodyType())) && Integer.valueOf(StateEnum.col_pending.key()).equals(affair.getState()) && !"inform".equals(ColUtil.getPolicyByAffair(affair).getId()) && !AffairUtil.isFormReadonly(affair) && !"glwd".equals(openFrom) && !"listDone".equals(openFrom)) {
//            viewState = 1;
//        }
//
//        ContentUtil.contentViewForDetail_col(ModuleType.collaboration, summary.getId(), affair.getId(), viewState, rightId, isHistoryFlag);
//        mav.addObject("_viewState", Integer.valueOf(viewState));
//        Map<Long, List<String>> logDescMap = this.getCommentLog(summary.getProcessId());
//        mav.addObject("logDescMap", logDescMap);
//        List<CtpContentAllBean> contentList = (List)request.getAttribute("contentList");
//        request.setAttribute("contentList", contentList);
//        if (summary.getParentformSummaryid() != null && !summary.getCanEdit()) {
//            mav.addObject("isFromTransform", true);
//        }
//
//        List memberIds;
//        if ("repealRecord".equals(openFrom)) {
//            List<WorkflowTracePO> dataByParams = this.traceWorkflowManager.getDataByModuleIdAndAffairId(summary.getId(), affair.getId());
//            Long currentUserId = AppContext.currentUserId();
//            if (null != dataByParams && dataByParams.size() > 0) {
//                boolean flag = true;
//                memberIds = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
//
//                for(int a = 0; a < dataByParams.size(); ++a) {
//                    if (((WorkflowTracePO)dataByParams.get(a)).getMemberId().equals(currentUserId)) {
//                        if (Strings.isNotEmpty(memberIds) && Strings.isNotBlank(((WorkflowTracePO)dataByParams.get(a)).getFormContent())) {
//                            ((CtpContentAll)memberIds.get(0)).setContent(((WorkflowTracePO)dataByParams.get(a)).getFormContent());
//                            this.ctpMainbodyManager.saveOrUpdateContentAll((CtpContentAll)memberIds.get(0));
//                            flag = false;
//                        }
//                        break;
//                    }
//                }
//
//                if (flag && Strings.isNotEmpty(memberIds) && Strings.isNotBlank(((WorkflowTracePO)dataByParams.get(0)).getFormContent())) {
//                    ((CtpContentAll)memberIds.get(0)).setContent(((WorkflowTracePO)dataByParams.get(0)).getFormContent());
//                    this.ctpMainbodyManager.saveOrUpdateContentAll((CtpContentAll)memberIds.get(0));
//                }
//            }
//        }
//
//        mav.addObject("_rightId", rightId);
//        mav.addObject("_moduleId", summary.getId());
//        mav.addObject("_moduleType", ModuleType.collaboration.getKey());
//        mav.addObject("_contentType", summary.getBodyType());
//        ContentViewRet ret = (ContentViewRet)request.getAttribute("contentContext");
//        String workflowTraceType = request.getParameter("trackType");
//        Integer intWorkflowTraceType = Strings.isNotBlank(workflowTraceType) ? Integer.valueOf(workflowTraceType) : 0;
//        if (Integer.valueOf(workflowTrackType.repeal.getKey()).equals(intWorkflowTraceType) || Integer.valueOf(workflowTrackType.step_back_repeal.getKey()).equals(intWorkflowTraceType)) {
//            readonly = "true";
//        }
//
//        if (Boolean.valueOf(readonly)) {
//            ret.setCanReply(false);
//        }
//
//        if (ColOpenFrom.formQuery.name().equals(openFrom) || ColOpenFrom.formStatistical.name().equals(openFrom)) {
//            AppContext.putThreadContext("THREAD_CTX_NO_HIDDEN_COMMENT", "true");
//        }
//
//        AppContext.putThreadContext("THREAD_CTX_NOT_HIDE_TO_ID_KEY", summary.getStartMemberId());
//        if (!ColOpenFrom.supervise.name().equals(openFrom) && !ColOpenFrom.repealRecord.name().equals(openFrom)) {
//            AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", affair.getMemberId());
//        }
//
//        if (ColOpenFrom.glwd.name().equals(openFrom)) {
//            memberIds = this.affairManager.getAffairMemberIds(ApplicationCategoryEnum.collaboration, summary.getId());
//            AppContext.putThreadContext("THREAD_CTX_PROCESS_MEMBERS", Strings.isNotEmpty(memberIds) ? memberIds : new ArrayList());
//        }
//
//        if (Integer.valueOf(flowState.finish.ordinal()).equals(summary.getState()) || Integer.valueOf(flowState.terminate.ordinal()).equals(summary.getState()) || ColOpenFrom.glwd.name().equals(openFrom) || Boolean.valueOf(readonly)) {
//            mav.addObject("_isffin", "1");
//        }
//
//        mav.addObject("title", summary.getSubject());
//        mav.addObject("openFrom", openFrom);
//        ret.setContentSenderId(summary.getStartMemberId());
//        NodePolicyVO newColNodePolicy = this.colManager.getNewColNodePolicy(user.getLoginAccount());
//        mav.addObject("newColNodePolicy", newColNodePolicy);
//        mav.addObject("isNewColNode", (affair.getState().equals(StateEnum.col_sent.getKey()) || affair.getState().equals(StateEnum.col_waitSend.getKey())) && !ColOpenFrom.supervise.name().equals(openFrom));
//        return mav;
//    }
//
//    public MainbodyManager getCtpMainbodyManager() {
//        return this.ctpMainbodyManager;
//    }
//
//    public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
//        this.ctpMainbodyManager = ctpMainbodyManager;
//    }
//
//    public ModelAndView doDraftOpinion(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        long summaryId = Long.parseLong(request.getParameter("summaryId"));
//        long affairId = Long.valueOf(request.getParameter("affairId"));
//        this.colManager.saveOpinionDraft(affairId, summaryId);
//        return null;
//    }
//
//    public ModelAndView statisticSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/colStatisticSearch");
//        String bodyType = request.getParameter("bodyType");
//        String collType = request.getParameter("CollType");
//        String templateId = request.getParameter("templateId");
//        String startTime = request.getParameter("start_time");
//        String endTime = request.getParameter("end_time");
//        String status = request.getParameter("state");
//        String userId = request.getParameter("user_id");
//        String coverTime = request.getParameter("coverTime");
//        String isGroup = request.getParameter("isGroup");
//        FlipInfo fi = new FlipInfo();
//        Map<String, String> param = this.getStatisticSearchCondition(fi, request);
//        mav.addObject("isTeamReport", param.get("isTeamReport"));
//        request.setAttribute("fflistStatistic", this.colManager.getStatisticSearchCols(fi, param));
//        mav.addObject("bodyType", bodyType);
//        mav.addObject("CollType", collType);
//        mav.addObject("templateId", templateId);
//        mav.addObject("start_time", startTime);
//        mav.addObject("end_time", endTime);
//        mav.addObject("state", status);
//        mav.addObject("user_id", userId);
//        mav.addObject("coverTime", coverTime);
//        mav.addObject("isGroup", isGroup);
//        return mav;
//    }
//
//    public ModelAndView openTrackDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mav = new ModelAndView("apps/collaboration/trackDetail");
//        String objectId = request.getParameter("objectId");
//        String affairId = request.getParameter("affairId");
//        ColSummary summary = this.colManager.getColSummaryById(Long.valueOf(objectId));
//        CtpAffair affair = this.affairManager.get(Long.valueOf(affairId));
//        int trackType = affair.getTrack();
//        Long startMemberId = summary.getStartMemberId();
//        int state = summary.getState();
//        if (trackType == 2) {
//            List<CtpTrackMember> trackList = this.trackManager.getTrackMembers(Long.valueOf(affairId));
//            String zdgzrStr = "";
//            StringBuilder sb = new StringBuilder();
//            int a = 0;
//
//            for(int j = trackList.size(); a < j; ++a) {
//                CtpTrackMember cm = (CtpTrackMember)trackList.get(a);
//                sb.append("Member|" + cm.getTrackMemberId() + ",");
//            }
//
//            zdgzrStr = sb.toString();
//            if (Strings.isNotBlank(zdgzrStr)) {
//                mav.addObject("zdgzrStr", zdgzrStr.substring(0, zdgzrStr.length() - 1));
//            }
//        }
//
//        mav.addObject("objectId", objectId);
//        mav.addObject("affairId", affairId);
//        mav.addObject("trackType", trackType);
//        mav.addObject("state", state);
//        mav.addObject("startMemberId", startMemberId);
//        return mav;
//    }
//
//    private Map<String, String> getStatisticSearchCondition(FlipInfo fi, HttpServletRequest request) {
//        Map<String, String> query = new HashMap();
//        User user = AppContext.getCurrentUser();
//        if (user == null) {
//            return query;
//        } else {
//            String bodyType = request.getParameter("bodyType");
//            if (Strings.isNotBlank(bodyType)) {
//                query.put(ColQueryCondition.bodyType.name(), bodyType);
//            }
//
//            String collType = request.getParameter("CollType");
//            if (Strings.isNotBlank(collType)) {
//                query.put(ColQueryCondition.CollType.name(), collType);
//            }
//
//            String templateId = request.getParameter("templateId");
//            if (Strings.isNotBlank(templateId) && !"null".equals(templateId)) {
//                query.put(ColQueryCondition.templeteIds.name(), templateId);
//            }
//
//            String state = request.getParameter("state");
//            List<Integer> states = new ArrayList();
//            String userId;
//            if (Strings.isNotBlank(state) && !"null".equals(state)) {
//                String[] stateStrs = state.split(",");
//                String[] var11 = stateStrs;
//                int var12 = stateStrs.length;
//
//                for(int var13 = 0; var13 < var12; ++var13) {
//                    userId = var11[var13];
//                    states.add(Integer.valueOf(userId));
//                }
//
//                if (states.contains(1)) {
//                    query.put(ColQueryCondition.archiveId.name(), "archived");
//                    states.remove(states.indexOf(1));
//                }
//
//                if (states.contains(0)) {
//                    query.put(ColQueryCondition.subState.name(), String.valueOf(SubStateEnum.col_pending_ZCDB.getKey()));
//                    states.remove(states.indexOf(0));
//                }
//
//                if (states.size() > 0) {
//                    state = Functions.join(states, ",");
//                    query.put(ColQueryCondition.state.name(), state);
//                }
//            }
//
//            String startTime = request.getParameter("start_time");
//            String endTime = request.getParameter("end_time");
//            String queryTime = "";
//            if (Strings.isEmpty(startTime) && Strings.isEmpty(endTime)) {
//                queryTime = null;
//            } else {
//                queryTime = startTime + "#" + endTime;
//            }
//
//            if (Strings.isNotBlank(queryTime)) {
//                if (states.size() == 1) {
//                    if (Integer.valueOf(StateEnum.col_sent.getKey()).equals(states.get(0))) {
//                        query.put(ColQueryCondition.createDate.name(), queryTime);
//                    } else if (Integer.valueOf(StateEnum.col_pending.getKey()).equals(states.get(0))) {
//                        query.put(ColQueryCondition.receiveDate.name(), queryTime);
//                    } else if (Integer.valueOf(StateEnum.col_done.getKey()).equals(states.get(0))) {
//                        query.put(ColQueryCondition.completeDate.name(), queryTime);
//                    }
//                } else if (String.valueOf(SubStateEnum.col_pending_ZCDB.getKey()).equals(query.get(ColQueryCondition.subState.name()))) {
//                    query.put(ColQueryCondition.updateDate.name(), queryTime);
//                }
//
//                if ("archived".equals(query.get(ColQueryCondition.archiveId.name())) || states.size() > 1) {
//                    query.put("statisticDate", queryTime);
//                }
//            }
//
//            String coverTime = request.getParameter("coverTime");
//            if (Strings.isNotBlank(coverTime)) {
//                query.put(ColQueryCondition.coverTime.name(), coverTime);
//            }
//
//            userId = request.getParameter("user_id");
//            if (Strings.isNotBlank(userId)) {
//                query.put(ColQueryCondition.currentUser.name(), userId);
//            }
//
//            query.put("statistic", "true");
//            String isGroup = request.getParameter("isGroup");
//            if (Strings.isNotBlank(isGroup)) {
//                query.put("isTeamReport", isGroup);
//            }
//
//            fi.setParams(query);
//            return query;
//        }
//    }
//
//    public ModelAndView findAttachmentListBuSummaryId(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mv = new ModelAndView("apps/collaboration/attachmentList");
//        String summaryId = request.getParameter("summaryId");
//        String affairId = request.getParameter("affairId");
//        CtpAffair affair = this.affairManager.get(Long.valueOf(affairId));
//        if (affair == null) {
//            affair = this.affairManager.getByHis(Long.valueOf(affairId));
//        }
//
//        ColSummary summary = this.colManager.getColSummaryById(affair.getObjectId());
//        User user = AppContext.getCurrentUser();
//        String memberId = String.valueOf(affair.getMemberId());
//        if (!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.collaboration, user, affair.getId(), affair, summary.getArchiveId(), false)) {
//            SecurityCheck.printInbreakTrace(AppContext.getRawRequest(), AppContext.getRawResponse(), user, ApplicationCategoryEnum.collaboration);
//            return null;
//        } else {
//            String openFrom = request.getParameter("openFromList");
//            if (!ColOpenFrom.supervise.name().equals(openFrom) && Strings.isNotBlank(memberId)) {
//                AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", Long.valueOf(memberId));
//            }
//
//            List<AttachmentVO> attachmentVOs = this.colManager.getAttachmentListBySummaryId(Long.valueOf(summaryId), Long.valueOf(memberId));
//            boolean canLook = false;
//            Iterator var13 = attachmentVOs.iterator();
//
//            while(var13.hasNext()) {
//                AttachmentVO attachmentVO = (AttachmentVO)var13.next();
//                if (attachmentVO.isCanLook()) {
//                    canLook = true;
//                    break;
//                }
//            }
//
//            mv.addObject("canLook", canLook);
//            mv.addObject("attachmentVOs", attachmentVOs);
//            mv.addObject("attSize", attachmentVOs.size());
//            mv.addObject("isHistoryFlag", request.getParameter("isHistoryFlag"));
//            return mv;
//        }
//    }
//
//    public ModelAndView exportColSummaryExcel(HttpServletRequest request, HttpServletResponse response) {
//        new ArrayList();
//        FlipInfo fi = new FlipInfo();
//
//        try {
//            Map<String, String> param = this.getStatisticSearchCondition(fi, request);
//            List<ColSummaryVO> colList = this.colManager.exportDetaileExcel((FlipInfo)null, param);
//            String subject = ResourceUtil.getString("common.subject.label");
//            String sendUser = ResourceUtil.getString("cannel.display.column.sendUser.label");
//            String sendtime = ResourceUtil.getString("common.date.sendtime.label");
//            String receiveTime = ResourceUtil.getString("cannel.display.column.receiveTime.label");
//            String donedate = ResourceUtil.getString("common.date.donedate.label");
//            String deadlineDate = ResourceUtil.getString("pending.deadlineDate.label");
//            String track = ResourceUtil.getString("collaboration.track.state");
//            String[] columnName = new String[]{subject, sendUser, sendtime, receiveTime, donedate, deadlineDate, track};
//            DataRecord dataRecord = new DataRecord();
//            String excelName = ResourceUtil.getString("performanceReport.queryMain_js.throughQueryDialog.title");
//            dataRecord.setTitle(excelName);
//            dataRecord.setSheetName(excelName);
//            dataRecord.setColumnName(columnName);
//
//            for(int i = 0; i < colList.size(); ++i) {
//                ColSummaryVO data = (ColSummaryVO)colList.get(i);
//                DataRow dataRow = new DataRow();
//                dataRow.addDataCell(data.getSubject(), 1);
//                dataRow.addDataCell(data.getStartMemberName(), 1);
//                dataRow.addDataCell(data.getStartDate() != null ? Datetimes.format(data.getStartDate(), "yyyy-MM-dd HH:mm").toString() : "-", 5);
//                dataRow.addDataCell(data.getReceiveTime() != null ? Datetimes.format(data.getReceiveTime(), "yyyy-MM-dd HH:mm").toString() : "-", 5);
//                dataRow.addDataCell(data.getDealTime() != null ? Datetimes.format(data.getDealTime(), "yyyy-MM-dd HH:mm").toString() : "-", 5);
//                dataRow.addDataCell(data.getDeadLineDateName(), 1);
//                dataRow.addDataCell(data.getTrack() == 1 ? ResourceUtil.getString("message.yes.js") : ResourceUtil.getString("message.no.js"), 1);
//                dataRecord.addDataRow(new DataRow[]{dataRow});
//            }
//
//            this.fileToExcelManager.save(response, dataRecord.getTitle(), new DataRecord[]{dataRecord});
//        } catch (Exception var19) {
//            LOG.error("为用户绩效报表穿透查询列表时出现异常:", var19);
//        }
//
//        return null;
//    }
//
//    public ModelAndView combinedQuery(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/col_com_query");
//        if ("templeteAll".equals(request.getParameter("condition")) && "all".equals(request.getParameter("textfield"))) {
//            modelAndView.addObject("condition1", "1");
//        }
//
//        if ("bizcofnig".equals(request.getParameter("srcFrom"))) {
//            modelAndView.addObject("condition2", "1");
//        }
//
//        if ("1".equals(request.getParameter("bisnissMap"))) {
//            modelAndView.addObject("condition3", "1");
//        }
//
//        if ("templeteCategorys".equals(request.getParameter("condition"))) {
//            modelAndView.addObject("condition4", "1");
//        }
//
//        modelAndView.addObject("openForm", request.getParameter("openForm"));
//        modelAndView.addObject("dataType", request.getParameter("dataType"));
//        return modelAndView;
//    }
//
//    public ModelAndView colTansfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView();
//        Map<String, String> params = new HashMap();
//        String affairId = request.getParameter("affairId");
//        params.put("affairId", affairId);
//        params.put("transferMemberId", request.getParameter("transferMemberId"));
//        boolean isLock = false;
//
//        String message;
//        try {
//            isLock = this.colLockManager.canGetLock(Long.valueOf(affairId));
//            if (isLock) {
//                message = this.colManager.transColTransfer(params);
//                modelAndView.addObject("message", message);
//                return null;
//            }
//
//            LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作finishWorkItem,affairId" + affairId);
//            message = null;
//        } finally {
//            if (isLock) {
//                this.colLockManager.unlock(Long.valueOf(affairId));
//            }
//
//        }
//
//        return null;
//    }
//
//    public ModelAndView tabOffice(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView modelAndView = new ModelAndView("apps/collaboration/tabOffice");
//        Locale locale = AppContext.getLocale();
//        String localeStr = "zh-cn";
//        if (locale.equals(Locale.ENGLISH)) {
//            localeStr = "en";
//        } else if (locale.equals(Locale.TRADITIONAL_CHINESE)) {
//            localeStr = "zh-tw";
//        }
//
//        modelAndView.addObject("localeStr", localeStr);
//        return modelAndView;
//    }
//
//    private Map<Long, List<String>> getCommentLog(String processId) throws BusinessException {
//        List<Integer> actionList = new ArrayList();
//        actionList.add(ProcessLogAction.insertPeople.getKey());
//        actionList.add(ProcessLogAction.colAssign.getKey());
//        actionList.add(ProcessLogAction.deletePeople.getKey());
//        actionList.add(ProcessLogAction.inform.getKey());
//        actionList.add(ProcessLogAction.processColl.getKey());
//        actionList.add(ProcessLogAction.addAttachment.getKey());
//        actionList.add(ProcessLogAction.deleteAttachment.getKey());
//        actionList.add(ProcessLogAction.updateAttachmentOnline.getKey());
//        Map<Long, List<String>> logDescStrMap = new HashMap();
//        if (Strings.isBlank(processId)) {
//            return logDescStrMap;
//        } else {
//            List<ProcessLog> processLogs = this.processLogManager.getLogsByProcessIdAndActionId(Long.valueOf(processId), actionList);
//            Map<Long, List<ProcessLog>> processLogMap = new HashMap();
//
//            Iterator var6;
//            ProcessLog log;
//            List<ProcessLog> logs;
//            for(var6 = processLogs.iterator(); var6.hasNext(); processLogMap.put(log.getCommentId(), logs)) {
//                log = (ProcessLog)var6.next();
//                logs = processLogMap.get(log.getCommentId());
//                if (null != logs) {
//                    logs.add(log);
//                } else {
//                    logs = new ArrayList();
//                    logs.add(log);
//                }
//            }
//
//            ArrayList logDescs;
//            Long commentId;
//            for(var6 = processLogMap.keySet().iterator(); var6.hasNext(); logDescStrMap.put(commentId, logDescs)) {
//                commentId = (Long)var6.next();
//                List<ProcessLog> logs2 = (List)processLogMap.get(commentId);
//                Boolean addAttachment = false;
//                Boolean deleteAttachment = false;
//                Boolean updateAttachment = false;
//                logDescs = new ArrayList();
//                Map<Integer, String> logDescMap = new HashMap();
//                Iterator var14 = logs2.iterator();
//
//                String logString;
//                while(var14.hasNext()) {
//                     log = (ProcessLog)var14.next();
//                    if (actionList.contains(log.getActionId())) {
//                        if (Integer.valueOf(ProcessLogAction.addAttachment.getKey()).equals(log.getActionId())) {
//                            if (Strings.isNotBlank(log.getParam0()) && !addAttachment) {
//                                addAttachment = true;
//                            }
//                        } else if (Integer.valueOf(ProcessLogAction.deleteAttachment.getKey()).equals(log.getActionId())) {
//                            if (Strings.isNotBlank(log.getParam0()) && !deleteAttachment) {
//                                deleteAttachment = true;
//                            }
//                        } else if (Integer.valueOf(ProcessLogAction.updateAttachmentOnline.getKey()).equals(log.getActionId())) {
//                            if (Strings.isNotBlank(log.getParam0()) && !updateAttachment) {
//                                updateAttachment = true;
//                            }
//                        } else {
//                            logString = (String)logDescMap.get(log.getActionId());
//                            if (logString != null) {
//                                StringBuilder desc = new StringBuilder(logString);
//                                desc.append(",").append(log.getParam0());
//                                logString = desc.toString();
//                            } else {
//                                logString = log.getActionUserDesc();
//                            }
//
//                            logDescMap.put(log.getActionId(), logString);
//                        }
//                    }
//                }
//
//                var14 = actionList.iterator();
//
//                while(var14.hasNext()) {
//                    Integer action = (Integer)var14.next();
//                    logString = (String)logDescMap.get(action);
//                    if (null != logString) {
//                        logDescs.add(logString);
//                    }
//                }
//
//                List<String> attachmentOperation = new ArrayList();
//                if (addAttachment) {
//                    attachmentOperation.add(ResourceUtil.getString("processLog.action.user.attchement.add"));
//                }
//
//                if (deleteAttachment) {
//                    attachmentOperation.add(ResourceUtil.getString("processLog.action.user.attchement.delete"));
//                }
//
//                if (updateAttachment) {
//                    attachmentOperation.add(ResourceUtil.getString("processLog.action.user.attchement.update"));
//                }
//
//                if (attachmentOperation.size() != 0) {
//                    logDescs.add(ResourceUtil.getString("processLog.action.user.0", Strings.join(attachmentOperation, ",")));
//                }
//            }
//
//            return logDescStrMap;
//        }
//    }
//
//    public ModelAndView showNodeMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        response.setContentType("text/html;charset=UTF-8");
//        ModelAndView mav = new ModelAndView("apps/collaboration/showNodeMembers");
//        String nodeId = request.getParameter("nodeId");
//        String summaryId = request.getParameter("summaryId");
//        List<CtpAffair> affairs = this.affairManager.getAffairsByObjectIdAndNodeId(Long.valueOf(summaryId), Long.valueOf(nodeId));
//        List<Object[]> node2Affairs = new ArrayList();
//        if (Strings.isNotEmpty(affairs)) {
//            Iterator it = affairs.iterator();
//
//            CtpAffair a;
//            while(it.hasNext()) {
//                a = (CtpAffair)it.next();
//                if (!this.affairManager.isAffairValid(a, true)) {
//                    it.remove();
//                }
//            }
//
//            it = affairs.iterator();
//
//            label32:
//            while(true) {
//                do {
//                    do {
//                        if (!it.hasNext()) {
//                            break label32;
//                        }
//
//                        a = (CtpAffair)it.next();
//                    } while(a.getActivityId() == null);
//                } while(a.getState() != StateEnum.col_done.getKey() && a.getState() != StateEnum.col_pending.getKey());
//
//                Object[] o = new Object[]{a.getMemberId(), Functions.showMemberName(a.getMemberId()), a.getState(), a.getSubState(), a.getBackFromId()};
//                node2Affairs.add(o);
//            }
//        }
//
//        mav.addObject("commentPushMessageToMembersList", JSONUtil.toJSONString(node2Affairs));
//        mav.addObject("readSwitch", this.systemConfig.get("read_state_enable"));
//        return mav;
//    }
//
//    public ModelAndView cashTransData(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        String cashId = String.valueOf(UUIDUtil.getUUIDLong());
//        Map<String, String> paramMap = new HashMap();
//        Enumeration names = request.getParameterNames();
//
//        while(names.hasMoreElements()) {
//            String name = (String)names.nextElement();
//            paramMap.put(name, request.getParameter(name));
//        }
//
//        V3xShareMap.put(cashId, paramMap);
//        response.getWriter().write(cashId);
//        return null;
//    }
//
//    private boolean showTraceWorkflows(String subState, CtpAffair affair) throws BusinessException {
//        if (!Strings.isEmpty(subState) && affair != null) {
//            int intSubState = Integer.parseInt(subState);
//            if (SubStateEnum.col_waitSend_stepBack.key() == intSubState || SubStateEnum.col_waitSend_cancel.key() == intSubState || SubStateEnum.col_pending_specialBackToSenderCancel.key() == intSubState) {
//                List<WorkflowTracePO> traceWorkflows = this.traceWorkflowManager.getShowDataByParams(affair.getObjectId(), affair.getActivityId(), affair.getMemberId());
//                if (Strings.isNotEmpty(traceWorkflows)) {
//                    return true;
//                }
//            }
//
//            return false;
//        } else {
//            return false;
//        }
//    }
//}
