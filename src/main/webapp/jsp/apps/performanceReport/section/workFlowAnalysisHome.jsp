<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="workFlowAnalysisHomeHtml_js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	$(function(){
		var reportName="${reportName}";
		if(reportName=='综合分析'){
			$("#workFlowAnalysis").html(getAppType());
		}
	})
</script>
</head>
<body scroll="no" class="padding5">
	<div >
		<table id="workFlowAnalysis">
			
		</table>
	</div>
</body>
</html>