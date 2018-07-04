<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<style>
<!--
.bodyc{
	padding: 5px 0px 0px 10px;
}
.bg-summary {
	background-color: #ededed;
}
//-->
</style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key='doc.jsp.add.title.edit'/></title>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<script type="text/javascript" language="javascript">			
<!--	
	var whitespace = " \t\n\r";
	var fileReplaceFlag = false;
	var versionEnabled = ${docEditVo.docResource.versionEnabled}
	
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
	/** 对上传类型的wps进行备份*/
	function copyWPS(){
		var sourceId = '${sourceId}';
		var requestCaller = new XMLHttpRequestCaller(this, "fileManager",
		 "copyWPS", false);
		requestCaller.addParameter(1, "Long", sourceId);
			
		requestCaller.serviceRequest();
	}
	//保存office正文的时候是否
	var needInsertToV3XFile = "true";
	function saveIt(isFile, canEditOnline) {
		disableDocButtons('true');
		if(!checkForm(myform)){
			enableDocButtons('true');
			if(V3X.checkFormAdvanceAttribute=="docAdvance"){
				editDocProperties('${docEditVo.docResource.id}');
			}
			return;
		}
		var newName = document.myform.docName.value.escapeHTML();
		if(newName && oldName != newName){		
			var exist = dupliName('${docEditVo.docResource.parentFrId}', document.myform.docName.value, document.myform.contentTypeId.value, false);
			if('true' == exist){
				alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert', newName));
				enableDocButtons('true');
				document.myform.docName.focus();
				return;
			}
		}
		var sampleToComFlag = "";
			if (isFile == "false") {
				if (!saveOffice()) {
					enableDocButtons('true');
					return ;
				}
			} else if("true" == canEditOnline){
				var mimeTypeId = '${mimeTypeId}';
				//当是WPS类型的上传文档时，进行手动备份
				if(mimeTypeId == '120' || mimeTypeId == '121'){
					copyWPS();
				}
				if (!saveOffice('${docEditVo.docResource.versionEnabled}')) {
					enableDocButtons('true');
					return ;
				}
				sampleToComFlag = "&isFile="+isFile+"&canEditOnline="+canEditOnline;
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
								// 是否同名上传替换 
								if("${v3x:toHTML(docEditVo.file.filename)}" != att.filename){
									if(!window.confirm(v3x.getMessage('DocLang.doc_replace_different_name_confirm'))){
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
			myform.action = myform.action + sampleToComFlag + "&fileReplaceFlag=" + fileReplaceFlag + (versionEnabled ? ('&originalFileId=' + originalFileId + '&fileId=' + fileId) : '');
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
			// 删除原来的replaceFile，如果有的话
			for(var i = 0; i < size; i++){
				var att = fileUploadAttachments.get(keys.get(i), null);
				if(att.type == 0){
					deleteAttachment(att.fileUrl, false);
					break;
				}
			}	
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
//-->
</script>
</head>
<body scroll="no" onunload="unlockAfterAction('${param.docResId}');">
<form name="myform" method="post" action="${detailURL}?method=modifyDoc" target="docFrame" >
<v3x:attachmentDefine attachments="${docEditVo.attachments}" />
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td colspan="9" valign="top" height="22">
<script type="text/javascript">
	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "saveIt('${docEditVo.isFile}','${docEditVo.canEditOnline}');", "<c:url value='/common/images/toolbar/save.gif'/>"));
	var insert = new WebFXMenu;
	<c:if test="${docEditVo.isFile == false}">
		insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachmentAndActiveOcx()"));
	</c:if>
	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocument()"));
	myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
	document.write(myBar);	
</script>
	</td>
</tr>
	<input type="hidden" name="docResId" value="${docEditVo.docResource.id}"/>
	<input type="hidden" name="docLibType" value="${param.docLibType}"/>	
	<input type="hidden" name="oldCTypeId" value="${docEditVo.docResource.frType}">
	<tr class="bg-summary lest-shadow" height="30">
		<td width="8%" height="29" valign="center" align="right"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;</td>
		<td width="42%"><fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
		<input type="text" name="docName" id="docName" class="input-100per" maxSize="80" deaultValue="${defName}"  validate="isDeaultValue,notNull,notSpecCharWithoutApos" inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" value="<c:out value='${docEditVo.name}' escapeXml='true' default='${defName}' />" ${v3x:outConditionExpression(readOnly, 'readonly', '')} onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/></td>
<c:choose>
	<c:when test="${contentTypeFlag == 'true'}">
		<td width="8%" height="29" valign="center" align="right"><fmt:message key='doclib.jsp.contenttype'/>:&nbsp;&nbsp;</td>
		<td colspan="5">
			<select id="contentTypeId" name="contentTypeId" class="input-50per">
				<c:forEach items="${contentTypes}" var="contentType">
					<option id="Opt${contentType.id}" value='${contentType.id}' ${contentType.id==docEditVo.docResource.frType? 'selected':''}>
						${v3x:toHTML(v3x:_(pageContext, contentType.name))}						
						<script type="text/javascript">
							var opt = document.getElementById("Opt${contentType.id}");
							opt.style.color = 'black';
						</script>
					</option>				
				</c:forEach>
			</select>
		</td>
	</c:when>
	<c:otherwise>
		<td colspan="6">&nbsp;
		<input type="text" class="hidden" id="contentTypeId" id="contentTypeId" value="${docEditVo.docResource.frType}">
		</td>
	</c:otherwise>
</c:choose>
		<td align="center" width="10%">
    	<div onclick="editDocProperties('${docEditVo.docResource.id}');" id="advanceButton" class="cursor-hand"><fmt:message key='doc.jsp.properties.label.advanced'/></div>
		</td>
	</tr>
	
<c:if test="${docEditVo.isFile == false}">
  <tr id="attachment2TR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="8" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
      <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
  </tr>

	<tr id="attachmentTR" class="bg-summary" style="display:none;">
		<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message
			key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
		<td colspan="8" valign="top">
		<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
		<v3x:fileUpload  applicationCategory="3"  attachments="${docEditVo.attachments}" /></td>
	</tr>

	<tr valign="top">
		<td colspan="9"><v3x:editor htmlId="content" originalNeedClone="${docEditVo.docResource.versionEnabled}" content="${docEditVo.content}" type="${docEditVo.bodyType}" createDate="${docEditVo.createDate}" category="<%=ApplicationCategoryEnum.collaboration.getKey()%>" /></td>
	</tr> 
</c:if>

<c:if test="${docEditVo.isFile == true}">
	<c:if test="${docEditVo.canEditOnline == false}">
  <tr id="attachment2TR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="8" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
      <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
  </tr>

	<tr>
		<td colspan="9">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" valign="top">

			<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doc.jsp.edit.file.label'/></strong></legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height="30">
					<td colspan="2">&nbsp;</td>	
				</tr>
				<tr height="30">
					<td width="30"></td>
					<td>
					<c:set value="${v3x:escapeJavascript(docEditVo.file.filename)}" var="theFilename"/>
					<a id="aDownload" href="###" onclick="docDownLoad('${docEditVo.file.id}','${theFilename}','${docEditVo.createDateString}')" class="font-12px"><c:out value="${docEditVo.file.filename}" escapeXml="true"/></a></td>
				</tr>
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
			      <td nowrap="nowrap" height="18" class="bg-gray" valign="top" id="temp"></td>
			      <td valign="top">
					<v3x:fileUpload applicationCategory="3"  attachments="${docEditVo.attachments}" />
					<script>
						var fileUploadQuantity = 1;
					</script>
			      </td>
				</tr>
				
				<tr height="30">
					<td colspan="2">&nbsp;</td>	
				</tr>
				
			</table>	
			</fieldset>
		</td>
	</tr> 
	</c:if>
	<c:if test="${docEditVo.canEditOnline == true}">
	<tr id="attachment2TR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="8" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
      <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
  	</tr>
  
	<tr valign="top">
		<td colspan="9"><v3x:editor htmlId="content" originalNeedClone="${docEditVo.docResource.versionEnabled}" content="${docEditVo.content}" type="${docEditVo.bodyType}" createDate="${docEditVo.createDate}" category="<%=ApplicationCategoryEnum.collaboration.getKey()%>" /></td>
	</tr> 
	
	<tr id="attachmentTR"  style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top" id="temp"></td>
      <td valign="top">
		<v3x:fileUpload applicationCategory="3"  attachments="${docEditVo.attachments}" />
		<script>
			var fileUploadQuantity = 1;
		</script>
      </td>
	</tr>
	</c:if>
</c:if>
<c:if test="${docEditVo.isFile == true && docEditVo.canEditOnline == false}">
	<div style="display: none;">
		<v3x:editor htmlId="empE"  />
	</div>	
</c:if>
</table>
<%@include file="docEdit_properties.jsp" %>
</form>
<iframe name="docFrame" id="docFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>

</body>
</html>