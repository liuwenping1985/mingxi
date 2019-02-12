/**
 * $Author:Macx$
 * $Rev: 1.0 $
 * $Date:: 2014-3-4 上午10:39:45#$:
 *
 * Copyright (C) 2014 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */

package com.seeyon.ctp.menu.manager;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.menu.check.MenuCheck;
import com.seeyon.ctp.plugin.PluginMainMenu;
import com.seeyon.ctp.plugin.PluginMenu;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;

/**
 * <p>Title: 自定义主菜单</p>
 * <p>Description: 取指定用户可以访问的菜单</p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: seeyon.com</p>
 * @since APP5.1
 */
public class MenuManagerImpl implements MenuManager {
	
	private static final Log log = LogFactory.getLog(MenuManagerImpl.class);
	
	public static Map<String, PluginMainMenu> pluginMainMenuMap = new HashMap<String, PluginMainMenu>();
	
    public static void init(){
        pluginMainMenuMap = AppContext.getBeansOfType(PluginMainMenu.class);
    }
    
    @Override
    public List<MenuBO> getAccessMenuBO(long memberId, long loginAccountId) {
        List<MenuBO> menuBOList = new ArrayList<MenuBO>();
        Collection<PluginMainMenu> collection = pluginMainMenuMap.values();
        Iterator<PluginMainMenu> it = collection.iterator();
        while (it.hasNext()) {
            PluginMainMenu pluginMainMenu = it.next();
            if(pluginMainMenu.getId() == null){
                continue;
            }
            MenuCheck menuCheck = pluginMainMenu.getMenuCheck();
            if (menuCheck != null) {
                boolean canAccess = menuCheck.check(memberId, loginAccountId);
                if (canAccess) {
                    menuBOList.add(getMenuBO(memberId, loginAccountId, pluginMainMenu));
                }
            } else {
                menuBOList.add(getMenuBO(memberId, loginAccountId, pluginMainMenu));
                log.warn("PluginMainMenu对象中属性menuCheck为null！");
            }
        }
        return menuBOList;
    }
	
    //根据PluginMainMenu获取MenuBO对象
    private MenuBO getMenuBO(long memberId, long loginAccountId, PluginMainMenu pluginMainMenu) {
        List<MenuBO> menuBOitems = new ArrayList<MenuBO>();
        PrivMenuBO privMenu = new PrivMenuBO();
        privMenu.setName(pluginMainMenu.getName());
        privMenu.setIcon(pluginMainMenu.getIcon());
        privMenu.setId(pluginMainMenu.getId());
        privMenu.setSortid(pluginMainMenu.getSortId());
        MenuBO menuBO = new MenuBO(privMenu);
        
        PluginMenu[] pluginMenus = pluginMainMenu.getChildren();
        if (pluginMenus != null) {
            for (PluginMenu pluginMenu : pluginMenus) {
                MenuCheck menuCheck = pluginMenu.getMenuCheck();
                if (menuCheck != null) {
                    boolean canAccess = menuCheck.check(memberId, loginAccountId);
                    if (canAccess) {
                        menuBOitems.add(getMenuBO(pluginMenu));
                    }
                } else {
                    menuBOitems.add(getMenuBO(pluginMenu));
                    log.warn("PluginMenu对象中属性menuCheck为null！");
                }
            }
        }
        menuBO.setItems(menuBOitems);
        return menuBO;
    }
    
    //根据PluginMenu获取MenuBO对象
    private MenuBO getMenuBO(PluginMenu pluginMenu) {
        PrivMenuBO privMenu = new PrivMenuBO();
        privMenu.setName(pluginMenu.getName());
        privMenu.setIcon(pluginMenu.getIcon());
        privMenu.setId(pluginMenu.getId());
        privMenu.setTarget(pluginMenu.getTarget());
        MenuBO menuBO = new MenuBO(privMenu);
        menuBO.setUrl(pluginMenu.getUrl());
        return menuBO;
    }
}