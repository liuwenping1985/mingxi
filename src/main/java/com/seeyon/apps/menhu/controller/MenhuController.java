package com.seeyon.apps.menhu.controller;

import com.seeyon.apps.menhu.po.BulDataItem;
import com.seeyon.apps.menhu.po.NewsDataItem;
import com.seeyon.apps.menhu.service.MenhuService;
import com.seeyon.apps.menhu.util.Helper;
import com.seeyon.apps.menhu.vo.*;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.*;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.DBAgent;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MenhuController extends BaseController {

    private MenhuService menHuService;
    private PrincipalManager principalManager = null;
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

    @NeedlessCheckLogin
    public ModelAndView checkUserInfo(HttpServletRequest request, HttpServletResponse response) throws BusinessException {


        Map<String,Object> data = new HashMap<String,Object>();
        data.put("result",false);
        data.put("msg","");
        String userName = request.getParameter("userName");

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
    @NeedlessCheckLogin
    public ModelAndView getNewsTypeList(HttpServletRequest request, HttpServletResponse response) throws Exception {

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
    @NeedlessCheckLogin
    public ModelAndView getBulletinTypeList(HttpServletRequest request, HttpServletResponse response) throws Exception {

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

    @NeedlessCheckLogin
    public ModelAndView getNewsList(HttpServletRequest request, HttpServletResponse response) throws Exception {

        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from NewsDataItem where state=30 order by createDate desc";
            if(p.getTypeId()!=null){
                sql = "from NewsDataItem where state=30 and typeId="+p.getTypeId()+" order by createDate desc";
            }
            List<NewsDataItem> newsDataList = DBAgent.find(sql);
            List<NewsDataItem> pagingNewsDataList = Helper.paggingList(newsDataList,p);
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
                vo.setImgUrl("/seeyon/fileUpload.do?method=showRTE&fileId="+imageId+"&createDate=&type=image");
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

        CommonResultVo data = new CommonResultVo();
        try {
            CommonTypeParameter p = Helper.parseCommonTypeParameter(request);
            String sql = "from BulDataItem where state=30  order by createDate desc";
            if(p.getTypeId()!=null){
                sql = "from BulDataItem where state=30 and typeId="+p.getTypeId()+" order by createDate desc";
            }
            List<BulDataItem> dataList = DBAgent.find(sql);
            List<BulDataItem> pagingBulsDataList = Helper.paggingList(dataList,p);
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
    public static void main(String[] args){
        String userName = "王明";
        String b64 = new String(Base64.encodeBase64(userName.getBytes(),false));
        System.out.println(b64);
        String decode =  new String(Base64.decodeBase64(b64.getBytes()));
        System.out.println(decode);


    }

}