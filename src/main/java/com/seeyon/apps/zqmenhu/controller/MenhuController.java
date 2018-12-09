package com.seeyon.apps.zqmenhu.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.dao.DocResourceDaoImpl;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.apps.zqmenhu.po.BulDataItem;
import com.seeyon.apps.zqmenhu.po.NewsDataItem;
import com.seeyon.apps.zqmenhu.service.MenhuService;
import com.seeyon.apps.zqmenhu.util.Helper;
import com.seeyon.apps.zqmenhu.vo.*;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManagerImpl;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.*;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.bulletin.controller.BulDataController;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.news.controller.NewsDataController;
import com.seeyon.v3x.news.domain.NewsType;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MenhuController extends BaseController {

    private MenhuService menHuService;
    private PrincipalManager principalManager = null;
    private AttachmentManager attachmentManager;
    private OrgManager orgManager;

    public MenhuService getMenHuService() {
        return menHuService;
    }

    public void setMenHuService(MenhuService menHuService) {
        this.menHuService = menHuService;
    }

    public PrincipalManager getPrincipalManager() {
        if(principalManager == null){
            principalManager = (PrincipalManager)AppContext.getBean("principalManager");
        }
        return principalManager;
    }
    public OrgManager getOrgManager() {
        if(orgManager == null){
            orgManager = (OrgManager)AppContext.getBean("orgManager");
        }
        return orgManager;
    }
    private void preResponse(HttpServletResponse response){
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
        Map<String,Object> data = new HashMap<String,Object>();
        data.put("result",false);
        data.put("msg","");
        String userName = request.getParameter("userName");

        //dm
        String password = request.getParameter("password");
        if(userName == null){
            data.put("msg","用户名为空");
            Helper.responseJSON(data,response);
            return null;
        }
        if(password == null){
            password = "";
        }
        userName = new String (Base64.decodeBase64(userName.getBytes()));
        password = new String(Base64.decodeBase64(password.getBytes()));
        MessageEncoder encode = null;
        try {
            encode = new MessageEncoder();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            data.put("msg","OA加密算法错误");
            Helper.responseJSON(data,response);
            return null;
        }

        Long memId = null;
        try {
            memId = getPrincipalManager().getMemberIdByLoginName(userName);
        } catch (NoSuchPrincipalException e) {
            data.put("msg","用户名不存在");
            Helper.responseJSON(data,response);
            e.printStackTrace();
            return null;
        }
        if (memId == null) {
            data.put("msg","用户名不存在");
            Helper.responseJSON(data,response);
            return null;
        }

        try {
            String pwdC = encode.encode(userName, password);
            String cr =  getPrincipalManager().getPassword(memId);
            if(cr.equals(pwdC)){

                V3xOrgMember member = this.getOrgManager().getMemberById(memId);
                V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
                String avatar = Functions.getAvatarImageUrl(memId);
                Map<String,String> userInfo = new HashMap<String, String>();
                Long postId = member.getOrgPostId();
                V3xOrgPost post = getOrgManager().getPostById(postId);
                userInfo.put("name",member.getName());
                if(post!=null) {
                    userInfo.put("post", post.getName());
                }else{
                    userInfo.put("post","");
                }
                V3xOrgLevel orgLevel = getOrgManager().getLevelById(member.getOrgLevelId());
                if(orgLevel!=null){
                    userInfo.put("orgLevel",orgLevel.getName());
                }else{
                    userInfo.put("orgLevel","");
                }
                userInfo.put("departmentName",dept.getName());
                userInfo.put("avatar",avatar);
                data.put("msg","成功");
                data.put("result",true);
                data.put("userInfo",userInfo);
                Helper.responseJSON(data,response);
                return null;
            }else{
                data.put("msg","密码错误");
                Helper.responseJSON(data,response);
                return null;
            }
        } catch (NoSuchPrincipalException e) {
            e.printStackTrace();
            data.put("msg","用户名不存在");
            Helper.responseJSON(data,response);
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
            if(CollectionUtils.isEmpty(newsTypeList)){
                data.setMsg("NO-DATA");
                Helper.responseJSON(data,response);
                return null;
            }
            List<TypeVo> types= new ArrayList<TypeVo>();
            for(NewsType type:newsTypeList){
                TypeVo vo = new TypeVo();
                vo.setSort(String.valueOf(type.getSortNum()));
                vo.setTypeId(String.valueOf(type.getId()));
                vo.setTypeName(type.getTypeName());
                try{
                    V3xOrgAccount account = this.getOrgManager().getAccountById(type.getAccountId());
                    if(account!=null){
                        vo.setAccountName(account.getName());
                    }
                }catch(Exception e){

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
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
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
            if(CollectionUtils.isEmpty(docTypeList)){
                data.setMsg("NO-DATA");
                Helper.responseJSON(data,response);
                return null;
            }

            data.setItems(docTypeList);
            // data.put("news", newsDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
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
            List<TypeVo> typeList= new ArrayList<TypeVo>();
            for(BulType type:bulsTypeList){
                TypeVo vo = new TypeVo();
                typeList.add(vo);
                vo.setSort(String.valueOf(type.getSortNum()));
                vo.setTypeId(String.valueOf(type.getId()));
                vo.setTypeName(type.getTypeName());
                vo.setAccountId(type.getAccountId());
                try{
                    V3xOrgAccount account = this.getOrgManager().getAccountById(vo.getAccountId());
                    if(account!=null){
                        vo.setAccountName(account.getName());
                    }
                }catch(Exception e){

                }

            }
            data.setItems(typeList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
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
            Long typeId=p.getTypeId();
            String sql="from DocResourcePO where parentFrId =  "+typeId+" order by createTime desc";

            List<DocResourcePO> docDataList = DBAgent.find(sql);
            List<DocResourcePO> pagingDocDataList = Helper.paggingList(docDataList,p);
            data.setItems(pagingDocDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }
//
public ModelAndView getFavorCollection(HttpServletRequest request, HttpServletResponse response){

    CommonResultVo data = new CommonResultVo();
   try {
       CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
       DocResourceDao docResourceDao = (DocResourceDao) AppContext.getBean("docResourceDao");
       User user = AppContext.getCurrentUser();
       String userName = user.getName();
       DocLibManager docLibManager = (DocLibManager)AppContext.getBean("docLibManager");
       DocLibPO docLibPo = docLibManager.getPersonalLibOfUser(user.getId());
       Map<String, Object> params = new HashMap<String, Object>();
       params.put("userName", userName);
       params.put("docLibId", String.valueOf(docLibPo.getId()));
       List<DocResourcePO> poList = docResourceDao.findFavoriteByCondition(params);
       List<DocResourcePO> pagingFavor = Helper.paggingList(poList,p);
       data.setItems(pagingFavor);
       Helper.responseJSON(data, response);
       System.out.println("params："+params);
       System.out.println("list："+poList);
       return null;
   }catch (Exception e){
       data.setResult(false);
       data.setMsg("EXCEPTION:"+e.getMessage());
       e.printStackTrace();
   }catch (Error e){
       data.setResult(false);
       data.setMsg("ERROR:"+e.getMessage());
       e.printStackTrace();
   }
    Helper.responseJSON(data, response);
    return null;
}

    @NeedlessCheckLogin
    public ModelAndView getNewsByAccountAndDepartment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            String orgSql = "from NewsDataItem where state=30 and typeId=1 order by createDate desc";
            String orgCountStr = request.getParameter("orgCount");
            String deptCountStr = request.getParameter("deptCount");
            if (CommonUtils.isEmpty(orgCountStr)) {
                orgCountStr = "3";
            }
            int orgCount = Integer.parseInt(orgCountStr);
            if (CommonUtils.isEmpty(deptCountStr)) {
                deptCountStr = "3";
            }
            int deptCount = Integer.parseInt(deptCountStr);
            List<NewsDataItem> retList = new ArrayList<NewsDataItem>();

            Integer leftCount = orgCount + deptCount;
            List<NewsDataItem> newsDataItemList = DBAgent.find(orgSql);
            data.setItems(retList);
            data.setResult(true);
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
            Long deptId = AppContext.getCurrentUser().getDepartmentId();
            V3xOrgDepartment department = this.getOrgManager().getDepartmentById(deptId);
            List<NewsType> newsTypeList = DBAgent.find("from NewsType where typeName ='" + department.getName() + "' and usedFlag=1");
            if (CommonUtils.isEmpty(newsTypeList)) {
                Helper.responseJSON(data, response);
                return null;
            }
            NewsType newsType = newsTypeList.get(0);
            String deptSql = "from NewsDataItem where state=30 and typeId=" + newsType.getId() + " order by createDate desc";
            
            newsDataItemList = DBAgent.find(deptSql);
            if (!CommonUtils.isEmpty(newsDataItemList)) {
                int size = newsDataItemList.size();
                if (size > leftCount) {
                    retList.addAll(newsDataItemList.subList(0, leftCount));
                } else {
                    retList.addAll(newsDataItemList);
                }
                Helper.responseJSON(data, response);
            } else {
                Helper.responseJSON(data, response);
            }

        }catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
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
            if(p.getTypeId()!=null){
                sql = "select * from formmain_0732 where field0001="+p.getTypeId();
            }
            List<Map> formDataList = DataBaseHelper.executeQueryByNativeSQL(sql);
             formDataList = Helper.paggingList(formDataList,p);
            data.setItems(formDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
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
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql1 = "select * from ctp_supervise_detail";

            List<Map> formDataList = DataBaseHelper.executeQueryByNativeSQL(sql1);
            //
            formDataList = Helper.paggingList(formDataList,p);
            data.setItems(formDataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }


    @NeedlessCheckLogin
    //查单位图片新闻
    public ModelAndView getImgNewList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from NewsDataItem where state=30 order by createDate desc";
            if(p.getTypeId()!=null){
                sql = "from NewsDataItem where state=30 and typeId="+p.getTypeId()+" order by createDate desc";
            }

            List<NewsDataItem> newsDataList = DBAgent.find(sql);
            //
            AttachmentManager impl = null;
            List<NewsDataItem> retNewsDataList = new ArrayList<NewsDataItem>();
            for(NewsDataItem item:newsDataList){
                if(item.isImageNews()){
                    retNewsDataList.add(item);
                }
            }
            List<NewsDataItem> pagingNewsDataList = Helper.paggingList(retNewsDataList,p);
            data.setItems(transToNewsVo(pagingNewsDataList));

            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }
    @NeedlessCheckLogin
    //查Mime类型
    public ModelAndView getNewList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from NewsDataItem where state=30 order by createDate desc";
            if(p.getTypeId()!=null){
                sql = "from NewsDataItem where state=30 and typeId="+p.getTypeId()+" order by createDate desc";
            }

            List<NewsDataItem> newsDataList = DBAgent.find(sql);
            //
            AttachmentManager impl = (AttachmentManager)AppContext.getBean("attachmentManager");
            List<NewsDataItem> retNewsDataList = new ArrayList<NewsDataItem>();
            for(NewsDataItem item:newsDataList){
                if(item.getAttachmentsFlag()){
                    List<Attachment> attachments = impl.getByReference(item.getId());
                    List<String> list= new ArrayList<String>();
                    for(Attachment attch:attachments){
                        list.add(attch.getMimeType());
                    }
                    item.setMimeTypes(list);
                    retNewsDataList.add(item);
                }
            }
            List<NewsDataItem> pagingNewsDataList = Helper.paggingList(retNewsDataList,p);
            data.setItems(transToNewsVo(pagingNewsDataList));

            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }

    //查事务列表
    @NeedlessCheckLogin
    public ModelAndView getUserCptList(HttpServletRequest request, HttpServletResponse response){
        preResponse(response);
        User user = AppContext.getCurrentUser();
        CommonResultVo data = new CommonResultVo();
        Long mockUserId = null;
        if(user==null){
             mockUserId = 8180340772611837618L;
        }
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from CtpAffair where state=3 order by createDate desc";
                Long state = p.getTypeId();
                if(state==null){
                    state=3L;
                }
                if(mockUserId!=null){
                    sql = "from CtpAffair where state="+state+" and memberId="+mockUserId+" order by createDate desc";
                }else {
                    if (p.getTypeId() != null) {
                        sql = "from CtpAffair where state="+state+" and memberId=" + user.getId() + " order by createDate desc";
                    }
                }
            List<CtpAffair> ctpaffair = DBAgent.find(sql);
            List<CtpAffair> paggingctpaffairs = Helper.paggingList(ctpaffair,p);
            data.setItems(wrapperCtpAffairList(paggingctpaffairs));

            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;

    }

    private SimpleDateFormat formt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//重点，查包装事务列表
    private List wrapperCtpAffairList(List<CtpAffair> affairList){


        List retList = new ArrayList();



        if(CommonUtils.isEmpty(affairList)){
            return retList;
        }

        for(CtpAffair ctpAffair:affairList){

            String jsonMap = JSON.toJSONString(ctpAffair);

            Map data = JSON.parseObject(jsonMap,HashMap.class);

            try {
               if(ctpAffair!=null) {



                   V3xOrgMember member = orgManager.getMemberById(ctpAffair.getSenderId());
                   if (member != null) {
                       data.put("senderName", member.getName());

                       data.put("receiveFormatDate", formt.format(ctpAffair.getReceiveTime()));
                   }
               }




                retList.add(data);

            }
            catch (BusinessException e) {

                e.printStackTrace();
            }

        }
        return retList;

    }
    private List<NewsVo> transToNewsVo(List<NewsDataItem> newsDataList){
        List<NewsVo> retList = new ArrayList<NewsVo>();
        if(CollectionUtils.isEmpty(newsDataList)){
            return retList;
        }
        for(NewsDataItem item:newsDataList){
            NewsVo vo = new NewsVo();
            retList.add(vo);
            vo.setTitle(item.getTitle());
            vo.setAccountId(item.getAccountId());
            vo.setCreateDate(item.getCreateDate());
            vo.setUpdateDate(item.getUpdateDate());
            vo.setPublishDate(item.getUpdateDate());
            vo.setReadCount(item.getReadCount());
            vo.setImgNews(item.isImageNews());
            vo.setFocusNews(item.isFocusNews());
            vo.setBrief(item.getBrief());
            Long imageId = item.getImageId();
            if(imageId!=null){
                vo.setImgUrl("/seeyon/commonimage.do?method=showImage&id="+imageId);
            }
            vo.setCreateUserId(item.getCreateUser());
            vo.setPublishDepartmentId(item.getPublishDepartmentId());
            vo.setPublishUserId(item.getPublishUserId());
            vo.setLink("/seeyon/menhu.do?method=openLink&linkType=news&id="+item.getId());
            filledVo(vo);
        }

        return retList;



    }
    @NeedlessCheckLogin

    public ModelAndView getBulData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        preResponse(response);
        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from BulDataItem where state=30  order by createDate desc";
            if(p.getTypeId()!=null){
                sql = "from BulDataItem where state=30 and typeId="+p.getTypeId()+" order by createDate desc";
            }
            List<BulDataItem> dataList = DBAgent.find(sql);
            List<BulDataItem> retdataList = new ArrayList<BulDataItem>();
            AttachmentManager impl = (AttachmentManager)AppContext.getBean("attachmentManager");
            List<String> list= new ArrayList<String>();
            for(BulDataItem item:dataList){
                if(item.getAttachmentsFlag()){
                    List<Attachment> attachments = impl.getByReference(item.getId());

                    for(Attachment attch:attachments){
                        list.add(attch.getMimeType());
                    }
                    item.setMimeTypes(list);
                    retdataList.add(item);

                }
            }
            List<BulDataItem> pagingBulsDataList = Helper.paggingList(retdataList,p);
            data.setItems(transToBulVo(pagingBulsDataList));
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            data.setResult(false);
            data.setMsg("EXCEPTION:"+e.getMessage());
            e.printStackTrace();
        } catch (Error e) {
            data.setResult(false);
            data.setMsg("ERROR:"+e.getMessage());
            e.printStackTrace();
        }
        Helper.responseJSON(data, response);
        return null;
    }
    private List<BulsVo> transToBulVo(List<BulDataItem> bulsDataList){
        List<BulsVo> retList = new ArrayList<BulsVo>();
        if(CollectionUtils.isEmpty(bulsDataList)){
            return retList;
        }
        for(BulDataItem item:bulsDataList){
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
            vo.setLink("/seeyon/menhu.do?method=openLink&linkType=bul&id="+item.getId());
            filledVo(vo);

        }

        return retList;

    }
    private BulsVo filledVo(BulsVo vo){
        try {
            V3xOrgAccount account = this.getOrgManager().getAccountById(vo.getAccountId());
            if(account!=null){
                vo.setAccountName(account.getName());
            }
            V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(vo.getPublishDepartmentId());
            if(dept !=null){
                vo.setPublishDepartmentName(dept.getName());
            }
            V3xOrgMember createMember = this.getOrgManager().getMemberById(vo.getCreateUserId());
            if(createMember!=null){
                vo.setCreateUserName(createMember.getName());
            }
            V3xOrgMember publishMember = this.getOrgManager().getMemberById(vo.getPublishUserId());
            if(publishMember!=null){
                vo.setPublishUserName(publishMember.getName());
            }

        } catch (Exception e) {

        }
        return vo;

    }

    public ModelAndView openLink(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String linkType = request.getParameter("linkType");
        if("bul".equals(linkType)){
            BulDataController bdc = (BulDataController)AppContext.getBean("bulDataController");
            if(bdc!=null){
                return bdc.userView(request,response);
            }
        }
        if("news".equals(linkType)){
            NewsDataController ndc = (NewsDataController)AppContext.getBean("newsDataController");
            if(ndc!=null){
                return ndc.userView(request,response);
            }
        }
        Helper.responseJSON("error",response);
        return null;
    }

    public ModelAndView getCommonDataByTableName(HttpServletRequest request, HttpServletResponse response){
        //preHandleRequest(request,response);
        CommonResultVo data = new CommonResultVo();
        String tbName = request.getParameter("tableName");
        String columns = request.getParameter("columns");
        CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
        if(CommonUtils.isEmpty(tbName)){
            data.setResult(false);
            data.setMsg("表名未传递");
            Helper.responseJSON(data,response);
            return null;
        }

        String condition =  request.getParameter("condition");
        String whereStr = "";
        if(!CommonUtils.isEmpty(condition)){
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
        if(CommonUtils.isEmpty(columns)){
            columns="*";
        }
        String sql = "select "+columns+" from "+tbName+" where 1=1";
        if(CommonUtils.isEmpty(whereStr)){
            sql+=" and "+whereStr;
        }
        try {
            List<Map> dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
            dataList = Helper.paggingList(dataList,p);
            data.setItems(dataList);
            data.setResult(true);
             Helper.responseJSON(data,response);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public static void main(String[] args){
        String userName = "王明";
        String b64 = new String(Base64.encodeBase64(userName.getBytes(),false));
        System.out.println(b64);
        String decode =  new String(Base64.decodeBase64(b64.getBytes()));
        System.out.println(decode);


    }

}
