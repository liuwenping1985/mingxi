/**
 * $Author: sunzhemin $
 * $Rev: 50775 $
 * $Date:: 2015-07-16 09:03:13#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
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
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.enums.RoleTypeEnum;
import com.seeyon.ctp.organization.event.UpdateDeptRoleEvent;
import com.seeyon.ctp.organization.po.OrgRelationship;
import com.seeyon.ctp.organization.po.OrgRole;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.privilege.bo.PrivTreeNodeBO;
import com.seeyon.ctp.privilege.dao.RoleMenuDao;
import com.seeyon.ctp.privilege.manager.MenuCacheManager;
import com.seeyon.ctp.privilege.manager.PrivilegeManager;
import com.seeyon.ctp.privilege.manager.PrivilegeMenuManager;
import com.seeyon.ctp.privilege.po.PrivRoleMenu;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator})
public class RoleManagerImpl implements RoleManager {

    private final static Log   log = LogFactory.getLog(RoleManagerImpl.class);

    protected AppLogManager       appLogManager;

    private MenuCacheManager menuCacheManager;

    /** */
    protected PrivilegeMenuManager      privilegeMenuManager;

    /** */
    protected OrgCache         orgCache;

    /** */
    protected OrgDao           orgDao;



    /** */
    protected OrgManager       orgManager;



	protected OrgManagerDirect orgManagerDirect;

    protected PrivilegeManager privilegeManager;

    /** */
    protected RoleMenuDao  roleMenuDao;

    protected SystemConfig  systemConfig;
    @Override
    public void batchRole2Entity(Long roleId, String entityIds) throws BusinessException {
        User user = AppContext.getCurrentUser();
        String dept = null;
        List<Map> oldRoleList = new ArrayList<Map>();
        Map<V3xOrgRole, List<V3xOrgMember>> roleOldMembers = new HashMap<V3xOrgRole, List<V3xOrgMember>>();

        V3xOrgRole role = orgManager.getRoleById(roleId);
        //if(Strings.isBlank(entityIds)) return;
        if (entityIds.contains("^")) {
            String[] es = entityIds.split("\\^");
            dept = es[1];
            entityIds = es[0];
        }
        String[] m1 = entityIds.split(",");
        List<V3xOrgMember> getmembersByEntity = new ArrayList<V3xOrgMember>();
        getmembersByEntity.addAll(orgManagerDirect.getmembersByEntity(entityIds));

        V3xOrgDepartment deptvo = null;
        if (null != dept) {
            deptvo = (V3xOrgDepartment) orgManager.getDepartmentById(Long.valueOf(dept));
            List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(deptvo.getId(), roleId);
            roleOldMembers.put(role, membersByRole);
            oldRoleList.add(roleOldMembers);
        }

        List<V3xOrgEntity> oldEntitys = new ArrayList<V3xOrgEntity>();
        if(role.getBond()==OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() && deptvo!=null){
        	oldEntitys = orgManager.getEntitysByRole(deptvo.getId(), roleId);
        }else{
        	oldEntitys = orgManager.getEntitysByRole(role.getOrgAccountId(), roleId);
        }
        String oldRoleMembers = "";
        for(V3xOrgEntity entity : oldEntitys){
        	if (null == entity || !entity.isValid()) {
        		continue;
        	}
        	if(Strings.isBlank(oldRoleMembers)){
        		oldRoleMembers = entity.getName();
        	}else{
        		oldRoleMembers = oldRoleMembers+","+entity.getName();
        	}
        }
        
        String newRoleMembers = "";
        List<V3xOrgEntity> entities = new ArrayList<V3xOrgEntity>();
        for (String s : m1) {
        	V3xOrgEntity entity = orgManager.getEntity(s);
        	if (null == entity || !entity.isValid()) {
        		continue;
        	}
        	entities.add(entity);
        	if(Strings.isBlank(newRoleMembers)){
        		newRoleMembers = entity.getName();
        	}else{
        		newRoleMembers = newRoleMembers+","+entity.getName();
        	}
        }
        //修改前后角色没有变化，不做改动。
        if(CollectionUtils.isEqualCollection(oldEntitys, entities)){
        	return;
        }
        privilegeMenuManager.updateMemberMenuLastDateByRoleId(roleId, role.getOrgAccountId(),getmembersByEntity);

        if (null == deptvo) {
            orgManagerDirect.deleteRole2Entity(roleId, role.getOrgAccountId(), getmembersByEntity);
        } else {
            orgManagerDirect.deleteRole2Entity(roleId, deptvo.getId(), getmembersByEntity);
        }
        Long deptId = null == deptvo ? null : deptvo.getId();
        orgManagerDirect.addRole2Entities(roleId, role.getOrgAccountId(), entities, deptId);
        
        //触发事件 为肖霖增加部门角色修改监听事件
        if(deptvo!=null){
        	List<Map> newRoleList = new ArrayList<Map>();
            Map<V3xOrgRole, List<V3xOrgMember>> roleNewMembers = new HashMap<V3xOrgRole, List<V3xOrgMember>>();
            List<V3xOrgMember> membersByRole = orgManager.getMembersByRole(deptvo.getId(), roleId);
            roleNewMembers.put(role, membersByRole);
            newRoleList.add(roleNewMembers);
            
        	UpdateDeptRoleEvent event = new UpdateDeptRoleEvent(this);
        	event.setDepartment(deptvo);
        	event.setOldRoleList(oldRoleList);
        	event.setNewRoleList(newRoleList);
        	EventDispatcher.fireEvent(event);
        }
        
        //日志
        if(user != null){
            appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_RoleToMember,  user.getName(),role.getShowName(),oldRoleMembers,newRoleMembers);
        }else{
            log.info("同步"+AppLogAction.Organization_RoleToMember+",roleId:"+roleId+",deptId:"+deptId);
        }
    }

    @Override
    public void batchRole2EntityToEntAccount(Long roleId, String entityIds) throws BusinessException {
    	 User user = AppContext.getCurrentUser();
     	String dept = null;
     	//if(Strings.isBlank(entityIds)) return;
     	if(entityIds.contains("^")){
     		String[] es = entityIds.split("\\^");
     		dept = es[1];
     		entityIds =es[0];
     	}

         V3xOrgDepartment deptvo = null;
         if (null != dept) {
             deptvo = (V3xOrgDepartment) orgManager.getDepartmentById(Long.valueOf(dept));
         }
         
         V3xOrgRole role = orgManager.getRoleById(roleId);
         List<V3xOrgEntity> oldEntitys = orgManager.getEntitysByRole(role.getOrgAccountId(), roleId);
         String oldRoleMembers = "";
         for(V3xOrgEntity entity : oldEntitys){
             if (null == entity || !entity.isValid()) {
                 continue;
             }
         	if(Strings.isBlank(oldRoleMembers)){
         		oldRoleMembers = entity.getName();
         	}else{
         		oldRoleMembers = oldRoleMembers+","+entity.getName();
         	}
         }
         
         if (null == deptvo) {
             orgManagerDirect.deleteRole2Entity(roleId, null,null);
         } else {
             orgManagerDirect.deleteRole2Entity(roleId, deptvo.getId(),null);
         }
         String newRoleMembers = "";
         String[] m1 = entityIds.split(",");
         for (String s : m1) {
             V3xOrgEntity entity = orgManager.getEntity(s);
             if (null == entity) {
                 continue;
             }
             
         	if(Strings.isBlank(newRoleMembers)){
        		newRoleMembers = entity.getName();
        	}else{
        		newRoleMembers = newRoleMembers+","+entity.getName();
        	}
             orgManagerDirect.addRole2Entity(roleId, role.getOrgAccountId(), entity,deptvo);
         }
         
         appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_RoleToMember, user.getName(), role.getShowName(),oldRoleMembers,newRoleMembers);
    }

    @Override
    public void batchRole2Member(String roleName, Long accountId, String memberIds) throws BusinessException {
        User user = AppContext.getCurrentUser();
        V3xOrgRole role = orgManager.getRoleByName(roleName, accountId);
        if(null == role) return;
        Long id = role.getId();
        
        List<V3xOrgEntity> oldEntitys = orgManager.getEntitysByRole(role.getOrgAccountId(), id);
        String oldRoleMembers = "";
        for(V3xOrgEntity entity : oldEntitys){
            if (null == entity || !entity.isValid()) {
                continue;
            }
        	if(Strings.isBlank(oldRoleMembers)){
        		oldRoleMembers = entity.getName();
        	}else{
        		oldRoleMembers = oldRoleMembers+","+entity.getName();
        	}
        }
        
        String newRoleMembers = "";
		//orgManagerDirect.deleteRole2Entity(id, null);
        String[] m1 = memberIds.split(",");
        for (String s : m1) {
        	V3xOrgEntity entity;
        	if(s.contains("|")){
        		entity = orgManager.getEntity(s);
        	}else{
        		entity = orgManager.getEntityById(V3xOrgMember.class, Long.valueOf(s));
        	}
        	
         	if(Strings.isBlank(newRoleMembers)){
        		newRoleMembers = entity.getName();
        	}else{
        		newRoleMembers = newRoleMembers+","+entity.getName();
        	}

            orgManagerDirect.addRole2Entity(id, accountId, entity);
        }
        appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_RoleToMember, user.getName(),role.getShowName(),oldRoleMembers,newRoleMembers);
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    public boolean checkDulipCode(V3xOrgRole role) {
        boolean result = false;
        Map param = new HashMap();
        param.put("codeEqule", role.getCode().trim());
        List<OrgRole> list = orgDao.getAllRolePO(role.getOrgAccountId(), null, param, null);
        if (list != null && list.size() > 0) {
        	if(!list.get(0).getId().equals(role.getId())){
        		result = true;
        	}

        }
        return result;
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    public boolean checkDulipName(V3xOrgRole role) {
        boolean result = false;
        Map param = new HashMap();
        String roleName = role.getName().trim();
        param.put("name", processRoleName(roleName, role.getOrgAccountId()));
        List<OrgRole> list = orgDao.getAllRolePO(role.getOrgAccountId(), null, param, null);
        List<V3xOrgRelationship> rellist = new ArrayList<V3xOrgRelationship>();
        if(role.getOrgAccountId().equals(OrgConstants.GROUPID)){
            EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
            enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
            rellist = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, (Long)null, null, enummap);
        }
        Set<Long> roleSet = new HashSet<Long>();
        if(rellist!=null){
            for(V3xOrgRelationship r : rellist){
                roleSet.add(r.getSourceId());
            }
        }
        if (list != null && list.size() > 0) {
            for(OrgRole r : list){
                V3xOrgRole vo = new V3xOrgRole(r);
                if(!r.getId().equals(role.getId()) && !roleSet.contains(r.getId()) && (roleName.equals(vo.getShowName()))){
                    result = true;
                    break;
                }
            }

        }
        return result;
    }
    @SuppressWarnings("unchecked")
    @Override
    public boolean checkDulipSortId(int sortId) {
        boolean result = false;
        Long accountId = AppContext.getCurrentUser().getAccountId();
        @SuppressWarnings("rawtypes")
        Map param = new HashMap();
        param.put("sortId", sortId);
        List<OrgRole> list = orgDao.getAllRolePO(accountId, null, param, null);
        if (list != null && list.size() > 0) {
            result = true;
        }
        return result;
    }
    @Override
    public String checkOnlyOneRole(Long roleId, String memberList,Long deptId) throws BusinessException {
        if(!AppContext.hasPlugin("didicar")){
            return null;
        }
        if(StringUtils.isBlank(memberList)){
            return null;
        }
        V3xOrgRole role = orgManager.getRoleById(roleId);
        if(role!=null){
            for (String m : memberList.split(",")) {
                if(OrgConstants.Role_NAME.DepartmentSpecialTrainAdmin.name().equals(role.getName())){
                    EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(
                            RelationshipObjectiveName.class);
                    enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, role.getId());
                    String memberS = m;
                    if(m.indexOf("|")!=-1){
                        memberS=m.split("[|]")[1];
                    }
                    Long memberId = NumberUtils.toLong(memberS);
                    List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(
                            OrgConstants.RelationshipType.Member_Role, memberId, role.getOrgAccountId(), enummap);
                    if (CollectionUtils.isNotEmpty(rels)) {
                        if(rels.size()>1||rels.get(0).getObjective0Id().longValue()!=deptId){
                            return ResourceUtil.getString("didicar.plugin.deptspecialmanager.onlyone", orgManager.getMemberById(memberId).getName());
                        }
                    }
                }
            }
        }
        return null;
    }
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public void copyrole(List<Map<String, Object>> rolelistmap, String type)
			throws BusinessException {
		List<V3xOrgRole> rolelist = ParamUtil.mapsToBeans(rolelistmap,
				V3xOrgRole.class, false);
		// 复制人员

		//日志
		User user = AppContext.getCurrentUser();
		for (V3xOrgRole inv3xOrgRole : rolelist) {
			V3xOrgRole newv3xOrgRole = new V3xOrgRole();
			V3xOrgRole oldv3xOrgRole = orgManager.getRoleById(inv3xOrgRole
					.getId());
			// 添加角色
			int sortId = getMaxSortId(oldv3xOrgRole.getOrgAccountId());
			newv3xOrgRole.setIdIfNew();
			newv3xOrgRole.setName(oldv3xOrgRole.getShowName()+"copy"+sortId);
			newv3xOrgRole.setBond(oldv3xOrgRole.getBond());
			newv3xOrgRole.setCategory(oldv3xOrgRole.getCategory());
			newv3xOrgRole.setCode(oldv3xOrgRole.getCode()+sortId);
			newv3xOrgRole.setDescription(oldv3xOrgRole.getDescription());
			newv3xOrgRole.setEnabled(oldv3xOrgRole.getEnabled());
			newv3xOrgRole.setIsBenchmark(false);
			newv3xOrgRole.setIsDeleted(oldv3xOrgRole.getIsDeleted());
			newv3xOrgRole.setOrgAccountId(oldv3xOrgRole.getOrgAccountId());
			newv3xOrgRole.setSortId(Long.valueOf(sortId));
			newv3xOrgRole.setStatus(oldv3xOrgRole.getStatus());
			// 复制的都为自建角色
			newv3xOrgRole.setType(3);
			orgManagerDirect.addRole(newv3xOrgRole);
			//日志
			appLogManager.insertLog4Account(user, newv3xOrgRole.getOrgAccountId(), AppLogAction.Organization_CopyRoles, user.getName(), newv3xOrgRole.getShowName());
			//集团基准角色同步
			if(orgManager.getAccountById(newv3xOrgRole.getOrgAccountId()).isGroup()){
				SycGroupRoleAdd(newv3xOrgRole);
			}

			if (type.contains("1")) {
				// 添加人员-角色关系
				EnumMap<RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
						RelationshipObjectiveName.class);
				objectiveIds.put(RelationshipObjectiveName.objective1Id,
						oldv3xOrgRole.getId());
				List<OrgRelationship> reslist = orgDao.getOrgRelationshipPO(
						OrgConstants.RelationshipType.Member_Role, null,
						oldv3xOrgRole.getOrgAccountId(), objectiveIds, null);

				List<OrgRelationship> list = new ArrayList<OrgRelationship>();
				for (OrgRelationship orgRelationship : reslist) {
					OrgRelationship newrel = new OrgRelationship();
					newrel.setIdIfNew();
					newrel.setSourceId(orgRelationship.getSourceId());
					newrel.setObjective1Id(newv3xOrgRole.getId());
					newrel.setObjective0Id(orgRelationship.getObjective0Id());
					newrel.setObjective2Id(orgRelationship.getObjective2Id());
					newrel.setObjective3Id(orgRelationship.getObjective3Id());
					newrel.setObjective4Id(orgRelationship.getObjective4Id());
					newrel.setObjective5Id(orgRelationship.getObjective5Id());
					newrel.setOrgAccountId(orgRelationship.getOrgAccountId());
					newrel.setSortId(orgRelationship.getSortId());
					newrel.setType(orgRelationship.getType());
					list.add(newrel);

				}
				orgDao.insertOrgRelationship(list);
			}
			if(type.contains("2")) {

				// 添加资源-角色关系
				PrivRoleMenu privRoleReource = new PrivRoleMenu();
				privRoleReource.setRoleid(oldv3xOrgRole.getId());
				List<PrivRoleMenu> oldlist = roleMenuDao
						.selectList(privRoleReource);

				List<PrivRoleMenu> newlist = new ArrayList<PrivRoleMenu>();
				for (PrivRoleMenu privRoleMenu : oldlist) {
				    //不可勾选的资源，不能复制过去
					/*权限修改，付涛后期修改 */
//                    if(resourceManager.findById(privRoleMenu.getResourceid())!=null){
//                        if(resourceManager.findById(privRoleMenu.getResourceid()).getExt5()!=null&&
//                                resourceManager.findById(privRoleMenu.getResourceid()).getExt5().intValue()==0){
//                                continue;
//                        }
//                    }
					PrivRoleMenu newprivRoleReource = new PrivRoleMenu();
					newprivRoleReource.setIdIfNew();
					newprivRoleReource.setMenuid(privRoleMenu.getMenuid());
					newprivRoleReource.setModifiable(privRoleMenu
							.getModifiable());
					newprivRoleReource.setResourceid(privRoleMenu
							.getResourceid());
					newprivRoleReource.setRoleid(newv3xOrgRole.getId());
					newlist.add(newprivRoleReource);


				}
				roleMenuDao.insertRoleMenuPatchAll(newlist);
				//如果是集团基准角色，更新各单位的关系
				if(orgManager.getAccountById(newv3xOrgRole.getOrgAccountId()).isGroup()){
					EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
		            enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, newv3xOrgRole.getId());
		            List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
		            	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
		        		List<PrivRoleMenu> accroleReources = new ArrayList<PrivRoleMenu>();
		        		//accroleReources.addAll(roleReources);
		        		for (PrivRoleMenu privRoleResource : newlist) {
						    //不可勾选的资源，不能复制过去
		        			/*权限修改，付涛后期修改 */
//                            if(resourceManager.findById(privRoleResource.getResourceid())!=null){
//                                if(resourceManager.findById(privRoleResource.getResourceid()).getExt5()!=null&&
//                                        resourceManager.findById(privRoleResource.getResourceid()).getExt5().intValue()==0){
//                                    continue;
//                                }
//                            }
		        			PrivRoleMenu accprivRoleResource = new PrivRoleMenu();
		        			accprivRoleResource.setRoleid(v3xOrgRelationship.getSourceId());
		        			accprivRoleResource.setId(UUIDLong.longUUID());
		        			accprivRoleResource.setMenuid(privRoleResource.getMenuid());
		        			accprivRoleResource.setModifiable(privRoleResource.getModifiable());
		        			accprivRoleResource.setResourceid(privRoleResource.getResourceid());
		        			accroleReources.add(accprivRoleResource);
						}
		        		roleMenuDao.insertRoleMenuPatchAll(accroleReources);
		        	}
		        }

			}


		}

	}
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public Long createRole(V3xOrgRole role) throws BusinessException {

        Long result = -1l;
        //判断角色名称是否重复
        if(checkDulipName(role)){
            throw new BusinessException(ResourceUtil.getString("role.repeat.name")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
        }
        //判断角色编码是否重复
        if(checkDulipCode(role)){
        	throw new BusinessException(ResourceUtil.getString("role.repeat")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
        }
        //判断外部人员角色不能前台授权为否
        if(OrgConstants.Role_NAME.ExternalStaff.name().equals(role.getCode()) && "0".equals(role.getCategory())){
        	throw new BusinessException(ResourceUtil.getString("role.defultandnopriv.no"));
        }
        if (role != null) {
            List<OrgRole> orgRolePO = new ArrayList<OrgRole>();
            OrgRole roleNew = (OrgRole) role.toPO();
            roleNew.setIdIfNew();
            orgRolePO.add(roleNew);
            orgDao.insertOrgRole(orgRolePO);
            result = roleNew.getId();
            //集团基准角色
            if(orgManager.getAccountById(role.getOrgAccountId()).isGroup()){
            	SycGroupRoleAdd((V3xOrgRole)OrgHelper.poTobo(roleNew));
            }
        }

        //应用日志
        User user = AppContext.getCurrentUser();
        if(null != user) {
            appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_NewRole, user.getName(), role.getName());
        }

        return result;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void defultRole(Long roles) throws BusinessException {
    	V3xOrgRole role = orgManager.getRoleById(roles);
    	User user = AppContext.getCurrentUser();
    	List<String[]> appLogs = new ArrayList<String[]>();
    	@SuppressWarnings("unchecked")
        List<V3xOrgRole> list = (List<V3xOrgRole>) OrgHelper.listPoTolistBo(orgDao.getAllRolePO(role.getOrgAccountId(), null, null, null, null));
        List<OrgRole> savelist = new ArrayList<OrgRole>();
        for (V3xOrgRole v3xOrgRole : list) {

    		v3xOrgRole.setIsBenchmark(false);
    		//orgManagerDirect.updateRole(v3xOrgRole);
            savelist.add((OrgRole)v3xOrgRole.toPO());
//    		String[] appLog = new String[2];
//            appLog[0] = user.getName();
//            appLog[1] = role.getShowName();
//            appLogs.add(appLog);
		}

        orgDao.updates(savelist);

    	role.setIsBenchmark(true);
//    	role.setCategory("1");
    	orgManagerDirect.updateRole(role);

    	appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_UpdateRole, user.getName(), role.getShowName());
    }



    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void deleteRole(Long[] roles) throws BusinessException {
        if (roles != null) {
            User user = AppContext.getCurrentUser();
            List<String[]> appLogs = new ArrayList<String[]>();
            V3xOrgRole role = null;
            List<V3xOrgRole> noDeleteRole = new UniqueList<V3xOrgRole>();
            for (Long id : roles) {
                role = orgManager.getRoleById(id);
                if(role==null){
                	return;
                }
                if (role.getOrgAccountId() != null && orgManager.getAccountById(role.getOrgAccountId()).isGroup()) {
                	//如果同步到单位的角色已经关联了人员，则不允许删除
                    EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
                    enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
                	List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
                	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
                	    List<V3xOrgMember> rellist1 = new ArrayList<V3xOrgMember>();
                		if(role.getBond()!=OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
                		    V3xOrgRole role2 = orgManager.getRoleById(v3xOrgRelationship.getSourceId());
                		    if(role2!=null){
                		        rellist1 = orgManager.getMembersByRole(role2.getOrgAccountId(), v3xOrgRelationship.getSourceId());
                		    }
                		}else{
                            rellist1 = orgManager.getMembersByRole(null, v3xOrgRelationship.getSourceId());
                		}

                		if(rellist1.size()>0){
                			noDeleteRole.add(role);
                		}

            		}
                }
                //如果角色被使用，则不允许删除
            	List<V3xOrgMember> rellistrole = orgManager.getMembersByRole(null, id);
            	if(rellistrole.size()>0){
            		noDeleteRole.add(role);
        		}
            }

            if(noDeleteRole.size()>0){
            	int i=0;
            	String roleNames = "";
            	for(V3xOrgRole nRole : noDeleteRole){
            		if(i==0){
            			roleNames = nRole.getShowName();
            		}else{
            			roleNames = roleNames + "、"+nRole.getShowName();
            		}
            		i++;
            	}
            	throw new BusinessException(roleNames+ResourceUtil.getString("role.message.use")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
            }

            Long accountId = null;
            for (Long id : roles) {
                role = orgManager.getRoleById(id);
                accountId = role.getOrgAccountId();
                if (accountId != null && orgManager.getAccountById(accountId).isGroup()) {
                	//同步删除单位角色
                	SycGroupRoleDelete(role);
                }

            	orgManagerDirect.deleteRole(role);
            	String[] appLog = new String[2];
            	appLog[0] = user.getName();
            	appLog[1] = role.getShowName();
            	appLogs.add(appLog);
            }

            //日志
            appLogManager.insertLogs4Account(user, accountId, AppLogAction.Organization_DeleteRole, appLogs);
        }
    }
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void deleteRole(Long roleId,Boolean whetherEnforced) throws BusinessException {
    	V3xOrgRole role = orgManager.getRoleById(roleId);
    	User user = AppContext.getCurrentUser();
        if(role==null){
        	return;
        }
        //如果是强制删除关系直接删除
        if(whetherEnforced){
        	orgManagerDirect.deleteRole2Entity(role.getId(), null, null);
        	SycGroupRoleDelete(role);
        }else {
	        if (role.getOrgAccountId() != null && orgManager.getAccountById(role.getOrgAccountId()).isGroup()) {
	        	//如果同步到单位的角色已经关联了人员，则不允许删除
	            EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
	            enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
	        	List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
	        	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
	        	    List<V3xOrgMember> rellist1 = new ArrayList<V3xOrgMember>();
	        		if(role.getBond()!=OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
	        		    V3xOrgRole role2 = orgManager.getRoleById(v3xOrgRelationship.getSourceId());
	        		    if(role2!=null){
	        		        rellist1 = orgManager.getMembersByRole(role2.getOrgAccountId(), v3xOrgRelationship.getSourceId());
	        		    }
	        		}else{
	                    rellist1 = orgManager.getMembersByRole(null, v3xOrgRelationship.getSourceId());
	        		}

	        		if(rellist1.size()>0){
	        			throw new BusinessException(role.getShowName()+ResourceUtil.getString("role.message.use")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
	        		}

	    		}

	        	//同步删除单位角色
	            SycGroupRoleDelete(role);
	        }
	        //如果角色被使用，则不允许删除
	    	List<V3xOrgMember> rellistrole = orgManager.getMembersByRole(null, role.getId());
	    	if(rellistrole.size()>0){
				throw new BusinessException(role.getShowName()+ResourceUtil.getString("role.message.use")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
			}
        }
        orgManagerDirect.deleteRole(role);
        String[] appLog = new String[2];
        appLog[0] = user.getName();
        appLog[1] = role.getShowName();
        //日志
        appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_DeleteRole, appLog);
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public void deleteRoleMenu(Long roleId) throws BusinessException {
		PrivRoleMenu roleRes = new PrivRoleMenu();
		roleRes.setRoleid(roleId);
		roleMenuDao.deleteRoleMenu(roleRes);
	}

    @Override
    public void delRole2Entity(String rolename, Long accountId, String entityIds) throws BusinessException {
    	if(rolename==null||entityIds==null){
    		return;
    	}
    	V3xOrgRole role = orgManager.getRoleByName(rolename, accountId);
    	if(null == role) return ;//OA-53498 增加防护
    	Long roleId = role.getId();
        //orgManagerDirect.deleteRole2Entity(roleId, null);
        String[] m1 = entityIds.split(",");
        for (String s : m1) {
            V3xOrgEntity entity = orgManager.getEntity(s);
            if(entity!=null){
                orgManagerDirect.deleteRoleandEntity(roleId, accountId, entity);
            }
        }
    }
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void disenableRole(Long[] roles) throws BusinessException {
        if (roles != null) {
            User user = AppContext.getCurrentUser();
            List<String[]> appLogs = new ArrayList<String[]>();
            Long accountId = null;
            
            //校验是否可以被停用
            for (Long id : roles) {
                V3xOrgRole role = orgManager.getRoleById(id);
                if(isUsed(role)){
                    throw new BusinessException(role.getShowName()+ResourceUtil.getString("role.message.use")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
                }
            }
            
            for (Long id : roles) {
            	V3xOrgRole role = orgManager.getRoleById(id);
            	accountId = role.getOrgAccountId();
            	role.setEnabled(false);
            	orgManagerDirect.updateRole(role);
            	String[] appLog = new String[2];
                appLog[0] = user.getName();
                appLog[1] = role.getShowName();
                appLogs.add(appLog);
            }
            //日志
            appLogManager.insertLogs4Account(user, accountId, AppLogAction.Organization_DisEnableRole, appLogs);
        }
    }
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void enableRole(Long[] roles) throws BusinessException {
        if (roles != null) {
            User user = AppContext.getCurrentUser();
            List<String[]> appLogs = new ArrayList<String[]>();
            Long accountId = null;
            for (Long id : roles) {
            	V3xOrgRole role = orgManager.getRoleById(id);
            	accountId = role.getOrgAccountId();
            	role.setEnabled(true);
            	orgManagerDirect.updateRole(role);
            	String[] appLog = new String[2];
                appLog[0] = user.getName();
                appLog[1] = role.getShowName();
                appLogs.add(appLog);
            }
            //日志
            appLogManager.insertLogs4Account(user, accountId, AppLogAction.Organization_EnableRole, appLogs);
        }
    }
    @Override
    public V3xOrgRole findById(Long role) throws BusinessException {
        return orgManager.getRoleById(role);
    }
    @SuppressWarnings("unchecked")
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public FlipInfo findRoles(FlipInfo fi, Map param) throws BusinessException {
        Long accountId = Long.parseLong(param.get("accountId").toString());
        if (param.get("name") != null) {
            String searchRoleName = String.valueOf(param.get("name"));
            param.put("name", processRoleName(searchRoleName, accountId));
        }
        List<V3xOrgRole> roleList = new ArrayList<V3xOrgRole>();
        // 查询条件为空的情况直接从缓存返回
        if (param.size() == 1) {
            roleList = orgCache.getAllV3xOrgEntity(V3xOrgRole.class, accountId);
        } else {
            // 存在查询提交时从数据库返回
            List<OrgRole> list = orgDao.getAllRolePO(accountId, null, param, null);
            for (int i = 0; i < list.size(); i++) {
                OrgRole role = list.get(i);
                if (null != role) {
                    roleList.add(new V3xOrgRole(role));
                }
            }
        }
        //根据插件过滤角色
        List<V3xOrgRole> dislist = orgManager.getPlugDisableRole(accountId);
        if (dislist != null) {
            for (V3xOrgRole v3xOrgRole : dislist) {
                for (int i = 0; i < roleList.size(); i++) {
                    V3xOrgRole role = roleList.get(i);
                    if (role.getId().equals(v3xOrgRole.getId())) {
                        roleList.remove(i--);
                    }
                }
            }
        }
        // 过滤不允许分配的菜单
        List<V3xOrgRole> copyList = new ArrayList<V3xOrgRole>();
        copyList.addAll(roleList);
		for (V3xOrgRole role : copyList) {
			if (!AppContext.hasPlugin("edoc")) { // 当前版本下是否需要显示公文相关人员
				if (role.getCode().equals(Role_NAME.Accountexchange.name())
						|| role.getCode().equals(Role_NAME.SendEdoc.name())
						|| role.getCode().equals(Role_NAME.SignEdoc.name())
						|| role.getCode().equals(Role_NAME.RecEdoc.name())
						|| role.getCode().equals(Role_NAME.EdocModfiy.name())
						|| role.getCode().equals(Role_NAME.Departmentexchange.name())) {
					roleList.remove(role);
				}
			}
			if (!(Boolean) SysFlag.hr_salary.getFlag() && role.getCode().equals(Role_NAME.SalaryAdmin.name())) {
				roleList.remove(role);
			}
		}
        // 排序
        Collections.sort(roleList, CompareSortEntity.getInstance());
        // 分页
        DBAgent.memoryPaging(roleList, fi);
        return fi;
    }

  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin,Role_NAME.DepAdmin})
    public V3xOrgRole getDefultRoleByAccount(Long accountId) throws BusinessException {
        List<V3xOrgRole> allRoles = orgManager.getAllRoles(accountId);
        for (V3xOrgRole role : allRoles) {
            if(role.getIsBenchmark()) {
                return role;
            }
        }
        return orgManager.getRoleByName(OrgConstants.Role_NAME.GeneralStaff.name(), accountId);
    }

    @Override
    public String getGroupPrivType() throws BusinessException{
    	//ConfigItem item = new ConfigItem();
    	String item = getSystemConfig().get("group_priv_type");

    		if("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))){
    			return item;
    		}else{
    			return "true";
    		}


    }

    @Override
    public int getMaxSortId(Long accountId) {
        return orgDao.getMaxSortId(V3xOrgRole.class, accountId) + 1;
    }

    public OrgManagerDirect getOrgManagerDirect() {
        return orgManagerDirect;
    }

    /**
     * 获取已经同步的集团角色列表
     * @return
     * @throws BusinessException
     */
    @SuppressWarnings("unused")
    private List<V3xOrgRole> getSycRole() throws BusinessException{
    	List<V3xOrgRole> list = new ArrayList<V3xOrgRole>();
    	boolean addflag = true;
    	List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, null);
    	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
    		addflag = true;
    		for (V3xOrgRole v3xOrgRole : list) {
				if(v3xOrgRole.getId().equals(v3xOrgRelationship.getObjective0Id())){
					addflag = false;
					break;
				}
			}
    		if(addflag){
    			list.add(orgManager.getRoleById(v3xOrgRelationship.getObjective0Id()));
    		}
		}

    	return null;
    }

    protected SystemConfig getSystemConfig(){
        if(systemConfig == null){
        	systemConfig = (SystemConfig)AppContext.getBean("systemConfig");
        }

        return systemConfig;
    }

    /**
     * 前台列表的角色名称显示的是国际化名称，查询时需进行转化
     * @param searchRoleName 查询时输入的角色名
     * @return 数据库中保存的角色名
     */
    private List<String> processRoleName(String searchRoleName, Long accountId) {
        List<String> result = new ArrayList<String>();
        if (Strings.isNotBlank(searchRoleName)) {
            List<OrgRole> list = orgDao.getAllRolePO(accountId, null, null, null);
            if (list != null) {
                String roleNameI81n = null;
                String roleName = null;
                for (OrgRole orgRole : list) {
                    roleName = orgRole.getName();
                    roleNameI81n = ResourceUtil.getString("sys.role.rolename." + roleName);
                    if (!StringUtil.checkNull(roleNameI81n) && roleNameI81n.indexOf(searchRoleName) != -1) {
                        result.add(roleName);
                    } else {
                        result.add(searchRoleName);
                    }
                }
            }
        }
        return result;
    }
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    @Override
    public void setGroupPrivType(String type) throws BusinessException{
//    	ConfigItem item = new ConfigItem();
//    	if(getConfigManager().getConfigItem("GROUP_PRIV_TYPE", "GROUP_PRIV_TYPE")==null){
//    		getConfigManager().addConfigItem("GROUP_PRIV_TYPE", "GROUP_PRIV_TYPE", type);
//    	}else{
//    		item = getConfigManager().getConfigItem("GROUP_PRIV_TYPE", "GROUP_PRIV_TYPE");
//    		item.setConfigValue(type);
//    		getConfigManager().updateConfigItem(item);
//    	}

    }


    public void setMenuCacheManager(MenuCacheManager menuCacheManager) {
        this.menuCacheManager = menuCacheManager;
    }



    /**
     * @param orgCache the orgCache to set
     */
    public void setOrgCache(OrgCache orgCache) {
        this.orgCache = orgCache;
    }

    /**
     * @param orgDao the orgDao to set
     */
    public void setOrgDao(OrgDao orgDao) {
        this.orgDao = orgDao;
    }

    /**
     * @param orgManager the orgManager to set
     */
    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }
    public void setPrivilegerManage(PrivilegeManager privilegeManager) {
		this.privilegeManager = privilegeManager;
	}
    /**
     * @param roleResourceDao the roleResourceDao to set
     */
    public void setRoleMenuDao(RoleMenuDao roleMenuDao) {
        this.roleMenuDao = roleMenuDao;
    }
    @Override
    public FlipInfo showMembers4Role(FlipInfo fi, Map params) throws BusinessException {
        if (params.size() == 0) {
            return fi;
        }
        Long roleId = Long.valueOf(params.get("id").toString());
        V3xOrgRole v3xOrgRole = orgManager.getRoleById(roleId);
        List<HashMap> maplist = new UniqueList<HashMap>();
        if(v3xOrgRole!=null && v3xOrgRole.isValid()){
            List<V3xOrgEntity> entitys = orgManager.getEntitysByRoleAllowRepeat(null, roleId);
            for (V3xOrgEntity v3xOrgEntity : entitys) {
                List<V3xOrgMember> members = new ArrayList<V3xOrgMember>();
                members.addAll(orgManager.getMembersByType(
                        OrgHelper.getEntityTypeByClassSimpleName(v3xOrgEntity.getClass().getSimpleName()),
                        v3xOrgEntity.getId()));
                for (V3xOrgMember v3xOrgMember : members) {
                    HashMap map = new HashMap();
                    ParamUtil.beanToMap(v3xOrgMember, map, false);
                    map.put("name", OrgHelper.showMemberName(v3xOrgMember.getId()));
                    map.put("entitytype", v3xOrgEntity.getName());
                    map.put("accountName", OrgHelper.showOrgAccountNameByMemberid(v3xOrgMember.getId()));
                    //map.put("accountName", orgManager.getAccountById(v3xOrgMember.getOrgAccountId())==null?"":orgManager.getAccountById(v3xOrgMember.getOrgAccountId()).getShortName());
                    //处理兼职人员的部门显示（当前登录单位的部门）
                    if ((Long.valueOf(v3xOrgRole.getOrgAccountId()).equals(OrgConstants.GROUPID)&&v3xOrgEntity.getOrgAccountId().equals(v3xOrgMember.getOrgAccountId()))
                            || v3xOrgMember.getOrgAccountId().equals(v3xOrgRole.getOrgAccountId())) {
                        map.put("deptname", OrgHelper.showDepartmentFullPath(v3xOrgMember.getOrgDepartmentId()));

                    } else {
                        List<MemberPost> memberposts = v3xOrgMember.getConcurrent_post();
                        if (memberposts != null) {
                            for (MemberPost memberPost : memberposts) {
                                if ((orgManager.getDepartmentById(memberPost.getDepId()).getOrgAccountId()
                                        .equals(v3xOrgRole.getOrgAccountId()))||(!v3xOrgEntity.getEntityType().equals(V3xOrgEntity.ORGENT_TYPE_MEMBER)&&orgManager.getDepartmentById(memberPost.getDepId()).getOrgAccountId()
                                                .equals(v3xOrgEntity.getOrgAccountId()))) {
                                    map.put("deptname", OrgHelper.showDepartmentFullPath(memberPost.getDepId()));
                                }
                            }
                        }
                        //map.put("deptname", orgManager.getDepartmentById(v3xOrgMember.getConcurrent_post()).getName());
                    }
                    if(!map.containsKey("deptname")){
                    	map.put("deptname", "");
                    }
                    if (Strings.isNotBlank(v3xOrgEntity.getDescription())
                            && orgManager.getDepartmentById(Long.valueOf(v3xOrgEntity.getDescription())) != null) {
                        map.put("deptrolename", orgManager.getDepartmentById(Long.valueOf(v3xOrgEntity.getDescription()))
                                .getName());
                    } else {
                        map.put("deptrolename", "");
                    }
                    maplist.add(map);
                }
            }
        }
        DBAgent.memoryPaging(maplist, fi);
        return fi;

    }
    /**
     * 同步集团角色
     * @throws BusinessException
     */
    public void SycGroupRole(V3xOrgRole role,int type) throws BusinessException{
    	if(role.getOrgAccountId().equals(OrgConstants.GROUPID)){
    		return;
    	}
    	if(type==1){
    		SycGroupRoleAdd(role);
    	}
    }
    public void SycGroupRoleAdd(V3xOrgRole role) throws BusinessException{
    	if(role.getBond()==0){
    		return;
    	}
    	List<OrgUnit> allAccounts = orgDao.getAllUnitPO(OrgConstants.UnitType.Account, null, null, null, "group", false, null);
    	for (OrgUnit orgUnit : allAccounts) {
    		V3xOrgRole newrole = new V3xOrgRole(role);
    		newrole.setId(UUIDLong.longUUID());
    		newrole.setOrgAccountId(orgUnit.getId());
    		newrole.setType(RoleTypeEnum.relativeflag.getKey());
    		orgManagerDirect.addRole(newrole);
    		V3xOrgRelationship newrel = new V3xOrgRelationship();
    		newrel.setId(UUIDLong.longUUID());
    		newrel.setSourceId(newrole.getId());
    		newrel.setObjective0Id(role.getId());
    		newrel.setKey(OrgConstants.RelationshipType.Banchmark_Role.name());
    		orgManagerDirect.addOrgRelationship(newrel);
		}
    }


    public void SycGroupRoleDelete(V3xOrgRole role) throws BusinessException{
    	if(role.getBond()==0){
    		return;
    	}
    	EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
    	List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
    	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
    		V3xOrgRole accrole = orgManager.getRoleById(v3xOrgRelationship.getSourceId());
    		orgManagerDirect.deleteRole(accrole);
    		//orgManagerDirect.deleteOrgRelationship(v3xOrgRelationship);
		}
        orgManagerDirect.deleteOrgRelationships(rellist);
    }
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public Long updateRole(V3xOrgRole role) throws BusinessException {
        Long result = -1l;
        //判断角色名称是否重复
        if(checkDulipName(role)){
            throw new BusinessException(ResourceUtil.getString("role.repeat.name")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
        }
        //判断角色编码是否重复
        if(checkDulipCode(role)){
        	throw new BusinessException(ResourceUtil.getString("role.repeat")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
        }
        //判断默认角色不能前台授权为否
        if(role.getIsBenchmark()&&"0".equals(role.getCategory())){
        	throw new BusinessException(ResourceUtil.getString("role.defultandnopriv.no"));
        }
        //判断默认角色不能停用
        if(role.getIsBenchmark()&&!role.getEnabled()){
        	throw new BusinessException(ResourceUtil.getString("role.defult.cannot"));
        }
        //判断外部人员角色不能前台授权为否
        if(role.getCode().equals(OrgConstants.Role_NAME.ExternalStaff.name())&&"0".equals(role.getCategory())){
        	throw new BusinessException(ResourceUtil.getString("role.defultandnopriv.no"));
        }
        
        //如果角色已经被使用，不允许停用
        if(!role.getEnabled()){
            if (role.getOrgAccountId() != null && orgManager.getAccountById(role.getOrgAccountId()).isGroup()) {
                //如果同步到单位的角色已经关联了人员，则不允许停用
                EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
                enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
                List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
                for (V3xOrgRelationship v3xOrgRelationship : rellist) {
                    List<V3xOrgMember> rellist1 = new ArrayList<V3xOrgMember>();
                    if(role.getBond()!=OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
                        V3xOrgRole role2 = orgManager.getRoleById(v3xOrgRelationship.getSourceId());
                        if(role2!=null){
                            rellist1 = orgManager.getMembersByRole(role2.getOrgAccountId(), v3xOrgRelationship.getSourceId());
                        }
                    }else{
                        rellist1 = orgManager.getMembersByRole(null, v3xOrgRelationship.getSourceId());
                    }
                    
                    if(rellist1.size()>0){
                        throw new BusinessException(ResourceUtil.getString("role.message.use")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
                    }
                    
                }
            }
            //如果角色被使用，则不允许删除
            List<V3xOrgMember> rellistrole = orgManager.getMembersByRole(null, role.getId());
            if(rellistrole.size()>0){
                throw new BusinessException(ResourceUtil.getString("role.message.use")+"，"+ResourceUtil.getString("MessageStatus.ERROR"));
            }
        }
        
        if (role != null && role.getId() != null) {
            //判断名称是否修改，如果没有修改，还原成老的
            boolean isChangeName = !Strings.equals(role.getName(), ResourceUtil.getString("sys.role.rolename." + role.getCode()));
            if(!isChangeName){
                role.setName(role.getCode());
            }
            
        	/*if(role.getType()){
        		role.setType(3);
        	}*/
            OrgRole roleUpdate = (OrgRole) role.toPO();
            orgDao.update(roleUpdate);
            //应用日志
            User user = AppContext.getCurrentUser();
            appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_UpdateRole, user.getName(), role.getShowName());
            //如果是集团基准角色，则更新所有单位
            if(orgManager.getAccountById(role.getOrgAccountId()).isGroup()){
            	EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
                enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
            	List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);

            	List<String[]> appLogs = new ArrayList<String[]>();
            	List<OrgRole> orgRoles = new UniqueList<OrgRole>();
            	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
            		V3xOrgRole accrole = orgManager.getRoleById(v3xOrgRelationship.getSourceId());
            		if(accrole==null){
            			continue;
            		}
            		accrole.setName(role.getName());
            		accrole.setShowName(role.getShowName());
            		accrole.setBond(role.getBond());
            		accrole.setCategory(role.getCategory());
            		accrole.setCode(role.getCode());
            		accrole.setDescription(role.getDescription());
            		accrole.setEnabled(role.getEnabled());
            		accrole.setIsBenchmark(role.getIsBenchmark());
            		accrole.setIsDeleted(role.getIsDeleted());
            		accrole.setSortId(role.getSortId());
            		accrole.setStatus(role.getStatus());

            		orgRoles.add((OrgRole)accrole.toPO());

            		String[] appLog = new String[2];
                    appLog[0] = user.getName();
                    appLog[1] = role.getShowName();
                    appLogs.add(appLog);
    			}
            	
            	orgDao.updates(orgRoles);
            	//更新集团角色，记录每一个单位内角色更新操作应用日志
            	appLogManager.insertLogs4Account(user, role.getOrgAccountId(), AppLogAction.Organization_UpdateRole, appLogs);
            }
            result = role.getId();
        }
        return result;
    }
    
    private boolean isUsed(V3xOrgRole role) throws BusinessException{
        //如果角色已经被使用，不允许停用
        if (role.getOrgAccountId() != null && orgManager.getAccountById(role.getOrgAccountId()).isGroup()) {
            //如果同步到单位的角色已经关联了人员，则不允许停用
            EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
            enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, role.getId());
            List<V3xOrgRelationship> rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
            for (V3xOrgRelationship v3xOrgRelationship : rellist) {
                List<V3xOrgMember> rellist1 = new ArrayList<V3xOrgMember>();
                if(role.getBond()!=OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
                    V3xOrgRole role2 = orgManager.getRoleById(v3xOrgRelationship.getSourceId());
                    if(role2!=null){
                        rellist1 = orgManager.getMembersByRole(role2.getOrgAccountId(), v3xOrgRelationship.getSourceId());
                    }
                }else{
                    rellist1 = orgManager.getMembersByRole(null, v3xOrgRelationship.getSourceId());
                }
                
                if(rellist1.size()>0){
                    return true;
                }
                
            }
        }
        //如果角色被使用，则不允许删除
        List<V3xOrgMember> rellistrole = orgManager.getMembersByRole(null, role.getId());
        if(rellistrole.size()>0){
            return true;
        }
        return false;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void updateRoleResource(List nodes, Long roleId) throws BusinessException {
//    	long startMili=System.currentTimeMillis();
        PrivTreeNodeBO node = null;
        String nodeId = null;
        PrivRoleMenu roleRes = null;
        Long menuId = null;

        List<PrivRoleMenu> roleReources = new ArrayList<PrivRoleMenu>();
        //这是一个坑，不知道其他里面是否调用，那就祝他好运了！
        if(nodes!=null&&nodes.size()>0){
        	if(nodes.get(0) instanceof Map){
        		nodes = ParamUtil.mapsToBeans(nodes, PrivTreeNodeBO.class, true);
        	}
        }
        // 先删除已存在的关系
        roleRes = new PrivRoleMenu();
        roleRes.setRoleid(roleId);
        roleMenuDao.deleteRoleMenu(roleRes);
        //如果是集团基准角色，批量删除单位关系
        List<V3xOrgRelationship> rellist = new ArrayList<V3xOrgRelationship>();
        if(orgManager.getAccountById(orgManager.getRoleById(roleId).getOrgAccountId()).isGroup()){
        	EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
            enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, roleId);
        	rellist = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Banchmark_Role, null, null, enummap);
        	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
        		roleRes = new PrivRoleMenu();
                roleRes.setRoleid(v3xOrgRelationship.getSourceId());
                roleMenuDao.deleteRoleMenu(roleRes);
			}
        }
        // 新建角色资源关系
        StringBuffer ressourcename = new StringBuffer("");

        for (int i = 0; i < nodes.size(); i++) {
            node = (PrivTreeNodeBO) nodes.get(i);
            nodeId = node.getIdKey();
             if (nodeId.indexOf(PrivTreeNodeBO.menuflag) != -1) {
                // 勾选菜单时自动将入口资源勾选
                menuId = Long.parseLong(node.getIdKey().replace(PrivTreeNodeBO.menuflag, ""));
                PrivMenuBO menuBO = privilegeMenuManager.findById(menuId);
                if (menuBO != null) {
                    roleRes = new PrivRoleMenu();
                    roleRes.setNewId();
                    roleRes.setResourceid(menuBO.getEnterResourceId());
                    roleRes.setRoleid(roleId);
                    roleRes.setMenuid(menuBO.getId());
                    roleReources.add(roleRes);
                    ressourcename.append(menuBO.getName());
                	ressourcename.append(",");
                }
            }
        }
        roleMenuDao.insertRoleMenuPatchAll(roleReources);
        //应用日志
        User user = AppContext.getCurrentUser();
//        for (PrivRoleMenu p : roleReources) {
//        	PrivRoleMenu resource = resourceManager.findById(p.getResourceid());
//        	if(resource != null){
//            	ressourcename.append(resource.getResourceName());
//            	ressourcename.append(",");
//        	}
//        }
            V3xOrgRole role = orgManager.getRoleById(roleId);

            privilegeMenuManager.updateMemberMenuLastDateByRoleId(roleId, role.getOrgAccountId(),null);
            appLogManager.insertLog4Account(user, role.getOrgAccountId(), AppLogAction.Organization_RoleToResource, user.getName(), role.getShowName(),
            		ressourcename.toString());


        //如果是集团基准角色，更新各单位的关系
        if(orgManager.getAccountById(orgManager.getRoleById(roleId).getOrgAccountId()).isGroup()){
            	for (V3xOrgRelationship v3xOrgRelationship : rellist) {
        		List<PrivRoleMenu> accroleReources = new ArrayList<PrivRoleMenu>();
        		//accroleReources.addAll(roleReources);
        		for (PrivRoleMenu privRoleResource : roleReources) {
        			PrivRoleMenu accprivRoleResource = new PrivRoleMenu();
        			accprivRoleResource.setRoleid(v3xOrgRelationship.getSourceId());
        			accprivRoleResource.setId(UUIDLong.longUUID());
        			accprivRoleResource.setMenuid(privRoleResource.getMenuid());
        			accprivRoleResource.setModifiable(privRoleResource.getModifiable());
        			accprivRoleResource.setResourceid(privRoleResource.getResourceid());
        			accroleReources.add(accprivRoleResource);
				}
        		roleMenuDao.insertRoleMenuPatchAll(accroleReources);
        	}
        }
        privilegeMenuManager.updateBiz();
        //results[0] = "更新成功";
        //return results;
//        long endMili=System.currentTimeMillis();
//        log.
//        System.out.println("总耗时为："+(endMili-startMili)+"毫秒");
    }

	public void setPrivilegeMenuManager(PrivilegeMenuManager privilegeMenuManager) {
		this.privilegeMenuManager = privilegeMenuManager;
	}
}
