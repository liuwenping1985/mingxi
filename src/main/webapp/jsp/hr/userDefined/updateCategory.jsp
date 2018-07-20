<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<c:set var="dis" value="${v3x:outConditionExpression(disabled, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(readonly, 'readOnly', '')}" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
	function mm(){
		var mmm=document.categoryForm.memo.value.length;
		var name=document.categoryForm.name.value.length;
		  if(mmm>100){
	        alert(v3x.getMessage("HRLang.hr_userDefined_remark_notexcess"));
		    return false;
		    }else if(name>100) {
		    	alert(v3x.getMessage("HRLang.hr_userDefined_sort_notexcess"));
		   	    return false;
		    }else{
		    	return true;
		    }  
	}

	function submitForm(){
		document.getElementById("b1").disabled = true;
	    var propertyForm = document.getElementById("categoryForm");
	    if(!(checkForm(propertyForm) && mm())){
	    	document.getElementById("b1").disabled = false;
	        return;
	    }
		propertyForm.submit();
	}
//-->
</script>
</head>
<body scroll="no" style="overflow: no">
<form id="categoryForm" name="categoryForm" action="${hrUserDefined}?method=updateCategory&settingType=${param.settingType}" method="post" target="hiddenIframe">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak();  
		</script>
		</td>
	</tr>
	<tr>
		<td class="">
        <input type="hidden" name="id" value="${category.id}" />
    						
								<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
									
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="name"><font color="red">*&nbsp;</font><fmt:message key="hr.userDefined.category.name.label" bundle="${v3xHRI18N}"/>:</label></td>
										<td class="new-column" width="75%">
											<input type="text" class="input-100per" name="name" ${dis} value="${v3x:toHTML(category.name)}" validate="notNull" inputName="<fmt:message key="hr.userDefined.category.name.label" bundle="${v3xHRI18N}" />" ${ro} } />
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap" valign="top" ><label for="memo"><fmt:message key="hr.record.remark.label" bundle="${v3xHRI18N}"/>:</label></td>
										<td class="new-column" width="75%">
										<textarea class="input-100per" name="memo" maxSize="70" validate="maxLength" inputName="<fmt:message key='hr.record.remark.label' bundle='${v3xHRI18N}'/>" id="memo" rows="6" ${dis}>${v3x:toHTML(category.memo)}</textarea>
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