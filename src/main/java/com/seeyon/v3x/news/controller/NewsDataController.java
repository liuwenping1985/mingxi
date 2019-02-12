package com.seeyon.v3x.news.controller;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.agent.utils.AgentUtil;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.doc.bo.DocResourceBO;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.news.event.NewsAddEvent;
import com.seeyon.apps.show.api.ShowApi;
import com.seeyon.apps.show.bo.ShowbarInfoBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.affair.constants.TrackEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.contentTemplate.domain.ContentTemplate;
import com.seeyon.v3x.contentTemplate.manager.ContentTemplateManager;
import com.seeyon.v3x.news.domain.NewsBody;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsReply;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.domain.NewsTypeManagers;
import com.seeyon.v3x.news.manager.NewsDataManager;
import com.seeyon.v3x.news.manager.NewsIssueManager;
import com.seeyon.v3x.news.manager.NewsReadManager;
import com.seeyon.v3x.news.manager.NewsReplyManager;
import com.seeyon.v3x.news.manager.NewsTypeManager;
import com.seeyon.v3x.news.util.Constants;
import com.seeyon.v3x.news.util.NewsDataLock;
import com.seeyon.v3x.news.util.NewsDataLockAction;
import com.seeyon.v3x.news.util.NewsUtils;
import com.seeyon.v3x.news.vo.NewsDataVO;
import com.seeyon.v3x.news.vo.NewsReplyVO;
import com.seeyon.v3x.news.vo.NewsTypeModel;

public class NewsDataController extends BaseController {

    private static final Log       log = LogFactory.getLog(NewsDataController.class);
    private NewsDataManager        newsDataManager;
    private NewsReadManager        newsReadManager;
    private NewsReplyManager       newsReplyManager;
    private AttachmentManager      attachmentManager;
    private IndexManager           indexManager;
    private AffairManager          affairManager;
    private AppLogManager          appLogManager;
    private UserMessageManager     userMessageManager;
    private NewsTypeManager        newsTypeManager;
    private OrgManager             orgManager;
    private ContentTemplateManager contentTemplateManager;
    private DocApi                 docApi;
    private SpaceManager           spaceManager;
    private ShowApi                showApi;
    private NewsUtils              newsUtils;
    private FileToExcelManager     fileToExcelManager;
    private CollaborationApi       collaborationApi;
    private MainbodyManager        ctpMainbodyManager;
    private NewsIssueManager       newsIssueManager;

    public void setNewsDataManager(NewsDataManager newsDataManager) {
        this.newsDataManager = newsDataManager;
    }

    public void setNewsReadManager(NewsReadManager newsReadManager) {
        this.newsReadManager = newsReadManager;
    }

    public void setNewsReplyManager(NewsReplyManager newsReplyManager) {
        this.newsReplyManager = newsReplyManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
        this.userMessageManager = userMessageManager;
    }

    public void setNewsTypeManager(NewsTypeManager newsTypeManager) {
        this.newsTypeManager = newsTypeManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setContentTemplateManager(ContentTemplateManager contentTemplateManager) {
        this.contentTemplateManager = contentTemplateManager;
    }

    public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public void setShowApi(ShowApi showApi) {
        this.showApi = showApi;
    }

    public void setNewsUtils(NewsUtils newsUtils) {
        this.newsUtils = newsUtils;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

    public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
        this.ctpMainbodyManager = ctpMainbodyManager;
    }

    public void setNewsIssueManager(NewsIssueManager newsIssueManager) {
        this.newsIssueManager = newsIssueManager;
    }

    public boolean check(Long spaceId, Long auditId) throws BusinessException {
        boolean flag = true;
        List<Object[]> entityObj = spaceManager.getSecuityOfSpace(spaceId);
        String scopeStr = "";
        if (Strings.isNotEmpty(entityObj)) {
            for (Object[] objects : entityObj) {
                scopeStr += objects[0] + "|" + objects[1] + ",";
            }
        }
        if (Strings.isNotBlank(scopeStr)) {
            scopeStr = scopeStr.substring(0, scopeStr.length() - 1);
        }
        Set<V3xOrgMember> members = orgManager.getMembersByTypeAndIds(scopeStr);
        Set<Long> entityIds = new HashSet<Long>();
        for (V3xOrgMember org : members) {
            entityIds.add(org.getId());
        }
        if (entityIds.contains(auditId)) {
            flag = false;
        }
        return flag;
    }

    /**
     * 为以下几种情况增加待办事项：
     * 1.新建新闻，发送待审核，增加一条对应的待办事项记录；
     * 2.已发送的新闻，未审核之前修改，再行发送，增加一条待审核记录，同时删除修改之前已有的待办事项记录；
     * 3.已审核且不通过的新闻，修改后再次发送待审核，增加一条对应的待办事项记录。
     * 抽取成为单独方法，便于单点维护 by Meng Yang at 2009-07-15
     * @param beanType  新闻板块
     * @param bean		新闻
     * @throws BusinessException 
     * @throws BusinessException 
     */
    public void addPendingAffair(NewsType beanType, NewsData bean) throws BusinessException {
        CtpAffair affair = new CtpAffair();
        affair.setIdIfNew();
        affair.setTrack(TrackEnum.no.ordinal());
        affair.setDelete(false);
        // 利用 subjectId 存储空间类型，将来用于进入不同的页面
        affair.setSubObjectId(Long.valueOf(beanType.getSpaceType().toString()));
        affair.setMemberId(beanType.getAuditUser());
        affair.setState(StateEnum.col_pending.key());
        affair.setSubState(SubStateEnum.col_pending_unRead.key());
        affair.setSenderId(bean.getCreateUser());
        affair.setSubject(bean.getTitle());
        affair.setObjectId(bean.getId());
        affair.setApp(ApplicationCategoryEnum.news.key());
        affair.setSubApp(ApplicationSubCategoryEnum.news_audit.key());
        affair.setCreateDate(new Timestamp(bean.getCreateDate().getTime()));
        affair.setReceiveTime((new Timestamp(System.currentTimeMillis())));
        V3xOrgMember member = orgManager.getMemberById(bean.getCreateUser());
        if (member != null) {
            affair.setSenderId(member.getId());
        }
        AffairUtil.setHasAttachments(affair, bean.getAttachmentsFlag());

        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceType, beanType.getSpaceType());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceId, beanType.getAccountId());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.typeId, beanType.getId());

        affairManager.save(affair);
    }
    //客开 start 废弃
    public void addPendingAffair2(NewsType beanType, NewsData bean) throws BusinessException {
      CtpAffair affair = new CtpAffair();
      affair.setIdIfNew();
      affair.setTrack(TrackEnum.no.ordinal());
      affair.setDelete(false);
      // 利用 subjectId 存储空间类型，将来用于进入不同的页面
      affair.setSubObjectId(Long.valueOf(beanType.getSpaceType().toString()));
      affair.setMemberId(beanType.getTypesettingStaff());
      affair.setState(StateEnum.col_pending.key());
      affair.setSubState(SubStateEnum.col_pending_unRead.key());
      affair.setSenderId(bean.getCreateUser());
      affair.setSubject(bean.getTitle());
      affair.setObjectId(bean.getId());
      affair.setApp(ApplicationCategoryEnum.news.key());
      affair.setSubApp(ApplicationSubCategoryEnum.news_audit.key());
      affair.setCreateDate(new Timestamp(bean.getCreateDate().getTime()));
      affair.setReceiveTime((new Timestamp(System.currentTimeMillis())));
      V3xOrgMember member = orgManager.getMemberById(bean.getCreateUser());
      if (member != null) {
        affair.setSenderId(member.getId());
      }
      AffairUtil.setHasAttachments(affair, bean.getAttachmentsFlag());

      AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceType, beanType.getSpaceType());
      AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceId, beanType.getAccountId());
      AffairUtil.addExtProperty(affair, AffairExtPropEnums.typeId, beanType.getId());

      affairManager.save(affair);
    }
    //客开 end

    private final Object readCountLock = new Object();

    private String convertContent(String content) throws BusinessException {
        int xslStart = content.indexOf("&&&&&&&  xsl_start  &&&&&&&&");
        int dataStart = content.indexOf("&&&&&&&&  data_start  &&&&&&&&");
        int inputStart = content.indexOf("&&&&&&&&  input_start  &&&&&&&&");
        if (xslStart == -1 || dataStart == -1 || inputStart == -1) {
            return null;
        }

        String xsl = content.substring(xslStart + 28, dataStart);
        String data = content.substring(dataStart + 30, inputStart);

        String formId = null;
        Pattern pAppId = Pattern.compile("appId=([-]{0,1}\\d+)");
        Matcher matcherAppId = pAppId.matcher(xsl);
        while (matcherAppId.find()) {
            formId = matcherAppId.group(1);
        }

        String viewId = null;
        Pattern pFormId = Pattern.compile("formId=([-]{0,1}\\d+)");
        Matcher matcherFormId = pFormId.matcher(xsl);
        while (matcherFormId.find()) {
            viewId = matcherFormId.group(1);
        }

        String recordid = null;
        Pattern pRecordid = Pattern.compile("recordid=\\\\\"([-]{0,1}\\d+?)\\\\\"");
        Matcher matcherRecordid = pRecordid.matcher(data);
        while (matcherRecordid.find()) {
            recordid = matcherRecordid.group(1);
        }

        if (recordid != null) {
            ColSummary summary = collaborationApi.getColSummaryByFormRecordId(Long.parseLong(recordid));
            List<CtpContentAll> contentList = ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
            if (Strings.isNotEmpty(contentList)) {
                CtpContentAll body = contentList.get(0);
                String htmlContent = MainbodyService.getInstance().getContentHTML(body.getModuleType(), body.getModuleId());
                //替换表单正文中的附件、关联文档（新框架和老框架不兼容）
                htmlContent = newsIssueManager.replaceFileHtml("fileupload", htmlContent);
                htmlContent = newsIssueManager.replaceFileHtml("assdoc", htmlContent);
                return htmlContent;
            }
        }

        return null;
    }

    /**
     * 新闻归档
     * 
     * @author lucx
     * 
     */
    public ModelAndView pigeonhole(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String ids = request.getParameter("id");
        User user = AppContext.getCurrentUser();
        String userName = user.getName();
        String[] archiveIds = request.getParameterValues("archiveId");
        if (StringUtils.isNotBlank(ids)) {
            String[] idA = ids.split(",");
            List<Long> idList = new ArrayList<Long>();
            for (int i = 0; i < idA.length; i++) {
                if (StringUtils.isNotBlank(idA[i])) {
                    Long _archiveId = Long.valueOf(archiveIds[i]);
                    DocResourceBO res = docApi.getDocResource(_archiveId);
                    //归档记录应用日志 added by Meng Yang at 2009-08-20
                    if (res != null) {
                        String folderName = docApi.getDocResourceName(res.getParentFrId());
                        appLogManager.insertLog(user, AppLogAction.News_Pigeonhole, userName, res.getFrName(), folderName);
                    }
                    idList.add(Long.valueOf(idA[i]));
                    // 更新缓存中新闻的状态为归档,防止通过系统提示信息查看归档后的新闻
                    Long longID = Long.valueOf(idA[i]);
                    NewsData bean = newsDataManager.getNewsData().get(longID);
                    if (bean != null) {
                        bean.setState(Constants.DATA_STATE_ALREADY_PIGEONHOLE);
                        newsDataManager.getNewsData().save(longID, bean, bean.getPublishDate().getTime(), (bean.getReadCount() == null ? 0 : bean.getReadCount()));
                    }
                }
            }
            this.newsDataManager.pigeonhole(idList);

        }
        super.rendJavaScript(response, "parent.window.location.reload();");
        return null;
    }

    /**
     * portal显示板块列表
     */
    public ModelAndView showDesignated(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("news/user/showDesignated");
        User user = AppContext.getCurrentUser();
        List<NewsType> typeList = null;
        String group = request.getParameter("group");
        String textfield = request.getParameter("textfield");

        if (Strings.isNotBlank(group)) {
            typeList = newsTypeManager.groupFindAll();
        } else {
            typeList = newsTypeManager.findAll(user.getLoginAccount());
        }

        List<NewsType> resultList = new ArrayList<NewsType>();
        if (Strings.isNotBlank(textfield)) {
            for (NewsType type : typeList) {
                if (type.getTypeName().contains(textfield)) {
                    resultList.add(type);
                }
            }
        } else {
            resultList = typeList;
        }

        mav.addObject("typeList", resultList);
        return mav;
    }

    public ModelAndView uploadNewsImage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        String imageId = request.getParameter("imageId");
        String type = request.getParameter("type");

        NewsData newsData = newsDataManager.getById(NumberUtils.toLong(id));
        //newsData.setContent(newsDataManager.getBody(newsData.getId()).getContent());
        if (newsData != null) {
            newsData.setImageId(NumberUtils.toLong(imageId));
            int imageOrFocus = NumberUtils.toInt(type);
            if (imageOrFocus == Constants.ImageNews) {
                newsData.setImageNews(true);
            } else {
                newsData.setFocusNews(true);
            }
        }

        attachmentManager.deleteByReference(newsData.getId(), newsData.getId());
        attachmentManager.create(ApplicationCategoryEnum.news, newsData.getId(), newsData.getId(), request);

        newsDataManager.updateDirect(newsData);

        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");
        out.println("<script type='text/javascript'>");
        out.println("alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.upload.success") + "');");
        out.println("parent.window.location.reload();");
        out.println("</script>");
        return null;
    }

    /**
     * 根据可操作列表展示
     * 
     * */
    public ModelAndView listType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("news/manager/moveTo");
        String ids = request.getParameter("ids");

        String typeIdsStr = request.getParameter("typeIds");
        List<NewsType> newsTypeList = new ArrayList<NewsType>();
        //原页面
        if (Strings.isNotEmpty(typeIdsStr)) {
            String[] str = typeIdsStr.split(",");
            // 类型列表
            NewsType type = null;
            for (int i = 0; i < str.length; i++) {
                type = newsTypeManager.getById(Long.valueOf(str[i]));
                if (type != null) {
                    newsTypeList.add(type);
                }
            }
        } else {
            String typeId = request.getParameter("typeId");
            User user = AppContext.getCurrentUser();
            NewsType newsType = newsTypeManager.getById(Long.valueOf(typeId));
            newsTypeList = getCanAdminTypes(user.getId(), newsType);
        }
        Collections.sort(newsTypeList);
        mav.addObject("typeList", newsTypeList);
        mav.addObject("ids", ids);

        return mav;
    }

    /**
     * 移动到新分类方法
     * 
     * */
    public ModelAndView moveToType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("ids");
        String typeId = request.getParameter("typeId");
        NewsData bean = null;
        if (StringUtils.isBlank(idStr)) {
            throw new BusinessException("bbs_not_exists");
        } else {
            String[] ids = idStr.split(",");
            Map<String, Object> summ = new HashMap<String, Object>();
            for (String id : ids) {
                if (StringUtils.isNotBlank(id)) {
                    bean = newsDataManager.getNewsData().get(Long.valueOf(id));
                    if (bean == null) {
                        bean = newsDataManager.getById(Long.valueOf(id));
                    }
                    //暂时不改修改时间
                    //bean.setUpdateDate(new Date());
                    //summ.put("updateDate", bean.getUpdateDate());
                    //版块移动时取消置顶
                    bean.setTopNumberOrder(Byte.valueOf("0"));
                    bean.setTypeId(Long.valueOf(typeId));
                    summ.put("typeId", bean.getTypeId());
                    summ.put("topNumberOrder", Byte.valueOf("0"));
                    this.newsDataManager.update(bean.getId(), summ);
                    //从缓存中移除该新闻
                    this.newsDataManager.removeCache(bean.getId());
                }
            }
        }
        super.rendJavaScript(response, "alert(\"" + ResourceUtil.getString("bbs.board.moved") + "\");parent.cloWithSuccess();");
        return null;
    }

    /**
    * 文化建设统计入口
    */
    public ModelAndView publishInfoStc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("stc/publishInfoStc");
        int year = DateUtil.getYear();
        Map<String, Object> jval = new HashMap<String, Object>();
        jval.put("year", year);
        jval.put("publishDateStart", year + "-01-01");
        jval.put("publishDateEnd", DateUtil.format(new Date()));
        //那个模块的统计
        String mode = request.getParameter("mode");
        String spceTypeId = request.getParameter("typeId");
        Map<String, Object> modeType = newsDataManager.getTypeByMode(mode, spceTypeId);
        jval.put("isGroupStc", !(Boolean) modeType.get("hideAcc"));
        jval.put("isStcDeptHide", modeType.get("hideDept"));
        jval.put("isStcAccHide", modeType.get("hideAcc"));

        jval.put("mode", mode);
        //参数spaceType,spaceId,typeId
        jval.put("spaceType", request.getParameter("spaceType"));
        jval.put("spaceId", spceTypeId);
        jval.put("typeId", request.getParameter("typeId"));
        mav.addObject("today", DateUtil.format(new Date()));
        mav.addObject("jval", Strings.escapeJson(JSONUtil.toJSONString(jval)));
        return mav;
    }

    /**
     * 统计导出
     */
    @SuppressWarnings("unchecked")
    public ModelAndView stcExpToXls(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, Object> param = ParamUtil.getJsonParams();
        DataRecord record = newsDataManager.expStcToXls(param);
        fileToExcelManager.save(response, record.getTitle(), record);
        return null;
    }

    /******************************6.0******************************/

    /**
     * 新闻首页/版块首页
     */
    public ModelAndView newsIndex(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("news/newsIndex");
        User user = AppContext.getCurrentUser();
        int spaceType = NumberUtils.toInt(request.getParameter("spaceType"));
        Long spaceId = NumberUtils.toLong(request.getParameter("spaceId"));
        String boardId = request.getParameter("boardId");
        
        //客开 gxy 20180716 焦点新闻栏目点击更多定位 start
        String fragmentId = request.getParameter("fragmentId");
        int indexflag = NumberUtils.toInt(request.getParameter("indexflag"));
        if( (boardId==null || "".equals(boardId))  && (fragmentId==null || "".equals(fragmentId)) && indexflag!=1){
        	boardId = "-2989629600863270294";
        	spaceType=0;
        }
        //客开 gxy 20180716 焦点新闻栏目点击更多定位 end
        
        //新闻首页指定标签页
        mav.addObject("labelPage", request.getParameter("labelPage"));

        //版块首页
        if (Strings.isNotBlank(boardId)) {
            Long typeId = NumberUtils.toLong(boardId);
            NewsType newsType = newsTypeManager.getById(typeId);
            if (newsType.getSpaceType() != SpaceType.group.ordinal() && newsType.getSpaceType() != SpaceType.corporation.ordinal()) {
                spaceType = newsType.getSpaceType();
                spaceId = newsType.getAccountId();
            }
            NewsTypeModel newsTypeModel = new NewsTypeModel(newsType, user.getId(), orgManager.getAllUserDomainIDs(user.getId()));
            newsTypeModel.setTopNumber(String.valueOf(newsType.getTopNumber()));
            //版块审核员
            if (newsType.getAuditUser() != 0) {
                newsTypeModel.setAuditName(Functions.showMemberName(newsType.getAuditUser()));
            } else {
                newsTypeModel.setAuditName("");
            }
            //客开 start
            //版块排版员
            if (newsType.getTypesettingStaff() != 0) {
              newsTypeModel.setTypesettingStaff(Functions.showMemberName(newsType.getTypesettingStaff()));
            } else {
              newsTypeModel.setTypesettingStaff("");
            }
            //客开 end
            StringBuilder typeAdmins = new StringBuilder();
            boolean flag = false;
            if (spaceType == SpaceType.custom.ordinal()) {
                List<V3xOrgMember> orgMember = spaceManager.getSpaceMemberBySecurity(typeId, 1);
                for (V3xOrgMember org : orgMember) {
                    if (flag) {
                        typeAdmins.append("、");
                    } else {
                        flag = true;
                    }
                    typeAdmins.append(Functions.showMemberName(org.getId()));
                }
            } else {
                for (NewsTypeManagers tm : newsType.getNewsTypeManagers()) {
                    if ("manager".equals(tm.getExt1())) {
                        String adminName = Functions.showMemberName(tm.getManagerId());
                        if (flag) {
                            typeAdmins.append("、");
                        } else {
                            flag = true;
                        }
                        typeAdmins.append(adminName);
                    }
                }
            }
            //版块管理员
            newsTypeModel.setAdminsName(typeAdmins.toString());
            Integer newsTypeCount = newsDataManager.getNewsNumber4Type(typeId);
            Integer newsTypeReplyCount = newsDataManager.getNewsReplyNumber4Type(typeId);
            if (Strings.isNotEmpty(newsTypeModel.getAuditName())) {
                mav.addObject("hasAuditUser", true);
            } else {
                mav.addObject("hasAuditUser", false);
            }
            //客开 start  排版员标识
            if (Strings.isNotEmpty(newsTypeModel.getTypesettingStaff())) {
              mav.addObject("hasTypesettingUser", true);
            } else {
                mav.addObject("hasTypesettingUser", false);
            }
            //客开 end
            //判断可管理版块
            List<NewsType> canAdminTypes = getCanAdminTypes(user.getId(), newsType);
            mav.addObject("canMove", Strings.isNotEmpty(canAdminTypes));
            mav.addObject("newsTypeCount", newsTypeCount);
            mav.addObject("newsTypeReplyCount", newsTypeReplyCount);
            mav.addObject("newsTypeMessage", newsTypeModel);
        }
        List<Long> myNewsTypeIds = null;
        if (spaceType == SpaceType.group.ordinal() || spaceType == SpaceType.corporation.ordinal()) {
            myNewsTypeIds = newsDataManager.getMyNewsTypeIds(0, spaceId);
        } else {
            myNewsTypeIds = newsDataManager.getMyNewsTypeIds(spaceType, spaceId);
        }

        if (Strings.isBlank(boardId)) {
            // 热门图片新闻
            List<NewsData> newsImgDataList = newsDataManager.queryListDatas(Constants.ImageNews, 0, 7, null, myNewsTypeIds, user.getId(), null, null, null);
            List<NewsDataVO> newsImgDataVOList = new ArrayList<NewsDataVO>();
            int i = 0;
            for (NewsData newsData : newsImgDataList) {
                NewsDataVO newsDataVO = new NewsDataVO();
                newsDataVO.setId(newsData.getId());
                newsDataVO.setTitle(newsData.getTitle());
                newsDataVO.setFuTitle(newsData.getFutitle());
                newsDataVO.setImageId(newsData.getImageId());
                if (newsData.getImageId() != null) {
                    if (i == 0) {
                        newsDataVO.setImageUrl(SystemEnvironment.getContextPath() + "/commonimage.do?method=showImage&id=" + newsData.getImageId() + "&size=custom&h=315&w=484");
                    } else {
                        newsDataVO.setImageUrl(SystemEnvironment.getContextPath() + "/commonimage.do?method=showImage&id=" + newsData.getImageId() + "&size=custom&h=155&w=215");
                    }
                }
                newsDataVO.setFocusNews(newsData.isFocusNews());
                newsImgDataVOList.add(newsDataVO);
                i++;
            }
            mav.addObject("topImageNews", newsImgDataVOList);

            /**秀吧最热列表*/
            if (AppContext.hasResourceCode("F05_show")) {
                List<ShowbarInfoBO> showbarHotList = showApi.findShowbarHotList(5);
                mav.addObject("showbarHotList", showbarHotList);
            }
        }

        // 我发布的，我评论的，我收藏的，新闻审核
        mav.addObject("myIssueCount", newsDataManager.getMyIssueCount(user.getId(), myNewsTypeIds));
        mav.addObject("myReplyCount", newsDataManager.getMyReplyCount(user.getId(), myNewsTypeIds));
        if (AppContext.hasPlugin("doc")) {
            mav.addObject("myCollectCount", newsDataManager.getMyCollectCount(user.getId(), myNewsTypeIds));
        }
        mav.addObject("myAuditCount", newsDataManager.getMyAuditCount(user.getId(), myNewsTypeIds));
        //客开 start  待排版数量
        mav.addObject("myTypesettingCount", newsDataManager.getMyTypesettingCount(user.getId(), myNewsTypeIds));
        //客开 end
        //是否允许发布新闻
        boolean hasIssue = false;
        boolean hasAudit = false;
        //客开 start 是否允许排版
        boolean hasTypesetting = false;
        //客开 end
        Map<String, List<NewsTypeModel>> newsTypeModelMap = new LinkedHashMap<String, List<NewsTypeModel>>();
        if (spaceType == SpaceType.public_custom.ordinal()) {// 自定义单位版块
            List<NewsType> customNewsTypeList = newsTypeManager.findAllOfCustom(spaceId, "publicCustom");
            List<NewsTypeModel> customNewsTypeModelList = new ArrayList<NewsTypeModel>();
            boolean[] _per = this.toNewsTypeModel(customNewsTypeList, customNewsTypeModelList);
            hasIssue = _per[0];
            hasAudit = _per[1];
            //客开 start
            hasTypesetting = _per[2];
            //客开 end
            newsTypeModelMap.put("17", customNewsTypeModelList);
        } else if (spaceType == SpaceType.public_custom_group.ordinal()) {// 自定义集团版块
            List<NewsType> customNewsTypeList = newsTypeManager.findAllOfCustom(spaceId, "publicCustomGroup");
            List<NewsTypeModel> customNewsTypeModelList = new ArrayList<NewsTypeModel>();
            boolean[] _per = this.toNewsTypeModel(customNewsTypeList, customNewsTypeModelList);
            hasIssue = _per[0];
            hasAudit = _per[1];
            //客开 start
            hasTypesetting = _per[2];
            //客开 end
            newsTypeModelMap.put("18", customNewsTypeModelList);
        } else if (spaceType == SpaceType.custom.ordinal()) {// 自定义团队版块
            List<NewsType> customNewsTypeList = newsTypeManager.findAllOfCustom(spaceId, "custom");
            List<NewsTypeModel> customNewsTypeModelList = new ArrayList<NewsTypeModel>();
            boolean[] _per = this.toNewsTypeModel(customNewsTypeList, customNewsTypeModelList);
            hasIssue = _per[0];
            hasAudit = _per[1];
            //客开 start
            hasTypesetting = _per[2];
            //客开 end
            newsTypeModelMap.put("4", customNewsTypeModelList);
        } else {
            // 集团版块
            boolean[] _perGroup = new boolean[] { false, false,false };
            if ((Boolean) (SysFlag.sys_isGroupVer.getFlag())) {
                List<NewsType> allGroupNewsTypeList = newsTypeManager.groupFindAll();
                List<NewsType> groupNewsTypeList = new ArrayList<NewsType>();
                for (NewsType newsType : allGroupNewsTypeList) {
                    if (user.isInternal() || newsType.getOutterPermit()) {
                        groupNewsTypeList.add(newsType);
                    }
                }
                List<NewsTypeModel> groupNewsTypeModelList = new ArrayList<NewsTypeModel>();
                _perGroup = this.toNewsTypeModel(groupNewsTypeList, groupNewsTypeModelList);
                newsTypeModelMap.put("3", groupNewsTypeModelList);
            }

            // 单位版块
            List<NewsType> allAccountNewsTypeList = newsTypeManager.findAll(user.getLoginAccount());
            List<NewsType> accountNewsTypeList = new ArrayList<NewsType>();
            for (NewsType newsType : allAccountNewsTypeList) {
                if (user.isInternal() || newsType.getOutterPermit()) {
                    accountNewsTypeList.add(newsType);
                }
            }
            List<NewsTypeModel> accountNewsTypeModelList = new ArrayList<NewsTypeModel>();
            boolean[] _perAccount = this.toNewsTypeModel(accountNewsTypeList, accountNewsTypeModelList);
            newsTypeModelMap.put("2", accountNewsTypeModelList);

            hasIssue = _perGroup[0] || _perAccount[0];
            hasAudit = _perGroup[1] || _perAccount[1];
          //客开 start
            hasTypesetting = _perGroup[2] || _perAccount[2];
          //客开 end
        }

        mav.addObject("newsTypeModelMap", newsTypeModelMap);
        mav.addObject("hasIssue", hasIssue);
        mav.addObject("hasAudit", hasAudit);
        //客开 start
        mav.addObject("hasTypesetting", hasTypesetting);
        //客开 end
        
      //客开 gxy 20180716 焦点新闻栏目点击更多定位 start
        mav.addObject("spaceTypeFlag", spaceType);
      //客开 gxy 20180716 焦点新闻栏目点击更多定位 start
        
        return mav;
    }

    private boolean[] toNewsTypeModel(List<NewsType> newsTypeList, List<NewsTypeModel> newsTypeModelList) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean hasIssue = false;
        boolean hasAudit = false;
      //客开 start 排版权限标识
        boolean hasTypesetting = false;
      //客开 end
        for (NewsType newsType : newsTypeList) {
            //外部人员不允许查看
            if (!user.isInternal() && !newsType.getOutterPermit()) {
                continue;
            }

            NewsTypeModel newsTypeModel = new NewsTypeModel(newsType, user.getId(), orgManager.getAllUserDomainIDs(user.getId()));
            if (newsTypeModel.isCanNewOfCurrent()) {
                hasIssue = true;
            }
            if (newsTypeModel.isCanAuditOfCurrent()) {
                hasAudit = true;
            }
            //客开 start
            if (newsTypeModel.isCanTypesettingOfCurrent()) {
              hasTypesetting = true;
            }
            //客开 end
            newsTypeModelList.add(newsTypeModel);
        }

        return new boolean[] { hasIssue, hasAudit ,hasTypesetting};
    }

    /**
     * 我发布的/我评论的/我收藏的/新闻审核
     */
    public ModelAndView newsMyInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("news/newsMyInfo");
        String infoType = request.getParameter("type");
        User user = AppContext.getCurrentUser();
        int spaceType = NumberUtils.toInt(request.getParameter("spaceType"));
        Long spaceId = NumberUtils.toLong(request.getParameter("spaceId"));
        List<Long> myNewsTypeIds = new ArrayList<Long>();
        if (spaceType == SpaceType.group.ordinal() || spaceType == SpaceType.corporation.ordinal()) {
            myNewsTypeIds = newsDataManager.getMyNewsTypeIds(0, spaceId);
        } else {
            myNewsTypeIds = newsDataManager.getMyNewsTypeIds(spaceType, spaceId);
        }
        if ("2".equals(infoType)) {
            int pageNo = NumberUtils.toInt(request.getParameter("pageNo"), 1);
            int pageSize = NumberUtils.toInt(request.getParameter("pageSize"), 20);
            Map<String, Object> replyMap = newsDataManager.findMyReply(pageNo, pageSize, myNewsTypeIds);
            Integer pages = (Integer) replyMap.get("pages");
            pageNo = (Integer) replyMap.get("pageNo");
            List<NewsReplyVO> replyList = (List<NewsReplyVO>) replyMap.get("replyList");

            mav.addObject("replyList", replyList);
            mav.addObject("pages", pages);
            mav.addObject("pageNo", pageNo);
            mav.addObject("pageArea", (pageNo - 1) / 10);
        }
        boolean[] _per = hasPermission(spaceType, spaceId, user);
        mav.addObject("hasIssue", _per[0]);
        mav.addObject("hasAudit", _per[1]);
      //客开 start
        mav.addObject("hasTypesetting", _per[2]);
      //客开 end
        // 页面类型
        mav.addObject("type", infoType);
        // 我发布的，我评论的，我收藏的，新闻审核
        mav.addObject("myIssueCount", newsDataManager.getMyIssueCount(user.getId(), myNewsTypeIds));
        mav.addObject("myReplyCount", newsDataManager.getMyReplyCount(user.getId(), myNewsTypeIds));
        if (AppContext.hasPlugin("doc")) {
            mav.addObject("myCollectCount", newsDataManager.getMyCollectCount(user.getId(), myNewsTypeIds));
        }
        mav.addObject("myAuditCount", newsDataManager.getMyAuditCount(user.getId(), myNewsTypeIds));
        //客开 start 待排版数量
        mav.addObject("myTypesettingCount", newsDataManager.getMyTypesettingCount(user.getId(), myNewsTypeIds));
        //客开 end
        return mav;
    }

    /**
     * 新闻搜索
     */
    public ModelAndView newsSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("news/newsSearch");
        return mav;
    }

    /**
     * 新闻新建/新闻修改
     */
    public ModelAndView newsEdit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        ModelAndView mav = new ModelAndView("news/newsEdit");
        String newsTypeStr = request.getParameter("newsType");
        String newsId = request.getParameter("newsId");
        String spaceId = request.getParameter("spaceId");
        String spaceTypeStr = request.getParameter("spaceType");
        //客开 start
        String publishFlag = request.getParameter("publishFlag");  //1 表示修改的是已发布的
        mav.addObject("publishFlag",publishFlag);
        //客开 end
        NewsData bean = new NewsData();
        List<Attachment> attachments = null;
        if (Strings.isNotBlank(newsId)) {
            Long newsDataId = NumberUtils.toLong(newsId);
            bean = newsDataManager.getNewsData().get(newsDataId);
            if (bean == null) {
                bean = newsDataManager.getById(newsDataId);
            }
            if (bean == null || bean.isDeletedFlag()) {
                String jsAction = "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.data.deleted") + "');parent.location.reload();";
                super.rendJavaScript(response, jsAction);
                return null;
            }
            //检验新闻是否被加锁 
            String action = NewsDataLockAction.NEWLOCK_EDITING;
            NewsDataLock newslock = newsDataManager.lock(newsDataId, action);
            if (newslock != null && newslock.getUserid() != user.getId()) {
                V3xOrgMember orm = orgManager.getMemberById(newslock.getUserid());
                String lockmessage = newslock.getAction();
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, lockmessage, orm.getName()) + "');window.close();");
                return null;
            }
            newsTypeStr = bean.getTypeId().toString();
            NewsType newsType = newsTypeManager.getById(Long.valueOf(newsTypeStr));
            spaceTypeStr = newsType.getSpaceType().toString();
            bean.setContent(newsDataManager.getBody(newsDataId).getContent());
            attachments = attachmentManager.getByReference(bean.getId(), bean.getId());
            boolean isAduit = false;
            if (null != bean.getAuditUserId() && 0 != bean.getAuditUserId()) {
                isAduit = true;
            }
            mav.addObject("isAduit", isAduit);
        } else {
            if(Strings.isNotBlank(newsTypeStr)) {
                boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
                Long accountId = AppContext.currentAccountId();
                if (!isV5Member) {
                    accountId = OrgHelper.getVJoinAllowAccount();
                }
                int spaceTypeInt = 2;
                if (Strings.isNotBlank(spaceTypeStr)) {
                    spaceTypeInt = Integer.parseInt(spaceTypeStr);
                } else if (Strings.isNotBlank(newsTypeStr)) {// 如果新闻类型不是空,从首页发布新闻页面进入，带过来的参数
                    NewsType newsType1 = newsTypeManager.getById(Long.parseLong(newsTypeStr));
                    if (newsType1 != null && newsType1.getSpaceType() != null) {
                        spaceTypeInt = newsType1.getSpaceType();
                    }
                }
                boolean canNewNewsFlag = false;
                List<NewsType> typeList = newsTypeManager.getTypesCanNewByMember(user.getId(), SpaceType.getEnumByKey(spaceTypeInt), accountId);
                for(NewsType type : typeList) {
                    if(newsTypeStr.equals(type.getId().toString())) {
                        canNewNewsFlag = true;
                        break;
                    }
                }
                if(!canNewNewsFlag) {
                    String jsAction = "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.alert.no.board.permission") + "');window.close();";
                    super.rendJavaScript(response, jsAction);
                    return null;
                }
            }
            bean.setCreateDate(new Date());
            bean.setCreateUser(user.getId());
            bean.setState(Constants.DATA_STATE_NO_SUBMIT);
            bean.setDataFormat(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
            bean.setReadCount(0);
            bean.setReplyNumber(0);
            bean.setPraiseSum(0);
            // 设置发布部门 ---登录人员在兼职单位
            if (!user.getLoginAccount().equals(user.getAccountId())) {
                List<MemberPost> memberPostList = orgManager.getMemberConcurrentPostsByAccountId(user.getId(), user.getLoginAccount());
                // 取兼职单位所在的部门
                if (Strings.isNotEmpty(memberPostList)) {
                    //bean.setPublishDepartmentId(memberPostList.get(0).getDepId());// SZP 客开
                	bean.setPublishDepartmentId(memberPostList.get(0).getOrgAccountId());// SZP 客开
                }
            } else {
                // 如果没有兼职信息，设置发布部门为当前用户登录单位所在的部门
                Long userId = bean.getCreateUser();
                //Long depId = this.newsUtils.getMemberById(userId).getOrgDepartmentId();// SZP 客开
                Long accId = this.newsUtils.getMemberById(userId).getOrgAccountId();// SZP 客开
                bean.setPublishDepartmentId(accId);
            }
            // SZP 客开 START
            if (bean.getPublishDepartmentId().toString().equals("-1792902092017745579")){
            	bean.setPublishDepartmentId(-2329940225728493295L);
            	bean.setPublishDepartmentName("中国信达资产管理股份有限公司");
            }else{
            	// 设置公司名称
            	Map<String,String> accounts = orgManager.getAccountIdAndNames();
            	if(accounts.containsKey(bean.getPublishDepartmentId().toString())){
            		bean.setPublishDepartmentName(accounts.get(bean.getPublishDepartmentId().toString()));
            	}
            }
            
            // SZP 客开 END
            bean.setDataFormat(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
            bean.setContent(null);

            //处理附件,默认的是不管从正常切换到正常的格式,还是正常的格式转换到格式附件都不应该丢的
            String attaFlag = null;
            //第一次或者说新建的时候bean.getId()肯定是空的
            Long attRefId = null;
            //第几次切换，第一次是true,false为不是第一次
            String openFlag = request.getParameter("openFlag");
            //点击修改时候进来的,这个时候新闻已有ID了
            String idStr = request.getParameter("id");
            if (!"".equalsIgnoreCase(idStr) && idStr != null) {
                bean.setId(Long.valueOf(idStr));
                attachmentManager.deleteByReference(bean.getId(), bean.getId());
                attaFlag = attachmentManager.create(ApplicationCategoryEnum.news, bean.getId(), bean.getId(), request);
                openFlag = "false";
                mav.addObject("attRefId", attRefId);
                mav.addObject("attFlag", openFlag);
                attachments = attachmentManager.getByReference(bean.getId(), bean.getId());
            } else {
                if ("true".equals(openFlag)) {
                    //第一次切换时执行以下方法
                    Long newId = UUIDLong.longUUID();
                    attaFlag = attachmentManager.create(ApplicationCategoryEnum.news, newId, newId, request);
                    attRefId = newId;
                    openFlag = "false";
                    mav.addObject("attRefId", attRefId);
                    mav.addObject("openFlag", openFlag);
                } else {
                    //第二次切换,会传递一个ID,应该先删除原来的附件,再创建一个ID;
                    attRefId = Long.valueOf(request.getParameter("attRefId"));
                    attachmentManager.deleteByReference(attRefId, attRefId);
                    attaFlag = attachmentManager.create(ApplicationCategoryEnum.news, attRefId, attRefId, request);
                    openFlag = "false";
                    mav.addObject("attRefId", attRefId);
                    mav.addObject("openFlag", openFlag);
                }
                attachments = attachmentManager.getByReference(attRefId, attRefId);
            }
            if (com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attaFlag)) {
                bean.setAttachmentsFlag(Boolean.TRUE);
            }
            /**  图片新闻 **/
            bean.setImageNews(Strings.isNotBlank(request.getParameter("imageNews")));
            bean.setFocusNews(Strings.isNotBlank(request.getParameter("focusNews")));
            String imageId = request.getParameter("imageId");
            if (Strings.isNotBlank(imageId)) {
                bean.setImageId(NumberUtils.toLong(imageId));
            }
        }
        mav.addObject("newsTypeId", newsTypeStr);
        mav.addObject("attachments", attachments);
        // 处理模板加载
        String oper = request.getParameter("form_oper");
        if (StringUtils.isNotBlank(oper) && "loadTemplate".equals(oper)) {
            super.bind(request, bean);
            bean.setShowPublishUserFlag("true".equals(request.getParameter("showPublish")));
            bean.setImageNews("true".equals(request.getParameter("hasImg")));
            bean.setShareWeixin("true".equals(request.getParameter("shareWeixin")));

            String templateId = request.getParameter("templateId");
            if (StringUtils.isNotBlank(templateId)) {
                ContentTemplate template = contentTemplateManager.getById(Long.valueOf(templateId));// 根据新闻格式ID取格式
                if (template != null) {
                    bean.setDataFormat(template.getTemplateFormat());
                    bean.setContent(template.getContent());
                    bean.setCreateDate(template.getCreateDate());
                    mav.addObject("templateId", template.getId());
                }

                mav.addObject("originalNeedClone", Boolean.TRUE);
            } else {
                bean.setDataFormat(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
                bean.setContent(null);
            }
        }

        mav.addObject("bean", bean);
        mav.addObject("constants", new Constants());

        //新闻版块
        int spaceTypeInt = SpaceType.corporation.ordinal();
        if (Strings.isNotBlank(spaceTypeStr)) {
            spaceTypeInt = Integer.parseInt(spaceTypeStr);
		} else if (Strings.isNotBlank(newsTypeStr)) {// 如果新闻类型不是空,从首页发布新闻页面进入，带过来的参数
			NewsType newsType1 = newsTypeManager.getById(Long.parseLong(newsTypeStr));
			if (newsType1 != null && newsType1.getSpaceType() != null) {
				spaceTypeInt = newsType1.getSpaceType();
			}
		}
        mav.addObject("spaceType", spaceTypeInt);
        mav.addObject("spaceId", spaceId);
        boolean isAuditEdit = false;
        if (Strings.isNotEmpty(request.getParameter("isAuditEdit"))) {
            isAuditEdit = "true".equals(request.getParameter("isAuditEdit")) ? true : false;
        }
        List<NewsType> groupType = new ArrayList<NewsType>();
        List<NewsType> corpType = new ArrayList<NewsType>();
        if (isAuditEdit) {
            if (spaceTypeInt == SpaceType.public_custom_group.ordinal() || spaceTypeInt == SpaceType.group.ordinal()) {
                groupType.add(newsTypeManager.getById(Long.valueOf(newsTypeStr)));
            } else if (spaceTypeInt == SpaceType.public_custom.ordinal() || spaceTypeInt == SpaceType.corporation.ordinal()) {
                corpType.add(newsTypeManager.getById(Long.valueOf(newsTypeStr)));
            }
        } else {
            if (Strings.isNotBlank(spaceId)
                    && (spaceTypeInt == SpaceType.public_custom_group.ordinal() || spaceTypeInt == SpaceType.public_custom.ordinal() || spaceTypeInt == SpaceType.custom.ordinal())) {
                if (spaceTypeInt == SpaceType.public_custom_group.ordinal()) {
                    groupType = this.newsTypeManager.getTypesCanNewByMember(user.getId(), SpaceType.public_custom_group, Long.valueOf(spaceId));
                } else if (spaceTypeInt == SpaceType.public_custom.ordinal()) {
                    corpType = this.newsTypeManager.getTypesCanNewByMember(user.getId(), SpaceType.public_custom, Long.valueOf(spaceId));
                } else if (spaceTypeInt == SpaceType.custom.ordinal()) {// 自定义团队版块
                    NewsType customType = newsTypeManager.getById(Long.valueOf(spaceId));
                    mav.addObject("customName", customType.getTypeName());
                }
            } else {
                groupType = newsTypeManager.getTypesCanNewByMember(user.getId(), SpaceType.group, user.getLoginAccount());
                corpType = newsTypeManager.getTypesCanNewByMember(user.getId(), SpaceType.corporation, user.getLoginAccount());
            }
        }
        Map<String, Object> typeMap = new HashMap<String, Object>();
        List<Map> groupNewsType = new ArrayList<Map>();
        for (NewsType nt : groupType) {
            Map<String, Object> type = new HashMap<String, Object>();
            type.put("id", nt.getId());
            type.put("typeName", nt.getTypeName());
            type.put("commentPermit", nt.getCommentPermit());
            groupNewsType.add(type);
        }
        List<Map> corpNewsType = new ArrayList<Map>();
        for (NewsType nt1 : corpType) {
            Map<String, Object> type = new HashMap<String, Object>();
            type.put("id", nt1.getId());
            type.put("typeName", nt1.getTypeName());
            type.put("commentPermit", nt1.getCommentPermit());
            corpNewsType.add(type);
        }
        typeMap.put("group", groupNewsType);
        typeMap.put("corp", corpNewsType);
        mav.addObject("hasGroup", groupType.size() > 0);
        mav.addObject("hasCorp", corpType.size() > 0);
        mav.addObject("typeJson", JSONUtil.toJSONString(typeMap));
        //新闻模板
        List<ContentTemplate> groupTempl = contentTemplateManager.findGroupTypesByScope(user.getId(), ContentTemplate.NEWS_CONTENT_TEMPLATE_TYPE);
        List<ContentTemplate> corpTempl = contentTemplateManager.findAccountTypesByScope(user.getId(), user.getLoginAccount(), ContentTemplate.NEWS_CONTENT_TEMPLATE_TYPE);
        Map<String, Object> templMap = new HashMap<String, Object>();
        List<ContentTemplate> groupTemplList = new ArrayList<ContentTemplate>();
        for (ContentTemplate ct : groupTempl) {
            ContentTemplate c = new ContentTemplate();
            c.setId(ct.getId());
            c.setTemplateName(ct.getTemplateName());
            groupTemplList.add(c);
        }
        List<ContentTemplate> corpTemplList = new ArrayList<ContentTemplate>();
        for (ContentTemplate ct1 : corpTempl) {
            ContentTemplate c1 = new ContentTemplate();
            c1.setId(ct1.getId());
            c1.setTemplateName(ct1.getTemplateName());
            corpTemplList.add(c1);
        }
        templMap.put("group", groupTemplList);
        templMap.put("corp", corpTemplList);
        if (spaceTypeInt == SpaceType.custom.ordinal()) {//自定义团队空间，使用单位的新闻格式
            mav.addObject("corp", corpTemplList);
        }
        mav.addObject("templJson", JSONUtil.toJSONString(templMap));

        return mav;
    }

    /**
     * 老页面跳转兼容（勿删）
     */
    public ModelAndView userView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return super.redirectModelAndView("/newsData.do?method=newsView&newsId=" + request.getParameter("id"));
    }

    /**
     * 新闻查看
     */
    public ModelAndView newsView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //from=message，从消息打开 pigeonhole，从归档打开 colCube，从协同立方打开 section,从栏目打开
        ModelAndView mav = new ModelAndView("news/newsView");
        String from = request.getParameter("from");
        String spaceId = request.getParameter("spaceId");
        Long newsId = NumberUtils.toLong(request.getParameter("newsId"));
        boolean fromPigeonhole = "pigeonhole".equals(from);
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();

        if (StringUtils.isBlank(newsId.toString())) {
            BusinessException e = new BusinessException("news_not_exists");
            request.getSession().setAttribute("_my_exception", e);
            return new ModelAndView("news/error");
        }
        NewsData newsData = newsDataManager.getNewsData().get(newsId);
        boolean hasCache = false;
        if (newsData == null) {
            newsData = newsDataManager.getById(newsId);
        } else {
            hasCache = true;
        }
        if (newsData == null || newsData.isDeletedFlag()) {
            super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "new.validate.delete") + "');window.close();");
            return null;
        }
        /*
        if (newsData.getPublishDepartmentName().equals("-1010101010101010101")){
        	newsData.setPublishDepartmentName("");
        }else if (newsData.getPublishDepartmentName().equals("-2329940225728493295")){
        	newsData.setPublishDepartmentName("中国信达资产管理股份有限公司");
        }
*/
        Long typeId = newsData.getTypeId();
        //判断用户是否管理员
        boolean isAdmin = newsTypeManager.isManagerOfType(typeId, userId);
        NewsType newsType = newsTypeManager.getById(typeId);
        String ext1 = newsType.getExt1();
        mav.addObject("viewStyle",ext1);
        mav.addObject("typeName", newsType.getTypeName());
        mav.addObject("auditorModify", newsType.getIsAuditorModify());
        Long agentId = null;
        if(newsData.getAuditUserId() != null){
        	agentId = AgentUtil.getAgentByApp(newsData.getAuditUserId(), ApplicationCategoryEnum.news.getKey());
        }
        boolean isAudit = newsType.getAuditUser().equals(userId) || userId.equals(agentId);
        //客开strat 是否是排版员
        boolean isTypesetting = newsType.getTypesettingStaff().equals(userId) || userId.equals(agentId);
        //客开end
        if (Strings.isNotBlank(spaceId)) {
            mav.addObject("customSpaceName", spaceManager.getSpaceFix(Long.parseLong(spaceId)).getSpacename());
        }
        boolean flag = false;
        if (newsData == null || newsData.isDeletedFlag()) {
            flag = true;
        }
        if (newsData.getState().intValue() == Constants.DATA_STATE_NO_SUBMIT && !"myIssue".equals(from)) {
            flag = true;
        } else if (newsData.getState().intValue() == Constants.DATA_STATE_ALREADY_CREATE) {
            if ("myAudit".equals(from) || "message".equals(from) || "section".equals(from)) {
                if (isAudit) {
                    if (user.getId() != -1 && Strings.isNotBlank(spaceId)) {
                        boolean isAlert = check(Long.parseLong(spaceId), user.getId());
                        if (isAlert) {
                            String jsAction = "alert("+ ResourceUtil.getString("news.sorry.not.scope.read") +");window.close();";//对不起，您不在该空间范围内，无法继续查看其内容
                            super.rendJavaScript(response, jsAction);
                            return null;
                        }
                    }
                    //检验文件中加锁
                    String action = NewsDataLockAction.NEWLOCK_AUDITING;
                    NewsDataLock newslock = newsDataManager.lock(newsId, action);
                    if (newslock != null && newslock.getUserid() != user.getId()) {
                        String lockaction = newslock.getAction();
                        V3xOrgMember orm = orgManager.getMemberById(newslock.getUserid());
                        super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, lockaction, orm.getName(), 2) + "');window.close();");

                        return null;
                    }
                    List<CtpAffair> updateaffs = affairManager.getAffairs(ApplicationCategoryEnum.news, newsId);
                    if (!updateaffs.isEmpty() && updateaffs.get(0).getSubState() != SubStateEnum.col_pending_read.key()) {
                        //因为只有一条，因此取0
                        CtpAffair updateaff = updateaffs.get(0);
                        updateaff.setSubState(SubStateEnum.col_pending_read.key());
                        affairManager.updateAffair(updateaff);
                    }
                    mav.addObject("viewFlag", "pendingAudit");
                } else {
                    mav.addObject("viewFlag", "draft");
                }
            } else if ("myIssue".equals(from)) {
                mav.addObject("viewFlag", "draft");
            } else {
                flag = true;
            }
        } else if (newsData.getState().intValue() == Constants.DATA_STATE_ALREADY_AUDIT) {
            if ("myAudit".equals(from) || "myIssue".equals(from) || "message".equals(from)) {
                mav.addObject("viewFlag", "auditPass");
            } else {
                flag = true;
            }
        } else if (newsData.getState().intValue() == Constants.DATA_STATE_NOPASS_AUDIT) {
            if ("myAudit".equals(from) || "myIssue".equals(from) || "message".equals(from)) {
                mav.addObject("viewFlag", "noPass");
            } else {
                flag = true;
            }
        }
        //客开start
        else if (newsData.getState().intValue() == Constants.DATA_STATE_TYPESETTING_CREATE) {
          if ("myTypesetting".equals(from) || "message".equals(from) || "section".equals(from)) {
            if (isTypesetting) {
                if (user.getId() != -1 && Strings.isNotBlank(spaceId)) {
                    boolean isAlert = check(Long.parseLong(spaceId), user.getId());
                    if (isAlert) {
                        String jsAction = "alert('对不起，您不在该空间范围内，无法继续查看其内容!');window.close();";
                        super.rendJavaScript(response, jsAction);
                        return null;
                    }
                }
                //检验文件中加锁
                String action = NewsDataLockAction.NEWLOCK_AUDITING;
                NewsDataLock newslock = newsDataManager.lock(newsId, action);
                if (newslock != null && newslock.getUserid() != user.getId()) {
                    String lockaction = newslock.getAction();
                    V3xOrgMember orm = orgManager.getMemberById(newslock.getUserid());
                    super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, lockaction, orm.getName(), 2) + "');window.close();");

                    return null;
                }
                List<CtpAffair> updateaffs = affairManager.getAffairs(ApplicationCategoryEnum.news, newsId);
                if (!updateaffs.isEmpty() && updateaffs.get(0).getSubState() != SubStateEnum.col_pending_read.key()) {
                    //因为只有一条，因此取0
                    CtpAffair updateaff = updateaffs.get(0);
                    updateaff.setSubState(SubStateEnum.col_pending_read.key());
                    affairManager.updateAffair(updateaff);
                }
                mav.addObject("viewFlag", "pendingAudit");
            } else {
                mav.addObject("viewFlag", "draft");
            }
          } else if ("myIssue".equals(from)) {
              mav.addObject("viewFlag", "draft");
          } else {
              flag = true;
          }
        }else if (newsData.getState().intValue() == Constants.DATA_STATE_TYPESETTING_PASS) {
          if ("myTypesetting".equals(from) || "myIssue".equals(from) || "message".equals(from)) {
            mav.addObject("viewFlag", "typesettingPass");
          } else {
              flag = true;
          }
        }else if (newsData.getState().intValue() == Constants.DATA_STATE_TYPESETTING_NOPASS) {
          if ("myTypesetting".equals(from) || "myIssue".equals(from) || "message".equals(from)) {
            mav.addObject("viewFlag", "noTypesettingPass");
          } else {
              flag = true;
          }
        }
        //客开end

        else if (newsData.getState().intValue() == Constants.DATA_STATE_ALREADY_PIGEONHOLE && !fromPigeonhole) {
            flag = true;
        }

        NewsType type = newsData.getType();
        if (type == null || !type.isUsedFlag()) {
            flag = true;
        }
        if (!user.isInternal()) {
            if (!newsData.getType().getOutterPermit()) {
                flag = true;
            }
        }

        if ("myCollect".equals(from)) {
            mav.addObject("viewFlag", "myCollect");
        }
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        Long accountId = AppContext.currentAccountId();
        if (!isV5Member) {
            accountId = OrgHelper.getVJoinAllowAccount();
        }

        // 防护：已发布的新闻被删除或被管理员归档，其他用户点击系统消息链接时候给出提示<归档的新闻，在文档中心处可以正常查看>
        if (flag && !fromPigeonhole) {
            //来自协同立方的话，这样关闭
            if ("colCube".equals(from)) {
                super.rendJavaScript(response,
                        "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "new.validate.delete") + "');window.close();window.parentDialogObj.url.closeParam.handler();");
                return null;
            } else if ("section".equals(from)) {
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "new.validate.delete") + "');window.close();");
                return null;
            }
            
            if(!isV5Member) {
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.user.notAuthority") + "');window.close();");
                return null;
            }
            super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "new.validate.delete") + "');window.close();");
            return null;
        }

        // SECURITY 访问安全检查
        if (!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.news, user, newsId, null, null)) {
            return null;
        }

        // 该单位的兼职人员
        Map<Long, List<MemberPost>> posts = orgManager.getConcurentPostsByMemberId(newsData.getAccountId(), user.getId());
        // 归档打开，权限归文档中心控制
        if (!fromPigeonhole && newsData.getType().getSpaceType().intValue() == SpaceType.corporation.ordinal() && !accountId.toString().equals(newsData.getAccountId().toString())
                && (posts == null || posts.isEmpty())) {
            super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.user.notAuthority") + "');window.close();");
            return null;
        }

        if (newsData.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH) {
            //设置阅读状态，以便已阅和未读状态标识能被获取
            this.newsReadManager.setReadState(newsData.getId(), userId);
            if (hasCache) {
                newsDataManager.clickCache(newsId, userId);
            } else {
                // 增加阅读次数，添加同步防护
                int readCount = 0;
                synchronized (readCountLock) {
                    readCount = newsData.getReadCount() == null ? 0 : newsData.getReadCount().intValue();
                    newsData.setReadCount(readCount + 1);
                }

                // 保存到缓存
                try{
                  newsDataManager.syncCache(newsData, (newsData.getReadCount() == null ? 0 : newsData.getReadCount()));
                }catch(Exception e){
                  log.info("syncCache ...");
                }
            }
        }

        newsData.setContent(newsDataManager.getBody(newsData.getId()).getContent());

        if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_FORM.equals(newsData.getDataFormat())) {
            String content = this.convertContent(newsData.getContent());
            if (content != null) {
                newsData.setDataFormat(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
                newsData.setContent(content);
            }
        }
        
        if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML.equals(newsData.getDataFormat())) {
            String content = this.convertContentV(newsData.getContent());
            if (content != null) {
                newsData.setContent(content);
            }
        }

        this.newsDataManager.initData(newsData);
        mav.addObject("bean", newsData);

        if (newsData.getAttachmentsFlag()) {
            List<Attachment> attachments = attachmentManager.getByReference(newsData.getId(), newsData.getId());
            String attListJSON = attachmentManager.getAttListJSON(attachments);
            mav.addObject("attListJSON", attListJSON);
        } else {
            mav.addObject("attListJSON", "");
        }

        if (AppContext.hasPlugin("doc")) {
            String collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
            if ("true".equals(collectFlag)) {
                List<Map<String, Long>> collectMap = docApi.findFavorites(userId, CommonTools.newArrayList(newsData.getId()));
                if (!collectMap.isEmpty()) {
                    mav.addObject("isCollect", Boolean.TRUE);
                    mav.addObject("collectDocId", collectMap.get(0).get("id"));
                }
            }
            mav.addObject("docCollectFlag", collectFlag);
        }
        AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.news, String.valueOf(newsData.getId()), AppContext.currentUserId());
        //查点赞
        if (!Strings.isBlank(newsData.getPraise()) && newsData.getPraise().contains(userId.toString())) {
            mav.addObject("newsPraise", true);
        } else {
            mav.addObject("newsPraise", false);
        }
        if (newsData.getPraiseSum() == null) {
            newsData.setPraiseSum(0);
        }

        //新闻回复总个数
        int allReplyCount = newsReplyManager.getAllReplyCount(newsId);
        mav.addObject("replyNum", allReplyCount);

        if (type.getCommentPermit() && newsData.getCommentPermit()
                && (newsData.getState().intValue() == Constants.DATA_STATE_ALREADY_PUBLISH || newsData.getState().intValue() == Constants.DATA_STATE_ALREADY_PIGEONHOLE)) {
            int replyPages = 0;//回复总页数
            int pageSize = 50;
            int begin = 0;//开始
            int replyPageNo = NumberUtils.toInt(request.getParameter("replyPageNo"), 1);
            //顶层回复个数
            int topReplyCount = newsReplyManager.getTopReplyCount(newsId);
            replyPages = (topReplyCount + pageSize - 1) / pageSize; // 总页数
            if (replyPages == 0) {
                replyPages = 1;
            }
            if (replyPageNo != 1) {
                begin = (replyPageNo - 1) * pageSize;
            } else if ("reply".equals(from)) {
                // 从回复进来的显示最后一页
                begin = (replyPages - 1) * pageSize;
            }
            mav.addObject("pages", replyPages);
            mav.addObject("nowPage", replyPageNo);//当前页数
            mav.addObject("pageArea", (replyPageNo - 1) / 10);//当前页数在第几个（1-10）间

            //最赞回复 3 条
            mav.addObject("hotReplyList", newsReplyManager.findHotReplyListById(newsId));

            List<NewsReplyVO> newsReplyList = new ArrayList<NewsReplyVO>();
            //顶层回复
            List<NewsReply> topReplyList = newsReplyManager.findTopReplyList(newsId, begin, pageSize);
            for (NewsReply nr : topReplyList) {
                NewsReplyVO newsReplyVO = new NewsReplyVO(nr);
                if (!Strings.isBlank(newsReplyVO.getPraise()) && newsReplyVO.getPraise().contains(userId.toString())) {
                    newsReplyVO.setPraiseFlag("true");
                }
                //****创建人 新闻创建人 （管理员）可删评论
                if (isAdmin || newsReplyVO.getFromMemberId().toString().equals(userId.toString()) || newsData.getCreateUser().toString().equals(userId.toString())) {
                    newsReplyVO.setCanDelete("true");
                }
                newsReplyList.add(newsReplyVO);
            }
            //子回复
            List<NewsReply> childReplyList = new ArrayList<NewsReply>();
            if (Strings.isNotEmpty(topReplyList)) {
                List<Long> replyIds = new ArrayList<Long>();
                for (NewsReply nr : topReplyList) {
                    replyIds.add(nr.getId());
                }
                childReplyList = newsReplyManager.findChildReplyList(replyIds);
            }
            if (Strings.isNotEmpty(childReplyList)) {
                for (NewsReplyVO vo : newsReplyList) {
                    List<NewsReplyVO> childReplyVOList = new ArrayList<NewsReplyVO>();
                    for (NewsReply child : childReplyList) {
                        if (child.getReplyType() == 0) {
                            continue;
                        }
                        String childId = child.getToReplyId().toString();
                        String parentId = vo.getId().toString();
                        if (childId.equals(parentId)) {
                            //****创建人 新闻创建人 （管理员）可删评论
                            NewsReplyVO tempVO = new NewsReplyVO(child);
                            if (isAdmin || tempVO.getFromMemberId().toString().equals(userId.toString()) || newsData.getCreateUser().toString().equals(userId.toString())) {
                                tempVO.setCanDelete("true");
                            }
                            childReplyVOList.add(tempVO);
                        }
                    }
                    vo.setChildReplyList(childReplyVOList);
                }
            }
            mav.addObject("replyList", newsReplyList);
        }

        return mav;
    }
    
    private String convertContentV(String content) throws BusinessException {
        if (content == null) {
            return content;
        }
        StringBuffer sb = new StringBuffer();
        Pattern pDiv = Pattern.compile("method=download&fileId=(.+?)&v=fromForm&createDate=(.+?)&filename=(.+?)\"");
        Matcher matcherDiv = pDiv.matcher(content);
        while (matcherDiv.find()) {
            try {
                String fileId = matcherDiv.group(1);
                String createDate = matcherDiv.group(2);
                String fileName = matcherDiv.group(3);
                String replace = "method=download&fileId=" + fileId + "&v=" + SecurityHelper.digest(fileId)
                        + "&createDate=" + createDate + "&filename=" + URLEncoder.encode(fileName, "UTF-8") + "\"";
                matcherDiv.appendReplacement(sb, replace.toString());
            } catch (UnsupportedEncodingException e) {
            }
        }
        matcherDiv.appendTail(sb);
        return sb.toString();
    }

    public List<NewsType> getCanAdminTypes(Long memberId, NewsType newsType) {
        Integer spaceType = newsType.getSpaceType();
        Long accountId = newsType.getAccountId();
        List<NewsType> newsTypeList = new ArrayList<NewsType>();
        if (spaceType == SpaceType.public_custom.ordinal()) {// 自定义单位版块
            newsTypeList = newsTypeManager.getManagerTypeByMember(memberId, SpaceType.public_custom, accountId);
        } else if (spaceType == SpaceType.public_custom_group.ordinal()) {// 自定义集团版块
            newsTypeList = newsTypeManager.getManagerTypeByMember(memberId, SpaceType.public_custom_group, accountId);
        } else if (spaceType == SpaceType.group.ordinal()) {// 集团版块
            newsTypeList = newsTypeManager.getManagerTypeByMember(memberId, SpaceType.group, accountId);
        } else if (spaceType == SpaceType.corporation.ordinal()) {// 单位版块
            newsTypeList = newsTypeManager.getManagerTypeByMember(memberId, SpaceType.corporation, accountId);
        }
        if (Strings.isNotEmpty(newsTypeList)) {
            newsTypeList.remove(newsType);
        }
        return newsTypeList;
    }

    public ModelAndView newSave(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        String userName = user.getName();
        String dataformat = request.getParameter("dataFormat");
        String ext5 = request.getParameter("ext5");
        String spaceId = request.getParameter("spaceId");
        //客开 start
        String publishFlag = request.getParameter("publishFlag");  //1 表示修改的是已发布的
        boolean isPublish = false;
        if(null!=publishFlag && publishFlag.equals("1")){
          isPublish = true;
        }
        if(isPublish){
          //如果是二次发布修改
          //此次修改当作新新闻处理，保持之前修改的新闻id到新纪录中的oldId字段中
          boolean isAuditEdit = "true".equals(request.getParameter("isAuditEdit"));
          NewsData bean = null;
          String idStr = request.getParameter("id");
          String imgUrl = request.getParameter("imgUrl");
		  //项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-10   修改功能  新闻发布界面添加副标题  start
		  String futitle = request.getParameter("futitle");
		  //项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-10   修改功能  新闻发布界面添加副标题  end
          Long oldImageId = 1L;
          //当作新新闻
          bean = new NewsData();


          //从缓存里面取新闻
          NewsData oldBean = newsDataManager.getNewsData().get(Long.valueOf(idStr));
          if (oldBean == null) {
            oldBean = newsDataManager.getById(Long.valueOf(idStr));
          }
          if (oldBean == null) {
              super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.data.noexist") + "');" + "window.close();");
              return null;
          }
          super.bind(request, bean);
          bean.setId(null);
          bean.setOldId(oldBean.getId());
          
          //客开 gxy 20180712 新闻修改发布时间不变  start
          bean.setPublishDate(oldBean.getPublishDate());
          //客开 gxy 20180712 新闻修改发布时间不变  end
          
          String newsTypeId = request.getParameter("newsType");
          if (Strings.isNotEmpty(newsTypeId)) {
              bean.setTypeId(Long.valueOf(newsTypeId));
          }
          Long typeId = bean.getTypeId();
          NewsType type = this.newsDataManager.getNewsTypeManager().getById(typeId);
          bean.setType(type);
          bean.setSpaceType(type.getSpaceType());
          bean.setAccountId(type.getAccountId());

          if (bean.getKeywords() != null && "".equals(bean.getKeywords().trim()))
              bean.setKeywords(null);
          if (bean.getBrief() != null && "".equals(bean.getBrief().trim()))
              bean.setBrief(null);

          String publishDepartmentId = request.getParameter("publishDepartmentId");
          if (publishDepartmentId != null) {
              bean.setPublishDepartmentId(Long.valueOf(publishDepartmentId));
          }

          if (bean.getState() != null) {
              bean.getState().intValue();
          }
          if (bean.getPublishScope() == null) {
              bean.setPublishScope("");
          }
          String form_oper = request.getParameter("form_oper");
          if (StringUtils.isNotBlank(form_oper)) {
              if ("draft".equals(form_oper)) {
                  bean.setState(Constants.DATA_STATE_NO_SUBMIT);
                  bean.setAuditAdvice(null);
                  bean.setPublishDate(null);
                  bean.setPublishUserId(null);
                  bean.setReadCount(0);
                  bean.setUpdateDate(null);
                  bean.setUpdateUser(null);
              } else if ("submit".equals(form_oper)) {
                  if (type.isAuditFlag()) {
                      bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
                  }else if(type.isTypesettingFlag()){
                    bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
                  } else {
                      // 改为直接发布
                      bean.setExt3(String.valueOf(String.valueOf(Constants.AUDIT_RECORD_NO)));
                      bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                      if (bean.getPublishDate() == null) {
                          bean.setPublishDate(new Date());
                      }
                      bean.setPublishUserId(AppContext.getCurrentUser().getId());
                  }
                  if (bean.getReadCount() == null) {
                      bean.setReadCount(0);
                  }
              }
          } else {
              bean.setAuditAdvice(null);
              bean.setPublishDate(null);
              bean.setPublishUserId(null);
              bean.setReadCount(0);
              bean.setUpdateDate(null);
              bean.setUpdateUser(null);
              bean.setState(Constants.DATA_STATE_NO_SUBMIT);
          }
          bean.setCreateDate(new Date());
          bean.setCreateUser(AppContext.getCurrentUser().getId());
          bean.setTopOrder(Byte.valueOf("0"));

          bean.setUpdateDate(new Date());
          bean.setUpdateUser(AppContext.getCurrentUser().getId());
          bean.setTopOrder(type.getTopCount());
          bean.setDataFormat(dataformat);
          bean.setExt5(ext5);
          /**-------------图片新闻-----------------**/
          boolean imageNews = false;
          if (Strings.isNotBlank(request.getParameter("hasImg"))) {
              imageNews = request.getParameter("hasImg").equals("true");
          }
          bean.setImageNews(imageNews);
          boolean showPublishUserFlag = false;
          if (Strings.isNotBlank(request.getParameter("showPublish"))) {
              showPublishUserFlag = request.getParameter("showPublish").equals("true");
          }
          bean.setShowPublishUserFlag(showPublishUserFlag);
          //  boolean focusNews = Strings.isNotBlank(request.getParameter("focusNews"));
          //  bean.setFocusNews(focusNews);
          if (imageNews) {
              String imageIdStr = request.getParameter("imageId");
              Long imageId = NumberUtils.toLong(imageIdStr, 1L);
              if (imageId != oldImageId) {
                  bean.setImageId(imageId);
              }
          } else {
              bean.setImageId(null);
          }

          if (type.isAuditFlag() && (type.getSpaceType() == SpaceType.public_custom.ordinal() || type.getSpaceType() == SpaceType.public_custom_group.ordinal())) {
              Long auditId = bean.getType().getAuditUser();
              if (auditId != -1) {
                  boolean isAlert = check(type.getAccountId(), auditId);
                  if (isAlert) {
                      response.setCharacterEncoding("UTF-8");
                      PrintWriter out = response.getWriter();
                      response.setContentType("text/html;charset=UTF-8");
                      out.println("<script type='text/javascript'>");
                      out.println("alert('该新闻无法审核，请联系管理员重新设置审核员!')");
                      out.println("</script>");
                      out.flush();
                      return null;
                  }
              }
          }

          String attaFlag = null;
          boolean isNew = true;
          //在保存的时候对新闻的格式进行处理
          bean.setIdIfNew();

          bean.setAttachmentsFlag(false);
          bean.setImgUrl(imgUrl);
          List<Attachment> attList = attachmentManager.getAttachmentsFromRequest(ApplicationCategoryEnum.news, bean.getId(), bean.getId(), request);
          if (!imageNews) {
              for (Attachment att : attList) {
                  //非图片格式的新闻 不保存栏目图片
                  if (att.getType() == 5) {
                      attList.remove(att);
                      break;
                  }
              }
          }
          attaFlag = attachmentManager.create(attList);
          if (com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attaFlag)) {
              bean.setAttachmentsFlag(true);
          }
          if (Strings.isNotBlank(spaceId) && bean.getAccountId() == null) {
              newsDataManager.saveCustomNews(bean, isNew);
          } else {
			  //项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-10   修改功能  新闻发布界面添加副标题  start
        	 bean.setFutitle(futitle);
        	//项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-10   修改功能  新闻发布界面添加副标题  end
            
              newsDataManager.save(bean, isNew);
          }
          newsDataManager.initDataFlag(bean, true);
          // 发送要审合公告消息消息
          if (bean.getState().equals(Constants.DATA_STATE_ALREADY_CREATE) && !isAuditEdit) {
              Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.news.getKey());
            // 新建提交
            // 2007.12.12 加入审核员的待办事项
            this.addPendingAffair(type, bean);
            userMessageManager.sendSystemMessage(MessageContent.get("news.send", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                    MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.news.alreadyauditing", String.valueOf(bean.getId())), type.getId());

            if (agentId != null) {//给代理人发消息,后缀(代理)
                userMessageManager.sendSystemMessage(MessageContent.get("news.send", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(),
                        MessageReceiver.get(bean.getId(), agentId, "message.link.news.alreadyauditing", String.valueOf(bean.getId())), type.getId());
            }

            //发布审核加日志<新建新闻>
            appLogManager.insertLog(user, AppLogAction.News_New, userName, bean.getTitle());
          } else if (bean.getState().equals(Constants.DATA_STATE_NO_SUBMIT)) {
              //发布审核加日志<修改新闻>
              appLogManager.insertLog(user, AppLogAction.News_Modify, userName, bean.getTitle());
          } else if (isAuditEdit && !bean.getCreateUser().equals(AppContext.currentUserId())) {//审核修改后，给发起人发送消息包括代理
              userMessageManager.sendSystemMessage(MessageContent.get("news.edit", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                      MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.news.writedetail", String.valueOf(bean.getId())));
              Long agentId = AgentUtil.getAgentByApp(bean.getCreateUser(), ApplicationCategoryEnum.news.getKey());
              if (agentId != null) {//给代理人发消息,后缀(代理)
                  MessageReceiver receiver = MessageReceiver.get(bean.getId(), agentId, "message.link.news.writedetail", String.valueOf(bean.getId()));
                  userMessageManager.sendSystemMessage(MessageContent.get("news.edit", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(), receiver);
              }
          }
          //对新闻文件进行解锁
          if (!"".equalsIgnoreCase(idStr) && idStr != null) {
              newsDataManager.unlock(Long.valueOf(idStr));
          }
          if(bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)){
            //如果是二次发布且并发布，当前新闻内容覆盖之前的老新闻（除发布时间、发布人、查阅留痕等信息需要保留不变外），删除当前新闻
            List<Attachment> oldAtts = attachmentManager.getByReference(oldBean.getId(), oldBean.getId());
            List<Long> oldFileUrls = new ArrayList<Long>();
            Map<Long,Long> oldFileUrlsMap = new HashMap<Long, Long>();
            if(!CollectionUtils.isEmpty(oldAtts)){
              for(Attachment att:oldAtts){
                oldFileUrls.add(att.getFileUrl());
                oldFileUrlsMap.put(att.getFileUrl(),att.getId());
              }
            }
            List<Attachment> atts = attachmentManager.getByReference(bean.getId(), bean.getId());
            List<Long> newAtts = new ArrayList<Long>();
            for(Attachment att:atts){
              if(oldFileUrls.contains(att.getFileUrl().longValue())){
                newAtts.add(att.getFileUrl());
                oldFileUrls.remove(att.getFileUrl().longValue());
                oldFileUrlsMap.remove(att.getFileUrl());
              }
            }
            //删除老新闻的附件
            for(Map.Entry<Long, Long> entry:oldFileUrlsMap.entrySet()){
              attachmentManager.deleteById(entry.getValue());
            }
            //把新新闻的附件指向老新闻
            for(Attachment att:atts){
              if(newAtts.contains(att.getFileUrl()))continue;
              att.setReference(oldBean.getId());
              att.setSubReference(oldBean.getId());
              attachmentManager.update(att);
            }
            NewsBody body = newsDataManager.getNewsBodyDao().get(bean.getId());
            newsDataManager.getNewsBodyDao().deleteByDataId(oldBean.getId());//删除老新闻的内容
            body.setId(oldBean.getId());//把新新闻的内容复制到老新闻上
            newsDataManager.getNewsBodyDao().save(body);
            //更新老新闻
            oldBean.setTitle(bean.getTitle());
            oldBean.setFutitle(bean.getFutitle());
            oldBean.setSpaceType(bean.getSpaceType());
            oldBean.setType(bean.getType());
            oldBean.setTypeId(bean.getTypeId());
            oldBean.setTypeName(bean.getTypeName());
            oldBean.setPublishDepartmentId(bean.getPublishDepartmentId());
            oldBean.setPublishDepartmentName(bean.getPublishDepartmentName());
            oldBean.setBrief(bean.getBrief());
            oldBean.setKeywords(bean.getKeywords());
            oldBean.setShowPublishUserFlag(bean.isShowPublishUserFlag());
            oldBean.setImgUrl(bean.getImgUrl());
            oldBean.setImageId(bean.getImageId());
            oldBean.setImageNews(bean.isImageNews());
            oldBean.setShareWeixin(bean.getShareWeixin());
            oldBean.setAttachmentsFlag(bean.getAttachmentsFlag());
            oldBean.setAuditAdvice(bean.getAuditAdvice());
            oldBean.setAuditAdvice1(bean.getAuditAdvice1());
            oldBean.setAuditDate(bean.getAuditDate());
            oldBean.setAuditDate1(bean.getAuditDate1());
            oldBean.setAuditUserId(bean.getAuditUserId());
            oldBean.setAuditUserId1(bean.getAuditUserId1());
            //项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-10   修改功能  新   闻发布界面添加副标题  start
            oldBean.setFutitle(bean.getFutitle());
            //项目  信达资产   公司  kimde  修改人  msg  修改时间    2017-11-10   修改功能  新闻发布界面添加副标题  end
            newsDataManager.updateDirect(oldBean);
            //删除新新闻
            newsDataManager.delete(bean.getId());
            // 删除待办
            affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
            newsDataManager.getNewsData().remove(oldBean.getId());
            newsDataManager.getNewsData().remove(bean.getId());
//            newsDataManager.getNewsData().save(oldBean.getId(), oldBean, oldBean.getPublishDate().getTime(), (oldBean.getReadCount() == null ? 0 : oldBean.getReadCount()));
          }
          String alertSuccess = isAuditEdit ? "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.modify.succces") + "');" : "";
          super.rendJavaScript(response, alertSuccess
                  + "try{if(window.opener){if (window.opener.getCtpTop().isCtpTop) {window.opener.getCtpTop().reFlesh();} else {window.opener.location.reload();}}}catch(e){}window.close();");
        }else{
          //客开end
          boolean isAuditEdit = "true".equals(request.getParameter("isAuditEdit"));
          NewsData bean = null;
          String idStr = request.getParameter("id");
          String imgUrl = request.getParameter("imgUrl");
          int oldState = Constants.DATA_STATE_NO_SUBMIT;
          Long oldImageId = 1L;
          if (StringUtils.isBlank(idStr)) {
              bean = new NewsData();
          } else {
              //从缓存里面取新闻
              bean = newsDataManager.getNewsData().get(Long.valueOf(idStr));
              if (bean == null) {
                  bean = newsDataManager.getById(Long.valueOf(idStr));
              }
              if (bean == null) {
                  super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.data.noexist") + "');" + "window.close();");
                  return null;
              }
              // 为下面发消息做判断---修改的是为审核，和审核不通过的，发不同的消息
              if (bean.getState() == Constants.DATA_STATE_ALREADY_CREATE) {
                  oldState = Constants.DATA_STATE_ALREADY_CREATE;
              } else if (bean.getState() == Constants.DATA_STATE_NOPASS_AUDIT) {
                  oldState = Constants.DATA_STATE_NOPASS_AUDIT;
              } else if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
                  oldState = Constants.DATA_STATE_ALREADY_PUBLISH;
              }
              //客开 start
              else if (bean.getState() == Constants.DATA_STATE_TYPESETTING_CREATE) {
                oldState = Constants.DATA_STATE_TYPESETTING_CREATE;
              } else if (bean.getState() == Constants.DATA_STATE_TYPESETTING_NOPASS) {
                oldState = Constants.DATA_STATE_TYPESETTING_NOPASS;
              }
              //客开 end
              oldImageId = bean.getImageId();
          }
          super.bind(request, bean);
          String newsTypeId = request.getParameter("newsType");
          if (Strings.isNotEmpty(newsTypeId)) {
              bean.setTypeId(Long.valueOf(newsTypeId));
          }

        NewsType oldType = bean.getType();
        boolean toDeleteAffair = false;
        if (oldType != null)
            toDeleteAffair = oldType.isAuditFlag();

        Long typeId = bean.getTypeId();
        NewsType type = this.newsDataManager.getNewsTypeManager().getById(typeId);
        bean.setType(type);
        bean.setSpaceType(type.getSpaceType());
        bean.setAccountId(type.getAccountId());

        if (bean.getKeywords() != null && "".equals(bean.getKeywords().trim()))
            bean.setKeywords(null);
        if (bean.getBrief() != null && "".equals(bean.getBrief().trim()))
            bean.setBrief(null);

        String publishDepartmentId = request.getParameter("publishDepartmentId");
        if (publishDepartmentId != null && !publishDepartmentId.equals("")) {
            bean.setPublishDepartmentId(Long.valueOf(publishDepartmentId));
            // SZP 客开 START
            /*
            if (publishDepartmentId.equals("-2329940225728493295")){
            	bean.setPublishDepartmentName("中国信达资产管理股份有限公司");
            }
            */
            // 设置公司名称
        	Map<String,String> accounts = orgManager.getAccountIdAndNames();
        	if(accounts.containsKey(publishDepartmentId)){
        		bean.setPublishDepartmentName(accounts.get(publishDepartmentId));
        	}
        	
            // SZP 客开 END
        }else{
        	bean.setPublishDepartmentId(-1010101010101010101L);
        	bean.setPublishDepartmentName("");
        }

        if (bean.getState() != null) {
            bean.getState().intValue();
        }
        if (bean.getPublishScope() == null) {
            bean.setPublishScope("");
        }

        String form_oper = request.getParameter("form_oper");
        if (StringUtils.isNotBlank(form_oper)) {
            if ("draft".equals(form_oper)) {
                bean.setState(Constants.DATA_STATE_NO_SUBMIT);
                bean.setAuditAdvice(null);
                bean.setPublishDate(null);
                bean.setPublishUserId(null);
                bean.setReadCount(0);
                bean.setUpdateDate(null);
                bean.setUpdateUser(null);
            } else if ("submit".equals(form_oper)) {
                if (type.isAuditFlag()) {
                    if(bean.getState()==null){
                    bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
                    }
					bean.setAuditUserId(type.getAuditUser());
                  }
                    
                if (type.isAuditFlag() && (bean.getState().intValue()!=25 && bean.getState().intValue()!=26 && bean.getState().intValue()!=27)) {
                      bean.setState(Constants.DATA_STATE_ALREADY_CREATE);
                  }else if(type.isTypesettingFlag()){
                    //客开 start
                    bean.setState(Constants.DATA_STATE_TYPESETTING_CREATE);
                    //客开 end
                } else {
                    // 改为直接发布
                    bean.setExt3(String.valueOf(String.valueOf(Constants.AUDIT_RECORD_NO)));
                    bean.setState(Constants.DATA_STATE_ALREADY_PUBLISH);
                    if (bean.getPublishDate() == null) {
                        bean.setPublishDate(new Date());
                    }
                    bean.setPublishUserId(AppContext.getCurrentUser().getId());
                }
                if (bean.getReadCount() == null) {
                    bean.setReadCount(0);
                }
            }
        } else {
            bean.setState(Constants.DATA_STATE_NO_SUBMIT);
            bean.setAuditAdvice(null);
            bean.setPublishDate(null);
            bean.setPublishUserId(null);
            bean.setReadCount(0);
            bean.setUpdateDate(null);
            bean.setUpdateUser(null);
        }
        Boolean firstInitFlag = Boolean.FALSE;
        if (bean.isNew()) {
            bean.setCreateDate(new Date());
            bean.setCreateUser(AppContext.getCurrentUser().getId());
            bean.setTopOrder(Byte.valueOf("0"));
            bean.setTopNumberOrder(Byte.valueOf("0"));
            firstInitFlag = Boolean.TRUE;
        }else{
            if (!bean.getTypeId().equals(typeId)) {
                bean.setTopNumberOrder(Byte.valueOf("0"));
            }
        }
        bean.setUpdateDate(new Date());
        bean.setUpdateUser(AppContext.getCurrentUser().getId());
        bean.setTopOrder(type.getTopCount());
        bean.setDataFormat(dataformat);
        if(!"HTML".equals(dataformat)){
            bean.setShareWeixin(false);
        }
        bean.setExt5(ext5);
        /**-------------图片新闻-----------------**/
        boolean imageNews = false;
        if (Strings.isNotBlank(request.getParameter("hasImg"))) {
            imageNews = "true".equals(request.getParameter("hasImg"));
        }
        bean.setImageNews(imageNews);
        boolean showPublishUserFlag = false;
        if (Strings.isNotBlank(request.getParameter("showPublish"))) {
            showPublishUserFlag = "true".equals(request.getParameter("showPublish"));
        }
        bean.setShowPublishUserFlag(showPublishUserFlag);
        //  boolean focusNews = Strings.isNotBlank(request.getParameter("focusNews"));
        //  bean.setFocusNews(focusNews);
        if (imageNews) {
            String imageIdStr = request.getParameter("imageId");
            Long imageId = NumberUtils.toLong(imageIdStr, 1L);
            if (!imageId.equals(oldImageId)) {
                bean.setImageId(imageId);
            }
        } else {
            bean.setImageId(null);
        }

        if (type.isAuditFlag() && (type.getSpaceType() == SpaceType.public_custom.ordinal() || type.getSpaceType() == SpaceType.public_custom_group.ordinal())) {
            Long auditId = bean.getType().getAuditUser();
            if (auditId != -1) {
                boolean isAlert = check(type.getAccountId(), auditId);
                if (isAlert) {
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    response.setContentType("text/html;charset=UTF-8");
                    out.println("<script type='text/javascript'>");
                    out.println("alert("+ResourceUtil.getString("news.not.audit.reset.audit.member")+")");//该新闻无法审核，请联系管理员重新设置审核员
                    out.println("</script>");
                    out.flush();
                    return null;
                }
            }
        }

        String attaFlag = null;
        // 已经提交审核的如果修改，需要发送消息
        boolean editAfterAudit = (oldState == Constants.DATA_STATE_ALREADY_CREATE);
        // 审核没有通过的修改
        boolean noAuditEdit = (oldState == Constants.DATA_STATE_NOPASS_AUDIT);
        // 不需要审核的板块发起者可直接修改已发布的新闻, 不需要管理员先撤消
        boolean noAuditPublishEdit = (oldState == Constants.DATA_STATE_ALREADY_PUBLISH);
          //客开 start
          // 已经提交排版的如果修改，需要发送消息
          boolean editAfterTypesetting = (oldState == Constants.DATA_STATE_TYPESETTING_CREATE);
          // 不需要排版的板块发起者可直接修改已发布的新闻, 不需要管理员先撤消
          boolean noTypesettinghEdit = (oldState == Constants.DATA_STATE_TYPESETTING_NOPASS);
          //客开 end

        boolean isNew = false;
        if (bean.isNew()) {
            //在保存的时候对新闻的格式进行处理
            isNew = true;
            bean.setIdIfNew();
            Long attRefId = Long.valueOf(request.getParameter("attRefId"));
            attachmentManager.deleteByReference(attRefId, attRefId);
        } else {
            attachmentManager.deleteByReference(bean.getId(), bean.getId());
            // 清除缓存
            if (newsDataManager.getNewsData().get(bean.getId()) != null) {
                newsDataManager.removeCache(bean.getId());
            }
        }

        bean.setAttachmentsFlag(false);
        bean.setImgUrl(imgUrl);
        List<Attachment> attList = attachmentManager.getAttachmentsFromRequest(ApplicationCategoryEnum.news, bean.getId(), bean.getId(), request);
        if (!imageNews) {
            for (Attachment att : attList) {
                //非图片格式的新闻 不保存栏目图片
                if (att.getType() == 5) {
                    attList.remove(att);
                    break;
                }
            }
        }
        attaFlag = attachmentManager.create(attList);
        if (com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attaFlag)) {
            bean.setAttachmentsFlag(true);
        }
        if (Strings.isNotBlank(spaceId) && bean.getAccountId() == null) {
            newsDataManager.saveCustomNews(bean, isNew);
        } else {
            newsDataManager.save(bean, isNew);
        }
        
        //更新缓存（集群）
        newsDataManager.getNewsData().remove(bean.getId());
        
        if (bean.getState() == Constants.DATA_STATE_ALREADY_PUBLISH) {
            //触发发布事件
            NewsAddEvent newsAddEvent = new NewsAddEvent(this);
            newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
            EventDispatcher.fireEvent(newsAddEvent);
        }
        newsDataManager.initDataFlag(bean, true);
        String deptName = bean.getPublishDepartmentName();
        
        // SZP 客开 START
        /*
        if (deptName.equals("-2329940225728493295")){
        	bean.setPublishDepartmentName("中国信达资产管理股份有限公司");
        }
        */
        // 设置公司名称
    	Map<String,String> accounts = orgManager.getAccountIdAndNames();
    	if(accounts.containsKey(deptName)){
    		bean.setPublishDepartmentName(accounts.get(deptName));
    	}else if (deptName.equals("-1010101010101010101")){
	    	bean.setPublishDepartmentName("");
	    }
	    // SZP 客开 END
        // 发送要审合公告消息消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_CREATE) && !isAuditEdit) {
            Long agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.news.getKey());

            if (editAfterAudit) {
                // 提交后修改
                userMessageManager.sendSystemMessage(MessageContent.get("news.edit", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                        MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                if (agentId != null) {//给代理人发消息,后缀(代理)
                    userMessageManager.sendSystemMessage(MessageContent.get("news.edit", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(),
                            MessageReceiver.get(bean.getId(), agentId, "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                }

                // 待审核如果修改加日志
                appLogManager.insertLog(user, AppLogAction.News_Modify, userName, bean.getTitle());
                //审核员未进行审核前修改公告并再次发送，需另行增加一条待办事项记录，先删除旧有记录，再生成新的记录 added by Meng Yang at 2009-07-15
                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
                this.addPendingAffair(type, bean);
            } else if (noAuditEdit) {
                userMessageManager.sendSystemMessage(MessageContent.get("news.send", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                        MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                if (agentId != null) {//给代理人发消息,后缀(代理)
                    userMessageManager.sendSystemMessage(MessageContent.get("news.send", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(),
                            MessageReceiver.get(bean.getId(), agentId, "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                }

                  //审核不通过修改后在发布审核加日志
                  appLogManager.insertLog(user, AppLogAction.News_Modify, userName, bean.getTitle());

                  //审核不通过后修改，再次发送给审核员进行审核，也需要增加一条对应的待办事项 added by Meng Yang at 2009-07-14
                  this.addPendingAffair(type, bean);
              }
              //客开 start
              else if (editAfterTypesetting) {
                userMessageManager.sendSystemMessage(MessageContent.get("news.send2", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                        MessageReceiver.get(bean.getId(), type.getTypesettingStaff(), "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                if (agentId != null) {//给代理人发消息,后缀(代理)
                    userMessageManager.sendSystemMessage(MessageContent.get("news.send2", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(),
                            MessageReceiver.get(bean.getId(), agentId, "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                }
                //审核不通过修改后在发布审核加日志
                appLogManager.insertLog(user, AppLogAction.News_Modify, userName, bean.getTitle());

                //审核不通过后修改，再次发送给审核员进行审核，也需要增加一条对应的待办事项 added by Meng Yang at 2009-07-14
                this.addPendingAffair(type, bean);
              }else if (noTypesettinghEdit) {
                userMessageManager.sendSystemMessage(MessageContent.get("news.send2", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                    MessageReceiver.get(bean.getId(), type.getTypesettingStaff(), "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                if (agentId != null) {//给代理人发消息,后缀(代理)
                    userMessageManager.sendSystemMessage(MessageContent.get("news.send2", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(),
                            MessageReceiver.get(bean.getId(), agentId, "message.link.news.auditing", String.valueOf(bean.getId())), type.getId());

                }

                //审核不通过修改后在发布审核加日志
                appLogManager.insertLog(user, AppLogAction.News_Modify, userName, bean.getTitle());

                //审核不通过后修改，再次发送给审核员进行审核，也需要增加一条对应的待办事项 added by Meng Yang at 2009-07-14
                this.addPendingAffair(type, bean);
              }
              //客开end
              else {
                // 新建提交
                // 2007.12.12 加入审核员的待办事项
                this.addPendingAffair(type, bean);
                userMessageManager.sendSystemMessage(MessageContent.get("news.send", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                        MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.news.alreadyauditing", String.valueOf(bean.getId())), type.getId());

                if (agentId != null) {//给代理人发消息,后缀(代理)
                    userMessageManager.sendSystemMessage(MessageContent.get("news.send", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(),
                            MessageReceiver.get(bean.getId(), agentId, "message.link.news.alreadyauditing", String.valueOf(bean.getId())), type.getId());
                }

                //发布审核加日志<新建新闻>
                appLogManager.insertLog(user, AppLogAction.News_New, userName, bean.getTitle());
            }
        } else if (bean.getState().equals(Constants.DATA_STATE_NO_SUBMIT)) {
            //发布审核加日志<修改新闻>
            appLogManager.insertLog(user, AppLogAction.News_Modify, userName, bean.getTitle());
        } else if (isAuditEdit && !bean.getCreateUser().equals(AppContext.currentUserId())) {//审核修改后，给发起人发送消息包括代理
            userMessageManager.sendSystemMessage(MessageContent.get("news.edit", bean.getTitle(), userName), ApplicationCategoryEnum.news, user.getId(),
                    MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.news.writedetail", String.valueOf(bean.getId())));
            Long agentId = AgentUtil.getAgentByApp(bean.getCreateUser(), ApplicationCategoryEnum.news.getKey());
            if (agentId != null) {//给代理人发消息,后缀(代理)
                MessageReceiver receiver = MessageReceiver.get(bean.getId(), agentId, "message.link.news.writedetail", String.valueOf(bean.getId()));
                userMessageManager.sendSystemMessage(MessageContent.get("news.edit", bean.getTitle(), userName).add("col.agent"), ApplicationCategoryEnum.news, user.getId(), receiver);
            }
        }

        // 直接发送不审合消息
        if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
            Set<Long> resultIds = new HashSet<Long>();
            List<V3xOrgMember> listMemberId = new ArrayList<V3xOrgMember>();
            if (type.getSpaceType() == SpaceType.custom.ordinal()) {
                listMemberId = spaceManager.getSpaceMemberBySecurity(typeId, -1);
            } else if (type.getSpaceType() == SpaceType.public_custom.ordinal() || type.getSpaceType() == SpaceType.public_custom_group.ordinal()) {
                listMemberId = spaceManager.getSpaceMemberBySecurity(type.getAccountId(), -1);
            } else {
                listMemberId = this.newsUtils.getScopeMembers(type.getSpaceType(), user.getLoginAccount(), type.getOutterPermit());
            }
            for (V3xOrgMember member : listMemberId) {
                resultIds.add(member.getId());
            }
            //发送消息
            userMessageManager.sendSystemMessage(
                    MessageContent.get(noAuditPublishEdit ? "news.publishEdit" : "news.auditing", bean.getTitle(), deptName).setBody(bean.getContent(), bean.getDataFormat(), bean.getCreateDate()),
                    ApplicationCategoryEnum.news, AppContext.currentUserId(),
                    MessageReceiver.getReceivers(bean.getId(), resultIds, "message.link.news.assessor.auditing", String.valueOf(bean.getId())), bean.getTypeId());

            // 直接发布加日志
            appLogManager.insertLog(user, noAuditPublishEdit ? AppLogAction.News_Modify : AppLogAction.News_Publish, userName, bean.getTitle());

            //如果是从有审核的板块切换到无审核的板块，需要删除之前的待办事项
            if (toDeleteAffair) {
                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.news, bean.getId());
            }
        }

        // 这里加入全文检索
        try {
            if (bean.getState().equals(Constants.DATA_STATE_ALREADY_PUBLISH)) {
                if (firstInitFlag) {
                    if (AppContext.hasPlugin("index")) {
                        indexManager.add(bean.getId(), ApplicationCategoryEnum.news.getKey());
                    }
                } else {
                    // 更新在此进行
                    if (AppContext.hasPlugin("index")) {
                        indexManager.update(bean.getId(), ApplicationCategoryEnum.news.getKey());
                    }
                }
            }
        } catch (Exception e) {
            log.error("全文检索: ", e);
        }

          //对新闻文件进行解锁
          if (!"".equalsIgnoreCase(idStr) && idStr != null) {
              newsDataManager.unlock(Long.valueOf(idStr));
          }
          String alertSuccess = isAuditEdit ? "alert('" + ResourceBundleUtil.getString(Constants.NEWS_RESOURCE_BASENAME, "news.modify.succces") + "');" : "";
          super.rendJavaScript(response, alertSuccess
                  + "try{if(window.opener){if (window.opener.getCtpTop().isCtpTop) {window.opener.getCtpTop().reFlesh();} else {window.opener.location.reload();}}}catch(e){}window.close();");
        }
        return null;
    }

    /**
     * 新闻预览
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView newsPreview(HttpServletRequest request, HttpServletResponse response) throws Exception {
        NewsData bean = new NewsData();
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String userName = user.getName();
        String previewTitle = request.getParameter("previewTitle");
        String previewBrief = request.getParameter("previewBrief");
        String previewKeywords = request.getParameter("previewKeywords");
        String idStr = request.getParameter("id");
        String publishFlag = request.getParameter("showPublish");
        super.bind(request, bean);
        String newsTypeId = request.getParameter("newsType");
        if (Strings.isNotEmpty(newsTypeId)) {
            bean.setTypeId(Long.valueOf(newsTypeId));
        }
        NewsType type = this.newsTypeManager.getById(Long.valueOf(newsTypeId));
        bean.setType(type);
        bean.setTitle(previewTitle);
        bean.setBrief(previewBrief);
        bean.setKeywords(previewKeywords);
        ModelAndView mav = new ModelAndView("news/newsView");
        Long newId = UUIDLong.longUUID();
        String attaFlag = attachmentManager.create(ApplicationCategoryEnum.news, newId, newId, request);
        Long attRefId = newId;
        List<Attachment> attachments = attachmentManager.getByReference(attRefId, attRefId);
        bean.setId(attRefId);
        bean.setCreateUser(userId);
        bean.setCreateDate(new Date());
        bean.setState(Constants.DATA_STATE_NO_SUBMIT);
        /**  图片新闻 **/
        bean.setImageNews(Strings.isNotBlank(request.getParameter("imageId")));
        String imageId = request.getParameter("imageId");
        if (Strings.isNotBlank(imageId)) {
            bean.setImageId(NumberUtils.toLong(imageId));
        }
        mav.addObject("typeName", type.getTypeName());
        boolean showKeyWords = Strings.isNotBlank(bean.getKeywords());
        boolean showBrief = Strings.isNotBlank(bean.getBrief());
        bean.setShowKeywordsArea(showKeyWords);
        bean.setShowBriefArea(showBrief);
        bean.setReadCount(0);
        if ("true".equals(publishFlag)) {
            bean.setShowPublishUserFlag(true);
            bean.setCreateUserName(userName);
        }
        mav.addObject("bean", bean);
        mav.addObject("replyNum", 0);
        mav.addObject("attachments", attachments);
        return mav;
    }

    /**
     * 是否有 发起权限/审核权限
     * [0] hasIssue
     * [1] hasAudit
     * @param spaceType
     * @param spaceId
     * @param user
     * @return
     * @throws BusinessException 
     */
    public boolean[] hasPermission(int spaceType, Long spaceId, User user) throws BusinessException {
        boolean hasIssue = false;
        boolean hasAudit = false;
      //客开 start
        boolean hasTypesetting = false;
      //客开 end
        List<NewsType> myNewsTypeList = new ArrayList<NewsType>();
        if (spaceType == SpaceType.public_custom_group.ordinal()) {//自定义集团空间
            List<NewsType> customNewsTypeList = newsTypeManager.findAllOfCustom(spaceId, "publicCustomGroup");
            myNewsTypeList.addAll(customNewsTypeList);
        } else if (spaceType == SpaceType.public_custom.ordinal()) {//自定义单位空间
            List<NewsType> customNewsTypeList = newsTypeManager.findAllOfCustom(spaceId, "publicCustom");
            myNewsTypeList.addAll(customNewsTypeList);
        } else if (spaceType == SpaceType.custom.ordinal()) {//自定义团队空间
            NewsType customNewsType = newsTypeManager.getById(spaceId);
            myNewsTypeList.add(customNewsType);
        } else {
            // 集团版块
            List<NewsType> groupNewsTypeList = newsDataManager.getNewsTypeManager().groupFindAll();
            myNewsTypeList.addAll(groupNewsTypeList);
            // 单位版块
            List<NewsType> accountNewsTypeList = newsTypeManager.findAll(user.getLoginAccount());
            myNewsTypeList.addAll(accountNewsTypeList);
        }
        if (Strings.isNotEmpty(myNewsTypeList)) {
            for (NewsType newsType : myNewsTypeList) {
                if (user.isInternal() || newsType.getOutterPermit()) {
                    if (!hasIssue) {
                        List<Long> domainIds = orgManager.getAllUserDomainIDs(user.getId());
                        for (NewsTypeManagers tm : newsType.getNewsTypeManagers()) {
                            if (domainIds.contains(tm.getManagerId())) {
                                if (Constants.MANAGER_FALG.equals(tm.getExt1())) {
                                    hasIssue = true;
                                } else if (Constants.WRITE_FALG.equals(tm.getExt1())) {
                                    hasIssue = true;
                                }
                            }
                        }
                    }
                    if (newsType.isAuditFlag() && newsType.getAuditUser().longValue() == user.getId()) {
                        hasAudit = true;
                    }
                  //客开 start
                    if ( newsType.isTypesettingFlag() && newsType.getTypesettingStaff().longValue() == user.getId()) {
                      hasTypesetting = true;
                  }
                    //客开 end
                }
            }
        }
        return new boolean[] { hasIssue, hasAudit,hasTypesetting };
    }

}
