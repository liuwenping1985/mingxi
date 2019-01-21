<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<style type="text/css">
	   #taskChartReport{width: 100%;height:100%;}
	</style>
	<title>项目任务状态统计</title>
</head>
<body class="h100b over_hidden bg_color_none">
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
			chartId : "taskChartReport",
			funShowChart : showPieChart
		});
	});

	var seeyonChart;
	function showPieChart(reportResult) {
		if (!reportResult.hasResultData) {//没有数据
			$("#taskChartReport").html("<center class='font_size12'>${ctp:i18n('project.has.not.ztask')}</center>");
			$("#taskChartReport").css("padding-top", $("#taskChartReport").height() / 2 - 10);
			return;
		}
		//饼图的选项
		var pieOptions = {
			//图例
			legend : {
				show : true,
				//图例显示开关
				orient : "vertical",
				//图例排列方式
				x : "right",
				//可是使用像素，如：12
				y : "center", //可是使用像素，如：12
				textStyle : {
					fontFamily : "微软雅黑,Arial, Verdana, sans-serif",
					color : "#414141"
				}
			},
			//穿透的单击事件
			itemClick : function(itemParams) {
				if (itemParams.data.url) {
					drillDownDetail(itemParams.data.url);
				}
			},
			tooltip : {
				show : true,//打开开关
				trigger : "item",//触发类型,axis（鼠标在数据所在的轴上即会触发该轴上所有的数据显示）、item
				backgroundColor : "rgba(123,56,78,0.5)",
				formatter : function(params, ticket, callback) {
					return params.data.name + "&ensp;&ensp;" + params.data.value;
				}
			}
		};
		var datas = $.parseJSON(reportResult.chartData.chartData);
		var taskChartReportDiv = $("#taskChartReport");
		if ($("#taskChartReport").width() < 300) {
			var tempdiv = document.createElement("div");
			tempdiv.id = "taskChartReportChild";
			$(tempdiv).width(300).height("100%");
			taskChartReportDiv.css({
				"overflow-x" : "auto",
				"overflow-y" : "hidden"
			});
			taskChartReportDiv.append(tempdiv);
			taskChartReportDiv = tempdiv;
		}

		/**
		 * @param cdiv :图表的容器，div的element对象、div的id、jquery对象
		 * @param datas :传递过来的数据
		 * @param options ：图标的选项
		 * @returns {"chart":图对象,"options":图的选项}
		 */
		seeyonChart = $.seeyoncharts(taskChartReportDiv, datas, pieOptions);
	}
</script>
</html>