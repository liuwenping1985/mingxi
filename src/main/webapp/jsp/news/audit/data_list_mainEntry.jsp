<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>

</head>
<body class="padding5" scroll=no>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<c:if test="${noManagerLabel == false}"><!-- 说明没有管理板块的权限，只有审核权限 -->
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="tab-separator"></div>
			<div class="div-float">
				<c:choose>
					<c:when test="${newsTypeId !=null }">
						<div class="tab-tag-left"></div>
						<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${newsDataURL}?method=listBoardIndex&spaceType=${param.spaceType}&newsTypeId=${newsTypeId}&from=${from}&spaceId=${param.spaceId}'"><fmt:message key="news.title" /><fmt:message key="oper.manage" /></div>
						<div class="tab-tag-right"></div>	
						<div class="tab-separator"></div>
					</c:when>
					<c:otherwise>
						<div class="tab-tag-left"></div>
						<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${newsDataURL}?method=listBoard&spaceType=${param.spaceType}&newsTypeId=${param.newsTypeId}&from=${from}&spaceId=${param.spaceId}'"><fmt:message key="news.title" /><fmt:message key="oper.manage" /></div>
						<div class="tab-tag-right"></div>	
						<div class="tab-separator"></div>
					</c:otherwise>
				</c:choose>
					
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel cursor-hand" onclick="javascript:location.href=location;">
					<fmt:message key="news.title" /><fmt:message key="oper.audit" />
				</div>
				<div class="tab-tag-right-sel"></div>
				
			</div>
			<div class="tab-separator"></div>
		</td>
	</tr>
</c:if>
	<tr><td valign="top">
	<div style="height: 100%;">
        <!--yangwulin Sprint4 2012-11-05 添加了一个参数 newsTypeId-->
		<iframe id="entryIframe" src="${newsDataURL}?method=entry&spaceType=${v3x:toHTML(param.spaceType)}&from=${from}&showAudit=${v3x:toHTML(noManagerLabel)}&spaceId=${v3x:toHTML(param.spaceId)}&newsTypeId=${v3x:toHTML(newsTypeId)}" frameborder="0" name="detailIframe" style="width:100%;height: 100%;" scrolling="no"></iframe>
	</div>
	</td></tr>
</table>

</body>
</html>



