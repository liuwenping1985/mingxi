package com.seeyon.ctp.form.modules.engin.base.formData;

import java.io.File;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.ConcurrentModificationException;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.taglibs.standard.functions.Functions;

import com.seeyon.apps.collaboration.constants.ColConstant;
import com.seeyon.apps.collaboration.enums.ColHandleType;
import com.seeyon.apps.collaboration.enums.CollaborationEnum.flowState;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.taskmanage.api.TaskmanageApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.barCode.manager.BarCodeManager;
import com.seeyon.ctp.common.barCode.vo.ResultVO;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.content.mainbody.MainbodyStatus;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.lbs.manager.LbsManager;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.progressBar.CTPProgressBar;
import com.seeyon.ctp.common.progressBar.CTPProgressUtil;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormAuthViewFieldBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean.AuthName;
import com.seeyon.ctp.form.bean.FormBindAuthBean4Phone;
import com.seeyon.ctp.form.bean.FormBindBean;
import com.seeyon.ctp.form.bean.FormConditionActionBean;
import com.seeyon.ctp.form.bean.FormDataBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.bean.FormFormulaBean;
import com.seeyon.ctp.form.bean.FormFormulaBean.FormulaBaseBean;
import com.seeyon.ctp.form.bean.FormFormulaBean.FormulaDataFieldBean;
import com.seeyon.ctp.form.bean.FormFormulaBean.FormulaFunctionBean;
import com.seeyon.ctp.form.bean.FormFormulaBean.FormulaValueBean;
import com.seeyon.ctp.form.bean.FormQueryBean;
import com.seeyon.ctp.form.bean.FormQueryBean4Phone;
import com.seeyon.ctp.form.bean.FormQueryIndicatorBean;
import com.seeyon.ctp.form.bean.FormQueryResult;
import com.seeyon.ctp.form.bean.FormQueryTypeEnum;
import com.seeyon.ctp.form.bean.FormQueryWhereClause;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.bean.FormTriggerBean;
import com.seeyon.ctp.form.bean.FormTriggerBean.TriggerConditionState;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.bean.SimpleObjectBean;
import com.seeyon.ctp.form.bean.SimpleObjectBean.ExtMap;
import com.seeyon.ctp.form.bean.SubRelationBean;
import com.seeyon.ctp.form.modules.bind.FormBindDesignManager;
import com.seeyon.ctp.form.modules.bind.FormLogManager;
import com.seeyon.ctp.form.modules.engin.authorization.FormAuthDesignManager;
import com.seeyon.ctp.form.modules.engin.formula.CustomSelectEnums.DateTime4CustomSelect;
import com.seeyon.ctp.form.modules.engin.formula.CustomSelectEnums.SystemVar4CustomSelect;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.DataFieldType;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.FormulaVar;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.FunctionSymbol;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.SystemDataField;
import com.seeyon.ctp.form.modules.engin.formula.FormulaFunctionUitl;
import com.seeyon.ctp.form.modules.engin.formula.FormulaUtil;
import com.seeyon.ctp.form.modules.engin.formula.validate.FormulaValidate;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.RelationAuthSourceType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ToRelationAttrType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ViewSelectType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationManager;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationRecordDAO;
import com.seeyon.ctp.form.modules.serialNumber.SerialCalRecordManager;
import com.seeyon.ctp.form.modules.trigger.FormTriggerManager;
import com.seeyon.ctp.form.po.CtpFormula;
import com.seeyon.ctp.form.po.CtpTemplateRelationAuth;
import com.seeyon.ctp.form.po.FormRelation;
import com.seeyon.ctp.form.po.FormRelationRecord;
import com.seeyon.ctp.form.po.FormSerialCalculateRecord;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.Enums;
import com.seeyon.ctp.form.util.Enums.BarcodeCorrectionOption;
import com.seeyon.ctp.form.util.Enums.BarcodeType;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FieldType;
import com.seeyon.ctp.form.util.Enums.FlowDealOptionsType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormDataRatifyFlagEnum;
import com.seeyon.ctp.form.util.Enums.FormDataStateEnum;
import com.seeyon.ctp.form.util.Enums.FormLogOperateType;
import com.seeyon.ctp.form.util.Enums.FormModuleAuthModuleType;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.FromDataFinishedFlagEnum;
import com.seeyon.ctp.form.util.Enums.ImportExcelType;
import com.seeyon.ctp.form.util.Enums.InputTypeCategory;
import com.seeyon.ctp.form.util.Enums.MasterTableField;
import com.seeyon.ctp.form.util.Enums.SubTableField;
import com.seeyon.ctp.form.util.Enums.UpdateDataType;
import com.seeyon.ctp.form.util.FormConstant;
import com.seeyon.ctp.form.util.FormLogUtil;
import com.seeyon.ctp.form.util.FormSearchUtil;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.form.util.StringUtils;
import com.seeyon.ctp.form.util.TreeNodeUtil;
import com.seeyon.ctp.form.util.UnflowFormQueryUtil;
import com.seeyon.ctp.form.vo.FormCalcParamVO;
import com.seeyon.ctp.form.vo.FormSearchFieldBaseBo;
import com.seeyon.ctp.form.vo.FormSearchFieldCheckboxVo;
import com.seeyon.ctp.form.vo.FormSearchFieldDateVo;
import com.seeyon.ctp.form.vo.FormSearchFieldDeptVo;
import com.seeyon.ctp.form.vo.FormSearchFieldEnumVo;
import com.seeyon.ctp.form.vo.FormSearchFieldVO;
import com.seeyon.ctp.form.vo.FormTreeNode;
import com.seeyon.ctp.form.vo.SelectedDateVo;
import com.seeyon.ctp.form.vo.ShowCheckboxVo;
import com.seeyon.ctp.login.event.UserLogoutEvent;
import com.seeyon.ctp.login.online.OnlineUser;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xSignet;
import com.seeyon.v3x.system.signet.manager.SignetManager;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;

import www.seeyon.com.utils.UUIDUtil;


public class FormDataManagerImpl implements FormDataManager {
    private static final Log LOGGER = CtpLogFactory.getLog(FormDataManagerImpl.class);
    private FormCacheManager formCacheManager;
    private FormDataDAO formDataDAO;
    private FormRelationManager formRelationManager;
    private FormRelationRecordDAO formRelationRecordDAO;
    private FormLogManager formLogManager;
    private FileManager fileManager;
    private FileToExcelManager fileToExcelManager;
    private FormTriggerManager formTriggerManager;
    private OrgManager orgManager;
    private AffairManager affairManager;
    private FormManager formManager;
    private FormAuthDesignManager formAuthDesignManager;
    private WorkflowApiManager wapi;
    private LbsManager lbsManager;
    private IndexManager indexManager;
    private EnumManager enumManagerNew;
    private FormBindDesignManager formBindDesignManager;
    private SignetManager signetManager;
    private V3xHtmDocumentSignatManager htmSignetManager;
    private BarCodeManager barCodeManager;
    private AttachmentManager attachmentManager;
    private SerialCalRecordManager serialCalRecordManager;

    /**
     * 审核节点权限常量
     */
    private static final String AUDIT = "formaudit";
    /**
     * 核定节点权限常量
     */
    private static final String vouch = "vouch";
    /**
     * 表单数据加锁导致错误标识
     */
    private static final String LOCKDATAERROR = "lockDataError";

    private static final int MAX_IMPORT_NUM = 999;

    /**
     * 缓存记录map
     */
    private static final ConcurrentMap<String, List<String>> CACHE_RECORD = new ConcurrentHashMap<String, List<String>>();

    private static final String DOWNLOAD_KEY = "DOWNLOAD_KEY";
    private static final String BATCH_UPDATE_KEY = "BATCH_UPDATE_KEY";

    @Override
    public void calc(FormBean form, FormFieldBean resultFormFieldBean, FormDataMasterBean cacheMasterData, Long recordId, Map<String, Object> resultMap, FormAuthViewBean authViewBean, boolean needHtml, boolean needDealSysRelation) throws BusinessException {
        FormCalcParamVO paramVO = new FormCalcParamVO();
        paramVO.setFormBean(form);
        paramVO.setFormFieldBean(resultFormFieldBean);
        paramVO.setMasterBean(cacheMasterData);
        paramVO.setRecordId(recordId);
        paramVO.setResultMap(resultMap);
        paramVO.setAuthViewBean(authViewBean);
        paramVO.setNeedHtml(needHtml);
        paramVO.setNeedDealSysRelation(needDealSysRelation);
        calc(paramVO);
    }

    @Override
    public void calc(FormCalcParamVO paramVO) throws BusinessException {
        FormBean form = paramVO.getFormBean();
        FormFieldBean resultFormFieldBean = paramVO.getFormFieldBean();
        FormDataMasterBean cacheMasterData = paramVO.getMasterBean();
        Long recordId = paramVO.getRecordId();
        Map<String, Object> resultMap = paramVO.getResultMap();
        FormAuthViewBean authViewBean = paramVO.getAuthViewBean();
        boolean needHtml = paramVO.isNeedHtml();
        boolean needDealSysRelation = paramVO.isNeedDealSysRelation();
        String errorFormulaStr = "";
        try {
            String fname = resultFormFieldBean.getName();
            String formulaType = FormulaEnums.getFormulaTypeByFieldType(resultFormFieldBean.getFieldType());
            //单元格计算之后的值
            Object value = null;
            //当前计算结果是否和缓存中的值一致，用于判断是否要刷新此单元格值改变所要影响的条件和公式计算
            boolean isChange = false;
            //计算map
            Map<String, Object> params = cacheMasterData.getFormulaMap(formulaType);
            //sumif averif maxif minif所需使用参数
            params.put("formDataBean", cacheMasterData);
            params.put("formBean", form);
            Map<String, Object> subRowConditionMap = null;
            FormDataBean dataBean = null;
            boolean isDelRow = false;
            if (!resultFormFieldBean.isMasterField() && recordId != null && recordId.longValue() != 0 && recordId.longValue() != -1) {
                dataBean = cacheMasterData.getFormDataSubBeanById(resultFormFieldBean.getOwnerTableName(), recordId);
                if (dataBean != null) {
                    //子表行内的计算要添加本行的数据
                    params.putAll(dataBean.getFormulaMap(formulaType));
                    params.put("subDataBean", dataBean);
                    subRowConditionMap = dataBean.getFormulaMap(FormulaEnums.componentType_condition);
                } else {//删除行的时候dataBean已经被移除缓存了,如果结果字段是子表行字段就不需要进行计算本行字段的计算了
                    isDelRow = true;
                }
            } else {
                dataBean = cacheMasterData;
            }

            if (!isDelRow) {
                //条件map
                Map<String, Object> conditionMap = null;
                List<FormConditionActionBean> formConditionList = resultFormFieldBean.getFormConditionList();
                if (formConditionList != null && formConditionList.size() > 1) {//高级计算
                    conditionMap = cacheMasterData.getFormulaMap(FormulaEnums.componentType_condition);
                    conditionMap.put("formDataBean", cacheMasterData);
                    conditionMap.put("formBean", form);
                    if (subRowConditionMap != null) {
                        conditionMap.putAll(subRowConditionMap);
                    }
                }
                FormFormulaBean formulaBean = resultFormFieldBean.formulaGetFormulaBean(conditionMap);
                if (null == formulaBean) {
                    return;
                }
                String forumlaStr = formulaBean.getExecuteFormulaForGroove();
                //动态组合单个字段变量需要自己做替换处理，为了满足现实格式，然后再给groovey执行
                if (formulaType.equals(FormulaEnums.formulaType_varchar)) {
                    String[] strs = forumlaStr.split("\\+");
//                    StringBuffer sb = new StringBuffer();
                    for (String str : strs) {
                        str = str.trim();
                        FormFieldBean field = form.getFieldBeanByName(str);
                        if (field != null) {
                            field = field.findRealFieldBean();
                            Object val = null;
                            if (field.isMasterField()) {
                                val = cacheMasterData.getFieldValue(str);
                            } else {
                                val = cacheMasterData.getSubDataMapById(field.getOwnerTableName(), recordId).get(field.getName());
                            }
                            String valueStr = String.valueOf(field.getDisplayValue(val, false)[1]);
                            valueStr = valueStr.replace("\\", "\\\\").replace("'", "\\'");
                            str = str.replace(str, valueStr);
                            str = str.replaceAll("\r", "@@SEEYON_V5_huiche@@");
                            str = str.replaceAll("\n", "@@SEEYON_V5_huanghang@@");

                            if(valueStr.contains("script")){
                                valueStr = valueStr.replaceAll("script","@seeyon_script");
                            }
                            params.put(field.getName(), valueStr);
//                            str = "'" + str + "'";
                        }
//                        sb.append(field.getName()).append("+");
                    }
//                    forumlaStr = StringUtils.replaceLast(sb.toString(), "+", "");
                    //动态组合必须先程序计算所有to_date函数以保证日期是字符串类型才能进行动态组合
                    if (forumlaStr.indexOf(FunctionSymbol.to_date.getKey()) >= 0) {
                        Pattern pattern = Pattern.compile("to_date\\(([^()]*)\\)");
                        Matcher matcher = pattern.matcher(forumlaStr);
                        StringBuffer sb = new StringBuffer();
                        while (matcher.find()) {
                            String group1 = matcher.group(1);
                            matcher.appendReplacement(sb, group1);
                        }
                        matcher.appendTail(sb);
                        forumlaStr = sb.toString();
                    }
                }
                //计算的Map是通过FormFieldBean的数据类型确定
                //没有流水号的运算式，要特殊处理，因为有些地方需要立刻计算，有些地方需要事后计算
                int hasSN = forumlaStr.indexOf(DataFieldType.serialNumber.getKey());
                if (hasSN >= 0) {//记录下计算式里含有流水号的;这里通过线程变量记录一下字段的名称、表单id以及数据id,格式:字段名称_表单id_数据id_字表数据id
                    String tempSerialData = resultFormFieldBean.getName() + FormConstant.DOWNLINE
                            + form.getId() + FormConstant.DOWNLINE + cacheMasterData.getId()
                            + FormConstant.DOWNLINE + recordId;
                    //如果是主表字段，但是传入了recordId，则再处理key的时候需要记录的是0，而不是传入的recordId，这种在新增、删除重复行的时候刷新计算就会出现这种情况
                    //OA-128417 主表的流水号动态组合字段又参与了重复表的动态组合，重复表增、减行，会导致主表流水号动态组合消失。
                    if(resultFormFieldBean.isMasterField() && recordId != 0L){
                        tempSerialData = resultFormFieldBean.getName() + FormConstant.DOWNLINE
                                + form.getId() + FormConstant.DOWNLINE + cacheMasterData.getId()
                                + FormConstant.DOWNLINE + "0";
                    }
                    AppContext.putThreadContext(FormConstant.serialCalFunctionKey, tempSerialData);
                }
                // 将计算式类型放入到参数中
                params.put("formulaType", formulaType);
                errorFormulaStr = "数据：" + cacheMasterData.getId() + " 字段：" + resultFormFieldBean.getName() + resultFormFieldBean.getDisplay() + " forumlaStr:" + forumlaStr;
                value = FormulaUtil.doResult(forumlaStr, params);//更改cacheMasterData中对应于resultFormFieldBean的值为value
                value = FormUtil.formatCalcValue(resultFormFieldBean, value, formulaType);
                Object oldVal = dataBean.getFieldValue(resultFormFieldBean.getName());
                if (!String.valueOf(value).equals(String.valueOf(oldVal))) {
                    isChange = true;
                }
                if (isPreRow(resultFormFieldBean) && "".equals(value)) {
                    isChange = false;
                }
                dataBean.addFieldValue(resultFormFieldBean.getName(), value, true);
                if (resultMap != null && needHtml && null != authViewBean) {
                    if (conditionMap == null) {
                        conditionMap = cacheMasterData.getFormulaMap(FormulaEnums.componentType_condition);
                        conditionMap.put("formDataBean", cacheMasterData);
                        conditionMap.put("formBean", form);
                        if (subRowConditionMap != null) {
                            conditionMap.putAll(subRowConditionMap);
                        }
                    }
                    FormAuthViewFieldBean fieldAuth = authViewBean.getFormAuthorizationField(fname, conditionMap);
                    String access = fieldAuth.getAccess();
                    if ((fieldAuth.getAccess().equals(FieldAccessType.edit.getKey()) || fieldAuth.getAccess().equals(FieldAccessType.add.getKey()))) {
                        access = FieldAccessType.browse.getKey();
                    }
                    boolean retMax = resultFormFieldBean.isBiggerThanMaxDecimal(value);
                    //计算结果字段大多是文本字段，为了减少网络传输量和前端减少dom替换，浏览态文本框的计算结果直接返回value
                    if ((!retMax) && access.equals(FieldAccessType.browse.getKey()) && resultFormFieldBean.getInputTypeEnum() != null && resultFormFieldBean.getInputTypeEnum().equals(FormFieldComEnum.TEXT)) {
                        //OA-86905 如图设置，文本型的长度小于计算式结果的出长度，填写数据时显示完整的，保存后才做的截取
                        value = dataBean.getFieldValue(resultFormFieldBean.getName());
                        String result = String.valueOf(resultFormFieldBean.getDisplayValue(value)[1]);
                        if (!resultFormFieldBean.isMasterField()) {
                            if (recordId == 0L || recordId == -1L) {
                                throw new BusinessException("子表字段参与计算需要传入recordId");
                            }
                            resultMap.put("v" + FormConstant.DOWNLINE + fname + FormConstant.DOWNLINE + recordId, result);
                        } else {
                            resultMap.put("v" + FormConstant.DOWNLINE + fname, result);
                        }
                        if (FormUtil.isH5()) {
                            FormFieldComEnum.getHTML(form, resultFormFieldBean, fieldAuth, dataBean);
                        }
                    } else {
                        String result = FormFieldComEnum.getHTML(form, resultFormFieldBean, fieldAuth, dataBean);
                        //数字计算结果如果超过最大长度，背景颜色变成黄色，并给title提示。
                        if (retMax) {
                            result = StringUtils.replaceLast(result, "class=\"", "title=\""+ ResourceUtil.getString("form.formula.calc.number.max.label") +"\" class=\"biggerThanMax ");//数字计算结果超过允许最大值，请联系表单管理员重新定义此单元格长度。
                        }
                        if (!resultFormFieldBean.isMasterField()) {
                            if (recordId == 0L || recordId == -1L) {
                                throw new BusinessException("子表字段参与计算需要传入recordId");
                            }
                            resultMap.put(fname + FormConstant.DOWNLINE + recordId, result);
                        } else {
                            resultMap.put(fname, result);
                        }
                    }
                }
            }
            boolean hasDealSysRelation = false;
            if (isChange) {
                boolean isSelect = resultFormFieldBean.findRealFieldBean().getInputType().equalsIgnoreCase(FormFieldComEnum.SELECT.getKey());
                if (isSelect) {//下拉可能需要刷新下级枚举
                    //查询此单元格作为父级枚举时的所有关联关系列表
                    List<FormRelation> relations = form.getEnumRelationByParent(resultFormFieldBean);
                    //循环处理当前枚举将要影响到的下级枚举
                    for (FormRelation relation : relations) {
                        formRelationManager.dealEnumRelation(form, cacheMasterData, authViewBean, relation, recordId, resultMap, resultFormFieldBean.getEnumId(), resultFormFieldBean.getEnumLevel() + 1, needDealSysRelation);
                    }
                }
                if (resultFormFieldBean.isInCalculate()) {
                    if (needDealSysRelation) {
                        hasDealSysRelation = true;
                    }
                    if (resultFormFieldBean.isMasterField()) {
                        //如果是主表字段参与的计算，需要将子表行id修改成0或者空，这样后续会依据此值来判断是否要循环计算重复行
                        calcAllWithFieldIn(form, resultFormFieldBean, cacheMasterData, 0l, resultMap, authViewBean, needHtml, needDealSysRelation);
                    } else {
                        calcAllWithFieldIn(form, resultFormFieldBean, cacheMasterData, recordId, resultMap, authViewBean, needHtml, needDealSysRelation);
                    }
                }
            }
            if (resultFormFieldBean.isInCondition()) {
                if (authViewBean != null && resultMap != null && needHtml) {
                    if (needDealSysRelation && !hasDealSysRelation) {
                        resultMap.putAll(dealSysRelation(form, cacheMasterData, resultFormFieldBean, authViewBean, recordId, false, null, needHtml));
                    }
                    resultMap.putAll(dealFormRightChangeResult(form, authViewBean, cacheMasterData));
                } else {
                    if (needDealSysRelation && !hasDealSysRelation) {
                        dealSysRelation(form, cacheMasterData, resultFormFieldBean, authViewBean, recordId, false, null, needHtml);
                    }
                }
            }
        } catch (StackOverflowError e) {
            LOGGER.error(errorFormulaStr + "  " + e.getMessage(), e);
            throw e;
        } catch (BusinessException e) {
            LOGGER.error(errorFormulaStr + "  " + e.getMessage(), e);
            throw e;
        }
    }


    /**
     * 计算出给定单元格在表单中所参与的所有计算结果
     *
     * @param form
     * @param formFieldBean
     * @param cacheMasterData
     * @param recordId
     * @param resultMap
     * @param authViewBean
     * @param needDealSysRelation 是否需要刷新关联
     * @throws BusinessException
     */
    @Override
    public void calcAllWithFieldIn(FormBean form, FormFieldBean formFieldBean, FormDataMasterBean cacheMasterData,
                                   Long recordId, Map<String, Object> resultMap, FormAuthViewBean authViewBean, boolean needHtml, boolean needDealSysRelation)
            throws BusinessException {
        try {
            List<FormFieldBean> allFields = form.getAllFieldBeans();
            for (FormFieldBean tempFormField : allFields) {
                FormAuthViewBean newAuthViewBean = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
                if (newAuthViewBean != null) {
                    authViewBean = newAuthViewBean;
                }
                //如果表单单元格计算式中包含fieldName则进行计算，将计算结果保存在cacheMasterData中
                List<FormConditionActionBean> actions = tempFormField.getFormConditionList();
                if (actions != null && actions.size() > 0) {
                    if (FormulaUtil.isFieldExistFormula(actions, formFieldBean.getName()) && !formFieldBean.getName().equalsIgnoreCase(tempFormField.getName())) {
                        if (tempFormField.isMasterField()) {
                            calc(form, tempFormField, cacheMasterData, recordId, resultMap, authViewBean, needHtml, needDealSysRelation);
                        } else {
                            //如果传递了行号，则只就算行号那行，否则计算全部行
                            if (recordId != null && recordId.longValue() != -1l && recordId.longValue() != 0l) {
                                if (isPreRow(tempFormField)) {
                                    List<FormDataSubBean> subDataBeans = cacheMasterData.getSubData(tempFormField.getOwnerTableName());
                                    //if (subDataBeans.size() > 1) {
                                    //OA-99574重复表上一行函数设置为累加，只有一行时计算结果字段没有刷新 去掉只有一行时不计算的判断
                                    for (int i = 0; i < subDataBeans.size(); i++) {
                                        FormDataSubBean subData = subDataBeans.get(i);
                                        calc(form, tempFormField, cacheMasterData, subData.getId(), resultMap, authViewBean, needHtml, needDealSysRelation);
                                    }
                                    //}
                                } else {
                                    calc(form, tempFormField, cacheMasterData, recordId, resultMap, authViewBean, needHtml, needDealSysRelation);
                                }
                            } else {
                                List<FormDataSubBean> subDataBeans = cacheMasterData.getSubData(tempFormField.getOwnerTableName());
                                if (subDataBeans != null) {
                                    for (FormDataSubBean subDataBean : subDataBeans) {
                                        calc(form, tempFormField, cacheMasterData, subDataBean.getId(), resultMap, authViewBean, needHtml, needDealSysRelation);
                                    }
                                }
                            }
                        }
                    }
                }
                /*if (isPreRow(tempFormField)) {
                    List<FormDataSubBean> subDataBeans = cacheMasterData.getSubData(tempFormField.getOwnerTableName());
                    if (subDataBeans.size() > 1) {
                        for (int i=0;i<subDataBeans.size();i++) {
                            FormDataSubBean subData = subDataBeans.get(i);
                            calc(form, tempFormField, cacheMasterData, subData.getId(), resultMap, authViewBean, needHtml, needDealSysRelation);
                        }
                    }
                }*/
            }
            if (formFieldBean.isInCondition()) {
                if (authViewBean != null && resultMap != null && needHtml) {
                    if (needDealSysRelation) {
                        Map<String, Object> tempResult = dealSysRelation(form, cacheMasterData, formFieldBean, authViewBean, recordId, false, null, needHtml);
                        List<DataContainer> tempResultDc = (List<DataContainer>) tempResult.get("datas");
                        List<DataContainer> resultDc = (List<DataContainer>) resultMap.get("datas");
                        if (resultDc == null || resultDc.size() <= 0) {
                            resultMap.putAll(tempResult);
                        } else {
                            if (tempResultDc != null && tempResultDc.size() > 0) {
                                for (DataContainer d1 : tempResultDc) {
                                    boolean hasInTag = false;
                                    for (DataContainer d : resultDc) {
                                        if (String.valueOf(d.get("recordId")).equalsIgnoreCase(String.valueOf(d1.get("recordId")))) {
                                            d.putAll(d1);
                                            hasInTag = true;
                                            break;
                                        }
                                    }
                                    if (!hasInTag) {
                                        resultDc.add(d1);
                                    }
                                }
                                Object o = tempResult.remove("datas");
                                resultMap.putAll(tempResult);
                                tempResult.put("datas", o);
                            } else {
                                resultMap.putAll(tempResult);
                            }
                        }
                    }
                    resultMap.putAll(dealFormRightChangeResult(form, authViewBean, cacheMasterData));
                } else {
                    if (needDealSysRelation) {
                        dealSysRelation(form, cacheMasterData, formFieldBean, authViewBean, recordId, false, null, needHtml);
                    }
                }
            }
        } catch (StackOverflowError e) {
            LOGGER.error(e.getMessage(), e);
            throw new BusinessException(ResourceUtil.getString("form.data.formula.calc.error.label"));
        }
    }

    @Override
    public Map<String, Object> calcAll(FormBean form, FormDataMasterBean masterData, FormAuthViewBean auth, boolean needHtml, boolean needCalSN, boolean needDealSysRelation) throws BusinessException {
        FormCalcParamVO paramVO = new FormCalcParamVO();
        paramVO.setFormBean(form);
        paramVO.setMasterBean(masterData);
        paramVO.setAuthViewBean(auth);
        paramVO.setNeedHtml(needHtml);
        paramVO.setNeedCalSN(needCalSN);
        paramVO.setNeedDealSysRelation(needDealSysRelation);
        return calcAll(paramVO);
    }

    /**
     * 表单全字段计算，将表单中有运算公式的单元格都计算一遍
     *
     * @param form                FormFieldBean表单定义
     * @param masterData          表单数据
     * @param needHtml            是否需要返回单元格html的map
     * @param needCalSN           是否需要计算流水号
     * @param needDealSysRelation 是否需要刷新系统条件类型的关联表单
     * @throws BusinessException
     */
    @Override
    public Map<String, Object> calcAll(final FormCalcParamVO paramVO) throws BusinessException {
        Long start = System.currentTimeMillis();
        Map<String, Object> resultMap = new HashMap<String, Object>();
        FormBean form = paramVO.getFormBean();
        FormDataMasterBean masterData = paramVO.getMasterBean();
        FormAuthViewBean auth = paramVO.getAuthViewBean();
        boolean needHtml = paramVO.isNeedHtml();
        boolean needDealSysRelation = paramVO.isNeedDealSysRelation();
        masterData.putExtraAttr("calcAll", "calcAll");
        AppContext.putThreadContext("isCalc", true);
        try {
            FormTableBean masterTable = masterData.getFormTable();
            //循环主表
            List<FormFieldBean> tableFields = masterTable.getFields();
            for (FormFieldBean masterField : tableFields) {
                //处理图片枚举
                this.dealImageEnum4calc(masterField, masterData, masterData);
                List<FormConditionActionBean> conditionList = masterField.getFormConditionList();
                boolean hasCalc = false;
                if (Strings.isNotEmpty(conditionList)) {
                    //如果是需要计算流水号并且流水号字段为空的时候才计算流水号
                    FormCalcParamVO tempVO = paramVO.clone();
                    tempVO.setFormFieldBean(masterField);
                    tempVO.setRecordId(0L);
                    tempVO.setResultMap(resultMap);
                    calc(tempVO);
                    hasCalc = true;
                }
                if ((!hasCalc) && masterField.isInCondition()) {
                    if (needHtml) {
                        if (needDealSysRelation) {
                            resultMap.putAll(dealSysRelation(form, masterData, masterField, auth, 0l, paramVO.isNeedAttr(), paramVO.getModuleId(), needHtml));
                        }
                        resultMap.putAll(dealFormRightChangeResult(form, auth, masterData));
                    } else {
                        if (needDealSysRelation) {
                            dealSysRelation(form, masterData, masterField, auth, 0l, paramVO.isNeedAttr(), paramVO.getModuleId(), needHtml);
                        }
                    }
                }
            }
            //循环子表
            Map<String, List<FormDataSubBean>> subDataMap = masterData.getSubTables();
            for (Entry<String, List<FormDataSubBean>> subEntry : subDataMap.entrySet()) {//循环所有子表
                tableFields = null;
                //OA-122304 A1为系统关联表单；B1为关联条件；满足条件刷新C1、D1的值 通过导入数据；没有任何反应
                //这里因为下面系统关联可能带出多条来，改变了缓存里面重复表行数，导致抛出ConcurrentModificationException异常
                List<FormDataSubBean> temp = new ArrayList<FormDataSubBean>();
                temp.addAll(subEntry.getValue());
                for (FormDataSubBean dataSubBean : temp) {//循环每张子表的所有数据
                    if (Strings.isEmpty(tableFields)) {
                        tableFields = dataSubBean.getFormTable().getFields();
                    }
                    for (FormFieldBean subField : tableFields) {//循环每张子表每行数据的所有字段
                        //处理图片枚举
                        this.dealImageEnum4calc(subField, dataSubBean, masterData);
                        List<FormConditionActionBean> conditionList = subField.getFormConditionList();
                        boolean hasCalc = false;
                        if (Strings.isNotEmpty(conditionList)) {
                            FormCalcParamVO tempVO = paramVO.clone();
                            tempVO.setFormFieldBean(subField);
                            tempVO.setRecordId(dataSubBean.getId());
                            tempVO.setResultMap(resultMap);
                            calc(tempVO);
                            hasCalc = true;
                        }
                        if ((!hasCalc) && subField.isInCondition()) {
                            if (needHtml) {
                                if (needDealSysRelation) {
                                    if (resultMap != null) {
                                        AppContext.putThreadContext("resultDatas", resultMap.get("datas"));
                                    }
                                    resultMap.putAll(dealSysRelation(form, masterData, subField, auth, dataSubBean.getId(), paramVO.isNeedAttr(), paramVO.getModuleId(), needHtml));
                                }
                                resultMap.putAll(dealFormRightChangeResult(form, auth, masterData));
                            } else {
                                if (needDealSysRelation) {
                                    dealSysRelation(form, masterData, subField, auth, dataSubBean.getId(), paramVO.isNeedAttr(), paramVO.getModuleId(), needHtml);
                                }
                            }
                        }
                    }
                }
            }
            //计算完全成功之后清除公式计算次数的线程级参数
            AppContext.removeThreadContext(FormConstant.calcStack);

            if (paramVO.isCalcSubRelation()) {
                calcAllRelationSubTable(form.getId(), masterData, true, auth, resultMap, needDealSysRelation);
            }
        } catch (StackOverflowError e) {
            LOGGER.error(e.getMessage(), e);
            throw new BusinessException(ResourceUtil.getString("form.data.formula.calc.error.label"));
        } catch (CloneNotSupportedException e) {
            LOGGER.error("刷新计算时，clone属性异常！", e);
            throw new BusinessException(ResourceUtil.getString("form.data.formula.calc.error.label2"));
        } catch (ConcurrentModificationException e) {
            LOGGER.error("刷新计算时异常，表单可能存在多个重复表系统关联且关联条件不能确定唯一的记录，请检查表单设置！", e);
            throw new BusinessException(ResourceUtil.getString("form.data.formula.calc.error.label3"));
        } catch (Exception e) {
            LOGGER.error("刷新计算时异常！"+e.getMessage(), e);
            throw new BusinessException(e.getMessage());
        }
        masterData.getExtraMap().remove("calcAll");
        masterData.getExtraMap().remove("formRelationGroups");
        AppContext.removeThreadContext("isCalc");
        Long end = System.currentTimeMillis();
        LOGGER.info("计算全部花费时间：" + (end - start) + " formId:" + form.getId() + " dataId:" + masterData.getId());
        return resultMap;
    }

    /**
     * 刷新时设置 了数据关联时处理图片枚举
     *
     * @param fieldBean
     * @param dataBean
     * @throws BusinessException
     */
    private void dealImageEnum4calc(FormFieldBean fieldBean, FormDataBean dataBean, FormDataMasterBean masterBean) throws BusinessException {
        //是否数据关联的图片枚举
        FormRelation relation = fieldBean.getFormRelation();
        if (relation != null) {
            boolean isDataRelImge = relation.isDataRelationImageEnum();
            if (isDataRelImge) {
                FormFieldBean rlbean = relation.findToFieldBean();
                Object obj = dataBean.getFieldValue(rlbean.getName());
                if (rlbean.isMasterField()) {
                    obj = masterBean.getFieldValue(rlbean.getName());
                }
                dataBean.addFieldValue(fieldBean.getName(), obj);
            }
        }
    }

    private Object getEnumValue(FormFieldBean bean, Object value) throws BusinessException {
        if (bean.getEnumId() != 0l && !StringUtil.checkNull(String.valueOf(value))) {
            EnumManager manager = (EnumManager) AppContext.getBean("enumManagerNew");
            CtpEnumItem item = manager.getCtpEnumItem(Long.valueOf(value.toString()));
            if (item != null) {
                return item.getEnumvalue();
            }
        }
        return value;
    }

    @Override
    public Map<String, Object> dealSysRelation(FormBean fromFormBean, FormDataMasterBean formcacheMasterData, FormFieldBean fieldBean, FormAuthViewBean currentOperation, Long recordId) throws BusinessException {
        return dealSysRelation(fromFormBean, formcacheMasterData, fieldBean, currentOperation, recordId, false, null, true);
    }

    /**
     * 系统自动条件选择类型关联表单
     * 说明：当单元格参与了系统条件判断，则当光标离开控件之后会将当前单元格的值传递到此方法
     * 方法负责找到当前单元格所参与的系统自动条件类型的关联表单进行条件判断查询，如果符合条
     * 件，则根据设置找到关联的值返回回填页面。
     *
     * @param fromFormBean
     * @param formcacheMasterData
     * @param fieldBean
     * @param currentOperation
     * @param recordId
     * @return
     * @throws BusinessException
     */
    @Override
    public Map<String, Object> dealSysRelation(FormBean fromFormBean, FormDataMasterBean formcacheMasterData,
                FormFieldBean fieldBean, FormAuthViewBean currentOperation, Long recordId, boolean refreshAttr, Long moduleId, boolean needHtml)
        throws BusinessException {
            Long oldRecordId = recordId;
        Map<String, Object> resultMap = new HashMap<String, Object>();
        String[] selectedFields = new String[]{"id"};
        /* 系统自动条件选择类型关联表单
        * 说明：当单元格参与了系统条件判断，则当光标离开控件之后会将当前单元格的值传递到此方法
        * 方法负责找到当前单元格所参与的系统自动条件类型的关联表单进行条件判断查询，如果符合条
        * 件，则根据设置找到关联的值返回回填页面。
        */
        List<FormFieldBean> list = null;
        if (AppContext.getThreadContext("relationFields") != null) {
            list = (List<FormFieldBean>) AppContext.getThreadContext("relationFields");
        } else {
            list = new ArrayList<FormFieldBean>();
            List<FormFieldBean> allFields = fromFormBean.getAllFieldBeans();
            for (FormFieldBean tempfieldBean : allFields) {
                //表单关联条件
                FormRelation tempRelation = tempfieldBean.getFormRelation();
                if (tempRelation != null
                        && (tempRelation.getToRelationAttrType() != null && tempRelation.getToRelationAttrType()
                        .intValue() == ToRelationAttrType.form_relation_field.getKey())
                        && (tempRelation.getViewSelectType() != null && ViewSelectType.system.getKey() == tempRelation
                        .getViewSelectType().intValue())) {
                    list.add(tempfieldBean);
                }
            }
            AppContext.putThreadContext("relationFields", list);
        }
        String cacheKey = "relation_formula_cache";
        Map<Long, Map<Long, FormFormulaBean>> formulaCache = (Map<Long, Map<Long, FormFormulaBean>>) AppContext.getThreadContext(cacheKey);
        if (formulaCache == null) {
            formulaCache = new HashMap<Long, Map<Long, FormFormulaBean>>();
            AppContext.putThreadContext(cacheKey, formulaCache);
        }
        Map<Long, FormFormulaBean> formCache = formulaCache.get(fromFormBean.getId());
        if (formCache == null) {
            formCache = new HashMap<Long, FormFormulaBean>();
            formulaCache.put(fromFormBean.getId(), formCache);
        }
        for (FormFieldBean tempField : list) {
            if (tempField.getName().equals(fieldBean.getName())) {
                continue;
            }
            if ("calcAll".equals(String.valueOf(formcacheMasterData.getExtraAttr("calcAll")))) {//调用的calcAll接口进行的系统关联
                Map<FormFieldBean, List<FormFieldBean>> groups = null;
                Map<String, FormRelationRecord> record = formcacheMasterData.getFormRelationRecordMap();
                if (record != null && ((record.get(formcacheMasterData.getId() + "_" + tempField.getName() + "_" + recordId) != null) || (recordId == 0l && tempField.isSubField()))) {
                    if (formcacheMasterData.getExtraAttr("formRelationGroups") != null) {
                        groups = (HashMap<FormFieldBean, List<FormFieldBean>>) formcacheMasterData.getExtraAttr("formRelationGroups");
                        if (groups.get(tempField) != null) {
                            continue;
                        }
                    }
                }
            }
            FormRelation relation = tempField.getFormRelation();
            long tempRelationConditionId = relation.getViewConditionId();

            FormFormulaBean conditionFormulaBean = formCache.get(tempRelationConditionId);
            if (conditionFormulaBean == null) {
                conditionFormulaBean = formCacheManager.loadFormFormulaBean(fromFormBean, tempRelationConditionId);
                formCache.put(tempRelationConditionId, conditionFormulaBean);
            }
            if (formCacheManager.isEnabled(relation.getToRelationObj()) && conditionFormulaBean != null && conditionFormulaBean.isInThisFormula(fieldBean.getOwnerTableName().substring(fieldBean.getOwnerTableName().indexOf("_") + 1) + "." + fieldBean.getName())) {
                //先获取toFormBean
                String conditionStr = conditionFormulaBean.getExecuteFormulaForSQL();
                String conditionCopyStr = new String(conditionStr);//用来定位条件字段的顺序
                FormBean toFormBean = formCacheManager.getForm(relation.getToRelationObj());
                List<String> fromTableShortName = fromFormBean.getAllTableShortName();
                List<String> toTableShortName = toFormBean.getAllTableShortName();
                FormTableBean toFormTableBean = null;
                FormTableBean subTable = null;
                List<Object> conditionPum = new ArrayList<Object>();
                List<Object> conditionPum4enum = new ArrayList<Object>();
                Map<Integer, Object> conditionPam = new LinkedHashMap<Integer, Object>();
                Map<Integer, Object> conditionPam4enum = new LinkedHashMap<Integer, Object>();
                //key tableName,value 该表中参与条件的字段名字 
                Map<String, List<String>> subConditionFieldNames = new HashMap<String, List<String>>();
                for (String fromTableName : fromTableShortName) {
                    String formTableNum = fromTableName.replace(FormBean.M_PREFIX, "");
                    FormTableBean fromTableBean = fromFormBean.getFormTableBeanByNumber(formTableNum);
                    if (fromTableBean == null) {
                        continue;
                    } else {
                        conditionCopyStr = conditionCopyStr.replace(fromTableName, fromTableBean.getTableName());
                    }
                }
                //替换FromFormBean中的值
                for (String fromTableName : fromTableShortName) {
                    String formTableNum = fromTableName.replace(FormBean.M_PREFIX, "");
                    FormTableBean fromTableBean = fromFormBean.getFormTableBeanByNumber(formTableNum);
                    if (fromTableBean == null) {
                        continue;
                    } else {
                        conditionStr = conditionStr.replace(fromTableName, fromTableBean.getTableName());
                    }
                    fromTableName = fromTableBean.getTableName();
                    while (conditionStr.indexOf(fromTableName) != -1) {
                        int tempFormFieldNameIndex = conditionStr.indexOf(fromTableName) + fromTableName.length() + 1;
                        String tempFieldName = conditionStr.substring(tempFormFieldNameIndex, tempFormFieldNameIndex + 9);
                        String s = conditionStr.substring(conditionStr.indexOf(fromTableName), conditionStr.indexOf(fromTableName) + 1 + fromTableName.length() + 9);
                        int i = conditionCopyStr.indexOf(s);
                        conditionStr = conditionStr.replaceFirst(s, "?");
                        FormFieldBean tempFieldBean = fromFormBean.getFieldBeanByName(tempFieldName);
                        if (tempFieldBean.isMasterField()) {
                            if (tempFieldBean.getFieldType().equalsIgnoreCase(FieldType.DECIMAL.getKey()) && formcacheMasterData.getFieldValue(tempFieldName) == null) {
                                conditionPam.put(i, null);
                                conditionPam4enum.put(i, null);
                            } else {
                                Object o = tempFieldBean.getFormulaValue(formcacheMasterData.getFieldValue(tempFieldName), FormulaEnums.componentType_condition);
                                if (String.valueOf(o).equalsIgnoreCase(FormConstant.double_min_value)) {
                                    o = null;
                                }
                                conditionPam.put(i, o);
                                conditionPam4enum.put(i, this.getEnumValue(tempFieldBean, o));
                            }
                            if ("calcAll".equals(String.valueOf(formcacheMasterData.getExtraAttr("calcAll")))) {//调用的calcAll接口进行的系统关联
                                Map<FormFieldBean, List<FormFieldBean>> groups = null;
                                if (formcacheMasterData.getExtraAttr("formRelationGroups") != null) {
                                    groups = (HashMap<FormFieldBean, List<FormFieldBean>>) formcacheMasterData.getExtraAttr("formRelationGroups");
                                } else {
                                    groups = new HashMap<FormFieldBean, List<FormFieldBean>>();
                                    formcacheMasterData.getExtraMap().put("formRelationGroups", groups);
                                }
                                List<FormFieldBean> g = groups.get(tempField);
                                if (g == null) {
                                    g = new ArrayList<FormFieldBean>();
                                    groups.put(tempField, g);
                                }
                                if (!g.contains(tempFieldBean)) {
                                    g.add(tempFieldBean);
                                }
                            }
                        } else {
                            Map<String, Object> sbm = formcacheMasterData.getSubDataMapById(tempFieldBean.getOwnerTableName(), recordId);
                            if (sbm == null || sbm.isEmpty()) {
                                List<String> conditionFields = subConditionFieldNames.get(tempFieldBean.getOwnerTableName());
                                if (conditionFields == null) {
                                    conditionFields = new ArrayList<String>();
                                    subConditionFieldNames.put(tempFieldBean.getOwnerTableName(), conditionFields);
                                }
                                int pos = conditionPam.size();
                                Object o = tempFieldBean.getFormulaValue(null, FormulaEnums.componentType_condition);
                                if (String.valueOf(o).equalsIgnoreCase(FormConstant.double_min_value)) {
                                    o = null;
                                }
                                conditionPam.put(i, o);
                                conditionPam4enum.put(i, this.getEnumValue(tempFieldBean, o));
                                conditionFields.add(i + FormConstant.DOWNLINE + tempFieldBean.getName());
                            } else {
                                if (tempFieldBean.getFieldType().equalsIgnoreCase(FieldType.DECIMAL.getKey()) && sbm.get(tempFieldName) == null) {
                                    conditionPam.put(i, null);
                                    conditionPam4enum.put(i, null);
                                } else {
                                    Object o = tempFieldBean.getFormulaValue(sbm.get(tempFieldName), FormulaEnums.componentType_condition);
                                    if (String.valueOf(o).equalsIgnoreCase(FormConstant.double_min_value)) {
                                        o = null;
                                    }
                                    conditionPam.put(i, o);
                                    conditionPam4enum.put(i, this.getEnumValue(tempFieldBean, o));
                                }
                            }
                        }
                    }
                }
                for (String toTableName : toTableShortName) {
                    String toTableNum = toTableName.replace(FormBean.R_PREFIX, "");
                    toFormTableBean = toFormBean.getFormTableBeanByNumber(toTableNum);
                    if (toFormTableBean == null) {
                        continue;
                    } else {
                        if (!toFormTableBean.isMainTable() && conditionStr.indexOf(toTableName) != -1) {
                            subTable = toFormTableBean;
                            break;
                        } else {
                            continue;
                        }
                    }
                }
                //重复表中全是数据关联并且关联条件全是主表字段，此时subTable通过以上条件是获取不到的
                if (subTable == null) {
                    List<FormRelation> relationList = formRelationManager.getFormRelations(tempField, fromFormBean);
                    boolean isAllFromSubTable = true;
                    String tSubName = "";
                    for (FormRelation r : relationList) {
                        if (r.getFromRelationAttr().equalsIgnoreCase(tempField.getName())) {
                            continue;
                        }
                        if (r.getToRelationObj().longValue() == toFormBean.getId().longValue()) {
                            if (!toFormBean.getFieldBeanByName(r.getViewAttr()).isSubField()) {
                                isAllFromSubTable = false;
                                break;
                            } else {
                                if ("".equals(tSubName)) {
                                    tSubName = toFormBean.getFieldBeanByName(r.getViewAttr()).getOwnerTableName();
                                } else {
                                    if (tSubName.equalsIgnoreCase(toFormBean.getFieldBeanByName(r.getViewAttr()).getOwnerTableName())) {
                                        tSubName = toFormBean.getFieldBeanByName(r.getViewAttr()).getOwnerTableName();
                                    } else {
                                        isAllFromSubTable = false;
                                        break;
                                    }
                                }
                            }

                        }
                    }
                    if (isAllFromSubTable) {
                        subTable = toFormBean.getTableByTableName(tSubName);
                    }
                }
                if (subConditionFieldNames != null && subConditionFieldNames.size() == 1) {
                    Iterator<String> tableKeyIt = subConditionFieldNames.keySet().iterator();
                    while (tableKeyIt.hasNext()) {
                        String tName = tableKeyIt.next();
                        List<String> posAndSubFieldNames = subConditionFieldNames.get(tName);
                        List<FormDataSubBean> rows = formcacheMasterData.getSubData(tName);
                        if (rows == null) {
                            continue;
                        }
                        rows = new ArrayList<FormDataSubBean>(rows);
                        for (FormDataSubBean subDataBean : rows) {
                            for (String posAndSubFieldName : posAndSubFieldNames) {
                                String[] posAndFieldNameStrs = posAndSubFieldName.split(FormConstant.DOWNLINE);
                                int pos = Integer.parseInt(posAndFieldNameStrs[0]);
                                String subFieldName = posAndFieldNameStrs[1];
                                FormFieldBean f = subDataBean.getFormTable().getFieldBeanByName(subFieldName);
                                if (f.getFieldType().equalsIgnoreCase(FieldType.DECIMAL.getKey()) && subDataBean.getFieldValue(subFieldName) == null) {
                                    conditionPam.put(pos, null);
                                    conditionPam4enum.put(pos, null);
                                } else {
                                    Object o = f.getFormulaValue(subDataBean.getFieldValue(subFieldName), FormulaEnums.componentType_condition);
                                    if (String.valueOf(o).equalsIgnoreCase(FormConstant.double_min_value)) {
                                        o = null;
                                    }
                                    conditionPam.put(pos, o);
                                    conditionPam4enum.put(pos, o);
                                }
                            }
                            List indexList = Arrays.asList(conditionPam.keySet().toArray());
                            Collections.sort(indexList);
                            for (Object i : indexList) {
                                Object o = conditionPam.get(i);
                                if (String.valueOf(o).equals(FormConstant.double_min_value)) {
                                    conditionPum.add(null);
                                } else {
                                    conditionPum.add(o);
                                }

                                o = conditionPam4enum.get(i);
                                if (String.valueOf(o).equals(FormConstant.double_min_value)) {
                                    conditionPum4enum.add(null);
                                } else {
                                    conditionPum4enum.add(o);
                                }
                            }
                            /*OA-91722	关联表单枚举字段，系统选择，前端满足关联条件后自动读取关联数据；修改关联条件不满足后，没有清空关联数据。*/
                            if (conditionPum.size()>1&&isAllNull(conditionPum)) {
                            	conditionPum.clear();
                                conditionPum4enum.clear();
                                continue;
                            }
                            //查询数据库判断是否有满足条件的记录，如果有，则取回并回填
                            List<Map> m = new ArrayList<Map>();
                            try {
                                LOGGER.info("数据ID:" + formcacheMasterData.getId() + "字段：" + fieldBean.getDisplay() + " " + fieldBean.getName() + " 引发字段：" + " " + tempField.getDisplay() + " " + tempField.getName() + "关联查询");
                                m = formDataDAO.selectFormDataByTableBean(toFormBean.getMasterTableBean(), subTable, selectedFields, conditionStr, conditionPum);
                                if (Strings.isEmpty(m)) {
                                    m = formDataDAO.selectFormDataByTableBean(toFormBean.getMasterTableBean(), subTable, selectedFields, conditionStr, conditionPum4enum);
                                }
                                LOGGER.info("查询结果：" + m.size());
                            } catch (Exception e) {
                                LOGGER.info("=================================查询报错====================================");
                            }

                            conditionPum.clear();
                            conditionPum4enum.clear();
                            recordId = subDataBean.getId();
                            AppContext.putThreadContext("isTriggerFromSubLine", "true");
                            Map<String, Object> tempRet = transFormRelationParam(m, fromFormBean.getId(), toFormBean.getId(), formcacheMasterData, subTable, tempField, currentOperation, recordId, refreshAttr, moduleId, needHtml);
                            AppContext.removeThreadContext("isTriggerFromSubLine");
                            List<DataContainer> d = (List<DataContainer>) tempRet.remove("datas");
                            if (d != null) {
                                List<DataContainer> data = (List<DataContainer>) resultMap.get("datas");
                                List<DataContainer> removeData = new ArrayList<DataContainer>();
                                if (data == null) {
                                    data = d;
                                } else {
                                    for (DataContainer d1 : d) {
                                        for (DataContainer d2 : data) {
                                            Object r = d1.get("recordId");
                                            if (r != null && r.equals(d2.get("recordId"))) {
                                                removeData.add(d2);
                                                break;
                                            }
                                        }
                                    }
                                    data.removeAll(removeData);//同样record的出现多次 导致data中出现很多同样record的对象导致内存溢出
                                    data.addAll(d);
                                }
                                resultMap.put("datas", data);
                            }
                            resultMap.putAll(tempRet);
                        }
                    }
                } else if (subConditionFieldNames != null && subConditionFieldNames.size() > 1) {
                    throw new BusinessException("不支持子表混合条件的系统关联。");
                } else {
                    //查询数据库判断是否有满足条件的记录，如果有，则取回并回填
                    List indexList = Arrays.asList(conditionPam.keySet().toArray());
                    Collections.sort(indexList);
                    for (Object i : indexList) {
                        Object o = conditionPam.get(i);
                        if (String.valueOf(o).equals(FormConstant.double_min_value)) {
                            conditionPum.add(null);
                        } else {
                            conditionPum.add(o);
                        }

                        o = conditionPam4enum.get(i);
                        if (String.valueOf(o).equals(FormConstant.double_min_value)) {
                            conditionPum4enum.add(null);
                        } else {
                            conditionPum4enum.add(o);
                        }
                    }
                    /*OA-91722	关联表单枚举字段，系统选择，前端满足关联条件后自动读取关联数据；修改关联条件不满足后，没有清空关联数据。*/
                    if (conditionPum.size()>1&&isAllNull(conditionPum)) {
                    	conditionPum.clear();
                        conditionPum4enum.clear();
                        continue;
                    }
                    //OA-87002  表单系统关联，当底表作为关联条件的字段的字段类型或录入类型改变后，前端关联时提示查询报错。
                    List<Map> m = new ArrayList<Map>();
                    try {
                        LOGGER.info("数据ID:" + formcacheMasterData.getId() + "字段：" + fieldBean.getDisplay() + " " + fieldBean.getName() + " 引发字段：" + " " + tempField.getDisplay() + " " + tempField.getName() + "关联查询");
                        m = formDataDAO.selectFormDataByTableBean(toFormBean.getMasterTableBean(), subTable, selectedFields, conditionStr, conditionPum);
                        if (Strings.isEmpty(m)) {
                            m = formDataDAO.selectFormDataByTableBean(toFormBean.getMasterTableBean(), subTable, selectedFields, conditionStr, conditionPum4enum);
                        }
                        LOGGER.info("查询结果：" + m.size());
                    } catch (Exception e) {
                        LOGGER.info("========================查询报错==================");
                    }
                    conditionPum.clear();
                    conditionPum4enum.clear();

                    Map<String, Object> tempRet = transFormRelationParam(m, fromFormBean.getId(), toFormBean.getId(), formcacheMasterData, subTable, tempField, currentOperation, recordId, refreshAttr, moduleId, needHtml);
                    List<DataContainer> d = (List<DataContainer>) tempRet.remove("datas");
                    if (d != null) {
                        List<DataContainer> data = (List<DataContainer>) resultMap.get("datas");
                        List<DataContainer> removeData = new ArrayList<DataContainer>();
                        if (data == null) {
                            data = d;
                        } else {
                            for (DataContainer d1 : d) {
                                for (DataContainer d2 : data) {
                                    Object r = d1.get("recordId");
                                    if (r != null && r.equals(d2.get("recordId"))) {
                                        removeData.add(d2);
                                        break;
                                    }
                                }
                            }
                            data.removeAll(removeData);//同样record的出现多次 导致data中出现很多同样record的对象导致内存溢出
                            data.addAll(d);
                        }
                        resultMap.put("datas", data);
                    }
                    resultMap.putAll(tempRet);
                }
            }
            recordId = oldRecordId;
        }
        return resultMap;
    }

    private boolean isAllNull(List<Object> param) {
        boolean result = true;
        if (param != null && param.size() > 0) {
            for (Object o : param) {
                if (!StringUtil.checkNull(String.valueOf(o))) {
                    result = false;
                    break;
                }
            }
        }
        return result;
    }

    /**
     * 封装的关联处理方法，内部逻辑使用的手动触发关联表单的逻辑
     *
     * @param r
     * @param fromFormId
     * @param toFormId
     * @param formcacheMasterData
     * @param toFormTableBean
     * @param tempField
     * @param currentOperation
     * @param recordId
     * @return
     * @throws BusinessException
     */
    private Map<String, Object> transFormRelationParam(List<Map> m, Long fromFormId, Long toFormId, FormDataMasterBean formcacheMasterData, FormTableBean toFormTableBean, FormFieldBean tempField, FormAuthViewBean currentOperation, Long recordId, boolean refreshAttr, Long moduleId, boolean needHtml) throws BusinessException {


        //去除重复的主表数据id，将重复表数据id合并
        List<Map> r = new ArrayList<Map>();

        if (Strings.isNotEmpty(m)) {

            for (Map mm : m) {
                boolean isIn = false;
                Map inMap = null;
                for (Map rr : r) {
                    if (String.valueOf(rr.get("id")).equalsIgnoreCase(String.valueOf(mm.get("id")))) {
                        isIn = true;
                        inMap = rr;
                        break;
                    }
                }
                if (isIn) {
                    inMap.put("slave_id", inMap.get("slave_id") + "," + mm.get("slave_id"));
                } else {
                    r.add(mm);
                }
            }
        }
        //select id from formmain_9999 whereStr 
        /*
           [{masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]},
            {masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]}]
         */
        Map<String, Object> selectMap = null;
        List<Map<String, Object>> selectArray = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> subData = null;
        List<Object> filterMasterIds = new ArrayList<Object>();
        //这里要支持多条记录返回。所以不能只取默认第一条了。
        if (Strings.isNotEmpty(r)) {
            for (int i = 0; i < r.size(); i++) {
                if (r.get(i).get("id") == null) {
                    continue;
                }
                Map m0 = r.get(i);
                if (filterMasterIds.contains(m0.get("id"))) {
                    //过滤重复的主表id
                    continue;
                } else {
                    filterMasterIds.add(m0.get("id"));
                }
                subData = new ArrayList<Map<String, Object>>();
                selectMap = new HashMap<String, Object>();
                selectMap.put("masterDataId", m0.get("id"));
                if (m0.get("slave_id") != null) {
                    Map<String, Object> subMap = new HashMap<String, Object>();
                    subMap.put("tableName", toFormTableBean.getTableName());
                    String slave_id = String.valueOf(m0.get("slave_id"));
                    if (slave_id.indexOf(",") != -1) {
                        subMap.put("dataIds", Arrays.asList(slave_id.split(",")));
                    } else {
                        subMap.put("dataIds", Arrays.asList(slave_id));
                    }
                    subData.add(subMap);
                }
                selectMap.put("subData", subData);
                selectArray.add(selectMap);
            }
        }
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("fieldName", tempField.getName());
        paramMap.put("rightId", currentOperation != null ? currentOperation.getId() : 0l);
        paramMap.put("recordId", recordId);
        paramMap.put("fromFormId", fromFormId);
        paramMap.put("selectArray", selectArray);
        paramMap.put("toFormId", toFormId);
        paramMap.put("relationType", "sys");
        paramMap.put("needHtml", String.valueOf(needHtml));
        Map<String, Object> tempRet = formRelationManager.transFormRelation4SysType(paramMap, formcacheMasterData, refreshAttr, moduleId);
        return tempRet;
    }

    /**
     * 带条件的权限，条件满足之后处理权限的变更，变更之后的值保存在以字段名字为key，字段html为value的map中
     *
     * @param form            表单bean
     * @param oldAuthViewBean 当前打开表单的权限，用以过滤单元格权限没有修改的就不用做处理，提高性能
     * @param newAuthViewBean 条件满足之后需要转换为的条件
     * @param formDataBean    表单数据
     * @param resultMap       存放替换结果
     * @throws NumberFormatException
     * @throws BusinessException
     */
    @Override
    public Map<String, Object> dealFormRightChangeResult(FormBean form, FormAuthViewBean newAuthViewBean, FormDataMasterBean formDataBean) throws NumberFormatException, BusinessException {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        //判断是否高级的时候还应该加上父权限ID是否为0   OA-109988 表单设置的高级权限【统一设置】，前端没有刷新生效。
        //避免升级6.1后因为缺少AdvanceAuthType，导致高级权限不生效的问题，暂时屏蔽性能优化条件。
//        if (newAuthViewBean == null || (newAuthViewBean.getAdvanceAuthType() == -1 && newAuthViewBean.getParentId() == 0L)) {
        if (newAuthViewBean == null) {
            return resultMap;
        }
        Map<String, FormAuthViewFieldBean> apartAuthMap = null;
        if (formDataBean.getExtraAttr("apartAuthMap") != null) {
            apartAuthMap = (Map<String, FormAuthViewFieldBean>) formDataBean.getExtraAttr("apartAuthMap");
        } else {
            apartAuthMap = new HashMap<String, FormAuthViewFieldBean>();
            formDataBean.getExtraMap().put("apartAuthMap", apartAuthMap);
        }
        Long pid = newAuthViewBean.getParentId();
        FormAuthViewBean originalAuth = null;
        if (pid != null && pid != 0L && !newAuthViewBean.isApartSetAuth()) {
            originalAuth = form.getAuthViewBeanById(pid);
        } else {
            originalAuth = newAuthViewBean;
        }
        if (originalAuth != null) {
            Map<String, Object> formDataMap = formDataBean.getFormulaMap(FormulaEnums.componentType_condition);
            //这里要处理分开设置
            FormAuthViewBean formAuthViewBean = newAuthViewBean.isApartSetAuth() ? originalAuth : originalAuth.getRightFormAuthViewBean(formDataMap);//需要转换的权限;
            //权限发生变化的时候将结果权限放到缓存中
            formDataBean.putExtraAttr(FormConstant.viewRight, formAuthViewBean);
            if ((newAuthViewBean.getId().longValue() != formAuthViewBean.getId().longValue())
                    || formAuthViewBean.isApartSetAuth()) {//高级权限-分开设置，这里需要进入
                //Map<String, Object> masterMap = formDataBean.getRowData();
                //for (Entry<String, Object> masterEntry : masterMap.entrySet()) {
                //    FormFieldBean fieldBean = form.getFieldBeanByName(masterEntry.getKey());
                //    if (fieldBean != null && !fieldBean.isConstantField()) {
                // 改为直接用主表字段类循环，而不是整个行，这样过滤掉固定字段少很多不必要的循环和判断 add by chenxb 2016-09-29
                List<FormFieldBean> fieldBeenList = form.getMasterTableBean().getFields();
                for (FormFieldBean fieldBean : fieldBeenList) {
                    //1、高级权限-统一设置情况
                    if (!newAuthViewBean.isApartSetAuth()) {
                        //获取单元格权限,这里要处理带条件的情况,需要传入数据对象
                        FormAuthViewFieldBean formAuthViewFieldBean = formAuthViewBean.getFormAuthorizationField(fieldBean.getName());
                        FormAuthViewFieldBean oldFormAuthViewFieldBean = newAuthViewBean.getFormAuthorizationField(fieldBean.getName());
                        //判断单元格权限是否发生变化，如果没有发生变化，那就不用调用getHtml方法重新生成单元格html传递到前台重新渲染
                        if ((!oldFormAuthViewFieldBean.getAccess().equalsIgnoreCase(formAuthViewFieldBean.getAccess())) || (oldFormAuthViewFieldBean.isNull() != formAuthViewFieldBean.isNull())) {
                            String htmlValue = FormFieldComEnum.getHTML(form, fieldBean, formAuthViewFieldBean, formDataBean);
                            resultMap.put(fieldBean.getName(), htmlValue);
                        }
                    } else {
                        //2、高级权限-分开设置情况
                        FormAuthViewFieldBean advanceFieldAuthBean = newAuthViewBean.getFormAuthorizationField(fieldBean.getName(), formDataMap);
                        List<FormAuthViewFieldBean> subAuthConditions = newAuthViewBean.getConditionFieldAuthList(fieldBean.getName());
                        FormAuthViewFieldBean oldFormAuthViewFieldBean = apartAuthMap.get(fieldBean.getName());
                        if (oldFormAuthViewFieldBean == null) {
                            oldFormAuthViewFieldBean = newAuthViewBean.getFormAuthorizationField(fieldBean.getName());
                        }
                        if (Strings.isNotEmpty(subAuthConditions)) {
                            if (oldFormAuthViewFieldBean == null) {
                                String htmlValue = FormFieldComEnum.getHTML(form, fieldBean, advanceFieldAuthBean, formDataBean);
                                resultMap.put(fieldBean.getName(), htmlValue);
                                apartAuthMap.put(fieldBean.getName(), advanceFieldAuthBean);
                            } else if ((!oldFormAuthViewFieldBean.getAccess().equalsIgnoreCase(advanceFieldAuthBean.getAccess())) || (oldFormAuthViewFieldBean.isNull() != advanceFieldAuthBean.isNull())) {
                                String htmlValue = FormFieldComEnum.getHTML(form, fieldBean, advanceFieldAuthBean, formDataBean);
                                resultMap.put(fieldBean.getName(), htmlValue);
                                apartAuthMap.put(fieldBean.getName(), advanceFieldAuthBean);
                            }
                        }
                    }
                    //}
                }
                Map<String, Object> newSubdataMap;
                Map<String, List<FormDataSubBean>> subMap = formDataBean.getSubTables();
                for (FormTableBean subTable : form.getSubTableBean()) {
                    List<FormDataSubBean> subDataLine = subMap.get(subTable.getTableName());
                    if (subDataLine != null && subDataLine.size() > 0) {
                        /*if (subDataLine.size() <= 0) {
                            FormDataSubBean tempSubDataBean = new FormDataSubBean(formAuthViewBean, subTable, formDataBean);
                            subDataLine.add(tempSubDataBean);
                        }*/
                        List<FormFieldBean> subFieldList = subTable.getFields();
                        for (FormDataSubBean tempFormDataSubBean : subDataLine) {
                            Map<String, Object> dataMap = tempFormDataSubBean.getFormulaMap(FormulaEnums.componentType_condition);
                            /*Iterator<Entry<String, Object>> it = dataMap.entrySet().iterator();
                            Entry<String, Object> entry = null;
                            while (it.hasNext()) {
                                entry = it.next();
                                FormFieldBean fieldBean = form.getFieldBeanByName(entry.getKey());
                                if (fieldBean != null && !fieldBean.isConstantField()) {*/
                            // 改为直接用主表字段类循环，而不是整个行，这样过滤掉固定字段少很多不必要的循环和判断 add by chenxb 2016-09-29
                            for (FormFieldBean fieldBean : subFieldList) {
                                if (!newAuthViewBean.isApartSetAuth()) {
                                    FormAuthViewFieldBean formAuthViewFieldBean = formAuthViewBean.getFormAuthorizationField(fieldBean.getName());
                                    FormAuthViewFieldBean oldFormAuthViewFieldBean = newAuthViewBean.getFormAuthorizationField(fieldBean.getName());
                                    //判断单元格权限是否发生变化，如果没有发生变化，那就不用调用getHtml方法重新生成单元格html传递到前台重新渲染
                                    if ((!oldFormAuthViewFieldBean.getAccess().equalsIgnoreCase(formAuthViewFieldBean.getAccess())) || (oldFormAuthViewFieldBean.isNull() != formAuthViewFieldBean.isNull())) {
                                        String htmlValue = FormFieldComEnum.getHTML(form, fieldBean, formAuthViewFieldBean, tempFormDataSubBean);
                                        resultMap.put(fieldBean.getName() + FormConstant.DOWNLINE + tempFormDataSubBean.getId(), htmlValue);
                                    }
                                } else {
                                    //2、高级权限-分开设置情况
                                    //这里对map数据对象做一个组装
                                    newSubdataMap = new HashMap<String, Object>();
                                    newSubdataMap.putAll(formDataMap);
                                    newSubdataMap.putAll(dataMap);
                                    FormAuthViewFieldBean advanceFieldAuthBean = newAuthViewBean.getFormAuthorizationField(fieldBean.getName(), newSubdataMap);
                                    List<FormAuthViewFieldBean> subAuthConditions = newAuthViewBean.getConditionFieldAuthList(fieldBean.getName());
                                    String authKey = fieldBean.getName() + "_" + tempFormDataSubBean.getId();
                                    FormAuthViewFieldBean oldFormAuthViewFieldBean = apartAuthMap.get(authKey);
                                    if (Strings.isNotEmpty(subAuthConditions)) {
                                        if (oldFormAuthViewFieldBean == null) {
                                            String htmlValue = FormFieldComEnum.getHTML(form, fieldBean, advanceFieldAuthBean, tempFormDataSubBean);
                                            resultMap.put(fieldBean.getName() + FormConstant.DOWNLINE + tempFormDataSubBean.getId(), htmlValue);
                                            apartAuthMap.put(authKey, advanceFieldAuthBean);
                                        } else if ((!oldFormAuthViewFieldBean.getAccess().equalsIgnoreCase(advanceFieldAuthBean.getAccess())) || (oldFormAuthViewFieldBean.isNull() != advanceFieldAuthBean.isNull())) {
                                            String htmlValue = FormFieldComEnum.getHTML(form, fieldBean, advanceFieldAuthBean, tempFormDataSubBean);
                                            resultMap.put(fieldBean.getName() + FormConstant.DOWNLINE + tempFormDataSubBean.getId(), htmlValue);
                                            apartAuthMap.put(authKey, advanceFieldAuthBean);
                                        }
                                    }
                                }
                                //}
                            }
                        }
                    }
                }
            }
        }
        return resultMap;
    }

    /**
     * 获取添加行的json封装
     *
     * @param form 当前编辑表单
     * @param authViewBean 权限
     * @param cacheMasterData 当前数据对象
     * @param formDataBeans 数据键值对
     * @return Set
     * @throws BusinessException
     */
    @SuppressWarnings("unchecked")
    @Override
    public Set<DataContainer> getSubDataLineContainer(FormBean form, FormAuthViewBean authViewBean,
                                                      FormDataMasterBean cacheMasterData, Set<FormDataSubBean> formDataBeans, Map<String, Object> resultMap) throws BusinessException {
        Set<DataContainer> subDataLines = new LinkedHashSet<DataContainer>();
        if (formDataBeans == null || formDataBeans.isEmpty()) {
            return subDataLines;
        }
        boolean mapIsNotNull = resultMap != null;
        List<FormFieldBean> beans = null;
        FormTableBean formTableBean = null;
        Map<String, Object> formDataMap = cacheMasterData.getFormulaMap(FormulaEnums.componentType_condition);
        Map<String, Object> newDataMap = new HashMap<String, Object>();
        newDataMap.putAll(formDataMap);
        for (FormDataSubBean formDataBean : formDataBeans) {
            if (formDataBean == null) {
                continue;
            }
            Boolean notFillAtt = (Boolean)formDataBean.getExtraMap().remove("notFillBackAtt");
            if(null==notFillAtt){
                notFillAtt = false;
            }
            newDataMap.putAll(formDataBean.getFormulaMap(FormulaEnums.componentType_condition));
            formTableBean = formDataBean.getFormTable();
            if (authViewBean.getParentId() == 0L) {//主权限
                beans = form.getFormView(authViewBean.getFormViewId()).getFieldBeanList(form, formTableBean.getTableName());
            } else {
                beans = form.getFormView(form.getAuthViewBeanById(authViewBean.getParentId()).getFormViewId()).getFieldBeanList(form, formTableBean.getTableName());
            }
            if (beans == null) {
                beans = formTableBean.getFields();
            }
            List<FormRelation> relationGroup = (List<FormRelation>) formDataBean.getExtraMap().remove(FormConstant.RELATIONGROUPSTR);
            List<DataContainer> subDataLine = new ArrayList<DataContainer>();
            if (relationGroup != null) {
                //List<Long> notShowIds = cacheMasterData.getNotShowSubDataIds(formTableBean.getTableName());
                //数据关联回填的行数据， 如果是新增行,需要回填新增行的所有字段数据（必须）
                Object o = AppContext.getThreadContext("onceAddedSubLineIds");
                Set<Long> onceAddedids = null;
                if(o!=null){
                    onceAddedids = (HashSet)o;
                }else{
                    onceAddedids = new HashSet<Long>();
                }
                if(onceAddedids.contains(formDataBean.getId())){//如果包含就说明是新增的行，就需要回填所有字段
                    for (FormFieldBean formFieldBean : beans) {
                        DataContainer tempRecord = new DataContainer();
                        String result = FormFieldComEnum.getHTML(form, formFieldBean,
                                authViewBean.getFormAuthorizationField(formFieldBean.getName(), newDataMap), formDataBean);
                        tempRecord.put("fieldName", formFieldBean.getName());
                        tempRecord.put("value", result);
                        subDataLine.add(tempRecord);
                        if (mapIsNotNull) {
                            resultMap.remove(formFieldBean.getName() + FormConstant.DOWNLINE + formDataBean.getId());
                        }
                    }
                } else {
                    //List<String> hasFillBackFields = new ArrayList<String>();
                    //数据关联回填的行数据，如果是原来行,只回填关联数据部分，行中其他单元格不参与回填,因为如果是重表中的关联表单的话，客户可能在其他单元格已经输入了值，如果全部回填会将客户输入的值清空了
                    for (FormRelation relation : relationGroup) {
                        DataContainer tempRecord = new DataContainer();
                        FormFieldBean fieldBean = formTableBean.getFieldBeanByName(relation.getFromRelationAttr());
                        String result = FormFieldComEnum.getHTML(form, fieldBean,
                                authViewBean.getFormAuthorizationField(fieldBean.getName(), newDataMap), formDataBean);
                        tempRecord.put("fieldName", fieldBean.getName());
                        //hasFillBackFields.add(fieldBean.getName());
                        tempRecord.put("value", result);
                        subDataLine.add(tempRecord);
                        if (mapIsNotNull) {
                            resultMap.put(fieldBean.getName() + FormConstant.DOWNLINE + formDataBean.getId(), result);
                        }
                    }
                }
            } else {//增加删除行，行内的单元格都需要参与回填
                if (!"removed".equals(String.valueOf(formDataBean.getExtraAttr("removed")))) {
                    for (FormFieldBean formFieldBean : beans) {
                        if(notFillAtt&&formFieldBean.isAttachment(true,true)){
                            if(FormUtil.isH5()){
                                //如果是M3，这里如果不调用getHTML，那么就不会回填这个字段，那么前端渲染就会报错
                                //OA-127484  M3-IOS端：重复表删除全部行后，控件丢失
                                FormFieldComEnum.getHTML(form, formFieldBean,authViewBean.getFormAuthorizationField(formFieldBean.getName(), newDataMap), formDataBean);
                            }
                            continue;
                        }
                        DataContainer tempRecord = new DataContainer();
                        String result = FormFieldComEnum.getHTML(form, formFieldBean,
                                authViewBean.getFormAuthorizationField(formFieldBean.getName(), newDataMap), formDataBean);
                        tempRecord.put("fieldName", formFieldBean.getName());
                        tempRecord.put("value", result);
                        subDataLine.add(tempRecord);
                        if (mapIsNotNull) {
                            resultMap.remove(formFieldBean.getName() + FormConstant.DOWNLINE + formDataBean.getId());
                        }
                    }
                }
            }
            DataContainer dataLine = new DataContainer();
            dataLine.put("recordId", formDataBean.getId() + "");
            dataLine.put("data", subDataLine);
            dataLine.put("tableName", formTableBean.getTableName());
            subDataLines.add(dataLine);
        }
        if (beans != null && !beans.isEmpty() && mapIsNotNull) {
            for (FormFieldBean field : beans) {
                if (field.getInputType() != null && field.getInputType().equalsIgnoreCase(FormFieldComEnum.LINE_NUMBER.getKey())) {
                    List<FormDataSubBean> tempSubdatas = cacheMasterData.getSubData(formTableBean.getTableName());
                    for (FormDataSubBean data : tempSubdatas) {
                        newDataMap.putAll(data.getRowData());
                        String result = FormFieldComEnum.getHTML(form, field,
                                authViewBean.getFormAuthorizationField(field.getName(), newDataMap), data);
                        resultMap.put(field.getName() + FormConstant.DOWNLINE + data.getId(), result);
                    }
                }
            }
        }
        if (mapIsNotNull) {
            List<DataContainer> resultDc = (List<DataContainer>) resultMap.get("datas");
            if (resultDc != null) {
                for (DataContainer d1 : resultDc) {
                    for (DataContainer d : subDataLines) {
                        if (String.valueOf(d.get("recordId")).equalsIgnoreCase(String.valueOf(d1.get("recordId")))) {
                            //d.putAll(d1);
                            List<DataContainer> tempData1 = (List<DataContainer>) d.get("data");
                            List<DataContainer> tempData2 = (List<DataContainer>) d1.get("data");
                            if (tempData1 != null && tempData2 != null) {
                                //BUG_普通_V5_V6.0sp1_一星卡_四川红棉投资管理有限责任公司_系统关联带不出数据_20171013045797
                                // 在tempData1中不存的，才从 tempData2中取出并放入tempData1。否则可能数据覆盖，造成数据丢失
                                List<DataContainer> dataList = new ArrayList<DataContainer>();
                                boolean exists = false;
                                for (DataContainer tempData2_ : tempData2) {
                                    exists = false;
                                    for (DataContainer tempData1_ : tempData1) {
                                        if (tempData1_ != null && tempData2_ != null && tempData1_.get("fieldName").equals(tempData2_.get("fieldName"))) {
                                            exists = true;
                                            break;
                                        }
                                    }
                                    if (!exists) {
                                        dataList.add(tempData2_);
                                    }
                                }
                                tempData1.addAll(dataList);
                            }


                            break;
                        }
                    }
                }
            }
        }
        return subDataLines;
    }

    /**
     * 将前台提交的表单数据和后台缓存的表单数据进行增量合并
     *
     * @param masterData
     * @param cacheData
     * @param fb
     * @param Type==>用来判读是新增还是修改,记录日志用
     * @return 日志信息
     */
    @Override
    public void mergeFormData(FormDataMasterBean masterData, FormDataMasterBean cacheData, FormBean fb) {
        Map<String, Object> masterDataMap = masterData.getRowData();
        for (Entry<String, Object> objEntry : masterDataMap.entrySet()) {
            //日志记录
            //判断是否需要记录详细日志
            FormFieldBean ffb = fb.getFieldBeanByName(objEntry.getKey());
            if (ffb != null) {
                //替换主表数据
                cacheData.addFieldValue(objEntry.getKey(), objEntry.getValue());
            }
        }
        Map<String, List<FormDataSubBean>> frontSubDataMapList = masterData.getSubTables();
        Map<String, List<FormDataSubBean>> cacheSubDataMapList = cacheData.getSubTables();
        //用来存储被删除的数据
        Map<String, List<FormDataSubBean>> delMap = null;
        //循环后端数据，将前端提交数据的记录id和缓存中存在的id进行对比，如果前端提交的id在cacheData中已经没有了，则cacheData中删除该id对应的数据
        for (Entry<String, List<FormDataSubBean>> cacheDataEntry : cacheSubDataMapList.entrySet()) {
            String subTableName = cacheDataEntry.getKey();
            List<FormDataSubBean> cacheSubDataList = cacheDataEntry.getValue();

            List<FormDataSubBean> frontSubDataList = frontSubDataMapList.get(subTableName);
            List<Long> cacheNotShowSubDataIds = cacheData.getNotShowSubDataIds(subTableName);
            if (frontSubDataList == null) {
                //前端提交页面视图有可能只有部分子表，所以frontSubDataList有可能是空，如果frontSubDataList为空，则不做处理
                continue;
            }
            boolean hasEqualsData = false;
            for (FormDataSubBean cacheSubLineData : cacheSubDataList) {
                for (FormDataSubBean frontSubLineData : frontSubDataList) {
                    hasEqualsData = (cacheSubLineData.getId().longValue() == frontSubLineData.getId().longValue()) ? true
                            : false;
                    if (hasEqualsData) {
                        break;
                    }
                }
                if (!hasEqualsData) {
                    if (delMap == null) {
                        delMap = new HashMap<String, List<FormDataSubBean>>();
                    }
                    if (delMap.get(subTableName) == null) {
                        delMap.put(subTableName, new ArrayList<FormDataSubBean>());
                    }
                    if (cacheNotShowSubDataIds == null || !cacheNotShowSubDataIds.contains(cacheSubLineData.getId())) {//前端虽然没有提交过来，但是后台缓存的没有显示的id中还有，则不将其删除，不然会导致没有加载的重复表数据丢失
                        delMap.get(subTableName).add(cacheSubLineData);
                    }
                }
            }
        }
        if (delMap != null && delMap.size() > 0) {
            for (Entry<String, List<FormDataSubBean>> delEntry : delMap.entrySet()) {
                for (FormDataSubBean delSubBean : delEntry.getValue()) {
                    cacheSubDataMapList.get(delEntry.getKey()).remove(delSubBean);
                }
            }
        }
        //循环前端数据，将后端缓存没有的则进行添加，如果后端缓存有，则进行值合并
        for (Entry<String, List<FormDataSubBean>> frontDataEntry : frontSubDataMapList.entrySet()) {
            String subTableName = frontDataEntry.getKey();
            List<FormDataSubBean> frontSubDataList = frontDataEntry.getValue();

            List<FormDataSubBean> cacheSubDataList = cacheSubDataMapList.get(subTableName);
            int i = 0;
            for (FormDataSubBean frontSubLineData : frontSubDataList) {
                boolean hasEqualsData = false;
                if (cacheSubDataList == null) {
                    cacheSubDataList = new ArrayList<FormDataSubBean>();
                    cacheSubDataMapList.put(subTableName, cacheSubDataList);
                }
                for (FormDataSubBean cacheSubLineData : cacheSubDataList) {
                    hasEqualsData = (cacheSubLineData.getId().longValue() == frontSubLineData.getId().longValue()) ? true
                            : false;
                    if (hasEqualsData) {
                        Map<String, Object> frontRowDataMap = frontSubLineData.getRowData();
                        for (Entry<String, Object> entry : frontRowDataMap.entrySet()) {
                            cacheSubLineData.addFieldValue(entry.getKey(), entry.getValue());
                        }
                        break;
                    }
                }
                //如果有相等的需要合并数据行
                if (!hasEqualsData) {
                    //如果没有则添加
                    cacheSubDataList.add(i, frontSubLineData);
                }
                i++;
            }

        }
    }

    /**
     * 接收前台提交的表单数据
     *
     * @param form
     * @param formMasterId
     * @param rightId
     * @return
     */
    @Override
    public FormDataMasterBean procFormParam(FormBean form, Long formMasterId, Long rightId) throws BusinessException {
        FormDataMasterBean cacheMasterData = formManager.getSessioMasterDataBean(formMasterId);
        if (cacheMasterData == null) {
            LOGGER.info("数据缓存已经被移除了：id="+formMasterId);
            throw new BusinessException(ResourceUtil.getString("form.cache.data.delete.label"));
        }
        FormAuthViewBean authView = null;
        if (cacheMasterData != null && cacheMasterData.getExtraAttr(FormConstant.viewRight) != null) {
            authView = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
        } else {
            authView = form.getAuthViewBeanById(rightId);
        }
        FormDataMasterBean masterData = null;
        FormTableBean masterTableBean = form.getMasterTableBean();
        Map<String, Object> mainDataMap = null;
        //样式中如果同一个区域中包含一样的id会出现多个分组，取最大集的分组
        List<Map<String, Object>> datas = ParamUtil.getJsonDomainGroup(masterTableBean.getTableName());
        if (datas.size() > 0) {
            mainDataMap = new HashMap<String, Object>();
            for (Map<String, Object> m : datas) {
                mainDataMap.putAll(m);
            }
        } else {
            mainDataMap = ParamUtil.getJsonDomain(masterTableBean.getTableName());//如果是主表直接获取map
        }
        List<FormFieldBean> masterFields = form.getMasterTableBean().getFields();
        Map<String, Object> formDataMap = cacheMasterData.getFormulaMap(FormulaEnums.componentType_condition);
        Map<String, Object> allDataMap = new HashMap<String, Object>();
        allDataMap.putAll(formDataMap);
        allDataMap.putAll(mainDataMap);
        for (FormFieldBean masterField : masterFields) {
            FormAuthViewFieldBean fieldAuth = authView.getFormAuthorizationField(masterField.getName(), allDataMap);
            //高级设置-分开设置-权限也不做处理
            if (fieldAuth == null || authView.isApartSetAuth()) {
                continue;
            }
            //权限既不是编辑又不是追加，则清除前台提交的单元格数据
            if (!fieldAuth.getAccess().equalsIgnoreCase(FieldAccessType.edit.getKey()) && !fieldAuth.getAccess().equalsIgnoreCase(FieldAccessType.add.getKey())) {
                mainDataMap.remove(masterField.getName());
            }
        }
        Map<String, Object> newMainDataMap = new LinkedHashMap<String, Object>();
        newMainDataMap.putAll(mainDataMap);
        masterData = new FormDataMasterBean(newMainDataMap, masterTableBean);
        mainDataMap.put("id", formMasterId);
        masterData.setId(formMasterId);
        List<FormTableBean> tableList = form.getSubTableBean();
        List<FormFieldBean> beans;
        //由于不知道前台提交的表单视图有多少个表格，所以循环该表单下所有表
        for (FormTableBean table : tableList) {
            String tableName = table.getTableName();
            //取出当前视图的字段，不再视图的，沿用后台缓存的数据
            if (authView.getParentId() == 0L) {//主权限
                beans = form.getFormView(authView.getFormViewId()).getFieldBeanList(form, table.getTableName());
            } else {
                beans = form.getFormView(form.getAuthViewBeanById(authView.getParentId()).getFormViewId()).getFieldBeanList(form, table.getTableName());
            }
            //如果是重复项表，分区分组提交
            List<Map<String, Object>> subTableData = ParamUtil.getJsonDomainGroup(tableName);
            for (Map<String, Object> subDataMap : subTableData) {
                Iterator<String> it = subDataMap.keySet().iterator();
                allDataMap.putAll(subDataMap);
                while (it.hasNext()) {
                    String fieldName = it.next();
                    FormAuthViewFieldBean fieldAuth = authView.getFormAuthorizationField(fieldName, allDataMap);
                    //高级权限-分开设置-这里不进行权限判断了，直接附加。
                    if (fieldAuth != null && !authView.isApartSetAuth()) {
                        FormFieldBean ffb = fieldAuth.getFormFieldBean();
                        //要处理重复表列头部分的主表数据
                        if (ffb.isMasterField()) {
                            if (fieldAuth.getAccess().equalsIgnoreCase(FieldAccessType.edit.getKey()) || fieldAuth.getAccess().equalsIgnoreCase(FieldAccessType.add.getKey())) {
                                try {
                                    masterData.addFieldValue(fieldName, ffb.getFrontSubmitData(subDataMap.get(fieldName)));
                                } catch (BusinessException e) {
                                    LOGGER.error(e.getMessage(), e);
                                }
                            }
                            it.remove();
                        } else {
                            if ((!fieldAuth.getAccess().equalsIgnoreCase(FieldAccessType.edit.getKey()) && !fieldAuth.getAccess().equalsIgnoreCase(FieldAccessType.add.getKey())) || !beans.contains(ffb)) {
                                it.remove();
                            }
                        }
                    } else if (fieldAuth != null && authView.isApartSetAuth()) {
                        FormFieldBean ffb = fieldAuth.getFormFieldBean();
                        if (ffb.isMasterField()) {
                            masterData.addFieldValue(fieldName, subDataMap.get(fieldName));
                        }else{
                            //不再视图的，沿用后台缓存的数据
                            if(!beans.contains(ffb)){
                                it.remove();
                            }
                        }
                    }
                }
                Map<String, Object> newSubDataMap = new LinkedHashMap<String, Object>();
                newSubDataMap.putAll(subDataMap);
                newSubDataMap.put(SubTableField.formmain_id.getKey(), formMasterId);
                FormDataSubBean subData = new FormDataSubBean(newSubDataMap, table, masterData);
                masterData.addSubData(tableName, subData);
            }
        }
        return masterData;
    }

    /**
     * 添加删除重复项或者重复节处理函数
     *
     * @param formMasterId 表单主数据id
     * @param formId       表单id
     * @param rightId      当前编辑权限id
     * @param tableName    从表名字
     * @param type         操作类型
     *                     -copy:复制上一行
     *                     -empty:添加一行空行
     *                     -del:删除一行
     * @param recordId     对应于不同type有不同的含义
     *                     -type==copy时,recordId代表被复制的那一行的id
     *                     -type==empty时，recordId代表被复制的那一行的id
     *                     -type==del时，recordId代表被删除的那一行的id
     * @param data         在复制或者添加一行空数据的时候前端传过来的行数据
     * @return
     * @throws NumberFormatException
     * @throws BusinessException
     */
    @Override
    public StringBuffer addOrDelDataSubBean(Long formMasterId, Long formId, Long rightId, String tableName,
                                            String type, Long recordId, Map<String, Object> data) {

        data.put(SubTableField.formmain_id.getKey(), formMasterId);
        data.remove("id");
        List<FormFieldBean> inCalculateFieldList = new ArrayList<FormFieldBean>();
        List<FormFieldBean> inConditionList = new ArrayList<FormFieldBean>();
        FormBean form = formCacheManager.getForm(formId.longValue());
        List<FormViewBean> formViewBeans = form.getFormViewList();
        FormDataMasterBean cacheMasterData = formManager.getSessioMasterDataBean(formMasterId);
        FormAuthViewBean authViewBean = null;
        if (cacheMasterData.getExtraMap().containsKey(FormConstant.viewRight)) {//首先考虑从缓存的FormDataMasterBean中获取权限，因为FormDataMasterBean存放的权限是合并之后的权限
            authViewBean = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
        }
        if (authViewBean == null) {//找不到才从全局缓存中获取
            for (FormViewBean formViewBean : formViewBeans) {
                authViewBean = formViewBean.getAuthorizaton(rightId.longValue());
                if (authViewBean != null) {
                    break;
                }
            }
        }
        FormTableBean formTableBean = form.getTableByTableName(tableName);
        List<FormFieldBean> inlineFields = formTableBean.getFields();
        //获取移动视图不显示的FIELD
        List<FormFieldBean> fieldInView = authViewBean.getViewBean(form,false).getFieldBeanList(form,tableName);
        FormDataSubBean formDataBean = null;
        //增加空行和复制一行需要合并当前行数据到缓存中
        if (!"del".equalsIgnoreCase(type)) {
            FormDataSubBean currentDataSubBean = cacheMasterData.getFormDataSubBeanById(formTableBean.getTableName(), recordId);
            for (FormFieldBean field : inlineFields) {
                //移动视图不显示的BEAN不合并缓存
                if (field != null && !field.isConstantField() && fieldInView.contains(field)) {
                    if (data.get(field.getName()) != null) {
                        try {
                            currentDataSubBean.addFieldValue(field.getName(), field.findRealFieldBean().getFrontSubmitData(data.get(field.getName())));
                        } catch (BusinessException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                    }
                }
            }
        }
        if ("copy".equalsIgnoreCase(type)) {
            formDataBean = new FormDataSubBean(data, formTableBean, cacheMasterData);
            cacheMasterData.addSubData4CopyRow(tableName, formDataBean, recordId);
        } else if ("empty".equalsIgnoreCase(type)) {
            FormDataSubBean tempData = new FormDataSubBean(data, formTableBean, cacheMasterData);
            formDataBean = new FormDataSubBean(authViewBean, formTableBean, cacheMasterData);
            cacheMasterData.addSubData(tableName, formDataBean, recordId);
            for (FormFieldBean tempField : inlineFields) {
                //如果控件是附件、图片、关联文档需要重新设置一个uuid
                if ((tempField != null) && (tempField.getInputType().equals(FormFieldComEnum.EXTEND_ATTACHMENT.getKey())
                        || tempField.getInputType().equals(FormFieldComEnum.EXTEND_DOCUMENT.getKey())
                        || tempField.getInputType().equals(FormFieldComEnum.EXTEND_IMAGE.getKey()))) {
                    formDataBean.addFieldValue(tempField.getName(), "" + UUIDUtil.getUUIDLong());
                } else if ((tempField != null)) {
                    FormRelation relation = tempField.getFormRelation();
                    if (relation != null) {
                        FormFieldBean fieldBean = form.getFieldBeanByName(relation.getToRelationAttr());
                        if (fieldBean != null) {
                            if (relation.isDataRelationMember()) {//关联人员-关联的主表字段，保留值
                                if (fieldBean.isMasterField()) {
                                    formDataBean.addFieldValue(tempField.getName(), tempData.getFieldValue(tempField.getName()));
                                }
                            } else if (relation.isDataRelationImageEnum()) {
                                if (fieldBean.isMasterField()) {
                                    formDataBean.addFieldValue(tempField.getName(), tempData.getFieldValue(tempField.getName()));
                                }
                            } else if (relation.isDataRelationMultiEnum()) {//关联多级枚举时，如果下级枚举只有一个，默认带出
                                try {
                                    formRelationManager.dealEnumRelation(form, cacheMasterData, authViewBean, relation, formDataBean.getId(), null, tempField.getEnumId(), tempField.getEnumLevel(), true);
                                } catch (BusinessException e) {
                                    LOGGER.info("关联多级枚举出现异常" + e);
                                }
                            }
                        }
                    }
                }
            }
        } else if ("del".equalsIgnoreCase(type)) {
            formDataBean = cacheMasterData.removeSubData(tableName, recordId);
        }
        List<FormFieldBean> allFields = form.getAllFieldBeans();
        for (FormFieldBean formFieldBean : allFields) {
            if (formFieldBean != null && !formFieldBean.isConstantField()) {
                //字表行内的相关逻辑处理
                if (formFieldBean.getOwnerTableName().equalsIgnoreCase(formTableBean.getTableName())) {
                    //循环子表中单元格，如果有关联表单控件，需要为该行的该单元格添加关联记录
                    Map<String, FormRelationRecord> relationRecordMap = cacheMasterData.getFormRelationRecordMap();
                    if (relationRecordMap == null) {
                        try {
                            relationRecordMap = formRelationManager.getFormRelationMap(cacheMasterData.getId());
                        } catch (BusinessException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                        cacheMasterData.setFormRelationRecordMap(relationRecordMap);
                    }
                    String recordKey = cacheMasterData.getId() + FormConstant.DOWNLINE + formFieldBean.getName() + FormConstant.DOWNLINE + recordId;
                    FormRelationRecord relationRecord = relationRecordMap.get(recordKey);
                    boolean isAtt = false;
                    try {
                        isAtt = formFieldBean.isAttachment(false, false);
                    } catch (BusinessException e1) {
                        LOGGER.error(e1.getMessage(), e1);
                    }
                    if ("copy".equalsIgnoreCase(type)) {
                        if (relationRecord != null) {
                            FormRelationRecord clonedRecord = null;
                            try {
                                clonedRecord = (FormRelationRecord) relationRecord.clone();
                                clonedRecord.setId(UUIDUtil.getUUIDLong());
                            } catch (CloneNotSupportedException e) {
                                LOGGER.error(e.getMessage(), e);
                            }
                            clonedRecord.setFromSubdataId(formDataBean.getId());
                            relationRecordMap.put(cacheMasterData.getId() + FormConstant.DOWNLINE + formFieldBean.getName()
                                    + FormConstant.DOWNLINE + formDataBean.getId(), clonedRecord);
                        }
                        if (formFieldBean.isRelationAttField() && !isAtt) {
                            formDataBean.addFieldValue(formFieldBean.getName(), null);
                        }
                    } else if ("del".equalsIgnoreCase(type) && formFieldBean.isRelationAttField() && !isAtt) {
                        formRelationManager.dealRelationAttr(cacheMasterData, null, formFieldBean, null, formDataBean.getFieldValue(formFieldBean.getName()), true);
                    }
                    //处理关联人员属性
                    if (!"del".equalsIgnoreCase(type)) {
                        FormRelation relation = formFieldBean.getFormRelation();
                        if (relation != null && (relation.isDataRelationMember() || relation.isDataRelationDepartment() || relation.isDataRelationLbs())) {
                            try {
                                String toAttr = relation.getToRelationAttr();
                                ToRelationAttrType toRelationAttrType = ToRelationAttrType.getEnumByKey(relation.getToRelationAttrType());
                                if (!StringUtil.checkNull(toAttr)) {
                                    FormFieldBean relFieldBean = form.getFieldBeanByName(toAttr);
                                    //增加空行，或复制一行且不为编辑权限时才计算组织关联,否则不计算，值为导入时excel中数据或复制一行时原来行数据
                                    FormBean formBean = formCacheManager.getForm(formId);
                                    FormAuthViewBean favb = formBean.getAuthViewBeanById(rightId);
                                    FormAuthViewFieldBean authViewFieldBean = null;
                                    authViewFieldBean = favb.getFormAuthorizationField(formFieldBean.getName());
                                    if (relFieldBean != null && (!authViewFieldBean.getAccess().equals(FieldAccessType.edit.getKey())
                                            || "empty".equalsIgnoreCase(type))) {
                                        formRelationManager.dealRelationByType(relFieldBean, form, authViewBean, cacheMasterData,
                                                null, formDataBean.getId(), toRelationAttrType, true, true);
                                    }
                                }
                            } catch (BusinessException e) {
                                LOGGER.error(e.getMessage(), e);
                            }
                        }
                    }
                    if (formFieldBean.isInCondition()) {
                        inConditionList.add(formFieldBean);
                    }
                }
                if (formFieldBean.getOwnerTableName().equalsIgnoreCase(formTableBean.getTableName()) || formFieldBean.getOwnerTableName().indexOf("formmain") != -1) {
                    if (formFieldBean.isInCalculate()) {
                        inCalculateFieldList.add(formFieldBean);
                    }
                }
            }
        }
        Map<String, Object> resultMap = new DataContainer();
        DataContainer dc = new DataContainer();
        try {
            List<FormFieldBean> calcResultField = new ArrayList<FormFieldBean>();
            for (FormFieldBean inCalculateField : inCalculateFieldList) {
                //只计算当前行中字段影响的计算
                //if(inCalculateField.getOwnerTableName().equalsIgnoreCase(formTableBean.getTableName())){
                List<FormFieldBean> allFieldBean = form.getAllFieldBeans();
                for (FormFieldBean resultBean : allFieldBean) {
                    if (resultBean.isConstantField()) {
                        continue;
                    }
                    List<FormConditionActionBean> actions = resultBean.getFormConditionList();
                    if (actions != null && actions.size() > 0) {
                        if (FormulaUtil.isFieldExistFormula(actions, inCalculateField.getName())) {
                            if (resultBean.isSubField() && inCalculateField.getInputType() != null && inCalculateField.getInputType().equalsIgnoreCase(FormFieldComEnum.LINE_NUMBER.getKey())) {
                                //如果结果字段是重复表中的字段，需要循环处理所有行
                                List<FormDataSubBean> subDataBeans = cacheMasterData.getSubData(tableName);
                                for (FormDataSubBean subData : subDataBeans) {
                                    calcResultField.add(resultBean);
                                    calc(form, resultBean, cacheMasterData, subData.getId(), resultMap, authViewBean, true, true);
                                }
                            } else {
                                if (isPreRow(resultBean)) {
                                    List<FormDataSubBean> subDataBeans = cacheMasterData.getSubData(tableName);
                                    for (int i = 0; i < subDataBeans.size(); i++) {
                                        FormDataSubBean subData = subDataBeans.get(i);
                                        calcResultField.add(resultBean);
                                        calc(form, resultBean, cacheMasterData, subData.getId(), resultMap, authViewBean, true, true);
                                    }
                                } else {
                                    calcResultField.add(resultBean);
                                    calc(form, resultBean, cacheMasterData, formDataBean.getId(), resultMap, authViewBean, true, (!resultBean.isSubField()));
                                }
                            }
                        }
                    }
                }
                //}
            }
            //如果一个字段公式设置为“=2”，这种情况在增加空行的时候不会计算，因为没有行内单元格参与公式，所以需要单独计算下
            for (FormFieldBean f : inlineFields) {
                if (!calcResultField.contains(f)) {
                    List<FormConditionActionBean> actions = f.getFormConditionList();
                    if (actions != null && actions.size() > 0) {
                        calc(form, f, cacheMasterData, formDataBean.getId(), resultMap, authViewBean, true, true);
                    }
                }
            }
            Set<Long> addSubIds = new HashSet<Long>();
            Set<FormDataSubBean> formDataSubBeans = new HashSet<FormDataSubBean>();
            List<DataContainer> tempList = new ArrayList<DataContainer>();
            for (FormFieldBean inConditionField : inConditionList) {
                //只计算当前行中字段影响的计算
                //OA-87004 重复表中含表单系统关联条件字段，当与被关联底表字段类型或录入类型不一致时，增加重复表操作时报错。inConditionField.getFormConditionList()为null，导致空指针
                if (inConditionField.getOwnerTableName().equalsIgnoreCase(formTableBean.getTableName()) && ((inConditionField.getFormConditionList() != null && inConditionField.getFormConditionList().size() == 0)||inConditionField.getFormConditionList()==null)) {
                    if (!"del".equalsIgnoreCase(type)) {
                        Map<String, Object> tempResult = dealSysRelation(form, cacheMasterData, inConditionField, authViewBean, formDataBean.getId(), false, null, true);
                        List<DataContainer> tempResultDc = (List<DataContainer>) tempResult.remove("datas");
                        List<DataContainer> resultDc = (List<DataContainer>) resultMap.get("datas");
                        if (resultDc == null) {
                            resultDc = new ArrayList<DataContainer>();
                        }
                        if (tempResultDc != null) {
                            for (DataContainer d1 : tempResultDc) {
                                addSubIds.add(Long.parseLong(String.valueOf(d1.get("recordId"))));
                            }
                        }
                        if (resultDc != null && resultDc.size() > 0) {
                            for (DataContainer d2 : resultDc) {
                                addSubIds.add(Long.parseLong(String.valueOf(d2.get("recordId"))));
                            }
                        }
                        resultMap.putAll(tempResult);
                    }
                    resultMap.putAll(dealFormRightChangeResult(form, authViewBean, cacheMasterData));
                }
            }
            addSubIds.add(formDataBean.getId());
            for (Long id : addSubIds) {
                FormDataSubBean subBean = cacheMasterData.getFormDataSubBeanById(tableName, id);
                if (subBean != null) {
                    subBean.getExtraMap().remove(FormConstant.RELATIONGROUPSTR);
                    formDataSubBeans.add(subBean);
                }
            }
            resultMap.remove("datas");
            if ("del".equalsIgnoreCase(type)) {
                cacheMasterData.refreshSort(cacheMasterData.getSubData(tableName));
                for (FormFieldBean field : inlineFields) {
                    if (field.getInputType() != null && field.getInputType().equalsIgnoreCase(FormFieldComEnum.LINE_NUMBER.getKey())) {
                        List<FormDataSubBean> tempSubdatas = cacheMasterData.getSubData(formTableBean.getTableName());
                        for (FormDataSubBean d : tempSubdatas) {
                            String result = FormFieldComEnum.getHTML(form, field, authViewBean.getFormAuthorizationField(field.getName()), d);
                            resultMap.put(field.getName() + FormConstant.DOWNLINE + d.getId(), result);
                        }
                    }
                }
            }
            //bug OA-84965 经过权限处理的所有值都添加到resultMap中
            Map<String, Object> rightDataMap = this.dealFormRightChangeResult(form, authViewBean, cacheMasterData);
            resultMap.putAll(rightDataMap);
            if (cacheMasterData.getExtraMap().containsKey(FormConstant.viewRight)) {
                authViewBean = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
            }
            if (FormUtil.isH5()) {
                AppContext.putThreadContext(FormConstant.REST_FORM_BEAN_INFO, form);
                AppContext.putThreadContext(FormConstant.REST_FORM_RIGHT_INFO, authViewBean);
            }

            Set<DataContainer> s = getSubDataLineContainer(form, authViewBean, cacheMasterData, formDataSubBeans, resultMap);
            if (s != null) {
                tempList.addAll(s);
            }
            dc.add("datas", tempList);
            if (null != cacheMasterData.getExtraAttr(FormConstant.viewRight)) {
                FormAuthViewBean currentAuth = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
                dc.add(FormConstant.viewRight, String.valueOf(currentAuth.getId()));
            }
            dc.put(FormConstant.SUCCESS, "true");
            dc.put(FormConstant.RESULTS, resultMap);

        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            dc.put(FormConstant.SUCCESS, "false");
            //OA-110113无流程表单重复表中设置了循环嵌套公式，前端新建数据时增加重复行，弹出空白提示框。
            dc.put(FormConstant.ERRORMSG, e.getMessage());
        }
        return new StringBuffer(dc.getJson());
    }

    private boolean isPreRow(FormFieldBean resultBean) {
        boolean isPreRow = false;
        List<FormConditionActionBean> fcabs = resultBean.getFormConditionList();
        if (fcabs != null && fcabs.size() > 0) {
            for (FormConditionActionBean fcab : fcabs) {
                if (isPreRow) break;
                List<CtpFormula> cfs = fcab.getAllFormulaList();
                for (CtpFormula cf : cfs) {
                    String expression = cf.getExpression();
                    if (expression != null && expression.replaceAll(" ", "").indexOf(FunctionSymbol.preRow.getKey() + "(") > -1) {// && cf.getExpression().trim().startsWith(FunctionSymbol.preRow.getKey())
                        isPreRow = true;
                        break;
                    }
                }
            }
        }
        return isPreRow;
    }

    /**
     * @param formTemplateId 无流程表单模板ID
     * @return List<CtpContentAll>
     * @throws BusinessException
     */
    @Override
    public boolean delFormData(Long formId, String ids, Long templateId) throws BusinessException, SQLException {
        return this.delFormData(formId, ids, templateId, true);
    }

    /**
     * 业务表单数据的导入
     *
     * @param formId
     * @param formAppAuth
     * @param templeteId
     * @param operationId
     * @param fileId
     * @param rightId
     * @return
     * @throws Exception
     */
    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    public String saveDataFromImportExcel(Long formId, Long templeteId, Long fileId, Long rightId, String repeat,
                                          int unlockAuth, String templeteTitle) {
        StringBuilder logs = new StringBuilder();
        int counts = 0;
        StringBuilder errorMessage = new StringBuilder();
        try {
            FormBean formBean = formCacheManager.getForm(formId);
            FormBindAuthBean bindAuthBean = null;
            if (formBean != null) {
                LOGGER.info("start: " + System.currentTimeMillis());
                bindAuthBean = formBean.getBind().getFormBindAuthBean(templeteId + "");
                if (bindAuthBean == null) {
                    return ResourceUtil.getString("form.masterdatalist.othererror");
                }
                File file = fileManager.getFile(fileId);
                List<List<List<String>>> excelListBySheets = fileToExcelManager.readExcelBySheets(file);
                int tableCount = excelListBySheets.size();
                int[] sheetCount = new int[tableCount];
                for (int i = 0; i < tableCount; i++) {
                    sheetCount[i] = i;
                }
                List<Object> resultList = fileToExcelManager.readExcelAllContentBySheets(file, null, sheetCount);
                List<String> sheetNames = (List<String>) resultList.get(0);
                boolean includeSon = sheetNames.size() > 1;
                excelListBySheets = (List<List<List<String>>>) resultList.get(1);
                if (excelListBySheets == null) {
                    return ResourceUtil.getString("form.exportdata.null");
                }
                for (List<List<String>> excelListBySheet : excelListBySheets) {
                    if (excelListBySheet == null || excelListBySheet.size() < 2) {
                        return ResourceUtil.getString("form.exportdata.null");
                    }
                }
                int start = getStartLine(formBean, excelListBySheets.get(0), true);
                if(start == -1){
                    return ResourceUtil.getString("form.masterdatalist.inportexcelerror");
                }
                //校验主表数据不可为空
                if (excelListBySheets.get(0).size() == start + 1) {
                    return ResourceUtil.getString("form.exportdata.masternull");
                }
                FormAuthViewBean auth = formBean.getAuthViewBeanById(rightId);

                //数据唯一
                Map<String, FormFieldBean> uniqueMap = new HashMap<String, FormFieldBean>();
                //外部写入与外部预写
                Map<String, FormFieldBean> writeMap = new HashMap<String, FormFieldBean>();
                //主表数据
                List<Map<String, Object>> masterDataLists = new ArrayList<Map<String, Object>>();
                //重复表数据key按层级依次为主表id，重复表名，重复表字段名
                Map<Long, Map<String, List<Map<String, Object>>>> sonDataMap = new HashMap<Long, Map<String, List<Map<String, Object>>>>();
                //用于转换$1,$2
                Map<String, IdAndIdx> masterForSon = new HashMap<String, IdAndIdx>();
                Map<String, FormFieldBean> realFormFieldBeanMap = new HashMap<String, FormFieldBean>();
                //处理多级枚举关联
                Map<String, String> enumRelationMap = new HashMap<String, String>();
                //重复行序号 key为 表名
                Map<String, List<String>> lineNumberFieldMap = new HashMap<String, List<String>>();
                List<FormTableBean> ftbList = formBean.getSubTableBean();
                List<FormDataMasterBean> saveDatas = new ArrayList<FormDataMasterBean>();
                List<CtpContentAll> contentAlls = new ArrayList<CtpContentAll>();
                for (FormTableBean formTableBean : ftbList) {
                    List<FormFieldBean> fields = formTableBean.getFields();
                    List<String> lnFieldName = new ArrayList<String>();
                    for (FormFieldBean field : fields) {
                        if (field.getInputType() != null && field.getInputType().equalsIgnoreCase(FormFieldComEnum.LINE_NUMBER.getKey())) {
                            lnFieldName.add(field.getName());
                        }
                    }
                    lineNumberFieldMap.put(formTableBean.getTableName(), lnFieldName);
                }
                //先查找一下模板中的多级枚举相关信息
                for (int sheet = 0; sheet < excelListBySheets.size(); sheet++) {
                    List<List<String>> excelList = excelListBySheets.get(sheet);
                    List<String> headerList = excelList.get(1);
                    for (int j = 0; j < headerList.size() - 1; j++) {
                        String display = headerList.get(j);
                        FormFieldBean ffb = formBean.getFieldBeanByDisplay(display);
                        if (ffb != null) {
                            if (FormFieldComEnum.RELATION == ffb.getInputTypeEnum()) {
                                FormRelation fr = ffb.getFormRelation();
                                if (fr != null && ToRelationAttrType.data_relation_multiEnum.getKey() == fr.getToRelationAttrType()) {
                                    enumRelationMap.put(fr.getFromRelationAttr(), fr.getToRelationAttr());
                                }
                            }
                        }
                    }
                }
                EnumManager enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
                setMasterData(sheetNames.get(0), excelListBySheets.get(0), masterDataLists, uniqueMap, writeMap, formBean, auth, masterForSon, errorMessage, realFormFieldBeanMap, includeSon, enumRelationMap, enumManager);
                for (int sheet = 1; sheet < excelListBySheets.size(); sheet++) {
                    String sheetName = sheetNames.get(sheet) == null ? "" : sheetNames.get(sheet);
                    setSonData(sheetName, excelListBySheets.get(sheet), sonDataMap, uniqueMap, writeMap, formBean, auth, masterForSon, errorMessage, realFormFieldBeanMap, enumRelationMap, enumManager, masterDataLists);
                }
                long currentUserId = AppContext.currentUserId();

                /**
                 * 唯一标识
                 * key：表名，全是主表时，为主表名， 包含重复表时，取重复表
                 * value：唯一组合字段列表
                 */
                Map<String, List<List<FormFieldBean>>> uniqueMarket = new LinkedHashMap<String, List<List<FormFieldBean>>>();
                /******     校验唯一标识(数据唯一 为特殊的唯一标识)      ****/
                /**一共有8种情况:2(主数据    主从数据)* 4(无唯一，主唯一，从唯一，主从唯一)
                 *主从数据无唯一   主数据无唯一     主数据从唯一
                 *主从数据主唯一   主数据主唯一     主数据主从唯一  
                 *主从数据从唯一   主从数据主从唯一  
                 */
                //对于数据唯一来说，也是唯一标识中一种特例
                if (!uniqueMap.isEmpty()) {
                    for (Entry<String, FormFieldBean> et : uniqueMap.entrySet()) {
                        FormFieldBean ffb = et.getValue();
                        List<FormFieldBean> uniqueList = new ArrayList<FormFieldBean>();
                        uniqueList.add(ffb);
                        Strings.addToMap(uniqueMarket, ffb.getOwnerTableName(), uniqueList);
                    }
                }
                //唯一标识
                List<List<String>> uniqueMarkStr = formBean.getUniqueFieldList();
                String masterTableName = formBean.getMasterTableBean().getTableName();
                if (Strings.isNotEmpty(uniqueMarkStr)) {
                    for (List<String> list : uniqueMarkStr) {

                        List<FormFieldBean> tempList = new ArrayList<FormFieldBean>();
                        String subTableName = masterTableName;
                        for (String str : list) {
                            FormFieldBean formFieldBean = formBean.getFieldBeanByName(str);
                            if (formFieldBean != null) {
                                tempList.add(formFieldBean);
                                if (!formFieldBean.isMasterField()) {
                                    subTableName = formFieldBean.getOwnerTableName();
                                }
                            }
                        }
                        Strings.addToMap(uniqueMarket, subTableName, tempList);
                    }
                }
                //处理回写与预回写
                List<FormFieldBean> masterWriteList = new ArrayList<FormFieldBean>();
                Map<String, List<FormFieldBean>> sonWriteList = new HashMap<String, List<FormFieldBean>>();
                if (writeMap != null) {
                    divideMasterAndSon(writeMap, masterWriteList, sonWriteList);
                }
                StringBuilder log = new StringBuilder();
                boolean isCover = ImportExcelType.COVER.getKey().equals(repeat);

                StringBuilder addLog = new StringBuilder("导入新增数据id：");
                StringBuilder updateLog = new StringBuilder("导入修改数据id：");
                //校验主表时段导入本身是否存在重复的数据
                checkMainIsSame(masterDataLists,uniqueMarket.get(formBean.getMasterTableBean().getTableName()));
                //因为新增的时候无流程数据的moduleTemplateId是模版数据的Id，不是应用绑定id，所以这里统一一下，不然以后导入数据生成的二维码在M1上又有问题
                long moduleTemplateId = templeteId;
                int moduleType = FormType.getEnumByKey(formBean.getFormType()).getModuleType().getKey();
                MainbodyManager contentManager = (MainbodyManager) AppContext.getBean("ctpMainbodyManager");
                List<CtpContentAll> contentAllList = contentManager.getContentListByModuleIdAndModuleType(ModuleType.getEnumByKey(moduleType), templeteId);
                if (!Strings.isEmpty(contentAllList)) {
                    moduleTemplateId = contentAllList.get(0).getId();
                }

                for (Map<String, Object> masterMap : masterDataLists) {
                    long currentMainId = (Long) masterMap.get(MasterTableField.id.getKey());
                    Map<String, List<Map<String, Object>>> sonTableMap = sonDataMap.get(currentMainId);
                    //记录上次查到的数据主表记录
                    Map<Long, Map> updateMasterMap = new HashMap<Long, Map>();
                    Map<Long, Map> updateSonIdMap = new HashMap<Long, Map>();
                    List<List<FormFieldBean>> masterUnique = uniqueMarket.get(masterTableName);
                    if (masterUnique != null) {
                        boolean[] result = validateImportDataUnique(masterTableName, masterMap, null, masterUnique, updateMasterMap, updateSonIdMap, masterWriteList);
                        if (!result[0]) {
                            continue;
                        }
                    }

                    //需要保存的重复表数据：重复表名，数据列表
                    Map<String, List<Map<String, Object>>> subDataMap = new HashMap<String, List<Map<String, Object>>>();
                    if (sonTableMap != null && !sonTableMap.isEmpty()) {
                        for (Entry<String, List<Map<String, Object>>> et : sonTableMap.entrySet()) {
                            String subTableName = et.getKey();
                            List<Map<String, Object>> subDatas = et.getValue();
                            List<List<FormFieldBean>> subUnique = uniqueMarket.get(subTableName);
                            //无数据导入或者该重复表没有设置唯一标识，直接追加导入
                            if (Strings.isNotEmpty(subDatas) && Strings.isNotEmpty(subUnique)) {
                                checkSonIsSame(masterMap, subDatas, subUnique);
                                for (Map<String, Object> data : subDatas) {
                                    boolean[] result = validateImportDataUnique(masterTableName, masterMap, data, subUnique, updateMasterMap, updateSonIdMap, masterWriteList);
                                    if (!result[0]) {
                                        //TODO 需要跳出到主表数据循环
                                        continue;
                                    }
                                    if (result[1]) {
                                        Strings.addToMap(subDataMap, subTableName, data);
                                    }
                                }
                            } else {
                                subDataMap.put(subTableName, subDatas);
                            }
                        }
                    }

                    //updateMasterSize：0插入;1更新;大于1的话，说明所有唯一定位的不是同一条数据只能跳过此条(此时数据库与excel唯一冲突,无法定位更新记录)
                    int updateMasterSize = updateMasterMap.size();
                    switch (updateMasterSize) {
                        case 0:
                            masterMap.put(MasterTableField.state.getKey(), FormDataStateEnum.UNFLOW_UNLOCK.getKey());
                            log.append(FormLogUtil.getLogForInportExcel(formBean, masterMap));
                            FormDataMasterBean fdmb = FormDataMasterBean.newInstance4ExcelImport(formBean, masterMap, sonTableMap);
                            saveDatas.add(fdmb);
//                            FormService.saveOrUpdateFormData(fdmb, formBean.getId());
                            //判断保存数据的时候是否成功，如果失败则不添加日志。
                            String flag = (String) AppContext.getThreadContext("saveSuccess");
                            if ("false".equals(flag)) {
                                continue;
                            }
                            CtpContentAll contentAll = getCtpContentAll(currentUserId, fdmb.getId(), moduleType , moduleTemplateId,
                                    MainbodyType.FORM.getKey(), formId, fdmb.getId(), templeteTitle);
                            contentAlls.add(contentAll);
//                            MainbodyService.getInstance().saveOrUpdateContentAll(contentAll);
                            addLog.append(fdmb.getId()).append(",");
                            counts++;
                            break;
                        case 1:
                            Set<Long> upDateMasterIds = updateMasterMap.keySet();
                            Long upDateMasterId = null;
                            for (Long tempId : upDateMasterIds) {
                                upDateMasterId = tempId;
                            }
                            Map updateMasterDataMap = updateMasterMap.get(upDateMasterId);
                            boolean isLock = (FormDataStateEnum.UNFLOW_LOCKED.getKey() == Integer.parseInt(updateMasterDataMap.get(MasterTableField.state.getKey()) + ""));
                            if (isLock) {
                                continue;
                            }
                            if (isCover && !isLock) {//覆盖且未锁定时，更新数据
                                masterMap.put(MasterTableField.id.getKey(), upDateMasterId);
                                masterMap.put(MasterTableField.start_member_id.getKey(), updateMasterDataMap.get(MasterTableField.start_member_id.getKey()));
                                masterMap.put(MasterTableField.start_date.getKey(), updateMasterDataMap.get(MasterTableField.start_date.getKey()));
                                masterMap.put(MasterTableField.modify_date.getKey(), DateUtil.currentTimestamp());
                                for (int j = 0; j < masterWriteList.size(); j++) {
                                    if (updateMasterDataMap.get(masterWriteList.get(j)) != null) {
                                        masterMap.remove(masterWriteList.get(j));
                                    }
                                }
                                this.formDataDAO.updateData(Long.parseLong(masterMap.get(MasterTableField.id.getKey()).toString()), masterTableName, masterMap);
                                updateLog.append(upDateMasterId).append(",");
                            }
                            if (!subDataMap.isEmpty()) {
                                for (Entry<String, List<Map<String, Object>>> et : subDataMap.entrySet()) {
                                    String tableName = et.getKey();
                                    List<Map<String, Object>> datas = et.getValue();
                                    if (Strings.isEmpty(datas)) {
                                        continue;
                                    }
                                    Map lineNumberMap = null;
                                    if (lineNumberFieldMap != null && !lineNumberFieldMap.isEmpty()) {
                                        lineNumberMap = getMaxLineNumberForOneSubTable(lineNumberFieldMap, tableName, upDateMasterId);
                                    }
                                    int lineNumber = 1;
                                    List<Map<String, Object>> addList = new ArrayList<Map<String, Object>>();
                                    for (Map<String, Object> data : datas) {
                                        Long thisSonId = Long.valueOf(data.get(SubTableField.id.getKey()).toString());
                                        //包含则为更新，不包含则为新增
                                        if (updateSonIdMap.containsKey(thisSonId)) {
                                            //覆盖且未锁定时，更新数据
                                            if (isCover && !isLock) {
                                                Map sonDbMap = updateSonIdMap.get(thisSonId);
                                                Object idValue = sonDbMap.get("slave_id");
                                                data.put(SubTableField.id.getKey(), idValue);
                                                data.put(SubTableField.formmain_id.getKey(), upDateMasterId);
                                                this.formDataDAO.updateData(Long.parseLong(data.get(SubTableField.id.getKey()).toString()), tableName, data);
                                                updateLog.append(upDateMasterId).append("_").append(idValue).append(",");
                                            }
                                        } else {
                                            data.put(SubTableField.formmain_id.getKey(), upDateMasterId);
                                            if (lineNumberMap != null && !lineNumberMap.isEmpty()) {
                                                for (Object key : lineNumberMap.keySet()) {
                                                    int maxNumber = 0;
                                                    if (lineNumberMap.get(key) != null && Strings.isNotBlank(lineNumberMap.get(key).toString())) {
                                                        maxNumber = Integer.parseInt(lineNumberMap.get(key).toString());
                                                    }
                                                    data.put(key.toString(), maxNumber + lineNumber);
                                                }
                                                lineNumber++;
                                            }
                                            updateLog.append(upDateMasterId).append("_").append(data.get("id")).append(",");
                                            addList.add(data);
                                        }
                                    }
                                    this.formDataDAO.insertData(tableName, addList, true);
                                }
                            }
                            break;
                    }

                }
                /******end   校验唯一标识     ****/
                saveMasterData(saveDatas, formBean, false, contentAlls);
                if (counts > 0) {
                    logs.insert(0, ResourceUtil.getString("form.log.inportdata", counts));
                    logs.append(log.toString());
                    formLogManager.saveOrUpdateLog(formId, formBean.getFormType(), null, currentUserId, FormLogOperateType.IMPORTEXCEL.getKey(), logs.toString(), AppContext.currentUserId(), DateUtil.currentTimestamp());
                }
                LOGGER.info(addLog.toString());
                LOGGER.info(updateLog.toString());
                LOGGER.info("end: " + System.currentTimeMillis());
            }//end formbean
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            String error = ResourceUtil.getString("form.masterdatalist.inportexcelerror");
            if (Strings.isNotBlank(e.getMessage()) && e.getMessage().contains("lineNum")) {
                String[] msg = e.getMessage().split(";");
                String lineNum = msg[0].substring(msg[0].indexOf(":") + 1);
                String rowNum = msg[1].substring(msg[1].indexOf(":") + 1);
                String sheetName = msg.length > 2 ? msg[2].substring(msg[2].indexOf(":") + 1) : "";
                error = ResourceUtil.getString("form.masterdatalist.inportexcellineandrow", sheetName, lineNum, rowNum);
            }
            return error;
        } finally {
            try {
                fileManager.deletePhysicsFile(fileId);
            } catch (BusinessException e) {
                LOGGER.error("delete the import excel error->", e);
            }
        }
        return errorMessage.toString();
    }

    /**
     * 根据excel的主 从数据校验唯一标识设置是否满足
     *
     * @param masterTableName 主表名称
     * @param masterMap       主数据map
     * @param sonMap          从数据map，如果当前唯一标识不包含重复表，则为null
     * @param uniqueMarkLists 针对某个表唯一标识组合列表
     * @param updateMasterMap 需要更新的主表记录map
     * @param updateSonIdMap  需要更新的从表记录map
     * @param masterWriteList 需要更新的主表记录字段列表
     * @return boolean 数组：0 是否需要导入主表，1 是否需要导入重复表，具体导入到那条数据结合 uniqueMarkLists updateSonIdMap确定
     * @throws BusinessException
     */
    private boolean[] validateImportDataUnique(String masterTableName, Map<String, Object> masterMap, Map<String, Object> sonMap, List<List<FormFieldBean>> uniqueMarkLists, Map<Long, Map> updateMasterMap, Map<Long, Map> updateSonIdMap, List<FormFieldBean> masterWriteList) throws BusinessException {
        Map<Long, Map> tempSonIdMap = new HashMap<Long, Map>();
        for (List<FormFieldBean> list : uniqueMarkLists) {
            Map<String, Object> valueMap = new HashMap<String, Object>();
            boolean notCheck = false;
            List<String> tableNameList = new ArrayList<String>();
            tableNameList.add(masterTableName);
            String subTableName = "";
            for (FormFieldBean fieldBean : list) {
                String name = fieldBean.getName();
                Object value = null;
                if (fieldBean.isMasterField()) {
                    value = masterMap.get(name);
                } else {
                    value = sonMap.get(name);
                    subTableName = fieldBean.getOwnerTableName();
                }
                if (value != null) {
                    //有的数据库下，如果字段类型是文本，但是传入的参数是Long型的
                    if(value instanceof  Long && FieldType.VARCHAR.getKey().equals(fieldBean.getFieldType())){
                        value = value.toString();
                    }
                    valueMap.put(name, value);
                } else {
                    notCheck = true;
                }
            }

            List<String> returnList = new ArrayList<String>();
            String masterKey = MasterTableField.id.getKey();

            returnList.add(MasterTableField.start_date.getKey());
            returnList.add(MasterTableField.start_member_id.getKey());
            returnList.add(MasterTableField.state.getKey());
            for (int j = 0; j < masterWriteList.size(); j++) {
                returnList.add(masterWriteList.get(j).getName());
            }
            boolean containSubTable = false;
            String subKey = subTableName + "." + SubTableField.id.getKey() + "  as slave_id ";
            if (Strings.isNotBlank(subTableName)) {
                returnList.add(subKey);
                returnList.add(SubTableField.formmain_id.getKey());
                tableNameList.add(subTableName);
                containSubTable = true;
                masterKey = masterTableName + "." + MasterTableField.id.getKey();
            }
            returnList.add(masterKey);
            if (!notCheck && !valueMap.isEmpty() && valueMap.size() == list.size()) {
                List<Map> tempList = getValueMapFromMulTable(returnList.toArray(new String[0]), valueMap, tableNameList, "AND");
                if (Strings.isNotEmpty(tempList)) {
                    //此时需要查看返回结果,如果为1条则代表是主表的唯一性情况或从表数据为一条的情况
                    if (tempList.size() == 1) {
                        Map value = tempList.get(0);
                        if (containSubTable) {
                            //确定需要覆盖的重复表id
                            Object idValue = value.get("slave_id");
                            if (idValue != null) {
                                long querySubId = Long.parseLong(String.valueOf(idValue));
                                if (!tempSonIdMap.containsKey(querySubId)) {
                                    long currentSubId = (Long) sonMap.get(SubTableField.id.getKey());
                                    tempSonIdMap.put(currentSubId, tempList.get(0));
                                }
                            }
                        }

                        //确认主表数据id
                        String mainId = String.valueOf(tempList.get(0).get(MasterTableField.id.getKey()));
                        if (!StringUtil.checkNull(mainId)) {
                            long queryMainId = Long.parseLong(mainId);
                            if (!updateMasterMap.containsKey(queryMainId)) {
                                updateMasterMap.put(queryMainId, tempList.get(0));
                            }
                        }
                    } else {
                        //有多条时，跳过
                        return new boolean[]{false, false};
                    }
                }
            }
        }

        //主表数据是否添加，0不存在，直接添加，1存在，如果是覆盖则覆盖，>1 存在多条，直接跳过
        boolean saveMaster = true;
        if (updateMasterMap.size() > 2) {
            saveMaster = false;
        }
        //重复表表数据是否添加，0不存在，直接添加，1存在，如果是覆盖则覆盖，>1 存在多条，直接跳过
        boolean saveSub = true;
        if (tempSonIdMap.size() > 2) {
            saveSub = false;
        } else {
            updateSonIdMap.putAll(tempSonIdMap);
        }
        return new boolean[]{saveMaster, saveSub};
    }

    private int getStartLine(FormBean formBean, List<List<String>> excelList, boolean isMaster) {
        for (int i = 0; i <= 2; i++) {
            List<String> dataList = excelList.get(i);
            if (checkLineIsFieldName(formBean, dataList)) {
                return i;
            }
        }
        return -1;
    }

    private boolean checkLineIsFieldName(FormBean formBean, List<String> dataList) {
        for (String col : dataList) {
            if (!FormConstant.excelTag.equals(col)) {
                FormFieldBean fieldBean = formBean.getFieldBeanByDisplay(col);
                if (fieldBean != null) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 处理主表sheet
     *
     * @param excelList
     * @param resultList
     * @param unique
     * @param writeList
     * @param formBean
     * @param auth
     * @param idForSon
     * @param err
     * @param realFormFieldBeanMap
     * @throws BusinessException
     */
    private void setMasterData(String sheetName, List<List<String>> excelList, List<Map<String, Object>> resultList, Map<String, FormFieldBean> unique,
                               Map<String, FormFieldBean> writeMap, FormBean formBean, FormAuthViewBean auth, Map<String, IdAndIdx> masterForSon,
                               StringBuilder err, Map<String, FormFieldBean> realFormFieldBeanMap, boolean includeSon, Map<String, String> enumRelationMap,
                               EnumManager enumManager) throws BusinessException {
        List<String> dataList;
        long currentUserId = AppContext.currentUserId();
        int start = getStartLine(formBean, excelList, true);
        label:
        for (int i = start + 1; i < excelList.size(); i++) {
            Map<String, Object> dataMap = new HashMap<String, Object>();
            Map<String, String> srcDataMap = new HashMap<String, String>();
            dataMap.put(MasterTableField.id.getKey(), UUIDLong.longUUID());
            dataMap.put(MasterTableField.start_member_id.getKey(), currentUserId);
            dataMap.put(MasterTableField.start_date.getKey(), DateUtil.currentTimestamp());
            dataList = excelList.get(i);
            List<String> headerList = excelList.get(start);
            for (int j = 0; j < headerList.size() - 1; j++) {
                String data = "";
                String key = headerList.get(j);
                if (j < dataList.size()) {
                    data = dataList.get(j);
                    if (data != null) {
                        data = data.trim();
                    }
                }
                if (includeSon && j == 0) {
                    IdAndIdx idIdx = new IdAndIdx((Long) dataMap.get(MasterTableField.id.getKey()), j);
                    masterForSon.put(data, idIdx);
                    continue;
                }
                StringBuilder errorMessage = new StringBuilder();
                try {
                    FormFieldBean ffb = formBean.getFieldBeanByDisplay(key);
                    if (ffb != null) {
                        // 数字类型字段，导出时按照格式导出，在导入时将格式转化去掉。add by chenxb 2015-12-03
                        //data = ffb.convertFormatDecimalValue(data);
                        Map<String, String> map = ffb.convertFormatDecimalValue(data, true);
                        if (Strings.isNotBlank(map.get("msg"))) {
                            err.append(ResourceUtil.getString(map.get("msg"), sheetName, i + 1, getExcelColumnName(j + 1))).append("!<br>");
                            continue label;
                        }
                        data = map.get("data");
                        srcDataMap.put(ffb.getName(), data);
                    }
                    checkDataAndSetDbValue(dataMap, key, data, unique, writeMap, ffb, auth, errorMessage, realFormFieldBeanMap, i, j, sheetName);
                    if (Strings.isNotBlank(errorMessage.toString())) {
                        err.append(errorMessage).append("<br>");
                        continue label;
                    }
                } catch (BusinessException e) {
                    err.append(e.getMessage()).append("!<br><br>");
                    LOGGER.error("--impot excel err-->" + e.getMessage(), e);
                    continue label;
                }
            }
            //处理流水号
            if (auth != null) {
                List<FormAuthViewFieldBean> favfbList = auth.getFormAuthorizationFieldList();
                if (favfbList != null) {
                    for (FormAuthViewFieldBean formAuthViewFieldBean : favfbList) {
                        if (formAuthViewFieldBean.isSerialNumberDefaultValue()
                                && FieldAccessType.edit.getKey().equals(formAuthViewFieldBean.getAccess())) {
                            String serialNum = formAuthViewFieldBean.getSerialNumber();
                            LOGGER.info("通过数据导入产生流水号："+serialNum+"--"+formAuthViewFieldBean.getFieldName());
                            dataMap.put(formAuthViewFieldBean.getFieldName(), serialNum);
                        }
                    }
                }
            }
            handleMultiEnum(dataMap, null, srcDataMap, enumRelationMap, formBean, enumManager);
            resultList.add(dataMap);
        }
    }

    /**
     * 处理重复表sheet
     *
     * @param excelList
     * @param dataMap
     * @param unique
     * @param writeList
     * @param formBean
     * @param auth
     * @param idForSon
     * @param err
     * @param realFormFieldBeanMap
     * @throws BusinessException
     */
    private void setSonData(String sheetName, List<List<String>> excelList, Map<Long, Map<String, List<Map<String, Object>>>> sonDataMap, Map<String, FormFieldBean> unique,
                            Map<String, FormFieldBean> writeMap, FormBean formBean, FormAuthViewBean auth, Map<String, IdAndIdx> masterForSon,
                            StringBuilder err, Map<String, FormFieldBean> realFormFieldBeanMap, Map<String, String> enumRelationMap,
                            EnumManager enumManager, List<Map<String, Object>> masterDataList) throws BusinessException {
        List<String> dataList;
        Long formmain_id;
        String tableName = null;
        label:
        for (int i = 2; i < excelList.size(); i++) {
            Map<String, Object> dataMap = new HashMap<String, Object>();
            Map<String, String> srcDataMap = new HashMap<String, String>();
            dataMap.put(SubTableField.id.getKey(), UUIDLong.longUUID());
            dataList = excelList.get(i);
            List<String> headerList = excelList.get(1);
            formmain_id = 0L;
            tableName = null;
            IdAndIdx idIdx = null;
            for (int j = 0; j < headerList.size() - 1; j++) {
                String data = "";
                String key = headerList.get(j);
                if (j < dataList.size()) {
                    data = dataList.get(j);
                    if (data != null) {
                        data = data.trim();
                    }
                }
                if (j == 0) {
                    idIdx = masterForSon.get(data);
                    if (idIdx == null) {
                        //没有对应则本条记录无效
                        break;
                    } else {
                        formmain_id = idIdx.getId();
                    }
                    dataMap.put(SubTableField.formmain_id.getKey(), formmain_id);
                    continue;
                }
                StringBuilder errorMessage = new StringBuilder();
                try {
                    FormFieldBean ffb = formBean.getFieldBeanByDisplay(key);
                    if (ffb == null) {
                        continue;
                    }
                    //重复表汇总表不支持导入
                    FormTableBean tableBean = formBean.getFormTableBeanByFieldName(ffb.getName());
                    if (tableBean.isCollectTable) {
                        return;
                    }
                    if (ffb != null) {
                        // 数字类型字段，导出时按照格式导出，在导入时将格式转化去掉。add by chenxb 2015-12-03
                        //data = ffb.convertFormatDecimalValue(data);
                        Map<String, String> map = ffb.convertFormatDecimalValue(data, true);
                        if (Strings.isNotBlank(map.get("msg"))) {
                            err.append(ResourceUtil.getString(map.get("msg"), sheetName, i + 1, getExcelColumnName(j + 1))).append("!<br>");
                            continue label;
                        }
                        data = map.get("data");
                        srcDataMap.put(ffb.getName(), data);
                    }
                    checkDataAndSetDbValue(dataMap, key, data, unique, writeMap, ffb, auth, errorMessage, realFormFieldBeanMap, i, j, sheetName);
                    if (Strings.isNotBlank(errorMessage.toString())) {
                        err.append(errorMessage).append("<br>");
                        continue label;
                    }
                } catch (BusinessException e) {
                    err.append(errorMessage).append("!<br><br>");
                    LOGGER.error("--impot excel err-->", e);
                    continue label;
                }
                FormFieldBean ffb = formBean.getFieldBeanByDisplay(key);
                tableName = ffb.getOwnerTableName();
            }
            //处理多级枚举
            if (masterDataList != null && !masterDataList.isEmpty() && idIdx != null) {
                Map<String, Object> masterDataMap = masterDataList.get(idIdx.getIdx());
                handleMultiEnum(masterDataMap, dataMap, srcDataMap, enumRelationMap, formBean, enumManager);
                if (sonDataMap.containsKey(formmain_id)) {
                    Map<String, List<Map<String, Object>>> tableMap = sonDataMap.get(formmain_id);
                    if (tableMap.containsKey(tableName)) {
                        List<Map<String, Object>> dataMapList = tableMap.get(tableName);
                        dataMapList.add(dataMap);
                    } else {
                        List<Map<String, Object>> dataMapList = new ArrayList<Map<String, Object>>();
                        dataMapList.add(dataMap);
                        tableMap.put(tableName, dataMapList);
                    }
                } else {
                    Map<String, List<Map<String, Object>>> tableMap = new HashMap<String, List<Map<String, Object>>>();
                    List<Map<String, Object>> dataMapList = new ArrayList<Map<String, Object>>();
                    dataMapList.add(dataMap);
                    tableMap.put(tableName, dataMapList);
                    sonDataMap.put(formmain_id, tableMap);
                }
            }
        }
    }

    /**
     * 设置每个单元格实际存储值
     *
     * @param dataMap
     * @param key
     * @param data
     * @param unique
     * @param writeList
     * @param formBean
     * @param auth
     * @param errorMessage
     * @param realFormFieldBeanMap
     * @param row
     * @param col
     * @throws BusinessException
     */
    private void checkDataAndSetDbValue(Map<String, Object> dataMap, String key, String data, Map<String, FormFieldBean> unique,
                                        Map<String, FormFieldBean> writeMap, FormFieldBean ffb, FormAuthViewBean auth, StringBuilder errorMessage,
                                        Map<String, FormFieldBean> realFormFieldBeanMap, int row, int col, String sheetName) throws BusinessException {
        Object objValue = null;
        try {
            if (ffb != null) {
                //校验值的格式
                String returnStr = ffb.checkFormat(data, true);
                if (returnStr != null) {
                    errorMessage.append(ResourceUtil.getString(returnStr, sheetName, row + 1, getExcelColumnName(col + 1)));
                    return;
                }
                //优化一下:由于basePo中有同步锁,避免多次克隆
                FormFieldBean formFieldBean = null;
                if (realFormFieldBeanMap.containsKey(key)) {
                    formFieldBean = realFormFieldBeanMap.get(key);
                } else {
                    formFieldBean = ffb.findRealFieldBean();
                    realFormFieldBeanMap.put(key, formFieldBean);
                }
                objValue = formFieldBean.getValue4Import(data, false);
                String inputType = formFieldBean.getInputType();
                //校验枚举是否是停用
                if (FormFieldComEnum.RADIO.getKey().equalsIgnoreCase(inputType)
                        || FormFieldComEnum.SELECT.getKey().equalsIgnoreCase(inputType)) {
                    CtpEnumItem item = enumManagerNew.getItemByEnumId(formFieldBean.getEnumId(), data);
                    if (item != null && item.getState() != null && item.getState().intValue() == 0) {
                        errorMessage.append(ResourceUtil.getString("form.export.excel.errordata", sheetName, row + 1, getExcelColumnName(col + 1), ResourceUtil.getString("form.export.excel.enum.disabled.error")));
                    }
                }
                if (objValue == null && Strings.isNotBlank(data)) {
                    errorMessage.append(ResourceUtil.getString("form.export.excel.errordata", sheetName, row + 1, getExcelColumnName(col + 1), "原因：值不能为空！"));
                }
                //校验存储位数与小数点个数
                if (objValue != null) {
                    if (!(FormFieldComEnum.RADIO.getKey().equalsIgnoreCase(formFieldBean.getInputType())
                            || FormFieldComEnum.SELECT.getKey().equalsIgnoreCase(formFieldBean.getInputType())
                            || FormFieldComEnum.CHECKBOX.getKey().equalsIgnoreCase(formFieldBean.getInputType()))) {
                        if (!ffb.checkDataLength(objValue.toString(), data)) {
                            errorMessage.append(ResourceUtil.getString("form.masterdatalist.savelengtherror", sheetName, row + 1, getExcelColumnName(col + 1)));
                        }
                    }
                    if (FieldType.DECIMAL.getKey().equalsIgnoreCase(ffb.getFieldType())) {
                        if (!(FormFieldComEnum.RADIO.getKey().equalsIgnoreCase(formFieldBean.getInputType())
                                || FormFieldComEnum.SELECT.getKey().equalsIgnoreCase(formFieldBean.getInputType())
                                || FormFieldComEnum.CHECKBOX.getKey().equalsIgnoreCase(formFieldBean.getInputType()))) {
                            if (!formFieldBean.checkNumberDigitLength(objValue)) {
                                errorMessage.append(ResourceUtil.getString("form.masterdatalist.decimalserror", sheetName, row + 1, getExcelColumnName(col + 1)));
                                return;
                            }
                        }
                    }
                }
                if (ffb.isUnique() && !unique.containsKey(ffb.getName())) {
                    unique.put(ffb.getName(), ffb);
                }
                if ((FormFieldComEnum.OUTWRITE == ffb.getInputTypeEnum()
                        || FormFieldComEnum.PREPAREWRITE == ffb.getInputTypeEnum()) && !writeMap.containsKey(ffb.getName())) {
                    writeMap.put(ffb.getName(), ffb);
                }
                //判断是否为空,校验必填项
//                boolean isNull = true;
//                if (auth != null) {
//                    FormAuthViewFieldBean fieldAuth = auth.getFormAuthorizationField(ffb.getName());
//                    isNull = fieldAuth.isNull();
//                }
//                if (Strings.isBlank(data)) {
//                    if (!isNull) {
//                        errorMessage.append(ResourceUtil.getString("form.masterdatalist.isnotnullerror", sheetName, row + 1, getExcelColumnName(col + 1)));
//                        return;
//                    }
//                }
                //导入数据的时候，如果类型是文本框的字段中导入的值存在制表符、换行、回车符号，需要替换掉
                if(!StringUtil.checkNull(String.valueOf(objValue)) && FormFieldComEnum.TEXT.getKey().equals(formFieldBean.getInputType())){
                    String objV = String.valueOf(objValue).replaceAll("\\t", "").replaceAll("\\n", "").replaceAll("\\r", "");
                    dataMap.put(ffb.getName(), objV);
                }else{
                    dataMap.put(ffb.getName(), objValue);
                }
            }
        } catch (Exception e) {
            String erorr = ResourceUtil.getString("form.masterdatalist.inportexcellineandrow", sheetName, (row + 1), getExcelColumnName((col + 1)), "原因：" + e.getMessage());
            errorMessage.append(erorr);
            throw new BusinessException(erorr);
        }
    }

    /**
     * 处理多级枚举
     *
     * @param masteData       主表数据
     * @param sonMap          子表数据
     * @param srcData         源数据
     * @param enumRelationMap 枚举关联关系
     * @param formBean
     * @param enumManager
     * @throws BusinessException
     */
    private void handleMultiEnum(Map<String, Object> masteData, Map<String, Object> sonMap, Map<String, String> srcData, Map<String, String> enumRelationMap, FormBean formBean, EnumManager enumManager) throws BusinessException {
        if (!enumRelationMap.isEmpty()) {
            Map<String, Object> dataMap = new HashMap<String, Object>();
            if (masteData != null && !masteData.isEmpty()) {
                dataMap.putAll(masteData);
            }
            if (sonMap != null && !sonMap.isEmpty()) {
                dataMap.putAll(sonMap);
            }
            Set<String> fieldNameSets = enumRelationMap.keySet();
            Map<String, Object> realIdMap = new HashMap<String, Object>();
            for (String fieldName : fieldNameSets) {
                FormFieldBean field = formBean.getFieldBeanByName(fieldName);
                handleRealEnumValue(field, dataMap, srcData, enumRelationMap, formBean, enumManager, realIdMap);
            }
            if (!realIdMap.isEmpty()) {
                for (String fieldName : realIdMap.keySet()) {
                    FormFieldBean field = formBean.getFieldBeanByName(fieldName);
                    if (field.isMasterField()) {
                        masteData.put(fieldName, realIdMap.get(fieldName));
                    } else {
                        sonMap.put(fieldName, realIdMap.get(fieldName));
                    }
                }
            }
        }
    }

    /**
     * 得到真实的枚举id
     *
     * @param field
     * @param dataMap
     * @param srcData
     * @param enumRelationMap
     * @param formBean
     * @param enumManager
     * @return
     * @throws BusinessException
     */
    private Object handleRealEnumValue(FormFieldBean field, Map<String, Object> dataMap, Map<String, String> srcData,
                                       Map<String, String> enumRelationMap, FormBean formBean, EnumManager enumManager, Map<String, Object> realIdMap) throws BusinessException {
        if (field != null && dataMap != null) {
            Object currValue = dataMap.get(field.getName());
            if (realIdMap.containsKey(field.getName())) {
                currValue = realIdMap.get(field.getName());
                return currValue;
            }
            if (FormFieldComEnum.SELECT == field.getInputTypeEnum()) {
                String displayValue = srcData.get(field.getName());
                CtpEnumItem item = null;
                try {
                    item = getEmumItemByParentAndShowvalue(field.getEnumId(), 0L, displayValue, enumManager);
                } catch (BusinessException e) {
                    LOGGER.error("----getRealEnumValue---->" + field.getName() + "---->" + currValue, e);
                }
                if (item != null) {
                    realIdMap.put(field.getName(), item.getId());
                    enumManager.updateEnumItemRef(item.getId());
                    return item.getId();
                }
                return currValue;
            } else {
                FormFieldBean rfield = formBean.getFieldBeanByName(enumRelationMap.get(field.getName()));
                if (rfield != null) {
                    Object parentIdObject = handleRealEnumValue(rfield, dataMap, srcData, enumRelationMap, formBean, enumManager, realIdMap);
                    if (parentIdObject != null && Strings.isNotBlank(parentIdObject.toString())) {
                        Long parentId = Long.parseLong(parentIdObject.toString());
                        if (parentId != null) {
                            String displayValue = srcData.get(field.getName());
                            CtpEnumItem item = null;
                            try {
                                item = getEmumItemByParentAndShowvalue(field.getEnumId(), parentId, displayValue, enumManager);
                            } catch (BusinessException e) {
                                LOGGER.error("----getRealEnumValue---->" + field.getName() + "---->" + currValue, e);
                            }
                            if (item != null) {
                                realIdMap.put(field.getName(), item.getId());
                                enumManager.updateEnumItemRef(item.getId());
                                return item.getId();
                            }
                        }
                    }
                }
            }
            return currValue;
        }
        return null;
    }

    private CtpEnumItem getEmumItemByParentAndShowvalue(long enumId, long parentId, String showValue, EnumManager enumManager) throws BusinessException {
        List<CtpEnumItem> enumItemList = enumManager.getEmumItemByEmumId(enumId);
        if (enumItemList != null) {
            for (CtpEnumItem ctpEnumItem : enumItemList) {
                if (parentId == ctpEnumItem.getParentId() && ctpEnumItem.getShowvalue().equals(showValue)) {
                    return ctpEnumItem;
                }
            }

        }
        return null;
    }

    /**
     * 查找重复表中最大的重复行序号
     *
     * @param lineNumberFieldMap
     * @param tableName
     * @param currentMainId
     * @return
     * @throws BusinessException
     */
    @SuppressWarnings({"unchecked", "rawtypes"})
    private Map getMaxLineNumberForOneSubTable(Map<String, List<String>> lineNumberFieldMap, String tableName, Long currentMainId) throws BusinessException {
        Map lineNumberMap = new HashMap();
        if (lineNumberFieldMap != null && !lineNumberFieldMap.isEmpty()) {
            List<String> lnList = lineNumberFieldMap.get(tableName);
            if (lnList != null && !lnList.isEmpty()) {
                StringBuilder sql = new StringBuilder(" select ");
                int len = lnList.size();
                for (int i = 0; i < len; i++) {
                    String name = lnList.get(i);
                    sql.append(" max(").append(name).append(") ").append(name);
                    if (i != len - 1) {
                        sql.append(",");
                    }
                }
                sql.append(" from ").append(tableName).append(" where ").append(SubTableField.formmain_id.getKey());
                sql.append(" =").append(currentMainId);

                List<Map> resList = formDataDAO.selectDataBySql(sql.toString());
                if (resList != null && !resList.isEmpty()) {
                    lineNumberMap.putAll(resList.get(0));
                }
            }
        }
        return lineNumberMap;
    }

    /**
     * 分离主表与子表信息
     *
     * @param fieldList
     * @param master
     * @param son       key为表名
     */
    private void divideMasterAndSon(Map<String, FormFieldBean> fieldMap, List<FormFieldBean> master, Map<String, List<FormFieldBean>> son) {
        for (FormFieldBean ffb : fieldMap.values()) {
            if (ffb.isMasterField()) {
                master.add(ffb);
            } else {
                String tableName = ffb.getOwnerTableName();
                Strings.addToMap(son, tableName, ffb);
            }
        }
    }

    /**
     * 因为现在主表导入采用的是批量插入，所以这里需要先判断导入的主表数据是否本身就有重复的
     * @param masterDataList 主表数据
     * @param uniqueMarkLists 主表的唯一标识，包含数据唯一
     */
    private void checkMainIsSame(List<Map<String, Object>> masterDataList, List<List<FormFieldBean>> uniqueMarkLists) {
        if (!masterDataList.isEmpty() && uniqueMarkLists != null && !uniqueMarkLists.isEmpty()) {
            for (List<FormFieldBean> uniqueMarkList : uniqueMarkLists) {
                Iterator<Map<String, Object>> it = masterDataList.iterator();
                //校验本身是否有重复:如果用，只保留最开始的那条
                Set<String> uniquStr = new HashSet<String>();
                while (it.hasNext()) {
                    Map<String, Object> masterMap = it.next();
                    StringBuilder tempsb = new StringBuilder();
                    boolean isSkip = false;
                    for (FormFieldBean ffb : uniqueMarkList) {
                        Object uniqueValue;
                        uniqueValue = masterMap.get(ffb.getName());
                        if (uniqueValue != null) {
                            tempsb.append(uniqueValue.toString());
                        }else{
                            isSkip = true;
                            continue;
                        }
                    }
                    if (!isSkip) {
                        if (!"".equals(tempsb.toString()) && uniquStr.contains(tempsb.toString())) {
                            it.remove();
                        } else {
                            uniquStr.add(tempsb.toString());
                        }
                    }
                }
            }
        }
    }

    /**
     * 校验重复表数据本身是否重复
     *
     * @param masterMap       主表数据
     * @param sonDataList     从表数据
     * @param uniqueMarkLists 唯一标识
     */
    private void checkSonIsSame(Map<String, Object> masterMap, List<Map<String, Object>> sonDataList, List<List<FormFieldBean>> uniqueMarkLists) {
        if (!sonDataList.isEmpty() && uniqueMarkLists != null && !uniqueMarkLists.isEmpty()) {
            for (List<FormFieldBean> uniqueMarkList : uniqueMarkLists) {
                Iterator<Map<String, Object>> it = sonDataList.iterator();
                //校验本身是否有重复:如果用，只保留最开始的那条
                Set<String> uniquStr = new HashSet<String>();
                while (it.hasNext()) {
                    Map<String, Object> sonMap = it.next();
                    StringBuilder tempsb = new StringBuilder();
                    boolean isSkip = false;
                    for (FormFieldBean ffb : uniqueMarkList) {
                        Object sonUniqueValue;
                        if (ffb.isMasterField()) {
                            sonUniqueValue = masterMap.get(ffb.getName());
                        } else {
                            sonUniqueValue = sonMap.get(ffb.getName());
                        }
                        if (sonUniqueValue != null) {
                            tempsb.append(sonUniqueValue.toString());
                        } else {
                            isSkip = true;
                            continue;
                        }
                    }
                    if (!isSkip) {
                        if (!"".equals(tempsb.toString()) && uniquStr.contains(tempsb.toString())) {
                            it.remove();
                        } else {
                            uniquStr.add(tempsb.toString());
                        }
                    }
                }
            }
        }
    }

    private List<Map> getValueMapFromMulTable(String[] returnFields, Map<String, Object> hm, List<String> tableNameList, String fieldsLogic) throws BusinessException {
        if (returnFields != null) {
            String fieldNames = StringUtils.arrayToString(returnFields);
            StringBuffer sb = new StringBuffer("");
            sb.append("SELECT ").append(fieldNames).append(" FROM ");
            for (int i = 0; i < tableNameList.size(); i++) {
                if (i == 0) {
                    sb.append(tableNameList.get(i));
                } else {
                    sb.append(" left join " + tableNameList.get(i) + " on " + tableNameList.get(0) + ".id=" + tableNameList.get(i) + ".formmain_id ");
                }
            }
            List<Object> fieldValues = new ArrayList<Object>();
            Iterator<Entry<String, Object>> iter = hm.entrySet().iterator();
            Entry<String, Object> entry;
            sb.append(" where ");
            while (iter.hasNext()) {
                entry = iter.next();
                sb.append(fieldsLogic).append(" ").append(entry.getKey()).append(" =? ");
                fieldValues.add(entry.getValue());
            }
            sb = new StringBuffer(sb.toString().replaceFirst(fieldsLogic + " ", ""));
            JDBCAgent jdbc = new JDBCAgent();
            try {
                jdbc.execute(sb.toString(), fieldValues);
                return jdbc.resultSetToList();
            } catch (SQLException e) {
                LOGGER.error(e.getMessage(), e);
                throw new BusinessException(e);
            } finally {
                if (jdbc != null) {
                    jdbc.close();
                }
            }
        } else {
            return null;
        }
    }

    /**
     * 由10进制转为26进制A-Z
     *
     * @param num
     * @return
     */
    private String getExcelColumnName(int num) {
        StringBuilder sb = new StringBuilder();
        int n = num;
        while (n > 0) {
            int m = n % 26;
            if (m == 0) m = 26;
            sb.insert(0, ((char) (m + 64)));
            n = (n - m) / 26;
        }
        return sb.toString();
    }

    /**
     * 新建content对象
     *
     * @param ModuleId
     * @param ModuleType
     * @param ModuleTemplateId
     * @param ContentType
     * @param ContentTemplateId
     * @param ContentDataId
     * @param Title
     * @return
     */
    private CtpContentAll getCtpContentAll(long currentUserId, Long ModuleId, int ModuleType, Long ModuleTemplateId,
                                           int ContentType, Long ContentTemplateId, Long ContentDataId, String Title) {
        Timestamp currentTime = DateUtil.currentTimestamp();
        CtpContentAll contentAll = new CtpContentAll();
        contentAll.setId(UUIDLong.longUUID());

        contentAll.setModuleId(ModuleId);
        contentAll.setModuleType(ModuleType);



        contentAll.setModuleTemplateId(ModuleTemplateId);

        contentAll.setContent(null);
        contentAll.setContentType(ContentType);
        contentAll.setContentTemplateId(ContentTemplateId);
        contentAll.setContentDataId(ContentDataId);

        contentAll.setModifyId(currentUserId);
        contentAll.setModifyDate(currentTime);
        contentAll.setCreateId(currentUserId);
        contentAll.setCreateDate(currentTime);
        contentAll.setTitle(Title);
        contentAll.setSort(0);
        return contentAll;
    }

    /**
     * 加锁
     *
     * @param formId
     * @param ids
     * @return
     * @throws SQLException
     * @throws BusinessException
     * @throws NumberFormatException
     */
    @Override
    public String setLock(Long formId, String ids, Long templateId) throws NumberFormatException, BusinessException,
            SQLException {

        String returnStr = "1";
        StringBuilder logs = new StringBuilder();
        FormBean fb = formCacheManager.getForm(formId);
        //取得需要记录日志的列
        List<String> fieldsList = fb.getBind().getLogFieldList();
        List<Object> value = new ArrayList<Object>();
        String values = "";
        String id[] = ids.split(",");
        //先判断需要加锁的数据是否有被锁定的。
        for (int j = 0; j < id.length; j++) {
            String lockInfo = formManager.checkDataLockFormEdit(id[j], true, false);
            if (Strings.isNotBlank(lockInfo)) {
                returnStr = ResourceUtil.getString("form.unflow.setLock.tips", (j + 1), lockInfo);
                return returnStr;
            }
        }
        for (int j = 0; j < id.length; j++) {
            FormDataMasterBean fdmb = formDataDAO.selectDataByMasterId(Long.parseLong(id[j]), fb, null);
            //取得日志记录列的数据
            for (String name : fieldsList) {
                String[] names = name.split("\\.");
                FormFieldBean ffb = fb.getFieldBeanByName(names[1]);
                value = fdmb.getDataList(ffb.getName());
                if (value != null) {
                    value = FormUtil.getNotNullItem(value);
                    if(value.size() == 0){
                        values = "";
                    }else{
                        values = getDisplayValue(ffb,value);
                    }
                } else {
                    values = "";
                }
                logs.append(FormLogUtil.getLogForLockorUnlock(fb, ffb, values,
                        FormDataStateEnum.UNFLOW_LOCKED.getKey()));
                LOGGER.debug(logs);
            }
            // 更新锁状态
            formDataDAO.updateLockState(id[j], fb.getMasterTableBean().getTableName(),
                    FormDataStateEnum.UNFLOW_LOCKED.getKey());
            //记录日志
            formLogManager.saveOrUpdateLog(formId, formCacheManager.getForm(formId).getFormType(),
                    Long.parseLong(id[j]), AppContext.currentUserId(), FormLogOperateType.LOCK.getKey(),
                    logs.toString(), fdmb.getStartMemberId(), fdmb.getStartDate());
            logs.setLength(0);
        }
        return returnStr;
    }

    //组装重复行字段的值，不然会显示id那些
    private String getDisplayValue(FormFieldBean ffb,List<Object> value) throws BusinessException{
        StringBuffer sb = new StringBuffer();
        if(ffb.isMasterField()){
            Object display = ffb.findRealFieldBean().getDisplayValue(value.get(0),false)[1];
            return display == null ?"":display.toString();
        }else{
            int index = 0;
            for(Object obj:value){
                if(index > 0){
                    sb.append(",");
                }
                Object display = ffb.findRealFieldBean().getDisplayValue(obj,false)[1];
                sb.append(display == null ?"":display.toString());
                index++;
            }
        }
        return sb.toString();
    }

    /**
     * 解锁
     *
     * @param formId
     * @return
     * @throws SQLException
     * @throws BusinessException
     */
    @Override
    public boolean unLock(Long formId, String ids, Long templateId) throws BusinessException, SQLException {
        StringBuilder logs = new StringBuilder();
        FormBean fb = formCacheManager.getForm(formId);

        //取得需要记录日志的列
        List<String> fieldsList = fb.getBind().getLogFieldList();
        List<FormFieldBean> list = fb.getAllFieldBeans();
        String[] fields = new String[list.size()];
        //记录所有需要保存日志的列
        List<FormFieldBean> logfields = new ArrayList<FormFieldBean>();
        int i = 0;
        for (FormFieldBean ffb : list) {
            //日志记录
            //判断是否需要记录详细日志,日志设置里列+数据唯一的列都要记录
            if (fb.getBind().getLogFieldList().contains(ffb.getOwnerTableName() + "." + ffb.getName())
                    || ffb.isUnique()) {
                if (ffb.isMasterField()) {
                    fields[i] = ffb.getName();
                }
                logfields.add(ffb);
            }
            i++;
        }
        List<Object> value = new ArrayList<Object>();
        String values = "";
        String id[] = ids.split(",");
        for (int j = 0; j < id.length; j++) {
            if (StringUtil.checkNull(id[j])) {
                continue;
            }
            //取得日志记录列的数据
            FormDataMasterBean fdmb = formDataDAO.selectDataByMasterId(Long.parseLong(id[j]), fb, fields);
            for (FormFieldBean ffb : logfields) {
                value = fdmb.getDataList(ffb.getName());
                if (value != null) {
                    value = FormUtil.getNotNullItem(value);
                    if(value.size() == 0){
                        values = "";
                    }else{
                        values = getDisplayValue(ffb,value);
                    }
                } else {
                    values = null;
                }
                logs.append(FormLogUtil.getLogForLockorUnlock(fb, ffb, values,
                        FormDataStateEnum.UNFLOW_UNLOCK.getKey()));
            }
            // 更新锁状态
            formDataDAO.updateLockState(id[j], fb.getMasterTableBean().getTableName(),
                    FormDataStateEnum.UNFLOW_UNLOCK.getKey());
            //记录日志
            formLogManager.saveOrUpdateLog(formId, formCacheManager.getForm(formId).getFormType(),
                    Long.parseLong(id[j]), AppContext.currentUserId(), FormLogOperateType.UNLOCK.getKey(),
                    logs.toString(), fdmb.getStartMemberId(), fdmb.getStartDate());
            logs.setLength(0);
        }
        return true;
    }

    private String getSql4FormBindAuth(FormBindAuthBean bind, String selectFields, String sortFields, FormBean form,
                                       Map<String, Object> params) {
        FormTableBean masterTable = form.getMasterTableBean();
        List<FormFieldBean> allFields = form.getAllFieldBeans();
        List<FormTableBean> subTables = form.getSubTableBean();
        StringBuffer sql = new StringBuffer("select DISTINCT ").append(selectFields).append(" from ");
        StringBuffer whereSb = new StringBuffer("");
        //需要查询的表名字
        StringBuffer fromTableName = new StringBuffer(masterTable.getTableName());
        StringBuffer userCondition = new StringBuffer("");
        StringBuffer subTablewhereSb = new StringBuffer("");
        FormFormulaBean formulaBean = bind.getFormFormulaBean();
        if (formulaBean != null) {
            userCondition.append(formulaBean.getExecuteFormulaForSQL());
        }
        if (!StringUtil.checkNull(userCondition.toString())) {
            for (FormFieldBean fieldBean : allFields) {
                int index = userCondition.indexOf(fieldBean.getName());
                if (index != -1) {
                    userCondition = userCondition.replace(index, index + fieldBean.getName().length(),
                            fieldBean.getOwnerTableName() + "." + fieldBean.getName());
                }
            }
            whereSb.append("(").append(userCondition).append(")");
        }

        //增加查询条件
        Iterator<String> ite = params.keySet().iterator();
        while (ite.hasNext()) {
            String key = ite.next();
            if (Strings.isBlank((String) params.get(key))) {
                continue;
            }
            if (!"sortStr".equals(key) && !"formId".equals(key) && !"formTemplateId".equals(key)) {
                if (StringUtil.checkNull(whereSb.toString().trim())) {
                    whereSb.append("(");
                } else {
                    whereSb.append(" and (");
                }
                if ("searchstr".equals(key)) {
                    whereSb.append(params.get(key));
                } else {
                    FormFieldBean ffb = form.getFieldBeanByName(key);
                    //系统变量
                    if (ffb == null) {
                        if (key.contains("_date")) {
                            List date = (List) params.get(key);
                            whereSb.append(" "
                                    + key
                                    + " between '"
                                    + (StringUtil.checkNull(date.get(0) + "") ? "0000" : date.get(0))
                                    + "' and '"
                                    + (StringUtil.checkNull(date.get(1) + "") ? DateUtil.getDateAndTime() : date.get(1))
                                    + "'");
                        } else {
                            whereSb.append(" " + key + " like '%" + params.get(key) + "%'");
                        }
                    } else {
                        //数字类型
                        if (ffb.getFieldType().equals(FieldType.DECIMAL.getKey())) {
                            whereSb.append(" " + key + " = " + params.get(key) + "");
                        } else {//其他类型
                            if (StringUtil.checkNull(params.get(key) + "")) {
                                whereSb.append(" " + key + " = '' or " + key + " is null");
                            } else {
                                whereSb.append(" " + key + " like '%" + params.get(key) + "%'");
                            }
                        }

                    }
                }
                whereSb.append(")");
            }
        }

        for (FormFieldBean fieldBean : allFields) {
            if (fieldBean.isConstantField() || fieldBean.isMasterField()) {
                continue;
            }
            //判断select后边的字符串中是否包含子表字段，如果有，则fromTableName后边需要跟子表名字
            if (fromTableName.indexOf(fieldBean.getOwnerTableName()) == -1
                    && selectFields.indexOf(fieldBean.getName()) != -1) {
                fromTableName.append(",").append(fieldBean.getOwnerTableName());
            }
            //判断where后边的字符串中是否包含子表字段，如果有，则fromTableName后边需要跟子表名字
            if (fromTableName.indexOf(fieldBean.getOwnerTableName()) == -1
                    && whereSb.indexOf(fieldBean.getName()) != -1) {
                fromTableName.append(",").append(fieldBean.getOwnerTableName());
            }
            //判断sortFields后边的字符串中是否包含子表字段，如果有，则fromTableName后边需要跟子表名字
            if (fromTableName.indexOf(fieldBean.getOwnerTableName()) == -1
                    && sortFields.indexOf(fieldBean.getName()) != -1) {
                fromTableName.append(",").append(fieldBean.getOwnerTableName());
            }
        }
        sql.append(fromTableName);

        for (int i = 0; i < subTables.size(); i++) {
            if (sql.indexOf(subTables.get(i).getTableName()) != -1
                    && subTablewhereSb.indexOf(subTables.get(i).getTableName()) == -1) {
                subTablewhereSb.append(" (").append(subTables.get(i).getTableName()).append(".")
                        .append(SubTableField.formmain_id.getKey()).append("=")
                        .append(masterTable.getTableName()).append(".").append(MasterTableField.id.getKey())
                        .append(") ").append(" and ");
            }
        }
        int andIndex = subTablewhereSb.lastIndexOf("and ");
        if (andIndex != -1) {
            subTablewhereSb = subTablewhereSb.replace(andIndex, andIndex + "and ".length(), "");
        }
        if (!StringUtil.checkNull(subTablewhereSb.toString().trim())) {
            if (!StringUtil.checkNull(whereSb.toString().trim())) {
                whereSb = subTablewhereSb.append(" and ").append(whereSb);
            } else {
                whereSb = whereSb.append(subTablewhereSb);
            }
        }
        if (!StringUtil.checkNull(whereSb.toString().trim())) {
            sql.append(" where ");
            sql.append(whereSb.toString());
        }
        //sql.append(sortFields);
        return sql.toString();
    }

    /*@Override
    public FlipInfo getFormMasterDataListByFormId(FlipInfo flipInfo,
            Map<String, Object> params) throws BusinessException, SQLException{
        Long formId = Long.parseLong(params.get("formId") + "");
        Long formTemplateId = Long.parseLong(params.get("formTemplateId")==null?"0":params.get("formTemplateId")+"");

        FormBean formBean = formCacheManager.getForm(formId.longValue());
        FormTableBean masterTableBean = formBean.getMasterTableBean();
        FormBindBean bindBean = formBean.getBind();
        List<FormBindAuthBean> bindAuthList = bindBean.getUnflowFormBindAuthByUserId(-4184608372420817817l);
        FormBindAuthBean firstFormBindAuthBean = null;
        //关联无流程表单列表不需templateId,循环所有有权限的模板，使用第一个模板的列头，排序，查询配置，组合所有模板的操作范围
        if (formTemplateId == null || formTemplateId.longValue() == 0) {
            for (int i = 0; i < bindAuthList.size(); i++) {
                FormBindAuthBean bindAuth = bindAuthList.get(i);
                if (i == 0) {
                    firstFormBindAuthBean = bindAuth;
                }
            }
        } else {//基础数据、信息管理列表需要传递templateId
            firstFormBindAuthBean = bindBean.getFormBindAuthBean(String.valueOf(formTemplateId));
        }
        //用户自定义的需要查询的主表字段
        String[] customSelectFields = firstFormBindAuthBean.getFieldStr4SQL();
        //用户自定义排序字段
        String sortFields = firstFormBindAuthBean.getSortStr(masterTableBean.getTableName());
        //主表固定字段，需要查询出来
        String[] constantFields = Enums.MasterTableField.getKeys();
        for(int i=0;i<constantFields.length;i++){
            constantFields[i] = masterTableBean.getTableName()+"."+constantFields[i];
        }
        for(int i=0;i<customSelectFields.length;i++){
            if(customSelectFields[i].indexOf(".")==-1){
                customSelectFields[i] = masterTableBean.getTableName()+"."+customSelectFields[i];
            }
        }
        //将用户自定义查询字段和主表固定字段求和，就是sql需要查询的主表所有字段
        Set<String> fieldSet = new LinkedHashSet<String>();
        fieldSet.addAll(Arrays.asList(customSelectFields));
        fieldSet.addAll(Arrays.asList(constantFields));
        sortFields = " order by " +((sortFields==null||sortFields.equals(""))?masterTableBean.getTableName()+".start_date":sortFields)+" ";
        String[] fields = new String[fieldSet.size()];
        int j=0;
        for(String s:fieldSet){
            fields[j++] = s;
        }
        String fieldNames = StringUtils.arrayToString(fields);
        StringBuffer sql = new StringBuffer("");
        for(int i=0;i<bindAuthList.size();i++){
            FormBindAuthBean bind = bindAuthList.get(i);
            String tempSb = getSql4FormBindAuth(bind, fieldNames,sortFields, formBean, params);
            if(bindAuthList.size()==1){
                sql.append(tempSb).append(sortFields);
            }else{
                sql.append("(").append(tempSb).append(sortFields).append(")");
            }
            if(i!=bindAuthList.size()-1){
                sql.append(" union ");
            }
        }
        formDataDAO.selectMasterDataList(flipInfo, masterTableBean, sql.toString(),new ArrayList());
        //处理组织机构等id类型数据，这样列表里面显示出来的是显示值，如人员id对应应该显示人员姓名
        List<Map<String, Object>> formDataMasterList = flipInfo.getData();
        for (Map<String, Object> lineValues : formDataMasterList) {
            Iterator<String> it = lineValues.keySet().iterator();
            Map<String,Object> addedMap = new HashMap<String,Object>();
            while(it.hasNext()) {
                String key = it.next();
                FormFieldBean fieldBean = formBean.getFieldBeanByName(key);
                if (fieldBean != null) {
                    Object value = lineValues.get(key);
                    try {
                        Object[] objs = null;
                        if(fieldBean!=null){
                            objs = fieldBean.getDisplayValue(value);
                            lineValues.put(key, objs[1]);
                        }
                    } catch (Exception e) {
                        throw new BusinessException(e);
                    }
                }else{
                    fieldBean = MasterTableField.getFormFieldBean(key);
                    if(fieldBean!=null){
                        Object value = lineValues.get(key);
                        try {
                            Object[] objs = null;
                            objs = fieldBean.getDisplayValue(value);
                            lineValues.put(key, value);
                            //固定字段需要转换，但是前台判断需要固定字段原来的值，如创建人id，所以将显示列名字的下划线“_”替换成了空‘’
                            addedMap.put(key.replace("_", ""), objs[1]);
                        } catch (Exception e) {
                            throw new BusinessException(e);
                        }
                    }
                }
            }
            lineValues.putAll(addedMap);
        }
        return flipInfo;
    }*/
    @Override
    public FlipInfo getFormMasterDataListByFormId(FlipInfo flipInfo, Map<String, Object> params)
            throws BusinessException, SQLException {
        return this.getFormMasterDataListByFormId(flipInfo, params, false);
    }

    @Override
    public FlipInfo getFormMasterDataListByFormId(FlipInfo flipInfo, Map<String, Object> params, boolean forExport) throws BusinessException, SQLException {
        Long formId = Long.parseLong(params.get("formId") + "");
        FormBean formBean = formCacheManager.getForm(formId.longValue());
        String templateIdStr = String.valueOf(params.get("formTemplateId"));
        String auth = FormUtil.getUnflowFormAuth(formBean, templateIdStr);
        flipInfo = this.getFormDataList(flipInfo, params, formBean, false);
        //处理组织机构等id类型数据，这样列表里面显示出来的是显示值，如人员id对应应该显示人员姓名
        //OA-62881  表单信息管理和基础数据列表中隐藏字段显示了  调用查询已经实现的接口完成
        FormUtil.setShowValueList(formBean, auth, flipInfo.getData(), forExport, true);
        return flipInfo;
    }

    /**
     * 查询无流程数据，主要供无流程栏目选择单据时调用
     *
     * @param flipInfo
     * @param params
     * @param reverse  排序是否反转，用来控制取第一条或者最后一条数据,将原先正常情况下的最后一条数据变成第一条数据
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    @Override
    public FlipInfo getFormData4SingleData(FlipInfo flipInfo, Map<String, Object> params, boolean reverse) throws BusinessException {
        Long formId = Long.parseLong(params.get("formId") + "");
        FormBean formBean = formCacheManager.getForm(formId.longValue());
        this.getFormDataList(flipInfo, params, formBean, reverse);
        String auth = FormUtil.getUnflowFormAuth(formBean, null);
        //处理组织机构等id类型数据，这样列表里面显示出来的是显示值，如人员id对应应该显示人员姓名
        //OA-62881  表单信息管理和基础数据列表中隐藏字段显示了  调用查询已经实现的接口完成
        FormUtil.setShowValueList(formBean, auth, flipInfo.getData(), false, true);
        return flipInfo;
    }

    /**
     * 查询表单列表数据
     *
     * @param flipInfo
     * @param params
     * @param reverse  排序是否反转，用来控制取第一条或者最后一条数据,将原先正常情况下的最后一条数据变成第一条数据
     * @return
     * @throws BusinessException
     */
    private FlipInfo getFormDataList(FlipInfo flipInfo, Map<String, Object> params, FormBean formBean, boolean reverse) throws BusinessException {
        Long currentUserId = AppContext.currentUserId();
        boolean isNeedPage = true;
        FormQueryTypeEnum queryType = FormQueryTypeEnum.infoManageQuery;
        FormQueryWhereClause customCondition = getCustomConditionFormQueryWhereClause(formBean, params);
        //M3无流程支持自定义排序20170214
        List<Map<String, Object>> customOrderBy = (List<Map<String,Object>>)params.get("userOrderBy");
        String[] customShowFields = new String[]{};

        FormQueryWhereClause relationSqlWhereClause = getRelationConditionFormQueryWhereClause(formBean, params);

        Long templeteId = Long.parseLong(Strings.isBlank(String.valueOf(params.get("formTemplateId") == null ? "" : params.get("formTemplateId"))) ? "0" : params.get("formTemplateId") + "");
        FormQueryResult queryResult = getFormQueryResult(currentUserId, flipInfo, isNeedPage, formBean, templeteId, queryType,
                customCondition, customOrderBy, customShowFields, relationSqlWhereClause, reverse);
        return queryResult.getFlipInfo();
    }

    public FormQueryWhereClause getRelationConditionFormQueryWhereClause(FormBean formBean, Map<String, Object> params) {
        try {
            String fromFormIdStr = ParamUtil.getString(params, "fromFormId");
            if (Strings.isNotBlank(fromFormIdStr)) {
                Long fromFormId = ParamUtil.getLong(params, "fromFormId");
                Long fromRecordId = ParamUtil.getLong(params, "fromRecordId");
                Long fromDataId = ParamUtil.getLong(params, "fromDataId");
                String fromRelationAttrStr = ParamUtil.getString(params, "fromRelationAttr");

                FormBean fromForm = formCacheManager.getForm(fromFormId);
                FormDataMasterBean fromData = formManager.getSessioMasterDataBean(fromDataId);
                FormFieldBean fromRelationAttr = fromForm.getFieldBeanByName(fromRelationAttrStr);
                FormFormulaBean conditionFormFormulaBean = this.changeFormFormulaBean(fromForm, fromData, fromRecordId, fromRelationAttr);
                if (null != conditionFormFormulaBean) {
                    AppContext.putThreadContext("isRelationCondition", true);//添加线程变量，用于判断是不是关联sql生成，主要用来判断多部门include的情况
                    FormQueryWhereClause whereClause = conditionFormFormulaBean.getExecuteFormulaForWhereClauseSQL(formBean, true, true);
                    AppContext.removeThreadContext("isRelationCondition");
                    String relationSql = whereClause.getAllSqlClause();
                    if (!StringUtil.checkNull(relationSql)) {
                        for (FormTableBean table : formBean.getTableList()) {
                            String tablePrefix = FormBean.R_PREFIX + Functions.substringAfter(table.getTableName(), "_");
                            if (relationSql.indexOf(tablePrefix) != -1) {
                                relationSql = relationSql.replace(tablePrefix, table.getTableName());
                            }
                        }
                    }
                    whereClause.setAllSqlClause(relationSql);
                    return whereClause;
                }
            }
        } catch (Exception e) {
            LOGGER.info("", e);
        }
        return null;
    }

    /**
     * 获得自定义查询sql对象：条件和参数
     *
     * @param formBean
     * @param customParams
     * @return
     */
    private FormQueryWhereClause getCustomConditionFormQueryWhereClause(FormBean formBean, Map<String, Object> customParams) {
        FormQueryWhereClause whereClause = new FormQueryWhereClause();
        StringBuilder sb = new StringBuilder("");
        List<Object> queryParams = new ArrayList<Object>();
        //增加查询条件
        Iterator<String> ite = customParams.keySet().iterator();
        while (ite.hasNext()) {
            String key = ite.next();
            if (customParams.get(key) == null || Strings.isBlank(String.valueOf(customParams.get(key)))) {
                continue;
            }
            if (!"sortStr".equals(key) && !"formId".equals(key) && !"formTemplateId".equals(key)
                    && !"fromFormId".equals(key) && !"fromDataId".equals(key) && !"fromRecordId".equals(key)
                    && !"fromRelationAttr".equals(key) && !"userOrderBy".equals(key)) {
                if ("highquery".equals(key)) {
                    List<Map<String, Object>> tempList = new ArrayList<Map<String, Object>>();
                    Object temO = customParams.get(key);
                    if (temO instanceof Map) {
                        tempList.add((Map) temO);
                    } else {
                        tempList.addAll((List) temO);
                    }
                    FormQueryWhereClause myWhereClause = FormUtil.getSQLStrWhereClause(tempList, formBean, true);
                    if (null != myWhereClause && Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                        sb.append(myWhereClause.getAllSqlClause());
                    }
                    if (null != myWhereClause && null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                        queryParams.addAll(myWhereClause.getQueryParams());
                    }
                } else {
                    try {
                        FormQueryWhereClause myWhereClause = getQuerySql4ConditionWhereClause(formBean, key, customParams.get(key));
                        if (null != myWhereClause) {
                            if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                sb.append(myWhereClause.getAllSqlClause());
                            }
                            if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                queryParams.addAll(myWhereClause.getQueryParams());
                            }
                        }
                    } catch (Exception e) {
                        LOGGER.error("getQuerySql4Condition error", e);
                    }
                }
            }
        }
        whereClause.setQueryParams(queryParams);
        whereClause.setAllSqlClause(sb.toString());
        return whereClause;
    }

    /**
     * 处理查询需要的SQL
     *
     * @param formTemplateId
     * @param formBean
     * @param params
     * @param pa
     * @return
     * @throws BusinessException
     */
    private String getFormMasterDataListSql(FormBean formBean, Map<String, Object> params, List pa) throws BusinessException {
        Long formTemplateId = Long.parseLong(Strings.isBlank(String.valueOf(params.get("formTemplateId"))) ? "0" : params.get("formTemplateId") + "");
        StringBuffer sql = new StringBuffer("");
        FormTableBean masterTableBean = formBean.getMasterTableBean();
        FormBindBean bindBean = formBean.getBind();
        List<FormBindAuthBean> bindAuthList = null;
        if (formBean.getFormType() == FormType.baseInfo.getKey()) {
            bindAuthList = new ArrayList<FormBindAuthBean>();
            bindAuthList.add(bindBean.getUnFlowTemplateMap().values().iterator().next());
        } else {
            bindAuthList = bindBean.getUnflowFormBindAuthByUserId(AppContext.currentUserId());
        }
        if (formTemplateId == null || formTemplateId.longValue() == 0) {
            int size = bindAuthList.size();
            boolean multiBinds = (size == 1) ? false : true;
            String[] bindSqls = new String[size];
            FormBindAuthBean firstFormBindAuthBean = null;
            for (int i = 0; i < size; i++) {
                StringBuilder userCondition = new StringBuilder("");
                FormBindAuthBean bindAuth = bindAuthList.get(i);
                if (i == 0) {
                    firstFormBindAuthBean = bindAuth;
                }
                FormFormulaBean formulaBean = bindAuth.getFormFormulaBean();
                if (formulaBean != null) {
                    userCondition.append(FormulaUtil.procReplaceNull(formulaBean.getExecuteFormulaForSQL()));
                } else {
                    userCondition = new StringBuilder("");
                }
                bindSqls[i] = getSqlForOneBind(formBean, firstFormBindAuthBean, userCondition, params, pa, multiBinds).toString();
            }
            //用union合并结果集
            if (multiBinds) {
                sql.append(" select * from (");
                for (int i = 0; i < size; i++) {
                    sql.append(" ").append(bindSqls[i]).append(" ");
                    if (i != size - 1) {
                        sql.append(" union ");
                    }
                }
                sql.append(" ) ").append(masterTableBean.getTableName()).append(" ");
                String sortFields = firstFormBindAuthBean.getSortStr(masterTableBean.getTableName());
                //sqlserver下面order by字段不能重复，要判断是否有创建时间
                sortFields = " order by " + (Strings.isBlank(sortFields) ? "" : sortFields + ",");
                if (!sortFields.contains("start_date")) {
                    sortFields += masterTableBean.getTableName() + ".start_date,";
                }
                sortFields += masterTableBean.getTableName() + ".id ";
                sql.append(sortFields);
            } else {
                sql.append(bindSqls[0]);
            }
        } else {
            //基础数据、信息管理列表需要传递templateId
            FormBindAuthBean firstFormBindAuthBean = bindBean.getFormBindAuthBean(String.valueOf(formTemplateId));
            StringBuilder userCondition = new StringBuilder("");
            FormFormulaBean formulaBean = firstFormBindAuthBean.getFormFormulaBean();
            if (formulaBean != null) {
                userCondition.append(FormulaUtil.procReplaceNull(formulaBean.getExecuteFormulaForSQL()));
            }
            sql.append(getSqlForOneBind(formBean, firstFormBindAuthBean, userCondition, params, pa, false));
        }
        return sql.toString().replace("<> null", "is not null");
    }

    /**
     * 查询一下一个授权下的的数据(不能用合并sql的情况，主表与从表情况下，会少主表有数据从表无数据的情况)
     *
     * @param formBean
     * @param firstFormBindAuthBean
     * @param userCondition
     * @param flipInfo
     * @param params
     * @return
     */
    private StringBuffer getSqlForOneBind(FormBean formBean, FormBindAuthBean firstFormBindAuthBean, StringBuilder userCondition, Map<String, Object> params, List pa, boolean multiBinds) {
        FormTableBean masterTableBean = formBean.getMasterTableBean();
        List<FormTableBean> subTables = formBean.getSubTableBean();
        List<FormFieldBean> allFields = formBean.getAllFieldBeans();
        StringBuffer whereSb = new StringBuffer("");
        StringBuffer subTablewhereSb = new StringBuffer("");
        if (!StringUtil.checkNull(userCondition.toString())) {
            for (FormFieldBean fieldBean : allFields) {
                int index = userCondition.indexOf(fieldBean.getName());
                if (index != -1) {
                    userCondition = userCondition.replace(index, index + fieldBean.getName().length(), fieldBean.getOwnerTableName() + "." + fieldBean.getName());
                }
            }
            whereSb.append(" (");
            whereSb.append(userCondition);
            whereSb.append(") ");
        }

        String changeFormFormulaSQL = this.getChangeFormFormulaSQL(formBean, params);
        whereSb.append(changeFormFormulaSQL);

        //增加查询条件
        Iterator<String> ite = params.keySet().iterator();
        while (ite.hasNext()) {
            String key = ite.next();
            if (params.get(key) == null || Strings.isBlank(String.valueOf(params.get(key)))) {
                continue;
            }
            if (!"sortStr".equals(key) && !"formId".equals(key) && !"formTemplateId".equals(key) && !"fromFormId".equals(key) && !"fromDataId".equals(key) && !"fromRecordId".equals(key) && !"fromRelationAttr".equals(key)) {
                StringBuffer conditionSb = new StringBuffer("");
                if ("highquery".equals(key)) {
                    List<Map<String, Object>> tempList = new ArrayList<Map<String, Object>>();
                    Object temO = params.get(key);
                    if (temO instanceof Map) {
                        tempList.add((Map) temO);
                    } else {
                        tempList.addAll((List) temO);
                    }
                    Object[] o = FormUtil.getSQLStr(tempList, formBean);
                    pa.addAll((List) o[1]);
                    conditionSb.append(o[0]);
                } else {
                    try {
                        conditionSb.append(getQuerySql4Condition(formBean, pa, key, params.get(key)));
                    } catch (Exception e) {
                        LOGGER.error("getQuerySql4Condition error", e);
                    }
                }
                if (!StringUtil.checkNull(whereSb.toString().trim())
                        && !StringUtil.checkNull(conditionSb.toString().trim())) {
                    whereSb.append(" and ");
                }
                if (!StringUtil.checkNull(conditionSb.toString().trim())) {
                    whereSb.append(conditionSb);
                }
            }
        }
        String[] showFields = firstFormBindAuthBean.getFieldStr4SQL();
        String[] constFieldStrs = MasterTableField.getKeys();
        for (int i = 0; i < constFieldStrs.length; i++) {
            constFieldStrs[i] = masterTableBean.getTableName() + "." + constFieldStrs[i];
        }
        for (int i = 0; i < showFields.length; i++) {
            if (showFields[i].indexOf(".") == -1) {
                showFields[i] = masterTableBean.getTableName() + "." + showFields[i];
            }
        }
        Set<String> fieldSet = new LinkedHashSet<String>();
        fieldSet.addAll(Arrays.asList(showFields));
        fieldSet.addAll(Arrays.asList(constFieldStrs));
        StringBuffer from = new StringBuffer(" ");
        String sortFields = firstFormBindAuthBean.getSortStr(masterTableBean.getTableName());
        //sqlserver下面order by字段不能重复，要判断是否有创建时间
        sortFields = " order by " + (Strings.isBlank(sortFields) ? "" : sortFields + ",");
        if (!sortFields.contains("start_date")) {
            sortFields += masterTableBean.getTableName() + ".start_date,";
        }
        sortFields += masterTableBean.getTableName() + ".id";

        String[] fields = new String[fieldSet.size()];
        int j = 0;
        for (String s : fieldSet) {
            fields[j++] = s;
        }
        String fieldNames = StringUtils.arrayToString(fields);
        StringBuffer sql = new StringBuffer(" select DISTINCT ");
        sql.append(fieldNames);
        sql.append(" from ").append(masterTableBean.getTableName());
        for (FormFieldBean fieldBean : allFields) {
            if (fieldBean.isConstantField() || fieldBean.isMasterField()) {
                continue;
            }
            //判断select后边的字符串中是否包含子表字段，如果有，则from后边需要跟子表名字
            if (from.indexOf(fieldBean.getOwnerTableName()) == -1 && sql.indexOf(fieldBean.getName()) != -1) {
                from.append(",").append(fieldBean.getOwnerTableName());
            }
            //判断where后边的字符串中是否包含子表字段，如果有，则from后边需要跟子表名字
            if (from.indexOf(fieldBean.getOwnerTableName()) == -1 && whereSb.indexOf(fieldBean.getName()) != -1) {
                from.append(",").append(fieldBean.getOwnerTableName());
            }
            //判断sortFields后边的字符串中是否包含子表字段，如果有，则from后边需要跟子表名字
            if (from.indexOf(fieldBean.getOwnerTableName()) == -1 && sortFields.indexOf(fieldBean.getName()) != -1) {
                from.append(",").append(fieldBean.getOwnerTableName());
            }
        }
        sql.append(from);
        for (int i = 0; i < subTables.size(); i++) {
            if (subTables.get(i).isMainTable()) {
                continue;
            }
            if (sql.indexOf(subTables.get(i).getTableName()) != -1
                    && subTablewhereSb.indexOf(subTables.get(i).getTableName()) == -1) {
                subTablewhereSb.append(" (").append(subTables.get(i).getTableName()).append(".")
                        .append(SubTableField.formmain_id.getKey()).append("=")
                        .append(formBean.getMasterTableBean().getTableName()).append(".")
                        .append(MasterTableField.id.getKey()).append(") ");
                subTablewhereSb.append(" and ");
            }
        }
        int andIndex = subTablewhereSb.lastIndexOf("and ");
        if (andIndex != -1) {
            subTablewhereSb = subTablewhereSb.replace(andIndex, andIndex + "and ".length(), "");
        }
        if (!StringUtil.checkNull(subTablewhereSb.toString().trim())) {
            whereSb = subTablewhereSb.append(" and ").append(whereSb);
        }
        if (!StringUtil.checkNull(whereSb.toString().trim())) {
            sql.append(" where ");
            sql.append(FormUtil.changeAndAddNullWhereSql(whereSb.toString()));
        }
        andIndex = sql.lastIndexOf("and ");
        if (andIndex != -1 && andIndex == (sql.length() - "and ".length())) {
            sql = sql.replace(andIndex, andIndex + "and ".length(), "");
        }
        if (!multiBinds) {
            sql.append(" " + sortFields);
        }
        return sql;
    }

    public String getChangeFormFormulaSQL(FormBean formBean, Map<String, Object> params) {
        StringBuffer whereSb = new StringBuffer("");
        try {
            String fromFormIdStr = (String) params.get("fromFormId");
            if (!StringUtil.checkNull(fromFormIdStr)) {
                Long fromFormId = Long.valueOf(fromFormIdStr);
                FormBean fromForm = formCacheManager.getForm(fromFormId);
                FormDataMasterBean fromData = formManager.getSessioMasterDataBean(ParamUtil.getLong(params, "fromDataId"));
                Long fromRecordId = ParamUtil.getLong(params, "fromRecordId");
                FormFieldBean fromRelationAttr = fromForm.getFieldBeanByName(ParamUtil.getString(params, "fromRelationAttr"));

                FormFormulaBean conditionFormFormulaBean = this.changeFormFormulaBean(fromForm, fromData, fromRecordId, fromRelationAttr);
                String relationSql = "";
                if (null != conditionFormFormulaBean) {
                    relationSql = conditionFormFormulaBean.getExecuteFormulaForSQL();
                }

                if (!StringUtil.checkNull(relationSql)) {
                    relationSql = FormUtil.changeEnumFieldsCompare(formBean, relationSql, true);
                    relationSql = FormUtil.changeNullWhereSql(relationSql);
                    //防止前端关联条件拷贝，导致报错，做个兼容
                    boolean isReplace = false;
                    for (FormTableBean table : formBean.getTableList()) {
                        String tablePrefix = FormBean.R_PREFIX + Functions.substringAfter(table.getTableName(), "_");
                        if (relationSql.indexOf(tablePrefix) != -1) {
                            relationSql = relationSql.replace(tablePrefix, table.getTableName());
                            isReplace = true;
                        }
                    }
                    if (!isReplace && Strings.isNotBlank(relationSql)) {//需要进行兼容处理
                        StringBuffer sb = new StringBuffer();
                        Pattern p = Pattern.compile("(b[0-9]{4})\\.(field[0-9]{4})");
                        Matcher matcher = p.matcher(relationSql);
                        while (matcher.find()) {
                            String group2 = matcher.group(2).trim();// FIELD

                            FormTableBean myTableBean = formBean.getFormTableBeanByFieldName(group2);
                            if (null != myTableBean) {
                                String myTableName = myTableBean.getTableName();
                                matcher.appendReplacement(sb, myTableName + "." + group2);
                            }
                        }
                        matcher.appendTail(sb);
                        relationSql = sb.toString();
                    }

                    if (!StringUtil.checkNull(whereSb.toString().trim())) {
                        whereSb.append(" and ");
                    }
                    whereSb.append(" (");
                    whereSb.append(relationSql);
                    whereSb.append(") ");
                }
            }
        } catch (Exception e) {
            LOGGER.error("", e);
        }
        return whereSb.toString();
    }

    /**
     * 处理某一个关联表单字段的过滤条件
     *
     * @param fromForm
     * @param fromData
     * @param fromRecordId
     * @param fromRelationAttr
     * @return
     * @throws Exception
     */
    private FormFormulaBean changeFormFormulaBean(FormBean fromForm, FormDataMasterBean fromData, Long fromRecordId, FormFieldBean fromRelationAttr) throws Exception {
        if (null == fromRelationAttr.getFormRelation().getViewConditionId()) {//没有设置过滤条件时这儿为空要做防护
            return null;
        }
        FormFormulaBean formFormulaBean = formCacheManager.loadFormFormulaBean(fromForm, fromRelationAttr.getFormRelation().getViewConditionId());
        FormFormulaBean conditionFormFormulaBean = (FormFormulaBean) formFormulaBean.clone();
        List<FormulaBaseBean> formulaBaseBeans = conditionFormFormulaBean.getFormulaBeanList();
        List<FormulaBaseBean> replaceFormulaBaseBeans = new ArrayList<FormulaBaseBean>();

        String masterTableName = fromForm.getMasterTableBean().getTableName();
        String masterTablePre = FormBean.M_PREFIX + Functions.substringAfter(masterTableName, "_");
        String subTableName = "";
        String subTablePre = "";
        if (!fromRelationAttr.isMasterField()) {
            subTableName = fromRelationAttr.getOwnerTableName();
            subTablePre = FormBean.M_PREFIX + Functions.substringAfter(subTableName, "_");
        }

        for (FormulaBaseBean formulaBaseBean : formulaBaseBeans) {
            if (formulaBaseBean instanceof FormulaDataFieldBean) {
                FormulaBaseBean changeBean = this.changeFormulaBaseBean(conditionFormFormulaBean, (FormulaDataFieldBean) formulaBaseBean, fromForm, fromData, fromRecordId, masterTablePre, subTableName, subTablePre);
                replaceFormulaBaseBeans.add(changeBean);
            } else if (formulaBaseBean instanceof FormulaFunctionBean) {
                List<FormulaBaseBean> temp = ((FormulaFunctionBean) formulaBaseBean).getList();
                List<FormulaBaseBean> list = new ArrayList<FormulaBaseBean>();
                for (FormulaBaseBean tempBean : temp) {
                    if (tempBean instanceof FormulaDataFieldBean) {
                        AppContext.putThreadContext("isFromFunction",true);
                        FormulaBaseBean changeBean = this.changeFormulaBaseBean(conditionFormFormulaBean, (FormulaDataFieldBean) tempBean, fromForm, fromData, fromRecordId, masterTablePre, subTableName, subTablePre);
                        AppContext.removeThreadContext("isFromFunction");
                        list.add(changeBean);
                    } else {
                        list.add(tempBean);
                    }
                }
                ((FormulaFunctionBean) formulaBaseBean).setList(list);
                replaceFormulaBaseBeans.add(formulaBaseBean);
            } else {
                replaceFormulaBaseBeans.add(formulaBaseBean);
            }
        }
        conditionFormFormulaBean.setFormulaBeanList(replaceFormulaBaseBeans);

        return conditionFormFormulaBean;
    }

    /**
     * 替换关联表单的过滤条件里面的当前表变量
     * @param formFormulaBean
     * @param formulaDataFieldBean
     * @param fromForm
     * @param fromData
     * @param fromRecordId
     * @param masterTablePre
     * @param subTableName
     * @param subTablePre
     * @return
     * @throws BusinessException
     */
    private FormulaBaseBean changeFormulaBaseBean(FormFormulaBean formFormulaBean, FormulaDataFieldBean formulaDataFieldBean, FormBean fromForm, FormDataMasterBean fromData, Long fromRecordId, String masterTablePre, String subTableName, String subTablePre) throws BusinessException {
        String value = formulaDataFieldBean.getValue();
        if (value.contains(masterTablePre) || (Strings.isNotBlank(subTablePre) && value.contains(subTablePre))) {
            String fieldName = value.substring(value.indexOf(".") + 1, value.length());
            FormFieldBean field = fromForm.getFieldBeanByName(fieldName);
            if (field == null) {//固定字段
                field = MasterTableField.getEnumByKey(fieldName).getFormFieldBean();
            }
            String fieldValue = "";
            if (field.isMasterField()) {
                fieldValue = formatSqlParm(field, fromData);
            } else {
                FormDataSubBean subBean = fromData.getFormDataSubBeanById(subTableName, fromRecordId);
                fieldValue = formatSqlParm(field, subBean);
            }
            if (field.getFieldType().equals(FieldType.DECIMAL.getKey())) {
                if (StringUtil.checkNull(fieldValue)) {
                    fieldValue = "0";//为空按默认值处理
                }
            } else if (field.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                if (StringUtil.checkNull(fieldValue)) {
                    fieldValue = FormulaFunctionUitl.DEFAULT_DATE;//为空按默认值处理
                }
                fieldValue = FunctionSymbol.to_date.getKey() + "('" + fieldValue + "')";
            } else if (field.getFieldType().equals(FieldType.DATETIME.getKey())) {
                if (StringUtil.checkNull(fieldValue)) {
                    fieldValue = FormulaFunctionUitl.DEFAULT_DATE_TIME;//为空按默认值处理
                }
                fieldValue = FunctionSymbol.to_date.getKey() + "('" + fieldValue + "')";
            } else {
                if (!StringUtil.checkNull(fieldValue)) {
                    fieldValue = "'" + fieldValue + "'";
                }
            }

            FormulaValueBean newBean = formFormulaBean.new FormulaValueBean();
            newBean.setValue(fieldValue);
            return newBean;
        } else {
            return formulaDataFieldBean;
        }
    }

    /**
     * 格式化字段的值，如果没有，则赋上默认值（主要针对日期和日期时间字段）
     *
     * @param field
     * @param fromData
     * @return
     */
    private String formatSqlParm(FormFieldBean field, FormDataBean fromData) {
        String fieldValue;
        Object obj = fromData.getFieldValue(field.getName());
        if (field.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
            if (StringUtil.checkNull(String.valueOf(obj))) {
                fieldValue = FormulaFunctionUitl.DEFAULT_DATE;//为空按默认值处理
            } else {
                if (obj instanceof Date) {
                    fieldValue = DateUtil.format((Date) obj, DateUtil.YEAR_MONTH_DAY_PATTERN);
                } else {
                    fieldValue = String.valueOf(obj);
                }
            }
        } else if (field.getFieldType().equals(FieldType.DATETIME.getKey())) {
            if (StringUtil.checkNull(String.valueOf(obj))) {
                fieldValue = FormulaFunctionUitl.DEFAULT_DATE_TIME;//为空按默认值处理
            } else {
                if (obj instanceof Date) {
                    fieldValue = DateUtil.formatDateTime((Date) obj);
                } else {
                    fieldValue = String.valueOf(obj);
                }
            }
        } else {
            fieldValue = String.valueOf(obj);
            //OA-109919表单关联过滤条件，对于in函数，目前过滤有点问题，包含了子部门，正常应默认不包含子部门
            String fromFunction = String.valueOf(AppContext.getThreadContext("isFromFunction"));
            if ("true".equals(fromFunction) && FormFieldComEnum.EXTEND_DEPARTMENT == FormFieldComEnum.getEnumByKey(field.getFinalInputType(true))) {
                if(Strings.isNotBlank(fieldValue)){
                    String[] str = fieldValue.split(",");
                    fieldValue = "";
                    for(String id:str){
                        fieldValue += id +"|1,";
                    }
                    if(fieldValue.endsWith(",")){
                        fieldValue = fieldValue.substring(0,fieldValue.length()-1);
                    }
                }
            }
        }
        return fieldValue;
    }

    /**
     * @param pa
     * @param key
     * @param values
     * @return
     * @throws Exception
     */
    private String getQuerySql4Condition(FormBean formBean, List pa, String key, Object values) throws Exception {
        StringBuffer conditionSb = new StringBuffer("");
        if (values instanceof List) {//日期
            List<String> v = (List<String>) values;
            if (v.size() == 2 && (Strings.isNotBlank(v.get(0)) || Strings.isNotBlank(v.get(1)))) {
                String mValue = v.get(0);
                String maxValue = v.get(1);
                if (Strings.isNotBlank(mValue)) {
                    Object mo = (mValue.length() < 12) ? DateUtil.parseTimestamp(mValue + " 00:00:00", "yyyy-MM-dd HH:mm:ss") : DateUtil.parseTimestamp(mValue, "yyyy-MM-dd HH:mm");
                    conditionSb.append(" ").append(key).append(" >= ? ");
                    pa.add(mo);
                }
                if (Strings.isNotBlank(maxValue)) {
                    if (Strings.isNotBlank(mValue)) {
                        conditionSb.append("and");
                    }
                    Object mo = (mValue.length() < 12) ? DateUtil.parseTimestamp(maxValue + " 23:59:59", "yyyy-MM-dd HH:mm:ss") : DateUtil.parseTimestamp(maxValue, "yyyy-MM-dd HH:mm");
                    conditionSb.append(" ").append(key).append(" <= ? ");
                    pa.add(mo);
                }
            }
        } else if (values instanceof Map) {
            Map v = (Map) values;
            List list = new ArrayList();
            list.add(v);
            Object[] o = FormUtil.getSQLStr(list, formBean);
            if (!"".equals(o[0])) {
                pa.addAll((List) o[1]);
                conditionSb.append(o[0]);
            }
        } else {
            String v = String.valueOf(values);
            conditionSb.append(" ").append(key).append(" <= ? ");
            pa.add(v);
        }
        return conditionSb.toString();
    }

    /**
     * 获得自定义查询sql
     *
     * @param formBean
     * @param queryParams
     * @param key
     * @param values
     * @return
     * @throws Exception
     */
    private FormQueryWhereClause getQuerySql4ConditionWhereClause(FormBean formBean, String key, Object values) throws Exception {
        FormFieldBean formFieldBean = formBean.getFieldBeanByName(key);
        String tableName = "";
        if (formFieldBean != null) {
            tableName = formFieldBean.getOwnerTableName() + ".";
        } else {
            tableName = formBean.getMasterTableBean().getTableName() + ".";
        }
        StringBuffer conditionSb = new StringBuffer("");
        List<Object> queryParams = new ArrayList<Object>();
        if (values instanceof List) {//日期
            List<String> v = (List<String>) values;
            if (v.size() == 2 && (Strings.isNotBlank(v.get(0)) || Strings.isNotBlank(v.get(1)))) {
                String mValue = v.get(0);
                String maxValue = v.get(1);
                if (Strings.isNotBlank(mValue)) {
                    Object mo = (mValue.length() < 12) ? DateUtil.parseTimestamp(mValue + " 00:00:00", "yyyy-MM-dd HH:mm:ss") : DateUtil.parseTimestamp(mValue, "yyyy-MM-dd HH:mm");
                    conditionSb.append(" ").append(tableName).append(key).append(" >= ? ");
                    queryParams.add(mo);
                }
                if (Strings.isNotBlank(maxValue)) {
                    if (Strings.isNotBlank(mValue)) {
                        conditionSb.append("and");
                    }
                    Object mo = (maxValue.length() < 12) ? DateUtil.parseTimestamp(maxValue + " 23:59:59", "yyyy-MM-dd HH:mm:ss") : DateUtil.parseTimestamp(maxValue, "yyyy-MM-dd HH:mm");
                    conditionSb.append(" ").append(tableName).append(key).append(" <= ? ");
                    queryParams.add(mo);
                }
            }
        } else if (values instanceof Map) {
            Map v = (Map) values;
            List list = new ArrayList();
            list.add(v);
            FormQueryWhereClause myWhereClause = FormUtil.getSQLStrWhereClause(list, formBean, true);
            if (null != myWhereClause && Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                conditionSb.append(myWhereClause.getAllSqlClause());
            }
            if (null != myWhereClause && null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                queryParams.addAll(myWhereClause.getQueryParams());
            }
        } else {
            String v = String.valueOf(values);
            conditionSb.append(" ").append(tableName).append(key).append(" <= ? ");
            queryParams.add(v);
        }
        FormQueryWhereClause whereClause = new FormQueryWhereClause();
        whereClause.setAllSqlClause(conditionSb.toString());
        whereClause.setQueryParams(queryParams);
        return whereClause;
    }

    @Override
    public void updateDataState(ColSummary colSummary, CtpAffair affair, ColHandleType type, List<Comment> list)
            throws BusinessException, SQLException {
        FormBean formBean = formCacheManager.getForm(colSummary.getFormAppid());
        LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 数据ID：" + colSummary.getFormRecordid() + " 操作类型是：" + type.name());
        List<FormFieldBean> fieldBeans = formBean.getFieldsByType(FormFieldComEnum.FLOWDEALOPITION);
        Map<String, Object> map = new HashMap<String, Object>();
        TriggerConditionState conditionState = null;

        Map<String, Object> subMap;
        Map<String, Map<String, Object>> tableDataMap = new HashMap<String, Map<String, Object>>();
        Map<String, List<String>> needDeleteRelationRecordMap = new HashMap<String, List<String>>();
        List<String> tempList;
        boolean needTrigger = false;
        boolean needFillBackDealOpition = false;
        boolean needCalcAll = false;
        boolean needAddRelationAuth = false;
        switch (type) {
            case save://保存待发
                this.getStateMap(map, false, colSummary.getStartMemberId(), DateUtil.currentTimestamp(),true);
                break;
            case send://发送
            case autosend://自动发起
                needTrigger = true;
                conditionState = TriggerConditionState.FlowSend;
                if (this.isChildrenWorkFlow(colSummary)) {
                    needTrigger = false;
                }
                //子流程发起不更新创建时间和创建人
                this.getStateMap(map, true, colSummary.getStartMemberId(), DateUtil.currentTimestamp(),needTrigger);
                break;
            case wait://暂存待办
                needFillBackDealOpition = true;
                needTrigger = true;
                conditionState = TriggerConditionState.FlowSend;
                break;
            case finish://正常提交
                //正常提交时，先给出默认状态值，然后根据是审核和核定给对应的值
                //子流程除了核定或者审核通过，都不修改状态为未审核状态 OA-59367
                if ((colSummary.getNewflowType() == null || colSummary.getNewflowType() != 1) && (colSummary.isAudited() == null || !colSummary.isAudited())) { //如果已经审核通过了，则不在修改状态为默认状态
                    this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_UNAUDITED.getKey(), AppContext.currentUserId(), DateUtil.currentTimestamp());
                }
                LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 操作类型是：" + type.name() + "提交处理");
                conditionState = TriggerConditionState.FlowSend;

                //审核
                if (AUDIT.equals(affair.getNodePolicy())) {
                    //审核通过
                    if (colSummary.isAudited()) {
                        this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_AUDITEDPASS.getKey(), AppContext.currentUserId(), DateUtil.currentTimestamp());
                        LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 操作类型是：" + type.name() + "审核通过");
                        //审核不通过
                    } else {
                        this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_AUDITEDUNPASS.getKey(), AppContext.currentUserId(), DateUtil.currentTimestamp());
                    }
                    needCalcAll = true;
                }
                //核定
                else if (vouch.equals(affair.getNodePolicy())) {
                    //核定通过
                    if (Strings.equals(colSummary.getVouch(), 1)) {
                        this.getStateMap(map, UpdateDataType.FORM_VOUCH, FormDataRatifyFlagEnum.FLOW_VOUCHPASS.getKey(), AppContext.currentUserId(), DateUtil.currentTimestamp());
                        conditionState = TriggerConditionState.FlowState_Ratify;
                        needAddRelationAuth = true;
                        LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 操作类型是：" + type.name() + "核定通过");
                        //核定不通过
                    } else {
                        this.getStateMap(map, UpdateDataType.FORM_VOUCH, FormDataRatifyFlagEnum.FLOW_VOUCHUNPASS.getKey(), AppContext.currentUserId(), DateUtil.currentTimestamp());
                    }
                    needCalcAll = true;
                }

                needTrigger = true;
                needFillBackDealOpition = true;
                break;
            case stepBack://回退
                //上一节点是审核，设置状态为未审核
                if (AUDIT.equals(affair.getNodePolicy())) {
                    needCalcAll = true;
                    this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_AUDITEDUNPASS.getKey(), 0l, DateUtil.currentTimestamp());
                }
                //上一节点是核定，设置状态为未核定
                else if (vouch.equals(affair.getNodePolicy())) {
                    needCalcAll = true;
                    this.getStateMap(map, UpdateDataType.FORM_VOUCH, FormDataRatifyFlagEnum.FLOW_VOUCHUNPASS.getKey(), 0l, DateUtil.currentTimestamp());
                }
                needFillBackDealOpition = true;
                break;
            case stepStop://终止
                if (!this.isChildrenWorkFlow(colSummary)) {
                    map.put(MasterTableField.finishedflag.getKey(), FromDataFinishedFlagEnum.STOP.getKey());
                }
                needCalcAll = true;
                try {
                    formTriggerManager.rollBack4FillBackTrigger(colSummary.getFormRecordid(), "stepStop");
                } catch (Exception e) {
                    LOGGER.error("终止预提数据还原报错", e);
                }
                needFillBackDealOpition = true;
                LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 操作类型是：" + type.name() + "流程终止");
                break;
            case repeal://撤销
                //撤销流程、回退到发起者节点都走的此分支
                this.getStateMap(map, false, colSummary.getStartMemberId(), DateUtil.currentTimestamp(),true);
                for (FormFieldBean formFieldBean : fieldBeans) {
                    map.put(formFieldBean.getName(), "");
                }
                String operationId = this.wapi.getNodeFormOperationNameFromRunning(colSummary.getProcessId(), null);
                if (Strings.isNotBlank(operationId)) {
                    FormAuthViewBean viewBean = formBean.getAuthViewBeanById(Long.parseLong(operationId));
                    //如果viewBean为null直接break;的话会导致后面的预提无法回滚
                    if (viewBean == null) {
                        LOGGER.error("流程撤销，获取到的权限为null，对应operationId = " + operationId);
                    } else {
                        List<FormAuthViewFieldBean> viewFieldBeans = viewBean.getFormAuthorizationFieldList();
                        FormFieldBean fieldBean;
                        for (FormAuthViewFieldBean avfb : viewFieldBeans) {
                            fieldBean = avfb.getFormFieldBean();
                            //计算式中含有流水号的，不清空
                            String serid = fieldBean.findSerialNumberIds4Formula();
                            if (Strings.isNotBlank(serid)) {
                                continue;
                            }
                            //默认值为流水号的，不清空
                            if (Strings.isNotBlank(avfb.getDefaultValueType()) && Strings.isNotBlank(avfb.getDefaultValue()) && avfb.isSerialNumberDefaultValue()) {
                                continue;
                            }
                            //重复表行序号不能录入值，不清空
                            if (fieldBean.getInputTypeEnum() == FormFieldComEnum.LINE_NUMBER) {
                                continue;
                            }
                            //非编辑权限全清空
                            if (this.needSetDefaultValue(avfb.getFormFieldBean(), formBean, viewBean)) {
                                if (avfb.getFormFieldBean().isMasterField()) {
                                    map.put(avfb.getFormFieldBean().getName(), avfb.getFormFieldBean().getDefaultVal4Db(null));
                                    if (avfb.getFormFieldBean().getInputTypeEnum() == FormFieldComEnum.HANDWRITE) {
                                        signetManager.deleteByRecordId(colSummary.getFormRecordid().toString());
                                        htmSignetManager.deleteBySummaryId(colSummary.getFormRecordid());
                                    } else if (avfb.getFormFieldBean().getInputTypeEnum() == FormFieldComEnum.RELATIONFORM) {
                                        this.formRelationRecordDAO.deleteFieldRecord(colSummary.getFormRecordid(), avfb.getFormFieldBean().getName(), 0l);
                                    }
                                } else {
                                    subMap = tableDataMap.get(avfb.getFormFieldBean().getOwnerTableName());
                                    if (subMap == null) {
                                        subMap = new HashMap<String, Object>();
                                    }

                                    if (avfb.getFormFieldBean().getInputTypeEnum() == FormFieldComEnum.RELATIONFORM) {
                                        tempList = needDeleteRelationRecordMap.get(avfb.getFormFieldBean().getOwnerTableName());
                                        if (tempList == null) {
                                            tempList = new ArrayList<String>();
                                        }
                                        tempList.add(avfb.getFormFieldBean().getName());
                                        needDeleteRelationRecordMap.put(avfb.getFormFieldBean().getOwnerTableName(), tempList);
                                    }
                                    subMap.put(avfb.getFormFieldBean().getName(), avfb.getFormFieldBean().getDefaultVal4Db(null));
                                    tableDataMap.put(avfb.getFormFieldBean().getOwnerTableName(), subMap);
                                }
                            }
                        }
                    }
                }
                try {
                    formTriggerManager.rollBack4FillBackTrigger(colSummary.getFormRecordid(), "repeal");
                } catch (Exception e) {
                    LOGGER.error("撤销保存待发预提数据还原报错", e);
                }
                //撤销到待发需要清空已发列表中该协同的表单授权
                Map<String, Object> param = new HashMap<String, Object>();
                param.put("value", "");
                param.put("moduleIds", "" + colSummary.getId());
                param.put("moduleType", RelationAuthSourceType.sourceSendCol.getKey());
                formRelationManager.updateRelationAuthority(param);
                AffairManager affairManager = (AffairManager) AppContext.getBean("affairManager");
                CtpAffair oldAffair = affairManager.getSenderAffair(affair.getObjectId());
                if (oldAffair != null) {
                    AffairUtil.setIsRelationAuthority(oldAffair, false);
                }
                //BUG_重要_V5_V6.0sp1_一星卡_北京华夏顺泽投资集团有限公司_流程处理意见框没有勾选回退意见不显示
                //未勾选流程意见回退不显示的时候未回填
                needFillBackDealOpition = true;
                break;
            case takeBack://取回
                //当前节点是审核，设置状态为未审核
                if (AUDIT.equals(affair.getNodePolicy())) {
                    needCalcAll = true;
                    this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_UNAUDITED.getKey(), 0l, null);
                }
                //当前节点是核定，设置状态为未核定
                else if (vouch.equals(affair.getNodePolicy())) {
                    needCalcAll = true;
                    this.getStateMap(map, UpdateDataType.FORM_VOUCH, FormDataRatifyFlagEnum.FLOW_UNVOUCH.getKey(), 0l, null);
                }
                needFillBackDealOpition = true;
                break;
            case specialback://指定回退
                //指定回退到发起者，即流程重走，需要回滚预提
                boolean isRepeal = AppContext.getThreadContext("isRepeal_4_form_use") == null ? false : (Boolean)AppContext.getThreadContext("isRepeal_4_form_use");
                LOGGER.info("指定回退，是否回退到发起者：isRepeal = " + isRepeal);
                if(isRepeal){
                	//指定回退到发起者，需要更改状态为草稿
                	this.getStateMap(map, false, colSummary.getStartMemberId(), DateUtil.currentTimestamp(),true);
                    try {
                        LOGGER.info("指定回退，预提回滚");
                        formTriggerManager.rollBack4FillBackTrigger(colSummary.getFormRecordid(), "specialback");
                    } catch (Exception e) {
                        LOGGER.error("撤销保存待发预提数据还原报错", e);
                    }
                }
                //BUG_重要_V5_V6.0sp1_一星卡_北京华夏顺泽投资集团有限公司_流程处理意见框没有勾选回退意见不显示
                //未勾选流程意见回退不显示的时候未回填
                needFillBackDealOpition = true;
                break;
            default:
                break;
        }
        if (!this.isChildrenWorkFlow(colSummary) && colSummary.getState() != null
                && colSummary.getState() == flowState.finish.ordinal()) {
            if (conditionState == TriggerConditionState.FlowSend) {
                conditionState = TriggerConditionState.FlowState_Send_OR_Finished;
            } else if (conditionState == TriggerConditionState.FlowState_Ratify) {
                conditionState = TriggerConditionState.FlowState_Ratify_OR_Finished;
            } else {
                conditionState = TriggerConditionState.FlowState_Finished;
            }
            map.put(MasterTableField.finishedflag.getKey(), FromDataFinishedFlagEnum.END_YES.getKey());
            //非子流程的流程结束需要执行触发
            needTrigger = true;
            needCalcAll = true;
            needAddRelationAuth = true;
            LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 操作类型是：" + type.name() + "流程结束");
        }
        //判断是否有字段设置了流程处理意见，然后决定是否更新二维码文件
        boolean hasSetValue = false;
        if (needFillBackDealOpition) {
            hasSetValue = this.getDealOpition(formBean, map, fieldBeans, list, colSummary, affair);
        }

        LOGGER.info(colSummary.getSubject() + "开始更新数据状态…………表单名称：" + formBean.getFormName() + " " + formBean.getId() + " 数据ID：" + colSummary.getFormRecordid() + " 操作类型是：" + type.name() + map);
        //BUG_普通_V5_V5.6SP1_宝鸡航天动力泵业有限公司_节点处理人提交流程之后，流程态度意见控件数据为空。
        FormDataMasterBean masterDataBean = formManager.getSessioMasterDataBean(colSummary.getFormRecordid());
        if (masterDataBean != null) {
            masterDataBean.addFieldValue(map);
        }
        //批处理完后, 也要修改modify_date
        map.put(MasterTableField.modify_date.getKey(),DateUtil.currentTimestamp());
		map.put(MasterTableField.modify_member_id.getKey(),AppContext.currentUserId());
        formDataDAO.updateData(colSummary.getFormRecordid(), formBean.getMasterTableBean().getTableName(), map);
        boolean constantFieldInCalc = formBean.hasConstantFieldInCalc(1);
        if ((needCalcAll && constantFieldInCalc)||hasSetValue) {
            if (masterDataBean == null) {
                //批处理提交的时候没有缓存，需要查询一次数据库
                masterDataBean = this.formDataDAO.selectDataByMasterId(colSummary.getFormRecordid(), formBean, null);
                if(hasSetValue){
                    //更新二维码的时候，如果缓存里面没有数据，则加进去
                    formManager.putSessioMasterDataBean(formBean,masterDataBean,true,false);
                }
                masterDataBean.addFieldValue(map);
            }
            if(needCalcAll && constantFieldInCalc){
                this.calcAll(formBean, masterDataBean, null, false, false, false);
            }
            if(hasSetValue){
                CtpContentAllBean contentAll = new CtpContentAllBean();
                contentAll.setModuleId(colSummary.getId());
                contentAll.setContentType(MainbodyType.FORM.getKey());
                contentAll.setViewState(CtpContentAllBean.viewState_readOnly);
                contentAll.setRightId(affair.getFormOperationId()==null?"":affair.getFormOperationId().toString());
                refreshAllBarCode(formBean,masterDataBean,contentAll);
            }
            FormService.saveOrUpdateFormData(masterDataBean, formBean.getId());
        }
        if (!tableDataMap.isEmpty()) {
            List<FormDataSubBean> subBeans;
            masterDataBean = this.formDataDAO.selectDataByMasterId(colSummary.getFormRecordid(), formBean, null);
            for (Entry<String, Map<String, Object>> et : tableDataMap.entrySet()) {
                subBeans = masterDataBean.getSubData(et.getKey());
                tempList = needDeleteRelationRecordMap.get(et.getKey());
                if (Strings.isNotEmpty(subBeans)) {
                    for (FormDataSubBean formDataSubBean : subBeans) {
                        this.formRelationRecordDAO.deleteFieldRecord(colSummary.getFormRecordid(), tempList, formDataSubBean.getId());
                        this.formDataDAO.updateData(formDataSubBean.getId(), et.getKey(), et.getValue());
                    }
                }
            }
        }
        //知会节点处理时不执行触发，回写动作
        if (isInformNode(affair)) {
            needTrigger = false;
        }
        if (needTrigger) {
            //增加判断，如果表单没有触发、回写设置等，则不进入调度 OA-110842性能问题：处理协同，每次都走FormTriggerManagerImpl.doTrigger
            if (formBean.getFormType() == FormType.processesForm.getKey() && formBean.hasTriggerSet()) {
                LOGGER.info("需要执行触发，进入触发执行判断…………");
                //OA-128458 预提执行，如果有异常的时候是需要colSummary对象的，但是预提是同步执行的，因此直接将当前的放入线程变量，不然会引起事务问题
                AppContext.putThreadContext("TRIGGER_PARAM_SUMMARY_PRE_" + colSummary.getId(), colSummary);
                formTriggerManager.preCheckTrigger(ModuleType.collaboration.getKey(), colSummary.getId(), formBean, colSummary.getFormRecordid(), conditionState, colSummary.getSubject());
                AppContext.removeThreadContext("TRIGGER_PARAM_SUMMARY_PRE_" + colSummary.getId());
                formTriggerManager.doTrigger(affair, ModuleType.collaboration.getKey(), colSummary.getId(), conditionState);
            }
        }
        //流程结束或者核定节点通过,添加更新关联授权数据
        if (needAddRelationAuth) {
            //更新关联他人发起的授权信息里面的流程状态
            formRelationManager.updateRelationAuthoritySummaryState(colSummary);
            List<CtpTemplateRelationAuth> relationAuthList = formRelationManager.getCtpTemplateRelationAuths(colSummary.getTempleteId());
            if(null!=relationAuthList&&relationAuthList.size()>0) {
                if (masterDataBean == null) {
                    masterDataBean = this.formDataDAO.selectDataByMasterId(colSummary.getFormRecordid(), formBean, null);
                }
                formRelationManager.actionRelAuthInFlowEnd(colSummary, masterDataBean,relationAuthList);
            }
        }
        if (colSummary.getFormRecordid() != null) {//有流程表单处理之后在更新完状态再调用移除session表单数据缓存
            formManager.removeSessionMasterDataBean(colSummary.getFormRecordid());
        }
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#getNewFlowDealOpitionValue(java.lang.Long, java.lang.Long, com.seeyon.ctp.common.po.comment.CtpCommentAll)
     */
    @Override
    public Map<String, Object> getNewFlowDealOpitionValue(Long formId, ColSummary colSummary, Comment comment)
            throws BusinessException {
        Map<String, Object> map = new HashMap<String, Object>();
        FormBean formBean = this.formCacheManager.getForm(formId);
        if (formBean == null || colSummary == null) {
            return map;
        }
        List<FormFieldBean> fieldBeans = formBean.getFieldsByType(FormFieldComEnum.FLOWDEALOPITION);
        CommentManager manager = (CommentManager) AppContext.getBean("ctpCommentManager");
        List<Comment> lists = manager.getCommentAllByModuleId(ModuleType.collaboration, colSummary.getId());
        if (lists == null) {
            lists = new ArrayList<Comment>();
        }
        if (!lists.contains(comment)) {
            lists.add(comment);
        }
        this.getDealOpition(formBean, map, fieldBeans, lists, null, comment.getAffairId() == null ? null : affairManager.get(comment.getAffairId()));
        FormDataMasterBean bean = this.formManager.getSessioMasterDataBean(colSummary.getFormRecordid());
        if (bean != null) {
            bean.addFieldValue(map);
        }
        return map;
    }

    private boolean needSetDefaultValue(FormFieldBean fieldBean, FormBean fb, FormAuthViewBean authBean) throws BusinessException {
        if (fieldBean.getInputTypeEnum() == FormFieldComEnum.RELATION) {
            if (fieldBean.getFormRelation() != null) {
                FormRelation fr = fieldBean.getFormRelation();
                FormFieldBean ffb = fb.getFieldBeanByName(fr.getToRelationAttr());
                return ffb == null || this.needSetDefaultValue(ffb, fb, authBean);
            }
        } else {
            FormAuthViewFieldBean avfb = authBean.getFormAuthorizationField(fieldBean.getName());
            return !avfb.isEditAuth();
        }
        return true;
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#updateDataState(java.lang.Long, java.lang.Long, java.lang.String, int)
     */
    @Override
    public void updateDataState(Long formId, Long dataId, String type, int state) throws BusinessException {

        FormDataMasterBean masterBean = this.formManager.getSessioMasterDataBean(dataId);
        if (masterBean != null) {
            UpdateDataType updateDataType = UpdateDataType.getTypeByName(type);
            if (updateDataType != null) {
                Map<String, Object> map = new HashMap<String, Object>();
                if (updateDataType != UpdateDataType.FORM_FLOW) {
                    this.getStateMap(map, updateDataType, state, AppContext.currentUserId(), DateUtil.currentTimestamp());
                } else {
                    this.getStateMap(map, updateDataType, state, masterBean.getStartMemberId(), masterBean.getStartDate());
                }
                masterBean.addFieldValue(map);
            }
        }
    }

    /**
     * 组装流程表单数据状态map，对下面的方法的进一步封装，主要用于发送，保存待发，撤销
     *
     * @param map      数据map 必传
     * @param isSend   是否是发送调用
     * @param senderId 发起人
     * @param date     发起时间
     * @param setFormFlow  是否执行创建人更新
     */
    private void getStateMap(Map<String, Object> map, boolean isSend, Long senderId, Date date,boolean setFormFlow) {
        if (isSend) {
            this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_UNAUDITED.getKey(), 0l, null);
        } else {
            this.getStateMap(map, UpdateDataType.FORM_AUDIT, FormDataStateEnum.FLOW_DRAFT.getKey(), 0l, null);
        }
        this.getStateMap(map, UpdateDataType.FORM_VOUCH, FormDataRatifyFlagEnum.FLOW_UNVOUCH.getKey(), 0l, null);
        if(setFormFlow){
            this.getStateMap(map, UpdateDataType.FORM_FLOW, FromDataFinishedFlagEnum.END_NO.getKey(), senderId, date);
        }
    }

    /**
     * 组装流程表单数据状态map
     *
     * @param map      数据map 必传
     * @param type     需要更新的状态分类：流程状态，核定状态，审核状态
     * @param state    对应的状态值
     * @param memberId 对应的人员
     * @param date     对应的更新时间
     */
    private void getStateMap(Map<String, Object> map, UpdateDataType type, int state, Long memberId, Date date) {
        if (map == null) {
            return;
        }

        switch (type) {
            case FORM_AUDIT:
                map.put(MasterTableField.state.getKey(), state);
                map.put(MasterTableField.approve_date.getKey(), date);
                map.put(MasterTableField.approve_member_id.getKey(), memberId);
                break;
            case FORM_FLOW:
                map.put(MasterTableField.finishedflag.getKey(), state);
                map.put(MasterTableField.start_member_id.getKey(), memberId);
                map.put(MasterTableField.start_date.getKey(), date);
                map.put(MasterTableField.modify_member_id.getKey(), memberId);
                map.put(MasterTableField.modify_date.getKey(), date);
                break;
            case FORM_VOUCH:
                map.put(MasterTableField.ratifyflag.getKey(), state);
                map.put(MasterTableField.ratify_date.getKey(), date);
                map.put(MasterTableField.ratify_member_id.getKey(), memberId);
                break;
            default:
                break;
        }
    }

    /**
     * 设置流程意见控件值
     * 201：意见为空时均不显示；202：暂存待办意见不显示；203：回退意见不显示
     *
     * @param formBean
     * @param masterBean
     * @param fieldBeans
     * @param comments
     * @throws BusinessException
     */
    private boolean getDealOpition(FormBean formBean, Map<String, Object> masterBean, List<FormFieldBean> fieldBeans,
                                List<Comment> comments, ColSummary colSummary, CtpAffair affair) throws BusinessException {
        List<Comment> temp;
        //是否有字段已经设置了流程处理意见，添加一个标识，看要不要更新二维码
        boolean hasSetValue = false;
        if (Strings.isEmpty(comments)) {
            return hasSetValue;
        }
        for (FormFieldBean formFieldBean : fieldBeans) {
        	
        	boolean needBackComments = false;
            boolean needTemporaryComments = true;
            boolean needNullComments = true;

            String formatType = formFieldBean.getFormatType();
            if (Strings.isNotBlank(formatType)) {
                if (formatType.contains(FlowDealOptionsType.nullToShow.getKey())) {
                    //【意见为空时均不显示】缺省不勾选，如果勾选，那么处理流程表单时如果意见为空，则均不回填到流程处理意见字段。
                    needNullComments = false;
                }
                if (formatType.contains(FlowDealOptionsType.temporaryToShow.getKey())) {
                    //【暂存待办意见不显示】缺省不勾选，如果勾选，那么处理流程表单时如果暂存待办，则意见不回填到流程处理意见字段。
                    needTemporaryComments = false;
                }
                if (!formatType.contains(FlowDealOptionsType.backToShow.getKey())) {
                    //【回退意见不显示】缺省勾选，如果不勾选，那么在做回退操作的时候的处理意见要回填到流程处理意见字段。
                    needBackComments = true;
                }
            }
            temp = this.getComments(formBean, formFieldBean, comments, colSummary, needBackComments, needTemporaryComments, needNullComments);
        	
            //客开 start
            if(needFillBackDeal(formBean.getFormName())){
              List<Comment> newTemp = new ArrayList();
              if(!CollectionUtils.isEmpty(temp)){
                for(Comment c:temp){
                  if(affairManager.get(c.getAffairId())!=null
                      && getNodePolicyField(formBean.getFormName(),affairManager.get(c.getAffairId()).getNodePolicy())!=null
                      && getNodePolicyField(formBean.getFormName(),affairManager.get(c.getAffairId()).getNodePolicy()).equals(formFieldBean.getDisplay())){
                    newTemp.add(c);
                  }
                }
                temp = newTemp;
              }
            }
            //客开 end
            if (Strings.isNotEmpty(temp)) {
                String value = this.getDealOpitionValue(formFieldBean, temp);
                if (formFieldBean.getFieldType().equals(FieldType.VARCHAR.getKey())) {
                    int length = formFieldBean.getFieldLength() == null || !Strings.isDigits(formFieldBean.getFieldLength()) ? 0 : Integer.parseInt(formFieldBean.getFieldLength());
                    if (value.length() > length / 3) {
                        LOGGER.info("表单：" + formBean.getFormName() + "的字段" + formFieldBean.getName() + "意见回填超长被截取，原意见：" + value);
                        value = value.substring(0, length / 3);
                    }
                }
                masterBean.put(formFieldBean.getName(), value);
            } else {
                masterBean.put(formFieldBean.getName(), "");
            }
            hasSetValue = true;
        }
        return hasSetValue;
    }

    /**
     * 获取某一个意见控件值
     *
     * @param formFieldBean
     * @param comments
     * @throws BusinessException
     */
    private String getDealOpitionValue(FormFieldBean formFieldBean, List<Comment> comments) throws BusinessException {
        StringBuilder sb = new StringBuilder();
        String value = null;
        for (int i = 0, j = comments.size(); i < j; i++) {
            Comment comment = comments.get(i);
            value = this.getDealOpition(comment, formFieldBean.getFormatType(), formFieldBean.getName());
            sb.append(value);
            if (i != j - 1) {
                sb.append("\r\n\r\n");
            }
        }
        return sb.toString();
    }

    /**
     * 按照事项分组处理意见
     *
     * @param commonts
     * @param colSummary
     * @param flag                  true 按照事项分组，false 按照人员分组
     * @param needBackComments      是否需要回退的意见
     * @param needTemporaryComments 是否需要暂存待办意见
     * @param needNullComments      意见为空是否显示
     * @return
     * @throws BusinessException
     */
    private Map<Long, List<Comment>> groupCommentByAffair(List<Comment> commonts, ColSummary colSummary, boolean flag,
                                                          boolean needBackComments, boolean needTemporaryComments, boolean needNullComments)
            throws BusinessException {
        Map<Long, List<Comment>> map = new LinkedHashMap<Long, List<Comment>>();
        List<Comment> list;
        List<Comment> temp = new ArrayList<Comment>();
        Long id = null;
        for (Comment comment : commonts) {
            if (flag) {
                id = comment.getAffairId();
                list = map.get(comment.getAffairId());
            } else {
                id = comment.getCreateId();
                list = map.get(comment.getCreateId());
            }
            if (list == null) {
                if (id == null) {
                    continue;
                } else {
                    list = new ArrayList<Comment>();
                    map.put(id, list);
                }
            }
            if (Strings.isBlank(comment.getContent()) && !needNullComments) {
                continue;
            }
            if (this.isTemporaryComment(comment) && !needTemporaryComments) {
                continue;
            }
            if ((this.isRollBackComment(comment) && !needBackComments) || !this.isFillBackComment(comment)) {
                continue;
            }
            if (this.isCancelComment(comment)) {
                for (Entry<Long, List<Comment>> et : map.entrySet()) {
                    et.getValue().clear();
                }
                temp.clear();
            }
            list.add(comment);
            temp.add(comment);
        }
        map.put(0l, temp);
        return map;
    }

    /**
     * 组装流程处理意见 6.0 新功能
     *
     * @param comment
     * @param typeStr   101，102，。。。。。
     * @param fieldName
     * @return
     * @throws BusinessException
     */
    //客开  意见显示格式   信息技术部 : oa管理员 【已阅】 休息休息  2017-04-14 17:01
    private String getDealOpition(Comment comment, String typeStr, String fieldName) throws BusinessException {
        StringBuilder sb = new StringBuilder();
        String transactor = "";
        V3xOrgMember member;
        if (Strings.isNotBlank(comment.getExtAtt2())) {
            transactor = ResourceUtil.getString("form.dealopition.by.other.label",comment.getExtAtt2());
        }
      
      String space = " ";
      
      member = this.orgManager.getMemberById(comment.getCreateId());
      V3xOrgDepartment department = this.orgManager.getDepartmentById(member.getOrgDepartmentId());
      V3xOrgPost orgPost = this.orgManager.getPostById(member.getOrgPostId());

      String att = StringUtils.fixStrWithSpace(this.getAtt(comment), 5);
      String inscribe = comment.getContent();
      if (Strings.isBlank(inscribe)) {
          inscribe = "";
      }
      Long affairId = comment.getAffairId();

      String deptName = "";
      if(department != null){
    	deptName = department.getName();
    	if (member.getOrgAccountId().toString().equals("-2329940225728493295") || member.getOrgAccountId().toString().equals("-1792902092017745579")){
	//        String parentPath = department.getPath().substring(0,department.getPath().length()-4);
	        String parentPath = department.getPath().length()>=16?org.apache.commons.lang.StringUtils.left(department.getPath(), 16):department.getPath();
	        List<OrgUnit> parentUnits = DBAgent.find("from OrgUnit where IS_DELETED=0 and path='"+parentPath+"'");
	        if(org.apache.commons.collections.CollectionUtils.isNotEmpty(parentUnits)){
	          deptName = parentUnits.get(0).getName()+space+":";
	        }
    	}
      }
      sb.append(deptName).append(space);  //部门
      sb.append(member.getName()).append(transactor).append(space);//人员
      sb.append(org.apache.commons.lang.StringUtils.equals(att.trim(),"【】")?"":att.trim()).append(space).append(inscribe).append(space);//态度 意见
      sb.append(comment.getCreateDateStr().substring(0, 10)).append(space);//日期
      sb.append(comment.getCreateDateStr().substring(comment.getCreateDateStr().length() - 5)).append(space);//时间
      return sb.toString();
  }
    //客开 原先的意见显示设置 start
    /*private String getDealOpition1(Comment comment, String typeStr, String fieldName) throws BusinessException {
        StringBuilder sb = new StringBuilder();
        String transactor = "";
        V3xOrgMember member;
        if (Strings.isNotBlank(comment.getExtAtt2())) {
            transactor = "(" + comment.getExtAtt2() + "代)";
        }
        //回车换行符加10的空格
        String crlfAndTenSpace = "\r\n          ";
        String space = " ";
        String leftMiddle = "[";
        String rightMiddle = "]";

        member = this.orgManager.getMemberById(comment.getCreateId());
        V3xOrgDepartment department = this.orgManager.getDepartmentById(member.getOrgDepartmentId());
        V3xOrgPost orgPost = this.orgManager.getPostById(member.getOrgPostId());

        String att = StringUtils.fixStrWithSpace(this.getAtt(comment), 5);
        String inscribe = comment.getContent();
        if (Strings.isBlank(inscribe)) {
            inscribe = "";
        }
        String inscribeWithCrlfAndTenSpace = inscribe.replace("\n", crlfAndTenSpace);

        Long affairId = comment.getAffairId();

        if (Strings.isBlank(typeStr)) {
            //格式化为空时，采用默认的值:态度 意见 \r\n          [姓名   日期  时间]
            sb.append(att).append(space).append(inscribe).append(crlfAndTenSpace).append(leftMiddle);
            sb.append(member.getName()).append(transactor).append(space).append(comment.getCreateDateStr()).append(rightMiddle);
        } else {
            *//******************************处理态度、意见**********************//*
            boolean isIncludeAtt = typeStr.indexOf(FlowDealOptionsType.att.getKey()) > -1;
            boolean isIncludeInscribe = typeStr.indexOf(FlowDealOptionsType.inscribe.getKey()) > -1;
            boolean hasSignet = typeStr.contains(FlowDealOptionsType.signet.getKey());
            if (isIncludeAtt) {
                sb.append(att).append(space);

            }
            if (isIncludeInscribe) {
                if (isIncludeAtt) {
                    sb.append(inscribeWithCrlfAndTenSpace);
                } else {
                    sb.append(inscribe);
                }
            }
            sb.append(crlfAndTenSpace);
            *//******************************部门、岗位、姓名、签章。日期、时间**********************//*
            if (hasSecondRow(typeStr)) {
                String[] types = typeStr.split(",");
                //有真实签名的不需要这个括号
                if(!hasSignet){
                    sb.append(leftMiddle);
                }
                for (String one : types) {
                    FlowDealOptionsType type = FlowDealOptionsType.getEnumItemByKey(one);
                    switch (type) {
                        case dept:
                          //客开 流程处理意见 部门 显示改为一级部门/当前部门 start
                          //sb.append(department.getName()).append(space);
                            String deptName = "";
                            if(department!=null){
                              String parentPath = department.getPath().substring(0,department.getPath().length()-4);
                              List<OrgUnit> parentUnits = DBAgent.find("from OrgUnit where IS_DELETED=0 and path='"+parentPath+"'");
                              if(org.apache.commons.collections.CollectionUtils.isNotEmpty(parentUnits)){
                                deptName = parentUnits.get(0).getName()+"/"+department.getName();
                              }
                            }
                            sb.append(deptName).append(space);
                            //客开 start
                            break;
                        case post:
                            sb.append((orgPost == null ? "" : orgPost.getName())).append(space);
                            break;
                        case name:
                            sb.append(member.getName()).append(transactor).append(space);
                            break;
                        case signet:
                            sb.append(getSignetAndSaveHtmlSignet(member, fieldName, affairId, transactor));
                            break;
                        case date:
                            sb.append(comment.getCreateDateStr().substring(0, 10)).append(space);
                            break;
                        case time:
                            sb.append(comment.getCreateDateStr().substring(comment.getCreateDateStr().length() - 5)).append(space);
                            break;
                        default:
                            sb.append("");
                    }
                }
                sb.deleteCharAt(sb.toString().length() - 1);//删掉方括号前的空格
                if(!hasSignet) {
                    sb.append(rightMiddle);
                }
            }
        }
        return sb.toString();
    }*/
  // 客开 原先的意见显示设置 end

    private boolean hasSecondRow(String formatStr) {
        if (Strings.isNotBlank(formatStr)) {
            if (formatStr.contains(FlowDealOptionsType.dept.getKey()) ||
                    formatStr.contains(FlowDealOptionsType.post.getKey()) ||
                    formatStr.contains(FlowDealOptionsType.name.getKey()) ||
                    formatStr.contains(FlowDealOptionsType.signet.getKey()) ||
                    formatStr.contains(FlowDealOptionsType.date.getKey()) ||
                    formatStr.contains(FlowDealOptionsType.time.getKey())) {
                return true;
            }
        }
        return false;
    }

    private String getAtt(Comment comment) {
        if (this.isDealAtt(comment)) {
            if ("collaboration.dealAttitude.disagree".equals(comment.getExtAtt1())) {
                return "【" + ResourceUtil.getString(comment.getExtAtt1()) + "】";
            } else {
                return "【" + ResourceUtil.getString(comment.getExtAtt1()) + "】  ";
            }
        }
        return "          ";
    }

    /**
     * 得到处理人的签名并保存到html签名历史表(保存格式:部门名称 <signet>小王_field0001_-5908625899231690426</signet>
     * 如果存在多个则再找人员与签章名字相同,如仍不存在，则视为签章不存在，返回人员姓名
     *
     * @param member
     * @param fieldName
     * @param affairId
     * @return
     */
    private String getSignetAndSaveHtmlSignet(V3xOrgMember member, String fieldName, Long affairId, String transactor) {
        String space = " ";
        String memberName = member.getName();
        StringBuilder res = new StringBuilder();
        List<V3xSignet> signetList = signetManager.findSignetByMemberId(member.getId());
        V3xSignet selfSignet = null;
        if (signetList != null && !signetList.isEmpty()) {
            for (V3xSignet v3xSignet : signetList) {
                if (v3xSignet.getMarkType() == 0) {
                    if (selfSignet == null ||
                            (selfSignet != null && selfSignet.getMarkDate().before(v3xSignet.getMarkDate()))) {
                        selfSignet = v3xSignet;
                    }
                }
            }
        }
        if (selfSignet != null) {
            long summaryId = UUIDLong.longUUID();
            V3xHtmDocumentSignature htmlDocSignature = new V3xHtmDocumentSignature();
            htmlDocSignature.setId(summaryId);
            htmlDocSignature.setSummaryId(summaryId);
            htmlDocSignature.setFieldName(fieldName + "_" + summaryId);
            htmlDocSignature.setUserName(memberName);
            htmlDocSignature.setSignetType(1);
            htmlDocSignature.setDateTime(DateUtil.currentTimestamp());
            if (affairId != null) {
                htmlDocSignature.setAffairId(affairId);
            }
            htmlDocSignature.setFieldValue(FormUtil.byte2Hex(selfSignet.getMarkBodyByte()));
            htmSignetManager.save(htmlDocSignature);
            res.append("@signet@").append(memberName).append("_").append(fieldName).append("_").append(summaryId).append("@signet@");
            res.append(transactor).append(space);
        } else {
            res.append(memberName).append(transactor).append(space);
        }
        return res.toString();
    }

    /**
     * 获取某个单元格需要填入的意见列表
     *
     * @param formBean
     * @param formFieldBean
     * @param allComments
     * @param needBackComments      是否需要回退的意见
     * @param needTemporaryComments 意见为空是否显示
     * @param needNullComments      意见为空是否显示
     * @return
     * @throws BusinessException
     */
    private List<Comment> getComments(FormBean formBean, FormFieldBean formFieldBean, List<Comment> allComments,
                                      ColSummary colSummary, boolean needBackComments, boolean needTemporaryComments, boolean needNullComments) throws BusinessException {
        List<Comment> list = new ArrayList<Comment>();
        Map<Long, List<Comment>> map = this.groupCommentByAffair(allComments, colSummary, false, needBackComments, needTemporaryComments, needNullComments);
        List<Comment> comments = map.get(0l);
        List<Comment> temp;
        Comment com = null;
        for (Comment comment : comments) {
            //排除空意见
            if (Strings.isBlank(comment.getContent()) && !needNullComments) {
                continue;
            }
            //排除暂存代办意见
            if (isTemporaryComment(comment) && !needTemporaryComments) {
                continue;
            }
            //排除回退和撤销已经
            if (isRollBackComment(comment) && !needBackComments) {
                continue;
            }
            if (isCancelComment(comment)) {
                list.clear();
                continue;
            }
            if (!this.isFillBackComment(comment)) {
                continue;
            }
            if (null == comment.getAffairId()) {
                continue;
            }
            //判断当前意见是否需要填入意见控件
            if (this.needFillBackDealOpition(formBean, formFieldBean, comment.getAffairId(), true)) {
                //编辑和追加分别处理
                if (this.needFillBackDealOpition(formBean, formFieldBean, comment.getAffairId(), false)) {
                    //排除草稿、回复、发起人附言
                    if (comment.getCtype() != Comment.CommentType.comment.getKey()) {
                        continue;
                    }
                    list.add(comment);
                } else {
                    //是编辑权限，取所有意见中最晚的一个，如果是回退或者撤销意见，则不填入
                    temp = map.get(comment.getCreateId());
                    if (Strings.isNotEmpty(temp)) {
                        for (Comment c : temp) {
                            //排除草稿、回复、发起人附言
                            if (c.getCtype() != Comment.CommentType.comment.getKey()) {
                                continue;
                            }
                            if (this.needFillBackDealOpition(formBean, formFieldBean, c.getAffairId(), true)) {
                                com = c;
                            }
                        }
                        if (com != null) {
                            if ((!isRollBackComment(com) || needBackComments) && comment.getCtype() != Comment.CommentType.draft.getKey()) {
                                if (!list.contains(com)) {
                                    list.add(com);
                                }
                            }
                        }
                    }
                }
            }
        }
        return list;
    }

    /**
     * 判断节点是否是知会节点
     *
     * @param affair
     * @return
     */
    private boolean isInformNode(CtpAffair affair) {
        return "inform".equals(affair.getNodePolicy());
    }

    /**
     * 判断处理意见是否是回退的
     *
     * @param comment
     * @return
     */
    private boolean isRollBackComment(Comment comment) {
        if (Strings.isNotBlank(comment.getExtAtt3())
                && ("collaboration.dealAttitude.rollback".equals(comment.getExtAtt3()))) {
            return true;
        }
        return false;
    }

    /**
     * 判断意见是否是暂存待办的
     *
     * @param comment
     * @return
     */
    private boolean isTemporaryComment(Comment comment) {
        if (Strings.isNotBlank(comment.getExtAtt3())
                && ("collaboration.dealAttitude.temporaryAbeyance".equals(comment.getExtAtt3()))) {
            return true;
        }
        return false;
    }

    /**
     * 判断是否是需要回填的意见，回复意见/草稿返回true，发起人附言/意见回复返回false；
     *
     * @param comment
     * @return
     */
    private boolean isFillBackComment(Comment comment) {
        if (comment.getCtype() == null) {
            return false;
        }
        if (Comment.CommentType.comment.getKey() != comment.getCtype() && Comment.CommentType.draft.getKey() != comment.getCtype()) {
            return false;
        }
        return true;
    }

    private boolean isCancelComment(Comment comment) {
        if (Strings.isNotBlank(comment.getExtAtt3())
                && ("collaboration.dealAttitude.cancelProcess".equals(comment.getExtAtt3()))) {
            return true;
        }
        return false;
    }

    private boolean isDealAtt(Comment comment) {
        if (Strings.isNotBlank(comment.getExtAtt1())
                && ("collaboration.dealAttitude.agree".equals(comment.getExtAtt1()) || "collaboration.dealAttitude.disagree".equals(comment.getExtAtt1()) || "collaboration.dealAttitude.haveRead".equals(comment.getExtAtt1()))) {
            return true;
        }
        return false;
    }

    private boolean needFillBackDealOpition(FormBean formBean, FormFieldBean formFieldBean, Long affairID, boolean isAdd) throws BusinessException {
        CtpAffair affair = affairManager.get(affairID);
        if (affair == null) {
            LOGGER.error("组装流程意见时，事项：" + affairID + "被删除，该事项对应意见不组装……");
            return false;
        }
        return needFillBackDealOpition(formBean, formFieldBean, affair, isAdd);
    }

    /**
     * 判断事项ID对应的意见是否需要写入单元格
     *
     * @param formBean
     * @param formFieldBean
     * @param affairID
     * @param isAdd         true:第一次判断是否需要写入，false：第二次判断是编辑还是追加
     * @return 第一次判断：需要写入：true,不需要则false；二次判断：是追加：true,编辑：false
     * @throws BusinessException
     */
    private boolean needFillBackDealOpition(FormBean formBean, FormFieldBean formFieldBean, CtpAffair affair, boolean isAdd)
            throws BusinessException {
        if (affair == null) {
            LOGGER.error("组装流程意见时，字段：" + formFieldBean.getName() + "对应事项被删除，该事项对应意见不组装……");
            return false;
        }
        if (AffairUtil.isFormReadonly(affair)) {
            LOGGER.info("组装流程意见时，事项：" + affair.getId() + "为只读权限，该事项对应意见不组装……");
            return false;
        }
        /*if (isInformNode(affair)) {
            LOGGER.error("组装流程意见时，事项对应权限：" + affair.getId() + "为知会节点，该事项对应意见不组装……");
            return false;
        }*/
        if (affair.getFormOperationId() == null) {
            LOGGER.error("组装流程意见时，事项：" + affair.getId() + "对应权限不存在，该事项对应意见不组装……");
            return false;
        }
        FormAuthViewBean formAuthViewBean = formBean.getAuthViewBeanById(affair.getFormOperationId());
        if (formAuthViewBean == null) {
            LOGGER.error("组装流程意见时，事项对应权限：" + affair.getFormOperationId() + "被删除，该事项对应意见不组装……");
            return false;
        }

        FormAuthViewFieldBean authViewFieldBean;
        FieldAccessType accessType;
        authViewFieldBean = formAuthViewBean.getFormAuthorizationField(formFieldBean.getName());
        if (authViewFieldBean != null) {
            //客开start
            if(needFillBackDeal(formBean.getFormName())){
              if(formFieldBean.getInputType().equalsIgnoreCase("flowdealoption") 
                  && getNodePolicyField(formBean.getFormName(),affair.getNodePolicy())!=null 
                  && getNodePolicyField(formBean.getFormName(),affair.getNodePolicy()).equals(formFieldBean.getDisplay())){
                return true;
              }
            }
            //客开 end
            accessType = FieldAccessType.getEnumByKey(authViewFieldBean.getAccess());
            if (accessType == FieldAccessType.add || accessType == FieldAccessType.edit) {
                if (isAdd) {
                    return true;
                } else {
                    if (accessType == FieldAccessType.add) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
        return false;
    }
    
    //客开 start
    private boolean needFillBackDeal(String formName){
      String formNameNode = AppContext.getSystemProperty("cinda.formName");
      if(org.apache.commons.lang.StringUtils.isNotBlank(formNameNode)){
        String[] formNames = formNameNode.split(",");
        for(String f:formNames){
          if(f.equalsIgnoreCase(formName)){
            return true;
          }
        }
      }
      return false;
    }
    
    private String getNodePolicyField(String formName,String nodePolicy){
      Map<String,String> map = new HashMap<String, String>();
      String formNameNode = AppContext.getSystemProperty("cinda.formName");
      if(org.apache.commons.lang.StringUtils.isNotBlank(formNameNode)){
        String[] formNames = formNameNode.split(",");
        for(int i=0;i<formNames.length;i++){
          if(formNames[i].equalsIgnoreCase(formName)){
            String nodePolicyField = AppContext.getSystemProperty("cinda.nodePolicyField_"+i);
            if(org.apache.commons.lang.StringUtils.isNotBlank(nodePolicyField)){
              String[] nodePolicyFields = nodePolicyField.split(",");
              for(String n:nodePolicyFields){
                map.put(n.split("=")[0], n.split("=")[1]);
              }
              break;
            }
          }
        }
      }
//      map.put("审核","处长审核");
//      map.put("领导批示","公司领导批示");
//      map.put("approve","部室负责人审核");
      return map.get(nodePolicy);
    }
    //客开 end

    /**
     * 根据recordId获取json格式的子表行数据
     * param:masterId（主数据id） recordId（子表行id） formId（表单id） subTableName（子表名字）
     */
    @Override
    public String getJsonSubDataById(Map<String, Object> param) {
        Long masterId = ParamUtil.getLong(param, "masterId");
        Long recordId = ParamUtil.getLong(param, "recordId");
        Long formId = ParamUtil.getLong(param, "formId");
        String subTableName = ParamUtil.getString(param, "subTableName");
        FormBean form = formCacheManager.getForm(formId);
        DataContainer dc = new DataContainer();
        List<DataContainer> datas = new ArrayList<DataContainer>();
        try {
            FormDataMasterBean masterData = formDataDAO.selectDataByMasterId(masterId, form, null);
            Map<String, Object> lineData = masterData.getSubDataMapById(subTableName, recordId);
            for (Entry<String, Object> entry : lineData.entrySet()) {
                String key = entry.getKey();
                FormFieldBean tempBean = form.getFieldBeanByName(key);
                if (tempBean != null && !tempBean.isConstantField()) {
                    Object val = entry.getValue();
                    DataContainer tempDc = new DataContainer();
                    tempDc.put("display", tempBean.getDisplay());
                    tempDc.put("fieldName", tempBean.getName());
                    tempDc.put("value", val);
                    datas.add(tempDc);
                }
            }
        } catch (BusinessException e) {
            LOGGER.error(e.getMessage(), e);
        } catch (SQLException e) {
            LOGGER.error(e.getMessage(), e);
        }
        dc.add("datas", datas);
        return dc.getJson();
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

    /**
     * @return the formDataDAO
     */
    public FormDataDAO getFormDataDAO() {
        return formDataDAO;
    }

    /**
     * @param formDataDAO the formDataDAO to set
     */
    public void setFormDataDAO(FormDataDAO formDataDAO) {
        this.formDataDAO = formDataDAO;
    }

    /**
     * @return the formRelationManager
     */
    public FormRelationManager getFormRelationManager() {
        return formRelationManager;
    }

    /**
     * @param formRelationManager the formRelationManager to set
     */
    public void setFormRelationManager(FormRelationManager formRelationManager) {
        this.formRelationManager = formRelationManager;
    }

    /**
     * @return the formLogManager
     */
    public FormLogManager getFormLogManager() {
        return formLogManager;
    }

    /**
     * @param formLogManager the formLogManager to set
     */
    public void setFormLogManager(FormLogManager formLogManager) {
        this.formLogManager = formLogManager;
    }

    /**
     * @return the fileManager
     */
    public FileManager getFileManager() {
        return fileManager;
    }

    /**
     * @param fileManager the fileManager to set
     */
    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    /**
     * @return the fileToExcelManager
     */
    public FileToExcelManager getFileToExcelManager() {
        return fileToExcelManager;
    }

    /**
     * @param fileToExcelManager the fileToExcelManager to set
     */
    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public FormTriggerManager getFormTriggerManager() {
        return formTriggerManager;
    }

    public void setFormTriggerManager(FormTriggerManager formTriggerManager) {
        this.formTriggerManager = formTriggerManager;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public AffairManager getAffairManager() {
        return affairManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
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

    public BarCodeManager getBarCodeManager() {
        return barCodeManager;
    }

    public void setBarCodeManager(BarCodeManager barCodeManager) {
        this.barCodeManager = barCodeManager;
    }

    public AttachmentManager getAttachmentManager() {
        return attachmentManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public SerialCalRecordManager getSerialCalRecordManager() {
        return serialCalRecordManager;
    }

    public void setSerialCalRecordManager(SerialCalRecordManager serialCalRecordManager) {
        this.serialCalRecordManager = serialCalRecordManager;
    }

    /**
     * 根据参数获取所选FormDataMasterBean列表，其中的FormDataMasterBean中的子表行已经根据参数进行过移除没选中行的操作
     *
     * @param selectArray
     * @param toFormBean
     * @return
     * @throws BusinessException
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<FormDataMasterBean> findSelectedDataBeans(List<Map> selectArray, FormBean toFormBean,
                                                          String relationType) throws BusinessException {
        Long[] masterIds = new Long[selectArray.size()];
        for (int i = 0; i < selectArray.size(); i++) {
            Long tempId = Long.parseLong(String.valueOf(selectArray.get(i).get("masterDataId")));
            Map params = new HashMap();
            params.put("moduleId", tempId);
            if (toFormBean.getFormType() == FormType.processesForm.getKey()) {//有流程表单传递的是协同id,需要通过正文来查询主表数据id
                params.put("moduleType", ModuleType.collaboration.getKey());
            } else if (toFormBean.getFormType() == FormType.baseInfo.getKey()) {
                params.put("moduleType", ModuleType.unflowBasic.getKey());
            } else if (toFormBean.getFormType() == FormType.manageInfo.getKey()) {
                params.put("moduleType", ModuleType.unflowInfo.getKey());
            } else if (toFormBean.getFormType() == FormType.planForm.getKey()) {
                params.put("moduleType", ModuleType.plan.getKey());
            }
            params.put("contentTemplateId", toFormBean.getId());
            //List<CtpContentAll> contentList = DBAgent.findByNamedQuery("ctp_common_content_findContentByModuleAndContentTemplate", params);
            List<CtpContentAll> contentList = MainbodyService.getInstance().getContentList(params);
            if (contentList == null || contentList.size() <= 0) {
                LOGGER.error("表单关联查不到底表正文数据：底表数据id:" + tempId + "moduleId:" + tempId + " moduleType:" + params.get("moduleType") + " templateId:" + params.get("contentTemplateId") + " 动态表名字：" + toFormBean.getFormName() + " 表单id:" + toFormBean.getId());
                continue;
            }
            CtpContentAll content = contentList.get(0);
            masterIds[i] = content.getContentDataId();
            selectArray.get(i).put("masterDataId", masterIds[i]);
            selectArray.get(i).put(FormConstant.contentTitle, content.getTitle());
            selectArray.get(i).put(FormConstant.moduleId, content.getModuleId());
            selectArray.get(i).put(FormConstant.content, Strings.isBlank(content.getContent()) ? "0" : String.valueOf(content.getContent()));
        }
        List<FormDataMasterBean> toFormDataMasterBeans = null;
        try {
            toFormDataMasterBeans = formDataDAO.selectMasterDataById(masterIds, toFormBean, null);
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            throw new BusinessException(StringUtil.toString(e));
        }
        for (FormDataMasterBean mdata : toFormDataMasterBeans) {
            Map fielterParam = null;
            for (int i = 0; i < selectArray.size(); i++) {
                Long mid = Long.parseLong(String.valueOf(selectArray.get(i).get("masterDataId")));
                if (mid.longValue() == mdata.getId()) {
                    fielterParam = selectArray.get(i);
                    mdata.putExtraAttr(FormConstant.contentTitle, fielterParam.get(FormConstant.contentTitle) == null ? "" : (String) fielterParam.get(FormConstant.contentTitle));
                    mdata.putExtraAttr(FormConstant.moduleId, fielterParam.get(FormConstant.moduleId) == null ? 0l : (Long) fielterParam.get(FormConstant.moduleId));
                    mdata.putExtraAttr(FormConstant.content, fielterParam.get(FormConstant.content) == null ? "0" : (String) fielterParam.get(FormConstant.content));
                }
            }
            //如果只选择了一条主数据，则子表数据如果没有选择需要默认选择第一条子表数据
            if (toFormDataMasterBeans.size() >= 1 && "user".equals(relationType)) {
                filterFormSubData(mdata, fielterParam, true);
            } else {
                filterFormSubData(mdata, fielterParam, false);
            }
        }
        return toFormDataMasterBeans;
    }

    /**
     * 根据参数过滤掉没有被选中的子表行数据
     *
     * @param masterData
     * @param fielterParam
     * @param defaultFirstRow 是否默认选择第一条子表数据
     *                        格式：{masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]}
     */
    private void filterFormSubData(FormDataMasterBean masterData, Map fielterParam, boolean defaultFirstRow) {
        List subDataParam = (List) fielterParam.get("subData");
        for (int i = 0; i < subDataParam.size(); i++) {
            Map tempMap = (Map) subDataParam.get(i);
            String tName = (String) tempMap.get("tableName");
            List subDataIds = (List) tempMap.get("dataIds");
            List<FormDataSubBean> subDataBeans = masterData.getSubData(tName);
            if (subDataIds == null) {
                subDataIds = new ArrayList<String>();
            }
            if (subDataIds.size() <= 0) {
                if (defaultFirstRow && subDataBeans != null && subDataBeans.size() > 0) {//如果只选择了一条主数据，则子表数据如果没有选择需要默认选择第一条子表数据
                    FormDataSubBean tempBean = subDataBeans.get(0);
                    subDataBeans.clear();
                    subDataBeans.add(tempBean);
                    subDataIds.add("" + tempBean.getId());
                }
            }
            List<Long> removedIds = new ArrayList<Long>();
            for (FormDataSubBean sData : subDataBeans) {
                if (!subDataIds.contains(String.valueOf(sData.getId()))) {
                    removedIds.add(sData.getId());
                }
            }
            for (Long sid : removedIds) {
                //用户没有选择子表行的时候需要留一行作为默认选择的
                subDataBeans.remove(masterData.getFormDataSubBeanById(tName, sid));
            }
        }
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#insertOrUpdateMasterData(com.seeyon.ctp.form.bean.FormDataMasterBean)
     */
    @Override
    public void insertOrUpdateMasterData(FormDataMasterBean masterData) throws BusinessException, SQLException {
        this.formDataDAO.insertOrUpdateMasterData(masterData);
    }

    @Override
    public void saveMasterData(List<FormDataMasterBean> masterBeen, FormBean formBean, boolean isUpdate, List<CtpContentAll> contentAlls) throws BusinessException, SQLException {

        Set<Long> enumId = new HashSet<Long>();
        List<FormRelationRecord> recordList = new ArrayList<FormRelationRecord>();
        List<FormSerialCalculateRecord> serialRecordList = new ArrayList<FormSerialCalculateRecord>();
        //List<Long> masterIds = new ArrayList<Long>();
        Map<String, List<FormDataBean>> datas = new HashMap<String, List<FormDataBean>>();

        List<FormFieldBean> allFields = formBean.getAllFieldBeans();
        List<FormFieldBean> enumField = new ArrayList<FormFieldBean>();
        for (FormFieldBean field : allFields) {
            if (field.isEnumField()) {
                enumField.add(field);
            }
        }

        for (FormDataMasterBean masterBean : masterBeen) {

            //masterIds.add(masterBean.getId());

            //获取需要更新枚举引用状态的枚举id
            if (Strings.isNotEmpty(enumField)) {
                for (FormFieldBean fieldBean : enumField) {
                    List<Object> attValues = masterBean.getDataList(fieldBean.getName());
                    if (attValues.size() > 0) {
                        for (Object objval : attValues) {
                            if (!StringUtil.checkNull(String.valueOf(objval)) && !"0".equals(String.valueOf(objval))) {
                                enumId.add(new BigDecimal((String.valueOf(objval))).longValue());
                            }
                        }
                    }
                }
            }

            //组装需要更新的关联记录
            Map<String, FormRelationRecord> recordMap = masterBean.getFormRelationRecordMap();
            if (recordMap != null && !recordMap.isEmpty()) {
                for (Entry<String, FormRelationRecord> entry : recordMap.entrySet()) {
                    FormRelationRecord record = entry.getValue();
                    record.setFromMasterDataId(masterBean.getId());
                    recordList.add(record);
                }
            }

            //流水号记录
            List<FormSerialCalculateRecord> serialRecord = (List<FormSerialCalculateRecord>) masterBean.getExtraAttr(FormConstant.serialCalRecords);
            if (Strings.isNotEmpty(serialRecord)) {
                serialRecordList.addAll(serialRecord);
            }

            Strings.addToMap(datas, formBean.getMasterTableBean().getTableName(), masterBean);
            List<FormTableBean> subTables = formBean.getSubTableBean();
            for (FormTableBean tableBean : subTables) {
                List<FormDataSubBean> subBeen = masterBean.getSubData(tableBean.getTableName());
                if (Strings.isNotEmpty(subBeen)) {
                    List<FormDataBean> temp = datas.get(tableBean.getTableName());
                    if (temp == null) {
                        temp = new ArrayList<FormDataBean>();
                    }
                    temp.addAll(subBeen);
                    datas.put(tableBean.getTableName(), temp);
                }
            }
        }

        for (Entry<String, List<FormDataBean>> et : datas.entrySet()) {
            //OA-101139	表单导入2150条，但实际没有导入2150条  oracle批量插入有限制，所以这里做一个分段
            if ("oracle".equals(JDBCAgent.getDBType())) {
                List<FormDataBean> formDataBean = et.getValue();
                int paramSize = formDataBean.get(0).getRowData().size();
                int pageSize = 32000 / paramSize;//32768 oracle executeBatch支持最大的参数值
                List<FormDataBean>[] lists = formCacheManager.splitList(formDataBean, pageSize);
                for (final List<FormDataBean> dataList : lists) {
                    formDataDAO.insertData(dataList);
                }
            } else {
                formDataDAO.insertData(et.getValue());
            }
        }

        if (Strings.isNotEmpty(enumId)) {
            enumManagerNew.updateEnumItemRef(new ArrayList<Long>(enumId));
        }

        List<BasePO> pos = new ArrayList<BasePO>();
        if (Strings.isNotEmpty(recordList)) {
            DBAgent.evict(recordList);
            pos.addAll(recordList);
//            formRelationRecordDAO.insertList(recordList);
        }

        if (Strings.isNotEmpty(serialRecordList)) {
            pos.addAll(serialRecordList);
//            serialCalRecordManager.save(serialRecordList);
        }

        if (Strings.isNotEmpty(contentAlls)) {
            pos.addAll(contentAlls);
//            MainbodyService.getInstance().saveOrUpdateContentAll(contentAlls);
        }

        if (Strings.isNotEmpty(pos)) {
            DBAgent.saveAll(pos);
        }
    }

    /* (non-Javadoc)
         * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#getFormFieldDisplayForImport(com.seeyon.ctp.form.bean.FormBean, com.seeyon.ctp.form.bean.FormAuthViewBean)
         */
    @Override
    public List<List<FormFieldBean>> getFormFieldDisplayForImportAndExport(FormBean form, FormBindAuthBean bindAuthBean, AuthName authName)
            throws BusinessException {
        if (form != null) {
            FieldAccessType fieldAccessType = null;
            FormAuthorizationType formAuthorizationType = null;
            if (AuthName.ADD == authName) {
                fieldAccessType = FieldAccessType.edit;
                formAuthorizationType = FormAuthorizationType.add;
            } else if (AuthName.BROWSE == authName) {
                fieldAccessType = FieldAccessType.browse;
                formAuthorizationType = FormAuthorizationType.show;
            }
            List<FormAuthViewBean> favbList = new ArrayList<FormAuthViewBean>();
            if (form.getFormType() == FormType.baseInfo.getKey()) {
                FormViewBean tempFormViewBean = form.getFormViewList().get(0);
                List<FormAuthViewBean> addAuths = tempFormViewBean.getFormAuthViewBeanListByType(formAuthorizationType);
                favbList.add(addAuths.get(0));
            } else {
                String authStrs = null;
                if (AuthName.ADD == authName) {
                    authStrs = bindAuthBean.getNewFormAuth();
                } else if (AuthName.BROWSE == authName) {
                    authStrs = bindAuthBean.getShowFormAuth();
                }
                if (Strings.isNotBlank(authStrs)) {
                    String[] authStrArray = authStrs.split("\\|");
                    for (String authStr : authStrArray) {
                        String[] str = authStr.split("\\.");
                        String viewId = str[0];
                        String authId = str[1];
                        FormViewBean fvb = form.getFormView(Long.valueOf(viewId));
                        //BUG_重要_V5_V5.6SP1_成都赫尔墨斯科技有限公司_信息表导出excel：导出数据需要一段时间处理，请耐心等待。客户表单回显。户数据不知道怎么搞的，视图id为无效的，导致这里找不到视图对象
                        if (fvb == null) {
                            continue;
                        }
                        List<FormAuthViewBean> favbs = fvb.getAllOperations();
                        for (FormAuthViewBean favb : favbs) {
                            if (authId.equals(favb.getId().toString())) {
                                favbList.add(favb);
                                break;
                            }
                        }
                    }
                }
            }
            List<FormTableBean> tableList = form.getTableList();
            List<List<FormFieldBean>> expotFields = new ArrayList<List<FormFieldBean>>(tableList.size());
            //记录表的名字
            List<String> tableName = new ArrayList<String>(tableList.size());
            List<String> comEnums = new ArrayList<String>();
            comEnums.add(FormFieldComEnum.EXTEND_ATTACHMENT.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_DOCUMENT.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_IMAGE.getKey());
            //dee字段支持导出 20170531
            //comEnums.add(FormFieldComEnum.EXTEND_EXCHANGETASK.getKey());
            //comEnums.add(FormFieldComEnum.EXTEND_QUERYTASK.getKey());
            comEnums.add(FormFieldComEnum.HANDWRITE.getKey());
            comEnums.add(FormFieldComEnum.MAP_LOCATE.getKey());
            comEnums.add(FormFieldComEnum.MAP_MARKED.getKey());
            comEnums.add(FormFieldComEnum.MAP_PHOTO.getKey());
            comEnums.add(FormFieldComEnum.LINE_NUMBER.getKey());
            comEnums.add(FormFieldComEnum.BARCODE.getKey());
            List<FormFieldBean> fieldBeans = this.formAuthDesignManager.getFormFieldBean4Import(form, favbList,
                    fieldAccessType, comEnums, true);

            tableName.add(form.getMasterTableBean().getTableName());
            expotFields.add(new ArrayList<FormFieldBean>());
            for (FormFieldBean formFieldBean : fieldBeans) {
                if (formFieldBean.isMasterField()) {
                    expotFields.get(0).add(formFieldBean);
                } else {
                    if (!tableName.contains(formFieldBean.getOwnerTableName())) {
                        tableName.add(formFieldBean.getOwnerTableName());
                        expotFields.add(new ArrayList<FormFieldBean>());
                    }
                    expotFields.get(tableName.indexOf(formFieldBean.getOwnerTableName())).add(formFieldBean);
                }
            }
            return expotFields;
        }
        return null;
    }

    /**
     * 判断数据唯一 数据保存和批量刷新、批量修改时调用
     * */
    @Override
    public boolean isFieldUnique(FormFieldBean ffb, String tableName, List<FormDataBean> dataBeanList,
                                 List<FormDataBean> oldDataBeanList) throws BusinessException {
        return this.isFieldUnique(ffb, tableName, dataBeanList, oldDataBeanList, false);
    }

    /**
     * 判断数据唯一 目前只有方法内部调用
     * */
    @Override
    public boolean isFieldUnique(FormFieldBean ffb, String tableName, List<FormDataBean> dataBeanList, List<FormDataBean> oldDataBeanList, boolean needCheckSameValue) throws BusinessException {
        if (Strings.isEmpty(dataBeanList)) {
            return false;
        }
        List<FormDataBean> tempDataBeanList = new ArrayList<FormDataBean>();
        //首先,如果是重复表字段，先判断传进来的list本身是否有重复的
        if (!ffb.isMasterField()) {
            //该变量目的是用来判断是否有重复的
            Set<Object> set = new HashSet<Object>();
            boolean isExist = false;
            for (int i = 0; i < dataBeanList.size(); i++) {
                Object value = dataBeanList.get(i).getFieldValue(ffb.getName());
                if (value == null) {
                    continue;
                }
                if (!set.add(value)) {
                    isExist = true;
                    break;
                }
                tempDataBeanList.add(dataBeanList.get(i));
            }
            if (isExist)
                return true;
        } else {
            tempDataBeanList.addAll(dataBeanList);
        }

        List<Object> dataList = new ArrayList<Object>();
        List<Object> oldDataList = new ArrayList<Object>();
        List<FormDataBean> addBeanList = new ArrayList<FormDataBean>();
        List<Long> delBeanList = new ArrayList<Long>();
        List<Long> existBeanList = new ArrayList<Long>();
        List<FormDataBean> compareBeanList = new ArrayList<FormDataBean>();
        if (Strings.isEmpty(oldDataBeanList)) {
            for (FormDataBean formDataBean : tempDataBeanList) {
                Object value = formDataBean.getFieldValue(ffb.getName());
                dataList.add(value);
                existBeanList.add(formDataBean.getId());
            }
        } else {
            for (FormDataBean dataBean : tempDataBeanList) {
                Object value = dataBean.getFieldValue(ffb.getName());
                FormDataBean temp = null;
                for (FormDataBean oldDataBean : oldDataBeanList) {
                    Object oldValue = oldDataBean.getFieldValue(ffb.getName());
                    if (oldValue == null) {
                        continue;
                    }
                    if (dataBean.equals(oldDataBean)) {
                        temp = oldDataBean;
                        oldDataList.add(oldValue);
                        break;
                    }
                }
                if (temp != null) {
                    dataList.add(value);
                    existBeanList.add(dataBean.getId());
                    compareBeanList.add(dataBean);
                }
            }
            tempDataBeanList.removeAll(compareBeanList);
            addBeanList = tempDataBeanList;
            if (Strings.isNotEmpty(addBeanList)) {
                for (FormDataBean dataBean : addBeanList) {
                    dataList.add(dataBean.getFieldValue(ffb.getName()));
                    existBeanList.add(dataBean.getId());
                }
            }
            oldDataBeanList.removeAll(compareBeanList);
            for (FormDataBean formDataBean : oldDataBeanList) {
                delBeanList.add(formDataBean.getId());
            }
        }

        //接下来,就是拼装sql语句，去数据库查找是否存在重复的数据了。
        //调用JDBC工具类执行查询
        JDBCAgent jdbc = null;
        StringBuilder sql = new StringBuilder();
        List<Object> values = new ArrayList<Object>();
        try {
            jdbc = new JDBCAgent();
            sql.append(" select id from " + tableName + " where ");
            //遍历数据组装
            for (int j = 0; j < dataList.size(); j++) {
                Object value = dataList.get(j);
                Object compareValue = value == null ? null : ffb.getDisplayValue(value)[1];
                //这里主要获取旧数据，如果有旧数据，说明是修改。需要判断旧数据和现在是否一致
                Object oldValue = null;
                if (oldDataList.size() > j) oldValue = ffb.getDisplayValue(oldDataList.get(j))[1];
                if (FieldType.DATETIME.getKey().equals(ffb.getFieldType())) {
                    if (value instanceof Date) {
                        String s = DateUtil.getDate((Date) value, DateUtil.YMDHMS_PATTERN);
                        value = DateUtil.parseTimestamp(s, DateUtil.YMDHMS_PATTERN);
                    } else if (value instanceof String) {
                        value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YMDHMS_PATTERN);
                    }
                } else if (FieldType.TIMESTAMP.getKey().equals(ffb.getFieldType())) {
                    if (value instanceof Date) {
                        String s = DateUtil.getDate((Date) value, DateUtil.YEAR_MONTH_DAY_PATTERN);
                        value = DateUtil.parseTimestamp(s, DateUtil.YEAR_MONTH_DAY_PATTERN);
                    } else if (value instanceof String) {
                        value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YEAR_MONTH_DAY_PATTERN);
                    }
                }

                //新值为空，不校验
                if (compareValue == null) {
                    continue;
                }

                //新值不为空，旧值为空，直接校验
                if (oldValue == null) {
                    //第一条特殊处理，同时这边也可能就只有一条的情况。
                    if (j == 0) {
                        sql.append(ffb.getName() + " =  ? ");
                    } else {
                        if (sql.indexOf("?") > -1) {
                            sql.append(" or " + ffb.getName() + " =  ? ");
                        } else {
                            sql.append(ffb.getName() + " =  ? ");
                        }
                    }
                    values.add(value);
                    continue;
                }

                //新值和旧值相同，且不需要校验时，不校验
                if (!needCheckSameValue && compareValue.toString().equals(oldValue.toString())) {
                    continue;
                }

                //第一条特殊处理，同时这边也可能就只有一条的情况。
                if (j == 0) {
                    sql.append(ffb.getName() + " =  ? ");
                } else {
                    if (sql.indexOf("?") > -1) {
                        sql.append(" or " + ffb.getName() + " =  ? ");
                    } else {
                        sql.append(ffb.getName() + " =  ? ");
                    }
                }
                values.add(value);
            }
            int count = sql.indexOf("?") > -1 ? jdbc.execute(sql.toString(), values) : 0;
            if (count > 0) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> list = jdbc.resultSetToList();
                count = 0;
                if (Strings.isNotEmpty(list)) {
                    for (Map<String, Object> map : list) {
                        String ids = String.valueOf(map.get("id"));
                        if (!StringUtil.checkNull(ids)) {
                            Long id = Long.valueOf(ids);
                            if (ffb.isMasterField()) {
                                if (tempDataBeanList.get(0).getId().equals(id)) {
                                    continue;
                                }
                            } else {
                                if (delBeanList.contains(id)) {
                                    continue;
                                } else if (existBeanList.contains(id)) {
                                    continue;
                                }
                            }
                            count++;
                        }
                    }
                }

            }
            //返回list大于0表示有重复数据
            if (count > 0)
                return true;
        } catch (Exception e) {
            throw new BusinessException(e);
        } finally {
            if (jdbc != null) {
                jdbc.close();
            }
        }
        return false;
    }

    /**
     * 针对回写做的数据唯一校验
     */
    @Override
    public boolean isFieldUnique4FillBack(FormFieldBean ffb, String tableName, List<Object> dataList, List<Object> oldDataList) throws BusinessException {
        //首先,如果是重复表字段，先判断传进来的list本身是否有重复的
        if (!ffb.isMasterField()) {
            //该变量目的是用来判断是否有重复的
            Map<Object, Object> map = new HashMap<Object, Object>();
            boolean isExist = false;
            for (int i = 0; i < dataList.size(); i++) {
                if (dataList.get(i) == null) {
                    continue;
                }
                //如果包含这个键值，说明数据重复
                if (map.containsKey(dataList.get(i))) {
                    isExist = true;
                    break;
                } else {
                    map.put(dataList.get(i), dataList.get(i));
                }
            }
            if (isExist)
                return true;
        }
        //接下来,就是拼装sql语句，去数据库查找是否存在重复的数据了。
        //调用JDBC工具类执行查询
        JDBCAgent jdbc = null;
        StringBuilder sql = new StringBuilder();
        List<Object> values = new ArrayList<Object>();
        try {
            jdbc = new JDBCAgent();
            sql.append(" select id from " + tableName + " where ");
            //遍历数据组装
            for (int j = 0; j < dataList.size(); j++) {
                Object value = dataList.get(j);
                Object compareValue = value == null ? null : ffb.getDisplayValue(value)[1];
                //这里主要获取旧数据，如果有旧数据，说明是修改。需要判断旧数据和现在是否一致
                Object oldValue = null;
                if (null != oldDataList && oldDataList.size() > j)
                    oldValue = ffb.getDisplayValue(oldDataList.get(j))[1];
                if (FieldType.DATETIME.getKey().equals(ffb.getFieldType())) {
                    if (value instanceof Date) {
                        String s = DateUtil.getDate((Date) value, DateUtil.YMDHMS_PATTERN);
                        value = DateUtil.parseTimestamp(s, DateUtil.YMDHMS_PATTERN);
                    } else if (value instanceof String) {
                        value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YMDHMS_PATTERN);
                    }
                } else if (FieldType.TIMESTAMP.getKey().equals(ffb.getFieldType())) {
                    if (value instanceof Date) {
                        String s = DateUtil.getDate((Date) value, DateUtil.YEAR_MONTH_DAY_PATTERN);
                        value = DateUtil.parseTimestamp(s, DateUtil.YEAR_MONTH_DAY_PATTERN);
                    } else if (value instanceof String) {
                        value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YEAR_MONTH_DAY_PATTERN);
                    }
                }
                //修改状态下，数据唯一字段如果数据和之前一致，不需要进行校验数据唯一
                if ((oldValue != null && compareValue != null && !compareValue.toString().equals(oldValue.toString()) || oldValue == null)) {
                    //第一条特殊处理，同时这边也可能就只有一条的情况。
                    if (j == 0) {
                        sql.append(ffb.getName() + " =  ? ");
                    } else {
                        if (sql.indexOf("?") > -1) {
                            sql.append(" or " + ffb.getName() + " =  ? ");
                        } else {
                            sql.append(ffb.getName() + " =  ? ");
                        }
                    }
                    values.add(value);
                }
            }
            int count = sql.indexOf("?") > -1 ? jdbc.execute(sql.toString(), values) : 0;
            //返回list大于0表示有重复数据
            if (count > 0)
                return true;
        } catch (Exception e) {
            LOGGER.error(ffb.getName() + " 做数据唯一判断时异常，", e);
            throw new BusinessException(e);
        } finally {
            if (jdbc != null) {
                jdbc.close();
            }
        }
        return false;
    }

    @Override
    public boolean isFieldValue4Unique(FormFieldBean ffb, Object data, String isNew) throws BusinessException {
        JDBCAgent jdbc = null;
        try {
            jdbc = new JDBCAgent();
            StringBuilder sql = new StringBuilder();
            sql.append(" select id from " + ffb.getOwnerTableName() + " where " + ffb.getName() + " = ?");
            int count = jdbc.execute(sql.toString(), data);
            if (("false".equals(isNew) && count > 1) || ("true".equals(isNew) && count > 0)) {
                return true;
            }
        } catch (Exception e) {
            throw new BusinessException(e);
        } finally{
            if(jdbc!=null){
                jdbc.close();
            }
        }
        return false;
    }

    @Override
    public boolean isFieldHasUnique(String fieldName, String tableName) throws BusinessException {
        JDBCAgent jdbc = null;
        try {
            jdbc = new JDBCAgent();
            StringBuilder sql = new StringBuilder();
            sql.append("select count( " + fieldName + ")  from  " + tableName + " group by (  " + fieldName + " )  HAVING COUNT( " + fieldName + " ) > 1 ");
            int count = jdbc.execute(sql.toString());
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            throw new BusinessException(e);
        } finally {
            if (jdbc != null) {
                jdbc.close();
            }
        }
        return false;
    }

    /**
     * 判断唯一标识  保存数据和批量刷新、批量修改时调用
     */
    @Override
    public boolean isUniqueMarked(FormBean fb, FormDataMasterBean formData, List<String> fieldList) throws BusinessException {
        //记录一个最大值max,该值的目的是为了给?号赋值。因为重复表可能多行，必须每一行都要赋值。主一，重一（第一行）。主一，重一（第二行）
        int max = 1;
        //存入每个字段对应的表名字
        List<String> allTableName = new ArrayList<String>();
        //记录所有表名list
        List<String> tableNameList = new ArrayList<String>();
        //重复表列表
        List<String> slaveList = new ArrayList<String>();
        String subTableName = "";
        //首先判断重复表字段唯一标识是否有重复的。
        tableNameList.add(fb.getMasterTableBean().getTableName());
        Map<String, Object> masterMap = formData.getRowData();
        for (int i = 0; i < fieldList.size(); i++) {
            String fieldName = fieldList.get(i);
            FormFieldBean ffb = fb.getFieldBeanByName(fieldName);
            if (ffb.isMasterField()) {
                String masterValue = String.valueOf(masterMap.get(fieldName));
                if (Strings.isBlank(masterValue)) {
                    return false;
                }
            }
            String tableName = ffb.getOwnerTableName();
            //通过表名获取子表数据列表。以便得到最大的行数
            List<FormDataSubBean> subList = formData.getSubData(tableName);
            if (subList != null && subList.size() > max) {
                max = subList.size();
            }
            allTableName.add(tableName);
            //添加表名字到list,以便后边和数据库对比时使用
            if (!tableNameList.contains(tableName)) {
                tableNameList.add(tableName);
            }
            //表示重复表字段。首先判断重复表字段是否有重复的数据
            if (ffb != null && !ffb.isMasterField()) {
                slaveList.add(fieldName);
                if ("".equals(subTableName)) {
                    subTableName = ffb.getOwnerTableName();
                }
            }
        }
        if (!"".equals(subTableName)) {
            boolean isSlaveExist = isExistSameSlaveValue(formData.getSubData(subTableName), slaveList);
            if (isSlaveExist) {
                return true;
            }
        }
        /*-------------------------------------去数据库查询是否存在唯一标识组合---------------------------------*/
        JDBCAgent jdbc = null;
        try {
            jdbc = new JDBCAgent();
            //组装from头sql
            StringBuilder sql = new StringBuilder();
            sql.append(" select " + tableNameList.get(0) + ".id from ");
            for (int i = 0; i < tableNameList.size(); i++) {
                if (i == 0) {
                    sql.append(tableNameList.get(i));
                } else {
                    sql.append(" left join " + tableNameList.get(i) + " on " + tableNameList.get(0) + ".id=" + tableNameList.get(i) + ".formmain_id ");
                }
            }
            sql.append(" where   ");
            //循环遍历唯一标识字段列表，组装a0.field0001 = ? and a1.field0003 = ?等等
            for (int i = 0; i < fieldList.size(); i++) {
                //i=末行的时候不应该有and
                if (i == (fieldList.size() - 1)) {
                    //这里么通过遍历需要传入表名列表，然后根据该字段的表名进行添加。
                    for (int k = 0; k < tableNameList.size(); k++) {
                        if (tableNameList.get(k).equals(allTableName.get(i))) {
                            sql.append(tableNameList.get(k) + "." + fieldList.get(i) + "= ? ");
                        }
                    }
                } else {
                    for (int k = 0; k < tableNameList.size(); k++) {
                        if (tableNameList.get(k).equals(allTableName.get(i))) {
                            sql.append(tableNameList.get(k) + "." + fieldList.get(i) + "=" + " ?  and ");
                        }
                    }
                }
            }
            boolean isExistDB = false;
            //循环最大值max,即为了组装?的值。
            for (int i = 0; i < max; i++) {
                List<Object> valueList = new ArrayList<Object>();
                Object value = null;
                //如果某个重复表字段为null值那么就不校验。
                boolean flag = false;
                for (int k = 0; k < fieldList.size(); k++) {
                    FormFieldBean ffb = fb.getFieldBeanByName(fieldList.get(k));
                    List<Object> dataList = formData.getDataList(fieldList.get(k));
                    if (ffb.isMasterField()) {
                        value = dataList != null && dataList.size() > 0 ? dataList.get(0) : null;
                    } else {
                        value = i >= dataList.size() ? null : dataList.get(i);
                    }
                    //如果值为空的话，就不校验。
                    if (value == null) {
                        flag = true;
                        break;
                    }
                    if (FieldType.DATETIME.getKey().equals(ffb.getFieldType())) {
                        if (value instanceof Date) {
                            String s = DateUtil.getDate((Date) value, DateUtil.YMDHMS_PATTERN);
                            value = DateUtil.parseTimestamp(s, DateUtil.YMDHMS_PATTERN);
                        } else if (value instanceof String) {
                            value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YMDHMS_PATTERN);
                        }
                    } else if (FieldType.TIMESTAMP.getKey().equals(ffb.getFieldType())) {
                        if (value instanceof Date) {
                            String s = DateUtil.getDate((Date) value, DateUtil.YEAR_MONTH_DAY_PATTERN);
                            value = DateUtil.parseTimestamp(s, DateUtil.YEAR_MONTH_DAY_PATTERN);
                        } else if (value instanceof String) {
                            value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YEAR_MONTH_DAY_PATTERN);
                        }
                    }
                    valueList.add(value);
                }
                if (flag) continue;
                sql.append(" and " + tableNameList.get(0) + ".id <> " + formData.getId());
                int count = sql.indexOf("?") > -1 ? jdbc.execute(sql.toString(), valueList) : 0;
                //
                if (count > 0) {
                    isExistDB = true;
                    break;
                }
            }
            return isExistDB;
        } catch (Exception e) {
            LOGGER.error(fb.getFormName() + " 判断数据唯一标识发生异常：" + formData.getId(), e);
            throw new BusinessException(e);
        } finally {
            if (jdbc != null) {
                jdbc.close();
            }
        }
    }

    /**
     * 是否存在相同的重复表字段组合
     *
     * @return
     */
    private boolean isExistSameSlaveValue(List<FormDataSubBean> subDatas, List<String> fields) {
        boolean isExist = false;
        if (Strings.isNotEmpty(subDatas) && Strings.isNotEmpty(fields)) {
            StringBuilder sb = new StringBuilder();
            List<String> subLineDataList = new ArrayList<String>();
            for (FormDataSubBean fdsb : subDatas) {
                for (int i = 0; i < fields.size(); i++) {
                    Object subValue = fdsb.getFieldValue(fields.get(i));
                    if (subValue == null) {
                        sb.setLength(0);
                        break;
                    } else {
                        sb.append(subValue);
                    }
                }
                if (sb.length() < 1) {
                    continue;
                }
                if (subLineDataList.contains(sb.toString())) {
                    isExist = true;
                    break;
                } else {
                    subLineDataList.add(sb.toString());
                }
                sb.setLength(0);//清空sb
            }
        }
        return isExist;
    }

    @Override
    public boolean isFieldHasUniqueMarked(String fieldList) throws BusinessException {
        String[] fields = fieldList.split(",");
        List<String> newFieldList = Arrays.asList(fields);
        //存入每个字段对应的表名字
        //List<String> allTableName = new ArrayList<String>();
        //记录所有表名list
        List<String> tableNameList = new ArrayList<String>();
        //获得当前编辑表单
        FormBean fb = formManager.getEditingForm();
        if (fb != null) {
            tableNameList.add(fb.getMasterTableBean().getTableName());
            //循环遍历字段列表
            for (int k = 0; k < newFieldList.size(); k++) {
                String fieldName = newFieldList.get(k);
                FormFieldBean ffb = fb.getFieldBeanByName(fieldName);
                String tableName = ffb.getOwnerTableName();
                //allTableName.add(tableName);
                //添加表名字到list,以便后边和数据库对比时使用
                if (!tableNameList.contains(tableName)) tableNameList.add(tableName);
            }
            JDBCAgent jdbc = null;
            try {
                jdbc = new JDBCAgent();
                //组装from头sql
                StringBuilder sql = new StringBuilder();
                sql.append(" select count(" + tableNameList.get(0) + ".id) from ");
                for (int i = 0; i < tableNameList.size(); i++) {
                    if (i == 0) {
                        sql.append(tableNameList.get(i));
                    } else {
                        sql.append(" left join " + tableNameList.get(i) + " on " + tableNameList.get(0) + ".id=" + tableNameList.get(i) + ".formmain_id ");
                    }
                }

                StringBuilder temp = new StringBuilder(" where ");
                for (String aNewFieldList : newFieldList) {
                    temp.append(aNewFieldList).append(" is not null and ");
                }
                temp.append(" 1=1 ");

                sql.append(temp);

                sql.append(" group  by ");
                //循环遍历唯一标识字段列表，组装a0.field0001 = ? and a1.field0003 = ?等等
                for (int i = 0; i < newFieldList.size(); i++) {
                    //i=末行的时候不应该有and
                    if (i == (newFieldList.size() - 1)) {
                        //这里通过遍历需要传入表名列表，然后根据该字段的表名进行添么加。
                        sql.append(newFieldList.get(i)).append(" ");
                    } else {
                        sql.append(newFieldList.get(i) + ",");
                    }
                }
                sql.append(" having count(" + tableNameList.get(0) + ".id) >1 ");
                int count = jdbc.execute(sql.toString());
                if (count > 0) {
                    return true;
                }
            } catch (Exception e) {
                LOGGER.error(fieldList + "ajax 判断数据唯一时异常：", e);
                return false;
            } finally {
                if (jdbc != null) {
                    jdbc.close();
                }
            }
        }
        return false;
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#getReplaceMsg(com.seeyon.ctp.form.bean.FormBean, java.util.Map)
     */
    @Override
    public String getReplaceMsg(String msg, FormBean fb, Map<String, Object> data, boolean needSubData) throws BusinessException {
        //20151222015290 表单流程标题设置了登录人员姓名、系统日期，但是表单发送之后标题没有把姓名和日期带出
        LOGGER.info("开始执行字符串表单数据替换：对象->" + msg + " 当前登录语言 " + AppContext.getLocale());
        String subject = msg;
        Pattern p = Pattern.compile("(\\{[^\\}]*\\})|(\\[[^\\]]*\\])");
        Matcher m = p.matcher(msg);
        while (m.find()) {
            String group = m.group();
            //LOGGER.info("当前匹配对象：" + group);
            String key = "";
            String value = group;
            if ((group.startsWith(FormulaEnums.FormulaExtendSymbol.leftBigBracket.getKey()) && group.endsWith(FormulaEnums.FormulaExtendSymbol.rightBigBracket.getKey()))) {
                key = group.substring(1, group.length() - 1);
                FormFieldBean tempFieldBean = fb.getFieldBeanByDisplay(key);
                if (tempFieldBean != null) {
                    if (needSubData) {
                        value = tempFieldBean.findRealFieldBean().getDisplayValue(data.get(tempFieldBean.getName()), false)[1].toString();
                    } else {
                        if (tempFieldBean.isMasterField()) {
                            Object dbValue = data.get(tempFieldBean.getName());
                            //LOGGER.info("数据库存储值：" + dbValue);
                            value = tempFieldBean.findRealFieldBean().getDisplayValue(dbValue, false)[1].toString();
                            //LOGGER.info("转换值：" + dbValue);
                        }
                    }
                } else {
                    SystemDataField dataField = SystemDataField.getEnumByText(key);
                    if (dataField != null) {
                        value = dataField.getKey();
                        switch (dataField) {
                            case approvalState:
                                value = FormDataStateEnum.getFlowFormDataStateEnumByKey((Integer) data.get(MasterTableField.state.getKey())).getText();
                                break;
                            case createDate:
                                value = DateUtil.format((Date) data.get(value), DateUtil.YMDHMS_PATTERN);
                                break;
                            case creator:
                                value = orgManager.getMemberById((Long) data.get(value)).getName();
                                break;
                            case flowState:
                                value = FromDataFinishedFlagEnum.getFlowStateByKey((Integer) data.get(MasterTableField.finishedflag.getKey())).getText();
                                break;
                            case modify_date:
                                value = DateUtil.format((Date) data.get(value), DateUtil.YMDHMS_PATTERN);
                                break;
                            case ratifyState:
                                value = FormDataRatifyFlagEnum.getFromLogOperateTypeByKey((Integer) data.get(MasterTableField.ratifyflag.getKey())).getText();
                                break;
                            default:
                                break;
                        }
                    } else if (key.contains("System")) { //兼容老数据，不知道是啥时候的版本，系统变量格式为{System.当前登录人员姓名} 现行格式为[当前登录人员姓名]
                        String temp = key.substring(key.indexOf(".") + 1);
                        FormulaVar var = FormulaVar.getEnumByText(temp);
                        if (var != null) {
                            value = var.getValue();
                        }
                    }
                }
            } else if ((group.startsWith(FormulaEnums.FormulaExtendSymbol.leftSquareBracket.getKey()) && group.endsWith(FormulaEnums.FormulaExtendSymbol.rightSquareBracket.getKey()))) {
                key = group.substring(1, group.length() - 1);
                FormulaVar var = FormulaVar.getEnumByText(key);
                if (var != null) {
                    Object obj = var.getValue();
                    if (obj == null) {
                        value = "";
                    } else {
                        value = obj.toString();
                    }
                }
            }
            //LOGGER.info(group + " 匹配结果：" + value);
            if (StringUtil.checkNull(value)) {
                value = "";
            }
            //LOGGER.info(group + " 匹配结果：" + value);
            subject = subject.replace(group, value);
        }
        LOGGER.info("结束执行字符串表单数据替换：结果-> " + subject);
        return subject;
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
     * 查询动态表的基础方法
     *
     * @param returnFields
     * @param table
     * @param whereId
     * @param id
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public List<Map<String, Object>> getFormSlaveDataListById(String[] returnFields, String table, String whereId, List<Long> ids) throws BusinessException {
        if (ids != null) {
            String fieldNames = (returnFields == null || returnFields.length == 0) ? "*" : StringUtils.arrayToString(returnFields);
            List<Long>[] subIds = Strings.splitList(ids, 1000);
            List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
            for (List<Long> subId : subIds) {
                StringBuilder sql = new StringBuilder("select " + fieldNames + " from " + table + " where " + whereId + " in (");
                for (int i = 0; i < subId.size(); i++) {
                    if (i == subId.size() - 1) {
                        sql.append("?");
                    } else {
                        sql.append("?,");
                    }
                }
                sql.append(" ) order by sort asc");
                JDBCAgent jdbc = new JDBCAgent();
                try {
                    jdbc.execute(sql.toString(), subId);
                    List<Map<String, Object>> resList = jdbc.resultSetToList();
                    if (resList != null) {
                        resultList.addAll(resList);
                    }
                } catch (SQLException e) {
                    LOGGER.error(e.getMessage(), e);
                    throw new BusinessException(e);
                } finally {
                    if (jdbc != null) {
                        jdbc.close();
                    }
                }
            }
            return resultList;
        }
        return null;
    }

    /**
     * 设置要显示的字段
     *
     * @param formBean
     * @param formDataList
     * @param showFieldList
     * @return
     */
    public Map<Long, List<List<String>>> setShowValueList(FormBean formBean, List<Map<String, Object>> formDataList, List<FormFieldBean> showFieldList, Map<Long, String> idMap) throws BusinessException {
        if (showFieldList != null && formDataList != null) {
            Map<Long, List<List<String>>> dataMap = new HashMap<Long, List<List<String>>>();
            Map<String, FormFieldBean> realFormFieldBeanMap = new HashMap<String, FormFieldBean>();
            for (Map<String, Object> lineValues : formDataList) {
                Long mainId = Long.valueOf(String.valueOf(lineValues.get(SubTableField.formmain_id.getKey())));
                List<List<String>> rowList = null;
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
                        Object[] objs = null;
                        objs = fieldBean.getDisplayValue(value);
                        row.add((String) (objs[1]));
                    } else {
                        MasterTableField me = MasterTableField.getEnumByText(key);
                        if (null != me) {
                            fieldBean = me.getFormFieldBean();
                        }
                        if (fieldBean != null) {
                            Object value = lineValues.get(fieldBean.getName());
                            try {
                                Object[] objs = null;
                                objs = fieldBean.getDisplayValue(value);
                                row.add((String) (objs[1]));
                            } catch (Exception e) {
                                throw new BusinessException(e);
                            }
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
     * 触发数据存档、分发联动、双向联动、自动更新保存新增数据的正文信息
     * */
    @Override
    public void saveDataAndContent(FormBean formBean, FormDataMasterBean masterBean, long creater, long templateId, String title) throws BusinessException, SQLException {
        //从自动更新处调用此方法的时候，传入的templateId就是ctpContentAll模板的moduleTemplateId了，因此不用再去转换
        String dataFrom = masterBean.getExtraAttr("dataFrom") == null ? "" : (String)masterBean.getExtraAttr("dataFrom");
        //masterBean.putExtraAttr("dataFrom", "");//用完之后马上置空
        masterBean.removeExtraMap("dataFrom");//用完之后马上置空
        //保存动态表数据
        FormService.saveOrUpdateFormData(masterBean, formBean.getId());
        //保存content 需要先根据应用绑定ID来找ctpContentAll的ID，因为ctpContentAll中会有一条模板数据和应用绑定对应，而具体数据中ctpContentAll的moduleTemplateId就是此ctpContentAll模板的ID
        int moduleType = formBean.getFormType() == FormType.manageInfo.getKey() ? ModuleType.unflowInfo.getKey() : ModuleType.unflowBasic.getKey();
        long moduleTemplateId = templateId;
        if(Strings.isBlank(dataFrom)){
            MainbodyManager contentManager = (MainbodyManager) AppContext.getBean("ctpMainbodyManager");
            CtpContentAll contentAll2 = contentManager.getContentListByModuleIdAndModuleType(ModuleType.getEnumByKey(moduleType), templateId).get(0);
            if (contentAll2 == null) {
                throw new BusinessException("触发创建目标数据，目标数据找不到原始模板，可能被删除了！");
            }
            moduleTemplateId = contentAll2.getId();
        }
        CtpContentAll contentAll = getCtpContentAll(creater, masterBean.getId(), moduleType, moduleTemplateId, MainbodyType.FORM.getKey(), formBean.getId(), masterBean.getId(), title);
        MainbodyService.getInstance().saveOrUpdateContentAll(contentAll);
    }


    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#delFormData(java.lang.Long, java.lang.String, java.lang.Long, boolean)
     */
    @Override
    public boolean delFormData(Long formId, String ids, Long templateId, boolean needLog) throws BusinessException,
            SQLException {
        StringBuffer logs = new StringBuffer();
        FormBean fb = formCacheManager.getForm(formId);

        List<FormFieldBean> list = fb.getAllFieldBeans();
        String[] masterFields = new String[list.size()];
        ModuleType moduleType = null;
        switch (FormType.getEnumByKey(fb.getFormType())) {
            case baseInfo:
                moduleType = ModuleType.unflowBasic;
                break;
            case manageInfo:
                moduleType = ModuleType.unflowInfo;
                break;
            case dynamicForm:
            	moduleType = ModuleType.dynamicForm;
            	break;
            default:
                break;
        }
        int master = 0;
        //记录所有需要保存日志的列
        List<FormFieldBean> logfields = new ArrayList<FormFieldBean>();
        for (FormFieldBean ffb : list) {
            //日志记录
            //判断是否需要记录详细日志,日志设置里列+数据唯一的列都要记录
            if (fb.getBind().getLogFieldList().contains(ffb.getOwnerTableName() + "." + ffb.getName())
                    || ffb.isUnique()) {
                //查询时只用主表数据进行查询
                if (ffb.isMasterField()) {
                    masterFields[master++] = ffb.getName();
                }
                logfields.add(ffb);
            }
        }
        //如果没有需要记录的列,则置为空,以免formDataDAO.selectDataByMasterId方法报错
        masterFields = masterFields.length == 0 ? null : masterFields;
        FormDataMasterBean fdmb;
        String id[] = ids.split(",");
        for (int j = 0; j < id.length; j++) {
            if (!this.formDataDAO.isExist(id[j], fb.getMasterTableBean().getTableName())) {
                continue;
            }
            //取得日志记录列的数据
            fdmb = formDataDAO.selectDataByMasterId(Long.parseLong(id[j]), fb, masterFields);
            if (fdmb != null) {
                for (FormFieldBean ffb : logfields) {
                    if (ffb == null) continue;
                    Object tempValue = fdmb.getFieldValue(ffb.getName());
                    if (ffb.isSubField()) {
                        List<FormDataSubBean> subBeans = fdmb.getSubData(ffb.getOwnerTableName());
                        if (subBeans != null && subBeans.size() > 0) {
                            tempValue = subBeans.get(0).getFieldValue(ffb.getName());
                        }
                    }
                    logs.append(FormLogUtil.getLogForDelete(ffb, tempValue));
                }
            }
            //删除全文检索信息
            if (AppContext.hasPlugin("index")) {
                indexManager.delete(Long.parseLong(id[j]), ApplicationCategoryEnum.form.getKey());
            }
            //删除正文数据
            MainbodyService.getInstance().deleteContentAllByModuleId(moduleType, Long.parseLong(id[j]), true);
            //删除表单中lbs相关数据
            lbsManager.deleteAttendanceInfoByMasterDataId(Long.parseLong(id[j]));
            //删除此数据生成的任务F28 --信息管理表单 and 有任务插件 and 有任务联动设置
            List<FormTriggerBean> triggerList = fb.getTriggerList();
            if(moduleType == ModuleType.unflowInfo && AppContext.hasPlugin("taskmanage") && CollectionUtils.isNotEmpty(triggerList)){
            	boolean hasTaskTrigger = false;
            	for(FormTriggerBean trigger:triggerList){
            		if(FormTriggerBean.TriggerType.LinkageSet.getKey() == trigger.getType()){
            			hasTaskTrigger = true;
            			break;
            		}
            	}
            	if(hasTaskTrigger){
            		TaskmanageApi taskManageApi = (TaskmanageApi)AppContext.getBean("taskmanageApi");
            		taskManageApi.deleteTaskInfoBySourceRecordId(Long.parseLong(id[j]));
            	}
            }

            //删除数据时删除对应的时间调度，不在此处删除，时间调度执行的时候如果数据不存在则不执行，如果执行时间是重复表字段删除时，数据多会有性能问题
            //delTriggerQuartzJod(fb, fdmb);
            if (needLog) {
                //记录日志
                formLogManager.saveOrUpdateLog(formId, formCacheManager.getForm(formId).getFormType(), templateId, AppContext.currentUserId(), FormLogOperateType.DELETE.getKey(), logs.toString(), fdmb == null?null:fdmb.getStartMemberId(), fdmb == null?null:fdmb.getStartDate());
            }
            logs.setLength(0);
        }
        return true;
    }

    /**
     * 保存表单单元格附件justMerge为true表明只同步缓存，不同步数据库
     */
    @Override
    public void saveAttachments(FormBean form,
                                FormDataMasterBean cacheMasterData,
                                FormDataMasterBean frontMasterBean, Long moduleId, boolean justMerge) throws Exception {
        AttachmentManager attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
        List<FormFieldBean> allFields = form.getAllFieldBeans();
        List<Attachment> attList = new ArrayList<Attachment>();
        for (FormFieldBean field : allFields) {
            FormFieldBean realField = field.findRealFieldBean();
            //图片、附件、关联文档控件，保存后，需要更新附件表的关系
            if (realField.isAttachment(true, true)) {
                if (field.isMasterField()) {
                    String editAtt = ParamUtil.getString(ParamUtil.getJsonDomain(field.getOwnerTableName()), FormFieldComEnum.getAttKey(field.getName(), "0"), "false");
                    /**
                     * 关联表单关联表单正文，其editAtt永远为false，此处单独处理为true
                     * 数据关联表单正文，其editAtt根据字段权限不同而不同，此处不管其是否可编辑，都处理为true
                     * */
                    FormRelation relation = field.getFormRelation();
                    if (relation != null) {
                        if ((FormFieldComEnum.RELATIONFORM.getKey().equals(field.getInputTypeEnum().getKey())
                                || FormFieldComEnum.RELATION.getKey().equals(field.getInputTypeEnum().getKey()))
                                && FormRelationEnums.ViewAttrValue.formContent.getKey().equals(relation.getViewAttr())) {
                            editAtt = "true";
                        }
                    }
                    //只有编辑权限才处理附件 图片 和关联文档
                    if (editAtt != null && "true".equals(editAtt)) {
                        //编辑权限，前台没有提交数据过来说明单元格没有在视图中
                        Object frontObj = frontMasterBean.getFieldValue(field.getName());
                        Object obj = cacheMasterData.getFieldValue(field.getName());
                        if (!StringUtil.checkNull(String.valueOf(obj)) && !StringUtil.checkNull(String.valueOf(frontObj))) {
                            Long subReference = Long.parseLong(String.valueOf(obj));
                            List<Attachment> oldAtts = attachmentManager.getByReference(moduleId, subReference);
                            List<Attachment> newAtts = getAttachmentsFromRequest(ApplicationCategoryEnum.form, moduleId, subReference);
                            List<Attachment> delAtts = new ArrayList<Attachment>();
                            List<Attachment> addAtts = new ArrayList<Attachment>();
                            if (FormFieldComEnum.BARCODE.getKey().equals(field.getFinalInputType())) {
                                continue;
                            }
                            if (oldAtts != null && newAtts != null) {
                                //数据库中存储的如果在新提交过来的里面不包含，那么就删除了
                                for (Attachment oldAtt : oldAtts) {
                                    boolean oldIsNotInNew = true;
                                    for (Attachment newAtt : newAtts) {
                                        if (newAtt.getFileUrl() != null && oldAtt.getFileUrl() != null && newAtt.getFileUrl().longValue() == oldAtt.getFileUrl().longValue()) {
                                            oldIsNotInNew = false;
                                            break;
                                        }
                                    }
                                    if (oldIsNotInNew) {
                                        delAtts.add(oldAtt);
                                    } else {
                                        attList.add(oldAtt);
                                    }
                                }
                                //新提交过来的在数据库中没有，那么是新增的
                                for (Attachment newAtt : newAtts) {
                                    boolean notInDb = true;
                                    for (Attachment oldAtt : oldAtts) {
                                        if (newAtt.getFileUrl() != null && oldAtt.getFileUrl() != null && newAtt.getFileUrl().longValue() == oldAtt.getFileUrl().longValue()) {
                                            notInDb = false;
                                            break;
                                        }
                                    }
                                    if (notInDb) {
                                        addAtts.add(newAtt);
                                    }
                                }
                            }
                            if (!justMerge) {
                                //删掉的
                                for (Attachment a : delAtts) {
                                    attachmentManager.deleteById(a.getId());
                                }
                            }
                            attList.addAll(addAtts);
                        }
                    }
                } else {
                    List<FormDataSubBean> subdatas = cacheMasterData.getSubData(field.getOwnerTableName());
                    List<Attachment> cacheAtts = (List<Attachment>)cacheMasterData.getExtraAttr(FormConstant.attachments);
                    if (null != subdatas) {
                        for (FormDataSubBean subData : subdatas) {
                            List<Map<String, Object>> subTableData = ParamUtil.getJsonDomainGroup(field.getOwnerTableName());
                            //查看更多功能导致前端有重复行没有加载出来，导致重复表中的附件丢失
                            List<Long> notShowSubDataIds = cacheMasterData.getNotShowSubDataIds(field.getOwnerTableName());//后台缓存的还没有显示出来的行id集合
                            Object fieldValo = subData.getFieldValue(field.getName());
                            if(null!=fieldValo&&null!=notShowSubDataIds&&notShowSubDataIds.contains(subData.getId())) {//没有显示出来的行
                                for(Attachment a:cacheAtts){
                                    Long subreferenceId = a.getSubReference();
                                    Long fieldVal = (Long)Long.parseLong(String.valueOf(fieldValo));
                                    if(subreferenceId!=null&&fieldVal!=null&&subreferenceId.longValue()==fieldVal.longValue()){
                                        attList.add(a);
                                    }
                                }
                            }else{//显示出来的行
                                for (Map<String, Object> map : subTableData) {
                                    Long subId = ParamUtil.getLong(map, "id", 0l);
                                    if (subId.longValue() == subData.getId().longValue()) {
                                        String editAtt = ParamUtil.getString(map, FormFieldComEnum.getAttKey(field.getName(), String.valueOf(subData.getId())), "false");
                                        /**
                                         * 关联表单关联表单正文，其editAtt永远为false，此处单独处理为true
                                         * 数据关联表单正文，其editAtt根据字段权限不同而不同，此处不管其是否可编辑，都处理为true
                                         * */
                                        FormRelation relation = field.getFormRelation();
                                        if (relation != null) {
                                            if ((FormFieldComEnum.RELATIONFORM.getKey().equals(field.getInputTypeEnum().getKey())
                                                    || FormFieldComEnum.RELATION.getKey().equals(field.getInputTypeEnum().getKey()))
                                                    && FormRelationEnums.ViewAttrValue.formContent.getKey().equals(relation.getViewAttr())) {
                                                editAtt = "true";
                                            }
                                        }
                                        //只有编辑权限才处理附件 图片 和关联文档
                                        if (editAtt != null && "true".equals(editAtt)) {
                                            //编辑权限，前台没有提交数据过来说明单元格没有在视图中
                                            Object frontObj = subData.getFieldValue(field.getName());
                                            Object obj = subData.getFieldValue(field.getName());
                                            if (!StringUtil.checkNull(String.valueOf(obj)) && !StringUtil.checkNull(String.valueOf(frontObj))) {
                                                Long subReference = Long.parseLong(String.valueOf(obj));
                                                List<Attachment> oldAtts = attachmentManager.getByReference(moduleId, subReference);
                                                List<Attachment> newAtts = getAttachmentsFromRequest(ApplicationCategoryEnum.form, moduleId, subReference);
                                                List<Attachment> delAtts = new ArrayList<Attachment>();
                                                List<Attachment> addAtts = new ArrayList<Attachment>();
                                                if (FormFieldComEnum.BARCODE.getKey().equals(field.getFinalInputType())) {
                                                    continue;
                                                }
                                                if (oldAtts != null && newAtts != null) {
                                                    //数据库中存储的如果在新提交过来的里面不包含，那么就删除了
                                                    for (Attachment oldAtt : oldAtts) {
                                                        boolean oldIsNotInNew = true;
                                                        for (Attachment newAtt : newAtts) {
                                                            if (newAtt.getFileUrl() != null && oldAtt.getFileUrl() != null && newAtt.getFileUrl().longValue() == oldAtt.getFileUrl().longValue()) {
                                                                oldIsNotInNew = false;
                                                                break;
                                                            }
                                                        }
                                                        if (oldIsNotInNew) {
                                                            delAtts.add(oldAtt);
                                                        } else {
                                                            attList.add(oldAtt);
                                                        }
                                                    }
                                                    //BUG_普通_V5_V5.6SP1_上海悠丰国际旅行社有限责任公司_底表3个控件，填写第3个控件内容后，第1个控件内容清空
                                                    //由于attList只是增加了本次新上传的附件.所以导致开始存在的附件丢失
                                                    //既然新提交过来的.那表示newAtts所有都应该添加到attList,不需要判断是否是已经在数据库中存在
                                                    //注释掉下面for (Attachment newAtt : newAtts) 代码块,attList.addAll(addAtts)-->attList.addAll(newAtts);
                                                    //新提交过来的在数据库中没有，那么是新增的
                                                    for (Attachment newAtt : newAtts) {
                                                        boolean notInDb = true;
                                                        for (Attachment oldAtt : oldAtts) {
                                                            if (newAtt.getFileUrl() != null && oldAtt.getFileUrl() != null && newAtt.getFileUrl().longValue() == oldAtt.getFileUrl().longValue()) {
                                                                notInDb = false;
                                                                break;
                                                            }
                                                        }
                                                        if (notInDb) {
                                                            addAtts.add(newAtt);
                                                        }
                                                    }
                                                }
                                                if (!justMerge) {
                                                    //删掉的
                                                    for (Attachment a : delAtts) {
                                                        attachmentManager.deleteById(a.getId());
                                                    }
                                                }
                                                attList.addAll(addAtts);
                                            }
                                        }
                                    }
                                }
                        }
                        }
                    } else {
                        LOGGER.error("The cacheMasterData can not getSubData for [" + field.getOwnerTableName() + "] ");
                    }
                }
            }
        }
        if (attList.size() > 0) {
            if (!justMerge) {
                attachmentManager.create(attList);
            }
            //更新缓存
            cacheMasterData.putExtraAttr(FormConstant.attachments, attList);
        }
    }

    /**
     * 从request中提取对应reference和subreference的附件、图片、关联文档
     *
     * @param category
     * @param reference
     * @param subReference
     * @return
     * @throws Exception
     */
    private List<Attachment> getAttachmentsFromRequest(ApplicationCategoryEnum category, Long reference, Long subReference) throws Exception {
        List groups1 = ParamUtil.getJsonDomainGroup("attachmentInputs");
        int lsize = groups1.size();
        Map dMap = ParamUtil.getJsonDomain("attachmentInputs");
        if (lsize == 0 && dMap.size() > 0) {
            groups1.add(dMap);
        }
        int k = 0;
        String[] fileUrl = new String[lsize];
        String[] extSubReference = new String[lsize];
        String[] mimeType = new String[lsize];
        String[] size = new String[lsize];
        String[] createdate = new String[lsize];
        String[] filename = new String[lsize];
        String[] type = new String[lsize];
        String[] needClone = new String[lsize];
        String[] description = new String[lsize];
        String[] extReference = new String[lsize];
        String[] subReferencea = new String[lsize];
        List<Attachment> atts = new ArrayList<Attachment>();
        for (Object o : groups1) {
            if (o instanceof Map) {
                Map map = (Map) o;
                fileUrl[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_fileUrl);
                mimeType[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_mimeType);
                size[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_size);
                createdate[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_createDate);
                filename[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_filename);
                type[k] = map.get(Constants.FILEUPLOAD_INPUT_NAME_type) == null ?"0":map.get(Constants.FILEUPLOAD_INPUT_NAME_type).toString();
                needClone[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_needClone);
                description[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_description);
                extReference[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_extReference);
                extReference[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_extReference);
                subReferencea[k] = (String) map.get(Constants.FILEUPLOAD_INPUT_NAME_subReference);
                k++;
            }
        }
        for (int i = 0; i < fileUrl.length; i++) {
            if (!(subReferencea != null && subReferencea.length >= i && Strings.isNotBlank(subReferencea[i]) && subReferencea[i].equals(String.valueOf(subReference)))) {
                continue;
            }
            Date originalCreateDate = Datetimes.parseNoTimeZone(createdate[i],Datetimes.datetimeStyle);
            if (originalCreateDate == null) {
                originalCreateDate = new Date();
            }
            Integer _type = new Integer(type[i]);
            Attachment attachment = new Attachment();
            attachment.setIdIfNew();
            attachment.setSort(i);
            attachment.setCategory(category.getKey());
            if (extReference != null && extReference.length >= i && Strings.isNotBlank(extReference[i])) {
                attachment.setReference(new Long(extReference[i]));
            } else if (reference != null) { //避免空值插入产生异常
                attachment.setReference(reference);
            }
            attachment.setSubReference(subReference);
            attachment.setMimeType(mimeType[i]);
            attachment.setSize(new Long(size[i]));
            attachment.setFilename(Strings.nobreakSpaceToSpace(filename[i]));
            attachment.setType(_type);
            attachment.setDescription(description[i]);
            if (Strings.isNotBlank(description[i])
                    && !"null".equals(description[i])
                    && (_type.equals(Constants.ATTACHMENT_TYPE.DOCUMENT.ordinal()) || _type
                    .equals(Constants.ATTACHMENT_TYPE.FormDOCUMENT.ordinal()))) {
                //将description字段值拷贝到GenesisId，用于提高查询效率(前端改动量大，暂不修改)
                Long genesisId = Long.parseLong(description[i]);
                attachment.setGenesisId(genesisId);
            }
            boolean _needClone = Boolean.parseBoolean(needClone[i]);
            boolean _isFile = Constants.ATTACHMENT_TYPE.DOCUMENT.ordinal() != _type.intValue() && Constants.ATTACHMENT_TYPE.FormDOCUMENT.ordinal() != _type.intValue();
            if (_isFile && _needClone) {
                Long newFileId = UUIDLong.longUUID();
                Date newCreateDate = new Date();
                attachment.setFileUrl(newFileId);
                attachment.setCreatedate(newCreateDate);
            } else {
                attachment.setCreatedate(originalCreateDate);
                if (NumberUtils.isNumber(fileUrl[i])) {
                    attachment.setFileUrl(new Long(fileUrl[i]));
                }
            }
            atts.add(attachment);
        }
        return atts;
    }

    public LbsManager getLbsManager() {
        return lbsManager;
    }

    public void setLbsManager(LbsManager lbsManager) {
        this.lbsManager = lbsManager;
    }

    public IndexManager getIndexManager() {
        return indexManager;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public EnumManager getEnumManagerNew() {
        return enumManagerNew;
    }

    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }

    @Override
    public void deleteNotInFormDataLbs(FormDataMasterBean cacheMasterData, String type) {
        try {
            Long formId = cacheMasterData.getFormTable().getFormId();
            FormBean formBean = formCacheManager.getForm(formId);
            List<FormFieldBean> fields = formBean.getAllFieldBeans();
            List<Long> notInIds = new ArrayList<Long>();
            for (FormFieldBean field : fields) {
                if ((!StringUtil.checkNull(field.getInputType()) && field.getInputType().equalsIgnoreCase(type)) || (!StringUtil.checkNull(String.valueOf(field.getFormatType())) && field.getFormatType().equalsIgnoreCase(type))) {
                    if (field.isMasterField()) {
                        Object val = cacheMasterData.getFieldValue(field.getName());
                        if (!StringUtil.checkNull(String.valueOf(val))) {
                            //地图标注字段回写时给的非数字值，会发生异常 bug OA-98524
                            try {
                                notInIds.add(Long.parseLong(String.valueOf(val)));
                            } catch (Exception e) {
                                LOGGER.info("地图标注字段删除时ID转换异常，字段：" + field.getName() + field.getDisplay() + " 值：" + val);
                            }
                        }
                    } else {
                        List<Object> subFieldVals = cacheMasterData.getDataList(field.getName());
                        for (Object subFieldVal : subFieldVals) {
                            if (!StringUtil.checkNull(String.valueOf(subFieldVal))) {
                                //地图标注字段回写时给的非数字值，会发生异常 bug OA-98524
                                try {
                                    notInIds.add(Long.parseLong(String.valueOf(subFieldVal)));
                                } catch (Exception e) {
                                    LOGGER.info("地图标注字段删除时ID转换异常，字段：" + field.getName() + field.getDisplay() + " 值：" + subFieldVal);
                                }
                            }
                        }
                    }
                }
            }
            if (notInIds.size() > 0) {
                lbsManager.deleteNotInFormData(cacheMasterData.getId(), notInIds);
            }
        } catch (BusinessException e) {
            LOGGER.error(e.getMessage(), e);
        }
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#updateDataState()
	 */
    @Override
    public boolean updateDataState() throws BusinessException {
        String sql = "from ColSummary where newflowType=2 and subject like '(自动发起)%' and bodyType = '20' and state in (0,1,3) and createDate >= '2014-05-30 00:00:00'";
        List<ColSummary> list = DBAgent.find(sql);
        Map<Long, List<ColSummary>> map = new HashMap<Long, List<ColSummary>>();
        List<ColSummary> temp;
        LOGGER.info("按照查询条件得到的协同列表数：" + list.size());
        LOGGER.info("分组协同类别，按照表单ID start");
        for (ColSummary summary : list) {
            temp = map.get(summary.getFormAppid());
            if (temp == null) {
                temp = new ArrayList<ColSummary>();
            }
            temp.add(summary);
            map.put(summary.getFormAppid(), temp);
        }
        LOGGER.info("分组协同类别，按照表单ID end");
        FormBean tempBean;
        //表名：状态值：list<数据id>
        Map<String, Map<Integer, List<Long>>> dataMap = new HashMap<String, Map<Integer, List<Long>>>();
        Map<Integer, List<Long>> stateMap;
        List<Long> dataIds;
        LOGGER.info("分组表单动态表名，按照协同状态获取对应表单状态，组装数据id列表，start");
        for (Entry<Long, List<ColSummary>> et : map.entrySet()) {
            tempBean = this.formCacheManager.getForm(et.getKey());
            if (tempBean == null) {
                continue;
            }

            String tableName = tempBean.getMasterTableBean().getTableName();
            stateMap = dataMap.get(tableName);
            if (stateMap == null) {
                stateMap = new HashMap<Integer, List<Long>>();
            }

            temp = et.getValue();
            int state = 0;
            for (ColSummary summary : temp) {
                CtpAffair affair = this.affairManager.getSenderAffair(summary.getId());
                if (affair == null) {
                    continue;
                }
                if (affair.getState() == 2 && (affair.isFinish() == null || !affair.isFinish())) {

                    if (summary.isAudited() != null && summary.isAudited()) {
                        state = FormDataStateEnum.FLOW_AUDITEDPASS.getKey();
                    } else {
                        state = FormDataStateEnum.FLOW_UNAUDITED.getKey();
                    }
                    dataIds = stateMap.get(state);
                    if (dataIds == null) {
                        dataIds = new ArrayList<Long>();
                    }

                    dataIds.add(summary.getFormRecordid());
                    stateMap.put(state, dataIds);
                }
            }
            dataMap.put(tableName, stateMap);
        }
        LOGGER.info("分组表单动态表名，按照协同状态获取对应表单状态，组装数据id列表，end");

        LOGGER.info("更新数据状态，start");
        JDBCAgent jdbc = null;
        boolean result = true;
        for (Entry<String, Map<Integer, List<Long>>> et : dataMap.entrySet()) {
            String tableName = et.getKey();
            stateMap = et.getValue();
            for (Entry<Integer, List<Long>> et1 : stateMap.entrySet()) {
                if (Strings.isEmpty(et1.getValue())) {
                    continue;
                }
                String value = et1.getValue().toString();
                String sql1 = "update " + tableName + " set state = " + et1.getKey() + " where id in (" + value.substring(1, value.length() - 1) + ") and state = 0";
                LOGGER.info(sql1);
                try {
                    jdbc = new JDBCAgent();
                    LOGGER.info("更新数据条数：" + jdbc.execute(sql1));
                } catch (Exception e) {
                    result = false;
                    LOGGER.error("更新数据状态异常", e);
                } finally {
                    if (jdbc != null) {
                        jdbc.close();
                    }
                }
            }
        }
        LOGGER.info("更新数据状态，end");
        return result;
    }

    public void setFormBindDesignManager(FormBindDesignManager formBindDesignManager) {
        this.formBindDesignManager = formBindDesignManager;
    }

    class IdAndIdx {
        Long id;
        int idx;

        IdAndIdx(long id, int idx) {
            this.id = id;
            this.idx = idx;
        }

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public int getIdx() {
            return idx;
        }

        public void setIdx(int idx) {
            this.idx = idx;
        }

    }

    /**
     * @return the formRelationRecordDAO
     */
    public FormRelationRecordDAO getFormRelationRecordDAO() {
        return formRelationRecordDAO;
    }

    /**
     * @param formRelationRecordDAO the formRelationRecordDAO to set
     */
    public void setFormRelationRecordDAO(FormRelationRecordDAO formRelationRecordDAO) {
        this.formRelationRecordDAO = formRelationRecordDAO;
    }

    @Override
    public Map<String, Object> fixDefaultValue4HiddenRefresh(String rightId, List<String> masterDataIds, String formTemplateId, Long formId) throws BusinessException {
        return fixDefaultValue4HiddenRefresh(rightId, masterDataIds, formTemplateId, formId, false);
    }

    @Override
    @AjaxAccess
    public Map<String, Object> fixDefaultValue4HiddenRefresh(String rightId, List<String> moduleIds, String formTemplateId, Long formId, boolean fromPortalet) throws BusinessException {
        if (Strings.isEmpty(moduleIds) || formId == null || Strings.isBlank(rightId)) {
            LOGGER.error("批量刷新，参数异常！");
            throw new BusinessException("批量刷新，参数异常！");
        }

        //刷新成功的数量
        int sucSize = 0;
        StringBuilder logs = new StringBuilder();
        //刷新失败的集合(key:数据ID，value:错误原因)
        Map<String, String> errorMap = new HashMap<String, String>();
        //数据对象集合(key:数据ID，value:数据对象)
        Map<String, FormDataMasterBean> dataMap = new HashMap<String, FormDataMasterBean>();

        FormBean form = formCacheManager.getForm(formId);
        /*****信息管理修改的时候需要合并新建和修改的单元格权限************/
        String rightStr = rightId;
        if (rightId != null && rightId.indexOf(",") != -1) {
            String[] rightStrs = rightId.split(",");
            rightStr = rightStrs[1];
        }
        FormAuthViewBean formAuthViewBean = form.getAuthViewBeanById(Long.parseLong(rightStr));
        int mt = FormType.getEnumByKey(form.getFormType()).getModuleType().getKey();
        for (String moduleId : moduleIds) {
            Long masterDataId = Long.parseLong(moduleId);
            try {
                if (!preUpdate(errorMap, moduleId, form, mt, dataMap)) {
                    continue;
                }
                FormDataMasterBean formDataBean = dataMap.get(moduleId);

                formDataBean.initData(formAuthViewBean, false);

                //--------------------刷新初始值-------------------------
                formManager.procDefaultValue(formDataBean, formAuthViewBean, true);
                formDataBean.putExtraAttr(FormConstant.moduleId,formDataBean.getId());
                if (afterUpdate(form, formDataBean, errorMap, mt, false, logs, formAuthViewBean)) {
                    sucSize++;
//                    String logs = formLogManager.getLogs(formDataBean, MainbodyStatus.STATUS_POST_UPDATE, form);
//                    formLogManager.saveOrUpdateLog(form.getId(), form.getFormType(), formDataBean.getId(), formDataBean.getId(), AppContext.currentUserId(), Enums.FormLogOperateType.MODIFY.getKey(), logs.toString(), formDataBean.getStartMemberId(), formDataBean.getStartDate());
                }
            } catch (Exception e) {
                //"修改失败,内部出现异常："
                errorMap.put(moduleId, ResourceUtil.getString("form.data.edit.failure.causes.label"));
                LOGGER.error(e.getMessage(), e);
            } finally {
                //---------------------------解锁-------------------------------------
                //判断是否由数据加锁导致的刷新失败，如果是因为数据加锁导致刷新失败，则不释放锁，由加锁方主动释放锁
                String errorMsg = errorMap.get(moduleId);
                if (Strings.isNotBlank(errorMsg) && errorMsg.startsWith(LOCKDATAERROR)) {
                    errorMap.put(moduleId, Strings.toHTML(errorMsg.replaceFirst(LOCKDATAERROR, "")));
                } else {
                    formManager.unlockFormData(masterDataId);
                }
            }
        }

        //------------------------记录日志-------------------------
        if (Strings.isBlank(logs.toString())) {
            logs.append(ResourceUtil.getString("form.bind.bath.update.suc.label", sucSize));
            try {
                formLogManager.saveOrUpdateLog(form.getId(), form.getFormType(), null, AppContext.currentUserId(), FormLogOperateType.BATCHUPDATE.getKey(), logs.toString(), AppContext.currentUserId(), DateUtil.currentTimestamp());
            } catch (SQLException e) {
                LOGGER.error(e.getMessage(), e);
                throw new BusinessException(e);
            }
        }
        //返回的数据
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("sucSize", sucSize);
        if (fromPortalet) {
            resultMap.put("msg", errorMap.get(moduleIds.get(0)));
        } else {
            //构建返回的信息
            resultMap.put("errorSize", errorMap.size());
            resultMap.put("detailData", getErrorDetail(errorMap, dataMap, form, formTemplateId));
        }
        return resultMap;
    }


    @Override
    @AjaxAccess
    public String saveBatchRefresh(List<String> moduleIds, String formId, String moduleType, String formTemplateId)
            throws BusinessException {
        if (Strings.isEmpty(moduleIds) || Strings.isBlank(formId) || Strings.isBlank(moduleType)) {
            LOGGER.error("批量刷新，参数异常！");
            throw new BusinessException("批量刷新，参数异常！");
        }
        //返回的数据
        Map<String, Object> resultMap = new HashMap<String, Object>();
        //刷新成功的数量
        int sucSize = 0;
        //刷新失败的集合(key:数据ID，value:错误原因)
        Map<String, String> errorMap = new HashMap<String, String>();
        //数据对象集合(key:数据ID，value:数据对象)
        Map<String, FormDataMasterBean> dataMap = new HashMap<String, FormDataMasterBean>();
        //-----------------加载表单数据----------------------
        FormBean form = formCacheManager.getForm(Long.parseLong(formId));
        int mt = Integer.parseInt(moduleType);
        for (String moduleId : moduleIds) {
            Long masterDataId = Long.parseLong(moduleId);
            try {
                if (!preUpdate(errorMap, moduleId, form, mt, dataMap)) {
                    continue;
                }
                FormDataMasterBean formDataBean = dataMap.get(moduleId);
                formDataBean.putExtraAttr("needProduceValue", "true");
                formDataBean.putExtraAttr(FormConstant.moduleId,formDataBean.getId());

                if (afterUpdate(form, formDataBean, errorMap, mt, true, null)) {
                    sucSize++;
                }
            } catch (SQLException e) {
                //"修改失败,内部出现异常："
                errorMap.put(moduleId, ResourceUtil.getString("form.data.edit.failure.causes.label"));
                LOGGER.error(e.getMessage(), e);
            } finally {
                //---------------------------解锁-------------------------------------
                //判断是否由数据加锁导致的刷新失败，如果是因为数据加锁导致刷新失败，则不释放锁，由加锁方主动释放锁
                String errorMsg = errorMap.get(moduleId);
                if (Strings.isNotBlank(errorMsg) && errorMsg.startsWith(LOCKDATAERROR)) {
                    errorMap.put(moduleId, Strings.toHTML(errorMsg.replaceFirst(LOCKDATAERROR, "")));
                } else {
                    formManager.unlockFormData(masterDataId);
                }
            }
        }
        //------------------------记录日志-------------------------
        StringBuilder logs = new StringBuilder();
        logs.append(ResourceUtil.getString("form.log.batchRefresh.suc.label", sucSize, errorMap.size()));
        try {
            formLogManager.saveOrUpdateLog(form.getId(), form.getFormType(), null, AppContext.currentUserId(), FormLogOperateType.BATCHREFRESH.getKey(), logs.toString(), AppContext.currentUserId(), DateUtil.currentTimestamp());
        } catch (SQLException e) {
            LOGGER.error(e.getMessage(), e);
            throw new BusinessException(e);
        }
        //构建返回的信息
        resultMap.put("sucSize", sucSize);
        resultMap.put("errorSize", errorMap.size());
        resultMap.put("detailData", getErrorDetail(errorMap, dataMap, form, formTemplateId));
        return JSONUtil.toJSONString(resultMap);
    }

    /**
     * 获得刷新失败详情页面需要的数据
     *
     * @param errorMap
     * @param form
     * @return
     */
    private List getErrorDetail(Map<String, String> errorMap, Map<String, FormDataMasterBean> dataMap, FormBean form, String formTemplateId) {
        List<List> result = new ArrayList<List>();
        if (errorMap == null || form == null || dataMap == null) {
            return result;
        }
        //处理数据唯一，
        result = this.getUniqueData(form, dataMap, errorMap);
        //处理唯一标识
        //是否处理处理唯一标识标志位，如果设置了数据唯一，但是数据唯一的值都是null时，则根据唯一标识来处理
        if (result.isEmpty()) {
            result = this.getUnique(form, dataMap, errorMap);
        }
        if (!Strings.isEmpty(result)) {
            return result;
        }

        //如果没有数据唯一或者唯一标识位时，则显示无流程列表显示项的前4个数据项
        result = this.get4FieldData(form, dataMap, formTemplateId, errorMap);
        return result;
    }

    /**
     * 获得数据唯一的数据集合，如果设置的数据唯一字段都是空值时，则以唯一标识位做判断，返回空的集合
     *
     * @param form     表单对象
     * @param dataMap  数据集合
     * @param errorMap 错误的信息
     * @return
     */
    private List<List> getUniqueData(FormBean form, Map<String, FormDataMasterBean> dataMap, Map<String, String> errorMap) {
        List<List> result = new ArrayList<List>();
        //显示列名称
        List<String> headList = new ArrayList<String>();

        //OA-114006 设置了唯一标示组合的无流程表单批量修改，不满足唯一标示组合时，查看失败详情中显示源代码。
        List<FormFieldBean> uniqueFieldList = new ArrayList<FormFieldBean>();
        for (Entry<String, String> en : errorMap.entrySet()) {
            String errorMsg = en.getValue();
            String[] array = errorMsg.split("@@@@");
            if (array.length > 1) {
                en.setValue(array[0]);
                String uniqueMark = array[1];
                if (!StringUtil.checkNull(uniqueMark)) {
                    String[] uniques = uniqueMark.split("[|]");
                    for (String str : uniques) {
                        FormFieldBean field = form.getFieldBeanByName(str);
                        //显示名称
                        if(!headList.contains(field.getDisplay())){
                            headList.add(field.getDisplay());
                            //字段
                            uniqueFieldList.add(field);
                        }
                    }
                }
            }
        }
        if (headList.isEmpty()) {
            //判断是否设置了数据唯一
            List<FormFieldBean> fieldBeanList = form.getAllFieldBeans();
            for (FormFieldBean ffb : fieldBeanList) {
                if (ffb.isUnique()) {
                    //显示名称
                    headList.add(ffb.getDisplay());
                    uniqueFieldList.add(ffb);
                }
            }
        }

        boolean isRight = false;
        if (!uniqueFieldList.isEmpty()) {
            //添加失败原因的列
            //"失败原因"
            headList.add(ResourceUtil.getString("form.data.refresh.failure.causes.label"));
            result.add(headList);
            for (FormDataMasterBean masterBean : dataMap.values()) {
                //显示数据值列表
                List<Object> valueList = new ArrayList<Object>();
                for (FormFieldBean ffb : uniqueFieldList) {
                    //获得实际的显示值
                    String val = this.getDisplayVal(ffb.getName(), masterBean, form);
                    //获得实际的显示值
                    valueList.add(val);
                    if (Strings.isNotBlank(val)) {
                        isRight = true;
                    }
                }

                //添加失败原因
                String errorMsg = errorMap.get(masterBean.getId().toString());
                if (Strings.isNotBlank(errorMsg)) {
                    valueList.add(errorMsg);
                    result.add(valueList);
                }
            }
        }
        //如果数据唯一的值都是空值时，则返回空的集合
        if (!isRight) {
            result.clear();
        }
        return result;
    }

    /**
     * 处理唯一标识
     *
     * @param form
     * @param dataMap
     * @return
     */
    private List<List> getUnique(FormBean form, Map<String, FormDataMasterBean> dataMap, Map<String, String> errorMap) {
        List<List> result = new ArrayList<List>();
        //显示列名称
        List<String> headList = new ArrayList<String>();
        //设置了数据标识的字段
        List<FormFieldBean> uniqueFieldList = new ArrayList<FormFieldBean>();

        //OA-84174 cxj001账号--唯一标识设置了6组，批量修改，批量刷新时使得第3组不满足唯一标识，但是详情提示仍然显示的第一组唯一标识
        for (Entry<String, String> en : errorMap.entrySet()) {
            String errorMsg = en.getValue();
            String[] array = errorMsg.split("@@@@");
            if (array.length > 1) {
                en.setValue(array[0]);
                String uniqueMark = array[1];
                if (!StringUtil.checkNull(uniqueMark)) {
                    String[] uniques = uniqueMark.split("[|]");
                    for (String str : uniques) {
                        FormFieldBean field = form.getFieldBeanByName(str);
                        //显示名称
                        if(!headList.contains(field.getDisplay())){
                            headList.add(field.getDisplay());
                            //字段
                            uniqueFieldList.add(field);
                        }
                    }
                }
            }
        }

        if (headList.isEmpty()) {
            List<List<String>> uniqueField = form.getUniqueFieldList();
            //如果设置了多个唯一标识，则取其中一个
            for (List<String> list : uniqueField) {
                for (int i = 0; i < list.size(); i++) {
                    String fieldName = list.get(i);
                    FormFieldBean field = form.getFieldBeanByName(fieldName);
                    //显示名称
                    headList.add(field.getDisplay());
                    //字段
                    uniqueFieldList.add(field);
                }
                break;
            }
        }
        //"失败原因"
        headList.add(ResourceUtil.getString("form.data.refresh.failure.causes.label"));
        result.add(headList);
        boolean isRight = false;
        if (!uniqueFieldList.isEmpty()) {
            for (FormDataMasterBean masterBean : dataMap.values()) {
                //显示数据值列表
                List<Object> valueList = new ArrayList<Object>();
                for (FormFieldBean field : uniqueFieldList) {
                    //获得实际的显示值
                    String val = this.getDisplayVal(field.getName(), masterBean, form);
                    //获得实际的显示值
                    valueList.add(val);
                    if (Strings.isNotBlank(val)) {
                        val = Strings.toHTML(val);
                        isRight = true;
                    }
                }
                //添加失败原因
                //添加失败原因
                String errorMsg = errorMap.get(masterBean.getId().toString());
                if (Strings.isNotBlank(errorMsg)) {
                    valueList.add(errorMsg);
                    result.add(valueList);
                }
            }
        }
        //如果唯一标识的值都是空值时，则返回空的集合
        if (!isRight) {
            result.clear();
        }
        return result;
    }

    /**
     * 获得无流程列表显示项的前4个数据项数据
     *
     * @param form
     * @param dataMap
     * @return
     */
    private List<List> get4FieldData(FormBean form, Map<String, FormDataMasterBean> dataMap, String formTemplateId, Map<String, String> errorMap) {
        List<List> result = new ArrayList<List>();
        //显示列名称
        List<String> headList = new ArrayList<String>();
        //字段名称 field0001
        List<String> fieldList = new ArrayList<String>();
        FormBindBean bindBean = form.getBind();
        Map<String, FormBindAuthBean> bindAuthMap = bindBean.getUnFlowTemplateMap();
        FormBindAuthBean bindAuthBean = bindAuthMap.get(formTemplateId);
        List<SimpleObjectBean> sobList = bindAuthBean.getShowFieldList();
        if (!Strings.isEmpty(sobList)) {
            for (int i = 0; i < sobList.size(); i++) {
                if (i == 4) {
                    break;
                }
                SimpleObjectBean soBean = sobList.get(i);
                //显示名称
                headList.add(soBean.getValue());
                //字段field0001
                if (Strings.isNotBlank(soBean.getName())) {
                    MasterTableField masterTableField = MasterTableField.getEnumByKey(soBean.getName());
                    if (masterTableField != null) {
                        fieldList.add(soBean.getName());
                    } else {
                        fieldList.add(soBean.getName().split("[.]")[1]);
                    }
                }
            }
            //"失败原因"
            headList.add(ResourceUtil.getString("form.data.refresh.failure.causes.label"));
            result.add(headList);
            if (!fieldList.isEmpty()) {
                for (FormDataMasterBean masterBean : dataMap.values()) {
                    //显示数据值列表
                    List<Object> valueList = new ArrayList<Object>();
                    for (String uniqueName : fieldList) {
                        //获得实际的显示值
                        valueList.add(Strings.toHTML(Strings.toHTML(this.getDisplayVal(uniqueName, masterBean, form))));
                    }
                    //添加失败原因
                    String errorMsg = errorMap.remove(masterBean.getId().toString());
                    if (Strings.isNotBlank(errorMsg)) {
                        valueList.add(errorMsg);
                        result.add(valueList);
                    }
                }
                if (!errorMap.isEmpty()) {
                    for (Entry<String, String> entry : errorMap.entrySet()) {
                        List<Object> valueList = new ArrayList<Object>();
                        if ("delete".equals(entry.getValue())) {
                            valueList.add("id = " + entry.getKey() + ResourceUtil.getString("form.data.delete.label"));
                            result.add(valueList);
                        }
                    }
                }
            }
        }
        return result;
    }

    /**
     * 批量刷新，返回错误详情列表时，对特殊数据进行加工显示(比如组织模型数据)
     *
     * @param fieldName
     * @param fieldVal
     * @param form
     * @return
     */
    private String getDisplayVal(String fieldName, FormDataMasterBean masterBean, FormBean form) {
        String display = "";
        try {
            FormFieldBean field = form.getFieldBeanByName(fieldName);
            if (field == null) {
                MasterTableField masterTableField = MasterTableField.getEnumByKey(fieldName);
                field = masterTableField.getFormFieldBean();
            }
            FormFieldBean realFfb = field.findRealFieldBean();
            Object fieldVal = masterBean.getFieldValue(fieldName);
            Object[] displayVal = realFfb.getDisplayValue(fieldVal);
            if (displayVal != null && displayVal.length > 1) {
                display = (String) displayVal[1];
            }
        } catch (BusinessException e) {
            LOGGER.error(e.getMessage(), e);
        }
        //获得实际的显示值
        return display;
    }

    /**
     * 校验无流程单据是否能够是刷新
     *
     * @param moduleId
     * @param formId
     * @param moduleType
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    private String checkData4Refresh(String moduleId, FormBean formBean, int moduleType, Map<String, FormDataMasterBean> dataBeanMap) throws BusinessException, SQLException {
        String returnStr = "1";
        //校验数据是否存在
        boolean isDelete = formManager.checkDelete(formBean.getId(), moduleId);
        if (!isDelete) {
            //"该记录已经被删除!"
//    		return ResourceUtil.getString("form.data.delete.label");
            return "delete";
        }
        getMasterDataBean(formBean, Long.parseLong(moduleId), dataBeanMap);
        //检查数据是否处于锁定状态
        String lock = formManager.checkDataLockForEdit(moduleId);
        if (Strings.isNotBlank(lock)) {
            //如果是数据加锁导致的原因，加上前缀，在批量刷新、修改调用处释放锁时不释放
            return LOCKDATAERROR + lock;
        }
        //校验信息管理数据是否锁定(列表页面的锁定功能)
        if (ModuleType.unflowInfo.getKey() == moduleType) {
            boolean isLock = formManager.checkLock(formBean.getId(), moduleId);
            if (isLock) {
                //"已锁定的数据不可修改"
                formManager.removeSessionMasterDataBean(Long.parseLong(moduleId));
                return ResourceUtil.getString("form.data.lock.no.edit.label");
            }
        }
        return returnStr;
    }
    /**
     * 表单校验前台设置的校验规则。如果校验不通过，则抛出异常到前台。
     *
     * @param formId
     * @param cacheMasterData
     * @throws BusinessException
     */
    /**
     * 表单校验前台设置的校验规则。如果校验不通过，则抛出异常到前台。
     *
     * @param formId
     * @param cacheMasterData
     * @throws BusinessException
     */
    private String validate(Long formId, FormDataMasterBean cacheMasterData) throws BusinessException {
        String returnStr = "1";
        FormBean fb = this.formCacheManager.getForm(formId);
        List<FormConditionActionBean> checkRules = formCacheManager.getFormCheckRule(formId);
        //如果该表单有校验规则，才进行校验
        Map<String, Object> conditionMap = cacheMasterData.getFormulaMap(FormulaEnums.componentType_condition);
        Map<String, Object> formulaMap = fb.getCheckRuleFormula(conditionMap);
        int forceCheck = Integer.valueOf(formulaMap.get("forceCheck").toString());
        FormFormulaBean formula = (FormFormulaBean)formulaMap.get("checkRule");
        if (forceCheck != 2 && Strings.isNotEmpty(checkRules)) {
            String formulaStr = formula.getExecuteFormulaForGroove();
            try {
                if (!Strings.isBlank(formulaStr)) {
                    String exceptionMessage = ResourceUtil.getString("form.baseinfo.checkRule.exception");
                    if (Strings.isBlank(exceptionMessage)) {
                        exceptionMessage = "form.baseinfo.checkRule.formula.error";
                    }

                    List<String> conditions = FormulaValidate.parseToSimpleConditions(formula.getFormulaForDisplay());
                    StringBuilder msgRule = new StringBuilder();
                    for (String condition : conditions) {
                        FormFormulaBean formulaBean = new FormFormulaBean(fb);
                        formulaBean.loadFromFormula(condition);
                        formulaStr = formulaBean.getExecuteFormulaForGroove();
                        boolean value = FormulaUtil.isMatch(formulaStr, conditionMap);
                        if (!value) {
                            msgRule.append(FormulaValidate.getValidateErrorMSG4CheckRule(condition, fb));
                        }
                    }
                    if (msgRule.length() > 0) {
                        String desc = fb.getCheckRuleDesc();
                        if(StringUtil.checkNull(desc)){
                            desc = formula.getFormulaDescription();
                        }
                        //将计算公式中的双引号去掉，不然批量刷新的时候失败点击详情会有问题
                        String formulaStrDesc = formula.getFormulaForDisplay().replaceAll("\"", "&quot;");
                        returnStr = exceptionMessage + msgRule.toString() + ". " + ResourceUtil.getString("form.forminputchoose.reaseme") + (StringUtil.checkNull(desc) ? Strings.toHTML(formulaStrDesc): Strings.toHTML(desc));
                    }
                }
            } catch (Exception e) {
                String exceptionMessage = ResourceUtil.getString("form.baseinfo.checkRule.exception");
                if (Strings.isBlank(exceptionMessage)) {
                    exceptionMessage = "form.baseinfo.checkRule.formula.error";
                }
                returnStr = exceptionMessage + "<br>(" + formula.getFormulaForDisplay() + ")";
            }
        }
        return returnStr;
    }

    /**
     * 校验数据唯一和唯一标识，<br>
     * 当设置了多个数据唯一时，其中一个数据唯一字段不满足，则返回<br>
     * 批量修改或者批量刷新时调用
     *
     * @param fb 需要校验的表单
     * @param cacheMasterData 需要校验的数据对象
     * @return String
     * @throws BusinessException
     */
    private String validateDataUnique(FormBean fb, FormDataMasterBean cacheMasterData) throws BusinessException {
        String returnStr = "1";
        try {
            List<FormFieldBean> fieldBeanList = fb == null ? null : fb.getAllFieldBeans();
            boolean isExist = false;
            String fieldName = "";
            FormDataMasterBean cloneDataBean = (FormDataMasterBean) cacheMasterData.getExtraAttr("cloneDataBean");
            if (null != fieldBeanList) {
        		/*------------------------------------------判断数据唯一-----------------------*/
                //判断数据唯一
                for (FormFieldBean ffb : fieldBeanList) {
                    //固定字段先排除
                    if (ffb.isConstantField()) continue;
                    //如果该字段设置了数据唯一，那么就需要判断该字段的数据是否有重复。
                    if (ffb.isUnique()) {
                        List<FormDataBean> dataList = new ArrayList<FormDataBean>();
                        List<FormDataBean> oldDataList = new ArrayList<FormDataBean>();
                        if (ffb.isMasterField()) {
                            dataList.add(cacheMasterData);
                        } else {
                            dataList.addAll(cacheMasterData.getSubData(ffb.getOwnerTableName()));
                            if (cloneDataBean != null) {
                                oldDataList.addAll(cloneDataBean.getSubData(ffb.getOwnerTableName()));
                            }
                        }
                        isExist = isFieldUnique(ffb, ffb.getOwnerTableName(), dataList, oldDataList);
                        if (isExist) {
                            fieldName = ffb.getDisplay();
                            break;
                        }
                    }
                }
        		/*------------------------------------------判断唯一标识-----------------------*/
                if (!isExist && Strings.isNotEmpty(fb.getUniqueFieldList())) {
                    for (List<String> list : fb.getUniqueFieldList()) {
                        if (isUniqueMarked(fb, cacheMasterData, list)) {
                            //【{0}】设置了唯一标识，数据不满足唯一标识组合！请重新输入！
                            // 需要定位到具体不符合的唯一标识上
                            StringBuffer sb = new StringBuffer();
                            String uniqueMark = "";
                            for (String str : list) {
                                sb.append(str).append("|");
                            }
                            if (!StringUtil.checkNull(sb.toString())) {
                                uniqueMark = sb.toString().substring(0, sb.toString().length() - 1);
                            }
                            returnStr = ResourceUtil.getString("form.data.validate.unique", fb.getFormName());
                            if (!StringUtil.checkNull(uniqueMark)) {
                                returnStr = returnStr + "@@@@" + uniqueMark;
                            }
                            break;
                        }
                    }
                }
            }
            if (isExist) {
                returnStr = ResourceUtil.getString("form.data.validate.uniqueFlag", fieldName);
            }
        } catch (Exception e) {
            returnStr = ResourceUtil.getString("form.data.validate.uniqueFlag.exception");
        }
        return returnStr;
    }

    @Override
    public List<Map<String, String>> getBatchUpdateHTML(Long formId, Long templateId) throws BusinessException {

        FormBean fb = formCacheManager.getForm(formId);
        List<FormFieldBean> fieldBeans = getBathUpdateFieldBeans(fb, templateId);

        List<Map<String, String>> result = new ArrayList<Map<String, String>>();
        if (Strings.isNotEmpty(fieldBeans)) {
            for (FormFieldBean fieldBean : fieldBeans) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("fieldName", fieldBean.getName());
                map.put("showName", fieldBean.getDisplay());
                map.put("html", formManager.getFieldHTML(fb, fieldBean, null));
                result.add(map);
            }
        }
        return result;
    }

    /**
     * 对要更新的数据做预判断，判断通过并对数据加锁
     *
     * @param errorMap   错误信息记录map
     * @param moduleId   对应的数据id
     * @param formId     表单id
     * @param moduleType 类型
     * @return 校验通过true，不通过false
     * @throws BusinessException
     * @throws SQLException
     */
    private boolean preUpdate(Map<String, String> errorMap, String moduleId, FormBean formBean, int moduleType, Map<String, FormDataMasterBean> dataBeanMap) throws BusinessException, SQLException {

        //校验数据是否合法
        String result = checkData4Refresh(moduleId, formBean, moduleType, dataBeanMap);
        //返回结果不等于1，说明校验不合法
        if (!"1".equals(result)) {
            errorMap.put(moduleId, Strings.toHTML(result));
            return false;
        }
        //----------------加锁--------------------
        Long masterDataId = Long.parseLong(moduleId);
        if (formManager.getLock(masterDataId) == null) {
            formManager.lockFormData(masterDataId);
        }
        return true;
    }

    /**
     * 获取需要刷新的数据bean对象，并放入缓存和数据map中
     *
     * @param formBean 表单对象
     * @param dataId   数据id
     * @param dataMap  数据map
     * @return
     * @throws SQLException
     * @throws BusinessException
     */
    private FormDataMasterBean getMasterDataBean(FormBean formBean, Long dataId, Map<String, FormDataMasterBean> dataMap) throws SQLException, BusinessException {
        FormDataMasterBean formDataBean = formDataDAO.selectDataByMasterId(dataId, formBean, null);
        dataMap.put(dataId.toString(), formDataBean);
        //可编辑的情况下，才产生数据缓存
        formManager.putSessioMasterDataBean(formBean, formDataBean, true, false);
        return formDataBean;
    }

    /**
     * 批量刷新/更新后的数据处理方法 校验各种规则，保存数据，执行触发，移除缓存
     *
     * @param formBean   表单对象
     * @param dataBean   数据对象
     * @param errorMap   异常map
     * @param moduleType 类型
     * @param isRefresh  是否是批量刷新
     * @return 所有通过true，否则false
     * @throws BusinessException
     * @throws SQLException
     */
    private boolean afterUpdate(FormBean formBean, FormDataMasterBean dataBean, Map<String, String> errorMap, int moduleType, boolean isRefresh, StringBuilder logSB) throws BusinessException, SQLException {
        return afterUpdate(formBean, dataBean, errorMap, moduleType, isRefresh, logSB, null);
    }

    private boolean afterUpdate(FormBean formBean, FormDataMasterBean dataBean, Map<String, String> errorMap, int moduleType, boolean isRefresh, StringBuilder logSB, FormAuthViewBean viewBean) throws BusinessException, SQLException {

        dataBean.setModifyDate(DateUtil.currentTimestamp());
        //---------------------刷新所有计算--------------------------
//        formManager.calcAll(formBean, dataBean, null, false, true, true);
        //将流水号计算记录值放入dataMasterBean的缓存当中
        List<FormSerialCalculateRecord> serialRecordList = serialCalRecordManager.selectAllByFormData(formBean.getId(), dataBean.getId());
        dataBean.putExtraAttr(FormConstant.serialCalRecords, serialRecordList);
        formManager.refreshFormData(formBean.getId(), dataBean, null, true, true, true);

        formRelationManager.dealAllOrgFieldRelation(formBean, dataBean, null, true, true);
        //-----------------------校验数据：校验规则、数据唯一、唯一标示-----------------
        String validateError = validate(formBean.getId(), dataBean);
        String moduleId = dataBean.getId().toString();
        if (!"1".equals(validateError)) {
            errorMap.put(moduleId, Strings.toHTML(validateError));
            //-------------------------移除缓存-----------------------------------
            formManager.removeSessionMasterDataBean(dataBean.getId());
            return false;
        }
        if (formBean.hasDataUniqueField()) {
            String uniqueError = validateDataUnique(formBean, dataBean);
            if (!"1".equals(uniqueError)) {
                errorMap.put(moduleId, Strings.toHTML(uniqueError));
                //-------------------------移除缓存-----------------------------------
                formManager.removeSessionMasterDataBean(dataBean.getId());
                return false;
            }
        }
        if (!isRefresh) {
            String log = formLogManager.getLogs(dataBean, MainbodyStatus.STATUS_POST_UPDATE, formBean);
            if (Strings.isNotBlank(log)) {
                if (logSB != null) {
                    logSB.append(log);
                }
                formLogManager.saveOrUpdateLog(formBean.getId(), formBean.getFormType(), dataBean.getId(), AppContext.currentUserId(), FormLogOperateType.BATCHUPDATE.getKey(), log, AppContext.currentUserId(), DateUtil.currentTimestamp());
            }
        }
        //---------------------------从新生成二维码图片，只针对已生成二维码的字段，如果还没有生成二维码的字段，这里不处理，保持原样。------------------------
        CtpContentAllBean contentAll = new CtpContentAllBean();
        contentAll.setModuleId(dataBean.getId());
        contentAll.setContentType(MainbodyType.FORM.getKey());
        contentAll.setViewState(CtpContentAllBean.viewState_readOnly);
        refreshAllBarCode(formBean, dataBean, contentAll);
        //------------------------保存数据-------------------------
        List<String> md = new ArrayList<String>();
        FormService.saveOrUpdateFormData(dataBean, formBean.getId(), true, md);
        //-------------------------执行触发、回写------------------------------
        String rightId = null;
        if (viewBean != null) {
            rightId = viewBean.getId().toString();
        }
        this.formTriggerManager.doTrigger(moduleType, dataBean.getId(), formBean.getId(), rightId, md, false);
        //-------------------------移除缓存-----------------------------------
        formManager.removeSessionMasterDataBean(dataBean.getId());
        return true;
    }

    private List<FormFieldBean> getBathUpdateFieldBeans(FormBean fb, Long templateId) throws BusinessException {
        List<FormFieldBean> fieldBeans = null;
        if (fb.getFormType() == FormType.baseInfo.getKey()) {
            fieldBeans = this.formBindDesignManager.getBathUpdateFields(fb);
        } else if (fb.getFormType() == FormType.manageInfo.getKey()
        		|| fb.getFormType() == FormType.dynamicForm.getKey()) {
            FormBindBean bindBean = fb.getBind();
            FormBindAuthBean bindAuthBean = bindBean.getFormBindAuthBean(String.valueOf(templateId));
            String auth = bindAuthBean.getAuthByName(AuthName.BATHUPDATE.getKey());
            if (Strings.isNotBlank(auth)) {
                List<FormFieldBean> authBeans = FormUtil.convertFieldName2BeanList(auth, ",", fb);
                fieldBeans = formBindDesignManager.getBathUpdateFields(fb, authBeans);
            }
        }
        return fieldBeans;
    }


    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#getProgressName4UpdateData4BatchUpdate(java.lang.String, java.lang.String)
     */
    public String getProgressName4UpdateData4BatchUpdate(String formId, String userId) {
        return "updateData4BatchUpdate_" + formId + "_" + userId;
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager#getProgress4UpdateData4BatchUpdate(java.lang.String, java.lang.String)
     */
    public String getProgress4UpdateData4BatchUpdate(String formId, String userId) {
        String progressBarName = getProgressName4UpdateData4BatchUpdate(formId, userId);//进度条名称
        CTPProgressBar progress = CTPProgressUtil.getProgressBar(progressBarName);
        if (progress != null) {
            return progress.getCurrent() + "/" + progress.getTotal();
        } else {
            return "";
        }
    }

    @Override
    public Map<String, Object> updateData4BatchUpdate(String formId, String templateId, List<String> dataIds, String updateType, Map<String, String> data) throws BusinessException, SQLException {

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("result", "true");
        if (Strings.isBlank(formId) || Strings.isBlank(templateId) || Strings.isEmpty(dataIds) || Strings.isBlank(updateType)) {
            LOGGER.info(AppContext.currentUserId() + " 批量修改数据异常，缺失必要参数！");
        }

        FormBean formBean = formCacheManager.getForm(Long.valueOf(formId));
        List<FormFieldBean> fieldBeans = getBathUpdateFieldBeans(formBean, Long.valueOf(templateId));

        Map<String, Map<String, Object>> dataMap = new HashMap<String, Map<String, Object>>();
        if (Strings.isNotEmpty(fieldBeans)) {
            for (Entry<String, String> entry : data.entrySet()) {
                FormFieldBean fieldBean = formBean.getFieldBeanByName(entry.getKey());
                if (fieldBean != null && fieldBeans.contains(fieldBean)) {
                    //值为空，且选择是保留原值，不对值做处理
                    if (Strings.isBlank(entry.getValue()) && "0".equals(updateType)) {
                        if (fieldBean.getInputTypeEnum() != FormFieldComEnum.CHECKBOX) {
                            continue;
                        }
                    }
                    Object o = fieldBean.getFrontSubmitData(entry.getValue());
                    Map<String, Object> temp = dataMap.get(fieldBean.getOwnerTableName());
                    if (temp == null) {
                        temp = new HashMap<String, Object>();
                    }
                    temp.put(fieldBean.getName(), o);
                    dataMap.put(fieldBean.getOwnerTableName(), temp);
                }
            }
        }

        List<FormFieldBean> relations = formBean.getFieldsByType(FormFieldComEnum.RELATION);
        Map<String, String> enumRelationMap = new HashMap<String, String>();
        for (FormFieldBean fieldBean : relations) {
            FormRelation fr = fieldBean.getFormRelation();
            if (fr != null && fr.isDataRelationMultiEnum()) {
                enumRelationMap.put(fr.getFromRelationAttr(), fr.getToRelationAttr());
            }
        }

        Map<String, String> errorMap = new HashMap<String, String>();
        Map<String, FormDataMasterBean> dataBeanMap = new HashMap<String, FormDataMasterBean>();
        int moduleType = FormType.getEnumByKey(formBean.getFormType()).getModuleType().getKey();
        //刷新成功的数量
        int sucSize = 0;
        StringBuilder logs = new StringBuilder();
        String progressBarName = getProgressName4UpdateData4BatchUpdate(formId, AppContext.currentUserId() + "");//进度条名称
        CTPProgressUtil.createNewProgressBar(progressBarName, dataIds.size(), "form_updateData4BatchUpdate", true);//创建进度条
        for (String dataId : dataIds) {
            CTPProgressUtil.addOne(progressBarName);//进度条计算
            Long masterDataId = Long.parseLong(dataId);
            try {
                if (!preUpdate(errorMap, dataId, formBean, moduleType, dataBeanMap)) {
                    continue;
                }
                FormDataMasterBean formDataBean = dataBeanMap.get(dataId);
                Map<String, Object> temp = dataMap.get(formBean.getMasterTableBean().getTableName());
                //更新主表数据
                if (temp != null) {
                    formDataBean.addFieldValue(temp);
                    handleRelationMultiEnum(enumRelationMap, formDataBean, formDataBean, formBean.getMasterTableBean(), formBean);
                }
                //更新重复表数据
                List<FormTableBean> subTables = formBean.getSubTableBean();
                for (FormTableBean tableBean : subTables) {
                    temp = dataMap.get(tableBean.getTableName());
                    List<FormDataSubBean> subBeans = formDataBean.getSubData(tableBean.getTableName());
                    if (Strings.isNotEmpty(subBeans)) {
                        for (FormDataSubBean subBean : subBeans) {
                            if (temp != null) {
                                subBean.addFieldValue(temp);
                            }
                            handleRelationMultiEnum(enumRelationMap, subBean, formDataBean, tableBean, formBean);
                        }
                    }
                }
                formDataBean.putExtraAttr("needProduceValue", "true");
                formDataBean.putExtraAttr(FormConstant.moduleId,formDataBean.getId());
                if (afterUpdate(formBean, formDataBean, errorMap, moduleType, false, logs)) {
                    sucSize++;
                }
            } catch (Exception e) {
                 //errorMap.put(dataId, ResourceUtil.getString("form.data.edit.failure.causes.label"));
                //OA-111113存在循环嵌套计算公式的表单，批量修改时，触发循环嵌套判断，修改失败，但是记录的失败原因描述不清。
                errorMap.put(dataId,null!=e.getCause().getMessage()?e.getCause().getMessage():e.getMessage());

                LOGGER.error(e.getMessage(), e);
            } finally {
                //---------------------------解锁-------------------------------------
                //判断是否由数据加锁导致的刷新失败，如果是因为数据加锁导致刷新失败，则不释放锁，由加锁方主动释放锁
                String errorMsg = errorMap.get(dataId);
                if (Strings.isNotBlank(errorMsg) && errorMsg.startsWith(LOCKDATAERROR)) {
                    errorMap.put(dataId, Strings.toHTML(errorMsg.replaceFirst(LOCKDATAERROR, "")));
                } else {
                    formManager.removeSessionMasterDataBean(masterDataId);
                }
            }
        }
        CTPProgressUtil.clearProgressBar(progressBarName);//关闭进度条
        //------------------------记录日志-------------------------
        if (Strings.isBlank(logs.toString())) {
            logs.append(ResourceUtil.getString("form.bind.bath.update.suc.label", sucSize));
            try {
                formLogManager.saveOrUpdateLog(formBean.getId(), formBean.getFormType(), null, AppContext.currentUserId(), FormLogOperateType.BATCHUPDATE.getKey(), logs.toString(), AppContext.currentUserId(), DateUtil.currentTimestamp());
            } catch (SQLException e) {
                LOGGER.error(e.getMessage(), e);
                throw new BusinessException(e);
            }
        }

        map.put("sucSize", sucSize);
        map.put("errorSize", errorMap.size());
        map.put("detailData", getErrorDetail(errorMap, dataBeanMap, formBean, templateId));
        return map;
    }

    private void handleRelationMultiEnum(Map<String, String> enumRelationMap, FormDataBean dataBean, FormDataMasterBean masterBean, FormTableBean tableBean, FormBean formBean) throws BusinessException {
        if (!enumRelationMap.isEmpty()) {
            for (Entry<String, String> entry : enumRelationMap.entrySet()) {
                FormFieldBean fieldBean = tableBean.getFormFieldBeanByFieldName(entry.getKey());
                if (fieldBean != null) {
                    List<CtpEnumItem> items = handleRelationMultiEnum4Field(fieldBean, enumRelationMap, dataBean, masterBean, tableBean, formBean);
                    if (Strings.isEmpty(items)) {
                        addFieldValue(fieldBean, dataBean, masterBean, null);
                    } else {
                        Long value = getFieldValue(fieldBean, dataBean, masterBean);
                        if (value != null) {
                            for (CtpEnumItem item : items) {
                                if (item.getId().equals(value)) {
                                    return;
                                }
                            }
                            addFieldValue(fieldBean, dataBean, masterBean, null);
                        }
                    }
                }
            }
        }
    }

    private List<CtpEnumItem> handleRelationMultiEnum4Field(FormFieldBean fieldBean, Map<String, String> enumRelationMap, FormDataBean dataBean, FormDataMasterBean masterBean, FormTableBean tableBean, FormBean formBean) throws BusinessException {
        if (FormFieldComEnum.SELECT == fieldBean.getInputTypeEnum()) {
            Long value = getFieldValue(fieldBean, dataBean, masterBean);
            if (value != null) {
                return enumManagerNew.getFirstLevelItemsByEmumId(fieldBean.getEnumId());
            }
            return Collections.EMPTY_LIST;
        } else {
            FormFieldBean rFieldBean = formBean.getFieldBeanByName(enumRelationMap.get(fieldBean.getName()));
            if (rFieldBean != null) {
                Long value = getFieldValue(rFieldBean, dataBean, masterBean);
                if (value == null) {
                    return Collections.EMPTY_LIST;
                }
                List<CtpEnumItem> items = handleRelationMultiEnum4Field(rFieldBean, enumRelationMap, dataBean, masterBean, tableBean, formBean);
                if (Strings.isEmpty(items)) {
                    addFieldValue(fieldBean, dataBean, masterBean, null);
                    return Collections.EMPTY_LIST;
                } else {
                    Map<String, Object> selectParams = new HashMap<String, Object>();
                    selectParams.put("enumId", fieldBean.getEnumId());
                    selectParams.put("enumLevel", fieldBean.getEnumLevel());
                    selectParams.put("parentId", value);
                    selectParams.put("bizModel", true);
                    for (CtpEnumItem item : items) {
                        if (item.getId().equals(value)) {
                            return enumManagerNew.getFormSelectEnumItemList(selectParams);
                        }
                    }
                    addFieldValue(fieldBean, dataBean, masterBean, null);
                }
            }
        }

        return Collections.EMPTY_LIST;
    }

    private void addFieldValue(FormFieldBean fieldBean, FormDataBean dataBean, FormDataMasterBean masterBean, Object value) {
        if (fieldBean.isMasterField()) {
            masterBean.addFieldValue(fieldBean.getName(), value);
        } else {
            dataBean.addFieldValue(fieldBean.getName(), value);
        }
    }

    private Long getFieldValue(FormFieldBean fieldBean, FormDataBean dataBean, FormDataMasterBean masterBean) {
        Object value;
        if (fieldBean.isMasterField()) {
            value = masterBean.getFieldValue(fieldBean.getName());
        } else {
            value = dataBean.getFieldValue(fieldBean.getName());
        }
        if (value == null) {
            return null;
        } else {
            return Long.valueOf(String.valueOf(value));
        }
    }

    @Override
    public List<FormFieldBean> getRepeatFormFieldForImport(FormBean form, FormAuthViewBean authViewBean, String tableName)
            throws BusinessException {
        List<FormFieldBean> expotFields = null;
        if (form != null && tableName != null) {
            List<String> comEnums = new ArrayList<String>();
            comEnums.add(FormFieldComEnum.HANDWRITE.getKey());
            comEnums.add(FormFieldComEnum.RELATIONFORM.getKey());
            comEnums.add(FormFieldComEnum.LABLE.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_ATTACHMENT.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_DOCUMENT.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_IMAGE.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_EXCHANGETASK.getKey());
            comEnums.add(FormFieldComEnum.EXTEND_QUERYTASK.getKey());
            comEnums.add(FormFieldComEnum.MAP_LOCATE.getKey());
            comEnums.add(FormFieldComEnum.MAP_MARKED.getKey());
            comEnums.add(FormFieldComEnum.MAP_PHOTO.getKey());
            comEnums.add(FormFieldComEnum.LINE_NUMBER.getKey());
            comEnums.add(FormFieldComEnum.CUSTOM_CONTROL.getKey());
            comEnums.add(FormFieldComEnum.CUSTOM_PLAN.getKey());
            comEnums.add(FormFieldComEnum.BARCODE.getKey());
            expotFields = this.formAuthDesignManager.getFormFieldBean4RepeatImport(form, authViewBean, tableName, comEnums);
        }
        return expotFields != null ? expotFields : new ArrayList<FormFieldBean>();
    }

    @Override
    public String dealExcelForImport(Map<String, Object> params, Map<String, Object> data)
            throws BusinessException {
        Long fileUrl = null;
        Long formId = null;
        Long rightId = null;
        String tableName = null;
        Long formMasterId = null;
        String error = "";//错误信息
        String sheetName = "";
        List<Map<String, Object>> res = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = null;
        int row = 0, col = 0;//记录行列数，数据出错时提示位置
        DataContainer dc = new DataContainer();
        //需要刷新关联的字段(关联人员，部门，地图，项目)
        Map<String, Object> needRefreshField = new HashMap<String, Object>();
        try {
            //获取参数
            fileUrl = Long.valueOf((String) params.get("fileUrl"));
            formId = Long.valueOf((String) params.get("formId"));
            rightId = Long.valueOf((String) params.get("rightId"));
            tableName = (String) params.get("tableName");
            formMasterId = Long.valueOf((String) params.get("formMasterId"));
            //获取导出模板包含的列
            FormBean formBean = formCacheManager.getForm(formId);
            FormAuthViewBean favb = formBean.getAuthViewBeanById(rightId);
            List<String> expotFields = new ArrayList<String>();
            /*List<FormFieldBean> expotFieldLists = this.getRepeatFormFieldForImport(formBean, favb, tableName);
            for (FormFieldBean bean : expotFieldLists) {
                expotFields.add(bean.getDisplay());
            }*/
            //获取导入的Exce中包含的列
            File file = fileManager.getFile(fileUrl);
            //List<List<String>> lists = fileToExcelManager.readExcel(file);
            List<Object> resultList = fileToExcelManager.readExcelAllContentBySheets(file, null, 0);
            if (resultList == null) {//单元格中有函数，导致读取单元格异常。
                error = ResourceUtil.getString("form.masterdatalist.inportexcelerror");
                throw new BusinessException("Excel模板格式不对");
            }
            sheetName = ((List<String>) resultList.get(0)).get(0);
            List<List<List<String>>> excelListBySheets = (List<List<List<String>>>) resultList.get(1);
            List<List<String>> lists = excelListBySheets.get(0);
            if (lists.size() < 2) {
                error = ResourceUtil.getString("form.masterdatalist.inportexcelerror");
                throw new BusinessException("Excel模板格式不对");
            }
            if(lists.size() == 2){
                error = ResourceUtil.getString("form.exportdata.null");
                throw new BusinessException(error);
            }
            List<String> list1 = lists.get(1);
            List<String> header = new ArrayList<String>();//Excel列头
            for (String str : list1) {
                if (!"".equals(str.trim())) {
                    header.add(str.trim());
                } else {
                    break;
                }
            }
            //Excel格式校验
            boolean isValid = false;
            /*if (expotFields.size() == header.size() && header.size() > 0) {
                isValid = expotFields.containsAll(header);
            }*/
            //有流程表单支持重复表导入模板设置
            if (header.size() > 0) {
                for (String field : header) {
                    FormFieldBean fb = formBean.getFieldBeanByDisplay(field);
                    if (fb != null) {
                        //判断下是否为当前重复表的，不是则不导入
                        if(fb.getOwnerTableName().equals(tableName)){
                            expotFields.add(field);
                        }
                    }
                }
                isValid = expotFields.size() == header.size() ? true : false;
            }
            if (!isValid) {
                error = ResourceUtil.getString("form.masterdatalist.inportexcelerror");
                throw new BusinessException("Excel模板格式不对");
            }
            //返回数据，去掉第一二行
            lists.remove(0);
            lists.remove(0);
            if (lists.size() > MAX_IMPORT_NUM) {
                error = "导入数据超过单次最大允许的条数 " + MAX_IMPORT_NUM + "，请分批次导入.";
                throw new BusinessException("导入数据超过单次最大允许的条数 " + MAX_IMPORT_NUM + "，请分批次导入");
            }
            //数据转换（组织等）
            FormFieldBean fieldBean = null;
            FormAuthViewFieldBean authViewFieldBean = null;
            boolean isOrgAndPro = false;
            //处理多级枚举关联
            FormDataMasterBean cacheMasterData = formManager.getSessioMasterDataBean(formMasterId);
            Map<String, Object> masterDataMap = null;
            if (cacheMasterData != null) {
                masterDataMap = cacheMasterData.getRowData();
            }
            Map<String, String> enumRelationMap = new HashMap<String, String>();
            Map<String, String> srcDataMap = new HashMap<String, String>();
            //先查找一下模板中的多级枚举相关信息
            List<FormFieldBean> fieldBeans = new ArrayList<FormFieldBean>();
            List<FormTableBean> beans = formBean.getSubTableBean();
            for (FormTableBean formTableBean : beans) {
                if (tableName.equals(formTableBean.getTableName())) {
                    //过滤计算字段
                    List<FormFieldBean> tbfieldBeans = formTableBean.getFields();
                    for (FormFieldBean b : tbfieldBeans) {
                        fieldBeans.add(b);
                    }
                    break;
                }
            }
            for (FormFieldBean ffb : fieldBeans) {
                if (FormFieldComEnum.RELATION == ffb.getInputTypeEnum()) {
                    FormRelation fr = ffb.getFormRelation();
                    if (fr != null) {
                        if (ToRelationAttrType.data_relation_multiEnum.getKey() == fr.getToRelationAttrType()) {
                            enumRelationMap.put(fr.getFromRelationAttr(), fr.getToRelationAttr());
                        } else if (ToRelationAttrType.data_relation_project.getKey() == fr.getToRelationAttrType() ||
                                ToRelationAttrType.data_relation_department.getKey() == fr.getToRelationAttrType() ||
                                ToRelationAttrType.data_relation_map.getKey() == fr.getToRelationAttrType() ||
                                ToRelationAttrType.data_relation_member.getKey() == fr.getToRelationAttrType()) {
                            String fieldName = fr.getToRelationAttr();
                            if (!needRefreshField.containsKey(fieldName)) {
                                needRefreshField.put(fieldName, fr.getToRelationAttrType());
                            }
                        }
                    }
                }
            }
            for (List<String> list : lists) {
                map = new HashMap<String, Object>();
                //map.putAll(data);
                row++;
                col = 0;//行加一，列归零
                for (int i = 0; i < list.size(); i++) {
                    if (i > header.size() - 1) {
                        break;
                    }
                    col++;
                    //fieldBean = expotFieldLists.get(expotFields.indexOf(header.get(i)));
                    fieldBean = formBean.getFieldBeanByDisplay(expotFields.get(i)).findRealFieldBean();
                    boolean hasRediectValue = false;
                    authViewFieldBean = favb.getFormAuthorizationField(fieldBean.getName());
                    //bug OA-94907 隐藏字段导入不成功
                    if (authViewFieldBean.getAccess().equals(FieldAccessType.browse.getKey())) {
                        String[] vstrs = authViewFieldBean.getValue();
                        if (vstrs != null && vstrs.length > 0) {
                            if (fieldBean.getEnumId() != 0L && Strings.isNotBlank(vstrs[0])) {
                                CtpEnumItem item = enumManagerNew.getCtpEnumItem(Long.parseLong(vstrs[0]));
                                list.set(i, item.getShowvalue());
                            } else {
                                list.set(i, vstrs[0]);
                                if (vstrs[0]!=null) {
                                    hasRediectValue = true;
                                }
                            }
                        } else {
                            continue;
                        }
                    } else if (authViewFieldBean.getAccess().equals(FieldAccessType.add.getKey())
                            || authViewFieldBean.getAccess().equals(FieldAccessType.edit.getKey())
                            || authViewFieldBean.getAccess().equals(FieldAccessType.hide.getKey())) {
                        if (authViewFieldBean.getIsInitNull() == 1) {
                            String[] vstrs = authViewFieldBean.getValue();
                            if (vstrs != null && vstrs.length > 0) {
                                if (fieldBean.getEnumId() != 0L && Strings.isNotBlank(vstrs[0])) {
                                    CtpEnumItem item = enumManagerNew.getCtpEnumItem(Long.parseLong(vstrs[0]));
                                    list.set(i, item.getShowvalue());
                                } else {
                                    list.set(i, vstrs[0]);
                                    hasRediectValue = true;
                                }
                            }
                        } else {
                            if (Strings.isBlank(list.get(i))) {
                                String[] vstrs = authViewFieldBean.getValue();
                                if (vstrs != null && vstrs.length > 0) {
                                    if (fieldBean.getEnumId() != 0L && Strings.isNotBlank(vstrs[0])) {
                                        CtpEnumItem item = enumManagerNew.getCtpEnumItem(Long.parseLong(vstrs[0]));
                                        list.set(i, item.getShowvalue());
                                    } else {
                                        if (Strings.isBlank(list.get(i))) {//如果设置了非强制初始值，那么导入的时候为空才把初始值赋上
                                            list.set(i, vstrs[0]);
                                            hasRediectValue = true;
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        continue;
                    }
                    srcDataMap.put(fieldBean.getName(), list.get(i));
                    isOrgAndPro = fieldBean.getInputTypeEnum().getCategory() == InputTypeCategory.ORG
                            || fieldBean.getInputTypeEnum() == FormFieldComEnum.EXTEND_PROJECT
                            || fieldBean.getInputTypeEnum() == FormFieldComEnum.SELECT
                            || fieldBean.getInputTypeEnum() == FormFieldComEnum.CHECKBOX
                            || fieldBean.getInputTypeEnum() == FormFieldComEnum.OUTWRITE;
                    if (isOrgAndPro) {
                        Object val = fieldBean.getValue4Import(list.get(i), hasRediectValue);//isDbValue
                        map.put(fieldBean.getName(), val);
                        if (!list.get(i).equals(val)) {
                            map.put(fieldBean.getName() + "_txt", list.get(i));
                        }
                    } else {
                        error = checkDataForImport(list.get(i), fieldBean, favb, sheetName, row, col);
                        if (!"".equals(error)) {
                            throw new BusinessException(error);
                        }
                        Object[] obj = fieldBean.getDisplayValue(list.get(i));
                        map.put(fieldBean.getName(), obj[2]);
                        if (!list.get(i).equals(obj[2])) {
                            map.put(fieldBean.getName() + "_txt", obj[1]);
                        }
                    }
                }
                handleMultiEnum(masterDataMap, map, srcDataMap, enumRelationMap, formBean, enumManagerNew);
                srcDataMap.clear();
                res.add(map);
            }
        } catch (Exception e) {
            if ("".equals(error)) {
                LOGGER.info("重复表导入数据,解析excel失败：" + e.getLocalizedMessage(), e);
                error = ResourceUtil.getString("form.repeatdata.importexcel.dataerror",
                        sheetName, row + 2, getExcelColumnName(col), e.getLocalizedMessage());
            }
            res.clear();
        } finally {
            try {
                fileManager.deleteFile(fileUrl, true);
            } catch (Exception e) {
                LOGGER.error("重复表导入数据,删除excel文件失败：" + e.getLocalizedMessage(), e);
            }
        }
        if (!"".equals(error)) {
            dc.add(FormConstant.RESULTS, "false");
            dc.add(FormConstant.ERRORMSG, error);
            return dc.getJson();
        }
        FormDataMasterBean cacheMasterData = formManager.getSessioMasterDataBean(formMasterId);
        //先校验再计算
        DataContainer resultMap = importDataSubBean(formMasterId, formId, rightId, tableName, res, data, needRefreshField);

        dc.add(FormConstant.SUCCESS, "true");
        if (null != cacheMasterData.getExtraAttr(FormConstant.viewRight)) {
            FormAuthViewBean currentAuth = (FormAuthViewBean) cacheMasterData.getExtraAttr(FormConstant.viewRight);
            dc.add(FormConstant.viewRight, String.valueOf(currentAuth.getId()));
        }
        dc.put(FormConstant.RESULTS, resultMap);
        return dc.getJson(MAX_IMPORT_NUM);
    }

    private DataContainer importDataSubBean(Long formMasterId, Long formId, Long rightId, String tableName,
                                            List<Map<String, Object>> datas, Map<String, Object> map, Map<String, Object> needRefreshField) throws BusinessException {
        FormBean form = formCacheManager.getForm(formId.longValue());
        FormTableBean formTableBean = form.getTableByTableName(tableName);
        List<FormFieldBean> fields = formTableBean.getFields();
        FormDataMasterBean cacheMasterData = formManager.getSessioMasterDataBean(formMasterId);
        boolean replaceFirstLine = false;
        List<FormDataSubBean> subBeans = cacheMasterData.getSubData(tableName);
        FormDataSubBean subBean = null;
        if (Strings.isNotEmpty(subBeans) && subBeans.size() == 1) {
            subBean = subBeans.get(0);
            Long id = Long.valueOf((String) map.get("id"));
            if (subBean.getId().equals(id)) {
                for (FormFieldBean field : fields) {
                    if (map.containsKey(field.getName())) {
                        subBean.addFieldValue(field.getName(), field.getFrontSubmitData(map.get(field.getName())));
                    }
                }
            }
            replaceFirstLine = subBean.isEmpty();
        }
        FormAuthViewBean formAuth = form.getAuthViewBeanById(rightId);
        Object obj = cacheMasterData.getExtraAttr(FormConstant.viewRight);
        if (obj != null) {
            formAuth = (FormAuthViewBean) obj;
        }
        for (Map<String, Object> data : datas) {
            data.put(SubTableField.formmain_id.getKey(), formMasterId);
            data.remove("id");
            if (replaceFirstLine && subBean != null) {
                subBean.addFieldValue(data);
                replaceFirstLine = false;
                continue;
            }
            AppContext.putThreadContext("isNew", false);
            FormDataSubBean formDataBean = new FormDataSubBean(data, formTableBean, cacheMasterData);
            formDataBean.initData(formAuth, false);
            AppContext.removeThreadContext("isNew");
            formDataBean.fillNullValue();
            cacheMasterData.addSubData(tableName, formDataBean);
        }
        Set<DataContainer> tempDatas = null;
        DataContainer resultMap = new DataContainer();
        AppContext.putThreadContext("notGenerateSubData", "true");
        if (datas.size() > 0) {
            Map<String, Object> tempMap = formManager.calcAll(form, cacheMasterData, formAuth, true, false, true);
            resultMap.putAll(tempMap);
        }
        for (Entry<String, Object> e : needRefreshField.entrySet()) {
            FormFieldBean tempField = form.getFieldBeanByName(e.getKey());
            ToRelationAttrType toRelationAttrType = ToRelationAttrType.getEnumByKey(Integer.valueOf(String.valueOf(e.getValue())));
            formRelationManager.dealRelationByType(tempField, form, formAuth, cacheMasterData, resultMap, 0L, toRelationAttrType, false, false);
        }
        Object o = AppContext.getThreadContext("addSubDataLines");
        Map<String,Set<FormDataSubBean>> addSubDataThreadMap = null;
        if(o!=null){
            addSubDataThreadMap = (Map<String,Set<FormDataSubBean>>)o;
        }else{
            addSubDataThreadMap = new HashMap<String, Set<FormDataSubBean>>();
        }
        resultMap.remove("datas");
        Set<FormDataSubBean> fillBackDatas = addSubDataThreadMap.get(tableName);
        if(fillBackDatas==null){
            fillBackDatas = new LinkedHashSet<FormDataSubBean>();
        }
        if(null!=subBean) {
            fillBackDatas.add(subBean);//第一行
        }
        tempDatas = this.getSubDataLineContainer(form, formAuth, cacheMasterData,fillBackDatas, resultMap);
        List<DataContainer> fillBackList = new ArrayList<DataContainer>();
        fillBackList.addAll(tempDatas);
        resultMap.put("datas", fillBackList);
        return resultMap;
    }

    private String checkDataForImport(String data, FormFieldBean ffb, FormAuthViewBean auth, String sheetName, int row, int col) throws BusinessException {
        Object objValue = null;
        StringBuilder errorMessage = new StringBuilder();
        try {
            if (ffb != null) {
                // 校验值的格式
                String returnStr = ffb.checkFormat(data, true);
                if (returnStr != null) {
                    errorMessage.append(ResourceUtil.getString(returnStr, sheetName, row + 2, getExcelColumnName(col)));
                    throw new BusinessException(errorMessage.toString());
                }
                objValue = ffb.getValue4Import(data, false);
                String inputType = ffb.getInputType();
                // 校验枚举是否是停用
                if (FormFieldComEnum.RADIO.getKey().equalsIgnoreCase(inputType)
                        || FormFieldComEnum.SELECT.getKey().equalsIgnoreCase(inputType)) {
                    CtpEnumItem item = enumManagerNew.getItemByEnumId(ffb.getEnumId(), data);
                    if (item != null && item.getState() != null && item.getState().intValue() == 0) {
                        errorMessage.append(ResourceUtil.getString("form.export.excel.errordata",
                                sheetName, row + 2, getExcelColumnName(col),
                                ResourceUtil.getString("form.export.excel.enum.disabled.error")));
                        throw new BusinessException(errorMessage.toString());
                    }
                }
                // 校验存储位数与小数点个数
                if (objValue != null) {
                    if (!ffb.checkDataLength(objValue.toString(), data)) {
                        errorMessage.append(ResourceUtil.getString("form.masterdatalist.savelengtherror",
                                sheetName, row + 2, getExcelColumnName(col)));
                        throw new BusinessException(errorMessage.toString());
                    }
                    if (FieldType.DECIMAL.getKey().equalsIgnoreCase(ffb.getFieldType())) {
                        FormRelation formRelation = ffb.getFormRelation();
                        boolean isRelationEnum = false;
                        if (formRelation != null) {
                            if (ToRelationAttrType.data_relation_multiEnum.getKey() == formRelation.getToRelationAttrType()) {
                                isRelationEnum = true;
                            }
                        }
                        if (!(FormFieldComEnum.RADIO.getKey().equalsIgnoreCase(ffb.getInputType())
                                || FormFieldComEnum.SELECT.getKey().equalsIgnoreCase(ffb.getInputType()) || isRelationEnum)) {
                            if (!ffb.checkNumberDigitLength(objValue)) {
                                errorMessage.append(ResourceUtil.getString("form.masterdatalist.decimalserror",
                                        sheetName, row + 2, getExcelColumnName(col)));
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.warn("重复表导入数据,字段校验：" + e.getLocalizedMessage(), e);
        }
        return errorMessage.toString();
    }

    public SignetManager getSignetManager() {
        return signetManager;
    }

    public void setSignetManager(SignetManager signetManager) {
        this.signetManager = signetManager;
    }

    public V3xHtmDocumentSignatManager getHtmSignetManager() {
        return htmSignetManager;
    }

    public void setHtmSignetManager(V3xHtmDocumentSignatManager htmSignetManager) {
        this.htmSignetManager = htmSignetManager;
    }

    @Override
    public FormQueryResult getFormQueryResult(Long currentUserId, FlipInfo flipInfo, boolean isNeedPage,
                                              FormBean formBean, Long templeteId, FormQueryTypeEnum queryType, FormQueryWhereClause customCondition,
                                              List<Map<String, Object>> customOrderBy, String[] customShowFields, FormQueryWhereClause relationSqlWhereClause, boolean reverse)
            throws BusinessException {
        if (queryType == FormQueryTypeEnum.baseManageQuery) {//业务生成器数据维护列表查询【基础数据】
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：业务生成器数据维护列表查询【基础数据】");
            }
        } else if (queryType == FormQueryTypeEnum.infoManageQuery) {//业务生成器数据维护列表查询【信息管理】
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：业务生成器数据维护列表查询【信息管理】");
            }
        } else if (queryType == FormQueryTypeEnum.flowRelationQuery) {//流程相关表单查询
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：流程相关表单查询");
            }
        } else if (queryType == FormQueryTypeEnum.relationFormQuery) {//关联表单查询
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：关联表单查询");
            }
        } else if (queryType == FormQueryTypeEnum.formQuery) {//表单查询
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：表单查询");
            }
        } else if(queryType == FormQueryTypeEnum.unFlowCheckRight){
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：无流程权限校验");
            }
        } else {
            if (LOGGER.isInfoEnabled()) {
                LOGGER.info("查询类型：未知查询");
            }
        }
        try {
            FormQueryWhereClause querySql = getFormQuerySql(
                    currentUserId,
                    flipInfo,
                    isNeedPage,
                    formBean,
                    templeteId,
                    queryType,
                    customCondition,
                    customOrderBy,
                    customShowFields,
                    relationSqlWhereClause,
                    reverse);
            LOGGER.info("生成的查询sql语句：" + querySql.getAllSqlClause());
            FormTableBean masterTableBean = formBean.getMasterTableBean();
            formDataDAO.selectMasterDataList(flipInfo, masterTableBean, querySql.getAllSqlClause(), querySql.getQueryParams());
            FormQueryResult queryResult = new FormQueryResult();
            queryResult.setFlipInfo(flipInfo);
            queryResult.setQuerySql(querySql.getAllSqlClause());
            queryResult.setQueryParams(querySql.getQueryParams());
            return queryResult;
        } catch (Exception e) {
            LOGGER.error("表单公共查询接口异常！", e);
            throw new BusinessException("表单公共查询接口异常！", e);
        }

    }

    /**
     * @param currentUserId
     * @param flipInfo
     * @param isNeedPage
     * @param formBean
     * @param templeteId
     * @param queryType
     * @param customCondition
     * @param customOrderBy
     * @param customShowFields
     * @param fromFormId
     * @param fromRecordId
     * @return
     * @throws BusinessException
     */
    private FormQueryWhereClause getFormQuerySql(Long currentUserId, FlipInfo flipInfo, boolean isNeedPage,
                                                 FormBean formBean, Long templeteId, FormQueryTypeEnum queryType, FormQueryWhereClause customSqlWhereClause,
                                                 List<Map<String, Object>> customOrderBy, String[] customShowFields, FormQueryWhereClause relationSqlWhereClause,
                                                 boolean reverse) throws Exception {
        StringBuffer sql = new StringBuffer("");
        FormTableBean masterTableBean = formBean.getMasterTableBean();
        FormBindBean bindBean = formBean.getBind();
        List<FormBindAuthBean> bindAuthList = new ArrayList<FormBindAuthBean>();
        if (templeteId == null || templeteId.longValue() == 0) {
            if (formBean.getFormType() == FormType.baseInfo.getKey()) {
                bindAuthList.add(bindBean.getUnFlowTemplateMap().values().iterator().next());
            } else {
                bindAuthList = bindBean.getUnflowFormBindAuthByUserId(currentUserId);
            }
        } else {
            FormBindAuthBean firstFormBindAuthBean = bindBean.getFormBindAuthBean(String.valueOf(templeteId));
            bindAuthList.add(firstFormBindAuthBean);
        }
        int size = bindAuthList.size();
        boolean multiBinds = (size == 1) ? false : true;
        String[] bindSqls = new String[size];
        FormBindAuthBean firstFormBindAuthBean = null;
        List<FormQueryWhereClause> whereClauseList = new ArrayList<FormQueryWhereClause>();
        //OA-79645公司协同：4.13 反馈上来性能问题 和一个严重的bug 详细内容见描述
        //亿化方案为：1、排除where条件相同的一个情况。2、限制5个，前端给提示

        /**
         * 性能优化专项：
         * 2016-11-07 CAP性能优化专项，解除5个应用绑定的限制。
         * 以前用的union关联查询，现在改为or条件查询。
         * 黄奎修改
         */
        for (int i = 0; i < size; i++) {
            //union改为or性能提升, 解除5个应用绑定的限制。
//            if (whereClauseList.size() >= 5) {
//                break;
//            }

            StringBuilder userCondition = new StringBuilder("");
            FormBindAuthBean bindAuth = bindAuthList.get(i);
            if (i == 0) {
                firstFormBindAuthBean = bindAuth;
            }
            //一个bind生成一个where查询条件对象
            FormQueryWhereClause oneWhereClause = getFormQueryWhereClauseForOneBind(formBean, firstFormBindAuthBean, bindAuth,
                    customSqlWhereClause, relationSqlWhereClause, multiBinds, reverse,customOrderBy);
            if (whereClauseList.isEmpty()) {
                whereClauseList.add(oneWhereClause);
            } else {
                boolean isAdd = false;
                Iterator<FormQueryWhereClause> it = whereClauseList.iterator();
                while (it.hasNext()) {
                    FormQueryWhereClause formQueryWhereClause = it.next();
                    String whereSql = formQueryWhereClause.getWhereClause();
                    if (whereSql.equals(oneWhereClause.getWhereClause())) {
                        List<Object> queryParams = formQueryWhereClause.getQueryParams();
                        List<Object> oneQueryParams = oneWhereClause.getQueryParams();
                        if (Strings.isNotEmpty(queryParams) && queryParams.size() == oneQueryParams.size()) {
                            for (int k = 0; k < queryParams.size(); k++) {
                                Object o1 = queryParams.get(k);
                                Object o2 = oneQueryParams.get(k);
                                if (!Strings.equals(o1, o2)) {
                                    isAdd = true;
                                    break;
                                }
                            }
                        } else {
                            LOGGER.error("--sql param is error-->" + queryParams + "<----->" + oneQueryParams);
                        }
                    } else {
                        isAdd = true;
                    }
                }
                if (isAdd) {
                    whereClauseList.add(oneWhereClause);
                }
            }
        }

        //用union合并结果集
        /**
         * 性能优化专项：
         * 2016-11-07 CAP性能优化专项，应用绑定关联底表数据列表选择加载很慢的性能问题。
         * 以前用的union关联查询，现在改为or条件查询。
         * 注意：union在没有建立索引时性能是差于or的，特别是应用绑定很多，union关联的很多时候慢的一塌糊涂。
         * 黄奎修改
         */
        if (multiBinds && whereClauseList.size() > 1) {
            List<Object> allParams = new ArrayList<Object>();
//            sql.append(" select * from (");
            for (int i = 0; i < whereClauseList.size(); i++) {
                FormQueryWhereClause abindWhereClause = whereClauseList.get(i);

                if (i == 0) {//首个需要select语句部分
                    sql.append(" ").append(abindWhereClause.getAllSqlClause()).append(" ");
                    if(Strings.isBlank(abindWhereClause.getWhereClause())) {//应用绑定中没有设置操作范围，那就查询所有数据，其他应用绑定不再拼sql
                        break;
                    }
                } else {
                    //后面的只需要条件部分用 or 连接
                    if(Strings.isNotBlank(abindWhereClause.getWhereClause())) {
                        //第二个应用绑定需要判断下是否有子表字段参与条件，但是在第一个应用的from里面没有，如果没有，这里给加上
                        for(String formson:abindWhereClause.getFormsons()){
                            if(sql.indexOf(formson) == -1){
                                sql = sql.replace(sql.indexOf("where"),sql.indexOf("where")+5,","+formson+" where");
                            }
                        }
                        sql.append(" or ").append(abindWhereClause.getWhereClause());
                    }else{
                        sql.append(" or 1=1 ");
                    }
                }

//                sql.append(" ").append(abindWhereClause.getAllSqlClause()).append(" ");
                if (null != abindWhereClause.getQueryParams() && !abindWhereClause.getQueryParams().isEmpty()) {
                    allParams.addAll(abindWhereClause.getQueryParams());
                }
//                if (i != whereClauseList.size() - 1) {
//                    sql.append(" union ");
//                }
            }
//            sql.append(" ) ").append(masterTableBean.getTableName()).append(" ");
            String sortFields = firstFormBindAuthBean.getSortStr(masterTableBean.getTableName(), reverse);
            //sqlserver下面order by字段不能重复，要判断是否有创建时间
            sortFields = " order by " + (Strings.isBlank(sortFields) ? "" : sortFields + ",");
            String collation = " asc ";
            if (reverse) {
                collation = "desc";
            }
            if (!sortFields.contains("start_date")) {
                sortFields += masterTableBean.getTableName() + ".start_date " + collation + ",";
            }
            sortFields += masterTableBean.getTableName() + ".id " + collation + " ";
            sql.append(sortFields);

            FormQueryWhereClause allQueryClause = new FormQueryWhereClause();
            allQueryClause.setAllSqlClause(sql.toString().replaceAll("<> null", "is not null"));
            allQueryClause.setQueryParams(allParams);
            return allQueryClause;
        } else if (multiBinds && whereClauseList.size() == 1) {
            FormQueryWhereClause queryClause = whereClauseList.get(0);
            String s = queryClause.getAllSqlClause();
            if (Strings.isNotBlank(s) && s.indexOf("order by") < 0) {
                String sortFields = firstFormBindAuthBean.getSortStr(masterTableBean.getTableName(), reverse);
                sortFields = " order by " + (Strings.isBlank(sortFields) ? "" : sortFields + ",");
                String collation = " asc ";
                if (reverse) {
                    collation = "desc";
                }
                if (!sortFields.contains("start_date")) {
                    sortFields += masterTableBean.getTableName() + ".start_date " + collation + ",";
                }
                sortFields += masterTableBean.getTableName() + ".id " + collation + " ";
                queryClause.setAllSqlClause(queryClause.getAllSqlClause().replaceAll("<> null", "is not null") + sortFields);
            } else {
                if (Strings.isNotBlank(s)) {
                    queryClause.setAllSqlClause(queryClause.getAllSqlClause().replaceAll("<> null", "is not null"));
                }
                return queryClause;
            }
            return queryClause;
        } else {
            FormQueryWhereClause queryClause = whereClauseList.get(0);
            if (Strings.isNotBlank(queryClause.getAllSqlClause())) {
                String allSql = queryClause.getAllSqlClause();
                allSql = allSql.replaceAll("<> null", "is not null");
                //加上自定义的排序语句
                if(Strings.isNotBlank(queryClause.getOrderByClause())){
                    allSql = allSql + "order by " + queryClause.getOrderByClause();
                }
                queryClause.setAllSqlClause(allSql);
            }
            return queryClause;
        }
    }

    /**
     * 一个bind生成一个where查询条件对象
     * 这里面如果没有自定义排序，就只处理了无流程列表的默认排序，关联表单的排序放到外面的方法处理的。
     * @param  customOrderBy M3无流程自定义排序
     * @return
     */
    private FormQueryWhereClause getFormQueryWhereClauseForOneBind(
            FormBean formBean,
            FormBindAuthBean firstFormBindAuthBean,
            FormBindAuthBean bindAuth,
            FormQueryWhereClause customSqlWhereClause,
            FormQueryWhereClause relationSqlWhereClause,
            boolean multiBinds, boolean reverse,List<Map<String, Object>> customOrderBy) {
        FormFormulaBean formulaBean = bindAuth.getFormFormulaBean();
        FormQueryWhereClause allWhereClause = new FormQueryWhereClause();
        List<Object> queryParams = new ArrayList<Object>();
        StringBuffer sb = new StringBuffer("");
        if (formulaBean != null) {
            //获得该绑定授权的过滤条件sql语句和查询参数对象
            FormQueryWhereClause formulaWhereClause = formulaBean.getExecuteFormulaForWhereClauseSQL(null, true, true);
            if (null != formulaWhereClause) {
                if (Strings.isNotBlank(formulaWhereClause.getAllSqlClause())) {
                    sb.append(" (").append(formulaWhereClause.getAllSqlClause()).append(") ");
                }
                if (null != formulaWhereClause.getQueryParams() && !formulaWhereClause.getQueryParams().isEmpty()) {
                    queryParams.addAll(formulaWhereClause.getQueryParams());
                }
            }
            //增加查询条件：拼接自定义增加的条件sql
            if (null != customSqlWhereClause) {
                if (Strings.isNotBlank(customSqlWhereClause.getAllSqlClause())) {
                    sb.append(" and (").append(customSqlWhereClause.getAllSqlClause()).append(") ");
                }
                if (null != customSqlWhereClause.getQueryParams() && !customSqlWhereClause.getQueryParams().isEmpty()) {
                    queryParams.addAll(customSqlWhereClause.getQueryParams());
                }
            }
            //拼接关联表单条件sql语句
            if (null != relationSqlWhereClause) {
                if (Strings.isNotBlank(relationSqlWhereClause.getAllSqlClause())) {
                    sb.append(" and (").append(relationSqlWhereClause.getAllSqlClause()).append(") ");
                }
                if (null != relationSqlWhereClause.getQueryParams() && !relationSqlWhereClause.getQueryParams().isEmpty()) {
                    queryParams.addAll(relationSqlWhereClause.getQueryParams());
                }
            }
        } else {
            boolean hasSql = false;
            //增加查询条件：拼接自定义增加的条件sql
            if (null != customSqlWhereClause) {
                if (Strings.isNotBlank(customSqlWhereClause.getAllSqlClause())) {
                    sb.append(" (").append(customSqlWhereClause.getAllSqlClause()).append(") ");
                    hasSql = true;
                }
                if (null != customSqlWhereClause.getQueryParams() && !customSqlWhereClause.getQueryParams().isEmpty()) {
                    queryParams.addAll(customSqlWhereClause.getQueryParams());
                }
            }
            //拼接关联表单条件sql语句
            if (null != relationSqlWhereClause) {
                if (Strings.isNotBlank(relationSqlWhereClause.getAllSqlClause())) {
                    if (hasSql) {
                        sb.append(" and (").append(relationSqlWhereClause.getAllSqlClause()).append(") ");
                    } else {
                        sb.append(" (").append(relationSqlWhereClause.getAllSqlClause()).append(") ");
                    }
                }
                if (null != relationSqlWhereClause.getQueryParams() && !relationSqlWhereClause.getQueryParams().isEmpty()) {
                    queryParams.addAll(relationSqlWhereClause.getQueryParams());
                }
            }
        }
        /*******
         * 20170421
         * 无流程打开的时候或者全文检索穿透的时候需要校验是否有权限打开单据，防止越权，这里采用统一的方式，保持一致，就不再单独用groovy来执行了
         * 查询字段就只查询id，然后在where语句最前面加id = contentDataId
         *******/
        boolean fromCheckRight = false;
        String contentDataId = AppContext.getThreadContext(FormConstant.CHECK_RIGHT_DATA_ID) == null?"":AppContext.getThreadContext(FormConstant.CHECK_RIGHT_DATA_ID).toString();
        if(Strings.isNotBlank(contentDataId)){
            fromCheckRight = true;
        }
        /*********************/
        String whereClause = sb.toString();

        FormTableBean masterTableBean = formBean.getMasterTableBean();
        Set<String> fieldSet = new LinkedHashSet<String>();
        List<SimpleObjectBean> showFieldObjs = firstFormBindAuthBean.getShowFieldList();
        String[] constFieldStrs = MasterTableField.getKeys();
        for (int i = 0; i < showFieldObjs.size(); i++) {
            SimpleObjectBean showField = showFieldObjs.get(i);
            String fieldName = showField.getName();
            if (fieldName.indexOf(".") == -1) {
                fieldName = masterTableBean.getTableName() + "." + fieldName;
            }
            fieldSet.add(fieldName);
        }
        //H5如果是用的移动视图的信息，取移动的显示字段
        boolean h5Tag = FormUtil.isH5();
        String isMobile = (String) AppContext.getThreadContext("isMobile");
        if (FormUtil.isPhoneLogin() || (h5Tag && "true".equals(isMobile))) {
            FormBindAuthBean4Phone phoneBind = firstFormBindAuthBean.getFormBindAuthBean4Phone();
            if (phoneBind != null) {
                List<SimpleObjectBean> phoneShow = phoneBind.getShowFieldList();
                if (Strings.isNotEmpty(phoneShow)) {
                    for (SimpleObjectBean show : phoneShow) {
                        String fieldName = show.getName();
                        if (fieldName.indexOf(".") == -1) {
                            fieldName = masterTableBean.getTableName() + "." + fieldName;
                        }
                        fieldSet.add(fieldName);
                    }
                }
            }
        }
        for (int i = 0; i < constFieldStrs.length; i++) {
            String constFieldStr = masterTableBean.getTableName() + "." + constFieldStrs[i];
            if (!fieldSet.contains(constFieldStr)) {
                fieldSet.add(constFieldStr);
            }
        }
        String[] fields = new String[fieldSet.size()];
        int j = 0;
        for (String s : fieldSet) {
            fields[j++] = s;
        }
        String fieldNames = StringUtils.arrayToString(fields);
        StringBuffer sql = new StringBuffer();
        if(fromCheckRight){
            sql.append(" select ").append(masterTableBean.getTableName()).append(".id");
        }else{
            sql.append(" select DISTINCT ").append(fieldNames);
        }
        sql.append(" from ").append(masterTableBean.getTableName()).append(" ").append(masterTableBean.getTableName()).append(" ");

        List<FormFieldBean> allFields = formBean.getAllFieldBeans();
        StringBuffer from = new StringBuffer(" ");
        for (FormFieldBean fieldBean : allFields) {
            if (fieldBean.isConstantField() || fieldBean.isMasterField()) {
                continue;
            }
            //判断select后边的字符串中是否包含子表字段，如果有，则from后边需要跟子表名字
            if (from.indexOf(fieldBean.getOwnerTableName()) == -1 && sql.indexOf(fieldBean.getName()) != -1) {
                from.append(",").append(fieldBean.getOwnerTableName());
                allWhereClause.putFormson(fieldBean.getOwnerTableName());
            }
            //判断where后边的字符串中是否包含子表字段，如果有，则from后边需要跟子表名字
            if (from.indexOf(fieldBean.getOwnerTableName()) == -1 && whereClause.indexOf(fieldBean.getName()) != -1) {
                from.append(",").append(fieldBean.getOwnerTableName());
                allWhereClause.putFormson(fieldBean.getOwnerTableName());
            }
            //判断sortFields后边的字符串中是否包含子表字段，如果有，则from后边需要跟子表名字
            if (from.indexOf(fieldBean.getOwnerTableName()) == -1 && whereClause.indexOf(fieldBean.getName()) != -1) {
                from.append(",").append(fieldBean.getOwnerTableName());
                allWhereClause.putFormson(fieldBean.getOwnerTableName());
            }
        }
        sql.append(from);

        List<FormTableBean> subTables = formBean.getSubTableBean();
        StringBuffer subTablewhereSb = new StringBuffer("");
        for (int i = 0; i < subTables.size(); i++) {
            if (subTables.get(i).isMainTable()) {
                continue;
            }
            if (sql.indexOf(subTables.get(i).getTableName()) != -1
                    && subTablewhereSb.indexOf(subTables.get(i).getTableName()) == -1) {
                subTablewhereSb.append(" (").append(subTables.get(i).getTableName()).append(".")
                        .append(SubTableField.formmain_id.getKey()).append("=")
                        .append(formBean.getMasterTableBean().getTableName()).append(".")
                        .append(MasterTableField.id.getKey()).append(") ");
                subTablewhereSb.append(" and ");
            }
        }
        int andIndex = subTablewhereSb.lastIndexOf("and ");
        if (andIndex != -1) {
            subTablewhereSb = subTablewhereSb.replace(andIndex, andIndex + "and ".length(), "");
        }
        if (!StringUtil.checkNull(subTablewhereSb.toString().trim())) {
            whereClause = subTablewhereSb.append(" and ").append(whereClause).toString();
        }
        if(fromCheckRight){
            if (!StringUtil.checkNull(whereClause.toString().trim())) {
                whereClause = " " + masterTableBean.getTableName()+".id = "+contentDataId+" and " + whereClause;
            }else{
                whereClause =" " + masterTableBean.getTableName()+".id = "+contentDataId;
            }
        }
        if (!StringUtil.checkNull(whereClause.toString().trim())) {
            sql.append(" where ");
            whereClause = FormUtil.changeAndAddNullWhereSql(whereClause.toString());
            sql.append(whereClause);
        }
        allWhereClause.setWhereClause(whereClause);
        andIndex = sql.lastIndexOf("and ");
        if (andIndex != -1 && andIndex == (sql.length() - "and ".length())) {
            sql = sql.replace(andIndex, andIndex + "and ".length(), "");
        }
        boolean customSort = false;
        if(!Strings.isEmpty(customOrderBy)){
            getCustomOrderByString(customOrderBy,allWhereClause,reverse);
            customSort= true;
        }
        if (!multiBinds && !customSort && !fromCheckRight) {
            String sortFields = firstFormBindAuthBean.getSortStr(masterTableBean.getTableName(), reverse);
            //sqlserver下面order by字段不能重复，要判断是否有创建时间
            sortFields = " order by " + (Strings.isBlank(sortFields) ? "" : sortFields + ",");
            String collation = " asc ";
            if (reverse) {
                collation = "desc";
            }
            String orderRule = "";
            if ("dm dbms".equals(SystemEnvironment.getDatabaseType())) {
                orderRule = " nulls first ";
                if ("desc".equals(collation)) {
                    orderRule = " nulls last ";
                }
                collation += orderRule;
            }
            if (!sortFields.contains("start_date")) {
                sortFields += masterTableBean.getTableName() + ".start_date " + collation + ",";
            }
            sortFields += masterTableBean.getTableName() + ".id " + collation + " ";
            sql.append(" " + sortFields);
        }
        allWhereClause.setAllSqlClause(sql.toString());
        allWhereClause.setQueryParams(queryParams);
        return allWhereClause;
    }

    /**
     * @param allWhereClause sql对象
     * @param sortList 自定义排序字段
     * @param reverse 预留，是否反转
     * 获取用户自定义的排序sql
     * @return
     */
    private void getCustomOrderByString(List<Map<String,Object>> sortList,FormQueryWhereClause allWhereClause,boolean reverse){
        StringBuffer sb = new StringBuffer();
        String sortStr = "";
        if(!Strings.isEmpty(sortList)){
            for(Map<String,Object> map:sortList){
                String orderType = map.get("orderType").toString();
                sb.append(map.get("fieldName")).append(" ").append(orderType);
                String orderRule = "";
                if ("dm dbms".equals(SystemEnvironment.getDatabaseType())) {
                    orderRule = " nulls first ";
                    if ("desc".equals(orderType)) {
                        orderRule = " nulls last ";
                    }
                    sb.append(" ").append(orderRule);
                }
                sb.append(" ,");
            }
        }
        sortStr = sb.toString();
        if(sortStr.endsWith(",")){
            sortStr = sortStr.substring(0,sortStr.length()-1);
        }
        allWhereClause.setOrderByClause(sortStr);
    }

    @Override
    public String checkBindsNum(Map<String, Object> params) {
        String msg = "";
        String formIdStr = (String) params.get("formId");
        if (Strings.isNotBlank(formIdStr)) {
            Long formId = Long.parseLong(formIdStr);
            FormBean formBean = formCacheManager.getForm(formId.longValue());
            if (formBean.getFormType() == FormType.manageInfo.getKey()) {
                FormBindBean bindBean = formBean.getBind();
                long currentUserId = AppContext.getCurrentUser().getId();
                List<FormBindAuthBean> bindAuthList = new ArrayList<FormBindAuthBean>();
                if (formBean.getFormType() == FormType.manageInfo.getKey()) {
                    try {
                        bindAuthList = bindBean.getUnflowFormBindAuthByUserId(currentUserId);
                    } catch (BusinessException e) {
                        LOGGER.error(e.getMessage(), e);
                    }

                    if (bindAuthList.size() > 5) {
                        msg = ResourceUtil.getString("form.check.bindnum");
                    }
                }
            }
        }
        return msg;
    }

    @Override
    public void addDownlaodRecord(Long formId, Long subReferenceId, Long userId) {
        addCacheRecord(formId, subReferenceId, userId, DOWNLOAD_KEY);
    }

    @Override
    public void addBatchUpdateRecord(Long formId, Long subReferenceId, Long userId) {
        addCacheRecord(formId, subReferenceId, userId, BATCH_UPDATE_KEY);
    }

    private void addCacheRecord(Long formId, Long subReferenceId, Long userId, String key) {
        Strings.addToMap(CACHE_RECORD, key, getCacheRecord(formId, subReferenceId, userId));
    }

    @Override
    public void removeBatchUpdateRecord(Long formId, Long subReferenceId, Long userId) {
        removeCacheRecord(formId, subReferenceId, userId, BATCH_UPDATE_KEY);
    }

    @Override
    public void removeDownloadRecord(Long formId, Long subReferenceId, Long userId) {
        removeCacheRecord(formId, subReferenceId, userId, DOWNLOAD_KEY);
    }

    @Override
    public void removeCacheRecord(Long formId, Long subReferenceId, Long userId, String key) {
        List<String> list = CACHE_RECORD.get(key);
        if (Strings.isNotEmpty(list)) {
            list.remove(getCacheRecord(formId, subReferenceId, userId));
        }
    }

    /**
     * 后台生成表单中的每个控件的二维码内容，因为前端生成会有如下两个问题：
     * 1.前端生成二维码后，客户又修改了其他内容，但是没有点击重新生成二维码，导致二维码中的内容和实际的有差异；
     * 2.流程表单的moduleId在新建的时候为-1，会导致如果为url格式的二维码中的moduleId不正确，导致最终扫码打不开页面。
     *
     * @param form
     * @param masterBean
     * @param contentAll
     * @throws BusinessException
     */
    @Override
    public void refreshAllBarCode(FormBean form, FormDataMasterBean masterBean, CtpContentAllBean contentAll) throws BusinessException {
        List<FormFieldBean> allFields = form.getAllFieldBeans();
        Map<String, Object> codeParam = null;
        Map<String, Object> customParam = null;
        long startTime = System.currentTimeMillis();
        for (FormFieldBean tempField : allFields) {
            if (FormFieldComEnum.BARCODE.getKey().equals(tempField.getInputType())) {
                String barcodeAttr = tempField.getBarcodeAttr();
                Map<String, String> attrMap = new HashMap<String, String>();
                codeParam = new HashMap<String, Object>();
                customParam = new HashMap<String, Object>();
                if (Strings.isNotBlank(barcodeAttr)) {
                    attrMap = (Map<String, String>) JSONUtil.parseJSONString(barcodeAttr);
                }
                //二维码宽度
                int width = Integer.valueOf(Strings.isBlank(attrMap.get("sizeOption")) ? "4" : attrMap.get("sizeOption")) * 50;
                //加密级别
                String encrypt = Strings.isBlank(attrMap.get("encrypt")) ? "0" : attrMap.get("encrypt");
                String encodeLevel = "0".equals(encrypt) ? "no" : "normal";
                //容错级别
                String errorCorrectionLevel = Strings.isBlank(attrMap.get("correctionOption")) ? BarcodeCorrectionOption.middle.getKey() : attrMap.get("correctionOption");
                //二维码类型
                String barcodeFormat = Strings.isBlank(attrMap.get("barcodeType")) ? BarcodeType.matrix.getKey() : attrMap.get("barcodeType");

                Long moduleId = contentAll.getModuleId();
                Long subReference = UUIDUtil.getUUIDLong();
                /**************************生成二维码图片需要的参数*********************************/
                codeParam.put("width", width);
                codeParam.put("height", width);
                codeParam.put("reference", moduleId);//无流程为主数据id，有流程为contentAll中的moduleId
                codeParam.put("subReference", subReference);//存入附件字段的id
                codeParam.put("encodeLevel", encodeLevel);
                codeParam.put("category", ApplicationCategoryEnum.form.getKey());//附件分类
                codeParam.put("errorLevel", errorCorrectionLevel);
                codeParam.put("barcodeFormat", barcodeFormat);
                codeParam.put("codeType", "form");//通过该参数找到实现生成二维码内容的类
                codeParam.put("throwException",false);//刷新二维码的时候，如果超过长度了，不抛出异常，重新生成一个带提示信息的二维码，扫描该二维码的时候给出提示

                /************************生成二维码内容需要的参数*************************/
                customParam.put("formId", form.getId());
                customParam.put("fieldName", tempField.getName());
                customParam.put("dataId", masterBean.getId());
                customParam.put("rightId", contentAll.getRightId());
                //url类型需要的参数
                customParam.put("moduleId", moduleId);
                customParam.put("contentType", contentAll.getContentType());
                customParam.put("viewState", contentAll.getViewState());
                customParam.put("formType", form.getFormType());
                List<FormDataSubBean> subdatas = null;
                if (tempField.isMasterField()) {//主表
                    customParam.put("recordId", 0L);
                    String oldStr = String.valueOf(masterBean.getFieldValue(tempField.getName()));
                    //20170428 应张颖要求，现在后台直接都生成二维码，前台不点生成后台也一并生成了
                    if (Strings.isNotBlank(oldStr) && !"null".equals(oldStr)) {//如果之前有值，则先删除已有的附件信息
                        Long oldSubReference = Long.valueOf(oldStr);
                        attachmentManager.removeByReference(moduleId, oldSubReference);
                        attachmentManager.removeByReference(-1L, oldSubReference);//有流程新增的时候moduleId 为-1
                    }
                    this.makeBarCode(tempField, codeParam, customParam);
                    masterBean.addFieldValue(tempField.getName(), subReference);

                } else {//重复表
                    subdatas = masterBean.getSubData(tempField.getOwnerTableName());
                    if (subdatas != null) {
                        for (FormDataSubBean subData : subdatas) {
                            customParam.put("recordId", subData.getId());
                            String oldStr = String.valueOf(subData.getFieldValue(tempField.getName()));
                            if (Strings.isNotBlank(oldStr) && !"null".equals(oldStr)) {
                                Long oldSubReference = Long.valueOf(oldStr);
                                attachmentManager.removeByReference(moduleId, oldSubReference);
                                attachmentManager.removeByReference(-1L, oldSubReference);//有流程新增的时候moduleId 为-1
                            }
                            this.makeBarCode(tempField, codeParam, customParam);
                            subData.addFieldValue(tempField.getName(), subReference);
                            //重复表有多行，重新生成一个subReference Id
                            subReference = UUIDUtil.getUUIDLong();
                            codeParam.put("subReference", subReference);//存入附件字段的id
                        }
                    }
                }
            }
        }
        LOGGER.info("二维码生成结束,共耗时" + (System.currentTimeMillis() - startTime));
    }

    /**
     * 生成二维码图片，并将附件入库
     *
     * @param fieldBean
     * @param codeParam
     * @param customParam
     * @throws BusinessException
     */
    private static void makeBarCode(FormFieldBean fieldBean, Map<String, Object> codeParam, Map<String, Object> customParam) throws BusinessException {
        BarCodeManager barCodeManager = (BarCodeManager) AppContext.getBean("barCodeManager");
        ResultVO vo = barCodeManager.getBarCodeAttachment(codeParam, customParam);
        if (!vo.isSuccess()) {
            LOGGER.info("----------【" + fieldBean.getDisplay() + "】二维码生成异常：" + vo.getMsg() + "--------------------");
            throw new BusinessException(vo.getMsg());
        }
    }

    private String getCacheRecord(Long formId, Long subReferenceId, Long userId) {
        StringBuilder sb = new StringBuilder();
        sb.append(formId).append("_").append(subReferenceId).append("_").append(userId);
        return sb.toString();
    }

    @Override
    public Map<String, Object> canDownload(Long formId, Long subReferenceId, Long userId) {
        return canDo(formId, subReferenceId, userId, DOWNLOAD_KEY, TOTAL_DOWNLOAD_NUM);
    }

    @Override
    public Map<String, Object> canBatchUpdate(Long formId, Long subReferenceId, Long userId) {
        return canDo(formId, subReferenceId, userId, BATCH_UPDATE_KEY, TOTAL_BATCH_UPDATE_NUM);
    }

    private Map<String, Object> canDo(Long formId, Long subReferenceId, Long userId, String key, int maxNum) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", true);
        //最大值大于0，且已有记录超过最大值时
        if (maxNum > 0 && moreThanMaxNum(key, maxNum)) {
            map.put("success", false);
            map.put("errorKey", "max");
            map.put("maxNum", maxNum);
        } else if (haveCacheRecord(formId, subReferenceId, userId, key)) {
            map.put("success", false);
            map.put("errorKey", "haveRecord");
        }
        return map;
    }

    private boolean haveCacheRecord(Long formId, Long subReferenceId, Long userId, String key) {
        List<String> list = CACHE_RECORD.get(key);
        return Strings.isNotEmpty(list) && list.contains(getCacheRecord(formId, subReferenceId, userId));
    }

    private boolean moreThanMaxNum(String key, int maxNum) {
        List<String> list = CACHE_RECORD.get(key);
        return Strings.isNotEmpty(list) && list.size() > maxNum;
    }

    @ListenEvent(event = UserLogoutEvent.class, async = true)
    public void listenEventUserLogout(UserLogoutEvent event) {
        List<UserLogoutEvent.LogoutUser> users = event.getUsers();
        if (Strings.isNotEmpty(users)) {
            for (UserLogoutEvent.LogoutUser user : users) {
                OnlineUser ou = user.getUser();
                if (ou == null) {
                    continue;
                }
                clearUserRecordCache(ou.getInternalId());
            }
        }
    }

    private void clearUserRecordCache(Long userId) {
        Set<String> keySet = CACHE_RECORD.keySet();
        for (String key : keySet) {
            clearUserRecordCache(userId, key);
        }
    }

    private void clearUserRecordCache(Long userId, String cacheKey) {
        List<String> caches = CACHE_RECORD.get(cacheKey);
        if (Strings.isNotEmpty(caches)) {
            List<String> tempCaches = new ArrayList<String>(caches);
            for (String str : tempCaches) {
                if (str.contains(userId.toString())) {
                    caches.remove(str);
                }
            }
        }
    }

    private boolean isChildrenWorkFlow(ColSummary colSummary) {
        return Integer.valueOf(ColConstant.NewflowType.child.ordinal()).equals(colSummary.getNewflowType());
    }

    @Override
    public List<FormDataSubBean> calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, String tableName, boolean replaceOldValue, FormAuthViewBean authViewBean) throws BusinessException {
        Map<String, SubRelationBean> relationBeanMap = fb.getRelationBeanMap();
        SubRelationBean subRelation = relationBeanMap.get(tableName);
        return calcRelationSubTable(fb, masterBean, subRelation, replaceOldValue, authViewBean);
    }

    @Override
    public List<FormDataSubBean> calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, String tableName, boolean replaceOldValue) throws BusinessException {
        return calcRelationSubTable(fb, masterBean, tableName, replaceOldValue, null);
    }

    private List<FormDataSubBean> calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, SubRelationBean subRelation, boolean replaceOldValue, FormAuthViewBean authViewBean) throws BusinessException {
        List<FormDataSubBean> result = new LinkedList<FormDataSubBean>();
        FormTableBean subTableBean = fb.getTableByTableName(subRelation.getToTable());
        List<FormDataSubBean> datas = masterBean.getSubData(subRelation.getFromTable());
        Map<String, List<FormDataSubBean>> relationDatas = groupDatas(fb, datas, subRelation);
        if (!relationDatas.isEmpty()) {
            for (Entry<String, List<FormDataSubBean>> et : relationDatas.entrySet()) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put(SubTableField.formmain_id.getKey(), masterBean.getId());
                List<FormDataSubBean> v = et.getValue();
                FormDataSubBean dataSubBean = v.get(0);
                Map<String, Object> formulaValueMap = masterBean.getFormulaMap(fb, subRelation.getFromTable(), v, FormulaEnums.formulaType_number);
                Map<String, FormFormulaBean> formulaMap = subRelation.getFormulaMap();
                //汇总计算的列的值处理
                for (Entry<String, FormFormulaBean> fet : formulaMap.entrySet()) {
                    FormFormulaBean formulaBean = fet.getValue();
                    String forumlaStr = formulaBean.getExecuteFormulaForGroove();
                    Object value = FormulaUtil.doResult(forumlaStr, formulaValueMap);
                    String key = fet.getKey().substring(fet.getKey().indexOf(".") + 1);
                    FormFieldBean formFieldBean = fb.getFieldBeanByName(key);
                    String formulaType = FormulaEnums.getFormulaTypeByFieldType(formFieldBean.getFieldType());
                    //处理计算后的值，比如枚举啊，小数位数啊那些
                    value = FormUtil.formatCalcValue(formFieldBean, value, formulaType);
                    map.put(key, value);
                }
                //分类项的值处理
                List<Map<String, String>> relations = subRelation.getFieldNameList();
                for (Map<String, String> ele : relations) {
                    for (Entry<String, String> e : ele.entrySet()) {
                        String key = e.getKey().substring(e.getKey().indexOf(".") + 1);
                        String value = e.getValue().substring(e.getValue().indexOf(".") + 1);
                        map.put(value, dataSubBean.getFieldValue(key));
                    }
                }
                //其他既不是分类汇总项也不是汇总计算列的，则用默认值或者空
                FormDataSubBean subBean = new FormDataSubBean(authViewBean, subTableBean, masterBean, true);
                subBean.addFieldValue(map);
                result.add(subBean);
            }
        } else {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put(SubTableField.formmain_id.getKey(), masterBean.getId());
            FormDataSubBean subBean = new FormDataSubBean(map, subTableBean, masterBean, true);
            result.add(subBean);
        }

        //按照分类项的顺序对数据进行排序
        result = sortDataByFieldList(fb, result, subRelation);

        if (replaceOldValue) {
            masterBean.refreshSort(result);
            masterBean.setSubData(subRelation.getToTable(), result);
        }

        return result;
    }

    /**
     * 根据设置的分类项来排序计算后的数据
     *
     * @param subDatas
     * @param subRelation
     * @return
     * @throws BusinessException
     */
    private List<FormDataSubBean> sortDataByFieldList(FormBean formBean, List<FormDataSubBean> subDatas, SubRelationBean subRelation) throws BusinessException {
        if (subDatas == null || subDatas.size() == 1) {//只有一条到时候不进行排序
            return subDatas;
        }
        List<Map<String, String>> fieldList = subRelation.getFieldNameList();
        List<FormDataSubBean> result = new LinkedList<FormDataSubBean>();
        result.addAll(sortDataByFieldList(formBean, subDatas, fieldList));
        return result;
    }

    /**
     * 递归处理每一对汇总项的排序
     *
     * @param formBean  表单
     * @param subDatas  需要排序的数据
     * @param fieldList 汇总项（每次取第一个，直到取完为止）
     * @return 返回排好序的数据列表
     * @throws BusinessException
     */
    private List<FormDataSubBean> sortDataByFieldList(FormBean formBean, List<FormDataSubBean> subDatas, List<Map<String, String>> fieldList) throws BusinessException {
        List<FormDataSubBean> result = new LinkedList<FormDataSubBean>();
        if (fieldList == null || fieldList.size() == 0) {
            return result;
        }
        //重新构建一个，不改变原有的值
        List<Map<String, String>> cloneList = new LinkedList<Map<String, String>>(fieldList);
        Map<String, String> sortField = cloneList.remove(0);
        String fieldName = "";
        for (Entry<String, String> e : sortField.entrySet()) {
            fieldName = e.getValue();
        }
        Set<String> keySet = new LinkedHashSet<String>();
        keySet.add(fieldName);
        Map<String, List<FormDataSubBean>> afterSort = new LinkedHashMap<String, List<FormDataSubBean>>();
        //数据分组
        for (FormDataSubBean subBean : subDatas) {
            String key = getKey(formBean, subBean, keySet);
            Strings.addToMap(afterSort, key, subBean);
        }
        //按照分组循环排序
        for (Entry<String, List<FormDataSubBean>> e : afterSort.entrySet()) {
            List<FormDataSubBean> tempList = sortDataByFieldList(formBean, e.getValue(), cloneList);
            result.addAll((tempList == null || tempList.size() == 0) ? e.getValue() : tempList);
        }
        return result;
    }

    private Map<String, List<FormDataSubBean>> groupDatas(FormBean fb, List<FormDataSubBean> datas, SubRelationBean subRelation) throws BusinessException {
        Map<String, List<FormDataSubBean>> result = new LinkedHashMap<String, List<FormDataSubBean>>();
        List<Map<String, String>> relations = subRelation.getFieldNameList();
        Set<String> keySet = new LinkedHashSet<String>();
        for (Map<String, String> ele : relations) {
            keySet.addAll(ele.keySet());
        }
        for (FormDataSubBean subBean : datas) {
            String key = getKey(fb, subBean, keySet);
            Strings.addToMap(result, key, subBean);
        }
        return result;
    }

    private String getKey(FormBean fb, FormDataSubBean subBean, Collection<String> keySet) throws BusinessException {
        if (Strings.isNotEmpty(keySet)) {
            StringBuilder sb = new StringBuilder();
            for (String key : keySet) {
                String fieldName = key.substring(key.indexOf(".") + 1);
                Object o = subBean.getFieldValue(fieldName);
                FormFieldBean fieldBean = fb.getFieldBeanByName(fieldName);
                sb.append(fieldBean.getDbValue(o)).append("_");
            }
            return sb.toString();
        }
        return "";
    }

    @Override
    public Map<String, List<FormDataSubBean>> calcAllRelationSubTable(Long formId, FormDataMasterBean masterBean, boolean replaceOldValue, FormAuthViewBean authViewBean, Map<String, Object> resultMap, boolean needDealSysRelation) throws BusinessException {
        FormBean fb = formCacheManager.getForm(formId);
        Map<String, SubRelationBean> relationBeanMap = fb.getRelationBeanMap();
        Map<String, List<FormDataSubBean>> result = null;
        if (relationBeanMap != null && !relationBeanMap.isEmpty()) {
            result = new HashMap<String, List<FormDataSubBean>>();
            for (Entry<String, SubRelationBean> et : relationBeanMap.entrySet()) {
                List<FormDataSubBean> list = calcRelationSubTable(fb, masterBean, et.getKey(), authViewBean, resultMap, needDealSysRelation);
                result.put(et.getKey(), list);
            }
        }
        return result;
    }

    /**
     * 前端调用生成汇总表数据
     *
     * @param fb
     * @param masterBean
     * @param tableName
     * @param authViewBean
     * @param resultMap
     * @param needDealSysRelation
     * @return
     * @throws BusinessException
     */
    @Override
    public List<FormDataSubBean> calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, String tableName, FormAuthViewBean authViewBean, Map<String, Object> resultMap, boolean needDealSysRelation) throws BusinessException {
        List<FormDataSubBean> newSubDatas = calcRelationSubTable(fb, masterBean, tableName, true, authViewBean);
        FormTableBean table = fb.getTableByTableName(tableName);
        List<FormFieldBean> fields = table.getFields();
        for (FormFieldBean field : fields) {
            for (FormDataSubBean subData : newSubDatas) {
                boolean hasCalc = false;
                if (field.isInCalculate()) {
                    hasCalc = true;
                    calcAllWithFieldIn(fb, field, masterBean, subData.getId(), resultMap, authViewBean, resultMap != null, needDealSysRelation);
                }
                if (!hasCalc && field.isInCondition() && needDealSysRelation) {
                    dealSysRelation(fb, masterBean, field, authViewBean, subData.getId(), false, null, resultMap != null);
                }
            }
        }
        return newSubDatas;
    }

    /**
     * 移动端查询接口
     *
     * @param flipInfo 页面信息
     * @param param    查询参数
     */
    @Override
    @SuppressWarnings("unchecked")
    public Map<String, Object> getQueryData4Phone(FlipInfo flipInfo, Map<String, Object> param) throws BusinessException {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("flipInfo", flipInfo);//查询结果
        resultMap.put("hasPhoneVeiwBean", false);//是否配置移动视图
        if (param.get("queryBeanId") == null || StringUtil.checkNull(param.get("queryBeanId").toString())) {
            return resultMap;
        }
        Long queryBeanId = Long.parseLong(param.get("queryBeanId").toString());
        //移动端可以切换为显示pc端字段，参数为isMobile = false;
        boolean isMobile = !(param.get("isMobile") != null && "false".equals(param.get("isMobile").toString()));
        FormQueryBean queryBean = formCacheManager.getQuery(queryBeanId);
        if (queryBean != null && queryBean.getFormBean() != null) {
            FormBean formBean = queryBean.getFormBean();
            // 需求调整，如果没有配置移动视图，则查询PC端的输出项 edit by chenxb 2016-04-28
            List<SimpleObjectBean> showFieldList;
            if (queryBean.hasPhoneViewBean() && isMobile) {
                FormQueryBean4Phone phoneVeiwBean = queryBean.getPhoneViewBean();
                showFieldList = phoneVeiwBean.getShowFieldList();
                resultMap.put("hasPhoneVeiwBean", true);
            } else {
                showFieldList = queryBean.getShowFieldList();
            }
            List<SimpleObjectBean> orderByList = queryBean.getOrderByList();

            String[] showField = null;
            if (!CollectionUtils.isEmpty(showFieldList)) {
                showField = new String[showFieldList.size()];
                for (int i = 0, size = showFieldList.size(); i < size; i++) {
                    showField[i] = showFieldList.get(i).getName();
                }
            }

            Map<String, String> orderBy = new LinkedHashMap<String, String>();

            Object userOrderByObj = param.get("userOrderBy");//用户排序
            List<Map<String, Object>> userOrderBy = (userOrderByObj instanceof List) ? (List<Map<String, Object>>) userOrderByObj : null;
            //M3配置的排序，如果有则按照这个来给查询排序
            if(Strings.isEmpty(userOrderBy)){
                if (!CollectionUtils.isEmpty(orderByList)) {
                    for (SimpleObjectBean bean : orderByList) {
                        if (Strings.isNotBlank(bean.getName())) {
                            orderBy.put(bean.getName(), bean.getValue());
                        }
                    }
                }
            }else{
                for(Map<String,Object> map:userOrderBy){
                    orderBy.put(map.get("fieldName").toString(),map.get("orderType").toString());
                }
            }
            Map<String, String> m = new HashMap<String, String>();
            //再组装用户输入条件
            if (queryBean.getUserCondition() != null) {
                Object userFastConObj = param.get("userFastCon");//用户输入条件
                List<Map<String, Object>> userFastCon = (userFastConObj instanceof List) ? (List<Map<String, Object>>) userFastConObj : null;//用户自定义条件

                if (userFastCon != null) {
                    for (Map<String, Object> mo : userFastCon) {
                        //TODO 之后用?占位符来处理
                        m.put("[" + mo.get("user_fieldName").toString() + "]", (String) Strings.escapeNULL(mo.get("fieldValue"), ""));//暂时先这么处理
                    }
                }
            }

            //先取querybean里的条件，这里面取到的用户输入条件是空的
            Object[] obj = queryBean.getCondicitonSQLStr(m);
            String whereSql = (String) obj[0];
            List wherePam = (List) obj[1];

            if (!StringUtil.checkNull(whereSql)) {
                whereSql = FormUtil.changeAndAddNullWhereSql(whereSql);
            }
            whereSql = FormUtil.changeEnumFieldsCompare(formBean, whereSql);

            flipInfo = formDataDAO.selectFormData4Query(formBean, flipInfo, showField, whereSql, orderBy, wherePam);
            FormUtil.setShowValueList(formBean, queryBean.getRightStr(), flipInfo.getData(), false);
        }
        return resultMap;
    }

    /**
     * 移动端查询接口 针对指标
     *
     * @param formId      表单ID
     * @param queryBeanId 查询对象ID
     * @param indicatorId 指标ID
     */
    @Override
    @SuppressWarnings("unchecked")
    public Map<Long, Object> selectData4PhoneIndicator(Long formId, Long queryBeanId, Long indicatorId) throws BusinessException {
        Map<Long, Object> result = new HashMap<Long, Object>();
        result.put(indicatorId, null);
        if (formId == null || queryBeanId == null || indicatorId == null) {
            return null;
        }

        FormBean formBean = formManager.getForm(formId);
        if (formBean == null || formBean.getFormQueryBean(queryBeanId) == null) {
            return null;
        }
        FormQueryBean queryBean = formBean.getFormQueryBean(queryBeanId);
        if (queryBean.getPhoneViewBean() == null) {
            return null;
        }
        //如果没有权限，则返回null
        if (!FormService.checkRight(FormModuleAuthModuleType.Query, queryBeanId, null, formId)) {
            return null;
        }

        FormQueryBean4Phone phoneVeiwBean = queryBean.getPhoneViewBean();
        FormQueryIndicatorBean indicator = phoneVeiwBean.getIndicatorById(indicatorId);
        if (indicator == null) {
            return null;
        }

        String type = indicator.getType();
        String fieldName = indicator.getIndicateField();

        //查询字段
        StringBuilder showStr = new StringBuilder();
        if (FormQueryBean4Phone.IndicatorType.getEnumByKey(type) == FormQueryBean4Phone.IndicatorType.IndicatorEarliest
                || FormQueryBean4Phone.IndicatorType.getEnumByKey(type) == FormQueryBean4Phone.IndicatorType.IndicatorLatest) {
            showStr.append(fieldName);
        } else if (FormQueryBean4Phone.IndicatorType.getEnumByKey(type) == FormQueryBean4Phone.IndicatorType.IndicatorCount) {
            showStr.append(type).append("(1)");
        } else {
            showStr.append(type).append("(").append(fieldName).append(")");
        }
        showStr.append(" as indicator ");

        //查询条件
        Object[] sqlArr = queryBean.getCondicitonSQLStr();
        String whereStr = (String) sqlArr[0];
        List param = (List) sqlArr[1];

        if (fieldName.contains(".")) {
            fieldName = fieldName.substring(fieldName.indexOf(".") + 1);
        }
        List<Map> value = formDataDAO.selectDataForPhoneIndicator(formBean, showStr.toString(), FormUtil.changeAndAddNullWhereSql(whereStr), param, type, fieldName);
        Object obj = null;
        if (value != null && value.size() == 1) {
            Map<String, Object> map = value.get(0);
            obj = map.get("indicator");
            if (obj != null) {
                //移动指标类型非个数的都应该进行格式化输出
                if (FormQueryBean4Phone.IndicatorType.getEnumByKey(type) != FormQueryBean4Phone.IndicatorType.IndicatorCount) {
                    FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
                    if (fieldBean == null) {
                        MasterTableField masterTableField = MasterTableField.getEnumByKey(fieldName);
                        if (masterTableField != null && (masterTableField == MasterTableField.start_date || masterTableField == MasterTableField.modify_date)) {
                            obj = DateUtil.formatDateTime((Date) obj);
                        }
                    } else {
                        //OA-100404M3-移动业务首页-移动指标项为复选数字时，合计平均最大最小显示成了名称
                        if (!FormFieldComEnum.CHECKBOX.getKey().equals(fieldBean.getFinalInputType(true))) {
                            obj = fieldBean.getDisplayValue(obj, false)[1];
                        }
                    }
                }
            }
        }

        result.put(indicatorId, obj);
        return result;
    }

    /**
     * 批量更新数据 针对回写批量更新动态表使用 采用先删除后新增的方式 add by chenxb 2016-11-30
     */
    @Override
    public void insertOrUpdateMasterData(List<FormDataMasterBean> masterBeanList) throws BusinessException, SQLException {
        formDataDAO.insertOrUpdateMasterData(masterBeanList);
    }

    /**
     * 批量删除数据
     */
    @Override
    public void deleteMasterData(List<FormDataMasterBean> masterBeanList) throws BusinessException, SQLException {
        formDataDAO.deleteMasterData(masterBeanList);
    }

    /**
     * 删除指定表单的指定数据
     * */
    @Override
    public void deleteData(Long masterId, FormBean formBean) throws BusinessException, SQLException{
        formDataDAO.deleteForm(masterId, formBean);
    }

    /**
     * 移动端看板查询栏目接口
     *
     * @param flipInfo 页面信息
     * @param param    查询参数
     */
    @Override
    @SuppressWarnings("unchecked")
    public void getQuerySectionData4Phone(FlipInfo flipInfo, Map<String, Object> param) throws BusinessException {
        if (param.get("queryBeanId") == null || StringUtil.checkNull(param.get("queryBeanId").toString())) {
            return;
        }
        Long queryBeanId = Long.parseLong(param.get("queryBeanId").toString());
        boolean showPhone = Boolean.valueOf(param.get("showPhone").toString());

        FormQueryBean queryBean = formCacheManager.getQuery(queryBeanId);
        if (queryBean != null && queryBean.getFormBean() != null) {
            FormBean formBean = queryBean.getFormBean();
            List<SimpleObjectBean> showFieldList;
            if (showPhone && queryBean.hasPhoneViewBean()) {
                FormQueryBean4Phone phoneVeiwBean = queryBean.getPhoneViewBean();
                showFieldList = phoneVeiwBean.getShowFieldList();
            } else {
                showFieldList = queryBean.getShowFieldList();
            }
            List<SimpleObjectBean> orderByList = queryBean.getOrderByList();

            String[] showField = null;
            if (Strings.isNotEmpty(showFieldList)) {
                showField = new String[showFieldList.size()];
                for (int i = 0, size = showFieldList.size(); i < size; i++) {
                    showField[i] = showFieldList.get(i).getName();
                }
            }

            Map<String, String> orderBy = new LinkedHashMap<String, String>();
            if (Strings.isNotEmpty(orderByList)) {
                for (SimpleObjectBean bean : orderByList) {
                    if (Strings.isNotBlank(bean.getName())) {
                        orderBy.put(bean.getName(), bean.getValue());
                    }
                }
            }

            Object[] obj = queryBean.getCondicitonSQLStr(null);
            String whereSql = (String) obj[0];
            List wherePam = (List) obj[1];

            if (!StringUtil.checkNull(whereSql)) {
                whereSql = FormUtil.changeAndAddNullWhereSql(whereSql);
            }
            whereSql = FormUtil.changeEnumFieldsCompare(formBean, whereSql);

            flipInfo = formDataDAO.selectFormData4Query(formBean, flipInfo, showField, whereSql, orderBy, wherePam);
            FormUtil.setShowValueList(formBean, queryBean.getRightStr(), flipInfo.getData(), false);
        }
    }

    /**
     * 判断数据唯一标识 采用加数据转入中间表的方式进行处理 进行联合查询，如果不能查到数据或者只能查询到一条，则表示符合规则，如果多余1条，则表示违反了唯一标识规则
     * 触发类数据保存时调用
     *
     * @param fb        表单
     * @param fieldList 唯一标识组合
     * @param valueList 对应唯一字段的值集
     * @return boolean true--不存在或者只有一条  false--存在多余1条
     */
    @Override
    public boolean isUniqueMarked(FormBean fb, List<String> fieldList, List<Object> valueList) throws BusinessException {
        String mainTableName = fb.getMasterTableBean().getTableName();
        String subTableName = "";
        boolean hasMainTable = false;
        boolean hasSubTable = false;
        StringBuilder sb = new StringBuilder();
        StringBuilder whereSb = new StringBuilder();
        if (fieldList.size() == 1) {
            return isFieldUnique(fb, fieldList.get(0), valueList);
        } else {
            String str = "";
            for (String fieldName : fieldList) {
                FormFieldBean ffb = fb.getFieldBeanByName(fieldName);
                if (!hasSubTable && ffb.isSubField()) {
                    subTableName = ffb.getOwnerTableName();
                    hasSubTable = true;
                }
                if (!hasMainTable && ffb.isMasterField()) {
                    hasMainTable = true;
                }
                sb.append(fieldName).append(", ");

                boolean isTime = false;
                if (FieldType.DATETIME.getKey().equals(ffb.getFieldType()) || FieldType.TIMESTAMP.getKey().equals(ffb.getFieldType())) {
                    isTime = true;
                }

                if(isTime){
                    str = " " + fieldName + " is not null and";
                }else {
                    if (JDBCAgent.getDBType().contains("server")) {
                        str = " isnull(" + fieldName + ", '0') != '0' and";
                    } else if ("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())) {
                        str = " NVL(" + fieldName + ", '0') != '0' and";
                    } else if ("mysql".equals(JDBCAgent.getDBType())) {
                        str = " ifnull(" + fieldName + ", '0') != '0' and";
                    }
                }
                whereSb.append(str);
            }
            String selectSql = sb.toString();
            selectSql = selectSql.substring(0, selectSql.length() - 2);
            String where = whereSb.toString();
            where = StringUtils.replaceLast(where, "and", "");

            String tableName = "";
            if (hasMainTable) {
                tableName = mainTableName;
            }
            String unionSQL = "";
            if (hasSubTable) {
                if (hasMainTable) {
                    tableName += " fm, " + subTableName + " fs";
                    unionSQL = "fm.id = fs.formmain_id and ";
                } else {
                    tableName = subTableName;
                }
            }

            //第一次查询所有的，第二次查询过滤掉重复的，然后比较两个size的大小，如果第一次比第二次多，那就是存在重复的
            StringBuilder sqlSB = new StringBuilder();
            sqlSB.append("select ");
            sqlSB.append(selectSql);
            sqlSB.append(" from ").append(tableName);
            sqlSB.append(" where ");
            sqlSB.append(unionSQL);
            sqlSB.append(where);
            String sql = "select count(*) as nnum from (" + sqlSB.toString() + ") t";
            List<Map> result = formDataDAO.selectDataBySql(sql);
            int v_size1 = result == null ? 0 : Integer.valueOf(result.get(0).get("nnum").toString());
            LOGGER.info("唯一标识1:" + v_size1);

            sqlSB = new StringBuilder();
            sqlSB.append("select distinct ");
            sqlSB.append(selectSql);
            sqlSB.append(" from ").append(tableName);
            sqlSB.append(" where ");
            sqlSB.append(unionSQL);
            sqlSB.append(where);
            sql = "select count(*) as nnum from (" + sqlSB.toString() + ") t";
            result = formDataDAO.selectDataBySql(sql);
            int v_size2 = result == null ? 0 : Integer.valueOf(result.get(0).get("nnum").toString());
            LOGGER.info("唯一标识2:" + v_size2);

            return !(v_size1 > v_size2);
        }
    }

    /**
     * 校验数据唯一 触发类数据保存时调用
     *
     * @param fb        表单
     * @param fieldName 唯一字段
     * @param valueList 对应唯一字段的值集
     * @return boolean true--不存在或者只有一条  false--存在多余1条
     */
    public boolean isFieldUnique(FormBean fb, String fieldName, List<Object> valueList) throws BusinessException {
        FormFieldBean ffb = fb.getFieldBeanByName(fieldName);
        String tableName = ffb.getOwnerTableName();

        //首先,如果是重复表字段，先判断传进来的list本身是否有重复的
        if (ffb.isSubField()) {
            //该变量目的是用来判断是否有重复的
            List<Object> list = new ArrayList<Object>();
            boolean isExist = false;
            for (Object value : valueList) {
                if (value == null) {
                    continue;
                }
                if (list.contains(value)) {
                    isExist = true;
                    break;
                } else {
                    list.add(value);
                }
            }
            if (isExist) {
                return false;
            }
        }

        JDBCAgent jdbc = new JDBCAgent();
        StringBuilder sql = new StringBuilder();
        List<Object> values = new ArrayList<Object>();
        try {
            sql.append(" select count(id) as num from " + tableName + " where ");
            int tempNum = 0;
            //遍历数据组装
            for (int j = 0; j < valueList.size(); j++) {
                Object value = valueList.get(j);
                if (value == null) {
                    continue;
                }
                boolean isTime = false;
                if (FieldType.DATETIME.getKey().equals(ffb.getFieldType())) {
                    if (value instanceof Date) {
                        String s = DateUtil.getDate((Date) value, DateUtil.YMDHMS_PATTERN);
                        value = DateUtil.parseTimestamp(s, DateUtil.YMDHMS_PATTERN);
                    } else if (value instanceof String) {
                        value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YMDHMS_PATTERN);
                    }
                    isTime = true;
                } else if (FieldType.TIMESTAMP.getKey().equals(ffb.getFieldType())) {
                    if (value instanceof Date) {
                        String s = DateUtil.getDate((Date) value, DateUtil.YEAR_MONTH_DAY_PATTERN);
                        value = DateUtil.parseTimestamp(s, DateUtil.YEAR_MONTH_DAY_PATTERN);
                    } else if (value instanceof String) {
                        value = DateUtil.parseTimestamp(String.valueOf(value), DateUtil.YEAR_MONTH_DAY_PATTERN);
                    }
                    isTime = true;
                }

                String str = "";
                if(isTime){
                    str = " " + fieldName + " is not null";
                } else {
                    if (JDBCAgent.getDBType().contains("server")) {
                        str = " isnull(" + fieldName + ", '0') != '0'";
                    } else if ("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())) {
                        str = " NVL(" + fieldName + ", '0') != '0'";
                    } else if ("mysql".equals(JDBCAgent.getDBType())) {
                        str = " ifnull(" + fieldName + ", '0') != '0'";
                    }
                }

                //第一条特殊处理，同时这边也可能就只有一条的情况。
                if (j == 0) {
                    sql.append(" (" + ffb.getName() + " =  ? and " + str + ") ");
                } else {
                    if (sql.indexOf("?") > -1) {
                        sql.append(" or (" + ffb.getName() + " =  ? and " + str + ") ");
                    } else {
                        sql.append(" (" + ffb.getName() + " =  ? and " + str + ") ");
                    }
                }
                values.add(value);
                tempNum++;
            }
            int count = 0;
            if (sql.indexOf("?") > -1) {
                jdbc.execute(sql.toString(), values);
                Map m = jdbc.resultSetToMap();
                count = m.get("num") == null ? 0 : Integer.parseInt(String.valueOf(m.get("num")));
            }
            LOGGER.info("数据唯一：" + sql.toString() + " param:" + values + " count:" + count + " tempNum" + tempNum);
            //返回count大于tempNum表示有重复数据
            if (count > tempNum) {
                return false;
            }
        } catch (Exception e) {
            LOGGER.error(ffb.getName() + " 做数据唯一判断时异常，", e);
            throw new BusinessException(e);
        } finally {
            jdbc.close();
        }
        return true;

        //第一次查询所有的，第二次查询过滤掉重复的，然后比较两个size的大小，如果第一次比第二次多，那就是存在重复的
        /*StringBuilder sqlSB = new StringBuilder();
        sqlSB.append("select count(1) as nnum from (select ");
        sqlSB.append(fieldName);
        sqlSB.append(" from ").append(tableName);
        sqlSB.append(" where ");

        String str = "";
        if (JDBCAgent.getDBType().contains("server")){
            str = " isnull("+fieldName+", '0') != '0'";
        }else if("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())){
            str = " NVL("+fieldName+", '0') != '0'";
        }else if ("mysql".equals(JDBCAgent.getDBType())){
            str = " ifnull("+fieldName+", '0') != '0'";
        }
        sqlSB.append(str);
        sqlSB.append(") t");

        List<Map> result = formDataDAO.selectDataBySql(sqlSB.toString());
        int v_size1 = result == null ? 0 : Integer.valueOf(result.get(0).get("nnum").toString());
        LOGGER.info("数据唯一1:" + v_size1);

        sqlSB = new StringBuilder();
        sqlSB.append("select count(1) as nnum from (select distinct ");
        sqlSB.append(fieldName);
        sqlSB.append(" from ").append(tableName);
        sqlSB.append(" where ");

        str = "";
        if (JDBCAgent.getDBType().contains("server")){
            str = " isnull("+fieldName+", '0') != '0'";
        }else if("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())){
            str = " NVL("+fieldName+", '0') != '0'";
        }else if ("mysql".equals(JDBCAgent.getDBType())){
            str = " ifnull("+fieldName+", '0') != '0'";
        }
        sqlSB.append(str);
        sqlSB.append(") t");

        result = formDataDAO.selectDataBySql(sqlSB.toString());
        int v_size2 = result == null ? 0 : Integer.valueOf(result.get(0).get("nnum").toString());
        LOGGER.info("数据唯一2:" + v_size2);

        return !(v_size1 > v_size2);*/
    }

	@Override
	@AjaxAccess
	public List<FormTreeNode> getUnflowFormQueryTree(Map params) throws BusinessException {
		//添加点击根节点图标时，返回树形结构不断追加根节点问题
		if(params.get("id") != null){
			return null;
		}
		String key = (String) params.get("formField");
		String formTemplateId = (String) params.get("formTemplateId");
		String formId = (String) params.get("formId");
		Long accountId = ParamUtil.getLong(params, "accountId");
		FormBean formBean = formCacheManager.getForm(Long.parseLong(formId));
		FormFieldBean ffb1 = formBean.getFieldBeanByName(key);
		ffb1 = ffb1.findRealFieldBean();
		List<FormTreeNode> result = new ArrayList<FormTreeNode>();
		FormFieldComEnum comEnum = FormFieldComEnum.getEnumByKey(ffb1.getFinalInputType(true));
		String conditionVal = ParamUtil.getString(params, "conditionVal");
		if(null != conditionVal){
			conditionVal = StringEscapeUtils.unescapeHtml4(conditionVal);
		}
		
		switch (comEnum) {
		case RADIO:
		case SELECT:
			Long enumId = ffb1.getEnumId();
			result = this.getEnumTree(ffb1, String.valueOf(params.get("condition")), conditionVal);
			break;
		case EXTEND_MULTI_DEPARTMENT:
		case EXTEND_DEPARTMENT:
			result = this.getOrgDeptTree(accountId, String.valueOf(params.get("condition")), conditionVal);
			break;
		default:
			break;
		}
		
		return result;
	}
    
	/**
	 * 获取枚举树
	 * @param fieldBean
	 * @param conditionName
	 * @param conditionVal
	 * @return
	 * @throws BusinessException
	 */
	private List<FormTreeNode> getEnumTree(FormFieldBean fieldBean,String conditionName,String conditionVal)throws BusinessException{
		Long enumId = fieldBean.getEnumId();
		boolean isFinalChild = fieldBean.getIsFinalChild();
		int enumLevel = fieldBean.getEnumLevel();
		CtpEnumBean enumBean = null;
		List<CtpEnumItem> enumList = null;
		if(FormFieldComEnum.OUTWRITE.getKey().equals(fieldBean.getFinalInputType())){
			enumId = fieldBean.getFormatEnumId();
			isFinalChild = fieldBean.isFormatEnumIsFinalChild();
			enumLevel = fieldBean.getFormatEnumLevel();
			enumBean = enumManagerNew.getEnum(enumId);
			enumList = enumManagerNew.getEmumItemByEmumId(enumId);
		}else{
			enumBean = enumManagerNew.getEnum(enumId);
			enumList = enumManagerNew.getEmumItemByEmumId(enumId);
		}
		
		List<FormTreeNode> result = new ArrayList<FormTreeNode>();
		FormTreeNode rootNode = new FormTreeNode();
		rootNode.setId(enumBean.getId()+"");
		rootNode.setParentId("0");
		rootNode.setName(ResourceUtil.getString(enumBean.getEnumname()));
		rootNode.setSort(enumBean.getSortnumber()+"");
//		rootNode.setType("nocheck");
		rootNode.setType("allvalue");
		rootNode.addProperties("isExpandNode", "true");
		result.add(rootNode);
		List<CtpEnumItem> lastEnumList = null;
		if(isFinalChild){
			lastEnumList = enumManagerNew.getLastCtpEnumItem(enumId);
		}
		
		for(CtpEnumItem item:enumList){
			FormTreeNode node = new FormTreeNode();
			if(isFinalChild){//是末级枚举，只有末级枚举可以勾选
//				if( !lastEnumList.contains(item)){
//					node.setType("nocheck");
//				}
				if( lastEnumList.contains(item)){
					node.setType("value");
				}
			}else{//不是末级枚举 按字段对应的枚举级别
//				if(item.getLevelNum().intValue() > enumLevel){
//					continue;
//				}else if(item.getLevelNum().intValue() < enumLevel){
//					node.setType("nocheck");
//				}
				if(item.getLevelNum().intValue() > enumLevel){
					continue;
				}else if(item.getLevelNum().intValue() == enumLevel){
					node.setType("value");
				}
			}
			
			if("0".equals(item.getLevelNum().toString()) && "0".equals(item.getParentId().toString())){
				node.setId(item.getId()+"");
				node.setParentId(item.getRefEnumid()+"");
				node.setName(item.getShowvalue());
			}else{
				node.setId(item.getId()+"");
				node.setParentId(item.getParentId()+"");
				node.setName(item.getShowvalue());
			}
			node.setSort(item.getSortnumber()+"");
			node.addProperties("isExpandNode", "true");
			result.add(node);
		}
		//进行条件过滤
		if("conditionName".equals(conditionName)){
			if(Strings.isNotBlank(conditionVal)){
				List<FormTreeNode> res = new ArrayList<FormTreeNode>();
				for(FormTreeNode node:result){
					if(node.getName().indexOf(conditionVal.toString()) != -1){
						UnflowFormQueryUtil.getTreeNode(node, result, res);
					}
				}
				if(Strings.isEmpty(res)){
					res.add(rootNode);
				}
				Collections.sort(res, TreeNodeUtil.TreeNodeComparator.getInstance());
				return res;
			}
		}
		Collections.sort(result, TreeNodeUtil.TreeNodeComparator.getInstance());
		return result;
	}
	
	/**
	 * 获取部门树
	 * @param accountId
	 * @param conditionName
	 * @param conditionVal
	 * @return
	 * @throws BusinessException
	 */
	private List<FormTreeNode> getOrgDeptTree(Long accountId,String conditionName,String conditionVal)throws BusinessException{
		List<FormTreeNode> result = new ArrayList<FormTreeNode>();
		FormTreeNode rootNode = new FormTreeNode();
		//是否设置了根节点
		boolean isSetRootNode = false;
		V3xOrgAccount acc = orgManager.getAccountById(accountId);
		//查询所有部门包含子部门
		List<V3xOrgDepartment> allDept = orgManager.getChildDepartments(accountId, false);
		FormTreeNode accNode = new FormTreeNode();
		accNode.setId(accountId+"");
		accNode.setParentId("0");
		accNode.setName(acc.getName());
		accNode.setSort(acc.getSortId()+"");
//		accNode.setType("account");
		accNode.setType("allvalue");
		result.add(accNode);
		for(V3xOrgDepartment dept:allDept){
			FormTreeNode deptNode = new FormTreeNode();
			deptNode.setId(dept.getId()+"");
			deptNode.setParentId(dept.getSuperior()+"");
			deptNode.setName(dept.getName());
			deptNode.setSort(dept.getSortId()+"");
//			deptNode.setType("department");
			deptNode.setType("value");
			if(dept.getId().equals(AppContext.getCurrentUser().getDepartmentId())){
				accNode.addProperties("isExpandNode", "true");
			}
			result.add(deptNode);
		}
		//判断是否为集团版
		if(!isSetRootNode){
			if(SysFlag.sys_isGroupVer.getFlag().equals(Boolean.valueOf(true)) && acc.isGroup()){
				rootNode = accNode;
			}else{
				rootNode = accNode;
			}
			isSetRootNode = true;
		}
		//进行条件过滤
		if("conditionName".equals(conditionName)){
			if(Strings.isNotBlank(conditionVal)){
				List<FormTreeNode> res = new ArrayList<FormTreeNode>();
				for(FormTreeNode node:result){
					if(node.getName().indexOf(conditionVal.toString()) != -1){
						UnflowFormQueryUtil.getTreeNode(node, result, res);
					}
				}
				Collections.sort(res, TreeNodeUtil.TreeNodeComparator.getInstance());
				if(Strings.isEmpty(res)){
					res.add(rootNode);
				}
				return res;
			}
		}
		Collections.sort(result, TreeNodeUtil.TreeNodeComparator.getInstance());
		return result;
	}

	//TODO 如果查询条件需要分级别展示，可能需要用到这个方法
	/**
	 * 查询无流程表单（信息管理）设置的查询条件字段<br>
     * 其中radio、checkbox、select、date、datetime 优先显示，其他类型 如：text、lalbel 次要显示
	 * @param formId
	 * @param formTemplateId
	 * @return
	 * @throws BusinessException
	 */
	private Map<String,List<FormSearchFieldBaseBo>> getUnfolwFormSearchFields(Long formId,Long formTemplateId)
			throws BusinessException {
		Map<String,List<FormSearchFieldBaseBo>> resultMap = new LinkedHashMap<String, List<FormSearchFieldBaseBo>>();
		FormBean formBean = formCacheManager.getForm(formId);
		FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
        if (bindAuthBean != null) {
            if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
            }
            List<SimpleObjectBean> searchFields = bindAuthBean.getSearchFieldList();
            List<FormSearchFieldBaseBo> firstField = new ArrayList<FormSearchFieldBaseBo>();
            List<FormSearchFieldBaseBo> otherField = new ArrayList<FormSearchFieldBaseBo>();
        	for(SimpleObjectBean sob:searchFields){
        		String extraJson = sob.getExtAttr(ExtMap.DefaultValJSON.getKey());
        		if(Strings.isNotBlank(extraJson)){
        			Map mapObj = (Map) JSONUtil.parseJSONString(extraJson);
        			Object inputType = mapObj.get("inputType");
        			//只有部门、多部门、单选、下来列表 才能树形展现
        			if(inputType == null){
        				continue;
        			}
        			FormSearchFieldBaseBo fieldBo = null;
        			FormFieldComEnum fieldComEnum = FormFieldComEnum.getEnumByKey(inputType.toString());
        			//单选、复选框、下拉框、日期 优先显示
        			switch (fieldComEnum) {
					case SELECT:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldEnumVo.class);
						firstField.add(fieldBo);
						break;
					case RADIO:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldEnumVo.class);
						firstField.add(fieldBo);
						break;
					case CHECKBOX:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldCheckboxVo.class);
						firstField.add(fieldBo);
						break;
					case EXTEND_DATE:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldDateVo.class);
						firstField.add(fieldBo);
						break;
					case EXTEND_DATETIME:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldDateVo.class);
						firstField.add(fieldBo);
						break;
					case TEXT:
					case TEXTAREA:
					case LABLE:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldBaseBo.class);
						otherField.add(fieldBo);
						break;
					case EXTEND_ACCOUNT:
					case EXTEND_MULTI_ACCOUNT:
					case EXTEND_DEPARTMENT:
					case EXTEND_MULTI_DEPARTMENT:
					case EXTEND_MEMBER:
					case EXTEND_MULTI_MEMBER:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldDeptVo.class);
						otherField.add(fieldBo);
					default:
						fieldBo = JSONUtil.parseJSONString(extraJson, FormSearchFieldBaseBo.class);
						otherField.add(fieldBo);
						break;
					}
        		}
        	}
        	resultMap.put("first", firstField);
        	resultMap.put("other", otherField);
        }
        
		return resultMap;
	}

	@Override
	public FormSearchFieldBaseBo getUnfolwFormSearchFirstTreeField(Long formId,Long formTemplateId)
			throws BusinessException {
		FormBean formBean = formCacheManager.getForm(formId);
		FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
        List<SimpleObjectBean> searchFields = bindAuthBean.getSearchFieldList();
     	for(SimpleObjectBean sob:searchFields){
     		String extraJson = sob.getExtAttr(ExtMap.DefaultValJSON.getKey());
     		if(Strings.isNotBlank(extraJson)){
     			String fieldName = sob.getName();
     			FormFieldBean field = null;
     			Enums.MasterTableField masterTableField = Enums.MasterTableField.getEnumByKey(fieldName);
     			if(null != masterTableField){
     				field = masterTableField.getFormFieldBean();
     			}else{
     				fieldName = fieldName.split("[.]")[1];
     				field = formBean.getFieldBeanByName(fieldName);
     			}
     			String inputType = field.getFinalInputType(true);
     			if(field.isEnumField()){//是枚举
     				FormSearchFieldBaseBo fieldBo = getSearchFeildBase(sob, field);
     				if(Strings.isNotEmpty(fieldBo.getTreeShow()) && "1".equals(fieldBo.getTreeShow())){
     					fieldBo.setKey(fieldName);
         				return fieldBo;
         			}
     			}else if(FormFieldComEnum.EXTEND_DEPARTMENT.getKey().equals(inputType) 
     					|| FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey().equals(inputType)){//部门字段
     				FormSearchFieldDeptVo fieldBoDepartment = JSONUtil.parseJSONString(extraJson, FormSearchFieldDeptVo.class);
    				FormulaVar enumDepVar = FormulaVar.getEnumByKey(fieldBoDepartment.getDefaultVal());
    				if(null != enumDepVar){
    					fieldBoDepartment.setDefaultVal(OrgHelper.showOrgEntities(enumDepVar.getValue(), "Department", ","));
    					fieldBoDepartment.setHandOrgIds(enumDepVar.getValue());
    				}
    				fieldBoDepartment.setInputType(field.getFinalInputType(true));
    				if(Strings.isNotEmpty(fieldBoDepartment.getTreeShow()) && "1".equals(fieldBoDepartment.getTreeShow())){
    					fieldBoDepartment.setKey(fieldName);
         				return fieldBoDepartment;
         			}
     			}
     		}
     	}
		return null;
	}
    
	@Override
	public Map<String,String> convertUnflowFormQuery2Html4First(Long formId,Long formTemplateId)throws BusinessException{
		FormBean formBean = formCacheManager.getForm(formId);
		Map<String,List<FormSearchFieldBaseBo>>  fieldsBo = this.getUnfolwFormSearchFields(formId, formTemplateId);
        //字段合并处理
        Map<String, List<FormSearchFieldBaseBo>> contractMap = UnflowFormQueryUtil.contractUnflowFormSearch4First(formBean, fieldsBo.get("first"));
        Map<String,String> firstHtml = this.convertUnflowFormQuery2Html(contractMap,formId,formTemplateId);
        return firstHtml;
	}
	
	
	@Override
	public Map<String, String> convertUnflowFormQuery2Html4Others(Long formId,
			Long formTemplateId) throws BusinessException {
		FormBean formBean = formCacheManager.getForm(formId);
		Map<String,List<FormSearchFieldBaseBo>>  fieldsBo = this.getUnfolwFormSearchFields(formId, formTemplateId);
        //字段合并处理
        Map<String, List<FormSearchFieldBaseBo>> contractMap = UnflowFormQueryUtil.contractUnflowFormSearch4First(formBean, fieldsBo.get("other"));
        Map<String,String> otherHtml = this.convertUnflowFormQuery2Html(contractMap,formId,formTemplateId);
        return otherHtml;
	}

	/**
	 * 将无流程表单设置的条件转换成html
	 * @return
	 * @throws BusinessException
	 */
    private Map<String,String> convertUnflowFormQuery2Html(Map<String,List<FormSearchFieldBaseBo>> fieldMap,Long formId,Long formTemplateId) throws BusinessException{
    	FormBean formBean = formCacheManager.getForm(formId);
    	List<String> allHtmlList = new ArrayList<String>();
    	
    	Map<String,String> resultHtml = new LinkedHashMap<String, String>();
    	//所有行的集合
    	for(Map.Entry<String,List<FormSearchFieldBaseBo>> entry : fieldMap.entrySet()){
    		//每一行的值
    		List<FormSearchFieldBaseBo> fieldList = entry.getValue();
    		StringBuffer lineHtml = new StringBuffer();
    		boolean isAppendHtml = false;
    		String key = entry.getKey();
    		String fieldName = key.split("[.]")[1];

			FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName).findRealFieldBean();
			FormFieldComEnum fieldComEnum = fieldBean.getInputTypeEnum();
			
			//每行显示的字段名称
			String showFieldName = "";
			//所有字段需要显示的值html
			String valHtml = "";
			switch (fieldComEnum) {
				case SELECT:
				
				case RADIO:
					
					for(FormSearchFieldBaseBo bo:fieldList){
						Long enumId = fieldBean.getEnumId();
						List<CtpEnumItem> enumList = enumManagerNew.getEmumItemByEmumId(enumId);
						showFieldName = bo.getValue();
						for(CtpEnumItem item:enumList){
							valHtml += "<label class=\"condition-lable\" for=\""+item.getId()+"\"><input type=\"checkbox\" id=\""+item.getId()+"\" name=\""+bo.getKey()+"\" value=\""+item.getId()+"\"/><span>"+ResourceUtil.getString(item.getShowvalue())+"</span></label>";
						}
					}
					
					isAppendHtml = true;
					break;
				case CHECKBOX:
					for(FormSearchFieldBaseBo bo:fieldList){
						FormSearchFieldCheckboxVo checkboxVo = (FormSearchFieldCheckboxVo) bo;
						//前置标签
						if(Strings.isNotBlank(checkboxVo.getFrontlabelVal())){
							showFieldName = checkboxVo.getFrontlabelVal();
						}
						String defaultVal = bo.getDefaultVal();
						String checkedStyle = null;
						if("1".equals(defaultVal)){
							checkedStyle = " checked = checked";
						}
						valHtml += "<label class=\"condition-lable\" for=\""+checkboxVo.getKey()+"\"><input type=\"checkbox\" name=\""+checkboxVo.getKey()+"\" id=\""+checkboxVo.getKey()+"\" "+checkedStyle+"\" value=\"1\"/><span>"+checkboxVo.getValue()+"</span></label>";
					}
					isAppendHtml = true;
					break;
				case EXTEND_DATE:
				
				case EXTEND_DATETIME:
					for(FormSearchFieldBaseBo bo:fieldList){
						FormSearchFieldDateVo dateVo = (FormSearchFieldDateVo) bo;
						showFieldName = dateVo.getValue();
						Map yzxxMap = dateVo.getDateTimeYzxxValue();
						if(yzxxMap != null){
							List<SelectedDateVo> dateVoList = (List<SelectedDateVo>) yzxxMap.get("rightArray");
							if(Strings.isNotEmpty(dateVoList)){
								for(int i=0;i<dateVoList.size();i++){
									SelectedDateVo selected = dateVoList.get(i);
									String checkedStyle = null;
									if("1".equals(dateVo.getDefaultCheckFirst()) && i == 0){
										checkedStyle = " checked = checked";
									}
									valHtml += "<label class=\"condition-lable\" for=\""+selected.getName()+"\"><input type=\"checkbox\" name=\""+dateVo.getKey()+"\" id=\""+selected.getName()+"\" "+checkedStyle+"\" value=\""+selected.getValue()+"\"/><span>"+selected.getName()+"</span></label>";
								}
								//添加固定时间选择控件段
								String time = "<div class=\"condition-lable\" style= \"display:inline \"><label class=\"condition-lable\">"
								+"<input id=\""+key+"_startTime\" type=\"text\"  class=\"comp\" comp=\"type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,cache:false,isClear:true,clearBlank:false\"/>"
								+"</label><label class=\"condition-lable\"><span>-</span></label>"
								+ "<label class=\"condition-lable\"><input id=\""+key+"_endTime\" type=\"text\"  class=\"comp\" comp=\"type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,cache:false,isClear:true,clearBlank:false\"/></label></div>";
								valHtml +=time;
								isAppendHtml = true;
							}
						}
					}
					break;
				default:
					break;
			}

			if(isAppendHtml){
				resultHtml.put(showFieldName, valHtml);
    		}
    	}
    	return resultHtml;
    }
    @Override
    public List<FormSearchFieldVO> findUnfolwFormSearchFieldVOs(Long formId, Long formTemplateId)
    		throws BusinessException {
    	List<FormSearchFieldVO> formSearchFieldList = new ArrayList<FormSearchFieldVO>();
		FormBean formBean = formCacheManager.getForm(formId);
		FormBindAuthBean bindAuthBean = formBean.getBind().getFormBindAuthBean(String.valueOf(formTemplateId));
        if (bindAuthBean != null) {
            if (!bindAuthBean.checkRight(AppContext.currentUserId())) {
                throw new BusinessException(ResourceUtil.getString("form.showAppFormData.noright"));
            }
            List<SimpleObjectBean> searchFields = bindAuthBean.getSearchFieldList();
            FormFieldBean field = null;
        	for(SimpleObjectBean sob:searchFields){
        		//===start 下面的逻辑 参照 DynamicFieldUtil.getSearchField(searchFields, formBean)
        		String fieldName = sob.getName();
        		String display = sob.getValue();
                int index1 = display.indexOf("(");
                if (index1 != -1) {
                    display = display.substring(index1 + 1);
                }
                int index2 = display.indexOf(")");
                if (index2 != -1) {
                    display = display.substring(0, index2);
                }
                if (fieldName.indexOf(".") > -1) {
                    String[] strs = fieldName.split("[.]");
                    fieldName = strs[1];
                    field = formBean.getFieldBeanByName(fieldName);
                    if (field == null || field.getInputTypeEnum() == null) {
                        MasterTableField mtf = MasterTableField.getEnumByKey(strs[1]);
                        if (mtf != null) {
                            field = mtf.getFormFieldBean();
                        } else {
                            continue;
                        }
                    }
                    if (field.getInputTypeEnum().isMultiOrg() && field.getFinalFieldType().equals(FieldType.LONGTEXT.getKey())) {
                        continue;
                    }
                    if (field.getInputTypeEnum() == FormFieldComEnum.MAP_MARKED || field.getInputTypeEnum() == FormFieldComEnum.MAP_LOCATE || field.getInputTypeEnum() == FormFieldComEnum.MAP_PHOTO) {
                        continue;
                    }
                } else {
                    MasterTableField mtf = MasterTableField.getEnumByKey(fieldName);
                    if (mtf != null) {
                        field = mtf.getFormFieldBean();
                    } else {
                        continue;
                    }
                }
                //=====end
                FormSearchFieldBaseBo fieldBase = this.getSearchFeildBase(sob,field);
                if(!"1".equals(fieldBase.getTreeShow())){
                	FormSearchFieldVO searchFieldVo = new FormSearchFieldVO(fieldName,sob.getValue(),display);
                	String finalInputType = field.getFinalInputType(true);
                	//创建时间和修改时间使用日期类型查询
                	if(MasterTableField.start_date.getKey().equals(field.getName())
                			|| MasterTableField.modify_date.getKey().equals(field.getName())){
                		finalInputType = FormFieldComEnum.EXTEND_DATE.getKey();
                	}
                    if("exchangetask".equals(field.getInputType()) || "querytask".equals(field.getInputType())){
                        if("DECIMAL".equals(field.getFieldType()) || "VARCHAR".equals(field.getFieldType())){
                            finalInputType = "text";
                        }else if("TIMESTAMP".equals(field.getFieldType())){
                            finalInputType = "date";
                        }else if("DATETIME".equals(field.getFieldType())){
                            finalInputType = "datetime";
                        }
                    }
                	searchFieldVo.setFinalInputType(finalInputType);
                	searchFieldVo.setExternalType(field.findRealFieldBean().getExternalType());
                	searchFieldVo.setFieldBase(fieldBase);
                	searchFieldVo.setFieldType(field.getFinalFieldType());
                    searchFieldVo.setDigitNum(field.getDigitNum());
                	formSearchFieldList.add(searchFieldVo);
                }
        	}
        }
        
    	return formSearchFieldList;
    }

	/**
	 * 根据自定义查询设置，获取查询对象
	 * @param sob
	 * @param fieldBean
	 * @return 
	 * @throws BusinessException
	 */
	private FormSearchFieldBaseBo getSearchFeildBase(SimpleObjectBean sob, FormFieldBean fieldBean) throws BusinessException {
		FormSearchFieldBaseBo fieldBo = new FormSearchFieldBaseBo(sob.getName(),sob.getValue());
		
		String extraJson = sob.getExtAttr(ExtMap.DefaultValJSON.getKey());
		boolean noSet = Strings.isBlank(extraJson);//有自定义查询设置
		
		FormFieldComEnum fieldComEnum = FormFieldComEnum.getEnumByKey(fieldBean.getFinalInputType(true));
		switch (fieldComEnum) {
		case SELECT:
		case RADIO:
			fieldBean = fieldBean.findRealFieldBean();//OA-117724
			FormSearchFieldEnumVo fieldBoEnum = noSet ? new FormSearchFieldEnumVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldEnumVo.class);
			List<CtpEnumItem> enumList = findEnumListByField(fieldBean);
			if(enumList.size() > 100){//TODO OA-122792 枚举值≤100还是使用现平铺方式
				fieldBoEnum.setShowCheckbox("0");
				fieldBoEnum.setFormId(fieldBean.findFormTableBean().getFormId().toString());
			}else{
				fieldBoEnum.setShowCheckbox("1");
				List<ShowCheckboxVo> enumCheckbox = new ArrayList<ShowCheckboxVo>();
				for(CtpEnumItem item:enumList){
					if(null != item.getOutputSwitch() && item.getOutputSwitch().intValue() == 0) {
                		continue;
                	}
					enumCheckbox.add(new ShowCheckboxVo(item.getShowvalue(),item.getId().toString()));
				}
				fieldBoEnum.setCheckboxList(enumCheckbox);
			}
			fieldBo = fieldBoEnum;
			break;
		case CHECKBOX:
			fieldBo = noSet ? fieldBo : JSONUtil.parseJSONString(extraJson, FormSearchFieldCheckboxVo.class);
			break;
		case EXTEND_DATE:
		case EXTEND_DATETIME:
			FormSearchFieldDateVo fieldBoDate = noSet ? new FormSearchFieldDateVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldDateVo.class);
			List<ShowCheckboxVo> dateCheckbox = new ArrayList<ShowCheckboxVo>();
			Map yzxxMap = fieldBoDate.getDateTimeYzxxValue();
			if(yzxxMap != null){
				List<SelectedDateVo> dateVoList = (List<SelectedDateVo>) yzxxMap.get("rightArray");
				if(Strings.isNotEmpty(dateVoList)){
					for(int i=0;i<dateVoList.size();i++){
						SelectedDateVo selected = dateVoList.get(i);
						dateCheckbox.add(new ShowCheckboxVo(selected.getName(),selected.getValue()));
					}
				}
			}else{
				dateCheckbox.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_today.getI18n()),DateTime4CustomSelect.date_today.getKey()));
				dateCheckbox.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_thisWeek.getI18n()),DateTime4CustomSelect.date_thisWeek.getKey()));
				dateCheckbox.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_thisMonth.getI18n()),DateTime4CustomSelect.date_thisMonth.getKey()));
				dateCheckbox.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_thisyear.getI18n()),DateTime4CustomSelect.date_thisyear.getKey()));
			}
			fieldBoDate.setCheckboxList(dateCheckbox);
			fieldBo = fieldBoDate;
			break;
        case EXTEND_EXCHANGETASK:
        case EXTEND_QUERYTASK:
            if("TIMESTAMP".equals(fieldBean.getFieldType()) || "DATETIME".equals(fieldBean.getFieldType())){
                FormSearchFieldDateVo fieldBoDateQ = noSet ? new FormSearchFieldDateVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldDateVo.class);
                List<ShowCheckboxVo> dateCheckboxQ= new ArrayList<ShowCheckboxVo>();
                Map yzxxMapQ = fieldBoDateQ.getDateTimeYzxxValue();
                if(yzxxMapQ != null){
                    List<SelectedDateVo> dateVoList = (List<SelectedDateVo>) yzxxMapQ.get("rightArray");
                    if(Strings.isNotEmpty(dateVoList)){
                        for(int i=0;i<dateVoList.size();i++){
                            SelectedDateVo selected = dateVoList.get(i);
                            dateCheckboxQ.add(new ShowCheckboxVo(selected.getName(),selected.getValue()));
                        }
                    }
                }else{
                    dateCheckboxQ.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_today.getI18n()),DateTime4CustomSelect.date_today.getKey()));
                    dateCheckboxQ.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_thisWeek.getI18n()),DateTime4CustomSelect.date_thisWeek.getKey()));
                    dateCheckboxQ.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_thisMonth.getI18n()),DateTime4CustomSelect.date_thisMonth.getKey()));
                    dateCheckboxQ.add(new ShowCheckboxVo(ResourceUtil.getString(DateTime4CustomSelect.date_thisyear.getI18n()),DateTime4CustomSelect.date_thisyear.getKey()));
                }
                fieldBoDateQ.setCheckboxList(dateCheckboxQ);
                fieldBo = fieldBoDateQ;
            }
            if("VARCHAR".equals(fieldBean.getFieldType()) || "DECIMAL".equals(fieldBean.getFieldType())){
                fieldBo = noSet ? fieldBo : JSONUtil.parseJSONString(extraJson, FormSearchFieldBaseBo.class);
                FormulaVar enumTextVar = FormulaVar.getEnumByKey(fieldBo.getDefaultVal());
                if(null != enumTextVar){
                    fieldBo.setDefaultVal(enumTextVar.getValue());
                }
            }

            break;
		case TEXT:
		case TEXTAREA:
		case LABLE:
			fieldBo = noSet ? fieldBo : JSONUtil.parseJSONString(extraJson, FormSearchFieldBaseBo.class);
			FormulaVar enumTextVar = FormulaVar.getEnumByKey(fieldBo.getDefaultVal());
			if(null != enumTextVar){
				fieldBo.setDefaultVal(enumTextVar.getValue());
			}
			break;
		case EXTEND_ACCOUNT:
		case EXTEND_MULTI_ACCOUNT:
			FormSearchFieldDeptVo fieldBoAccount = noSet ? new FormSearchFieldDeptVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldDeptVo.class);
			FormulaVar enumAccVar = FormulaVar.getEnumByKey(fieldBoAccount.getDefaultVal());
			if(null == enumAccVar){
				fieldBoAccount.setHandOrgIds(FormSearchUtil.showOrgEntities(fieldBoAccount.getHandOrgIds(), "Account"));
			}else{
				fieldBoAccount.setDefaultVal(OrgHelper.showOrgEntities(enumAccVar.getValue(), "Account", ","));
				fieldBoAccount.setHandOrgIds(FormSearchUtil.showOrgEntities(enumAccVar.getValue(), "Account"));
			}
			fieldBo = fieldBoAccount;
			break;
		case EXTEND_DEPARTMENT:
			FormSearchFieldDeptVo fieldBoDep = noSet ? new FormSearchFieldDeptVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldDeptVo.class);
			SystemVar4CustomSelect enumDepVar = SystemVar4CustomSelect.getEnumByKey(fieldBoDep.getDefaultVal());
			if(null == enumDepVar){
                String defaultVal = fieldBoDep.getDefaultVal();
                if (FormulaVar.org_currentUserExternalDepartmentId.getKey().equals(defaultVal)) {
                    String orgIds = FormulaVar.org_currentUserExternalDepartmentId.getValue();
                    fieldBoDep.setDefaultVal(OrgHelper.showOrgEntities(orgIds, "Department", ","));
                    fieldBoDep.setHandOrgIds(FormSearchUtil.showOrgEntities(orgIds, "Department"));
                } else if (FormulaVar.org_currentUserExternalSuperiorDepartmentId.getKey().equals(defaultVal)) {
                    String orgIds = FormulaVar.org_currentUserExternalSuperiorDepartmentId.getValue();
                    fieldBoDep.setDefaultVal(OrgHelper.showOrgEntities(orgIds, "Department", ","));
                    fieldBoDep.setHandOrgIds(FormSearchUtil.showOrgEntities(orgIds, "Department"));
                } else {
                    fieldBoDep.setHandOrgIds(FormSearchUtil.showOrgEntities(fieldBoDep.getHandOrgIds(), "Department"));
                }
			}else{
				String valIds = enumDepVar.getIdValue();
				String defaultVal = "",orgIds = "";
				if(SystemVar4CustomSelect.org_currentUserDepartmentId == enumDepVar
						|| SystemVar4CustomSelect.org_currentUserSuperiorDeptId == enumDepVar
						|| SystemVar4CustomSelect.org_currentUserJZDeptId == enumDepVar){//不包含子部门情况
					defaultVal = FormSearchUtil.showOrgNoChildDepName(valIds, "Department");
					orgIds = FormSearchUtil.showOrgNoChildDepEntities(valIds, "Department");
				}else{
					defaultVal = OrgHelper.showOrgEntities(valIds, "Department", ",");
					orgIds = FormSearchUtil.showOrgEntities(valIds, "Department");
				}
				fieldBoDep.setDefaultVal(defaultVal);
				fieldBoDep.setHandOrgIds(orgIds);
			}
			fieldBo = fieldBoDep;
			break;
		case EXTEND_MULTI_DEPARTMENT:
			FormSearchFieldDeptVo fieldBoDepartment = noSet ? new FormSearchFieldDeptVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldDeptVo.class);
			SystemVar4CustomSelect enumDepVar1 = SystemVar4CustomSelect.getEnumByKey(fieldBoDepartment.getDefaultVal());
			if(null == enumDepVar1){
				fieldBoDepartment.setHandOrgIds(FormSearchUtil.showOrgEntities(fieldBoDepartment.getHandOrgIds(), "Department"));
			}else{
				fieldBoDepartment.setDefaultVal( OrgHelper.showOrgEntities(enumDepVar1.getIdValue(), "Department", ","));
				fieldBoDepartment.setHandOrgIds( FormSearchUtil.showOrgEntities(enumDepVar1.getIdValue(), "Department"));
			}
			fieldBo = fieldBoDepartment;
			break;
		case EXTEND_MEMBER:
		case EXTEND_MULTI_MEMBER:
			FormSearchFieldDeptVo fieldBoMember = noSet ? new FormSearchFieldDeptVo(sob.getName(),sob.getValue()) : JSONUtil.parseJSONString(extraJson, FormSearchFieldDeptVo.class);
			String defaultVal = fieldBoMember.getDefaultVal();
			String value = "";
			if(FormulaVar.org_currentUserId.getKey().equals(defaultVal)){
				value = FormulaVar.org_currentUserId.getValue();
			}else if(SystemVar4CustomSelect.org_currentUserDeptManagerId.getKey().equals(defaultVal)){
				value = SystemVar4CustomSelect.org_currentUserDeptManagerId.getIdValue();
			}else if(SystemVar4CustomSelect.org_currentUserSuperiorDeptManagerId.getKey().equals(defaultVal)){
				value = SystemVar4CustomSelect.org_currentUserSuperiorDeptManagerId.getIdValue();
			}else{
				value = fieldBoMember.getHandOrgIds();
			}
			
			fieldBoMember.setDefaultVal(OrgHelper.showOrgEntities(value, "Member", ","));
			fieldBoMember.setHandOrgIds(FormSearchUtil.showOrgEntities(value, "Member"));
			fieldBo = fieldBoMember;
			break;
		default:
			fieldBo = noSet ? fieldBo : JSONUtil.parseJSONString(extraJson, FormSearchFieldBaseBo.class);
			break;
		}
		fieldBo.setInputType(fieldBean.getFinalInputType(true));
		return fieldBo;
	}

	@Override
	public FlipInfo getFormMasterDataListBySearch(FlipInfo flipInfo, Map<String, Object> params,boolean forExport)
			throws BusinessException, SQLException {
//		FlipInfo fi = this.getFormMasterDataListByFormId(flipInfo, params);
		
		Long formId = Long.parseLong(params.get("formId") + "");
        FormBean formBean = formCacheManager.getForm(formId.longValue());
        String templateIdStr = String.valueOf(params.get("formTemplateId"));
        String auth = FormUtil.getUnflowFormAuth(formBean, templateIdStr);
//        flipInfo = this.getFormDataList(flipInfo, params, formBean, false);
        Long currentUserId = AppContext.currentUserId();
        boolean isNeedPage = true;
        FormQueryTypeEnum queryType = FormQueryTypeEnum.infoManageQuery;
//        FormQueryWhereClause customCondition = getCustomConditionFormQueryWhereClause(formBean, params);
        FormQueryWhereClause customCondition = FormSearchUtil.getCustomConditionFormQueryWhereClause(formBean, params);
        //M3无流程支持自定义排序20170214
        List<Map<String, Object>> customOrderBy = (List<Map<String,Object>>)params.get("userOrderBy");
        String[] customShowFields = new String[]{};

        FormQueryWhereClause relationSqlWhereClause = getRelationConditionFormQueryWhereClause(formBean, params);
        Long templeteId = Long.parseLong(Strings.isBlank(String.valueOf(params.get("formTemplateId") == null ? "" : params.get("formTemplateId"))) ? "0" : params.get("formTemplateId") + "");
        FormQueryResult queryResult = getFormQueryResult(currentUserId, flipInfo, isNeedPage, formBean, templeteId, queryType,
                customCondition, customOrderBy, customShowFields, relationSqlWhereClause, false);
        
        //处理组织机构等id类型数据，这样列表里面显示出来的是显示值，如人员id对应应该显示人员姓名
        //OA-62881  表单信息管理和基础数据列表中隐藏字段显示了  调用查询已经实现的接口完成
        FormUtil.setShowValueList(formBean, auth, flipInfo.getData(), forExport, true);
        
		return queryResult.getFlipInfo();
	}
    @Override
    public FlipInfo getFormMasterDataList(FlipInfo flipInfo, Map<String, Object> params)
            throws BusinessException, SQLException {
        return this.getFormMasterDataList(flipInfo,params,false);
    }
	@Override
	public FlipInfo getFormMasterDataList(FlipInfo flipInfo, Map<String, Object> params,boolean forExport)
			throws BusinessException, SQLException {
		String queryType = ParamUtil.getString(params, "queryType", "baseSearch");
		params.remove("queryType");
		FlipInfo fi = null;
		if("baseSearch".equals(queryType)){
			fi = this.getFormMasterDataListBySearch(flipInfo,params,forExport);
		}else if("highSearch".equals(queryType)){
			fi = this.getFormMasterDataListByFormId(flipInfo, params,forExport);
		}
		return fi;
	}
	@Override
	public List<WebV3xOrgAccount> getAccountTree(Map<String, Object> params) throws BusinessException{
        List<V3xOrgAccount> orgAccounts =  orgManager.accessableAccounts(AppContext.getCurrentUser().getId());
        Collections.sort(orgAccounts, CompareSortEntity.getInstance());
        List<WebV3xOrgAccount> treeResult = new ArrayList<WebV3xOrgAccount>();
        
        Map<String, V3xOrgAccount> path2AccountMap = new HashMap<String, V3xOrgAccount>();
        for (V3xOrgAccount a : orgAccounts) {
            path2AccountMap.put(a.getPath(), a);
        }
        
        Map<Long, Long> accId2parentAcc = new HashMap<Long, Long>();
        Set<Long> accHaschild = new HashSet<Long>();
        for (V3xOrgAccount a : orgAccounts) {
            String path = a.getPath();
            if(Strings.isNotBlank(path)) {
                if(path.length() > 4){
                    String parentpath = path.substring(0, path.length() - 4);
                    V3xOrgAccount t = path2AccountMap.get(parentpath);
                    if(t != null){
                        accId2parentAcc.put(a.getId(), t.getId());
                        accHaschild.add(t.getId());
                    }
                }
            }
        }
        
        for (V3xOrgAccount a : orgAccounts) {
            Long parentId = accId2parentAcc.get(a.getId())==null?Long.valueOf(-1):accId2parentAcc.get(a.getId());
            WebV3xOrgAccount treeAccount = new WebV3xOrgAccount(a.getId(), a.getName(), parentId);
            //treeAccount.setV3xOrgAccount(a);
            treeAccount.setLevel(new Long(a.getPath().length()/4));
            treeAccount.setShortName(a.getShortName());
            //处理zTree上的图标问题
            treeAccount.setIconSkin("account");
            if(accHaschild.contains(a.getId())) {
                treeAccount.setIconSkin("treeAccount");
            }
            treeResult.add(treeAccount);
        }
        return treeResult;
	}
	
	@Override
	public List<CtpEnumItem> findEnumListByField(FormFieldBean fieldBean) throws BusinessException {
		List<CtpEnumItem> enumList = null;
		if(FormFieldComEnum.OUTWRITE.getKey().equals(fieldBean.getFinalInputType())){
			if(fieldBean.isFormatEnumIsFinalChild()){
				enumList = enumManagerNew.getLastCtpEnumItem(fieldBean.getFormatEnumId());
			}else{
				enumList = enumManagerNew.getCtpEnumItem(fieldBean.getFormatEnumId(), fieldBean.getFormatEnumLevel());
			}
		}else{
			if(fieldBean.getIsFinalChild()){
				enumList = enumManagerNew.getLastCtpEnumItem(fieldBean.getEnumId());
			}else{
				enumList = enumManagerNew.getCtpEnumItem(fieldBean.getEnumId(), fieldBean.getEnumLevel());
			}
		}
		return enumList;
	}
	
	   
    @Override
	public boolean switchTemplate(String formId, String reference, String subReference,
			String fileId, String newTemplateName) {

		try{
			List<Attachment> attachmentList = attachmentManager.getByReference(Long.valueOf(reference), Long.valueOf(subReference));
			if (attachmentList == null || attachmentList.size() == 0){
				return false;
			}
			Attachment curAttachment = null;
			for(Attachment attachment : attachmentList){
				
				if (attachment.getFileUrl().longValue() == Long.valueOf(fileId).longValue()){
					curAttachment = attachment;
					break;
				}
			}
			if (curAttachment == null){
				return false;
			}

			Long attachmentFileId = curAttachment.getFileUrl();
			V3XFile currMainFile = fileManager.getV3XFile(attachmentFileId);
			if(currMainFile == null || currMainFile.getFilename().equalsIgnoreCase(newTemplateName)){
				return false; // 模板名相同，可以认为新模板与当前应用模板是一个模板，不作切换。
			}
			// 指定表单的所有模板附件
			List<Attachment> templateAttachmentList = attachmentManager.getByReference(Long.valueOf(formId));
			Attachment newTemplateAttachment = null;
			for(Attachment templateAttachment : templateAttachmentList){
				if (!templateAttachment.getFilename().equalsIgnoreCase(newTemplateName)){
					continue;
				}
				
				if (newTemplateAttachment == null || 
					newTemplateAttachment.getCreatedate().compareTo(templateAttachment.getCreatedate()) < 0){
					newTemplateAttachment = templateAttachment;
				}
			}
			
			if (newTemplateAttachment == null){
				return false; // 新模板不存在
			}
			
			Long newTemplateAttachmentFileId = newTemplateAttachment.getFileUrl();
			V3XFile newTemplateFile = fileManager.getV3XFile(newTemplateAttachmentFileId);
			String attFolder = fileManager.getFolder(newTemplateFile == null ? newTemplateAttachment.getCreatedate() : newTemplateFile.getCreateDate(), true);
			String curAttFolder = fileManager.getFolder(currMainFile.getCreateDate(), true);
			FileUtils.copyFile(new File(attFolder, String.valueOf(newTemplateAttachmentFileId)), new File(curAttFolder, fileId));
			
			currMainFile.setFilename(newTemplateFile.getFilename());
			fileManager.update(currMainFile);
		
		}catch (Exception e){
			return false;
		}

		return true;
	}
}
