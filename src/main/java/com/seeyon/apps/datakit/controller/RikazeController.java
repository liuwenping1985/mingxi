package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.datakit.po.BulDataItem;
import com.seeyon.apps.datakit.po.NewsDataItem;
import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.apps.datakit.vo.RikazeAccountVo;
import com.seeyon.apps.datakit.vo.RikazeDeptVo;
import com.seeyon.apps.datakit.vo.RikazeMemberVo;
import com.seeyon.apps.doc.manager.KnowledgeFavoriteManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.login.auth.DefaultLoginAuthentication;
import com.seeyon.ctp.organization.bo.*;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.customize.manager.CustomizeManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.OperationControllable;
import com.seeyon.ctp.util.OperationCounter;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.bulletin.BulletinException;
import com.seeyon.v3x.bulletin.domain.BulBody;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.manager.BulDataManager;
import com.seeyon.v3x.bulletin.manager.BulReadManager;
import com.seeyon.v3x.bulletin.manager.BulTypeManager;
import com.seeyon.v3x.bulletin.util.BulletinUtils;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.news.NewsException;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.manager.NewsDataManager;
import com.seeyon.v3x.news.manager.NewsIssueManager;
import com.seeyon.v3x.news.manager.NewsReadManager;
import com.seeyon.v3x.util.CommonTools;
import org.apache.axis.utils.StringUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by liuwenping on 2018/5/31.
 */
public class RikazeController extends BaseController {
    private RikazeService rikazeService;
    private PendingManager pendingManager;

    public RikazeService getRikazeService() {
        return rikazeService;
    }

    public void setRikazeService(RikazeService rikazeService) {
        this.rikazeService = rikazeService;
    }


    public PendingManager getPendingManager() {
        return pendingManager;
    }

    public void setPendingManager(PendingManager pendingManager) {
        this.pendingManager = pendingManager;
    }

    public RikazeController() {

    }

    private CustomizeManager customizeManager;

    public CustomizeManager getCustomizeManager() {
        if (customizeManager == null) {
            customizeManager = (CustomizeManager) AppContext.getBean("customizeManager");
        }
        return customizeManager;
    }

    private SystemConfig systemConfig;

    private SystemConfig getSystemConfig() {
        if (systemConfig == null) {
            systemConfig = (SystemConfig) AppContext.getBean("systemConfig");
        }
        return systemConfig;
    }

    public String getAvatarImageUrl(Long memberId) {
        String contextPath = SystemEnvironment.getContextPath();
        return getAvatarImageUrl(memberId, contextPath);
    }

    public String getSystemSwitch(String name) {
        return getSystemConfig().get(name);
    }

    private String getAvatarImageUrl(Long memberId, String contextPath) {
        String imageSrc = contextPath + "/apps_res/v3xmain/images/personal/pic.gif";
        String isUseDefaultAvatar = getSystemSwitch("default_avatar");
        try {
            String fileName = getCustomizeManager().getCustomizeValue(memberId, "avatar");
            if (fileName != null && !Strings.equals("pic.gif", fileName)) {
                fileName = fileName.replaceAll(" on", " son");
                if (fileName.startsWith("fileId")) {
                    imageSrc = contextPath + "/fileUpload.do?method=showRTE&" + fileName + "&type=image";
                } else {
                    imageSrc = contextPath + "/apps_res/v3xmain/images/personal/" + fileName;
                }
            } else if (Strings.equals("enable", isUseDefaultAvatar)) {
                V3xOrgMember member = getOrgManager().getMemberById(memberId);
                if (member != null) {
                    Object property = member.getProperty("imageid");
                    if (property != null) {
                        String imageId = member.getProperty("imageid").toString();
                        if (Strings.isNotBlank(imageId)) {
                            imageSrc = contextPath + imageId;
                        }
                    }
                }
            }
        } catch (Exception var8) {
            var8.printStackTrace();
        }
        return imageSrc;
    }

    @NeedlessCheckLogin
    public ModelAndView getDepartmentListGroupByAccount(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        List<V3xOrgAccount> accountList = this.getOrgManager().getAllAccounts();
        Map<String, Object> data = new HashMap<String, Object>();
        List<RikazeAccountVo> dataList = new ArrayList<RikazeAccountVo>();
        if (accountList != null && accountList.size() > 0) {
            for (V3xOrgAccount account : accountList) {
                RikazeAccountVo accountVo = new RikazeAccountVo();
                accountVo.setAccountId(String.valueOf(account.getId()));
                accountVo.setV3xOrgAccount(account);
                List<V3xOrgDepartment> depts = this.getOrgManager().getAllDepartments(account.getId());
                List<RikazeDeptVo> deptVoList = new ArrayList<RikazeDeptVo>();
                for (V3xOrgDepartment department : depts) {
                    RikazeDeptVo vo = new RikazeDeptVo();
                    vo.setAccountId(accountVo.getAccountId());
                    vo.setDeptId(String.valueOf(department.getId()));
                    vo.setDeptName(department.getName());
                    vo.setV3xOrgDepartment(department);
                    deptVoList.add(vo);
                }
                accountVo.setDepts(deptVoList);
                dataList.add(accountVo);
            }
        }
        data.put("items", dataList);
        com.seeyon.ctp.common.taglibs.functions.Functions funs;
        DataKitSupporter.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getDepartmentMemberList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        Map<String, Object> data = new HashMap<String, Object>();
        String deptId = request.getParameter("deptId");
        if (deptId == null || "".equals(deptId)) {
            data.put("items", new ArrayList());
        } else {
            List<V3xOrgMember> list = this.getOrgManager().getAllMembersByDepartmentBO(Long.parseLong(deptId));
            List<RikazeMemberVo> dataList = new ArrayList<RikazeMemberVo>();

            for (V3xOrgMember member : list) {
                RikazeMemberVo vo = new RikazeMemberVo();
                vo.setDepartmentId(String.valueOf(member.getOrgDepartmentId()));
                vo.setMemberId(String.valueOf(member.getId()));
                vo.setMemberName(member.getName());
                vo.setV3xOrgMember(member);
                V3xOrgPost post = this.getOrgManager().getPostById(member.getOrgPostId());
                if (post != null) {
                    vo.setPostName(post.getName());
                } else {
                    vo.setPostName("");
                }
                vo.setAvtar(getAvatarImageUrl(member.getId()));
                dataList.add(vo);
            }
            data.put("items", dataList);
        }
        DataKitSupporter.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView checkLogin(HttpServletRequest request, HttpServletResponse response) {
        User user = AppContext.getCurrentUser();
        Map<String, String> data = new HashMap<String, String>();
        String userName = "no-body";
        if (user != null) {
            userName = user.getName();
        }
        data.put("user", userName);
        DataKitSupporter.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getNews(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, Object> data = new HashMap<String, Object>();
        try {
            List<NewsDataItem> newsDataList = DBAgent.find("from NewsDataItem");
            data.put("news", newsDataList);
            DataKitSupporter.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        } catch (Error e) {
            e.printStackTrace();
        }
        data.put("news", "error");
        return null;
    }




    @NeedlessCheckLogin
    public ModelAndView getBulData(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, Object> data = new HashMap<String, Object>();
        try {
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem where state=30 and typeId=1 order by createDate desc");
            data.put("buls", dataList);
            DataKitSupporter.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        } catch (Error e) {
            e.printStackTrace();
        }
        data.put("buls", "error");
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView loadData(HttpServletRequest request, HttpServletResponse response){
        Map<String, Object> data = new HashMap<String, Object>();
        String type = request.getParameter("type");
        if("tzgg".equals(type)){
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem where state=30 and typeId=1 order by createDate desc");
            data.put("data", dataList);
            DataKitSupporter.responseJSON(data, response);
            return null;
        }
        if("xxjb".equals(type)){
            List<NewsDataItem> newsDataList = DBAgent.find("from NewsDataItem where state=30 and typeId=2 order by createDate desc");
            data.put("data", newsDataList);
            DataKitSupporter.responseJSON(data, response);
            return null;
        }
        if("gzdt".equals(type)){
            List<NewsDataItem> newsDataList = DBAgent.find("from NewsDataItem where state=30 and typeId=1 order by createDate desc");
            data.put("data", newsDataList);
            DataKitSupporter.responseJSON(data, response);
            return null;
        }

        if("ywzn".equals(type)){
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem where state=30 and typeId=-4695372691792968435 order by createDate desc");
            data.put("data", dataList);
            DataKitSupporter.responseJSON(data, response);
            return null;

        }
        if("xxjl".equals(type)){

            List<BulDataItem> dataList = DBAgent.find("from BulDataItem where state=30 and typeId=-4083198690925721448 order by createDate desc");
            data.put("data", dataList);
            DataKitSupporter.responseJSON(data, response);
            return null;
        }
        if("xzzx".equals(type)){
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem where state=30 and typeId=-1365569722735310114 order by createDate desc");
            data.put("data", dataList);
            DataKitSupporter.responseJSON(data, response);
            return null;

        }




        return null;
    }

    public ModelAndView getBanwenCount(HttpServletRequest request, HttpServletResponse response) {
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        String fragementId = request.getParameter("fragmentId");
        if (StringUtils.isEmpty(fragementId)) {
            fragementId = "-7771288622128478783";
        }
        String ord = "0";
        Long fgId = Long.parseLong(fragementId);
        int count = pendingManager.getPendingCount(memberId, fgId, ord);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("count", count);
        DataKitSupporter.responseJSON(data, response);
        return null;
    }

    public ModelAndView getYuewenCount(HttpServletRequest request, HttpServletResponse response) {
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        String fragementId = request.getParameter("fragmentId");
        if (StringUtils.isEmpty(fragementId)) {
            fragementId = "-7771288622128478783";
        }
        String ord = "1";
        Long fgId = Long.parseLong(fragementId);
        int count = pendingManager.getPendingCount(memberId, fgId, ord);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("count", count);
      
        DataKitSupporter.responseJSON(data, response);
        return null;
    }
    public ModelAndView getPeixunCount(HttpServletRequest request, HttpServletResponse response) {
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        String fragementId = request.getParameter("fragmentId");
        if (StringUtils.isEmpty(fragementId)) {
            fragementId = "-7771288622128478783";
        }
        String ord = "0";
        Long fgId = Long.parseLong(fragementId);
        int count = pendingManager.getPendingCount(memberId, fgId, ord);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("count", count);
        DataKitSupporter.responseJSON(data, response);
        return null;
    }
    public ModelAndView getKaoqinCount(HttpServletRequest request, HttpServletResponse response) {
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        String fragementId = request.getParameter("fragmentId");
        if (StringUtils.isEmpty(fragementId)) {
            fragementId = "-7771288622128478783";
        }
        String ord = "0";
        Long fgId = Long.parseLong(fragementId);
        int count = pendingManager.getPendingCount(memberId, fgId, ord);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("count", count);
        DataKitSupporter.responseJSON(data, response);
        return null;
    }
    public ModelAndView getUserLevelName(HttpServletRequest request, HttpServletResponse response) {
        User user = AppContext.getCurrentUser();
        Map<String,Object> data = new HashMap<String, Object>();
        try {
           V3xOrgLevel level =  this.getOrgManager().getLevelById(user.getLevelId());
            data.put("level",level);
        } catch (BusinessException e) {
            data.put("level",null);
            e.printStackTrace();
        }

        DataKitSupporter.responseJSON(data, response);
        return null;
    }

    private NewsDataManager newsDataManager;

    public NewsDataManager getNewsDataManager() {
        if (newsDataManager != null) {
            return newsDataManager;
        }
        newsDataManager = (NewsDataManager) AppContext.getBean("newsDataManager");
        return newsDataManager;
    }

    private SpaceManager spaceManager;

    public SpaceManager getSpaceManager() {
        if (spaceManager != null) {
            return spaceManager;
        }
        spaceManager = (SpaceManager) AppContext.getBean("spaceManager");
        return spaceManager;
    }

    private OrgManager orgManager;

    public OrgManager getOrgManager() {
        if (orgManager != null) {
            return orgManager;
        }
        orgManager = (OrgManager) AppContext.getBean("orgManager");
        return orgManager;
    }

    private NewsReadManager newsReadManager;

    public NewsReadManager getNewsReadManager() {
        if (newsReadManager != null) {
            return newsReadManager;
        }
        newsReadManager = (NewsReadManager) AppContext.getBean("newsReadManager");
        return newsReadManager;
    }

    private AttachmentManager attachmentManager;

    private AttachmentManager getAttachmentManager() {
        if (attachmentManager != null) {
            return attachmentManager;
        }
        attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
        return attachmentManager;
    }

    private KnowledgeFavoriteManager knowledgeFavoriteManager;

    private KnowledgeFavoriteManager getKnowledgeFavoriteManager() {
        if (knowledgeFavoriteManager != null) {
            return knowledgeFavoriteManager;
        }
        knowledgeFavoriteManager = (KnowledgeFavoriteManager) AppContext.getBean("knowledgeFavoriteManager");
        return knowledgeFavoriteManager;
    }

    private ColManager colManager;

    private ColManager getColManager() {
        if (colManager != null) {
            return colManager;
        }
        colManager = (ColManager) AppContext.getBean("colManager");
        return colManager;
    }

    private MainbodyManager mainbodyManager;

    private MainbodyManager getCtpMainbodyManager() {
        if (mainbodyManager != null) {
            return mainbodyManager;
        }
        mainbodyManager = (MainbodyManager) AppContext.getBean("ctpMainbodyManager");
        return mainbodyManager;
    }

    private NewsIssueManager newsIssueManager;

    private NewsIssueManager getNewsIssueManager() {
        if (newsIssueManager != null) {
            return newsIssueManager;
        }
        newsIssueManager = (NewsIssueManager) AppContext.getBean("newsIssueManager");
        return newsIssueManager;
    }

    private BulDataManager bulDataManager2;

    private BulDataManager getBulDataManager() {
        if (bulDataManager2 != null) {
            return bulDataManager2;
        }
        bulDataManager2 = (BulDataManager) AppContext.getBean("bulDataManager");

        return bulDataManager2;
    }

    private BulTypeManager getBulTypeManager() {
        BulTypeManager bulTypeManager = (BulTypeManager) AppContext.getBean("bulTypeManager");
        return bulTypeManager;
    }

    private BulletinUtils getBulletinUtils() {
        BulletinUtils bulletinUtils = (BulletinUtils) AppContext.getBean("bulletinUtils");
        return bulletinUtils;
    }

    @NeedlessCheckLogin
    public ModelAndView bulDataView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("id");
        String spaceId = request.getParameter("spaceId");
        if (org.apache.commons.lang.StringUtils.isBlank(idStr)) {
            throw new BulletinException("bulletin.not_exists");
        } else {
            long dataId = Long.valueOf(idStr);
            BulData bean = (BulData) this.getBulDataManager().getBulDataCache().getDataCache().get(dataId);
            boolean hasCache = false;
            if (bean == null) {
                bean = this.getBulDataManager().getById(Long.valueOf(idStr));
            } else {
                hasCache = true;
            }
            String fromPigeonhole = request.getParameter("fromPigeonhole");
            ModelAndView mav = new ModelAndView("bulletin/user/data_view");
           if (bean == null) {
                return mav.addObject("dataExist", Boolean.FALSE);
            } else {
                mav.addObject("dataExist", Boolean.TRUE);
                if (Strings.isNotBlank(spaceId)) {
                    mav.addObject("customSpaceName", this.getSpaceManager().getSpaceFix(Long.parseLong(spaceId)).getSpacename());
                }

                // User user = AppContext.getCurrentUser();

                if (!"true".equals(fromPigeonhole)) {
                    this.recordBulRead(dataId, bean, hasCache);
                }

                BulBody body = this.getBulDataManager().getBody(bean.getId());
                bean.setContent(body.getContent());
                bean.setContentName(body.getContentName());
                String content;
                if ("FORM".equals(bean.getDataFormat())) {
                    content = this.convertContent(bean.getContent());
                    if (content != null) {
                        bean.setDataFormat("HTML");
                        bean.setContent(content);
                    }
                }

                if ("HTML".equals(bean.getDataFormat())) {
                    content = this.convertContentV(bean.getContent());
                    if (content != null) {
                        bean.setContent(content);
                    }
                }

                Long userId = -4709450004260764208L;
                boolean isManager = true;


                mav.addObject("isManager", isManager);
                this.getBulletinUtils().initData(bean);
                mav.addObject("bul_title", Strings.toText(bean.getTitle()));
                mav.addObject("bean", bean);
                if (bean.getAttachmentsFlag()) {
                    List<Attachment> attachments = this.getAttachmentManager().getByReference(bean.getId(), bean.getId());
                    mav.addObject("attachments", attachments);
                } else {
                    mav.addObject("attachments", new ArrayList());
                }

                String collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
                if ("true".equals(collectFlag)) {
                    List<Map<Long, Long>> collectMap = this.getKnowledgeFavoriteManager().getFavoriteSource(CommonTools.newArrayList(new Long[]{bean.getId()}), userId);
                    if (!collectMap.isEmpty()) {
                        mav.addObject("isCollect", true);
                        mav.addObject("collectDocId", ((Map) collectMap.get(0)).get("id"));
                    }
                }

                mav.addObject("docCollectFlag", collectFlag);
                AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.bulletin, String.valueOf(bean.getId()), userId);
                return mav.addObject("bulStyle", bean.getType().getExt1());

            }
        }
    }
    private Map<String, String> getParameterMap(HttpServletRequest request) {
        Map<String, String> ps = new HashMap();
        Enumeration params = request.getParameterNames();

        while(params.hasMoreElements()) {
            String name = (String)params.nextElement();
            if (!"method".equalsIgnoreCase(name)) {
                String value = request.getParameter(name);
                ps.put(name, value);
            }
        }

        return ps;
    }
    private String htmlSuffix="htm|html|shtm|shtml|xhtml|hta|htc|mht|wml|xml|xslt|xsl|jsp|asp|php|css|js|sql";
    private static Map<String, String> RTE_type;
    private static OperationControllable downloadCounter;
    private static Integer maxDownloadConnections = SystemProperties.getInstance().getIntegerProperty("fileDowload.maxConnections", 65535);
    static {
        downloadCounter = new OperationCounter((long)maxDownloadConnections);
        RTE_type = new HashMap();
        RTE_type.put("image", "image/jpeg");
        RTE_type.put("flash", "application/x-shockwave-flash");
    }
    @NeedlessCheckLogin
    public ModelAndView download(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView m = new ModelAndView("ctp/common/fileUpload/download");

            Map<String, String> ps = this.getParameterMap(request);
            m.addObject("ps", ps);
            String filename = request.getParameter("filename");
            String suffix = FilenameUtils.getExtension(filename).toLowerCase();
            String from = request.getParameter("from");
            if (from != null && "a8geniues".equals(from)) {
                m.addObject("isHTML", Pattern.matches(this.htmlSuffix, suffix));
            } else if (Pattern.matches(this.htmlSuffix, suffix) && !"mobile".equals(from)) {
                m.addObject("isHTML", true);
            }
            return m;

    }

    private BulReadManager bulReadManager;

    private BulReadManager getBulReadManager() {
        if (bulReadManager != null) {
            return bulReadManager;
        }
        bulReadManager = (BulReadManager) AppContext.getBean("bulReadManager");
        return bulReadManager;
    }

    public boolean checkScope(BulData bulData) throws BusinessException {
        String scopeId = bulData.getPublishScope();
        Long createId = bulData.getCreateUser();
        Long publishId = bulData.getPublishUserId();
        Long auditId = bulData.getAuditUserId();
        Long userId = -4709450004260764208L;
        if (bulData.getType().getSpaceType() == 1 || bulData.getType().getSpaceType() == 4) {
            List<Long> managerSpaces = this.getSpaceManager().getCanManagerSpace(userId);
            if (CollectionUtils.isNotEmpty(managerSpaces) && managerSpaces.contains(bulData.getType().getId())) {
                return true;
            }
        }

        boolean isManager = this.getBulTypeManager().isManagerOfType(bulData.getTypeId(), userId);
        if (!userId.equals(createId) && !userId.equals(publishId) && !userId.equals(auditId) && !isManager) {
            List<Long> scopeIds = CommonTools.parseTypeAndIdStr2Ids(scopeId);
            List<Long> ids = CommonTools.getUserDomainIds(userId, this.getOrgManager());
            List<Long> intersectIds = CommonTools.getIntersection(scopeIds, ids);
            return !Strings.isEmpty(intersectIds);
        } else {
            return true;
        }
    }

    private void recordBulRead(long dataId, BulData bean, boolean hasCache) {
        Long userId = -4709450004260764208L;
        Long accountId = 670869647114347L;
        this.getBulReadManager().setReadState(bean, userId);
        if (hasCache) {
            this.getBulDataManager().clickCache(dataId, userId);
        } else {
            BulBody body = this.getBulDataManager().getBody(bean.getId());
            bean.setContent(body.getContent());
            bean.setContentName(body.getContentName());
            int readCount = bean.getReadCount() == null ? 0 : bean.getReadCount();
            bean.setReadCount(readCount + 1);
            this.getBulDataManager().syncCache(bean, readCount + 1);
        }

    }

    private String convertContentV(String content) throws BusinessException {
        if (Strings.isBlank(content)) {
            return null;
        } else {
            StringBuffer sb = new StringBuffer();
            Pattern pDiv = Pattern.compile("method=download&fileId=(.+?)&v=fromForm");
            Matcher matcherDiv = pDiv.matcher(content);

            while (matcherDiv.find()) {
                String fileId = matcherDiv.group(1);
                String replace = "method=download&fileId=" + fileId + "&v=" + SecurityHelper.digest(new Object[]{fileId});
                matcherDiv.appendReplacement(sb, replace.toString());
            }

            matcherDiv.appendTail(sb);
            return sb.toString();
        }
    }

    //spaceManager
    @NeedlessCheckLogin
    public ModelAndView userView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // User user = AppContext.getCurrentUser();
        try {
            Long userId = -4709450004260764208L;
            Long accountId = 670869647114347L;
            String idStr = request.getParameter("id");
            String spaceId = request.getParameter("spaceId");
            boolean fromPigeonhole = "true".equals(request.getParameter("fromPigeonhole"));
            if (org.apache.commons.lang.StringUtils.isBlank(idStr)) {
                NewsException e = new NewsException("news_not_exists");
                request.getSession().setAttribute("_my_exception", e);
                return new ModelAndView("news/error");
            } else {
                long dataId = Long.valueOf(idStr);
                NewsData bean = (NewsData) this.getNewsDataManager().getNewsData().get(dataId);
                boolean hasCache = false;
                if (bean == null) {
                    bean = this.getNewsDataManager().getById(Long.valueOf(idStr), userId);
                } else {
                    hasCache = true;
                }

                ModelAndView mav = new ModelAndView("news/user/data_view");
                if (Strings.isNotBlank(spaceId)) {
                    mav.addObject("customSpaceName", this.getSpaceManager().getSpaceFix(Long.parseLong(spaceId)).getSpacename());
                }

                boolean flag = false;
                if (bean != null && !bean.isDeletedFlag() && (bean.getState() == 30 || bean.getState() == 100) && (bean.getState() != 100 || fromPigeonhole)) {
                    NewsType type = bean.getType();
                    if (type == null || !type.isUsedFlag()) {
                        flag = true;
                    }
                } else {
                    flag = true;
                }

                if (!bean.getType().getOutterPermit()) {
                    flag = true;
                }

                if (flag && !fromPigeonhole) {
                    if ("1".equals(request.getParameter("isCollCube"))) {
                        super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.news.resources.i18n.NewsResource", "new.validate.delete", new Object[0]) + "');window.close();window.parentDialogObj.url.closeParam.handler();");
                        return null;
                    } else {
                        return mav.addObject("dataExist", Boolean.FALSE);
                    }
                } else {
                    mav.addObject("dataExist", Boolean.TRUE);

                    Map<Long, List<MemberPost>> posts = this.getOrgManager().getConcurentPostsByMemberId(bean.getAccountId(), userId);
                    if (fromPigeonhole || bean.getType().getSpaceType() != Constants.SpaceType.corporation.ordinal() || accountId.toString().equals(bean.getAccountId().toString()) || posts != null && !posts.isEmpty()) {
                        if (!fromPigeonhole) {
                            if (hasCache) {
                                this.getNewsReadManager().setReadState(bean, userId);
                                this.getNewsDataManager().clickCache(dataId, userId);
                            } else {
                                this.getNewsReadManager().setReadState(bean, userId);
                                int readCount = bean.getReadCount() == null ? 0 : bean.getReadCount();
                                bean.setReadCount(readCount + 1);


                                this.getNewsDataManager().updateDirect(bean);
                                bean.setContent(this.getNewsDataManager().getBody(bean.getId()).getContent());
                                this.getNewsDataManager().syncCache(bean, bean.getReadCount() == null ? 0 : bean.getReadCount());
                            }
                        } else if (!hasCache) {
                            bean.setContent(this.getNewsDataManager().getBody(bean.getId()).getContent());
                        }

                        String collectFlag;
                        if ("FORM".equals(bean.getDataFormat())) {
                            collectFlag = this.convertContent(bean.getContent());
                            if (collectFlag != null) {
                                bean.setDataFormat("HTML");
                                bean.setContent(collectFlag);
                            }
                        }

                        this.getNewsDataManager().initData(bean);
                        mav.addObject("bean", bean);
                        if (bean.getAttachmentsFlag()) {
                            List<Attachment> attachments = this.getAttachmentManager().getByReference(bean.getId(), bean.getId());
                            mav.addObject("attachments", attachments);
                        } else {
                            mav.addObject("attachments", new ArrayList());
                        }

                        collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
                        if ("true".equals(collectFlag)) {
                            List<Map<Long, Long>> collectMap = this.getKnowledgeFavoriteManager().getFavoriteSource(CommonTools.newArrayList(new Long[]{bean.getId()}), userId);
                            if (!collectMap.isEmpty()) {
                                mav.addObject("isCollect", Boolean.TRUE);
                                mav.addObject("collectDocId", ((Map) collectMap.get(0)).get("id"));
                            }
                        }

                        AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.news, String.valueOf(bean.getId()), AppContext.currentUserId());
                        return mav.addObject("docCollectFlag", collectFlag);
                    } else {
                        super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.news.resources.i18n.NewsResource", "news.user.notAuthority", new Object[0]) + "');window.close();");
                        return null;
                    }

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private String convertContent(String content) throws BusinessException {
        int xslStart = content.indexOf("&&&&&&&  xsl_start  &&&&&&&&");
        int dataStart = content.indexOf("&&&&&&&&  data_start  &&&&&&&&");
        int inputStart = content.indexOf("&&&&&&&&  input_start  &&&&&&&&");
        if (xslStart != -1 && dataStart != -1 && inputStart != -1) {
            String xsl = content.substring(xslStart + 28, dataStart);
            String data = content.substring(dataStart + 30, inputStart);
            String formId = null;
            Pattern pAppId = Pattern.compile("appId=([-]{0,1}\\d+)");

            for (Matcher matcherAppId = pAppId.matcher(xsl); matcherAppId.find(); formId = matcherAppId.group(1)) {
                ;
            }

            String viewId = null;
            Pattern pFormId = Pattern.compile("formId=([-]{0,1}\\d+)");

            for (Matcher matcherFormId = pFormId.matcher(xsl); matcherFormId.find(); viewId = matcherFormId.group(1)) {
                ;
            }

            String recordid = null;
            Pattern pRecordid = Pattern.compile("recordid=\\\\\"([-]{0,1}\\d+?)\\\\\"");

            for (Matcher matcherRecordid = pRecordid.matcher(data); matcherRecordid.find(); recordid = matcherRecordid.group(1)) {
                ;
            }

            if (recordid != null) {
                ColSummary summary = this.getColManager().getColSummaryByFormRecordId(Long.parseLong(recordid));
                List<CtpContentAll> contentList = this.getCtpMainbodyManager().getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
                if (Strings.isNotEmpty(contentList)) {
                    CtpContentAll body = (CtpContentAll) contentList.get(0);
                    String htmlContent = MainbodyService.getInstance().getContentHTML(body.getModuleType(), body.getModuleId());
                    htmlContent = this.getNewsIssueManager().replaceFileHtml("fileupload", htmlContent);
                    htmlContent = this.getNewsIssueManager().replaceFileHtml("assdoc", htmlContent);
                    return htmlContent;
                }
            }

            return null;
        } else {
            return null;
        }
    }


}
