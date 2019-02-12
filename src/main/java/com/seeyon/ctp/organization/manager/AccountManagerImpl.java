package com.seeyon.ctp.organization.manager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.ldap.domain.V3xLdapRdn;
import com.seeyon.apps.ldap.event.OrganizationLdapEvent;
import com.seeyon.apps.ldap.util.LdapUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.Constants.LoginOfflineOperation;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPrincipal;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgDao;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

public class AccountManagerImpl implements AccountManager {
    private final static Log        logger = LogFactory.getLog(AccountManagerImpl.class);
    private static final Class<?>   c1     = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
    private boolean isVirtualAccAdmin = false;//客开 虚拟管理员角色
    protected OrgDao                orgDao;
    protected OrgCache              orgCache;
    protected OrgManagerDirect      orgManagerDirect;
    protected OrgManager            orgManager;
    protected PrincipalManager      principalManager;
    protected AppLogManager         appLogManager;
    protected EnumManager           enumManagerNew;
    protected OrganizationLdapEvent organizationLdapEvent;
    protected RoleManager           roleManager;
    protected ConcurrentPostManager conPostManager;
    protected TeamManager           teamManager;

    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }

    public void setOrganizationLdapEvent(OrganizationLdapEvent organizationLdapEvent) {
        this.organizationLdapEvent = organizationLdapEvent;
    }

    public void setPrincipalManager(PrincipalManager principalManager) {
        this.principalManager = principalManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgDao(OrgDao orgDao) {
        this.orgDao = orgDao;
    }

    public void setOrgCache(OrgCache orgCache) {
        this.orgCache = orgCache;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
    
    public void setRoleManager(RoleManager roleManager) {
		this.roleManager = roleManager;
	}
    
    public void setConPostManager(ConcurrentPostManager conPostManager) {
        this.conPostManager = conPostManager;
    }
    
    public void setTeamManager(TeamManager teamManager) {
        this.teamManager = teamManager;
    }

	@Override
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public FlipInfo showAccounts(FlipInfo fi, Map params) throws BusinessException {
        /********过滤和条件搜索*******/
        Boolean enabled = null;
        String condition = String.valueOf(params.get("condition"));
        Object value = params.get("value")==null?"":params.get("value");
        if("all".equals(condition)) {//查询全部
            condition = null;
            value = null;
        }
        if (params.containsKey("enabled")) {
            enabled = (Boolean) params.get("enabled");
        }
        /********************/
        orgDao.getAllUnitPO(OrgConstants.UnitType.Account, null, enabled, true, condition, value, fi);
        List<OrgUnit> units = fi.getData();
        List<V3xOrgAccount> accountBOs = (List<V3xOrgAccount>) OrgHelper.listPoTolistBo(units);
        List<WebV3xOrgAccount> results = new ArrayList<WebV3xOrgAccount>(accountBOs.size());
        
        Map<String, V3xOrgAccount> tempAccount = new HashMap<String, V3xOrgAccount>();
        List<V3xOrgAccount> accountAll = orgManager.getAllAccounts();
        for (V3xOrgAccount a : accountAll) {
            tempAccount.put(a.getPath(), a);
        }
        for (V3xOrgAccount bo : accountBOs) {
            V3xOrgUnit parentUnit = null;
            String path = bo.getPath();
            if(Strings.isNotBlank(path)) {
                if(path.length() > 4){
                    String parentpath = path.substring(0, path.length() - 4);
                    parentUnit = tempAccount.get(parentpath);
                }
            }
            bo.setSuperiorName(parentUnit == null ? "" : parentUnit.getName());
            WebV3xOrgAccount vo = new WebV3xOrgAccount();
            vo.setId(bo.getId());
            //vo.setV3xOrgAccount(bo);
            vo.setName(bo.getName());
            vo.setShortName(bo.getShortName());
            vo.setCode(bo.getCode());
            V3xOrgMember adminMember = orgManager.getAdministrator(bo.getId());
            if(null == adminMember
                    || null == adminMember.getV3xOrgPrincipal()) {
                if(bo.getIsGroup()) {
                    vo.setLoginName(orgManager.getGroupAdmin().getV3xOrgPrincipal().getLoginName());
                } else {
                    vo.setLoginName("");
                }
            } else {
                vo.setLoginName(adminMember.getV3xOrgPrincipal().getLoginName());
            }
            vo.setSortId(bo.getSortId());
            if(null == parentUnit) {
                vo.setSuperiorName("");
            } else {
                vo.setSuperiorName(parentUnit.getName());
            }
            vo.setEnabled(bo.getEnabled());
            results.add(vo);
        }
        fi.setData(results);
        return fi;
    }

    @Override
    public FlipInfo loadParent(FlipInfo fi, Map params) throws BusinessException {
        orgDao.getAllUnitPO(OrgConstants.UnitType.Account, Long.parseLong(String.valueOf(params.get("id"))), true,
                true, null, null, fi);
        List<OrgUnit> units = fi.getData();
        List<V3xOrgAccount> results = (List<V3xOrgAccount>) OrgHelper.listPoTolistBo(units);
        for (V3xOrgAccount v : results) {
            v.setSuperiorName(OrgHelper.getParentUnit(v).getName());
        }
        fi.setData(results);
        return fi;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public Boolean delAccounts(Long[] ids) throws BusinessException {
        List<V3xOrgAccount> delAccounts = new ArrayList<V3xOrgAccount>();
        for (Long s : ids) {
            V3xOrgAccount a = orgManager.getAccountById(s);
            if (null != a) {
                delAccounts.add(a);
                User user = AppContext.getCurrentUser();
                appLogManager.insertLog(user, AppLogAction.Organization_DeleteAccount, user.getName(), a.getName());
            }
        }
        OrganizationMessage returnMesage = orgManagerDirect.deleteAccounts(delAccounts);
        OrgHelper.throwBusinessExceptionTools(returnMesage);
        return true;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public Long updateAcc(Map map) throws BusinessException {
        V3xOrgAccount updateAccount = new V3xOrgAccount();
        ParamUtil.mapToBean(map, updateAccount, false, false);
        
        //2012-12-25由于T1修改fillform组件只能对集团做特殊处理
        if(OrgConstants.GROUPID.equals(updateAccount.getId())) {
            updateAccount.setName(map.get("gname").toString());
            updateAccount.setShortName(map.get("gshortName").toString());
            updateAccount.setCode(map.get("gcode").toString());
            updateAccount.setDescription(map.get("gdescription").toString());
        }
        
        if("true".equals(String.valueOf(map.get("isCustomLoginUrl")))) {
            map.put("isCustomLoginUrl", 1L);
        } else {
            map.put("isCustomLoginUrl", 0L);
        }
        updateAccount.setProperties(map);
        String superAccountStr = (String) map.get("superiorName");//选人界面过来的数据Account|1234567
        if (Strings.isNotBlank(superAccountStr) && superAccountStr.contains("|")) {
            String[] temp = superAccountStr.split("[|]");
            //修改上级单位重新计算path
            updateAccount.setSuperior(Long.valueOf(temp[1]));
        }
        //处理排序号方式OA-17554修改单位不处理排序号
        if (OrgConstants.SORTID_TYPE_INSERT.equals((String) map.get("sortIdtype1"))) {
            updateAccount.setSortIdType(OrgConstants.SORTID_TYPE_INSERT);
        } else if (OrgConstants.SORTID_TYPE_REPEAT.equals((String) map.get("sortIdtype2"))) {
            updateAccount.setSortIdType(OrgConstants.SORTID_TYPE_REPEAT);
        }
        OrganizationMessage message = null;
        if (OrgConstants.GROUPID.equals(updateAccount.getId())) {
            updateAccount.setGroup(true);
            updateAccount.setSortId(1L);
            message = orgManagerDirect.updateAccount(updateAccount);
            OrgHelper.throwBusinessExceptionTools(message);
        } else {
            //单位管理员账号修改更新
            V3xOrgMember oldAdmin = orgManager.getAdministrator(updateAccount.getId());
            V3xOrgMember admin = new V3xOrgMember(oldAdmin);
            if (null != map.get("checkManager") && "1".equals(map.get("checkManager").toString())) {
                OnlineRecorder.moveToOffline(admin.getLoginName(), LoginOfflineOperation.adminKickoff);
                String adminName = String.valueOf(map.get("adminName"));
                if(Strings.isNotBlank(adminName)) {
                    if(!adminName.equals(admin.getLoginName())) {
                        // 校验登录名是否已存在
                        if (principalManager.isExist(adminName)) {
                            throw new BusinessException(ResourceUtil.getString("MessageStatus.ACCOUNT_REPEAT_ADMIN_NAME"));
                        }
                    }
                }
                String adminPass = String.valueOf(map.get("adminPass"));
                if (!OrgConstants.DEFAULT_INTERNAL_PASSWORD.equals(adminPass) && !Strings.isEmpty(adminPass)) {
                    V3xOrgPrincipal adminPri = admin.getV3xOrgPrincipal();
                    adminPri.setLoginName(adminName);
                    adminPri.setMemberId(admin.getId());
                    adminPri.setPassword(adminPass);
                    // principalManager.update(adminPri);
                    admin.setV3xOrgPrincipal(adminPri);
                    // orgManagerDirect.updateMember(admin);
                    //记录密码修改日志
                    User user = AppContext.getCurrentUser();
                    appLogManager.insertLog(user, AppLogAction.Systemmanager_UpdateAdminPassWord, user.getName(),
                            admin.getName());
                }
            }
            //单位可见范围的处理
            this.dealUnitAccess(updateAccount, map);
            message = orgManagerDirect.updateAccount(updateAccount);
            OrgHelper.throwBusinessExceptionTools(message);
            //更新单位管理员的状态
            //Fix OA-7581 由于修改人员会将不可登录的人的帐号删除，这里只是将人员置为停用，不做不可登录状态修改
            // admin.setIsLoginable(updateAccount.getEnabled());
            admin.setEnabled(updateAccount.getEnabled());
            orgManagerDirect.updateMember(admin);
        }
        
        
        @SuppressWarnings("unchecked")
		List<V3xOrgRole> accountCustomerRolesList = (List<V3xOrgRole>) getAccountCustomerRoles(updateAccount.getId()).get("accountCustomerRoles");
        if(null!=accountCustomerRolesList && accountCustomerRolesList.size()>0){
        	for (int i = 0; i < accountCustomerRolesList.size(); i++) {
        		String entityIds = null;
        		if (map.containsKey("customerRole" + i) && map.get("customerRole" + i) != null
        				&& !"".equals(map.get("customerRole" + i))) {
        			entityIds = (map.get("customerRole" + i+"Id").toString());
        		}
        		roleManager.batchRole2Entity(accountCustomerRolesList.get(i).getId(), null==entityIds?"":entityIds);
        	}
        }
        
        
        //枚举调用记录
        if (Strings.isNotBlank(String.valueOf(map.get("unitCategory")))) {
            enumManagerNew.updateEnumItemRef("org_property_account_category", String.valueOf(map.get("unitCategory")));
        }
        //记录应用日志
        User user = AppContext.getCurrentUser();
        appLogManager.insertLog(user, AppLogAction.Organization_UpdateAccount, user.getName(), updateAccount.getName());
        return message.getSuccessMsgs().get(0).getEnt().getId();
    }
    
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
    public Long updateAcc4Admin(Map map) throws BusinessException {
        V3xOrgAccount updateAccount = new V3xOrgAccount();
        ParamUtil.mapToBean(map, updateAccount, false, false);
        updateAccount.setProperties(map);
        
        V3xOrgAccount oldEntity = orgManager.getAccountById(updateAccount.getId());
        //OA-21948 单位管理员修改排序号
        updateAccount.setSortId(oldEntity.getSortId());
        
        if (OrgConstants.GROUPID.equals(updateAccount.getId())) {
            updateAccount.setGroup(true);
            updateAccount.setSortId(-1L);
        } else {
            V3xOrgMember admin = orgManager.getAdministrator(updateAccount.getId());
            if (null != map.get("checkManager") && "1".equals(map.get("checkManager").toString())) {
                if(!admin.getLoginName().equals(map.get("adminName").toString())) {
                    // 校验登录名是否已存在
                    if (principalManager.isExist(map.get("adminName").toString())) {
                        throw new BusinessException(ResourceUtil.getString("MessageStatus.ACCOUNT_REPEAT_ADMIN_NAME"));
                    }
                }
                String adminName = String.valueOf(map.get("adminName"));
                String adminPass = String.valueOf(map.get("adminPass"));
                if (!OrgConstants.DEFAULT_INTERNAL_PASSWORD.equals(adminPass) && !Strings.isEmpty(adminPass)) {
                    V3xOrgPrincipal adminPri = admin.getV3xOrgPrincipal();
                    adminPri.setLoginName(adminName);
                    adminPri.setMemberId(admin.getId());
                    adminPri.setPassword(adminPass);
                    // principalManager.update(adminPri);
                    admin.setV3xOrgPrincipal(adminPri);
                    orgManagerDirect.updateMember(admin);
                    //记录密码修改日志
                    User user = AppContext.getCurrentUser();
                    appLogManager.insertLog(user, AppLogAction.Systemmanager_UpdateAdminPassWord, user.getName(),
                            admin.getName());
                }
            }
        }
        
        //处理LDAP/AD
        this.ldap4AccountOU(updateAccount, map.get("ldapOu").toString(), updateAccount.getId());
        
        @SuppressWarnings("unchecked")
		List<V3xOrgRole> accountCustomerRolesList = (List<V3xOrgRole>) getAccountCustomerRoles(updateAccount.getId()).get("accountCustomerRoles");
        if(null!=accountCustomerRolesList && accountCustomerRolesList.size()>0){
        	for (int i = 0; i < accountCustomerRolesList.size(); i++) {
        		String entityIds = null;
        		if (map.containsKey("customerRole" + i) && map.get("customerRole" + i) != null
        				&& !"".equals(map.get("customerRole" + i))) {
        			entityIds = (map.get("customerRole" + i+"Id").toString());
        		}
        		roleManager.batchRole2Entity(accountCustomerRolesList.get(i).getId(), null==entityIds?"":entityIds);
        	}
        }
        
        //枚举调用记录
        if (Strings.isNotBlank(String.valueOf(map.get("unitCategory")))) {
            enumManagerNew.updateEnumItemRef("org_property_account_category", String.valueOf(map.get("unitCategory")));
        }
        //同步独立登录页设置信息
        if(oldEntity.isCustomLogin()) {
        	updateAccount.setProperty("isCustomLoginUrl", Long.valueOf(1));
        	updateAccount.setProperty("customLoginUrl", oldEntity.getCustomLoginUrl());
        }
        OrganizationMessage message = orgManagerDirect.updateAccount(updateAccount);
        OrgHelper.throwBusinessExceptionTools(message);
        //记录应用日志
        User user = AppContext.getCurrentUser();
        appLogManager.insertLog(user, AppLogAction.Organization_UpdateAccount, user.getName(), updateAccount.getName());
        return message.getSuccessMsgs().get(0).getEnt().getId();
    }

    @Override
    //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin,Role_NAME.HrAdmin})
    public HashMap viewAccount(Long accountId) throws BusinessException {
        HashMap map = new HashMap();
        V3xOrgAccount viewAccount = orgManager.getAccountById(accountId);
        ParamUtil.beanToMap(viewAccount, map, true);
        map.putAll(viewAccount.getProperties());
        if(viewAccount.isCustomLogin()) {
            map.put("isCustomLoginUrl", true);
            map.put("customLoginUrl", viewAccount.getCustomLoginUrl());
        } else {
            map.put("isCustomLoginUrl", false);
        }

        //2012-12-25由于T1修改组件，fillform无法回填同名的input,只能特殊处理集团信息的回填
        if (viewAccount.isGroup()) {
            map.put("gname", viewAccount.getName());
            map.put("gshortName", viewAccount.getShortName());
            map.put("gcode", viewAccount.getCode());
            map.put("gdescription", viewAccount.getDescription());

            map.put("accountSize", orgManager.getAllAccounts().size() - 1);
            map.put("gPostSize", orgManager.getAllPosts(accountId).size());
            map.put("gLevelSize", orgManager.getAllLevels(accountId).size());
            map.put("gRoleSize", orgManager.getAllRoles(accountId).size());
            FlipInfo fi = conPostManager.list4Manager(new FlipInfo(), new HashMap());
            map.put("concurrentSize", fi.getTotal());
            map.put("gTeamSize", orgManager.getAllTeams(accountId).size());
        } else {
            //为刷新名称将集团的名称传到前台去OA-49273
            map.put("gname", orgManager.getUnitById(OrgConstants.GROUPID).getName());
            map.put("gshortName", orgManager.getUnitById(OrgConstants.GROUPID).getShortName());

            map.put("deptSize", orgManager.getAllInternalDepartments(accountId).size());
            map.put("postSize", orgManager.getAllPosts(accountId).size());
            map.put("levelSize", orgManager.getAllLevels(accountId).size());
            map.put("memberSize", orgManager.getAllMembersNumsWithOutConcurrent(accountId));
            map.put("roleSize", orgManager.getAllRoles(accountId).size());
            map.put("extMemberSize", orgManager.getAllExtMembers(accountId).size());
            Map teamParams = new HashMap();
            teamParams.put("accountId", accountId);
            teamParams.put("condition", "enable");
            teamParams.put("value", "true");
            if(isVirtualAccAdmin){//客开 增加虚拟管理员角色
            	teamParams.put("isVirtualAccAdmin", "1");
            }
            FlipInfo fi = teamManager.showTeamList(new FlipInfo(), teamParams);
            map.put("teamSize", fi.getTotal());
        }

        V3xOrgUnit parentUnit = OrgHelper.getParentUnit(viewAccount);
        if (null == parentUnit) {
            map.put("superiorName", "");
        } else {
            map.put("superiorName", parentUnit.getName());
        }

        if (!String.valueOf(OrgConstants.GROUPID).equals(String.valueOf(accountId))) {
            V3xOrgMember adminMember = orgManager.getAdministrator(accountId);
            if (null != adminMember) {//增加防护防止因为单位与账号数据不完整报错
                String adminLoginName;
                try {
                    adminLoginName = principalManager.getLoginNameByMemberId(adminMember.getId());
                }
                catch (NoSuchPrincipalException e) {
                    throw new BusinessException(e);
                }
//                V3xOrgPrincipal adminPrincipal = adminMember.getV3xOrgPrincipal();
                map.put("adminName", adminLoginName);
                map.put("oldAdminName", adminLoginName);
                map.put("adminPass", OrgConstants.DEFAULT_INTERNAL_PASSWORD);
            }
            Long permissionType = (Long)viewAccount.getProperty("permissionType");
            if(Long.valueOf(1).equals(permissionType)){//分级设置
                map.put("permissionType", 1);
                String accessLevels = (String)viewAccount.getProperty("accessLevels");
                if(null!=accessLevels) {
                    String[] acLevels = accessLevels.split(",");
                    for (String s : acLevels) {
                        if("1".equals(s)) map.put("sLevel", "1");
                        if("2".equals(s)) map.put("pLevel", "1");
                        if("3".equals(s)) map.put("xLevel", "1");
                    }
                }
            } else if(Long.valueOf(2).equals(permissionType)) {//自由设置
                map.put("permissionType", 2);
                List<V3xOrgRelationship> rels = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Account_AccessScope, accountId, accountId, null);
                StringBuilder strValueName = new StringBuilder();//用于回写选人界面的名称
                StringBuilder strValueId = new StringBuilder();//用于回写选人的value
                for (V3xOrgRelationship bo : rels) {
                    if (null == bo.getObjective0Id() || Long.valueOf(-1).equals(bo.getObjective0Id()))
                        continue;
                    V3xOrgAccount a = orgManager.getAccountById(bo.getObjective0Id());
                    if(null == a) continue;
                    strValueName.append(a.getName()).append("、");
                    strValueId.append("Account|").append(bo.getObjective0Id()).append(",");
                }
                if(Strings.isNotBlank(strValueName.toString())) {
                    map.put("strValueName", strValueName.toString().substring(0, strValueName.length()-1));
                    map.put("strValueId", strValueId.toString().substring(0, strValueId.length()-1));
                }
                map.put("isCanAccess", getAccountIsCanAccess(viewAccount));
            } else if(null == permissionType || new Long(0).equals(permissionType)) {//统一设置
                map.put("permissionType", 0);
                map.put("isCanAccess", getAccountIsCanAccess(viewAccount));
            }
        }
        
        if("true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"))) {
            map.put("isGroupVer", true);
        } else {
            map.put("isGroupVer", false);
        }
        
        //单位自定义登录开关和地址
        map.put("isCunstomLoginUrl", viewAccount.isCustomLogin());
        map.put("customLoginUrl", null == viewAccount.getCustomLoginUrl()?"":viewAccount.getCustomLoginUrl());
        
        //注册并发数处理
        dealLicenseInfo(accountId, map);
        
        /****ldap/ad****/
        map.put("isLdapEnabled", LdapUtils.isLdapEnabled());
        /*************/
        
        //集团自定义角色
        @SuppressWarnings("unchecked")
		List<V3xOrgRole> accountCustomerRolesList = (List<V3xOrgRole>) getAccountCustomerRoles(accountId).get("accountCustomerRoles");
        if(null!=accountCustomerRolesList && accountCustomerRolesList.size()>0){
        	for (int i = 0; i < accountCustomerRolesList.size(); i++) {
        		Long roleId=accountCustomerRolesList.get(i).getId();
        		List<V3xOrgEntity> entitys = orgManager.getEntitysByRole(accountId,roleId);
        		map.put("customerRole" + i+"Id", OrgHelper.parseElements(entitys, "id","entityType"));
        		map.put("customerRole" + i+"Text", OrgHelper.showOrgEntities(entitys, "id","entityType",null));
        		map.put("roleId" + i, roleId);
        	}
        }
        return map;
    }

    /**
     * 显示单位注册并发数的方法
     * @param accountId 单位id
     * @param map 要送到前台的map
     * @throws BusinessException
     */
    private void dealLicenseInfo(Long accountId, HashMap map) throws BusinessException {
        //单位注册数的信息回显
        Object obj = MclclzUtil.invoke(c1, "getInstance",new Class[]{String.class},null,new Object[]{String.valueOf(accountId)});
        StringBuilder serverPermission = new StringBuilder();
        StringBuilder m1Permission = new StringBuilder();
        if (null != obj) {
            //TODO 1.将变量抽取出去;
            //server
            if ("1".equals(MclclzUtil.invoke(c1, "getServerPermissionType"))) {
                serverPermission.append(ResourceUtil.getString("org.permission.notByUnit"));
            } else {
                serverPermission.append(MclclzUtil.invoke(c1, "getUseservernum",null,obj,null)).append("/").append(MclclzUtil.invoke(c1, "getTotalservernum",null,obj,null));
                if (Integer.valueOf(1).equals(MclclzUtil.invoke(c1, "getserverType",null,obj,null))) {
                    serverPermission.append(" ").append(ResourceUtil.getString("org.permission.registered"));
                } else {
                    serverPermission.append(" ").append(ResourceUtil.getString("org.permission.complicating"));
                }
            }
            //m1server
            if ("1".equals(MclclzUtil.invoke(c1, "getM1PermissionType"))) {
                m1Permission.append(ResourceUtil.getString("org.permission.notByUnit"));
            } else {
                m1Permission.append(MclclzUtil.invoke(c1, "getUsem1num",null,obj,null)).append("/").append(MclclzUtil.invoke(c1, "getTotalm1num",null,obj,null));
                if (Integer.valueOf(1).equals(MclclzUtil.invoke(c1, "getm1Type",null,obj,null))) {
                    m1Permission.append(" ").append(ResourceUtil.getString("org.permission.registered"));
                } else {
                    m1Permission.append(" ").append(ResourceUtil.getString("org.permission.complicating"));
                }
            }
        }
        map.put("serverPermission", serverPermission.toString());
        map.put("m1Permission", m1Permission.toString());
        if(OrgConstants.GROUPID.equals(accountId)) {//集团版显示，单位可注册数
            StringBuilder unitRegCount = new StringBuilder();
            Object info1 = MclclzUtil.invoke(c1, "getInstance", new Class[] { String.class }, null, new Object[] { "" });
            //集团新建单位的注册数
            int maxCompanySum = ((Integer) MclclzUtil.invoke(c1, "getMaxCompany", null, info1, null)).intValue();
            int accountAllNums = orgCache.getAllAccounts().size() - 1;
            if(maxCompanySum == 0) {
                unitRegCount.append(ResourceUtil.getString("org.permission.unitReg.umlimited"));
            } else {
                unitRegCount.append(" ").append(accountAllNums).append(" / ").append(maxCompanySum);
            }
            map.put("unitRegCounts", unitRegCount.toString());
        }
        
    }
    
    /**
     * 获取该单位自由设置或是统一是时的isCanAccess状态
     * @param account
     * @return
     * @throws BusinessException
     */
    private boolean getAccountIsCanAccess(V3xOrgAccount account) throws BusinessException {
        boolean b = true;
        List<V3xOrgRelationship> rels = orgManager.getV3xOrgRelationship(OrgConstants.RelationshipType.Account_AccessScope, account.getId(), account.getId(), null);
        for (V3xOrgRelationship bo : rels) {
            if(Strings.isBlank(bo.getObjective5Id()) 
                    || OrgConstants.Account_AccessScope_Type.CAN_ACCESS.name().equals(bo.getObjective5Id())) {
                break;
            }
            if(OrgConstants.Account_AccessScope_Type.NOT_ACCESS.name().equals(bo.getObjective5Id())) {
                b = false;
                break;
            }
        }
        return b;
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public Long createAcc(Map map) throws BusinessException {
        V3xOrgAccount newAccount = new V3xOrgAccount();
        ParamUtil.mapToBean(map, newAccount, false, false);
        if("true".equals(String.valueOf(map.get("isCustomLoginUrl")))) {
            map.put("isCustomLoginUrl", 1L);
        } else {
            map.put("isCustomLoginUrl", 0L);
        }
        newAccount.setProperties(map);
        newAccount.setPath(null);
    	newAccount.setSuperior(null);
        String superAccountStr = (String) map.get("superiorName");//选人界面过来的数据Account|1234567
        if (Strings.isNotBlank(superAccountStr) && superAccountStr.contains("|")) {
            String[] temp = superAccountStr.split("[|]");
            long superior = Long.valueOf(temp[1]);
            V3xOrgAccount superAccount = orgManager.getAccountById(superior);
            if(null!=superAccount && superAccount.isValid()){
            	newAccount.setPath(OrgHelper.getPathByPid4Add(V3xOrgAccount.class, superior));
            	newAccount.setSuperior(superior);
            }
        }
        //单位可见范围的处理
        this.dealUnitAccess(newAccount, map);

        //处理排序号方式
        if (OrgConstants.SORTID_TYPE_INSERT.equals((String) map.get("sortIdtype1"))) {
            newAccount.setSortIdType(OrgConstants.SORTID_TYPE_INSERT);
        } else if (OrgConstants.SORTID_TYPE_REPEAT.equals((String) map.get("sortIdtype2"))) {
            newAccount.setSortIdType(OrgConstants.SORTID_TYPE_REPEAT);
        }
        newAccount.setId(UUIDLong.longUUID());
        newAccount.setOrgAccountId(newAccount.getId());
        
        //复制集团职务级别
        Object isCopyGroupLevel = map.get("isCopyGroupLevel");
        if(null != isCopyGroupLevel
                && Strings.isNotBlank((String)isCopyGroupLevel)
                && "1".equals((String)isCopyGroupLevel)) {
            orgManagerDirect.copyGroupLevelToAccount(newAccount.getId());
        }

        V3xOrgMember admin = new V3xOrgMember();
        admin.setId(UUIDLong.longUUID());
        admin.setName(map.get("adminName").toString());
        admin.setType(OrgConstants.MEMBER_TYPE.FORMAL.ordinal());
        admin.setIsAdmin(true);
        admin.setOrgAccountId(newAccount.getId());
        admin.setV3xOrgPrincipal(new V3xOrgPrincipal(admin.getId(), map.get("adminName").toString(), map.get(
                "adminPass").toString()));
        
        //枚举调用记录
        if (Strings.isNotBlank(String.valueOf(map.get("unitCategory")))) {
            enumManagerNew.updateEnumItemRef("org_property_account_category", String.valueOf(map.get("unitCategory")));
        }

        OrganizationMessage message = orgManagerDirect.addAccount(newAccount, admin);
        User user = AppContext.getCurrentUser();
        //记录应用日志
        appLogManager.insertLog(user,  AppLogAction.Organization_NewAccount,  user.getName(),  newAccount.getName());
        OrgHelper.throwBusinessExceptionTools(message);
        return message.getSuccessMsgs().get(0).getEnt().getId();
    }
    
    /**
     * 将前台的选择转变成account中的数据
     * @param account
     * @param map
     */
    private void dealUnitAccess(V3xOrgAccount account, Map<String, Object> map) {
        String permissionType = (String)map.get("permissionType");
        account.setProperty("permissionType", Integer.valueOf(permissionType.trim()));
        List<Long> accessIds = new UniqueList<Long>();
        if("0".equals(permissionType)) {//统一设置
            String pType = (String)map.get("pType");
            if("1".equals(pType)) {//默认全部可见
                return;
            } else if("0".equals(pType)) {//全部不可见
                accessIds.add(account.getId());
                account.setIsCanAccess(false);
            }
        } else if("1".equals(permissionType)) {//分级设置
            List<Integer> accessLevels = new ArrayList<Integer>();
            account.setIsCanAccess(false);
            if(null != map.get("sLevel") 
                    && Strings.isNotBlank((String)map.get("sLevel"))) {//勾选了分支内可见上级单位
                accessLevels.add(Integer.valueOf(1));
            }
            if(null != map.get("pLevel") 
                    && Strings.isNotBlank((String)map.get("pLevel"))) {//勾选了分支内可见平级单位
                accessLevels.add(Integer.valueOf(2));
            }
            if(null != map.get("xLevel") 
                    && Strings.isNotBlank((String)map.get("xLevel"))) {//勾选了分之内可见下级单位
                accessLevels.add(Integer.valueOf(3));
            }
            //将关系表的数据组装给单位作为关系表的记录存储
            //此处单位可见分级控制代码超级冗余，如果有大侠能够帮忙修改提炼，不胜感激！！！
            //等待某位少侠来拯救这段逻辑，希望以后我自己能看懂
            if (accessLevels.contains(Integer.valueOf(1)) 
                    && !accessLevels.contains(Integer.valueOf(2))
                    && !accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_0);//只勾选了分支内可见上级单位
            } else if (!accessLevels.contains(Integer.valueOf(1)) 
                    && accessLevels.contains(Integer.valueOf(2))
                    && !accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_1);//只勾选了分支内可见平级单位
            } else if (!accessLevels.contains(Integer.valueOf(1)) 
                    && !accessLevels.contains(Integer.valueOf(2))
                    && accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_2);//只勾选了分支内可见下级单位
            } else if (accessLevels.contains(Integer.valueOf(1)) 
                    && !accessLevels.contains(Integer.valueOf(2))
                    && accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_4);//勾选分支内上级 && 分支内下级
            } else if (accessLevels.contains(Integer.valueOf(1)) 
                    && accessLevels.contains(Integer.valueOf(2))
                    && !accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_3);//勾选分支内上级 && 分之内平级
            } else if (!accessLevels.contains(Integer.valueOf(1)) 
                    && accessLevels.contains(Integer.valueOf(2))
                    && accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_5);//勾选分支内平级 && 分支内下级
            } else if (accessLevels.contains(Integer.valueOf(1)) 
                    && accessLevels.contains(Integer.valueOf(2))
                    && accessLevels.contains(Integer.valueOf(3))) {
                accessIds.add(OrgConstants.Account_AccessScope_Level_6);//三个都勾选了
            }
            account.setAccessScopeLevels(accessLevels);
        } else if("2".equals(permissionType)) {//自由设置
            String rangType = (String)map.get("rangType");
            if("1".equals(rangType)) {
                account.setIsCanAccess(true);
            } else {
                account.setIsCanAccess(false);
            }
            String range = (String)map.get("range");
            if(Strings.isNotBlank(range)) {
                String[] _temp = range.split(",");
                for (String typeAndId : _temp) {
                    String[] id = typeAndId.split("[|]");
                    accessIds.add(Long.valueOf(id[1].trim()));
                }
            } else {
                accessIds.add(-1L);
            }
        }
        account.setAccessIds(accessIds);
        
        //除了保存关系表还要保存的机构表中为了回写这里的选择
        List<Integer> accessScopeLevels = account.getAccessScopeLevels();
        StringBuilder accessLevels = new StringBuilder();
        for (Integer i : accessScopeLevels) {
            accessLevels.append(i).append(",");
        }
        account.setProperty("accessLevels", accessLevels.toString().trim());
    }

    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public Integer getMaxSort() throws BusinessException{
        return orgDao.getMaxSortId(V3xOrgAccount.class , OrgConstants.GROUPID);
    }
    
    /**
     * 处理单位的目录节点
     * @param account
     * @param ldapOu
     * @param accountId
     * @throws BusinessException
     */
    private void ldap4AccountOU(V3xOrgAccount account, String ldapOu, Long accountId) throws BusinessException {
        if (LdapUtils.isLdapEnabled()) {
            try {
                V3xLdapRdn value = null;
                value = organizationLdapEvent.findLdapSet(accountId);
                User user = AppContext.getCurrentUser();
                if (value == null) {
                    value = new V3xLdapRdn();
                    value.setRootAccountRdn(ldapOu);
                    value.setOrgAccountId(accountId);
                    appLogManager.insertLog(user, AppLogAction.LDAP_OU_Create, account.getName(),ldapOu);
                } else {
                    value.setRootAccountRdn(ldapOu);
                    appLogManager.insertLog(user, AppLogAction.LDAP_OU_Update,account.getName(),ldapOu);
                }
                organizationLdapEvent.saveOrUpdateLdapSet(account, value);
            } catch (Exception e) {
                logger.error("ldap_ad 更新和添加单位ldap配置！", e);
                throw new BusinessException("ldap_ad 更新和添加单位ldap配置！", e);
            }
        }
    }
    
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.GroupAdmin})
    public List<WebV3xOrgAccount> showAccountTree(Map params) throws BusinessException {
        List<V3xOrgAccount> orgAccounts = orgManagerDirect.getAllAccounts(null, true, null, null, null);
        Collections.sort(orgAccounts, CompareSortEntity.getInstance());
        List<WebV3xOrgAccount> treeResult = new ArrayList<WebV3xOrgAccount>();
        
        Map<String, V3xOrgAccount> path2AccountMap = new HashMap<String, V3xOrgAccount>();
        for (V3xOrgAccount a : orgAccounts) {
            path2AccountMap.put(a.getPath(), a);
        }
        
        Map<Long, Long> accId2parentAcc = new HashMap<Long, Long>();
        Set<Long> accHaschild = new HashSet<Long>();
        for (V3xOrgAccount a : orgAccounts) {
            String path = a.getPath();
            if(Strings.isNotBlank(path)) {
                if(path.length() > 4){
                    String parentpath = path.substring(0, path.length() - 4);
                    V3xOrgAccount t = path2AccountMap.get(parentpath);
                    if(t != null){
                        accId2parentAcc.put(a.getId(), t.getId());
                        accHaschild.add(t.getId());
                    }
                }
            }
        }
        
        for (V3xOrgAccount a : orgAccounts) {
        	String name = a.getName();
        	if(a.getStatus().equals(OrgConstants.ORGENT_STATUS.DISABLED.ordinal())){
        		name = name +"("+ResourceUtil.getString("org.entity.disabled")+")";
        	}
        	if(a.getStatus().equals(OrgConstants.ORGENT_STATUS.DELETED.ordinal())){
        		name = name +"("+ResourceUtil.getString("org.entity.deleted ")+")";
        	}
        	
            Long parentId = accId2parentAcc.get(a.getId())==null?Long.valueOf(-1):accId2parentAcc.get(a.getId());
            WebV3xOrgAccount treeAccount = new WebV3xOrgAccount(a.getId(), name, parentId);
            //treeAccount.setV3xOrgAccount(a);
            treeAccount.setLevel(new Long(a.getPath().length()/4));
            //处理zTree上的图标问题
            treeAccount.setIconSkin("account");
            if(accHaschild.contains(a.getId())) {
                treeAccount.setIconSkin("treeAccount");
            }
            treeResult.add(treeAccount);
        }
        //非集团的为了显示的组织结构根
        WebV3xOrgAccount nonAccount = new WebV3xOrgAccount(-1L, ResourceUtil.getString("org.account.structure.deployment"), -1L);
        nonAccount.setIconSkin("treeAccount");
        treeResult.add(nonAccount);
        
        return treeResult;
    }
    
    @Override
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
    public boolean isEnableLdap() {
        return LdapUtils.isLdapEnabled();
    }
    
	@Override
	public HashMap getAccountCustomerRoles(Long accountId) {
		List<V3xOrgRole> result =  new ArrayList<V3xOrgRole>();
		try {
			List<V3xOrgRole> accountCustomerRoles;
			//accountCustomerRoles = orgManager.getAllCustomerRoles(accountId, OrgConstants.ROLE_BOND.ACCOUNT.ordinal());
			accountCustomerRoles  = orgManager.getAllRoles(accountId);
			if(null!=accountCustomerRoles && accountCustomerRoles.size()>0){
				for(V3xOrgRole o : accountCustomerRoles){
					if(o.getStatus() == 1 && o.getBond()==OrgConstants.ROLE_BOND.ACCOUNT.ordinal()){//是否显示在单位信息
						if(o.getType()==V3xOrgEntity.ROLETYPE_RELATIVEROLE && !OrgConstants.GROUPID.equals(accountId)){
							result.add(o);
						}else if(OrgConstants.GROUPID.equals(accountId)){
							result.add(o);
						}
					}
				}
			}
		} catch (BusinessException e) {
		}
		
		HashMap m = new HashMap();
		m.put("accountCustomerRoles", result);
		return m;
	}
	
	// 客开 设置虚拟管理角色
	public void setVirtualAccAdmin(String virtualAccAdmin){
		if(Strings.isNotBlank(virtualAccAdmin) 
			&& "1".equals(virtualAccAdmin)){
			this.isVirtualAccAdmin = true;
		}
	}
		
}
