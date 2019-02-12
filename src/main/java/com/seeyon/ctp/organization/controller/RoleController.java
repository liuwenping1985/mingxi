/**
 * $Author: gaohang $
 * $Rev: 26015 $
 * $Date:: 2013-07-15 17:11:59#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.organization.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.RoleManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

/**
 * <p>Title: T2角色维护控制器</p>
 * <p>Description: 主要针对角色进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @version CTP2.0
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator})
public class RoleController extends BaseController {

    private RoleManager roleManager;

    private OrgManager  orgManager;

    public ModelAndView showRoleList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/organization/role/roleList");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        
        //客开 检查是否为虚拟组管理角色
        String virtualGroupAdmin = request.getParameter("virtualGroupAdmin");
        if(Strings.isNotBlank(virtualGroupAdmin) 
           && "1".equals(virtualGroupAdmin)){
        	accountId = -1730833917365171641L; /** 集团版--常量集团ID */
        }

        mav.addObject("accountId", accountId);
        mav.addObject("isGroup", OrgConstants.GROUPID.equals(accountId));
        return mav;
    }

    public ModelAndView showMember4Role(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long roleId = Long.parseLong(request.getParameter("roleId"));
        List<V3xOrgMember> members = orgManager.getMembersByRole(AppContext.currentAccountId(), roleId);
        if (!CollectionUtils.isEmpty(members)) {
            for (V3xOrgMember v3xOrgMember : members) {
                v3xOrgMember.setName("Member");
            }
        }
        request.setAttribute("members", members);
        HashMap m = new HashMap();
        m.put("flag", 0);
        
        
        //如果是部门角色，需要显示所属部门
        if(orgManager.getRoleById(roleId).getBond()==OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
        	m.put("flag", 1);
        }
        request.setAttribute("isdeprole", m);
        
        return new ModelAndView("apps/organization/role/role4Member");
    }
    public ModelAndView showEntity4Role(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long roleId = Long.parseLong(request.getParameter("roleId"));
        Long accountId = Long.parseLong(request.getParameter("accountId"));
        List<V3xOrgEntity> entitys = orgManager.getEntitysByRole(accountId, roleId);
//        if (!CollectionUtils.isEmpty(entitys)) {
//            for (V3xOrgEntity v3xOrgEntity : entitys) {
//            	v3xOrgEntity.setName("Member");
//            }
//        }
//        ;
        request.setAttribute("members", entitys);
        HashMap m = new HashMap();
        m.put("flag", 0);
        
        //如果是部门角色，需要显示所属部门
        if(orgManager.getRoleById(roleId).getBond()==OrgConstants.ROLE_BOND.DEPARTMENT.ordinal()){
        	m.put("flag", 1);
        }
        request.setAttribute("isdeprole", m);
        request.setAttribute("roleId", roleId);
        request.setAttribute("accountId", accountId);
        request.setAttribute("isGroup", OrgConstants.GROUPID.equals(accountId));
        return new ModelAndView("apps/organization/role/role4Member");
    }

    public ModelAndView createRole(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/role/roleNew");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        request.setAttribute("isGroup", OrgConstants.GROUPID.equals(accountId));
        Map<String, Object> roleMap = new HashMap<String, Object>();
        roleMap.put("accountId", accountId);
        roleMap.put("sortId", roleManager.getMaxSortId(accountId));
        request.setAttribute("ffmyfrm", roleMap);
        return result;
    }
    public ModelAndView showMembers4RoleCon(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/role/rolemembersList");
        request.setAttribute("roleid", request.getParameter("roleid"));
        request.setAttribute("bond", request.getParameter("bond"));
        return result;
    }
    
    public ModelAndView edit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long menuId = Long.parseLong(request.getParameter("id"));
        V3xOrgRole role = roleManager.findById(menuId);
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        request.setAttribute("isGroup", OrgConstants.GROUPID.equals(accountId));
        Map<String, Object> roleMap = new HashMap<String, Object>();
        roleMap.put("id", String.valueOf(role.getId()));
        roleMap.put("name", role.getShowName());
        roleMap.put("code", role.getCode());
        roleMap.put("sortId", role.getSortId());
        roleMap.put("enable", role.getEnabled());
        roleMap.put("type", role.getType());
        roleMap.put("description", role.getDescription());
        roleMap.put("accountId", role.getOrgAccountId());
        roleMap.put("bond", role.getBond());
        roleMap.put("isBenchmark", role.getIsBenchmark());
        roleMap.put("category", role.getCategory());
        roleMap.put("status", role.getStatus());
        request.setAttribute("ffmyfrm", roleMap);
        return new ModelAndView("apps/organization/role/roleNew");
    }

    public void setRoleManager(RoleManager roleManager) {
        this.roleManager = roleManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
}
