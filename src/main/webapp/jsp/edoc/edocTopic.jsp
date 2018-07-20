<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<html class="over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp"%>
<v3x:showHtmlSignetOcx/> 
<fmt:message key="common.opinion.been.hidden.label" bundle="${v3xCommonI18N}" var="opinionHidden" />
<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" var="attachmentLabel" />
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edocDisplay.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery-ui.custom.min.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.plugin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-ui.custom.js${v3x:resSuffix()}" />"></script>
<c:set value="${v3x:currentUser().id == summary.startUserId}" var="currentUserIsSender"/>
<style>
	.metadataItemDiv {
		font-size:12px;
	}
 .ui-menu *{font-size:12px;}
</style>
<script>
var _fileUrlStr = "${fileUrlStr}";
var logoURL = "${logoURL}";
var phraseURL = '<html:link renderURL="/edocController.do?method=listPhrase" />';
var attachmentLabel = "${v3x:escapeJavascript(attachmentLabel)}";
var theToShowAttachments = parent.theToShowAttachments || null;
var opn = "${opn}";
var bodyType="${formModel.edocBody.contentType}";
var canTransformToPdf="${canConvert}";
var onlySeeContent ='${onlySeeContent}';
${docMarkByTemplateJs}
formOperation = "aa";
${opinionsJs}
var isFromTrace = openFrom == "repealRecord" || openFrom == 'stepBackRecord';
var officecanPrint = isFromTrace ? 'false' : '${officecanPrint}';
var officecanSaveLocal =  isFromTrace ? 'false' : '${officecanSaveLocal}';
parent.officecanPrint = officecanPrint;
parent.officecanSaveLocal = officecanSaveLocal;
var onlySeeContent="${onlySeeContent}";
//设置打开的印章变灰
parent.setSignatureBlack = "${isDeptPigeonhole}";  
var isBoundSerialNo = "${isBoundSerialNo}";
var openFrom="${v3x:escapeJavascript(openFrom)}";
var docId="${docId}";
var docSubject="${v3x:escapeJavascript(formModel.edocSummary.subject)}";
var summaryId="${formModel.edocSummary.id}";
var isAllowContainsChildDept_ExchangeUnit = true;
var edocResourseNotExist = "<fmt:message key='edoc.resourse.notExist'/>";
var subState = "${subState}";
var recEdocId = "${recEdocId}";
var paramRecType = "${v3x:escapeJavascript(param.recType)}";
var paramForwardType = "${v3x:escapeJavascript(param.forwardType)}";
var paramRecEdocId = "${v3x:escapeJavascript(param.recEdocId)}";
var relationUrl = "${relationUrl}";
var paramRelSends = "${v3x:escapeJavascript(param.relSends)}";
var paramRelRecs = "${v3x:escapeJavascript(param.relRecs)}";

var optionTypes;
$(function(){
	optionTypes = $("#optionType").val();
});
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocTopic.js${v3x:resSuffix()}" />"></script>
${hwjs} 
</head>
<body id="bodyId" class="over_hidden" onload="edocFormDisplay();loadRelationButton();loadUE()" onunload="edocContentUnLoad();" <c:if test="${onlySeeContent=='true'}">scroll="no"</c:if>>

<!-- changyi添加,显示意见状态 -->
    <input type="hidden" name="optionId"   id="optionId" value="${optionId}">
    <input type="hidden" name="affairState"   id="affairState" value="${affairState}">
    <input type="hidden" name="optionType"   id="optionType" value="${optionType}">

<%--puyc --%>
<div id="relationSend" align="right" style="display:none;"> <a href="#" onclick="relationSendV()" ><font color=red><fmt:message key='edoc.associated.posting'/></font></a></div>
<div id="relationRec" align="right" style="display:none;"> <a href="#" onclick="relationRecV()" ><font color=red><fmt:message key='edoc.associated.geting'/></font></a></div>
<%--//puyc --%>
<form name="sendForm" id="sendForm" method="post" action="">
<%@include file="unitId.jsp" %>
<input type="hidden" name="appName"   id="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" name="summaryId" id="summaryId" value="${formModel.edocSummary.id}">
<input type="hidden" name="edoctable" id="edoctable" value="${formModel.edocSummary.formId}">
<input type="hidden" name="edocType"  id="edocType"  value="${formModel.edocSummary.edocType}">
<input type="hidden" name="currContentNum" id="currContentNum" value="0">
<input type="hidden" name="affairId"  id="affairId" value="${affairId}">
<input type="hidden" name="isUniteSend" id="isUniteSend" value="${formModel.edocSummary.isunit}">
<input type="hidden" name="orgAccountId" id="orgAccountId" value="${formModel.edocSummary.orgAccountId}">
<%--记录日志的时候不能区别出是修改了文单还是仅仅修改了文号。加此变量就是为了区别这个 BUG30034--%>
<input type="hidden" name="isOnlyModifyWordNo" id="isOnlyModifyWordNo" value=true>
<input type="hidden" id="pushMessageMemberIds" name="pushMessageMemberIds" value="">
<input type="hidden" name="templeteId" id="templeteId" value="${formModel.edocSummary.templeteId}">

<input type="hidden" name="docMarkValue" id="docMarkValue" value ="${summary.docMark}">
<input type="hidden" name="docMark2Value" id="docMarkValue2" value ="${summary.docMark2}">
<input type="hidden" name="docInmarkValue" id="docInmarkValue" value ="${summary.serialNo}">
<input type="hidden" name="taohongriqiSwitch" id="taohongriqiSwitch" value ="${taohongriqiSwitch}">
<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" style="">
  <tr>
  <c:if test="${onlySeeContent=='false'}">
    <td id="slideTd1" class="body-left"><img src="javascript:void(0)" height="1" width="20px"></td>
  </c:if>
    <td>
    <div id="formAreaDiv" style="margin-top:20px;">
			
			<div style="display:none">
			<textarea id="xml" cols="40" rows="10">
				 ${formModel.xml}
         	</textarea>
         	</div>
         	<div style="display:none">
		   	<textarea id="xslt" cols="40" rows="10">   
				${formModel.xslt}
			</textarea>
		    </div>		 	
		 	<div id="html" name="html" style="height: auto;"></div>
		 	
		 	<div id="img" name="img" style="height:0px;"></div>	 
			<div style="display:none">
			<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea>
			</div>
		 	
	</div>

	<%--<div name="edocContentDiv" id="edocContentDiv" width="0px" height="0px" style="display:none">
		<input type="hidden" name="bodyContentId" value="${formModel.edocBody.id}">
		<v3x:showContent  htmlId="edoc-contentText" content="${formModel.edocBody.content}" type="${formModel.edocBody.contentType}" createDate="${formModel.edocBody.createTime}" contentName="${formModel.edocBody.contentName}" viewMode ="edit"/>
		<script>editType="4,0"</script>
	</div>--%>	
	
	
	</td>
	<c:if test="${onlySeeContent=='false'}">
    <td id="slideTd2" class="body-right"><img src="javascript:void(0)" height="1" width="20px"></td>
    </c:if>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="body-buttom-left"><img src="javascript:void(0)" height="1"></td>
    <td class="body-buttom-line"><img src="javascript:void(0)" height="1"></td>
    <td class="body-buttom-right"><img src="javascript:void(0)" height="1"></td>
  </tr>
</table>
</form>

<!-- 发起人附言 -->
<div id="colOpinion">
<c:if test="${senderOpinion ne null || fn:length(senderOpinion) > 0 || isSender}">
<table align="center" width="800px" border="0" cellspacing="0" cellpadding="0"  id="printSenderOpinionsTable" style="margin-bottom:10px;">
  <tr>
    <td class="body-detail-border" id="senderOpinion">
    <hr style="width:100%;border-bottom:1px solid #a4a4a4;border-top:none;border-left:none;" size="1">
    	<div>
			<div class="body-detail-su" id="sendOpinionTitle" style="display: inline;"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /><fmt:message key="sender.note.label" /></div>
			<c:if test="${summary.finished == false && currentUserIsSender && (param.from eq 'Sent' || param.from eq 'Done' || param.from=='sended'||param.from=='Pending' ||param.from eq 'listSent') && (openFrom ne 'glwd') && (param.openFrom ne 'recRegisterResult' && param.openFrom ne 'sendRegisterResult')}">
				<div id="addSenderOpinionDiv" style="visibility:inherit;display:inline;float:right;" class="">
					<c:if test='${isTransFrom ne "transEvent"}'>
						<a id='newReplyButton' href="javascript:addReplySenderOpinion()" class="font-12px"><fmt:message key="sender.addnote.label"/></a>
					</c:if>
				</div>
			</c:if>
		</div>
		<div id="displaySenderOpinoinDiv" name="displaySenderOpinoinDiv">
			<c:forEach items="${senderOpinion}" var="opinion">
			<div style="width: 100%">
				<div class="optionContent1 wordbreak">
				<fmt:formatDate value="${opinion.createTime}" pattern="yyyy-MM-dd HH:mm"/>
				&nbsp;&nbsp;
				${v3x:toHTML(opinion.content)}
				<c:if test="${!empty opinion.proxyName}">
					<div class="opinion-agent">
						<fmt:message key="col.opinion.proxy">
							<fmt:param value="${opinion.proxyName}" />
						</fmt:message>
					</div>
				</c:if>
				</div>
				<%-- 附件 --%>
				<c:if test="${not empty senderOpinionAttStr[opinion.id]}"><%--xiangfan 添加判断条件 修复GOV-4936 --%>
				<div class="div-float attsContent" style="display: block" id="attsDiv${opinion.id}">
					<div class="atts-label">${attachmentLabel} :&nbsp;&nbsp;</div>
					${senderOpinionAttStr[opinion.id]}
				</div>
				</c:if>
				<div style="clear:both;">&nbsp;</div>
			</div>
			</c:forEach>
		</div>
		<%-- 用于存放本次发起人附言的内容 --%>
		<div id="replyDivsenderOpinionDIV"></div>
		<c:if test="${summary.finished == false && currentUserIsSender && (param.from eq 'Sent' || param.from eq 'Done' || param.from eq 'sended'||param.from eq'Pending'||param.from eq 'listSent')}">
		<%-- 发起人附言框位置 --%>
		<div class="comment-div div-float" style="display:none" id="replyDivsenderOpinion">
		<form name="repform" method="post" target="replyCommentIframe" action="<html:link renderURL='/edocController.do?method=doComment' />" onsubmit="return (checkReplyForm(this) &&dorepform()&& saveAttachment())" style="margin: 0px;">
		<input type="hidden" name="summaryId" value="${formModel.edocSummary.id}">
		<input type="hidden" name="opinionId" value="">
		<input type="hidden" name="startMemberId" value="${senderId}">
		<input type="hidden" name="memberId" value="">
		<input type="hidden" name="memberName" value="">
		<input type="hidden" name="isProxy" value="${isProxy}">
		<input type="hidden" name="affairId" value="${affairId}">
		
		<input type="hidden" name="isNoteAddOrReply" value="reply">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<textarea name="postscriptContent" id="postscriptContent"  cols="" rows="" style="width: 100%;height: 80px" class="font-12px" inputName="<fmt:message key='topic.reply.content.label' />" validate="notNull" maxSize="500"></textarea>
				</td>
			</tr>
			<tr>
				<td align="right" colspan="2">
					<span class="like-a font-12px" id="uploadAttachmentSpan" onclick="insertAttachment()"><fmt:message key="common.toolbar.insertAttachment.label" bundle="${v3xCommonI18N}" /></span>
					<label for="isSendMessage" class="font-12px">
						<input name="isSendMessage" type="checkbox" value="1" checked="checked">
						<fmt:message key="edoc.isSendMessage.label"/>
					</label>
					<input type="submit" name="b12" id="subbtton" class="button-default_emphasize" value="<fmt:message key='common.button.submit.label' bundle="${v3xCommonI18N}" />">
					<input type="button" name="b12" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" onclick="document.getElementById('postscriptContent').value='';document.getElementById('replyDivsenderOpinion').style.display='none';deleteAllAttachment(0);">
				</td>
			</tr>
			
			<tr id="attachmentTR" style="display:none;">
	      		<td nowrap="nowrap" height="18" class="font-12px" align='right'>
	      			<div class="div-float font-12px">${attachmentLabel}: (<span id="attachmentNumberDiv"></span>个)</div>
					<v3x:fileUpload /></td>
	      		<td valign="top">
	      		</td>
			</tr>
			
		</table>
		</form>
		</div>
		</c:if>
	</td>
  </tr>
  </table>
</c:if>
<%--显示未绑定公文元素的节点的处理意见 --%>
<table align="center" width="800px" border="0" cellspacing="0" cellpadding="0" id="printOtherOpinionsTable" <c:if test="${param.from eq'Pending' }">style="padding-top:40px"</c:if>>
	<tr id="dealOpinionTitleDiv" style="display:none">
		<td>
			<hr style="width:100%;border-bottom:1px solid #a4a4a4; border-top:none;border-left:none;" size="1">
			<div class="div-float">
				<div class="div-float body-detail-su"  id="dealOpinionTitle"><fmt:message key="edoc.element.comment"  /></div>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div  class="wordbreak" id="processOtherOpinions" name="processOtherOpinions"  style="display:none;"></div>
			<div  class="wordbreak" id="displayOtherOpinions" name="displayOtherOpinions" style="visibility:hidden;"></div>
		</td>
	</tr>
</table>
<iframe name="replyCommentIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<!-- 发起人附言 结束-->
</div>
<c:if test="${!empty param.firstPDFId}">
	<div name="edocContentDiv" id="edocContentDiv" style="width:100%;height:0px;overflow:hidden">
		<v3x:showContent  htmlId="edoc-contentText" content="${v3x:escapeJavascript(param.firstPDFId)}" type="${'Pdf'}" createDate="${summary.firstBody.createTime}" contentName="${summary.firstBody.contentName}" viewMode ="edit"/>
	</div>
</c:if>
<script>
//GOV-4683 公文管理-发文管理，人员收到待办公文后，点击进入公文，页面刚刚加载完提交按钮后，快速点击提交，报2个脚本错误
//edocSummary.jsp先加载时将提交、暂存待办、回退、终止按钮置灰，不能点击，当该页面加载完后再让提交按钮可以点击
if(parent.document.getElementById("processButton")){
	parent.document.getElementById("processButton").disabled="";
}

if(parent.document.getElementById("zcdbButton")){
	parent.document.getElementById("zcdbButton").disabled="";
}

if(parent.document.getElementById("stepBackSpan")){
	parent.document.getElementById("stepBackSpan").disabled="";
}

if(parent.document.getElementById("stepStopSpan")){
	parent.document.getElementById("stepStopSpan").disabled="";
}

</script>
</body>
</html>
