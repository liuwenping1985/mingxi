<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<html:link renderURL="/doc.do" var="detailURL" />
<html:link renderURL="/doc.do" psml="default-page.psml" forcePortal="true" var="detailPortalURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colDetailURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL="/newsData.do" var="newsURL" />
<html:link renderURL="/bulData.do" var="bulURL" />
<html:link renderURL="/plan.do" var="planURL" />
<html:link renderURL="/webmail.do" var="mailURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/inquirybasic.do" var="inquiryURL" />
<html:link renderURL="/docManager.do" var="managerURL" />
<html:link renderURL="/doc.do?method=xmlJsp" var="srcJURL" />
<html:link renderURL="/doc.do?method=listDocs" var="actionJURL" />
<html:link renderURL="/rssManager.do" var="rssURL" />
<html:link renderURL="/docSpace.do" var="spaceURL" />
<html:link renderURL="/infoDetailController.do" var="infoURL" />
<html:link renderURL="/infoStatController.do" var="infoStatURL" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<c:url value="/apps_res/doc/images/docIcon/" var="imgURL"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/property.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="dateTimePattern" bundle="${v3xCommonI18N}"/>

<script type="text/javascript">
var docjsshowlabel = "<fmt:message key='doc.menu.show.label'/>";
var docjshiddenlabel = "<fmt:message key='doc.menu.hidden.label'/>";
var dtb = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(new java.util.Date())%>";
var dte = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(com.seeyon.ctp.util.Datetimes.addDate(new java.util.Date(),180))%>";
var contpath = "${pageContext.request.contextPath}";

var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
var treeImgURL = "${imgURL}";
var jsURL = "${detailURL}";
var docURL = jsURL;
var jsColURL = "${colDetailURL}";
var jsMeetingURL = "${mtMeetingURL}";
var jsPlanURL = "${planURL}";
var jsMailURL = "${mailURL}";
var jsNewsURL = "${newsURL}";
var jsBulURL = "${bulURL}";
var jsEdocURL = "${edocURL}";
var jsInquiryURL = "${inquiryURL}";
var managerURL="${managerURL}";
var spaceURL="${spaceURL}";
var infoURL="${infoURL}";
var infoStatURL="${infoStatURL}";
var baseurl = v3x.baseURL;
var srcURL = baseurl + "/doc.do?method=xmlJsp";
var actionURL = jsURL + "?method=listDocs";
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/doc/i18n");
v3x.loadLanguage("/common/pdf/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
<%-- ææ¡£åºç¨éç¶æå¸¸éå®ä¹ --%>
var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>"
</script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xmlextras.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xloadtree.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/xtree.css${v3x:resSuffix()}' />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/commonFuncs.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/controllerFuncs.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/property.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.add.title'/></title>
<style>
<!--
.bodyc{
	padding: 5px 0px 0px 10px;
}
//-->
</style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<style>
.link-blue-here{
	color:#1039b2;
	cursor: pointer;
	text-decoration:none;
}
</style>
<script type="text/javascript">
var from = "${from}${param.from}";

var contentSelect = "${contentTypeFlag}";
<!--	
	fileUploadAttachments.clear();

	function validate() {
		var i;
		var name = document.addDoc.docName.value;
		if((name == null) || (name.length == 0)) {
			return true;
		}
		for(i = 0; i < name.length; i++) {
			var c = name.charAt(i);
			if(whitespace.indexOf(c) == -1) {
				return false;
			}
		}			
		return true;
	}
	
	function doCancel() {
		self.history.back();
	}

	$(function(){
		$('select#contentTypeId').change(function() {
			var options = {
				url: '${detailURL}?method=changeContentType',
				params: {contentTypeId: $(this).val(),docResId:$('input#docResId').val(),oldCTypeId:$('input#oldCTypeId').val()},
				success: function(json) {
					$("div#extendDiv").html(json[0].htmlStr);
				}
			};
			getJetspeedJSON(options);
		});
	});
	
	function changeEve(val){
		// 目标文档夹有效性检查
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxHtmlUtil", "getNewHtml", false);
		requestCaller.addParameter(1, "long", val);
		var ret = requestCaller.serviceRequest();
		document.getElementById('extendDiv').innerHTML = ret;
	}	
	
	function _saveBtn(){
		if (from == "project"){
			addProDocument('${docLib.id}','${docLib.type}','${docResId}','${frType}','${bodyType}' , '${commentEnabled}', '${versionEnabled}', '${recommendEnable}', '${param.projectId}', '${param.projectPhaseId}');
		}else if(from=="docShare"){
			addDocument('${param.docLibId}','${param.docLibType}','${param.resId}','${param.frType}','${param.all}','${param.edit}','${param.add}','${param.readonly}','${param.browse}','${param.list}','${param.parentCommentEnabled}','${param.parentRecommendEnable}','${param.bodyType}', '${param.parentPath}', '${param.flag}', '${param.parentVersionEnabled}','addShareDocument');
		}else{
			addDocument('${param.docLibId}','${param.docLibType}','${param.resId}','${param.frType}','${param.all}','${param.edit}','${param.add}','${param.readonly}','${param.browse}','${param.list}','${param.parentCommentEnabled}','${param.parentRecommendEnable}','${param.bodyType}', '${param.parentPath}', '${param.flag}', '${param.parentVersionEnabled}');
		}
	}
	
	//帮助弹出窗口
	function showHelpDocAdd(menuId, menuItemId){
		var theHelpURL = getA8Top().contentFrame.topFrame.helpURL;
		if(menuId){
			theHelpURL += "?menuId="+menuId;
			if(menuItemId){
				theHelpURL += "&menuItemId="+menuItemId;
			}
		}
		v3x.openWindow({
			    url: theHelpURL,
			    width:"700",
			    height:"640",
			    scrollbars:"yes",
			    resizable:"yes"
		    });
	}
//-->
</script>
</head>
<body>
<div class="page2-list-border">
<form action="" name="addDoc" id="addDoc" method="post" onsubmit="return false" >
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0" >
<c:if test="${param.personalShare!='true'}">
  <tr height="24">
  	<td  colspan="10" bgcolor="#EFEFEF">
  		<div class="body_location like-a" style="border-width:0 0 1px 0;">
			<fmt:message key="seeyon.top.nowLocation.label" bundle="${v3xMainI18N}" /> <span id="nowLocation"></span>
		</div>
		<script type="text/javascript">
			try{
				showLocation(null, "${v3x:_(pageContext, v3x:toHTML(parentDr.frName))}", "<fmt:message key='doc.jsp.add.title'/>");
			}
			catch(e){}
		</script>
  	</td>
  </tr>
  </c:if>
  <tr>
	<td rowspan="2"  width="6%" class="bg-summary" height="29" valign="center" >
		<div id="_saveBtn" onclick="_saveBtn();"  class="newbtn"  onmouseover="javascript:this.className='newbtn-over';" onmouseout="javascript:this.className='newbtn';"><fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' /></div>
	</td>
    <td colspan="10" valign="top" height="22">
		<script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
// 			if (from == "project"){
// 				myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />",  "addProDocument('${docLib.id}','${docLib.type}','${docResId}','${frType}','${bodyType}' , '${commentEnabled}', '${versionEnabled}', '${param.projectId}', '${param.projectPhaseId}');", [1,5], "", ""));	
// 			}else if(from=="docShare"){
// 			    myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />",  "addDocument('${param.docLibId}','${param.docLibType}','${param.resId}','${param.frType}','${param.all}','${param.edit}','${param.add}','${param.readonly}','${param.browse}','${param.list}','${param.parentCommentEnabled}','${param.bodyType}', '${param.parentPath}', '${param.flag}', '${param.parentVersionEnabled}','addShareDocument');",[1,5], "", ""));	
// 			}else{
// 			    myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />",  "addDocument('${param.docLibId}','${param.docLibType}','${param.resId}','${param.frType}','${param.all}','${param.edit}','${param.add}','${param.readonly}','${param.browse}','${param.list}','${param.parentCommentEnabled}','${param.bodyType}', '${param.parentPath}', '${param.flag}', '${param.parentVersionEnabled}');",[1,5], "", "")); 
// 			}
		
			var insert = new WebFXMenu;
			if(v3x.getBrowserFlag("hideMenu") == true){
				insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachmentAndActiveOcx()"));
			}
			insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocument('position1')"));
			myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
				
			document.write(myBar);	
		</script>
		</td>
	</tr>
	<tr class="bg-summary lest-shadow" height="30">
		<td width="4%" class="bg-summary"  valign="center" >
			&nbsp;&nbsp;&nbsp;<fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:
		</td>
		<td width="40%" class="bg-summary" >
		
		<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
		<input type="text" name="docName" id="docName" class="input-100per" maxSize="80" deaultValue="${defName}" validate="isDeaultValue,notNull,notSpecCharWithoutApos" inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" 
		value="<c:out value="${defName}" escapeXml="true" default='${defName}' />" ${v3x:outConditionExpression(readOnly, 'readonly', '')} onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/>		
		<input type="hidden" name="projectId" id="projectId" value="${param.projectId}"/>
		</td>		
<c:choose>
	<c:when test="${contentTypeFlag == 'true'}">
		<td width="8%" height="29" valign="center" align="right" class="bg-summary" ><fmt:message key='doclib.jsp.contenttype'/>:&nbsp;&nbsp;</td>
		<td colspan="6" class="bg-summary" >
			<select id="contentTypeId" name="contentTypeId"  class="input-50per" onchange="changeEve(this.value)">
				<c:forEach items="${contentTypes}" var="contentType">
					<option value='${contentType.id}'>${v3x:toHTML(v3x:_(pageContext, contentType.name))}</option>
				</c:forEach>
			</select>
		</td>
	</c:when>
	<c:otherwise>
		<td colspan="6" class="bg-summary" >&nbsp;</td>
	</c:otherwise>
</c:choose>
		<td align="center" width="10%" class="bg-summary" >
    	<div onclick="editDocProperties('0');" id="advanceButton" class="cursor-hand"><fmt:message key='doc.jsp.properties.label.advanced'/></div>
		</td>
	</tr>


  <tr id="attachment2TR" class="bg-summary" style="display:none;">
	  <td></td>
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="9" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>):<div id="attachment2Area"></div></div>
						<div class="comp" comp="type:'assdoc',attachmentTrId:'position1', modids:'1,3'" attsdata='${attachmentsJSON}'>
           				</div></td>
  </tr>
  <tr id="attachmentTR" class="bg-summary" style="display:none;">
  		<td></td>
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="9" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>):</div>
		<v3x:fileUpload   applicationCategory="3" />
      </td>
  </tr>
	
<tr id="doclink" class="bg-summary" style="display:none;">
		<input type="hidden" name="sourceId" id="sourceId"/>
		<input type="hidden" name="currentNumber" id="currentNumber"
			value="${docLinkVoSize}" />
		<input type="hidden" name="delDocLinkId" id="delDocLinkId" value="" />
		<input type="hidden" name="addDocLink" id="addDocLink"/>
		<td></td>
		<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key='doc.jsp.open.label.rel'/>:&nbsp;&nbsp;</td>

		<td colspan="9" valign="top">
		<div class="div-float">(<span id="allDocLinkNumber"></span>)</div>
		<script>
      		<c:if test="${docLinkVoSize > 0 }">
      			var _allDocLinkNumber=document.getElementById("allDocLinkNumber").innerHTML='${docLinkVoSize}';
      			document.getElementById("doclink").style.display="";
      		</c:if>
      </script> <span id="initSpan"><c:forEach var="doclinkVo" items="${docLinkVo }">
			<span id="doclink_${doclinkVo.docResource.id }"> <img
				src="/seeyon/apps_res/doc/images/docIcon/${doclinkVo.icon}" /> <a
				href="javascript:void(null)">${doclinkVo.name}</a> <img
				src="/seeyon/common/images/attachmentICON/delete.gif"
				onclick="deleteDocLink('doclink_${doclinkVo.docResource.id}','${ doclinkVo.docResource.frName}','${doclinkVo.docResource.id}')" />
			</span>

		</c:forEach></span> <span id="addNew"></span></td>
	</tr>

	<tr>
  		<td colspan="10" height="6" class="bg-b"></td>
	</tr>

	<tr valign="top">
		<td colspan="10"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr valign="top">
			<td><c:choose>
			  	<c:when test="${v3x:getBrowserFlagByUser('HtmlEditer', v3x:currentUser())==true}">
			  		<v3x:editor htmlId="content" barType="Basic" createDate="<%=new Date()%>" type="${param.bodyType}"  category="<%=ApplicationCategoryEnum.doc.getKey()%>" />
			  	</c:when>
			  	<c:otherwise>
			  		<textarea id="content" name="content" style="height: 100%;width: 100%"></textarea>
			  		<input type='hidden' name='bodyType' id='bodyType' value='HTML'>
					<input type="hidden" name="bodyCreateDate" id="bodyCreateDate" value="">
					<input id="contentNameId" type="hidden" name="contentName" value="">	
			  	</c:otherwise>
			  </c:choose></td>
		</tr></table></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td><div id="contentDiv" style="display:none">
		<table width="95%" border="0" cellspacing="0" align="center" cellpadding="2"
							  style="word-break:break-all;word-wrap:break-word">
			<tr>
				<td align="right" width="23%" valign="top"><fmt:message key='doc.metadata.def.keywords'/>:</td><td width="2%">&nbsp;</td>
				<td valign="top"><input type="text" id="keyword" name="keyword" size="52" value="${v3x:toHTML(docEditVo.docResource.keyWords)}"
				maxSize="80" validate="maxLength" inputName="<fmt:message key='doc.metadata.def.keywords'/>"
				></td>
			</tr>
			<tr>
				<td align="right" width="23%" valign="top"><fmt:message key='doc.metadata.def.desc'/>:</td><td width="2%">&nbsp;</td>
				<td valign="top"><textarea id="description" name="description" rows="4" cols="54" 
				maxSize="80" validate="maxLength" inputName="<fmt:message key='doc.metadata.def.desc'/>"
				>${v3x:toHTML(docEditVo.docResource.frDesc)}</textarea></td>
			</tr>
		</table>
	</div>
	</td>
	</tr>	
	<tr><td><div id="extendDiv" style="display:none">${html}</div></td></tr>				
</table>
</form>
<iframe name="docFrame" id="docFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
<iframe name="docEditIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
</div>
</body>
</html>