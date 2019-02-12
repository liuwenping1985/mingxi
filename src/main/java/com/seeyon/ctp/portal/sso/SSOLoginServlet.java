/**
 * $Author: tanmf $
 * $Rev: 51890 $
 * $Date:: 2016-02-27 13:49:26 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.sso;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;

import com.seeyon.apps.ldap.config.LDAPConfig;
import com.seeyon.apps.ldap.util.LDAPTool;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager;
import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager.TicketInfo;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.LoginConstants;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.usermapper.CtpOrgUserMapper;
import com.seeyon.ctp.common.usermapper.dao.UserMapperDao;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.signin.manager.SignInManager;
import com.seeyon.ctp.signin.po.SignIn;
import com.seeyon.ctp.util.Strings;
/**
 * <p>Title: 访问示例：http://a8:80/sso?from=dlyh&ticket=390923asdf4052j218jh12h3</p>
 * <p>Description:</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class SSOLoginServlet extends HttpServlet {

	private static final long serialVersionUID = 8250719400904761530L;
	
	private static final Log log = LogFactory.getLog(SSOLoginServlet.class);
	private transient Object object = new Object();
	private transient PrincipalManager principalManager = null;
	private UserMapperDao    userMapperDao = null;
	
    private SignInManager ssoManager=null;


    public void setSignInManager(SignInManager signInManager) {
        this.ssoManager = signInManager;
    }
    public SignInManager getSignInManager() {
        return ssoManager;
    }
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if(principalManager == null){
			principalManager = (PrincipalManager)AppContext.getBean("principalManager");
		}
		
        if (userMapperDao == null) {
            userMapperDao = (UserMapperDao) AppContext.getBean("userMapperDao");
        }	
		
		if(ssoManager == null){
			ssoManager = (SignInManager)AppContext.getBean("signInManager");
		}
		
		req.setCharacterEncoding("UTF-8");
		resp.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = resp.getWriter();
		SSOLoginContext ssoLoginContext=null;
		SignIn ssoSetInfo=null;
        
        String from = req.getParameter("from");//XML配置登录标记
        String signin=req.getParameter("signin");//可视化平台配置
        //进入平台配置模式
        if(!isBlank(signin)&&isBlank(from)){
        	ssoSetInfo=ssoManager.findSsoByName(signin);
        	if(ssoSetInfo!=null){
        	ssoLoginContext=signinTo(signin,ssoSetInfo);
        	}
        }else if(isBlank(signin)&&!isBlank(from)){
        	ssoLoginContext = SSOLoginContextManager.getInstance().getSSOLoginContext(from);
        }else if(isBlank(signin)&&isBlank(from)){
        	out.println("Parameter 'from' is not available.");
        	resp.addHeader("SSOError", "Parameter 'from' is not available.");
        	return;
        }
//        if(isBlank(from)){
//        	out.println("Parameter 'from' is not available.");
//        	resp.addHeader("SSOError", "Parameter 'from' is not available.");
//        	return;
//        }
        
         
        if(ssoLoginContext == null){
        	out.println(Strings.toHTML(from) + " is not available.");
        	resp.addHeader("SSOError", "from is not available.");
        	return;
        }
        if(ssoLoginContext.isEnableTrustAddress()){
        	if(!com.seeyon.ctp.common.authenticate.TrustAddressManager.getInstance().isTrustPass(req)){
        		out.println( Strings.toHTML(from) +" client ip is untrusted.");
            	resp.addHeader("SSOError", "from client ip is untrusted.");
            	return;
        	}
        }
        
        String ticketName = ssoLoginContext.getTicketName();
        
        String ticket = req.getParameter(ticketName);
        if(isBlank(ticket)){
    		out.println("Parameter '" + Strings.escapeJavascript(ticketName) + "' is not available.");
    		resp.addHeader("SSOError", "Parameter '" + Strings.escapeJavascript(ticketName) + "' is not available.");
    		return;
        }
        
        SSOLoginHandshakeInterface handshake = ssoLoginContext.getHandshake();
        if(handshake == null){
        	out.println("SSOLoginHandshakeInterface is not implements.");
        	resp.addHeader("SSOError", "Parameter 'SSOLoginHandshakeInterface is not implements.");
        	return;
        }
		
		String username = null;
		try{
			username = handshake.handshake(ticket);
			if(username!=null&&!"".equals(username)){
				if(username.equals(ticket)){
					out.println("[ticket] prohibit same user login name!");
					resp.addHeader("SSOError", "[ticket] prohibit same user login name!");
					return;
				}
			}
		}
		catch(Throwable e){
			log.error(ssoLoginContext, e);
			out.println("Login fail");
			resp.addHeader("SSOError", Strings.escapeJavascript(e.getMessage()));
			return;
		}

        if(!isBlank(username)){
        	if (!LDAPTool.canLocalAuth()) {
        		CtpOrgUserMapper ep = userMapperDao.getLoginName(username, LDAPTool.catchLDAPConfig().getType());
        		
                if (ep != null) {
                	username = ep.getLoginName();
                } else { 
                	//如果该账号已经绑定了，验证失败,不再往下走
                	boolean isBind = userMapperDao.isbind(username);
                	if(isBind){
                		log.error(username + " : ldap登录，绑定条目异常！");
        	        	out.println("Username is not available.");
        	        	resp.addHeader("SSOError", "Username is not available.");
        	        	return;
                	}else if(!LDAPConfig.getInstance().getLdapCanOauserLogon()){
                	//如果该账号没有绑定，并且默認沒有勾选可以进行a8验证，則验证失败,不再往下走
                		log.error(username + " : ldap登录，没有进行绑定！");
        	        	out.println("Username is not available.");
        	        	resp.addHeader("SSOError", "Username is not available.");
        	        	return;
                	}
                	//勾选可以进行a8验证，保留登录名作为a8的登录名
                }
        	}
        	username = java.net.URLDecoder.decode(username, "UTF-8");
        	boolean isforward=ssoLoginContext.isForward();
        	// 不弹出A8窗口
        	if(!ssoLoginContext.isForward()){
        	    V3xOrgMember member = null;
        	    TicketInfo ticketInfo1 =null;
        	    TicketInfo ticketInfo2 =null;
                try {
                    member = SSOTicketManager.getInstance().getOrgManager().getMemberByLoginName(username);
                } catch (BusinessException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }
        	    if(member!=null&&member.isValid()){
        	    ticketInfo1 = SSOTicketManager.getInstance().getTicketInfo(ticket);
        	    ticketInfo2 = SSOTicketManager.getInstance().getTicketInfoListByUsername(username,ticket);
        	    }
        		
        		if(ticketInfo1 != null && ticketInfo2 != null){
        			//相当于重复登录
        			if(ticketInfo1.equals(ticketInfo2)){
	        			out.println("TicketInfo '" + Strings.escapeJavascript(ticket) + ", " + Strings.escapeJavascript(username) + "' already SSO.");
	        			resp.addHeader("SSOOK", "TicketInfo '" + Strings.escapeJavascript(ticket) + ", " + Strings.escapeJavascript(username) + "' already SSO.");
        			}
        			else{
        				out.println("Ticket or Username already exists, but with the current information does not match.");
        				resp.addHeader("SSOError", "Ticket or Username already exists, but with the current information does not match.");
        			}
        			
        			return;
        		}
        		
        		try {
					if(member!=null&&member.isValid()){
						SSOTicketManager.getInstance().newTicketInfoList(ticket, username, from);
						out.println("SSOOK");
						resp.addHeader("SSOOK", "");
					}else{
						out.println("Username '" + Strings.escapeJavascript(username) + "' is not available.");
						resp.addHeader("SSOError", "Username '" + Strings.escapeJavascript(username) + "' is not available.");
					}
        		}
				catch (Exception e) {
				    log.error("", e);
					out.println(Strings.escapeJavascript(e.getMessage()));
					resp.addHeader("SSOError", "Username is not available." + Strings.escapeJavascript(e.getMessage()));
				}
        	}
        	else{
	        	try {
	        		String tourl="";
	                if(!isBlank(signin)&&isBlank(from)){
		        		tourl = ssoSetInfo.getTargetUrl();
	                }else if(isBlank(signin)&&!isBlank(from)){
		        		tourl = req.getParameter("tourl");
		        		
	                }
	                //SSOTicketManager.getInstance().newTicketInfo(ticket, username, from);
	                SSOTicketManager.getInstance().newTicketInfoList(ticket, username, from);
	        		StringBuilder sb=null;
	        		synchronized(object){
	        			sb = get2URL(req, ssoLoginContext, ticket, tourl,handshake);
	        		}
	        		resp.sendRedirect(sb.toString());
				}
				catch (Throwable e) {
					out.println(e.getMessage());
				}
        	}
        }
        else{
        	out.println("Username is not available.");
        	resp.addHeader("SSOError", "Username is not available.");
        }
	}
	
	private SSOLoginContext signinTo(String param,SignIn ssoInfo){
		//判断是后台配置单点登录模式
		//SignIn ssoInfo=ssoManager.findSsoByName(param);
		//设置SSOLoginContext参数
		SSOLoginHandshakeInterface handshake = null;
		try {
			handshake = (SSOLoginHandshakeInterface)Class.forName(ssoInfo.getCheckUrl()!=null?ssoInfo.getCheckUrl():null).newInstance();
		} catch (Exception e) {
			log.error("后台配置单点登录模式报错:"+e.getMessage(),e);
		} 
		SSOLoginContext signin=new SSOLoginContext();
		signin.setHandshake(handshake);
		signin.setForward(ssoInfo.getSort()==0?false:true);
		signin.setTicketName(ssoInfo.getLoginParam()!=null?ssoInfo.getLoginParam():"ticket");

		return signin;
	}

	private StringBuilder get2URL(HttpServletRequest req, SSOLoginContext ssoLoginContext, String ticket, String tourl, SSOLoginHandshakeInterface handshake) {
        StringBuilder sb = new StringBuilder();
        if (!this.isBlank(tourl)) {
            String formUrl = req.getParameter("formUrl");
            if(!isBlank(formUrl))
               {
            	   sb.append(tourl + "?ticket=" + java.net.URLEncoder.encode(ticket));
                    int end=formUrl.indexOf("login/sso");
                    if(end!=-1)
                    {
                        formUrl=formUrl.substring(0,end);
                    }
                    sb.append("&formUrl="+java.net.URLEncoder.encode(formUrl));
               }else{
//            	   sb.append("/seeyon/main.do?method=login&ticket=" + java.net.URLEncoder.encode(ticket));
//            	   sb.append("&ssoFrom=" + req.getParameter("from"));
            	   sb.append(tourl + "?ticket=" + java.net.URLEncoder.encode(ticket));
               }
            sb=urlMosaic(req, ssoLoginContext, tourl, sb);
            return sb;
        }
        sb.append("/seeyon/main.do?method=login&ticket=" + java.net.URLEncoder.encode(ticket) + "&ssoFrom=" + req.getParameter("from"));
        

        //取接口实现返回的参数
        String handShakToUrl = handshake.getToUrl(req,ssoLoginContext,ticket);
        if(Strings.isNotBlank(handShakToUrl)){
        	tourl = handShakToUrl;
        }
      
        //取Context对象中的参数
        String ssoToUrl = ssoLoginContext.getTourl();
        if(Strings.isNotBlank(ssoToUrl)){
        	tourl = ssoToUrl;
        }
        
        sb=urlMosaic(req, ssoLoginContext, tourl, sb);
        return sb;
    }

    private StringBuilder urlMosaic(HttpServletRequest req,
            SSOLoginContext ssoLoginContext, String tourl, StringBuilder sb) {
        String UserLanguage = req.getParameter(LoginConstants.LOCALE);
        if (UserLanguage != null) {
            sb.append("&" + LoginConstants.LOCALE + "=" + UserLanguage);
        }
        
        String UserAgentFrom = req.getParameter("UserAgentFrom");
        if (UserAgentFrom != null) {
            sb.append("&UserAgentFrom=" + UserAgentFrom);
        }

        String des = tourl!=null?tourl:ssoLoginContext.getDestination();
        if (StringUtils.hasText(des)) {
            sb.append("&");
            sb.append(LoginConstants.DESTINATION);
            sb.append("=");
            sb.append(java.net.URLEncoder.encode(des));

            String top = ssoLoginContext.getTopFrameName();
            if (StringUtils.hasText(top)) {
                sb.append("&");
                sb.append(Constants.TOPFRAMENAME);
                sb.append("=");
                sb.append(top);
            }
        }
        return sb;
    }

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

    private boolean isBlank(String s){
    	return s == null || s.length() == 0;
    }
}
