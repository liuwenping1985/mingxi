package com.seeyon.apps.menhu.controller;

import com.seeyon.apps.menhu.po.BulDataItem;
import com.seeyon.apps.menhu.po.NewsDataItem;
import com.seeyon.apps.menhu.service.MenhuService;
import com.seeyon.apps.menhu.util.Helper;
import com.seeyon.apps.menhu.vo.CommonResultVo;
import com.seeyon.apps.menhu.vo.TypeVo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
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
    public ModelAndView getNewsType(HttpServletRequest request, HttpServletResponse response) throws Exception {

        CommonResultVo data = new CommonResultVo;
        try {
            List<NewsType> newsTypeList = DBAgent.find("from NewsType");
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
    public ModelAndView getBulsType(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, Object> data = new HashMap<String, Object>();
        try {
            String offset =  request.getParameter("offset");
            String limit = request.getParameter("limit");
            List<NewsDataItem> newsDataList = DBAgent.find("from NewsDataItem where state=30 order by createDate desc");
            data.put("news", newsDataList);

            Helper.responseJSON(data, response);
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
    public ModelAndView getNews(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map<String, Object> data = new HashMap<String, Object>();
        try {
            String offset =  request.getParameter("offset");
            String limit = request.getParameter("limit");
            List<NewsDataItem> newsDataList = DBAgent.find("from NewsDataItem where state=30 order by createDate desc");
            data.put("news", newsDataList);

            Helper.responseJSON(data, response);
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
            String offset =  request.getParameter("offset");
            String limit = request.getParameter("limit");
            List<BulDataItem> dataList = DBAgent.find("from BulDataItem where state=30  order by createDate desc");
            data.put("buls", dataList);
            Helper.responseJSON(data, response);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        } catch (Error e) {
            e.printStackTrace();
        }
        data.put("buls", "error");
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
