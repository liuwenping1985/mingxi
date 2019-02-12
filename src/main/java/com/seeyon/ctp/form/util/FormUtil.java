package com.seeyon.ctp.form.util;

import static com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ViewAttrValue.formContent;

import java.io.File;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.Deque;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.hibernate.dialect.Dialect;

import com.seeyon.ctp.cluster.ClusterConfigBean;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.Constants.login_useragent_from;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormAuthViewFieldBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean;
import com.seeyon.ctp.form.bean.FormBindBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.bean.FormFormulaBean;
import com.seeyon.ctp.form.bean.FormQueryWhereClause;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.bean.FormUserFieldBean;
import com.seeyon.ctp.form.bean.FormViewBean;
import com.seeyon.ctp.form.bean.SimpleObjectBean;
import com.seeyon.ctp.form.formContent.FormContentManager;
import com.seeyon.ctp.form.formContent.IFormContent;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.ConditionSymbol;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.FunctionSymbol;
import com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.SystemDataField;
import com.seeyon.ctp.form.modules.engin.formula.FormulaFunctionUitl;
import com.seeyon.ctp.form.modules.engin.formula.function.FormFormulaFunctionCompareEnumValue;
import com.seeyon.ctp.form.modules.engin.formula.validate.FormulaValidate;
import com.seeyon.ctp.form.modules.engin.formula.validate.Stack;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums;
import com.seeyon.ctp.form.po.FormOwner;
import com.seeyon.ctp.form.po.FormRelation;
import com.seeyon.ctp.form.po.FormResource;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FieldType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormDataRatifyFlagEnum;
import com.seeyon.ctp.form.util.Enums.FormDataStateEnum;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.FromDataFinishedFlagEnum;
import com.seeyon.ctp.form.util.Enums.MasterTableField;
import com.seeyon.ctp.form.util.Enums.TemplateType;
import com.seeyon.ctp.form.util.Enums.WorkFlowDealOpitionType;
import com.seeyon.ctp.form.util.infopath.InfoPathNodeName;
import com.seeyon.ctp.form.util.infopath.InfoPath_DataElement;
import com.seeyon.ctp.form.util.infopath.InfoPath_DataElement.TDataType;
import com.seeyon.ctp.form.util.infopath.InfoPath_DataGroup;
import com.seeyon.ctp.form.util.infopath.InfoPath_xsd;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.manager.JoinOrgManagerDirect;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.rest.resources.vo.FormFieldValueBaseRestVO;
import com.seeyon.ctp.rest.resources.vo.FormMasterBeanRestVO;
import com.seeyon.ctp.rest.resources.vo.FormMasterTableBeanRestVO;
import com.seeyon.ctp.rest.resources.vo.FormTableBeanRestVO;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.util.WorkflowUtil;

public class FormUtil {

    private static final Log LOG = CtpLogFactory.getLog(FormUtil.class);

    public static String FIELDNAME = "fieldName";//名称
    public static String LEFTCHAR = "leftChar";//左边括号
    public static String OPERATION = "operation";//操作符号
    public static String RIGHTCHAR = "rightChar";//右边括号
    public static String FIELDVALUE = "fieldValue";
    public static String ROWOPERATION = "rowOperation";

    public static void setMapList4SimpleObject(String name, String value, List<SimpleObjectBean> list, Map<String, Object> map, FormBean fb) {
        StringBuilder names = new StringBuilder("");
        StringBuilder values = new StringBuilder("");
        for (int i = 0; i < list.size(); i++) {
            StringBuilder temp = new StringBuilder("");
            SimpleObjectBean o = list.get(i);
            String s = i == (list.size() - 1) ? "" : ",";
            String n = o.getName();
            names.append(n).append(s);
            String v = o.getValue();
            String fieldName = n.substring(n.indexOf(".") + 1);
            String realDisplay = null;
            if (fb.getFieldBeanByName(fieldName) != null) {
                realDisplay = fb.getFieldBeanByName(fieldName).getDisplay();
            } else {
                //系统数据域
                realDisplay = SystemDataField.getEnumByKey(n).getText();
            }
            temp.append(realDisplay);
            if (v.contains("(") && v.contains(")") && v.indexOf("(") < v.indexOf(")")) {
                temp.append(v.substring(v.indexOf("("), v.indexOf(")") + 1));
            }
            if ("orderByNameList".equals(name) || "oldOrderByNameList".equals(name)) {
                SimpleObjectBean.OrderByValue order = SimpleObjectBean.OrderByValue.getEnumByKey(v);
                temp.append(order.getSymbol());
            }
            v = temp.toString();
            values.append(v).append(s);
        }
        map.put(name, names.toString());
        map.put(value, values.toString());
    }

    /**
     * 无流程表单应用绑定 自定义查询 设置 
     * @param name
     * @param value
     * @param list
     * @param map
     * @param fb
     */
    public static void setMapList4SimpleObject4Search(List<SimpleObjectBean> list, Map<String, Object> map, FormBean fb) {
        StringBuilder values = new StringBuilder("");
        List<Map<String,String>> searchFieldNameList = new ArrayList<Map<String,String>>();
        for (int i = 0; i < list.size(); i++) {
            StringBuilder temp = new StringBuilder("");
            SimpleObjectBean o = list.get(i);
            String s = i == (list.size() - 1) ? "" : ",";
            String n = o.getName();
            String v = o.getValue();
            String fieldName = n.substring(n.indexOf(".") + 1);
            String realDisplay = null;
            if (fb.getFieldBeanByName(fieldName) != null) {
                realDisplay = fb.getFieldBeanByName(fieldName).getDisplay();
            } else {
                //系统数据域
                realDisplay = SystemDataField.getEnumByKey(n).getText();
            }
            temp.append(realDisplay);
            if (v.contains("(") && v.contains(")") && v.indexOf("(") < v.indexOf(")")) {
                temp.append(v.substring(v.indexOf("("), v.indexOf(")") + 1));
            }
            
            v = temp.toString();
            values.append(v).append(s);
            String defaultValJson = o.getExtAttr(SimpleObjectBean.ExtMap.DefaultValJSON.getKey());
            if(Strings.isNotBlank(defaultValJson)){
            	searchFieldNameList.add(JSONUtil.parseJSONString(defaultValJson, Map.class));
            }else{
                Map<String,String> defaultMap = new HashMap<String,String>();
                defaultMap.put("value",v);
                defaultMap.put("key",n);
                searchFieldNameList.add(defaultMap);
            }
        }
        //searchFieldNameList
        map.put("searchFieldNameList", JSONUtil.toJSONString(searchFieldNameList));
        //searchFieldList
        map.put("searchFieldList", values.toString());
    }
    public static List<SimpleObjectBean> getSimpleObjectList(String type, String names, String values) {
        List<SimpleObjectBean> list = new ArrayList<SimpleObjectBean>();
        SimpleObjectBean simpleObj;
        if (!Strings.isBlank(names)) {
            String[] name = names.split(",");
            String[] value = values.split(",");
            for (int i = 0; i < name.length; i++) {
                String temp = name[i];
                if (Strings.isNotBlank(temp)) {
                    String va = SimpleObjectBean.ColumnType.OrderBy.getKey().equals(type) ? SimpleObjectBean.OrderByValue.getEnumBySymbol(value[i].substring(value[i].length() - 1)).getKey() : value[i];
                    simpleObj = new SimpleObjectBean(0l, type, temp, va);
                    list.add(simpleObj);
                }
            }
        }
        return list;
    }

    /**
     * 无流程表单应用绑定 自定义查询 设置 
     * @param type
     * @param names 查询设置JSON串
     * @return
     */
    public static List<SimpleObjectBean> getSimpleObjectList4Search(String type, String names) {
    	List<SimpleObjectBean> list = new ArrayList<SimpleObjectBean>();
    	if(SimpleObjectBean.ColumnType.SearchField.getKey().equals(type)){
    		SimpleObjectBean simpleObj;
            if (!Strings.isBlank(names)) {
            	List<Map<String,String>> searchList = JSONUtil.parseJSONString(names, List.class);
            	for(Map<String,String> map:searchList){
            		String temp = map.get("key");
            		String va = map.get("value");
            		 simpleObj = new SimpleObjectBean(0l, type, temp, va);
            		 simpleObj.addExtAttr(SimpleObjectBean.ExtMap.DefaultValJSON.getKey(), JSONUtil.toJSONString(map));
            		 list.add(simpleObj);
            	}
            }
    	}
        return list;
    }
    /**
     * 转换成前端可以显示的json对象
     *
     * @param formula
     * @return
     */
    public static String getConditionJson(String formula) {
        return JSONUtil.toJSONString(getConditionMap(formula));
    }

    public static Object[] preDealFlowCondition(FormBean formBean, Map<String, Object> datas, FormFormulaBean systemCondition, boolean needTableName) throws BusinessException {
        return preDealFlowCondition(formBean, datas, systemCondition, needTableName, true);
    }

    public static Object[] preDealFlowCondition(FormBean formBean, Map<String, Object> datas, FormFormulaBean systemCondition, boolean needTableName, boolean hasIncludeChildDepartment) throws BusinessException {
        List<FormUserFieldBean> userFieldBeans = new ArrayList<FormUserFieldBean>();
        List<FormFieldBean> fieldBeans = formBean.getMasterTableBean().getFields();
        String formula = systemCondition.getFormulaForDisplay();
        formula = FormulaValidate.replaceCurrentFieldWithValue(formula, formBean, datas);
        FormFormulaBean realBean = new FormFormulaBean(formBean);
        realBean.loadFromFormula(formula);
        Map<String, String> map = new HashMap<String, String>();
        for (FormFieldBean fieldBean : fieldBeans) {
            FormUserFieldBean userFieldBean = new FormUserFieldBean(fieldBean, FormBean.FLOW_PREFIX, false);
            userFieldBeans.add(userFieldBean);
            Object value = datas.get(fieldBean.getName());
            map.put("[" + userFieldBean.getName() + "]", value == null ? "" : value.toString());
        }
        return getSQLByFormula(realBean, map, userFieldBeans, formBean, needTableName, hasIncludeChildDepartment);
    }

    /**
     * @param formula
     * @return
     */
    public static List<Map<String, String>> getConditionMap(String formula) {
        List<Map<String, String>> conditionList = new ArrayList<Map<String, String>>();
        Map<String, String> sm;
        String rowReg = "([\\)|}| ]and[\\(|{| ])|([\\)|}| ]or[\\(|{| ])";
        String[] rowCon = formula.split(rowReg);
        Pattern p = Pattern.compile(rowReg);
        Matcher m = p.matcher(formula);
        List<String> op = new ArrayList<String>();
        while (m.find()) {
            op.add(m.group());
        }
        String reg = "(xor)|(like)|(nolike)|(==)|(<>)|(<=)|(>=)|(=)|(<)|(>)";
        for (int i = 0; i < rowCon.length; i++) {
            sm = new HashMap<String, String>();
            conditionList.add(sm);
            String str = rowCon[i];
            String[] nameAndvalue = str.split(reg);

            p = Pattern.compile(reg);
            m = p.matcher(str);
            if (m.find()) {
                sm.put("operation", m.group());
            }
            String name = nameAndvalue[0].trim();
            if (name.startsWith("(")) {
                sm.put("leftChar", "(");
                sm.put("fieldName", name.replace("(", "").trim());
            } else {
                sm.put("fieldName", name);
            }
            String value = nameAndvalue[1].trim();
            if (value.endsWith(")")) {
                p = Pattern.compile("\\(");
                m = p.matcher(value);
                int leftcount = 0;
                while (m.find()) {
                    leftcount++;
                }
                p = Pattern.compile("\\)");
                m = p.matcher(value);
                int rightcount = 0;
                while (m.find()) {
                    rightcount++;
                }
                if (rightcount - 1 == leftcount) {
                    sm.put("rightChar", ")");
                    sm.put("fieldValue", value.substring(0, value.length() - 1).trim());
                } else {
                    sm.put("fieldValue", value);
                }
            } else {
                sm.put("fieldValue", value);
            }
            if (i < rowCon.length - 1) {
                sm.put("rowOperation", op.get(i));
            }
        }
        return conditionList;
    }


    /**
     * 获取选人界面的回显值
     *
     * @param mem
     * @param fb
     * @return
     * @throws BusinessException
     */
    public static String getShowMemNameByIds(String mem, FormBean fb) throws BusinessException {
        StringBuilder sb = new StringBuilder("");//名称
        OrgManager extendMemberOrgManager = (OrgManager) AppContext.getBean("orgManager");
        if (!Strings.isBlank(mem)) {
            String[] m = mem.split(",");
            for (String n : m) {
                sb.append(getShowMemNameByEntity(fb, extendMemberOrgManager, n));
            }
        }
        String tempStr = sb.toString();
        return !Strings.isBlank(tempStr) ? tempStr.substring(0, tempStr.length() - 1) : "";
    }

    public static String getShowMemNameByEntity(FormBean fb, OrgManager extendMemberOrgManager, String key) throws BusinessException {
        StringBuilder sb = new StringBuilder("");
        String n = key.replace("Node|", "");
        if (n.contains("field")) {
            String regex = "(field\\d{4,})";// 字段的正在表达式
            Pattern p = Pattern.compile(regex);
            Matcher matcher = p.matcher(n);
            String fieldName = "";
            if (matcher.find()) {
                fieldName = matcher.group();
            }
            FormFieldBean fieldBean = fb.getFieldBeanByName(fieldName);
            if (fieldBean != null) {
                sb.append(getShowMemNameByRole(fieldBean.getDisplay(), n.substring(n.lastIndexOf("#") + 1)));
            } else {
                sb.append("无控件").append(",");
            }
        } else if (n.contains("_Post")) {
            String[] deptPost = n.split("\\|")[1].split("_");
            V3xOrgDepartment entity = extendMemberOrgManager.getDepartmentById(Long.parseLong(deptPost[0]));
            V3xOrgPost post = extendMemberOrgManager.getPostById(Long.parseLong(deptPost[1]));
            if (entity != null && post != null) {
                sb.append(entity.getName()).append("-").append(FormTriggerUtil.getOrgEntityName(post, extendMemberOrgManager)).append(",");
            }
        } else if (n.contains("_Role")) {
            String[] deptPost = n.split("\\|")[1].split("_");
            V3xOrgDepartment entity = extendMemberOrgManager.getDepartmentById(Long.parseLong(deptPost[0]));
            if (entity == null) {
                return sb.toString();
            }
            V3xOrgRole role;
            try {
                Long roleId = Long.parseLong(deptPost[1]);
                role = extendMemberOrgManager.getRoleById(roleId);
            } catch (Exception e) {
                role = extendMemberOrgManager.getRoleByName(deptPost[1], AppContext.currentAccountId());
            }
            if (role == null) {
                return sb.toString();
            }
            sb.append(entity.getName()).append("-").append(FormTriggerUtil.getOrgEntityName(role, extendMemberOrgManager)).append(",");
        } else if (n.contains("SenderSuperDept")) {//发起者上级部门角色
            sb.append(getShowMemNameByRole(ResourceUtil.getString("sys.role.rolename.SenderSuperDept"), n.replace("SenderSuperDept", "")));
        } else if (n.contains("SenderSuperAccount")) {
            sb.append(getShowMemNameByRole(ResourceUtil.getString("sys.role.rolename.SenderSuperAccount"), n.replace("SenderSuperAccount", "")));
        } else if (n.contains("Sender")) {
            sb.append(getShowMemNameByRole(ResourceUtil.getString("workflow.sys.role.rolename.sender"), n.replace("Sender", "")));
        } else {
            List<V3xOrgEntity> orgList = extendMemberOrgManager.getEntities(n);
            for (V3xOrgEntity o : orgList) {
                V3xOrgAccount account = extendMemberOrgManager.getAccountById(o.getOrgAccountId());
                if(account != null && AppContext.currentAccountId() != account.getId()){
                    sb.append(o.getName()).append("(").append(account.getName()).append(")").append(",");
                } else {
                    sb.append(o.getName()).append(",");
                }
            }
        }
        return sb.toString();
    }

    public static String getShowMemNameByRole(String type, String role) {
        String value = "";
        OrgManager extendMemberOrgManager = (OrgManager) AppContext.getBean("orgManager");
        JoinOrgManagerDirect joinOrgManagerDirect = (JoinOrgManagerDirect) AppContext.getBean("joinOrgManagerDirect");
        //固定角色的，其名称可能会修改过，因此需要重新查询一遍，而不能取固定的值
        if (role.contains("Departmentexchange") || role.contains("DepAdmin") || role.contains("DepLeader") || role.contains("DepManager")
                || role.contains("DeptMember") || role.contains("DepartmentSpecialTrainAdmin") || role.contains("ReciprocalRoleReporter")
                || role.contains("AccountLeader")) {
            String roleName = "";
            try {
                List<V3xOrgRole> roleList = extendMemberOrgManager.getRoleByCode(role, AppContext.currentAccountId());
                if (Strings.isNotEmpty(roleList)) {
                    roleName = roleList.get(0).getShowName();
                }
            } catch (Exception e) {
                LOG.error("根据角色编码查询角色异常！角色编码：" + role);
            }
            if (Strings.isBlank(roleName)) {
                if (role.contains("Departmentexchange")) {//发起者部门公文收发员
                    roleName = ResourceUtil.getString("sys.role.rolename.Departmentexchange");
                } else if (role.contains("DepAdmin")) {//发起者部门管理员
                    roleName = ResourceUtil.getString("sys.role.rolename.DepAdmin");
                } else if (role.contains("DepLeader")) {//发起者部门分管领导
                    roleName = ResourceUtil.getString("sys.role.rolename.DepLeader");
                } else if (role.contains("DepManager")) {//发起者部门主管
                    roleName = ResourceUtil.getString("sys.role.rolename.DepManager");
                } else if (role.contains("DeptMember")) {//发起者部门成员
                    roleName = ResourceUtil.getString("selectPeople.node.DeptMember") + "(" + ResourceUtil.getString("common.selectPeople.excludechilddepartment") + ")";
                } else if (role.contains("DepartmentSpecialTrainAdmin")) {//部门公文收发员
                    roleName = ResourceUtil.getString("sys.role.rolename.DepartmentSpecialTrainAdmin");
                } else if (role.contains("ReciprocalRoleReporter")) {//汇报人
                    roleName = ResourceUtil.getString("sys.role.rolename.ReciprocalRoleReporter");
                } else if (role.contains("AccountLeader")){//单位分管领导
                    roleName = ResourceUtil.getString("sys.role.rolename.AccountLeader");
                }
            }
            value = (type + roleName + "、");
        } else {//发起者
        	if(role.startsWith(WorkflowUtil.VJOIN)){
        		String roleIdTemp= role.substring(WorkflowUtil.VJOIN.length());
        		if(WorkflowUtil.isLong(roleIdTemp)){
        			role= roleIdTemp;
        		}
        	}
        	if(WorkflowUtil.isLong(role)){//id为数字
	            try {
	                Long roleId = Long.parseLong(role);
	                V3xOrgRole r = extendMemberOrgManager.getRoleById(roleId);
	                if (r != null) {
	                	if(r.getExternalType()!=0){
	                   	 value = (type + r.getShowName() + "（外）、");
	                    }else{
	                    	value = (type + r.getShowName() + "、");
	                    }
	                    
	                }
	            } catch (Exception e) {
	                value = type + "、";
	            }
        	}else{
        		try {
	        		V3xOrgRole r = null;
	            	if(role.startsWith("Vjoin")){//可能是vjoin角色
	            		r= joinOrgManagerDirect.getRoleByCode(role, null);
	            	}
	            	if(null==r){
	            		r = extendMemberOrgManager.getRoleByName(role, AppContext.currentAccountId());
	            	}
	            	if (r != null) {
	                	if(r.getExternalType()!=0){
	                   	 value = (type + r.getShowName() + "（外）、");
	                    }else{
	                    	value = (type + r.getShowName() + "、");
	                    }
	                }else{
	                	value = type + "、";
	                }
        		} catch (Exception e) {
	                value = type + "、";
	            }
        	}
        }
        return value;
    }

    /**
     * 获取组织机构的名称，如果与当前登录单位不一致时，加上单位简称
     *
     * @param entity 组织实体
     * @return 名称
     */
    public static String getOrgEntityName(V3xOrgEntity entity, OrgManager manager) throws BusinessException {
        String name = entity.getName();
        if (!entity.getOrgAccountId().equals(AppContext.currentAccountId())) {
            V3xOrgAccount account = manager.getAccountById(entity.getOrgAccountId());
            name += ("(" + account.getShortName() + ")");
        }
        return name;
    }

    /**
     * 从一个可执行的SQL里面 解析出用户控件 并找出与这个用户控件组成表达式的字段的fieldName
     *
     * @param formula
     * @param userConditionList
     */
    public static void setFieldNameByUserCondition(String formula, List<FormUserFieldBean> userConditionList) {
        String[] conditions = formula.split("\\sand\\s|\\sor\\s");
        String userReg = "";
        for (String condition : conditions) {
            for (FormUserFieldBean f : userConditionList) {
                if (f.getInputTypeEnum() == FormFieldComEnum.RELATIONFORM) {
                    userReg = "(\\s*" + f.getName() + "\\s*)";
                    Pattern p = Pattern.compile(userReg);
                    Matcher matcher = p.matcher(" " + condition + " ");
                    if (matcher.find()) {//查询有这个用户控件的
                        userReg = "(\\sfield\\d{4,}\\s)";
                        p = Pattern.compile(userReg);
                        matcher = p.matcher(" " + condition + " ");
                        if (matcher.find()) {
                            f.putExtraAttr("fieldName", matcher.group(0).trim());
                        }
                        break;
                    }
                } else {
                    if (condition.contains("[" + f.getName() + "]")) {
                        userReg = "(\\sfield\\d{4,}\\s)";
                        Pattern p = Pattern.compile(userReg);
                        Matcher matcher = p.matcher(" " + condition + " ");
                        if (matcher.find()) {
                            f.putExtraAttr("fieldName", matcher.group(0).trim());
                        }
                    }
                }
            }
        }
    }

    /**
     * 对于<>,not like,<,<=处理增加null
     *
     * @param sql
     * @return
     */
    public static String changeAndAddNullWhereSql(String sql) {
        StringBuffer sb = new StringBuffer();
        String result = sql;
        if (result.contains(ConditionSymbol.notEqual.getKey()) || result.contains(ConditionSymbol.lessAndEqual.getKey())
                || result.contains(ConditionSymbol.lessThan.getKey()) || result.contains("not like")) {
            sb = new StringBuffer();
            Pattern p = Pattern.compile("(\\w+\\.\\w+|\\w+\\.|\\w+|lower\\(\\w+\\.?\\w+\\))\\s*(not like|<>)\\s*(\"[^\"]*\"|'[^']*'|\\[[^\\[]*\\]|(-?\\d+)(\\.\\d+)?|\\?|to_date\\([^\\)]*\\))");
            Matcher matcher = p.matcher(result);
            while (matcher.find()) {
                String group1 = matcher.group(1).trim();//FIELD
                String group2 = matcher.group(2).trim();//操作符
                String group3 = matcher.group(3).trim();//实际值
                matcher.appendReplacement(sb, " ( " + group1 + " " + group2 + " " + group3 + " or " + group1 + " is null" + " ) ");
            }
            matcher.appendTail(sb);
            result = sb.toString();
        }
        return result;
    }

    /**
     * 对于>=、>、<=、<、=、<>处理null
     * >=、>、<>：is not null；<=、<、=：is null
     *
     * @param result
     * @return
     */
    public static String changeNullWhereSql(String sql) {
        StringBuffer sb = new StringBuffer();
        String result = sql;
        if (result.contains(ConditionSymbol.greatAndEqual.getKey()) ||
                result.contains(ConditionSymbol.greatThan.getKey()) ||
                result.contains(ConditionSymbol.lessAndEqual.getKey()) ||
                result.contains(ConditionSymbol.lessThan.getKey()) ||
                result.contains(ConditionSymbol.equal.getKey()) ||
                result.contains(ConditionSymbol.notEqual.getKey())) {
            sb = new StringBuffer();
            Pattern p = Pattern.compile("(\\w+\\.\\w+|\\w+\\.|\\w+|lower\\(\\w+\\))\\s*(>=|>|<=|<|=|<>)\\s*((n|N)(u|U)(l|L)(l|L))");
            Matcher matcher = p.matcher(result);
            while (matcher.find()) {
                String group1 = matcher.group(1).trim();//FIELD
                String group2 = matcher.group(2).trim();//操作符
                //String group3 = matcher.group(3).trim();//实际值
                if ("<>".equals(group2)) {
                    matcher.appendReplacement(sb, group1 + " is not null");
                }
                if (">=".equals(group2) || "<=".equals(group2) || "=".equals(group2)) {
                    matcher.appendReplacement(sb, group1 + " is null");
                }
            }
            matcher.appendTail(sb);
            result = sb.toString();

            sb = new StringBuffer();
            p = Pattern.compile("((n|N)(u|U)(l|L)(l|L))\\s*(>=|>|<=|<|=|<>)\\s*(\\w+\\.\\w+|\\w+\\.|\\w+|lower\\(\\w+\\))");
            matcher = p.matcher(result);
            while (matcher.find()) {
                String group1 = matcher.group(1).trim();//实际值
                String group6 = matcher.group(6).trim();//操作符
                String group7 = matcher.group(7).trim();//FIELD
                if ("<>".equals(group6)) {
                    matcher.appendReplacement(sb, group7 + " is not null");
                }
                if (">=".equals(group6) || "<=".equals(group6) || "=".equals(group6)) {
                    matcher.appendReplacement(sb, group7 + " is null");
                }
            }
            matcher.appendTail(sb);
            result = sb.toString();
        }
        return result;
    }

    /**
     * 过滤条件式，去掉多余的括号，包括前括号和多余的后括号
     * 截取临界值：前括号第一次没有后括号匹配时，后括号第一次没有匹配的前括号
     *
     * @param contion 需要过滤的条件式
     * @return 过滤后的条件
     */
    public static String getCondition(String contion) {
        Stack<Integer> bracketStack4All = new Stack<Integer>();
        int i = 0;
        for (int len = contion.length(); i < len; ) {
            char ch = contion.charAt(i);
            int count = 1;
            boolean isEnd = false;
            switch (ch) {
                case '(':
                    bracketStack4All.push(i);
                    break;
                case ')':
                    if (bracketStack4All.size() <= 0) {
                        isEnd = true;
                        break;
                    }
                    bracketStack4All.pop();
                    break;
                case '\'':
                case '"':
                    //判断单引号和双引号前面是否有转义字符，有的话不作为表达式特殊符号
                    char last = i == 0 ? ' ' : contion.charAt(i - 1);
                    if (last != '\\') {
                        //找到字符串的开始和结束字符，作为一个元素放入
                        //Stack<Character> quoteStack = new Stack<Character>();
                        //quoteStack.push(ch);
                        for (int j = i + 1; j < len; j++) {
                            char ch2 = contion.charAt(j);
                            char last2 = contion.charAt(j - 1);
                            if (ch2 == ch) {
                                if (last2 != '\\') {
                                    count = j - i + 1;
                                    break;
                                }
                            }
                        }
                    }
                    break;
                default:
                    break;
            }
            if (isEnd) {
                break;
            }
            i += count;
        }
        if (bracketStack4All.size() > 0) {
            Integer index = bracketStack4All.pop();
            return contion.substring(index + 1);
        } else if (i != contion.length()) {
            return contion.substring(0, i);
        }
        return contion;
    }

    public static Object[] getSQLByFormula(FormFormulaBean ffb, Map<String, String> userFastCon, List<FormUserFieldBean> userConditionList) throws BusinessException {
        return getSQLByFormula(ffb, userFastCon, userConditionList, null, false);
    }

    /**
     * 处理用户输入条件
     *
     * @param ffb               用户输入条件
     * @param userFastCon       页面条件值
     * @param userConditionList 用户变量
     * @param fb                当前表单
     * @param needTableName     是否需要表名
     * @throws BusinessException
     */
    public static Object[] getSQLByFormula(FormFormulaBean ffb, Map<String, String> userFastCon, List<FormUserFieldBean> userConditionList, FormBean fb, boolean needTableName) throws BusinessException {
        return getSQLByFormula(ffb, userFastCon, userConditionList, null, needTableName, true);
    }

    /**
     * 处理用户输入条件
     *
     * @param ffb                       用户输入条件
     * @param userFastCon               页面条件值
     * @param userConditionList         用户变量
     * @param fb                        当前表单
     * @param needTableName             是否需要表名
     * @param hasIncludeChildDepartment 是否包含子部门
     * @throws BusinessException
     */
    public static Object[] getSQLByFormula(FormFormulaBean ffb, Map<String, String> userFastCon, List<FormUserFieldBean> userConditionList, FormBean fb, boolean needTableName, boolean hasIncludeChildDepartment) throws BusinessException {
        String returnSql = ffb.getExecuteFormulaForSQL(hasIncludeChildDepartment, needTableName);
        List<Object> param = new ArrayList<Object>();
        if (Strings.isNotBlank(returnSql)) {
            String[] conditions = returnSql.split("\\sand\\s|\\sor\\s");
            for (String condition : conditions) {
                //对于有to_date函数的不进行处理
                if ((condition.contains(FunctionSymbol.to_date.getKey()) || condition.contains("CONVERT")) && !condition.matches(".*(\\[[^\\]]*\\]).*")) {
                    continue;
                }
                //不包含用户变量的不执行替换
                if (!condition.matches(".*(\\[[^\\]]*\\]).*")) {
                    //以前这里只判断了等号的情况，会导致>= <=的条件式在sqlserver下解析有问题，这里先判断，如果后续需要处理>=这种情况，请先用>=来拆分条件，如果没有>=的情况，才用=号拆分
                    if (condition.indexOf("=") > -1 && condition.indexOf(">=") == -1 && condition.indexOf("<=") == -1) {
                        String[] carr = condition.split("=");
                        if (carr != null && carr.length > 1) {
                            StringBuilder dateFormat = new StringBuilder();
                            if ("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())) {
                                dateFormat.append("TO_CHAR(").append(carr[0]).append(",'yyyy-MM-dd')");
                            } else if (JDBCAgent.getDBType().indexOf("server") != -1) {
                                dateFormat.append("CONVERT(varchar(100), ").append(carr[0]).append(", 23)");
                            } else if ("postgresql".equals(JDBCAgent.getDBType())) {
                                dateFormat.append("TO_CHAR(").append(carr[0]).append(",'YYYY-MM-DD')");
                            } else {
                                dateFormat.append("DATE_FORMAT(").append(carr[0]).append(",'%Y-%m-%d')");
                            }
                            String tempCarr = carr[1].trim().replaceAll("'", "");
                            if (tempCarr.matches("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}")) {
                                carr[1] = tempCarr.indexOf(" ") > -1 ? tempCarr.substring(0, tempCarr.indexOf(" ")) : tempCarr;
                                returnSql = returnSql.replace(condition, dateFormat.toString() + " = '" + carr[1] + "'");
                            }
                        }
                    }
                    continue;
                }
                if (condition.contains("(") || condition.contains(")")) {
                    condition = getCondition(condition);
                }
                //此处用空格进行分割是因为FormFormulaBean.getExecuteFormulaForSQL方法处理后的每个condition中都加了一个空格
                String[] str = condition.split(" ");
                String value = "";
                String opt = "";
                String field = "", ufield = "";
                //我去，测试设置[当前登录人员部门Id] = [xxx] 这样的毫无实际意义的条件，妈的
                String fixedValue = "";
                for (String temp : str) {
                    if (temp.matches(".*(\\[[^\\]]*\\]).*")) {
                        value = temp;
                    } else if (temp.matches(".*(>=)|(<=)|(<>)|(>)|(<)|(=)|(like)|(not like).*")) {
                        opt = temp;
                    } else if (temp.matches(".*(field\\d{4}).*") || temp.contains("start_date") || temp.contains("start_member_id") || temp.contains("modify_date")) {
                        field = ufield = temp;
                    }else {
                        fixedValue = temp;
                    }
                }

                for (FormUserFieldBean fufb : userConditionList) {
                    String userFieldName = "[" + fufb.getName() + "]";
                    if (value.contains(userFieldName) || field.contains(userFieldName)) {// 找到需要替换的用户变量
                        if (fufb.getName().equals(field.trim())) {// 用户条件在前
                            ufield = value;
                        }
                        String userFieldValue = null;
                        if (userFastCon != null) {
                            userFieldValue = getValue(fufb, userFastCon.get(userFieldName));
                        }
                        if (Strings.isBlank(userFieldValue)) {// 用户变量客户没有输入，则替换为空
                            returnSql = returnSql.replace(condition, "1=1");
                        } else {// 客户输入了用户变量
                            //TODO  sql注入
                            if (fufb.getInputTypeEnum() == FormFieldComEnum.RADIO || fufb.getInputTypeEnum() == FormFieldComEnum.SELECT) {
                                returnSql = returnSql.replace(condition, getUserFieldRadioString(userFieldValue, field, opt));
                            } else if (fufb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DEPARTMENT) {
                                returnSql = returnSql.replace(condition, getDepartmentsLogicString(userFieldValue, "".equals(field)?fixedValue:field, opt));
                            } else if (fufb.getInputTypeEnum() == FormFieldComEnum.EXTEND_MULTI_DEPARTMENT) {
                                returnSql = returnSql.replace(condition, getSqlForMultilDepartmentEqualNotEqual(userFieldValue, "".equals(field)?fixedValue:field, opt));
                            } else {
                                if (opt.contains("like")) {
                                    param.add("%" + SQLWildcardUtil.escape(userFieldValue.toLowerCase()) + "%");
                                    returnSql = returnSql.replace(condition, condition.replace(userFieldName, " ? "));
                                } else {
                                    Object vObject = getHQLObject(ffb.findFormBean(), ufield.trim(), userFieldValue);// 日期的情况下会报错
                                    if (fufb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATE) {
                                        param.add(vObject != null && String.valueOf(vObject).indexOf(" ") > -1 ? String.valueOf(vObject).substring(0, String.valueOf(vObject).indexOf(" ")) : vObject);
                                        // 为空时左边是具体的值，而不是字段，此时正则匹配操作符，然后split取第一个就是具体值
                                        if (Strings.isEmpty(ufield)) {
                                            String op = "";
                                            Pattern p = Pattern.compile("((>=)|(<=)|(<>)|(>)|(<)|(=))");
                                            Matcher matcher = p.matcher(condition);
                                            while (matcher.find()) {
                                                op = matcher.group(1).trim();
                                            }
                                            if (Strings.isNotEmpty(op)) {
                                                ufield = condition.split(op)[0];
                                            }
                                        }
                                        StringBuilder dateFormat = new StringBuilder();
                                        if ("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())) {
                                            dateFormat.append("TO_CHAR(").append(ufield).append(",'yyyy-MM-dd')");
                                        } else if (JDBCAgent.getDBType().indexOf("server") != -1) {
                                            dateFormat.append("CONVERT(varchar(100), ").append(ufield).append(", 23)");
                                        } else if ("postgresql".equals(JDBCAgent.getDBType())) {
                                            dateFormat.append("TO_CHAR(").append(ufield).append(",'YYYY-MM-DD')");
                                        } else {
                                            dateFormat.append("DATE_FORMAT(").append(ufield).append(",'%Y-%m-%d')");
                                        }
                                        returnSql = returnSql.replace(condition, condition.replace(userFieldName, " ? ").replace(ufield, dateFormat.toString()));
                                    } else if (fufb.getInputTypeEnum() == FormFieldComEnum.EXTEND_DATETIME) {
                                        param.add(userFieldValue);
                                        StringBuilder dateFormat = new StringBuilder();
                                        if ("oracle".equals(JDBCAgent.getDBType()) || "dm dbms".equals(JDBCAgent.getDBType())) {
                                            dateFormat.append("TO_CHAR(").append(ufield).append(",'YYYY-MM-DD HH24:MI')");
                                        } else if (JDBCAgent.getDBType().indexOf("server") != -1) {
                                            //sqlserver 没有直接截取年月日时分的函数，只能这样转换一次了
                                            dateFormat.append("SUBSTRING(CONVERT(varchar(100),").append(ufield).append(",120),1,16)");
                                        } else if ("postgresql".equals(JDBCAgent.getDBType())) {
                                            dateFormat.append("TO_CHAR(").append(ufield).append(",'YYYY-MM-DD HH24:MI')");
                                        } else {
                                            dateFormat.append("DATE_FORMAT(").append(ufield).append(",'%Y-%m-%d %H:%i')");
                                        }
                                        returnSql = returnSql.replace(condition, condition.replace(userFieldName, " ? ").replace(ufield, dateFormat.toString()));
                                    } else {
                                        param.add(vObject);
                                        returnSql = returnSql.replace(condition, condition.replace(userFieldName, " ? "));
                                    }
                                }
                            }
                        }
                        break;
                    }
                }
            }
        }
        return new Object[]{returnSql, param};
    }

    /**
     * 处理用户输入控件单选的前端复选问题
     *
     * @param value
     * @param field
     * @param operator
     * @return
     */
    public static String getUserFieldRadioString(String value, String field, String operator) {
        if (Strings.isBlank(value)) {
            return field + operator + value;
        }
        StringBuilder sb = new StringBuilder(" ( ");
        String[] strs = value.split(",");
        int len = strs.length;
        for (int i = 0; i < len; i++) {
            String str = strs[i];
            sb.append(field).append(operator).append(str);
            if (i != len - 1) {
                sb.append(" or ");
            }
        }
        return sb.append(" )").toString();
    }

    /**
     * 取得部门与子部门口串(如field0001 = xxx1 or field0001 =xxx2)
     * ps:此接口主要处理单部门控件的"="与不"<>"以及多部门的include函数的处理
     *
     * @param id
     * @param field
     * @param operator
     * @return
     */
    public static String getDepartmentsLogicString(String id, String field, String operator) {
        if (Strings.isBlank(id)) {
            return field + operator + "'" + id + "'";
        }
        StringBuilder sb = new StringBuilder(" ");
        String percent = operator.indexOf("like") >= 0 ? "%" : "";
        /**
         * 此处应该分情况
         * operator为'=' 或 like： field 等于 部门 及其子部门
         *      包含子部门：field=1 or field=1.1 or field = 1.2
         *      不包含子部门：field = 1
         * operator为'<>':field不等于某部门及其子部门
         *      包含子部门：field<>1 and field <> 1.1 and field <> 1.2
         *      不包含子部门： field <> 1
         */
        if (!id.contains("|1")) {//包含子部门
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            try {
                V3xOrgDepartment dept = orgManager.getDepartmentById(Long.parseLong(id));
                if (dept != null) {
                    List<V3xOrgDepartment> list = orgManager.getChildDepartments(dept.getId(), false);
                    if (list != null) {
                        String logicOp = operator.indexOf("<>") >= 0 ? " and " : " or ";
                        sb.append(" ( ");
                        sb.append(field + operator + " '" + percent + id + percent + "' ");
                        int len = list.size();
                        for (int i = 0; i < len; i++) {
                            V3xOrgDepartment v3xOrgDepartment = list.get(i);
                            sb.append(logicOp);
                            sb.append(field + operator + " '" + percent + v3xOrgDepartment.getId() + percent + "' ");
                        }
                        sb.append(" ) ");
                    }
                } else {
                    //非部门控件
                    sb.append(field + operator + " '" + percent + id + percent + "' ");
                }
            } catch (Exception e) {
                sb.append(field + operator + " '" + percent + id + percent + "' ");
            }
        } else {//不包含子部门
            sb.append(field + operator + " '" + percent + id.substring(0, id.indexOf("|")) + percent + "' ");
        }
        return sb.toString();
    }

    /**
     * 取得部门与子部门口串
     * 主要用于多部门控件的"="与"<>"的处理
     *
     * @param id
     * @param field
     * @param operator
     * @return
     */
    public static String getSqlForMultilDepartmentEqualNotEqual(String id, String field, String operator) {
        if (Strings.isBlank(id)) {
            return field + operator + "'" + id + "'";
        }
        StringBuilder sb = new StringBuilder(" (");
        Map<String, Deque<String>> childDeptMap = new HashMap<String, Deque<String>>();
        //带有"|1"的id对应表
        Map<String, String> upMap = new HashMap<String, String>();
        //总条数
        int count = 1;
        OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
        String[] ids = id.split(",");
        for (String idi : ids) {
            if (!idi.contains("|1")) {//包含子部门
                try {
                    V3xOrgDepartment dept = orgManager.getDepartmentById(Long.parseLong(idi));
                    if (dept != null) {
                        Deque<String> childDetpDeque = new ArrayDeque<String>();
                        childDeptMap.put(idi, childDetpDeque);
                        childDetpDeque.offer(idi);
                        List<V3xOrgDepartment> list = orgManager.getChildDepartments(dept.getId(), false);
                        if (list != null && !list.isEmpty()) {
                            int len = list.size();
                            for (int i = 0; i < len; i++) {
                                V3xOrgDepartment v3xOrgDepartment = list.get(i);
                                childDetpDeque.offer(String.valueOf(v3xOrgDepartment.getId()));
                            }
                        }
                        count *= childDetpDeque.size();
                    }
                } catch (Exception e) {
                    LOG.error("---getDepartmentById error---->", e);
                }
            } else {
                //不包含子部门
                upMap.put(idi, idi.substring(0, idi.indexOf("|")));
            }
        }
        //是多部门控件需要处理
        if (!upMap.isEmpty() || !childDeptMap.isEmpty()) {
            String logicOp = operator.indexOf("<>") >= 0 ? " and " : " or ";
            for (int i = 0; i < count; i++) {
                String sbSub = id;
                //替换带"|1"
                Iterator<Entry<String, String>> upIt = upMap.entrySet().iterator();
                while (upIt.hasNext()) {
                    Entry<String, String> upItEn = upIt.next();
                    String key = upItEn.getKey();
                    String value = upItEn.getValue();
                    sbSub = sbSub.replace(key, value);
                }
                //替换子部门
                Iterator<Entry<String, Deque<String>>> childIt = childDeptMap.entrySet().iterator();
                while (childIt.hasNext()) {
                    Entry<String, Deque<String>> childItEn = childIt.next();
                    String key = childItEn.getKey();
                    Deque<String> deValue = childItEn.getValue();
                    String value = deValue.pollFirst();
                    if (value != null) {
                        sbSub = sbSub.replace(key, value);
                    }
                }
                sb.append(" " + field + operator + " '" + sbSub + "' ");
                if (i != count - 1) {
                    sb.append(" " + logicOp + " ");
                }
            }
        } else {
            sb.append(field + operator + " '" + id + "' ");
        }
        sb.append(")");
        return sb.toString();
    }

    /**
     * 取得部门与子部门口串以逗号间隔
     *
     * @param id
     * @return
     */
    public static String getDepartmentsCommaString(String id) {
        if (Strings.isBlank(id)) {
            return id;
        }
        StringBuilder sb = new StringBuilder();
        if (!id.contains("|1")) {//包含子部门
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            try {
                V3xOrgDepartment dept = orgManager.getDepartmentById(Long.parseLong(id));
                if (dept != null) {
                    List<V3xOrgDepartment> list = orgManager.getChildDepartments(dept.getId(), false);
                    sb.append("'").append(id).append("'");
                    if (list != null && !list.isEmpty()) {
                        sb.append(",");
                        int len = list.size();
                        for (int j = 0; j < len; j++) {
                            V3xOrgDepartment v3xOrgDepartment = list.get(j);
                            sb.append("'").append(v3xOrgDepartment.getId()).append("'");
                            if (j != len - 1) {
                                sb.append(",");
                            }
                        }
                    }
                } else {
                    //非部门控件
                    sb.append("'").append(id).append("'");
                }
            } catch (Exception e) {
                sb.append("'").append(id).append("'");
            }
        } else {//不包含子部门
            sb.append("'").append(id.substring(0, id.indexOf("|"))).append("'");
        }
        return sb.toString();
    }

    private static String getValue(FormUserFieldBean fuf, String value) {
        StringBuilder v = new StringBuilder("");
        if (Strings.isNotBlank(value) && !("0".equals(value) && fuf.getInputTypeEnum() == FormFieldComEnum.SELECT)) {
            if (fuf.getInputTypeEnum() == FormFieldComEnum.RADIO || fuf.getInputTypeEnum() == FormFieldComEnum.SELECT) {
                StringBuilder tempValue = new StringBuilder("");
                String[] vs = value.split(",");
                for (String va : vs) {
                    tempValue.append("'").append(va).append("',");
                }
                v.append(tempValue.substring(0, tempValue.length() - 1));
            } else {
                v.append(value);
            }
        }
        return v.toString();
    }

    /**
     * 根据条件列表获取对应的状态sql
     *
     * @param stateCon 条件列表
     * @return result
     */
    public static String getStateSQLStr(Map<String, Object> stateCon) {
        return getStateSQLStr(stateCon, null, false);
    }

    /**
     * 根据条件列表获取对应的状态sql
     *
     * @param stateCon      条件列表
     * @param fb            表单对象
     * @param needTableName 是否需要表名
     * @return result
     */
    public static String getStateSQLStr(Map<String, Object> stateCon, FormBean fb, boolean needTableName) {
        StringBuilder sb = new StringBuilder("");

        String finishedFlag = "finishedflag";
        String stateFlag = "state";
        String ratifyFlag = "ratifyflag";

        if (needTableName && fb != null) {
            finishedFlag = fb.getMasterTableBean().getTableName() + "." + finishedFlag;
            stateFlag = fb.getMasterTableBean().getTableName() + "." + stateFlag;
            ratifyFlag = fb.getMasterTableBean().getTableName() + "." + ratifyFlag;
        }

        //finishedflag:0=未结束→finishedflag:1=已结束→finishedflag:3=终止
        String finishFlag = "";
        finishFlag = finishFlag + (stateCon.get("finishedflag0") == null ? "" : (stateCon.get("finishedflag0").toString() + ","));
        finishFlag = finishFlag + (stateCon.get("finishedflag1") == null ? "" : (stateCon.get("finishedflag1").toString() + ","));
        finishFlag = finishFlag + (stateCon.get("finishedflag3") == null ? "" : (stateCon.get("finishedflag3").toString() + ","));
        if (Strings.isNotBlank(finishFlag.trim())) {
            sb.append(" ").append(finishedFlag).append(" in (").append(finishFlag).append("-1) ");
        }
        //state:0=草稿→state:1=未审核→state:2=审核通过→state:3=审核不通过
        String state = "";
        StringBuilder sb2 = new StringBuilder("");
        state = state + (stateCon.get("state0") == null ? "" : (stateCon.get("state0").toString() + ","));
        state = state + (stateCon.get("state1") == null ? "" : (stateCon.get("state1").toString() + ","));
        state = state + (stateCon.get("state2") == null ? "" : (stateCon.get("state2").toString() + ","));
        state = state + (stateCon.get("state3") == null ? "" : (stateCon.get("state3").toString() + ","));
        if (Strings.isNotBlank(state.trim())) {
            sb2.append(" ").append(stateFlag).append(" in (").append(state).append("-1) ");
        }
        //ratifyflag:0=未核定→ratifyflag:1=核定通过→ratifyflag:2=核定不通过
        String ratifyflag = "";
        ratifyflag = ratifyflag + (stateCon.get("ratifyflag0") == null ? "" : (stateCon.get("ratifyflag0").toString() + ","));
        ratifyflag = ratifyflag + (stateCon.get("ratifyflag1") == null ? "" : (stateCon.get("ratifyflag1").toString() + ","));
        ratifyflag = ratifyflag + (stateCon.get("ratifyflag2") == null ? "" : (stateCon.get("ratifyflag2").toString() + ","));
        if (Strings.isNotBlank(ratifyflag.trim())) {
            if (Strings.isNotBlank(sb2.toString().trim())) {
                sb2.append("or");
            }
            sb2.append(" ").append(ratifyFlag).append(" in (").append(ratifyflag).append("-1) ");
        }
        if (stateCon.get("state0") == null) { //草稿分开
            if (Strings.isNotBlank(sb2.toString().trim())) {
                sb2.append(" and ");
            }
            sb2.append(" ").append(stateFlag).append(" != ").append(FormDataStateEnum.FLOW_DRAFT.getKey()).append(" ");
        }
        if (Strings.isNotBlank(sb.toString().trim()) && Strings.isNotBlank(sb2.toString().trim())) {
            sb.append(" and (").append(sb2).append(") ");
        }
        return Strings.isNotBlank(sb.toString().trim()) ? ("(" + sb.toString() + " and " + stateFlag + " != -2)") : " " + stateFlag + " != -2 ";
    }

    /**
     * 处理前端的查询或搜索条件，将前段的条件式列表转换为对应的sql
     *
     * @param condition 条件列表
     * @param fb        表单bean对象
     * @return 二维数组：0 结果sql，1参数列表
     */
    public static Object[] getSQLStr(List<Map<String, Object>> condition, FormBean fb) {
        return getSQLStr(condition, fb, false);
    }

    private static String getFieldName4SQL(String fieldName, FormTableBean tableBean, boolean needTableName) {

        if (needTableName) {
            return tableBean.getTableName() + "." + fieldName;
        }
        return fieldName;
    }

    /**
     * 处理前端的查询或搜索条件，将前段的条件式列表转换为对应的sql
     *
     * @param condition     条件列表
     * @param fb            表单bean对象
     * @param needTableName 返回的结果sql是否需要包含字段所在表表名
     * @return 二维数组：0 结果sql，1参数列表
     */
    public static Object[] getSQLStr(List<Map<String, Object>> condition, FormBean fb, boolean needTableName) {
        List<Object> list = new ArrayList<Object>();
        Object[] result = {"", list};
        StringBuffer sb = new StringBuffer("");
        if (Strings.isNotEmpty(condition)) {//组装SQL
            sb.append("(");
            for (int i = 0; i < condition.size(); i++) {
                Map<String, Object> m = condition.get(i);
                FormFieldBean tempField = fb.getFieldBeanByName((String) m.get(FIELDNAME));
                //查询值为空时，直接替换为 1= 1；daiy 61968
                if (Strings.isBlank((String) m.get(FIELDVALUE)) || Strings.isBlank((String) m.get(FIELDNAME)) || ("0".equals(m.get(FIELDVALUE)) && tempField != null && tempField.getFinalInputType().equalsIgnoreCase(FormFieldComEnum.SELECT.getKey()))) {
                    sb.append(isNull2Str(m.get(LEFTCHAR)));
                    sb.append(" 1 = 1 ");
                    sb.append(isNull2Str(m.get(RIGHTCHAR))).append(" ");
                    if (i < condition.size() - 1) {
                        sb.append(m.get(ROWOPERATION).toString()).append(" ");
                    }
                    continue;
                }
                String fieldName = m.get(FIELDNAME).toString();
                sb.append(isNull2Str(m.get(LEFTCHAR)));
                if (fieldName.equals(MasterTableField.start_date.getKey()) || fieldName.equals(MasterTableField.modify_date.getKey())) {
                    try {
                        setDateTimeSql(m, sb, list, fb, needTableName);
                    } catch (ParseException e) {
                        LOG.error("设置开始日期，结束日期时条件时，异常", e);
                    }
                } else if (MasterTableField.getEnumByKey(fieldName) != null) {
                    String op = m.get(OPERATION).toString();
                    Object o = isNull2Str(m.get(FIELDVALUE));
                    fieldName = getFieldName4SQL(fieldName, fb.getMasterTableBean(), needTableName);
                    sb.append(fieldName).append(op).append("'").append(String.valueOf(o)).append("'").append(" ");
                } else {
                    String op = m.get(OPERATION).toString();
                    Object o = isNull2Str(m.get(FIELDVALUE));
                    String value = "?";
                    if (tempField != null) {
                        fieldName = getFieldName4SQL(fieldName, fb.getTableByTableName(tempField.getOwnerTableName()), needTableName);
                    }
                    if (!ConditionSymbol.include.getKey().equals(op)) {
                        if (tempField != null) {
                            if (FormFieldComEnum.EXTEND_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFinalInputType(true))
                                    || (FormFieldComEnum.OUTWRITE.getKey().equalsIgnoreCase(tempField.getFinalInputType())
                                    && FormFieldComEnum.EXTEND_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFormatType()))) {
                                sb.append(getDepartmentsLogicString(String.valueOf(o), fieldName, op));
                            } else if (FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFinalInputType(true))
                                    || (FormFieldComEnum.OUTWRITE.getKey().equalsIgnoreCase(tempField.getFinalInputType())
                                    && FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFormatType()))) {
                                sb.append(getSqlForMultilDepartmentEqualNotEqual(String.valueOf(o), fieldName, op));
                            } else {
                                boolean isEnumField = false;
                                if (null != tempField && (FormFieldComEnum.SELECT.getKey().equals(tempField.getFinalInputType())
                                        || FormFieldComEnum.CHECKBOX.getKey().equals(tempField.getFinalInputType())
                                        || FormFieldComEnum.RADIO.getKey().equals(tempField.getFinalInputType()))) {//枚举类型字段
                                    FormFormulaFunctionCompareEnumValue enumFunction = new FormFormulaFunctionCompareEnumValue();
                                    FormQueryWhereClause myWhereClause = enumFunction.getEnumCompareWhereClause(true, fb, true, false, fieldName, op, String.valueOf(o));
                                    if (null != myWhereClause) {
                                        if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                            sb.append(myWhereClause.getAllSqlClause());
                                        }
                                        if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                            list.addAll(myWhereClause.getQueryParams());
                                        }
                                    }
                                    isEnumField = true;
                                }
                                if (!isEnumField) {
                                    if (op.contains(ConditionSymbol.like.getKey())) {
                                        op = op.replace(ConditionSymbol.like.getKey(), " " + ConditionSymbol.like.getKey()).replace("_", "");
                                        o = "%" + String.valueOf(o) + "%";
                                        list.add(o);
                                    } else {
                                        o = getHQLObject(fb, fieldName, String.valueOf(o));
                                        list.add(o);
                                    }
                                    sb.append(fieldName).append(" ").append(op).append(" ").append(value).append(" ");
                                }
                            }
                        }
                    } else {
                        StringBuilder valueStr = new StringBuilder();
                        String oStr = String.valueOf(o);
                        if (oStr.contains(",")) {
                            String[] oStrs = oStr.split(",");
                            valueStr.append(" (");
                            for (int j = 0; j < oStrs.length; j++) {
                                valueStr.append(getDepartmentsLogicString(oStrs[j], fieldName, " like "));
                                if (j != oStrs.length - 1) {
                                    valueStr.append(" and ");
                                }
                            }
                            valueStr.append(" )");
                        } else {
                            valueStr.append(getDepartmentsLogicString(oStr, fieldName, " like "));
                        }
                        sb.append(valueStr);
                    }
                }
                sb.append(isNull2Str(m.get(RIGHTCHAR))).append(" ");
                if (i < condition.size() - 1) {
                    sb.append(m.get(ROWOPERATION).toString()).append(" ");
                }
            }
            sb.append(") ");
        }
        result[0] = sb.toString();
        return result;
    }

    /**
     * 设置创建时间 和修改时间的SQL
     * =的时候设置>=该日期的0点0分 且<=改日期的0点0分
     * 同理其他的
     *
     * @param m
     * @param sb
     * @param list
     * @throws ParseException
     */
    private static void setDateTimeSql(Map<String, Object> m, StringBuffer sb, List<Object> list, FormBean fb, boolean needTableName) throws ParseException {
        String fieldName = m.get(FIELDNAME).toString();//字段名称
        if (needTableName) {
            fieldName = fb.getMasterTableBean().getTableName() + "." + fieldName;
        }
        String o = isNull2Str(m.get(FIELDVALUE));
        String maxSuffix = " 23:59:59";
        String minSuffix = " 00:00:00";
        int maxLength = 19;
        int dateLength = o.length();
        Object maxDate = DateUtil.parseTimestamp(o + maxSuffix.substring(maxSuffix.length() + dateLength - maxLength), DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN);
        Object minDate = DateUtil.parseTimestamp(o + minSuffix.substring(minSuffix.length() + dateLength - maxLength), DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN);
        ConditionSymbol opChar = ConditionSymbol.getEnumByKey(m.get(OPERATION).toString());
        switch (opChar) {
            case equal:
                sb.append("(").append(fieldName).append(" >= ? ").append(" and ").append(fieldName).append(" <= ? ").append(")");
                list.add(minDate);
                list.add(maxDate);
                break;
            case greatAndEqual://>=
                sb.append(fieldName).append(" >= ? ");
                list.add(minDate);
                break;
            case greatThan://>
                sb.append(fieldName).append(" > ? ");
                list.add(maxDate);
                break;
            case lessAndEqual://<=
                sb.append(fieldName).append(" <= ? ");
                list.add(maxDate);
                break;
            case lessThan://<
                sb.append(fieldName).append(" < ? ");
                list.add(minDate);
                break;
            case notEqual:
                sb.append("(").append(fieldName).append(" > ? ").append(" or ").append(fieldName).append(" < ? ").append(")");
                list.add(maxDate);
                list.add(minDate);
                break;
            default:
                sb.append(fieldName).append(" ").append(opChar).append(" ? ");
                list.add(minDate);
                break;
        }
    }

    /**
     * @param fb
     * @param fieldName
     * @param value
     * @return
     */
    private static Object getHQLObject(FormBean fb, String fieldName, String value) {
        Object o = value;
        try {
            String realField = fieldName;
            if (fieldName.contains(".")) {
                //there must substring field when fieldName from FormReport
                //which will be formmain0001.field0001
                realField = fieldName.substring(fieldName.indexOf(".") + 1);
            }
            MasterTableField mtf = MasterTableField.getEnumByKey(realField);
            FormFieldBean ffb = null;
            if (mtf == null) {
                ffb = fb.getFieldBeanByName(realField);
            } else {
                ffb = mtf.getFormFieldBean();
            }
            if (ffb == null) {
                return o;
            }
            switch (FieldType.getEnumByKey(ffb.getFieldType())) {
                case DATETIME:
                    o = DateUtil.parseTimestamp(value);
                    break;
                case TIMESTAMP:
                    o = DateUtil.parseTimestamp(value, "yyyy-MM-dd");
                    break;
                case DECIMAL:
                    if (FormFieldComEnum.SELECT == ffb.getInputTypeEnum()
                            || FormFieldComEnum.RADIO == ffb.getInputTypeEnum()
                            || (FormFieldComEnum.OUTWRITE == ffb.getInputTypeEnum() && (FormFieldComEnum.SELECT.getKey().equals(ffb.getFormatType()) || FormFieldComEnum.RADIO.getKey().equals(ffb.getFormatType())))) {
                        o = Long.valueOf(value);
                    } else {
                        o = new BigDecimal(value);
                    }
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            LOG.error("获取查询SQL值参数异常...", e);
            try {
                o = new BigDecimal(value);
            } catch (Exception e2) {
                o = -1;//如果是数字的字段，用户自定义条件输入的是非数字，直接置空 OA-107992M3-IOS端：表单查询统计输入用户条件后点击查询不生效
                LOG.error("获取查询SQL值参数异常...", e);
            }
        }
        return o;
    }

    private static String isNull2Str(Object o) {
        return (o == null ? "" : o.toString());
    }

    public static void setShowValueList(FormBean formBean, String rightStr, List<Map<String, Object>> formDataList, boolean isExcelExport) throws NumberFormatException, BusinessException {
        setShowValueList(formBean, rightStr, formDataList, isExcelExport, false);
    }


    /**
     * 查询结果 数据处理，ID显示名称等
     *
     * @param formBean
     * @param rightStr
     * @param list
     * @param isExcelExport是不为导出excel操作
     * @throws BusinessException
     * @throws NumberFormatException
     */
    public static void setShowValueList(FormBean formBean, String rightStr, List<Map<String, Object>> formDataList, boolean isExcelExport, boolean needReplaceMasterTableField) throws NumberFormatException, BusinessException {
        OrgManager orgManager = null;
        CtpEnumItem item = null;
        FormFieldBean currentField = null;
        EnumManager selectManager = (EnumManager) AppContext.getBean("enumManagerNew");
        Map<String, FormFieldBean> realFormFieldBeanMap = new HashMap<String, FormFieldBean>();
        for (Map<String, Object> lineValues : formDataList) {
            Map<String, Object> map = new HashMap<String, Object>(lineValues);
            for (Entry<String, Object> entry : map.entrySet()) {
                String key = entry.getKey();
                FormFieldBean fieldBean = formBean.getFieldBeanByName(key);
                currentField = fieldBean;
                if (fieldBean != null && !(isExcelExport && (FieldType.DECIMAL.getKey().equals(fieldBean.getFieldType())
                        && (FormFieldComEnum.TEXT.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.LABLE.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.PREPAREWRITE.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.OUTWRITE.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.RELATIONFORM.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.EXTEND_EXCHANGETASK.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.EXTEND_QUERYTASK.getKey().equals(fieldBean.getInputType())
                        || FormFieldComEnum.RELATION.getKey().equals(fieldBean.getInputType()))
                ))) {
                    String filedAuth = getFieldAnthString(formBean, fieldBean, rightStr);
                    //由于basePo中有同步锁,避免多次克隆
                    if (realFormFieldBeanMap.containsKey(key)) {
                        fieldBean = realFormFieldBeanMap.get(key);
                    } else {
                        fieldBean = fieldBean.findRealFieldBean();
                        realFormFieldBeanMap.put(key, fieldBean);
                    }
                    try {
                        Object valueObj;
                        if (filedAuth.equals(FieldAccessType.browse.getKey())) {
                            Object value = entry.getValue();
                            Object[] objs = fieldBean.getDisplayValue(value, false, true, isExcelExport);
                            valueObj = objs[1];
                        } else {
                            valueObj = "*";
                        }
                        // 客开 start
                        if (valueObj != null && String.valueOf(valueObj).matches("^Team\\|-?[0-9]+$")) {
                        	try {
                        		String[] tt = String.valueOf(valueObj).split("\\|");
                            	valueObj = Functions.getTeam(Long.valueOf(tt[1])).getName();
                        	} catch (Exception e) {
                        	}
                        }
                        // 客开 end
                        lineValues.put(entry.getKey(), valueObj);

                    } catch (Exception e) {
                        throw new BusinessException(e);
                    }
                } else {
                	if(fieldBean!=null){
                    	String filedAuth = getFieldAnthString(formBean,fieldBean,rightStr);
                    	if(filedAuth.equals(Enums.FieldAccessType.hide.getKey())){
                    		lineValues.put(entry.getKey(), "*");
                    		continue;
                    	}
                    }
                    if (entry.getValue() == null) {
                        lineValues.put(entry.getKey(), "");
                        continue;
                    }
                    //导出时，数字字段按格式导出 add by chenxb 2016-03-01 bug OA-88985
                    if (fieldBean != null && isExcelExport
                            && FieldType.getEnumByKey(fieldBean.getFieldType().toUpperCase()) == FieldType.DECIMAL
                            && !(fieldBean.getInputType().equals(FormFieldComEnum.SELECT.getKey())
                            || fieldBean.getInputType().equals(FormFieldComEnum.RADIO.getKey())
                            || fieldBean.getInputType().equals(FormFieldComEnum.CHECKBOX.getKey())
                            || (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isDataRelationMultiEnum()))) {
                        try {
                            Object value = entry.getValue();
                            Object[] objs = fieldBean.getDisplayValue(value, false, true, isExcelExport);
                            lineValues.put(entry.getKey(), objs[1]);
                        } catch (Exception e) {
                            throw new BusinessException(e);
                        }
                    }
                    if (fieldBean != null && (FormFieldComEnum.RELATION.getKey().equals(fieldBean.getInputType())
                    		|| FormFieldComEnum.RELATIONFORM.getKey().equals(fieldBean.getInputType()))) {
                        FormRelation fr = fieldBean.getFormRelation();
                        FormFieldBean tempFieldBean = fieldBean.findRealFieldBean();
                        if (tempFieldBean != null && fr != null && (fr.isDataRelationMultiEnum() || fr.isDataRelationImageEnum() || 
                        		((fr.isFormRelationField() || fr.isDataRelationField()) && tempFieldBean.getInputTypeEnum() != null &&
                                (tempFieldBean.getInputTypeEnum().getKey().equals(FormFieldComEnum.RADIO.getKey())
                                        || tempFieldBean.getInputTypeEnum().getKey().equals(FormFieldComEnum.SELECT.getKey()))))) {
                            fieldBean = tempFieldBean;
                            realFormFieldBeanMap.put(key, fieldBean);
                            Object value = entry.getValue();
                            try {
                                Object[] objs = fieldBean.getDisplayValue(value);
                                lineValues.put(entry.getKey(), objs[1]);
                            } catch (Exception e) {
                                throw new BusinessException(e);
                            }
                        }
                    }
                    MasterTableField masterTableField = MasterTableField.getEnumByKey(entry.getKey());
                    if (masterTableField != null) {
                        int state;
                        switch (masterTableField) {
                            case start_member_id:
                                if (orgManager == null) {
                                    orgManager = (OrgManager) AppContext.getBean("orgManager");
                                }
                                if (NumberUtils.isNumber(entry.getValue().toString())) {//表单统计直接获取组织机构姓名，所以加个判断
                                    V3xOrgMember member = orgManager.getMemberById(Long.parseLong(entry.getValue().toString()));
                                    if (member != null) {
                                        if (needReplaceMasterTableField) {
                                            lineValues.put(entry.getKey().replace("_", ""), member.getName());
                                        } else {
                                            lineValues.put(entry.getKey(), member.getName());
                                        }
                                    }
                                }
                                break;
                            case state:
                                FormDataStateEnum dateAuditedSate = null;
                                state = Integer.parseInt(entry.getValue().toString());
                                if (formBean.getFormType() == FormType.processesForm.getKey()) {
                                    switch (state) {
                                        case 2:
                                            dateAuditedSate = FormDataStateEnum.FLOW_AUDITEDPASS;
                                            break;
                                        case 3:
                                            dateAuditedSate = FormDataStateEnum.FLOW_AUDITEDUNPASS;
                                            break;
                                        case 0:
                                        	dateAuditedSate = FormDataStateEnum.FLOW_DRAFT;
                                        	break;
                                        case 1:
                                        default:
                                            dateAuditedSate = FormDataStateEnum.FLOW_UNAUDITED;
                                            break;
                                    }
                                } else if (formBean.getFormType() == FormType.manageInfo.getKey()) {
                                    dateAuditedSate = FormDataStateEnum.getUnFlowFormDataStateEnumByKey(state);
                                }
                                if (dateAuditedSate != null) {
                                    if (needReplaceMasterTableField) {
                                        lineValues.put(entry.getKey(), dateAuditedSate.getKey());
                                    } else {
                                        lineValues.put(entry.getKey(), dateAuditedSate.getText());
                                    }
                                }
                                break;
                            case ratifyflag:
                                FormDataRatifyFlagEnum dateVouchSate;
                                state = Integer.parseInt(entry.getValue().toString());
                                switch (state) {
                                    case 1:
                                        dateVouchSate = FormDataRatifyFlagEnum.FLOW_VOUCHPASS;
                                        break;
                                    case 2:
                                        dateVouchSate = FormDataRatifyFlagEnum.FLOW_VOUCHUNPASS;
                                        break;
                                    default:
                                        dateVouchSate = FormDataRatifyFlagEnum.FLOW_UNVOUCH;
                                        break;
                                }
                                if (dateVouchSate != null) {
                                    lineValues.put(entry.getKey(), dateVouchSate.getText());
                                }
                                break;
                            case finishedflag:
                                state = Integer.parseInt(entry.getValue().toString());
                                FromDataFinishedFlagEnum flowState;
                                switch (state) {
                                    case 0:
                                        flowState = FromDataFinishedFlagEnum.END_NO;
                                        break;
                                    case 1:
                                        flowState = FromDataFinishedFlagEnum.END_YES;
                                        break;
                                    case 3:
                                    default:
                                        flowState = FromDataFinishedFlagEnum.STOP;
                                        break;
                                }
                                if (flowState != null) {
                                    lineValues.put(entry.getKey(), flowState.getText());
                                }
                                break;
                            case modify_date:
                            case start_date:
                                if (needReplaceMasterTableField) {
                                    lineValues.put(entry.getKey().replace("_", ""), DateUtil.formatDateTime((Date) entry.getValue()));
                                } else {
                                    lineValues.put(entry.getKey(), DateUtil.formatDateTime((Date) entry.getValue()));
                                }
                                break;
                            default:
                                break;
                        }
                    }
                }
                if (currentField != null && entry.getValue() != null && !"*".equals(lineValues.get(entry.getKey())) && currentField.isDisplayImage()) {
                    try {
                        item = selectManager.getCacheEnumItem(Long.parseLong(entry.getValue().toString()));
                        if (item != null && !isExcelExport) {
                            lineValues.put(entry.getKey(), item.getImageId());
                        } else if (item != null && isExcelExport) {
                            lineValues.put(entry.getKey(), item.getShowvalue());
                        }
                    } catch (Exception e) {
                        LOG.error("图片枚举字段格式类型转换错误：" + currentField.getDisplay() + " 值：" + entry.getValue(), e);
                    }
                }
            }
        }
    }

    /**
     * 表单查询显示-获取字段权限，用于判断字段数据是否显示
     * 2015-2-9 private改为public，表单统计调用
     *
     * @param formBean
     * @param fieldBean
     * @param rightStr
     * @return
     */
    public static String getFieldAnthString(FormBean formBean, FormFieldBean fieldBean, String rightStr) {
    	rightStr = rightStr.replaceAll("[|]", "_");
        String[] rights = rightStr.split("_");
        boolean hide = true;
        for (String right : rights) {
            //设置了穿透权限：在所有设置的权限中查找目标字段是否都为隐藏，如果不都是隐藏权限 则可以显示；
            if (!StringUtil.checkNull(right)) {
                String[] rightIdStr = right.split("\\.");
                if (rightIdStr.length > 1) {
                    Long rightId = Long.valueOf(rightIdStr[1]);
                    FormAuthViewBean auth = formBean.getAuthViewBeanById(rightId);
                    if (auth != null) {
                        FormAuthViewFieldBean fieldAuth = auth.getFormAuthorizationField(fieldBean.getName());
                        if (fieldAuth != null) {
                            String access = fieldAuth.getAccess();
                            if (!access.equals(FieldAccessType.hide.getKey())) {
                                hide = false;
                                break;
                            }
                        }
                    }
                }
            } else {
                //如果不允许穿透：在所有视图的所有权限中取系统显示权限，如果不都为隐藏权限，则返回显示权限
                List<FormViewBean> views = formBean.getFormViewList();
                for (FormViewBean view : views) {
                    List<FormAuthViewBean> operations = view.getAllOperations();
                    for (FormAuthViewBean op : operations) {
                        if (formBean.isSystemAuth(op.getId())) {
                            String type = op.getType();
                            if (type.equals(FormAuthorizationType.show.getKey())) {
                                FormAuthViewFieldBean fieldAuth = op.getFormAuthorizationField(fieldBean.getName());
                                if (fieldAuth != null) {
                                    if (!fieldAuth.getAccess().equals(FieldAccessType.hide.getKey())) {
                                        hide = false;
                                        break;
                                    }
                                }
                            }
                        }

                    }
                    if (!hide) {
                        break;
                    }
                }
            }
        }
        return hide ? FieldAccessType.hide.getKey() : FieldAccessType.browse.getKey();
    }

    /**
     * 得到表单字段对应的EXCEL字段类型
     *
     * @param fb
     * @param fieldName
     * @return
     */
    public static int toExcelFieldType(FormBean fb, String fieldName) {
        FormFieldBean ffb = fb.getFieldBeanByName(fieldName);
        return toExcelFieldType(ffb);
    }

    public static int toExcelFieldType(FormFieldBean ffb) {
        if (ffb != null) {
            if (ffb.getFieldType().equalsIgnoreCase(FieldType.DECIMAL.getKey())) {//设置显示格式 不能进行计算
                //数字类型字段，在导出时如果有格式，则按照格式导出 add by chenxb 2015-12-03
                if (!StringUtil.checkNull(ffb.getFormatType())) {
                    if(FormConstant.HundredTag.equalsIgnoreCase(ffb.getFormatType())){
                        //百分号
                        return DataCell.DATA_TYPE_PERCENT;
                    }else if(FormConstant.ThousandTag.equalsIgnoreCase(ffb.getFormatType())){
                        //千分位
                        if (Strings.isNotBlank(ffb.getDigitNum()) && !"0".equals(ffb.getDigitNum())) {
                            return DataCell.DATA_TYPE_NUMERIC_Thousandth;
                        }else{
                            return DataCell.DATA_TYPE_INTEGER_Thousandth;
                        }
                    }
                    return DataCell.DATA_TYPE_TEXT;
                }

                if (Strings.isNotBlank(ffb.getDigitNum()) && !"0".equals(ffb.getDigitNum())) {
                    return DataCell.DATA_TYPE_NUMERIC;
                } else {
                    return DataCell.DATA_TYPE_INTEGER;
                }
            }
        }
        return DataCell.DATA_TYPE_TEXT;
    }

    public static <E> Collection<Collection<E>> splitCollection(Collection<E> collection, int length) {

        Collection<Collection<E>> collections = new ArrayList<Collection<E>>();

        if (collection.size() <= length) {
            collections.add(collection);
        } else {
            Collection<E> temp = new ArrayList<E>();
            Iterator<E> it = collection.iterator();
            while (it.hasNext()) {
                temp.add(it.next());
                if (temp.size() == length) {
                    break;
                }
            }
            collection.removeAll(temp);
            collections.add(temp);
            collections.addAll(splitCollection(collection, length));
        }
        return collections;
    }

    public static void showStackTrace(String info) {
        StringBuilder sb = new StringBuilder(info);
        StackTraceElement[] elements = Thread.currentThread().getStackTrace();

        for (StackTraceElement e : elements) {
            sb.append("\n" + e.getClassName() + " " + e.getMethodName() + " " + e.getLineNumber());
        }
        LOG.info(sb.toString());
    }

    public static String getLocalIpAddress() {
        if (ClusterConfigBean.getInstance().isClusterEnabled()) {
            return ClusterConfigBean.getInstance().getLocalhost();
        }
        return "";
    }

    /**
     * 根据相对角色或者表单控件获取相应的人员列表
     *
     * @param orgManager
     * @param key
     * @param value
     * @param createrId
     * @param masterBean
     * @return
     * @throws BusinessException
     */
    public static List<V3xOrgEntity> getSpecialMembers(OrgManager orgManager, String key, String value, Long createrId, FormDataMasterBean masterBean, boolean toMember) throws BusinessException {
        List<V3xOrgEntity> members = new ArrayList<V3xOrgEntity>();
        if (V3xOrgEntity.ORGENT_TYPE_ROLE.equalsIgnoreCase(key) || "Node".equalsIgnoreCase(key)) { //角色
            V3xOrgMember member = orgManager.getMemberById(createrId);
            if (value.contains("SenderSuperDept")) { //发起者上级部门
                V3xOrgDepartment department = orgManager.getParentDepartment(member.getOrgDepartmentId());
                if (department != null) {
                    members = getDeptMembers(orgManager, member, department.getId(), value.replace("SenderSuperDept", ""), toMember);
                }
            } else if (value.contains("SenderSuperAccount")) {
                V3xOrgAccount account = orgManager.getAccountById(member.getOrgAccountId());
                if (account != null) {
                    account = (V3xOrgAccount) orgManager.getParentUnitById(account.getId());
                    if (account != null) {
                        members.addAll(orgManager.getMembersByAccountRoleOfUp(account.getId(), value.replace("SenderSuperAccount", "")));
                    }
                }
            } else if (value.contains("Sender")) {
                if ("Sender".equals(value)) { //发起者
                    members.add(orgManager.getMemberById(createrId));
                } else if (value.contains("ReciprocalRoleReporter")) {
                    V3xOrgMember reporter = orgManager.getMemberById(member.getReporter());
                    if (reporter != null) {
                        members.add(reporter);
                    }
                } else { //部门成员 和其他角色
                    members = getDeptMembers(orgManager, member, member.getOrgDepartmentId(), value.replace("Sender", ""), toMember);
                }
            }
        } else if (V3xOrgEntity.ORGENT_TYPE_DEPARTMENT.equalsIgnoreCase(key) || key.equals(FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey())) {
            members.addAll(getEntities(orgManager, Long.parseLong(value), V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, toMember));
        } else if (V3xOrgEntity.ORGENT_TYPE_LEVEL.equalsIgnoreCase(key) || key.equals(FormFieldComEnum.EXTEND_MULTI_LEVEL.getKey())) {
            members.addAll(getEntities(orgManager, Long.parseLong(value), V3xOrgEntity.ORGENT_TYPE_LEVEL, toMember));
        } else if (V3xOrgEntity.ORGENT_TYPE_MEMBER.equalsIgnoreCase(key) || key.equals(FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey())) {
            members.add(orgManager.getMemberById(Long.parseLong(value)));
        } else if (V3xOrgEntity.ORGENT_TYPE_POST.equalsIgnoreCase(key) || key.equals(FormFieldComEnum.EXTEND_MULTI_POST.getKey())) {
            members.addAll(getEntities(orgManager, Long.parseLong(value), V3xOrgEntity.ORGENT_TYPE_POST, toMember));
        } else if (V3xOrgEntity.ORGENT_TYPE_ACCOUNT.equalsIgnoreCase(key) || key.equals(FormFieldComEnum.EXTEND_MULTI_ACCOUNT.getKey())) {
            members.addAll(getEntities(orgManager, Long.parseLong(value), V3xOrgEntity.ORGENT_TYPE_ACCOUNT, toMember));
        } else if (V3xOrgEntity.ORGENT_TYPE_TEAM.equalsIgnoreCase(key)) {
            members.addAll(getEntities(orgManager, Long.parseLong(value), V3xOrgEntity.ORGENT_TYPE_TEAM, toMember));
        } else if (V3xOrgEntity.ORGREL_TYPE_DEP_ROLE.equalsIgnoreCase(key)) {
            String[] deprole = value.split("_");
            members.addAll(orgManager.getMembersByDepartmentRole(Long.parseLong(deprole[0]), deprole[1]));
        } else if (V3xOrgEntity.ORGREL_TYPE_DEP_POST.equalsIgnoreCase(key)) {
            String[] deppost = value.split("_");
            members.addAll(orgManager.getMembersByDepartmentPost(Long.parseLong(deppost[0]), Long.parseLong(deppost[1])));
        } else if ("FormField".equalsIgnoreCase(key)) {
            String type = getFieldName(value)[0];
            Object obj = masterBean.getFieldValue(getFieldName(value)[1]);
            if (obj != null) {
                String[] values = obj.toString().split(",");
                for (String string : values) {
                    if (Strings.isNotBlank(string)) {
                        members.addAll(getSpecialMembers(orgManager, type.toLowerCase(), string, createrId, masterBean, toMember));
                    }
                }
            }
        }
        return members;
    }

    private static List<V3xOrgEntity> getEntities(OrgManager orgManager, Long entity, String entityType, boolean toMember) throws BusinessException {
        List<V3xOrgEntity> members = new ArrayList<V3xOrgEntity>();
        if (toMember) {
            members.addAll(orgManager.getMembersByType(entityType, entity));
        } else {
            V3xOrgEntity entity1 = orgManager.getEntity(entityType, entity);
            if (entity1 != null) {
                members.add(entity1);
            }
        }
        return members;
    }

    /**
     * 根据角色获取部门下的人员
     *
     * @param orgManager
     * @param deptId
     * @param role
     * @return
     * @throws BusinessException
     */
    private static List<V3xOrgEntity> getDeptMembers(OrgManager orgManager,V3xOrgMember member, Long deptId, String role, boolean toMember) throws BusinessException {
        List<V3xOrgEntity> members = new ArrayList<V3xOrgEntity>();
        Long roleId = null;
        try{
            roleId = Long.valueOf(role);
        } catch (Exception e) {
            LOG.error("触发消息角色执行id转换时移除，按照角色名称处理", e);
        }
        if (roleId != null) {
            V3xOrgRole role1 = orgManager.getRoleById(roleId);
            if (role1 != null) {
                if (role1.getBond() == OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()) {
                    members.addAll(orgManager.getMembersByDepartmentRoleOfUp(member.getOrgDepartmentId(), role));
                } else if (role1.getBond() == OrgConstants.ROLE_BOND.ACCOUNT.ordinal()) {
                    members.addAll(orgManager.getMembersByRole(member.getOrgAccountId(), roleId));
                }
            }
        } else {
            if ("DeptMember".equals(role)) {//部门成员
                if (toMember) {
                    members.addAll(orgManager.getMembersByDepartment(deptId, true)) ;
                } else {
                    V3xOrgDepartment department = orgManager.getDepartmentById(deptId);
                    if (department != null) {
                        members.add(department);
                    }
                }
            } else {
                members.addAll(orgManager.getMembersByDepartmentRole(deptId, role));
            }
        }
        return members;
    }

    /**
     * 表单控件，格式为“类型@控件名#控件显示名”
     *
     * @param value
     * @return 0:类型，1：控件名，2：控件显示名, 3:角色(不一定有值)
     */
    public static String[] getFieldName(String value) {
        String[] ret = new String[4];
        ret[0] = value.substring(0, value.indexOf("@"));
        ret[1] = value.substring(value.indexOf("@") + 1, value.indexOf("#"));
        ret[2] = value.substring(value.indexOf("#"));
        ret[3] = "";
        String role = value.substring(value.lastIndexOf("#"));
        if (!role.contains(ret[2])) {
            ret[3] = role.substring(1);
        }
        return ret;
    }


    /**
     * 获取重复表与group对应关系
     *
     * @param formId 表单Id
     * @throws BusinessException
     */
    public static Map<String, String> getGroupSubTableNameMap(Long formId, FormCacheManager formCacheManager) throws BusinessException {
        Map<String, String> groupSubTableNameMap = new HashMap<String, String>();
        String resourceName = "myschema.xsd";
        List<FormResource> schemaResources = formCacheManager.findByFormIdAndResourceName(formId, resourceName);
        for (FormResource formResource : schemaResources) {
            Document schemaResourceDoc;
            try {
                schemaResourceDoc = DocumentHelper.parseText(formResource.getContent());
            } catch (DocumentException e) {
                throw new BusinessException(e);
            }
            Element schemaElement = schemaResourceDoc.getRootElement();
            if (schemaElement == null) {
                throw new BusinessException("xsd:schema 节点不存在");
            }
            InfoPath_xsd fschema = new InfoPath_xsd();
            readSchemaHeadInfo(fschema, formId, formCacheManager);
            fschema.loadFromInfoPathXSD(schemaElement);
            Map<String, String> dataAreaGroupMap = new HashMap<String, String>();
            for (InfoPath_DataElement fDataElement : fschema.getDataElementList()) {
                if (fDataElement.getDataType() == TDataType.dtGroup) {
                    addGroupByDataElement((InfoPath_DataGroup) fDataElement, null, dataAreaGroupMap);
                } else {

                }

            }

            if (dataAreaGroupMap.isEmpty()) {
                return groupSubTableNameMap;
            }

            FormBean fb = formCacheManager.getForm(formId);
            List<FormTableBean> subTableBeanList = fb.getSubTableBean();
            for (FormTableBean formTableBean : subTableBeanList) {
                List<FormFieldBean> fields = formTableBean.getFields();
                for (FormFieldBean formFieldBean : fields) {
                    String display = formFieldBean.getDisplay();
                    String groupName = dataAreaGroupMap.get(display);
                    if (groupName != null) {
                        groupSubTableNameMap.put(groupName, formFieldBean.getOwnerTableName());
                    }
                }
            }
        }
        return groupSubTableNameMap;
    }

    public static void addGroupByDataElement(InfoPath_DataGroup aGroup, List<String> aPath, Map<String, String> dataAreaGroupMap) throws BusinessException {
        List<String> fthisPath = new ArrayList<String>();
        if (aPath != null && aPath.size() > 0) {
            fthisPath.addAll(aPath);
        }
        fthisPath.add(aGroup.getDataName());
        for (InfoPath_DataElement fSubElement : aGroup.getSubElement()) {
            if (fSubElement.getDataType() == TDataType.dtGroup) {
                addGroupByDataElement((InfoPath_DataGroup) fSubElement, fthisPath, dataAreaGroupMap);
            } else {
                dataAreaGroupMap.put(fSubElement.getDataName(), fthisPath.get(fthisPath.size() - 1));
            }
        }
    }

    public static void readSchemaHeadInfo(InfoPath_xsd aSchema, Long formId, FormCacheManager formCacheManager) throws BusinessException {
        String resourceName = "manifest.xsf";
        List<FormResource> resources = formCacheManager.findByFormIdAndResourceName(formId, resourceName);
        if (Strings.isEmpty(resources)) {
            return;
        }
        FormResource tempResource = resources.get(0);
        Document resourceDoc;
        try {
            resourceDoc = DocumentHelper.parseText(tempResource.getContent());
        } catch (DocumentException e) {
            throw new BusinessException(e);
        }
        Element froot = resourceDoc.getRootElement();
        froot = froot.element(InfoPathNodeName.xsf_package);
        froot = froot.element(InfoPathNodeName.xsf_files);
        List<Element> ftempList = froot.elements(InfoPathNodeName.xsf_file);
        Attribute fatt;
        froot = null;
        for (Element felement : ftempList) {
            fatt = felement.attribute(InfoPathNodeName.name);
            resourceName = FormCharset.getInstance().selfXML2JDK(fatt.getValue());
            if (resourceName.endsWith(".xsd")) {
                aSchema.setName(resourceName);
                froot = felement.element(InfoPathNodeName.xsf_fileProperties);
                break;
            }
        }
        if (froot == null) {
            throw new BusinessException("xsf文件根节点没有传入!");
        }

        ftempList = froot.elements(InfoPathNodeName.xsf_property);
        for (Element felement : ftempList) {
            fatt = felement.attribute(InfoPathNodeName.name);
            resourceName = fatt.getValue();
            if ("rootElement".equalsIgnoreCase(resourceName)) {
                fatt = felement.attribute(InfoPathNodeName.value);
                resourceName = FormCharset.getInstance().selfXML2JDK(fatt.getValue());
                aSchema.setRootElement(resourceName);
            }
        }
    }

    /**
     * 查看是否有权修改表单
     *
     * @param currentUserId 当前用户
     * @param formOwner     表单所属人
     * @param orgManager
     * @return
     * @throws BusinessException
     */
    public static boolean isRightEditForm(long currentUserId, FormOwner formOwner) throws BusinessException {
        OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
        if (formOwner != null) {
            boolean isFormAdmin = false;
            boolean isSameUser = false;
            isFormAdmin = orgManager.isRole(currentUserId, formOwner.getOrgAccountId(), "FormAdmin");
            isSameUser = currentUserId == formOwner.getOwnerId();
            if (!isFormAdmin || !isSameUser) {
                return false;
            }
        }
        return true;
    }

    /**
     * 如果配置有添加重复表行，需要删除第一行全空数据 目前仅触发在使用
     *
     * @param subTableNames        子表名称
     * @param targetFormMasterBean 目标表主数据记录bean
     * @param toFormBean           目标表定义Bean
     * @param checkAttachment      是否校验附件类型字段 触发为false
     */
    public static void deleteNullDataOfSubdataBean(List<String> subTableNames, FormDataMasterBean targetFormMasterBean, FormBean toFormBean, boolean checkAttachment) {
        for (String tableName : subTableNames) {
            deleteNullDataOfSubdataBean(tableName, targetFormMasterBean, toFormBean, checkAttachment);
        }
    }

    /**
     * 如果配置有添加重复表行，需要删除第一行全空数据 目前仅触发在使用
     *
     * @param tableName            子表名称
     * @param targetFormMasterBean 目标表主数据记录bean
     * @param toFormBean           目标表定义Bean
     * @param checkAttachment      是否校验附件类型字段 触发为false
     */
    public static void deleteNullDataOfSubdataBean(String tableName, FormDataMasterBean targetFormMasterBean, FormBean toFormBean, boolean checkAttachment) {
        //获得子表数据
        List<FormDataSubBean> subBeans = targetFormMasterBean.getSubData(tableName);
        //只考虑子表一条记录的情况，也就是说触发回写之前底表(被触发表单)没有其它数据，
        //只有第一次保存底表数据时产生的一条空数据
        if (Strings.isNotEmpty(subBeans) && subBeans.size() == 1) {
            //获得行序号为1的数据
            FormDataSubBean subBean = subBeans.get(0);
            boolean flag = subBean.isEmpty(checkAttachment);
            if (flag && StringUtil.checkNull(String.valueOf(subBean.getExtraAttr(FormTriggerUtil.NO_NEED_DELETE_SUBLINE_KEY)))) {
                subBeans.clear();
            }
        }
    }

    public static String changeEnumFieldsCompare(FormBean form, String sql) {
        return changeEnumFieldsCompare(form, sql, false);
    }

    /**
     * 支持数字枚举值比较
     * 由于数字枚举值也是保存的id，此处将枚举字段改为in语句，并使用原来的参数做子查询
     *
     * @param form
     * @param result
     * @param existPrefix 字段是否包含表单名称
     * @return
     */
    public static String changeEnumFieldsCompare(FormBean form, String sql, boolean existPrefix) {
        String enumSql1 = " SELECT yyy.id FROM ctp_enum_item xxx LEFT JOIN ctp_enum_item yyy ON yyy.REF_ENUMID = xxx.REF_ENUMID WHERE xxx.id = ? AND CAST(yyy.enumvalue as DECIMAL) ";
        String enumSql2 = " CAST(xxx.enumvalue as DECIMAL) ";
        StringBuffer sb = new StringBuffer();
        String result = sql;
        if (result.contains(ConditionSymbol.greatAndEqual.getKey()) ||
                result.contains(ConditionSymbol.greatThan.getKey()) ||
                result.contains(ConditionSymbol.lessAndEqual.getKey()) ||
                result.contains(ConditionSymbol.lessThan.getKey()) ||
                result.contains(ConditionSymbol.equal.getKey()) ||
                result.contains(ConditionSymbol.notEqual.getKey())) {
            sb = new StringBuffer();
            Pattern p = Pattern.compile("(\\w+\\.\\w+|\\w+\\.|\\w+)\\s*(>=|>|<=|<|=|<>)\\s*(\"[^\"]*\"|'[^']*'|\\[[^\\[]*\\]|-?[0-9]+|\\?)");
            Matcher matcher = p.matcher(result);
            int count = 0;
            FormFieldBean temp;
            while (matcher.find()) {
                String group1 = matcher.group(1).trim();// FIELD
                if (existPrefix) {
                    temp = form.getFieldBeanByName(group1.substring(group1.indexOf(".") + 1));
                } else {
                    temp = form.getFieldBeanByName(group1);
                }

                if (temp == null) {
                    continue;
                }
                if (temp.getEnumId() == 0L || !temp.getFieldType().equals(FieldType.DECIMAL.getKey())) {//判断是否为枚举字段、数字类型
                    continue;
                }

                String group2 = matcher.group(2).trim();// 操作符
                String group3 = matcher.group(3).trim();// 实际值
                String enumSql = enumSql1.replace("xxx", "xxx" + count).replace("yyy", "yyy" + count).replace("?", group3) + group2 + enumSql2.replace("xxx", "xxx" + count);
                matcher.appendReplacement(sb, group1 + " in (" + enumSql + ")");

                count++;
            }
            matcher.appendTail(sb);
            result = sb.toString();
        }
        return result;
    }

    /**
     * 移除参与计算/条件的计算式线程缓存
     */
    public static void removeThreadCalcCache() {
        removeThreadCalcCache(null);
    }

    public static void removeThreadCalcCache(User currentUser) {
        AppContext.clearThreadContext();
        if (currentUser != null) {
            AppContext.putThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY, currentUser);
        }
    }

    /**
     * 转换字段列表为对应的显示名称列表
     *
     * @param names    字段列表： field0001,formmain_0123.field0001
     * @param formBean 表单对象
     * @return
     */
    public static List<String> convertFieldName2Display(List<String> names, FormBean formBean) {
        List<FormFieldBean> fieldBeans = getFieldBean4NameList(names, formBean);
        List<String> arrayList = new ArrayList<String>();
        for (FormFieldBean fieldBean : fieldBeans) {
            arrayList.add(fieldBean.getDisplay());
        }
        return arrayList;
    }

    /**
     * 转换字段名称串为对应的显示名称串
     *
     * @param fieldNames
     * @param label
     * @param formBean
     * @return
     */
    public static String convertFieldName2Display(String fieldNames, String label, FormBean formBean) {
        String[] names = fieldNames.split(label);
        List<String> resutl = convertFieldName2Display(Arrays.asList(names), formBean);
        return Strings.join(resutl, ",");
    }

    public static List<FormFieldBean> getFieldBean4NameList(List<String> names, FormBean formBean) {
        List<FormFieldBean> beans = new ArrayList<FormFieldBean>();
        if (Strings.isEmpty(names)) {
            return beans;
        }
        for (String name : names) {
            String fieldName = name;
            if (name.contains(".")) {
                fieldName = name.substring(name.indexOf(".") + 1);
            }
            FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
            if (fieldBean != null) {
                beans.add(fieldBean);
            }
        }
        return beans;
    }

    /**
     * 处理流程回复意见中的签章
     *
     * @param value
     * @return
     */
    public static String dealFlowDealSignet(String value) {
        if (Strings.isNotBlank(value)) {
            StringBuffer sb = new StringBuffer();
            Pattern p = Pattern.compile("@signet@(.+?)@signet@\\(?.*?\\)?(\\s+\\d{4}-\\d{2}-\\d{2}\\s+\\d{2}:\\d{2})");
            Matcher m = p.matcher(value);
            while (m.find()) {
                String group = m.group(1);
                String dateTime = m.group(2);
                String userName = group.indexOf("field") <= 0 ? "" : group.substring(0, group.indexOf("field") - 1);
                // TODO: 2017/4/5  感觉这里会有问题
                m.appendReplacement(sb, "[" + userName + " " + dateTime + "]");
            }
            m.appendTail(sb);
            return sb.toString();
        } else {
            return null;
        }
    }

    /**
     * 处理流程回复意见中的签章的html
     *
     * @param value
     * @return
     */
    public static Map<String, Object> getFlowDealSignetHtml(String value) {
        boolean hasSignet = false;
        Map<String, Object> reMap = new HashMap<String, Object>();
        String html = null;
        if (Strings.isNotBlank(value)) {
            StringBuffer sb = new StringBuffer();
            String imgStart = "<img src='/seeyon/form/formData.do?method=showInscribeSignetPic&id=";
            String imgEnd = "' ></img>";
            Pattern p = Pattern.compile("@signet@(.+?)@signet@");
            Matcher m = p.matcher(value);
            while (m.find()) {
                hasSignet = true;
                String group = m.group(1);
                StringBuilder imgUrl = new StringBuilder();
                imgUrl.append(imgStart).append(group.substring(group.lastIndexOf("_")+1)).append(imgEnd);
                m.appendReplacement(sb, imgUrl.toString());
            }
            m.appendTail(sb);
            html = sb.toString();
        } else {
            html = "";
        }
        reMap.put("html", html);
        reMap.put("hasSignet", hasSignet);
        return reMap;
    }

    /**
     * 将Byte转换成16进制字符串:用于处理流程回复签章
     *
     * @param b
     * @return
     */
    public static String byte2Hex(byte[] b) // 二进制转字符串
    {
        StringBuffer sb = new StringBuffer();
        String stmp = "";
        for (int n = 0; n < b.length; n++) {
            stmp = Integer.toHexString(b[n] & 0XFF);
            if (stmp.length() == 1) {
                sb.append("0" + stmp);
            } else {
                sb.append(stmp);
            }

        }
        return sb.toString();
    }

    /**
     * 将16进制字符串转换成byte数组      :用于处理流程回复签章
     *
     * @param source
     * @return
     */
    public static byte[] hex2Byte(String source) { // 字符串转二进制
        if (source == null)
            return null;
        String str = source.trim();
        int len = str.length();
        if (len == 0 || len % 2 == 1)
            return null;
        byte[] b = new byte[len / 2];
        try {
            for (int i = 0; i < str.length(); i += 2) {
                b[i / 2] = (byte) Integer.decode("0X" + str.substring(i, i + 2)).intValue();
            }
            return b;
        } catch (Exception e) {
            return null;
        }
    }

    public static List<FormFieldBean> convertFieldName2BeanList(String fieldName, String label, FormBean formBean) {
        String[] names = fieldName.split(label);
        return getFieldBean4NameList(Arrays.asList(names), formBean);
    }

    /**
     * 获得单部门控件比较sql语句
     *
     * @param whereClause
     * @param id
     * @param field
     * @param operator
     * @return FormQueryWhereClause
     */
    public static FormQueryWhereClause getDepartmentsLogicWhereClauseSQL(String tableName, String id,
                                                                         String field, String operator) {
        FormQueryWhereClause whereClause = new FormQueryWhereClause();
        if (field.contains(".")) {
            field = field.split("[.]")[1];
        }
        boolean needTableName = true;
        if (field.startsWith(FormBean.R_PREFIX)) {
            needTableName = false;
        }
        boolean isLike = (operator.indexOf("like") >= 0);
        String sql = "";
        List<Object> params = new ArrayList<Object>();
        //id可能是null字符串 edit by chenxb 2016-04-20 from Strings.isBlank to StringUtil.checkNull
        if (StringUtil.checkNull(id)) {
            sql = (needTableName ? tableName : "") + field + " " + operator + " ? ";
            if (isLike) {
                params.add("%%");
            } else {
                params.add(id);
            }
        } else {
            StringBuilder sb = new StringBuilder(" ");
            /**
             * 此处应该分情况
             * operator为'=' 或 like： field 等于 部门 及其子部门
             *      包含子部门：field=1 or field=1.1 or field = 1.2
             *      不包含子部门：field = 1
             * operator为'<>':field不等于某部门及其子部门
             *      包含子部门：field<>1 and field <> 1.1 and field <> 1.2
             *      不包含子部门： field <> 1
             */
            if (id.startsWith(FormBean.R_PREFIX)) {
                sb.append(id.replaceFirst(FormBean.R_PREFIX, tableName.substring(0, tableName.indexOf("_") + 1))).append(" ").append(operator);
            } else if (!id.contains("|1") && !id.contains(",")) {//包含子部门
                OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
                try {
                    V3xOrgDepartment dept = orgManager.getDepartmentById(Long.parseLong(id));
                    if (dept != null) {
                        List<V3xOrgDepartment> list = orgManager.getChildDepartments(dept.getId(), false);
                        if (list != null) {
                            String logicOp = operator.indexOf("<>") >= 0 ? " and " : " or ";
                            sb.append(" ( ");
                            sb.append(tableName + field + " " + operator + " ? ");
                            if (isLike) {
                                params.add("%" + SQLWildcardUtil.escape(id) + "%");
                            } else {
                                params.add(id);
                            }
                            int len = list.size();
                            for (int i = 0; i < len; i++) {
                                V3xOrgDepartment v3xOrgDepartment = list.get(i);
                                sb.append(logicOp);
                                sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                                if (isLike) {
                                    params.add("%" + SQLWildcardUtil.escape(v3xOrgDepartment.getId().toString()) + "%");
                                } else {
                                    params.add(v3xOrgDepartment.getId().toString());
                                }
                            }
                            sb.append(" ) ");
                        }
                    } else {
                        //非部门控件
                        sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                        if (isLike) {
                            params.add("%" + SQLWildcardUtil.escape(id) + "%");
                        } else {
                            params.add(id);
                        }
                    }
                } catch (Exception e) {
                    LOG.error("", e);
                    sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                    if (isLike) {
                        params.add("%" + SQLWildcardUtil.escape(id) + "%");
                    } else {
                        params.add(id);
                    }
                }
            } else if (id.contains(",")) {
                String[] departmentIds = id.split(",");
                String logicOp = operator.indexOf("<>") >= 0 ? " and " : " or ";
                sb.append(" ( ");
                int len = departmentIds.length;
                for (int i = 0; i < len; i++) {
                    String depId = departmentIds[i];
                    if (i == 0) {
                        sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                        if (isLike) {
                            params.add("%" + SQLWildcardUtil.escape(depId) + "%");
                        } else {
                            params.add(depId);
                        }
                    } else {
                        sb.append(logicOp);
                        sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                        if (isLike) {
                            params.add("%" + SQLWildcardUtil.escape(depId) + "%");
                        } else {
                            params.add(depId);
                        }
                    }
                }
                sb.append(" ) ");
            } else {//不包含子部门
                String realId = id.substring(0, id.indexOf("|"));
                sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                if (isLike) {
                    params.add("%" + SQLWildcardUtil.escape(realId) + "%");
                } else {
                    params.add(realId);
                }
            }
            sql = sb.toString();
        }
        whereClause.setAllSqlClause(sql.toString());
        whereClause.setQueryParams(params);
        return whereClause;
    }

    /**
     * 获得多部门控件比较sql语句 getSqlForMultilDepartmentEqualNotEqual
     *
     * @param whereClause
     * @param id
     * @param field
     * @param operator
     * @return FormQueryWhereClause
     */
    public static FormQueryWhereClause getMultilDepartmentEqualNotEqualWhereClauseSQL(String tableName,
                                                                                      String id, String field, String operator) {
        FormQueryWhereClause whereClause = new FormQueryWhereClause();
        String sql = "";
        boolean needTableName = true;
        if (field.startsWith(FormBean.R_PREFIX)) {
            needTableName = false;
        }
        List<Object> params = new ArrayList<Object>();
        if (Strings.isBlank(id)) {
            sql = FormulaFunctionUitl.getFieldSqlForNull((needTableName ? tableName : "") + field, null) + operator + " ? ";
            params.add(id);
        } else {
            StringBuilder sb = new StringBuilder(" (");
            Map<String, Deque<String>> childDeptMap = new HashMap<String, Deque<String>>();
            //带有"|1"的id对应表
            Map<String, String> upMap = new HashMap<String, String>();
            //总条数
            int count = 1;
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            String[] ids = id.split(",");
            for (String idi : ids) {
                if (!idi.contains("|1")) {//包含子部门
                    try {
                        V3xOrgDepartment dept = orgManager.getDepartmentById(Long.parseLong(idi));
                        if (dept != null) {
                            Deque<String> childDetpDeque = new ArrayDeque<String>();
                            childDeptMap.put(idi, childDetpDeque);
                            childDetpDeque.offer(idi);
                            List<V3xOrgDepartment> list = orgManager.getChildDepartments(dept.getId(), false);
                            if (list != null && !list.isEmpty()) {
                                int len = list.size();
                                for (int i = 0; i < len; i++) {
                                    V3xOrgDepartment v3xOrgDepartment = list.get(i);
                                    childDetpDeque.offer(String.valueOf(v3xOrgDepartment.getId()));
                                }
                            }
                            count *= childDetpDeque.size();
                        }
                    } catch (Exception e) {
                        LOG.error("---getDepartmentById error---->", e);
                    }
                } else {
                    //不包含子部门
                    upMap.put(idi, idi.substring(0, idi.indexOf("|")));
                }
            }
            //是多部门控件需要处理
            if (!upMap.isEmpty() || !childDeptMap.isEmpty()) {
                String logicOp = operator.indexOf("<>") >= 0 ? " and " : " or ";
                for (int i = 0; i < count; i++) {
                    String sbSub = id;
                    //替换带"|1"
                    Iterator<Entry<String, String>> upIt = upMap.entrySet().iterator();
                    while (upIt.hasNext()) {
                        Entry<String, String> upItEn = upIt.next();
                        String key = upItEn.getKey();
                        String value = upItEn.getValue();
                        sbSub = sbSub.replace(key, value);
                    }
                    //替换子部门
                    Iterator<Entry<String, Deque<String>>> childIt = childDeptMap.entrySet().iterator();
                    while (childIt.hasNext()) {
                        Entry<String, Deque<String>> childItEn = childIt.next();
                        String key = childItEn.getKey();
                        Deque<String> deValue = childItEn.getValue();
                        String value = deValue.pollFirst();
                        if (value != null) {
                            sbSub = sbSub.replace(key, value);
                        }
                    }
//                    sb.append(" " + field + operator + " '" + sbSub + "' ");
                    sb.append(" " + (needTableName ? tableName : "") + field + " " + operator + " ? ");
                    if (i != count - 1) {
                        sb.append(" " + logicOp + " ");
                    }
                    params.add(sbSub);
                }
            } else {
//                sb.append(field + operator + " '" + id + "' ");
                sb.append((needTableName ? tableName : "") + field + " " + operator + " ? ");
                params.add(id);
            }
            sb.append(")");
            sql = sb.toString();
        }
        whereClause.setAllSqlClause(sql);
        whereClause.setQueryParams(params);
        return whereClause;
    }

    /**
     * @param condition
     * @param fb
     * @param needTableName
     * @return
     */
    public static FormQueryWhereClause getSQLStrWhereClause(List<Map<String, Object>> condition, FormBean fb, boolean needTableName) {
        List<Object> queryParams = new ArrayList<Object>();
        StringBuffer sb = new StringBuffer("");
        if (Strings.isNotEmpty(condition)) {//组装SQL
            sb.append("(");
            for (int i = 0; i < condition.size(); i++) {
                Map<String, Object> m = condition.get(i);
                FormFieldBean tempField = fb.getFieldBeanByName((String) m.get(FIELDNAME));
                if(tempField != null){
                    try {
                        tempField = tempField.findRealFieldBean();
                    } catch (BusinessException e) {
                        LOG.info("转换字段出现异常"+e);
                    }
                }
                //查询值为空时，直接替换为 1= 1；daiy 61968
                if (Strings.isBlank((String) m.get(FIELDVALUE)) || Strings.isBlank((String) m.get(FIELDNAME)) || ("0".equals(m.get(FIELDVALUE)) && tempField != null && tempField.getFinalInputType().equalsIgnoreCase(FormFieldComEnum.SELECT.getKey()))) {
                    sb.append(isNull2Str(m.get(LEFTCHAR)));
                    sb.append(" 1 = 1 ");
                    sb.append(isNull2Str(m.get(RIGHTCHAR))).append(" ");
                    if (i < condition.size() - 1) {
                        sb.append(m.get(ROWOPERATION).toString()).append(" ");
                    }
                    continue;
                }
                String fieldName = m.get(FIELDNAME).toString();
                sb.append(isNull2Str(m.get(LEFTCHAR)));
                if (fieldName.equals(MasterTableField.start_date.getKey()) || fieldName.equals(MasterTableField.modify_date.getKey())) {
                    try {
                        FormQueryWhereClause myWhereClause = getDateTimeWhereClauseSql(m, fb, needTableName);
                        if (null != myWhereClause) {
                            if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                sb.append(myWhereClause.getAllSqlClause());
                            }
                            if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                queryParams.addAll(myWhereClause.getQueryParams());
                            }
                        }
                    } catch (ParseException e) {
                        LOG.error("设置开始日期，结束日期时条件时，异常", e);
                    }
                } else if (MasterTableField.getEnumByKey(fieldName) != null) {
                    String op = m.get(OPERATION).toString();
                    Object o = isNull2Str(m.get(FIELDVALUE));
                    fieldName = getFieldName4SQL(fieldName, fb.getMasterTableBean(), needTableName);
                    sb.append(fieldName).append(op).append(" ? ");
                    queryParams.add(String.valueOf(o));
                } else {
                    String op = m.get(OPERATION).toString();
                    Object o = isNull2Str(m.get(FIELDVALUE));
                    String value = "?";
                    boolean isEnumField = false;
                    if (null != tempField && (tempField.getFinalInputType(true).equals(FormFieldComEnum.SELECT.getKey())
                            || tempField.getFinalInputType(true).equals(FormFieldComEnum.CHECKBOX.getKey())
                            || tempField.getFinalInputType(true).equals(FormFieldComEnum.RADIO.getKey()))) {//枚举类型字段
                        FormFormulaFunctionCompareEnumValue enumFunction = new FormFormulaFunctionCompareEnumValue();
                        FormQueryWhereClause myWhereClause = enumFunction.getEnumCompareWhereClause(true, fb, true, false, fieldName, op, String.valueOf(o));
                        if (null != myWhereClause) {
                            if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                sb.append(myWhereClause.getAllSqlClause());
                            }
                            if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                queryParams.addAll(myWhereClause.getQueryParams());
                            }
                        }
                        isEnumField = true;
                    }
                    if (!isEnumField) {
                        if (tempField != null) {
                            fieldName = getFieldName4SQL(fieldName, fb.getTableByTableName(tempField.getOwnerTableName()), needTableName);
                        }
                        if (!ConditionSymbol.include.getKey().equals(op)) {
                            if (tempField != null) {
                                if (FormFieldComEnum.EXTEND_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFinalInputType())
                                        || (FormFieldComEnum.OUTWRITE.getKey().equalsIgnoreCase(tempField.getFinalInputType())
                                        && FormFieldComEnum.EXTEND_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFormatType()))) {
                                    FormQueryWhereClause myWhereClause = getDepartmentsLogicWhereClauseSQL("", String.valueOf(o), fieldName, op);
                                    if (null != myWhereClause) {
                                        if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                            sb.append(myWhereClause.getAllSqlClause());
                                        }
                                        if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                            queryParams.addAll(myWhereClause.getQueryParams());
                                        }
                                    }
                                } else if (FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFinalInputType())
                                        || (FormFieldComEnum.OUTWRITE.getKey().equalsIgnoreCase(tempField.getFinalInputType())
                                        && FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey().equalsIgnoreCase(tempField.getFormatType()))) {
                                    FormQueryWhereClause myWhereClause = getMultilDepartmentEqualNotEqualWhereClauseSQL("", String.valueOf(o), fieldName, op);
                                    if (null != myWhereClause) {
                                        if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                            sb.append(myWhereClause.getAllSqlClause());
                                        }
                                        if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                            queryParams.addAll(myWhereClause.getQueryParams());
                                        }
                                    }
                                } else {
                                    if (op.contains(ConditionSymbol.like.getKey())) {
                                        if (FormFieldComEnum.RADIO.getKey().equalsIgnoreCase(tempField.getFinalInputType())) {
                                            op = "in";
                                            value = "(" + String.valueOf(o) + ")";
                                            if (tempField.getFieldType().equalsIgnoreCase(FieldType.VARCHAR.getKey())) {
                                                String[] os = String.valueOf(o).split(",");
                                                for (int k = 0; k < os.length; k++) {
                                                    os[k] = "'" + os[k] + "'";
                                                }
                                                value = "(" + Strings.joinDelNull(",", os) + ")";
                                                ;
                                            }
                                        } else {
                                            JDBCAgent jdbc = new JDBCAgent();
                                            Dialect d =  jdbc.getDialect();
                                            jdbc.close();
                                            op = op.replace(ConditionSymbol.like.getKey(), " " + ConditionSymbol.like.getKey()).replace("_", "");
                                            //sqlserver下 江(购)字[2015]第10007号这种有[的查询不出来
                                            if(d.getClass().getName().toLowerCase().indexOf("sqlserver")>-1){
                                                o = "%" + String.valueOf(o).replace("[", "[[]")  + "%";
                                            }else{
                                                o = "%" + String.valueOf(o)  + "%";
                                            }
                                            queryParams.add(o);
                                        }
                                    } else {
                                        o = getHQLObject(fb, fieldName, String.valueOf(o));
                                        queryParams.add(o);
                                    }

                                    sb.append(fieldName).append(" ").append(op).append(" ").append(value).append(" ");
                                }
                            }
                        } else {
                            StringBuilder valueStr = new StringBuilder();
                            String oStr = String.valueOf(o);
                            if (oStr.contains(",")) {
                                String[] oStrs = oStr.split(",");
                                valueStr.append(" (");
                                for (int j = 0; j < oStrs.length; j++) {
                                    FormQueryWhereClause myWhereClause = getDepartmentsLogicWhereClauseSQL("", oStrs[j], fieldName, " like ");
                                    if (null != myWhereClause) {
                                        if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                            valueStr.append(myWhereClause.getAllSqlClause());
                                        }
                                        if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                            queryParams.addAll(myWhereClause.getQueryParams());
                                        }
                                    }
                                    if (j != oStrs.length - 1) {
                                        valueStr.append(" and ");
                                    }
                                }
                                valueStr.append(" )");
                            } else {
                                FormQueryWhereClause myWhereClause = getDepartmentsLogicWhereClauseSQL("", oStr, fieldName, " like ");
                                if (null != myWhereClause) {
                                    if (Strings.isNotBlank(myWhereClause.getAllSqlClause())) {
                                        valueStr.append(myWhereClause.getAllSqlClause());
                                    }
                                    if (null != myWhereClause.getQueryParams() && !myWhereClause.getQueryParams().isEmpty()) {
                                        queryParams.addAll(myWhereClause.getQueryParams());
                                    }
                                }
                            }
                            sb.append(valueStr);
                        }
                    }
                }
                sb.append(isNull2Str(m.get(RIGHTCHAR))).append(" ");
                if (i < condition.size() - 1) {
                    sb.append(m.get(ROWOPERATION).toString()).append(" ");
                }
            }
            sb.append(") ");
        }
        FormQueryWhereClause whereClause = new FormQueryWhereClause();
        whereClause.setAllSqlClause(sb.toString());
        whereClause.setQueryParams(queryParams);
        return whereClause;
    }

    private static FormQueryWhereClause getDateTimeWhereClauseSql(Map<String, Object> m, FormBean fb,
                                                                  boolean needTableName) throws ParseException {
        List<Object> queryParams = new ArrayList<Object>();
        StringBuffer sb = new StringBuffer("");
        String fieldName = m.get(FIELDNAME).toString();//字段名称
        if (needTableName) {
            fieldName = fb.getMasterTableBean().getTableName() + "." + fieldName;
        }
        String o = isNull2Str(m.get(FIELDVALUE));
        Object maxDate = null;
        Object minDate = null;
        if (o.length() == 10) {
            maxDate = DateUtil.parseTimestamp(o + " 23:59:59", "yyyy-MM-dd HH:mm:ss");
            minDate = DateUtil.parseTimestamp(o + " 00:00:00", "yyyy-MM-dd HH:mm:ss");
        } else if (o.length() == 16) {
            maxDate = DateUtil.parseTimestamp(o + ":59", "yyyy-MM-dd HH:mm:ss");
            minDate = DateUtil.parseTimestamp(o + ":00", "yyyy-MM-dd HH:mm:ss");
        } else if (o.length() == 19) {
            maxDate = DateUtil.parseTimestamp(o, "yyyy-MM-dd HH:mm:ss");
            minDate = DateUtil.parseTimestamp(o, "yyyy-MM-dd HH:mm:ss");
        }

        ConditionSymbol opChar = ConditionSymbol.getEnumByKey(m.get(OPERATION).toString());
        switch (opChar) {
            case equal:
                sb.append("(").append(fieldName).append(" >= ? ").append(" and ").append(fieldName).append(" <= ? ").append(")");
                queryParams.add(minDate);
                queryParams.add(maxDate);
                break;
            case greatAndEqual://>=
                sb.append(fieldName).append(" >= ? ");
                queryParams.add(minDate);
                break;
            case greatThan://>
                sb.append(fieldName).append(" > ? ");
                queryParams.add(maxDate);
                break;
            case lessAndEqual://<=
                sb.append(fieldName).append(" <= ? ");
                queryParams.add(maxDate);
                break;
            case lessThan://<
                sb.append(fieldName).append(" < ? ");
                queryParams.add(minDate);
                break;
            case notEqual:
                sb.append("(").append(fieldName).append(" > ? ").append(" or ").append(fieldName).append(" < ? ").append(")");
                queryParams.add(maxDate);
                queryParams.add(minDate);
                break;
            default:
                sb.append(fieldName).append(" ").append(opChar).append(" ? ");
                queryParams.add(minDate);
                break;
        }
        FormQueryWhereClause whereClause = new FormQueryWhereClause();
        whereClause.setQueryParams(queryParams);
        whereClause.setAllSqlClause(sb.toString());
        return whereClause;
    }

    /**
     * 判断某个分类是否是根分类
     * 根分类：表单分类，协同分类
     *
     * @param category 分类
     * @return 是 true
     */
    public static boolean isBaseRootCatg(CtpTemplateCategory category) {
        return !(category.getParentId() != null && (ModuleType.form.getKey() != category.getParentId() && ModuleType.collaboration.getKey() != category.getParentId()));
    }

    /**
     * 查找Url字段
     *
     * @param allfieldList
     * @return
     * @throws BusinessException
     */
    public static List<String> findUrlFieldList(List<FormFieldBean> allfieldList) throws BusinessException {
        List<String> urlFieldList = new ArrayList<String>();
        for (FormFieldBean ffb : allfieldList) {
            FormFieldBean rffb = ffb.findRealFieldBean();
            if (FormConstant.URL_PAGE.equals(rffb.getFormatType())) {
                urlFieldList.add(ffb.getName());
            }
        }
        return urlFieldList;
    }
    /**
     * 查找image字段
     *
     * @param allfieldList
     * @return
     * @throws BusinessException
     */
    public static List<String> findImageFieldList(List<FormFieldBean> allFieldList) throws BusinessException{
        List<String> imgFieldList = new ArrayList<String>();
        for (FormFieldBean ffb : allFieldList) {
            if(ffb.isDisplayImage()){
                imgFieldList.add(ffb.getName());
            }
        }
        return imgFieldList;
    }

    /**
     * 删除目录或者文件（不管目录是否为空）
     *
     * @param path
     * @return
     */
    public static boolean delDirectory(String path) {

        File file = new File(path);
        if (file.exists()) {
            if (file.isDirectory()) {
                File[] files = file.listFiles();
                for (int i = 0; i < files.length; i++) {
                    if (delDirectory(files[i].getPath()) == false)
                        return false;
                }
                return file.delete();
            } else {
                return file.delete();
            }
        }
        return true;
    }

    public static <K, V> void addToMap(Map<K, List<V>> map, K k, V v, boolean check) {
        List<V> list = map.get(k);
        if (list == null) {
            list = new ArrayList<V>();
            map.put(k, list);
        }
        if (!check || !list.contains(v)) {
            list.add(v);
        }
    }

    public static BigDecimal formatNumBerFieldValue(Object value, String digitNumStr) {
        int digitNum = 0;
        if (Strings.isNotBlank(digitNumStr)) {
            digitNum = Integer.valueOf(digitNumStr);
        }
        return formatNumBerFieldValue(value, digitNum);
    }

    public static BigDecimal formatNumBerFieldValue(Object value, int digitNum) {
        BigDecimal result = new BigDecimal("0");
        if (value == null) {
            return null;
        }
        if (value instanceof Double) {
            //处理小数位
            BigDecimal b = new BigDecimal((Double) value);
            result = b.setScale(digitNum, BigDecimal.ROUND_HALF_UP);
            if (Double.doubleToRawLongBits(result.doubleValue()) == 0) {
                result = new BigDecimal("0");
            }
        } else if (value instanceof BigDecimal) {
            BigDecimal b = (BigDecimal) value;
            result = b.setScale(digitNum, BigDecimal.ROUND_HALF_UP);
            if (Double.doubleToRawLongBits(result.doubleValue()) == 0) {
                result = new BigDecimal("0");
            }
        } else if (value instanceof Integer) {
            result = new BigDecimal((Integer) value);
        }
        return result;
    }

    /**
     * 文本类型字段根据字段长度截取字段值
     * 中文字符按照3个字符长度计算
     *
     * @param str    需要校验及截取的值
     * @param length 最大长度
     * @return 根据长度截取后的值
     */
    public static String subStringByFieldLength(String str, int length) {
        if (Strings.isBlank(str)) {
            return str;
        }
        StringBuilder result = new StringBuilder();
        int len = 0;
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            //中文字符按照3个字符长度算
            if (c <= 255) {
                len += 1;
            } else {
                len += 3;
            }
            if (len <= length) {
                result.append(c);
            } else {
                break;
            }
        }
        return result.toString();
    }

    /**
     * 校验表单字段的录入类型是否是当前系统允许的类型
     * 如果是不允许的，替换为 普通的文本框类型
     *
     * @param formBean 目标对象
     */
    public static void validateFormBeanFieldInputType(FormBean formBean) {

        List<FormFieldBean> fieldBeans = formBean.getFieldsByType(FormFieldComEnum.RELATION);
        if (Strings.isNotEmpty(fieldBeans)) {
            for (FormFieldBean fieldBean : fieldBeans) {
                validateFormFieldBeanInputType(formBean, fieldBean);
            }
        }
        fieldBeans = formBean.getAllFieldBeans();
        for (FormFieldBean fieldBean : fieldBeans) {
            validateFormFieldBeanInputType(formBean, fieldBean);
        }
    }

    public static void validateFormFieldBeanInputType(FormBean formBean, FormFieldBean fieldBean) {

        FormFieldComEnum defaultEnum = FormFieldComEnum.TEXT;
        FormFieldComEnum comEnum = fieldBean.getInputTypeEnum();
        if (!comEnum.canUse()) {
            fieldBean.setInputType(defaultEnum.getKey());
            return;
        }
        FormRelation relation = fieldBean.getFormRelation();
        if (comEnum == FormFieldComEnum.RELATION && relation != null && formBean.getId().equals(relation.getToRelationObj())) {
            FormFieldBean finalFieldBean = formBean.getFieldBeanByName(relation.getToRelationAttr());
            if (finalFieldBean != null) {
                comEnum = finalFieldBean.getInputTypeEnum();
                if (!comEnum.canUse()) {
                    fieldBean.setInputType(defaultEnum.getKey());
                    fieldBean.setFormRelation(null);
                } else if (comEnum == FormFieldComEnum.EXTEND_MEMBER) {
                    FormRelationEnums.ViewAttrValue value = FormRelationEnums.ViewAttrValue.getEnumByKey(relation.getViewAttr());
                    if (!value.canUse()) {
                        fieldBean.setInputType(defaultEnum.getKey());
                        fieldBean.setFormRelation(null);
                    }
                } else if (relation.isDataRelationImageEnum() && !AppContext.hasPlugin(FormManager.FORM_ADVANCED_PLUGIN_ID)) {
                    fieldBean.setInputType(defaultEnum.getKey());
                    fieldBean.setFormRelation(null);
                }
            }
        }
    }

    /**
     * 获得无流程表单的授权信息
     *
     * @param formBean
     * @return
     * @throws BusinessException
     */
    public static String getUnflowFormAuth(FormBean formBean,String templateIdStr) throws BusinessException {
        String auth = null;
        if (formBean.getFormType() == FormType.baseInfo.getKey()) {//基础数据不考虑权限
            FormAuthViewBean authViewBean = formBean.getFormViewList().get(0).getFormAuthViewBeanListByType(FormAuthorizationType.show).get(0);
            auth = authViewBean.getFormViewId() + "." + authViewBean.getId();
        }
        if (formBean.getFormType() == FormType.manageInfo.getKey() || 
        		formBean.getFormType() == FormType.dynamicForm.getKey() ) {
            FormBindBean bindBean = formBean.getBind();
            FormBindAuthBean bindAuth = null;
            if(!StringUtil.checkNull(templateIdStr)){
                bindAuth = bindBean.getUnFlowTemplateMap().get(templateIdStr);
            }else{
                List<FormBindAuthBean> bindAuthList = bindBean.getUnflowFormBindAuthByUserId(AppContext.currentUserId());
                if (bindAuthList != null && bindAuthList.size() > 0) {
                    bindAuth = bindAuthList.get(0);
                }
            }
            if(bindAuth != null) {
                auth = bindAuth.getAuthByName(FormBindAuthBean.AuthName.BROWSE.getKey());
            }
        }
        return auth;
    }

    /**
     * 是否是移动端登陆，包含手机、pad
     *
     * @return
     */
    public static boolean isMobileLogin() {
        if (AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.iphone.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.ipad.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.androidphone.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.androidpad.ordinal()) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 是否是手机端登录
     *
     * @return
     */
    public static boolean isPhoneLogin() {
        if (AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.iphone.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.ipad.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.androidphone.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.androidpad.ordinal()
                || AppContext.getCurrentUser().getUserAgentFromEnum().ordinal() == login_useragent_from.weixin.ordinal()) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 获取具有固定前缀和特定后缀的国际化资源
     *
     * @param preI18n 固定前缀
     * @param sufI18n 后缀
     * @param values  参数
     * @return 国际化后的字符串
     */
    public static String getI18nString(String preI18n, String sufI18n, String... values) {
        return ResourceUtil.getStringByParams(preI18n + sufI18n, values);
    }

    /**
     * 递归校验表单数据关联的是否是流程表的流程标题
     *
     * @param formField        需要校验的字段
     * @param formCacheManager cacheManager
     * @return true 是
     */
    public static boolean isFlowName(FormFieldBean formField, FormCacheManager formCacheManager) {
        if (formField == null) {
            return false;
        }
        FormRelation formRelation = formField.getFormRelation();
        if (formRelation != null) {
            String viewAttr = formRelation.getViewAttr();
            int toRelationAttrType = formRelation.getToRelationAttrType();
            if (!FormRelationEnums.ViewAttrValue.flowName.getKey().equals(viewAttr)
                    && (FormRelationEnums.ToRelationAttrType.form_relation_field.getKey() == toRelationAttrType
                    || FormRelationEnums.ToRelationAttrType.data_relation_field.getKey() == toRelationAttrType)) {
                FormBean formbean = formCacheManager.getForm(formRelation.getToRelationObj());
                FormFieldBean tempFormFieldBean = formbean.getFieldBeanByName(formRelation.getViewAttr());
                if (tempFormFieldBean != null && (FormFieldComEnum.RELATIONFORM.getKey().equals(tempFormFieldBean.getInputType())
                        || FormFieldComEnum.RELATION.getKey().equals(tempFormFieldBean.getInputType()))) {
                    return isFlowName(tempFormFieldBean, formCacheManager);
                }
                return false;
            } else {
                return true;
            }
        }
        return false;
    }

    /**
     * 将由字段名称组成的字符串，转换为对应的字段列表，以字段所属表为区隔
     *
     * @param formBean  表单
     * @param fieldName 字段串
     * @return 结果
     */
    public static List<List<FormFieldBean>> splitFieldName2Field(FormBean formBean, String fieldName) {
        return splitFieldName2Field(formBean, fieldName, ",");
    }

    public static List<List<FormFieldBean>> splitFieldName2Field(FormBean formBean, String fieldName, String split) {
        Map<String, List<FormFieldBean>> map = splitFieldName2FieldByTable(formBean, fieldName, split);
        List<List<FormFieldBean>> result = new ArrayList<List<FormFieldBean>>();
        if (map != null && !map.isEmpty()) {
            for (Entry<String, List<FormFieldBean>> et : map.entrySet()) {
                List<FormFieldBean> fieldBeans = et.getValue();
                if (Strings.isNotEmpty(fieldBeans)) {
                    result.add(fieldBeans);
                }
            }
        }
        return result;
    }

    public static Map<String, List<FormFieldBean>> splitFieldName2FieldByTable(FormBean formBean, String fieldName) {
        return splitFieldName2FieldByTable(formBean, fieldName, ",");
    }

    public static Map<String, List<FormFieldBean>> splitFieldName2FieldByTable(FormBean formBean, String names, String split) {

        String[] fieldNames = names.split(split);
        Map<String, List<FormFieldBean>> result = getFieldTableFieldMap(formBean);
        for (String name : fieldNames) {
            String fieldName = name;
            if (name.contains(".")) {
                fieldName = name.substring(name.indexOf("."));
            }
            FormFieldBean fieldBean = formBean.getFieldBeanByName(fieldName);
            if (fieldBean != null) {
                Strings.addToMap(result, fieldBean.getOwnerTableName(), fieldBean);
            }
        }
        return result;
    }

    public static Map<String, List<FormFieldBean>> getFieldTableFieldMap(FormBean formBean) {
        return getFieldTableFieldMap(formBean, true);
    }

    public static Map<String, List<FormFieldBean>> getFieldTableFieldMap(FormBean formBean, boolean onlyMaster) {
        Map<String, List<FormFieldBean>> result = new LinkedHashMap<String, List<FormFieldBean>>();

        if (onlyMaster) {
            result.put(formBean.getMasterTableBean().getTableName(), new ArrayList<FormFieldBean>());
        } else {
            List<FormTableBean> tables = formBean.getTableList();
            for (FormTableBean table : tables) {
                result.put(table.getTableName(), new ArrayList<FormFieldBean>());
            }
        }

        return result;
    }

    /**
     * 转换老的流程处理意见
     *
     * @param oldFormatType
     * @return
     */
    public static String transOldFlowOption(String oldFormatType) {
        if (Strings.isNotBlank(oldFormatType)) {
            WorkFlowDealOpitionType oldType = WorkFlowDealOpitionType.getEnumItemByKey(oldFormatType);
            if (oldType == null) {
                return oldFormatType;
            }
            return oldType.getNewFormatType();
        }
        return "";
    }

    public static Object formatCalcValue(FormFieldBean fieldBean, Object v, String formulaType) throws BusinessException {
        Object value = v;
        try {
            boolean isSelect = fieldBean.findRealFieldBean().getInputType().equalsIgnoreCase(FormFieldComEnum.SELECT.getKey());
            if (isSelect ||
                    fieldBean.getInputType().equalsIgnoreCase(FormFieldComEnum.RADIO.getKey())) {
                EnumManager enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
                List<CtpEnumItem> enumItems = enumManager.getCtpEnumItem(fieldBean.getEnumId(), fieldBean.getEnumLevel());
                CtpEnumItem item = calcEnumItem(Math.ceil(new BigDecimal(value == null ? "0" : String.valueOf(value)).floatValue()), enumItems);
                if (item != null) {
                    value = item.getId();
                }
            }
            if (fieldBean.getInputType().equalsIgnoreCase(FormFieldComEnum.CHECKBOX.getKey())) {
                double val = 0d;
                try {
                    val = Double.valueOf(String.valueOf(value));
                } catch (Exception e) {
                    LOG.error("格式化复选框异常：", e);
                }
                BigDecimal resultVal = new BigDecimal(val);
                BigDecimal one = new BigDecimal(1);
                if (resultVal.compareTo(one) == 0) {
                    value = 1;
                } else {
                    value = 0;
                }
            }
        } catch (Exception e) {
            if (FormulaEnums.formulaType_varchar.equalsIgnoreCase(formulaType)) {
                value = "";
            } else if (FormulaEnums.formulaType_number.equalsIgnoreCase(formulaType)) {
                value = 0d;
            } else if (FormulaEnums.formulaType_date.equalsIgnoreCase(formulaType)) {
                value = null;
            } else if (FormulaEnums.formulaType_datetime.equalsIgnoreCase(formulaType)) {
                value = null;
            }
            LOG.error(e.getMessage(), e);
        }
        if (value instanceof Double) {
            //处理小数位
            if (fieldBean.getDigitNum() != null) {
                String digitNumStr = fieldBean.getDigitNum();
                int digitNumInt = Integer.parseInt(digitNumStr);
                BigDecimal b = new BigDecimal((Double) value);
                value = b.setScale(digitNumInt, BigDecimal.ROUND_HALF_UP);
                if (Double.doubleToRawLongBits(((BigDecimal) value).doubleValue()) == 0) {
                    value = new BigDecimal("0");
                }
            }
        } else if (value instanceof BigDecimal) {
            String digitNumStr = fieldBean.getDigitNum();
            int digitNumInt = Integer.parseInt(digitNumStr);
            BigDecimal b = (BigDecimal) value;
            value = b.setScale(digitNumInt, BigDecimal.ROUND_HALF_UP);
            if (Double.doubleToRawLongBits(((BigDecimal) value).doubleValue()) == 0) {
                value = new BigDecimal("0");
            }
        } else if (value != null && value instanceof Timestamp && FormulaEnums.formulaType_varchar.equalsIgnoreCase(formulaType)) {
            value = DateUtil.format((Date) value, DateUtil.YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_PATTERN);
        } else if (value != null && value instanceof Date && FormulaEnums.formulaType_varchar.equalsIgnoreCase(formulaType)) {
            value = DateUtil.format((Date) value);
        }
        return value;
    }

    /**
     * 当计算结果小于最小枚举时，取最小值
     * 当计算结果大于最大枚举时，取最大值
     * 当计算结果处于两个枚举项值之间时，取高值
     *
     * @param val
     * @param enumItems
     * @return
     */
    public static CtpEnumItem calcEnumItem(Number val, List<CtpEnumItem> enumItems) {
        int targetNum = val.intValue();
        CtpEnumItem maxItem = null;
        CtpEnumItem minItem = null;
        CtpEnumItem minimumRangeItem = null;
        int maxItemVal = 0;
        int minItemVal = 0;
        int minimumRangeVal = 0;
        //找出最大值和最小值
        for (int i = 0; i < enumItems.size(); i++) {
            CtpEnumItem euumItem = enumItems.get(i);
            String key = euumItem.getEnumvalue();
            int tempVal = Integer.parseInt(key);
            if (i == 0) {
                maxItemVal = tempVal;
                minItemVal = tempVal;
                maxItem = euumItem;
                minItem = euumItem;
                minimumRangeItem = euumItem;
                minimumRangeVal = (tempVal - targetNum) < 0 ? Integer.MAX_VALUE : (tempVal - targetNum);
            } else {
                if (tempVal >= maxItemVal) {
                    maxItemVal = tempVal;
                    maxItem = euumItem;
                }
                if (tempVal <= minItemVal) {
                    minItemVal = tempVal;
                    minItem = euumItem;
                }
                int rangeVal = (tempVal - targetNum);
                if (rangeVal >= 0 && rangeVal <= minimumRangeVal) {
                    minimumRangeVal = rangeVal;
                    minimumRangeItem = euumItem;
                }
            }
        }
        //小于最小枚举值，取最小枚举项
        if (targetNum <= minItemVal) {
            return minItem;
        }
        //大于最大枚举值，取最大枚举项
        if (targetNum >= maxItemVal) {
            return maxItem;
        }
        return minimumRangeItem;
    }

    /**
     * 判断给定的值是否在给定国际化key获取后的国际化值中
     *
     * @param source     需要比较的值
     * @param i18n       国际化key
     * @param parameters 国际化参数
     * @return true 是
     */
    public static boolean isEqualsWithI18nValue(String source, String i18n, Object... parameters) {
        String[] values = getAllI18nValue(i18n, parameters);
        if (values != null && values.length > 0) {
            for (String value : values) {
                if (source.equals(value)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 根据国际化key获取当前系统支持的所有的国际化后的值
     *
     * @param i18n       国际化key
     * @param parameters 参数
     * @return 国际化后的值数组
     */
    public static String[] getAllI18nValue(String i18n, Object... parameters) {
        List<Locale> allLocales = LocaleContext.getAllLocales();
        String[] values = new String[allLocales.size()];
        int i = 0;
        for (Locale local : allLocales) {
            values[i] = ResourceUtil.getStringByParams(local, i18n, parameters);
            i++;
        }
        return values;
    }

    /**
     * 递归校验表单数据关联的是否是表单的正文
     * add by chenxb 2016-01-20
     *
     * @param formField        需要校验的字段
     * @param formCacheManager cacheManager
     * @return true 是
     */
    public static boolean isFormContent(FormFieldBean formField, FormCacheManager formCacheManager) {
        if (formField == null) {
            return false;
        }
        FormRelation formRelation = formField.getFormRelation();
        if (formRelation != null) {
            String viewAttr = formRelation.getViewAttr();
            int toRelationAttrType = formRelation.getToRelationAttrType();
            if (!formContent.getKey().equals(viewAttr)
                    && (FormRelationEnums.ToRelationAttrType.form_relation_field.getKey() == toRelationAttrType
                    || FormRelationEnums.ToRelationAttrType.data_relation_field.getKey() == toRelationAttrType)) {
                FormBean formbean = formCacheManager.getForm(formRelation.getToRelationObj());
                FormFieldBean tempFormFieldBean = formbean.getFieldBeanByName(formRelation.getViewAttr());
                if (FormFieldComEnum.RELATIONFORM.getKey().equals(tempFormFieldBean.getInputType())
                        || FormFieldComEnum.RELATION.getKey().equals(tempFormFieldBean.getInputType())) {
                    return isFormContent(tempFormFieldBean, formCacheManager);
                }
                return false;
            } else {
                return true;
            }
        }
        return false;
    }

    /**
     * 将指定的SimpleObjectBean的属性转换为String
     * add by  chenxb 2016-03-09
     *
     * @param type  需要转换的属性
     * @param list  转化的list
     * @param split 连接符，默认，
     */
    public static String convertSimpleObjectList2String(String type, List<SimpleObjectBean> list, String split) {
        String value;
        StringBuilder string = new StringBuilder();
        if (Strings.isBlank(split)) {
            split = ",";
        }
        if (Strings.isNotEmpty(list) && Strings.isNotBlank(type)) {
            for (SimpleObjectBean objectBean : list) {
                if ("type".equals(type)) {
                    string.append(objectBean.getType()).append(split);
                } else if ("name".equals(type)) {
                    string.append(objectBean.getName()).append(split);
                } else if ("value".equals(type)) {
                    string.append(objectBean.getValue()).append(split);
                } else if ("display".equals(type)) {
                    string.append(objectBean.getDisplay()).append(split);
                }
            }
        }
        value = string.toString();
        if (value.endsWith(split)) {
            value = value.substring(0, value.length() - 1);
        }
        return value;
    }

    /**
     * 获取线程变量中的改变的单元格信息，分成主表和重复表，再返回
     * @return
     * @throws BusinessException
     */
    public static Map<String, Object> getRestChangeFieldInfo() throws BusinessException{
        Map<String, Object> result = new HashMap<String, Object>();
        //关联、计算等没有metadata，showformdata（打开表单）才会有
        FormTableBeanRestVO vo = (FormTableBeanRestVO) AppContext.getThreadContext(FormConstant.REST_FORM_FORM_INFO);
        if (vo != null) {
            result.put("metadata", vo);
        }
        Map<String,FormFieldValueBaseRestVO> changeInfo = (Map<String,FormFieldValueBaseRestVO>)AppContext.getThreadContext(FormConstant.REST_FORM_CHANGE_FIELD_INFO);
        if(changeInfo == null || changeInfo.size() == 0){
            return result;
        }
        //主表字段结果list放入返回值map中
        List<FormFieldValueBaseRestVO> masterVOList = new ArrayList<FormFieldValueBaseRestVO>();
        //重表字段结果map放入返回值map中
        //TODO 结构先这么定，后面需要再调整
        Map<String, Map<Long, List<FormFieldValueBaseRestVO>>> subVoMap = new HashMap<String, Map<Long, List<FormFieldValueBaseRestVO>>>();
        List<FormFieldValueBaseRestVO> subVOList;//每一行的单元格
        Map<Long, List<FormFieldValueBaseRestVO>> subMap;
        for(Entry<String,FormFieldValueBaseRestVO> map: changeInfo.entrySet()){
            String key = map.getKey();
            FormFieldValueBaseRestVO restVO = map.getValue();
            if(key.contains(FormConstant.DOWNLINE)){
                Long recordId = Long.parseLong(key.substring(key.indexOf(FormConstant.DOWNLINE) + 1));
                subMap = subVoMap.get(restVO.getOwnerTableName());
                if (subMap == null) {
                    subMap = new LinkedHashMap<Long, List<FormFieldValueBaseRestVO>>();
                    subVoMap.put(restVO.getOwnerTableName(), subMap);
                }
                subVOList = subMap.get(recordId);
                if (subVOList == null) {
                    subVOList = new ArrayList<FormFieldValueBaseRestVO>();
                    subMap.put(recordId, subVOList);
                }
                subVOList.add(restVO);
            }else{
                masterVOList.add(restVO);
            }
        }
        //给重复表数据排序
        FormDataMasterBean formDataMasterBean = (FormDataMasterBean)AppContext.getThreadContext(FormConstant.REST_FORM_DATA);
        if(formDataMasterBean != null){
            //重复表未展现的id
            DataContainer unShowSubDataIdMap = new DataContainer();
            Map<String, Map<Long, List<FormFieldValueBaseRestVO>>> newSubVoMap = new HashMap<String, Map<Long, List<FormFieldValueBaseRestVO>>>();
            for(Entry<String,Map<Long, List<FormFieldValueBaseRestVO>>> tableMap:subVoMap.entrySet()){
                String subTableName = tableMap.getKey();
                List<FormDataSubBean> subBeanList = formDataMasterBean.getSubData(subTableName);
                //重复表的值
                Map<Long, List<FormFieldValueBaseRestVO>> tableData = tableMap.getValue();
                Map<Long, List<FormFieldValueBaseRestVO>> newTableData = new LinkedHashMap<Long, List<FormFieldValueBaseRestVO>>();
                if(!Strings.isEmpty(subBeanList)) {
                    for (FormDataSubBean subBean : subBeanList) {
                        List<FormFieldValueBaseRestVO> list = tableData.get(subBean.getId());
                        if (list != null) {
                            newTableData.put(subBean.getId(), list);
                        }
                    }
                }
                newSubVoMap.put(subTableName,newTableData);
                //判断数据是否有未加载的重复表
                List<Long> notShowSubDataId = formDataMasterBean.getNotShowSubDataIds(subTableName);
                if(notShowSubDataId!=null){
                    unShowSubDataIdMap.add(subTableName, notShowSubDataId);
                }
            }
            if(!newSubVoMap.isEmpty()){
                subVoMap = newSubVoMap;
            }
            result.put("unShowSubDataIdMap",unShowSubDataIdMap);
            //判断没有加载完的重复行是否有必填的
            result.put("hasNotNullField",AppContext.getThreadContext("hasNotNullField")==null?new HashMap<String,Object>():AppContext.getThreadContext("hasNotNullField"));
            AppContext.removeThreadContext(FormConstant.REST_FORM_DATA);
        }
        FormBean fb = (FormBean) AppContext.getThreadContext(FormConstant.REST_FORM_BEAN_INFO);
        FormMasterBeanRestVO restVO = new FormMasterBeanRestVO(masterVOList, subVoMap);
        result.put(FormConstant.REST_FORM_PARAM_KEY_DATA, restVO.toJsonMap(fb));
        return result;
    }

    /**
     * 根据线程变量熟悉判断当前请求是否来自 H5页面通过rest接口
     * @return true 是
     */
    public static boolean isH5() {
        Object tag = AppContext.getThreadContext(FormConstant.h5Tag);
        boolean h5Tag = (tag==null)?false:(Boolean)tag;//预留h5参数
        return h5Tag;
    }

    /**
     * 判断请求是不是来自原表单
     * @return
     */
    public static boolean isPcForm(){
        String pcForm = (String)AppContext.getThreadContext("needContent");
        boolean isPcForm = "true".equals(pcForm)?true:false;
        return isPcForm;
    }

    /**
     * 将自定义查询项，输出项，排序项等转换为formFieldBean
     * @param formBean
     * @param list
     * @return
     * @throws BusinessException
     */
    public static List<FormFieldBean> getFieldBean4SimpleObject(FormBean formBean,List<SimpleObjectBean> list) throws BusinessException{
        List<FormFieldBean> resultList = new ArrayList<FormFieldBean>();
        for(SimpleObjectBean o:list){
            SystemDataField m = SystemDataField.getEnumByKey(o.getName());
            FormFieldBean ffb = new FormFieldBean();
            if(m!=null){//创建人或者创建时间
                ffb.setName(m.getKey());
                switch (m) {
                    case creator:
                        ffb.setInputType(FormFieldComEnum.EXTEND_MEMBER.getKey());
                        ffb.setFieldTypeEnum(FormFieldComEnum.EXTEND_MEMBER);
                        ffb.setFieldType(FieldType.VARCHAR.getKey());
                        break;
                    case createDate:
                        ffb.setInputType(FormFieldComEnum.EXTEND_DATETIME.getKey());
                        ffb.setFieldTypeEnum(FormFieldComEnum.EXTEND_DATETIME);
                        ffb.setFieldType(FieldType.DATETIME.getKey());
                        break;
                    default:
                        ffb.setInputType(FormFieldComEnum.TEXT.getKey());
                        ffb.setFieldTypeEnum(FormFieldComEnum.TEXT);
                        ffb.setFieldType(FieldType.VARCHAR.getKey());
                        break;
                }
            }else{
                    ffb = (FormFieldBean)formBean.getFieldBeanByName(o.getName().substring(o.getName().indexOf(".")+1));
            }
            String display = o.getValue();
            int index1 = display.indexOf("(");
            if(index1 != -1){
                display = display.substring(index1 + 1);
            }
            int index2 = display.indexOf(")");
            if(index2 != -1){
                display = display.substring(0,index2);
            }
            ffb.putExtraAttr("showDisplay", display);
            resultList.add(ffb);
        }
        return resultList;
    }

    public static Map<String, Object> getCommitData() {
        Map<String, Object> data = (Map<String, Object>) AppContext.getThreadContext(FormConstant.REST_FORM_COMMIT_DATA);
        if (data == null) {
            data = new HashMap<String, Object>();
        }
        return data;
    }

    public static void convertData(FormBean formBean) {
        Map<String, Object> commitData = getCommitData();
        Map<String, Object> data = (Map<String, Object>) commitData.get(FormConstant.REST_FORM_PARAM_KEY_DATA);
        if (data == null) {
            return;
        }
        Map<String, Object> result = convertData(formBean, data);
        result.put(FormConstant.REST_FORM_PARAM_KEY_ATTR,commitData.get(FormConstant.REST_FORM_PARAM_KEY_ATTR));
        AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_JSONOBJ_KEY, result);
    }
    private static Map<String,Object> convertData(FormBean formBean, Map<String, Object> params) {
        Map<String, Object> result = new HashMap<String, Object>();
        Map<String, Object> master = (Map<String, Object>) params.get(FormConstant.REST_FORM_PARAM_KEY_MASTER);
        master = convertSimpleData(master, true);
        result.put(formBean.getMasterTableBean().getTableName(), master);
        Map<String, Object> children = (Map<String, Object>) params.get(FormConstant.REST_FORM_PARAM_KEY_CHILDREN);
        Map<String, List<Map<String, Object>>> subData = new HashMap<String, List<Map<String, Object>>>();
        if (children != null && !children.isEmpty()) {
            for (Map.Entry<String, Object> et : children.entrySet()) {
                String tableName = et.getKey();
                Map<String, Object> data = (Map<String, Object>) et.getValue();
                if (data != null) {
                    List<Map<String, Object>> subDatas = (List<Map<String, Object>>)data.get(FormConstant.REST_FORM_PARAM_KEY_DATA);
                    if (Strings.isNotEmpty(subDatas)) {
                        for (Map<String, Object> e : subDatas) {
                            Map<String, Object> ss = convertSimpleData(e, false);
                            Strings.addToMap(subData, tableName, ss);
                        }
                    }
                }
            }
        }
        result.putAll(subData);
        return result;
    }

    private static Map<String, Object> convertSimpleData(Map<String, Object> params, boolean isMaster) {
        Map<String, Object> result = new HashMap<String, Object>();
        if (params.containsKey(FormConstant.REST_PARAM_KEY_ID)) {
            result.put(FormConstant.ID, params.get(FormConstant.REST_PARAM_KEY_ID));
        }
        for (Map.Entry<String, Object> et : params.entrySet()) {
            if (et.getKey().startsWith(FormConstant.FIELD_NAME_PRE)) {
                Map<String, Object> value = (Map<String, Object>) et.getValue();
                //"__state" -> "modified"
                if ("modified".equals(value.get("__state"))) {
                    result.put(et.getKey()+"_"+ (isMaster ? "0" : params.get(FormConstant.REST_PARAM_KEY_ID)) +"_editAtt", "true");
                }
                result.put(et.getKey(), value.get("value"));
            }
        }
        return result;
    }

    /**
     * 获取M3需要的模版信息
     * @param formBean 表单
     * @param formAuthViewBean 权限
     * @param formMasterDataBean 数据
     * @param viewState 单据状态，编辑，查看，设计，预览，打印（CtpContentAllBean）
     * @param templateType  当前请求展示表单类型
     * @param from 来源，如果是从showFormData来的，就不用在getHtml了。
     * @return
     * @throws BusinessException
     */
    public static FormTableBeanRestVO loadTemplate(FormBean formBean,FormAuthViewBean formAuthViewBean,FormDataMasterBean formMasterDataBean,int viewState,String templateType,String from) throws  BusinessException{
        FormMasterTableBeanRestVO restVO;
        FormViewBean formViewBean4Phone = formAuthViewBean.getViewBean(formBean, true);
        //如果没有传入表单展示类型，那么就用默认规则：当前视图为轻表单的，用轻表单模版，没有就返回源表单
        if(Strings.isBlank(templateType)){
            if(formViewBean4Phone.isPhone()){
                templateType = TemplateType.lightForm.getKey();
            }else{
                templateType = TemplateType.infopath.getKey();
            }
        }
        AppContext.putThreadContext("viewState",viewState);
        if(TemplateType.infopath.getKey().equals(templateType)){
            FormViewBean formViewBean4PC = formAuthViewBean.getViewBean(formBean, false);
            restVO = (FormMasterTableBeanRestVO)formViewBean4PC.getField4Rest(formBean,formAuthViewBean);
            restVO.setTemplateType(templateType);
            if("loadTemplate".equals(from)) {
                FormContentManager formContentManager = (FormContentManager) AppContext.getBean("formContentManager");
                IFormContent formContent = formContentManager.getFormContentManager(IFormContent.VIEW_TEMPLATE_INFOPATH);
                restVO.setTemplate(formContent.getHtml(formBean, formAuthViewBean, formMasterDataBean, viewState));
            }
        }else{
            restVO = (FormMasterTableBeanRestVO)formViewBean4Phone.getField4Rest(formBean,formAuthViewBean);
            restVO.setTemplate(FormLightFormUtil.transLightForm2H5(formBean, formAuthViewBean));
            restVO.setTemplateType(templateType);
        }
        AppContext.removeThreadContext("viewState");
        return restVO;
    }

    /**
     * H5 返回数据需要的信息
     * @param formDataMasterBean 主表数据，用于重复表排序
     * @param formBean 表单信息
     * @param formAuthViewBean 当前权限，如果formDataMasterBean不为空，则取这里面的
     */
    public static void putInfoToThreadContent(FormDataMasterBean formDataMasterBean,FormBean formBean,FormAuthViewBean formAuthViewBean){
        if(formDataMasterBean != null){
            AppContext.putThreadContext(FormConstant.REST_FORM_DATA,formDataMasterBean);
            if (formDataMasterBean.getExtraMap().containsKey(FormConstant.viewRight)) {
                formAuthViewBean = (FormAuthViewBean) formDataMasterBean.getExtraAttr(FormConstant.viewRight);
            }
        }
        AppContext.putThreadContext(FormConstant.REST_FORM_BEAN_INFO, formBean);
        AppContext.putThreadContext(FormConstant.REST_FORM_RIGHT_INFO, formAuthViewBean);
    }
    /**
     * 获取当前线程的堆栈信息，没有特殊需要的时候请不要调用，用作跟踪疑难杂症的时候输出日志
     * 如果整个堆栈打出来，日志信息太多，这里处理一下，只要有用的信息
     * @return
     */
    public static String getCurrentThreadStackTrance(){
        StringBuffer sb = new StringBuffer("\r\n");
        Throwable ex = new Throwable();
        StackTraceElement[] stackElements = ex.getStackTrace();
        if (stackElements != null) {
            for (int i = 0; i < stackElements.length; i++) {
                String className = stackElements[i].getClassName();
                //只输出业务相关的日志，平台的就不输出了
                if(className != null && (className.contains("com.seeyon.ctp.common") || className.contains("com.seeyon.ctp.form") || className.contains("com.seeyon.ctp.rest") || className.contains("com.seeyon.apps.collaboration"))){
                    String fileName = stackElements[i].getFileName();
                    if(fileName != null){
                        fileName = fileName.replaceAll(".java","");
                    }
                    sb.append(fileName+".");
                    sb.append(stackElements[i].getMethodName()+":");
                    sb.append(stackElements[i].getLineNumber()+"\r\n");
                }
            }
        }
        return sb.toString();
    }
    /**
     * 返回list中有非空的项
     * @param list
     * @return
     */
    public static List<Object> getNotNullItem(List<Object> list){
        List<Object> result = new ArrayList<Object>();
        for(Object obj: list){
            if(obj != null){
                result.add(obj);
            }
        }
        return result;
    }
}
