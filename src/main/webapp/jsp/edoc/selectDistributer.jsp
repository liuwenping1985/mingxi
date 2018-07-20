<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>请选择分发人</title>
<script type="text/javascript"></script>
<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/register.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

var distributerId = "${curUser.id }";
var distributer = "${curUser.name }";

//选人界面回调函数
function setPeopleFields(elements) {
	for(var i=0; i<elements.length; i++) {		
		distributerId = elements[i].id;
		distributer = elements[i].name;
	}
	$("input[@name='distributerId']").val(distributerId);
	$("input[@name='distributer']").val(distributer);
}	

function ok() {

	//检查分发人员是否有分发权限
	if(!isEdocDistribute(distributerForm)) {return;}

	var runValue = new Array; 
	runValue[0] = distributerId;
	runValue[1] = distributer;
	window.returnValue = runValue;
	window.close();

}



</script>
</head>
<body style="overflow:hidden;">

<v3x:selectPeople id="distributerSelect" 
	panels="Department,Post,Team" 
	selectType="Department,Member,Post,Team" 
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
 	jsFunction="setPeopleFields(elements, 'detailIframe')" 
 	viewPage="" 
 	minSize="0" 
 	maxSize="1" 
 	/>
	<form action="${controller }" name="distributerForm" onsubmit="return isEdocDistribute(registerForm)">
		<input type="hidden" name="distributerId" value="${curUser.id }"/>
		<input type="hidden" id="orgAccountId" name="orgAccountId" value="${curUser.accountId }"/>
		<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="20" class="PopupTitle"><fmt:message key='edoc.select.distribution'/>
		</td>
			</tr>
			<tr>
		<td class="bg-advance-middel">
		<table valign="middle" align="center">
			<tr style="MIN-HEIGHT: 30px">
				<td>
					<div><font color="#ff0000" size="2"><fmt:message key="edoc.element.receive.distributer" /></font></div>
				</td>
				<td>
					<INPUT name="distributer" value="${curUser.name }" style="CURSOR: hand" class=xdTextBox title="" readOnly />
					<a onclick="selectPeopleFun_distributerSelect();"><fmt:message key="exchange.edoc.staffselect" bundle="${exchangeI18N }"/></a>
				</td>
			</tr>
			<tr style="MIN-HEIGHT: 10px">
				<td colspan="2"></td>
			</tr>
		</table>
	</td>
		</tr>
		<tr>
				<td height="42" align="right" class="bg-advance-bottom">
					<input type="button" onClick="ok()" value="<fmt:message key='modifyBody.save.label'/>" class="button-default_emphasize" />
					<input type="button" onClick="window.close()" class="button-default-2" value="<fmt:message key='edoc.form.button.cancel'/>" />
				</td>
				</td>
			</tr>
		</table>
		
	
	</form>

	
</body>
</html>