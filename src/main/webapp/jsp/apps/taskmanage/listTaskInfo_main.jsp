<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function initSelectedTab() {
  <c:if test="${param.from eq 'Project' || param.from eq 'Personal' || param.from eq 'Sent'}">
	setDefaultTab(0);
  </c:if>
}

function setDefaultTab(pos)
{
  var menuDiv=document.getElementById("menuTabDiv");
  var divs=menuDiv.getElementsByTagName("div");
  divs[pos*4].className=divs[pos*4].className+"-sel";
  divs[pos*4+1].className=divs[pos*4+1].className+"-sel";
  divs[pos*4+2].className=divs[pos*4+2].className+"-sel";
  var detailIframe=document.getElementById('detailIframe').contentWindow;
  detailIframe.location.href=divs[pos*4+1].getAttribute('url');
  
}

</script>
<title></title>
</head>
<body scroll="no" class="padding5" onLoad="initSelectedTab()">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <c:choose>
	    <c:when test="${param.from eq 'Project'}">
	       <%@ include file="projectInfo.jsp" %>
				<tr>
				   <td valign="bottom" height="26" class="tab-tag gov_noborder">
				       <div class="tab-separator"></div>
				       <div id="menuTabDiv" class="div-float">
				           <div class="tab-tag-left"></div>
				           <div class="tab-tag-middel" onClick="javascript:changeMenuTab(this);" 
				                url="/seeyon/taskmanage/taskinfo.do?method=projectTaskListFrame&from=ProjectAll&projectId=${param.projectId}&projectPhaseId=${param.projectPhaseId}&listTypeName=${listTypeName}&beginDate=${fn:substring(currentPhase != null ? currentPhase.phaseBegintime : projectCompose.projectSummary.begintime,0,10)}&endDate=${fn:substring(currentPhase != null ? currentPhase.phaseClosetime : projectCompose.projectSummary.closetime,0,10)}&projectState=${param.projectState}&isNewTask=${param.isNewTask}">
			                    <span id='projectTaskCount'><fmt:message key='task.projectall' /></span>
			               </div>
			               <div class="tab-tag-right"></div>
			               <div class="tab-separator"></div>
			               <div class="tab-tag-left"></div>
			               <div class="tab-tag-middel" onClick="javascript:changeMenuTab(this);" 
			                    url="/seeyon/taskmanage/taskinfo.do?method=statisticFrame&projectId=${param.projectId}&projectPhaseId=${param.projectPhaseId}"><fmt:message key='task.projectstatistic' />
			               </div>
			               <div class="tab-tag-right"></div>
			           </div>
			           <div class="tab-separator"></div>
				   </td>
				</tr>
		</c:when>
	</c:choose>
	
	 <tr>
        <td valign="top" width="100%" height="100%" align="center" class="">
            <iframe id="detailIframe" name="detailIframe" width="100%" height="100%" scrolling="no" frameborder="0" ></iframe>
        </td>
    </tr>

</table>
</body>
</html>