//package com.seeyon.apps.nbd.core.resource;
//
//import com.alibaba.fastjson.JSON;
//import com.seeyon.apps.nbd.core.config.ConfigService;
//import com.seeyon.apps.nbd.core.util.AESUtils;
//import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
//import com.seeyon.ctp.common.AppContext;
//import com.seeyon.ctp.common.authenticate.domain.User;
//import com.seeyon.ctp.common.constants.Constants;
//import com.seeyon.ctp.common.constants.LoginResult;
//import com.seeyon.ctp.common.exceptions.BusinessException;
//import com.seeyon.ctp.common.flag.BrowserEnum;
//import com.seeyon.ctp.common.flag.SysFlag;
//import com.seeyon.ctp.common.i18n.LocaleContext;
//import com.seeyon.ctp.common.i18n.ResourceUtil;
//import com.seeyon.ctp.login.LoginControl;
//import com.seeyon.ctp.login.LoginControlImpl;
//import com.seeyon.ctp.login.SSOTicketLoginAuthentication;
//import com.seeyon.ctp.login.controller.MainController;
//import com.seeyon.ctp.login.online.OnlineRecorder;
//import com.seeyon.ctp.organization.bo.V3xOrgAccount;
//import com.seeyon.ctp.organization.bo.V3xOrgMember;
//import com.seeyon.ctp.organization.manager.OrgManager;
//import com.seeyon.ctp.organization.po.OrgMember;
//import com.seeyon.ctp.rest.resources.BaseResource;
//import com.seeyon.ctp.util.StringUtil;
//import com.seeyon.ctp.util.Strings;
//import com.seeyon.ctp.util.UUIDLong;
//import com.seeyon.ctp.util.annotation.RestInterfaceAnnotation;
//import com.seeyon.v3x.services.ServiceException;
//import org.springframework.util.StringUtils;
//import org.springframework.web.servlet.i18n.SessionLocaleResolver;
//import www.seeyon.com.utils.MD5Util;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import javax.ws.rs.Consumes;
//import javax.ws.rs.GET;
//import javax.ws.rs.Path;
//import javax.ws.rs.core.Context;
//import javax.ws.rs.core.Response;
//import java.util.HashMap;
//import java.util.Locale;
//import java.util.TimeZone;
//
///**
// * Created by liuwenping on 2018/8/20.
// */
//@Path("/casso")
//public class NbdSSOResource  extends BaseResource {
//    @Context
//    private HttpServletRequest request;
//    @Context
//    private HttpServletResponse response;
//
//    private static String PRIVATE_KEY = "Pwd@2018@~!@#$%^&*(";
//
//
//    private LoginControlImpl loginControl;
//
//
//    private LoginControlImpl getLoginControl(){
//        if(loginControl == null){
//            loginControl = (LoginControlImpl)AppContext.getBean("loginControl");
//            if(loginControl == null){
//                loginControl = (LoginControlImpl)AppContext.getBean("loginControlImpl");
//            }
//        }
//        return loginControl;
//    }
//
//    @GET
//    @Consumes({"application/xml", "application/json","multipart/form-data"})
//    @Path("")
//    @RestInterfaceAnnotation
//    public Response sso() throws ServiceException {
//
//        NbdResponseEntity entity = new NbdResponseEntity();
//        String app_key = request.getParameter("app_key");
//        String userName = request.getParameter("userLoginName");
//
//        if(StringUtils.isEmpty(userName)){
//            entity.setMsg("用户名没有提供");
//            return this.ok(entity);
//        }
//        if(StringUtils.isEmpty(app_key)){
//            entity.setMsg("APP_KEY没有提供");
//            return this.ok(entity);
//        }
//        if(!ConfigService.APP_KEY.equals(app_key)){
//
//            entity.setMsg("APP_KEY错误");
//            return this.ok(entity);
//        }
//        String md5 = MD5Util.MD5(PRIVATE_KEY);
//        String password = md5.substring(0, 16);
//        String v16 = md5.substring(16, 32);
//        try {
//            String loginName = AESUtils.decrypt(userName,password,v16);
//            V3xOrgMember handleMember = this.getOrgManager().getMemberByLoginName(loginName);
//            if(handleMember == null){
//                entity.setMsg("用户名错误,找不到用户");
//                return this.ok(entity);
//            }
//            User user = login(handleMember);
//            if(user == null){
//                entity.setResult(false);
//                entity.setMsg("不合法的用户");
//            }else{
//                entity.setResult(true);
//                entity.setMsg("success");
//            }
//
//
//            entity.setData(JSON.parseObject(JSON.toJSONString(user),HashMap.class));
//        } catch (Exception e) {
//            e.printStackTrace();
//            entity.setMsg("解密错误");
//            return this.ok(entity);
//        }
//        return Response.status(200).entity(entity).type("application/json").build();
//
//
//    }
//
//    public OrgManager getOrgManager(){
//        return (OrgManager)AppContext.getBean("orgManager");
//    }
//
//    private User login(V3xOrgMember handleMember) throws BusinessException {
//        User user = new User();
//        user.setId(handleMember.getId());
//        user.setDepartmentId(handleMember.getOrgDepartmentId());
//        user.setLoginAccount(handleMember.getOrgAccountId());
//        user.setLoginName(handleMember.getLoginName());
//        user.setName(handleMember.getName());
//        user.setSecurityKey(UUIDLong.longUUID());
//        user.setUserAgentFrom("pc");
//        user.setBrowser(BrowserEnum.IE);
//        String remoteAddr = Strings.getRemoteAddr(request);
//        user.setRemoteAddr(remoteAddr);
//        HttpSession session = request.getSession(true);
//        String sessionId = session.getId();
//        user.setSessionId(sessionId);
//        user.setTimeZone(TimeZone.getDefault());
//        user.setLoginState(User.login_state_enum.ok);
//        Locale locale = LocaleContext.make4Frontpage(request);
//        user.setLocale(locale);
//        LoginResult result = mergeUserInfo(user,this.getLoginControl());
//        if(!result.isOK()){
//            return null;
//        }
//        user.setLoginState(User.login_state_enum.ok);
//        AppContext.putSessionContext(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale);
//        session.setAttribute("com.seeyon.current_user", user);
//        AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
//        OnlineRecorder.moveToOffline(user.getLoginName(), user.getLoginSign(), Constants.LoginOfflineOperation.loginAnotherone);
//        this.getLoginControl().getOnlineManager().updateOnlineState(user);
//        this.getLoginControl().createLog(user);
//        this.getLoginControl().getTopFrame(user, request);
//        response.addHeader("LoginOK", "ok");
//        response.addHeader("VJA", user.isAdmin()?"1":"0");
//        return user;
//    }
//
//
//    private static LoginResult mergeUserInfo(User currentUser, LoginControlImpl loginControl) {
//        if(currentUser == null) {
//            return LoginResult.ERROR_UNKNOWN_USER;
//        } else {
//            try {
//                String loginName = currentUser.getLoginName();
//                V3xOrgMember member = loginControl.getOrgManager().getMemberByLoginName(loginName);
//                if(member != null && member.isValid()) {
//                    long userId = member.getId().longValue();
//                    V3xOrgAccount account = loginControl.getOrgManager().getAccountById(member.getOrgAccountId());
//                    V3xOrgAccount loginAccount;
//                    if(currentUser.getLoginAccount() != null) {
//                        loginAccount = loginControl.getOrgManager().getAccountById(currentUser.getLoginAccount());
//                    } else {
//                        loginAccount = account;
//                    }
//
//                    if(account != null && loginAccount != null && account.isValid() && loginAccount.isValid()) {
//                        currentUser.setId(Long.valueOf(userId));
//                        currentUser.setAccountId(account.getId());
//                        currentUser.setLoginAccount(loginAccount.getId());
//                        currentUser.setLoginAccountName(loginAccount.getName());
//                        currentUser.setLoginAccountShortName(loginAccount.getShortName());
//                        currentUser.setExternalType(member.getExternalType());
//                        String name = null;
//                        if(member.getIsAdmin().booleanValue()) {
//                            if(loginControl.getOrgManager().isAuditAdminById(Long.valueOf(userId)).booleanValue()) {
//                                currentUser.setAuditAdmin(true);
//                                name = ResourceUtil.getString("org.auditAdminName.value");
//                            } else if(loginControl.getOrgManager().isGroupAdminById(Long.valueOf(userId)).booleanValue()) {
//                                currentUser.setGroupAdmin(true);
//                                name = ResourceUtil.getString("org.account_form.groupAdminName.value" + (String) SysFlag.EditionSuffix.getFlag());
//                            } else if(loginControl.getOrgManager().isAdministratorById(Long.valueOf(userId), loginAccount).booleanValue()) {
//                                currentUser.setAdministrator(true);
//                                name = loginAccount.getName() + ResourceUtil.getString("org.account_form.adminName.value");
//                            } else if(loginControl.getOrgManager().isSystemAdminById(Long.valueOf(userId)).booleanValue()) {
//                                currentUser.setSystemAdmin(true);
//                                name = ResourceUtil.getString("org.account_form.systemAdminName.value");
//                            } else if(loginControl.getOrgManager().isSuperAdmin(loginName, loginAccount).booleanValue()) {
//                                currentUser.setSuperAdmin(true);
//                                name = ResourceUtil.getString("org.account_form.superAdminName.value");
//                            } else if(loginControl.getOrgManager().isPlatformAdminById(Long.valueOf(userId)).booleanValue()) {
//                                currentUser.setPlatformAdmin(true);
//                                name = ResourceUtil.getString("org.account_form.platformAdminName.value");
//                            }
//                        } else {
//                            name = member.getName();
//                        }
//
//                        currentUser.setName(name);
//                        currentUser.setDepartmentId(member.getOrgDepartmentId());
//                        currentUser.setLevelId(member.getOrgLevelId());
//                        currentUser.setPostId(member.getOrgPostId());
//                        currentUser.setInternal(member.getIsInternal().booleanValue());
//                        return LoginResult.OK;
//                    } else {
//                        return LoginResult.ERROR_UNKNOWN_USER;
//                    }
//                } else {
//                    return LoginResult.ERROR_UNKNOWN_USER;
//                }
//            } catch (Throwable var9) {
//                loginControl.getLogger().error(var9.getLocalizedMessage(), var9);
//                return LoginResult.ERROR_UNKNOWN_USER;
//            }
//        }
//    }
//    public static void main(String[] args){
//
//
//    }
//}
