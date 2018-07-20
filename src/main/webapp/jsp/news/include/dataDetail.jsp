

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/news/css/news.css${v3x:resSuffix()}" />">
<html>
<head>
<title>

</title>


</head>
<body scroll='no'  onkeydown="listenerKeyESC()">


	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" >
		<tr height="8">
			<td  width="100%" height="8" >
			
				<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
					<tr >
						<td colspan="6" width="100%" height="8">
							<script type="text/javascript">
								getDetailPageBreak();
							</script>
						</td>
					</tr>
				  </table>  
				</td>
		</tr>
			
			<tr>
			<td  width="100%" >
			<div class="scrollList">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"
style="word-break:break-all;word-wrap:break-word"
>		
	<tr>
		<td align="center" colspan="3" class="paddingLR newsTitle" height="15" valign="top">

		</td>
	</tr>
	<tr>
		<td align="center" colspan="3" class="paddingLR newsTitle" height="30" valign="top">
			${bean.title}
			<hr size="1" class="newsBorder">
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center" class="paddingLR font-12px" height="40" valign="top">
			<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" /> 
			&nbsp;&nbsp;&nbsp;&nbsp;
			${bean.publishDepartmentName}
			&nbsp;&nbsp;&nbsp;&nbsp;
			${bean.createUserName}
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="label.readCount" />: ${bean.readCount}
		</td>
	</tr>
	<c:if test="${bean.brief != null}">
	<tr>
		<td colspan="3" class="paddingLR" height="80" valign="top">
			<div id="newsSummary" class="font-12px">
			<b><fmt:message key="news.data.brief"/>:</b>&nbsp;&nbsp;${bean.brief}
			</div>
		</td>
	</tr>
	</c:if>
	<tr>
		<td colspan="3" class="paddingLR" valign="top" height="500">
			<c:choose>
				<c:when test="${bean.dataFormat == 'HTML'}">
					<div class="contentText">${bean.content}</div>
				</c:when>
				<c:otherwise>
					<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="paddingLR" height="10" valign="top">
			<hr size="1" class="newsBorder">
		</td>
	</tr>
	<c:if test="${bean.keywords != null}">
	<tr>
		<td colspan="3" class="paddingLR" height="22" valign="top">
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50" nowrap="nowrap" class="font-12px"><fmt:message key="news.data.keywords" />:&nbsp;</td>
					<td width="100%" class="font-12px">${bean.keywords}</td>
				</tr>
			</table>
		</td>
	</tr>
	</c:if>
	<tr id="attachmentTr" style="display: none">
		<td colspan="3" class="paddingLR font-12px" height="30">
			<%-- 附件显示 --%>
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50" nowrap="nowrap" class="font-12px"><b><fmt:message key="label.attachments" /></b>:&nbsp;</td>
					<td width="100%" class="font-12px">
						<v3x:attachmentDefine attachments="${attachments}" />
						<%-- 
						(<span id="attachmentNumberDiv"></span>)
						--%>
						<script type="text/javascript">
							showAttachment('${bean.id}', 0, 'attachmentTr', '');
						</script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" height="10" valign="top">
			<hr size="1" class="newsBorder">
		</td>
	</tr>

</table>
<c:if test="${bean.type.auditFlag == true}">
				<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" class="paddingLR font-12px">
					<tr>
						<td height="30" style="text-align: left;" class="font-12px">
						<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}"  /><fmt:message key="label.colon" />

						</td>
					</tr>
				</table>	
				<table width="100%" height="80" border="0" cellpadding="0" cellspacing="0" class="paddingLR font-12px">
					<tr>	
						<td align="center" height="100%" class="paddingLR" ><textarea id="auditAdvice" readonly="readonly" name="auditAdvice" rows="5" style="width:100%">${bean.auditAdvice}</textarea></td>
					</tr>

				</table>
</c:if>

				
				
				<c:if test="${bean.state == '20'}">
				
								<table id="publishBtn" width="100%" height="50" border="0" cellpadding="0" cellspacing="0" class="paddingLR font-12px">
					<tr>
						<td height="30" style="text-align: right;" class="font-12px">
						<input
			type="button" name="b1" id="b1" onclick="publishIt('${bean.id}')"
			value="<fmt:message key="oper.publish" bundle='${bulI18N}' />"
			class="button-default-2">

						</td>
					</tr>
				</table>	
				
				<script>
						function publishIt(id){
							hiddenIframe.document.location.href = '${newsDataURL}?method=publishIt&id='+id;
						}
						
						if(!window.dialogArguments){
							document.getElementById("publishBtn").style.display = "none";
						}
				</script>	

				</c:if>	




				</div>	
				</td>
			</tr>

	</table>
				</div>	
				</td>
			</tr>

	</table>

<iframe id="hiddenIframe" name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>



</body>
</html> 