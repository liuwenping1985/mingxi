/**
 * $Author$
 * $Rev$
 * $Date::                     $:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.organization.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.util.Strings;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.ldap.config.LDAPConfig;
import com.seeyon.apps.ldap.util.LdapUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

/**
 * <p>Title: T2组织模型单位维护控制器</p>
 * <p>Description: 主要针对单位组织进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 * @author lilong
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.HrAdmin,Role_NAME.AccountAdministrator})
public class AccountController extends BaseController {

    protected OrgManager       orgManager;
    protected OrgManagerDirect orgManagerDirect;
    private static final Class<?> c2 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public OrgManagerDirect getOrgManagerDirect() {
        return orgManagerDirect;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    /******************************/

    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return null;
    }

    /**
     * 单位展现，左侧树右侧列表
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView listAccounts(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        Long accountId = AppContext.currentAccountId();
        
        // 客开 虚拟管理员角色
        boolean isVirtualAccAdmin = false;
        String virtualAccAdmin = request.getParameter("virtualAccAdmin");
        if(Strings.isNotBlank(virtualAccAdmin) && "1".equals(virtualAccAdmin)){
        	isVirtualAccAdmin = true;
        }
        if(!isVirtualAccAdmin){
	        //单位管理员直接跳转查看单独维护单位信息的页面去
	        if (orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.AccountAdministrator.name())) {
	            return viewAccount(request, response);
	        }
        }
        ModelAndView result = new ModelAndView("apps/organization/account/account");
        result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
        result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
        String MxVersion = SystemEnvironment.getMxVersion();
        result.addObject("MxVersion", MxVersion);
        result.addObject("virtualAccAdmin", isVirtualAccAdmin ? "1" : "0");
        
        return result;
    }

    /**
     * 单位管理员和HR管理员的单位信息管理界面
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    //客开 @CheckRoleAccess(roleTypes = { Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public ModelAndView viewAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //如果是集团管理员直接跳转到机构管理的页面
        User user = AppContext.getCurrentUser();
        Long accountId = AppContext.currentAccountId();
        if (orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.GroupAdmin.name())) {
            return listAccounts(request, response);
        }

        ModelAndView result = new ModelAndView("apps/organization/account/account4Admin");
        result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
        result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
        result.addObject("id", accountId);
        String MxVersion = SystemEnvironment.getMxVersion();
        result.addObject("MxVersion", MxVersion);
        return result;
    }
    
    // 客开增加 提供系统管理授权使用
    public ModelAndView viewAccountForSystemConfig(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //如果是集团管理员直接跳转到机构管理的页面
        User user = AppContext.getCurrentUser();
        Long accountId = AppContext.currentAccountId();
        if (orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.GroupAdmin.name())) {
            return listAccounts(request, response);
        }

        ModelAndView result = new ModelAndView("apps/organization/account/account4Admin");
        result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
        result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
        result.addObject("id", accountId);
        String MxVersion = SystemEnvironment.getMxVersion();
        result.addObject("MxVersion", MxVersion);
        return result;
    }

}
