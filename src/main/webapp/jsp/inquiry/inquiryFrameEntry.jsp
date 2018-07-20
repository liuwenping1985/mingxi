<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="inquiryHeader.jsp"%>
</head>
<body class="padding5" scroll=no>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
		<div class="div-float">
			<div class="tab-separator"></div>
			<c:choose>
				<c:when test="${surveytypeid !=null }">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${basicURL}?method=survey_index&mid=mid&surveytypeid=${surveytypeid}&group=${group}&hasCheckAuth=${hasCheckAuth}&spaceType=${param.spaceType}&spaceId=${v3x:toHTML(param.spaceId)}" class="non-a"><fmt:message key="inquiry.manage.inquiry.label"></fmt:message></a></div>
					<div class="tab-tag-right"></div>	
					<div class="tab-separator"></div>
				</c:when>
				<c:otherwise>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${basicURL}?method=getAuthoritiesTypeList&group=${group}&spaceType=${param.spaceType}&spaceId=${v3x:toHTML(param.spaceId)}" class="non-a"><fmt:message key="inquiry.manage.inquiry.label"></fmt:message></a></div>
					<div class="tab-tag-right"></div>	
					<div class="tab-separator"></div>
				</c:otherwise>
			</c:choose>
			
			<div class="tab-tag-left-sel"></div>
			<div class="tab-tag-middel-sel"><fmt:message key="inquiry.auditor.manage.label"></fmt:message></div>
			<div class="tab-tag-right-sel"></div>
			<div class="tab-separator"></div>
		</div>
		</td>
	</tr>
	
	<tr><td colspan="2">
		<div style="height: 100%;">
			<iframe src="${basicURL}?method=checkerListFrameInner&group=${group}&surveytypeid=${surveytypeid}&spaceType=${param.spaceType}&spaceId=${v3x:toHTML(param.spaceId)}" frameborder="0" name="detailIframe" style="width:100%;height: 100%;" scrolling="no"></iframe>
		</div>
	</td></tr>
</table>

</body>
</html>

