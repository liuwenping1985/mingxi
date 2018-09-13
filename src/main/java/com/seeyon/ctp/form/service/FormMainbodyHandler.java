//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.form.service;

import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.constants.ColConstant.NewflowType;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants.login_sign;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyStatus;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.content.mainbody.handler.MainbodyHandler;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.lbs.manager.LbsManager;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.lock.Lock;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormAuthViewFieldBean;
import com.seeyon.ctp.form.bean.FormAuthorizationTableBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean;
import com.seeyon.ctp.form.bean.FormDataBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFormulaBean;
import com.seeyon.ctp.form.bean.FormQueryTypeEnum;
import com.seeyon.ctp.form.bean.FormQueryWhereClause;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.formContent.FormContentManager;
import com.seeyon.ctp.form.formContent.IFormContent;
import com.seeyon.ctp.form.modules.bind.FormLogManager;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataDAO;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationManager;
import com.seeyon.ctp.form.modules.event.FormDataAfterSubmitEvent;
import com.seeyon.ctp.form.modules.event.FormDataBeforeSubmitEvent;
import com.seeyon.ctp.form.modules.serialNumber.SerialCalRecordManager;
import com.seeyon.ctp.form.modules.serialNumber.SerialNumberManager;
import com.seeyon.ctp.form.modules.trigger.FormTriggerManager;
import com.seeyon.ctp.form.po.FormRelation;
import com.seeyon.ctp.form.po.FormRelationRecord;
import com.seeyon.ctp.form.po.FormSerialCalculateRecord;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.form.util.StringUtils;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormDataStateEnum;
import com.seeyon.ctp.form.util.Enums.FormLogOperateType;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.TemplateType;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.rest.resources.vo.FormMasterTableBeanRestVO;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.system.signet.manager.SignetManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import www.seeyon.com.utils.UUIDUtil;

public class FormMainbodyHandler implements MainbodyHandler {
    private static final Log LOGGER = CtpLogFactory.getLog(FormMainbodyHandler.class);
    private static final String ADD_DEL_IMG_HTML = "<DIV class=\"hidden\" style=\"position:relative;width:16px;visibility:hidden;\" id=\"img\" name=\"img\"><DIV id=\"addDiv\"><span id=\"addImg\" class=\"ico16 repeater_plus_16\"></span></DIV><DIV id=\"addEmptyDiv\"><span id=\"addEmptyImg\" class=\"ico16 blank_plus_16\"></span></DIV><DIV id=\"delDiv\"><span id=\"delImg\" class=\"ico16 repeater_reduce_16\"></span></DIV></DIV>";
    private static final String ADD_DEL_DELALL_IMG_HTML = "<DIV class=\"hidden\" style=\"position:relative;width:16px;visibility:hidden;\" id=\"img\" name=\"img\"><DIV id=\"addDiv\"><span id=\"addImg\" class=\"ico16 repeater_plus_16\"></span></DIV><DIV id=\"addEmptyDiv\"><span id=\"addEmptyImg\" class=\"ico16 blank_plus_16\"></span></DIV><DIV id=\"delDiv\"><span id=\"delImg\" class=\"ico16 repeater_reduce_16\"></span><span id=\"delAllImg\" class=\"ico16 permanently_delete_16\" style=\"display:block\"></span></DIV></DIV>";
    private static final String RELATION_DOCUMENT_HTML = "<div class=\"comp\" comp=\"type:'fileupload'\"></div>";
    private static final String IN_EXCEL_HTML = "<input id=\"dataImport\" type=\"hidden\" class=\"comp hidden\" comp=\"type:'fileupload',applicationCategory:'2',extensions:'xls,xlsx',quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'excelImport',callMethod:'dataImportCall'\">";
    private static final String SCAN_CODE_INPUT_HTML = "<div class=\"hidden font_size12\" style=\"position:absolute;right:20px;top:20px;width:50px;height:50px;line-height:90px;visibility:hidden;\" id=\"scan\" name=\"scan\"><span id=\"scan_img\" title=\"@title@\" class=\"form_scan_img\" style=\"cursor:pointer;\"></span></div>";
    private FormManager formManager;
    private FormCacheManager formCacheManager;
    private FormDataDAO formDataDAO;
    private FormRelationManager formRelationManager;
    private FormTriggerManager formTriggerManager;
    private FormLogManager formLogManager;
    private FormDataManager formDataManager;
    private SerialCalRecordManager serialCalRecordManager;
    private SerialNumberManager serialNumberManager;
    private CollaborationApi collaborationApi;
    private LbsManager lbsManager;
    private IndexManager indexManager;
    FormContentManager formContentManager;
    private WorkflowApiManager wapi;
    private static final String canNotFindAuthErr = "表单操作权限找不到，请联系表单管理员重新调整该应用绑定的节点权限。";
    private static final String MODIFIED_FIELD_KEY = "MODIFIED_FIELD_KEY";

    public FormMainbodyHandler() {
    }

    public MainbodyType getType() {
        return MainbodyType.FORM;
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public boolean checkRight(CtpContentAllBean content, HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        long formId = content.getContentTemplateId().longValue();
        FormBean fb = this.formCacheManager.getForm(formId);
        if(fb == null) {
            return true;
        } else {
            if(content.getViewState().intValue() == 4) {
                ;
            }

            FormType formType = FormType.getEnumByKey(fb.getFormType());
            if(!formType.isUnFlowForm()) {
                return true;
            } else if(content.getViewState().intValue() != 2 && !"scanInput".equals(String.valueOf(content.getAttr("openFrom")))) {
                return true;
            } else {
                List<FormBindAuthBean> list = fb.getBind().getUnflowFormBindAuthByUserId(Long.valueOf(AppContext.currentUserId()));
                if(Strings.isEmpty(list)) {
                    return false;
                } else {
                    Iterator var9 = list.iterator();

                    FormFormulaBean formulaBean;
                    do {
                        if(!var9.hasNext()) {
                            boolean canOpen = false;
                            Long contentDataId = content.getContentDataId();
                            AppContext.putThreadContext("check_right_data_id", contentDataId);
                            FlipInfo flipInfo = new FlipInfo();
                            this.formDataManager.getFormQueryResult(Long.valueOf(AppContext.currentUserId()), flipInfo, false, fb, (Long)null, FormQueryTypeEnum.unFlowCheckRight, (FormQueryWhereClause)null, (List)null, (String[])null, (FormQueryWhereClause)null, false);
                            AppContext.removeThreadContext("check_right_data_id");
                            if(flipInfo.getData().size() > 0) {
                                canOpen = true;
                            }

                            return canOpen;
                        }

                        FormBindAuthBean authBean = (FormBindAuthBean)var9.next();
                        formulaBean = authBean.getFormFormulaBean();
                    } while(formulaBean != null);

                    return true;
                }
            }
        }
    }

    public ApplicationCategoryEnum getCategoryEnum(CtpContentAllBean content) throws BusinessException {
        return ApplicationCategoryEnum.form;
    }

    public void handleContentView(CtpContentAllBean contentAll) throws BusinessException {
        Object fromCopy = contentAll.getAttr("fromCopy");
        if(fromCopy == null || ((Long)fromCopy).longValue() == -1L) {
            this.findSourceContent(contentAll);
        }

        StringBuilder sb = new StringBuilder();
        Locale locale = AppContext.getLocale();
        String localeStr = "zh-cn";
        if(locale.equals(Locale.ENGLISH)) {
            localeStr = "en";
        } else if(locale.equals(Locale.TRADITIONAL_CHINESE)) {
            localeStr = "zh-tw";
        }

        sb.append("<script type=\"text/javascript\" src=\"").append(SystemEnvironment.getContextPath()).append("/common/office/js/i18n/").append(localeStr).append(".js").append(Functions.resSuffix()).append("\"></script>");
        if(contentAll.getStatus() == MainbodyStatus.STATUS_RESPONSE_NEW && contentAll.getContentType().intValue() == MainbodyType.FORM.getKey()) {
            contentAll.setId(Long.valueOf(0L));
            contentAll.setContentType(Integer.valueOf(MainbodyType.FORM.getKey()));
            contentAll.setTitle("");
            contentAll.setContent("");
            contentAll.setSort(Integer.valueOf(0));
        }

        sb.append(this.dealFormContent(contentAll));
        sb.append("<div class=\"comp\" comp=\"type:'fileupload'\"></div>");
        String s;
        if(contentAll.getViewState().intValue() == 1 || contentAll.getViewState().intValue() == 2) {
            s = (String)AppContext.getThreadContext("style");
            if(s != null && s.equals("1")) {
                sb.append("<DIV class=\"hidden\" style=\"position:relative;width:16px;visibility:hidden;\" id=\"img\" name=\"img\"><DIV id=\"addDiv\"><span id=\"addImg\" class=\"ico16 repeater_plus_16\"></span></DIV><DIV id=\"addEmptyDiv\"><span id=\"addEmptyImg\" class=\"ico16 blank_plus_16\"></span></DIV><DIV id=\"delDiv\"><span id=\"delImg\" class=\"ico16 repeater_reduce_16\"></span><span id=\"delAllImg\" class=\"ico16 permanently_delete_16\" style=\"display:block\"></span></DIV></DIV>");
            } else {
                sb.append("<DIV class=\"hidden\" style=\"position:relative;width:16px;visibility:hidden;\" id=\"img\" name=\"img\"><DIV id=\"addDiv\"><span id=\"addImg\" class=\"ico16 repeater_plus_16\"></span></DIV><DIV id=\"addEmptyDiv\"><span id=\"addEmptyImg\" class=\"ico16 blank_plus_16\"></span></DIV><DIV id=\"delDiv\"><span id=\"delImg\" class=\"ico16 repeater_reduce_16\"></span></DIV></DIV>");
            }

            sb.append("<input id=\"dataImport\" type=\"hidden\" class=\"comp hidden\" comp=\"type:'fileupload',applicationCategory:'2',extensions:'xls,xlsx',quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'excelImport',callMethod:'dataImportCall'\">");
        }

        s = ResourceUtil.getString("form.input.inputtype.barcode.label");
        sb.append("<div class=\"hidden font_size12\" style=\"position:absolute;right:20px;top:20px;width:50px;height:50px;line-height:90px;visibility:hidden;\" id=\"scan\" name=\"scan\"><span id=\"scan_img\" title=\"@title@\" class=\"form_scan_img\" style=\"cursor:pointer;\"></span></div>".replaceAll("@title@", s));
        contentAll.setContentHtml(sb.toString());
        CustomizeManager customizeManager = (CustomizeManager)AppContext.getBean("customizeManager");
        String formDisplay = customizeManager.getCustomizeValue(AppContext.currentUserId(), "form_display");
        formDisplay = StringUtil.checkNull(formDisplay)?"false":formDisplay;
        contentAll.putExtraMap("form_display", formDisplay);
        if(FormUtil.isH5()) {
            contentAll.setContentHtml((String)null);
            contentAll.putExtraMap("isLightForm", AppContext.getThreadContext("REST_HAS_LIGHT_FORM"));
        } else {
            FormBean formClone = (FormBean)contentAll.getExtraMap().get("clonedForm");
            String form_json = this.toJSON(formClone, contentAll.getViewState());
            DataBaseHandler.getInstance().putData("formJson",form_json);
            contentAll.putExtraMap("formJson",form_json);
        }

        contentAll.getExtraMap().remove("clonedForm");
    }

    private void findSourceContent(CtpContentAllBean contentAll) throws BusinessException {
        TemplateManager templateManager = (TemplateManager)AppContext.getBean("templateManager");
        MainbodyManager contentManager = (MainbodyManager)AppContext.getBean("ctpMainbodyManager");
        if(contentAll.getViewState().intValue() == 3) {
            CtpTemplate template = templateManager.getCtpTemplate(contentAll.getModuleId());
            if(template == null) {
                return;
            }

            while(template.getFormParentid() != null) {
                template = templateManager.getCtpTemplate(template.getFormParentid());
            }

            CtpContentAll contentAll2 = (CtpContentAll)contentManager.getContentListByModuleIdAndModuleType(ModuleType.getEnumByKey(contentAll.getModuleType().intValue()), template.getId()).get(0);
            if(contentAll2 == null) {
                throw new BusinessException("找不到原始引用的模板，可能被删除了！");
            }

            contentAll.setId(contentAll2.getId());
            contentAll.setContent(contentAll.getContent());
            contentAll.setContentDataId(contentAll2.getContentDataId());
            contentAll.setModuleId(contentAll2.getModuleId());
            contentAll.setContentTemplateId(contentAll2.getContentTemplateId());
            contentAll.setContentType(contentAll2.getContentType());
            contentAll.setModuleTemplateId(contentAll2.getModuleTemplateId());
            contentAll.setModuleType(contentAll2.getModuleType());
        }

    }

    private String dealFormContent(CtpContentAllBean contentAll) throws BusinessException {
        long formId = contentAll.getContentTemplateId().longValue();
        int viewState = contentAll.getViewState().intValue();
        String rightId = contentAll.getRightId();
        FormBean form = this.formManager.getForm(Long.valueOf(formId));
        if(form == null) {
            LOGGER.error("打开表单时，表单缓存为空，重新初始化缓存，FormId:" + String.valueOf(formId));
            this.formCacheManager.initForm(formId);
            form = this.formManager.getForm(Long.valueOf(formId));
        }

        AppContext.putThreadContext("REST_FORM_BEAN_INFO", form);
        if(!StringUtil.checkNull(rightId) && !StringUtil.checkNull(rightId)) {
            if(rightId.indexOf(",") != -1) {
                String[] rids = rightId.split(",");
                rightId = "";
                String[] var8 = rids;
                int var9 = rids.length;

                for(int var10 = 0; var10 < var9; ++var10) {
                    String rid = var8[var10];
                    Long lrid = Long.valueOf(Long.parseLong(rid));
                    rightId = rightId + String.valueOf(this.formCacheManager.getNewOperationId(Long.valueOf(formId), lrid)) + ",";
                }

                rightId = StringUtils.replaceLast(rightId, ",", "");
            } else {
                rightId = String.valueOf(this.formCacheManager.getNewOperationId(Long.valueOf(formId), Long.valueOf(Long.parseLong(rightId))));
            }
        }

        FormDataMasterBean formDataMasterBean = null;
        FormAuthViewBean formAuthViewBean = null;
        FormAuthViewBean conditionAuthViewBean = null;
        contentAll.putExtraMap("clonedForm", form);
        String from;
        String templateId;
        if(viewState == 1) {
            if(StringUtil.checkNull(rightId)) {
                LOGGER.info(ModuleType.getEnumByKey(contentAll.getModuleType().intValue()).getText() + "模块的数据" + contentAll.getModuleId() + ",在" + viewState + "状态下使用表单正文未传入rightId,系统默认使用表单编辑权限.");
                rightId = String.valueOf(form.getNewFormAuthViewBean().getId());
                contentAll.setRightId(rightId);
            }

            Long moduleTemplateId = contentAll.getModuleTemplateId();
            if(moduleTemplateId == null) {
                contentAll.setContent((String)null);
            }

            if(moduleTemplateId != null && moduleTemplateId.longValue() == -1L) {
                if(!StringUtil.checkNull(contentAll.getContent()) && contentAll.getContentType().equals(Integer.valueOf(MainbodyType.FORM.getKey()))) {
                    MainbodyManager contentManager = (MainbodyManager)AppContext.getBean("ctpMainbodyManager");
                    CtpContentAll contentAll2 = (CtpContentAll)contentManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, contentAll.getModuleId()).get(0);
                    AppContext.putThreadContext("INIT_FORMDATA", contentAll2.getContent());
                }

                contentAll.setModuleId(Long.valueOf(-1L));
            }

            formAuthViewBean = form.getAuthViewBeanById(Long.valueOf(Long.parseLong(rightId)));
            if(formAuthViewBean == null) {
                rightId = String.valueOf(form.getNewFormAuthViewBean().getId());
                contentAll.setRightId(rightId);
                formAuthViewBean = form.getAuthViewBeanById(Long.valueOf(Long.parseLong(rightId)));
            }

            Map<String, Object> map = this.initFormViewData(form, formAuthViewBean, contentAll);
            formDataMasterBean = (FormDataMasterBean)map.get("formDataBean");
            formAuthViewBean = (FormAuthViewBean)map.get("formAuthViewBean");
            conditionAuthViewBean = (FormAuthViewBean)map.get("conditionAuthViewBean");
            if(contentAll.isEditable().booleanValue() && (form.getFormType() == FormType.baseInfo.getKey() || form.getFormType() == FormType.manageInfo.getKey())) {
                boolean hasEditFlag = this.formManager.checkUnFlowFormFieldCanEdit(Long.valueOf(formId), rightId);
                if(hasEditFlag) {
                    Lock lock = this.formManager.getLock(formDataMasterBean.getId());
                    from = login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
                    if(lock != null) {
                        boolean isOne = lock.getOwner() == AppContext.currentUserId();
                        if(!isOne || !from.equals(lock.getFrom())) {
                            OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
                            V3xOrgMember member = orgManager.getMemberById(Long.valueOf(lock.getOwner()));
                            contentAll.putExtraMap("formDataLocker", member);
                        }
                    } else {
                        this.formManager.lockFormData(formDataMasterBean.getId());
                    }

                    templateId = (String)AppContext.getThreadContext("templateId");
                    if(Strings.isNotBlank(templateId)) {
                        FormBindAuthBean bindAuthBean = form.getBind().getFormBindAuthBean(templateId);
                        if(bindAuthBean != null) {
                            AppContext.putThreadContext("scanInput", bindAuthBean.getScanCodeInput());
                        }
                    }
                }
            }

            formDataMasterBean.putExtraAttr("viewRight", conditionAuthViewBean);
        } else if(viewState != 2 && viewState != 5) {
            if(viewState == 3) {
                if(formAuthViewBean == null) {
                    rightId = String.valueOf(form.getShowFormAuthViewBean().getId());
                    contentAll.setRightId(rightId);
                    formAuthViewBean = form.getAuthViewBeanById(Long.valueOf(Long.parseLong(rightId)));
                }

                long viewId = formAuthViewBean.getFormViewId();
                formAuthViewBean = (FormAuthViewBean)form.getFormView(viewId).getOperations().get(0);
                formDataMasterBean = FormDataMasterBean.newInstance(form, (FormAuthViewBean)null);

                try {
                    formAuthViewBean = (FormAuthViewBean)formAuthViewBean.cloneWithRight(FieldAccessType.design);
                } catch (CloneNotSupportedException var19) {
                    throw new BusinessException(var19);
                }

                conditionAuthViewBean = formAuthViewBean;
            } else if(viewState == 4) {
                formAuthViewBean = (FormAuthViewBean)form.getFormView(contentAll.getModuleId().longValue()).getOperations().get(0);
                formDataMasterBean = FormDataMasterBean.newInstance(form, (FormAuthViewBean)null);

                try {
                    formAuthViewBean = (FormAuthViewBean)formAuthViewBean.cloneWithRight(FieldAccessType.design);
                } catch (CloneNotSupportedException var18) {
                    throw new BusinessException(var18);
                }

                conditionAuthViewBean = formAuthViewBean;
            }
        } else {
            if(StringUtil.checkNull(rightId)) {
                LOGGER.info(ModuleType.getEnumByKey(contentAll.getModuleType().intValue()).getText() + "模块的数据" + contentAll.getModuleId() + ",在" + viewState + "状态下使用表单正文未传入rightId,系统默认使用表单浏览权限.");
                rightId = String.valueOf(form.getShowFormAuthViewBean().getId());
                contentAll.setRightId(rightId);
            }

            formAuthViewBean = form.getAuthViewBeanById(Long.valueOf(Long.parseLong(rightId)));
            if(formAuthViewBean == null) {
                LOGGER.error(ModuleType.getEnumByKey(contentAll.getModuleType().intValue()).getText() + "模块的数据moduleId:" + contentAll.getModuleId() + ",在viewState:" + viewState + "状态下,使用表单正文传入的rightId：" + rightId + "在表单:" + form.getId() + "中已经被删除,系统默认使用表单浏览权限.");
                rightId = String.valueOf(form.getShowFormAuthViewBean().getId());
                contentAll.setRightId(rightId);
                formAuthViewBean = form.getAuthViewBeanById(Long.valueOf(Long.parseLong(rightId)));
            }

            Map<String, Object> map = this.initFormViewData(form, formAuthViewBean, contentAll);
            formDataMasterBean = (FormDataMasterBean)map.get("formDataBean");
            formAuthViewBean = (FormAuthViewBean)map.get("formAuthViewBean");
            conditionAuthViewBean = (FormAuthViewBean)map.get("conditionAuthViewBean");

            try {
                conditionAuthViewBean = (FormAuthViewBean)conditionAuthViewBean.cloneWithRight(FieldAccessType.browse);
            } catch (CloneNotSupportedException var20) {
                throw new BusinessException("ContentAll.moduleType等于'formView'时，rightId传递错误：" + rightId);
            }
        }

        contentAll.putExtraMap("viewTitle", form.getFormView(conditionAuthViewBean.getFormViewId()).getFormViewName());
        String style = this.computeStyleFromEnv(form, conditionAuthViewBean, contentAll);
        if(StringUtil.checkNull(style)) {
            throw new BusinessException("当前表单为纯移动表单，没有PC视图，请在移动设备上使用。");
        } else {
            IFormContent formContent = this.formContentManager.getFormContentManager(style);
            Map<String, Object> formDataMap = formDataMasterBean.getFormulaMap("componentType_condition");
            Object oldState = formDataMap.get("Seeyon_Form_ViewState");
            from = formContent.getHtml(form, conditionAuthViewBean, formDataMasterBean, viewState);
            if(oldState != null) {
                formDataMap.put("Seeyon_Form_ViewState", oldState);
            }

            if(FormUtil.isH5()) {
                templateId = (String)AppContext.getThreadContext("templateType");
                FormMasterTableBeanRestVO formTableBeanRestVO = (FormMasterTableBeanRestVO)FormUtil.loadTemplate(form, conditionAuthViewBean, formDataMasterBean, viewState, templateId, "showFormData");
                if(TemplateType.infopath.getKey().equals(formTableBeanRestVO.getTemplateType())) {
                    formTableBeanRestVO.setTemplate(from);
                }

                AppContext.putThreadContext("rest_form_form_info", formTableBeanRestVO);
                AppContext.putThreadContext("rest_form_data", formDataMasterBean);
            }

            AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.collaboration, formDataMasterBean.getId().toString(), AppContext.currentUserId());
            Long end = Long.valueOf(System.currentTimeMillis());
            AppContext.removeThreadContext("realFieldBeanMap");
            return from;
        }
    }

    private String computeStyleFromEnv(FormBean form, FormAuthViewBean conditionAuthViewBean, CtpContentAllBean contentAll) throws BusinessException {
        String style = (String)AppContext.getThreadContext("style");
        FormViewBean viewBean = form.getFormView(conditionAuthViewBean.getFormViewId());
        if(StringUtil.checkNull(style)) {
            if(form.isPhoneForm()) {
                if(FormUtil.isPhoneLogin()) {
                    style = "4";
                } else {
                    style = null;
                }
            } else if(viewBean.isPhone()) {
                if(FormUtil.isPhoneLogin()) {
                    style = "4";
                } else {
                    style = "1";
                }
            } else if(FormUtil.isPhoneLogin()) {
                if(!conditionAuthViewBean.isSettedPhoneView() && !viewBean.hasPhoneView()) {
                    style = "1";
                } else {
                    style = "4";
                }
            } else {
                style = "1";
            }
        }

        AppContext.putThreadContext("style", style);
        if(FormUtil.isH5()) {
            FormViewBean viewBean1 = conditionAuthViewBean.getViewBean(form, true);
            if(viewBean1 == null) {
                LOGGER.warn("根据权限获取移动视图信息异常，视图为空，权限id：" + conditionAuthViewBean.getId() + " 表单id： " + form.getId());
                viewBean1 = viewBean;
            }

            AppContext.putThreadContext("REST_HAS_LIGHT_FORM", Boolean.valueOf(viewBean1.isPhone()));
            AppContext.putThreadContext("REST_FORM_RIGHT_INFO", conditionAuthViewBean);
        }

        return style;
    }

    public Map<String, Object> initFormViewData(FormBean form, FormAuthViewBean formAuthViewBean, CtpContentAllBean contentAll) throws BusinessException {
        if(formAuthViewBean == null) {
            throw new BusinessException("表单操作权限找不到，请联系表单管理员重新调整该应用绑定的节点权限。");
        } else {
            Object fromCopy = contentAll.getAttr("fromCopy");
            Long masterDataId = contentAll.getContentDataId();
            FormDataMasterBean formDataBean = null;
            FormAuthViewBean conditionAuthViewBean = null;
            boolean isNew = false;
            HashMap allRelationRecordMap;
            if(masterDataId == null || masterDataId.longValue() == -1L || masterDataId.longValue() == 0L || contentAll.getModuleTemplateId() != null && -1L == contentAll.getModuleTemplateId().longValue() && !StringUtil.checkNull(contentAll.getContent())) {
                isNew = true;
                String dataJson = (String)AppContext.getThreadContext("INIT_FORMDATA");
                if(Strings.isEmpty(dataJson)) {
                    AppContext.putThreadContext("isNew", Boolean.valueOf(isNew));
                    String contentDataId = (String)AppContext.getThreadContext("contentDataId");
                    if(!StringUtil.checkNull(contentDataId)) {
                        formDataBean = this.formManager.getSessioMasterDataBean(Long.valueOf(Long.parseLong(contentDataId)));
                        if(null == formDataBean) {
                            formDataBean = FormDataMasterBean.newInstance(form, formAuthViewBean);
                        }
                    } else {
                        formDataBean = FormDataMasterBean.newInstance(form, formAuthViewBean);
                    }

                    AppContext.removeThreadContext("isNew");
                } else {
                    formDataBean = FormService.conStuctFormDataBeanWithJson(form, dataJson, formAuthViewBean);
                    formDataBean.initData(formAuthViewBean, new boolean[]{false});
                    AppContext.removeThreadContext("INIT_FORMDATA");
                }

                formDataBean.putExtraAttr("isNew", isNew);
                contentAll.setContentDataId(formDataBean.getId());
                contentAll.setContent((String)null);
                if(contentAll.getModuleType().intValue() == ModuleType.unflowBasic.getKey() || contentAll.getModuleType().intValue() == ModuleType.unflowInfo.getKey()) {
                    contentAll.setModuleId(formDataBean.getId());
                }
            } else {
                try {
                    masterDataId = Long.valueOf(masterDataId == null?-1L:masterDataId.longValue());
                    allRelationRecordMap = new HashMap();
                    if(contentAll.getViewState().intValue() == 5) {
                        formDataBean = this.formManager.getSessioMasterDataBean(masterDataId);
                        if(formDataBean == null) {
                            formDataBean = this.formDataDAO.selectDataByMasterId(masterDataId, form, (String[])null);
                        }
                    } else {
                        if("true".equalsIgnoreCase(String.valueOf(contentAll.getAttr("showIndex"))) && (contentAll.getViewState().intValue() == 1 || FormUtil.isH5() && contentAll.getViewState().intValue() == 2)) {
                            formDataBean = this.formManager.getSessioMasterDataBean(masterDataId);
                            if(null != formDataBean) {
                                if(formDataBean.getFormRelationRecordMap() != null) {
                                    allRelationRecordMap.putAll(formDataBean.getFormRelationRecordMap());
                                }

                                FormDataMasterBean tempFormDataBean = this.formDataDAO.selectDataByMasterId(masterDataId, form, (String[])null);
                                if(null != tempFormDataBean) {
                                    Date dbModifyDate = tempFormDataBean.getModifyDate();
                                    Date cacheModifyDate = formDataBean.getModifyDate();
                                    if(dbModifyDate != null && cacheModifyDate != null && dbModifyDate.getTime() > cacheModifyDate.getTime()) {
                                        formDataBean = tempFormDataBean;
                                        LOGGER.info("数据已经不是最新的，使用数据库中的数据：" + form.getMasterTableBean().getTableName() + " " + tempFormDataBean.getId());
                                    }
                                }
                            } else {
                                formDataBean = this.formDataDAO.selectDataByMasterId(masterDataId, form, (String[])null);
                            }
                        } else {
                            formDataBean = this.formDataDAO.selectDataByMasterId(masterDataId, form, (String[])null);
                        }

                        formDataBean.putExtraAttr("moduleId", contentAll.getModuleId().longValue());
                        if(contentAll.getViewState().intValue() == 1) {
                            formDataBean.putExtraAttr("calcAll", "calcAll");
                            formDataBean.initData(formAuthViewBean, new boolean[]{false});
                            formDataBean.getExtraMap().remove("calcAll");
                        }
                    }

                    Map<String, FormRelationRecord> m = this.formRelationManager.getFormRelationMap(masterDataId);
                    if(m != null) {
                        allRelationRecordMap.putAll(m);
                    }

                    formDataBean.setFormRelationRecordMap(allRelationRecordMap);
                    Long moduleId = contentAll.getModuleId();
                    moduleId = this.getRealModuleId(moduleId);
                    MainbodyManager contentManager = (MainbodyManager)AppContext.getBean("ctpMainbodyManager");
                    List<CtpContentAll> contents = contentManager.getContentListByContentDataIdAndModuleType(contentAll.getModuleType().intValue(), masterDataId);
                    List<Attachment> allAtts = new ArrayList();
                    if(moduleId.longValue() != 0L && moduleId.longValue() != -1L) {
                        allAtts = FormService.getAllFormAttsByModuleId(moduleId);
                    }

                    Iterator var15 = contents.iterator();

                    label244:
                    while(true) {
                        CtpContentAll c;
                        List serialRecordList;
                        do {
                            do {
                                if(!var15.hasNext()) {
                                    List<Attachment> removedAtt = (List)AppContext.getThreadContext("removedAtt");
                                    if(removedAtt != null && !removedAtt.isEmpty()) {
                                        Iterator var32 = removedAtt.iterator();

                                        label224:
                                        while(true) {
                                            Attachment a;
                                            Long subReference;
                                            do {
                                                do {
                                                    if(!var32.hasNext()) {
                                                        break label224;
                                                    }

                                                    a = (Attachment)var32.next();
                                                    subReference = a.getSubReference();
                                                } while(a.getCategory().intValue() != ApplicationCategoryEnum.collaboration.getKey());
                                            } while(StringUtil.checkNull(String.valueOf(subReference)));

                                            Iterator var38 = form.getAllFieldBeans().iterator();

                                            while(true) {
                                                while(true) {
                                                    FormFieldBean f;
                                                    do {
                                                        if(!var38.hasNext()) {
                                                            continue label224;
                                                        }

                                                        f = (FormFieldBean)var38.next();
                                                    } while(!f.isAttachment(false, false));

                                                    if(f.isMasterField()) {
                                                        if(String.valueOf(formDataBean.getFieldValue(f.getName())).equalsIgnoreCase(String.valueOf(subReference))) {
                                                            a.setCategory(Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                                                            ((List)allAtts).add(a);
                                                        }
                                                    } else {
                                                        List<FormDataSubBean> subDatas = formDataBean.getSubData(f.getOwnerTableName());
                                                        Iterator var22 = subDatas.iterator();

                                                        while(var22.hasNext()) {
                                                            FormDataSubBean subData = (FormDataSubBean)var22.next();
                                                            if(String.valueOf(subData.getFieldValue(f.getName())).equalsIgnoreCase(String.valueOf(subReference))) {
                                                                a.setCategory(Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                                                                ((List)allAtts).add(a);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    List<Attachment> cacheAtts = (List)formDataBean.getExtraAttr("attachments");
                                    if(cacheAtts != null && !cacheAtts.isEmpty() && allAtts != null && !((List)allAtts).isEmpty() && ((List)allAtts).hashCode() != cacheAtts.hashCode()) {
                                        Iterator var35 = cacheAtts.iterator();

                                        while(var35.hasNext()) {
                                            Attachment cacheAtt = (Attachment)var35.next();
                                            boolean hasInclude = false;
                                            Iterator var40 = ((List)allAtts).iterator();

                                            while(var40.hasNext()) {
                                                Attachment a = (Attachment)var40.next();
                                                if(a.getFileUrl() != null && cacheAtt.getFileUrl() != null && cacheAtt.getFileUrl().longValue() == a.getFileUrl().longValue()) {
                                                    hasInclude = true;
                                                    break;
                                                }
                                            }

                                            if(!hasInclude) {
                                                ((List)allAtts).add(cacheAtt);
                                            }
                                        }
                                    } else if(cacheAtts != null && !cacheAtts.isEmpty() && allAtts != null && ((List)allAtts).isEmpty()) {
                                        ((List)allAtts).addAll(cacheAtts);
                                    }

                                    formDataBean.putExtraAttr("attachments", (List)allAtts);
                                    serialRecordList = this.serialCalRecordManager.selectAllByFormData(form.getId(), formDataBean.getId());
                                    formDataBean.putExtraAttr("serialCalRecords", serialRecordList);
                                    break label244;
                                }

                                c = (CtpContentAll)var15.next();
                            } while(c.getModuleId() == null);
                        } while(moduleId.equals(c.getModuleId()));

                        serialRecordList = FormService.getAllFormAttsByModuleId(c.getModuleId());
                        Iterator var18 = serialRecordList.iterator();

                        while(var18.hasNext()) {
                            Attachment a = (Attachment)var18.next();
                            if(moduleId.longValue() != 0L && moduleId.longValue() != -1L) {
                                a.setReference(moduleId);
                            }
                        }

                        ((List)allAtts).addAll(serialRecordList);
                    }
                } catch (SQLException var24) {
                    throw new BusinessException(var24);
                }
            }

            contentAll.putExtraMap("isNew", Boolean.valueOf(isNew));
            formDataBean.putExtraAttr("moduleId", contentAll.getModuleId().longValue());
            if(contentAll.getViewState().intValue() == 1) {
                boolean isCopy = fromCopy != null && ((Long)fromCopy).longValue() != -1L;
                if(!isCopy) {
                    this.formManager.putSessioMasterDataBean(form, formDataBean);
                    this.formManager.procDefaultValue(formDataBean, formAuthViewBean, false, !isNew);
                    this.formManager.calcAll(form, formDataBean, formAuthViewBean, false, true, isNew);
                }

                if(contentAll.getModuleType().intValue() == ModuleType.collaboration.getKey()) {
                    contentAll.putExtraMap("advanceAuthType", Integer.valueOf(formAuthViewBean.getAdvanceAuthType()));
                }

                if(isCopy) {
                    AppContext.putThreadContext("formDataIsFromCopy", Boolean.valueOf(isCopy));
                    this.transResetFormDataMasterBean4Copy(form, formAuthViewBean, contentAll, formDataBean, true);
                    AppContext.removeThreadContext("formDataIsFromCopy");
                }

                this.formDataManager.dealFormRightChangeResult(form, formAuthViewBean, formDataBean);
            }

            conditionAuthViewBean = formAuthViewBean.getRightFormAuthViewBean(formDataBean.getFormulaMap("componentType_condition"));
            contentAll.setRightId(String.valueOf(conditionAuthViewBean.getId()));
            allRelationRecordMap = new HashMap();
            allRelationRecordMap.put("formDataBean", formDataBean);
            allRelationRecordMap.put("formAuthViewBean", formAuthViewBean);
            allRelationRecordMap.put("conditionAuthViewBean", conditionAuthViewBean);
            return allRelationRecordMap;
        }
    }

    private void transResetFormDataMasterBean4Copy(FormBean form, FormAuthViewBean formAuthViewBean, CtpContentAllBean contentAll, FormDataMasterBean formDataBean, boolean isNew) throws BusinessException, NumberFormatException {
        Long oldMasterDataId = formDataBean.getId();
        formDataBean.resetId();
        boolean isProcessForm = form.getFormType() == FormType.processesForm.getKey();
        Long summaryId = Long.valueOf(-1L);
        Long oldModuleId = Long.valueOf(-1L);
        Long newId = formDataBean.getId();
        List tempAtts;
        if(isProcessForm) {
            formDataBean.removeNoAuthFieldVal(form, formAuthViewBean);
            FormViewBean viewBean = form.getFormView(formAuthViewBean.getFormViewId());
            if(null != viewBean) {
                List<FormTableBean> subTableBeans = form.getSubTableBean();
                Iterator var13 = subTableBeans.iterator();

                while(var13.hasNext()) {
                    FormTableBean subTableBean = (FormTableBean)var13.next();
                    FormDataSubBean subData;
                    if(!viewBean.hasSubTable(form, subTableBean.getTableName())) {
                        tempAtts = formDataBean.getSubData(subTableBean.getTableName());
                        if(tempAtts.size() > 0) {
                            subData = (FormDataSubBean)tempAtts.get(0);
                            tempAtts.clear();
                            tempAtts.add(subData);
                        }
                    } else if(subTableBean.isCollectTable) {
                        tempAtts = formDataBean.getSubData(subTableBean.getTableName());
                        if(tempAtts.size() > 0) {
                            subData = (FormDataSubBean)tempAtts.get(0);
                            tempAtts.clear();
                            tempAtts.add(subData);
                        }
                    }
                }
            }

            formDataBean.resetConstantFieldValue();
            summaryId = (Long)AppContext.getThreadContext("_summaryId");
            MainbodyManager contentManager = (MainbodyManager)AppContext.getBean("ctpMainbodyManager");
            List<CtpContentAll> contents = contentManager.getContentListByContentDataIdAndModuleType(contentAll.getModuleType().intValue(), oldMasterDataId);
            if(contents != null && contents.size() > 0) {
                oldModuleId = ((CtpContentAll)contents.get(0)).getModuleId();
            }

            List<CtpContentAll> selfContents = contentManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summaryId);
            if(selfContents != null && selfContents.size() > 0) {
                contentAll.setId(((CtpContentAll)selfContents.get(0)).getId());
                newId = ((CtpContentAll)selfContents.get(0)).getContentDataId();
            }
        }

        Map<Long, Long> oldNewSubDataIdMap = (Map)formDataBean.getExtraMap().get("oldNewSubDataIdMap");
        Map<String, FormRelationRecord> relationRecords = formDataBean.getFormRelationRecordMap();
        Map<String, FormRelationRecord> relationRecordMap = new HashMap();
        Iterator var35 = relationRecords.entrySet().iterator();

        while(true) {
            FormAuthViewFieldBean fieldAuth;
            Entry relationRecordEntry;
            do {
                FormFieldBean fieldBean;
                do {
                    if(!var35.hasNext()) {
                        formDataBean.setFormRelationRecordMap(relationRecordMap);
                        Object attObj = formDataBean.getExtraAttr("attachments");
                        tempAtts = null;
                        if(attObj != null) {
                            tempAtts = (List)attObj;
                        }

                        List<FormFieldBean> fields = form.getAllFieldBeans();
                        List<Attachment> attsNew = new ArrayList();
                        AttachmentManager attachmentManager = (AttachmentManager)AppContext.getBean("attachmentManager");
                        Iterator var43 = fields.iterator();

                        while(true) {
                            while(true) {
                                FormFieldBean field;
                                boolean allIsEdit;
                                do {
                                    FormRelation relation;
                                    do {
                                        FormFieldComEnum e;
                                        do {
                                            do {
                                                while(true) {
                                                    do {
                                                        do {
                                                            do {
                                                                if(!var43.hasNext()) {
                                                                    if(tempAtts != null) {
                                                                        tempAtts.clear();
                                                                    }

                                                                    Map<String, List<FormDataSubBean>> subMap = formDataBean.getSubTables();
                                                                    Iterator var46 = subMap.entrySet().iterator();

                                                                    while(var46.hasNext()) {
                                                                        Entry<String, List<FormDataSubBean>> et = (Entry)var46.next();
                                                                        formDataBean.refreshSort((List)et.getValue());
                                                                    }

                                                                    formDataBean.putExtraAttr("attachments", attsNew);
                                                                    formDataBean.putExtraAttr("serialCalRecords", new ArrayList());
                                                                    contentAll.setContentDataId(newId);
                                                                    formDataBean.resetId(newId, false);
                                                                    this.formManager.putSessioMasterDataBean(form, formDataBean);
                                                                    this.formManager.procDefaultValue(formDataBean, formAuthViewBean, false);
                                                                    this.formRelationManager.dealAllOrgFieldRelation(form, formDataBean, (FormAuthViewBean)null, true, true);
                                                                    this.formManager.calcAll(form, formDataBean, formAuthViewBean, false, true, isNew);
                                                                    return;
                                                                }

                                                                field = (FormFieldBean)var43.next();
                                                            } while(null == field);

                                                            List subDatas;
                                                            Iterator var22;
                                                            FormDataSubBean subData;
                                                            if(!field.isSn() && !field.isFormulaSn()) {
                                                                if(field.findRealFieldBean().isAttachment(true, true) && !FormFieldComEnum.BARCODE.getKey().equals(field.getFinalInputType(true))) {
                                                                    if(tempAtts != null && tempAtts.size() > 0) {
                                                                        oldModuleId = null != ((Attachment)tempAtts.get(0)).getReference()?((Attachment)tempAtts.get(0)).getReference():oldModuleId;
                                                                        if(field.isMasterField()) {
                                                                            Object val = formDataBean.getFieldValue(field.getName());
                                                                            Long newSubReference = Long.valueOf(UUIDUtil.getUUIDLong());
                                                                            if(val != null && !StringUtil.checkNull(String.valueOf(val))) {
                                                                                Long oldSubReferece = Long.valueOf(Long.parseLong(String.valueOf(val)));
                                                                                List<Attachment> atts = this.copyAtt(oldMasterDataId, oldModuleId, newId, newSubReference, isProcessForm, summaryId, oldSubReferece, attachmentManager);
                                                                                if(atts != null) {
                                                                                    attsNew.addAll(atts);
                                                                                }
                                                                            }

                                                                            formDataBean.addFieldValue(field.getName(), newSubReference);
                                                                        } else {
                                                                            subDatas = formDataBean.getSubData(field.getOwnerTableName());

                                                                            Long newSubReference;
                                                                            for(var22 = subDatas.iterator(); var22.hasNext(); subData.addFieldValue(field.getName(), newSubReference)) {
                                                                                subData = (FormDataSubBean)var22.next();
                                                                                Object val = subData.getFieldValue(field.getName());
                                                                                newSubReference = Long.valueOf(UUIDUtil.getUUIDLong());
                                                                                if(val != null && !StringUtil.checkNull(String.valueOf(val))) {
                                                                                    Long oldSubReferece = Long.valueOf(Long.parseLong(String.valueOf(val)));
                                                                                    List<Attachment> atts = this.copyAtt(oldMasterDataId, oldModuleId, newId, newSubReference, isProcessForm, summaryId, oldSubReferece, attachmentManager);
                                                                                    if(atts != null) {
                                                                                        attsNew.addAll(atts);
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    } else if(field.isMasterField()) {
                                                                        formDataBean.addFieldValue(field.getName(), Long.valueOf(UUIDUtil.getUUIDLong()));
                                                                    } else {
                                                                        subDatas = formDataBean.getSubData(field.getOwnerTableName());
                                                                        var22 = subDatas.iterator();

                                                                        while(var22.hasNext()) {
                                                                            subData = (FormDataSubBean)var22.next();
                                                                            subData.addFieldValue(field.getName(), Long.valueOf(UUIDUtil.getUUIDLong()));
                                                                        }
                                                                    }
                                                                } else if(field.getInputTypeEnum().equals(FormFieldComEnum.HANDWRITE)) {
                                                                    if(field.isMasterField()) {
                                                                        formDataBean.addFieldValue(field.getName(), (Object)null);
                                                                    } else {
                                                                        subDatas = formDataBean.getSubData(field.getOwnerTableName());
                                                                        var22 = subDatas.iterator();

                                                                        while(var22.hasNext()) {
                                                                            subData = (FormDataSubBean)var22.next();
                                                                            subData.addFieldValue(field.getName(), (Object)null);
                                                                        }
                                                                    }
                                                                }
                                                            } else if(field.isMasterField()) {
                                                                formDataBean.addFieldValue(field.getName(), (Object)null);
                                                            } else {
                                                                subDatas = formDataBean.getSubData(field.getOwnerTableName());
                                                                var22 = subDatas.iterator();

                                                                while(var22.hasNext()) {
                                                                    subData = (FormDataSubBean)var22.next();
                                                                    subData.addFieldValue(field.getName(), (Object)null);
                                                                }
                                                            }
                                                        } while(!isProcessForm);

                                                        e = field.getInputTypeEnum();
                                                    } while(e == null);

                                                    relation = field.getFormRelation();
                                                    if(!e.equals(FormFieldComEnum.FLOWDEALOPITION) && (!e.equals(FormFieldComEnum.RELATIONFORM) || relation == null || !relation.isSysRelationForm()) && (!e.equals(FormFieldComEnum.RELATION) || relation == null || !relation.isDataRelationMember()) && (!e.equals(FormFieldComEnum.RELATION) || relation == null || relation.getToRelationAttr() == null || form.getFieldBeanByName(relation.getToRelationAttr()) == null || form.getFieldBeanByName(relation.getToRelationAttr()).getFormRelation() == null || form.getFieldBeanByName(relation.getToRelationAttr()).getFormRelation() == null || !form.getFieldBeanByName(relation.getToRelationAttr()).getFormRelation().isSysRelationForm())) {
                                                        break;
                                                    }

                                                    if(field.isMasterField()) {
                                                        formDataBean.addFieldValue(field.getName(), (Object)null);
                                                    } else {
                                                        List<FormDataSubBean> subDatas = formDataBean.getSubData(field.getOwnerTableName());
                                                        Iterator var55 = subDatas.iterator();

                                                        while(var55.hasNext()) {
                                                            FormDataSubBean subData = (FormDataSubBean)var55.next();
                                                            subData.addFieldValue(field.getName(), (Object)null);
                                                        }
                                                    }
                                                }
                                            } while(!e.equals(FormFieldComEnum.RELATION));
                                        } while(relation == null);
                                    } while(!relation.isDataRelationMultiEnum());

                                    allIsEdit = true;

                                    FormFieldBean pField;
                                    for(pField = form.getFieldBeanByName(relation.getToRelationAttr()); pField.getFormRelation() != null && pField.getFormRelation().isDataRelationMultiEnum(); pField = form.getFieldBeanByName(pField.getFormRelation().getToRelationAttr())) {
                                        if(!formAuthViewBean.getFormAuthorizationField(pField.getName()).isEditAuth()) {
                                            allIsEdit = false;
                                            break;
                                        }
                                    }

                                    if(allIsEdit && !formAuthViewBean.getFormAuthorizationField(pField.getName()).isEditAuth()) {
                                        allIsEdit = false;
                                    }
                                } while(allIsEdit);

                                if(field.isMasterField()) {
                                    formDataBean.addFieldValue(field.getName(), (Object)null);
                                } else {
                                    List<FormDataSubBean> subDatas = formDataBean.getSubData(field.getOwnerTableName());
                                    Iterator var60 = subDatas.iterator();

                                    while(var60.hasNext()) {
                                        FormDataSubBean subData = (FormDataSubBean)var60.next();
                                        subData.addFieldValue(field.getName(), (Object)null);
                                    }
                                }
                            }
                        }
                    }

                    relationRecordEntry = (Entry)var35.next();
                    String key = (String)relationRecordEntry.getKey();
                    String fieldName = key.split("_")[1];
                    fieldBean = form.getFieldBeanByName(fieldName);
                } while(isProcessForm && (fieldBean.getFormRelation() == null || fieldBean.getFormRelation().isSysRelationForm()));

                if(!isProcessForm) {
                    break;
                }

                fieldAuth = formAuthViewBean.getFormAuthorizationField(fieldBean.getName());
            } while(FieldAccessType.browse.getKey().equals(fieldAuth.getAccess()));

            FormRelationRecord record = null;

            try {
                record = (FormRelationRecord)((FormRelationRecord)relationRecordEntry.getValue()).clone();
            } catch (CloneNotSupportedException var28) {
                LOGGER.error(var28.getMessage(), var28);
            }

            record.setId(Long.valueOf(UUIDUtil.getUUIDLong()));
            record.setFromMasterDataId(newId);
            record.setFromFormId(form.getId());
            Long fromSubDataId = (Long)oldNewSubDataIdMap.get(record.getFromSubdataId());
            if(fromSubDataId == null) {
                fromSubDataId = Long.valueOf(0L);
            }

            record.setFromSubdataId(fromSubDataId);
            relationRecordMap.put(record.getFromMasterDataId() + "_" + record.getFieldName() + "_" + record.getFromSubdataId(), record);
        }
    }

    private List<Attachment> copyAtt(Long oldMasterDataId, Long oldModuleId, Long newId, Long newSubReference, boolean isProcessForm, Long summaryId, Long oldSubReferece, AttachmentManager attachmentManager) {
        List<Attachment> atts = null;
        List fuck;
        Iterator var11;
        Attachment f;
        if(!isProcessForm) {
            attachmentManager.copy(oldMasterDataId, oldSubReferece, newId, newSubReference, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
            fuck = attachmentManager.getByReference(oldMasterDataId, oldSubReferece);
            var11 = fuck.iterator();

            while(var11.hasNext()) {
                f = (Attachment)var11.next();
                f.setReference(oldMasterDataId);
                attachmentManager.update(f);
            }

            atts = attachmentManager.getByReference(newId, newSubReference);
        } else if(oldModuleId.longValue() != -1L) {
            attachmentManager.copy(oldModuleId, oldSubReferece, summaryId, newSubReference, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
            fuck = attachmentManager.getByReference(oldModuleId, oldSubReferece);
            var11 = fuck.iterator();

            while(var11.hasNext()) {
                f = (Attachment)var11.next();
                f.setReference(oldModuleId);
                attachmentManager.update(f);
            }

            atts = attachmentManager.getByReference(summaryId, newSubReference);
        }

        return atts;
    }

    private Map<String, Object> getCommitData() {
        return FormUtil.getCommitData();
    }

    private void convertData(FormBean formBean) {
        FormUtil.convertData(formBean);
    }

    private boolean notSave2DB() {
        return FormUtil.isH5()?((Boolean)this.getCommitData().get("notSaveDB")).booleanValue():AppContext.getRawRequest().getParameter("notSaveDB") != null;
    }

    private boolean needCheckRule(CtpContentAllBean contentAll) {
        return FormUtil.isH5()?((Boolean)this.getCommitData().get("needCheckRule")).booleanValue():contentAll.getAttr("needCheckRule") == null || "true".equals(contentAll.getAttr("needCheckRule").toString());
    }

    private boolean needSn() {
        return FormUtil.isH5()?!"false".equals(String.valueOf(this.getCommitData().get("needSn"))):false;
    }

    public boolean handleContentSaveOrUpdate(CtpContentAllBean contentAll) throws BusinessException {
        String rightIdStr = contentAll.getRightId();
        Long rightId = Long.valueOf(Long.parseLong(rightIdStr));
        long formMasterId = contentAll.getContentDataId().longValue();
        FormBean form = this.formCacheManager.getForm(contentAll.getContentTemplateId().longValue());
        if(FormUtil.isH5()) {
            this.convertData(form);
        }

        FormDataMasterBean frontMasterBean = this.formManager.procFormParam(form, Long.valueOf(formMasterId), rightId);
        FormAuthViewBean auth = form.getAuthViewBeanById(rightId);
        List<FormAuthViewFieldBean> list = auth.getFormAuthorizationFieldList();
        FormTableBean masterTableBean = form.getMasterTableBean();
        boolean saveFormData = true;
        if(FormAuthorizationType.show.getKey().equals(auth.getType())) {
            saveFormData = false;
        }

        boolean notSaveDataTag4Template = !"saveAsTemplate".equals(AppContext.getRawRequest().getParameter("optType"));
        FormDataMasterBean cacheMasterData = this.formManager.getSessioMasterDataBean(frontMasterBean.getId());
        if(saveFormData) {
            this.formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            if(AppContext.getCurrentUser().isFromM1()) {
                this.formManager.calcAll(form, cacheMasterData, auth, false, true, false);
            }

            this.formDataManager.calcAllRelationSubTable(form.getId(), cacheMasterData, true, auth, (Map)null, true);
        }

        this.validateDataUnique(form, cacheMasterData, contentAll.getStatus());
        if(this.needCheckRule(contentAll) && saveFormData) {
            this.formManager.validate(contentAll.getContentTemplateId(), cacheMasterData);
            if(form.getFormType() == FormType.processesForm.getKey() && !this.notSave2DB() && notSaveDataTag4Template || form.getFormType() != FormType.processesForm.getKey()) {
                this.dealSn(contentAll, form, auth, list, masterTableBean, cacheMasterData);
            }
        } else if(this.needSn() || "true".equalsIgnoreCase(String.valueOf(AppContext.getRawRequest().getParameter("onlyGenerateSn")))) {
            this.dealSn(contentAll, form, auth, list, masterTableBean, cacheMasterData);
        }

        if(this.notSave2DB()) {
            Long moduleId = Long.valueOf(0L);
            if(ModuleType.unflowBasic.getKey() == contentAll.getModuleType().intValue()) {
                moduleId = cacheMasterData.getId();
            } else if(ModuleType.unflowInfo.getKey() == contentAll.getModuleType().intValue()) {
                moduleId = cacheMasterData.getId();
            } else if(ModuleType.dynamicForm.getKey() == contentAll.getModuleType().intValue()) {
                moduleId = cacheMasterData.getId();
            }

            if(moduleId.longValue() == 0L) {
                moduleId = contentAll.getModuleId();
            }

            moduleId = this.getRealModuleId(moduleId);

            try {
                this.formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, moduleId, true);
            } catch (Exception var21) {
                LOGGER.error(var21.getMessage(), var21);
            }

            return false;
        } else {
            try {
                if(ModuleType.unflowBasic.getKey() == contentAll.getModuleType().intValue()) {
                    contentAll.setModuleId(cacheMasterData.getId());
                    contentAll.setContentDataId(cacheMasterData.getId());
                    contentAll.setModuleType(Integer.valueOf(ModuleType.unflowBasic.getKey()));
                } else if(ModuleType.unflowInfo.getKey() == contentAll.getModuleType().intValue()) {
                    contentAll.setModuleId(cacheMasterData.getId());
                    contentAll.setContentDataId(cacheMasterData.getId());
                    contentAll.setModuleType(Integer.valueOf(ModuleType.unflowInfo.getKey()));
                } else if(ModuleType.dynamicForm.getKey() == contentAll.getModuleType().intValue()) {
                    contentAll.setModuleId(cacheMasterData.getId());
                    contentAll.setContentDataId(cacheMasterData.getId());
                    contentAll.setModuleType(Integer.valueOf(ModuleType.dynamicForm.getKey()));
                }

                String logs = "";
                if(form.getFormType() == FormType.manageInfo.getKey() || form.getFormType() == FormType.baseInfo.getKey() || form.getFormType() == FormType.dynamicForm.getKey()) {
                    logs = this.formLogManager.getLogs(cacheMasterData, contentAll.getStatus(), form);
                }

                cacheMasterData.setModifyMemberId(AppContext.currentUserId());
                Timestamp modifyDate;
                if(contentAll.getStatus() == MainbodyStatus.STATUS_POST_SAVE) {
                    cacheMasterData.setState(FormDataStateEnum.FLOW_UNAUDITED.getKey());
                    if(form.getFormType() == FormType.processesForm.getKey()) {
                        cacheMasterData.setState(FormDataStateEnum.FLOW_UNOFFICIAL.getKey());
                    }

                    modifyDate = DateUtil.currentTimestamp();
                    cacheMasterData.setStartDate(modifyDate);
                    cacheMasterData.setModifyDate(modifyDate);
                } else if(contentAll.getStatus() == MainbodyStatus.STATUS_POST_UPDATE) {
                    modifyDate = DateUtil.currentTimestamp();
                    cacheMasterData.setModifyDate(modifyDate);
                }

                Long moduleId = contentAll.getModuleId();
                moduleId = this.getRealModuleId(moduleId);
                if(saveFormData && notSaveDataTag4Template) {
                    this.formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, moduleId, false);
                }

                Object isNewStr = cacheMasterData.getExtraAttr("isNew");
                boolean isNew = "true".equals(String.valueOf(isNewStr));
                if(saveFormData) {
                    this.formDataManager.refreshAllBarCode(form, cacheMasterData, contentAll);
                }

                if((form.getFormType() == FormType.manageInfo.getKey() || form.getFormType() == FormType.baseInfo.getKey()) && AppContext.hasPlugin("index")) {
                    this.indexManager.update(moduleId, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                }

                if(saveFormData && form.hasConstantFieldInCalc(2)) {
                    this.formDataManager.calcAll(form, cacheMasterData, auth, false, false, false);
                }

                FormDataBeforeSubmitEvent formDataBeforeSubmitEvent = new FormDataBeforeSubmitEvent(cacheMasterData);
                EventDispatcher.fireEvent(formDataBeforeSubmitEvent);
                FormDataMasterBean cloneDataBean = (FormDataMasterBean)cacheMasterData.getExtraAttr("cloneDataBean");
                if(cloneDataBean != null) {
                    List<String> modifiedFields = cloneDataBean.getModifiedFields(cacheMasterData);
                    contentAll.putExtraMap("MODIFIED_FIELD_KEY", modifiedFields);
                }

                FormService.saveOrUpdateFormData(cacheMasterData, form.getId(), notSaveDataTag4Template?saveFormData:notSaveDataTag4Template);
                if("saveAsTemplate".equals(AppContext.getRawRequest().getParameter("optType"))) {
                    contentAll.setContent(cacheMasterData.getDataJsonString());
                }

                FormDataAfterSubmitEvent formDataAfterSubmitEvent = new FormDataAfterSubmitEvent(cacheMasterData);
                EventDispatcher.fireEvent(formDataAfterSubmitEvent);
                if(form.hasLbsField() && null != this.lbsManager) {
                    this.lbsManager.updateStateByMasterDataId(cacheMasterData.getId().longValue(), 2);
                }

                if(form.getFormType() == FormType.manageInfo.getKey() || form.getFormType() == FormType.baseInfo.getKey() || form.getFormType() == FormType.dynamicForm.getKey()) {
                    if(contentAll.getStatus() == MainbodyStatus.STATUS_POST_SAVE) {
                        this.formLogManager.saveOrUpdateLog(form.getId(), form.getFormType(), frontMasterBean.getId(), Long.valueOf(AppContext.currentUserId()), FormLogOperateType.INSERT.getKey(), logs.toString(), Long.valueOf(cacheMasterData.getStartMemberId()), cacheMasterData.getStartDate());
                    } else if(contentAll.getStatus() == MainbodyStatus.STATUS_POST_UPDATE) {
                        this.formLogManager.saveOrUpdateLog(form.getId(), form.getFormType(), cacheMasterData.getId(), frontMasterBean.getId(), Long.valueOf(AppContext.currentUserId()), FormLogOperateType.MODIFY.getKey(), logs.toString(), Long.valueOf(cacheMasterData.getStartMemberId()), cacheMasterData.getStartDate());
                    }

                    this.formManager.removeSessionMasterDataBean(cacheMasterData.getId());
                }

                return true;
            } catch (Exception var22) {
                LOGGER.error(var22.getMessage(), var22);
                throw new BusinessException(null != var22.getCause()?var22.getCause().getMessage():var22.getMessage());
            }
        }
    }

    private void dealSn(CtpContentAllBean contentAll, FormBean form, FormAuthViewBean auth, List<FormAuthViewFieldBean> list, FormTableBean masterTableBean, FormDataMasterBean cacheMasterData) throws BusinessException {
        DataContainer sn = new DataContainer();
        Iterator var8 = list.iterator();

        while(true) {
            FormAuthViewFieldBean fieldAuth;
            String val;
            do {
                do {
                    do {
                        if(!var8.hasNext()) {
                            this.processSerial4Formula(cacheMasterData, form, auth);
                            if(sn.size() > 0) {
                                contentAll.putExtraMap("sn", sn);
                            }

                            return;
                        }

                        fieldAuth = (FormAuthViewFieldBean)var8.next();
                    } while(masterTableBean.getFieldBeanByName(fieldAuth.getFieldName()) == null);
                } while(!fieldAuth.isSerialNumberDefaultValue());

                val = (String)cacheMasterData.getFieldValue(fieldAuth.getFieldName());
            } while(val != null && !"".equals(val.trim()));

            FormFieldBean authSnField = form.getFieldBeanByName(fieldAuth.getFieldName());
            String snmu = fieldAuth.getSerialNumber();
            if(snmu != null) {
                if(FormFieldComEnum.TEXTAREA != authSnField.getInputTypeEnum() && snmu.length() > authSnField.getMaxLength(false)) {
                    cacheMasterData.addFieldValue(fieldAuth.getFieldName(), snmu.substring(0, authSnField.getMaxLength(true)));
                } else {
                    cacheMasterData.addFieldValue(fieldAuth.getFieldName(), snmu);
                }

                LOGGER.info("字段：" + authSnField.getDisplay() + "(" + authSnField.getName() + ")" + "通过权限:" + auth.getName() + "(" + auth.getId() + ")产生流水号 : " + cacheMasterData.getFieldValue(authSnField.getName()));
            }

            this.formDataManager.calcAllWithFieldIn(form, authSnField, cacheMasterData, Long.valueOf(0L), (Map)null, auth, false, false);
            sn.put(authSnField.getDisplay(), cacheMasterData.getFieldValue(fieldAuth.getFieldName()));
        }
    }

    private Long getRealModuleId(Long moduleId) throws BusinessException {
        return AppContext.hasPlugin("collaboration")?this.getParentProceeObjectId(moduleId):moduleId;
    }

    private Long getParentProceeObjectId(Long id) throws BusinessException {
        if(!AppContext.hasPlugin("collaboration")) {
            return id;
        } else {
            ColSummary summary = this.collaborationApi.getColSummary(id);
            if(null == summary) {
                return id;
            } else if(Integer.valueOf(NewflowType.child.ordinal()).equals(summary.getNewflowType())) {
                String processId = summary.getProcessId();
                if(Strings.isBlank(processId)) {
                    return id;
                } else {
                    Long parentProcessId = this.wapi.getMainProcessIdBySubProcessId(Long.valueOf(processId));
                    if(null == parentProcessId) {
                        return id;
                    } else {
                        ColSummary colSummaryById = this.collaborationApi.getColSummaryByProcessId(String.valueOf(parentProcessId));
                        return null != colSummaryById?colSummaryById.getId():id;
                    }
                }
            } else {
                return id;
            }
        }
    }

    public void beforeSaveContent(CtpContentAllBean content) throws BusinessException {
    }

    public void afterSaveContent(CtpContentAllBean content) throws BusinessException {
        FormBean form = this.formCacheManager.getForm(content.getContentTemplateId().longValue());
        if(form.getFormType() == FormType.baseInfo.getKey() || form.getFormType() == FormType.manageInfo.getKey()) {
            try {
                List<String> modifiedFields = (List)content.getAttr("MODIFIED_FIELD_KEY");
                this.formTriggerManager.doTrigger(content.getModuleType().intValue(), content.getModuleId().longValue(), form.getId().longValue(), content.getRightId(), modifiedFields, false);
            } catch (SQLException var4) {
                LOGGER.error("触发失败", var4);
            }
        }

    }

    @ListenEvent(
            event = FormDataAfterSubmitEvent.class
    )
    public void listenEventAfterFormDataSave(FormDataAfterSubmitEvent event) throws Exception {
        if(FormUtil.isH5()) {
            List<Map<String, Object>> signatures = (List)this.getCommitData().get("signatures");
            if(Strings.isNotEmpty(signatures)) {
                SignetManager signetManager = (SignetManager)AppContext.getBean("signetManager");
                Iterator var4 = signatures.iterator();

                while(var4.hasNext()) {
                    Map<String, Object> s = (Map)var4.next();
                    signetManager.saveSignets(s);
                }
            }
        }

    }

    private void processSerial4Formula(FormDataMasterBean cacheMasterData, FormBean form, FormAuthViewBean auth) throws BusinessException {
        List<FormSerialCalculateRecord> serialRecordList = (List)cacheMasterData.getExtraAttr("serialCalRecords");
        new HashMap();
        cacheMasterData.putExtraAttr("needProduceValue", "true");
        if(serialRecordList != null) {
            new HashMap();
            List<FormSerialCalculateRecord> subMap = new ArrayList();
            Iterator var8 = serialRecordList.iterator();

            FormSerialCalculateRecord record;
            FormFieldBean ffb;
            while(var8.hasNext()) {
                record = (FormSerialCalculateRecord)var8.next();
                ffb = form.getFieldBeanByName(record.getFieldName());
                if(ffb != null) {
                    if(ffb.isSubField()) {
                        subMap.add(record);
                    } else {
                        this.formDataManager.calc(form, ffb, cacheMasterData, Long.valueOf(0L), (Map)null, auth, false, false);
                    }
                }
            }

            var8 = subMap.iterator();

            while(var8.hasNext()) {
                record = (FormSerialCalculateRecord)var8.next();
                if(record != null) {
                    ffb = form.getFieldBeanByName(record.getFieldName());
                    this.formDataManager.calc(form, ffb, cacheMasterData, record.getFormSubId(), (Map)null, auth, false, false);
                }
            }
        }

    }

    private void validateDataUnique(FormBean fb, FormDataMasterBean cacheMasterData, MainbodyStatus status) throws BusinessException {
        DataContainer dc = new DataContainer();

        try {
            List<FormFieldBean> fieldBeanList = fb == null?null:fb.getAllFieldBeans();
            boolean isExist = false;
            String fieldName = "";
            List<String> fieldNameList = new ArrayList();
            FormDataMasterBean cloneDataBean = (FormDataMasterBean)cacheMasterData.getExtraAttr("cloneDataBean");
            if(null != fieldBeanList) {
                Iterator var10 = fieldBeanList.iterator();

                while(var10.hasNext()) {
                    FormFieldBean ffb = (FormFieldBean)var10.next();
                    if(!ffb.isConstantField() && ffb.isUnique()) {
                        List<FormDataBean> dataList = new ArrayList();
                        List<FormDataBean> oldDataList = new ArrayList();
                        if(ffb.isMasterField()) {
                            dataList.add(cacheMasterData);
                        } else {
                            dataList.addAll(cacheMasterData.getSubData(ffb.getOwnerTableName()));
                            if(cloneDataBean != null) {
                                oldDataList.addAll(cloneDataBean.getSubData(ffb.getOwnerTableName()));
                            }
                        }

                        isExist = this.formDataManager.isFieldUnique(ffb, ffb.getOwnerTableName(), dataList, oldDataList);
                        if(isExist) {
                            fieldName = ffb.getDisplay();
                            fieldNameList.add(ffb.getName());
                            break;
                        }
                    }
                }

                if(!isExist && Strings.isNotEmpty(fb.getUniqueFieldList())) {
                    var10 = fb.getUniqueFieldList().iterator();

                    while(var10.hasNext()) {
                        List<String> list = (List)var10.next();
                        if(this.formDataManager.isUniqueMarked(fb, cacheMasterData, list)) {
                            dc.add("ruleError", ResourceUtil.getString("form.data.validate.unique", fb.getFormName()));
                            dc.add("fields", list);
                            dc.add("forceCheck", "1");
                            throw new BusinessException(dc.getJson());
                        }
                    }
                }
            }

            if(isExist) {
                dc.add("ruleError", ResourceUtil.getString("form.data.validate.uniqueFlag", fieldName));
                dc.add("fields", fieldNameList);
                dc.add("forceCheck", "1");
                throw new BusinessException(dc.getJson());
            }
        } catch (Exception var14) {
            LOGGER.error(var14.getMessage(), var14);
            if(dc.isEmpty()) {
                dc.add("ruleError", ResourceUtil.getString("form.data.validate.uniqueFlag.exception"));
                dc.add("fields", new ArrayList());
                dc.add("forceCheck", "1");
            }

            throw new BusinessException(dc.getJson());
        }
    }

    private FormAuthViewBean mergeFormAuthViewBean(FormAuthViewBean newAuthViewBean, FormAuthViewBean updateAuthViewBean) throws BusinessException {
        FormAuthViewBean mergedAuth = null;

        try {
            mergedAuth = (FormAuthViewBean)updateAuthViewBean.clone();
        } catch (CloneNotSupportedException var10) {
            LOGGER.error(var10.getMessage(), var10);
            throw new BusinessException(var10);
        }

        List newAuthViewFieldList = newAuthViewBean.getFormAuthorizationFieldList();

        try {
            Iterator var5 = newAuthViewFieldList.iterator();

            while(var5.hasNext()) {
                FormAuthViewFieldBean tempNewAuthFieldBean = (FormAuthViewFieldBean)var5.next();
                FormAuthViewFieldBean tempUpdateAuthFieldBean = mergedAuth.getFormAuthorizationField(tempNewAuthFieldBean.getFieldName());
                FieldAccessType typeNewEnum = FieldAccessType.getEnumByKey(tempNewAuthFieldBean.getAccess());
                FieldAccessType typeUpdateEnum = FieldAccessType.getEnumByKey(tempUpdateAuthFieldBean.getAccess());
                if(typeNewEnum.ordinal() > typeUpdateEnum.ordinal()) {
                    tempUpdateAuthFieldBean.setAccess(tempNewAuthFieldBean.getAccess());
                }

                if(tempUpdateAuthFieldBean.getAccess().equalsIgnoreCase(FieldAccessType.edit.getKey()) && !tempNewAuthFieldBean.isNull()) {
                    tempUpdateAuthFieldBean.setIsNotNull(1);
                }
            }
        } catch (Exception var11) {
            LOGGER.error(var11.getMessage(), var11);
        }

        List<FormAuthorizationTableBean> newAuthTableList = newAuthViewBean.getFormAuthorizationTableList();
        Iterator var13 = newAuthTableList.iterator();

        while(var13.hasNext()) {
            FormAuthorizationTableBean tempNewAuthTable = (FormAuthorizationTableBean)var13.next();
            FormAuthorizationTableBean tempUpdateAuthTable = mergedAuth.getFormAuthorizationTableBeanByTableName(tempNewAuthTable.getTableName());
            if(tempNewAuthTable.isAllowAdd()) {
                tempUpdateAuthTable.setAllowAdd(true);
            }

            if(tempNewAuthTable.isAllowDelete()) {
                tempUpdateAuthTable.setAllowDelete(true);
            }
        }

        return mergedAuth;
    }

    public FormManager getFormManager() {
        return this.formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public FormCacheManager getFormCacheManager() {
        return this.formCacheManager;
    }

    public void setFormCacheManager(FormCacheManager formCacheManager) {
        this.formCacheManager = formCacheManager;
    }

    public FormDataDAO getFormDataDAO() {
        return this.formDataDAO;
    }

    public void setFormDataDAO(FormDataDAO formDataDAO) {
        this.formDataDAO = formDataDAO;
    }

    public FormRelationManager getFormRelationManager() {
        return this.formRelationManager;
    }

    public void setFormRelationManager(FormRelationManager formRelationManager) {
        this.formRelationManager = formRelationManager;
    }

    public FormTriggerManager getFormTriggerManager() {
        return this.formTriggerManager;
    }

    public void setFormTriggerManager(FormTriggerManager formTriggerManager) {
        this.formTriggerManager = formTriggerManager;
    }

    public FormLogManager getFormLogManager() {
        return this.formLogManager;
    }

    public void setFormLogManager(FormLogManager formLogManager) {
        this.formLogManager = formLogManager;
    }

    public FormDataManager getFormDataManager() {
        return this.formDataManager;
    }

    public void setFormDataManager(FormDataManager formDataManager) {
        this.formDataManager = formDataManager;
    }

    private String toJSON(FormBean form, Integer viewState) {
        DataContainer formJson = new DataContainer();
        DataContainer dc = null;
        List<DataContainer> list = null;
        formJson.add("id", "" + form.getId());
        formJson.add("formName", form.getFormName());
        formJson.add("categoryId", form.getCategoryId());
        formJson.add("creatorId", form.getCreatorId());
        formJson.add("ownerId", form.getOwnerId());
        formJson.add("state", form.getState());
        formJson.add("editFlag", form.getEditFlag());
        formJson.add("createDate", form.getCreateDate());
        formJson.add("useFlag", form.getUseFlag());
        formJson.add("formType", form.getFormType());
        formJson.add("dataDefindeType", form.getDataDefindeType());
        list = new ArrayList();
        Object o = AppContext.getThreadContext("_formDataMasterBean");
        FormDataMasterBean masterData = null;
        if(o != null) {
            masterData = (FormDataMasterBean)o;
        }

        DataContainer unShowSubDataIdMap = new DataContainer();
        Iterator var9 = form.getTableList().iterator();

        while(var9.hasNext()) {
            FormTableBean bean = (FormTableBean)var9.next();
            dc = new DataContainer();
            dc.add("id", "" + bean.getId());
            dc.add("tableName", bean.getTableName());
            dc.add("display", bean.getDisplay());
            dc.add("tableType", bean.getTableType());
            dc.add("ownerTable", bean.getOwnerTable());
            dc.add("ownerField", bean.getOwnerField());
            boolean showCollectTable = bean.isCollectTable();
            if(showCollectTable && 1 == viewState.intValue()) {
                showCollectTable = true;
            } else {
                showCollectTable = false;
            }

            dc.add("isCollectTable", showCollectTable);
            list.add(dc);
            if(masterData != null) {
                List<Long> notShowSubDataId = masterData.getNotShowSubDataIds(bean.getTableName());
                if(notShowSubDataId != null) {
                    unShowSubDataIdMap.add(bean.getTableName(), notShowSubDataId);
                }
            }
        }

        formJson.add("unShowSubDataIdMap", unShowSubDataIdMap);
        formJson.add("pageSize", 20);
        formJson.add("tableList", list);
        return formJson.getJson();
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

    public SerialCalRecordManager getSerialCalRecordManager() {
        return this.serialCalRecordManager;
    }

    public void setSerialCalRecordManager(SerialCalRecordManager serialCalRecordManager) {
        this.serialCalRecordManager = serialCalRecordManager;
    }

    public LbsManager getLbsManager() {
        return this.lbsManager;
    }

    public void setLbsManager(LbsManager lbsManager) {
        this.lbsManager = lbsManager;
    }

    public IndexManager getIndexManager() {
        return this.indexManager;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public SerialNumberManager getSerialNumberManager() {
        return this.serialNumberManager;
    }

    public void setSerialNumberManager(SerialNumberManager serialNumberManager) {
        this.serialNumberManager = serialNumberManager;
    }

    public void setFormContentManager(FormContentManager formContentManager) {
        this.formContentManager = formContentManager;
    }
}
