//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.form.modules.engin.relation;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.enums.ColQueryCondition;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.vo.ColSummaryVO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormAuthViewFieldBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean;
import com.seeyon.ctp.form.bean.FormDataBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFormulaBean;
import com.seeyon.ctp.form.bean.FormQueryWhereClause;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.bean.FormTriggerActionBean;
import com.seeyon.ctp.form.bean.FormTriggerBean;
import com.seeyon.ctp.form.bean.FormTriggerConditionBean;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FieldRelationObj;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.bean.FormTriggerBean.ConditionType;
import com.seeyon.ctp.form.bean.FormTriggerBean.ParamType;
import com.seeyon.ctp.form.bean.FormTriggerBean.TriggerConditionState;
import com.seeyon.ctp.form.bean.FormTriggerBean.TriggerType;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataDAO;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.SystemDataField;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.DepartmentViewAttrValue;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.MapViewAttrValue;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ProjectViewAttrValue;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.RelationAuthSourceType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ToRelationAttrType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ViewAttrValue;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ViewSelectType;
import com.seeyon.ctp.form.po.CtpTemplateRelationAuth;
import com.seeyon.ctp.form.po.FormRelation;
import com.seeyon.ctp.form.po.FormRelationAuthority;
import com.seeyon.ctp.form.po.FormRelationRecord;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.form.util.SelectPersonOperation;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FieldType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormModuleAuthOrgType;
import com.seeyon.ctp.form.util.Enums.FormStateEnum;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.FormUseFlagEnum;
import com.seeyon.ctp.form.util.Enums.MasterTableField;
import com.seeyon.ctp.form.util.Enums.RelationDataCreatType;
import com.seeyon.ctp.form.util.Enums.SubTableField;
import com.seeyon.ctp.form.vo.FormRelationTableVO;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.workflow.manager.ProcessTemplateManager;
import com.seeyon.ctp.workflow.po.ProcessTemplete;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentMap;
import org.apache.commons.logging.Log;
import www.seeyon.com.utils.UUIDUtil;

public class FormRelationManagerImpl implements FormRelationManager {
    private static final Log LOGGER = CtpLogFactory.getLog(FormRelationManagerImpl.class);
    private FormRelationDAO formRelationDAO;
    private FormRelationRecordDAO formRelationRecordDAO;
    private FormCacheManager formCacheManager;
    private FormDataManager formDataManager;
    private FormDataDAO formDataDAO;
    private FormManager formManager;
    private TemplateManager templateManager;
    private WorkflowApiManager wapi;
    private OrgManager orgManager;
    private EnumManager enumManagerNew;
    private AttachmentManager attachmentManager;
    private CollaborationApi collaborationApi;

    public FormRelationManagerImpl() {
    }

    public AttachmentManager getAttachmentManager() {
        return this.attachmentManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public Map<String, Object> getAuthById4Edit(long authId) throws BusinessException {
        return null;
    }

    public List<FormRelation> getFieldBeanRelations(FormFieldBean fieldBean, FormBean form, ToRelationAttrType toRelationAttrType) {
        List<FormRelation> list = form.getRelationList();
        List<FormRelation> resultList = new ArrayList();
        if(list.size() > 0) {
            Iterator var6 = list.iterator();

            while(var6.hasNext()) {
                FormRelation relation = (FormRelation)var6.next();
                if(relation.getToRelationAttrType().intValue() == toRelationAttrType.getKey()) {
                    if(relation.getToRelationAttr().equals(fieldBean.getName())) {
                        resultList.add(relation);
                    }

                    if(relation.getFromRelationAttr().equals(fieldBean.getName()) && !resultList.contains(relation)) {
                        resultList.add(relation);
                    }
                }
            }
        }

        return resultList;
    }

    public List<FormRelation> getFormRelations(FormFieldBean fieldBean, FormBean form) {
        List<FormRelation> list = form.getRelationList();
        List<FormRelation> resultList = new ArrayList();
        Iterator var5 = list.iterator();

        while(true) {
            while(var5.hasNext()) {
                FormRelation relation = (FormRelation)var5.next();
                if(relation.getToRelationAttrType().intValue() != ToRelationAttrType.form_relation_field.getKey() && relation.getToRelationAttrType().intValue() != ToRelationAttrType.form_relation_flow.getKey() && relation.getToRelationAttrType().intValue() != ToRelationAttrType.form_relation_formContent.getKey()) {
                    if(relation.getToRelationAttrType().intValue() == ToRelationAttrType.data_relation_field.getKey() && fieldBean.getName().equals(relation.getToRelationAttr())) {
                        resultList.add(relation);
                    }
                } else if(fieldBean.getName().equals(relation.getFromRelationAttr())) {
                    resultList.add(relation);
                }
            }

            return resultList;
        }
    }

    public Map<String, FormRelationRecord> getFormRelationMap(Long fromMasterDataId) throws BusinessException {
        List<FormRelationRecord> relationRecordList = this.formRelationRecordDAO.selectRecordByFormMasterDataId(fromMasterDataId);
        Map<String, FormRelationRecord> relationRecordMap = new HashMap();
        Iterator var4 = relationRecordList.iterator();

        while(var4.hasNext()) {
            FormRelationRecord record = (FormRelationRecord)var4.next();
            relationRecordMap.put(record.getFromMasterDataId() + "_" + record.getFieldName() + "_" + record.getFromSubdataId(), record);
        }

        return relationRecordMap;
    }

    public List<FormRelationRecord> getRecordByToMasterId(long toMasterDataId) throws BusinessException {
        List<FormRelationRecord> relationRecordList = this.formRelationRecordDAO.selectRecordByToMasterDataId(Long.valueOf(toMasterDataId));
        return relationRecordList;
    }

    public void updateRelationRecord(FormDataMasterBean data) {
        Map<String, FormRelationRecord> recordMap = data.getFormRelationRecordMap();
        if(recordMap != null) {
            this.formRelationRecordDAO.deleteByFromFormMasterDataId(data.getId());
            List<FormRelationRecord> recordList = new ArrayList();
            Iterator var4 = recordMap.entrySet().iterator();

            while(var4.hasNext()) {
                Entry<String, FormRelationRecord> entry = (Entry)var4.next();
                FormRelationRecord oldRecord = (FormRelationRecord)entry.getValue();
                FormRelationRecord newRecord = new FormRelationRecord();
                newRecord.setId(Long.valueOf(UUIDUtil.getUUIDLong()));
                newRecord.setFromMasterDataId(data.getId());
                newRecord.setToMasterDataId(oldRecord.getToMasterDataId());
                newRecord.setFromFormId(oldRecord.getFromFormId());
                newRecord.setToFormId(oldRecord.getToFormId());
                newRecord.setFromSubdataId(oldRecord.getFromSubdataId());
                newRecord.setToSubdataId(oldRecord.getToSubdataId());
                newRecord.setState(oldRecord.getState());
                newRecord.setFieldName(oldRecord.getFieldName());
                newRecord.setFormType(oldRecord.getFormType());
                newRecord.setType(oldRecord.getType());
                newRecord.setMemberId(oldRecord.getMemberId());
                recordList.add(newRecord);
            }

            DBAgent.evict(recordList);
            this.formRelationRecordDAO.insertList(recordList);
        }

    }

    public String getRelationAuthorityBySummaryId(Map<String, Object> param) {
        String moduleId = String.valueOf(param.get("moduleId"));
        String moduleType = String.valueOf(param.get("moduleType"));
        DataContainer dc = new DataContainer();
        StringBuffer text = new StringBuffer("");
        StringBuffer value = new StringBuffer("");

        try {
            Long mId = Long.valueOf(Long.parseLong(moduleId));
            Integer mType = Integer.valueOf(Integer.parseInt(moduleType));
            Map<String, Object> params = new HashMap();
            params.put("moduleId", mId);
            params.put("moduleType", mType);
            params.put("authSourceType", Integer.valueOf(RelationAuthSourceType.sourceTemplateSet.getKey()));
            List<FormRelationAuthority> colRelationAuthoritys = DBAgent.find(" from FormRelationAuthority c where c.moduleId=:moduleId and c.moduleType=:moduleType and c.authSourceType <>:authSourceType", params);
            OrgManager extendMultiMemberOrgManager = (OrgManager)AppContext.getBean("orgManager");

            for(int i = 0; i < colRelationAuthoritys.size(); ++i) {
                FormRelationAuthority colRelationAuthority = (FormRelationAuthority)colRelationAuthoritys.get(i);
                String tempName = SelectPersonOperation.getNameByTypeIdAndUserId(colRelationAuthority.getUserType().intValue(), colRelationAuthority.getUserId());
                text.append(tempName);
                String userType = SelectPersonOperation.getTypeByTypeId(colRelationAuthority.getUserType().intValue());
                value.append(userType).append("|").append(colRelationAuthority.getUserId());
                if(i != colRelationAuthoritys.size() - 1) {
                    text.append("、");
                    value.append(",");
                }
            }

            dc.put("success", "true");
            DataContainer oldSelect = new DataContainer();
            oldSelect.put("text", text.toString());
            oldSelect.put("value", value.toString());
            dc.put("oldSelect", oldSelect);
        } catch (Exception var16) {
            dc.put("success", "false");
            dc.put("errorMsg", StringUtil.toString(var16));
        }

        return dc.getJson();
    }

    public String updateRelationAuthority(Map<String, Object> param) {
        DataContainer dc = new DataContainer();

        try {
            String value = String.valueOf(param.get("value"));
            String moduleIds = String.valueOf(param.get("moduleIds"));
            String moduleType = String.valueOf(param.get("moduleType"));
            Integer mTypei = Integer.valueOf(Integer.parseInt(moduleType));
            String[] moduleIdStrs = moduleIds.split(",");
            List<Long> moduleIdLongs = new ArrayList();

            for(int i = 0; i < moduleIdStrs.length; ++i) {
                moduleIdLongs.add(Long.valueOf(Long.parseLong(moduleIdStrs[i])));
            }

            Map dbParam = new HashMap();
            dbParam.put("moduleIds", moduleIdLongs);
            dbParam.put("authSourceType", Integer.valueOf(RelationAuthSourceType.sourceSendCol.getKey()));
            DBAgent.bulkUpdate("delete FormRelationAuthority c where c.moduleId in (:moduleIds) and c.authSourceType = :authSourceType", dbParam);
            String[][] vals = Strings.getSelectPeopleElements(value);
            List<FormRelationAuthority> colRelationAuthoritys = new ArrayList();
            if(vals != null) {
                List<ColSummary> summaries = this.collaborationApi.findColSummarys(moduleIdLongs);

                for(int i = 0; i < vals.length; ++i) {
                    Iterator var14 = summaries.iterator();

                    while(var14.hasNext()) {
                        ColSummary col = (ColSummary)var14.next();
                        FormRelationAuthority colRelationAuthority = new FormRelationAuthority();
                        colRelationAuthority.setIdIfNew();
                        colRelationAuthority.setModuleId(col.getId());
                        colRelationAuthority.setSummarySubject(col.getSubject());
                        colRelationAuthority.setImportantLevel(col.getImportantLevel().intValue());
                        colRelationAuthority.setFormId(col.getFormAppid());
                        colRelationAuthority.setTemplateId(col.getTempleteId());
                        colRelationAuthority.setSummaryStartMemberId(col.getStartMemberId());
                        colRelationAuthority.setSummaryStartDate(col.getStartDate());
                        colRelationAuthority.setFormDataId(col.getFormRecordid());
                        colRelationAuthority.setSummaryState(col.getState().intValue());
                        colRelationAuthority.setSummaryVouchState(col.getVouch().intValue());
                        colRelationAuthority.setModuleType(mTypei);
                        colRelationAuthority.setUserId(Long.valueOf(Long.parseLong(vals[i][1])));
                        colRelationAuthority.setUserType(Integer.valueOf(SelectPersonOperation.changeType(vals[i][0])));
                        colRelationAuthority.setAuthSourceType(Integer.valueOf(RelationAuthSourceType.sourceSendCol.getKey()));
                        colRelationAuthoritys.add(colRelationAuthority);
                    }
                }
            }

            DBAgent.saveAll(colRelationAuthoritys);
            dc.put("success", "true");
        } catch (Exception var17) {
            dc.put("success", "false");
            dc.put("errorMsg", StringUtil.toString(var17));
        }

        return dc.getJson();
    }

    public List<Long> getMemberColIds(Long member) throws BusinessException {
        String[] orgType = new String[]{FormModuleAuthOrgType.Member.getText(), FormModuleAuthOrgType.Department.getText(), FormModuleAuthOrgType.Level.getText(), FormModuleAuthOrgType.Post.getText(), FormModuleAuthOrgType.Team.getText(), FormModuleAuthOrgType.Account.getText()};
        List<Long> list = this.orgManager.getUserDomainIDs(Long.valueOf(member == null?AppContext.currentUserId():member.longValue()), orgType);
        Map<String, Object> dbParam = new HashMap();
        dbParam.put("userIds", list);
        dbParam.put("authSourceType", Integer.valueOf(RelationAuthSourceType.sourceTemplateSet.getKey()));
        List<Long> colAuths = DBAgent.find("select c.moduleId from FormRelationAuthority c where c.userId in (:userIds) and (c.authSourceType <> :authSourceType or c.authSourceType is null)", dbParam);
        return colAuths;
    }

    public List<Long> getMemberColIds4TemplateSet(Long member) throws BusinessException {
        String[] orgType = new String[]{FormModuleAuthOrgType.Member.getText(), FormModuleAuthOrgType.Department.getText(), FormModuleAuthOrgType.Level.getText(), FormModuleAuthOrgType.Post.getText(), FormModuleAuthOrgType.Team.getText(), FormModuleAuthOrgType.Account.getText()};
        List<Long> list = this.orgManager.getUserDomainIDs(Long.valueOf(member == null?AppContext.currentUserId():member.longValue()), orgType);
        Map<String, Object> dbParam = new HashMap();
        dbParam.put("userIds", list);
        dbParam.put("authSourceType", Integer.valueOf(RelationAuthSourceType.sourceTemplateSet.getKey()));
        List<Long> templateIds = DBAgent.find("select c.moduleId from FormRelationAuthority c where c.userId in (:userIds) and c.authSourceType = :authSourceType", dbParam);
        return templateIds;
    }

    public Map<String, Object> transFormRelation4SysType(Map<String, Object> params, FormDataMasterBean fromFormDataMasterBean) throws BusinessException {
        return this.transFormRelation4SysType(params, fromFormDataMasterBean, false, (Long)null);
    }

    public Map<String, Object> transFormRelation4SysType(Map<String, Object> params, FormDataMasterBean fromFormDataMasterBean, boolean refreshAttr, Long moduleId) throws BusinessException {
        Map<String, Object> resultMap = new DataContainer();
        String relationType = (String)params.get("relationType");
        String currentFieldName = ParamUtil.getString(params, "fieldName");
        boolean needHtml = false;
        String needHtmlStr = ParamUtil.getString(params, "needHtml");
        if(!StringUtil.checkNull(needHtmlStr) && "true".equalsIgnoreCase(needHtmlStr)) {
            needHtml = true;
        }

        Long rightId = ParamUtil.getLong(params, "rightId");
        Object recordId = Long.valueOf(0L);
        if(params.get("recordId") != null && !StringUtil.checkNull(String.valueOf(params.get("recordId"))) && !(params.get("recordId") instanceof List)) {
            recordId = ParamUtil.getLong(params, "recordId", (Long)null);
        } else if(params.get("recordId") != null && params.get("recordId") instanceof List) {
            recordId = params.get("recordId");
        }

        Long fromFormId = ParamUtil.getLong(params, "fromFormId", (Long)null);
        FormBean fromFormBean = this.formCacheManager.getForm(fromFormId.longValue());
        FormFieldBean fieldBean = fromFormBean.getFieldBeanByName(currentFieldName);
        FormAuthViewBean formAuth = null;
        if(fromFormDataMasterBean.getExtraMap().containsKey("viewRight")) {
            formAuth = (FormAuthViewBean)fromFormDataMasterBean.getExtraAttr("viewRight");
        }

        if(formAuth == null) {
            formAuth = fromFormBean.getAuthViewBeanById(rightId);
        }

        FormBean toFormBean = null;
        List<Map> selectArray = (List)params.get("selectArray");
        Long toFormId = ParamUtil.getLong(params, "toFormId");
        toFormBean = this.formCacheManager.getForm(toFormId.longValue());
        Set<DataContainer> datas = new LinkedHashSet();
        List<FormDataMasterBean> toFormDataMasterBeans = null;
        boolean isEmptySelect = false;
        FormDataMasterBean formData;
        String tableName;
        if(selectArray.size() <= 0) {
            toFormDataMasterBeans = new ArrayList();
            formData = FormDataMasterBean.newInstance(toFormBean, (FormAuthViewBean)null);
            isEmptySelect = true;
            ((List)toFormDataMasterBeans).add(formData);
        } else {
            toFormDataMasterBeans = this.formDataManager.findSelectedDataBeans(selectArray, toFormBean, relationType);
            isEmptySelect = false;
            if(((List)toFormDataMasterBeans).size() <= 0) {
                formData = FormDataMasterBean.newInstance(toFormBean, (FormAuthViewBean)null);
                isEmptySelect = true;
                ((List)toFormDataMasterBeans).add(formData);
            }

            Iterator var34 = ((List)toFormDataMasterBeans).iterator();

            while(var34.hasNext()) {
                FormDataMasterBean tempMaster = (FormDataMasterBean)var34.next();
                Iterator var24 = tempMaster.getSubTables().entrySet().iterator();

                while(var24.hasNext()) {
                    Entry<String, List<FormDataSubBean>> subDataMap = (Entry)var24.next();
                    tableName = (String)subDataMap.getKey();
                    if(((List)subDataMap.getValue()).size() == 0) {
                        FormTableBean formTableBean = toFormBean.getTableByTableName(tableName);
                        Map<String, Object> dataMap = new HashMap();
                        FormDataSubBean subData = new FormDataSubBean(dataMap, formTableBean, tempMaster, new boolean[]{true});
                        ((List)subDataMap.getValue()).add(subData);
                    }
                }
            }
        }

        List<FormRelation> list = this.getFormRelations(fieldBean, fromFormBean);
        List<FormRelation> removedList = new ArrayList();
        Map<String, List<FormRelation>> relationGroup = new HashMap();
        Iterator var38 = list.iterator();

        FormRelation relation;
        while(var38.hasNext()) {
            relation = (FormRelation)var38.next();
            FormFieldBean tempField = fromFormBean.getFieldBeanByName(relation.getFromRelationAttr());
            if(!tempField.isMasterField()) {
                if(relationGroup.get(tempField.getOwnerTableName()) == null) {
                    List<FormRelation> tempRelationList = new ArrayList();
                    tempRelationList.add(relation);
                    relationGroup.put(tempField.getOwnerTableName(), tempRelationList);
                } else {
                    ((List)relationGroup.get(tempField.getOwnerTableName())).add(relation);
                }
            }
        }

        var38 = relationGroup.entrySet().iterator();

        Iterator var48;
        while(var38.hasNext()) {
            Entry<String, List<FormRelation>> entry = (Entry)var38.next();
            List<FormRelation> relations = (List)entry.getValue();
            boolean hasFormRelation = false;
            var48 = relations.iterator();

            while(var48.hasNext()) {
                FormRelation tempRelation = (FormRelation)var48.next();
                if(tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_field.getKey()) {
                    removedList.addAll(relations);
                    removedList.remove(tempRelation);
                    hasFormRelation = true;
                    break;
                }
            }

            if(!hasFormRelation) {
                removedList.addAll(relations);
                removedList.remove(relations.get(0));
            }
        }

        list.removeAll(removedList);
        resultMap.put("relationGroups", relationGroup);
        resultMap.put("isEmptySelect", Boolean.valueOf(isEmptySelect));
        var38 = list.iterator();

        while(var38.hasNext()) {
            relation = (FormRelation)var38.next();
            this.transFormFieldRelation(recordId, formAuth, fromFormBean, relation.getFromRelationAttr(), (List)toFormDataMasterBeans, fromFormDataMasterBean, resultMap, datas, refreshAttr, moduleId, needHtml);
        }

        resultMap.remove("relationGroups");
        resultMap.remove("isEmptySelect");
        List<DataContainer> threadResultDatas = (List)AppContext.getThreadContext("resultDatas");
        tableName = null;
        Object tempList;
        if(threadResultDatas != null) {
            tempList = threadResultDatas;
        } else {
            tempList = new ArrayList();
        }

        DataContainer d;
        DataContainer d1;
        for(Iterator it = datas.iterator(); it.hasNext(); ((List)tempList).add(((List)tempList).size(), d)) {
            d = (DataContainer)it.next();
            var48 = ((List)tempList).iterator();

            while(var48.hasNext()) {
                d1 = (DataContainer)var48.next();
                if(String.valueOf(d.get("recordId")).equals(String.valueOf(d1.get("recordId")))) {
                    d.putAll(d1);
                    break;
                }
            }
        }

        if(tempList != null && !((List)tempList).isEmpty()) {
            List<DataContainer> dcList = (List)resultMap.get("datas");
            if(dcList != null && !dcList.isEmpty()) {
                var48 = ((List)tempList).iterator();

                while(var48.hasNext()) {
                    d1 = (DataContainer)var48.next();
                    boolean hasInTag = false;
                    Iterator var32 = dcList.iterator();

                    while(var32.hasNext()) {
                        DataContainer d2 = (DataContainer)var32.next();
                        if(String.valueOf(d1.get("recordId")).equalsIgnoreCase(String.valueOf(d2.get("recordId")))) {
                            hasInTag = true;
                            d2.putAll(d1);
                            break;
                        }
                    }

                    if(!hasInTag) {
                        dcList.add(d1);
                    }
                }
            } else {
                resultMap.put("datas", tempList);
            }
        }

        if(FormUtil.isH5()) {
            FormUtil.putInfoToThreadContent(fromFormDataMasterBean, fromFormBean, formAuth);
        }

        return resultMap;
    }

    public String transFormRelation(Map<String, Object> params) {
        DataContainer dc = new DataContainer();

        try {
            params.put("relationType", "user");
            List<Map> selectArray = (List)params.get("selectArray");
            Long toFormId = ParamUtil.getLong(params, "toFormId");
            FormBean toFormBean = this.formCacheManager.getForm(toFormId.longValue());
            List<FormTableBean> subTableBeans = toFormBean.getSubTableBean();

            for(int i = 0; i < selectArray.size(); ++i) {
                List<Map> subDataParam = (List)((Map)selectArray.get(i)).get("subData");
                if(subDataParam.size() <= 0) {
                    Iterator var9 = subTableBeans.iterator();

                    while(var9.hasNext()) {
                        FormTableBean formTable = (FormTableBean)var9.next();
                        Map tempMap = new HashMap();
                        tempMap.put("tableName", formTable.getTableName());
                        subDataParam.add(tempMap);
                    }
                }
            }

            Long fromDataId = ParamUtil.getLong(params, "fromDataId", (Long)null);
            Long moduleId = ParamUtil.getLong(params, "moduleId", (Long)null);
            FormDataMasterBean sessionMasterData = this.formManager.getSessioMasterDataBean(fromDataId);
            if(sessionMasterData == null) {
                throw new BusinessException(ResourceUtil.getString("form.cache.data.delete.label"));
            }

            sessionMasterData.putExtraAttr("moduleId", moduleId.longValue());
            Map<String, Object> resultMap = this.transFormRelation4SysType(params, sessionMasterData);
            if(null != sessionMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)sessionMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }

            List<DataContainer> tempList = (ArrayList)resultMap.remove("datas");
            Map<String, Set<FormDataSubBean>> dataSubBeanMap = new LinkedHashMap();
            Object o = AppContext.getThreadContext("onceAddedSubLineIds");
            Set<Long> onceAddedids = null;
            if(o != null) {
                onceAddedids = (HashSet)o;
            } else {
                onceAddedids = new HashSet();
            }

            List<DataContainer> newLines = new ArrayList();
            LinkedHashSet sortedSubDatas;
            if(Strings.isNotEmpty(tempList)) {
                Iterator var16 = tempList.iterator();

                while(var16.hasNext()) {
                    DataContainer d = (DataContainer)var16.next();
                    String tableName = (String)d.get("tableName");
                    Long subId = Long.valueOf(Long.parseLong(String.valueOf(d.get("recordId"))));
                    if(onceAddedids.contains(subId)) {
                        Set<FormDataSubBean> dataBeans = (Set)dataSubBeanMap.get(tableName);
                        if(dataBeans != null) {
                            dataBeans.add(sessionMasterData.getFormDataSubBeanById(tableName, subId));
                        } else {
                            sortedSubDatas = new LinkedHashSet();
                            sortedSubDatas.add(sessionMasterData.getFormDataSubBeanById(tableName, subId));
                            dataSubBeanMap.put(tableName, sortedSubDatas);
                        }

                        newLines.add(d);
                    }
                }
            } else {
                tempList = new ArrayList();
            }

            FormBean fromFormBean = this.formCacheManager.getForm(Long.parseLong(String.valueOf(params.get("fromFormId"))));
            tempList.removeAll(newLines);
            Iterator var35 = dataSubBeanMap.entrySet().iterator();

            while(var35.hasNext()) {
                Entry<String, Set<FormDataSubBean>> e = (Entry)var35.next();
                Set<FormDataSubBean> fillBackSubDatas = (Set)e.getValue();
                sortedSubDatas = new LinkedHashSet();
                String tempTableName = (String)e.getKey();
                List<FormDataSubBean> subDatas = sessionMasterData.getSubData(tempTableName);
                Iterator var23 = subDatas.iterator();

                while(var23.hasNext()) {
                    FormDataSubBean subData = (FormDataSubBean)var23.next();
                    Iterator var25 = fillBackSubDatas.iterator();

                    while(var25.hasNext()) {
                        FormDataSubBean fillBackSubData = (FormDataSubBean)var25.next();
                        if(subData.equals(fillBackSubData)) {
                            sortedSubDatas.add(fillBackSubData);
                        }
                    }
                }

                tempList.addAll(this.formDataManager.getSubDataLineContainer(fromFormBean, fromFormBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(String.valueOf(params.get("rightId"))))), sessionMasterData, sortedSubDatas, resultMap));
            }

            dc.add("success", "true");
            dc.put("results", resultMap);
            dc.put("datas", tempList);
        } catch (Exception var27) {
            LOGGER.error(var27.getMessage(), var27);
            dc.add("errorMsg", StringUtil.toString(var27));
            dc.add("success", "false");
        }

        return dc.getJson();
    }

    public void transFormFieldRelation(Object recordId, FormAuthViewBean formAuth, FormBean fromFormBean, String fromFieldName, List<FormDataMasterBean> toFormDataMasterBeans, FormDataMasterBean fromFormDataMasterBean, Map<String, Object> resultMap, Set<DataContainer> datas) throws BusinessException {
        this.transFormFieldRelation(recordId, formAuth, fromFormBean, fromFieldName, toFormDataMasterBeans, fromFormDataMasterBean, resultMap, datas, false, (Long)null, true);
    }

    public void transFormFieldRelation(Object recordId, FormAuthViewBean formAuth, FormBean fromFormBean, String fromFieldName, List<FormDataMasterBean> toFormDataMasterBeans, FormDataMasterBean cacheMasterBean, Map<String, Object> resultMap, Set<DataContainer> datas, boolean refreshAttr, Long moduleId, boolean needHtml) throws BusinessException {
        String fieldHtml = "";
        FormFieldBean formFieldBean = fromFormBean.getFieldBeanByName(fromFieldName);
        FormAuthViewFieldBean auth = null;
        Map<String, Object> conditionMap = cacheMasterBean.getFormulaMap("componentType_condition");
        if(formAuth != null) {
            auth = formAuth.getFormAuthorizationField(formFieldBean.getName(), conditionMap);
        }

        FormRelation relation = formFieldBean.getFormRelation();
        FormBean toFormBean = this.formCacheManager.getForm(relation.getToRelationObj().longValue());
        boolean isEmptySelect = ((Boolean)resultMap.get("isEmptySelect")).booleanValue();
        boolean isFormRelation = formFieldBean.getInputType().equals(FormFieldComEnum.RELATIONFORM.getKey());
        String toFieldName = isFormRelation?relation.getToRelationAttr():relation.getViewAttr();
        FormFieldBean toFieldBean = null;
        String fieldRelType = "";
        if(relation.getToRelationAttrType().intValue() != ToRelationAttrType.form_relation_flow.getKey() && !ViewAttrValue.formContent.getKey().equals(relation.getViewAttr())) {
            if(toFormBean != null) {
                toFieldBean = toFormBean.getFieldBeanByName(toFieldName);
                if(toFieldBean == null) {
                    LOGGER.info("被关联字段找不到，被关联表单id:" + String.valueOf(toFormBean.getId()) + " 表单名称：" + toFormBean.getFormName() + " 被关联表单字段:" + toFieldName);
                } else {
                    fieldRelType = this.getRelationType(formFieldBean, toFieldBean);
                }
            }
        } else {
            fieldRelType = formFieldBean.isMasterField()?"m":"s";
            fieldRelType = fieldRelType + "m";
        }

        FormTableBean fromFormTableBean = fromFormBean.getTableByTableName(formFieldBean.getOwnerTableName());
        FormDataMasterBean toFormDataMasterBean = (FormDataMasterBean)toFormDataMasterBeans.get(0);
        Object val = null;
        Object oldVal = null;
        boolean isCloneMasterData = false;
        String isCloneStr = String.valueOf(cacheMasterBean.getExtraAttr("isClone"));
        if(StringUtil.checkNull(isCloneStr) && "true".equals(isCloneStr)) {
            isCloneMasterData = true;
        }

        Object obj;
        if(fieldRelType.equals("mm")) {
            if(relation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey()) {
                cacheMasterBean.getFieldValue(formFieldBean.getName());
                val = toFormDataMasterBean.getExtraAttr("contentTitle");
                if(val == null) {
                    val = "";
                }

                cacheMasterBean.addFieldValue(formFieldBean.getName(), val);
            } else if(ViewAttrValue.formContent.getKey().equals(relation.getViewAttr())) {
                this.dealRelationFormContent(cacheMasterBean, toFormDataMasterBean, formFieldBean, (FormDataSubBean)null, (FormRelation)null, true);
            } else {
                cacheMasterBean.getFieldValue(formFieldBean.getName());
                val = toFormDataMasterBean.getFieldValue(toFieldName);
                if(refreshAttr && moduleId != null) {
                    if(formFieldBean.isAttachment(true, true)) {
                        Long uuid = Long.valueOf(UUIDUtil.getUUIDLong());
                        if(!StringUtil.checkNull(String.valueOf(val))) {
                            this.attachmentManager.copy((Long)toFormDataMasterBean.getExtraAttr("moduleId"), Long.valueOf(Long.parseLong(String.valueOf(val))), moduleId, uuid, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                        }

                        cacheMasterBean.addFieldValue(formFieldBean.getName(), uuid);
                    } else {
                        cacheMasterBean.addFieldValue(formFieldBean.getName(), val);
                    }
                } else if(formFieldBean.isAttachment(true, true)) {
                    this.dealRelationAttr(cacheMasterBean, (FormDataSubBean)null, formFieldBean, toFormDataMasterBean, val, Boolean.valueOf(isEmptySelect));
                } else {
                    cacheMasterBean.addFieldValue(formFieldBean.getName(), val);
                }

                this.dealRelationByType(formFieldBean, fromFormBean, formAuth, cacheMasterBean, resultMap, Long.valueOf(recordId instanceof Long?((Long)recordId).longValue():0L), formFieldBean.findRealFieldBean().getPossibleRelationAttrType(), true, true);
            }

            Long tempRecordId;
            Iterator var55;
            if(recordId instanceof Long) {
                this.formDataManager.calcAllWithFieldIn(fromFormBean, formFieldBean, cacheMasterBean, (Long)recordId, resultMap, formAuth, needHtml, true);
                Object obj2 = cacheMasterBean.getExtraAttr("viewRight");
                if(obj2 != null) {
                    auth = ((FormAuthViewBean)obj2).getFormAuthorizationField(formFieldBean.getName(), conditionMap);
                }
            } else if(recordId instanceof List) {
                var55 = ((List)recordId).iterator();

                while(var55.hasNext()) {
                    tempRecordId = (Long)var55.next();
                    this.formDataManager.calcAllWithFieldIn(fromFormBean, formFieldBean, cacheMasterBean, tempRecordId, resultMap, formAuth, needHtml, true);
                    obj = cacheMasterBean.getExtraAttr("viewRight");
                    if(obj != null) {
                        auth = ((FormAuthViewBean)obj).getFormAuthorizationField(formFieldBean.getName(), conditionMap);
                    }
                }
            }

            if(recordId instanceof Long) {
                if(isFormRelation && !isEmptySelect) {
                    this.createRelationRecordMap(cacheMasterBean, (Long)toFormDataMasterBean.getExtraAttr("moduleId"), toFormBean, relation.getFromRelationAttr(), Long.valueOf(0L));
                } else if(isFormRelation && isEmptySelect) {
                    this.clearRelationRecordMap(cacheMasterBean, relation.getFromRelationAttr(), ((Long)recordId).longValue());
                }
            } else if(recordId instanceof List) {
                var55 = ((List)recordId).iterator();

                label478:
                while(true) {
                    while(true) {
                        if(!var55.hasNext()) {
                            break label478;
                        }

                        tempRecordId = (Long)var55.next();
                        if(isFormRelation && !isEmptySelect) {
                            this.createRelationRecordMap(cacheMasterBean, (Long)toFormDataMasterBean.getExtraAttr("moduleId"), toFormBean, relation.getFromRelationAttr(), tempRecordId);
                        } else if(isFormRelation && isEmptySelect) {
                            this.clearRelationRecordMap(cacheMasterBean, relation.getFromRelationAttr(), tempRecordId.longValue());
                        }
                    }
                }
            }

            if(needHtml) {
                fieldHtml = FormFieldComEnum.getHTML(fromFormBean, formFieldBean, auth, cacheMasterBean);
                resultMap.put(formFieldBean.getName(), fieldHtml);
            }
        } else if(fieldRelType.equals("ms")) {
            List<FormDataSubBean> subLines = toFormDataMasterBean.getSubData(toFieldBean.getOwnerTableName());
            if(recordId instanceof Long) {
                if(isFormRelation && !isEmptySelect) {
                    this.createRelationRecordMap(cacheMasterBean, (Long)toFormDataMasterBean.getExtraAttr("moduleId"), toFormBean, relation.getFromRelationAttr(), (Long)recordId, ((FormDataSubBean)subLines.get(0)).getId());
                } else if(isFormRelation && isEmptySelect) {
                    this.clearRelationRecordMap(cacheMasterBean, relation.getFromRelationAttr(), ((Long)recordId).longValue());
                }
            } else if(recordId instanceof List) {
                Iterator var59 = ((List)recordId).iterator();

                label531:
                while(true) {
                    while(true) {
                        if(!var59.hasNext()) {
                            break label531;
                        }

                        Long tempRecordId = (Long)var59.next();
                        if(isFormRelation && !isEmptySelect) {
                            this.createRelationRecordMap(cacheMasterBean, (Long)toFormDataMasterBean.getExtraAttr("moduleId"), toFormBean, relation.getFromRelationAttr(), tempRecordId, ((FormDataSubBean)subLines.get(0)).getId());
                        } else if(isFormRelation && isEmptySelect) {
                            this.clearRelationRecordMap(cacheMasterBean, relation.getFromRelationAttr(), tempRecordId.longValue());
                        }
                    }
                }
            }

            if(subLines != null && subLines.size() > 0) {
                FormDataSubBean subLine = (FormDataSubBean)subLines.get(0);
                val = subLine.getFieldValue(toFieldName);
                cacheMasterBean.getFieldValue(formFieldBean.getName());
                if(formFieldBean.isAttachment(true, true)) {
                    this.dealRelationAttr(cacheMasterBean, (FormDataSubBean)null, formFieldBean, toFormDataMasterBean, val, Boolean.valueOf(isEmptySelect));
                } else {
                    cacheMasterBean.addFieldValue(formFieldBean.getName(), val);
                }

                this.dealRelationByType(formFieldBean, fromFormBean, formAuth, cacheMasterBean, resultMap, Long.valueOf(recordId instanceof Long?((Long)recordId).longValue():0L), formFieldBean.findRealFieldBean().getPossibleRelationAttrType(), true, true);
                if(recordId instanceof Long) {
                    this.formDataManager.calcAllWithFieldIn(fromFormBean, formFieldBean, cacheMasterBean, (Long)recordId, resultMap, formAuth, needHtml, true);
                    obj = cacheMasterBean.getExtraAttr("viewRight");
                    if(obj != null) {
                        auth = ((FormAuthViewBean)obj).getFormAuthorizationField(formFieldBean.getName(), conditionMap);
                    }
                } else if(recordId instanceof List) {
                    Iterator var63 = ((List)recordId).iterator();

                    while(var63.hasNext()) {
                        Long tempRecordId = (Long)var63.next();
                        this.formDataManager.calcAllWithFieldIn(fromFormBean, formFieldBean, cacheMasterBean, tempRecordId, resultMap, formAuth, needHtml, true);
                        Object obj22 = cacheMasterBean.getExtraAttr("viewRight");
                        if(obj22 != null) {
                            auth = ((FormAuthViewBean)obj22).getFormAuthorizationField(formFieldBean.getName(), conditionMap);
                        }
                    }
                }

                if(needHtml) {
                    fieldHtml = FormFieldComEnum.getHTML(fromFormBean, formFieldBean, auth, cacheMasterBean);
                    resultMap.put(formFieldBean.getName(), fieldHtml);
                }
            }
        } else if(fieldRelType.equals("sm") || fieldRelType.equals("ss")) {
            Set<FormDataSubBean> resultDatas = new LinkedHashSet();
            Map<String, List<FormRelation>> relationGroups = (Map)resultMap.get("relationGroups");
            if(relationGroups != null) {
                List<FormRelation> relationGroup = (List)relationGroups.get(formFieldBean.getOwnerTableName());
                if(relationGroup != null && relationGroup.size() > 0) {
                    boolean hasChildTable = false;
                    boolean hasFormRelation = false;
                    boolean hasCanEditField = false;
                    boolean isSysTriggerFromSubLine = false;
                    String tName = "";
                    Iterator var37 = relationGroup.iterator();

                    label803:
                    while(true) {
                        FormRelation toRelation;
                        while(var37.hasNext()) {
                            FormRelation tempRelation = (FormRelation)var37.next();
                            if(tempRelation.getToRelationAttrType().intValue() != ToRelationAttrType.form_relation_flow.getKey() && !ViewAttrValue.formContent.getKey().equals(tempRelation.getViewAttr())) {
                                FormFieldBean tfBean = toFormBean.getFieldBeanByName(tempRelation.getViewAttr());
                                if(formAuth != null) {
                                    FormAuthViewFieldBean tempAuth = formAuth.getFormAuthorizationField(tempRelation.getFromRelationAttr(), conditionMap);
                                    if(!tempAuth.getAccess().equals(FieldAccessType.add.getKey())) {
                                        hasCanEditField = true;
                                    }
                                }

                                if(!tfBean.isMasterField()) {
                                    hasChildTable = true;
                                    tName = tfBean.getOwnerTableName();
                                }

                                if(tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_field.getKey()) {
                                    hasFormRelation = true;
                                } else {
                                    FormFieldBean toRelationFieldBean = fromFormBean.getFieldBeanByName(tempRelation.getToRelationAttr());
                                    if(toRelationFieldBean != null && toRelationFieldBean.isMasterField()) {
                                        toRelation = toRelationFieldBean.getFormRelation();
                                        if(toRelation != null && toRelation.isFormRelation() && toRelation.getViewSelectType().intValue() == ViewSelectType.system.getKey() && AppContext.getThreadContext("isTriggerFromSubLine") != null && "true".equals(AppContext.getThreadContext("isTriggerFromSubLine"))) {
                                            isSysTriggerFromSubLine = true;
                                        }
                                    }
                                }
                            } else {
                                hasCanEditField = true;
                                hasFormRelation = true;
                            }
                        }

                        List<FormDataSubBean> subDatas = cacheMasterBean.getSubData(formFieldBean.getOwnerTableName());
                        if(subDatas == null || ((List)subDatas).size() == 0) {
                            if(subDatas == null) {
                                subDatas = new ArrayList();
                            }

                            FormTableBean formTableBean = fromFormBean.getTableByTableName(formFieldBean.getOwnerTableName());
                            FormDataSubBean newSub = new FormDataSubBean(formAuth, formTableBean, cacheMasterBean, new boolean[0]);
                            ((List)subDatas).add(newSub);
                        }

                        List<Long> subDataIds = new ArrayList();
                        Iterator var74;
                        FormDataSubBean d;
                        if(recordId instanceof Long) {
                            if(((Long)recordId).longValue() != 0L) {
                                subDataIds.add((Long)recordId);
                            } else {
                                boolean isAllFormRelation = true;
                                var74 = relationGroup.iterator();

                                while(var74.hasNext()) {
                                    toRelation = (FormRelation)var74.next();
                                    if(!toRelation.isFormRelation()) {
                                        isAllFormRelation = false;
                                    }
                                }

                                if(isAllFormRelation) {
                                    if(isSysTriggerFromSubLine) {
                                        var74 = ((List)subDatas).iterator();

                                        while(var74.hasNext()) {
                                            d = (FormDataSubBean)var74.next();
                                            subDataIds.add(d.getId());
                                        }
                                    } else {
                                        subDataIds.add((Long)recordId);
                                    }
                                } else if(isSysTriggerFromSubLine) {
                                    subDataIds.add(((FormDataSubBean)((List)subDatas).get(((List)subDatas).size() - 1)).getId());
                                } else {
                                    subDataIds.add((Long)recordId);
                                }
                            }
                        } else if(recordId instanceof List) {
                            subDataIds.addAll((List)recordId);
                        }

                        Iterator var72 = subDataIds.iterator();

                        while(true) {
                            boolean addRow;
                            while(var72.hasNext()) {
                                Long tempRecordId = (Long)var72.next();
                                int i;
                                List selectedSubDatas;
                                boolean hasDealFirstLine;
                                if(!hasChildTable) {
                                    hasDealFirstLine = false;

                                    label770:
                                    for(i = 0; i < toFormDataMasterBeans.size(); ++i) {
                                        selectedSubDatas = null;
                                        addRow = false;
                                        FormDataSubBean subLine;
                                        if((hasFormRelation || !hasFormRelation && isSysTriggerFromSubLine) && i == 0 && tempRecordId.longValue() != 0L) {
                                            hasDealFirstLine = true;
                                            subLine = cacheMasterBean.getFormDataSubBeanById(formFieldBean.getOwnerTableName(), tempRecordId);
                                        } else {
                                            if(!hasCanEditField || isEmptySelect) {
                                                break;
                                            }

                                            if(hasDealFirstLine || ((List)subDatas).size() != 1 || (formAuth == null || !((FormDataSubBean)((List)subDatas).get(0)).isEmpty(fromFormBean, formAuth)) && !((FormDataSubBean)((List)subDatas).get(0)).isEmpty()) {
                                                if(isCloneMasterData) {
                                                    continue;
                                                }

                                                addRow = true;
                                                AppContext.putThreadContext("isNew", Boolean.valueOf(true));
                                                subLine = new FormDataSubBean(formAuth, fromFormTableBean, cacheMasterBean, new boolean[0]);
                                                AppContext.removeThreadContext("isNew");
                                                if(formAuth != null) {
                                                    subLine.putExtraAttr("addedNewRow", "true");
                                                }
                                            } else {
                                                subLine = (FormDataSubBean)((List)subDatas).get(0);
                                            }
                                        }

                                        if(subLine != null) {
                                            if(addRow) {
                                                if(tempRecordId.longValue() == 0L) {
                                                    tempRecordId = ((FormDataSubBean)((List)subDatas).get(((List)subDatas).size() - 1)).getId();
                                                }

                                                cacheMasterBean.addSubData(formFieldBean.getOwnerTableName(), subLine, tempRecordId);
                                                List<FormFieldBean> tableFields = subLine.getFormTable().getFields();
                                                Iterator var88 = tableFields.iterator();

                                                while(var88.hasNext()) {
                                                    FormFieldBean subField = (FormFieldBean)var88.next();
                                                    if(subField.getFormConditionList() != null && subField.getFormConditionList().size() > 0) {
                                                        this.formDataManager.calc(fromFormBean, subField, cacheMasterBean, subLine.getId(), resultMap, formAuth, needHtml, true);
                                                    }
                                                }

                                                tempRecordId = subLine.getId();
                                            }

                                            List<String> hasCalcField = new ArrayList();
                                            List<FormFieldBean> inCalculateFieldList = new ArrayList();
                                            Iterator var91 = relationGroup.iterator();

                                            while(true) {
                                                while(true) {
                                                    FormRelation tempRelation;
                                                    FormFieldBean sunFieldbean;
                                                    while(true) {
                                                        if(!var91.hasNext()) {
                                                            if(addRow) {
                                                                List<FormFieldBean> allFields = fromFormBean.getAllFieldBeans();
                                                                Iterator var96 = allFields.iterator();

                                                                label700:
                                                                while(true) {
                                                                    do {
                                                                        if(!var96.hasNext()) {
                                                                            var96 = inCalculateFieldList.iterator();

                                                                            while(var96.hasNext()) {
                                                                                sunFieldbean = (FormFieldBean)var96.next();
                                                                                if(!hasCalcField.contains(sunFieldbean.getName())) {
                                                                                    this.formDataManager.calcAllWithFieldIn(fromFormBean, sunFieldbean, cacheMasterBean, subLine.getId(), resultMap, formAuth, needHtml, false);
                                                                                }
                                                                            }
                                                                            break label700;
                                                                        }

                                                                        sunFieldbean = (FormFieldBean)var96.next();
                                                                    } while(!sunFieldbean.getOwnerTableName().equalsIgnoreCase(fromFormTableBean.getTableName()) && sunFieldbean.getOwnerTableName().indexOf("formmain") == -1);

                                                                    if(sunFieldbean.isInCalculate()) {
                                                                        inCalculateFieldList.add(sunFieldbean);
                                                                    }
                                                                }
                                                            }

                                                            if(formAuth != null) {
                                                                subLine.putExtraAttr("relationGroup", relationGroup);
                                                                resultDatas.add(subLine);
                                                            }
                                                            continue label770;
                                                        }

                                                        tempRelation = (FormRelation)var91.next();
                                                        if(tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey()) {
                                                            subLine.getFieldValue(tempRelation.getFromRelationAttr());
                                                            val = ((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("contentTitle");
                                                            if(val == null) {
                                                                val = "";
                                                            }

                                                            subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                            break;
                                                        }

                                                        if(ViewAttrValue.formContent.getKey().equals(tempRelation.getViewAttr())) {
                                                            this.dealRelationFormContent(cacheMasterBean, (FormDataMasterBean)toFormDataMasterBeans.get(i), (FormFieldBean)null, subLine, tempRelation, false);
                                                            break;
                                                        }

                                                        if(tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.data_relation_field.getKey() && formAuth != null) {
                                                            FormAuthViewFieldBean tempAuth = formAuth.getFormAuthorizationField(tempRelation.getFromRelationAttr(), conditionMap);
                                                            if(tempAuth.getAccess().equals(FieldAccessType.add.getKey())) {
                                                                continue;
                                                            }
                                                        }

                                                        subLine.getFieldValue(tempRelation.getFromRelationAttr());
                                                        val = ((FormDataMasterBean)toFormDataMasterBeans.get(i)).getFieldValue(tempRelation.getViewAttr());
                                                        sunFieldbean = subLine.getFormTable().getFieldBeanByName(tempRelation.getFromRelationAttr());
                                                        if(refreshAttr && moduleId != null) {
                                                            if(sunFieldbean.isAttachment(true, true)) {
                                                                Long uuid = Long.valueOf(UUIDUtil.getUUIDLong());
                                                                if(!StringUtil.checkNull(String.valueOf(val))) {
                                                                    this.attachmentManager.copy((Long)((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("moduleId"), Long.valueOf(Long.parseLong(String.valueOf(val))), moduleId, uuid, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                                                                }

                                                                subLine.addFieldValue(tempRelation.getFromRelationAttr(), uuid);
                                                            } else {
                                                                subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                            }
                                                        } else if(sunFieldbean.isAttachment(true, true)) {
                                                            this.dealRelationAttr(cacheMasterBean, subLine, sunFieldbean, (FormDataMasterBean)toFormDataMasterBeans.get(i), val, Boolean.valueOf(isEmptySelect));
                                                        } else {
                                                            subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                        }

                                                        this.dealRelationByType(sunFieldbean, fromFormBean, formAuth, cacheMasterBean, resultMap, subLine.getId(), sunFieldbean.findRealFieldBean().getPossibleRelationAttrType(), true, true);
                                                        break;
                                                    }

                                                    sunFieldbean = fromFormBean.getFieldBeanByName(tempRelation.getFromRelationAttr());
                                                    hasCalcField.add(sunFieldbean.getName());
                                                    this.formDataManager.calcAllWithFieldIn(fromFormBean, sunFieldbean, cacheMasterBean, subLine.getId(), resultMap, formAuth, needHtml, true);
                                                    boolean tempIsFormRelation = tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_field.getKey() || tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey() || tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_formContent.getKey();
                                                    if(tempIsFormRelation && !isEmptySelect) {
                                                        this.createRelationRecordMap(cacheMasterBean, (Long)((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("moduleId"), toFormBean, tempRelation.getFromRelationAttr(), subLine.getId());
                                                    } else if(tempIsFormRelation && isEmptySelect) {
                                                        this.clearRelationRecordMap(cacheMasterBean, tempRelation.getFromRelationAttr(), subLine.getId().longValue());
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    hasDealFirstLine = false;

                                    for(i = 0; i < toFormDataMasterBeans.size(); ++i) {
                                        selectedSubDatas = ((FormDataMasterBean)toFormDataMasterBeans.get(i)).getSubData(tName);

                                        label670:
                                        for(int j = 0; j < selectedSubDatas.size(); ++j) {
                                            FormDataSubBean sdata = (FormDataSubBean)selectedSubDatas.get(j);
                                            FormDataSubBean subLine = null;
                                             addRow = false;
                                            if((hasFormRelation || !hasFormRelation && isSysTriggerFromSubLine) && j == 0 && i == 0 && tempRecordId.longValue() != 0L) {
                                                hasDealFirstLine = true;
                                                subLine = cacheMasterBean.getFormDataSubBeanById(formFieldBean.getOwnerTableName(), tempRecordId);
                                            } else {
                                                if(!hasCanEditField || isEmptySelect) {
                                                    break;
                                                }

                                                if(!hasDealFirstLine && ((List)subDatas).size() == 1 && ((FormDataSubBean)((List)subDatas).get(0)).isEmpty()) {
                                                    subLine = (FormDataSubBean)((List)subDatas).get(0);
                                                } else {
                                                    if(isCloneMasterData) {
                                                        continue;
                                                    }

                                                    addRow = true;
                                                    AppContext.putThreadContext("isNew", Boolean.valueOf(true));
                                                    subLine = new FormDataSubBean(formAuth, fromFormTableBean, cacheMasterBean, new boolean[0]);
                                                    AppContext.removeThreadContext("isNew");
                                                    if(formAuth != null) {
                                                        subLine.putExtraAttr("addedNewRow", "true");
                                                    }
                                                }
                                            }

                                            if(subLine != null) {
                                                if(addRow) {
                                                    if(tempRecordId.longValue() == 0L) {
                                                        tempRecordId = ((FormDataSubBean)((List)subDatas).get(((List)subDatas).size() - 1)).getId();
                                                    }

                                                    cacheMasterBean.addSubData(formFieldBean.getOwnerTableName(), subLine, tempRecordId);
                                                    List<FormFieldBean> tableFields = subLine.getFormTable().getFields();
                                                    Iterator var49 = tableFields.iterator();

                                                    while(var49.hasNext()) {
                                                        FormFieldBean subField = (FormFieldBean)var49.next();
                                                        if(subField.getFormConditionList() != null && subField.getFormConditionList().size() > 0) {
                                                            this.formDataManager.calc(fromFormBean, subField, cacheMasterBean, subLine.getId(), resultMap, formAuth, needHtml, true);
                                                        }
                                                    }

                                                    tempRecordId = subLine.getId();
                                                }

                                                List<String> hasCalcField = new ArrayList();
                                                List<FormFieldBean> inCalculateFieldList = new ArrayList();
                                                Iterator var100 = relationGroup.iterator();

                                                while(true) {
                                                    while(true) {
                                                        FormRelation tempRelation;
                                                        FormFieldBean field1;
                                                        while(true) {
                                                            if(!var100.hasNext()) {
                                                                if(addRow) {
                                                                    List<FormFieldBean> allFields = fromFormBean.getAllFieldBeans();
                                                                    Iterator var104 = allFields.iterator();

                                                                    label597:
                                                                    while(true) {
                                                                        do {
                                                                            if(!var104.hasNext()) {
                                                                                var104 = inCalculateFieldList.iterator();

                                                                                while(var104.hasNext()) {
                                                                                    field1 = (FormFieldBean)var104.next();
                                                                                    if(!hasCalcField.contains(field1.getName())) {
                                                                                        this.formDataManager.calcAllWithFieldIn(fromFormBean, field1, cacheMasterBean, subLine.getId(), resultMap, formAuth, needHtml, false);
                                                                                    }
                                                                                }
                                                                                break label597;
                                                                            }

                                                                            field1 = (FormFieldBean)var104.next();
                                                                        } while(!field1.getOwnerTableName().equalsIgnoreCase(fromFormTableBean.getTableName()) && field1.getOwnerTableName().indexOf("formmain") == -1);

                                                                        if(field1.isInCalculate()) {
                                                                            inCalculateFieldList.add(field1);
                                                                        }
                                                                    }
                                                                }

                                                                if(formAuth != null) {
                                                                    subLine.putExtraAttr("relationGroup", relationGroup);
                                                                    resultDatas.add(subLine);
                                                                }
                                                                continue label670;
                                                            }

                                                            tempRelation = (FormRelation)var100.next();
                                                            if(tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey()) {
                                                                subLine.getFieldValue(tempRelation.getFromRelationAttr());
                                                                val = ((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("contentTitle");
                                                                if(val == null) {
                                                                    val = "";
                                                                }

                                                                subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                                break;
                                                            }

                                                            if(ViewAttrValue.formContent.getKey().equals(tempRelation.getViewAttr())) {
                                                                this.dealRelationFormContent(cacheMasterBean, (FormDataMasterBean)toFormDataMasterBeans.get(i), (FormFieldBean)null, subLine, tempRelation, false);
                                                                break;
                                                            }

                                                            if(tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.data_relation_field.getKey() && formAuth != null) {
                                                                FormAuthViewFieldBean tempAuth = formAuth.getFormAuthorizationField(tempRelation.getFromRelationAttr(), conditionMap);
                                                                if(tempAuth.getAccess().equals(FieldAccessType.add.getKey())) {
                                                                    continue;
                                                                }
                                                            }

                                                            field1 = toFormBean.getFieldBeanByName(tempRelation.getViewAttr());
                                                            FormFieldBean sunFieldbean;
                                                            Long uuid;
                                                            if(field1.isMasterField()) {
                                                                subLine.getFieldValue(tempRelation.getFromRelationAttr());
                                                                val = ((FormDataMasterBean)toFormDataMasterBeans.get(i)).getFieldValue(tempRelation.getViewAttr());
                                                                sunFieldbean = subLine.getFormTable().getFieldBeanByName(tempRelation.getFromRelationAttr());
                                                                if(refreshAttr && moduleId != null) {
                                                                    if(sunFieldbean.isAttachment(true, true)) {
                                                                        uuid = Long.valueOf(UUIDUtil.getUUIDLong());
                                                                        if(!StringUtil.checkNull(String.valueOf(val))) {
                                                                            this.attachmentManager.copy((Long)((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("moduleId"), Long.valueOf(Long.parseLong(String.valueOf(val))), moduleId, uuid, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                                                                        }

                                                                        subLine.addFieldValue(tempRelation.getFromRelationAttr(), uuid);
                                                                    } else {
                                                                        subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                                    }
                                                                } else if(sunFieldbean.isAttachment(true, true)) {
                                                                    this.dealRelationAttr(cacheMasterBean, subLine, sunFieldbean, (FormDataMasterBean)toFormDataMasterBeans.get(i), val, Boolean.valueOf(isEmptySelect));
                                                                } else {
                                                                    subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                                }

                                                                this.dealRelationByType(sunFieldbean, fromFormBean, formAuth, cacheMasterBean, resultMap, subLine.getId(), sunFieldbean.findRealFieldBean().getPossibleRelationAttrType(), true, true);
                                                                break;
                                                            }

                                                            subLine.getFieldValue(tempRelation.getFromRelationAttr());
                                                            val = sdata.getFieldValue(tempRelation.getViewAttr());
                                                            sunFieldbean = subLine.getFormTable().getFieldBeanByName(tempRelation.getFromRelationAttr());
                                                            if(refreshAttr && moduleId != null) {
                                                                if(sunFieldbean.isAttachment(true, true)) {
                                                                    uuid = Long.valueOf(UUIDUtil.getUUIDLong());
                                                                    if(!StringUtil.checkNull(String.valueOf(val))) {
                                                                        this.attachmentManager.copy((Long)((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("moduleId"), Long.valueOf(Long.parseLong(String.valueOf(val))), moduleId, uuid, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                                                                    }

                                                                    subLine.addFieldValue(tempRelation.getFromRelationAttr(), uuid);
                                                                } else {
                                                                    subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                                }
                                                            } else if(sunFieldbean.isAttachment(true, true)) {
                                                                this.dealRelationAttr(cacheMasterBean, subLine, sunFieldbean, (FormDataMasterBean)toFormDataMasterBeans.get(i), val, Boolean.valueOf(isEmptySelect));
                                                            } else {
                                                                subLine.addFieldValue(tempRelation.getFromRelationAttr(), val);
                                                            }

                                                            this.dealRelationByType(sunFieldbean, fromFormBean, formAuth, cacheMasterBean, resultMap, subLine.getId(), sunFieldbean.findRealFieldBean().getPossibleRelationAttrType(), true, true);
                                                            break;
                                                        }

                                                        field1 = fromFormBean.getFieldBeanByName(tempRelation.getFromRelationAttr());
                                                        hasCalcField.add(field1.getName());
                                                        this.formDataManager.calcAllWithFieldIn(fromFormBean, field1, cacheMasterBean, subLine.getId(), resultMap, formAuth, needHtml, true);
                                                        boolean tempIsFormRelation = tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_field.getKey() || tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey() || tempRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_formContent.getKey();
                                                        if(tempIsFormRelation && !isEmptySelect) {
                                                            this.createRelationRecordMap(cacheMasterBean, (Long)((FormDataMasterBean)toFormDataMasterBeans.get(i)).getExtraAttr("moduleId"), toFormBean, tempRelation.getFromRelationAttr(), subLine.getId(), sdata.getId());
                                                        } else if(tempIsFormRelation && isEmptySelect) {
                                                            this.clearRelationRecordMap(cacheMasterBean, tempRelation.getFromRelationAttr(), subLine.getId().longValue());
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            String notGenerateSubData = String.valueOf(AppContext.getThreadContext("notGenerateSubData"));
                            if(formAuth != null && needHtml && !"true".equals(notGenerateSubData)) {
                                 obj = cacheMasterBean.getExtraAttr("viewRight");
                                toRelation = null;
                                Set tempDatas;
                                if(obj != null) {
                                    tempDatas = this.formDataManager.getSubDataLineContainer(fromFormBean, (FormAuthViewBean)obj, cacheMasterBean, resultDatas, resultMap);
                                } else {
                                    tempDatas = this.formDataManager.getSubDataLineContainer(fromFormBean, formAuth, cacheMasterBean, resultDatas, resultMap);
                                }

                                if(tempDatas == null || tempDatas.size() <= 0) {
                                    break label803;
                                }

                                Iterator var79 = tempDatas.iterator();

                                while(true) {
                                    if(!var79.hasNext()) {
                                        break label803;
                                    }

                                    DataContainer d1 = (DataContainer)var79.next();
                                    addRow = false;
                                    Iterator var87 = datas.iterator();

                                    while(var87.hasNext()) {
                                        DataContainer d2 = (DataContainer)var87.next();
                                        if(String.valueOf(d1.get("recordId")).equalsIgnoreCase(String.valueOf(d2.get("recordId")))) {
                                            d2.putAll(d1);
                                            addRow = true;
                                            break;
                                        }
                                    }

                                    if(!addRow) {
                                        datas.add(d1);
                                    }
                                }
                            }

                            if(resultDatas == null || resultDatas.size() <= 0) {
                                break label803;
                            }

                            var74 = resultDatas.iterator();

                            while(true) {
                                if(!var74.hasNext()) {
                                    break label803;
                                }

                                d = (FormDataSubBean)var74.next();
                                d.getExtraMap().remove("relationGroup");
                            }
                        }
                    }
                }

                relationGroups.remove(formFieldBean.getOwnerTableName());
            }
        }

    }

    private void dealRelationFormContent(FormDataMasterBean cacheMasterBean, FormDataMasterBean toFormDataMasterBean, FormFieldBean formFieldBean, FormDataSubBean subLine, FormRelation tempRelation, boolean isMaster) {
        String content = String.valueOf(toFormDataMasterBean.getExtraAttr("content"));
        if(Strings.isNotEmpty(content) && !"null".equals(content) && Long.valueOf(content).longValue() != 0L) {
            Long subRef = Long.valueOf(content);
            Long toFormDataId = toFormDataMasterBean.getId();
            Long newSub = Long.valueOf(UUIDLong.longUUID());
            Long newModuleId = (Long)cacheMasterBean.getExtraAttr("moduleId");
            this.attachmentManager.copy(toFormDataId, subRef, newModuleId, newSub, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
            List<Attachment> list = this.attachmentManager.getByReference(newModuleId, newSub);
            Attachment attachment = (Attachment)list.get(0);
            attachment.setFilename(toFormDataMasterBean.getExtraAttr("contentTitle") + "[正文].doc");
            this.attachmentManager.update(attachment);
            List<Attachment> cacheAtts = (List)cacheMasterBean.getExtraAttr("attachments");
            if(cacheAtts == null) {
                cacheAtts = new ArrayList();
                cacheMasterBean.putExtraAttr("attachments", (List)cacheAtts);
            }

            ((List)cacheAtts).addAll(this.attachmentManager.getByReference(newModuleId, newSub));
            if(isMaster) {
                cacheMasterBean.addFieldValue(formFieldBean.getName(), newSub);
            } else {
                subLine.addFieldValue(tempRelation.getFromRelationAttr(), newSub);
            }
        } else if(isMaster) {
            cacheMasterBean.addFieldValue(formFieldBean.getName(), Long.valueOf(UUIDLong.longUUID()));
        } else {
            subLine.addFieldValue(tempRelation.getFromRelationAttr(), Long.valueOf(UUIDLong.longUUID()));
        }

    }

    public void dealRelationAttr(FormDataMasterBean cacheMasterBean, FormDataSubBean subLine, FormFieldBean formFieldBean, FormDataMasterBean toFormDataMasterBean, Object val, Boolean isEmptySelect) {
        List<Attachment> cacheAtts = (List)cacheMasterBean.getExtraAttr("attachments");
        String attStr = String.valueOf(val);
        attStr = attStr.trim();
        boolean isCopy = AppContext.getThreadContext("formDataIsFromCopy") == null?false:((Boolean)AppContext.getThreadContext("formDataIsFromCopy")).booleanValue();
        if(!isCopy) {
            Long uuid;
            if(!isEmptySelect.booleanValue() && !StringUtil.checkNull(attStr) && !StringUtil.checkNull(String.valueOf(cacheMasterBean.getExtraAttr("moduleId")))) {
                uuid = Long.valueOf(UUIDUtil.getUUIDLong());
                this.attachmentManager.copy((Long)toFormDataMasterBean.getExtraAttr("moduleId"), Long.valueOf(Long.parseLong(attStr)), (Long)cacheMasterBean.getExtraAttr("moduleId"), uuid, Integer.valueOf(ApplicationCategoryEnum.form.getKey()));
                if(formFieldBean.isMasterField()) {
                    cacheMasterBean.addFieldValue(formFieldBean.getName(), uuid);
                } else if(subLine != null) {
                    subLine.addFieldValue(formFieldBean.getName(), uuid);
                }

                if(cacheAtts == null) {
                    cacheAtts = new ArrayList();
                    cacheMasterBean.putExtraAttr("attachments", (List)cacheAtts);
                }

                ((List)cacheAtts).addAll(this.attachmentManager.getByReference((Long)cacheMasterBean.getExtraAttr("moduleId"), uuid));
            } else if(!StringUtil.checkNull(attStr) && cacheAtts != null && !((List)cacheAtts).isEmpty()) {
                List<Attachment> removeAtts = new ArrayList();
                Long removeSubReferenceId = Long.valueOf(Long.parseLong(attStr));
                Iterator var12 = ((List)cacheAtts).iterator();

                while(var12.hasNext()) {
                    Attachment att = (Attachment)var12.next();
                    if(att.getSubReference().longValue() == removeSubReferenceId.longValue()) {
                        removeAtts.add(att);
                    }
                }

                ((List)cacheAtts).removeAll(removeAtts);
            } else {
                uuid = Long.valueOf(UUIDUtil.getUUIDLong());
                if(formFieldBean.isMasterField()) {
                    cacheMasterBean.addFieldValue(formFieldBean.getName(), uuid);
                } else if(subLine != null) {
                    subLine.addFieldValue(formFieldBean.getName(), uuid);
                }
            }

        }
    }

    public FormDataMasterBean cloneAndRefreshMasterData(FormDataMasterBean cacheMasterData, FormBean fb) throws CloneNotSupportedException, BusinessException, SQLException {
        FormDataMasterBean cloneMasterDataBean = (FormDataMasterBean)cacheMasterData.clone();
        cloneMasterDataBean.putExtraAttr("isClone", "true");
        Map<String, FormRelationRecord> relationRecordMap = cacheMasterData.getFormRelationRecordMap();
        if(relationRecordMap != null) {
            Iterator var5 = relationRecordMap.entrySet().iterator();

            label176:
            while(true) {
                while(true) {
                    label147:
                    while(true) {
                        FormRelationRecord record;
                        String fName;
                        FormFieldBean relationFormField;
                        FormRelation relation;
                        FormBean toFormBean;
                        FormDataMasterBean toMasterData;
                        do {
                            Long toFormId;
                            do {
                                do {
                                    do {
                                        do {
                                            do {
                                                do {
                                                    do {
                                                        if(!var5.hasNext()) {
                                                            break label176;
                                                        }

                                                        Entry<String, FormRelationRecord> e = (Entry)var5.next();
                                                        record = (FormRelationRecord)e.getValue();
                                                        fName = record.getFieldName();
                                                    } while(StringUtil.checkNull(fName));

                                                    relationFormField = fb.getFieldBeanByName(fName);
                                                } while(relationFormField == null);

                                                relation = relationFormField.getFormRelation();
                                            } while(relation == null);
                                        } while(!relation.isSysRelationForm());
                                    } while(!relation.isFormRelationField());

                                    toFormId = relation.getToRelationObj();
                                } while(toFormId == null);
                            } while(record.getToMasterDataId() == null);

                            toFormBean = this.formCacheManager.getForm(toFormId.longValue());
                            toMasterData = FormService.findDataById(record.getToMasterDataId().longValue(), toFormBean, (String[])null);
                        } while(toMasterData == null);

                        List<FormRelation> relations = this.getFormRelations(relationFormField, fb);
                        String toFieldBeanName = relation.getViewAttr();
                        FormFieldBean toFieldBean = toFormBean.getFieldBeanByName(toFieldBeanName);
                        FormDataSubBean fromSubData;
                        FormFieldBean otherToFieldBean;
                        Iterator var25;
                        FormRelation otherRelation;

                        FormFieldBean otherFromFieldBean;
                        if(relationFormField.isMasterField()) {
                            if(toFieldBean.isMasterField()) {
                                cloneMasterDataBean.addFieldValue(fName, toMasterData.getFieldValue(toFieldBeanName));
                                var25 = relations.iterator();

                                while(var25.hasNext()) {
                                    otherRelation = (FormRelation)var25.next();
                                    otherFromFieldBean = fb.getFieldBeanByName(otherRelation.getFromRelationAttr());
                                    otherFromFieldBean = toFormBean.getFieldBeanByName(otherRelation.getViewAttr());
                                    if(otherFromFieldBean.isMasterField() && otherFromFieldBean.isMasterField()) {
                                        cloneMasterDataBean.addFieldValue(otherFromFieldBean.getName(), toMasterData.getFieldValue(otherFromFieldBean.getName()));
                                    }
                                }
                            } else if(record.getToSubdataId() != null) {
                                fromSubData = toMasterData.getFormDataSubBeanById(toFieldBean.getOwnerTableName(), record.getToSubdataId());
                                if(fromSubData != null) {
                                    cloneMasterDataBean.addFieldValue(fName, fromSubData.getFieldValue(toFieldBeanName));
                                }

                                Iterator var27 = relations.iterator();

                                while(true) {
                                    while(true) {
                                        if(!var27.hasNext()) {
                                            continue label147;
                                        }

                                         otherRelation = (FormRelation)var27.next();
                                        otherFromFieldBean = fb.getFieldBeanByName(otherRelation.getFromRelationAttr());
                                        otherToFieldBean = toFormBean.getFieldBeanByName(otherRelation.getViewAttr());
                                        if(otherFromFieldBean.isMasterField()) {
                                            if(otherToFieldBean.isMasterField()) {
                                                cloneMasterDataBean.addFieldValue(otherFromFieldBean.getName(), toMasterData.getFieldValue(otherToFieldBean.getName()));
                                            } else {
                                                cloneMasterDataBean.addFieldValue(otherFromFieldBean.getName(), fromSubData.getFieldValue(otherToFieldBean.getName()));
                                            }
                                        } else if(otherToFieldBean.isMasterField()) {
                                            List<FormDataSubBean> subDatas = cloneMasterDataBean.getSubData(otherFromFieldBean.getOwnerTableName());
                                            Iterator var23 = subDatas.iterator();

                                            while(var23.hasNext()) {
                                                FormDataSubBean subData1 = (FormDataSubBean)var23.next();
                                                subData1.addFieldValue(otherFromFieldBean.getName(), toMasterData.getFieldValue(otherToFieldBean.getName()));
                                            }
                                        }
                                    }
                                }
                            }
                        } else if(toFieldBean.isMasterField()) {
                            if(record.getFromSubdataId() != null) {
                                fromSubData = cloneMasterDataBean.getFormDataSubBeanById(relationFormField.getOwnerTableName(), record.getFromSubdataId());
                                if(fromSubData != null) {
                                    fromSubData.addFieldValue(fName, toMasterData.getFieldValue(toFieldBean.getName()));
                                }
                            }

                            var25 = relations.iterator();

                            while(var25.hasNext()) {
                                otherRelation = (FormRelation)var25.next();
                                otherFromFieldBean = fb.getFieldBeanByName(otherRelation.getFromRelationAttr());
                                otherFromFieldBean = toFormBean.getFieldBeanByName(otherRelation.getViewAttr());
                                if(otherFromFieldBean.isMasterField()) {
                                    if(otherFromFieldBean.isMasterField()) {
                                        ;
                                    }
                                } else if(otherFromFieldBean.isMasterField() && record.getFromMasterDataId() != null && relationFormField.getOwnerTableName().equals(otherFromFieldBean.getOwnerTableName())) {
                                    FormDataSubBean subData = cloneMasterDataBean.getFormDataSubBeanById(otherFromFieldBean.getOwnerTableName(), record.getFromSubdataId());
                                    if(subData != null) {
                                        subData.addFieldValue(otherFromFieldBean.getName(), toMasterData.getFieldValue(otherFromFieldBean.getName()));
                                    }
                                }
                            }
                        } else if(record.getFromSubdataId() != null && record.getToSubdataId() != null) {
                            fromSubData = cloneMasterDataBean.getFormDataSubBeanById(relationFormField.getOwnerTableName(), record.getFromSubdataId());
                            FormDataSubBean toSubData = toMasterData.getFormDataSubBeanById(toFieldBean.getOwnerTableName(), record.getToSubdataId());
                            if(fromSubData != null && toSubData != null) {
                                fromSubData.addFieldValue(relationFormField.getName(), toSubData.getFieldValue(toFieldBean.getName()));
                                Iterator var19 = relations.iterator();

                                while(var19.hasNext()) {
                                     otherRelation = (FormRelation)var19.next();
                                    otherToFieldBean = fb.getFieldBeanByName(otherRelation.getFromRelationAttr());
                                     otherToFieldBean = toFormBean.getFieldBeanByName(otherRelation.getViewAttr());
                                    if(otherToFieldBean.isMasterField()) {
                                        if(otherToFieldBean.isMasterField()) {
                                            ;
                                        }
                                    } else if(otherToFieldBean.isMasterField()) {
                                        if(relationFormField.getOwnerTableName().equals(otherToFieldBean.getOwnerTableName())) {
                                            fromSubData.addFieldValue(otherToFieldBean.getName(), toMasterData.getFieldValue(otherToFieldBean.getName()));
                                        }
                                    } else if(relationFormField.getOwnerTableName().equals(otherToFieldBean.getOwnerTableName())) {
                                        fromSubData.addFieldValue(otherToFieldBean.getName(), toSubData.getFieldValue(otherToFieldBean.getName()));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        cloneMasterDataBean.setFormRelationRecordMap(new HashMap());
        this.formDataManager.calcAll(fb, cloneMasterDataBean, (FormAuthViewBean)null, false, false, false);
        return cloneMasterDataBean;
    }

    public List<CtpContentAll> getContentAllBean(Long contentDataId) {
        Map<String, Object> param = new HashMap();
        param.put("contentDataId", contentDataId);
        List<CtpContentAll> contentAlls = MainbodyService.getInstance().getContentList(param);
        return contentAlls;
    }

    public boolean isExistRelation(Long formId) throws BusinessException {
        boolean isExist = false;
        List<FormRelation> allRelations = this.formRelationDAO.selectAll();
        if(allRelations != null) {
            Iterator var4 = allRelations.iterator();

            FormRelation fr;
            do {
                do {
                    do {
                        do {
                            do {
                                do {
                                    if(!var4.hasNext()) {
                                        return isExist;
                                    }

                                    fr = (FormRelation)var4.next();
                                } while(fr.getToRelationObj() == null);
                            } while(formId == null);
                        } while(fr.getToRelationObj().longValue() != formId.longValue());
                    } while(fr.getToRelationAttrType() == null);
                } while(fr.getFromRelationObj() != null && fr.getToRelationObj().longValue() == fr.getFromRelationObj().longValue());
            } while(ToRelationAttrType.data_relation_field.getKey() != fr.getToRelationAttrType().intValue() && ToRelationAttrType.form_relation_field.getKey() != fr.getToRelationAttrType().intValue() && ToRelationAttrType.form_relation_flow.getKey() != fr.getToRelationAttrType().intValue() && ToRelationAttrType.form_relation_formContent.getKey() != fr.getToRelationAttrType().intValue());

            isExist = true;
        }

        return isExist;
    }

    public void createRelationRecordMap(FormDataMasterBean fromFormDataMasterBean, Long toMasterDataId, FormBean toFormBean, String name, Long fromSubDataId) throws BusinessException {
        this.createRelationRecordMap(fromFormDataMasterBean, toMasterDataId, toFormBean, name, fromSubDataId, Long.valueOf(0L));
    }

    public void createRelationRecordMap(FormDataMasterBean fromFormDataMasterBean, Long toMasterDataId, FormBean toFormBean, String name, Long fromSubDataId, Long toSubDataId) throws BusinessException {
        Map<String, FormRelationRecord> relationRecordMap = fromFormDataMasterBean.getFormRelationRecordMap();
        if(relationRecordMap == null) {
            relationRecordMap = this.getFormRelationMap(fromFormDataMasterBean.getId());
            fromFormDataMasterBean.setFormRelationRecordMap(relationRecordMap);
        }

        FormTableBean tableBean = fromFormDataMasterBean.getFormTable();
        String recordKey;
        if(tableBean.getFieldBeanByName(name) != null) {
            recordKey = fromFormDataMasterBean.getId() + "_" + name;
            Iterator it = relationRecordMap.entrySet().iterator();

            while(it.hasNext()) {
                Entry<String, FormRelationRecord> tempMap = (Entry)it.next();
                if(((String)tempMap.getKey()).startsWith(recordKey)) {
                    it.remove();
                }
            }
        }

        recordKey = fromFormDataMasterBean.getId() + "_" + name + "_" + fromSubDataId;
        FormRelationRecord relationRecord = (FormRelationRecord)relationRecordMap.get(recordKey);
        if(relationRecord == null) {
            relationRecord = new FormRelationRecord();
            relationRecord.setId(Long.valueOf(UUIDUtil.getUUIDLong()));
            relationRecord.setFromMasterDataId(fromFormDataMasterBean.getId());
            relationRecord.setFromFormId(fromFormDataMasterBean.getFormTable().getFormId());
            relationRecord.setToMasterDataId(toMasterDataId);
            relationRecord.setState(Integer.valueOf(1));
            relationRecord.setFieldName(name);
            if(toFormBean.getFormType() == FormType.baseInfo.getKey()) {
                relationRecord.setFormType(Integer.valueOf(ModuleType.unflowBasic.getKey()));
            } else if(toFormBean.getFormType() == FormType.manageInfo.getKey()) {
                relationRecord.setFormType(Integer.valueOf(ModuleType.unflowInfo.getKey()));
            } else {
                relationRecord.setFormType(Integer.valueOf(toFormBean.getFormType()));
            }

            relationRecord.setType(Integer.valueOf(RelationDataCreatType.formRelaton.getKey()));
            relationRecord.setMemberId(Long.valueOf(AppContext.currentUserId()));
            relationRecord.setFromSubdataId(fromSubDataId);
            relationRecord.setToSubdataId(toSubDataId);
            relationRecord.setToFormId(toFormBean.getId());
            LOGGER.info("新增关联记录：id=" + relationRecord.getId() + " 数据id：" + fromFormDataMasterBean.getId() + " 目标数据id：" + toMasterDataId);
        } else {
            relationRecord.setToFormId(toFormBean.getId());
            relationRecord.setToMasterDataId(toMasterDataId);
            relationRecord.setMemberId(Long.valueOf(AppContext.currentUserId()));
            relationRecord.setToSubdataId(toSubDataId);
        }

        relationRecordMap.put(recordKey, relationRecord);
    }

    public void clearRelationRecordMap(FormDataMasterBean fromFormDataMasterBean, String fieldName, long recordId) {
        Map<String, FormRelationRecord> relationRecordMap = fromFormDataMasterBean.getFormRelationRecordMap();
        if(relationRecordMap != null) {
            String recordKey = fromFormDataMasterBean.getId() + "_" + fieldName + "_" + recordId;
            relationRecordMap.remove(recordKey);
        }

    }

    private String getRelationType(FormFieldBean fromField, FormFieldBean toField) {
        String fromType = fromField.isMasterField()?"m":"s";
        String toType = toField.isMasterField()?"m":"s";
        return fromType + toType;
    }

    private FormAuthViewFieldBean getApartAuth(FormDataMasterBean cacheMasterData, FormFieldBean fieldBean, Long recordId) {
        FormAuthViewFieldBean authViewFieldBean = null;
        Map<String, FormAuthViewFieldBean> apartAuthMap = (Map)cacheMasterData.getExtraAttr("apartAuthMap");
        if(apartAuthMap != null) {
            if(fieldBean.isMasterField()) {
                authViewFieldBean = (FormAuthViewFieldBean)apartAuthMap.get(fieldBean.getName());
            } else {
                String authKey = fieldBean.getName() + "_" + recordId;
                authViewFieldBean = (FormAuthViewFieldBean)apartAuthMap.get(authKey);
            }
        }

        return authViewFieldBean;
    }

    public void dealEnumRelation(FormBean formBean, FormDataMasterBean cacheMasterData, FormAuthViewBean authViewBean, FormRelation relation, Long recordId, Map<String, Object> resultMap, long enumId, int level, boolean needRefreshFormRelation) throws BusinessException {
        Object defaultVal = null;
        String fromRelationAttr = relation.getFromRelationAttr();
        String toRelationAttr = relation.getToRelationAttr();
        FormFieldBean fromFieldBean = formBean.getFieldBeanByName(fromRelationAttr);
        FormFieldBean toFieldBean = formBean.getFieldBeanByName(toRelationAttr);
        boolean needHtml = resultMap != null && authViewBean != null;
        boolean isImageRelation = relation.isDataRelationImageEnum();
        Long pVal = Long.valueOf(0L);
        String o;
        if(toFieldBean.isMasterField()) {
            o = String.valueOf(cacheMasterData.getFieldValue(toFieldBean.getName()));
            if(!StringUtil.checkNull(o)) {
                pVal = Long.valueOf(Long.parseLong(o));
            }
        } else {
            o = String.valueOf(cacheMasterData.getFormDataSubBeanById(toFieldBean.getOwnerTableName(), recordId).getFieldValue(toFieldBean.getName()));
            if(!StringUtil.checkNull(o)) {
                pVal = Long.valueOf(Long.parseLong(o));
            }
        }

        List<CtpEnumItem> currentEnums = new ArrayList();
        List relations;
        Iterator var21;
        if(pVal.longValue() != 0L && level > 0 && !isImageRelation) {
            relations = this.enumManagerNew.getEmumItemByEmumId(Long.valueOf(enumId));
            var21 = relations.iterator();

            CtpEnumItem item;
            while(var21.hasNext()) {
                item = (CtpEnumItem)var21.next();
                if(item.getLevelNum() != null && item.getLevelNum().intValue() == level && item.getParentId().longValue() == pVal.longValue() && item.getState().intValue() != 0) {
                    currentEnums.add(item);
                }
            }

            if(Strings.isNotEmpty(currentEnums)) {
                if(currentEnums.size() == 1) {
                    defaultVal = ((CtpEnumItem)currentEnums.get(0)).getId();
                } else {
                    Object oldVal = cacheMasterData.getFieldValue(fromFieldBean.getName());
                    if(oldVal != null && Long.parseLong(oldVal.toString()) != 0L && currentEnums.size() > 1) {
                        item = this.enumManagerNew.getCtpEnumItem(Long.valueOf(Long.parseLong(oldVal.toString())));
                        if(item != null && currentEnums.contains(item)) {
                            defaultVal = oldVal;
                        }
                    }
                }
            }
        }

        if(toFieldBean.isMasterField() && fromFieldBean.isMasterField()) {
            if(isImageRelation) {
                defaultVal = cacheMasterData.getFieldValue(toFieldBean.getName());
            }

            cacheMasterData.addFieldValue(fromFieldBean.getName(), defaultVal);
            if(fromFieldBean.isInCalculate() || fromFieldBean.isInCondition()) {
                this.formDataManager.calcAllWithFieldIn(formBean, fromFieldBean, cacheMasterData, recordId, resultMap, authViewBean, true, true);
            }

            if(needHtml) {
                FormAuthViewFieldBean authViewFieldBean = authViewBean.getFormAuthorizationField(fromFieldBean.getName());
                FormAuthViewFieldBean newAuthViewFieldBean = this.getApartAuth(cacheMasterData, fromFieldBean, recordId);
                if(newAuthViewFieldBean != null) {
                    authViewFieldBean = newAuthViewFieldBean;
                }

                String htmlStr = FormFieldComEnum.getHTML(formBean, fromFieldBean, authViewFieldBean, cacheMasterData);
                resultMap.put(fromFieldBean.getName(), htmlStr);
            }

            relations = formBean.getEnumRelationByParent(fromFieldBean);
            var21 = relations.iterator();

            while(var21.hasNext()) {
                FormRelation tempRelation = (FormRelation)var21.next();
                this.dealEnumRelation(formBean, cacheMasterData, authViewBean, tempRelation, recordId, resultMap, enumId, level + 1, needRefreshFormRelation);
            }
        } else if(toFieldBean.isMasterField() && !fromFieldBean.isMasterField()) {
            relations = cacheMasterData.getSubData(fromFieldBean.getOwnerTableName());
            if(isImageRelation) {
                defaultVal = cacheMasterData.getFieldValue(toFieldBean.getName());
            }

            var21 = relations.iterator();

            while(var21.hasNext()) {
                FormDataSubBean subData = (FormDataSubBean)var21.next();
                Long tempRecordId = subData.getId();
                if(!isImageRelation && currentEnums.size() > 1) {
                    Object oldVal = subData.getFieldValue(fromFieldBean.getName());
                    if(oldVal != null && Long.parseLong(oldVal.toString()) != 0L) {
                        CtpEnumItem item = this.enumManagerNew.getCtpEnumItem(Long.valueOf(Long.parseLong(oldVal.toString())));
                        if(item != null && currentEnums.contains(item)) {
                            defaultVal = oldVal;
                        }
                    } else {
                        defaultVal = Long.valueOf(0L);
                    }
                }

                String htmlStr;
                FormAuthViewFieldBean authViewFieldBean;
                FormAuthViewFieldBean newAuthViewFieldBean;
                if(recordId.longValue() != 0L) {
                    if(tempRecordId.longValue() == recordId.longValue()) {
                        subData.addFieldValue(fromFieldBean.getName(), defaultVal);
                        if(fromFieldBean.isInCalculate() || fromFieldBean.isInCondition()) {
                            this.formDataManager.calcAllWithFieldIn(formBean, fromFieldBean, cacheMasterData, tempRecordId, resultMap, authViewBean, true, true);
                        }

                        cacheMasterData.putExtraAttr("recordId", subData.getId().longValue());
                        if(needHtml) {
                            authViewFieldBean = authViewBean.getFormAuthorizationField(fromFieldBean.getName());
                            newAuthViewFieldBean = this.getApartAuth(cacheMasterData, fromFieldBean, recordId);
                            if(newAuthViewFieldBean != null) {
                                authViewFieldBean = newAuthViewFieldBean;
                            }

                            htmlStr = FormFieldComEnum.getHTML(formBean, fromFieldBean, authViewFieldBean, subData);
                            resultMap.put(fromFieldBean.getName() + "_" + subData.getId(), htmlStr);
                        }
                        break;
                    }
                } else {
                    cacheMasterData.putExtraAttr("recordId", subData.getId().longValue());
                    subData.addFieldValue(fromFieldBean.getName(), defaultVal);
                    if(fromFieldBean.isInCalculate() || fromFieldBean.isInCondition()) {
                        this.formDataManager.calcAllWithFieldIn(formBean, fromFieldBean, cacheMasterData, tempRecordId, resultMap, authViewBean, true, true);
                    }

                    if(needHtml) {
                        authViewFieldBean = authViewBean.getFormAuthorizationField(fromFieldBean.getName());
                        newAuthViewFieldBean = this.getApartAuth(cacheMasterData, fromFieldBean, ((FormDataSubBean)cacheMasterData.getSubData(fromFieldBean.getOwnerTableName()).get(0)).getId());
                        if(newAuthViewFieldBean != null) {
                            authViewFieldBean = newAuthViewFieldBean;
                        }

                        htmlStr = FormFieldComEnum.getHTML(formBean, fromFieldBean, authViewFieldBean, subData);
                        resultMap.put(fromFieldBean.getName() + "_" + subData.getId(), htmlStr);
                    }
                }

                relations = formBean.getEnumRelationByParent(fromFieldBean);
                Iterator var49 = relations.iterator();

                while(var49.hasNext()) {
                    FormRelation tempRelation = (FormRelation)var49.next();
                    this.dealEnumRelation(formBean, cacheMasterData, authViewBean, tempRelation, subData.getId(), resultMap, enumId, level + 1, needRefreshFormRelation);
                }

                if(!toFieldBean.isMasterField()) {
                    defaultVal = Long.valueOf(0L);
                }
            }
        } else if(!toFieldBean.isMasterField() && !fromFieldBean.isMasterField()) {
            if(recordId.longValue() == 0L || recordId.longValue() == -1L) {
                throw new BusinessException("inner table field enum relation must need recordId,but input:" + recordId + " .");
            }

            FormDataSubBean currentLine = null;
            List<FormDataSubBean> subDataLines = cacheMasterData.getSubData(fromFieldBean.getOwnerTableName());
            Iterator var33 = subDataLines.iterator();

            while(var33.hasNext()) {
                FormDataSubBean subData = (FormDataSubBean)var33.next();
                Long tempRecordId = subData.getId();
                if(tempRecordId.longValue() == recordId.longValue()) {
                    currentLine = subData;
                    break;
                }
            }

            if(currentLine == null) {
                throw new BusinessException("input recordId is not find in cache,recordId:" + recordId + " .");
            }

            if(isImageRelation) {
                defaultVal = currentLine.getFieldValue(toFieldBean.getName());
            } else if(currentEnums.size() > 1) {
                Object oldVal = currentLine.getFieldValue(fromFieldBean.getName());
                if(oldVal != null && Long.parseLong(oldVal.toString()) != 0L) {
                    CtpEnumItem item = this.enumManagerNew.getCtpEnumItem(Long.valueOf(Long.parseLong(oldVal.toString())));
                    if(item != null && currentEnums.contains(item)) {
                        defaultVal = oldVal;
                    }
                }
            }

            currentLine.addFieldValue(fromFieldBean.getName(), defaultVal);
            if(fromFieldBean.isInCalculate() || fromFieldBean.isInCondition()) {
                this.formDataManager.calcAllWithFieldIn(formBean, fromFieldBean, cacheMasterData, currentLine.getId(), resultMap, authViewBean, true, true);
            }

            cacheMasterData.putExtraAttr("recordId", currentLine.getId().longValue());
            if(needHtml) {
                FormAuthViewFieldBean authViewFieldBean = authViewBean.getFormAuthorizationField(fromFieldBean.getName());
                FormAuthViewFieldBean newAuthViewFieldBean = this.getApartAuth(cacheMasterData, fromFieldBean, currentLine.getId());
                if(newAuthViewFieldBean != null) {
                    authViewFieldBean = newAuthViewFieldBean;
                }

                String htmlStr = FormFieldComEnum.getHTML(formBean, fromFieldBean, authViewFieldBean, currentLine);
                resultMap.put(fromFieldBean.getName() + "_" + recordId, htmlStr);
            }

             relations = formBean.getEnumRelationByParent(fromFieldBean);
            Iterator var38 = relations.iterator();

            while(var38.hasNext()) {
                FormRelation tempRelation = (FormRelation)var38.next();
                this.dealEnumRelation(formBean, cacheMasterData, authViewBean, tempRelation, recordId, resultMap, enumId, level + 1, needRefreshFormRelation);
            }
        }

        if(cacheMasterData.getExtraAttr("recordId") != null) {
            cacheMasterData.getExtraMap().remove("recordId");
        }

    }

    public String dealMultiEnumRelation(Map<String, Object> params) {
        Long recordId = ParamUtil.getLong(params, "recordId", Long.valueOf(-1L));
        String fieldName = ParamUtil.getString(params, "fieldName");
        Long formId = ParamUtil.getLong(params, "formId");
        Long formMasterId = ParamUtil.getLong(params, "formMasterId");
        Long rightId = ParamUtil.getLong(params, "rightId");
        String currentEnumItemValue = ParamUtil.getString(params, "currentEnumItemValue");
        Long enumId = Long.valueOf(0L);
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormDataMasterBean cacheMasterData = this.formManager.getSessioMasterDataBean(formMasterId);
        List<FormViewBean> formViewBeans = formBean.getFormViewList();
        FormAuthViewBean authViewBean = null;
        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            authViewBean = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(authViewBean == null) {
            Iterator var13 = formViewBeans.iterator();

            while(var13.hasNext()) {
                FormViewBean formViewBean = (FormViewBean)var13.next();
                authViewBean = formViewBean.getAuthorizaton(rightId.longValue());
                if(authViewBean != null) {
                    break;
                }
            }
        }

        FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
        int level = fieldBean.getEnumLevel();
        if(level == 0) {
            enumId = Long.valueOf(fieldBean.getEnumId());
        } else {
            Map<String, Object> param = FormFieldComEnum.getEnumInfoByCurrentField(fieldBean);
            enumId = (Long)param.get("enumId");
        }

        List<FormRelation> relations = formBean.getEnumRelationByParent(fieldBean);
        Map<String, Object> resultMap = new DataContainer();
        DataContainer dc = new DataContainer();

        try {
            if(fieldBean.isMasterField()) {
                cacheMasterData.addFieldValue(fieldBean.getName(), currentEnumItemValue);
            } else {
                if(recordId == null || recordId.longValue() == 0L || recordId.longValue() == -1L) {
                    throw new BusinessException("inner table field enum relation must need recordId,but input:" + recordId + " .");
                }

                List<FormDataSubBean> subDatas = cacheMasterData.getSubData(fieldBean.getOwnerTableName());
                Iterator var19 = subDatas.iterator();

                while(var19.hasNext()) {
                    FormDataSubBean subData = (FormDataSubBean)var19.next();
                    if(subData.getId().longValue() == recordId.longValue()) {
                        subData.addFieldValue(fieldBean.getName(), currentEnumItemValue);
                        break;
                    }
                }
            }

            Iterator var29 = relations.iterator();

            while(var29.hasNext()) {
                FormRelation relation = (FormRelation)var29.next();
                this.dealEnumRelation(formBean, cacheMasterData, authViewBean, relation, recordId, resultMap, enumId.longValue(), level + 1, true);
            }

            if(fieldBean.isInCalculate() || fieldBean.isInCondition()) {
                this.formDataManager.calcAllWithFieldIn(formBean, fieldBean, cacheMasterData, recordId, resultMap, authViewBean, true, true);
            }

            resultMap.putAll(this.formDataManager.dealFormRightChangeResult(formBean, authViewBean, cacheMasterData));
            if(null != cacheMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }
        } catch (BusinessException var24) {
            dc.add("success", "false");
            dc.add("errorMsg", StringUtil.toString(var24));
            LOGGER.error(var24.getMessage(), var24);
        } finally {
            if(FormUtil.isH5()) {
                FormUtil.putInfoToThreadContent(cacheMasterData, formBean, authViewBean);
            }

            dc.add("success", "true");
            dc.put("results", resultMap);
        }

        return dc.getJson();
    }

    public String transFormRelationRecord(Map<String, Object> params) throws BusinessException {
        return this.transFormRelationRecordMap(params).getJson();
    }

    public DataContainer transFormRelationRecordMap(Map<String, Object> params) throws BusinessException {
        Long formId = ParamUtil.getLong(params, "formId");
        String fieldName = ParamUtil.getString(params, "fieldName");
        String text = ParamUtil.getString(params, "text");
        Long recordId = ParamUtil.getLong(params, "recordId");
        Long formMasterDataId = ParamUtil.getLong(params, "formMasterDataId");
        FormDataMasterBean masterDataBean = this.formManager.getSessioMasterDataBean(formMasterDataId);
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
        Map<String, FormRelationRecord> relationRecordMap = this.getFormRelationMap(formMasterDataId);
        if(masterDataBean != null) {
            relationRecordMap.putAll(masterDataBean.getFormRelationRecordMap());
        }
        System.out.println("data is filled:"+relationRecordMap.size());
        List<FormRelation> relations = this.getFieldBeanRelations(fieldBean, formBean, ToRelationAttrType.form_relation_field);
        relations.addAll(this.getFieldBeanRelations(fieldBean, formBean, ToRelationAttrType.form_relation_flow));
        relations.addAll(this.getFieldBeanRelations(fieldBean, formBean, ToRelationAttrType.form_relation_formContent));
        FormRelation currentRelation = null;
        Iterator var13 = relations.iterator();
        System.out.println("releation is queryed:"+relations.size());
        while(var13.hasNext()) {
            FormRelation relation = (FormRelation)var13.next();
            if(relation.getFromRelationAttr().equals(fieldName)) {
                currentRelation = relation;
                break;
            }
        }

        Long toFormId = currentRelation.getToRelationObj();
        FormBean toFormBean = this.formCacheManager.getForm(toFormId.longValue());
        FormAuthViewBean tempOperation = null;
        FormRelationRecord record = (FormRelationRecord)relationRecordMap.get(formMasterDataId + "_" + fieldBean.getName() + "_" + recordId);
        System.out.println("record is queryed:"+record==null?"null": JSON.toJSONString(record));
        DataContainer dc = new DataContainer();
        String errorMst = "";
        String success = "true";
        if(toFormBean == null) {
            success = "false";
            errorMst = ResourceUtil.getString("表单已经被删除");
        } else if(record != null) {
            Map contentParam = new HashMap();
            if(toFormBean.getFormType() == FormType.processesForm.getKey()) {
                contentParam.put("moduleType", Integer.valueOf(ModuleType.collaboration.getKey()));
            } else if(toFormBean.getFormType() == FormType.baseInfo.getKey()) {
                contentParam.put("moduleType", Integer.valueOf(ModuleType.unflowBasic.getKey()));
            } else if(toFormBean.getFormType() == FormType.manageInfo.getKey()) {
                contentParam.put("moduleType", Integer.valueOf(ModuleType.unflowInfo.getKey()));
            } else if(toFormBean.getFormType() == FormType.planForm.getKey()) {
                contentParam.put("moduleType", Integer.valueOf(ModuleType.plan.getKey()));
            }

            contentParam.put("moduleId", record.getToMasterDataId());
            contentParam.put("contentTemplateId", toFormBean.getId());
            System.out.println("contentParam:"+contentParam);
            List<CtpContentAll> contentAllBeans = MainbodyService.getInstance().getContentList(contentParam);
            if(contentAllBeans==null||contentAllBeans.size()==0){
                contentParam.remove("moduleId");
                contentParam.put("contentDataId",record.getToMasterDataId());
                contentAllBeans = MainbodyService.getInstance().getContentList(contentParam);
            }
            System.out.println("contentAllBeans:"+contentAllBeans.size());

            String rightId;
            Long tempLateId;
            List contentAlls;
            if(toFormBean.getFormType() != FormType.baseInfo.getKey() && toFormBean.getFormType() != FormType.manageInfo.getKey()) {
                if(toFormBean.getFormType() == FormType.processesForm.getKey()) {
                    if(contentAllBeans != null && contentAllBeans.size() > 0) {
                        tempLateId = ((CtpContentAll)contentAllBeans.get(0)).getModuleTemplateId();
                        CtpTemplate template = this.templateManager.getCtpTemplate(tempLateId);
                        FormAuthViewBean readOnlyAuth;
                        if(template == null) {
                            dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getModuleId());
                            contentAlls = toFormBean.getAllFormAuthViewBeans();
                             readOnlyAuth = null;
                            Iterator var42 = contentAlls.iterator();

                            while(var42.hasNext()) {
                                readOnlyAuth = (FormAuthViewBean)var42.next();
                                if(readOnlyAuth.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                    readOnlyAuth = readOnlyAuth;
                                    break;
                                }
                            }

                            if(readOnlyAuth != null) {
                                dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getModuleId());
                                dc.put("rightId", readOnlyAuth.getFormViewId() + "." + readOnlyAuth.getId());
                            } else {
                                LOGGER.error("没有设置只读权限，穿透无法完成");
                            }
                        } else {
                            ProcessTemplateManager p = (ProcessTemplateManager)AppContext.getBean("processTemplateManager");
                            ProcessTemplete t = p.selectProcessTemplateById(template.getWorkflowId());
                            if(t == null) {
                                dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getModuleId());
                                List<FormAuthViewBean> auths = toFormBean.getAllFormAuthViewBeans();
                                readOnlyAuth = null;
                                Iterator var44 = auths.iterator();

                                while(var44.hasNext()) {
                                    FormAuthViewBean auth = (FormAuthViewBean)var44.next();
                                    if(auth.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                        readOnlyAuth = auth;
                                        break;
                                    }
                                }

                                if(readOnlyAuth != null) {
                                    dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getModuleId());
                                    dc.put("rightId", readOnlyAuth.getFormViewId() + "." + readOnlyAuth.getId());
                                } else {
                                    LOGGER.error("没有设置只读权限，穿透无法完成");
                                }
                            } else {
                                rightId = this.wapi.getNodeFormOperationName(template.getWorkflowId(), (String)null);
                                tempOperation = toFormBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(rightId)));
                                if(tempOperation != null) {
                                    dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getModuleId());
                                    dc.put("rightId", tempOperation.getFormViewId() + "." + tempOperation.getId());
                                } else {
                                    dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getModuleId());
                                    List<FormAuthViewBean> auths = toFormBean.getAllFormAuthViewBeans();
                                     readOnlyAuth = null;
                                    Iterator var29 = auths.iterator();

                                    while(var29.hasNext()) {
                                        FormAuthViewBean auth = (FormAuthViewBean)var29.next();
                                        if(auth.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                            readOnlyAuth = auth;
                                            break;
                                        }
                                    }

                                    if(readOnlyAuth != null) {
                                        dc.put("rightId", readOnlyAuth.getFormViewId() + "." + readOnlyAuth.getId());
                                    } else {
                                        LOGGER.error("没有设置只读权限，穿透无法完成");
                                    }
                                }
                            }
                        }
                    } else {
                        success = "false";
                        LOGGER.info("没有找到底表数据，数据Id" + formMasterDataId + ";底表数据Id：" + record.getToMasterDataId() + ";底表formId : " + toFormBean.getId() + ";ModuleType:" + contentParam.get("moduleType"));
                        errorMst = ResourceUtil.getString("form.relation.collaborationdel.before") + text + ResourceUtil.getString("form.relation.collaborationdel.after");
                    }
                }
            } else if(contentAllBeans != null && contentAllBeans.size() > 0) {
                dc.put("dataId", "" + ((CtpContentAll)contentAllBeans.get(0)).getContentDataId());
                if(toFormBean.getFormType() == FormType.manageInfo.getKey()) {
                    tempLateId = ((CtpContentAll)contentAllBeans.get(0)).getModuleTemplateId();
                    Map<String, Object> param = new HashMap();
                    param.put("id", tempLateId);
                    contentAlls = MainbodyService.getInstance().getContentList(param);
                    List<FormBindAuthBean> binds = toFormBean.getBind().getUnflowFormBindAuthByUserId(Long.valueOf(AppContext.currentUserId()));
                    rightId = "";
                    if(binds.size() > 0) {
                        rightId = ((FormBindAuthBean)binds.get(0)).getShowFormAuth();
                        dc.put("rightId", rightId == null?"":rightId.replaceAll("[|]", "_"));
                    } else if(contentAlls.size() > 0) {
                        FormBindAuthBean tempAuthBean = toFormBean.getBind().getFormBindAuthBean(String.valueOf(((CtpContentAll)contentAlls.get(0)).getModuleId()));
                        if(tempAuthBean == null) {
                            success = "false";
                            errorMst = ResourceUtil.getString("没有权限查看此数据。");
                        } else {
                            rightId = tempAuthBean.getShowFormAuth();
                            dc.put("rightId", rightId == null?"":rightId.replaceAll("[|]", "_"));
                        }
                    } else {
                        success = "false";
                        errorMst = ResourceUtil.getString("没有权限查看此数据。");
                    }
                } else {
                    List<FormAuthViewBean> operations = ((FormViewBean)toFormBean.getFormViewList().get(0)).getOperations();
                    Iterator var23 = operations.iterator();

                    while(var23.hasNext()) {
                        FormAuthViewBean operation = (FormAuthViewBean)var23.next();
                        if(operation.getType().equals(FormAuthorizationType.show.getKey())) {
                            tempOperation = operation;
                            break;
                        }
                    }

                    dc.put("rightId", tempOperation.getFormViewId() + "." + tempOperation.getId());
                }
            } else {
                success = "false";
                LOGGER.info("没有找到底表数据，数据Id" + formMasterDataId + ";底表数据Id：" + record.getToMasterDataId() + ";底表formId : " + toFormBean.getId() + ";ModuleType:" + contentParam.get("moduleType"));
                errorMst = ResourceUtil.getString("form.relation.formdata.deleted");
            }

            if("true".equals(success)) {
                dc.put("success", "true");
                dc.put("record", record.toJSON());
                dc.put("title", ((CtpContentAll)contentAllBeans.get(0)).getTitle());
                dc.put("formType", Integer.valueOf(toFormBean.getFormType()));
            }
        } else if(toFormBean.getFormType() != FormType.baseInfo.getKey() && toFormBean.getFormType() != FormType.manageInfo.getKey()) {
            success = "false";
            errorMst = ResourceUtil.getString("form.relation.collaborationdel.before") + text + ResourceUtil.getString("form.relation.collaborationdel.after");
        } else {
            success = "false";
            LOGGER.info("没有找到关联formRelationRecord记录，数据Id" + formMasterDataId + ";字段名称：" + fieldName + ";recordId : " + recordId);
            if(relationRecordMap.isEmpty()) {
                LOGGER.info("关联记录为空------------------------------------------");
            }

            errorMst = ResourceUtil.getString("form.relation.formdata.deleted");
        }

        if("false".equals(success)) {
            dc.put("success", success);
            dc.put("errorMsg", errorMst);
        }

        return dc;
    }

    public String dealOrgFieldRelation(Map<String, Object> params) throws Exception {
        Long orgId = null;
        if(!StringUtil.checkNull(String.valueOf(params.get("orgId")))) {
            orgId = ParamUtil.getLong(params, "orgId");
        }

        String selectType = ParamUtil.getString(params, "selectType");
        ToRelationAttrType toRelationAttrType = ToRelationAttrType.data_relation_member;
        if(selectType != null && selectType.equalsIgnoreCase(FormModuleAuthOrgType.Department.getText())) {
            toRelationAttrType = ToRelationAttrType.data_relation_department;
        } else if(selectType != null && selectType.equalsIgnoreCase(FormModuleAuthOrgType.Member.getText())) {
            toRelationAttrType = ToRelationAttrType.data_relation_member;
        }

        String fieldName = ParamUtil.getString(params, "fieldName");
        Long rightId = ParamUtil.getLong(params, "rightId");
        Long formId = ParamUtil.getLong(params, "formId");
        Long formDataId = ParamUtil.getLong(params, "formDataId");
        Long recordId = ParamUtil.getLong(params, "recordId");
        FormDataMasterBean cacheMasterData = this.formManager.getSessioMasterDataBean(formDataId);
        Map<String, Object> resultMap = new DataContainer();
        FormBean currentForm = this.formCacheManager.getForm(formId.longValue());
        FormFieldBean fieldBean = currentForm.getFieldBeanByName(fieldName);
        FormDataBean formData = null;
        if(fieldBean.isMasterField()) {
            formData = cacheMasterData;
        } else {
            formData = cacheMasterData.getFormDataSubBeanById(fieldBean.getOwnerTableName(), recordId);
        }

        Long moduleId = ParamUtil.getLong(params, "moduleId");
        cacheMasterData.putExtraAttr("moduleId", moduleId.longValue());
        ((FormDataBean)formData).addFieldValue(fieldBean.getName(), orgId);
        List<FormViewBean> viewList = currentForm.getFormViewList();
        FormAuthViewBean currentOperation = null;
        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            currentOperation = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(currentOperation == null) {
            Iterator var18 = viewList.iterator();

            while(var18.hasNext()) {
                FormViewBean view = (FormViewBean)var18.next();
                List<FormAuthViewBean> operationList = view.getOperations();
                Iterator var21 = operationList.iterator();

                while(var21.hasNext()) {
                    FormAuthViewBean operation = (FormAuthViewBean)var21.next();
                    if(rightId.longValue() == operation.getId().longValue()) {
                        currentOperation = operation;
                        break;
                    }
                }

                if(currentOperation != null) {
                    break;
                }
            }
        }

        DataContainer dc = new DataContainer();

        try {
            this.dealRelationByType(fieldBean, currentForm, currentOperation, cacheMasterData, resultMap, recordId, toRelationAttrType, true, true);
            boolean hasDealSys = false;
            if(resultMap != null) {
                if(fieldBean.isInCondition() && currentOperation != null) {
                    hasDealSys = true;
                    resultMap.putAll(this.formDataManager.dealSysRelation(currentForm, cacheMasterData, fieldBean, currentOperation, recordId, false, moduleId, true));
                }

                if(currentOperation != null && fieldBean.isInCalculate()) {
                    this.formDataManager.calcAllWithFieldIn(currentForm, fieldBean, cacheMasterData, recordId, resultMap, currentOperation, true, !hasDealSys);
                }

                resultMap.putAll(this.formDataManager.dealFormRightChangeResult(currentForm, currentOperation, cacheMasterData));
            }

            if(null != cacheMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }

            if(FormUtil.isH5()) {
                FormUtil.putInfoToThreadContent(cacheMasterData, currentForm, currentOperation);
            }

            dc.put("success", "true");
            dc.put("results", resultMap);
        } catch (BusinessException var23) {
            dc.put("success", "false");
            dc.put("errorMsg", StringUtil.toString(var23));
            LOGGER.error(var23.getMessage(), var23);
        }

        return dc.getJson();
    }

    public String dealLbsFieldRelation(Map<String, Object> params) {
        Long lbsId = Long.valueOf(0L);
        if(!StringUtil.checkNull(String.valueOf(params.get("lbsId")))) {
            lbsId = ParamUtil.getLong(params, "lbsId");
        }

        ToRelationAttrType toRelationAttrType = ToRelationAttrType.data_relation_map;
        String fieldName = ParamUtil.getString(params, "fieldName");
        Long rightId = ParamUtil.getLong(params, "rightId");
        Long formId = ParamUtil.getLong(params, "formId");
        Long formDataId = ParamUtil.getLong(params, "formDataId");
        Long recordId = ParamUtil.getLong(params, "recordId");
        FormDataMasterBean cacheMasterData = this.formManager.getSessioMasterDataBean(formDataId);
        Map<String, Object> resultMap = new DataContainer();
        FormBean currentForm = this.formCacheManager.getForm(formId.longValue());
        FormFieldBean fieldBean = currentForm.getFieldBeanByName(fieldName);
        FormDataBean formData = null;
        if(fieldBean.isMasterField()) {
            formData = cacheMasterData;
        } else {
            formData = cacheMasterData.getFormDataSubBeanById(fieldBean.getOwnerTableName(), recordId);
        }

        ((FormDataBean)formData).addFieldValue(fieldBean.getName(), lbsId);
        List<FormViewBean> viewList = currentForm.getFormViewList();
        FormAuthViewBean currentOperation = null;
        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            currentOperation = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(currentOperation == null) {
            Iterator var16 = viewList.iterator();

            while(var16.hasNext()) {
                FormViewBean view = (FormViewBean)var16.next();
                List<FormAuthViewBean> operationList = view.getOperations();
                Iterator var19 = operationList.iterator();

                while(var19.hasNext()) {
                    FormAuthViewBean operation = (FormAuthViewBean)var19.next();
                    if(rightId.longValue() == operation.getId().longValue()) {
                        currentOperation = operation;
                        break;
                    }
                }

                if(currentOperation != null) {
                    break;
                }
            }
        }

        DataContainer dc = new DataContainer();

        try {
            this.dealRelationByType(fieldBean, currentForm, currentOperation, cacheMasterData, resultMap, recordId, toRelationAttrType, true, true);
            if(resultMap != null) {
                resultMap.putAll(this.formDataManager.dealFormRightChangeResult(currentForm, currentOperation, cacheMasterData));
            }

            if(null != cacheMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }

            if(FormUtil.isH5()) {
                FormUtil.putInfoToThreadContent(cacheMasterData, currentForm, currentOperation);
            }

            dc.put("success", "true");
            dc.put("results", resultMap);
        } catch (BusinessException var21) {
            dc.put("success", "false");
            dc.put("errorMsg", StringUtil.toString(var21));
            LOGGER.error(var21.getMessage(), var21);
        }

        return dc.getJson();
    }

    public String dealProjectFieldRelation(Map<String, Object> params) {
        Long projectId = Long.valueOf(0L);
        if(!StringUtil.checkNull(String.valueOf(params.get("projectId")))) {
            projectId = ParamUtil.getLong(params, "projectId");
        }

        ToRelationAttrType toRelationAttrType = ToRelationAttrType.data_relation_project;
        String fieldName = ParamUtil.getString(params, "fieldName");
        Long rightId = ParamUtil.getLong(params, "rightId");
        Long formId = ParamUtil.getLong(params, "formId");
        Long formDataId = ParamUtil.getLong(params, "formDataId");
        Long recordId = ParamUtil.getLong(params, "recordId");
        FormDataMasterBean cacheMasterData = this.formManager.getSessioMasterDataBean(formDataId);
        Map<String, Object> resultMap = new DataContainer();
        FormBean currentForm = this.formCacheManager.getForm(formId.longValue());
        FormFieldBean fieldBean = currentForm.getFieldBeanByName(fieldName);
        FormDataBean formData = null;
        if(fieldBean.isMasterField()) {
            formData = cacheMasterData;
        } else {
            formData = cacheMasterData.getFormDataSubBeanById(fieldBean.getOwnerTableName(), recordId);
        }

        DataContainer dc = new DataContainer();
        ((FormDataBean)formData).addFieldValue(fieldBean.getName(), projectId.longValue() == 0L?null:projectId);
        List<FormViewBean> viewList = currentForm.getFormViewList();
        FormAuthViewBean currentOperation = null;
        if(cacheMasterData.getExtraMap().containsKey("viewRight")) {
            currentOperation = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
        }

        if(currentOperation == null) {
            Iterator var17 = viewList.iterator();

            while(var17.hasNext()) {
                FormViewBean view = (FormViewBean)var17.next();
                List<FormAuthViewBean> operationList = view.getOperations();
                Iterator var20 = operationList.iterator();

                while(var20.hasNext()) {
                    FormAuthViewBean operation = (FormAuthViewBean)var20.next();
                    if(rightId.longValue() == operation.getId().longValue()) {
                        currentOperation = operation;
                        break;
                    }
                }

                if(currentOperation != null) {
                    break;
                }
            }
        }

        try {
            this.dealRelationByType(fieldBean, currentForm, currentOperation, cacheMasterData, resultMap, recordId, toRelationAttrType, true, true);
            if(resultMap != null) {
                resultMap.putAll(this.formDataManager.dealFormRightChangeResult(currentForm, currentOperation, cacheMasterData));
            }

            if(null != cacheMasterData.getExtraAttr("viewRight")) {
                FormAuthViewBean currentAuth = (FormAuthViewBean)cacheMasterData.getExtraAttr("viewRight");
                dc.add("viewRight", String.valueOf(currentAuth.getId()));
            }

            dc.put("success", "true");
            dc.put("results", resultMap);
        } catch (BusinessException var22) {
            dc.put("success", "false");
            dc.put("errorMsg", StringUtil.toString(var22));
            LOGGER.error(var22.getMessage(), var22);
        }

        return dc.getJson();
    }

    public Map<String, Object> dealRelationByType(FormFieldBean fieldBean, FormBean currentForm, FormAuthViewBean formAuthViewBean, FormDataMasterBean formDataBean, Map<String, Object> resultMap, Long recordId, ToRelationAttrType toRelationAttrType, boolean needCalc, boolean needRelation) throws BusinessException {
        if(null == toRelationAttrType) {
            return resultMap;
        } else {
            List<FormRelation> relations = this.getFieldBeanRelations(fieldBean, currentForm, toRelationAttrType);
            if(formDataBean == null) {
                return resultMap;
            } else {
                boolean needHtml = false;
                if(resultMap != null && formAuthViewBean != null) {
                    needHtml = true;
                }

                if(relations != null && relations.size() > 0) {
                    Iterator var12 = relations.iterator();

                    while(true) {
                        while(true) {
                            FormRelation relation;
                            FormAuthViewFieldBean auth;
                            do {
                                do {
                                    if(!var12.hasNext()) {
                                        return resultMap;
                                    }

                                    relation = (FormRelation)var12.next();
                                } while(relation.getFromRelationAttr().equals(fieldBean.getName()));

                                auth = null;
                                if(formAuthViewBean == null) {
                                    break;
                                }

                                auth = formAuthViewBean.getFormAuthorizationField(relation.getFromRelationAttr());
                            } while(auth.getAccess().equalsIgnoreCase(FieldAccessType.add.getKey()));

                            String viewAttr = relation.getViewAttr();
                            FormFieldBean tempFieldBean = currentForm.getFieldBeanByName(relation.getFromRelationAttr());
                            Object valObj = null;
                            Object value = null;
                            String fieldHtml;
                            if(fieldBean.isMasterField() && tempFieldBean.isMasterField()) {
                                try {
                                    valObj = formDataBean.getFieldValue(fieldBean.getName());
                                    if(StringUtil.checkNull(String.valueOf(valObj))) {
                                        valObj = Long.valueOf(0L);
                                    }

                                    value = FormRelationEnums.getRelationValue(viewAttr, toRelationAttrType, Long.valueOf(Long.parseLong(String.valueOf(valObj))), tempFieldBean);
                                    formDataBean.addFieldValue(tempFieldBean.getName(), value);
                                    FormFieldBean tempRealFieldBean = tempFieldBean.findRealFieldBean();
                                    this.dealRelationByType(tempFieldBean, currentForm, formAuthViewBean, formDataBean, resultMap, recordId, tempRealFieldBean.getPossibleRelationAttrType(), needCalc, needRelation);
                                    if(needRelation && tempFieldBean.isInCondition()) {
                                        if(needHtml) {
                                            resultMap.putAll(this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, recordId, false, (Long)null, needHtml));
                                        } else {
                                            this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, recordId, false, (Long)null, needHtml);
                                        }
                                    }

                                    if(needCalc && tempFieldBean.isInCalculate()) {
                                        this.formDataManager.calcAllWithFieldIn(currentForm, tempFieldBean, formDataBean, recordId, resultMap, formAuthViewBean, needHtml, needRelation);
                                    }

                                    if(needHtml) {
                                        fieldHtml = FormFieldComEnum.getHTML(currentForm, currentForm.getFieldBeanByName(relation.getFromRelationAttr()), auth, formDataBean);
                                        resultMap.put(relation.getFromRelationAttr(), fieldHtml);
                                    }
                                } catch (NumberFormatException var31) {
                                    LOGGER.error(var31.getMessage(), var31);
                                } catch (Exception var32) {
                                    LOGGER.error(var32.getMessage(), var32);
                                }
                            } else {
                                List subDatas;
                                Iterator var20;
                                FormDataSubBean subData;

                                if(fieldBean.isMasterField() && tempFieldBean.isSubField()) {
                                    if(formDataBean.getSubTables() != null) {
                                        valObj = formDataBean.getFieldValue(fieldBean.getName());
                                        if(StringUtil.checkNull(String.valueOf(valObj))) {
                                            valObj = Long.valueOf(0L);
                                        }

                                        if(recordId != null && recordId.longValue() != 0L && recordId.longValue() != -1L) {
                                            subData = formDataBean.getFormDataSubBeanById(tempFieldBean.getOwnerTableName(), recordId);
                                            if(subData != null) {
                                                try {
                                                    value = FormRelationEnums.getRelationValue(viewAttr, toRelationAttrType, Long.valueOf(Long.parseLong(String.valueOf(valObj))), tempFieldBean);
                                                    subData.addFieldValue(tempFieldBean.getName(), value);
                                                    this.dealRelationByType(tempFieldBean, currentForm, formAuthViewBean, formDataBean, resultMap, subData.getId(), tempFieldBean.findRealFieldBean().getPossibleRelationAttrType(), needCalc, needRelation);
                                                    if(needRelation) {
                                                        if(needHtml) {
                                                            resultMap.putAll(this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, subData.getId(), false, (Long)null, needHtml));
                                                        } else {
                                                            this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, subData.getId(), false, (Long)null, needHtml);
                                                        }
                                                    }

                                                    if(needCalc && tempFieldBean.isInCalculate()) {
                                                        this.formDataManager.calcAllWithFieldIn(currentForm, tempFieldBean, formDataBean, subData.getId(), resultMap, formAuthViewBean, needHtml, needRelation);
                                                    }

                                                    if(needHtml) {
                                                        fieldHtml = FormFieldComEnum.getHTML(currentForm, currentForm.getFieldBeanByName(relation.getFromRelationAttr()), auth, subData);
                                                        resultMap.put(relation.getFromRelationAttr() + "_" + subData.getId(), fieldHtml);
                                                    }
                                                } catch (NumberFormatException var27) {
                                                    throw new BusinessException(var27);
                                                } catch (Exception var28) {
                                                    throw new BusinessException(var28);
                                                }
                                            }
                                        } else {
                                            subDatas = formDataBean.getSubData(tempFieldBean.getOwnerTableName());
                                            if(Strings.isNotEmpty(subDatas)) {
                                                var20 = subDatas.iterator();

                                                while(var20.hasNext()) {
                                                    subData = (FormDataSubBean)var20.next();

                                                    try {
                                                        value = FormRelationEnums.getRelationValue(viewAttr, toRelationAttrType, Long.valueOf(Long.parseLong(String.valueOf(valObj))), tempFieldBean);
                                                        subData.addFieldValue(tempFieldBean.getName(), value);
                                                        this.dealRelationByType(tempFieldBean, currentForm, formAuthViewBean, formDataBean, resultMap, subData.getId(), tempFieldBean.findRealFieldBean().getPossibleRelationAttrType(), needCalc, needRelation);
                                                        if(needRelation) {
                                                            if(needHtml) {
                                                                resultMap.putAll(this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, subData.getId(), false, (Long)null, needHtml));
                                                            } else {
                                                                this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, subData.getId(), false, (Long)null, needHtml);
                                                            }
                                                        }

                                                        if(needCalc && tempFieldBean.isInCalculate()) {
                                                            this.formDataManager.calcAllWithFieldIn(currentForm, tempFieldBean, formDataBean, subData.getId(), resultMap, formAuthViewBean, needHtml, needRelation);
                                                        }

                                                        if(needHtml) {
                                                            fieldHtml = FormFieldComEnum.getHTML(currentForm, currentForm.getFieldBeanByName(relation.getFromRelationAttr()), auth, subData);
                                                            resultMap.put(relation.getFromRelationAttr() + "_" + subData.getId(), fieldHtml);
                                                        }
                                                    } catch (NumberFormatException var29) {
                                                        throw new BusinessException(var29);
                                                    } catch (Exception var30) {
                                                        throw new BusinessException(var30);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else if(fieldBean.isSubField() && tempFieldBean.isSubField()) {
                                    if((recordId == null || recordId.longValue() != 0L && recordId.longValue() != -1L) && recordId != null) {
                                        subData = formDataBean.getFormDataSubBeanById(tempFieldBean.getOwnerTableName(), recordId);
                                        valObj = subData.getFieldValue(fieldBean.getName());
                                        if(StringUtil.checkNull(String.valueOf(valObj))) {
                                            valObj = Long.valueOf(0L);
                                        }

                                        try {
                                            value = FormRelationEnums.getRelationValue(viewAttr, toRelationAttrType, Long.valueOf(Long.parseLong(String.valueOf(valObj))), tempFieldBean);
                                            subData.addFieldValue(tempFieldBean.getName(), value);
                                            this.dealRelationByType(tempFieldBean, currentForm, formAuthViewBean, formDataBean, resultMap, subData.getId(), tempFieldBean.findRealFieldBean().getPossibleRelationAttrType(), needCalc, needRelation);
                                            if(needRelation) {
                                                if(needHtml) {
                                                    resultMap.putAll(this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, recordId, false, (Long)null, needHtml));
                                                } else {
                                                    this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, recordId, false, (Long)null, needHtml);
                                                }
                                            }

                                            if(needCalc && tempFieldBean.isInCalculate()) {
                                                this.formDataManager.calcAllWithFieldIn(currentForm, tempFieldBean, formDataBean, subData.getId(), resultMap, formAuthViewBean, needHtml, needRelation);
                                            }

                                            if(needHtml) {
                                                fieldHtml = FormFieldComEnum.getHTML(currentForm, currentForm.getFieldBeanByName(relation.getFromRelationAttr()), auth, subData);
                                                resultMap.put(relation.getFromRelationAttr() + "_" + subData.getId(), fieldHtml);
                                            }
                                        } catch (NumberFormatException var23) {
                                            throw new BusinessException(var23);
                                        } catch (Exception var24) {
                                            throw new BusinessException(var24);
                                        }
                                    } else {
                                        subDatas = formDataBean.getSubData(tempFieldBean.getOwnerTableName());
                                        var20 = subDatas.iterator();

                                        while(var20.hasNext()) {
                                            subData = (FormDataSubBean)var20.next();
                                            valObj = subData.getFieldValue(fieldBean.getName());
                                            if(StringUtil.checkNull(String.valueOf(valObj))) {
                                                valObj = Long.valueOf(0L);
                                            }

                                            try {
                                                value = FormRelationEnums.getRelationValue(viewAttr, toRelationAttrType, Long.valueOf(Long.parseLong(String.valueOf(valObj))), tempFieldBean);
                                                subData.addFieldValue(tempFieldBean.getName(), value);
                                                this.dealRelationByType(tempFieldBean, currentForm, formAuthViewBean, formDataBean, resultMap, subData.getId(), tempFieldBean.findRealFieldBean().getPossibleRelationAttrType(), needCalc, needRelation);
                                                if(needRelation) {
                                                    if(needHtml) {
                                                        resultMap.putAll(this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, subData.getId(), false, (Long)null, needHtml));
                                                    } else {
                                                        this.formDataManager.dealSysRelation(currentForm, formDataBean, tempFieldBean, formAuthViewBean, subData.getId(), false, (Long)null, needHtml);
                                                    }
                                                }

                                                if(needCalc && tempFieldBean.isInCalculate()) {
                                                    this.formDataManager.calcAllWithFieldIn(currentForm, tempFieldBean, formDataBean, subData.getId(), resultMap, formAuthViewBean, needHtml, needRelation);
                                                }

                                                if(needHtml) {
                                                    fieldHtml = FormFieldComEnum.getHTML(currentForm, currentForm.getFieldBeanByName(relation.getFromRelationAttr()), auth, subData);
                                                    resultMap.put(relation.getFromRelationAttr() + "_" + subData.getId(), fieldHtml);
                                                }
                                            } catch (NumberFormatException var25) {
                                                throw new BusinessException(var25);
                                            } catch (Exception var26) {
                                                throw new BusinessException(var26);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    return resultMap;
                }
            }
        }
    }

    public void dealAllOrgFieldRelation(FormBean currentForm, FormDataMasterBean formDataBean, FormAuthViewBean formAuthViewBean, boolean needCalc, boolean needRelation) throws BusinessException {
        List<FormFieldBean> fields = currentForm.getAllFieldBeans();
        Iterator var7 = fields.iterator();

        while(true) {
            label81:
            while(var7.hasNext()) {
                FormFieldBean fieldBean = (FormFieldBean)var7.next();
                if(fieldBean.getOutwriteFieldInputType() == FormFieldComEnum.EXTEND_MEMBER) {
                    this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, (Map)null, (Long)null, ToRelationAttrType.data_relation_member, needCalc, needRelation);
                } else if(fieldBean.getOutwriteFieldInputType() == FormFieldComEnum.EXTEND_DEPARTMENT) {
                    this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, (Map)null, (Long)null, ToRelationAttrType.data_relation_department, needCalc, needRelation);
                } else if(fieldBean.getOutwriteFieldInputType() == FormFieldComEnum.MAP_MARKED) {
                    this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, (Map)null, (Long)null, ToRelationAttrType.data_relation_map, needCalc, needRelation);
                } else if(fieldBean.getOutwriteFieldInputType() == FormFieldComEnum.EXTEND_PROJECT) {
                    this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, (Map)null, (Long)null, ToRelationAttrType.data_relation_project, needCalc, needRelation);
                } else if((fieldBean.getOutwriteFieldInputType() == FormFieldComEnum.RELATION || fieldBean.getOutwriteFieldInputType() == FormFieldComEnum.RELATIONFORM) && (FormFieldComEnum.getEnumByKey(fieldBean.getRealInputType()) == FormFieldComEnum.EXTEND_MEMBER || FormFieldComEnum.getEnumByKey(fieldBean.getRealInputType()) == FormFieldComEnum.EXTEND_MULTI_MEMBER)) {
                    this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, (Map)null, (Long)null, ToRelationAttrType.data_relation_member, needCalc, needRelation);
                } else if(fieldBean.getOutwriteFieldInputType() != FormFieldComEnum.RELATION && fieldBean.getOutwriteFieldInputType() != FormFieldComEnum.RELATIONFORM || FormFieldComEnum.getEnumByKey(fieldBean.getRealInputType()) != FormFieldComEnum.EXTEND_DEPARTMENT && FormFieldComEnum.getEnumByKey(fieldBean.getRealInputType()) != FormFieldComEnum.EXTEND_MULTI_DEPARTMENT) {
                    if(fieldBean.getInputTypeEnum() == FormFieldComEnum.SELECT) {
                        List<FormRelation> relations = currentForm.getEnumRelationByParent(fieldBean);
                        Long enumId = Long.valueOf(fieldBean.getEnumId());
                        Iterator var11 = relations.iterator();

                        while(true) {
                            while(true) {
                                if(!var11.hasNext()) {
                                    continue label81;
                                }

                                FormRelation relation = (FormRelation)var11.next();
                                FormFieldBean toFieldBean = currentForm.getFieldBeanByName(relation.getToRelationAttr());
                                if(toFieldBean.isMasterField()) {
                                    this.dealEnumRelation(currentForm, formDataBean, formAuthViewBean, relation, Long.valueOf(0L), (Map)null, enumId.longValue(), 1, needRelation);
                                } else {
                                    List<FormDataSubBean> subBeans = formDataBean.getSubData(toFieldBean.getOwnerTableName());
                                    Iterator var15 = subBeans.iterator();

                                    while(var15.hasNext()) {
                                        FormDataSubBean subBean = (FormDataSubBean)var15.next();
                                        this.dealEnumRelation(currentForm, formDataBean, formAuthViewBean, relation, subBean.getId(), (Map)null, enumId.longValue(), 1, needRelation);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, (Map)null, (Long)null, ToRelationAttrType.data_relation_department, needCalc, needRelation);
                }
            }

            return;
        }
    }

    public Map<String, Object> dealRelation(FormFieldBean fieldBean, FormBean currentForm, FormAuthViewBean formAuthViewBean, FormDataMasterBean formDataBean, Map<String, Object> resultMap, Long recordId, ToRelationAttrType toRelationAttrType) throws BusinessException {
        return this.dealRelationByType(fieldBean, currentForm, formAuthViewBean, formDataBean, resultMap, recordId, toRelationAttrType, true, true);
    }

    public void dealAllOrgFieldRelation(FormBean form, FormDataMasterBean formDataBean, FormAuthViewBean formAuthViewBean) throws BusinessException {
        this.dealAllOrgFieldRelation(form, formDataBean, formAuthViewBean, true, true);
    }

    public boolean isExistFieldToRelation(String formId, String fieldName) throws BusinessException {
        if(formId != null && !"".equals(formId) && !"-1".equals(formId)) {
            List<FormRelation> list = this.formRelationDAO.selectByField(Long.valueOf(Long.parseLong(formId)), fieldName);
            if(null != list && list.size() > 0) {
                return true;
            }
        }

        return false;
    }

    public String getFieldToRelationStr(String fieldName) throws BusinessException {
        FormBean currentForm = this.formManager.getEditingForm();
        Long formId = currentForm.getId();
        StringBuilder sb = new StringBuilder();
        if(formId != null && formId.longValue() != -1L) {
            List<FormRelation> list = this.formRelationDAO.selectByField(formId, fieldName);
            Map<Long, FormBean> mapId = new HashMap();
            if(null != list && list.size() > 0) {
                Iterator var7 = list.iterator();

                while(var7.hasNext()) {
                    FormRelation fr = (FormRelation)var7.next();
                    Long fromFormId = fr.getFromRelationObj();
                    if(!mapId.containsKey(fromFormId)) {
                        FormBean fb = this.formCacheManager.getForm(fromFormId.longValue());
                        if(fb != null) {
                            sb.append("《" + fb.getFormName() + "》,");
                            mapId.put(fromFormId, fb);
                        }
                    }
                }
            }
        }

        return sb.toString().indexOf(",") > 1?sb.substring(0, sb.toString().length() - 1):sb.toString();
    }

    public String getRelationFormStr(Long formId) throws BusinessException {
        StringBuilder sb = new StringBuilder();
        List<FormRelation> allRelations = this.formRelationDAO.selectAll();
        Map<Long, FormBean> mapId = new HashMap();
        if(allRelations != null) {
            Iterator var5 = allRelations.iterator();

            while(true) {
                FormRelation fr;
                do {
                    do {
                        do {
                            do {
                                do {
                                    do {
                                        if(!var5.hasNext()) {
                                            return sb.toString().indexOf(",") > 1?sb.substring(0, sb.toString().length() - 1):sb.toString();
                                        }

                                        fr = (FormRelation)var5.next();
                                    } while(fr == null);
                                } while(fr.getToRelationObj() == null);
                            } while(formId == null);
                        } while(fr.getToRelationObj().longValue() != formId.longValue());
                    } while(fr.getToRelationAttrType() == null);
                } while(ToRelationAttrType.data_relation_field.getKey() != fr.getToRelationAttrType().intValue() && ToRelationAttrType.form_relation_field.getKey() != fr.getToRelationAttrType().intValue() && ToRelationAttrType.form_relation_flow.getKey() != fr.getToRelationAttrType().intValue() && ToRelationAttrType.form_relation_formContent.getKey() != fr.getToRelationAttrType().intValue());

                Long fromFormId = fr.getFromRelationObj();
                if(!mapId.containsKey(fromFormId)) {
                    FormBean fb = this.formCacheManager.getForm(fromFormId.longValue());
                    if(fb != null) {
                        sb.append("《" + fb.getFormName() + "》,");
                        mapId.put(fromFormId, fb);
                    }
                }
            }
        } else {
            return sb.toString().indexOf(",") > 1?sb.substring(0, sb.toString().length() - 1):sb.toString();
        }
    }

    public FormRelationRecordDAO getFormRelationRecordDAO() {
        return this.formRelationRecordDAO;
    }

    public void setFormRelationRecordDAO(FormRelationRecordDAO formRelationRecordDAO) {
        this.formRelationRecordDAO = formRelationRecordDAO;
    }

    public FormCacheManager getFormCacheManager() {
        return this.formCacheManager;
    }

    public void setFormCacheManager(FormCacheManager formCacheManager) {
        this.formCacheManager = formCacheManager;
    }

    public FormRelationDAO getFormRelationDAO() {
        return this.formRelationDAO;
    }

    public void setFormRelationDAO(FormRelationDAO formRelationDAO) {
        this.formRelationDAO = formRelationDAO;
    }

    public FormDataManager getFormDataManager() {
        return this.formDataManager;
    }

    public void setFormDataManager(FormDataManager formDataManager) {
        this.formDataManager = formDataManager;
    }

    public FormDataDAO getFormDataDao() {
        return this.formDataDAO;
    }

    public void setFormDataDAO(FormDataDAO formDataDao) {
        this.formDataDAO = formDataDao;
    }

    public FormDataDAO getFormDataDAO() {
        return this.formDataDAO;
    }

    public FormManager getFormManager() {
        return this.formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public TemplateManager getTemplateManager() {
        return this.templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public WorkflowApiManager getWapi() {
        return this.wapi;
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public void RelationAuthorityBySummaryId(Long summaryId, int key) {
        Map map = new HashMap();
        map.put("moduleId", summaryId);
        map.put("moduleType", Integer.valueOf(key));
        String hql = "delete from FormRelationAuthority c where c.moduleId=:moduleId and c.moduleType=:moduleType";
        DBAgent.bulkUpdate(hql, map);
    }

    public boolean isRelationData(long fromMasterDataId, long toMasterDataId) throws BusinessException {
        String hql = " from FormRelationRecord f where f.fromMasterDataId = :fromMasterDataId and f.toMasterDataId = :toMasterDataId";
        Map<String, Long> map = new HashMap();
        map.put("fromMasterDataId", Long.valueOf(fromMasterDataId));
        map.put("toMasterDataId", Long.valueOf(toMasterDataId));
        List<FormRelationRecord> list = DBAgent.find(hql, map);
        return Strings.isNotEmpty(list);
    }

    public boolean hasRight4UserCol(Long member, Long moduleId) throws BusinessException {
        String[] orgType = new String[]{FormModuleAuthOrgType.Member.getText(), FormModuleAuthOrgType.Department.getText(), FormModuleAuthOrgType.Level.getText(), FormModuleAuthOrgType.Post.getText(), FormModuleAuthOrgType.Team.getText(), FormModuleAuthOrgType.Account.getText()};
        List<Long> list = this.orgManager.getUserDomainIDs(Long.valueOf(member == null?AppContext.currentUserId():member.longValue()), orgType);
        Map<String, Object> dbParam = new HashMap();
        dbParam.put("userIds", list);
        dbParam.put("moduleId", moduleId);
        List<Long> colAuths = DBAgent.find("select c.moduleId from FormRelationAuthority c where moduleId=:moduleId and c.userId in (:userIds)", dbParam);
        return Strings.isNotEmpty(colAuths);
    }

    public void deleteFormRelationList(List<FormRelation> relationList) throws BusinessException {
        if(relationList != null) {
            Iterator var2 = relationList.iterator();

            while(var2.hasNext()) {
                FormRelation formRelation = (FormRelation)var2.next();
                this.formRelationDAO.delete(formRelation);
            }
        }

    }

    public void deleteFormRelation(FormRelation formRelation) throws BusinessException {
        if(formRelation != null) {
            this.formRelationDAO.delete(formRelation);
        }

    }

    public OrgManager getOrgManager() {
        return this.orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void saveOrUpdateRelationRecord(List<FormRelationRecord> relationRecords) throws BusinessException {
        if(relationRecords != null && relationRecords.size() != 0) {
            Long formMasterDataId = ((FormRelationRecord)relationRecords.get(0)).getFromMasterDataId();
            int type = ((FormRelationRecord)relationRecords.get(0)).getType().intValue();
            Set<String> fieldNames = new HashSet();
            Set<Long> subDataIds = new HashSet();
            Iterator var6 = relationRecords.iterator();

            while(var6.hasNext()) {
                FormRelationRecord record = (FormRelationRecord)var6.next();
                fieldNames.add(record.getFieldName());
                subDataIds.add(record.getFromSubdataId());
            }

            this.formRelationRecordDAO.deleteByDataAndFieldName(formMasterDataId, type, new ArrayList(fieldNames), new ArrayList(subDataIds));
            this.formRelationRecordDAO.insertList(relationRecords);
        }
    }

    public String getRefInputNameOptions(FormFieldBean currentField, List<FormFieldBean> refFields, FormBean fb) throws BusinessException {
        StringBuilder sb = new StringBuilder();
        sb.append("<option value=\"\"></option>");
        Iterator var5 = refFields.iterator();

        while(true) {
            while(true) {
                FormFieldBean refField;
                do {
                    if(!var5.hasNext()) {
                        return sb.toString();
                    }

                    refField = (FormFieldBean)var5.next();
                } while(!this.dataRelationRule(currentField, refField, refFields));

                FormRelation currentRel = currentField.getFormRelation();
                FormRelation fr = refField.getFormRelation();
                FormFieldBean relationField = fb == null?null:fb.getFieldBeanByName(fr == null?"":fr.getToRelationAttr());
                String relationFieldType = relationField == null?"":String.valueOf(relationField.isMasterField());
                String bindTableName = relationField == null?"":String.valueOf(relationField.getOwnerTableName());
                if(currentRel != null && currentRel.getToRelationAttr().equals(refField.getName())) {
                    sb.append("<option value=\"" + refField.getName() + "\" relType=\"" + refField.getInputType() + "\" bindMasterField=\"" + relationFieldType + "\" bindTableName=\"" + bindTableName + "\" isMasterField=\"" + refField.isMasterField() + "\" tableName=\"" + refField.getOwnerTableName() + "\" title=\"" + refField.getDisplay() + "\" selected>" + refField.getDisplay() + "</option>");
                } else {
                    sb.append("<option value=\"" + refField.getName() + "\" relType=\"" + refField.getInputType() + "\" bindMasterField=\"" + relationFieldType + "\" bindTableName=\"" + bindTableName + "\" isMasterField=\"" + refField.isMasterField() + "\" tableName=\"" + refField.getOwnerTableName() + "\" title=\"" + refField.getDisplay() + "\">" + refField.getDisplay() + "</option>");
                }
            }
        }
    }

    public String getRefInputAttrOptions(FormFieldBean ffb, FormBean fb) throws BusinessException {
        String returnStr = "";
        FormRelation fr = ffb.getFormRelation();
        int toRelationAttType = fr == null?0:fr.getToRelationAttrType().intValue();
        FormFieldBean relationField = fb == null?null:fb.getFieldBeanByName(fr == null?"":fr.getViewAttr());
        StringBuilder relFormOptions;
        List viewAttrValueList = new ArrayList();
       // List viewAttrValueList;
        String[] vav;
        int m;
        if(ToRelationAttrType.data_relation_member.getKey() == toRelationAttType) {
            relFormOptions = new StringBuilder();

            List it1 = ViewAttrValue.getAllViewAttrValue();
            viewAttrValueList = new ArrayList();
            vav = new String[]{"IDcard", "workStartingDate", "specialty", "edulevel", "position", "marriage", "birthplace"};
            List<String> hrAttrList = Arrays.asList(vav);
            Iterator var12 = it1.iterator();
            ViewAttrValue vav2;
            while(true) {

                do {
                    if(!var12.hasNext()) {
                        relFormOptions.append("<option value=\"\"></option>");

                        for(m = 0; m < viewAttrValueList.size(); ++m) {
                            vav2 = (ViewAttrValue)viewAttrValueList.get(m);
                            if(vav2.getKey().equals(fr.getViewAttr())) {
                                relFormOptions.append("<option fieldType=\"" + vav2.getFieldType() + "\" value=\"" + vav2.getKey() + "\" title=\"" + vav2.getText() + "\" selected>" + vav2.getText() + "</option>");
                            } else {
                                relFormOptions.append("<option fieldType=\"" + vav2.getFieldType() + "\" value=\"" + vav2.getKey() + "\" title=\"" + vav2.getText() + "\" >" + vav2.getText() + "</option>");
                            }
                        }

                        returnStr = relFormOptions.toString();
                        return returnStr;
                    }

                    vav2 = (ViewAttrValue)var12.next();
                } while(!AppContext.hasPlugin("hr") && hrAttrList.contains(vav2.getKey()));

                if(!ViewAttrValue.flowName.getKey().equals(vav2.getKey()) && !ViewAttrValue.formContent.getKey().equals(vav2.getKey())) {
                    viewAttrValueList.add(vav2);
                }
            }
        } else {
            int i;
            if(ToRelationAttrType.data_relation_department.getKey() == toRelationAttType) {
                relFormOptions = new StringBuilder();
                viewAttrValueList = DepartmentViewAttrValue.getAllViewAttrValue();
                relFormOptions.append("<option value=\"\"></option>");
                viewAttrValueList = null;

                for(i = 0; i < viewAttrValueList.size(); ++i) {
                    DepartmentViewAttrValue vav3 = (DepartmentViewAttrValue)viewAttrValueList.get(i);
                    if(vav3.getKey().equals(fr.getViewAttr())) {
                        relFormOptions.append("<option fieldLength=\"" + vav3.getFieldLength() + "\" fieldType=\"" + vav3.getFieldType() + "\" value=\"" + vav3.getKey() + "\" title=\"" + vav3.getText() + "\" selected>" + vav3.getText() + "</option>");
                    } else {
                        relFormOptions.append("<option fieldLength=\"" + vav3.getFieldLength() + "\" fieldType=\"" + vav3.getFieldType() + "\" value=\"" + vav3.getKey() + "\" title=\"" + vav3.getText() + "\" >" + vav3.getText() + "</option>");
                    }
                }

                returnStr = relFormOptions.toString();
            } else if(ToRelationAttrType.data_relation_map.getKey() == toRelationAttType) {
                relationField = fb == null?null:fb.getFieldBeanByName(fr == null?"":fr.getToRelationAttr());
                String inputType = relationField == null?FormFieldComEnum.TEXT.getKey():relationField.getInputType();
                StringBuilder mapOptions = new StringBuilder();
                viewAttrValueList = MapViewAttrValue.getAllViewAttrValue();
                mapOptions.append("<option value=\"\"></option>");
                vav = null;

                for( i = 0; i < viewAttrValueList.size(); ++i) {
                    MapViewAttrValue vav7 = (MapViewAttrValue)viewAttrValueList.get(i);
                    if(FormFieldComEnum.MAP_MARKED.getKey().equals(inputType) && !vav7.getKey().startsWith("gps_date_") || !FormFieldComEnum.MAP_MARKED.getKey().equals(inputType)) {
                        if(vav7.getKey().equals(fr.getViewAttr())) {
                            mapOptions.append("<option fieldType=\"" + vav7.getFieldType() + "\" value=\"" + vav7.getKey() + "\" title=\"" + vav7.getText() + "\" selected>" + vav7.getText() + "</option>");
                        } else {
                            mapOptions.append("<option fieldType=\"" + vav7.getFieldType() + "\" value=\"" + vav7.getKey() + "\" title=\"" + vav7.getText() + "\" >" + vav7.getText() + "</option>");
                        }
                    }
                }

                returnStr = mapOptions.toString();
            } else if(ToRelationAttrType.data_relation_project.getKey() == toRelationAttType) {
                relFormOptions = new StringBuilder();
                viewAttrValueList = ProjectViewAttrValue.getAllViewAttrValue();
                relFormOptions.append("<option value=\"\"></option>");
                viewAttrValueList = null;

                for(i = 0; i < viewAttrValueList.size(); ++i) {
                    ProjectViewAttrValue vav6 = (ProjectViewAttrValue)viewAttrValueList.get(i);
                    if(vav6.getKey().equals(fr.getViewAttr())) {
                        relFormOptions.append("<option fieldLength=\"" + vav6.getFieldLength() + "\" fieldType=\"" + vav6.getFieldType() + "\" value=\"" + vav6.getKey() + "\" title=\"" + vav6.getText() + "\" selected>" + vav6.getText() + "</option>");
                    } else {
                        relFormOptions.append("<option fieldLength=\"" + vav6.getFieldLength() + "\" fieldType=\"" + vav6.getFieldType() + "\" value=\"" + vav6.getKey() + "\" title=\"" + vav6.getText() + "\" >" + vav6.getText() + "</option>");
                    }
                }

                returnStr = relFormOptions.toString();
            } else if(ToRelationAttrType.data_relation_field.getKey() == toRelationAttType) {
                relFormOptions = new StringBuilder();
                relFormOptions.append("<option value=\"\"></option>");
                boolean isCanInput = false;
                Iterator var21 = fb.getAllFieldBeans().iterator();

                while(true) {
                    while(true) {
                        FormFieldBean formFieldBean;
                        do {
                            do {
                                do {
                                    do {
                                        if(!var21.hasNext()) {
                                            FormBean ff = this.formManager.getForm(fr.getToRelationObj());
                                            if(ff != null && ff.getFormType() == 1) {
                                                if(fr.getViewAttr() != null && fr.getViewAttr().equals(ViewAttrValue.formContent.getKey())) {
                                                    relFormOptions.append("<option value=\"" + ViewAttrValue.formContent.getKey() + "\" canInputLength=\"" + false + "\"  digitNum=\"" + 0 + "\" inputType=\"" + FormFieldComEnum.EXTEND_ATTACHMENT.getKey() + "\" fieldLength=\"" + 255 + "\" fieldType=\"" + FieldType.VARCHAR.getKey() + "\" isMasterField=\"" + true + "\" tableName=\"" + fr.getExtraAttr("tableName") + "\" title=\"" + ViewAttrValue.formContent.getText() + "-" + ResourceUtil.getString("form.auth.field.content.lable") + "\" selected>" + ViewAttrValue.formContent.getText() + "-" + ResourceUtil.getString("form.auth.field.content.lable") + "</option>");
                                                } else {
                                                    relFormOptions.append("<option value=\"" + ViewAttrValue.formContent.getKey() + "\" canInputLength=\"" + false + "\"  digitNum=\"" + 0 + "\" inputType=\"" + FormFieldComEnum.EXTEND_ATTACHMENT.getKey() + "\" fieldLength=\"" + 255 + "\" fieldType=\"" + FieldType.VARCHAR.getKey() + "\" isMasterField=\"" + true + "\" tableName=\"" + fr.getExtraAttr("tableName") + "\" title=\"" + ViewAttrValue.formContent.getText() + "-" + ResourceUtil.getString("form.auth.field.content.lable") + "\">" + ViewAttrValue.formContent.getText() + "-" + ResourceUtil.getString("form.auth.field.content.lable") + "</option>");
                                                }
                                            }

                                            returnStr = relFormOptions.toString();
                                            return returnStr;
                                        }

                                        formFieldBean = (FormFieldBean)var21.next();
                                    } while("flowName".equals(formFieldBean.getName()));
                                } while(formFieldBean.isConstantField());
                            } while("false".equals(formFieldBean.getInputTypeEnum().getCanRelation().getKey()));
                        } while(!this.filterData4RelationForm(relationField, formFieldBean));

                        FieldRelationObj[] fieldRelationObjArray = FormFieldComEnum.getEnumByKey(formFieldBean.getInputType()).getFieldRelationObjArray();

                        for(m = 0; m < fieldRelationObjArray.length; ++m) {
                            if(fieldRelationObjArray[m].getFieldType().getKey().equals(formFieldBean.getFieldType())) {
                                isCanInput = Boolean.parseBoolean(fieldRelationObjArray[m].getIsCanInput().getKey());
                                break;
                            }
                        }

                        String tableType = formFieldBean.getOwnerTableName().toLowerCase().indexOf("formmain") != -1?"[" + ResourceUtil.getString("form.base.mastertable.label") + "] ":"[" + ResourceUtil.getString("formoper.dupform.label") + fb.getTableByTableName(formFieldBean.getOwnerTableName()).getTableIndex() + "]" + " ";
                        if(fr.getViewAttr() != null && fr.getViewAttr().equals(formFieldBean.getName())) {
                            relFormOptions.append("<option value=\"" + formFieldBean.getName() + "\" canInputLength=\"" + isCanInput + "\"  digitNum=\"" + formFieldBean.getDigitNum() + "\" inputType=\"" + formFieldBean.getFinalInputType(true) + "\" fieldLength=\"" + formFieldBean.getFieldLength() + "\" fieldType=\"" + formFieldBean.getFieldType() + "\" isMasterField=\"" + formFieldBean.isMasterField() + "\" tableName=\"" + formFieldBean.getOwnerTableName() + "\" title=\"" + tableType + formFieldBean.getDisplay() + "\" selected>" + tableType + formFieldBean.getDisplay() + "</option>");
                        } else {
                            relFormOptions.append("<option value=\"" + formFieldBean.getName() + "\" canInputLength=\"" + isCanInput + "\" digitNum=\"" + formFieldBean.getDigitNum() + "\" inputType=\"" + formFieldBean.getFinalInputType(true) + "\" fieldLength=\"" + formFieldBean.getFieldLength() + "\" fieldType=\"" + formFieldBean.getFieldType() + "\" isMasterField=\"" + formFieldBean.isMasterField() + "\" tableName=\"" + formFieldBean.getOwnerTableName() + "\" title=\"" + tableType + formFieldBean.getDisplay() + "\" >" + tableType + formFieldBean.getDisplay() + "</option>");
                        }
                    }
                }
            }
        }

        return returnStr;
    }

    private boolean filterData4RelationForm(FormFieldBean relField, FormFieldBean filterField) throws BusinessException {
        boolean result = true;
        if(relField != null && FormFieldComEnum.RELATIONFORM.getKey().equals(relField.getInputType())) {
            FormRelation fr = relField.getFormRelation();
            FormBean fb = this.formCacheManager.getForm(fr.getToRelationObj().longValue());
            FormFieldBean relToRelField = fb == null?null:fb.getFieldBeanByName(fr.getToRelationAttr());
            if(relToRelField != null && !relToRelField.isMasterField() && !filterField.getOwnerTableName().equals(relField.getOwnerTableName()) && !filterField.isMasterField()) {
                result = false;
            }
        }

        return result;
    }

    private boolean dataRelationRule(FormFieldBean currentField, FormFieldBean filterField, List<FormFieldBean> refFields) throws BusinessException {
        boolean comRules = true;
        String relInputType = filterField.getInputType();
        FormRelation fr = filterField.getFormRelation();
        int relationAttrType = fr == null?0:(fr.getToRelationAttrType() == null?0:fr.getToRelationAttrType().intValue());
        boolean isMasterField = currentField.isMasterField();
        if(currentField.getName().equals(filterField.getName())) {
            comRules = false;
        }

        if(!isMasterField) {
            if(!currentField.getOwnerTableName().equals(filterField.getOwnerTableName()) && !filterField.isMasterField()) {
                comRules = false;
            }
        } else if(!filterField.isMasterField()) {
            comRules = false;
        }

        if(comRules) {
            if(FormFieldComEnum.RELATIONFORM.getKey().equals(relInputType)) {
                if(isMasterField) {
                    if(!filterField.isMasterField()) {
                        comRules = false;
                    }
                } else {
                    comRules = this.slaveDataRelFormRule(currentField, filterField, refFields);
                }
            } else if(FormFieldComEnum.RELATION.getKey().equals(relInputType)) {
                FormFieldBean realFieldBean = filterField.findRealFieldBean();
                if(relationAttrType == ToRelationAttrType.data_relation_multiEnum.getKey()) {
                    CtpEnumBean ceb = this.enumManagerNew.getEnum(Long.valueOf(filterField.getEnumId()));
                    if(ceb == null || filterField.getEnumLevel() <= 5 && (ceb.getMaxDepth() == null || filterField.getEnumLevel() < ceb.getMaxDepth().intValue())) {
                        if(ceb == null) {
                            comRules = false;
                        }
                    } else {
                        comRules = false;
                    }
                } else if(relationAttrType == ToRelationAttrType.data_relation_department.getKey()) {
                    if(DepartmentViewAttrValue.DepParent.getKey().equals(fr.getViewAttr())) {
                        comRules = true;
                    } else {
                        comRules = false;
                    }
                } else if(relationAttrType == ToRelationAttrType.data_relation_field.getKey()) {
                    if(realFieldBean.getInputTypeEnum() != FormFieldComEnum.EXTEND_MEMBER && realFieldBean.getInputTypeEnum() != FormFieldComEnum.EXTEND_DEPARTMENT && realFieldBean.getInputTypeEnum() != FormFieldComEnum.EXTEND_PROJECT) {
                        if(realFieldBean.getOutwriteFieldInputType() != FormFieldComEnum.EXTEND_MEMBER && realFieldBean.getOutwriteFieldInputType() != FormFieldComEnum.EXTEND_DEPARTMENT && realFieldBean.getOutwriteFieldInputType() != FormFieldComEnum.EXTEND_PROJECT) {
                            comRules = false;
                        } else {
                            comRules = true;
                        }
                    } else {
                        comRules = true;
                    }
                } else if(relationAttrType == ToRelationAttrType.data_relation_member.getKey()) {
                    if(!ViewAttrValue.department.getKey().equals(fr.getViewAttr()) && !ViewAttrValue.reporter.getKey().equals(fr.getViewAttr()) && !ViewAttrValue.name.getKey().equals(fr.getViewAttr())) {
                        comRules = false;
                    } else {
                        comRules = true;
                    }
                } else {
                    comRules = false;
                }
            } else if(FormFieldComEnum.SELECT.getKey().equals(relInputType)) {
                CtpEnumBean ceb = this.enumManagerNew.getEnum(Long.valueOf(filterField.getEnumId()));
                if(this.enumManagerNew.isUserImageEnum(ceb)) {
                    comRules = true;
                } else if(!this.enumManagerNew.hasMoreLevelEnumItem(Long.valueOf(filterField.getEnumId())) || filterField.getIsFinalChild()) {
                    comRules = false;
                }
            }
        }

        return comRules;
    }

    private boolean slaveDataRelFormRule(FormFieldBean currentField, FormFieldBean filterField, List<FormFieldBean> refFields) {
        boolean pass = true;
        String curTableName = currentField.getOwnerTableName();
        if(this.isExistSlaveRelForm(curTableName, refFields)) {
            if(!curTableName.equals(filterField.getOwnerTableName()) && !filterField.isMasterField()) {
                pass = false;
            }
        } else if(!filterField.isMasterField()) {
            pass = false;
        }

        return pass;
    }

    private boolean isExistSlaveRelForm(String curTableName, List<FormFieldBean> refFields) {
        boolean isExist = false;
        Iterator var4 = refFields.iterator();

        while(var4.hasNext()) {
            FormFieldBean ffb = (FormFieldBean)var4.next();
            if(FormFieldComEnum.RELATIONFORM.getKey().equals(ffb.getInputType()) && !ffb.isMasterField() && curTableName.equals(ffb.getOwnerTableName())) {
                isExist = true;
                break;
            }
        }

        return isExist;
    }

    public EnumManager getEnumManagerNew() {
        return this.enumManagerNew;
    }

    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }

    public List<CtpContentAll> getFormMasterDataIdByToModyleId(Long fromMasterDataId, Long toModuleId) {
        List<FormRelationRecord> records = this.formRelationRecordDAO.selectByToModuleId(toModuleId, fromMasterDataId);
        List<Long> fromMasterDataids = new ArrayList();
        Iterator var5 = records.iterator();

        while(var5.hasNext()) {
            FormRelationRecord record = (FormRelationRecord)var5.next();
            fromMasterDataids.add(record.getFromMasterDataId());
        }

        if(fromMasterDataids.size() > 0) {
            Map<String, Object> param = new HashMap();
            param.put("moduleType", Integer.valueOf(ModuleType.collaboration.getKey()));
            param.put("contentDataId", fromMasterDataids);
            String sql = "from CtpContentAll c where c.moduleType=:moduleType and c.contentDataId in (:contentDataId)";
            List<CtpContentAll> contentAlls = MainbodyService.getInstance().getContentList(sql, param);
            return contentAlls;
        } else {
            return new ArrayList();
        }
    }

    public void deleteRelationAuthoritys(Long moduleId, int moduleType, int authSourceType) throws BusinessException {
        Map map = new HashMap();
        map.put("moduleId", moduleId);
        map.put("moduleType", Integer.valueOf(moduleType));
        map.put("authSourceType", Integer.valueOf(authSourceType));
        String hql = "delete from FormRelationAuthority c where c.moduleId=:moduleId and c.moduleType=:moduleType and c.authSourceType = :authSourceType";
        DBAgent.bulkUpdate(hql, map);
    }

    public List<FormRelationAuthority> getRelationAuthoritys(Long moduleId, int moduleType, int authSourceType) throws BusinessException {
        Map map = new HashMap();
        map.put("moduleId", moduleId);
        map.put("moduleType", Integer.valueOf(moduleType));
        map.put("authSourceType", Integer.valueOf(authSourceType));
        String hql = "from FormRelationAuthority c where c.moduleId=:moduleId and c.moduleType=:moduleType and c.authSourceType = :authSourceType";
        return DBAgent.find(hql, map);
    }

    public void saveRelationAuthoritys(List<FormRelationAuthority> list) throws BusinessException {
        DBAgent.saveAll(list);
    }

    public void deleteCtpTemplateRelationAuths(Long templateId) throws BusinessException {
        Map map = new HashMap();
        map.put("templateId", templateId);
        String hql = "delete from CtpTemplateRelationAuth c where c.templateId=:templateId";
        DBAgent.bulkUpdate(hql, map);
    }

    public void saveCtpTemplateRelationAuths(List<CtpTemplateRelationAuth> list) throws BusinessException {
        DBAgent.saveAll(list);
    }

    public List<CtpTemplateRelationAuth> getCtpTemplateRelationAuths(Long templateId) throws BusinessException {
        Map map = new HashMap();
        map.put("templateId", templateId);
        String hql = "from CtpTemplateRelationAuth c where c.templateId=:templateId";
        return DBAgent.find(hql, map);
    }

    public void addRelationAuth4Template(List<V3xOrgEntity> memberList, ColSummary summary) throws BusinessException {
        if(memberList != null && summary != null) {
            List<FormRelationAuthority> colRelationAuthoritys = new ArrayList();

            for(int i = 0; i < memberList.size(); ++i) {
                V3xOrgEntity member = (V3xOrgEntity)memberList.get(i);
                FormRelationAuthority colRelationAuthority = new FormRelationAuthority();
                colRelationAuthority.setIdIfNew();
                colRelationAuthority.setModuleId(summary.getId());
                colRelationAuthority.setModuleType(Integer.valueOf(ModuleType.collaboration.getKey()));
                colRelationAuthority.setUserId(member.getId());
                colRelationAuthority.setSummarySubject(summary.getSubject());
                colRelationAuthority.setImportantLevel(summary.getImportantLevel().intValue());
                colRelationAuthority.setFormId(summary.getFormAppid());
                colRelationAuthority.setTemplateId(summary.getTempleteId());
                colRelationAuthority.setSummaryStartMemberId(summary.getStartMemberId());
                colRelationAuthority.setSummaryStartDate(summary.getStartDate());
                colRelationAuthority.setFormDataId(summary.getFormRecordid());
                colRelationAuthority.setSummaryState(summary.getState().intValue());
                colRelationAuthority.setSummaryVouchState(summary.getVouch().intValue());
                FormModuleAuthOrgType orgType = FormModuleAuthOrgType.getFormModuleAuthOrgTypeByText(member.getEntityType());
                int type = 0;
                if(orgType != null) {
                    type = orgType.getKey();
                } else {
                    LOGGER.warn("未知的组织模型类型：" + member.getEntityType());
                }

                colRelationAuthority.setUserType(Integer.valueOf(type));
                colRelationAuthority.setAuthSourceType(Integer.valueOf(RelationAuthSourceType.sourceTemplateSet.getKey()));
                colRelationAuthoritys.add(colRelationAuthority);
            }

            DBAgent.saveAll(colRelationAuthoritys);
        }

    }

    public void actionRelAuthInFlowEnd(ColSummary summary, FormDataMasterBean dataBean, List<CtpTemplateRelationAuth> relationAuthList) throws BusinessException {
        if(relationAuthList != null) {
            List<V3xOrgEntity> memberList = new ArrayList();
            Iterator var5 = relationAuthList.iterator();

            while(var5.hasNext()) {
                CtpTemplateRelationAuth ctpRelationAuth = (CtpTemplateRelationAuth)var5.next();
                String key = SelectPersonOperation.getTypeByTypeId(ctpRelationAuth.getAuthType().intValue());
                memberList.addAll(FormUtil.getSpecialMembers(this.orgManager, key, ctpRelationAuth.getAuthValue(), summary.getStartMemberId(), dataBean, false));
            }

            if(memberList.size() > 0) {
                this.deleteRelationAuthoritys(summary.getId(), ModuleType.collaboration.getKey(), RelationAuthSourceType.sourceTemplateSet.getKey());
                this.addRelationAuth4Template(memberList, summary);
            }
        }

    }

    public boolean isFilterFormMasterData(Map<String, Object> map) throws BusinessException {
        Long formId = ParamUtil.getLong(map, "formId");
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        String changeFormFormulaSQL = this.formDataManager.getChangeFormFormulaSQL(formBean, map);
        return !StringUtil.checkNull(changeFormFormulaSQL.toString().trim());
    }

    public FlipInfo getRelationAffairsByType(FlipInfo flipInfo, Map<String, Object> map) throws BusinessException {
        Long formId = ParamUtil.getLong(map, "formId");
        Integer colType = ParamUtil.getInt(map, "colType");
        FormBean formBean = this.formCacheManager.getForm(formId.longValue());
        FormTableBean masterTableBean = formBean.getMasterTableBean();
        List<FormTableBean> subTableBeans = formBean.getSubTableBean();
        StringBuffer sql = new StringBuffer();
        List<Object> parameterList = new ArrayList();
        if(colType.intValue() == 1) {
            sql.append("select distinct ").append(masterTableBean.getTableName()).append(".").append(MasterTableField.id.getKey());
            sql.append(",summary.subject,summary.id as module_id, summary.start_member_id as summary_start_member_id, summary.start_date as summary_start_date, summary.important_level,summary.state,summary.templete_id ");
            sql.append(" from ").append(masterTableBean.getTableName()).append(" ,col_Summary summary");
        } else {
            sql.append("select distinct f.module_id,f.summary_start_member_id ,f.summary_subject as subject,f.summary_start_date ,f.important_level,f.summary_state as state,f.template_id ");
            sql.append(" from ").append(masterTableBean.getTableName()).append(" ,form_relation_authority f");
        }

        if(map.containsKey(ColQueryCondition.startMemberName.name())) {
            sql.append(", org_member om ");
        }

        FormQueryWhereClause relationSqlWhereClause = this.formDataManager.getRelationConditionFormQueryWhereClause(formBean, map);
        StringBuffer whereSb = new StringBuffer("");
        if(null != relationSqlWhereClause && Strings.isNotBlank(relationSqlWhereClause.getAllSqlClause())) {
            whereSb.append(relationSqlWhereClause.getAllSqlClause());
        }

        StringBuffer from = new StringBuffer(" ");
        List<FormFieldBean> allFields = formBean.getAllFieldBeans();
        Iterator var14 = allFields.iterator();

        String createDate;
        while(var14.hasNext()) {
            FormFieldBean fieldBean = (FormFieldBean)var14.next();
            if(!fieldBean.isConstantField() && !fieldBean.isMasterField()) {
                createDate = fieldBean.getOwnerTableName();
                if(from.indexOf(createDate) == -1 && whereSb.indexOf(fieldBean.getName()) != -1) {
                    from.append(",").append(createDate);
                }
            }
        }

        sql.append(from);
        StringBuffer subWhereSb = new StringBuffer("");

        int andIndex;
        for(andIndex = 0; andIndex < subTableBeans.size(); ++andIndex) {
            if(!((FormTableBean)subTableBeans.get(andIndex)).isMainTable()) {
                createDate = ((FormTableBean)subTableBeans.get(andIndex)).getTableName();
                if(sql.indexOf(createDate) != -1 && subWhereSb.indexOf(createDate) == -1) {
                    subWhereSb.append(" (");
                    subWhereSb.append(createDate).append(".").append(SubTableField.formmain_id.getKey());
                    subWhereSb.append("=");
                    subWhereSb.append(masterTableBean.getTableName()).append(".").append(MasterTableField.id.getKey());
                    subWhereSb.append(") and ");
                }
            }
        }

        andIndex = subWhereSb.lastIndexOf("and ");
        if(andIndex != -1) {
            subWhereSb = subWhereSb.replace(andIndex, andIndex + "and ".length(), "");
        }

        if(!StringUtil.checkNull(subWhereSb.toString().trim())) {
            whereSb = subWhereSb.append(" and ").append(whereSb);
        }

        if(!StringUtil.checkNull(whereSb.toString().trim())) {
            sql.append(" where (").append(FormUtil.changeAndAddNullWhereSql(whereSb.toString())).append(" ) ");
        }

        if(null != relationSqlWhereClause && null != relationSqlWhereClause.getQueryParams()) {
            parameterList.addAll(relationSqlWhereClause.getQueryParams());
        }

        if(sql.indexOf("where") == -1) {
            sql.append(" where 1=1 ");
        }

        if(colType.intValue() == 1) {
            sql.append(" and (summary.state = 3 or summary.vouch = 1) and summary.start_member_id = ").append(AppContext.currentUserId());
            sql.append(" and summary.form_appid = ").append(formBean.getId());
            sql.append(" and summary.form_recordid = ").append(masterTableBean.getTableName()).append(".").append(MasterTableField.id.getKey());
            if(map.containsKey(ColQueryCondition.importantLevel.name())) {
                sql.append(" and summary.important_level= ?");
                parameterList.add(Integer.valueOf(Integer.parseInt(map.get(ColQueryCondition.importantLevel.name()).toString())));
            }

            if(map.containsKey(ColQueryCondition.subject.name())) {
                sql.append(" and summary.subject like ? ");
                parameterList.add("%" + SQLWildcardUtil.escape(map.get(ColQueryCondition.subject.name()).toString()) + "%");
            }

            if(map.containsKey(ColQueryCondition.createDate.name())) {
                createDate = map.get(ColQueryCondition.createDate.name()).toString();
                String[] date = createDate.split("#");
                if(date.length > 0) {
                    Date stamp;
                    if(Strings.isNotBlank(date[0])) {
                        stamp = Datetimes.getTodayFirstTime(date[0]);
                        sql.append(" and summary.start_date >= ?");
                        parameterList.add(stamp);
                    }

                    if(date.length > 1 && Strings.isNotBlank(date[1])) {
                        stamp = Datetimes.getTodayLastTime(date[1]);
                        sql.append(" and summary.start_date <= ?");
                        parameterList.add(stamp);
                    }
                }
            }

            sql.append(" order by summary.start_date desc");
        } else {
            String[] orgType = new String[]{FormModuleAuthOrgType.Member.getText(), FormModuleAuthOrgType.Department.getText(), FormModuleAuthOrgType.Level.getText(), FormModuleAuthOrgType.Post.getText(), FormModuleAuthOrgType.Team.getText(), FormModuleAuthOrgType.Account.getText()};
            List<Long> userDomainlist = this.orgManager.getUserDomainIDs(Long.valueOf(AppContext.currentUserId()), orgType);
            String placeholder = "";

            for(Iterator var19 = userDomainlist.iterator(); var19.hasNext(); placeholder = placeholder + "?,") {
                Long userDomain = (Long)var19.next();
            }

            if(placeholder.endsWith(",")) {
                placeholder = placeholder.substring(0, placeholder.length() - 1);
            }

            sql.append(" and ").append(masterTableBean.getTableName()).append(".id = f.form_data_id ");
            sql.append(" and f.form_id = ? and f.summary_start_member_id != ? and (f.summary_state = 3 or f.summary_vouch_state = 1) ");
            sql.append(" and f.user_id in (").append(placeholder).append(")");
            parameterList.add(formId);
            parameterList.add(Long.valueOf(AppContext.currentUserId()));
            parameterList.addAll(userDomainlist);
            if(map.containsKey(ColQueryCondition.importantLevel.name())) {
                sql.append(" and f.important_level= ?");
                parameterList.add(Integer.valueOf(Integer.parseInt(map.get(ColQueryCondition.importantLevel.name()).toString())));
            }

            if(map.containsKey(ColQueryCondition.subject.name())) {
                sql.append(" and f.summary_subject like ? ");
                parameterList.add("%" + SQLWildcardUtil.escape(map.get(ColQueryCondition.subject.name()).toString()) + "%");
            }

            if(map.containsKey(ColQueryCondition.startMemberName.name())) {
                sql.append(" and f.summary_start_member_id = om.id and om.name like ? ");
                parameterList.add("%" + SQLWildcardUtil.escape(map.get(ColQueryCondition.startMemberName.name()).toString()) + "%");
            }

            if(map.containsKey(ColQueryCondition.createDate.name())) {
                 createDate = map.get(ColQueryCondition.createDate.name()).toString();
                String[] date = createDate.split("#");
                if(date.length > 0) {
                    Date stamp;
                    if(Strings.isNotBlank(date[0])) {
                        stamp = Datetimes.getTodayFirstTime(date[0]);
                        sql.append(" and f.summary_start_date >= ?");
                        parameterList.add(stamp);
                    }

                    if(date.length > 1 && Strings.isNotBlank(date[1])) {
                        stamp = Datetimes.getTodayLastTime(date[1]);
                        sql.append(" and f.summary_start_date <= ?");
                        parameterList.add(stamp);
                    }
                }
            }

            sql.append(" order by f.summary_start_date desc");
        }

        flipInfo = this.formDataDAO.selectDataBySql(sql.toString(), parameterList, flipInfo);
        List<Object> list = flipInfo.getData();
        List<ColSummaryVO> summaryVOList = new ArrayList();
        if(Strings.isNotEmpty(list)) {
            Iterator var31 = list.iterator();

            while(var31.hasNext()) {
                Object obj = var31.next();
                Map<String, Object> tempMap = (Map)obj;
                ColSummaryVO model = new ColSummaryVO();
                summaryVOList.add(model);
                model.setStartDate((Date)tempMap.get("summary_start_date"));
                model.setSubject((String)tempMap.get("subject"));
                model.setSummaryId(tempMap.get("module_id").toString());
                model.setImportantLevel(Integer.valueOf(tempMap.get("important_level").toString()));
                model.setStartMemberName(OrgHelper.showMemberName(Long.valueOf(tempMap.get("summary_start_member_id").toString())));
                model.setCreateDate((Date)tempMap.get("summary_start_date"));
                model.setState(Integer.valueOf(tempMap.get("state").toString()));
                model.setStartMemberId(Long.valueOf(tempMap.get("summary_start_member_id").toString()));
                if(colType.intValue() == 1) {
                    model.setTempleteId(Long.valueOf(tempMap.get("templete_id").toString()));
                } else {
                    model.setTempleteId(Long.valueOf(tempMap.get("template_id").toString()));
                }
            }
        }

        flipInfo.setData(summaryVOList);
        return flipInfo;
    }

    public boolean isRelationed4Form(Long formId) throws BusinessException {
        return this.formRelationDAO.selectByForm(formId) > 0;
    }

    @AjaxAccess
    public FlipInfo getRelationAffairs(FlipInfo flipInfo, Map<String, Object> param) throws BusinessException {
        Long formId = ParamUtil.getLong(param, "formId", Long.valueOf(0L));
        flipInfo = this.getRelationAffairsByType(flipInfo, param);
        List<ColSummaryVO> datas = flipInfo.getData();
        Map<Long, String> nfonMap = new HashMap();
        ColSummaryVO col;
        String formOpeName;
        if(Strings.isNotEmpty(datas)) {
            for(Iterator var6 = datas.iterator(); var6.hasNext(); col.setOperationId(formOpeName)) {
                col = (ColSummaryVO)var6.next();
                Long templeteId = col.getTempleteId();
                formOpeName = (String)nfonMap.get(templeteId);
                if(Strings.isBlank(formOpeName)) {
                    CtpTemplate template = this.templateManager.getCtpTemplate(templeteId);
                    FormBean toFormBean = this.formCacheManager.getForm(formId.longValue());
                    FormAuthViewBean readOnlyAuth;
                    if(template == null) {
                        List<FormAuthViewBean> auths = toFormBean.getAllFormAuthViewBeans();
                         readOnlyAuth = null;
                        Iterator var22 = auths.iterator();

                        while(var22.hasNext()) {
                            readOnlyAuth = (FormAuthViewBean)var22.next();
                            if(readOnlyAuth.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                readOnlyAuth = readOnlyAuth;
                                break;
                            }
                        }

                        if(readOnlyAuth != null) {
                            formOpeName = String.valueOf(readOnlyAuth.getId());
                        } else {
                            LOGGER.error("没有设置只读权限，穿透无法完成");
                        }
                    } else {
                        ProcessTemplateManager p = (ProcessTemplateManager)AppContext.getBean("processTemplateManager");
                        ProcessTemplete t = p.selectProcessTemplateById(template.getWorkflowId());
                        if(t == null) {
                            List<FormAuthViewBean> auths = toFormBean.getAllFormAuthViewBeans();
                            readOnlyAuth = null;
                            Iterator var24 = auths.iterator();

                            while(var24.hasNext()) {
                                FormAuthViewBean auth = (FormAuthViewBean)var24.next();
                                if(auth.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                    readOnlyAuth = auth;
                                    break;
                                }
                            }

                            if(readOnlyAuth != null) {
                                formOpeName = String.valueOf(readOnlyAuth.getId());
                            } else {
                                LOGGER.error("没有设置只读权限，穿透无法完成");
                            }
                        } else {
                            formOpeName = this.wapi.getNodeFormOperationName(template.getWorkflowId(), (String)null);
                            FormAuthViewBean tempOperation = toFormBean.getAuthViewBeanById(Long.valueOf(Long.parseLong(formOpeName)));
                            if(tempOperation != null) {
                                formOpeName = String.valueOf(tempOperation.getId());
                            } else {
                                List<FormAuthViewBean> auths = toFormBean.getAllFormAuthViewBeans();
                                 readOnlyAuth = null;
                                Iterator var17 = auths.iterator();

                                while(var17.hasNext()) {
                                    FormAuthViewBean auth = (FormAuthViewBean)var17.next();
                                    if(auth.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                        readOnlyAuth = auth;
                                        break;
                                    }
                                }

                                if(readOnlyAuth != null) {
                                    formOpeName = String.valueOf(readOnlyAuth.getId());
                                } else {
                                    LOGGER.error("没有设置只读权限，穿透无法完成");
                                }
                            }
                        }
                    }
                }
            }
        }

        return flipInfo;
    }

    public void updateRelationAuthoritySummaryState(ColSummary summary) throws BusinessException {
        this.formRelationDAO.updateRelationAuthoritySummaryState(summary);
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

    @AjaxAccess
    public Map<String, Object> loadChartViewData(Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap();
        Long formId = ParamUtil.getLong(paramMap, "formId", Long.valueOf(0L));
        FormBean form = this.formCacheManager.getForm(formId.longValue());
        if(null == form) {
            result.put("isFind", "false");
            return result;
        } else {
            result.put("isFind", "true");
            String showRelation = ParamUtil.getString(paramMap, "showRelation", "all");
            String queryLevels = ParamUtil.getString(paramMap, "queryLevels", "-1");
            Map recursionMap = new HashMap();
            recursionMap.put("currentLevelFrom", Integer.valueOf(1));
            recursionMap.put("currentLevelTo", Integer.valueOf(1));
            recursionMap.put("queryLevels", queryLevels);
            recursionMap.put("totalLevel", Integer.valueOf(1));
            recursionMap.put("showRelation", showRelation);
            recursionMap.put("centerFormId", formId);
            recursionMap.put("centerFormName", form.getFormName());

            try {
                List<FormRelationTableVO> list = new ArrayList();
                List<Map> listMap = new ArrayList();
                list = this.getFormRelationView(form, true, true, true, list, listMap, true, recursionMap);
                result.put("data", list);
                result.put("dataForms", listMap);
                result.put("recursionMap", recursionMap);
            } catch (Exception var10) {
                LOGGER.error(var10.getMessage(), var10);
            }

            return result;
        }
    }

    public List<FormRelationTableVO> getFormRelationView(FormBean form, boolean needFieldForm, boolean needFillBackForm, boolean needTriggerForm, List<FormRelationTableVO> relationVOList, List<Map> listMap, boolean isChart, Map<String, Object> recursionMap) {
        if(relationVOList == null) {
            relationVOList = new ArrayList();
        }

        if(listMap == null) {
            listMap = new ArrayList();
        }

        Map<String, Object> pathMap = null;
        Map<String, FormRelationTableVO> relationVOMap = new HashMap();
        List<FormRelationTableVO> list = new ArrayList();
        List<FormRelationTableVO> reverseList = new ArrayList();
        String showRelation = String.valueOf(recursionMap.get("showRelation"));
        this.getFormRelationTable(form, true, true, true, (Map)pathMap, relationVOMap, list, reverseList, true, true, recursionMap);
        if(isChart && (null == list || list.size() == 0) && ("from".equals(showRelation) || null == reverseList || reverseList.size() == 0)) {
            list = new ArrayList();
            FormRelationTableVO frtvo = new FormRelationTableVO();
            frtvo.setRelationType("null");
            frtvo.setPath(String.valueOf(form.getId()));
            frtvo.setSrcForm(form);
            frtvo.setEnabledSrcForm(form.getState() == FormStateEnum.published.getKey() && form.getUseFlag() == FormUseFlagEnum.enabled.getKey());
            list.add(frtvo);
        }

        ((List)relationVOList).addAll(list);
        if(!"from".equals(showRelation) && null != reverseList) {
            ((List)relationVOList).addAll(reverseList);
        }

        List<FormRelationTableVO> resultList = new ArrayList();
        List<String> formIds = new ArrayList();
        List<String> paths = new ArrayList();
        Map centerFromMap = FormRelationTableVO.bulidFormBeanMap(form);
        centerFromMap.put("rowIndex", Integer.valueOf(1));
        centerFromMap.put("columnIndex", Integer.valueOf(1));
        centerFromMap.put("columnCount", Integer.valueOf(1));
        ((List)listMap).add(centerFromMap);
        recursionMap.put("currentLevel", Integer.valueOf(1));
        recursionMap.put("rowCount", Integer.valueOf(1));
        recursionMap.put("maxColumn", Integer.valueOf(1));
        this.sortRelationLevel(centerFromMap, (List)relationVOList, recursionMap, formIds, paths, (List)listMap, resultList);
        this.calculateRowColumn((List)listMap, recursionMap);
        return resultList;
    }

    private void calculateRowColumn(List<Map> listMap, Map<String, Object> recursionMap) {
        int maxColumn = 1;
        Map row_cloumn = new HashMap();
        int rowCount = Integer.parseInt(String.valueOf(recursionMap.get("rowCount")));

        for(int i = 1; i <= rowCount; ++i) {
            int columnCount = 1;
            Iterator var8 = listMap.iterator();

            while(var8.hasNext()) {
                Map formMap = (Map)var8.next();
                int rowIndex = Integer.parseInt(String.valueOf(formMap.get("rowIndex")));
                if(rowIndex == i) {
                    row_cloumn.put(Integer.valueOf(i), Integer.valueOf(columnCount));
                    formMap.put("columnIndex", Integer.valueOf(columnCount));
                    ++columnCount;
                }
            }

            if(columnCount - 1 > maxColumn) {
                maxColumn = columnCount - 1;
                recursionMap.put("maxColumn", Integer.valueOf(maxColumn));
            }
        }

        Iterator var11 = listMap.iterator();

        while(var11.hasNext()) {
            Map formMap = (Map)var11.next();
            int rowIndex = Integer.parseInt(String.valueOf(formMap.get("rowIndex")));
            formMap.put("columnCount", row_cloumn.get(Integer.valueOf(rowIndex)));
        }

    }

    private void sortRelationLevel(Map form, List<FormRelationTableVO> relationVOList, Map<String, Object> recursionMap, List<String> formIds, List<String> paths, List<Map> listMap, List<FormRelationTableVO> resultList) {
        int rowIndex = Integer.parseInt(String.valueOf(form.get("rowIndex"))) + 1;
        int queryLevels = Integer.parseInt(String.valueOf(recursionMap.get("queryLevels")));
        int currentLevel = Integer.parseInt(String.valueOf(recursionMap.get("currentLevel")));
        List<Map> tempListMap = new ArrayList();
        List<FormRelationTableVO> tempResultList = new ArrayList();
        List<FormRelationTableVO> tempOtherList = new ArrayList();
        Iterator var14 = relationVOList.iterator();

        while(true) {
            FormRelationTableVO vo;
            String formId;
            Map formMap;
            label93:
            while(true) {
                while(var14.hasNext()) {
                    vo = (FormRelationTableVO)var14.next();
                    formId = String.valueOf(form.get("formId"));
                    if(vo.getPath().contains(formId)) {
                        if(paths.contains(vo.getPath())) {
                            break label93;
                        }

                        int relationLevel = 999999999;
                        if(null != vo.getRecursionMap()) {
                            if(null != vo.getRecursionMap().get("relationLevel")) {
                                relationLevel = Integer.parseInt(String.valueOf(vo.getRecursionMap().get("relationLevel")));
                            }

                            if(rowIndex - 1 < relationLevel) {
                                vo.getRecursionMap().put("currentLevel", Integer.valueOf(rowIndex - 1));
                            }

                            tempResultList.add(vo);
                            paths.add(vo.getPath());
                            break label93;
                        }
                    } else {
                        tempOtherList.add(vo);
                    }
                }

                int listSize = tempListMap.size();
                if(listSize > 0) {
                    Iterator var20 = tempListMap.iterator();

                    while(var20.hasNext()) {
                        Map tempMap = (Map)var20.next();
                        if(!formIds.contains(String.valueOf(tempMap.get("formId")))) {
                            listMap.add(tempMap);
                            formIds.add(String.valueOf(tempMap.get("formId")));
                        }
                    }
                }

                int rowCount = Integer.parseInt(String.valueOf(recursionMap.get("rowCount")));
                if(rowIndex > rowCount) {
                    recursionMap.put("currentLevel", Integer.valueOf(rowIndex));
                    recursionMap.put("rowCount", Integer.valueOf(rowIndex));
                }

                if((queryLevels == -1 || currentLevel < queryLevels) && tempOtherList.size() > 0 && tempListMap.size() > 0) {
                    Iterator var23 = tempListMap.iterator();

                    while(var23.hasNext()) {
                        formMap = (Map)var23.next();
                        String tempMapFormId = String.valueOf(formMap.get("formId"));
                        if(!tempMapFormId.equals(String.valueOf(form.get("formId")))) {
                            this.sortRelationLevel(formMap, tempOtherList, recursionMap, formIds, paths, listMap, resultList);
                        }
                    }
                }

                if(tempResultList.size() > 0) {
                    resultList.addAll(tempResultList);
                }

                return;
            }

            if(null != vo.getSrcForm() && null != vo.getTarForm()) {
                formMap = vo.getSrcForm();
                if(String.valueOf(vo.getSrcForm().get("formId")).equals(formId)) {
                    formMap = vo.getTarForm();
                }

                if(null != formMap.get("formId")) {
                    formMap.put("rowIndex", Integer.valueOf(rowIndex));
                    formMap.put("parentFormId", form.get("formId"));
                    this.checkRowIndex(formIds, listMap, formMap);
                    if(!formIds.contains(String.valueOf(formMap.get("formId")))) {
                        tempListMap.add(formMap);
                    }
                }
            }
        }
    }

    private void checkRowIndex(List<String> formIds, List<Map> listMap, Map formMap) {
        int rowIndex = Integer.parseInt(String.valueOf(formMap.get("rowIndex")));
        if(formIds.contains(String.valueOf(formMap.get("formId")))) {
            Iterator var5 = listMap.iterator();

            while(var5.hasNext()) {
                Map oldFormMap = (Map)var5.next();
                if(String.valueOf(oldFormMap.get("formId")).equals(String.valueOf(formMap.get("formId")))) {
                    int oldRowIndex = Integer.parseInt(String.valueOf(oldFormMap.get("rowIndex")));
                    if(rowIndex < oldRowIndex) {
                        oldFormMap.put("rowIndex", Integer.valueOf(rowIndex));
                        this.changeChildRowIndex(listMap, oldFormMap);
                    }
                    break;
                }
            }
        }

    }

    private void changeChildRowIndex(List<Map> listMap, Map oldFormMap) {
        int parentFormRowIndex = Integer.parseInt(String.valueOf(oldFormMap.get("rowIndex")));
        Iterator var4 = listMap.iterator();

        while(var4.hasNext()) {
            Map oldChildFormMap = (Map)var4.next();
            if(String.valueOf(oldFormMap.get("formId")).equals(String.valueOf(oldChildFormMap.get("parentFormId")))) {
                int childFormRowIndex = Integer.parseInt(String.valueOf(oldChildFormMap.get("rowIndex")));
                if(parentFormRowIndex + 1 < childFormRowIndex) {
                    oldChildFormMap.put("rowIndex", Integer.valueOf(parentFormRowIndex + 1));
                    this.changeChildRowIndex(listMap, oldChildFormMap);
                }
            }
        }

    }

    private List<FormRelationTableVO> getFormRelationTable(FormBean form, boolean needFieldForm, boolean needFillBackForm, boolean needTriggerForm, Map<String, Object> pathMap, Map<String, FormRelationTableVO> relationVOMap, List<FormRelationTableVO> relationVOList, List<FormRelationTableVO> reverseRelationVOList, boolean isFirst, boolean isChart, Map<String, Object> recursionMap) {
        String showRelation = String.valueOf(recursionMap.get("showRelation"));
        if(pathMap == null) {
            pathMap = new LinkedHashMap();
        }

        String path = null;
        relationVOList = this.getFormRelationVO((String)path, form, relationVOMap, relationVOList, isFirst, isChart, (Map)pathMap, recursionMap);
        isFirst = false;
        if(((Map)pathMap).containsKey(String.valueOf(form.getId()))) {
            return relationVOList;
        } else {
            ((Map)pathMap).put(String.valueOf(form.getId()), form.getFormName());
            this.getReverseFormRelationTable((String)path, form, needFieldForm, needFillBackForm, needTriggerForm, (Map)pathMap, relationVOMap, relationVOList, reverseRelationVOList, isFirst, isChart, recursionMap);
            int currentLevelFrom = Integer.parseInt(String.valueOf(recursionMap.get("currentLevelFrom")));
            int currentLevelTo = Integer.parseInt(String.valueOf(recursionMap.get("currentLevelTo")));
            int queryLevels = Integer.parseInt(String.valueOf(recursionMap.get("queryLevels")));
            if(queryLevels == -1 || currentLevelFrom < queryLevels || currentLevelTo < queryLevels) {
                List<FormBean> formList = this.getRelationForms(form, needFieldForm, needFillBackForm, needTriggerForm, (Map)pathMap);
                Iterator var18 = formList.iterator();

                while(true) {
                    FormBean relForm;
                    do {
                        if(!var18.hasNext()) {
                            recursionMap.put("currentLevelFrom", Integer.valueOf(currentLevelFrom + 1));
                            return relationVOList;
                        }

                        relForm = (FormBean)var18.next();
                        if(!((Map)pathMap).containsKey(String.valueOf(relForm.getId())) && queryLevels == 1) {
                            ((Map)pathMap).put(String.valueOf(relForm.getId()), relForm.getFormName());
                        }

                        currentLevelFrom = Integer.parseInt(String.valueOf(recursionMap.get("currentLevelFrom")));
                        relationVOList = this.getFormRelationVO((String)path, relForm, relationVOMap, relationVOList, isFirst, isChart, (Map)pathMap, recursionMap);
                        if("all".equals(showRelation)) {
                            this.getReverseFormRelationTable((String)path, relForm, needFieldForm, needFillBackForm, needTriggerForm, (Map)pathMap, relationVOMap, relationVOList, reverseRelationVOList, isFirst, isChart, recursionMap);
                        }
                    } while(queryLevels != -1 && currentLevelFrom >= queryLevels && currentLevelTo >= queryLevels);

                    this.getFormRelationTable(relForm, needFieldForm, needFillBackForm, needTriggerForm, (Map)pathMap, relationVOMap, relationVOList, reverseRelationVOList, isFirst, isChart, recursionMap);
                }
            } else {
                return relationVOList;
            }
        }
    }

    private List<FormRelationTableVO> getReverseFormRelationTable(String path, FormBean form, boolean needFieldForm, boolean needFillBackForm, boolean needTriggerForm, Map<String, Object> pathMap, Map<String, FormRelationTableVO> relationVOMap, List<FormRelationTableVO> relationVOList, List<FormRelationTableVO> reverseRelationVOList, boolean isFirst, boolean isChart, Map<String, Object> recursionMap) {
        int queryLevels = Integer.parseInt(String.valueOf(recursionMap.get("queryLevels")));
        List<FormBean> formListReverse = this.getReverseRelationForms(form, needFieldForm, needFillBackForm, needTriggerForm, relationVOMap, reverseRelationVOList, isFirst, isChart, pathMap, recursionMap);
        int currentLevelFrom = Integer.parseInt(String.valueOf(recursionMap.get("currentLevelFrom")));
        int currentLevelTo = Integer.parseInt(String.valueOf(recursionMap.get("currentLevelTo")));
        Iterator var17 = formListReverse.iterator();

        while(true) {
            FormBean relFormReverse;
            do {
                do {
                    if(!var17.hasNext()) {
                        recursionMap.put("currentLevelTo", Integer.valueOf(currentLevelTo + 1));
                        return reverseRelationVOList;
                    }

                    relFormReverse = (FormBean)var17.next();
                } while(pathMap.containsKey(String.valueOf(relFormReverse.getId())));

                if(queryLevels == 1) {
                    pathMap.put(String.valueOf(relFormReverse.getId()), relFormReverse.getFormName());
                }

                reverseRelationVOList = this.getFormRelationVO(path, relFormReverse, relationVOMap, reverseRelationVOList, isFirst, isChart, pathMap, recursionMap);
            } while(queryLevels != -1 && currentLevelFrom >= queryLevels && currentLevelTo >= queryLevels);

            this.getFormRelationTable(relFormReverse, needFieldForm, needFillBackForm, needTriggerForm, pathMap, relationVOMap, relationVOList, reverseRelationVOList, isFirst, isChart, recursionMap);
        }
    }

    private List<FormBean> getRelationForms(FormBean form, boolean needFieldForm, boolean needFillBackForm, boolean needTriggerForm, Map<String, Object> relationMap) {
        if(relationMap == null) {
            relationMap = new LinkedHashMap();
        }

        List<FormBean> relationList = new ArrayList();
        FormCacheManager cacheManager = (FormCacheManager)AppContext.getBean("formCacheManager");
        FormBean relationFormBean = null;
        if(needFieldForm) {
            Iterator var9 = form.getFieldsByType(FormFieldComEnum.RELATIONFORM).iterator();

            while(var9.hasNext()) {
                FormFieldBean fieldBean = (FormFieldBean)var9.next();
                FormRelation relation = fieldBean.getFormRelation();
                if(relation != null) {
                    relationFormBean = cacheManager.getForm(relation.getToRelationObj().longValue());
                    if(relationFormBean != null && !relationFormBean.equals(form) && !((Map)relationMap).containsKey(String.valueOf(relationFormBean.getId()))) {
                        relationList.add(relationFormBean);
                    }
                }
            }
        }

        if(needFillBackForm || needTriggerForm) {
            Map<Long, FormTriggerBean> map = form.getTriggerConfigMap();
            Iterator var18 = map.entrySet().iterator();

            while(true) {
                TriggerType triggerType;
                List actions;
                do {
                    do {
                        do {
                            if(!var18.hasNext()) {
                                return relationList;
                            }

                            Entry<Long, FormTriggerBean> triggerConfig = (Entry)var18.next();
                            FormTriggerBean formTriggerBean = (FormTriggerBean)triggerConfig.getValue();
                            triggerType = TriggerType.getEnumByKey(formTriggerBean.getType());
                            actions = formTriggerBean.getActions();
                        } while(triggerType == TriggerType.fillBackSet && !needFillBackForm);
                    } while(triggerType == TriggerType.triggerSet && !needTriggerForm);
                } while(triggerType == TriggerType.LinkageSet && !needTriggerForm);

                Iterator var15 = actions.iterator();

                while(var15.hasNext()) {
                    FormTriggerActionBean action = (FormTriggerActionBean)var15.next();
                    if(Strings.isNotBlank((String)action.getParam(ParamType.FormId.getKey())) && !this.isMessageOrUpdate(action.getType())) {
                        relationFormBean = cacheManager.getForm(Long.parseLong((String)action.getParam(ParamType.FormId.getKey())));
                        if(relationFormBean != null && !relationFormBean.equals(form) && !((Map)relationMap).containsKey(String.valueOf(relationFormBean.getId()))) {
                            relationList.add(relationFormBean);
                        }
                    }
                }
            }
        } else {
            return relationList;
        }
    }

    private List<Long> selectToByModuleId(Long moduleId) throws BusinessException {
        List ids = new ArrayList();
        FormRelation relation = null;
        ConcurrentMap<Long, FormRelation> relations = this.formCacheManager.getRelations();
        Iterator var5 = relations.entrySet().iterator();

        while(var5.hasNext()) {
            Entry<Long, FormRelation> entry = (Entry)var5.next();
            relation = (FormRelation)entry.getValue();
            if(String.valueOf(relation.getToRelationObj()).equals(String.valueOf(moduleId))) {
                ids.add(relation.getFromRelationObj());
            }
        }

        return ids;
    }

    public List<Long> selectFormDefByTriggerInfo(long formId) throws BusinessException {
        List ids = new ArrayList();
        FormBean form = null;
        ConcurrentMap<Long, FormBean> forms = this.formCacheManager.getForms();
        Iterator var6 = forms.entrySet().iterator();

        label39:
        while(var6.hasNext()) {
            Entry<Long, FormBean> entry = (Entry)var6.next();
            boolean findTriggerRelation = false;
            form = (FormBean)entry.getValue();
            Map<Long, FormTriggerBean> map = form.getTriggerConfigMap();
            Iterator var10 = map.entrySet().iterator();

            while(true) {
                while(true) {
                    if(!var10.hasNext()) {
                        continue label39;
                    }

                    Entry<Long, FormTriggerBean> triggerConfig = (Entry)var10.next();
                    FormTriggerBean formTriggerBean = (FormTriggerBean)triggerConfig.getValue();
                    TriggerType triggerType = TriggerType.getEnumByKey(formTriggerBean.getType());
                    List<FormTriggerActionBean> actions = formTriggerBean.getActions();
                    Iterator var15 = actions.iterator();

                    while(var15.hasNext()) {
                        FormTriggerActionBean action = (FormTriggerActionBean)var15.next();
                        String triggerFormId = (String)action.getParam(ParamType.FormId.getKey());
                        if(Strings.isNotBlank(triggerFormId) && !this.isMessageOrUpdate(action.getType()) && String.valueOf(triggerFormId).equals(String.valueOf(formId))) {
                            ids.add(form.getId());
                            findTriggerRelation = true;
                            break;
                        }

                        if(findTriggerRelation) {
                            break;
                        }
                    }
                }
            }
        }

        return ids;
    }

    private List<FormBean> getReverseRelationForms(FormBean form, boolean needFieldForm, boolean needFillBackForm, boolean needTriggerForm, Map<String, FormRelationTableVO> relationMap, List<FormRelationTableVO> reverseRelationVOList, boolean isFirst, boolean isChart, Map<String, Object> pathMap, Map<String, Object> recursionMap) {
        int queryLevels = Integer.parseInt(String.valueOf(recursionMap.get("queryLevels")));
        if(pathMap == null) {
            pathMap = new LinkedHashMap();
        }

        if(relationMap == null) {
            new LinkedHashMap();
        }

        if(reverseRelationVOList == null) {
            new ArrayList();
        }

        List<FormBean> relationList = new ArrayList();
        List reverseFormList = new ArrayList();
        Object reverseForms = recursionMap.get("reverseForms");
        if(null != reverseForms) {
            reverseFormList = (List)reverseForms;
        }

        if(((List)reverseFormList).contains(form.getId())) {
            return relationList;
        } else {
            ((List)reverseFormList).add(form.getId());
            recursionMap.put("reverseForms", reverseFormList);
            FormCacheManager cacheManager = (FormCacheManager)AppContext.getBean("formCacheManager");
            FormBean relationFormBean = null;
            String path = "";
            List reverseFormDefs;
            Iterator var19;
            Long reverseFd;
            if(needFieldForm) {
                try {
                    reverseFormDefs = this.selectToByModuleId(form.getId());
                    var19 = reverseFormDefs.iterator();

                    while(var19.hasNext()) {
                        reverseFd = (Long)var19.next();
                        relationFormBean = cacheManager.getForm(reverseFd.longValue());
                        if(relationFormBean != null && !relationFormBean.equals(form) && !((Map)pathMap).containsKey(String.valueOf(relationFormBean.getId()))) {
                            relationList.add(relationFormBean);
                            if(queryLevels == 1) {
                                ;
                            }
                        }
                    }
                } catch (Exception var31) {
                    LOGGER.error(var31.getMessage(), var31);
                }
            }

            if(needFillBackForm || needTriggerForm) {
                try {
                    reverseFormDefs = this.selectFormDefByTriggerInfo(form.getId().longValue());
                    var19 = reverseFormDefs.iterator();

                    label108:
                    while(var19.hasNext()) {
                        reverseFd = (Long)var19.next();
                        FormBean reverseFormBean = cacheManager.getForm(reverseFd.longValue());
                        Map<Long, FormTriggerBean> map = reverseFormBean.getTriggerConfigMap();
                        Iterator var23 = map.entrySet().iterator();

                        while(true) {
                            TriggerType triggerType;
                            List actions;
                            do {
                                do {
                                    do {
                                        if(!var23.hasNext()) {
                                            if(!reverseFormBean.equals(form) && !((Map)pathMap).containsKey(String.valueOf(reverseFormBean.getId()))) {
                                                relationList.add(reverseFormBean);
                                                if(queryLevels == 1) {
                                                    ;
                                                }
                                            }
                                            continue label108;
                                        }

                                        Entry<Long, FormTriggerBean> triggerConfig = (Entry)var23.next();
                                        FormTriggerBean formTriggerBean = (FormTriggerBean)triggerConfig.getValue();
                                        triggerType = TriggerType.getEnumByKey(formTriggerBean.getType());
                                        actions = formTriggerBean.getActions();
                                    } while(triggerType == TriggerType.fillBackSet && !needFillBackForm);
                                } while(triggerType == TriggerType.triggerSet && !needTriggerForm);
                            } while(triggerType == TriggerType.LinkageSet && !needTriggerForm);

                            Iterator var28 = actions.iterator();

                            while(var28.hasNext()) {
                                FormTriggerActionBean action = (FormTriggerActionBean)var28.next();
                                if(Strings.isNotBlank((String)action.getParam(ParamType.FormId.getKey())) && !this.isMessageOrUpdate(action.getType())) {
                                    relationFormBean = cacheManager.getForm(Long.parseLong((String)action.getParam(ParamType.FormId.getKey())));
                                    if(relationFormBean != null && !relationFormBean.equals(form) && !((Map)pathMap).containsKey(String.valueOf(relationFormBean.getId())) && queryLevels != 1) {
                                        relationList.add(relationFormBean);
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception var30) {
                    LOGGER.error(var30.getMessage(), var30);
                }
            }

            return relationList;
        }
    }

    private List<FormRelationTableVO> getFormRelationVO(String path, FormBean form, Map<String, FormRelationTableVO> relationMap, List<FormRelationTableVO> relationList, boolean isFirst, boolean isChart, Map<String, Object> pathMap, Map<String, Object> recursionMap) {
        if(relationMap == null) {
            relationMap = new LinkedHashMap();
        }

        if(relationList == null) {
            relationList = new ArrayList();
        }

        FormCacheManager cacheManager = (FormCacheManager)AppContext.getBean("formCacheManager");
        FormBean relationFormBean = null;
        Iterator var11 = form.getFieldsByType(FormFieldComEnum.RELATIONFORM).iterator();

        while(var11.hasNext()) {
            FormFieldBean fieldBean = (FormFieldBean)var11.next();
            FormRelation relation = fieldBean.getFormRelation();
            if(null != relation) {
                path = this.creatRelationPath(relation);
                this.buildRelationData(path, form, (FormBean)relationFormBean, relation, fieldBean, (Map)relationMap, (List)relationList, isChart, cacheManager, recursionMap);
            }
        }

        Map<Long, FormTriggerBean> map = form.getTriggerConfigMap();
        Iterator var20 = map.entrySet().iterator();

        while(var20.hasNext()) {
            Entry<Long, FormTriggerBean> triggerConfig = (Entry)var20.next();
            FormTriggerBean formTriggerBean = (FormTriggerBean)triggerConfig.getValue();
            TriggerType triggerType = TriggerType.getEnumByKey(formTriggerBean.getType());
            List<FormTriggerActionBean> actions = formTriggerBean.getActions();
            Iterator var17 = actions.iterator();

            while(var17.hasNext()) {
                FormTriggerActionBean action = (FormTriggerActionBean)var17.next();
                if(null != action) {
                    path = this.buildTriggerData(path, form, (FormBean)relationFormBean, formTriggerBean, action, (Map)relationMap, (List)relationList, isFirst, isChart, cacheManager, pathMap, recursionMap);
                }
            }
        }

        return (List)relationList;
    }

    private void buildRelationData(String path, FormBean form, FormBean relationFormBean, FormRelation relation, FormFieldBean fieldBean, Map<String, FormRelationTableVO> relationMap, List<FormRelationTableVO> relationList, boolean isChart, FormCacheManager cacheManager, Map<String, Object> recursionMap) {
        String relationShip = "";
        String linkConditTitle = "";
        String fildFilterTitle = "";
        String mapFildTitle = "";
        String relationAttr = "";
        if(relation != null) {
            relationFormBean = cacheManager.getForm(relation.getToRelationObj().longValue());
            if(relationFormBean != null) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.associatedform");
                FormRelationTableVO frtvo = new FormRelationTableVO();
                if(null == relation.getViewSelectType()) {
                    relation.setViewSelectType(Integer.valueOf(ViewSelectType.user.getKey()));
                }

                if(ViewSelectType.system.getKey() == relation.getViewSelectType().intValue()) {
                    relationAttr = ResourceUtil.getString("form.data.system");
                    linkConditTitle = ResourceUtil.getString("form.relation.condition.label");
                } else {
                    relationAttr = ResourceUtil.getString("form.data.user");
                    fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                }

                Map linkConOrDataFilter = new HashMap();
                linkConOrDataFilter.put("type", "relation");
                linkConOrDataFilter.put("fildFilterTitle", fildFilterTitle);
                linkConOrDataFilter.put("linkConditTitle", linkConditTitle);
                linkConOrDataFilter.put("relationId", relation.getId());
                linkConOrDataFilter.put("srcFormFildId", relation.getFromRelationAttr());
                linkConOrDataFilter.put("tarFormFildId", relation.getToRelationAttr());
                linkConOrDataFilter.put("isUserChoice", Boolean.valueOf(relation.getViewSelectType().intValue() == 1));
                String formulaStr = "";
                if(relation.getExtraAttr("formulaStr") == null) {
                    if(relation.getViewConditionId() != null) {
                        FormFormulaBean formulab = null;

                        try {
                            formulab = cacheManager.loadFormFormulaBean(form, relation.getViewConditionId());
                        } catch (BusinessException var27) {
                            LOGGER.error(var27.getMessage(), var27);
                        }

                        if(formulab != null) {
                            formulaStr = formulab.getFormulaForDisplay();
                        }
                    }
                } else {
                    formulaStr = (String)relation.getExtraAttr("formulaStr");
                }

                linkConOrDataFilter.put("dataFilterContent", formulaStr);
                frtvo.setLinkConOrDataFilter(linkConOrDataFilter);
                frtvo.setRelationShip(relationShip);
                frtvo.setRelationType("relation");
                frtvo.setRelationAttr(relationAttr);
                frtvo.setSrcForm(form);
                frtvo.setSystemDisabledSrcForm(cacheManager.isSystemDisabledForm(form));
                frtvo.setEnabledSrcForm(cacheManager.isEnabled(form));
                frtvo.setTarForm(relationFormBean);
                frtvo.setSystemDisabledTarForm(cacheManager.isSystemDisabledForm(relationFormBean));
                frtvo.setEnabledTarForm(cacheManager.isEnabled(relationFormBean));
                Map fild = new HashMap();
                fild.put("type", "relation");
                fild.put("relationType", "relation");
                fild.put("relationId", relation.getId());
                String masterFormLable = ResourceUtil.getString("form.base.mastertable.label");
                String repeatFormLable = ResourceUtil.getString("formoper.dupform.label");
                if(fieldBean.isMasterField()) {
                    mapFildTitle = "[" + masterFormLable + "]" + fieldBean.getDisplay();
                } else {
                    mapFildTitle = "[" + repeatFormLable + fieldBean.getOwnerTableIndex() + "]" + fieldBean.getDisplay();
                }

                FormFieldBean relationFieldBean = relationFormBean.getFieldBeanByName(relation.getToRelationAttr(), true);
                if(null != relationFieldBean) {
                    if(relationFieldBean.isMasterField()) {
                        mapFildTitle = mapFildTitle + " = [" + masterFormLable + "]" + relationFieldBean.getDisplay();
                    } else {
                        mapFildTitle = mapFildTitle + " = [" + repeatFormLable + relationFieldBean.getOwnerTableIndex() + "]" + relationFieldBean.getDisplay();
                    }
                } else {
                    mapFildTitle = mapFildTitle + " = " + this.getFormFildDisplay(relationFormBean, relation.getToRelationAttr());
                }

                fild.put("title", mapFildTitle);
                frtvo.setMapFild(fild);
                Map exeCondition = new HashMap();
                exeCondition.put("dotConditionValue", "");
                exeCondition.put("dotConditionTitle", "/");
                frtvo.setExeCondition(exeCondition);
                if(!relationMap.containsKey(path)) {
                    relationMap.put(path, frtvo);
                    frtvo.setPath(path);
                    Map<String, Object> recursionMapCopy = new HashMap();
                    recursionMapCopy.putAll(recursionMap);
                    long centerFormId = Long.parseLong(String.valueOf(recursionMap.get("centerFormId")));
                    if(form.getId().longValue() == centerFormId || null != relationFormBean && relationFormBean.getId().longValue() == centerFormId) {
                        recursionMapCopy.put("currentLevelFrom", Integer.valueOf(1));
                    }

                    frtvo.setRecursionMap(recursionMapCopy);
                    relationList.add(frtvo);
                }
            }
        }

    }

    private String buildTriggerData(String path, FormBean form, FormBean relationFormBean, FormTriggerBean formTriggerBean, FormTriggerActionBean action, Map<String, FormRelationTableVO> relationMap, List<FormRelationTableVO> relationList, boolean isFirst, boolean isChart, FormCacheManager cacheManager, Map<String, Object> pathMap, Map<String, Object> recursionMap) {
        int queryLevels = Integer.parseInt(String.valueOf(recursionMap.get("queryLevels")));
        String relationShip = "";
        String linkConditTitle = "";
        String fildFilterTitle = "";
        String mapFildTitle = "";
        String relationAttr = "";
        String templateName = "";
        String actionType = action.getType();
        if(action.isDelete()) {
            return path;
        } else {
            if(com.seeyon.ctp.form.util.Enums.TriggerType.FLOW.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.trigger.triggerSet.triggerPro.label");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.base.data.copy");
                templateName = this.getFormTempName(form, action);
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.MESSAGE.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.triggermessage");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.UNFLOW.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.dataarchive");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.base.data.copy");
                templateName = this.getFormTempName(form, action);
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.CALCULATE.getKey().equals(action.getType()) || "calaulate".equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.datawriteback");
                linkConditTitle = ResourceUtil.getString("form.relation.condition.label");
                mapFildTitle = ResourceUtil.getString("form.formrelation.listtable.datawriteback");
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.DEE.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.relation.trigger.dee.task");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.relation.dee.mission.field");
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.DISTRIBUTION.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.distributionlinkage");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.relation.data.linkage");
                templateName = this.getFormTempName(form, action);
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.Gather.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.summarylinkage");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                linkConditTitle = ResourceUtil.getString("form.relation.condition.label");
                mapFildTitle = ResourceUtil.getString("form.relation.data.linkage");
                templateName = this.getFormTempName(form, action);
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.BILATERAL.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.twowaylinkage");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                templateName = this.getFormTempName(form, action);
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.BILATERAL_GO.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.twowaylinkage");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.relation.data.linkage");
                templateName = this.getFormTempName(form, action);
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.BILLINNER.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.updatecurrentformdata");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.trigger.automatic.rule.label");
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.BILLOUTER.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.formrelation.listtable.updateotherformdata");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.trigger.automatic.rule.label");
            }

            if(com.seeyon.ctp.form.util.Enums.TriggerType.AUTOINSERT.getKey().equals(action.getType())) {
                relationShip = ResourceUtil.getString("form.trigger.automatic.billnew.label");
                fildFilterTitle = ResourceUtil.getString("form.create.input.relation.datafilter.label");
                mapFildTitle = ResourceUtil.getString("form.trigger.automatic.newrule.label");
            }

            boolean isBilateralback = false;
            if(com.seeyon.ctp.form.util.Enums.TriggerType.BILATERAL_BACK.getKey().equals(action.getType())) {
                if(!isFirst) {
                    return path;
                }

                isBilateralback = true;
            }

            Object withholding = action.getParam(ParamType.Withholding.getKey());
            if(null != withholding && "true".equals(String.valueOf(withholding).toLowerCase())) {
                relationAttr = "控制预提";
            }

            Object addSlaveRow = action.getParam(ParamType.AddSlaveRow.getKey());
            if(null != addSlaveRow && "true".equals(String.valueOf(addSlaveRow).toLowerCase())) {
                relationAttr = relationAttr + "\n添加重复表行";
            }

            Object regeneration = action.getParam(ParamType.Regeneration.getKey());
            if(null != regeneration && "true".equals(String.valueOf(regeneration).toLowerCase())) {
                relationAttr = "删除目标数据后重新生成";
            }

            if(Strings.isNotBlank((String)action.getParam(ParamType.FormId.getKey())) || this.isMessageOrUpdate(action.getType())) {
                if(!this.isMessageOrUpdate(action.getType())) {
                    relationFormBean = cacheManager.getForm(Long.parseLong((String)action.getParam(ParamType.FormId.getKey())));
                    if(relationFormBean == null || relationFormBean.equals(form)) {
                        return path;
                    }

                    if(queryLevels == 1) {
                        ;
                    }
                }

                FormRelationTableVO frtvo = new FormRelationTableVO();
                Map linkConOrDataFilter = new HashMap();
                Map fild = new HashMap();
                linkConOrDataFilter.put("type", "trigger");
                linkConOrDataFilter.put("fildFilterTitle", fildFilterTitle);
                linkConOrDataFilter.put("linkConditTitle", linkConditTitle);
                linkConOrDataFilter.put("relationId", action.getId());
                linkConOrDataFilter.put("triggerId", formTriggerBean.getId());
                linkConOrDataFilter.put("relationType", actionType);
                String dataFilterContent = formTriggerBean.getConditionFormulaStr();
                linkConOrDataFilter.put("dataFilterContent", dataFilterContent);
                if(this.isMessageOrUpdate(actionType)) {
                    linkConOrDataFilter.put("targetFormData", ResourceUtil.getString("form.trigger.automatic.billtarget.label"));
                    linkConOrDataFilter.put("repeatRow", ResourceUtil.getString("form.trigger.automatic.repeatrowlocation.label"));
                }

                String repeatRowLoactionValue = "";
                List<FormTriggerActionBean> actions = formTriggerBean.getActions();

                Map param;
                for(Iterator var31 = actions.iterator(); var31.hasNext(); repeatRowLoactionValue = (String)param.get("repeatRowLoactionValue")) {
                    FormTriggerActionBean action2 = (FormTriggerActionBean)var31.next();
                    param = action.getParam();
                }

                if("".equals(repeatRowLoactionValue)) {
                    linkConOrDataFilter.put("repeatRows", Boolean.valueOf(false));
                } else {
                    linkConOrDataFilter.put("repeatRows", Boolean.valueOf(true));
                }

                frtvo.setLinkConOrDataFilter(linkConOrDataFilter);
                frtvo.setRelationShip(relationShip);
                frtvo.setRelationType(action.getType());
                frtvo.setRelationAttr(relationAttr);
                frtvo.setSrcForm(form);
                frtvo.setSystemDisabledSrcForm(cacheManager.isSystemDisabledForm(form));
                frtvo.setEnabledSrcForm(cacheManager.isEnabled(form));
                if(!com.seeyon.ctp.form.util.Enums.TriggerType.MESSAGE.getKey().equals(action.getType())) {
                    frtvo.setTarForm(relationFormBean);
                    frtvo.setSystemDisabledTarForm(cacheManager.isSystemDisabledForm(relationFormBean));
                    frtvo.setEnabledTarForm(cacheManager.isEnabled(relationFormBean));
                    fild.put("relationType", action.getType());
                }

                if((com.seeyon.ctp.form.util.Enums.TriggerType.UNFLOW.getKey().equals(action.getType()) || com.seeyon.ctp.form.util.Enums.TriggerType.FLOW.getKey().equals(action.getType()) || com.seeyon.ctp.form.util.Enums.TriggerType.DISTRIBUTION.getKey().equals(action.getType()) || com.seeyon.ctp.form.util.Enums.TriggerType.BILATERAL_GO.getKey().equals(action.getType())) && null != frtvo.getTarForm()) {
                    frtvo.getTarForm().put("templateName", templateName);
                }

                if(com.seeyon.ctp.form.util.Enums.TriggerType.BILLINNER.getKey().equals(action.getType()) || com.seeyon.ctp.form.util.Enums.TriggerType.BILLOUTER.getKey().equals(action.getType()) || com.seeyon.ctp.form.util.Enums.TriggerType.AUTOINSERT.getKey().equals(action.getType())) {
                    frtvo.getTarForm().put("targetFormName", "none");
                }

                fild.put("type", "trigger");
                fild.put("relationType", action.getType());
                fild.put("title", mapFildTitle);
                fild.put("relationId", action.getId());
                fild.put("triggerId", formTriggerBean.getId());

                try {
                    Map<String, Object> ParamMap = action.getActionManager().getParamMap(action, form);
                    if(null != ParamMap.get("fillBackType")) {
                        String type = ParamMap.get("fillBackType").toString();
                        if(Strings.isBlank(type)) {
                            fild.put("hasCopySet", Boolean.valueOf(false));
                        } else {
                            fild.put("hasCopySet", Boolean.valueOf(true));
                        }
                    }
                } catch (BusinessException var47) {
                    LOGGER.error(var47.getMessage(), var47);
                }

                frtvo.setMapFild(fild);
                Map exeCondition = new HashMap();
                exeCondition.put("state", Integer.valueOf(formTriggerBean.getState()));
                exeCondition.put("relationType", actionType);
                exeCondition.put("triggerId", formTriggerBean.getId());
                exeCondition.put("flowForm", Boolean.valueOf(form.getFormType() == 1));
                FormTriggerConditionBean timeCondition = formTriggerBean.getTriggerConditionBean(ConditionType.date);
                if(null == timeCondition) {
                    exeCondition.put("hasTimeQuazta", Boolean.valueOf(false));
                } else {
                    exeCondition.put("hasTimeQuazta", Boolean.valueOf(true));
                }

                if(formTriggerBean.getFlowState() != null && Strings.isNotBlank(formTriggerBean.getFlowState())) {
                    exeCondition.put("dotConditionValue", formTriggerBean.getFlowState());
                    TriggerConditionState tcs = TriggerConditionState.getEnumByKey(formTriggerBean.getFlowState());
                    if(null != tcs) {
                        exeCondition.put("dotConditionTitle", tcs.getText());
                    }
                }

                Iterator var53 = formTriggerBean.getConditions().iterator();

                while(var53.hasNext()) {
                    FormTriggerConditionBean conditionBean = (FormTriggerConditionBean)var53.next();
                    ConditionType dataFieldType = ConditionType.getEnumByKey(conditionBean.getType());
                    String fieldConditionValue = "";
                    String fieldCondition1 = "";
                    String fieldCondition2 = "";
                    if("form".equals(dataFieldType.getKey()) && null != conditionBean.getNewRight() && null != conditionBean.getModifyRight()) {
                        String newRight = conditionBean.getNewRight();
                        String updateRight = conditionBean.getModifyRight();
                        Long viewId;
                        Long updateID;
                        FormAuthViewBean formAuthViewBean;
                        String updateType;
                        FormViewBean formView2;
                        String viewName2;
                        if(!Strings.isBlank(newRight)) {
                            viewId = Long.valueOf(Long.parseLong(newRight.substring(0, newRight.indexOf(46))));
                            updateID = Long.valueOf(Long.parseLong(newRight.substring(newRight.indexOf(46) + 1, newRight.length())));
                            formAuthViewBean = form.getAuthViewBeanById(updateID);
                            if(null == formAuthViewBean) {
                                fieldCondition1 = "";
                            } else {
                                updateType = formAuthViewBean.getName();
                                formView2 = form.getFormView(viewId.longValue());
                                viewName2 = formView2.getFormViewName();
                                if(!Strings.isBlank(updateRight)) {
                                    fieldCondition1 = viewName2 + "." + updateType + " or ";
                                } else {
                                    fieldCondition1 = viewName2 + "." + updateType;
                                }
                            }
                        }

                        if(!Strings.isBlank(updateRight)) {
                            viewId = Long.valueOf(Long.parseLong(updateRight.substring(0, updateRight.indexOf(46))));
                            updateID = Long.valueOf(Long.parseLong(updateRight.substring(updateRight.indexOf(46) + 1, updateRight.length())));
                            formAuthViewBean = form.getAuthViewBeanById(updateID);
                            if(null == formAuthViewBean) {
                                fieldCondition2 = "";
                            } else {
                                updateType = formAuthViewBean.getName();
                                formView2 = form.getFormView(viewId.longValue());
                                viewName2 = formView2.getFormViewName();
                                fieldCondition2 = viewName2 + "." + updateType;
                            }
                        }

                        fieldConditionValue = fieldCondition1 + fieldCondition2;
                    }

                    switch(dataFieldType) {
                        case form:
                            exeCondition.put("dotConditionId", conditionBean.getId());
                            exeCondition.put("dotConditionValue", conditionBean.getFormulaId());
                            break;
                        case flow:
                            exeCondition.put("add", conditionBean.getNewRight());
                            exeCondition.put("update", conditionBean.getModifyRight());
                            exeCondition.put("fieldConditionId", conditionBean.getId());
                            exeCondition.put("fieldConditionFormulaId", conditionBean.getFormulaId());
                            exeCondition.put("fieldConditionValue", fieldConditionValue);
                            break;
                        case date:
                            exeCondition.put("timeConditionId", conditionBean.getId());
                            exeCondition.put("timeFormulaId", conditionBean.getFormulaId());
                            exeCondition.put("timeQuartz", conditionBean.getParam() + "|" + conditionBean.getFormFormulaBean().getFormulaForDisplay() + "|" + conditionBean.getTriggerTime());
                    }

                    if(conditionBean.getParam() != null && Strings.isNotBlank(conditionBean.getParam())) {
                        exeCondition.put("dotConditionValue", conditionBean.getParam());
                        TriggerConditionState tcs = TriggerConditionState.getEnumByKey(String.valueOf(exeCondition.get("dotConditionValue")));
                        if(null != tcs) {
                            exeCondition.put("dotConditionTitle", tcs.getText());
                        }
                    }
                }

                frtvo.setExeCondition(exeCondition);
                path = this.creatTriggerPath(form, relationFormBean, action);
                if(!relationMap.containsKey(path) && !isBilateralback) {
                    relationMap.put(path, frtvo);
                    frtvo.setPath(path);
                    Map<String, Object> recursionMapCopy = new HashMap();
                    recursionMapCopy.putAll(recursionMap);
                    long centerFormId = Long.parseLong(String.valueOf(recursionMap.get("centerFormId")));
                    if(form.getId().longValue() == centerFormId || null != relationFormBean && relationFormBean.getId().longValue() == centerFormId) {
                        recursionMapCopy.put("currentLevelFrom", Integer.valueOf(1));
                    }

                    frtvo.setRecursionMap(recursionMapCopy);
                    relationList.add(frtvo);
                }
            }

            return path;
        }
    }

    private String creatRelationPath(FormRelation relation) {
        String path = relation.getFromRelationObj() + "." + relation.getFromRelationAttr() + "_$" + relation.getToRelationAttrType() + "$_" + relation.getToRelationObj() + "." + relation.getToRelationAttr() + "$_" + relation.getToRelationObj() + "." + relation.getViewAttr();
        return path;
    }

    private String creatTriggerPath(FormBean form, FormBean relationFormBean, FormTriggerActionBean action) {
        String path;
        if(!this.isMessageOrUpdate(action.getType())) {
            path = form.getId() + "_$" + action.getId() + "$_" + relationFormBean.getId();
        } else {
            path = form.getId() + "_$" + action.getId() + "$_";
        }

        return path;
    }

    private String getFormTempName(FormBean form, FormTriggerActionBean action) {
        String templateName = "";

        try {
            Map<String, Object> paramMap = action.getActionManager().getParamMap(action, form);
            templateName = (String)paramMap.get("content");
            if(null == templateName) {
                templateName = "";
            }
        } catch (BusinessException var6) {
            LOGGER.error(var6.getMessage(), var6);
        }

        return templateName;
    }

    private boolean isMessageOrUpdate(String actionType) {
        return actionType.equals(com.seeyon.ctp.form.util.Enums.TriggerType.MESSAGE.getKey())?true:(actionType.equals(com.seeyon.ctp.form.util.Enums.TriggerType.BILLINNER.getKey())?true:(actionType.equals(com.seeyon.ctp.form.util.Enums.TriggerType.BILLOUTER.getKey())?true:actionType.equals(com.seeyon.ctp.form.util.Enums.TriggerType.AUTOINSERT.getKey())));
    }

    private String getFormFildDisplay(FormBean formBean, String fildName) {
        String display = "";
        if(!StringUtil.checkNull(fildName)) {
            FormFieldBean tempFFB = formBean.getFieldBeanByName(fildName);
            if(tempFFB != null) {
                display = tempFFB.getDisplay();
            } else {
                if(fildName.toLowerCase().contains("flowname")) {
                    fildName = "flowTitleName";
                } else if(fildName.toLowerCase().contains("flowcontent")) {
                    fildName = "flowFormContent";
                }

                SystemDataField tempSysDataField = SystemDataField.getEnumByKey(fildName);
                if(tempSysDataField != null) {
                    display = tempSysDataField.getText();
                } else {
                    display = "";
                }
            }
        } else {
            display = "";
        }

        return display;
    }

    public void updateSummarySubjectByModuleId(String newSubject, Long moduleId) throws BusinessException {
        Map<String, Object> map = new HashMap();
        map.put("moduleId", moduleId);
        map.put("summarySubject", newSubject);
        String hql = "update FormRelationAuthority set summarySubject =:summarySubject where moduleId=:moduleId";
        DBAgent.bulkUpdate(hql, map);
    }
}
