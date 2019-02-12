package com.seeyon.apps.kdXdtzXc.scheduled;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.manager.XieChenXinXiQueRenManager;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class XieChengRenYuanQuartz {
	
private static XieChenXinXiQueRenManager xieChenXinXiQueRenManager;
private static Log log = LogFactory.getLog(XieChenXinXiQueRenManager.class);
	public XieChenXinXiQueRenManager getXieChenXinXiQueRenManager() {
		return xieChenXinXiQueRenManager;
	}

	public void setXieChenXinXiQueRenManager(XieChenXinXiQueRenManager xieChenXinXiQueRenManager) {
		this.xieChenXinXiQueRenManager = xieChenXinXiQueRenManager;
	}
	 /**
     * 功能：人事对接
     * 获取所需的人员信息封装为json格式串给中间区
     * @param request
     * @param response
     * @throws Exception
     */
    @NeedlessCheckLogin
    public void employeeDuijie() throws Exception {
    	String RenShiTongBu = (String) PropertiesUtils.getInstance().get("RenShiTongBu");
    	String types= RenShiTongBu;
    	log.info("*********************"+RenShiTongBu);
    	 if("Whole".equals(types)){ //-1792902092017745579
    		String [] str = new String[] {"-1792902092017745579","2662344410291130278","1755267543710320898","-5358952287431081185"};
    		for (int i = 0; i < str.length; i++) {
    			String type=str[i];
    			String xieChengType="";
    			if("-1792902092017745579".equals(type)){ //总部
    				type="cindaAsset-中国信达资产管理股份有限公司-提前审批";
    				xieChengType="ZB";
    			}
				if("2662344410291130278".equals(type)){ //北分
					type="cindaAssetBJ_提前审批授权"; 
					xieChengType="BF";
				 }
				if("1755267543710320898".equals(type)){//湖北
					type="cindaAssetHB_提前审批授权";
					xieChengType="HB";
				}
				if("-5358952287431081185".equals(type)){//江苏
					type="cindaAssetJS_提前审批授权";
					xieChengType="JS";
				}
				getOrgMember(str[i],type,xieChengType);
				/*Map<String,Object> map=new HashMap<String,Object>();
    	    	map.put("Renshiduijie", Renshiduijie);
    	    	map.put("xieChengType", xieChengType);
    	    	log.info("**携程数据**"+Renshiduijie);
    	    	//从配置文件中获取要post到中间区的地址
    	    	String RenShiDuiJie = (String) PropertiesUtils.getInstance().get("RenShiDuiJie");
    			String responseResult = HttpClientUtil.post(RenShiDuiJie, map);
    			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);//返回
    			String jsonJipiao  = jsonObject.optString("message");
    			log.info("****"+jsonJipiao);*/
			}
    	 }else if("Time".equals(types)){
    		 
    		 String [] str = new String[] {"-1792902092017745579","2662344410291130278","1755267543710320898","-5358952287431081185"};
     		for (int i = 0; i < str.length; i++) {
     			String type=str[i];
     			String xieChengType="";
     			if("-1792902092017745579".equals(type)){ //总部
     				type="cindaAsset-中国信达资产管理股份有限公司-提前审批";
     				xieChengType="ZB";
     			}
 				if("2662344410291130278".equals(type)){ //北分
 					type="cindaAssetBJ_提前审批授权"; 
 					xieChengType="BF";
 				 }
 				if("1755267543710320898".equals(type)){//湖北
 					type="cindaAssetHB_提前审批授权";
 					xieChengType="HB";
 				}
 				if("-5358952287431081185".equals(type)){//江苏
 					type="cindaAssetJS_提前审批授权";
 					xieChengType="JS";
 				}
 				getUpdateOrgMember(str[i],type,xieChengType);
     		}
        	 
         }else{
         	throw new Exception("type 参数丢失,或参数错误");
         }
    }
    
    public static void getOrgMember(String accountId,String type,String xieChengType){
    	log.info("////////////////////////////"+accountId+"*****"+xieChengType +"*-*-"+type);
    	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
    	StringBuilder builder = new StringBuilder();
    	try {
			List<Map<String, Object>> memberList =  xieChenXinXiQueRenManager.getDataByMemberWhole(accountId);
			 if(memberList != null && memberList.size() > 0){
	            	String subAccount=type;
	            	
	            	int listSize = memberList.size();
	            	int toIndex=500;
	            	//builder.append("{");
	        		//builder.append("\"Member\":[ ");
	            	for (int i =0;i<memberList.size();i+=500) {
	            		if(i+500>listSize){toIndex=listSize-i;}
	            		List<Map<String, Object>> subList = memberList.subList(i, i+toIndex);
	            		builder = new StringBuilder();
	            		for (int j = 0; j < subList.size(); j++) {
						Map<String, Object> map = subList.get(j);
	            		Long id = Long.valueOf(map.get("id")+"") ;
	            		String Dept1 = map.get("ORG_ACCOUNT_ID").toString() == null ? "" : (String) map.get("ORG_ACCOUNT_ID").toString();//信达机构编码	ORG_ACCOUNT_ID为公司ID
	            		String Dept2 = map.get("ORG_DEPARTMENT_ID").toString() == null ? "" : (String) map.get("ORG_DEPARTMENT_ID").toString();//部门编码	ORG_DEPARTMENT_ID部门ID
	            		String is_dgj = map.get("IS_DGJ")+"" == null ? "" : (String) map.get("IS_DGJ")+"";//部门编码	ORG_DEPARTMENT_ID部门ID
	            		
	            		String EmployeeID = map.get("LOGIN_NAME") == null ? "" : (String) map.get("LOGIN_NAME");//员工编码	LOGIN_NAME为登录人员名称
	            		String Name = map.get("NAME") == null ? "" : (String) map.get("NAME");//姓名
	            		String Email = map.get("EXT_ATTR_2") == null ? "" : (String) map.get("EXT_ATTR_2");//Email 
	            		String Is_deleted = map.get("IS_DELETED").toString() == null ? "" : (String) map.get("IS_DELETED").toString();//是否删除
	            		String IsSendEMail = "False";	//是否发送开通邮件
	            		String Valid = null;			//在职状态（ A-在职,I-离职）
	            		String IsBookClass = null;		//国内机票两舱是否可预订
	            		String RankName = null;			//职级
	            		String IntlBookClassBlock = null;//国际屏蔽舱位控制
	            		if(Is_deleted != "1" ){
	            			Valid = "A";
	            		}else{
	            			Valid = "I";
	            		}
	            		String zhiJi="";
	            		String loginName="";
	            		
	            		
	            	
	            		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager"); //-9077130845621107851
	            		 V3xOrgDepartment parentDepartment = orgManager.getParentDepartment(Long.valueOf(Dept2));
            			 Long id2 =0L;
	            		 if(parentDepartment == null){
	            			 /*List<V3xOrgDepartment> allParentDepartments = orgManager.getAllParentDepartments(Long.valueOf(Dept2));
	            			 Long id3 = allParentDepartments.get(0).getId();*/
	            			 id2= Long.valueOf(Dept2);
	            			/* V3xOrgDepartment departmentById = orgManager.getDepartmentById(Long.valueOf(Dept2));
	            			 String parentPath = departmentById.getParentPath();
	            			 V3xOrgDepartment departmentByPath = orgManager.getDepartmentByPath(parentPath);
	            			id2 = departmentByPath.getId();*/
	            		 }else{
	            			 id2 = parentDepartment.getId();//一级部门
	            		 }
	            		Boolean rolebm = orgManager.hasSpecificRole(id,id2,"部门领导");
	            		Boolean rolefgs = orgManager.hasSpecificRole(id,Long.valueOf(Dept1),"分公司领导");
	            		Boolean roleldj = orgManager.hasSpecificRole(id,Long.valueOf(Dept1),"部门领导级");
	            		Boolean rolelbsms = orgManager.hasSpecificRole(id,id2,"部室秘书");
	            		
	            		if(accountId != "-1792902092017745579"){
	            			//按照分公司
	            			if(rolefgs){
	            				zhiJi="中层管理人员";
		            			IsBookClass="T";
	            				//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            			List<V3xOrgDepartment> departmentsByName = orgManager.getDepartmentsByName("计划财务处",Long.valueOf(Dept1));
		            			if("-5358952287431081185".equals(accountId)){
    	            				departmentsByName =orgManager.getDepartmentsByName("资金财务处",Long.valueOf(Dept1));
    	            			}
		            			if(departmentsByName != null && departmentsByName.size() > 0){
	    	            		//List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(Long.valueOf(Dept1),"部门分管领导");
	    	            		Long cwDepaId = departmentsByName.get(0).getId();
	    	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(cwDepaId,"财务部分管领导");
	    	            		//List<V3xOrgMember> membersByDepartmentRoleOfUp = orgManager.getMembersByDepartmentRoleOfUp(id3, "财务部分管领导");
	    	            		
	    	            		//List<V3xOrgMember> membersByRole2 = orgManager.getMembersByAccountRoleOfUp(Long.valueOf(Dept1), "分公司领导");
	    	            		if(membersByRole != null && membersByRole.size() > 0){
	    	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		  		            			  
	    		                        @Override  
	    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	    		                        		
	    		                        	
	    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	    		                                return 1;  
	    		                            }  
	    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	    		                                return 0;  
	    		                            }  
	    		                            return -1; 
	    		                        	}
	    		                            return 1; 
	    		                        }  
	    		                    });   
	    	            		 V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	    	            		 
	    		                    if(v3xOrgMember.getId() == id){
	    		                    	List<V3xOrgDepartment> fgsDepartments = orgManager.getDepartmentsByName("分公司领导",Long.valueOf(Dept1));
	    		                    	if(fgsDepartments != null && fgsDepartments.size() >0){
	    	    	            		Long fgsDepaId = fgsDepartments.get(0).getId();
	    	    	            		List<V3xOrgMember> membersByRole2 = orgManager.getMembersByRole(fgsDepaId,"分公司总经理");
	    	    	            		if(membersByRole2 != null && membersByRole2.size() >0){
	    	    	            		V3xOrgMember v3xOrgMember1 = membersByRole2.get(0);//获取最小的
	    	    	            		loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    	    	            			}
	    		                    	}
	    		                    }else 
	    		            		{
	    		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    		   	            	
	    		            		}
	    	                   
	            			}
		            			}	
	            			}else if(rolelbsms){
	            				zhiJi="中层管理人员";
		            			IsBookClass="T";
	            				//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            			List<V3xOrgDepartment> departmentsByName = orgManager.getDepartmentsByName("计划财务处",Long.valueOf(Dept1));
		            			if("-5358952287431081185".equals(accountId)){
    	            				departmentsByName =orgManager.getDepartmentsByName("资金财务处",Long.valueOf(Dept1));
    	            			}
		            			if(departmentsByName != null && departmentsByName.size() > 0){
	    	            		//List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(Long.valueOf(Dept1),"部门分管领导");
	    	            		Long cwDepaId = departmentsByName.get(0).getId();
	    	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(cwDepaId,"财务部分管领导");
	    	            		//List<V3xOrgMember> membersByDepartmentRoleOfUp = orgManager.getMembersByDepartmentRoleOfUp(id3, "财务部分管领导");
	    	            		
	    	            		//List<V3xOrgMember> membersByRole2 = orgManager.getMembersByAccountRoleOfUp(Long.valueOf(Dept1), "分公司领导");
	    	            		if(membersByRole != null && membersByRole.size() > 0){
	    	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		  		            			  
	    		                        @Override  
	    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	    		                        		
	    		                        	
	    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	    		                                return 1;  
	    		                            }  
	    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	    		                                return 0;  
	    		                            }  
	    		                            return -1; 
	    		                        	}
	    		                            return 1; 
	    		                        }  
	    		                    });   
	    	            		 V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	    	            		 
	    		                    if(v3xOrgMember.getId() == id){
	    		                    	List<V3xOrgDepartment> fgsDepartments = orgManager.getDepartmentsByName("分公司领导",Long.valueOf(Dept1));
	    		                    	if(fgsDepartments != null && fgsDepartments.size() >0){
	    	    	            		Long fgsDepaId = fgsDepartments.get(0).getId();
	    	    	            		List<V3xOrgMember> membersByRole2 = orgManager.getMembersByRole(fgsDepaId,"分公司总经理");
	    	    	            		if(membersByRole2 != null && membersByRole2.size() >0){
	    	    	            		V3xOrgMember v3xOrgMember1 = membersByRole2.get(0);//获取最小的
	    	    	            		loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    	    	            			}
	    		                    	}
	    		                    }else 
	    		            		{
	    		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    		   	            	
	    		            		}
	    	                   
	            			}
		            			}
	            				
	            			}else{
	            				zhiJi="其他人员";
    	            			IsBookClass="F";
	            				//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
    	            			
    	            			List<V3xOrgDepartment> departmentsByName = orgManager.getDepartmentsByName("计划财务处",Long.valueOf(Dept1));
    	            			if("-5358952287431081185".equals(accountId)){
    	            				departmentsByName =orgManager.getDepartmentsByName("资金财务处",Long.valueOf(Dept1));
    	            			}
    	            			if(departmentsByName != null && departmentsByName.size() > 0){
	    	            		Long cwDepaId = departmentsByName.get(0).getId();
	    	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(cwDepaId,"财务部分管领导");
    	            			
	    	            		if(membersByRole != null && membersByRole.size() > 0){
	    	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		  		            			  
	    		                        @Override  
	    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	    		                        		
	    		                        	
	    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	    		                                return 1;  
	    		                            }  
	    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	    		                                return 0;  
	    		                            }  
	    		                            return -1; 
	    		                        	}
	    		                            return 1; 
	    		                        }  
	    		                    });    
	    	              
	    	                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	    	   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            				}
	            			}
	            			}

	            		}else {
	            			
	            		if("董事".equals(is_dgj)){
	            			zhiJi="公司高级管理人员";
	            			IsBookClass="T";
	            		//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6264752758283483849L,"部门领导");
	            		if(membersByRole != null && membersByRole.size() > 0){
	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		            			  
		                        @Override  
		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
		                        	if(!StringUtils.isEmpty(o1.getCode())){
		                        		
		                        	
		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
		                                return 1;  
		                            }  
		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
		                                return 0;  
		                            }  
		                            return -1; 
		                        	}
		                            return 1; 
		                        }  
		                    });  
	              
	                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	                    if(v3xOrgMember.getId() == id){
	                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
	            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	                    }else 
	            		{
	   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            		}
	            	}
	            		
	            		}else if("监事".equals(is_dgj)){
	            			zhiJi="公司高级管理人员";
	            			IsBookClass="T";
	            			
	            			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(6347997137069034145L,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });   
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		
		                    }else 
		            		{
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
		            		}
	            		}else if("高管".equals(is_dgj)){
	            			zhiJi="公司高级管理人员";
	            			IsBookClass="T";
	            			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6942533054201314690L,"部门领导");
	            			if(membersByRole != null && membersByRole.size() > 0){
	            				Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });    
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		
		                    }else 
		            		{
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
	            		}	
	            	}else if("高层秘书".equals(is_dgj)){
            			zhiJi="公司高级管理人员";
            			IsBookClass="T";
            			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6942533054201314690L,"部门领导");
            			if(membersByRole != null && membersByRole.size() > 0){
            				Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		            			  
		                        @Override  
		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
		                        		
		                        	
		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
		                                return 1;  
		                            }  
		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
		                                return 0;  
		                            }  
		                            return -1; 
		                        	}
		                            return 1; 
		                        }  
		                    });   
	              
	                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	                    if(v3xOrgMember.getId() == id){
	                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
	            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            		
	                    }else 
	            		{
	   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            		}
            		}	
            	}else if(rolelbsms){
        			zhiJi="公司高级管理人员";
        			IsBookClass="T";
        			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6942533054201314690L,"部门领导");
        			if(membersByRole != null && membersByRole.size() > 0){
        				Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	            			  
	                        @Override  
	                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	                        		
	                        	
	                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	                                return 1;  
	                            }  
	                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	                                return 0;  
	                            }  
	                            return -1; 
	                        	}
	                            return 1; 
	                        }  
	                    });   
              
                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
                    if(v3xOrgMember.getId() == id){
                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
            		
                    }else 
            		{
   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
            		}
        		}	
        	}
	            		else if(rolebm){
	            			zhiJi="中层管理人员";
	            			IsBookClass="T";
	            			//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });   
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            	    loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		                    }else 
		            		{
		   	            	 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
	            		}//else if(rolefgs){
	            	}	
	            		//}
	            		else if(roleldj){
	            			zhiJi="中层管理人员";
	            			IsBookClass="T";
	            			//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });   
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            	
		                    }else 
		            		{
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
		            		}	
	            		}else{
	            			zhiJi="其他人员";
	            			IsBookClass="F";
	            			//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });   
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                  
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
	            		
	            		}
	            		
	            	}
	            		//判断是否是第一个（从0开始）如果是不添加“，”号。
	            		//if(i != 0)
	            			//builder.append(",");
	            		log.info("////////////////////////////"+j);
	            		builder.append("{\"Authentication\":{");
	            		builder.append("\"EmployeeID\": \""+EmployeeID+"\"");		//员工编号
	            		builder.append(",\"Name\": \""+Name+"\"");		//用户姓名
	            		builder.append(",\"Dept1\": \""+Dept1+"\"");	//部门1
	            		builder.append(",\"Dept2\": \""+Dept2+"\"");	//部门2
	            		builder.append(",\"Email\": \""+Email+"\"");	//联系邮箱
	            		builder.append(",\"IsSendEMail\": \""+IsSendEMail+"\"");	//是否发送开通邮件默认为false
	            		builder.append(",\"SubAccountName\": \""+subAccount+"\"");	//
	            		builder.append(",\"Valid\": \""+Valid+"\"");	//在职情况
	            		builder.append(",\"RankName\": \""+zhiJi+"\"");	//职级
	            		builder.append(",\"IsBookClass\": \""+IsBookClass+"\"");	//关联信达员工国内机票差标设置，是否可预订高舱等。T:是，F：否。
	            		builder.append(",\"IntlBookClassBlock\": \""+IntlBookClassBlock+"\",");	//
	            		builder.append("\"ConfirmPersonList\":[{\"ProductType\":\"N\",\"AuthorizedTime\":2,\"ConfirmPerson\":\""+loginName+"\",\"ConfirmPersoncc\":\""+loginName+"\",\"IsDefault\":true},{\"ProductType\":\"H\",\"AuthorizedTime\":2,\"ConfirmPerson\":\""+loginName+"\",\"ConfirmPersoncc\":\""+loginName+"\",\"IsDefault\":true}]");
	            		builder.append("}},");
	            		}	   
	            		String Renshiduijie = builder.toString();
	            		if(!StringUtils.isEmpty(Renshiduijie)){
	            			Renshiduijie=Renshiduijie.substring(0, Renshiduijie.length()-1);
	            		}
	    				Map<String,Object> map=new HashMap<String,Object>();
	        	    	map.put("Renshiduijie", Renshiduijie);
	        	    	map.put("xieChengType", xieChengType);
	        	    	//从配置文件中获取要post到中间区的地址
	        	    	String RenShiDuiJie = (String) PropertiesUtils.getInstance().get("RenShiDuiJie");
	        			String responseResult = HttpClientUtil.post(RenShiDuiJie, map);
	        			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);//返回
	        			String jsonJipiao  = jsonObject.optString("message");
	        			log.info("****"+jsonJipiao);
	            	}
	            }
			 
		} catch (BusinessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//return null;
    	
   }
    
    public static void getUpdateOrgMember(String accountId,String type,String xieChengType){

    	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
    	StringBuilder builder = new StringBuilder();
    	try {
			List<Map<String, Object>> memberList =  xieChenXinXiQueRenManager.getDataByMemberTime(accountId);
			 if(memberList != null && memberList.size() > 0){
	            	String subAccount=type;
	            	
	            	int listSize = memberList.size();
	            	int toIndex=500;
	            	//builder.append("{");
	        		//builder.append("\"Member\":[ ");
	            	for (int i =0;i<memberList.size();i+=500) {
	            		if(i+500>listSize){toIndex=listSize-i;}
	            		List<Map<String, Object>> subList = memberList.subList(i, i+toIndex);
	            		builder = new StringBuilder();
	            		for (int j = 0; j < subList.size(); j++) {
						Map<String, Object> map = subList.get(j);
	            		Long id = Long.valueOf(map.get("id")+"") ;
	            		String Dept1 = map.get("ORG_ACCOUNT_ID").toString() == null ? "" : (String) map.get("ORG_ACCOUNT_ID").toString();//信达机构编码	ORG_ACCOUNT_ID为公司ID
	            		String Dept2 = map.get("ORG_DEPARTMENT_ID").toString() == null ? "" : (String) map.get("ORG_DEPARTMENT_ID").toString();//部门编码	ORG_DEPARTMENT_ID部门ID
	            		String is_dgj = map.get("IS_DGJ")+"" == null ? "" : (String) map.get("IS_DGJ")+"";//部门编码	ORG_DEPARTMENT_ID部门ID
	            		
	            		String EmployeeID = map.get("LOGIN_NAME") == null ? "" : (String) map.get("LOGIN_NAME");//员工编码	LOGIN_NAME为登录人员名称
	            		String Name = map.get("NAME") == null ? "" : (String) map.get("NAME");//姓名
	            		String Email = map.get("EXT_ATTR_2") == null ? "" : (String) map.get("EXT_ATTR_2");//Email 
	            		String Is_deleted = map.get("IS_DELETED").toString() == null ? "" : (String) map.get("IS_DELETED").toString();//是否删除
	            		String IsSendEMail = "False";	//是否发送开通邮件
	            		String Valid = null;			//在职状态（ A-在职,I-离职）
	            		String IsBookClass = null;		//国内机票两舱是否可预订
	            		String RankName = null;			//职级
	            		String IntlBookClassBlock = null;//国际屏蔽舱位控制
	            		if(Is_deleted != "1" ){
	            			Valid = "A";
	            		}else{
	            			Valid = "I";
	            		}
	            		String zhiJi="";
	            		String loginName="";
	            		
	            		
	            	
	            		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager"); //-9077130845621107851
	            		 V3xOrgDepartment parentDepartment = orgManager.getParentDepartment(Long.valueOf(Dept2));
            			 Long id2 =0L;
	            		 if(parentDepartment == null){
	            			 /*List<V3xOrgDepartment> allParentDepartments = orgManager.getAllParentDepartments(Long.valueOf(Dept2));
	            			 Long id3 = allParentDepartments.get(0).getId();*/
	            			 id2= Long.valueOf(Dept2);
	            			/* V3xOrgDepartment departmentById = orgManager.getDepartmentById(Long.valueOf(Dept2));
	            			 String parentPath = departmentById.getParentPath();
	            			 V3xOrgDepartment departmentByPath = orgManager.getDepartmentByPath(parentPath);
	            			id2 = departmentByPath.getId();*/
	            		 }else{
	            			 id2 = parentDepartment.getId();//一级部门
	            		 }
	            		Boolean rolebm = orgManager.hasSpecificRole(id,id2,"部门领导");
	            		Boolean rolefgs = orgManager.hasSpecificRole(id,Long.valueOf(Dept1),"分公司领导");
	            		Boolean roleldj = orgManager.hasSpecificRole(id,Long.valueOf(Dept1),"部门领导级");
	            		Boolean rolelbsms = orgManager.hasSpecificRole(id,id2,"部室秘书");
	            		
	            		if(accountId != "-1792902092017745579"){
	            			//按照分公司
	            			if(rolefgs){
	            				zhiJi="中层管理人员";
		            			IsBookClass="T";
	            				//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            			List<V3xOrgDepartment> departmentsByName = orgManager.getDepartmentsByName("计划财务处",Long.valueOf(Dept1));
		            			if("-5358952287431081185".equals(accountId)){
    	            				departmentsByName =orgManager.getDepartmentsByName("资金财务处",Long.valueOf(Dept1));
    	            			}
		            			if(departmentsByName != null && departmentsByName.size() > 0){
	    	            		//List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(Long.valueOf(Dept1),"部门分管领导");
	    	            		Long cwDepaId = departmentsByName.get(0).getId();
	    	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(cwDepaId,"财务部分管领导");
	    	            		//List<V3xOrgMember> membersByDepartmentRoleOfUp = orgManager.getMembersByDepartmentRoleOfUp(id3, "财务部分管领导");
	    	            		
	    	            		//List<V3xOrgMember> membersByRole2 = orgManager.getMembersByAccountRoleOfUp(Long.valueOf(Dept1), "分公司领导");
	    	            		if(membersByRole != null && membersByRole.size() > 0){
	    	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		  		            			  
	    		                        @Override  
	    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	    		                        		
	    		                        	
	    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	    		                                return 1;  
	    		                            }  
	    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	    		                                return 0;  
	    		                            }  
	    		                            return -1; 
	    		                        	}
	    		                            return 1; 
	    		                        }  
	    		                    });  
	    	            		 V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	    	            		 
	    		                    if(v3xOrgMember.getId() == id){
	    		                    	List<V3xOrgDepartment> fgsDepartments = orgManager.getDepartmentsByName("分公司领导",Long.valueOf(Dept1));
	    		                    	if(fgsDepartments != null && fgsDepartments.size() >0){
	    	    	            		Long fgsDepaId = fgsDepartments.get(0).getId();
	    	    	            		List<V3xOrgMember> membersByRole2 = orgManager.getMembersByRole(fgsDepaId,"分公司总经理");
	    	    	            		if(membersByRole2 != null && membersByRole2.size() >0){
	    	    	            		V3xOrgMember v3xOrgMember1 = membersByRole2.get(0);//获取最小的
	    	    	            		loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    	    	            			}
	    		                    	}
	    		                    }else 
	    		            		{
	    		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    		   	            	
	    		            		}
	    	                   
	            			}
		            			}	
	            			}else if(rolelbsms){
	            				zhiJi="中层管理人员";
		            			IsBookClass="T";
	            				//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            			List<V3xOrgDepartment> departmentsByName = orgManager.getDepartmentsByName("计划财务处",Long.valueOf(Dept1));
		            			if("-5358952287431081185".equals(accountId)){
    	            				departmentsByName =orgManager.getDepartmentsByName("资金财务处",Long.valueOf(Dept1));
    	            			}
		            			if(departmentsByName != null && departmentsByName.size() > 0){
	    	            		//List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(Long.valueOf(Dept1),"部门分管领导");
	    	            		Long cwDepaId = departmentsByName.get(0).getId();
	    	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(cwDepaId,"财务部分管领导");
	    	            		//List<V3xOrgMember> membersByDepartmentRoleOfUp = orgManager.getMembersByDepartmentRoleOfUp(id3, "财务部分管领导");
	    	            		
	    	            		//List<V3xOrgMember> membersByRole2 = orgManager.getMembersByAccountRoleOfUp(Long.valueOf(Dept1), "分公司领导");
	    	            		if(membersByRole != null && membersByRole.size() > 0){
	    	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		  		            			  
	    		                        @Override  
	    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	    		                        		
	    		                        	
	    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	    		                                return 1;  
	    		                            }  
	    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	    		                                return 0;  
	    		                            }  
	    		                            return -1; 
	    		                        	}
	    		                            return 1; 
	    		                        }  
	    		                    });  
	    	            		 V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	    	            		 
	    		                    if(v3xOrgMember.getId() == id){
	    		                    	List<V3xOrgDepartment> fgsDepartments = orgManager.getDepartmentsByName("分公司领导",Long.valueOf(Dept1));
	    		                    	if(fgsDepartments != null && fgsDepartments.size() >0){
	    	    	            		Long fgsDepaId = fgsDepartments.get(0).getId();
	    	    	            		List<V3xOrgMember> membersByRole2 = orgManager.getMembersByRole(fgsDepaId,"分公司总经理");
	    	    	            		if(membersByRole2 != null && membersByRole2.size() >0){
	    	    	            		V3xOrgMember v3xOrgMember1 = membersByRole2.get(0);//获取最小的
	    	    	            		loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    	    	            			}
	    		                    	}
	    		                    }else 
	    		            		{
	    		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	    		   	            	
	    		            		}
	    	                   
	            			}
		            			}
	            				
	            			}else{
	            				zhiJi="其他人员";
    	            			IsBookClass="F";
	            				//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
    	            			
    	            			List<V3xOrgDepartment> departmentsByName = orgManager.getDepartmentsByName("计划财务处",Long.valueOf(Dept1));
    	            			if("-5358952287431081185".equals(accountId)){
    	            				departmentsByName =orgManager.getDepartmentsByName("资金财务处",Long.valueOf(Dept1));
    	            			}
    	            			if(departmentsByName != null && departmentsByName.size() > 0){
	    	            		Long cwDepaId = departmentsByName.get(0).getId();
	    	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(cwDepaId,"财务部分管领导");
    	            			
	    	            		if(membersByRole != null && membersByRole.size() > 0){
	    	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		  		            			  
	    		                        @Override  
	    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	    		                        		
	    		                        	
	    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	    		                                return 1;  
	    		                            }  
	    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	    		                                return 0;  
	    		                            }  
	    		                            return -1; 
	    		                        	}
	    		                            return 1; 
	    		                        }  
	    		                    });   
	    	              
	    	                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	    	   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            				}
	            			}
	            			}

	            		}else {
	            			
	            		if("董事".equals(is_dgj)){
	            			zhiJi="公司高级管理人员";
	            			IsBookClass="T";
	            		//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
	            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6264752758283483849L,"部门领导");
	            		if(membersByRole != null && membersByRole.size() > 0){
	            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		            			  
		                        @Override  
		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
		                        		
		                        	
		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
		                                return 1;  
		                            }  
		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
		                                return 0;  
		                            }  
		                            return -1; 
		                        	}
		                            return 1; 
		                        }  
		                    });   
	              
	                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	                    if(v3xOrgMember.getId() == id){
	                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
	            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	                    }else 
	            		{
	   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            		}
	            	}
	            		
	            		}else if("监事".equals(is_dgj)){
	            			zhiJi="公司高级管理人员";
	            			IsBookClass="T";
	            			
	            			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(6347997137069034145L,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });  
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		
		                    }else 
		            		{
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
		            		}
	            		}else if("高管".equals(is_dgj)){
	            			zhiJi="公司高级管理人员";
	            			IsBookClass="T";
	            			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6942533054201314690L,"部门领导");
	            			if(membersByRole != null && membersByRole.size() > 0){
	            				Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });  
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		
		                    }else 
		            		{
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
	            		}	
	            	}else if("高层秘书".equals(is_dgj)){
            			zhiJi="公司高级管理人员";
            			IsBookClass="T";
            			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6942533054201314690L,"部门领导");
            			if(membersByRole != null && membersByRole.size() > 0){
            				Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
		            			  
		                        @Override  
		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
		                        		
		                        	
		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
		                                return 1;  
		                            }  
		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
		                                return 0;  
		                            }  
		                            return -1; 
		                        	}
		                            return 1; 
		                        }  
		                    });   
	              
	                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
	                    if(v3xOrgMember.getId() == id){
	                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
	            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            		
	                    }else 
	            		{
	   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
	            		}
            		}	
            	}else if(rolelbsms){
        			zhiJi="公司高级管理人员";
        			IsBookClass="T";
        			List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(-6942533054201314690L,"部门领导");
        			if(membersByRole != null && membersByRole.size() > 0){
        				Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	            			  
	                        @Override  
	                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
	                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
	                        		
	                        	
	                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
	                                return 1;  
	                            }  
	                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
	                                return 0;  
	                            }  
	                            return -1; 
	                        	}
	                            return 1; 
	                        }  
	                    });   
              
                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
                    if(v3xOrgMember.getId() == id){
                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
            		
                    }else 
            		{
   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
            		}
        		}	
        	}
	            		else if(rolebm){
	            			zhiJi="中层管理人员";
	            			IsBookClass="T";
	            			//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    }); 
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            	    loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		                    }else 
		            		{
		   	            	 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
	            		}//else if(rolefgs){
	            	}	
	            		//}
	            		else if(roleldj){
	            			zhiJi="中层管理人员";
	            			IsBookClass="T";
	            			//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });   
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                    if(v3xOrgMember.getId() == id){
		                    V3xOrgMember v3xOrgMember1 = membersByRole.get(1);//获取最小的
		            		 loginName = v3xOrgMember1.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            	
		                    }else 
		            		{
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
		            		}	
	            		}else{
	            			zhiJi="其他人员";
	            			IsBookClass="F";
	            			//Boolean rolebmDs = orgManager.hasSpecificRole(id,Long.valueOf(Dept2),"部门领导");
		            		List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(id2,"部门领导");
		            		if(membersByRole != null && membersByRole.size() > 0){
		            			Collections.sort(membersByRole, new Comparator<V3xOrgMember>() {  
	  		            			  
    		                        @Override  
    		                        public int compare(V3xOrgMember o1, V3xOrgMember o2) {
    		                        	if(!StringUtils.isEmpty(o1.getCode()) && !StringUtils.isEmpty(o2.getCode())){
    		                        		
    		                        	
    		                            if (Integer.valueOf(o1.getCode()) > Integer.valueOf(o2.getCode())) {  
    		                                return 1;  
    		                            }  
    		                            if (Integer.valueOf(o1.getCode()) == Integer.valueOf(o2.getCode())) {  
    		                                return 0;  
    		                            }  
    		                            return -1; 
    		                        	}
    		                            return 1; 
    		                        }  
    		                    });  
		              
		                    V3xOrgMember v3xOrgMember = membersByRole.get(0);//获取最小的
		                  
		   	            		 loginName = v3xOrgMember.getLoginName();//员工编码	LOGIN_NAME为登录人员名称
		            		}
	            		
	            		}
	            		
	            	}
	            		/*if(StringUtils.isEmpty(loginName)){
	            			continue;
	            		}*/
	            		
	            		//判断是否是第一个（从0开始）如果是不添加“，”号。
	            		//if(i != 0)
	            			//builder.append(",");
	            		builder.append("{\"Authentication\":{");
	            		builder.append("\"EmployeeID\": \""+EmployeeID+"\"");		//员工编号
	            		builder.append(",\"Name\": \""+Name+"\"");		//用户姓名
	            		builder.append(",\"Dept1\": \""+Dept1+"\"");	//部门1
	            		builder.append(",\"Dept2\": \""+Dept2+"\"");	//部门2
	            		builder.append(",\"Email\": \""+Email+"\"");	//联系邮箱
	            		builder.append(",\"IsSendEMail\": \""+IsSendEMail+"\"");	//是否发送开通邮件默认为false
	            		builder.append(",\"SubAccountName\": \""+subAccount+"\"");	//
	            		builder.append(",\"Valid\": \""+Valid+"\"");	//在职情况
	            		builder.append(",\"RankName\": \""+zhiJi+"\"");	//职级
	            		builder.append(",\"IsBookClass\": \""+IsBookClass+"\"");	//关联信达员工国内机票差标设置，是否可预订高舱等。T:是，F：否。
	            		builder.append(",\"IntlBookClassBlock\": \""+IntlBookClassBlock+"\",");	//
	            		builder.append("\"ConfirmPersonList\":[{\"ProductType\":\"N\",\"AuthorizedTime\":2,\"ConfirmPerson\":\""+loginName+"\",\"ConfirmPersoncc\":\""+loginName+"\",\"IsDefault\":true},{\"ProductType\":\"H\",\"AuthorizedTime\":2,\"ConfirmPerson\":\""+loginName+"\",\"ConfirmPersoncc\":\""+loginName+"\",\"IsDefault\":true}]");
	            		builder.append("}},");
	            		}	   
	            		String Renshiduijie = builder.toString();
	            		if(!StringUtils.isEmpty(Renshiduijie)){
	            			Renshiduijie=Renshiduijie.substring(0, Renshiduijie.length()-1);
	            		}
	    				Map<String,Object> map=new HashMap<String,Object>();
	        	    	map.put("Renshiduijie", Renshiduijie);
	        	    	map.put("xieChengType", xieChengType);
	        	    	//从配置文件中获取要post到中间区的地址
	        	    	String RenShiDuiJie = (String) PropertiesUtils.getInstance().get("RenShiDuiJie");
	        			String responseResult = HttpClientUtil.post(RenShiDuiJie, map);
	        			JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(responseResult);//返回
	        			String jsonJipiao  = jsonObject.optString("message");
	        			log.info("****"+jsonJipiao);
	            	}
	            }
			 
		} catch (BusinessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//return null;
    	
    }
    
}
