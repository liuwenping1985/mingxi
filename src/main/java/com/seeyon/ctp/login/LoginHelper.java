//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.login;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.User.login_state_enum;
import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager;
import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager.TicketInfo;
import com.seeyon.ctp.common.constants.Constants.LoginOfflineOperation;
import com.seeyon.ctp.common.constants.Constants.login_useragent_from;
import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.BrowserEnum;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.common.thirdparty.ThirdpartyTicketManager;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.portal.sso.SSOLoginContext;
import com.seeyon.ctp.portal.sso.SSOLoginContextManager;
import com.seeyon.ctp.portal.sso.SSOLoginHandshakeInterface;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TimeZoneUtil;
import com.seeyon.ctp.util.UUIDLong;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Iterator;
import java.util.Locale;
import java.util.TimeZone;

public final class LoginHelper {
    private static final Log loginLog = LogFactory.getLog("login");
    private static final String ncportalURL = SystemProperties.getInstance().getProperty("nc.portal.url");
    private static final String ncURL = SystemProperties.getInstance().getProperty("nc.server.url.prefix");
    private static Object isExceedMaxLoginNumberLock = new Object();
    private static Object o = null;
    private static int serverType;
    private static int m1Type;
    private static int vjoinPermissionType = -1;
    private static final Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");

    public LoginHelper() {
    }

    private static void init() {
        if(o == null) {
            o = MclclzUtil.invoke(c1, "getInstance", new Class[]{String.class}, (Object)null, new Object[]{""});
            serverType = ((Integer)MclclzUtil.invoke(c1, "getserverType", (Class[])null, o, (Object[])null)).intValue();
            m1Type = ((Integer)MclclzUtil.invoke(c1, "getm1Type", (Class[])null, o, (Object[])null)).intValue();
            if(vjoinPermissionType == -1) {
                vjoinPermissionType = ((Integer)MclclzUtil.invoke(c1, "getVJoinPermissionType", (Class[])null, o, (Object[])null)).intValue();
            }

        }
    }

    public static LoginResult transDoLogin(HttpServletRequest request, HttpSession session, HttpServletResponse response, LoginControlImpl loginControl) throws BusinessException {
        long startTime = System.currentTimeMillis();
        init();
        String userAgentFrom = request.getParameter("UserAgentFrom");
        if(userAgentFrom == null || "".equals(userAgentFrom)) {
            userAgentFrom = login_useragent_from.pc.name();
        }

        BrowserEnum browser = BrowserEnum.valueOf(request);
        if(browser == null) {
            browser = BrowserEnum.IE;
        }

        String remoteAddr = Strings.getRemoteAddr(request);
        String loginName = null;
        String password = null;
        boolean success = false;
        Locale locale = LocaleContext.make4Frontpage(request);
        AppContext.putSessionContext(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale);
        Iterator ite = loginControl.getLoginIntercepters().keySet().iterator();

        String key;
        while(ite.hasNext()) {
            key = (String)ite.next();
            LoginInterceptor loginInterceptor = (LoginInterceptor)loginControl.getLoginIntercepters().get(key);
            LoginResult loginResult = loginInterceptor.preHandle(request, response);
            loginResultCheck(loginResult);
        }

        ite = loginControl.getLoginAuthentications().keySet().iterator();

        while(ite.hasNext()) {
            key = (String)ite.next();
            LoginAuthentication loginAuthentication = (LoginAuthentication)loginControl.getLoginAuthentications().get(key);
            request.setAttribute("__LoginAuthenticationClassSimpleName", loginAuthentication.getClass().getSimpleName());

            try {
                String[] _success = loginAuthentication.authenticate(request, response);
                if(_success != null) {
                    success = true;
                    loginName = _success[0];
                    password = _success[1];
                    break;
                }
            } catch (LoginAuthenticationException var31) {
                loginLog.warn(remoteAddr + ";" + key + ";" + var31.getLoginReslut() + ";" + var31.getLocalizedMessage());
                afterFailure(request, response, loginControl);
                loginResultCheck(var31.getLoginReslut());
            } catch (Exception var32) {
                loginControl.getLogger().error(var32.getLocalizedMessage(), var32);
                loginResultCheck(LoginResult.ERROR_UNKNOWN_USER);
            }
        }

        if(!success) {
            LoginResult r = afterFailure(request, response, loginControl);
            loginResultCheck(r);
            return r;
        } else {
            if(!loginControl.getPrincipalManager().isExist(loginName)) {
                loginResultCheck(LoginResult.ERROR_UNKNOWN_USER);
            }

            TimeZone timeZone = TimeZone.getDefault();

            try {
                String tempTimeZone = request.getParameter("login.timezone");
                if(Strings.isNotBlank(tempTimeZone) && TimeZoneUtil.isEnable()) {
                    timeZone = TimeZone.getTimeZone(tempTimeZone);
                }
            } catch (Exception var29) {
                loginControl.getLogger().warn("Get Info of TimeZone from Request error : " + var29.getLocalizedMessage());
            }

            User user = new User();
            session.setAttribute("com.seeyon.current_user", user);
            AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
            user.setSecurityKey(UUIDLong.longUUID());
            user.setLoginName(loginName);
            user.setPassword(password);
            user.setUserAgentFrom(userAgentFrom);
            user.setBrowser(browser);
            user.setLocale(locale);
            user.setTimeZone(timeZone);
            user.setRemoteAddr(remoteAddr);
            user.setUserSSOFrom(request.getParameter("com.seeyon.sso.topframename"));
            String loginAccount = request.getParameter("login.accountId");
            if(Strings.isNotBlank(loginAccount)) {
                user.setLoginAccount(new Long(loginAccount));
            }

            String sessionId = session.getId();
            user.setSessionId(sessionId);
            LoginResult code0 = mergeUserInfo(user, loginControl);
            loginResultCheck(code0);
            ite = loginControl.getLoginIntercepters().keySet().iterator();

            while(ite.hasNext()) {
                key = (String)ite.next();
                LoginInterceptor loginInterceptor = (LoginInterceptor)loginControl.getLoginIntercepters().get(key);
                LoginResult loginResult = loginInterceptor.afterComplete(request, response);
                loginResultCheck(loginResult);
            }

            String m1PermissionType = null;
            String serverPermissionType = null;
            boolean isFromM1 = user.isFromM1();
            if(isFromM1) {
                m1PermissionType = (String)MclclzUtil.invoke(c1, "getM1PermissionType", (Class[])null, o, (Object[])null);
            } else {
                serverPermissionType = (String)MclclzUtil.invoke(c1, "getServerPermissionType", (Class[])null, o, (Object[])null);
            }

            boolean isVJoinUser = user.getExternalType().equals(Integer.valueOf(1));
            Long loginAccountId = user.getLoginAccount();
            user.setLoginLogId(Long.valueOf(UUIDLong.longUUID()));
            boolean isAdmin = user.isAdmin();
            boolean ignoreOnlineCheck = false;
            if(!ignoreOnlineCheck) {
                Object var27 = isExceedMaxLoginNumberLock;
                synchronized(isExceedMaxLoginNumberLock) {
                    boolean isExceedMaxLoginNumber;
                    if(isFromM1) {
                        if(AppContext.hasPlugin("m1")) {
                            m1Type = ((Integer)MclclzUtil.invoke(c1, "getm1Type", (Class[])null, o, (Object[])null)).intValue();
                        }

                        if(m1Type == 2) {
                            isExceedMaxLoginNumber = OnlineRecorder.isExceedMaxLoginNumberM1();
                            if(isExceedMaxLoginNumber && !isOnline(loginName)) {
                                loginControl.getLogger().info("M1在线" + OnlineRecorder.getOnlineUserNumber4M1() + ",M1并发" + OnlineRecorder.getMaxOnlineM1());
                                loginResultCheck(new LoginResult(4006, new String[0]));
                            }

                            if("2".equals(m1PermissionType) && OnlineRecorder.isExceedMaxLoginNumberM1InAccount(loginAccountId)) {
                                loginResultCheck(new LoginResult(4007, new String[0]));
                            }
                        }
                    } else if(isVJoinUser && !isAdmin && vjoinPermissionType == 2) {
                        isExceedMaxLoginNumber = OnlineRecorder.isExceedMaxLoginNumberVJoin();
                        if(isExceedMaxLoginNumber && !isOnline(loginName)) {
                            loginResultCheck(LoginResult.ERROR_EXCEED_MAXNUMBER);
                        }
                    } else if(serverType == 2 && !isAdmin) {
                        isExceedMaxLoginNumber = OnlineRecorder.isExceedMaxLoginNumberServer();
                        if(isExceedMaxLoginNumber && !isOnline(loginName)) {
                            loginResultCheck(LoginResult.ERROR_EXCEED_MAXNUMBER);
                        }

                        if("2".equals(serverPermissionType) && OnlineRecorder.isExceedMaxLoginNumberServerInAccount(loginAccountId)) {
                            loginResultCheck(LoginResult.ERROR_EXCEED_MAXNUMBER_IN_ACCOUNT);
                        }
                    }

                    addToOnlineUserList(loginControl);
                }
            }

            loginControl.createLog(user);
            user.setLoginState(login_state_enum.ok);
            loginControl.getTopFrame(user, request);
            response.addHeader("LoginOK", "ok");
            response.addHeader("VJA", user.isAdmin()?"1":"0");
            String screen = "";
            if(Strings.isNotBlank(request.getParameter("screenWidth")) && Strings.isNotBlank(request.getParameter("screenHeight"))) {
                screen = request.getParameter("screenWidth") + "*" + request.getParameter("screenHeight");
            }

            loginLog.info("Login," + user.getLoginName() + "," + user.getUserAgentFrom() + "," + remoteAddr + "," + (System.currentTimeMillis() - startTime) + "," + BrowserEnum.valueOf1(request) + "," + screen);
            return LoginResult.OK;
        }
    }

    private static boolean isOnline(String loginName) {
        return OnlineRecorder.getOnlineUser(loginName) != null;
    }

    private static LoginResult afterFailure(HttpServletRequest request, HttpServletResponse response, LoginControlImpl loginControl) {
        LoginResult r = LoginResult.ERROR_UNKNOWN_USER;
        Iterator ite = loginControl.getLoginIntercepters().keySet().iterator();

        while(ite.hasNext()) {
            String key = (String)ite.next();
            LoginInterceptor loginInterceptor = (LoginInterceptor)loginControl.getLoginIntercepters().get(key);
            LoginResult tmp = loginInterceptor.afterFailure(request, response);
            if(tmp != null && !tmp.isOK()) {
                r = tmp;
            }
        }

        return r;
    }

    private static void loginResultCheck(LoginResult loginResult) throws BusinessException {
        if(!loginResult.isOK()) {
            BusinessException e = new BusinessException("login.label.ErrorCode." + loginResult.getStatus(), loginResult.getParameters());
            e.setCode(String.valueOf(loginResult.getStatus()));
            throw e;
        }
    }

    private static LoginResult mergeUserInfo(User currentUser, LoginControlImpl loginControl) {
        if(currentUser == null) {
            return LoginResult.ERROR_UNKNOWN_USER;
        } else {
            try {
                String loginName = currentUser.getLoginName();
                V3xOrgMember member = loginControl.getOrgManager().getMemberByLoginName(loginName);
                if(member != null && member.isValid()) {
                    long userId = member.getId().longValue();
                    V3xOrgAccount account = loginControl.getOrgManager().getAccountById(member.getOrgAccountId());
                    V3xOrgAccount loginAccount;
                    if(currentUser.getLoginAccount() != null) {
                        loginAccount = loginControl.getOrgManager().getAccountById(currentUser.getLoginAccount());
                    } else {
                        loginAccount = account;
                    }

                    if(account != null && loginAccount != null && account.isValid() && loginAccount.isValid()) {
                        currentUser.setId(Long.valueOf(userId));
                        currentUser.setAccountId(account.getId());
                        currentUser.setLoginAccount(loginAccount.getId());
                        currentUser.setLoginAccountName(loginAccount.getName());
                        currentUser.setLoginAccountShortName(loginAccount.getShortName());
                        currentUser.setExternalType(member.getExternalType());
                        String name = null;
                        if(member.getIsAdmin().booleanValue()) {
                            if(loginControl.getOrgManager().isAuditAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setAuditAdmin(true);
                                name = ResourceUtil.getString("org.auditAdminName.value");
                            } else if(loginControl.getOrgManager().isGroupAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setGroupAdmin(true);
                                name = ResourceUtil.getString("org.account_form.groupAdminName.value" + (String)SysFlag.EditionSuffix.getFlag());
                            } else if(loginControl.getOrgManager().isAdministratorById(Long.valueOf(userId), loginAccount).booleanValue()) {
                                currentUser.setAdministrator(true);
                                name = loginAccount.getName() + ResourceUtil.getString("org.account_form.adminName.value");
                            } else if(loginControl.getOrgManager().isSystemAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setSystemAdmin(true);
                                name = ResourceUtil.getString("org.account_form.systemAdminName.value");
                            } else if(loginControl.getOrgManager().isSuperAdmin(loginName, loginAccount).booleanValue()) {
                                currentUser.setSuperAdmin(true);
                                name = ResourceUtil.getString("org.account_form.superAdminName.value");
                            } else if(loginControl.getOrgManager().isPlatformAdminById(Long.valueOf(userId)).booleanValue()) {
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

    private static void addToOnlineUserList(LoginControlImpl loginControl) {
        User user = AppContext.getCurrentUser();
        OnlineRecorder.moveToOffline(user.getLoginName(), user.getLoginSign(), LoginOfflineOperation.loginAnotherone);
        loginControl.getOnlineManager().updateOnlineState(user);
    }

    public static void transChangeLoginAccount(Long newLoginAccountId, LoginControlImpl loginControl) throws BusinessException {
        User currentUser = AppContext.getCurrentUser();
        Long oldAccountId = currentUser.getLoginAccount();
        if(newLoginAccountId != oldAccountId) {
            currentUser.setLoginAccount(newLoginAccountId);
            mergeUserInfo(currentUser, loginControl);
            Object o = MclclzUtil.invoke(c1, "getInstance", new Class[]{String.class}, (Object)null, new Object[]{""});
            Object var5 = isExceedMaxLoginNumberLock;
            synchronized(isExceedMaxLoginNumberLock) {
                int serverType = ((Integer)MclclzUtil.invoke(c1, "getserverType", (Class[])null, o, (Object[])null)).intValue();
                if(serverType == 2) {
                    String m1PermissionType;
                    if(currentUser.isFromM1()) {
                        m1PermissionType = (String)MclclzUtil.invoke(c1, "getM1PermissionType", (Class[])null, o, (Object[])null);
                        if("2".equals(m1PermissionType) && OnlineRecorder.isExceedMaxLoginNumberM1InAccount(newLoginAccountId)) {
                            loginResultCheck(new LoginResult(4007, new String[0]));
                        }
                    } else {
                        m1PermissionType = (String)MclclzUtil.invoke(c1, "getServerPermissionType", (Class[])null, o, (Object[])null);
                        if(!currentUser.isAdmin() && "2".equals(m1PermissionType) && OnlineRecorder.isExceedMaxLoginNumberServerInAccount(newLoginAccountId)) {
                            loginResultCheck(LoginResult.ERROR_EXCEED_MAXNUMBER_IN_ACCOUNT);
                        }
                    }
                }

                loginControl.getOnlineManager().swithAccount(oldAccountId, currentUser);
            }
        }
    }

    public static String transDoLogout(HttpServletRequest request, HttpSession session, HttpServletResponse response, LoginControlImpl loginControl) throws BusinessException {
        String destination = null;
        if("m".equalsIgnoreCase(request.getParameter("f"))) {
            destination = "/m/";
        } else if("toPortal".equalsIgnoreCase(request.getParameter("toPortal"))) {
            destination = ncportalURL + "/portal/logout.jsp";
            if(Strings.isBlank(ncportalURL)) {
                destination = ncURL + "/portal/logout.jsp";
            }
        } else if(session != null) {
            destination = (String)session.getAttribute("com.seeyon.login.error_destination");
        }

        try {
            User user = null;
            if(session != null) {
                user = (User)session.getAttribute("com.seeyon.current_user");
            }

            if(user != null && request.getParameter("Offline") == null) {
                Object var6 = isExceedMaxLoginNumberLock;
                synchronized(isExceedMaxLoginNumberLock) {
                    OnlineRecorder.logoutUser(user);
                }

                TicketInfo ticketInfo = SSOTicketManager.getInstance().getTicketInfoByUsername(user.getLoginName());
                if(ticketInfo != null) {
                    SSOLoginContext ssoLoginContext = SSOLoginContextManager.getInstance().getSSOLoginContext(ticketInfo.getFrom());
                    if(ssoLoginContext != null) {
                        SSOLoginHandshakeInterface handshake = ssoLoginContext.getHandshake();
                        if(handshake != null) {
                            handshake.logoutNotify(ticketInfo.getTicket());
                        }
                    }

                    SSOTicketManager.getInstance().removeTicketInfo(ticketInfo.getUsername());
                }

                ThirdpartyTicketManager.getInstance().removeTicketInfosByUsername(user.getLoginName());
                loginLog.info("Logout," + user.getLoginName() + "," + user.getUserAgentFrom() + "," + user.getRemoteAddr());

                try {
                    if(session != null) {
                        session.invalidate();
                    }
                } catch (Throwable var9) {
                    loginControl.getLogger().error(var9.getLocalizedMessage());
                }
            }
        } catch (Throwable var11) {
            loginControl.getLogger().error(var11.getLocalizedMessage(), var11);
        }

        String caFactory = SystemProperties.getInstance().getProperty("ca.factory");
        if(!"true".equalsIgnoreCase(request.getParameter("close")) && !"koal".equals(caFactory)) {
            if(Strings.isBlank(destination)) {
                destination = "/main.do";
            }

            return destination;
        } else {
            return "close";
        }
    }
}
