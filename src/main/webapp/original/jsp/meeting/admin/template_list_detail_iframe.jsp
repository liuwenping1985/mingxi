<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">

<script type="text/javascript">
<!--
var status_0 = "0,*";
var status_1 = "30%,*";
var status_2 = "*,12";
var status_3 = "30%,*";

var indexFlag = 0;
function previewFrame(){
	var obj = parent.parent.document.all.sx;
	if(obj == null){
		obj = parent.document.all.sx;
	}
	
	if(obj == null){
		return;
	}
	
	if(indexFlag > 3){
		indexFlag = 0;
	}
	
	eval("obj.rows = status_" + indexFlag);
	indexFlag++;
}
//-->
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr align="center">
		<td height="12" class="detail-top"><img src="" height="8" onclick="previewFrame()" class="cursor-hand"></td>
	</tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td width="90" height="28" nowrap class="subjectView"align="right"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" /></td>
					<td class="subjectView2">${bean.title} 
					<c:if test="${bean.beginDate!=null&&bean.endDate!=null}">
						(<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" /> <fmt:message key="oper.to" /> <fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />)</td>
					</c:if>
				</tr>
				<tr>
					<td height="22" nowrap class="sender"><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
					<td class="sender2">${v3x:showOrgEntitiesOfIds(bean.emceeId, 'Member', pageContext)}</td>
				</tr>
				<tr>
					<td height="22" nowrap class="sender"><fmt:message key="mt.mtMeeting.recorderId" /><fmt:message key="label.colon" /></td>
					<td class="sender2">${v3x:showOrgEntitiesOfIds(bean.recorderId, 'Member', pageContext)}</td>
				</tr>				
				<tr id="attachmentTr" style="display: none">
					<v3x:attachmentDefine attachments="${attachments}" />
					<td height="18" nowrap class="sender" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
					<td class="sender2">
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="div-float sender2">(<span id="attachmentNumberDiv"></span>)</div>
							<script type="text/javascript">
							<!--
							showAttachment('${bean.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
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
	<tr id="contentTR">
		<td>
      <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="body-left"><img src="javascript:void(0)" height="1" width="20px"></td>
          <td><v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="col-contentText"/></td>
          <td class="body-right"><img src="javascript:void(0)" height="1" width="20px"></td>
        </tr>
      </table>				
		</td>
	</tr>
	<tr>
		<td height="2px">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="body-buttom-left"><img src="" height="1"></td>
					<td class="body-buttom-line"><img src="" height="1"></td>
					<td class="body-buttom-right"><img src="" height="1"></td>
				</tr>
			</table>	
		</td>
	</tr>
</table>

</body>
</html>