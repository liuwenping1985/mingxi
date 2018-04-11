<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>项目超期统计</title>
	<style type="text/css">
		#taskChartReport{width: 100%;height:100%;}
		.stadic_head_height{ overflow:hidden; height:0px;}
		.stadic_body_top_bottom{ bottom: 0px; top: 0px; <c:if test="${showContent eq '20'}">overflow:hidden;</c:if>}
		<c:if test="${isMore eq true}">
			.stadic_head_height{ height:45px;}
			.stadic_body_top_bottom{ bottom: 0px; top: 45px; overflow-x:hidden; overflow-y:auto;}
		</c:if>
	</style>
</head>
<body class="h100b over_hidden ${isMore eq true ? '' : 'bg_color_none'}">
<div class="stadic_layout">
    <div class="stadic_layout_head stadic_head_height">
		<c:if test="${isMore eq true}">
			<%@ include file="/WEB-INF/jsp/apps/taskmanage/report/commonMenu.jsp"%>
		</c:if>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom">
		<div id="taskGridReport" class="padding_lr_20"></div>
		<div id="taskChartReport"></div>
		<div id="drillDownDiv">
			<%@ include file="/WEB-INF/jsp/apps/taskmanage/report/commonCondition.jsp"%>
		</div>
    </div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/report/queryTaskCommon.jsp"%>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/report/projectReportCommon.js${v3x:resSuffix()}"></script>
<c:if test="${fn:contains(reportViewPattern,'20')}">
	<script type="text/javascript" charset="UTF-8" src="${path}/common/report/chart/echarts/echarts-all.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/common/report/chart/echarts/seeyonChart.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
</c:if>
<!--[if IE 7]>
<script type="text/javascript">
 	$("#taskChartReport").width($(".stadic_layout_body").width());
	$("#taskChartReport").height($(".stadic_layout_body").height());
 </script>
<![endif]-->
<script type="text/javascript">


	$(function() {
		//OA-73812IE7：项目空间，1/2栏目时，显示多余横向滚动条。
		$("#taskGridReport").css("overflow-x", "hidden");
		initTaskReport({
			conditionId : "drillDownDiv",
			showContent : "${showContent}",
			gridId : "taskGridReport",
			chartId : "taskChartReport",
			funShowChart : showBarChart,
			reportId : "${reportId}"
		});

		function showBarChart(reportResult) {
			if (reportResult.chartData == undefined 
					|| reportResult.chartData.chartData == undefined 
					|| $.isNull(reportResult.chartData.chartData)) {
				if ("${reportId}" == PEOPLETASKREPORT) {//人员任务统计
					$("#taskChartReport").html("<center>" + $.i18n('project.has.not.task') + "</center>");
				} else {
					$("#taskChartReport").html("<center>${ctp:i18n('project.has.not.voerTime.task')}</center>");
				}
				$("#taskChartReport").css("padding-top", $("#taskChartReport").height() / 2 - 10);
				return;
			}

			<c:if test="${reportPage eq 'projectOverdueTaskReport'}">
			var nbarOptions = {
				align : "v",
				//图例
				legend : {
					show : false
				//关闭图例
				},
				xAxis : {
					position : 'top'
				},
				itemClick : function(itemParams) {
					if (itemParams.data.url) {
						drillDownDetail(itemParams.data.url);
					}
				}
			};
			var mbarOptions = {
				align : "v",
				//图例
				legend : {
					show : false
				//关闭图例
				},
				xAxis : {
					position : 'top'
				},
				itemClick : function(itemParams) {
					if (itemParams.data.url) {
						drillDownDetail(itemParams.data.url);
					}
				}
			};
			</c:if>
			
			<c:if test="${reportPage eq 'projectMemberTaskReport'}">
			var nbarOptions = {
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
					y : 30
				//可是使用像素，如：12
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
			var mbarOptions = {
				align : "v",
				//设置对齐方式，默认为H，为自添加的参数，为实现，数据格式的统一性
				//图例
				legend : {
					show : true,
					//图例显示开关
					orient : "vertical",
					//图例排列方式
					x : $("#taskChartReport").width() - 128 - 62,
					//可是使用像素，如：12
					y : 130 - 48
				//可是使用像素，如：12
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
			</c:if>
			
			<%-- 普通样式--%>
			var barOptions = nbarOptions;
			barOptions.barWidth = 16;
			barOptions.barCategoryGap = 10;
			barOptions.barGap = 10;
			barOptions.grid = {
				y : 30,
				x : 60,
				x2 : 75
			};
			
			<%-- 人员任务统计样式 --%>
			<c:if test="${reportPage eq 'projectMemberTaskReport'}">
				<c:if test="${isMore eq true}">
				barOptions = mbarOptions;
				barOptions.barWidth = 30;
				barOptions.barCategoryGap = 17;
				barOptions.barGap = 17;
				barOptions.grid = {
					y : 67,//上边
					x : 128 + 45,//左边
					x2 : 128 + 62 + 45
				//右边
				};
				</c:if>
			</c:if>
			
			<%-- 超期任务统计样式 --%>
			<c:if test="${reportPage eq 'projectOverdueTaskReport'}">
				<c:if test="${isMore eq true}">
				barOptions = mbarOptions;
				barOptions.barWidth = 30;
				barOptions.barCategoryGap = 17;
				barOptions.barGap = 17;
				barOptions.grid = {
					y : 30,
					x : 70,
					x2 : 75
				};
				</c:if>
			</c:if>
			
			barOptions.tooltip = {
				show : true,//打开开关
				trigger : "item",//触发类型,axis（鼠标在数据所在的轴上即会触发该轴上所有的数据显示）、item
				backgroundColor : "rgba(123,56,78,0.5)",
				formatter : function(params, ticket, callback) {
					return (params.seriesName) + "&ensp;" + (params.value || params.data.value || "0");
				}
			}

			try {
				classReport.seeyonChart = $.seeyoncharts("taskChartReport", $.parseJSON(reportResult.chartData.chartData), barOptions);
			} catch (e) {
				$.alert("显示任务统计图操作太频繁，请稍后再试！");
			}
		}

	});
</script>
</html>