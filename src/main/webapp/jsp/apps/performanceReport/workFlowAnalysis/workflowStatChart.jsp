<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<%@include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<script type="text/javascript" src="${url_ajax_workFlowAnalysisManager}"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程分析统计图</title>
<script type="text/javascript">
<!--
  function ok() {
  }
  //-->
  //展示图表
  $(function() {
	  showChart(${workflowChart});
  });
  //ID情况
  var simpleDataList_id = new Array();
  var seriestNames = new Array("已发","已办","待办","超期");
  function showChart(workflowChart) {
  var chart1 = new SeeyonChart({
    title : "流程分析统计图",
    htmlId:"chart1",
    width : "100%",
    height: "100%",
    legend : "true", 
    chartJson : workflowChart,
    seriesNames : seriestNames,
    //dataIdList :simpleDataList_id,
    event : [
             {name:"pointClick",func:function(e){
            	// openList(e.data.appType,e.data.entityType,e.data.entityType=='Department' || e.data.entityType=='Account',"2",e.data.beginDate ,e.data.endDate ,"","",e.data.statScope);
             }}
             /**{name:"pointClick",func:function(e){
               alert("ID="+e.data.ID);
             }}*/
             ],
    fromReport : true,
    debugge:false
  });
  }
  //钻取操作
function openList(appType,entityType,entityId,state,beginDate,endDate,templateId,appName,statScope){
	var rv = v3x.openWindow({
        url: "${path}/performanceReport/WorkFlowAnalysisController.do?method=statResultListMain&appType=" + appType + "&entityId="
         + entityId + "&entityType=" + encodeURIComponent(entityType) + "&state=" + state 
         + "&beginDate=" + beginDate + "&endDate=" + endDate + "&templateId=" + templateId
         + "&appName=" + appName+"&statScope="+statScope,
        height: 590,
        width: 670,
        resizable:'no'
    });
}

</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" class="page_color">
    <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="bg-advance-middel" height="50%" width="100%" align="center" id="dataListDiv">
                 <div id="chart1" style="text-align: center;width: 100%;height: 100%"></div>
            </td>
        </tr>
    </table>
</body>
</html>