/**
 *
 */
package com.seeyon.ctp.form.modules.selectpeople;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormFieldComBean.FormFieldComEnum;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.manager.JoinOrgManagerDirect;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.selectpeople.manager.SelectPeoplePanel;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.workflow.manager.WorkflowCustomRoleInvokeManager;
import com.seeyon.ctp.workflow.wapi.WorkflowCustomRoleManager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.seeyon.ctp.organization.bo.V3xOrgEntity.TOXML_PROPERTY_NAME;
import static com.seeyon.ctp.organization.bo.V3xOrgEntity.TOXML_PROPERTY_id;

/**
 * @author duansy
 */
public class SelectPeoplePanel4FormImpl extends SelectPeoplePanel {
    private static final char SELECT_SINGLE = '1';//单选
    private static final char SELECT_MANY = '2';//多选
    private static final char SELECT_ALL = '3';//全选
    private static final String ALL_TYPES = "333";//全类型，即选人、选部门、选单位
    private static final String NONE_TYPES = "0";
    private static final int SIZE = 6;
    private static final String NOT_CHOOSE_SLAVE = "false";
    private FormManager formManager;

    private OrgManager orgManager;
    private JoinOrgManagerDirect joinOrgManagerDirect;

    public FormManager getFormManager() {
        return formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    /**
     * extParameters中参数为:formId,xxxxxx,true|false,slaveTableName
     * formId:表名ID
     * xxxxxx:为6位数字，前3位代表主表的，后3位代表重复表的(此处目前只用于工作流，同时做了特殊处理),每3位分别按顺序代表选人，选部门，选单位;每位分别都可设置0，1，2，3分别代表不选，只单人，只多人，单人多人,(xxxxx若要使三位起作用，第3个参数必须为false,第4个参数必须为空)
     * true/false:代表是否选取重复表所有控件,true选择，false不选
     * slaveTableName是重复表名字   选择重复表下的选人(在第3参数为false的情况下，本参数无效)
     */
    @Override
    public String getJsonString(long memberId, long accountId) throws BusinessException {
        String str = (String) AppContext.getThreadContext("extParameters");
        if (Strings.isBlank(str)) {
            return "[]";
        } else {
            String[] paramArray = analysisExtParams(str);
            if (NONE_TYPES.equals(paramArray[1]) || !isLong(paramArray[0])) {
                return "[]";
            }
            FormBean formBean = formManager.getEditingForm();
            if (Strings.isNotBlank(paramArray[0]) && isLong(paramArray[0]) && formBean == null) {
                formBean = formManager.getForm(Long.valueOf(paramArray[0]));
            }
            List<String> filterList = new ArrayList<String>();
            List<String> filterSlaveList = new ArrayList<String>();
            char[] types = paramArray[1].toCharArray();
            if (types[0] == SELECT_SINGLE) {
                filterList.add(FormFieldComEnum.EXTEND_MEMBER.getKey());
            } else if (types[0] == SELECT_MANY) {
                filterList.add(FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey());
            } else if (types[0] == SELECT_ALL) {
                filterList.add(FormFieldComEnum.EXTEND_MEMBER.getKey());
                filterList.add(FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey());
            }
            if (types[1] == SELECT_SINGLE) {
                filterList.add(FormFieldComEnum.EXTEND_DEPARTMENT.getKey());
            } else if (types[1] == SELECT_MANY) {
                filterList.add(FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey());
            } else if (types[1] == SELECT_ALL) {
                filterList.add(FormFieldComEnum.EXTEND_DEPARTMENT.getKey());
                filterList.add(FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey());
            }
            if (types[2] == SELECT_SINGLE) {
                filterList.add(FormFieldComEnum.EXTEND_ACCOUNT.getKey());
            } else if (types[2] == SELECT_MANY) {
                filterList.add(FormFieldComEnum.EXTEND_MULTI_ACCOUNT.getKey());
            } else if (types[2] == SELECT_ALL) {
                filterList.add(FormFieldComEnum.EXTEND_ACCOUNT.getKey());
                filterList.add(FormFieldComEnum.EXTEND_MULTI_ACCOUNT.getKey());
            }
            if (types[3] == SELECT_SINGLE) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_MEMBER.getKey());
            } else if (types[3] == SELECT_MANY) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey());
            } else if (types[3] == SELECT_ALL) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_MEMBER.getKey());
                filterSlaveList.add(FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey());
            }
            if (types[4] == SELECT_SINGLE) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_DEPARTMENT.getKey());
            } else if (types[4] == SELECT_MANY) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey());
            } else if (types[4] == SELECT_ALL) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_DEPARTMENT.getKey());
                filterSlaveList.add(FormFieldComEnum.EXTEND_MULTI_DEPARTMENT.getKey());
            }
            if (types[5] == SELECT_SINGLE) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_ACCOUNT.getKey());
            } else if (types[5] == SELECT_MANY) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_MULTI_ACCOUNT.getKey());
            } else if (types[5] == SELECT_ALL) {
                filterSlaveList.add(FormFieldComEnum.EXTEND_ACCOUNT.getKey());
                filterSlaveList.add(FormFieldComEnum.EXTEND_MULTI_ACCOUNT.getKey());
            }
            // 客开 start
            filterList.add(FormFieldComEnum.EXTEND_TEAM.getKey());
            filterSlaveList.add(FormFieldComEnum.EXTEND_TEAM.getKey());
            // 客开 end
            String slaveTableName = paramArray[3];
            if (Strings.isBlank(slaveTableName)) {
                slaveTableName = "";
            }

            StringBuilder o = new StringBuilder();
            o.append("[");
            if (formBean != null) {
                List<FormFieldBean> fieldList = formBean.getAllFieldBeans();
                List<FormFieldBean> resultList = new ArrayList<FormFieldBean>();
                for (FormFieldBean formFieldBean : fieldList) {
                    String inputType = formFieldBean.getInputType();
                    String tableName = formFieldBean.getOwnerTableName();
                    //默认是false
                    boolean notChooseSlave = Boolean.parseBoolean(paramArray[2]);
                    boolean isMasterField = formFieldBean.isMasterField();
                    if (FormFieldComEnum.RELATIONFORM.getKey().equals(inputType)
                            || FormFieldComEnum.RELATION.getKey().equals(inputType)) {
                        inputType = formFieldBean.getRealInputType();
                    }
                    if (FormFieldComEnum.OUTWRITE.getKey().equals(inputType)) {
                        FormFieldBean realFieldBean = formFieldBean.findRealFieldBean();
                        inputType = realFieldBean.getFormatType();
                    }

                    if (isMasterField && Strings.isNotEmpty(filterList) && filterList.contains(inputType)) {
                        FormFieldBean temp = new FormFieldBean();
                        temp.setDisplay(formFieldBean.getDisplay());
                        temp.setName(formFieldBean.getName());
                        temp.setInputType(inputType);
                        temp.setExternalType(formFieldBean.findRealFieldBean().getExternalType());
                        temp.setOwnerTableName(tableName);
                        resultList.add(temp);
                    } else if (Strings.isNotEmpty(filterSlaveList) && filterSlaveList.contains(inputType)
                            && (!notChooseSlave || slaveTableName.contains(tableName))) {
                        //此处为工作流对于选人，以及选多人做了特殊处理
                        FormFieldBean temp = new FormFieldBean();
                        temp.setDisplay(formFieldBean.getDisplay());
                        temp.setName(formFieldBean.getName());
                        if (FormFieldComEnum.EXTEND_MEMBER.getKey().equals(inputType)
                                || FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey().equals(inputType)) {
                            temp.setInputType(FormFieldComEnum.EXTEND_MULTI_MEMBER.getKey());
                        } else {
                            temp.setInputType(inputType);
                        }
                        temp.setExternalType(formFieldBean.findRealFieldBean().getExternalType());
                        temp.setOwnerTableName(tableName);
                        resultList.add(temp);
                    }
                }
                for (int i = 0; i < resultList.size(); i++) {
                    FormFieldBean temp = resultList.get(i);
                    boolean isVjoin= temp.getExternalType() != OrgConstants.ExternalType.Inner.ordinal();
                    if (i > 0) {
                        o.append(",");
                    }
                    String inputType = temp.getInputType();
                    String preFix = inputType.substring(0, 1).toUpperCase() + inputType.substring(1) + "@";

                    o.append("{");
                    o.append(TOXML_PROPERTY_id).append(":\"").append(preFix).append(temp.getName()).append("#").append(temp.getDisplay()).append("\"");
                    o.append(",").append(TOXML_PROPERTY_NAME).append(":\"").append(Strings.escapeJavascript(temp.getDisplay())).append("\"");
                    // 客开 start
                    if (inputType.contains(FormFieldComEnum.EXTEND_MEMBER.getKey()) || inputType.contains(FormFieldComEnum.EXTEND_DEPARTMENT.getKey()) 
                    		|| inputType.contains(FormFieldComEnum.EXTEND_ACCOUNT.getKey()) || inputType.contains(FormFieldComEnum.EXTEND_TEAM.getKey())) {

                        String r = "";
                    	int needType= 0;
                    	if(isVjoin && AppContext.hasPlugin("vjoin")){
                    		if(inputType.contains(FormFieldComEnum.EXTEND_DEPARTMENT.getKey())){
	                    		if(temp.getExternalType()==1){//机构角色
	                    			needType= 1;
	                    		}else if(temp.getExternalType()==2){//单位角色
	                    			needType= 2;
	                    		}
                    		}
                    		r = getRoleJsonString(accountId,isVjoin,needType);
                    	}else{
                    		r = getRoleJsonString(accountId,isVjoin,needType);
                    	}
                        o.append(",R : ").append(r);
                    }
                    // 客开 end
                    o.append("}");
                }
            }
            o.append("]");
            return o.toString();
        }
    }

    /**
     * 对传入的extParameters进行解析
     */
    private String[] analysisExtParams(String str) {
        String[] re = new String[4];
        re[0] = "";
        re[1] = ALL_TYPES;
        re[2] = NOT_CHOOSE_SLAVE;
        String[] extParameters = str.split(",");
        if (extParameters.length == 1) {
            re[0] = extParameters[0];
        } else if (extParameters.length == 2) {
            re[0] = extParameters[0];
            re[1] = extParameters[1];
        } else if (extParameters.length == 3) {
            re[0] = extParameters[0];
            re[1] = extParameters[1];
            re[2] = extParameters[2];
        } else if (extParameters.length == 4) {
            re[0] = extParameters[0];
            re[1] = extParameters[1];
            re[2] = extParameters[2];
            re[3] = extParameters[3];
        }
        int len = re[1].length();
        for (int i = len; i < SIZE; i++) {
            if (i <= 2) {
                re[1] = re[1] + SELECT_ALL;
            } else {
                re[1] = re[1] + NONE_TYPES;
            }
        }
        return re;
    }

    /**
     * 获取部门、单位角色，用于选人界面左侧下方的角色展示
     */
    private String getRoleJsonString(long accountId,boolean isShowVjoin,int needType) throws BusinessException {
        StringBuilder a = new StringBuilder();
        String deptMemberI18N = ResourceUtil.getString("selectPeople.node.DeptMember") + "(" + ResourceUtil.getString("common.selectPeople.excludechilddepartment") + ")";
        a.append("[");

        //vjoin预制角色和自定义角色
        if(!isShowVjoin){
	        a.append("{");
	        a.append(TOXML_PROPERTY_id).append(":\"DeptMember\"");
	        a.append(",").append(TOXML_PROPERTY_NAME).append(":\"").append(Strings.escapeJavascript(deptMemberI18N)).append("\"");
	        a.append("}");

        
	        /**
	         * V3xOrgRole
	         * category 是否前台授权 1--是；0--否
	         * status   是否显示在选人界面  1--是；0--否
	         * bond     角色所属OrgConstants.ROLE_BOND  0--集团角色GROUP；1--单位角色ACCOUNT；2--部门角色DEPARTMENT
	         * type     角色类型  1--固定角色V3xOrgEntity.ROLETYPE_FIXROLE；2--相对角色V3xOrgEntity.ROLETYPE_RELATIVEROLE；3--自定义角色V3xOrgEntity.ROLETYPE_USERROLE
	         * */
	        List<V3xOrgRole> allRoles = this.orgManager.getAllDepRoles(accountId);
	        for (V3xOrgRole role : allRoles) {
	            if (role.getStatus() != 1 || (role.getType() == V3xOrgEntity.ROLETYPE_FIXROLE && role.getName().contains("_"))) {
	                continue;
	            }
	
	            a.append(",");
	            role.toJsonString(a);
	        }
	
	        //单位角色
	        List<V3xOrgRole> accountCustomerRoles = orgManager.getAllRoles(accountId);
	        if (null != accountCustomerRoles && accountCustomerRoles.size() > 0) {
	            for (V3xOrgRole r : accountCustomerRoles) {
	                if (r.getType() == V3xOrgEntity.ROLETYPE_RELATIVEROLE && r.getBond() == OrgConstants.ROLE_BOND.ACCOUNT.ordinal() && r.getStatus() == 1) {
	                    a.append(",");
	                    //r.toJsonString(a);
	                    r.toJsonString4FormAccount(a);
	                }
	            }
	        }
	
	        //自定义角色
	        List<WorkflowCustomRoleManager> customRoles = WorkflowCustomRoleInvokeManager.getAllManager();
	        if (customRoles != null && !customRoles.isEmpty()) {
	            for (WorkflowCustomRoleManager role : customRoles) {
	                a.append(",{");
	                a.append(TOXML_PROPERTY_id).append(":\"").append(role.getRoleName()).append("\"");
	                a.append(",").append(TOXML_PROPERTY_NAME).append(":\"").append(Strings.escapeJavascript(role.getRoleText())).append("\"");
	                a.append("}");
	            }
	        }
        }
        //vjoin预制角色和自定义角色
        if(isShowVjoin){
        	List<V3xOrgRole> vjoinRoles = joinOrgManagerDirect.getAllRoles(null, null, null);
        	int i=0;
        	if(null!=vjoinRoles && vjoinRoles.size()>0){
    			for(V3xOrgRole r : vjoinRoles){
    				if(r.getBond() == OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() && r.getEnabled()
    						&& r.getExternalType()!=OrgConstants.ExternalType.Inner.ordinal()
    						){
    					if(r.getExternalType()==OrgConstants.ExternalType.Interconnect1.ordinal() && ( needType==1 || needType==0)){//机构角色
    						if(i!=0){
        						a.append(",");
        					}
        					i++;
    						r.toVjoinJsonString(a);
    					}else if(r.getExternalType()==OrgConstants.ExternalType.Interconnect2.ordinal() && ( needType==2 || needType==0)){//单位角色
    						if(i!=0){
        						a.append(",");
        					}
        					i++;
    						r.toVjoinJsonString(a);
    					}
    					
    				}
    			}
    		}
        }

        a.append("]");

        return a.toString();
    }

    @Override
    public Date getLastModifyTimestamp(Long arg0) throws BusinessException {
        return null;
    }

    /**
     * 页签类型：表单控件
     */
    @Override
    public String getType() {
        return "FormField";
    }

    /**
     * 是否为long类型
     */
    private static boolean isLong(String id) {
        String regex = "[-]{0,1}[\\d]+?";
        if (id.matches(regex)) {//id为数字
            return true;
        }
        return false;
    }

	public void setJoinOrgManagerDirect(JoinOrgManagerDirect joinOrgManagerDirect) {
		this.joinOrgManagerDirect = joinOrgManagerDirect;
	}

}
