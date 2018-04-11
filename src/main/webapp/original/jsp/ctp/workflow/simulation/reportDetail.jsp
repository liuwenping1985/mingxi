<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>仿真报告详情</title>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<link rel="stylesheet" href="${path}/common/workflow/simulation/css/simulation.css${ctp:resSuffix()}">
</head>
<body class="h100b">
		    <div class="reportDetail1">
		    	<div id="problemDiv">
	                <div class="caption">
	                    <h3>${ctp:toHTMLWithoutSpace(report.simulationCode)}</h3>
	                    <p>${ctp:i18n("simulation.page.label.exeTime")}：${report.startTime}</p>
	                </div>
	                <c:if test="${report.isSuccess}">
	                	<c:choose >
	                		<c:when test="${report.referStateVal==2}">
				                <div class="risk">
				                    <span class="risk_span"></span> 
				                    	${ctp:i18n("simulation.page.report.refer.result.js")}<span class="risk_span_color">${ctp:i18n("simulation.code.enum.failedMatch.js")}</span>
				                    	<a class="right" href="javascript:void(0)" onclick="openReferReport('${report.simulationId}')">${ctp:i18n("simulation.page.alert.showExpectation.js")}<!-- 查看预期 --></a>
				                </div>
				                <div class="problem">
                                <p>   
                                ${ctp:toHTML(report.result)} 
                                </p>
                                </div>
			                </c:when> 
			                <c:otherwise>
			                	<div class="normal">
				                    <span class="normal_span"></span> ${report.sucessMsg}
				                    	<p>
				                    		${ctp:toHTML(report.result)} 
				                    	</p>
				                </div>
			                </c:otherwise>
		                </c:choose>
	                </c:if>
	                <c:if test="${!report.isSuccess}">
		                <div class="problem">
		                	 <span class="problem_span"></span>
		                        ${ctp:i18n("simulation.code.match.11") }
		                   	 <c:if test="${report.caseId == -1}">
		                   	 	<p class="red">${ctp:i18n("simulation.page.report.noWorkflow") }</p>
		                   	 </c:if>
		                   	 <c:if test="${report.caseId == -2}">
		                   	 	<p class="red">${ctp:i18n("simulation.page.report.noWorkflowTemplateDelete") }</p>
		                   	 </c:if>
		                   	 	<p>	  
		                   		${ctp:toHTML(report.result)} 
		                   		</p>
		                </div>
	                </c:if>
                </div>
				<c:if test="${report.processId!=null && report.processId!=-1  && report.caseId!=null && report.caseId!=-1}">
	                <div class="processImg w100b" id="workflowDiv">
	                	<p>
	                		${ctp:i18n("simulation.page.report.workflowdesc") }
	                	</p>
						<iframe id="workflowIframe" name="workflowIframe" width="100%" height="300px" frameborder="0" scrolling="no"></iframe>
	                </div>
	                <form id="workflowIframeForm" target="workflowIframe"
	                 action="${path}/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=3&processId=${report.processId}&caseId=${report.caseId}&currentNodeId=&appName=simulation&formMutilOprationIds=" method="post" style="display: none">
	                  <input type="hidden" name="simulationModeColorNodeIds" value="${report.signNodes}">
	                </form>
				</c:if>
           </div>     
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<script type="text/javascript" src="${path}/common/workflow/simulation/js/reportDetail.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var reportId = "${report.id}";
var referStateVal = "${report.referStateVal}";
var reportRefer = "${report.referVal}";
var simulationId = "${report.simulationId}";
var canSaveRefer = "${report.isSuccess && (report.referStateVal==1 || report.referStateVal ==2)}";
var openFrom = "${openType}";
var invalidMembers = "${ctp:escapeJavascript(invalidMembers)}";
</script>
</body>
</html>