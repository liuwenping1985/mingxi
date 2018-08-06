//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.collaboration.controller;

import com.seeyon.apps.collaboration.bo.ColInfo;
import com.seeyon.apps.collaboration.bo.ColQueryCondition;
import com.seeyon.apps.collaboration.bo.TrackAjaxTranObj;
import com.seeyon.apps.collaboration.constants.ColConstant.SendType;
import com.seeyon.apps.collaboration.constants.ColConstant.flowState;
import com.seeyon.apps.collaboration.enums.ColOpenFrom;
import com.seeyon.apps.collaboration.event.CollaborationAddCommentEvent;
import com.seeyon.apps.collaboration.manager.ColLockManager;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.manager.ColManagerImpl;
import com.seeyon.apps.collaboration.manager.CollaborationService;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.po.WorkflowTracePO;
import com.seeyon.apps.collaboration.trace.enums.WorkflowTraceEnums.workflowTrackType;
import com.seeyon.apps.collaboration.trace.manager.TraceWorkflowManager;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.collaboration.vo.AttachmentVO;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.apps.collaboration.vo.NewCollTranVO;
import com.seeyon.apps.doc.manager.DocFilingManager;
import com.seeyon.apps.doc.util.Constants.PigeonholeType;
import com.seeyon.apps.govdoc.doc.bo.EdocQuickSendWorkFlow;
import com.seeyon.apps.govdoc.event.GovDocURLEvent;
import com.seeyon.apps.govdoc.exchange.dao.GovdocExchangeDetailLogDao;
import com.seeyon.apps.govdoc.exchange.manager.GovdocExchangeManager;
import com.seeyon.apps.govdoc.exchange.po.GovdocExchangeDetail;
import com.seeyon.apps.govdoc.exchange.po.GovdocExchangeDetailLog;
import com.seeyon.apps.govdoc.exchange.po.GovdocExchangeMain;
import com.seeyon.apps.govdoc.exchange.po.JointlyIssyedVO;
import com.seeyon.apps.govdoc.exchange.util.GovDocUtil;
import com.seeyon.apps.govdoc.exchange.util.GovDocEnum.ExchangeDetailStatus;
import com.seeyon.apps.govdoc.exchange.util.GovDocEnum.GovdocExchangeOrgType;
import com.seeyon.apps.govdoc.relation.manager.GovdocRelationManager;
import com.seeyon.apps.govdoc.relation.po.GovdocRelation;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.secret.util.SecretUtil;
import com.seeyon.apps.srs.util.SRSUtil;
import com.seeyon.apps.supervision.manager.SupervisionManager;
import com.seeyon.apps.supervision.vo.EdocSupervisionVo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.ContentConfig;
import com.seeyon.ctp.common.content.ContentUtil;
import com.seeyon.ctp.common.content.ContentViewRet;
import com.seeyon.ctp.common.content.ContentUtil.OperationType;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.content.comment.Comment.CommentType;
import com.seeyon.ctp.common.content.comment.dao.CommentDao;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenum.EnumNameEnum;
import com.seeyon.ctp.common.ctpenum.manager.EnumManager;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE;
import com.seeyon.ctp.common.filemanager.manager.AttachmentEditHelper;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.Util;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.permission.bo.NodePolicy;
import com.seeyon.ctp.common.permission.bo.Permission;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.permission.vo.PermissionVO;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.comment.CtpCommentAll;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenum.CtpEnum;
import com.seeyon.ctp.common.po.ctpenum.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.po.track.CtpTrackMember;
import com.seeyon.ctp.common.processlog.ProcessLogAction;
import com.seeyon.ctp.common.processlog.ProcessLogAction.ProcessEdocAction;
import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.enums.TemplateEnum.Type;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.template.manager.TemplateService;
import com.seeyon.ctp.common.template.util.TemplateUtil;
import com.seeyon.ctp.common.track.manager.CtpTrackMemberManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.manager.FormPermissionConfigManager;
import com.seeyon.ctp.form.manager.GovdocFormOpinionSortManager;
import com.seeyon.ctp.form.manager.GovdocTemplateDepAuthManager;
import com.seeyon.ctp.form.modules.engin.base.formBase.GovdocFormDefaultDao;
import com.seeyon.ctp.form.po.FormPermissionConfig;
import com.seeyon.ctp.form.po.GovdocTemplateDepAuth;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.Enums.FormStateEnum;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.FormUseFlagEnum;
import com.seeyon.ctp.form.util.permission.factory.PermissionFatory;
import com.seeyon.ctp.form.util.permission.util.PermissionUtil;
import com.seeyon.ctp.organization.OrgConstants.MemberPostType;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.MemberRole;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.customize.manager.CustomizeManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.XMLCoder;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.manager.ProcessManager;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.edoc.EdocEnum.TransferStatus;
import com.seeyon.v3x.edoc.dao.EdocOpinionDao;
import com.seeyon.v3x.edoc.domain.EdocObjTeam;
import com.seeyon.v3x.edoc.domain.EdocOpinion;
import com.seeyon.v3x.edoc.domain.EdocSendFormRelation;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocObjTeamManager;
import com.seeyon.v3x.edoc.manager.EdocSendFormRelationManager;
import com.seeyon.v3x.edoc.manager.EdocSwitchHelper;
import com.seeyon.v3x.edoc.manager.GovdocOpenManager;
import com.seeyon.v3x.edoc.util.EdocUtil;
import com.seeyon.v3x.meeting.dao.MeetingSummaryDao;
import com.seeyon.v3x.meetingsummary.domain.MtSummary;
import com.seeyon.v3x.project.domain.ProjectSummary;
import com.seeyon.v3x.project.manager.ProjectManager;
import com.seeyon.v3x.system.signet.manager.SignetManager;
import com.seeyon.v3x.util.SQLWildcardUtil;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.engine.wapi.NodeInfo;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;
import org.springframework.web.servlet.ModelAndView;
import www.seeyon.com.utils.UUIDUtil;

public class CollaborationController extends BaseController {
    private static final Logger LOGGER = Logger.getLogger(CollaborationController.class);
    private ColManager colManager;
    private AffairManager affairManger;
    private WorkflowApiManager wapi;
    private CustomizeManager customizeManager;
    private TemplateManager templateManager;
    private OrgManager orgManager;
    private AttachmentManager attachmentManager;
    private FileToExcelManager fileToExcelManager;
    private FileManager fileManager;
    private EdocManager edocManager;
    private EnumManager enumManager;
    private MainbodyManager ctpMainbodyManager;
    private ColLockManager colLockManager;
    private ConfigManager configManager;
    private ProcessLogManager processLogManager;
    private EdocObjTeamManager edocObjTeamManager;
    private IndexManager indexManager;
    private GovdocRelationManager govdocRelationManager;
    private CommentManager commentManager;
    private MeetingSummaryDao meetingSummaryDao;
    private SignetManager signetManager;
    private DocFilingManager docFilingManager;
    private CommentDao commentDao;
    private EdocOpinionDao edocOpinionDao;
    private GovdocOpenManager govdocOpenManager;
    private SupervisionManager supervisionManager;
    private AppLogManager appLogManager;
    private GovdocExchangeManager govdocExchangeManager;
    private FormPermissionConfigManager formPermissionConfigManager;
    private PermissionManager permissionManager;
    private TraceWorkflowManager traceWorkflowManager;
    private ProjectManager projectManager;
    private CtpTrackMemberManager trackManager;
    private AffairManager affairManager;

    public CollaborationController() {
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setGovdocOpenManager(GovdocOpenManager govdocOpenManager) {
        this.govdocOpenManager = govdocOpenManager;
    }

    public EdocOpinionDao getEdocOpinionDao() {
        return this.edocOpinionDao;
    }

    public void setEdocOpinionDao(EdocOpinionDao edocOpinionDao) {
        this.edocOpinionDao = edocOpinionDao;
    }

    public CommentDao getCommentDao() {
        return this.commentDao;
    }

    public void setCommentDao(CommentDao commentDao) {
        this.commentDao = commentDao;
    }

    public void setDocFilingManager(DocFilingManager docFilingManager) {
        this.docFilingManager = docFilingManager;
    }

    public SignetManager getSignetManager() {
        return this.signetManager;
    }

    public void setSignetManager(SignetManager signetManager) {
        this.signetManager = signetManager;
    }

    public MeetingSummaryDao getMeetingSummaryDao() {
        return this.meetingSummaryDao;
    }

    public void setMeetingSummaryDao(MeetingSummaryDao meetingSummaryDao) {
        this.meetingSummaryDao = meetingSummaryDao;
    }

    public CommentManager getCommentManager() {
        return this.commentManager;
    }

    public void setCommentManager(CommentManager commentManager) {
        this.commentManager = commentManager;
    }

    public void setGovdocRelationManager(GovdocRelationManager govdocRelationManager) {
        this.govdocRelationManager = govdocRelationManager;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public ConfigManager getConfigManager() {
        return this.configManager;
    }

    public void setConfigManager(ConfigManager configManager) {
        this.configManager = configManager;
    }

    public ProcessLogManager getProcessLogManager() {
        return this.processLogManager;
    }

    public void setProcessLogManager(ProcessLogManager processLogManager) {
        this.processLogManager = processLogManager;
    }

    public FormPermissionConfigManager getFormPermissionConfigManager() {
        return this.formPermissionConfigManager;
    }

    public void setFormPermissionConfigManager(FormPermissionConfigManager formPermissionConfigManager) {
        this.formPermissionConfigManager = formPermissionConfigManager;
    }

    public PermissionManager getPermissionManager() {
        return this.permissionManager;
    }

    public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    public GovdocExchangeManager getGovdocExchangeManager() {
        return this.govdocExchangeManager;
    }

    public void setGovdocExchangeManager(GovdocExchangeManager govdocExchangeManager) {
        this.govdocExchangeManager = govdocExchangeManager;
    }

    public ColLockManager getColLockManager() {
        return this.colLockManager;
    }

    public void setColLockManager(ColLockManager colLockManager) {
        this.colLockManager = colLockManager;
    }

    public void setEnumManager(EnumManager enumManager) {
        this.enumManager = enumManager;
    }

    public AffairManager getAffairManger() {
        return this.affairManger;
    }

    public void setAffairManger(AffairManager affairManger) {
        this.affairManger = affairManger;
    }

    public EdocManager getEdocManager() {
        return this.edocManager;
    }

    public void setEdocManager(EdocManager edocManager) {
        this.edocManager = edocManager;
    }

    public FileManager getFileManager() {
        return this.fileManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
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

    public void setProjectManager(ProjectManager projectManager) {
        this.projectManager = projectManager;
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

    public EdocObjTeamManager getEdocObjTeamManager() {
        return this.edocObjTeamManager;
    }

    public void setEdocObjTeamManager(EdocObjTeamManager edocObjTeamManager) {
        this.edocObjTeamManager = edocObjTeamManager;
    }

    public void setSupervisionManager(SupervisionManager supervisionManager) {
        this.supervisionManager = supervisionManager;
    }

    public ModelAndView newColl(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String app = request.getParameter("app");
        String sub_app = ReqUtil.getString(request, "sub_app", "collaboration");
        String oldSummaryId = request.getParameter("oldSummaryId");
        ModelAndView modelAndView = null;
        Long defaultFormId = null;
        Long contentDataId = null;
        boolean isWaitSend = false;
        boolean isWaitSendFenban = false;
        Long contentTemplateId = null;
        String templateId = request.getParameter("templateId");
        String isFenbanFlag = request.getParameter("isFenbanFlag");
        String curSummaryID = request.getParameter("curSummaryID");
        String meetingSummaryId = request.getParameter("meetingSummaryId");
        String isQuickSend = request.getParameter("isQuickSend");
        if (ColUtil.isGovDocRequest(request)) {
            modelAndView = new ModelAndView("govdoc/newGovdoc");
            ConfigItem govdocItem = this.configManager.getConfigItem("govdoc_switch", "govdocview", AppContext.getCurrentUser().getLoginAccount());
            if (govdocItem != null && govdocItem.getConfigValue().equals("yes")) {
                modelAndView.addObject("newGovdocView", 1);
            }

            if (this.govdocOpenManager != null && this.govdocOpenManager.isAllowCommentInForm()) {
                modelAndView.addObject("allowCommentInForm", 1);
            }

            if (Strings.isBlank(templateId)) {
                ConfigItem configItem = this.configManager.getConfigItem("govdoc_switch", "selfFlow", AppContext.getCurrentUser().getLoginAccount());
                if (configItem != null && "no".equals(configItem.getConfigValue())) {
                    modelAndView.addObject("noselfflow", "noselfflow");
                }
            }

            if (Strings.isNotBlank(isQuickSend)) {
                modelAndView.addObject("isQuickSend", true);
            } else {
                modelAndView.addObject("isQuickSend", false);
            }
        } else {
            modelAndView = new ModelAndView("apps/collaboration/newCollaboration");
        }

        User user = AppContext.getCurrentUser();
        NewCollTranVO vobj = new NewCollTranVO();
        vobj.setCreateDate(new Date());
        String from = request.getParameter("from");
        String s_summaryId = request.getParameter("summaryId");
        String projectID = request.getParameter("projectId");
        boolean relateProjectFlag = false;
        if (Strings.isNotBlank(projectID)) {
            relateProjectFlag = true;
        }

        String affairId = request.getParameter("affairId");
        ColSummary summary = null;
        boolean canEditColPigeonhole = true;
        CtpTemplate template = null;
        vobj.setFrom(from);
        vobj.setSummaryId(Strings.isBlank(s_summaryId) ? String.valueOf(UUIDUtil.getUUIDLong()) : s_summaryId);
        vobj.setTempleteId(templateId);
        vobj.setProjectId(Strings.isNotBlank(projectID) ? Long.parseLong(projectID) : null);
        vobj.setAffairId(affairId);
        vobj.setUser(user);
        vobj.setCanDeleteOriginalAtts(true);
        vobj.setCloneOriginalAtts(false);
        vobj.setArchiveName("");
        vobj.setNewBusiness("1");
        GovDocURLEvent event = new GovDocURLEvent(this);
        event.setApp(app);
        event.setSubApp(sub_app);
        EventDispatcher.fireEvent(event);
        boolean isEnable;
        PrintWriter out;
        if (Strings.isNotBlank(templateId) && s_summaryId == null) {
            if (Strings.isBlank(curSummaryID)) {
                vobj.setSummaryId(String.valueOf(UUIDUtil.getUUIDLong()));
            } else {
                vobj.setSummaryId(curSummaryID);
                vobj.setNewBusiness((String)null);
            }

            try {
                isEnable = this.templateManager.checkTemplateEnabel(templateId);
                if (!isEnable) {
                    if ("templateNewColl".equals(from)) {
                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                    } else {
                        out = response.getWriter();
                        out.println("<script>");
                        out.println("alert('模板已经被删除，或者您已经没有该模板的使用权限');");
                        out.print("parent.window.close();");
                        out.println("</script>");
                        out.flush();
                    }
                }

                vobj = this.colManager.transferTemplate(vobj);
                template = vobj.getTemplate();
                if (template.isDelete()) {
                    this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                    return null;
                }

                modelAndView.addObject("zwContentType", template.getBodyType());
                if ("4".equals(app) && template.isSystem()) {
                    modelAndView.addObject("isGovdocSystemTemplate", true);
                    modelAndView.addObject("isGovdocTemplate", true);
                }

                if (!template.isSystem()) {
                    ConfigItem configItem = this.configManager.getConfigItem("govdoc_switch", "selfFlow", AppContext.getCurrentUser().getLoginAccount());
                    if (configItem != null && "no".equals(configItem.getConfigValue())) {
                        modelAndView.addObject("noselfflow", "noselfflow");
                    }
                }
            } catch (Exception var54) {
                LOGGER.info("", var54);
                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                return null;
            }

            if (vobj == null) {
                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                return null;
            }

            canEditColPigeonhole = vobj.isCanEditColPigeonhole();
            if (vobj.getTemplate().getTempleteNumber() == null) {
                vobj.getTemplate().setTempleteNumber("");
            }

            if (Strings.isNotBlank(app) && "4".equals(app)) {
                FormManager formManager = (FormManager)AppContext.getBean("formManager");
                defaultFormId = formManager.getFormByFormCode4Govdoc(vobj.getTemplate()).getId();
            }

            modelAndView.addObject("taohongTemplete", template.getTaohongTemplete() == null ? "-1" : template.getTaohongTemplete());
        } else {
            Long referenceId;
            if ("resend".equals(from)) {
                vobj = this.colManager.transResend(vobj);
                vobj.setSummaryId(String.valueOf(UUIDLong.longUUID()));
                modelAndView.addObject("parentSummaryId", vobj.getSummary().getId());
                referenceId = vobj.getSummary().getId();
                ColSummary parentSummary = this.colManager.getSummaryById(referenceId);
                vobj.getSummary().setId(Long.valueOf(vobj.getSummaryId()));
                Long parentTemplateId = parentSummary.getTempleteId();
                CtpTemplate ctpTemplate = null;
                if (parentTemplateId != null) {
                    ctpTemplate = this.templateManager.getCtpTemplate(parentTemplateId);
                    if (ctpTemplate != null) {
                        ColSummary tSummary = (ColSummary)XMLCoder.decoder(ctpTemplate.getSummary());
                        vobj.setTempleteHasDeadline(tSummary.getDeadline() != null && tSummary.getDeadline() != 0L);
                        vobj.setTempleteHasRemind(tSummary.getAdvanceRemind() != null && tSummary.getAdvanceRemind() != 0L && tSummary.getAdvanceRemind() != -1L);
                        vobj.setCanEditColPigeonhole(tSummary.getArchiveId() != null);
                        vobj.setParentWrokFlowTemplete(this.colManager.isParentWrokFlowTemplete(ctpTemplate.getFormParentid()));
                        vobj.setParentTextTemplete(this.colManager.isParentTextTemplete(ctpTemplate.getFormParentid()));
                        vobj.setParentColTemplete(this.colManager.isParentColTemplete(ctpTemplate.getFormParentid()));
                        vobj.setFromSystemTemplete(ctpTemplate.isSystem());
                    }
                }

                this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
                modelAndView.addObject("isResend", "1");
            } else {
                String _formTitleText;
                if (vobj.getSummaryId() != null && "waitSend".equals(from)) {
                    vobj.setNewBusiness("0");

                    try {
                        if (Strings.isNotBlank(affairId)) {
                            CtpAffair valAffair = this.affairManager.get(Long.valueOf(affairId));
                            if (valAffair != null && !valAffair.getMemberId().equals(user.getId())) {
                                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("您无权查看该主题!"));
                                return null;
                            }
                        }

                        vobj = this.colManager.transComeFromWaitSend(vobj);
                        template = vobj.getTemplate();
                        if (template != null && template.isSystem()) {
                            isEnable = this.templateManager.checkTemplateEnabel("" + template.getId());
                            if (!isEnable) {
                                if ("templateNewColl".equals(from)) {
                                    this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                                } else {
                                    out = response.getWriter();
                                    out.println("<script>");
                                    out.println("alert('模板已经被删除，或者您已经没有该模板的使用权限');");
                                    out.print("parent.window.close();");
                                    out.println("</script>");
                                    out.flush();
                                }
                            }

                            if (template.isDelete()) {
                                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                                return null;
                            }

                            modelAndView.addObject("isGovdocSystemTemplate", true);
                            modelAndView.addObject("isGovdocTemplate", true);
                            modelAndView.addObject("taohongTemplete", template.getTaohongTemplete() == null ? "-1" : template.getTaohongTemplete());
                        }

                        this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
                        if (vobj.getSummary() != null && vobj.getSummary().getGovdocType() != null) {
                            modelAndView.setViewName("govdoc/newGovdoc");
                            if (Strings.isBlank(app)) {
                                app = "4";
                            }

                            if (Strings.isBlank(sub_app)) {
                                sub_app = vobj.getSummary().getGovdocType().toString();
                            }

                            EdocSummary edocSummary = this.edocManager.getEdocSummaryById(Long.parseLong(vobj.getSummaryId()));
                            if (edocSummary != null) {
                                modelAndView.addObject("jianbanType", edocSummary.getJianbanType());
                            }
                        }
                    } catch (BPMException var53) {
                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                        return null;
                    }

                    String subState = ReqUtil.getString(request, "subState", "");
                    modelAndView.addObject("subState", subState);
                    canEditColPigeonhole = vobj.isCanEditColPigeonhole();
                    modelAndView.addObject("alertSuperviseSet", true);
                    _formTitleText = request.getParameter("formTitleText");
                    if (Strings.isNotBlank(_formTitleText)) {
                        String _stiitle = URLDecoder.decode(_formTitleText, "UTF-8");
                        modelAndView.addObject("_formTitleText", _stiitle);
                        vobj.setCollSubject(_stiitle);
                        if (vobj.getSummary() != null) {
                            vobj.getSummary().setSubject(_stiitle);
                        }
                    }

                    if ("bizconfig".equals(request.getParameter("reqFrom"))) {
                        vobj.setFrom("bizconfig");
                    }

                    defaultFormId = vobj.getSummary().getFormAppid();
                    contentTemplateId = vobj.getSummary().getFormAppid();
                    contentDataId = vobj.getSummary().getFormRecordid();
                    isWaitSend = true;
                    modelAndView.addObject("isWaitSend", isWaitSend);
                    if (ColUtil.isGovDocRequest(request)) {
                        List<CtpContentAll> govdocCtpContentAll = MainbodyService.getInstance().getContentManager().getContentOfTransByModuleId(vobj.getSummary().getId());
                        Iterator it = govdocCtpContentAll.iterator();

                        while(it.hasNext()) {
                            MainbodyService.getInstance().getContentManager().deleteByEntityId(((CtpContentAll)it.next()).getId());
                        }
                    }

                    GovdocExchangeDetail govdocExchangeDetail = this.govdocExchangeManager.findDetailByRecSummaryId(vobj.getSummary().getId());
                    if (govdocExchangeDetail != null) {
                        isWaitSendFenban = true;
                    }
                } else if ("relatePeople".equals(from)) {
                    vobj.setNewBusiness("1");
                    V3xOrgMember sender = null;
                    _formTitleText = request.getParameter("memberId");
                    if (_formTitleText != null) {
                        sender = this.orgManager.getMemberById(Long.valueOf(_formTitleText));
                        V3xOrgAccount account = this.orgManager.getAccountById(sender.getOrgAccountId());
                        modelAndView.addObject("accountObj", account);
                        modelAndView.addObject("isSameAccount", String.valueOf(sender.getOrgAccountId().equals(user.getLoginAccount())));
                    }

                    modelAndView.addObject("peopeleCardInfo", sender);
                } else if ("a8genius".equals(from)) {
                    referenceId = UUIDLong.longUUID();
                    String[] attachids = request.getParameterValues("attachid");
                    if (attachids != null && attachids.length > 0) {
                        Long[] attId = new Long[attachids.length];

                        for(int count = 0; count < attachids.length; ++count) {
                            attId[count] = Long.valueOf(attachids[count]);
                        }

                        if (attId.length > 0) {
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

        EnumManager enumManager = (EnumManager)AppContext.getBean("enumManager");
        List<CtpEnumItem> secretLevelList1 = enumManager.getEnumItems(EnumNameEnum.edoc_secret_level);
        List<CtpEnumItem> secretLevelList = new ArrayList();
        if (CollectionUtils.isNotEmpty(secretLevelList1)) {
            Iterator var76 = secretLevelList1.iterator();

            while(var76.hasNext()) {
                CtpEnumItem item = (CtpEnumItem)var76.next();
                if (item.getState() != 0) {
                    item.setLabel(ResourceUtil.getString(item.getLabel()));
                    secretLevelList.add(item);
                }
            }
        }

        modelAndView.addObject("secretLevelList", secretLevelList);
        Long contentList;
        CtpTemplateCategory ctpTemplateCategory;
        String forwardText;
        String forwardAffairId;
        boolean cloneOriginalAtts;
        if (Strings.isNotBlank(app) && "4".equals(app)) {
            if (Strings.isNotBlank(oldSummaryId)) {
                if (vobj.getSummary() == null) {
                    List<CtpContentAll> ctpContentAlls = new ArrayList();
                    CtpContentAll content = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.parseLong(oldSummaryId));
                    if (content == null) {
                        ctpContentAlls = MainbodyService.getInstance().getContentManager().getContentOfTransByModuleId(Long.parseLong(oldSummaryId));
                    } else {
                        ((List)ctpContentAlls).add(content);
                    }

                    List<CtpContentAll> ctpContentAlls0 = new ArrayList();
                    Iterator var35 = ((List)ctpContentAlls).iterator();

                    while(var35.hasNext()) {
                        CtpContentAll ctpContentAll = (CtpContentAll)var35.next();
                        if (ctpContentAll.getContentType() != MainbodyType.HTML.getKey()) {
                            long contentFileId = Long.parseLong(ctpContentAll.getContent());
                            long newContentFileId = this.fileManager.copyFileBeforeModify(contentFileId);
                            if (newContentFileId != -1L) {
                                ctpContentAll.setContent(String.valueOf(newContentFileId));
                                ColUtil.copySignet(this.fileManager, this.signetManager, contentFileId, newContentFileId);
                            }
                        }

                        ctpContentAll.setId(UUIDLong.longUUID());
                        ctpContentAll.setModuleId(Long.parseLong(vobj.getSummaryId()));
                        ctpContentAll.setCreateDate(new Date());
                        ctpContentAll.setTransId((Long)null);
                        ctpContentAlls0.add(ctpContentAll);
                        this.ctpMainbodyManager.saveOrUpdateContentAll(ctpContentAll);
                    }
                }

                List<Attachment> attachments = this.attachmentManager.getByReference(Long.parseLong(oldSummaryId));
                if (attachments != null) {
                    List<Attachment> attachs = new ArrayList();
                    Iterator var88 = attachments.iterator();

                    while(var88.hasNext()) {
                        Attachment attachment = (Attachment)var88.next();
                        if (attachment.getCategory() == ApplicationCategoryEnum.edoc.getKey()) {
                            attachs.add(attachment);
                        }
                    }

                    modelAndView.addObject("fenbanFile", 1);
                    forwardText = this.attachmentManager.getAttListJSON(attachs);
                    Strings.isNotBlank(vobj.getAttListJSON());
                    vobj.setAttListJSON(forwardText);
                }
            }

            FormCacheManager formcachemanager = (FormCacheManager)AppContext.getBean("formCacheManager");
            List<Map<String, Object>> listMap = new ArrayList();
            CtpTemplateCategory category = null;
            HashMap params;
            if (template != null && AppContext.currentAccountId() != template.getOrgAccountId() && defaultFormId != null) {
                FormBean formBean = formcachemanager.getForm(defaultFormId);
                params = new HashMap();
                params.put("id", formBean.getId());
                params.put("categoryId", formBean.getCategoryId());
                params.put("name", formBean.getFormName());
                ((List)listMap).add(params);
                category = this.templateManager.getCategorybyId(formBean.getCategoryId());
            } else {
                FlipInfo fi = new FlipInfo();
                fi.setPage(-1);
                fi.setSize(-1);
                params = new HashMap();
                if ("1".equals(sub_app)) {
                    params.put("formType", FormType.govDocSendForm.getKey());
                } else if ("2".equals(sub_app)) {
                    params.put("formType", FormType.govDocReceiveForm.getKey());
                } else if ("3".equals(sub_app)) {
                    params.put("formType", FormType.govDocSignForm.getKey());
                }

                params.put("useFlag", FormUseFlagEnum.enabled.getKey());
                params.put("orgAccountId", AppContext.currentAccountId());
                params.put("state", FormStateEnum.published.getKey());
                listMap = formcachemanager.getFormDefinitionDAO().selectByFlipInfo(fi, params);
            }

            if (((List)listMap).size() <= 0) {
                modelAndView = new ModelAndView("govdoc/govdocNoSetting");
                return modelAndView;
            }

            GovdocFormDefaultDao govdocFormDefaultDao = (GovdocFormDefaultDao)AppContext.getBean("govdocFormDefaultDao");
            List<Integer> intList = new ArrayList();
            intList.add(Integer.parseInt(String.valueOf(ModuleType.govdocSend.getKey())));
            List<CtpTemplateCategory> list = new ArrayList();
            long defaultCategoryId = 0L;
            if (template != null && AppContext.currentAccountId() != template.getOrgAccountId() && category != null) {
                ((List)list).add(category);
                if (category.getId() != null) {
                    defaultCategoryId = category.getId();
                } else {
                    defaultCategoryId = 0L;
                }
            } else {
                list = this.templateManager.getCategorys(AppContext.getCurrentUser().getLoginAccount(), intList);
                contentList = Long.parseLong(String.valueOf(ModuleType.govdocSend.getKey()));
                CtpTemplateCategory govdocSendNode = new CtpTemplateCategory(contentList, "发文模板", Long.parseLong(String.valueOf(ModuleType.edoc.getKey())));
                ((List)list).add(govdocSendNode);
                Iterator var42;
                 ctpTemplateCategory = null;
                Iterator var44;
                CtpTemplateCategory ec;
                if (defaultFormId == null) {
                    if ("2".equals(sub_app)) {
                        defaultFormId = govdocFormDefaultDao.getDefaultReceiveFormId();
                    } else if ("1".equals(sub_app)) {
                        var42 = ((List)list).iterator();

                        while(var42.hasNext()) {
                            ctpTemplateCategory = (CtpTemplateCategory)var42.next();
                            defaultFormId = govdocFormDefaultDao.getDefaultSendFormId(ctpTemplateCategory.getId());
                            if (defaultFormId != null) {
                                defaultCategoryId = ctpTemplateCategory.getId();
                                break;
                            }
                        }

                        if (defaultFormId == null && ((List)listMap).size() > 0) {
                            defaultCategoryId = (Long)((Map)((List)listMap).get(0)).get("categoryId");
                            defaultFormId = (Long)((Map)((List)listMap).get(0)).get("id");
                        }
                    } else if ("3".equals(sub_app)) {
                        Long govdocSign = Long.parseLong(String.valueOf(ModuleType.govdocSign.getKey()));
                        ec = new CtpTemplateCategory(govdocSign, "签报模板", Long.parseLong(String.valueOf(ModuleType.edoc.getKey())));
                        ((List)list).add(ec);
                        var44 = ((List)list).iterator();

                        while(var44.hasNext()) {
                            ctpTemplateCategory = (CtpTemplateCategory)var44.next();
                            defaultFormId = govdocFormDefaultDao.getDefaultSignFormId(ctpTemplateCategory.getId());
                            if (defaultFormId != null) {
                                defaultCategoryId = ctpTemplateCategory.getId();
                                break;
                            }
                        }

                        if (defaultFormId == null && ((List)listMap).size() > 0) {
                            defaultCategoryId = (Long)((Map)((List)listMap).get(0)).get("categoryId");
                            defaultFormId = (Long)((Map)((List)listMap).get(0)).get("id");
                        }
                    }
                } else {
                    var42 = ((List)listMap).iterator();

                    while(var42.hasNext()) {
                        Map<String, Object> map = (Map)var42.next();
                        if (map.get("id").equals(defaultFormId)) {
                            var44 = ((List)list).iterator();

                            while(var44.hasNext()) {
                                ctpTemplateCategory = (CtpTemplateCategory)var44.next();
                                if (map.get("categoryId").equals(ctpTemplateCategory.getId())) {
                                    defaultCategoryId = ctpTemplateCategory.getId();
                                    break;
                                }
                            }
                        }

                        if (defaultCategoryId != 0L) {
                            break;
                        }
                    }
                }

                Iterator it = ((List)list).iterator();

                while(it.hasNext()) {
                    ec = (CtpTemplateCategory)it.next();
                    cloneOriginalAtts = false;
                    Iterator var45 = ((List)listMap).iterator();

                    while(var45.hasNext()) {
                        Map<String, Object> map = (Map)var45.next();
                        Object ecIdObj = map.get("categoryId");
                        Long moren = govdocFormDefaultDao.getDefaultSendFormId(ec.getId());
                        if (map.get("id").equals(moren)) {
                            map.put("defaultFormByCategory", 1);
                        }

                        if (ecIdObj != null && Strings.isNotBlank(ecIdObj.toString()) && ec.getId().toString().equals(ecIdObj.toString())) {
                            cloneOriginalAtts = true;
                        }
                    }

                    if (!cloneOriginalAtts) {
                        it.remove();
                    }
                }
            }

            String signAndDistribute = request.getParameter("signAndDistribute");
            if (Strings.isNotBlank(signAndDistribute)) {
                modelAndView.addObject("signAndDistribute", signAndDistribute);
            }

            forwardAffairId = request.getParameter("isDistribute");
            if (Strings.isNotBlank(forwardAffairId)) {
                modelAndView.addObject("isDistribute", forwardAffairId);
            }

            modelAndView.addObject("edocCategoryList", list);
            modelAndView.addObject("formList", JSONUtil.toJSONString(listMap));
            modelAndView.addObject("defaultFormId", defaultFormId);
            modelAndView.addObject("defaultCategoryId", defaultCategoryId);
            modelAndView.addObject("app", app);
            modelAndView.addObject("sub_app", sub_app);
            if (sub_app != null) {
                if (sub_app.equals("1")) {
                    modelAndView.addObject("_govDocFormType", 5);
                } else if (sub_app.equals("2")) {
                    modelAndView.addObject("_govDocFormType", 7);
                } else if (sub_app.equals("3")) {
                    modelAndView.addObject("_govDocFormType", 8);
                }
            }
        }

        if (vobj.getSummary() == null) {
            summary = new ColSummary();
            if (Strings.isNotBlank(oldSummaryId)) {
                ColSummary fbSummary = this.colManager.getSummaryById(Long.valueOf(oldSummaryId));
                summary.setSecretLevel(fbSummary.getSecretLevel());
            }

            vobj.setSummary(summary);
            summary.setCanForward(true);
            summary.setCanArchive(true);
            summary.setCanDueReminder(true);
            summary.setCanEditAttachment(true);
            summary.setCanModify(true);
            summary.setCanTrack(true);
            summary.setCanEdit(true);
            summary.setAdvanceRemind(-1L);
            if ("true".equals(isQuickSend)) {
                summary.setProcessId("" + EdocQuickSendWorkFlow.processId);
                summary.setGovdocType(Integer.valueOf(sub_app));
                summary.setIsQuickSend(true);
                vobj.setProcessId("" + EdocQuickSendWorkFlow.processId);
            }
        }

        if (vobj.isParentColTemplete() && vobj.getTemplate() != null && vobj.getTemplate().getProjectId() != null) {
            modelAndView.addObject("disabledProjectId", "1");
        }

        if (!relateProjectFlag) {
            Long projectId = vobj.getSummary().getProjectId();
            vobj.setProjectId(projectId);
        }

        ContentConfig _config = ContentConfig.getConfig(ModuleType.collaboration);
        modelAndView.addObject("contentCfg", _config);
        forwardText = request.getParameter("forwardText");
        ContentViewRet context;
        String formAppId;
        String govdocBodyType;
        if (Strings.isBlank(forwardText) && Strings.isBlank(oldSummaryId) && (s_summaryId == null && Strings.isBlank(templateId) || Strings.isNotBlank(templateId) && Type.workflow.name().equals(template.getType())) && Strings.isBlank(meetingSummaryId)) {
            context = this.setWorkflowParam(request, (Long)null, ModuleType.collaboration);
        } else {
            Long originalContentId = null;
            formAppId = null;
            if (s_summaryId != null) {
                originalContentId = Long.parseLong(s_summaryId);
            } else if (Strings.isNotBlank(templateId)) {
                originalContentId = Long.valueOf(templateId);
            }

            if (template != null && MainbodyType.FORM.getKey() == Integer.parseInt(template.getBodyType()) && template.getWorkflowId() != null && template.getWorkflowId() != 0L) {
                formAppId = this.wapi.getNodeFormViewAndOperationName(template.getWorkflowId(), (String)null);
            }

            ColSummary fromToSummary = vobj.getSummary();
            int viewState = 1;
            if (fromToSummary.getParentformSummaryid() != null && !fromToSummary.getCanEdit()) {
                viewState = 2;
            }

            modelAndView.addObject("contentViewState", Integer.valueOf(viewState));
            modelAndView.addObject("uuidlong", UUIDLong.longUUID());
            modelAndView.addObject("zwModuleId", originalContentId);
            modelAndView.addObject("zwRightId", formAppId);
            modelAndView.addObject("zwIsnew", "false");
            modelAndView.addObject("zwViewState", Integer.valueOf(viewState));
            modelAndView.addObject("govdocBodyType", MainbodyType.WpsWord.name());
            context = this.setWorkflowParam(request, originalContentId, ModuleType.collaboration);
            ContentUtil.commentView(request, _config, ModuleType.collaboration, originalContentId, (Long)null);
            CtpContentAll ctpContentAll = null;
            contentList = null;
            if (Strings.isNotBlank(templateId) && template != null && template.getId() != null) {
                if (Strings.isNotBlank(isFenbanFlag) && Strings.isNotBlank(curSummaryID) && "true".equals(isFenbanFlag)) {
                    ctpContentAll = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.valueOf(curSummaryID));
                } else {
                    ctpContentAll = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.valueOf(templateId));
                    if (ctpContentAll != null && "-1".equals(ctpContentAll.getContent())) {
                        CtpContentAll oldContentAll = this.ctpMainbodyManager.getContentNotFormByModuleId(Long.valueOf(vobj.getSummaryId()));
                        if (oldContentAll != null) {
                            ctpContentAll.setContent(oldContentAll.getContent());
                            ctpContentAll.setContentType(oldContentAll.getContentType());
                        }

                        modelAndView.addObject("isGovdocTemplate", false);
                    }
                }
            } else {
                List<CtpContentAll> contentAlls = new ArrayList();
                ctpTemplateCategory = null;
                CtpContentAll content;
                if (ColUtil.isGovDocRequest(request)) {
                    content = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.valueOf(vobj.getSummaryId()));
                    if (content == null) {
                        contentAlls = MainbodyService.getInstance().getContentManager().getContentOfTransByModuleId(Long.valueOf(vobj.getSummaryId()));
                    } else {
                        ((List)contentAlls).add(content);
                    }
                } else {
                    content = MainbodyService.getInstance().getContentManager().getFormContentByModuleId(Long.valueOf(vobj.getSummaryId()));
                    ((List)contentAlls).add(content);
                }

                if (contentAlls != null && ((List)contentAlls).size() > 0) {
                    ctpContentAll = (CtpContentAll)((List)contentAlls).get(0);
                }
            }

            if (Strings.isNotBlank(oldSummaryId) && Strings.isNotBlank(templateId)) {
                ctpContentAll = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.valueOf(oldSummaryId));
                if (ctpContentAll == null) {
                    List<CtpContentAll> alls = MainbodyService.getInstance().getContentManager().getContentOfTransByModuleId(Long.valueOf(oldSummaryId));
                    if (alls != null && alls.size() > 0) {
                        ctpContentAll = (CtpContentAll)alls.get(0);
                    }
                }
            }

            forwardAffairId = request.getParameter("forwardAffairId");
            if (Strings.isNotBlank(forwardText)) {
                String[] result = forwardText.split("\\.");
                if (Strings.isNotBlank(forwardAffairId)) {
                    CtpAffair affair = this.affairManager.get(Long.valueOf(forwardAffairId));
                    modelAndView.addObject("forwardSummaryId", affair.getObjectId());
                    List<Attachment> atts = new ArrayList();
                    if (result[0].equals("0")) {
                        ctpContentAll = this.ctpMainbodyManager.getContentNotFormByModuleId(affair.getObjectId());
                    } else if (result[0].equals("1")) {
                        CtpContentAll contentAll = this.ctpMainbodyManager.getContentNotFormByModuleId(affair.getObjectId());
                        String content = contentAll.getContent();
                        Date createDate = contentAll.getCreateDate();
                        String subject = affair.getSubject();
                        if (contentAll.getContentType() == MainbodyType.HTML.getKey()) {
                            V3XFile f = this.fileManager.save(content == null ? "" : content, ApplicationCategoryEnum.edoc, subject + ".htm", createDate, false);
                            atts.add(new Attachment(f, ApplicationCategoryEnum.edoc, ATTACHMENT_TYPE.FILE));
                        } else {
                            V3XFile f;
                            String srcPath;
                            if (contentAll.getContentType() != MainbodyType.Pdf.getKey() && contentAll.getContentType() != MainbodyType.Ofd.getKey()) {
                                srcPath = this.fileManager.getFolder(createDate, true) + File.separator + content;
                                String newPath = CoderFactory.getInstance().decryptFileToTemp(srcPath);
                                String newPathName = SystemEnvironment.getSystemTempFolder() + File.separator + UUIDLong.longUUID();
                                Util.jinge2StandardOffice(newPath, newPathName);
                                InputStream in = new FileInputStream(new File(newPathName));
                                f = this.fileManager.save(in, ApplicationCategoryEnum.edoc, subject + EdocUtil.getOfficeFileExt(MainbodyType.getEnumByKey(contentAll.getContentType()).toString()), createDate, false);
                                atts.add(new Attachment(f, ApplicationCategoryEnum.edoc, ATTACHMENT_TYPE.FILE));
                            } else {
                                srcPath = this.fileManager.getFolder(createDate, true) + File.separator + content;
                                File srcFile = new File(srcPath);
                                if (srcFile.exists() && srcFile.isFile()) {
                                    InputStream in = new FileInputStream(srcFile);
                                    String extName = ".pdf";
                                    if (contentAll.getContentType() == MainbodyType.Ofd.getKey()) {
                                        extName = ".ofd";
                                    }

                                    f = this.fileManager.save(in, ApplicationCategoryEnum.edoc, subject + extName, createDate, false);
                                    atts.add(new Attachment(f, ApplicationCategoryEnum.edoc, ATTACHMENT_TYPE.FILE));
                                } else {
                                    this.logger.error("公文正文的文件不存在：" + srcFile);
                                }
                            }
                        }
                    }

                    if (result[1].equals("true") || result[2].equals("true")) {
                        modelAndView.addObject("govdocRelation1", result[1]);
                    }

                    if (result[2].equals("true")) {
                        modelAndView.addObject("govdocRelation2", result[2]);
                    }

                    modelAndView.addObject("forwardText", forwardText);
                    List<Attachment> attachments = this.attachmentManager.getByReference(affair.getObjectId());
                    Iterator var144 = attachments.iterator();

                    while(var144.hasNext()) {
                        Attachment attachment = (Attachment)var144.next();
                        if (attachment.getType() == ATTACHMENT_TYPE.FILE.ordinal()) {
                            atts.add(attachment);
                        }
                    }

                    modelAndView.addObject("forwardAffairId", forwardAffairId);
                    vobj.setAttListJSON(this.attachmentManager.getAttListJSON(atts));
                }
            }

            if (StringUtils.isNotBlank(meetingSummaryId)) {
                MtSummary mtSummary = (MtSummary)this.meetingSummaryDao.get(Long.valueOf(meetingSummaryId));
                if (mtSummary != null) {
                    ctpContentAll = new CtpContentAll();
                    ctpContentAll.setContent(mtSummary.getContent());
                    ctpContentAll.setCreateDate(new Date());
                     govdocBodyType = mtSummary.getDataFormat();
                    if (MainbodyType.HTML.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.HTML.getKey());
                    } else if (MainbodyType.OfficeWord.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.OfficeWord.getKey());
                    } else if (MainbodyType.OfficeExcel.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.OfficeExcel.getKey());
                    } else if (MainbodyType.WpsWord.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.WpsWord.getKey());
                    } else if (MainbodyType.WpsExcel.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.WpsExcel.getKey());
                    } else if (MainbodyType.Pdf.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.Pdf.getKey());
                    } else if (MainbodyType.Ofd.name().equals(govdocBodyType)) {
                        ctpContentAll.setContentType(MainbodyType.Ofd.getKey());
                    } else {
                        ctpContentAll.setContentType(MainbodyType.OfficeWord.getKey());
                    }
                }
            }

            if (ctpContentAll != null && ctpContentAll.getContentType() != null && MainbodyType.FORM.getKey() != ctpContentAll.getContentType()) {
                govdocBodyType = "";
                Integer tempType = 0;
                CtpContentAll contentAll;
                if (vobj.getSummaryId() != null && "waitSend".equals(from)) {
                    contentAll = this.ctpMainbodyManager.getContentNotFormByModuleId(Long.valueOf(vobj.getSummaryId()));
                    if (contentAll != null) {
                        tempType = contentAll.getContentType();
                    }
                } else {
                    tempType = ctpContentAll.getContentType();
                }

                if (tempType == 10) {
                    govdocBodyType = MainbodyType.HTML.name();
                } else if (tempType == 41) {
                    govdocBodyType = MainbodyType.OfficeWord.name();
                } else if (tempType == 42) {
                    govdocBodyType = MainbodyType.OfficeExcel.name();
                } else if (tempType == 43) {
                    govdocBodyType = MainbodyType.WpsWord.name();
                } else if (tempType == 44) {
                    govdocBodyType = MainbodyType.WpsExcel.name();
                } else if (tempType == 45) {
                    govdocBodyType = MainbodyType.Pdf.name();
                } else if (tempType == 46) {
                    govdocBodyType = MainbodyType.Ofd.name();
                } else {
                    govdocBodyType = MainbodyType.OfficeWord.name();
                }

                modelAndView.addObject("govdocBodyType", govdocBodyType);
                modelAndView.addObject("govdocContentCreateTime", ctpContentAll.getCreateDate());
                modelAndView.addObject("govdocContentObj", ctpContentAll);
                if (Strings.isNotBlank(ctpContentAll.getContent()) && govdocBodyType != MainbodyType.HTML.name()) {
                    V3XFile v3xFile = this.fileManager.getV3XFile(Long.parseLong(ctpContentAll.getContent()));
                    if (v3xFile != null) {
                        modelAndView.addObject("myContentNameId", v3xFile.getFilename());
                    }
                }

                if ((ctpContentAll.getContentType() == 43 || ctpContentAll.getContentType() == 41) && "-1".equals(ctpContentAll.getContent())) {
                    modelAndView.addObject("contentT", "-1");
                } else {
                    modelAndView.addObject("contentT", "0");
                    if (vobj.getSummaryId() != null && "waitSend".equals(from) && vobj.getTempleteId() != null) {
                        contentAll = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.valueOf(vobj.getTempleteId()));
                        if (contentAll != null && contentAll.getContent() != null && contentAll.getContent().equals("-1")) {
                            modelAndView.addObject("contentT", "-1");
                        } else {
                            modelAndView.addObject("contentT", "0");
                        }
                    }
                }

                cloneOriginalAtts = Strings.isNotBlank(templateId) || Strings.isNotBlank(meetingSummaryId);
                modelAndView.addObject("cloneOriginalAtts", cloneOriginalAtts);
            }
        }

        String _trackValue;
        if (context != null) {
            context.setWfProcessId(vobj.getSummary().getProcessId());
            context.setWfCaseId(vobj.getCaseId() == null ? -1L : vobj.getCaseId());
            String xml = "";
            boolean isSpecialSteped = vobj.getAffair() != null && vobj.getAffair().getSubState() == SubStateEnum.col_pending_specialBacked.key();
            if (vobj.getTemplate() != null && vobj.getTemplate().getWorkflowId() != null && !isSpecialSteped && !"resend".equals(from)) {
                context.setWfProcessId(String.valueOf(vobj.getTemplate().getWorkflowId()));
                if (!TemplateUtil.isSystemTemplate(vobj.getTemplate().getId())) {
                    xml = this.wapi.selectWrokFlowTemplateXml(vobj.getTemplate().getWorkflowId().toString());
                    modelAndView.addObject("ordinalTemplateIsSys", "no");
                }
            } else if (Strings.isNotBlank(vobj.getSummary().getProcessId())) {
                xml = this.wapi.selectWrokFlowXml(vobj.getProcessId());
            }

            _trackValue = this.wapi.getWorkflowNodesInfo(context.getWfProcessId(), ModuleType.collaboration.name(), PermissionUtil.getCtpEnumBySubApp(sub_app));
            if ("true".equals(isQuickSend)) {
                xml = "<ps><p s=\"false\" u=\"\" y=\"0\" x=\"0\" t=\"p\" d=\"\" n=\"\" i=\"\"><n f=\"\" g=\"\" h=\"\" y=\"50\" x=\"50\" t=\"8\" d=\"\" n=\"发起者\" i=\"start\"><a a=\"\" b=\"\" c=\"1\" d=\"\" e=\"\" f=\"\" g=\"\" h=\"false\" i=\"false\" j=\"false\" k=\"\" /><s sa=\"0\" a=\"\" b=\"0\" c=\"1\" z=\"\" r=\"-4517940104153840768\" e=\"-4932805465266960787\" f=\"-4053283448206113490\" g=\"0\" na=\"-1\" w=\"-1\" v=\"-1\" sid=\"\" qid=\"\" h=\"-1\" u=\"-1\" tm=\"1\" j=\"single\" k=\"\" l=\"\" m=\"false\" s=\"success\" o=\"\" p=\"\" q=\"\" d=\"\" t=\"\" n=\"审批\" i=\"shenpi\" /></n><n f=\"\" g=\"\" h=\"\" y=\"50\" x=\"260\" t=\"4\" d=\"\" n=\"end\" i=\"end\"><a a=\"\" b=\"\" c=\"1\" d=\"\" e=\"\" f=\"\" g=\"\" h=\"false\" i=\"false\" j=\"false\" k=\"\" /><s sa=\"0\" a=\"\" b=\"0\" c=\"1\" z=\"\" r=\"-5191080912759471674\" e=\"-4932805465266960787\" f=\"-4053283448206113490\" g=\"0\" na=\"-1\" w=\"-1\" v=\"-1\" sid=\"\" qid=\"\" h=\"-1\" u=\"-1\" tm=\"1\" j=\"single\" k=\"\" l=\"\" m=\"false\" s=\"success\" o=\"\" p=\"\" q=\"\" d=\"\" t=\"\" n=\"审批\" i=\"shenpi\" /></n><n a=\"1\" b=\"normal\" c=\"false\" l=\"1000\" e=\"0\" f=\"\" g=\"\" h=\"\" y=\"50\" x=\"155\" t=\"6\" d=\"\" n=\"空节点\" i=\"14576665144001\"><a a=\"\" b=\"-2132261314804494831\" c=\"1\" d=\"空节点\" e=\"\" f=\"BlankNode\" g=\"Node\" h=\"false\" i=\"false\" j=\"false\" k=\"roleadmin\" /><s sa=\"0\" a=\"\" b=\"0\" c=\"1\" z=\"\" r=\"-5191080912759471674\" e=\"-4932805465266960787\" f=\"-4053283448206113490\" g=\"0\" na=\"-1\" w=\"-1\" v=\"-1\" sid=\"\" qid=\"\" h=\"-1\" u=\"-1\" tm=\"1\" j=\"single\" k=\"\" l=\"\" m=\"false\" s=\"success\" o=\"\" p=\"\" q=\"\" d=\"\" t=\"\" n=\"知会\" i=\"inform\" /></n><l a=\"\" b=\"\" c=\"\" m=\"\" e=\"\" h=\"3\" o=\"0\" j=\"end\" k=\"14576665144001\" t=\"11\" d=\"\" n=\"\" i=\"14576665082920\" /><l a=\"\" b=\"\" c=\"\" m=\"\" e=\"\" h=\"3\" o=\"0\" j=\"14576665144001\" k=\"start\" t=\"11\" d=\"\" n=\"\" i=\"14576665144002\" /></p></ps>";
                _trackValue = "快速发文流程";
            }

            context.setWorkflowNodesInfo(_trackValue);
            vobj.setWfXMLInfo(Strings.escapeJavascript(xml));
            modelAndView.addObject("contentContext", context);
        }

        if (vobj.getTemplate() != null && !Type.text.name().equals(vobj.getTemplate().getType())) {
            modelAndView.addObject("onlyViewWF", true);
        }

        if ("true".equals(isQuickSend)) {
            modelAndView.addObject("onlyViewWF", true);
            modelAndView.addObject("process_xml", "<ps><p s=\"false\" u=\"\" y=\"0\" x=\"0\" t=\"p\" d=\"\" n=\"\" i=\"\"><n f=\"\" g=\"\" h=\"\" y=\"50\" x=\"50\" t=\"8\" d=\"\" n=\"发起者\" i=\"start\"><a a=\"\" b=\"\" c=\"1\" d=\"\" e=\"\" f=\"\" g=\"\" h=\"false\" i=\"false\" j=\"false\" k=\"\" /><s sa=\"0\" a=\"\" b=\"0\" c=\"1\" z=\"\" r=\"-4517940104153840768\" e=\"-4932805465266960787\" f=\"-4053283448206113490\" g=\"0\" na=\"-1\" w=\"-1\" v=\"-1\" sid=\"\" qid=\"\" h=\"-1\" u=\"-1\" tm=\"1\" j=\"single\" k=\"\" l=\"\" m=\"false\" s=\"success\" o=\"\" p=\"\" q=\"\" d=\"\" t=\"\" n=\"审批\" i=\"shenpi\" /></n><n f=\"\" g=\"\" h=\"\" y=\"50\" x=\"260\" t=\"4\" d=\"\" n=\"end\" i=\"end\"><a a=\"\" b=\"\" c=\"1\" d=\"\" e=\"\" f=\"\" g=\"\" h=\"false\" i=\"false\" j=\"false\" k=\"\" /><s sa=\"0\" a=\"\" b=\"0\" c=\"1\" z=\"\" r=\"-5191080912759471674\" e=\"-4932805465266960787\" f=\"-4053283448206113490\" g=\"0\" na=\"-1\" w=\"-1\" v=\"-1\" sid=\"\" qid=\"\" h=\"-1\" u=\"-1\" tm=\"1\" j=\"single\" k=\"\" l=\"\" m=\"false\" s=\"success\" o=\"\" p=\"\" q=\"\" d=\"\" t=\"\" n=\"审批\" i=\"shenpi\" /></n><n a=\"1\" b=\"normal\" c=\"false\" l=\"1000\" e=\"0\" f=\"\" g=\"\" h=\"\" y=\"50\" x=\"155\" t=\"6\" d=\"\" n=\"空节点\" i=\"14576665144001\"><a a=\"\" b=\"-2132261314804494831\" c=\"1\" d=\"空节点\" e=\"\" f=\"BlankNode\" g=\"Node\" h=\"false\" i=\"false\" j=\"false\" k=\"roleadmin\" /><s sa=\"0\" a=\"\" b=\"0\" c=\"1\" z=\"\" r=\"-5191080912759471674\" e=\"-4932805465266960787\" f=\"-4053283448206113490\" g=\"0\" na=\"-1\" w=\"-1\" v=\"-1\" sid=\"\" qid=\"\" h=\"-1\" u=\"-1\" tm=\"1\" j=\"single\" k=\"\" l=\"\" m=\"false\" s=\"success\" o=\"\" p=\"\" q=\"\" d=\"\" t=\"\" n=\"知会\" i=\"inform\" /></n><l a=\"\" b=\"\" c=\"\" m=\"\" e=\"\" h=\"3\" o=\"0\" j=\"end\" k=\"14576665144001\" t=\"11\" d=\"\" n=\"\" i=\"14576665082920\" /><l a=\"\" b=\"\" c=\"\" m=\"\" e=\"\" h=\"3\" o=\"0\" j=\"14576665144001\" k=\"start\" t=\"11\" d=\"\" n=\"\" i=\"14576665144002\" /></p></ps>");
            List taohongList1 = EdocHelper.getEdocDocTemplate(user.getLoginAccount(), user, "edoc", "officeword");
            modelAndView.addObject("taohongList", taohongList1);
        }

        modelAndView.addObject("postName", Functions.showOrgPostName(user.getPostId()));
        V3xOrgDepartment department = Functions.getDepartment(user.getDepartmentId());
        if (department != null) {
            modelAndView.addObject("departName", Functions.getDepartment(user.getDepartmentId()).getName());
        }

        modelAndView.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
        AppContext.putRequestContext("moduleId", vobj.getSummaryId());
        AppContext.putRequestContext("canDeleteISigntureHtml", true);
        if (vobj.getSummary().getDeadlineDatetime() != null) {
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            vobj.setDeadLineDateTimeHidden(sf.format(vobj.getSummary().getDeadlineDatetime()));
        }

        formAppId = request.getParameter("formAppId");
        if (vobj.getSummary().getFormAppid() == null && Strings.isNotBlank(formAppId)) {
            vobj.getSummary().setFormAppid(Long.valueOf(formAppId));
        }

        if (vobj.getSummary().getOrgAccountId() == null) {
            vobj.getSummary().setOrgAccountId(AppContext.currentAccountId());
        }

        modelAndView.addObject("vobj", vobj);
        modelAndView.addObject("canEditColPigeonhole", canEditColPigeonhole);
        _trackValue = this.customizeManager.getCustomizeValue(user.getId(), "track_send");
        if (Strings.isBlank(_trackValue)) {
            modelAndView.addObject("customSetTrack", "true");
        } else {
            modelAndView.addObject("customSetTrack", _trackValue);
        }

        String officeOcxUploadMaxSize = SystemProperties.getInstance().getProperty("officeFile.maxSize");
        modelAndView.addObject("officeOcxUploadMaxSize", Strings.isBlank(officeOcxUploadMaxSize) ? "8192" : officeOcxUploadMaxSize);
        Object distributeContentDataId = contentDataId == null ? request.getParameter("contentDataId") : contentDataId;
        modelAndView.addObject("distributeContentDataId", distributeContentDataId);
        boolean isFenban = Strings.isNotBlank(request.getParameter("isFenban")) && !"null".equals(request.getParameter("isFenban")) || !isWaitSend && distributeContentDataId != null && StringUtils.isNotBlank(distributeContentDataId.toString()) && StringUtils.isNotBlank(oldSummaryId) || isWaitSendFenban;
        modelAndView.addObject("isFenban", isFenban);
        if (isFenban) {
            modelAndView.addObject("editType", "4,0");
        } else if (Strings.isBlank(forwardText)) {
            modelAndView.addObject("editType", "1,0");
        } else {
            String[] result = forwardText.split("\\.");
            if (result[0].equals("0")) {
                modelAndView.addObject("editType", "4,0");
                modelAndView.addObject("forwardFawen", "true");
            } else {
                modelAndView.addObject("editType", "1,0");
            }
        }

        modelAndView.addObject("distributeContentTemplateId", contentTemplateId == null ? request.getParameter("contentTemplateId") : contentTemplateId);
        modelAndView.addObject("distributeAffairId", request.getParameter("distributeAffairId"));
        modelAndView.addObject("oldSummaryId", oldSummaryId);
        if (AppContext.hasPlugin("supervision") && this.supervisionManager != null) {
            modelAndView.addObject("supervisionFormId", this.supervisionManager.getSupervisionAFormId());
            forwardAffairId = request.getParameter("supType");
            if (StringUtils.isNotBlank(forwardAffairId)) {
                govdocBodyType = request.getParameter("operType");
                modelAndView.addObject("operType", govdocBodyType);
                modelAndView.addObject("supType", forwardAffairId);
                SupervisionManager supervisionManager = (SupervisionManager)AppContext.getBean("supervisionManager");
                String masterDataId = request.getParameter("masterDataId");
                long supervisionDataId = StringUtils.isNotBlank(masterDataId) ? Long.valueOf(masterDataId) : -1L;
                String json = supervisionManager.getRelationData(supervisionDataId, govdocBodyType);
                modelAndView.addObject("relationJson", json);
                modelAndView.addObject("relationField", request.getParameter("relationField"));
            }
        }

        return modelAndView;
    }

    private ContentViewRet setWorkflowParam(HttpServletRequest request, Long moduleId, ModuleType moduleType) throws BusinessException {
        ContentViewRet context = new ContentViewRet();
        context.setModuleId(moduleId);
        String sub_app = ReqUtil.getString(request, "sub_app", "collaboration");
        context.setModuleType(PermissionFatory.getPermBySubApp(sub_app).getModuleType());
        context.setCommentMaxPath("00");
        return context;
    }

    private void getTrackInfo(ModelAndView modelAndView, NewCollTranVO vobj, String smmaryId) throws BusinessException {
        CtpAffair affairSent = this.affairManager.getSenderAffair(Long.valueOf(smmaryId));
        if ("waitSend".equals(vobj.getFrom()) && Strings.isNotBlank(vobj.getAffairId()) && !"null".equals(vobj.getAffairId())) {
            affairSent = this.affairManager.get(Long.valueOf(vobj.getAffairId()));
        }

        if (affairSent != null) {
            Integer trackType = affairSent.getTrack();
            modelAndView.addObject("trackType", trackType);
            List<CtpTrackMember> tList = this.trackManager.getTrackLisByAffairId(affairSent.getId());
            String trackNames = "";
            StringBuffer trackIds = new StringBuffer();
            if (tList.size() > 0) {
                Iterator var10 = tList.iterator();

                while(var10.hasNext()) {
                    CtpTrackMember ctpT = (CtpTrackMember)var10.next();
                    trackNames = trackNames + "Member|" + ctpT.getTrackMemberId() + ",";
                    trackIds.append(ctpT.getTrackMemberId() + ",");
                }

                if (trackNames.length() > 0) {
                    vobj.setForGZShow(trackNames.substring(0, trackNames.length() - 1));
                    modelAndView.addObject("forGZIds", trackIds.substring(0, trackIds.length() - 1));
                }
            }
        }

    }

    public ModelAndView newCollForH5(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/newCollaborationForH5");
        User user = AppContext.getCurrentUser();
        NewCollTranVO vobj = new NewCollTranVO();
        vobj.setCreateDate(new Date());
        String from = request.getParameter("from");
        String s_summaryId = request.getParameter("summaryId");
        String templateId = request.getParameter("templateId");
        String projectID = request.getParameter("projectId");
        boolean relateProjectFlag = false;
        if (Strings.isNotBlank(projectID)) {
            relateProjectFlag = true;
        }

        String affairId = request.getParameter("affairId");
        ColSummary summary = null;
        boolean canEditColPigeonhole = true;
        CtpTemplate template = null;
        vobj.setFrom(from);
        vobj.setSummaryId(Strings.isBlank(s_summaryId) ? String.valueOf(UUIDUtil.getUUIDLong()) : s_summaryId);
        vobj.setTempleteId(templateId);
        vobj.setProjectId(Strings.isNotBlank(projectID) ? Long.parseLong(projectID) : null);
        vobj.setAffairId(affairId);
        vobj.setUser(user);
        vobj.setCanDeleteOriginalAtts(true);
        vobj.setCloneOriginalAtts(false);
        vobj.setArchiveName("");
        vobj.setNewBusiness("1");
        Long originalContentId;
        ColSummary fromToSummary;
        Long referenceId;
        String _trackValue;
        if (Strings.isNotBlank(templateId)) {
            vobj.setSummaryId(String.valueOf(UUIDUtil.getUUIDLong()));

            try {
                boolean isEnable = this.templateManager.checkTemplateEnabel(templateId);
                if (!isEnable) {
                    if ("templateNewColl".equals(from)) {
                        this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                    } else {
                        PrintWriter out = response.getWriter();
                        out.println("<script>");
                        out.println("alert('模板已经被删除，或者您已经没有该模板的使用权限');");
                        out.print("parent.window.close();");
                        out.println("</script>");
                        out.flush();
                    }
                }

                vobj = this.colManager.transferTemplate(vobj);
                template = vobj.getTemplate();
                modelAndView.addObject("zwContentType", template.getBodyType());
            } catch (Exception var23) {
                LOGGER.info("", var23);
                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                return null;
            }

            if (vobj == null) {
                this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                return null;
            }

            canEditColPigeonhole = vobj.isCanEditColPigeonhole();
        } else if ("resend".equals(from)) {
            vobj = this.colManager.transResend(vobj);
            vobj.setSummaryId(String.valueOf(UUIDLong.longUUID()));
            modelAndView.addObject("parentSummaryId", vobj.getSummary().getId());
            referenceId = vobj.getSummary().getId();
            ColSummary parentSummary = this.colManager.getSummaryById(referenceId);
            vobj.getSummary().setId(Long.valueOf(vobj.getSummaryId()));
            originalContentId = parentSummary.getTempleteId();
            CtpTemplate ctpTemplate = null;
            if (originalContentId != null) {
                ctpTemplate = this.templateManager.getCtpTemplate(originalContentId);
                if (ctpTemplate != null) {
                    fromToSummary = (ColSummary)XMLCoder.decoder(ctpTemplate.getSummary());
                    vobj.setTempleteHasDeadline(fromToSummary.getDeadline() != null && fromToSummary.getDeadline() != 0L);
                    vobj.setTempleteHasRemind(fromToSummary.getAdvanceRemind() != null && fromToSummary.getAdvanceRemind() != 0L && fromToSummary.getAdvanceRemind() != -1L);
                    vobj.setCanEditColPigeonhole(fromToSummary.getArchiveId() != null);
                    vobj.setParentWrokFlowTemplete(this.colManager.isParentWrokFlowTemplete(ctpTemplate.getFormParentid()));
                    vobj.setParentTextTemplete(this.colManager.isParentTextTemplete(ctpTemplate.getFormParentid()));
                    vobj.setParentColTemplete(this.colManager.isParentColTemplete(ctpTemplate.getFormParentid()));
                    vobj.setFromSystemTemplete(ctpTemplate.isSystem());
                }
            }

            this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
            modelAndView.addObject("isResend", "1");
        } else {
            String _formTitleText;
            if (vobj.getSummaryId() != null && "waitSend".equals(from)) {
                vobj.setNewBusiness("0");

                try {
                    if (Strings.isNotBlank(affairId)) {
                        CtpAffair valAffair = this.affairManager.get(Long.valueOf(affairId));
                        if (valAffair != null && !valAffair.getMemberId().equals(user.getId())) {
                            this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("您无权查看该主题!"));
                            return null;
                        }
                    }

                    vobj = this.colManager.transComeFromWaitSend(vobj);
                    template = vobj.getTemplate();
                    this.getTrackInfo(modelAndView, vobj, vobj.getSummaryId());
                } catch (BPMException var24) {
                    this.newCollAlert(response, StringEscapeUtils.escapeJavaScript("模板已经被删除，或者您已经没有该模板的使用权限"));
                    return null;
                }

                String subState = ReqUtil.getString(request, "subState", "");
                modelAndView.addObject("subState", subState);
                canEditColPigeonhole = vobj.isCanEditColPigeonhole();
                modelAndView.addObject("alertSuperviseSet", true);
                _formTitleText = request.getParameter("formTitleText");
                if (Strings.isNotBlank(_formTitleText)) {
                    String _stiitle = URLDecoder.decode(_formTitleText, "UTF-8");
                    modelAndView.addObject("_formTitleText", _stiitle);
                    vobj.setCollSubject(_stiitle);
                    if (vobj.getSummary() != null) {
                        vobj.getSummary().setSubject(_stiitle);
                    }
                }

                if ("bizconfig".equals(request.getParameter("reqFrom"))) {
                    vobj.setFrom("bizconfig");
                }
            } else if ("relatePeople".equals(from)) {
                vobj.setNewBusiness("1");
                V3xOrgMember sender = null;
                _formTitleText = request.getParameter("memberId");
                if (_formTitleText != null) {
                    sender = this.orgManager.getMemberById(Long.valueOf(_formTitleText));
                    V3xOrgAccount account = this.orgManager.getAccountById(sender.getOrgAccountId());
                    modelAndView.addObject("accountObj", account);
                    modelAndView.addObject("isSameAccount", String.valueOf(sender.getOrgAccountId().equals(user.getLoginAccount())));
                }

                modelAndView.addObject("peopeleCardInfo", sender);
            } else if ("a8genius".equals(from)) {
                referenceId = UUIDLong.longUUID();
                String[] attachids = request.getParameterValues("attachid");
                if (attachids != null && attachids.length > 0) {
                    Long[] attId = new Long[attachids.length];

                    for(int count = 0; count < attachids.length; ++count) {
                        attId[count] = Long.valueOf(attachids[count]);
                    }

                    if (attId.length > 0) {
                        this.attachmentManager.create(attId, ApplicationCategoryEnum.collaboration, referenceId, referenceId);
                        _trackValue = this.attachmentManager.getAttListJSON(referenceId);
                        vobj.setAttListJSON(_trackValue);
                    }
                }

                modelAndView.addObject("source", request.getParameter("source"));
                modelAndView.addObject("from", from);
                modelAndView.addObject("referenceId", referenceId);
            }
        }

        if (vobj.getSummary() == null) {
            summary = new ColSummary();
            vobj.setSummary(summary);
            summary.setCanForward(true);
            summary.setCanArchive(true);
            summary.setCanDueReminder(true);
            summary.setCanEditAttachment(true);
            summary.setCanModify(true);
            summary.setCanTrack(true);
            summary.setCanEdit(true);
            summary.setAdvanceRemind(-1L);
        }

        if (vobj.isParentColTemplete() && vobj.getTemplate() != null && vobj.getTemplate().getProjectId() != null) {
            modelAndView.addObject("disabledProjectId", "1");
        }

        if (!relateProjectFlag) {
            referenceId = vobj.getSummary().getProjectId();
            vobj.setProjectId(referenceId);
        }

        ContentConfig _config = ContentConfig.getConfig(ModuleType.collaboration);
        modelAndView.addObject("contentCfg", _config);
        ContentViewRet context;
        if (s_summaryId == null && Strings.isBlank(templateId) || Strings.isNotBlank(templateId) && Type.workflow.name().equals(template.getType())) {
            context = this.setWorkflowParam(request, (Long)null, ModuleType.collaboration);
        } else {
            originalContentId = null;
            _trackValue = null;
            if (s_summaryId != null) {
                originalContentId = Long.parseLong(s_summaryId);
            } else if (Strings.isNotBlank(templateId)) {
                originalContentId = Long.valueOf(templateId);
            }

            if (template != null && MainbodyType.FORM.getKey() == Integer.parseInt(template.getBodyType())) {
                _trackValue = this.wapi.getNodeFormViewAndOperationName(template.getWorkflowId(), (String)null);
            }

            fromToSummary = vobj.getSummary();
            int viewState = 1;
            if (fromToSummary.getParentformSummaryid() != null && !fromToSummary.getCanEdit()) {
                viewState = 2;
            }

            modelAndView.addObject("contentViewState", Integer.valueOf(viewState));
            modelAndView.addObject("uuidlong", UUIDLong.longUUID());
            modelAndView.addObject("zwModuleId", originalContentId);
            modelAndView.addObject("zwRightId", _trackValue);
            modelAndView.addObject("zwIsnew", "false");
            modelAndView.addObject("zwViewState", Integer.valueOf(viewState));
            context = this.setWorkflowParam(request, originalContentId, ModuleType.collaboration);
            ContentUtil.commentView(request, _config, ModuleType.collaboration, originalContentId, (Long)null);
        }

        if (context != null) {
            context.setWfProcessId(vobj.getSummary().getProcessId());
            context.setWfCaseId(vobj.getCaseId() == null ? -1L : vobj.getCaseId());
            EnumManager em = (EnumManager)AppContext.getBean("enumManager");
            Map ems = em.getEnumsMap(ApplicationCategoryEnum.collaboration);
            CtpEnum nodePermissionPolicy = (CtpEnum)ems.get(EnumNameEnum.col_flow_perm_policy.name());
            String xml = "";
            boolean isSpecialSteped = vobj.getAffair() != null && vobj.getAffair().getSubState() == SubStateEnum.col_pending_specialBacked.key();
            if (vobj.getTemplate() != null && vobj.getTemplate().getWorkflowId() != null && !isSpecialSteped && !"resend".equals(from)) {
                context.setWfProcessId(String.valueOf(vobj.getTemplate().getWorkflowId()));
                if (!TemplateUtil.isSystemTemplate(vobj.getTemplate().getId())) {
                    xml = this.wapi.selectWrokFlowTemplateXml(vobj.getTemplate().getWorkflowId().toString());
                    modelAndView.addObject("ordinalTemplateIsSys", "no");
                }
            } else if (Strings.isNotBlank(vobj.getSummary().getProcessId())) {
                xml = this.wapi.selectWrokFlowXml(vobj.getProcessId());
            }

            String workflowNodesInfo = this.wapi.getWorkflowNodesInfo(context.getWfProcessId(), ModuleType.collaboration.name(), nodePermissionPolicy);
            context.setWorkflowNodesInfo(workflowNodesInfo);
            vobj.setWfXMLInfo(Strings.escapeJavascript(xml));
            modelAndView.addObject("contentContext", context);
        }

        if (vobj.getTemplate() != null && !Type.text.name().equals(vobj.getTemplate().getType())) {
            modelAndView.addObject("onlyViewWF", true);
        }

        modelAndView.addObject("postName", Functions.showOrgPostName(user.getPostId()));
        V3xOrgDepartment department = Functions.getDepartment(user.getDepartmentId());
        if (department != null) {
            modelAndView.addObject("departName", Functions.getDepartment(user.getDepartmentId()).getName());
        }

        modelAndView.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
        AppContext.putRequestContext("moduleId", vobj.getSummaryId());
        AppContext.putRequestContext("canDeleteISigntureHtml", true);
        if (vobj.getSummary().getDeadlineDatetime() != null) {
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            vobj.setDeadLineDateTimeHidden(sf.format(vobj.getSummary().getDeadlineDatetime()));
        }

        modelAndView.addObject("vobj", vobj);
        modelAndView.addObject("canEditColPigeonhole", canEditColPigeonhole);
        _trackValue = this.customizeManager.getCustomizeValue(user.getId(), "track_send");
        if (Strings.isBlank(_trackValue)) {
            modelAndView.addObject("customSetTrack", "true");
        } else {
            modelAndView.addObject("customSetTrack", _trackValue);
        }

        String officeOcxUploadMaxSize = SystemProperties.getInstance().getProperty("officeFile.maxSize");
        modelAndView.addObject("officeOcxUploadMaxSize", Strings.isBlank(officeOcxUploadMaxSize) ? "8192" : officeOcxUploadMaxSize);
        return modelAndView;
    }

    public ModelAndView checkFile(HttpServletRequest request, HttpServletResponse response) throws IOException, BusinessException {
        String userId = request.getParameter("userId");
        String docId = request.getParameter("docId");
        String isBorrow = request.getParameter("isBorrow");
        String vForDocDownload = request.getParameter("v");
        String result = null;
        String context = SystemEnvironment.getContextPath();
        V3XFile vf = this.fileManager.getV3XFile(Long.valueOf(docId));
        result = "0#" + context + "/fileDownload.do?method=doDownload&viewMode=download&fileId=" + vf.getId() + "&filename=" + URLEncoder.encode(vf.getFilename(), "UTF-8") + "&createDate=" + Datetimes.formatDate(vf.getCreateDate()) + "&v=" + vForDocDownload;
        PrintWriter out = response.getWriter();
        out.print(result);
        out.close();
        return null;
    }

    private void newCollAlert(HttpServletResponse response, String msg) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('" + msg + "');");
        out.print("parent.window.close();");
        out.print("parent.window.history.back();");
        out.println("</script>");
        out.flush();
    }

    private void getProjectInfo(HttpServletRequest request, ModelAndView modelAndView, NewCollTranVO vobj, String from) throws BusinessException {
        Long projectId = vobj.getSummary().getProjectId();
        if ("relateProject".equals(from)) {
            String projectIdStr = request.getParameter("projectId");
            projectId = Long.parseLong(projectIdStr);
            modelAndView.addObject("projectPhaseId", request.getParameter("phaseId"));
        }

        List<ProjectSummary> projectList = this.projectManager.getIndexProjectListOnly(AppContext.currentUserId(), -1);
        projectList = projectList == null ? new ArrayList() : projectList;
        if (projectId != null) {
            ProjectSummary ps = this.projectManager.getProject(projectId);
            if (ps != null && !ProjectSummary.state_close.equals(ps.getProjectState()) && !((List)projectList).contains(ps)) {
                ((List)projectList).add(ps);
            }

            vobj.setProjectId(projectId);
        }

        for(int i = ((List)projectList).size() - 1; i > -1; --i) {
            ProjectSummary ps = (ProjectSummary)((List)projectList).get(i);
            if (ProjectSummary.state_close.equals(ps.getProjectState())) {
                ((List)projectList).remove(i);
            }
        }

        vobj.setProjectList((List)projectList);
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    private void addCommentWhenFenban(String signAndDistribute, String isDistribute, ColSummary summary) throws BusinessException {
        if (Strings.isNotBlank(signAndDistribute) || Strings.isNotBlank(isDistribute)) {
            Comment comment = AppContext.getSessionContext("comment") == null ? null : (Comment)AppContext.getSessionContext("comment");
            if (comment != null) {
                if (comment.getId() != null) {
                    this.commentManager = (CommentManager)AppContext.getBean("ctpCommentManager");
                    CtpCommentAll c = this.commentManager.getDrfatComment(comment.getAffairId());
                    if (c != null) {
                        this.commentManager.deleteComment(ModuleType.collaboration, c.getId());
                        this.attachmentManager.deleteByReference(summary.getId(), c.getId());
                    }
                }

                CommentManager commentManager = (CommentManager)AppContext.getBean("ctpCommentManager");
                comment.setPushMessage(false);
                comment.setId(UUIDLong.longUUID());
                commentManager.insertComment(comment, this.affairManager.get(comment.getAffairId()));
                CollaborationAddCommentEvent commentEvent = new CollaborationAddCommentEvent(this);
                commentEvent.setCommentId(comment.getId());
                EventDispatcher.fireEvent(commentEvent);
            }
        }

    }

    public ModelAndView saveDraft(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ColInfo info = new ColInfo();
        User user = AppContext.getCurrentUser();
        Map para = ParamUtil.getJsonDomain("colMainData");
        ColSummary summary = (ColSummary)ParamUtil.mapToBean(para, new ColSummary(), false);
        String selectProjectId = ParamUtil.getString(para, "selectProjectId", "-1");
        if ("-1".equals(selectProjectId)) {
            summary.setProjectId((Long)null);
        } else {
            summary.setProjectId(Long.valueOf(selectProjectId));
        }

        String app = ParamUtil.getString(para, "app");
        if (Strings.isNotBlank(app)) {
            summary.setGovdocType(ParamUtil.getInt(para, "sub_app"));
        }

        if (para.get("jianbanType") != null && !"".equals(para.get("jianbanType"))) {
            summary.setJianbanType(ParamUtil.getInt(para, "jianbanType"));
        }

        Map para1 = ParamUtil.getJsonDomain("senderOpinion");
        boolean saveProcessFlag = true;
        if (Strings.isNotBlank((String)para.get("tId"))) {
            Long templateIdLong = new Long((String)para.get("tId"));
            info.settId(templateIdLong);
            CtpTemplate ct = this.templateManager.getCtpTemplate(templateIdLong);
            if (!"text".equals(ct.getType())) {
                saveProcessFlag = false;
            }
        }

        if (Strings.isNotBlank((String)para.get("curTemId"))) {
            info.setCurTemId(Long.valueOf((String)para.get("curTemId")));
        }

        String isNewBusiness = (String)para.get("newBusiness");
        info.setNewBusiness("1".equals(isNewBusiness));
        info.setSummary(summary);
        info.setCurrentUser(user);
        info.setGovdocContent(para.get("govdocContent") == null ? null : para.get("govdocContent").toString());
        info.setGovdocContentType(para.get("govdocContentType") == null ? null : Integer.parseInt(para.get("govdocContentType").toString()));
        Object canTrack = para.get("canTrack");
        int track = 0;
        if (canTrack != null) {
            track = 1;
            if (para.get("radiopart") != null) {
                track = 2;
            }

            info.getSummary().setCanTrack(true);
        } else {
            info.getSummary().setCanTrack(false);
        }

        info.setTrackType(track);
        String trackMemberId = (String)para.get("zdgzry");
        info.setTrackMemberId(trackMemberId);
        String contentSaveId = (String)para.get("contentSaveId");
        info.setContentSaveId(contentSaveId);
        Map map = this.colManager.saveDraft(info, saveProcessFlag, para);
        String forwardAffairId = ParamUtil.getString(para, "forwardAffairId");
        String govdocRelation1 = ParamUtil.getString(para, "govdocRelation1");
        String govdocRelation2 = ParamUtil.getString(para, "govdocRelation2");
        if (Strings.isNotBlank(forwardAffairId) && Strings.isNotBlank(govdocRelation1) || Strings.isNotBlank(govdocRelation2)) {
            CtpAffair affair = this.affairManager.get(Long.valueOf(forwardAffairId));
            if (govdocRelation1.equals("true")) {
                ColSummary srcSummary = this.colManager.getSummaryById(affair.getObjectId());
                V3xOrgUnit unit = this.orgManager.getUnitById(srcSummary.getOrgAccountId());
                GovDocUtil.createGovdocRelation(summary.getId(), affair.getSubject(), affair.getObjectId(), affair.getSubApp(), 1, unit.getId(), unit.getName());
            }

            if (govdocRelation2.equals("true")) {
                GovDocUtil.createGovdocRelation(affair.getObjectId(), summary.getSubject(), summary.getId(), summary.getGovdocType(), 1, AppContext.currentAccountId(), AppContext.currentAccountName());
            }
        }

        String distributeAffairId = request.getParameter("distributeAffairId");
        String oldSummaryId;
        if (Strings.isNotBlank(distributeAffairId)) {
            oldSummaryId = ParamUtil.getString(para, "signAndDistribute");
            String isDistribute = ParamUtil.getString(para, "isDistribute");
            this.addCommentWhenFenban(oldSummaryId, isDistribute, summary);
            this.finishWorkItem(request, response);
            String _affairId = request.getParameter("affairId");
            if (Strings.isBlank(_affairId) && Strings.isNotBlank(distributeAffairId)) {
                _affairId = distributeAffairId;
            }

            Long affairId = Strings.isBlank(_affairId) ? 0L : Long.parseLong(_affairId);
            CtpAffair affair = this.affairManager.get(affairId);
            List<GovdocExchangeDetail> govdocExchangeDetails = this.govdocExchangeManager.findDetailBySummaryId(affair.getObjectId());
            if (govdocExchangeDetails != null) {
                GovDocUtil.createGovdocRelation(affair.getObjectId(), summary.getSubject(), summary.getId(), summary.getGovdocType(), 0, AppContext.currentAccountId(), AppContext.currentAccountName());
                ColSummary srcSummary = this.colManager.getSummaryById(affair.getObjectId());
                V3xOrgUnit unit = this.orgManager.getUnitById(srcSummary.getOrgAccountId());
                GovDocUtil.createGovdocRelation(summary.getId(), affair.getSubject(), affair.getObjectId(), affair.getSubApp(), 0, unit.getId(), unit.getName());
                Iterator var30 = govdocExchangeDetails.iterator();

                while(var30.hasNext()) {
                    GovdocExchangeDetail govdocExchangeDetail = (GovdocExchangeDetail)var30.next();
                    GovDocUtil.setStatusIsFenban(this.govdocExchangeManager, govdocExchangeDetail);
                }
            }
        }

        try {
            super.rendJavaScript(response, "parent.endSaveDraft('" + map.get("summaryId").toString() + "','" + map.get("contentId").toString() + "','" + map.get("affairId").toString() + "','" + para.get("tId") + "','" + para.get("isFenban") + "')");
        } catch (Exception var31) {
            this.logger.error("调用js报错！", var31);
        }

        oldSummaryId = ParamUtil.getString(para, "oldSummaryId");
        if (Strings.isBlank(oldSummaryId)) {
            oldSummaryId = request.getParameter("oldSummaryId");
        }

        if (Strings.isNotBlank(oldSummaryId)) {
            GovdocExchangeDetail detail = (GovdocExchangeDetail)this.govdocExchangeManager.findDetailBySummaryId(Long.valueOf(oldSummaryId)).get(0);
            detail.setRecSummaryId(summary.getId());
            this.govdocExchangeManager.updateDetail(detail);
        }

        return null;
    }

    public ModelAndView send(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!this.checkHttpParamValid(request, response)) {
            return null;
        } else {
            Map para = ParamUtil.getJsonDomain("colMainData");
            User user = AppContext.getCurrentUser();
            ColSummary summary = (ColSummary)ParamUtil.mapToBean(para, new ColSummary(), false);
            String sub_app = ParamUtil.getString(para, "sub_app");
            String app = ParamUtil.getString(para, "app");
            if (Strings.isNotBlank(sub_app)) {
                summary.setGovdocType(Integer.valueOf(sub_app));
            }

            String secretLevel = (String)para.get("secretLevel");
            if (Strings.isNotBlank(secretLevel)) {
                summary.setSecretLevel(Integer.parseInt(secretLevel));
            } else {
                summary.setSecretLevel((Integer)null);
            }

            if (para.get("jianbanType") != null && !"".equals(para.get("jianbanType"))) {
                summary.setJianbanType(ParamUtil.getInt(para, "jianbanType"));
            }

            summary.setSubject(Strings.nobreakSpaceToSpace(summary.getSubject()));
            String dls = (String)para.get("deadLineselect");
            if (Strings.isNotBlank(dls)) {
                summary.setDeadline(Long.valueOf(dls));
            }

            ColInfo info = new ColInfo();
            if (para.get("canAutostopflow") == null) {
                summary.setCanAutostopflow(false);
            }

            if (para.get("phaseId") != null && Strings.isNotBlank((String)para.get("phaseId"))) {
                info.setPhaseId((String)para.get("phaseId"));
            }

            if (Strings.isNotBlank((String)para.get("tId"))) {
                info.settId(new Long((String)para.get("tId")));
            }

            if (Strings.isNotBlank((String)para.get("curTemId"))) {
                info.setCurTemId(Long.valueOf((String)para.get("curTemId")));
            }

            if (Strings.isNotBlank((String)para.get("parentSummaryId"))) {
                summary.setParentformSummaryid(Long.valueOf((String)para.get("parentSummaryId")));
            }

            String isNewBusiness = (String)para.get("newBusiness");
            info.setNewBusiness("1".equals(isNewBusiness));
            info.setSummary(summary);
            if (AppContext.hasPlugin("index") && Strings.isNotBlank(sub_app)) {
                this.indexManager.add(summary.getId(), ApplicationCategoryEnum.govdoc.key());
            }

            SendType sendType = SendType.normal;
            info.setCurrentUser(user);
            Object canTrack = para.get("canTrack");
            int track = 0;
            if (canTrack != null) {
                track = 1;
                if (para.get("radiopart") != null) {
                    track = 2;
                }

                info.getSummary().setCanTrack(true);
            } else {
                info.getSummary().setCanTrack(false);
            }

            info.setTrackType(track);
            info.setTrackMemberId((String)para.get("zdgzry"));
            String caseId = (String)para.get("caseId");
            info.setCaseId(StringUtil.checkNull(caseId) ? null : Long.parseLong(caseId));
            String currentaffairId = (String)para.get("currentaffairId");
            info.setCurrentAffairId(StringUtil.checkNull(currentaffairId) ? null : Long.parseLong(currentaffairId));
            String currentProcessId = (String)para.get("oldProcessId");
            info.setCurrentProcessId(StringUtil.checkNull(currentProcessId) ? null : Long.parseLong(currentProcessId));
            info.setTemplateHasPigeonholePath(String.valueOf(Boolean.TRUE).equals(para.get("isTemplateHasPigeonholePath")));
            info.setGovdocContent(para.get("govdocContent") == null ? null : para.get("govdocContent").toString());
            info.setGovdocContentType(para.get("govdocContentType") == null ? null : Integer.parseInt(para.get("govdocContentType").toString()));
            if (para.get("govdocContent") != null && Strings.isNotBlank(para.get("govdocContent").toString()) && para.get("myContentNameId") != null && Strings.isNotBlank(para.get("myContentNameId").toString()) && info.getGovdocContentType() != null && 10 != info.getGovdocContentType()) {
                V3XFile file = this.fileManager.getV3XFile(Long.parseLong(para.get("govdocContent").toString()));
                if (file == null) {
                    LOGGER.info("没有获取到文件信息");
                } else {
                    file.setFilename(para.get("myContentNameId").toString());
                    this.fileManager.save(file);
                }
            }

            String distributeAffairId = request.getParameter("distributeAffairId");
            String formIdStr;
            if (Strings.isNotBlank(distributeAffairId)) {
                formIdStr = request.getParameter("affairId");
                if (Strings.isBlank(formIdStr) && Strings.isNotBlank(distributeAffairId)) {
                    ;
                }
            }

            formIdStr = ParamUtil.getString(para, "formId");
            String forwardAffairId = ParamUtil.getString(para, "forwardAffairId");
            info.getSummary().putExtraAttr("forwardAffairId", forwardAffairId);
            if (Strings.isNotBlank(formIdStr)) {
                this.colManager.transSend(info, sendType, Long.valueOf(formIdStr));
            } else {
                this.colManager.transSend(info, sendType);
            }

            String govdocRelation1 = ParamUtil.getString(para, "govdocRelation1");
            String govdocRelation2 = ParamUtil.getString(para, "govdocRelation2");
            if (Strings.isNotBlank(forwardAffairId) && Strings.isNotBlank(govdocRelation1) || Strings.isNotBlank(govdocRelation2)) {
                CtpAffair affair = this.affairManager.get(Long.valueOf(forwardAffairId));
                if (govdocRelation1.equals("true")) {
                    ColSummary srcSummary = this.colManager.getSummaryById(affair.getObjectId());
                    V3xOrgUnit unit = this.orgManager.getUnitById(srcSummary.getOrgAccountId());
                    GovDocUtil.createGovdocRelation(summary.getId(), affair.getSubject(), affair.getObjectId(), affair.getSubApp(), 1, unit.getId(), unit.getName());
                }

                if (govdocRelation2.equals("true")) {
                    GovDocUtil.createGovdocRelation(affair.getObjectId(), summary.getSubject(), summary.getId(), summary.getGovdocType(), 1, AppContext.currentAccountId(), AppContext.currentAccountName());
                }
            }

            String oldSummaryId;
            String isQuickSend;
            String quickSendUnit;
            if (Strings.isNotBlank(distributeAffairId)) {
                oldSummaryId = ParamUtil.getString(para, "signAndDistribute");
                isQuickSend = ParamUtil.getString(para, "isDistribute");
                this.addCommentWhenFenban(oldSummaryId, isQuickSend, summary);
                AppContext.getRawRequest().setAttribute("fromDistribute", true);
                this.finishWorkItem(request, response);
                quickSendUnit = request.getParameter("affairId");
                if (Strings.isBlank(quickSendUnit) && Strings.isNotBlank(distributeAffairId)) {
                    quickSendUnit = distributeAffairId;
                }

                Long affairId = Strings.isBlank(quickSendUnit) ? 0L : Long.parseLong(quickSendUnit);
                CtpAffair affair = this.affairManager.get(affairId);
                GovDocUtil.directUpdateEdocSummaryTransferStatus(summary.getId(), TransferStatus.receiveFenbanEletric);
                GovDocUtil.updateEdocSummaryTransferStatus(affair.getObjectId(), TransferStatus.receiveSignedFenban);
                List<GovdocExchangeDetail> govdocExchangeDetails = this.govdocExchangeManager.findDetailBySummaryId(affair.getObjectId());
                if (govdocExchangeDetails != null) {
                    long mainId = 0L;

                    GovdocExchangeDetail govdocExchangeDetail;
                    for(Iterator var32 = govdocExchangeDetails.iterator(); var32.hasNext(); mainId = govdocExchangeDetail.getMainId()) {
                        govdocExchangeDetail = (GovdocExchangeDetail)var32.next();
                        GovDocUtil.setStatusIsFenban(this.govdocExchangeManager, govdocExchangeDetail);
                    }
                }

                GovDocUtil.createGovdocRelation(affair.getObjectId(), summary.getSubject(), summary.getId(), summary.getGovdocType(), 0, AppContext.currentAccountId(), AppContext.currentAccountName());
                ColSummary srcSummary = this.colManager.getSummaryById(affair.getObjectId());
                V3xOrgUnit unit = this.orgManager.getUnitById(srcSummary.getOrgAccountId());
                GovDocUtil.createGovdocRelation(summary.getId(), affair.getSubject(), affair.getObjectId(), affair.getSubApp(), 0, unit.getId(), unit.getName());
            }

            oldSummaryId = ParamUtil.getString(para, "oldSummaryId");
            if (Strings.isBlank(oldSummaryId)) {
                oldSummaryId = request.getParameter("oldSummaryId");
            }

            if (Strings.isNotBlank(oldSummaryId)) {
                GovdocExchangeDetail detail = (GovdocExchangeDetail)this.govdocExchangeManager.findDetailBySummaryId(Long.valueOf(oldSummaryId)).get(0);
                detail.setRecSummaryId(summary.getId());
                this.govdocExchangeManager.updateDetail(detail);
            }

            isQuickSend = ParamUtil.getString(para, "isQuickSend");
            summary.setIsQuickSend(false);
            if ("true".equals(isQuickSend)) {
                summary.setIsQuickSend(true);
                quickSendUnit = ParamUtil.getString(para, "quickSendUnit");
                List<CtpAffair> affairsByObjectIdAndUserId = this.affairManager.getAffairsByObjectIdAndUserId(ApplicationCategoryEnum.edoc, summary.getId(), user.getId());
                if (CollectionUtils.isNotEmpty(affairsByObjectIdAndUserId)) {
                    this.exchangeGovdoc(summary, ((CtpAffair)affairsByObjectIdAndUserId.get(0)).getId(), quickSendUnit, 0, new HashMap());
                }
            }

            if ("a8genius".equals(request.getParameter("from"))) {
                super.rendJavaScript(response, "try{parent.parent.parent.closeWindow();}catch(e){window.close()}");
                return null;
            } else if (!"bizconfig".equals(request.getParameter("from")) && !"bizconfig".equals(request.getParameter("reqFrom"))) {
                Map<String, Object> lshmap = (Map)request.getAttribute("lshMap");
                StringBuffer lshsb = new StringBuffer();
                if (lshmap != null) {
                    response.setContentType("text/html;charset=UTF-8");
                    Iterator var43 = lshmap.entrySet().iterator();

                    while(var43.hasNext()) {
                        Entry entry = (Entry)var43.next();
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
                } else if (!"true".equals(para.get("isOpenWindow")) && (app == null || !String.valueOf(ApplicationCategoryEnum.edoc.getKey()).equals(app))) {
                    return this.redirectModelAndView("collaboration.do?method=listSent");
                } else {
                    super.rendJavaScript(response, "window.close();");
                    return null;
                }
            } else {
                return sub_app == null || !"1".equals(sub_app) && !"2".equals(sub_app) && !"3".equals(sub_app) ? this.redirectModelAndView("/form/business.do?method=listBizColList&srcFrom=bizconfig&from=bizconfig&templeteId=" + info.getCurTemId() + "&menuId=" + (String)para.get("bzmenuId"), "parent") : this.redirectModelAndView("/form/business.do?method=listBizEdocList&srcFrom=bizconfig&from=bizconfig&templeteId=" + info.getCurTemId() + "&menuId=" + (String)para.get("bzmenuId"), "parent");
            }
        }
    }

    public ModelAndView sendImmediate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
        String workflow_data_flag = (String)wfdef.get("workflow_data_flag");
        if (Strings.isBlank(workflow_data_flag) || "undefined".equals(workflow_data_flag.trim()) || "null".equals(workflow_data_flag.trim())) {
            this.logger.info("来自立即发送sendImmediate");
        }

        Map params = ParamUtil.getJsonParams();
        String _summaryIds = (String)params.get("summaryId");
        String _affairIds = (String)params.get("affairId");
        if (_summaryIds != null && _affairIds != null) {
            boolean sentFlag = false;
            String workflow_node_peoples_input = "";
            String workflow_node_condition_input = "";
            String workflow_newflow_input = "";
            if (params.get("workflow_node_peoples_input") != null) {
                workflow_node_peoples_input = (String)params.get("workflow_node_peoples_input");
            }

            if (params.get("workflow_node_condition_input") != null) {
                workflow_node_condition_input = (String)params.get("workflow_node_condition_input");
            }

            if (params.get("workflow_newflow_input") != null) {
                workflow_newflow_input = (String)params.get("workflow_newflow_input");
            }

            this.colManager.transSendImmediate(_summaryIds, _affairIds, sentFlag, workflow_node_peoples_input, workflow_node_condition_input, workflow_newflow_input);
            return this.redirectModelAndView("collaboration.do?method=listSent");
        } else {
            return null;
        }
    }

    public ModelAndView listSent(HttpServletRequest request, HttpServletResponse response) throws Exception {
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        ModelAndView modelAndView;
        if (ColUtil.isGovDocRequest(request)) {
            modelAndView = new ModelAndView("govdoc/listSent");
            param.put("govdoc", "govdoc");
        } else {
            modelAndView = new ModelAndView("apps/collaboration/listSent");
        }

        request.setAttribute("fflistSent", this.colManager.getSentList(fi, param));
        EnumManager enumManager = (EnumManager)AppContext.getBean("enumManager");
        List<CtpEnumItem> secretLevelList = enumManager.getEnumItems(EnumNameEnum.edoc_secret_level);
        List<CtpEnumItem> urgentLevelList = enumManager.getEnumItems(EnumNameEnum.edoc_urgent_level);
        CtpEnumItem item;
        Iterator var10;
        if (CollectionUtils.isNotEmpty(secretLevelList)) {
            var10 = secretLevelList.iterator();

            while(var10.hasNext()) {
                item = (CtpEnumItem)var10.next();
                item.setLabel(ResourceUtil.getString(item.getLabel()));
            }

            modelAndView.addObject("secretLevelList", JSONUtil.toJSONString(secretLevelList));
        }

        if (CollectionUtils.isNotEmpty(urgentLevelList)) {
            var10 = urgentLevelList.iterator();

            while(var10.hasNext()) {
                item = (CtpEnumItem)var10.next();
                item.setLabel(ResourceUtil.getString(item.getLabel()));
            }

            modelAndView.addObject("urgentLevelList", JSONUtil.toJSONString(urgentLevelList));
        }

        modelAndView.addObject("paramMap", param);
        return modelAndView;
    }

    public ModelAndView list4Quote(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/list4Quote");
        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        request.setAttribute("fflistSend", this.colManager.getSentlist4Quote(fi, param));
        return modelAndView;
    }

    public ModelAndView listDesc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/listDesc");
        String type = request.getParameter("type");
        if ("listSent".equals(type)) {
            mav.addObject("desc", ResourceUtil.getString("menu.collaboration.listsent"));
        } else if ("listDone".equals(type)) {
            mav.addObject("desc", ResourceUtil.getString("menu.collaboration.listDone"));
        } else if ("listPending".equals(type)) {
            mav.addObject("desc", ResourceUtil.getString("menu.collaboration.listPending"));
        } else if ("listWaitSend".equals(type)) {
            mav.addObject("desc", ResourceUtil.getString("menu.collaboration.listWaitsend"));
        } else if ("listSupervise".equals(type)) {
            mav.addObject("desc", ResourceUtil.getString("menu.collaboration.supervise"));
        }

        mav.addObject("type", type);
        mav.addObject("size", request.getParameter("size"));
        return mav;
    }

    private Map<String, String> getWebQueryCondition(FlipInfo fi, HttpServletRequest request) {
        String condition = request.getParameter("condition");
        String textfield = request.getParameter("textfield");
        Map<String, String> query = new HashMap();
        String app = request.getParameter("app");
        if (Strings.isNotBlank(app)) {
            query.put("app", app);
        }

        String sub_app = request.getParameter("sub_app");
        if (Strings.isNotBlank(sub_app)) {
            query.put("sub_app", sub_app);
        }

        String permissions = request.getParameter("listCfgId");
        ColUtil.getPermissions(query, permissions);
        String finishstate = request.getParameter("finishstate");
        if (Strings.isNotBlank(finishstate)) {
            query.put("finishstate", finishstate);
        }

        if (AppContext.hasPlugin(SecretUtil.SECRET_PLUGIN_NAME)) {
            String secretLevel = request.getParameter("secretLevel");
            if (Strings.isNotBlank(secretLevel)) {
                query.put("secretLevel", secretLevel);
            }
        }

        if (Strings.isNotBlank(condition) && Strings.isNotBlank(textfield)) {
            query.put(condition, textfield);
            fi.setParams(query);
        }

        return query;
    }

    public ModelAndView listDone(HttpServletRequest request, HttpServletResponse response) throws Exception {
        boolean flag = ColUtil.isGovDocRequest(request);
        ModelAndView modelAndView;
        FlipInfo fi;
        Map param;
        if (flag) {
            modelAndView = new ModelAndView("govdoc/govdocListDone");
            fi = new FlipInfo();
            param = this.getWebQueryCondition(fi, request);
            request.setAttribute("fflistDone", this.colManager.getDoneList(fi, param));
            modelAndView.addObject("paramMap", param);
            return modelAndView;
        } else {
            modelAndView = new ModelAndView("apps/collaboration/listDone");
            fi = new FlipInfo();
            param = this.getWebQueryCondition(fi, request);
            request.setAttribute("fflistDone", this.colManager.getDoneList(fi, param));
            modelAndView.addObject("paramMap", param);
            return modelAndView;
        }
    }

    public ModelAndView listPending(HttpServletRequest request, HttpServletResponse response) throws Exception {
        boolean flag = ColUtil.isGovDocRequest(request);
        ModelAndView modelAndView;
        FlipInfo fi;
        String extType = request.getParameter("ext_type");
        Map param;
        if (flag) {
            modelAndView = new ModelAndView("govdoc/govdocListPending");
            fi = new FlipInfo();
            param = this.getWebQueryCondition(fi, request);
            this.colManager.getPendingList(fi, param);
            request.setAttribute("fflistPending", this.colManager.getPendingList(fi, param));
            modelAndView.addObject("paramMap", param);
            return modelAndView;
        } else {
            modelAndView = new ModelAndView("apps/collaboration/listPending");
            fi = new FlipInfo();
            param = this.getWebQueryCondition(fi, request);
            ColManagerImpl impl2;
            request.setAttribute("fflistPending", this.colManager.getPendingList(fi, param));
            modelAndView.addObject("paramMap", param);
            return modelAndView;
        }
    }

    public ModelAndView listWaitSend(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView;
        if (ColUtil.isGovDocRequest(request)) {
            modelAndView = new ModelAndView("govdoc/listWaitSend");
        } else {
            modelAndView = new ModelAndView("apps/collaboration/listWaitSend");
        }

        FlipInfo fi = new FlipInfo();
        Map<String, String> param = this.getWebQueryCondition(fi, request);
        request.setAttribute("fflistWaitSend", this.colManager.getWaitSendList(fi, param));
        List<CtpEnumItem> secretLevelList = this.enumManager.getEnumItems(EnumNameEnum.edoc_secret_level);
        if (CollectionUtils.isNotEmpty(secretLevelList)) {
            Iterator var8 = secretLevelList.iterator();

            while(var8.hasNext()) {
                CtpEnumItem item = (CtpEnumItem)var8.next();
                item.setLabel(ResourceUtil.getString(item.getLabel()));
            }

            modelAndView.addObject("secretLevelList", JSONUtil.toJSONString(secretLevelList));
        }

        modelAndView.addObject("paramMap", param);
        return modelAndView;
    }

    public ModelAndView summary(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        if ("true".equals(request.getParameter("fromFormQuery"))) {
            AppContext.putRequestContext("fromFormQuery", "1");
        }

        ModelAndView mav = null;
        mav = new ModelAndView("apps/collaboration/summary");
        ColSummaryVO summaryVO = new ColSummaryVO();
        User user = AppContext.getCurrentUser();
        String _affairId = request.getParameter("affairId");
        String _summaryId = request.getParameter("summaryId");
        String _processId = request.getParameter("processId");
        String _operationId = request.getParameter("operationId");
        String formMutilOprationIds = request.getParameter("formMutilOprationIds");
        String openFrom = request.getParameter("openFrom");
        String type = request.getParameter("type");
        String contentAnchor = request.getParameter("contentAnchor");
        String pigeonholeType = request.getParameter("pigeonholeType");
        String isRecSendRel = request.getParameter("isRecSendRel");
        String isJointly = request.getParameter("isJointly");
        String govdocType = "";
        String extFrom = request.getParameter("extFrom");
        CtpAffair affair = null;
        if (Strings.isNotBlank(_affairId)) {
            CtpAffair affairId = this.colManager.getAffairById(Long.valueOf(_affairId));
            if (affairId == null) {
                ColUtil.webAlertAndClose(response, "数据已删除，你无法访问该数据！");
                return null;
            }

            affairId.setSubState(SubStateEnum.col_pending_read.getKey());
            if (AppContext.hasPlugin(SecretUtil.SECRET_PLUGIN_NAME) && !SecretUtil.canOpenCol((HttpServletResponse)null, affairId.getSecretLevel(), (String)null)) {
                ColUtil.webAlertAndClose(response, "涉密级别不够，无法查看！");
                return null;
            }

            affair = affairId;
            if (Strings.isBlank(_summaryId)) {
                _summaryId = String.valueOf(affairId.getObjectId());
            }

            if (affairId.getSubApp() != null) {
                switch(affairId.getSubApp()) {
                    case 1:
                        govdocType = "send";
                        break;
                    case 2:
                        govdocType = "rec";
                    case 3:
                    default:
                        break;
                    case 4:
                        govdocType = "exchange";
                }
            }
        }

        String _trackTypeRecord = request.getParameter("trackTypeRecord");
        String _dumpData = request.getParameter("dumpData");
        boolean isHistoryFlag = "1".equals(_dumpData);
        summaryVO.setHistoryFlag(isHistoryFlag);
        if ((!Strings.isNotBlank(_affairId) || NumberUtils.isNumber(_affairId)) && (!Strings.isNotBlank(_summaryId) || NumberUtils.isNumber(_summaryId)) && (!Strings.isNotBlank(_processId) || NumberUtils.isNumber(_processId))) {
            if (Strings.isBlank(_affairId) && Strings.isBlank(_summaryId) && Strings.isBlank(_processId)) {
                ColUtil.webAlertAndClose(response, "无法访问该协同，请求参数中必须有affairId,summaryId,processId 三个参数中的一个！");
                this.logger.info("无法访问该协同，请求参数中必须有affairId,summaryId,processId 三个参数中的一个！");
                return null;
            } else {
                summaryVO.setProcessId(_processId);
                summaryVO.setSummaryId(_summaryId);
                if (ColOpenFrom.subFlow.name().equals(openFrom)) {
                    summaryVO.setOperationId(formMutilOprationIds);
                } else {
                    summaryVO.setOperationId(_operationId);
                }

                summaryVO.setAffairId(Strings.isBlank(_affairId) ? null : Long.parseLong(_affairId));
                summaryVO.setOpenFrom(openFrom);
                summaryVO.setType(type);
                summaryVO.setCurrentUser(user);
                summaryVO.setLenPotent(request.getParameter("lenPotent"));
                summaryVO.setRecSendRel("1".equals(isRecSendRel));
                boolean isBlank = Strings.isBlank(pigeonholeType) || "null".equals(pigeonholeType) || "undefined".equals(pigeonholeType);
                summaryVO.setPigeonholeType(isBlank ? PigeonholeType.edoc_dept.ordinal() : Integer.valueOf(pigeonholeType));

                try {
                    summaryVO = this.colManager.transShowSummary(summaryVO);
                    if (summaryVO == null) {
                        return null;
                    }
                } catch (Exception var69) {
                    this.logger.error("summary方法中summaryVO为空", var69);
                    ColUtil.webAlertAndClose(response, var69.getMessage());
                    return null;
                }

                if (Strings.isNotBlank(summaryVO.getErrorMsg())) {
                    ColUtil.webAlertAndCloseDialog(response, summaryVO.getErrorMsg(), request.getParameter("dialogId"));
                    return null;
                } else {
                    if (StringUtils.isBlank(_summaryId) && summaryVO.getSummary() != null) {
                        _summaryId = String.valueOf(summaryVO.getSummary().getId());
                    }

                    boolean hasAtt = false;
                    String jbign = "no";

                    boolean chuantouchakan1;
                    String nodePermissionPolicy;
                    List details;
                    String messsageAnchor;
                    try {
                        if (summaryVO.getSummary() != null && summaryVO.getSummary().getGovdocType() != null && (summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_fawen.getKey() || summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_shouwen.getKey() || summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_qianbao.getKey() || summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_jiaohuan.getKey())) {
                            mav = new ModelAndView("govdoc/govdoc_summary");
                            Long isFlowBack = summaryVO.getAffair().getBackFromId();
                            if (isFlowBack == null) {
                                Map<String, Object> params = new HashMap();
                                params.put("objectId", summaryVO.getSummary().getId());
                                params.put("memberId", summaryVO.getAffair().getMemberId());
                                params.put("state", StateEnum.col_cancel.key());
                                params.put("nodePolicy", summaryVO.getAffair().getNodePolicy());
                                List<CtpAffair> affairs = this.affairManager.getByConditions(params);
                                if (affairs != null && affairs.size() > 0) {
                                    isFlowBack = ((CtpAffair)affairs.get(0)).getBackFromId();
                                }
                            }

                            Iterator it;
                            List govdocCtpContentAll;
                            if (this.govdocOpenManager.isEdocNewView()) {
                                mav.addObject("newGovdocView", 1);
                                details = this.govdocExchangeManager.findMainBySummaryId4Exchange(summaryVO.getSummary().getId());
                                int govdocview_delivery = 0;
                                int govdocview_waitSign = 0;
                                int govdocview_hasBack = 0;
                                List<CtpAffair> affairs = this.affairManager.getAffairsByAppAndObjectId(ApplicationCategoryEnum.edoc, summaryVO.getSummary().getId());
                                chuantouchakan1 = false;
                                it = affairs.iterator();

                                while(it.hasNext()) {
                                    CtpAffair ctpAffair = (CtpAffair)it.next();
                                    if (ctpAffair.getMemberId() == AppContext.currentUserId()) {
                                        chuantouchakan1 = true;
                                        break;
                                    }
                                }

                                if (CollectionUtils.isNotEmpty(details) && chuantouchakan1) {
                                    if (((GovdocExchangeMain)details.get(0)).getStartUserId() == AppContext.currentUserId()) {
                                        mav.addObject("isSender", 1);
                                    }

                                    govdocCtpContentAll = this.govdocExchangeManager.findDetailByMainId(((GovdocExchangeMain)details.get(0)).getId());
                                    govdocview_delivery = govdocCtpContentAll.size();
                                    Iterator var35 = govdocCtpContentAll.iterator();

                                    while(var35.hasNext()) {
                                        GovdocExchangeDetail govdocExchangeDetail = (GovdocExchangeDetail)var35.next();
                                        if (govdocExchangeDetail.getStatus() == ExchangeDetailStatus.waitSign.getKey()) {
                                            ++govdocview_waitSign;
                                        }

                                        if (govdocExchangeDetail.getStatus() == ExchangeDetailStatus.hasBack.getKey()) {
                                            ++govdocview_hasBack;
                                        }
                                    }
                                }

                                mav.addObject("govdocview_delivery", govdocview_delivery);
                                mav.addObject("govdocview_waitSign", govdocview_waitSign);
                                mav.addObject("govdocview_hasBack", govdocview_hasBack);
                            }

                            if (this.govdocOpenManager.isAllowCommentInForm()) {
                                mav.addObject("allowCommentInForm", 1);
                            }

                            mav.addObject("isFlowBack", isFlowBack);
                            details = this.govdocExchangeManager.findDetailBySummaryId(summaryVO.getSummary().getId());
                            if (details != null && details.size() > 0) {
                                if (((GovdocExchangeDetail)details.get(0)).getStatus() == ExchangeDetailStatus.waitSign.getKey()) {
                                    mav.addObject("signStatus", "waitSign");
                                }

                                if (((GovdocExchangeDetail)details.get(0)).getStatus() == ExchangeDetailStatus.hasFenBan.getKey()) {
                                    mav.addObject("fenbanStatus", "hasFenban");
                                }
                            }

                            boolean allowUpdateAttachment = false;
                            if ("listSent".equals(openFrom) && !"true".equals(isJointly) && summaryVO.getSummary().getState() == flowState.run.ordinal()) {
                                allowUpdateAttachment = EdocSwitchHelper.allowUpdateAttachment(AppContext.currentAccountId());
                            }

                            messsageAnchor = request.getParameter("chuantou");
                            if (Strings.isNotBlank(messsageAnchor)) {
                                allowUpdateAttachment = false;
                            }

                            mav.addObject("chuantou", messsageAnchor);
                            mav.addObject("canEditAtt", allowUpdateAttachment);
                            if (summaryVO.getAttachments() != null && summaryVO.getAttachments().size() > 0) {
                                hasAtt = true;
                            }

                            boolean taohongriqiSwitch = EdocSwitchHelper.taohongriqiSwitch(AppContext.currentAccountId());
                            mav.addObject("taohongriqiSwitch", taohongriqiSwitch);
                            mav.addObject("newPdfIdFirst", UUIDLong.longUUID());
                            mav.addObject("newPdfIdSecond", UUIDLong.longUUID());
                            mav.addObject("newOFDIdFirst", UUIDLong.longUUID());
                            mav.addObject("newOFDIdSecond", UUIDLong.longUUID());
                            EdocSendFormRelationManager edocSendFormRelationManager = (EdocSendFormRelationManager)AppContext.getBean("edocSendFormRelationManager");
                            List<EdocSendFormRelation> edocSendFormRelations = edocSendFormRelationManager.getByEdocId(summaryVO.getSummary().getId());
                            if (edocSendFormRelations != null && edocSendFormRelations.size() > 0) {
                                mav.addObject("PDFId", ((EdocSendFormRelation)edocSendFormRelations.get(0)).getFileId());
                                mav.addObject("fileType", ((EdocSendFormRelation)edocSendFormRelations.get(0)).getFileType());
                            }

                            govdocCtpContentAll = MainbodyService.getInstance().getContentManager().getContentOfTransByModuleId(Long.parseLong(_summaryId));
                            it = govdocCtpContentAll.iterator();

                            while(it.hasNext()) {
                                CtpContentAll content = (CtpContentAll)it.next();
                                if (content.getContentType() == MainbodyType.Pdf.getKey()) {
                                    mav.addObject("pdfFileId", content.getContent());
                                }

                                if (content.getContentType() == MainbodyType.Ofd.getKey()) {
                                    mav.addObject("ofdFileId", content.getContent());
                                }
                            }

                            ColUtil.getGovdocContent(mav, String.valueOf(summaryVO.getSummary().getId()), this.ctpMainbodyManager);
                            GovDocURLEvent event = new GovDocURLEvent(this);
                            String atts;
                            if (!"listSent".equals(openFrom) && !"listWaitSend".equals(openFrom) && !"formQuery".equals(openFrom) && !"edocStatics".equals(openFrom)) {
                                ColSummary colSummary = this.colManager.getSummaryById(Long.valueOf(_summaryId));
                                long formId = colSummary.getFormAppid();
                                FormManager formManager = (FormManager)AppContext.getBean("formManager");
                                FormBean formBean = formManager.getForm(formId);
                                String category = PermissionFatory.getPermBySubApp(colSummary.getGovdocType()).getCategorty();
                                String configItem = ColUtil.getPolicyByAffair(summaryVO.getAffair()).getId();
                                Permission permission = this.permissionManager.getPermission(category, configItem, formBean.getOwnerAccountId());
                                String str;
                                if (permission != null) {
                                    NodePolicy nodePolicy = permission.getNodePolicy();
                                    String bActions = nodePolicy.getBaseAction();
                                    mav.addObject("canShowOpinion", bActions.contains("Opinion"));
                                    mav.addObject("canShowAttitude", nodePolicy.getAttitude() != 3);
                                    mav.addObject("canShowCommonPhrase", bActions.contains("CommonPhrase"));
                                    mav.addObject("canUploadAttachment", bActions.contains("UploadAttachment"));
                                    mav.addObject("canUploadRel", bActions.contains("UploadRelDoc"));
                                    mav.addObject("formDefaultShow", nodePolicy.getFormDefaultShow());
                                    if (Strings.isNotBlank(nodePolicy.getPermissionRange()) && affair.getSubState() != SubStateEnum.col_pending_specialBack.key()) {
                                        mav.addObject("showCustomDealWith", "true");
                                        Map<String, List<Map<String, Object>>> memberMapList = new HashMap();
                                        if (affair != null) {
                                            mav.addObject("customDealWith", affair.getCustomDealWith() == null ? "true" : affair.getCustomDealWith().toString());
                                            mav.addObject("customDealWithPermission", affair.getCustomDealWithPermission());
                                            mav.addObject("customDealWithMemberId", affair.getCustomDealWithMemberId());
                                        } else {
                                            mav.addObject("customDealWith", "true");
                                            mav.addObject("customDealWithPermission", "");
                                            mav.addObject("customDealWithMemberId", "");
                                        }

                                        List<PermissionVO> permissions = new ArrayList();
                                        String[] permissionIds = StringUtils.split(nodePolicy.getPermissionRange(), ",");
                                        String[] var53 = permissionIds;
                                        int var52 = permissionIds.length;

                                        for(int var51 = 0; var51 < var52; ++var51) {
                                            str = var53[var51];
                                            if (!Strings.isBlank(str)) {
                                                PermissionVO permissionVO = this.permissionManager.getPermission(Long.valueOf(str));
                                                if (permissionVO != null) {
                                                    if (permissionVO != null && permissionVO.getIsEnabled() == 1) {
                                                        permissions.add(permissionVO);
                                                    }

                                                    Permission temp = this.permissionManager.getPermission(category, permissionVO.getName(), permissionVO.getOrgAccountId());
                                                    String memberRange = temp.getNodePolicy().getMemberRange();
                                                    this.logger.debug("自流程策略设置的人员=" + memberRange);
                                                    List<Map<String, Object>> list = new ArrayList();
                                                    if (Strings.isNotBlank(memberRange)) {
                                                        String[] strs = StringUtils.split(memberRange, ",");
                                                        String[] var62 = strs;
                                                        int var61 = strs.length;

                                                        for(int var60 = 0; var60 < var61; ++var60) {
                                                            String memberStr = var62[var60];
                                                            if (!Strings.isBlank(memberStr)) {
                                                                String[] ids = StringUtils.split(memberStr, "|");
                                                                V3xOrgMember member = this.orgManager.getMemberById(Long.valueOf(ids[ids.length - 1]));
                                                                if ((colSummary.getSecretLevel() == null || colSummary.getSecretLevel() <= member.getSecretLevel()) && member != null && member.isValid()) {
                                                                    Map<String, Object> memberMap = new HashMap();
                                                                    memberMap.put("id", member.getId());
                                                                    memberMap.put("name", member.getName());
                                                                    memberMap.put("orgAccountId", member.getOrgAccountId());
                                                                    list.add(memberMap);
                                                                }
                                                            }
                                                        }
                                                    }

                                                    memberMapList.put(permissionVO.getName(), list);
                                                }
                                            }
                                        }

                                        mav.addObject("permissions", permissions);
                                        List<Map<String, Object>> members = new ArrayList();
                                        if (Strings.isNotBlank(affair.getCustomDealWithPermission()) && memberMapList.containsKey(affair.getCustomDealWithPermission())) {
                                            members = (List)memberMapList.get(affair.getCustomDealWithPermission());
                                        } else if (permissionIds != null && permissionIds.length > 0) {
                                            PermissionVO permissionVO = this.permissionManager.getPermission(Long.valueOf(permissionIds[0]));
                                            members = (List)memberMapList.get(permissionVO.getName());
                                        }

                                        this.logger.debug("自流程affair.getCustomDealWithMemberId()=" + affair.getCustomDealWithMemberId());
                                        V3xOrgMember returnToMember;
                                        if (affair.getCustomDealWithMemberId() != null) {
                                            returnToMember = this.orgManager.getMemberById(affair.getCustomDealWithMemberId());
                                            if (returnToMember != null) {
                                                Map<String, Object> memberMap = new HashMap();
                                                memberMap.put("id", returnToMember.getId());
                                                memberMap.put("name", returnToMember.getName());
                                                memberMap.put("orgAccountId", returnToMember.getOrgAccountId());
                                                ((List)members).add(memberMap);
                                            }
                                        }

                                        mav.addObject("members", members);
                                        mav.addObject("memberJson", JSONUtil.toJSONString(memberMapList));
                                        returnToMember = null;
                                        if ("sendMember".equals(nodePolicy.getReturnTo())) {
                                            returnToMember = this.orgManager.getMemberById(colSummary.getStartMemberId());
                                        } else if ("currentMember".equals(nodePolicy.getReturnTo())) {
                                            returnToMember = this.orgManager.getMemberById(AppContext.currentUserId());
                                        }

                                        mav.addObject("nextMember", returnToMember);
                                        mav.addObject("currentPolicyId", permission.getName());
                                        mav.addObject("currentPolicyName", permission.getLabel());
                                    }
                                }

                                long permissionId = permission.getFlowPermId();
                                atts = "true";
                                FormPermissionConfig formPermissionConfig = this.formPermissionConfigManager.getConfigByFormId(formId);
                                if (formPermissionConfig != null) {
                                    Map<String, String> conentShowMap = (Map)JSONUtil.parseJSONString(formPermissionConfig.getShowContentConfig());
                                    if (conentShowMap != null) {
                                        Iterator var133 = conentShowMap.keySet().iterator();

                                        while(var133.hasNext()) {
                                            str = (String)var133.next();
                                            if (permissionId == Long.valueOf(str)) {
                                                atts = (String)conentShowMap.get(str);
                                                break;
                                            }
                                        }
                                    }
                                }

                                if ("true".equals(atts)) {
                                    mav.addObject("showContentByGovdocNodePropertyConfig", true);
                                } else {
                                    mav.addObject("showContentByGovdocNodePropertyConfig", false);
                                }

                                if (_affairId != null) {
                                    event.setAffairId(Long.valueOf(_affairId));
                                }

                                event.setColSummary(colSummary);
                                if (colSummary.getTempleteId() != null) {
                                    mav.addObject("isSystemTemplate", TemplateUtil.isSystemTemplate(colSummary.getTempleteId()));
                                }
                            } else {
                                mav.addObject("showContentByGovdocNodePropertyConfig", true);
                            }

                            event.setApp(String.valueOf(ApplicationCategoryEnum.edoc.key()));
                            event.setSubApp(String.valueOf(summaryVO.getSummary().getGovdocType()));
                            EventDispatcher.fireEvent(event);
                            CtpContentAll ctpContentAll = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(Long.valueOf(_summaryId));
                            if (ctpContentAll == null) {
                                ctpContentAll = this.colManager.getCtpContentAllTypeAndId(ModuleType.collaboration, Long.valueOf(_summaryId));
                            }

                            if (MainbodyType.HTML.getKey() != ctpContentAll.getContentType()) {
                                mav.addObject("currentContentId", ctpContentAll.getContent());
                            }

                            String[] nodePolicyFromWorkflow = null;
                            nodePermissionPolicy = "";
                            GovdocFormOpinionSortManager govdocFormOpinionSortManager = (GovdocFormOpinionSortManager)AppContext.getBean("govdocFormOpinionSortManager");
                            if (summaryVO.getActivityId() != null) {
                                nodePolicyFromWorkflow = this.wapi.getNodePolicyIdAndName(ApplicationCategoryEnum.edoc.name(), summaryVO.getProcessId(), String.valueOf(summaryVO.getActivityId()));
                            }

                            if (nodePolicyFromWorkflow != null) {
                                nodePermissionPolicy = nodePolicyFromWorkflow[0];
                            }

                            try {
                                String disPosition = "";
                                summaryVO.getSummary();
                                mav.addObject("disPosition", disPosition);
                                mav.addObject("nodePermissionPolicy", nodePermissionPolicy);
                            } catch (Exception var67) {
                                this.logger.error("查询处理意见错误", var67);
                            }

                            List<JointlyIssyedVO> mainList = this.govdocExchangeManager.findMainBySummaryId4Lianhe(Long.parseLong(_summaryId), false);
                            Iterator var121;
                            if (mainList != null && mainList.size() > 0) {
                                StringBuffer jointlyIssyed_value = new StringBuffer("");
                                StringBuffer jointlyIssyed_text = new StringBuffer("");
                                Set<Long> s = new HashSet();
                                var121 = mainList.iterator();

                                while(var121.hasNext()) {
                                    JointlyIssyedVO vo = (JointlyIssyedVO)var121.next();
                                    if (vo.isSendFlow()) {
                                        Long orgId = Long.parseLong(vo.getOrgId());
                                        if (!s.contains(orgId)) {
                                            s.add(orgId);
                                            if (jointlyIssyed_value.length() > 0) {
                                                jointlyIssyed_value.append(",");
                                                jointlyIssyed_text.append("、");
                                            }

                                            jointlyIssyed_value.append(vo.getOrgType()).append("|").append(vo.getOrgId());
                                            jointlyIssyed_text.append(vo.getOrgName());
                                        }
                                    }
                                }

                                mav.addObject("jointlyIssyed_value", jointlyIssyed_value.toString());
                                mav.addObject("jointlyIssyed_text", jointlyIssyed_text.toString());
                                mav.addObject("_jointlyIssued", "1");
                            }

                            EdocSummary edocSummary = this.edocManager.getEdocSummaryById(summaryVO.getSummary().getId(), false);
                            if (("listPending".equals(openFrom) || "Pending".equals(openFrom)) && edocSummary != null) {
                                mav.addObject("jianbanType", edocSummary.getJianbanType());
                            }

                            this.commentManager = (CommentManager)AppContext.getBean("ctpCommentManager");
                            List<Comment> commentList = this.commentManager.getCommentAllByModuleId(ModuleType.collaboration, summaryVO.getSummary().getId());
                            List<Attachment> commentShowAttrs = new ArrayList();
                            var121 = commentList.iterator();

                            while(var121.hasNext()) {
                                Comment comment = (Comment)var121.next();
                                if (comment.getCtype() != CommentType.draft.getKey() && !comment.getIsNiban()) {
                                    atts = comment.getRelateInfo();
                                    if (Strings.isNotBlank(atts) && atts.indexOf(":") != -1) {
                                        try {
                                            List list = (List)JSONUtil.parseJSONString(atts, List.class);
                                            List<Attachment> l = ParamUtil.mapsToBeans(list, Attachment.class, false);
                                            commentShowAttrs.addAll(l);
                                        } catch (Exception var66) {
                                            LOGGER.error(var66);
                                        }
                                    }
                                }
                            }

                            String commentShowAttrstr = this.attachmentManager.getAttListJSON(commentShowAttrs);
                            mav.addObject("commentShowAttrstr", commentShowAttrstr);
                        }
                    } catch (Exception var68) {
                        LOGGER.error("新公文详情页面打开报错", var68);
                    }

                    if (Strings.isNotBlank(_summaryId)) {
                        ColSummary colSummary = this.colManager.getSummaryById(Long.valueOf(_summaryId));
                        EdocSummary edocSummary = this.edocManager.getEdocSummaryById(summaryVO.getSummary().getId(), false);
                        if (colSummary != null && colSummary.getGovdocType() != null && colSummary.getGovdocType() == ApplicationSubCategoryEnum.edoc_shouwen.getKey() && Strings.isNotBlank(edocSummary.getSerialNo())) {
                            FlipInfo ff = new FlipInfo();
                            Map<String, String> params = new HashMap();
                            params.put("serialNo", edocSummary.getSerialNo());
                            params.put("summaryId", _summaryId);
                            this.edocManager.getSeriList(ff, params);
                            if (CollectionUtils.isNotEmpty(ff.getData())) {
                                jbign = "yes";
                            }
                        }

                        mav.addObject("curSeriNo", edocSummary != null ? edocSummary.getSerialNo() : "");
                    }

                    String isFromSendPro = request.getParameter("isFromSendPro");
                    if (Strings.isNotBlank(isFromSendPro)) {
                        mav.addObject("isFromSendPro", isFromSendPro);
                    }

                    mav.addObject("edocInnerMarkJB", jbign);
                    mav.addObject("hasAtt", hasAtt);
                    mav.addObject("trackTypeRecord", _trackTypeRecord);
                    mav.addObject("forwardEventSubject", summaryVO.getSubject());
                    summaryVO.setSubject(Strings.toHTML(Strings.toText(summaryVO.getSubject())));
                    summaryVO.getSummary().setSubject(Strings.toHTML(summaryVO.getSummary().getSubject()));
                    mav.addObject("summaryVO", summaryVO);
                    details = this.trackManager.getTrackLisByAffairId(summaryVO.getAffairId());
                    String forTrackShowString = "";
                    if (details.size() > 0) {
                        StringBuffer sb = new StringBuffer();
                        Iterator var86 = details.iterator();

                        while(var86.hasNext()) {
                            CtpTrackMember member = (CtpTrackMember)var86.next();
                            sb.append("Member|" + member.getTrackMemberId() + ",");
                        }

                        forTrackShowString = sb.toString();
                        if (forTrackShowString.length() > 0) {
                            mav.addObject("forTrackShowString", forTrackShowString.substring(0, forTrackShowString.length() - 1));
                        }
                    }

                    mav.addObject("currentUserName", Strings.toHTML(AppContext.currentUserName()));
                    messsageAnchor = "";
                    if (Strings.isNotBlank(contentAnchor)) {
                        messsageAnchor = contentAnchor;
                    }

                    ConfigItem configItem = this.configManager.getConfigItem("govdoc_switch", "duanxintixing", AppContext.getCurrentUser().getAccountId());
                    if (configItem != null) {
                        mav.addObject("configValue", configItem.getConfigValue());
                    }

                    int superNodestatus = 0;
                    if (summaryVO.getActivityId() != null) {
                        superNodestatus = this.wapi.getSuperNodeStatus(summaryVO.getProcessId(), String.valueOf(summaryVO.getActivityId()));
                    }

                    if (Strings.isBlank(_affairId)) {
                        _affairId = String.valueOf(summaryVO.getAffairId());
                    }

                    if (Strings.isBlank(_summaryId)) {
                        _summaryId = String.valueOf(summaryVO.getSummary().getId());
                    }

                    chuantouchakan1 = SystemProperties.getInstance().getProperty("govdocConfig.chuantouchakan1").equals("true");
                    boolean chuantouchakan2 = SystemProperties.getInstance().getProperty("govdocConfig.chuantouchakan2").equals("true");
                    List<GovdocExchangeMain> exchangeMains = this.govdocExchangeManager.findMainBySummaryIdAndCreateUser4TurnRecEdoc(summaryVO.getSummary().getId(), AppContext.currentUserId());
                    if (exchangeMains != null && exchangeMains.size() > 0 && !"1".equals(isRecSendRel)) {
                        String mainsId = "";

                        GovdocExchangeMain govdocExchangeMain;
                        for(Iterator var100 = exchangeMains.iterator(); var100.hasNext(); mainsId = mainsId + govdocExchangeMain.getId()) {
                            govdocExchangeMain = (GovdocExchangeMain)var100.next();
                            if (mainsId != "") {
                                mainsId = mainsId + ",";
                            }
                        }

                        mav.addObject("haveTurnRecEdoc", mainsId);
                        mav.addObject("chuantouchakan2", chuantouchakan2);
                    }

                    if (chuantouchakan2) {
                        GovdocExchangeDetail detail = this.govdocExchangeManager.findDetailBySummaryIdOrRecSummaryId4TurnRecEdoc(summaryVO.getSummary().getId());
                        if (detail != null && !"1".equals(isRecSendRel)) {
                            mav.addObject("haveTurnRecEdoc2", detail.getId());
                        }
                    }

                    List<GovdocRelation> turnSendEdocRelations = this.govdocRelationManager.findByReferenceId4TurnSendEdoc(summaryVO.getSummary().getId());
                    if (turnSendEdocRelations != null && turnSendEdocRelations.size() > 0 && !"1".equals(isRecSendRel)) {
                        if (summaryVO.getSummary().getGovdocType() != null && summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_fawen.getKey()) {
                            mav.addObject("haveTurnSendEdoc1", ((GovdocRelation)turnSendEdocRelations.get(0)).getSummaryId());
                        } else if (summaryVO.getSummary().getGovdocType() != null && summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_shouwen.getKey()) {
                            mav.addObject("haveTurnSendEdoc2", "true");
                        }
                    }

                    List exchangeRelations;
                    Iterator var105;
                    if (chuantouchakan1) {
                        exchangeRelations = this.govdocRelationManager.findByReferenceId4Exchange(summaryVO.getSummary().getId());
                        if (exchangeRelations != null && exchangeRelations.size() > 0) {
                            if (summaryVO.getSummary().getGovdocType() != null && summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_fawen.getKey() && summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_qianbao.getKey()) {
                                mav.addObject("recRelation", "true");
                            } else if (summaryVO.getSummary().getGovdocType() != null && summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_shouwen.getKey()) {
                                label691: {
                                    mav.addObject("exchangeRelationId", ((GovdocRelation)exchangeRelations.get(0)).getSummaryId());
                                    mav.addObject("exchangeRelationSubject", ((GovdocRelation)exchangeRelations.get(0)).getSubject());
                                    List<GovdocRelation> exchangeRelations2 = this.govdocRelationManager.findByReferenceId4Exchange(((GovdocRelation)exchangeRelations.get(0)).getSummaryId());
                                    Iterator var107 = exchangeRelations2.iterator();

                                    GovdocRelation govdocRelation;
                                    do {
                                        if (!var107.hasNext()) {
                                            break label691;
                                        }

                                        govdocRelation = (GovdocRelation)var107.next();
                                    } while(govdocRelation.getGovdocType() != ApplicationSubCategoryEnum.edoc_fawen.getKey() && govdocRelation.getGovdocType() != ApplicationSubCategoryEnum.edoc_qianbao.getKey());

                                    mav.addObject("sendRelation", govdocRelation.getSummaryId());
                                }
                            } else if (summaryVO.getSummary().getGovdocType() != null && summaryVO.getSummary().getGovdocType() == ApplicationSubCategoryEnum.edoc_jiaohuan.getKey()) {
                                var105 = exchangeRelations.iterator();

                                label450:
                                while(true) {
                                    while(true) {
                                        if (!var105.hasNext()) {
                                            break label450;
                                        }

                                        GovdocRelation govdocRelation = (GovdocRelation)var105.next();
                                        if (govdocRelation.getGovdocType() != ApplicationSubCategoryEnum.edoc_fawen.getKey() && govdocRelation.getGovdocType() != ApplicationSubCategoryEnum.edoc_qianbao.getKey()) {
                                            if (govdocRelation.getGovdocType() == ApplicationSubCategoryEnum.edoc_shouwen.getKey()) {
                                                mav.addObject("exchangeRecId", govdocRelation.getSummaryId());
                                                mav.addObject("exchangeRecSubject", govdocRelation.getSubject());
                                            }
                                        } else {
                                            mav.addObject("exchangeSendSubject", govdocRelation.getSubject());
                                            mav.addObject("exchangeSendId", govdocRelation.getSummaryId());
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if (AppContext.hasPlugin("supervision") && this.supervisionManager != null) {
                        label694: {
                            exchangeRelations = this.orgManager.getMemberRoles(user.getId(), user.getAccountId());
                            var105 = exchangeRelations.iterator();

                            do {
                                if (!var105.hasNext()) {
                                    break label694;
                                }

                                MemberRole memberRole = (MemberRole)var105.next();
                                nodePermissionPolicy = memberRole.getRole().getCode();
                            } while(!Role_NAME.SuperviseStaff.name().equals(nodePermissionPolicy) && !Role_NAME.SuperviseLeader.name().equals(nodePermissionPolicy) && !Role_NAME.UnitSupervision.name().equals(nodePermissionPolicy) && !Role_NAME.DeptSupervision.name().equals(nodePermissionPolicy));

                            List<EdocSupervisionVo> items = this.supervisionManager.listSuperviseItem(Long.valueOf(_summaryId));
                            mav.addObject("supervisionItems", items);
                        }
                    }

                    mav.addObject("govdocType", govdocType);
                    mav.addObject("affairId", _affairId);
                    mav.addObject("summaryId", _summaryId);
                    mav.addObject("currentUserId", AppContext.getCurrentUser().getId());
                    mav.addObject("workitemId", this.affairManager.get(Long.valueOf(_affairId)).getSubObjectId());
                    mav.addObject("superNodestatus", superNodestatus);
                    mav.addObject("contentAnchor", messsageAnchor);
                    mav.addObject("openNewWindow", request.getParameter("openNewWindow"));
                    mav.addObject("proContentPath", request.getContextPath());
                    if (Strings.isNotBlank(extFrom)) {
                        summaryVO.setOpenFrom(extFrom);
                    }

                    return mav;
                }
            }
        } else {
            ColUtil.webAlertAndClose(response, "传入的参数非法，你无法访问该协同！");
            return null;
        }
    }

    public ModelAndView stepBackDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/stepbackDialog");
        String _affairId = request.getParameter("affairId");
        String _objectId = request.getParameter("objectId");
        if (Strings.isNotBlank(_affairId)) {
            CtpAffair ctpAffair = this.affairManager.get(Long.valueOf(_affairId));
            if (ctpAffair != null) {
                if (ctpAffair.getTempleteId() != null) {
                    CtpTemplate ctpTemplate = this.templateManager.getCtpTemplate(ctpAffair.getTempleteId());
                    if (ctpTemplate != null) {
                        mav.addObject("template", ctpTemplate.getCanTrackWorkflow());
                    }
                }

                if (ctpAffair.getApp() != null && ctpAffair.getApp() == ApplicationCategoryEnum.edoc.getKey()) {
                    mav.addObject("affairApp", ctpAffair.getApp());
                }
            }
        }

        mav.addObject("affairId", _affairId);
        mav.addObject("objectId", _objectId);
        return mav;
    }

    public ModelAndView repealDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/repealDialog");
        String _affairId = request.getParameter("affairId");
        String _objectId = request.getParameter("objectId");
        if (Strings.isNotBlank(_affairId)) {
            CtpAffair ctpAffair = this.affairManager.get(Long.valueOf(_affairId));
            if (ctpAffair != null) {
                if (ctpAffair.getTempleteId() != null) {
                    CtpTemplate ctpTemplate = this.templateManager.getCtpTemplate(ctpAffair.getTempleteId());
                    if (ctpTemplate != null) {
                        mav.addObject("template", ctpTemplate.getCanTrackWorkflow());
                    }
                }

                if (ctpAffair.getApp() != null && ctpAffair.getApp() == ApplicationCategoryEnum.edoc.getKey()) {
                    mav.addObject("affairApp", ctpAffair.getApp());
                }
            }
        }

        mav.addObject("affairId", _affairId);
        mav.addObject("objectId", _objectId);
        return mav;
    }

    private boolean checkHttpParamValid(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
        String workflow_data_flag = (String)wfdef.get("workflow_data_flag");
        if (!Strings.isBlank(workflow_data_flag) && !"undefined".equals(workflow_data_flag.trim()) && !"null".equals(workflow_data_flag.trim())) {
            return true;
        } else {
            PrintWriter out = null;

            try {
                out = response.getWriter();
                out.println("<script>");
                out.println("alert('" + StringEscapeUtils.escapeJavaScript("从前端获取数据失败，请重试！") + "');");
                out.println(" window.close();");
                out.println("</script>");
            } catch (Exception var10) {
                this.logger.error("", var10);
            }

            Enumeration es = request.getHeaderNames();
            StringBuilder stringBuffer = new StringBuilder();
            if (es != null) {
                while(es.hasMoreElements()) {
                    Object name = es.nextElement();
                    String header = request.getHeader(name.toString());
                    stringBuffer.append(name + ":=" + header + ",");
                }

                this.logger.warn("request header---" + stringBuffer.toString());
            }

            return false;
        }
    }

    public boolean addToGovdoc(String[] ids, String xml, FormDataMasterBean formDataMasterBean, ColSummary colSummary, GovdocExchangeMain govdocExchangeMain, Long affairId, Map<String, Object> params) throws NumberFormatException, BusinessException {
        List<GovdocExchangeDetail> govdocExchangeDetails = new ArrayList();
        boolean flag = true;

        try {
            String flagStr = "";
            List<V3xOrgEntity> entities = new ArrayList();

            for(int i = 0; i < ids.length; ++i) {
                String thisDanwei = ids[i];
                V3xOrgEntity v = null;
                if (Strings.isNotBlank(thisDanwei)) {
                    if (flagStr.indexOf(thisDanwei) <= -1 && thisDanwei.split("\\|")[0].equals("Account")) {
                        v = this.orgManager.getAccountById(Long.parseLong(thisDanwei.split("\\|")[1]));
                        entities.add(v);
                        flagStr = flagStr + thisDanwei + ",";
                    } else {
                        //V3xOrgDepartment v;
                        if (flagStr.indexOf(thisDanwei) <= -1 && thisDanwei.split("\\|")[0].equals("Department")) {
                            v = this.orgManager.getDepartmentById(Long.parseLong(thisDanwei.split("\\|")[1]));
                            entities.add(v);
                            flagStr = flagStr + thisDanwei + ",";
                        } else if (thisDanwei.split("\\|")[0].equals("OrgTeam")) {
                            EdocObjTeam edocObjTeam = this.edocObjTeamManager.getById(Long.parseLong(thisDanwei.split("\\|")[1]));
                            String selObjsStr = edocObjTeam.getSelObjsStr();
                            if (selObjsStr != null) {
                                String[] selObjsStrs = selObjsStr.split(",");

                                for(int j = 0; j < selObjsStrs.length; ++j) {
                                    if (flagStr.indexOf(selObjsStrs[j]) <= -1) {
                                        flagStr = flagStr + selObjsStrs[j] + ",";
                                        if (selObjsStrs[j].indexOf("Account") > -1) {
                                           V3xOrgAccount v2 = this.orgManager.getAccountById(Long.parseLong(selObjsStrs[j].split("\\|")[1]));
                                            entities.add(v2);
                                        } else if (selObjsStrs[j].indexOf("Department") > -1) {
                                            v = this.orgManager.getDepartmentById(Long.parseLong(selObjsStrs[j].split("\\|")[1]));
                                            entities.add(v);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            String opinion = null;
            if (params.get("opinion") != null) {
                opinion = params.get("opinion").toString();
            }

            Iterator var24 = entities.iterator();

            while(var24.hasNext()) {
                V3xOrgEntity v3xOrgEntity = (V3xOrgEntity)var24.next();
                GovdocExchangeDetail govdocExchangeDetail = new GovdocExchangeDetail();
                govdocExchangeDetail.setSendAccountId(String.valueOf(AppContext.currentAccountId()));
                govdocExchangeDetail.setId(UUIDLong.longUUID());
                govdocExchangeDetail.setMainId(govdocExchangeMain.getId());
                govdocExchangeDetail.setRecOrgId(v3xOrgEntity.getId().toString());
                govdocExchangeDetail.setRecOrgName(v3xOrgEntity.getName());
                int recOrgType = -1;
                if (v3xOrgEntity.getEntityType().equals("Account")) {
                    recOrgType = GovdocExchangeOrgType.account.getKey();
                } else if (v3xOrgEntity.getEntityType().equals("Department")) {
                    recOrgType = GovdocExchangeOrgType.department.getKey();
                }

                govdocExchangeDetail.setRecOrgType(recOrgType);
                govdocExchangeDetail.setStatus(ExchangeDetailStatus.waitSend.getKey());
                govdocExchangeDetail.setOpinion(opinion);
                govdocExchangeDetail.setCreateTime(new Date());
                govdocExchangeDetails.add(govdocExchangeDetail);
            }

            this.govdocExchangeManager.saveToGovdocExchange(govdocExchangeDetails, govdocExchangeMain);
        } catch (Exception var19) {
            LOGGER.error("新增交换数据失败", var19);
        }

        return flag;
    }

    public ModelAndView finishWorkItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String _affairId = request.getParameter("affairId");
        String distributeAffairId = request.getParameter("distributeAffairId");
        String govdocContent = request.getParameter("govdocContent");
        String isConvertPdf = request.getParameter("isConvertPdf");
        String sms_alert = request.getParameter("duanxintixing");
        Map<String, Object> commentDeal = ParamUtil.getJsonDomain("comment_deal");
        String danwei = commentDeal.get("_jointlyIssued_value") == null ? "" : String.valueOf(commentDeal.get("_jointlyIssued_value"));
        if (Strings.isBlank(_affairId) && Strings.isNotBlank(distributeAffairId)) {
            _affairId = distributeAffairId;
        }

        Long affairId = Strings.isBlank(_affairId) ? 0L : Long.parseLong(_affairId);
        String fenfa_input_value = commentDeal.get("fenfa_input_value") == null ? "" : String.valueOf(commentDeal.get("fenfa_input_value"));
        if (!this.checkHttpParamValid(request, response)) {
            return null;
        } else {
            CtpAffair affair = this.affairManager.get(affairId);
            String customDealWithActivitys = request.getParameter("customDealWithActivitys");
            if (Strings.isNotBlank(customDealWithActivitys) && !"undefined".equalsIgnoreCase(customDealWithActivitys)) {
                affair.setCustomDealWithActivitys(customDealWithActivitys);
            }

            Long summaryId = affair.getObjectId();
            if (AppContext.hasPlugin("index") && !"faxing".equals(affair.getNodePolicy())) {
                this.indexManager.update(summaryId, ApplicationCategoryEnum.govdoc.key());
            }

            ColSummary summary = this.colManager.getSummaryById(summaryId);

            try {
                boolean isLock = this.colLockManager.canGetLock(affairId);
                if (isLock) {
                    if ("true".equals(isConvertPdf)) {
                        CtpContentAll content = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(summary.getId());
                        this.colManager.saveGovdocContentAll(summary, AppContext.getCurrentUser().getId(), govdocContent, MainbodyType.Pdf.getKey(), ModuleType.edoc, content.getId());
                        this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.valueOf(summary.getProcessId()), affairId, ProcessLogAction.processEdoc, new String[]{String.valueOf(ProcessEdocAction.wordTransPDF.getKey())});
                    }

                    if (affair == null || affair.getState() != StateEnum.col_pending.key()) {
                        String msg = ColUtil.getErrorMsgByAffair(affair);
                        if (Strings.isNotBlank(msg)) {
                            ColUtil.webAlertAndClose(response, msg);
                            return null;
                        }
                    }

                    boolean canDeal = ColUtil.checkAgent(affair, summary, true);
                    if (!canDeal) {
                        return null;
                    }

                    boolean flg = false;
                    List<GovdocExchangeDetail> govdocExchangeDetails = this.govdocExchangeManager.findDetailBySummaryId(summaryId);
                    Long logId = null;
                    GovdocExchangeMain main = null;
                    if (govdocExchangeDetails != null && govdocExchangeDetails.size() > 0) {
                        main = this.govdocExchangeManager.findMainById(((GovdocExchangeDetail)govdocExchangeDetails.get(0)).getMainId());
                    }

                    GovdocExchangeDetail govdocExchangeDetail;
                    GovdocExchangeMain permission;
                    if (main != null && govdocExchangeDetails != null) {
                        for(Iterator var23 = govdocExchangeDetails.iterator(); var23.hasNext(); logId = this.changeSignState(govdocExchangeDetail, summary, affair, permission.getType(), request)) {
                            govdocExchangeDetail = (GovdocExchangeDetail)var23.next();
                            permission = this.govdocExchangeManager.findMainById(govdocExchangeDetail.getMainId());
                        }
                    }

                    if (StringUtils.isNotBlank(fenfa_input_value)) {
                        this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.issue, new String[]{this.getOrgNamesUtil(fenfa_input_value)});
                    }

                    if (StringUtils.isNotBlank(danwei)) {
                        this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.jointlyIssued, new String[]{this.getOrgNamesUtil(danwei)});
                    }

                    String configItem = ColUtil.getPolicyByAffair(affair).getId();
                    String category = PermissionFatory.getPermBySubApp(summary.getGovdocType(), configItem).getCategorty();

                    Permission permission2 = this.permissionManager.getPermission(category, configItem, AppContext.currentAccountId());
                    String baseAction = permission2.getBasicOperation();
                    if (baseAction.indexOf("FaDistribute") != -1) {
                        summary.setTransferStatus(TransferStatus.sendPublished.getKey());
                    }

                    this.colManager.transFinishWorkItem(summary, affair);
                    List<GovdocExchangeMain> mains = this.govdocExchangeManager.findMainBySummaryId4Exchange(summaryId);
                    if (baseAction.indexOf("FaDistribute") != -1 && CollectionUtils.isEmpty(mains)) {
                        this.exchangeGovdoc(summary, affairId, fenfa_input_value, 0, new HashMap());
                    }

                    this.exchangeGovdoc(summary, affairId, danwei, 1, new HashMap());
                    if (StringUtils.isNotBlank(sms_alert) && "yes".equals(sms_alert)) {
                        this.govdocExchangeManager.msgReminder(affair);
                    }

                    if (summary != null && summary.getGovdocType() != null && (summary.getGovdocType() == ApplicationSubCategoryEnum.edoc_fawen.getKey() || summary.getGovdocType() == ApplicationSubCategoryEnum.edoc_shouwen.getKey() || summary.getGovdocType() == ApplicationSubCategoryEnum.edoc_qianbao.getKey() || summary.getGovdocType() == ApplicationSubCategoryEnum.edoc_jiaohuan.getKey()) && logId != null && summary.getState() == com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState.finish.ordinal()) {
                        GovdocExchangeDetailLog log = this.govdocExchangeManager.getGovdocExchangeDetailLogById(logId);
                        GovdocExchangeDetail detail = this.govdocExchangeManager.getGovdocExchangeDetailById(log.getDetailId());
                        GovdocExchangeMain govdocmain = this.govdocExchangeManager.findMainById(detail.getMainId());
                        if (govdocmain.getType() != 0) {
                            GovdocExchangeDetailLogDao govdocExchangeDetailLogDao = (GovdocExchangeDetailLogDao)AppContext.getBean("govdocExchangeDetailLogDao");
                            List<GovdocExchangeDetailLog> logs = govdocExchangeDetailLogDao.queryLogByDetailId(detail.getId());
                            Iterator var33 = logs.iterator();

                            while(var33.hasNext()) {
                                GovdocExchangeDetailLog govdocExchangeDetailLog = (GovdocExchangeDetailLog)var33.next();
                                govdocExchangeDetailLog.setStatus(ExchangeDetailStatus.ended.getKey());
                                this.govdocExchangeManager.saveDetailLog(govdocExchangeDetailLog);
                            }

                            log.setStatus(ExchangeDetailStatus.ended.getKey());
                            log.setDescription("已结束");
                            this.govdocExchangeManager.saveDetailLog(log);
                            detail.setStatus(ExchangeDetailStatus.ended.getKey());
                            this.govdocExchangeManager.updateDetail(detail);
                        }
                    }

                    GovDocUtil.sendMeg(summary);
                    this.updateDocMetadata(summary, affair.getApp());
                    return null;
                }
            } finally {
                this.colLockManager.unlock(affairId);
                this.colManager.colDelLock(summary, affair);
            }

            return null;
        }
    }

    private void updateDocMetadata(ColSummary summary, int app) {
        if (summary.getArchiveId() != null) {
            try {
                this.docFilingManager.updatePigeHoleFileBySummary(summary, app, AppContext.getCurrentUser().getId());
            } catch (BusinessException var4) {
                LOGGER.error("提交后，保存归档文件数据抛出异常：", var4);
            }
        }

    }

    private Long changeSignState(GovdocExchangeDetail govdocExchangeDetail, ColSummary summary, CtpAffair affair, int type, HttpServletRequest request) throws BusinessException, SQLException {
        Long logId = null;
        if (govdocExchangeDetail.getStatus() == ExchangeDetailStatus.waitSign.getKey()) {
            govdocExchangeDetail.setRecUserName(AppContext.getCurrentUser().getName());
            govdocExchangeDetail.setRecTime(new Date());
            String reSign = request.getParameter("reSign");
            if (type != 0 && type != 2) {
                if (type == 1) {
                    govdocExchangeDetail.setStatus(ExchangeDetailStatus.beingProcessed.getKey());
                }
            } else {
                if (Strings.isBlank(reSign) && request.getAttribute("reSign") == null) {
                    return logId;
                }

                govdocExchangeDetail.setStatus(ExchangeDetailStatus.hasSign.getKey());
            }

            govdocExchangeDetail.setNodeInfo(affair.getActivityId().toString());
            Long formId = summary.getFormAppid();
            FormDataMasterBean formDataMasterBean = null;
            if (formId != null) {
                formDataMasterBean = FormService.findDataById(summary.getFormRecordid(), summary.getFormAppid(), (String[])null);
                FormManager formManager = (FormManager)AppContext.getBean("formManager");
                FormBean fb = formManager.getForm(formId);
                List<FormFieldBean> fs = fb.getAllFieldBeans();
                Iterator var14 = fs.iterator();

                while(var14.hasNext()) {
                    FormFieldBean formFieldBean = (FormFieldBean)var14.next();
                    if (formFieldBean.getInputType().equals("edocSignMark")) {
                        Object value = formDataMasterBean.getFieldValue(formFieldBean.getName());
                        if (value != null) {
                            String recNo = formFieldBean.getDisplayValue(value) == null ? "" : formFieldBean.getDisplayValue(value)[1].toString();
                            govdocExchangeDetail.setRecNo(recNo);
                            break;
                        }
                    }
                }
            }

            GovDocUtil.updateEdocSummaryTransferStatus(summary.getId(), TransferStatus.receiveSigned);
            this.govdocExchangeManager.updateDetail(govdocExchangeDetail);
            GovdocExchangeDetailLog govdocExchangeDetailLog = new GovdocExchangeDetailLog();
            govdocExchangeDetailLog.setId(UUIDLong.longUUID());
            govdocExchangeDetailLog.setDetailId(govdocExchangeDetail.getId());
            if (type != 0 && type != 2) {
                if (type == 1) {
                    govdocExchangeDetailLog.setStatus(ExchangeDetailStatus.beingProcessed.getKey());
                    govdocExchangeDetailLog.setDescription("已签收，进行中");
                }
            } else {
                govdocExchangeDetailLog.setStatus(ExchangeDetailStatus.hasSign.getKey());
                govdocExchangeDetailLog.setDescription("已签收，等待分办");
            }

            govdocExchangeDetailLog.setUserName(AppContext.getCurrentUser().getName());
            govdocExchangeDetailLog.setTime(new Date());
            this.govdocExchangeManager.saveDetailLog(govdocExchangeDetailLog);
            logId = govdocExchangeDetailLog.getId();
        } else if (type == 1) {
            GovdocExchangeDetailLog govdocExchangeDetailLog = new GovdocExchangeDetailLog();
            govdocExchangeDetailLog.setId(UUIDLong.longUUID());
            govdocExchangeDetailLog.setDetailId(govdocExchangeDetail.getId());
            govdocExchangeDetailLog.setStatus(ExchangeDetailStatus.beingProcessed.getKey());
            govdocExchangeDetailLog.setDescription("正在处理");
            govdocExchangeDetailLog.setUserName(AppContext.getCurrentUser().getName());
            govdocExchangeDetailLog.setTime(new Date());
            this.govdocExchangeManager.saveDetailLog(govdocExchangeDetailLog);
            logId = govdocExchangeDetailLog.getId();
        }

        return logId;
    }

    private String getOrgNamesUtil(String str) {
        StringBuffer fenfa_value_str = new StringBuffer();
        if (StringUtils.isBlank(str)) {
            return fenfa_value_str.toString();
        } else {
            try {
                String[] strs = str.split(",");
                String flagStr = "";

                for(int i = 0; i < strs.length; ++i) {
                    if (flagStr.indexOf(strs[i]) <= -1 && strs[i].indexOf("Account") > -1) {
                        V3xOrgAccount account = this.orgManager.getAccountById(Long.parseLong(strs[i].split("\\|")[1]));
                        fenfa_value_str.append(account.getName()).append(",");
                        flagStr = flagStr + strs[i] + ",";
                    } else if (flagStr.indexOf(strs[i]) <= -1 && strs[i].indexOf("Department") > -1) {
                        V3xOrgDepartment department = this.orgManager.getDepartmentById(Long.parseLong(strs[i].split("\\|")[1]));
                        fenfa_value_str.append(department.getName()).append(",");
                        flagStr = flagStr + strs[i] + ",";
                    } else if (strs[i].indexOf("OrgTeam") > -1) {
                        EdocObjTeam edocObjTeam = this.edocObjTeamManager.getById(Long.parseLong(strs[i].split("\\|")[1]));
                        String selObjsStr = edocObjTeam.getSelObjsStr();
                        if (selObjsStr != null) {
                            String[] selObjsStrs = selObjsStr.split(",");

                            for(int j = 0; j < selObjsStrs.length; ++j) {
                                if (flagStr.indexOf(selObjsStrs[j]) <= -1) {
                                    flagStr = flagStr + selObjsStrs[j] + ",";
                                    if (selObjsStrs[j].indexOf("Account") > -1) {
                                        V3xOrgAccount account = this.orgManager.getAccountById(Long.parseLong(selObjsStrs[j].split("\\|")[1]));
                                        fenfa_value_str.append(account.getName()).append(",");
                                    } else if (selObjsStrs[j].indexOf("Department") > -1) {
                                        V3xOrgDepartment department = this.orgManager.getDepartmentById(Long.parseLong(selObjsStrs[j].split("\\|")[1]));
                                        fenfa_value_str.append(department.getName()).append(",");
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (Exception var11) {
                LOGGER.error("获取单位部门信息出错", var11);
            }

            return fenfa_value_str.substring(0, fenfa_value_str.length() - 1);
        }
    }

    private void exchangeGovdoc(ColSummary summary, Long affairId, String danwei, int type, Map<String, Object> params) throws BusinessException, SQLException {
        if (!Strings.isBlank(danwei) || type == 0) {
            Long formRecordId = summary.getFormRecordid();
            Long formAppId = summary.getFormAppid();
            if (formRecordId != null && formAppId != null) {
                FormDataMasterBean formDataMasterBean = FormService.findDataById(summary.getFormRecordid(), summary.getFormAppid(), (String[])null);
                String xml = GovDocUtil.formDataBeanToXML(formDataMasterBean, type);
                String[] ids = danwei.split(",");
                GovdocExchangeMain govdocExchangeMain = new GovdocExchangeMain();
                govdocExchangeMain.setId(UUIDLong.longUUID());
                govdocExchangeMain.setStartTime(new Date());
                govdocExchangeMain.setSubject(String.valueOf(formDataMasterBean.getFieldValue("subject")));
                govdocExchangeMain.setStartUserId(AppContext.getCurrentUser().getId());
                govdocExchangeMain.setCreateTime(new Date());
                govdocExchangeMain.setElementData(xml);
                govdocExchangeMain.setParentId(formDataMasterBean.getId());
                govdocExchangeMain.setSummaryId(summary.getId());
                govdocExchangeMain.setAffairId(affairId);
                govdocExchangeMain.setType(type);
                if (type == 1) {
                    List<GovdocExchangeMain> mains = this.govdocExchangeManager.findMainBySummaryId(summary.getId(), 1);
                    if (mains != null && mains.size() > 0) {
                        govdocExchangeMain.setId(((GovdocExchangeMain)mains.get(0)).getId());
                    }
                } else if (type == 0) {
                    GovDocUtil.updateEdocSummaryTransferStatus(summary.getId(), TransferStatus.sendPublished);
                }

                this.addToGovdoc(ids, xml, formDataMasterBean, summary, govdocExchangeMain, affairId, params);
            }

        }
    }

    public ModelAndView doZCDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String _affairId = request.getParameter("affairId");
        String govdocContent = request.getParameter("govdocContent");
        String isConvertPdf = request.getParameter("isConvertPdf");
        Long affairId = Long.parseLong(_affairId);
        CtpAffair affair = this.affairManager.get(affairId);
        String customDealWithMemberId;
        if (affair == null || affair.getState() != StateEnum.col_pending.key()) {
            customDealWithMemberId = ColUtil.getErrorMsgByAffair(affair);
            if (Strings.isNotBlank(customDealWithMemberId)) {
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.println("alert('" + StringEscapeUtils.escapeJavaScript(customDealWithMemberId) + "');");
                out.println(" window.close();");
                out.println("</script>");
                return null;
            }
        }

        affair.setCustomDealWith("true".equals(request.getParameter("customDealWith")));
        affair.setCustomDealWithPermission(request.getParameter("permissionRange"));
        customDealWithMemberId = request.getParameter("memberRange");
        if (Strings.isNotBlank(customDealWithMemberId) && !"undefined".equals(customDealWithMemberId)) {
            affair.setCustomDealWithMemberId(Long.valueOf(customDealWithMemberId));
        }

        ColSummary summary = this.colManager.getColSummaryById(affair.getObjectId());
        boolean canDeal = ColUtil.checkAgent(affair, summary, true);
        if (!canDeal) {
            return null;
        } else {
            try {
                Map<String, Object> commentDeal = ParamUtil.getJsonDomain("comment_deal");
                String isDistribute = commentDeal.get("isDistribute") == null ? "" : (String)commentDeal.get("isDistribute");
                if (!Strings.isNotBlank(isDistribute)) {
                    this.colManager.transDoZcdb(summary, affair);
                    String signAndDistribute = commentDeal.get("signAndDistribute") == null ? "" : (String)commentDeal.get("signAndDistribute");
                    if (signAndDistribute.equals("1")) {
                        AppContext.putSessionContext("comment", ContentUtil.getCommnetFromRequest(OperationType.finish, affair.getMemberId(), affair.getObjectId()));
                        List<GovdocExchangeDetail> details = this.govdocExchangeManager.findDetailBySummaryId(summary.getId());
                        if (details != null && details.size() > 0) {
                            AppContext.putRequestContext("reSign", 1);
                            this.changeSignState((GovdocExchangeDetail)details.get(0), summary, affair, 0, request);
                        }
                    }

                    this.exchangeGovdoc(summary, affairId, commentDeal.get("_jointlyIssued_value") == null ? "" : String.valueOf(commentDeal.get("_jointlyIssued_value")), 1, new HashMap());
                    if ("true".equals(isConvertPdf)) {
                        CtpContentAll content = MainbodyService.getInstance().getContentManager().getContentNotFormByModuleId(summary.getId());
                        this.colManager.saveGovdocContentAll(summary, AppContext.getCurrentUser().getId(), govdocContent, MainbodyType.Pdf.getKey(), ModuleType.edoc, content.getId());
                        this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.valueOf(summary.getProcessId()), affairId, ProcessLogAction.processEdoc, new String[]{String.valueOf(ProcessEdocAction.wordTransPDF.getKey())});
                    }

                    return null;
                }

                AppContext.putSessionContext("comment", ContentUtil.getCommnetFromRequest(OperationType.finish, affair.getMemberId(), affair.getObjectId()));
            } finally {
                this.colManager.colDelLock(summary, affair);
            }

            return null;
        }
    }

    public ModelAndView doForward(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        Map para = ParamUtil.getJsonDomain("MainData");
        String data = (String)para.get("data");
        String[] ds = data.split("[,]");
        String[] var10 = ds;
        int var9 = ds.length;

        for(int var8 = 0; var8 < var9; ++var8) {
            String d1 = var10[var8];
            if (!Strings.isBlank(d1)) {
                String[] d1s = d1.split("[_]");
                long summaryId = Long.parseLong(d1s[0]);
                long affairId = Long.parseLong(d1s[1]);
                this.colManager.transDoForward(user, summaryId, affairId, para);
            }
        }

        return null;
    }

    public ModelAndView chooseOperation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mv = new ModelAndView("apps/collaboration/isignaturehtml/chooseOperation");
        return mv;
    }

    public ModelAndView showForward(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/forward");
        String data = request.getParameter("data");
        if (Strings.isNotBlank(data) && data.indexOf("_") > 0) {
            String[] datas = data.split("_");
            ColSummary summary = this.colManager.getColSummaryById(Long.valueOf(datas[0]));
            if (summary != null) {
                modelAndView.addObject("secretLevel", summary.getSecretLevel());
            }
        }

        return modelAndView;
    }

    public ModelAndView stepStop(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String _affairId = request.getParameter("affairId");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("affairId", _affairId);
        Map<String, Object> commentDeal = ParamUtil.getJsonDomain("comment_deal");
        tempMap.put("extAtt1", commentDeal.get("extAtt1"));

        try {
            this.colManager.transStepStop(tempMap);
        } finally {
            this.colManager.colDelLock(Long.valueOf(_affairId));
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
        String _affairId = request.getParameter("affairId");
        String _summaryId = request.getParameter("summaryId");
        if (AppContext.hasPlugin("index")) {
            this.indexManager.update(Long.parseLong(_summaryId), ApplicationCategoryEnum.govdoc.key());
        }

        String _trackWorkflowType = request.getParameter("trackWorkflowType");
        Map<String, Object> commentDeal = ParamUtil.getJsonDomain("comment_deal");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("affairId", _affairId);
        CtpAffair ctpAffair = this.affairManager.get(Long.parseLong(_affairId));
        tempMap.put("summaryId", _summaryId);
        tempMap.put("targetNodeId", "");
        tempMap.put("trackWorkflowType", _trackWorkflowType);
        tempMap.put("extAtt1", commentDeal.get("extAtt1"));
        if (ctpAffair.getApp() == 4) {
            tempMap.put("isEdoc", true);
        }

        try {
            this.colManager.transStepBack(tempMap);
        } finally {
            this.colManager.colDelLock(Long.valueOf(_affairId));
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
        Map<String, String> tempMap = new HashMap();
        tempMap.put("workitemId", workitemId);
        tempMap.put("processId", processId);
        tempMap.put("caseId", caseId);
        tempMap.put("activityId", activityId);
        tempMap.put("theStepBackNodeId", theStepBackNodeId);
        tempMap.put("submitStyle", submitStyle);
        tempMap.put("affairId", affairId);
        tempMap.put("summaryId", summaryId);
        Map<String, Object> commentDeal = ParamUtil.getJsonDomain("comment_deal");
        tempMap.put("extAtt1", "" + commentDeal.get("extAtt1"));
        this.colManager.updateAppointStepBack(tempMap);
        if ("0".equals(submitStyle)) {
            CtpAffair ctpAffair = this.affairManager.get(Long.valueOf(affairId));
            ProcessManager processManager = (ProcessManager)AppContext.getBean("processManager");
            ColSummary summary = this.colManager.getColSummaryById(ctpAffair.getObjectId());
            BPMProcess process = processManager.getRunningProcess(summary.getProcessId());
            List<NodeInfo> nodeInfos = process.getNextHumenActivities(theStepBackNodeId, (List)null, 0);
            List<String> activitys = new ArrayList();
            boolean find = false;

            while(!find) {
                Iterator var21 = nodeInfos.iterator();

                while(var21.hasNext()) {
                    NodeInfo nodeInfo = (NodeInfo)var21.next();
                    if (nodeInfo.getId().equals(ctpAffair.getActivityId().toString())) {
                        find = true;
                    } else {
                        activitys.add(nodeInfo.getId());
                        nodeInfos = process.getNextHumenActivities(nodeInfo.getId(), (List)null, 0);
                    }
                }
            }

            activitys.add(theStepBackNodeId);
            activitys.remove("start");
            List<String> deleteActivitys = new ArrayList();
            Iterator var22 = activitys.iterator();

            label55:
            while(true) {
                String activity;
                do {
                    if (!var22.hasNext()) {
                        SRSUtil.deleteNode(ctpAffair, deleteActivitys);
                        break label55;
                    }

                    activity = (String)var22.next();
                } while(Strings.isNotBlank(activity) && activity.equals("start"));

                List<CtpAffair> affairs = this.affairManager.getAffairsByObjectIdAndActivityId(ApplicationCategoryEnum.valueOf(ctpAffair.getApp()), ctpAffair.getObjectId(), Long.valueOf(activity));
                Iterator var25 = affairs.iterator();

                while(true) {
                    CtpAffair affair;
                    do {
                        if (!var25.hasNext()) {
                            continue label55;
                        }

                        affair = (CtpAffair)var25.next();
                    } while(Strings.isBlank(affair.getCustomDealWithActivitys()));

                    String[] strs = StringUtils.split(affair.getCustomDealWithActivitys(), ",");
                    String[] var30 = strs;
                    int var29 = strs.length;

                    for(int var28 = 0; var28 < var29; ++var28) {
                        String str = var30[var28];
                        if (!deleteActivitys.contains(str)) {
                            deleteActivitys.add(str);
                        }
                    }
                }
            }
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

    public ModelAndView repeal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String _summaryId = request.getParameter("summaryId");
        String _affairId = request.getParameter("affairId");
        String _trackWorkflowType = request.getParameter("trackWorkflowType");
        Map<String, Object> tempMap = new HashMap();
        tempMap.put("summaryId", _summaryId);
        tempMap.put("affairId", _affairId);
        tempMap.put("repealComment", request.getParameter("repealComment"));
        tempMap.put("trackWorkflowType", _trackWorkflowType);
        Map<String, Object> commentDeal = ParamUtil.getJsonDomain("comment_deal");
        tempMap.put("extAtt1", commentDeal.get("extAtt1"));

        try {
            this.colManager.transRepal(tempMap);
        } finally {
            this.colManager.colDelLock(Long.valueOf(_affairId));
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
        String isGovdocFlag = request.getParameter("isGovdocFlag");
        if (isGovdocFlag != null && isGovdocFlag.equals("true")) {
            mav = new ModelAndView("govdoc/govdoc_showAttributeSetting");
        }

        Map args = new HashMap();
        args.put("affairId", affairId);
        args.put("isHistoryFlag", isHistoryFlag);
        Map map = this.colManager.getAttributeSettingInfo(args);
        request.setAttribute("ffattribute", map);
        mav.addObject("supervise", map.get("supervise"));
        mav.addObject("openFrom", request.getParameter("openFrom"));
        return mav;
    }

    public ModelAndView getSeriList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("govdoc/seri_list");
        String serialNo = request.getParameter("seriNo");
        mav.addObject("serialNo", serialNo);
        String summaryId = request.getParameter("summaryId");
        mav.addObject("summaryId", summaryId);
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
        if (!StringUtil.checkNull(category)) {
            mav = new ModelAndView("apps/collaboration/showPortalCatagory4MyTemplate");
        }

        return mav;
    }

    public ModelAndView showPortalImportLevel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalImportLevel");
        List<CtpEnumItem> secretLevelItems = this.enumManager.getEnumItems(EnumNameEnum.edoc_urgent_level);
        ColUtil.putImportantI18n2Session();
        mav.addObject("itemCount", secretLevelItems.size());
        return mav;
    }

    public ModelAndView moreSent(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreSent");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String columnsName = ReqUtil.getString(request, "columnsName");
        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_sent.key());
        query.put("isTrack", false);
        query.put("isTrack", false);
        query.put("isFromMore", true);
        ColUtil.putImportantI18n2Session();
        this.colManager.getMoreList4SectionContion(fi, query);
        request.setAttribute("ffmoreList", fi);
        modelAndView.addObject("total", fi.getTotal());
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("columnsName", columnsName);
        return modelAndView;
    }

    public ModelAndView moreDone(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreDone");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = ReqUtil.getString(request, "columnsName");
        String isGroupBy = request.getParameter("isGroupBy");
        if (Strings.isBlank(isGroupBy)) {
            isGroupBy = "false";
        }

        String section = "doneSection";
        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_done.key());
        query.put("isTrack", false);
        query.put("section", section);
        query.put("isGroupBy", isGroupBy);
        query.put("isFromMore", true);
        ColUtil.putImportantI18n2Session();
        this.colManager.getMoreList4SectionContion(fi, query);
        modelAndView.addObject("total", fi.getTotal());
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("section", section);
        modelAndView.addObject("params", query);
        modelAndView.addObject("rowStr", rowStr);
        modelAndView.addObject("columnsName", columnsName);
        modelAndView.addObject("isGroupBy", isGroupBy);
        return modelAndView;
    }

    public ModelAndView moreWaitSend(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreWaitSend");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = ReqUtil.getString(request, "columnsName");
        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_waitSend.key());
        query.put("isTrack", false);
        query.put("isFromMore", true);
        ColUtil.putImportantI18n2Session();
        this.colManager.getMoreList4SectionContion(fi, query);
        modelAndView.addObject("total", fi.getTotal());
        modelAndView.addObject("rowStr", rowStr);
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("columnsName", columnsName);
        return modelAndView;
    }

    public ModelAndView moreMeeting(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreMeeting");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        String meeting_category = request.getParameter("meeting_category");
        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_done.key());
        query.put("isTrack", false);
        query.put("meeting_category", meeting_category);
        fi.setSortField("receiveTime");
        fi.setSortOrder("desc");
        query.put("isFromMore", true);
        this.colManager.getMoreList4SectionContion(fi, query);
        modelAndView.addObject("total", fi.getTotal());
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("rowStr", rowStr);
        modelAndView.addObject("meeting_category", meeting_category);
        return modelAndView;
    }

    public ModelAndView moreTrack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreTrack");
        FlipInfo fi = new FlipInfo();
        String rowStr = request.getParameter("rowStr");
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String columnsName = ReqUtil.getString(request, "columnsName");
        modelAndView.addObject("columnsName", columnsName);
        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("isTrack", true);
        query.put("isFromMore", true);
        ColUtil.putImportantI18n2Session();
        this.colManager.getMoreList4SectionContion(fi, query);
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("total", fi.getTotal());
        modelAndView.addObject("rowStr", rowStr);
        return modelAndView;
    }

    public ModelAndView cancelTrack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map args = ParamUtil.getJsonParams();
        String affairId = (String)args.get("affairId");
        TrackAjaxTranObj obj = new TrackAjaxTranObj();
        obj.setAffairId(affairId);
        this.colManager.transCancelTrack(obj);
        String fragmentId = (String)args.get("fragmentId");
        String ordinal = (String)args.get("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = request.getParameter("columnsName");
        return this.redirectModelAndView("/collaboration/collaboration.do?method=moreTrack&fragmentId=" + fragmentId + "&ordinal=" + ordinal + "&rowStr=" + rowStr + "&columnsName=" + columnsName);
    }

    public ModelAndView disagreeDeal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/disagreeDeal");
        return mav;
    }

    public ModelAndView forwordMail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map query = new HashMap();
        query.put("summaryId", Long.parseLong(request.getParameter("id")));
        query.put("formContent", String.valueOf(request.getParameter("formContent")));
        ModelAndView mv = this.colManager.getforwordMail(query);
        return mv;
    }

    public ModelAndView saveAsTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/saveAsTemplate");
        if (ColUtil.isGovDocRequest(request)) {
            mav.setViewName("govdoc/saveAsTemplate");
        }

        String _hasWorkflow = request.getParameter("hasWorkflow");
        String _subject = request.getParameter("subject");
        String _tembodyType = request.getParameter("tembodyType");
        String _formtitle = request.getParameter("formtitle");
        String _defaultValue = request.getParameter("defaultValue");
        String _ctype = request.getParameter("ctype");
        String _temType = request.getParameter("temType");
        if ("hasnotTemplate".equals(_temType)) {
            mav.addObject("canSelectType", "all");
        } else if ("template".equals(_temType)) {
            mav.addObject("canSelectType", "template");
        } else if ("workflow".equals(_temType)) {
            mav.addObject("canSelectType", "workflow");
        } else if ("text".equals(_temType)) {
            mav.addObject("canSelectType", "text");
        }

        if (Strings.isNotBlank(_ctype)) {
            int n = Integer.parseInt(_ctype);
            if (n == 20) {
                mav.addObject("onlyTemplate", Boolean.TRUE);
            }
        }

        mav.addObject("hasWorkflow", _hasWorkflow);
        mav.addObject("subject", _subject);
        mav.addObject("tembodyType", _tembodyType);
        mav.addObject("formtitle", _formtitle);
        mav.addObject("defaultValue", _defaultValue);
        return mav;
    }

    public ModelAndView detail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return this.summary(request, response);
    }

    public ModelAndView appToColl(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String from = request.getParameter("from");
        String peopleCard = request.getParameter("peopleCard");
        String subject = "";
        Integer moduleType = ModuleType.collaboration.ordinal();
        Date bodyCreateDate = new Date();
        String bodyContent = "";
        List<Attachment> atts = null;
        boolean attsNeedCopy = false;
        Long personId = 0L;
        if (Strings.isNotBlank(peopleCard)) {
            personId = Long.valueOf(peopleCard);
        } else {
            personId = null;
        }

        ModelAndView modelAndView = CollaborationService.appToColl(subject, moduleType, bodyCreateDate, bodyContent, (List)atts, attsNeedCopy, personId, (Long)null, from);
        return modelAndView;
    }

    public ModelAndView updateContentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/updateContentPage");
        String summaryId = request.getParameter("summaryId");
        ContentViewRet context = ContentUtil.contentView(ModuleType.collaboration, Long.parseLong(summaryId), (Long)null, 1, (String)null);
        return mav;
    }

    public ModelAndView componentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/componentPage");
        String _affairId = request.getParameter("affairId");
        String _rightId = request.getParameter("rightId");
        String readonly = request.getParameter("readonly");
        String openFrom = request.getParameter("openFrom");
        String isRecSendRel = request.getParameter("isRecSendRel");
        String isHistoryFlag = request.getParameter("isHistoryFlag");
        boolean _isHistoryFlag = Strings.isBlank(isHistoryFlag) ? false : Boolean.valueOf(isHistoryFlag);
        mav.addObject("isHasPraise", request.getParameter("isHasPraise"));
        if (String.valueOf(workflowTrackType.step_back_repeal.getKey()).equals(request.getParameter("trackType")) && "stepBackRecord".equals(openFrom)) {
            openFrom = "repealRecord";
        }

        CtpAffair affair = null;
        ColSummary summary = null;
        if (_isHistoryFlag) {
            affair = this.affairManager.getByHis(Long.valueOf(_affairId));
            summary = this.colManager.getColSummaryByIdHistory(affair.getObjectId());
        } else {
            affair = this.affairManager.get(Long.valueOf(_affairId));
            summary = this.colManager.getColSummaryById(affair.getObjectId());
        }

        String formAppid = request.getParameter("formAppid");
        User user = AppContext.getCurrentUser();
        mav.addObject("moduleId", summary.getId().toString());
        mav.addObject("affair", affair);
        boolean signatrueShowFlag = Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState()) && "listPending".equals(openFrom);
        mav.addObject("canMoveISignature", signatrueShowFlag);
        mav.addObject("canDeleteISigntureHtml", signatrueShowFlag);
        mav.addObject("isShowMoveMenu", signatrueShowFlag);
        mav.addObject("isShowDocLockMenu", signatrueShowFlag);
        boolean isFormQuery = ColOpenFrom.formQuery.name().equals(openFrom);
        boolean isFormStatistical = ColOpenFrom.formStatistical.name().equals(openFrom);
        boolean ifFromstepBackRecord = ColOpenFrom.stepBackRecord.name().equalsIgnoreCase(openFrom);
        boolean isFromrepealRecord = ColOpenFrom.repealRecord.name().equalsIgnoreCase(openFrom);
        boolean isEdocStatics = "edocStatics".equals(openFrom);
        boolean isGlwd = ColOpenFrom.glwd.name().equals(openFrom);
        boolean isGovLenPotent = "lenPotent".endsWith(openFrom) && "1".equals(request.getParameter("isGovArchive"));
        if ("1".equals(isRecSendRel)) {
            isGlwd = true;
        }

        Map<String, Object> affairExtMap = AffairUtil.getExtProperty(affair);
        if (affairExtMap != null) {
            String isTakeback = affairExtMap.get(AffairExtPropEnums.edoc_lastOperateState.name()) == null ? "" : String.valueOf(affairExtMap.get(AffairExtPropEnums.edoc_lastOperateState.name()));
            if (Strings.isNotBlank(isTakeback)) {
                mav.addObject("isTakeback", 1);
            }
        }

        ApplicationCategoryEnum moduleType = ApplicationCategoryEnum.collaboration;
        if (!isFormQuery && !isFormStatistical && !ifFromstepBackRecord && !isFromrepealRecord && !isEdocStatics && !isGlwd && !isGovLenPotent) {
            if ("20".equals(summary.getBodyType())) {
                moduleType = ApplicationCategoryEnum.edoc;
                if (summary.getGovdocType() != null) {
                    moduleType = ApplicationCategoryEnum.collaboration;
                }
            }

            if (!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), moduleType, user, affair.getObjectId(), affair, summary.getArchiveId())) {
                return null;
            }
        }

        int viewState = 2;
        if (String.valueOf(MainbodyType.FORM.getKey()).equals(String.valueOf(affair.getBodyType())) && Integer.valueOf(StateEnum.col_pending.key()).equals(affair.getState()) && !"inform".equals(ColUtil.getPolicyByAffair(affair).getId()) && !"glwd".equals(openFrom) && !"listDone".equals(openFrom) && (affair.getApp() == ApplicationCategoryEnum.edoc.getKey() || affair.getApp() != ApplicationCategoryEnum.edoc.getKey() && !AffairUtil.isFormReadonly(affair))) {
            viewState = 1;
        }

        ContentUtil.contentViewForDetail(ModuleType.collaboration, summary.getId(), affair.getId(), viewState, _rightId, _isHistoryFlag);
        mav.addObject("_viewState", Integer.valueOf(viewState));
        List<Comment> commentList = (List)request.getAttribute("commentList");
        if (CollectionUtils.isNotEmpty(commentList)) {
            Iterator var28 = commentList.iterator();

            while(var28.hasNext()) {
                Comment comment = (Comment)var28.next();
                comment.setPolicyName("");
                if (comment.getAffairId() != null) {
                    CtpAffair aff = this.colManager.getAffairById(comment.getAffairId());
                    String configItem = ColUtil.getPolicyByAffair(aff).getName();
                    comment.setPolicyName(configItem);
                }
            }

            request.setAttribute("commentList", commentList);
        }

        List<CtpContentAllBean> contentList = (List)request.getAttribute("contentList");
        request.setAttribute("contentList", contentList);
        if (summary.getParentformSummaryid() != null && !summary.getCanEdit()) {
            mav.addObject("isFromTransform", true);
        }

        List memberIds;
        if ("repealRecord".equals(openFrom)) {
            List<WorkflowTracePO> dataByParams = this.traceWorkflowManager.getDataByModuleIdAndAffairId(summary.getId(), affair.getId());
            Long currentUserId = AppContext.currentUserId();
            if (dataByParams != null && dataByParams.size() > 0) {
                boolean _flag = true;
                memberIds = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());

                for(int a = 0; a < dataByParams.size(); ++a) {
                    if (((WorkflowTracePO)dataByParams.get(a)).getMemberId().equals(currentUserId)) {
                        if (Strings.isNotEmpty(memberIds) && Strings.isNotBlank(((WorkflowTracePO)dataByParams.get(a)).getFormContent())) {
                            ((CtpContentAll)memberIds.get(0)).setContent(((WorkflowTracePO)dataByParams.get(a)).getFormContent());
                            this.ctpMainbodyManager.saveOrUpdateContentAll((CtpContentAll)memberIds.get(0));
                            _flag = false;
                        }
                        break;
                    }
                }

                if (_flag && Strings.isNotEmpty(memberIds) && Strings.isNotBlank(((WorkflowTracePO)dataByParams.get(0)).getFormContent())) {
                    ((CtpContentAll)memberIds.get(0)).setContent(((WorkflowTracePO)dataByParams.get(0)).getFormContent());
                    this.ctpMainbodyManager.saveOrUpdateContentAll((CtpContentAll)memberIds.get(0));
                }
            }
        }

        if (summary.getGovdocType() == null) {
            mav.addObject("_moduleType", ModuleType.collaboration.getKey());
        } else {
            mav.addObject("isGovdocForm", 1);
            mav.addObject("_moduleType", ModuleType.edoc.getKey());
            ConfigItem govdocItem = this.configManager.getConfigItem("govdoc_switch", "govdocview", AppContext.getCurrentUser().getAccountId());
            if (govdocItem != null && govdocItem.getConfigValue().equals("yes")) {
                mav.addObject("newGovdocView", 1);
            }
        }

        mav.addObject("_rightId", _rightId);
        mav.addObject("_moduleId", summary.getId());
        mav.addObject("_contentType", summary.getBodyType());
        ContentViewRet ret = (ContentViewRet)request.getAttribute("contentContext");
        request.setAttribute("isChangeOpinion", this.govdocOpenManager.hasEditAuth(user.getId(), user.getAccountId()));
        String workflowTraceType = request.getParameter("trackType");
        Integer _workflowTraceType = Strings.isNotBlank(workflowTraceType) ? Integer.valueOf(workflowTraceType) : 0;
        if (Integer.valueOf(workflowTrackType.repeal.getKey()).equals(_workflowTraceType) || Integer.valueOf(workflowTrackType.step_back_repeal.getKey()).equals(_workflowTraceType)) {
            readonly = "true";
        }

        if (Boolean.valueOf(readonly) || "edocStatics".equals(openFrom)) {
            ret.setCanReply(false);
        }

        if (ColOpenFrom.formQuery.name().equals(openFrom) || ColOpenFrom.formStatistical.name().equals(openFrom)) {
            AppContext.putThreadContext("THREAD_CTX_NO_HIDDEN_COMMENT", "true");
        }

        AppContext.putThreadContext("THREAD_CTX_NOT_HIDE_TO_ID_KEY", summary.getStartMemberId());
        if (!ColOpenFrom.supervise.name().equals(openFrom) && !ColOpenFrom.repealRecord.name().equals(openFrom)) {
            AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", affair.getMemberId());
        }

        if (ColOpenFrom.glwd.name().equals(openFrom)) {
            memberIds = this.affairManager.getMemberIdListByAppAndObjectId(ApplicationCategoryEnum.collaboration, summary.getId());
            AppContext.putThreadContext("THREAD_CTX_PROCESS_MEMBERS", Strings.isNotEmpty(memberIds) ? memberIds : new ArrayList());
        }

        if (Integer.valueOf(flowState.finish.ordinal()).equals(summary.getState()) || Integer.valueOf(flowState.terminate.ordinal()).equals(summary.getState()) || ColOpenFrom.glwd.name().equals(openFrom) || Boolean.valueOf(readonly)) {
            mav.addObject("_isffin", "1");
        }

        Long accountId = summary.getOrgAccountId() == null ? user.getLoginAccount() : summary.getOrgAccountId();
        boolean taohongriqiSwitch = EdocSwitchHelper.taohongriqiSwitch(accountId);
        mav.addObject("taohongriqiSwitch", taohongriqiSwitch);
        mav.addObject("title", summary.getSubject());
        mav.addObject("openFrom", openFrom);
        mav.addObject("templateId", request.getParameter("templateId"));
        mav.addObject("formAppid", request.getParameter("formAppid"));
        ret.setContentSenderId(summary.getStartMemberId());
        return mav;
    }

    public ModelAndView newCommentPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("common/content/contentDealTpl/default_govdoc_comment");
        String _affairId = request.getParameter("affairId");
        String _rightId = request.getParameter("rightId");
        String readonly = request.getParameter("readonly");
        String openFrom = request.getParameter("openFrom");
        String isRecSendRel = request.getParameter("isRecSendRel");
        String isHistoryFlag = request.getParameter("isHistoryFlag");
        boolean _isHistoryFlag = Strings.isBlank(isHistoryFlag) ? false : Boolean.valueOf(isHistoryFlag);
        mav.addObject("isHasPraise", request.getParameter("isHasPraise"));
        if (String.valueOf(workflowTrackType.step_back_repeal.getKey()).equals(request.getParameter("trackType")) && "stepBackRecord".equals(openFrom)) {
            openFrom = "repealRecord";
        }

        CtpAffair affair = null;
        ColSummary summary = null;
        if (_isHistoryFlag) {
            affair = this.affairManager.getByHis(Long.valueOf(_affairId));
            summary = this.colManager.getColSummaryByIdHistory(affair.getObjectId());
        } else {
            affair = this.affairManager.get(Long.valueOf(_affairId));
            summary = this.colManager.getColSummaryById(affair.getObjectId());
        }

        String formAppid = request.getParameter("formAppid");
        User user = AppContext.getCurrentUser();
        mav.addObject("moduleId", summary.getId().toString());
        mav.addObject("affair", affair);
        boolean signatrueShowFlag = Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState()) && "listPending".equals(openFrom);
        mav.addObject("canMoveISignature", signatrueShowFlag);
        mav.addObject("canDeleteISigntureHtml", signatrueShowFlag);
        mav.addObject("isShowMoveMenu", signatrueShowFlag);
        mav.addObject("isShowDocLockMenu", signatrueShowFlag);
        boolean isFormQuery = ColOpenFrom.formQuery.name().equals(openFrom);
        boolean isFormStatistical = ColOpenFrom.formStatistical.name().equals(openFrom);
        boolean ifFromstepBackRecord = ColOpenFrom.stepBackRecord.name().equalsIgnoreCase(openFrom);
        boolean isFromrepealRecord = ColOpenFrom.repealRecord.name().equalsIgnoreCase(openFrom);
        boolean isEdocStatics = "edocStatics".equals(openFrom);
        boolean isGlwd = ColOpenFrom.glwd.name().equals(openFrom);
        boolean var10000;
        if ("lenPotent".endsWith(openFrom) && "1".equals(request.getParameter("isGovArchive"))) {
            var10000 = true;
        } else {
            var10000 = false;
        }

        if ("1".equals(isRecSendRel)) {
            isGlwd = true;
        }

        int viewState = 2;
        if (String.valueOf(MainbodyType.FORM.getKey()).equals(String.valueOf(affair.getBodyType())) && Integer.valueOf(StateEnum.col_pending.key()).equals(affair.getState()) && !"inform".equals(ColUtil.getPolicyByAffair(affair).getId()) && !"glwd".equals(openFrom) && !"listDone".equals(openFrom) && (affair.getApp() == ApplicationCategoryEnum.edoc.getKey() || affair.getApp() != ApplicationCategoryEnum.edoc.getKey() && !AffairUtil.isFormReadonly(affair))) {
            viewState = 1;
        }

        ContentUtil.contentViewForDetail(ModuleType.collaboration, summary.getId(), affair.getId(), viewState, _rightId, _isHistoryFlag);
        List<Comment> commentList = (List)request.getAttribute("commentList");
        if (CollectionUtils.isNotEmpty(commentList)) {
            Iterator var26 = commentList.iterator();

            while(var26.hasNext()) {
                Comment comment = (Comment)var26.next();
                comment.setPolicyName("");
                if (comment.getAffairId() != null) {
                    CtpAffair aff = this.colManager.getAffairById(comment.getAffairId());
                    String configItem = ColUtil.getPolicyByAffair(aff).getName();
                    comment.setPolicyName(configItem);
                }
            }

            request.setAttribute("commentList", commentList);
        }

        List<CtpContentAllBean> contentList = (List)request.getAttribute("contentList");
        request.setAttribute("contentList", contentList);
        if (summary.getParentformSummaryid() != null && !summary.getCanEdit()) {
            mav.addObject("isFromTransform", true);
        }

        if (summary.getGovdocType() == null) {
            mav.addObject("_moduleType", ModuleType.collaboration.getKey());
        } else {
            mav.addObject("isGovdocForm", 1);
            mav.addObject("_moduleType", ModuleType.edoc.getKey());
            mav.addObject("newGovdocView", 1);
        }

        mav.addObject("_rightId", _rightId);
        mav.addObject("_moduleId", summary.getId());
        mav.addObject("_contentType", summary.getBodyType());
        ContentViewRet ret = (ContentViewRet)request.getAttribute("contentContext");
        request.setAttribute("isChangeOpinion", this.govdocOpenManager.hasEditAuth(user.getId(), user.getAccountId()));
        String workflowTraceType = request.getParameter("trackType");
        Integer _workflowTraceType = Strings.isNotBlank(workflowTraceType) ? Integer.valueOf(workflowTraceType) : 0;
        if (Integer.valueOf(workflowTrackType.repeal.getKey()).equals(_workflowTraceType) || Integer.valueOf(workflowTrackType.step_back_repeal.getKey()).equals(_workflowTraceType)) {
            readonly = "true";
        }

        if (Boolean.valueOf(readonly) || "edocStatics".equals(openFrom)) {
            ret.setCanReply(false);
        }

        if (ColOpenFrom.formQuery.name().equals(openFrom) || ColOpenFrom.formStatistical.name().equals(openFrom)) {
            AppContext.putThreadContext("THREAD_CTX_NO_HIDDEN_COMMENT", "true");
        }

        AppContext.putThreadContext("THREAD_CTX_NOT_HIDE_TO_ID_KEY", summary.getStartMemberId());
        if (!ColOpenFrom.supervise.name().equals(openFrom) && !ColOpenFrom.repealRecord.name().equals(openFrom)) {
            AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", affair.getMemberId());
        }

        if (ColOpenFrom.glwd.name().equals(openFrom)) {
            List<Long> memberIds = this.affairManager.getMemberIdListByAppAndObjectId(ApplicationCategoryEnum.collaboration, summary.getId());
            AppContext.putThreadContext("THREAD_CTX_PROCESS_MEMBERS", Strings.isNotEmpty(memberIds) ? memberIds : new ArrayList());
        }

        if (Integer.valueOf(flowState.finish.ordinal()).equals(summary.getState()) || Integer.valueOf(flowState.terminate.ordinal()).equals(summary.getState()) || ColOpenFrom.glwd.name().equals(openFrom) || Boolean.valueOf(readonly)) {
            mav.addObject("_isffin", "1");
        }

        Long accountId = summary.getOrgAccountId() == null ? user.getLoginAccount() : summary.getOrgAccountId();
        boolean taohongriqiSwitch = EdocSwitchHelper.taohongriqiSwitch(accountId);
        mav.addObject("taohongriqiSwitch", taohongriqiSwitch);
        mav.addObject("title", summary.getSubject());
        mav.addObject("openFrom", openFrom);
        mav.addObject("templateId", request.getParameter("templateId"));
        mav.addObject("formAppid", request.getParameter("formAppid"));
        ret.setContentSenderId(summary.getStartMemberId());
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
        long affairId = Long.valueOf(request.getParameter("affairId"));
        this.colManager.saveOpinionDraft(affairId, summaryId);
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
        String _userId = request.getParameter("user_id");
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
        mav.addObject("user_id", _userId);
        mav.addObject("coverTime", coverTime);
        mav.addObject("isGroup", isGroup);
        return mav;
    }

    public ModelAndView openTrackDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/trackDetail");
        String _objectId = request.getParameter("objectId");
        String _affairId = request.getParameter("affairId");
        ColSummary summary = this.colManager.getColSummaryById(Long.valueOf(_objectId));
        if (summary == null) {
            EdocSummary edocSummary = this.edocManager.getEdocSummaryById(Long.valueOf(_objectId), false);
            summary = new ColSummary();
            summary.setStartMemberId(edocSummary.getStartMember().getId());
            summary.setState(edocSummary.getState());
        }

        CtpAffair affair = this.affairManager.get(Long.valueOf(_affairId));
        int trackType = affair.getTrack();
        Long startMemberId = summary.getStartMemberId();
        int state = summary.getState();
        if (trackType == 2) {
            List<CtpTrackMember> trackList = this.trackManager.getTrackLisByAffairId(Long.valueOf(_affairId));
            String zdgzrStr = "";
            StringBuffer sb = new StringBuffer();
            int a = 0;

            for(int j = trackList.size(); a < j; ++a) {
                CtpTrackMember cm = (CtpTrackMember)trackList.get(a);
                sb.append("Member|" + cm.getTrackMemberId() + ",");
            }

            zdgzrStr = sb.toString();
            if (Strings.isNotBlank(zdgzrStr)) {
                mav.addObject("zdgzrStr", zdgzrStr.substring(0, zdgzrStr.length() - 1));
            }
        }

        mav.addObject("objectId", _objectId);
        mav.addObject("affairId", _affairId);
        mav.addObject("trackType", trackType);
        mav.addObject("state", state);
        mav.addObject("startMemberId", startMemberId);
        mav.addObject("secretLevel", affair.getSecretLevel());
        return mav;
    }

    private Map<String, String> getStatisticSearchCondition(FlipInfo fi, HttpServletRequest request) {
        Map<String, String> query = new HashMap();
        User user = AppContext.getCurrentUser();
        if (user == null) {
            return query;
        } else {
            String _bodyType = request.getParameter("bodyType");
            if (Strings.isNotBlank(_bodyType)) {
                query.put(ColQueryCondition.bodyType.name(), _bodyType);
            }

            String _collType = request.getParameter("CollType");
            if (Strings.isNotBlank(_collType)) {
                query.put(ColQueryCondition.CollType.name(), _collType);
            }

            String _templateId = request.getParameter("templateId");
            if (Strings.isNotBlank(_templateId) && _templateId != "null") {
                query.put(ColQueryCondition.templeteIds.name(), _templateId);
            }

            String _state = request.getParameter("state");
            List<Integer> states = new ArrayList();
            String s;
            if (Strings.isNotBlank(_state) && _state != "null") {
                String[] stateStrs = _state.split(",");
                String[] var14 = stateStrs;
                int var13 = stateStrs.length;

                for(int var12 = 0; var12 < var13; ++var12) {
                    s = var14[var12];
                    states.add(new Integer(s));
                }

                if (states.contains(1)) {
                    query.put(ColQueryCondition.archiveId.name(), "archived");
                    states.remove(states.indexOf(1));
                }

                if (states.contains(0)) {
                    query.put(ColQueryCondition.subState.name(), String.valueOf(SubStateEnum.col_pending_ZCDB.getKey()));
                    states.remove(states.indexOf(0));
                }

                if (states.size() > 0) {
                    _state = Functions.join(states, ",");
                    query.put(ColQueryCondition.state.name(), _state);
                }
            }

            String _startTime = request.getParameter("start_time");
            s = request.getParameter("end_time");
            String queryTime = "";
            if (Strings.isEmpty(_startTime) && Strings.isEmpty(s)) {
                queryTime = null;
            } else {
                queryTime = _startTime + "#" + s;
            }

            if (Strings.isNotBlank(queryTime)) {
                if (states.size() == 1) {
                    if (Integer.valueOf(StateEnum.col_sent.getKey()).equals(states.get(0))) {
                        query.put(ColQueryCondition.createDate.name(), queryTime);
                    } else if (Integer.valueOf(StateEnum.col_pending.getKey()).equals(states.get(0))) {
                        query.put(ColQueryCondition.receiveDate.name(), queryTime);
                    } else if (Integer.valueOf(StateEnum.col_done.getKey()).equals(states.get(0))) {
                        query.put(ColQueryCondition.completeDate.name(), queryTime);
                    }
                } else if (String.valueOf(SubStateEnum.col_pending_ZCDB.getKey()).equals(query.get(ColQueryCondition.subState.name()))) {
                    query.put(ColQueryCondition.updateDate.name(), queryTime);
                }

                if ("archived".equals(query.get(ColQueryCondition.archiveId.name())) || states.size() > 1) {
                    query.put("statisticDate", queryTime);
                }
            }

            String _coverTime = request.getParameter("coverTime");
            if (Strings.isNotBlank(_coverTime)) {
                query.put(ColQueryCondition.coverTime.name(), _coverTime);
            }

            String _userId = request.getParameter("user_id");
            if (Strings.isNotBlank(_userId)) {
                query.put(ColQueryCondition.currentUser.name(), _userId);
            }

            query.put("statistic", "true");
            String isGroup = request.getParameter("isGroup");
            if (Strings.isNotBlank(isGroup)) {
                query.put("isTeamReport", isGroup);
            }

            fi.setParams(query);
            return query;
        }
    }

    public ModelAndView findAttachmentListBuSummaryId(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mv = new ModelAndView("apps/collaboration/attachmentList");
        String summaryId = request.getParameter("summaryId");
        String memberId = request.getParameter("memberId");
        String typeFlag = request.getParameter("typeFlag");
        if ("edocFlag".equals(typeFlag)) {
            List<AttachmentVO> attachmentVOs = this.edocManager.getAttachmentListBySummaryId(Long.valueOf(summaryId), AppContext.getCurrentUser().getId());
            mv.addObject("attachmentVOs", attachmentVOs);
            mv.addObject("attSize", attachmentVOs.size());
            return mv;
        } else {
            String _openFrom = request.getParameter("openFromList");
            if (!ColOpenFrom.supervise.name().equals(_openFrom) && Strings.isNotBlank(memberId)) {
                AppContext.putThreadContext("THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID", Long.valueOf(memberId));
            }

            List<AttachmentVO> attachmentVOs = this.colManager.getAttachmentListBySummaryId(Long.valueOf(summaryId), Long.valueOf(memberId));
            mv.addObject("attachmentVOs", attachmentVOs);
            mv.addObject("attSize", attachmentVOs.size());
            return mv;
        }
    }

    public ModelAndView reportForwardColl(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = CollaborationService.appToColl(request.getParameter("reportTitle"), ModuleType.collaboration.getKey(), new Date(), request.getParameter("reportContent"), (List)null, false, (Long)null, (Long)null, "report");
        return mav;
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
            String excelName = ResourceUtil.getString("performanceReport.queryMain_js.throughQueryDialog.title");
            dataRecord.setTitle(excelName);
            dataRecord.setSheetName(excelName);
            dataRecord.setColumnName(columnName);

            for(int i = 0; i < colList.size(); ++i) {
                ColSummaryVO data = (ColSummaryVO)colList.get(i);
                DataRow dataRow = new DataRow();
                dataRow.addDataCell(data.getSubject(), 1);
                dataRow.addDataCell(data.getStartMemberName(), 1);
                dataRow.addDataCell(data.getStartDate() != null ? Datetimes.format(data.getStartDate(), "yyyy-MM-dd HH:mm").toString() : "-", 5);
                dataRow.addDataCell(data.getReceiveTime() != null ? Datetimes.format(data.getReceiveTime(), "yyyy-MM-dd HH:mm").toString() : "-", 5);
                dataRow.addDataCell(data.getDealTime() != null ? Datetimes.format(data.getDealTime(), "yyyy-MM-dd HH:mm").toString() : "-", 5);
                dataRow.addDataCell(data.getDeadLineDateName(), 1);
                dataRow.addDataCell(data.getTrack() == 1 ? ResourceUtil.getString("message.yes.js") : ResourceUtil.getString("message.no.js"), 1);
                dataRecord.addDataRow(new DataRow[]{dataRow});
            }

            this.fileToExcelManager.save(response, dataRecord.getTitle(), new DataRecord[]{dataRecord});
        } catch (Exception var19) {
            this.logger.error("为用户绩效报表穿透查询列表时出现异常:", var19);
        }

        return null;
    }

    public ModelAndView combinedQuery(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/col_com_query");
        if ("templeteAll".equals(request.getParameter("condition")) && "all".equals(request.getParameter("textfield"))) {
            modelAndView.addObject("condition1", "1");
        }

        if ("bizcofnig".equals(request.getParameter("srcFrom"))) {
            modelAndView.addObject("condition2", "1");
        }

        if ("1".equals(request.getParameter("bisnissMap"))) {
            modelAndView.addObject("condition3", "1");
        }

        if ("templeteCategorys".equals(request.getParameter("condition"))) {
            modelAndView.addObject("condition4", "1");
        }

        modelAndView.addObject("openForm", request.getParameter("openForm"));
        return modelAndView;
    }

    public ModelAndView showDistributeState(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/showDistributeState");
        String summaryId = request.getParameter("summaryId");
        modelAndView.addObject("summaryId", summaryId);
        String exchangeStatus = request.getParameter("exchangeStatus");
        modelAndView.addObject("exchangeStatus", exchangeStatus);
        boolean chuantouchakan1 = SystemProperties.getInstance().getProperty("govdocConfig.chuantouchakan1").equals("true");
        modelAndView.addObject("chuantouchakan1", chuantouchakan1);

        try {
            Map<String, Object> conditionMap = new HashMap();
            conditionMap.put("summaryId", summaryId);
            if (StringUtils.isNotBlank(exchangeStatus)) {
                conditionMap.put("status", exchangeStatus);
            }

            FlipInfo fi = this.govdocExchangeManager.getGovdocExchangeDetail(new FlipInfo(), conditionMap);
            request.setAttribute("ffexchangeDetail", fi);
        } catch (Exception var9) {
            LOGGER.error("获取分送状态初始化列表数据出错 ", var9);
        }

        return modelAndView;
    }

    public ModelAndView initCount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String summaryId = request.getParameter("summaryId");
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        Map<String, Object> result = new HashMap();
        PrintWriter out = response.getWriter();
        List<Object[]> reCountDetail = this.govdocExchangeManager.checkGovdocExchangeDetailCount(Long.valueOf(summaryId));
        if (reCountDetail != null && reCountDetail.size() > 0) {
            Object[] data = (Object[])reCountDetail.get(0);
            result.put("totalCount", data[0]);
            result.put("sendCount", data[1]);
            result.put("waitSignCount", data[2]);
            result.put("backCount", data[3]);
        }

        out.print(JSONObject.fromObject(result));
        out.close();
        return null;
    }

    public ModelAndView reSend(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String detailId = request.getParameter("detailId");
        PrintWriter out = response.getWriter();
        GovdocExchangeDetail govdocExchangeDetail = this.govdocExchangeManager.getById(Long.parseLong(detailId));
        GovdocExchangeMain govdocExchangeMain = this.govdocExchangeManager.findMainById(govdocExchangeDetail.getMainId());
        govdocExchangeDetail.setStatus(ExchangeDetailStatus.waitSend.getKey());
        govdocExchangeDetail.setCreateTime(new Date());
        govdocExchangeDetail.setRecNo("");
        govdocExchangeDetail.setRecTime((Date)null);
        govdocExchangeDetail.setRecUserName("");
        List<GovdocExchangeDetail> detailList = new ArrayList();
        detailList.add(govdocExchangeDetail);
        if (govdocExchangeMain.getType() == 1) {
            GovdocTemplateDepAuthManager ctpTemplateDepAuthManager = (GovdocTemplateDepAuthManager)AppContext.getBean("govdocTemplateDepAuthManager");
            long orgId = Long.parseLong(govdocExchangeDetail.getRecOrgId());
            List<GovdocTemplateDepAuth> ctpTemplateDepAuths = ctpTemplateDepAuthManager.findByOrgIdAndAccountId4Lianhe(orgId, orgId);
            if (ctpTemplateDepAuths == null || ctpTemplateDepAuths.size() < 1) {
                out.print("0");
                out.close();
                return null;
            }

            CtpTemplate ctpTemplate = TemplateService.getCtpTemplate(((GovdocTemplateDepAuth)ctpTemplateDepAuths.get(0)).getTemplateId());
            if (ctpTemplate == null || ctpTemplate.getState() != 0 || ctpTemplate.isDelete()) {
                out.print("0");
                out.close();
                return null;
            }
        }

        this.govdocExchangeManager.saveToGovdocExchange(detailList, govdocExchangeMain);
        out.print("1");
        out.close();
        return null;
    }

    public ModelAndView createReissue(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String summaryId = request.getParameter("summaryId");
        PrintWriter out = response.getWriter();
        List<GovdocExchangeMain> mainList = this.govdocExchangeManager.findMainBySummaryId4Exchange(Long.parseLong(summaryId));
        if (mainList != null && mainList.size() > 0) {
            GovdocExchangeMain govdocExchangeMain = (GovdocExchangeMain)mainList.get(0);
            if (!govdocExchangeMain.isCanSend()) {
                out.print("0");
                out.close();
                return null;
            }

            ColSummary summary = this.colManager.getSummaryById(govdocExchangeMain.getSummaryId());
            String danwei = request.getParameter("danwei");
            FormDataMasterBean formDataMasterBean = FormService.findDataById(summary.getFormRecordid(), summary.getFormAppid(), (String[])null);
            String xml = GovDocUtil.formDataBeanToXML(formDataMasterBean, govdocExchangeMain.getType());
            if (danwei != null && !"".equals(danwei.trim())) {
                String[] ids = danwei.split(",");
                String sendUnitName = "";
                Iterator var14 = FormService.getForm(summary.getFormAppid()).getAllFieldBeans().iterator();

                while(var14.hasNext()) {
                    FormFieldBean fieldBean = (FormFieldBean)var14.next();
                    if ("send_unit".equals(fieldBean.getMappingField())) {
                        sendUnitName = fieldBean.getName();
                        break;
                    }
                }

                Map params = new HashMap();
                params.put("send_unit", formDataMasterBean.getFieldValue(sendUnitName));
                boolean flag = this.addToGovdoc(ids, xml, formDataMasterBean, summary, govdocExchangeMain, (Long)null, params);
                if (flag) {
                    out.print("1");
                }
            }
        }

        out.close();
        return null;
    }

    public ModelAndView showLog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/showLog");
        String detailId = request.getParameter("detailId");
        modelAndView.addObject("detailId", detailId);
        modelAndView.addObject("from", request.getParameter("from"));
        return modelAndView;
    }

    public ModelAndView forRevokeGetParams(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String summaryId = request.getParameter("summaryId");
        String summaryIds = request.getParameter("summaryIds");
        boolean onlyOne = false;
        if (summaryId != null) {
            onlyOne = true;
            summaryIds = summaryId;
        }

        boolean onlyOneAffair = false;
        List<String> processId = new ArrayList();
        List<String> affairId = new ArrayList();
        List<String> startAffairId = new ArrayList();
        List<String> validSummaryId = new ArrayList();
        List<String> error = new ArrayList();
        if (StringUtils.isNotBlank(summaryIds)) {
            String[] split = summaryIds.split(",");
            if (ArrayUtils.isNotEmpty(split)) {
                String[] var16 = split;
                int var15 = split.length;

                for(int var14 = 0; var14 < var15; ++var14) {
                    String id = var16[var14];
                    List<CtpAffair> affairs = this.affairManager.getAffairsByAppAndObjectId(ApplicationCategoryEnum.edoc, Long.valueOf(id));
                    CtpAffair pendingaffair = null;
                    CtpAffair startaffair = null;
                    if (affairs != null && affairs.size() > 0) {
                        Iterator var21 = affairs.iterator();

                        label69:
                        while(true) {
                            while(true) {
                                if (!var21.hasNext()) {
                                    break label69;
                                }

                                CtpAffair a = (CtpAffair)var21.next();
                                if (a.getState() == StateEnum.col_pending.getKey()) {
                                    pendingaffair = a;
                                } else if (a.getState() == StateEnum.col_sent.getKey() || a.getState() == StateEnum.col_waitSend.getKey()) {
                                    startaffair = a;
                                }
                            }
                        }
                    }

                    ColSummary summary = this.colManager.getColSummaryById(Long.valueOf(id));
                    if (pendingaffair != null && summary != null) {
                        processId.add(summary.getProcessId());
                        affairId.add(pendingaffair.getId().toString());
                        startAffairId.add(startaffair.getId().toString());
                        validSummaryId.add(id);
                    } else if (startaffair != null && affairs.size() == 1) {
                        onlyOneAffair = true;
                        processId.add(summary.getProcessId());
                        affairId.add(startaffair.getId().toString());
                        startAffairId.add(startaffair.getId().toString());
                        validSummaryId.add(id);
                    } else {
                        error.add(id);
                    }

                    List<GovdocExchangeDetail> govdocExchangeDetails = this.govdocExchangeManager.findDetailBySummaryId(Long.parseLong(id));
                    if (govdocExchangeDetails != null && govdocExchangeDetails.size() > 0 && ((GovdocExchangeDetail)govdocExchangeDetails.get(0)).getStatus() != ExchangeDetailStatus.waitSign.getKey() && ((GovdocExchangeDetail)govdocExchangeDetails.get(0)).getStatus() != ExchangeDetailStatus.beingProcessed.getKey()) {
                        error.add(id);
                    }
                }
            }
        }

        response.setHeader("Content-type", "text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, String> result = new HashMap();
        if (processId.size() > 0) {
            result.put("processId", StringUtils.join(processId, ","));
            result.put("affairId", StringUtils.join(affairId, ","));
            result.put("startAffairId", StringUtils.join(startAffairId, ","));
            result.put("validSummaryId", StringUtils.join(validSummaryId, ","));
            result.put("onlyOneAffair", String.valueOf(onlyOneAffair));
        }

        if (CollectionUtils.isNotEmpty(error)) {
            if (onlyOne) {
                out.print("error");
            } else {
                result.put("error", StringUtils.join(error, ","));
                out.print(JSONObject.fromObject(result));
            }
        } else {
            out.print(JSONObject.fromObject(result));
        }

        out.close();
        return null;
    }

    public ModelAndView revoke(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String summaryId = request.getParameter("summaryId");
        if (StringUtils.isNotBlank(summaryId)) {
            String[] ids = summaryId.split(",");
            String[] var8 = ids;
            int var7 = ids.length;

            for(int var6 = 0; var6 < var7; ++var6) {
                String id = var8[var6];
                this.indexManager.update(Long.parseLong(id), ApplicationCategoryEnum.govdoc.key());
            }
        }

        return null;
    }

    public ModelAndView forwardSummary4Content(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("ctp/common/fileUpload/upload");
        String forwardSummaryId = request.getParameter("forwardSummaryId");
        if (Strings.isNotBlank(forwardSummaryId)) {
            List<Attachment> atts = new ArrayList();
            List<CtpContentAll> ctpContentAlls = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.edoc, Long.parseLong(forwardSummaryId));
            Iterator var8 = ctpContentAlls.iterator();

            while(var8.hasNext()) {
                CtpContentAll contentAll = (CtpContentAll)var8.next();
                if (contentAll.getModuleType() == 4 && contentAll.getContentType() != 10) {
                    V3XFile file = this.fileManager.getV3XFile(Long.valueOf(contentAll.getContent()));
                    if (Strings.isNotBlank(contentAll.getContent())) {
                        Attachment att = new Attachment(file, ApplicationCategoryEnum.edoc, ATTACHMENT_TYPE.FILE);
                        atts.add(att);
                        this.attachmentManager.create(atts);
                        break;
                    }
                }
            }

            modelAndView.addObject("atts", atts);
        }

        return modelAndView;
    }

    public ModelAndView toTurnRecEdoc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("govdoc/turnRecEdoc");
        modelAndView.addObject("summaryId", request.getParameter("summaryId"));
        return modelAndView;
    }

    public ModelAndView doTurnRecEdoc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long affairId = Long.valueOf(request.getParameter("affairId"));
        String unitId = request.getParameter("unitId");
        String opinion = request.getParameter("opinion");
        CtpAffair affair = this.affairManager.get(affairId);
        ColSummary colSummary = this.colManager.getColSummaryById(affair.getObjectId());
        Map<String, Object> params = new HashMap();
        params.put("opinion", opinion);
        this.exchangeGovdoc(colSummary, affairId, unitId, 2, params);
        return null;
    }

    public ModelAndView getTurnRecEdocInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("govdoc/turnRecEdocInfo");
        String mainIds = request.getParameter("mainIds");
        modelAndView.addObject("mainIds", mainIds);
        modelAndView.addObject("chuantouchakan2", request.getParameter("chuantouchakan2"));
        return modelAndView;
    }

    public ModelAndView getTurnRecEdocInfo2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("govdoc/turnRecEdocInfo2");
        String detailId = request.getParameter("detailId");
        GovdocExchangeDetail detail = this.govdocExchangeManager.getById(Long.valueOf(detailId));
        GovdocExchangeMain main = this.govdocExchangeManager.findMainById(detail.getMainId());
        modelAndView.addObject("opinion", detail.getOpinion());
        modelAndView.addObject("createDate", DateUtil.getDate(main.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));
        V3xOrgMember member = this.orgManager.getMemberById(main.getStartUserId());
        modelAndView.addObject("createUnit", this.orgManager.getAccountById(member.getOrgAccountId()).getName());
        modelAndView.addObject("summaryId", main.getSummaryId());
        modelAndView.addObject("chuantouchakan2", SystemProperties.getInstance().getProperty("govdocConfig.chuantouchakan2").equals("true"));
        return modelAndView;
    }

    public ModelAndView edocQuickSendUnit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("govdoc/edocQuickSendUnit");
        return mav;
    }

    public ModelAndView toTurnSendEdocInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("govdoc/turnSendEdocInfo");
        modelAndView.addObject("referenceId", request.getParameter("referenceId"));
        modelAndView.addObject("type", request.getParameter("type"));
        return modelAndView;
    }

    public ModelAndView toExchangeEdocInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("govdoc/exchangeEdocInfo");
        modelAndView.addObject("referenceId", request.getParameter("referenceId"));
        modelAndView.addObject("type", request.getParameter("type"));
        return modelAndView;
    }

    public ModelAndView checkWorkflowSecretLevel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (!AppContext.hasPlugin(SecretUtil.SECRET_PLUGIN_NAME)) {
            out.write("{\"msg\":\"\",\"res\":\"true\"}");
            out.close();
            return null;
        } else {
            String secretLevel = request.getParameter("secretLevel");
            String processInfo = request.getParameter("pro");
            String processXml = request.getParameter("processXml");
            String zdgzry = request.getParameter("zdgzry");
            String supervisorIds = request.getParameter("supervisorIds");
            if (StringUtils.isBlank(secretLevel) || StringUtils.isBlank(processXml) && StringUtils.isBlank(processInfo)) {
                out.write("{\"msg\":\"\",\"res\":\"true\"}");
                out.close();
                return null;
            } else {
                List<V3xOrgMember> memberList = new ArrayList();
                List<V3xOrgMember> tempMemberList = null;
                V3xOrgMember member = null;
                boolean isOK = true;
                int secret = Integer.valueOf(secretLevel);
                String str;
                int var15;
                int var16;
                String[] type;
                String[] m;
                if (StringUtils.isNotBlank(processInfo)) {
                    var16 = (type = processInfo.split(",")).length;

                    for(var15 = 0; var15 < var16; ++var15) {
                        str = type[var15];
                        if (StringUtils.isNotBlank(str)) {
                            m = str.split("\\|");
                            if (m.length >= 2) {
                                member = this.orgManager.getMemberById(Long.valueOf(m[1]));
                                if (member != null && member.getSecretLevel() < secret) {
                                    out.write("{\"msg\":\"" + ResourceUtil.getString("secret.flowcheck.lower", "流程") + "\",\"res\":\"false\",\"cause\":\"workflow\"}");
                                    out.close();
                                    return null;
                                }
                            }
                        }
                    }
                }

                if (StringUtils.isNotBlank(zdgzry)) {
                    var16 = (type = zdgzry.split(",")).length;

                    for(var15 = 0; var15 < var16; ++var15) {
                        str = type[var15];
                        if (StringUtils.isNotBlank(str)) {
                            member = this.orgManager.getMemberById(Long.valueOf(str));
                            if (member != null && member.getSecretLevel() < secret) {
                                out.write("{\"msg\":\"" + ResourceUtil.getString("secret.flowcheck.lower", "指定跟踪人员") + "\",\"res\":\"false\",\"cause\":\"zdgzry\"}");
                                out.close();
                                return null;
                            }
                        }
                    }
                }

                if (StringUtils.isNotBlank(supervisorIds)) {
                    var16 = (type = supervisorIds.split(",")).length;

                    for(var15 = 0; var15 < var16; ++var15) {
                        str = type[var15];
                        if (StringUtils.isNotBlank(str)) {
                            member = this.orgManager.getMemberById(Long.valueOf(str));
                            if (member != null && member.getSecretLevel() < secret) {
                                out.write("{\"msg\":\"" + ResourceUtil.getString("secret.flowcheck.lower", "督办人员") + "\",\"res\":\"false\",\"cause\":\"supervisor\"}");
                                out.close();
                                return null;
                            }
                        }
                    }
                }

                if (StringUtils.isBlank(processXml)) {
                    out.write("{\"msg\":\"\",\"res\":\"true\"}");
                    out.close();
                    return null;
                } else {
                    Document doc = DocumentHelper.parseText(processXml);
                    Node root = doc.selectSingleNode("//ps/p");
                    List list = root.selectNodes("n/a");
                    type = null;
                    m = null;

                    for(int i = 0; i < list.size(); ++i) {
                        Element e = (Element)list.get(i);
                        String key = e.attributeValue("f");
                        if (!StringUtils.isBlank(key)) {
                            String type2 = e.attributeValue("g");
                            if ("user".equals(type2)) {
                                member = this.orgManager.getMemberById(Long.valueOf(key));
                                if (member != null) {
                                    memberList.add(member);
                                }
                            } else if ("Account".equals(type2)) {
                                tempMemberList = this.orgManager.getAllMembers(Long.valueOf(key));
                                if (tempMemberList != null) {
                                    memberList.addAll(tempMemberList);
                                }
                            } else if ("Department".equals(type2)) {
                                tempMemberList = this.orgManager.getMembersByDepartment(Long.valueOf(key), true, (MemberPostType)null);
                                if (tempMemberList != null) {
                                    memberList.addAll(tempMemberList);
                                }
                            } else if ("Team".equals(type2)) {
                                tempMemberList = this.orgManager.getMembersByTeam(Long.valueOf(key));
                                if (tempMemberList != null) {
                                    memberList.addAll(tempMemberList);
                                }
                            } else if ("Post".equals(type2)) {
                                tempMemberList = this.orgManager.getMembersByPost(Long.valueOf(key));
                                if (tempMemberList != null) {
                                    memberList.addAll(tempMemberList);
                                }
                            }
                        }
                    }

                    Iterator var27 = memberList.iterator();

                    while(var27.hasNext()) {
                        V3xOrgMember orgMember = (V3xOrgMember)var27.next();
                        if (orgMember.getSecretLevel() < secret) {
                            isOK = false;
                            break;
                        }
                    }

                    if (!isOK) {
                        out.write("{\"msg\":\"" + ResourceUtil.getString("secret.flowcheck.lower", "流程") + "\",\"res\":\"false\",\"cause\":\"workflow\"}");
                    } else {
                        out.write("{\"msg\":\"\",\"res\":\"true\"}");
                    }

                    out.close();
                    return null;
                }
            }
        }
    }

    private void initAttLog(long moduleId, long opinionId, List<Attachment> commentAtts, ColSummary summary, CtpAffair affair) throws Exception {
        List<Attachment> hasAttList = this.attachmentManager.getByReference(moduleId, opinionId);
        Map<String, String> diffMap = new HashMap();
        Iterator var11 = commentAtts.iterator();

        Attachment hasAtt;
        boolean isExist;
        Attachment natt;
        Iterator var14;
        while(var11.hasNext()) {
            hasAtt = (Attachment)var11.next();
            isExist = false;
            var14 = hasAttList.iterator();

            while(var14.hasNext()) {
                natt = (Attachment)var14.next();
                if (hasAtt.getFilename().equals(natt.getFilename())) {
                    isExist = true;
                    break;
                }
            }

            if (!isExist) {
                diffMap.put(hasAtt.getFilename(), "add");
            }
        }

        var11 = hasAttList.iterator();

        while(var11.hasNext()) {
            hasAtt = (Attachment)var11.next();
            isExist = false;
            var14 = commentAtts.iterator();

            while(var14.hasNext()) {
                natt = (Attachment)var14.next();
                if (hasAtt.getFilename().equals(natt.getFilename())) {
                    isExist = true;
                    break;
                }
            }

            if (!isExist) {
                diffMap.put(hasAtt.getFilename(), "del");
            }
        }

        var11 = diffMap.entrySet().iterator();

        while(var11.hasNext()) {
            Entry<String, String> entry = (Entry)var11.next();
            String operContent = "";
            if (((String)entry.getValue()).equals("del")) {
                operContent = " 删除附件：" + (String)entry.getKey();
                this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId() == null ? -1L : affair.getActivityId(), ProcessLogAction.delOpinAtt, new String[]{operContent});
            } else {
                operContent = " 添加附件：" + (String)entry.getKey();
                this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId() == null ? -1L : affair.getActivityId(), ProcessLogAction.addOpinAtt, new String[]{operContent});
            }
        }

    }

    public ModelAndView editOpinion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        String outInfo = "";
        String opinionContent = request.getParameter("modifyContent");
        long opinionId = request.getParameter("editOpinionId") == null ? 0L : Long.parseLong(request.getParameter("editOpinionId").trim());
        User user = AppContext.getCurrentUser();
        boolean hasEdit = this.govdocOpenManager.hasEditAuth(user.getId(), user.getAccountId());
        this.commentManager = (CommentManager)AppContext.getBean("ctpCommentManager");
        if (hasEdit) {
            AttachmentEditHelper editHelper = new AttachmentEditHelper(request);

            try {
                String attListJSON = "";
                Comment comment = this.commentManager.getComment(opinionId);
                CtpAffair affair = this.colManager.getAffairById(Long.parseLong(request.getParameter("affairId")));
                ColSummary summary = this.colManager.getColSummaryById(comment.getModuleId());
                List commentAtts;
                Iterator var16;
                if (editHelper.hasEditAtt()) {
                    request.setAttribute("HASSAVEDATTACHMENT", new Date());
                    commentAtts = this.attachmentManager.getAttachmentsFromRequest(ApplicationCategoryEnum.edoc, comment.getModuleId(), opinionId, request);

                    try {
                        this.initAttLog(comment.getModuleId(), opinionId, commentAtts, summary, affair);
                    } catch (Exception var23) {
                        LOGGER.error("编辑意见生成流程日志时出错:", var23);
                    }

                    if (Strings.isNotBlank(request.getParameter("isEditAttachment"))) {
                        this.attachmentManager.deleteByReference(comment.getModuleId(), opinionId);
                    }

                    var16 = commentAtts.iterator();

                    while(var16.hasNext()) {
                        Attachment att = (Attachment)var16.next();
                        att.setCreatedate(new Date());
                        att.setCategory(ApplicationCategoryEnum.collaboration.getKey());
                    }

                    this.attachmentManager.create(commentAtts);
                    if (comment.getIsNiban()) {
                        List<Attachment> edocAtts = new ArrayList();
                        Iterator var17 = commentAtts.iterator();

                        while(var17.hasNext()) {
                            Attachment attachment = (Attachment)var17.next();
                            Attachment att = (Attachment)attachment.clone();
                            att.setCategory(ApplicationCategoryEnum.edoc.getKey());
                            att.setReference(comment.getModuleId());
                            att.setSubReference(comment.getModuleId());
                            edocAtts.add(att);
                        }

                        this.attachmentManager.deleteByReference(comment.getModuleId(), comment.getModuleId());
                        this.attachmentManager.create(edocAtts);
                    }

                    attListJSON = this.attachmentManager.getAttListJSON4JS(comment.getModuleId(), opinionId);
                }

                if (!"collaboration.dealAttitude.temporaryAbeyance".equals(comment.getExtAtt3())) {
                    commentAtts = this.edocOpinionDao.findListBySummaryIdAndAffairId(comment.getModuleId(), comment.getAffairId());

                    EdocOpinion opinion;
                    for(var16 = commentAtts.iterator(); var16.hasNext(); this.edocOpinionDao.update(opinion)) {
                        opinion = (EdocOpinion)var16.next();
                        opinion.setContent(opinionContent);
                        if (editHelper.hasEditAtt()) {
                            opinion.setHasAtt(editHelper.attSize() > 0);
                            EdocSummary edocSummary = opinion.getEdocSummary();
                            if (Strings.isNotBlank(request.getParameter("isEditAttachment"))) {
                                this.attachmentManager.deleteByReference(edocSummary.getId(), opinion.getId());
                            }

                            List<Attachment> atts = this.attachmentManager.getAttachmentsFromRequest(ApplicationCategoryEnum.edoc, edocSummary.getId(), opinion.getId(), request);
                            List<Attachment> lastAtt = new ArrayList();
                            Iterator var21 = atts.iterator();

                            while(var21.hasNext()) {
                                Attachment att = (Attachment)var21.next();
                                File file = this.fileManager.getFile(att.getFileUrl(), new Date());
                                if (file != null) {
                                    att.setCreatedate(new Date());
                                    att.setSubReference(opinion.getId());
                                    lastAtt.add(att);
                                }
                            }

                            this.attachmentManager.create(lastAtt);
                            List<Attachment> attachments = this.attachmentManager.getByReference(edocSummary.getId(), opinion.getId());
                            opinion.setOpinionAttachments(attachments);
                            this.edocManager.saveUpdateAttInfo(editHelper.attSize(), edocSummary.getId(), new ArrayList());
                        }
                    }
                }

                this.commentDao.saveModifyContent(opinionId, opinionContent, attListJSON);
                String operContent = AppContext.getCurrentUser().getName() + "修改" + Functions.showMemberName(comment.getCreateId()) + "意见:原意见内容改为" + opinionContent;
                this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId() == null ? -1L : affair.getActivityId(), ProcessLogAction.modifyOpinion, new String[]{operContent});
                String accountName = this.orgManager.getMemberById(comment.getCreateId()).getName();
                this.appLogManager.insertLog(user, AppLogAction.Edoc_Modify_Opinion, new String[]{accountName});
                if (comment.getIsNiban()) {
                    Long formAppId = summary.getFormAppid();
                    FormBean formBean = FormService.getForm(formAppId);
                    String nibanyijian = "";
                    Iterator var39 = formBean.getAllFieldBeans().iterator();

                    while(var39.hasNext()) {
                        FormFieldBean fieldBean = (FormFieldBean)var39.next();
                        if ("nibanyijian".equals(fieldBean.getMappingField())) {
                            nibanyijian = fieldBean.getName();
                            break;
                        }
                    }

                    FormDataMasterBean formDataMasterBean = FormService.findDataById(summary.getFormRecordid(), summary.getFormAppid(), (String[])null);
                    formDataMasterBean.addFieldValue(nibanyijian, opinionContent);
                    FormService.saveOrUpdateFormData(formDataMasterBean, formAppId);
                }

                outInfo = "保存成功！";
            } catch (Exception var24) {
                outInfo = "保存失败！";
                this.logger.error("执行意见修改异常！", var24);
            }
        } else {
            outInfo = "对不起，您没有权限进行此操作！";
        }

        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('" + outInfo + "')");
        out.println("</script>");
        out.flush();
        return super.refreshWindow("parent");
    }

    private String specialString(String field) {
        if (field != null) {
            StringBuffer buffer = new StringBuffer();

            for(int i = 0; i < field.length(); ++i) {
                if (field.charAt(i) == '\'') {
                    buffer.append("\\'");
                } else {
                    buffer.append(field.charAt(i));
                }
            }

            field = SQLWildcardUtil.escape(buffer.toString());
        }

        return field;
    }
}
