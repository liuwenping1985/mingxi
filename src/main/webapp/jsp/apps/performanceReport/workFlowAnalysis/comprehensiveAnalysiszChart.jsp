<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<%@include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<script type="text/javascript" src="${url_ajax_workFlowAnalysisManager}"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>综合分析统计图</title>
<script type="text/javascript">
<!--
  function ok() {
  }
  //-->
  $(function() {
    //默认加载第一个radio的图
    analysisTypeClick(1);
  });

  var seeyonChart = null;
  /**
  *点击radio事件
  */
  function analysisTypeClick(index) {
    if (index == 1) {//使用率
      var anyChart = eval(${chartUseRadio});
      seeyonChart = renderMainChart(anyChart,index);
    } else if (index == 2) {//运行效率
      var anyChart = eval(${charEfficiency});
      seeyonChart = renderMainChart(anyChart,index);
    } else if (index == 3) {//超时率
      var anyChart = eval(${chartOverTimeRatio});
      seeyonChart = renderMainChart(anyChart,index);
    }
    //默认下钻第一组数据
    try{
      chartDrillDown(seeyonChart.chart.getInformation().Series[0].Points[0].YValue,index);
    }catch(e){
    }
    
  }

  
  //渲染上方的图表
  function renderMainChart(anyChart,index) {
    return new SeeyonChart({
      htmlId : "chart1",
      width : "100%",
      height : "100%",
      chartJson : anyChart,
      xZoom : 5,
      yLabels : {
        format : "{%Value}{numDecimals:0}%" //将值格式化
      },
      outsideLabel : "{%Value}{numDecimals:0}%", //显示在柱状上面
      toolTip : "流程:{%Name}\n使用率:{%Value}{numDecimals:0}%",
      event : [ {
        name : "pointClick",
        func : function(e){
          chartDrillDown(e.data.ID,index);
        }
      },{
        name : "draw",
        func : function(e){
          drawInit(e,index);
        }
      }  ],
      debugge: true
    });
  }
  
  //切换主图后，默认加载第一条数据
  function drawInit(e,index){
    var chartDatas = seeyonChart.chart.getInformation();
    try{
      chartDrillDown(chartDatas.Series[0].Points[0].ID,index);
    }catch(e){}
  }
  
  var manager = new workFlowAnalysisManager();
  //钻取操作
  function chartDrillDown(id,index){
    var appType = "${appType}";
    var templeteIds = id;
    var beginDate = "${beginDate}";
    var endDate = "${endDate}";
    var analysisType = index;
    manager.getAnalysisChartData(appType,templeteIds,beginDate,endDate,analysisType,{
      success:function(result){
        renderChildChart(result);
      }});
  }
  
  //渲染下方的图表
  function renderChildChart(anyChart) {
    var chart2 = new SeeyonChart({
      htmlId : "chart2",
      width : "80%",
      height : "100%",
      chartJson : anyChart,
      insideLabel : "{%YPercentOfTotal}{numDecimals:2}%",
      debugge: true
    });
  }
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" class="page_color">
    <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="20" align="center" class="font_size12">
            <input type="radio" onclick="analysisTypeClick(1);" name="analysisType"
                value="1" checked="checked">使用率&nbsp;&nbsp; <input type="radio" onclick="analysisTypeClick(2);"
                name="analysisType" value="2">运行效率&nbsp;&nbsp; <input type="radio"
                onclick="analysisTypeClick(3);" name="analysisType" value="3">超时率</td>
        </tr>
        <tr>
            <td class="bg-advance-middel" height="50%" width="100%" align="center" id="dataListDiv">
                <div align="center">
                    <div id="chart1"></div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="bg-advance-middel" height="50%" width="100%" align="center" id="dataListDiv">
                <div align="center">
                    <div id="chart2"></div>
                </div>
            </td>
        </tr>
    </table>
</body>
</html>