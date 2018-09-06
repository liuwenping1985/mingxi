//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.portal.sso.thirdpartyintegration.controller;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.constants.Constants.login_useragent_from;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.flag.BrowserEnum;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.thirdparty.ThirdpartyTicketManager;
import com.seeyon.ctp.common.thirdparty.ThirdpartyTicketManager.TicketInfo;
import com.seeyon.ctp.common.usermessage.UserMessageUtil;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.login.online.OnlineUser;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.portal.sso.SSOTicketBean;
import com.seeyon.ctp.portal.sso.thirdpartyintegration.ThirdpartySpace;
import com.seeyon.ctp.portal.sso.thirdpartyintegration.manager.ThirdpartySpaceManager;
import com.seeyon.ctp.privilege.manager.PrivilegeMenuManager;
import com.seeyon.ctp.services.security.ServiceManager;
import com.seeyon.ctp.util.*;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.ctp.util.annotation.SetContentType;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.mail.manager.MessageMailManager;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.MessageFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

public class ThirdpartyController extends BaseController {
    private static final Log log = LogFactory.getLog(ThirdpartyController.class);
    private OrgManager orgManager;
    private OrgManagerDirect orgManagerDirect;
    private MessageMailManager messageMailManager;
    private PrivilegeMenuManager privilegeMenuManager;
    private OnlineManager onlineManager;
    private static Object isExceedMaxLoginNumberLock = new Object();
    private static Map<String, Integer> VlinkeParamMap = new HashMap();
    private static Object o;
    private static int serverType;
    private static int m1Type;
    private static final Class<?> c1;

    public ThirdpartyController() {
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setMessageMailManager(MessageMailManager messageMailManager) {
        this.messageMailManager = messageMailManager;
    }

    public void setOnlineManager(OnlineManager onlineManager) {
        this.onlineManager = onlineManager;
    }

    @NeedlessCheckLogin
    public ModelAndView show(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        String loginName;
        if(user == null) {
            loginName = request.getHeader("token");
            if(Strings.isEmpty(loginName)) {
                loginName = request.getParameter("token");
            }

            if(Strings.isEmpty(loginName)) {
                loginName = Cookies.get(request, "token");
            }

            ServiceManager.getInstance().initCurrentUser(request, loginName);
            user = AppContext.getCurrentUser();
        }

        if(user == null) {
            OutputStream stream = response.getOutputStream();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=UTF-8");
            stream.write("请重新登录后再试".getBytes("UTF-8"));
            stream.flush();
            stream.close();
            return null;
        } else {
            loginName = user.getLoginName();
            String id = request.getParameter("id");
            String pageURL = request.getParameter("pageUrl");
            String extendParam = request.getParameter("extendParam");
            String width = request.getParameter("width");
            String height = request.getParameter("height");
            ThirdpartySpace tpSpace = ThirdpartySpaceManager.getInstance().get(id);
            if(tpSpace != null) {
                if(Strings.isBlank(tpSpace.getLoginURL(user.getId().longValue(), user.getLoginAccount().longValue()))) {
                    pageURL = tpSpace.getPageURL(user.getId().longValue(), user.getLoginAccount().longValue());
                    if(Strings.isNotBlank(pageURL)) {
                        if(Strings.isNotBlank(width)) {
                            pageURL = pageURL + "&width=" + width + "&height=" + height;
                        }

                        if(Strings.isNotBlank(extendParam)) {
                            pageURL = pageURL + "&extendParam=" + URLEncoder.encode(extendParam, "UTF-8");
                        }

                        response.sendRedirect(pageURL);
                        return null;
                    }
                } else {
                    String ticket = ThirdpartySpaceManager.getInstance().ssoLogin(id, loginName, user.getId().longValue(), user.getLoginAccount().longValue());
                    if(Strings.isNotBlank(ticket)) {
                        if(pageURL == null) {
                            pageURL = tpSpace.getPageURL(user.getId().longValue(), user.getLoginAccount().longValue());
                        }

                        if(Strings.isNotBlank(pageURL)) {
                            response.sendRedirect(doURL(pageURL, tpSpace.getTicketName(), ticket));
                            return null;
                        }
                    }
                }
            }

            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('" + StringEscapeUtils.escapeJavaScript("页面地址不存在，不能正常登录，请联系系统管理员.") + "');");
            out.println("window.close();");
            out.println("</script>");
            return null;
        }
    }

    @SetContentType
    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        Enumeration params = request.getParameterNames();

        while(params.hasMoreElements()) {
            String ticket = request.getParameter(String.valueOf(params.nextElement()));
            if(ticket != null) {
                TicketInfo ticketInfo = ThirdpartyTicketManager.getInstance().getTicketInfo(ticket);
                if(ticketInfo != null) {
                    ThirdpartySpace tpSpace = ThirdpartySpaceManager.getInstance().get(ticketInfo.getSpaceId());
                    if(tpSpace != null) {
                        String username = ticketInfo.getLoginName();
                        if(username != null) {
                            V3xOrgMember member = this.orgManager.getMemberByLoginName(username);
                            String thirdUsername = tpSpace.getThirdpartyLoginName(username);
                            PrintWriter out = response.getWriter();
                            response.addHeader("LoginName", URLEncoder.encode(thirdUsername, "UTF-8"));
                            if(null != member) {
                                response.addHeader("MemberId", String.valueOf(member.getId()));
                                response.addHeader("MemberName", URLEncoder.encode(member.getName(), "UTF-8"));
                            } else {
                                log.warn("OA集成第三方系统通过登录名称找人失败：" + username + " " + thirdUsername);
                            }

                            if(AppContext.hasPlugin("m3")) {
                                response.addHeader("M3URL", URLEncoder.encode(ThirdpartyController.PNSPropertyUtils.getInstance().getM3URL(), "UTF-8"));
                            }

                            out.println(URLEncoder.encode(username, "UTF-8"));
                        }
                    }
                    break;
                }else{
                    byte[] bytes = Base64.decodeBase64(ticket.getBytes("UTF-8"));
                    String loginName = new String(bytes,"UTF-8");
                    PrintWriter out = response.getWriter();
                    V3xOrgMember member = this.orgManager.getMemberByLoginName(loginName);
                    response.addHeader("LoginName", URLEncoder.encode(loginName, "UTF-8"));
                    if(null != member) {
                        response.addHeader("MemberId", String.valueOf(member.getId()));
                        response.addHeader("MemberName", URLEncoder.encode(member.getName(), "UTF-8"));
                    } else {
                        log.warn("OA集成第三方系统通过登录名称找人失败：" + loginName + " " + loginName);
                    }
                    out.println(URLEncoder.encode(loginName, "UTF-8"));
                    break;
                }
            }
        }

        return null;
    }

    @SetContentType
    @NeedlessCheckLogin
    public ModelAndView logoutNotify(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        Enumeration params = request.getParameterNames();

        while(params.hasMoreElements()) {
            String ticket = request.getParameter(String.valueOf(params.nextElement()));
            if(ticket != null) {
                TicketInfo ticketInfo = ThirdpartyTicketManager.getInstance().getTicketInfo(ticket);
                if(ticketInfo != null) {
                    ThirdpartyTicketManager.getInstance().removeTicketInfo(ticket);
                    break;
                }
            }
        }

        return null;
    }

    private static String doURL(String loginURL, String ticketName, String ticket) {
        try {
            String[] us = loginURL.split("[?]");
            if(us.length < 2) {
                return loginURL + "?" + ticketName + "=" + ticket;
            } else {
                StringBuffer sb = new StringBuffer(loginURL + "&from=A8&" + ticketName + "=" + ticket);
                String internetURL = SystemEnvironment.getInternetSiteURL();
                if(StringUtils.isNotBlank(internetURL)) {
                    sb.append("&interneturl=" + internetURL);
                }

                return sb.toString();
            }
        } catch (Exception var6) {
            log.error(var6.getMessage(), var6);
            return null;
        }
    }

    @NeedlessCheckLogin
    public ModelAndView access(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long time1 = System.currentTimeMillis();
        ModelAndView mv = new ModelAndView("thirdparty/thirdpartyAccess");
        Locale locale = LocaleContext.make4Frontpage(request);
        HttpSession session = request.getSession();
        String openFrom = request.getParameter("from");
        Long loginTime = Long.valueOf(System.currentTimeMillis());
        String enc = null;
        if(request.getParameter("enc") != null) {
            enc = LightWeightEncoder.decodeString(request.getParameter("enc").replaceAll(" ", "+"));
        } else {
            String transcode = URLDecoder.decode(request.getQueryString().split("enc=")[1]);
            enc = request.getQueryString().indexOf("enc=") > 0?LightWeightEncoder.decodeString(transcode):null;
        }

        if(enc == null) {
            mv.addObject("ExceptionKey", "mail.read.alert.wuxiao");
            return mv;
        } else {
            Map<String, String> encMap = new HashMap();
            String[] enc0 = enc.split("[&]");
            String[] link = enc0;
            int var14 = enc0.length;

            String path;
            String startTimeStr;
            for(int var15 = 0; var15 < var14; ++var15) {
                String enc1 = link[var15];
                String[] enc2 = enc1.split("[=]");
                if(enc2 != null) {
                    path = enc2[0];
                    startTimeStr = enc2.length == 2?enc2[1]:null;
                    if(null != startTimeStr) {
                        startTimeStr = URLEncoder.encode(startTimeStr);
                        startTimeStr = startTimeStr.replaceAll("%3F", "");
                        startTimeStr = URLDecoder.decode(startTimeStr);
                    }

                    encMap.put(path, startTimeStr);
                }
            }

            long memberId = -1L;
            login_useragent_from userAgentFrom = login_useragent_from.pc;
            String linkType = (String)encMap.get("L");
            path = (String)encMap.get("P");
            Long timeStamp;
            String link2 =null;
            if(Strings.isNotBlank(linkType)) {
                startTimeStr = "0";
                if(encMap.containsKey("T")) {
                    startTimeStr = (String)encMap.get("T");
                    startTimeStr = startTimeStr.trim();
                }

                timeStamp = Long.valueOf(0L);
                if(NumberUtils.isNumber(startTimeStr)) {
                    timeStamp = Long.valueOf(Long.parseLong(startTimeStr));
                }

                if(!"ucpc".equals(openFrom) && (System.currentTimeMillis() - timeStamp.longValue()) / 1000L > (long)(this.messageMailManager.getContentLinkValidity() * 60 * 60)) {
                    mv.addObject("ExceptionKey", "mail.read.alert.guoqi");
                    return mv;
                }

                String _memberId = (String)encMap.get("M");
                if(_memberId == null) {
                    mv.addObject("ExceptionKey", "mail.read.alert.wuxiao");
                    return mv;
                }

                memberId = Long.parseLong(_memberId);
                link2 = (String)UserMessageUtil.getMessageLinkType().get(linkType);
                if(link == null) {
                    mv.addObject("ExceptionKey", "mail.read.alert.wuxiao");
                    return mv;
                }

                String[] linkParams = request.getParameterValues("P");
                MessageFormat formatter = new MessageFormat(link2);
                int formatsCount = formatter.getFormats().length;
                if(linkParams != null) {
                    if(formatsCount > linkParams.length) {
                        String[] params = new String[formatsCount];

                        for(int i = 0; i < params.length; ++i) {
                            if(i < linkParams.length) {
                                params[i] = linkParams[i];
                            } else {
                                params[i] = "";
                            }
                        }

                        link2 = formatter.format(params);
                    } else {
                        link2 = formatter.format(linkParams);
                    }
                } else {
                    linkParams = new String[formatsCount];

                    for(int i = 0; i < linkParams.length; ++i) {
                        linkParams[i] = "";
                    }

                    link2 = formatter.format(linkParams);
                }
            } else {
                if(!Strings.isNotBlank(path)) {
                    mv.addObject("ExceptionKey", "mail.read.alert.wuxiao");
                    return mv;
                }

                link2 = URLDecoder.decode(path);
                startTimeStr = (String)encMap.get("C");
                timeStamp = null;
                com.seeyon.ctp.common.authenticate.sso.SSOTicketManager.TicketInfo ticketInfo = SSOTicketBean.getTicketInfoByticketOrname(startTimeStr);
                if(ticketInfo == null) {
                    startTimeStr = startTimeStr.replaceAll(" ", "+");
                    ticketInfo = SSOTicketBean.getTicketInfoByticketOrname(startTimeStr);
                }

                loginTime = Long.valueOf(ticketInfo.getCreateDate().getTime());
                if("weixin".equals(ticketInfo.getFrom())) {
                    userAgentFrom = login_useragent_from.weixin;
                }

                if(ticketInfo != null) {
                    memberId = ticketInfo.getMemberId();
                }
            }

            if(memberId == -1L) {
                mv.addObject("ExceptionKey", "mail.read.alert.noUser");
                return mv;
            } else {
                boolean isNeedLogout = false;
                long time2 = System.currentTimeMillis();
                log.info("Param耗时" + (time2 - time1) + "MS");
                User currentUser = (User)session.getAttribute("com.seeyon.current_user");
                if(currentUser != null) {
                    if(currentUser.getId().longValue() != memberId) {
                        mv.addObject("ExceptionKey", "mail.read.alert.exists");
                        return mv;
                    }
                } else {
                    V3xOrgMember member = this.orgManager.getMemberById(Long.valueOf(memberId));
                    if(member == null) {
                        mv.addObject("ExceptionKey", "mail.read.alert.noUser");
                        return mv;
                    }

                    LocaleContext.setLocale(session, this.orgManagerDirect.getMemberLocaleById(member.getId()));
                    currentUser = new User();
                    currentUser.setLoginTimestamp(loginTime.longValue());
                    session.setAttribute("com.seeyon.current_user", currentUser);
                    AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", currentUser);
                    AppContext.initSystemEnvironmentContext(request, response, true);
                    currentUser.setSecurityKey(UUIDLong.longUUID());
                    currentUser.setId(Long.valueOf(memberId));
                    currentUser.setName(member.getName());
                    currentUser.setLoginName(member.getLoginName());
                    currentUser.setAccountId(member.getOrgAccountId());
                    currentUser.setLoginAccount(member.getOrgAccountId());
                    currentUser.setDepartmentId(member.getOrgDepartmentId());
                    currentUser.setLevelId(member.getOrgLevelId());
                    currentUser.setPostId(member.getOrgPostId());
                    currentUser.setInternal(member.getIsInternal().booleanValue());
                    currentUser.setUserAgentFrom(userAgentFrom.name());
                    currentUser.setSessionId(session.getId());
                    currentUser.setRemoteAddr(Strings.getRemoteAddr(request));
                    currentUser.setLocale(locale);
                    BrowserEnum browser = BrowserEnum.valueOf(request);
                    if(browser == null) {
                        browser = BrowserEnum.IE;
                    }

                    currentUser.setBrowser(browser);
                    UserHelper.setResourceJsonStr(JSONUtil.toJSONString(this.privilegeMenuManager.getResourceCode(currentUser.getId(), currentUser.getLoginAccount())));
                    CurrentUser.set(currentUser);
                    isNeedLogout = true;
                }

                long time3 = System.currentTimeMillis();
                log.info("User耗时" + (time3 - time2) + "MS");
                if(Strings.isNotBlank(linkType)) {
                    Integer paramIndex = (Integer)VlinkeParamMap.get(linkType);
                    String[] linkParams = request.getParameterValues("P");
                    if(paramIndex != null && linkParams.length > paramIndex.intValue()) {
                        String paramValue = linkParams[paramIndex.intValue()];
                        if(Strings.isNotBlank(paramValue)) {
                            String vlink = SecurityHelper.func_digest(paramValue);
                            int _index = link2.indexOf("&v=");
                            if(Strings.isNotBlank(link2) && _index > -1) {
                                String beforeLink = link2.substring(0, _index);
                                String afterLink = link2.substring(_index + 1, link2.length());
                                int _indexAfter = afterLink.indexOf("&");
                                if(_indexAfter > -1) {
                                    afterLink = afterLink.substring(_indexAfter, afterLink.length());
                                    link2 = beforeLink + "&v=" + vlink + afterLink;
                                } else {
                                    link2 = beforeLink + "&v=" + vlink;
                                }
                            } else {
                                vlink = "&v=" + vlink;
                                link2 = link2 + vlink;
                            }
                        }
                    }
                }

                long time4 = System.currentTimeMillis();
                log.info("Link耗时" + (time4 - time3) + "MS");
                init();
                OnlineUser onlineUser = OnlineRecorder.getOnlineUser(currentUser.getLoginName());
                if(serverType == 2) {
                    Object var52 = isExceedMaxLoginNumberLock;
                    synchronized(isExceedMaxLoginNumberLock) {
                        if(onlineUser == null) {
                            boolean isExceedMaxLoginNumber = OnlineRecorder.isExceedMaxLoginNumberServer();
                            if(isExceedMaxLoginNumber) {
                                mv.addObject("ExceptionKey", "mail.read.alert.ExceedMaxLoginNumber");
                                return mv;
                            }
                        }

                        this.onlineManager.updateOnlineState(currentUser);
                    }
                }

                link2 = link2 + (link2.contains("?")?"&":"?") + "_isModalDialog=true";
                if(link2.indexOf("&openFrom") > -1) {
                    link2 = link2 + "&extFrom=" + (String)Strings.escapeNULL(openFrom, "");
                } else {
                    link2 = link2 + "&openFrom=" + (String)Strings.escapeNULL(openFrom, "");
                }

                if("ucpc".equals(openFrom)) {
                    link2 = link2 + "&from=a8genius";
                }

                mv.addObject("link", link);
                mv.addObject("isNeedLogout", Boolean.valueOf(isNeedLogout));
                long time5 = System.currentTimeMillis();
                log.info("Online耗时" + (time5 - time4) + "MS");
                log.info("All耗时" + (time5 - time1) + "MS");
                return mv;
            }
        }
    }

    private static void init() {
        if(o == null) {
            o = MclclzUtil.invoke(c1, "getInstance", new Class[]{String.class}, (Object)null, new Object[]{""});
            serverType = ((Integer)MclclzUtil.invoke(c1, "getserverType", (Class[])null, o, (Object[])null)).intValue();
            m1Type = ((Integer)MclclzUtil.invoke(c1, "getm1Type", (Class[])null, o, (Object[])null)).intValue();
        }
    }

    public void setPrivilegeMenuManager(PrivilegeMenuManager privilegeMenuManager) {
        this.privilegeMenuManager = privilegeMenuManager;
    }

    static {
        VlinkeParamMap.put("message.link.office.assetN.audit", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.assetN.view", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.autoN.audit", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.autoN.view", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.bookN.audit", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.bookN.lended", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.stockN.audit", Integer.valueOf(0));
        VlinkeParamMap.put("message.link.office.stockN.view", Integer.valueOf(0));
        o = null;
        c1 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
    }

    public static class PNSPropertyUtils {
        private static final Log logger = LogFactory.getLog(ThirdpartyController.PNSPropertyUtils.class);
        private static String FILE_PATH;
        private static ThirdpartyController.PNSPropertyUtils property;
        private static Properties properties;

        private PNSPropertyUtils() {
            StringBuffer sb = (new StringBuffer(SystemEnvironment.getApplicationFolder())).append(File.separator).append("WEB-INF").append(File.separator).append("cfgHome").append(File.separator).append("plugin").append(File.separator).append("m3").append(File.separator).append("pns.properties");
            FILE_PATH = sb.toString();
        }

        public static final ThirdpartyController.PNSPropertyUtils getInstance() {
            if(property == null) {
                Class var0 = ThirdpartyController.PNSPropertyUtils.class;
                synchronized(ThirdpartyController.PNSPropertyUtils.class) {
                    if(property == null) {
                        property = new ThirdpartyController.PNSPropertyUtils();
                        init();
                    }
                }
            }

            return property;
        }

        private static void init() {
            File file = new File(FILE_PATH);
            if(file.exists()) {
                properties = new Properties();
                FileInputStream in = null;

                try {
                    in = new FileInputStream(file);
                    properties.load(in);
                } catch (FileNotFoundException var13) {
                    logger.error(var13);
                } catch (IOException var14) {
                    logger.error(var14);
                } finally {
                    if(in != null) {
                        try {
                            in.close();
                        } catch (IOException var12) {
                            logger.error(var12);
                        }
                    }

                }
            }

        }

        public final String getProperty(String key) {
            return properties != null?properties.getProperty(key):null;
        }

        public void setProperty(String key, String value) {
            File file = new File(FILE_PATH);
            if(file.exists()) {
                FileOutputStream out = null;

                try {
                    out = new FileOutputStream(file);
                    properties.setProperty(key, value);
                    properties.store(out, "Update PNS Property : [key=" + key + "; value=" + value + "].");
                } catch (FileNotFoundException var16) {
                    logger.error(var16);
                } catch (IOException var17) {
                    logger.error(var17);
                } finally {
                    if(out != null) {
                        try {
                            out.flush();
                            out.close();
                        } catch (IOException var15) {
                            logger.error(var15);
                        }
                    }

                }
            }

        }

        public String getM3URL() {
            String serverType = property.getProperty("pns.server.type");
            String serverIp = property.getProperty("pns.server.ip");
            String serverPort = property.getProperty("pns.server.port");
            String serverNamespase = property.getProperty("pns.server.namespase");
            return serverType + "://" + serverIp + ":" + serverPort + serverNamespase;
        }
    }

    public static void main(String[] args){
        System.out.println("123");
    }
}
