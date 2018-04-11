<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../edocHeader.jsp"%>
<title><fmt:message key="showDiagram.title" /></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>

<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel"/>
<script type="text/javascript">
<!--
var hasDiagram = <c:out value="${hasDiagram}" default='false' />;        
var caseProcessXML = "${caseProcessXML}";
var caseLogXML = "";
var caseWorkItemLogXML = "";
var currentNodeId = "<c:out value='${currentNodeId}' escapeXml='true' />";        
var showMode = 0;
var showHastenButton = "<c:out value='${showHastenButton}' escapeXml='true' />";
var isTemplete = true;  
var affair_id = "";
var appName = "${appName}";      
var contentType = "${contentType}";

var panels = new ArrayList();
<c:if test="${edocContentType!='text'}">
panels.add(new Panel("workflow", '<fmt:message key="workflow.label" />', "showPrecessArea()"));
</c:if>
//panels.add(new Panel("content", '<fmt:message key="common.toolbar.content.label" bundle="${v3xCommonI18N}" />', "popupContentWin()"));
//panels.add(new Panel("attribute", '<fmt:message key="common.attribute.label" bundle="${v3xCommonI18N}" />', "showPrecessArea()"));
//panels.add(new Panel("print", '${printLabel}', "showPrecessArea()"));

function init(){
}

function showContent(){
	if(parent && parent.detailMainFrame && parent.detailMainFrame.contentIframe){
		if((contentType != 'HTML' && parent.detailMainFrame.contentIframe.officeEditorFrame && parent.detailMainFrame.contentIframe.hasLoadOfficeFrameComplete()) || contentType == 'HTML'){
			parent.detailMainFrame.contentIframe.popupContentWin();
			return;
		}
	}
	alert(v3x.getMessage("edocLang.templete_alertWaiting"));
}

//分枝 开始
//分支
	var branchs = new Array();
	var keys = new Array();
	var team = new Array();
	var secondpost = new Array();
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
				branch.conditionDesc = handworkCondition;*/
			branch.isForce = "${branch.isForce}";
			eval("branchs["+${branch.linkId}+"]=branch");
			keys[${status.index}] = ${branch.linkId};
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
//分枝 结束

<c:if test="${pageFlag == 'workflowAnalysisz'}">
	if(document.readyState != 'complete')
		 setTimeout("showWorkFlowXml()",10);
		 
	function showWorkFlowXml() {
		 document.getElementById("workflowTR").style.display='block';
		 showPrecessArea();
	}
</c:if>

//-->
</script>

</head>
<body onload="init()" scroll="no" class="precss-scroll-bg">

<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel" />

<div oncontextmenu="return false" style="position:absolute; right:20px; top:100px; width:260px; height:60px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;" id="divPhrase" onMouseOver="" onMouseOut="">
	<IFRAME width="100%" id="phraseFrame" name="phraseFrame" height="100%" frameborder="0" src="" align="middle" scrolling="no" marginheight="0" marginwidth="0"></IFRAME>
</div>

<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
	<script type="text/javascript">try{showMinPanels();}catch(e){}</script>
	<c:if test="${edocContentType!='workflow'}">
	<div class="sign-min-label" onclick="showContent()" title="<fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' />"><fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' /></div><div class="separatorDIV"></div>
	<div class="sign-min-label" onclick="colPrint()" title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></div><div class="separatorDIV"></div>
	</c:if>
</div>

<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0" class="sign-button-bg">
  <c:if test="${pageFlag != 'workflowAnalysisz'}">
  	 <tr>
	    <td height="25" valign="top" nowrap="nowrap" class="sign-button-bg" >
			<script type="text/javascript">try{showPanels();}catch(e){}</script>
			<c:if test="${edocContentType!='workflow'}">
				<div class="sign-button-L"></div>
				<div id='buttonContent' onClick="showContent()" class="sign-button-M"><fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' /></div><div class="sign-button-R"></div><div class="sign-button-line"></div>
				<div class="sign-button-L"></div>
				<div onclick="colPrint()" class="sign-button-M"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></div><div class="sign-button-R"></div><div class="sign-button-line"></div>
			</c:if>
		</td>
		<td width="8%" align="right" style="padding-right: 10px">
		<!--
		<img src="<c:url value='/common/images/toolbar/edoccontent.gif' />" alt="<fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' />" onclick='parent.detailMainFrame.contentIframe.popupContentWin()' class="cursor-hand">
		-->
		</td>
		<!-- 
		    <td width="8%" align="right" style="padding-right: 10px">
		    <span onclick="colPrint()" class="cursor-hand coll_print  div-float-right"></span>
		    </td> 
		 -->
	  </tr> 
  </c:if>
  <tr id="closeTR" style="display: none" valign="top">
  	<td>&nbsp;</td>
  </tr>
    <tr id="workflowTR" style="display: none">
    <td   colspan="3">
        <%-- 不是格式模板，就显示流程图 --%>
        <c:if test="${edocContentType != 'text'}">
		<iframe src="<html:link renderURL='/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=false&processId=${workflowId}' />" name="monitorFrame" frameborder="0" marginheight="0" marginwidth="0" height="100%" width="100%" scrolling="auto"></iframe>
	    </c:if>
    </td>
  </tr>	
  <tr    id="attributeTR" style="display: none">
    <td colspan="3" valign="top"><div style="width:100%; height:100%; overflow-y: scroll"><table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td width="30%" class="attribute-left">${v3x:_(pageContext, "common.remind.time.label")}</td>
			<td width="70%" class="attribute-right"><input type="text" readonly="readonly" value='<v3x:metadataItemLabel metadata="${comMetadata}" value="" />' class="input-100per">
		</tr>
	  	<tr>
	  		<td class="attribute-left">${v3x:_(pageContext, "project.label")}</td>
	  		<td class="attribute-right"><input type="text" readonly="readonly" value="" class="input-100per"></td>
	  	</tr>
	  	<tr>
	  		<td class="attribute-left">${v3x:_(pageContext, "prep-pigeonhole.label")}</td>
	  		<td class="attribute-right"><input type="text" readonly="readonly" value="" class="input-100per"></td>
	  	</tr>
	  	<tr>
	  		<td class="attribute-left">${v3x:_(pageContext, "urger.label")}</td>
	  		<td class="attribute-right"><input type="text" readonly="readonly" value="" class="input-100per"></td>
	  	</tr>
	  	<tr>
	  		<td class="attribute-left">${v3x:_(pageContext, "collaboration.type.label")}</td>
	  		<td class="attribute-right"><input type="text" readonly="readonly" value="<fmt:message key='edoc.self.built'/>" class="input-100per"></td>
	  	</tr>
		<tr>
			<td colspan="2" class="separatorDIV" height="2"></td>
		</tr>		
	</table></div></td>
  </tr>	
</table>
</body>
</html>