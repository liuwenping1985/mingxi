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
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.bulletin.controller.BulDataController;
import com.seeyon.v3x.bulletin.domain.BulBody;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.manager.BulDataManager;
import com.seeyon.v3x.bulletin.manager.BulReadManager;
import com.seeyon.v3x.bulletin.manager.BulTypeManager;
import com.seeyon.v3x.bulletin.util.BulletinUtils;
import com.seeyon.v3x.news.controller.NewsDataController;
import com.seeyon.v3x.news.manager.NewsDataManager;
import com.seeyon.v3x.news.manager.NewsIssueManager;
import com.seeyon.v3x.news.manager.NewsReadManager;
import org.apache.axis.utils.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    private SystemConfig systemConfig;
    private  SystemConfig getSystemConfig() {
        if (systemConfig == null) {
            systemConfig = (SystemConfig)AppContext.getBean("systemConfig");
        }
        return systemConfig;
    }

    public  String getSystemSwitch(String name) {
        return getSystemConfig().get(name);
    }

    @NeedlessCheckLogin
    public ModelAndView getDepartmentListGroupByAccount(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        List<V3xOrgAccount> accountList = this.getOrgManager().getAllAccounts();
        Map<String, Object> data = new HashMap<String, Object>();
        List<RikazeAccountVo> dataList = new ArrayList<RikazeAccountVo>();
        if (accountList != null && accountList.size() > 0) {
            for(V3xOrgAccount account:accountList){
                RikazeAccountVo accountVo = new RikazeAccountVo();
                accountVo.setAccountId(String.valueOf(account.getId()));
                accountVo.setV3xOrgAccount(account);
                List<V3xOrgDepartment> depts = this.getOrgManager().getAllDepartments(account.getId());
                List<RikazeDeptVo> deptVoList = new ArrayList<RikazeDeptVo>();
                for(V3xOrgDepartment department:depts){
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
        data.put("items",dataList);
        com.seeyon.ctp.common.taglibs.functions.Functions funs;
        DataKitSupporter.responseJSON(data,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView getDepartmentMemberList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        Map<String,Object> data = new HashMap<String, Object>();
        String deptId = request.getParameter("deptId");
        if(deptId == null||"".equals(deptId)){
            data.put("items",new ArrayList());
        }else{
            List<V3xOrgMember> list = this.getOrgManager().getAllMembersByDepartmentBO(Long.parseLong(deptId));
           List<RikazeMemberVo> dataList = new ArrayList<RikazeMemberVo>();
           for(V3xOrgMember member:list){
              RikazeMemberVo vo = new RikazeMemberVo();
              vo.setDepartmentId(String.valueOf(member.getOrgDepartmentId()));
              vo.setMemberId(String.valueOf(member.getId()));
              vo.setMemberName(member.getName());
              vo.setV3xOrgMember(member);
              //vo.setAvtar(getAvatarImageUrl(member.getId()));
              dataList.add(vo);
           }
            data.put("items",dataList);
        }
        DataKitSupporter.responseJSON(data,response);
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
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem");
            data.put("buls", dataList);
            DataKitSupporter.responseJSON(data, response);
            NewsDataController controller;
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        } catch (Error e) {
            e.printStackTrace();
        }
        data.put("buls", "error");
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
        NewsDataController ndc;
        String ord = "1";
        Long fgId = Long.parseLong(fragementId);
        int count = pendingManager.getPendingCount(memberId, fgId, ord);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("count", count);
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


    private BulReadManager bulReadManager;

    private BulReadManager getBulReadManager() {
        if (bulReadManager != null) {
            return bulReadManager;
        }
        bulReadManager = (BulReadManager) AppContext.getBean("bulReadManager");
        return bulReadManager;
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
