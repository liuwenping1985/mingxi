package com.seeyon.ctp.organization.manager;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.IConfigPublicKey;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.MemberPostType;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.CompareSortWebEntity;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.MemberRole;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.event.DeleteConCurrentPostEvent;
import com.seeyon.ctp.organization.po.OrgRelationship;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgConcurrentPost;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgSecondPost;
import com.seeyon.ctp.permission.bo.DelConPostResult;
import com.seeyon.ctp.privilege.manager.PrivilegeMenuManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

/**
 * <p>Title: 人员兼职管理信息业务层接口实现类</p>
 * <p>Description: 提供兼职管理外部功能的Manager接口</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 * @author lilong
 */
public class ConcurrentPostManagerImpl implements ConcurrentPostManager {

    private final static Log    logger                   = LogFactory.getLog(ConcurrentPostManagerImpl.class);
    private Long virtualGroupAccountId = null;
    protected OrgDao            orgDao;
    protected OrgCache          orgCache;
    protected OrgManagerDirect  orgManagerDirect;
    protected OrgManager        orgManager;
    protected AppLogManager     appLogManager;
    protected PrivilegeMenuManager privilegeMenuManager;
    /**兼职信息不完整显示的字符串*/
    private final static String NULL_CONCURRENTPOST_INFO = "--";
    
    private ConfigManager configManager;
    
    public void setConfigManager(ConfigManager configManager) {
		this.configManager = configManager;
	}

    public void setOrgDao(OrgDao orgDao) {
        this.orgDao = orgDao;
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
    
    public void setVirtualGroupAccountId(Long virtualGroupAccountId){
    	this.virtualGroupAccountId = virtualGroupAccountId;
    }

    @Override
    //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public FlipInfo list4in(FlipInfo fi, Map params) throws BusinessException {
        Long currentAccountId = AppContext.currentAccountId();
        EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(
                RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, MemberPostType.Concurrent.name());
        Long postId = null;
        Long accountId = null;
        String cMemberName = null;
        /**************************/
        //查询条件
        String condition = String.valueOf(params.get("condition"));
        Object value = params.get("value") == null ? "" : params.get("value");
        //选人界面过来的查询条件和值
        if ("cMemberName".equals(condition)) {//兼职人员名称
            cMemberName = String.valueOf(value);
        } else if ("cCode".equals(condition)) {//兼职编号
            if(Strings.isNotBlank(String.valueOf(value))) {
                enummap.put(OrgConstants.RelationshipObjectiveName.objective6Id, String.valueOf(value));
            }
        } else if ("sAccount".equals(condition)) {//原单位
            String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
            String[] strs = str.trim().split(",");
            if (strs.length != 0 && Strings.isNotBlank(strs[1])) {
                String[] strs2 = strs[1].split("[|]");
                accountId = Long.valueOf(strs2[1].trim());
            }
        } else if("cPost".equals(condition)) {//兼职岗位
            String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
            String[] strs = str.trim().split(",");
            if (strs.length != 0 && Strings.isNotBlank(strs[1])) {
                String[] strs2 = strs[1].split("[|]");
                enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, Long.valueOf(strs2[1].trim()));
            }
        }
        /******************************/
        List<OrgRelationship> relationships = orgDao.getOrgRelationshipPO4ConPost(cMemberName, postId, accountId, currentAccountId, enummap,false,null, null);
        List<WebV3xOrgConcurrentPost> resultConcurrentPosts = this.dealFilpInfoData(relationships);
        DBAgent.memoryPaging(resultConcurrentPosts, fi);

        return fi;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public FlipInfo list4out(FlipInfo fi, Map params) throws BusinessException {
        Long currentAccountId = AppContext.currentAccountId();
        EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(
                RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, MemberPostType.Concurrent.name());

        Long postId = null;
        Long accountId = currentAccountId;
        Long conAccountId = null;
        String cMemberName = null;
        /**************************/
//        boolean isNullValue = false;//用于防护按主岗查询，主岗下没有人导致查询结果不正确
        //查询条件
        String condition = String.valueOf(params.get("condition"));
        Object value = params.get("value") == null ? "" : params.get("value");
        //选人界面过来的查询条件和值
        if ("cMemberName".equals(condition)) {//兼职人员名称
            cMemberName = String.valueOf(value);
        } else if ("cCode".equals(condition)) {//兼职编号
            if(Strings.isNotBlank(String.valueOf(value))) {
                enummap.put(OrgConstants.RelationshipObjectiveName.objective6Id, String.valueOf(value));
            }
        } else if ("cAccount".equals(condition)) {//兼职单位
            String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
            String[] strs = str.trim().split(",");
            if (strs.length != 0 && Strings.isNotBlank(strs[1])) {
                String[] strs2 = strs[1].split("[|]");
                conAccountId = Long.valueOf(strs2[1].trim());
            }
        } else if ("cPost".equals(condition)) {//兼职岗位
            String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
            String[] strs = str.trim().split(",");
            if (strs.length != 0 && Strings.isNotBlank(strs[1])) {
                String[] strs2 = strs[1].split("[|]");
                enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, Long.valueOf(strs2[1].trim()));
            }
        } else if ("post".equals(condition)) {//主岗
            String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
            String[] strs = str.trim().split(",");
            if (strs.length != 0 && Strings.isNotBlank(strs[1])) {
                String[] strs2 = strs[1].split("[|]");
                postId = Long.valueOf(strs2[1].trim());
            }
        }
        /******************************/
        List<OrgRelationship> relationships = orgDao.getOrgRelationshipPO4ConPost(cMemberName, postId, accountId, conAccountId, enummap,false,null, null);
        List<WebV3xOrgConcurrentPost> resultConcurrentPosts = this.dealFilpInfoData(relationships);
        DBAgent.memoryPaging(resultConcurrentPosts, fi);

        return fi;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
    public FlipInfo list4Manager(FlipInfo fi, Map params) throws BusinessException {
        EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(
                RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, MemberPostType.Concurrent.name());

        //查询条件
        String condition = String.valueOf(params.get("condition"));
        Object value = params.get("value") == null ? "" : params.get("value");

        Long accountId = null;
        Long postId = null;
        Long conAccountId = null;

        //选人界面过来的查询条件和值
        if ("cMemberName".equals(condition)) {//兼职人员名称
            //OA-44787
            List<OrgRelationship> relationships = orgDao.getOrgRelationshipPOByMemberName(String.valueOf(value), fi,"list4Manager",null);
            List<WebV3xOrgConcurrentPost> resultConcurrentPosts = this.dealFilpInfoData(relationships);
            fi.setData(resultConcurrentPosts);
            return fi;
        }
        else if ("cAccount".equals(condition)) {//兼职单位
        	conAccountId = getValue(params);
        }
        else if ("sAccount".equals(condition)) {//原单位
        	accountId = getValue(params);
        }
        
        List<OrgRelationship> relationships = orgDao.getOrgRelationshipPO4ConPost(null, postId, accountId, conAccountId, enummap,false,null, null);
        List<WebV3xOrgConcurrentPost> resultConcurrentPosts = this.dealFilpInfoData(relationships);
        DBAgent.memoryPaging(resultConcurrentPosts, fi);
        return fi;
    }

    private Long getValue(Map params) {
        List<String> strs = (List<String>)params.get("value");
        if (Strings.isEmpty(strs)) {
            return null;
        }
        
        String[] strs2 = strs.get(1).split("[|]");
        
        if(strs2 == null || strs2.length <= 1){
            return null;
        }
        
        return Long.valueOf(strs2[1].trim());
    }

    @Override
    //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void updateOne(Map map) throws BusinessException {
    	Long id = Long.valueOf(String.valueOf(map.get("id")));
        //先判断兼职是否重复 //OA-52344
        this.checkDupliateConpost(map);
        //关系维护----原则先删除再新建
        map.put("isNew", false);

        //V3xOrgRelationship rel = orgManager.getEntityById(V3xOrgRelationship.class, id);
        OrgRelationship rel = orgDao.getEntity(OrgRelationship.class, id);
        if(null == rel) {
            throw new BusinessException("兼职信息不存在!");
        }
        HashMap<String, Object> mapOld = new HashMap<String, Object>();
        mapOld.put("cAccountId", rel.getOrgAccountId());
        mapOld.put("cDeptId", rel.getObjective0Id()==null?Long.valueOf(-1):rel.getObjective0Id());
        mapOld.put("cPostId", rel.getObjective1Id());
        mapOld.put("cLevelId", rel.getObjective2Id()==null?Long.valueOf(-1):rel.getObjective2Id());
        if(!rel.getOrgAccountId().equals(Long.valueOf(String.valueOf(map.get("cAccountId"))))) {
        	int cSort = orgManager.getMaxMemberSortByAccountId(Long.valueOf(String.valueOf(map.get("cAccountId"))));
        	mapOld.put("sortId", cSort+1);
        }else{
        	mapOld.put("sortId", (rel.getSortId()==null||rel.getSortId().equals(Long.valueOf(1)))?Integer.valueOf(1):rel.getSortId());
        }
        //应用日志
        User user = AppContext.getCurrentUser();
        V3xOrgMember member = orgManager.getMemberById(rel.getSourceId());

        //兼职部门变化了
        if (!Strings.equals(String.valueOf(mapOld.get("cDeptId")), String.valueOf(map.get("cDeptId")))) {
            String odeptId = String.valueOf(mapOld.get("cDeptId"));
            String ndeptId = String.valueOf(map.get("cDeptId"));
            appLogManager.insertLog(user, 843, user.getName(), member.getName(),
                    isNotLegal(odeptId)?"":orgManager.getDepartmentById(Long.valueOf(odeptId)).getName(),
                            isNotLegal(ndeptId)?"":orgManager.getDepartmentById(Long.valueOf(ndeptId)).getName());
        }
        //兼职崗位变化了
        if (!Strings.equals(String.valueOf(mapOld.get("cPostId")), String.valueOf(map.get("cPostId")))) {
            String opostId = String.valueOf(mapOld.get("cPostId"));
            String npostId = String.valueOf(map.get("cPostId"));
            appLogManager.insertLog(user, 844, user.getName(), member.getName(),
                    isNotLegal(opostId)?"":orgManager.getPostById(Long.valueOf(opostId)).getName(),
                            isNotLegal(npostId)?"":orgManager.getPostById(Long.valueOf(npostId)).getName());
        }
        //兼职職務变化了
        if (!Strings.equals(String.valueOf(mapOld.get("cLevelId")), String.valueOf(map.get("cLevelId")))) {
            String olevelId = String.valueOf(mapOld.get("cLevelId"));
            String nlevelId = String.valueOf(map.get("cLevelId"));
            appLogManager.insertLog(user, 845, user.getName(), member.getName(),
                    isNotLegal(olevelId)?"":orgManager.getLevelById(Long.valueOf(olevelId)).getName(),
                            isNotLegal(nlevelId)?"":orgManager.getLevelById(Long.valueOf(nlevelId)).getName());
        }
        //兼职單位变化了
        if (!Strings.equals(String.valueOf(mapOld.get("cAccountId")), String.valueOf(map.get("cAccountId")))) {
            String oaccId = String.valueOf(mapOld.get("cAccountId"));
            String naccId = String.valueOf(map.get("cAccountId"));
            appLogManager.insertLog(user, 847, user.getName(), member.getName(),
                    isNotLegal(oaccId)?"":orgManager.getAccountById(Long.valueOf(oaccId)).getName(),
                            isNotLegal(oaccId)?"":orgManager.getAccountById(Long.valueOf(naccId)).getName());
        }
        //兼职角色变化了
        String[] s = getRoleNameAndId(rel,rel.getOrgAccountId());
        String roleIds = (String)map.get("cRoleIds");
        Set<Long> newRoleIds = new HashSet<Long>();
        Set<Long> oldRoleIds = new HashSet<Long>();
        StringBuilder newRoleNames = new StringBuilder();
        if(null != map.get("cRoleIds")
                && Strings.isNotBlank((String)map.get("cRoleIds"))) {
            String[] roles = roleIds.split(",");
            for (String roleId : roles) {
                newRoleNames.append(orgManager.getRoleById(Long.valueOf(roleId.trim())).getShowName()).append("、");
                newRoleIds.add(Long.valueOf(roleId.trim()));
            }
        }
        for(String roleId:s[1].split(",")){
            if(!isNotLegal(roleId)){
                oldRoleIds.add(Long.valueOf(roleId.trim()));
            }
        }
        if(!newRoleIds.equals(oldRoleIds)){
            String onames=s[0];
            String nnames=newRoleNames.toString();;
            appLogManager.insertLog(user, 846, user.getName(),member.getName(),
                    onames,nnames.substring(0, nnames.length()-1));
        }
        //更新菜单缓存
        privilegeMenuManager.updateMemberMenuLastDate(member.getId(), Long.parseLong(String.valueOf(map.get("cAccountId"))));
/*        if(!rel.getOrgAccountId().equals(Long.valueOf(String.valueOf(map.get("cAccountId"))))) {
            //OA-31769 1.删除兼职信息时删除这个人在所在兼职单位，兼职部门的所有部门角色
            if(null != rel && null != rel.getObjective0Id()) {
                EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                        OrgConstants.RelationshipObjectiveName.class);
                objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, rel.getObjective0Id());
                orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), rel.getSourceId(), rel.getOrgAccountId(), objectiveIds);

                //OA-52559 删除起所有父部门所担当的部门角色
                V3xOrgDepartment  v3xOrgDepartment= orgManager.getDepartmentById(rel.getObjective0Id());
                List<V3xOrgDepartment> depts = new ArrayList<V3xOrgDepartment>();
                if(null != v3xOrgDepartment){
                    depts = orgManager.getAllParentDepartments(rel.getObjective0Id());
                }
                for (V3xOrgDepartment d : depts) {
                    EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds2 = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                            OrgConstants.RelationshipObjectiveName.class);
                    objectiveIds2.put(OrgConstants.RelationshipObjectiveName.objective0Id, d.getId());
                    orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), rel.getSourceId(), rel.getOrgAccountId(), objectiveIds2);
                }
            }
        }*/
        
        //如果修改兼职信息后，这个人在这个单位再无有效的兼职信息（部门岗位信息没有设置），清除这个人之前在这个单位设置过所有的部门角色
        //1.单位管理员清除部门或者岗位信息
        //2.集团管理员修改了单位信息
        {
        	boolean isEnable = false;       
        	OrgConstants.MemberPostType[] postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Concurrent};
        	List<V3xOrgRelationship> rels = this.orgCache.getMemberPostRelastionships(member.getId(), rel.getOrgAccountId(), postType);
        	for(V3xOrgRelationship memberPostRel : rels){
        		if(memberPostRel.getId().equals(id)){
        			if(Strings.isNotBlank(String.valueOf(map.get("cDeptId")))
        					&& Strings.isNotBlank(String.valueOf(map.get("cPostId")))
        					&& Strings.isNotBlank(String.valueOf(map.get("cAccountId")))
        					&& rel.getOrgAccountId().equals(Long.valueOf(String.valueOf(map.get("cAccountId"))))
        					){
        				isEnable = true;
        				break;
        			}
        		}else{
        			if(memberPostRel.getObjective0Id()!=null && memberPostRel.getObjective1Id()!=null){
        				isEnable = true;
        				break;
        			}
        		}
        	}
        	
        	//删除这个人在这个单位下的部门角色
        	if(!isEnable){
        		List<MemberRole> memberAllRole = orgManager.getMemberRoles(rel.getSourceId(),null);
        		for (MemberRole memberRole : memberAllRole) {
        			if(!rel.getOrgAccountId().equals(memberRole.getAccountId())){
        				continue;
        			}
        			
        			if(null!=memberRole.getDepartment()){
        				EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
        						OrgConstants.RelationshipObjectiveName.class);
        				objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, memberRole.getDepartment().getId());
        				orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), member.getId(),rel.getOrgAccountId(), objectiveIds);
        			}
        		}
        	}
        }
        	  
        //先删除这个老兼职信息的所选择的兼职角色
        this.deleteConRoles(rel.getSourceId(), rel.getOrgAccountId());
        //UC需求--删除兼职分发事件
        orgManagerDirect.deleteRelationById(id);
        map.put("createTime", rel.getCreateTime());
        map.put("createUserID", rel.getObjective3Id());
        this.createOne(map);
        V3xOrgRelationship r = new V3xOrgRelationship(rel);
        DeleteConCurrentPostEvent event = new DeleteConCurrentPostEvent(this);
        event.setRel(r);
        EventDispatcher.fireEvent(event);
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void createOne(Map map) throws BusinessException {
        //新建这个信息
        MemberPost m = new MemberPost();
        //cMember兼职人员--必填项
        Long memberId = Long.valueOf(String.valueOf(map.get("cMemberId")));
        //cCode兼职编号--非必填
        String cCode = String.valueOf(map.get("code")==null?"":map.get("code"));
        //cAccountId兼职--必填项
        Long cAccountId = Long.valueOf(String.valueOf(map.get("cAccountId")));
        //cSortId兼职排序号
        int cSort = orgManager.getMaxMemberSortByAccountId(cAccountId)+1;
        //boolean isCSort = false;
        if(null != map.get("sortId") && Strings.isNotBlank(String.valueOf(map.get("sortId")))) {
            //isCSort = true;
            cSort = Integer.valueOf(String.valueOf(map.get("sortId")).trim());
        }
        //cPost兼职岗位--非必填项
        Long cPostId = null;
        if(null != map.get("cPostId")
                && Strings.isNotBlank(String.valueOf(map.get("cPostId")))) {
            cPostId = Long.valueOf(String.valueOf(map.get("cPostId")));
            //V3xOrgPost cPostBO = orgManager.getPostById(cPostId);
           // if(!isCSort) cSort = cPostBO.getSortId().intValue();
        }
        //cLevelId兼职职务级别--非必填
        Long cLevelId = null;
        if(null != map.get("cLevelId")
                && Strings.isNotBlank(String.valueOf(map.get("cLevelId")))) {
            cLevelId = Long.valueOf(String.valueOf(map.get("cLevelId")));
        }
        //cDept兼职部门--非必填项
        Long cDeptId = null;
        if(null != map.get("cDeptId")
                && Strings.isNotBlank((String)map.get("cDeptId"))) {
            cDeptId = Long.valueOf(String.valueOf(map.get("cDeptId")));
        }
        //cRoles兼职角色--必填项
        String roleIds = (String)map.get("cRoleIds");
        if(null != map.get("cRoleIds")
                && Strings.isNotBlank((String)map.get("cRoleIds"))) {
            String[] roles = roleIds.split(",");
            List<Long> rIds = new ArrayList<Long>();
            V3xOrgMember member = orgManager.getMemberById(memberId);
            for (String roleId : roles) {
                rIds.add(Long.valueOf(roleId.trim()));
            }
            //先删除
            this.deleteConRoles(memberId, cAccountId);
            //再新建
            orgManagerDirect.addConcurrentRoles2Entity(rIds, cAccountId, member);
        }
        //兼职信息重复的判断
        EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                OrgConstants.RelationshipObjectiveName.class);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, cDeptId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective1Id, cPostId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective2Id, cLevelId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Concurrent.name());
        //兼职信息重复的判断
        this.checkDupliateConpost(map);
        //创建兼职关系
        m = MemberPost.createConcurrentPost(memberId, cDeptId, cPostId, cLevelId, cAccountId, cSort, cCode, roleIds);
        Object createTime=map.get("createTime");
        if(null!=createTime && !"".equals(createTime)){
        	m.setCreateTime((Date)map.get("createTime"));
        }
        Object createUserID = map.get("createUserID");
        if(null != createUserID && !"".equals(createUserID)){
        	m.setCreateUserID((Long)map.get("createUserID"));
        }
        orgManagerDirect.addConurrentPost(m);

        //兼职管理，多条兼职管理信息，以最后一次修改或新建的职务级别为准
        if(null != cLevelId) {
            EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds2 = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                    OrgConstants.RelationshipObjectiveName.class);
            objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Concurrent.name());
            List<V3xOrgRelationship> preConRelationShips = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, memberId, cAccountId, objectiveIds2);
            for (V3xOrgRelationship pShip : preConRelationShips) {
                pShip.setObjective2Id(cLevelId);
                orgManagerDirect.updateV3xOrgRelationship(pShip);
            }
        }
        //应用日志
        User user = AppContext.getCurrentUser();
        V3xOrgMember member = orgManager.getMemberById(memberId);
        V3xOrgAccount account = orgManager.getAccountById(cAccountId);
        if (null == map.get("isNew") || (Boolean) map.get("isNew")) {
            appLogManager.insertLog(user, AppLogAction.Organization_GroupAdminAddCntPost, member.getName(),
                    account.getName(), user.getName());
        } else {
            appLogManager.insertLog(user, AppLogAction.Organization_GroupAdminUpdateCntPost, member.getName(),
                    account.getName(), user.getName());
        }
        privilegeMenuManager.updateMemberMenuLastDate(member.getId(), cAccountId);
    }

    /**
     * 校验兼职信息重复
     * @param map
     * @throws BusinessException
     */
    private void checkDupliateConpost(Map map) throws BusinessException {
        Long id = Long.valueOf(String.valueOf(map.get("id")));
        Long memberId = Long.valueOf(String.valueOf(map.get("cMemberId")));
        Long cAccountId = Long.valueOf(String.valueOf(map.get("cAccountId")));
        Long cPostId = null;
        if(null != map.get("cPostId")
                && Strings.isNotBlank(String.valueOf(map.get("cPostId")))) {
            cPostId = Long.valueOf(String.valueOf(map.get("cPostId")));
        }
        Long cLevelId = null;
        if(null != map.get("cLevelId")
                && Strings.isNotBlank(String.valueOf(map.get("cLevelId")))) {
            cLevelId = Long.valueOf(String.valueOf(map.get("cLevelId")));
        }
        Long cDeptId = null;
        if(null != map.get("cDeptId")
                && Strings.isNotBlank((String)map.get("cDeptId"))) {
            cDeptId = Long.valueOf(String.valueOf(map.get("cDeptId")));
        }
        EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                OrgConstants.RelationshipObjectiveName.class);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, cDeptId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective1Id, cPostId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective2Id, cLevelId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Concurrent.name());

        List<V3xOrgRelationship> oldCon = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, memberId, cAccountId, objectiveIds);
        List<V3xOrgRelationship> resultList = new ArrayList<V3xOrgRelationship>();

        for (V3xOrgRelationship orgRel : oldCon) {
            if(orgRel.getId().equals(id)) {
                continue;//OA-53658
            } else {
                if(Strings.equals(orgRel.getObjective0Id(),cDeptId) && Strings.equals(orgRel.getObjective1Id(),cPostId) &&
                        Strings.equals(orgRel.getObjective2Id(),cLevelId)){
                    resultList.add(orgRel);
                }
            }
        }
        if(Strings.isNotEmpty(resultList)) {
            String message = ResourceUtil.getString("cntPost.cntPost.repeated");
            throw new BusinessException(message);
        } else {
            return;
        }
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public Map<String,Object> delConPosts(Long[] ids) throws BusinessException {
    	Map<String,Object> map = new HashMap<String, Object>();
    	List<DelConPostResult> delConPostList = new ArrayList<DelConPostResult>();
    	int allCount = 0;
    	int failCount = 0;
        User user = AppContext.getCurrentUser();
        for (Long id : ids) {
        	allCount ++;
            V3xOrgRelationship rel = orgManager.getV3xOrgRelationshipById(id);
            V3xOrgMember member = null;
            if (null != rel) {
                member = orgManager.getMemberById(rel.getSourceId());
                V3xOrgAccount account = orgManager.getAccountById(rel.getOrgAccountId());
            	String includeUnitId = getIncludeUnitIds();
            	if(Strings.isNotBlank(includeUnitId) && includeUnitId.indexOf(account.getId()+"") == -1){
            		DelConPostResult conPostResult = new DelConPostResult();
            		conPostResult.setUserName(member.getName());
            		V3xOrgAccount sourceAccount =  orgManager.getAccountById(member.getOrgAccountId());
            		conPostResult.setSourceUnitName(sourceAccount.getName());
            		conPostResult.setTargetUnitName(account.getName());
            		delConPostList.add(conPostResult);
            		failCount++;
            		continue;
            	}
                //删除本条兼职所设置的兼职角色
                //this.deleteConRoles(rel.getSourceId(), rel.getOrgAccountId(), rel.getObjective7Id());
                this.deleteConRolesForDel(rel.getSourceId(), rel.getOrgAccountId());

                //为了防止有另外的兼职与这个人的兼职角色有交集，再删除他的角色后再补充新建一次
                this.dealOtherConRoles(id, rel.getSourceId(), rel.getOrgAccountId());

                //记录审计日志
                appLogManager.insertLog(user, AppLogAction.Organization_GroupAdminDeleteCntPost, member.getName(),
                        account.getName(), user.getName());
            }

            //OA-31769 1.删除兼职信息时删除这个人在所在兼职单位，兼职部门的所有部门角色
/*            if(null != rel && null != rel.getObjective0Id()) {
                EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                        OrgConstants.RelationshipObjectiveName.class);
                objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, rel.getObjective0Id());
                orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), rel.getSourceId(), rel.getOrgAccountId(), objectiveIds);

                //OA-52559 删除起所有父部门所担当的部门角色
                List<V3xOrgDepartment> depts = orgManager.getAllParentDepartments(rel.getObjective0Id());
                for (V3xOrgDepartment d : depts) {
                    EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds2 = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                            OrgConstants.RelationshipObjectiveName.class);
                    objectiveIds2.put(OrgConstants.RelationshipObjectiveName.objective0Id, d.getId());
                    //修改主岗方法 steven
                    // OA-61578 如果兼职人员同时兼职子部门和父部门，如果删除子部门的兼职信息，则在父部门的角色也被清除了，错误
                    objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Concurrent.name());
                    List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, member.getId(), rel.getOrgAccountId(), objectiveIds);
                    if(member!=null && d.getId().equals(member.getOrgDepartmentId())){
                        MemberPost memberPost = MemberPost.createMainPost(member);
                        rels.add(memberPost.toRelationship());
                    }
                    if(rels.size() > 0) {
                        continue;
                    }
                    orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), rel.getSourceId(), rel.getOrgAccountId(), objectiveIds2);
                }
            }*/
            
            //如果删除兼职信息后，这个人在这个单位再无有效的兼职信息（部门岗位信息没有设置），清除这个人之前在这个单位设置过所有的部门角色
            {
            	boolean isEnable = false;       
            	OrgConstants.MemberPostType[] postType = new OrgConstants.MemberPostType[]{OrgConstants.MemberPostType.Concurrent};
            	List<V3xOrgRelationship> rels = this.orgCache.getMemberPostRelastionships(member.getId(), rel.getOrgAccountId(), postType);
            	for(V3xOrgRelationship memberPostRel : rels){
            		if(memberPostRel.getId().equals(id)){
            			continue;
            		}else{
            			if(memberPostRel.getObjective0Id()!=null && memberPostRel.getObjective1Id()!=null){
            				isEnable = true;
            				break;
            			}
            		}
            	}
            	
            	//删除这个人在这个单位下的部门角色
            	if(!isEnable){
            		List<MemberRole> memberAllRole = orgManager.getMemberRoles(rel.getSourceId(),null);
            		for (MemberRole memberRole : memberAllRole) {
            			if(!rel.getOrgAccountId().equals(memberRole.getAccountId())){
            				continue;
            			}
            			
            			if(null!=memberRole.getDepartment()){
            				EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
            						OrgConstants.RelationshipObjectiveName.class);
            				objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, memberRole.getDepartment().getId());
            				orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), member.getId(),rel.getOrgAccountId(), objectiveIds);
            			}
            		}
            	}
            }

            orgManagerDirect.deleteRelationById(id);

            //UC需求--删除兼职分发事件
            DeleteConCurrentPostEvent event = new DeleteConCurrentPostEvent(this);
            event.setRel(rel);
            EventDispatcher.fireEvent(event);
            // 删除兼职的角色有T2的自己监听和逻辑，请注意不要疏漏
        }
        map.put("allCount", allCount);
    	map.put("failCount", failCount);
    	map.put("delConPostList", delConPostList);
        return map;
    }

    /**
     * 为了防止有另外的兼职与这个人的兼职角色有交集，再删除他的角色后再补充新建一次
     * @param relId
     * @param memberId
     * @param conAccountId
     * @throws BusinessException
     */
    private void dealOtherConRoles(long relId, long memberId, long conAccountId) throws BusinessException {
        EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                OrgConstants.RelationshipObjectiveName.class);
        //objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, conAccountId);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Concurrent.name());

        List<V3xOrgRelationship> oldCon = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post,
                memberId, conAccountId, objectiveIds);

        for (V3xOrgRelationship r : oldCon) {
            if (relId != r.getId().longValue()) {
                String roleIds = r.getObjective7Id() == null ? "" : r.getObjective7Id();
                if (Strings.isNotBlank(roleIds)) {
                    String[] roles = roleIds.split(",");
                    List<Long> rIds = new ArrayList<Long>();
                    V3xOrgMember member = orgManager.getMemberById(memberId);
                    for (String roleId : roles) {
                        rIds.add(Long.valueOf(roleId.trim()));
                    }
                    orgManagerDirect.addConcurrentRoles2Entity(rIds, conAccountId, member);
                }
            }
        }
    }

    /**
     * 删除本条兼职所设置的兼职角色
     * @param memberId
     * @param conAccountId
     * @param conRoles
     * @throws BusinessException
     */
    private void deleteConRoles(long memberId, long conAccountId) throws BusinessException {

        EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                OrgConstants.RelationshipObjectiveName.class);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, conAccountId);
        //objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, "Member");//这个不按照这个删除，兼职到单位后仍然可以分配其他角色，兼职部门也有所在角色
        //objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective1Id, mrole.getRole().getId());
        orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), memberId,
                conAccountId, objectiveIds);
        //緩存老不一致，單獨刪除下緩存
        List<V3xOrgRelationship> rsList= orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Role, memberId, conAccountId, objectiveIds);
        List<OrgRelationship>  orList = new ArrayList<OrgRelationship>();
        for(V3xOrgRelationship rs: rsList){
            OrgRelationship or =(OrgRelationship) rs.toPO();
            orList.add(or);
        }
        orgCache.cacheRemoveRelationship(orList);

//        List<MemberRole> memroles = orgManager.getMemberRoles(memberId, conAccountId);
//
//        for (int i = 0; i < memroles.size(); i++) {
//            MemberRole mrole = memroles.get(i);
//            EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
//                    OrgConstants.RelationshipObjectiveName.class);
//            objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, conAccountId);
//            //objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective5Id, "Member");//这个不按照这个删除，兼职到单位后仍然可以分配其他角色，兼职部门也有所在角色
//            objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective1Id, mrole.getRole().getId());
//            orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), memberId,
//                    conAccountId, objectiveIds);
//        }

//        if (Strings.isNotBlank(conRoles)) {
//            String[] roles = conRoles.split(",");
//            for (String roleId : roles) {
//                EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
//                        OrgConstants.RelationshipObjectiveName.class);
//                objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, conAccountId);
//                objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective1Id, Long.valueOf(roleId.trim()));
//                orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), memberId,
//                        conAccountId, objectiveIds);
//            }
//        }
    }

    private void deleteConRolesForDel(long memberId, long conAccountId) throws BusinessException {
        EnumMap<OrgConstants.RelationshipObjectiveName, Object> objectiveIds = new EnumMap<OrgConstants.RelationshipObjectiveName, Object>(
                OrgConstants.RelationshipObjectiveName.class);
        objectiveIds.put(OrgConstants.RelationshipObjectiveName.objective0Id, conAccountId);
        orgDao.deleteOrgRelationshipPO(OrgConstants.RelationshipType.Member_Role.name(), memberId,
                conAccountId, objectiveIds);
    }

    /**
     * 为前台列表组建展现数据名称的工具方法内部使用
     * @param fi
     * @return
     * @throws BusinessException
     */
    private List<WebV3xOrgConcurrentPost> dealFilpInfoData(List<OrgRelationship> relationships) throws BusinessException {
        List<OrgRelationship> cntRels = relationships;
        List<WebV3xOrgConcurrentPost> fiData2Show = new ArrayList<WebV3xOrgConcurrentPost>(cntRels.size());
        for (OrgRelationship po : cntRels) {
            WebV3xOrgConcurrentPost w = new WebV3xOrgConcurrentPost(new V3xOrgRelationship(po));
            w.setCreateTime(po.getCreateTime());
            w.setUpdateTime(po.getUpdateTime());
            String mainAccountName = OrgHelper.showOrgAccountNameByMemberid(po.getSourceId());
            w.setConMemberName(OrgHelper.showMemberNameOnly(po.getSourceId()));
            w.setConPostCode(po.getObjective6Id());
            w.setSouAccountName(mainAccountName);
            V3xOrgMember member = OrgHelper.getMember(po.getSourceId());
            if(member != null){
            	w.setSouAccountID(member.getOrgAccountId() + "");
            }
            w.setSouPAnames(OrgHelper.showOrgPostNameByMemberid(po.getSourceId()));
            Long createUserID = po.getObjective3Id();
            if(createUserID == null){
            	createUserID = 5725175934914479521L;
            }
            w.setCreateUserName(getUserName(createUserID));
            Long lastModifyUnitId = po.getObjective4Id();
            if(lastModifyUnitId == null){
            	lastModifyUnitId = 5725175934914479521L;
            }
            w.setLastModifyUserName(getUserName(lastModifyUnitId));
            if (null != po.getObjective0Id()
                    && null != po.getObjective1Id()
                    && !po.getObjective0Id().equals(-1L)
                    && !po.getObjective1Id().equals(-1L)) {
                V3xOrgPost tarPost = orgManager.getPostById(po.getObjective1Id());
                w.setTarDPAnames(OrgHelper.showDepartmentFullPath(po.getObjective0Id().longValue()) + "-"
                        + ((null==tarPost)?"":tarPost.getName()));
            } else {
                w.setTarDPAnames(NULL_CONCURRENTPOST_INFO);
            }
            w.setConSortId(po.getSortId());//兼职排序号
            w.setTarAccountName(OrgHelper.showOrgAccountName(po.getOrgAccountId().longValue()));
            w.setTarAccountID(po.getOrgAccountId()+"");
            fiData2Show.add(w);
        }
        return fiData2Show;
    }
    
    private String getUserName(Long userID) throws BusinessException{
    	String userName = "";
    	if(userID != null){
        	V3xOrgMember createUser = orgManager.getMemberById(userID);
        	if(createUser != null){
        		V3xOrgAccount account = orgManager.getAccountById(createUser.getOrgAccountId());
        		if(createUser.getIsAdmin()){
        			if(account.isGroup()){
        				userName = createUser.getName();//集团管理员
        			}else{
        				userName = account.getName() + "单位管理员";//单位管理员
        			}
        		}else{
        			if(account.getOrgAccountId().longValue() != AppContext.currentAccountId()){
        				userName = createUser.getName() + "(" + account.getShortName() + ")";//创建人
        			}else{
        				userName = createUser.getName();
        			}
        		}
        	}
        }
    	return userName;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public HashMap viewOne(Long relId) throws BusinessException {
        HashMap<String, Object> map = new HashMap<String, Object>();
        OrgRelationship relPO = orgDao.getEntity(OrgRelationship.class, relId);
        if(null==relPO){
            return null;
        }
        //是否显示单位简称
        boolean isShowAccountName = false;
        Long currentAccountId = AppContext.currentAccountId();
        Long cAccountId = relPO.getOrgAccountId();
        if(Strings.equals(OrgConstants.GROUPID, currentAccountId) || Strings.equals(currentAccountId, cAccountId)) {
            isShowAccountName = true;
        }

        map.put("id", relPO.getId());
        map.put("code", relPO.getObjective6Id());
        map.put("cMemberId", relPO.getSourceId());

        //需要显示原单位信息
        V3xOrgMember cMember = orgManager.getMemberById(relPO.getSourceId());
        V3xOrgAccount sAccount = orgManager.getAccountById(cMember.getOrgAccountId());
        //原单位所属人员Id
        map.put("sAccountId", sAccount.getId().toString());
        V3xOrgAccount cAccount = orgManager.getAccountById(cAccountId);
        //主岗
        if(isShowAccountName) {
            map.put("primaryPost", orgManager.getPostById(cMember.getOrgPostId()).getName()+"("+sAccount.getShortName()+")");
        } else {
            map.put("primaryPost", orgManager.getPostById(cMember.getOrgPostId()).getName());
        }
        map.put("cAccountId", relPO.getOrgAccountId());
        map.put("cDeptId", relPO.getObjective0Id()==null?Long.valueOf(-1):relPO.getObjective0Id());
        map.put("cPostId", relPO.getObjective1Id());
        map.put("cLevelId", relPO.getObjective2Id()==null?Long.valueOf(-1):relPO.getObjective2Id());
        map.put("sortId", (relPO.getSortId()==null||relPO.getSortId().equals(Long.valueOf(1)))?Integer.valueOf(1):relPO.getSortId());
        if(isShowAccountName) {
            map.put("cMember", cMember.getName()+"("+sAccount.getShortName()+")");
        } else {
            map.put("cMember", cMember.getName());
        }
        map.put("cAccount", OrgHelper.showOrgAccountName(relPO.getOrgAccountId().longValue()));
        if(null == relPO.getObjective0Id()
                || Long.valueOf(-1).equals(relPO.getObjective0Id())) {
            map.put("cDept","");
        } else {
            if(!isShowAccountName || Strings.equals(OrgConstants.GROUPID, currentAccountId)) {
                map.put("cDept", orgManager.getDepartmentById(relPO.getObjective0Id()).getName() + "(" + cAccount.getShortName() + ")");
            } else {
                map.put("cDept", orgManager.getDepartmentById(relPO.getObjective0Id()).getName());
            }
        }
        if(null == relPO.getObjective1Id()
                || Long.valueOf(-1).equals(relPO.getObjective1Id())) {
            map.put("cPost", "");
        } else {
            if(!isShowAccountName || Strings.equals(OrgConstants.GROUPID, currentAccountId)) {
                map.put("cPost", orgManager.getPostById(relPO.getObjective1Id()).getName() + "(" + cAccount.getShortName() + ")");
            } else {
                map.put("cPost", orgManager.getPostById(relPO.getObjective1Id()).getName());
            }
        }
        if(null == relPO.getObjective2Id()
                || relPO.getObjective2Id().equals(Long.valueOf(-1))) {
            map.put("cLevel","");
        } else {
            if(!isShowAccountName || Strings.equals(OrgConstants.GROUPID, currentAccountId)) {
                map.put("cLevel", orgManager.getLevelById(relPO.getObjective2Id()).getName() + "(" + cAccount.getShortName() + ")");
            } else {
                map.put("cLevel", orgManager.getLevelById(relPO.getObjective2Id()).getName());
            }
        }

        //兼职角色回写
        //String roleIds = relPO.getObjective7Id()==null?"":relPO.getObjective7Id();
        StringBuilder roleNames = new StringBuilder();
//        if(Strings.isNotBlank(roleIds)) {
//            String[] roles = roleIds.split(",");
//            for (String roleId : roles) {
//                V3xOrgRole role = orgManager.getRoleById(Long.valueOf(roleId.trim()));
//                if(null != role) {
//                    roleNames.append(role.getShowName()).append(",");
//                }
//            }
//        }
        StringBuilder roleIds = new StringBuilder();
        List<MemberRole> memberRoles = orgManager.getMemberRoles(relPO.getSourceId(), relPO.getOrgAccountId());
        for (int i = 0; i < memberRoles.size(); i++) {
            MemberRole m = memberRoles.get(i);
            //人员管理列表详细信息，不显示这个人的部门角色
            if(OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == m.getRole().getBond()
                    || OrgConstants.ROLE_BOND.ACCOUNT.ordinal() == m.getRole().getBond()) {
                if(relPO.getSourceId() != m.getMemberId()
                        || OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == m.getRole().getBond()
                        || !Strings.equals(cAccountId, m.getRole().getOrgAccountId())) {
                    continue;
                } else if(Strings.equals(cAccountId, m.getRole().getOrgAccountId())) {
                    roleNames.append(m.getRole().getShowName()).append(",");
                    roleIds.append(m.getRole().getId()).append(",");
                }
            }

        }
        String showRoles = new String();
        if(roleNames.length() == 0) {
            showRoles = "";
        } else {
            showRoles = roleNames.substring(0, roleNames.length() - 1);
        }
        map.put("cRoles", showRoles);
        map.put("cRoleIds", roleIds.toString());

        return map;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public HashMap<String, String> getPriPostNameByMemberId(Long memberId) throws BusinessException {
        HashMap<String, String> p = new HashMap<String, String>();
        V3xOrgMember cMember = orgManager.getMemberById(memberId);
        V3xOrgPost primaryPost = orgManager.getPostById(cMember.getOrgPostId());
        if(null == primaryPost) {
            p.put("primaryPost", "");//OA-51675
        } else {
            p.put("primaryPost", primaryPost.getName() + "("
                    + orgManager.getAccountById(cMember.getOrgAccountId()).getShortName() + ")");
        }
        return p;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public boolean checkBatConpostAccount(String memberIds, String accountIds) throws BusinessException {
        //批量新建兼职选择的人员的单位id列表
        String[] mIds = memberIds.split(",");
        List<Long> sAccountIds = new ArrayList<Long>();
        for (String mId : mIds) {
            V3xOrgMember m = orgManager.getMemberById(Long.valueOf(mId.trim().split("[|]")[1]));
            if(null != m) {
                sAccountIds.add(m.getOrgAccountId());
            }
        }
        //批量新建兼职选择的单位id列表
        String[] aIds = accountIds.split(",");
        List<Long> tAccountIds = new ArrayList<Long>();
        for (String aId : aIds) {
            tAccountIds.add(Long.valueOf(aId.trim().split("[|]")[1]));
        }

        return Collections.disjoint(sAccountIds, tAccountIds);//去交集
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public FlipInfo list4SecondPost(FlipInfo fi, Map params) throws BusinessException {

        List<WebV3xOrgSecondPost> resultList = dealSecondPostInfo(getSecondPostMap(AppContext.currentAccountId(), params));

        fi.setData(resultList);

        DBAgent.memoryPaging(resultList, fi);

        return fi;
    }

    @Override
	public FlipInfo list4SubUnitManage(FlipInfo fi, Map params) throws BusinessException {
		EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(
                RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, MemberPostType.Concurrent.name());

        //查询条件
        String condition = String.valueOf(params.get("condition"));
        Object value = params.get("value") == null ? "" : params.get("value");

        Long accountId = null;
        Long postId = null;
        Long conAccountId = null;

        //取所有子单位的id
        Long currentAccountId = AppContext.currentAccountId();
        //所有有权限访问的单位
        List<V3xOrgAccount> accessableUnitList = orgManager.accessableAccounts(AppContext.currentUserId());
        List<V3xOrgAccount> subUnitList = orgCache.getChildAccount(currentAccountId);
        subUnitList.retainAll(accessableUnitList);//取可以访问的范围内的子单位交集
        List<Long> subUnitIds = new ArrayList<Long>();
        subUnitIds.add(currentAccountId);
        for(V3xOrgAccount unit:subUnitList){
        	subUnitIds.add(unit.getId());
        }
        
        //选人界面过来的查询条件和值
        if ("cMemberName".equals(condition)) {//兼职人员名称
            //OA-44787
            List<OrgRelationship> relationships = orgDao.getOrgRelationshipPOByMemberName(String.valueOf(value), fi,"subUnitManage",subUnitIds);
            List<WebV3xOrgConcurrentPost> resultConcurrentPosts = this.dealFilpInfoData(relationships);
            fi.setData(resultConcurrentPosts);
            return fi;
        }
        else if ("cAccount".equals(condition)) {//兼职单位
        	conAccountId = getValue(params);
        }
        else if ("sAccount".equals(condition)) {//原单位
        	accountId = getValue(params);
        }
        List<OrgRelationship> relationships = orgDao.getOrgRelationshipPO4ConPost(null, postId, accountId, conAccountId, enummap,true,subUnitIds,null);
        List<WebV3xOrgConcurrentPost> resultConcurrentPosts = this.dealFilpInfoData(relationships);
        DBAgent.memoryPaging(resultConcurrentPosts, fi);
        return fi;
	}
    
    @Override
    public Map<Long, List<MemberPost>> getSecondPostMap(Long accountId, Map params) throws BusinessException {
        List<MemberPost> toQueryList = new ArrayList<MemberPost>();

        Map<Long, List<MemberPost>> secondPostMap = new HashMap<Long, List<MemberPost>>();
        Set<Long> memberIdSet = new HashSet<Long>();
        List<MemberPost> secondPostList = orgManager.getSecondPostByAccount(accountId);

        if(null != params) {
            //查询条件
            String condition = String.valueOf(params.get("condition"));
            Object value = params.get("value") == null ? "" : params.get("value");

            if("cMemberName".equals(condition)){
                if(Strings.isBlank(String.valueOf(value))) {
                    toQueryList = secondPostList;
                } else {
                    List<V3xOrgMember> members = orgManager.getMemberByIndistinctName(String.valueOf(value));
                    Set<Long> idSet = new HashSet<Long>();
                    for (V3xOrgMember m : members) {
                        idSet.add(m.getId());
                    }
                    for (MemberPost mp : secondPostList) {
                        if(idSet.contains(mp.getMemberId())) {
                            toQueryList.addAll(orgManager.getMemberSecondPosts(mp.getMemberId()));
                        }
                    }
                }
            } else if("orgDepartmentId".equals(condition)) {
                String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
                String[] strs = str.trim().split(",");
                if (strs.length != 0) {
                  //修改主岗方法 steven
                    EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
                    enummap.put(OrgConstants.RelationshipObjectiveName.objective0Id, Long.valueOf(strs[1].trim()));
                    enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Main.name());
                    List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, null, accountId, enummap);
                    Set<Long> idSet = new HashSet<Long>();
                    for (V3xOrgRelationship r : rels) {
                        idSet.add(r.getSourceId());
                    }
                    for (MemberPost mp : secondPostList) {
                        if (idSet.contains(mp.getMemberId())) {
                            toQueryList.addAll(orgManager.getMemberSecondPosts(mp.getMemberId()));
                        }
                    }
                } else {
                    toQueryList = secondPostList;
                }
            } else if("orgPostId".equals(condition)) {
                String str = String.valueOf(value).replace("]", "").replace("[", "").replace("\"", "");
                String[] strs = str.trim().split(",");
                if (strs.length != 0) {
                  //修改主岗方法 steven
                    EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(RelationshipObjectiveName.class);
                    enummap.put(OrgConstants.RelationshipObjectiveName.objective1Id, Long.valueOf(strs[1].trim()));
                    enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, OrgConstants.MemberPostType.Main.name());
                    List<V3xOrgRelationship> rels = orgCache.getV3xOrgRelationship(OrgConstants.RelationshipType.Member_Post, null, accountId, enummap);

                    Set<Long> idSet = new HashSet<Long>();
                    for (V3xOrgRelationship r : rels) {
                        idSet.add(r.getSourceId());
                    }
                    for (MemberPost mp : secondPostList) {
                        if (idSet.contains(mp.getMemberId())) {
                            toQueryList.addAll(orgManager.getMemberSecondPosts(mp.getMemberId()));
                        }
                    }
                } else {
                    toQueryList = secondPostList;
                }
            } else if("secPostId".equals(condition)) {
                for (MemberPost mp : secondPostList) {
                	Long tempValue = null;
                	List<String> strs = (List<String>)params.get("value");
                    if (Strings.isEmpty(strs)) {
                    	tempValue = null;
                    } else {
                    	String s1= strs.get(1).trim();
                    	if(Strings.isEmpty(s1)){
                    		tempValue = null;
                    	}else{
                    		tempValue = Long.valueOf(s1);
                    	}
                    }
                    if (tempValue!=null) {
                        if(mp.getPostId().equals(tempValue) && OrgConstants.MemberPostType.Second.name().equals(mp.getType().name())) {
                            toQueryList.addAll(orgManager.getMemberSecondPosts(mp.getMemberId()));
                            continue;
                        }
                    } else {
                        toQueryList = secondPostList;
                        break;
                    }
                }
            } else {
                toQueryList = secondPostList;
            }
        } else {
            toQueryList = secondPostList;
        }

        for (MemberPost memberPost : toQueryList) {
            if(memberIdSet.contains(memberPost.getMemberId())) {
                List<MemberPost> temp = secondPostMap.get(memberPost.getMemberId());
                temp.add(memberPost);
                secondPostMap.put(memberPost.getMemberId(), temp);
            } else {
                memberIdSet.add(memberPost.getMemberId());
                List<MemberPost> temp = new ArrayList<MemberPost>();
                temp.add(memberPost);
                secondPostMap.put(memberPost.getMemberId(), temp);
            }
        }
        return secondPostMap;
    }

    @Override
    public List<WebV3xOrgSecondPost> dealSecondPostInfo(Map<Long, List<MemberPost>> resultMap) throws BusinessException {
        List<WebV3xOrgSecondPost> fiData2Show = new ArrayList<WebV3xOrgSecondPost>();
        for (Long memberId : resultMap.keySet()) {
            List<MemberPost> secondPosts = resultMap.get(memberId);

            V3xOrgMember m =  orgManager.getMemberById(memberId);
            if(null == m || !m.isValid()) continue;
            WebV3xOrgSecondPost sec = new WebV3xOrgSecondPost();
            sec.setMemberId(memberId);
            sec.setSortId(m.getSortId());
            V3xOrgDepartment dept = orgManager.getDepartmentById(m.getOrgDepartmentId());
            sec.setDeptName( null == dept ? "" : OrgHelper.showDepartmentFullPath(m.getOrgDepartmentId()));
            V3xOrgPost post = orgManager.getPostById(m.getOrgPostId());
            sec.setPostName( null == post ? "" : post.getName());
            sec.setMemberName(m.getName());
            sec.setTypeName(null == m.getType() ? "" : m.getType().toString());

            if(secondPosts.size() > 3) {
                MemberPost secPost0 = secondPosts.get(0);
                secondPosts.remove(0);
                V3xOrgDepartment dept0 = orgManager.getDepartmentById(secPost0.getDepId());
                V3xOrgPost post0 = orgManager.getPostById(secPost0.getPostId());
                sec.setSecPost0((null == dept0 ? "" : dept0.getName()) + "-" + (null == post0 ? "" : post0.getName()));

                MemberPost secPost1 = secondPosts.get(1);
                V3xOrgDepartment dept1 = orgManager.getDepartmentById(secPost1.getDepId());
                V3xOrgPost post1 = orgManager.getPostById(secPost1.getPostId());
                sec.setSecPost1((null == dept1 ? "" : dept1.getName()) + "-" + (null == post1 ? "" : post1.getName()));

                secondPosts.remove(secPost0);
                secondPosts.remove(secPost1);

                StringBuffer post2Str = new StringBuffer();
                for (MemberPost memberPost : secondPosts) {
                    V3xOrgDepartment dept2 = orgManager.getDepartmentById(memberPost.getDepId());
                    V3xOrgPost post2 = orgManager.getPostById(memberPost.getPostId());
                    post2Str.append((null == dept2 ? "" : dept2.getName()) + "-" + (null == post2 ? "" : post2.getName()) + "、");
                }
                sec.setSecPost2(post2Str.toString());
            } else if (secondPosts.size() == 3) {
                MemberPost secPost0 = secondPosts.get(0);
                V3xOrgDepartment dept0 = orgManager.getDepartmentById(secPost0.getDepId());
                V3xOrgPost post0 = orgManager.getPostById(secPost0.getPostId());
                sec.setSecPost0((null == dept0 ? "" : dept0.getName()) + "-" + (null == post0 ? "" : post0.getName()));

                MemberPost secPost1 = secondPosts.get(1);
                V3xOrgDepartment dept1 = orgManager.getDepartmentById(secPost1.getDepId());
                V3xOrgPost post1 = orgManager.getPostById(secPost1.getPostId());
                sec.setSecPost1((null == dept1 ? "" : dept1.getName()) + "-" + (null == post1 ? "" : post1.getName()));

                MemberPost secPost2 = secondPosts.get(2);
                V3xOrgDepartment dept2 = orgManager.getDepartmentById(secPost2.getDepId());
                V3xOrgPost post2 = orgManager.getPostById(secPost2.getPostId());
                sec.setSecPost2((null == dept2 ? "" : dept2.getName()) + "-" + (null == post2 ? "" : post2.getName()));
            } else if(secondPosts.size() > 1) {
                MemberPost secPost0 = secondPosts.get(0);
                V3xOrgDepartment dept0 = orgManager.getDepartmentById(secPost0.getDepId());
                V3xOrgPost post0 = orgManager.getPostById(secPost0.getPostId());
                sec.setSecPost0((null == dept0 ? "" : dept0.getName()) + "-" + (null == post0 ? "" : post0.getName()));

                MemberPost secPost1 = secondPosts.get(1);
                V3xOrgDepartment dept1 = orgManager.getDepartmentById(secPost1.getDepId());
                V3xOrgPost post1 = orgManager.getPostById(secPost1.getPostId());
                sec.setSecPost1((null == dept1 ? "" : dept1.getName()) + "-" + (null == post1 ? "" : post1.getName()));
            } else if(secondPosts.size() > 0) {
                MemberPost secPost0 = secondPosts.get(0);
                V3xOrgDepartment dept0 = orgManager.getDepartmentById(secPost0.getDepId());
                V3xOrgPost post0 = orgManager.getPostById(secPost0.getPostId());
                sec.setSecPost0((null == dept0 ? "" : dept0.getName()) + "-" + (null == post0 ? "" : post0.getName()));
            } else {
                sec.setSecPost0("");
                sec.setSecPost1("");
                sec.setSecPost2("");
            }
            fiData2Show.add(sec);
        }

        Collections.sort(fiData2Show, CompareSortWebEntity.getInstance());
        return fiData2Show;
    }

    private String[] getRoleNameAndId(OrgRelationship relPO,Long cAccountId) throws BusinessException{
        StringBuilder roleIds = new StringBuilder();
        StringBuilder roleNames = new StringBuilder();
        List<MemberRole> memberRoles = orgManager.getMemberRoles(relPO.getSourceId(), relPO.getOrgAccountId());
        for (int i = 0; i < memberRoles.size(); i++) {
            MemberRole m = memberRoles.get(i);
            //人员管理列表详细信息，不显示这个人的部门角色
            if(OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == m.getRole().getBond()
                    || OrgConstants.ROLE_BOND.ACCOUNT.ordinal() == m.getRole().getBond()) {
                if(relPO.getSourceId() != m.getMemberId()
                        || OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == m.getRole().getBond()
                        || !Strings.equals(cAccountId, m.getRole().getOrgAccountId())) {
                    continue;
                } else if(Strings.equals(cAccountId, m.getRole().getOrgAccountId())) {
                    roleNames.append(m.getRole().getShowName()).append(",");
                    roleIds.append(m.getRole().getId()).append(",");
                }
            }

        }
        String showRoles = new String();
        if(roleNames.length() == 0) {
            showRoles = "";
        } else {
            showRoles = roleNames.substring(0, roleNames.length() - 1);
        }
        return new String[]{showRoles,roleIds.toString()};
    }
    
    @Override
	public String getIncludeUnitIds() throws BusinessException {
    	
		Long currentUnitId = AppContext.currentAccountId();
		// 客开 增加虚拟集团ID判断
		if (virtualGroupAccountId != null && "-1730833917365171641".equals(String.valueOf(virtualGroupAccountId))){
			currentUnitId = -1730833917365171641L;
		}
		// END 
		V3xOrgAccount currentUnit = orgManager.getAccountById(currentUnitId);
		List<V3xOrgAccount> subUnitList = orgCache.getChildAccount(currentUnitId);//所有子单位
		subUnitList.add(currentUnit);
		
        StringBuffer excludeUnitIDs = new StringBuffer();
        for(V3xOrgAccount unit : subUnitList){
        	excludeUnitIDs.append(unit.getId() + ",");
        }
        String unitIDs = excludeUnitIDs.toString();
        if(Strings.isNotBlank(unitIDs)){
        	unitIDs = unitIDs.substring(0, unitIDs.length() - 1);
        }
		return unitIDs;
	}

    private boolean isNotLegal(String inString){
        return Strings.isEmpty(inString)||Strings.equals(inString, "-1")||Strings.equals(inString, "null");
    }

	public PrivilegeMenuManager getPrivilegeMenuManager() {
		return privilegeMenuManager;
	}

	public void setPrivilegeMenuManager(PrivilegeMenuManager privilegeMenuManager) {
		this.privilegeMenuManager = privilegeMenuManager;
	}
	@Override
	public Map<String,Object> checkCanModify(Long relId) throws BusinessException {
		Map<String,Object> map = new HashMap<String, Object>();
		boolean fromOutUnit = false;
		boolean toOutUnit = false;
		OrgRelationship relPO = orgDao.getEntity(OrgRelationship.class, relId);
        if(null != relPO){
        	Long targetUnitId = relPO.getOrgAccountId();
        	String includeUnitId = getIncludeUnitIds();
        	if(Strings.isNotBlank(includeUnitId) && includeUnitId.indexOf(targetUnitId+"") == -1){
        		toOutUnit = true;
        	}
        	Long userID = relPO.getSourceId();
        	V3xOrgMember member = orgManager.getMemberById(userID);
        	if(member != null){
        		Long unitId = member.getOrgAccountId();
        		if(Strings.isNotBlank(includeUnitId) && includeUnitId.indexOf(unitId+"") == -1){
        			fromOutUnit = true;
            	}
        	}
        }
        map.put("fromOutUnit", fromOutUnit);
        map.put("toOutUnit", toOutUnit);
        return map;
	}

	@Override
	public String checkCanDel(Long relId) throws BusinessException {
		OrgRelationship relPO = orgDao.getEntity(OrgRelationship.class, relId);
        if(null != relPO){
        	Long targetUnitId = relPO.getOrgAccountId();
        	String includeUnitId = getIncludeUnitIds();
        	if(Strings.isNotBlank(includeUnitId) && includeUnitId.indexOf(targetUnitId+"") == -1){
        		return "此人员的兼职单位不在管理范围内，无法删除该兼职关系！";
        	}
        }
		return "";
	}

	@Override
	public void conPostSwitch(Boolean switchOn) throws BusinessException {
		//检查当前登录人的角色，集团管理员才能修改开关状态
		if(AppContext.isGroupAdmin()){
			String configCategory = IConfigPublicKey.CON_POST_SWITCH;
			String configItem = IConfigPublicKey.ALLOW_SUBUNIT_MANAGE_CON_POST;
			ConfigItem conPostItem = configManager.getConfigItem(configCategory, configItem);
	        if(null == conPostItem){
	        	
	        	conPostItem = getNewConfigItem(configItem,switchOn ? "1":"0");
	        	configManager.addConfigItem(conPostItem);
	        }else{
	        	conPostItem.setConfigValue(switchOn ? "1":"0");
	        	configManager.updateConfigItem(conPostItem);
	        }
		}
	}
	
	private ConfigItem getNewConfigItem(String item, String value) {
        ConfigItem configItem = new ConfigItem();
        configItem.setIdIfNew();
        configItem.setConfigCategory(IConfigPublicKey.CON_POST_SWITCH);
        configItem.setConfigItem(item);
        configItem.setConfigValue(value);
		Date date=new Date();
		Timestamp stamp=new Timestamp(date.getTime());
		configItem.setCreateDate(stamp);
		configItem.setModifyDate(stamp);
        return configItem;
    }

	@Override
	public boolean canSubunitManageConPost() throws BusinessException {
		String configCategory = IConfigPublicKey.CON_POST_SWITCH;
		String configItem = IConfigPublicKey.ALLOW_SUBUNIT_MANAGE_CON_POST;
		ConfigItem conPostItem = configManager.getConfigItem(configCategory, configItem);
		if(conPostItem != null && "1".equals(conPostItem.getConfigValue())){
			return true;
		}
		return false;
	}
}
