<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<title><fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' /></title>
<%-- 说明：  --%>
<%-- 复选框的事件是：onclick="parent.quoteDocumentSelected(this, subject, ${applicationCategoryType.name}, id)"  --%>

<script type="text/javascript">
<!--
function change1(){
	changeTabSelected('1');
	changeTabUnSelected('3');
	
	quoteDocumentFrame.location.href = '${detailURL}?method=list4Quote&appType=${appType}';
}

function change3(){
	changeTabSelected('3');
	changeTabUnSelected('1');
	
	quoteDocumentFrame.location.href = '${docURL}?method=docQuoteFrame';
}
function OK(){
    var atts = fileUploadAttachments.values().toArray();

    if (!atts || atts.length < 1) {
        alert(getA8Top().v3x.getMessage('collaborationLang.collaboration_alertQuoteItem'));
        return;
    }
    return atts;
}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' /> - <fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="bottom" height="26" class="tab-tag">
						<div class="div-float" style="border-left:solid 1px #B6B6B6;border-right:solid 1px #B6B6B6;">
							<div id="l-1" class="tab-tag-left-sel"></div>
							<div id="m-1" class="tab-tag-middel-sel" onclick="change1()"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></div>
							<div id="r-1" class="tab-tag-right-sel"></div>
							
							<div class="tab-separator"></div>
							
							<div id="l-3" class="tab-tag-left"></div>
							<div id="m-3" class="tab-tag-middel  cursor-hand" onclick="change3()"><fmt:message key="menu.doc.docCenter" bundle="${v3xMainI18N}" /></div>
							<div id="r-3" class="tab-tag-right"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="tab-body-bg" style="padding:0;">
						<iframe src="${detailURL}?method=list4Quote&appType=${appType}" name="quoteDocumentFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
					</td>
				</tr>
				<tr>
					<td height="20" style="padding-left: 15px;"><fmt:message key="col.quoteDocument.selected.label"  bundle="${colI18N}" />:</td>
				</tr>
				<tr>
					<td height="60" style="padding: 0px 15px 0px 15px;"><div style="height: 100%; width: 100%;float: left; overflow-y: auto" id="attachment2Area">&nbsp;</div></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="quoteDocumentOK()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
<script type="text/javascript">

var fileUploadAtts = null;
if(window.dialogArguments){
	fileUploadAtts = window.dialogArguments.fileUploadAttachments;
}else{
	fileUploadAtts = window.parent.fileUploadAttachments;
}
//var fileUploadAtts = window.dialogArguments.fileUploadAttachments;
if(fileUploadAtts){
	var atts = fileUploadAtts.values();
	for(var i = 0; i < atts.size(); i++) {
		var att = atts.get(i);
		if(att.type == 2){
			fileUploadAttachments.put(att.fileUrl, att);
			showAtachmentObject(att, true);
		}
	}
}
</script>
</body>
</html>