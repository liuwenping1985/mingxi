/**
 * $Author: wangwy $
 * $Rev: 17435 $
 * $Date:: 2015-06-10 13:30:31#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.common.spring;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.ServerState;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.aspect.AspectAnnotationAware;
import com.seeyon.ctp.common.authenticate.CTPSecurityManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.code.EnumsConfigLoader;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.exceptions.InfrastructureException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.service.NeedlessCheckLoginAnnotationAware;
import com.seeyon.ctp.common.web.util.WebUtil;
import com.seeyon.ctp.login.CurrentUserToSeeyonApp;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.monitor.perfmon.PerfLogConfig;
import com.seeyon.ctp.monitor.perfmon.PerfmonMisc;
import com.seeyon.ctp.privilege.manager.PrivlegeSecurityManager;
import com.seeyon.ctp.thread.ThreadInfoHolder;
import com.seeyon.ctp.thread.monitor.ThreadMonitor;
import com.seeyon.ctp.util.Cookies;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.ZipUtil;
import com.seeyon.ctp.util.cache.CachePojoManager;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.util.json.JsonErrorObject;
import com.seeyon.ctp.util.json.mapper.JSONMapper;
import com.seeyon.ctp.util.json.model.JSONValue;

/**
 * <p>Title: T1开发框架</p>
 * <p>Description: Controller处理拦截器，实现preHandle、postHandle和afterCompletion框架处理机制</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class CTPHandlerInterceptor extends HandlerInterceptorAdapter {

    public static final String      responseEncoding            = "UTF-8";
    private static final Log        LOGGER                      = CtpLogFactory.getLog(CTPHandlerInterceptor.class);
    private static final Log        logCapability               = CtpLogFactory.getLog("capability");
    private final static String     THREADLOCAL_KEY_START_TIME  = "CTPHandlerInterceptor.startTime";
    private final static String     THREADLOCAL_KEY_METHOD_NAME = "CTPHandlerInterceptor.methodName";

    private static final String     JSON_PARAMS_KEY             = "_json_params";
    //url digest请求摘要参数名
    private static final String     DIGEST_PARAMS_KEY           = "v";

    private OnlineManager           onlineManager;
    private PrivlegeSecurityManager privlegeSecurityManager;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    	AppContext.initSystemEnvironmentContext(request, response, false);
    	AppContext.putThreadContext(THREADLOCAL_KEY_START_TIME, System.currentTimeMillis());
    	PerfmonMisc.setUuid(String.valueOf(UUIDLong.longUUID()));
    	String method = getMethodName(request, handler);
    	String clazzName = PerfmonMisc.getAopProxySaneName(handler);
		AppContext.putThreadContext(THREADLOCAL_KEY_METHOD_NAME, method);

        WebUtil.setRequest(request);
        WebUtil.setResponse(response);

        ThreadInfoHolder.getInstance().initThread(Thread.currentThread());

        if (SystemEnvironment.getContextPath() == null)
            SystemProperties.getInstance().put(SystemEnvironment.ENV_APPLICATION_CONTEXT_PATH_KEY,
                    request.getContextPath());

        //资源权限判定
        String uri = getUri(request);

        boolean isAjax = "/ajax.do".equals(uri);
        StringBuilder sb = new StringBuilder(uri);
        String queryStr = request.getQueryString();      
        if (queryStr != null){
            sb.append("?").append(queryStr);
        }else{
        	queryStr = "";
        }
        String url = sb.toString();
        String ignoreUrl = url;
        
        User user = null;
        try {
            user = (User) AppContext.getSessionContext(Constants.SESSION_CURRENT_USER);
        } catch (InfrastructureException e) {
            // 保证用户不登录也能不抛异常，返回null。4定时任务。
        }
        if (isAjax) {
            String serviceName = request.getParameter("managerName");
            String methodName = request.getParameter("managerMethod");
            if(methodName!=null)
            	LOGGER.info(String.format("CTPHandlerInterceptor preHandle 126: serviceName:[%s] methodName:[%s]", serviceName,methodName));
                validateUserRole(PerfmonMisc.getAopProxySaneName(AppContext.getBean(serviceName)), methodName, user);
            ignoreUrl = serviceName + "." + methodName;
        }

        //开始监控请求
//        ThreadMonitor.startMonitor(uri);
        ThreadMonitor.startMonitor(url+" "+queryStr);
        boolean needlessUrl = false;
        //用户未登录
        if (user == null) {
        	AppContext.removeThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY);
        	String methodName = method;
            if (isAjax) {
                methodName = request.getParameter("managerMethod");
                if(methodName==null){
                	methodName = method;
                }
            }
            needlessUrl = isNeedlessLoginUrl(request, methodName, needlessUrl);
        }else{
        	// 防止ThreadLocal清除不干净引起的串session
        	AppContext.putThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY, user);
        }

        if (!needlessUrl) {
            //Session有效性检测
            if (!CTPSecurityManager.isIgnoreUrl(ignoreUrl, request, response)) {
                //非忽略是否登录的url请求，正常业务访问，则进行session合法性校验和资源访问权限判断
                boolean state = checkSessionPre(request, response, handler.getClass().getCanonicalName(), isAjax);
                if (!state)
                    return state;

                validateUserRole(clazzName, method, user);
                //资源访问权限判断
//                CTPSecurityManager.validateResource(url, true);
            }
        }

        initJsonParams(request);


        //url digest安全验证
        String digestUri = uri + (method == null ? "" : " " + method);
        String digestParam = SecurityHelper.getDigestUrlParam(digestUri);
        if (digestParam != null) {
            //配置了url digest安全校验，则执行校验过程
            String digest = request.getParameter(DIGEST_PARAMS_KEY);
            //摘要不能为空
            if (Strings.isBlank(digest))
                illegalAccess(url,response);
            String[] params = digestParam.split("\\,");
            StringBuilder param = new StringBuilder();
            for (String para : params) {
                String paraVal = request.getParameter(para);
                //改造为支持参数个数重载机制
                if (paraVal != null)
                    param.append(paraVal);
            }

            //摘要验证
            if (!SecurityHelper.verify(param.toString(), digest)){
                illegalAccess(url,response);
            }

        }

        //生成当前请求路径ID，用于表格组件个性化设置存储
        String pathId = uri.substring(1).replace(".do", "").replace('/', '_');
        if (method != null)
            pathId = pathId.concat("_").concat(method);
        request.setAttribute("_currentPathId", pathId);

        return super.preHandle(request, response, handler);
    }

    /**
     * 
     * @方法名称: validateUserRole
     * @功能描述: 内部调用，调用功能对用户自由角色验证
     * @参数 ：@param clazzName 类名称
     * @参数 ：@param method 方法名称
     * @参数 ：@param user 登录用户信息
     * @参数 ：@throws BusinessException
     * @返回类型：void
     * @创建时间 ：2015年11月19日 下午1:38:27
     * @创建人 ： FuTao
     * @修改人 ： 
     * @修改时间 ：
     */
    private void validateUserRole(String clazzName, String method, User user) throws BusinessException {
        if (user == null) {
            return;
        }

        //方法优先，然后是类
        Set<String> roleSet = CachePojoManager.getmethodNeedRole(clazzName + "." + method);
        if (roleSet == null) {
            roleSet = CachePojoManager.getclazzNeedRole(clazzName);
        }

        //方法优先，然后是类
        Set<String> extendSet = CachePojoManager.getmethodNeedExtendRole(clazzName + "." + method);
        if (extendSet == null) {
            extendSet = CachePojoManager.getclazzNeedExtendRole(clazzName);
        }

        if (Strings.isEmpty(roleSet) && Strings.isEmpty(extendSet)) {
            return;
        }

        if (privlegeSecurityManager == null) {
            privlegeSecurityManager = (PrivlegeSecurityManager) AppContext.getBean("privlegeSecurityManager");
        }
        privlegeSecurityManager.validateRole(user, method, roleSet, extendSet);
    }

	private boolean isNeedlessLoginUrl(HttpServletRequest request, String method, boolean needlessUrl) {
		Map<String, Set<String>> needlessUrlMap = new NeedlessCheckLoginAnnotationAware().getNeedlessUrlMap();
		Set<String> keys = needlessUrlMap.keySet();
		String accessUrl = request.getRequestURI();
		//由于配置文件中controller的name属性值的层级可能不同（比如：/addressbook.do与/doc/doc.do）并且不需登录
		//可以访问的URL是少数，故这里使用循环得到的name值集合来判断
		for (String key : keys) {
		    if (accessUrl.indexOf(key) != -1) {
		        Set<String> methods = needlessUrlMap.get(key);
		        needlessUrl = methods.contains("*") || methods.contains(method);
		    }
		}
		return needlessUrl;
	}

	private void initJsonParams(HttpServletRequest request) {
		String jsonStr = (String) request.getAttribute(JSON_PARAMS_KEY);
        if (jsonStr == null)
            jsonStr = request.getParameter(JSON_PARAMS_KEY);
        if (jsonStr != null) {
            AppContext.putThreadContext(GlobalNames.THREAD_CONTEXT_JSONSTR_KEY, jsonStr);
        }
	}

	private String getUri(HttpServletRequest request) throws BusinessException {
		String uri = request.getRequestURI();
        if(uri.matches(".*?/{2,}.*?")){
        	throw new BusinessException("url格式错误有超过2个以上的'/'"+uri);
        	//uri = uri.replaceAll("/{2,}", "/");
        }
        //排除jsessionid参数
        int idx = uri.indexOf(';');
        uri = uri.substring(request.getContextPath().length(), idx == -1 ? uri.length() : idx);
		return uri;
	}

	private String getMethodName(HttpServletRequest request, Object handler) {
		String method = request.getParameter("method");
		if("com.seeyon.v3x.common.controller.GenericController".equals(handler.getClass().getCanonicalName())){
			method = request.getParameter("ViewPage");
		}
		else if(method == null){
			method = "index";
		}
		return method;
	}

    private boolean checkSessionPre(HttpServletRequest request, HttpServletResponse response, String clazz,
            boolean isAjax) throws Exception {

        User currentUser = AppContext.getCurrentUser();
        String message1 = CurrentUserToSeeyonApp.getUserOnlineMessage();

        String ctxPath = request.getContextPath();
        if (message1 != null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            //手机登录
            if (isFromMobile(request, currentUser)) {
                out.println("<meta http-equiv='Refresh' content='0;url=" + ctxPath
                        + "/common/mobileprompt.jsp?message=" + java.net.URLEncoder.encode(message1, responseEncoding) + "' />");
            } else if ((currentUser != null && currentUser.isFromM1())
                    || Strings.isNotBlank(request.getParameter("ClientRequestPath"))) {
                //M1端在线状态异常处理
                out.print(m1ErrorResponse(request, message1));

                response.setStatus(500);
            } else {
                if (isAjax) {
                    //OA-33212 ajax请求如果session失效则返回空串，避免不必要的js错误
                    out.print("\"__LOGOUT\"");
                    response.addHeader("__LOGOUT", "o");
                } else {
                	// jsonsubmit
                	String msg = Strings.escapeJavascript(message1);
                	if(request.getMethod().equals("POST") && (request.getParameter("_json_params")!=null)){
                		out.println("{\"errorMsg\":\""+  msg + "\"}");
                	}else{
	                	out.println("<section data-role=\"page\">");//为移动端，JQUERY MOBILE UI特有
	                    out.println("<script type=\"text/javascript\">var _ctxPath='" + SystemEnvironment.getContextPath() + "';</script>");
	                    out.println("<script type=\"text/javascript\" src=\"" + SystemEnvironment.getContextPath() + "/common/all-min.js\"></script>");
	                    out.println("<script>");
	                    out.println("try{getCtpTop().messageTask.clear();}catch(e){}");
						out.println("alert(\"" + msg + "\");");
	                    out.println("self.close();");
	                    out.println("try{");
	                    if (currentUser != null && currentUser.getUserSSOFrom() != null
	                            && currentUser.getUserSSOFrom().equals(Constants.user_sso_from.nc_portal.name())) {
	                        out.println("getCtpTop().location.href = '" + ctxPath + "/main.do?method=logout?toPortal=toPortal';");
	                    } else {
	                        out.println("getCtpTop().location.href = '" + ctxPath + "/main.do?method=logout';");
	                    }
	                    out.println("}catch(e){}");
	                    out.println("</script>");
	                    out.println("</section>");
                	}
                }
            }

            out.close();
            return false;
        }

        //系统管理员不检测
        ServerState serverState = ServerState.getInstance();
        if (serverState.isShutdown()) {

            //强制下线
            if (serverState.isForceLogout()) {
                String message = ResourceUtil.getString("ServerState.shutdown", serverState.getComment());
                PrintWriter out = response.getWriter();
                if (isFromMobile(request, currentUser)) {
                    out.println("<meta http-equiv='Refresh' content='0;url=" + request.getContextPath()
                            + "/common/mobileprompt.jsp?message=" + java.net.URLEncoder.encode(message, responseEncoding)
                            + "' />");
                    out.close();
                    return false;
                } else if (currentUser != null && currentUser.isFromM1()) {
                    //M1端在线状态异常处理
                    out.print(m1ErrorResponse(request, message));

                    response.setStatus(500);
                    return false;
                }
            }
        }

        if (isFromMobile(request, currentUser) || (currentUser != null && currentUser.isFromM1())) {
            if (onlineManager == null)
                onlineManager = (OnlineManager) AppContext.getBean("onlineManager");
            this.onlineManager.updateOnlineState(currentUser);
        }

        return true;
    }

    private String m1ErrorResponse(HttpServletRequest request, String message) throws Exception {
        String responseCompress = request.getParameter("responseCompress");
        JsonErrorObject jsonErrorObject = new JsonErrorObject();
        jsonErrorObject.setMessage(message);
        jsonErrorObject.setDetails("");
        jsonErrorObject.setCode("10000");
        JSONValue jsonValue = JSONMapper.toJSON(jsonErrorObject);
        return ZipUtil.compressResponse(jsonValue.render(false), responseCompress, responseEncoding,
                LOGGER);
    }

    private boolean isFromMobile(HttpServletRequest request, User currentUser) {
        String fromCookies = Cookies.get(request, "u_login_from");
        String agentFrom = currentUser == null ? null : currentUser.getUserAgentFrom();
        return Constants.login_useragent_from.mobile.name().equals(fromCookies)
                || Constants.login_useragent_from.mobile.name().equals(agentFrom);
    }

    private void illegalAccess(String url,HttpServletResponse response) throws IOException {
        LOGGER.error("User:" + AppContext.currentUserName() + ";URL:" + url);
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        response.sendError(404);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,ModelAndView modelAndView) throws Exception {
        Map fillMap = new HashMap();
        Enumeration attEnu = request.getAttributeNames();
        while (attEnu.hasMoreElements()) {
            String attName = (String) attEnu.nextElement();
            Object fillForm = request.getAttribute(attName);
            if (attName.startsWith("ff")) { //表单自动回填
                attName = attName.substring(2);
                fillMap.put(attName, fillForm);
            }
        }
        if (fillMap.size() > 0) {
        	String fillMapStr =  JSONUtil.toJSONString4Ajax(fillMap);
        	request.setAttribute("_FILL_MAP", StringUtil.replace(fillMapStr, "</script>", "</scr\"+\"ipt>"));
//            request.setAttribute("_FILL_MAP", StringUtil.replace(fillMapStr, "</script>", "<//script>"));
        }
        request.setAttribute("_JSON_PLUGIN", SystemEnvironment.getPluginIdsJsonStr());
        if (request.getSession(false) != null) //Session是否被invalidate判断，避免退出异常
            request.setAttribute("CurrentUser", AppContext.getCurrentUser());
        request.setAttribute("enu", EnumsConfigLoader.getEnumCachMap());
        setRequestAttr(request,modelAndView);
        AspectAnnotationAware.execute(handler,request.getParameter("method"));
        super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        try {
            if (logCapability.isDebugEnabled()) {
//                long elapsedTime = System.currentTimeMillis() - startTime.get();
                long elapsedTime = System.currentTimeMillis() - (Long)AppContext.getThreadContext(THREADLOCAL_KEY_START_TIME);
                String loginName="";
                try{
                loginName=AppContext.currentUserLoginName();
                }catch(Exception e){
                }
                if (elapsedTime >= PerfLogConfig.getSlowlaunchControllerTime()) {
//                    String  action=PerfmonMisc.getAopProxy(handler) + "."+ methodTL.get();
                	String  action=PerfmonMisc.getAopProxy(handler) + "."+ AppContext.getThreadContext(THREADLOCAL_KEY_METHOD_NAME);
                    if(action.startsWith("AjaxController")){
                        String name = request.getParameter("managerName");
                        if(name!=null){
                            name = name.replaceAll(",", " ");
                            if("sectionManager".equalsIgnoreCase(name)){
                                String arguments=request.getParameter("arguments");
                                if(arguments!=null) {
                                	arguments = arguments.substring(19, arguments.indexOf("\"", 20));
                                }
                                action=name+"."+arguments;
                            }else{
                                action=name+"."+request.getParameter("managerMethod");
                            }
                        }
                    }
                    // 节约日志文件空间， 本次先取消CSD根据uuid对应，在下期配套工具出来后再追加 + "," +PerfmonMisc.getUuid()，
                    logCapability.debug(Strings.getRemoteAddr(request) +","+loginName +","+action+ "," + elapsedTime
                            + (PerfLogConfig.isRecordControllerParam() ? ("," + request.getQueryString()) : "") );
                }
            }
        } catch (Throwable e) {
            LOGGER.warn("输出操作日志错误",e);
        } finally {
            //	        ThreadLocalUtil.removeThreadLocal();
//            startTime.remove();
//            methodTL.remove();
        }
        //线程变量清除
        AppContext.clearThreadContext();
        
        ThreadInfoHolder.getInstance().remove(Thread.currentThread());

        ThreadMonitor.stopMonitor();
        super.afterCompletion(request, response, handler, ex);
    }


    private void setRequestAttr(HttpServletRequest request,ModelAndView modelAndView){
		String uri = request.getRequestURI();// /projectName/login.do
		String url = uri.toString();// http://localhost:8080/projectName/login.do

		String schema = request.getScheme();// http
		String serverName = request.getServerName();// localhost
		int port = request.getServerPort();// 8080
		String contextPath = request.getContextPath();

//		String url7 = request.getLocalAddr();
//		String url8 = request.getLocalName();
//		int url9 = request.getLocalPort();
//
//		String url10 = request.getPathInfo();
//		String url11 = request.getPathTranslated();
//
//		String url12 = request.getRemoteAddr();
//		String url13 = request.getRemoteHost();
//		String url14 = request.getRemoteUser();
//		int url15 = request.getRemotePort();
		if(modelAndView != null){
			//modelAndView.addObject("ctp_startTime",startTime);//方便页面计算性能时间
	    	modelAndView.addObject("ctp_htmlAtt"," xmlns=\"http://www.w3.org/1999/xhtml\" ");
	    	modelAndView.addObject("ctp_DTD"," <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \""+contextPath+"seeyonoa/ui/DTD/xhtml1-transitional.dtd\">");
	    	modelAndView.addObject("ctp_uri",uri);//uri
	    	modelAndView.addObject("ctp_url",url);//url
	    	modelAndView.addObject("ctp_scheme",schema);//协议名
	    	modelAndView.addObject("ctp_server",serverName);//服务器IP
	    	modelAndView.addObject("ctp_port",port);//端口号
	    	modelAndView.addObject("ctp_contextPath",contextPath);//WEB工程名,server.XML里配置的
		}
    }
}
