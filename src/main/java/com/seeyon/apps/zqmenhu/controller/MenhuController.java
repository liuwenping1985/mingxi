package com.seeyon.apps.zqmenhu.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.doc.controller.DocController;
import com.seeyon.apps.doc.dao.DocActionDaoImpl;
import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.manager.*;
import com.seeyon.apps.doc.po.DocActionPO;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.DocMVCUtils;
import com.seeyon.apps.form.enums.FormEnums;
import com.seeyon.apps.m3.app.vo.AppInfoVO;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.zqmenhu.po.BulDataItem;
import com.seeyon.apps.zqmenhu.po.NewsDataItem;
import com.seeyon.apps.zqmenhu.service.MenhuService;
import com.seeyon.apps.zqmenhu.util.Helper;
import com.seeyon.apps.zqmenhu.vo.*;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyController;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.*;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.privilege.enums.ResourceCategoryEnums;
import com.seeyon.ctp.privilege.enums.ResourceTypeEnums;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.bulletin.controller.BulDataController;
import com.seeyon.v3x.bulletin.domain.BulRead;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.news.controller.NewsDataController;
import com.seeyon.v3x.news.domain.NewsType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;
import www.seeyon.com.utils.Base64Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.*;


public class MenhuController extends BaseController {
    private static Logger LOG = LoggerFactory.getLogger(MenhuController.class);
    private MenhuService menHuService;
    private PrincipalManager principalManager = null;
    private AttachmentManager attachmentManager;
    private OrgManager orgManager;
    private DocLibManager docLibManager = null;

    private FileManager fileManager;

    private DocHierarchyManager docHierarchyManager;

    private DocAclNewManager docAclNewManager;

    private OperationlogManager operationlogManager;

    public FileManager getFileManager() {
        if (fileManager == null) {
            fileManager = (FileManager) AppContext.getBean("fileManager");
        }
        return fileManager;
    }
    public DocHierarchyManager getDocHierarchyManager() {
        if (docHierarchyManager == null) {
            docHierarchyManager = (DocHierarchyManager) AppContext.getBean("docHierarchyManager");
        }
        return docHierarchyManager;
    }
    public OperationlogManager getOperationlogManager() {
        if (operationlogManager == null) {
            operationlogManager = (OperationlogManager) AppContext.getBean("operationlogManager");
        }
        return operationlogManager;
    }

    public DocAclNewManager getDocAclNewManager(){
        if (docAclNewManager == null) {
            docAclNewManager = (DocAclNewManager) AppContext.getBean("docAclNewManager");
        }
        return docAclNewManager;
    }

    private Integer parseEntranceType(DocLibPO docLib) {
        Integer entranceType = 6;
        if (docLib.getType() == Constants.PERSONAL_LIB_TYPE) {
            entranceType = 1;
        } else if (docLib.getType() == Constants.EDOC_LIB_TYPE) {
            entranceType = 9;
        }
        return entranceType;
    }

    public MenhuService getMenHuService() {
        return menHuService;
    }

    public void setMenHuService(MenhuService menHuService) {
        this.menHuService = menHuService;
    }

    public PrincipalManager getPrincipalManager() {
        if (principalManager == null) {
            principalManager = (PrincipalManager) AppContext.getBean("principalManager");
        }
        return principalManager;
    }

    public DocLibManager getDocLibManager() {
        if (docLibManager == null) {
            docLibManager = (DocLibManager) AppContext.getBean("docLibManager");
        }
        return docLibManager;
    }

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    private void preResponse(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS, PATCH");
        response.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type,Token,Accept, Connection, User-Agent, Cookie");
        response.setHeader("Access-Control-Max-Age", "3628800");
    }


    @NeedlessCheckLogin
    public ModelAndView checkUserInfo(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
//查用户信息
        preResponse(response);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("result", false);
        data.put("msg", "");
        String userName = request.getParameter("userName");

        //dm
        String password = request.getParameter("password");
        if (userName == null) {
            data.put("msg", "用户名为空");
            Helper.responseJSON(data, response);
            return null;
        }
        if (password == null) {
            password = "";
        }
        userName = new String(Base64.decodeBase64(userName.getBytes()));
        password = new String(Base64.decodeBase64(password.getBytes()));
        MessageEncoder encode = null;
        try {
            encode = new MessageEncoder();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            data.put("msg", "OA加密算法错误");
            Helper.responseJSON(data, response);
            return null;
        }

        Long memId = null;
        try {
            memId = getPrincipalManager().getMemberIdByLoginName(userName);
        } catch (NoSuchPrincipalException e) {
            data.put("msg", "用户名不存在");
            Helper.responseJSON(data, response);
            e.printStackTrace();
            return null;
        }
        if (memId == null) {
            data.put("msg", "用户名不存在");
            Helper.responseJSON(data, response);
            return null;
        }

        try {
            String pwdC = encode.encode(userName, password);
            String cr = getPrincipalManager().getPassword(memId);
            if (cr.equals(pwdC)) {

                V3xOrgMember member = this.getOrgManager().getMemberById(memId);
                V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
                String avatar = Functions.getAvatarImageUrl(memId);
                Map<String, String> userInfo = new HashMap<String, String>();
                Long postId = member.getOrgPostId();
                V3xOrgPost post = getOrgManager().getPostById(postId);
                userInfo.put("name", member.getName());
                if (post != null) {
                    userInfo.put("post", post.getName());
                } else {
                    userInfo.put("post", "");
                }
                V3xOrgLevel orgLevel = getOrgManager().getLevelById(member.getOrgLevelId());
                if (orgLevel != null) {
                    userInfo.put("orgLevel", orgLevel.getName());
                } else {
                    userInfo.put("orgLevel", "");
                }
                userInfo.put("departmentName", dept.getName());
                userInfo.put("avatar", avatar);
                data.put("msg", "成功");
                data.put("result", true);
                data.put("userInfo", userInfo);
                Helper.responseJSON(data, response);
                return null;
            } else {
                data.put("msg", "密码错误");
                Helper.responseJSON(data, response);
                return null;
            }
        } catch (NoSuchPrincipalException e) {
            e.printStackTrace();
            data.put("msg", "用户名不存在");
            Helper.responseJSON(data, response);
            return null;
        }
    }

    //查新闻类型列表
    @NeedlessCheckLogin
    public ModelAndView getNewsTypeList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            List<NewsType> newsTypeList = DBAgent.find("from NewsType where usedFlag =1");
            if (CollectionUtils.isEmpty(newsTypeList)) {
                data.setMsg("NO-DATA");
                Helper.responseJSON(data, response);
                return null;
            }
            List<TypeVo> types = new ArrayList<TypeVo>();
            for (NewsType type : newsTypeList) {
                TypeVo vo = new TypeVo();
                vo.setSort(String.valueOf(type.getSortNum()));
                vo.setTypeId(String.valueOf(type.getId()));
                vo.setTypeName(type.getTypeName());
                try {
                    V3xOrgAccount account = this.getOrgManager().getAccountById(type.getAccountId());
                    if (account != null) {
                        vo.setAccountName(account.getName());
                    }
                } catch (Exception e) {

                }
                vo.setAccountId(type.getAccountId());

                types.add(vo);
            }
            data.setItems(types);
            // data.put("news", newsDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin  //得到文档库类型
    public ModelAndView getDocTypeList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            List<DocLibPO> docTypeList = DBAgent.find("from DocLibPO ");
            if (CollectionUtils.isEmpty(docTypeList)) {
                data.setMsg("NO-DATA");
                Helper.responseJSON(data, response);
                return null;
            }

            data.setItems(docTypeList);
            // data.put("news", newsDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    //得公告类型列表
    @NeedlessCheckLogin
    public ModelAndView getBulletinTypeList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {

            List<BulType> bulsTypeList = DBAgent.find("from BulType where usedFlag=1");
            List<TypeVo> typeList = new ArrayList<TypeVo>();
            for (BulType type : bulsTypeList) {
                TypeVo vo = new TypeVo();
                typeList.add(vo);
                vo.setSort(String.valueOf(type.getSortNum()));
                vo.setTypeId(String.valueOf(type.getId()));
                vo.setTypeName(type.getTypeName());
                vo.setAccountId(type.getAccountId());
                try {
                    V3xOrgAccount account = this.getOrgManager().getAccountById(vo.getAccountId());
                    if (account != null) {
                        vo.setAccountName(account.getName());
                    }
                } catch (Exception e) {

                }

            }
            data.setItems(typeList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    //得文档列表
    @NeedlessCheckLogin
    public ModelAndView getDocList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            Long typeId = p.getTypeId();
            String sql = "from DocResourcePO where parentFrId =  " + typeId + " order by createTime desc";
            List<DocResourcePO> docDataList = DBAgent.find(sql);
            List<DocResourcePO> pagingDocDataList = Helper.paggingList(docDataList, p);
            data.setItems(transToDocVo(pagingDocDataList));
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }
    //

    public ModelAndView getFavorCollection(HttpServletRequest request, HttpServletResponse response) {

        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            DocResourceDao docResourceDao = (DocResourceDao) AppContext.getBean("docResourceDao");
            User user = AppContext.getCurrentUser();
            String userName = user.getName();
            //DocLibManager docLibManager = (DocLibManager)AppContext.getBean("docLibManager");
            //DocLibPO docLibPo = docLibManager.getPersonalLibOfUser(user.getId());
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("userName", userName);
            //params.put("docLibId", String.valueOf(docLibPo.getId()));
            List<DocResourcePO> poList = docResourceDao.findFavoriteByCondition(params);
            List<DocResourcePO> pagingFavor = Helper.paggingList(poList, p);
            data.setItems(pagingFavor);
            Helper.responseJSON(data, response);
            //  System.out.println("params："+params);
            //System.out.println("list："+poList);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getNewsByAccountAndDepartment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        this.preResponse(response);
        CommonResultVo data = new CommonResultVo();

        try {
            String orgSql = "from NewsDataItem where state=30 and typeId=1 order by createDate desc";
            String orgCountStr = request.getParameter("orgCount");
            String deptCountStr = request.getParameter("deptCount");
            String deptId = request.getParameter("deptId");
            if (CommonUtils.isEmpty(orgCountStr)) {
                orgCountStr = "3";
            }

            int orgCount = Integer.parseInt(orgCountStr);
            if (CommonUtils.isEmpty(deptCountStr)) {
                deptCountStr = "3";
            }

            int deptCount = Integer.parseInt(deptCountStr);
            List<NewsDataItem> retList = new ArrayList();
            Integer leftCount = orgCount + deptCount;
            List<NewsDataItem> newsDataItemList = DBAgent.find(orgSql);

            if (!CommonUtils.isEmpty(newsDataItemList)) {
                int size = newsDataItemList.size();
                if (size > orgCount) {
                    leftCount = leftCount - orgCount;
                    retList.addAll(newsDataItemList.subList(0, orgCount));
                } else {
                    leftCount = leftCount - size;
                    retList.addAll(newsDataItemList);
                }
            }

            String deptSql = "from NewsDataItem where state=30 and typeId!=1 order by createDate desc";
            newsDataItemList = DBAgent.find(deptSql);
            if (!CommonUtils.isEmpty(newsDataItemList)) {
                int size = newsDataItemList.size();
                if (size > leftCount) {
                    retList.addAll(newsDataItemList.subList(0, leftCount));
                } else {
                    retList.addAll(newsDataItemList);
                }
            }
          //  List<Map> contain = new ArrayList<Map>();
            List<NewsVo> contain= transToNewsVo(retList);
//            for (NewsDataItem item : retList) {
//                String sJson = JSON.toJSONString(item);
//                Map map = JSON.parseObject(sJson, HashMap.class);
//                map.put("link", "/seeyon/newsData.do?method=newsView&newsId=" + map.get("id"));
//                contain.add(map);
//
//            }
            data.setItems(contain);
            data.setResult(true);
        } catch (Exception var15) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + var15.getMessage());
            var15.printStackTrace();
        } catch (Error var16) {
            data.setResult(false);
            data.setMsg("ERROR:" + var16.getMessage());
            var16.printStackTrace();
        }

        Helper.responseJSON(data, response);
        return null;
    }


    @NeedlessCheckLogin
    public ModelAndView getFormmainList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();

        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "";
            if (p.getTypeId() != null) {
                sql = "select * from formmain_0732 where field0001=" + p.getTypeId();
            }
            List<Map> formDataList = DataBaseHelper.executeQueryByNativeSQL(sql);
            formDataList = Helper.paggingList(formDataList, p);
            for (Map fd : formDataList) {
                fd.put("link", "/seeyon/menhu.do?method=openLink&openType=form&id=" + fd.get("id"));
            }
            data.setItems(formDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }

        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getSuperviseList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);

        CommonResultVo data = new CommonResultVo();
        try {
            User user = AppContext.getCurrentUser();
            String sql1 = "";
            if (user == null) {
                sql1 = "select * from ctp_supervise_detail";
            } else {
                sql1 = "select * from ctp_supervise_detail where forward_member=" + user.getId();
            }

            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);

//            ApplicationCategoryEnum enum2;
            List<Map> formDataList = DataBaseHelper.executeQueryByNativeSQL(sql1);
            formDataList = Helper.paggingList(formDataList, p);
            for (Map fd : formDataList) {

                // maps.put("link","/seeyon/collaboration/collaboration.do?method=summary&affairId="+maps.get("affair_id")+"&summaryId="+maps.get("entity_id")+"&openFrom=supervise&type="+maps.get("status"));
                fd.put("link", "/seeyon/menhu.do?method=openLink&linkType=supervise&id=" + fd.get("id"));
            }
            data.setItems(formDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    /**
     * //查单位图片新闻
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @NeedlessCheckLogin
    public ModelAndView getImgNewList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from NewsDataItem where state=30 order by createDate desc";
            if (p.getTypeId() != null) {
                sql = "from NewsDataItem where state=30 and typeId=" + p.getTypeId() + " order by createDate desc";
            }

            //DBAgent.find
            List<NewsDataItem> newsDataList = DBAgent.find(sql);
            //
            AttachmentManager impl = null;
            List<NewsDataItem> retNewsDataList = new ArrayList<NewsDataItem>();
            for (NewsDataItem item : newsDataList) {
                if (item.isImageNews()) {
                    retNewsDataList.add(item);
                }
            }
            List<NewsDataItem> pagingNewsDataList = Helper.paggingList(retNewsDataList, p);
            data.setItems(transToNewsVo(pagingNewsDataList));

            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    /**
     * //查Mime类型
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @NeedlessCheckLogin
    public ModelAndView getNewList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String departmentId = request.getParameter("deptId");
            String sql = "from NewsDataItem where state=30 order by createDate desc";
            if (p.getTypeId() != null) {
                sql = "from NewsDataItem where state=30 and typeId=" + p.getTypeId() + " order by createDate desc";
            }
            if (departmentId != null) {
                sql = "from NewsDataItem where state=30 and typeId=" + p.getTypeId() + " and publishDepartmentId=" + departmentId + " order by createDate desc";
            }

            List<NewsDataItem> newsDataList = DBAgent.find(sql);
            AttachmentManager impl = (AttachmentManager) AppContext.getBean("attachmentManager");
            List<NewsDataItem> retNewsDataList = new ArrayList<NewsDataItem>();
            for (NewsDataItem item : newsDataList) {
                if (item.getAttachmentsFlag()) {
                    List<Attachment> attachments = impl.getByReference(item.getId());
                    List<String> list = new ArrayList<String>();
                    for (Attachment attch : attachments) {
                        list.add(attch.getMimeType());
                    }
                    item.setMimeTypes(list);
                    retNewsDataList.add(item);
                } else {
                    retNewsDataList.add(item);
                }
            }
            List<NewsDataItem> pagingNewsDataList = Helper.paggingList(retNewsDataList, p);
            data.setItems(transToNewsVo(pagingNewsDataList));

            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }


    //查事务列表
    @NeedlessCheckLogin
    public ModelAndView getUserCptList(HttpServletRequest request, HttpServletResponse response) {
        preResponse(response);
        User user = AppContext.getCurrentUser();
        CommonResultVo data = new CommonResultVo();
        Long userId = null;
        String subState = request.getParameter("subState");
        String appType = request.getParameter("appType");
        String count = request.getParameter("$count");
        if (user == null) {
            userId = 8180340772611837618L;
        }else{
            userId = user.getId();
        }

        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            StringBuilder sql = new StringBuilder("from CtpAffair where 1=1 ");
            StringBuilder countSql = new StringBuilder("select count(*) from CtpAffair where 1=1 ");
            Long state = p.getTypeId();
            if (state == null) {
                state = 3L;
            }
            CtpAffair cd;
            sql.append(" and state="+state);
            countSql.append(" and state="+state);
           // sql.append("and state="+state);
            if (subState != null) {
                sql.append(" and subState="+ subState );
                countSql.append(" and subState="+ subState );
            }
            if (userId != null) {
                sql.append(" and memberId=" + userId);
                countSql.append(" and memberId=" + userId);
            }
            if(appType!=null){
                if("4".equals(appType)){
                    sql.append(" and app in(4,19,20,21)");
                    countSql.append(" and app in(4,19,20,21)");
                }else{
                    sql.append(" and app=" + appType);
                    countSql.append(" and app=" + appType);
                }

            }else{
                sql.append(" and app in(1,2,3,4,6,19,20,21)");
                countSql.append(" and app in(1,2,3,4,6,19,20,21)");
            }
            sql.append(" and is_delete =0");
            countSql.append(" and is_delete =0");
            sql.append(" order by createDate desc");


            Integer offset = p.getOffset();
            Integer limit = p.getLimit();
            FlipInfo info = new FlipInfo();

            info.setPage(offset/limit);
            info.setSize(limit);

            List<CtpAffair> ctpaffair = DBAgent.find(sql.toString(),null,info);;

            if("true".equals(count)){
                Integer count_ = DBAgent.count(countSql.toString());
                data.setCount(count_);
            }
            //List<CtpAffair> paggingctpaffairs = Helper.paggingList(ctpaffair, p);
            data.setItems(wrapperCtpAffairList(ctpaffair));

            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;

    }

    private SimpleDateFormat formt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    //重点，查包装事务列表
    private List wrapperCtpAffairList(List<CtpAffair> affairList) {


        List retList = new ArrayList();


        if (CommonUtils.isEmpty(affairList)) {
            return retList;
        }

        for (CtpAffair ctpAffair : affairList) {

            String jsonMap = JSON.toJSONString(ctpAffair);

            Map data = JSON.parseObject(jsonMap, HashMap.class);
            data.put("link", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId=" + data.get("id"));
            try {
                if (ctpAffair != null) {
                    V3xOrgMember member = orgManager.getMemberById(ctpAffair.getSenderId());
                    if (member != null) {
                        data.put("senderName", member.getName());
                        data.put("receiveFormatDate", formt.format(ctpAffair.getReceiveTime()));
                    }
                }

            } catch (BusinessException e) {
            }
            retList.add(data);

        }
        return retList;

    }



    private List<NewsVo> transToNewsVo(List<NewsDataItem> newsDataList) {
        List<NewsVo> retList = new ArrayList<NewsVo>();
        if (CollectionUtils.isEmpty(newsDataList)) {
            return retList;
        }

        List<Long> idList = new ArrayList<Long>();
        User user = AppContext.getCurrentUser();
        for (NewsDataItem item : newsDataList) {
            NewsVo vo = new NewsVo();
            retList.add(vo);
            vo.setTitle(item.getTitle());
            idList.add(item.getId());
            vo.setAccountId(item.getAccountId());
            vo.setCreateDate(item.getCreateDate());
            vo.setUpdateDate(item.getUpdateDate());
            vo.setPublishDate(item.getUpdateDate());
            vo.setReadCount(item.getReadCount());
            vo.setImgNews(item.isImageNews());
            vo.setFocusNews(item.isFocusNews());
            vo.setBrief(item.getBrief());
            vo.setId(String.valueOf(item.getId()));
            Long imageId = item.getImageId();
            if (imageId != null) {
                vo.setImgUrl("/seeyon/commonimage.do?method=showImage&id=" + imageId);
            }
            vo.setCreateUserId(item.getCreateUser());
            vo.setPublishDepartmentId(item.getPublishDepartmentId());
            vo.setPublishUserId(item.getPublishUserId());
            vo.setAttachmentsFlag(item.getAttachmentsFlag());

            vo.setReadFlag(false);
            vo.setLink("/seeyon/menhu.do?method=openLink&linkType=news&id=" + item.getId());
            filledVo(vo);
        }


        if (user != null) {

            String sql = null;
            if(!CommonUtils.isEmpty(idList)){
                sql = "select * from news_read where news_id in(" + DataBaseHelper.join(idList,",") + ") and manager_id="+user.getId();
                try {
                    List<Map>  dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
                    if(CommonUtils.isEmpty(dataList)){
                        return retList;
                    }
                    for(NewsVo vo:retList){
                        for(Map data:dataList){
                            Long newsId = CommonUtils.getLong(data.get("news_id"));
                            if(newsId==null){
                                continue;
                            }
                            if(String.valueOf(newsId).equals(vo.getId())){
                                vo.setReadFlag(true);
                                break;
                            }

                        }
                    }
                    //
                } catch (Exception e) {

                }
            }

        }

        return retList;
    }

    private List<DocVo> transToDocVo(List<DocResourcePO> newsDataList) {
        //0、将po转换成Vo
        //  DocLibManager docLibManager = (DocLibManager)AppContext.getBean("docLibManager");
        List<DocVo> voList = new ArrayList<DocVo>();
        if (CommonUtils.isEmpty(newsDataList)) {
            return voList;
        }
        Long curDocLibId = 0l;
        DocLibPO curDocLibPo = null;

        List<Long> idList = new ArrayList<Long>();
        for (DocResourcePO po : newsDataList) {
            boolean find = false;
            String json = JSON.toJSONString(po);
            Long docLibId = po.getDocLibId();

            if (curDocLibId != null && curDocLibId.equals(docLibId)) {
                find = true;
            } else {
                curDocLibId = docLibId;
                find = false;
            }
            List<Long> ids = getDocLibManager().getOwnersByDocLibId(curDocLibId);
            if (CommonUtils.isEmpty(ids)) {
                continue;
            }
            DocVo vo = JSON.parseObject(json, DocVo.class);
            if (!find) {
                curDocLibPo = this.getDocLibManager().getDocLibById(curDocLibId);
                // this.getDocLibManager().getDocLibByIds()
            }
            Integer enType = parseEntranceType(curDocLibPo);

            try {
                //System.out.println();
                String v = SecurityHelper.digest(new Object[]{po.getSourceId()});
                vo.setV(v);
            } catch (Exception e) {
                e.printStackTrace();
                vo.setV(po.getv());
            }

            vo.setEntranceType(String.valueOf(enType));
            vo.setOwnerId(String.valueOf(ids.get(0)));
            /**
             *  this.accessOneTime(dr.getId(), dr.getIsLearningDoc(), !validUserId.equals(dr.getCreateUserId()));
             if(this.docLibManager.getDocLibById(dr.getDocLibId()).getLogView()) {
             this.operationlogManager.insertOplog(dr.getId(), Long.valueOf(dr.getParentFrId()), ApplicationCategoryEnum.doc, "log.doc.view", "log.doc.view.desc", new Object[]{AppContext.currentUserName(), dr.getFrName()});
             }
             */
            String url = DocMVCUtils.getOpenKnowledgeUrl(po, enType.intValue(), this.getDocAclNewManager(), this.getDocHierarchyManager(), null);

            url = "/seeyon"+url;
            String link = Base64Util.encode(url);
            vo.setLink("/seeyon/menhu.do?method=openLink&linkType=doc&id="+vo.getId()+"&link=" + link);
            voList.add(vo);
            vo.setId(po.getId());
            idList.add(po.getId());
        }
        User user = AppContext.getCurrentUser();
        if (user != null) {
            String sql = null;
            if(!CommonUtils.isEmpty(idList)){
                sql = "select * from doc_action where subject_id in(" + DataBaseHelper.join(idList,",") + ") and action_type=3 and action_user_id="+user.getId();
                try {
                    List<Map>  dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
                    if(CommonUtils.isEmpty(dataList)){
                        return voList;
                    }
                    for(DocVo vo:voList){
                        for(Map data:dataList){
                            Long subjectId = CommonUtils.getLong(data.get("subject_id"));
                            if(subjectId==null){
                                continue;
                            }
                            if(subjectId.equals(vo.getId())){
                                vo.setReadFlag(true);
                                break;
                            }

                        }
                    }
                    //
                } catch (Exception e) {

                }
            }

        }
        return voList;
    }


    @NeedlessCheckLogin
    public ModelAndView getBulData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);

            String departmentId = request.getParameter("deptId");
            String sql = "from BulDataItem where state=30  order by createDate desc";
            if (p.getTypeId() != null) {
                sql = "from BulDataItem where state=30 and typeId=" + p.getTypeId() + " order by createDate desc";
            }
            if (departmentId != null) {
                sql = "from BulDataItem where state=30 and typeId=" + p.getTypeId() + " and publishDepartmentId=" + departmentId + " order by createDate desc";
            }
            List<BulDataItem> dataList = DBAgent.find(sql);
            List<BulDataItem> retdataList = new ArrayList<BulDataItem>();
            AttachmentManager impl = (AttachmentManager) AppContext.getBean("attachmentManager");
            List<String> list = new ArrayList<String>();
            for (BulDataItem item : dataList) {
                if (item.getAttachmentsFlag()) {
                    List<Attachment> attachments = impl.getByReference(item.getId());

                    for (Attachment attch : attachments) {
                        list.add(attch.getMimeType());
                    }
                    item.setMimeTypes(list);
                    retdataList.add(item);
                } else {
                    retdataList.add(item);  //不一定对
                }
            }

            List<BulDataItem> pagingBulsDataList = Helper.paggingList(retdataList, p);
            data.setItems(transToBulVo(pagingBulsDataList));
            //Flag flag = null;
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:" + e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:" + e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    private List<BulsVo> transToBulVo(List<BulDataItem> bulsDataList) {
        List<BulsVo> retList = new ArrayList<BulsVo>();
        if (CollectionUtils.isEmpty(bulsDataList)) {
            return retList;
        }

        List<Long> idList = new ArrayList<Long>();
        for (BulDataItem item : bulsDataList) {
            BulsVo vo = new BulsVo();
            retList.add(vo);
            vo.setTitle(item.getTitle());
            vo.setAccountId(item.getAccountId());
            vo.setCreateDate(item.getCreateDate());
            vo.setUpdateDate(item.getUpdateDate());
            vo.setPublishDate(item.getUpdateDate());
            vo.setReadCount(item.getReadCount());
            vo.setBrief(item.getBrief());
            vo.setCreateUserId(item.getCreateUser());
            vo.setPublishDepartmentId(item.getPublishDepartmentId());
            vo.setPublishUserId(item.getPublishUserId());
            vo.setAttachmentsFlag(item.getAttachmentsFlag());
            idList.add(item.getId());
            vo.setId(String.valueOf(item.getId()));
            //  vo.setMimeTypes();
            // vo.setReadFlag();
            //DocHierarchyManager m;
            vo.setLink("/seeyon/menhu.do?method=openLink&linkType=bul&id=" + item.getId());
            filledVo(vo);

        }
        User user = AppContext.getCurrentUser();
        if (user != null) {

            String sql = null;
            if(!CommonUtils.isEmpty(idList)){
                sql = "select * from bul_read where bulletin_id in(" + DataBaseHelper.join(idList,",") + ") and manager_id="+user.getId();
                try {
                    List<Map>  dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
                    if(CommonUtils.isEmpty(dataList)){
                        return retList;
                    }
                    for(BulsVo vo:retList){
                        for(Map data:dataList){
                            Long bulletinId = CommonUtils.getLong(data.get("bulletin_id"));
                            if(bulletinId==null){
                                continue;
                            }
                            if(String.valueOf(bulletinId).equals(vo.getId())){
                                vo.setReadFlag(true);
                                break;
                            }

                        }
                    }
                    //
                } catch (Exception e) {

                }
            }

        }

        return retList;

    }

    private BulsVo filledVo(BulsVo vo) {
        try {
            V3xOrgAccount account = this.getOrgManager().getAccountById(vo.getAccountId());
            if (account != null) {
                vo.setAccountName(account.getName());
            }
            V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(vo.getPublishDepartmentId());
            if (dept != null) {
                vo.setPublishDepartmentName(dept.getName());
            }
            V3xOrgMember createMember = this.getOrgManager().getMemberById(vo.getCreateUserId());
            if (createMember != null) {
                vo.setCreateUserName(createMember.getName());
            }
            V3xOrgMember publishMember = this.getOrgManager().getMemberById(vo.getPublishUserId());
            if (publishMember != null) {
                vo.setPublishUserName(publishMember.getName());
            }

        } catch (Exception e) {

        }
        return vo;

    }


    public ModelAndView openLink(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String linkType = request.getParameter("linkType");

        if ("bul".equals(linkType)) {
            //BulDataController bdc = (BulDataController)AppContext.getBean("bulDataController");
            BulDataController bdc = null;
            Map<String, BulDataController> dataMaps = AppContext.getBeansOfType(BulDataController.class);
            if (!CommonUtils.isEmpty(dataMaps)) {
                bdc = dataMaps.values().iterator().next();
            }
            if (bdc != null) {
                return bdc.userView(request, response);
            }
        }
        if ("news".equals(linkType)) {

            NewsDataController nbc = null;
            Map<String, NewsDataController> dataMaps = AppContext.getBeansOfType(NewsDataController.class);
            if (!CommonUtils.isEmpty(dataMaps)) {
                nbc = dataMaps.values().iterator().next();
            }
            if (nbc != null) {
                return nbc.userView(request, response);
            }
        }
        if ("doc".equals(linkType)) {
            String link = request.getParameter("link");
            String id = request.getParameter("id");
            DocResourcePO dr = this.getDocHierarchyManager().getDocResourceById(CommonUtils.getLong(id));
            if(dr!=null){
                String sql = "select COUNT(*) from DocActionPO where actionUserId="+AppContext.currentUserId()+" and subjectId="+dr.getId()+" and actionType=3";
                int count = DBAgent.count(sql);
                if(count == 0){
                    DocActionPO po = new DocActionPO();
                    po.setActionTime(new Date());
                    po.setSubjectId(dr.getId());
                    po.setActionType(3);
                    po.setIdIfNew();
                    po.setActionUserId(AppContext.currentUserId());
                    po.setDescription("read");
                    po.setUserAccountId(AppContext.getCurrentUser().getAccountId());
                    DBAgent.save(po);
                }
            }
           response.sendRedirect(Base64Util.decode(link));
           return null;
        }
        if ("form".equals(linkType)) {
            //TODO
            ///seeyon/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=5362885690085430039&moduleType=37&rightId=-7543887085843953036.-4745304762424997952&contentType=20&viewState=2
            String id = request.getParameter("id");
            List<CtpContentAll> cont = DBAgent.find("from CtpContentAll where id="+id);
            if(!CommonUtils.isEmpty(cont)){
                String url = "";
                CtpContentAll cca= cont.get(0);
                url = "/seeyon/content/content.do?isFullPage=true&_isModalDialog=false&moduleId="+cca.getModuleId()+"&moduleType="+cca.getModuleType()+"&rightId=&contentType="+cca.getContentType()+"&viewState=2";

                response.sendRedirect(url);
                MainbodyController mdc;
            }

            return null;
        }
        if ("supervise".equals(linkType)) {
            String id = request.getParameter("id");
            if(!CommonUtils.isEmpty(id)){
                String sql ="select * from ctp_supervise_detail where id = "+id;
                List<Map> data = DataBaseHelper.executeQueryByNativeSQL(sql);
                if(!CommonUtils.isEmpty(data)){
                    Map dataMap = data.get(0);
                    Object affairId = dataMap.get("affair_id");
                    Object summaryId = dataMap.get("entity_id");
                    Integer app = Integer.parseInt(""+dataMap.get("app"));
                    ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(app);
                    if(appEnum!=null){
                        String url ="";
                        switch(appEnum){
                            case edoc:
                            case edocSign:
                            case edocRec:
                            case edocSend:
                            case edocRegister:
                            case edocRecDistribute:{
                                url = "/seeyon/edocController.do?method=detailIFrame&affairId="+affairId+"&summaryId="+summaryId+"&openFrom=supervise&type=0";
                                break;
                            }
                            case collaboration:
                            default:{
                                url = "/seeyon/collaboration/collaboration.do?method=summary&affairId="+affairId+"&summaryId="+summaryId+"&openFrom=supervise&type=0";

                            }

                        }
                        response.sendRedirect(url);
                        return null;

                    }else{

                    }


                }

            }
            //http://192.168.1.98:612/seeyon/edocController.do?method=detailIFrame&affairId=3979121591364177700&summaryId=1332069481704211477&openFrom=supervise&type=0


        }


        Helper.responseJSON("error", response);
        return null;
    }

    public ModelAndView getCommonDataByTableName(HttpServletRequest request, HttpServletResponse response) {
        //preHandleRequest(request,response);
        CommonResultVo data = new CommonResultVo();
        String tbName = request.getParameter("tableName");
        String columns = request.getParameter("columns");
        CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
        if (CommonUtils.isEmpty(tbName)) {
            data.setResult(false);
            data.setMsg("表名未传递");
            Helper.responseJSON(data, response);
            return null;
        }

        String condition = request.getParameter("condition");
        String whereStr = "";
        if (!CommonUtils.isEmpty(condition)) {
            /**
             * TODO
             * 解析条件 格式为 key1_op_value1_and_key2_op_value2_or_key3_op_value3
             * key为字段名称
             * op为条件 暂时支持 eq (=), ne(!=) , gt(>) , lt(<),gte(>=),lte(<=)
             * value为值
             * 连接符为 and 和 or
             * 只支持左向解析 即前置条件合并后在同后一个条件合并
             * 如key1_eq_value1_and_key2_ne_value2_or_key3_lt_value3解析为sql如下
             *   （key1 = value1 and key2!=value2） or key3 <value3
             *  注:括号不可少
             */
        }
        if (CommonUtils.isEmpty(columns)) {
            columns = "*";
        }
        String sql = "select " + columns + " from " + tbName + " where 1=1";
        if (CommonUtils.isEmpty(whereStr)) {
            sql += " and " + whereStr;
        }
        try {
            List<Map> dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
            dataList = Helper.paggingList(dataList, p);
            data.setItems(dataList);
            data.setResult(true);
            Helper.responseJSON(data, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public static void main(String[] args) {
        System.out.println("a");

    }


}
