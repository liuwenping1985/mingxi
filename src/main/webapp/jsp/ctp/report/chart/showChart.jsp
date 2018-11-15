<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<c:if test="${param.includeFile != null}">
<jsp:include page="${param.includeFile}"></jsp:include>
</c:if>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma"   content="no-cache">
<title></title>
</head>

<script type="text/javascript">
$().ready(function(){
	var chartDate = $.parseJSON('${chart}');
	new SeeyonChart({
	  htmlId:"chartDiv",
	  fromReport : "${fromReport}",
	  <c:if test="${param.event != null}">
	  event :${param.event},
	  </c:if>
	  chartJson:chartDate,
	  debugge:true
	});
});
</script>
<body>
<div id="chartDiv" class="align_center" style="width: ${width}; height: ${height}"></div>
</body>
</html>