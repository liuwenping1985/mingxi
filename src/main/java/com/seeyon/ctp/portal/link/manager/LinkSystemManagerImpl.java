package com.seeyon.ctp.portal.link.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.portal.link.dao.LinkAclDao;
import com.seeyon.ctp.portal.link.dao.LinkMemberDao;
import com.seeyon.ctp.portal.link.dao.LinkSystemDao;
import com.seeyon.ctp.portal.link.util.Constants;
import com.seeyon.ctp.portal.po.PortalLinkMember;
import com.seeyon.ctp.portal.po.PortalLinkMenu;
import com.seeyon.ctp.portal.po.PortalLinkMenuAcl;
import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.portal.po.PortalLinkOptionValue;
import com.seeyon.ctp.portal.po.PortalLinkSection;
import com.seeyon.ctp.portal.po.PortalLinkSystem;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.privilege.dao.MenuDao;
import com.seeyon.ctp.privilege.manager.PrivilegeManager;
import com.seeyon.ctp.privilege.manager.PrivilegeMenuManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.LightWeightEncoder;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;

public class LinkSystemManagerImpl implements LinkSystemManager {
    private static final Log logger = LogFactory.getLog(LinkSystemManagerImpl.class);
    private LinkSystemDao     linkSystemDao;
    private LinkAclDao        linkAclDao;
    private OrgManager        orgManager;
    private OrgManagerDirect orgManagerDirect;
    private LinkMemberDao     linkMemberDao;
    private PrivilegeManager   privilegeManager;
    private PrivilegeMenuManager privilegeMenuManager;
    private LinkOptionManager linkOptionManager;
    private MenuDao           menuDao;
    private LinkMenuManager   linkMenuManager;
    private AppLogManager       appLogManager;
    
    private static final CacheAccessable cacheFactory = CacheFactory.getInstance(LinkSystemManagerImpl.class);
    private CacheMap<Long, String> linkSystemIconCache; //关联系统图标缓存,只缓存图标
    
    public void init(){
    	linkSystemIconCache=cacheFactory.createMap("linkSystemIconCache");
    	List<PortalLinkSystem> list=linkSystemDao.findAll();
    	Map<Long, String> map=new HashMap<Long, String>();
    	for(PortalLinkSystem l:list){
    		map.put(l.getId(), l.getImage());
    	}
    	linkSystemIconCache.putAll(map);
    }

    public void setLinkSystemDao(LinkSystemDao linkSystemDao) {
        this.linkSystemDao = linkSystemDao;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setLinkAclDao(LinkAclDao linkAclDao) {
        this.linkAclDao = linkAclDao;
    }

    public void setLinkMemberDao(LinkMemberDao linkMemberDao) {
        this.linkMemberDao = linkMemberDao;
    }

    public void setPrivilegeManager(PrivilegeManager privilegeManager) {
        this.privilegeManager = privilegeManager;
    }

    /**
     * @param linkMenuManager the linkMenuManager to set
     */
    public void setLinkMenuManager(LinkMenuManager linkMenuManager) {
        this.linkMenuManager = linkMenuManager;
    }

    /**
     * @param linkOptionManager the linkOptionManager to set
     */
    public void setLinkOptionManager(LinkOptionManager linkOptionManager) {
        this.linkOptionManager = linkOptionManager;
    }

    public void setMenuDao(MenuDao menuDao) {
        this.menuDao = menuDao;
    }
    
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

	/**
     * 检查某类别下是否存在关联系统
     */
    public boolean checkLinkSytemByCategory(Long categoryId) {
        return linkSystemDao.checkLinkSytemByCategory(categoryId);
    }

    @Override
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public FlipInfo selectLinkSystem(FlipInfo fi, Map params) throws BusinessException {
    	if(params==null||params.isEmpty()){
    		params = fi.getParams();
    	}
        Long userId = AppContext.currentUserId();
        if (params.get("categoryId") != null && Long.valueOf(params.get("categoryId").toString()) == 5) {
            List<Long> linkSystemId = findLinkSystemAcl(userId);
            if (!CollectionUtils.isEmpty(linkSystemId)) {
                params.put("linkSystemId", linkSystemId);
                return linkSystemDao.findMemberShareKnowledge(fi, params);
            }
        }
        if (params.get("categoryId") != null && Long.valueOf(params.get("categoryId").toString()) == 6) {
            params.put("creatorType", Constants.LINK_CREATOR_TYPE_MEMBER);
            params.put("createUserId", userId);
            linkSystemDao.findLinkSystemByCreator(fi, params);
            List<HashMap> linkSystems = fi.getData();
            List<Long> linkSystemId = new ArrayList<Long>();
            for (HashMap linkSystem : linkSystems) {
                linkSystemId.add((Long) linkSystem.get("id"));
            }
            linkSystemSort(fi, userId, linkSystemId);
            return fi;
        } else {
            List<Long> linkSystemId = findLinkSystemAcl(userId);
            linkSystemDao.selectLinkSystem(fi, params);
            linkSystemSort(fi, userId, linkSystemId);
            return fi;
        }
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private void linkSystemSort(FlipInfo fi, Long userId, List<Long> linkSystemId) {
        List<HashMap> linkSystems = fi.getData();
        if (!CollectionUtils.isEmpty(linkSystemId)) {
            List<PortalLinkMember> linkMembers = linkMemberDao.findLinkMember(linkSystemId, userId);
            if (!CollectionUtils.isEmpty(linkSystems) && !CollectionUtils.isEmpty(linkMembers)) {
                Map<Long, HashMap> linkMap = new HashMap<Long, HashMap>();
                for (HashMap linkSystem : linkSystems) {
                    linkMap.put((Long) linkSystem.get("id"), linkSystem);
                }
                linkSystems = new ArrayList<HashMap>();
                for (PortalLinkMember linkMember : linkMembers) {
                    if (linkMap.get(linkMember.getLinkSystemId()) != null) {
                        linkSystems.add(linkMap.get(linkMember.getLinkSystemId()));
                        linkMap.remove(linkMember.getLinkSystemId());
                    }
                }
                if (!linkMap.isEmpty()) {
                    Set<Entry<Long, HashMap>> linkSystemMap = linkMap.entrySet();
                    Iterator<Entry<Long, HashMap>> linkIt = linkSystemMap.iterator();
                    while (linkIt.hasNext()) {
                        Entry<Long, HashMap> entry = linkIt.next();
                        linkSystems.add(entry.getValue());
                    }
                }
                fi.setData(linkSystems);
            }
        }
    }

    @Override
    //@CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin})
    public void deleteLinkSystemByIds(List<String> linkSystemIds) throws BusinessException {
        List<Long> ids = new ArrayList<Long>();
        for (String linkSystemId : linkSystemIds) {
            ids.add(Long.valueOf(linkSystemId));
        }
        List<PortalLinkSystem> linkSystems = linkSystemDao.findAllLinkSystem(ids);
        StringBuffer linkSystemNames = new StringBuffer();
        List<Long> menuRoleList = new ArrayList<Long>();
        for (PortalLinkSystem linkSystem : linkSystems) {
            if (linkSystem.getSystem()) {
                linkSystemNames.append(linkSystem.getLname()).append("、");
            } else {
                List<PortalLinkMenu> linkMenus = linkMenuManager.selectLinkMenuBySystemId(linkSystem.getId());
                if (!CollectionUtils.isEmpty(linkMenus)) {
                    for (int i = 0; i < linkMenus.size(); i++) {
                    	PortalLinkMenu portalLinkMenu= linkMenus.get(i);
                    	Long roleId= portalLinkMenu.getRoleId();
                    	V3xOrgRole role= orgManager.getRoleById(roleId);
                    	if(null!=role){
	                    	String code= role.getCode();
	                    	List<V3xOrgRole> relationRoleList= orgManager.getRoleByCode(code, role.getOrgAccountId());
	                    	if(null!=relationRoleList){
	                    		for (V3xOrgRole v3xOrgRole : relationRoleList) {
	                    			menuRoleList.add(v3xOrgRole.getId());
								}
	                    	}
	                        menuRoleList.add(roleId);
                    	}
                    }
                }
            }
        }
        if (linkSystemNames.length() > 0) {
            throw new BusinessException("不能删除系统预置的关联系统：" + linkSystemNames.deleteCharAt(linkSystemNames.length() - 1));
        } else {
            DBAgent.deleteAll(linkSystems);
            if (!CollectionUtils.isEmpty(menuRoleList)) {
                for (Long roleId : menuRoleList) {
                	orgManagerDirect.deleteRole2Entity(roleId, null, null);
                	privilegeManager.deleteByRole(roleId);
                }
            }
            User user = AppContext.getCurrentUser();
            for(PortalLinkSystem linkSystem : linkSystems){
                appLogManager.insertLog(user, AppLogAction.InterSystem_Delete, linkSystem.getLname());
            }
        }
    }

    @Override
    public PortalLinkSystem selectLinkSystem(Long linkSystemId) throws BusinessException {
        PortalLinkSystem linkSystem = linkSystemDao.selectLinkSystemById(linkSystemId);
        try {
            linkSystem = (PortalLinkSystem) BeanUtils.cloneBean(linkSystem);
        } catch (Exception e) {
            logger.error("查询关联系统时cloneBean发生异常", e);
        }
        List<PortalLinkOption> options = linkSystem.getLinkOptions();
        for (PortalLinkOption option : options) {
            option.setParamValue(LightWeightEncoder.decodeString(option.getParamValue()));
        }
        List<PortalLinkMenu> menus = linkSystem.getLinkMenus();
        for (PortalLinkMenu linkMenu : menus) {
            List<PortalLinkMenuAcl> linkMenuAcls = new ArrayList<PortalLinkMenuAcl>();
            if(linkMenu == null){
                logger.error("LinkSystemManagerImpl.selectLinkSystem, linkMenu为空！"); 
            } else {
                List<V3xOrgEntity> orgEntities = orgManager.getEntitysByRole(null, linkMenu.getRoleId());
                for (V3xOrgEntity entity : orgEntities) {
                    PortalLinkMenuAcl menuAcl = new PortalLinkMenuAcl();
                    menuAcl.setUserType(entity.getEntityType());
                    menuAcl.setUserId(entity.getId());
                    linkMenuAcls.add(menuAcl);
                }
                linkMenu.setLinkMenuAcls(linkMenuAcls);
            }
        }
        return linkSystem;
    }
    
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public PortalLinkSystem selectLinkSystemWithOptions(Long linkSystemId) throws BusinessException {
        String hql = "select ls from PortalLinkSystem ls left join fetch ls.linkOptions where ls.id = :id";
        Map params = new HashMap();
        params.put("id", linkSystemId);
        List<PortalLinkSystem> list = (List<PortalLinkSystem>) DBAgent.find(hql, params);
        if (list != null && list.size() > 0) {
            PortalLinkSystem linkSystem = list.get(0);
            try {
                PortalLinkSystem newLinkSystem = (PortalLinkSystem) BeanUtils.cloneBean(linkSystem);
                newLinkSystem.setId(linkSystem.getId());
                List<PortalLinkOption> options = newLinkSystem.getLinkOptions();
                if(options != null && options.size() > 0){
                    for (PortalLinkOption option : options) {
                        option.setParamValue(LightWeightEncoder.decodeString(option.getParamValue()));
                    }
                } else {
                    newLinkSystem.setLinkOptions(new ArrayList<PortalLinkOption>(0));
                }
                return newLinkSystem;
            } catch (Exception e) {
                logger.error("查询关联系统时cloneBean发生异常", e);
            }
        }
        return null;
    }

    @Override
//    @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin})
    public void saveLinkSystem(PortalLinkSystem linkSystem) throws BusinessException {
        PortalLinkSystem existSystem = selectLinkSystem(linkSystem.getLname(), linkSystem.getLinkCategoryId());
        PortalLinkSystem pls = DBAgent.get(PortalLinkSystem.class, linkSystem.getId());
        if (existSystem != null) {
            if (pls != null && !pls.getId().equals(existSystem.getId()) || pls == null) {
                throw new BusinessException("所选类别中已存在名称为 " + linkSystem.getLname() + " 的关联系统！");
            }
        }
        Date now = new Date();
        linkSystem.setCreateUserId(AppContext.currentUserId());
        linkSystem.setCreateTime(now);
        linkSystem.setLastUserId(AppContext.currentUserId());
        linkSystem.setLastUpdate(now);
        linkSystem.setSystem(false);
        List<PortalLinkSection> linkSections = linkSystem.getLinkSections();
        for (PortalLinkSection linkSection : linkSections) {
            linkSection.setCreateDate(now);
        }
        List<PortalLinkOption> options = linkSystem.getLinkOptions();
        for (PortalLinkOption option : options) {
            option.setParamValue(LightWeightEncoder.encodeString(option.getParamValue()));
        }
        List<PortalLinkMenu> linkMenus = linkMenuManager.selectLinkMenuBySystemId(linkSystem.getId());
        if (!CollectionUtils.isEmpty(linkMenus)) {
            for (PortalLinkMenu linkMenu : linkMenus) {
                orgManagerDirect.deleteRole2Entity(linkMenu.getRoleId(), null, null);
                privilegeManager.deleteByRole(linkMenu.getRoleId());
            }
        }
        User user = AppContext.getCurrentUser();
        if (pls == null) {
            DBAgent.save(linkSystem);
            saveMenu(linkSystem);
            appLogManager.insertLog(user, AppLogAction.InterSystem_Create, linkSystem.getLname());
        } else {
            DBAgent.merge(linkSystem);
            saveMenu(linkSystem);
            appLogManager.insertLog(user, AppLogAction.InterSystem_Update, linkSystem.getLname());
        }
        linkSystemIconCache.put(linkSystem.getId(), linkSystem.getImage());//更新关联系统图标缓存
    }

    /**
     * 组装sso菜单数据
     * @param linkSystem
     * @throws BusinessException
     */
    private void saveMenu(PortalLinkSystem linkSystem) throws BusinessException {
        List<PortalLinkMenu> menus = linkSystem.getLinkMenus();
        long parentId = 0;
/*        int pathIndex = Integer.parseInt(menuDao.selectMaxPath(null, 1)) + 1;
        String pathStr = String.valueOf(pathIndex);
        if (pathIndex < 100) {
            pathStr = "0" + pathIndex;
        }
        int index = 0;*/
        int sortId = 100;
        long pId=0;
        for (PortalLinkMenu menu : menus) {
            //权限
            String auth = "";
            List<PortalLinkMenuAcl> menuAuths = menu.getLinkMenuAcls();
            if (CollectionUtils.isEmpty(menuAuths)) {
                continue;
            }
            for (PortalLinkMenuAcl menuAcl : menuAuths) {
                auth += menuAcl.getUserType() + "|" + menuAcl.getUserId() + ",";
            }
            if (auth.length() > 0) {
                auth = auth.substring(0, auth.length() - 1);
            }
            //角色
            V3xOrgRole role = new V3xOrgRole();
            role.setIdIfNew();
            role.setName(menu.getMname() + "_" + UUIDLong.longUUID());
            role.setBond(OrgConstants.ROLE_BOND.SSO.ordinal());
            role.setOrgAccountId(AppContext.currentAccountId());
            role.setCode(String.valueOf(UUIDLong.longUUID()));
            //菜单
            List<PrivMenuBO> privMenus = new ArrayList<PrivMenuBO>();
            PrivMenuBO privMenu = new PrivMenuBO();
            privMenu.setCreatedate(new Date());
            privMenu.setCreateuserid(AppContext.currentUserId());
            privMenu.setName(menu.getMname());
            privMenu.setId(menu.getId());
            privMenu.setExt12(-3);
            privMenu.setSortid(sortId);
            sortId++;
            String url = "/portal/linkSystemController.do?method=linkConnectForMenu&linkSystemId=" + linkSystem.getId()
                    + "&menuId=" + menu.getId();
            privMenu.setUrl(url);
            if (menu.getParentId() == 0) {
                parentId = privMenu.getId();
                privMenu.setParentId(menu.getParentId());
//                privMenu.setPath(pathStr);
                privMenu.setExt2("1");
                privMenu.setIcon((linkSystem.getImage()==null||"".equals(linkSystem.getImage()))?"relatedDefine.png":linkSystem.getImage());
                pId=menu.getId();
                privMenu= privilegeMenuManager.getMenuPath(privMenu, null);
            } else {
            	PrivMenuBO pm=privilegeManager.findMenuById(pId);
           /* 	if(pm!=null&&pm.getId()!=0){
            		pathStr=pm.getPath();
            	}*/
                privMenu.setParentId(parentId);
//                privMenu.setPath(pathStr + (100 + index++));
                privMenu.setExt2("2");
                privMenu.setIcon((linkSystem.getImage()==null||"".equals(linkSystem.getImage()))?"related.png":linkSystem.getImage());
                privMenu= privilegeMenuManager.getMenuPath(privMenu, pm);
            }
            if(menu.getOpenType() == 2){
                privMenu.setTarget("mainfrm");
            } else {
                privMenu.setTarget("newWindow");
            }
            privMenus.add(privMenu);
            privilegeManager.insertMenus(privMenus, role, auth);
            menu.setRoleId(role.getId());
            DBAgent.merge(menu);
        }
    }

    @SuppressWarnings("deprecation")
    @Override
    public String magerSsourl(long userId, PortalLinkSystem linkSystem, String ssoTargetUrl) throws BusinessException {
        if (linkSystem == null) {
            return "";
        }

        Map<String, String> optionVos = new HashMap<String, String>();
        List<PortalLinkOption> options = linkSystem.getLinkOptions();
        if (options != null && options.size() > 0) {
            Map<Long, PortalLinkOption> linkOptionMap = new HashMap<Long, PortalLinkOption>();
            List<Long> optionIds = new ArrayList<Long>();
            for (PortalLinkOption lo : options) {
                optionIds.add(lo.getId());
                linkOptionMap.put(lo.getId(), lo);
                optionVos.put(lo.getParamSign(), lo.getParamValue());
            }
            List<PortalLinkOptionValue> plovs = linkOptionManager.selectLinkOptionValues(optionIds, userId);
            for (PortalLinkOptionValue plov : plovs) {
                PortalLinkOption plo = linkOptionMap.get(plov.getLinkOptionId());
                optionVos.put(plo.getParamSign(), plov.getValue());
            }
        }
        if (ssoTargetUrl == null || ssoTargetUrl.trim().length() == 0) {
            ssoTargetUrl = linkSystem.getUrl();
        }
        String baseSource = ssoTargetUrl;

        StringBuffer source = new StringBuffer(baseSource);
        if (baseSource.indexOf("?") == -1) {
            if (optionVos.size() > 0) {
                source.append("?");
            }
        } else {
            source.append("&");
        }

        for (Iterator<String> iter = optionVos.keySet().iterator(); iter.hasNext();) {
            String n = iter.next();
            source.append(n + "=" + java.net.URLEncoder.encode(optionVos.get(n)) + "&");
        }

        return source.toString();
    }

    @Override
    public PortalLinkSystem selectLinkSystem(String lname, Long categoryId) {
        return linkSystemDao.selectLinkSystem(lname, categoryId);
    }

    @Override
    public List<PortalLinkSystem> findLinkSystemBySize(long userId, int size, long categoryId) throws BusinessException {
        List<Long> linkSystemId = findLinkSystemAcl(userId);
        List<PortalLinkSystem> linkSystems = new ArrayList<PortalLinkSystem>();
        if (!CollectionUtils.isEmpty(linkSystemId)) {
            linkSystems = linkSystemDao.selectLinkSystem(linkSystemId, linkSystemId.size(), categoryId);
            List<PortalLinkMember> linkMembers = linkMemberDao.findLinkMember(linkSystemId, userId);
            linkSystems = linkSystemSortByMember(linkSystems, linkMembers);
            if(linkSystems.size() > size && size>0){ 
            	linkSystems = linkSystems.subList(0, size);
            }
        }
        return linkSystems;
    }

    @Override
    public boolean isUseTheSystem(Long userId, Long systemId, Long systemCategoryId) throws BusinessException {
        PortalLinkSystem ls = DBAgent.get(PortalLinkSystem.class, systemId);
        if(userId.equals(ls.getCreateUserId())){
            return true;
        }
        List<Long> userInfo = orgManager.getAllUserDomainIDs(userId);
        return linkSystemDao.isUseTheSystem(systemId, systemCategoryId, userInfo);
    }

    @Override
    public List<Long> findLinkSystemAcl(long userId) throws BusinessException {
        List<Long> userInfo = new ArrayList<Long>();
        boolean isInternal = AppContext.getCurrentUser().isInternal();
        if(isInternal){ 
            userInfo = orgManager.getAllUserDomainIDs(userId); 
        }else{ 
            userInfo = orgManager.getUserDomainIDs(userId, AppContext.currentAccountId(), V3xOrgEntity.ORGENT_TYPE_MEMBER,V3xOrgEntity.ORGENT_TYPE_DEPARTMENT);
        }
        return linkAclDao.findLinkByAcl(userInfo);
    }

    @Override
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public FlipInfo selectLinkSystemByUser(FlipInfo fi, Map param) throws BusinessException {
        Long userId = AppContext.currentUserId();
        List<Long> linkSystemId = findLinkSystemAcl(userId);
        if (!CollectionUtils.isEmpty(linkSystemId)) {
            param.put("linkSystemId", linkSystemId);
            linkSystemDao.selectLinkSystem(fi, param);
        }
        //if (fi.getSortField() == null || param.get("ordered") != null) {
            linkSystemSort(fi, userId, linkSystemId);
        //}
        return fi;
    }

    private List<PortalLinkSystem> linkSystemSortByMember(List<PortalLinkSystem> linkSystems,
            List<PortalLinkMember> linkMembers) {
        if (!CollectionUtils.isEmpty(linkSystems) && !CollectionUtils.isEmpty(linkMembers)) {
            Map<Long, PortalLinkSystem> linkMap = new HashMap<Long, PortalLinkSystem>();
            for (PortalLinkSystem linkSystem : linkSystems) {
                linkMap.put(linkSystem.getId(), linkSystem);
            }
            linkSystems = new ArrayList<PortalLinkSystem>();
            for (PortalLinkMember linkMember : linkMembers) {
                if (linkMap.get(linkMember.getLinkSystemId()) != null) {
                    linkSystems.add(linkMap.get(linkMember.getLinkSystemId()));
                    linkMap.remove(linkMember.getLinkSystemId());
                }
            }
            if (!linkMap.isEmpty()) {
                Set<Entry<Long, PortalLinkSystem>> linkSystemMap = linkMap.entrySet();
                Iterator<Entry<Long, PortalLinkSystem>> linkIt = linkSystemMap.iterator();
                while (linkIt.hasNext()) {
                    Entry<Long, PortalLinkSystem> entry = linkIt.next();
                    linkSystems.add(entry.getValue());
                }
            }
        }
        return linkSystems;
    }

    @Override
    public List<List<PortalLinkSystem>> findAllLinkSystem(int doType) throws BusinessException {
        List<List<PortalLinkSystem>> ret = new ArrayList<List<PortalLinkSystem>>();
        List<PortalLinkSystem> inners = new ArrayList<PortalLinkSystem>();
        List<PortalLinkSystem> outters = new ArrayList<PortalLinkSystem>();
        List<PortalLinkSystem> commons = new ArrayList<PortalLinkSystem>();
        List<PortalLinkSystem> sysKnowledges = new ArrayList<PortalLinkSystem>();
        List<PortalLinkSystem> memberKnowledges = new ArrayList<PortalLinkSystem>();
        Map<Long, List<PortalLinkSystem>> customMap = new HashMap<Long, List<PortalLinkSystem>>();
        List<PortalLinkSystem> linkSystemList = new ArrayList<PortalLinkSystem>();
        if (doType == Constants.LIST_MORE_TYPE_ALL) {
            linkSystemList = findSysLinkSystem(AppContext.currentUserId());
        } else if (doType == Constants.LIST_MORE_TYPE_KNOWLEDGE) {
            long userId = AppContext.currentUserId();
            sysKnowledges = findSysKnowledgeSystem(userId);
            memberKnowledges = findShareLinkSystem(userId);
            linkSystemList = findKnowledgeSystemByCreator(userId);
        } else {
            linkSystemList = findCommonLinkSystem(AppContext.currentUserId());
        }
        for (PortalLinkSystem ls : linkSystemList) {
            if (ls.getLinkCategoryId() == Constants.LINK_IN) {
                inners.add(ls);
            } else if (ls.getLinkCategoryId() == Constants.LINK_OUT) {
                outters.add(ls);
            } else if (ls.getLinkCategoryId() == Constants.LINK_COMMON) {
                commons.add(ls);
            } else {
                // 自定义
                List<PortalLinkSystem> lss = customMap.get(ls.getLinkCategoryId());
                if (lss == null) {
                    lss = new ArrayList<PortalLinkSystem>();
                    lss.add(ls);
                    customMap.put(ls.getLinkCategoryId(), lss);
                } else {
                    lss.add(ls);
                }
            }
        }
        if (doType == Constants.LIST_MORE_TYPE_ALL) {
            ret.add(commons);
            ret.add(inners);
            ret.add(outters);
        } else if (doType == Constants.LIST_MORE_TYPE_KNOWLEDGE) {
            ret.add(sysKnowledges);
            ret.add(memberKnowledges);
        } else {
            ret.add(commons);
        }
        if (customMap.size() > 0) {
            Set<Long> set = customMap.keySet();
            for (Long categoryId : set) {
                ret.add(customMap.get(categoryId));
            }
        }
        return ret;
    }

    @Override
    public void saveLinkMember(List<Map<String, Object>> linkMembers) {
        List<Long> linkSystemIdList = new ArrayList<Long>();
        long userId = AppContext.currentUserId();
        if (linkMembers != null && linkMembers.size() > 0) {
            List<PortalLinkMember> members = ParamUtil.mapsToBeans(linkMembers, PortalLinkMember.class, true);
            for (PortalLinkMember member : members) {
                member.setMemberId(userId);
                linkSystemIdList.add(member.getLinkSystemId());
            }
            List<PortalLinkMember> oldMembers = linkMemberDao.findLinkMember(linkSystemIdList, userId);
            linkMemberDao.deleteLinkMember(oldMembers);
            linkMemberDao.saveLinkMember(members);
        }
    }

    @Override
    public List<PortalLinkSystem> findAllKnowledgeSystem(long userId, int size) throws BusinessException {
        List<PortalLinkSystem> linkSystemList = new ArrayList<PortalLinkSystem>();
        //系统知识链接
        List<PortalLinkSystem> sysKnowledges = findLinkSystemBySize(userId, size, Constants.LINK_CATEGORY_KNOWLEDGE_ID);
        int sysKnowledgeSize = 0;
        if(!CollectionUtils.isEmpty(sysKnowledges)){
            sysKnowledgeSize = sysKnowledges.size();
        }
        if(sysKnowledgeSize == size){
            linkSystemList.addAll(sysKnowledges);
        } else {
            if(sysKnowledgeSize > 0) linkSystemList.addAll(sysKnowledges);
            //余下的个数
            int leftSize = size - sysKnowledgeSize;
            //个人自定义的知识链接
            List<PortalLinkSystem> myKnowledges = linkSystemDao.findLinkSystemByCreator(userId, Constants.LINK_CREATOR_TYPE_MEMBER, leftSize);
            int myKnowledgeSize = 0;
            if(!CollectionUtils.isEmpty(myKnowledges)){
                myKnowledgeSize = myKnowledges.size();
            }
            if(myKnowledgeSize == leftSize){
                linkSystemList.addAll(myKnowledges);
            } else {
                if(myKnowledgeSize > 0) linkSystemList.addAll(myKnowledges);
                //余下的个数
                leftSize = leftSize - myKnowledgeSize;
                //他人分享给我的知识链接
                List<PortalLinkSystem> memberKnowledges = findShareLinkSystem(userId);
                int memberKnowledgeSize = 0;
                if (!CollectionUtils.isEmpty(memberKnowledges)) {
                    memberKnowledgeSize = memberKnowledges.size();
                    //余下的他人分享的知识链接个数
                    leftSize = (leftSize < memberKnowledgeSize)? leftSize : memberKnowledgeSize;
                    for (int i = 0; i < leftSize; i++) {
                        linkSystemList.add(memberKnowledges.get(i));
                    }
                }
            }
        }

        for (PortalLinkSystem linkSystem : linkSystemList) {
            String url = "/seeyon/portal/linkSystemController.do?method=linkConnect&linkId=" + linkSystem.getId();
            String icon = linkSystem.getImage();
            if (Strings.isBlank(icon) || (icon.indexOf("defaultLinkSystemImage") != -1)) {
                icon = "/decorations/css/images/portal/defaultLinkSystemImage.png";
            } else {
                icon = icon.replaceFirst("/seeyon", "");
            }
            linkSystem.setImage(icon);
            linkSystem.setUrl(url);
        }
        return linkSystemList;
    }

    @Override
    public List<PortalLinkSystem> findKnowledgeSystemByCreator(long userId) throws BusinessException {
        int userType = Constants.LINK_CREATOR_TYPE_MEMBER;
        List<PortalLinkSystem> linkSystems = linkSystemDao.findLinkSystemByCreator(userId, userType, 0);
        List<Long> linkSystemId = new ArrayList<Long>();
        for (PortalLinkSystem linkSystem : linkSystems) {
            linkSystemId.add(linkSystem.getId());
        }
        if (!CollectionUtils.isEmpty(linkSystemId)) {
            List<PortalLinkMember> linkMembers = linkMemberDao.findLinkMember(linkSystemId, userId);
            linkSystems = linkSystemSortByMember(linkSystems, linkMembers);
        }
        return linkSystems;
    }

    @Override
    public List<PortalLinkSystem> findLinkSystemBySharerType(long userId, int creatorType, boolean includeKnowledge)
            throws BusinessException {
        List<Long> linkSystemId = findLinkSystemAcl(userId);
        List<PortalLinkSystem> linkSystems = new ArrayList<PortalLinkSystem>();
        if (!CollectionUtils.isEmpty(linkSystemId)) {
            linkSystems = linkSystemDao.findLinkSystemBySharerType(linkSystemId, creatorType, includeKnowledge, userId);
            List<PortalLinkMember> linkMembers = linkMemberDao.findLinkMember(linkSystemId, userId);
            linkSystems = linkSystemSortByMember(linkSystems, linkMembers);
        }
        return linkSystems;
    }

    @Override
    public List<PortalLinkSystem> findAllLinkSystem(long userId) throws BusinessException {
        List<Long> linkSystemId = findLinkSystemAcl(userId);
        List<PortalLinkSystem> linkSystems = new ArrayList<PortalLinkSystem>();
        if (!CollectionUtils.isEmpty(linkSystemId)) {
            linkSystems = linkSystemDao.findAllLinkSystem(linkSystemId);
            List<PortalLinkMember> linkMembers = linkMemberDao.findLinkMember(linkSystemId, userId);
            linkSystems = linkSystemSortByMember(linkSystems, linkMembers);
        }
        return linkSystems;
    }

    @Override
    public List<PortalLinkSystem> findSysLinkSystem(long userId) throws BusinessException {
        return findLinkSystemBySharerType(userId, Constants.LINK_CREATOR_TYPE_SYSTEMADMIN, false);
    }

    @Override
    public List<PortalLinkSystem> findShareLinkSystem(long userId) throws BusinessException {
        return findLinkSystemBySharerType(userId, Constants.LINK_CREATOR_TYPE_MEMBER, true);
    }

    @Override
    public List<PortalLinkSystem> findCommonLinkSystem(long userId) throws BusinessException {
        return findLinkSystemBySize(userId, 0, Constants.LINK_CATEGORY_COMMON_ID);
    }

    @Override
    public List<PortalLinkSystem> findSysKnowledgeSystem(long userId) throws BusinessException {
        return findLinkSystemBySize(userId, 0, Constants.LINK_CATEGORY_KNOWLEDGE_ID);
    }

    @Override
    public List<PortalLinkSystem> findLinkSystemByCreator(long userId, long linkCategoryId) {
        List<PortalLinkSystem> linkSystems = linkSystemDao.findLinkSystemByCreator(userId, linkCategoryId);
        if (!CollectionUtils.isEmpty(linkSystems)) {
            List<Long> linkIds = new ArrayList<Long>();
            for (PortalLinkSystem linkSystem : linkSystems) {
                linkIds.add(linkSystem.getId());
            }
            List<PortalLinkMember> linkMembers = linkMemberDao.findLinkMember(linkIds, userId);
            linkSystems = linkSystemSortByMember(linkSystems, linkMembers);
        }
        return linkSystems;
    }

    @Override
    public String getUUID() throws BusinessException {
        String retValue = String.valueOf(UUIDLong.longUUID()) + "L";
        return retValue;
    }

    @SuppressWarnings("rawtypes")
    @Override
    public long selectMaxSort(long categoryId) {
        long userId = AppContext.currentUserId();
        String hql = "select max(orderNum) from PortalLinkSystem where createUserId=:createUserId and linkCategoryId =:linkCategoryId";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("createUserId", userId);
        params.put("linkCategoryId", categoryId);
        List result = DBAgent.find(hql, params);
        Long maxSort = (Long) result.get(0);
        if (maxSort == null) {
            return 0;
        } else {
            return maxSort;
        }
    }

    @Override
    public PortalLinkSystem selectLinkSystemByUrl(String linkSystemUrl) throws BusinessException {
        PortalLinkSystem portalLinkSystem= linkSystemDao.findLinkSystemByUrl(linkSystemUrl);
        return portalLinkSystem;
    }

	@Override
	public String getLinkSytemIconById(Long linkSystemId) {
		String icon=linkSystemIconCache.get(linkSystemId);
		if(icon==null){
			List<Long> id=new ArrayList<Long>();
			id.add(linkSystemId);
			List<PortalLinkSystem> sys=this.linkSystemDao.findAllLinkSystem(id);
			if(sys!=null&&sys.size()>0){
				icon=sys.get(0).getImage();
			}
		}
		return icon;
	}

	public void setPrivilegeMenuManager(PrivilegeMenuManager privilegeMenuManager) {
		this.privilegeMenuManager = privilegeMenuManager;
	}
}
