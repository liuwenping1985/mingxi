//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.form.service;

import com.alibaba.fastjson.JSONArray;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormAuthViewFieldBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean;
import com.seeyon.ctp.form.bean.FormBindBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormQueryBean;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.bean.SimpleObjectBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean.AuthName;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.bean.SimpleObjectBean.ColumnType;
import com.seeyon.ctp.form.formreport.bo.FormReportBean;
import com.seeyon.ctp.form.formreport.manager.FormAuthManager;
import com.seeyon.ctp.form.modules.bind.FormLogManager;
import com.seeyon.ctp.form.modules.component.ComponentManager;
import com.seeyon.ctp.form.modules.engin.authorization.FormAuthDesignManager;
import com.seeyon.ctp.form.modules.engin.authorization.FormAuthModuleDAO;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.form.po.FormLog;
import com.seeyon.ctp.form.util.DynamicFieldUtil;
import com.seeyon.ctp.form.util.FormLogUtil;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.form.util.QueryUtil;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FieldType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormLogOperateType;
import com.seeyon.ctp.form.util.Enums.FormModuleAuthModuleType;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.MasterTableField;
import com.seeyon.ctp.form.util.Enums.SubTableField;
import com.seeyon.ctp.form.util.Enums.TableType;
import com.seeyon.ctp.form.vo.FormSearchFieldBaseBo;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.springframework.web.servlet.ModelAndView;
import www.seeyon.com.utils.ReqUtil;

public class FormDataController extends BaseController {
    private static final Log LOGGER = CtpLogFactory.getLog(FormDataController.class);
    private FormManager formManager;
    private FormCacheManager formCacheManager;
    private FileToExcelManager fileToExcelManager;
    private FileManager fileManager;
    private FormLogManager formLogManager;
    private TemplateManager templateManager;
    private FormDataManager formDataManager;
    private WorkflowApiManager wapi;
    private FormAuthDesignManager formAuthDesignManager;
    private V3xHtmDocumentSignatManager htmSignetManager;
    private FormAuthManager formAuthManager;
    private OrgManager orgManager;
    private FormAuthModuleDAO formAuthModuleDAO;
    private static final String CONTENT_TYPE = "text/html;charset=UTF-8";

    public FormDataController() {
    }

    public ModelAndView calculate(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Map params = request.getParameterMap();
        long formMasterId = ParamUtil.getLong(params, "formMasterId").longValue();
        long formId = ParamUtil.getLong(params, "formId").longValue();
        long rightId = ParamUtil.getLong(params, "rightId").longValue();
        String fieldName = ParamUtil.getString(params, "fieldName");
        long recordId = ParamUtil.getLong(params, "recordId").longValue();
        long moduleId = ParamUtil.getLong(params, "moduleId").longValue();
        String calcAll = ParamUtil.getString(params, "calcAll");
        String calcSysRel = ParamUtil.getString(params, "calcSysRel");
        FormBean form = this.formCacheManager.getForm(formId);
        FormFieldBean fieldBean = form.getFieldBeanByName(fieldName);
        DataContainer resultMap = new DataContainer();
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;

        try {
            frontMasterBean = this.formManager.procFormParam(form, Long.valueOf(formMasterId), Long.valueOf(rightId));
            cacheMasterData = this.formManager.getSessioMasterDataBean(frontMasterBean.getId());
            if(moduleId != -1L && moduleId != 0L) {
                cacheMasterData.putExtraAttr("moduleId", moduleId);
            }

            this.formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            this.formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, Long.valueOf(moduleId), true);
            DataBaseHandler.getInstance().putData("cacheMasterData",cacheMasterData.toXML());
            DataBaseHandler.getInstance().putData("form_bean",form.toXML());//;
        } catch (Exception var33) {
            LOGGER.error(var33.getMessage(), var33);
        }

        FormAuthViewBean authViewBean = null;
        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            authViewBean = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(authViewBean == null) {
            authViewBean = form.getAuthViewBeanById(Long.valueOf(rightId));
        }

        PrintWriter out = null;
        DataContainer dc = new DataContainer();

        try {
            out = response.getWriter();
            if("true".equals(calcAll)) {
                resultMap.putAll(this.formDataManager.calcAll(form, cacheMasterData, authViewBean, true, false, "true".equals(calcSysRel)));
            } else {
                boolean hasCalc = false;
                if(fieldBean.isInCalculate()) {
                    hasCalc = true;
                    this.formDataManager.calcAllWithFieldIn(form, fieldBean, cacheMasterData, Long.valueOf(recordId), resultMap, authViewBean, true, true);
                }

                if(fieldBean.isInCondition()) {
                    if(recordId != 0L) {
                        AppContext.putThreadContext("isTriggerFromSubLine", "true");
                    }

                    if(!hasCalc) {
                        resultMap.putAll(this.formDataManager.dealSysRelation(form, cacheMasterData, fieldBean, authViewBean, Long.valueOf(recordId), false, (Long)null, true));
                    }

                    resultMap.putAll(this.formDataManager.dealFormRightChangeResult(form, authViewBean, cacheMasterData));
                }
            }

            dc.add("success", "true");
            if(null != cacheMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }

            DataContainer trans = null;
            if(resultMap.containsKey("datas")) {
                trans = new DataContainer();
                trans.put("datas", resultMap.get("datas"));
                resultMap.remove("datas");
                trans.putAll(resultMap);
            }

            dc.put("results", trans == null?resultMap:trans);
        } catch (BusinessException var31) {
            LOGGER.error(var31.getMessage(), var31);
            dc.add("results", "false");
            dc.add("errorMsg", var31.getMessage());
        } catch (IOException var32) {
            dc.add("results", "false");
            LOGGER.error(var32.getMessage(), var32);
        } finally {
            if(out != null) {
                out.println(dc.getJson());
            }

        }

        out.flush();
        out.close();
        return null;
    }

    public ModelAndView generageSubData(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Map params = request.getParameterMap();
        long formMasterId = ParamUtil.getLong(params, "formMasterId").longValue();
        long formId = ParamUtil.getLong(params, "formId").longValue();
        long rightId = ParamUtil.getLong(params, "rightId").longValue();
        long moduleId = ParamUtil.getLong(params, "moduleId").longValue();
        String tableName = ParamUtil.getString(params, "tableName");
        FormBean form = this.formCacheManager.getForm(formId);
        DataContainer resultMap = new DataContainer();
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;

        try {
            frontMasterBean = this.formManager.procFormParam(form, Long.valueOf(formMasterId), Long.valueOf(rightId));
            cacheMasterData = this.formManager.getSessioMasterDataBean(frontMasterBean.getId());
            this.formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            this.formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, Long.valueOf(moduleId), true);
            DataBaseHandler.getInstance().putData("cacheMasterData",cacheMasterData.toXML());
            DataBaseHandler.getInstance().putData("form_bean",form.toXML());//;
        } catch (Exception var29) {
            LOGGER.error(var29.getMessage(), var29);
        }

        FormAuthViewBean authViewBean = null;
        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            authViewBean = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(authViewBean == null) {
            authViewBean = form.getAuthViewBeanById(Long.valueOf(rightId));
        }

        PrintWriter out = null;
        DataContainer dc = new DataContainer();

        try {
            out = response.getWriter();
            List<FormDataSubBean> newSubDatas = this.formDataManager.calcRelationSubTable(form, cacheMasterData, tableName, authViewBean, resultMap, true);
            dc.add("success", "true");
            if(null != cacheMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }
            DataBaseHandler.getInstance().putData("cacheMasterData",cacheMasterData.toXML());
            DataBaseHandler.getInstance().putData("form_bean",form.toXML());//;
            //cacheMasterData.toJSON()
            Set<DataContainer> datas = this.formDataManager.getSubDataLineContainer(form, authViewBean, cacheMasterData, new LinkedHashSet(newSubDatas), resultMap);
            resultMap.put("datas", new LinkedList(datas));
            dc.put("results", resultMap);
        } catch (BusinessException var27) {
            LOGGER.error(var27.getMessage(), var27);
            dc.add("results", "false");
            dc.add("errorMsg", var27.getMessage());
        } catch (IOException var28) {
            dc.add("results", "false");
            LOGGER.error(var28.getMessage(), var28);
        } finally {
            if(out != null) {
                out.println(dc.getJson());
            }

        }

        out.flush();
        out.close();
        return null;
    }

    public ModelAndView formPreSubmitData(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Map params = request.getParameterMap();
        long formMasterId = ParamUtil.getLong(params, "formMasterId").longValue();
        long formId = ParamUtil.getLong(params, "formId").longValue();
        long rightId = ParamUtil.getLong(params, "rightId").longValue();
        long moduleId = ParamUtil.getLong(params, "moduleId").longValue();
        FormBean form = this.formCacheManager.getForm(formId);
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;

        try {
            frontMasterBean = this.formManager.procFormParam(form, Long.valueOf(formMasterId), Long.valueOf(rightId));
            cacheMasterData = this.formManager.getSessioMasterDataBean(frontMasterBean.getId());
            this.formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            DataBaseHandler.getInstance().putData("cacheMasterData",cacheMasterData.toXML());
            DataBaseHandler.getInstance().putData("form_bean",form.toXML());//;
        } catch (Exception var16) {
            LOGGER.error(var16.getMessage(), var16);
        }

        return null;
    }

    public ModelAndView validateFieldUnique(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Map params = request.getParameterMap();
        long formId = ParamUtil.getLong(params, "formId").longValue();
        String fieldName = ParamUtil.getString(params, "fieldName");
        String isNew = ParamUtil.getString(params, "isNew");
        FormBean form = this.formCacheManager.getForm(formId);
        String data = request.getParameter("fieldData") == null?"":request.getParameter("fieldData");
        FormFieldBean fieldBean = form.getFieldBeanByName(fieldName);
        PrintWriter out = null;
        boolean isExist = false;
        DataContainer dc = new DataContainer();

        try {
            out = response.getWriter();
            if(fieldBean != null && fieldBean.isUnique() && fieldBean.getFieldType().equals(FieldType.VARCHAR.getKey())) {
                isExist = this.formDataManager.isFieldValue4Unique(fieldBean, data, isNew);
            }

            dc.add("success", isExist);
        } catch (BusinessException var19) {
            LOGGER.error(var19.getMessage(), var19);
            dc.add("results", "false");
            dc.add("errorMsg", StringUtil.toString(var19));
        } catch (IOException var20) {
            dc.add("results", "false");
            LOGGER.error(var20.getMessage(), var20);
        } finally {
            if(out != null) {
                out.println(dc.getJson());
            }

        }

        out.flush();
        out.close();
        return null;
    }

    public ModelAndView addOrDelDataSubBean(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        Map params = request.getParameterMap();
        Long formMasterId = ParamUtil.getLong(params, "formMasterId");
        Long formId = ParamUtil.getLong(params, "formId");
        Long rightId = ParamUtil.getLong(params, "rightId");
        String tableName = ParamUtil.getString(params, "tableName");
        String type = ParamUtil.getString(params, "type");
        Long recordId = ParamUtil.getLong(params, "recordId");
        Map<String, Object> data = ParamUtil.getJsonParams();
        StringBuffer sb = this.formManager.addOrDelDataSubBean(formMasterId, formId, rightId, tableName, type, recordId, data);
        PrintWriter out = null;

        try {
            out = response.getWriter();
            out.println(sb.toString());
            out.flush();
        } catch (IOException var17) {
            LOGGER.error(var17.getMessage(), var17);
        } finally {
            if(out != null) {
                out.close();
            }

        }

        return null;
    }

    public ModelAndView getFormMasterDataList(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String isFromSectionMore = (String)request.getAttribute("unflowFormSectionMore");
        ModelAndView view = new ModelAndView("ctp/form/common/formMasterDataList");
        if("true".equals(isFromSectionMore)) {
            view.addObject("isFormSection", isFromSectionMore);
        }

        Map params = request.getParameterMap();
        Long formId = ParamUtil.getLong(params, "formId");
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        if(formBean == null || !this.formManager.isEnabled(formBean)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');parent.window.history.back();");
        }

        view.addObject("viewStyle", "1");
        if(formBean.isPhoneForm()) {
            view.addObject("viewStyle", "4");
        }

        String type = request.getParameter("type") == null?"baseInfo":request.getParameter("type");
        List<FormFieldBean> searchFieldList = new ArrayList();
        User user = AppContext.getCurrentUser();
        FormBindAuthBean bindAuthBean;
        List searchFields;
        List showFields;
        String op;
        int i;
        List htmls;
        String html;
        if(!"baseInfo".equals(type) && !"dynamicForm".equals(type)) {
            if("formRelation".equals(type)) {
                FormBindBean bindBean = formBean.getBind();
                bindAuthBean = null;
                Object bindAuthList;
                if(formBean.getFormType() == FormType.baseInfo.getKey()) {
                    bindAuthList = new ArrayList();
                    ((List)bindAuthList).add(bindBean.getUnFlowTemplateMap().values().iterator().next());
                } else {
                    bindAuthList = bindBean.getUnflowFormBindAuthByUserId(Long.valueOf(AppContext.currentUserId()));
                }

                if(((List)bindAuthList).size() <= 0) {
                    throw new BusinessException(ResourceUtil.getString("form.show.relationFormData.norightornobind"));
                }

                boolean showView = StringUtil.checkNull(ParamUtil.getString(params, "showView"))?true:Boolean.parseBoolean(ParamUtil.getString(params, "showView"));
                Long fromFormId = ParamUtil.getLong(params, "fromFormId");
                Long fromDataId = ParamUtil.getLong(params, "fromDataId");
                Long fromRecordId = ParamUtil.getLong(params, "fromRecordId");
                op = ParamUtil.getString(params, "fromRelationAttr");
                html = ParamUtil.getString(params, "toRelationAttr");
                FormBean fromFormBean = this.formCacheManager.getForm(fromFormId.longValue());
                FormFieldBean fromFieldBean = fromFormBean.getFieldBeanByName(op);
                FormFieldBean toFieldBean = formBean.getFieldBeanByName(html);
                String fromFieldType = fromFieldBean.isMasterField()?"m":"s";
                String toFieldType = toFieldBean.isMasterField()?"m":"s";
                view.addObject("relationInitParam", fromFieldType + toFieldType);
                view.addObject("fromFormId", fromFormId);
                view.addObject("fromDataId", fromDataId);
                view.addObject("fromRecordId", fromRecordId);
                view.addObject("fromRelationAttr", op);
                view.addObject("showView", Boolean.valueOf(showView));
                AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.form, fromDataId.toString(), AppContext.currentUserId());
                i = 0;
                Iterator var79 = ((List)bindAuthList).iterator();

                label219:
                while(true) {
                    while(true) {
                        FormBindAuthBean template;
                        do {
                            if(!var79.hasNext()) {
                                view.addObject("templateName", ParamUtil.getString(params, "templateName"));
                                break label219;
                            }

                            template = (FormBindAuthBean)var79.next();
                        } while(i != 0);

                        ++i;
                         showFields = template.getShowFieldList();
                        view.addObject("showFields", DynamicFieldUtil.getTheadStr(showFields, formBean));
                        List<SimpleObjectBean> orderByFields = template.getOrderByList();
                        view.addObject("sortStr", DynamicFieldUtil.getSortStr(orderByFields));
                        if(formBean.getFormType() == FormType.baseInfo.getKey()) {
                            view.addObject("firstRightId", ((FormAuthViewBean)((FormViewBean)formBean.getFormViewList().get(0)).getFormAuthViewBeanListByType(FormAuthorizationType.show).get(0)).getId());
                            searchFieldList = DynamicFieldUtil.getSearchField(showFields, formBean);
                        } else {
                             searchFields = template.getSearchFieldList();
                            searchFieldList = DynamicFieldUtil.getSearchField(searchFields, formBean);
                            String showAuth = template.getShowFormAuth();
                            if(Strings.isNotBlank(showAuth) && "|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                                showAuth = showAuth.substring(0, showAuth.length() - 1);
                            }

                            List<String> showAuths = new ArrayList();
                            String[] showAuthStrs = showAuth.split("[|]");
                            String[] var33 = showAuthStrs;
                            int var34 = showAuthStrs.length;

                            for(int var35 = 0; var35 < var34; ++var35) {
                                String str = var33[var35];
                                showAuths.add(str);
                            }

                            view.addObject("showAuth", showAuths);
                            view.addObject("firstRightId", showAuth.replaceAll("[|]", "_"));
                        }
                    }
                }
            }
        } else {
            view.addObject("hasBarcode", Boolean.valueOf(AppContext.hasPlugin("barCode") && user.isV5Member()));
            Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
            view.addObject("formTemplateId", formTemplateId);
            bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
            if(bindAuthBean != null) {
                if(!bindAuthBean.checkRight(AppContext.currentUserId())) {
                    throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
                }

                view.addObject("templateName", bindAuthBean.getName());
                searchFields = bindAuthBean.getSearchFieldList();
                showFields = bindAuthBean.getShowFieldList();
                List<SimpleObjectBean> orderByFields = bindAuthBean.getOrderByList();
                List orgIds;
                 i=0;
                if(formBean.getFormType() == FormType.baseInfo.getKey()) {
                    FormViewBean tempFormViewBean = (FormViewBean)formBean.getFormViewList().get(0);
                    List<FormAuthViewBean> addAuths = tempFormViewBean.getFormAuthViewBeanListByType(FormAuthorizationType.add);
                    view.addObject("newFormAuth", tempFormViewBean.getId() + "." + ((FormAuthViewBean)addAuths.get(0)).getId());
                    List<SimpleObjectBean> editAuth = new ArrayList();
                    SimpleObjectBean sob = new SimpleObjectBean(0L, ColumnType.Auth.getKey(), AuthName.UPDATE.getKey(), tempFormViewBean.getId() + "." + ((FormAuthViewBean)addAuths.get(0)).getId(), ((FormAuthViewBean)addAuths.get(0)).getName());
                    editAuth.add(sob);
                    view.addObject("editAuth", tempFormViewBean.getId() + "." + ((FormAuthViewBean)addAuths.get(0)).getId());
                    view.addObject("editAuthJson", JSONUtil.toJSONString(editAuth));
                    List<FormAuthViewBean> formShowAuths = tempFormViewBean.getFormAuthViewBeanListByType(FormAuthorizationType.show);
                    view.addObject("firstRightId", ((FormAuthViewBean)formShowAuths.get(0)).getId());
                } else {
                    String newauth = bindAuthBean.getNewFormAuth();
                    view.addObject("newFormAuth", bindAuthBean.getNewFormAuth());
                    op = bindAuthBean.getAuthObjByName(AuthName.ADD.getKey()).getDisplay();
                    if(Strings.isBlank(op)) {
                        op = ResourceUtil.getString("form.formlist.newform");
                    }

                    view.addObject("newFormAuthTitle", Strings.escapeJavascript(op));
                    orgIds = bindAuthBean.getUpdateAuthList();
                    List<SimpleObjectBean> cloneEditAuth = new ArrayList();
                    Iterator var20 = orgIds.iterator();

                    SimpleObjectBean c;
                    while(var20.hasNext()) {
                        SimpleObjectBean s = (SimpleObjectBean)var20.next();
                        if(!Strings.isBlank(s.getValue())) {
                            c = null;

                            try {
                                c = (SimpleObjectBean)s.clone();
                            } catch (CloneNotSupportedException var37) {
                                LOGGER.error(var37.getMessage(), var37);
                            }

                            if(StringUtil.checkNull(c.getDisplay())) {
                                c.setDisplay(ResourceUtil.getString("application.92.label"));
                            } else {
                                c.setDisplay(Strings.escapeJavascript(c.getDisplay()));
                            }

                            cloneEditAuth.add(c);
                        }
                    }

                    view.addObject("editAuth", cloneEditAuth);
                    view.addObject("editAuthJson", JSONUtil.toJSONString(cloneEditAuth));
                    view.addObject("editAuthTitle", ResourceUtil.getString("application.92.label"));
                    view.addObject("chooseAuth", "false");
                    if(newauth != null && newauth.split("[.]").length > 1 && cloneEditAuth.size() > 0) {
                        label308: {
                            FormAuthViewBean newAuth = formBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(newauth.split("[.]")[1])));
                            Iterator var63 = cloneEditAuth.iterator();

                            FormAuthViewBean e;
                            do {
                                do {
                                    if(!var63.hasNext()) {
                                        break label308;
                                    }

                                    c = (SimpleObjectBean)var63.next();
                                } while(!Strings.isNotBlank(c.getValue()));

                                e = formBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(c.getValue().split("[.]")[1])));
                            } while(newAuth.getConditionFormAuthViewBeanList().size() <= 0 && e.getConditionFormAuthViewBeanList().size() <= 0);

                            view.addObject("chooseAuth", "true");
                        }
                    }

                    view.addObject("customSet", bindAuthBean.getCustomAuthList());
                    String showAuth = bindAuthBean.getShowFormAuth();
                    if(Strings.isNotBlank(showAuth)) {
                        if("|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                            showAuth = showAuth.substring(0, showAuth.length() - 1);
                        }

                        List<String> showAuths = new ArrayList();
                        String[] showAuthStrs = showAuth.split("[|]");
                        String[] var71 = showAuthStrs;
                        i = showAuthStrs.length;

                        for(i = 0; i < i; ++i) {
                            String str = var71[i];
                            showAuths.add(str);
                        }

                        view.addObject("showAuth", showAuths);
                    }

                    view.addObject("firstRightId", showAuth.replaceAll("[|]", "_"));
                }

                view.addObject("showFields", DynamicFieldUtil.getTheadStr(showFields, formBean));
                view.addObject("sortStr", DynamicFieldUtil.getSortStr(orderByFields));
                searchFieldList = formBean.getFormType() == FormType.baseInfo.getKey()?DynamicFieldUtil.getSearchField(showFields, formBean):DynamicFieldUtil.getSearchField(searchFields, formBean);
                htmls = bindAuthBean.getAuthList();
                view.addObject("allImp", bindAuthBean.getAuthByName(AuthName.ALLOWIMPORT.getKey()));
                view.addObject("authList", htmls);
                Long memberId = Long.valueOf(AppContext.currentUserId());
                orgIds = this.orgManager.getAllUserDomainIDs(memberId);
                List<FormQueryBean> queryList = formBean.getFormQueryList();
                List<FormQueryBean> queryList2 = new ArrayList();
                List reportList;
                if(!queryList.isEmpty()) {
                    reportList = this.formAuthModuleDAO.selectModuleIdByOrgList(FormModuleAuthModuleType.Query, orgIds);
                    if(!reportList.isEmpty()) {
                        Set<Long> queryIds = new HashSet(reportList);

                        for( i = 0; i < queryList.size(); ++i) {
                            if(queryIds.contains(((FormQueryBean)queryList.get(i)).getId())) {
                                queryList2.add(queryList.get(i));
                            }
                        }
                    }
                }

                view.addObject("queryList", queryList2);
                reportList = formBean.getFormReportList();
                List<FormReportBean> reportList2 = new ArrayList();
                if(!reportList.isEmpty()) {
                    List<Long> reportIdsList = this.formAuthManager.listAuthByReportIdAndUserId(memberId);
                    if(!reportIdsList.isEmpty()) {
                        Set<Long> reportIds = new HashSet(reportIdsList);

                        for(i = 0; i < reportList.size(); ++i) {
                            if(reportIds.contains(((FormReportBean)reportList.get(i)).getReportDefinition().getId())) {
                                reportList2.add((FormReportBean) reportList.get(i));
                            }
                        }
                    }
                }

                view.addObject("reportList", reportList2);
            }
        }

        view.addObject("searchFields", searchFieldList);
        List<DataContainer> commonSearchFields = new ArrayList();
        if(((List)searchFieldList).size() > 0) {
            ComponentManager componentManager = (ComponentManager)AppContext.getBean("componentManager");
            Iterator var46 = ((List)searchFieldList).iterator();

            label197:
            while(true) {
                while(true) {
                    if(!var46.hasNext()) {
                        break label197;
                    }

                    FormFieldBean fb = (FormFieldBean)var46.next();
                    fb = fb.findRealFieldBean(false);
                    DataContainer o = new DataContainer();
                    commonSearchFields.add(o);
                    o.put("id", fb.getName());
                    o.put("name", fb.getName());
                    o.put("value", fb.getName());
                    o.put("text", fb.getDisplay());
                    o.put("type", "datemulti");
                    o.put("fieldType", fb.getFinalInputType());
                    if(fb.getInputTypeEnum() == FormFieldComEnum.OUTWRITE && (fb.getFieldType().equals(FieldType.DATETIME.getKey()) || fb.getFieldType().equals(FieldType.TIMESTAMP.getKey()))) {
                        if(fb.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                            o.put("dateTime", Boolean.valueOf(false));
                            o.put("ifFormat", "%Y-%m-%d");
                        } else {
                            o.put("dateTime", Boolean.valueOf(true));
                            o.put("minuteStep", Integer.valueOf(1));
                        }
                    } else if(fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATETIME) {
                        if(!fb.getName().equalsIgnoreCase(MasterTableField.start_date.getKey()) && !fb.getName().equalsIgnoreCase(MasterTableField.modify_date.getKey())) {
                            o.put("dateTime", Boolean.valueOf(true));
                            o.put("minuteStep", Integer.valueOf(1));
                        } else {
                            o.put("dateTime", Boolean.valueOf(false));
                            o.put("ifFormat", "%Y-%m-%d");
                        }
                    } else if(fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATE) {
                        o.put("dateTime", Boolean.valueOf(false));
                        o.put("ifFormat", "%Y-%m-%d");
                    } else if(fb.getInputTypeEnum() == FormFieldComEnum.RADIO) {
                        o.put("type", "customPanel");
                        o.put("readonly", "readonly");
                        o.put("panelWidth", Integer.valueOf(270));
                        o.put("panelHeight", Integer.valueOf(200));
                        htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), (List)null, (List)null);
                        op = ((String[])htmls.get(0))[0].replace("<select", "<select style='display:none;' ");
                        html = "<div class=\"padding_5\" style=\"line-height:20px;\">" + ((String[])htmls.get(0))[1] + "</div>";
                        o.put("customHtml", op + html);
                    } else {
                        o.put("type", "custom");
                        htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), (List)null, (List)null);
                        op = ((String[])htmls.get(0))[0].replace("<select", "<select style='display:none;' ");
                        html = ((String[])htmls.get(0))[1];
                        if(fb.getInputTypeEnum().isMultiOrg() || fb.getOutwriteFieldInputType().isMultiOrg()) {
                            html = ((String[])htmls.get(0))[1].replace("<textarea", "<input type='text'").replace("textarea", "input");
                        }

                        o.put("customHtml", op + html);
                    }
                }
            }
        }

        DataContainer dc = new DataContainer();
        dc.add("commonSearchFields", commonSearchFields);
        view.addObject("commonSearchFields", dc.getJson());
        searchFields = formBean.getAllFieldBeans();
        showFields = FormUtil.findUrlFieldList(searchFields);
        Map<String, Object> formP = new HashMap();
        formP.put("id", formBean.getId());
        formP.put("tableList", formBean.getAllTableName());
        view.addObject("urlFieldList", JSONUtil.toJSONString(showFields));
        int _moduType = formBean.getFormType() == FormType.baseInfo.getKey()?ModuleType.unflowBasic.getKey():ModuleType.unflowInfo.getKey();
        if(formBean.getFormType() == FormType.dynamicForm.getKey()) {
            _moduType = ModuleType.dynamicForm.getKey();
        }

        view.addObject("moduleType", Integer.valueOf(_moduType));
        view.addObject("formId", formBean.getId());
        view.addObject("toFormBean", JSONUtil.toJSONString(formP));
        view.addObject("type", type);
        view.addObject("formType", Integer.valueOf(formBean.getFormType()));
        view.addObject("currentUserId", Long.valueOf(AppContext.currentUserId()));
        return view;
    }

    public ModelAndView showUnflowIndex(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView view = new ModelAndView("ctp/form/common/showUnflowIndex");
        Map params = request.getParameterMap();
        Long formId = ParamUtil.getLong(params, "formId");
        String modelType = ParamUtil.getString(params, "model");
        String isFromSectionMore = ParamUtil.getString(params, "unflowFormSectionMore");
        if("true".equals(isFromSectionMore)) {
            view.addObject("isFormSection", isFromSectionMore);
        }

        if("column".equals(modelType)) {
            view.addObject("modelType", "column");
        } else if("menu".equals(modelType)) {
            view.addObject("modelType", "menu");
        } else {
            view.addObject("modelType", "info");
        }

        view.addObject("formId", formId);
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        if(formBean == null || !this.formManager.isEnabled(formBean)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');parent.window.close();");
        }

        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        view.addObject("formTemplateId", formTemplateId);
        String templateName = ParamUtil.getString(params, "templateName");
        view.addObject("templateName", templateName);
        String type = request.getParameter("type") == null?"baseInfo":request.getParameter("type");
        view.addObject("type", type);
        if("baseInfo".equals(type)) {
            FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
            if(bindAuthBean != null) {
                if(!bindAuthBean.checkRight(AppContext.currentUserId())) {
                    throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
                }

                view.addObject("templateName", bindAuthBean.getName());
                FormSearchFieldBaseBo fieldBo = this.formDataManager.getUnfolwFormSearchFirstTreeField(formId, formTemplateId);
                view.addObject("searchField", fieldBo);
            }
        }

        String srcFrom = ParamUtil.getString(params, "srcFrom");
        view.addObject("srcFrom", srcFrom);
        boolean isGroupVer = false;
        if("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))) {
            isGroupVer = true;
        }

        view.addObject("isGroupVer", Boolean.valueOf(isGroupVer));
        User user = AppContext.getCurrentUser();
        Long accountId = user.getLoginAccount();
        String accountShortName = user.getLoginAccountShortName();
        if(!user.isV5Member()) {
            accountId = OrgHelper.getVJoinAllowAccount();
            V3xOrgAccount account = this.orgManager.getAccountById(accountId);
            if(account != null) {
                accountShortName = account.getShortName();
            }
        }

        view.addObject("loginAccount", accountId);
        view.addObject("loginAccountName", accountShortName);
        return view;
    }

    public ModelAndView showUnflowFormDataList(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        ModelAndView view = new ModelAndView("ctp/form/common/showUnflowFormDataList");
        response.setContentType("text/html;charset=UTF-8");
        Map params = request.getParameterMap();
        String isFromSectionMore = ParamUtil.getString(params, "unflowFormSectionMore");
        if("true".equals(isFromSectionMore)) {
            view.addObject("isFormSection", isFromSectionMore);
        }

        Long formId = ParamUtil.getLong(params, "formId");
        String model = ParamUtil.getString(params, "model");
        if("column".equals(model)) {
            view.addObject("modelType", "column");
        } else if("menu".equals(model)) {
            view.addObject("modelType", "menu");
        } else {
            view.addObject("modelType", "info");
        }

        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        if(formBean == null || !this.formManager.isEnabled(formBean)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');parent.window.history.back();");
        }

        view.addObject("viewStyle", "1");
        if(formBean.isPhoneForm()) {
            view.addObject("viewStyle", "4");
        }

        String type = request.getParameter("type") == null?"baseInfo":request.getParameter("type");
        List<FormFieldBean> searchFieldList = new ArrayList();
        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        List showFields;
        List orderByFields;
        if("baseInfo".equals(type)) {
            view.addObject("formTemplateId", formTemplateId);
            FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
            if(bindAuthBean != null) {
                if(!bindAuthBean.checkRight(AppContext.currentUserId())) {
                    throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
                }

                view.addObject("templateName", bindAuthBean.getName());
                List<SimpleObjectBean> searchFields = bindAuthBean.getSearchFieldList();
                showFields = bindAuthBean.getShowFieldList();
                orderByFields = bindAuthBean.getOrderByList();
                List orgIds;
                int i;
                if(formBean.getFormType() == FormType.manageInfo.getKey()) {
                    String newauth = bindAuthBean.getNewFormAuth();
                    view.addObject("newFormAuth", bindAuthBean.getNewFormAuth());
                    String newBtnTitile = bindAuthBean.getAuthObjByName(AuthName.ADD.getKey()).getDisplay();
                    if(Strings.isBlank(newBtnTitile)) {
                        newBtnTitile = ResourceUtil.getString("form.formlist.newform");
                    }

                    view.addObject("newFormAuthTitle", Strings.escapeJavascript(newBtnTitile));
                    orgIds = bindAuthBean.getUpdateAuthList();
                    List<SimpleObjectBean> cloneEditAuth = new ArrayList();
                    Iterator var20 = orgIds.iterator();

                    SimpleObjectBean c;
                    while(var20.hasNext()) {
                        SimpleObjectBean s = (SimpleObjectBean)var20.next();
                        if(!Strings.isBlank(s.getValue())) {
                            c = null;

                            try {
                                c = (SimpleObjectBean)s.clone();
                            } catch (CloneNotSupportedException var27) {
                                LOGGER.error(var27.getMessage(), var27);
                            }

                            if(StringUtil.checkNull(c.getDisplay())) {
                                c.setDisplay(ResourceUtil.getString("application.92.label"));
                            } else {
                                c.setDisplay(Strings.escapeJavascript(c.getDisplay()));
                            }

                            cloneEditAuth.add(c);
                        }
                    }

                    view.addObject("editAuth", cloneEditAuth);
                    view.addObject("editAuthJson", JSONUtil.toJSONString(cloneEditAuth));
                    view.addObject("editAuthTitle", ResourceUtil.getString("application.92.label"));
                    view.addObject("chooseAuth", "false");
                    if(newauth != null && newauth.split("[.]").length > 1 && cloneEditAuth.size() > 0) {
                        label232: {
                            FormAuthViewBean newAuth = formBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(newauth.split("[.]")[1])));
                            Iterator var43 = cloneEditAuth.iterator();

                            FormAuthViewBean e;
                            do {
                                do {
                                    if(!var43.hasNext()) {
                                        break label232;
                                    }

                                    c = (SimpleObjectBean)var43.next();
                                } while(!Strings.isNotBlank(c.getValue()));

                                e = formBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(c.getValue().split("[.]")[1])));
                            } while(newAuth.getConditionFormAuthViewBeanList().size() <= 0 && e.getConditionFormAuthViewBeanList().size() <= 0);

                            view.addObject("chooseAuth", "true");
                        }
                    }

                    view.addObject("customSet", bindAuthBean.getCustomAuthList());
                    String showAuth = bindAuthBean.getShowFormAuth();
                    if(Strings.isNotBlank(showAuth)) {
                        if("|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                            showAuth = showAuth.substring(0, showAuth.length() - 1);
                        }

                        List<String> showAuths = new ArrayList();
                        String[] showAuthStrs = showAuth.split("[|]");
                        String[] var48 = showAuthStrs;
                        int var24 = showAuthStrs.length;

                        for(i = 0; i < var24; ++i) {
                            String str = var48[i];
                            showAuths.add(str);
                        }

                        view.addObject("showAuth", showAuths);
                    }

                    view.addObject("firstRightId", showAuth.replaceAll("[|]", "_"));
                }

                view.addObject("showFields", DynamicFieldUtil.getTheadStr(showFields, formBean));
                view.addObject("sortStr", DynamicFieldUtil.getSortStr(orderByFields));
                searchFieldList = formBean.getFormType() == FormType.baseInfo.getKey()?DynamicFieldUtil.getSearchField(showFields, formBean):DynamicFieldUtil.getSearchField(searchFields, formBean);
                List<SimpleObjectBean> authList = bindAuthBean.getAuthList();
                view.addObject("allImp", bindAuthBean.getAuthByName(AuthName.ALLOWIMPORT.getKey()));
                view.addObject("authList", authList);
                Long memberId = Long.valueOf(AppContext.currentUserId());
                orgIds = this.orgManager.getAllUserDomainIDs(memberId);
                List<FormQueryBean> queryList = formBean.getFormQueryList();
                List<FormQueryBean> queryList2 = new ArrayList();
                List reportList;
                if(!queryList.isEmpty()) {
                    reportList = this.formAuthModuleDAO.selectModuleIdByOrgList(FormModuleAuthModuleType.Query, orgIds);
                    if(!reportList.isEmpty()) {
                        Set<Long> queryIds = new HashSet(reportList);

                        for( i = 0; i < queryList.size(); ++i) {
                            if(queryIds.contains(((FormQueryBean)queryList.get(i)).getId())) {
                                queryList2.add(queryList.get(i));
                            }
                        }
                    }
                }

                view.addObject("queryList", queryList2);
                reportList = formBean.getFormReportList();
                List<FormReportBean> reportList2 = new ArrayList();
                if(!reportList.isEmpty()) {
                    List<Long> reportIdsList = this.formAuthManager.listAuthByReportIdAndUserId(memberId);
                    if(!reportIdsList.isEmpty()) {
                        Set<Long> reportIds = new HashSet(reportIdsList);

                        for(i = 0; i < reportList.size(); ++i) {
                            if(reportIds.contains(((FormReportBean)reportList.get(i)).getReportDefinition().getId())) {
                                reportList2.add((FormReportBean) reportList.get(i));
                            }
                        }
                    }
                }

                view.addObject("reportList", reportList2);
            }
        }

        view.addObject("searchFields", searchFieldList);
        List<DataContainer> commonSearchFields = new ArrayList();
        List htmls;
        if(((List)searchFieldList).size() > 0) {
            ComponentManager componentManager = (ComponentManager)AppContext.getBean("componentManager");

            DataContainer o;
            for(Iterator var32 = ((List)searchFieldList).iterator(); var32.hasNext(); commonSearchFields.add(o)) {
                FormFieldBean fb = (FormFieldBean)var32.next();
                fb = fb.findRealFieldBean();
                o = new DataContainer();
                o.put("id", fb.getName());
                o.put("name", fb.getName());
                o.put("value", fb.getName());
                o.put("text", fb.getDisplay());
                o.put("type", "datemulti");
                o.put("fieldType", fb.getFinalInputType());
                if(fb.getInputTypeEnum() != FormFieldComEnum.OUTWRITE || !fb.getFieldType().equals(FieldType.DATETIME.getKey()) && !fb.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                    if(fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATETIME) {
                        if(!fb.getName().equalsIgnoreCase(MasterTableField.start_date.getKey()) && !fb.getName().equalsIgnoreCase(MasterTableField.modify_date.getKey())) {
                            o.put("dateTime", Boolean.valueOf(true));
                            o.put("minuteStep", Integer.valueOf(1));
                        } else {
                            o.put("dateTime", Boolean.valueOf(false));
                            o.put("ifFormat", "%Y-%m-%d");
                        }
                    } else if(fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATE) {
                        o.put("dateTime", Boolean.valueOf(false));
                        o.put("ifFormat", "%Y-%m-%d");
                    } else {
                        String op;
                        if(fb.getInputTypeEnum() == FormFieldComEnum.RADIO) {
                            o.put("type", "customPanel");
                            o.put("readonly", "readonly");
                            o.put("panelWidth", Integer.valueOf(270));
                            o.put("panelHeight", Integer.valueOf(200));
                            htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), (List)null, (List)null);
                            op = ((String[])htmls.get(0))[0].replace("<select", "<select style='display:none;' ");
                            o.put("customHtml", op + ((String[])htmls.get(0))[1]);
                        } else {
                            o.put("type", "custom");
                            htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), (List)null, (List)null);
                            op = ((String[])htmls.get(0))[0].replace("<select", "<select style='display:none;' ");
                            String html = ((String[])htmls.get(0))[1];
                            if(fb.getInputTypeEnum().isMultiOrg() || fb.getOutwriteFieldInputType().isMultiOrg()) {
                                html = ((String[])htmls.get(0))[1].replace("<textarea", "<input type='text'").replace("textarea", "input");
                            }

                            o.put("customHtml", op + html);
                        }
                    }
                } else if(fb.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                    o.put("dateTime", Boolean.valueOf(false));
                    o.put("ifFormat", "%Y-%m-%d");
                } else {
                    o.put("dateTime", Boolean.valueOf(true));
                    o.put("minuteStep", Integer.valueOf(1));
                }
            }
        }

        DataContainer dc = new DataContainer();
        dc.add("commonSearchFields", commonSearchFields);
        view.addObject("commonSearchFields", dc.getJson());
        showFields = formBean.getAllFieldBeans();
        orderByFields = FormUtil.findUrlFieldList(showFields);
        Map<String, Object> formP = new HashMap();
        formP.put("id", formBean.getId());
        formP.put("tableList", formBean.getAllTableName());
        view.addObject("urlFieldList", JSONUtil.toJSONString(orderByFields));
        view.addObject("moduleType", Integer.valueOf(formBean.getFormType() == FormType.baseInfo.getKey()?ModuleType.unflowBasic.getKey():ModuleType.unflowInfo.getKey()));
        view.addObject("formId", formBean.getId());
        view.addObject("toFormBean", JSONUtil.toJSONString(formP));
        view.addObject("type", type);
        view.addObject("formType", Integer.valueOf(formBean.getFormType()));
        view.addObject("currentUserId", Long.valueOf(AppContext.currentUserId()));
        htmls = this.formDataManager.findUnfolwFormSearchFieldVOs(formId, formTemplateId);
        view.addObject("formSearchFields", JSONUtil.toJSONString(htmls));
        view.addObject("hasBarcode", Boolean.valueOf(AppContext.hasPlugin("barCode")));
        return view;
    }

    public ModelAndView showEnumsChoose(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/form/common/showEnumsChoose");
        long formId = ReqUtil.getLong(request, "formId", 0L);
        String fieldName = ReqUtil.getString(request, "fieldName");
        FormBean formBean = this.formCacheManager.getForm(formId);
        FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
        List<CtpEnumItem> enumList = this.formDataManager.findEnumListByField(fieldBean);
        mav.addObject("enumList", enumList);
        return mav;
    }

    public ModelAndView showTriggerEventList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ModelAndView mav = new ModelAndView("ctp/form/common/formTriggerEventList");
        if(!AppContext.isSystemAdmin()) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');window.close()");
        }

        return mav;
    }

    public ModelAndView colFormRelationList(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView view = new ModelAndView("ctp/form/common/colFormRelationList");
        Map params = request.getParameterMap();
        Long toFromId = ParamUtil.getLong(params, "formId");
        Long fromFormId = ParamUtil.getLong(params, "fromFormId");
        String fromRelationAttr = ParamUtil.getString(params, "fromRelationAttr");
        String toRelationAttr = ParamUtil.getString(params, "toRelationAttr");
        boolean showView = StringUtil.checkNull(ParamUtil.getString(params, "showView"))?true:Boolean.parseBoolean(ParamUtil.getString(params, "showView"));
        FormBean fromFormBean = this.formCacheManager.getForm(fromFormId.longValue());
        FormBean toFormBean = this.formCacheManager.getForm(toFromId.longValue());
        view.addObject("showView", Boolean.valueOf(showView));
        FormFieldBean fromFieldBean = fromFormBean.getFieldBeanByName(fromRelationAttr);
        FormFieldBean toFieldBean = toFormBean.getFieldBeanByName(toRelationAttr);
        String fromFieldType = fromFieldBean.isMasterField()?"m":"s";
        String toFieldType = toFieldBean != null && !toFieldBean.isMasterField()?"s":"m";
        view.addObject("relationInitParam", fromFieldType + toFieldType);
        Map<String, Object> formP = new HashMap();
        formP.put("id", toFormBean.getId());
        formP.put("tableList", toFormBean.getAllTableName());
        view.addObject("formId", toFormBean.getId());
        view.addObject("toFormBean", JSONUtil.toJSONString(formP));
        return view;
    }

    public ModelAndView newUnFlowFormData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("ctp/form/common/newUnFlowFormData");
        Map params = request.getParameterMap();
        Long contentAllId = ParamUtil.getLong(params, "contentAllId");
        String rightId = ParamUtil.getString(params, "rightId");
        Long viewId = ParamUtil.getLong(params, "viewId");
        Long formId = ParamUtil.getLong(params, "formId");
        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        String moduleType = ParamUtil.getString(params, "moduleType");
        String isNew = ParamUtil.getString(params, "isNew");
        String _from = ParamUtil.getString(params, "_from");
        if(!FormService.checkRight(FormModuleAuthModuleType.BindAppForm, formTemplateId.longValue(), Long.valueOf(AppContext.currentUserId()), formId)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');window.close()");
        }

        if(!Boolean.parseBoolean(isNew)) {
            boolean hasEditFlag = this.formManager.checkUnFlowFormFieldCanEdit(formId, rightId);
            if(this.formManager.getLock(contentAllId) == null && hasEditFlag) {
                this.formManager.lockFormData(contentAllId);
            }

            boolean displayNextAndPre = true;
            if("scanner".equals(_from)) {
                displayNextAndPre = false;
            }

            view.addObject("displayNextAndPre", Boolean.valueOf(displayNextAndPre));
        }

        FormBean fb = this.formManager.getForm(formId);
        FormBindAuthBean formBind = fb.getBind().getUnFlowTemplateById(formTemplateId);
        view.addObject("contentAllId", contentAllId);
        view.addObject("rightId", rightId);
        view.addObject("viewId", viewId);
        view.addObject("formId", formId);
        view.addObject("formTemplateId", formTemplateId);
        view.addObject("moduleType", moduleType);
        view.addObject("isNew", isNew);
        view.addObject("scanCodeInput", Strings.isBlank(formBind.getScanCodeInput())?"":formBind.getScanCodeInput());
        view.addObject("fromSrc", ParamUtil.getString(params, "fromSrc"));
        return view;
    }

    public ModelAndView viewUnflowFormData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("ctp/form/common/viewUnflowFormData");
        Map params = request.getParameterMap();
        Long moduleId = ParamUtil.getLong(params, "moduleId");
        if(moduleId.longValue() == -1L) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("form.exception.datanotexit") + "');window.close()");
            return null;
        } else {
            String rightId = ParamUtil.getString(params, "rightId");
            String moduleType = ParamUtil.getString(params, "moduleType");
            Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
            Long formId = ParamUtil.getLong(params, "formId");
            String from = ParamUtil.getString(params, "_from");
            boolean allowPrint = false;
            boolean displayNextAndPre = true;
            if("scanner".equals(from)) {
                displayNextAndPre = false;
            }

            if(formId == null) {
                displayNextAndPre = false;
                if(Strings.isNotBlank(rightId) && !"0".equals(rightId) && (moduleId.longValue() == 0L || moduleId.longValue() == -1L)) {
                    super.rendJavaScript(response, "alert('" + ResourceUtil.getString("form.exception.datanotexit") + "');window.close()");
                }
            } else {
                FormBean formBean = this.formManager.getForm(formId);
                if(formBean.getFormType() == FormType.baseInfo.getKey()) {
                    allowPrint = true;
                } else if(formBean.getFormType() == FormType.manageInfo.getKey()) {
                    FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
                    List<SimpleObjectBean> authList = bindAuthBean.getAuthList();
                    Iterator var16 = authList.iterator();

                    while(var16.hasNext()) {
                        SimpleObjectBean one = (SimpleObjectBean)var16.next();
                        if("allowprint".equals(one.getName()) && "true".equals(one.getValue())) {
                            allowPrint = true;
                            break;
                        }
                    }
                }
            }

            view.addObject("formId", formId);
            view.addObject("displayNextAndPre", Boolean.valueOf(displayNextAndPre));
            view.addObject("allowprint", Boolean.valueOf(allowPrint));
            view.addObject("moduleId", moduleId);
            view.addObject("rightId", rightId);
            view.addObject("moduleType", moduleType);
            return view;
        }
    }

    public ModelAndView batchUpdateData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("ctp/form/common/batchUpdateData");
        Map params = request.getParameterMap();
        Long formId = ParamUtil.getLong(params, "formId");
        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        if(!FormService.checkRight(FormModuleAuthModuleType.BindAppForm, formTemplateId.longValue(), Long.valueOf(AppContext.currentUserId()), formId)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');window.close()");
        }

        List<Map<String, String>> resutl = this.formDataManager.getBatchUpdateHTML(formId, formTemplateId);
        view.addObject("result", resutl);
        view.addObject("haveField", Boolean.valueOf(Strings.isNotEmpty(resutl)));
        return view;
    }

    public ModelAndView unflowForm(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView view = new ModelAndView("ctp/form/common/unflowForm");
        Map params = request.getParameterMap();
        int formType = ParamUtil.getInt(params, "formType").intValue();
        List<FormBean> formList = this.formCacheManager.getFormsByType(formType);
        List<Map<String, Object>> wapperMapList = new ArrayList();
        Iterator var8 = formList.iterator();

        while(true) {
            FormBean fbean;
            do {
                if(!var8.hasNext()) {
                    view.addObject("size", Integer.valueOf(wapperMapList.size()));
                    view.addObject("formType", Integer.valueOf(formType));
                    return view;
                }

                fbean = (FormBean)var8.next();
            } while(!this.formCacheManager.isEnabled(fbean.getId()));

            FormBindBean bindBean = fbean.getBind();
            Map<String, FormBindAuthBean> templates = bindBean.getUnFlowTemplateMap();
            Iterator var12 = templates.entrySet().iterator();

            while(var12.hasNext()) {
                Entry<String, FormBindAuthBean> entry = (Entry)var12.next();
                FormBindAuthBean template = (FormBindAuthBean)entry.getValue();
                if(template.checkRight(AppContext.currentUserId())) {
                    Map<String, Object> wapperMap = new HashMap();
                    wapperMap.put("id", template.getId());
                    wapperMap.put("pId", Long.valueOf(fbean.getCategoryId()));
                    wapperMap.put("name", template.getName());
                    wapperMap.put("formId", fbean.getId());
                    wapperMapList.add(wapperMap);
                }
            }
        }
    }

    public ModelAndView unflowFormSectionMore(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        request.setAttribute("unflowFormSectionMore", "true");
        return this.getFormMasterDataList(request, response);
    }

    public ModelAndView exportRepeatTableData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long formId = Long.valueOf(ReqUtil.getLong(request, "formId"));
        Long formTemplateId = Long.valueOf(ReqUtil.getLong(request, "formTemplateId"));
        Long moduleId = Long.valueOf(ReqUtil.getLong(request, "moduleId"));
        Long rightId = Long.valueOf(ReqUtil.getLong(request, "rightId"));
        String tableName = ReqUtil.getString(request, "tableName");
        Long formMasterId = Long.valueOf(ReqUtil.getLong(request, "formMasterId"));
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;
        FormAuthViewBean authViewBean = null;

        try {
            frontMasterBean = this.formManager.procFormParam(formBean, formMasterId, rightId);
            cacheMasterData = this.formManager.getSessioMasterDataBean(frontMasterBean.getId());
            this.formManager.mergeFormData(frontMasterBean, cacheMasterData, formBean);
            DataBaseHandler.getInstance().putData("cacheMasterData",cacheMasterData.toXML());
            DataBaseHandler.getInstance().putData("frontMasterBean",frontMasterBean.toXML());//;
        } catch (BusinessException var34) {
            LOGGER.error(var34.getMessage(), var34);
        }

        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            authViewBean = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(authViewBean == null) {
            authViewBean = formBean.getAuthViewBeanById(rightId);
        }

        FormTableBean formTableBean = formBean.getTableByTableName(tableName);
        List<FormFieldBean> allField = formTableBean.getFields();
        Set<String> viewFieldSet = new HashSet(formBean.getAllFieldBeans().size());
        long viewId = authViewBean.getFormViewId();
        FormViewBean formViewBean = formBean.getFormView(viewId);
        viewFieldSet.addAll(formViewBean.getFieldList());
        List<String> comEnums = new ArrayList();
        comEnums.add(FormFieldComEnum.EXTEND_ATTACHMENT.getKey());
        comEnums.add(FormFieldComEnum.EXTEND_DOCUMENT.getKey());
        comEnums.add(FormFieldComEnum.EXTEND_IMAGE.getKey());
        comEnums.add(FormFieldComEnum.EXTEND_EXCHANGETASK.getKey());
        comEnums.add(FormFieldComEnum.EXTEND_QUERYTASK.getKey());
        comEnums.add(FormFieldComEnum.HANDWRITE.getKey());
        comEnums.add(FormFieldComEnum.MAP_LOCATE.getKey());
        comEnums.add(FormFieldComEnum.MAP_MARKED.getKey());
        comEnums.add(FormFieldComEnum.MAP_PHOTO.getKey());
        comEnums.add(FormFieldComEnum.LINE_NUMBER.getKey());
        comEnums.add(FormFieldComEnum.BARCODE.getKey());
        List<FormFieldBean> toExportField = new ArrayList();
        Iterator var21 = allField.iterator();

        while(var21.hasNext()) {
            FormFieldBean tempField = (FormFieldBean)var21.next();
            tempField = tempField.findRealFieldBean();
            if(viewFieldSet.contains(tempField.getName()) && !comEnums.contains(tempField.getRealInputType())) {
                toExportField.add(tempField);
            }
        }

        String title = formBean.getFormName();
        String fileName = formBean.getFormName() + "_" + formTableBean.getDisplay();
        List<FormDataSubBean> subDataBeanList = cacheMasterData.getSubData(tableName);
        List<List<String>> slaveDataList = new ArrayList();
        List<String> oneRow = null;
        Iterator var26 = subDataBeanList.iterator();

        while(var26.hasNext()) {
            FormDataSubBean subData = (FormDataSubBean)var26.next();
            oneRow = new ArrayList();

            Object data="";
            for(Iterator var28 = toExportField.iterator(); var28.hasNext(); oneRow.add(String.valueOf(data))) {
                FormFieldBean tempField = (FormFieldBean)var28.next();
                tempField = tempField.findRealFieldBean();
                Object value = subData.getFieldValue(tempField.getName());

                FormAuthViewFieldBean formAuthViewFieldBean = authViewBean.getFormAuthorizationField(tempField.getName());
                if(FieldAccessType.hide.getKey().equals(formAuthViewFieldBean.getAccess())) {
                    data = "*";
                } else if(value == null) {
                    data = "";
                } else {
                    Object[] objs = tempField.getDisplayValue(value, false, true, true);
                    data = objs[1];
                }
            }

            slaveDataList.add(oneRow);
        }

        this.fileToExcelManager.save(response, Strings.isBlank(fileName)?formBean.getFormName():fileName, new DataRecord[]{QueryUtil.exportOneSheetForExcel(formBean, title, toExportField, new HashMap(), slaveDataList, false, (String)null)});
        return null;
    }

    public ModelAndView exporttoExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        StringBuffer logs = new StringBuffer();
        Long formId = Long.valueOf(ReqUtil.getLong(request, "formId"));
        Long formTemplateId = Long.valueOf(ReqUtil.getLong(request, "formTemplateId"));
        Long rightId = Long.valueOf(ReqUtil.getLong(request, "rightId"));
        String queryConditionStr = request.getParameter("queryConditionStr");
        String exportType = request.getParameter("exportType");
        Map<String, Object> conditions = (Map)JSONUtil.parseJSONString(queryConditionStr, Map.class);
        if(!"base".equals(exportType)) {
            Iterator var10 = conditions.entrySet().iterator();

            label120:
            while(true) {
                while(true) {
                    if(!var10.hasNext()) {
                        break label120;
                    }

                    Entry<String, Object> tempMap = (Entry)var10.next();
                    Object o = tempMap.getValue();
                    if(o instanceof Map) {
                        Map<String, Object> valueMap = (Map)o;
                        if(valueMap != null) {
                            Object fieldValue = valueMap.get("fieldValue");
                            valueMap.put("fieldValue", URLDecoder.decode((String)fieldValue, "UTF-8"));
                        }
                    } else {
                        JSONArray arr = (JSONArray)o;
                        Iterator var14 = arr.iterator();

                        while(var14.hasNext()) {
                            Object tempObj = var14.next();
                            Map<String, Object> valueMap = (Map)tempObj;
                            if(valueMap != null) {
                                Object fieldValue = valueMap.get("fieldValue");
                                valueMap.put("fieldValue", URLDecoder.decode((String)fieldValue, "UTF-8"));
                            }
                        }
                    }
                }
            }
        }

        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
        long currentUserId = AppContext.currentUserId();
        List<List<FormFieldBean>> fields = new ArrayList();
        if(bindAuthBean != null) {
            this.formDataManager.addDownlaodRecord(formBean.getId(), bindAuthBean.getId(), Long.valueOf(currentUserId));
            List<FormFieldBean> masterList = new ArrayList();
            List<SimpleObjectBean> showFields = bindAuthBean.getShowFieldList();

            FormFieldBean ffb;
            for(Iterator var41 = showFields.iterator(); var41.hasNext(); masterList.add(ffb)) {
                SimpleObjectBean sob = (SimpleObjectBean)var41.next();
                ffb = null;
                if(sob.getName().indexOf(".") > -1) {
                    String[] strs = sob.getName().split("[.]");
                    ffb = formBean.getFieldBeanByName(strs[1]);
                } else {
                    MasterTableField mtf = MasterTableField.getEnumByKey(sob.getName());
                    if(mtf != null) {
                        ffb = mtf.getFormFieldBean();
                    }
                }
            }

            fields.add(masterList);
            List<List<FormFieldBean>> expotFieldLists = this.formDataManager.getFormFieldDisplayForImportAndExport(formBean, bindAuthBean, AuthName.BROWSE);
            if(expotFieldLists.size() > 1) {
                Iterator var44 = expotFieldLists.iterator();

                while(var44.hasNext()) {
                    List<FormFieldBean> expotFieldList = (List)var44.next();
                    if(expotFieldList != null && !expotFieldList.isEmpty() && !((FormFieldBean)expotFieldList.get(0)).getOwnerTableName().contains(TableType.MASTER.getTableSufName())) {
                        fields.add(expotFieldList);
                    }
                }
            }
        }

        Map<String, Object> params = new HashMap();
        List<Long> ids = new ArrayList();
        params.put("formId", formId);
        params.put("formTemplateId", formTemplateId);
        String page = request.getParameter("page");
        String size = request.getParameter("size");
        FlipInfo flipInfo = new FlipInfo(Integer.parseInt(page), Integer.parseInt(size));
        if(conditions != null) {
            params.putAll(conditions);
        }

        new ArrayList();
        List formDataMasterList;
        if("base".equals(exportType)) {
            formDataMasterList = this.formDataManager.getFormMasterDataList(flipInfo, params, true).getData();
        } else {
            formDataMasterList = this.formManager.getFormMasterDataListByFormId(flipInfo, params, true).getData();
        }

        logs.append(ResourceUtil.getString("form.condition.guideout.label") + formDataMasterList.size() + ResourceUtil.getString("form.query.querySet.dataQuery.nodelabel") + ":");
        List<List<String>> masterDataList = new ArrayList();
        Map<Long, String> idMap = new HashMap();
        int idx = 1;
        Iterator var24 = formDataMasterList.iterator();

        Map slaveDataMap;
        String tableName;
        while(var24.hasNext()) {
            slaveDataMap = (Map)var24.next();
            Long id = (Long)slaveDataMap.get(MasterTableField.id.getKey());
            ids.add(id);
            List<String> data = new ArrayList();
            if(fields.size() > 1) {
                tableName = "$" + idx++;
                idMap.put(id, tableName);
                data.add(tableName);
            }

            Iterator var53 = ((List)fields.get(0)).iterator();

            while(var53.hasNext()) {
                FormFieldBean ffb = (FormFieldBean)var53.next();
                String temp_data = slaveDataMap.get(ffb.getName().replace("_", "")) + "";
                if(StringUtil.checkNull(temp_data)) {
                    temp_data = "";
                }

                data.add(temp_data);
                logs.append(FormLogUtil.getLogForExportExcel(formBean, ffb, temp_data));
            }

            masterDataList.add(data);
        }

        List<Map<Long, List<List<String>>>> slaveDataList = new ArrayList();
        slaveDataMap = null;
        if(fields.size() > 1 && ids.size() > 0) {
            for(int i = 1; i < fields.size(); ++i) {
                List<FormFieldBean> slaveFieldList = (List)fields.get(i);
                if(slaveFieldList != null && !slaveFieldList.isEmpty()) {
                    tableName = ((FormFieldBean)slaveFieldList.get(0)).getOwnerTableName();
                    List<Map<String, Object>> formSlaveDataList = this.formDataManager.getFormSlaveDataListById((String[])null, tableName, SubTableField.formmain_id.getKey(), ids);
                    FormUtil.setShowValueList(formBean, FormUtil.getUnflowFormAuth(formBean, String.valueOf(formTemplateId)), formSlaveDataList, true, true);
                    slaveDataMap = this.convertSlaveDataListToMap(formBean, formSlaveDataList, slaveFieldList, idMap);
                    slaveDataList.add(slaveDataMap);
                }
            }
        }

        this.fileToExcelManager.save(response, formBean.getFormName() + "_" + page, QueryUtil.exportExcel(formBean, bindAuthBean.getName(), fields, new HashMap(), masterDataList, slaveDataList, ids));
        this.formLogManager.saveOrUpdateLog(formId, formBean.getFormType(), formTemplateId, Long.valueOf(currentUserId), FormLogOperateType.EXPORTEXCEL.getKey(), logs.toString(), (Long)null, (Date)null);
        this.formDataManager.removeDownloadRecord(formBean.getId(), bindAuthBean.getId(), Long.valueOf(currentUserId));
        return null;
    }

    private Map<Long, List<List<String>>> convertSlaveDataListToMap(FormBean formBean, List<Map<String, Object>> formDataList, List<FormFieldBean> showFieldList, Map<Long, String> idMap) throws BusinessException {
        if(showFieldList != null && formDataList != null) {
            Map<Long, List<List<String>>> dataMap = new HashMap();
            Map<String, FormFieldBean> realFormFieldBeanMap = new HashMap();
            Iterator var7 = formDataList.iterator();

            while(var7.hasNext()) {
                Map<String, Object> lineValues = (Map)var7.next();
                Long mainId = Long.valueOf(String.valueOf(lineValues.get(SubTableField.formmain_id.getKey())));
                List rowList;
                if(dataMap.containsKey(mainId)) {
                    rowList = (List)dataMap.get(mainId);
                } else {
                    rowList = new ArrayList();
                    dataMap.put(mainId, rowList);
                }

                List<String> row = new ArrayList();
                row.add(idMap.get(mainId));
                Iterator var12 = showFieldList.iterator();

                while(var12.hasNext()) {
                    FormFieldBean showField = (FormFieldBean)var12.next();
                    String key = showField.getDisplay();
                    FormFieldBean fieldBean = formBean.getFieldBeanByDisplay(key);
                    if(fieldBean != null) {
                        if(realFormFieldBeanMap.containsKey(key)) {
                            fieldBean = (FormFieldBean)realFormFieldBeanMap.get(key);
                        } else {
                            fieldBean = fieldBean.findRealFieldBean();
                            realFormFieldBeanMap.put(key, fieldBean);
                        }

                        Object value = lineValues.get(fieldBean.getName());
                        if(value == null) {
                            row.add("");
                        } else {
                            row.add(value.toString());
                        }
                    } else {
                        MasterTableField me = MasterTableField.getEnumByText(key);
                        if(null != me) {
                            fieldBean = me.getFormFieldBean();
                        }

                        if(fieldBean != null) {
                            Object value = lineValues.get(fieldBean.getName());
                            row.add(value.toString());
                        }
                    }
                }

                ((List)rowList).add(row);
            }

            return dataMap;
        } else {
            return null;
        }
    }

    public ModelAndView downTemplate(HttpServletRequest request, HttpServletResponse response) throws BusinessException, Exception {
        Map map = ParamUtil.getJsonParams();
        Long formId = ParamUtil.getLong(map, "formId");
        String field = ParamUtil.getString(map, "field");
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        List<List<FormFieldBean>> expotFieldLists = FormUtil.splitFieldName2Field(formBean, field);
        String fileName = "导入模板";
        Iterator var9 = expotFieldLists.iterator();

        while(var9.hasNext()) {
            List<FormFieldBean> expotFieldList = (List)var9.next();
            if(expotFieldList.size() > 255) {
                fileName = "导入模板.xlsx";
                break;
            }
        }

        this.fileToExcelManager.save(response, fileName, QueryUtil.exportFormForExcelTemplate("导入模板", "导入模板", expotFieldLists));
        return null;
    }

    public ModelAndView exportRepeatTableTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        Long formId = Long.valueOf(ReqUtil.getLong(request, "formId"));
        Long rightId = Long.valueOf(ReqUtil.getLong(request, "rightId"));
        String tableName = ReqUtil.getString(request, "tableName");
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        formBean.getAuthViewBeanById(rightId);
        List<String> expotFields = new ArrayList();
        String field = ReqUtil.getString(request, "field");
        if(Strings.isNotEmpty(field)) {
            String[] fieldNames = field.split(",");
            String[] var11 = fieldNames;
            int var12 = fieldNames.length;

            for(int var13 = 0; var13 < var12; ++var13) {
                String name = var11[var13];
                String fieldName = name;
                if(name.contains(".")) {
                    fieldName = name.substring(name.indexOf("."));
                }

                FormFieldBean fb = formBean.getFieldBeanByName(fieldName);
                expotFields.add(fb.getDisplay());
            }
        }

        if(expotFields.isEmpty()) {
            PrintWriter out = null;

            try {
                out = response.getWriter();
                out.println("<script>");
                out.println("parent.$.alert(\"" + ResourceUtil.getString("form.repeatdata.importexcel.templatenull") + "\")");
                out.println("window.close();");
                out.println("</script>");
                out.flush();
            } catch (IOException var20) {
                LOGGER.error(var20.getMessage(), var20);
            } finally {
                if(out != null) {
                    out.close();
                }

            }
        } else {
            this.fileToExcelManager.save(response, ResourceUtil.getString("form.repeatdata.importexcel.excelname"), new DataRecord[]{QueryUtil.exportTemplate(ResourceUtil.getString("form.repeatdata.importexcel.template"), expotFields, new HashMap())});
        }

        return null;
    }

    public ModelAndView dealExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, Object> data = ParamUtil.getJsonParams();
        Map<String, Object> params = new HashMap();
        params.put("fileUrl", ReqUtil.getString(request, "fileUrl"));
        params.put("formId", ReqUtil.getString(request, "formId"));
        params.put("rightId", ReqUtil.getString(request, "rightId"));
        params.put("tableName", ReqUtil.getString(request, "tableName"));
        params.put("formMasterId", ReqUtil.getString(request, "formMasterId"));
        params.put("recordId", ReqUtil.getString(request, "recordId"));
        String res = this.formDataManager.dealExcelForImport(params, data);
        PrintWriter out = null;

        try {
            out = response.getWriter();
            out.println(res);
            out.flush();
        } catch (IOException var11) {
            LOGGER.error(var11.getMessage(), var11);
        } finally {
            if(out != null) {
                out.close();
            }

        }

        return null;
    }

    public ModelAndView showLog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("ctp/form/common/formLogShow");
        Long formId = Long.valueOf(ReqUtil.getLong(request, "formId"));
        Long recordId = Long.valueOf(ReqUtil.getLong(request, "recordId", -1L));
        Long formTemplateId = Long.valueOf(ReqUtil.getLong(request, "formTemplateId", -1L));
        if(!FormService.checkRight(FormModuleAuthModuleType.BindAppForm, formTemplateId.longValue(), Long.valueOf(AppContext.currentUserId()), formId)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');window.close()");
        }

        view.addObject("formId", formId);
        view.addObject("recordId", recordId);
        view.addObject("formType", ReqUtil.getString(request, "formType"));
        view.addObject("single", ReqUtil.getString(request, "single"));
        return view;
    }

    public ModelAndView exportLogs(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        String logLable = ResourceUtil.getString("form.log.label");
        Map<String, Object> params = new HashMap();
        params.put("formId", ReqUtil.getString(request, "formId"));
        params.put("size", ReqUtil.getString(request, "size"));
        params.put("page", ReqUtil.getString(request, "page"));
        if(ReqUtil.getString(request, "beginoperatime") != null) {
            params.put("beginoperatime", ReqUtil.getString(request, "beginoperatime"));
        }

        if(ReqUtil.getString(request, "endoperatime") != null) {
            params.put("endoperatime", ReqUtil.getString(request, "endoperatime"));
        }

        if(ReqUtil.getString(request, "operateType") != null) {
            params.put("operateType", ReqUtil.getString(request, "operateType"));
        }

        if(ReqUtil.getString(request, "begincreatetime") != null) {
            params.put("begincreatetime", ReqUtil.getString(request, "begincreatetime"));
        }

        if(ReqUtil.getString(request, "endcreatetime") != null) {
            params.put("endcreatetime", ReqUtil.getString(request, "endcreatetime"));
        }

        if(ReqUtil.getString(request, "creator") != null) {
            params.put("creator", ReqUtil.getString(request, "creator"));
        }

        if(ReqUtil.getString(request, "operator") != null) {
            params.put("operator", ReqUtil.getString(request, "operator"));
        }

        if(ReqUtil.getString(request, "recordId") != null) {
            params.put("recordId", ReqUtil.getString(request, "recordId"));
        }

        List<Map<String, Object>> listMap = this.formLogManager.exportLogs(params);
        OrgManager extendMemberOrgManager = (OrgManager)AppContext.getBean("orgManager");
        List<String> expotFields = new ArrayList();
        expotFields.add("操作人员");
        expotFields.add("操作类型");
        expotFields.add("操作描述");
        expotFields.add("操作时间");
        expotFields.add("创建人");
        expotFields.add("创建时间");
        List<List<String>> datas = new ArrayList();

        for(int i = 0; i < listMap.size(); ++i) {
            List<String> data = new ArrayList();
            FormLog fb = (FormLog)listMap.get(i);
            V3xOrgMember member;
            if(extendMemberOrgManager != null) {
                if(fb.getOperator().longValue() == 0L) {
                    data.add(ResourceUtil.getString("form.trigger.triggerSet.unflow.log.system"));
                } else {
                    member = extendMemberOrgManager.getMemberById(fb.getOperator());
                    if(member != null) {
                        data.add(member.getName());
                    }
                }
            }

            data.add(FormLogOperateType.getFromLogOperateTypeByKey(fb.getOperateType().intValue()).getText());
            if(fb.getDescription() != null && fb.getDescription().length() > 32767) {
                String subDescription = fb.getDescription().substring(0, 32763) + "...";
                data.add(subDescription);
            } else {
                data.add(fb.getDescription());
            }

            data.add(DateUtil.format(fb.getOperateDate(), "yyyy-MM-dd HH:mm"));
            if(extendMemberOrgManager != null) {
                member = extendMemberOrgManager.getMemberById(fb.getCreator());
                if(member != null) {
                    data.add(member.getName());
                }
            }

            if(fb.getCreateDate() == null) {
                data.add("");
            } else {
                data.add(DateUtil.format(fb.getCreateDate(), "yyyy-MM-dd HH:mm"));
            }

            datas.add(data);
        }

        try {
            this.fileToExcelManager.save(response, logLable, new DataRecord[]{QueryUtil.exportLogForExcelTemplate(logLable, logLable, expotFields, new HashMap(), datas)});
            return null;
        } catch (Exception var13) {
            throw new BusinessException(var13);
        }
    }

    public ModelAndView modifyAutoSendData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String result = "更新状态完成！";
        if(!this.formDataManager.updateDataState()) {
            result = "部分数据更新发生异常，详情参见日志！";
        }

        super.rendJavaScript(response, "alert('" + result + "')");
        return null;
    }

    public ModelAndView unflowQueryResultSection(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/form/queryResult/unflowQueryResultSection");
        Long queryId = Long.valueOf(ReqUtil.getLong(request, "queryId"));
        Long formId = Long.valueOf(ReqUtil.getLong(request, "formId"));
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(queryId));
        List showFields;
        if(bindAuthBean != null) {
            if(!bindAuthBean.checkRight(AppContext.currentUserId())) {
                LOGGER.error(ResourceUtil.getString("form.showAppFormData.noright"));
                throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
            }

            showFields = bindAuthBean.getShowFieldList();
            mav.addObject("theadStr", DynamicFieldUtil.getTheadStr(showFields, formBean));
            FlipInfo flipInfo = new FlipInfo();
            flipInfo.setSize(50);
            Map<String, Object> params = new HashMap();
            params.put("formId", formBean.getId());
            params.put("formTemplateId", queryId);
            params.put("sortStr", DynamicFieldUtil.getSortStr(bindAuthBean.getOrderByList()));

            try {
                this.formManager.getFormMasterDataListByFormId(flipInfo, params);
            } catch (SQLException var12) {
                LOGGER.error(var12.getMessage(), var12);
                throw new BusinessException(var12);
            }

            mav.addObject("_data", JSONUtil.toJSONString(flipInfo.getData()));
            this.unflowSectionComm(formBean, bindAuthBean, mav, request);
        }

        showFields = formBean.getAllFieldBeans();
        List<String> urlFieldList = FormUtil.findUrlFieldList(showFields);
        mav.addObject("urlFieldList", JSONUtil.toJSONString(urlFieldList));
        return mav;
    }

    public ModelAndView unflowQuerySingleDataSection(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/form/queryResult/unflowSingleDataSection");
        Long queryId = Long.valueOf(ReqUtil.getLong(request, "queryId"));
        Long formId = Long.valueOf(ReqUtil.getLong(request, "formId"));
        String singleType = ReqUtil.getString(request, "singleType");
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(queryId));
        if(bindAuthBean != null) {
            if(!bindAuthBean.checkRight(AppContext.currentUserId())) {
                LOGGER.error(ResourceUtil.getString("form.showAppFormData.noright"));
                throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
            }

            FlipInfo flipInfo = new FlipInfo();
            Map<String, Object> params = new HashMap();
            params.put("formId", formBean.getId());
            params.put("formTemplateId", queryId);
            String sortStr = DynamicFieldUtil.getSortStr(bindAuthBean.getOrderByList());
            params.put("sortStr", sortStr);
            boolean reverse = false;
            if("1".equals(singleType)) {
                reverse = true;
            }

            this.formDataManager.getFormData4SingleData(flipInfo, params, reverse);
            List<Map<String, String>> dataList = flipInfo.getData();
            if(dataList.isEmpty()) {
                return mav;
            }

            Map<String, String> dataObj = (Map)dataList.get(0);
            mav.addObject("_moduleId", dataObj.get("id"));
            this.unflowSectionComm(formBean, bindAuthBean, mav, request);
        }

        return mav;
    }

    private void unflowSectionComm(FormBean formBean, FormBindAuthBean bindAuthBean, ModelAndView mav, HttpServletRequest request) {
        mav.addObject("_moduleType", Integer.valueOf(formBean.getFormType() == FormType.baseInfo.getKey()?ModuleType.unflowBasic.getKey():ModuleType.unflowInfo.getKey()));
        mav.addObject("_templateName", bindAuthBean.getName());
        List editAuth;
        if(formBean.getFormType() == FormType.baseInfo.getKey()) {
            FormViewBean tempFormViewBean = (FormViewBean)formBean.getFormViewList().get(0);
            editAuth = tempFormViewBean.getFormAuthViewBeanListByType(FormAuthorizationType.show);
            mav.addObject("_rightId", ((FormAuthViewBean)editAuth.get(0)).getId());
            List<FormAuthViewBean> addAuths = tempFormViewBean.getFormAuthViewBeanListByType(FormAuthorizationType.add);
            mav.addObject("editAuth", tempFormViewBean.getId() + "." + ((FormAuthViewBean)addAuths.get(0)).getId());
        } else {
            String showAuth = bindAuthBean.getShowFormAuth();
            if(Strings.isNotBlank(showAuth) && "|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                showAuth = showAuth.substring(0, showAuth.length() - 1);
            }

            mav.addObject("_rightId", showAuth.replaceAll("[|]", "_"));
            editAuth = bindAuthBean.getUpdateAuthList();
            List<SimpleObjectBean> cloneEditAuth = new ArrayList();

            SimpleObjectBean c;
            for(Iterator var8 = editAuth.iterator(); var8.hasNext(); cloneEditAuth.add(c)) {
                SimpleObjectBean s = (SimpleObjectBean)var8.next();
                c = null;

                try {
                    c = (SimpleObjectBean)s.clone();
                } catch (CloneNotSupportedException var12) {
                    LOGGER.error(var12.getMessage(), var12);
                }

                if(StringUtil.checkNull(c.getDisplay())) {
                    c.setDisplay(ResourceUtil.getString("application.92.label"));
                }
            }

            mav.addObject("editAuth", JSONUtil.toJSONString(cloneEditAuth));
        }

        mav.addObject("_formId", Long.valueOf(ReqUtil.getLong(request, "formId")));
        mav.addObject("_formTemplateId", Long.valueOf(ReqUtil.getLong(request, "queryId")));
    }

    public ModelAndView setScanningGun(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/form/common/scanningSet");
        return mav;
    }

    @NeedlessCheckLogin
    public ModelAndView showInscribeSignetPic(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean accessDenied = false;
        if(user == null) {
            if(UserHelper.isFromMicroCollaboration(request)) {
                accessDenied = false;
            } else {
                accessDenied = true;
            }
        }

        if(accessDenied) {
            response.setStatus(404);
            return null;
        } else {
            Long id = Long.valueOf(request.getParameter("id"));
            V3xHtmDocumentSignature signet = this.htmSignetManager.getById(id);
            ServletOutputStream out = null;

            try {
                if(signet != null) {
                    String body = signet.getFieldValue();
                    byte[] b = FormUtil.hex2Byte(body);
                    response.setContentType("image/jpeg");
                    out = response.getOutputStream();
                    out.write(b);
                }
            } catch (Exception var18) {
                LOGGER.error("显示电子签名异常", var18);
            } finally {
                if(out != null) {
                    try {
                        out.close();
                    } catch (Exception var17) {
                        LOGGER.error("", var17);
                    }
                }

            }

            return null;
        }
    }

    public ModelAndView getTriggerEventQueneList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView modelAndView = new ModelAndView("ctp/form/common/formTriggreEventList");
        return modelAndView;
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

    public FileToExcelManager getFileToExcelManager() {
        return this.fileToExcelManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public FormLogManager getFormLogManager() {
        return this.formLogManager;
    }

    public void setFormLogManager(FormLogManager formLogManager) {
        this.formLogManager = formLogManager;
    }

    public FileManager getFileManager() {
        return this.fileManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public TemplateManager getTemplateManager() {
        return this.templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public FormDataManager getFormDataManager() {
        return this.formDataManager;
    }

    public void setFormDataManager(FormDataManager formDataManager) {
        this.formDataManager = formDataManager;
    }

    public WorkflowApiManager getWapi() {
        return this.wapi;
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public FormAuthDesignManager getFormAuthDesignManager() {
        return this.formAuthDesignManager;
    }

    public void setFormAuthDesignManager(FormAuthDesignManager formAuthDesignManager) {
        this.formAuthDesignManager = formAuthDesignManager;
    }

    public V3xHtmDocumentSignatManager getHtmSignetManager() {
        return this.htmSignetManager;
    }

    public void setHtmSignetManager(V3xHtmDocumentSignatManager htmSignetManager) {
        this.htmSignetManager = htmSignetManager;
    }

    public void setFormAuthModuleDAO(FormAuthModuleDAO formAuthModuleDAO) {
        this.formAuthModuleDAO = formAuthModuleDAO;
    }

    public void setFormAuthManager(FormAuthManager formAuthManager) {
        this.formAuthManager = formAuthManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
}
