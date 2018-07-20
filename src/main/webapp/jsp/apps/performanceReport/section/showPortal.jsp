<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp" %> --%>
<%-- <%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryCommon.jsp" %> --%>
<!-- 图表展示控制文件:5.6前端优化 将showTable.jsp脚本清理到showTable.js中 -->
<%-- <%@ include file="/WEB-INF/jsp/apps/performanceReport/common/showTable.jsp" %> --%>
<!-- 图表展示控制文件:5.6前端优化 将showChart.jsp脚本清理到showChart.js中 -->
<%-- <%@ include file="/WEB-INF/jsp/apps/performanceReport/common/showChart.jsp" %> --%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%-- <script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script> --%>
<%-- <script type="text/javascript" src="${path}/ajax.do?managerName=performanceQueryManager"></script> --%>
<%-- <script type="text/javascript" src="${path}/ajax.do?managerName=workFlowAnalysisManager"></script> --%>
<%-- <script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script> --%>
<title>绩效分析统计栏目</title>
<script type="text/javascript">
	var tableChartTab="${ctp:escapeJavascript(tableChartTab)}";
	var param="${ctp:escapeJavascript(params)}";
	var result="";
	var flowType="";
   	var end_time="";
   	var start_time="";
   	var templeteId_=""
   	var isPortal="${isPortal}";
   	var showNumber="${showNumber}";
    //报表id
    var Constants_report_id="${ctp:escapeJavascript(reportId)}";
    //查看团队报表标记
    var Constants_report_flag="${viewFlag}";
    //是否为集团管理员
 	var isGroupAdmin="${isGroupAdmin}";
  	//是否为管理员
  	var isAdministrator="${isAdministrator}";
    //列表总条数，分页使用
    var pageTotle="${pageTotle}";
    //报表图对象，打印转发时使用
    var chartObjS=[];
    var path = "${path}";
    var reportParams="";
	$(function(){
		if(tableChartTab == '2'){
		 	var bool = inputNoDataInfo();
		 	if(bool != false){
			 	executeStatistics();
		 	}
		 }else{
		 	executeStatistics();
		 }
	});
	function hideTab(index){ $("body").css("height", ${ctp:escapeJavascript(chartHeight)}-1); }
</script>
</head>
<body onunload="removeChart()" class="bg_color_none">
	<div id="queryResult" style="height:100%" style="overflow:auto; background:#fff;">
	</div>
	<form id="queryConditionForm" name='queryConditionForm' style="margin:0;padding:0; height:105px;display:none" method="post" target="_parent">
	</form>
	<input type="hidden" id="task_id"/>
</body>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/section/showPortal.footer.jsp"%>
</html>