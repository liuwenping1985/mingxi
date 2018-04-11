<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>
		<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /></c:if><fmt:message key="mt.mtContentTemplate" />
	</title>
	<%@ include file="../include/header.jsp" %>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	function setPeopleFields(elements){
		alert(elements);
	}
//-->
</script>

</head>
<body scroll='no'>
<script type="text/javascript">
		function chanageBodyTypeExt(type){
			if(chanageBodyType(type))
				dataForm.templateFormat.value = type;
			  $('templateFormat').value=type;
		}
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	    	
    	//var bodyTypeSelector = new WebFXMenu;
    //	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_HTML%>');", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
    //	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>');", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
    //	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>');", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
    //	bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsWord", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
	//	bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsExcel", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>"));
		    	
		//myBar.add(new WebFXMenuButton("draft", "<fmt:message key='oper.draft' />", "send()", "<c:url value='/common/images/toolbar/send.gif'/>", "", null));
    	myBar.add(new WebFXMenuButton("submit", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "if($('dataForm').onsubmit()){meetingSaveOffice(); isFormSumit = true;disableButtons();$('dataForm').submit();}", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));   	
    	    	
 		//myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
    	//myBar.add(new WebFXMenuButton("bodyTypeSelector", "<fmt:message key='common.body.type.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/bodyTypeSelector.gif'/>", "", bodyTypeSelector));

    	myBar.add(${v3x:bodyTypeSelector("v3x")});
		if(bodyTypeSelector){
			bodyTypeSelector.disabled("menu_bodytype_${bean.templateFormat}");//默认的置灰
		}
    	//myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "document.location.href='${mtContentTemplateURL}?method=listMain';", "<c:url value='/common/images/toolbar/back.gif'/>", "", null)); 
    	//document.write(myBar);
    	//document.close();
    	
    	function validate(){
    		if($('description').value== document.getElementById("valiName").value){
    			$('description').value="";
    			return false;
    		}
    	}
    	function disableButtons() {
		    disableButton("submit");
		    disableButton("bodyTypeSelector");
		    disableButton("return");
		}
</script>

    	
<div class="newDiv">
<form id="dataForm" name="dataForm" action="${mtContentTemplateURL}" method="post" onsubmit="return checkForm(this)">
<input type="hidden" name="method" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="templateFormat" id="templateFormat" value="${bean.templateFormat}" />
<fmt:message key="mt.mtContentTemplate.description" var="valiParam"/>
<fmt:message key="label.please.input" var="valiName">
	<fmt:param value="${valiParam}" />
</fmt:message>
<input type="hidden" id="valiname" value="${valiName}" >
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="22">
				<script type="text/javascript">document.write(myBar);</script>
			</td>
		</tr>
		<tr>
		<td height="10" class="detail-summary">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
		<tr class="bg-summary lest-shadow">
			<td width="10%" class="bg-gray"><fmt:message key="mt.mtSubject.label" /><fmt:message key="label.colon" /> </td>
			<td class="value">
			<fmt:message key="mt.mtSubject.label" var="_myLabel"/>
			<fmt:message key="label.please.input" var="_myLabelDefault">
				<fmt:param value="${_myLabel}" />
			</fmt:message>
			<input type="text" style="width: 400px" name="templateName"
				maxlength="20"
				value="<c:out value="${bean.templateName}" default="${_myLabelDefault}" escapeXml="true" />" 
				title="${bean.templateName}"
				deaultValue="${_myLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_myLabel}"
				maxSize="20"
				validate="isDeaultValue,notNull"
				${clearValue}
				/>
			</td>
	
		
		
			<td width="10%" class="bg-gray"><fmt:message key="mt.mtType.label" /><fmt:message key="label.colon" /></td>
			<!--    <td >
				<fmt:message key="mt.mtContentTemplate.description" var="_myLabel"/>
				<fmt:message key="label.please.input" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message>
				<input style="width: 700px" type="text" name="description"
					value="<c:out value="${bean.description}" default="${_myLabelDefault}" escapeXml="true" />" 
					title="${bean.description}"
					deaultValue="${_myLabelDefault}"
					onfocus="checkDefSubject(this, true)"
					onblur="checkDefSubject(this, false)"
					inputName="${_myLabel}"
					maxSize="300"
					validate="isDeaultValue"
					${clearValue}
					/>
			</td>			
		-->	
		  
			    <TD width="45%"><select name="type" style="font-size:12px;width:300;font:'瀹嬩綋'; height:20">
			      <option value="3" <c:if test="${bean.ext1=='3' || bean.ext2=='3'}"><c:out value="selected"></c:out></c:if>><fmt:message key="mt.mtBulletion"/></option>
			      <option value="4" <c:if test="${bean.ext1=='4' || bean.ext2=='4'}"><c:out value="selected"></c:out></c:if>><fmt:message key="mt.mtNews"/></option>
			    <c:if test="${!v3x:currentUser().groupAdmin}">
			      <option value="2" <c:if test="${bean.ext1=='2'}"><c:out value="selected"></c:out></c:if>><fmt:message key="mt.mtPlan"/></option>
			      <option value="1" <c:if test="${bean.ext1=='1'}"><c:out value="selected"></c:out></c:if>><fmt:message key="mt.mtMeeting"/></option>
			    </c:if>  
			      </select></TD>
			     <TD></TD>
		
		</tr>
		</table>
		</td>
		</tr>
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
</div>

<jsp:include page="../include/deal_exception.jsp" />

</body>
</html> 