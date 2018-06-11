//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.collaboration.manager;

import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.collaboration.bo.ColInfo;
import com.seeyon.apps.collaboration.bo.DateSharedWithWorkflowEngineThreadLocal;
import com.seeyon.apps.collaboration.bo.DeleteAjaxTranObj;
import com.seeyon.apps.collaboration.bo.FormLockParam;
import com.seeyon.apps.collaboration.bo.LockObject;
import com.seeyon.apps.collaboration.bo.QuerySummaryParam;
import com.seeyon.apps.collaboration.bo.TrackAjaxTranObj;
import com.seeyon.apps.collaboration.constants.ColConstant.ColSummaryVouch;
import com.seeyon.apps.collaboration.constants.ColConstant.ConfigCategory;
import com.seeyon.apps.collaboration.constants.ColConstant.NewflowType;
import com.seeyon.apps.collaboration.constants.ColConstant.SendType;
import com.seeyon.apps.collaboration.dao.ColDao;
import com.seeyon.apps.collaboration.enums.ColHandleType;
import com.seeyon.apps.collaboration.enums.ColListType;
import com.seeyon.apps.collaboration.enums.ColOpenFrom;
import com.seeyon.apps.collaboration.enums.ColQueryCondition;
import com.seeyon.apps.collaboration.enums.CommentExtAtt3Enum;
import com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState;
import com.seeyon.apps.collaboration.enums.CollaborationEnum.vouchState;
import com.seeyon.apps.collaboration.event.CollaborationAddCommentEvent;
import com.seeyon.apps.collaboration.event.CollaborationAppointStepBackEvent;
import com.seeyon.apps.collaboration.event.CollaborationCancelEvent;
import com.seeyon.apps.collaboration.event.CollaborationDelEvent;
import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;
import com.seeyon.apps.collaboration.event.CollaborationStepBackEvent;
import com.seeyon.apps.collaboration.event.CollaborationStopEvent;
import com.seeyon.apps.collaboration.listener.WorkFlowEventListener;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.trace.dao.TraceDao;
import com.seeyon.apps.collaboration.trace.enums.WorkflowTraceEnums.workflowTrackType;
import com.seeyon.apps.collaboration.trace.manager.TraceWorkflowDataManager;
import com.seeyon.apps.collaboration.trace.manager.TraceWorkflowManager;
import com.seeyon.apps.collaboration.util.AttachmentEditUtil;
import com.seeyon.apps.collaboration.util.ColSelfUtil;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.collaboration.vo.AttachmentVO;
import com.seeyon.apps.collaboration.vo.ColListSimpleVO;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.apps.collaboration.vo.NewCollTranVO;
import com.seeyon.apps.collaboration.vo.NodePolicyVO;
import com.seeyon.apps.collaboration.vo.SeeyonPolicy;
import com.seeyon.apps.collaboration.vo.WebEntity4QuickIndex4Col;
import com.seeyon.apps.common.isignaturehtml.manager.ISignatureHtmlManager;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.bo.DocResourceBO;
import com.seeyon.apps.doc.constants.DocConstants.PigeonholeType;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.index.util.Convertor;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.apps.webmail.api.WebmailApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.constants.Constants.login_sign;
import com.seeyon.ctp.common.content.ContentConfig;
import com.seeyon.ctp.common.content.ContentInterface;
import com.seeyon.ctp.common.content.ContentSaveOrUpdateRet;
import com.seeyon.ctp.common.content.ContentUtil;
import com.seeyon.ctp.common.content.ContentViewRet;
import com.seeyon.ctp.common.content.ContentUtil.OperationType;
import com.seeyon.ctp.common.content.affair.AffairDao;
import com.seeyon.ctp.common.content.affair.AffairData;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.AffairFromTypeEnum;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.affair.constants.TrackEnum;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.content.comment.Comment.CommentType;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.lock.manager.LockManagerImpl;
import com.seeyon.ctp.common.lock.manager.LockState;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.office.HandWriteManager;
import com.seeyon.ctp.common.office.OfficeLockManager;
import com.seeyon.ctp.common.office.trans.util.OfficeTransHelper;
import com.seeyon.ctp.common.permission.bo.CustomAction;
import com.seeyon.ctp.common.permission.bo.NodePolicy;
import com.seeyon.ctp.common.permission.bo.Permission;
import com.seeyon.ctp.common.permission.enums.PermissionAction;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.permission.vo.PermissionVO;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.comment.CtpCommentAll;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.lock.Lock;
import com.seeyon.ctp.common.po.processlog.ProcessLog;
import com.seeyon.ctp.common.po.processlog.ProcessLogDetail;
import com.seeyon.ctp.common.po.supervise.CtpSuperviseDetail;
import com.seeyon.ctp.common.po.supervise.CtpSupervisor;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.processlog.ProcessLogAction;
import com.seeyon.ctp.common.processlog.ProcessLogAction.ProcessEdocAction;
import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
import com.seeyon.ctp.common.quartz.QuartzHolder;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.supervise.enums.SuperviseEnum.EntityType;
import com.seeyon.ctp.common.supervise.enums.SuperviseEnum.superviseState;
import com.seeyon.ctp.common.supervise.manager.SuperviseManager;
import com.seeyon.ctp.common.supervise.vo.SuperviseMessageParam;
import com.seeyon.ctp.common.supervise.vo.SuperviseModelVO;
import com.seeyon.ctp.common.supervise.vo.SuperviseSetVO;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.enums.TemplateEnum.Type;
import com.seeyon.ctp.common.template.manager.CollaborationTemplateManager;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.track.manager.CtpTrackMemberManager;
import com.seeyon.ctp.common.track.po.CtpTrackMember;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationManager;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.organization.OrgConstants.ExternalType;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.webmodel.WebEntity4QuickIndex;
import com.seeyon.ctp.portal.portlet.PortletConstants.PortletCategory;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.XMLCoder;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.peoplerelate.domain.PeopleRelate;
import com.seeyon.v3x.peoplerelate.manager.PeopleRelateManager;
import com.seeyon.v3x.system.signet.manager.SignetManager;
import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;
import java.io.File;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import net.joinwork.bpm.definition.BPMAbstractNode;
import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMActor;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.engine.wapi.WorkItem;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

public class ColManagerImpl implements ColManager {
    private static Log LOG = CtpLogFactory.getLog(ColManagerImpl.class);
    private CollaborationTemplateManager collaborationTemplateManager;
    private WorkflowApiManager wapi;
    private OrgManager orgManager;
    private PermissionManager permissionManager;
    private AffairManager affairManager;
    private AttachmentManager attachmentManager;
    private CtpTrackMemberManager trackManager;
    private AppLogManager appLogManager;
    private ProcessLogManager processLogManager;
    private SuperviseManager superviseManager;
    private TemplateManager templateManager;
    private WorkTimeManager workTimeManager;
    private FileManager fileManager;
    private CommentManager commentManager;
    private ColDao colDao;
    private AffairDao affairDao;
    private IndexManager indexManager;
    private FormManager formManager;
    private ColMessageManager colMessageManager;
    private FormCacheManager formCacheManager;
    private ColPubManager colPubManager;
    private CustomizeManager customizeManager;
    private FormRelationManager formRelationManager;
    private UserMessageManager userMessageManager;
    private MainbodyManager ctpMainbodyManager;
    private ISignatureHtmlManager iSignatureHtmlManager;
    private SignetManager signetManager;
    private List cannotRepealList;
    private TraceWorkflowDataManager colTraceWorkflowManager;
    private TraceWorkflowManager traceWorkflowManager;
    private OfficeLockManager officeLockManager;
    private PeopleRelateManager peopleRelateManager;
    private ColLockManager colLockManager;
    private LockManagerImpl lockManager;
    private ColBatchUpdateAnalysisTimeManager colBatchUpdateAnalysisTimeManager;
    private TraceDao traceDao;
    private ProjectApi projectApi;
    private DocApi docApi;
    private WebmailApi webmailApi;
    private HandWriteManager handWriteManager;
    private static Pattern PATTERN_ATTACHMENT_ID = Pattern.compile("\"v\":\"(\\S+)\"", 2);
    private final Object CheckAndupdateLock = new Object();

    public ColManagerImpl() {
    }

    public CollaborationTemplateManager getCollaborationTemplateManager() {
        return collaborationTemplateManager;
    }

    public WorkflowApiManager getWapi() {
        return wapi;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public PermissionManager getPermissionManager() {
        return permissionManager;
    }

    public AffairManager getAffairManager() {
        return affairManager;
    }

    public AttachmentManager getAttachmentManager() {
        return attachmentManager;
    }

    public CtpTrackMemberManager getTrackManager() {
        return trackManager;
    }

    public AppLogManager getAppLogManager() {
        return appLogManager;
    }

    public ProcessLogManager getProcessLogManager() {
        return processLogManager;
    }

    public SuperviseManager getSuperviseManager() {
        return superviseManager;
    }

    public TemplateManager getTemplateManager() {
        return templateManager;
    }

    public WorkTimeManager getWorkTimeManager() {
        return workTimeManager;
    }

    public FileManager getFileManager() {
        return fileManager;
    }

    public CommentManager getCommentManager() {
        return commentManager;
    }

    public ColDao getColDao() {
        return colDao;
    }

    public AffairDao getAffairDao() {
        return affairDao;
    }

    public IndexManager getIndexManager() {
        return indexManager;
    }

    public FormManager getFormManager() {
        return formManager;
    }

    public ColMessageManager getColMessageManager() {
        return colMessageManager;
    }

    public FormCacheManager getFormCacheManager() {
        return formCacheManager;
    }

    public ColPubManager getColPubManager() {
        return colPubManager;
    }

    public FormRelationManager getFormRelationManager() {
        return formRelationManager;
    }

    public UserMessageManager getUserMessageManager() {
        return userMessageManager;
    }

    public MainbodyManager getCtpMainbodyManager() {
        return ctpMainbodyManager;
    }

    public ISignatureHtmlManager getiSignatureHtmlManager() {
        return iSignatureHtmlManager;
    }

    public SignetManager getSignetManager() {
        return signetManager;
    }

    public List getCannotRepealList() {
        return cannotRepealList;
    }

    public TraceWorkflowDataManager getColTraceWorkflowManager() {
        return colTraceWorkflowManager;
    }

    public OfficeLockManager getOfficeLockManager() {
        return officeLockManager;
    }

    public ColLockManager getColLockManager() {
        return colLockManager;
    }

    public TraceDao getTraceDao() {
        return traceDao;
    }

    public ProjectApi getProjectApi() {
        return projectApi;
    }

    public DocApi getDocApi() {
        return docApi;
    }

    public WebmailApi getWebmailApi() {
        return webmailApi;
    }

    public HandWriteManager getHandWriteManager() {
        return handWriteManager;
    }

    public Object getCheckAndupdateLock() {
        return CheckAndupdateLock;
    }

    public void setHandWriteManager(HandWriteManager handWriteManager) {
        this.handWriteManager = handWriteManager;
    }

    public void setWebmailApi(WebmailApi webmailApi) {
        this.webmailApi = webmailApi;
    }

    public PeopleRelateManager getPeopleRelateManager() {
        return this.peopleRelateManager;
    }

    public void setPeopleRelateManager(PeopleRelateManager peopleRelateManager) {
        this.peopleRelateManager = peopleRelateManager;
    }

    public ColBatchUpdateAnalysisTimeManager getColBatchUpdateAnalysisTimeManager() {
        return this.colBatchUpdateAnalysisTimeManager;
    }

    public void setColBatchUpdateAnalysisTimeManager(ColBatchUpdateAnalysisTimeManager colBatchUpdateAnalysisTimeManager) {
        this.colBatchUpdateAnalysisTimeManager = colBatchUpdateAnalysisTimeManager;
    }

    public LockManagerImpl getLockManagerImpl() {
        return this.lockManager;
    }

    public void setLockManagerImpl(LockManagerImpl lockManagerImpl) {
        this.lockManager = lockManagerImpl;
    }

    public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }

    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }

    public void setTraceDao(TraceDao traceDao) {
        this.traceDao = traceDao;
    }

    public TraceWorkflowManager getTraceWorkflowManager() {
        return this.traceWorkflowManager;
    }

    public void setTraceWorkflowManager(TraceWorkflowManager traceWorkflowManager) {
        this.traceWorkflowManager = traceWorkflowManager;
    }

    public void setColTraceWorkflowManager(TraceWorkflowDataManager colTraceWorkflowManager) {
        this.colTraceWorkflowManager = colTraceWorkflowManager;
    }

    public CustomizeManager getCustomizeManager() {
        return this.customizeManager;
    }

    public void setSignetManager(SignetManager signetManager) {
        this.signetManager = signetManager;
    }

    public void setiSignatureHtmlManager(ISignatureHtmlManager iSignatureHtmlManager) {
        this.iSignatureHtmlManager = iSignatureHtmlManager;
    }

    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }

    public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
        this.ctpMainbodyManager = ctpMainbodyManager;
    }

    public void setCollaborationTemplateManager(CollaborationTemplateManager collaborationTemplateManager) {
        this.collaborationTemplateManager = collaborationTemplateManager;
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setTrackManager(CtpTrackMemberManager trackManager) {
        this.trackManager = trackManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setProcessLogManager(ProcessLogManager processLogManager) {
        this.processLogManager = processLogManager;
    }

    public void setSuperviseManager(SuperviseManager superviseManager) {
        this.superviseManager = superviseManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public void setWorkTimeManager(WorkTimeManager workTimeManager) {
        this.workTimeManager = workTimeManager;
    }

    public void setCommentManager(CommentManager commentManager) {
        this.commentManager = commentManager;
    }

    public void setColDao(ColDao colDao) {
        this.colDao = colDao;
    }

    public void setAffairDao(AffairDao affairDao) {
        this.affairDao = affairDao;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public void setColMessageManager(ColMessageManager colMessageManager) {
        this.colMessageManager = colMessageManager;
    }

    public void setFormCacheManager(FormCacheManager formCacheManager) {
        this.formCacheManager = formCacheManager;
    }

    public void setColPubManager(ColPubManager colPubManager) {
        this.colPubManager = colPubManager;
    }

    public void setFormRelationManager(FormRelationManager formRelationManager) {
        this.formRelationManager = formRelationManager;
    }

    public void setCannotRepealList(List cannotRepealList) {
        this.cannotRepealList = cannotRepealList;
    }

    public void setOfficeLockManager(OfficeLockManager officeLockManager) {
        this.officeLockManager = officeLockManager;
    }

    public void setColLockManager(ColLockManager colLockManager) {
        this.colLockManager = colLockManager;
    }

    public void saveColSummary(ColSummary colSummary) {
        this.colDao.saveColSummary(colSummary);
    }

    public void deleteColSummary(ColSummary colSummary) {
        this.colDao.deleteColSummary(colSummary);
    }

    public void updateColInfo(ColInfo info) {
        if (null != info.getSummary()) {
            this.updateColSummary(info.getSummary());
        }

    }

    public void updateColSummary(ColSummary colSummary) {
        this.colDao.updateColSummary(colSummary);
    }

    public NodePolicyVO getNewColNodePolicy(Long loginAcctountId) {
        NodePolicyVO nodePolicy = null;

        try {
            Permission permission = this.permissionManager.getPermission(EnumNameEnum.col_flow_perm_policy.name(), "newCol", loginAcctountId);
            nodePolicy = new NodePolicyVO(permission);
        } catch (BusinessException var4) {
            LOG.error("", var4);
        }

        return nodePolicy;
    }

    public void transSend(ColInfo info, SendType sendType) throws BusinessException {
        boolean isNew = info.getNewBusiness();
        ColSummary summary = info.getSummary();
        if (!isNew) {
            CtpAffair senderAffair = info.getSenderAffair();
            if (senderAffair == null || StateEnum.col_waitSend.getKey() != senderAffair.getState()) {
                return;
            }

            int subState = senderAffair.getSubState();
            if (subState != SubStateEnum.col_pending_specialBacked.getKey() && subState != SubStateEnum.col_pending_specialBackToSenderCancel.getKey()) {
                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.collaboration, summary.getId());
                if (subState == SubStateEnum.col_waitSend_cancel.getKey()) {
                    this.superviseManager.deleteLogs(summary.getId());
                    this.superviseManager.deleteSuperviseAllById(summary.getId());
                    this.commentManager.deleteCommentAllByModuleId(ModuleType.collaboration, summary.getId());
                    List<Attachment> attachment = this.attachmentManager.getByReference(summary.getId());
                    Iterator var8 = attachment.iterator();

                    while(var8.hasNext()) {
                        Attachment att = (Attachment)var8.next();
                        if (!"100".equals(att.getSubReference().toString()) && !Integer.valueOf(ModuleType.form.getKey()).equals(att.getCategory())) {
                            this.attachmentManager.deleteById(att.getId());
                        }
                    }
                } else {
                    this.attachmentManager.deleteByReference(summary.getId(), summary.getId());
                }
            } else {
                this.deleteAttachment4SpecialBack(summary.getId());
            }
        }

        summary.setTempleteId(info.gettId());
        Comment comment = ContentUtil.getCommnetFromRequest(OperationType.send, (Long)null, summary.getId());
        if (Strings.isNotBlank(comment.getContent()) && !ResourceUtil.getString("collaboration.newcoll.fywbzyl").equals(comment.getContent().replace("\n", ""))) {
            if (comment.getId() != null && comment.getId() != -1L) {
                ContentUtil.deleteCommentAllByModuleIdAndCtype(ModuleType.collaboration, summary.getId());
            }

            comment.setId(UUIDLong.longUUID());
            info.setComment(comment);
        }

        summary.setCanDueReminder(false);
        summary.setAudited(false);
        summary.setVouch(vouchState.defaultValue.ordinal());
        this.colPubManager.transSendColl(sendType, info);
    }

    public void transSendImmediate(String _summaryIds, String _affairIds, boolean sentFlag, String workflowNodePeoplesInput, String workflowNodeConditionInput, String workflowNewflowInput, String toReGo) throws BusinessException {
        CtpAffair affair = this.affairManager.get(Long.valueOf(_affairIds));
        this.transSendImmediate(_summaryIds, affair, sentFlag, workflowNodePeoplesInput, workflowNodeConditionInput, workflowNewflowInput, toReGo);
    }

    public void transSendImmediate(String _summaryIds, CtpAffair affair, boolean sentFlag, String workflowNodePeoplesInput, String workflowNodeConditionInput, String workflowNewflowInput, String toReGo) throws BusinessException {
        Long summaryId = Long.valueOf(_summaryIds);
        ColSummary colSummary = this.getColSummaryById(summaryId);
        if (StateEnum.col_waitSend.getKey() == affair.getState()) {
            int subState = affair.getSubState();
            String processId = colSummary.getProcessId();
            if (subState != SubStateEnum.col_pending_specialBacked.getKey() && subState != SubStateEnum.col_pending_specialBackToSenderCancel.getKey()) {
                if (subState == SubStateEnum.col_waitSend_cancel.getKey()) {
                    this.superviseManager.deleteLogs(colSummary.getId());
                    List<CommentType> types = new ArrayList();
                    types.add(CommentType.reply);
                    types.add(CommentType.comment);
                    this.commentManager.deleteCommentAllByModuleIdAndCtypes(ModuleType.collaboration, summaryId, types);
                }

                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.collaboration, colSummary.getId());
                if (subState == SubStateEnum.col_waitSend_cancel.getKey()) {
                    List<Attachment> l = this.attachmentManager.getByReference(summaryId);
                    List<Comment> comments = this.commentManager.getCommentList(ModuleType.collaboration, summaryId);
                    if (comments.size() > 0) {
                        List<Long> attSend = new ArrayList();
                        Iterator var15 = comments.iterator();

                        while(var15.hasNext()) {
                            Comment com = (Comment)var15.next();
                            if (com.getCtype() == CommentType.sender.getKey()) {
                                attSend.add(com.getId());
                            }
                        }

                        if (Strings.isNotEmpty(l)) {
                            var15 = l.iterator();

                            while(var15.hasNext()) {
                                Attachment m = (Attachment)var15.next();
                                if (!summaryId.equals(m.getSubReference()) && !attSend.contains(m.getSubReference())) {
                                    this.attachmentManager.deleteByReference(summaryId, m.getSubReference());
                                }
                            }
                        }
                    }
                }
            }

            ColInfo info = new ColInfo();
            info.setCurrentUser(AppContext.getCurrentUser());
            info.setSenderAffair(affair);
            info.setSummary(colSummary);
            info.setCurrentProcessId(colSummary.getProcessId() == null ? 0L : Long.valueOf(colSummary.getProcessId()));
            info.setWorkflowNewflowInput(workflowNewflowInput);
            info.setWorkflowNodeConditionInput(workflowNodeConditionInput);
            info.setWorkflowNodePeoplesInput(workflowNodePeoplesInput);
            info.setTrackType(affair.getTrack());
            this.colPubManager.transSendColl(SendType.immediate, info);
        }
    }

    private void deleteAttachment4SpecialBack(Long id) {
        try {
            this.attachmentManager.deleteByReference(id, id);
            List<Long> commentIds = ContentUtil.getSenderCommentIdByModuleIdAndCtype(ModuleType.collaboration, id);
            if (Strings.isNotEmpty(commentIds)) {
                Iterator var3 = commentIds.iterator();

                while(var3.hasNext()) {
                    Long cid = (Long)var3.next();
                    this.attachmentManager.deleteByReference(id, cid);
                }
            }
        } catch (BusinessException var5) {
            LOG.error("", var5);
        }

    }

    public String saveAttachmentFromDomain(ApplicationCategoryEnum type, Long module_id) throws BusinessException {
        List assDocGroup = ParamUtil.getJsonDomainGroup("assDocDomain");
        int assDocSize = assDocGroup.size();
        Map assDocMap = ParamUtil.getJsonDomain("assDocDomain");
        if (assDocSize == 0 && assDocMap.size() > 0) {
            assDocGroup.add(assDocMap);
        }

        List attFileGroup = ParamUtil.getJsonDomainGroup("attFileDomain");
        int attFileSize = attFileGroup.size();
        Map attFileMap = ParamUtil.getJsonDomain("attFileDomain");
        if (attFileSize == 0 && attFileMap.size() > 0) {
            attFileGroup.add(attFileMap);
        }

        assDocGroup.addAll(attFileGroup);

        List result;
        try {
            result = this.attachmentManager.getAttachmentsFromAttachList(ApplicationCategoryEnum.collaboration, module_id, module_id, assDocGroup);
        } catch (Exception var11) {
            LOG.error("", var11);
            throw new BusinessException("创建附件出错");
        }

        return this.attachmentManager.create(result);
    }

    private void deleteAllColSummaryById(ColSummary summary) throws BusinessException {
        this.colDao.deleteColSummaryById(summary.getId());
        ContentUtil.contentDelete(ModuleType.collaboration, summary.getId(), summary.getProcessId());
        if (Strings.isNotBlank(summary.getProcessId())) {
            this.processLogManager.deleteLog(Long.parseLong(summary.getProcessId()));
        }

        this.affairManager.deleteByObjectId(ApplicationCategoryEnum.collaboration, summary.getId());
        this.attachmentManager.deleteByReference(summary.getId());
    }

    public CtpAffair getAffairById(long affairId) throws BusinessException {
        return this.getAffairById(affairId, false);
    }

    private CtpAffair getAffairById(long affairId, boolean isHistoryFlag) throws BusinessException {
        CtpAffair affair = null;
        if (isHistoryFlag) {
            affair = this.affairManager.getByHis(affairId);
        } else {
            affair = this.affairManager.get(affairId);
            if (AppContext.hasPlugin("fk") && affair == null) {
                affair = this.affairManager.getByHis(affairId);
            }
        }

        return affair == null ? null : affair;
    }

    public ColSummary getColSummaryById(Long id) {
        try {
            return this.getSummaryById(id);
        } catch (BusinessException var3) {
            return null;
        }
    }

    public ColSummary getColSummaryByIdHistory(Long id) {
        ColSummary s = null;

        try {
            ColDao colDaoFK = null;
            if (AppContext.hasPlugin("fk")) {
                colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
            }

            if (colDaoFK != null) {
                s = colDaoFK.getColSummaryByIdHis(id);
            }

            return s;
        } catch (Exception var4) {
            return null;
        }
    }

    public String getProcessId(String id) throws BusinessException {
        if (Strings.isBlank(id)) {
            return null;
        } else {
            ColSummary summary = this.getColSummaryById(Long.parseLong(id));
            return summary != null ? summary.getProcessId() : null;
        }
    }

    public List<String> getForwardMemberNames(String forwardMemberIds) {
        if (!Strings.isNotBlank(forwardMemberIds)) {
            return null;
        } else {
            String[] forwardMembers = forwardMemberIds.split(",");
            List<String> forwardMemberNames = new ArrayList(forwardMembers.length);
            String[] var4 = forwardMembers;
            int var5 = forwardMembers.length;

            for(int var6 = 0; var6 < var5; ++var6) {
                String m = var4[var6];
                long memberId = Long.parseLong(m);

                try {
                    String memberName = Functions.showMemberName(memberId);
                    forwardMemberNames.add(Strings.escapeNULL(memberName, ""));
                } catch (Exception var11) {
                    LOG.error("查询人员信息：" + memberId, var11);
                }
            }

            return forwardMemberNames;
        }
    }

    public List<Attachment> getAttachmentsById(long summaryId) {
        return this.attachmentManager.getByReference(summaryId);
    }

    public Long getPermissionAccountId(long loginAccount, ColSummary summary) {
        return 0L;
    }

    public Map<String, Object> getSaveToLocalOrPrintPolicy(ColSummary summary, String nodePermissionPolicy, String lenPotents, CtpAffair affair, String openForm) throws BusinessException {
        Map<String, Object> map = new HashMap();
        boolean officecanPrint = false;
        Boolean officecanSaveLocal = true;

        try {
            Long accountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), summary);
            Permission fp = this.permissionManager.getPermission(EnumNameEnum.col_flow_perm_policy.name(), nodePermissionPolicy, accountId);
            if (fp != null) {
                String baseAction = fp.getBasicOperation();
                if (Strings.isNotBlank(lenPotents) && ColOpenFrom.docLib.name().equals(openForm)) {
                    officecanPrint = !"0".equals(lenPotents.substring(2, 3));
                    officecanSaveLocal = !"0".equals(lenPotents.substring(1, 2));
                } else {
                    int state = affair.getState();
                    if (StateEnum.col_waitSend.getKey() == state || StateEnum.col_sent.getKey() == state || baseAction.indexOf("Print") >= 0 || ColOpenFrom.supervise.name().equals(openForm)) {
                        officecanPrint = true;
                    }

                    officecanSaveLocal = true;
                }
            }

            map.put("officecanPrint", officecanPrint);
            map.put("officecanSaveLocal", officecanSaveLocal);
            return map;
        } catch (Exception var13) {
            LOG.error("获取协同的打印权限异常,affairId:" + affair.getId(), var13);
            throw new BusinessException("获取协同的打印权限异常,affairId:" + affair.getId());
        }
    }

    public ColSummary getSummaryByCaseId(Long caseId) throws BusinessException {
        ColSummary s = this.colDao.getSummaryByCaseId(caseId);
        ColDao colDaoFK = null;
        if (AppContext.hasPlugin("fk")) {
            colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
        }

        if (s == null && colDaoFK != null) {
            s = colDaoFK.getSummaryByCaseId(caseId);
        }

        return s;
    }

    public FlipInfo getSentAffairs(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        String userId = (String)query.get(ColQueryCondition.currentUser.name());
        if (Strings.isBlank(userId)) {
            User user = AppContext.getCurrentUser();
            userId = String.valueOf(user.getId());
        }

        query.put(ColQueryCondition.currentUser.name(), userId);
        query.put(ColQueryCondition.state.name(), String.valueOf(StateEnum.col_sent.key()));
        List<ColSummaryVO> result = null;
        boolean dumpData = Boolean.parseBoolean((String)query.get("dumpData"));
        if (dumpData) {
            ColDao colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
            query.put(ColQueryCondition.state.name(), StateEnum.col_sent.getKey() + "," + StateEnum.col_waitSend.getKey());
            if (colDaoFK != null) {
                result = colDaoFK.queryByConditionHis(flipInfo, query);
            }
        } else {
            result = this.colDao.queryByCondition(flipInfo, query);
        }

        if (flipInfo != null) {
            flipInfo.setData(result);
        }

        return flipInfo;
    }

    public FlipInfo getSentList(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        FlipInfo info = this.getSentAffairs(flipInfo, query);
        this.convertColSummaryVO2ListSimpleVO(info);
        return info;
    }

    public FlipInfo getSentlist4Quote(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        String userId = (String)query.get(ColQueryCondition.currentUser.name());
        if (Strings.isBlank(userId)) {
            User user = AppContext.getCurrentUser();
            userId = String.valueOf(user.getId());
        }

        String state = (String)query.get("state");
        if ("3".equals(state)) {
            state = String.valueOf(StateEnum.col_pending.key());
        } else if ("4".equals(state)) {
            state = String.valueOf(StateEnum.col_done.key());
        } else if ("2".equals(state)) {
            state = String.valueOf(StateEnum.col_sent.key());
        }

        query.put(ColQueryCondition.state.name(), state);
        query.put(ColQueryCondition.list4Quote.name(), String.valueOf(Boolean.TRUE));
        query.put(ColQueryCondition.currentUser.name(), String.valueOf(userId));
        List<ColSummaryVO> result = null;
        boolean dumpData = Boolean.parseBoolean((String)query.get("dumpData"));
        if (dumpData) {
            ColDao colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
            if (colDaoFK != null) {
                query.put(ColQueryCondition.state.name(), StateEnum.col_pending.getKey() + "," + StateEnum.col_done.getKey() + "," + StateEnum.col_sent.getKey());
                result = colDaoFK.queryByConditionHis(flipInfo, query);
            }
        } else {
            result = this.colDao.queryByCondition(flipInfo, query);
        }

        if (flipInfo != null) {
            flipInfo.setData(result);
        }

        return flipInfo;
    }

    public FlipInfo getPendingAffairs(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        String userId = (String)query.get(ColQueryCondition.currentUser.name());
        if (Strings.isBlank(userId)) {
            User user = AppContext.getCurrentUser();
            userId = String.valueOf(user.getId());
        }

        V3xOrgMember member = this.orgManager.getMemberById(Long.valueOf(userId));
        query.put(ColQueryCondition.currentUser.name(), userId);
        query.put(ColQueryCondition.state.name(), String.valueOf(StateEnum.col_pending.key()));
        String hasNeedAgent = (String)query.get("hasNeedAgent");
        if (Strings.isBlank(hasNeedAgent)) {
            hasNeedAgent = "true";
        }

        query.put("hasNeedAgent", hasNeedAgent);
        List<ColSummaryVO> result = this.colDao.queryByCondition(flipInfo, query);
        Iterator var7 = result.iterator();

        while(true) {
            while(var7.hasNext()) {
                ColSummaryVO csvo = (ColSummaryVO)var7.next();
                String nodeName = csvo.getNodePolicy();
                ColSummary summary = csvo.getSummary();
                long flowPermAccountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), summary.getOrgAccountId(), summary.getPermissionAccountId());
                Permission permisson = this.permissionManager.getPermission(EnumNameEnum.col_flow_perm_policy.name(), nodeName, flowPermAccountId);
                if (permisson != null) {
                    NodePolicy nodePolicy = permisson.getNodePolicy();
                    Integer opinion = nodePolicy.getOpinionPolicy();
                    boolean canDeleteORarchive = opinion != null && opinion == 1;
                    csvo.setCanDeleteORarchive(canDeleteORarchive);
                    csvo.setCancelOpinionPolicy(nodePolicy.getCancelOpinionPolicy());
                    csvo.setDisAgreeOpinionPolicy(nodePolicy.getDisAgreeOpinionPolicy());
                } else {
                    csvo.setCanDeleteORarchive(true);
                }
            }

            if (flipInfo != null) {
                flipInfo.setData(result);
            }

            return flipInfo;
        }
    }

    public Map<String, Permission> getPermissonMap(String category, Long accountId) throws BusinessException {
        Map<String, Permission> permissionMap = new HashMap();
        List<Permission> permissonList = this.permissionManager.getPermissionsByCategory(category, accountId);
        Iterator var5 = permissonList.iterator();

        while(var5.hasNext()) {
            Permission permission = (Permission)var5.next();
            permissionMap.put(permission.getName(), permission);
        }

        return permissionMap;
    }

    public FlipInfo getPendingList(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        FlipInfo info = this.getPendingAffairs(flipInfo, query);
        this.convertColSummaryVO2ListSimpleVO(info);
        return info;
    }

    private void convertColSummaryVO2ListSimpleVO(FlipInfo info) {
        if (info != null) {
            List<ColSummaryVO> list = info.getData();
            if (Strings.isNotEmpty(list)) {
                List<ColListSimpleVO> csvo = new ArrayList();
                Iterator var4 = list.iterator();

                while(var4.hasNext()) {
                    ColSummaryVO c = (ColSummaryVO)var4.next();
                    ColListSimpleVO vo = new ColListSimpleVO(c);
                    csvo.add(vo);
                }

                info.setData(csvo);
            }
        }

    }

    public FlipInfo getDoneAffairs(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        String userId = (String)query.get(ColQueryCondition.currentUser.name());
        if (Strings.isBlank(userId)) {
            User user = AppContext.getCurrentUser();
            userId = String.valueOf(user.getId());
        }

        query.put(ColQueryCondition.currentUser.name(), userId);
        query.put(ColQueryCondition.state.name(), String.valueOf(StateEnum.col_done.key()));
        String hasNeedAgent = (String)query.get("hasNeedAgent");
        if (Strings.isBlank(hasNeedAgent)) {
            hasNeedAgent = "true";
        }

        query.put("hasNeedAgent", hasNeedAgent);
        List<ColSummaryVO> result = null;
        boolean dumpData = Boolean.parseBoolean((String)query.get("dumpData"));
        if (dumpData) {
            ColDao colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
            if (colDaoFK != null) {
                query.put(ColQueryCondition.state.name(), StateEnum.col_pending.getKey() + "," + StateEnum.col_done.getKey());
                result = colDaoFK.queryByConditionHis(flipInfo, query);
            }
        } else {
            result = this.colDao.queryByCondition(flipInfo, query);
        }

        if (flipInfo != null) {
            flipInfo.setData(result);
        }

        return flipInfo;
    }

    public FlipInfo getDoneList(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        String deduplication = String.valueOf(query.get("deduplication"));
        if ("null".equals(deduplication)) {
            deduplication = "false";
        }

        query.put(ColQueryCondition.deduplication.name(), deduplication);
        FlipInfo info = this.getDoneAffairs(flipInfo, query);
        this.convertColSummaryVO2ListSimpleVO(info);
        return info;
    }

    public FlipInfo getWaitSendAffairs(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        User user = AppContext.getCurrentUser();
        query.put(ColQueryCondition.currentUser.name(), String.valueOf(user.getId()));
        query.put(ColQueryCondition.state.name(), String.valueOf(StateEnum.col_waitSend.key()));
        List<ColSummaryVO> result = this.colDao.queryByCondition(flipInfo, query);
        if (flipInfo != null) {
            flipInfo.setData(result);
        }

        return flipInfo;
    }

    public FlipInfo getWaitSendList(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        FlipInfo info = this.getWaitSendAffairs(flipInfo, query);
        this.convertColSummaryVO2ListSimpleVO(info);
        return info;
    }

    public List<ColSummaryVO> getTrackList4BizConfig(Long memberId, List<Long> tempIds) throws BusinessException {
        return this.colDao.getTrackList4BizConfig(memberId, tempIds);
    }

    public Map saveDraft(ColInfo info, boolean b, Map para) throws BusinessException {
        V3xOrgMember sender = null;

        try {
            sender = this.orgManager.getMemberById(info.getCurrentUser().getId());
        } catch (BusinessException var23) {
            LOG.error("", var23);
        }

        ColSummary summaryFromUE = info.getSummary();
        CtpAffair affair = null;
        boolean isSpecialBacked = false;
        ColSummary summary = info.getSummary();
        if (summary.getId() != null) {
            summary = this.getColSummaryById(summary.getId());
            if (summary != null) {
                affair = this.affairManager.getSenderAffair(summary.getId());
                if (affair != null) {
                    int subState = affair.getSubState();
                    if (subState == SubStateEnum.col_pending_specialBacked.getKey() || subState == SubStateEnum.col_pending_specialBackToSenderCancel.getKey()) {
                        isSpecialBacked = true;
                    }
                }
            } else {
                summary = info.getSummary();
            }
        }

        if (summary.getId() != null) {
            if (!isSpecialBacked) {
                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.collaboration, summary.getId());
            }

            this.attachmentManager.deleteByReference(summary.getId(), summary.getId());
            summary.setSubject(summaryFromUE.getSubject());
            summary.setDeadline(summaryFromUE.getDeadline());
            summary.setDeadlineDatetime(summaryFromUE.getDeadlineDatetime());
            summary.setAdvanceRemind(summaryFromUE.getAdvanceRemind());
            summary.setAwakeDate(summaryFromUE.getAwakeDate());
            summary.setImportantLevel(summaryFromUE.getImportantLevel());
            summary.setArchiveId(summaryFromUE.getArchiveId());
            summary.setAdvancePigeonhole(summaryFromUE.getAdvancePigeonhole());
            summary.setProjectId(summaryFromUE.getProjectId());
            summary.setCanArchive(summaryFromUE.getCanArchive());
            summary.setCanAutostopflow(summaryFromUE.getCanAutostopflow());
            summary.setCanEdit(summaryFromUE.getCanEdit());
            summary.setCanEditAttachment(summaryFromUE.getCanEditAttachment());
            summary.setCanModify(summaryFromUE.getCanModify());
            summary.setCanForward(summaryFromUE.getCanForward());
            if (null == summaryFromUE.getCanMergeDeal()) {
                summary.setCanMergeDeal(false);
            }

            summary.setCanAnyMerge(summaryFromUE.getCanAnyMerge());
        }

        ContentSaveOrUpdateRet content = ContentUtil.contentSave();
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (MainbodyType.FORM.getKey() == Integer.valueOf((String)para.get("bodyType"))) {
            summary.setFormid(this.formCacheManager.getForm(Long.valueOf((String)para.get("contentTemplateId"))).getAuthViewBeanById(Long.valueOf((String)para.get("contentRightId"))).getFormViewId());
            summary.setFormAppid(Long.valueOf((String)para.get("contentTemplateId")));
            summary.setFormRecordid(Long.valueOf((String)para.get("contentDataId")));
        }

        boolean needMergeCreateDate = false;
        String subjectForCopy = info.getSubjectForCopy();
        if (Strings.isNotBlank(subjectForCopy) && subjectForCopy.equals(summary.getSubject())) {
            needMergeCreateDate = true;
        }

        if (!isSpecialBacked) {
            summary.setCreateDate(now);
            if (needMergeCreateDate) {
                summary.setSubject(this.getTemplateSubject(summary.getSubject(), now, true));
            }
        }

        summary.setState((Integer)null);
        summary.setStartMemberId(info.getCurrentUser().getId());
        summary.setBodyType((String)para.get("bodyType"));
        summary.setOrgAccountId(info.getCurrentUser().getLoginAccount());
        summary.setTempleteId(info.gettId());
        Long permissionAccountId = summary.getOrgAccountId();
        if (summary.getTempleteId() != null) {
            CtpTemplate t = this.templateManager.getCtpTemplate(summary.getTempleteId());
            if (t != null) {
                permissionAccountId = t.getOrgAccountId();
            }
        }

        summary.setPermissionAccountId(permissionAccountId);
        summary.setAudited(false);
        summary.setVouch(vouchState.defaultValue.ordinal());
        if (affair == null) {
            affair = new CtpAffair();
        }

        affair.setIdIfNew();
        affair.setApp(ApplicationCategoryEnum.collaboration.key());
        affair.setSubApp(summary.getTempleteId() == null ? ApplicationSubCategoryEnum.collaboration_self.key() : ApplicationSubCategoryEnum.collaboration_tempate.key());
        affair.setSubject(summary.getSubject());
        if (!isSpecialBacked) {
            affair.setCreateDate(now);
            if (needMergeCreateDate) {
                affair.setSubject(summary.getSubject());
            }
        }

        affair.setUpdateDate(now);
        affair.setMemberId(info.getCurrentUser().getId());
        affair.setObjectId(summary.getId());
        affair.setSubObjectId((Long)null);
        affair.setSenderId(info.getCurrentUser().getId());
        affair.setState(StateEnum.col_waitSend.key());
        String oldProcessId = summary.getProcessId();
        if (!isSpecialBacked) {
            boolean isTextTemplate = false;
            boolean isSystem = false;
            if (info.gettId() != null) {
                CtpTemplate t = this.templateManager.getCtpTemplate(info.gettId());
                isTextTemplate = Type.text.name().equals(t.getType());
                isSystem = true;
            }

            if (!Strings.isBlank(summary.getProcessId()) || isSystem && !isTextTemplate) {
                if (info.gettId() == null) {
                    summary.setProcessId(content.getProcessId());
                } else {
                    summary.setProcessId((String)null);
                }
            } else {
                summary.setProcessId(content.getProcessId());
            }

            summary.setCaseId((Long)null);
            affair.setSubState(SubStateEnum.col_waitSend_draft.key());
            summary.setStartDate((Date)null);
        }

        String newProcessId = summary.getProcessId();
        if (Strings.isNotBlank(oldProcessId) && Strings.isNotBlank(newProcessId) && !newProcessId.equals(oldProcessId)) {
            this.processLogManager.updateByHQL(Long.valueOf(newProcessId), Long.valueOf(oldProcessId));
        }

        affair.setDelete(false);
        affair.setTempleteId(summary.getTempleteId());
        affair.setTrack(info.getTrackType());
        affair.setBodyType((String)para.get("bodyType"));
        AffairUtil.setHasAttachments(affair, ColUtil.isHasAttachments(summary));
        affair.setImportantLevel(summary.getImportantLevel());
        affair.setResentTime(summary.getResentTime());
        affair.setForwardMember(summary.getForwardMember());
        affair.setProcessId(summary.getProcessId());
        affair.setCaseId(summary.getCaseId());
        affair.setOrgAccountId(summary.getOrgAccountId());
        affair.setNodePolicy("newCol");
        if (Strings.isNotBlank(info.getDR())) {
            affair.setRelationDataId(Long.valueOf(info.getDR()));
        }

        if (summary.getDeadlineDatetime() != null) {
            AffairUtil.addExtProperty(affair, AffairExtPropEnums.processPeriod, summary.getDeadlineDatetime());
        }

        String attaFlag = this.saveAttachmentFromDomain(ApplicationCategoryEnum.collaboration, summary.getId());
        if (Constants.isUploadLocaleFile(attaFlag)) {
            ColUtil.setHasAttachments(summary, true);
            AffairUtil.setHasAttachments(affair, true);
        } else {
            ColUtil.setHasAttachments(summary, false);
            AffairUtil.setHasAttachments(affair, false);
        }

        this.colDao.saveColSummary(summary);
        if (null != info.getCurTemId()) {
            this.updateTempleteHistory(info.getCurTemId());
        } else if (summary.getTempleteId() != null) {
            this.updateTempleteHistory(summary.getTempleteId());
        }

        DBAgent.saveOrUpdate(affair);
        if (!info.isM3Flag()) {
            this.saveColSupervise4NewColl(summary, false);
        }

        if (isSpecialBacked) {
            this.colPubManager.updateSpecialBackedAffair(summary);
        }

        if (info.getTrackType() == 2) {
            this.trackManager.deleteTrackMembers(summary.getId(), affair.getId());
            String trackMemberId = info.getTrackMemberId();
            String[] str = trackMemberId.split(",");
            List<CtpTrackMember> list = new ArrayList();
            CtpTrackMember member = null;

            for(int count = 0; count < str.length; ++count) {
                member = new CtpTrackMember();
                member.setIdIfNew();
                member.setAffairId(affair.getId());
                member.setObjectId(summary.getId());
                member.setMemberId(sender.getId());
                member.setTrackMemberId(Long.parseLong(str[count]));
                list.add(member);
            }

            this.trackManager.save(list);
        }

        Map<String, Object> tranMap = new HashMap();
        tranMap.put("summaryId", summary.getId());
        tranMap.put("contentId", info.getContentSaveId());
        tranMap.put("affairId", affair.getId());
        if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
            try {
                this.formManager.updateDataState(summary, affair, ColHandleType.save, (List)null);
            } catch (Exception var22) {
                LOG.error("更新表单相关信息异常", var22);
            }
        }

        return tranMap;
    }

    public List<ColSummaryVO> queryByCondition(FlipInfo flipInfo, Map<String, String> condition) throws BusinessException {
        return this.colDao.queryByCondition(flipInfo, condition);
    }

    public int countByCondition(Map<String, String> condition) throws BusinessException {
        return this.colDao.countByCondition(condition);
    }

    public Map getAttributeSettingInfo(Map<String, String> args) throws BusinessException {
        Map map = new HashMap();
        if (args == null) {
            return map;
        } else {
            String blank = ResourceUtil.getString("collaboration.project.nothing.label");
            String affairId = (String)args.get("affairId");
            if (Strings.isBlank(affairId)) {
                return map;
            } else {
                boolean isHistoryFlag = false;
                if (args.get("isHistoryFlag") != null && "true".equals((String)args.get("isHistoryFlag"))) {
                    isHistoryFlag = true;
                }

                CtpAffair affair = null;
                if (isHistoryFlag) {
                    affair = this.affairManager.getByHis(Long.parseLong(affairId));
                } else {
                    affair = this.affairManager.get(Long.parseLong(affairId));
                }

                if (affair == null) {
                    return map;
                } else {
                    String state = "";
                    switch(StateEnum.valueOf(affair.getState())) {
                        case col_waitSend:
                            state = ResourceUtil.getString("collaboration.state.11.waitSend");
                            break;
                        case col_sent:
                            state = ResourceUtil.getString("collaboration.state.12.col_sent");
                            break;
                        case col_pending:
                            state = ResourceUtil.getString("collaboration.state.13.col_pending");
                            break;
                        case col_done:
                            state = ResourceUtil.getString("collaboration.state.14.done");
                    }

                    map.put("flowState", state);
                    String processId = null;
                    Long templateWorkFlowID = null;
                    ColSummary colSummary;
                    String archiveName;
                    if (ApplicationCategoryEnum.collaboration.key() == affair.getApp()) {
                        colSummary = this.getColSummaryById(affair.getObjectId());
                        Boolean cOverTime = ColUtil.checkAffairIsOverTime(affair, colSummary);
                        map.put("cOverTime", Boolean.TRUE.equals(cOverTime) ? ResourceUtil.getString("pending.overtop.true.label") : ResourceUtil.getString("pending.overtop.false.label"));
                        processId = colSummary.getProcessId();
                        if (Strings.isBlank(processId) && Integer.valueOf(StateEnum.col_waitSend.getKey()).equals(affair.getState()) && colSummary.getTempleteId() != null) {
                            CtpTemplate t = this.templateManager.getCtpTemplate(colSummary.getTempleteId());
                            templateWorkFlowID = t.getWorkflowId();
                        }

                        Long projectId = colSummary.getProjectId();
                        if (projectId != null && projectId != -1L) {
                            if (null != this.projectApi) {
                                ProjectBO project = this.projectApi.getProject(projectId);
                                if (null != project) {
                                    archiveName = project.getProjectName();
                                    if (archiveName != null) {
                                        map.put("projectName", archiveName);
                                    } else {
                                        map.put("projectName", blank);
                                    }
                                }
                            }
                        } else {
                            map.put("projectName", blank);
                        }

                        Long archiveId = colSummary.getArchiveId();
                        archiveName = blank;
                        String archiveAllName = blank;
                        boolean queryArchievePath = true;
                        String retArchiveName;
                        if (Strings.isNotBlank(colSummary.getAdvancePigeonhole())) {
                            try {
                                JSONObject jo = new JSONObject(colSummary.getAdvancePigeonhole());
                                retArchiveName = jo.optString("archiveField", "");
                                if (Strings.isNotBlank(retArchiveName)) {
                                    archiveName = ColUtil.getAdvancePigeonholeName(colSummary.getArchiveId(), colSummary.getAdvancePigeonhole(), "col");
                                    if (jo.has("archiveFieldValue")) {
                                        String archiveFieldValue = jo.get("archiveFieldValue").toString();
                                        if (Strings.isNotBlank(archiveFieldValue) && Strings.isNotBlank(ColUtil.getArchiveAllNameById(archiveId))) {
                                            archiveAllName = ColUtil.getArchiveAllNameById(archiveId) + "\\" + archiveFieldValue;
                                        }
                                    } else if (jo.has("archiveFieldName") && Strings.isNotBlank(ColUtil.getArchiveAllNameById(archiveId))) {
                                        archiveAllName = ColUtil.getArchiveAllNameById(archiveId) + "\\{" + jo.get("archiveFieldName").toString() + "}";
                                    }

                                    queryArchievePath = false;
                                }
                            } catch (JSONException var32) {
                                LOG.info("解析归档信息", var32);
                            }
                        }

                        if (queryArchievePath && archiveId != null) {
                            archiveName = ColUtil.getArchiveNameById(archiveId);
                            archiveAllName = ColUtil.getArchiveAllNameById(archiveId);
                            if (Strings.isBlank(archiveName)) {
                                archiveName = blank;
                            }

                            if (Strings.isBlank(archiveAllName)) {
                                archiveAllName = blank;
                            }
                        }

                        String attachmentArchiveName = blank;
                        if (colSummary.getAttachmentArchiveId() != null) {
                            retArchiveName = ColUtil.getArchiveAllNameById(colSummary.getAttachmentArchiveId());
                            if (Strings.isBlank(retArchiveName)) {
                                retArchiveName = blank;
                            }

                            attachmentArchiveName = retArchiveName;
                        }

                        Boolean canPraise = true;
                        Boolean isFormTemplete = false;
                        if (colSummary.getTempleteId() != null) {
                            CtpTemplate t = this.templateManager.getCtpTemplate(colSummary.getTempleteId());
                            canPraise = t.getCanPraise();
                            if (String.valueOf(MainbodyType.FORM.getKey()).equals(t.getBodyType())) {
                                isFormTemplete = true;
                            }
                        }

                        map.put("isFormTemplete", isFormTemplete);
                        map.put("canPraise", canPraise);
                        map.put("attachmentArchiveName", attachmentArchiveName);
                        map.put("archiveName", archiveName);
                        map.put("archiveAllName", archiveAllName);
                        Integer importantLevel = colSummary.getImportantLevel();
                        map.put("importantLevel", importantLevel == null ? blank : ColUtil.getImportantLevel(importantLevel.toString()));
                        Date deadlineDatetime = colSummary.getDeadlineDatetime();
                        if (deadlineDatetime != null) {
                            map.put("deadline", ColUtil.getDeadLineName(deadlineDatetime));
                        } else {
                            String oldDeadLine = ColUtil.getDeadLineName(colSummary.getDeadline());
                            map.put("deadline", Strings.isNotBlank(oldDeadLine) ? oldDeadLine : blank);
                        }

                        Boolean canForward = colSummary.getCanForward();
                        map.put("canForward", Boolean.TRUE.equals(canForward) ? "1" : "0");
                        Boolean canModify = colSummary.getCanModify();
                        map.put("canModify", Boolean.TRUE.equals(canModify) ? "1" : "0");
                        Boolean canMergeDeal = colSummary.getCanMergeDeal();
                        map.put("canMergeDeal", Boolean.TRUE.equals(canMergeDeal) ? "1" : "0");
                        map.put("canAnyMerge", colSummary.getCanAnyMerge() ? "1" : "0");
                        Boolean canEdit = colSummary.getCanEdit();
                        map.put("canEdit", Boolean.TRUE.equals(canEdit) ? "1" : "0");
                        Boolean canEditAttachment = colSummary.getCanEditAttachment();
                        map.put("canEditAttachment", Boolean.TRUE.equals(canEditAttachment) ? "1" : "0");
                        Boolean canArchive = colSummary.getCanArchive();
                        map.put("canArchive", Boolean.TRUE.equals(canArchive) ? "1" : "0");
                        Boolean canAutoStopFlow = colSummary.getCanAutostopflow();
                        map.put("canAutoStopFlow", Boolean.TRUE.equals(canAutoStopFlow) ? "1" : "0");
                        Long advanceRemind = colSummary.getAdvanceRemind();
                        map.put("canDueReminder", advanceRemind == null ? blank : ColUtil.getAdvanceRemind(advanceRemind.toString()));
                        Date startDate = colSummary.getStartDate();
                        map.put("startDate", null != startDate ? DateUtil.formatDateTime(startDate) : "");
                        CtpSuperviseDetail detail = this.superviseManager.getSupervise(affair.getObjectId());
                        if (detail != null) {
                            map.put("awakeDate", DateUtil.formatDateTime(detail.getAwakeDate()));
                            map.put("supervisors", detail.getSupervisors());
                            map.put("supervise", "supervise");
                        }
                    }

                    if (String.valueOf(MainbodyType.FORM.getKey()).equals(affair.getBodyType())) {
                        colSummary = null;
                        Long operationId;
                        if (!Integer.valueOf(StateEnum.col_done.getKey()).equals(affair.getState()) && !Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState())) {
                            String oId = "";
                            if (templateWorkFlowID != null) {
                                oId = this.wapi.getNodeFormOperationName(templateWorkFlowID, (String)null);
                            } else {
                                oId = this.wapi.getNodeFormOperationNameFromRunning(processId, (String)null, isHistoryFlag);
                            }

                            operationId = Long.parseLong(oId);
                        } else {
                            operationId = affair.getFormOperationId();
                            if (operationId == null) {
                                operationId = Long.valueOf(ContentUtil.findRightIdbyAffairIdOrTemplateId(affair, affair.getTempleteId()));
                            }
                        }

                        FormAuthViewBean authViewBean = this.formCacheManager.getAuth(operationId);
                        FormViewBean viewBean = this.formCacheManager.getView(authViewBean.getFormViewId());
                        String operationName = authViewBean.getName();
                        archiveName = viewBean.getFormViewName();
                        map.put("formOperation", archiveName + "." + operationName);
                    }

                    return map;
                }
            }
        }
    }

    private int saveTrackInfo(CtpAffair affair, Map<String, String> params) throws BusinessException {
        Long affairId = affair.getId();
        Long summaryId = affair.getObjectId();
        int trackType = 0;
        String trackIds = "";
        if (null != params && params.size() > 0) {
            String isTrack = (String)params.get("isTrack");
            if ("1".equals(isTrack)) {
                trackType = 1;
                if (Integer.valueOf(TrackEnum.part.ordinal()).equals(affair.getTrack())) {
                    this.trackManager.deleteTrackMembers((Long)null, affair.getId());
                }

                if (null != params.get("trackRange_members")) {
                    trackType = 2;
                    trackIds = (String)params.get("zdgzry");
                }

                if (trackType == 2) {
                    String[] str = trackIds.split(",");
                    List<CtpTrackMember> list = new ArrayList();
                    if (Strings.isNotBlank(str[0])) {
                        CtpTrackMember member = null;

                        for(int count = 0; count < str.length; ++count) {
                            member = new CtpTrackMember();
                            member.setIdIfNew();
                            member.setAffairId(affairId);
                            member.setObjectId(summaryId);
                            member.setMemberId(affair.getMemberId());
                            member.setTrackMemberId(Long.parseLong(str[count]));
                            list.add(member);
                        }

                        this.trackManager.save(list);
                    }
                }
            } else if (isTrack == null && !Integer.valueOf(TrackEnum.no.ordinal()).equals(affair.getTrack())) {
                this.trackManager.deleteTrackMembers((Long)null, affair.getId());
            }
        }

        affair.setTrack(Integer.valueOf(trackType));
        return trackType;
    }

    public void transFinishWorkItem(ColSummary summary, CtpAffair affair, Map<String, Object> params) throws BusinessException {
        Map<String, Object> superviseMap = ParamUtil.getJsonDomain("superviseDiv");
        String isModifySupervise = (String)superviseMap.get("isModifySupervise");
        if ("1".equals(isModifySupervise)) {
            SuperviseMessageParam smp = new SuperviseMessageParam(true, summary.getImportantLevel(), summary.getSubject(), summary.getForwardMember(), summary.getStartMemberId());
            this.superviseManager.saveOrUpdateSupervise4Process(smp, summary.getId(), EntityType.summary);
        }

        Comment comment = ContentUtil.getCommnetFromRequest(OperationType.finish, affair.getMemberId(), affair.getObjectId());
        this.transFinishWorkItemPublic(affair, summary, comment, ColHandleType.finish, params);
    }

    public void transFinishWorkItemPublic(Long affairId, Comment comment, Map<String, Object> params) throws BusinessException {
        CtpAffair affair = this.affairManager.get(affairId);
        ColSummary summary = this.getColSummaryById(affair.getObjectId());
        this.transFinishWorkItemPublic(affair, summary, comment, ColHandleType.finish, params);
    }

    public void transFinishWorkItemPublic(CtpAffair affair, ColSummary summary, Comment comment, ColHandleType handleType, Map<String, Object> params) throws BusinessException {
        try {
            if (!ColUtil.checkAgent(affair, summary, true)) {
                return;
            }
        } catch (Exception var8) {
            LOG.error("", var8);
        }

        String isTrack = String.valueOf(params.get("isTrack"));
        if (!"1".equals(isTrack) && !Integer.valueOf(TrackEnum.no.ordinal()).equals(affair.getTrack())) {
            this.trackManager.deleteTrackMembers((Long)null, affair.getId());
            affair.setTrack(0);
            this.affairManager.updateAffair(affair);
        }

        CollaborationProcessEvent event = new CollaborationProcessEvent(this);
        event.setSummaryId(summary.getId());
        event.setAffair(affair);
        event.setComment(comment);
        EventDispatcher.fireEvent(event);
        if ("vouch".equalsIgnoreCase(affair.getNodePolicy())) {
            summary.setVouch(vouchState.pass.ordinal());
        }

        if ("formaudit".equals(affair.getNodePolicy())) {
            summary.setAudited(true);
        }

        this.transFinishAndZcdb(affair, summary, comment, handleType, params);
    }

    private void transFinishAndZcdb(CtpAffair affair, ColSummary summary, Comment comment, ColHandleType handleType, Map<String, Object> params) throws BusinessException {
        User user = AppContext.getCurrentUser();
        Map<String, String> colSummaryDomian = ParamUtil.getJsonDomain("colSummaryData");
        System.out.println("colSummaryDomian:"+colSummaryDomian);
        String _flowPermAccountId = (String)colSummaryDomian.get("flowPermAccountId");
        Long flowPermAccountId = Strings.isBlank(_flowPermAccountId) ? summary.getOrgAccountId() : Long.valueOf(_flowPermAccountId);
        System.out.println("flowPermAccountId:"+flowPermAccountId);
        System.out.println("params:"+params);
        if (comment != null) {
            if (comment.getId() != null) {
                CtpCommentAll c = this.commentManager.getDrfatComment(affair.getId());
                if (c != null) {
                    this.commentManager.deleteComment(ModuleType.collaboration, c.getId());
                    this.attachmentManager.deleteByReference(summary.getId(), c.getId());
                }
            }

            comment.setPushMessage(false);
            comment.setId(UUIDLong.longUUID());
            this.commentManager.insertComment(comment, affair);
            CollaborationAddCommentEvent commentEvent = new CollaborationAddCommentEvent(this);
            commentEvent.setCommentId(comment.getId());
            EventDispatcher.fireEvent(commentEvent);
        }

        this.saveAttDatas(user, summary, affair, comment.getId());
        AffairUtil.setHasAttachments(affair, ColUtil.isHasAttachments(summary));
        AffairData affairData = ColUtil.getAffairData(summary);
        affairData.setMemberId(affair.getMemberId());
        affairData.addBusinessData("flowPermAccountId", flowPermAccountId);
        Integer t = WorkFlowEventListener.COMMONDISPOSAL;
        if (handleType.ordinal() == ColHandleType.wait.ordinal()) {
            t = WorkFlowEventListener.ZCDB;
        }

        affairData.addBusinessData("operationType", t);
        Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
        System.out.println("wfdef:"+wfdef);
        String messageDataListJSON = (String)wfdef.get("process_message_data");
        Date actionTime = this.colMessageManager.sendOperationTypeMessage(messageDataListJSON, summary, affair, comment.getId());
        actionTime = Datetimes.addSecond(actionTime, 1);
        this.checkCollSubject(summary, affair, params);
        Boolean isRego = false;
        String isProcessCompetion;
        String _pigeonholeValue;
        if (handleType.ordinal() == ColHandleType.wait.ordinal()) {
            ContentUtil.workflowWait(affairData, affair.getSubObjectId(), summary, params);
            this.processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.zcdb, comment.getId(), actionTime, new String[0]);
            this.colMessageManager.sendMessage4Zcdb(affair, comment);
        } else {
            Boolean isSepicalBackedSubmit = Integer.valueOf(SubStateEnum.col_pending_specialBacked.getKey()).equals(affair.getSubState());
            isProcessCompetion = (String)params.get("conditionsOfNodes");
            _pigeonholeValue = (String)params.get("subState");
            Map<String, String> wfRetMap = ContentUtil.workflowFinish(comment, affairData, affair.getSubObjectId(), affair, summary, isProcessCompetion, _pigeonholeValue, params);
            String nextMembers = (String)wfRetMap.get("nextMembers");
            isRego = "true".equals(wfRetMap.get("isRego"));
            String nextMembersWithoutPolicyInfo = (String)wfRetMap.get("nextMembersWithoutPolicyInfo");
            if (Strings.isNotBlank(nextMembersWithoutPolicyInfo) && isSepicalBackedSubmit) {
                this.colMessageManager.transSendSubmitMessage4SepicalBacked(summary, nextMembersWithoutPolicyInfo, affair, comment);
            }

            List<ProcessLogDetail> allProcessLogDetailList = this.wapi.getAllWorkflowMatchLogAndRemoveCache();
            this.processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.commit, comment.getId(), actionTime, allProcessLogDetailList, new String[]{nextMembers});
            affair.setState(StateEnum.col_done.getKey());
        }

        Date nowTime;
        long responseTime;
        if (affair.getSignleViewPeriod() == null && affair.getFirstViewDate() != null) {
            nowTime = new Date();
            responseTime = this.workTimeManager.getDealWithTimeValue(affair.getFirstViewDate(), nowTime, affair.getOrgAccountId());
            affair.setSignleViewPeriod(responseTime);
        }

        if (affair.getFirstResponsePeriod() == null) {
            nowTime = new Date();
            responseTime = this.workTimeManager.getDealWithTimeValue(affair.getReceiveTime(), nowTime, affair.getOrgAccountId());
            affair.setFirstResponsePeriod(responseTime);
        }

        if (handleType.ordinal() == ColHandleType.finish.ordinal()) {
            HttpServletRequest request = AppContext.getRawRequest();
            Long pigeonholeValue = null;
            if (request != null) {
                _pigeonholeValue = request.getParameter("pigeonholeValue");
                if (_pigeonholeValue != null) {
                    pigeonholeValue = Long.parseLong(_pigeonholeValue);
                }
            }

            _pigeonholeValue = (String)params.get("archiveValue");
            if (Strings.isNotBlank(_pigeonholeValue) && NumberUtils.isNumber(_pigeonholeValue)) {
                pigeonholeValue = Long.valueOf(_pigeonholeValue);
            }

            if (pigeonholeValue != null && pigeonholeValue != 0L) {
                this.transPigeonhole(summary, affair, pigeonholeValue, "handle");
            }
        }

        if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
            List commentList = this.commentManager.getCommentAllByModuleId(ModuleType.collaboration, affair.getObjectId());

            try {
                this.formManager.updateDataState(summary, affair, handleType, commentList);
            } catch (Exception var23) {
                LOG.error("更新表单相关信息异常", var23);
            }
        }

        boolean isFinished = Integer.valueOf(flowState.finish.ordinal()).equals(summary.getState()) || Integer.valueOf(flowState.terminate.ordinal()).equals(summary.getState());
        if (isFinished) {
            affair.setFinish(true);
        } else {
            Map<String, String> trackParam = (Map)params.get("trackParam");
            this.saveTrackInfo(affair, trackParam);
        }

        this.affairManager.updateAffair(affair);
        if (Strings.isNotBlank(affair.getNodePolicy()) && !"inform".equals(affair.getNodePolicy())) {
            isProcessCompetion = DateSharedWithWorkflowEngineThreadLocal.getIsProcessCompetion();
            if (!isRego && (!Strings.isNotBlank(isProcessCompetion) || !isProcessCompetion.equals("1"))) {
                if (handleType.ordinal() == ColHandleType.finish.ordinal()) {
                    ColUtil.setCurrentNodesInfoFromCache(summary, affair.getMemberId());
                } else {
                    ColUtil.setCurrentNodesInfoFromCache(summary, (Long)null);
                }
            } else {
                ColUtil.updateCurrentNodesInfo(summary);
            }
        }

        ColUtil.addOneReplyCounts(summary);
        this.updateColSummary(summary);
        if (AppContext.hasPlugin("index")) {
            boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType());

            try {
                if (isForm) {
                    this.indexManager.update(summary.getId(), ApplicationCategoryEnum.form.getKey());
                } else {
                    this.indexManager.update(summary.getId(), ApplicationCategoryEnum.collaboration.getKey());
                }
            } catch (Exception var24) {
                String errorInfo = "全文检索更新异常,传入参数summaryId:" + summary.getId() + "mnoduletype:" + (isForm ? "2" : "1");
                LOG.error(errorInfo, var24);
                throw new BusinessException(errorInfo, var24);
            }
        }

        ColSelfUtil.fireAutoSkipEvent(this);
    }

    private void checkCollSubject(ColSummary summary, CtpAffair affair, Map<String, Object> params) {
        String templateColSubject = (String)params.get("templateColSubject");
        String templateWorkflowId = "";
        Object temWorkflowId = params.get("templateWorkflowId");
        if (null != temWorkflowId && temWorkflowId instanceof Long) {
            templateWorkflowId = String.valueOf((Long)temWorkflowId);
        } else {
            templateWorkflowId = (String)params.get("templateWorkflowId");
        }

        Long templateId = summary.getTempleteId();
        if (templateId != null && Strings.isNotBlank(templateColSubject) && Strings.isNotBlank(templateWorkflowId)) {
            User user = AppContext.getCurrentUser();

            try {
                String newSubject = ColUtil.makeSubject(templateColSubject, Long.valueOf(templateWorkflowId), summary, user);
                String oldSubject = summary.getSubject();
                if (!oldSubject.equals(newSubject) && Strings.isNotBlank(newSubject)) {
                    CtpTemplate template = this.templateManager.getCtpTemplate(templateId);
                    if (template != null) {
                        ColSummary summary1 = (ColSummary)XMLCoder.decoder(template.getSummary());
                        if (summary1 != null && summary1.getUpdateSubject() != null && summary1.getUpdateSubject()) {
                            Long summaryId = summary.getId();
                            summary.setSubject(newSubject);
                            affair.setSubject(newSubject);
                            this.affairManager.updateFormCollSubject(summaryId, newSubject);
                            this.ctpMainbodyManager.updateTitleByModuleId(newSubject, summaryId);
                            if (this.docApi != null) {
                                this.docApi.updateDocResourceFRNameByColSummaryId(newSubject, summaryId);
                                this.docApi.updateDocMetadataAvarchar1ByColSummaryId(newSubject, summaryId);
                            }

                            this.colTraceWorkflowManager.updateSubjectByModuleId(newSubject, summaryId);
                            List<Long> affairIdList = this.affairManager.getAllAffairIdByAppAndObjectId(ApplicationCategoryEnum.collaboration, summaryId);
                            this.attachmentManager.updateFileNameByAffairIds(newSubject, affairIdList);
                            this.superviseManager.updateSubjectByEntityId(newSubject, summaryId);
                            this.formRelationManager.updateSummarySubjectByModuleId(newSubject, summaryId);
                            LOG.info("表单协同标题有变化：summaryId=" + summaryId + "，oldSubject=" + oldSubject + "，newSubject=" + newSubject + "，userId=" + user.getId());
                        }
                    }
                }
            } catch (BusinessException var15) {
                LOG.error("更新表单协同标题时发生异常：", var15);
            }
        }

    }

    private void saveAttDatas(User user, ColSummary summary, CtpAffair affair, Long commentId) throws BusinessException {
        Map<String, String> colSummaryDomian = ParamUtil.getJsonDomain("colSummaryData");
        if (colSummaryDomian != null) {
            AttachmentEditUtil attUtil = new AttachmentEditUtil("attActionLogDomain");
            boolean modifyContent = "1".equals(colSummaryDomian.get("modifyFlag"));
            boolean modifyAtt = attUtil.hasEditAtt();
            if (modifyAtt) {
                this.saveAttachment(summary, affair, !modifyContent, commentId);
            }

            if (modifyContent) {
                this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.processColl, commentId, new String[]{String.valueOf(ProcessEdocAction.modifyBody.getKey())});
                if (!modifyAtt) {
                    this.colMessageManager.sendMessage4ModifyBodyOrAtt(summary, affair.getMemberId(), 1);
                }

                if ("1".equals(colSummaryDomian.get("isLoadNewFile"))) {
                    this.appLogManager.insertLog(user, AppLogAction.Coll_Content_Edit_LoadNewFile, new String[]{user.getName(), affair.getSubject()});
                }
            }

            if (modifyAtt && modifyContent) {
                this.colMessageManager.sendMessage4ModifyBodyOrAtt(summary, affair.getMemberId(), 2);
            }
        }

    }

    private String saveAttachment(ColSummary summary, CtpAffair affair, boolean toSendMsg, Long commentId) throws BusinessException {
        String attaFlag = "";

        try {
            List attFileGroup = ParamUtil.getJsonDomainGroup("attFileDomain");
            int attFileSize = attFileGroup.size();
            Map attFileMap = ParamUtil.getJsonDomain("attFileDomain");
            if (attFileSize == 0 && attFileMap.size() > 0) {
                attFileGroup.add(attFileMap);
            }

            List assDocGroup = ParamUtil.getJsonDomainGroup("assDocDomain");
            int assDocSize = assDocGroup.size();
            Map assDocMap = ParamUtil.getJsonDomain("assDocDomain");
            if (assDocSize == 0 && assDocMap.size() > 0) {
                assDocGroup.add(assDocMap);
            }

            attFileGroup.addAll(assDocGroup);
            List<Attachment> result = this.attachmentManager.getAttachmentsFromAttachList(ApplicationCategoryEnum.collaboration, summary.getId(), summary.getId(), attFileGroup);
            List<Attachment> oldAtts = this.attachmentManager.getByReference(summary.getId(), summary.getId());
            Set<Attachment> needAddAtts = new HashSet();
            Set<Long> newAttFUIds = new HashSet();
            Map<Long, Attachment> nm = new HashMap();
            Map<Long, Long> oldFUID = new HashMap();
            Set<Long> oldAttFUIds = new HashSet();
            LOG.info("===============当前附件：");
            Iterator var19 = result.iterator();

            Attachment oldAtt;
            while(var19.hasNext()) {
                oldAtt = (Attachment)var19.next();
                newAttFUIds.add(oldAtt.getFileUrl());
                nm.put(oldAtt.getFileUrl(), oldAtt);
                LOG.info("文件名：" + oldAtt.getFilename() + ",ID：" + oldAtt.getId() + "创建时间：" + oldAtt.getCreatedate());
            }

            LOG.info("原来的附件：");
            var19 = oldAtts.iterator();

            while(var19.hasNext()) {
                oldAtt = (Attachment)var19.next();
                oldAttFUIds.add(oldAtt.getFileUrl());
                oldFUID.put(oldAtt.getFileUrl(), oldAtt.getId());
                LOG.info("文件名：" + oldAtt.getFilename() + ",ID：" + oldAtt.getId() + "创建时间：" + oldAtt.getCreatedate());
            }

            var19 = newAttFUIds.iterator();

            Long id;
            while(var19.hasNext()) {
                id = (Long)var19.next();
                if (!oldAttFUIds.contains(id)) {
                    needAddAtts.add(nm.get(id));
                    LOG.info("添加的附件fileUrl：" + nm.get(id));
                }
            }

            var19 = oldAttFUIds.iterator();

            while(var19.hasNext()) {
                id = (Long)var19.next();
                if (!newAttFUIds.contains(id)) {
                    this.attachmentManager.deleteById((Long)oldFUID.get(id));
                    LOG.info("删除附件 ：" + oldFUID.get(id));
                }
            }

            attaFlag = this.attachmentManager.create(needAddAtts);
            LOG.info("添加附件成功返回的attaFlag:" + attaFlag);
            AttachmentEditUtil attUtil = new AttachmentEditUtil("attActionLogDomain");
            List<ProcessLog> logs = attUtil.parseProcessLog(Long.valueOf(summary.getProcessId()), affair.getActivityId());
            Iterator var21 = logs.iterator();

            while(var21.hasNext()) {
                ProcessLog log = (ProcessLog)var21.next();
                log.setCommentId(commentId);
            }

            this.processLogManager.insertLog(logs);
            this.updateSummaryAttachment(result.size(), summary, affair, toSendMsg);
            if (AppContext.hasPlugin("index")) {
                if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                    this.indexManager.update(affair.getObjectId(), ApplicationCategoryEnum.form.getKey());
                } else {
                    this.indexManager.update(affair.getObjectId(), ApplicationCategoryEnum.collaboration.getKey());
                }
            }

            return attaFlag;
        } catch (Exception var23) {
            LOG.error("创建附件出错，位于方法ColManagerImpl.saveAttachment", var23);
            throw new BusinessException("创建附件出错");
        }
    }

    private void updateSummaryAttachment(int attSize, ColSummary summary, CtpAffair affair, boolean toSendMsg) throws BusinessException {
        Map<String, String> colSummaryDomian = ParamUtil.getJsonDomain("colSummaryData");
        int type = 0;
        boolean needUpdate = false;
        boolean isHasAtt = ColUtil.isHasAttachments(summary);
        if (!isHasAtt && attSize > 0) {
            needUpdate = true;
            ColUtil.setHasAttachments(summary, true);
        } else if (isHasAtt && attSize == 0) {
            needUpdate = true;
            ColUtil.setHasAttachments(summary, false);
        }

        if (needUpdate) {
            Map<String, Object> parameter = new HashMap();
            parameter.put("identifier", summary.getIdentifier());
            this.updateColSummary(summary);
            this.affairManager.updateAffairs(ApplicationCategoryEnum.collaboration, summary.getId(), parameter);
        }

        if (toSendMsg) {
            this.colMessageManager.sendMessage4ModifyBodyOrAtt(summary, affair.getMemberId(), 0);
        }

    }

    public Long getSentAffairIdByFormRecordId(Long formRecordId) throws BusinessException {
        ColSummary s = this.colDao.getColSummaryByFormRecordId(formRecordId);
        if (s != null) {
            CtpAffair aff = this.affairManager.getSenderAffair(s.getId());
            return aff.getId();
        } else {
            return 0L;
        }
    }

    public List<String> checkForwardPermission(String data) throws BusinessException {
        List<String> noPermissionCols = new ArrayList();
        User user = AppContext.getCurrentUser();
        String[] ds = data.split("[,]");
        String[] var5 = ds;
        int var6 = ds.length;

        for(int var7 = 0; var7 < var6; ++var7) {
            String d1 = var5[var7];
            if (!Strings.isBlank(d1)) {
                String[] d1s = d1.split("[_]");
                long summaryId = Long.parseLong(d1s[0]);
                long affairId = Long.parseLong(d1s[1]);
                CtpAffair affair = this.affairManager.get(affairId);
                ColSummary summary = this.getColSummaryById(summaryId);
                if (!Strings.isTrue(summary.getCanForward())) {
                    noPermissionCols.add("&lt;" + ColUtil.showSubjectOfSummary(summary, false, -1, "") + "&gt;");
                } else {
                    String ActivityId = affair.getActivityId() == null ? "start" : String.valueOf(affair.getActivityId());
                    Boolean isNewColNode = StateEnum.col_sent.getKey() == affair.getState() || StateEnum.col_waitSend.getKey() == affair.getState();
                    String[] nodePolicy = this.wapi.getNodePolicyIdAndName(ApplicationCategoryEnum.collaboration.name(), summary.getProcessId(), ActivityId);
                    if (isNewColNode) {
                        NodePolicyVO newColNodePolicy = this.getNewColNodePolicy(user.getLoginAccount());
                        if (!newColNodePolicy.isForward()) {
                            noPermissionCols.add("&lt;" + ColUtil.showSubjectOfSummary(summary, false, -1, "") + "&gt;");
                        }
                    } else if (nodePolicy != null && nodePolicy.length > 0) {
                        Long accountId = ColUtil.getFlowPermAccountId(user.getLoginAccount(), summary);
                        List<String> actionList = this.permissionManager.getActionList(ConfigCategory.col_flow_perm_policy.name(), nodePolicy[0], accountId);
                        if (!actionList.contains("Forward")) {
                            noPermissionCols.add("&lt;" + ColUtil.showSubjectOfSummary(summary, false, -1, "") + "&gt;");
                        }
                    }
                }
            }
        }

        return noPermissionCols;
    }

    public void transDoForward(User user, Long summaryId, Long affairId, Map para) throws BusinessException {
        LOG.info("transDoForward...start summaryId=" + summaryId + "..affairId=" + affairId);
        boolean forwardOriginalNote = "1".equals(para.get("forwardOriginalNote"));
        boolean forwardOriginalopinion = "1".equals(para.get("forwardOriginalopinion"));
        boolean track = "1".equals(para.get("track"));
        String commentContent = (String)para.get("comment");
        ColSummary oldSummary = this.getColSummaryById(summaryId);
        Date now = new Date();

        ColSummary newSummary;
        try {
            newSummary = (ColSummary)oldSummary.clone();
        } catch (Exception var34) {
            LOG.error("", var34);
            throw new BusinessException(var34);
        }

        newSummary.setCurrentNodesInfo("");
        newSummary.setProcessNodesInfo("");
        Long templeteId = newSummary.getTempleteId();
        newSummary.setNewId();
        newSummary.setForwardMember(String.valueOf(oldSummary.getStartMemberId()));
        if (oldSummary.getParentformSummaryid() != null) {
            newSummary.setParentformSummaryid(oldSummary.getParentformSummaryid());
        } else {
            newSummary.setParentformSummaryid(oldSummary.getId());
        }

        newSummary.setTempleteId((Long)null);
        newSummary.setArchiveId((Long)null);
        newSummary.setAudited(false);
        newSummary.setVouch(0);
        newSummary.setCreateDate(now);
        newSummary.setFinishDate((Date)null);
        newSummary.setFormAppid((Long)null);
        newSummary.setFormid((Long)null);
        newSummary.setFormRecordid((Long)null);
        newSummary.setProcessId((String)null);
        newSummary.setCaseId((Long)null);
        newSummary.setSuperviseTitle((String)null);
        newSummary.setSupervisors((String)null);
        newSummary.setSupervisorsId((String)null);
        newSummary.setAwakeDate((String)null);
        newSummary.setAttachmentArchiveId((Long)null);
        newSummary.setReplyCounts(0);
        MainbodyType newBodyType = MainbodyType.HTML;
        String newContent = "";
        Long contentDataId = null;
        List<CtpContentAll> contents = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, oldSummary.getId());
        if (Strings.isNotEmpty(contents)) {
            CtpContentAll oldContentAll = (CtpContentAll)contents.get(0);
            MainbodyType oldBodyType = MainbodyType.getEnumByKey(oldContentAll.getContentType());
            String oldContent = oldContentAll.getContent();
            LOG.info("transDoForward...contents=" + contents.size() + ",oldBodyType" + oldBodyType + ",templeteId=" + templeteId);
            switch(oldBodyType) {
                case OfficeWord:
                case OfficeExcel:
                case WpsWord:
                case WpsExcel:
                case Pdf:
                    V3XFile newFile = null;

                    try {
                        newFile = this.fileManager.clone(oldContentAll.getContentDataId(), true);
                        newBodyType = oldBodyType;
                        newContent = oldContentAll.getContentDataId() == null ? "" : String.valueOf(oldContentAll.getContentDataId());
                        contentDataId = newFile.getId();
                        this.signetManager.insertSignet(oldContentAll.getContentDataId(), contentDataId);
                    } catch (Exception var33) {
                        LOG.error("", var33);
                    }
                    break;
                case FORM:
                    newBodyType = MainbodyType.HTML;
                    newSummary.setCanEdit(false);
                    CtpAffair aff = this.affairManager.get(affairId);
                    String formRightId = "-1";
                    if (aff != null) {
                        formRightId = ContentUtil.findRightIdbyAffairIdOrTemplateId(aff, templeteId);
                    }

                    String[] frId = formRightId.split("[_]");
                    this.transForwardBody(newSummary.getId(), oldContentAll.getModuleId(), Long.valueOf(frId[0]));
                    newContent = MainbodyService.getInstance().getContentHTML(oldContentAll.getModuleType(), oldContentAll.getModuleId(), formRightId);
                    List<CtpContentAll> ctpContentAll = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summaryId);
                    if (ctpContentAll != null && ctpContentAll.size() > 0 && Strings.isNotBlank(((CtpContentAll)ctpContentAll.get(0)).getContent())) {
                        Long formID = ((CtpContentAll)ctpContentAll.get(0)).getContentTemplateId();
                        String templateAuth = FormService.getForm(formID).getAuthViewBeanById(Long.valueOf(frId[0])).getTemplateAuth();
                        if (Strings.isNotBlank(templateAuth) && !"hide".equals(templateAuth)) {
                            List<Attachment> attachments = this.attachmentManager.getByReference(((CtpContentAll)ctpContentAll.get(0)).getContentDataId(), Long.parseLong(((CtpContentAll)ctpContentAll.get(0)).getContent()));
                            if (Strings.isNotEmpty(attachments)) {
                                List<Attachment> _attNews = new ArrayList();
                                Iterator var29 = attachments.iterator();

                                while(var29.hasNext()) {
                                    Attachment att = (Attachment)var29.next();

                                    try {
                                        Attachment attNew = (Attachment)att.clone();
                                        attNew.setNewId();
                                        attNew.setReference(newSummary.getId());
                                        attNew.setSubReference(newSummary.getId());
                                        _attNews.add(attNew);
                                    } catch (CloneNotSupportedException var32) {
                                        LOG.error("", var32);
                                    }
                                }

                                boolean attaFlag = false;
                                String attaFlagStr = this.attachmentManager.create(_attNews);
                                attaFlag = Constants.isUploadLocaleFile(attaFlagStr);
                                if (attaFlag) {
                                    ColUtil.setHasAttachments(newSummary, attaFlag);
                                }
                            }
                        }
                    }

                    this.iSignatureHtmlManager.save(summaryId, newSummary.getId());
                    break;
                case HTML:
                case TXT:
                default:
                    newBodyType = oldBodyType;
                    newContent = oldContent;
                    this.iSignatureHtmlManager.save(summaryId, newSummary.getId());
            }
        }

        newSummary.setBodyType(String.valueOf(newBodyType.getKey()));
        this.commentManager.transForwardComment(ModuleType.collaboration, oldSummary.getId(), ModuleType.collaboration, newSummary.getId(), forwardOriginalNote, forwardOriginalopinion);
        if (String.valueOf(MainbodyType.HTML.getKey()).equals(oldSummary.getBodyType())) {
            this.addToFromHTMLAtt(summaryId, newSummary.getId());
        }

        ColInfo info = new ColInfo();
        info.setTrackType(track ? TrackEnum.all.ordinal() : TrackEnum.no.ordinal());
        info.setSummary(newSummary);
        info.setCurrentUser(user);
        info.setNewBusiness(true);
        info.setBody(newBodyType, newContent, contentDataId, now);
        if (Strings.isNotBlank(commentContent)) {
            info.setComment(commentContent);
        }

        newSummary.setDeadline(0L);
        newSummary.setDeadlineDatetime((Date)null);
        newSummary.setArchiveId((Long)null);
        newSummary.setAdvancePigeonhole((String)null);
        newSummary.setAdvanceRemind((Long)null);
        newSummary.setCanAutostopflow(false);
        newSummary.setCanMergeDeal(false);
        newSummary.setCanAnyMerge(false);
        this.colPubManager.transSendColl(SendType.forward, info);
    }

    private void addToFromHTMLAtt(Long oldSummaryId, Long summaryId) {
        List<Attachment> attachment = this.attachmentManager.getByReference(oldSummaryId);
        List<Attachment> newAtts = new ArrayList();
        Iterator var5 = attachment.iterator();

        while(var5.hasNext()) {
            Attachment att = (Attachment)var5.next();
            if ("100".equals(att.getSubReference().toString())) {
                try {
                    Attachment newAtt = null;
                    newAtt = (Attachment)att.clone();
                    newAtt.setNewId();
                    newAtt.setFileUrl(att.getFileUrl());
                    newAtt.setReference(summaryId);
                    newAtt.setSubReference(100L);
                    newAtts.add(newAtt);
                } catch (Exception var8) {
                    LOG.warn("添加表单中的附件报错！", var8);
                }
            }
        }

        this.attachmentManager.create(newAtts);
    }

    public String replaceInlineAttachment(String html) {
        if (Strings.isEmpty(html)) {
            return html;
        } else {
            String result = html;
            Matcher matcher = PATTERN_ATTACHMENT_ID.matcher(html);

            while(matcher.find()) {
                try {
                    String id = matcher.group(1);
                    String lodId = id.substring(0, id.indexOf("\""));
                    String fileUrlStr = id.substring(id.lastIndexOf("\"fileUrl\":\""));
                    String fileUrl = fileUrlStr.substring(11, fileUrlStr.indexOf(",") - 1);
                    String v = SecurityHelper.digest(new Object[]{fileUrl});
                    if (result.indexOf("\"v\":\"") > -1) {
                        result = result.replaceAll("\"v\":\"" + lodId + "\"", "\"v\":\"" + v + "\"");
                    }
                } catch (Throwable var9) {
                    LOG.error("", var9);
                }
            }

            return result;
        }
    }

    public void transDoZcdb(ColSummary summary, CtpAffair affair, Map<String, Object> params) throws BusinessException {
        Map<String, Object> superviseMap = ParamUtil.getJsonDomain("superviseDiv");
        String isModifySupervise = (String)superviseMap.get("isModifySupervise");
        if ("1".equals(isModifySupervise)) {
            DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
            SuperviseMessageParam smp = new SuperviseMessageParam(true, summary.getImportantLevel(), summary.getSubject(), summary.getForwardMember(), summary.getStartMemberId());
            this.superviseManager.saveOrUpdateSupervise4Process(smp, summary.getId(), EntityType.summary);
        }

        Comment comment = ContentUtil.getCommnetFromRequest(OperationType.wait, affair.getMemberId(), affair.getObjectId());
        this.transDoZcdbPublic(affair, summary, comment, ColHandleType.wait, params);
    }

    public void transDoZcdbPublic(CtpAffair affair, ColSummary summary, Comment comment, ColHandleType handType, Map<String, Object> params) throws BusinessException {
        affair.setUpdateDate(new Timestamp(System.currentTimeMillis()));
        affair.setSubState(SubStateEnum.col_pending_ZCDB.key());
        this.affairManager.updateAffair(affair);
        this.transFinishAndZcdb(affair, summary, comment, ColHandleType.wait, params);
    }

    public void getTrackInfo(TrackAjaxTranObj obj) throws BusinessException {
        String oldTrackType = obj.getOldTrackType();
        String newTrackType = obj.getNewTrackType();
        String affairId = obj.getAffairId();
        String objectId = obj.getObjectId();
        String trackMemberIds = obj.getTrackMemberIds();
        String senderId = obj.getSenderId();
        String[] ids = null;
        if (Strings.isNotBlank(trackMemberIds)) {
            ids = trackMemberIds.split(",");
        }

        CtpAffair affair;
        if ("0".equals(oldTrackType) && "1".equals(newTrackType)) {
            new CtpAffair();
            affair = this.affairManager.get(Long.parseLong(affairId));
            affair.setTrack(Integer.parseInt(newTrackType));
            this.affairManager.updateAffair(affair);
        }

        CtpTrackMember member;
        int i;
        ArrayList list;
//        CtpAffair affair;
        if ("0".equals(oldTrackType) && "2".equals(newTrackType)) {
            list = new ArrayList();
            if (null != ids) {
                member = null;

                for(i = 0; i < ids.length; ++i) {
                    member = new CtpTrackMember();
                    member.setIdIfNew();
                    member.setAffairId(Long.parseLong(affairId));
                    member.setObjectId(Long.parseLong(objectId));
                    member.setMemberId(Long.parseLong(senderId));
                    member.setTrackMemberId(Long.parseLong(ids[i]));
                    list.add(member);
                }

                this.trackManager.save(list);
            }

            new CtpAffair();
            affair = this.affairManager.get(Long.parseLong(affairId));
            affair.setTrack(Integer.parseInt(newTrackType));
            this.affairManager.updateAffair(affair);
        }

        if ("1".equals(oldTrackType) && "0".equals(newTrackType)) {
            new CtpAffair();
            affair = this.affairManager.get(Long.parseLong(affairId));
            affair.setTrack(Integer.parseInt(newTrackType));
            this.affairManager.updateAffair(affair);
        }

        if ("1".equals(oldTrackType) && "2".equals(newTrackType)) {
            list = new ArrayList();
            if (null != ids) {
                member = null;

                for(i = 0; i < ids.length; ++i) {
                    member = new CtpTrackMember();
                    member.setIdIfNew();
                    member.setAffairId(Long.parseLong(affairId));
                    member.setObjectId(Long.parseLong(objectId));
                    member.setMemberId(Long.parseLong(senderId));
                    member.setTrackMemberId(Long.parseLong(ids[i]));
                    list.add(member);
                }

                this.trackManager.save(list);
            }

            new CtpAffair();
            affair = this.affairManager.get(Long.parseLong(affairId));
            affair.setTrack(Integer.parseInt(newTrackType));
            this.affairManager.updateAffair(affair);
        }

        if ("2".equals(oldTrackType) && "0".equals(newTrackType)) {
            new CtpAffair();
            affair = this.affairManager.get(Long.parseLong(affairId));
            affair.setTrack(Integer.parseInt(newTrackType));
            this.affairManager.updateAffair(affair);
        }

        if ("2".equals(oldTrackType) && "1".equals(newTrackType)) {
            this.trackManager.deleteTrackMembers(Long.parseLong(objectId), Long.parseLong(affairId));
            new CtpAffair();
            affair = this.affairManager.get(Long.parseLong(affairId));
            affair.setTrack(Integer.parseInt(newTrackType));
            this.affairManager.updateAffair(affair);
        }

        if ("2".equals(oldTrackType) && "2".equals(newTrackType)) {
            this.trackManager.deleteTrackMembers(Long.parseLong(objectId), Long.parseLong(affairId));
            list = new ArrayList();
            if (null != ids) {
                member = null;

                for(i = 0; i < ids.length; ++i) {
                    member = new CtpTrackMember();
                    member.setIdIfNew();
                    member.setAffairId(Long.parseLong(affairId));
                    member.setObjectId(Long.parseLong(objectId));
                    member.setMemberId(Long.parseLong(senderId));
                    member.setTrackMemberId(Long.parseLong(ids[i]));
                    list.add(member);
                }

                this.trackManager.save(list);
            }
        }

    }

    public void saveColSupervise4NewColl(ColSummary colSummary, boolean sendMessage) throws BusinessException {
        try {
            Map superviseMap = ParamUtil.getJsonDomain("colMainData");
            SuperviseSetVO ssvo = (SuperviseSetVO)ParamUtil.mapToBean(superviseMap, new SuperviseSetVO(), false);
            SuperviseMessageParam smp = new SuperviseMessageParam();
            if (sendMessage) {
                smp.setSendMessage(true);
                smp.setMemberId(colSummary.getStartMemberId());
                smp.setImportantLevel(colSummary.getImportantLevel());
                smp.setSubject(colSummary.getSubject());
                smp.setForwardMember(colSummary.getForwardMember());
            }

            DateSharedWithWorkflowEngineThreadLocal.setColSummary(colSummary);
            smp.setSaveDraft(true);
            this.superviseManager.saveOrUpdateSupervise4Process(ssvo, smp, colSummary.getId(), EntityType.summary);
        } catch (Exception var6) {
            LOG.error("", var6);
        }

    }

    public ColSummary getSummaryById(Long summaryId) throws BusinessException {
        ColSummary s = this.colDao.getColSummaryById(summaryId);
        if (s == null) {
            ColDao colDaoFK = null;
            if (AppContext.hasPlugin("fk")) {
                colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
            }

            if (colDaoFK != null) {
                s = colDaoFK.getColSummaryByIdHis(summaryId);
            }
        }

        return s;
    }

    public String checkCanDelete(DeleteAjaxTranObj obj) throws BusinessException {
        String affairIds = obj.getAffairIds();
        String result = "";
        String from = obj.getFromMethod();
        List<CtpAffair> affairList = null;
        if (Strings.isNotBlank(affairIds)) {
            affairList = new ArrayList();
            String[] affairs = affairIds.split("[,]");
            String[] var7 = affairs;
            int var8 = affairs.length;

            for(int var9 = 0; var9 < var8; ++var9) {
                String affairId = var7[var9];
                Long _affairId = Long.valueOf(affairId);
                CtpAffair affair = this.affairManager.get(_affairId);
                affairList.add(affair);
                int state = affair.getState();
                if (state != StateEnum.col_pending.getKey() && state != StateEnum.col_done.getKey() && state != StateEnum.col_sent.getKey() && (state != StateEnum.col_waitSend.getKey() || "listSent".equals(from))) {
                    result = ColUtil.getErrorMsgByAffair(affair);
                }
            }
        }

        return !"".equals(result) ? result : "success";
    }

    public void deleteAffair(String pageType, long affairId) throws BusinessException {
        User user = AppContext.getCurrentUser();
        CtpAffair affair = this.affairManager.get(affairId);
        if (affair != null) {
            ColSummary summary = this.getColSummaryById(affair.getObjectId());
            if (ColListType.draft.name().equals(pageType)) {
                long summaryId = affair.getObjectId();
                List affairs = this.affairManager.getAffairs(ApplicationCategoryEnum.collaboration, summaryId);

                try {
                    this.deleteAttachments(summary);
                } catch (BusinessException var13) {
                    LOG.error("删除归档文档异常", var13);
                    throw new BusinessException(var13);
                }

                this.deleteColSummaryUseHqlById(summaryId);
                this.affairManager.deletePhysicalByObjectId(summaryId);
                List<Long> ids = new ArrayList();
                Iterator var11 = affairs.iterator();

                while(var11.hasNext()) {
                    CtpAffair a = (CtpAffair)var11.next();
                    ids.add(a.getId());
                }

                Boolean hasDoc = AppContext.hasPlugin("doc");
                if (hasDoc && this.docApi != null) {
                    this.docApi.deleteDocResources(user.getId(), ids);
                }

                try {
                    if (String.valueOf(MainbodyType.FORM.getKey()).equals(affair.getBodyType())) {
                        LOG.info("待发删除表单数据：summayId:" + summaryId);
                        MainbodyService.getInstance().deleteContentAllByModuleId(ModuleType.collaboration, summaryId, true);
                    }
                } catch (Throwable var14) {
                    LOG.error("删除表单数据异常", var14);
                    throw new BusinessException(var14);
                }

                if (Strings.isNotBlank(summary.getProcessId())) {
                    this.processLogManager.deleteLog(Long.parseLong(summary.getProcessId()));
                }
            } else {
                if (ColListType.pending.name().equals(pageType)) {
                    Comment comment = new Comment();
                    comment.setId(UUIDLong.longUUID());
                    comment.setAffairId(affairId);
                    comment.setModuleId(affair.getObjectId());
                    comment.setClevel(1);
                    comment.setCtype(0);
                    comment.setHidden(false);
                    comment.setContent("");
                    comment.setModuleType(ApplicationCategoryEnum.collaboration.getKey());
                    comment.setPath("001");
                    comment.setPid(0L);
                    comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
                    comment.setCreateId(user.getId());
                    comment.setPushMessage(false);
                    DateSharedWithWorkflowEngineThreadLocal.setIsNeedAutoSkip(false);
                    Map<String, Object> param = new HashMap();
                    param.put("subState", String.valueOf(SubStateEnum.col_done_delete.getKey()));
                    this.transFinishWorkItemPublic(affair.getId(), comment, param);
                }

                this.affairManager.deleteAffair(affair.getId());
            }

            this.appLogManager.insertLog(user, AppLogAction.Coll_Delete, new String[]{user.getName(), affair.getSubject()});
            if (AppContext.hasPlugin("index")) {
                if (String.valueOf(MainbodyType.FORM.getKey()).equals(affair.getBodyType())) {
                    this.indexManager.update(affair.getObjectId(), ApplicationCategoryEnum.form.getKey());
                } else {
                    this.indexManager.update(affair.getObjectId(), ApplicationCategoryEnum.collaboration.getKey());
                }
            }

            CollaborationDelEvent takedel = new CollaborationDelEvent(this);
            takedel.setSummaryId(summary.getId());
            takedel.setAffair(affair);
            EventDispatcher.fireEvent(takedel);
        }
    }

    private void deleteAttachments(ColSummary summary) throws BusinessException {
        Long summaryId = summary.getId();
        boolean isOnlyDeleteAtt = Strings.isNotBlank(summary.getForwardMember());
        if (!isOnlyDeleteAtt) {
            List<ColSummary> summarys = this.colDao.findColSummarysByParentId(summaryId);
            if (Strings.isNotEmpty(summarys)) {
                isOnlyDeleteAtt = true;
            }
        }

        if (isOnlyDeleteAtt) {
            this.attachmentManager.deleteOnlyAttByReference(summaryId);
        } else {
            this.attachmentManager.removeByReference(summaryId);
        }
    }

    public void deleteColSummaryUseHqlById(Long id) throws BusinessException {
        this.colDao.deleteColSummaryById(id);
    }

    public void transUpdateCurrentInfo(Map<String, Object> ma) throws BusinessException {
        CtpAffair affair = this.affairManager.get(Long.valueOf((String)ma.get("affairId")));
        ColSummary summary = this.getSummaryById(affair.getObjectId());
        ColUtil.updateCurrentNodesInfo(summary);
        this.updateColSummary(summary);
    }

    public String transTakeBack(Map<String, Object> ma) throws BusinessException {
        String msg = null;
        String processId = null;

        try {
            CtpAffair affair = this.affairManager.get(Long.valueOf(String.valueOf(ma.get("affairId"))));
            ColSummary summary = this.getSummaryById(affair.getObjectId());
            processId = summary.getProcessId();
            int result = ContentUtil.colTakeBack(affair);
            if (result == 0) {
                if (!(Boolean)ma.get("isSaveOpinion")) {
                    this.updateOpinion2Draft(affair.getId(), summary);
                }

                affair.setState(StateEnum.col_pending.key());
                affair.setSubState(SubStateEnum.col_pending_unRead.key());
                affair.setCompleteTime((Date)null);
                affair.setOverTime((Long)null);
                affair.setOverWorktime((Long)null);
                affair.setRunTime((Long)null);
                affair.setRunWorktime((Long)null);
                affair.setUpdateDate(new Timestamp(System.currentTimeMillis()));
                affair.setTransactorId((Long)null);
                this.affairManager.updateAffair(affair);
                ColUtil.updateCurrentNodesInfo(summary);
                this.updateColSummary(summary);
                this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.takeBack, new String[0]);
                if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                    try {
                        List<Comment> commentList = this.commentManager.getCommentAllByModuleId(ModuleType.collaboration, summary.getId());
                        this.formManager.updateDataState(summary, affair, ColHandleType.takeBack, commentList);
                    } catch (Exception var12) {
                        LOG.error("更新表单相关信息异常", var12);
                        throw new BusinessException("更新表单相关信息异常", var12);
                    }
                }

                this.colMessageManager.transTakeBackMessage((List)null, affair, summary.getId());
                if (AppContext.hasPlugin("index")) {
                    if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                        this.indexManager.update(summary.getId(), ApplicationCategoryEnum.form.getKey());
                    } else {
                        this.indexManager.update(summary.getId(), ApplicationCategoryEnum.collaboration.getKey());
                    }
                }
            } else if (result == 1) {
                msg = "流程已结束，不能取回；";
            } else if (result == 2) {
                msg = "当前及后面节点有子流程已结束，不能取回";
            } else if (result == -1) {
                msg = "后面节点任务事项已处理完成，不能取回";
            } else if (result == -2) {
                msg = "当前任务事项所在节点为知会节点，不能取回";
            }

            boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(affair.getBodyType());
            Long formAppId = affair.getFormAppId();
            if (isForm && formAppId != null) {
                ;
            }
        } finally {
            this.wapi.releaseWorkFlowProcessLock(processId, String.valueOf(AppContext.currentUserId()));
        }

        return msg;
    }

    private Long updateOpinion2Draft(Long id, ColSummary summary) throws BusinessException {
        List<CtpCommentAll> allDelOpin = this.getDealOpinion(id);
        Long commentId = 0L;
        if (!allDelOpin.isEmpty()) {
            CtpCommentAll all = (CtpCommentAll)allDelOpin.get(0);
            all.setCtype(CommentType.draft.getKey());
            Comment comment = new Comment(all);
            this.commentManager.updateCommentCtype(comment.getId(), CommentType.draft);
            ColUtil.removeOneReplyCounts(summary);
            List<Comment> list = this.commentManager.getCommentList(ModuleType.collaboration, summary.getId(), all.getId());
            this.commentManager.deleteCommentAllByModuleIdAndParentId(ModuleType.collaboration, summary.getId(), all.getId());
            if (Strings.isNotEmpty(list)) {
                Iterator var8 = list.iterator();

                while(var8.hasNext()) {
                    Comment c = (Comment)var8.next();
                    this.attachmentManager.deleteByReference(summary.getId(), c.getId());
                }
            }
        }

        return commentId;
    }

    private List<CtpCommentAll> getDealOpinion(Long affairId) {
        StringBuffer hql = new StringBuffer();
        hql.append("from CtpCommentAll where affairId=:affairId and ctype=:ctype order by createDate desc");
        Map<String, Object> params = new HashMap();
        params.put("affairId", affairId);
        params.put("ctype", CommentType.comment.getKey());
        return DBAgent.find(hql.toString(), params);
    }

    public Comment getDraftOpinion(Long affairId) {
        StringBuffer hql = new StringBuffer();
        Map<String, Object> params = new HashMap();
        hql.append(" from CtpCommentAll where affairId=:affairId and ctype=:ctype ");
        params.put("affairId", affairId);
        params.put("ctype", CommentType.draft.getKey());
        List<CtpCommentAll> list = DBAgent.find(hql.toString(), params);
        Comment comment = null;
        if (Strings.isNotEmpty(list)) {
            comment = new Comment((CtpCommentAll)list.get(0));
        }

        return comment;
    }

    public NewCollTranVO transComeFromWaitSend(NewCollTranVO vobj) throws BusinessException {
        long summaryId = Long.valueOf(vobj.getSummaryId());
        ColSummary summary = this.getSummaryById(summaryId);
        if (null != summary && null != summary.getResentTime() && summary.getResentTime() != 0) {
            vobj.setReadOnly(Boolean.TRUE);
        }

        CtpAffair affair = this.affairManager.get(Long.valueOf(vobj.getAffairId()));
        if (affair == null) {
            affair = (CtpAffair)this.affairManager.getAffairs(summaryId, StateEnum.col_waitSend).get(0);
        }

        boolean isSpecailBackSubmitTo = Integer.valueOf(SubStateEnum.col_pending_specialBacked.getKey()).equals(affair.getSubState());
        ColSummary summaryCloneColSummary = null;

        try {
            summaryCloneColSummary = (ColSummary)summary.clone();
            summaryCloneColSummary.setId(summary.getId());
            summary = summaryCloneColSummary;
            if (null != summaryCloneColSummary.getParentformSummaryid() && !summaryCloneColSummary.getCanEdit()) {
                AppContext.putRequestContext("parentSummaryId", summaryCloneColSummary.getParentformSummaryid());
                AppContext.putRequestContext("_hideContentType", "1");
            }
        } catch (CloneNotSupportedException var22) {
            LOG.error("", var22);
        }

        vobj.setSummary(summary);
        String attListJSON = this.getSummaryAttachmentJsonsIncludeSender(summaryId);
        vobj.setAttListJSON(attListJSON);
        Long templateId = summary.getTempleteId();
        CtpTemplate template = null;
        if (templateId != null) {
            vobj.setTempleteId(String.valueOf(templateId));
            template = this.templateManager.getCtpTemplate(templateId);
            if (template == null) {
                return null;
            }

            AppContext.putRequestContext("curTemplateID", template.getId());
            if (null != template.getFormParentid()) {
                vobj.setParentWrokFlowTemplete(this.isParentWrokFlowTemplete(template.getFormParentid()));
                vobj.setParentTextTemplete(this.isParentTextTemplete(template.getFormParentid()));
                vobj.setParentColTemplete(this.isParentColTemplete(template.getFormParentid()));
            } else {
                vobj.setParentWrokFlowTemplete(template.isSystem() && "workflow".equals(template.getType()));
                vobj.setParentTextTemplete(template.isSystem() && "text".equals(template.getType()));
                vobj.setParentColTemplete(template.isSystem() && "template".equals(template.getType()));
            }

            CtpTemplate pTemplate = this.getParentSystemTemplete(template.getId());
            Boolean isFromSystem = template.isSystem();
            if (isFromSystem != null && !isFromSystem) {
                isFromSystem = pTemplate != null && pTemplate.isSystem() != null ? pTemplate.isSystem() : false;
            } else {
                isFromSystem = true;
            }

            vobj.setFromSystemTemplete(isFromSystem);
            vobj.setTemplate(template);
            vobj.setFromTemplate(template.isSystem());
            if (template.isSystem()) {
                vobj.setSystemTemplate(true);
            } else {
                vobj.setSystemTemplate(false);
            }

            ColSummary tSummary = summary;
            if (pTemplate != null) {
                tSummary = (ColSummary)XMLCoder.decoder(pTemplate.getSummary());
            }

            vobj.setTempleteHasDeadline(tSummary.getDeadline() != null && tSummary.getDeadline() != 0L);
            vobj.setTempleteHasRemind(tSummary.getAdvanceRemind() != null && tSummary.getAdvanceRemind() != 0L && tSummary.getAdvanceRemind() != -1L);
            vobj.setCanEditColPigeonhole(tSummary.getArchiveId() != null);
            summary.setCanMergeDeal(tSummary.getCanMergeDeal());
            summary.setCanAnyMerge(tSummary.getCanAnyMerge());
            String scanCodeInput = "0";
            if (template != null && null != template.getScanCodeInput() && template.getScanCodeInput()) {
                scanCodeInput = "1";
            }

            AppContext.putRequestContext("scanCodeInput", scanCodeInput);
            String formtitle = template.getSubject();
            Long templeteFormparnetId = template.getFormParentid();
            if (null != templeteFormparnetId) {
                vobj.setTemformParentId(String.valueOf(templeteFormparnetId));
            }

            if (Strings.isNotBlank(template.getColSubject())) {
                vobj.setCollSubjectNotEdit(true);
                vobj.setCollSubject(template.getColSubject());
            }

            vobj.setFormtitle(formtitle);
            String mSubject = this.getTemplateSubject(formtitle, summary.getCreateDate(), false);
            if (summary.getSubject().equals(mSubject)) {
                summary.setSubject(formtitle);
                String fsubject = this.getTemplateSubject(formtitle, new Date(), false);
                summary.setSubject(fsubject);
            }

            Long standardDuration = template.getStandardDuration();
            if (null != standardDuration) {
                vobj.setStandardDuration(template.getStandardDuration().toString());
            }

            if (!"text".equals(template.getType())) {
                String formOperationId = "";

                try {
                    Long rightTemplateId = templeteFormparnetId != null ? templeteFormparnetId : template.getId();
                    formOperationId = ContentUtil.findRightIdbyAffairIdOrTemplateId((CtpAffair)null, rightTemplateId);
                } catch (BusinessException var21) {
                    LOG.error("", var21);
                    throw new BusinessException(var21);
                }

                vobj.setFormOperationId(formOperationId);
            }

            if (isFromSystem && !isSpecailBackSubmitTo) {
                if ("template".equals(template.getType())) {
                    summary.setCanArchive(tSummary.getCanArchive());
                    summary.setCanEdit(tSummary.getCanEdit());
                    summary.setCanEditAttachment(tSummary.getCanEditAttachment());
                    summary.setCanModify(tSummary.getCanModify());
                    summary.setCanForward(tSummary.getCanForward());
                }

                if ("workflow".equals(template.getType())) {
                    summary.setCanEditAttachment(tSummary.getCanEditAttachment());
                }

                Long projectId = pTemplate.getProjectId();
                if (null != projectId && null != this.projectApi) {
                    ProjectBO ps = this.projectApi.getProject(projectId);
                    if (null != ps && ProjectBO.STATE_DELETE.intValue() != ps.getProjectState()) {
                        summary.setProjectId(projectId);
                    }
                }

                if (null != tSummary.getArchiveId()) {
                    summary.setArchiveId(tSummary.getArchiveId());
                }

                if (Strings.isNotBlank(tSummary.getAdvancePigeonhole())) {
                    summary.setAdvancePigeonhole(tSummary.getAdvancePigeonhole());
                }

                if (tSummary.getDeadline() != null && tSummary.getDeadline() != 0L) {
                    summary.setDeadline(tSummary.getDeadline());
                }

                if (tSummary.getAdvanceRemind() != null && tSummary.getAdvanceRemind() != 0L) {
                    summary.setAdvanceRemind(tSummary.getAdvanceRemind());
                }

                if (tSummary.getSupervisors() != null) {
                    summary.setSupervisors(tSummary.getSupervisors());
                }
            }
        }

        if (AppContext.hasPlugin("doc")) {
            if (Strings.isNotBlank(summary.getAdvancePigeonhole())) {
                if (Strings.isBlank(String.valueOf(summary.getArchiveId()))) {
                    LOG.warn("预归档时，ArchiveId为空，AdvancePigeonhole值为：" + summary.getId());
                    vobj.setAdvancePigeonhole("");
                    vobj.setArchiveName("");
                    AppContext.putRequestContext("setDisabled", true);
                } else {
                    String archiveName = ColUtil.getAdvancePigeonholeName(summary.getArchiveId(), summary.getAdvancePigeonhole(), "template");
                    if ("wendangisdeleted".equals(archiveName)) {
                        vobj.setAdvancePigeonhole("");
                        vobj.setArchiveName("");
                        AppContext.putRequestContext("setDisabled", true);
                    } else {
                        vobj.setAdvancePigeonhole(summary.getAdvancePigeonhole());
                        vobj.setArchiveName(archiveName);
                    }
                }
            } else if (summary.getArchiveId() != null) {
                vobj.setArchiveId(summary.getArchiveId());
                vobj.setArchiveName(this.docApi.getDocResourceName(summary.getArchiveId()));
            }
        }

        LOG.info("summary.getProcessId()=" + summary.getProcessId() + ",summary.getSubject()=" + summary.getSubject());
        if (summary.getProcessId() != null) {
            vobj.setProcessId(summary.getProcessId());
            vobj.setCaseId(summary.getCaseId());
        }

        Long projectId = summary.getProjectId();
        vobj.setProjectId(projectId);
        if (template != null && Strings.isNotBlank(template.getColSubject())) {
            vobj.setCollSubjectNotEdit(true);
            if (String.valueOf(SubStateEnum.col_pending_specialBacked.key()).equals(affair.getSubState().toString())) {
                vobj.setCollSubject(affair.getSubject());
            } else {
                vobj.setCollSubject(template.getColSubject());
            }
        }

        vobj.setAffair(affair);
        vobj.setAffairId(String.valueOf(affair.getId()));
        this.superviseManager.parseProcessSupervise(summary.getId(), templateId, summary.getStartMemberId(), EntityType.summary);
        return vobj;
    }

    public void updateAffairStateWhenClick(CtpAffair affair) throws BusinessException {
        Integer sub_state = affair.getSubState();
        if (sub_state == null || sub_state == SubStateEnum.col_pending_unRead.key()) {
            affair.setSubState(SubStateEnum.col_pending_read.key());
            Date nowTime = new Date();
            long firstViewTime = this.workTimeManager.getDealWithTimeValue(affair.getReceiveTime(), nowTime, affair.getOrgAccountId());
            affair.setFirstViewPeriod(firstViewTime);
            affair.setFirstViewDate(nowTime);
            this.affairManager.updateAffair(affair);
            if (affair.getSubObjectId() != null) {
                try {
                    this.wapi.readWorkItem(affair.getSubObjectId());
                } catch (BPMException var7) {
                    LOG.error("", var7);
                    throw new BusinessException(var7);
                }
            }
        }

    }

    public void transSendImmediate(String _summaryIds, String _affairIds, boolean sentFlag) throws BusinessException {
        this.transSendImmediate(_summaryIds, (String)_affairIds, sentFlag, (String)null, (String)null, (String)null, "");
    }

    public NewCollTranVO transResend(NewCollTranVO vobj) throws BusinessException {
        long summaryId = Long.parseLong(vobj.getSummaryId());
        ColSummary summary = this.getColSummaryById(summaryId);
        vobj.setSummary(summary);
        String attListJSON = this.getSummaryAttachmentJsonsIncludeSender(summaryId);
        vobj.setAttListJSON(attListJSON);
        if (summary.getProcessId() != null) {
            vobj.setProcessId(summary.getProcessId());
        }

        if (Strings.isNotBlank(summary.getAdvancePigeonhole())) {
            String archiveName = ColUtil.getAdvancePigeonholeName(summary.getArchiveId(), summary.getAdvancePigeonhole(), "col");
            vobj.setArchiveName(archiveName);
        } else if (null != summary.getArchiveId() && Strings.isNotBlank(String.valueOf(summary.getArchiveId()))) {
            vobj.setArchiveId(summary.getArchiveId());
            vobj.setArchiveName(ColUtil.getArchiveNameById(summary.getArchiveId()));
            vobj.setArchiveAllName(ColUtil.getArchiveAllNameById(summary.getArchiveId()));
        }

        vobj.setReadOnly(Boolean.TRUE);
        boolean cloneOriginalAtts = true;
        vobj.setCloneOriginalAtts(cloneOriginalAtts);
        if (summary.getTempleteId() != null) {
            CtpTemplate ctpTemplate = this.templateManager.getCtpTemplate(summary.getTempleteId());
            vobj.setTemplate(ctpTemplate);
            vobj.setSystemTemplate(ctpTemplate.isSystem());
            ColSummary colSummary = (ColSummary)XMLCoder.decoder(ctpTemplate.getSummary());
            vobj.setTempleteHasRemind(colSummary.getAdvanceRemind() != null && colSummary.getAdvanceRemind() != 0L && colSummary.getAdvanceRemind() != -1L);
            vobj.setTempleteHasDeadline(colSummary.getDeadlineDatetime() != null);
            vobj.setTempleteId(summary.getTempleteId().toString());
            vobj.setTemplate(this.templateManager.getCtpTemplate(summary.getTempleteId()));
            vobj.setFromTemplate(summary.getTempleteId() != null);
            vobj.setParentWrokFlowTemplete(this.isParentWrokFlowTemplete(summary.getTempleteId()));
            vobj.setParentTextTemplete(this.isParentTextTemplete(summary.getTempleteId()));
            vobj.setParentColTemplete(this.isParentColTemplete(summary.getTempleteId()));
            vobj.setFromSystemTemplete(this.isParentSystemTemplete(summary.getTempleteId()));
        }

        vobj.setProjectId(summary.getProjectId());
        vobj.setResendFlag(true);
        this.CopySuperviseFromSummary(vobj, summary.getId());
        return vobj;
    }

    private String getSummaryAttachmentJsonsIncludeSender(long summaryId) throws BusinessException {
        List<Attachment> showAtts = new ArrayList();
        List<Attachment> list = this.attachmentManager.getByReference(summaryId);
        List<Comment> comments = this.commentManager.getCommentList(ModuleType.collaboration, summaryId);
        List<Long> showlds = new ArrayList();
        showlds.add(summaryId);
        Iterator var7;
        if (Strings.isNotEmpty(comments)) {
            var7 = comments.iterator();

            while(var7.hasNext()) {
                Comment c = (Comment)var7.next();
                if (Integer.valueOf(CommentType.sender.getKey()).equals(c.getCtype())) {
                    showlds.add(c.getId());
                }
            }
        }

        if (Strings.isNotEmpty(list)) {
            var7 = list.iterator();

            while(var7.hasNext()) {
                Attachment a = (Attachment)var7.next();
                if (showlds.contains(a.getSubReference())) {
                    Attachment aclone = null;

                    try {
                        aclone = (Attachment)a.clone();
                        aclone.setSubReference(a.getReference());
                    } catch (CloneNotSupportedException var11) {
                        LOG.error("", var11);
                    }

                    if (aclone != null) {
                        showAtts.add(aclone);
                    }
                }
            }
        }

        String attListJSON = this.attachmentManager.getAttListJSON(showAtts);
        return attListJSON;
    }

    public String transRepalFront(String summaryId, String repealComment, String affairId, String isWFTrace) throws BusinessException {
        String processId = null;
        Long recordId = null;

        String var19;
        try {
            int result = 0;
            Long _summaryId = Long.parseLong(summaryId);
            Long _affairId = Long.parseLong(affairId);
            ColSummary summary = this.getColSummaryById(_summaryId);
            Long caseId = summary.getCaseId();
            processId = summary.getProcessId();
            recordId = summary.getFormRecordid();
            if (Strings.isNotBlank(repealComment)) {
                repealComment = repealComment.replaceAll(new String(new char[]{' '}), " ");
            }

            String info = "";
            AffairData affairData = new AffairData();
            Map<String, Object> businessData = new HashMap();
            businessData.put("operationType", WorkFlowEventListener.CANCEL);
            businessData.put("CURRENT_OPERATE_AFFAIR_ID", _affairId);
            businessData.put("CURRENT_OPERATE_SUMMARY_ID", _summaryId);
            businessData.put("CURRENT_OPERATE_COMMENT_CONTENT", repealComment);
            businessData.put("CURRENT_OPERATE_TRACK_FLOW", isWFTrace);
            affairData.setBusinessData(businessData);
            if (caseId != null) {
                result = ContentUtil.cancelCase(affairData, caseId);
            } else {
                this.repairData(_summaryId);
            }

            String colSubject = summary.getSubject();
            if (result == -1) {
                info = "协同《" + colSubject + "》未生成完毕，请稍后进行撤销操作";
            } else if (result == -2) {
                info = "该协同触发的子流程《" + colSubject + "》已结束，不允许撤销！";
            } else if (result == 1) {
                info = "协同《" + colSubject + "》已经结束,不允许撤销";
            }

            CtpAffair currentAffair = this.affairManager.get(_affairId);
            boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType());
            Long formAppId = currentAffair.getFormAppId();
            if (isForm && formAppId != null) {
                this.formManager.unlockFormData(summary.getFormRecordid());
            }

            this.affairManager.updateSignleViewTime(currentAffair);
            var19 = info;
        } catch (Exception var23) {
            LOG.error("", var23);
            throw new BusinessException("", var23);
        } finally {
            this.officeLockManager.unlockAll(recordId);
            this.colDelLock(Long.valueOf(affairId), true);
        }

        return var19;
    }

    private void repairData(Long _summaryId) throws BusinessException {
        CtpAffair senderAffair = this.affairManager.getSenderAffair(_summaryId);
        if (null != senderAffair && senderAffair.getState() == StateEnum.col_sent.key()) {
            senderAffair.setState(StateEnum.col_waitSend.key());
            this.affairManager.updateAffair(senderAffair);
            Timestamp now = new Timestamp(System.currentTimeMillis());
            StringBuilder hql = new StringBuilder();
            hql.append("update CtpAffair set state=:state,subState=:subState,updateDate=:updateDate where id!=:id and objectId=:objectId ");
            Map<String, Object> params = new HashMap();
            params.put("state", StateEnum.col_stepBack.key());
            params.put("subState", SubStateEnum.col_normal.key());
            params.put("objectId", senderAffair.getObjectId());
            params.put("updateDate", now);
            params.put("id", senderAffair.getId());
            DBAgent.bulkUpdate(hql.toString(), params);
        }

    }

    public void transRepalBackground(Long _summaryId, Long _affairId, String repealComment, String trackWorkflowType, Integer _ioperationType) throws BusinessException {
        boolean isBackOperation = WorkFlowEventListener.WITHDRAW.equals(_ioperationType) || WorkFlowEventListener.SPECIAL_BACK_RERUN.equals(_ioperationType);
        if (Strings.isNotBlank(repealComment)) {
            repealComment = repealComment.replaceAll(new String(new char[]{' '}), " ");
        }

        String colSubject = "";
        Comment comment = new Comment();
        comment.setAffairId(_affairId);
        comment.setCtype(CommentType.comment.getKey());
        String repealCommentTOHTML = repealComment;
        Long affairForAuthUpdateAffair = null;

        try {
            User user = AppContext.getCurrentUser();
            ColSummary summary = this.getColSummaryById(_summaryId);
            colSubject = summary.getSubject();
            List<StateEnum> states = new ArrayList();
            states.add(StateEnum.col_sent);
            states.add(StateEnum.col_pending);
            states.add(StateEnum.col_done);
            states.add(StateEnum.col_waitSend);
            List<CtpAffair> affairs = this.affairManager.getAffairs(_summaryId, states);
            CtpAffair currentAffair = this.affairManager.get(comment.getAffairId());
            ColUtil.deleteQuartzJob(_summaryId);
            Iterator var16 = affairs.iterator();

            CtpAffair ctpAffair;
            while(var16.hasNext()) {
                ctpAffair = (CtpAffair)var16.next();
                int state = ctpAffair.getState();
                int subState = ctpAffair.getSubState();
                if (state == StateEnum.col_sent.key()) {
                    ctpAffair.setState(StateEnum.col_waitSend.key());
                    ctpAffair.setSubState(SubStateEnum.col_waitSend_cancel.key());
                    ctpAffair.setDelete(false);
                    this.affairManager.updateAffair(ctpAffair);
                    affairForAuthUpdateAffair = ctpAffair.getId();
                } else if (state == StateEnum.col_waitSend.key() && (subState == SubStateEnum.col_pending_specialBacked.key() || subState == SubStateEnum.col_pending_specialBackToSenderCancel.key())) {
                    ctpAffair.setSubState(SubStateEnum.col_waitSend_cancel.key());
                    ctpAffair.setDelete(false);
                    this.affairManager.updateAffair(ctpAffair);
                }

                if (ctpAffair.getDeadlineDate() != null && ctpAffair.getDeadlineDate() != 0L) {
                    ColUtil.deleteQuartzJobForNode(ctpAffair);
                }
            }

            summary.setCaseId((Long)null);
            summary.setCoverTime(Boolean.FALSE);
            summary.setCurrentNodesInfo("");
            ColUtil.addOneReplyCounts(summary);
            summary.setState(flowState.cancel.ordinal());
            this.updateColSummary(summary);
            if (!isBackOperation) {
                comment = this.saveComment4Repeal(comment, repealCommentTOHTML, user, summary, currentAffair);
                this.saveAttDatas(user, summary, currentAffair, comment.getId());
            }

            if (!isBackOperation) {
                this.createRepealTraceWfData(summary, affairs, currentAffair, trackWorkflowType);
            }

            if (!isBackOperation) {
                this.colMessageManager.sendMessage4Repeal(affairs, currentAffair, Strings.toText(comment.getContent()), "1".equals(trackWorkflowType), comment);
            }

            String messageLink = "collaboration.summary.cancel";
            if (currentAffair != null && currentAffair.getState() == StateEnum.col_pending.getKey()) {
                messageLink = "collaboration.summary.cancelPending";
            }

            this.colMessageManager.sendMessage2Supervisor(summary.getId(), ApplicationCategoryEnum.collaboration, summary.getSubject(), messageLink, user.getId(), user.getName(), Strings.toText(comment.getContent()), summary.getForwardMember());
            this.do4Repeal(user.getId(), comment.getContent(), summary.getId(), affairs, true);
            this.affairManager.updateAffairsState2Cancel(_summaryId);
            if (!isBackOperation) {
                this.iSignatureHtmlManager.deleteAllByDocumentId(summary.getId());
                this.appLogManager.insertLog(user, AppLogAction.Coll_Repeal, new String[]{user.getName(), colSubject});
                this.processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), -1L, ProcessLogAction.cancelColl, comment.getId(), new String[0]);
                if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                    try {
                        this.formRelationManager.RelationAuthorityBySummaryId(_summaryId, ModuleType.collaboration.getKey());
                        if (null != affairForAuthUpdateAffair) {
                            ctpAffair = this.getAffairById(affairForAuthUpdateAffair);
                            AffairUtil.setIsRelationAuthority(ctpAffair, false);
                            DBAgent.update(ctpAffair);
                        }

                        this.formManager.updateDataState(summary, currentAffair, ColHandleType.repeal, (List)null);
                    } catch (Exception var20) {
                        LOG.error("更新表单相关信息异常", var20);
                    }
                }
            }

            if (AppContext.hasPlugin("index")) {
                if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                    this.indexManager.delete(_summaryId, ApplicationCategoryEnum.form.getKey());
                } else {
                    this.indexManager.delete(_summaryId, ApplicationCategoryEnum.collaboration.getKey());
                }
            }

        } catch (Exception var21) {
            LOG.error("", var21);
            throw new BusinessException("", var21);
        }
    }

    public String transRepal(Map<String, Object> tempMap) throws BusinessException {
        String repealComment = (String)tempMap.get("repealComment");
        if (Strings.isNotBlank(repealComment)) {
            repealComment = repealComment.replaceAll(new String(new char[]{' '}), " ");
        }

        String affairId = (String)tempMap.get("affairId");
        String summaryId = (String)tempMap.get("summaryId");
        String isWFTrace = (String)tempMap.get("isWFTrace");
        boolean isLock = false;
        Long laffairId = Long.valueOf(affairId);

        String var8;
        try {
            isLock = this.colLockManager.canGetLock(laffairId);
            if (!isLock) {
                LOG.error(AppContext.currentAccountName() + "不能获取到map缓存锁，不能执行操作repeal,affairId:" + laffairId);
                var8 = null;
                return var8;
            }

            var8 = this.transRepalFront(summaryId, repealComment, affairId, isWFTrace);
        } finally {
            if (isLock) {
                this.colLockManager.unlock(laffairId);
            }

        }

        return var8;
    }

    private void createRepealTraceWfData(ColSummary summary, List<CtpAffair> affairs, CtpAffair currentAffair, String trackWorkflowType) throws BusinessException {
        CtpTemplate t = null;
        if (summary.getTempleteId() != null) {
            t = this.templateManager.getCtpTemplate(summary.getTempleteId());
        }

        List<CtpAffair> traceAffairs = new ArrayList();
        Iterator var7 = affairs.iterator();

        while(true) {
            CtpAffair aff;
            do {
                if (!var7.hasNext()) {
                    this.colTraceWorkflowManager.createRepealTraceData(summary, currentAffair, traceAffairs, t, trackWorkflowType);
                    return;
                }

                aff = (CtpAffair)var7.next();
            } while(!Integer.valueOf(StateEnum.col_done.key()).equals(aff.getState()) && (!Integer.valueOf(StateEnum.col_pending.key()).equals(aff.getState()) || !Integer.valueOf(SubStateEnum.col_pending_ZCDB.key()).equals(aff.getSubState())) && !aff.getId().equals(currentAffair.getId()) && !Integer.valueOf(StateEnum.col_sent.key()).equals(aff.getState()) && !Integer.valueOf(StateEnum.col_waitSend.key()).equals(aff.getState()));

            traceAffairs.add(aff);
        }
    }

    private Comment saveComment4Repeal(Comment comment, String repealCommentTOHTML, User user, ColSummary summary, CtpAffair currentAffair) throws BusinessException {
        ParamUtil.getJsonDomainToBean("comment_deal", comment);
        comment.setCtype(CommentType.comment.getKey());
        comment.setAffairId(currentAffair.getId());
        if (user != null && user.getId() != null) {
            Long userId = user.getId();
            comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
            comment.setModuleId(summary.getId());
            comment.setExtAtt3("collaboration.dealAttitude.cancelProcess");
            Long curAgentIDLong = MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.collaboration.ordinal(), currentAffair.getMemberId());
            if (!userId.equals(currentAffair.getMemberId()) && user.isAdmin()) {
                comment.setCreateId(userId);
            } else {
                comment.setCreateId(currentAffair.getMemberId());
            }

            if (userId.equals(curAgentIDLong) && currentAffair.getMemberId() != userId) {
                comment.setExtAtt2(user.getName());
            }

            if (Strings.isBlank(comment.getContent())) {
                comment.setContent(repealCommentTOHTML);
            }

            comment.setModuleType(ModuleType.collaboration.getKey());
            comment.setPid(0L);
            comment = this.saveOrUpdateComment(comment);
            return comment;
        } else {
            return comment;
        }
    }

    public Boolean getIsVouchByProcessId(Long processId) throws BusinessException {
        return false;
    }

    public String checkAffairValid(String affairId) throws NumberFormatException, BusinessException {
        return this.checkAffairValid(affairId, true);
    }

    public String checkAffairValid(String affairId, boolean isTraceValid) throws NumberFormatException, BusinessException {
        CtpAffair affair = this.getSimpleAffair4Check(affairId);
        return this.checkAffairValid(affair, isTraceValid);
    }

    private CtpAffair getSimpleAffair4Check(String affairId) {
        CtpAffair affair = null;
        if (Strings.isNotBlank(affairId)) {
            try {
                affair = this.affairManager.getSimpleAffair(Long.valueOf(affairId));
                if (affair == null) {
                    affair = this.affairManager.getByHis(Long.valueOf(affairId));
                }
            } catch (Exception var4) {
                LOG.error(var4);
            }
        }

        return affair;
    }

    public String checkAffairValid(CtpAffair affair, boolean isTraceValid) {
        String errorMsg = "";
        if (!ColUtil.isAfffairValid(affair)) {
            errorMsg = ColUtil.getErrorMsgByAffair(affair);

            try {
                if (isTraceValid && affair != null && this.traceDao.getTraceWorkflowsByAffairId(affair.getId())) {
                    return "";
                }
            } catch (BusinessException var5) {
                LOG.error("", var5);
            }
        }

        return errorMsg;
    }

    private CtpAffair findMemberAffair(Long summaryId, boolean _isHistoryFlag, Long memberId) throws BusinessException {
        CtpAffair ret = null;
        new ArrayList();
        List affairs;
        if (_isHistoryFlag) {
            affairs = this.affairManager.getAffairsHis(ApplicationCategoryEnum.collaboration, summaryId, memberId);
        } else {
            affairs = this.affairManager.getAffairs(ApplicationCategoryEnum.collaboration, summaryId, memberId);
        }

        if (Strings.isNotEmpty(affairs)) {
            Iterator var6 = affairs.iterator();

            while(var6.hasNext()) {
                CtpAffair aff = (CtpAffair)var6.next();
                if (!aff.isDelete()) {
                    ret = aff;
                    break;
                }
            }
        }

        return ret;
    }

    public boolean getDisplayData2VO(ColSummaryVO summaryVO, ColSummary summary, CtpAffair affair, boolean isHistoryFlag) throws BusinessException {
        boolean _isHistoryFlag = isHistoryFlag;
        if (summaryVO.getAffairId() == null) {
            if (Strings.isNotBlank(summaryVO.getSummaryId())) {
                if (isHistoryFlag) {
                    affair = this.affairManager.getSenderAffairByHis(Long.valueOf(summaryVO.getSummaryId()));
                } else {
                    affair = this.affairManager.getSenderAffair(Long.valueOf(summaryVO.getSummaryId()));
                    if (affair == null) {
                        affair = this.affairManager.getSenderAffairByHis(Long.valueOf(summaryVO.getSummaryId()));
                        if (affair != null) {
                            _isHistoryFlag = true;
                        }
                    }
                }
            } else if (Strings.isNotBlank(summaryVO.getProcessId())) {
                if (summary == null) {
                    _isHistoryFlag = true;
                    summaryVO.setHistoryFlag(true);
                    summary = this.getColSummaryByProcessIdHistory(Long.valueOf(summaryVO.getProcessId()));
                    if (summary == null) {
                        _isHistoryFlag = false;
                        summaryVO.setHistoryFlag(false);
                        summary = this.getColSummaryByProcessId(Long.valueOf(summaryVO.getProcessId()));
                    }
                }

                if (summary != null) {
                    affair = this.affairManager.getSenderAffair(summary.getId());
                    if (_isHistoryFlag) {
                        affair = this.affairManager.getSenderAffairByHis(summary.getId());
                    } else {
                        affair = this.affairManager.getSenderAffair(summary.getId());
                        if (affair == null) {
                            affair = this.affairManager.getSenderAffairByHis(summary.getId());
                            if (affair != null) {
                                _isHistoryFlag = true;
                            }
                        }
                    }
                }
            }

            if (affair != null) {
                summaryVO.setAffairId(affair.getId());
            }
        } else {
            Long aId = summaryVO.getAffairId();
            if (aId != null && aId.intValue() != -1) {
                if (isHistoryFlag) {
                    affair = this.affairManager.getByHis(summaryVO.getAffairId());
                } else {
                    affair = this.affairManager.get(summaryVO.getAffairId());
                    if (affair == null) {
                        affair = this.affairManager.getByHis(summaryVO.getAffairId());
                        if (affair != null) {
                            _isHistoryFlag = true;
                        }
                    }
                }
            }

            if (affair == null) {
                return false;
            }

            if (!ColUtil.isAfffairValid(affair)) {
                CtpAffair aff = this.findMemberAffair(affair.getObjectId(), _isHistoryFlag, affair.getMemberId());
                if (aff != null) {
                    affair = aff;
                    summaryVO.setAffairId(aff.getId());
                }
            }
        }

        summaryVO.setAffair(affair);
        summaryVO.setSummary(summary);
        return _isHistoryFlag;
    }

    public ColSummaryVO transShowSummary(ColSummaryVO summaryVO) throws BusinessException {
        boolean isHistoryFlag = summaryVO.isHistoryFlag();
        User user = AppContext.getCurrentUser();
        CtpAffair affair = null;
        ColSummary summary = null;
        if (ColOpenFrom.formQuery.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.formStatistical.name().equals(summaryVO.getOpenFrom())) {
            summary = this.getMainSummary4FormQueryAndStatic(summaryVO.getOpenFrom(), summaryVO.getSummaryId());
            if (summary != null) {
                summaryVO.setSummaryId(summary.getId().toString());
            }
        }

        isHistoryFlag = this.getDisplayData2VO(summaryVO, summary, affair, isHistoryFlag);
        if (!AppContext.hasPlugin("fk") && isHistoryFlag) {
            summaryVO.setAffair((CtpAffair)null);
        }

        summary = summaryVO.getSummary();
        affair = summaryVO.getAffair();
        AppContext.putRequestContext("isHistoryFlag", isHistoryFlag);
        if (affair == null) {
            summaryVO.setErrorMsg(ColUtil.getErrorMsgByAffair(affair));
            return summaryVO;
        } else {
            if (summary == null) {
                if (isHistoryFlag) {
                    summary = this.getColSummaryByIdHistory(affair.getObjectId());
                } else {
                    summary = this.getColSummaryById(affair.getObjectId());
                }

                if (summary == null) {
                    summaryVO.setErrorMsg(ColUtil.getErrorMsgByAffair(affair));
                    return summaryVO;
                }
            }

            boolean isFormQuery;
            if (ColOpenFrom.supervise.name().equals(summaryVO.getOpenFrom())) {
                isFormQuery = this.superviseManager.isSupervisor(user.getId(), summary.getId());
                if (!isFormQuery) {
                    summaryVO.setErrorMsg(ResourceUtil.getString("collaboration.supercise.cancel.acl"));
                    return summaryVO;
                }

                if (affair.getSubState() == SubStateEnum.col_pending_specialBackToSenderCancel.getKey()) {
                    summaryVO.setErrorMsg(ColUtil.getErrorMsgByAffair(affair));
                    return summaryVO;
                }
            }

            DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
            isFormQuery = ColOpenFrom.formQuery.name().equals(summaryVO.getOpenFrom());
            boolean isFormStatistical = ColOpenFrom.formStatistical.name().equals(summaryVO.getOpenFrom());
            boolean isFormRelation = ColOpenFrom.formRelation.name().equals(summaryVO.getOpenFrom());
            boolean isDocLib = ColOpenFrom.docLib.name().equals(summaryVO.getOpenFrom());
            boolean isFromListWaitSend = ColOpenFrom.listWaitSend.name().equals(summaryVO.getOpenFrom()) && Integer.valueOf(StateEnum.col_waitSend.getKey()).equals(affair.getState());
            boolean ifFromstepBackRecord = ColOpenFrom.stepBackRecord.name().equalsIgnoreCase(summaryVO.getOpenFrom());
            boolean isFromrepealRecord = ColOpenFrom.repealRecord.name().equals(summaryVO.getOpenFrom());
            boolean isSubFlow = ColOpenFrom.subFlow.name().equals(summaryVO.getOpenFrom());
            if (!ifFromstepBackRecord && !isFromrepealRecord && !isFormQuery && !isFormStatistical && !isFormRelation && !isDocLib && !isFromListWaitSend && !isSubFlow && !ColUtil.isAfffairValid(affair, false)) {
                if (!this.traceDao.getTraceWorkflowsByAffairId(affair.getId())) {
                    summaryVO.setErrorMsg(ColUtil.getErrorMsgByAffair(affair));
                    return summaryVO;
                }

                summaryVO.setOpenFrom("repealRecord");
            }

            if (!SecurityCheck.isLicit(AppContext.getRawRequest(), AppContext.getRawResponse(), ApplicationCategoryEnum.collaboration, user, affair.getId(), affair, summary.getArchiveId(), false)) {
                CtpAffair aff = this.findMemberAffair(affair.getObjectId(), isHistoryFlag, user.getId());
                if (aff == null) {
                    SecurityCheck.printInbreakTrace(AppContext.getRawRequest(), AppContext.getRawResponse(), user, ApplicationCategoryEnum.collaboration);
                    return null;
                }

                affair = aff;
                summaryVO.setAffair(aff);
                summaryVO.setAffairId(aff.getId());
            }

            this.checkCanOpenAcl(summaryVO, affair, summary, isHistoryFlag);
            if (Strings.isNotBlank(summaryVO.getErrorMsg())) {
                return summaryVO;
            } else {
                if (StateEnum.col_pending.getKey() == affair.getState() && SubStateEnum.col_pending_specialBack.getKey() != affair.getSubState() && SubStateEnum.col_pending_specialBacked.getKey() != affair.getSubState() && SubStateEnum.col_pending_specialBackCenter.getKey() != affair.getSubState() && summary.getCaseId() != null) {
                    boolean inInSpecialSB = this.wapi.isInSpecialStepBackStatus(summary.getCaseId(), isHistoryFlag);
                    if (!inInSpecialSB) {
                        AppContext.putRequestContext("inInSpecialSB", true);
                    }
                }

                CtpTemplate template = null;
                String wfOperationId = "";
                String nodeDesc;
                if (summary.getTempleteId() != null) {
                    template = this.templateManager.getCtpTemplate(summary.getTempleteId());
                    if (template != null) {
                        if (Integer.valueOf(StateEnum.col_waitSend.getKey()).equals(affair.getState()) && Boolean.TRUE.equals(template.isDelete()) && "20".equals(template.getBodyType())) {
                            summaryVO.setErrorMsg(ResourceUtil.getString("workflow.wapi.exception.msg001"));
                            return summaryVO;
                        }

                        summaryVO.setCanPraise(template.getCanPraise());
                        if (Integer.valueOf(StateEnum.col_pending.key()).equals(affair.getState())) {
                            nodeDesc = this.wapi.getBPMActivityDesc(template.getWorkflowId(), String.valueOf(affair.getActivityId()));
                            AppContext.putRequestContext("nodeDesc", nodeDesc);
                        }

                        if ("20".equals(template.getBodyType())) {
                            AppContext.putRequestContext("signetProtectInput", template.getSignetProtect());
                        }
                    }
                }

                nodeDesc = affair.getRelationDataId() == null ? "" : String.valueOf(affair.getRelationDataId());
                AppContext.putRequestContext("DR", nodeDesc);
                String rightId = "";
                boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType());
                if (isForm) {
                    String scanCodeInput = "0";
                    if (ColOpenFrom.docLib.name().equals(summaryVO.getOpenFrom())) {
                        boolean isAcountPighole = Integer.valueOf(PigeonholeType.edoc_account.ordinal()).equals(summaryVO.getPigeonholeType());
                        String docLibrightid = ContentUtil.findRightIdbyAffairIdOrTemplateId(affair, template, isAcountPighole, wfOperationId);
                        summaryVO.setOperationId(docLibrightid);
                    }

                    if (!Strings.isBlank(summaryVO.getOperationId()) && !ColOpenFrom.subFlow.name().equals(summaryVO.getOpenFrom())) {
                        rightId = summaryVO.getOperationId();
                    } else {
                        rightId = ContentUtil.findRightIdbyAffairIdOrTemplateId(affair, template, false, wfOperationId);
                    }

                    if (template != null) {
                        if (null != template.getScanCodeInput() && template.getScanCodeInput() && ColOpenFrom.listPending.name().equals(summaryVO.getOpenFrom())) {
                            scanCodeInput = "1";
                        }

                        AppContext.putRequestContext("templateColSubject", template.getColSubject());
                        AppContext.putRequestContext("templateWorkflowId", template.getWorkflowId());
                    }

                    AppContext.putRequestContext("scanCodeInput", scanCodeInput);
                }

                rightId = rightId == null ? null : rightId.replaceAll("[|]", "_");
                AppContext.putRequestContext("rightId", rightId);
                boolean colReadOnly = false;
                if (ColOpenFrom.docLib.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.favorite.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.F8Reprot.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.formStatistical.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.task.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.formQuery.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.formRelation.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.glwd.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.repealRecord.name().equals(summaryVO.getOpenFrom()) || isHistoryFlag || Integer.valueOf(StateEnum.col_waitSend.getKey()).equals(affair.getState()) && SubStateEnum.col_pending_specialBacked.getKey() != affair.getSubState()) {
                    colReadOnly = true;
                }

                summaryVO.setReadOnly(colReadOnly);
                if (!isHistoryFlag) {
                    this.updateAffairStateWhenClick(affair);
                }

                if (Integer.valueOf(flowState.finish.ordinal()).equals(summary.getState()) || Integer.valueOf(flowState.terminate.ordinal()).equals(summary.getState())) {
                    summaryVO.setReadOnly(true);
                }

                summaryVO.setBodyType(summary.getBodyType());
                String configItem = ColUtil.getPolicyByAffair(affair).getId();
                Long accountId = summary.getOrgAccountId();
                Long startMenberId = summary.getStartMemberId();
                if (null == accountId && startMenberId != null) {
                    V3xOrgMember orgMember = this.orgManager.getMemberById(startMenberId);
                    accountId = orgMember.getOrgAccountId();
                }

                int wfTraceType = 0;
                if (template != null) {
                    AppContext.putRequestContext("templateWorkflowId", template.getWorkflowId());
                    AppContext.putRequestContext("templateType", template.getType());
                    accountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), accountId, template.getOrgAccountId());
                    if (null != template.getCanTrackWorkflow()) {
                        wfTraceType = template.getCanTrackWorkflow();
                    }
                }

                AppContext.putRequestContext("wfTraceType", wfTraceType);
                summaryVO.setFlowPermAccountId(accountId);
                String category = EnumNameEnum.col_flow_perm_policy.name();
                Permission permission = null;

                try {
                    permission = this.permissionManager.getPermission(category, configItem, accountId);
                    if (permission != null) {
                        if (!configItem.equals(permission.getName()) && affair.getState() == StateEnum.col_pending.getKey()) {
                            AppContext.putRequestContext("noFindPermission", true);
                        } else {
                            AppContext.putRequestContext("noFindPermission", false);
                        }
                    }
                } catch (Exception var70) {
                    LOG.error("获取节点权限报错category:" + category + " caonfigItem:" + configItem + " accountId:" + accountId, var70);
                }

                List<String> basicActionList = this.permissionManager.getActionList(permission, PermissionAction.basic);
                if (!Strings.isEmpty(basicActionList)) {
                    String isHasPraise = basicActionList.contains("Praise") ? "1" : "0";
                    AppContext.putRequestContext("isHasPraise", isHasPraise);
                }

                List<String> commonActionList = this.permissionManager.getActionList(permission, PermissionAction.common);
                List<String> advanceActionList = this.permissionManager.getActionList(permission, PermissionAction.advanced);
                boolean isTemplete = false;
                if (template != null && template.isSystem()) {
                    isTemplete = true;
                }

                AppContext.putRequestContext("isTemplete", isTemplete);
                this.checkCanAction(affair, summary, basicActionList, commonActionList, advanceActionList, isTemplete);
                NodePolicy nodePolicy = permission.getNodePolicy();
                CustomAction customAction = nodePolicy.getCustomAction();
                if (customAction != null) {
                    String isOptional = customAction.getIsOptional();
                    String optionalAction = customAction.getOptionalAction();
                    String defaultAction = customAction.getDefaultAction();
                    AppContext.putRequestContext("isOptional", isOptional);
                    AppContext.putRequestContext("optionalAction", optionalAction);
                    AppContext.putRequestContext("defaultAction", defaultAction);
                }

                boolean show1 = true;
                boolean show2 = true;
                if (permission != null) {
                    AppContext.putRequestContext("nodeattitude", permission.getNodePolicy().getAttitude());
                    Integer submitStyle = permission.getNodePolicy().getSubmitStyle();
                    if (submitStyle != null) {
                        switch(submitStyle) {
                            case 0:
                                show1 = true;
                                show2 = false;
                                break;
                            case 1:
                                show1 = false;
                                show2 = true;
                        }
                    }
                }

                NodePolicyVO newColNodePolicy = this.getNewColNodePolicy(user.getLoginAccount());
                boolean _canUploadAttachment = basicActionList.contains("UploadAttachment");
                boolean _canUploadRelDoc = basicActionList.contains("UploadRelDoc");
                if ("listSent".equals(summaryVO.getOpenFrom())) {
                    _canUploadAttachment = true;
                    _canUploadRelDoc = true;
                }

                Boolean isNewColNode = (StateEnum.col_sent.getKey() == affair.getState() || StateEnum.col_waitSend.getKey() == affair.getState()) && !ColOpenFrom.supervise.name().equals(summaryVO.getOpenFrom());
                if (isNewColNode) {
                    _canUploadAttachment = newColNodePolicy.isUploadAttachment();
                    _canUploadRelDoc = newColNodePolicy.isUploadRelDoc();
                }

                boolean isSuervise = (StateEnum.col_sent.getKey() == affair.getState() || StateEnum.col_waitSend.getKey() == affair.getState()) && ColOpenFrom.supervise.name().equals(summaryVO.getOpenFrom());
                if (isSuervise) {
                    _canUploadAttachment = true;
                    _canUploadRelDoc = true;
                }

                AppContext.putRequestContext("show1", show1);
                AppContext.putRequestContext("show2", show2);
                AppContext.putRequestContext("newColNodePolicy", newColNodePolicy);
                AppContext.putRequestContext("isNewColNode", isNewColNode);
                AppContext.putRequestContext("nodePerm_baseActionList", JSONUtil.toJSONString(basicActionList));
                AppContext.putRequestContext("nodePerm_commonActionList", JSONUtil.toJSONString(commonActionList));
                AppContext.putRequestContext("nodePerm_advanceActionList", JSONUtil.toJSONString(advanceActionList));
                AppContext.putRequestContext("commonActionList", commonActionList);
                AppContext.putRequestContext("basicActionList", basicActionList);
                AppContext.putRequestContext("advanceActionList", advanceActionList);
                AppContext.putRequestContext("permissionName", this.permissionManager.getPermissionName(permission));
                AppContext.putRequestContext("nodePolicy", configItem);
                AppContext.putRequestContext("canModifyWorkFlow", summary.getCanModify() == null ? false : summary.getCanModify());
                AppContext.putSessionContext("canUploadAttachment", _canUploadAttachment);
                AppContext.putSessionContext("canUploadRelDoc", _canUploadRelDoc);
                AppContext.putSessionContext("canEdit", commonActionList.contains("Edit") || advanceActionList.contains("Edit"));
                boolean isContainOperation = Boolean.valueOf(basicActionList.contains("Archive"));
                if (StateEnum.col_sent.getKey() == affair.getState() || StateEnum.col_waitSend.getKey() == affair.getState()) {
                    isContainOperation = Boolean.valueOf(basicActionList.contains("Pigeonhole"));
                }

                boolean isSenderOrCanArchive = Boolean.TRUE.equals(summary.getCanArchive());
                boolean hasResourceCode = AppContext.getCurrentUser().hasResourceCode("F04_docIndex") || AppContext.getCurrentUser().hasResourceCode("F04_myDocLibIndex") || AppContext.getCurrentUser().hasResourceCode("F04_accDocLibIndex") || AppContext.getCurrentUser().hasResourceCode("F04_proDocLibIndex") || AppContext.getCurrentUser().hasResourceCode("F04_eDocLibIndex") || AppContext.getCurrentUser().hasResourceCode("F04_docLibsConfig");
                hasResourceCode = hasResourceCode && AppContext.hasPlugin("doc");
                String systemVer = AppContext.getSystemProperty("system.ProductId");
                if (AffairUtil.isFormReadonly(affair)) {
                    AppContext.putRequestContext("deeReadOnly", 1);
                }

                String propertyFav = SystemProperties.getInstance().getProperty("doc.collectFlag");
                boolean propertyFavFlag = "true".equals(propertyFav);
                boolean canFavorite = isContainOperation && isSenderOrCanArchive && hasResourceCode && propertyFavFlag && !isFormQuery && !isFormStatistical;
                AppContext.putSessionContext("canFavorite", canFavorite);
                boolean canAttFavorite = hasResourceCode && propertyFavFlag;
                AppContext.putSessionContext("canAttFavorite", canAttFavorite);
                boolean canArchive = isContainOperation && isSenderOrCanArchive && hasResourceCode;
                AppContext.putSessionContext("canArchive", canArchive);
                if (!canFavorite) {
                    LOG.info("協同ID：<" + summary.getId() + ">,没有收藏权限,isContainOperation:" + isContainOperation + " isSenderOrCanArchive:" + isSenderOrCanArchive + " hasResourceCode：" + hasResourceCode + ",propertyFav:" + propertyFav);
                }

                String permissionName = permission == null ? "" : permission.getName();
                AppContext.putRequestContext("isAudit", "formaudit".equals(permissionName));
                AppContext.putRequestContext("isIssus", "newsaudit".equals(permissionName) || "bulletionaudit".equals(permissionName));
                AppContext.putRequestContext("isVouch", "vouch".equals(permissionName));
                AppContext.putRequestContext("senderCanFavorite", hasResourceCode && propertyFavFlag);
                this.setPara4Wf(summary, affair);
                List<Attachment> allAttachments = new ArrayList();
                List<Attachment> temp = this.getAttachmentsById(affair.getObjectId());
                if (temp != null) {
                    allAttachments.addAll(temp);
                }

                String nodePermissionPolicy = ColUtil.getPolicyByAffair(affair).getId();
                String lenPotents = summaryVO.getLenPotent();
                boolean officecanPrint = true;
                boolean officecanSaveLocal = true;
                Map<String, Object> map = this.getSaveToLocalOrPrintPolicy(summary, nodePermissionPolicy, lenPotents, affair, summaryVO.getOpenFrom());
                if (map != null && map.size() != 0) {
                    officecanPrint = (Boolean)map.get("officecanPrint");
                    officecanSaveLocal = (Boolean)map.get("officecanSaveLocal");
                }

                if (ColOpenFrom.supervise.name().equals(summaryVO.getOpenFrom()) || ColOpenFrom.listDone.name().equals(summaryVO.getOpenFrom())) {
                    SuperviseSetVO ssvo = this.superviseManager.parseProcessSupervise(summary.getId(), summary.getTempleteId(), summary.getStartMemberId(), EntityType.summary);
                    if (Strings.isNotBlank(ssvo.getSupervisorIds()) && ssvo.getSupervisorIds().indexOf(user.getId().toString()) != -1) {
                        summaryVO.setIsCurrentUserSupervisor(true);
                    }
                }

                V3xOrgMember orgMember = this.orgManager.getMemberById(affair.getMemberId());
                if (orgMember != null) {
                    summaryVO.setAffairMemberName(orgMember.getName());
                }

                summaryVO.setActivityId(affair.getActivityId());
                summaryVO.setWorkitemId(affair.getSubObjectId());
                summaryVO.setOfficecanPrint(officecanPrint);
                summaryVO.setOfficecanSaveLocal(officecanSaveLocal);
                summaryVO.setForwardMemberNames(this.getForwardMemberNames(summary.getForwardMember()));
                summaryVO.setSummary(summary);
                summaryVO.setIsTrack(AffairUtil.isTrack(affair));
                summaryVO.setAffair(affair);
                summaryVO.setAttachments(allAttachments);
                summaryVO.setShowButton(false);
                summaryVO.setCreateDate(summary.getCreateDate());
                if (summary.getCaseId() != null) {
                    summaryVO.setCaseId(summary.getCaseId().toString());
                }

                String subject = ColUtil.showSubjectOfSummary(summary, false, -1, (String)null).replaceAll("\r\n", "").replaceAll("\n", "");
                summaryVO.setSubject(subject);
                Integer newflowType = summary.getNewflowType();
                if (newflowType != null && newflowType == NewflowType.main.ordinal()) {
                    summaryVO.setIsNewflow(false);
                } else if (newflowType != null && newflowType == NewflowType.child.ordinal()) {
                    summaryVO.setIsNewflow(true);
                } else {
                    summaryVO.setIsNewflow(false);
                }

                summaryVO.setProcessId(summary.getProcessId());
                summaryVO.setFlowFinished(summary.getFinishDate() != null);
                V3xOrgMember member = this.orgManager.getMemberById(summary.getStartMemberId());
                String postName;
                if (member != null) {
                    summaryVO.setStartMemberName(Functions.showMemberName(member));
                    summaryVO.setStartMemberDepartmentId(member.getOrgDepartmentId());
                    if (member.getIsInternal()) {
                        summaryVO.setStartMemberPostId(member.getOrgPostId());
                        postName = "";
                        if (member.getOrgPostId() != null) {
                            V3xOrgPost post = this.orgManager.getPostById(member.getOrgPostId());
                            if (post != null) {
                                postName = post.getName();
                            }
                        }

                        summaryVO.setStartMemberPostName(postName);
                    } else {
                        summaryVO.setStartMemberPostId((Long)null);
                        summaryVO.setStartMemberPostName(OrgHelper.getExtMemberPriPost(member));
                    }
                }

                if (permission != null) {
                    Integer opinion = permission.getNodePolicy().getOpinionPolicy();
                    if (opinion != null && opinion == 1) {
                        summaryVO.setCanDeleteORarchive(true);
                    }

                    summaryVO.setCancelOpinionPolicy(permission.getNodePolicy().getCancelOpinionPolicy());
                    summaryVO.setDisAgreeOpinionPolicy(permission.getNodePolicy().getDisAgreeOpinionPolicy());
                }

                postName = user.getCustomize("handle_Expand");
                AppContext.putRequestContext("isDealPageShow", postName == null ? "" : postName);
                String _trackValue = user.getCustomize("track_process");
                AppContext.putRequestContext("customSetTrack", _trackValue);
                String trackIds = "";
                String trackOnlyIds = "";
                String trackNames = "";
                AppContext.putRequestContext("trackType", affair.getTrack());
                if (null != affair.getTrack() && affair.getTrack() == 2) {
                    List<CtpTrackMember> trackInfo = this.trackManager.getTrackMembers(affair.getId());
                    if (Strings.isNotEmpty(trackInfo)) {
                        V3xOrgMember trackMember;
                        for(Iterator var66 = trackInfo.iterator(); var66.hasNext(); trackNames = trackNames + Functions.showMemberName(trackMember) + ",") {
                            CtpTrackMember ctpTrackMember = (CtpTrackMember)var66.next();
                            Long trackMemeberId = ctpTrackMember.getTrackMemberId();
                            trackMember = this.orgManager.getMemberById(trackMemeberId);
                            trackIds = trackIds + "Member|" + trackMemeberId + ",";
                            trackOnlyIds = trackOnlyIds + trackMember.getId() + ",";
                        }

                        if (trackIds.length() > 0) {
                            AppContext.putRequestContext("trackIds", trackIds.substring(0, trackIds.length() - 1));
                            AppContext.putRequestContext("trackOnlyIds", trackOnlyIds.substring(0, trackOnlyIds.length() - 1));
                            AppContext.putRequestContext("trackNames", trackNames.substring(0, trackNames.length() - 1));
                        }
                    }
                }

                String arrListJSON = "";
                List<Attachment> mainAtt = new ArrayList();
                this.comtentDraftAttAndDis(allAttachments, affair);
                if (Strings.isNotEmpty(allAttachments)) {
                    Iterator var87 = allAttachments.iterator();

                    label363:
                    while(true) {
                        Attachment att;
                        do {
                            do {
                                if (!var87.hasNext()) {
                                    break label363;
                                }

                                att = (Attachment)var87.next();
                            } while(!affair.getObjectId().equals(att.getSubReference()));
                        } while(!Integer.valueOf(ATTACHMENT_TYPE.FILE.ordinal()).equals(att.getType()) && !Integer.valueOf(ATTACHMENT_TYPE.DOCUMENT.ordinal()).equals(att.getType()));

                        mainAtt.add(att);
                    }
                }

                Collections.sort(mainAtt, new Comparator<Attachment>() {
                    public int compare(Attachment a1, Attachment a2) {
                        Date d1 = a1.getCreatedate();
                        Date d2 = a2.getCreatedate();
                        int res = 0;
                        if (d1 != null && d2 != null) {
                            res = d1.compareTo(d2);
                        } else if (d1 == null && d2 != null) {
                            res = -1;
                        } else if (d1 != null && d2 == null) {
                            res = 1;
                        }

                        return res == 0 ? 0 : (res > 0 ? -1 : 1);
                    }
                });
                arrListJSON = this.attachmentManager.getAttListJSON(mainAtt);
                String productId = AppContext.getSystemProperty("system.ProductId");
                AppContext.putRequestContext("productId", productId);
                AppContext.putRequestContext("attListJSON", arrListJSON);
                AppContext.putRequestContext("collEnumKey", ApplicationCategoryEnum.collaboration.getKey());
                if (summary.getTempleteId() == null && summary.getProcessId() != null) {
                    new ArrayList();
                    List nodeInfos;
                    if (Strings.isNotEmpty(summary.getProcessNodesInfo())) {
                        nodeInfos = this.parseNodeInfos(summary.getProcessNodesInfo());
                    } else {
                        nodeInfos = this.getNodeMemberInfos(summary.getProcessId());
                    }

                    AppContext.putRequestContext("nodeInfos", nodeInfos);
                }

                return summaryVO;
            }
        }
    }

    private List<String[]> parseNodeInfos(String processNodesInfo) {
        List<String[]> nodeInfos = new ArrayList();
        if (Strings.isNotBlank(processNodesInfo)) {
            List<Map> nodeList = (List)JSONUtil.parseJSONString(processNodesInfo);

            for(int a = 0; a < nodeList.size(); ++a) {
                Map map = (Map)nodeList.get(a);
                String[] info = new String[5];
                String nodeName = (String)map.get("nodeName");
                String accountId = (String)map.get("actorPartyAccountId");
                if (Strings.isNotBlank(accountId) && Strings.isDigits(accountId)) {
                    try {
                        Long _wfAccount = Long.valueOf(accountId);
                        if (!_wfAccount.equals(AppContext.currentAccountId())) {
                            V3xOrgAccount account = this.orgManager.getAccountById(_wfAccount);
                            if (account != null) {
                                nodeName = nodeName + "(" + account.getShortName() + ")";
                            }
                        }
                    } catch (Throwable var11) {
                        LOG.error("", var11);
                    }
                }

                info[0] = nodeName;
                info[1] = (String)map.get("nodeId");
                info[2] = (String)map.get("actorPartyId");
                info[3] = (String)map.get("actorTypeId");
                info[4] = "true";
                nodeInfos.add(info);
            }
        }

        return nodeInfos;
    }

    private List<String[]> getNodeMemberInfos(String processId) throws BPMException {
        BPMProcess process = this.wapi.getBPMProcessForM1(processId);
        if (process == null) {
            process = this.wapi.getBPMProcessHis(processId);
        }

        List<String[]> nodeInfos = new ArrayList();
        if (process != null) {
            List<BPMAbstractNode> processes = this.wapi.getHumenNodeInOrderFromProcess(process);
            List<BPMAbstractNode> nodes = new ArrayList(processes.size());
            Iterator var6 = processes.iterator();

            BPMAbstractNode node;
            while(var6.hasNext()) {
                Object _node = var6.next();
                node = (BPMAbstractNode)_node;
                if (!"start".equals(node.getId()) && !"end".equals(node.getId()) && !"join".equals(node.getName()) && !"split".equals(node.getName()) && Strings.isNotEmpty(node.getActorList())) {
                    nodes.add(node);
                }
            }

            List<Map<String, String>> nodeInfoMaps = new ArrayList();
            Iterator var20 = nodes.iterator();

            while(var20.hasNext()) {
                node = (BPMAbstractNode)var20.next();
                BPMActor actor = (BPMActor)node.getActorList().get(0);
                String[] info = new String[5];
                String nodeId = node.getId();
                String type = actor.getType().id;
                info[1] = nodeId;
                info[2] = actor.getParty().getId();
                info[3] = type;
                String nodeName = node.getBPMAbstractNodeName();
                String showNodeName = nodeName;
                String accountId = actor.getParty().getAccountId();
                if (Strings.isNotBlank(accountId) && Strings.isDigits(accountId)) {
                    try {
                        Long _wfAccount = Long.valueOf(accountId);
                        if (!_wfAccount.equals(AppContext.currentAccountId())) {
                            V3xOrgAccount account = this.orgManager.getAccountById(_wfAccount);
                            if (account != null) {
                                showNodeName = nodeName + "(" + account.getShortName() + ")";
                            }
                        }
                    } catch (Throwable var18) {
                        LOG.error("", var18);
                    }
                }

                info[0] = showNodeName;
                String canClick = "true";
                info[4] = canClick;
                nodeInfos.add(info);
                Map<String, String> map = new HashMap();
                map.put("nodeId", nodeId);
                map.put("nodeName", nodeName);
                map.put("actorTypeId", type);
                map.put("actorPartyId", actor.getParty().getId());
                map.put("actorPartyAccountId", accountId);
                nodeInfoMaps.add(map);
            }

            if (Strings.isNotEmpty(nodeInfoMaps)) {
                String nodesInfo = JSONUtil.toJSONString(nodeInfoMaps);
                this.colDao.updateColSummaryProcessNodeInfos(processId, nodesInfo);
            }
        }

        return nodeInfos;
    }

    private void checkCanOpenAcl(ColSummaryVO summaryVO, CtpAffair affair, ColSummary summary, boolean isHistoryFlag) throws BusinessException {
        HttpServletRequest request = AppContext.getRawRequest();
        String isCollCube = request.getParameter("isCollCube");
        String isColl360 = request.getParameter("isColl360");
        AppContext.putRequestContext("summaryId", affair.getObjectId());
        AppContext.putRequestContext("isCollCube", isCollCube);
        AppContext.putRequestContext("isColl360", isColl360);
        if (!Strings.isNotBlank(isCollCube) || !"1".equals(isCollCube) || StateEnum.col_done.getKey() == affair.getState() && StateEnum.col_sent.getKey() == affair.getState()) {
            if (Strings.isNotBlank(isColl360) && "1".equals(isColl360) && (StateEnum.col_sent.getKey() == affair.getState() && affair.isDelete() || StateEnum.col_done.getKey() != affair.getState() && affair.isDelete() || StateEnum.col_waitSend.getKey() == affair.getState() || StateEnum.col_pending.getKey() == affair.getState())) {
                summaryVO.setErrorMsg(ResourceUtil.getString("collaboration.alert.chuantou.label"));
            } else {
                if (ColOpenFrom.stepBackRecord.name().equals(summaryVO.getOpenFrom()) && null != summary.getCaseId() && null != affair.getActivityId()) {
                    boolean nodeDelete = false;
                    if (isHistoryFlag) {
                        nodeDelete = this.wapi.isNodeDelete(summary.getCaseId(), affair.getActivityId().toString(), isHistoryFlag);
                    } else {
                        nodeDelete = this.wapi.isNodeDelete(summary.getCaseId(), affair.getActivityId().toString());
                    }

                    boolean effectiveAffair = this.isEffectiveAffair(summary.getId(), affair.getActivityId(), AppContext.getCurrentUser().getId());
                    if (nodeDelete || !effectiveAffair) {
                        summaryVO.setErrorMsg(ResourceUtil.getString("collaboration.alert.notExistInWF"));
                        return;
                    }
                }

            }
        } else {
            summaryVO.setErrorMsg(ResourceUtil.getString("collaboration.alert.chuantou.label"));
        }
    }

    private boolean isEffectiveAffair(Long objectId, Long activityId, Long memId) throws BusinessException {
        boolean flag = true;
        List<CtpAffair> affairsByActivityId = this.affairManager.getAffairsByObjectIdAndNodeId(objectId, activityId);
        List<Long> _memId = new ArrayList();

        for(int a = 0; a < affairsByActivityId.size(); ++a) {
            CtpAffair affair = (CtpAffair)affairsByActivityId.get(a);
            if (ColUtil.isAfffairValid(affair)) {
                _memId.add(affair.getMemberId());
            }
        }

        if (!Strings.isEmpty(_memId) && !_memId.contains(memId)) {
            flag = false;
        }

        return flag;
    }

    private void comtentDraftAttAndDis(List<Attachment> attachments, CtpAffair affair) {
        String handleAttach = "";
        Long commentId = null;
        List<Attachment> dealAtt = new ArrayList();
        Comment comentDraft = this.getDraftOpinion(affair.getId());
        AppContext.putRequestContext("commentDraft", comentDraft);
        String displayIds = "";
        String displayNames = "";

        try {
            if (affair.getState().equals(StateEnum.col_pending.key())) {
                if (comentDraft != null) {
                    commentId = comentDraft.getId();
                    Iterator var9 = attachments.iterator();

                    while(var9.hasNext()) {
                        Attachment att = (Attachment)var9.next();
                        if (commentId.equals(att.getSubReference())) {
                            dealAtt.add(att);
                        }
                    }

                    if (comentDraft.getShowToId() != null) {
                        String[] ids = comentDraft.getShowToId().split(",");
                        if (!"".equals(ids[0])) {
                            for(int i = 0; i < ids.length; ++i) {
                                V3xOrgMember mem = this.orgManager.getMemberById(Long.valueOf(ids[i]));
                                if (i == ids.length - 1) {
                                    displayIds = displayIds + "Member|" + ids[i];
                                    displayNames = displayNames + mem.getName();
                                } else {
                                    displayIds = displayIds + "Member|" + ids[i] + ",";
                                    displayNames = displayNames + mem.getName() + ",";
                                }
                            }
                        }
                    }
                }
            } else {
                commentId = 20L;
            }
        } catch (Exception var12) {
            LOG.error("获取草稿中的附件、意见隐藏人报错！", var12);
        }

        AppContext.putRequestContext("displayIds", displayIds);
        AppContext.putRequestContext("displayNames", displayNames);
        handleAttach = this.attachmentManager.getAttListJSON(dealAtt);
        AppContext.putRequestContext("commentId", commentId);
        AppContext.putRequestContext("handleAttachJSON", handleAttach);
    }

    public ColSummary getMainSummary4FormQueryAndStatic(String openFrom, String summaryId) throws BPMException, BusinessException {
        ColSummary summary = null;
        if ((ColOpenFrom.formQuery.name().equals(openFrom) || ColOpenFrom.formStatistical.name().equals(openFrom)) && Strings.isNotBlank(summaryId)) {
            summary = this.getColSummaryById(Long.valueOf(summaryId));
            if (summary == null) {
                LOG.info("协同展现，表单穿透，统计，summary为空，入参summaryId：" + summaryId);
            }

            if (summary != null && Integer.valueOf(NewflowType.child.ordinal()).equals(summary.getNewflowType())) {
                String processId = summary.getProcessId();
                if (Strings.isNotBlank(processId)) {
                    Long parentProcessId = this.wapi.getMainProcessIdBySubProcessId(Long.valueOf(processId));
                    if (null != parentProcessId) {
                        ColSummary colSummaryById = this.getColSummaryByProcessId(parentProcessId);
                        if (null != colSummaryById) {
                            summary = colSummaryById;
                        }
                    }
                }
            }
        }

        return summary;
    }

    private void checkCanAction(CtpAffair affair, ColSummary summary, List<String> basicActionList, List<String> commonActionList, List<String> advanceActionList, boolean isTemplete) {
        if (!ColUtil.checkByReourceCode("F02_eventlist") || !AppContext.hasPlugin("calendar")) {
            commonActionList.remove("Transform");
            advanceActionList.remove("Transform");
        }

        if (!AppContext.hasPlugin("doc")) {
            basicActionList.remove("Pigeonhole");
        }

        if (!ColUtil.checkByReourceCode("F01_newColl")) {
            advanceActionList.remove("Forward");
            commonActionList.remove("Forward");
        }

        if (summary.getCanEdit() != null && !summary.getCanEdit()) {
            if (advanceActionList != null) {
                advanceActionList.remove("Edit");
            }

            if (commonActionList != null) {
                commonActionList.remove("Edit");
            }
        }

        if (summary.getCanEditAttachment() != null && !summary.getCanEditAttachment()) {
            if (advanceActionList != null) {
                advanceActionList.remove("allowUpdateAttachment");
            }

            if (commonActionList != null) {
                commonActionList.remove("allowUpdateAttachment");
            }
        }

        if (summary.getCanForward() != null && !summary.getCanForward()) {
            if (advanceActionList != null) {
                advanceActionList.remove("Forward");
            }

            if (commonActionList != null) {
                commonActionList.remove("Forward");
            }
        }

        if (summary.getCanArchive() != null && !summary.getCanArchive() && basicActionList != null) {
            basicActionList.remove("Archive");
        }

        if (isTemplete && summary.getCanModify() != null && !summary.getCanModify()) {
            if (advanceActionList != null) {
                advanceActionList.remove("JointSign");
                advanceActionList.remove("RemoveNode");
                advanceActionList.remove("Infom");
                advanceActionList.remove("AddNode");
            }

            if (commonActionList != null) {
                commonActionList.remove("AddNode");
                commonActionList.remove("JointSign");
                commonActionList.remove("RemoveNode");
                commonActionList.remove("Infom");
            }
        }

        if (Strings.isNotBlank(summary.getForwardMember()) && summary.getCanEdit() != null && !summary.getCanEdit()) {
            if (advanceActionList.contains("Edit")) {
                advanceActionList.remove("Edit");
            }

            if (commonActionList.contains("Edit")) {
                commonActionList.remove("Edit");
            }
        }

        boolean isFinished = ColUtil.isColSummaryFinished(summary);
        if (isFinished) {
            basicActionList.remove("Track");
        }

        User user = AppContext.getCurrentUser();
        if (user.getExternalType() != ExternalType.Inner.ordinal()) {
            basicActionList.remove("CommonPhrase");
        }

    }

    private void setPara4Wf(ColSummary summary, CtpAffair affair) throws BusinessException {
        HttpServletRequest request = (HttpServletRequest)AppContext.getThreadContext("THREAD_CONTEXT_REQUEST_KEY");
        ContentViewRet context = new ContentViewRet();
        context.setModuleId(summary.getId());
        context.setModuleType(ModuleType.collaboration.getKey());
        context.setAffairId(affair.getId());
        context.setWfActivityId(affair.getActivityId());
        if (Strings.isNotBlank(summary.getProcessId())) {
            context.setWfCaseId(summary.getCaseId());
            context.setWfItemId(affair.getSubObjectId());
            context.setWfProcessId(summary.getProcessId());
            AppContext.putRequestContext("scene", 3);
        } else if (null != summary.getTempleteId() && Strings.isNotBlank(String.valueOf(summary.getTempleteId()))) {
            CtpTemplate cp = this.templateManager.getCtpTemplate(summary.getTempleteId());
            if (null != cp && !"text".equals(cp.getType())) {
                context.setWfProcessId(cp.getWorkflowId().toString());
                AppContext.putRequestContext("scene", 2);
            }
        }

        context.setContentSenderId(summary.getStartMemberId());
        ContentConfig contentCfg = ContentConfig.getConfig(ModuleType.collaboration);
        request.setAttribute("contentCfg", contentCfg);
        request.setAttribute("contentContext", context);
    }

    private NewCollTranVO setWorkFlowInfo(CtpTemplate template, NewCollTranVO vobj) throws BPMException, BusinessException {
        ContentViewRet contextwf = (ContentViewRet)AppContext.getRequestContext("contentContext");
        CtpTemplate ct = this.templateManager.getCtpTemplate(template.getId());
        Long workflowId = ct.getWorkflowId();
        if (contextwf != null && null != workflowId) {
            if ((workflowId == -1L || !ct.isSystem()) && null != ct.getFormParentid() && null != this.templateManager.getCtpTemplate(ct.getFormParentid())) {
                ct = this.templateManager.getCtpTemplate(template.getFormParentid());
            }

            contextwf.setWfProcessId(ct.getWorkflowId().toString());
            if (!template.isSystem() && null == ct || !template.isSystem() && null != ct && !ct.isSystem()) {
                contextwf.setWfProcessId((String)null);
            }

            EnumManager em = (EnumManager)AppContext.getBean("enumManagerNew");
            Map<String, CtpEnumBean> ems = em.getEnumsMap(ApplicationCategoryEnum.collaboration);
            CtpEnumBean nodePermissionPolicy = (CtpEnumBean)ems.get(EnumNameEnum.col_flow_perm_policy.name());
            String workflowNodesInfo = this.wapi.getWorkflowNodesInfo(String.valueOf(ct.getWorkflowId()), ModuleType.collaboration.name(), nodePermissionPolicy);
            contextwf.setWorkflowNodesInfo(workflowNodesInfo);
            String xml = "";
            if (!ct.isSystem()) {
                xml = this.wapi.selectWrokFlowTemplateXml(ct.getWorkflowId().toString());
                vobj.setWfXMLInfo(Strings.escapeJavascript(xml));
            }

            AppContext.putRequestContext("contentContext", contextwf);
        }

        return vobj;
    }

    public NewCollTranVO transferTemplate(NewCollTranVO vobj) throws BusinessException {
        String _templateId = vobj.getTempleteId();
        vobj.setFromTemplate(true);
        Long templateId = Long.valueOf(_templateId);
        CtpTemplate template = vobj.getTemplate();
        if (template != null) {
            AppContext.putRequestContext("curTemplateID", template.getId());
            Long templeteFormparnetId = template.getFormParentid();
            if (null != templeteFormparnetId && Strings.isNotBlank(String.valueOf(templeteFormparnetId))) {
                vobj.setTemformParentId(String.valueOf(templeteFormparnetId));
            }

            vobj.setFormtitle(template.getSubject());
            Long standardDuration = template.getStandardDuration();
            vobj.setStandardDuration(ColUtil.getStandardDuration(standardDuration == null ? null : standardDuration.toString()));
            ColSummary summary = (ColSummary)XMLCoder.decoder(template.getSummary());
            Long projectId = template.getProjectId();
            if (null != projectId && AppContext.hasPlugin("project") && null != this.projectApi) {
                ProjectBO ps = this.projectApi.getProject(projectId);
                if (null != ps && ProjectBO.STATE_DELETE.intValue() != ps.getProjectState()) {
                    summary.setProjectId(projectId);
                } else {
                    summary.setProjectId((Long)null);
                    template.setProjectId((Long)null);
                }
            }

            if (!Type.template.name().equals(template.getType())) {
                summary.setCanForward(true);
                summary.setCanArchive(true);
                summary.setCanDueReminder(true);
                summary.setCanEditAttachment(true);
                summary.setCanTrack(true);
                summary.setCanEdit(true);
            }

            if (Type.text.name().equals(template.getType())) {
                summary.setCanModify(true);
            }

            summary.setSubject(template.getSubject());
            boolean isPersonFlag;
            String fsubject;
            if (Type.template.name().equals(template.getType())) {
                String attListJSON = this.attachmentManager.getAttListJSON(templateId);
                vobj.setAttListJSON(attListJSON);
                vobj.setCloneOriginalAtts(true);
                if (summary.getArchiveId() != null && AppContext.hasPlugin("doc")) {
                    isPersonFlag = this.docApi.isDocResourceExisted(summary.getArchiveId());
                    if (isPersonFlag) {
                        try {
                            if (Strings.isNotBlank(summary.getAdvancePigeonhole())) {
                                JSONObject jo = new JSONObject(summary.getAdvancePigeonhole());
                                vobj.setAdvancePigeonhole(summary.getAdvancePigeonhole());
                                fsubject = "";
                                String tempFolder = "";
                                if (jo.has("archiveFieldName")) {
                                    fsubject = jo.get("archiveFieldName").toString();
                                    tempFolder = ColUtil.getArchiveAllNameById(summary.getArchiveId()) + "\\{" + fsubject + "}";
                                } else {
                                    tempFolder = ColUtil.getArchiveAllNameById(summary.getArchiveId());
                                }

                                vobj.setArchiveName(tempFolder);
                                vobj.setArchiveAllName(tempFolder);
                            } else {
                                vobj.setArchiveId(summary.getArchiveId());
                                vobj.setArchiveName(ColUtil.getArchiveNameById(summary.getArchiveId()));
                                vobj.setArchiveAllName(ColUtil.getArchiveAllNameById(summary.getArchiveId()));
                            }
                        } catch (JSONException var15) {
                            LOG.error("", var15);
                        }
                    } else {
                        summary.setArchiveId((Long)null);
                    }
                }

                if (summary.getAttachmentArchiveId() != null && AppContext.hasPlugin("doc")) {
                    isPersonFlag = this.docApi.isDocResourceExisted(summary.getAttachmentArchiveId());
                    if (isPersonFlag) {
                        vobj.setAttachmentArchiveId(summary.getAttachmentArchiveId());
                        summary.setCanArchive(true);
                    }
                }

                List<Comment> commentSenderList = this.commentManager.getCommentList(ModuleType.collaboration, templateId);
                AppContext.putRequestContext("commentSenderList", commentSenderList);
            }

            List<CtpContentAll> contentAll = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, templateId, false);
            if (null != contentAll && !contentAll.isEmpty()) {
                CtpContentAll content = (CtpContentAll)contentAll.get(0);
                if (content != null) {
                    summary.setFormAppid(content.getContentTemplateId());
                }
            }

            isPersonFlag = false;
            if (templeteFormparnetId != null) {
                template = this.templateManager.getCtpTemplate(templeteFormparnetId);
                if (template == null) {
                    return null;
                }

                isPersonFlag = true;
            }

            if (Strings.isNotBlank(template.getColSubject())) {
                vobj.setCollSubjectNotEdit(true);
                vobj.setCollSubject(template.getColSubject());
            }

            if (template.isSystem()) {
                vobj.setSystemTemplate(true);
            } else {
                vobj.setSystemTemplate(false);
            }

            if ("FORM".equals(template.getBodyType())) {
                vobj.setForm(Boolean.TRUE);
            } else {
                vobj.setForm(Boolean.FALSE);
            }

            AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, String.valueOf(templateId), AppContext.currentUserId());
            if (Type.template.name().equals(template.getType())) {
                this.superviseManager.parseTemplateSupervise4New(templateId, AppContext.currentUserId(), template.getOrgAccountId());
            } else if (Type.workflow.name().equals(template.getType()) || Type.text.name().equals(template.getType())) {
                template.setStandardDuration((Long)null);
                vobj.setStandardDuration((String)null);
                summary.setDeadline((Long)null);
                summary.setAdvanceRemind((Long)null);
            }

            vobj.setTemplate(template);
            Date _date = new Date();
            fsubject = this.getTemplateSubject(summary.getSubject(), _date, false);
            summary.setSubject(fsubject);
            vobj.setSubjectForCopy(fsubject);
            vobj.setSummary(summary);
            ColSummary tSummary = summary;
            if (isPersonFlag) {
                tSummary = (ColSummary)XMLCoder.decoder(template.getSummary());
            }

            String scanCodeInput = "0";
            if (template != null && null != template.getScanCodeInput() && template.getScanCodeInput()) {
                scanCodeInput = "1";
            }

            AppContext.putRequestContext("scanCodeInput", scanCodeInput);
            vobj.setTempleteHasDeadline(tSummary.getDeadline() != null && tSummary.getDeadline() != 0L);
            vobj.setTempleteHasRemind(tSummary.getAdvanceRemind() != null && tSummary.getAdvanceRemind() != 0L && tSummary.getAdvanceRemind() != -1L);
            vobj.setCanEditColPigeonhole(tSummary.getArchiveId() != null);
            if (null != template.getFormParentid()) {
                vobj.setParentWrokFlowTemplete(this.isParentWrokFlowTemplete(template.getFormParentid()));
                vobj.setParentTextTemplete(this.isParentTextTemplete(template.getFormParentid()));
                vobj.setParentColTemplete(this.isParentColTemplete(template.getFormParentid()));
            } else {
                vobj.setParentWrokFlowTemplete(template.isSystem() && "workflow".equals(template.getType()));
                vobj.setParentTextTemplete(template.isSystem() && "text".equals(template.getType()));
                vobj.setParentColTemplete(template.isSystem() && "template".equals(template.getType()));
            }

            vobj.setFromSystemTemplete(template.isSystem());
        }

        return vobj;
    }

    private String getTemplateSubject(String subject, Object now, boolean needCut) {
        User curUser = AppContext.getCurrentUser();
        String title = subject;
        if (needCut) {
            title = subject.substring(0, subject.indexOf("("));
        }

        String formatDate = Datetimes.formatDatetimeWithoutSecond((Date)now);
        title = title + "(" + curUser.getName() + " " + formatDate + ")";
        return title;
    }

    private void CopySuperviseFromSummary(NewCollTranVO vobj, Long summaryId) throws BusinessException {
        SuperviseSetVO ssvo = new SuperviseSetVO();
        CtpSuperviseDetail detail = this.superviseManager.getSupervise(summaryId);
        if (detail != null) {
            ssvo.setTitle(detail.getTitle());
            Long terminalDate = detail.getTemplateDateTerminal();
            if (null != terminalDate) {
                Date superviseDate = Datetimes.addDate(new Date(), terminalDate.intValue());
                String date = Datetimes.format(superviseDate, "yyyy-MM-dd HH:mm");
                vobj.setSuperviseDate(date);
            } else if (detail.getAwakeDate() != null) {
                vobj.setSuperviseDate(Datetimes.format(detail.getAwakeDate(), "yyyy-MM-dd HH:mm"));
                ssvo.setAwakeDate(Datetimes.format(detail.getAwakeDate(), "yyyy-MM-dd HH:mm"));
            }

            List<CtpSupervisor> supervisors = this.superviseManager.getSupervisors(detail.getId());
            Set<String> sIdSet = new HashSet();
            Iterator var8 = supervisors.iterator();

            while(var8.hasNext()) {
                CtpSupervisor supervisor = (CtpSupervisor)var8.next();
                sIdSet.add(supervisor.getSupervisorId().toString());
            }

            if (!sIdSet.isEmpty()) {
                StringBuffer names = new StringBuffer();
                StringBuffer ids = new StringBuffer();
                String forshow = "";
                Iterator var11 = sIdSet.iterator();

                while(var11.hasNext()) {
                    String s = (String)var11.next();
                    V3xOrgMember mem = this.orgManager.getMemberById(Long.valueOf(s));
                    if (mem != null) {
                        if (ids.length() > 0) {
                            ids.append(",");
                            names.append(",");
                        }

                        ids.append(mem.getId());
                        names.append(mem.getName());
                        forshow = forshow + "Member|" + mem.getId() + ",";
                    }
                }

                if (forshow.length() > 0) {
                    vobj.setForShow(forshow.substring(0, forshow.length() - 1));
                }

                ColSummary byId = this.getSummaryById(summaryId);
                if (null != byId && null != byId.getTempleteId()) {
                    Set<Long> _tempSur = this.superviseManager.parseTemplateSupervisorIds(byId.getTempleteId(), AppContext.getCurrentUser().getId());
                    StringBuffer sb = new StringBuffer();
                    if (null != _tempSur) {
                        Iterator var14 = _tempSur.iterator();

                        while(var14.hasNext()) {
                            Long lid = (Long)var14.next();
                            sb.append(lid + ",");
                        }

                        String sbs = sb.toString();
                        if (sbs.length() > 1) {
                            ssvo.setUnCancelledVisor(sbs.substring(0, sbs.length() - 1));
                        }
                    }
                }

                vobj.setColSupervisors(ids.toString());
                vobj.setColSupervisorNames(names.toString());
                ssvo.setSupervisorNames(names.toString());
            }

            vobj.setColSupervise(detail);
            if (!Strings.isNotBlank(ssvo.getTitle()) && !Strings.isNotBlank(ssvo.getAwakeDate()) && !Strings.isNotBlank(ssvo.getSupervisorNames())) {
                vobj.setSuperviseDate((String)null);
            } else {
                AppContext.putRequestContext("_SSVO", ssvo);
            }
        }

    }

    public boolean isParentTextTemplete(Long templeteId) throws BusinessException {
        CtpTemplate t = this.getParentSystemTemplete(templeteId);
        if (t == null) {
            return false;
        } else {
            return Type.text.name().equals(t.getType());
        }
    }

    public boolean isParentWrokFlowTemplete(Long templeteId) throws BusinessException {
        CtpTemplate t = this.getParentSystemTemplete(templeteId);
        if (t == null) {
            return false;
        } else {
            return Type.workflow.name().equals(t.getType());
        }
    }

    public boolean isParentColTemplete(Long templeteId) throws BusinessException {
        CtpTemplate t = this.getParentSystemTemplete(templeteId);
        if (t == null) {
            return false;
        } else {
            return Type.template.name().equals(t.getType());
        }
    }

    public ColSummary getColSummaryByProcessId(Long processId) throws BusinessException {
        ColSummary s = this.colDao.getColSummaryByProcessId(processId);
        if (s == null && AppContext.hasPlugin("fk")) {
            ColDao colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
            s = colDaoFK.getColSummaryByProcessId(processId);
        }

        return s;
    }

    public ColSummary getColSummaryByProcessIdHistory(Long processId) throws BusinessException {
        ColSummary s = null;
        ColDao colDaoFK = null;
        if (AppContext.hasPlugin("fk")) {
            colDaoFK = (ColDao)AppContext.getBean("colDaoFK");
        }

        if (colDaoFK != null) {
            s = colDaoFK.getColSummaryByProcessId(processId);
        }

        return s;
    }

    public String transStepStop(Map<String, Object> tempMap) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String _affairId = (String)tempMap.get("affairId");
        String repealComment = (String)tempMap.get("repealComment");
        if (_affairId == null) {
            return null;
        } else {
            Comment comment = new Comment();
            if (Strings.isNotBlank(repealComment)) {
                comment.setContent(repealComment);
            }

            Long affairId = Long.parseLong(_affairId);
            String processId = null;

            String var10;
            try {
                CtpAffair affair = this.affairManager.get(affairId);
                if (affair.getState() == StateEnum.col_pending.key()) {
                    ColSummary summary = this.getColSummaryById(affair.getObjectId());

                    Long _workitemId;
                    try {
                        boolean canDeal = ColUtil.checkAgent(affair, summary, true);
                        if (!canDeal) {
                            _workitemId = null;
                            return null;
                        }
                    } catch (Exception var20) {
                        LOG.error("", var20);
                    }

                    processId = summary.getProcessId();
                    Map<String, Object> columnValue = new HashMap();
                    if (affairId != null) {
                        if (!user.isAdmin() && !user.getId().equals(affair.getMemberId())) {
                            columnValue.put("transactorId", user.getId());
                            comment.setExtAtt2(user.getName());
                        }

                        if (!columnValue.isEmpty() && columnValue.size() > 0) {
                            this.affairManager.update(affairId, columnValue);
                        }
                    }

                    ParamUtil.getJsonDomainToBean("comment_deal", comment);
                    DateSharedWithWorkflowEngineThreadLocal.setPushMessageMembers(comment.getPushMessageToMembersList());
                    comment.setModuleId(summary.getId());
                    comment.setCtype(CommentType.comment.getKey());
                    comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
                    if (user.isAdmin()) {
                        comment.setCreateId(user.getId());
                    } else {
                        comment.setCreateId(affair.getMemberId());
                        comment.setAffairId(affairId);
                    }

                    comment.setExtAtt3("collaboration.dealAttitude.termination");
                    if (!user.getId().equals(affair.getMemberId()) && !user.isAdmin()) {
                        comment.setExtAtt2(user.getName());
                    }

                    comment.setModuleType(ModuleType.collaboration.getKey());
                    comment.setPid(0L);
                    comment.setPushMessage(false);
                    comment = this.saveOrUpdateComment(comment);
                    this.saveAttDatas(user, summary, affair, comment.getId());
                    _workitemId = affair.getSubObjectId();
                    DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
                    DateSharedWithWorkflowEngineThreadLocal.setFinishWorkitemOpinionId(comment.getId(), false, comment.getContent(), 2, false);
                    ContentUtil.colStepStop(_workitemId);
                    summary = (ColSummary)DateSharedWithWorkflowEngineThreadLocal.getColSummary();
                    this.superviseManager.updateStatusBySummaryIdAndType(superviseState.supervised, summary.getId(), EntityType.summary);
                    if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                        try {
                            List<Comment> commentList = this.commentManager.getCommentList(ModuleType.collaboration, affair.getObjectId());
                            this.formManager.updateDataState(summary, affair, ColHandleType.stepStop, commentList);
                        } catch (Exception var19) {
                            LOG.error("更新表单相关信息异常", var19);
                        }
                    }

                    if (!user.isAdministrator() && !user.isGroupAdmin() && !user.isSystemAdmin()) {
                        this.processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.stepStop, comment.getId(), new String[0]);
                    } else {
                        this.processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), 1L, ProcessLogAction.stepStop, comment.getId(), new String[0]);
                    }

                    this.appLogManager.insertLog(user, AppLogAction.Coll_Flow_Stop, new String[]{user.getName(), summary.getSubject()});
                    CollaborationStopEvent stopEvent = new CollaborationStopEvent(this);
                    stopEvent.setSummaryId(summary.getId());
                    stopEvent.setUserId(user.getId());
                    stopEvent.setAffair(affair);
                    EventDispatcher.fireEvent(stopEvent);
                    CtpAffair sendAffair = this.affairManager.getSenderAffair(summary.getId());
                    if (sendAffair.getSubState() == SubStateEnum.col_pending_specialBacked.getKey() || sendAffair.getSubState() == SubStateEnum.col_pending_specialBackToSenderCancel.getKey()) {
                        sendAffair.setState(StateEnum.col_sent.getKey());
                        sendAffair.setUpdateDate(new Date());
                        this.affairManager.updateAffair(sendAffair);
                    }

                    this.affairManager.updateAffairAnalyzeData(affair);
                    ColUtil.addOneReplyCounts(summary);
                    this.updateColSummary(summary);
                    return null;
                }

                String msg = ColUtil.getErrorMsgByAffair(affair);
                var10 = msg;
            } catch (Exception var21) {
                LOG.error("", var21);
                throw new BusinessException(var21);
            } finally {
                this.wapi.releaseWorkFlowProcessLock(processId, String.valueOf(AppContext.currentUserId()));
            }

            return var10;
        }
    }

    private Comment saveOrUpdateComment(Comment c) throws BusinessException {
        Comment comment = c;
        c.setPushMessage(false);
        if (c.getId() == null) {
            comment = this.commentManager.insertComment(c);
        } else {
            this.commentManager.updateComment(c);
        }

        return comment;
    }

    public String transStepBack(Map<String, Object> tempMap) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String _summaryId = (String)tempMap.get("summaryId");
        String _affairId = (String)tempMap.get("affairId");
        String targetNodeId = (String)tempMap.get("targetNodeId");
        String isWFTrace = (String)tempMap.get("isWFTrace");
        targetNodeId = "".equals(targetNodeId) ? null : targetNodeId;
        Long summaryId = Long.parseLong(_summaryId);
        Long affairId = Long.parseLong(_affairId);
        Comment comment = new Comment();
        CtpAffair affair = this.affairManager.get(affairId);
        int state = affair.getState();
        if (state != StateEnum.col_pending.key()) {
            String msg = "";
            if (state == StateEnum.col_stepBack.key()) {
                msg = "协同《" + affair.getSubject() + "》已经被回退";
            } else if (state == StateEnum.col_takeBack.key()) {
                msg = "协同《" + affair.getSubject() + "》已经被取回";
            } else {
                msg = "协同《" + affair.getSubject() + "》已经被撤销";
            }

            return msg;
        } else {
            ColSummary summary = this.getColSummaryById(summaryId);
            if (summary == null) {
                return null;
            } else {
                try {
                    boolean canDeal = ColUtil.checkAgent(affair, summary, true);
                    if (!canDeal) {
                        return null;
                    }
                } catch (Exception var25) {
                    LOG.error("", var25);
                }

                String var17;
                try {
                    AffairData affairData = ColUtil.getAffairData(summary);
                    affairData.getBusinessData().put("CURRENT_OPERATE_TRACK_FLOW", isWFTrace);
                    affairData.getBusinessData().put("ColSummary", summary);
                    affairData.getBusinessData().put("CURRENT_OPERATE_AFFAIR_ID", affairId);
                    affairData.getBusinessData().put("CURRENT_OPERATE_SUMMARY_ID", summaryId);
                    List<CtpAffair> aLLAvailabilityAffairList = this.affairManager.getValidAffairs(ApplicationCategoryEnum.collaboration, summary.getId());
                    String[] result = ContentUtil.stepBack(affairData, affair, targetNodeId);
                    ColUtil.updateCurrentNodesInfo(summary);
                    ColUtil.addOneReplyCounts(summary);
                    this.updateColSummary(summary);
                    StringBuffer info;
                    if ("-2".equals(result[0])) {
                        info = new StringBuffer();
                        info.append("《").append(affair.getSubject()).append("》").append("\n");
                        var17 = ResourceUtil.getString("collaboration.takeBack.alert", info.toString());
                        return var17;
                    }

                    if (!"-1".equals(result[0])) {
                        boolean backToSender = "1".equals(result[0]);
                        ParamUtil.getJsonDomainToBean("comment_deal", comment);
                        if (backToSender) {
                            this.stepBackSummary(user.getId(), summary.getId(), StateEnum.col_stepBack.key());
                            this.createRepealData2BeginNode(affair, summary, aLLAvailabilityAffairList, workflowTrackType.step_back_repeal, isWFTrace);
                            this.do4Repeal(user.getId(), comment.getContent(), summary.getId(), aLLAvailabilityAffairList, true);
                        }

                        if (!"0".equals(result[0]) && !backToSender) {
                            var17 = "回退失败";
                            return var17;
                        }

                        comment.setModuleId(summary.getId());
                        comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
                        comment.setCreateId(affair.getMemberId());
                        comment.setAffairId(affair.getId());
                        comment.setExtAtt3("collaboration.dealAttitude.rollback");
                        if (!user.getId().equals(affair.getMemberId())) {
                            comment.setExtAtt2(user.getName());
                        }

                        comment.setModuleType(ModuleType.collaboration.getKey());
                        comment.setPid(0L);
                        comment.setPushMessage(false);
                        comment = this.saveOrUpdateComment(comment);
                        if (backToSender) {
                            this.createRepealData2BeginNode(affair, summary, aLLAvailabilityAffairList, workflowTrackType.step_back_repeal, isWFTrace);
                            this.iSignatureHtmlManager.deleteAllByDocumentId(summary.getId());
                        }

                        this.saveAttDatas(user, summary, affair, comment.getId());
                        this.affairManager.updateAffairAnalyzeData(affair);
                        CollaborationStepBackEvent backEvent = new CollaborationStepBackEvent(this);
                        backEvent.setSummaryId(summary.getId());
                        EventDispatcher.fireEvent(backEvent);
                        List<CtpAffair> trackingAffairLists = this.affairManager.getValidTrackAffairs(summary.getId());
                        this.colMessageManager.stepBackMessage(trackingAffairLists, affair, summaryId, comment, "1".equals(isWFTrace), backToSender);
                        this.processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.stepBack, comment.getId(), new String[]{result[1]});
                        this.appLogManager.insertLog(user, AppLogAction.Coll_Step_Back, new String[]{user.getName(), summary.getSubject()});
                        if (AppContext.hasPlugin("index")) {
                            if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                                this.indexManager.update(summaryId, ApplicationCategoryEnum.form.getKey());
                            } else {
                                this.indexManager.update(summaryId, ApplicationCategoryEnum.collaboration.getKey());
                            }
                        }

                        List commentList;
                        if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                            try {
                                commentList = this.commentManager.getCommentAllByModuleId(ModuleType.collaboration, affair.getObjectId());
                                this.formManager.updateDataState(summary, affair, "1".equals(result[0]) ? ColHandleType.repeal : ColHandleType.stepBack, commentList);
                            } catch (Exception var24) {
                                LOG.error("更新表单相关信息异常", var24);
                                throw new BusinessException("更新表单相关信息异常", var24);
                            }
                        }

                        commentList = null;
                        return null;
                    }

                    info = new StringBuffer();
                    info.append("《").append(affair.getSubject()).append("》").append("\n");
                    var17 = ResourceUtil.getString("collaboration.takeBack.alert.dimission", info.toString());
                } finally {
                    this.wapi.releaseWorkFlowProcessLock(summary.getProcessId(), String.valueOf(AppContext.currentUserId()));
                }

                return var17;
            }
        }
    }

    private void createRepealData2BeginNode(CtpAffair affair, ColSummary summary, List<CtpAffair> aLLAvailabilityAffairList, workflowTrackType trackType, String _trackWorkflowType) throws BusinessException {
        List<CtpAffair> traceAffairs = new ArrayList();
        Iterator var7 = aLLAvailabilityAffairList.iterator();

        while(true) {
            CtpAffair aff;
            do {
                if (!var7.hasNext()) {
                    CtpTemplate template = null;
                    if (summary.getTempleteId() != null) {
                        template = this.templateManager.getCtpTemplate(summary.getTempleteId());
                    }

                    this.colTraceWorkflowManager.createStepBackTrackDataToBegin(summary, affair, traceAffairs, template, trackType, _trackWorkflowType);
                    return;
                }

                aff = (CtpAffair)var7.next();
            } while(!Integer.valueOf(StateEnum.col_done.key()).equals(aff.getState()) && (!Integer.valueOf(StateEnum.col_pending.key()).equals(aff.getState()) || !Integer.valueOf(SubStateEnum.col_pending_ZCDB.key()).equals(aff.getSubState())) && (!aff.getId().equals(affair.getId()) || Integer.valueOf(StateEnum.col_sent.key()).equals(aff.getState()) || Integer.valueOf(StateEnum.col_waitSend.key()).equals(aff.getState())));

            traceAffairs.add(aff);
        }
    }

    public void transReMeToReGo(WorkflowBpmContext context) throws BusinessException {
        long summaryId = 0L;
        ColSummary summary = (ColSummary)context.getAppObject();
        if (summary != null) {
            summaryId = summary.getId();
        }

        List<CtpAffair> allAvailableAffairs = this.affairManager.getValidAffairs(ApplicationCategoryEnum.collaboration, summaryId);
        CtpAffair stepBackAffair = (CtpAffair)context.getBusinessData().get("_ReMeToReGo_stepBackAffair");
        Long currentAffairId = (Long)context.getBusinessData().get("CURRENT_OPERATE_AFFAIR_ID");
        CtpAffair currentAffair = null;
        if (allAvailableAffairs != null) {
            for(int i = 0; i < allAvailableAffairs.size(); ++i) {
                CtpAffair affair = (CtpAffair)allAvailableAffairs.get(i);
                if (affair.getId().equals(currentAffairId)) {
                    currentAffair = affair;
                }
            }
        }

        if ("start".equals(context.getCurrentActivityId())) {
            CtpAffair sendAffair = null;
            if (allAvailableAffairs != null) {
                for(int i = 0; i < allAvailableAffairs.size(); ++i) {
                    CtpAffair affair = (CtpAffair)allAvailableAffairs.get(i);
                    if (affair.getState() == StateEnum.col_sent.key() || affair.getState() == StateEnum.col_waitSend.key()) {
                        sendAffair = affair;
                    }

                    if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
                        QuartzHolder.deleteQuartzJob("Remind" + affair.getId());
                        QuartzHolder.deleteQuartzJob("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
                    }

                    if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
                        QuartzHolder.deleteQuartzJob("DeadLine" + affair.getId());
                        QuartzHolder.deleteQuartzJob("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
                    }

                    ColUtil.deleteCycleRemindQuartzJob(affair, false);
                }
            }

            long userId = Strings.isNotBlank(context.getCurrentUserId()) ? Long.valueOf(context.getCurrentUserId()) : 0L;
            this.do4Repeal(userId, "", summaryId, allAvailableAffairs, false);
            if (String.valueOf(MainbodyType.FORM.getKey()).equals(sendAffair.getBodyType())) {
                try {
                    FormRelationManager formRelationManager = (FormRelationManager)AppContext.getBean("formRelationManager");
                    formRelationManager.RelationAuthorityBySummaryId(summaryId, ModuleType.collaboration.getKey());
                    if (null != sendAffair) {
                        AffairUtil.setIsRelationAuthority(sendAffair, false);
                        DBAgent.update(sendAffair);
                    }
                } catch (Exception var13) {
                    LOG.error("更新表单相关信息异常", var13);
                }
            }

            workflowTrackType trackType = workflowTrackType.special_step_back_repeal;
            this.createRepealData2BeginNode(stepBackAffair, summary, allAvailableAffairs, trackType, "1");
            this.iSignatureHtmlManager.deleteAllByDocumentId(summary.getId());
        }

        this.colMessageManager.reMeToRegoMessage(currentAffair);
        long activityId = "start".equals(context.getCurrentActivityId()) ? -1L : Long.parseLong(context.getCurrentActivityId());
        ProcessLogAction action = "start".equals(context.getCurrentActivityId()) ? ProcessLogAction.colStepBackReMeToReGo4Send : ProcessLogAction.colStepBackReMeToReGo;
        this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(context.getProcessId()), activityId, action, new String[0]);
    }

    private void do4Repeal(long userId, String repealComment, long summaryId, List<CtpAffair> aLLAvailabilityAffairList, boolean isFireEvent) throws BusinessException {
        List<Long> ids = new ArrayList();
        Iterator var9 = aLLAvailabilityAffairList.iterator();

        while(true) {
            CtpAffair affair0;
            do {
                if (!var9.hasNext()) {
                    this.trackManager.deleteTrackMembersByAffairIds(ids);
                    CtpAffair sendAffair = this.affairManager.getSenderAffair(summaryId);
                    ids.add(sendAffair.getId());
                    if (AppContext.hasPlugin("doc")) {
                        this.docApi.deleteDocResources(userId, ids);
                    }

                    if (isFireEvent) {
                        CollaborationCancelEvent cancelEvent = new CollaborationCancelEvent(this);
                        cancelEvent.setSummaryId(summaryId);
                        cancelEvent.setUserId(userId);
                        cancelEvent.setMessage(repealComment);
                        EventDispatcher.fireEvent(cancelEvent);
                    }

                    this.superviseManager.updateStatus2Cancel(summaryId);
                    return;
                }

                affair0 = (CtpAffair)var9.next();
            } while((Integer.valueOf(StateEnum.col_sent.getKey()).equals(affair0.getState()) || Integer.valueOf(StateEnum.col_waitSend.getKey()).equals(affair0.getState())) && !affair0.isDelete());

            DateSharedWithWorkflowEngineThreadLocal.addToAllStepBackAffectAffairMap(affair0.getMemberId(), affair0.getId());
            ids.add(affair0.getId());
        }
    }

    public int stepBackSummary(long userId, long summaryId, int from) throws BusinessException {
        ColSummary summary = this.getColSummaryById(summaryId);
        summary.setCaseId((Long)null);
        summary.setState(flowState.cancel.ordinal());
        ColUtil.updateCurrentNodesInfo(summary);
        this.updateColSummary(summary);
        CtpAffair senderAffair = this.affairManager.getSenderAffair(summaryId);
        if (senderAffair != null) {
            senderAffair.setState(StateEnum.col_waitSend.key());
            senderAffair.setSubState(SubStateEnum.col_waitSend_stepBack.key());
            senderAffair.setArchiveId((Long)null);
            senderAffair.setDelete(false);
            this.affairManager.updateAffair(senderAffair);
            this.affairManager.updateAffairsState2Cancel(summaryId);
        }

        return 0;
    }

    public int getColCount(long memberId, int state, List<Long> templeteIds) throws BusinessException {
        return this.colDao.getColCount(state, memberId, templeteIds);
    }

    public List<SuperviseModelVO> getColSuperviseModelList(FlipInfo filpInfo, Map<String, String> map) {
        return this.colDao.getColSuperviseModelList(filpInfo, map);
    }

    public String getTrackInfosToString(TrackAjaxTranObj obj) throws BusinessException {
        String objectId = obj.getObjectId();
        List<CtpTrackMember> boList = this.trackManager.getTrackMembers(objectId);
        StringBuffer memberInfo = new StringBuffer();
        String mInfo = "";
        if (boList.size() > 0) {
            Iterator var6 = boList.iterator();

            while(var6.hasNext()) {
                CtpTrackMember member = (CtpTrackMember)var6.next();
                Long mId = member.getTrackMemberId();
                memberInfo.append("Member|" + mId + ",");
            }

            mInfo = memberInfo.toString();
            if (mInfo.length() > 0) {
                mInfo = mInfo.substring(0, mInfo.length() - 1);
            }
        }

        return mInfo;
    }

    private List<ProjectBO> getProjectList(NewCollTranVO vobj, Long projectId) throws BusinessException {
        if (null == this.projectApi) {
            return null;
        } else {
            List<ProjectBO> projectList = this.projectApi.findProjectsByMemberId(vobj.getUser().getId());
            boolean flag = true;
            ProjectBO p;
            if (projectId != null) {
                p = this.projectApi.getProject(projectId);
                if (p != null && p.getProjectState() != ProjectBO.STATE_DELETE.intValue()) {
                    if (projectList == null) {
                        projectList = new ArrayList();
                        ((List)projectList).add(p);
                    } else if (!((List)projectList).contains(p)) {
                        ((List)projectList).add(p);
                    }
                } else {
                    projectId = null;
                    flag = false;
                }
            }

            if (null == projectId && null != vobj.getProjectId() && Strings.isNotBlank(vobj.getProjectId().toString())) {
                projectId = vobj.getProjectId();
                p = this.projectApi.getProject(vobj.getProjectId());
                if (p != null && p.getProjectState() != ProjectBO.STATE_DELETE.intValue()) {
                    if (projectList == null) {
                        projectList = new ArrayList();
                        ((List)projectList).add(p);
                    } else if (!((List)projectList).contains(p)) {
                        ((List)projectList).add(p);
                    }
                } else {
                    projectId = null;
                }
            }

            if (flag) {
                vobj.setProjectId(projectId);
            } else {
                vobj.setProjectId((Long)null);
                vobj.getTemplate().setProjectId((Long)null);
            }

            vobj.setProjectList((List)projectList);
            return (List)projectList;
        }
    }

    private boolean isParentSystemTemplete(Long templeteId) throws BusinessException {
        CtpTemplate t = this.getParentSystemTemplete(templeteId);
        if (t == null) {
            return false;
        } else {
            return t.isSystem();
        }
    }

    private CtpTemplate getParentSystemTemplete(Long templeteId) throws BusinessException {
        if (templeteId == null) {
            return null;
        } else {
            boolean needQueryParent = true;

            CtpTemplate t;
            for(t = null; needQueryParent; templeteId = t.getFormParentid()) {
                t = this.templateManager.getCtpTemplate(templeteId);
                if (t == null) {
                    needQueryParent = false;
                    return null;
                }

                if (t.isSystem()) {
                    needQueryParent = false;
                    return t;
                }

                if (t.getFormParentid() == null) {
                    needQueryParent = false;
                    return null;
                }
            }

            return t;
        }
    }

    public List<ColSummaryVO> getMyCollDeadlineNotEmpty(Map<String, Object> tempMap) throws BusinessException {
        List<ColSummaryVO> colList = this.colDao.getMyCollDeadlineNotEmpty(tempMap);
        return colList;
    }

    public void updateTempleteHistory(Long id) throws BusinessException {
        this.collaborationTemplateManager.updateTempleteHistory(id);
    }

    public String getPigeonholeRight(List<String> collIds) throws BusinessException {
        return this.getPigeonholeRightForM3(collIds, false);
    }

    public String getPigeonholeRightForM3(List<String> collIds, boolean fromM3) throws BusinessException {
        StringBuilder result = new StringBuilder();
        CtpAffair affair = null;
        ColSummary summary = null;
        List<String> permissions = null;
        List<String> actions = null;
        int count = 1;
        Iterator var9 = collIds.iterator();

        while(true) {
            while(var9.hasNext()) {
                String id = (String)var9.next();
                affair = this.getAffairById(Long.parseLong(id));
                summary = this.getSummaryById(affair.getObjectId());
                long accountId = ColUtil.getFlowPermAccountId(AppContext.currentAccountId(), summary);
                actions = this.permissionManager.getActionList(EnumNameEnum.col_flow_perm_policy.name(), affair.getNodePolicy(), accountId);
                if ((actions.contains("Pigeonhole") || actions.contains("Archive")) && summary.getCanArchive() != null && summary.getCanArchive()) {
                    permissions = this.permissionManager.getRequiredOpinionPermissions(EnumNameEnum.col_flow_perm_policy.name(), accountId);
                    if (affair.getState() == StateEnum.col_pending.getKey() && permissions.contains(affair.getNodePolicy())) {
                        result.append("以下事项要求意见不能为空，不能直接归档或删除。").append(summary.getSubject()).append("<br>");
                    }
                } else if (fromM3) {
                    result.append(count + ".").append(ResourceUtil.getString("collaboration.pigeonhole.notallow.note", summary.getSubject())).append("<br>");
                    ++count;
                } else {
                    result.append(ResourceUtil.getString("collaboration.pigeonhole.notallow.note", summary.getSubject())).append("\r\n");
                }
            }

            return result.toString();
        }
    }

    public String getIsSamePigeonhole(List<String> collIds, Long destFolderId) throws BusinessException {
        StringBuilder result = new StringBuilder();
        CtpAffair affair = null;
        Iterator var5 = collIds.iterator();

        while(var5.hasNext()) {
            String id = (String)var5.next();
            affair = this.getAffairById(Long.parseLong(id));
            if (affair != null) {
                List<Long> sourceIds = new ArrayList();
                sourceIds.add(affair.getObjectId());
                int _key = ApplicationCategoryEnum.collaboration.getKey();
                if (affair.getBodyType().equals(String.valueOf(MainbodyType.FORM.getKey()))) {
                    _key = ApplicationCategoryEnum.form.getKey();
                }

                if (this.docApi.hasSamePigeonhole(destFolderId, sourceIds, _key)) {
                    result.append(ResourceUtil.getString("collaboration.same.pigeonhole.note", affair.getSubject()));
                }
            }
        }

        return result.toString();
    }

    public String transPigeonhole(ColSummary summary, CtpAffair affair, Long destFolderId, String type) throws BusinessException {
        boolean hasAttachment = ColUtil.isHasAttachments(summary);
        StringBuilder result = new StringBuilder();
        User user = AppContext.getCurrentUser();
        List<Boolean> hasAttachments = new ArrayList();
        List<Long> collIdLongs = new ArrayList();
        collIdLongs.add(affair.getId());
        hasAttachments.add(hasAttachment);
        boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType());
        int app = ApplicationCategoryEnum.collaboration.key();
        if (isForm) {
            app = ApplicationCategoryEnum.form.key();
        }

        List<Long> results = this.docApi.pigeonhole(AppContext.currentUserId(), app, collIdLongs, hasAttachments, (Long)null, destFolderId, PigeonholeType.edoc_dept.ordinal());
        if (results != null && results.size() == 1) {
            DocResourceBO res = this.docApi.getDocResource((Long)results.get(0));
            affair.setArchiveId(res.getParentFrId());
            String forderName = this.docApi.getDocResourceName(res.getParentFrId());
            this.appLogManager.insertLog(user, AppLogAction.Coll_Pigeonhole, new String[]{user.getName(), res.getFrName(), forderName});
            this.affairDao.update(affair);
        }

        return result.toString();
    }

    public String transPigeonhole(Long affairId, Long destFolderId, String type) throws BusinessException {
        User user = AppContext.getCurrentUser();
        List<Boolean> hasAttachments = new ArrayList();
        List<Long> collIdLongs = new ArrayList();
        collIdLongs.add(affairId);
        CtpAffair affair = this.getAffairById(affairId);
        ColSummary summary = this.getSummaryById(affair.getObjectId());
        hasAttachments.add(ColUtil.isHasAttachments(summary));
        boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType());
        int app = ApplicationCategoryEnum.collaboration.key();
        if (isForm) {
            app = ApplicationCategoryEnum.form.key();
        }

        List<Long> results = this.docApi.pigeonhole(AppContext.currentUserId(), app, collIdLongs, hasAttachments, (Long)null, destFolderId, (Integer)null);
        affair.setArchiveId((Long)results.get(0));
        DocResourceBO res = this.docApi.getDocResource((Long)results.get(0));
        String forderName = this.docApi.getDocResourceName(res.getParentFrId());
        this.appLogManager.insertLog(user, AppLogAction.Coll_Pigeonhole, new String[]{user.getName(), res.getFrName(), forderName});
        affair.setArchiveId(res.getParentFrId());
        this.affairDao.update(affair);
        if ("pending".equals(type)) {
            Comment c = this.getNullDealComment(affair.getId(), affair.getObjectId());
            c.setExtAtt3(CommentExtAtt3Enum.pighole_pending_skip.getI18nLabel());
            DateSharedWithWorkflowEngineThreadLocal.setIsNeedAutoSkip(false);
            Map<String, Object> param = new HashMap();
            param.put("subState", String.valueOf(SubStateEnum.col_done_pighone.getKey()));
            this.transFinishWorkItemPublic(affairId, c, param);
        }

        return "";
    }

    public String transPigeonholeDeleteStepBackDoc(List<String> collIds, Long destFolderId) throws BusinessException {
        StringBuilder result = new StringBuilder();
        if (CollectionUtils.isEmpty(collIds)) {
            return result.toString();
        } else {
            List<Long> needDeleteDocs = new ArrayList();
            Map<Long, List<Long>> objectDocMap = new HashMap();
            List<String> appIds = new ArrayList();
            appIds.add(String.valueOf(ApplicationCategoryEnum.collaboration.getKey()));
            List<DocResourceBO> reses = this.docApi.findDocResourcesByType(destFolderId, appIds);
            CtpAffair affairPig;
            if (!CollectionUtils.isEmpty(reses)) {
                affairPig = null;
                List<Long> affairIds = null;
                Iterator var10 = reses.iterator();

                while(var10.hasNext()) {
                    DocResourceBO docResourcePO = (DocResourceBO)var10.next();
                    affairPig = this.affairManager.get(docResourcePO.getSourceId());
                    if (affairPig != null && affairPig.getState() == StateEnum.col_stepBack.getKey()) {
                        affairIds = (List)objectDocMap.get(affairPig.getObjectId());
                        if (affairIds == null) {
                            affairIds = new ArrayList();
                        }

                        ((List)affairIds).add(affairPig.getId());
                        objectDocMap.put(affairPig.getObjectId(), affairIds);
                    }
                }
            }

            affairPig = null;
            Iterator var12 = collIds.iterator();

            while(var12.hasNext()) {
                String id = (String)var12.next();
                affairPig = this.getAffairById(Long.parseLong(id));
                if (objectDocMap.get(affairPig.getObjectId()) != null) {
                    needDeleteDocs.addAll((Collection)objectDocMap.get(affairPig.getObjectId()));
                }
            }

            if (!CollectionUtils.isEmpty(needDeleteDocs)) {
                this.docApi.deleteDocResources(AppContext.getCurrentUser().getId(), needDeleteDocs);
            }

            return result.toString();
        }
    }

    private Comment getNullDealComment(Long affairId, Long summaryId) {
        Comment comment = new Comment();
        comment.setId(UUIDLong.longUUID());
        comment.setAffairId(affairId);
        comment.setModuleId(summaryId);
        comment.setCreateId(AppContext.currentUserId());
        comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
        comment.setClevel(1);
        comment.setCtype(CommentType.comment.getKey());
        comment.setHidden(false);
        comment.setContent("");
        comment.setModuleType(ApplicationCategoryEnum.collaboration.getKey());
        comment.setPath("001");
        comment.setPid(0L);
        return comment;
    }

    public void transCancelTrack(TrackAjaxTranObj obj) throws BusinessException {
        Object obj1 = obj.getAffairId();
        if (obj1 != null) {
            String[] affairIds = obj1.toString().split("[,]");

            for(int i = 0; i < affairIds.length; ++i) {
                Map<String, Object> columnValue = new HashMap();
                columnValue.put("track", 0);
                Long affairId = Long.parseLong(affairIds[i]);
                this.affairManager.update(affairId, columnValue);
                this.trackManager.deleteTrackMembers((Long)null, affairId);
            }
        }

    }

    public ModelAndView getforwordMail(Map params) throws BusinessException {
        User user = AppContext.getCurrentUser();

        try {
            boolean hasDefaultMbc = this.webmailApi.hasDefaultMbc(user.getId());
            if (!hasDefaultMbc) {
                ModelAndView mav = new ModelAndView("webmail/error");
                mav.addObject("errorMsg", "2");
                mav.addObject("errorUrls", "?method=list&jsp=set");
                return mav;
            }
        } catch (Exception var17) {
            LOG.error("调用邮件接口判断当前用户是否有邮箱设置：", var17);
        }

        Long summaryId = Long.parseLong(String.valueOf(params.get("summaryId")));
        ColSummary summary = this.getColSummaryById(summaryId);
        String subject = summary.getSubject();
        List<Attachment> atts = this.attachmentManager.getByReference(summaryId, summaryId);
        CtpAffair senderAffair = this.affairManager.getSenderAffair(summaryId);
        String _rightId = ContentUtil.findRightIdbyAffairIdOrTemplateId(senderAffair, summary.getTempleteId());
        List<CtpContentAll> contentList = this.ctpMainbodyManager.getContentList(ModuleType.collaboration, summary.getId(), _rightId);
        CtpContentAll ctpContent = (CtpContentAll)contentList.get(0);
        Date createDate = ctpContent.getCreateDate();
        String bodyType = summary.getBodyType();
        String bodyContent = "";
        if (String.valueOf(MainbodyType.FORM.getKey()).equals(bodyType)) {
            bodyContent = MainbodyService.getInstance().getContentHTML(ctpContent.getModuleType(), ctpContent.getModuleId());
        } else if (String.valueOf(MainbodyType.HTML.getKey()).equals(bodyType)) {
            bodyContent = ctpContent.getContent();
        } else if (String.valueOf(MainbodyType.WpsWord.getKey()).equals(bodyType) || String.valueOf(MainbodyType.OfficeWord.getKey()).equals(bodyType) || String.valueOf(MainbodyType.OfficeExcel.getKey()).equals(bodyType) || String.valueOf(MainbodyType.WpsExcel.getKey()).equals(bodyType) || String.valueOf(MainbodyType.Pdf.getKey()).equals(bodyType)) {
            File file = null;

            try {
                file = this.fileManager.getStandardOffice(CoderFactory.getInstance().decryptFileToTemp(this.fileManager.getFile(ctpContent.getContentDataId()).getAbsolutePath()));
                V3XFile f = this.fileManager.save(file, ApplicationCategoryEnum.mail, subject + "." + Convertor.getSufficName(bodyType), createDate, false);
                atts.add(new Attachment(f, ApplicationCategoryEnum.mail, ATTACHMENT_TYPE.FILE));
            } catch (Exception var16) {
                LOG.error("协同转发为邮件错误 [summaryId = " + summaryId + "]", var16);
            }
        }

        ModelAndView mv = this.webmailApi.forwardMail(summaryId, subject, bodyContent, atts);
        return mv;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public void updateAffairIdentifierForRelationAuth(Map param) throws BusinessException {
        List<CtpAffair> affairs = new ArrayList();
        List<String> ids = (List)param.get("affairIds");
        Boolean flag = (Boolean)param.get("flag");
        Iterator var5 = ids.iterator();

        while(var5.hasNext()) {
            String _id = (String)var5.next();
            if (!StringUtil.checkNull(_id)) {
                Long affairId = Long.parseLong(_id);
                CtpAffair ctpAffair = this.getAffairById(affairId);
                AffairUtil.setIsRelationAuthority(ctpAffair, flag);
                affairs.add(ctpAffair);
            }
        }

        DBAgent.updateAll(affairs);
    }

    public List<AttachmentVO> getAttachmentListBySummaryId(Long summaryId, Long memberId) throws BusinessException {
        List<Attachment> tempattachments = null;
        List<Attachment> attachments = new ArrayList();
        List<AttachmentVO> attachmentVOs = new ArrayList();
        List<Long> attmentIds = new ArrayList();
        AttachmentVO vo = null;
        HttpServletRequest request = AppContext.getRawRequest();
        String formAttrId = request.getParameter("formAttrId");
        List formAttrIds = new ArrayList();
        String attmentContent = request.getParameter("attmentList");
        List<String> attmentList = new ArrayList();
        new ArrayList();
        if (Strings.isNotBlank(attmentContent) && !"null".equals(attmentContent)) {
            List<String> _attmentList = Arrays.asList(attmentContent.split(","));

            for(int a = _attmentList.size() - 1; a > -1; --a) {
                if (!attmentList.contains(_attmentList.get(a))) {
                    attmentList.add(_attmentList.get(a));
                }
            }
        }

        if (Strings.isNotBlank(formAttrId)) {
            formAttrIds = Arrays.asList(formAttrId.split(","));
        }

        ColSummary colSummary = this.getSummaryById(summaryId);
        tempattachments = this.attachmentManager.getByReference(summaryId);
        AppContext.putThreadContext("THREAD_CTX_NOT_HIDE_TO_ID_KEY", colSummary.getStartMemberId());
        Iterator var15 = tempattachments.iterator();

        Attachment attachment;
        while(var15.hasNext()) {
            attachment = (Attachment)var15.next();
            if (attachment.getType() == 0) {
                attachments.add(attachment);
            }
        }

        Iterator var18;
        List collectMap;
        if (attachments != null && attachments.size() > 0) {
            boolean isHistoryFlag = "true".equals(request.getParameter("isHistoryFlag"));
            collectMap = this.commentManager.getCommentAllByModuleId(ModuleType.collaboration, summaryId, isHistoryFlag);
            new ArrayList();
            var18 = attachments.iterator();

            label198:
            while(true) {

                String fromType;
                while(true) {
                    Comment curComment;
                    V3xOrgMember member;
                    do {
                        while(true) {
                            if (!var18.hasNext()) {
                                break label198;
                            }

                            attachment = (Attachment)var18.next();
                            vo = new AttachmentVO();
                            this.createAttachmentVO(vo, attachment);
                            Long commentId = attachment.getSubReference();
                            curComment = null;
                            Iterator var22 = collectMap.iterator();

                            while(var22.hasNext()) {
                                Comment comment = (Comment)var22.next();
                                if (comment.getId() == commentId) {
                                    curComment = comment;
                                    break;
                                }
                            }

                            if (curComment != null) {
                                break;
                            }

                            if (summaryId.equals(attachment.getSubReference())) {
                                Date attaDate = attachment.getCreatedate();
                                Date colDate = colSummary.getCreateDate();
                                if (attaDate.getTime() < colDate.getTime() + 2000L) {
                                    try {
                                        member = this.orgManager.getMemberById(colSummary.getStartMemberId());
                                        vo.setUserName(member.getName());
                                    } catch (Exception var31) {
                                        LOG.error("", var31);
                                    }

                                    vo.setFromType(ResourceUtil.getString("collaboration.att.titleArea"));
                                } else {
                                    V3XFile file = this.fileManager.getV3XFile(attachment.getFileUrl());
                                    String name = "";
                                    if (file != null) {
                                        try {
                                            member = this.orgManager.getMemberById(file.getCreateMember());
                                            name = member.getName();
                                        } catch (Exception var30) {
                                            LOG.error("", var30);
                                        }
                                    }

                                    vo.setUserName(name);
                                    vo.setFromType(ResourceUtil.getString("collaboration.att.titleArea"));
                                }

                                attmentIds.add(attachment.getFileUrl());
                                attachmentVOs.add(vo);
                            } else if ("100".equals(attachment.getSubReference().toString())) {
                                V3XFile file = this.fileManager.getV3XFile(attachment.getFileUrl());
                                String name = "";
                                if (file != null) {
                                    try {
                                        member = this.orgManager.getMemberById(file.getCreateMember());
                                        name = member.getName();
                                    } catch (Exception var29) {
                                        LOG.error("", var29);
                                    }
                                }

                                vo.setUserName(name);
                                vo.setFromType(ResourceUtil.getString("collaboration.att.form"));
                                attmentIds.add(attachment.getFileUrl());
                                attachmentVOs.add(vo);
                            }
                        }
                    } while(!curComment.isCanView());

                    String agentName = curComment.getExtAtt2();
                    Long createId = curComment.getCreateId();
                    if (Strings.isNotBlank(agentName)) {
                        vo.setUserName(agentName);
                    } else {
                        member = this.orgManager.getMemberById(createId);
                        vo.setUserName(member.getName());
                    }

                    fromType = "";
                    Integer cType = curComment.getCtype();
                    if (cType == null) {
                        break;
                    }

                    int ct = cType;
                    if (ct != -2) {
                        if (curComment.getForwardCount() > 0) {
                            fromType = ResourceUtil.getString("collaboration.att.form");
                            break;
                        }

                        if (ct == -1) {
                            fromType = ResourceUtil.getString("collaboration.att.sender");
                            break;
                        }

                        if (ct == 1 || ct == 0) {
                            fromType = ResourceUtil.getString("collaboration.att.reply");
                        }
                        break;
                    }
                }

                attmentIds.add(attachment.getFileUrl());
                vo.setFromType(fromType);
                attachmentVOs.add(vo);
            }
        }

        int i;
        V3xOrgMember member;
        if (formAttrIds != null && ((List)formAttrIds).size() > 0 && "20".equals(colSummary.getBodyType())) {
            for(i = 0; i < ((List)formAttrIds).size(); ++i) {
                vo = new AttachmentVO();

                try {
                    attachment = this.attachmentManager.getAttachmentByFileURL(Long.valueOf(((List)formAttrIds).get(i).toString()));
                    this.createAttachmentVO(vo, attachment);
                    V3XFile file = this.fileManager.getV3XFile(Long.valueOf(((List)formAttrIds).get(i).toString()));
                    String name = "";
                    if (file != null) {
                        member = this.orgManager.getMemberById(file.getCreateMember());
                        name = member.getName();
                    }

                    vo.setUserName(name);
                    vo.setFromType(ResourceUtil.getString("collaboration.att.form"));
                    attmentIds.add(attachment.getFileUrl());
                    attachmentVOs.add(vo);
                } catch (Exception var28) {
                    LOG.error("获取表单中的附件报错！", var28);
                }
            }
        }

        if (attmentList != null && attmentList.size() > 0) {
            for(i = 0; i < attmentList.size(); ++i) {
                vo = new AttachmentVO();
                Long fileId = Long.parseLong((String)attmentList.get(i));
                if (fileId != null) {
                    try {
                        Attachment attachment3 = this.attachmentManager.getAttachmentByFileURL(fileId);
                        this.createAttachmentVO(vo, attachment3);
                        V3XFile file = this.fileManager.getV3XFile(fileId);
                        member = this.orgManager.getMemberById(file.getCreateMember());
                        String name = member.getName();
                        vo.setUserName(name);
                        vo.setFromType(ResourceUtil.getString("collaboration.att.form"));
                        attmentIds.add(attachment3.getFileUrl());
                        attachmentVOs.add(vo);
                    } catch (Exception var27) {
                        LOG.error("获取正文区域中的附件报错！", var27);
                    }
                }
            }
        }

        String collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
        if ("true".equals(collectFlag) && AppContext.hasPlugin("doc")) {
            collectMap = this.docApi.findFavorites(AppContext.currentUserId(), attmentIds);
            Map<Long, Long> doc2SourceId = new HashMap();
            var18 = collectMap.iterator();

            while(var18.hasNext()) {
                Map<String, Long> map = (Map)var18.next();
                doc2SourceId.put(map.get("sourceId"), map.get("id"));
            }

            var18 = attachmentVOs.iterator();

            while(var18.hasNext()) {
                AttachmentVO attachment2 = (AttachmentVO)var18.next();
                if (doc2SourceId.get(Long.valueOf(attachment2.getFileUrl())) != null) {
                    attachment2.setCollect(true);
                }
            }
        }

        Collections.sort(attachmentVOs, new AttachmentVO());
        return attachmentVOs;
    }

    private void createAttachmentVO(AttachmentVO vo, Attachment attachment) {
        vo.setUploadTime(attachment.getCreatedate());
        Long size = attachment.getSize() / 1024L + 1L;
        vo.setFileSize(size.toString());
        String extension = attachment.getExtension();
        vo.setFileType(extension);
        if (OfficeTransHelper.isOfficeTran() && OfficeTransHelper.allowTrans(attachment)) {
            vo.setCanLook(true);
        } else {
            vo.setCanLook(false);
        }

        String fileName = attachment.getFilename();
        if (!StringUtil.checkNull(extension)) {
            fileName = fileName.substring(0, fileName.lastIndexOf("."));
        }

        vo.setFileFullName(fileName);
        vo.setFileName(Strings.getSafeLimitLengthString(fileName, 25, "..."));
        vo.setFileUrl(String.valueOf(attachment.getFileUrl()));
        vo.setV(String.valueOf(attachment.getV()));
    }

    public Map checkTemplateCanUse(String strID) throws BusinessException {
        Map result = new HashMap();
        if (Strings.isNotBlank(strID)) {
            Long tId = Long.parseLong(strID);
            User user = AppContext.getCurrentUser();
            boolean outMsg = this.templateManager.isTemplateEnabled(tId, user.getId());
            if (!outMsg) {
                result.put("flag", "cannot");
                return result;
            }
        }

        result.put("flag", "can");
        return result;
    }

    @AjaxAccess
    public Map checkTemplate(Map<String, String> param) throws BusinessException {
        Long templateId = Long.valueOf((String)param.get("templateId"));
        Long formAppId = Strings.isBlank((String)param.get("formAppId")) ? null : Long.valueOf((String)param.get("formAppId"));
        Long formParentId = Strings.isBlank((String)param.get("formParentId")) ? null : Long.valueOf((String)param.get("formParentId"));
        Boolean isSystem = Boolean.valueOf(String.valueOf(param.get("isSystem")));
        Map result = new HashMap();
        User user = AppContext.getCurrentUser();
        boolean outMsg = this.templateManager.isTemplateEnabled(templateId, formAppId, formParentId, user.getId(), isSystem);
        if (!outMsg) {
            result.put("flag", "cannot");
            return result;
        } else {
            result.put("flag", "can");
            return result;
        }
    }

    public String getTemplateId(String tssemplateId) throws BusinessException {
        if (Strings.isNotBlank(tssemplateId)) {
            CtpTemplate template = this.templateManager.getCtpTemplate(Long.valueOf(tssemplateId));
            User user = AppContext.getCurrentUser();
            boolean outMsg = this.templateManager.isTemplateEnabled(template, user.getId());
            if (!outMsg) {
                return "{'wflag':'cannot'}";
            } else {
                return null != template && !"text".equals(template.getType()) && null != template.getWorkflowId() && !"".equals(template.getWorkflowId().toString()) ? "{'wflag':'" + template.getWorkflowId() + "'}" : "{'wflag':'isTextTemplate'}";
            }
        } else {
            return "{'wflag':'noworkflow'}";
        }
    }

    public String checkCollTemplate(String tssemplateId) throws BusinessException {
        if (Strings.isNotBlank(tssemplateId) && Strings.isDigits(tssemplateId)) {
            CtpTemplate template = this.templateManager.getCtpTemplate(Long.valueOf(tssemplateId));
            User user = AppContext.getCurrentUser();
            boolean outMsg = this.templateManager.isTemplateEnabled(template, user.getId());
            if (!outMsg) {
                return "cannot";
            } else {
                return null != template && !"text".equals(template.getType()) && null != template.getWorkflowId() && !"".equals(template.getWorkflowId().toString()) ? String.valueOf(template.getWorkflowId()) : "isTextTemplate";
            }
        } else {
            return "noworkflow";
        }
    }

    public String getTrackListByAffairId(TrackAjaxTranObj obj) throws BusinessException {
        String affairId = obj.getAffairId();
        List<CtpTrackMember> trackLisByAffairId = this.trackManager.getTrackMembers(Long.valueOf(affairId));
        String str = "";
        if (trackLisByAffairId.size() > 0) {
            for(int a = 0; a < trackLisByAffairId.size(); ++a) {
                str = str + "Member|" + ((CtpTrackMember)trackLisByAffairId.get(a)).getTrackMemberId() + ",";
            }

            if (str.length() > 0) {
                str = str.substring(0, str.length() - 1);
                return str;
            }
        }

        return str;
    }

    public void saveOpinionDraft(Long affairId, Long summaryId) throws BusinessException {
        try {
            Comment comment = new Comment();
            boolean isSave = true;
            ParamUtil.getJsonDomainToBean("comment_deal", comment);
            comment.setCtype(CommentType.draft.getKey());
            comment.setPushMessage(false);
            Map para = ParamUtil.getJsonDomain("comment_deal");
            if ("1".equals((String)para.get("praiseInput"))) {
                comment.setPraiseToSummary(true);
            }

            if (isSave) {
                Long commentId = comment.getId();
                String draftCommentId = (String)para.get("draftCommentId");
                if (Strings.isNotBlank(draftCommentId)) {
                    commentId = Long.valueOf((String)para.get("draftCommentId"));
                }

                this.commentManager.deleteComment(ModuleType.collaboration, commentId);
                this.attachmentManager.deleteByReference(comment.getModuleId(), comment.getId());
                this.commentManager.insertComment(comment);
            }

        } catch (Exception var8) {
            LOG.error("", var8);
            throw new BusinessException(var8);
        }
    }

    public Map checkVouchAudit(Map params) throws BusinessException {
        String summaryId = (String)params.get("summaryId");
        Map<String, Object> result = new HashMap();
        if (summaryId != null) {
            result.put("result", true);
            ColSummary colSummary = this.getColSummaryById(Long.parseLong(summaryId));
            if (!"20".equals(colSummary.getBodyType())) {
                result.put("isForm", false);
                return result;
            } else {
                result.put("isForm", true);
                Boolean isAudited = colSummary.isAudited();
                Integer isVouch = colSummary.getVouch();
                result.put("isVouch", isVouch);
                result.put("isAudited", isAudited);
                return result;
            }
        } else {
            result.put("result", false);
            return result;
        }
    }

    public String getDealExplain(Map params) {
        String affairId = (String)params.get("affairId");
        String templeteId = (String)params.get("templeteId");
        String processId = (String)params.get("processId");
        String desc = "";
        if (!Strings.isBlank(affairId) && !Strings.isBlank(templeteId) && !Strings.isBlank(processId)) {
            try {
                CtpAffair affair = this.affairManager.get(Long.valueOf(affairId));
                BPMProcess process = this.wapi.getBPMProcessForM1(processId);
                BPMActivity activity = process.getActivityById(affair.getActivityId().toString());
                desc = activity.getDesc();
                desc = desc.replaceAll("\r\n", "<br>").replaceAll("\r", "<br>").replaceAll("\n", "<br>").replaceAll("\\s", "&nbsp;");
            } catch (Exception var9) {
                LOG.error("", var9);
            }

            return desc;
        } else {
            return desc;
        }
    }

    public void transSetFinishedFlag(ColSummary summary) throws BusinessException {
        this.colDao.transSetFinishedFlag(summary);
    }

    public LockObject formAddLock(FormLockParam lockParam) throws BusinessException {
        LockObject obj = new LockObject();
        obj.setCanSubmit("1");
        if (lockParam != null) {
            Long formAppId = lockParam.getFormAppId();
            Long formRecordId = lockParam.getFormRecordId();
            String nodePolicy = lockParam.getNodePolicy();
            Boolean affairReadOnly = lockParam.getAffairReadOnly() == null ? false : lockParam.getAffairReadOnly();
            Integer affairState = lockParam.getAffairState();
            String rightId = lockParam.getRightId();
            Long affairId = lockParam.getAffairId();
            LOG.info("formAppId=" + formAppId + ",nodePolicy=" + nodePolicy + ",affairReadOnly=" + affairReadOnly);
            if (formAppId != null && !"inform".equals(nodePolicy) && !affairReadOnly) {
                StringBuilder paramsLog = new StringBuilder();
                paramsLog.append("Form Lock All Params ：formAppId:").append(formAppId);
                paramsLog.append(",formRecordId:").append(formRecordId);
                paramsLog.append(",nodePolicy:").append(nodePolicy);
                paramsLog.append(",affairReadOnly:").append(affairReadOnly);
                paramsLog.append(",affairState:").append(affairState);
                paramsLog.append(",rightId:").append(rightId);
                paramsLog.append(",affairId:").append(affairId);
                LOG.info("协同表单加锁：" + paramsLog.toString());
                if (Integer.valueOf(StateEnum.col_pending.getKey()).equals(affairState)) {
                    boolean isReadOnly = false;
                    String from;
                    if (Strings.isNotBlank(rightId)) {
                        String _firstRightId = rightId.split("[_]")[0].split("[.]")[0];
                        if (NumberUtils.isNumber(_firstRightId)) {
                            FormBean bean = this.formManager.getForm(formAppId);
                            if (bean != null) {
                                FormAuthViewBean formAuthViewBean = bean.getAuthViewBeanById(Long.valueOf(_firstRightId));
                                if (formAuthViewBean != null) {
                                    from = formAuthViewBean.getType();
                                    isReadOnly = FormAuthorizationType.show.getKey().equals(from);
                                }
                            }
                        }
                    }

                    LOG.info("表单锁校验 canEdit:true,isReadOnly:" + isReadOnly);
                    obj.setIsReadOnly(String.valueOf(isReadOnly));
                    if (!isReadOnly) {
                        Object var19 = this.CheckAndupdateLock;
                        synchronized(this.CheckAndupdateLock) {
                            Lock lock = this.formManager.getLock(formRecordId);
                            from = login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
                            if (lock == null) {
                                Long userId = AppContext.currentUserId();
                                LOG.info("开始加锁 - lock is null : from=" + from + ",userId= " + userId + ",affairId:" + affairId);
                                this.formManager.lockFormData(formRecordId, AppContext.currentUserId(), from);
                                obj.setOwner(AppContext.currentUserId());
                                obj.setLoginName(AppContext.currentUserLoginName());
                                obj.setLoginTimestamp(AppContext.getCurrentUser().getLoginTimestamp().getTime());
                                obj.setCanSubmit("1");
                            } else {
                                obj.setFrom(lock.getFrom());
                                obj.setLoginName(Functions.showMemberName(lock.getOwner()));
                                obj.setOwner(lock.getOwner());
                                obj.setLoginTimestamp(lock.getLoginTime());
                                boolean isOne = lock.getOwner() == AppContext.currentUserId();
                                if (isOne && !from.equals(lock.getFrom())) {
                                    LOG.info("SAME AND DIFFERENT,user:" + AppContext.currentUserId() + ",form:" + from + ",lock.getFrom():" + lock.getFrom() + ",affairId:" + affairId);
                                }

                                LOG.info("判断锁：isOne=" + isOne + " from=" + from + " lockFrom=" + lock.getFrom());
                                if (isOne && from.equals(lock.getFrom())) {
                                    obj.setCanSubmit("1");
                                    LOG.info("可以提交！");
                                } else {
                                    obj.setCanSubmit("0");
                                    LOG.info("不可以提交 - SAME AND DIFFERENT,user:" + AppContext.currentUserId() + ",form:" + from + ",lock.getFrom():" + lock.getFrom() + ",affairId:" + affairId + ",lock.owner:" + lock.getOwner() + ",obj.setLoginName：" + obj.getLoginName() + ",lockTime:" + lock.getLockTime());
                                }
                            }
                        }
                    }
                }
            }
        }

        return obj;
    }

    @AjaxAccess
    public void activeLockTime(Map<String, String> lockParam) throws BusinessException {
        List<Lock> needUpdatelockList = new ArrayList();
        String curUserId = (String)lockParam.get("curUserId");
        String loginPlatform = (String)lockParam.get("loginPlatform");
        String masterId = (String)lockParam.get("formMasterId");
        long _curUserId = Strings.isNotBlank(curUserId) ? new Long(curUserId) : (null != AppContext.getCurrentUser() ? AppContext.getCurrentUser().getId() : 0L);
        if (Strings.isNotBlank(masterId)) {
            Lock lock = this.formManager.getLock(Long.valueOf(masterId));
            if (null != lock) {
                long owner = lock.getOwner();
                if (owner == _curUserId && loginPlatform.equals(lock.getFrom())) {
                    long _curTime = (new Timestamp(System.currentTimeMillis())).getTime();
                    lock.setExpirationTime(_curTime);
                    needUpdatelockList.add(lock);
                }
            }
        }

        String processId = (String)lockParam.get("processId");
        if (Strings.isNotBlank(processId)) {
            List<Lock> plocks = this.getWFLockObject(Long.valueOf(processId), String.valueOf(_curUserId));
            if (!Strings.isEmpty(plocks)) {
                Iterator var10 = plocks.iterator();

                while(var10.hasNext()) {
                    Lock _plock = (Lock)var10.next();
                    if (loginPlatform.equals(_plock.getFrom())) {
                        long _curTime = (new Timestamp(System.currentTimeMillis())).getTime();
                        _plock.setExpirationTime(_curTime);
                        needUpdatelockList.add(_plock);
                    }
                }
            }
        }

        Iterator var16 = needUpdatelockList.iterator();

        while(var16.hasNext()) {
            Lock needUpdate = (Lock)var16.next();
            this.lockManager.updateLockExpirationTime(needUpdate.getResourceId(), needUpdate.getAction(), needUpdate.getExpirationTime());
        }

    }

    private List<Lock> getWFLockObject(Long processId, String userId) {
        List<Lock> mylocks = new ArrayList();
        List<Lock> locks = this.lockManager.getLocks(processId);
        if (locks != null && !locks.isEmpty()) {
            Iterator var5 = locks.iterator();

            while(var5.hasNext()) {
                Lock lk = (Lock)var5.next();
                if (lk != null && lk.getOwner() == Long.parseLong(userId) && LockState.effective_lock.equals(this.lockManager.isValid(lk))) {
                    mylocks.add(lk);
                }
            }
        }

        return mylocks;
    }

    public void colDelLock(Long affairId) throws BusinessException {
        CtpAffair affair = this.affairManager.get(affairId);
        if (affair == null) {
            LOG.info("协同解锁，获取affair为null,可能有问题");
        } else {
            Long summaryId = affair.getObjectId();
            ColSummary summary = this.getSummaryById(summaryId);
            this.colDelLock(summary, affair);
        }
    }

    public void colDelLock(Long affairId, boolean delAll) throws BusinessException {
        if (delAll) {
            CtpAffair affair = this.affairManager.get(affairId);
            if (affair == null) {
                LOG.info("协同解锁，获取affair为null,可能有问题");
                return;
            }

            Long summaryId = affair.getObjectId();
            ColSummary summary = this.getSummaryById(summaryId);
            this.colDelLock(summary, affair, delAll);
        } else {
            this.colDelLock(affairId);
        }

    }

    public void colDelLock(ColSummary summary, CtpAffair _affair) throws BusinessException {
        Map<String, String> param = new HashMap();
        param.put("summaryId", String.valueOf(summary.getId()));
        param.put("processId", summary.getProcessId());
        param.put("formAppId", summary.getFormAppid() == null ? null : String.valueOf(summary.getFormAppid()));
        param.put("fromRecordId", summary.getFormRecordid() == null ? null : String.valueOf(summary.getFormRecordid()));
        param.put("bodyType", summary.getBodyType());
        this.ajaxColDelLock(param);
    }

    public void colDelLock(ColSummary summary, CtpAffair _affair, boolean delAll) throws BusinessException {
        if (delAll) {
            Map<String, String> param = new HashMap();
            param.put("summaryId", String.valueOf(summary.getId()));
            param.put("processId", summary.getProcessId());
            param.put("formAppId", summary.getFormAppid() == null ? null : String.valueOf(summary.getFormAppid()));
            param.put("fromRecordId", summary.getFormRecordid() == null ? null : String.valueOf(summary.getFormRecordid()));
            param.put("bodyType", summary.getBodyType());
            param.put("delAll", "true");
            this.ajaxColDelLock(param);
        } else {
            this.colDelLock(summary, _affair);
        }

    }

    @AjaxAccess
    public void unlock4NewCol(Map<String, String> params) throws BusinessException {
        String masterDataId = (String)params.get("masterDataId");
        if (Strings.isNotEmpty(masterDataId)) {
            Map<String, Object> m = new HashMap();
            m.put("masterDataId", masterDataId);
            this.formManager.removeSessionMasterData(m);
        }

        String handWriteKeys = (String)params.get("handWriteKeys");
        if (Strings.isNotEmpty(handWriteKeys)) {
            String[] names = handWriteKeys.split("[,]");
            String[] var5 = names;
            int var6 = names.length;

            for(int var7 = 0; var7 < var6; ++var7) {
                String name = var5[var7];
                this.handWriteManager.deleteUpdateObj(name);
            }
        }

    }

    @AjaxAccess
    public void onDealPageLeave(Map<String, Map<String, String>> params) throws BusinessException {
        Map<String, String> delLockMap = (Map)params.get("DelLock");
        if (delLockMap != null && delLockMap.size() > 0) {
            try {
                this.ajaxColDelLock(delLockMap);
            } catch (Exception var6) {
                LOG.error("解锁失败", var6);
            }
        }

        Map<String, String> viewRecordMap = (Map)params.get("ViewRecord");
        if (viewRecordMap != null && viewRecordMap.size() > 0) {
            try {
                this.colBatchUpdateAnalysisTimeManager.addTask(viewRecordMap);
            } catch (Exception var5) {
                LOG.error("记录第一次关闭窗口时间异常", var5);
            }
        }

    }

    public void ajaxColDelLock(Map<String, String> param) throws BusinessException {
        Long summaryId = Long.valueOf((String)param.get("summaryId"));
        String processId = Strings.isBlank((String)param.get("processId")) ? "" : (String)param.get("processId");
        Long formAppId = Strings.isBlank((String)param.get("formAppId")) ? 0L : Long.valueOf((String)param.get("formAppId"));
        Long fromRecordId = Strings.isBlank((String)param.get("fromRecordId")) ? 0L : Long.valueOf((String)param.get("fromRecordId"));
        String bodyType = (String)param.get("bodyType");
        if (summaryId == null) {
            LOG.info("协同解锁，获取summary为null,可能有问题");
        } else {
            try {
                String loginFrom = login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
                String userId = String.valueOf(AppContext.currentUserId());
                boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(bodyType);
                StringBuilder unlockLog = new StringBuilder();
                unlockLog.append(AppContext.currentUserLoginName()).append("-协同解锁-ajaxColDelLock-loginFrom:").append(loginFrom).append(",processId:").append(processId).append(",userId:").append(userId).append(",isForm:").append(isForm).append(",formAppId:").append(formAppId).append(",summaryId:").append(summaryId).append(",fromRecordId:").append(fromRecordId);
                LOG.info(unlockLog.toString());
                this.wapi.releaseWorkFlowProcessLock(processId, userId, loginFrom);
                this.wapi.releaseWorkFlowProcessLock(String.valueOf(summaryId), userId);
                if (isForm && formAppId != null) {
                    if (LOG.isDebugEnabled()) {
                        LOG.debug("AjaxColDelLock协同页面离开，解锁表单锁：summaryid:" + summaryId + ",fromRecordId:" + fromRecordId);
                    }

                    this.formManager.removeSessionMasterDataBean(fromRecordId);
                }

            } catch (Throwable var11) {
                LOG.error("协同解锁失败colDelLock", var11);
                throw new BusinessException(var11);
            }
        }
    }

    public boolean updateAppointStepBack(Map<String, Object> c) throws BusinessException {
        String summaryId = (String)c.get("summaryId");
        String workitemId = (String)c.get("workitemId");
        String caseId = (String)c.get("caseId");
        String processId = (String)c.get("processId");
        String currentUserId = String.valueOf(AppContext.currentUserId());
        String currentAccountId = String.valueOf(AppContext.currentAccountId());
        String selectTargetNodeId = (String)c.get("theStepBackNodeId");
        String submitStyle = (String)c.get("submitStyle");
        String currentActivityId = (String)c.get("activityId");
        String currentAffairId = (String)c.get("affairId");
        String isWfTrace = (String)c.get("isWFTrace");
        String isCircleBack = (String)c.get("isCircleBack");
        ColSummary summary = (ColSummary)c.get("summary");
        CtpAffair currentAffair = (CtpAffair)c.get("affair");
        Comment comment = (Comment)c.get("comment");
        User user = (User)c.get("user");
        DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
        List<CtpAffair> allAvailableAffairs = this.affairManager.getValidAffairs(ApplicationCategoryEnum.collaboration, Long.valueOf(summaryId));
        comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
        this.saveOrUpdateComment(comment);
        this.saveAttDatas(user, summary, currentAffair, comment.getId());
        AffairData affairData = ColUtil.getAffairData(summary);
        WorkflowBpmContext context = new WorkflowBpmContext();
        context.setCurrentWorkitemId(Long.parseLong(workitemId));
        context.setCaseId(Long.parseLong(caseId));
        context.setProcessId(processId);
        context.setCurrentUserId(currentUserId);
        context.setCurrentAccountId(currentAccountId);
        context.setCurrentActivityId(currentActivityId);
        context.setSelectTargetNodeId(selectTargetNodeId);
        context.setSubmitStyleAfterStepBack(submitStyle);
        context.getBusinessData().put("ColSummary", summary);
        context.setBusinessData("CURRENT_OPERATE_SUMMARY_ID", summary.getId());
        context.setBusinessData("CTP_AFFAIR_DATA", affairData);
        context.setBusinessData("CURRENT_OPERATE_MEMBER_ID", currentAffair.getMemberId());
        context.setBusinessData("CURRENT_OPERATE_COMMENT_ID", comment.getId());
        context.setBusinessData("CURRENT_OPERATE_AFFAIR_ID", Long.valueOf(currentAffairId));
        context.setBusinessData("operationType", "1".equals(submitStyle) ? WorkFlowEventListener.SPECIAL_BACK_SUBMITTO : WorkFlowEventListener.SPECIAL_BACK_RERUN);
        context.setBusinessData("isCircleBack", isCircleBack);
        context.setAppObject(summary);
        context.setVersion("2.0");
        context.setBusinessData("CURRENT_OPERATE_TRACK_FLOW", isWfTrace);
        String[] retValue = this.wapi.stepBack(context);
        String selectTargetNodeName = retValue[2];
        V3xOrgMember member = null;
        boolean isRepeal = false;
        int backStrategy = 169;
        if ("1".equals(submitStyle)) {
            backStrategy = 168;
        }

        String describe = "appLog.action." + backStrategy;
        if ("start".equals(selectTargetNodeId)) {
            CtpAffair sendAffair;
            if ("1".equals(submitStyle)) {
                sendAffair = this.affairManager.getSenderAffair(Long.parseLong(summaryId));
                member = this.orgManager.getMemberById(sendAffair.getMemberId());
                sendAffair.setSubState(SubStateEnum.col_pending_specialBacked.getKey());
                sendAffair.setState(StateEnum.col_waitSend.getKey());
                sendAffair.setUpdateDate(new Date());
                sendAffair.setDelete(Boolean.FALSE);
                sendAffair.setPreApprover(user.getId());
                this.affairManager.updateAffair(sendAffair);
            } else if ("0".equals(submitStyle)) {
                isRepeal = true;
                sendAffair = null;
                if (allAvailableAffairs != null) {
                    for(int i = 0; i < allAvailableAffairs.size(); ++i) {
                        CtpAffair affair = (CtpAffair)allAvailableAffairs.get(i);
                        if (affair.getState() == StateEnum.col_sent.key() || affair.getState() == StateEnum.col_waitSend.key()) {
                            affair.setState(StateEnum.col_waitSend.key());
                            affair.setSubState(SubStateEnum.col_pending_specialBackToSenderCancel.key());
                            affair.setDelete(false);
                            affair.setPreApprover(user.getId());
                            this.affairManager.updateAffair(affair);
                            member = this.orgManager.getMemberById(affair.getMemberId());
                            sendAffair = affair;
                        }

                        if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
                            QuartzHolder.deleteQuartzJob("Remind" + affair.getId());
                            QuartzHolder.deleteQuartzJob("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
                        }

                        if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
                            QuartzHolder.deleteQuartzJob("DeadLine" + affair.getId());
                            QuartzHolder.deleteQuartzJob("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
                        }

                        ColUtil.deleteCycleRemindQuartzJob(affair, false);
                    }
                }

                summary.setCaseId((Long)null);
                summary.setState(flowState.cancel.ordinal());
                this.updateColSummary(summary);
                workflowTrackType trackType = workflowTrackType.special_step_back_repeal;
                if ("1".equals(isCircleBack)) {
                    trackType = workflowTrackType.circle_step_back_repeal;
                }

                this.createRepealData2BeginNode(currentAffair, summary, allAvailableAffairs, trackType, isWfTrace);
                this.do4Repeal(user.getId(), comment.getContent(), summary.getId(), allAvailableAffairs, true);
                this.iSignatureHtmlManager.deleteAllByDocumentId(summary.getId());
                if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                    try {
                        this.formRelationManager.RelationAuthorityBySummaryId(summary.getId(), ModuleType.collaboration.getKey());
                        if (null != sendAffair) {
                            AffairUtil.setIsRelationAuthority(sendAffair, false);
                            DBAgent.update(sendAffair);
                        }
                    } catch (Exception var31) {
                        LOG.error("更新表单相关信息异常", var31);
                    }
                }
            }

            this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(processId), Long.parseLong(currentActivityId), ProcessLogAction.colStepBackToSender, comment.getId(), new String[]{member == null ? "" : member.getName(), describe, summary.getSubject(), selectTargetNodeName, "true"});
        } else {
            this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(processId), Long.parseLong(currentActivityId), ProcessLogAction.colStepBackToPoint, comment.getId(), new String[]{"", describe, summary.getSubject(), selectTargetNodeName, "true"});
        }

        ColUtil.updateCurrentNodesInfo(summary);
        ColUtil.addOneReplyCounts(summary);
        this.updateColSummary(summary);
        if (AppContext.hasPlugin("index")) {
            if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                this.indexManager.update(summary.getId(), ApplicationCategoryEnum.form.getKey());
            } else {
                this.indexManager.update(summary.getId(), ApplicationCategoryEnum.collaboration.getKey());
            }
        }

        if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
            try {
                AppContext.putThreadContext("isRepeal_4_form_use", "start".equals(selectTargetNodeId));
                List<Comment> commentList = this.commentManager.getCommentAllByModuleId(ModuleType.collaboration, summary.getId());
                this.formManager.updateDataState(summary, currentAffair, ColHandleType.specialback, commentList);
                AppContext.removeThreadContext("isRepeal_4_form_use");
            } catch (Exception var30) {
                LOG.error("更新表单相关信息异常", var30);
            }
        }

        if ("1".equals(submitStyle)) {
            this.appLogManager.insertLog(user, 168, new String[]{user.getName(), summary.getSubject(), selectTargetNodeName});
        } else if ("0".equals(submitStyle)) {
            this.appLogManager.insertLog(user, 169, new String[]{user.getName(), summary.getSubject(), selectTargetNodeName});
        }

        this.affairManager.updateAffairAnalyzeData(currentAffair);
        CollaborationAppointStepBackEvent backEvent = new CollaborationAppointStepBackEvent(this);
        backEvent.setSelectTargetNodeId(selectTargetNodeId);
        backEvent.setSummaryId(summary.getId());
        EventDispatcher.fireEvent(backEvent);
        this.colMessageManager.appointStepBackSendMsg(summary, allAvailableAffairs, submitStyle, selectTargetNodeId, selectTargetNodeName, currentAffair, comment);
        return true;
    }

    public String getContentComponentType(String moduleId) {
        List<CtpContentAll> list = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, Long.valueOf(moduleId));
        return ((CtpContentAll)list.get(0)).getContentType().toString();
    }

    public String colCheckAndupdateLock(String processId, Long summaryId, boolean isLock) throws BusinessException {
        return null;
    }

    private String getModifyUserName(String processId, Long summaryId) throws BusinessException {
        return null;
    }

    public FlipInfo getStatisticSearchCols(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        User user = AppContext.getCurrentUser();
        List<ColSummaryVO> result = null;
        boolean setTimeNull = false;
        String stateStr = (String)query.get("state");
        if ("archived".equals(query.get(ColQueryCondition.archiveId.name()))) {
            result = this.getArchiveAffair(flipInfo, query);
        } else {
            result = this.colDao.queryByCondition(flipInfo, query);
            if (Strings.isNotBlank(stateStr) && ("3,4".equals(stateStr) || "3".equals(stateStr))) {
                setTimeNull = true;
            }
        }

        Iterator var7 = result.iterator();

        while(true) {
            while(var7.hasNext()) {
                ColSummaryVO csvo = (ColSummaryVO)var7.next();
                ColSummary summary = csvo.getSummary();
                CtpAffair caffair = csvo.getAffair();
                if (caffair != null && null != caffair.getSubState()) {
                    int affairState = caffair.getSubState();
                    if (setTimeNull && (SubStateEnum.col_pending_specialBacked.getKey() == affairState || SubStateEnum.col_pending_specialBackCenter.getKey() == affairState || SubStateEnum.col_pending_specialBackToSenderCancel.getKey() == affairState)) {
                        csvo.setDealTime((Date)null);
                    }
                }

                Long accountId = ColUtil.getFlowPermAccountId(user.getLoginAccount(), summary);
                String nodeName = csvo.getNodePolicy();
                Map<String, Permission> permissonMap = this.getPermissonMap(EnumNameEnum.col_flow_perm_policy.name(), accountId);
                Permission permisson = (Permission)permissonMap.get(nodeName);
                if (permisson != null) {
                    NodePolicy nodePolicy = permisson.getNodePolicy();
                    Integer opinion = nodePolicy.getOpinionPolicy();
                    boolean canDeleteORarchive = opinion != null && opinion == 1;
                    csvo.setCanDeleteORarchive(canDeleteORarchive);
                    csvo.setCancelOpinionPolicy(nodePolicy.getCancelOpinionPolicy());
                    csvo.setDisAgreeOpinionPolicy(nodePolicy.getDisAgreeOpinionPolicy());
                    csvo.setCanDeleteORarchive(false);
                } else {
                    csvo.setCanDeleteORarchive(true);
                }
            }

            if (flipInfo != null) {
                flipInfo.setData(result);
            }

            return flipInfo;
        }
    }

    public Map checkIsCanRepeal(Map params) throws BusinessException {
        String _summaryId = (String)params.get("summaryId");
        Map<String, String> map = new HashMap();
        if (Strings.isBlank(_summaryId)) {
            map.put("msg", "程序或者数据异常，不可以撤销！");
            return map;
        } else {
            Long summaryId = Long.parseLong(_summaryId);
            ColSummary colSummary = this.getColSummaryById(summaryId);
            if (colSummary == null) {
                map.put("msg", "程序或者数据异常，不可以撤销！");
                return map;
            } else if (flowState.terminate.ordinal() != colSummary.getState() && flowState.finish.ordinal() != colSummary.getState()) {
                if (colSummary.getVouch() != null && ColSummaryVouch.vouchPass.getKey() == colSummary.getVouch()) {
                    map.put("msg", ResourceUtil.getString("collaboration.cannotRepeal_workflowIsVouched"));
                    return map;
                } else {
                    Map<String, Object> conditions = new HashMap();
                    conditions.put("objectId", summaryId);
                    conditions.put("state", StateEnum.col_done.key());
                    conditions.put("delete", false);
                    List<CtpAffair> affairList = this.affairManager.getByConditions((FlipInfo)null, conditions);
                    if (affairList != null && !affairList.isEmpty()) {
                        Iterator var8 = affairList.iterator();

                        while(var8.hasNext()) {
                            CtpAffair affair = (CtpAffair)var8.next();
                            if (affair.getActivityId() != null) {
                                SeeyonPolicy seeyonPolicy = ColUtil.getPolicyByAffair(affair);
                                if (this.cannotRepealList.contains(seeyonPolicy.getId())) {
                                    map.put("msg", ResourceUtil.getString("collaboration.cannotRepeal_workflowIsAudited"));
                                    return map;
                                }
                            }
                        }
                    }

                    return map;
                }
            } else {
                map.put("msg", ResourceUtil.getString("collaboration.cannotRepeal_workflowIsFinished"));
                return map;
            }
        }
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
        this.userMessageManager = userMessageManager;
    }

    public int recallNewflowSummary(Long caseId, User user, String operationType) throws BusinessException {
        int result = 0;
        if (user == null) {
            return result;
        } else {
            ColSummary summary = this.getSummaryByCaseId(caseId);
            if (summary == null) {
                return 1;
            } else {
                Map map = new HashMap();
                map.put("objectId", summary.getId());
                List<CtpAffair> affairs = this.affairManager.getValidAffairs((FlipInfo)null, map);
                List<Long> affairIds = new ArrayList();
                if (affairs != null) {
                    for(int i = 0; i < affairs.size(); ++i) {
                        CtpAffair affair = (CtpAffair)affairs.get(i);
                        if (affair.getState() == StateEnum.col_sent.key()) {
                            affair.setState(StateEnum.col_waitSend.key());
                            affair.setSubState(SubStateEnum.col_waitSend_cancel.key());
                            affair.setDelete(true);
                            this.affairManager.updateAffair(affair);
                        }

                        if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
                            QuartzHolder.deleteQuartzJob("Remind" + affair.getId());
                            QuartzHolder.deleteQuartzJob("Remind" + affair.getObjectId() + "_" + affair.getActivityId());
                        }

                        if (affair.getDeadlineDate() != null && affair.getDeadlineDate() != 0L) {
                            QuartzHolder.deleteQuartzJob("DeadLine" + affair.getId());
                            QuartzHolder.deleteQuartzJob("DeadLine" + affair.getObjectId() + "_" + affair.getActivityId());
                        }

                        ColUtil.deleteCycleRemindQuartzJob(affair, false);
                        affairIds.add(affair.getId());
                    }

                    this.affairManager.updateAffairsState2Cancel(summary.getId());
                }

                summary.setCaseId((Long)null);
                DBAgent.update(summary);
                ColUtil.deleteQuartzJobOfSummary(summary);
                if (AppContext.hasPlugin("doc")) {
                    this.docApi.deleteDocResources(user.getId(), affairIds);
                }

                String key = "col.newflow.callback";
                String operation = "";
                if ("takeBack".equals(operationType)) {
                    operation = ResourceUtil.getString("collaboration.takeBack.label");
                } else if ("stepBack".equals(operationType)) {
                    operation = ResourceUtil.getString("collaboration.stepBack.label");
                } else if ("repeal".equals(operationType)) {
                    operation = ResourceUtil.getString("collaboration.repeal.2.label");
                }

                CtpSuperviseDetail detail = this.superviseManager.getSupervise(EntityType.template.ordinal(), summary.getTempleteId());
                if (null != detail) {
                    this.colMessageManager.sendMessage2Supervisor(detail.getId(), ApplicationCategoryEnum.collaboration, summary.getSubject(), key, user.getId(), user.getName(), operation, summary.getForwardMember());
                }

                this.superviseManager.updateStatus2Cancel(summary.getId());

                try {
                    Integer importantLevel = summary.getImportantLevel();
                    Set<MessageReceiver> receivers = new HashSet();
                    if (affairs != null && affairs.size() > 0) {
                        Iterator var14 = affairs.iterator();

                        while(var14.hasNext()) {
                            CtpAffair affair1 = (CtpAffair)var14.next();
                            if (!affair1.isDelete() && !user.getId().equals(affair1.getMemberId())) {
                                receivers.add(new MessageReceiver(affair1.getId(), affair1.getMemberId()));
                            }
                        }

                        this.userMessageManager.sendSystemMessage((new MessageContent(key, new Object[]{summary.getSubject(), user.getName(), operation})).setImportantLevel(importantLevel), ApplicationCategoryEnum.collaboration, user.getId(), receivers, new Object[]{ColUtil.getImportantLevel(summary)});
                    }
                } catch (Exception var16) {
                    LOG.error("召回新流程协同发送提醒消息异常", var16);
                    throw new BusinessException("send message failed");
                }

                this.processLogManager.deleteLog(Long.parseLong(summary.getProcessId()));
                CollaborationCancelEvent cancelEvent = new CollaborationCancelEvent(this);
                cancelEvent.setSummaryId(summary.getId());
                cancelEvent.setUserId(user.getId());
                EventDispatcher.fireEvent(cancelEvent);
                return 0;
            }
        }
    }

    public boolean isTemplateHasPrePigholePath(Long templateId) throws BusinessException {
        if (templateId == null) {
            return false;
        } else {
            CtpTemplate templete = this.templateManager.getCtpTemplate(templateId);
            if (templete != null) {
                ColSummary summary = (ColSummary)XMLCoder.decoder(templete.getSummary());
                if (summary != null) {
                    Long archiveId = summary.getArchiveId();
                    if (archiveId != null) {
                        return true;
                    }

                    if (Strings.isNotBlank(summary.getAdvancePigeonhole())) {
                        return true;
                    }
                }
            }

            return false;
        }
    }

    public List<Long> getColAllMemberId(String summaryId) {
        List<Long> memberIdList = new ArrayList();
        List<StateEnum> states = new ArrayList();
        states.add(StateEnum.col_pending);
        states.add(StateEnum.col_done);
        states.add(StateEnum.col_sent);
        states.add(StateEnum.col_waitSend);

        try {
            List<CtpAffair> ctpAffair = this.affairManager.getAffairs(Long.valueOf(summaryId), states);

            for(int i = 0; i < ctpAffair.size(); ++i) {
                if (!memberIdList.contains(((CtpAffair)ctpAffair.get(i)).getMemberId())) {
                    memberIdList.add(((CtpAffair)ctpAffair.get(i)).getMemberId());
                }
            }
        } catch (Exception var6) {
            LOG.error("获取当前事项的所有memberId异常", var6);
        }

        return memberIdList;
    }

    public Comment insertComment(Comment comment, String openFrom) throws BusinessException {
        Long affairId = comment.getAffairId();
        User user = AppContext.getCurrentUser();
        CtpAffair affair = this.affairManager.get(affairId);
        if (affair != null) {
            if ("supervise".equals(openFrom)) {
                comment.setCreateId(user.getId());
            } else {
                List<Long> ownerIds = MemberAgentBean.getInstance().getAgentToMemberId(ModuleType.collaboration.getKey(), user.getId());
                boolean isProxy = false;
                if (Strings.isNotEmpty(ownerIds) && ownerIds.contains(affair.getMemberId())) {
                    isProxy = true;
                }

                if (affair != null && !affair.getMemberId().equals(user.getId()) && isProxy) {
                    comment.setExtAtt2(user.getName());
                    comment.setCreateId(affair.getMemberId());
                } else {
                    comment.setCreateId(user.getId());
                    comment.setExtAtt2((String)null);
                }
            }
        } else {
            comment.setCreateId(user.getId());
        }

        Comment c = this.commentManager.insertComment(comment);
        this.sendMsg(c);
        if (c.getCreateId() != null) {
            c.setCreateName(OrgHelper.showMemberNameOnly(c.getCreateId()));
        }

        CollaborationAddCommentEvent commentEvent = new CollaborationAddCommentEvent(this);
        commentEvent.setCommentId(c.getId());
        EventDispatcher.fireEvent(commentEvent);

        try {
            if (AppContext.hasPlugin("index") && affairId != null && Integer.valueOf(ModuleType.collaboration.getKey()).equals(comment.getModuleType())) {
                CtpAffair ctpAffair = this.affairManager.get(affairId);
                if (ctpAffair != null) {
                    if (String.valueOf(MainbodyType.FORM.getKey()).equals(ctpAffair.getBodyType())) {
                        this.indexManager.update(ctpAffair.getObjectId(), ApplicationCategoryEnum.form.getKey());
                    } else {
                        this.indexManager.update(ctpAffair.getObjectId(), ApplicationCategoryEnum.collaboration.getKey());
                    }
                }
            }
        } catch (Exception var9) {
            LOG.error("全文检索异常", var9);
        }

        return c;
    }

    private void sendMsg(Comment comment) throws BusinessException {
        boolean ispush = comment.isPushMessage() != null && comment.isPushMessage();
        if (comment.getCtype() == CommentType.reply.getKey() && !ispush) {
            ispush = true;
            comment.setPushMessageToMembers("");
        }

        if (ispush) {
            ContentConfig cc = ContentConfig.getConfig(ModuleType.getEnumByKey(comment.getModuleType()));
            ContentInterface ci = cc.getContentInterface();
            if (ci != null) {
                ci.doCommentPushMessage(comment);
            }
        }

    }

    public Map checkTemplateCanModifyProcess(String templateId) throws BusinessException {
        Map resMap = new HashMap();
        if (!Strings.isNotBlank(templateId)) {
            resMap.put("canModify", "yes");
            return resMap;
        } else {
            CtpTemplate ctpTemplate = this.templateManager.getCtpTemplate(Long.valueOf(templateId));
            if (null == ctpTemplate) {
                resMap.put("canModify", "yes");
                return resMap;
            } else {
                String summary = ctpTemplate.getSummary();
                Boolean canSupervise = ctpTemplate.getCanSupervise();
                if (!canSupervise) {
                    resMap.put("canSetSupervise", "no");
                }

                ColSummary sum = (ColSummary)XMLCoder.decoder(summary);
                Boolean canModify = sum.getCanModify();
                if (canModify) {
                    resMap.put("canModify", "yes");
                    return resMap;
                } else {
                    resMap.put("canModify", "no");
                    return resMap;
                }
            }
        }
    }

    public List<ColSummaryVO> exportDetaileExcel(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        new ArrayList();
        List<ColSummaryVO> colSumList = this.colDao.queryByCondition(flipInfo, query);
        return colSumList;
    }

    public List<ColSummaryVO> getArchiveAffair(FlipInfo flipInfo, Map<String, String> query) throws BusinessException {
        return this.colDao.getArchiveAffair(flipInfo, query);
    }

    private void transForwardBody(Long summaryId, Long moduleId, Long rightId) throws BusinessException {
        List<Attachment> newAtts = new ArrayList();
        FormService formService = new FormService();
        Set<Attachment> atts = FormService.getFormAttsByAuth(moduleId, rightId);
        if (atts != null) {
            Iterator var7 = atts.iterator();

            while(true) {
                Attachment newAtt;
                while(true) {
                    if (!var7.hasNext()) {
                        this.attachmentManager.create(newAtts);
                        return;
                    }

                    Attachment att = (Attachment)var7.next();
                    newAtt = null;

                    try {
                        newAtt = (Attachment)att.clone();
                        newAtt.setNewId();
                        if (att.getType() == ATTACHMENT_TYPE.FILE.ordinal() || att.getType() == ATTACHMENT_TYPE.FormFILE.ordinal()) {
                            newAtt.setFileUrl(att.getFileUrl());
                        }
                        break;
                    } catch (Exception var11) {
                        LOG.warn("", var11);
                    }
                }

                newAtt.setReference(summaryId);
                newAtt.setSubReference(100L);
                newAtts.add(newAtt);
            }
        }
    }

    public Long getParentProceeObjectId(Long id) throws BusinessException {
        ColSummary summary = this.getSummaryById(id);
        if (null == summary) {
            return id;
        } else {
            String processId = summary.getProcessId();
            if (Strings.isBlank(processId)) {
                return id;
            } else {
                Long parentProcessId = this.wapi.getMainProcessIdBySubProcessId(Long.valueOf(processId));
                if (null == parentProcessId) {
                    return id;
                } else {
                    ColSummary colSummaryById = this.getColSummaryByProcessId(parentProcessId);
                    return null != colSummaryById ? colSummaryById.getId() : id;
                }
            }
        }
    }

    public List<ColSummary> findColSummarysByIds(List<Long> ids) throws BusinessException {
        return this.colDao.findColSummarysByIds(ids);
    }

    public Map<Long, ColSummary> getColAndEdocSummaryMap(List<Long> collIdList) throws BusinessException {
        Map<Long, ColSummary> colSummaryMap = new HashMap();
        if (Strings.isNotEmpty(collIdList)) {
            List<ColSummary> colSummarys = this.findColSummarysByIds(collIdList);
            Iterator var4 = colSummarys.iterator();

            while(var4.hasNext()) {
                ColSummary summary = (ColSummary)var4.next();
                colSummaryMap.put(summary.getId(), summary);
            }
        }

        return colSummaryMap;
    }

    public Long calculateWorkDatetime(Map<String, String> params) throws BusinessException {
        new Date();
        int m = 0;
        String strMinutes = (String)params.get("minutes");
        if (strMinutes != null) {
            m = Integer.valueOf((String)params.get("minutes"));
        }

        String datetime = (String)params.get("datetime");
        Date newDate;
        if (Strings.isNotBlank(datetime)) {
            Date fromDate = Datetimes.parseDatetimeWithoutSecond(datetime);
            newDate = this.workTimeManager.getRemindDate(fromDate, (long)m);
        } else {
            Long currentAccuntId = AppContext.getCurrentUser().getLoginAccount();
            int workDayCount = this.workTimeManager.getWorkDaysByWeek();
            switch(m) {
                case 0:
                case 5:
                case 10:
                case 15:
                case 30:
                    newDate = this.workTimeManager.getCompleteDate4Worktime(new Date(), (long)m, currentAccuntId);
                    break;
                case 60:
                case 120:
                case 180:
                case 240:
                case 300:
                case 360:
                case 420:
                case 480:
                case 720:
                    long hours = Long.valueOf((long)(m / 60));
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", hours, "hour", currentAccuntId);
                    break;
                case 1440:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 1L, "day", currentAccuntId);
                    break;
                case 2880:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 2L, "day", currentAccuntId);
                    break;
                case 4320:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 3L, "day", currentAccuntId);
                    break;
                case 5760:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 4L, "day", currentAccuntId);
                    break;
                case 7200:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 5L, "day", currentAccuntId);
                    break;
                case 8640:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 6L, "day", currentAccuntId);
                    break;
                case 10080:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", (long)workDayCount, "day", currentAccuntId);
                    break;
                case 14400:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 10L, "day", currentAccuntId);
                    break;
                case 20160:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", Long.valueOf((long)(workDayCount * 2)), "day", currentAccuntId);
                    break;
                case 21600:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 15L, "day", currentAccuntId);
                    break;
                case 30240:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", Long.valueOf((long)(workDayCount * 3)), "day", currentAccuntId);
                    break;
                case 43200:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 30L, "day", currentAccuntId);
                    break;
                case 86400:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 60L, "day", currentAccuntId);
                    break;
                case 129600:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", 90L, "day", currentAccuntId);
                    break;
                default:
                    newDate = this.workTimeManager.getComputeDate(new Date(), "+", (long)workDayCount, "day", currentAccuntId);
            }
        }

        return newDate.getTime();
    }

    public List<ColSummaryVO> getSummaryByTemplateIdAndState(Long templateId, Integer state) throws BusinessException {
        return this.colDao.getSummaryByTemplateId(templateId, state);
    }

    public String[] getProcessIdByColSummaryId(Long id) throws BusinessException {
        ColSummary summary = this.getColSummaryById(id);
        return new String[]{summary.getProcessId()};
    }

    public String getTrackName(Map params) {
        String userName = "";
        String ids = (String)params.get("userId");
        if (Strings.isNotBlank(ids)) {
            String[] str = ids.split(",");

            try {
                for(int i = 0; i < str.length; ++i) {
                    String strId = str[i].replace("|", ",");
                    V3xOrgMember member = this.orgManager.getMemberById(Long.valueOf(strId.split(",")[1]));
                    userName = userName + member.getName() + ",";
                }
            } catch (NumberFormatException var8) {
                LOG.error("通过用户ID获取用户类型转换错误", var8);
            } catch (BusinessException var9) {
                LOG.error("通过用户ID获取用户对象出错", var9);
            }

            return userName.substring(0, userName.length() - 1);
        } else {
            return userName;
        }
    }

    public String ajaxCheckAgent(Map param) {
        Long affairMemberId = Long.valueOf((String)param.get("affairMemberId"));
        String subject = String.valueOf(param.get("subject"));
        int moduleType = Integer.valueOf((String)param.get("moduleType"));
        ModuleType mt = ModuleType.getEnumByKey(moduleType);
        String result = ColUtil.ajaxCheckAgent(affairMemberId, subject, mt);
        return result;
    }

    public ColSummary getColSummaryByFormRecordId(Long formRecordId) throws BusinessException {
        return this.colDao.getColSummaryByFormRecordId(formRecordId);
    }

    public Integer getColSummaryCount(Date beginDate, Date endDate, boolean isForm) throws BusinessException {
        return this.colDao.findIndexResumeCount(beginDate, endDate, isForm);
    }

    public List<Long> findIndexResumeIDList(Date starDate, Date endDate, Integer firstRow, Integer pageSize, boolean isForm) throws BusinessException {
        return this.colDao.findIndexResumeIDList(starDate, endDate, firstRow, pageSize, isForm);
    }

    public Map<String, String> getColDefaultNode(Long orgAccountId) throws BusinessException {
        Map<String, String> tempMap = new HashMap();
        PermissionVO permission = this.permissionManager.getDefaultPermissionByConfigCategory(EnumNameEnum.col_flow_perm_policy.name(), orgAccountId);
        String defaultNodeName = "";
        String defaultNodeLable = "";
        if (permission != null) {
            defaultNodeName = permission.getName();
            defaultNodeLable = permission.getLabel();
        }

        tempMap.put("defaultNodeName", defaultNodeName);
        tempMap.put("defaultNodeLable", defaultNodeLable);
        return tempMap;
    }

    public Permission getPermisson(CtpAffair affair, ColSummary summary, List<String> nodePermissions) throws BusinessException {
        Permission permission = this.getPermisson(affair, summary);
        List<String> basicActionList = this.permissionManager.getActionList(permission, PermissionAction.basic);
        List<String> commonActionList = this.permissionManager.getActionList(permission, PermissionAction.common);
        List<String> advanceActionList = this.permissionManager.getActionList(permission, PermissionAction.advanced);
        nodePermissions.addAll(basicActionList);
        nodePermissions.addAll(commonActionList);
        nodePermissions.addAll(advanceActionList);
        return permission;
    }

    public Permission getPermisson(CtpAffair affair, ColSummary summary) throws BusinessException {
        Long permissionAccountId = summary.getPermissionAccountId();
        Long startMenberId = summary.getStartMemberId();
        if (null == permissionAccountId && startMenberId != null) {
            V3xOrgMember orgMember = this.orgManager.getMemberById(startMenberId);
            permissionAccountId = orgMember.getOrgAccountId();
        }

        String configItem = ColUtil.getPolicyByAffair(affair).getId();
        String category = EnumNameEnum.col_flow_perm_policy.name();
        if (permissionAccountId == null) {
            LOG.info("permissionAccountId is null ,summaryId:" + summary.getPermissionAccountId());
        }

        return this.permissionManager.getPermission(category, configItem, permissionAccountId);
    }

    public String transColTransfer(Map<String, String> params) throws BusinessException {
        String message = "";
        User user = AppContext.getCurrentUser();
        Long affairId = Long.valueOf((String)params.get("affairId"));
        CtpAffair ctpAffair = this.affairManager.get(affairId);
        ColSummary summary = this.getColSummaryById(ctpAffair.getObjectId());
        Comment comment = ContentUtil.getCommnetFromRequest((OperationType)null, ctpAffair.getMemberId(), ctpAffair.getObjectId());
        comment.setModuleId(summary.getId());
        comment.setCreateDate(new Timestamp(System.currentTimeMillis()));
        comment.setCreateId(ctpAffair.getMemberId());
        comment.setAffairId(ctpAffair.getId());
        comment.setExtAtt3("collaboration.dealAttitude.transfer");
        if (!user.getId().equals(ctpAffair.getMemberId())) {
            comment.setExtAtt2(user.getName());
        }

        comment.setModuleType(ModuleType.collaboration.getKey());
        comment.setPid(0L);
        Comment m3Comment = (Comment)AppContext.getRequestContext("m3Comment");
        if (m3Comment != null) {
            AppContext.removeSessionArrribute("m3Comment");
            comment = m3Comment;
            m3Comment.setExtAtt3("collaboration.dealAttitude.transfer");
            if (!user.getId().equals(ctpAffair.getMemberId())) {
                m3Comment.setExtAtt2(user.getName());
            }

            this.saveOrUpdateComment(m3Comment);
            String modifyFlag = ParamUtil.getString(params, "modifyFlag", "");
            if ("1".equals(modifyFlag)) {
                this.processLogManager.insertLog(AppContext.getCurrentUser(), Long.parseLong(summary.getProcessId()), ctpAffair.getActivityId(), ProcessLogAction.processColl, m3Comment.getId(), new String[]{String.valueOf(ProcessEdocAction.modifyBody.getKey())});
            }
        } else {
            this.saveOrUpdateComment(comment);
            this.saveAttDatas(user, summary, ctpAffair, comment.getId());
        }

        Long transferMemberId = Long.valueOf((String)params.get("transferMemberId"));
        String processId = summary.getProcessId();

        try {
            V3xOrgMember orgMember = this.orgManager.getMemberById(transferMemberId);
            if (!orgMember.isValid()) {
                message = "转办指定人无效，请重新指定！";
                String var28 = message;
                return var28;
            }

            List<V3xOrgMember> nextMembers = new ArrayList();
            nextMembers.add(orgMember);
            String newAffairMemeerId = "";
            if (nextMembers.size() > 0) {
                LOG.info("转办参数： 转办人：" + orgMember.getName() + ",id=" + orgMember.getId());
                LOG.info("转办参数：processId：" + processId + ",id=" + orgMember.getId());
                LOG.info("转办参数：affair: memberId=" + ctpAffair.getMemberId() + ",subObjectId=" + ctpAffair.getSubObjectId() + "activityId=" + ctpAffair.getActivityId());
                DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
                Object[] result = this.wapi.replaceWorkItemMembers(true, ctpAffair.getMemberId(), processId, ctpAffair.getSubObjectId(), ctpAffair.getActivityId().toString(), nextMembers, true);
                List<WorkItem> workitems = (List)result[1];
                BPMHumenActivity bpmActivity = (BPMHumenActivity)result[2];
                List<CtpAffair> newAffairs = new ArrayList();
                summary = (ColSummary)DateSharedWithWorkflowEngineThreadLocal.getColSummary();

                for(int i = 0; i < workitems.size(); ++i) {
                    WorkItem workItem = (WorkItem)workitems.get(i);
                    CtpAffair newAffair = (CtpAffair)BeanUtils.cloneBean(ctpAffair);
                    newAffairMemeerId = workItem.getPerformer();
                    newAffair.setMemberId(Long.parseLong(newAffairMemeerId));
                    newAffair.setId(UUIDLong.longUUID());
                    newAffair.setSubObjectId(workItem.getId());
                    newAffair.setCoverTime(false);
                    newAffair.setReceiveTime(new Date());
                    newAffair.setUpdateDate(new Date());
                    newAffair.setDelete(false);
                    newAffair.setFromId(user.getId());
                    newAffair.setFromType(AffairFromTypeEnum.Col_Transfer.getKey());
                    newAffair.setBackFromId((Long)null);
                    newAffair.setState(StateEnum.col_pending.getKey());
                    newAffair.setSubState(SubStateEnum.col_pending_unRead.getKey());
                    newAffair.setOverWorktime((Long)null);
                    newAffair.setRunWorktime((Long)null);
                    newAffair.setOverTime((Long)null);
                    newAffair.setRunTime((Long)null);
                    newAffair.setPreApprover(ctpAffair.getMemberId());
                    V3xOrgMember nextMember = (V3xOrgMember)nextMembers.get(i);
                    if (newAffair.getDeadlineDate() != null && newAffair.getDeadlineDate() != 0L) {
                        newAffair.setExpectedProcessTime(this.workTimeManager.getCompleteDate4Nature(new Date(), newAffair.getDeadlineDate(), nextMember.getOrgAccountId()));
                    }

                    newAffairs.add(newAffair);
                }

                this.affairManager.saveAffairs(newAffairs);
                this.processLogManager.insertLog(user, Long.valueOf(processId), Long.valueOf(bpmActivity.getId()), ProcessLogAction.transfer, comment.getId(), new String[]{user.getName(), orgMember.getName()});
                this.appLogManager.insertLog(user, AppLogAction.Coll_Tranfer, new String[]{user.getName(), summary.getSubject(), orgMember.getName()});
                this.colMessageManager.sendMessage4Transfer(user, summary, newAffairs, ctpAffair, comment);
            }

            ctpAffair.setDelete(true);
            ctpAffair.setActivityId(-1L);
            ctpAffair.setSubObjectId(-1L);
            ctpAffair.setObjectId(-1L);
            ctpAffair.setTempleteId(-1L);
            Long oldMemberId = ctpAffair.getMemberId();
            ctpAffair.setMemberId(-1L);
            if (ctpAffair.getSignleViewPeriod() == null && ctpAffair.getFirstViewDate() != null) {
                Date nowTime = new Date();
                long viewTime = this.workTimeManager.getDealWithTimeValue(ctpAffair.getFirstViewDate(), nowTime, ctpAffair.getOrgAccountId());
                ctpAffair.setSignleViewPeriod(viewTime);
            }

            this.affairManager.updateAffair(ctpAffair);
            ColUtil.addOneReplyCounts(summary);
            String currentNodesInfo = summary.getCurrentNodesInfo().replaceFirst(String.valueOf(oldMemberId), String.valueOf(newAffairMemeerId));
            summary.setCurrentNodesInfo(currentNodesInfo);
            this.updateColSummary(summary);
        } catch (Throwable var25) {
            LOG.error("转办报错！", var25);
        } finally {
            this.colDelLock(summary, ctpAffair);
        }

        return message;
    }

    public List<ColSummary> findColSummarys(QuerySummaryParam param, FlipInfo flip) throws BusinessException {
        return this.colDao.findColSummarys(param, flip);
    }

    public List<ColSummaryVO> queryByCondition4DataRelation(FlipInfo flipInfo, Map<String, String> condition) throws BusinessException {
        return this.colDao.queryByCondition4DataRelation(flipInfo, condition);
    }

    @AjaxAccess
    public String getAffairState(String affairId) throws BusinessException {
        CtpAffair affair = null;
        String state = "";
        if (Strings.isNotBlank(affairId)) {
            try {
                affair = this.affairManager.getSimpleAffair(Long.valueOf(affairId));
                if (affair != null) {
                    state = String.valueOf(affair.getState());
                }
            } catch (Exception var5) {
                LOG.error(var5);
            }
        }

        return state;
    }

    @AjaxAccess
    public String getRelativeMembers() {
        User user = AppContext.getCurrentUser();
        List<WebEntity4QuickIndex> oml = new ArrayList();
        Object l = new ArrayList();

        try {
            l = this.peopleRelateManager.getPeopleRelatedList(user.getId());
        } catch (Exception var16) {
            LOG.error("", var16);
        }

        Long currentLoginAccId = user.getLoginAccount();
        if (Strings.isNotEmpty((Collection)l)) {
            Iterator var5 = ((List)l).iterator();

            while(true) {
                WebEntity4QuickIndex data;
                while(true) {
                    V3xOrgMember vm;
                    do {
                        do {
                            if (!var5.hasNext()) {
                                return JSONUtil.toJSONString(oml);
                            }

                            PeopleRelate peopleRelate = (PeopleRelate)var5.next();
                            if (oml.size() == 50) {
                                return JSONUtil.toJSONString(oml);
                            }

                            vm = null;

                            try {
                                vm = this.orgManager.getMemberById(peopleRelate.getRelateMemberId());
                            } catch (BusinessException var15) {
                                LOG.error("", var15);
                            }
                        } while(null == vm);
                    } while(!vm.isValid());

                    data = null;
                    V3xOrgDepartment d = null;

                    try {
                        d = this.orgManager.getDepartmentById(vm.getOrgDepartmentId());
                    } catch (BusinessException var14) {
                        LOG.error("", var14);
                    }

                    if (currentLoginAccId.equals(vm.getOrgAccountId())) {
                        data = new WebEntity4QuickIndex("Member|" + vm.getId() + "|" + vm.getOrgAccountId(), vm.getName(), null == d ? "" : d.getName());
                        break;
                    }

                    V3xOrgAccount account = null;

                    try {
                        account = this.orgManager.getAccountById(vm.getOrgAccountId());
                    } catch (BusinessException var13) {
                        LOG.error("", var13);
                    }

                    if (null != account && account.isValid()) {
                        if (vm.getName().contains("(") && vm.getName().contains("-")) {
                            data = new WebEntity4QuickIndex("Member|" + vm.getId() + "|" + vm.getOrgAccountId(), vm.getName(), null == d ? "" : d.getName());
                            break;
                        }

                        data = new WebEntity4QuickIndex("Member|" + vm.getId() + "|" + vm.getOrgAccountId(), vm.getName() + "(" + account.getShortName() + ")", null == d ? "" : d.getName());
                        break;
                    }
                }

                WebEntity4QuickIndex4Col c = new WebEntity4QuickIndex4Col();
                c.setD(data.getD());
                c.setK(data.getK());
                c.setS(data.getS());
                int vlength = data.getV().length();
                String _tv = Strings.toHTML(data.getV());
                c.setSn(vlength <= 38 ? _tv : _tv.substring(38) + "...");
                c.setV(Strings.toHTML(data.getV()));
                oml.add(c);
            }
        } else {
            return JSONUtil.toJSONString(oml);
        }
    }

    @AjaxAccess
    public Map<String, String> showMoreBtn(Map<String, String> map) throws BusinessException {
        Map<String, String> r_map = new HashMap();
        String checkBtnStr = (String)map.get("checkBtns");
        if (checkBtnStr != null) {
            String[] checkBtns = checkBtnStr.split(",");
            String[] var5 = checkBtns;
            int var6 = checkBtns.length;

            for(int var7 = 0; var7 < var6; ++var7) {
                String btn = var5[var7];
                if ("Favorite".equals(btn)) {
                    String collect = "false";
                    User user = AppContext.getCurrentUser();
                    String affairId = (String)map.get("affairId");
                    String collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
                    if (AppContext.hasPlugin(PortletCategory.doc.name()) && "true".equals(collectFlag) && AppContext.hasPlugin("doc")) {
                        List<Map<String, Long>> collectMap = this.docApi.findFavorites(user.getId(), CommonTools.newArrayList(new Long[]{Long.valueOf(affairId)}));
                        if (Strings.isNotEmpty(collectMap)) {
                            collect = "true";
                        }
                    }

                    r_map.put("collect", collect);
                }
            }
        }

        return r_map;
    }

    @AjaxAccess
    public String checkAffairAndLock4NewCol(String summaryId, String isNeedCheckAffair) throws NumberFormatException, BusinessException {
        if (Strings.isEmpty(summaryId)) {
            return ResourceUtil.getString("collaboration.newcoll.check.param.error");
        } else {
            if ("true".equals(isNeedCheckAffair)) {
                Integer state = this.affairManager.getStartAffairStateByObjectId(Long.valueOf(summaryId));
                if (Integer.valueOf(StateEnum.col_sent.key()).equals(state)) {
                    return ResourceUtil.getString("collaboration.newcoll.check.send.error");
                }
            }

            if (Strings.isNotBlank(summaryId)) {
                boolean isLock = this.colLockManager.isLock(Long.valueOf(summaryId));
                if (isLock) {
                    return ResourceUtil.getString("collaboration.summary.notDuplicateSub");
                }
            }

            return "";
        }
    }

    @AjaxAccess
    public String checkAffairValidAndIsLock(String affairId, String canSubmit, String isReadOnly) throws NumberFormatException, BusinessException {
        CtpAffair affair = this.getSimpleAffair4Check(affairId);
        String errorMsg = this.checkAffairValid(affair, true);
        if (Strings.isBlank(errorMsg)) {
            if (affair.getState() != StateEnum.col_pending.key()) {
                errorMsg = ColUtil.getErrorMsgByAffair(affair);
            }

            if (Strings.isNotBlank(affairId)) {
                boolean isLock = this.colLockManager.isLock(Long.valueOf(affairId));
                if (isLock) {
                    errorMsg = ResourceUtil.getString("collaboration.summary.notDuplicateSub");
                } else if (null != affair.getFormRecordid()) {
                    Lock lock = this.formManager.getLock(affair.getFormRecordid());
                    boolean hasLock = Strings.isNotBlank(canSubmit) && "1".equals(canSubmit);
                    boolean _isReadOnly = Strings.isNotBlank(isReadOnly) && ("true".equals(isReadOnly) || "affairReadOnly".equals(isReadOnly));
                    LOG.info("离开页面验证锁lock=" + lock + ",hasLock=" + hasLock + ",_isReadOnly=" + _isReadOnly);
                    if (lock == null && hasLock && !_isReadOnly) {
                        errorMsg = ResourceUtil.getString("collaboration.summary.lock.lost");
                    }
                }
            }
        }

        return errorMsg;
    }

    public void unlockCollAll(Long affairId, CtpAffair affair, ColSummary summary) {
        try {
            if (affairId != null && affairId != -1L) {
                if (affair == null) {
                    affair = this.affairManager.get(affairId);
                }

                if (affair != null && !affair.isDelete()) {
                    if (summary == null) {
                        summary = this.getColSummaryById(affair.getObjectId());
                    }

                    if (summary != null) {
                        try {
                            this.colDelLock(summary, affair, true);
                        } catch (BusinessException var5) {
                            LOG.error("表单锁解锁失败", var5);
                        }
                    }
                }
            }
        } catch (Exception var6) {
            LOG.error("协同解锁失败", var6);
        }

    }

    @AjaxAccess
    public List<Map<String, Object>> pushMessageToMembersList(Map<String, String> params) throws BusinessException {
        return this.pushMessageToMembersList(params, false);
    }

    public List<Map<String, Object>> pushMessageToMembersList(Map<String, String> params, boolean needPost) throws BusinessException {
        Long summaryId = Long.valueOf((String)params.get("summaryId"));
        List<StateEnum> states = new ArrayList();
        states.add(StateEnum.col_sent);
        states.add(StateEnum.col_done);
        states.add(StateEnum.col_pending);
        states.add(StateEnum.col_waitSend);
        List<CtpAffair> pushMessageList = this.affairManager.getAffairs(summaryId, states);
        Collections.sort(pushMessageList, new Comparator<CtpAffair>() {
            public int compare(CtpAffair o1, CtpAffair o2) {
                if (o1.getState() == StateEnum.col_sent.getKey()) {
                    return -1;
                } else if (o2.getState() == StateEnum.col_sent.getKey()) {
                    return 1;
                } else if (o1.getState() == StateEnum.col_done.key()) {
                    return -1;
                } else {
                    return o2.getState() == StateEnum.col_done.key() ? 1 : 0;
                }
            }
        });
        Map<Long, Boolean> memberIdMap = new HashMap(pushMessageList.size());
        List<Map<String, Object>> rset = new ArrayList();
        Long currentUserId = AppContext.currentUserId();
        Iterator var9 = pushMessageList.iterator();

        while(true) {
            CtpAffair r;
            int subState;
            int state;
            Long memberId;
            do {
                do {
                    do {
                        if (!var9.hasNext()) {
                            return rset;
                        }

                        r = (CtpAffair)var9.next();
                        subState = r.getSubState();
                        state = r.getState();
                    } while((subState != SubStateEnum.col_pending_ZCDB.key() || state != StateEnum.col_pending.key()) && state != StateEnum.col_done.key() && state != StateEnum.col_sent.key() && subState != SubStateEnum.col_pending_specialBack.key() && subState != SubStateEnum.col_pending_specialBacked.key() && subState != SubStateEnum.col_pending_specialBackCenter.key() && state != StateEnum.col_pending.key());

                    memberId = r.getMemberId();
                } while(memberId.equals(currentUserId));
            } while(memberIdMap.get(memberId) != null);

            memberIdMap.put(memberId, Boolean.TRUE);
            Map<String, Object> map = new HashMap();
            map.put("state", state);
            map.put("subState", subState);
            map.put("memberId", memberId);
            map.put("backFromId", r.getBackFromId());
            map.put("id", r.getId());
            map.put("name", OrgHelper.showMemberName(memberId));
            if (needPost) {
                V3xOrgMember member = this.orgManager.getMemberById(memberId);
                V3xOrgPost post = this.orgManager.getPostById(member.getOrgPostId());
                if (post != null) {
                    map.put("postName", post.getName());
                }
            }

            if (state == StateEnum.col_sent.getKey()) {
                map.put("i18n", ResourceUtil.getString("cannel.display.column.sendUser.label"));
            } else if (state == StateEnum.col_pending.getKey()) {
                map.put("i18n", ResourceUtil.getString("collaboration.default.currentToDo"));
            } else if (state == StateEnum.col_done.getKey()) {
                map.put("i18n", ResourceUtil.getString("collaboration.default.haveBeenProcessedPe"));
            } else if (subState == SubStateEnum.col_pending_specialBack.getKey()) {
                map.put("i18n", ResourceUtil.getString("collaboration.default.stepBack"));
            } else if (subState == SubStateEnum.col_pending_specialBackCenter.getKey()) {
                map.put("i18n", ResourceUtil.getString("collaboration.default.specialBacked"));
            } else if (state == StateEnum.col_waitSend.getKey() && subState == SubStateEnum.col_pending_specialBacked.getKey()) {
                map.put("i18n", ResourceUtil.getString("cannel.display.column.sendUser.label"));
            } else {
                map.put("i18n", ResourceUtil.getString("collaboration.default.stagedToDo"));
            }

            rset.add(map);
        }
    }

    public void updateColSummaryProcessNodeInfos(String processId, String nodeInfos) {
        this.colDao.updateColSummaryProcessNodeInfos(processId, nodeInfos);
    }

    public LockManagerImpl getLockManager() {
        return this.lockManager;
    }

    public void setLockManager(LockManagerImpl lockManager) {
        this.lockManager = lockManager;
    }
}
