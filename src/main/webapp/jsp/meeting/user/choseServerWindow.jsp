<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp"%>
<head>
<fmt:setBundle basename="com.seeyon.v3x.meeting.resources.i18n.MeetingResources" var="v3xMtMeetingI18n"/>
<title><fmt:message key="oper.please.selectserver" bundle="${v3xMtMeetingI18n}"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
function showSendResult(){
	var returnMsg =  $('selectServerSelect').value;
	window.returnValue = returnMsg;
	window.close();
}

function getServerList() {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtMeetingManager", "getMeetingServerList", false);
		var ds = requestCaller.serviceRequest();	   
		if(ds != null && ds!=""){
			for(var i = 0; i < ds.length; i++){
				var d = ds[i];
				$('selectServerSelect').add(new Option(d[1],d[0]));
			}
		}
		
		if(document.getElementById("selectServerSelect").value.length==0){
		    showSendResult();
		}else{
			document.getElementById("selectServerSelect").options[0].selected ="true";
		}
}
		
</script>
</head>
<body onload="getServerList()">
	<table class="sort manage-stat-1" width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
	      <tr height="20%" border="0">
	      	<td>
	      	 &nbsp;
			</td>
			<td>
	      	 &nbsp;
			</td>
	      </tr>
	      <tr height="40%">
	      	<td width="100%">
	      	    <select id="selectServerSelect" name="selectServerSelect" align="center">
				</select>
			</td>
			<td>
	      	 &nbsp;
			</td>
	      </tr>
		  <tr height="40%">
		    <td width="100%" align="center">
           		<input type="button" id="ok" name="ok" value="<fmt:message key='oper.ok' bundle='${v3xMtMeetingI18n}'/>"  class="button-default-2" onclick="showSendResult()">
            	&nbsp;&nbsp;&nbsp;
            	<input type="button" id="cancel" name="cancel" value="<fmt:message key='oper.cancel' bundle='${v3xMtMeetingI18n}'/>"  class="button-default-2" onclick="window.close()">
		    </td>
		  </tr>
		</table>

</body>