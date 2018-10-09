package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;
import com.seeyon.apps.collaboration.event.CollaborationStartEvent;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.BrowserEnum;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.login.LoginControlImpl;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.MemberManagerImpl;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Base64;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.dee.common.base.util.MD5;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import www.seeyon.com.utils.MD5Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;

/**
 * Created by liuwenping on 2018/9/3.
 */
public class SsoController extends BaseController {

    private LoginControlImpl loginControl;
    private OrgManager orgManager;

    private OrgManager getOrgManager() {

        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;

    }

    private LoginControlImpl getLoginControl() {
        if (loginControl == null) {
            loginControl = (LoginControlImpl) AppContext.getBean("loginControl");
            if (loginControl == null) {
                loginControl = (LoginControlImpl) AppContext.getBean("loginControlImpl");
            }
        }
        return loginControl;
    }

    @NeedlessCheckLogin
    public ModelAndView login(HttpServletRequest request, HttpServletResponse response) {

        String user_name = request.getParameter("loginname");

        String password = request.getParameter("spassword");

        String skey = "oa";
        Map<String, Object> dataMap = new HashMap<String, Object>();
        dataMap.put("result", false);
        Map ret = null;
        try {
            String url = ConfigService.getPropertyByName("lens_url", "");
            url = url + "?loginname=" + user_name + "&spassword=" + password + "&syskey=" + skey;
            System.out.println(url);
            ret = UIUtils.get(url);
            System.out.println(ret);
            String retStatus = String.valueOf(ret.get("result"));
            if ("0".equals(retStatus)) {
                Long memId = UIUtils.getMemberIdByCode(user_name);

                if (memId == null) {
                    V3xOrgMember memebr = this.getOrgManager().getMemberByLoginName(user_name);
                    if (memebr != null) {
                        memId = memebr.getId();
                    } else {
                        dataMap.put("result", false);
                        dataMap.put("msg", "根据用户名无法找到用户");
                    }

                }
                try {
                    V3xOrgMember member = this.getOrgManager().getMemberById(memId);
                    this.login(member, request, response);
                    return null;
                } catch (BusinessException e) {
                    e.printStackTrace();
                }
            } else {
                dataMap.put("result", false);
                dataMap.put("msg", ret.get("retmsg"));
                UIUtils.responseJSON(dataMap, response);
                return null;
            }
        } catch (IOException e) {
            dataMap.put("msg", "回调时发生错误:" + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        dataMap.put("msg", "出现错误");
        UIUtils.responseJSON(dataMap, response);
        return null;

    }

    public User login(V3xOrgMember handleMember, HttpServletRequest request, HttpServletResponse response) throws BusinessException {

        User user = new User();
        user.setId(handleMember.getId());
        user.setDepartmentId(handleMember.getOrgDepartmentId());
        user.setLoginAccount(handleMember.getOrgAccountId());
        user.setLoginName(handleMember.getLoginName());
        user.setName(handleMember.getName());
        user.setSecurityKey(UUIDLong.longUUID());
        user.setUserAgentFrom("pc");
        user.setBrowser(BrowserEnum.IE);
        String remoteAddr = Strings.getRemoteAddr(request);
        user.setRemoteAddr(remoteAddr);
        HttpSession session = request.getSession(true);
        String sessionId = session.getId();
        user.setSessionId(sessionId);
        user.setTimeZone(TimeZone.getDefault());
        user.setLoginState(User.login_state_enum.ok);
        Locale locale = LocaleContext.make4Frontpage(request);
        user.setLocale(locale);
        LoginResult result = mergeUserInfo(user, this.getLoginControl());
        if (!result.isOK()) {
            return null;
        }
        user.setLoginState(User.login_state_enum.ok);
        AppContext.putSessionContext(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale);
        session.setAttribute("com.seeyon.current_user", user);
        AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
        OnlineRecorder.moveToOffline(user.getLoginName(), user.getLoginSign(), Constants.LoginOfflineOperation.loginAnotherone);
        this.getLoginControl().getOnlineManager().updateOnlineState(user);
        this.getLoginControl().createLog(user);
        this.getLoginControl().getTopFrame(user, request);
        response.addHeader("LoginOK", "ok");
        response.addHeader("VJA", user.isAdmin() ? "1" : "0");

        try {
            response.sendRedirect("/seeyon/main.do?method=main");
        } catch (IOException e) {
            e.printStackTrace();
        }


        return user;
    }

    private static LoginResult mergeUserInfo(User currentUser, LoginControlImpl loginControl) {
        if (currentUser == null) {
            return LoginResult.ERROR_UNKNOWN_USER;
        } else {
            try {
                String loginName = currentUser.getLoginName();
                V3xOrgMember member = loginControl.getOrgManager().getMemberByLoginName(loginName);
                if (member != null && member.isValid()) {
                    long userId = member.getId().longValue();
                    V3xOrgAccount account = loginControl.getOrgManager().getAccountById(member.getOrgAccountId());
                    V3xOrgAccount loginAccount;
                    if (currentUser.getLoginAccount() != null) {
                        loginAccount = loginControl.getOrgManager().getAccountById(currentUser.getLoginAccount());
                    } else {
                        loginAccount = account;
                    }

                    if (account != null && loginAccount != null && account.isValid() && loginAccount.isValid()) {
                        currentUser.setId(Long.valueOf(userId));
                        currentUser.setAccountId(account.getId());
                        currentUser.setLoginAccount(loginAccount.getId());
                        currentUser.setLoginAccountName(loginAccount.getName());
                        currentUser.setLoginAccountShortName(loginAccount.getShortName());
                        currentUser.setExternalType(member.getExternalType());
                        String name = null;
                        if (member.getIsAdmin().booleanValue()) {
                            if (loginControl.getOrgManager().isAuditAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setAuditAdmin(true);
                                name = ResourceUtil.getString("org.auditAdminName.value");
                            } else if (loginControl.getOrgManager().isGroupAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setGroupAdmin(true);
                                name = ResourceUtil.getString("org.account_form.groupAdminName.value" + (String) SysFlag.EditionSuffix.getFlag());
                            } else if (loginControl.getOrgManager().isAdministratorById(Long.valueOf(userId), loginAccount).booleanValue()) {
                                currentUser.setAdministrator(true);
                                name = loginAccount.getName() + ResourceUtil.getString("org.account_form.adminName.value");
                            } else if (loginControl.getOrgManager().isSystemAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setSystemAdmin(true);
                                name = ResourceUtil.getString("org.account_form.systemAdminName.value");
                            } else if (loginControl.getOrgManager().isSuperAdmin(loginName, loginAccount).booleanValue()) {
                                currentUser.setSuperAdmin(true);
                                name = ResourceUtil.getString("org.account_form.superAdminName.value");
                            } else if (loginControl.getOrgManager().isPlatformAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setPlatformAdmin(true);
                                name = ResourceUtil.getString("org.account_form.platformAdminName.value");
                            }
                        } else {
                            name = member.getName();
                        }

                        currentUser.setName(name);
                        currentUser.setDepartmentId(member.getOrgDepartmentId());
                        currentUser.setLevelId(member.getOrgLevelId());
                        currentUser.setPostId(member.getOrgPostId());
                        currentUser.setInternal(member.getIsInternal().booleanValue());
                        return LoginResult.OK;
                    } else {
                        return LoginResult.ERROR_UNKNOWN_USER;
                    }
                } else {
                    return LoginResult.ERROR_UNKNOWN_USER;
                }
            } catch (Throwable var9) {
                loginControl.getLogger().error(var9.getLocalizedMessage(), var9);
                return LoginResult.ERROR_UNKNOWN_USER;
            }
        }
    }

    //流程更新
    @ListenEvent(event = CollaborationStartEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStart(CollaborationStartEvent event) {

        CtpAffair affair = event.getAffair();
        System.out.println("流程开始：" + affair.getId());
        String url = ConfigService.getPropertyByName("lens_flow_add_url", "");
        String skey = getSysKey(false);
        url = url + "&syskey=" + skey;
        Map param = genParam(affair, 0);
        /**
         *
         "sname" : "通知",
         "scode" : "mes001",
         "istate" : 1,
         "itype" : 1,
         "usercode" : "YG02",
         "username" : "user",
         "senddatetime" : "2018-7-11 05:07:12",
         "accdatetime" : "2018-7-11 06:07:12",
         "dealusercode" : "YG001",
         "dealusername" : "admin",
         "slink" : "www.baidu.com",
         "enddatetime" : "2018-7-11 06:07:12",
         "iview" : 1,
         "delflag" : 0,
         "modifydate" : "2018-7-11"
         */
        //UIUtils.post()


    }

    //流程更新
    @ListenEvent(event = CollaborationProcessEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {

        CtpAffair affair = event.getAffair();
        String url = ConfigService.getPropertyByName("lens_flow_update_url", "");
        String skey = getSysKey(false);
        url = url + "&syskey=" + skey;
        Map param = genParam(affair, 1);
        /**
         *  {
         "sname" : "通知",
         "scode" : "mes001",
         "istate" : 1,
         "itype" : 1,
         "usercode" : "YG02",
         "username" : "user",
         "senddatetime" : "2018-7-11 05:07:12",
         "accdatetime" : "2018-7-11 06:07:12",
         "usercode" : "YG001",
         "username" : "admin",
         "slink" : "www.baidu.com",
         "enddatetime" : "2018-7-11 06:07:12",
         "iview" : 1,
         "delflag" : 0,
         "modifydate" : "2018-7-11"
         }
         */
        Map ret = null;
        try {
            ret = UIUtils.post(url,param);
            System.out.println(ret);
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    //流程借宿
    @ListenEvent(event = CollaborationFinishEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onFinish(CollaborationFinishEvent event) {
        AffairManager afm = (AffairManager) AppContext.getBean("affairManager");
        try {
            CtpAffair affair = afm.get(event.getAffairId());
            String url = ConfigService.getPropertyByName("lens_flow_update_url", "");
            String skey = getSysKey(false);
            url = url + "&syskey=" + skey;
            Map param = genParam(affair, 2);
            Map ret =  UIUtils.post(url,param);
            System.out.println(ret);

        } catch (BusinessException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    private Map genParam(CtpAffair affair, int type) {

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("sname",affair.getSubject());
        param.put("scode","flow"+affair.getProcessId());
        param.put("istate",1);
        param.put("itype",1);
        OrgManager manager = (OrgManager)AppContext.getBean("orgManager");
        Long senderId = affair.getSenderId();
        Long memberId = affair.getMemberId();
        try {
            V3xOrgMember member = manager.getMemberById(memberId);
            V3xOrgMember sender = manager.getMemberById(senderId);
            param.put("usercode",sender.getCode());
            param.put("username",sender.getName());
            param.put("dealusercode",member.getCode());
            param.put("dealusername",member.getName());

        } catch (BusinessException e) {
            e.printStackTrace();
        }
        param.put("slink","http://113.104.5.249/seeyon/main.do?method=main");
        Date cr = affair.getCreateDate();
        param.put("senddatetime",UIUtils.formatDate(cr));
        Date re = affair.getReceiveTime();
        param.put("accdatetime",UIUtils.formatDate(re));
        Date ext = affair.getExpectedProcessTime();
        param.put("enddatetime",UIUtils.formatDate(ext));
        param.put("iview",2);
        param.put("delflag",0);
        Date upd = affair.getUpdateDate();
        param.put("modifydate",UIUtils.formatDate(upd));
        if(0==type){
            param.put("istate",1);

        }
        if(1==type){


        }

        if(2==type){
            param.put("istate",2);

        }
        System.out.println(param);

        return param;
    }

    private String getSysKey(boolean isMD5) {
        if (isMD5) {
            return MD5Util.MD5("oa");
        }

        return "oa";

    }


}
