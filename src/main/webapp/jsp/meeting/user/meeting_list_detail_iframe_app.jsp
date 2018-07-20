<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
	<%@ include file="../include/header.jsp" %>
</head>
<script type="text/javascript">
function init(){
	if("${audier_Disabled}" != null && "${audier_Disabled}" != ""){
		alert("审核领导："+"${audier_Disabled} " + "已被系统管理员删除，请撤销重新选择审核人！");
	}
}
</script>
<body style="overflow: hidden" onload="init();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
<!-- Edit By Lif Start 缩短了行间距 -->					
							<c:if test="${bean.accountName!=null }">
								<c:set value="(${bean.accountName})" var="createAccountName"/>
							</c:if>			
					    	<TR>
      							<TD width="10%" height="22" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" />&nbsp;&nbsp;</TD>
      							<TD class="detail-subject" colspan="3">${v3x:toHTML(bean.title)}${createAccountName} </TD>
      							<TD width="10%" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.searchdate" /><fmt:message key="label.colon" /></TD>
      							<TD class="detail-subject"><fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatDate pattern="${mtHoldTimeInSameDay ? timePattern : datePattern}" value="${bean.endDate}" /></TD>
    						</TR>
    					    <TR>
						      <TD height="22" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.list.column.app_person" /><fmt:message key="label.colon" />&nbsp;&nbsp;</TD>
						      <TD class="detail-subject" colspan="3" width="40%">${v3x:showOrgEntitiesOfIds(bean.createUser, 'Member', pageContext)}&nbsp;&nbsp;(<fmt:formatDate value="${bean.createDate}" pattern="yyyy-MM-dd HH:mm"/>)</TD>
						      <% 
						     	 if (com.seeyon.v3x.common.SystemEnvironment.hasPlugin("zhbg")){
						      %>
						      <TD width="10%" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.approve" /><fmt:message key="label.colon" /></TD>
							  <TD class="detail-subject">
							  	<c:forEach items="${approveExList}" var="rl">
									<c:out value="${rl.name}" />&nbsp;
								</c:forEach>
							  </TD>
							  <%
						     	 }else{
							  %>
							  <TD></TD>
							  <TD></TD>
							  <%
						     	 }
							  %>
						    </TR>
							<TR>
						      <TD width="10%" height="22" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;</TD>
						      <td class="detail-subject" colspan="5">${v3x:toHTML(bean.mtTitle)}</td>
						    </TR> 
							<tr id="attachment2Tr" style="display: none">
                             <v3x:attachmentDefine attachments="${attachments}" />
								<td height="22" nowrap class="bg-gray" valign="bottom">
								
								<fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" /> :&nbsp;&nbsp; </td>
								
								
								<td valign="bottom" colspan="5">

										<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
										<div class="div-float font-12px">(<span id="attachment2NumberDiv" class="font-12px"></span>)</div>
										<script type="text/javascript">
										<!--
										showAttachment('${bean.id}', 2, 'attachment2Tr', 'attachment2NumberDiv');
										//-->
										</script>
									</div>
									
								</td>
							</tr>							    
							
							
							
							<tr id="attachmentTr" style="display: none">
								<v3x:attachmentDefine attachments="${attachments}" />
								<td class="bg-gray"  height="22" valign="bottom" style="padding-top:2px"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" />&nbsp;&nbsp; </td>
								<td colspan="5"  nowrap valign="bottom">
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
						
							
<!-- Edit End -->							
			</table>
		</td>
	</tr>
 	<tr>
		<td height="5" class="detail-summary-separator"></td>
	</tr>
	
	<tr id="contentTR">
		<td valign="top">
      		<iframe src="mtAppMeetingController.do?method=detail&id=${bean.id}&oper=showContent" width="100%" height="100%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>
	
</table>

</body>
</html>