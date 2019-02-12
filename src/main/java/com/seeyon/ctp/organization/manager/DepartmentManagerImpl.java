package com.seeyon.ctp.organization.manager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.event.UpdateDeptRoleEvent;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.organization.util.OrgTree;
import com.seeyon.ctp.organization.util.OrgTreeNode;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgDepartment;
import com.seeyon.ctp.portal.api.SpaceApi;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
//客开 赵培珅  20180730 start 
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
public class DepartmentManagerImpl implements DepartmentManager {
	private final static Log logger = LogFactory
			.getLog(DepartmentManagerImpl.class);
	protected OrgCache orgCache;
	protected OrgDao orgDao;
	protected OrgManagerDirect orgManagerDirect;
	protected OrgManager orgManager;
	protected PrincipalManager principalManager;
	protected AppLogManager       appLogManager;
	
	public void setOrgDao(OrgDao orgDao) {
		this.orgDao = orgDao;
	}

	public void setPrincipalManager(PrincipalManager principalManager) {
		this.principalManager = principalManager;
	}

	public void setOrgCache(OrgCache orgCache) {
		this.orgCache = orgCache;
	}

	public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
		this.orgManagerDirect = orgManagerDirect;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
	protected SpaceApi  spaceApi;
    protected SpaceApi getSpaceApi(){
        if(spaceApi == null){
        	spaceApi = (SpaceApi)AppContext.getBean("spaceApi");
        }
        
        return spaceApi;
    }
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public HashMap addDept(String accountId) throws Exception {
		// TODO Auto-generated method stub
		Integer maxSortNum = orgManagerDirect.getMaxSortNum(V3xOrgDepartment.class.getSimpleName(), Long.valueOf(accountId));
		HashMap m = new HashMap();
		m.put("sortId", maxSortNum+1);
		return m;
	}
	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public HashMap addOutDept(String accountId) throws Exception {
		Integer maxSortNum = orgManagerDirect.getMaxOutternalDeptSortNum(Long.parseLong(accountId));
		HashMap m = new HashMap();
		m.put("sortId", maxSortNum+1);
		return m;
	}
	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public HashMap getDepRoles(String accountId) throws Exception {
		List<V3xOrgRole> deproles = orgManager.getAllDepRoles(Long.valueOf(accountId));
		HashMap m = new HashMap();
		m.put("deproles", deproles);
		return m;
	}

	@SuppressWarnings("unchecked")
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
	public Long createDept(String accountId, Map dept) throws Exception {
		User user = AppContext.getCurrentUser();
		Long accId = Long.parseLong(accountId);
		V3xOrgDepartment newdept = new V3xOrgDepartment();
		String parentdeptId = String.valueOf(dept.get("superDepartment"));
		if(parentdeptId!=null&&parentdeptId.contains("|")){
			parentdeptId = parentdeptId.split("\\|")[1];
		}else{
			parentdeptId = String.valueOf(accId);
		}

		ParamUtil.mapToBean(dept, newdept, false);
		newdept.setOrgAccountId(accId);
        //创建部门空间的话，必须选择部门主管
        List<V3xOrgRole> rolelist = orgManager.getAllDepRoles(accId);
        int DepManagerint = 0;
        String depManagerRoleName = "";
        for (int i = 0; i < rolelist.size(); i++) {
            if (OrgConstants.Role_NAME.DepManager.name().equals(rolelist.get(i).getCode())) {
                DepManagerint = i;
                depManagerRoleName = rolelist.get(i).getShowName();
            }
        }
        //A6-s任务项，默认没有部门空间
        Integer productId = SystemProperties.getInstance().getIntegerProperty("system.ProductId");
        if(null != productId && productId.intValue() == ProductEditionEnum.a6s.ordinal()) {
            newdept.setCreateDeptSpace(false);
        } else {
            if (dept.containsKey("createDeptSpace")) {
                if ("true".equals(dept.get("createDeptSpace")) 
                        || Boolean.valueOf(String.valueOf(dept.get("createDeptSpace")))) {
                    if (!dept.containsKey("deptrole" + DepManagerint) || Strings.isBlank(String.valueOf(dept.get("deptrole" + DepManagerint)))) {
                        throw new BusinessException(ResourceUtil.getString("dept.space.mustmanager", depManagerRoleName));
                    }
                    newdept.setCreateDeptSpace(true);
                    newdept.setDepManager(String.valueOf(dept.get("deptrole" + DepManagerint)));
                }else{
                    newdept.setCreateDeptSpace(false);
                }
            }
        }
        if (newdept.getId() == null) {
            //部门排序号的重复处理 新建的部门直接插入
            String isInsert = dept.get("sortIdtype").toString();
            if ("1".equals(isInsert)
                    && orgManagerDirect.isPropertyDuplicated(V3xOrgDepartment.class.getSimpleName(), "sortId", newdept
                            .getSortId(), newdept.getOrgAccountId())) {

                orgManagerDirect.insertRepeatSortNum(V3xOrgDepartment.class.getSimpleName(),
                        accId, newdept.getSortId(), null);
            }
            newdept.setIdIfNew();
            newdept.setSuperior(Long.valueOf(parentdeptId));
            
            dealDeptRole(dept, user, newdept, rolelist);
            
            OrganizationMessage mes = orgManagerDirect.addDepartment(newdept);
            OrgHelper.throwBusinessExceptionTools(mes);
            //记录日志
            if(newdept.getIsInternal()) {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewDept, user.getName(), newdept.getName());
            } else {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewExternalDept, user.getName(), newdept.getName());
            }

        } else {
            
            //外部不需要关心path，只需要传递上级组织的id即可
            //部门排序号的重复处理 修改部门判断自己
            String isInsert = dept.get("sortIdtype").toString();
            if ("1".equals(isInsert)
                    && orgManagerDirect.isPropertyDuplicated(V3xOrgDepartment.class.getSimpleName(), "sortId", newdept
                            .getSortId().longValue(), newdept.getOrgAccountId(), newdept.getId())) {

                orgManagerDirect.insertRepeatSortNum(V3xOrgDepartment.class.getSimpleName(),
                        accId, newdept.getSortId(), null);
            }
            newdept.setSuperior(Long.valueOf(parentdeptId));
            
            dealDeptRole(dept, user, newdept, rolelist);
            
            OrganizationMessage mes = orgManagerDirect.updateDepartment(newdept);
            OrgHelper.throwBusinessExceptionTools(mes);
            //记录日志
            if(newdept.getIsInternal()) {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdateDept, user.getName(), newdept.getName());
            } else {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdateExternalDept, user.getName(), newdept.getName());
            }
            
        }
		//添加或更新部门中的岗位
		if(dept.containsKey("deptpost")){
		    List entlist = orgManager.getEntities(dept.get("deptpost").toString());
		    if(null == entlist) entlist = new ArrayList();
            Set<Long> tempSet = new HashSet<Long>();
            for (Object post : entlist) {
                tempSet.add(((V3xOrgPost)post).getId());
            }
            List<V3xOrgPost> deptPosts = orgManager.getDepartmentPost(newdept.getId());
            for (V3xOrgPost p : deptPosts) {
                if(!tempSet.contains(p.getId())) {
                    List<V3xOrgMember> deptMembers = orgManager.getMembersByDepartmentPost(newdept.getId(), p.getId());
                    if(null != deptMembers && !deptMembers.isEmpty()) {
                        throw new BusinessException(ResourceUtil.getString("department.del.post.member", p.getName()));
                    }
                }
            }
			orgManagerDirect.addDepartmentPost(entlist, newdept.getId());
		}
		
		return newdept.getId();
	}
	
	
	@SuppressWarnings("unchecked")
    @Override
    @AjaxAccess
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
	public String postCheck(Map dept) throws Exception {
		String checkInfo="";
		
		V3xOrgDepartment newdept = new V3xOrgDepartment();
		ParamUtil.mapToBean(dept, newdept, false);
	    if (newdept.getId() == null) {
	    	newdept.setIdIfNew();
	    }

		//添加或更新部门中的岗位
		if(dept.containsKey("deptpost")){
		    List deptlist = orgManager.getEntities(dept.get("deptpost").toString());
		    if(null == deptlist) deptlist = new ArrayList();
		    List<V3xOrgPost> entlist = new UniqueList<V3xOrgPost>(deptlist);
            Set<Long> tempSet = new HashSet<Long>();
            for (Object post : entlist) {
                tempSet.add(((V3xOrgPost)post).getId());
            }
            String canDeletePostName="";
            String canNotDeletePostName="";
            List<V3xOrgPost> deptPosts = orgManager.getDepartmentPost(newdept.getId());
            for (V3xOrgPost p : deptPosts) {
                if(!tempSet.contains(p.getId())) {
                    List<V3xOrgMember> deptMembers = orgManager.getMembersByDepartmentPost(newdept.getId(), p.getId());
                    if(null != deptMembers && !deptMembers.isEmpty()) {
                    	entlist.add(p);
                    	if(Strings.isBlank(canNotDeletePostName)){
                    		canNotDeletePostName = p.getName();
                    	}else{
                    		canNotDeletePostName = canNotDeletePostName +","+p.getName();
                    	}
                    }else{
                    	entlist.remove(p);
                     	if(Strings.isBlank(canDeletePostName)){
                     		canDeletePostName = p.getName();
                    	}else{
                    		canDeletePostName = canDeletePostName +","+p.getName();
                    	}
                    }
                }
            }
            
            //没有信息，或者全都是可以删除的岗位，前台不需要再次确认，直接进行下一步
            if(Strings.isBlank(canDeletePostName)  && Strings.isBlank(canNotDeletePostName)){
            	return null;
            }
            //全都是不能删除的岗位，直接抛异常提示不能删除
            if(Strings.isBlank(canDeletePostName)  && Strings.isNotBlank(canNotDeletePostName)){
            	throw new BusinessException(ResourceUtil.getString("department.del.post.member", canNotDeletePostName));
            }
            
            //即有可以删除的岗位，又有不可以删除的岗位，前台需要再次确认，是否只删除可以删除的岗位。
            if(Strings.isNotBlank(canDeletePostName)  && Strings.isNotBlank(canNotDeletePostName)){
            	 checkInfo = ResourceUtil.getString("department.del.post.member", canNotDeletePostName) + 
            			     ResourceUtil.getString("department.del.post.confirm", canDeletePostName);
            }
		}
		return checkInfo;
	}
	
	@SuppressWarnings("unchecked")
    @Override
    @AjaxAccess
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
	public Long createDeptAfterCheckPost(String accountId, Map dept) throws Exception {
	    Long accId = Long.parseLong(accountId);
		User user = AppContext.getCurrentUser();
		V3xOrgDepartment newdept = new V3xOrgDepartment();
		String parentdeptId = String.valueOf(dept.get("superDepartment"));
		if(parentdeptId!=null&&parentdeptId.contains("|")){
			parentdeptId = parentdeptId.split("\\|")[1];
		}else{
			parentdeptId = String.valueOf(accId);
		}

		ParamUtil.mapToBean(dept, newdept, false);
		newdept.setOrgAccountId(accId);
        //创建部门空间的话，必须选择部门主管
        List<V3xOrgRole> rolelist = orgManager.getAllDepRoles(accId);
        int DepManagerint = 0;

        String depManagerRoleName = "";
        for (int i = 0; i < rolelist.size(); i++) {
            if (OrgConstants.Role_NAME.DepManager.name().equals(rolelist.get(i).getCode())) {
            	depManagerRoleName = rolelist.get(i).getShowName();
                DepManagerint = i;
            }
        }
        //A6-s任务项，默认没有部门空间
        Integer productId = SystemProperties.getInstance().getIntegerProperty("system.ProductId");
        if(null != productId && productId.intValue() == ProductEditionEnum.a6s.ordinal()) {
            newdept.setCreateDeptSpace(false);
        } else {
            if (dept.containsKey("createDeptSpace")) {
                if ("true".equals(dept.get("createDeptSpace")) 
                        || Boolean.valueOf(String.valueOf(dept.get("createDeptSpace")))) {
                    if (!dept.containsKey("deptrole" + DepManagerint) || Strings.isBlank(String.valueOf(dept.get("deptrole" + DepManagerint)))) {
                        throw new BusinessException(ResourceUtil.getString("dept.space.mustmanager", depManagerRoleName));
                    }
                    newdept.setCreateDeptSpace(true);
                    newdept.setDepManager(String.valueOf(dept.get("deptrole" + DepManagerint)));
                }else{
                    newdept.setCreateDeptSpace(false);
                }
            }
        }
        if (newdept.getId() == null) {
            //部门排序号的重复处理 新建的部门直接插入
            String isInsert = dept.get("sortIdtype").toString();
            if ("1".equals(isInsert)
                    && orgManagerDirect.isPropertyDuplicated(V3xOrgDepartment.class.getSimpleName(), "sortId", newdept
                            .getSortId(), newdept.getOrgAccountId())) {

                orgManagerDirect.insertRepeatSortNum(V3xOrgDepartment.class.getSimpleName(),
                        accId, newdept.getSortId(), null);
            }
            newdept.setIdIfNew();
            newdept.setSuperior(Long.valueOf(parentdeptId));
            
            dealDeptRole(dept, user, newdept, rolelist);
            
            OrganizationMessage mes = orgManagerDirect.addDepartment(newdept);
            OrgHelper.throwBusinessExceptionTools(mes);
            //记录日志
            if(newdept.getIsInternal()) {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewDept, user.getName(), newdept.getName());
            } else {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewExternalDept, user.getName(), newdept.getName());
            }

        } else {
            
            //外部不需要关心path，只需要传递上级组织的id即可
            //部门排序号的重复处理 修改部门判断自己
            String isInsert = dept.get("sortIdtype").toString();
            if ("1".equals(isInsert)
                    && orgManagerDirect.isPropertyDuplicated(V3xOrgDepartment.class.getSimpleName(), "sortId", newdept
                            .getSortId().longValue(), newdept.getOrgAccountId(), newdept.getId())) {

                orgManagerDirect.insertRepeatSortNum(V3xOrgDepartment.class.getSimpleName(),
                        accId, newdept.getSortId(), null);
            }
            newdept.setSuperior(Long.valueOf(parentdeptId));
            
            dealDeptRole(dept, user, newdept, rolelist);
            
            OrganizationMessage mes = orgManagerDirect.updateDepartment(newdept);
            OrgHelper.throwBusinessExceptionTools(mes);
            //记录日志
            if(newdept.getIsInternal()) {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdateDept, user.getName(), newdept.getName());
            } else {
                appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdateExternalDept, user.getName(), newdept.getName());
            }
            
        }
		//添加或更新部门中的岗位
		if(dept.containsKey("deptpost")){
		    List entlist = orgManager.getEntities(dept.get("deptpost").toString());
		    if(null == entlist) entlist = new ArrayList();
            Set<Long> tempSet = new HashSet<Long>();
            for (Object post : entlist) {
                tempSet.add(((V3xOrgPost)post).getId());
            }
            List<V3xOrgPost> deptPosts = orgManager.getDepartmentPost(newdept.getId());
            for (V3xOrgPost p : deptPosts) {
                if(!tempSet.contains(p.getId())) {
                    List<V3xOrgMember> deptMembers = orgManager.getMembersByDepartmentPost(newdept.getId(), p.getId());
                    if(null != deptMembers && !deptMembers.isEmpty()) {
                    	entlist.add(p);
                    }else{
                    	entlist.remove(p);
                    }
                }
            }
			orgManagerDirect.addDepartmentPost(entlist, newdept.getId());
		}
		
		return newdept.getId();
	}

    private void dealDeptRole(Map dept, User user, V3xOrgDepartment newdept, List<V3xOrgRole> rolelist)
            throws BusinessException {
        
        List<Map> oldRoleList = new ArrayList<Map>();
        List<Map> newRoleList = new ArrayList<Map>();
        
        //添加或更新部门角色人员
        for (int i = 0; i < rolelist.size(); i++) {
            
            Map<V3xOrgRole, List<V3xOrgMember>> roleOldMembers = new HashMap<V3xOrgRole, List<V3xOrgMember>>();
            Map<V3xOrgRole, List<V3xOrgMember>> roleNewMembers = new HashMap<V3xOrgRole, List<V3xOrgMember>>();
            
            List<V3xOrgMember> members = new ArrayList<V3xOrgMember>();
            String membersstr = null;
            if (dept.containsKey("deptrole" + i) && dept.get("deptrole" + i) != null
                    && !"".equals(dept.get("deptrole" + i))) {
                membersstr = (dept.get("deptrole" + i).toString());
            }
            V3xOrgDepartment department = orgManager.getDepartmentById(newdept.getId());
            if (membersstr != null) {
            	members = orgManagerDirect.getmembersByEntity(membersstr);
            }
            //如果这个部门某个角色人员没有发生任何变化，则对角色信息不做任何操作，直接跳过。
            List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(newdept.getId(), rolelist.get(i).getId());
            if(Strings.isNotEmpty(members) && Strings.isNotEmpty(membersByRole)){	
            	boolean isEquals = false;
            	if(members.size()==membersByRole.size()){
            		for(int j=0;j<members.size();j++){
            			if(!members.get(j).getId().equals(membersByRole.get(j).getId())){
            				break;
            			}
            			if(j+1 == members.size()){
            				isEquals = true;
            			}
            		}
            	}
            	if(isEquals){
            		continue;
            	}
            }else if(Strings.isEmpty(members) && Strings.isEmpty(membersByRole)){
            	continue;
            }
            
            if(null != department) {
                roleOldMembers.put(rolelist.get(i), membersByRole);
                oldRoleList.add(roleOldMembers);
                orgManagerDirect.deleteRole2Entity(rolelist.get(i).getId(), newdept.getId(), members);
            }
            
			String oldRoleMembers = "";
			for(V3xOrgMember entity : membersByRole){
				if (null == entity || !entity.isValid()) {
					continue;
				}
				if(Strings.isBlank(oldRoleMembers)){
					oldRoleMembers = entity.getName();
				}else{
					oldRoleMembers = oldRoleMembers+","+entity.getName();
				}
			}
			 String newRoleMembers="";
            if (membersstr != null) {
                //记录日志  
                roleNewMembers.put(rolelist.get(i), members);
                newRoleList.add(roleNewMembers);
                List<V3xOrgEntity> entities = new ArrayList<V3xOrgEntity>();
                for (V3xOrgEntity v3xOrgEntity : members) {
                    entities.add(v3xOrgEntity);
                	if(Strings.isBlank(newRoleMembers)){
						newRoleMembers = v3xOrgEntity.getName();
					}else{
						newRoleMembers = newRoleMembers+","+v3xOrgEntity.getName();
					}
                }
                orgManagerDirect.addRole2Entities(rolelist.get(i).getId(), newdept.getOrgAccountId(), entities, newdept.getId());
            }
            
            if(user != null){
            	appLogManager.insertLog4Account(user, rolelist.get(i).getOrgAccountId(), AppLogAction.Organization_RoleToMember,  user.getName(),rolelist.get(i).getShowName(),oldRoleMembers,newRoleMembers);
            }
        }
        //触发事件 为肖霖增加部门角色修改监听事件
        UpdateDeptRoleEvent event = new UpdateDeptRoleEvent(this);
        event.setDepartment(newdept);
        event.setOldRoleList(oldRoleList);
        event.setNewRoleList(newRoleList);
        EventDispatcher.fireEvent(event);
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
    public String deleteDept(Map dept) throws Exception {
        V3xOrgDepartment deldept = orgManager.getDepartmentById(Long.valueOf(dept.get("id").toString()));
        List<V3xOrgDepartment> childs = orgManager.getChildDepartments(deldept.getId(), false, true);
        OrganizationMessage mes = orgManagerDirect.deleteDepartment(deldept);
        OrgHelper.throwBusinessExceptionTools(mes);
        //日志信息       
        User user = AppContext.getCurrentUser();
        List<String[]> appLogs = new ArrayList<String[]>(1);
        String[] appLog = new String[3];
        appLog[0] = user.getName();
        appLog[1] = deldept.getName();
        String childrenDeptNames = "";
        if(Strings.isNotEmpty(childs)){
        	for(V3xOrgDepartment child : childs){
        		if(Strings.isBlank(childrenDeptNames)){
        			childrenDeptNames = child.getName();
        		}else{
        			childrenDeptNames =childrenDeptNames+","+child.getName();
        		}
        	}
        }
        appLog[2] = childrenDeptNames;
        appLogs.add(appLog);
        //记录日志
        if(Strings.isBlank(childrenDeptNames)){
        	appLogManager.insertLogs4Account(user, deldept.getOrgAccountId(), AppLogAction.Organization_DeleteDept, appLogs);
        }else{
        	appLogManager.insertLogs4Account(user, deldept.getOrgAccountId(), AppLogAction.Organization_DeleteDepts, appLogs);
        }
        return "";
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public String deleteDepts(List<Map<String, Object>> depts) throws Exception {
        User user = AppContext.getCurrentUser();
        List<V3xOrgDepartment> deptlist = new ArrayList<V3xOrgDepartment>();
        List<OrgUnit> mapsToBeans = ParamUtil.mapsToBeans(depts, OrgUnit.class, false);
        Map<Long,List<String[]>> appsLogMap = new HashMap<Long, List<String[]>>();
        for (OrgUnit orgUnit : mapsToBeans) {
        	deptlist.add((V3xOrgDepartment)OrgHelper.poTobo(orgUnit));
        	
        	List<V3xOrgDepartment> childs = orgManager.getChildDepartments(orgUnit.getId(), false, true);
            String childrenDeptNames = "";
            if(Strings.isNotEmpty(childs)){
            	for(V3xOrgDepartment child : childs){
            		if(Strings.isBlank(childrenDeptNames)){
            			childrenDeptNames = child.getName();
            		}else{
            			childrenDeptNames =childrenDeptNames+","+child.getName();
            		}
            	}
            }else{
            	continue;
            }
            String[] appLog = new String[3];
            appLog[0] = user.getName();
            appLog[1] = orgUnit.getName();
            appLog[2] = childrenDeptNames;
            List<String[]> appLogs = new ArrayList<String[]>(1);
            appLogs.add(appLog);
            appsLogMap.put(orgUnit.getId(), appLogs);
		}
        OrgHelper.throwBusinessExceptionTools(orgManagerDirect.deleteDepartments(deptlist));
        //日志信息         
        for (V3xOrgDepartment d : deptlist) {
            if (d.getIsInternal()) {
                if(appsLogMap.get(d.getId())==null){
                	appLogManager.insertLog4Account(user, d.getOrgAccountId(), AppLogAction.Organization_DeleteDept, user.getName(), d.getName());
                }else{
                	appLogManager.insertLogs4Account(user, d.getOrgAccountId(), AppLogAction.Organization_DeleteDepts, appsLogMap.get(d.getId()));
                }
            } else {
                appLogManager.insertLog4Account(user,d.getOrgAccountId(), AppLogAction.Organization_DeleteExternalDept, user.getName(), d.getName());
            }
        }
        return "";
    }

    @SuppressWarnings("unchecked")
	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
    public HashMap viewDept(Long deptId) throws Exception {
    	
        HashMap map = new HashMap();
        V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
        ParamUtil.beanToMap(dept, map, false);
        
        map.put("superDepartment", OrgHelper.getSelectPeopleStr(orgManager.getParentUnit(dept)));
        //map.put("pname", orgManager.getParentUnit(dept).getName());
        List list = new ArrayList<V3xOrgPost>();
        List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Department_Post, dept.getId(), null, null);
        for (V3xOrgRelationship orgRelationship : rellist) {
            V3xOrgPost post = orgManager.getPostById(orgRelationship.getObjective0Id());
            if(null == post) {
                continue;
            }
            list.add(post);
        }
        String selstr = OrgHelper.getSelectPeopleStr(list);
        map.put("deptpost", selstr);
        //显示部门角色
        List<V3xOrgRole> rolelist = orgManager.getAllDepRoles(dept.getOrgAccountId());
        
        for (int i = 0; i < rolelist.size(); i++) {
            List memberlist = orgManager.getMembersByRole(deptId, rolelist.get(i).getId());
            map.put("deptrole" + i, OrgHelper.getSelectPeopleStr(memberlist));

        }
        map.put("deptLevel", orgManager.getDeptLevel(deptId));
        map.put("createDeptSpace", String.valueOf(getSpaceApi().isCreateDepartmentSpace(deptId)));
        return map;
    }
	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
	public List showDepartmentTree(Map params) throws Exception {
	    Long accId = Long.parseLong(params.get("accountId").toString());
		V3xOrgAccount account = orgManager.getAccountById(accId);

		List<V3xOrgDepartment> deptlist = new ArrayList<V3xOrgDepartment>();
		List<V3xOrgDepartment> list = orgManagerDirect.getAllDepartments(account.getId(), true, true, null, null, null);
		
        OrgTree orgTree = OrgHelper.getTree(list, accId);
        OrgTreeNode accountNode = orgTree.getRoot();
		
		for (V3xOrgEntity deptEnt : list) {
			//V3xOrgDepartment dept = (V3xOrgDepartment) deptEnt;
			V3xOrgDepartment dept = orgManager.getDepartmentById(deptEnt.getId());
			deptlist.add(dept);
		}
		Collections.sort(deptlist, CompareSortEntity.getInstance());
		List resultlist = new ArrayList();
		for (int i = 0; i < deptlist.size(); i++) {
			V3xOrgDepartment dept = (V3xOrgDepartment) deptlist.get(i);
			if(!dept.getIsInternal()) continue;//单位管理员不展现外部部门
			if (null == dept.getSuperior() || dept.getSuperior() == -1) continue;//防护
			//OA-11514 //TODO 国际化
			StringBuffer deptShowName = new StringBuffer();
			deptShowName.append(dept.getName());
			if(OrgConstants.ORGENT_STATUS.DISABLED.ordinal() == dept.getStatus()) {
			    deptShowName.append("("+ ResourceUtil.getString("org.entity.disabled") +")");//申请停用
			} else if(OrgConstants.ORGENT_STATUS.DELETED.ordinal() == dept.getStatus()) {
			    deptShowName.append("("+ ResourceUtil.getString("org.entity.deleted") +")");//申请删除
			}
			
			WebV3xOrgDepartment webdept = new WebV3xOrgDepartment(dept.getId(),
			        deptShowName.toString(), dept.getSuperior());
			webdept.setV3xOrgDepartment(dept);
			
			webdept.setIconSkin("department");
            List<Long> childrenDepts = this.orgCache.getSubDeptList(dept.getId(),orgCache.SUBDEPT_INNER_FIRST);
            if(Strings.isNotEmpty(childrenDepts)){
            	webdept.setIconSkin("treeDepartment");
            }
/*			OrgTreeNode deptNode= OrgTree.getOrgTreeNodeById(accountNode, dept.getPath());
			if(!deptNode.isLeaf()) {
			    webdept.setIconSkin("treeDepartment");
			}*/
			
			resultlist.add(webdept);
		}

		WebV3xOrgAccount webrootaccount = new WebV3xOrgAccount(account.getId(),
				account.getName(), account.getId());
		webrootaccount.setIconSkin("treeAccount");
		resultlist.add(webrootaccount);
		return resultlist;
	}

	@Override
	//客开 赵培珅  20180730 start 
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
	public FlipInfo showDepList(FlipInfo fi, Map params)
			throws BusinessException {
		//SZP
		Long accountId = AppContext.currentAccountId();
		if (params.get("accountId") != null){
			accountId = Long.parseLong(params.get("accountId").toString());
		}
		
	    //Long accountId = Long.parseLong(params.get("accountId").toString());
		//PZS
		if(params.size()==1||params.get("value")==null||"".equals(params.get("value"))||"[, ]".equals(params.get("value").toString())||"[\"\",\"\"]".equals(params.get("value").toString())){
			orgManagerDirect.getAllDepartments(accountId, null, true, null, null, fi);			
		}else{
			orgManagerDirect.getAllDepartments(accountId, null, true,String.valueOf(params.get("condition")), getSelectPeopleSerchStr(params), fi);
		}
		
		List list = fi.getData();
		List rellist = new ArrayList();
		for (Object object : list) {
			HashMap m = new HashMap();
			OrgUnit dept = (OrgUnit)object;
			ParamUtil.beanToMap(dept, m, true);
			V3xOrgUnit punit = orgManager.getParentUnit(orgManager.getDepartmentById(Long.valueOf(m.get("id").toString())));
			//V3xOrgDepartment pdept = orgManager.getDepartmentByPath(orgManager.getDepartmentById(Long.valueOf(m.get("id").toString())).getParentPath());
			//V3xOrgAccount pacc = orgManager.getac(orgManager.getDepartmentById(Long.valueOf(m.get("id").toString())).getParentPath());
			if(punit!=null){
				m.put("superDepartment", punit.getName());
			}else{
				m.put("superDepartment", "");
			}
			m.put("DepManager", "");
			EnumMap<RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                    RelationshipObjectiveName.class);
            objectiveIds.put(RelationshipObjectiveName.objective0Id,dept.getId());
            objectiveIds.put(RelationshipObjectiveName.objective5Id,OrgConstants.ORGENT_TYPE.Member.name());
			List<V3xOrgRelationship> reflist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Role, null, null, objectiveIds);
			for (V3xOrgRelationship v3xOrgRelationship : reflist) {
				if(orgManager.getRoleById(v3xOrgRelationship.getObjective1Id()).getName().equals(OrgConstants.Role_NAME.DepManager.name())){
					m.put("DepManager", m.get("DepManager")+orgManager.getMemberById(v3xOrgRelationship.getSourceId()).getName()+",");
				}
			}
			if(String.valueOf(m.get("DepManager")).lastIndexOf(",")!=-1&&String.valueOf(m.get("DepManager")).lastIndexOf(",")==String.valueOf(m.get("DepManager")).length()-1){
				m.put("DepManager", String.valueOf(m.get("DepManager")).substring(0, String.valueOf(m.get("DepManager")).length()-1));
			}
			rellist.add(m);
			
		}
		fi.setData(rellist);
		return fi;
	}

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
    public FlipInfo showDepList4Ext(FlipInfo fi, Map params) throws BusinessException {
        Long accountId = Long.parseLong(params.get("accountId").toString());
        orgManagerDirect.getAllDepartments(accountId, null, false, null, null, fi);
        List list = fi.getData();
        List rellist = new ArrayList();
        for (Object object : list) {
            HashMap m = new HashMap();
            ParamUtil.beanToMap((OrgUnit) object, m, true);
            V3xOrgUnit punit = orgManager.getParentUnit(orgManager.getDepartmentById(Long.valueOf(m.get("id")
                    .toString())));
            //V3xOrgDepartment pdept = orgManager.getDepartmentByPath(orgManager.getDepartmentById(Long.valueOf(m.get("id").toString())).getParentPath());
            //V3xOrgAccount pacc = orgManager.getac(orgManager.getDepartmentById(Long.valueOf(m.get("id").toString())).getParentPath());
            if (punit != null) {
                m.put("superDepartment", punit.getName());
            } else {
                m.put("superDepartment", "");
            }

            rellist.add(m);

        }
        fi.setData(rellist);
        return fi;
    }
	
    private Object getSelectPeopleSerchStr(Map params) throws BusinessException{
        String condition = String.valueOf(params.get("condition"));
        if("path".equals(condition)) {//这种情况是从选人界面选过来的
        	List<String> strs = (List<String>) params.get("value");
            return ((V3xOrgUnit)orgManager.getEntities(strs.get(1).trim()).get(0)).getPath()+"0";
        } else {
            return String.valueOf(params.get("value"));
        }
    }
	
   
    /**
     * @param dept
     * @param newdept
     * @param rolelist
     * @return
     * @throws BusinessException
     */
    @Override
    public String dealDeptRole(Map dept,V3xOrgDepartment newdept, List<V3xOrgRole> rolelist)
            throws BusinessException {
        User user = AppContext.getCurrentUser();
        
        this.dealDeptRole(dept, user, newdept, rolelist);
        return null;
    }
}
