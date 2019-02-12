package com.seeyon.v3x.bulletin.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.RoleManager;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.domain.BulTypeManagers;
import com.seeyon.v3x.bulletin.manager.BulDataManager;
import com.seeyon.v3x.bulletin.manager.BulTypeManager;
import com.seeyon.v3x.bulletin.util.Constants;

@CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator }, extendRoles = { "SpaceManager" })
public class BulTypeController extends BaseController {

    private EnumManager        enumManagerNew;
    private BulTypeManager     bulTypeManager;
    private BulDataManager     bulDataManager;
    private OrgManager         orgManager;
    private AppLogManager      appLogManager;
    private SpaceManager       spaceManager;
    private RoleManager        roleManager;
    private UserMessageManager userMessageManager;

    public void setEnumManagerNew(EnumManager enumManager) {
        this.enumManagerNew = enumManager;
    }

    public void setBulTypeManager(BulTypeManager bulTypeManager) {
        this.bulTypeManager = bulTypeManager;
    }

    public void setBulDataManager(BulDataManager bulDataManager) {
        this.bulDataManager = bulDataManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public void setRoleManager(RoleManager roleManager) {
        this.roleManager = roleManager;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
        this.userMessageManager = userMessageManager;
    }

    public ModelAndView listMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("bulletin/admin/type_list_main");
    }

    public ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception {
        boolean isGroup = AppContext.getCurrentUser().isGroupAdmin();
        ModelAndView mav = new ModelAndView("bulletin/admin/type_list_iframe");
        String spaceId = request.getParameter("spaceId");
        Integer type = null;
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            type = spaceFix.getType();
            mav.addObject("spaceName", ResourceUtil.getString(spaceFix.getSpacename()));
            mav.addObject("spaceType", type);
        }
        List<BulType> list = new ArrayList<BulType>();
        if (Strings.isNotBlank(spaceId)) {
            list = bulTypeManager.customAccBoardFindAllByPage(Long.parseLong(spaceId), type, true);
        } else {
            list = isGroup ? bulTypeManager.groupFindAllByPage() : bulTypeManager.boardFindAllByPage();
        }
        return mav.addObject("list", list).addObject("isGroup", isGroup);
    }

    public ModelAndView create(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/admin/type_create");
        User user = AppContext.getCurrentUser();
        boolean isGroup = user.isGroupAdmin();
        BulType bean = new BulType();
        //客开 start  默认需要审核、排版
        //新建时，集团默认需要审核员，单位默认不需审核员
        //bean.setAuditFlag(isGroup);
        bean.setAuditFlag(true);
        bean.setTypesettingFlag(true);
        //客开 end
        bean.setUsedFlag(true);
        bean.setCreateDate(new Date());
        bean.setCreateUser(user.getId());
        bean.setIsAuditorModify(Boolean.TRUE);
        mav.addObject("bean", bean);

        mav.addObject("topCountMetaData", enumManagerNew.getEnum("bulletin_type_topCount"));
        mav.addObject("readOnly",false);

        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spaceType");
        //记录已有公告板块名称，以便随后在前端作重名判断
        if (Strings.isNotBlank(spaceId)) {
            List<Object[]> entityObj = spaceManager.getSecuityOfSpace(Long.parseLong(spaceId));
            String entity = "";
            for (Object[] obj : entityObj) {
                entity += obj[0] + "|" + obj[1] + ",";
            }
            if (!"".equals(entity)) {
                entity = entity.substring(0, entity.length() - 1);
            }
            mav.addObject("entity", entity);
            int spaceTypeInt = "public_custom".equalsIgnoreCase(spaceType) ? SpaceType.public_custom.ordinal() : SpaceType.public_custom_group.ordinal();
            mav.addObject("spaceType", spaceTypeInt);
            mav.addObject("typeNameList", bulTypeManager.customAccBoardAllBySpaceId(Long.parseLong(spaceId), spaceTypeInt));
        } else {
            mav.addObject("typeNameList", isGroup ? bulTypeManager.groupFindAll() : bulTypeManager.boardFindAll());
        }
        return mav.addObject("isGroup", isGroup);
    }

    public ModelAndView edit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean isGroup = user.isGroupAdmin();

        BulType bean = null;
        String idStr = request.getParameter("id");
        if (StringUtils.isBlank(idStr)) {
            //如果不存在，新建公告类型(这种情况似乎不会出现)
            bean = new BulType();
            //客开 start
            //bean.setAuditFlag(isGroup); //单位新闻修改缺省是不需要审核，集团新闻板块需要
            bean.setAuditFlag(true); //默认都需要审核
            bean.setTypesettingFlag(true);
            //客开 end
            bean.setUsedFlag(true);
            bean.setCreateDate(new Date());
            bean.setCreateUser(user.getId());
        } else {
            bean = bulTypeManager.getById(Long.valueOf(idStr));
        }
        ModelAndView mav = new ModelAndView("bulletin/admin/type_create");
		// 默认设置显示发布人
		if (bean.getDefaultPublish() == null) {
			bean.setDefaultPublish(false);
		}
		if (bean.getFinalPublish() == null) {
			bean.setFinalPublish(0);
		}
		if (bean.getWritePermit()== null) {
			bean.setWritePermit(false);
		}
        mav.addObject("bean", bean);
        mav.addObject("readOnly", "readOnly".equals(request.getParameter("isDetail")));

        boolean hasPending = false;
        boolean isAlert = false;
        //客开 start
        boolean hasPending2 = false;
        boolean isAlert2 = false;
        //客开 end
        if (bean.isAuditFlag()) {
            //如果审核员已不可用，此处需加以判断，避免在审核员停用后有人发起公告的情况下，审核员无法修改
            Long auditorId = bean.getAuditUser();
            if (auditorId != -1) {
                isAlert = check(bean.getAccountId(), auditorId);
            }
            if ("readOnly".equals(request.getParameter("isDetail"))) {
                isAlert = false;
            }
            mav.addObject("isAlert", isAlert);
            V3xOrgMember auditor = this.orgManager.getMemberById(bean.getAuditUser());
            boolean isAuditorValid = auditor != null && auditor.isValid();
            //单位、集团预置板块审核员ID为0，需加以判断，此种情况下允许修改为不审核
            if (auditorId != 0 && auditorId != -1l && !isAuditorValid) {
                //添加标识参数：表明该板块待审的公告需要转到新的审核员名下
                mav.addObject("needTransfer2NewAuditor", true).addObject("oldAuditorId", bean.getAuditUser());
            } else {
                hasPending = bulDataManager.hasPendingOfUser(bean.getAuditUser(), bean.getId());
            }
            //单位、集团预置板块审核员ID为0，需加以判断，此种情况下允许修改为不审核
            if (bean.getAuditUser() == 0) {
                mav.addObject("isAlert", false);
            }
        }
        mav.addObject("hasPending", isAlert ? false : hasPending);
        //客开 start
        if(bean.isTypesettingFlag()){
          Long auditorId = bean.getTypesettingStaff();
          if (auditorId != -1) {
              isAlert2 = check(bean.getAccountId(), auditorId);
          }
          if ("readOnly".equals(request.getParameter("isDetail"))) {
              isAlert2 = false;
          }
          mav.addObject("isAlert2", isAlert2);
          //如果排版员已不可用，此处需加以判断，避免在排版员停用后有人发起公告的情况下，排版员无法修改
          V3xOrgMember auditor = this.orgManager.getMemberById(auditorId);
          boolean isAuditorValid = auditor != null && auditor.isValid();
          //单位、集团预置板块审核员ID为0，需加以判断，此种情况下允许修改为不审核
          if (auditorId != 0 && auditorId != -1l && !isAuditorValid) {
              //添加标识参数：表明该板块待审的公告需要转到新的审核员名下
              mav.addObject("needTransfer2NewTypesetting", true).addObject("oldTypesettingId", bean.getTypesettingStaff());
          } else {
              hasPending2 = bulDataManager.hasPending2OfUser(bean.getTypesettingStaff(), bean.getId());
          }
          //单位、集团预置板块审核员ID为0，需加以判断，此种情况下允许修改为不审核
          if (bean.getTypesettingStaff() == 0) {
              mav.addObject("isAlert2", false);
          }
        }
        mav.addObject("hasPending2", isAlert2 ? false : hasPending2);
        //客开 end
        mav.addObject("topCountMetaData", enumManagerNew.getEnum("bulletin_type_topCount"));

        List<BulType> types = new ArrayList<BulType>();
        String spaceId = request.getParameter("spaceId");
        Integer type = null;
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            type = spaceFix.getType();
        }
        if (Strings.isNotBlank(spaceId)) {
            String spaceType = request.getParameter("spaceType");
            int spaceTypeInt = "public_custom".equalsIgnoreCase(spaceType) ? SpaceType.public_custom.ordinal() : SpaceType.public_custom_group.ordinal();
            mav.addObject("spaceType", spaceTypeInt);
            List<Object[]> entityObj = spaceManager.getSecuityOfSpace(Long.parseLong(spaceId));
            String entity = "";
            for (Object[] obj : entityObj) {
                entity += obj[0] + "|" + obj[1] + ",";
            }
            if (!"".equals(entity)) {
                entity = entity.substring(0, entity.length() - 1);
            }
            mav.addObject("entity", entity);
            types = bulTypeManager.customAccBoardAllBySpaceId(Long.parseLong(spaceId), type);
        } else {
            types = isGroup ? bulTypeManager.groupFindAll() : bulTypeManager.boardFindAll();
        }
        //记录已有公告板块(排除自己)名称，以便随后在前端作重名判断
        types.remove(bean);
        return mav.addObject("typeNameList", types).addObject("isGroup", isGroup);
    }

    public boolean check(Long spaceId, Long auditId) throws BusinessException {
        boolean flag = true;
        Set<Long> entityIds = new HashSet<Long>(); //取当前空间使用范围内的所有人员
        List<Object[]> entityObj = spaceManager.getSecuityOfSpace(spaceId);
        if (CollectionUtils.isEmpty(entityObj)) {
            List<V3xOrgMember> members = orgManager.getAllMembers(spaceId);
            for (V3xOrgMember member : members) {
                entityIds.add(member.getId());
            }
        } else {
            String scopeStr = "";
            for (Object[] objects : entityObj) {
                scopeStr += objects[0] + "|" + objects[1] + ",";
            }
            if (Strings.isNotBlank(scopeStr)) {
                scopeStr = scopeStr.substring(0, scopeStr.length() - 1);
            }
            Set<V3xOrgMember> members = orgManager.getMembersByTypeAndIds(scopeStr);
            for (V3xOrgMember org : members) {
                entityIds.add(org.getId());
            }
        }
        if (entityIds.contains(auditId)) {
            flag = false;
        }
        return flag;
    }

    public ModelAndView save(HttpServletRequest request, HttpServletResponse response) throws Exception {
        BulType bean = null;
        String idStr = request.getParameter("id"); //id：指板块的id
        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spacetype");
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            spaceType = String.valueOf(spaceFix.getType());
        }
        try {
            boolean isNew = Strings.isBlank(idStr);
            bean = isNew ? new BulType() : bulTypeManager.getById(Long.valueOf(idStr));
            if (!isNew) {
                this.delRoleInfo(bean);
            }
            super.bind(request, bean);
            //版块设置添加控制各项控制修改
            if(request.getParameter("printFlag") == null){
            	bean.setPrintFlag(false);
            	bean.setPrintDefault(false);
            }
            if(request.getParameter("printDefault") == null){
            	bean.setPrintFlag(false);
            }
            if(request.getParameter("defaultPublish") == null){
            	bean.setDefaultPublish(false);
            }
            if(request.getParameter("finalPublish") == null){
            	bean.setFinalPublish(0);
            }
            if(request.getParameter("writePermit") == null){
            	bean.setWritePermit(false);
            }

            if (bean.isNew()) {
                bean.setCreateDate(new Date());
                bean.setCreateUser(AppContext.getCurrentUser().getId());
            }
            bean.setUpdateDate(new Date());
            bean.setUpdateUser(AppContext.getCurrentUser().getId());

            if (!bean.isAuditFlag()) {
                bean.setAuditUser(0l);
                //不审核时，默认设置显示发起人
                bean.setFinalPublish(1);
            }
            if (Strings.isNotBlank(spaceId) && Strings.isBlank(idStr)) {
                bean.setAccountId(Long.parseLong(spaceId));
                bean.setSpaceType(Integer.parseInt(spaceType));
            }
            //客开 SZP start
            //bean.setTypesettingFlag(true);
            if (!bean.isTypesettingFlag()) {
                bean.setTypesettingStaff(0l);
            }
            //客开 SZP end
            bulTypeManager.save(bean);
            User user = AppContext.getCurrentUser();

            String roleName4Admin = "";
            String roleName4Auditor = "";
            if (user.isGroupAdmin()) {
                roleName4Admin = OrgConstants.Role_NAME.GroupBulletinAdmin.name();
                roleName4Auditor = OrgConstants.Role_NAME.GroupBulletinAuditor.name();
                appLogManager.insertLog(user, AppLogAction.Group_BulManagers_Update, user.getName(), bean.getTypeName(), Constants.getActionText(isNew));
            } else {
                roleName4Admin = OrgConstants.Role_NAME.UnitBulletinAdmin.name();
                roleName4Auditor = OrgConstants.Role_NAME.UnitBulletinAuditor.name();
                String accountName = this.orgManager.getAccountById(user.getLoginAccount()).getName();
                appLogManager.insertLog(user, AppLogAction.Account_BulManagers_Update, user.getName(), accountName, bean.getTypeName(), Constants.getActionText(isNew));
            }
            //管理员角色处理
            roleManager.batchRole2Member(roleName4Admin, AppContext.currentAccountId(), bean.getManagerUserIds());
            //审核员角色处理
            if (bean.isAuditFlag()) {
                roleManager.batchRole2Member(roleName4Auditor, AppContext.currentAccountId(), String.valueOf(bean.getAuditUser()));
            }
            //处理公告板块置顶个数变化之后的情况，已置顶的该板块公告置顶数需同步调整
            if (!bean.isNew()) {
                String oldTopCountStr = request.getParameter("oldTopCount");
                String newTopCountStr = request.getParameter("topCount");
                this.bulDataManager.updateTopOrder(oldTopCountStr, newTopCountStr, bean.getId());
            }
            //该板块存在待审核公告，但当时的审核员已不可用，如果随后该板块设定了新的审核员，需要将原先的待审核公告转给新的审核员
            if (!bean.isNew() && "true".equals(request.getParameter("needTransfer2NewAuditor")) && bean.isAuditFlag()) {
                Long oldAuditorId = Long.parseLong(request.getParameter("oldAuditorId"));
                this.bulDataManager.transferWait4AuditBulDatas2NewAuditor(bean.getId(), oldAuditorId, bean.getAuditUser());
            }
            //客开 start
            //该板块存在待排版新闻，但当时的排版员已不可用，如果随后该板块设定了新的排版员，需要将原先的待排版公告转给新的排版员
            if (!bean.isNew() && "true".equals(request.getParameter("needTransfer2NewTypesetting")) && bean.isTypesettingFlag()) {
              Long oldTypesettingId = Long.parseLong(request.getParameter("oldTypesettingId"));
              this.bulDataManager.transferWait4AuditBulDatas2NewTypesettingStaff(bean.getId(), oldTypesettingId, bean.getTypesettingStaff());
            }
            //客开 end
        } catch (BusinessException e) {
            ModelAndView mav = new ModelAndView("bulletin/admin/type_list_main");
            mav.addObject("topCountMetaData", enumManagerNew.getEnum("bulletin_type_topCount"));

            mav.addObject("bean", bean);
            request.getSession().setAttribute("_my_exception", e);
            return mav;
        }

        super.rendJavaScript(response, "parent.location.href = parent.location;");
        return null;
    }

    public ModelAndView delete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Long> typeids = CommonTools.parseStr2Ids(request.getParameter("id"));
        for (Long id : typeids) {
            BulType type = bulTypeManager.getById(id);
            if (type != null) {
                this.delRoleInfo(type);
                String name = AppContext.currentUserName();
                appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Bulletin_Type_Delete, name, type.getTypeName());
            }
        }

        bulTypeManager.setTypeDeleted(typeids);
        List<BulData> l = new ArrayList<BulData>();
        for (Long typeid : typeids) {
            l = bulDataManager.searchBulDatas(typeid);
            List<Long> ids = new ArrayList<Long>();
            for (BulData b : l) {
                long id = b.getId();
                ids.add(id);
            }
            bulDataManager.deletes(ids);
        }
        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spaceType");
        return this.redirectModelAndView("/bulType.do?method=listMain&spaceType=" + spaceType + "&spaceId=" + spaceId);
    }

    /**
     * 取消管理员/审核员角色
     * 其它同类型（单位、集团）板块所有管理员中不包含此板块管理员的先删除增加
     */
    private void delRoleInfo(BulType type) throws Exception {
        if (type == null) {
            return;
        }

        User user = AppContext.getCurrentUser();
        String roleName4Admin = "";
        String roleName4Auditor = "";
        List<BulType> types = null;
        if (user.isGroupAdmin()) {
            roleName4Admin = OrgConstants.Role_NAME.GroupBulletinAdmin.name();
            roleName4Auditor = OrgConstants.Role_NAME.GroupBulletinAuditor.name();
            types = bulTypeManager.groupFindAll();
        } else {
            roleName4Admin = OrgConstants.Role_NAME.UnitBulletinAdmin.name();
            roleName4Auditor = OrgConstants.Role_NAME.UnitBulletinAuditor.name();
            types = bulTypeManager.boardFindAll();
        }

        Set<Long> otherAdmins = new HashSet<Long>();
        Set<Long> otherAuditors = new HashSet<Long>();
        if (Strings.isNotEmpty(types)) {
            for (BulType bulType : types) {
                if (!bulType.equals(type)) {
                    Set<BulTypeManagers> bulTypeManagers = bulType.getBulTypeManagers();
                    if (Strings.isNotEmpty(bulTypeManagers)) {
                        for (BulTypeManagers bulTypeManager : bulTypeManagers) {
                            otherAdmins.add(bulTypeManager.getManagerId());
                        }
                    }
                    Long bulTypeAuditUser = bulType.getAuditUser();
                    if (bulTypeAuditUser != null && !bulTypeAuditUser.equals(0L)) {
                        otherAuditors.add(bulTypeAuditUser);
                    }
                }
            }
        }

        String adminEntityIds = "";
        String auditorEntityIds = "";
        Set<BulTypeManagers> oldBulTypeManagers = type.getBulTypeManagers();
        Long oldBulTypeAuditUser = type.getAuditUser();
        if (Strings.isNotEmpty(oldBulTypeManagers)) {
            for (BulTypeManagers bulTypeManager : oldBulTypeManagers) {
                if (!otherAdmins.contains(bulTypeManager.getManagerId())) {
                    adminEntityIds += OrgConstants.ORGENT_TYPE.Member.name() + "|" + bulTypeManager.getManagerId() + ",";
                }
            }
        }

        if (oldBulTypeAuditUser != null && !oldBulTypeAuditUser.equals(0L)) {
            if (!otherAuditors.contains(oldBulTypeAuditUser)) {
                auditorEntityIds += OrgConstants.ORGENT_TYPE.Member.name() + "|" + oldBulTypeAuditUser + ",";
            }
        }

        if (Strings.isNotBlank(adminEntityIds)) {
            roleManager.delRole2Entity(roleName4Admin, AppContext.currentAccountId(), adminEntityIds);
        }
        if (Strings.isNotBlank(auditorEntityIds)) {
            roleManager.delRole2Entity(roleName4Auditor, AppContext.currentAccountId(), auditorEntityIds);
        }
    }

    public ModelAndView orderBulType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spaceType");
        int spaceTypeInt = "public_custom".equalsIgnoreCase(spaceType) ? SpaceType.public_custom.ordinal() : SpaceType.public_custom_group.ordinal();
        List<BulType> typelist = new ArrayList<BulType>();
        if (Strings.isNotBlank(spaceId)) {
            typelist = bulTypeManager.customAccBoardFindAllByPage(Long.parseLong(spaceId), spaceTypeInt, false);
        } else {
            typelist = AppContext.getCurrentUser().isGroupAdmin() ? bulTypeManager.groupFindAll() : bulTypeManager.boardFindAll();
        }
        return new ModelAndView("bulletin/admin/orderBulType", "typelist", typelist);
    }

    public ModelAndView saveOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
        bulTypeManager.updateBulTypeOrder(request.getParameterValues("projects"));
        return super.refreshWorkspace();
    }

    @CheckRoleAccess(roleTypes = { Role_NAME.NULL })
    public ModelAndView bulTypeSet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean isGroup = user.isGroupAdmin();

        BulType bean = null;
        String idStr = request.getParameter("id");
        if (StringUtils.isBlank(idStr)) {
            //如果不存在，新建公告类型(这种情况似乎不会出现)
            bean = new BulType();
            bean.setAuditFlag(isGroup);
            bean.setUsedFlag(true);
            bean.setCreateDate(new Date());
            bean.setCreateUser(user.getId());
        } else {
            bean = bulTypeManager.getById(Long.valueOf(idStr));
        }
        ModelAndView mav = new ModelAndView("bulletin/bulTypeSetting");

        //授权
        List<BulTypeManagers> listW = bulTypeManager.findTypeWriters(bean);
        List<V3xOrgEntity> auList = new ArrayList<V3xOrgEntity>();
        if (listW != null && listW.size() > 0) {
            StringBuffer strbuf = new StringBuffer();
            for (BulTypeManagers managers : listW) {
                strbuf.append(managers.getExt2() + "|" + managers.getManagerId() + ",");
            }
            auList = orgManager.getEntities(strbuf.substring(0, strbuf.length() - 1));
            mav.addObject("managerId", auList);
        }
		// 默认设置显示发布人
		if (bean.getDefaultPublish() == null) {
			bean.setDefaultPublish(true);
		}
		if (bean.getFinalPublish() == null) {
			bean.setFinalPublish(0);
		}
		if (bean.getWritePermit() == null) {
			bean.setWritePermit(false);
		}

        mav.addObject("bean", bean);
        mav.addObject("topCountMetaData", enumManagerNew.getEnum("bulletin_type_topCount"));
        List<BulType> types = new ArrayList<BulType>();
        String spaceId = request.getParameter("spaceId");
        Integer type = null;
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            type = spaceFix.getType();
        }
        if (Strings.isNotBlank(spaceId)) {
            String spaceType = request.getParameter("spaceType");
            int spaceTypeInt = "public_custom".equalsIgnoreCase(spaceType) ? SpaceType.public_custom.ordinal() : SpaceType.public_custom_group.ordinal();
            mav.addObject("spaceType", spaceTypeInt);
            List<Object[]> entityObj = spaceManager.getSecuityOfSpace(Long.parseLong(spaceId));
            String entity = "";
            for (Object[] obj : entityObj) {
                entity += obj[0] + "|" + obj[1] + ",";
            }
            if (!"".equals(entity)) {
                entity = entity.substring(0, entity.length() - 1);
            }
            mav.addObject("entity", entity);
            types = bulTypeManager.customAccBoardAllBySpaceId(Long.parseLong(spaceId), type);
        } else {
            types = isGroup ? bulTypeManager.groupFindAll() : bulTypeManager.boardFindAll();
        }
        //记录已有公告板块(排除自己)名称，以便随后在前端作重名判断
        types.remove(bean);
        return mav.addObject("typeNameList", types).addObject("isGroup", isGroup);
    }

    @CheckRoleAccess(roleTypes = { Role_NAME.NULL })
    public ModelAndView modifyTypeBul(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        User user = AppContext.getCurrentUser();

        String typeId = request.getParameter("typeId");
        String authIssue = request.getParameter("authIssue");
        String printFlag = request.getParameter("printFlag");
        String printDefault = request.getParameter("printDefault");
        String topCount = request.getParameter("topCount");
        String oldTopCount = request.getParameter("oldTopCount");
        String finalPublish = request.getParameter("finalPublish");
        String defaultPublish = request.getParameter("defaultPublish");
        String writePermit = request.getParameter("writePermit");

        BulType bulType = new BulType();
        if (Strings.isNotBlank(typeId)) {
            bulType = bulTypeManager.getById(Long.valueOf(typeId));
        }
        if (Strings.isNotBlank(writePermit)) {
            bulType.setWritePermit("true".equals(writePermit) ? true : false);
        }
        if (Strings.isNotBlank(defaultPublish)) {
            bulType.setDefaultPublish("true".equals(defaultPublish) ? true : false);
        }
        if (Strings.isNotBlank(finalPublish)) {
            bulType.setFinalPublish(Integer.valueOf(finalPublish));
        }
        if (Strings.isNotBlank(printFlag)) {
            bulType.setPrintFlag("true".equals(printFlag) ? true : false);
        }
        if (Strings.isNotBlank(printDefault)) {
            bulType.setPrintDefault("true".equals(printDefault) ? true : false);
        } else {
            bulType.setPrintDefault(false);
        }
        if (Strings.isNotBlank(topCount)) {
            bulType.setTopCount(Byte.valueOf(topCount));
            //处理公告板块置顶个数变化之后的情况，已置顶的该板块公告置顶数需同步调整
            this.bulDataManager.updateTopOrder(oldTopCount, topCount, Long.valueOf(typeId));
        }
        if (Strings.isBlank(authIssue)) {
            this.bulTypeManager.saveWriteByType(Long.valueOf(typeId), new String[0][0]);
            //对整个操作过程记录应用日志
            appLogManager.insertLog(user, AppLogAction.News_PostAuth_Update, user.getName(), bulType.getTypeName());
        } else {

            //授权人
            String[][] authInfoArray = Strings.getSelectPeopleElements(authIssue);
            // 构造消息接收者
            List<Long> auth = new ArrayList<Long>();
            Set<V3xOrgMember> membersSet = orgManager.getMembersByTypeAndIds(authIssue);
            for (V3xOrgMember entity : membersSet) {
                if (!user.getId().equals(entity.getId())) {
                    auth.add(entity.getId());
                }
            }

            // 消息过滤
            List<BulTypeManagers> oldWriter = this.bulTypeManager.findTypeWriters(bulType);
            if (CollectionUtils.isNotEmpty(oldWriter)) {
                for (BulTypeManagers ntm : oldWriter) {
                    Set<V3xOrgMember> membersOld = orgManager.getMembersByTypeAndIds(ntm.getExt2()+"|"+ntm.getManagerId());
                    if (CollectionUtils.isNotEmpty(membersOld)) {
                        for (V3xOrgMember org:membersOld){
                            auth.remove(org.getId());
                        }
                    }
                }
            }

            userMessageManager.sendSystemMessage(MessageContent.get("bul.accredit", bulType.getTypeName(), user.getName()), ApplicationCategoryEnum.bulletin, user.getId(), MessageReceiver.getReceivers(bulType.getId(), auth, "", typeId, bulType.getId()));
            this.bulTypeManager.saveWriteByType(Long.valueOf(typeId), authInfoArray);

            //对整个操作记录应用日志
            appLogManager.insertLog(user, AppLogAction.News_PostAuth_Update, user.getName(), bulType.getTypeName());
        }

        bulType.setUpdateDate(new Date());
        bulType.setUpdateUser(user.getId());
        bulType.isNew();
        bulTypeManager.save(bulType);

        return super.refreshWindow("parent");
    }

}