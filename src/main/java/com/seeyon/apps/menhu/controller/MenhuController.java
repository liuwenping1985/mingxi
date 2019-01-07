package com.seeyon.apps.menhu.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.doc.manager.DocAclNewManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.m3.core.controller.M3CoreController;
import com.seeyon.apps.menhu.util.Helper;
import com.seeyon.apps.menhu.vo.MemberVo;
import com.seeyon.apps.menhu.vo.OrgVo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.*;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.rest.resources.M3PendingResource;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.services.flow.FlowUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;


public class MenhuController extends BaseController {
    private static Logger LOG = LoggerFactory.getLogger(MenhuController.class);

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

    public DocAclNewManager getDocAclNewManager() {
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
    public ModelAndView showPending(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        //查用户信息
        preResponse(response);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("result", false);
        data.put("msg", "error");
        data.put("data", "0");
        String loginName = request.getParameter("loginName");
        String affairId = request.getParameter("affairId");
        if (StringUtils.isEmpty(loginName)) {
            data.put("msg", "登录名不能为空");
            data.put("data", "-1");
        } else {
            V3xOrgMember member = this.getOrgManager().getMemberByLoginName(loginName);
            if (member == null) {
                data.put("msg", "根据登录名找不到用户");
                data.put("data", "-1");
            } else {
                AffairManager manager = (AffairManager)(AppContext.getBean("affairManager"));
                CtpAffair affair = manager.get(Long.parseLong(affairId));
                if(affair == null){
                    data.put("msg", "根据待办id找不到待办，处理失败");
                    data.put("data", "-1");
                }else{
                    ModelAndView mav = new ModelAndView("apps/menhu/pending");

                    mav.addObject("affair",affair);
                    
                    mav.addObject("affairJSON", JSON.toJSONString(affair));
                    mav.addObject("member",member);
                    mav.addObject("memberJSON",JSON.toJSONString(member));
                    return mav;
                }



            }

        }

        Helper.responseJSON(data, response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView pendingCount(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        //查用户信息
        preResponse(response);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("result", false);
        data.put("msg", "error");
        data.put("data", "0");
        String loginName = request.getParameter("loginName");
        if (StringUtils.isEmpty(loginName)) {
            data.put("msg", "登录名不能为空");
            data.put("data", "-1");
        } else {
            V3xOrgMember member = this.getOrgManager().getMemberByLoginName(loginName);
            if (member == null) {
                data.put("msg", "根据登录名找不到用户");
                data.put("data", "-1");
            } else {
                try {
                    // CtpAffair affair;

                    Integer count = DBAgent.count("select count(1) from CtpAffair where memberId=" + member.getId() + " and state=3 and is_delete=0");
                    data.put("data", count);
                    data.put("msg", "success");
                    data.put("result", true);
                } catch (Exception e) {
                    e.printStackTrace();
                    data.put("msg", e.getMessage());
                }
            }

        }

        Helper.responseJSON(data, response);
        return null;

    }

    private Map<String, Object> genRet() {
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("result", true);
        data.put("msg", "success");
        data.put("data", null);
        data.put("items", new ArrayList());

        return data;
    }

    @NeedlessCheckLogin
    public ModelAndView getOrgInfoList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        //查用户信息
        preResponse(response);
        Map<String, Object> data = genRet();
        List<OrgVo> voList = new ArrayList<OrgVo>();
        try {
            List<V3xOrgAccount> orgAccounts = this.getOrgManager().getAllAccounts();
            for (V3xOrgAccount account : orgAccounts) {

                OrgVo vo = new OrgVo();
                vo.setCode(account.getCode());
                vo.setFullName(account.getName());
                vo.setOrganType(0);
                vo.setId(String.valueOf(account.getId()));
                vo.setOrganTypeName("单位");
                vo.setParentId("0");
                vo.setPath(account.getPath());
                Long sortId = account.getSortId();
                if (sortId != null) {
                    vo.setSortFlag(sortId.intValue());
                } else {

                    vo.setSortFlag(-1);
                }
                String shortName = account.getShortName();
                if (StringUtils.isEmpty(shortName)) {
                    vo.setName(account.getName());
                } else {
                    vo.setName(shortName);
                }
                voList.add(vo);
                List<V3xOrgDepartment> depts = this.getOrgManager().getAllDepartments(account.getId());
                if (!CollectionUtils.isEmpty(depts)) {
                    for (V3xOrgDepartment dept : depts) {
                        OrgVo de = new OrgVo();
                        de.setId(String.valueOf(dept.getId()));
                        de.setCode(dept.getCode());
                        de.setName(dept.getName());
                        String wn = dept.getWholeName();
                        if (StringUtils.isEmpty(wn)) {
                            de.setFullName(de.getName());
                        } else {
                            de.setFullName(dept.getWholeName());
                        }
                        de.setParentId(dept.getParentPath());
                        de.setPath(dept.getPath());
                        de.setOrganType(1);
                        de.setOrganTypeName("部门");
                        sortId = dept.getSortId();
                        if (sortId != null) {
                            de.setSortFlag(sortId.intValue());
                        } else {

                            de.setSortFlag(-1);
                        }
                        voList.add(de);

                    }
                }

            }
            List<OrgVo> tempList = new ArrayList<OrgVo>();
            tempList.addAll(voList);
            OUT_LABEL:
            for (OrgVo vo1 : tempList) {
                INNER_LABEL:
                for (OrgVo vo2 : voList) {
                    String path = vo1.getPath();

                    if (StringUtils.isEmpty(path)) {
                        continue OUT_LABEL;
                    }
                    String myPath = vo2.getParentId();
                    if (StringUtils.isEmpty(myPath)) {
                        continue INNER_LABEL;
                    }
                    if(myPath.equals(path)){
                        vo2.setParentId(vo1.getId());
                    }
                }
            }
            data.put("msg", "success");
            data.put("result", true);
            data.put("items", voList);
        } catch (Exception e) {
            data.put("result", false);
            data.put("msg", "错误：" + e.getMessage());
        }

        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getUserList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        //查用户信息
        preResponse(response);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("result", false);
        data.put("msg", "error");
        data.put("data", "0");
        List<MemberVo> voList = new ArrayList<MemberVo>();
        try {
            List<V3xOrgAccount> orgAccounts = this.getOrgManager().getAllAccounts();
            for (V3xOrgAccount account : orgAccounts) {

                List<V3xOrgMember> members = this.getOrgManager().getAllMembers(account.getId());
                if(CollectionUtils.isEmpty(members)){
                    continue;
                }
                for(V3xOrgMember member:members){
                    MemberVo vo = new MemberVo();
                    vo.setActualName(member.getName());
                    Long postId = member.getOrgPostId();
                    if(postId!=null){
                        V3xOrgPost post = this.getOrgManager().getPostById(postId);
                        if(post!=null){
                            vo.setDuty(post.getName());
                        }

                    }else{
                        vo.setDuty("");

                    }
                    Long levelId = member.getOrgLevelId();
                    if(levelId!=null){
                        V3xOrgLevel level =  this.getOrgManager().getLevelById(levelId);
                        if(level!=null){
                            vo.setDutyRank(level.getName());
                        }

                    }else{
                        vo.setDutyRank("");
                    }

                    vo.setEmail(member.getEmailAddress());
                    vo.setTel(member.getTelNumber());
                    vo.setId(String.valueOf(member.getId()));
                    vo.setOrganId(String.valueOf(member.getOrgDepartmentId()));
                    Integer gender = member.getGender();
                    if(gender!=null){
                        if(gender==-1){
                            vo.setSex("其它");
                        }else{
                            vo.setSex(member.getGender()==1?"男":"女");
                        }
                    }
                    vo.setName(member.getName());
                    vo.setCode(member.getCode());
                    voList.add(vo);
                }
            }
            data.put("msg", "success");
            data.put("result", true);
            data.put("items",voList);
        }catch(Exception e){
            data.put("result", false);
            data.put("msg", "错误：" + e.getMessage());
        }


        Helper.responseJSON(data, response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView receiveAffair(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        /**
         * http://培训系统网址/usLoginBySSO.jsp?token=aaa&url=us-home
         * String userSyncCode, String name, String content, Date createdTime, Integer validDays, String url
         */
        preResponse(response);
        Map<String, Object> data = genRet();
        String userSyncCode = request.getParameter("userSyncCode");
        String name = request.getParameter("name");
        String content = request.getParameter("content");
        String createdTime = request.getParameter("createdTime");
        String validDays = request.getParameter("validDays");
        String url = request.getParameter("url");
        if(StringUtils.isEmpty(userSyncCode)){
            data.put("msg","userSyncCode值为空 用户为空,传值因为用户ID");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        if(StringUtils.isEmpty(name)){
            data.put("msg","name为空");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        if(StringUtils.isEmpty(url)){
            data.put("msg","添加失败,url为空，待办无法处理");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        CtpAffair affair = new CtpAffair();
        if(!StringUtils.isEmpty(createdTime)){
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            try{
                Date ft = format.parse(createdTime);
                affair.setCreateDate(ft);
            }catch (Exception e){

            }
        }else{
            affair.setCreateDate(new Date());
        }
        if(!StringUtils.isEmpty(validDays)){
            try {
                Integer days = Integer.parseInt(validDays);
                affair.setOverTime(days*3600*24*1000L);
            }catch(Exception e){

            }
        }

        Long userId = Long.parseLong(userSyncCode);
        V3xOrgMember member = this.getOrgManager().getMemberById(userId);




        affair.setState(3);
        affair.setIdentifier("outside");
        affair.setAddition(url);
        affair.setSubject(StringUtils.isEmpty(name)?content:name);
        affair.setMemberId(member.getId());
       //Helper.parseCommonTypeParameter()
        //affair
        //affair.setOverTime();
        affair.setMemberId(Long.parseLong(userSyncCode));
        affair.setIdIfNew();
        DBAgent.save(affair);
        data.put("data",affair);
        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView fininshAffair(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        /**
         * http://培训系统网址/usLoginBySSO.jsp?token=aaa&url=us-home
         * String userSyncCode, String name, String content, Date createdTime, Integer validDays, String url
         */
        preResponse(response);
        Map<String, Object> data = genRet();
        String affairId = request.getParameter("affairId");
        AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
        if(StringUtils.isEmpty(affairId)){
            data.put("msg","affairId为空,传值因为affairId");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        CtpAffair affair = affairManager.get(Long.parseLong(affairId));
        if(affair == null){
            data.put("msg","affair为空,根据affairId找不到待办");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        affair.setState(4);

        DBAgent.update(affair);
        data.put("data",affair);
        Helper.responseJSON(data, response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView deleteAffair(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        /**
         * http://培训系统网址/usLoginBySSO.jsp?token=aaa&url=us-home
         * String userSyncCode, String name, String content, Date createdTime, Integer validDays, String url
         */
        preResponse(response);
        Map<String, Object> data = genRet();
        String affairId = request.getParameter("affairId");
        AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
        if(StringUtils.isEmpty(affairId)){
            data.put("msg","affairId为空,传值因为affairId");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        CtpAffair affair = affairManager.get(Long.parseLong(affairId));
        if(affair == null){
            data.put("msg","affair为空,根据affairId找不到待办");
            data.put("result",false);
            Helper.responseJSON(data, response);
            return null;
        }
        DBAgent.delete(affair);
        data.put("data",affair);
        Helper.responseJSON(data, response);
        return null;
    }




        public static void main(String[] args) {
        System.out.println("a");

    }


}
