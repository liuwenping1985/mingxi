<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../INC/noCache.jsp" %>
<head>
<%@ include file="../header.jsp" %>
<title><fmt:message key="selectPeople.page.title" /></title>
<script type="text/javascript">
<!--
function showOriginalDate(originalData){
	addElementsToList3(originalData);
}

function getIsCheckSelectedData(){
	return true;
}

function selected(){
	var data = null;	
	try{
		data = getSelectedPeoples();
	}
	catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}
	var  dv = window.dialogArguments.extendField;
	if(data[0]){	   
	   if(data[0].accountShortname	== null)
			dv.label = data[0].name;
		else
			dv.label = data[0].name + "(" + data[0].accountShortname + ")";
	    dv.value = data[0].id;	
		if(data[0].excludeChildDepartment){
			dv.excludeChildDepartment = data[0].excludeChildDepartment;
		}
	}else if(dv.label != "" ){
		dv.label = "" ;
		dv.value = "" ;
	}		
	window.close();
}
function OK(){
	var data = null;	
	try{
		data = getSelectedPeoples();
	}
	catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}
	
	return data;
}
//-->
</script>

<%@ include file="AbstractSelectPeople.jsp" %>
<c:if test="${v3x:getBrowserFlagByUser('SelectPeople', v3x:currentUser())==true}">
	<tr>
		<td height="50" class="bg-button-select" style="padding-right:30px;">
			<input name="Submit" type="button" onClick="selected()" class="button-default-2 button-onlyPeolel"
				value='<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />'>&nbsp;&nbsp;
			<input name="close" type="button" onclick="window.close()" class="button-default-2 button-onlyPeolel"
				value='<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" />'>
		</td>
	</tr>
</c:if>
</table>
</body>
</html>

