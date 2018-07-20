<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<body class="padding5">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a  href="${newsDataURL}?method=userList" class="non-a"><fmt:message key="oper.view" /><fmt:message key="news.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>
<c:if test="${sessionScope['news.isShowPublish'] || isShowPublish}">	
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="oper.publish" /><fmt:message key="news.data_shortname" /></a></div>
				<div class="tab-tag-right-sel"></div>
</c:if>
			</div>
		</td>
	</tr>
</table>
<div class="page-border-A4" style="border-top:0px">
	<iframe noresize frameborder="no" src="${newsDataURL}?method=publishListMainEntry" id="detailIframe" name="detailIframe" style="width:100%;height: 92%;" border="0px"></iframe>			
</div>
</html>

