<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.net.*" %>
<%@page import="java.io.*" %>
<%@page import="com.seeyon.ctp.common.i18n.ResourceBundleUtil" %>
<%@page import="com.seeyon.apps.nc.multi.NCMultiManager" %>
<%@page import="com.seeyon.apps.nc.multi.NCMultiManager.Provider" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle basename="com.seeyon.apps.nc.i18n.NCResources"/>
<%
response.setDateHeader("Expires",-1);
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
%>
 <%
 String accountCode=null;
 String pkcorp=null;
 String userCode=null;
 Provider provider=null;
    try {
            pkcorp=request.getParameter("pkcorp");
            userCode=request.getParameter("userCode");
            accountCode=request.getParameter("accountCode");
            String providerId=request.getParameter("providerId");
            //userCode=new String(userCode.getBytes("ISO-8859-1"),"UTF-8");
            //userCode=java.net.URLEncoder.encode(userCode,"UTF-8");;
            com.seeyon.apps.nc.ssomanager.NCSSOService register=(com.seeyon.apps.nc.ssomanager.NCSSOService)com.seeyon.ctp.common.AppContext.getBean("ncSSOService");
            String key=register.login(providerId,pkcorp,userCode);
            provider=NCMultiManager.getInstance().getProvider(providerId);
            if(org.apache.commons.lang.StringUtils.isBlank(key))
            {
                out.println("</br>");
                out.println("</br>");
                out.println("</br>");
                out.println("<center><pre><strong>"+ResourceBundleUtil.getString("com.seeyon.apps.nc.i18n.NCResources", "nc.login.fail",accountCode,userCode,provider.getUrl())+"</strong></pre></center>");
                //out.println("<br>"+"OA IP: "+request.getServerName());
                return;
            }else{
                response.sendRedirect(provider.getUrl()+"/login.jsp?clienttype=portal&"+key+"&height="+request.getParameter("height")+"&width="+request.getParameter("width")+"&autoResize=true&onlyOnePerVM=N");
            }

    } catch (Throwable e) {
                out.println("</br>");
                out.println("</br>");
                out.println("</br>");
                out.println("<center><pre><strong>"+ResourceBundleUtil.getString("com.seeyon.apps.nc.i18n.NCResources", "nc.login.fail",accountCode,userCode,provider.getUrl())+"</strong></pre></center>");
                out.println(e.getMessage());
    }   
           
    
    %>