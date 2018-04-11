<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
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
<form id="propertyForm" name="propertyForm" action="${hrUserDefined}?method=addOption&settingType=${param.settingType}" method="post" target="hiddenIframe">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
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
		  						
								<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="propertyName"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.option.name.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<input type="text" class="input-100per" name="propertyName" value="" validate="notNull" maxlength="20" inputName="<fmt:message key="hr.userDefined.option.name.label" bundle="${v3xHRI18N}" />" />
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="propertyLabel_en"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.name.english.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<input type="text" class="input-100per" id="propertyLabel_en" name="propertyLabel_en" value="" validate="notNull" maxlength="30" inputName="<fmt:message key="hr.userDefined.name.english.label" bundle="${v3xHRI18N}" />" />
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="type"><fmt:message key="hr.userDefined.type.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<select name="type" id="type" class="input-100per">
												<option value="1"><fmt:message key="hr.userDefined.type.integer.label" bundle="${v3xHRI18N}" /></option>
												<option value="2"><fmt:message key="hr.userDefined.type.float.label" bundle="${v3xHRI18N}" /></option>
												<option value="3"><fmt:message key="hr.userDefined.type.date.label" bundle="${v3xHRI18N}" /></option>
												<option value="4"><fmt:message key="hr.userDefined.type.varchar.label" bundle="${v3xHRI18N}" /></option>
												<option value="5"><fmt:message key="hr.userDefined.type.text.label" bundle="${v3xHRI18N}" /></option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="notNull"><fmt:message key="hr.userDefined.notNull.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<select name="notNull" id="notNull" class="input-100per">
												<option value="0"><fmt:message key="hr.userDefined.yes.label" bundle="${v3xHRI18N}" /></option>
												<option value="1"><fmt:message key="hr.userDefined.no.label" bundle="${v3xHRI18N}" /></option>												
											</select>											
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="category"><fmt:message key="hr.userDefined.option.category.label" bundle="${v3xHRI18N}" />:</label></td>
										<td class="new-column" width="90%">
											<select name="categoryId" id="categoryId" class="input-100per">
												<c:forEach items="${categories}" var="category">
													<option value="${category.id}">${v3x:toHTML(category.name)}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
								</table>							
    			
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input id="b1" type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="reSet()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe name="hiddenIframe" id="hiddenIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>