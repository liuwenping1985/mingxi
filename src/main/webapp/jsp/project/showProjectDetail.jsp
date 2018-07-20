<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${path}/common/all-min.css">
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
</c:if>
<html>
<head>
</head>
<body class="h100b cardmini">
    	<div class="adapt_w font_size12 form_area people_msg" >
    		<table cellpadding="0" cellspacing="0" width="200" class="margin_l_5">
    			<c:if test="${leaderNames ne ''}">
	    			<tr>
	    				<th nowrap="nowrap" style="text-align:left">${ctp:i18n('plan.project.body.manger.label')}:</th>
	    				<td width="180" height="20" nowrap="nowrap">
	    					<span style="width:132px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;word-break:keep-all;">${leaderNames}</span>
	    				</td>
	    			</tr>
    			</c:if>
    		</table>
    		<table cellpadding="0" cellspacing="0" width="200" class="margin_l_5">
    			<tr>
    				<th nowrap="nowrap" style="text-align:left">${ctp:i18n('plan.project.body.responsible.label')}:</th>
    				<td width="180" height="20" nowrap="nowrap">
	    					<span style="width:132px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;word-break:keep-all;">${principalNames}</span>
	    			</td>
    			</tr>
    		</table>
    		<table cellpadding="0" cellspacing="0" width="200" class="margin_l_5">
    			<tr>
    				<th nowrap="nowrap" style="text-align:left">${ctp:i18n('plan.project.detail.projecttime')}:</th>
    				<td width="180" nowrap="nowrap" class="text_overflow">${dateStr}</td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap" style="text-align:left">${ctp:i18n('plan.project.process.label')}:</th>
    				<td width="180" nowrap="nowrap" class="text_overflow">${process}</td>
    			</tr>
    		</table>
    	</div>
	</body>
</html>