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
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
//客开 赵培珅  20180730 start 
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator,Role_NAME.DepAdmin,Role_NAME.HrAdmin})
public class PostManagerImpl implements PostManager {
	private final static Log logger = LogFactory
			.getLog(PostManagerImpl.class);
	protected OrgCache orgCache;
	protected OrgDao orgDao;
	protected OrgManagerDirect orgManagerDirect;
	protected OrgManager orgManager;
	protected PrincipalManager principalManager;
	protected AppLogManager       appLogManager;
	protected EnumManager         enumManagerNew;


	public void setEnumManagerNew(EnumManager enumManagerNew) {
		this.enumManagerNew = enumManagerNew;
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

	public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    @Override
    //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public HashMap addPost(String accountId) throws BusinessException {
		// TODO Auto-generated method stub
		Integer maxSortNum = orgManagerDirect.getMaxSortNum(V3xOrgPost.class.getSimpleName(), Long.valueOf(accountId));
		HashMap m = new HashMap();
		m.put("sortId", maxSortNum+1);
		return m;
	}
	

	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public Long createPost(String accountId, Map post) throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long accId = Long.valueOf(accountId);
        V3xOrgPost newpost = new V3xOrgPost();

        ParamUtil.mapToBean(post, newpost, false);
        newpost.setOrgAccountId(accId);

        if (newpost.getId() == null) {
            //排序号的重复处理
            String isInsert = post.get("sortIdtype").toString();
            if ("1".equals(isInsert)
                    && orgManagerDirect.isPropertyDuplicated(V3xOrgPost.class.getSimpleName(), "sortId", newpost
                            .getSortId().longValue(), newpost.getOrgAccountId())) {
                orgManagerDirect.insertRepeatSortNum(V3xOrgPost.class.getSimpleName(), accId,
                        newpost.getSortId(), null);
            }
            newpost.setIdIfNew();
            OrganizationMessage returnMessage = orgManagerDirect.addPost(newpost);
            OrgHelper.throwBusinessExceptionTools(returnMessage);
            //枚举调用记录
            enumManagerNew.updateEnumItemRef("organization_post_types", String.valueOf(newpost.getTypeId()));
            //记录日志
            appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_NewPost, user.getName(), newpost.getName());
        } else {
            //排序号的重复处理
            String isInsert = post.get("sortIdtype").toString();
            if ("1".equals(isInsert)
                    && orgManagerDirect.isPropertyDuplicated(V3xOrgPost.class.getSimpleName(), "sortId", newpost
                            .getSortId().longValue(), newpost.getOrgAccountId(), newpost.getId())) {
                orgManagerDirect.insertRepeatSortNum(V3xOrgPost.class.getSimpleName(), accId,
                        newpost.getSortId(), null);
            }
            OrganizationMessage returnMessage = orgManagerDirect.updatePost(newpost);
            OrgHelper.throwBusinessExceptionTools(returnMessage);
            //记录日志
            appLogManager.insertLog4Account(user, accId, AppLogAction.Organization_UpdatePost, user.getName(), newpost.getName());
        }
        return newpost.getId();
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public void createPostFormBase(String accountId, String posts) throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long accId = Long.valueOf(accountId);
        List<String[]> applogs = new ArrayList<String[]>();
        List<V3xOrgEntity> ents = orgManager.getEntities(posts);
        for (V3xOrgEntity v3xOrgEntity : ents) {
            V3xOrgPost oldpost = (V3xOrgPost) v3xOrgEntity;
            Long oldid = oldpost.getId();
            oldpost.setId(null);
            oldpost.setOrgAccountId(accId);
            oldpost.setSortId(Long.valueOf(orgManagerDirect.getMaxSortNum(V3xOrgPost.class.getSimpleName(), accId)) + 1);
            oldpost.setIdIfNew();
            OrganizationMessage mes = orgManagerDirect.addPost(oldpost);
            OrgHelper.throwBusinessExceptionTools(mes);
            V3xOrgRelationship rel = new V3xOrgRelationship();
            rel.setOrgAccountId(oldpost.getOrgAccountId());
            rel.setKey(OrgConstants.RelationshipType.Banchmark_Post.name());
            rel.setSourceId(oldpost.getId());
            rel.setObjective0Id(oldid);
            orgManagerDirect.addOrgRelationship(rel);

            String[] appLog = new String[2];
            appLog[0] = user.getName();
            appLog[1] = oldpost.getName();
            applogs.add(appLog);
        }

        //记录日志
        appLogManager.insertLogs4Account(user, accId, AppLogAction.Organization_NewPost, applogs);

    }


    @Override
    public HashMap viewPost(Long postId) throws BusinessException {
        HashMap map = new HashMap();
        V3xOrgPost p = orgManager.getPostById(postId);
        ParamUtil.beanToMap(orgManager.getPostById(postId), map, false);
        List<V3xOrgRelationship> reflist = orgManager.getV3xOrgRelationship(
                OrgConstants.RelationshipType.Banchmark_Post, Long.valueOf(map.get("id").toString()),
                p.getOrgAccountId(), null);
        if (reflist.size() > 0 || orgManager.getAccountById(p.getOrgAccountId()).isGroup()) {
            map.put("posttype", ResourceUtil.getString("post.bmpost.label"));
        } else {
            map.put("posttype", ResourceUtil.getString("post.account.post"));
        }
        dealPostName(p, map);
        return map;
    }

    @Override
    //客开 赵培珅  20180730 start 
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public FlipInfo showPostList(FlipInfo fi, Map params) throws BusinessException {
        
    	//SZP
		Long accountId = AppContext.currentAccountId();
		if (params.get("accountId") != null){
			accountId = Long.parseLong(params.get("accountId").toString());
		}
		
	    //Long accountId = Long.parseLong(params.get("accountId").toString());
		//PZS

        if (params.size() == 1) {
            orgDao.getAllPostPO(accountId, null, null, null, fi);
        } else {
            if ("type".equals(params.get("condition"))) {
                params.put("value", Long.valueOf(params.get("value").toString()));
            }
            if (Strings.isBlank(String.valueOf(params.get("value")))) {
                params.put("condition", null);//OA-48521 oracle下select * from org_post where code like '%%'查询出来是code有值得不能查出null的记录
            }
            orgDao.getAllPostPO(accountId, null, String.valueOf(params.get("condition")),
                    params.get("value"), fi);
        }
        List list = fi.getData();
        List<V3xOrgPost> v3xlist = (List<V3xOrgPost>) OrgHelper.listPoTolistBo(list);
        List rellist = new ArrayList();
        for (V3xOrgPost p : v3xlist) {
            HashMap m = new HashMap();
            ParamUtil.beanToMap(p, m, true);
            List<V3xOrgRelationship> reflist = orgManager.getV3xOrgRelationship(
                    OrgConstants.RelationshipType.Banchmark_Post, Long.valueOf(m.get("id").toString()),
                    accountId, null);
            dealPostName(p, m);
            if (reflist.size() > 0 || orgManager.getAccountById(accountId).isGroup()) {
                m.put("posttype", ResourceUtil.getString("post.bmpost.label"));
            } else {
                m.put("posttype", ResourceUtil.getString("post.account.post"));
            }
            rellist.add(m);
        }
        fi.setData(rellist);
        return fi;
    }

    /**
     * NC同步过来的申请停用或删除的岗位名称处理
     * @param p
     * @param m
     */
    private void dealPostName(V3xOrgPost p, HashMap m) {
        //OA-26340
        String postName = p.getName();
        if(OrgConstants.ORGENT_STATUS.DISABLED.ordinal() == p.getStatus()) {
            postName = p.getName() + "("+ ResourceUtil.getString("org.entity.disabled") +")";//申请停用
        } else if(OrgConstants.ORGENT_STATUS.DELETED.ordinal() == p.getStatus()) {
            postName = p.getName() + "("+ ResourceUtil.getString("org.entity.deleted") +")";//申请删除
        }
        m.put("name", postName);
    }
    
	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public String deletePost(List<Map<String,Object>> post) throws BusinessException {
		List<V3xOrgPost> postlist = new ArrayList<V3xOrgPost>();
		postlist = ParamUtil.mapsToBeans(post, V3xOrgPost.class, false);
		OrganizationMessage mes = orgManagerDirect.deletePosts(postlist, true);
		OrgHelper.throwBusinessExceptionTools(mes);
		
        //日志信息
        User user = AppContext.getCurrentUser();
        List<String[]> appLogs = new ArrayList<String[]>();
        for (V3xOrgPost p : postlist) {
            String[] appLog = new String[2];
            appLog[0] = user.getName();
            appLog[1] = p.getName();
            appLogs.add(appLog);
        }
        //记录日志
        appLogManager.insertLogs4Account(user, postlist.get(0).getOrgAccountId(), AppLogAction.Organization_DeletePost, appLogs);
		return null;
	}

    @Override
    public String getdeletePostnames(List<Map<String, Object>> post) throws BusinessException {
        StringBuilder names = new StringBuilder();
        for (Map<String, Object> map : post) {
            names.append(String.valueOf(map.get("name"))).append(",");
        }
        return names.toString();
    }

	@Override
	public HashMap getRootAccountId() throws BusinessException {
		HashMap m = new HashMap();
		m.put("id", orgManager.getRootAccount().getId().toString());
		return m;
	}

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public String bdingBasePost(String accountId, List<Map<String, Object>> post) throws BusinessException {
        String nobding = "";
        List<V3xOrgPost> postlist = orgManagerDirect.getAllPosts(orgManager.getRootAccount().getId(), false);
        for (Map postmap : post) {
            boolean bing = false;

            for (V3xOrgPost v3xOrgPost : postlist) {
                if (v3xOrgPost.getName().equals(
                        orgManager.getPostById(Long.valueOf(postmap.get("id").toString())).getName())) {
                    V3xOrgRelationship rel = new V3xOrgRelationship();
                    rel.setOrgAccountId(Long.valueOf(accountId));
                    rel.setKey(OrgConstants.RelationshipType.Banchmark_Post.name());
                    rel.setSourceId(Long.valueOf(postmap.get("id").toString()));
                    rel.setObjective0Id(v3xOrgPost.getId());
                    orgManagerDirect.addOrgRelationship(rel);
                    bing = true;
                    //更新被绑定的岗位
                    V3xOrgPost  accpost = orgManager.getPostById(Long.valueOf(postmap.get("id").toString()));
                    accpost.setCode(v3xOrgPost.getCode());
                    accpost.setTypeId(v3xOrgPost.getTypeId());
                    accpost.setDescription(v3xOrgPost.getDescription());
                    accpost.setEnabled(v3xOrgPost.getEnabled());//OA-52360 绑定的基准岗与集团的岗位停用启用状态一致
                    orgManagerDirect.updatePost(accpost);
                    break;
                }

            }
            if (!bing) {
            	if("".equals(nobding)){
            		nobding = nobding + postmap.get("name");
            	}else{
            		nobding = nobding + ","+postmap.get("name");
            	}
                
            }
        }
        
        return nobding;

    }

    @Override
    public boolean isGroup() throws BusinessException {
        return orgManager.getAccountById(AppContext.currentAccountId()).isGroup();
    }
	

}
