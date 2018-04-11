<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<c:set var="dis" value="${v3x:outConditionExpression(disabled, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(readonly, 'readOnly', '')}" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
	function submitForm(){
            document.getElementById("b1").disabled = true;
            var propertyForm = document.getElementById("propertyForm");
            if(!(checkForm(propertyForm) && valid('propertyLabel_en'))){
                document.getElementById("b1").disabled = false;
                return;
            }
            propertyForm.submit();
	}
//-->
</script>
</head>
<body scroll="no" style="overflow: no">
<form id="propertyForm" name="propertyForm" action="${hrUserDefined}?method=updateOption&settingType=${param.settingType}" method="post" target="hiddenIframe">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak();  
			</script>
		</td>
	</tr>
    <tr>
     <td class="categorySet-4" height="8"></td>
     </tr>
	<tr>
		<td >
                                   <input type="hidden"  name="id" value="${property.id}" />
    							<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
                               
									<tr>
									  <td class="bg-gray">
									    <div class="hr-blue-font"><strong><fmt:message key="hr.userDefined.option.info.label" bundle="${v3xHRI18N}" />&nbsp;&nbsp;</strong></div>
									  </td>
									  <td>&nbsp;</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="propertyName"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.option.name.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%"> 
											<input type="text" class="input-100per" name="propertyName" value="${v3x:toHTML(property.name)}" validate="notNull" maxlength="20" inputName="<fmt:message key="hr.userDefined.option.name.label" bundle="${v3xHRI18N}" />" ${ro} ${dis}/>
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="propertyLabel_en"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.name.english.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<input type="text" class="input-100per" id="propertyLabel_en" name="propertyLabel_en" value="${labelName_en}" validate="notNull" maxlength="30" inputName="<fmt:message key="hr.userDefined.name.english.label" bundle="${v3xHRI18N}" />" ${ro} ${dis}/>
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="type"><fmt:message key="hr.userDefined.type.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<input name="type" type="hidden" value="${property.type}">
											<input name="typeName" id="typeName" type="text" class="input-100per" readonly='true'  ${dis}
											<c:choose>
												<c:when test="${property.type == 1}">
													 value='<fmt:message key="hr.userDefined.type.integer.label" bundle="${v3xHRI18N}" />'
												</c:when>
												<c:when test="${property.type == 2}">
													value='<fmt:message key="hr.userDefined.type.float.label" bundle="${v3xHRI18N}" />'
												</c:when>
												<c:when test="${property.type == 3}">
													value='<fmt:message key="hr.userDefined.type.date.label" bundle="${v3xHRI18N}" />'
												</c:when>
												<c:when test="${property.type == 4}">
													value='<fmt:message key="hr.userDefined.type.varchar.label" bundle="${v3xHRI18N}" />'
												</c:when>
												<c:otherwise>
													value='<fmt:message key="hr.userDefined.type.text.label" bundle="${v3xHRI18N}" />'
												</c:otherwise>
											</c:choose>
											>
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="notNull"><fmt:message key="hr.userDefined.notNull.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<select name="notNull" id="notNull" class="input-100per" ${dis}>
											<c:choose>
												<c:when test="${property.not_null == 0}">
													<option value="0" selected><fmt:message key="hr.userDefined.yes.label" bundle="${v3xHRI18N}" /></option>
													<option value="1"><fmt:message key="hr.userDefined.no.label" bundle="${v3xHRI18N}" /></option>												
												</c:when>
												<c:otherwise>
													<option value="0"><fmt:message key="hr.userDefined.yes.label" bundle="${v3xHRI18N}" /></option>
													<option value="1" selected><fmt:message key="hr.userDefined.no.label" bundle="${v3xHRI18N}" /></option>												
												</c:otherwise>
												</c:choose>
											</select>
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="category"><fmt:message key="hr.userDefined.option.category.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<select name="categoryId" id="categoryId" class="input-100per" ${dis}>
												<c:forEach items="${categories}" var="category">
												<c:choose>
													<c:when test="${category.id == property.category_id}">
														<option value="${category.id}" selected>${v3x:toHTML(category.name)}</option>
													</c:when>
													<c:otherwise>
														<option value="${category.id}">${v3x:toHTML(category.name)}</option>
													</c:otherwise>
												</c:choose>
												</c:forEach>
											</select>
										</td>
									</tr>
								</table>							
    			
		</td>
	</tr>
	<c:choose>
	<c:when test="${!readonly}">
	<tr>
		<td height="42" align="center" class="page_color bg-advance-bottom">
			<input id="b1" type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="reSet()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:when>
	</c:choose>
</table>
</form>
<iframe name="hiddenIframe" id="hiddenIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>