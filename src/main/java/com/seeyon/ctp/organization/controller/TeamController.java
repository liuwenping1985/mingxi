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

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

/**
 * <p>Title: T2组织模型职务级别维护控制器</p>
 * <p>Description: 主要针对单位组织进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @version CTP2.0
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin,Role_NAME.DepAdmin})
public class TeamController extends BaseController {

    protected OrgManager       orgManager;
    protected OrgManagerDirect orgManagerDirect;

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

    public ModelAndView showTeamframe(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/team/listteam");
        String fromSection = request.getParameter("fromSection");
        if(Strings.isNotBlank(fromSection)) {
            result.addObject("fromSection", Boolean.valueOf(fromSection));
        } else {
            result.addObject("fromSection", false);
        }
        // 客开 增加虛拟单位管理员角色
        String isVirtualAccAdmin = "0";
        String virtualAccAdmin = request.getParameter("virtualAccAdmin");
        if (Strings.isNotBlank(virtualAccAdmin)) {
        	isVirtualAccAdmin = "1";//虚拟管理角色
        }
        result.addObject("virtualAccAdmin", isVirtualAccAdmin);
        
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        result.addObject("accountId", accountId);
        result.addObject("isGroup", OrgConstants.GROUPID.equals(accountId));
        return result;
    }
}
