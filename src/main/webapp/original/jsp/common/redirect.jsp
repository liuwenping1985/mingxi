<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>	
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ page import="com.seeyon.ctp.common.controller.BaseController" %>
<%
Object redirectURLObject = request.getAttribute("redirectURL");
Object errMsg = request.getAttribute("errMsg");
Object errMsgAlertObj=request.getAttribute("errMsgAlert");
Boolean errMsgAlert=false;
if(errMsgAlertObj!=null){errMsgAlert=(Boolean)errMsgAlertObj;}
String redirectURL = "";
if (redirectURLObject != null) {
	redirectURL = (String)redirectURLObject;
	
	if(redirectURL.equals(BaseController.REDIRECT_BACK)){
		out.println("<script type=\"text/javascript\" charset=\"UTF-8\" src=\""+request.getContextPath()+"/common/js/V3X.js\"></script>");
		out.println("<script>");
		if(errMsg!=null && !"".equals(errMsg.toString())){out.println("alert(\""+errMsg.toString()+"\");");}
		//如果当前是首页。不进行跳转
		out.println("function doSomeThing(){if(getA8Top().isShowCachePage()){return false;}");
		out.println("history.back();}");
		out.println("doSomeThing()");
		out.println("</script>");
	}
	else{
		String[] prefix = redirectURL.split("[?]");
		
		redirectURL = com.seeyon.v3x.portlets.bridge.spring.taglibs.LinkTag.calculateURL("render", prefix[0], pageContext) + "?" + prefix[1];
		
		String location = "";
		Object locationOBj = request.getAttribute("location");
		if(locationOBj != null){
			location = ((String)locationOBj) + ".";
		}
		if("".equals(location) && (errMsgAlert == false || errMsg == null)){
%>
<c:set var="currentUser" value="${v3x:currentUser()}"/>
<c:if test="${currentUser.userAgentFrom=='mobile'}">
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh">
</c:if>
<c:if test="${currentUser.userAgentFrom !='mobile'}">
<html>
</c:if>
<head>
<meta http-equiv="Refresh" content="0;url=<%=redirectURL%>">
</head>
</html>
<%
		}else{
			out.println("<script>");
			if(errMsgAlert==true && errMsg!=null)
			{
			 out.println("alert(\""+errMsg+"\");");
			}
			out.println(location + "location.href=\"" + redirectURL + "\";");
			out.println("</script>");
		}
	}
}
%>
