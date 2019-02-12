package com.seeyon.ctp.form.service;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
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
import com.seeyon.ctp.form.bean.FormBindAuthBean.AuthName;
import com.seeyon.ctp.form.bean.FormBindBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.bean.FormQueryBean;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.bean.SimpleObjectBean;
import com.seeyon.ctp.form.formreport.bo.FormReportBean;
import com.seeyon.ctp.form.formreport.manager.FormAuthManager;
import com.seeyon.ctp.form.modules.bind.FormLogManager;
import com.seeyon.ctp.form.modules.component.ComponentManager;
import com.seeyon.ctp.form.modules.engin.authorization.FormAuthDesignManager;
import com.seeyon.ctp.form.modules.engin.authorization.FormAuthModuleDAO;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.form.po.FormLog;
import com.seeyon.ctp.form.util.DynamicFieldUtil;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FieldType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormLogOperateType;
import com.seeyon.ctp.form.util.Enums.FormModuleAuthModuleType;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.MasterTableField;
import com.seeyon.ctp.form.util.Enums.SubTableField;
import com.seeyon.ctp.form.util.Enums.TableType;
import com.seeyon.ctp.form.util.FormConstant;
import com.seeyon.ctp.form.util.FormLogUtil;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.form.util.QueryUtil;
import com.seeyon.ctp.form.vo.FormSearchFieldBaseBo;
import com.seeyon.ctp.form.vo.FormSearchFieldVO;
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

    /**
     * 表单单元格ajax数据提交计算响应
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView calculate(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(CONTENT_TYPE);
        @SuppressWarnings("unchecked")
        Map params = request.getParameterMap();
        long formMasterId = ParamUtil.getLong(params, "formMasterId");
        long formId = ParamUtil.getLong(params, "formId");
        long rightId = ParamUtil.getLong(params, "rightId");
        String fieldName = ParamUtil.getString(params, "fieldName");
        long recordId = ParamUtil.getLong(params, "recordId");
        long moduleId = ParamUtil.getLong(params, "moduleId");
        String calcAll = ParamUtil.getString(params, "calcAll");
        String calcSysRel = ParamUtil.getString(params, "calcSysRel");
        FormBean form = formCacheManager.getForm(formId);
        FormFieldBean fieldBean = form.getFieldBeanByName(fieldName);
        DataContainer resultMap = new DataContainer();
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;
        try {
            //1、接受前台提交的表单提交参数
            frontMasterBean = formManager.procFormParam(form, formMasterId, rightId);
            cacheMasterData = formManager.getSessioMasterDataBean(frontMasterBean.getId());
            if(moduleId!=-1&&moduleId!=0){
            	cacheMasterData.putExtraAttr(FormConstant.moduleId, moduleId);
            }
            //2、将前台提交的表单参数和后台缓存合并
            formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, moduleId, true);
        } catch (Exception e1) {
            LOGGER.error(e1.getMessage(), e1);
        }
        FormAuthViewBean authViewBean = null;
        if (cacheMasterData.getExtraMap().containsKey(FormConstant.viewRight)) {//首先考虑从缓存的FormDataMasterBean中获取权限，因为FormDataMasterBean存放的权限是合并之后的权限
            authViewBean = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
        }
        if (authViewBean == null) {
            authViewBean = form.getAuthViewBeanById(rightId);
        }
        PrintWriter out = null;
        DataContainer dc = new DataContainer();
        try {
            out = response.getWriter();

            if ("true".equals(calcAll)) {
                resultMap.putAll(formDataManager.calcAll(form, cacheMasterData, authViewBean, true, false, "true".equals(calcSysRel)));
            } else {
                boolean hasCalc = false;
                //3、计算当前单元格值的改变所影响的表单中其他单元格的值
                if (fieldBean.isInCalculate()) {
                    hasCalc = true;
                    formDataManager.calcAllWithFieldIn(form, fieldBean, cacheMasterData, recordId, resultMap, authViewBean, true, true);
                }
                //4、处理当前单元格参与的条件判断，如果条件满足，则执行条件之后的动作，比如带条件的系统关联类型表单、带条件的权限
                if (fieldBean.isInCondition()) {
                    if (recordId != 0L) {
                        AppContext.putThreadContext("isTriggerFromSubLine", "true");
                    }
                    if (!hasCalc) {
                        resultMap.putAll(formDataManager.dealSysRelation(form, cacheMasterData, fieldBean, authViewBean, recordId,false,null,true));
                    }
                    resultMap.putAll(formDataManager.dealFormRightChangeResult(form, authViewBean, cacheMasterData));
                }
            }
            //5、当计算完成之后，返回计算所影响的单元格及其结果json字符串,例如：
            dc.add(FormConstant.SUCCESS, "true");
            if (null != cacheMasterData.getExtraAttr(FormConstant.viewRight)) {
                FormAuthViewBean currentAuth = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
                dc.add(FormConstant.viewRight, String.valueOf(currentAuth.getId()));
            }
            //BUG_紧急_V5_V5.1sp1_上海京正投资管理有限公司_有流程表单每次关联底表重复表后带出的数据有丢失，原因：datas在map中如果不是第一个位置，就会出现recordId找不到的情况。
            DataContainer trans = null;
            if(resultMap.containsKey("datas")){
                trans = new DataContainer();
                trans.put("datas",resultMap.get("datas"));
                resultMap.remove("datas");
                trans.putAll(resultMap);
            }
            dc.put(FormConstant.RESULTS, trans==null?resultMap:trans);
        } catch (BusinessException e) {
            LOGGER.error(e.getMessage(), e);
            dc.add(FormConstant.RESULTS, "false");
            dc.add(FormConstant.ERRORMSG, e.getMessage());
        } catch (IOException e) {
            dc.add(FormConstant.RESULTS, "false");
            LOGGER.error(e.getMessage(), e);
        } finally {
            if(out != null){
                out.println(dc.getJson());
            }
        }
        out.flush();
        out.close();
        return null;
    }

    public ModelAndView generageSubData(HttpServletRequest request, HttpServletResponse response){
    	response.setContentType(CONTENT_TYPE);
        @SuppressWarnings("unchecked")
        Map params = request.getParameterMap();
        long formMasterId = ParamUtil.getLong(params, "formMasterId");
        long formId = ParamUtil.getLong(params, "formId");
        long rightId = ParamUtil.getLong(params, "rightId");
        long moduleId = ParamUtil.getLong(params, "moduleId");
        String tableName = ParamUtil.getString(params, "tableName");
        FormBean form = formCacheManager.getForm(formId);
        DataContainer resultMap = new DataContainer();
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;
        try {
            //1、接受前台提交的表单提交参数
            frontMasterBean = formManager.procFormParam(form, formMasterId, rightId);
            cacheMasterData = formManager.getSessioMasterDataBean(frontMasterBean.getId());

            //2、将前台提交的表单参数和后台缓存合并
            formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, moduleId, true);
        } catch (Exception e1) {
            LOGGER.error(e1.getMessage(), e1);
        }
        FormAuthViewBean authViewBean = null;
        if (cacheMasterData.getExtraMap().containsKey(FormConstant.viewRight)) {//首先考虑从缓存的FormDataMasterBean中获取权限，因为FormDataMasterBean存放的权限是合并之后的权限
            authViewBean = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
        }
        if (authViewBean == null) {
            authViewBean = form.getAuthViewBeanById(rightId);
        }
        PrintWriter out = null;
        DataContainer dc = new DataContainer();
        try {
            out = response.getWriter();
            List<FormDataSubBean> newSubDatas = formDataManager.calcRelationSubTable(form, cacheMasterData, tableName, authViewBean, resultMap, true);
            dc.add(FormConstant.SUCCESS, "true");
            if (null != cacheMasterData.getExtraAttr(FormConstant.viewRight)) {
                FormAuthViewBean currentAuth = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
                dc.add(FormConstant.viewRight, String.valueOf(currentAuth.getId()));
            }
            Set<DataContainer> datas = formDataManager.getSubDataLineContainer(form, authViewBean, cacheMasterData, new LinkedHashSet<FormDataSubBean>(newSubDatas), resultMap);
            resultMap.put("datas", new LinkedList(datas));
            //当计算完成之后，返回计算所影响的单元格及其结果json字符串,例如：
            dc.put(FormConstant.RESULTS, resultMap);
        } catch (BusinessException e) {
            LOGGER.error(e.getMessage(), e);
            dc.add(FormConstant.RESULTS, "false");
            dc.add(FormConstant.ERRORMSG, e.getMessage());
        } catch (IOException e) {
            dc.add(FormConstant.RESULTS, "false");
            LOGGER.error(e.getMessage(), e);
        } finally {
            if(out != null){
                out.println(dc.getJson());
            }
        }
        out.flush();
        out.close();
    	return null;
    }
    
    /**
     * 控件值变动之后，调用该方法，合并数据到缓存。
     * @param request
     * @param response
     * @return
     */
    public ModelAndView formPreSubmitData(HttpServletRequest request, HttpServletResponse response){
        response.setContentType(CONTENT_TYPE);

        Map params = request.getParameterMap();
        long formMasterId = ParamUtil.getLong(params, "formMasterId");
        long formId = ParamUtil.getLong(params, "formId");
        long rightId = ParamUtil.getLong(params, "rightId");
        long moduleId = ParamUtil.getLong(params,"moduleId");
        FormBean form = formCacheManager.getForm(formId);

        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;
        try {
            frontMasterBean = formManager.procFormParam(form, formMasterId, rightId);
            cacheMasterData = formManager.getSessioMasterDataBean(frontMasterBean.getId());

            //2、将前台提交的表单参数和后台缓存合并
            formManager.mergeFormData(frontMasterBean, cacheMasterData, form);
            //bug OA-100443 暂时不改此bug，影像点很多
            //formDataManager.saveAttachments(form, cacheMasterData, frontMasterBean, moduleId, true);
        }catch (Exception e1){
            LOGGER.error(e1.getMessage(), e1);
        }
        return null;
    }

    /**
     * 表单单元格ajax数据提交计算响应
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public ModelAndView validateFieldUnique(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(CONTENT_TYPE);
        Map params = request.getParameterMap();
        long formId = ParamUtil.getLong(params, "formId");
        String fieldName = ParamUtil.getString(params, "fieldName");
        String isNew = ParamUtil.getString(params, "isNew");
        FormBean form = formCacheManager.getForm(formId);
        String data = request.getParameter("fieldData") == null ? "" : request.getParameter("fieldData");
        FormFieldBean fieldBean = form.getFieldBeanByName(fieldName);
        PrintWriter out = null;
        boolean isExist = false;
        DataContainer dc = new DataContainer();
        try {
            out = response.getWriter();
            if (fieldBean != null && fieldBean.isUnique() && fieldBean.getFieldType().equals(FieldType.VARCHAR.getKey())) {
                isExist = formDataManager.isFieldValue4Unique(fieldBean, data, isNew);
            }
            dc.add(FormConstant.SUCCESS, isExist);
        } catch (BusinessException e) {
            LOGGER.error(e.getMessage(), e);
            dc.add(FormConstant.RESULTS, "false");
            dc.add(FormConstant.ERRORMSG, StringUtil.toString(e));
        } catch (IOException e) {
            dc.add(FormConstant.RESULTS, "false");
            LOGGER.error(e.getMessage(), e);
        } finally {
            if(out != null){
                out.println(dc.getJson());
            }
        }
        out.flush();
        out.close();
        return null;
    }

    /**
     * 响应添加删除重复行的ajax函数
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView addOrDelDataSubBean(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType(CONTENT_TYPE);
        @SuppressWarnings("unchecked")
        Map params = request.getParameterMap();
        Long formMasterId = ParamUtil.getLong(params, "formMasterId");
        Long formId = ParamUtil.getLong(params, "formId");
        Long rightId = ParamUtil.getLong(params, "rightId");
        String tableName = ParamUtil.getString(params, "tableName");
        String type = ParamUtil.getString(params, "type");
        Long recordId = ParamUtil.getLong(params, "recordId");

        @SuppressWarnings("unchecked")
        Map<String, Object> data = ParamUtil.getJsonParams();
        StringBuffer sb;
        sb = formManager.addOrDelDataSubBean(formMasterId, formId, rightId, tableName, type, recordId, data);

        PrintWriter out = null;
        try {
            out = response.getWriter();
            out.println(sb.toString());
            out.flush();
        } catch (IOException e) {
            LOGGER.error(e.getMessage(), e);
        } finally {
            if(out != null){
                out.close();
            }
        }
        return null;
    }

    /**
     * 根据表单id获取表单主数据
     *
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * @throws IOException
     */
    public ModelAndView getFormMasterDataList(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        response.setContentType(CONTENT_TYPE);
        String isFromSectionMore = (String) request.getAttribute("unflowFormSectionMore");
        ModelAndView view = new ModelAndView("ctp/form/common/formMasterDataList");
        if ("true".equals(isFromSectionMore)) {
            view.addObject("isFormSection", isFromSectionMore);
        }
        Map params = request.getParameterMap();
        //被单元格所关联的表单的表单id
        Long formId = ParamUtil.getLong(params, "formId");
        FormBean formBean = formCacheManager.getForm(formId);
        if (formBean == null || !formManager.isEnabled(formBean)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');parent.window.history.back();");
        }
        view.addObject("viewStyle","1");
        if (formBean.isPhoneForm()) {
            view.addObject("viewStyle","4");
        }
        String type = request.getParameter("type") == null ? "baseInfo" : request.getParameter("type");
        List<FormFieldBean> searchFieldList = new ArrayList<FormFieldBean>();
        User user = AppContext.getCurrentUser();
        //基础数据和信息管理
        if ("baseInfo".equals(type) || "dynamicForm".equals(type)) {
            view.addObject("hasBarcode",AppContext.hasPlugin("barCode") && user.isV5Member());
            Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
            view.addObject("formTemplateId", formTemplateId);
            FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
            if (bindAuthBean != null) {
                if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                    throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
                }
                view.addObject("templateName", bindAuthBean.getName());
                List<SimpleObjectBean> searchFields = bindAuthBean.getSearchFieldList();
                List<SimpleObjectBean> showFields = bindAuthBean.getShowFieldList();
                List<SimpleObjectBean> orderByFields = bindAuthBean.getOrderByList();
                //基础信息默认第一个新增权限，信息管理需要管理员设定权限
                if (formBean.getFormType() == FormType.baseInfo.getKey()) {
                    //新建按钮权限
                    FormViewBean tempFormViewBean = formBean.getFormViewList().get(0);
                    List<FormAuthViewBean> addAuths = tempFormViewBean
                            .getFormAuthViewBeanListByType(FormAuthorizationType.add);
                    view.addObject("newFormAuth", tempFormViewBean.getId() + "." + addAuths.get(0).getId());
                    //修改权限
                    //OA-88559 基础数据：扫描URL二维码时，默认应该是修改页面（基础数据默认有修改权限），实际上是打开的查看页面，与预期不符
                    List<SimpleObjectBean> editAuth = new ArrayList<SimpleObjectBean>();
                    SimpleObjectBean sob = new SimpleObjectBean(0L,SimpleObjectBean.ColumnType.Auth.getKey(), AuthName.UPDATE.getKey(),tempFormViewBean.getId() + "." + addAuths.get(0).getId(),addAuths.get(0).getName());
                    editAuth.add(sob);
                    view.addObject("editAuth", tempFormViewBean.getId() + "." + addAuths.get(0).getId());
                    view.addObject("editAuthJson", JSONUtil.toJSONString(editAuth));
                    List<FormAuthViewBean> formShowAuths = tempFormViewBean
                            .getFormAuthViewBeanListByType(FormAuthorizationType.show);
                    //基础数据因为绑定中没有设置显示的时候是用哪个视图下的那个查看权限，所以取第一个视图下的第一个查看权限
                    view.addObject("firstRightId", formShowAuths.get(0).getId());
                } else {
                    //新建按钮权限
                    String newauth = bindAuthBean.getNewFormAuth();
                    view.addObject("newFormAuth", bindAuthBean.getNewFormAuth());
                    String newBtnTitile = bindAuthBean.getAuthObjByName(AuthName.ADD.getKey()).getDisplay();
                    if (Strings.isBlank(newBtnTitile)) {
                        newBtnTitile = ResourceUtil.getString("form.formlist.newform");//新增
                    }
                    view.addObject("newFormAuthTitle", Strings.escapeJavascript(newBtnTitile));
                    //修改权限
                    List<SimpleObjectBean> editAuth = bindAuthBean.getUpdateAuthList();
                    List<SimpleObjectBean> cloneEditAuth = new ArrayList<SimpleObjectBean>();
                    for (SimpleObjectBean s : editAuth) {
                        //修改设置对应权限没有配置时，不显示修改按钮，兼容历史数据
                        if (Strings.isBlank(s.getValue())){
                            continue;
                        }
                        SimpleObjectBean c = null;
                        try {
                            c = (SimpleObjectBean) s.clone();
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                        if (StringUtil.checkNull(c.getDisplay())) {
                            c.setDisplay(ResourceUtil.getString("application.92.label"));
                        } else {
                            c.setDisplay(Strings.escapeJavascript(c.getDisplay()));
                        }
                        cloneEditAuth.add(c);
                    }
                    editAuth = cloneEditAuth;
                    view.addObject("editAuth", editAuth);
                    view.addObject("editAuthJson", JSONUtil.toJSONString(editAuth));
                    view.addObject("editAuthTitle", ResourceUtil.getString("application.92.label"));
                    //如果有设置的有高级权限,则修改时提示客户选择哪个权限进行编辑
                    view.addObject("chooseAuth", "false");
                    if (newauth != null && newauth.split("[.]").length > 1 && editAuth.size() > 0) {
                        FormAuthViewBean newAuth = formBean.getAuthViewBeanById(Long.parseLong(newauth.split("[.]")[1]));
                        for (SimpleObjectBean s : editAuth) {
                            if (Strings.isNotBlank(s.getValue())) {
                                FormAuthViewBean e = formBean.getAuthViewBeanById(Long.parseLong(s.getValue().split("[.]")[1]));
                                if (newAuth.getConditionFormAuthViewBeanList().size() > 0 || e.getConditionFormAuthViewBeanList().size() > 0) {
                                    view.addObject("chooseAuth", "true");
                                    break;
                                }
                            }
                        }
                    }
                    view.addObject("customSet", bindAuthBean.getCustomAuthList());
                    String showAuth = bindAuthBean.getShowFormAuth();
                    if (Strings.isNotBlank(showAuth)) {
                        if ("|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                            showAuth = showAuth.substring(0, showAuth.length() - 1);
                        }
                        List<String> showAuths = new ArrayList<String>();
                        String[] showAuthStrs = showAuth.split("[|]");
                        for (String str : showAuthStrs) {
                            showAuths.add(str);
                        }
                        view.addObject("showAuth", showAuths);
                    }

                    //信息管理列表下方点击查看默认打开第一个视图的
                    view.addObject("firstRightId", showAuth.replaceAll("[|]","_"));
                }
                //----------------------------列头处理
                view.addObject("showFields", DynamicFieldUtil.getTheadStr(showFields, formBean));
                //----------------------------排序字段处理
                view.addObject("sortStr", DynamicFieldUtil.getSortStr(orderByFields));
                //---------------------------查询字段处理
                searchFieldList = (formBean.getFormType() == FormType.baseInfo.getKey() ? DynamicFieldUtil.getSearchField(showFields, formBean) : DynamicFieldUtil.getSearchField(searchFields, formBean));

                //操作权限（包含新建修改权限，加解锁、允许打印等 ）
                List<SimpleObjectBean> authList = bindAuthBean.getAuthList();
                view.addObject("allImp", bindAuthBean.getAuthByName(AuthName.ALLOWIMPORT.getKey()));
                view.addObject("authList", authList);

                Long memberId = AppContext.currentUserId();
                List<Long> orgIds = this.orgManager.getAllUserDomainIDs(memberId);
                
                //查询
                List<FormQueryBean> queryList = formBean.getFormQueryList();
                List<FormQueryBean> queryList2 = new ArrayList<FormQueryBean>();
                if(!queryList.isEmpty()){
                    //提权我的权限
                    List<Long> queryIdsList = formAuthModuleDAO.selectModuleIdByOrgList(FormModuleAuthModuleType.Query, orgIds);
                    if(!queryIdsList.isEmpty()){
                        Set<Long> queryIds = new HashSet<Long>(queryIdsList);
    
                        for (int i = 0; i < queryList.size(); i++) {
                            //if (FormService.checkRight(FormModuleAuthModuleType.Query, queryList.get(i).getId(), AppContext.currentUserId(), formId)) {
                            if(queryIds.contains(queryList.get(i).getId())){
                                queryList2.add(queryList.get(i));
                            }
                        }
                    }
                }
                view.addObject("queryList", queryList2);
                
                //统计
                List<FormReportBean> reportList = formBean.getFormReportList();
                List<FormReportBean> reportList2 = new ArrayList<FormReportBean>();
                if(!reportList.isEmpty()){
                    //提权我的权限
                    List<Long> reportIdsList = formAuthManager.listAuthByReportIdAndUserId(memberId);
                    if(!reportIdsList.isEmpty()){
                        Set<Long> reportIds = new HashSet<Long>(reportIdsList);
                        
                        for (int i = 0; i < reportList.size(); i++) {
                            //if (FormService.checkRight(FormModuleAuthModuleType.Report, reportList.get(i).getReportDefinition().getId(), AppContext.currentUserId(), formId)) {
                            if(reportIds.contains(reportList.get(i).getReportDefinition().getId())){
                                reportList2.add(reportList.get(i));
                            }
                        }
                    }
                }
                view.addObject("reportList", reportList2);
            }
        } else if ("formRelation".equals(type)) {
            FormBindBean bindBean = formBean.getBind();
            List<FormBindAuthBean> bindAuthList = null;
            if (formBean.getFormType() == FormType.baseInfo.getKey()) {//基础数据不考虑权限
                bindAuthList = new ArrayList<FormBindAuthBean>();
                bindAuthList.add(bindBean.getUnFlowTemplateMap().values().iterator().next());
            } else {
                bindAuthList = bindBean.getUnflowFormBindAuthByUserId(AppContext.currentUserId());
            }
            if (bindAuthList.size() > 0) {
                boolean showView = StringUtil.checkNull(ParamUtil.getString(params, "showView"))?true:Boolean.parseBoolean(ParamUtil.getString(params, "showView"));
                Long fromFormId = ParamUtil.getLong(params, "fromFormId");
                Long fromDataId = ParamUtil.getLong(params, "fromDataId");
                Long fromRecordId = ParamUtil.getLong(params, "fromRecordId");
                String fromRelationAttr = ParamUtil.getString(params, "fromRelationAttr");
                String toRelationAttr = ParamUtil.getString(params, "toRelationAttr");
                FormBean fromFormBean = formCacheManager.getForm(fromFormId);
                FormFieldBean fromFieldBean = fromFormBean.getFieldBeanByName(fromRelationAttr);
                FormFieldBean toFieldBean = formBean.getFieldBeanByName(toRelationAttr);
                String fromFieldType = fromFieldBean.isMasterField() ? "m" : "s";
                String toFieldType = toFieldBean.isMasterField() ? "m" : "s";
                view.addObject("relationInitParam", fromFieldType + toFieldType);
                view.addObject("fromFormId", fromFormId);
                view.addObject("fromDataId", fromDataId);
                view.addObject("fromRecordId", fromRecordId);
                view.addObject("fromRelationAttr", fromRelationAttr);
                view.addObject("showView", showView);
                AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.form, fromDataId.toString(), AppContext.currentUserId());
                int i = 0;
                for (FormBindAuthBean template : bindAuthList) {
                    if (i == 0) {
                        i++;
                        List<SimpleObjectBean> showFields = template.getShowFieldList();
                        //列头和排序都以第一个模板的作为参考
                        view.addObject("showFields", DynamicFieldUtil.getTheadStr(showFields, formBean));
                        List<SimpleObjectBean> orderByFields = template.getOrderByList();
                        view.addObject("sortStr", DynamicFieldUtil.getSortStr(orderByFields));
                        //关联表单不能传这个id，不然就只能查这个模版下面的数据
                        //view.addObject("formTemplateId", template.getId());
                        
                        // view.addObject("searchFields", getSearchField(showFields, formBean));
                        if (formBean.getFormType() == FormType.baseInfo.getKey()) {
                            view.addObject("firstRightId", formBean.getFormViewList().get(0)
                                    .getFormAuthViewBeanListByType(FormAuthorizationType.show).get(0).getId());
                            searchFieldList = DynamicFieldUtil.getSearchField(showFields, formBean);
                        } else {
                        	List<SimpleObjectBean> searchFields = template.getSearchFieldList();
                        	searchFieldList = DynamicFieldUtil.getSearchField(searchFields, formBean);
                            String showAuth = template.getShowFormAuth();
                            if (Strings.isNotBlank(showAuth)) {
                                if ("|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                                    showAuth = showAuth.substring(0, showAuth.length() - 1);
                                }
                            }
                            List<String> showAuths = new ArrayList<String>();
                            String[] showAuthStrs = showAuth.split("[|]");
                            for (String str : showAuthStrs) {
                                showAuths.add(str);
                            }
                            view.addObject("showAuth", showAuths);
                            view.addObject("firstRightId", showAuth.replaceAll("[|]","_"));
                        }
                    }
                }
                view.addObject("templateName", ParamUtil.getString(params, "templateName"));
            } else {
                //您无权限操作或者表单还没有建应用绑定，请联系表单管理员
                throw new BusinessException(ResourceUtil.getString("form.show.relationFormData.norightornobind"));
            }
        }

        view.addObject("searchFields", searchFieldList);
        List<DataContainer> commonSearchFields = new ArrayList<DataContainer>();
        if (searchFieldList.size() > 0) {
            ComponentManager componentManager = (ComponentManager) AppContext.getBean("componentManager");
            DataContainer o;
            for (FormFieldBean fb : searchFieldList) {
                fb = fb.findRealFieldBean(false);
                o = new DataContainer();
                commonSearchFields.add(o);
                o.put("id", fb.getName());
                o.put("name", fb.getName());
                o.put("value", fb.getName());
                o.put("text", fb.getDisplay());
                o.put("type", "datemulti");
                o.put("fieldType", fb.getFinalInputType());
                if(fb.getInputTypeEnum() == FormFieldComEnum.OUTWRITE 
                        && (fb.getFieldType().equals(FieldType.DATETIME.getKey()) || fb.getFieldType().equals(FieldType.TIMESTAMP.getKey()))){
                    if(fb.getFieldType().equals(FieldType.TIMESTAMP.getKey())){
                        o.put("dateTime", false);
                        o.put("ifFormat", "%Y-%m-%d");
                    }else{
                        o.put("dateTime", true);
                        o.put("minuteStep", 1);
                    }
                } else if (fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATETIME) {
                    if (fb.getName().equalsIgnoreCase(MasterTableField.start_date.getKey()) || fb.getName().equalsIgnoreCase(MasterTableField.modify_date.getKey())) {
                        o.put("dateTime", false);
                        o.put("ifFormat", "%Y-%m-%d");
                    } else {
                        o.put("dateTime", true);
                        o.put("minuteStep", 1);
                    }
                } else if (fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATE) {
                    o.put("dateTime", false);
                    o.put("ifFormat", "%Y-%m-%d");
                } else if (fb.getInputTypeEnum() == FormFieldComEnum.RADIO) {
                    o.put("type", "customPanel");
                    o.put("readonly", "readonly");
                    o.put("panelWidth", 270);
                    o.put("panelHeight", 200);
                    List<String[]> htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), null, null);
                    String op = htmls.get(0)[0].replace("<select", "<select style='display:none;' ");
                    String inputHtml = "<div class=\"padding_5\" style=\"line-height:20px;\">"+htmls.get(0)[1]+"</div>";
                    o.put("customHtml", op + inputHtml);
                } else {
                    o.put("type", "custom");
                    List<String[]> htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), null, null);
                    String op = htmls.get(0)[0].replace("<select", "<select style='display:none;' ");
                    String html = htmls.get(0)[1];
                    if (fb.getInputTypeEnum().isMultiOrg() || fb.getOutwriteFieldInputType().isMultiOrg()) {
                        html = htmls.get(0)[1].replace("<textarea", "<input type='text'").replace("textarea", "input");
                    }
                    o.put("customHtml", op + html);
                }
            }
        }
        DataContainer dc = new DataContainer();
        dc.add("commonSearchFields", commonSearchFields);
        view.addObject("commonSearchFields", dc.getJson());
        
        List<FormFieldBean> allfieldList = formBean.getAllFieldBeans();
        List<String> urlFieldList = FormUtil.findUrlFieldList(allfieldList);

        Map<String, Object> formP = new HashMap<String, Object>();
        formP.put("id", formBean.getId());
        formP.put("tableList", formBean.getAllTableName());

        view.addObject("urlFieldList", JSONUtil.toJSONString(urlFieldList));
        int _moduType =  formBean.getFormType() == FormType.baseInfo.getKey() ? ModuleType.unflowBasic.getKey()
                : ModuleType.unflowInfo.getKey();
        if(formBean.getFormType() == FormType.dynamicForm.getKey()){
        	_moduType = ModuleType.dynamicForm.getKey();
        }
        view.addObject("moduleType",_moduType);
        
        view.addObject("formId", formBean.getId());
        view.addObject("toFormBean", JSONUtil.toJSONString(formP));
        view.addObject("type", type);
        view.addObject("formType", formBean.getFormType());
        view.addObject("currentUserId", AppContext.currentUserId());
        return view;
    }

    
    public ModelAndView showUnflowIndex(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException{
    	response.setContentType(CONTENT_TYPE);
    	ModelAndView view = new ModelAndView("ctp/form/common/showUnflowIndex");
    	Map params = request.getParameterMap();
        Long formId =  ParamUtil.getLong(params, "formId");
        String modelType = ParamUtil.getString(params, "model");
        String isFromSectionMore = ParamUtil.getString(params, "unflowFormSectionMore");
        if ("true".equals(isFromSectionMore)) {
            view.addObject("isFormSection", isFromSectionMore);
        }


        if("column".equals(modelType)){
            view.addObject("modelType", "column");
        }else if("menu".equals(modelType)){
            view.addObject("modelType", "menu");
        }else{
            view.addObject("modelType", "info");
        }
        view.addObject("formId", formId);
        FormBean formBean = formCacheManager.getForm(formId);
        if (formBean == null || !formManager.isEnabled(formBean)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');parent.window.close();");
        }
        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        view.addObject("formTemplateId", formTemplateId);
        String templateName = ParamUtil.getString(params, "templateName");
        view.addObject("templateName", templateName);
        String type = request.getParameter("type") == null ? "baseInfo" : request.getParameter("type");
        view.addObject("type", type);
        //基础数据和信息管理
        if ("baseInfo".equals(type)) {
           
            FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
            if (bindAuthBean != null) {
                if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                    throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
                }
                view.addObject("templateName", bindAuthBean.getName());
                FormSearchFieldBaseBo fieldBo = formDataManager.getUnfolwFormSearchFirstTreeField(formId, formTemplateId);
            	view.addObject("searchField", fieldBo);
            }
        }
        String srcFrom = ParamUtil.getString(params, "srcFrom");
        view.addObject("srcFrom", srcFrom);
        boolean isGroupVer=false;
        if("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))){
        	isGroupVer = true;
        }
        view.addObject("isGroupVer",isGroupVer);
        User user = AppContext.getCurrentUser();
        Long accountId = user.getLoginAccount();
        String accountShortName = user.getLoginAccountShortName();
        if (!user.isV5Member()) {
            accountId = OrgHelper.getVJoinAllowAccount();
            V3xOrgAccount account = orgManager.getAccountById(accountId);
            if (account != null) {
                accountShortName = account.getShortName();
            }
        }
        view.addObject("loginAccount", accountId);
        view.addObject("loginAccountName", accountShortName);
        return view;
    }
    /**
     * 
     * 信息管理表单数据展现
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * @throws IOException
     */
    public ModelAndView showUnflowFormDataList(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        ModelAndView view = new ModelAndView("ctp/form/common/showUnflowFormDataList");
        response.setContentType(CONTENT_TYPE);
        Map params = request.getParameterMap();
        String isFromSectionMore = ParamUtil.getString(params, "unflowFormSectionMore");
        if ("true".equals(isFromSectionMore)) {
            view.addObject("isFormSection", isFromSectionMore);
        }
        //被单元格所关联的表单的表单id
        Long formId = ParamUtil.getLong(params, "formId");
        String model = ParamUtil.getString(params, "model");
        if("column".equals(model)){
            view.addObject("modelType", "column");
        }else if("menu".equals(model)){
            view.addObject("modelType", "menu");
        }else{
            view.addObject("modelType", "info");
        }
        FormBean formBean = formCacheManager.getForm(formId);
        if (formBean == null || !formManager.isEnabled(formBean)) {
            super.rendJavaScript(response, "alert('" + ResourceUtil.getString("bizconfig.use.authorize.forbidden") + "');parent.window.history.back();");
        }
        view.addObject("viewStyle","1");
        if (formBean.isPhoneForm()) {
            view.addObject("viewStyle","4");
        }
        String type = request.getParameter("type") == null ? "baseInfo" : request.getParameter("type");
		//客开马文丽 接受过滤催办参数 start
		String filterCuiban = request.getParameter("filterCuiban") == null ? "0" : "1";
		view.addObject("filterCuiban",filterCuiban);
		//客开马文丽 接受过滤催办参数 end
        List<FormFieldBean> searchFieldList = new ArrayList<FormFieldBean>();
        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        //基础数据和信息管理
        if ("baseInfo".equals(type)) {
            view.addObject("formTemplateId", formTemplateId);
            FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
            if (bindAuthBean != null) {
                if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                    throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
                }
                view.addObject("templateName", bindAuthBean.getName());
                List<SimpleObjectBean> searchFields = bindAuthBean.getSearchFieldList();
                List<SimpleObjectBean> showFields = bindAuthBean.getShowFieldList();
                List<SimpleObjectBean> orderByFields = bindAuthBean.getOrderByList();
                //基础信息默认第一个新增权限，信息管理需要管理员设定权限
                if (formBean.getFormType() == FormType.manageInfo.getKey()) {
                    //新建按钮权限
                    String newauth = bindAuthBean.getNewFormAuth();
                    view.addObject("newFormAuth", bindAuthBean.getNewFormAuth());
                    String newBtnTitile = bindAuthBean.getAuthObjByName(AuthName.ADD.getKey()).getDisplay();
                    if (Strings.isBlank(newBtnTitile)) {
                        newBtnTitile = ResourceUtil.getString("form.formlist.newform");//新增
                    }
                    view.addObject("newFormAuthTitle", Strings.escapeJavascript(newBtnTitile));
                    //修改权限
                    List<SimpleObjectBean> editAuth = bindAuthBean.getUpdateAuthList();
                    List<SimpleObjectBean> cloneEditAuth = new ArrayList<SimpleObjectBean>();
                    for (SimpleObjectBean s : editAuth) {
                        //修改设置对应权限没有配置时，不显示修改按钮，兼容历史数据
                        if (Strings.isBlank(s.getValue())){
                            continue;
                        }
                        SimpleObjectBean c = null;
                        try {
                            c = (SimpleObjectBean) s.clone();
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                        if (StringUtil.checkNull(c.getDisplay())) {
                            c.setDisplay(ResourceUtil.getString("application.92.label"));
                        } else {
                            c.setDisplay(Strings.escapeJavascript(c.getDisplay()));
                        }
                        cloneEditAuth.add(c);
                    }
                    editAuth = cloneEditAuth;
                    view.addObject("editAuth", editAuth);
                    view.addObject("editAuthJson", JSONUtil.toJSONString(editAuth));
                    view.addObject("editAuthTitle", ResourceUtil.getString("application.92.label"));
                    //如果有设置的有高级权限,则修改时提示客户选择哪个权限进行编辑
                    view.addObject("chooseAuth", "false");
                    if (newauth != null && newauth.split("[.]").length > 1 && editAuth.size() > 0) {
                        FormAuthViewBean newAuth = formBean.getAuthViewBeanById(Long.parseLong(newauth.split("[.]")[1]));
                        for (SimpleObjectBean s : editAuth) {
                            if (Strings.isNotBlank(s.getValue())) {
                                FormAuthViewBean e = formBean.getAuthViewBeanById(Long.parseLong(s.getValue().split("[.]")[1]));
                                if (newAuth.getConditionFormAuthViewBeanList().size() > 0 || e.getConditionFormAuthViewBeanList().size() > 0) {
                                    view.addObject("chooseAuth", "true");
                                    break;
                                }
                            }
                        }
                    }
                    view.addObject("customSet", bindAuthBean.getCustomAuthList());
                    String showAuth = bindAuthBean.getShowFormAuth();
                    if (Strings.isNotBlank(showAuth)) {
                        if ("|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                            showAuth = showAuth.substring(0, showAuth.length() - 1);
                        }
                        List<String> showAuths = new ArrayList<String>();
                        String[] showAuthStrs = showAuth.split("[|]");
                        for (String str : showAuthStrs) {
                            showAuths.add(str);
                        }
                        view.addObject("showAuth", showAuths);
                    }

                    //信息管理列表下方点击查看默认打开第一个视图的
                    view.addObject("firstRightId", showAuth.replaceAll("[|]","_"));
                }
                //----------------------------列头处理
                view.addObject("showFields", DynamicFieldUtil.getTheadStr(showFields, formBean));
                //----------------------------排序字段处理
                view.addObject("sortStr", DynamicFieldUtil.getSortStr(orderByFields));
                //---------------------------查询字段处理
                searchFieldList = (formBean.getFormType() == FormType.baseInfo.getKey() ? DynamicFieldUtil.getSearchField(showFields, formBean) : DynamicFieldUtil.getSearchField(searchFields, formBean));

                //操作权限（包含新建修改权限，加解锁、允许打印等 ）
                List<SimpleObjectBean> authList = bindAuthBean.getAuthList();
                view.addObject("allImp", bindAuthBean.getAuthByName(AuthName.ALLOWIMPORT.getKey()));
                view.addObject("authList", authList);

                Long memberId = AppContext.currentUserId();
                List<Long> orgIds = this.orgManager.getAllUserDomainIDs(memberId);
                
                //查询
                List<FormQueryBean> queryList = formBean.getFormQueryList();
                List<FormQueryBean> queryList2 = new ArrayList<FormQueryBean>();
                if(!queryList.isEmpty()){
                    //提权我的权限
                    List<Long> queryIdsList = formAuthModuleDAO.selectModuleIdByOrgList(FormModuleAuthModuleType.Query, orgIds);
                    if(!queryIdsList.isEmpty()){
                        Set<Long> queryIds = new HashSet<Long>(queryIdsList);
    
                        for (int i = 0; i < queryList.size(); i++) {
                            //if (FormService.checkRight(FormModuleAuthModuleType.Query, queryList.get(i).getId(), AppContext.currentUserId(), formId)) {
                            if(queryIds.contains(queryList.get(i).getId())){
                                queryList2.add(queryList.get(i));
                            }
                        }
                    }
                }
                view.addObject("queryList", queryList2);
                
                //统计
                List<FormReportBean> reportList = formBean.getFormReportList();
                List<FormReportBean> reportList2 = new ArrayList<FormReportBean>();
                if(!reportList.isEmpty()){
                    //提权我的权限
                    List<Long> reportIdsList = formAuthManager.listAuthByReportIdAndUserId(memberId);
                    if(!reportIdsList.isEmpty()){
                        Set<Long> reportIds = new HashSet<Long>(reportIdsList);
                        
                        for (int i = 0; i < reportList.size(); i++) {
                            //if (FormService.checkRight(FormModuleAuthModuleType.Report, reportList.get(i).getReportDefinition().getId(), AppContext.currentUserId(), formId)) {
                            if(reportIds.contains(reportList.get(i).getReportDefinition().getId())){
                                reportList2.add(reportList.get(i));
                            }
                        }
                    }
                }
                view.addObject("reportList", reportList2);
            }
        }
        view.addObject("searchFields", searchFieldList);
        List<DataContainer> commonSearchFields = new ArrayList<DataContainer>();
        if (searchFieldList.size() > 0) {
            ComponentManager componentManager = (ComponentManager) AppContext.getBean("componentManager");
            DataContainer o;
            for (FormFieldBean fb : searchFieldList) {
                fb = fb.findRealFieldBean();
                o = new DataContainer();
                o.put("id", fb.getName());
                o.put("name", fb.getName());
                o.put("value", fb.getName());
                o.put("text", fb.getDisplay());
                o.put("type", "datemulti");
                o.put("fieldType", fb.getFinalInputType());
                if(fb.getInputTypeEnum() == FormFieldComEnum.OUTWRITE 
                        && (fb.getFieldType().equals(FieldType.DATETIME.getKey()) || fb.getFieldType().equals(FieldType.TIMESTAMP.getKey()))){
                    if(fb.getFieldType().equals(FieldType.TIMESTAMP.getKey())){
                        o.put("dateTime", false);
                        o.put("ifFormat", "%Y-%m-%d");
                    }else{
                        o.put("dateTime", true);
                        o.put("minuteStep", 1);
                    }
                } else if (fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATETIME) {
                    if (fb.getName().equalsIgnoreCase(MasterTableField.start_date.getKey()) || fb.getName().equalsIgnoreCase(MasterTableField.modify_date.getKey())) {
                        o.put("dateTime", false);
                        o.put("ifFormat", "%Y-%m-%d");
                    } else {
                        o.put("dateTime", true);
                        o.put("minuteStep", 1);
                    }
                } else if (fb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATE) {
                    o.put("dateTime", false);
                    o.put("ifFormat", "%Y-%m-%d");
                } else if (fb.getInputTypeEnum() == FormFieldComEnum.RADIO) {
                    o.put("type", "customPanel");
                    o.put("readonly", "readonly");
                    o.put("panelWidth", 270);
                    o.put("panelHeight", 200);
                    List<String[]> htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), null, null);
                    String op = htmls.get(0)[0].replace("<select", "<select style='display:none;' ");
                    o.put("customHtml", op + htmls.get(0)[1]);
                } else {
                    o.put("type", "custom");
                    List<String[]> htmls = componentManager.getFormConditionHTML(formId, Arrays.asList(new String[]{fb.getName()}), null, null);
                    String op = htmls.get(0)[0].replace("<select", "<select style='display:none;' ");
                    String html = htmls.get(0)[1];
                    if (fb.getInputTypeEnum().isMultiOrg() || fb.getOutwriteFieldInputType().isMultiOrg()) {
                        html = htmls.get(0)[1].replace("<textarea", "<input type='text'").replace("textarea", "input");
                    }
                    o.put("customHtml", op + html);
                }
                commonSearchFields.add(o);
            }
        }
        DataContainer dc = new DataContainer();
        dc.add("commonSearchFields", commonSearchFields);
        view.addObject("commonSearchFields", dc.getJson());
        
        List<FormFieldBean> allfieldList = formBean.getAllFieldBeans();
        List<String> urlFieldList = FormUtil.findUrlFieldList(allfieldList);

        Map<String, Object> formP = new HashMap<String, Object>();
        formP.put("id", formBean.getId());
        formP.put("tableList", formBean.getAllTableName());

        view.addObject("urlFieldList", JSONUtil.toJSONString(urlFieldList));
        view.addObject("moduleType",
                formBean.getFormType() == FormType.baseInfo.getKey() ? ModuleType.unflowBasic.getKey()
                        : ModuleType.unflowInfo.getKey());
        view.addObject("formId", formBean.getId());
        view.addObject("toFormBean", JSONUtil.toJSONString(formP));
        view.addObject("type", type);
        view.addObject("formType", formBean.getFormType());
        view.addObject("currentUserId", AppContext.currentUserId());
//        Map<String,String> firstHtml = formDataManager.convertUnflowFormQuery2Html4First(formId, formTemplateId);
//        view.addObject("firstHtml", firstHtml);
//        Map<String,String> otherHtml = formDataManager.convertUnflowFormQuery2Html4Others(formId, formTemplateId);
//        view.addObject("otherHtml", otherHtml);
        List<FormSearchFieldVO> formSearchFields = formDataManager.findUnfolwFormSearchFieldVOs(formId, formTemplateId);
        view.addObject("formSearchFields", JSONUtil.toJSONString(formSearchFields));
        view.addObject("hasBarcode",AppContext.hasPlugin("barCode"));
        return view;
    }

    public ModelAndView showEnumsChoose(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
    	ModelAndView mav = new ModelAndView("ctp/form/common/showEnumsChoose");
    	long formId = ReqUtil.getLong(request, "formId", 0L);
    	String fieldName = ReqUtil.getString(request, "fieldName");
    	FormBean formBean = formCacheManager.getForm(formId);
    	FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
    	List<CtpEnumItem> enumList = formDataManager.findEnumListByField(fieldBean);
    	
    	mav.addObject("enumList",enumList);
        return mav;
    }


    /**
     * 表单待触发列表
     * @param request
     * @param response
     * @return
     * @throws IOException
     */
    public ModelAndView showTriggerEventList(HttpServletRequest request, HttpServletResponse response) throws IOException{
        ModelAndView mav = new ModelAndView("ctp/form/common/formTriggerEventList");
        //只有system账号才能访问
        if(!AppContext.isSystemAdmin()){
            super.rendJavaScript(response, "alert('"+ResourceUtil.getString("bizconfig.use.authorize.forbidden")+"');window.close()");
        }
        return mav;
    }
    
    /**
     * 关联有流程表单
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView colFormRelationList(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView view = new ModelAndView("ctp/form/common/colFormRelationList");
        Map params = request.getParameterMap();
        Long toFromId = ParamUtil.getLong(params, "formId");
        Long fromFormId = ParamUtil.getLong(params, "fromFormId");
        String fromRelationAttr = ParamUtil.getString(params, "fromRelationAttr");
        String toRelationAttr = ParamUtil.getString(params, "toRelationAttr");
        boolean showView = StringUtil.checkNull(ParamUtil.getString(params, "showView"))?true:Boolean.parseBoolean(ParamUtil.getString(params, "showView"));
        FormBean fromFormBean = formCacheManager.getForm(fromFormId);
        FormBean toFormBean = formCacheManager.getForm(toFromId);
        view.addObject("showView", showView);
        FormFieldBean fromFieldBean = fromFormBean.getFieldBeanByName(fromRelationAttr);
        FormFieldBean toFieldBean = toFormBean.getFieldBeanByName(toRelationAttr);
        String fromFieldType = fromFieldBean.isMasterField() ? "m" : "s";
        String toFieldType = (toFieldBean == null || toFieldBean.isMasterField()) ? "m" : "s";
        view.addObject("relationInitParam", fromFieldType + toFieldType);
        Map<String, Object> formP = new HashMap<String, Object>();
        formP.put("id", toFormBean.getId());
        formP.put("tableList", toFormBean.getAllTableName());
        view.addObject("formId", toFormBean.getId());
        view.addObject("toFormBean", JSONUtil.toJSONString(formP));

        return view;
    }

    /**
     * 新建无流程数据
     *
     * @param request
     * @param response
     * @return
     */
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
        String _from = ParamUtil.getString(params,"_from");//扫一扫打开的单据没有保存并修改下一条

        //校验权限
        if(!FormService.checkRight(FormModuleAuthModuleType.BindAppForm,formTemplateId,AppContext.currentUserId(),formId)){
            super.rendJavaScript(response, "alert('"+ResourceUtil.getString("bizconfig.use.authorize.forbidden")+"');window.close()");
        }
        //点进修改进入后，进行加锁
        if (!Boolean.parseBoolean(isNew)) {
            boolean hasEditFlag = formManager.checkUnFlowFormFieldCanEdit(formId, rightId);
            if (formManager.getLock(contentAllId) == null && hasEditFlag) {
                formManager.lockFormData(contentAllId);
            }
            boolean displayNextAndPre = true;
            if("scanner".equals(_from)){
                displayNextAndPre = false;
            }
            view.addObject("displayNextAndPre", displayNextAndPre);
        }
        FormBean fb = formManager.getForm(formId);
        FormBindAuthBean formBind = fb.getBind().getUnFlowTemplateById(formTemplateId);
        view.addObject("contentAllId", contentAllId);
        view.addObject("rightId", rightId);
        view.addObject("viewId", viewId);
        view.addObject("formId", formId);
        view.addObject("formTemplateId", formTemplateId);
        view.addObject("moduleType", moduleType);
        view.addObject("isNew", isNew);
        view.addObject("scanCodeInput",Strings.isBlank(formBind.getScanCodeInput())?"":formBind.getScanCodeInput());
        view.addObject("fromSrc", ParamUtil.getString(params, "fromSrc"));
        return view;
    }

    /**
     * 双击查看无流程数据，扫一扫打开数据查看，无流程全文检索点击穿透
     * @param request
     * @param response
     * @return
     */
    public ModelAndView viewUnflowFormData(HttpServletRequest request, HttpServletResponse response) throws Exception{
        ModelAndView view = new ModelAndView("ctp/form/common/viewUnflowFormData");
        Map params = request.getParameterMap();
        Long moduleId = ParamUtil.getLong(params, "moduleId");
        if(moduleId == -1L){
            super.rendJavaScript(response, "alert('"+ResourceUtil.getString("form.exception.datanotexit")+"');window.close()");
            return null;
        }
        String rightId = ParamUtil.getString(params, "rightId");
        String moduleType = ParamUtil.getString(params, "moduleType");
        Long formTemplateId = ParamUtil.getLong(params,"formTemplateId");
        Long formId = ParamUtil.getLong(params,"formId");
        String from = ParamUtil.getString(params,"_from");//扫一扫打开的单据没有上一条下一条
        boolean allowPrint = false;
        boolean displayNextAndPre = true;
        if("scanner".equals(from)){
            displayNextAndPre = false;
        }
        //boolean canOpen = true;
        if(formId == null){
            displayNextAndPre = false;
            if(Strings.isNotBlank(rightId) && !"0".equals(rightId)){
                if(moduleId == 0L || moduleId == -1L){
                    super.rendJavaScript(response, "alert('"+ResourceUtil.getString("form.exception.datanotexit")+"');window.close()");
                }
                //canOpen = false;
               // formmainbodyhandler 里面有统一的权限校验，这里注释掉
//                MainbodyManager contentManager  = (MainbodyManager) AppContext.getBean("ctpMainbodyManager");
//                ModuleType type = ModuleType.getEnumByKey(Integer.valueOf(moduleType));
//                List<CtpContentAll> contentAllList = contentManager.getContentListByModuleIdAndModuleType(type,moduleId);
//                if(contentAllList != null && !contentAllList.isEmpty()){
//                    CtpContentAll contentAll = contentAllList.get(0);
//                    formId = contentAll.getContentTemplateId();
//                    FormBean formBean = formCacheManager.getForm(formId);
//                    if(formBean != null){
//                        FormDataMasterBean masterBean = formManager.getDataMasterBeanById(moduleId, formBean, null);
//                        List<FormBindAuthBean> list = formBean.getBind().getUnflowFormBindAuthByUserId(AppContext.currentUserId());
//                        for(FormBindAuthBean authBean:list){
//                            FormFormulaBean formulaBean = authBean.getFormFormulaBean();
//                            if(formulaBean != null){
//                                Map<String,Object> formDataMap = masterBean.getFormulaMap(FormulaEnums.componentType_condition);
//                                String formulaVar =formulaBean.getExecuteFormulaForGroove();
//                                boolean flag = FormulaUtil.isMatch(formulaVar,formDataMap);
//                                if(flag){
//                                    canOpen = true;
//                                    break;
//                                }
//                            }else{//如果有某一个应用绑定没有操作范围
//                                canOpen = true;
//                                break;
//                            }
//                        }
//                    }
//
//                }
            }
        }else{
            FormBean  formBean = formManager.getForm(formId);
            //无流程都允许打印，和权限没有关系
            if(formBean.getFormType() == FormType.baseInfo.getKey()){
                allowPrint = true;
            }else if(formBean.getFormType() == FormType.manageInfo.getKey()){
                FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
                List<SimpleObjectBean> authList = bindAuthBean.getAuthList();
                for(SimpleObjectBean one :authList){
                    if("allowprint".equals(one.getName()) && "true".equals(one.getValue())){
                        allowPrint = true;
                        break;
                    }
                }
            }
        }
        view.addObject("formId",formId);
        //view.addObject("canOpen",canOpen);
        view.addObject("displayNextAndPre",displayNextAndPre);
        view.addObject("allowprint",allowPrint);//需要后端配置了打印按钮的，查看页面才能有打印按钮
        view.addObject("moduleId",moduleId);
        view.addObject("rightId",rightId);
        view.addObject("moduleType",moduleType);
        return  view;
    }

    public ModelAndView batchUpdateData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("ctp/form/common/batchUpdateData");
        Map params = request.getParameterMap();
        Long formId = ParamUtil.getLong(params, "formId");
        Long formTemplateId = ParamUtil.getLong(params, "formTemplateId");
        if(!FormService.checkRight(FormModuleAuthModuleType.BindAppForm,formTemplateId,AppContext.currentUserId(),formId)){
            super.rendJavaScript(response, "alert('"+ResourceUtil.getString("bizconfig.use.authorize.forbidden")+"');window.close()");
        }
        List<Map<String,String>> resutl = formDataManager.getBatchUpdateHTML(formId,formTemplateId);
        view.addObject("result",resutl);
        view.addObject("haveField", Strings.isNotEmpty(resutl));
        return view;
    }

    /**
     * 基础数据和信息管理页面
     *
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView unflowForm(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        response.setContentType(CONTENT_TYPE);
        ModelAndView view = new ModelAndView("ctp/form/common/unflowForm");
        Map params = request.getParameterMap();
        int formType = ParamUtil.getInt(params, "formType");

        List<FormBean> formList = formCacheManager.getFormsByType(formType);
        List<Map<String, Object>> wapperMapList = new ArrayList<Map<String, Object>>();
        for (FormBean fbean : formList) {
            if (!this.formCacheManager.isEnabled(fbean.getId())) {
                continue;
            }
            FormBindBean bindBean = fbean.getBind();
            Map<String, FormBindAuthBean> templates = bindBean.getUnFlowTemplateMap();
            for (Map.Entry<String, FormBindAuthBean> entry : templates.entrySet()) {
                FormBindAuthBean template = entry.getValue();
                if (template.checkRight(AppContext.currentUserId())) {
                    Map<String, Object> wapperMap = new HashMap<String, Object>();
                    wapperMap.put("id", template.getId());
                    wapperMap.put("pId", fbean.getCategoryId());
                    wapperMap.put("name", template.getName());
                    wapperMap.put("formId", fbean.getId());
                    wapperMapList.add(wapperMap);
                }
            }
        }
        view.addObject("size", wapperMapList.size());
        view.addObject("formType", formType);
        return view;
    }

    /**
     * 无流程表单栏目更多
     *
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * @throws IOException
     */
    public ModelAndView unflowFormSectionMore(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        request.setAttribute("unflowFormSectionMore", "true");
        return getFormMasterDataList(request, response);
    }
    /**
    * 导出重复表数据(重复表汇总用)
    * 1.汇总重复表导出隐藏权限字段：是否只参考原始权限，还是要参考高级权限计算后的隐藏权限。
    * 2.在视图中删除的字段，不导出
    * @param request
    * @param response
    * @return
    * @throws BusinessException
    */
    public ModelAndView exportRepeatTableData(HttpServletRequest request, HttpServletResponse response) throws Exception{
        Long formId = ReqUtil.getLong(request, "formId");
        Long formTemplateId = ReqUtil.getLong(request, "formTemplateId");
        Long moduleId = ReqUtil.getLong(request,"moduleId");
        Long rightId = ReqUtil.getLong(request, "rightId");
        String tableName = ReqUtil.getString(request,"tableName");
        Long formMasterId = ReqUtil.getLong(request,"formMasterId");
        FormBean formBean = formCacheManager.getForm(formId);
        FormDataMasterBean frontMasterBean = null;
        FormDataMasterBean cacheMasterData = null;
        FormAuthViewBean authViewBean = null;
        try {
            //1、接受前台提交的表单提交参数
            frontMasterBean = formManager.procFormParam(formBean, formMasterId, rightId);
            cacheMasterData = formManager.getSessioMasterDataBean(frontMasterBean.getId());
            //2、将前台提交的表单参数和后台缓存合并
            formManager.mergeFormData(frontMasterBean, cacheMasterData, formBean);
        }catch (BusinessException ex){
            LOGGER.error(ex.getMessage(), ex);
        }
        //首先考虑从缓存的FormDataMasterBean中获取权限，因为FormDataMasterBean存放的权限是合并之后的权限
        if (cacheMasterData.getExtraMap().containsKey(FormConstant.viewRight)) {
            authViewBean = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
        }
        if (authViewBean == null) {
            authViewBean = formBean.getAuthViewBeanById(rightId);
        }
        FormTableBean formTableBean = formBean.getTableByTableName(tableName);
        List<FormFieldBean> allField = formTableBean.getFields();//当前重复表所有字段

        //视图中已删除的字段不导出
        Set<String> viewFieldSet = new HashSet<String>(formBean.getAllFieldBeans().size());
        long viewId = authViewBean.getFormViewId();
        FormViewBean formViewBean = formBean.getFormView(viewId);
        viewFieldSet.addAll(formViewBean.getFieldList());

        //过滤掉不能导出的字段
        List<String> comEnums = new ArrayList<String>();
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

        //组装需要导出的列头
        List<FormFieldBean> toExportField = new ArrayList<FormFieldBean>();
        for(FormFieldBean tempField: allField){
            tempField = tempField.findRealFieldBean();
            if(!viewFieldSet.contains(tempField.getName())){
                continue;
            }
            if(comEnums.contains(tempField.getRealInputType())){
                continue;
            }
            toExportField.add(tempField);
        }

        //文件名用表单名称_重复表
        String title = formBean.getFormName();
        String fileName = formBean.getFormName()+"_"+formTableBean.getDisplay();

        List<FormDataSubBean> subDataBeanList = cacheMasterData.getSubData(tableName);
        List<List<String>> slaveDataList = new ArrayList<List<String>>();
        List<String> oneRow = null;
        for(FormDataSubBean subData:subDataBeanList){
            oneRow = new ArrayList<String>();
            //遍历要导出的所有字段
            for(FormFieldBean tempField: toExportField){
                tempField = tempField.findRealFieldBean();
                Object  value = subData.getFieldValue(tempField.getName());
                Object data = "";
                //隐藏权限的导出*
                FormAuthViewFieldBean formAuthViewFieldBean = authViewBean.getFormAuthorizationField(tempField.getName());
                if(FieldAccessType.hide.getKey().equals(formAuthViewFieldBean.getAccess())){
                    data = "*";
                }else{
                    if(value == null){
                        data = "";
                    }else{
                        Object[] objs = tempField.getDisplayValue(value,false,true,true);
                        data = objs[1];
                    }
                }
                oneRow.add(String.valueOf(data));
            }
            slaveDataList.add(oneRow);
        }

        fileToExcelManager.save(response, Strings.isBlank(fileName)?formBean.getFormName():fileName,
                QueryUtil.exportOneSheetForExcel(formBean,title,toExportField, new HashMap<String, String>(), slaveDataList,false,null));
        return null;
    }

    /**
     * 导出excel
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView exporttoExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        StringBuffer logs = new StringBuffer();
        Long formId = ReqUtil.getLong(request, "formId");
        Long formTemplateId = ReqUtil.getLong(request, "formTemplateId");
        Long rightId = ReqUtil.getLong(request, "rightId");
        String queryConditionStr = request.getParameter("queryConditionStr");
        String exportType = request.getParameter("exportType");
        Map<String,Object> conditions = JSONUtil.parseJSONString(queryConditionStr, Map.class);
        if(!"base".equals(exportType)){
            for(Map.Entry<String,Object> tempMap:conditions.entrySet()){
                Object o = tempMap.getValue();
                if(o instanceof Map){
                    Map<String,Object> valueMap = (Map<String,Object>)o;
                    if(valueMap != null){
                        Object fieldValue = valueMap.get("fieldValue");
                        valueMap.put("fieldValue",URLDecoder.decode((String) fieldValue, "UTF-8"));
                    }
                }else{
                    com.alibaba.fastjson.JSONArray arr = (com.alibaba.fastjson.JSONArray)o;
                    for(Object tempObj:arr){
                        Map<String,Object> valueMap = (Map<String,Object>)tempObj;
                        if(valueMap != null){
                            Object fieldValue = valueMap.get("fieldValue");
                            valueMap.put("fieldValue",URLDecoder.decode((String) fieldValue, "UTF-8"));
                        }
                    }
                }
            }
        }

        FormBean formBean = formCacheManager.getForm(formId);
        FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
        long currentUserId = AppContext.currentUserId();
        //显示字段
        List<List<FormFieldBean>> fields = new ArrayList<List<FormFieldBean>>();
        if (bindAuthBean != null) {
            formDataManager.addDownlaodRecord(formBean.getId(), bindAuthBean.getId(), currentUserId);
            //主表显示字段
            List<FormFieldBean> masterList = new ArrayList<FormFieldBean>();
            List<SimpleObjectBean> showFields = bindAuthBean.getShowFieldList();
            for (SimpleObjectBean sob : showFields) {
                FormFieldBean ffb = null;
                if (sob.getName().indexOf(".") > -1) {
                    String[] strs = sob.getName().split("[.]");
                    ffb = formBean.getFieldBeanByName(strs[1]);
                } else {
                    MasterTableField mtf = MasterTableField.getEnumByKey(sob.getName());
                    if (mtf != null) {
                        ffb = mtf.getFormFieldBean();
                    }
                }
                masterList.add(ffb);
            }
            fields.add(masterList);
            List<List<FormFieldBean>> expotFieldLists = this.formDataManager.getFormFieldDisplayForImportAndExport(formBean, bindAuthBean,AuthName.BROWSE);
            if (expotFieldLists.size() > 1) {
                for (List<FormFieldBean> expotFieldList : expotFieldLists) {
                    if (expotFieldList != null && !expotFieldList.isEmpty()
                            && !expotFieldList.get(0).getOwnerTableName().contains(TableType.MASTER.getTableSufName())) {
                        fields.add(expotFieldList);
                    }
                }
            }
        }

        Map<String, Object> params = new HashMap<String, Object>();
        List<Long> ids = new ArrayList<Long>();
        params.put("formId", formId);
        params.put("formTemplateId", formTemplateId);
        String page = request.getParameter("page");
        String size = request.getParameter("size");
        FlipInfo flipInfo = new FlipInfo(Integer.parseInt(page), Integer.parseInt(size));
        if (conditions != null) {
            params.putAll(conditions);
        }
        List<Map<String, Object>> formDataMasterList = new ArrayList<Map<String, Object>>();
        if("base".equals(exportType)){
            //getFormMasterDataList
            formDataMasterList = formDataManager.getFormMasterDataList(flipInfo, params,true).getData();
        }else{
            //得到主表数据
            formDataMasterList = formManager.getFormMasterDataListByFormId(flipInfo, params, true).getData();
        }

        logs.append(ResourceUtil.getString("form.condition.guideout.label") + formDataMasterList.size() + ResourceUtil.getString("form.query.querySet.dataQuery.nodelabel") + ":");
        List<List<String>> masterDataList = new ArrayList<List<String>>();
        Map<Long, String> idMap = new HashMap<Long, String>();
        int idx = 1;
        for (Map<String, Object> lineValues : formDataMasterList) {
            Long id = (Long) lineValues.get(MasterTableField.id.getKey());
            ids.add(id);
            List<String> data = new ArrayList<String>();
            if (fields.size() > 1) {
                String idString = FormConstant.excelTag + (idx++);
                idMap.put(id, idString);
                data.add(idString);
            }
            //遍历要导出的数据
            for (FormFieldBean ffb : fields.get(0)) {
                String temp_data = lineValues.get(ffb.getName().replace("_", "")) + "";//固定字段key有_但显示值没有_所以有这步操作
                if (StringUtil.checkNull(temp_data))
                    temp_data = "";
                data.add(temp_data);
                //日志
                logs.append(FormLogUtil.getLogForExportExcel(formBean, ffb, temp_data));
            }
            masterDataList.add(data);
        }
        //查询重复表数据
        List<Map<Long, List<List<String>>>> slaveDataList = new ArrayList<Map<Long, List<List<String>>>>();
        Map<Long, List<List<String>>> slaveDataMap = null;
        if (fields.size() > 1 && ids.size() > 0) {
            for (int i = 1; i < fields.size(); i++) {
                List<FormFieldBean> slaveFieldList = fields.get(i);
                if (slaveFieldList != null && !slaveFieldList.isEmpty()) {
                    String tableName = slaveFieldList.get(0).getOwnerTableName();
                    List<Map<String, Object>> formSlaveDataList = formDataManager.getFormSlaveDataListById(null, tableName, SubTableField.formmain_id.getKey(), ids);
                    FormUtil.setShowValueList(formBean, FormUtil.getUnflowFormAuth(formBean,String.valueOf(formTemplateId)), formSlaveDataList, true, true);
                    slaveDataMap = convertSlaveDataListToMap(formBean, formSlaveDataList, slaveFieldList, idMap);
                    slaveDataList.add(slaveDataMap);
                }
            }
        }

        fileToExcelManager.save(response, formBean.getFormName() + "_" + page, QueryUtil.exportExcel(formBean,
                bindAuthBean.getName(), fields, new HashMap<String, String>(), masterDataList, slaveDataList, ids));

        //记录无流程导出日志  
        formLogManager.saveOrUpdateLog(formId, formBean.getFormType(), formTemplateId, currentUserId,
                FormLogOperateType.EXPORTEXCEL.getKey(), logs.toString(), null, null);

        formDataManager.removeDownloadRecord(formBean.getId(), bindAuthBean.getId(), currentUserId);
        return null;
    }

    /**
     * 数字字段按格式导出，将重表数据list转换为map形式进行导出
     * add by chenxb 2016-03-01
     * */
    private Map<Long, List<List<String>>> convertSlaveDataListToMap(FormBean formBean, List<Map<String, Object>> formDataList, List<FormFieldBean> showFieldList, Map<Long, String> idMap) throws BusinessException{
        if (showFieldList != null && formDataList != null) {
            Map<Long, List<List<String>>> dataMap = new HashMap<Long, List<List<String>>>();
            Map<String, FormFieldBean> realFormFieldBeanMap = new HashMap<String, FormFieldBean>();
            for (Map<String, Object> lineValues : formDataList) {
                Long mainId = Long.valueOf(String.valueOf(lineValues.get(SubTableField.formmain_id.getKey())));
                List<List<String>> rowList;
                if (dataMap.containsKey(mainId)) {
                    rowList = dataMap.get(mainId);
                } else {
                    rowList = new ArrayList<List<String>>();
                    dataMap.put(mainId, rowList);
                }
                List<String> row = new ArrayList<String>();
                row.add(idMap.get(mainId));
                for (FormFieldBean showField : showFieldList) {
                    String key = showField.getDisplay();
                    FormFieldBean fieldBean = formBean.getFieldBeanByDisplay(key);
                    if (fieldBean != null) {
                        if (realFormFieldBeanMap.containsKey(key)) {
                            fieldBean = realFormFieldBeanMap.get(key);
                        } else {
                            fieldBean = fieldBean.findRealFieldBean();
                            realFormFieldBeanMap.put(key, fieldBean);
                        }
                        Object value = lineValues.get(fieldBean.getName());
                        if(value==null){
                        	row.add("");
                        }else{
                        	row.add(value.toString());
                        }
                    }else{
                        MasterTableField me = MasterTableField.getEnumByText(key);
                        if (null != me) {
                            fieldBean = me.getFormFieldBean();
                        }
                        if (fieldBean != null) {
                            Object value = lineValues.get(fieldBean.getName());
                            row.add(value.toString());
                        }
                    }
                }
                rowList.add(row);
            }
            return dataMap;
        }
        return null;
    }

    /**
     * 下载模板
     * 1、基础数据模板下载，取的是表单中所有可编辑状态的字段（不包含重复表）；
     * 2、信息管理模板下载，取的是表单中填写类型操作权限可编辑的所有字段（不包含重复表）。
     *
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * @throws Exception
     */
    public ModelAndView downTemplate(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, Exception {
        Map map = ParamUtil.getJsonParams();
        Long formId = ParamUtil.getLong(map, "formId");
        String field = ParamUtil.getString(map, "field");
        FormBean formBean = formCacheManager.getForm(formId);
        List<List<FormFieldBean>> expotFieldLists = FormUtil.splitFieldName2Field(formBean, field);
        String fileName = "导入模板";
        for (List<FormFieldBean> expotFieldList : expotFieldLists) {
            if (expotFieldList.size() > 255) {
                fileName = "导入模板.xlsx";
                break;
            }
        }
        fileToExcelManager.save(response, fileName, QueryUtil.exportFormForExcelTemplate("导入模板", "导入模板", expotFieldLists));
        return null;
    }

    /**
     * 下载重复表excel填写模板
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     * @throws
     */
    public ModelAndView exportRepeatTableTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        Long formId = ReqUtil.getLong(request, "formId");
        Long rightId = ReqUtil.getLong(request, "rightId");
        String tableName = ReqUtil.getString(request, "tableName");
        FormBean formBean = formCacheManager.getForm(formId);
        FormAuthViewBean favb = formBean.getAuthViewBeanById(rightId);
        //显示字段
        List<String> expotFields = new ArrayList<String>();
        /*List<FormFieldBean> expotFieldLists = this.formDataManager.getRepeatFormFieldForImport(formBean, favb, tableName);
        for (FormFieldBean bean : expotFieldLists) {
            expotFields.add(bean.getDisplay());
        }*/
        //有流程表单支持重复表导入模板设置
        String field = ReqUtil.getString(request, "field");
        if(Strings.isNotEmpty(field)){
            String[] fieldNames = field.split(",");
            for (String name : fieldNames) {
                String fieldName = name;
                if (name.contains(".")) {
                    fieldName = name.substring(name.indexOf("."));
                }
                FormFieldBean fb = formBean.getFieldBeanByName(fieldName);
                expotFields.add(fb.getDisplay());
            }
        }
        if (expotFields.isEmpty()) {
            PrintWriter out = null;
            try {
                out = response.getWriter();
                out.println("<script>");
                out.println("parent.$.alert(\""
                        + ResourceUtil.getString("form.repeatdata.importexcel.templatenull")
                        + "\")");
                out.println("window.close();");
                out.println("</script>");
                out.flush();
            } catch (IOException e) {
                LOGGER.error(e.getMessage(), e);
            } finally {
                if(out != null){
                    out.close();
                }
            }
        } else {
            fileToExcelManager.save(response, ResourceUtil.getString("form.repeatdata.importexcel.excelname"),
                    QueryUtil.exportTemplate(ResourceUtil.getString("form.repeatdata.importexcel.template"), expotFields, new HashMap<String, String>()));
        }
        return null;
    }

    /**
     * 导入excel填写模板数据到重复表
     *
     * @param
     * @throws Exception
     * @throws
     */
    @SuppressWarnings("unchecked")
    public ModelAndView dealExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType(CONTENT_TYPE);
        Map<String, Object> data = ParamUtil.getJsonParams();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("fileUrl", ReqUtil.getString(request, "fileUrl"));
        params.put("formId", ReqUtil.getString(request, "formId"));
        params.put("rightId", ReqUtil.getString(request, "rightId"));
        params.put("tableName", ReqUtil.getString(request, "tableName"));
        params.put("formMasterId", ReqUtil.getString(request, "formMasterId"));
        params.put("recordId", ReqUtil.getString(request, "recordId"));
        String res = formDataManager.dealExcelForImport(params, data);
        PrintWriter out = null;
        try {
            out = response.getWriter();
            out.println(res);
            out.flush();
        } catch (IOException e) {
            LOGGER.error(e.getMessage(), e);
        } finally {
            if(out != null){
                out.close();
            }
        }
        return null;
    }

    /**
     * 显示日志
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView showLog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("ctp/form/common/formLogShow");
        Long formId = ReqUtil.getLong(request, "formId");
        Long recordId = ReqUtil.getLong(request, "recordId", -1L);
        Long formTemplateId = ReqUtil.getLong(request,"formTemplateId",-1L);
        if(!FormService.checkRight(FormModuleAuthModuleType.BindAppForm,formTemplateId,AppContext.currentUserId(),formId)){
            super.rendJavaScript(response, "alert('"+ResourceUtil.getString("bizconfig.use.authorize.forbidden")+"');window.close()");
        }
        view.addObject("formId", formId);
        view.addObject("recordId", recordId);
        view.addObject("formType", ReqUtil.getString(request, "formType"));
        view.addObject("single", ReqUtil.getString(request, "single"));
        return view;
    }

    public ModelAndView exportLogs(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        String logLable = ResourceUtil.getString("form.log.label");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("formId", ReqUtil.getString(request, "formId"));
        params.put("size", ReqUtil.getString(request, "size"));
        params.put("page", ReqUtil.getString(request, "page"));
        if (ReqUtil.getString(request, "beginoperatime") != null) {
            params.put("beginoperatime", ReqUtil.getString(request, "beginoperatime"));
        }
        if (ReqUtil.getString(request, "endoperatime") != null) {
            params.put("endoperatime", ReqUtil.getString(request, "endoperatime"));
        }
        if (ReqUtil.getString(request, "operateType") != null) {
            params.put("operateType", ReqUtil.getString(request, "operateType"));
        }
        if (ReqUtil.getString(request, "begincreatetime") != null) {
            params.put("begincreatetime", ReqUtil.getString(request, "begincreatetime"));
        }
        if (ReqUtil.getString(request, "endcreatetime") != null) {
            params.put("endcreatetime", ReqUtil.getString(request, "endcreatetime"));
        }
        if (ReqUtil.getString(request, "creator") != null) {
            params.put("creator", ReqUtil.getString(request, "creator"));
        }
        if (ReqUtil.getString(request, "operator") != null) {
            params.put("operator", ReqUtil.getString(request, "operator"));
        }
        if (ReqUtil.getString(request, "recordId") != null) {
            params.put("recordId", ReqUtil.getString(request, "recordId"));
        }
        List<Map<String, Object>> listMap = formLogManager.exportLogs(params);
        OrgManager extendMemberOrgManager = (OrgManager) AppContext.getBean("orgManager");
        // 列头
        List<String> expotFields = new ArrayList<String>();
        expotFields.add("操作人员");
        expotFields.add("操作类型");
        expotFields.add("操作描述");
        expotFields.add("操作时间");
        expotFields.add("创建人");
        expotFields.add("创建时间");
        // 数据
        List<List<String>> datas = new ArrayList<List<String>>();
        for (int i = 0; i < listMap.size(); i++) {
            List<String> data = new ArrayList<String>();

            FormLog fb = (FormLog) listMap.get(i);
            // 设置人员
            if (extendMemberOrgManager != null) {
                if (fb.getOperator() == 0) {
                    data.add(ResourceUtil.getString("form.trigger.triggerSet.unflow.log.system"));
                } else {
                    V3xOrgMember member = extendMemberOrgManager.getMemberById(fb.getOperator());
                    if (member != null) {
                        data.add(member.getName());
                    }
                }
            }
            data.add(FormLogOperateType.getFromLogOperateTypeByKey(fb.getOperateType()).getText());
            //这里对操作描述字符做一个截取，如果大于32767个字符，进行截取，后三位以...表示
            if (fb.getDescription() != null && fb.getDescription().length() > 32767) {
                String subDescription = fb.getDescription().substring(0, 32763) + "...";
                data.add(subDescription);
            } else {
                data.add(fb.getDescription());
            }
            data.add(DateUtil.format(fb.getOperateDate(), DateUtil.YMDHMS_PATTERN));
            // 设置人员
            if (extendMemberOrgManager != null) {
                V3xOrgMember member = extendMemberOrgManager.getMemberById(fb.getCreator());
                if (member != null) {
                    data.add(member.getName());
                }
            }
            if (fb.getCreateDate() == null) {
                data.add("");
            } else {
                data.add(DateUtil.format(fb.getCreateDate(), DateUtil.YMDHMS_PATTERN));
            }
            datas.add(data);
        }
        try {
            fileToExcelManager.save(response, logLable, QueryUtil.exportLogForExcelTemplate(logLable, logLable, expotFields,
                    new HashMap<String, String>(), datas));
        } catch (Exception e) {
            throw new BusinessException(e);
        }
        return null;
    }

    public ModelAndView modifyAutoSendData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String result = "更新状态完成！";
        if (!this.formDataManager.updateDataState()) {
            result = "部分数据更新发生异常，详情参见日志！";
        }
        super.rendJavaScript(response, "alert('" + result + "')");
        return null;
    }

    /**
     * 无流程表单栏目查询（列表展现）
     *
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView unflowQueryResultSection(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/form/queryResult/unflowQueryResultSection");
        //模板ID
        Long queryId = ReqUtil.getLong(request, "queryId");
        //表单ID
        Long formId = ReqUtil.getLong(request, "formId");
        FormBean formBean = this.formCacheManager.getForm(formId);
        FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(queryId));
        if (bindAuthBean != null) {
            if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                LOGGER.error(ResourceUtil.getString("form.showAppFormData.noright"));
                throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
            }
            //显示的字段
            List<SimpleObjectBean> showFields = bindAuthBean.getShowFieldList();
            //将动态字段转换成JSON
            mav.addObject("theadStr", DynamicFieldUtil.getTheadStr(showFields, formBean));
            FlipInfo flipInfo = new FlipInfo();
            flipInfo.setSize(50);
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("formId", formBean.getId());
            params.put("formTemplateId", queryId);
            params.put("sortStr", DynamicFieldUtil.getSortStr(bindAuthBean.getOrderByList()));
            try {
                formManager.getFormMasterDataListByFormId(flipInfo, params);
            } catch (SQLException e) {
                LOGGER.error(e.getMessage(), e);
                throw new BusinessException(e);
            }
            mav.addObject("_data", JSONUtil.toJSONString(flipInfo.getData()));
            //处理返回前端的数据
            unflowSectionComm(formBean, bindAuthBean, mav, request);
        }
        List<FormFieldBean> allfieldList = formBean.getAllFieldBeans();
        List<String> urlFieldList = FormUtil.findUrlFieldList(allfieldList);
        mav.addObject("urlFieldList", JSONUtil.toJSONString(urlFieldList));
        return mav;
    }

    /**
     * 无流程栏目 单据显示
     *
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView unflowQuerySingleDataSection(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/form/queryResult/unflowSingleDataSection");
        //模板ID
        Long queryId = ReqUtil.getLong(request, "queryId");
        //表单ID
        Long formId = ReqUtil.getLong(request, "formId");
        //单据查询类型
        String singleType = ReqUtil.getString(request, "singleType");
        FormBean formBean = this.formCacheManager.getForm(formId);
        FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(queryId));
        if (bindAuthBean != null) {
            if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                LOGGER.error(ResourceUtil.getString("form.showAppFormData.noright"));
                throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
            }

            FlipInfo flipInfo = new FlipInfo();
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("formId", formBean.getId());
            params.put("formTemplateId", queryId);
            String sortStr = DynamicFieldUtil.getSortStr(bindAuthBean.getOrderByList());
            params.put("sortStr", sortStr);
            boolean reverse = false;
            //默认取第一条数据,singleType == 1 表示最后一条数据
            if ("1".equals(singleType)) {
                //将排序置反，查询的结果取第一条，相当于取最后一条
                reverse = true;
            }
            formDataManager.getFormData4SingleData(flipInfo, params, reverse);
            List<Map<String, String>> dataList = flipInfo.getData();
            if (dataList.isEmpty()) {
                return mav;
            }
            Map<String, String> dataObj = dataList.get(0);
            mav.addObject("_moduleId", dataObj.get("id"));
            //处理返回前端的数据
            unflowSectionComm(formBean, bindAuthBean, mav, request);
        }
        return mav;
    }

    /**
     * 无流程栏目 -- 处理返回前端的数据
     *
     * @param formBean
     * @param bindAuthBean
     * @param mav
     * @param request
     */
    private void unflowSectionComm(FormBean formBean, FormBindAuthBean bindAuthBean, ModelAndView mav, HttpServletRequest request) {
        mav.addObject("_moduleType",
                formBean.getFormType() == FormType.baseInfo.getKey() ? ModuleType.unflowBasic.getKey() : ModuleType.unflowInfo.getKey());
        mav.addObject("_templateName", bindAuthBean.getName());
        //查询权限
        if (formBean.getFormType() == FormType.baseInfo.getKey()) {
            FormViewBean tempFormViewBean = formBean.getFormViewList().get(0);
            List<FormAuthViewBean> formShowAuths = tempFormViewBean.getFormAuthViewBeanListByType(FormAuthorizationType.show);
            //基础数据因为绑定中没有设置显示的时候是用哪个视图下的那个查看权限，所以取第一个视图下的第一个查看权限
            mav.addObject("_rightId", formShowAuths.get(0).getId());
            //新建按钮权限
            List<FormAuthViewBean> addAuths = tempFormViewBean.getFormAuthViewBeanListByType(FormAuthorizationType.add);
            mav.addObject("editAuth", tempFormViewBean.getId() + "." + addAuths.get(0).getId());
        } else {
            //视图查看权限 ,信息管理列表下方点击查看默认打开第一个视图的
            String showAuth = bindAuthBean.getShowFormAuth();
            if (Strings.isNotBlank(showAuth)) {
                if ("|".equals(showAuth.substring(showAuth.length() - 1, showAuth.length()))) {
                    showAuth = showAuth.substring(0, showAuth.length() - 1);
                }
            }
            mav.addObject("_rightId", showAuth.replaceAll("[|]","_"));
            //修改权限
            List<SimpleObjectBean> editAuth = bindAuthBean.getUpdateAuthList();
            List<SimpleObjectBean> cloneEditAuth = new ArrayList<SimpleObjectBean>();
            for (SimpleObjectBean s : editAuth) {
                SimpleObjectBean c = null;
                try {
                    c = (SimpleObjectBean) s.clone();
                } catch (CloneNotSupportedException e) {
                    LOGGER.error(e.getMessage(), e);
                }
                if (StringUtil.checkNull(c.getDisplay())) {
                    c.setDisplay(ResourceUtil.getString("application.92.label"));
                }
                cloneEditAuth.add(c);
            }
            editAuth = cloneEditAuth;
            mav.addObject("editAuth", JSONUtil.toJSONString(editAuth));
        }
        mav.addObject("_formId", ReqUtil.getLong(request, "formId"));
        mav.addObject("_formTemplateId", ReqUtil.getLong(request, "queryId"));
    }

    /**
     * 扫描枪设置端口
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView setScanningGun(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/form/common/scanningSet");
        return mav;
    }
    /**
     * 显示签名图片，微信上需要加白名单
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @NeedlessCheckLogin
    public ModelAndView showInscribeSignetPic(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean accessDenied =false;
        if( user == null){
            // 如果没有登录,只对来自微信的放行.
            if(UserHelper.isFromMicroCollaboration(request)){
                accessDenied = false;
            }else{
                accessDenied = true;
            }
        }

        //没有登录，直接屏蔽
        if(accessDenied){
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }
        Long id = Long.valueOf(request.getParameter("id"));
        V3xHtmDocumentSignature signet = htmSignetManager.getById(id);
        OutputStream out = null;
        try {
            if (signet != null) {
                String body = signet.getFieldValue();
                byte[] b = FormUtil.hex2Byte(body);

//                response.setContentType("application/octet-stream; charset=UTF-8");
//                response.setHeader("Content-disposition", "attachment;filename=\"file.jpg\"");
                response.setContentType("image/gif");//image/jpeg
                out = response.getOutputStream();
                out.write(b);
            }
        } catch (Exception e) {
            LOGGER.error("显示电子签名异常", e);
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (Exception e) {
                    LOGGER.error("", e);
                }
            }
        }

        return null;
    }

    /**
     * 查询正在排队执行的触发等任务列表
     * */
    public ModelAndView getTriggerEventQueneList(HttpServletRequest request, HttpServletResponse response) throws BusinessException{
        response.setContentType(CONTENT_TYPE);
        ModelAndView modelAndView = new ModelAndView("ctp/form/common/formTriggreEventList");
        return modelAndView;
    }

    /**
     * @return the formManager
     */
    public FormManager getFormManager() {
        return formManager;
    }

    /**
     * @param formManager the formManager to set
     */
    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    /**
     * @return the formCacheManager
     */
    public FormCacheManager getFormCacheManager() {
        return formCacheManager;
    }

    /**
     * @param formCacheManager the formCacheManager to set
     */
    public void setFormCacheManager(FormCacheManager formCacheManager) {
        this.formCacheManager = formCacheManager;
    }

    public FileToExcelManager getFileToExcelManager() {
        return fileToExcelManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public FormLogManager getFormLogManager() {
        return formLogManager;
    }

    public void setFormLogManager(FormLogManager formLogManager) {
        this.formLogManager = formLogManager;
    }

    public FileManager getFileManager() {
        return fileManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    /**
     * @return the templateManager
     */
    public TemplateManager getTemplateManager() {
        return templateManager;
    }

    /**
     * @param templateManager the templateManager to set
     */
    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    /**
     * @return the formDataManager
     */
    public FormDataManager getFormDataManager() {
        return formDataManager;
    }

    /**
     * @param formDataManager the formDataManager to set
     */
    public void setFormDataManager(FormDataManager formDataManager) {
        this.formDataManager = formDataManager;
    }

    /**
     * @return the wapi
     */
    public WorkflowApiManager getWapi() {
        return wapi;
    }

    /**
     * @param wapi the wapi to set
     */
    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    /**
     * @return the formAuthDesignManager
     */
    public FormAuthDesignManager getFormAuthDesignManager() {
        return formAuthDesignManager;
    }

    /**
     * @param formAuthDesignManager the formAuthDesignManager to set
     */
    public void setFormAuthDesignManager(FormAuthDesignManager formAuthDesignManager) {
        this.formAuthDesignManager = formAuthDesignManager;
    }
    public V3xHtmDocumentSignatManager getHtmSignetManager() {
        return htmSignetManager;
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
