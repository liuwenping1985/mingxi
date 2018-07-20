<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<%@include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<script type="text/javascript" src="${url_ajax_workFlowAnalysisManager}"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>节点分析统计图</title>
<script type="text/javascript">
<!--
  function ok() {
  }
  //-->
  //展示图表
  $(function() {
	  showChart(${chartNode});
  });
  /**
  var indexNames = new Array("核算员","运营部经理","财务主管","采购部经理","采购员");
  var simpleDataList_id = new Array();
  simpleDataList_id.push(new Array("1","2","3","4","5"));
  simpleDataList_id.push(new Array("1","2","3","4","5"));*/
  
  var seriesNames = new Array("平均处理时长","超时率");
  var seriesTypes = new Array(ChartType.column_cylinder,ChartType.line_vertical);
  function showChart(chartNode) {
  var chart1 = new SeeyonChart({
	  	title: "节点分析统计图",
	    htmlId:"chart1",
	    width : 500,
	    height: 300,
	    border : false,
	    animation : true,
	    legend : "true",   //显示图例
	    seriesTypes : seriesTypes,
	    seriesNames : seriesNames,
	    chartJson : chartNode,
	    //indexNames : indexNames,
	    //dataList : dataList,
	    //dataIdList :simpleDataList_id,    //ID
	    event : [
	             {name:"pointClick",func:function(e){
	               alert("ID="+e.data.ID);
	             }}
	             ],
	    extraYaxisNameList : ["","","a"],
	    extraYaxisNodeList : [{
	      name : "a",
	      yLabels : {
	        format : "{%Value}{numDecimals:0}%"
	      }
	    }
	    ],
	    fromReport : true,
	    debugge:false
	  });
  }
  //钻取操作
  function chartDrillDown(id){
	  /**var appType = "${appType}";
	    var templeteIds = id;
	    var beginDate = "${beginDate}";
	    var endDate = "${endDate}";
	    var analysisType = index;
	    manager.getAnalysisChartData(appType,templeteIds,beginDate,endDate,analysisType,{
	      success:function(result){
	        renderChildChart(result);
	      }});**/
  }

</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" class="page_color">
    <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="bg-advance-middel" height="50%" width="100%" align="center" id="dataListDiv">
                <div align="center">
                    <div id="chart1"></div>
                </div>
            </td>
        </tr>
    </table>
</body>
</html>