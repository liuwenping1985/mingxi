<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>请选择领导</title>
<script type="text/javascript"></script>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

var userIds = "Member|${curUser.id }";
var userNames = "${curUser.name }";

//选人界面回调函数
function setPeopleFields(elements) {
	userIds = "";
	userNames = "";
	for(var i=0; i<elements.length; i++) {		
		userIds += "Member|"+elements[i].id+",";
		userNames += elements[i].name+",";
	}
	$("input[@name='userIds']").val(userIds.substring(0, userIds.length-1));
	$("input[@name='userNames']").val(userNames.substring(0, userNames.length-1));
}	

function ok() {
	//是否有会议领导查阅权限
	if(!hasMeetingLeaderRight(leaderForm)) {return;}
	var runValue = new Array; 
	runValue[0] = userIds;
	runValue[1] = userNames;
	window.returnValue = runValue;
	window.close();
}


//是否有会议领导查阅权限
function hasMeetingLeaderRight(theForm) {
	var userIds = theForm.userIds.value;
	var orgAccountId = document.getElementById("orgAccountId").value;
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtMeetingManager", "hasMeetingLeaderRight", false);
	requestCaller.addParameter(1, "Long", orgAccountId); 
	requestCaller.addParameter(2, "String", userIds); 
	requestCaller.addParameter(3, "String", "v3x_meeting_create_acc_leadership"); 
	var ds = requestCaller.serviceRequest(); 
	if(ds!="true") {
	  	alert(_("meetingLang.alert_no_mt_leadLookRole", ds));
	    return false;
	}
	return true;	  
} 


</script>
</head>
<body>

<v3x:selectPeople id="leaderSelect" 
	panels="Department,Post,Team" 
	selectType="Department,Member,Post,Team" 
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
 	jsFunction="setPeopleFields(elements, 'detailIframe')" 
 	viewPage="" 
 	minSize="0" 
 	/>
	<form action="${controller }" name="leaderForm" onsubmit="">
		<input type="hidden" name="userIds" value="Member|${curUser.id }"/>
		<input type="hidden" id="orgAccountId" name="orgAccountId" value="${curUser.accountId }"/>
		
		<table valign="middle" align="center" style="background-color:#FFFFFF">
			<tr style="MIN-HEIGHT: 30px">
				<td colspan="2"></td>
			</tr>
			<tr style="MIN-HEIGHT: 30px">
				<td>
					<div><font color="#ff0000" size="2">领导：</font></div>
				</td>
				<td>
					<INPUT name="userNames" value="${curUser.name }" style="CURSOR: hand;width:300px " class=xdTextBox title="" readOnly />
					<a onclick="selectPeopleFun_leaderSelect();">选择</a>
				</td>
			</tr>
			<tr style="MIN-HEIGHT: 10px">
				<td colspan="2"></td>
			</tr>
			<tr>
			<td colspan="2" align="center">
				<input type="button" onClick="ok()" value="保存"/>&nbsp;&nbsp;
				<input type="button" onClick="window.close()" value="取消"/>
			</td>
		</tr>
		</table>
		
		
	
	</form>

	
</body>
</html>