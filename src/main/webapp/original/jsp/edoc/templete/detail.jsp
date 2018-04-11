<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<c:set value="${templete.type}" var="type" />
<STYLE type="text/css">
<!--
.contentText td, div
{
	font-family: Times New Roman;
	font-size: medium;
	line-height: normal;

	margin-top: auto;
	margin-bottom: auto;
}
-->
</STYLE>
<script type="text/javascript">
<!--
    var logoURL = "${logoURL}";
var hasDiagram = true;        
var caseProcessXML = "${workflow}";
var caseLogXML = "";
var caseWorkItemLogXML = "";
var showMode = 0;
var isTemplete = true;
var edocFormId="${formModel.edocFormId}";
var templeteType="${templete.type}";
var templeteBodyType="${templete.bodyType}";

var supervisorId="${colSupervisors }";
var supervisors="${colSupervise.supervisors }";
var unCancelledVisor="${colSupervisors }";
var sVisorsFromTemplate="${sVisorsFromTemplate}";
var awakeDate="${superviseDate}";
var superviseTitle="${v3x:escapeJavascript(colSupervise.title) }";

var panels = new ArrayList();

<c:if test="${type ne 'workflow'}">
panels.add(new Panel("bodytable", '<fmt:message key="templete.panel.bodytable.label" />'));
panels.add(new Panel("body", '<fmt:message key="templete.panel.body.label" />','pagecheckOpenState();'));
</c:if>
<c:if test="${type ne 'text'}">
panels.add(new Panel("workflow", '<fmt:message key="templete.panel.wf.label" />'));
panels.add(new Panel("description", '<fmt:message key="templete.panel.description.label" />'));
</c:if>
<%--
var workflowInfo = '<c:out value="${col:getWorkflowInfo(workflowInfo, nodePermissionPolicy, pageContext)}" escapeXml="true" />';
--%>
var workflowInfo = '';

function edocFormDisplay()
{
  if(templeteType!="workflow")
  {
    var xml = document.getElementById("xml");
    var xsl = document.getElementById("xslt");
    
  //设置修复字段宽度的传参
    window.fixFormParam = {"isPrint" : false, "reLoadSpans" : false};
    initReadSeeyonForm(xml.value,xsl.value);    	
    substituteLogo(logoURL);

    convertEdocMark("my:doc_mark");
    convertEdocMark("my:doc_mark2");
    convertEdocMark("my:serial_no");
    return false;
  }
}   

function pagecheckOpenState()
{//点击正文的时候，才真正调入office文件
	var officeOcxDiv=document.getElementById("edocContentDiv");
	if(officeOcxDiv!=null){officeOcxDiv.style.display="block";}
	if(templeteBodyType!="HTML"){
		try{
			checkOpenState();
		}catch(e){
		}
	}
}
 	
formOperation = "aa";


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

//处理升级后文号显示为 -8419626473303881442|bbwh|4|1 的问题
//目前只有这样特殊处理一下
function convertEdocMark(docmarkname){
	if(docmarkname){
	  var docmark = document.getElementById(docmarkname);
	  if(!docmark){
		  return;
	  }
	  if(docmark.value.trim()!= ""){
		  var arr = docmark.value.split("|");
		  if(arr.length == 4 ){
			  docmark.value = arr[1];
			  docmark.title = arr[1];
			  var docmarkDiv = document.getElementById(docmarkname+"_div");
			  if(!docmarkDiv){
				  return;
			  }
			  docmarkDiv.innerHTML=arr[1];
			  docmarkDiv.title=arr[1];
		  }
	  }
  	}
}

//-->
</script>
</head>

<body onkeypress="listenerKeyESC()" onload="edocFormDisplay();">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="sign-button-bg">
  
  <c:if test="${type ne 'workflow'}">
  <tr id="bodytableTR" style="background-color: #FFFFFF;" valign="top">
  	<td>
  		
  		    <div id="formAreaDiv">
			
			<div style="display:none;">
				<textarea id="xml" cols="40" rows="10">
				 ${formModel.xml}
         		</textarea>
			
         	</div>
         	<div style="display:none;">
         		<textarea id="xslt" cols="40" rows="10">
		   		${formModel.xslt}
				</textarea>
				
		    </div>
		    
		    <div id="html" name="html" style="border:1px solid;border-color:#FFFFFF;height:0px;"></div>
		    
		    <div id="img" name="img" style="height:0px;"></div>	 
			<div style="display:none">
			<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea>
			</div>
		 	
			</div>
  	</td>
  </tr>
  
  </c:if>
</table>
</body>
</html>