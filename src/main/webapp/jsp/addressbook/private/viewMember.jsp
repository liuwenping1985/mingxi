<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<%@include file="../header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='addressbook.menu.public.label' bundle='${v3xAddressBookI18N}'/></title>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8"
	src="<c:url value='/apps_res/addressbook/js/private.js${v3x:resSuffix()}'/>">
</script>
<script type="text/javascript">
<!--
var addressBookUrl = '${addressbookURL}';
function submitEditForm(form){
	 if(checkForm(form)){
	 	//getA8Top().startProc(''); 
     	//document.getElementById("check").disabled = true;
     	//document.getElementById("submintCancel").disabled = true;
     	return true;
	 }
	 return false;
}
function OK(){
	var editForm = document.getElementById('editForm');
	if(submitEditForm(editForm)){
		editForm.submit();
	}
}
-->
</script>
</head>
<body scroll="no" style="overflow: no">
<c:set value="${empty param.edit && empty param.mId}" var="editFrame" />
<form  id="editForm" method="post" target="viewMemberHiddenFrame" action="${addressbookURL}?method=updateMember&addressbookType=2" onsubmit="return submitEditForm(this);">
	<input type="hidden" name="id" value="${member.id}" />
	<input type="hidden" name="isCreated" value="${isCreated }" />
	<c:set value="${empty param.edit && ! empty param.mId}" var="disabled"/>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
<%-- 
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	--%>
	
	<tr>
		<td height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="PopupTitle" nowrap="nowrap">
						<c:out value="${member.name}"></c:out>
					</td>
				</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body2">
				<%@include file="memberInfo.jsp"%>
			</div>		
		</td>
	</tr>

	<c:if test="${!readOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" id="check" name="check" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
			<input type="button" name="submintCancel" onclick="getA8Top().newMemberWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>
</form>
<iframe name="viewMemberHiddenFrame" width="0" height="0" frameborder="0"></iframe>
</body>
</html>