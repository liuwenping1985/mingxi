<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="header.jsp"%>
<html style=" height:100% ">
<head>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
var startDate = "";
var lastSelectIndex;

window.onload = function(){
	var freecoll = document.getElementById("freecoll");
	var templateSelect = document.getElementById("templateSelect");
	var templateIds = document.getElementById("templateIds");
	var template = document.getElementById("template");
	var edoc = document.getElementById("edoc");
	var meeting = document.getElementById("meeting");
	var govinfo = document.getElementById("govinfo");
	var audit = document.getElementById("audit");
	var office = document.getElementById("office");
	if("${operationType}" == "modify"){
		document.getElementById("surrogate").value = "${agentName}";
		document.getElementById("surrogateValue").value = "${agent.agentId}";
		
		if("${hasEdoc}" == "true"){
            edoc.checked = true;
        }
		
		if("${hasMeeting}" == "true"){
		    meeting.checked = true;
        }
		
		if("${hasInfo}" == "true"){
		    govinfo.checked = true;
        }
		
		if("${hasPubAudit}" == "true"){
		    audit.checked = true;
        }
		//显示自由流程
		if("${hasCol}" == "true"){
			freecoll.checked = true;
		}
		
		//显示“全部”
		if("${hasTemplate}" == "true"){
		    template.checked = true;
			templateSelect.checked = true;
		}
		
		//显示已选择的模板
		if("${hasTemplate}" == "true" && templateIds && templateIds.value && templateIds.value != "2"){
			template.checked = true;
			var option = document.createElement("OPTION");
			option.text = "${names}";
			option.value = "${ids}";
			option.selected = true;
			templateSelect.add(option);
		}
		
		if(template.checked==false){
			document.getElementById("templateSpan").style.display="none";
		}
		
		if("${hasOffice}" == "true"){
		    office.checked = true;
        }
	}else{
		var isEnableTemplate = "${v3x:hasPlugin('template') || v3x:hasPlugin('form')}";
		if(isEnableTemplate == "true"){
	    	template.checked = true;
		}
		
		var isEnableEdoc = "${ (v3x:hasPlugin('edoc')) && (v3x:getSysFlagByName('edoc_notShow') == 'false')}";
		if(isEnableEdoc == "true"){
			edoc.checked = true;
		}
		var isEnableMeeting = "${v3x:hasPlugin('meeting')}";
		if(isEnableMeeting == "true"){
			meeting.checked = true;
		}
		var isEnableAudit = "${v3x:hasPlugin('bbs') || v3x:hasPlugin('news') || v3x:hasPlugin('bulletin') || v3x:hasPlugin('inquiry')}";
		if(isEnableAudit == "true"){
			audit.checked = true;
		}
		if(govinfo){
		    govinfo.checked = true;
		}
		var isEnableCol = "${v3x:hasPlugin('collaboration')}";
		if(isEnableCol == "true"){
			freecoll.checked = true;
		}
		templateSelect.checked = true;
		var isEnableOffice = "${v3x:hasPlugin('office')}";
        if(isEnableOffice == "true"){
            office.checked = true;
        }
	}
	lastSelectIndex = templateSelect.selectedIndex;
};

function dataToSurrogate(elements){
    if (!elements) {
        return;
    }
    var person = elements[0] || [];
    var surrogateName = person.name;
    var surrogateId = person.id;
    document.getElementById("surrogate").value = surrogateName;
    document.getElementById("surrogateValue").value = surrogateId;
}

function checkoutDate(){
	var beginDate = document.getElementById("beginDate").value;
	var endDate = document.getElementById("endDate").value;
	var days = endDate.substring(0,endDate.indexOf(" "));
	var hours = endDate.substring(endDate.indexOf(" "));
	var temp = days.split("-");
	var temp2 = hours.split(":");
	var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
	days = beginDate.substring(0,beginDate.indexOf(" "));
	hours = beginDate.substring(beginDate.indexOf(" "));
	temp = days.split("-");
	temp2 = hours.split(":");
	var d2 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
	if(d1.getTime()<=d2.getTime()){
		alert(v3x.getMessage("agentLang.agent_end_time_alert"));
		return false;
	}
	var now = new Date();
	if(d1.getTime()<now.getTime()){
		alert(v3x.getMessage("agentLang.agent_endtime_beforeNow"));
		return false;
	}
	return true;
	
	/*var requestCaller = new XMLHttpRequestCaller(this, "ajaxAgentIntercalateManager", "compareDate", false);
	requestCaller.addParameter(1, "String", beginDate);
	requestCaller.addParameter(2, "String", endDate);
	requestCaller.addParameter(3, "String", startDate);
	var rv = requestCaller.serviceRequest();
	if(!rv || rv == null){
		document.getElementById("beginTime").value = document.getElementById("beginDate").value;
		document.getElementById("endTime").value = document.getElementById("endDate").value;
		return;
	}else{
		var hintType = new Number(rv[0]);
		var alertStr = rv[1];
		if(hintType == 1){
			alert(alertStr);
			document.getElementById("beginDate").value = document.getElementById("beginTime").value;
			document.getElementById("endDate").value = document.getElementById("endTime").value;
		}else if(hintType == 2){
			alert(alertStr);
			document.getElementById("beginDate").value = document.getElementById("beginTime").value;
			document.getElementById("endDate").value = document.getElementById("endTime").value;
		}
	}*/
}
function selectedOption(){
	var agentOptionObject = document.getElementsByName("agentOption");
	var selectedStr = "";
	for(var i=0; i<agentOptionObject.length; i++){
		if(agentOptionObject[i].checked){
			selectedStr += agentOptionObject[i].value + ",";
		}
	}
	document.getElementById("appTypeStr").value = selectedStr;
}

function ok(from){
	var theForm = document.getElementById("newAgentForm");
	var agentId = document.getElementById("surrogateValue").value;
	var beginDate = document.getElementById("beginDate").value;
	var endDate = document.getElementById("endDate").value;
	var agentOptionTD = document.getElementById("agentOptionTD");
	var currentAgentId = document.getElementById("currentAgentId").value;
	var templateIds = document.getElementById("templateIds").value;
	var agentOptionObj = agentOptionTD.getElementsByTagName("INPUT");
	var templateSelect = document.getElementById("templateSelect");
	var template = document.getElementById("template");;
	var selectedValues = new Array();
	for(var i=0; i<agentOptionObj.length; i++){
		if(agentOptionObj[i].getAttribute('type') == 'checkbox' && agentOptionObj[i].checked){
			selectedValues.push(agentOptionObj[i].getAttribute("extvalue"));
		}
	}
	if(template.checked == true && templateSelect && templateSelect.selectedIndex!=0){
		if(templateIds == '<fmt:message key="templatecoll.select" bundle="${agentI18N}"/>'){
			$.alert("${ctp:i18n('template.templateJs.leastSelectTemplate')}");
			return;
		}
	}
	if(template.checked == false && templateIds == '<fmt:message key="templatecoll.select" bundle="${agentI18N}"/>'){
		document.getElementById("templateIds").value ="";
	}
	
	if(agentId == ""){
		alert(_("agentLang.agent_not_permit_null_alert"));
		return;
	}
	if(beginDate == "" || endDate==""){
		alert(_("agentLang.agent_deadline_not_null_alert"));
		return;
	}
	if(selectedValues.length == 0){
		alert(_("agentLang.agent_option_not_null_alert"));
		return;
	}
	if(!checkoutDate()){
		return;
	}
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxAgentIntercalateManager", "checkDataValidity", false);
	requestCaller.addParameter(1, "String", agentId);
	requestCaller.addParameter(2, "String", beginDate);
	requestCaller.addParameter(3, "String", endDate);
	requestCaller.addParameter(4, "String[]", selectedValues);
	requestCaller.addParameter(5, "String", currentAgentId);
	requestCaller.addParameter(6, "String", templateIds);
	var rv = requestCaller.serviceRequest();
	if(rv != null && rv != ""){
		alert(rv);
		return;
	}
	//var coll = document.getElementById("coll");
	//var templateSelect = document.getElementById("templateSelect");
	//if(coll && coll.checked && templateSelect && templateSelect.selectedIndex==0){
	//	document.getElementById("templateIds").value = 2;
	//}
	if(from == "new"){
		theForm.action = "${detailURL}?method=saveAgent";
	}else{
		theForm.action = "${detailURL}?method=updateAgent";
	}
	theForm.submit();
}

function reFlesh(){
	parent.listFrame.location.href = parent.listFrame.location.href;
}

</script>
</head>
<body scroll="no" style="overflow: no ; height:100% " id="agentbody">
<form id="newAgentForm" method="post" target="editAgentFrame" action="" onsubmit="">

<input type="hidden" id="beginTime" name="beginTime" value="<fmt:formatDate value='${firstDay}' pattern='yyyy-MM-dd HH:mm'/>" />
<input type="hidden" id="endTime" name="endTime" value="<fmt:formatDate value='${lastDay}' pattern='yyyy-MM-dd HH:mm'/>" />
<input type="hidden" id="currentAgentId" name="currentAgentId" value="${agent.id }" />

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
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key="agent.particular.message" bundle="${agentI18N}" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" align="center">
			<div id="docLibBody" class="categorySet-body">
			<script type="text/javascript">
			$(window).resize(function() {
	 			 var thisHeight = $("#agentbody").height()-122;  
			    $("#docLibBody").css("height",thisHeight); 
				});
			var thisHeight = $("#agentbody").height()-122;  
		    $("#docLibBody").css("height",thisHeight); 
			</script>
			<%@include file="agentform.jsp"%>
			</div>		
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<table width="100%" border="0">
			  <tr>
				<td width="100%" align="center">
					<input id="submintButton" type="button" onclick="ok('${operationType}')" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
					<input id="submintCancel" type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
				</td>
			  </tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe name="editAgentFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
document.getElementById("surrogate").focus();
</script>
<script type="text/javascript">
	//bindOnresize('docLibBody',0,70)
</script>
</body>
</html>
