package com.seeyon.ctp.menu.manager;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserCustomizeCache;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.portal.manager.PortalCacheManager;
import com.seeyon.ctp.portal.manager.PortalSYSMenuManager;
import com.seeyon.ctp.portal.po.PortalSpaceMenu;
import com.seeyon.ctp.portal.space.bo.MenuTreeNode;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.privilege.dao.PrivilegeCache;
import com.seeyon.ctp.privilege.manager.PrivilegeMenuManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;

public class PortalMenuManagerImpl implements PortalMenuManager {

	// 插件菜单
	private MenuManager pluginMenuManager;

	private PortalCacheManager portalCacheManager;

	private PortalSYSMenuManager portalSYSMenuManager;

	private PrivilegeCache privilegeCache;

	private PrivilegeMenuManager privilegeMenuManager;

	@Override
	public void deleteSpaceMenu(Long spaceId) {
		 String hql = " delete from PortalSpaceMenu where spaceId = :spaceId";
	        Map<String,Object> params = new HashMap<String,Object>();
	        params.put("spaceId", spaceId);
	        DBAgent.bulkUpdate(hql, params);
	        portalCacheManager.removePortalSpaceMenuCache(spaceId);

	}

	@Override
	public List<MenuTreeNode> getAllUseAbleMenus() throws BusinessException {
		 List<MenuTreeNode> menuTree = new ArrayList<MenuTreeNode>();
	        //List<PrivMenuBO> allMenus = privilegeManage.getAllUseAbleMenus();
	        List<PrivMenuBO> allMenus = portalSYSMenuManager.getOrderedSYSMenus();
	        MenuTreeNode node = null;
	        for (PrivMenuBO pm : allMenus) {
	        	Long parentId = pm.getParentId();
	        	Integer ext12 = pm.getExt12();
	            if(parentId != null && parentId != 0l && ext12 != null && ext12.intValue() != 0 && ext12.intValue() != -3){
	                //过滤掉自定义（业务生成器生成的）二级菜单
	                continue;
	            }
	            node = new MenuTreeNode(pm);
	            menuTree.add(node);
	        }
	        return menuTree;
	}

	@Override
	public List<MenuBO> getCustomizeMenusOfMember(User user) throws BusinessException {
		return getCustomizeMenusOfMember(user, null, false);
	}

	@Override
	public List<MenuBO> getCustomizeMenusOfMember(User user, Boolean isChange) throws BusinessException {
		return getCustomizeMenusOfMember(user, null, isChange);
	}

	@Override
	public List<MenuBO> getCustomizeMenusOfMember(User user, List<MenuBO> menus) throws BusinessException {
		return getCustomizeMenusOfMember(user, menus, false);
	}

	@Override
	public List<MenuBO> getCustomizeMenusOfMember(User user, List<MenuBO> menus, Boolean isChange)
			throws BusinessException {
		Long memberId = user.getId(), accountId = user.getLoginAccount();
		String ctxKey = "Menu-" + memberId + "-" + accountId;
		boolean userLocaleChange=false;
		if(!user.getLocale().equals(portalCacheManager.getUserLocalByKey(ctxKey))){
			userLocaleChange=true;
		}
		if (portalCacheManager.getPortalMenusByKey(ctxKey) != null && !isChange &&!userLocaleChange
				&& !privilegeMenuManager.getMenuValidity(memberId, accountId)
				&& privilegeMenuManager.validateMemberMenuLastDate(memberId, accountId)&&!user.isAdmin()) {
			return portalCacheManager.getPortalMenusByKey(ctxKey);
		} else {

			
			Map<String, String> cmenus = user.getCustomizeJson(CustomizeConstants.MENU_ORDER, Map.class);
			List<MenuBO> customizeMenus=this.getCustomizeMenus(user.getId(), user.getLoginAccount(), user.isAdmin(), menus, cmenus);
			//存储用户菜单集合至共享缓存
			portalCacheManager.putPortalMenusCache(ctxKey, customizeMenus);
			//更新本地会员菜单最后一次更新时间
			privilegeMenuManager.updateLocalMemberMenuLastDate(memberId, accountId);
			//存储用户地区语言集合至本地缓存
			portalCacheManager.putUserLocalCache(ctxKey, user.getLocale());
			return customizeMenus;
		}
	}

	@Override
	public List<MenuBO> getCustomizeMenus(Long userId,Long accountId,boolean isadmin,List<MenuBO> menus,Map<String,String> cmenus) throws BusinessException{
		if (CollectionUtils.isEmpty(menus)) {
			menus = this.getMenusOfMember(userId,accountId,isadmin);
		}
		/**
		 * 防护：后台管理员不读个性化设置
		 */
		if (cmenus == null || isadmin) {
			cmenus = new HashMap<String, String>();
		}
		String loginAccountId = String.valueOf(accountId);
		String customizeMenuIds = cmenus.get(loginAccountId);		
		List<MenuBO> customizeMenus = new ArrayList<MenuBO>();
		List<String> cmenuIds = JSONUtil.parseJSONString(customizeMenuIds, List.class);
		if (Strings.isBlank(customizeMenuIds)) {
			customizeMenus = menus;
		} else {
			for (MenuBO menu : menus) {
				String menuId = String.valueOf(menu.getId());
				if (cmenuIds.contains(menuId)) {
					customizeMenus.add(menu);
				}
			}
		}
		final List<String> menuIds = cmenuIds;
		Comparator<MenuBO> comparator = new Comparator<MenuBO>() {
			@Override
			public int compare(final MenuBO o1, final MenuBO o2) {
				int r = o1.privSortid() - o2.privSortid();
				if (menuIds != null) {
					String i1 = String.valueOf(o1.getId()), i2 = String.valueOf(o2.getId());
					int idx1 = menuIds.indexOf(i1), idx2 = menuIds.indexOf(i2);
					if (idx1 != -1 && idx2 != -1) {
						r = idx1 - idx2;
					} else if (idx1 != -1) {
						r = -1;
					} else if (idx2 != -1) {
						r = 1;
					}
				}
				return r;
			}
		};
		Collections.sort(customizeMenus, comparator);
		return customizeMenus;
	}
	
	@Override
	public List<MenuBO> getMenusOfMember(Long userId,Long accountId,boolean isAdmin) throws BusinessException {
		List<MenuBO> menus = new ArrayList<MenuBO>();
		Map<Long, PrivMenuBO> curMenusMap=null;
		List<PrivMenuBO> curMenus = new ArrayList<PrivMenuBO>();
		// 判断管理员环境是否拥有和开始了m1
		if (isAdmin) { //&& AppContext.hasPlugin("mm1")只要是管理员菜单不走缓存
			curMenusMap =  privilegeMenuManager.reSetMM1Menus(userId, accountId);
			curMenus.addAll(curMenusMap.values());
		} else {
			curMenusMap = privilegeMenuManager.getMenus(userId, accountId);
			curMenus = portalSYSMenuManager.wrapMenuBOListOfMember(curMenusMap);
		}

		Collection<PrivMenuBO> allMenus = privilegeCache.getAllMenuForCollection();

		Map<String, MenuBO> allMenuMap = new HashMap<String, MenuBO>();
		for (PrivMenuBO pm : allMenus) {
			MenuBO mbo = new MenuBO(pm);
			mbo.setUrl(pm.getResourceNavurl());
			mbo.setResourceCode(pm.getResourceCode());
			allMenuMap.put(pm.getPath(), mbo);
		}

		String path;
		int level;
		List<Long> menuIds = new ArrayList<Long>();
		for (PrivMenuBO pm : curMenus) {
			path = pm.getPath();
			level = path.length();
			int i = level / privilegeCache.getMenuPathLength();
			MenuBO prt = null;
			for (int j = 1; j <= i; j++) {
				String pPath = path.substring(0, j * privilegeCache.getMenuPathLength());
				MenuBO tmp = allMenuMap.get(pPath);
				if (tmp == null || "2".equals(pm.getExt8())) {
					break;
				}
				if (j == 1) {
					if (!menus.contains(tmp)) {
						menus.add(tmp);
						menuIds.add(tmp.getId());
					}
				} else {
					if (!prt.containsItem(tmp)) {
						prt.addItem(tmp);
					}
				}
				prt = tmp;
			}
		}
		
		List<MenuBO> hasItemMenus = new ArrayList<MenuBO>();
		for (MenuBO mb : menus) {
			if (CollectionUtils.isNotEmpty(mb.getItems())) {
				hasItemMenus.add(mb);
			}
		}
		// 增加插件菜单
		List<MenuBO> pluginMenus = pluginMenuManager.getAccessMenuBO(userId, accountId);
		if (CollectionUtils.isNotEmpty(pluginMenus)) {
			hasItemMenus.addAll(pluginMenus);
		}
		return hasItemMenus;
	}
	@Override
	public List<MenuBO> getMenusOfMember(User user) throws BusinessException {
		return this.getMenusOfMember(user.getId(), user.getLoginAccount(), user.isAdmin());
	}

	public MenuManager getPluginMenuManager() {
		return pluginMenuManager;
	}

	public PortalCacheManager getPortalCacheManager() {
		return portalCacheManager;
	}

	public PortalSYSMenuManager getPortalSYSMenuManager() {
		return portalSYSMenuManager;
	}

	public PrivilegeCache getPrivilegeCache() {
		return privilegeCache;
	}

	public PrivilegeMenuManager getPrivilegeMenuManager() {
		return privilegeMenuManager;
	}

	@Override
	public List<MenuTreeNode> getSpaceMenuIds(Long spaceId) throws BusinessException {
		 List<PortalSpaceMenu> portalSpaceMenus = this.findSpaceMenusBySpaceId(spaceId);//DBAgent.findByNamedQuery("space_findSpaceMenusBySpaceId", params);
	        List<MenuTreeNode> allMenus = this.getAllUseAbleMenus();

	        if(CollectionUtils.isNotEmpty(portalSpaceMenus)){
	            Map<String,PortalSpaceMenu> spaceMenuMap = new HashMap<String,PortalSpaceMenu>();
	            for(PortalSpaceMenu spaceMenu : portalSpaceMenus){
	                String spaceMenuId = "menu_"+spaceMenu.getMenuId();
	                spaceMenuMap.put(spaceMenuId, spaceMenu);
	            }
	            for(MenuTreeNode node : allMenus){
	                PortalSpaceMenu menu = spaceMenuMap.get(node.getIdKey());
	                if(menu!=null){
	                    node.setSort(menu.getSortId().toString());
	                    node.setChecked(menu.getMenuChecked()==1?true:false);
	                }
	            }

	            Comparator<MenuTreeNode> comparator = new Comparator<MenuTreeNode>() {
	                @Override
	                public int compare(final MenuTreeNode o1, final MenuTreeNode o2) {
	                    if(Strings.isBlank(o1.getSort())||Strings.isBlank(o2.getSort())){
	                        return 0;
	                    }else{
	                        return Integer.parseInt(o1.getSort())-Integer.parseInt(o2.getSort());
	                    }
	                }
	            };
	            Collections.sort(allMenus, comparator);
	        }
	        MenuTreeNode rootNode = new MenuTreeNode();
	        rootNode.setIdKey("menu_0");
	        String rootName = ResourceUtil.getString("menuManager.menuTree.root.label");
	        rootNode.setNameKey(rootName);
	        rootNode.setpIdKey(null);
	        rootNode.setUrlKey(null);
	        rootNode.setIconKey(null);
	        allMenus.add(rootNode);
	        return allMenus;
	}

	@Override
	public List<MenuBO> getUnselectedMenusOfMember(User user, List<MenuBO> allMenus, List<MenuBO> customizeMenus)
			throws BusinessException {
		  if(CollectionUtils.isEmpty(allMenus)){
	            allMenus = this.getMenusOfMember(user);
	        }
	        if(CollectionUtils.isEmpty(customizeMenus)){
	            customizeMenus = this.getCustomizeMenusOfMember(user, allMenus);
	        }
	        List<MenuBO> unSelectedMenus = new ArrayList<MenuBO>();
	        if(!CollectionUtils.isEmpty(customizeMenus)){
	            for(MenuBO menu : allMenus){
	                if(!customizeMenus.contains(menu)){
	                    unSelectedMenus.add(menu);
	                }
	            }
	        }else{
	            unSelectedMenus = allMenus;
	        }
	        return unSelectedMenus;
	}

	@Override
	public void saveMenuSort(String selectedMenusString) throws BusinessException {
		 User user = AppContext.getCurrentUser();
	        Map<String,String> customMenus = user.getCustomizeJson(CustomizeConstants.MENU_ORDER, Map.class);
	        if(customMenus == null){
	            customMenus = new HashMap<String, String>();
	        }
	        String loginAccountId = String.valueOf(user.getLoginAccount());
	        customMenus.put(loginAccountId, selectedMenusString);
	        UserCustomizeCache.setCustomize(CustomizeConstants.MENU_ORDER,JSONUtil.toJSONString(customMenus));
	        List<MenuBO> menus = this.getCustomizeMenusOfMember(user, true);
	        UserHelper.setMenus(menus);

	}

	@Override
	public void saveSpaceMenu(Long spaceId, List<Map<String, Object>> menus) {
		this.deleteSpaceMenu(spaceId);
        if(!CollectionUtils.isEmpty(menus)){
        	ArrayList<PortalSpaceMenu> spaceMenus = new ArrayList<PortalSpaceMenu>();
            for(int i=0; i<menus.size();i++){
                Map<String,Object> menu = menus.get(i);
                String menuId = ((String)menu.get("id")).split("_")[1];
                int isChecked = ((Boolean)menu.get("checked")) == true?1:0;
                String sort = String.valueOf(menu.get("sort"));
                PortalSpaceMenu spaceMenu = new PortalSpaceMenu();
                spaceMenu.setIdIfNew();
                spaceMenu.setSpaceId(spaceId);
                spaceMenu.setMenuId(Long.valueOf(menuId));
                spaceMenu.setSortId(Integer.parseInt(sort));
                spaceMenu.setMenuChecked(isChecked);
                spaceMenus.add(spaceMenu);
            }
            DBAgent.saveAll(spaceMenus);
            portalCacheManager.putPortalSpaceMenuCache(spaceId, spaceMenus);
        }

	}

	public void setPluginMenuManager(MenuManager pluginMenuManager) {
		this.pluginMenuManager = pluginMenuManager;
	}

	public void setPortalCacheManager(PortalCacheManager portalCacheManager) {
		this.portalCacheManager = portalCacheManager;
	}

	public void setPortalSYSMenuManager(PortalSYSMenuManager portalSYSMenuManager) {
		this.portalSYSMenuManager = portalSYSMenuManager;
	}

	public void setPrivilegeCache(PrivilegeCache privilegeCache) {
		this.privilegeCache = privilegeCache;
	}

	public void setPrivilegeMenuManager(PrivilegeMenuManager privilegeMenuManager) {
		this.privilegeMenuManager = privilegeMenuManager;
	}

	@Override
	public List<PortalSpaceMenu> findSpaceMenusBySpaceId(Long spaceId) {
		if(spaceId==null)return new ArrayList<PortalSpaceMenu>();
		return portalCacheManager.getPortalSpaceMenuCacheByKey(spaceId);
	}

}
