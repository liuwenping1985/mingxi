<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<html:link renderURL='/edocController.do?method=addMoreSign'  var="addMoreSignUrl"/>
<fmt:setBundle basename="com.seeyon.v3x.taskmanage.resources.i18n.TaskManageResources" var="taskI18N"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="edoc.moreSign.findPerson" /></title>
<script type="text/javascript">
var processId = "${processId}";
<!--

function initPolicy() {
  	var i;
  	var objTypes=document.getElementsByName("objType");
  	var peoObjs=document.getElementsByName("selp");
  	var selectObjs=document.getElementsByName("policy");

  	var process_mode = "0";
  	var process_modes = parent.document.insertPeopleForm.process_mode;   
  	for(var i=0; i<process_modes.length; i++) {      
  		if(process_modes[i].checked) {
  			process_mode = process_modes[i].value;
  			break;
  	  	}
  	}
  	var isHuiqian = (process_mode=="11");
  	var isOnlyDept = true;
  	for(i=0;i<objTypes.length;i++) {
  	  	var objType = objTypes[i].value.split("|")[0];
    	setPolicy(objType, selectObjs[i]);
        if(!isHuiqian || objType!="Department") {
        	isOnlyDept = false;
        }
        if(!isHuiqian || (isHuiqian && objType!="Department")) { 
        	peoObjs[i].disabled = true;
        }
  	}
  	if(isOnlyDept) {
  		parent.document.getElementById("nodeProcessMode").className = "hidden";
  	}
}
//根据类型选择默认权限，部门默认为文书管理，人员默认为会签
function setPolicy(objType,selObj) {
  	var i;
  	var policy="";
  	//if(objType=="Department")
  	////{
  	//  policy="wenshuguanli";
 	// }
  	//else if(objType=="Member")
  	//{ull
  	///  policy="huiqian";
  	//}
  	policy = (parent.document.getElementById("policy").value==""?"huiqian":parent.document.getElementById("policy").value);
  	for(i=0;i<selObj.options.length;i++) {
      	if(policy==selObj.options[i].value) {
      		selObj.options[i].selected=true;
      		return;
    	}
  	}  
}

var plength = 0;
//改变页面上方节点权限为 自定义
function changeTocustom(){
	var policy = parent.document.getElementById("policy");
	if(plength == 0 ){
		plength = policy.options.length;
	}
	var isContainCustom=false;
	if(policy.options.length>0){
		for(var i=0;i<policy.options.length;i++){
			if(policy.options[i].value==0){
				isContainCustom=true;
				break;
			}
		}
	}
	if(policy.options.length == plength && !isContainCustom){
		policy.options.add(new Option('<fmt:message key="task.timerange.custom" bundle="${taskI18N}"/>',0));
	}
	policy.options[policy.options.length-1].selected=true;
}

//-->
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()" onload="initPolicy()">
<form name="selForm" target="inserPeopleIframe" method="post">
<span id="people" style="display:none;"></span>
<table width="100%" height="100%" border="0" class="popupTitleRight" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel">
			<div class="scrollList" style="border: solid 1px #dadada;">
				<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0">
				<thead>
				<tr class="sort">
					<td width="120px" type="String"><fmt:message key="edoc.moreSign.hasSelected" /></td>
					<td type="String"><fmt:message key="edoc.moreSign.exePerson" /></td>
					<td type="String"><fmt:message key="edoc.moreSign.permit" /></td>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="msp" items="${msps}">
				<tr class="sort" style="border-bottom: solid 1px #dadada;">
					<td type="String" height="20px"><input type="hidden" name="objType" value="${msp.selObj.entityType}|${msp.selObj.id}|${msp.selObj.orgAccountId}" text="${msp.selObj.name }">${v3x:getLimitLengthString(msp.selObj.name,20,"...")} </td>
					<td type="String">
					<select name="selp" style="width:100%;">
					<c:forEach var="mem" items="${msp.selPersons}">
					<option value="${mem.id}|${mem.orgAccountId}">${mem.name}</option>
					</c:forEach>
					</select>
					</td>
					<td type="String">
							<select style="width:100%;" name="policy" onchange="changeTocustom();">
					        <c:forEach items='${nodePolicyList}' var="nodePolicy">				        	
					        	<option value="${nodePolicy.name}" itemName="${nodePolicy.category}" ${policyId==nodePolicy.name || (policyId==null && param.defaultPolicyId==nodePolicy.name)?"selected":"" }>
						        	<c:if test="${nodePolicy.type == 0}">
						        		<fmt:message key="${nodePolicy.label}"  bundle="${v3xCommonI18N}"/>				        		
						        	</c:if>
					        		<c:if test="${nodePolicy.type == 1}">${nodePolicy.name}</c:if>
					        	</option>
					        </c:forEach>					        	
				    	</select>
					</td>
				</tr>
				</c:forEach>
				</tbody>
				</table>
			</div>
		</td>
	</tr>
</table>
</form>
<iframe src="" id="inserPeopleIframe" name="inserPeopleIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>