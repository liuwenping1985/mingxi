<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE Html>
<%@ include file="../../common/INC/noCache.jsp"%>    
<html>
<head>    
<%@include file="../edocHeader.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no">
	<div class="main_div_row2">
	  <div class="right_div_row2" style="_padding-top:45px;">
	    <div class="top_div_row2">
			<table class="popupTitleRight" width="100%"border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="20" class="PopupTitle" ><fmt:message key="col.supervise.title.label" bundle="${v3xCommonI18N}"/></td>
				</tr>
			</table>
		</div>

	
<div  class="center_div_row2" id="scrollListDiv" style="top:45px;">

<form name="sendForm" id="sendForm" method="post">
<v3x:table data="logList" var="bean" htmlId="list" showHeader="true" showPager="true" pageSize="10">
		<fmt:formatDate value="${bean.sendTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm" var="date1"/>
	<v3x:column width="20%" type="String" align="center"
		label="col.supervise.hastenTime" className="cursor-hand sort"  alt="${date1}" value="${date1}">
	</v3x:column>
	<v3x:column width="20%" type="String" align="center"
		label="col.supervise.hastener" className="cursor-hand sort" maxLength="6" symbol="...">
		${v3x:showMemberName(bean.sender)}
	</v3x:column>	
	<v3x:column width="20%" type="String" align="center"
		label="col.supervise.receiver" className="cursor-hand sort" value="${v3x:showOrgEntitiesOfIds(bean.reveiverIds,'Member',pageContext)}" maxLength="20">
	</v3x:column>	
	<v3x:column width="40%" type="String" align="left"
		label="col.supervise.content" className="cursor-hand sort" value="${bean.content}" maxLength="40">
	</v3x:column>	
</v3x:table>
</form>
</div>
</div>
</body>
</html>		