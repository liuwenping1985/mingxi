<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="../collaboration/Collaborationheader.jsp"%>

<html:link renderURL='/edocController.do' var="edoc" />
<html:link renderURL="/collaboration.do" var="col" />

<title><fmt:message key="insertPeople.label"/></title>

<script type="text/javascript">

var colInsertPeopleUrl = "${col}";
var edocInsertPeopleUrl = "${edoc}";
var appTypeName="${appTypeName}"; 

var desArr = new Array();
<c:forEach items='${desList}' var="desStr" varStatus="status">
	desArr[${status.index}] = '${desStr}'; 
</c:forEach>
window.onload = function(){
	var description = "";
	var policyId = "";
	for(var i=0; i<desArr.length; i++){
		var policyAndDes = desArr[i].split("split");
		var _description = policyAndDes[1];
		var _policyId = policyAndDes[0];
		if(_policyId == '${policyId}'){
			description = _description;
		}
	}
	document.getElementById("content").value = description;
}

function setAppOnload()
{
	var isColl = "${appName == 'collaboration'}";
	if(isColl != "true"){
		onlyLoginAccount_insertPeople=true;
	}
	<%--发文收文签报--%>
	var appName ='${appName}';
	if(appName == '0' || appName == '1' || appName == '2'){ 
		onlyLoginAccount_insertPeople=false;
	}
}

//点击确认
function ok(){
	var selObjStr=document.getElementById("people").innerHTML;
	if(selObjStr=="")
	{  
	  alert(_("collaborationLang.alert_select_person"));
	  return;
	}
	//生成人员个节点权限属性
	var str="",submitStr="";
	var temp,tempSel,memObj,memName;
    var i,memId,memName,memAccountId,userType,policy,policyName;
    
    var selPersons=this.addPeopleSelect.document.getElementsByName("selp");
    var selPolicys=this.addPeopleSelect.document.getElementsByName("policy");

    var objTypes = this.addPeopleSelect.document.getElementsByName("objType");

    var isNull = false;
    var title = "";
    for(i=0;i<selPersons.length;i++) {
        if(selPersons[i].selectedIndex < 0) {
        	title += objTypes[i].text+",";
        	isNull = true;
        }
    }
    if(isNull==true) {
    	title = title.substring(0, title.length-1);
    	alert(title+"<fmt:message key='edoc.mustHave.actionPerson'/>");
		return;
    }
    
    for(i=0;i<objTypes.length;i++) {
        str = objTypes[i].text;
        
        memId = objTypes[i].value.split("|")[1];
        var peopleType = objTypes[i].value.split("|")[0];
        memAccountId = objTypes[i].value.split("|")[2];
      	//str=objTypes[i].options[objTypes[i].selectedIndex].value.split("|");
      	//memId=str[0];
     	// memAccountId=str[1];
     
		 //会签
		if(document.getElementById("processMode_huiqian").checked == true){
	         if(peopleType=="Department") {
	        	 peopleType = "Member";
	        	 memId = selPersons[i].options[selPersons[i].selectedIndex].value.split("|")[0];
	        	 str = selPersons[i].options[selPersons[i].selectedIndex].text;
		     }
	     }
     
      policy=selPolicys[i].options[selPolicys[i].selectedIndex].value;
      policyName=selPolicys[i].options[selPolicys[i].selectedIndex].text;      
      submitStr += '<input type="hidden" name="userType" value="'+peopleType+'" />';
	  submitStr += '<input type="hidden" name="userId" value="' + memId + '" />';      
      submitStr += '<input type="hidden" name="accountId" value="'+memAccountId+'" />';
      submitStr += '<input type="hidden" name="accountShortname" value="" />';
      submitStr += '<input type="hidden" name="policyId" value="'+policy+'" />';
      submitStr += '<input type="hidden" name="policyName" value="'+policyName+'" />';
    }
    

    /*for(i=0;i<selPersons.length;i++)
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
    }*/
    
    var parentDocument = window.dialogArguments.document;
    var parentForm = parentDocument.getElementById("theform");
    submitStr += '<input type="hidden" name="summaryId" value="'+parentDocument.getElementById("summary_id").value+'" />';
    submitStr += '<input type="hidden" name="affairId" value="'+parentDocument.getElementById("affair_id").value+'" />';
    submitStr += '<input type="hidden" name="processId" value="'+parentDocument.getElementById("processId").value+'" />';
    submitStr += '<input type="hidden" name="curPolicyId" value="'+parentDocument.getElementById("policy").value+'" />';
    document.getElementById("people").innerHTML = submitStr;
	
	//与当前节点并发（当前会签）
	if(document.getElementById("processMode_bingfa").checked == true){
		dangqianhuiqianOk();
	}else if(document.getElementById("processMode_huiqian").checked == true){ //多级会签
		duojihuiqianOk();
	}else{ //普通加签
		jiaqianOk();
	}
}

var showAccountShortname_colAssign = "yes";
var hiddenFlowTypeRadio_colAssign = true;
var showOriginalElement_colAssign = false;
var unallowedSelectEmptyGroup_colAssign = true;
var hiddenRootAccount_colAssign = true;

//当前会签确认
function dangqianhuiqianOk(){
var selObjStr=document.getElementById("people").innerHTML;
if(selObjStr=="")
{  
  alert(_("collaborationLang.alert_select_person"));
  return;
}
v3x.getParentWindow().workflowUpdate = true ;
var form = document.getElementsByName("insertPeopleForm")[0];

var processId = form.processId.value;

var itemName = '${nodePolicy.category}';

try { getA8Top().startProc(''); }catch (e) { }

var _genericURL = null;

	form.action = edocInsertPeopleUrl+"?method=colAssign"
	+"&itemName="+encodeURIComponent(itemName)+"&flowcomm=col";


document.getElementById("b1").disabled = true;
document.getElementById("b2").disabled = true;

form.submit();
}


//普通加签确认
function jiaqianOk(){
	var selObjStr=document.getElementById("people").innerHTML;
	if(selObjStr=="")
	{  
	  alert(_("collaborationLang.alert_select_person"));
	  return;
	}
	v3x.getParentWindow().parent.detailMainFrame.workflowUpdate = true ;
	var form = document.getElementsByName("insertPeopleForm")[0];
    var processId = form.processId.value;
	var policyOption = form.policy.options[form.policy.selectedIndex];
    var itemName = policyOption.getAttribute("itemName");
	var process_mode = form.process_mode;
	var processMode;
	
    for(var i=0; i<process_mode.length; i++){
		if(process_mode[i].checked){
			processMode = process_mode[i].value;
		}
	}
	try { getA8Top().startProc(''); }catch (e) { }
	var isColl = "${appName == 'collaboration'}";
	var _genericURL = null;
	_genericURL = edocInsertPeopleUrl;
	form.action = _genericURL+"?method=insertPeople&itemName="+encodeURIComponent(itemName)+"&processMode="+encodeURIComponent(processMode)+"&appName="+encodeURIComponent('${appName}');

	document.getElementById("b1").disabled = true;
    document.getElementById("b2").disabled = true;
    
    form.submit();
    // 流程是否改变全局变量 
    v3x.getParentWindow().workflowUpdate = true ;
    
}

var unallowedSelectEmptyGroup_insertPeople = true;
var hiddenRootAccount_insertPeople = true;
function enAbleButton(){
	document.getElementById("b1").disabled = false;
    document.getElementById("b2").disabled = false;
}

function policyChange(poli){
	if(poli == "inform" || poli =="zhihui"){
		document.getElementById("processMode_parallel").checked = true;
		document.getElementById("processMode_serial").disabled = true;
		document.getElementById("processMode_nextparallel").disabled = true;
		if(document.getElementById("nodeProcessMode") && document.getElementById("nodeProcessMode").className == ""){
			document.getElementById("nodeProcessMode").className = "hidden";
		}
		document.getElementById("all_mode").checked = true;	
		if(document.getElementById("formOperationPolicy1")){
			document.getElementById("formOperationPolicy1").disabled = true;
		}
		if(document.getElementById("formOperationPolicy2")){
			document.getElementById("formOperationPolicy2").checked = true;
		}
	}
	else{
		document.getElementById("processMode_serial").disabled = false;
		document.getElementById("processMode_nextparallel").disabled = false;
		if(document.getElementById("formOperationPolicy1")){
			document.getElementById("formOperationPolicy1").disabled = false;
			document.getElementById("formOperationPolicy1").checked = true;
		}
		if(document.getElementById("formOperationPolicy2")){
			document.getElementById("formOperationPolicy2").checked = false;
		}
	}

    var peopleSelectPolicy=this.addPeopleSelect.document.getElementsByName("policy");
	if(peopleSelectPolicy && peopleSelectPolicy.length>0 && poli!='0'){
		for(var i=0;i<peopleSelectPolicy.length;i++){
			peopleSelectPolicy[i].value=poli;
		}
	}
}


function changeSelectPeople(elements){
	setPeopleInsert(elements);
	this.addPeopleSelect.location.href = edocInsertPeopleUrl + "?method=preAddMoreSign&selObj="+getIdsString(elements)+"&appName=${appTypeName}&summary_id=${summaryId}";
}


///////多级会签确认
function duojihuiqianOk(){
if(checkSetPerson()==false){return;}

document.getElementById("b1").disabled = true;
document.getElementById("b2").disabled = true;
    insertPeopleForm.action=this.addPeopleSelect.collaborationCanstant.addMoreSignActionURL;    
    insertPeopleForm.submit();
}
/*选择部门时候是否匹配到部门收发员、主管等*/
function checkSetPerson()
{
  var i;
  var selObjs=this.addPeopleSelect.document.getElementsByName("selp");
  for(i=0;i<selObjs.length;i++)
  {
    if(selObjs[i].options.length<=0)
    {
    	alert(v3x.getMessage("edocLang.edoc_alert_selExePerson"));
        return false;
    }
  }
}

function changeProcessMode(value) {
	var process_mode = value;
	var addPeopleSelectFrame = window.frames["addPeopleSelect"];
	var objTypes = addPeopleSelectFrame.window.document.getElementsByName("objType");
  	var peoObjs = addPeopleSelectFrame.window.document.getElementsByName("selp");
	
  	var isHuiqian = (process_mode=="11");
  	var isOnlyDept = true;
  	var isOnlyMember = true;
  	for(i=0;i<objTypes.length;i++) {
  	  	var objType = objTypes[i].value.split("|")[0];
  	  	if(objType!="Member") {
  	  		isOnlyMember = false;
  	  	}
        if(!isHuiqian || objType!="Department") {
        	isOnlyDept = false;
        }
        if(!isHuiqian || (isHuiqian && objType!="Department") || process_mode=="0") { 
        	peoObjs[i].disabled = true;
        } else {
        	peoObjs[i].disabled = false;
        }
  	}
  	//GOV-5116.【公文-待办】加签，选择具体的人员，在串发，并发之间切换，居然出现了执行模式。不应该有执行模式的 start
  	if(isOnlyMember) {
  		document.getElementById("nodeProcessMode").className = "hidden";
  	} else {
	  	if(isOnlyDept) {
	  		document.getElementById("nodeProcessMode").className = "hidden";
	  	} else {
	  		document.getElementById("nodeProcessMode").className = "";
	  	}
  	}
  	//GOV-5116.【公文-待办】加签，选择具体的人员，在串发，并发之间切换，居然出现了执行模式。不应该有执行模式的 end
}
var isConfirmExcludeSubDepartment_insertPeople = true;
//////
</script>

<v3x:selectPeople id="insertPeople" panels="${appName eq 'collaboration'?'Department,Team,Post,Outworker':'Department,Team,Post'},RelatePeople" selectType="Department,Team,Member"
                  jsFunction="changeSelectPeople(elements)" minSize="1" />

</head>
<body scroll="no" onkeypress="listenerKeyESC()" onLoad="setAppOnload()">
<form name="insertPeopleForm" action="" target="inserPeopleIframe" method="post" >
<input type="hidden" name="summaryId" id="summaryId" value="${summaryId}">
<input type="hidden" name="affairId" id="affairId" value="${affairId}">
<input type="hidden" name="processId" id="processId" value="${processId}">
<input type="hidden" name="process_desc_by" id="process_desc_by" value="people">
<input type="hidden" name="appName" id="appName" value="${appName}">
<input type="hidden" id="currentLoginAccountId" name="currentLoginAccountId" value="${v3x:currentUser().loginAccount}">

<span id="people" style="display:none;"></span>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#BADCE8">

	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="insertPeople.label"/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr  height="32">
				<td nowrap="nowrap" align="right" width="25%">
					<fmt:message key="selectPolicy.please.select" />:&nbsp;
				</td>
				<td width="56%">	
				
				<select id="policy" name="policy" class="input-100per" onChange="policyChange(this.value)">
		    		<c:forEach items='${nodePolicyList}' var="nodePolicy">				        	
			        	<option value="${nodePolicy.name}" itemName="${nodePolicy.category}" ${defaultPolicyId==nodePolicy.name || defaultPolicyId==nodePolicy.id?"selected":"" }>
				        	<c:if test="${nodePolicy.type == 0}">
				        		<fmt:message key="${nodePolicy.label}"  bundle="${v3xCommonI18N}"/>				        		
				        	</c:if>
			        		<c:if test="${nodePolicy.type == 1}">${nodePolicy.name}</c:if>
			        	</option>
			        </c:forEach>
			        <c:if test="${param.appName == 'collaboration'}">
			        	<v3x:metadataItem metadata="${formAuditPolicy}" showType="option" name="policy"  selected="${policyId}" bundle="${v3xNodePolicyI18N}"/>				        
			        </c:if>		
		    	</select>
			
		    	</td>
		    	<td align="center">

	    		</td>
	    	</tr>
			<c:if test="${param.isForm eq true}">
			<tr height="32">
				<td align="right">
					<fmt:message key="form.operation.permission" />:&nbsp;
				</td>
				<td colspan="2">
					<c:if test="${isFormReadonly ne true}">
						<label for="formOperationPolicy1">
							<input type="radio" id="formOperationPolicy1" name="formOperationPolicy" value="0"><fmt:message key="operation.permission.sameToCurrentNode" />
						</label>
					</c:if>
					<label for="formOperationPolicy2">
						<input id="formOperationPolicy2" type="radio" name="formOperationPolicy" value="1" checked><fmt:message key="common.readonly" bundle="${v3xCommonI18N}" />
					</label>
				</td>
			</tr>
			</c:if>
			<tr height="32">
				<td nowrap="nowrap" align="right">
					<fmt:message key="select.excutive.people.lable"/>:&nbsp;
				</td>
				<td align="left"><input id="workflowInfo" name="workflowInfo" class="input-100per cursor-hand" readonly value="<<fmt:message key='urger.alt' />>" onClick="selectPeopleFun_insertPeople()"></td>
		  		<td></td>
		  	</tr>
			
			<tr>
			 <td colspan="3" valign="top">
			    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			      <tr>
			        <td width="50%" valign="top">
			        <table width="100%" border="0" cellspacing="0" cellpadding="0">
			        <tr>
			        <td width="56" valign="top">
			        <fmt:message key="process.mode.label"/>:
			        </td>
			        <td><div style="border-top:1px solid #979797; margin-top:4px;">&nbsp;</div>
			        </td>
			        </tr>
			        </table>
			        A&nbsp;<fmt:message key='edoc.currentNode.person'/>&nbsp;&nbsp;&nbsp;B&nbsp;<fmt:message key='edoc.nextNode.person'/>&nbsp;&nbsp;&nbsp;C&nbsp;<fmt:message key='edoc.choosedNode.person'/>
			        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
				      	<tr>
					      	<td>
					      	 <label for="processMode_serial">
						<input type="radio" name="process_mode" id="processMode_serial" value="0" onClick="changeProcessMode(this.value)"><fmt:message key="flow.type.serial"/>
					</label><br />
					<img src="<%=request.getContextPath() %>/apps_res/edoc/images/insertPeople1.jpg" width="166" height="97">
					      	</td>
					      	<td>
					      	<label for="processMode_parallel">
						<input type="radio" name="process_mode" id="processMode_parallel" value="1" checked onClick="changeProcessMode(this.value)"><fmt:message key="flow.type.parallel"/>
					</label><br />
					<img src="<%=request.getContextPath() %>/apps_res/edoc/images/insertPeople2.jpg" width="166" height="97">
					      	</td>
				      	</tr>
				      	<tr>
					      	<td>
					      	<label for="processMode_nextparallel">
						<input type="radio" name="process_mode" id="processMode_nextparallel" value="4" onClick="changeProcessMode(this.value)"><fmt:message key="flow.type.nextparallel"/>
					</label>
					<br />
					<img src="<%=request.getContextPath() %>/apps_res/edoc/images/insertPeople3.jpg" width="166" height="97">
					      	</td>
					      	<td>
					      	<label for="processMode_bingfa">
						<input type="radio" name="process_mode" id="processMode_bingfa" value="10" onClick="changeProcessMode(this.value)"><fmt:message key='edoc.currentNode.concurrent'/>
					</label><br />
					<img src="<%=request.getContextPath() %>/apps_res/edoc/images/insertPeople4.jpg" width="166" height="97">
					      	</td>
				      	</tr>
				      	<tr>
					      	<td>
					      	<label for="processMode_huiqian">
						<input type="radio" name="process_mode" id="processMode_huiqian" value="11" onClick="changeProcessMode(this.value)"><fmt:message key='colAssign.label'/>
					</label><br />
					<img src="<%=request.getContextPath() %>/apps_res/edoc/images/insertPeople5.jpg" width="166" height="97">
					      	</td>
					      	<td>
					      	</td>
				      	</tr>
				    </table>
			        </td>
			        <td width="50%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			        <tr>
			        <td width="76" valign="top" height="30">
			        &nbsp;&nbsp;<fmt:message key='edoc.moreSign.findPerson'/>:
			        </td>
			        <td><div style="border-top:1px solid #979797; margin-top:4px; width:100%">&nbsp;</div>
			        </td>
			        </tr>
                    <tr>
			        </table>
                     <iframe src="edocController.do?method=preAddMoreSign"  name="addPeopleSelect" id="addPeopleSelect" frameborder="0" height="90%" width="100%" scrolling="auto" marginheight="0" marginwidth="0" ></iframe>
			        </td>
			      </tr>
			    </table>
			 </td>
			</tr>
			

			<tr id="nodeProcessMode" class="hidden">			
				<td nowrap="nowrap" align="right">					
					<fmt:message key="node.process.mode"  bundle="${v3xCommonI18N}"/>:&nbsp;
				</td>
				<td>
					<label for="all_mode">
						<input type="radio" name="node_process_mode" id="all_mode" value="all"  checked>
						<fmt:message key="node.all.mode" bundle="${v3xCommonI18N}"/>
					</label>
					<label for="competition_mode">	
						<input type="radio" name="node_process_mode" id="competition_mode" value="competition">
						<fmt:message key="node.competition.mode" bundle="${v3xCommonI18N}"/>
					</label>
					<span style="display:none">
						<label for="one_mode">	
							<input type="radio" name="node_process_mode" id="one_mode" value="one">
						</label>
					</span>
				</td>
			</tr>					

		</table>
		</td>
	</tr>
	<tr height="42" align="right">
					<td class="bg-advance-bottom">
						<input type="button" name="b1" id="b1" onClick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;
					<input type="button" name="b2" id="b2" onClick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
	              </tr>
</table>

<div id="policyExplainHTML" class="hidden">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
		<tr>
			<td colspan="2">
			    <div style="height: 28px;">
	        		<textarea name="content" rows="9" cols="46" validate="maxLength"
	                  		inputName="<fmt:message key="common.opinion.label" bundle="${v3xCommonI18N}" />" maxSize="2000" readonly></textarea>
			    </div>	
			</td>
		</tr>	
 	</table>
</div>

</form>
<iframe src="" name="inserPeopleIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>