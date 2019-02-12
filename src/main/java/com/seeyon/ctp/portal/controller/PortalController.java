/**
 * $Author: leikj $
 * $Rev: 4194 $
 * $Date:: 2012-09-19 18:17:52 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserCustomizeCache;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.config.IConfigPublicKey;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.menu.manager.PortalMenuManager;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.bo.MenuTreeNode;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SpaceState;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title: 首页公共控制器类</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class PortalController extends BaseController {

    private SpaceManager                 spaceManager;
    //考勤管理
    public static final String           CARD_ENABLED = "enable";
    
    private PortalMenuManager portalMenuManager;
    
    public void setPortalMenuManager(PortalMenuManager portalMenuManager) {
		this.portalMenuManager = portalMenuManager;
	}

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    /**
     * 首页个人事务
     */
    public ModelAndView personalInfo(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/person/personalWork");
        Integer productId =  SystemProperties.getInstance().getIntegerProperty("system.ProductId");
        if(ProductEditionEnum.a6s.ordinal() == productId){
            mv.addObject("productId", "a6s");
        } else {
            mv.addObject("productId", "");
        }

        SystemConfig systemConfig = (SystemConfig) AppContext.getBean("systemConfig");
        String ci = systemConfig.get(IConfigPublicKey.CARD_ENABLE);
        boolean cardEnabled = ci != null && CARD_ENABLED.equals(ci);
        boolean cipEnabled=true;
        if(ProductEditionEnum.isU8OEM()){
        	cardEnabled=false;//U8不显示考勤打卡
        	cipEnabled=false;//U8不显示cip的个人用户绑定菜单
        }
        //是否开启薪资查看
        String sal = systemConfig.get(IConfigPublicKey.SALARY_ENABLE);
        boolean salaryEnabled = sal != null && "enable".equals(sal);
       
        User user = AppContext.getCurrentUser();

        String personModifyPwd = SystemProperties.getInstance().getProperty("person.disable.modify.password");
        mv.addObject("personModifyPwd", "0".equals(personModifyPwd));
        mv.addObject("isInternal", user.isInternal());
        mv.addObject("cardEnabled", cardEnabled);
        mv.addObject("cipEnabled", cipEnabled);
        mv.addObject("salaryEnabled", salaryEnabled);
        return mv;
    }

    /**
     * 首页个人事务框架
     */
    public ModelAndView personalInfoFrame(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/person/personalWorkFrame");
        String targetURL = request.getParameter("path");
        //首页模版管理中path传递了一个参数,需要用*分割参数
        if (targetURL.contains("*")) {
            targetURL = targetURL.replace("*", "&");
        }
        mv.addObject("targetURL", targetURL);
        return mv;
    }

    /**
     * 空间排序
     */
    public ModelAndView showSpaceNavigation(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/person/spaceNavigationSetting");
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        Long accountId = user.getLoginAccount();
        //可访问的PortalSpaceFix
        List<String[]> accessedPortalSpaceFixList = spaceManager.getAccessSpaceSort(memberId, accountId, AppContext.getLocale(), false, null);
        //可访问的第3方系统空间
        List<String[]> accessedThirdpartySpaces = spaceManager.getAccessedThirdpartySpace(memberId, accountId, AppContext.getLocale());
        //可访问的PortalLinkSpace
        List<String[]> accessedLinkSpaces = spaceManager.getAccessedLinkSystemSpace(memberId);
        //可访问的关联项目空间
        List<String[]> accessedRelatedProjects = spaceManager.getAccessedRelatedProjectSpace(memberId);

        //备选空间（包括备选的PortalSpaceFix + 备选的第3方系统空间）
        List<String[]> unSelectedSpaces = new LinkedList<String[]>();
        //备选PortalLinkSpace
        List<String[]> unSelectedLinkSpaces = new ArrayList<String[]>();
        //备选关联项目空间
        List<String[]> unSelectedRelatedProjects = new ArrayList<String[]>();
        //已选空间(包括PortalSpaceFix + 第3方系统空间 + PortalLinkSpace +　关联项目空间)
        List<String[]> selectedSpaces = new LinkedList<String[]>();
        //筛选出"备选"和"已选"的空间
        spaceManager.screeningSpaces(accessedPortalSpaceFixList, accessedThirdpartySpaces, accessedLinkSpaces, accessedRelatedProjects, unSelectedSpaces, unSelectedLinkSpaces, unSelectedRelatedProjects, selectedSpaces);
        mv.addObject("unSelectedSpaces", unSelectedSpaces);
        mv.addObject("selectedSpaces", selectedSpaces);
        mv.addObject("linkSpaces", unSelectedLinkSpaces);
        mv.addObject("relatedProjects", unSelectedRelatedProjects);
        long currentAccountId = AppContext.currentAccountId();
        boolean canSetDefaultSpace = spaceManager.canSetDefaultSpace();
        mv.addObject("currentAccountId", currentAccountId);
        mv.addObject("canSetDefaultSpace", canSetDefaultSpace);
        return mv;
    }

    /**
     * 菜单排序
     */
    public ModelAndView showMenuSetting(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/person/menuSetting");
        User user = AppContext.getCurrentUser();

        List<MenuBO> allMenus = portalMenuManager.getMenusOfMember(user);
        List<MenuBO> customizeMenus = portalMenuManager.getCustomizeMenusOfMember(user, allMenus);
        List<MenuBO> unSelectedMenus = portalMenuManager.getUnselectedMenusOfMember(user, allMenus, customizeMenus);
        mv.addObject("unSelectedMenus", unSelectedMenus);
        mv.addObject("customizeMenus", customizeMenus);
        mv.addObject("currentAccountId", AppContext.currentAccountId());
        return mv;
    }

    /**
     * 显示快捷方式树
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView showShortcutSet(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/person/shortcutSetting");
        User user = AppContext.getCurrentUser();

        List<MenuTreeNode> allMenus = spaceManager.getShortcutsOfMember(user);
        List<MenuTreeNode> customizeMenus = spaceManager.getCustomizeShortcuts(user, allMenus);
        Map<String, MenuTreeNode> allMenusMap = new LinkedHashMap<String, MenuTreeNode>();
        for (MenuTreeNode node : allMenus) {
            allMenusMap.put(node.getIdKey(), node);
        }
        MenuTreeNode rootNode = new MenuTreeNode();
        rootNode.setIdKey("menu_0");
        String rootName = ResourceUtil.getString("menu.menuTree.root.label");
        rootNode.setNameKey(rootName);
        rootNode.setpIdKey(null);
        rootNode.setUrlKey(null);
        rootNode.setIconKey(null);
        List<MenuTreeNode> shortcuts = new ArrayList<MenuTreeNode>();

        if (!CollectionUtils.isEmpty(allMenus)) {
            if (CollectionUtils.isEmpty(customizeMenus)) {
                shortcuts = allMenus;
            } else {
                for (MenuTreeNode node : customizeMenus) {
                    MenuTreeNode shortCut = allMenusMap.get(node.getIdKey());
                    if (shortCut != null) {
                        shortCut.setChecked(node.getChecked());
                        shortCut.setSort(node.getSort());
                        shortcuts.add(shortCut);
                    }
                }
            }
        }
        shortcuts.add(rootNode);
        request.setAttribute("ffshortcutTree", shortcuts);
        return mv;
    }

    /**
     * 显示空间导航
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.AuditAdmin})
    public ModelAndView showSystemNavigation(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/navigation");
        User user = AppContext.getCurrentUser();
        // TODO 解耦
//        List<MenuBO> menus = user.getMenus();
        List<MenuBO> menus = spaceManager.getCustomizeMenusOfMember(user, null);
        mv.addObject("menus", menus);
        return mv;
    }

    /**
     * 显示产品导图
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView showProductView(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mv = new ModelAndView("ctp/portal/productView");
        User user = AppContext.getCurrentUser();
        // TODO 解耦
//      List<MenuBO> menus = user.getMenus();
      List<MenuBO> menus = spaceManager.getCustomizeMenusOfMember(user, null);
        mv.addObject("menus", menus);
        return mv;
    }

    /**
     * 二级导图跳转
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView showProductSencendView(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        String pageName = request.getParameter("pageName");
        ModelAndView mv = new ModelAndView("ctp/portal/productView/" + pageName);
        List<MenuBO> menus = UserHelper.getMenus();
        mv.addObject("menus", menus);
        return mv;
    }
    /**
     * 产品导图设置保存
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView saveUserProductViewSet(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        String isHide = request.getParameter("isHide");
        if("true".equals(isHide)){
        	UserCustomizeCache.setCustomize(CustomizeConstants.PRODUCTVIEW, "true");
        }else{
        	UserCustomizeCache.setCustomize(CustomizeConstants.PRODUCTVIEW, "false");
        }
        return null;
    }

    /**
     * 产品导图设置保存
     * @param request
     * @param response
     * @throws BusinessException
     * @throws IOException
     */
    public void showCorporationSpace(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        User user = AppContext.getCurrentUser();
        Long loginAccountId = user.getLoginAccount();
        PortalSpaceFix space = spaceManager.transCreateCorporationSpace(loginAccountId);
        Map<String,String> content = new HashMap<String, String>();
        if(Integer.valueOf(SpaceState.normal.ordinal()).equals(space.getState())){
            content.put("result", "true");
            content.put("CorporationSpace", String.valueOf(space.getId()));
        }else{
            content.put("result", "false");
        }
        super.rendText(response, JSONUtil.toJSONString(content));
    }

    /**
     * 系统预制菜单排序设置入口
     */
    @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin})
    public ModelAndView sysMenuSortSetting(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        ModelAndView mv = new ModelAndView("ctp/portal/sysMenuSortSetting");
        return mv;
    }

    /**
     *      删除绑定
          * @param request request
          * @param response response
          * @return ModelAndView
          * @throws Exception Exception
     */
    public ModelAndView del(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mvRepet = new ModelAndView("ctp/portal/person/result");
        mvRepet.addObject("delvalue", "ok");
        return mvRepet;

    }

    /**
     * 个人头像剪切上传入口
     */
    public ModelAndView headImgCutting(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        ModelAndView mv = new ModelAndView("ctp/portal/personalHeadImg/headImgCutting");
        return mv;
    }

    /**
     * 图片横幅-设置
     */
    public ModelAndView bannerImageSet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("ctp/portal/banner/bannerImageSet");
    }

}
