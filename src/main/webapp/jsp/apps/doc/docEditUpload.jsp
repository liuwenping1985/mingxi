<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
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

<c:url value="/apps_res/doc/images/docIcon/" var="imgURL"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/property.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="dateTimePattern" bundle="${v3xCommonI18N}"/>

<script type="text/javascript">
var docjsshowlabel = "<fmt:message key='doc.menu.show.label'/>";
var docjshiddenlabel = "<fmt:message key='doc.menu.hidden.label'/>";
var dtb = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(new java.util.Date())%>";
var dte = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(com.seeyon.v3x.util.Datetimes.addDate(new java.util.Date(),60))%>";
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
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}"/>"></script>
<title><fmt:message key='doc.jsp.add.title.edit'/></title>
<html:link renderURL="/doc.do" var="detailURL" />
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<script type="text/javascript" language="javascript">			

var jsURL = "${detailURL}";
	var whitespace = " \t\n\r";
	var fileReplaceFlag = false;
	
	var oldName = "<c:out value='${docEditVo.docResource.frName}' escapeXml='true' />";
	
	function propertiesChanged() {
		
	}
	
	function validate() {
		var i;
		var name = document.myform.docName.value;
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

	function saveIt(isFile, canEditOnline) {
	
		var count = 0;
		var size = fileUploadAttachments.size();
		var keys = fileUploadAttachments.keys();	
		for(var i = 0; i < size; i++){
			var att = fileUploadAttachments.get(keys.get(i), null);
			if(att.type == 0){
				count++;
			}
		}							
		disableDocButtons('true');
		if(!checkForm(myform)){
			enableDocButtons('true');
			return;
		}
		var docResId = document.getElementById("docResId").value;
		var newName = document.myform.docName.value.escapeHTML();
		if(newName && oldName != newName){		
			var exist = dupliName('${docEditVo.docResource.parentFrId}', newName, '${docEditVo.docResource.frType}', false);
			if('true' == exist){
				alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert', newName));
				enableDocButtons('true');
				document.myform.docName.focus();
				return;
			}
		}
			if (isFile == "false") {
				if (!saveOffice()) {
					enableDocButtons('true');
					return ;
				}
			} else if("true" == canEditOnline){
				if (!saveOffice('true')) {
					enableDocButtons('true');
					return ;
				}
			} else {
				if(fileReplaceFlag){	
					var count = 0;
					var size = fileUploadAttachments.size();
					var keys = fileUploadAttachments.keys();	
					for(var i = 0; i < size; i++){
						var att = fileUploadAttachments.get(keys.get(i), null);
						if(att.type == 0){
							count++;
						}
					}							
					if(count == 0) {	
						alert(v3x.getMessage("DocLang.doc_edit_file_replace_upload_alert"));
						enableDocButtons('true');
						return;						
					}else{	
						// 对于上传文件需要替换的情况，在saveAttachment()之前，将替换的文件提取出来，另行处理

						for(var i = 0; i < keys.size(); i++){
							var att = fileUploadAttachments.get(keys.get(i), null);
							if(att.type == 0){
								if("${v3x:toHTML(docEditVo.file.filename)}" != att.filename){
									if(!window.confirm(v3x.getMessage('DocLang.doc_replace_different_name_confirm'))){										
										deleteAttachment(att.fileUrl, false);
										enableDocButtons('true');
										return;
									}
									//alert('${docEditVo.docResource.parentFrId}' + "----" + att.filename + "----" + '${docEditVo.docResource.frType}');	
									var exist = dupliName('${docEditVo.docResource.parentFrId}', att.filename, '${docEditVo.docResource.frType}', false);
									if('true' == exist){
										alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert', att.filename));
										deleteAttachment(att.fileUrl, false);
										enableDocButtons('true');
										return;
									}
								}	
							
								var fileInput = myAttToInput(att);
								document.getElementById("fileReplaceDiv").innerHTML = fileInput;
								deleteAttachment(att.fileUrl, false);
								break;
							}
						}
					
					}
				}
			}

			isFormSumit = true;
			
			saveAttachment(); 
			myform.action = myform.action + "&fileReplaceFlag=" + fileReplaceFlag;			
			myform.submit();			
		//}
	}
	
	// 上传文件的替换处理，生成页面元素
	function myAttToInput(att){
		var str = "";
		str += "<input type='hidden' name='file_id' value='" + att.id + "'>";
		str += "<input type='hidden' name='file_reference' value='" + att.reference + "'>";
		str += "<input type='hidden' name='file_subReference' value='" + att.subReference + "'>";
		str += "<input type='hidden' name='file_category' value='" + att.category + "'>";
		str += "<input type='hidden' name='file_type' value='" + att.type + "'>";
		str += "<input type='hidden' name='file_filename' value='" + escapeStringToHTML(att.filename) + "'>";
		str += "<input type='hidden' name='file_mimeType' value='" + att.mimeType + "'>";
		str += "<input type='hidden' name='file_createDate' value='" + att.createDate + "'>";
		str += "<input type='hidden' name='file_size' value='" + att.size + "'>";
		str += "<input type='hidden' name='file_fileUrl' value='" + att.fileUrl + "'>";
		str += "<input type='hidden' name='file_description' value='" + att.description + "'>";
		str += "<input type='hidden' name='file_needClone' value='" + att.needClone + "'>";
		document.getElementById("docName").value = escapeStringToHTML(att.filename) ;
		
		return str;
	}
	
	function backDocAdd(){		
		myform.action = "${detailURL}?method=cancelModifyDoc&docResId=${docEditVo.docResource.id}";
		myfrom.submit();
	}

	function docDownLoad(fileId,fileName,theDate) {
		docFrame.document.location="/seeyon/fileUpload.do?method=download&fileId="+fileId+"&createDate="+theDate+"&filename="+encodeURI(fileName);

	}

	function changeUploadFile() {
		var btn = document.getElementById("uploadBtn");
		if (myform.fileAction[1].checked ) {
			// 替换
			fileReplaceFlag = true;
			btn.disabled = "";		
			
			// 如果已经上传过，保存fileUrl
			var size = fileUploadAttachments.size();
			var keys=fileUploadAttachments.keys();	
			var oldFileUrl = '';			
			if(size > 0) {				
				for(var i = 0; i < size; i++){
					var att = fileUploadAttachments.get(keys.get(i), null);
					if(att.type == 0){
						oldFileUrl = att.fileUrl;
						break;
					}
				}				
			}
			
			// 上传
			insertAttachment();
			// 遍历，判断type == 0 的size，如果超过1个，删除老的
			var count = 0;
			size = fileUploadAttachments.size();
			keys = fileUploadAttachments.keys();	
			for(var i = 0; i < size; i++){
				var att = fileUploadAttachments.get(keys.get(i), null);
				if(att.type == 0){
					count++;
				}
			}	
			if(count > 1){
				deleteAttachment(oldFileUrl, false);
			}

			
		} else {
			fileReplaceFlag = false;
			btn.disabled = "disabled";
			var size = fileUploadAttachments.size();
			var keys=fileUploadAttachments.keys();
		}
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
	
 function  choseContentType(){
	  var choseObj = document.getElementById('contentTypeId2') ;
	 if(choseObj) {
		    var docResId = document.getElementById('docResId').value ;
		    var selectValue = choseObj.options[choseObj.selectedIndex].value 
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "checkDocResourceIsSystem", false);
			requestCaller.addParameter(1, "String", selectValue);
			requestCaller.addParameter(2, "String", docResId) ;
			  var requestCaller = new XMLHttpRequestCaller(this, "ajaxHtmlUtil",
			 "getNewHtml", false);
		      requestCaller.addParameter(1, "long", selectValue);				
		      var ret = requestCaller.serviceRequest();		
		      document.getElementById('extendDiv').innerHTML = ret;
			var isSystem = requestCaller.serviceRequest(); 
			if(isSystem == 'true') {
				  var button1 = document.getElementById("button1");
				  if(button1) {
				      button1.disabled = true ;
				  }
			}else{
				  var button1 = document.getElementById("button1");
				  if(button1) {
				      button1.disabled = false ;
				  }			
			}
			
		 	    
	  }
	}
//-->
</script>
</head>
<body scroll="no" onunload="unlockAfterAction('${param.docResId}');">
<form name="myform" method="post" action="${detailURL}?method=modifyDoc" target="docFrame" >
<v3x:attachmentDefine attachments="${docEditVo.attachments}" />
<input type="hidden" name="docResId" id="docResId" value="${docEditVo.docResource.id}"/>
<input type="hidden" name="docLibType" value="${param.docLibType}"/>	
<input type="hidden" name="oldCTypeId" value="${docEditVo.docResource.frType}">
<input type="text" class="hidden" id="contentTypeId" id="contentTypeId" value="${docEditVo.docResource.frType}">
<input type="hidden" name="fileId" value="${docEditVo.file.id}"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">
	<tr>
		<td class="PopupTitle" colspan="3">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><fmt:message key='doc.jsp.add.title.edit'/></td>
					<td width="30"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="15">&nbsp;</td>
		<td>
			<div class="scrollList">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" class="padding5"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:</td>
					<td><fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" /><input type="text" name="docName" id="docName" class="input-100per" maxSize="80" deaultValue="${defName}"  validate="isDeaultValue,notNull,notSpecCharWithoutApos" inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" value="<c:out value="${docEditVo.name}" escapeXml="true" default='${defName}' />" ${v3x:outConditionExpression(readOnly, 'readonly', '')} onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/></td>
				</tr>
				<tr>
				<c:choose>
					<c:when test="${contentTypeFlag == 'true'}">
						<td align="right"><fmt:message key='doclib.jsp.contenttype'/>:&nbsp;&nbsp;</td>
						<td>
							<select id="contentTypeId2" name="contentTypeId" class="input-100per" onchange="choseContentType()">
								<c:forEach items="${contentTypes}" var="contentType">
									<option id="Opt${contentType.id}" value='${contentType.id}' <c:if test='${contentType.id==docEditVo.docResource.frType}'>selected</c:if>>
										${v3x:_(pageContext, contentType.name)}						
										<script type="text/javascript">
											var opt = document.getElementById("Opt${contentType.id}");
											//alert(opt)
											opt.style.color = 'black';
										</script>
															
								</c:forEach>
							</select>
						</td>
					</c:when>
					<c:otherwise>
						<td colspan="2">
						<input type="text" class="hidden" id="contentTypeId" id="contentTypeId" value="${docEditVo.docResource.frType}">
						</td>
					</c:otherwise>
				</c:choose>
				</tr>
				
				
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
				<c:if test="${docEditVo.isFile == true}">
				<c:if test="${docEditVo.canEditOnline == false}">
				<tr height="30">
					<td width="30"></td>
					<td><label for="fileAction0"><input type="radio" id="fileAction0" name="fileAction" value="0" onclick="changeUploadFile();" checked><fmt:message key='doc.jsp.edit.file.hold'/></label></td>
				</tr>
				<tr height="30">
					<td width="30"></td>
					<td><label for="fileAction2"><input type="radio" id="fileAction2" name="fileAction" onclick="changeUploadFile();" value="2"><fmt:message key='doc.jsp.edit.file.replace'/></label>
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="<fmt:message key='doc.jsp.edit.file.upload'/>" onclick="changeUploadFile()" id="uploadBtn" disabled />
					</td>
				</tr>
				<tr id="attachmentTR"  style="display:none;">
			      <td nowrap="nowrap" height="18" class="" valign="top" id="temp"></td>
			      <td valign="top">
					<v3x:fileUpload applicationCategory="3"  attachments="${docEditVo.attachments}" />
					<script>
						var fileUploadQuantity = 1;
					</script>
			      </td>
				</tr>
						
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right" class="padding5"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
					<td>
						<div class="comp" comp="type:'assdoc',attachmentTrId:'position1', modids:'1,3'" attsdata='${attachmentsJSON}'>
           					<input type="button" onclick="quoteDocument('position1')" value="关联文档">
           				</div>
					 <div id="attachment2Area"></div>
					</td>
				</tr>
				</c:if>
				</c:if>
				<tr><td></td><td>&nbsp;</td></tr>
				<tr>
					<td></td>
					<td><input type="button"  onclick="editDocProperties('0');" value="<fmt:message key='doc.jsp.properties.label.advanced'/>"/></td>
				</tr>
				</table>
				</div>
		</td>
		<td width="15">&nbsp;</td>
	</tr>
	<tr>
		<td height="41" class="bg-advance-bottom" align="right" colspan="3">
			<input type="button" class="button-default_emphasize" id="button1" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" onClick="saveIt('${docEditVo.isFile}','${docEditVo.canEditOnline}')"/>
			<input type="button" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" onClick="cancelOk({'page':'close'})"/>
		</td>
	</tr>
</table>
<%@include file="docEdit_properties.jsp" %>
</form>
<iframe name="docFrame" id="docFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
</body>
</html>
