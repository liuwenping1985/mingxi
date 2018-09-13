//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.v3x.services.flow.impl;

import com.seeyon.apps.collaboration.bo.DateSharedWithWorkflowEngineThreadLocal;
import com.seeyon.apps.collaboration.enums.ColHandleType;
import com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState;
import com.seeyon.apps.collaboration.enums.CollaborationEnum.vouchState;
import com.seeyon.apps.collaboration.event.CollaborationStartEvent;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.quartz.CollaborationJob;
import com.seeyon.apps.collaboration.util.ColSelfUtil;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.doc.manager.DocFilingManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairData;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.content.mainbody.MainbodyStatus;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.dao.AttachmentDAO;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.supervise.CtpSuperviseDetail;
import com.seeyon.ctp.common.po.supervise.CtpSupervisor;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.processlog.ProcessLogAction;
import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
import com.seeyon.ctp.common.supervise.manager.SuperviseManager;
import com.seeyon.ctp.common.template.manager.CollaborationTemplateManager;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormAuthViewFieldBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.SubTableField;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.IdentifierUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.XMLCoder;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.vo.CPMatchResultVO;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.oainterface.common.OAInterfaceException;
import com.seeyon.oainterface.common.PropertyList;
import com.seeyon.v3x.project.manager.ProjectManager;
import com.seeyon.v3x.services.ErrorServiceMessage;
import com.seeyon.v3x.services.ServiceException;
import com.seeyon.v3x.services.flow.FlowFactory;
import com.seeyon.v3x.services.flow.FlowUtil;
import com.seeyon.v3x.services.flow.bean.AttachmentExport;
import com.seeyon.v3x.services.flow.bean.FlowExport;
import com.seeyon.v3x.services.flow.bean.TextAttachmentExport;
import com.seeyon.v3x.services.flow.bean.TextHtmlExport;
import com.seeyon.v3x.services.form.bean.DefinitionExport;
import com.seeyon.v3x.services.form.bean.FormExport;
import com.seeyon.v3x.services.form.bean.RecordExport;
import com.seeyon.v3x.services.form.bean.SubordinateFormExport;
import com.seeyon.v3x.services.form.bean.ValueExport;
import com.seeyon.v3x.services.util.SaveFormToXml;
import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import www.seeyon.com.utils.UUIDUtil;

public class FlowFactoryImpl implements FlowFactory {
    private static final Log logger = LogFactory.getLog(FlowFactoryImpl.class);
    private TemplateManager templateManager = null;
    private OrgManager orgManager = null;
    private AffairManager affairManager = null;
    private ColManager colManager = null;
    private FormManager formManager = null;
    private WorkTimeManager workTimeManager = null;
    private CollaborationTemplateManager collaborationTemplateManager = null;
    private IndexManager indexManager = null;
    private AppLogManager appLogManager = null;
    private ProcessLogManager processLogManager = null;
    private FormCacheManager formCacheManager = null;
    private WorkflowApiManager wapi = null;
    private DocHierarchyManager docHierarchyManager = null;
    private ProjectManager projectManager = null;
    private AttachmentManager attachmentManager = null;
    private static FileManager fileManager = null;
    private CommentManager commentManager = null;
    private AttachmentDAO attachmentDAO = null;
    private DocFilingManager docFilingManager = null;
    private SuperviseManager superviseManager = null;
    private UserMessageManager userMessageManager = null;

    public FlowFactoryImpl() {
    }

    public AttachmentManager getAttachmentManager() {
        if(this.attachmentManager == null) {
            this.attachmentManager = (AttachmentManager)AppContext.getBean("attachmentManager");
        }

        return this.attachmentManager;
    }

    public TemplateManager getTemplateManager() {
        if(this.templateManager == null) {
            this.templateManager = (TemplateManager)AppContext.getBean("templateManager");
        }

        return this.templateManager;
    }

    public AffairManager getAffairManager() {
        if(this.affairManager == null) {
            this.affairManager = (AffairManager)AppContext.getBean("affairManager");
        }

        return this.affairManager;
    }

    public ColManager getColManager() {
        if(this.colManager == null) {
            this.colManager = (ColManager)AppContext.getBean("colManager");
        }

        return this.colManager;
    }

    public OrgManager getOrgManager() {
        if(this.orgManager == null) {
            this.orgManager = (OrgManager)AppContext.getBean("orgManager");
        }

        return this.orgManager;
    }

    public FormManager getFormManager() {
        if(this.formManager == null) {
            this.formManager = (FormManager)AppContext.getBean("formManager");
        }

        return this.formManager;
    }

    public WorkTimeManager getWorkTimeManager() {
        if(this.workTimeManager == null) {
            this.workTimeManager = (WorkTimeManager)AppContext.getBean("workTimeManager");
        }

        return this.workTimeManager;
    }

    public CollaborationTemplateManager getCollaborationTemplateManager() {
        if(this.collaborationTemplateManager == null) {
            this.collaborationTemplateManager = (CollaborationTemplateManager)AppContext.getBean("collaborationTemplateManager");
        }

        return this.collaborationTemplateManager;
    }

    public IndexManager getIndexManager() {
        if(this.indexManager == null) {
            this.indexManager = (IndexManager)AppContext.getBean("indexManager");
        }

        return this.indexManager;
    }

    public AppLogManager getAppLogManager() {
        if(this.appLogManager == null) {
            this.appLogManager = (AppLogManager)AppContext.getBean("appLogManager");
        }

        return this.appLogManager;
    }

    public ProcessLogManager getProcessLogManager() {
        if(this.processLogManager == null) {
            this.processLogManager = (ProcessLogManager)AppContext.getBean("processLogManager");
        }

        return this.processLogManager;
    }

    public FormCacheManager getFormCacheManager() {
        if(this.formCacheManager == null) {
            this.formCacheManager = (FormCacheManager)AppContext.getBean("formCacheManager");
        }

        return this.formCacheManager;
    }

    public WorkflowApiManager getWorkflowApiManager() {
        if(this.wapi == null) {
            this.wapi = (WorkflowApiManager)AppContext.getBean("wapi");
        }

        return this.wapi;
    }

    public DocHierarchyManager getDocHierarchyManager() {
        if(this.docHierarchyManager == null) {
            this.docHierarchyManager = (DocHierarchyManager)AppContext.getBean("docHierarchyManager");
        }

        return this.docHierarchyManager;
    }

    public ProjectManager getProjectManager() {
        if(this.projectManager == null) {
            this.projectManager = (ProjectManager)AppContext.getBean("projectManager");
        }

        return this.projectManager;
    }

    public static FileManager getFileManager() {
        if(fileManager == null) {
            fileManager = (FileManager)AppContext.getBean("fileManager");
        }

        return fileManager;
    }

    public CommentManager getCommentManager() {
        if(this.commentManager == null) {
            this.commentManager = (CommentManager)AppContext.getBean("ctpCommentManager");
        }

        return this.commentManager;
    }

    public AttachmentDAO getAttachmentDAO() {
        if(this.attachmentDAO == null) {
            this.attachmentDAO = (AttachmentDAO)AppContext.getBean("attachmentDAO");
        }

        return this.attachmentDAO;
    }

    public DocFilingManager getDocFilingManager() {
        if(this.docFilingManager == null) {
            this.docFilingManager = (DocFilingManager)AppContext.getBean("docFilingManager");
        }

        return this.docFilingManager;
    }

    public SuperviseManager getSuperviseManager() {
        if(this.superviseManager == null) {
            this.superviseManager = (SuperviseManager)AppContext.getBean("superviseManager");
        }

        return this.superviseManager;
    }

    public UserMessageManager getUserMessageManager() {
        if(this.userMessageManager == null) {
            this.userMessageManager = (UserMessageManager)AppContext.getBean("userMessageManager");
        }

        return this.userMessageManager;
    }

    public long sendCollaboration(String senderLoginName, String templateCode, String subject, Object data1, Long[] attachments, String parameter, String relateDoc) throws BusinessException, ServiceException {
        Map<String, Object> relevantParam = new HashMap();
        Long summaryId = Long.valueOf(this.sendCollaboration(senderLoginName, templateCode, subject, data1, attachments, parameter, relateDoc, relevantParam));
        return summaryId.longValue();
    }

    public long sendCollaboration(String senderLoginName, String templateCode, String subject, Object data1, Long[] attachments, String parameter, String relateDoc, Map<String, Object> relevantParam) throws BusinessException, ServiceException {
        CtpTemplate template = this.getTemplateManager().getTempleteByTemplateNumber(templateCode);
        if(template == null) {
            throw new ServiceException(ErrorServiceMessage.flowTempleExist.getErroCode(), ErrorServiceMessage.flowTempleExist.getValue() + ":" + templateCode);
        } else {
            List<Attachment> attachmentList = this.getAttachmentManager().getByReference(template.getId());
            StringBuffer attBuffer = new StringBuffer();
            StringBuffer colBuffer = new StringBuffer();
            StringBuffer edocBuffer = new StringBuffer();
            List<Attachment> meetingAndDoc = new ArrayList();
            colBuffer.append("col|");
            edocBuffer.append("edoc|");
            List<Long> attList = new ArrayList();
            if(attachmentList != null) {
                for(int i = 0; i < attachmentList.size(); ++i) {
                    Attachment attInfo = (Attachment)attachmentList.get(i);
                    if(attInfo != null && attInfo.getType().intValue() == 0) {
                        attList.add(attInfo.getFileUrl());
                    } else if(attInfo != null && attInfo.getType().intValue() == 2 && "collaboration".equals(attInfo.getMimeType())) {
                        colBuffer.append(this.getColManager().getAffairById(attInfo.getFileUrl().longValue()).getObjectId().toString() + ",");
                    } else if(attInfo != null && attInfo.getType().intValue() == 2 && "edoc".equals(attInfo.getMimeType())) {
                        edocBuffer.append(this.getColManager().getAffairById(attInfo.getFileUrl().longValue()).getObjectId().toString() + ",");
                    } else if(attInfo != null && attInfo.getType().intValue() == 2 && "km".equals(attInfo.getMimeType())) {
                        meetingAndDoc.add(attInfo);
                    } else if(attInfo != null && attInfo.getType().intValue() == 2 && "meeting".equals(attInfo.getMimeType())) {
                        meetingAndDoc.add(attInfo);
                    }
                }
            }

            Long[] fileIds = this.getAttachments(attList, attachments);
            if(relateDoc == null && (colBuffer.toString().split("\\|").length >= 2 || edocBuffer.toString().split("\\|").length >= 2)) {
                attBuffer.append(colBuffer.deleteCharAt(colBuffer.length() - 1).toString() + ";");
                attBuffer.append(edocBuffer.deleteCharAt(edocBuffer.length() - 1).toString() + ";");
                relateDoc = attBuffer.toString();
            }

            FormExport data = null;
            FormBean formBean = null;
            boolean isForm = template.getModuleType().intValue() == 1 && Integer.valueOf(template.getBodyType()).intValue() == 20;
            if(isForm) {
                data = (FormExport)data1;
                formBean = this.getFormManager().getFormByFormCode(template);
            }

            V3xOrgMember member = null;

            try {
                member = this.getOrgManager().getMemberByLoginName(senderLoginName);
            } catch (Exception var51) {
                ;
            }

            if(member == null) {
                throw new ServiceException(ErrorServiceMessage.formImportServiceMember.getErroCode(), ErrorServiceMessage.formImportServiceMember.getValue() + ":" + senderLoginName);
            } else {
                long sender = member.getId().longValue();
                User user = new User();
                user.setId(Long.valueOf(sender));
                user.setName(member.getName());
                if(relevantParam.size() > 0 && relevantParam.get("accountId") != null) {
                    user.setLoginAccount((Long)relevantParam.get("accountId"));
                } else {
                    user.setLoginAccount(member.getOrgAccountId());
                }

                user.setLocale((Locale)LocaleContext.getAllLocales().get(0));
                AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
                if(AppContext.getRawSession() != null) {
                    Object raw = AppContext.getSessionContext("com.seeyon.current_user");
                    if(raw != null) {
                        User u = (User)raw;
                        logger.error("操作被阻止，试图将会话中的当前用户" + u.getName() + "替换为" + user.getName());
                    } else {
                        AppContext.putSessionContext("com.seeyon.current_user", user);
                    }
                }

                if(isForm) {
                    this.checkIsExist(data, senderLoginName, templateCode, template, formBean, member);
                }

                Timestamp now = new Timestamp(System.currentTimeMillis());
                String bodyType = template.getBodyType();
                Long templateId = template.getId();
                String sub = Strings.nobreakSpaceToSpace(subject);
                if(StringUtils.isBlank(sub)) {
                    sub = template.getSubject() + "(" + member.getName() + " " + DateUtil.formatDateTime(now) + ")";
                }

                ColSummary summary = this.createColSummary(template);
                summary.setSubject(sub);
                summary.setProjectId(template.getProjectId());
                if(template != null) {
                    summary.setPermissionAccountId(template.getOrgAccountId());
                }

                long masterId = -1L;
                if(isForm) {
                    try {
                        masterId = this.saveMasterAndSubForm(template, data, formBean, user);
                    } catch (SQLException var50) {
                        throw new ServiceException(ErrorServiceMessage.formExportServiceDateInfoError.getErroCode(), ErrorServiceMessage.formExportServiceDateInfoError.getValue() + ":" + var50.getMessage());
                    }
                }

                boolean saveDraft = "1".equals(parameter);
                CPMatchResultVO resultVo = null;
                if(!saveDraft) {
                    resultVo = this.isSelectPersonCondition(isForm, template, member, sender, masterId, user);
                    if(resultVo.isPop()) {
                        saveDraft = true;
                    }
                }

                MainbodyService mainBodyService = MainbodyService.getInstance();
                CtpContentAllBean content = new CtpContentAllBean();
                content.setModuleType(Integer.valueOf(ModuleType.collaboration.getKey()));
                content.setCreateId(Long.valueOf(sender));
                content.setCreateDate(now);
                content.setSort(Integer.valueOf(0));
                content.setId(Long.valueOf(UUIDUtil.getUUIDLong()));
                content.setStatus(MainbodyStatus.STATUS_POST_SAVE);
                content.setContentType(Integer.valueOf(Integer.parseInt(bodyType)));
                content.setTitle(summary.getSubject());
                content.setContentTemplateId(Long.valueOf(0L));
                content.setContentDataId((Long)null);
                if(MainbodyType.FORM.getKey() == content.getContentType().intValue()) {
                    content.setContentType(Integer.valueOf(MainbodyType.FORM.getKey()));
                    content.setContentTemplateId(formBean.getId());
                    content.setContentDataId(Long.valueOf(masterId));
                    summary.setFormAppid(content.getContentTemplateId());
                    summary.setFormRecordid(content.getContentDataId());
                } else {
                    content.setContent("<p>" + data1 + "</p>");
                }

                content.setModuleTemplateId(templateId);
                content.setModuleId(summary.getId());
                content.setModifyDate(now);
                content.setModifyId(Long.valueOf(sender));
                mainBodyService.saveOrUpdateContentAll(content.toContentAll());
                summary.setOrgAccountId(member.getOrgAccountId());
                summary.setOrgDepartmentId(member.getOrgDepartmentId());
                summary.setStartMemberId(Long.valueOf(sender));
                summary.setCreateDate(now);
                summary.setStartDate(now);
                summary.setState(Integer.valueOf(flowState.run.ordinal()));
                summary.setTempleteId(template.getId());
                boolean attaFlag = false;
                if(fileIds != null && fileIds.length != 0) {
                    try {
                        String attaFlagStr = this.getAttachmentManager().create(fileIds, ApplicationCategoryEnum.collaboration, summary.getId(), summary.getId());
                        attaFlag = Constants.isUploadLocaleFile(attaFlagStr);
                    } catch (Exception var49) {
                        throw new BusinessException(var49);
                    }
                }

                Object formContentAttIds = relevantParam.get("formContentAtt");
                Long[] contentAttIds = (Long[])((Long[])formContentAttIds);
                Iterator var41;
                Attachment attInfo;
                int i;
                if(null != contentAttIds && contentAttIds.length > 0) {
                    try {
                        this.getAttachmentManager().create(contentAttIds, ApplicationCategoryEnum.collaboration, summary.getId(), summary.getId());
                        List<Attachment> formAttList = this.getAttachmentManager().getByReference(summary.getId(), summary.getId());
                        int count = 0;
                        var41 = formAttList.iterator();

                        while(var41.hasNext()) {
                            attInfo = (Attachment)var41.next();

                            for(i = 0; i < contentAttIds.length; ++i) {
                                if(attInfo.getFileUrl().equals(contentAttIds[i]) && count < contentAttIds.length) {
                                    attInfo.setSubReference(contentAttIds[i]);
                                    this.getAttachmentManager().update(attInfo);
                                    logger.info("表单正文附件ID上传：" + attInfo.getFilename());
                                }
                            }
                        }
                    } catch (Exception var52) {
                        throw new ServiceException(ErrorServiceMessage.formExportServiceDateInfoError.getErroCode(), ErrorServiceMessage.formExportServiceDateInfoError.getValue() + ":" + var52.getMessage());
                    }
                }

                String toMmembers;
                String[] formInfo;
                if(Strings.isNotBlank(relateDoc)) {
                    String[] temp = relateDoc.split(";");
                    formInfo = null;
                    String[] summaryEdocIds = null;
                    String[] var62 = temp;
                    int var64 = temp.length;

                    for(i = 0; i < var64; ++i) {
                        toMmembers = var62[i];
                        String[] edocInfo;
                        if(toMmembers.startsWith("col")) {
                            edocInfo = toMmembers.split("\\|");
                            if(edocInfo.length >= 2) {
                                formInfo = edocInfo[1].split(",");
                            }
                        } else if(toMmembers.startsWith("edoc")) {
                            edocInfo = toMmembers.split("\\|");
                            if(edocInfo.length >= 2) {
                                summaryEdocIds = edocInfo[1].split(",");
                            }
                        }
                    }

                    if(formInfo != null) {
                        this.loopAttachmentList(summary, formInfo, "col");
                    }

                    if(summaryEdocIds != null) {
                        this.loopAttachmentList(summary, summaryEdocIds, "edoc");
                    }

                    if(meetingAndDoc != null) {
                        var41 = meetingAndDoc.iterator();

                        while(var41.hasNext()) {
                            attInfo = (Attachment)var41.next();
                            Attachment atta = new Attachment();
                            atta.setIdIfNew();
                            atta.setReference(summary.getId());
                            atta.setSubReference(summary.getId());
                            atta.setCategory(attInfo.getCategory());
                            atta.setType(attInfo.getType());
                            atta.setSize(attInfo.getSize());
                            atta.setFilename(attInfo.getFilename());
                            atta.setFileUrl(attInfo.getFileUrl());
                            atta.setMimeType(attInfo.getMimeType());
                            atta.setCreatedate(attInfo.getCreatedate());
                            atta.setDescription(attInfo.getDescription());
                            atta.setGenesisId(attInfo.getGenesisId());
                            this.getAttachmentDAO().save(atta);
                        }
                    }
                }

                if(attaFlag) {
                    ColUtil.setHasAttachments(summary, Boolean.valueOf(attaFlag));
                }

                summary.setCanDueReminder(Boolean.valueOf(false));
                summary.setAudited(Boolean.valueOf(false));
                summary.setVouch(Integer.valueOf(vouchState.defaultValue.ordinal()));
                summary.setBodyType(String.valueOf(content.getContentType()));

                try {
                    summary.setSubject(ColUtil.makeSubject(template, summary, (User)null));
                } catch (Throwable var48) {
                    logger.error(var48.getMessage(), var48);
                }

                CtpAffair affair = new CtpAffair();
                affair.setIdIfNew();
                affair.setCreateDate(now);
                affair.setApp(Integer.valueOf(ApplicationCategoryEnum.collaboration.key()));
                affair.setSubApp(Integer.valueOf(ApplicationSubCategoryEnum.collaboration_tempate.key()));
                affair.setSubject(summary.getSubject());
                affair.setReceiveTime(now);
                affair.setMemberId(Long.valueOf(sender));
                affair.setObjectId(summary.getId());
                affair.setSubObjectId((Long)null);
                affair.setSenderId(Long.valueOf(sender));
                affair.setState(Integer.valueOf(StateEnum.col_sent.key()));
                affair.setSubState(Integer.valueOf(SubStateEnum.col_normal.key()));
                if(saveDraft) {
                    affair.setState(Integer.valueOf(StateEnum.col_waitSend.key()));
                    affair.setSubState(Integer.valueOf(SubStateEnum.col_waitSend_draft.key()));
                }

                affair.setTempleteId(summary.getTempleteId());
                affair.setBodyType(bodyType);
                affair.setImportantLevel(summary.getImportantLevel());
                affair.setResentTime(summary.getResentTime());
                affair.setForwardMember(summary.getForwardMember());
                affair.setNodePolicy("collaboration");
                affair.setTrack(Integer.valueOf(1));
                affair.setDelete(Boolean.valueOf(false));
                affair.setArchiveId((Long)null);
                affair.setFinish(Boolean.valueOf(false));
                affair.setCoverTime(Boolean.valueOf(false));
                affair.setDueRemind(Boolean.valueOf(false));
                affair.setOrgAccountId(member.getOrgAccountId());
                if(summary.getDeadline() != null && summary.getDeadline().longValue() > 0L) {
                    AffairUtil.addExtProperty(affair, AffairExtPropEnums.processPeriod, summary.getDeadline());
                }

                if(saveDraft) {
                    affair.setIdentifier(IdentifierUtil.newIdentifier(affair.getIdentifier(), 20, '0'));
                }

                formInfo = this.wapi.getStartNodeFormPolicy(template.getWorkflowId());
                affair.setFormOperationId(Long.valueOf(formInfo[2]));
                affair.setFormAppId(template.getFormAppId());
                this.getAffairManager().save(affair);
                AffairData affairData = ColUtil.getAffairData(summary);
                Long flowPermAccountId = ColUtil.getFlowPermAccountId(member.getOrgAccountId(), summary);
                affairData.addBusinessData("flowPermAccountId", flowPermAccountId);
                if(MainbodyType.FORM.getKey() == content.getContentType().intValue()) {
                    affairData.setFormAppId(content.getContentTemplateId());
                    affairData.setFormRecordId(content.getContentDataId());
                }

                String[] caseProcessIds = null;
                if(!saveDraft) {
                    caseProcessIds = this.runWorkFlow(template, member, resultVo, summary, user, affairData, affair);
                    summary.setProcessId(caseProcessIds[1]);
                    summary.setCaseId(Long.valueOf(caseProcessIds[0]));
                } else {
                    summary.setStartDate((Date)null);
                    summary.setState((Integer)null);
                    summary.setProcessId("");
                    summary.setCaseId((Long)null);
                }

                ColUtil.updateCurrentNodesInfo(summary);
                this.getColManager().saveColSummary(summary);
                if(summary.getArchiveId() != null) {
                    this.getDocFilingManager().pigeonholeAsLinkWithoutAcl(Integer.valueOf(ApplicationCategoryEnum.collaboration.key()), affair.getId(), ColUtil.isHasAttachments(summary), summary.getArchiveId(), Long.valueOf(sender), (Integer)null);
                }

                this.getCollaborationTemplateManager().updateTempleteHistory(summary.getTempleteId(), Long.valueOf(sender));
                if(saveDraft) {
                    if(String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                        try {
                            List<Comment> commentList = this.getCommentManager().getCommentAllByModuleId(ModuleType.collaboration, summary.getId());
                            this.getFormManager().updateDataState(summary, affair, ColHandleType.save, commentList);
                        } catch (Exception var47) {
                            ;
                        }
                    }
                } else {
                    this.getSuperviseManager().saveSuperviseByCopyTemplete(member.getId().longValue(), summary, template.getId());
                    if(subject == null) {
                        subject = summary.getSubject();
                    }

                    String[] nextNodeNames = caseProcessIds[2].split("[,]");
                    toMmembers = Strings.join(",", nextNodeNames);
                    this.getAppLogManager().insertLog(user, AppLogAction.Coll_New, new String[]{user.getName(), summary.getSubject()});
                    this.getProcessLogManager().insertLog(user, Long.parseLong(summary.getProcessId()), -1L, ProcessLogAction.sendForm, new String[]{toMmembers});
                    CollaborationJob.createQuartzJobOfSummary(summary, this.getWorkTimeManager());
                    if(String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                        try {
                            List<Comment> commentList = this.getCommentManager().getCommentAllByModuleId(ModuleType.collaboration, summary.getId());
                            this.getFormManager().updateDataState(summary, affair, ColHandleType.send, commentList);
                        } catch (Exception var46) {
                            ;
                        }
                    }

                    DateSharedWithWorkflowEngineThreadLocal.setColSummary(summary);
                    CollaborationStartEvent event = new CollaborationStartEvent(this);
                    event.setSummaryId(summary.getId());
                    event.setFrom("pc");
                    event.setAffair(affair);
                    EventDispatcher.fireEvent(event);
                    ColSelfUtil.fireAutoSkipEvent(this);
                }

                if(AppContext.hasPlugin("index")) {
                    if(String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
                        this.getIndexManager().add(summary.getId(), Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                    } else {
                        this.getIndexManager().add(summary.getId(), Integer.valueOf(ApplicationCategoryEnum.collaboration.getKey()));
                    }
                }

                return summary.getId().longValue();
            }
        }
    }

    private void loopAttachmentList(ColSummary summary, String[] summaryIds, String Type) throws BusinessException {
        String[] var4 = summaryIds;
        int var5 = summaryIds.length;

        for(int var6 = 0; var6 < var5; ++var6) {
            String summaryId = var4[var6];
            List<CtpAffair> affairs = this.getAffairManager().getAffairs(Long.valueOf(summaryId), StateEnum.col_sent);
            if(affairs != null && affairs.size() == 1) {
                CtpAffair affair = (CtpAffair)affairs.get(0);
                Attachment atta = new Attachment();
                atta.setIdIfNew();
                atta.setReference(summary.getId());
                atta.setSubReference(summary.getId());
                atta.setCategory(Integer.valueOf("col".equals(Type)?ApplicationCategoryEnum.collaboration.ordinal():ApplicationCategoryEnum.edoc.ordinal()));
                atta.setType(Integer.valueOf(2));
                atta.setSize(Long.valueOf(0L));
                atta.setFilename(affair.getSubject());
                atta.setFileUrl(affair.getId());
                atta.setMimeType("col".equals(Type)?"collaboration":"edoc");
                atta.setCreatedate(affair.getCreateDate());
                atta.setDescription(affair.getId() + "");
                atta.setGenesisId(affair.getId());
                this.getAttachmentDAO().save(atta);
            }
        }

    }

    private Long[] getAttachments(List<Long> attList, Long[] fileIds) {
        if(CollectionUtils.isNotEmpty(attList)) {
            int attacSizeThirdParty = fileIds != null?fileIds.length:0;
            Long[] fileIdTemp = new Long[attacSizeThirdParty + attList.size()];

            int i;
            for(i = 0; i < attacSizeThirdParty; ++i) {
                fileIdTemp[i] = fileIds[i];
            }

            for(i = 0; i < attList.size(); ++i) {
                fileIdTemp[attacSizeThirdParty + i] = (Long)attList.get(i);
            }

            fileIds = fileIdTemp;
        }

        return fileIds;
    }

    private void sendSuperviseMessage(String subject, V3xOrgMember member, User user, Long templateId, ColSummary summary) throws BusinessException {
        Set<Long> templateIdSets = this.getSuperviseManager().parseTemplateSupervisorIds(templateId, member.getId());
        CtpSupervisor ctpPeop = null;
        List<CtpSupervisor> surpeople = new ArrayList();
        CtpSuperviseDetail moduleDetail = new CtpSuperviseDetail();
        moduleDetail.setIdIfNew();
        if(Strings.isNotEmpty(templateIdSets)) {
            Iterator var10 = templateIdSets.iterator();

            while(var10.hasNext()) {
                Long mid = (Long)var10.next();
                ctpPeop = new CtpSupervisor();
                ctpPeop.setSupervisorId(mid);
                ctpPeop.setIdIfNew();
                ctpPeop.setSuperviseId(moduleDetail.getId());
                surpeople.add(ctpPeop);
            }
        }

        String hastenType = "col.supervise.hasten";
        String linkType = "message.link.col.supervise";
        int forwardMemberFlag = 0;
        String forwardMember = null;
        int ImportantLevel = 1;
        ApplicationCategoryEnum app = ApplicationCategoryEnum.collaboration;
        List<MessageReceiver> receivers = new ArrayList();
        MessageReceiver receiver = null;
        List<Long> members = new ArrayList();
        if(surpeople != null) {
            Iterator var19 = surpeople.iterator();

            while(var19.hasNext()) {
                CtpSupervisor colSupervisor = (CtpSupervisor)var19.next();
                if(!user.getId().equals(colSupervisor.getSupervisorId()) && !members.contains(colSupervisor.getSupervisorId())) {
                    receiver = new MessageReceiver(moduleDetail.getId(), colSupervisor.getSupervisorId().longValue(), linkType, new Object[]{summary.getId()});
                    receivers.add(receiver);
                    members.add(colSupervisor.getSupervisorId());
                }
            }
        }

        if(receivers != null) {
            this.getUserMessageManager().sendSystemMessage((new MessageContent(hastenType, new Object[]{subject, member.getName(), Integer.valueOf(forwardMemberFlag), forwardMember})).setImportantLevel(Integer.valueOf(ImportantLevel)), app, user.getId().longValue(), receivers, new Object[]{Integer.valueOf(7)});
        }

    }

    private ColSummary createColSummary(CtpTemplate template) {
        String strXml = template.getSummary();
        ColSummary summary = (ColSummary)XMLCoder.decoder(strXml);
        summary.setIdIfNew();
        return summary;
    }

    private void checkIsExist(FormExport data, String loginName, String templateCode, CtpTemplate template, FormBean formBean, V3xOrgMember member) throws ServiceException {
        if(template.getWorkflowId() == null) {
            throw new ServiceException(ErrorServiceMessage.flowTempleExist.getErroCode(), ErrorServiceMessage.flowTempleExist.getValue() + ":" + templateCode);
        } else if(formBean == null) {
            throw new ServiceException(ErrorServiceMessage.formImportServiceIsexit.getErroCode(), ErrorServiceMessage.formImportServiceIsexit.getValue() + ":" + templateCode);
        } else if(formBean.getFormType() != FormType.baseInfo.getKey() && formBean.getFormType() != FormType.manageInfo.getKey()) {
            if(member == null) {
                throw new ServiceException(ErrorServiceMessage.formImportServiceMember.getErroCode(), ErrorServiceMessage.formImportServiceMember.getValue() + ":" + loginName);
            } else {
                String bodyType = template.getBodyType();
                if(!String.valueOf(MainbodyType.FORM.getKey()).equals(bodyType)) {
                    throw new ServiceException(ErrorServiceMessage.flowValidContent.getErroCode(), ErrorServiceMessage.flowValidContent.getValue());
                } else {
                    try {
                        boolean auth = this.getTemplateManager().isTemplateEnabled(template.getId(), member.getId());
                        if(!auth) {
                            throw new ServiceException(ErrorServiceMessage.flowTempleAuth.getErroCode(), ErrorServiceMessage.flowTempleAuth.getValue() + ":" + templateCode + " " + member.getName());
                        }
                    } catch (BusinessException var18) {
                        throw new ServiceException(ErrorServiceMessage.flowTempleAuth.getErroCode(), ErrorServiceMessage.flowTempleAuth.getValue() + ":" + templateCode + " " + member.getName() + var18.getMessage());
                    }

                    Map<String, String> masterNameValues = new HashMap();
                    Iterator var9 = data.getValues().iterator();

                    while(var9.hasNext()) {
                        ValueExport value = (ValueExport)var9.next();
                        masterNameValues.put(value.getDisplayName(), value.getValue());
                    }

                    List<Map<String, String>> slaveNameValues = new ArrayList();
                    Iterator var21 = data.getSubordinateForms().iterator();

                    while(var21.hasNext()) {
                        SubordinateFormExport subFormExport = (SubordinateFormExport)var21.next();
                        Iterator var12 = subFormExport.getValues().iterator();

                        while(var12.hasNext()) {
                            RecordExport recordExport = (RecordExport)var12.next();
                            Map<String, String> subDataMap = new HashMap();
                            Iterator var15 = recordExport.getRecord().iterator();

                            while(var15.hasNext()) {
                                ValueExport v = (ValueExport)var15.next();
                                subDataMap.put(v.getDisplayName(), v.getValue());
                            }

                            slaveNameValues.add(subDataMap);
                        }
                    }

                    try {
                        String operationId = this.getWorkflowApiManager().getNodeFormOperationName(template.getWorkflowId(), (String)null);
                        FormService.checkInputData(formBean.getId().longValue(), -1L, Long.valueOf(operationId).longValue(), masterNameValues, slaveNameValues, -1L);
                    } catch (Exception var17) {
                        throw new ServiceException(ErrorServiceMessage.formExportServiceDateInfoError.getErroCode(), ErrorServiceMessage.formExportServiceDateInfoError.getValue() + ":" + var17.getMessage());
                    }
                }
            }
        } else {
            throw new ServiceException(ErrorServiceMessage.flowImportException.getErroCode(), ErrorServiceMessage.flowImportException.getValue());
        }
    }

    private String[] runWorkFlow(CtpTemplate template, V3xOrgMember member, CPMatchResultVO resultVo, ColSummary summary, User user, AffairData affairData, CtpAffair affair) throws BPMException {
        WorkflowBpmContext context = new WorkflowBpmContext();
        context.setAppName(ModuleType.collaboration.name());
        context.setStartUserId(String.valueOf(member.getId()));
        context.setStartUserName(member.getName());
        context.setStartAccountId(String.valueOf(user.getLoginAccount()));
        context.setStartAccountName("seeyon");
        context.setCurrentAccountId(String.valueOf(user.getLoginAccount()));
        context.setBusinessData("CTP_AFFAIR_DATA", affairData);
        context.setBusinessData("bizObject", summary);
        context.setBusinessData("ColSummary", summary);
        context.setBusinessData("operationType", affairData.getBusinessData().get("operationType"));
        context.setProcessTemplateId(String.valueOf(template.getWorkflowId()));
        String conditon_Str = this.getConditonStr(resultVo);
        logger.info("conditon_Str:=" + conditon_Str);
        context.setConditionsOfNodes(conditon_Str.toString());
        context.setVersion("2.0");
        if(affairData.getFormRecordId() != null && affairData.getFormRecordId().longValue() != -1L) {
            context.setMastrid("" + affairData.getFormRecordId());
            context.setFormData("" + affairData.getFormAppId());
        }

        context.setBusinessData("CtpAffair", affair);
        return this.getWorkflowApiManager().transRunCaseFromTemplate(context);
    }

    private String getConditonStr(CPMatchResultVO resultVo) {
        StringBuilder conditon_Str = new StringBuilder();
        Set<String> allSelectNodes = resultVo.getAllSelectNodes();
        conditon_Str.append("{\"condition\":[");
        Iterator var4 = allSelectNodes.iterator();

        String vauleString;
        while(var4.hasNext()) {
            vauleString = (String)var4.next();
            conditon_Str.append("{\"nodeId\":\"" + vauleString + "\",");
            conditon_Str.append("\"isDelete\":\"false\"},");
        }

        Set<String> allNotSelectNodes = resultVo.getAllNotSelectNodes();
        Iterator var7 = allNotSelectNodes.iterator();

        while(var7.hasNext()) {
            String value = (String)var7.next();
            conditon_Str.append("{\"nodeId\":\"" + value + "\",");
            conditon_Str.append("\"isDelete\":\"true\"},");
        }

        vauleString = StringUtils.removeEnd(conditon_Str.toString(), ",");
        return vauleString + "]}";
    }

    private CPMatchResultVO isSelectPersonCondition(boolean isForm, CtpTemplate template, V3xOrgMember member, long sender, long masterId, User user) throws BPMException {
        WorkflowBpmContext wfContext = new WorkflowBpmContext();
        wfContext.setProcessId((String)null);
        wfContext.setCaseId(-1L);
        wfContext.setCurrentActivityId((String)null);
        wfContext.setCurrentWorkitemId(-1L);
        if(isForm) {
            wfContext.setMastrid(String.valueOf(masterId));
            wfContext.setFormData(String.valueOf(masterId));
        }

        wfContext.setStartUserId(String.valueOf(member.getId()));
        wfContext.setCurrentUserId(String.valueOf(sender));
        wfContext.setProcessTemplateId(String.valueOf(template.getWorkflowId()));
        wfContext.setAppName(ModuleType.collaboration.name());
        wfContext.setStartAccountId(String.valueOf(user.getLoginAccount()));
        wfContext.setCurrentAccountId(String.valueOf(user.getLoginAccount()));
        CPMatchResultVO result = this.getWorkflowApiManager().transBeforeInvokeWorkFlow(wfContext, new CPMatchResultVO());
        return result;
    }

    private long saveMasterAndSubForm(CtpTemplate template, FormExport data, FormBean formBean, User user) throws BusinessException, SQLException {

        System.out.println("----------- i am in ---------");
        String operationId = this.getWorkflowApiManager().getNodeFormOperationName(template.getWorkflowId(), (String)null);
        FormAuthViewBean viewBean = this.getFormCacheManager().getAuth(Long.parseLong(operationId));
        long masterid = 0L;
        FormTableBean masterTableBean = formBean.getMasterTableBean();
        Map<String, Object> mainDataMap = new LinkedHashMap();
        Iterator var11 = data.getValues().iterator();

        while(var11.hasNext()) {
            ValueExport value = (ValueExport)var11.next();
            if(StringUtils.isNotBlank(value.getValue())) {
                FormFieldBean fieldBean = masterTableBean.getFieldBeanByDisplay(value.getDisplayName());
                if(fieldBean != null) {
                    mainDataMap.put(fieldBean.getName(), value.getValue());
                }
            }
        }

        FormDataMasterBean masterData = FormDataMasterBean.newInstance(formBean, viewBean);
        masterData.addFieldValue(mainDataMap);
        masterData.putExtraAttr("needProduceValue", "true");
        masterid = masterData.getId().longValue();
        List<FormTableBean> tableList = formBean.getSubTableBean();
        Iterator var29 = tableList.iterator();

        while(var29.hasNext()) {
            FormTableBean table = (FormTableBean)var29.next();
            String tableName = table.getTableName();
            Iterator var16 = data.getSubordinateForms().iterator();
            System.out.println(" sub forms:"+data.getSubordinateForms().size());
            label77:
            while(var16.hasNext()) {
                SubordinateFormExport subFormExport = (SubordinateFormExport)var16.next();
                Iterator var18 = subFormExport.getValues().iterator();

                while(true) {
                    while(true) {
                        LinkedHashMap subDataMap;
                        label66:
                        do {
                            if(!var18.hasNext()) {
                                continue label77;
                            }

                            RecordExport recordExport = (RecordExport)var18.next();
                            subDataMap = null;
                            Iterator var21 = recordExport.getRecord().iterator();

                            while(true) {
                                ValueExport v;
                                FormFieldBean fieldBean;
                                FormAuthViewFieldBean filedBean;
                                do {
                                    do {
                                        if(!var21.hasNext()) {
                                            continue label66;
                                        }

                                        v = (ValueExport)var21.next();
                                        fieldBean = table.getFieldBeanByDisplay(v.getDisplayName());
                                    } while(fieldBean == null);

                                    filedBean = viewBean.getFormAuthorizationField(fieldBean.getName());
                                    if(subDataMap == null) {
                                        subDataMap = new LinkedHashMap();
                                    }
                                } while(!filedBean.getAccess().equals(FieldAccessType.add.name()) && !filedBean.getAccess().equals(FieldAccessType.edit.name()));

                                subDataMap.put(fieldBean.getName(), v.getValue());
                            }
                        } while(subDataMap == null);
                        System.out.println("-------->>>subDataMap:"+subDataMap);
                        subDataMap.put(SubTableField.formmain_id.getKey(), Long.valueOf(masterid));
                        System.out.println("-------->>>subDataMap:"+subDataMap);
                        List<FormDataSubBean> subDatas = masterData.getSubData(table.getTableName());
                        if(subDatas != null && subDatas.size() == 1 && ((FormDataSubBean)subDatas.get(0)).isEmpty()) {
                            ((FormDataSubBean)subDatas.get(0)).addFieldValue(subDataMap);
                        } else {
                            FormDataSubBean subData = new FormDataSubBean(subDataMap, table, masterData, new boolean[]{true});
                            masterData.addSubData(tableName, subData);
                        }
                    }
                }
            }
        }

        this.getFormManager().putSessioMasterDataBean(formBean, masterData);
        this.getFormManager().calcAll(formBean, masterData, viewBean, false, false, true);
        FormService.saveOrUpdateFormData(masterData, formBean.getId());
        return masterid;
    }

    public long getFlowState(String token, long flowId) throws ServiceException {
        ColSummary summary;
        try {
            summary = this.getColManager().getColSummaryById(Long.valueOf(flowId));
        } catch (BusinessException var6) {
            throw new ServiceException(ErrorServiceMessage.documentExportFlowExist.getErroCode(), ErrorServiceMessage.documentExportFlowExist.getValue());
        }

        if(summary == null) {
            throw new ServiceException(ErrorServiceMessage.documentExportFlowExist.getErroCode(), ErrorServiceMessage.documentExportFlowExist.getValue());
        } else {
            int state = FlowUtil.getFlowState(this.getAffairManager(), summary);
            return NumberUtils.toLong(String.valueOf(state));
        }
    }

    public String[] getTemplateDefinition(String token, String templateCode) throws ServiceException {
        CtpTemplate template = this.getTemplateManager().getTempleteByTemplateNumber(templateCode);
        if(template != null && template.getWorkflowId() != null) {
            String[] result = new String[2];
            FlowExport flowExport = new FlowExport();
            ColSummary summary = this.createColSummary(template);
            flowExport.setFlowTitle(template.getSubject());
            flowExport.setImportantLevel(summary.getImportantLevel().intValue());
            flowExport.setFlowFolder(FlowUtil.getFolder(this.getDocHierarchyManager(), summary));
            flowExport.setFlowProject(FlowUtil.getProject(this.getProjectManager(), summary));
            String bodyType = template.getBodyType();
            if(!bodyType.equals(String.valueOf(MainbodyType.HTML.getKey())) && !bodyType.equals(String.valueOf(MainbodyType.TXT.getKey()))) {
                if(bodyType.equals(String.valueOf(MainbodyType.FORM.getKey()))) {
                    FormExport export = new FormExport();

                    FormBean formBean;
                    try {
                        formBean = this.getFormManager().getFormByFormCode(template);
                    } catch (BusinessException var24) {
                        throw new ServiceException(var24.getLocalizedMessage());
                    }

                    List<DefinitionExport> define = new ArrayList();
                    List<SubordinateFormExport> subordinateFormExport = new ArrayList();
                    export.setSubordinateForms(subordinateFormExport);
                    FormTableBean masterTableBean = formBean.getMasterTableBean();
                    export.setFormName(masterTableBean.getTableName());
                    export.setDefinitions(define);
                    List<FormFieldBean> fieldBean = masterTableBean.getFields();
                    Iterator var14 = fieldBean.iterator();

                    while(var14.hasNext()) {
                        FormFieldBean field = (FormFieldBean)var14.next();
                        FlowUtil.getDefinition(field, define);
                        logger.debug(field.getDisplay() + " " + field.getFieldType() + " ");
                    }

                    List<FormTableBean> subtalbes = formBean.getSubTableBean();
                    Iterator var31 = subtalbes.iterator();

                    while(var31.hasNext()) {
                        FormTableBean formTableBean = (FormTableBean)var31.next();
                        SubordinateFormExport sub = new SubordinateFormExport();
                        List<DefinitionExport> subDefine = new ArrayList();
                        sub.setDefinitions(subDefine);
                        subordinateFormExport.add(sub);
                        List<FormFieldBean> subfieldBeans = formTableBean.getFields();
                        Iterator var20 = subfieldBeans.iterator();

                        while(var20.hasNext()) {
                            FormFieldBean subFieldValue = (FormFieldBean)var20.next();
                            FlowUtil.getDefinition(subFieldValue, subDefine);
                            logger.debug(subFieldValue.getDisplay() + " " + subFieldValue.getFieldType() + " ");
                        }
                    }

                    flowExport.setFlowContent(export);

                    try {
                        result[1] = this.toString(export.saveToPropertyList());
                    } catch (OAInterfaceException var23) {
                        ;
                    }
                } else {
                    CtpContentAll ctpContentAll = this.getContentAll(template);
                    TextAttachmentExport te = convertOfficeBody(bodyType, ctpContentAll.getContent(), ctpContentAll.getCreateDate());
                    flowExport.setFlowContent(te);
                }
            } else {
                TextHtmlExport te = new TextHtmlExport();
                CtpContentAll ctpContentAll = this.getContentAll(template);
                te.setContext(ctpContentAll.getContent());
                flowExport.setFlowContent(te);
            }

            flowExport.setFlowFolder(FlowUtil.getFolder(this.getDocHierarchyManager(), summary));
            flowExport.setFlowProject(FlowUtil.getProject(this.getProjectManager(), summary));
            List<AttachmentExport> ret = FlowUtil.createAttachment(getFileManager(), this.getAttachmentManager(), template.getId().longValue());
            flowExport.setAttachmentList(ret);

            try {
                result[0] = this.toString(flowExport.saveToPropertyList());
            } catch (OAInterfaceException var22) {
                ;
            }

            return result;
        } else {
            throw new ServiceException(ErrorServiceMessage.flowTempleExist.getErroCode(), ErrorServiceMessage.flowTempleExist.getValue() + ":" + templateCode);
        }
    }

    private CtpContentAll getContentAll(CtpTemplate template) {
        Map<String, Object> param = new HashMap();
        param.put("ID", template.getBody());
        List<CtpContentAll> contentAllList = DBAgent.find("from CtpContentAll c  where c.id=:ID", param);
        CtpContentAll ctpContentAll = (CtpContentAll)contentAllList.get(0);
        return ctpContentAll;
    }

    public static TextAttachmentExport convertOfficeBody(String bodyType, String content, Date createDate) {
        TextAttachmentExport te = new TextAttachmentExport();

        try {
            File file = getFileManager().getStandardOffice(Long.valueOf(content), createDate);
            te.setId(Long.valueOf(content).longValue());
            te.setType(convertBodyType(bodyType));
            te.setDownloadpath("");
            if(file != null) {
                te.setAbsolutepath(file.getAbsolutePath());
                String name = file.getName() == null?"":file.getName();
                int loc = name.lastIndexOf(46);
                if(loc > -1 && loc != name.length()) {
                    te.setFilesuffix(name.substring(loc));
                } else {
                    te.setFilesuffix("");
                }
            } else {
                te.setFilesuffix("");
                logger.info("文件id为：【" + content + "】，创建日期为【" + createDate + "】的文件未找到");
            }
        } catch (Exception var7) {
            logger.error(var7);
        }

        return te;
    }

    public static int convertBodyType(String bodyType) {
        int ret = MainbodyType.OfficeExcel.getKey();
        if(bodyType.equals(MainbodyType.OfficeExcel.getKey() + "")) {
            ret = 2;
        } else if(bodyType.equals(MainbodyType.OfficeWord.getKey() + "")) {
            ret = 1;
        } else if(bodyType.equals(MainbodyType.WpsExcel.getKey() + "")) {
            ret = 4;
        } else if(bodyType.equals(MainbodyType.WpsWord.getKey() + "")) {
            ret = 3;
        } else if(bodyType.equals(MainbodyType.Pdf.getKey() + "")) {
            ret = 5;
        }

        return ret;
    }

    private String toString(PropertyList props) {
        StringWriter writer = new StringWriter();

        try {
            props.saveXMLToStream(writer);
        } catch (IOException var4) {
            ;
        }

        return writer.toString();
    }

    public String getTemplateXml(String templateCode) throws ServiceException {
        CtpTemplate template = this.getTemplateManager().getTempleteByTemplateNumber(templateCode);
        String result = "";
        if(template != null && template.getWorkflowId() != null) {
            String bodyType = template.getBodyType();
            if(bodyType.equals(String.valueOf(MainbodyType.FORM.getKey()))) {
                FormExport export = new FormExport();

                FormBean formBean;
                try {
                    formBean = this.getFormManager().getFormByFormCode(template);
                } catch (BusinessException var19) {
                    throw new ServiceException(var19.getLocalizedMessage());
                }

                List<DefinitionExport> define = new ArrayList();
                List<SubordinateFormExport> subordinateFormExport = new ArrayList();
                export.setSubordinateForms(subordinateFormExport);
                FormTableBean masterTableBean = formBean.getMasterTableBean();
                export.setFormName(masterTableBean.getTableName());
                export.setDefinitions(define);
                List<FormFieldBean> fieldBean = masterTableBean.getFields();
                Iterator var11 = fieldBean.iterator();

                while(var11.hasNext()) {
                    FormFieldBean field = (FormFieldBean)var11.next();
                    FlowUtil.getDefinition(field, define);
                    logger.debug(field.getDisplay() + " " + field.getFieldType() + " ");
                }

                List<FormTableBean> subtalbes = formBean.getSubTableBean();
                Iterator var21 = subtalbes.iterator();

                while(var21.hasNext()) {
                    FormTableBean formTableBean = (FormTableBean)var21.next();
                    SubordinateFormExport sub = new SubordinateFormExport();
                    List<DefinitionExport> subDefine = new ArrayList();
                    sub.setDefinitions(subDefine);
                    subordinateFormExport.add(sub);
                    List<FormFieldBean> subfieldBeans = formTableBean.getFields();
                    Iterator var17 = subfieldBeans.iterator();

                    while(var17.hasNext()) {
                        FormFieldBean subFieldValue = (FormFieldBean)var17.next();
                        FlowUtil.getDefinition(subFieldValue, subDefine);
                        logger.debug(subFieldValue.getDisplay() + " " + subFieldValue.getFieldType() + " ");
                    }
                }

                result = this.toXml(export);
            }

            return result;
        } else {
            throw new ServiceException(ErrorServiceMessage.flowTempleExist.getErroCode(), ErrorServiceMessage.flowTempleExist.getValue() + ":" + templateCode);
        }
    }

    private String toXml(FormExport export) {
        StringWriter writer = new StringWriter();

        try {
            SaveFormToXml.getInstance().saveXMLToStream(writer, export);
        } catch (IOException var4) {
            var4.printStackTrace();
        }

        return writer.toString();
    }
}
