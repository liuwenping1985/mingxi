<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<title>
		<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.edit.label' bundle="${v3xCommonI18N}" /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /></c:if><fmt:message key="bul.template" />
	</title>
	<%@ include file="../include/header.jsp" %>
	
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
  			$('templateFormat').value=type;
		}
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	    	
    	var bodyTypeSelector = new WebFXMenu;
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_HTML%>');", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>');", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>');", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
		bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>"));
    	    	
		//myBar.add(new WebFXMenuButton("draft", "<fmt:message key='oper.draft' />", "send()", "<c:url value='/common/images/toolbar/send.gif'/>", "", null));
    	myBar.add(new WebFXMenuButton("submit", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}'/>", "if($('dataForm').onsubmit()){saveOffice();  validate(); isFormSumit = true; $('dataForm').submit();}", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));
    	    	    	
 		//myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
    	myBar.add(new WebFXMenuButton("bodyTypeSelector", "<fmt:message key='common.body.type.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/bodyTypeSelector.gif'/>", "", bodyTypeSelector));
    	myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "location.href='${bulTemplateURL}?method=listMain';", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));    	
    	//document.write(myBar);
    	//document.close();
    	function validate(){
    		//alert($('description').value);
    		if($('description').value=="<点击此处填写版面描述>"||$('description').value=="<Please Click to Input Description>"){
    			$('description').value="";
    			return false;
    		}
    	}
</script>

    	
<div class="newDiv">
<form id="dataForm" name="dataForm" action="${bulTemplateURL}" method="post" onsubmit="return checkForm(this)">
<input type="hidden" name="method" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="templateFormat" id="templateFormat" value="${bean.templateFormat}" />

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="10">
				<script type="text/javascript">document.write(myBar);</script>
			</td>
		</tr>
		<tr><td height="10" class="detail-summary"><table border="0" cellpadding="0" cellspacing="0" width="50%" align="left">
		<tr>
			<td class="label"><fmt:message key="bul.template.templateName" /><fmt:message key="label.colon" /></td>
			<td class="value" colspan="3">
				<jsp:include page="../include/inputDefine.jsp">
					<jsp:param name="_property" value="templateName" />
					<jsp:param name="_key" value="bul.template.templateName" />
					<jsp:param name="_validate" value="notNull,isDefaultValue" />
				</jsp:include>
			</td>
			<%-- 
			<td class="label"><fmt:message key="bul.template.usedFlag" /><fmt:message key="label.colon" /></td>
			<td class="value">		
				<label for="usedFlag1">	
					<input type="radio" id="usedFlag1" name="usedFlag" value="1" checked="true"/><fmt:message key="label.used" />
				</label>
				<label for="usedFlag0">	
					<input type="radio" id="usedFlag0" name="usedFlag" value="0" /><fmt:message key="label.noused" />
				</label>
				<script type="text/javascript">
					setRadioValue("usedFlag","<c:if test="${bean.usedFlag}">1</c:if><c:if test="${not bean.usedFlag}">0</c:if>");
				</script>
			</td>
			--%>
		</tr>
		<c:if test="${bean.id!=null}">
		<tr>
			
			<td class="label"><fmt:message key="bul.template.createDate" /><fmt:message key="label.colon" /></td>
			<td class="value"><fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/></td>
		</tr>
		</c:if>
		<tr>
			<td class="label">
				<fmt:message key="bul.template.description" /><fmt:message key="label.colon" />
			</td>
			<td class="value" colspan="3">			
				<jsp:include page="../include/inputDefine.jsp">
					<jsp:param name="_property" value="description" />
					<jsp:param name="_key" value="bul.template.description" />
				</jsp:include>
			</td>
		</tr>
		</table></td></tr>
		<tr>
			<td height="5" class="detail-summary-separator"></td>
		</tr>
		<tr>
			<td>
				<v3x:editor htmlId="content" content="${bean.content}" type="${bean.templateFormat}" createDate="${bean.createDate}" category="6" />
			</td>
		</tr>
	</table>

</form>
</div>

<jsp:include page="../include/deal_exception.jsp" />
</body>
</html> 