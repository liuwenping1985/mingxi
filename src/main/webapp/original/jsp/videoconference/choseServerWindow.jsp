<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="head.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="oper.please.selectserver" bundle="${v3xVideoconf}"/></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
function showSendResult(){
	var returnMsg =  $('selectServerSelect').value;
	window.returnValue = returnMsg;
	window.close();
}

function getServerList(){
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxVideoConferenceManager", "getMeetingServerList", false);
		var ds = requestCaller.serviceRequest();	      
		if(ds != null && ds!=""){
			for(var i = 0; i < ds.length; i++){
				var d = ds[i];
				if (d[0] == "top") {
					$('selectServerSelect').add(new Option(d[1],d[0]));
				}
			}
			for(var i = 0; i < ds.length; i++){
				var d = ds[i];
				if (d[0] != "top") {
					$('selectServerSelect').add(new Option(d[1],d[0]));
				}
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
           		<input type="button" id="ok" name="ok" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>"  class="button-default-2" onclick="showSendResult()">
            	&nbsp;&nbsp;&nbsp;
            	<input type="button" id="cancel" name="cancel" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>"  class="button-default-2" onclick="window.close()">
		    </td>
		  </tr>
		</table>

</body>