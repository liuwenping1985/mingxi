<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<style type="text/css"> 
	     #taskChartReport { width: 100%; height: 100%;}
	</style>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>项目人员统计</title>
</head>
<body class="h100b over_hidden">
	<c:if test="${isMore eq true}">
		<div style="margin-top: 20px">
			<%@ include file="/WEB-INF/jsp/apps/taskmanage/report/commonMenu.jsp"%>
		</div>
	</c:if>
	<div id="taskGridReport" class="padding_lr_20"></div>
	<div id="taskChartReport"></div>
	<div id="drillDownDiv">
		<%@ include file="/WEB-INF/jsp/apps/taskmanage/report/commonCondition.jsp"%>
	</div>
</body>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/report/queryTaskCommon.jsp"%>
<script type="text/javascript" src="<c:url value='/apps_res/taskmanage/js/report/projectReportCommon.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/report/chart/echarts/echarts-all.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/report/chart/echarts/seeyonChart.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(function() {
		initTaskReport({
			conditionId : "drillDownDiv",
			showContent : "${showContent}",
			gridId : "taskGridReport",
			chartId : "taskChartReport",
			funShowChart : showBarChart,
			reportId : "${reportId}"
		});
	})
	var seeyonChart;
	function showBarChart(reportResult) {
		if ($.isNull(reportResult.chartData.chartData)) {
			$("#taskChartReport").text("${ctp:i18n('report.chart.noData')}");
		}
		var barOptions = {
			align : "v",
			//设置对齐方式，默认为H，为自添加的参数，为实现，数据格式的统一性
			//图例
			legend : {
				show : true,
				//图例显示开关
				orient : "vertical",
				//图例排列方式
				x : "right",
				//可是使用像素，如：12
				y : "center" //可是使用像素，如：12
			},
			xAxis : {
				position : 'top'
			},
			//穿透的单击事件
			itemClick : function(itemParams) {
				if (itemParams.data.url) {
					drillDownDetail(itemParams.data.url);
				}
			}
		};
		seeyonChart = $.seeyoncharts("taskChartReport", $.parseJSON(reportResult.chartData.chartData), barOptions);
	}
</script>
</html>