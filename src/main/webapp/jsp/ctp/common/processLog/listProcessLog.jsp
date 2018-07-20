<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../../common/INC/noCache.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<title><fmt:message key="processLog.list.title.alt.label" bundle="${v3xCommonI18N}"/></title>
</head>
<body onkeydown="listenerKeyESC()" scroll="no">
<form>
	<div id="print" style="overflow: auto; height: 100%;">
				<v3x:table data="${processLogList}" var="bean" htmlId="ee" className="sort ellipsis" isChangeTRColor="true" showHeader="true" showPager="true"  varIndex="num" pageSize="20" dragable="true">
				<v3x:column width="5%" type="Number" label="processLog.list.number.label">
					${num+1}
				</v3x:column>
				<v3x:column width="15%" type="String" label="processLog.list.actionuser.label"  value="${v3x:showMemberNameOnly(bean.actionUserId)}" alt="${v3x:showMemberNameOnly(bean.actionUserId)}" />
				<v3x:column width="15%" type="String" label="processLog.list.date.label"  alt="">
					<fmt:formatDate value="${bean.actionTime}" pattern="${datetimePattern}"/>
				</v3x:column>
				<v3x:column width="20%" type="String" label="processLog.list.content.label">
					${bean.actionName}
				</v3x:column>
				<v3x:column width="25%" type="String" label="processLog.list.description.label"  value="${bean.actionDesc}" alt="${bean.actionDesc}" />
				<v3x:column width="20%" type="String" label="common.opinion.label">
					${bean.param5}&nbsp;
				</v3x:column>
				</v3x:table>
	</div>
</form>
</body>
</html>