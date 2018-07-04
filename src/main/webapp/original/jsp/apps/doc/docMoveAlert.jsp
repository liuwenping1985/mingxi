<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html style="height:100%;">
<head>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.tree.move.title'/></title>
<style>
	.collectCol{
		color:red;
	}
	.collectSize{
		font-size:14px;
		font-weight: bold;
		line-height: 20px;
	}
</style>
</head>
<body scroll="no">
	 <div style="width:100%;text-align:left;margin-left: 20px;height:270px;">
		<span class="collectCol collectSize"><fmt:message key='doc.jsp.alert.collect.msg'/></span><br>
		<span class="collectSize"><fmt:message key='doc.alert.collect.msg'/></span><br><br>
		<c:forEach items="${names}" var="docNames" varStatus="len" end="10">
		<c:choose> 
			<c:when test="${len.index > 9}">
				<span>······</span><br>
			</c:when>
			<c:otherwise>
				<span>${v3x:toHTML(v3x:_(pageContext, docNames))}</span><br>
			</c:otherwise>
		</c:choose>
		</c:forEach>
	</div>
	<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
			<div  class="bg-advance-bottom" style="text-align:right;">
				<input style="margin-top:10px;" type="button" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</div>
	</c:if>
	
<!--<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top:10px;height:320px;">
	<tr height="42">
		<td><span class="collectCol collectSize"  style="margin-left: 20px;"><fmt:message key='doc.jsp.alert.collect.msg'/></span></td>
	</tr>
	<tr height="42">
		<td><span class="collectSize"  style="margin-left: 20px;"><fmt:message key='doc.alert.collect.msg'/></span></td>
	</tr>
	<c:forEach items="${names}" var="docNames" varStatus="len" end="10">
		<c:choose> 
			<c:when test="${len.index > 9}">
				<tr height="42"><td><span  style="margin-left: 20px;">······</span></td></tr>
			</c:when>
			<c:otherwise>
				<tr height="42"><td><span  style="margin-left: 20px;">${v3x:toHTML(v3x:_(pageContext, docNames))}</span></td><tr>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
		<tr height="42">
			<td align="right" class="bg-advance-bottom">
				<input type="button" name="b2" id="b2" onclick="window.close();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		</c:if>
</table>-->
</body>
</html>