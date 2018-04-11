<%--
/**
 * $Author: zhoulj $
 * $Rev: 28394 $
 * $Date:: 2013-08-13 18:14:23#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>${ctp:i18n('workflow.moreSign.findPerson')}</title>
<script type="text/javascript">
<!--
function OK(){
    if(checkSetPerson()==false){
      return false;
    }
	var str="",submitStr="";
	var temp,tempSel,memObj,memName;
    var i,memId,memName,memAccountId,userType,policy,policyName;
    var selPersons=document.getElementsByName("selp");
    var selPolicys=document.getElementsByName("policy");
    var userIds= new Array();
    var userIdNames= new Array();
    var accoundIds= new Array();
    var policyIds= new Array();
    var policyNames= new Array();
    var userTypes= new Array();
    var mymap= {};
    for(i=0;i<selPersons.length;i++){
      str=selPersons[i].options[selPersons[i].selectedIndex].value.split("|");
      memId=str[0];
      memName= selPersons[i].options[selPersons[i].selectedIndex].getAttribute("mName");
      memAccountId=str[1];
      policy=selPolicys[i].options[selPolicys[i].selectedIndex].value;
      policyName=selPolicys[i].options[selPolicys[i].selectedIndex].text;      
      userIds.push(memId);
      userIdNames.push(memName);
      userTypes.push("Member");
      accoundIds.push(memAccountId);
      policyIds.push(policy);
      policyNames.push(policyName);
    }
    mymap.userType= userTypes;
    mymap.userName= userIdNames;
    mymap.userId= userIds;
    mymap.accountId= accoundIds;
    mymap.policyId= policyIds;
    mymap.policyName= policyNames;
    return $.toJSON(mymap);
    /* var parentForm=window.dialogArguments.theform;
    submitStr += '<input type="hidden" name="summaryId" value="'+parentForm.summary_id.value+'" />';
    submitStr += '<input type="hidden" name="affairId" value="'+parentForm.affair_id.value+'" />';
    submitStr += '<input type="hidden" name="processId" value="'+parentForm.processId.value+'" />';
    submitStr += '<input type="hidden" name="curPolicyId" value="'+parentForm.policy.value+'" />';
    
    document.getElementById("people").innerHTML = submitStr;
    selForm.action=collaborationCanstant.addMoreSignActionURL;    
    selForm.submit(); */
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
    	$.alert("${ctp:i18n('workflow.alert_selExePerson')}");
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
<body style="overflow: auto" onkeydown="listenerKeyESC()" onload="initPolicy()">
<form name="selForm" target="inserPeopleIframe" method="post">
<span id="people" style="display:none;"></span>
<div class="form_area  relative">
<table class="only_table edit_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
     <thead>
      	<tr>
      		<th width="120px" >${ctp:i18n('workflow.moreSign.hasSelected')}</th>
      		<th>${ctp:i18n('workflow.moreSign.exePerson')}</th>
      		<th>${ctp:i18n('workflow.moreSign.permit')}</th>
      	</tr>
     </thead>
	 <tbody>
	   <c:forEach var="msp" items="${msps}">
	   <tr>
		  <td height="20px"><input type="hidden" name="objType" value="${msp.selObj.entityType}">${v3x:getLimitLengthString(msp.selObj.name,20,"...")} </td><td >
    		  <select name="selp" style="width:100%;">
    		      <c:forEach var="mem" items="${msp.selPersons}">
    		      <option value="${mem.id}|${mem.orgAccountId}" mName="${mem.name}" title="${mem.name}">${mem.name}</option>
    		      </c:forEach>
    		  </select>
		  </td>
		  <td >
			  <select style="width:100%;" name="policy">
		        <c:forEach items='${nodePolicyList}' var="nodePolicy">				        	
		        	<option value="${nodePolicy.value}" itemName="${nodePolicy.category}" ${policyId==nodePolicy.value || (policyId==null && defaultPolicyId==nodePolicy.value)?"selected":"" }>${nodePolicy.name}</option>
		        </c:forEach>					        	
	    	  </select>
		  </td>
	</tr>
	</c:forEach>
	</tbody>
</table>
</div>
</form>
</body>
</html>