<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource" var="bulI18N"/>
<title><fmt:message key="bulletin.menu.move.label"  bundle='${bulI18N}'/></title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html:link renderURL="/inquirybasic.do" var="detailURL" />
${v3x:skin()}
<script type="text/javascript" >
function OK(){
	var theForm = document.getElementsByName("sendForm")[0];
	    if (!theForm) {
	        return false;
	    }
	var selectedArr = document.getElementsByName("typeName");
 	var selectedValue = null;
 	var selectedType = null;
	for(var i=0; i<selectedArr.length; i++){
		if(selectedArr[i].checked == true){
			selectedValue = selectedArr[i].value;
			selectedType = selectedArr[i].getAttribute("extAttribute1");
			break;
		}
	}
	theForm.action = "${detailURL}?method=moveToType&typeId="+selectedValue;
	theForm.target = "emptyIframe";
	theForm.submit();
	
}
function cancel(){
	transParams.parentWin.moveCollBack(false);
}
function cloWithSuccess(){
	transParams.parentWin.moveCollBack(true);
}
</script>

</head>
<body scroll='no' onkeydown="listenerKeyESC()" id="typeBody" style="overflow: hidden;">
<form name="sendForm" action="" method="post" >
<input type="hidden" value="moveToType" name="method">
<input type="hidden" id="ids" name="ids" value="${ids}"/>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
		<td class="bg-advance-middel">
			<div style="border: solid 1px #666666;overflow:auto;height:265 ;background-color:rgb(255, 255, 255)" id="listDiv">
				<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
					<thead>
					<tr class="sort">
						<td type="String" colspan="2"><fmt:message key="space.name" bundle='${v3xCommonI18N}' /></td>
					</tr>
					</thead>
					<tbody>
						<c:forEach items="${typeList}" var="typeData">
						<tr class="sort" align="left">
							<td align="center" class="sort" width="5%">
								<input type="radio" name="typeName" value="${typeData.id}" extAttribute1="${typeData.accountId}"/>
							</td>
							<td class="sort" type="String">
								${v3x:toHTML(typeData.typeName)}
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</td>
 </tr>
 <tr>
		<td height="28" align="right" class="bg-advance-bottom" colspan="2">
			<input type="button" onclick="OK()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe id="emptyIframeId" name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript" >

$(document).ready(function() { 
	$('#listDiv').height($('#typeBody').height()-100);
	$('input:radio:first').attr("checked",'checked');
}); 
</script>
</body>
</html>