package com.seeyon.apps.menhu.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.controller.CollaborationController;
import com.seeyon.apps.doc.manager.DocAclNewManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.m3.core.controller.M3CoreController;
import com.seeyon.apps.menhu.manager.LoginTokenManager;
import com.seeyon.apps.menhu.util.CommonUtils;
import com.seeyon.apps.menhu.util.DESUtil;
import com.seeyon.apps.menhu.util.Helper;
import com.seeyon.apps.menhu.vo.*;
import com.seeyon.apps.taskmanage.enums.ImportantLevelEnums;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.login.LoginControlImpl;
import com.seeyon.ctp.login.LoginInterceptor;
import com.seeyon.ctp.login.auth.DefaultLoginAuthentication;
import com.seeyon.ctp.organization.bo.*;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgPrincipal;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.organization.principal.PrincipalManagerImpl;
import com.seeyon.ctp.rest.resources.M3PendingResource;
import com.seeyon.ctp.services.ServiceException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.oainterface.impl.exportdata.MessageExporter;
import com.seeyon.v3x.services.flow.FlowUtil;
import com.seeyon.v3x.services.message.impl.MessageServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import www.seeyon.com.utils.MD5Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
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


    private String sysKey = "haijinge";

    public FileManager getFileManager() {
        if (fileManager == null) {
            MessageServiceImpl i2;
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
                AffairManager manager = (AffairManager) (AppContext.getBean("affairManager"));
                CtpAffair affair = manager.get(Long.parseLong(affairId));
                if (affair == null) {
                    data.put("msg", "根据待办id找不到待办，处理失败");
                    data.put("data", "-1");
                } else {
                    ModelAndView mav = new ModelAndView("apps/menhu/pending");

                    mav.addObject("affair", affair);

                    mav.addObject("affairJSON", JSON.toJSONString(affair));
                    mav.addObject("member", member);
                    mav.addObject("memberJSON", JSON.toJSONString(member));
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
                    if (myPath.equals(path)) {
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
                if (account.isGroup()) {
                    continue;
                }
                List<V3xOrgMember> members = this.getOrgManager().getAllMembers(account.getId());
                if (CollectionUtils.isEmpty(members)) {
                    continue;
                }
                for (V3xOrgMember member : members) {
                    MemberVo vo = new MemberVo();
                    vo.setActualName(member.getName());
                    Long postId = member.getOrgPostId();
                    if (postId != null) {
                        V3xOrgPost post = this.getOrgManager().getPostById(postId);
                        if (post != null) {
                            vo.setDuty(post.getName());
                        }

                    } else {
                        vo.setDuty("");

                    }
                    Long levelId = member.getOrgLevelId();
                    if (levelId != null) {
                        V3xOrgLevel level = this.getOrgManager().getLevelById(levelId);
                        if (level != null) {
                            vo.setDutyRank(level.getName());
                        }

                    } else {
                        vo.setDutyRank("");
                    }

                    vo.setEmail(member.getEmailAddress() == null ? "" : member.getEmailAddress());
                    vo.setTel(member.getTelNumber() == null ? "" : member.getTelNumber());
                    vo.setMobile(vo.getTel());
                    vo.setId(String.valueOf(member.getId()));
                    vo.setOrganId(String.valueOf(member.getOrgDepartmentId()));
                    Integer gender = member.getGender();
                    if (gender != null) {
                        if (gender == -1) {
                            vo.setSex("其它");
                        } else {
                            vo.setSex(member.getGender() == 1 ? "男" : "女");
                        }
                    }
                    vo.setName(member.getName());
                    vo.setCode(member.getCode());
                    voList.add(vo);
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
    public ModelAndView receiveMessage(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        preResponse(response);
        Map<String, Object> data = genRet();
        MessageExporter messageExporter = new MessageExporter();
        String receiverId = request.getParameter("receiverId");
        if(CommonUtils.isEmpty(receiverId)){
            data.put("result",false);
            data.put("msg","接受者不能为空");
            Helper.responseJSON(data, response);
            return null;
        }
        Long userId = CommonUtils.getLong(receiverId);
        if(userId==null){
            data.put("result",false);
            data.put("msg","非法的接受者ID");
            Helper.responseJSON(data, response);
            return null;
        }
        V3xOrgMember member = this.getOrgManager().getMemberById(userId);
        if(member==null){
            data.put("result",false);
            data.put("msg","找不到接收者");
            Helper.responseJSON(data, response);
            return null;
        }
//       long messageId =
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        if(title==null){
            title = "";
        }
        if(CommonUtils.isEmpty(content)){
            data.put("result",false);
            data.put("msg","消息正文不能为空");
            Helper.responseJSON(data, response);
            return null;
        }
        content="【"+title+"】"+content;
        long[] userIds= new long[]{member.getId()};
//        // 学员ID（接收者），消息标题、消息正文
        try {
            long messageId = messageExporter.sendMessage(-1,userIds,content,new String[0]);
            data.put("data",messageId);
            data.put("result",true);
        } catch (ServiceException e) {
            e.printStackTrace();
            data.put("msg",e.getMessage());
            data.put("result",false);
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
        try {

            CommonParameter p = CommonParameter.parseParameter(request);
            String userSyncCode = p.$("userSyncCode");
            String name = p.$("name");
            String content = p.$("content");
            String createdTime = p.$("createdTime");
            String validDays = p.$("validDays");
            String url = p.$("url");
            if (StringUtils.isEmpty(userSyncCode)) {
                data.put("msg", "userSyncCode值为空 用户为空,传值因为用户ID");
                data.put("result", false);
                Helper.responseJSON(data, response);
                return null;
            }
            if (StringUtils.isEmpty(name)) {
                data.put("msg", "name为空");
                data.put("result", false);
                Helper.responseJSON(data, response);
                return null;
            }
            if (StringUtils.isEmpty(url)) {
                data.put("msg", "添加失败,url为空，待办无法处理");
                data.put("result", false);
                Helper.responseJSON(data, response);
                return null;
            }
            CtpAffair affair = new CtpAffair();
            if (!StringUtils.isEmpty(createdTime)) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                try {
                    Date ft = format.parse(createdTime);
                    affair.setCreateDate(ft);
                } catch (Exception e) {

                }
            } else {
                affair.setCreateDate(new Date());
            }
            if (!StringUtils.isEmpty(validDays)) {
                try {
                    Integer days = Integer.parseInt(validDays);
                    affair.setOverTime(days * 3600 * 24 * 1000L);
                } catch (Exception e) {

                }
            }

            Long userId = Long.parseLong(userSyncCode);
            V3xOrgMember member = this.getOrgManager().getMemberById(userId);
            if (member == null) {
                data.put("msg", "根据userSyncCode值查找用户为空");
                data.put("result", false);
                Helper.responseJSON(data, response);
                return null;
            }
            affair.setState(3);
            affair.setIdentifier("outside");
            affair.setAddition(url);
            affair.setSubject(StringUtils.isEmpty(name) ? content : name);
            affair.setMemberId(member.getId());
            //Helper.parseCommonTypeParameter()
            //affair
            //affair.setOverTime();
            affair.setMemberId(Long.parseLong(userSyncCode));
            affair.setIdIfNew();
            affair.setSenderId(affair.getMemberId());


            affair.setApp(Integer.valueOf(ApplicationCategoryEnum.collaboration.ordinal()));

            affair.putExtraAttr("linkAddress", url);
            affair.putExtraAttr("outside_affair", "YES");
            affair.setUpdateDate(new Date());
            affair.setReceiveTime(new Date());
            affair.setSubState(11);
            //affair.setSenderId(sender.getId());

            affair.setObjectId(Long.valueOf(0L));
            affair.setActivityId(Long.valueOf(0L));
            affair.setNodePolicy("collaboration");
            affair.setBodyType("20");
            affair.setTrack(Integer.valueOf(0));
            affair.setDealTermType(Integer.valueOf(0));
            affair.setDealTermUserid(Long.valueOf(-1L));
            affair.setSubApp(Integer.valueOf(0));

            affair.setImportantLevel(Integer.valueOf(ImportantLevelEnums.general.getKey()));
            affair.setState(Integer.valueOf(StateEnum.col_pending.key()));
            Long accountId = member.getOrgAccountId();
            if (accountId != null) {
                affair.setOrgAccountId(accountId);
            }
            DBAgent.save(affair);
            data.put("data", affair);
            Helper.responseJSON(data, response);
        } catch (Exception e) {
            e.printStackTrace();
            data.put("msg", e.getMessage());
            data.put("result", false);

        }
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
        if (affairId == null) {
            affairId = request.getParameter("jobId");
        }
        AffairManager affairManager = (AffairManager) AppContext.getBean("affairManager");
        if (StringUtils.isEmpty(affairId)) {
            data.put("msg", "affairId为空,传值因为affairId");
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        Long afId = null;
        try {
            afId = Long.parseLong(affairId);
        } catch (Exception e) {

        }
        if (afId == null) {
            data.put("msg", "affairId值非法");
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        CtpAffair affair = affairManager.get(afId);
        if (affair == null) {
            data.put("msg", "affair为空,根据affairId找不到待办");
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        affair.setState(Integer.valueOf(StateEnum.col_done.key()));
        affair.setFinish(true);
        affair.setSubState(null);

        DBAgent.update(affair);
        data.put("data", affair);
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
        if (affairId == null) {
            affairId = request.getParameter("jobId");
        }
        AffairManager affairManager = (AffairManager) AppContext.getBean("affairManager");
        if (StringUtils.isEmpty(affairId)) {
            data.put("msg", "affairId为空,传值因为affairId");
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        Long afId = null;
        try {
            afId = Long.parseLong(affairId);
        } catch (Exception e) {

        }
        if (afId == null) {
            data.put("msg", "affairId值非法");
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        CtpAffair affair = affairManager.get(afId);
        if (affair == null) {
            data.put("msg", "affair为空,根据affairId找不到待办");
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        LoginControlImpl impl;
        LoginInterceptor interceptor;
        affair.setDelete(true);
        affair.setFinish(true);
        affair.setState(4);
        DBAgent.delete(affair);
        data.put("data", affair);
        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView genToken(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        preResponse(response);
        Map<String, Object> data = genRet();
        User user = AppContext.getCurrentUser();
        String debug = request.getParameter("debug");
        String logInName = request.getParameter("loginName");
        boolean isdebug = debug == null ? false : "1".equals(debug) ? true : false;
        if (user != null) {
            UserToken token = LoginTokenManager.getInstance().createToken(user);
            data.put("result", true);
            data.put("data", token);

        } else {
            V3xOrgMember member = null;
            if (logInName != null) {
                try {
                    member = this.getOrgManager().getMemberByLoginName(logInName);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (member != null && isdebug) {
                UserToken token = LoginTokenManager.getInstance().createToken(member);
                data.put("result", true);
                data.put("data", token);
            } else {
                data.put("result", false);
                data.put("data", "");
                data.put("msg", "请先登录");
            }

        }
        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView checkToken(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        preResponse(response);
        Map<String, Object> data = genRet();
        String token = request.getParameter("token");
        UserToken userToken = LoginTokenManager.getInstance().checkToken(token);
        if (userToken != null) {
            data.put("result", true);
            Map<String, String> retData = new HashMap<String, String>();
            retData.put("loginName", userToken.getUserLoginName());
            retData.put("token", userToken.getToken());
            String inMd5 = userToken.getUserLoginName() + userToken.getToken() + sysKey;
            String md5 = MD5Util.MD5(inMd5);
            md5 = md5.substring(0, 28);
            retData.put("sign", md5);
            data.put("data", retData);

        } else {
            data.put("result", false);
            data.put("msg", "无效token");

        }
        /**
         * 获取当前用户的登陆帐号和签名（学员帐号+令牌+【集成密钥】的md值的前28位）
         */

        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView checkUser(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        preResponse(response);
        Map<String, Object> data = genRet();
        String loginName = request.getParameter("loginName");
        String userName = request.getParameter("userName");
        if (loginName == null) {
            loginName = userName;
        }
        String password = request.getParameter("password");
        if (CommonUtils.isEmpty(password)) {
            data.put("result", false);
            data.put("msg", "密码为空");
        }
        if (CommonUtils.isEmpty(loginName)) {
            data.put("result", false);
            data.put("msg", "用户名为空");
        }
        try {

            Long userId = CommonUtils.getLong(loginName);
            V3xOrgMember member;
            if (userId != null) {
                member = this.getOrgManager().getMemberById(userId);
            } else {
                member = this.getOrgManager().getMemberByLoginName(loginName);
            }
            if (member == null) {
                data.put("result", false);
                data.put("msg", "找不到用户");
            } else {
                List<OrgPrincipal> opList = DBAgent.find("from OrgPrincipal where member_id=" + member.getId());
                if (!CommonUtils.isEmpty(opList)) {
                    OrgPrincipal op = opList.get(0);
                    String credentialValue = op.getCredentialValue();
                    MessageEncoder encode =null;
                    try {
                        if(credentialValue.indexOf("$SM3$") >= 0) {
                            encode = new MessageEncoder("SM3", "BC");
                        } else {
                            encode = new MessageEncoder();
                        }
                        password = DESUtil.decrypt(password,sysKey);
                        String pwdC = encode.encode(loginName, password);
                        boolean result = pwdC.equals(credentialValue);
                        if(result) {
                            data.put("result",true);
                            data.put("msg","合法用户");
                           // LOG.debug("Password" + pwdC + "!=" + credentialValue);
                        }else{
                            data.put("result",false);
                            data.put("msg","密码不匹配");
                        }
                    } catch (Exception var8) {
                        LOG.warn("", var8);
                    }
                } else {
                    data.put("result", false);
                    data.put("msg", "找不到登录凭据");
                }
            }

        } catch (Exception e) {
            data.put("result", false);
            data.put("msg", e.getMessage());
        }

        Helper.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView syncProjectDataList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        preResponse(response);
        Map<String, Object> data = genRet();
        String sql = "select id,field0001,field0029,field0037,field0042,field0040 from formmain_0014";
        JDBCAgent agent = new JDBCAgent();
        try {
            agent.execute(sql);
            List<Map> resultList = agent.resultSetToList(true);
            if (!CollectionUtils.isEmpty(resultList)) {
                List<ProjectDataVo> voList = new ArrayList<ProjectDataVo>();
                for (Map pData : resultList) {
                    Object pc = pData.get("field0001");
                    Object pn = pData.get("field0040");
                    Object pId = pData.get("id");
                    Object u1List = pData.get("field0029");
                    Object u2List = pData.get("field0037");
                    Object u3List = pData.get("field0042");
                    if (pId == null || (pn == null && u1List == null && u2List == null && u3List == null)) {
                        continue;
                    }
                    String pCode = "";
                    if (pc != null) {
                        pCode = pc.toString();
                    }
                    String pName = "";
                    if (pn != null) {
                        pName = pn.toString();
                    }
                    Set<Long> userList = new HashSet<Long>();
                    filledUserSet(u1List, userList);
                    filledUserSet(u2List, userList);
                    filledUserSet(u3List, userList);
                    ProjectDataVo pVo = new ProjectDataVo();
                    pVo.setId(String.valueOf(pId));
                    pVo.setCode(pCode);
                    pVo.setName(pName);
                    pVo.setUserList(genUserVoList(userList));
                    voList.add(pVo);

                }
                data.put("items", voList);
            }
        } catch (Exception e) {
            e.printStackTrace();
            data.put("result", false);
            data.put("msg", e.getMessage());
        } finally {
            if (agent != null) {
                try {
                    agent.close();
                } catch (Exception e) {

                }
            }
        }

        Helper.responseJSON(data, response);
        return null;
    }

    private void filledUserSet(Object u1List, Set<Long> userSet) {
        if (u1List != null) {
            String[] u1splits = (u1List + "").split(",");
            for (String s1 : u1splits) {
                if (s1 != null) {
                    Long val = CommonUtils.getLong(s1);
                    if (val != null) {
                        userSet.add(val);
                    }
                }
            }
        }

    }

    private List<ProjectUserDataVo> genUserVoList(Set<Long> userSet) {

        List<ProjectUserDataVo> userList = new ArrayList<ProjectUserDataVo>();

        if (userSet == null || userSet.isEmpty()) {
            return userList;
        }
        for (Long id : userSet) {


            try {
                V3xOrgMember member = this.getOrgManager().getMemberById(id);
                if (member != null) {
                    ProjectUserDataVo vo = new ProjectUserDataVo();
                    vo.setCode(member.getCode() == null ? "" : member.getCode());
                    vo.setId(String.valueOf(member.getId()));
                    vo.setName(member.getName());
                    userList.add(vo);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return userList;
    }

    @NeedlessCheckLogin
    public ModelAndView openLink(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        preResponse(response);
        Map<String, Object> data = genRet();
        String affairId = request.getParameter("affairId");
        AffairManager affairManager = (AffairManager) AppContext.getBean("affairManager");

        CtpAffair affair = affairManager.get(Long.parseLong(affairId));
        if (StringUtils.isEmpty(affair)) {
            data.put("msg", "affair为空,affairId:" + affairId);
            data.put("result", false);
            Helper.responseJSON(data, response);
            return null;
        }
        String link = affair.getAddition();
        try {
            UserToken token = LoginTokenManager.getInstance().createToken();
            String host = "http://1.119.195.90/usLoginBySSO.jsp?token=" + token.getToken() + "&url=" + link;


            //usLoginBySSO.jsp?token=aaa&url=us-home
            response.sendRedirect(host);
            return null;
        } catch (IOException e) {
            e.printStackTrace();
        }
        ModelAndView mav = new ModelAndView("");

        return mav;
        //CollaborationController
    }

    public static void main(String[] args) {
        System.out.println("a");
        CollaborationController cm;
    }


}