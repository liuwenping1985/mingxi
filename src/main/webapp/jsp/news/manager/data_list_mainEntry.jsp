<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<body class="padding5" scroll=no>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a  href="#" class="non-a"><fmt:message key="news.board" /></a></div>
				<div class="tab-tag-right-sel"></div>
				
				
				<c:if test="${sessionScope['news.isShowAudit']}">	
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${newsDataURL}?method=auditListMain&from=${from}" class="non-a"><fmt:message key="oper.audit" /><fmt:message key="news.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>
			</c:if>	
			</div>
		</td>
	</tr>
</table>
		<div class="page-border-A4" style="border-top:0px">
			<iframe id="detailIframe" noresize src="${newsDataURL}?method=mgrEntry&from=${from}&typeId=${typeId }" frameborder="no" name="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe>			
		</div>
</body>
</html>