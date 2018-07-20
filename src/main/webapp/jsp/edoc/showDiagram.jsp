<%@ page import="com.seeyon.v3x.workflow.event.WorkflowEventListener" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	     pageEncoding="UTF-8" %>
<%@page import="com.seeyon.v3x.exchange.util.Constants"%>
<%@page import="com.seeyon.v3x.edoc.manager.EdocSwitchHelper"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<%@ include file="../doc/pigeonholeHeader.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<title><fmt:message key="showDiagram.title"/></title>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<c:set value="${v3x:currentUser().id}" var="currentUserId"/>
<c:set value="${param.from eq 'Pending' && affair.state eq 3}" var="hasSignButton"/>
<v3x:selectPeople id="flash" panels="Department,Team" selectType="Department,Team,Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="monitorFrame.dataToFlash(elements)" viewPage="selectNode4Workflow"/>
                  
<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel"/>
<fmt:message key="common.attribute.label" bundle="${v3xCommonI18N}" var="attributeLabel" />
 <fmt:message key='flow.node.excute.detail' bundle="${colI18N}" var="excuteDetailLabel" />                 
<script type="text/javascript">
<!--
var appTypeName="${appTypeName}";
var summaryId="${param.summaryId}";
var hasDiagram = "${hasDiagram}";
var currentNodeId = "${currentNodeId}";
var showMode = 0;
var showHastenButton = "${showHastenButton}";
var isNewCollaboration = "${isNewCollaboration}";
var isTemplete = false;
var isCheckTemplete = false;
var templateFlag = "${templateFlag}";
var summary_id = "${param.summaryId}";
var transmitSendNewEdocId="${transmitSendNewEdocId}";
var isEdocCreateRole="${isEdocCreateRole}";
var canEdit="${v3x:containInCollection(advancedActions, 'Edit') or v3x:containInCollection(commonActions, 'Edit')}";
var affair_id = "${param.affairId}";
var hasPrepigeonholePath="${hasSetPigeonholePath}";
var sendUserDepartmentId="${edocSendMember.orgDepartmentId}";
var sendUserAccountId="${edocSendMember.orgAccountId}";
var caseId = "${caseId }";
var processId = "${processId }";
var showOriginalElement_colAssign=false;
//异步加载流程信息
var isLoadProcessXML = false;
var caseProcessXML = "";
var caseLogXML = "";
var caseWorkItemLogXML = "";
var clickClose = false;
//var hasSetPigeonholePath="${hasSetPigeonholePath}";
function initCaseProcessXML(){
	if(isLoadProcessXML == false){
		try {
			var requestCaller = new XMLHttpRequestCaller(null, "ajaxColManager", "getXML", false, "POST");
			requestCaller.addParameter(1, "String", caseId);
			requestCaller.addParameter(2, "String", processId);
			var processXMLs = requestCaller.serviceRequest();
			
			if(processXMLs){
				caseProcessXML = processXMLs[0];
				caseLogXML = processXMLs[1];
				caseWorkItemLogXML = processXMLs[2];
				document.getElementById("process_xml").value = caseProcessXML;
				document.getElementById("process_desc_by").value = "xml";
			}
		}
		catch (ex1) {
		}
		isLoadProcessXML = true;
	}
}

var panels = new ArrayList();
<c:if test="${hasSignButton == true}">
panels.add(new Panel("sign", '<fmt:message key="sign.label" />', "showPrecessArea()"));
</c:if>
<c:if test="${onlySeeContent=='false'}">
panels.add(new Panel("workflow", '<fmt:message key="workflow.label" />', "showPrecessArea()"));
</c:if>
<c:if test="${isSupervis == true && from == 'supervise'}">
	panels.add(new Panel("supervis", '<fmt:message key="supervise.label" bundle="${colI18N}"/>', "showPrecessArea()"));
</c:if>
var divPhraseDisplay = 'none';
function init() {
var dealListArry = [];
var dealListParent = document.getElementById('dealTD');
if(dealListParent!=null){
var dealList = dealListParent.childNodes;
if(dealList!=null){



for(var i = 0;i<dealList.length;i++){
	dealListArry[dealListArry.length] = dealList[i].outerHTML;
}
dealListParent.innerHTML='';
var stringBuffer = new StringBuffer();
stringBuffer.append("<table class='ellipsis'>");
var count = 0;
var numberSub = 4;
var widthScreen = parseInt(window.screen.width);
if(v3x.isIpad){
	widthScreen = parseInt(window.screen.height);
}
if(widthScreen==1024){
	if('${param.list}'=='list'){
		numberSub = 3;
	}else{
		numberSub = 4;
	}
}else if(widthScreen<1024){
	numberSub = 2;
}else if(widthScreen==1280){
	if('${param.list}'=='list'){
		numberSub = 4;
	}else{
		numberSub = 5;
	}
}else if(widthScreen>1280){
	numberSub = 5;
}
for(var j = 0;j<dealListArry.length;j++){
	if((j+1)%numberSub==1){
		stringBuffer.append("<tr>");
		count++;
	}
	stringBuffer.append("<td>");
	stringBuffer.append(dealListArry[j]);
	stringBuffer.append("</td>");
	if((j+1)%numberSub==0){
	stringBuffer.append("</tr>");
	}
}
stringBuffer.append("</table>");
dealListParent.innerHTML=stringBuffer.toString();
}
}
if(${supervisePanel!=null}){
	changeLocation('workflow');
	showPrecessArea();
}

var oSupervise = document.getElementById('buttonsupervis');
if(oSupervise!=null){
oSupervise.onclick=null;
oSupervise.onclick=function(){
changeLocation('supervis');
showPrecessArea();
document.getElementById('superviseIframe').src = "${edoc}?method=superviseDiagram&summaryId=${param.summaryId}&openModal=${openModal}";
}
}

var buttonworkflow = document.getElementById('buttonworkflow');
if(buttonworkflow!=null){
	buttonworkflow.onclick=null;
	buttonworkflow.onclick=function(){
		changeLocation('workflow');showPrecessArea();
		var divPhrase = document.getElementById('divPhrase');
		if(divPhrase!=null && divPhrase.style.display!='none'){
			divPhraseDisplay  = 'block';
			divPhrase.style.display='none';
		}else{
			divPhraseDisplay  = 'none';
		}
	}
}
var buttonsign = document.getElementById('buttonsign');
if(buttonsign!=null){
	buttonsign.onclick=null;
	buttonsign.onclick=function(){
		changeLocation('sign');showPrecessArea();
		var divPhrase = document.getElementById('divPhrase');
		if(divPhrase!=null && divPhraseDisplay=='block'){
			divPhrase.style.display='block';
		}else{
			divPhrase.style.display='none';
		}
	}
}

}
if(${supervisePanel!=null}){
	parent.zy.cols="*,45";
}
function unLoad(processId, summaryId,userId){
	try{
    	unlockEdocEditForm(summaryId,userId);
    	unlockHtmlContent(summaryId);
    }catch(e){
    }
}

var phraseURL = '<html:link renderURL="/phrase.do?method=list" />';

function updateContent(summaryId)
{
  parent.detailMainFrame.contentIframe.modifyBody(summaryId,hasSign);
}
var hasSign=${v3x:containInCollection(commonActions, 'Sign') || v3x:containInCollection(advancedActions, 'Sign')};

function htmlSign()
{
  parent.detailMainFrame.contentIframe.handWrite(theform.summary_id.value,theform.disPosition.value);
}

var permKey="${nodePermissionPolicyKey}";
var isCanFengfa=${v3x:containInCollection(baseActions, 'EdocExchangeType')};
function edocSubmitForm(subForm,summaryId)
{
//yangzd 在多人执行时，删除当前编辑人的编辑信息
 var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "deleteUpdateObj",false);
  requestCaller.addParameter(1, "String", summaryId);  
  requestCaller.serviceRequest();
//yangzd
	<%-- dIdentifier(); //给督办人ID加标识 0|1|2 --%>
	  if(permKey=="fengfa"||isCanFengfa)
  {
       if(parent.detailMainFrame.contentIframe.checkEdocWordNo()==false)
       {
       	 return;
       }
       if(checkExchangeRole()==false)
       {
         return;
       }
	  var memberList = document.getElementById("memberList");
	  var selectValueObj = memberList.options[memberList.selectedIndex];
  }  
  try{
    doSign(subForm,formAction);
  }catch(e){
  }
}
function showMemberList(){
	var memberListDiv = document.getElementById("selectMemberList");
	memberListDiv.style.display = "";
}
function hideMemberList(){
	var memberListDiv = document.getElementById("selectMemberList");
	memberListDiv.style.display = "none";
}

	function addIdentifier(){
	var orgMemberId = document.getElementById("orgSupervisorId").value;
	var memberId = document.getElementById("supervisorId").value;
	var orgArray = orgMemberId.split(",");
	var memberArray = memberId.split(",");
	var returnId = "";
	for(var i=0;i<memberArray.length;i++){

		if(orgMemberId.value == ""){
			memberArray[i] +="|0";
			returnId += memberArray[i];
			returnId +=",";
			continue;
		}

		var bool = orgMemberId.search(memberArray[i]);
		
		if(bool != "-1" || bool != -1){
			memberArray[i] += "|0";
		}else{
			memberArray[i] += "|1";
		}
		returnId += memberArray[i];
		returnId +=",";
	}

	if(orgMemberId != ''){
		for(var i=0;i<orgArray.length;i++){
			var bool = returnId.search(orgArray[i]);
			if(bool == '-1' || bool == -1){
				orgArray[i] += "|2";
				returnId += orgArray[i];
				returnId += ",";
			}
		}
	}

	document.getElementById("supervisorId").value = returnId;
		
	}

	function checkExchangeRole()
	{
	  var typeAndIds="";
	  var msgKey="edocLang.alert_set_departExchangeRole";	  
	  var obj=document.getElementById("edocExchangeType_depart");
	  if(obj==null){return true;}
	  if(obj.checked)
	  {
	    typeAndIds="Department|"+sendUserDepartmentId;	    
	  }
	  else
	  {
	  	typeAndIds="Account|"+sendUserAccountId;
	  	msgKey="edocLang.alert_set_accountExchangeRole";
	  }
	  var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "checkExchangeRole",false);
  	  requestCaller.addParameter(1, "String", typeAndIds);  
	  var ds = requestCaller.serviceRequest();
	  if(ds=="check ok"){return true;}
	  else
	  {
	    alert(_(msgKey,ds));
	  }
	  return false;
	}

var formAction="<html:link renderURL='/edocController.do?method=finishWorkItem' />";



var timerBrighter;
function brighter(id){
    timerBrighter = window.setInterval("menuItemIn('" + id + "')", 50);
    window.clearInterval(timerDarker);
}

function menuItemIn(id){
	if(document.getElementById(id).filters.alpha.opacity < 100){
		document.getElementById(id).filters.alpha.opacity += 10;
    }else{
		window.clearInterval(timerBrighter);
    }
}

var timerDarker;
function darker(id){
	timerDarker = window.setInterval("menuItemOut('" + id + "')", 50);
	window.clearInterval(timerBrighter);
}

function menuItemOut(id){
    if(document.getElementById(id).filters.alpha.opacity > 0){
		document.getElementById(id).filters.alpha.opacity -= 10;
    }else{
		window.clearInterval(timerDarker);
		
		if(document.getElementById(id).filters.alpha.opacity <= 0) {
			document.getElementById(id).style.display = "none";
		}
    }
}

	function openSuperviseWindow(summaryId){
    	var mId = document.getElementById("supervisorId");
		var sDate = document.getElementById("awakeDate");
		var sNames = document.getElementById("supervisors");
		var title = document.getElementById("superviseTitle");
		var count = document.getElementById("count");
		var isDeleteSupervisior = document.getElementById("isDeleteSupervisior");
	
		var unCancelledVisor = document.getElementById("unCancelledVisor");
		var sfTemp = document.getElementById("sVisorsFromTemplate");
		var urlStr = superviseURL + "?method=superviseWindow";
		if(mId.value != null && mId.value != ""){
			urlStr += "&supervisorId=" + mId.value + "&supervisors=" + encodeURIComponent(sNames.value) 
			+ "&superviseTitle=" + encodeURIComponent(title.value) + "&awakeDate=" + sDate.value  + "&sVisorsFromTemplate="+sfTemp.value +"&unCancelledVisor="+unCancelledVisor.value + "&count="+count.value;
		}

        var rv = v3x.openWindow({
	        url: urlStr,
	        height: 300,
	        width: 400
     	});
     	
    	if(rv!=null && rv!="undefined"){
    	   try{
	    	    var affair_IdValue = document.getElementById('affair_id') ;
	    	    var summary_IdValue = document.getElementById('summary_id') ;
	    	    var ajaxUserId = document.getElementById('ajaxUserId') ;
	    	    if(affair_IdValue && summary_IdValue && ajaxUserId ) {
	    	       recordChangeWord(affair_IdValue.value ,summary_IdValue.value ,"duban" ,ajaxUserId.value)
	    	    }
    	   }catch(e){
    	   }
    		var sv = rv.split("|");
    		if(sv.length == 4){
				mId.value = sv[0]; //督办人的ID(添加标识的，为的是向后台传送)
				sDate.value = sv[1]; //督办时间
				sNames.value = sv[2]; //督办人的姓名
				title.value = sv[3];
				//canModify.value = sv[4];
			}else if(sv.length == 5){
				mId.value = sv[0]; //督办人的ID(添加标识的，为的是向后台传送)
				sDate.value = sv[1]; //督办时间
				sNames.value = sv[2]; //督办人的姓名
				title.value = sv[3];
				isDeleteSupervisior.value = sv[4];//取消督办
			}
    	}
}

	//分支 开始
	//分支
var branchs = new Array();
var team = new Array();
var secondpost = new Array();
var startTeam = new Array();
var startSecondpost = new Array();
<c:if test="${branchs != null}">
	var handworkCondition = _('edocLang.handworkCondition');
	<c:forEach items="${branchs}" var="branch" varStatus="status">
		var branch = new ColBranch();
		branch.id = ${branch.id};
		branch.conditionType = "${branch.conditionType}";
		branch.formCondition = "${v3x:escapeJavascript(branch.formCondition)}";
		branch.conditionTitle = "${v3x:escapeJavascript(branch.conditionTitle)}";		
		//if(branch.conditionType!=2)
			branch.conditionDesc = "${v3x:escapeJavascript(branch.conditionDesc)}";
		/*else
				branch.conditionDesc = handworkCondition;		*/
		branch.isForce = "${branch.isForce}";
		eval("branchs["+${branch.linkId}+"]=branch");
	</c:forEach>
</c:if>
<c:if test="${teams != null}">
	<c:forEach items="${teams}" var="team">
		team["${team.id}"] = ${team.id};
	</c:forEach>
</c:if>
<c:if test="${secondPosts != null}">
	<c:forEach items="${secondPosts}" var="secondPost">
		secondpost["${secondPost.depId}_${secondPost.postId}"] = "${secondPost.depId}_${secondPost.postId}";
	</c:forEach>
</c:if>
<c:if test="${startTeams != null}">
	<c:forEach items="${startTeams}" var="startTeam">
		startTeam["${startTeam.id}"] = "${startTeam.id}";
	</c:forEach>
</c:if>
<c:if test="${startSecondPosts != null}">
	<c:forEach items="${startSecondPosts}" var="startSecondPost">
		startSecondpost["${startSecondPost.depId}_${startSecondPost.postId}"] = "${startSecondPost.depId}_${startSecondPost.postId}";
	</c:forEach>
</c:if>
	//分支 结束
	
function showDigarm(id) {
	//判断是否当前用户是否仍然是公文督办人
	if(!isStillSupervisor(summaryId)){
		if(!window.dialogArguments)
			parent.parent.location.href = parent.parent.location.href;
		else
			window.close();
		return false;
	}
	var _url = "${supervise}?method=showDigarm&superviseId="+id+"&comm=toxml&fromList=popup";
	  	var rv = v3x.openWindow({
	     		 url: _url,
	     		 width: 860,
	      	height: 690,
	      	resizable: "no"
	  	});
	  	if(rv){
		//parent.detailRightFrame.location.href = parent.detailRightFrame.location+"&supervise=workflow";
		document.getElementById('monitorFrame').src = "${supervise}?method=showDigramOnly&edocId=${param.summaryId}&superviseId=${bean.id}&fromList=list";
		}
}
//-->



</script>

</head>
<body onload="init()" onUnload="unLoad('${summary.processId}', '${param.summaryId}','${currentUserId}')" scroll="no" class="precss-scroll-bg">
<div oncontextmenu="return false"
     style="position:absolute; right:20px; top:120px; width:260px; height:60px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;"
     id="divPhrase" onmouseover="showPhrase()" onmouseout="hiddenPhrase()" oncontextmenu="return false">
    <IFRAME width="100%" id="phraseFrame" name="phraseFrame" height="100%" frameborder="0" align="middle" scrolling="no"
            marginheight="0" marginwidth="0"></IFRAME>
</div>

<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
    <script type="text/javascript">showMinPanels();</script>
    <div class="sign-min-label" onclick="parent.detailMainFrame.contentIframe.dealPopupContentWin('0')" title="<fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' />"><fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' /></div><div class="separatorDIV"></div>
    <c:if test="${hasBody1}">
    <div class="sign-min-label" onclick="parent.detailMainFrame.contentIframe.dealPopupContentWin('1')" title="<fmt:message key='edoc.contentnum1.label' />"><fmt:message key='edoc.contentnum1.label' /></div><div class="separatorDIV"></div>
    </c:if>
    <c:if test="${hasBody2}">
    <div class="sign-min-label" onclick="parent.detailMainFrame.contentIframe.dealPopupContentWin('2')" title="<fmt:message key='edoc.contentnum2.label' />"><fmt:message key='edoc.contentnum2.label' /></div><div class="separatorDIV"></div>
    </c:if>
</div>
<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td height="25" valign="top" nowrap="nowrap" class="sign-button-bg">    
        <script type="text/javascript">showPanels();</script>
        <div class="sign-button-L"></div>
        <div id='buttonContent' onClick="parent.detailMainFrame.contentIframe.dealPopupContentWin('0')" class="sign-button-M"><fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' /></div><div class="sign-button-R"></div><div class="sign-button-line"></div>
        <c:if test="${hasBody1}">
        <div class="sign-button-L"></div>
        <div id='buttonContent' onClick="parent.detailMainFrame.contentIframe.dealPopupContentWin('1')" class="sign-button-M"><fmt:message key='edoc.contentnum1.label' /></div><div class="sign-button-R"></div><div class="sign-button-line"></div>
        </c:if>
        <c:if test="${hasBody2}">
        <div class="sign-button-L"></div>
        <div id='buttonContent' onClick="parent.detailMainFrame.contentIframe.dealPopupContentWin('2')" class="sign-button-M"><fmt:message key='edoc.contentnum2.label' /></div><div class="sign-button-R"></div><div class="sign-button-line"></div>
        </c:if>
        </td>
	    <td width="12%" class="sign-button-bg" align="right" nowrap="nowrap">
	    <c:if test="${printEdocTable && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
	    	<img src="<c:url value='/common/images/toolbar/print.gif' />" alt="${printLabel}" onclick='colPrint()' class="cursor-hand">
	    </c:if>
	    <img src="<c:url value='/apps_res/collaboration/images/workflowDealDetail.gif' />" alt="<fmt:message key="newflow.view" bundle='${colI18N}' />" onclick="showFlowNodeDetail()" class="cursor-hand">
	    <c:if test="${param.from eq 'sended'}">
	    	<img src="<c:url value='/apps_res/collaboration/images/superviseSetup.gif' />" alt="<fmt:message key='common.toolbar.supervise.label' bundle='${v3xCommonI18N}' />" onclick='showSuperviseWindow()' class="cursor-hand">
	    </c:if>&nbsp;
    </td>       
</tr>

<tr id="closeTR" style="display: none" valign="top">
    <td>&nbsp;</td>
</tr>

<c:if test="${hasSignButton == true}">
<tr id="signTR" style="display: none" valign="top">
<td  colspan="3">
<div style="width:100%; height:100%; overflow-y: auto;overflow-x: auto;">
<form id="theform" name="theform" action="<html:link renderURL='/edocController.do?method=finishWorkItem' />"
      method="post" style='margin: 0px' onsubmit="return false">
      <div id="contentAttachmentInputs" style="display:none;"></div>
<div style="display:none" id="processModeSelectorContainer">
</div>
<input type="hidden" id="ajaxUserId" name="ajaxUserId" value="${currentUserId} "/>
<input type="hidden" id="affair_id" name="affair_id" value="${param.affairId}"/>      
<input type="hidden" id="summary_id" name="summary_id" value="${param.summaryId}"/>
<input type="hidden" name="startMemberId" value="${summary.startMember.id}"/>
<input type="hidden" name="appName" id="appName" value='<%=ApplicationCategoryEnum.edoc.getKey()%>'/>
<input type="hidden" name="policy" value="${nodePermissionPolicyKey}"/>
<input type="hidden" name="edocType" value="${summary.edocType}"/>
<input type="hidden" id="archiveId" name="archiveId" value="${summary.archiveId}">
<input type="hidden" id="prevArchiveId" name="prevArchiveId" value="${summary.archiveId}">
<input type="hidden" name="supervisorId" id="supervisorId" value="${supervisorId}">
<input type="hidden" name="isDeleteSupervisior" id="isDeleteSupervisior" value="false">
<input type="hidden" name="orgSupervisorId" id="orgSupervisorId" value="${supervisorId}">
<input type="hidden" name="supervisors" id="supervisors" value="${supervisors}">
<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${unCancelledVisor }">
<input type="hidden" name="sVisorsFromTemplate" id="sVisorsFromTemplate" value="${sVisorsFromTemplate}">
<input type="hidden" name="awakeDate" id="awakeDate" value="${awakeDate}">
<input type="hidden" name="superviseTitle" id="superviseTitle" value="${superviseTitle}">
<input type="hidden" name="processId" id="processId" value="${summary.processId}">
<input type="hidden" name="caseId" id="caseId" value="${summary.caseId }">
<input type="hidden" name="count" id="count" value="${count}"/>
<input type="hidden" name="disPosition" value="${disPosition}"/>
<input type="hidden" name="redForm" id="redForm" value="false">
<input type="hidden" name="redContent" id="redContent" value="false"/>
<input type="hidden" id="currentLoginAccountId" name="currentLoginAccountId" value="${v3x:currentUser().loginAccount}">

<%--PDF--%>
<INPUT type="hidden"  NAME="isConvertPdf"   id="isConvertPdf" value="" />
<INPUT type="hidden"  NAME="newPdfIdFirst"  id="newPdfIdFirst" value="" />
<INPUT type="hidden"  NAME="newPdfIdSecond" id="newPdfIdSecond" value="" />

<input type="hidden" id="process_xml" name="process_xml" value=""/>
<input type="hidden" name="process_desc_by" id="process_desc_by" value="xml" />
<input type="hidden" name="currentNodeId" value="${currentNodeId }" />
<!-- 将isMatch缺省值为true，判断是否最后一个处理人在preSend中 -->
<input type="hidden" name="isMatch" id="isMatch" value="true" />
<!-- 暂存待办的意见ID -->
<input type="hidden" name="oldOpinionId" value="${tempOpinion.id}" />
<input type="hidden" name="__ActionToken" readonly value="SEEYON_A8" > <%-- post提交的标示，先写死，后续动态 --%>

<input type="hidden" name="bodyType" id="bodyType" value="${param.bodyType}">

<script type="text/javascript">
	document.getElementById("process_xml").value = caseProcessXML;
</script>

<v3x:selectPeople id="wf" panels="Department,Team" selectType="Department,Team,Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="selectInsertPeople(elements)" viewPage="selectNode4Workflow"/>
<script type="text/javascript">var hiddenMultipleRadio_wf = true;</script>
<v3x:selectPeople id="colAssign" panels="Department,Team,Post" selectType="Department,Team,Post,Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="selectColAssign(elements)"/>
<v3x:selectPeople id="addInform" panels="Department,Team,Post" selectType="Department,Team,Post,Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="selectAddInform(elements)"/>
<v3x:selectPeople id="passRead" panels="Department,Team" selectType="Account,Department,Team,Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="selectPassRead(elements)" targetWindow="parent.detailMainFrame" isAutoClose="false"/>
<v3x:selectPeople id="addMoreSign" panels="Department" selectType="Department,Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="addMoreSignResult(elements)" targetWindow="parent.detailMainFrame" isAutoClose="false"/>
<script>
    var exMems = new Array();
	exMems = exMems.concat(parseElements("${v3x:parseElementsOfIds(supervisorIds, 'Member')}"));
	excludeElements_sv = exMems;
	//传阅知会，不回现选择数据
	showOriginalElement_addInform=false;
	showOriginalElement_passRead=false;
	showOriginalElement_addMoreSign=false;
	
</script>
<v3x:selectPeople id="sv" panels="Department" selectType="Member"
                  departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                  jsFunction="sv(elements)"/>
<script>
onlyLoginAccount_flash=true;
onlyLoginAccount_wf=true;
onlyLoginAccount_colAssign=true;
//onlyLoginAccount_addInform=true;
//onlyLoginAccount_passRead=true;
onlyLoginAccount_sv=true;
//onlyLoginAccount_addMoreSign=true;

var unallowedSelectEmptyGroup_colAssign = true;
var unallowedSelectEmptyGroup_addInform = true;
var hiddenRootAccount_addInform = true;
//hiddenWhenRootAccount
</script>
<input type="hidden" name="affairId" value="${param.affairId}"/>
<span id="selectPeoplePanel"></span>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sign-area">
<tr>
    <td height="35"><br>
    	<c:set value="${v3x:_(pageContext, nodePermissionPolicy.label)}" var="perLocalName"/>
        <fmt:message key="node.permission.label"/>${perLocalName==""?nodePermissionPolicyKey:perLocalName}
        <br>
        <br>
    </td>
    <td align="right"><c:set var="hasAdvanceButton" value="no"/>
    <c:set var="buttonNum" value="0" /> <!-- 控制6个后换行 -->
        <div id="processAdvanceDIV" oncontextmenu="return false" onMouseOver="advanceViews(true)" onMouseOut="advanceViews(false);"
             style="position:absolute; right:2px; top:30px; width:240px; z-index:2; background-color: #e3f2fb; display:none;overflow-x:auto;">
            <!--
            <div class="div-float cursor-hand" onclick="advanceViews()"><img
                    src="<c:url value='/common/images/attachmentICON/delete.gif' />" border=0></div>
            -->
          <c:forEach items="${advancedActions}" var="aoperation">
            <c:if test="${'AddNode' eq aoperation }">
            <c:set var="buttonNum" value="${buttonNum+1}" />               
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>                    
                    <a href="javascript:preInsertPeople('${param.summaryId}','${summary.processId}','${param.affairId}','${summary.edocType}','false')">
                            <span class="dealicons-advance insertPeople"></span>
                            <div></div>
                            <fmt:message key="insertPeople.label"/></a>
            </div>
            </c:if>
           <c:if test="${'SuperviseSet' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:set var="buttonNum" value="${buttonNum+1}" />              
			<div class="div-float processAdvanceICON">		
					<c:set var="hasAdvanceButton" value="yes"/>
					<a href="javascript:openSuperviseWindow('${param.summaryId}')">
                    <span class="dealicons-advance supervise"></span>
                    <div></div>
                    <fmt:message key="col.supervise.operation.label" bundle="${colI18N}"/></a>
			</div>
			</c:if>
            <c:if test="${'UpdateForm' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:set var="buttonNum" value="${buttonNum+1}" />              
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:parent.detailMainFrame.contentIframe.UpdateEdocForm('${param.summaryId}')">
                            <span class="dealicons-advance updateform"></span>
                            <div></div>
                            <fmt:message key="node.policy.updateform.label"/></a>
            </div>
            </c:if>
            <c:if test="${'Edit' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:set var="buttonNum" value="${buttonNum+1}" />               
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>                    
                    <a href="javascript:updateContent('${param.summaryId}')">
                            <span class="dealicons-advance editContent"></span>
                            <div></div>
                            <fmt:message key="editContent.label"/></a>
            </div>
            </c:if>
        	<%--  修改附件--%>
        	<c:if test="${'allowUpdateAttachment' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
        	<c:set var="buttonNum" value="${buttonNum+1}" /> 
			<div class="div-float processAdvanceICON">
        		 	<c:set var="hasAdvanceButton" value="yes"/>
            	 	<a href="javascript:updateAtt('${param.summaryId}','${summary.processId}')">
                             <span class="dealicons-advance updateAttachment"></span>
                             <div></div>
                            <fmt:message key="edoc.allowUpdateAttachment" bundle="${colI18N}"/></a>
            </div>
        	</c:if>
            <c:if test="${'RemoveNode' eq aoperation}">
            <c:set var="buttonNum" value="${buttonNum+1}" />         
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:preDeletePeople('${param.summaryId}','${summary.processId}','${param.affairId}')">
                             <span class="dealicons-advance deletePeople"></span>
                             <div></div>
                             <fmt:message key="deletePeople.label"/></a>
                
            </div>
            </c:if>
            <%--
            <c:if test="${v3x:containInCollection(advancedActions, 'Modify')}">
	        <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <img src="<c:url value='/apps_res/collaboration/images/commonPhrase.gif' />" border="0"
                            align="absmiddle" with="16"><br><fmt:message key="modify.label" bundle="${colI18N}"/>
            </div>  
            </c:if>
            <c:if test="${v3x:containInCollection(advancedActions, 'ApproveSubmit')}">
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <img src="<c:url value='/apps_res/collaboration/images/commonPhrase.gif' />" border="0"
                            align="absmiddle" with="16"><br><fmt:message key="approveSubmit.label" bundle="${colI18N}"/>
            </div>
            </c:if>
            --%>            
            <c:if test="${'Forward' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>
            <c:set var="buttonNum" value="${buttonNum+1}" />                
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:transmitSend('${param.summaryId}','${param.affairId}','${summary.edocType}');">
                             <span class="dealicons-advance transmit"></span>
                            <div></div>
                            <fmt:message key='common.toolbar.transmit.label' bundle='${v3xCommonI18N}' />
                    </a>
            </div>
            </c:if>
            <c:if test="${'WordNoChange' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                 <c:set var="hasAdvanceButton" value="yes"/>
                   <a href="javascript:parent.detailMainFrame.contentIframe.WordNoChange()">
                            <span class="dealicons-advance wordNoChange"></span>
                            <div></div>
                            <fmt:message key="wordNoChange.label" bundle="${colI18N}"/>
                  </a>
            </div>
            </c:if>
            <c:if test="${'EdocTemplate' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                 <c:set var="hasAdvanceButton" value="yes"/>
                   <a href="javascript:parent.detailMainFrame.contentIframe.taohong('edoc')">
                            <span class="dealicons-advance loadRedTemplate"></span>
                            <div></div>
                            <fmt:message key="edoc.action.form.template" />
                   </a>
            </div>
            </c:if>
            <c:if test="${'Return' eq aoperation}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON" id="stepBackSpan">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:stepBack(document.theform)">
                            <span class="dealicons-advance stepBack"></span>
                            <div></div>
                            <fmt:message key="stepBack.label" bundle="${colI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'JointSign' eq aoperation}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:preColAssign('${param.summaryId}','${summary.processId}','${param.affairId}')">
                            <span class="dealicons-advance colAssign"></span>
                            <div></div>
                            <fmt:message key="colAssign.label" bundle="${colI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'Infom' eq aoperation}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:addInform('${param.summaryId}','${summary.processId}','${param.affairId}');">
                            <span class="dealicons-advance addInform"></span>
                            <div></div>
                            <fmt:message key="addInform.label" bundle="${colI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'moreSign' eq aoperation }">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:addMoreSign('${param.summaryId}','${summary.processId}','${param.affairId}');"><img
                            src="<c:url value='/apps_res/collaboration/images/addMoreSign.gif' />" border="0"
                            align="absmiddle" height="14"><br><fmt:message key="edoc.metadata_item.moreSign" bundle="${colI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'Terminate' eq aoperation}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON" id="stepStopSpan">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:stepStop(document.theform);">
                            <span class="dealicons-advance stepStop"></span>
                            <div></div>
                            <fmt:message key="stepStop.label" bundle="${colI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'Cancel' eq aoperation}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
					<a href="javascript:repealItem('pending','${param.summaryId}')">
				        <span class="dealicons-advance repeal"></span>
				        <div></div>
				        <fmt:message key="repeal.2.label" bundle="${colI18N}"/></a>
			</div>
	    	</c:if>
            <c:if test="${'Sign' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:parent.detailMainFrame.contentIframe.openSignature()"  title="<fmt:message key="comm.sign.introduce.label" bundle="${v3xCommonI18N}"/>">
                            <span class="dealicons-advance signature"></span>
                            <div></div>
                            <fmt:message key="node.policy.Sign.label" bundle="${v3xCommonI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'DepartPigeonhole' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:DepartPigeonhole(<%=ApplicationCategoryEnum.edoc.getKey()%>,'${param.summaryId}')">
                            <span class="dealicons-advance departpigeonhole"></span>
                            <div></div>
                            <fmt:message key="edoc.action.DepartPigeonhole.label"/></a>
            </div>
            </c:if>
            <c:if test="${'ScriptTemplate' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:parent.detailMainFrame.contentIframe.taohong('script')">
                            <span class="dealicons-advance scriptTemplate"></span>
                            <div></div>
                            <fmt:message key="edoc.action.script.template" /></a>
            </div>
            </c:if>
            <c:if test="${'PassRead' eq aoperation}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>                
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:addPassInform('${param.summaryId}','${summary.processId}','${param.affairId}');">
                            <span class="dealicons-advance passred"></span>
                            <div></div>
                            <fmt:message key="node.policy.chuanyue" bundle="${v3xCommonI18N}"/></a>
            </div>
            </c:if>
            <c:if test="${'HtmlSign' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>    
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:htmlSign();">
                            <span class="dealicons-advance htmlSign"></span>
                            <div></div>
                            <fmt:message key="edoc.action.htmlSign.label"/></a>
            </div>
            </c:if>
            
            <c:if test="${'TransmitBulletin' eq aoperation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <c:if test="${buttonNum !=0 && buttonNum % 5 ==0 }"><div style="clear:both"></div></c:if>    
            <c:set var="buttonNum" value="${buttonNum+1}" />
            <div class="div-float processAdvanceICON">
                    <c:set var="hasAdvanceButton" value="yes"/>
                    <a href="javascript:TransmitBulletin('bulletionaudit','${param.summaryId}');">
                            <span class="dealicons-advance transmitBulletin"></span>
                            <div></div>
                            <fmt:message key="edoc.metadata_item.TransmitBulletin"  bundle="${colI18N}"  /></a>
            </div>
            </c:if>
           </c:forEach>
           <div style="clear: both; width: 100%; text-align: right;padding: 0 5px 5px 0">
              <a href="javascript:closeAdvance()"><fmt:message key="common.button.close.label"  bundle="${v3xCommonI18N}" /></a>
           </div>
        </div>
        <c:if test="${hasAdvanceButton eq 'yes'}">
            <div id='processAdvance' onClick="advanceViews()" class="cursor-hand">&lt;&lt;&nbsp;<fmt:message
                    key='common.advance.label' bundle="${v3xCommonI18N}"/></div>
        </c:if>
    </td>
</tr>
<tr>
    <td colspan="2" id="dealTD">
    	<c:forEach items="${commonActions}" var="operation">
	        <c:if test="${'AddNode' eq operation}">
				<a class="like-a div-float padding5 deal-margin" href="javascript:preInsertPeople('${param.summaryId}','${summary.processId}','${param.affairId}','${summary.edocType}','false')">
	            <span class="dealicons insertPeople"></span>
	            <fmt:message key="insertPeople.label" bundle="${colI18N}"/>
	            </a>
	        </c:if>
	        <c:if test="${'JointSign' eq operation}">
				<a class="like-a div-float padding5 deal-margin" href="javascript:preColAssign('${param.summaryId}','${summary.processId}','${param.affairId}')">
	            <span class="dealicons colAssign"></span>
	            <fmt:message key="colAssign.label" bundle="${colI18N}"/>
	            </a>
	        </c:if>
	        <c:if test="${'Return' eq operation}">
				<span class="like-a div-float padding5 deal-margin" id="stepBackSpan" onclick="javascript:stepBack(document.theform)">
	            <span class="dealicons stepBack"></span>
	            <fmt:message key="stepBack.label" bundle="${colI18N}"/>
	            </span>
	        </c:if>
	        <c:if test="${'RemoveNode' eq operation}">
				<a class="like-a div-float padding5 deal-margin" href="javascript:preDeletePeople('${param.summaryId}','${summary.processId}','${param.affairId}')">
	            <span class="dealicons deletePeople"></span>
	            <fmt:message key="deletePeople.label" bundle="${colI18N}"/>
	            </a>
	        </c:if>
	        <c:if test="${'Edit' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
	        	<a class="like-a div-float padding5 deal-margin" href="javascript:updateContent('${param.summaryId}')">
	            <span class="dealicons editContent"></span>
	            <fmt:message key="editContent.label" bundle="${colI18N}"/>
	            </a>
	        </c:if>
	        <%--  修改附件--%>
	        <c:if test="${'allowUpdateAttachment' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
	        	<a class="like-a div-float padding5 deal-margin" href="javascript:updateAtt('${param.summaryId}','${summary.processId}')">
	            <span class="dealicons updateAttachment"></span>
	            <fmt:message key="edoc.allowUpdateAttachment" bundle="${colI18N}"/>
	            </a>
	        </c:if>
	        <c:if test="${'Infom' eq operation}">
				 <a class="like-a div-float padding5 deal-margin" href="javascript:addInform('${param.summaryId}','${summary.processId}','${param.affairId}');">
	             <span class="dealicons addInform"></span>
	             <fmt:message key="addInform.label" bundle="${colI18N}"/>
	             </a>
	        </c:if>
	        
	        <c:if test="${'moreSign' eq operation }">
				<a class="like-a div-float padding5 deal-margin" href="javascript:addMoreSign('${param.summaryId}','${summary.processId}','${param.affairId}');">
				<span class="dealicons multyAssign"></span>
	            <fmt:message key="edoc.metadata_item.moreSign" bundle="${colI18N}"/>
	            </a>
	        </c:if>
			<c:if test="${'Terminate' eq operation}">
				<span class="like-a div-float padding5 deal-margin" id="stepStopSpan" onclick="javascript:stepStop(document.theform)">
		        <span class="dealicons stepStop"></span>
		        <fmt:message key="stepStop.label" bundle="${colI18N}"/>
		        </span>
			</c:if>
			<c:if test="${'Cancel' eq operation}">
				<a class="like-a div-float padding5 deal-margin" href="javascript:repealItem('pending','${param.summaryId}')">
		        <span class="dealicons repeal"></span>
		        <fmt:message key="repeal.2.label"  bundle="${colI18N}"/>
		        </a>
		    </c:if>
			<c:if test="${'Forward' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:transmitSend('${param.summaryId}','${param.affairId}','${summary.edocType}');">
				         <span class="dealicons transmit"></span>
				        <fmt:message key='common.toolbar.transmit.label' bundle='${v3xCommonI18N}' />
				        </a>
			</c:if>
	        <c:if test="${'WordNoChange' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:parent.detailMainFrame.contentIframe.WordNoChange()">
				        <span class="dealicons wordNoChange"></span>
				        <fmt:message key="wordNoChange.label" bundle="${colI18N}"/>
				        </a>
	        </c:if>		
			<c:if test="${'ApproveSubmit' eq operation}">
				        <span class="dealicons approveSubmit"></span>
				        <fmt:message key="approveSubmit.label" bundle="${colI18N}"/>
			</c:if>
			<%--
			<c:if test="${v3x:containInCollection(commonActions, 'Modify')}">
						<img src="<c:url value='/apps_res/collaboration/images/workflowstop.gif' />" border="0" 
				        align="absmiddle" with="16">
				        <fmt:message key="modify.label" bundle="${colI18N}"/>
			</c:if>
			--%>
			<c:if test="${'UpdateForm' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:parent.detailMainFrame.contentIframe.UpdateEdocForm('${param.summaryId}')">
				        <span class="dealicons updateform"></span>
				        <fmt:message key="node.policy.updateform.label"/>
				        </a>
			</c:if>
			<c:if test="${'Sign' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:parent.detailMainFrame.contentIframe.openSignature()" title="<fmt:message key="comm.sign.introduce.label" bundle="${v3xCommonI18N}"/>">
				        <span class="dealicons signature"></span>
				        <fmt:message key="node.policy.Sign.label" bundle="${v3xCommonI18N}"/>
				        </a>
			</c:if>
			<c:if test="${'DepartPigeonhole' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:DepartPigeonhole(<%=ApplicationCategoryEnum.edoc.getKey()%>,'${param.summaryId}')">
				        <span class="dealicons departpigeonhole"></span>
				        <fmt:message key="edoc.action.DepartPigeonhole.label"/>
				        </a>
			</c:if>
			<c:if test="${'EdocTemplate' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
	        			<a class="like-a div-float padding5 deal-margin" href="javascript:parent.detailMainFrame.contentIframe.taohong('edoc')">
	                    <span class="dealicons loadRedTemplate"></span>
	                    <fmt:message key="edoc.action.form.template" />
	                    </a>
	        </c:if>
			<c:if test="${'ScriptTemplate' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
	        			<a class="like-a div-float padding5 deal-margin" class="like-a" href="javascript:parent.detailMainFrame.contentIframe.taohong('script')">
	                    <span class="dealicons scriptTemplate"></span>
	                    <fmt:message key="edoc.action.script.template" />
	                    </a>
	        </c:if>
	        <c:if test="${'PassRead' eq operation}">
	        					<a class="like-a  div-float padding5 deal-margin" href="javascript:addPassInform('${param.summaryId}','${summary.processId}','${param.affairId}');">
	                            <span class="dealicons passred"></span>
	                            <fmt:message key="node.policy.chuanyue" bundle="${v3xCommonI18N}"/>
	                            </a>
	        </c:if>
	        <c:if test="${'HtmlSign' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
	        			<a class="like-a  div-float padding5 deal-margin" href="javascript:htmlSign()">
	                    <span class="dealicons htmlSign"></span>
	                    <fmt:message key="edoc.action.htmlSign.label" />
	                    </a>
	        </c:if>
			<c:if test="${'SuperviseSet' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:openSuperviseWindow('${param.summaryId}')">
	                    <span class="dealicons supervise"></span>
	                    <fmt:message key="col.supervise.operation.label" bundle="${colI18N}" />
	                    </a>
			</c:if>
			<c:if test="${'TransmitBulletin' eq operation && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
						<a class="like-a div-float padding5 deal-margin" href="javascript:TransmitBulletin('bulletionaudit','${param.summaryId}')">
	                    <span class="dealicons transmitBulletin"></span>
	                    <fmt:message key="edoc.metadata_item.TransmitBulletin" bundle="${colI18N}" />
	                    </a>
			</c:if>
		</c:forEach>
    </td>
</tr>
<tr>
    <td colspan="2" class="separatorDIV"></td>
</tr>
<tr>
    <td height="30" colspan="2">
        <c:if test="${attitudes != 3}">
        	<c:set var="enclude" value="${attitudes==2?'1':'' }"/>
        	<c:set var="select" value="${attitudes==2?'2':'1' }"/>
            <v3x:metadataItem metadata="${colMetadata['collaboration_attitude']}" showType="radio" name="attitude"
	                              selected="${draftOpinion == null ? select : draftOpinion.attitude}" enclude="${enclude }"/>
	     </c:if>

        <c:if test="${v3x:containInCollection(baseActions, 'CommonPhrase')}">
            <a href="javascript:showPhrase(this)" style="float: right;"><img
                    src="<c:url value='/apps_res/collaboration/images/commonPhrase.gif' />" border="0" align="absmiddle"
                    with="16"><fmt:message key="commonPhrase.label"/></a>
        </c:if>
    </td>
</tr>

<c:if test="${v3x:containInCollection(baseActions, 'Opinion')}">
<input type="hidden" id="opinionPolicy" name="opinionPolicy" value="${opinionPolicy}" />
<input type="hidden" id="cancelOpinionPolicy" name="cancelOpinionPolicy" value="${cancelOpinionPolicy}" />
<input type="hidden" id="disAgreeOpinionPolicy" name="disAgreeOpinionPolicy" value="${disAgreeOpinionPolicy}" />
    <tr>
        <td colspan="2"><textarea name="content" rows="10" style="width: 100%" validate="maxLength"
                                  inputName="<fmt:message key="common.opinion.label" bundle="${v3xCommonI18N}" />" maxSize="2000">${tempOpinion.content}</textarea></td>
    </tr>
    <tr>
        <td colspan="2" height="8"></td>
    </tr>
    <!--
    <tr>
        <td colspan="2" height="${param.openLocation=='detailFrame'? '24':'36'}">
        <table border=0>
        <tr><td>
        <div style="display:none">
            <label for="isHidden">
                <input type="checkbox" name="isHidden" id="isHidden"><fmt:message key="common.opinion.hidden.label" bundle="${v3xCommonI18N}" />
            </label>
        </div>
        </td></tr>
            </table>
        </td>
    </tr>
    -->
</c:if>
<tr>
    <td colspan="2">
        <c:if test="${v3x:containInCollection(baseActions, 'Track') && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <label for="track">
                <input type="checkbox" name="afterSign" id="track" value="track" onclick="checkMulitSign(this)" ${affair.isTrack?'checked':''}><fmt:message key="track.label"/>
            </label>
        </c:if>
        <c:if test="${v3x:containInCollection(baseActions, 'Archive')}">
        	<c:if test="${v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
            <label for="pipeonhole">
                <input type="checkbox" name="afterSign" id="pipeonhole" value="pipeonhole" onclick="checkMulitSign(this)" 
                	${nodePermissionPolicyKey eq 'fengfa'?"checked":""}
                	<c:if test="${!canArchive}">disabled</c:if>>
                	<fmt:message key="sign.after.pipeonhole.label"/>
                	&nbsp;&nbsp;&nbsp;&nbsp;
                	
                	
            </label>
            </c:if>
            <%--封发 并且设置了预归档路径--%>
            <c:set var="isShowPrepigenholePath" value="${nodePermissionPolicyKey eq 'fengfa' and summary.archiveId ne null and isPresPigeonholeFolderExsit}"/>
            <c:set var="archiveIdIsNull" value="${summary.archiveId eq null }"/>
            <c:set var="presPigeonholeFolderNotExsit" value="${summary.archiveId ne null and not isPresPigeonholeFolderExsit}"/>
            <c:set var="isShowSelectpigenholePath" value="${nodePermissionPolicyKey eq 'fengfa' and (archiveIdIsNull or presPigeonholeFolderNotExsit ) }"/>
           
            <%--设置了预先归档。则直接显示 --%>
            <span id="showPrePigeonhole" style="display:${isShowPrepigenholePath?"":"none"}">
           		<fmt:message key="prep-pigeonhole.label" /> : &nbsp;${archiveFullName}
            </span>
            <%--没有设置预归档，需要手动选择 --%>
            <span id="showSelectPigeonholePath" style="display:${isShowSelectpigenholePath?"":"none"}">
             	<fmt:message key="prep-pigeonhole.label" /> : &nbsp;
             	<select id="selectPigeonholePath" class="input-40per" onchange="pigeonholeEvent(this,'<%=ApplicationCategoryEnum.edoc.key()%>','finishWorkItem',this.form)">
			    	<option id="defaultOption" value="1"><fmt:message key="common.default" bundle="${v3xCommonI18N}"/></option>   
			    	<option id="modifyOption" value="2">${v3x:_(pageContext, 'click.choice')}</option>
			    	<c:if test="${archiveName ne null && archiveName ne ''}" >
			    		<option value="3" selected>${archiveName}</option>
			    	</c:if>
		   		</select>
            </span>
        </c:if>
        <!--
        <c:if test="${v3x:containInCollection(baseActions, 'Delete')}">
            <label for="delete">
                <input type="checkbox" name="afterSign" id="delete" value="delete" onclick="checkMulitSign(this)"><fmt:message
                    key="sign.after.delete.label"/>
            </label>
        </c:if>
          -->
    </td>
</tr>
<c:if test="${v3x:containInCollection(baseActions, 'EdocExchangeType')}">
<tr>
<td colspan="1">
<label for="edocExchangeType_depart">
                <input type="radio" name="edocExchangeType" id="edocExchangeType_depart"  onclick="hideMemberList()" value="<%=Constants.C_iExchangeType_Dept%>" checked><fmt:message
                    key="edoc.exchangetype.department.label"/>
</label>
</td>
</tr>
<tr>
<td>
<label for="edocExchangeType_company">
                <input type="radio" name="edocExchangeType" id="edocExchangeType_company" onclick="showMemberList()" value="<%=Constants.C_iExchangeType_Org%>" <%=(EdocSwitchHelper.getDefaultExchangeType()==Constants.C_iExchangeType_Org?"checked":"")%>><fmt:message
                    key="edoc.exchangetype.company.label"/>
</label>
</td>
<td colspan="1">
	<div id="selectMemberList" style="display:none;">
		<select name="memberList" class="condition" style="width: 115px">
			<option value=""><fmt:message key="select.label.unitEdocOper"/></option>
			<c:forEach items="${memberList}" var="member">
			 	<option value="${member.user.id}">${v3x:toHTML(member.user.name)}</option>
			</c:forEach>
		</select>
	</div>
</td>
</tr>
<tr>
    <td colspan="2" height="4"></td>
</tr>
</c:if>
<c:set var="canUploadRel" value="${v3x:containInCollection(baseActions, 'UploadRelDoc')}"/>
<c:set var="canUploadAttachment" value="${v3x:containInCollection(baseActions, 'UploadAttachment')}"/>
<div id="attachmentEditInputs"></div>
<c:if test="${canUploadRel || canUploadAttachment}">
            	<tr><td colspan="2" style="padding: 5px 10px;">
            	<div height="36">
            	<c:if test="${canUploadRel }">
                <a href="javascript:quoteDocument()"><fmt:message key="common.toolbar.insert.mydocument.label"  bundle="${v3xCommonI18N}"/></a>
                (<span id="attachment2NumberDiv">0</span>)
                &nbsp;&nbsp;
                </c:if>
                <c:if test="${canUploadAttachment && v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
                	 <a href="javascript:insertAttachment()"><fmt:message key="common.toolbar.insertAttachment.label" bundle="${v3xCommonI18N}"/></a>
                	 (<span id="attachmentNumberDiv">0</span>)
                </c:if>
                </div>
                </td></tr>
                <tr><td colspan="2">
                <div id="attachment2Area" style="overflow: auto;"></div>
                <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" originalAttsNeedClone="false" />
                </td></tr>
            </c:if>
<tr>
    <td colspan="2" class="separatorDIV" height="2"></td>
</tr>
<tr>
    <td colspan="2" align="right" class="col-process" height="30" id="doSignTr">
        <input id="processButton" type="button" onclick="edocSubmitForm(this.form,'${param.summaryId}')"
               value='<fmt:message key="common.button.submit.label" bundle="${v3xCommonI18N}" />'
               class="button-default_emphasize">
        <c:if test="${v3x:containInCollection(baseActions, 'Comment')}">
            <input id="zcdbButton" type="button" value='<fmt:message key="zancundaiban.label" />'
                   class="button-default-4" onclick="doZcdb(this,'${param.summaryId}')">
        </c:if>&nbsp;
    </td>
</tr>
</table>
</form>
</div>
</td>
</tr>
</c:if>
<tr id="workflowTR" style="display: none">
    <td colspan="3">
    	 <c:choose>
    	 	<c:when test="${isSupervis == true && from == 'supervise' && finished!=true}">
		    	 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		    		<tr><td height="30" align="left" valign="middle" class="padding-5"><c:if test="${v3x:getBrowserFlagByRequest('WorkFlowEdit', pageContext.request)}"><input type="button" onclick="showDigarm('${bean.id}');" value="<fmt:message key="edit.workflow.label" bundle="${colI18N}"/>"/></c:if></td></tr>
		    		<tr>
			    		<td>
			    			<div class="scrollList">
					        <iframe src="${supervise}?method=showDigramOnly&edocId=${param.summaryId}&superviseId=${bean.id}&fromList=list" name="monitorFrame" id="monitorFrame"
					                frameborder="0" marginheight="0" marginwidth="0" height="100%" width="100%" scrolling="auto"></iframe>
			    			</div>
			    		</td>
		    		</tr>
		    	</table>
    	 	</c:when>
    	 	<c:otherwise>
	        <iframe src="<html:link renderURL='/genericController.do?ViewPage=collaboration/monitor&isShowButton=${isShowButton}' />" name="monitorFrame"
	                frameborder="0" marginheight="0" marginwidth="0" height="100%" width="100%" scrolling="auto"></iframe>
    	 	</c:otherwise>
    	 </c:choose>
    </td>
</tr>
<c:if test="${isSupervis == true && from == 'supervise'}">
	<tr id="supervisTR" style="display: none">
	    <td colspan="3">
	       <iframe src="${edoc}?method=superviseDiagram&summaryId=${param.summaryId}&openModal=${openModal}" name="superviseIframe"  id="superviseIframe"  frameborder="0" marginheight="0" marginwidth="0" height="100%" width="100%" scrolling="auto"></iframe>
	    </td>
	</tr>
</c:if>
		
	</table></div></td>
  </tr>	
</table>
<div id="formContainer" style="display:none"></div>  
<iframe name="showDiagramFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
<c:choose>
	<c:when test="${param.preAction eq 'insertPeople' || param.preAction eq 'deletePeople' || param.preAction eq 'stepBack' || param.preAction eq 'takeBack' || param.preAction eq 'colAssign' || param.preAction eq 'addInform' }">
	    changeLocation(panels.get(1).id);
	    showPrecessArea();
	</c:when>
	<c:when test="${hasSignButton == true}">
		changeLocation("sign");
		showPrecessArea();
	</c:when>
</c:choose>
var edocExchangeFlagObj = "${v3x:containInCollection(baseActions, 'EdocExchangeType')}";
if(edocExchangeFlagObj=="true"){
	//封发节点和【交换类型】节点权限都显示
if ((permKey == "fengfa")||(edocExchangeFlagObj=="true")) {
 var companyRadioObj = document.getElementById("edocExchangeType_company");
	  if(companyRadioObj!=null && companyRadioObj.checked){
	  	showMemberList();
	  }
	}
}
</script>
</body>
</html>