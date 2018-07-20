<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<html:link renderURL='/edocController.do?method=addMoreSign'  var="addMoreSignUrl"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="edoc.moreSign.findPerson" /></title>
<script type="text/javascript">
var processId = "${processId}";
<!--
function ok(){
if(checkSetPerson()==false){return;}
	var str="",submitStr="";
	var temp,tempSel,memObj,memName;
    var i,memId,memName,memAccountId,userType,policy,policyName;
    var selPersons=document.getElementsByName("selp");
    var selPolicys=document.getElementsByName("policy");
    for(i=0;i<selPersons.length;i++)
    {
      str=selPersons[i].options[selPersons[i].selectedIndex].value.split("|");
      memId=str[0];
      memAccountId=str[1];
      policy=selPolicys[i].options[selPolicys[i].selectedIndex].value;
      policyName=selPolicys[i].options[selPolicys[i].selectedIndex].text;      
      submitStr += '<input type="hidden" name="userType" value="Member" />';
	  submitStr += '<input type="hidden" name="userId" value="' + memId + '" />';      
      submitStr += '<input type="hidden" name="accountId" value="'+memAccountId+'" />';
      submitStr += '<input type="hidden" name="accountShortname" value="" />';
      submitStr += '<input type="hidden" name="policyId" value="'+policy+'" />';
      submitStr += '<input type="hidden" name="policyName" value="'+policyName+'" />';
    }
    var parentForm=window.dialogArguments.theform;
    submitStr += '<input type="hidden" name="summaryId" value="'+parentForm.summary_id.value+'" />';
    submitStr += '<input type="hidden" name="affairId" value="'+parentForm.affair_id.value+'" />';
    submitStr += '<input type="hidden" name="processId" value="'+parentForm.processId.value+'" />';
    submitStr += '<input type="hidden" name="curPolicyId" value="'+parentForm.policy.value+'" />';
    
    document.getElementById("people").innerHTML = submitStr;
    selForm.action=collaborationCanstant.addMoreSignActionURL;    
    selForm.submit();
}
/*选择部门时候是否匹配到部门收发员、主管等*/
function checkSetPerson()
{
  var i;
  var selObjs=document.getElementsByName("selp");
  for(i=0;i<selObjs.length;i++)
  {
    if(selObjs[i].options.length<=0)
    {
    	alert(v3x.getMessage("edocLang.edoc_alert_selExePerson"));
        return false;
    }
  }
}
function initPolicy()
{
  var i;
  var objTypes=document.getElementsByName("objType");
  var selectObjs=document.getElementsByName("policy");
  for(i=0;i<objTypes.length;i++)
  {
    setPolicy(objTypes[i].value,selectObjs[i]);
  }
}
//根据类型选择默认权限，部门默认为文书管理，人员默认为会签
function setPolicy(objType,selObj)
{  
  var i;
  var policy="";
  if(objType=="Department")
  {
    policy="wenshuguanli";
  }
  else if(objType=="Member")
  {
    policy="huiqian";
  }
  policy="huiqian";
  for(i=0;i<selObj.options.length;i++)
  {
      if(policy==selObj.options[i].value)
    {
      selObj.options[i].selected=true;
      return;
    }
  }  
}
//-->
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()" onload="initPolicy()">
<form name="selForm" target="inserPeopleIframe" method="post">
<span id="people" style="display:none;"></span>
<table width="100%" height="100%" border="0" class="popupTitleRight" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="edoc.moreSign.findPerson" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<div class="scrollList" style="border: solid 1px #666666;">
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
				<tr class="sort">
					<td type="String" height="20px"><input type="hidden" name="objType" value="${msp.selObj.entityType}">${v3x:getLimitLengthString(msp.selObj.name,20,"...")} </td>
					<td type="String">
					<select name="selp" style="width:100%;">
					<c:forEach var="mem" items="${msp.selPersons}">
					<option value="${mem.id}|${mem.orgAccountId}">${mem.name}</option>
					</c:forEach>
					</select>
					</td>
					<td type="String">
							<select style="width:100%;" name="policy">
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
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe src="" id="inserPeopleIframe" name="inserPeopleIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>