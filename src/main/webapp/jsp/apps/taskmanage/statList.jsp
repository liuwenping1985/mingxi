<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="header.jsp" %>
<title><fmt:message key='application.30.label' bundle='${v3xCommonI18N}'/>:<fmt:message key='task.statlist' /></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body srcoll="no" style="overflow:auto;" onkeydown="listenerKeyESC()">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="25" class="webfx-menu-bar-gray border-top border-bottom padding-L">
					<c:choose>
						<c:when test="${!empty param.title}">${param.title}</c:when>
						<c:otherwise><fmt:message key='application.30.label' bundle='${v3xCommonI18N}'/></c:otherwise>
					</c:choose>
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<c:set value="${v3x:currentUser()}" var="currentUser"/>
		<%@ include file="listTable.jsp"%>
    </div>
  </div>
</div>
</body>
</html>