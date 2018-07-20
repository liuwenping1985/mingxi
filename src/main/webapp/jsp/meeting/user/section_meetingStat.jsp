<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" content="no-cache">
<title>图表组件</title>
<script type="text/javascript">
  $(function() {
    //var indexNames = new Array("参加", "不参加", "待定", "未回执");
    var viewType = ChartType.pie;
    var statContent = "${statContent}";
    var displayContent = "${displayContent}";
    var names = "${IndexNames}";
    if(statContent == "mtReply"){
      names = "[参加,不参加,待定,未回执]";
    }else {
      names = "[发起人,主持人,记录人,与会人]";
    }
    var DataList = "${DataList}";
    names = names.substring(1,names.length-1);
    DataList = DataList.substring(0,DataList.length-1);
    var namesArry = names.split(",");
    var DataArry = DataList.split(",");
    var indexNames = new Array(namesArry[0],namesArry[1],namesArry[2],namesArry[3]);
    var simpleDataList;
    if(statContent == "mtReply" && displayContent == "number"){
      simpleDataList = new Array(new Array(DataArry[3], DataArry[4], DataArry[5], DataArry[6]));
    }else if(statContent == "mtReply" && displayContent == "time"){
      indexNames = new Array("参加时长", "工作时长");
      var joinTime = DataArry[8];
      var workTime = DataArry[9];
      if(joinTime){
        if(joinTime.indexOf("分") > 0){
          joinTime = joinTime.replace("小时",".");
          joinTime = joinTime.replace("分","");
        }else{
          joinTime = joinTime.substring(0, joinTime.length-2);
        }
      }else{ 
        joinTime = 0;
      }
      if(workTime){
        if(workTime.indexOf("分") > 0){
          workTime = workTime.replace("小时",".");
          workTime = workTime.replace("分","");
        }else{
          workTime = workTime.substring(0, workTime.length-2);
        }
      }else {
        workTime = 0;
      }
      simpleDataList = new Array(new Array(joinTime, workTime));
      viewType = ChartType.column;
    }else {
      simpleDataList = new Array(new Array(DataArry[2], DataArry[3], DataArry[4], DataArry[5]));
    }
    if(DataList == "" && displayContent != "time"){
      simpleDataList = new Array(new Array(0, 0, 0, 0));
    }
    var chart1;
    if(statContent == "mtReply" && displayContent == "time"){
            chart1 = new SeeyonChart({
            htmlId:"chart1",
            width : 350,
            heigth: 240,
            toolTip : "时长:{%Value}小时\n比例:{%YPercentOfTotal}%",
            indexNames : indexNames,
            animation: "true",
            yScale:{
              minimum:"0"
            },
            dataList : simpleDataList,
            debugge : false
          });
    }else{
          chart1 = new SeeyonChart({
          htmlId : "chart1",
          width : 350,
          heigth : 240,
          indexNames : indexNames,
          legend: "{%Icon}{%Name}",
          toolTip : "数量:{%Value}次\n比例:{%YPercentOfTotal}%",
          chartType : viewType,
          dataList : simpleDataList,
          animation: "true",
          debugge : false
        });
    }

    $("#chart1Btn").click(function() {
      renderChart(chart1);
    });

    $("#clearBtn").click(function() {
      chartObj.clear();
    });
  });
  
  function searchForm(){
    var from = document.getElementById("from_datetime").value;
    var to = document.getElementById("to_datetime").value;
    if(from == ""){
      alert("开始时间不允许为空！");
      return ;
    }
    if(to == ""){
      alert("结束时间不允许为空！");
      return ;
    }
    if(compareDate(from,to)>0){
      alert("开始时间不能大于结束时间！");
      return ;
    }
    document.getElementById('searchForm').action = _ctxPath + "/mtMeeting.do?method=meetingStatSectionView";
    document.getElementById('searchForm').submit();
  }

  function meetingStatInit(){
    var statTime = "${statTime}";
    var chart1 = document.getElementById('chart1');
    var charDiv = document.getElementById('charDiv');
    if(statTime == "custom"){
      //chart1.style.display = "inline";
      if("${width}" != "5")
        charDiv.align = "center";
    }else{
      chart1.align = "center";
    }
  }
</script>
</head>
<body onload="meetingStatInit();">
<c:set var="displayPattern" value="yyyy年MM月dd日" />
<c:set var="datetimePattern" value="yyyy-MM-dd" />
    <!-- <input type="button" id="chart1Btn" value="确定"/>
<input type="button" id="clearBtn" value="清除"/> -->
<c:if test="${statTime eq 'custom'}">
<div class="clearfix">
<form name="searchForm" id="searchForm" method="post" onsubmit="return false">
    <input type="hidden" name="statTime" value="${statTime}">
    <input type="hidden" name="displayContent" value="${displayContent}">
    <input type="hidden" name="statContent" value="${statContent}">
    <input type="hidden" name="fragmentId" value="${fragmentId}">
    <input type="hidden" name="ordinal" value="${ordinal}">
<!-- <div style="display: inline; margin: 100px;"> -->
    <ul class="common_search common_search_condition clearfix"
        style="position: absolute; z-index: 900; top: 5px; right: 0px;">
        <li id="createDate_container" class="condition_text margin_lr_5">
            <input id="from_datetime" name="from_datetime" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"  value="<fmt:formatDate pattern="${datetimePattern}" value="${from_datetime}"/>" type="text" class="comp input_date" style="width: 95px;" readonly="readonly" _inited="1">
                <span class="calendar_icon"></span><span class="padding_lr_5">-</span>
            <input id="to_datetime" name="to_datetime" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" value="<fmt:formatDate pattern="${datetimePattern}" value="${to_datetime}"/>" type="text" class="comp input_date" style="width: 95px;" readonly="readonly" _inited="1">
                <span class="calendar_icon"></span>
        </li>
        <li class="search_btn">
        <a class="common_button common_button_gray search_buttonHand" href="javascript:searchForm();">
            <em>
            </em>
        </a>
        </li>
    </ul>
</form>
</div>
</c:if>
    <div id="charDiv">
        <div id="chart1" class="align_center"></div>
        <div align="center" class="font_size12"><span><fmt:formatDate pattern="${displayPattern}" value="${from_datetime}" />—<fmt:formatDate pattern="${displayPattern}" value="${to_datetime}" /></span></div>
        <!-- </div> -->
    </div>
    <!-- <div id="chart3">
</div>
<div id="htmlDiv">
</div> -->

</body>
</html>