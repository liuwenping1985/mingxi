<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">

</head>
<body>
<script type="text/javascript">
<!--
getDetailPageBreak();
//-->
</script>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td width="90" height="28" nowrap class="subjectView"align="right"><fmt:message key="bul.template.templateName" /><fmt:message key="label.colon" /></td>
					<td class="subjectView2">${bean.templateName}</td>
				</tr>
				<tr id="attachmentTr" style="display: none">
					<td height="18" nowrap class="attachmentView" valign="top"><fmt:message key="attachment.label" /> <fmt:message key="label.colon" /> </td>
					<td>
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
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
		<!-- Edit By Lif Start --><td height="85%"><div class="scrollList"><!-- Edit End -->
      <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="body-left">&nbsp;</td>
          <td><v3x:showContent content="${bean.content}" type="${bean.templateFormat}" createDate="${bean.createDate}" /></td>
          <td class="body-right">&nbsp;</td>
        </tr>
      </table>	<p></p>	
      	</div>		
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table height="4px" width="100%" border="0" cellspacing="0" cellpadding="0">
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