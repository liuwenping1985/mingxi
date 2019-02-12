package com.seeyon.ctp.organization.manager;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.EntityIdTypeDsBO;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.po.OrgTeam;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin,Role_NAME.DepAdmin})
public class TeamManagerImpl implements TeamManager {
    private final static Log   logger = LogFactory.getLog(TeamManagerImpl.class);
    protected OrgCache         orgCache;
    protected OrgDao           orgDao;
    protected OrgManagerDirect orgManagerDirect;
    protected OrgManager       orgManager;
    protected PrincipalManager principalManager;
    protected AppLogManager    appLogManager;

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

    @Override
	public HashMap addTeam(String accountId) throws BusinessException {
		Integer maxSortNum = orgManagerDirect.getMaxSortNum(V3xOrgTeam.class.getSimpleName(), Long.parseLong(accountId));
		HashMap m = new HashMap();
		m.put("sortId", maxSortNum+1);
		return m;
	}

	@Override
	public Long saveTeam(String accountId, Map team) throws BusinessException {
		User user = AppContext.getCurrentUser();
		Long accId = Long.parseLong(accountId);
		V3xOrgTeam newteam = new V3xOrgTeam();
		String ownerId = "-1";
		V3xOrgMember member = orgManager.getMemberById(user.getId());
		boolean isVirtualAccAdmin = false;
		if(team.containsKey("isVirtualAccAdmin") && team.get("isVirtualAccAdmin") != null){
			String virtualAccAdmin = String.valueOf(team.get("isVirtualAccAdmin"));
			isVirtualAccAdmin = "1".equals(virtualAccAdmin) ? true : false;
		}
		if(member.getIsAdmin()
			|| orgManager.isRole(user.getId(), accId, OrgConstants.Role_NAME.DepAdmin.name())
	        || orgManager.isRole(user.getId(), accId, OrgConstants.Role_NAME.HrAdmin.name())
	        || isVirtualAccAdmin){//如果是HR管理员新建的组
			ownerId = String.valueOf(accId);
		}else{
			//考虑兼职 用memberpost取部门
			if(member.getOrgAccountId().equals(accId)){
				ownerId = String.valueOf(member.getOrgDepartmentId());
			}else{
				List<MemberPost> memposts = member.getConcurrent_post();
				for (MemberPost memberPost : memposts) {
					if(memberPost.getOrgAccountId().equals(accId)){
						ownerId = String.valueOf(memberPost.getDepId());
					}
				}
			}
		}
		if(team.get("ownerId")==null||"".equals(team.get("ownerId"))){
			team.put("ownerId", ownerId);
		}else{
			team.put("ownerId", orgManager.getEntity(String.valueOf(team.get("ownerId"))).getId());
			V3xOrgUnit unitById = orgManager.getUnitById(Long.valueOf(team.get("ownerId").toString()));
			V3xOrgUnit owner = orgManager.getUnitById(Long.valueOf(ownerId));
			if(owner.getType().equals(OrgConstants.UnitType.Department)&&!unitById.getPath().startsWith(owner.getPath())){
				throw new BusinessException(unitById.getName()+"不在管理员管理范围之内");
			}
			
			//如果只是是部门管理员 所属范围 和公开范围 只能选择 管理的所有的部门及其子部门
	        String deptIds="";
	        if(orgManager.isDepartmentAdmin() && !orgManager.isHRAdmin() && !isVirtualAccAdmin){
	    		List<V3xOrgDepartment> depts= orgManager.getDeptsByAdmin(user.getId(),accId);
	    		List<V3xOrgDepartment> allChildDepts = new UniqueList<V3xOrgDepartment>();
	    		for(V3xOrgDepartment dept : depts){
	    			if(allChildDepts.contains(dept)){
	    				continue;
	    			}
	    			allChildDepts.add(dept);
	    			allChildDepts.addAll(orgManager.getChildDepartments(dept.getId(), false));
	    		}
	    		
	    		for(V3xOrgDepartment adept : allChildDepts){
	    			deptIds+=adept.getId()+",";
	    		}
	    		
	    		//所属范围
    			if(deptIds.indexOf(unitById.getId().toString())<0){
    					throw new BusinessException(unitById.getName()+"不在管理员管理范围之内");
    			}
	    		//公开范围
	    		String scopein = team.get("scopein").toString();
	    		if(Strings.isNotBlank(scopein)){
	    			String[] scopedepts = scopein.split(",");
	    			for(String deptStr : scopedepts){
	    				String deptId =(String) deptStr.split("\\|")[1];
	    				if(Strings.isNotBlank(deptId) && deptIds.indexOf(deptId)<0){
	    					V3xOrgDepartment dept = orgManager.getDepartmentById(Long.valueOf(deptId));
	    					throw new BusinessException(dept.getName()+"不在管理员管理范围之内");
	    				}
	    			}
	    		}
	        }
		}
		ParamUtil.mapToBean(team, newteam, false);
		//处理组的创建实体
		//如果是单位管理员或HR管理员，创建实体是单位
		if(orgManager.isGroupAdminById(user.getId())||orgManager.isAdministrator()||orgManager.isHRAdmin()||isVirtualAccAdmin){
			newteam.setCreateId(accId);
		}
		//如果是部门管理员，创建实体是部门
		else{
			newteam.setCreateId(orgManager.getCurrentDepartment().getId());
		}

        if (newteam.getId() == null) {
        	//排序号的重复处理
    		String isInsert = team.get("sortIdtype").toString();
    		if("1".equals(isInsert)&&orgManagerDirect.isPropertyDuplicated(V3xOrgTeam.class.getSimpleName(), "sortId", newteam.getSortId().longValue(),accId)){
    		        orgManagerDirect.insertRepeatSortNum(V3xOrgTeam.class.getSimpleName(), accId, newteam.getSortId(),null);
    		}
            newteam.setIdIfNew();
            //newteam.setOwnerId(Long.valueOf(ownerId));
            newteam.setOrgAccountId(accId);
            //一定要在送入接口前将组成员组装好，否则分发会有问题，例如分发出去的事件中午组成员
            dealTeamMembers(team, newteam);
            orgManagerDirect.addTeam(newteam);
            //日志
            appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewTeam, user.getName(), newteam.getName());
        } else {
        	String isInsert = team.get("sortIdtype").toString();
    		if("1".equals(isInsert)&&orgManagerDirect.isPropertyDuplicated(V3xOrgTeam.class.getSimpleName(), "sortId", newteam.getSortId().longValue(),accId,newteam.getId())){
    		        orgManagerDirect.insertRepeatSortNum(V3xOrgTeam.class.getSimpleName(), accId, newteam.getSortId(),null);
    		}
            dealTeamMembers(team, newteam);
            orgManagerDirect.updateTeam(newteam);
            //日志
            appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdateTeam, user.getName(), newteam.getName());
        }


		//增加组的公开范围
		List scopelist = new ArrayList();

		//公开组，范围读取
		if("1".equals(team.get("scope").toString())){
			if(!"".equals(team.get("scopein"))){
				scopelist.addAll(orgManager.getEntities(team.get("scopein").toString()));
			}else
				//部门管理员默认公开范围是部门，单位管理员、HR管理员是单位
				if(orgManager.isDepartmentAdmin() && !isVirtualAccAdmin){
					scopelist.add(orgManager.getDepartmentById(orgManager.getMemberById(user.getId()).getOrgDepartmentId()));
				}else{
					scopelist.add(orgManager.getAccountById(accId));
				}
		}

		orgManagerDirect.addTeamScope(scopelist, newteam);
		return newteam.getId();
	}

	/**
	 * 处理组成员列表
	 * @param team
	 * @param newteam
	 * @throws BusinessException
	 */
    private void dealTeamMembers(Map team, V3xOrgTeam newteam) throws BusinessException {
        //增加组的各种类型人员
		if(!"".equals(team.get("teamLeader"))){
			List list = orgManager.getEntities(team.get("teamLeader").toString());
			//orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.Leader.name());
			newteam.setLeaders(OrgHelper.entityListToIdTypeList(list));
		}
		if(!"".equals(team.get("teamMember"))){
			String teamMembers = team.get("teamMember").toString();
		//	List list = orgManager.getEntities(teamMembers);
			//orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.Member.name());
			//newteam.setMembers(OrgHelper.entityListToIdTypeList(list,getEntityMap(teamMembers)));
			newteam.setMembers(OrgHelper.mapToIdTypeList(getEntityMap(teamMembers)));
		}
		if(!"".equals(team.get("teamSuperVisor"))){
			List list = orgManager.getEntities(team.get("teamSuperVisor").toString());
			//orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.SuperVisor.name());
			newteam.setSupervisors(OrgHelper.entityListToIdTypeList(list));
		}
		if(!"".equals(team.get("teamRelative"))){
			List list = orgManager.getEntities(team.get("teamRelative").toString());
			//orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.Relative.name());
			newteam.setRelatives(OrgHelper.entityListToIdTypeList(list));
		}
    }

    @Override
    public String deleteTeam(List<Map<String, Object>> team) throws BusinessException {
        List<V3xOrgTeam> teamlist = new ArrayList<V3xOrgTeam>();
        teamlist = ParamUtil.mapsToBeans(team, V3xOrgTeam.class, false);
        OrganizationMessage message = orgManagerDirect.deleteTeams(teamlist);
        //日志信息
        List<String[]> appLogs = new ArrayList<String[]>();
        User user = AppContext.getCurrentUser();
        for (V3xOrgTeam t : teamlist) {
            String[] appLog = new String[2];
            appLog[0] = user.getName();
            appLog[1] = t.getName();
            appLogs.add(appLog);
        }
        appLogManager.insertLogs4Account(user, teamlist.get(0).getOrgAccountId(), AppLogAction.Organization_DeleteTeam, appLogs);
        return String.valueOf(message.getSuccessMsgs());
    }

	@Override
    public HashMap viewTeam(Long teamId) throws BusinessException {
        HashMap map = new HashMap();
        V3xOrgTeam team = orgManager.getTeamById(teamId);
        ParamUtil.beanToMap(team, map, false);
        //组织公开范围
        List scopelist = orgManagerDirect.getTeamScope(team);
        if (scopelist.size() == 0) {
            map.put("scope", "2");
            map.put("scopein", "");
            map.put("scopein_txt", "");
        } else {
            map.put("scope", "1");
            map.put("scopein", OrgHelper.parseElements(scopelist, "id", "entityType"));
            map.put("scopein_txt", OrgHelper.showOrgEntities(scopelist, "id", "entityType", null));
        }
        //组所属的机构
        map.put("ownerId",
                OrgHelper.getSelectPeopleStr(orgManager.getUnitById(Long.valueOf(map.get("ownerId").toString()))));
        //组人员
        List teamLeader = orgManagerDirect.getTeamMembers(team, OrgConstants.TeamMemberType.Leader.name());
        List teamRelative = orgManagerDirect.getTeamMembers(team, OrgConstants.TeamMemberType.Relative.name());
        List teamSuperVisor = orgManagerDirect.getTeamMembers(team, OrgConstants.TeamMemberType.SuperVisor.name());
        String teamLeaderstr = OrgHelper.getSelectPeopleStr(teamLeader);
        String teamMemberstr = JSONUtil.toJSONString(orgManagerDirect.getTeamsMember(team, OrgConstants.TeamMemberType.Member.name()));
        String teamRelativestr = OrgHelper.getSelectPeopleStr(teamRelative);
        String teamSuperVisorstr = OrgHelper.getSelectPeopleStr(teamSuperVisor);
        map.put("teamLeader", teamLeaderstr);
        map.put("teamMember", teamMemberstr);
        map.put("teamRelative", teamRelativestr);
        map.put("teamSuperVisor", teamSuperVisorstr);

        return map;
    }

    @Override
    public FlipInfo showTeamList(FlipInfo fi, Map params)
            throws BusinessException {
        Long currentUserId = AppContext.currentUserId();
        Long accountId = Long.valueOf(params.get("accountId").toString());
        // 客开 虚拟单位管理员
        boolean isVirtualAccAdmin = false;
        if (params.containsKey("isVirtualAccAdmin")){
        	String virtualAccAdmin = String.valueOf(params.remove("isVirtualAccAdmin"));
        	isVirtualAccAdmin = "1".equals(virtualAccAdmin)? true : false;
        }

        Map<String, Object> param = new HashMap<String, Object>();
        List<OrgTeam> list;
        if (params.size() == 1 || "scope".equals(params.get("condition"))) {
            list = orgDao.getAllTeamPO(accountId, null, null, param, null);
        } else {
            param.put(String.valueOf(params.get("condition")), params.get("value"));
            list = orgDao.getAllTeamPO(accountId, null, null, param, null);
        }
        List rellist = new ArrayList();

        boolean isHrAdmin = orgManager.isHRAdmin();
        boolean isAdministrator = orgManager.isAdministratorById(currentUserId, accountId);
        boolean isGroupAdmin = orgManager.isGroupAdminById(currentUserId);
        boolean isDeptAdmin = orgManager.isDepartmentAdmin();
        
        isAdministrator = isAdministrator ? isAdministrator : isVirtualAccAdmin;

        String deptIds="";
        if(!isHrAdmin && isDeptAdmin){
    		//如果只是是部门管理员,能看到 所属范围是 管理的所有的部门及其子部门下的组
    		List<V3xOrgDepartment> depts= orgManager.getDeptsByAdmin(currentUserId,accountId);
    		List<V3xOrgDepartment> allChildDepts = new UniqueList<V3xOrgDepartment>();
    		for(V3xOrgDepartment dept : depts){
    			if(allChildDepts.contains(dept)){
    				continue;
    			}
    			allChildDepts.add(dept);
    			allChildDepts.addAll(orgManager.getChildDepartments(dept.getId(), false));

    		}
    		
    		for(V3xOrgDepartment adept : allChildDepts){
    			deptIds+=adept.getId()+",";
    		}
        }

        for (OrgTeam object : list) {
            HashMap<String, String> m = new HashMap<String, String>();
            ParamUtil.beanToMap((OrgTeam)object, m, true);

            if(!String.valueOf(OrgConstants.TEAM_TYPE.SYSTEM.ordinal()).equals(String.valueOf(m.get("type")))){
                continue;//管理员只管理系统组
            }

            V3xOrgUnit unit = orgManager.getUnitById(Long.valueOf(String.valueOf(m.get("ownerId"))));
            if(null == unit) {
                continue;
            }

            //根据查询条件过滤权限属性
            if(orgManager.isEmptyTeamScope((V3xOrgTeam)OrgHelper.poTobo(object))){
            	m.put("scope", "2");
            }else{
            	m.put("scope", "1");
            }
            if (params.size() > 1 && "scope".equals(params.get("condition"))
                    && !params.get("value").equals(m.get("scope"))) {
                continue;
            }

            if (!m.containsKey("ownerId") || "".equals(String.valueOf(m.get("ownerId")))
                    || orgManager.getUnitById(Long.valueOf(String.valueOf(m.get("ownerId")))) == null) {
                rellist.add(m);
                continue;
            }
            if (isGroupAdmin || isAdministrator || isHrAdmin) {
                if (!unit.getOrgAccountId().equals(accountId)) {
                    continue;
                }
            }else if(isDeptAdmin){
            	//如果只是部门管理员,能看到 所属范围是 管理的所有的部门及其子部门下的组
            	if(deptIds.indexOf(String.valueOf(m.get("ownerId")))<0){
            		continue;
            	}
            }
            else {
                String currentdeptid=String.valueOf(orgManager.getCurrentDepartment().getId());
                if (!String.valueOf(m.get("ownerId")).equals(currentdeptid)&&!String.valueOf(m.get("createrId")).equals(currentdeptid)) {
                    continue;
                }
            }

            rellist.add(m);
        }

        DBAgent.memoryPaging(rellist, fi);
        
        Map<Long,List<V3xOrgMember>> leaderMap = getTeamsLeader(accountId);

        List result = new ArrayList();
        for (Object m : fi.getData()) {
            V3xOrgTeam team = orgManager.getTeamById(Long.valueOf(((HashMap) m).get("id").toString()));
            if (orgManager.isEmptyTeamScope(team)) {
                ((HashMap) m).put("scope", "2");
            } else {
                ((HashMap) m).put("scope", "1");
            }
            List teamLeader = leaderMap.get(team.getId());
            
            if (teamLeader!=null && teamLeader.size() > 0) {
                String names = OrgHelper.showOrgEntities(teamLeader, "id", "entityType", null);
                ((HashMap) m).put("teamLeader", names);
            } else {
                ((HashMap) m).put("teamLeader", "");
            }
            result.add(m);
        }
        fi.setData(result);


        return fi;
    }
    
    private Map<String,Map<String,String>> getEntityMap(String typeAndIds) throws BusinessException {
    	
    	String[] items = typeAndIds.split(V3xOrgEntity.ORG_ID_DELIMITER);
    	
    	Map<String,Map<String,String>> map = new LinkedHashMap<String,Map<String,String>>(items.length);
    	
        for (String item : items) {
        	Map<String,String> m = new HashMap<String,String>();
        	
        	String[] data = item.split("[|]");

            if (data.length < 2) {
                throw new BusinessException("参数格式不正确 [" + item + "]; 正确的格式应该为 [Member|5129341885565]");
            }
            String type = data[0].toString();
            String id = data[1];
            String include = "0";
            if(data.length==3){
            	include = data[2];
            }else if(data.length==6){
            	include = data[5];
            }
            m.put("type", type);
            m.put("include", include);
            map.put(id, m);
        }

        return map;
    }
    
    private Map<Long,List<V3xOrgMember>> getTeamsLeader(Long accountId) throws BusinessException {
    	Map<Long,List<V3xOrgMember>> map = new HashMap<Long, List<V3xOrgMember>>();
    	EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.TeamMemberType.Leader.name());
    	List<V3xOrgRelationship> rellist = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Team_Member, null, accountId, enummap);
    	for (V3xOrgRelationship orgRelationship : rellist) {
    		Long teamId = Long.valueOf(orgRelationship.getSourceId());
    		if(!map.containsKey(teamId)){
    			map.put(teamId, new UniqueList<V3xOrgMember>());
    		}
    		List<V3xOrgMember> memberList = map.get(teamId);
    		memberList.add(orgManager.getMemberById(orgRelationship.getObjective0Id()));
		}
    	return map;
    }

}
