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

import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.addressbook.manager.AddressBookCustomerFieldInfoManager;
import com.seeyon.apps.addressbook.manager.AddressBookManager;
import com.seeyon.apps.addressbook.po.AddressBook;
import com.seeyon.apps.ldap.config.LDAPConfig;
import com.seeyon.apps.ldap.util.LdapUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.metadata.bo.MetadataColumnBO;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.MemberRole;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.inexportutil.DataUtil;
import com.seeyon.ctp.organization.inexportutil.ResultObject;
import com.seeyon.ctp.organization.manager.MemberManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.util.OrgTree;
import com.seeyon.ctp.organization.util.OrgTreeNode;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgDepartment;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title: T2组织模型人员维护控制器</p>
 * <p>Description: 主要针对人员进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 * @author lilong
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin,Role_NAME.GroupAdmin,Role_NAME.DepAdmin})
public class MemberController extends BaseController {

    private static final Log   log = LogFactory.getLog(MemberController.class);
    protected OrgManager         orgManager;
    protected OrgManagerDirect   orgManagerDirect;
    protected OrgCache           orgCache;
    protected FileToExcelManager fileToExcelManager;
    protected AppLogManager      appLogManager;
    protected MemberManager      memberManager;
    protected AddressBookManager addressBookManager;
    protected AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager;
    
    protected EnumManager        enumManagerNew;
    protected FileManager        fileManager;
    
    public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}
    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }
    
    public void setMemberManager(MemberManager memberManager) {
        this.memberManager = memberManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

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

    public FileToExcelManager getFileToExcelManager() {
        return fileToExcelManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public OrgCache getOrgCache() {
        return orgCache;
    }

    public void setOrgCache(OrgCache orgCache) {
        this.orgCache = orgCache;
    }
    
	public void setAddressBookManager(AddressBookManager addressBookManager) {
		this.addressBookManager = addressBookManager;
	}
	
	public void setAddressBookCustomerFieldInfoManager(
			AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager) {
		this.addressBookCustomerFieldInfoManager = addressBookCustomerFieldInfoManager;
	}

	/***************************/
    public ModelAndView listByAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //增加部門管理員的功能
        ModelAndView result = new ModelAndView("apps/organization/member/member");
        User user = AppContext.getCurrentUser();
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        result.addObject("accountId", accountId);
        
        // 客开 增加虛拟单位管理员角色
        String isVirtualAccAdmin = request.getParameter("virtualAccAdmin");
        
        //自定义通讯录字字段
        List<MetadataColumnBO> metadataColumnBOList = addressBookManager.getCustomerAddressBookList();
        
        if (user.isGroupAdmin()
                || orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.AccountAdministrator.name())
                || orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.HrAdmin.name()) 
                || ("0".equals(SystemProperties.getInstance().getProperty("system.ProductId")) && orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.SystemAdmin.name()))
                || (Strings.isNotBlank(isVirtualAccAdmin) && isVirtualAccAdmin.equals("1"))) {
            //單位管理員 || HR管理员 管理人員列表
            V3xOrgAccount account = orgManager.getAccountById(accountId);
            List<V3xOrgDepartment> list = orgManager.getAllInternalDepartments(account.getId());
            OrgTree orgTree = OrgHelper.getTree(list,accountId);
            Collections.sort(list, CompareSortEntity.getInstance());
            List<Object> resultlist = new ArrayList<Object>();
            for (V3xOrgDepartment dept : list) {
            	if (null == dept.getSuperior() || dept.getSuperior() == -1)
                    continue;//防护
                //OA-11514 NC同步显示申请停用和删除
                StringBuffer deptShowName = new StringBuffer();
                deptShowName.append(dept.getName());
                if (OrgConstants.ORGENT_STATUS.DISABLED.ordinal() == dept.getStatus()) {
                    deptShowName.append("("+ ResourceUtil.getString("org.entity.disabled") +")");
                } else if (OrgConstants.ORGENT_STATUS.DELETED.ordinal() == dept.getStatus()) {
                    deptShowName.append("("+ ResourceUtil.getString("org.entity.deleted") +")");
                }
                WebV3xOrgDepartment webdept = new WebV3xOrgDepartment(dept.getId(), deptShowName.toString(), dept.getSuperior());
                webdept.setV3xOrgDepartment(dept);

                //处理zTree上的层级图标
                webdept.setIconSkin("department");
                List<Long> childrenDepts = this.orgCache.getSubDeptList(dept.getId(),orgCache.SUBDEPT_INNER_FIRST);
                if(Strings.isNotEmpty(childrenDepts)){
                	webdept.setIconSkin("treeDepartment");
                }
/*                OrgTreeNode deptNode= OrgTree.getOrgTreeNodeById(orgTree.getRoot(), dept.getPath());
                if (!deptNode.isLeaf()) {
                    webdept.setIconSkin("treeDepartment");
                }*/

                resultlist.add(webdept);
            }
            WebV3xOrgAccount webrootaccount = new WebV3xOrgAccount(account.getId(), account.getName(), account.getId());
            webrootaccount.setIconSkin("treeAccount");
            resultlist.add(webrootaccount);

            request.setAttribute("ffdeptTree", resultlist);
            if ("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))) {
                result.addObject("isGroupVer", true);
            } else {
                result.addObject("isGroupVer", false);
            }
            /****ldap/ad****/
            String disableModifyLdapPsw = AppContext.getSystemProperty("ldap.disable.modify.password");
            result.addObject("disableModifyLdapPsw","1".equals(disableModifyLdapPsw));//是否禁用OA修改ldap密码功能,0--不启用,1--启用
            result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
            result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
            ;
            /*************/
            
            result.addObject("bean",metadataColumnBOList);
            return result;
        } else if (orgManager.isRole(user.getId(), accountId, OrgConstants.Role_NAME.DepAdmin.name())) {
            //部门管理员，管理人员界面
            return this.list4DeptAdmin(request, response);
        } else if (AppContext.hasResourceCode("F03_member")) {
        	//單位管理員 || HR管理员 管理人員列表
            V3xOrgAccount account = orgManager.getAccountById(accountId);
            List<V3xOrgDepartment> list = orgManager.getAllInternalDepartments(account.getId());
            OrgTree orgTree = OrgHelper.getTree(list,accountId);
            Collections.sort(list, CompareSortEntity.getInstance());
            List<Object> resultlist = new ArrayList<Object>();
            for (V3xOrgDepartment dept : list) {
            	if (null == dept.getSuperior() || dept.getSuperior() == -1)
                    continue;//防护
                //OA-11514 NC同步显示申请停用和删除
                StringBuffer deptShowName = new StringBuffer();
                deptShowName.append(dept.getName());
                if (OrgConstants.ORGENT_STATUS.DISABLED.ordinal() == dept.getStatus()) {
                    deptShowName.append("("+ ResourceUtil.getString("org.entity.disabled") +")");
                } else if (OrgConstants.ORGENT_STATUS.DELETED.ordinal() == dept.getStatus()) {
                    deptShowName.append("("+ ResourceUtil.getString("org.entity.deleted") +")");
                }
                WebV3xOrgDepartment webdept = new WebV3xOrgDepartment(dept.getId(), deptShowName.toString(), dept.getSuperior());
                webdept.setV3xOrgDepartment(dept);

                //处理zTree上的层级图标
                webdept.setIconSkin("department");
                List<Long> childrenDepts = this.orgCache.getSubDeptList(dept.getId(),orgCache.SUBDEPT_INNER_FIRST);
                if(Strings.isNotEmpty(childrenDepts)){
                	webdept.setIconSkin("treeDepartment");
                }
/*                OrgTreeNode deptNode= OrgTree.getOrgTreeNodeById(orgTree.getRoot(), dept.getPath());
                if (!deptNode.isLeaf()) {
                    webdept.setIconSkin("treeDepartment");
                }*/

                resultlist.add(webdept);
            }
            WebV3xOrgAccount webrootaccount = new WebV3xOrgAccount(account.getId(), account.getName(), account.getId());
            webrootaccount.setIconSkin("treeAccount");
            resultlist.add(webrootaccount);

            request.setAttribute("ffdeptTree", resultlist);
            if ("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))) {
                result.addObject("isGroupVer", true);
            } else {
                result.addObject("isGroupVer", false);
            }
            /****ldap/ad****/
            String disableModifyLdapPsw = AppContext.getSystemProperty("ldap.disable.modify.password");
            result.addObject("disableModifyLdapPsw","1".equals(disableModifyLdapPsw));//是否禁用OA修改ldap密码功能,0--不启用,1--启用
            result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
            result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
            /*************/
            result.addObject("bean",metadataColumnBOList);
            return result;
        }else{
        	return null;
        }
        
    }
    
    /**
     * 部门管理员管理
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView list4DeptAdmin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/member/member4DeptAdmin");
        User user = AppContext.getCurrentUser();
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        result.addObject("accountId", accountId);
        //需要将该人员的管理的所有部门列表送到前台去做简要
        List<V3xOrgDepartment> depts = orgManager.getDeptsByAdmin(user.getId(), accountId);
        List<String> deptIds = new UniqueList<String>();
        for (V3xOrgDepartment bo : depts) {
            deptIds.add(bo.getId().toString());
            //父部门管理员可以管理子部门的人员
            List<V3xOrgDepartment> childs = orgManager.getChildDepartments(bo.getId(), false);
            for (V3xOrgDepartment child : childs) {
                deptIds.add(child.getId().toString());
            }
        }
        result.addObject("deptIds", JSONUtil.toJSONString(deptIds));
        /****ldap/ad****/
        String disableModifyLdapPsw = AppContext.getSystemProperty("ldap.disable.modify.password");
        result.addObject("disableModifyLdapPsw","1".equals(disableModifyLdapPsw));//是否禁用OA修改ldap密码功能,0--不启用,1--启用
        result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
        result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
        /*************/
        
        //自定义通讯录字字段
        List<MetadataColumnBO> metadataColumnBOList = addressBookManager.getCustomerAddressBookList();
        result.addObject("bean",metadataColumnBOList);
        return result;
    }

    /**
     * 跳转到人员授权角色的小页面，用于给人员授权单位角色
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView member2Role(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/organization/member/member2role");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        mav.addObject("accountId", accountId);
        return mav;
    }
    
    /**
     * 人员管理查看该人员的所有角色
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView showMemberAllRoles(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView view = new ModelAndView("apps/organization/member/memberAllRoles");
        view.addObject("memberId", request.getParameter("memberId"));
        return view;
    }
    
    /**
     * 跳转到外部人员授权角色的小页面，用于给外部人员授权单位角色
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView member2Role4Ext(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/organization/member/member2role4ext");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        mav.addObject("accountId", accountId);
        return mav;
    }
    
    /**
     * 跳转到兼职人员授权角色的页面，用于给人员授权单位角色
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView cMember2Role(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String orgAccountId = request.getParameter("orgAccountId");
    	ModelAndView mv = new ModelAndView("apps/organization/concurrentPost/cMember2role");
    	mv.addObject("orgAccountId",orgAccountId);
        return mv;
    }
    
    /**
     * 外部人員列表
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView listExtMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/member/member4Ext");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        result.addObject("accountId", accountId);
        /****ldap/ad****/
        String disableModifyLdapPsw = AppContext.getSystemProperty("ldap.disable.modify.password");
        result.addObject("disableModifyLdapPsw","1".equals(disableModifyLdapPsw));//是否禁用OA修改ldap密码功能,0--不启用,1--启用
        result.addObject("isLdapEnabled", LdapUtils.isLdapEnabled());
        result.addObject("LdapCanOauserLogon", LDAPConfig.getInstance().getLdapCanOauserLogon());
        /*************/
        //自定义通讯录字字段
        List<MetadataColumnBO> metadataColumnBOList = addressBookManager.getCustomerAddressBookList();
        result.addObject("bean",metadataColumnBOList);
        return result;
    }
    
    /**
     * 批量修改跳转controller
     * 不做逻辑处理
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView batchUpdatePre(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/member/member4BatchUpdate");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        result.addObject("accountId", accountId);
        Boolean isDeptAdmin = Boolean.valueOf(String.valueOf(request.getParameter("isDeptAdmin")));
        //需要将该人员的管理的所有部门列表送到前台去做校验
        List<V3xOrgDepartment> depts = new ArrayList<V3xOrgDepartment>();
        if (null != isDeptAdmin && isDeptAdmin) {
            depts = orgManager.getDeptsByAdmin(AppContext.currentUserId(), accountId);
        } else {
            depts = Collections.emptyList();//不是部门管理员就不用对已经管理的部门进行校验也不需要将json送到前台
        }
        List<String> deptIds = new UniqueList<String>();
        for (V3xOrgDepartment bo : depts) {
            deptIds.add(bo.getId().toString());
            //父部门管理员可以管理子部门的人员
            List<V3xOrgDepartment> childs = orgManager.getChildDepartments(bo.getId(), false);
            for (V3xOrgDepartment child : childs) {
                deptIds.add(child.getId().toString());
            }
        }
        result.addObject("deptIds", JSONUtil.toJSONString(deptIds));
        result.addObject("isDeptAdmin", isDeptAdmin);
        return result;
    }
    
    /**
     * 批量修改操作controller
     * 进行人员属性批量修改操作
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView batchUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Type", "text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        // 要更新的人员ID
        String idsStr = request.getParameter("ids");
        List<Long> idList = new LinkedList<Long>();
        if (!Strings.isBlank(idsStr)) {
            String[] idStrArray = idsStr.split(",");
            for (String idStr : idStrArray) {
                try {
                    idList.add(Long.valueOf(idStr.trim()));
                } catch (NumberFormatException e) {
                    log.warn("无效的人员ID：" + idStr, e);
                }
            }
        }
        // 角色
        String orgRoleIdsStr = request.getParameter("roleIds");
        List<Long> roleIdList = new LinkedList<Long>();
        StringBuilder newRoles = new StringBuilder();
        if(null != orgRoleIdsStr
                && Strings.isNotBlank(orgRoleIdsStr)) {
            String roleIds = orgRoleIdsStr;
            String[] roles = roleIds.split(",");
            for (String s : roles) {
                roleIdList.add(Long.valueOf(s.trim()));
                newRoles.append(orgManager.getRoleById(Long.valueOf(s.trim())).getShowName()).append("、");
            }
        }
        // 所属部门
        String orgDepartmentIdStr = request.getParameter("orgDepartmentId");
        Long orgDepartmentId = null;
        if (!Strings.isBlank(orgDepartmentIdStr)) {
            try {
                orgDepartmentId = Long.valueOf(orgDepartmentIdStr.trim());
            } catch (NumberFormatException e) {
                log.warn("无效的部门ID：" + orgDepartmentIdStr);
            }
        }
        // 职务级别
        String orgLevelIdStr = request.getParameter("orgLevelId");
        Long orgLevelId = null;
        if (!Strings.isBlank(orgLevelIdStr)) {
            try {
                orgLevelId = Long.valueOf(orgLevelIdStr.trim());
            } catch (NumberFormatException e) {
                log.warn("无效的职务级别：" + orgLevelIdStr);
            }
        }
        // 主岗
        String orgPostIdStr = request.getParameter("orgPostId");
        Long orgPostId = null;
        if (!Strings.isBlank(orgPostIdStr)) {
            try {
                orgPostId = Long.valueOf(orgPostIdStr.trim());
            } catch (NumberFormatException e) {
                log.warn("无效的岗位ID：" + orgPostIdStr);
            }
        }
        // 性别
        String genderStr = request.getParameter("gender");
        Integer gender = null;
        if (!Strings.isBlank(genderStr)) {
            try {
                gender = Integer.valueOf(genderStr);
            } catch (NumberFormatException e) {
                log.warn("无效的性别：" + genderStr);
            }
        }
        // 人员类型
        String typeStr = request.getParameter("type");
        Integer type = null;
        if (!Strings.isBlank(typeStr)) {
            try {
                type = Integer.valueOf(typeStr);
            } catch (NumberFormatException e) {
                log.warn("无效的人员类型：" + typeStr);
            }
        }
        // 账户状态
        String enabledStr = request.getParameter("enabled");
        Boolean enabled = null;
        if (!Strings.isBlank(enabledStr)) {
            if ("1".equals(enabledStr)) {
                enabled = Boolean.TRUE;
            } else if ("0".equals(enabledStr)) {
                enabled = Boolean.FALSE;
            } else {
                log.warn("无效的账户状态：" + enabledStr);
            }
        }

        
        List<V3xOrgRelationship> delRels = new UniqueList<V3xOrgRelationship>();
        List<V3xOrgRelationship> addRels = new UniqueList<V3xOrgRelationship>();
        List<V3xOrgMember> members = new LinkedList<V3xOrgMember>();
        for (Long id : idList) {
            boolean skipFlag = false;
            V3xOrgMember member = new V3xOrgMember();
            try {
                member = this.orgManager.getMemberById(id);
            } catch (BusinessException e) {
                log.warn("查询人员信息失败：" + id, e);
                skipFlag = false;
            }
            if (skipFlag || member == null) {
                log.warn("查询人员信息失败：" + id);
                continue;
            }
            //前台不允许授权的角色集合catortyRoles
            //List<Long> categoryRoles = new UniqueList<Long>();
            //更新人员时老角色局部存储设定
            StringBuilder oldRoles = new StringBuilder();
            Set<Long> oldRoleIds = new HashSet<Long>();
            
            List<MemberRole> memberRoles = orgManager.getMemberRoles(member.getId(), member.getOrgAccountId());
            for (MemberRole m : memberRoles) {
                /*if("0".equals(m.getRole().getCategory().trim())) {
                    categoryRoles.add(m.getRole().getId());//此处将这个人拥有的【不允许前台授权的角色】收集起来
                }*/
                if(OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == m.getRole().getBond() 
                        || OrgConstants.ROLE_BOND.ACCOUNT.ordinal() == m.getRole().getBond()){
                    oldRoles.append(m.getRole().getShowName()).append("、");
                    oldRoleIds.add(m.getRole().getId());
                }

            }
            //角色变化了.增加日志
            if(!roleIdList.isEmpty() && !roleIdList.equals(oldRoleIds)){
                String onames=oldRoles.toString();
                String nnames=newRoles.toString();
                appLogManager.insertLog4Account(user, accountId, AppLogAction.Organization_UpdateMemberRole, user.getName(),member.getName(),
                        onames.length()==0?"":onames.substring(0, onames.length()-1),nnames.length()==0?"":nnames.substring(0, nnames.length()-1));
                
            }
            //角色
            if (roleIdList.size() > 0) {
                orgManagerDirect.cleanMemberAccAndSelfDeptRoles(member, memberManager.canDelRoles(member.getOrgAccountId()));
                for (Long roleId : roleIdList) {
                    V3xOrgRole r = orgManager.getRoleById(roleId);
                    if(null != r) {
                        if(OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == r.getBond()) {//部门角色
                            orgManagerDirect.addRole2Entity(r.getId(), member.getOrgAccountId(), member, orgManager.getDepartmentById(member.getOrgDepartmentId()),delRels, addRels);
                        } else {
                            orgManagerDirect.addRole2Entity(r.getId(), member.getOrgAccountId(), member, delRels, addRels);
                        }
                    } else {
                        continue;
                    }
                }
            }
            // 所属部门
            if (orgDepartmentId != null) {
                member.setOrgDepartmentId(orgDepartmentId);
            }
            // 职务级别
            if (orgLevelId != null) {
                member.setOrgLevelId(orgLevelId);
            }
            // 主岗
            if (orgPostId != null) {
                member.setOrgPostId(orgPostId);
            }
            // 性别
            if (gender != null) {
                member.setProperty("gender", gender);
            }
            // 人员类型
            if (type != null) {
                member.setType(type);
            }
            // 首选语言
            if (Strings.isNotBlank(request.getParameter("primaryLanguange"))) {
            	member.setPrimaryLanguange(request.getParameter("primaryLanguange"));
                orgManagerDirect.setMemberLocale(member, LocaleContext.parseLocale(request.getParameter("primaryLanguange")));
            }
            // 账户状态
            if (enabled != null) {
                if(OrgConstants.MEMBER_STATE.RESIGN.ordinal() == member.getState() && enabled) {
                    out.println("<script>");
                    out.println("alert(\""+ ResourceUtil.getString("org.member.controller.fail.member.delete") +"\")");
                    out.println("window.parent.location.reload();");
                    out.println("window.parent.dialog4Batch.close();");
                    out.println("</script>");
                    return null;
                } else {
                    member.setEnabled(enabled);
                }
            }
            if (member.getEnabled() != null && member.getEnabled()) {//启用，则改成在职状态
                if ("2".equals(member.getState().toString())) {//由离职改成在职,取消所有代理事项
                    member.setState(new Byte("1"));
                }
            }
            members.add(member);
        }
        //统一添加删除角色关系
        orgManagerDirect.deleteOrgRelationships(delRels);
        orgManagerDirect.addOrgRelationships(addRels);
        
        orgManagerDirect.updateMembers(members);
        
        appLogManager.insertLog4Account(user, accountId, AppLogAction.Organization_BanchEditMember, user.getName());

        out.println("<title></title>");
        out.println("<script>");
        //out.println("alert(\"操作成功！\")");
        out.println("try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};");
        out.println("window.parent.location.reload();");
        out.println("window.parent.dialog4Batch.close();");
        out.println("</script>");
        out.println("</head><body></body></html>");      
        out.flush();
        
        return null;
    }

    /**
     * 内部人员导出controller
     * @param request
     * @param response
     * @return
     * @throws Exception 
     */
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin })
    public ModelAndView exportMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.info("exportMember start");
        orgCache.setOrgExportFlag(true);
        User user = AppContext.getCurrentUser();
        if (user == null) {
            return null;
        }
        if (DataUtil.doingImpExp(user.getId())) {
            return null;
        }
//        Locale locale = LocaleContext.getLocale(request);
//        String resource = "com.seeyon.v3x.organization.resources.i18n.OrganizationResources";
        
        Map paraMap = new HashMap();
        String listname = "MemberList_";
        listname += user.getLoginName();

        String key = null;
        DataUtil.putImpExpAction(user.getId(), "export");
        DataRecord dataRecord = null;
        paraMap.put("isInternal", Boolean.TRUE);
        try {
            dataRecord = exportMember(request, fileToExcelManager, paraMap);
            key = DataUtil.createTempSaveKey4Sheet(dataRecord);
        } catch (Exception e) {
            DataUtil.removeImpExpAction(user.getId());
            log.error("error occur ->",e);
            orgCache.setOrgExportFlag(false);
            throw new BusinessException("导出失败！");
        }
        DataUtil.removeImpExpAction(user.getId());

        String url = DataUtil.getOrgDownloadExpToExcelUrl(key, listname);
        log.info("url=" + url);
        DataUtil.removeImpExpAction(user.getId());
        try {
            OrgHelper.exportToExcel(request, response, fileToExcelManager, listname, dataRecord);
        } catch (Exception e) {
            log.error(e);
            throw e;
        } finally {
            orgCache.setOrgExportFlag(false);
        }
        return null;

    }
    
    /**
     * 外部人员全部导出controller
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
    public ModelAndView exportExtMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.info("exportExtMember start");
        User user = AppContext.getCurrentUser();
        if (user == null) {
            return null;
        }
        if (DataUtil.doingImpExp(user.getId())) {
            return null;
        }
        String listname = "ExtMemberList_";
        listname += user.getLoginName();
        String key = null;
        DataUtil.putImpExpAction(user.getId(), "export");
        DataRecord dataRecord = null;
        Map paraMap = new HashMap();
        paraMap.put("isInternal", Boolean.FALSE);
        try {
            dataRecord = exportMember(request, fileToExcelManager, paraMap);
            key = DataUtil.createTempSaveKey4Sheet(dataRecord);
        } catch (Exception e) {
            DataUtil.removeImpExpAction(user.getId());
            throw e;
        }
        DataUtil.removeImpExpAction(user.getId());

        String url = DataUtil.getOrgDownloadExpToExcelUrl(key, listname);
        log.info("url=" + url);
        DataUtil.removeImpExpAction(user.getId());
        OrgHelper.exportToExcel(request, response, fileToExcelManager, listname, dataRecord);
        return null;

    }

    /**
     * 将导出人员数据整理excel的数据对象
     * @param fileToExcelManager
     * @param orgManagerDirect
     * @return
     * @throws Exception
     */
    private DataRecord exportMember(HttpServletRequest request, FileToExcelManager fileToExcelManager, Map paraMap) throws Exception {
        Long accountId = Long.parseLong(request.getParameter("accountId"));
        DataRecord dataRecord = new DataRecord();
        List<V3xOrgMember> memberlist = new UniqueList<V3xOrgMember>();
        Boolean isInternal = (Boolean)paraMap.get("isInternal");
        Boolean enabled = null;
        String condition = null;
        String conditionTemp = null;
        Object value = null;
        
        Map queryParams = new HashMap<String, Object>();
        
        String oDepartId = request.getParameter("orgDepartmentId");
        if(Strings.isNotBlank(oDepartId) && !"null".equals(oDepartId)) {
            condition = "orgDepartmentId";
            value = Long.valueOf(oDepartId);
            
            queryParams.put("orgDepartmentId", Long.valueOf(oDepartId));
        } else {
            condition = request.getParameter("condition");
            if(Strings.isNotBlank(condition) && !"undefined".equals(condition)){
                paraMap = (Map) JSONUtil.parseJSONString(condition);
                if(paraMap.containsKey("condition")) {
                    condition = paraMap.get("condition").toString();
                } else {
                    condition = null;
                }
                if(paraMap.containsKey("value")) {
                    if("selectPeople".equals(String.valueOf(paraMap.get("type")))) {
                        String _tempStr = paraMap.get("value").toString().replace("\"", "");
                        value = Long.valueOf(_tempStr.substring(_tempStr.indexOf("|")+1, _tempStr.length()-1));
                    } else if("input".equals(String.valueOf(paraMap.get("type")))) {
                        value = paraMap.get("value");
                    }
                }
            } else {
                condition = null;
            }
            conditionTemp = condition;
            if("search_workLocalId".equals(condition)) {
                String str = (String)paraMap.get("value");
                String workLocal= enumManagerNew.parseToIds(str,OrgConstants.WORKLOCAL_ID);
                queryParams.put("workLocal", workLocal);
                conditionTemp = "workLocal";
            }else{
            	queryParams.put(condition, value);
            }
        }
        
        //人员过滤后带着过滤条件导出
        String filter = request.getParameter("filter");
        if(null == filter || "null".equals(filter) || Strings.isBlank(filter) || "{}".equals(filter)) {
            enabled = null;
        } else {
            paraMap = (Map) JSONUtil.parseJSONString(filter);
            if(paraMap.containsKey("enabled") && null != paraMap.get("enabled")) {
                enabled = Boolean.valueOf(String.valueOf(paraMap.get("enabled")).trim());
            }
            if((Strings.isBlank(oDepartId) || "null".equals(oDepartId)) && paraMap.get("cond")!=null && "no".equals(paraMap.get("cond"))){
            	queryParams.remove(conditionTemp);
            }
            if(paraMap.containsKey("condition")) {
                condition = String.valueOf(paraMap.get("condition"));
                if("state".equals(condition)) {
                    value = Integer.valueOf(String.valueOf(paraMap.get("value")).trim());
                    queryParams.put("state", value);
                }else if("search_workLocalId".equals(condition)) {
                    String str = (String)paraMap.get("value");
                    String workLocal= enumManagerNew.parseToIds(str,OrgConstants.WORKLOCAL_ID);
                    queryParams.put("workLocal", workLocal);
                } else {
                    value = paraMap.get("value");
                }
            }
        }
        
        memberlist = orgManagerDirect.getAllMemberPOByAccountId(accountId, isInternal, enabled, queryParams, null);

        V3xOrgAccount account = null;
        V3xOrgMember member = null;
        V3xOrgDepartment dept = null;
        String deptName = "";
        V3xOrgPost post = null;
        V3xOrgLevel level = null;
        //导出excel文件的国际化
        String member_name = ResourceUtil.getString("org.member_form.name.label");
        String member_loginName = ResourceUtil.getString("org.member_form.loginName.label");
        String member_code = ResourceUtil.getString("org.member_form.code");
        String member_sortId = ResourceUtil.getString("org.member_form.sort");
        String member_deptName = "";
        if(isInternal) {
            member_deptName = ResourceUtil.getString("org.member_form.deptName.label"); 
        } else {
            member_deptName = ResourceUtil.getString("org.member_form.ExtDeptName4export.label");
        }
        String member_primaryPost = ResourceUtil.getString("org.member_form.primaryPost.label");
        String member_secondPost = ResourceUtil.getString("org.member_form.secondPost.label");
        String member_levelName = ResourceUtil.getString("org.member_form.levelName.label");
        String member_tel = ResourceUtil.getString("org.member_form.tel");
        String member_account = ResourceUtil.getString("org.member_form.account");
        String member_email = ResourceUtil.getString("org.member.emailaddress");
        String member_gender = ResourceUtil.getString("org.memberext_form.base_fieldset.sexe");
        String member_birthday = ResourceUtil.getString("org.memberext_form.base_fieldset.birthday");
        String member_officeNumber = ResourceUtil.getString("member.office.number");
        String member_primaryLanguange = ResourceUtil.getString("org.member_form.primaryLanguange");
       // String member_communication = ResourceUtil.getString("hr.staffInfo.communication.label");
        String member_location = ResourceUtil.getString("member.location");
        String member_hiredate = ResourceUtil.getString("member.hiredate");
        String member_reporter = ResourceUtil.getString("member.report2");
        String member_list = ResourceUtil.getString("org.member_form.list");
        String customerAddressBookFields="";
        
        //导出记录提前将单位管理员和无效人员过滤出去，这里过滤的原因防止产生的excel的列与记录不同
        List<V3xOrgMember> exportList = new ArrayList<V3xOrgMember>();
        for (V3xOrgMember v : memberlist) {
            if(v.getIsAdmin()) {
                continue;
            } else if(null != enabled) {
                if(enabled) {
                    if(!v.isValid()) {
                        continue;
                    } else {
                        exportList.add(v);
                    }
                } else {
                    exportList.add(v);
                }
            } else {
                exportList.add(v);
            }
        }

        if (null != exportList && exportList.size() > 0) {
            DataRow[] datarow = new DataRow[exportList.size()];
            
            //自定义的通讯录字段
            List<MetadataColumnBO> metadataColumnList=addressBookManager.getCustomerAddressBookList();
        	for(MetadataColumnBO metadataColumnBO : metadataColumnList){
        		customerAddressBookFields=customerAddressBookFields+","+metadataColumnBO.getLabel();
        	}
            
            for (int i = 0; i < exportList.size(); i++) {
                member = exportList.get(i);
                DataRow row = new DataRow();
                row.addDataCell(member.getName(), 1);
                row.addDataCell(member.getLoginName(), 1);
                row.addDataCell(member.getCode(), 1);
                //增加排序号
                row.addDataCell(String.valueOf(member.getSortId()), 1);
                //所属单位
                account = orgManager.getAccountById(member.getOrgAccountId());
                row.addDataCell(account.getName(), 1); //所属单位
                //所属部门
                dept = orgManager.getDepartmentById(member.getOrgDepartmentId());
                if (dept != null) {
                	deptName = OrgHelper.showDepartmentFullPath(dept.getId());
                }
                row.addDataCell(deptName, 1); //所属部门
                //主要岗位
                if (null == member.getOrgPostId() 
                        || member.getOrgPostId() == -1) {
                    if(!isInternal){
                        row.addDataCell(OrgHelper.getExtMemberPriPost(member), 1); //主要岗位
                    }else{
                        row.addDataCell(null, 1); //主要岗位
                    }
                } else {
                    post = orgManager.getPostById(member.getOrgPostId());
                    if (null != post) {
                        String ppostName = post.getName(); //
                        String ppostCode = post.getCode();
                        if (StringUtils.hasText(ppostCode)) {
                            try {
                                ppostName += "(" + ppostCode + ")";
                            } catch (Exception e) {
                                log.error("", e);
                            }
                        }
                        row.addDataCell(ppostName, 1); //主要岗位tanglh
                    } else {
                        row.addDataCell(null, 1); //主要岗位tanglh
                    }
                }
                if(isInternal){
                    //增加副岗
                    List<MemberPost> secendPosts = member.getSecond_post();
                    if(null == secendPosts|| secendPosts.size()<1){
                        row.addDataCell(null, 1); //副岗为空
                    }else{
                        StringBuffer sb= new StringBuffer();
                        for(MemberPost secendPost : secendPosts){
                            V3xOrgPost tempPost = orgManager.getPostById(secendPost.getPostId());
                            if(tempPost!=null){
                                String pName = tempPost.getName();
                                V3xOrgDepartment tempDept = orgManager.getDepartmentById(secendPost.getDepId());
                                String dName= tempDept.getName()+(tempDept.getCode()!=null?"("+tempDept.getCode()+")":"");
                                sb.append(dName+"》"+pName+",");
                            }
                        }
                        String seconddepts = sb.toString();
                        row.addDataCell(seconddepts.length() > 0 ? seconddepts.substring(0, seconddepts.length() - 1) : null, 1); //增加副岗
                    }
                }
                //职务级别
                if (null == member.getOrgLevelId()
                        || member.getOrgLevelId() == -1) {
                    if(!isInternal){
                        row.addDataCell(OrgHelper.getExtMemberLevel(member), 1); //职务级别
                    }else{
                        row.addDataCell(null, 1); //职务级别
                    }
                } else {
                    level = orgManager.getLevelById(member.getOrgLevelId());
                    if (null != level) {
                        String levName = level.getName();
                        String levelCode = level.getCode();
                        if (StringUtils.hasText(levelCode)) {
                            try {
                                levName += "(" + levelCode + ")";
                            } catch (Exception e) {
                                log.error("", e);
                            }
                        }
                        row.addDataCell(levName, 1); //职务级别
                    } else {
                        row.addDataCell(null, 1); //职务级别
                    }
                }
                row.addDataCell(member.getTelNumber(), 1); //移动电话号码
                row.addDataCell(member.getEmailAddress(), 1);//email
                // 性别
                String gender = "";
                if (member.getGender() != null) {
                    if (V3xOrgEntity.MEMBER_GENDER_MALE == member.getGender()) {
                        gender = ResourceUtil.getString("org.memberext_form.base_fieldset.sexe.man");
                    } else if (V3xOrgEntity.MEMBER_GENDER_FEMALE == member.getGender()) {
                        gender = ResourceUtil.getString("org.memberext_form.base_fieldset.sexe.woman");
                    }
                }
                row.addDataCell(gender, 1); // 性别
                // 生日
                String birthday = "";
                if (member.getBirthday() != null)
                    birthday = Datetimes.format(member.getBirthday(), "yyyy-MM-dd");
                row.addDataCell(birthday, 1); // 生日
                
                V3xOrgMember memMember = orgManager.getMemberById(member.getId());
                // 办公电话
                String officeNum = "";
                if (memMember != null)
                    officeNum = (String) memMember.getOfficeNum();
                row.addDataCell(officeNum, 1); // 办公电话
                
                // 首选语言
                Locale orgLocale = orgManagerDirect.getMemberLocaleById(member.getId());
                String localStr = "localeselector.locale."+orgLocale;
                row.addDataCell(ResourceUtil.getString(localStr), 1);  
                
/*                // 通信地址
                String communication = "";
                if (memMember != null)
                	communication = (String) memMember.getPostAddress();
                row.addDataCell(communication, 1);  */
                
                if(isInternal){
	                // 工作地
	                String location = "";
	                if (memMember != null){
	                	location = (String) memMember.getLocation();
	                	if(location==null){
	                		location ="";
	                	}else{
	                		location = enumManagerNew.parseToName(location);
	                	}
	                }
	                row.addDataCell(location, 1); 
	                
	                // 入职时间
	                String hiredate = "";
	                if (memMember != null){
	                	if (member.getHiredate() != null){
	                		hiredate = Datetimes.format(memMember.getHiredate(), "yyyy-MM-dd");
	                	}
	                }
	                row.addDataCell(hiredate, 1);
                
                // 汇报人
                	String report2 = "";
                	if (memMember != null){
                		V3xOrgMember reportTo = orgManager.getMemberById(memMember.getReporter());
                		if(reportTo!=null){
                			report2 = reportTo.getName()+"("+reportTo.getLoginName()+")";
                		}
                	}
                	row.addDataCell(report2, 1); 
                }
                
            	//自定义的通讯录字段
                if(Strings.isNotEmpty(metadataColumnList)){
                	AddressBook addressBook = addressBookCustomerFieldInfoManager.getByMemberId(member.getId());
                	for(MetadataColumnBO metadataColumn : metadataColumnList){
                		String columnName=metadataColumn.getColumnName();
                		try {
                			Method method=addressBookManager.getGetMethod(columnName);
                			if(null==method){
                				throw new BusinessException("自定义通讯录字段: "+metadataColumn.getLabel()+"不存在！");
                			}
                			if(null!=addressBook){
                				Object custValue=method.invoke(addressBook, new Object[] {});
                				if(metadataColumn.getType()==0){
                					String showValue=null==custValue?"":String.valueOf(custValue);
                					row.addDataCell(showValue, 1); 
                				}
                				if(metadataColumn.getType()==1){
                					String showValue="";
                					if(custValue!=null){
                						DecimalFormat df = new DecimalFormat();
                						df.setMinimumFractionDigits(0);
                						df.setMaximumFractionDigits(4);
                						showValue = df.format(Double.valueOf(String.valueOf(custValue)));
                						showValue = showValue.replaceAll(",", "");
                					}
                					row.addDataCell(showValue, 1); 
                				}
                				if(metadataColumn.getType()==2){
                					String showValue=null==custValue?"":Datetimes.format((Date)custValue, "yyyy-MM-dd");
                					row.addDataCell(showValue, 1); 
                				}
                			}else{
                				row.addDataCell("", 1); 
                			}
                		} catch (Exception e) {
                			logger.error("查看人员通讯录信息失败！", e);
                		}
                	}
                }
                
                datarow[i] = row;
            }
            try {
                dataRecord.addDataRow(datarow);
            } catch (Exception e) {
                log.error("error", e);
            }
        }
        if(isInternal){
        	String columnName=member_name+","+member_loginName+","+member_code+","+member_sortId+","+member_account+","+member_deptName+","
        			+ member_primaryPost+","+member_secondPost+","+member_levelName+","+member_tel+","+member_email+","+member_gender+","+member_birthday+","+member_officeNumber+""
        			+ ","+member_primaryLanguange+ ","+member_location+","+member_hiredate+","+member_reporter;
            String columnNameAllStr=columnName+customerAddressBookFields;
            String[] columnNameAll=columnNameAllStr.split(",");
            dataRecord.setColumnName(columnNameAll);
        }else{
            String columnName = member_name+","+member_loginName+","+member_code+","+member_sortId+","+member_account+","+member_deptName+","+
                    member_primaryPost+","+member_levelName+","+member_tel+","+member_email+","+member_gender+","+member_birthday+","+member_officeNumber+ ","+member_primaryLanguange;
            String columnNameAllStr=columnName+customerAddressBookFields;
            String[] columnNameAll=columnNameAllStr.split(",");
            dataRecord.setColumnName(columnNameAll);
        }
        dataRecord.setTitle(member_list);
        dataRecord.setSheetName(member_list);
        return dataRecord;
    }
	/**
	 * 上传图片界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView uploadPicture(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("apps/organization/member/selectFileUpload");
		String fileUpload_maxSize = SystemProperties.getInstance().getProperty("fileUpload.maxSize");
		// 默认值50m,可根据系统配置改变
		Long maxFileSize = 52428800L;
		if (Strings.isNotBlank(fileUpload_maxSize)) {
			maxFileSize = Long.parseLong(fileUpload_maxSize);
		}
		String maxSize = maxFileSize / (1024 * 1024) + "m";
		modelAndView.addObject("maxSize", maxSize);
		String loginAccountId = request.getParameter("loginAccountId");
		modelAndView.addObject("loginAccountId", loginAccountId);
		return modelAndView;
	}

	/**
	 * 执行批量压缩图片上传功能
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	//客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.HrAdmin })
	public ModelAndView doUploadFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView("apps/organization/member/importReport");
		HttpSession session = request.getSession();
		List<ResultObject> resultList = new ArrayList<ResultObject>();
		// 如果不是文件上传类型的请求，直接从session取结果列表（针对结果列表翻页）
		if (!(request instanceof MultipartHttpServletRequest)) {
			Object result = session.getAttribute("picUploadReport");
			if (result != null) {
				resultList = (List<ResultObject>) result;
			}
		} else {// 如果是文件上传请求，进行文件上传操作
			Long accountId = null;
			String  loginAccountId = request.getParameter("loginAccountId");
			if(Strings.isNotBlank(loginAccountId)){
				accountId = Long.valueOf(loginAccountId);
			}else{
				accountId = AppContext.currentAccountId();
			}
			// 上传的压缩的文件地址
			String impUrl = request.getParameter("impURL");
			String zipFileName = "";
			if (Strings.isNotBlank(impUrl)) {
				zipFileName = impUrl.substring(impUrl.lastIndexOf("\\") + 1);
			}
			Map<String, V3XFile> v3xFiles = null;
			Long maxFileSize = null;
			try {
				String fileUpload_maxSize = SystemProperties.getInstance().getProperty("fileUpload.maxSize");
				if (Strings.isNotBlank(fileUpload_maxSize)) {
					maxFileSize = Long.parseLong(fileUpload_maxSize);
				}
				// 50m,zip文件
				v3xFiles = fileManager.uploadFiles(request, "zip", maxFileSize);
				if (v3xFiles != null) {
					V3XFile v3x = null;
					Iterator<String> keys = v3xFiles.keySet().iterator();
					String key = "";
					while (keys.hasNext()) {
						key = keys.next();
						v3x = (V3XFile) v3xFiles.get(key);
						if (v3x != null) {
							// 取参数是否进行文件覆盖，1：跳过；0：覆盖
							String repeat = request.getParameter("repeat");
							Boolean override = false;
							if (Strings.isNotBlank(repeat) && "0".equals(repeat)) {
								override = true;
							}
							resultList = memberManager.uploadMemberPicAttachment(zipFileName, v3x, accountId, override);
							// 放入session主要是报告翻页使用，翻页时请求不是multipartRequest,结果取上次的列表进行翻页
							session.setAttribute("picUploadReport", resultList);
						}
					}
				}
			} catch (BusinessException e) {
				ResultObject ro = new ResultObject();
				if (Strings.isBlank(impUrl)) {// 如果是空，文件超过系统限制大小50m后接收不到属性，命名为“上传文件”
					zipFileName = ResourceUtil.getString("member.photo.batch.upload.file.name");
				}
				ro.setName(zipFileName);
				ro.setSuccess(ResourceUtil.getString("import.report.fail"));
				ro.setDescription(e.getMessage());
				resultList.add(ro);
				session.setAttribute("picUploadReport", resultList);
				List subl = DataUtil.pageForList(resultList);
				modelAndView.addObject("resultlst", subl);
				return modelAndView;
			} catch (Exception e) {
				logger.error("批量上传图片失败：", e);
			}
			if (Strings.isEmpty(resultList)) {// 如果结果列表无数据，表示全部上传成功
				super.rendJavaScript(response, "alert('" + ResourceUtil.getString("member.photo.batch.upload.success")
						+ "');if(parent && parent.uploadDialog){parent.uploadDialog.close();};");
				return null;
			}
		}
		List subl = DataUtil.pageForList(resultList);
		modelAndView.addObject("resultlst", subl);
		return modelAndView;
	}

	/**
	 * 导出结果报告
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ModelAndView exportReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		DataRow[] datarow = null;
		if (datarow == null) {
			List resultlst = (List) session.getAttribute("picUploadReport");
			datarow = DataUtil.createDataRowsFromResultObjects(resultlst);
		}
		String import_report = ResourceUtil.getString("member.photo.batch.upload.report");
		String import_data = ResourceUtil.getString("import.data");
		String import_result = ResourceUtil.getString("import.result");
		String import_description = ResourceUtil.getString("import.description");
		String title = "";
		String sheetName = "";
		title = import_report;
		sheetName = import_report;
		// 将导入结果添加到excel中
		DataRecord dataRecord = new DataRecord();
		try {
			dataRecord.addDataRow(datarow);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		String[] columnName = { import_data, import_result, import_description };
		dataRecord.setColumnName(columnName);
		dataRecord.setTitle(title);
		dataRecord.setSheetName(sheetName);

		try {
			fileToExcelManager.save(response, import_report, dataRecord);
		} catch (Exception e) {
			log.error("error", e);
		}
		return null;
	}
}
