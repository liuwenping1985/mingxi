package com.seeyon.ctp.organization.manager;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.OrgTypeIdBO;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
public class DistributeManagerImpl implements DistributeManager {
    private final static Log   logger = LogFactory.getLog(DistributeManagerImpl.class);
    protected OrgCache         orgCache;
    protected OrgDao           orgDao;
    protected OrgManagerDirect orgManagerDirect;
    protected OrgManager       orgManager;
    protected PrincipalManager principalManager;
    protected AppLogManager    appLogManager;
    
	public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

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

    @Override
    public HashMap addTeam() throws BusinessException {
        Integer maxSortNum = orgManagerDirect.getMaxSortNum(V3xOrgTeam.class.getSimpleName(),
                AppContext.currentAccountId());
        HashMap m = new HashMap();
        m.put("sortId", maxSortNum + 1);
        return m;
    }

	@Override
    public Long saveTeam(Map team) throws BusinessException {
        V3xOrgTeam newteam = new V3xOrgTeam();

        String ownerId = String.valueOf(team.get("ownerId"));
        if (ownerId != null && ownerId.contains("|")) {
            ownerId = ownerId.split("\\|")[1];
        } else {
            ownerId = String.valueOf(AppContext.currentAccountId());
        }
        team.put("ownerId", ownerId);
        ParamUtil.mapToBean(team, newteam, false);

        // 排序号的重复处理
        String isInsert = team.get("sortIdtype").toString();
        if ("1".equals(isInsert)
                && orgManagerDirect.isPropertyDuplicated(V3xOrgTeam.class.getSimpleName(), "sortId", newteam.getSortId())) {
            orgManagerDirect.insertRepeatSortNum(V3xOrgTeam.class.getSimpleName(), AppContext.currentAccountId(),
                    newteam.getSortId(), null);
        }
        if (newteam.getId() == null) {
            newteam.setIdIfNew();
            newteam.setOwnerId(Long.valueOf(ownerId));
            newteam.setOrgAccountId(AppContext.currentAccountId());
            dealTeamMembers(team, newteam);
            orgManagerDirect.addTeam(newteam);

        } else {
            dealTeamMembers(team, newteam);
            orgManagerDirect.updateTeam(newteam);
        }

        // 增加组的公开范围
        List scopelist = new ArrayList();
        // 私有组，范围是人员自己

        scopelist.add(orgManager.getMemberById(AppContext.currentUserId()));

        // 公开组，范围读取
        if ("1".equals(team.get("scope").toString())) {
            scopelist.addAll(orgManager.getEntities(team.get("scopein").toString()));
        }
        orgManagerDirect.addTeamScope(scopelist, newteam);
        return newteam.getId();
    }

    /**
     * 处理组成员，一定要在送入接口前将组员组装好放在Team对象里面
     * @param team
     * @param newteam
     * @throws BusinessException
     */
    private void dealTeamMembers(Map team, V3xOrgTeam newteam) throws BusinessException {
        // 增加组的各种类型人员
        if (team.get("teamLeader") != null) {
            List list = orgManager.getEntities(team.get("teamLeader").toString());
            orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.Leader.name());
            newteam.setLeaders(OrgHelper.entityListToIdTypeList(list));
        }
        if (team.get("teamMember") != null) {
            List list = orgManager.getEntities(team.get("teamMember").toString());
            orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.Member.name());
            newteam.setMembers(OrgHelper.entityListToIdTypeList(list));
        }
        if (team.get("teamSuperVisor") != null) {
            List list = orgManager.getEntities(team.get("teamSuperVisor").toString());
            orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.SuperVisor.name());
            newteam.setSupervisors(OrgHelper.entityListToIdTypeList(list));
        }
        if (team.get("teamRelative") != null) {
            List list = orgManager.getEntities(team.get("teamRelative").toString());
            orgManagerDirect.addTeamMembers(list, newteam, OrgConstants.TeamMemberType.Relative.name());
            newteam.setRelatives(OrgHelper.entityListToIdTypeList(list));
        }
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public String deleteMember(List<Map<String, Object>> Member) throws BusinessException {
        List<V3xOrgMember> memberlist = new ArrayList<V3xOrgMember>();
        for (Map<String, Object> member : Member) {
            memberlist.add(orgManager.getMemberById(Long.valueOf(member.get("id").toString())));
        }
        // memberlist = ParamUtil.mapsToBeans(Member, V3xOrgMember.class,
        // false);
        OrganizationMessage mes = orgManagerDirect.deleteMembers(memberlist);
        OrgHelper.throwBusinessExceptionTools(mes);

        //日志信息                
        List<String[]> appLogs = new ArrayList<String[]>();
        User user = AppContext.getCurrentUser();
        for (V3xOrgMember member1 : memberlist) {
            String[] appLog = new String[2];
            appLog[0] = user.getName();
            appLog[1] = member1.getName();
            appLogs.add(appLog);
        }
        appLogManager.insertLogs(user, AppLogAction.Organization_DeleteCancelMember, appLogs);

        return null;

    }

	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
	public void saveDistributeMessage(List<Map<String, Object>> Member,
			String accId) throws BusinessException {

		// 获得单位 ID
		Long accountId = Long.parseLong(accId.split("\\|")[1]);
		User user = AppContext.getCurrentUser();

		for (Map<String, Object> map : Member) {
			
			Long memberId = Long.valueOf(String.valueOf(map.get("id")));
			V3xOrgMember member = orgManager.getMemberById(memberId);
			
			member.setIsAssigned(true);
			// 重新分配人员后其排序号变为最大
			member.setSortId(Long.valueOf((orgManagerDirect.getMaxSortNum(
					V3xOrgMember.class.getSimpleName(), accountId) + 1)));
			
			//无论是否重新调回到原单位，都清除之前的信息。
			member.setOrgAccountId(accountId);
			V3xOrgLevel lev = orgManager.getLowestLevel(accountId);
			if (lev != null) {
				member.setOrgLevelId(lev.getId());
			} else {
				member.setOrgLevelId(V3xOrgEntity.DEFAULT_NULL_ID);
			}
			member.setOrgPostId(V3xOrgEntity.DEFAULT_NULL_ID);
			member.setOrgDepartmentId(V3xOrgEntity.DEFAULT_NULL_ID);
			member.setEnabled(false);
			// member.setSecond_post(new ArrayList<MemberPost>());
			orgDao.deleteOrgRelationshipPO(null, member.getId(), null, null);

			// 移动个人组
			List<V3xOrgTeam> allTeams = orgManager.getAllTeams(null);
			for (V3xOrgTeam team : allTeams) {
				if (!team.getOwnerId().equals(member.getId()))
					continue;
				if (team.getOrgAccountId().equals(accountId))
					continue;
				
				initTeam(team); //取所有的组成员，包括无效的
				team.setOrgAccountId(accountId);
				
				orgManagerDirect.updateTeam(team);
			}

			member.setEnabled(false);
			orgManagerDirect.updateMember(member);
			
			//日志信息                
			V3xOrgAccount account = orgManager.getAccountById(accountId);
	        appLogManager.insertLog(user, AppLogAction.Organization_OrgMember, user.getName(),member.getName(),account.getName());
		}
	}
	
	
	private void initTeam(V3xOrgTeam team){
	    List<V3xOrgRelationship> ents = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Team_Member, team.getId(), null, null);
        for (V3xOrgRelationship ent : ents) {
            OrgTypeIdBO typeIdBO = new OrgTypeIdBO();
            typeIdBO.setId(ent.getObjective0Id());
            typeIdBO.setType(ent.getObjective6Id());
            typeIdBO.setInclude(ent.getObjective7Id());
            
            team.addTeamMember(typeIdBO, OrgConstants.TeamMemberType.valueOf(ent.getObjective5Id()).ordinal());
        }
	}

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public FlipInfo showDistributeList(FlipInfo fi, Map params) throws BusinessException {
        orgDao.getAllUnAssignedMember(null, fi, params);
        List list = fi.getData();
        List<HashMap<String, String>> rellist = new ArrayList<HashMap<String, String>>();
        for (Object object : list) {
            HashMap<String, String> m = new HashMap<String, String>();
            OrgMember member = (OrgMember) object;
            ParamUtil.beanToMap(member, m, true);
            V3xOrgMember v3xmember = (V3xOrgMember) OrgHelper.poTobo(member);
            m.put("loginName", v3xmember.getLoginName());
            if (!"".equals(m.get("orgAccountId"))) {
                V3xOrgAccount a = orgManager.getAccountById(Long.valueOf(m.get("orgAccountId").toString()));
                if (null != a) {
                    m.put("orgAccountIdname", a.getName());
                } else {
                    m.put("orgAccountIdname", "");
                }
            }
            if (!"".equals(m.get("orgDepartmentId"))) {
                V3xOrgDepartment d = orgManager.getDepartmentById(Long.valueOf(m.get("orgDepartmentId").toString()));
                if (null != d) {
                    m.put("orgDepartmentIdname", d.getName());
                } else {
                    m.put("orgDepartmentIdname", "");
                }
            }
            if (!"".equals(m.get("orgPostId"))) {
                V3xOrgPost p = orgManager.getPostById(Long.valueOf(m.get("orgPostId").toString()));
                if (null != p) {
                    m.put("orgPostIdname", p.getName());
                } else {
                    m.put("orgPostIdname", "");
                }
            }
            if (!"".equals(m.get("orgLevelId"))) {
                V3xOrgLevel l = orgManager.getLevelById(Long.valueOf(m.get("orgLevelId").toString()));
                if (null != l) {
                    m.put("orgLevelIdname", l.getName());
                } else {
                    m.put("orgLevelIdname", "");
                }
            }
            rellist.add(m);

        }
        fi.setData(rellist);
        return fi;
    }

}
