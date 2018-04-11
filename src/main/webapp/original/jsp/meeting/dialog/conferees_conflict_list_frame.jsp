<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body onload="">

<div class="main_div_row2">

<div class="right_div_row2">

<div class="center_div_row2" id="scrollListDiv" style="top:0;">

<form name="listForm" id="listForm" action="meeting.do" method="post" style="margin: 0px">
<input type="hidden" id="method" name="method" value="listConfereesConflict" />
<input type="hidden" id="meetingId" name="meetingId" value="${v3x:toHTML(param.meetingId)}" />
<input type="hidden" id="beginDatetime" name="beginDatetime" value="${param.beginDatetime}" />
<input type="hidden" id="endDatetime" name="endDatetime" value="${param.endDatetime}" />
<input type="hidden" id="emceeId" name="emceeId" value="${param.emceeId}" />
<input type="hidden" id="recorderId" name="recorderId" value="${param.recorderId}" />
<input type="hidden" id="conferees" name="conferees" value="${param.conferees}" />

<v3x:table htmlId="listTable" data="list" var="bean" showPager="false">
    
<v3x:column width="10%" type="String" label="mt.mtType.label" className="cursor-hand sort" maxLength="45" symbol="...">
	<c:choose>
        <c:when test="${bean.meetingUserType == 2}">
            <fmt:message key="mt.mtReply.user_id"/>
        </c:when>
        <c:when test="${bean.meetingUserType == 1}">
            <fmt:message key="mt.mtMeeting.recorderId"/>
        </c:when>
        <c:when test="${bean.meetingUserType == 0}">
            <fmt:message key="mt.mtMeeting.emceeId"/>
        </c:when>
        <c:otherwise>
        </c:otherwise>
    </c:choose>
</v3x:column>
   
<v3x:column width="50%" type="String" label="meeting.collide.message" className="cursor-hand sort" maxLength="45" symbol="..." alt="${bean.displayTitle ? bean.mtTitle:''}">
	<c:choose>
	    <c:when test="${bean.collideType eq 'Member'}">
	        ${ctp:toHTML(v3x:showMemberName(bean.id))}&nbsp;
	    </c:when>
	    <c:when test="${bean.collideType eq 'Account'}">
	        ${v3x:getAccount(bean.id).name}&nbsp;<fmt:message key="meeting.collide.join.account"/>
	    </c:when>
	    <c:when test="${bean.collideType eq 'Department'}">
	        ${v3x:getDepartment(bean.id).name}&nbsp;<fmt:message key="meeting.collide.join.department"/>
	    </c:when>
	</c:choose>
	<fmt:message key="meeting.coolide.plan"/>
</v3x:column>

<v3x:column width="20%" type="String" label="mt.mtMeeting.beginDate" className="cursor-hand sort" maxLength="45" symbol="...">
	<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
</v3x:column>

<v3x:column width="20%" type="String" label="common.date.endtime.label" className="cursor-hand sort" maxLength="45" symbol="...">
	<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
</v3x:column>

</v3x:table>
</form>
</div>
</div>
</div>

</body>
</html>