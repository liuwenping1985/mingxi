<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp"%>
<title>Insert title here</title>
</head>
<script type="text/javascript">
showCtpLocation("F13_sysSecurityLog");
function doIt(){
	var usersValue = document.getElementById("users").value;
	var startDay = document.getElementById("startDay").value;
	var endDay = document.getElementById("endDay").value;
	
	if(startDay != "" && endDay != ""){
		if(compareDate(startDay,endDay)>0){
			alert(v3x.getMessage("LogLang.log_search_overtime"))		
			return false;
		}
	}else{
		alert(v3x.getMessage("LogLang.log_time_not_null"))		
		return false;
	}
	document.getElementById('userName').disabled=true;
	form1.target = "listIframe";
	form1.action = "${logonLog}?method=onlineTimeStat&show=list";
	document.getElementById("oldUsers").value = document.getElementById("users").value;
	document.getElementById("oldStartDay").value = document.getElementById("startDay").value;
	document.getElementById("oldEndDay").value = document.getElementById("endDay").value;
	var objs = document.getElementsByName("desc"); 
	for(var i=0; i<objs.length; i++){
		if(objs[i].checked){
			document.getElementById("oldDesc").value = objs[i].value;
			break;
		} 
	} 
	form1.submit();
	document.getElementById('userName').disabled=false;
}

function showDetail(userId){
	var startDay = form1.startDay.value;
	var endDay = form1.endDay.value;
	v3x.openWindow({
        url: logonLog + "?method=detailListMain&userId=" + userId + "&startDay=" + startDay + "&endDay=" + endDay,
        height: 400,
        width: 750,
        resizable:'no'
    });
}

function export2Excel(){
	form1.target = "targetFrame";
	form1.action = "${logonLog}?method=exportOnlineTimeToExcel"
	form1.submit();
}

function popprint() {
	var printContentBody = "";
	var cssList = new ArrayList();
	
	var pl = new ArrayList();
	var contentBody = "" ;
	var contentBodyFrag = "" ;
	
	contentBody = window.frames["listIframe"].document.getElementById("dataList").innerHTML;
	
	cssList.add("/seeyon/common/skin/default/skin.css");
	
	contentBodyFrag = new PrintFragment(printContentBody, contentBody);
	pl.add(contentBodyFrag);
	printList(pl,cssList);
}

</script>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
<%@include file="labelPage.jsp"%>
<tr>
	<td height="20" style="border-right: solid 1px #A4A4A4;">
		<script>	
			var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
			myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "javascript:export2Excel()", [2,6], "", null));
			myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:popprint()", [1,8], "", null));
			document.write(myBar);
			document.close();
		</script>
	</td>
</tr>
<tr>
	<td class="page-list-border-LRD" valign="top">
	<form method="post" id="form1" action="${logonLog}?method=onlineTimeStat&show=list">
		<c:set value="${v3x:parseElementsOfIds(param.users, 'Member')}"	var="userIds" />
		<v3x:selectPeople id="user" originalElements="${userIds }" panels="Department,Outworker,Admin" selectType="Member,Admin"
			jsFunction="showUser(elements,'${systemFlag}' )" minSize="0" maxSize="80"/>
		<input type="hidden" name="users" id="users" value="${param.users}" />
		<input type="hidden" name="oldUsers" id="oldUsers" value="" />
		<input type="hidden" name="oldStartDay" id="oldStartDay" value="" />
		<input type="hidden" name="oldEndDay" id="oldEndDay" value="" />
		<input type="hidden" name="oldDesc" id="oldDesc" value="" />
		<table>
			<tr>
				<td width="100" rowspan="3" align="right" class="lest-shadow"><b><fmt:message key="logon.templete.branch.search.label" />:</b></td>
				<td width="100" align="right"><fmt:message key="logon.search.selectPeople" />:</td>
				<td width="280"><input type="text" id="userName" class="cursor-hand" name="userName" onclick="selectPeopleFun_user()" value="${param.userName }" readonly="readonly"></td>
				<td rowspan="3" class="padding-L">
				<input type="button" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="doIt()"></td>				
			</tr>
			<tr>		
				<td align="right"><fmt:message key="logon.search.selectTime"/>:</td>
				<td><input type="text" class="cursor-hand" name="startDay" id="startDay" value="${startDay}" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true"> <fmt:message key="logon.search.to"/> <input type="text" class="cursor-hand" name="endDay" id="endDay" value="${endDay }" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true"></td>
			</tr>
			<tr>
				<td align="right"><fmt:message key="logon.search.order" />:</td>
				<td>
				<label for="desc1"><input type="radio" id="desc1" name="desc" value="0" ${param.desc!='1'?"checked":"" }><fmt:message key="logon.search.order.max" /></label>
				<label for="desc2"><input id="desc2" name="desc" value="1" type="radio" ${param.desc=='1'?"checked":"" }><fmt:message key="logon.search.order.min" /></label>
				</td>
			</tr>
		</table>
	</form>
</td>
</tr>
<tr>
	<td class="page-list-border-LRD" height="100%" valign="top" style="padding: 0">
		<iframe id="listIframe" name="listIframe" frameborder="0" src="${logonLog}?method=onlineTimeStat&show=list" width="100%" height="100%"></iframe>
	</td>
</tr>
</table>
<iframe id="targetFrame" name="targetFrame" width="0" height="0"></iframe>
</body>
</html>