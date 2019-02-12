/**
 * $Author: wangwy $
 * $Rev: 17968 $
 * $Date:: 2015-08-06 11:00:09#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.login.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.seeyon.apps.eip.manager.EipApi;
import com.seeyon.apps.ldap.config.LDAPConfig;
import com.seeyon.apps.ldap.util.LdapUtils;
import com.seeyon.apps.uc.api.UcApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.ServerState;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserCustomizeCache;
import com.seeyon.ctp.common.config.IConfigPublicKey;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.Constants.login_sign;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.constants.LoginConstants;
import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.ProductVersionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.exceptions.InfrastructureException;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.common.po.usermessage.Ent_UserMessage;
import com.seeyon.ctp.common.po.usermessage.UserHistoryMessage;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.shareMap.V3xShareMap;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.common.web.util.WebUtil;
import com.seeyon.ctp.form.upgrade.UpgradeUtil;
import com.seeyon.ctp.login.HomePageParamsInterface;
import com.seeyon.ctp.login.LoginActiveX;
import com.seeyon.ctp.login.LoginControl;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.login.online.OnlineUser;
import com.seeyon.ctp.login.online.OnlineUser.LoginInfo;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.portal.engine.render.PageRenderResult;
import com.seeyon.ctp.portal.expansion.ExpandJspForHomePage;
import com.seeyon.ctp.portal.manager.PortalCacheManager;
import com.seeyon.ctp.portal.manager.PortalManager;
import com.seeyon.ctp.portal.po.PortalHotspot;
import com.seeyon.ctp.portal.po.PortalLoginTemplate;
import com.seeyon.ctp.portal.po.PortalTemplateSetting;
import com.seeyon.ctp.portal.util.PortalFunctions;
import com.seeyon.ctp.util.Cookies;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.mobile.message.manager.MobileMessageManager;

//import com.seeyon.apps.eip.manager.EipApi;
/**
 * <p>Title: T1开发框架</p>
 * <p>Description: 登陆页展现、登陆、首页展现等处理Controller。</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class MainController extends BaseController {
    private static final Log     log              = LogFactory.getLog(MainController.class);
    private static final int expiry = 60 * 60 * 24 * 1;
    private static final int expiry10year = 10 * 365 * 24 * 60 * 60;
    private SystemConfig         systemConfig;
    private LoginControl         loginControl;
    private ConfigManager			     configManager;
    
    private final String         DefaultFramePage = "/frame.jsp";
    private final String         DefaultLoginPage = "/login.jsp";
    private static String        appDefaultPath   = "/indexOpenWindow.jsp";

    private String               cframePage;
    private String               cloginPage;
    private PortalManager        portalManager;
    private OnlineManager        onlineManager;
    private MobileMessageManager mobileMessageManager;
    private UcApi ucApi;
    private PortalCacheManager portalCacheManager;
    private CustomizeManager customizeManager;
    private EnumManager enumManagerNew;
    private UserMessageManager userMessageManager;
	private EipApi eipApi;
	private String mobileLoginType = null;
	private String getMobileLoginType(){
		if(Strings.isBlank(mobileLoginType)){
			mobileLoginType=(String) MclclzUtil.invoke(c2, "getMxProductLine", null, null, null);
		}
		return mobileLoginType;
	}
	public EipApi getEipApi() {
		return eipApi;
	}

	public void setEipApi(EipApi eipApi) {
		this.eipApi = eipApi;
	}
    
	public void setConfigManager(ConfigManager configManager) {
		this.configManager = configManager;
	}
	
    public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}

    public void setPortalCacheManager(PortalCacheManager portalCacheManager) {
		this.portalCacheManager = portalCacheManager;
	}

	public void setPortalManager(PortalManager portalManager) {
        this.portalManager = portalManager;
    }

    public void setOnlineManager(OnlineManager onlineManager) {
        this.onlineManager = onlineManager;
    }

    public void setLoginControl(LoginControl loginControl) {
        this.loginControl = loginControl;
    }

    public void setSystemConfig(SystemConfig systemConfig) {
        this.systemConfig = systemConfig;
    }

    public void setMobileMessageManager(MobileMessageManager mobileMessageManager) {
        this.mobileMessageManager = mobileMessageManager;
    }

	public void setUcApi(UcApi ucApi) {
        this.ucApi = ucApi;
    }

	public EnumManager getEnumManagerNew() {
		return enumManagerNew;
	}

	public void setEnumManagerNew(EnumManager enumManagerNew) {
		this.enumManagerNew = enumManagerNew;
	}

	public CustomizeManager getCustomizeManager() {
		return customizeManager;
	}

	public void setCustomizeManager(CustomizeManager customizeManager) {
		this.customizeManager = customizeManager;
	}

	//不要做集群
	private List<HomePageParamsInterface> HomePageParamsInterfaces = new ArrayList<HomePageParamsInterface>();
	private List<ExpandJspForHomePage> expansionJspForHomepage = new ArrayList<ExpandJspForHomePage>();
	
	public void init() throws BusinessException{
		//增加外部模块需要在首页增加参数控制的接口
        Map<String, HomePageParamsInterface> paramsCreaters = AppContext.getBeansOfType(HomePageParamsInterface.class);
		if(paramsCreaters!=null && paramsCreaters.size() >0){
			for(Map.Entry<String, HomePageParamsInterface> entry  : paramsCreaters.entrySet()){
				HomePageParamsInterface paramsCreater = entry.getValue();
				
				HomePageParamsInterfaces.add(paramsCreater);
			}
		}
		
		//增加外部模块需要在首页增加jsp页面引用的接口
		Map<String,ExpandJspForHomePage> expansionJspCreaters = AppContext.getBeansOfType(ExpandJspForHomePage.class);
		if(expansionJspCreaters!=null && expansionJspCreaters.size() >0){
			for(Map.Entry<String, ExpandJspForHomePage> entry  : expansionJspCreaters.entrySet()){
				ExpandJspForHomePage expansionJspCreater = entry.getValue();
				expansionJspForHomepage.add(expansionJspCreater);
			}
		}
		
		log.info("初始化外部模块需要在首页增加参数控制、JSP页面引用的接口");
	}
	
    /**
     * 登陆页显示
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unused" })
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (cloginPage == null) {
            String loginPage = systemConfig.get("login_page");
            if (loginPage != null)
                cloginPage = loginPage;
            else
                cloginPage = DefaultLoginPage;
        }
        String selectedPath = null;
        PortalTemplateSetting setting = (PortalTemplateSetting) request.getAttribute("PortalLoginTemplateSetting");
        Long loginAccountId = (Long) request.getAttribute("loginAccountId");
        List<PortalHotspot> hotSpots = null;
        if(setting == null){
        	setting= portalCacheManager.getLoginSettingBy(OrgConstants.GROUPID.longValue(), OrgConstants.GROUPID.longValue());
        	//setting = portalTemplateSettingManager.getLoginSettingBy(OrgConstants.GROUPID.longValue(), OrgConstants.GROUPID.longValue());
        	//hotSpots = portalHotSpotManager.getHotSpotsBy(setting.getTemplateId(), null, OrgConstants.GROUPID.longValue(), OrgConstants.GROUPID.longValue());
        	hotSpots = portalCacheManager.getHotSpotsBy(setting.getTemplateId(), null, OrgConstants.GROUPID.longValue(), OrgConstants.GROUPID.longValue());
        } else {
        	//hotSpots = portalHotSpotManager.getHotSpotsBy(setting.getTemplateId(), null, loginAccountId, loginAccountId);
        	hotSpots = portalCacheManager.getHotSpotsBy(setting.getTemplateId(), null, loginAccountId, loginAccountId);
        }
        //PortalLoginTemplate plt = DBAgent.get(PortalLoginTemplate.class, setting.getTemplateId());
        PortalLoginTemplate plt = portalCacheManager.getLoginTemplate(setting.getTemplateId());
        if (plt != null) {
            String path = plt.getPath();
            if (path != null && path.trim().length() > 0) {
                selectedPath = "/main/login/" + path;
            }
        }
        ModelAndView modelAndView = null;
        if (selectedPath != null) {
            modelAndView = new ModelAndView("raw:" + selectedPath);
        } else {
            modelAndView = new ModelAndView("raw:" + cloginPage);
        }
        //二维码,判断登录页二维码显示哪个端的二维码,默认m3
        String mobile="m3";
        boolean m1=AppContext.hasPlugin("m1");
        boolean m3=AppContext.hasPlugin("m3");
        if(m1){
        	mobile="m1";
        }
        if(m3){//同时有m3和m1插件的时候显示m3
        	mobile="m3";
        }
        if(m1&&m3){
        	String mx=SystemEnvironment.getMxVersion();
        	if(Strings.isNotBlank(mx)){
        		mobile=mx.toLowerCase();
        	}
        }
        modelAndView.addObject("mobile",mobile);
        Locale currentLocale = LocaleContext.make4Frontpage(request);
        List localeCode = new ArrayList();
        Map localeCodeCfg = new HashMap();
        localeCode.add(localeCodeCfg);
        localeCodeCfg.put("eleid", LoginConstants.LOCALE);
        localeCodeCfg.put("defaultValue", currentLocale.toString());
        localeCodeCfg.put("options", getLocaleInfo());

        String loginTitleName = Functions.getPageTitle();
        modelAndView.addObject("templatesJsonStr", JSONUtil.toJSONString(plt));
        modelAndView.addObject("hotSpotsJsonStr", JSONUtil.toJSONString(hotSpots));
        String layout = "all";
        if (CollectionUtils.isNotEmpty(hotSpots) && plt.getPreset() == 1) {
            //预置的
            for (PortalHotspot hotspot : hotSpots) {
                if ("note".equals(hotspot.getHotspotkey())) {
                    String noteName = hotspot.getHotspotvalue();
                    if (noteName == null || noteName.trim().length() == 0 || "null".equals(noteName)) {
                        loginTitleName = Functions.getVersion();
                    } else {
                        String suffix = SystemProperties.getInstance().getProperty("portal.loginTitle");
                        loginTitleName = ResourceUtil.getString(noteName + suffix) + " " + Functions.getVersion();
                    }
                }
                if ("layout".equals(hotspot.getHotspotkey())) {
                    layout = hotspot.getHotspotvalue();
                }
                if("showQr".equals(hotspot.getHotspotkey())){
                	modelAndView.addObject("showQr", "1".equals(hotspot.getHotspotvalue()));
                }
            }
        }
        Map<String,String> bgImgSize=portalCacheManager.getCurrentLoginImgSize(hotSpots);
        modelAndView.addObject("bgImgSize", JSONUtil.toJSONString(bgImgSize));
        modelAndView.addObject("layout", layout);
        Map<String, LoginActiveX> activeXMap = loginControl.getLoginActiveXes();
        StringBuilder activeXLoader = new StringBuilder();
        if (activeXMap != null) {
            Iterator<String> ite = activeXMap.keySet().iterator();
            String key;
            while (ite.hasNext()) {
                key = ite.next();
                LoginActiveX loginActiveX = activeXMap.get(key);
                String activeX = loginActiveX.getActiveX(request, response);
                activeXLoader.append(activeX);
            }
        }

        modelAndView.addObject("currentLocale", currentLocale);
        modelAndView.addObject("locales", JSONUtil.toJSONString(localeCode));
//        modelAndView.addObject("locales", JSONMapper.toJSON(localeCode).render(false));
        //modelAndView.addObject("loginImgFileName", MainDataLoader.getInstance().getLoginImagePath());
        modelAndView.addObject("loginTitleName", loginTitleName);
        modelAndView.addObject("productCategory", ProductEditionEnum.getCurrentProductEditionEnum().getName());
        //并发数
        this.setProductInfo(modelAndView);
        modelAndView.addObject("ServerState", ServerState.getInstance().isShutdown());
        modelAndView.addObject("ServerStateComment", Strings.toHTML(ServerState.getInstance().getComment()));
        if (onlineManager == null) {
            modelAndView.addObject("OnlineNumber", "...");
        } else {
            modelAndView.addObject("OnlineNumber", this.onlineManager.getOnlineNumber());
        }
        modelAndView.addObject("verifyCode", "enable".equals(this.systemConfig.get("verify_code")));
        modelAndView.addObject("activeXLoader", activeXLoader.toString());
        if (LDAPConfig.getInstance().getIsEnableLdap()
                && request.getServerName().equalsIgnoreCase(LDAPConfig.getInstance().getA8ServerDomainName())) {
            String adssoToken = request.getHeader("authorization");
            if (adssoToken == null) {
                modelAndView.addObject("adSSOEnable", true);
            } else {
                //             modelAndView.addObject("adLoginName",ADSSOEvent.getInstance().getADLoginName(adssoToken));
                modelAndView.addObject("authorization", adssoToken);
            }
        }
        loadCAPlugIn(request, modelAndView);
        //modelAndView.addObject("hasPluginCA", true);
        String exceptPlugin = "";
        String ucServerIpOrPort = "NULL/NULL/5222";
        if (!AppContext.hasPlugin("videoconference")) {
            exceptPlugin += "@videoconf";
        }
        if (!AppContext.hasPlugin("https")) {
            exceptPlugin += "@seeyonRootCA";
        }
        if (!AppContext.hasPlugin("identification")) {
            exceptPlugin += "@identificationDog";
        }
        if (!AppContext.hasPlugin("officeOcx")) {
            exceptPlugin += "@officeOcx";
        }
        if (!AppContext.hasPlugin("barCode")) {
            exceptPlugin += "@erweima";
        }
		if (!AppContext.hasPlugin("u8")) {
			exceptPlugin += "@U8Reg";
		}
		exceptPlugin += "@wizard";
        if (AppContext.hasPlugin("uc")&&AppContext.hasPlugin("zx")) { //有zx插件才显示
            String ucServerInIp = ucApi.getUcServerInip();
            if (Strings.isBlank(ucServerInIp)) {
                ucServerInIp = "NULL";
            }
            String ucServerOutIp = ucApi.getUcServerOutip();
            if (Strings.isBlank(ucServerOutIp)) {
                ucServerOutIp = "NULL";
            }
            String ucC2sPort = ucApi.getUcC2sPort();
            if (Strings.isBlank(ucC2sPort)) {
                ucC2sPort = "5222";
            }
            ucServerIpOrPort = ucServerInIp + "/" + ucServerOutIp + "/" + ucC2sPort;
        }
        else {
            exceptPlugin += "@zhixin";
        }

        modelAndView.addObject("ucServerIpOrPort", ucServerIpOrPort);
        modelAndView.addObject("exceptPlugin", exceptPlugin);
        // 判断是否能发送手机短信
        boolean isCanUseSMS = false;
//        if (AppContext.hasPlugin("sms")) {
            if (mobileMessageManager.isCanUseSMS()) {
            	isCanUseSMS = true;
            }
//        }
        modelAndView.addObject("isCanUseSMS", isCanUseSMS);
        
        //判断系统配置是否启用口令加密传输，启用则生成加密种子传到页面
        if (SecurityHelper.isCryptPassword())
            modelAndView.addObject("_SecuritySeed", SecurityHelper.getSessionContextSeed());
        //产品服务到期,产品授权到期
        ConfigItem dueRemind=configManager.getConfigItem("login_page", "dueRemind");
        modelAndView.addObject("dueRemindV",dueRemind==null?"1":dueRemind.getConfigValue());
        if(dueRemind==null||"1".equals(dueRemind.getConfigValue())){
        	modelAndView.addObject("dueRemind",portalCacheManager.getDueRemind());
        }
        
    	if(UpgradeUtil.upgradeIngTag){//表单升级中
            HttpSession session = request.getSession(false);
            AppContext.putSessionContext(LoginConstants.Result, ResourceUtil.getString("login.label.ErrorCode.50"));
    	}else if(!UpgradeUtil.isUpgradedV5()){
            HttpSession session = request.getSession(false);
            AppContext.putSessionContext(LoginConstants.Result, ResourceUtil.getString("login.label.ErrorCode.51"));
    	}
    	String loginPageURL = (String) request.getAttribute("loginPageURL");
    	Cookie cookie = null;
    	if(loginPageURL == null){
    		loginPageURL="";
    	}
    	  cookie = new Cookie("loginPageURL", loginPageURL);
          cookie.setMaxAge(expiry);
          cookie.setPath("/");
          response.addCookie(cookie);
        return modelAndView;
    }

    private Map localeInfo = null;
	private Map getLocaleInfo() {
		if(localeInfo==null){
			localeInfo = new LinkedHashMap();
	        List<Locale> locales = LocaleContext.getAllLocales();
	        String locStr;
	        for (Locale loc : locales) {
	            locStr = loc.toString();
	            localeInfo.put(locStr, ResourceUtil.getString("localeselector.locale." + locStr));
	        }
		}
		return localeInfo;
	}

    private void loadCAPlugIn(HttpServletRequest request, ModelAndView modelAndView)
            throws UnsupportedEncodingException {
        String caFactory = SystemProperties.getInstance().getProperty("ca.factory");
        String factoryJsp = "/WEB-INF/jsp/ca/ca4" + caFactory + ".jsp";
        String sslVerifyCertValue = "no";
        String keyNum = "noKey";
        boolean hasPluginCA = AppContext.hasPlugin("ca");
        //如果是格尔CA厂商,从cookie中获取
        if ("koal".equals(caFactory)) {
            Cookie[] cookies = request.getCookies();
            if (cookies == null) {
                cookies = new Cookie[0];
            }
            for (int i = 0; i < cookies.length; i++) {
                Cookie cookie = cookies[i];
                //是否通过CA校验
                if ("SSL_VERIFY_CERT".equals(cookie.getName())) {
                    sslVerifyCertValue = new String(java.net.URLDecoder.decode(cookie.getValue())
                            .getBytes("ISO-8859-1"), "utf-8");
                }
                if ("KOAL_CERT_CN".equals(cookie.getName())) {
                    keyNum = new String(java.net.URLDecoder.decode(cookie.getValue()).getBytes("ISO-8859-1"), "utf-8");
                }
            }
        }
        if("Jit".equals(caFactory)){
        	this.loadJitCAPlugin(request, modelAndView);
        }
        modelAndView.addObject("caFactory", caFactory);
        modelAndView.addObject("sslVerifyCertValue", sslVerifyCertValue);
        modelAndView.addObject("keyNum", keyNum);
        modelAndView.addObject("hasPluginCA", hasPluginCA);
        modelAndView.addObject("pageUrl", factoryJsp);
        File jspFile = new File(SystemEnvironment.getApplicationFolder() + factoryJsp);
        if (hasPluginCA && !"koal".equals(caFactory) && jspFile.exists()) {
            modelAndView.addObject("includeJsp", true);
        } else {
            modelAndView.addObject("includeJsp", false);
        }
    }
    private void loadJitCAPlugin(HttpServletRequest request,ModelAndView modelAndView){
    	HttpSession session = request.getSession();
    	String randNum = generateRandomNum();
		/**************************
		 * 第三步 服务端返回认证原文   *
		 **************************/
		// 设置认证原文到session，用于程序向后传递，通讯报文中使用
    	AppContext.putSessionContext("ToSign", randNum);

		// 设置认证原文到页面，给页面程序提供参数，用于产生认证请求数据包
    	modelAndView.addObject("original", randNum);
    }
    /**
	 * 产生认证原文
	 */
	private String generateRandomNum() {
		/**************************
		 * 第二步 服务端产生认证原文   *
		 **************************/
		String num = "1234567890abcdefghijklmnopqrstopqrstuvwxyz";
		int size = 6;
		char[] charArray = num.toCharArray();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < size; i++) {
			sb
					.append(charArray[((int) (Math.random() * 10000) % charArray.length)]);
		}
		return sb.toString();
	}
    /**
     * Locale切换
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView changeLocale(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Locale locale = LocaleContext.parseLocale((String) ParamUtil.getJsonParams().get(LoginConstants.LOCALE));
        if(locale==null){
        	locale = Locale.getDefault();
        }
        String loginPageURL="";
        Cookie[] cookies = request.getCookies();
        if(cookies != null){
            for(Cookie cookie : cookies){
                if("loginPageURL".equals(cookie.getName()) && cookie.getValue().length() > 0){
                	loginPageURL=cookie.getValue();
                }
            }
        }
        LocaleContext.setLocale(request, locale);
//        if (locale.equals(LocaleContext.getAllLocales().get(0))) {
//            //OA-24343 减少不必要的Cookie存储
//            Cookies.remove(response, LoginConstants.LOCALE);
//        } else {
            Cookies.add(response, LoginConstants.LOCALE, locale.toString(), Cookies.COOKIE_EXPIRES_FOREVER);
//        }
        User user = AppContext.getCurrentUser();
        if (user != null)
            user.setLocale(locale);
        
        if(null==loginPageURL||"".equals(loginPageURL)){
        	return this.index(request, response);
        }else{
        	ModelAndView mav=new ModelAndView();
        	mav.setView(new RedirectView(loginPageURL));
        	return mav;
        }
    }

    /**
     * 首页模板切换，当前用户拥有多首页模板的授权时可用于在可用模板间切换
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView changeTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long portalTemplateId = ParamUtil.getLong(request.getParameterMap(), "portalTemplateId");
        String showSkinchoose = request.getParameter("showSkinchoose");
        //集团/单位管理员是否刚切换过布局（尚未保存到数据库）
        String isPortalTemplateSwitching = request.getParameter("isPortalTemplateSwitching");
        loginControl.transChangeTemplate(portalTemplateId);
        StringBuilder url = new StringBuilder("main.do?method=main");
        if(showSkinchoose != null){
        	url.append("&showSkinchoose=true");
        }
        if(isPortalTemplateSwitching != null){
        	url.append("&isPortalTemplateSwitching=true");
        }
        response.sendRedirect(url.toString());
        return null;
    }

    /**
     * 登陆动作
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView login(HttpServletRequest request, HttpServletResponse response) throws Exception {

        //OA-24354 注销原有session，创建新的session
        HttpSession session = request.getSession(false);
        try {
    	if(UpgradeUtil.upgradeIngTag){//表单升级中
            BusinessException be = getBusinessException(new BusinessException("login.label.ErrorCode.50"));
            goout(request, session, response, be, true);
            return null;
    	}
    	if(!UpgradeUtil.isUpgradedV5()){
    		super.rendJavaScriptUnclose(response, "alert(\""+ResourceUtil.getString("login.label.ErrorCode.51")+"\");");
            ModelAndView view = new ModelAndView("ctp/form/upgrade/formUpgradeIframe");
            view.addObject("viewUpgrade", true);
    		return view;
    	}


        //校验码转移
        String verifyCode = null;
        //iTrusCA校验码转移
        String oriToSign = null;
        //登陆口令加密种子
        String seed = null;
        if (session != null) {
            verifyCode = (String) session.getAttribute(LoginConstants.VerifyCode);
            oriToSign = (String) session.getAttribute("ToSign");
            seed = (String)session.getAttribute(GlobalNames.SESSION_CONTEXT_SECURITY_SEED_KEY);
            try {
                session.invalidate();
            } catch (Throwable t) {
                //ignore it
            }
        }

        session = request.getSession(true);
        AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_SESSION_KEY, session);
        if (Strings.isNotBlank(verifyCode)) {
            AppContext.putSessionContext(LoginConstants.VerifyCode, verifyCode);
        }
        if (Strings.isNotBlank(oriToSign)) {
            AppContext.putSessionContext("ToSign", oriToSign);
        }
        if (Strings.isNotBlank(seed)) {
            AppContext.putSessionContext(GlobalNames.SESSION_CONTEXT_SECURITY_SEED_KEY, seed);
        }
        //Session线程变量更新
        AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_SESSION_KEY, session);

       loginControl.transDoLogin(request, session, response);
       AppContext.putSessionContext("login_validatePwdStrength", request.getParameter("login_validatePwdStrength"));

        User user = AppContext.getCurrentUser();
        if (user.getExternalType() != null && user.getExternalType() != OrgConstants.ExternalType.Inner.ordinal()) {//V-Join用户不能登录V5
            LoginResult error = LoginResult.ERROR_UNKNOWN_USER;
            BusinessException e = new BusinessException("login.label.ErrorCode." + error.getStatus(), error.getParameters());
            e.setCode(String.valueOf(error.getStatus()));
            log.info(user.getLoginName() + " 不是v5人员!");
            throw e;
        }

        String username = user.getLoginName();
        String password = user.getPassword();
        String userAgentFrom = user.getUserAgentFrom();
        Locale locale = user.getLocale();
        String fontSize = (String)request.getParameter("fontSize");
        if(Strings.isNotBlank(fontSize)){
        	AppContext.putSessionContext("fontSize", fontSize);
        }

        AppContext.putSessionContext("ssoFrom", Strings.escapeNULL(request.getParameter("ssoFrom"), "PC"));

        //登录成功的目标页面
        String destination = this.getDestination(request, session);

        writeCookie(request, response, session, username, password, userAgentFrom, locale);
        //OA-23900 首页展现增加随机数种子校验，解决部分浏览器关闭窗口后还能打开首页操作的安全漏洞
        /*int random = SecurityHelper.randomInt();
        AppContext.putSessionContext(GlobalNames.SESSION_CONTEXT_MAINPAGE_SEED_KEY, random);
        StringBuilder buf = new StringBuilder(destination);
        if (buf.indexOf("?") != -1)
            buf.append('&');
        else
            buf.append('?');
        buf.append("r=").append(random);
        response.sendRedirect(buf.toString());*/
        
        response.sendRedirect(destination);
    	} catch (Throwable e) {
            BusinessException be = getBusinessException(e);
            if(!(e instanceof InfrastructureException)){
            	log.error(e.getLocalizedMessage(),e);
            }
            goout(request, session, response, be, true);
            return null;
        }
        return null;
    }

    /**
     * Vjoin系统登录
     */
    public ModelAndView login4Vjoin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        try {
            //清除session
            this.logout4Session(request, response);

            session = request.getSession(true);
            AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_SESSION_KEY, session);

            if (!AppContext.hasPlugin("vjoin")) {
                LoginResult error = LoginResult.ERROR_DOG_EXPIRED;
                BusinessException e = new BusinessException("login.label.ErrorCode." + error.getStatus(), error.getParameters());
                e.setCode(String.valueOf(error.getStatus()));
                throw e;
            }

            loginControl.transDoLogin(request, session, response);

            User user = AppContext.getCurrentUser();
            if (!AppContext.hasPlugin("vjoin") || user.getExternalType() != OrgConstants.ExternalType.Interconnect1.ordinal()) {
                LoginResult error = LoginResult.ERROR_UNKNOWN_USER;
                BusinessException e = new BusinessException("login.label.ErrorCode." + error.getStatus(), error.getParameters());
                e.setCode(String.valueOf(error.getStatus()));
                throw e;
            }
        } catch (Throwable e) {
            BusinessException be = getBusinessException(e);
            if (!(e instanceof InfrastructureException)) {
                log.error(e.getLocalizedMessage(), e);
            }
            goout(request, session, response, be, false);
            return null;
        }
        return null;
    }

    /**
     * 致信登录（单独）
     */
    //致信2.0登录
    public ModelAndView login4Ucpc(HttpServletRequest request, HttpServletResponse response) throws Exception {
    		return loginForUcpc(request, response, false);
    }
    //致信3.0登录
    public ModelAndView login4Ucpc3(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return loginForUcpc(request, response, true);
    }
    /**
     * 
     * @param request
     * @param response
     * @param isIgnoreOnline 是否忽略不添加至为登录用户（true：不占并发，false：占并发）
     * @return
     * @throws Exception
     */
    private ModelAndView loginForUcpc(HttpServletRequest request, HttpServletResponse response ,Boolean isIgnoreOnline) throws Exception {
    	  HttpSession session = request.getSession(false);
          try {
              if (session != null) {
                  try {
                      session.invalidate();
                  } catch (Throwable t) {
                      //ignore it
                  }
              }

              session = request.getSession(true);
        //Session线程变量更新
        AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_SESSION_KEY, session);
        if(isIgnoreOnline){
        		request.setAttribute("IgnoreOnlineCheck",true);
        }  
       loginControl.transDoLogin(request, session, response);
       AppContext.putSessionContext("login_validatePwdStrength", request.getParameter("login_validatePwdStrength"));

        User user = AppContext.getCurrentUser();
        if (user.getExternalType() != OrgConstants.ExternalType.Inner.ordinal()) {//V-Join用户不能登录致信
            LoginResult error = LoginResult.ERROR_UNKNOWN_USER;
            BusinessException e = new BusinessException("login.label.ErrorCode." + error.getStatus(), error.getParameters());
            e.setCode(String.valueOf(error.getStatus()));
            throw e;
        }
        String username = user.getLoginName();
        String password = user.getPassword();
        String userAgentFrom = user.getUserAgentFrom();
        Locale locale = user.getLocale();
        String fontSize = (String)request.getParameter("fontSize");
        if(Strings.isNotBlank(fontSize)){
        		AppContext.putSessionContext("fontSize", fontSize);
        }
        AppContext.putSessionContext("ssoFrom", Strings.escapeNULL(request.getParameter("ssoFrom"), "PC"));
        writeCookie(request, response, session, username, password, userAgentFrom, locale);
        if(userAgentFrom.equals(Constants.login_useragent_from.ucpc.name())){
	        	HashMap<String,String> resultMap=new HashMap<String,String>();
	        	resultMap.put("LoginOK", response.getHeader("LoginOK"));
	        	resultMap.put("JSESSIONID", session.getId());
	        	response.getWriter().write(JSONUtil.toJSONString(resultMap));
        }
        } catch (Throwable e) {
            BusinessException be = getBusinessException(e);
            if (!(e instanceof InfrastructureException)) {
                log.error(e.getLocalizedMessage(), e);
            }
            goout4Ucpc(request, session, response, be);
            return null;
        }
        return null;
    }
    
    private String getDestination(HttpServletRequest request, HttpSession session) {
        String destination = request.getParameter(LoginConstants.DESTINATION);
        if (destination != null)
            AppContext.putSessionContext(LoginConstants.DESTINATION, destination);
        else
            session.removeAttribute(LoginConstants.DESTINATION);

        if (destination == null || destination.equals(request.getContextPath())) {
            String contextPath = request.getContextPath();
            if ("/".equals(contextPath)) {
                contextPath = "";
            }

            destination = contextPath + appDefaultPath;
        }

        return destination;
    }

    private BusinessException getBusinessException(Throwable e) {
        if (e == null)
            return null;
        if (e instanceof BusinessException)
            return (BusinessException) e;
        else {
            return getBusinessException(e.getCause());
        }
    }
    private String getSearchRuValue(){
    	StringBuffer sb=new StringBuffer("[");
    	sb.append("'全部'");
    	if(AppContext.hasPlugin("collaboration")){
    		sb.append(",'协同'");
    	}
    	if(AppContext.hasPlugin("edoc")){
    		sb.append(",'公文'");
    	}
    	if(AppContext.hasPlugin("meeting")){
    		sb.append(",'会议'");
    	}
    	if(AppContext.hasPlugin("bulletin")){
    		sb.append(",'公告'");
    	}
    	if(AppContext.hasPlugin("doc")){
    		sb.append(",'文档'");
    	}
    	sb.append(",'附件名']");
    	return sb.toString();
    }

    /**
     * 首页展现，登陆后或首页模板切换后调用
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //ServletRequestImpl.invoke(request);

        HttpSession session = request.getSession(false);
        /*if (session != null) {
            //OA-23900 首页展现增加随机数种子校验，解决部分浏览器关闭窗口后还能打开首页操作的安全漏洞
            Integer random = (Integer) session.getAttribute(GlobalNames.SESSION_CONTEXT_MAINPAGE_SEED_KEY);
            String r = request.getParameter("r");
            if (random == null || !random.toString().equals(r)) {
                redirectToIndex(request, response);
                session.invalidate();
                return null;
            }
        } else {
            return index(request, response);
        }*/
        if (session == null)
            return index(request, response);

        User user = AppContext.getCurrentUser();
        
        if(user!=null){
        	//有种情况打开首页会没有初始化数据,通过access打开协同或消息后 session 是有了,但是没有执行inituser的方法,所以此时跳转到main会没有菜单等信息
            Object menus=user.getProperty("menus");Object spaceJson=user.getProperty("spacesList");        		
           //项目  信达资产   公司  kimde  修改人  msg  修改时间   2018-01-04   修改功能：修改主页一级菜单是否显示  start 
            List<MenuBO> list =(List<MenuBO>)menus;
            
            for(int i = list.size() - 1; i >= 0; i--){// 需要改成 服务器上的真实一级菜单名称拼接
            		MenuBO menuBO = list.get(i);
            	if(menuBO.getName().equals("机构动态") || menuBO.getName().equals("教育培训")|| 
            	   menuBO.getName().equals("交流园地") || menuBO.getName().equals("知识文库")|| 
            	   menuBO.getName().equals("信息发布") || menuBO.getName().equals("我的工具"))
            		list.remove(menuBO);
			}
          //项目  信达资产   公司  kimde  修改人  msg  修改时间      2018-01-04   修改功能：修改主页一级菜单是否显示  end
            
            if(menus==null||spaceJson==null){
            	this.loginControl.initLoginUser();
            }
        }
        
        if (user != null) {
            if (cframePage == null) {
                String framePage = systemConfig.get("frame_page");
                if (framePage != null)
                    cframePage = framePage;
                else
                    cframePage = DefaultFramePage;
            }
			//客开 EIP 门户改造 20170227 start
            ModelAndView modelAndView= new ModelAndView("raw:/main/frames/pageLayout/index.jsp");
            Boolean bEIP = null;
            
            if(eipApi!=null){
            	String openOA = request.getParameter("EIPTicket");
            	if(StringUtils.isEmpty(openOA)){
            		openOA = request.getParameter("showSkinchoose");
            	}
            	if(bEIP==null){            		
            		bEIP = eipApi.judgeEIP(openOA, session);
            	}
            	if(bEIP){
                	modelAndView= new ModelAndView("raw:/main/frames/cipPageLayout/index.jsp");
                }	
            }
            
            //ModelAndView modelAndView= new ModelAndView("raw:/main/frames/pageLayout/index.jsp");
            //客开 EIP 门户改造 20170227 end
            // 判断是否具有发送手机短信的权限(是否显示手机图标)
            boolean isCanSendSMS = false;
//            if (AppContext.hasPlugin("sms")) {
                if (mobileMessageManager.isCanSend(user.getId(), user.getLoginAccount())) {
                    isCanSendSMS = true;
                }
//            }
            modelAndView.addObject("isCanSendSMS", isCanSendSMS);
            //是否开启个人打卡
            String ci = systemConfig.get(IConfigPublicKey.CARD_ENABLE);
            boolean cardEnabled = ci != null && "enable".equals(ci) && AppContext.hasPlugin("attendance");
            //是否开启薪资查看
            String sal = systemConfig.get(IConfigPublicKey.SALARY_ENABLE);
            boolean salaryEnabled = sal != null && "enable".equals(sal);
            boolean appcenterEnabled=true;
            if(ProductEditionEnum.isU8OEM()){
            	cardEnabled=false;//U8不显示考勤打卡
            	appcenterEnabled=false;//云应用中心不显示
            }
            modelAndView.addObject("cardEnabled", cardEnabled);
            modelAndView.addObject("salaryEnabled", salaryEnabled);
            modelAndView.addObject("appcenterEnabled", appcenterEnabled);
            
            int onlineNum = onlineManager.getOnlineNumber();
            modelAndView.addObject("onlineNumber", onlineNum);
//            if(user.isAdmin()){
//	            String uframe = user.getMainFrame();
//	            if (uframe != null) {
//	                modelAndView = new ModelAndView("raw:" + uframe);
//	            } else {
//	                modelAndView = new ModelAndView("raw:" + cframePage);
//	            }
//            }else{
            	String contextPath= request.getContextPath();
            	Map<String, Object> dataMap= new HashMap<String, Object>();
            	dataMap.put("isCanSendSMS", String.valueOf(isCanSendSMS));
            	dataMap.put("cardEnabled", String.valueOf(cardEnabled));
            	dataMap.put("appcenterEnabled", String.valueOf(appcenterEnabled));
            	dataMap.put("salaryEnabled", String.valueOf(salaryEnabled));
            	dataMap.put("onlineNum", String.valueOf(onlineNum));
                PageRenderResult pageRenderResult  = portalCacheManager.generateHtmlPage(user,contextPath,dataMap);
                if(null!=pageRenderResult){
					// 客开 EIP 门户改造 20170227 start
					if(bEIP!=null&&bEIP){
                		String html = "<iframe marginheight=\"0\" marginwidth=\"0\" height=\"100%\" style=\"height: 100%;\" src=\"\\seeyon\\zyPortalController.do?method=zyPortalMain\" name=\"dataIFrame\" scroll=\"no\" id=\"dataIFrame\" width=\"100%\" frameborder=\"0\"></iframe>";
                		pageRenderResult.setBodyHtml(html);
                		pageRenderResult.setCustomJS("/seeyon/main/frames/cipPageLayout/layout001/frount_56.js");
                		pageRenderResult.setDefaultLayoutCssPath("/seeyon/main/frames/cipPageLayout/layout001/main.css");
                	}
					// 客开  EIP 门户改造 20170227 end
	                modelAndView.addObject("pageRenderResult", pageRenderResult);
	                user.setProperty(UserCustomizeCache.DEFAULT_SKIN_PATH, pageRenderResult.getDefaultSkinCssPath());
                }else{
                	String uframe = user.getMainFrame();
                    if (uframe != null) {
                        modelAndView = new ModelAndView("raw:" + uframe);
                    } else {
                        modelAndView = new ModelAndView("raw:" + cframePage);
                    }
                }
//            }
                
            //允许个人设置密码
            String personModifyPwd = SystemProperties.getInstance().getProperty("person.disable.modify.password");
            modelAndView.addObject("personModifyPwd", "1".equals(personModifyPwd));
            
    		/**
    		 * 普通用户修改密码时，提示过期或者强度不符合要求的情况。
    		*1.系统参数设置，禁用个人修改密码，不提示
    		*2.没有开启目录绑定条目，提示。
    		*3.开启了目录绑定条目
    			a.没有绑定，用oa账号进行登陆（开启了可以用oa账号登陆的设置），提示。
    			b.绑定了，用ad账号进行登陆，系统设置中设置了允许在协同中修改LDAP密码，并使用ssl方式，提示.其他情况不提示。
    		 */
            boolean checkPwd =  true;
            if(!user.isAdmin()){
            	if("1".equals(personModifyPwd)){
            		checkPwd = false;
            	}else if(!LdapUtils.isLdapEnabled()){
            		checkPwd = true;
            	}else{
            		if(!LdapUtils.isBind(AppContext.getCurrentUser().getId())){
            			checkPwd = true;
            		}else{
            			if(LdapUtils.isOaCanModifyLdapPwd() && LDAPConfig.getInstance().getIsEnableSSL()){
            				checkPwd = true;
            			}else{
            				checkPwd = false;
            			}
            		}
            	}
            }
            modelAndView.addObject("checkPwd", checkPwd);
            
            Object[] pwdExpirationInfo = (Object[]) V3xShareMap.get("PwdExpirationInfo-" + user.getLoginName());
            modelAndView.addObject("pwdExpirationInfo", pwdExpirationInfo);
            
            //判断是否密码到期或者不符合强度要求强制校验
            String pwdmodify_force_enable=systemConfig.get("pwdmodify_force_enable");
            modelAndView.addObject("pwdmodify_force_enable", pwdmodify_force_enable);
            //登陆时输入的密码的密码强度
            String login_validatePwdStrength = String.valueOf(session.getAttribute("login_validatePwdStrength")); 
            //如果没有取到密码强度，设置强度为最高（可能是从其他途径 致信等方式跳转过来的）
            int loginPwdStrength = (Strings.isNotBlank(login_validatePwdStrength) && !"null".equals(login_validatePwdStrength))?Integer.valueOf(login_validatePwdStrength):4;
            
            //密码强度
            String pwd_strong_require=systemConfig.get("pwd_strong_require");
            int requirePwdStrength = 1;
            if(pwd_strong_require.isEmpty()){
            	pwd_strong_require = "weak";
            }
            if("weak".equals(pwd_strong_require)){
            	requirePwdStrength =1;
            }
            if("medium".equals(pwd_strong_require)){
            	requirePwdStrength =2;
            }
            if("strong".equals(pwd_strong_require)){
            	requirePwdStrength =3;
            }
            if("best".equals(pwd_strong_require)){
            	requirePwdStrength =4;
            }
            
            //不符合强度要求
            if(loginPwdStrength<requirePwdStrength){
            	modelAndView.addObject("login_validatePwdStrength", false);            		
            }else{
            	modelAndView.addObject("login_validatePwdStrength", true);    
            }

            //是否需要播放声音
            boolean isEnableMsgSound = false;
            String enableMsgSoundConfig = this.systemConfig.get(IConfigPublicKey.MSG_HINT);
            if (enableMsgSoundConfig != null) {
                if ("enable".equals(enableMsgSoundConfig)) {
                    isEnableMsgSound = "true".equals(user.getCustomize(CustomizeConstants.MESSAGESOUNDENABLED));
                }
            }
            //全文检索下拉框内容
            String searchRuValue=getSearchRuValue();
            modelAndView.addObject("searchRuValue", searchRuValue);
            
            modelAndView.addObject("isEnableMsgSound", isEnableMsgSound);
            //消息查看后是否需要从消息框中移出  2009年7月23日 dongyj
            modelAndView.addObject("msgClosedEnable",
                    !"false".equals(user.getCustomize(CustomizeConstants.MESSAGEVIEWREMOVED)));
            //NC专用
            String currentSpaceForNC = request.getParameter("currentSpaceForNC");
            modelAndView.addObject("currentSpaceForNC", currentSpaceForNC);
            //标题
            //String pageTitle = portalManager.getPageTitle();
            String pageTitle = portalCacheManager.getPageTitle();
            modelAndView.addObject("pageTitle", pageTitle);
            //集团外文名称
            String groupSecondName = portalManager.getGroupSecondName();
            modelAndView.addObject("groupSecondName", Strings.escapeJavascript(groupSecondName));
            //当前单位外文名称
            String accountSecondName = portalManager.getAccountSecondName();
            modelAndView.addObject("accountSecondName", Strings.escapeJavascript(accountSecondName));
            //皮肤路径
            String skinPathKey = PortalFunctions.getSkinPathKey(user);
            modelAndView.addObject("skinPathKey", skinPathKey);
            //换肤,整体主题切换使用
            user.setSkin(skinPathKey);
            //IE内存泄露，刷新页面使用
            String mainMenuId = request.getParameter("mainMenuId");
            if (Strings.isNotBlank(mainMenuId)) {
                modelAndView.addObject("mainMenuId", mainMenuId);
            }
            String clickMenuId = request.getParameter("clickMenuId");
            if (Strings.isNotBlank(clickMenuId)) {
                modelAndView.addObject("clickMenuId", clickMenuId);
            }
            String mainSpaceId = request.getParameter("mainSpaceId");
            if (Strings.isNotBlank(mainSpaceId)) {
                modelAndView.addObject("mainSpaceId", mainSpaceId);
            }
            String shortCutId = request.getParameter("shortCutId");
            if (Strings.isNotBlank(shortCutId)) {
                modelAndView.addObject("shortCutId", shortCutId);
            }
            String isRefresh = request.getParameter("isRefresh");
            if(Strings.isNotBlank(isRefresh)){
                modelAndView.addObject("isRefresh", isRefresh);
            }
            String showSkinchoose = request.getParameter("showSkinchoose");
            if(Strings.isNotBlank(showSkinchoose)){
            	modelAndView.addObject("showSkinchoose", showSkinchoose);
            }
            String isPortalTemplateSwitching = request.getParameter("isPortalTemplateSwitching");
            if(Strings.isNotBlank(isPortalTemplateSwitching)){
            	modelAndView.addObject("isPortalTemplateSwitching", isPortalTemplateSwitching);
            }
            String portal_default_page = request.getParameter("portal_default_page");
            if(Strings.isNotBlank(portal_default_page)){
            	modelAndView.addObject("portal_default_page", portal_default_page);
            }
            //是否从致信打开---致信已经改成调用main不用sso了.
//            String openFrom = (String) session.getAttribute("ssoFrom");
//            if(Strings.isNotBlank(openFrom)){
//            	modelAndView.addObject("openFrom", openFrom);
//            } else {
//            	modelAndView.addObject("openFrom", "");
//            }
            String openFrom = request.getParameter("from");
            if(Strings.isNotBlank(openFrom)){
            	modelAndView.addObject("openFrom", openFrom);
            } else {
            	modelAndView.addObject("openFrom", "");
            }
            
            //大字体传参
            String fontSize = (String) session.getAttribute("fontSize");
            if(Strings.isNotBlank(fontSize)&&!"12".equals(fontSize)){
            	user.setFontSize(fontSize);
            }else{
            	user.setFontSize("");
            }
			if (!user.isAdmin()) {// 非管理员
				OnlineUser onlineUser = OnlineRecorder.getOnlineUser(user);
				if (null != onlineUser) {
					Map<login_sign, LoginInfo> loginInfoMapper = onlineUser.getLoginInfoMap();
					if (loginInfoMapper != null
							&& Constants.login_useragent_from.pc.name().equals(user.getUserAgentFrom())) {// 如果当前登录是pc
						String pLang = user.getCustomize(CustomizeConstants.LOCALE);
						pLang = Strings.escapeNULL(pLang, "zh_CN");
						Locale locale = LocaleContext.parseLocale(pLang);
						String content = ResourceUtil.getStringByParams(locale,"pc.login.remind");
						for (Map.Entry entity : loginInfoMapper.entrySet()) {
							Constants.login_sign key = (Constants.login_sign) entity.getKey();
							OnlineUser.LoginInfo value = (OnlineUser.LoginInfo) entity.getValue();
							if (key != null && login_sign.phone.name().equals(key.name())) { // 若移动端已在线，发送系统消息到移动端
								Ent_UserMessage message = new Ent_UserMessage();
								message.setIdIfNew();
								message.setUserId(user.getId());
								message.setCreationDate(new Date());
								message.setMessageCategory(ApplicationCategoryEnum.statusRemind.getKey());
								message.setMessageContent(content);
								message.setSenderId(user.getId());
								message.setOpenType(com.seeyon.ctp.common.usermessage.Constants.PC_LOGIN_REMIND_TYPE);
								String loginType=getMobileLoginType();
								// 取移动端类型
								if ("M1".equals(loginType)) {// 类型为M1
									userMessageManager.saveMessage(message);
								} else {// 移动端类型不是M1,只保存历史消息(m3使用时直接调历史消息)
									UserHistoryMessage historyMessage = message.toUserHistoryMessage();
									List<UserHistoryMessage> ms = new ArrayList<UserHistoryMessage>(1);
									ms.add(historyMessage);
									userMessageManager.savePatchHistory(ms);
								}
							}
						}
					}
				}
			}
            
            //增加外部模块需要在首页增加参数控制的接口
			if(!HomePageParamsInterfaces.isEmpty()){
				for (HomePageParamsInterface paramsCreater : HomePageParamsInterfaces) {
					Map<String,Object> params = paramsCreater.getParamsForHomePage();
					if(params!=null && params.size() > 0){
						modelAndView.addAllObjects(params);
					}
				}
			}
			
            //增加外部模块需要在首页增加jsp页面引用的接口            
			List<String> ExpansionJsps = new ArrayList<String>();
			if(CollectionUtils.isNotEmpty(expansionJspForHomepage)){
				for (ExpandJspForHomePage expansionJspCreater : expansionJspForHomepage) {
					List<String> expansionJsp = expansionJspCreater.expandJspForHomePage(null);
					if(expansionJsp!=null && expansionJsp.size() > 0){
						ExpansionJsps.addAll(expansionJsp);
					}
					
				}
				if(CollectionUtils.isNotEmpty(expansionJspForHomepage)){
					modelAndView.addObject("ExpansionJsp", ExpansionJsps);
				}
	        }
			
			
			//普通用户取个人设置的时区
			//user 里始终存放的是登录者操作系统的时区设置
/*			CustomizeManager customizeManager =(CustomizeManager) AppContext.getBean("customizeManager");
			CtpCustomize timeZone = customizeManager.getCustomizeInfo(AppContext.getCurrentUser().getId(), CustomizeConstants.TIMEZONE);
			if(null!=timeZone){
				try {
						Long setTimeZone = Long.valueOf(timeZone.getCvalue());
						EnumManager enumManagerNew =(EnumManager) AppContext.getBean("enumManagerNew");
						CtpEnumItem enumItem = enumManagerNew.getCtpEnumItem(setTimeZone);
						String timezoneOffset = enumItem.getEnumvalue();
						user.setTimeZone(TimeZone.getTimeZone(TimeZoneUtil.getTimeZoneId(timezoneOffset)));
					} catch (BusinessException e) {
				}
			}*/

            Cookie cookie = new Cookie("avatarImageUrl", String.valueOf(AppContext.currentUserId()));
            cookie.setMaxAge(expiry10year);
            cookie.setPath("/");
            response.addCookie(cookie);
            return modelAndView;
        } else {
            //用户登录信息失效
            BusinessException e = new BusinessException("loginUserState.unknown");
            e.setCode("-1");
            goout(request, session, response, e, true);
            return null;
        }
    }


    private String getErrorDestination(HttpServletRequest request, HttpSession session) {
        String error_destination = request.getParameter(Constants.LOGIN_ERROR_DESTINATION);
        if (session != null) {
            if (error_destination != null)
                AppContext.putSessionContext(Constants.LOGIN_ERROR_DESTINATION, error_destination);
            else
                session.removeAttribute(Constants.LOGIN_ERROR_DESTINATION);
        }

        if (error_destination == null) {
            error_destination = request.getContextPath();
            if (error_destination == null || "".equals(error_destination)) {
                error_destination = "/main.do";
            } else {
                error_destination += "/main.do";
            }
        }

        return error_destination;
    }

    private void redirectToIndex(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(response.encodeURL(getErrorDestination(request, request.getSession(false))));
    }

    private void goout(HttpServletRequest request, HttpSession session, HttpServletResponse response,
            BusinessException be, boolean jumpDestination) {
        //登录失败目标页面
        String error_destination = getErrorDestination(request, session);
        Cookie[] cookies = request.getCookies();
        if(cookies != null){
            for(Cookie cookie : cookies){
                if("loginPageURL".equals(cookie.getName()) && cookie.getValue().length() > 0){
                    error_destination = request.getContextPath() + cookie.getValue();
                    cookie.setMaxAge(0);
                    cookie.setValue(null);
                    response.addCookie(cookie);
                }
            }
        }
        if (be != null) {
            //清除已有session信息
            Enumeration<String> attsEnu = session.getAttributeNames();
            List<String> attrs = new ArrayList<String>();
            while (attsEnu.hasMoreElements()) {
            	attrs.add(attsEnu.nextElement());
            }
            for (String name : attrs) {
				
            	session.removeAttribute(name);
			}
            AppContext.putSessionContext(LoginConstants.Result, be.getMessage());
            response.addHeader("LoginError", be.getCode());
        }
        try {
            if (jumpDestination) {
                response.sendRedirect(response.encodeURL(error_destination));
            }
        } catch (Exception e) {
        }
    }

	private void goout4Ucpc(HttpServletRequest request, HttpSession session, HttpServletResponse response,
			BusinessException be) {
		// 登录失败目标页面
		String error_destination = getErrorDestination(request, session);
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if ("loginPageURL".equals(cookie.getName()) && cookie.getValue().length() > 0) {
					error_destination = request.getContextPath() + cookie.getValue();
					cookie.setMaxAge(0);
					cookie.setValue(null);
					response.addCookie(cookie);
				}
			}
		}
		if (be != null) {
			// 清除已有session信息
			Enumeration<String> attsEnu = session.getAttributeNames();
			List<String> attrs = new ArrayList<String>();
			while (attsEnu.hasMoreElements()) {
				attrs.add(attsEnu.nextElement());
			}
			for (String name : attrs) {

				session.removeAttribute(name);
			}
			AppContext.putSessionContext(LoginConstants.Result, be.getMessage());
			response.addHeader("LoginError", be.getCode());
		}
		try {
			if (request.getParameter("UserAgentFrom").equals(Constants.login_useragent_from.ucpc.name())) {
				response.getWriter().write("LoginError:" + be.getCode());
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
	}
    private static void writeCookie(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            String username, String password, String userAgentFrom, Locale locale) {
        if (Constants.login_useragent_from.mobile.name().equals(userAgentFrom)) {
            boolean rememberName = request.getParameterValues(LoginConstants.rememberName) != null;
            //boolean rememberPassword = request.getParameterValues(LoginConstants.rememberPassword) != null;
            boolean rememberPassword = false;
            if (rememberName) {
                rememberPassword = true;
            }

            if (Boolean.TRUE.equals(rememberName)) {
                Cookies.add(response, LoginConstants.USERNAME, username, Cookies.COOKIE_EXPIRES_FOREVER, true);
                Cookies.add(response, LoginConstants.rememberName, "true", Cookies.COOKIE_EXPIRES_FOREVER);
                session.removeAttribute(LoginConstants.rememberName);
            } else {
                Cookies.remove(response, LoginConstants.USERNAME);
                Cookies.remove(response, LoginConstants.rememberName);
            }

            if (Boolean.TRUE.equals(rememberPassword)) {
                Cookies.add(response, LoginConstants.PASSWORD, password, Cookies.COOKIE_EXPIRES_FOREVER, true);
                Cookies.add(response, LoginConstants.rememberPassword, "true", Cookies.COOKIE_EXPIRES_FOREVER);
                session.removeAttribute(LoginConstants.rememberPassword);
            } else {
                Cookies.remove(response, LoginConstants.PASSWORD);
                Cookies.remove(response, LoginConstants.rememberPassword);
            }

            Cookies.add(response, "u_login_from", userAgentFrom, Cookies.COOKIE_EXPIRES_FOREVER, false);
            Cookies.add(response, "u_login_name", username, Cookies.COOKIE_EXPIRES_One_day, true);
            Cookies.add(response, "u_login_password", password, Cookies.COOKIE_EXPIRES_One_day, true);
        }

        if (locale != null) {
            if (locale.equals(LocaleContext.getAllLocales().get(0))) {
                //OA-24343 减少不必要的Cookie存储
                Cookies.remove(response, LoginConstants.LOCALE);
            } else {
                Cookies.add(response, LoginConstants.LOCALE, locale.toString(), Cookies.COOKIE_EXPIRES_FOREVER);
            }
        }
    }

    /**
     * 系统退出
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	response.setDateHeader("Expires", -1);
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragrma", "no-cache");

        HttpSession session = request.getSession(false);

        //OA-43979 退出时进行登陆相关的session信息复制，避免退出和消息遍历可能的同时退出动作导致登陆相关验证数据错误
        //校验码转移
        String verifyCode = null;
        //iTrusCA校验码转移
        String oriToSign = null;
        //登陆口令加密种子
        String seed = null;
        if (session != null) {
            verifyCode = (String) session.getAttribute(LoginConstants.VerifyCode);
            oriToSign = (String) session.getAttribute("ToSign");
            seed = (String)session.getAttribute(GlobalNames.SESSION_CONTEXT_SECURITY_SEED_KEY);
        }
        String destination = loginControl.transDoLogout(request, session, response);
        session = request.getSession(true);

        //Session线程变量更新
        AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_SESSION_KEY, session);
        if (Strings.isNotBlank(verifyCode)) {
            AppContext.putSessionContext(LoginConstants.VerifyCode, verifyCode);
        }
        if (Strings.isNotBlank(oriToSign)) {
            AppContext.putSessionContext("ToSign", oriToSign);
        }
        if (Strings.isNotBlank(seed)) {
            AppContext.putSessionContext(GlobalNames.SESSION_CONTEXT_SECURITY_SEED_KEY, seed);
        }

        if ("close".equals(destination)) {
            response.setContentType("text/html; charset=UTF-8");

            PrintWriter out = response.getWriter();
            out.println("<script>top.window.close();</script>");
            out.close();
        } else {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (("loginPageURL".equals(cookie.getName())) && cookie.getValue().length() > 0) {
                        destination = cookie.getValue();
                        cookie.setMaxAge(0);
                        cookie.setValue(null);
                        response.addCookie(cookie);
                    }
                }
            }
            //response.sendRedirect(SystemEnvironment.getContextPath() + destination);
			response.sendRedirect("/");
        }

        return null;
    }

    /**
     * Vjoin系统退出
     */
    public ModelAndView logout4Vjoin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setDateHeader("Expires", -1);
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragrma", "no-cache");

        HttpSession session = request.getSession(false);
        loginControl.transDoLogout(request, session, response);

        return null;
    }

    /**
     * Vjoin清除会话
     */
    public ModelAndView logout4Session(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setDateHeader("Expires", -1);
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragrma", "no-cache");
        HttpSession session = request.getSession(false);
        try {
            if (session != null) {
                try {
                    session.invalidate();
                } catch (Throwable t) {
                    //ignore it
                }
            }

            javax.servlet.http.Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (javax.servlet.http.Cookie cookie : cookies) {
                    if (cookie.getValue().length() > 0) {
                        cookie.setMaxAge(0);
                        cookie.setValue(null);
                        response.addCookie(cookie);
                    }
                }
            }
        } catch (Throwable e) {
            //ignore it
        }
        return null;
    }

    /**
     * 切换登陆单位
     *
     * @param requestServlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView changeLoginAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String loginAccount = request.getParameter(LoginConstants.LOGIN_ACCOUNT_ID);
        if (Strings.isNotBlank(loginAccount)) {
            loginControl.transChangeLoginAccount(Long.parseLong(loginAccount));
        }
        String isRefresh = request.getParameter("isRefresh");
        String shortCutId = request.getParameter("shortCutId");
        String showSkinchoose = request.getParameter("showSkinchoose");
        String isPortalTemplateSwitching = request.getParameter("isPortalTemplateSwitching");
        String portal_default_page = request.getParameter("portal_default_page");
        String param = "";

        if(Strings.isNotBlank(isRefresh)){
        	param += "&isRefresh="+isRefresh;
        }
        if(Strings.isNotBlank(showSkinchoose)){
        	param += "&showSkinchoose=true";
        }
        if(Strings.isNotBlank(isPortalTemplateSwitching)){
        	param += "&isPortalTemplateSwitching=true";
        }
        if(Strings.isNotBlank(portal_default_page)){
        	param += "&portal_default_page=default";
        }
        if(Strings.isNotBlank(shortCutId)){
        	param += "&shortCutId="+shortCutId;
        }
        response.sendRedirect("main.do?method=main"+param);

        return null;
    }

    /**
     * 系统关于对话框
     *
     * @param request Servlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView showAbout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("common/about");

        modelAndView.addObject("productVersion", Functions.getVersion());
        modelAndView.addObject(
                "buildId",
                "B" + Datetimes.format(SystemEnvironment.getProductBuildDate(), "yyMMdd") + "."
                        + SystemEnvironment.getProductBuildVersion() + ".CTP"
                        + SystemEnvironment.getCtpProductBuildVersion());
        String edition =  ProductEditionEnum.getCurrentProductEditionEnum().getName();
        int releaseYear = ProductVersionEnum.getCurrentVersion().getReleaseDate().getYear() + 1900;
        
        modelAndView.addObject("releaseYear", String.valueOf(releaseYear));
        modelAndView.addObject("productCategory", edition);
        
        String docNo = (String)MclclzUtil.invoke(c2, "getDogNo", null, null, null);
        modelAndView.addObject("docNo", docNo);
        
        this.setProductInfo(modelAndView);

        return modelAndView;
    }

    /**
     * 头公共JS生成
     *
     * @param requestServlet请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView headerjs(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	User user = AppContext.getCurrentUser();
    	long time = user!=null ? user.getLoginTimestamp().getTime() : 0;
    	String etag = "e"+SystemEnvironment.getProductBuildVersion() + "" + time+"";

    	if(WebUtil.checkEtag(request, response, etag)){ //匹配，没有修改，浏览器已经做了缓存
    		return null;
    	}
    	response.setStatus(200);
        ModelAndView modelAndView = new ModelAndView("common/header_js");

        WebUtil.writeETag(request, response, etag, 1000L * 60 * 5);
        return modelAndView;
    }

    /**
     * 用户状态刷新/挂起
     *
     * @param request请求对象
     * @param response Servlet应答对象
     * @return Spring MVC对象
     * @throws Exception
     */
    public ModelAndView hangup(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User currentUser = AppContext.getCurrentUser();
        if (currentUser != null)
            this.onlineManager.updateOnlineState(currentUser);
        return null;
    }

    private void setProductInfo(ModelAndView modelAndView) {
        Object o = MclclzUtil.invoke(c1, "getInstance", new Class[] { String.class }, null, new Object[] { "" });
        //1是注册数.2是并发数
        Integer serverType = (Integer) MclclzUtil.invoke(c1, "getserverType", null, o, null);
        //1是注册数.2是并发数
        Integer m1ServerType = (Integer) MclclzUtil.invoke(c1, "getm1Type", null, o, null);

        modelAndView.addObject("serverType", serverType);
        modelAndView.addObject("m1ServerType", m1ServerType);
        modelAndView.addObject("maxOnline", MclclzUtil.invoke(c1, "getTotalservernum", null, o, null));
        modelAndView.addObject("maxOnline", MclclzUtil.invoke(c1, "getTotalservernum", null, o, null));
        modelAndView.addObject("m1MaxOnline", MclclzUtil.invoke(c1, "getTotalm1num", null, o, null));
        String MxVersion = SystemEnvironment.getMxVersion();
        modelAndView.addObject("MxVersion", MxVersion);
    }
    
    private Integer expireDayNum = null;    
    /**
     * 获取剩余使用天数，正数表示还有多少天到期，负数表示超期多少天
     * */
    private Integer getExpireDayNum() {
    	if(expireDayNum == null){
	        Date executeDate = null;
	    	try {
	    		//取授权到期日期
	            Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
	            String endDateStr = (String) MclclzUtil.invoke(c1, "getUseEndDate");
	            if(StringUtils.isNotBlank(endDateStr) && endDateStr.length() >= 8) {
	                executeDate = DateUtil.parse(endDateStr);
	                Date currentDate = DateUtil.currentDate();
	                //取授权剩余多少天
	                expireDayNum = DateUtil.beforeDays(currentDate,executeDate);
	            }else{
	            	//如果无授权到期日期则认为是无限制狗，随后就不再做检查了
	            	expireDayNum = null;
	            }
	        } catch (Exception e) {
	        	log.error(e.getLocalizedMessage(), e);
	        }
    	}
		return expireDayNum;
	}
    private static final Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
    private static final Class<?> c2 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
}