<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head> 
<%@include file="../exchangeHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	function doIt(){
		if(!checkForm(detailForm))
			return;
		
		//-- justify whether the name of justification is null or not 
		//var name = document.getElementById("name");

		/*if(name==null || name.value==""){
			alert(v3x.getMessage("ExchangeLang.outter_unit_name_input_error"));
			return false;
		}*/
		//-- justification end.
		detailForm.submit();			
	}
//-->	
</script>
</head>
<body>

<form name="detailForm" action="${exchangeEdoc}?method=addExchangeAccount" method="post">

<div class="newDiv">

<table width="100%" height="100%" border="0" bordercolor="red" cellspacing="0" cellpadding="0" align="center" class="categorySet-bg">
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
	<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="120" nowrap="nowrap"><fmt:message key='exchange.account.add' /></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
	</td>
</tr>

<tr valign="middle">
	<td width="100%" valign="middle" id="categorySetTd" class="categorySet-head">  
  		<div id="categorySetBody" class="categorySet-body" style="padding:0;border-bottom:1px solid #a0a0a0;">	   
  		
			<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr >
			    <td width="80%">    	
					<table width="60%" border="0" cellspacing="0" cellpadding="2" align="center">
					<tr><td colspan="2" height="10px">&nbsp;</td></tr>
					<tr>
						<td class="bg-gray" width="30%"><font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:</td>		
						<td class="new-column">
							<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
							<input name="name" type="text" id="name" class="input-100per" deaultValue="${defName}" inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />"
							validate="isDeaultValue,notNull,isWord" character=",|" maxSize="50" value="<c:out value="${account.name}" escapeXml="true"  default='${defName}' />"
							${v3x:outConditionExpression(readOnly, 'readonly', '')} onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/>		
						</td>
					</tr>
					<tr>
						<td class="bg-gray" valign="top"><fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:</td>
						<td class="new-column" nowrap="nowrap">
								<textarea rows="5" name="description" id="description" class="input-100per" inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />" validate="maxLength" maxSize="80" >${account.description}</textarea>					
						</td>	
					</tr>
			        
			  		</table>	
					</td>
			  		</tr>
					<tr>
				</tr>
			</table>
		</div>
    </td>
</tr>
	
<tr>
	<td height="42" align="center" class="bg-advance-bottom">
       <input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="doIt();">
       &nbsp; 
       <input type="button" onclick="window.location.href='<c:url value='/common/detail.jsp'/>';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
    </td>
</tr>
   
</table>
</form>
</div>
</body>
</html>