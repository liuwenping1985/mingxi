package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;
import com.seeyon.apps.collaboration.event.CollaborationStartEvent;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
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
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import www.seeyon.com.utils.MD5Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 * Created by liuwenping on 2018/9/3.
 */
public class SsoController extends BaseController {

    private LoginControlImpl loginControl;
    private OrgManager orgManager;
    private AffairManager aff;

    private OrgManager getOrgManager() {

        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;

    }

    private AffairManager getAffairManager() {
        if (aff == null) {
            aff = (AffairManager) AppContext.getBean("affairManager");
        }
        return aff;

    }

    private static void initMessageThread() {
        DataBaseHandler handler = DataBaseHandler.getInstance();
        handler.createNewDataBaseByName("msg");
        Object obj = handler.getDataByKey("msg","updated");
        if(obj == null){
            String updateSql="update ctp_user_history_message set link_param_9='1' where link_param_9 is null and is_read=0";
            JDBCAgent agent = new JDBCAgent();
            try{
                agent.execute(updateSql);
            }catch(Exception e){
                e.printStackTrace();
            }finally {
                agent.close();
            }

            handler.putData("msg","updated","1");
        }

        Timer timer = new Timer();

        timer.schedule(new TimerTask() {


            private Map genMsgParam(Map msg) {
                Map<String, Object> param = new HashMap<String, Object>();
                param.put("sname", msg.get("message_content"));
                param.put("scode", "msg" + msg.get("id"));
                param.put("istate", 1);
                param.put("itype", 1);
                Long senderId = UIUtils.getLong(msg.get("sender_id"));
                Long memberId = UIUtils.getLong(msg.get("receiver_id"));
                OrgManager manager = (OrgManager) AppContext.getBean("orgManager");
                try {
                    V3xOrgMember member = manager.getMemberById(memberId);
                    V3xOrgMember sender = manager.getMemberById(senderId);
                    if (sender == null || member == null) {
                        return null;
                    }
                    param.put("usercode", sender.getCode());
                    param.put("username", sender.getName());
                    param.put("leadercode", member.getCode());

                } catch (BusinessException e) {
                    e.printStackTrace();
                    return null;
                }
                //param.put("slink", "http://113.104.5.249/seeyon/main.do?method=main");
                Date cr = UIUtils.getDate(msg.get("creation_date"));
                param.put("senddatetime", UIUtils.formatDate(cr));
                Date stt = new Date(cr.getTime() + 1000 * 3600 * 72);
                param.put("readdatetime", UIUtils.formatDate(stt));
                param.put("scontent", msg.get("message_content"));
                param.put("iview", 2);
                param.put("delflag", 0);
                param.put("modifydate", UIUtils.formatDate(cr));


                return param;
            }

            @Override
            public void run() {
               // System.out.println("read-msg");
                JDBCAgent agent = new JDBCAgent();
                try {
                    String sql = "select * from ctp_user_history_message where is_read=0 and link_param_9 is null";

                    agent.execute(sql);
                    List<Map> msgList = agent.resultSetToList();

                    String url = ConfigService.getPropertyByName("lens_msg_add_url", "");
                    String skey = "oa";
                    url = url + "&syskey=" + skey;

                    if (!CollectionUtils.isEmpty(msgList)) {
                      //  System.out.println("send messages:"+msgList.size());
                        for (Map map : msgList) {
                         //   Long id = UIUtils.getLong(map.get("id"));
                            Map param = genMsgParam(map);
                           // System.out.println("param:" + param);
                            if (param != null) {
                                Map data = UIUtils.post(url, param);
                              // System.out.println(data);
                            }
                        }
                        String updateSql="update ctp_user_history_message set link_param_9='1' where link_param_9 is null and is_read=0";
                        agent.execute(updateSql);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    agent.close();
                }

            }
        }, 248000, 5 * 60 * 1000);

    }

    static {

        initMessageThread();
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
    public ModelAndView openLink(HttpServletRequest request, HttpServletResponse response) {
        //http://127.0.0.1:701/seeyon/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId=-5367598530848996210

        String affId = request.getParameter("affairId");
        String memberId = request.getParameter("memberId");
        try {

            V3xOrgMember member = this.getOrgManager().getMemberById(Long.valueOf(memberId));
            String url = "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId=" + affId;

            User user2 = AppContext.getCurrentUser();
            if (user2 == null || !user2.getId().equals(member.getId())) {
                doLogin(member, request, response);
            }
            response.sendRedirect(url);
        } catch (Exception e) {
            e.printStackTrace();
            UIUtils.responseJSON("error", response);
        }
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView login(HttpServletRequest request, HttpServletResponse response) {

        String user_name = request.getParameter("loginname");

        String password = request.getParameter("spassword");
        if (StringUtils.isEmpty(password)) {
            password = request.getParameter("password");
        }
        String skey = "oa";
        Map<String, Object> dataMap = new HashMap<String, Object>();
        dataMap.put("result", false);
        Map ret = null;
        try {
            String url = ConfigService.getPropertyByName("lens_url", "");
            url = url + "?loginname=" + user_name + "&password=" + password + "&syskey=" + skey;
            //System.out.println(url);
            ret = UIUtils.get(url);
           // System.out.println(ret);
            String retStatus = String.valueOf(ret.get("result"));
            if ("0".equals(retStatus)) {
                V3xOrgMember member = this.getOrgManager().getMemberByLoginName(user_name);

                if (member != null) {

                    this.login(member, request, response);
                    return null;
                } else {
                    dataMap.put("result", false);
                    dataMap.put("msg", "根据用户名无法找到用户");
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
        User user2 = AppContext.getCurrentUser();
        if (user2 != null && user2.getId().equals(handleMember.getId())) {
            try {
                response.sendRedirect("/seeyon/main.do?method=main");
                return user2;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        User user = doLogin(handleMember, request, response);
        try {
            response.sendRedirect("/seeyon/main.do?method=main");
        } catch (IOException e) {
            e.printStackTrace();
        }


        return user;
    }

    private User doLogin(V3xOrgMember handleMember, HttpServletRequest request, HttpServletResponse response) {
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
        HttpSession session2 = (HttpSession) AppContext.getThreadContext("THREAD_CONTEXT_SESSION_KEY");
        if (session2 == null) {
            AppContext.putThreadContext("THREAD_CONTEXT_SESSION_KEY", session);
        }
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
        CtpAffair affair = event.getAffair();
        System.out.println("流程开始：" + affair.getId());
        Long summaryId = affair.getObjectId();
        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where state=3 and objectId= " + summaryId);
        if(!CollectionUtils.isEmpty(affairList)){
            String url = ConfigService.getPropertyByName("lens_flow_add_url", "");
            String skey = getSysKey(false);
            url = url + "&syskey=" + skey;
           for (CtpAffair af:affairList) {
                if(!isAffairSended(af.getId())){
                    Map param = genParam(af, 0);
              //      System.out.println("开始发送：" + param);
                    Map ret = null;
                    try {
                        ret = UIUtils.post(url, param);
                //        System.out.println(ret);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

        }





    }

    private DataBaseHandler getDataBaseHandler(){
        String key = "pending";
        DataBaseHandler handler= DataBaseHandler.getInstance();
        if(!handler.isDBExit(key)){
           handler.createNewDataBaseByName(key);
        }
        return handler;
    }
    private boolean isAffairSended(Long affairId){
        String key = "pending";
        DataBaseHandler handler = getDataBaseHandler();
        Object obj = handler.getDataByKey(key,String.valueOf(affairId));
        if(obj!=null){
            return true;
        }
        return false;
    }

    //流程更新
    @ListenEvent(event = CollaborationProcessEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {

        CtpAffair affair = event.getAffair();
        Long summaryId = affair.getObjectId();
        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where state=3 and objectId= " + summaryId);
        //new send
        if(!CollectionUtils.isEmpty(affairList)){
            String addurl = ConfigService.getPropertyByName("lens_flow_add_url", "");
            String skey = getSysKey(false);
            addurl = addurl + "&syskey=" + skey;
            for (CtpAffair af:affairList) {
                if(!isAffairSended(af.getId())){
                    Map param = genParam(af, 0);
                   // System.out.println("开始发送：" + param);
                    Map ret = null;
                    try {
                        ret = UIUtils.post(addurl, param);
                      //  System.out.println(ret);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

        }

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
            ret = UIUtils.post(url, param);
          //  System.out.println(ret);
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
            Map ret = UIUtils.post(url, param);
          //  System.out.println(ret);

        } catch (BusinessException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    private Map genParam(CtpAffair affair, int type) {

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("sname", affair.getSubject());
        param.put("scode", "flow" + affair.getProcessId());
        param.put("istate", 1);
        param.put("itype", 1);
        OrgManager manager = (OrgManager) AppContext.getBean("orgManager");
        Long senderId = affair.getSenderId();
        Long memberId = affair.getMemberId();
        try {
            V3xOrgMember member = manager.getMemberById(memberId);
            V3xOrgMember sender = manager.getMemberById(senderId);
            param.put("usercode", sender.getCode());
            param.put("username", sender.getName());
            param.put("dealusercode", member.getCode());
            param.put("dealusername", member.getName());

        } catch (BusinessException e) {
            e.printStackTrace();
        }

        String oaUrl = ConfigService.getPropertyByName("oa_url", "http://113.104.5.249");
        param.put("slink", oaUrl + "/seeyon/gateway/sso.do?method=openLink&affairId=" + affair.getId() + "&memberId=" + memberId);
        Date cr = affair.getCreateDate();
        param.put("senddatetime", UIUtils.formatDate(cr));
        Date re = affair.getReceiveTime();
        param.put("accdatetime", UIUtils.formatDate(re));
        Date ext = affair.getExpectedProcessTime();
        if (ext == null) {
            ext = new Date(affair.getCreateDate().getTime() + 365 * 3600 * 24 * 1000L);
        }
        param.put("enddatetime", UIUtils.formatDate(ext));
        param.put("iview", 2);
        param.put("delflag", 0);
        Date upd = affair.getUpdateDate();
        param.put("modifydate", UIUtils.formatDate(upd));
        if (0 == type) {
            param.put("istate", 1);

        }
        if (1 == type) {
            param.put("istate", 2);
        }

        if (2 == type) {
            param.put("istate", 2);

        }
       // System.out.println(param);

        return param;
    }

    private String getSysKey(boolean isMD5) {
        if (isMD5) {
            return MD5Util.MD5("oa");
        }

        return "oa";

    }


}
