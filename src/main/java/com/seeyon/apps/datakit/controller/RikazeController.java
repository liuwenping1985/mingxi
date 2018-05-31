package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.apps.eip.manager.EipApi;
import com.seeyon.apps.ldap.config.LDAPConfig;
import com.seeyon.apps.ldap.util.LdapUtils;
import com.seeyon.apps.uc.api.UcApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.common.po.usermessage.Ent_UserMessage;
import com.seeyon.ctp.common.po.usermessage.UserHistoryMessage;
import com.seeyon.ctp.common.shareMap.V3xShareMap;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.login.HomePageParamsInterface;
import com.seeyon.ctp.login.LoginControl;
import com.seeyon.ctp.login.controller.MainController;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.login.online.OnlineUser;
import com.seeyon.ctp.portal.engine.render.PageRenderResult;
import com.seeyon.ctp.portal.expansion.ExpandJspForHomePage;
import com.seeyon.ctp.portal.manager.PortalCacheManager;
import com.seeyon.ctp.portal.manager.PortalManager;
import com.seeyon.ctp.portal.util.PortalFunctions;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.mobile.message.manager.MobileMessageManager;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Created by liuwenping on 2018/5/31.
 */
public class RikazeController extends BaseController {

    private static final Log log = LogFactory.getLog(MainController.class);
    private static final int expiry = 86400;
    private static final int expiry10year = 315360000;
    private SystemConfig systemConfig;
    private LoginControl loginControl;
    private final String DefaultFramePage = "/frame.jsp";
    private final String DefaultLoginPage = "/login.jsp";
    private static String appDefaultPath = "/indexOpenWindow.jsp";
    private String cframePage;
    private String cloginPage;
    private PortalManager portalManager;
    private OnlineManager onlineManager;
    private MobileMessageManager mobileMessageManager;
    private UcApi ucApi;
    private PortalCacheManager portalCacheManager;
    private CustomizeManager customizeManager;
    private EnumManager enumManagerNew;
    private UserMessageManager userMessageManager;
    private EipApi eipApi;
    private String mobileLoginType = null;
    private List<HomePageParamsInterface> HomePageParamsInterfaces = new ArrayList();
    private List<ExpandJspForHomePage> expansionJspForHomepage = new ArrayList();
    private Map localeInfo = null;
    private Integer expireDayNum = null;
    private static final Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
    private static final Class<?> c2 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
    private RikazeService rikazeService;

    public RikazeService getRikazeService() {
        return rikazeService;
    }

    public void setRikazeService(RikazeService rikazeService) {
        this.rikazeService = rikazeService;
    }



    public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if(session == null) {
            return this.index(request, response);
        } else {
            User user = AppContext.getCurrentUser();
            if(user != null) {
                if(this.cframePage == null) {
                    String framePage = this.systemConfig.get("frame_page");
                    if(framePage != null) {
                        this.cframePage = framePage;
                    } else {
                        this.cframePage = "/frame.jsp";
                    }
                }

                ModelAndView modelAndView = new ModelAndView("raw:/main/frames/pageLayout/index.jsp");
                Boolean bEIP = null;
                if(this.eipApi != null) {
                    String openOA = request.getParameter("EIPTicket");
                    if(StringUtils.isEmpty(openOA)) {
                        openOA = request.getParameter("showSkinchoose");
                    }

                    if(bEIP == null) {
                        bEIP = Boolean.valueOf(this.eipApi.judgeEIP(openOA, session));
                    }

                    if(bEIP.booleanValue()) {
                        modelAndView = new ModelAndView("raw:/main/frames/cipPageLayout/index.jsp");
                    }
                }

                boolean isCanSendSMS = false;
                if(this.mobileMessageManager.isCanSend(user.getId().longValue(), user.getLoginAccount().longValue())) {
                    isCanSendSMS = true;
                }

                modelAndView.addObject("isCanSendSMS", Boolean.valueOf(isCanSendSMS));
                String ci = this.systemConfig.get("card_enable");
                boolean cardEnabled = ci != null && "enable".equals(ci) && AppContext.hasPlugin("attendance");
                String sal = this.systemConfig.get("salary_enable");
                boolean salaryEnabled = sal != null && "enable".equals(sal);
                boolean appcenterEnabled = true;
                if(ProductEditionEnum.isU8OEM()) {
                    cardEnabled = false;
                    appcenterEnabled = false;
                }

                modelAndView.addObject("cardEnabled", Boolean.valueOf(cardEnabled));
                modelAndView.addObject("salaryEnabled", Boolean.valueOf(salaryEnabled));
                modelAndView.addObject("appcenterEnabled", Boolean.valueOf(appcenterEnabled));
                int onlineNum = this.onlineManager.getOnlineNumber();
                modelAndView.addObject("onlineNumber", Integer.valueOf(onlineNum));
                String contextPath = request.getContextPath();
                Map<String, Object> dataMap = new HashMap();
                dataMap.put("isCanSendSMS", String.valueOf(isCanSendSMS));
                dataMap.put("cardEnabled", String.valueOf(cardEnabled));
                dataMap.put("appcenterEnabled", String.valueOf(appcenterEnabled));
                dataMap.put("salaryEnabled", String.valueOf(salaryEnabled));
                dataMap.put("onlineNum", String.valueOf(onlineNum));
                PageRenderResult pageRenderResult = this.portalCacheManager.generateHtmlPage(user, contextPath, dataMap);
                String personModifyPwd;
                if(null != pageRenderResult) {
                    if(bEIP != null && bEIP.booleanValue()) {
                        personModifyPwd = "<iframe marginheight=\"0\" marginwidth=\"0\" height=\"100%\" style=\"height: 100%;\" src=\"\\seeyon\\zyPortalController.do?method=zyPortalMain\" name=\"dataIFrame\" scroll=\"no\" id=\"dataIFrame\" width=\"100%\" frameborder=\"0\"></iframe>";
                        pageRenderResult.setBodyHtml(personModifyPwd);
                        pageRenderResult.setCustomJS("/seeyon/main/frames/cipPageLayout/layout001/frount_56.js");
                        pageRenderResult.setDefaultLayoutCssPath("/seeyon/main/frames/cipPageLayout/layout001/main.css");
                    }

                    modelAndView.addObject("pageRenderResult", pageRenderResult);
                    user.setProperty("default_skin_path", pageRenderResult.getDefaultSkinCssPath());
                } else {
                    personModifyPwd = user.getMainFrame();
                    if(personModifyPwd != null) {
                        modelAndView = new ModelAndView("raw:" + personModifyPwd);
                    } else {
                        modelAndView = new ModelAndView("raw:" + this.cframePage);
                    }
                }

                personModifyPwd = SystemProperties.getInstance().getProperty("person.disable.modify.password");
                modelAndView.addObject("personModifyPwd", Boolean.valueOf("1".equals(personModifyPwd)));
                boolean checkPwd = true;
                if(!user.isAdmin()) {
                    if("1".equals(personModifyPwd)) {
                        checkPwd = false;
                    } else if(!LdapUtils.isLdapEnabled()) {
                        checkPwd = true;
                    } else if(!LdapUtils.isBind(AppContext.getCurrentUser().getId())) {
                        checkPwd = true;
                    } else if(LdapUtils.isOaCanModifyLdapPwd() && LDAPConfig.getInstance().getIsEnableSSL()) {
                        checkPwd = true;
                    } else {
                        checkPwd = false;
                    }
                }

                modelAndView.addObject("checkPwd", Boolean.valueOf(checkPwd));
                Object[] pwdExpirationInfo = (Object[])((Object[]) V3xShareMap.get("PwdExpirationInfo-" + user.getLoginName()));
                modelAndView.addObject("pwdExpirationInfo", pwdExpirationInfo);
                String pwdmodify_force_enable = this.systemConfig.get("pwdmodify_force_enable");
                modelAndView.addObject("pwdmodify_force_enable", pwdmodify_force_enable);
                String login_validatePwdStrength = String.valueOf(session.getAttribute("login_validatePwdStrength"));
                int loginPwdStrength = Strings.isNotBlank(login_validatePwdStrength) && !"null".equals(login_validatePwdStrength)?Integer.valueOf(login_validatePwdStrength).intValue():4;
                String pwd_strong_require = this.systemConfig.get("pwd_strong_require");
                int requirePwdStrength = 1;
                if(pwd_strong_require.isEmpty()) {
                    pwd_strong_require = "weak";
                }

                if("weak".equals(pwd_strong_require)) {
                    requirePwdStrength = 1;
                }

                if("medium".equals(pwd_strong_require)) {
                    requirePwdStrength = 2;
                }

                if("strong".equals(pwd_strong_require)) {
                    requirePwdStrength = 3;
                }

                if("best".equals(pwd_strong_require)) {
                    requirePwdStrength = 4;
                }

                if(loginPwdStrength < requirePwdStrength) {
                    modelAndView.addObject("login_validatePwdStrength", Boolean.valueOf(false));
                } else {
                    modelAndView.addObject("login_validatePwdStrength", Boolean.valueOf(true));
                }

                boolean isEnableMsgSound = false;
                String enableMsgSoundConfig = this.systemConfig.get("SMS_hint");
                if(enableMsgSoundConfig != null && "enable".equals(enableMsgSoundConfig)) {
                    isEnableMsgSound = "true".equals(user.getCustomize("messageSoundEnabled"));
                }

                modelAndView.addObject("isEnableMsgSound", Boolean.valueOf(isEnableMsgSound));
                modelAndView.addObject("msgClosedEnable", Boolean.valueOf(!"false".equals(user.getCustomize("messageViewRemoved"))));
                String currentSpaceForNC = request.getParameter("currentSpaceForNC");
                modelAndView.addObject("currentSpaceForNC", currentSpaceForNC);
                String pageTitle = this.portalCacheManager.getPageTitle();
                modelAndView.addObject("pageTitle", pageTitle);
                String groupSecondName = this.portalManager.getGroupSecondName();
                modelAndView.addObject("groupSecondName", Strings.escapeJavascript(groupSecondName));
                String accountSecondName = this.portalManager.getAccountSecondName();
                modelAndView.addObject("accountSecondName", Strings.escapeJavascript(accountSecondName));
                String skinPathKey = PortalFunctions.getSkinPathKey(user);
                modelAndView.addObject("skinPathKey", skinPathKey);
                user.setSkin(skinPathKey);
                String mainMenuId = request.getParameter("mainMenuId");
                if(Strings.isNotBlank(mainMenuId)) {
                    modelAndView.addObject("mainMenuId", mainMenuId);
                }

                String clickMenuId = request.getParameter("clickMenuId");
                if(Strings.isNotBlank(clickMenuId)) {
                    modelAndView.addObject("clickMenuId", clickMenuId);
                }

                String mainSpaceId = request.getParameter("mainSpaceId");
                if(Strings.isNotBlank(mainSpaceId)) {
                    modelAndView.addObject("mainSpaceId", mainSpaceId);
                }

                String shortCutId = request.getParameter("shortCutId");
                if(Strings.isNotBlank(shortCutId)) {
                    modelAndView.addObject("shortCutId", shortCutId);
                }

                String isRefresh = request.getParameter("isRefresh");
                if(Strings.isNotBlank(isRefresh)) {
                    modelAndView.addObject("isRefresh", isRefresh);
                }

                String showSkinchoose = request.getParameter("showSkinchoose");
                if(Strings.isNotBlank(showSkinchoose)) {
                    modelAndView.addObject("showSkinchoose", showSkinchoose);
                }

                String isPortalTemplateSwitching = request.getParameter("isPortalTemplateSwitching");
                if(Strings.isNotBlank(isPortalTemplateSwitching)) {
                    modelAndView.addObject("isPortalTemplateSwitching", isPortalTemplateSwitching);
                }

                String portal_default_page = request.getParameter("portal_default_page");
                if(Strings.isNotBlank(portal_default_page)) {
                    modelAndView.addObject("portal_default_page", portal_default_page);
                }

                String openFrom = request.getParameter("from");
                if(Strings.isNotBlank(openFrom)) {
                    modelAndView.addObject("openFrom", openFrom);
                } else {
                    modelAndView.addObject("openFrom", "");
                }

                String fontSize = (String)session.getAttribute("fontSize");
                if(Strings.isNotBlank(fontSize) && !"12".equals(fontSize)) {
                    user.setFontSize(fontSize);
                } else {
                    user.setFontSize("");
                }

                if(!user.isAdmin()) {
                    OnlineUser onlineUser = OnlineRecorder.getOnlineUser(user);
                    if(null != onlineUser) {
                        Map<Constants.login_sign, OnlineUser.LoginInfo> loginInfoMapper = onlineUser.getLoginInfoMap();
                        if(loginInfoMapper != null && Constants.login_useragent_from.pc.name().equals(user.getUserAgentFrom())) {
                            Iterator var44 = loginInfoMapper.entrySet().iterator();

                            label189:
                            while(true) {
                                while(true) {
                                    Constants.login_sign key;
                                    do {
                                        do {
                                            if(!var44.hasNext()) {
                                                break label189;
                                            }

                                            Map.Entry entity = (Map.Entry)var44.next();
                                            key = (Constants.login_sign)entity.getKey();
                                            OnlineUser.LoginInfo value = (OnlineUser.LoginInfo)entity.getValue();
                                        } while(key == null);
                                    } while(!Constants.login_sign.phone.name().equals(key.name()));

                                    Ent_UserMessage message = new Ent_UserMessage();
                                    String content = ResourceUtil.getString("pc.login.remind");
                                    message.setIdIfNew();
                                    message.setUserId(user.getId());
                                    message.setCreationDate(new Date());
                                    message.setMessageCategory(Integer.valueOf(ApplicationCategoryEnum.statusRemind.getKey()));
                                    message.setMessageContent(content);
                                    message.setSenderId(user.getId());
                                    message.setOpenType(Integer.valueOf(10));
                                    String loginType = this.getMobileLoginType();
                                    if(Strings.isNotBlank(loginType) && "M1".equals(loginType)) {
                                        this.userMessageManager.saveMessage(message);
                                    } else {
                                        UserHistoryMessage historyMessage = message.toUserHistoryMessage();
                                        List<UserHistoryMessage> ms = new ArrayList(1);
                                        ms.add(historyMessage);
                                        this.userMessageManager.savePatchHistory(ms);
                                    }
                                }
                            }
                        }
                    }
                }

                if(!this.HomePageParamsInterfaces.isEmpty()) {
                    Iterator var56 = this.HomePageParamsInterfaces.iterator();

                    while(var56.hasNext()) {
                        HomePageParamsInterface paramsCreater = (HomePageParamsInterface)var56.next();
                        Map<String, Object> params = paramsCreater.getParamsForHomePage();
                        if(params != null && params.size() > 0) {
                            modelAndView.addAllObjects(params);
                        }
                    }
                }

                List<String> ExpansionJsps = new ArrayList();
                if(CollectionUtils.isNotEmpty(this.expansionJspForHomepage)) {
                    Iterator var59 = this.expansionJspForHomepage.iterator();

                    while(var59.hasNext()) {
                        ExpandJspForHomePage expansionJspCreater = (ExpandJspForHomePage)var59.next();
                        List<String> expansionJsp = expansionJspCreater.expandJspForHomePage((Map)null);
                        if(expansionJsp != null && expansionJsp.size() > 0) {
                            ExpansionJsps.addAll(expansionJsp);
                        }
                    }

                    if(CollectionUtils.isNotEmpty(this.expansionJspForHomepage)) {
                        modelAndView.addObject("ExpansionJsp", ExpansionJsps);
                    }
                }

                Cookie cookie = new Cookie("avatarImageUrl", String.valueOf(AppContext.currentUserId()));
                cookie.setMaxAge(315360000);
                cookie.setPath("/");
                response.addCookie(cookie);
                return modelAndView;
            } else {
                BusinessException e = new BusinessException("loginUserState.unknown");
                e.setCode("-1");
                this.goout(request, session, response, e);
                return null;
            }
        }
    }





}
