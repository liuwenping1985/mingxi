package com.seeyon.v3x.news.controller;

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
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.RoleManager;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.domain.NewsTypeManagers;
import com.seeyon.v3x.news.manager.NewsDataManager;
import com.seeyon.v3x.news.manager.NewsTypeManager;

@CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator }, extendRoles = { "SpaceManager" })
public class NewsTypeController extends BaseController {

    private NewsTypeManager    newsTypeManager;
    private NewsDataManager    newsDataManager;
    private EnumManager        enumManagerNew;
    private OrgManager         orgManager;
    private AppLogManager      appLogManager;
    private SpaceManager       spaceManager;
    private RoleManager        roleManager;
    private UserMessageManager userMessageManager;

    public void setNewsTypeManager(NewsTypeManager newsTypeManager) {
        this.newsTypeManager = newsTypeManager;
    }

    public void setNewsDataManager(NewsDataManager newsDataManager) {
        this.newsDataManager = newsDataManager;
    }

    public void setEnumManagerNew(EnumManager enumManager) {
        this.enumManagerNew = enumManager;
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
        ModelAndView mav = new ModelAndView("news/admin/type_list_main");
        if (request.getParameter("id") != null)
            mav.addObject("id", request.getParameter("id"));
        return mav.addObject("isGroup", AppContext.getCurrentUser().isGroupAdmin());
    }

    public ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean isGroup = user.isGroupAdmin();
        String spaceId = request.getParameter("spaceId");
        Integer type = null;
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            type = spaceFix.getType();
        }
        List<NewsType> list = new ArrayList<NewsType>();
        if (Strings.isNotBlank(spaceId)) {
            list = newsTypeManager.findAllByCustomAccId(Long.parseLong(spaceId), type, true);
        } else {
            list = isGroup ? newsTypeManager.groupFindAllByPage() : newsTypeManager.findAllByPage(user.getLoginAccount());
        }
        return new ModelAndView("news/admin/type_list_iframe").addObject("list", list).addObject("isGroup", isGroup);
    }

    public ModelAndView create(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("news/admin/type_create");
        User user = AppContext.getCurrentUser();
        boolean isGroup = user.isGroupAdmin();
        NewsType bean = new NewsType();
        //客开 start  默认需要审核、排版
        //bean.setAuditFlag(isGroup);
        bean.setAuditFlag(true);
        bean.setTypesettingFlag(true);
        //客开 end
        bean.setUsedFlag(true);
        bean.setCreateDate(new Date());
        bean.setCreateUser(user.getId());
        bean.setIsAuditorModify(Boolean.TRUE);
        mav.addObject("bean", bean);

        mav.addObject("topCountMetaData", enumManagerNew.getEnum("news_type_topCount"));//标新天数
        mav.addObject("topNumberData", enumManagerNew.getEnum("bulletin_type_topCount"));//置顶个数

        String spaceId = request.getParameter("spaceId");
        if (StringUtils.isNotBlank(spaceId)) {

        }
        String spaceType = request.getParameter("spaceType");
        int spaceTypeInt = "public_custom".equalsIgnoreCase(spaceType) ? SpaceType.public_custom.ordinal() : SpaceType.public_custom_group.ordinal();
        //已创建新闻类型列表，用于在前端判断是否存在重名板块
        if (Strings.isNotBlank(spaceId)) {
            List<Object[]> entityObj = spaceManager.getSecuityOfSpace(Long.parseLong(spaceId));
            String entity = "";
            for (Object[] obj : entityObj) {
                entity += obj[0] + "|" + obj[1] + ",";
            }
            if (!"".equals(entity)) {
                entity = entity.substring(0, entity.length() - 1);
            }
            mav.addObject("spaceType", spaceTypeInt);
            mav.addObject("entity", entity);
            mav.addObject("typeNameList", newsTypeManager.findAllOfCustomAcc(Long.parseLong(spaceId), spaceTypeInt));
        } else {
            mav.addObject("typeNameList", isGroup ? newsTypeManager.groupFindAll() : newsTypeManager.findAll(user.getLoginAccount()));
        }
        return mav.addObject("isGroup", isGroup);
    }

    @CheckRoleAccess(roleTypes = { Role_NAME.NULL })
    public ModelAndView edit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        NewsType bean = null;
        String idStr = request.getParameter("id");
        User user = AppContext.getCurrentUser();
        boolean isGroup = user.isGroupAdmin();
        ModelAndView mav = new ModelAndView("news/admin/type_create");

        if (StringUtils.isBlank(idStr)) {
            //如果不存在，新文件新闻类型
            bean = new NewsType();
            bean.setAuditUser(user.getId());
            //客开 start
            //bean.setAuditFlag(isGroup); //单位新闻修改缺省是不需要审核，集团新闻板块需要
            bean.setAuditFlag(true); //默认都需要审核
            bean.setTypesettingFlag(true);
            //客开 end
            bean.setUsedFlag(true);
            bean.setCreateDate(new Date());
            bean.setCreateUser(user.getId());
        } else {
            bean = newsTypeManager.getById(Long.valueOf(idStr));
        }
        String from = request.getParameter("from");
        if (!user.isAdmin() && "index".equals(from)) {
            mav = new ModelAndView("news/newsTypeSetting");
            // 授权
            List<NewsTypeManagers> listW = this.newsDataManager.getNewsTypeManager().findTypeWriters(bean);
            if (listW != null && listW.size() > 0) {
                StringBuffer strbuf = new StringBuffer();
                for (NewsTypeManagers managers : listW) {
                    strbuf.append(managers.getExt2() + "|" + managers.getManagerId() + ",");
                }
                mav.addObject("managerId", strbuf.substring(0, strbuf.length() - 1));
            }
        }

        mav.addObject("bean", bean);
        // 取得是否是详细页面标志
        mav.addObject("readOnly", "readOnly".equals(request.getParameter("isDetail")));

        // 判断是否有待办
        boolean hasPending = false;
        boolean isAlert = false;
        //客开 start
        boolean hasPending2 = false;
        boolean isAlert2 = false;
        //客开 end
        if (bean.isAuditFlag()) {
            Long auditorId = bean.getAuditUser();
            if (auditorId != -1) {
                isAlert = check(bean.getAccountId(), auditorId);
            }
            if ("readOnly".equals(request.getParameter("isDetail"))) {
                isAlert = false;
            }
            mav.addObject("isAlert", isAlert);
            //如果审核员已不可用，此处需加以判断，避免在审核员停用后有人发起公告的情况下，审核员无法修改
            V3xOrgMember auditor = this.orgManager.getMemberById(auditorId);
            boolean isAuditorValid = auditor != null && auditor.isValid();
            //单位、集团预置板块审核员ID为0，需加以判断，此种情况下允许修改为不审核
            if (auditorId != 0 && auditorId != -1l && !isAuditorValid) {
                //添加标识参数：表明该板块待审的公告需要转到新的审核员名下
                mav.addObject("needTransfer2NewAuditor", true).addObject("oldAuditorId", bean.getAuditUser());
            } else {
                hasPending = newsDataManager.hasPendingOfUser(bean.getAuditUser(), bean.getId());
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
              hasPending2 = newsDataManager.hasPending2OfUser(bean.getTypesettingStaff(), bean.getId());
          }
          //单位、集团预置板块审核员ID为0，需加以判断，此种情况下允许修改为不审核
          if (bean.getTypesettingStaff() == 0) {
              mav.addObject("isAlert2", false);
          }
        }
        mav.addObject("hasPending2", isAlert2 ? false : hasPending2);
        //客开 end

        mav.addObject("topCountMetaData", enumManagerNew.getEnum("news_type_topCount"));
        mav.addObject("topNumberData", enumManagerNew.getEnum("bulletin_type_topCount"));//置顶个数
        String spaceId = request.getParameter("spaceId");
        Integer type = null;
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            type = spaceFix.getType();
        }
        List<NewsType> namelist = new ArrayList<NewsType>();
        if (Strings.isNotBlank(spaceId)) {
            List<Object[]> entityObj = spaceManager.getSecuityOfSpace(Long.parseLong(spaceId));
            String entity = "";
            for (Object[] obj : entityObj) {
                entity += obj[0] + "|" + obj[1] + ",";
            }
            if (!"".equals(entity)) {
                entity = entity.substring(0, entity.length() - 1);
            }
            mav.addObject("spaceType", type);
            mav.addObject("entity", entity);
            namelist = newsTypeManager.findAllOfCustomAcc(Long.parseLong(spaceId), type);
        } else {
            namelist = isGroup ? newsTypeManager.groupFindAll() : newsTypeManager.findAll(user.getLoginAccount());
        }
        namelist.remove(bean);
        mav.addObject("typeNameList", namelist);//已创建新闻类型列表//前端做判断是否重名
        return mav.addObject("isGroup", isGroup);
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
        NewsType bean = null;
        String idStr = request.getParameter("id");
        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spacetype");
        if (StringUtils.isNotBlank(spaceId)) {
            PortalSpaceFix spaceFix = spaceManager.getSpaceFix(Long.valueOf(spaceId));
            spaceType = String.valueOf(spaceFix.getType());
        }
        try {
            boolean isNew = StringUtils.isBlank(idStr);
            bean = isNew ? new NewsType() : newsTypeManager.getById(Long.valueOf(idStr));
            if (!isNew) {
                this.delRoleInfo(bean);
            }
            NewsType temp = new NewsType();
            super.bind(request, temp);
            //20120-10-18 添加的if条件
            if (bean != null) {
                temp.setAccountId(bean.getAccountId());
            }

            if (temp.getAccountId() == null) {
                temp.setAccountId(AppContext.getCurrentUser().getLoginAccount());
            }

            super.bind(request, bean);

            if (bean.isNew()) {
                bean.setCreateDate(new Date());
                bean.setCreateUser(AppContext.getCurrentUser().getId());
            }
            bean.setUpdateDate(new Date());
            bean.setUpdateUser(AppContext.getCurrentUser().getId());

            if (!bean.isAuditFlag()) {
                bean.setAuditUser(0l);
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

            newsTypeManager.save(bean, false);
            User user = AppContext.getCurrentUser();
            String roleName4Admin = "";
            String roleName4Auditor = "";
            if (user.isGroupAdmin()) {
                roleName4Admin = OrgConstants.Role_NAME.GroupNewsAdmin.name();
                roleName4Auditor = OrgConstants.Role_NAME.GroupNewsAuditor.name();
                appLogManager.insertLog(user, AppLogAction.Group_NewsManagers_Update, user.getName(), bean.getTypeName(), ResourceUtil.getString("bul.manageraction." + isNew));
            } else {
                roleName4Admin = OrgConstants.Role_NAME.UnitNewsAdmin.name();
                roleName4Auditor = OrgConstants.Role_NAME.UnitNewsAuditor.name();
                String accountName = this.orgManager.getAccountById(user.getLoginAccount()).getName();
                appLogManager.insertLog(user, AppLogAction.Account_NewsManagers_Update, user.getName(), accountName, bean.getTypeName(), ResourceUtil.getString("bul.manageraction." + isNew));
            }

            //管理员角色处理
            roleManager.batchRole2Member(roleName4Admin, AppContext.currentAccountId(), bean.getManagerUserIds());
            //审核员角色处理
            if (bean.isAuditFlag()) {
                roleManager.batchRole2Member(roleName4Auditor, AppContext.currentAccountId(), String.valueOf(bean.getAuditUser()));
            }
            //处理新闻板块置顶个数变化之后的情况，已置顶的该板块新闻置顶数需同步调整
            if (!bean.isNew()) {
                String oldTopNumberStr = request.getParameter("oldTopNumber");
                String newTopNumberStr = request.getParameter("topNumber");
                this.newsDataManager.updateTopNumberOrder(oldTopNumberStr, newTopNumberStr, bean.getId());
            }
            //该板块存在待审核新闻，但当时的审核员已不可用，如果随后该板块设定了新的审核员，需要将原先的待审核新闻转给新的审核员
            if (!bean.isNew() && "true".equals(request.getParameter("needTransfer2NewAuditor")) && bean.isAuditFlag()) {
                Long oldAuditorId = Long.parseLong(request.getParameter("oldAuditorId"));
                this.newsDataManager.transferWait4AuditBulDatas2NewAuditor(bean.getId(), oldAuditorId, bean.getAuditUser());
            }
            //客开 start
            //该板块存在待排版新闻，但当时的排版员已不可用，如果随后该板块设定了新的排版员，需要将原先的待排版新闻转给新的排版员
            if (!bean.isNew() && "true".equals(request.getParameter("needTransfer2NewTypesetting")) && bean.isTypesettingFlag()) {
              Long oldTypesettingId = Long.parseLong(request.getParameter("oldTypesettingId"));
              this.newsDataManager.transferWait4AuditBulDatas2NewTypesettingStaff(bean.getId(), oldTypesettingId, bean.getTypesettingStaff());
            }
            //客开 end
        } catch (BusinessException e) {
            ModelAndView mav = new ModelAndView("news/admin/type_list_main");
            mav.addObject("topCountMetaData", enumManagerNew.getEnum("news_type_topCount"));
            mav.addObject("topNumberData", enumManagerNew.getEnum("bulletin_type_topCount"));
            mav.addObject("bean", bean);
            request.getSession().setAttribute("_my_exception", e);
            return mav;
        }
        super.rendJavaScript(response, "parent.parent.location.href=parent.parent.location;");
        return null;
    }

    public ModelAndView delete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Long> typeIds = CommonTools.parseStr2Ids(request.getParameter("id"));
        for (Long id : typeIds) {
            NewsType byId = newsTypeManager.getById(id);
            if (byId != null) {
                this.delRoleInfo(byId);
                String name = AppContext.currentUserName();
                appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.News_Type_Delete, name, byId.getTypeName());
            }
        }
        newsTypeManager.setTypeDeleted(typeIds);
        List<NewsData> newsList = new ArrayList<NewsData>();
        for (Long typeId : typeIds) {
            newsList = newsDataManager.getNewsByTypeId(typeId);
            for (NewsData newsData : newsList) {
                newsDataManager.delete(newsData.getId());
            }
        }
        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spaceType");
        return this.redirectModelAndView("/newsType.do?method=listMain&spaceType=" + spaceType + "&spaceId=" + spaceId);
    }

    /**
     * 取消管理员/审核员角色
     * 其它同类型（单位、集团）板块所有管理员中不包含此板块管理员的先删除增加
     */
    private void delRoleInfo(NewsType type) throws Exception {
        if (type == null) {
            return;
        }

        User user = AppContext.getCurrentUser();
        String roleName4Admin = "";
        String roleName4Auditor = "";
        List<NewsType> types = null;
        if (user.isGroupAdmin()) {
            roleName4Admin = OrgConstants.Role_NAME.GroupNewsAdmin.name();
            roleName4Auditor = OrgConstants.Role_NAME.GroupNewsAuditor.name();
            types = newsTypeManager.groupFindAll();
        } else {
            roleName4Admin = OrgConstants.Role_NAME.UnitNewsAdmin.name();
            roleName4Auditor = OrgConstants.Role_NAME.UnitNewsAuditor.name();
            types = newsTypeManager.findAll(user.getLoginAccount());
        }

        Set<Long> otherAdmins = new HashSet<Long>();
        Set<Long> otherAuditors = new HashSet<Long>();
        if (Strings.isNotEmpty(types)) {
            for (NewsType newsType : types) {
                if (!newsType.equals(type)) {
                    Set<NewsTypeManagers> newsTypeManagers = newsType.getNewsTypeManagers();
                    if (Strings.isNotEmpty(newsTypeManagers)) {
                        for (NewsTypeManagers newsTypeManager : newsTypeManagers) {
                            otherAdmins.add(newsTypeManager.getManagerId());
                        }
                    }
                    Long newsTypeAuditUser = newsType.getAuditUser();
                    if (newsTypeAuditUser != null && !newsTypeAuditUser.equals(0L)) {
                        otherAuditors.add(newsTypeAuditUser);
                    }
                }
            }
        }

        String adminEntityIds = "";
        String auditorEntityIds = "";
        Set<NewsTypeManagers> oldNewsTypeManagers = type.getNewsTypeManagers();
        Long oldNewsTypeAuditUser = type.getAuditUser();
        if (Strings.isNotEmpty(oldNewsTypeManagers)) {
            for (NewsTypeManagers newsTypeManager : oldNewsTypeManagers) {
                if (!otherAdmins.contains(newsTypeManager.getManagerId())) {
                    adminEntityIds += OrgConstants.ORGENT_TYPE.Member.name() + "|" + newsTypeManager.getManagerId() + ",";
                }
            }
        }

        if (oldNewsTypeAuditUser != null && !oldNewsTypeAuditUser.equals(0L)) {
            if (!otherAuditors.contains(oldNewsTypeAuditUser)) {
                auditorEntityIds += OrgConstants.ORGENT_TYPE.Member.name() + "|" + oldNewsTypeAuditUser + ",";
            }
        }

        if (Strings.isNotBlank(adminEntityIds)) {
            roleManager.delRole2Entity(roleName4Admin, AppContext.currentAccountId(), adminEntityIds);
        }
        if (Strings.isNotBlank(auditorEntityIds)) {
            roleManager.delRole2Entity(roleName4Auditor, AppContext.currentAccountId(), auditorEntityIds);
        }
    }

    public ModelAndView orderNewsType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        ModelAndView mav = new ModelAndView("news/admin/orderNewsType");
        String spaceId = request.getParameter("spaceId");
        String spaceType = request.getParameter("spaceType");
        int spaceTypeInt = "public_custom".equalsIgnoreCase(spaceType) ? SpaceType.public_custom.ordinal() : SpaceType.public_custom_group.ordinal();
        if (Strings.isNotBlank(spaceId)) {
            mav.addObject("typelist", newsTypeManager.findAllByCustomAccId(Long.parseLong(spaceId), spaceTypeInt, false));
        } else {
            mav.addObject("typelist", user.isGroupAdmin() ? newsTypeManager.groupFindAll() : newsTypeManager.findAll(user.getLoginAccount()));
        }
        return mav;
    }

    public ModelAndView saveOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
        newsTypeManager.updateNewsTypeOrder(request.getParameterValues("projects"));
        super.rendJavaScript(response, "parent.location.reload();");
        return null;
    }

    @CheckRoleAccess(roleTypes = { Role_NAME.NULL })
    public ModelAndView modifyTypeNew(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        User user = AppContext.getCurrentUser();

        String typeId = request.getParameter("typeId");
        String commentFlag = request.getParameter("commentPermit");
        String newDays = request.getParameter("newDays");
        String newTopNumber = request.getParameter("topNumber");
        String oldTopNumber = request.getParameter("oldTopNumber");

        NewsType newsType = new NewsType();
        if (Strings.isNotBlank(typeId)) {
            newsType = newsTypeManager.getById(Long.valueOf(typeId));
        }
        if (Strings.isNotBlank(commentFlag)) {
            newsType.setCommentPermit("1".equals(commentFlag) ? true : false);
        }
        if (Strings.isNotBlank(newDays)) {
            newsType.setTopCount(Byte.valueOf(newDays));
        }
        if (Strings.isNotBlank(newTopNumber)) {
        	newsType.setTopNumber(Byte.valueOf(newTopNumber));
            //处理公告板块置顶个数变化之后的情况，已置顶的该板块公告置顶数需同步调整
            this.newsDataManager.updateTopNumberOrder(oldTopNumber, newTopNumber, Long.valueOf(typeId));
        }
        //授权
        String authIssue = request.getParameter("authIssue");
        if (Strings.isBlank(authIssue)) {
            this.newsTypeManager.saveWriteByType(Long.valueOf(typeId), new String[0][0]);
            //对整个操作过程记录应用日志
            appLogManager.insertLog(user, AppLogAction.News_PostAuth_Update, user.getName(), newsType.getTypeName());
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
            
            List<NewsTypeManagers> oldWriter = this.newsTypeManager.findTypeWriters(newsType);
            if (CollectionUtils.isNotEmpty(oldWriter)) {
                for (NewsTypeManagers ntm : oldWriter) {
                    Set<V3xOrgMember> membersOld = orgManager.getMembersByTypeAndIds(ntm.getExt2()+"|"+ntm.getManagerId());
                    if (CollectionUtils.isNotEmpty(membersOld)) {
                        for (V3xOrgMember org:membersOld){
                            auth.remove(org.getId());
                        }
                    }
                }
            }

            userMessageManager.sendSystemMessage(MessageContent.get("news.accredit", newsType.getTypeName(), user.getName()), ApplicationCategoryEnum.news, user.getId(), MessageReceiver.getReceivers(newsType.getId(), auth, "", typeId, newsType.getId()));
            this.newsTypeManager.saveWriteByType(Long.valueOf(typeId), authInfoArray);

            //对整个操作记录应用日志
            appLogManager.insertLog(user, AppLogAction.News_PostAuth_Update, user.getName(), newsType.getTypeName());
        }
        newsType.setUpdateDate(new Date());
        newsType.setUpdateUser(user.getId());
        newsType.isNew();
        newsTypeManager.save(newsType, false);

        return super.refreshWindow("parent");
    }

}
