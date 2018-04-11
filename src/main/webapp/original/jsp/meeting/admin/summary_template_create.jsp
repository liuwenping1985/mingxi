<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<title>
		<c:if test="${bean.id!=null}"><fmt:message key="common.toolbar.edit.label" bundle='${v3xCommonI18N}'/></c:if><c:if test="${bean.id==null}"><fmt:message key="common.toolbar.new.label" bundle='${v3xCommonI18N}'/></c:if><fmt:message key="mt.mtSummaryTemplate" />
	</title>
	<%@ include file="../include/header.jsp" %>
	

</head>
<body scroll='no'>
<script type="text/javascript">
		function chanageBodyTypeExt(type){
			if(chanageBodyType(type))
			  $('templateFormat').value=type;
		}
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	    	
    	//var bodyTypeSelector = new WebFXMenu;
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_HTML", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_HTML%>');", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_OfficeWord", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>');", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_OfficeExcel", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>');", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsWord", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
		//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsExcel", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>"));
		    	
		//myBar.add(new WebFXMenuButton("draft", "<fmt:message key='oper.draft' />", "send()", "<c:url value='/common/images/toolbar/send.gif'/>", "", null));
    	myBar.add(new WebFXMenuButton("submit", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "if($('dataForm').onsubmit()){saveAttachment();meetingSaveOffice(); $('dataForm').submit();}", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));    	   	    	
    	if(v3x.getBrowserFlag('hideMenu')){
 			myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
    	}
    	//myBar.add(new WebFXMenuButton("bodyTypeSelector", "<fmt:message key='common.body.type.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/bodyTypeSelector.gif'/>", "", bodyTypeSelector));
    	//myBar.add(new WebFXMenuButton("return", "<fmt:message key='oper.return' />", "history.go(-1);", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));
    	function saveSummary(obj){
	    	var parentObj = window.dialogArguments;
	    	if(checkForm(obj)){
	    			isFormSumit = true;
	    			saveAttachment();
					meetingSaveOffice();
					if(parentObj){
					    obj.target="hiddeniframe";
						window.close();
						obj.submit();
	    			}else{
	    				obj.submit();
	    			}
	    		}
    	}
    	//document.write(myBar);
    	//document.close();
</script>

    	
<div class="newDiv">
<form id="dataForm" name="dataForm" action="${mtSummaryTemplateURL}" method="post" onsubmit="saveSummary(this)">
<input type="hidden" name="fisearch" value="${fisearch}" />
<input type="hidden" name="method" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="meetingId" value="${bean.meetingId}" />
<input type="hidden" name="templateFormat" id="templateFormat" value="${bean.templateFormat}" />
<input type="hidden" name="fromdoc"  value="${param.fromdoc}" />

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="10">
				<script type="text/javascript">document.write(myBar);document.close();</script>
			</td>
		</tr>
		<tr><td height="10" class="detail-summary">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
		<tr class="bg-summary lest-shadow">
			<td class="bg-gray" width="10%"><fmt:message key="mt.mtSummaryTemplate.templateName" /><fmt:message key="label.colon" /></td>
			<td class="value" colspan="3" width="90%">
				<input type="text" class="input-100per" maxlength="50" maxSize="50" name="templateName" inputName="<fmt:message key="mt.mtSummaryTemplate.templateName" />" validate="notNull,maxLength" value="${bean.templateName}" />
			</td>
		</tr>
		<!--  描述去掉
		<tr class="bg-summary">
			<td class="bg-gray" width="10%"><fmt:message key="common.description.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td class="value" colspan="3" width="90%">
				<input type="text" class="input-100per" maxSize="200" inputName="<fmt:message key="common.description.label" bundle="${v3xCommonI18N}" />" validate="maxLength" name="description" value="${bean.description}"/>
			</td>
		</tr>
		-->
		<tr id="attachmentTR" style="display:none;" class="bg-summary">

			<td class="bg-gray" width="10%"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td class="value" colspan="3" width="90%">
				<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
				<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="${canDeleteOriginalAtts}" />
			</td>
		</tr>
		</table></td></tr>
		<tr>
  			<td colspan="9" height="6" class="bg-b"></td>
 		</tr>
		<tr>
			<td>
				<v3x:editor htmlId="content" content="${bean.content}" type="${bean.templateFormat}" createDate="${bean.createDate}" category="<%=ApplicationCategoryEnum.meeting.getKey()%>" />
			</td>
		</tr>
	</table>

</form>
<iframe width="100%" height="100%" name="hiddeniframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>	
</div>

<c:if test="${null!=exception}">
<script type="text/javascript">
<!--
	alert("${exception.message}");
//-->
</script>
</c:if>
</body>
</html> 