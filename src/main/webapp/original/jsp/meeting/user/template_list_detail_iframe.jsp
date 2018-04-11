<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/meeting/css/meeting.css${v3x:resSuffix()}" />">
<html>
<head>
</head>
<body>
<!-- Edit By Lif Start  得到上下框架的中间横条 ,删除了此处的table,增加了如下代码 -->
<script>
getDetailPageBreak(true) ;
</script>
<!-- Edit End -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
<!-- Edit By Lif Start 缩短了行间距 -->			
				<tr>
					<td width="90" height="22" nowrap class="subjectView" align="right"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" /></td>
					<td colspan="3">${bean.title}
						<c:if test="${bean.beginDate!=null&&bean.endDate!=null}">
							(<label class="meetingtimecss"><fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" /> <fmt:message key="oper.to" /> <fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" /></label>)
						</c:if>
					</td>
				</tr>
				<tr>
					<td height="22" nowrap class="sender" align="right"><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
					<td class="sender2">${v3x:showOrgEntitiesOfIds(bean.emceeId, 'Member', pageContext)}</td>
					<td height="22" nowrap class="sender" align="right"><fmt:message key="mt.mtMeeting.recorderId" /><fmt:message key="label.colon" /></td>
					<td class="sender2">${v3x:showOrgEntitiesOfIds(bean.recorderId, 'Member', pageContext)}</td>					
				</tr>
				<tr id="attachmentTr" style="display: none">
					<v3x:attachmentDefine attachments="${attachments}" />
					<td height="22" nowrap class="bg-gray" valign="top" style="padding-top:2px"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
					<td colspan="3">
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="div-float font-12px">(<span id="attachmentNumberDiv"></span>)</div>
							<script type="text/javascript">
							<!--
							showAttachment('${bean.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
							//-->
							</script>
						</div>
					</td>
				</tr>
<!-- Edit end -->								
			</table>
		</td>
	</tr>
 	<tr>
		<td height="5" class="detail-summary-separator"></td>
	</tr>
	<tr id="contentTR">
		<td>
      		<iframe src="${mtTemplateURL}?method=detail&id=${bean.id}&oper=showContent&from=${param.from}" width="100%" height="100%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>				
		</td>
	</tr>
</table>

</body>
</html>