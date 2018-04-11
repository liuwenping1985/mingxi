<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>
	<script type="text/javascript">
		getDetailPageBreak(true);
	</script>
</head>
<body>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td width="100" height="28" nowrap class="bg-gray detail-subject" align="right">&nbsp;</td>
					<td class="detail-subject" width="30%"><fmt:message key="mt.mtSubject.label" /><fmt:message key="label.colon" />${bean.templateName}</td>
					
					<td height="28" nowrap class="detail-subject"  width="30%" align="center"><fmt:message key="mt.mtType.label" /><fmt:message key="label.colon" />
					
						<c:choose>
							<c:when test="${bean.ext1 == '1'}">
								<fmt:message key="mt.mtMeeting"/>
							</c:when>
							<c:when test="${bean.ext1 == '2'}">
								<fmt:message key="mt.mtPlan"/>
							</c:when>
							<c:when test="${bean.ext1 == '3' || bean.ext2 == '3'}">
								<fmt:message key="mt.mtBulletion"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="mt.mtNews"/>
							</c:otherwise>
						</c:choose>
					
					</td>
		
					<td height="22" nowrap class="bg-gray detail-subject" width="30%"><fmt:message key="common.date.lastupdate.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" />
					<fmt:formatDate value="${bean.updateDate}" type="both" pattern="${datePattern}"/></td>
					<td width="100" height="28" nowrap class="bg-gray detail-subject" align="right">&nbsp;</td>
				</tr>
				<tr id="attachmentTr" style="display: none">
					<td height="18" nowrap class="bg-gray detail-subject" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
					<td colspan="4">
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="detail-subject">(<span id="attachmentNumberDiv"></span>)</div>
							<script type="text/javascript">
							<!--
							showAttachment('3036614342760681198', 0, 'attachmentTr', 'attachmentNumberDiv');
							//-->
							</script>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
 	<tr>
		<td height="5" class="detail-summary-separator"></td>
	</tr>
  <tr>
		<td valign="top">
      		<iframe src="${mtContentTemplateURL}?method=detail&id=${bean.id}&oper=showContent" width="100%" height="97%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>
	
</table>

</body>
</html>