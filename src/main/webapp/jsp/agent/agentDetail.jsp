<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="header.jsp"%>
<script type="text/javascript">

window.onload = function(){
	document.getElementById("surrogate").disabled = "false";
	document.getElementById("beginDate").disabled = "false";
	document.getElementById("endDate").disabled = "false";
	document.getElementById("dateTd").onclick = "false";
	document.getElementById("surrogate").value = "${agentName}";
	document.getElementById("beginDate").value = "<fmt:formatDate value='${agent.startDate}' pattern='yyyy-MM-dd HH:mm'/>";
	document.getElementById("endDate").value = "<fmt:formatDate value='${agent.endDate}' pattern='yyyy-MM-dd HH:mm'/>";
	if("${hasEdoc}" == "true"){
		document.getElementById("edoc").checked = true;
	}
	if("${hasMeeting}" == "true"){
		document.getElementById("meeting").checked = true;
	}
	if("${hasInfo}" == "true"){
		document.getElementById("govinfo").checked = true; 
	}
	if("${hasPubAudit}" == "true"){
		document.getElementById("audit").checked = true;
	}
	//显示自由流程
	if("${hasCol}" == "true"){
		document.getElementById("freecoll").checked = true;
	}
	var template = document.getElementById("template");
	var templateSelect = document.getElementById("templateSelect");
	//显示“全部”
	if("${hasTemplate}" == "true"){
	    template.checked = true;
		templateSelect.checked = true;
	}
		
	var templateIds = document.getElementById("templateIds");
	//显示已选择的模板
	if("${hasTemplate}" == "true" && templateIds && templateIds.value){
	    template.checked = true;
		var option = document.createElement("OPTION");
		option.text = "${names}";
		option.selected = true;
		templateSelect.add(option);
		templateSelect.title="${names}";
	}
	templateSelect.disabled=true;
		
	if(template.checked==false){
		document.getElementById("templateSpan").style.display="none";
	}
	
	if("${hasOffice}" == "true"){
        document.getElementById("office").checked = true;
    }
	
	var agentOptionTD = document.getElementById("agentOptionTD");
	var agentOptionObj = agentOptionTD.getElementsByTagName("INPUT");
    for(var i=0; i<agentOptionObj.length; i++){
        if(agentOptionObj[i].getAttribute('type') == 'checkbox'){
            agentOptionObj[i].disabled = true;
        }
    }
}

</script>
</head>
<body scroll="no" style="overflow: no">
<form id="showAgentForm" method="post" target="showAgentFrame" action="" onsubmit="return false">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
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
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="agent.setting" bundle="${agentI18N}" /></td>
					<td class="categorySet-2" width="7"> </td>
					<td class="categorySet-head-space">&nbsp</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" align="center">
			<div class="categorySet-body">
			<%@include file="agentform.jsp"%>
			</div>		
		</td>
	</tr>
</table>
</form>
<iframe name="showAgentFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>
