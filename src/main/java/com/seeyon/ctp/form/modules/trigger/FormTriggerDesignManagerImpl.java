package com.seeyon.ctp.form.modules.trigger;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.template.enums.TemplateEnum.searchCondtion;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.bean.*;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.bean.FormTriggerBean.*;
import com.seeyon.ctp.form.modules.engin.base.formBase.FormDefinitionDAO;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.FlowState;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.*;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import org.apache.commons.logging.Log;

import java.util.*;
import java.util.Map.Entry;

/**
 * @author Administrator
 *
 */
public class FormTriggerDesignManagerImpl implements FormTriggerDesignManager {

    private TemplateManager    templateManager;
    private FormManager        formManager;
    private FormCacheManager   formCacheManager;
    private FormDefinitionDAO  formDefinitionDAO;
    private OrgManager         orgManager;
    private FormTriggerManager formTriggerManager;
	private static final Log LOGGER = CtpLogFactory.getLog(FormTriggerDesignManagerImpl.class);

    /**
     * 触发设置保存前的校验，校验死循环的可能性和触发名称是否重复
     */
    @Override
    @AjaxAccess
    public String checkTriggerDeadCycle(String targetFormIds) {
        if (Strings.isNotBlank(targetFormIds) && targetFormIds.split(",").length > 0) {
            try {
                FormBean fb = formManager.getEditingForm();
                String[] idArr = targetFormIds.split(",");
                List<String> formNames;
                for (String id : idArr) {
                    if (Strings.isNotBlank(id)) {
                        Long targetFormId = Long.valueOf(id);
                        formNames = new ArrayList<String>();
                        if (FormTriggerUtil.checkTriggerDeadCycle(fb, targetFormId, formNames)) {
                            StringBuilder sb = new StringBuilder();
                            for (String name : formNames) {
                                sb.append(name).append("、");
                            }
                            String name = sb.toString();
                            name = name.substring(0, name.length() - 1);
                            return name;
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.info("保存触发设置判断死循环异常！");
            }
        }
        return "";
    }

    @Override
    public boolean validateTriggerName(String triggerId, String triggerName, String currentTypeStr) {
        if (Strings.isBlank(triggerName)) {
            return true;
        }
        int currentType = Integer.parseInt(currentTypeStr);
        FormBean fb = formManager.getEditingForm();
        List<FormTriggerBean> formTriggerBeanList = fb.getTriggerList();
        if (null != formTriggerBeanList) {
            for (FormTriggerBean formTriggerBean : formTriggerBeanList) {
                if (!formTriggerBean.getId().toString().equals(triggerId) && formTriggerBean.getFormTriggerId() == null && formTriggerBean.getType() == currentType) {
                    if (formTriggerBean.getName().equals(triggerName)) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    @Override
    public void saveTrigger4Cache(Map<String, String> baseInfo, List<Map<String, String>> actionList) throws BusinessException {
        String triggerId = baseInfo.get("triggerId");
        FormBean fb = formManager.getEditingForm();
        FormTriggerBean formTriggerBean;
        List<FormTriggerConditionBean> conditions = new ArrayList<FormTriggerConditionBean>();
        List<FormTriggerActionBean> actions = new ArrayList<FormTriggerActionBean>();
        if ("".equals(triggerId) || "-1".equals(triggerId)) {
            formTriggerBean = new FormTriggerBean(fb);
            formTriggerBean.setId(UUIDLong.longUUID());
            formTriggerBean.setCreateTime(DateUtil.get19DateAndTime());
            formTriggerBean.setCreator(AppContext.currentUserId());
            formTriggerBean.setModifyTime(DateUtil.get19DateAndTime());
            fb.addTriggerBean(formTriggerBean);
        } else {
            formTriggerBean = fb.getFormTriggerBean(Long.parseLong(triggerId));
            formTriggerBean.setModifyTime(DateUtil.get19DateAndTime());
            formTriggerBean.clearFormulaList();
        }
        formTriggerBean.setActions(actions);
        formTriggerBean.setConditions(conditions);
        formTriggerBean.setFormId(fb.getId());
        formTriggerBean.setType(Integer.parseInt(baseInfo.get("triggerType")));
        formTriggerBean.setName(baseInfo.get("triggerName").trim());
        formTriggerBean.setState(Integer.parseInt(baseInfo.get("state")));

        //流程条件
        FormTriggerConditionBean formTriggerConditionBean = null;
        //表单数据域条件
        formTriggerConditionBean = new FormTriggerConditionBean(formTriggerBean);
        String dotConditionFre = baseInfo.get("dotConditionValue");
        if (FlowState.getFlowStateByKey(dotConditionFre) != null) {//是流程触发事件状态
            formTriggerBean.setFlowState(dotConditionFre);
        } else {
            formTriggerBean.setFlowState(null);
            formTriggerConditionBean.setParam(dotConditionFre);

            if (TriggerConditionState.Condition_Operation.getKey().equals(dotConditionFre)) {
                formTriggerConditionBean.setNewRight(baseInfo.get("add"));
                formTriggerConditionBean.setModifyRight(baseInfo.get("update"));
            }
        }
        String fieldConditionId = baseInfo.get("fieldConditionId");
        String formulaValue = baseInfo.get("fieldConditionValue");
        formTriggerConditionBean.setId("".equals(fieldConditionId) ? UUIDLong.longUUID() : Long.parseLong(fieldConditionId));
        formTriggerConditionBean.setType(ConditionType.form.getKey());
        FormFormulaBean formulaBean = new FormFormulaBean(fb);
        if (Strings.isBlank(formulaValue)) {
            formTriggerConditionBean.setFormulaId("");
        } else {
            formTriggerBean.addFormula(formulaBean);
            formulaBean.loadFromFormula(formulaValue);
            if (!Strings.isBlank(baseInfo.get("fieldConditionFormulaId"))) {
                formulaBean.setFormulaId(Long.parseLong(baseInfo.get("fieldConditionFormulaId")));
            }
            formTriggerConditionBean.setFormulaId(formulaBean.getFormulaId() == null ? "" : ("" + formulaBean.getFormulaId()));
            formTriggerConditionBean.setFormFormulaBean(formulaBean);
        }
        formTriggerConditionBean.setOperation("and");
        conditions.add(formTriggerConditionBean);

        //时间调度
        String timeConditionId = baseInfo.get("timeConditionId");
        String timeQuartz = baseInfo.get("timeQuartz");
        if (timeQuartz == null || Strings.isBlank(timeQuartz)) {
            formTriggerConditionBean.setOperation(null);
        } else {
            if (!Strings.isBlank(timeQuartz)) {
                String[] timeQuarts = timeQuartz.split("\\|");
                formTriggerConditionBean = new FormTriggerConditionBean(formTriggerBean);
                formTriggerConditionBean.setParam(timeQuarts[0]);
                formTriggerConditionBean.setTriggerTime(timeQuarts[2]);
                formulaBean = new FormFormulaBean(fb);
                formTriggerBean.addFormula(formulaBean);
                formulaBean.loadFromFormula(timeQuarts[1]);
                if (!Strings.isBlank(baseInfo.get("timeFormulaId"))) {
                    formulaBean.setFormulaId(Long.parseLong(baseInfo.get("timeFormulaId")));
                }
                formTriggerConditionBean.setId(Strings.isBlank(timeConditionId) ? UUIDLong.longUUID() : Long.parseLong(timeConditionId));
                formTriggerConditionBean.setType(ConditionType.date.getKey());
                formTriggerConditionBean.setFormulaId(formulaBean.getFormulaId() == null ? "" : ("" + formulaBean.getFormulaId()));
                formTriggerConditionBean.setFormFormulaBean(formulaBean);
                conditions.add(formTriggerConditionBean);
            }
        }
        for (Map<String, String> actionMap : actionList) {
            //非标准触发接口实现时，会传过来很多只有一个ConfigValue的键值对，而不是整个页面的信息，因此导致触发保存失败，此处增加过滤
            if(actionMap.keySet().size() > 1){
                actionMap.put("triggerId", String.valueOf(formTriggerBean.getId()));
                String actionType = actionMap.get("actionType");
                FormTriggerActionBean actionBean = FormTriggerUtil.getTriggerActionManager(actionType).getActionFromMap(actionMap);
                actionBean.setFormTriggerBean(formTriggerBean);
                actions.add(actionBean);

                //如果是双向，并且设置了反馈，除了保存双向去，同时保存双向回：1、在保存表单的时候用来保存目标表单的双向回；2、在编辑表单联动的时候用来回显双向回。
                if (Enums.TriggerType.BILATERAL_GO.getKey().equals(actionType)) {
                    actionBean = FormTriggerUtil.getTriggerActionManager(Enums.TriggerType.BILATERAL_BACK.getKey()).getActionFromMap(actionMap);
                    actionBean.setFormTriggerBean(formTriggerBean);
                    actions.add(actionBean);
                }
            }
        }
        formTriggerBean.setEdit(1);
    }

    @Override
    public String deleteTrigger4Cache(List<String> ids) {
        FormBean fb = formManager.getEditingForm();
        for (String id : ids) {
            fb.removeTrigger(Long.parseLong(id));
        }
        return "success";
    }

    /**
     * 显示、编辑触发、联动、自动更新设置
     * 点击行为显示，点击修改为编辑
     * */
    @Override
    public Map<String, Object> editTrigger(String id) throws BusinessException {
        FormBean fb = formManager.getEditingForm();
        FormTriggerBean formTriggerBean = fb.getFormTriggerBean(Long.parseLong(id));
        Map<String, Object> map = new HashMap<String, Object>();
        if (formTriggerBean != null) {
            map.put("triggerId", formTriggerBean.getId());
            map.put("triggerType", formTriggerBean.getType());
            map.put("triggerName", formTriggerBean.getName());
            map.put("state", formTriggerBean.getState());
            if (formTriggerBean.getFlowState() != null && Strings.isNotBlank(formTriggerBean.getFlowState())) {
                map.put("dotConditionValue", formTriggerBean.getFlowState());
            }

            for (FormTriggerConditionBean conditionBean : formTriggerBean.getConditions()) {
                ConditionType dataFieldType = ConditionType.getEnumByKey(conditionBean.getType());
                switch (dataFieldType) {
                    case flow:
                        map.put("dotConditionId", conditionBean.getId());
                        map.put("dotConditionValue", conditionBean.getFormulaId());
                        break;
                    case form:
                        if (conditionBean.getParam() != null && Strings.isNotBlank(conditionBean.getParam())) {
                            map.put("dotConditionValue", conditionBean.getParam());
                        }
                        map.put("add", conditionBean.getNewRight());
                        map.put("update", conditionBean.getModifyRight());
                        map.put("fieldConditionId", conditionBean.getId());
                        map.put("fieldConditionFormulaId", conditionBean.getFormulaId());
                        map.put("fieldConditionValue", conditionBean.getFormFormulaBean() == null ? "" : conditionBean.getFormFormulaBean().getFormulaForDisplay());
                        break;
                    case date:
                        map.put("timeConditionId", conditionBean.getId());
                        map.put("timeFormulaId", conditionBean.getFormulaId());
                        map.put("timeQuartz", conditionBean.getParam() + "|" + conditionBean.getFormFormulaBean().getFormulaForDisplay() + "|" + conditionBean.getTriggerTime());
                        break;
                    default:
                        break;
                }
            }

            if(!map.containsKey("timeQuartz")){
                map.put("timeConditionId", "");
                map.put("timeFormulaId", "");
                map.put("timeQuartz","");
            }

            List<Map<String, Object>> actions = new ArrayList<Map<String, Object>>();
            map.put("actions", actions);

            FormTriggerActionBean backAction = null;
            for (FormTriggerActionBean action : formTriggerBean.getActions()) {
                if (Enums.TriggerType.BILATERAL_BACK.getKey().equals(action.getType())) {
                    backAction = action;
                }
            }
            for (FormTriggerActionBean action : formTriggerBean.getActions()) {
                if (!Enums.TriggerType.BILATERAL_BACK.getKey().equals(action.getType())) {
                    Map<String, Object> paramMap = action.getActionManager().getParamMap(action, fb);
                    //如果有双向回，将双向回属性放在双向去属性中用来页面回显
                    if (Enums.TriggerType.BILATERAL_GO.getKey().equals(action.getType()) && backAction != null) {
                        paramMap.putAll(backAction.getActionManager().getParamMap(backAction, fb));
                    }
                    actions.add(paramMap);
                }
            }
        }
        return map;
    }
    
    /**
     * 显示、编辑触发、联动、自动更新设置
     * 点击行为显示，点击拷贝为编辑
     * */
    @Override
    public Map<String, Object> copyTrigger(String id) throws BusinessException {
        FormBean fb = formManager.getEditingForm();
        FormTriggerBean formTriggerBean = fb.getFormTriggerBean(Long.parseLong(id));
        Map<String, Object> map = new HashMap<String, Object>();
        if (formTriggerBean != null) {
            map.put("triggerId", "");
            map.put("triggerType", formTriggerBean.getType());
            String strNewName = String.format("%s-copy-%d", formTriggerBean.getName(),formTriggerBean.getId());
            map.put("triggerName", strNewName);
            map.put("state", formTriggerBean.getState());
            if (formTriggerBean.getFlowState() != null && Strings.isNotBlank(formTriggerBean.getFlowState())) {
                map.put("dotConditionValue", formTriggerBean.getFlowState());
            }

            for (FormTriggerConditionBean conditionBean : formTriggerBean.getConditions()) {
                ConditionType dataFieldType = ConditionType.getEnumByKey(conditionBean.getType());
                switch (dataFieldType) {
                    case flow:
                        map.put("dotConditionId", conditionBean.getId());
                        map.put("dotConditionValue", conditionBean.getFormulaId());
                        break;
                    case form:
                        if (conditionBean.getParam() != null && Strings.isNotBlank(conditionBean.getParam())) {
                            map.put("dotConditionValue", conditionBean.getParam());
                        }
                        map.put("add", conditionBean.getNewRight());
                        map.put("update", conditionBean.getModifyRight());
                        map.put("fieldConditionId", conditionBean.getId());
                        map.put("fieldConditionFormulaId", conditionBean.getFormulaId());
                        map.put("fieldConditionValue", conditionBean.getFormFormulaBean() == null ? "" : conditionBean.getFormFormulaBean().getFormulaForDisplay());
                        break;
                    case date:
                        map.put("timeConditionId", conditionBean.getId());
                        map.put("timeFormulaId", conditionBean.getFormulaId());
                        map.put("timeQuartz", conditionBean.getParam() + "|" + conditionBean.getFormFormulaBean().getFormulaForDisplay() + "|" + conditionBean.getTriggerTime());
                        break;
                    default:
                        break;
                }
            }

            if(!map.containsKey("timeQuartz")){
                map.put("timeConditionId", "");
                map.put("timeFormulaId", "");
                map.put("timeQuartz","");
            }

            List<Map<String, Object>> actions = new ArrayList<Map<String, Object>>();
            map.put("actions", actions);

            FormTriggerActionBean backAction = null;
            for (FormTriggerActionBean action : formTriggerBean.getActions()) {
                if (Enums.TriggerType.BILATERAL_BACK.getKey().equals(action.getType())) {
                    backAction = action;
                }
            }
            for (FormTriggerActionBean action : formTriggerBean.getActions()) {
                if (!Enums.TriggerType.BILATERAL_BACK.getKey().equals(action.getType())) {
                    Map<String, Object> paramMap = action.getActionManager().getParamMap(action, fb);
                    //如果有双向回，将双向回属性放在双向去属性中用来页面回显
                    if (Enums.TriggerType.BILATERAL_GO.getKey().equals(action.getType()) && backAction != null) {
                        paramMap.putAll(backAction.getActionManager().getParamMap(backAction, fb));
                    }
                    actions.add(paramMap);
                }
            }
        }
        return map;
    }

	@Override
	public List<FormFieldBean> getOutwriteField(String formId) throws BusinessException {
		List<FormFieldBean> resultList = new ArrayList<FormFieldBean>();
		if(Strings.isBlank(formId)){
			return resultList;
		}
		FormBean fb = formCacheManager.getForm(Long.parseLong(formId));
		String tableName = "";
        if (Strings.isNotEmpty(fb.getUniqueFieldList())){
            List<String> uniqueFieldList = fb.getUniqueFieldList().get(0);
            if(uniqueFieldList!=null&&uniqueFieldList.size()>0){
                for(String n:uniqueFieldList){
                    FormTableBean tableBean = fb.getFormTableBeanByFieldName(n);
                    if(!tableBean.isMainTable()){
                        tableName = tableBean.getTableName();
                        break;
                    }
                }
            }
        }
		List<FormFieldBean> list = fb.getAllFieldBeans();
		for(FormFieldBean ffb:list){
		    try {
                ffb = (FormFieldBean) ffb.clone();
            } catch (CloneNotSupportedException e) {
            	LOGGER.error(e.getMessage(), e);
            }
			if(ffb.getInputType().equals(FormFieldComEnum.OUTWRITE.getKey())){
				ffb.putExtraAttr("uniqueTableName", tableName);//位置标示的表名称，用于前台判断
				resultList.add(ffb);
			}
		}
		return resultList;
	}

	@SuppressWarnings("unchecked")
    @Override
	public Object saveOrUpdateFillBackSet(List<Map<String,Object>> fillBackList) throws BusinessException{
		FormBean fb = formManager.getEditingForm();
		String msg = checkField(fb, fillBackList);
		if(msg != null){
		    return msg;
		}
		Map<Long, FormTriggerBean> triggerMap = fb.getTriggerConfigMap();
		Iterator<Map.Entry<Long, FormTriggerBean>> it = triggerMap.entrySet().iterator();
		List<Long> removeList = new ArrayList<Long>();
		while(it.hasNext()){
			Map.Entry<Long, FormTriggerBean> tempEntry = it.next();
			if(tempEntry.getValue().getType() == TriggerType.fillBackSet.getKey()){
				removeList.add(tempEntry.getKey());
			}
		}
		Map<Long,FormTriggerBean> newTriggerMap = new LinkedHashMap<Long,FormTriggerBean>();
		FormTriggerBean formTriggerBean;
        List<String> sb = new ArrayList<String>();
		for(Map<String,Object> map:fillBackList){
            String id = map.get("id")==null?"":map.get("id").toString();
			boolean isNew = false;
			if(Strings.isNotBlank(id)){
				formTriggerBean = triggerMap.get(Long.parseLong(id));
			}else{
				isNew = true;
				formTriggerBean = new FormTriggerBean(fb);
				formTriggerBean.setId(UUIDLong.longUUID());
				formTriggerBean.setCreateTime(DateUtil.get19DateAndTime());
				formTriggerBean.setCreator(AppContext.currentUserId());
			}
			formTriggerBean.setModifyTime(DateUtil.get19DateAndTime());
			Object columTable = map.get("refColumTable");
			List<Map<String,Object>> submitFillList = null;
			if (columTable instanceof Map) {
                Map<String,Object> new_name = (Map<String,Object>) columTable;
                submitFillList = new ArrayList<Map<String,Object>>();
                submitFillList.add(new_name);
            }
			if (columTable instanceof List) {
			    submitFillList = (List<Map<String, Object>>) columTable;
            }
			if(Strings.isBlank((String)map.get("formId"))){
				continue;
			}
			if(submitFillList.size()==1&&Strings.isBlank((String)submitFillList.get(0).get("refColumNames"))){
				continue;
			}
			newTriggerMap.put(formTriggerBean.getId(), formTriggerBean);
			//fb.addTriggerBean(formTriggerBean);
            String name = map.get("triggerName").toString();
            //协同V5OA-131017【V6.0sp1_9月修复包】如图所示的回写设置，开始名称一个是“1”，一个是“2”；修改其中任意一个，去掉后面数字，保存时提示不能重复。
            boolean isDiffacultName = false;
            for(String fillBackName:sb){
                if(fillBackName.equals(name)){
                    isDiffacultName = true;
                    break;
                }
            }
            if(isDiffacultName){
                return ResourceUtil.getString("form.echoSetting.triggername.error2.label");//回写名称不能重复！
            }else{
                sb.add(name);
            }
			List<FormTriggerActionBean> actions = new ArrayList<FormTriggerActionBean>();
			formTriggerBean.setActions(actions);
			formTriggerBean.setFormId(fb.getId());
			formTriggerBean.setType(TriggerType.fillBackSet.getKey());
			long refFormId = Long.parseLong(map.get("formId").toString());
			//formTriggerBean.setName(formCacheManager.getForm(refFormId).getFormName());
            formTriggerBean.setName(map.get("triggerName").toString());
			formTriggerBean.setState(TriggerState.Enable.getKey());
			formTriggerBean.setFlowState(map.get("pointData").toString());
			
			List<FormTriggerConditionBean> conditions = formTriggerBean.getConditions();
			FormTriggerConditionBean formTriggerConditionBean;
			//条件
			if(isNew){
				formTriggerConditionBean = new FormTriggerConditionBean(formTriggerBean);
				conditions.add(formTriggerConditionBean);
				formTriggerConditionBean.setId(UUIDLong.longUUID());
				formTriggerConditionBean.setType(ConditionType.form.getKey());
				formTriggerConditionBean.setParam(getString4DefaultValue(map.get("formId"),""));
				String condition = getString4DefaultValue(map.get("condition"),"");
				String conditionId = getString4DefaultValue(map.get("conditionId"),"");
				if(Strings.isNotBlank(conditionId)){
					formTriggerConditionBean.setFormulaId(conditionId);
				}else{
					if(Strings.isNotBlank(condition)){
						FormFormulaBean formulaBean = new FormFormulaBean(fb);
						formTriggerBean.addFormula(formulaBean);
						formulaBean.loadFromFormula(condition);
						formTriggerConditionBean.setFormulaId(formulaBean.getFormulaId() == null ? "" : ("" + formulaBean.getFormulaId()));
						formTriggerConditionBean.setFormFormulaBean(formulaBean);
					}
				}
				formTriggerBean.setConditions(conditions);
			} else {
			    formTriggerConditionBean = conditions.get(0);
			    String conditionId = getString4DefaultValue(map.get("conditionId"),"");
			    formTriggerConditionBean.setFormulaId(conditionId);
			    formTriggerConditionBean.setParam(getString4DefaultValue(map.get("formId"),""));
			}
			
			//action
			FormTriggerActionBean actionBean = new FormTriggerActionBean();
			actionBean.setActionManager(FormTriggerUtil.getCanUseTriggerActionManager("calculate"));
			actions.add(actionBean);
			actionBean.setId(UUIDLong.longUUID());
			actionBean.setType("calculate");
            actionBean.setName("触发回写");
			actionBean.addParam(ParamType.FormId.getKey(), map.get("formId"));
			actionBean.addParam(ParamType.Withholding.getKey(), map.get("withholding"));
			actionBean.addParam(ParamType.AddSlaveRow.getKey(), map.get("addSlaveRow"));
			List<Map<String,Object>> fillList = new ArrayList<Map<String,Object>>();
			actionBean.addParam(ParamType.FillInBack.getKey(), fillList);
			for(Map<String,Object> fillMap:submitFillList){
				Map<String,Object> prop = new LinkedHashMap<String,Object>();
				prop.put(IXmlNodeName.type, fillMap.get("fillType").toString());
				prop.put(IXmlNodeName.key, fillMap.get("refColumNames").toString());
				String rowcondition = fillMap.get("rowcondition").toString();
				if (Strings.isNotBlank(rowcondition)){
				    FormFormulaBean formulaBean = new FormFormulaBean(fb);
				    formTriggerBean.addFormula(formulaBean);
				    formulaBean.loadFromFormula(rowcondition);
				    prop.put(IXmlNodeName.RowCondition, formulaBean);
				}
				if(fillMap.get("fillType").toString().equals(FillBackType.formula.getKey())){
					FormFormulaBean formulaBean = new FormFormulaBean(fb);
					formTriggerBean.addFormula(formulaBean);
					formulaBean.loadFromFormula(fillMap.get("calcExpression").toString());
					prop.put(IXmlNodeName.value, formulaBean);
				}else{
					prop.put(IXmlNodeName.value, fillMap.get("calcField").toString());
				}
				fillList.add(prop);
			}
		}
		for(Long temId:removeList){
			triggerMap.remove(temId);
		}
		fb.getTriggerConfigMap().putAll(newTriggerMap);
		return "";
	}

	/**
	 * 校验回写值
	 * @throws BusinessException
	 */
	private String checkField(FormBean srcFb,List<Map<String,Object>> fillBackList) throws BusinessException{
        if(srcFb != null && fillBackList != null){
            for(Map<String,Object> map:fillBackList){
                Object columTable = map.get("refColumTable");
                List<Map<String,Object>> submitFillList = null;
                if (columTable instanceof Map) {
                    Map<String,Object> new_name = (Map<String,Object>) columTable;
                    submitFillList = new ArrayList<Map<String,Object>>();
                    submitFillList.add(new_name);
                }
                if (columTable instanceof List) {
                    submitFillList = (List<Map<String, Object>>) columTable;
                }
                if(Strings.isBlank((String)map.get("formId"))){
                    continue;
                }
                if(submitFillList.size()==1&&Strings.isBlank((String)submitFillList.get(0).get("refColumNames"))){
                    continue;
                }
                long tarFormId = Long.parseLong(map.get("formId").toString());
                FormBean tarForm = formCacheManager.getForm(tarFormId);
                for(Map<String,Object> fillMap:submitFillList){
                    if(fillMap.get("fillType").toString().equals(FillBackType.copy.getKey())){
                        String tarFieldName= fillMap.get("refColumNames").toString();
                        String srcFieldName = fillMap.get("calcField").toString();
                        if(srcFieldName != null && tarFieldName != null){
                            FormFieldBean srcFfb = srcFb.getFieldBeanByName(srcFieldName.substring(srcFieldName.indexOf(".")+1));
                            FormFieldBean tarFfb = tarForm.getFieldBeanByName(tarFieldName.substring(tarFieldName.indexOf(".")+1));
                            if(tarFfb != null && tarFfb.getInputTypeEnum() == FormFieldComEnum.OUTWRITE && FormFieldComEnum.SELECT.getKey().equals(tarFfb.getFormatType())){
                                long formatEnumId = tarFfb.getFormatEnumId();
                                int formatEnumLevel = tarFfb.getFormatEnumLevel();
                                boolean formatEnumIsFinalChild = tarFfb.isFormatEnumIsFinalChild();
                                if(srcFfb != null && formatEnumId != 0){
                                    long enumId = 0L;
                                    int enumLevel = 0;
                                    boolean isFinalChild = false;
                                    FormFieldBean srcFinal = srcFfb.findRealFieldBean();
                                    if(srcFinal != null){
                                        if(FormFieldComEnum.SELECT == srcFinal.getInputTypeEnum() || FormFieldComEnum.RADIO ==  srcFinal.getInputTypeEnum()){
                                            enumId = srcFinal.getEnumId();
                                            enumLevel = srcFinal.getEnumLevel();
                                            isFinalChild = srcFinal.getIsFinalChild();
                                        }else if(FormFieldComEnum.OUTWRITE == srcFinal.getInputTypeEnum()){
                                            enumId = srcFinal.getFormatEnumId();
                                            enumLevel = srcFinal.getFormatEnumLevel();
                                            isFinalChild = srcFinal.isFormatEnumIsFinalChild();
                                        }else{
                                            return ResourceUtil.getString("form.echoSetting.check.outwrite.type", tarForm.getFormName(), tarFfb.getDisplay() ,srcFinal.getDisplay());
                                        }
                                        if(formatEnumId != enumId){
                                            return ResourceUtil.getString("form.echoSetting.check.outwrite.enum", tarForm.getFormName(), tarFfb.getDisplay() ,srcFinal.getDisplay());
                                        }
                                        if(formatEnumLevel != enumLevel || formatEnumIsFinalChild != isFinalChild){
                                            return ResourceUtil.getString("form.echoSetting.check.outwrite.enumlevel", tarForm.getFormName(), tarFfb.getDisplay() ,srcFinal.getDisplay());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return null;
    }

	private String getString4DefaultValue(Object o,String defaultValue){
		return (o!=null?o.toString():defaultValue);
	}

    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.trigger.FormTriggerDesignManager#getSubTableNameFromCondition(java.lang.String)
     */
    @Override
    public String getSubTableNameFromCondition(String condition) throws BusinessException {
        return this.getSubTableNameFromCondition(condition, true);
    }

    @Override
    public String getSubTableNameFromCondition(String condition, FormBean formBean) throws BusinessException {
        return getSubTableNameFromCondition(condition, formBean, true);
    }
    
    /* (non-Javadoc)
     * @see com.seeyon.ctp.form.modules.trigger.FormTriggerDesignManager#getSubTableNameFromCondition(java.lang.String, boolean)
     */
    @Override
    public String getSubTableNameFromCondition(String condition, boolean needDefault) throws BusinessException {
        FormBean formBean = this.formManager.getEditingForm();
        return getSubTableNameFromCondition(condition, formBean, needDefault);
    }

    @Override
    public String getSubTableNameFromCondition(String condition, FormBean formBean, boolean needDefault) {
        FormFormulaBean formulaBean = new FormFormulaBean(formBean);
        formulaBean.loadFromFormula(condition);
        Set<FormFieldBean> fieldBeans = formulaBean.getInFormulaFormFieldBean();
        FormTableBean tableBean;
        for (FormFieldBean formFieldBean : fieldBeans) {
            tableBean = formBean.getFormTableBeanByFieldName(formFieldBean.getName());
            if(null != tableBean && !tableBean.isMainTable()){
                return tableBean.getTableName();
            }
        }
        if (needDefault){
            List<FormTableBean> beans = formBean.getSubTableBean();
            if(Strings.isNotEmpty(beans) && beans.size()==1){
                return beans.get(0).getTableName();
            }
        }
        return "";
    }

    @Override
    public String getSubTableBean4Msg(String msg, boolean needDefault) throws BusinessException {
        FormBean formBean = this.formManager.getEditingForm();
        Set<FormTableBean> beans = FormTriggerUtil.getSubTableBean4Msg(msg,formBean);
        if (Strings.isNotEmpty(beans) && beans.size() == FormNumConstant.NUM_ONE){
            Iterator<FormTableBean> iterator = beans.iterator();
            return iterator.next().getTableName();
        }
        if (needDefault){
            return formBean.getDefaultSubTableName();
        }
        return null;
    }

    @Override
    public boolean senderIsSubField(String condition, String sender) throws BusinessException {

        String [] ret = TriggerUtil.getFieldName(sender);

        FormBean formBean = this.formManager.getEditingForm();

        //没有重复表，或者重复表只有一个时，不限制
        if (Strings.isEmpty(formBean.getSubTableBean()) || formBean.getSubTableBean().size() == 1) {
            return false;
        }

        //如果是主表字段，不用修改发起人
        FormTableBean temptableBean = formBean.getFormTableBeanByFieldName(ret[1]);
        if(temptableBean.isMainTable()){
            return false;
        }
        Set<FormTableBean> set = getTableBean4DataCondition(condition, formBean);
        return !set.contains(temptableBean);
    }

    private Set<FormTableBean> getTableBean4DataCondition(final String condition, final FormBean formBean) {

        FormFormulaBean formulaBean = new FormFormulaBean(formBean);
        formulaBean.loadFromFormula(condition);
        Set<FormFieldBean> fieldBeans = formulaBean.getInFormulaFormFieldBean();
        Set<FormTableBean> set = new HashSet<FormTableBean>();
        for (FormFieldBean fieldBean : fieldBeans) {
            set.add(formBean.getTableByTableName(fieldBean.getOwnerTableName()));
        }
        return set;
    }

    @Override
    public boolean senderIsSubField(String condition, String msg, String sender) throws BusinessException {
        String [] ret = TriggerUtil.getFieldName(sender);

        FormBean formBean = this.formManager.getEditingForm();
        if (formBean.getSubTableBean().size() <= 1) {
            return false;
        }
        //如果是主表字段，不用修改发起人
        FormTableBean temptableBean = formBean.getFormTableBeanByFieldName(ret[1]);
        if(temptableBean.isMainTable()){
            return false;
        }

        Set<FormTableBean> conditionSet = getTableBean4DataCondition(condition, formBean);
        Set<FormTableBean> msgSet = FormTriggerUtil.getSubTableBean4Msg(condition, formBean);
        return !conditionSet.contains(temptableBean) && !msgSet.contains(temptableBean);
    }

    /* (non-Javadoc)
             * @see com.seeyon.ctp.form.modules.trigger.FormTriggerDesignManager#getFormTemplateList(com.seeyon.ctp.common.authenticate.domain.User, java.lang.String, java.lang.String, boolean)
             */
    @Override
    public List<Map<String, String>> getFormTemplateList(User user, String condition, String textfield, boolean isAll)
            throws BusinessException {
        List<Map<String,String>> templateList = new ArrayList<Map<String,String>>();
        List<FormType> tempList = new ArrayList<FormType>();
        tempList.add(FormType.processesForm);
        List<FormBean> beans = FormService.getMyOwnForms(tempList);
        List<FormBean> tempBeans = new ArrayList<FormBean>();
        for (FormBean formBean : beans) {
            if(this.formManager.isEnabled(formBean.getId())){
                tempBeans.add(formBean);
            }
        }
        beans = tempBeans;
        tempBeans = new ArrayList<FormBean>();
        if(Strings.isNotBlank(condition) && searchCondtion.categoryId.name().equals(condition)){
            Long catg = Long.parseLong(textfield);
            for (FormBean formBean : beans) {
                if(formBean.getCategoryId() == catg){
                    tempBeans.add(formBean);
                }
            }
            beans = tempBeans;
        }
        beans.remove(this.formManager.getEditingForm());
        List<CtpTemplate> templates = this.formDefinitionDAO.selectTemplate4Forms(new HashMap<String, Object>(),beans, 0l);
        if(Strings.isNotBlank(condition) && searchCondtion.subject.name().equals(condition)){
            List<CtpTemplate> tempCtpTemplates = new ArrayList<CtpTemplate>();
            for (CtpTemplate ctpTemplate : templates) {
                if(ctpTemplate.getSubject().contains(textfield)){
                    tempCtpTemplates.add(ctpTemplate);
                }
            }
            templates = tempCtpTemplates;
        }
        if(Strings.isEmpty(templates)){
            return templateList;
        }
        Set<Long> catgs = new HashSet<Long>();
        Set<Long> templateIdset = new HashSet<Long>();
        boolean hasOtherAccountTempalte = false;
        V3xOrgAccount account;
        for (CtpTemplate ctpTemplate : templates) {
            if(!ctpTemplate.isSystem()){
                continue;
            }
            if (!templateIdset.add(ctpTemplate.getId())){
                continue;
            }
            Map<String,String> map4 = new HashMap<String,String>();
            map4.put("value", ctpTemplate.getId()+"");
            map4.put("parentValue", ctpTemplate.getCategoryId()+"");
            map4.put("name", ctpTemplate.getSubject());
            map4.put("type", "son");
            map4.put("canSelecte", "true");
            if(!ctpTemplate.getOrgAccountId().equals(user.getLoginAccount())){
                account = this.orgManager.getAccountById(ctpTemplate.getOrgAccountId());
                if(account != null){
                    map4.put("name", "("+account.getShortName()+")"+ctpTemplate.getSubject());
                }
                hasOtherAccountTempalte = true;
                map4.put("parentValue", "-1");
            }else{
                catgs.add(ctpTemplate.getCategoryId());
            }
            templateList.add(map4);
        }
        CtpTemplateCategory category;
        for (Long long1 : catgs) {
            category = this.templateManager.getCtpTemplateCategory(long1);
            if(category == null){
                continue;
            }
            Map<String,String> map4 = new HashMap<String,String>();
            map4.put("value", category.getId()+"");
            map4.put("parentValue", "0");
            map4.put("name", ResourceUtil.getString(category.getName()));
            map4.put("canSelecte", "false");
            templateList.add(map4);
        }
        if (hasOtherAccountTempalte){
            Map<String,String> map4 = new HashMap<String,String>();
            map4.put("value", "-1");
            map4.put("parentValue", "0");
            map4.put("canSelecte", "false");
            map4.put("name", ResourceUtil.getString("formsection.config.choose.otheraccounttemplate"));
            templateList.add(map4);
        }
        return templateList;
    }

    @Override
    public FlipInfo getFormTemplateList(FlipInfo fi, Map<String, Object> params) throws BusinessException {
        FormBean editingForm = this.formManager.getEditingForm();
        List<FormBean> beans = this.formCacheManager.getFormsByType(FormType.baseInfo.getKey());
        beans.addAll(this.formCacheManager.getFormsByType(FormType.manageInfo.getKey()));
		if (params != null ){
			if (params.get("formcategory") != null){
				beans = this.formCacheManager.getFormsByType(Integer.parseInt((String) params.get("formcategory")));
			}
			if (params.get("category") != null){
				long catgId = Long.parseLong((String) params.get("category"));
				List<FormBean> temp = new ArrayList<FormBean>();
				for (FormBean formBean : beans) {
					if (formBean.getCategoryId() == catgId){
						temp.add(formBean);
					}
				}
				beans = temp;
			}
			if (params.get("formname") != null){
				String formName = (String) params.get("formname");
				List<FormBean> temp = new ArrayList<FormBean>();
				for (FormBean formBean : beans) {
					if (formBean.getFormName().contains(formName)){
						temp.add(formBean);
					}
				}
				beans = temp;
			}
		}
		List<Map<String,String>> data = new ArrayList<Map<String,String>>();
		Map<String,String> map;
		CtpTemplateCategory category;
        for (FormBean formBean : beans) {
            if (formBean.getOwnerId() != AppContext.currentUserId() || formBean.getId().equals(editingForm.getId()) || !formCacheManager.isEnabled(formBean)) {
                continue;
            }
			category = this.templateManager.getCtpTemplateCategory(formBean.getCategoryId());
			if(null == category){
				LOGGER.error("表单：("+formBean.getId() + " " + formBean.getFormName() + ")" + "的category获取不到，categoryid：" + formBean.getCategoryId());
				continue;
			}
			Map<String, FormBindAuthBean> unTemplates = formBean.getBind().getUnFlowTemplateMap();
			for (Entry<String, FormBindAuthBean> et : unTemplates.entrySet()) {
				FormBindAuthBean template = et.getValue();
				if (params != null && params.get("templateName") != null){
					String name = (String) params.get("templateName");
					if (!template.getName().contains(name)){
						continue;
					}
				}
				map = new HashMap<String, String>();
				map.put("id", template.getId().toString());
				map.put("name", template.getName());
				map.put("createtime", DateUtil.format(formBean.getCreateDate(), DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN));
				map.put("modifytime", DateUtil.format(formBean.getModifyDate(), DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN));
				map.put("formname", formBean.getFormName());
				map.put("category", category.getName());
				map.put("formtype", FormType.getEnumByKey(formBean.getFormType()).getValue());
				map.put("formId", formBean.getId().toString());
				data.add(map);
			}
		}
		int start = fi.getStartAt();
		Collections.sort(data, TriggerUnflowTemplateCompare.getInstance());
		List<Map<String,String>> newMapList = new ArrayList<Map<String,String>>();
		for(int i = start; null != data && i < data.size()&&i<start+fi.getSize();i++){
			newMapList.add(data.get(i));
		}
		fi.setTotal(data.size());
		fi.setData(newMapList);
		return fi;
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
     * @return the formDefinitionDAO
     */
    public FormDefinitionDAO getFormDefinitionDAO() {
        return formDefinitionDAO;
    }

    /**
     * @param formDefinitionDAO the formDefinitionDAO to set
     */
    public void setFormDefinitionDAO(FormDefinitionDAO formDefinitionDAO) {
        this.formDefinitionDAO = formDefinitionDAO;
    }

    /**
     * @return the orgManager
     */
    public OrgManager getOrgManager() {
        return orgManager;
    }

    /**
     * @param orgManager the orgManager to set
     */
    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    /**
     * @param formCacheManager the formCacheManager to set
     */
    public void setFormCacheManager(FormCacheManager formCacheManager) {
        this.formCacheManager = formCacheManager;
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

    public void setFormTriggerManager(FormTriggerManager formTriggerManager) {
        this.formTriggerManager = formTriggerManager;
    }

}
