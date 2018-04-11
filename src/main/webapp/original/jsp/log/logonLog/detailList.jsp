<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<title>Insert title here</title>
</head>
<body scroll="yes">
<form>
<fmt:message key="message.online.loginType" var="loginTypeTitle" bundle="${v3xMainI18N}" />
<div id="print" style="height: 100%">
<v3x:table data="${results}" var="result" htmlId="dd" isChangeTRColor="true" showHeader="true" showPager="true">
  <v3x:column width="10%" label="logon.stat.person" maxLength="40" value='${v3x:getLimitLengthString(v3x:showMemberNameOnly(result.memberId),10,"...") }'  type="String"/>
  
  <v3x:column width="15%" type="String" label="log.toolbar.title.account" maxLength="12" value='${v3x:showOrgAccountNameByMemberid(result.memberId)}' />
  <v3x:column width="10%" type="String" label="logon.org.post" maxLength="12" value='${v3x:showOrgPostNameByMemberid(result.memberId)}' />
  
  <fmt:formatDate value="${result.logonTime}"  pattern="${datePattern}" var="logonTime"/>
  <fmt:formatDate value="${result.logoutTime}"  pattern="${datePattern}" var="logoutTime"/>
  <v3x:column width="10%"  type="Date" label="logon.search.logonTime" maxLength="40" value="${logonTime }"   />
   <c:choose>
	<c:when test="${onlineLog == result.id}">
		<c:set var="state" value="logon.search.online"/>
		<c:set var="logoutTimes" value="--"/>
		<c:set var="onlineTimeTemp" value="${(now.time - result.logonTime.time)/(1000*60)}"/>
		<c:set var="onlineTime" value="${fn:substring(onlineTimeTemp,0,fn:indexOf(onlineTimeTemp,'.'))}"/>
	</c:when>
	<c:when test="${result.logoutType==0 }">
		<c:set var="state" value="logon.search.logoutNoError"/>
		<c:set var="logoutTimes" value="${logoutTime }"/>
		<c:set var="onlineTime" value="${result.onlineTime}"/>
	</c:when>
	<c:otherwise>
		<c:set var="state" value="logon.search.logoutWithError"/>
		<c:set var="logoutTimes" value="--"/>
		<c:set var="onlineTime" value="${result.onlineTime}"/>
	</c:otherwise>
</c:choose>
  <v3x:column width="10%" type="Date" label="logon.search.logoutTime" maxLength="40" value="${logoutTimes }" />
  <v3x:column width="10%"  type="String" label="logon.search.onlineTime" maxLength="40" value="${fn:substring((onlineTime / 60),0,fn:indexOf((onlineTime / 60),'.')) }小时${onlineTime % 60 }分" />
  <v3x:column width="10%" type="String" label="logon.search.ip" maxLength="40" value="${result.ipAddress }" />
  <v3x:column width="10%" type="String"  label="${loginTypeTitle}">
  	<fmt:message key='online.loginType.${result.loginType}' bundle="${v3xMainI18N}" />
  </v3x:column>
  <v3x:column width="10%" type="String" label="logon.search.remark" maxLength="40" value="${v3x:_(pageContext,state)}" />
</v3x:table>
</div>
</form>
</body>
</html>