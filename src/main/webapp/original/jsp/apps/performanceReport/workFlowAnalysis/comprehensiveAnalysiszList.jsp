<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<%@include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>综合分析</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=workFlowAnalysisManager"></script>
<script type="text/javascript">
<!--
var beginDate;
var endDate;
var baseUrl="${path}";
function exportComprehensiveExcel() {
	document.getElementById("appType").value = parent.document.getElementById("appType").value;
	
	var templete = parent.document.getElementsByName("templete");
	for (var i = 0 ; i < templete.length ; i ++) {
		if (templete[i].checked) {
			if (templete[i].value == 2)  {
				document.getElementById("templete").value = templete[i].value;
				document.getElementById("templeteId").value = parent.document.getElementById("templeteId").value;
			}
		}
	}
	document.getElementById("beginDate").value = parent.document.getElementById("beginDate").value;
	document.getElementById("endDate").value = parent.document.getElementById("endDate").value;
	
	var searchForm = document.getElementById("searchForm");
	searchForm.action = ""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=exportComprehensiveExcel";
	searchForm.target = "temp_iframe";
	searchForm.submit();
}

function rift(id,subject){
	if(beginDate==''){
		beginDate = window.parent.document.getElementById('beginDate').value;
	}
	if(endDate==''){
		endDate = window.parent.document.getElementById('endDate').value;
	}
	showDetail(id,subject,beginDate,endDate);
}
function showDetail(id,subject,beginDate,endDate){
    var templeteSubject=encodeURIComponent(subject);
   /* var rv = v3x.openWindow({
        url: ""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=getDetailAccount&templeteId="+id+"&beginDate="+beginDate+"&endDate="+endDate+"&templeteSubject="+templeteSubject,
        height: 500,
        width:750
    });*/
    var url=""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=getDetailAccount&templeteId="+id+"&beginDate="+beginDate+"&endDate="+endDate+"&templeteSubject="+templeteSubject;
    var dialog = $.dialog({
	    id: 'url',
	    url: url,
	    width: 750,
	    height: 500,
	    targetWindow:getCtpTop(),
	    title: "综合分析"
	});
}
//-->
</script>
<script type="text/javascript">
  var isSection="${isSection}";
  var reportType = 1;
 $(function(){ 
	 initButton(); 
     var tableChart="${tableChart}";
     if(isSection=='true'){
         $("#heep_td").css("display","none");
         $("#tabs_head").hide();
         $("#scrollListDiv").css("top","0px");
         $("#lastLine").hide();
         var th=$("#headIDdataListTable th");
         if(tableChart == "1"){
             $("#chartDiv").hide();
             $("#chart").hide();
             reportType = 1;
         }else if(tableChart == "2"){
             $("#tabs_body").hide();
             $("#chartDiv").show();
             reportType = 2;
             //默认加载第一个radio的图
             analysisTypeClick(1);  
         }
     }else{
    	 if(tableChart!=null && tableChart!=''){
    		 if(tableChart == "1"){
    	         if(! $("#tableResult").parent("li").hasClass("current")){
	   	             $("#ul_tab li").toggleClass("current");
	   	             $("#tabs_body").show();
    	         }
               reportType = 1;
	   	         $("#chartDiv").hide();
             }else if(tableChart == "2"){
                 if(!$("#chartResult").parent("li").hasClass("current")){
                     $("#ul_tab li").toggleClass("current");
                     $("#chartDiv").show();
                     $("#tabs_body").hide();
                     //默认加载第一个radio的图
                     reportType = 2;
                     analysisTypeClick(1);   
                 } 
             }
    	 }else{
    		 $("#chartDiv").hide();
    	 }
     }
     window.parent.window.$('#querySave').attr('disabled',false);
 });
 


 
 
 function initButton(){
     $("#tableResult").click(function(){
         if(!$(this).parent("li").hasClass("current")){
             $("#ul_tab li").toggleClass("current");
             $("#tabs_body").show();
             $("#chartDiv").hide();
             reportType = 1;
             parent.document.getElementById("tableChart").value=1;        
         }
     });
     $("#chartResult").click(function(){
         if(!$(this).parent("li").hasClass("current")){
             $("#ul_tab li").toggleClass("current");
             $("#chartDiv").show();
             $("#tabs_body").hide();
             //默认加载第一个radio的图
             analysisTypeClick(1); 
             $("#analysisType1").attr("checked","checked");//radio也同步选择使用率
             reportType = 2;
             parent.document.getElementById("tableChart").value=2;        
         }
     });
 }
 
 function ok() {
 }
 var seeyonChart = null;
 var childChart = null;
 
 function printContent(){
   if($("#chartDiv").is(":hidden")){//图隐藏
     //popprint();
      var printContentBody = "";
      var cssList = new ArrayList();
      var pl = new ArrayList();
      var contentBody = "" ;
      var contentBodyFrag = "" ;

      var htmlContent = "<tr id='headIDdataListTable'>"+$("#headIDdataListTable").html()+"</tr>";
      $(".hDivBox thead th div").each(function(){
        var _html = $(this).html();
        $(this).parent().html(_html);
      });

      contentBody = document.getElementById("dataListDiv").innerHTML;
      contentBodyFrag = new PrintFragment(printContentBody, contentBody);
      pl.add(contentBodyFrag);
      
      cssList.add("/seeyon/common/skin/default/skin.css");
      
      var parentObj = $("#headIDdataListTable").parent();
      $("#headIDdataListTable").remove();
      parentObj.html(htmlContent);
      
      printList(pl,cssList);
   }else{//图显示
     var chartObjS = new Array();
     if(seeyonChart != null){
       chartObjS.push(seeyonChart);
       if(childChart != null){
         chartObjS.push(childChart);
       }
     }
     printFlashChart2IMG(chartObjS);
   }
 }
 
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
     }]
   });
 }
 
 //切换主图后，默认加载第一条数据
 function drawInit(e,index){
   var chartDatas = seeyonChart.chart.getInformation();
   try{
     chartDrillDown(chartDatas.Series[0].Points[0].ID,index);
   }catch(e){
     childChart = null;
     $("#chart2").empty();
   }
 }
 var manager = new workFlowAnalysisManager();
 if(isSection!='true'){
	 beginDate = "${beginDate}" == "" ? window.parent.document.getElementById("beginDate").value : "${beginDate}";
	 endDate = "${endDate}" == "" ? window.parent.document.getElementById("endDate").value : "${endDate}";
 }else{
	 beginDate = "${beginDate}" == "" ? getLastYearMonth('${productUpgrageDate }') : "${beginDate}";
	 endDate = "${endDate}" == "" ? getLastYearMonth('${productUpgrageDate }') : "${endDate}";
 }
 
 //钻取操作
 function chartDrillDown(id,index){
   
   childChart = null;
   var appType = "${appType}";
   var templeteIds = id;
   var analysisType = index;
   if(isSection=='true'){
	   if($.isNull(analysisType)){
		   analysisType=1;
	   }
   }
   manager.getAnalysisChartData(appType,templeteIds,beginDate,endDate,analysisType,"${isSection}",{
     success:function(result){
       childChart = renderChildChart(result , id);
     }});
 }
 
 //渲染下方的图表
 function renderChildChart(anyChart , id) {
  //debugger;
  reportType = 2;
   return new SeeyonChart({
     htmlId : "chart2",
     width : "100%",
     height : "100%",
     chartJson : anyChart,
     event : [ {
         name : "pointClick",
         func : function(e){
             showDetail(id,anyChart.title,e.data.Name,e.data.Name);
         }
       }]
   });
 }
  function forwardToCol(){
  var contentHtml="";
    if(reportType==2){
    if(seeyonChart!=null){
    	if ( $.browser.msie ){
   		if($.browser.version<8){//对不起，当前您的浏览器版本过低无法支持图表的打印与转发，请升级至IE8及以上版本
   			$.alert("${ctp:i18n('report.chart.ie7.info')}");
   			return;
   		}
   		}
        contentHtml+="<img src='data:image/gif;base64,"+seeyonChart.chart.getPNG()+"'>";
        if(childChart != null){
	        contentHtml+="<img src='data:image/gif;base64,"+childChart.chart.getPNG()+"'>";
        }
    }
  }else{
    convertTable();
    contentHtml = "<div style='height:300px;'>"+$("#dataListDiv").html()+"</div>";
  }
  parent.window.closeAndForwardToCol("综合分析", contentHtml);
    
}
function convertTable(){
  var mxtgrid = $(".mxtgrid");
  if(mxtgrid.length > 0 ){
  $(".hDivBox thead th div").each(function(){
  var _html = $(this).html();
    $(this).parent().html(_html);
  });
    var tableHeader = $(".hDivBox thead");

  $(".bDiv tbody td div a").each(function(){
    var _html = $(this).html();
      $(this).parent().html(_html);
    });                
    $(".bDiv tbody td div").each(function(){
    var _html = $(this).html();
      $(this).parent().html(_html);
    });
                
    var tableBody = $(".bDiv tbody");
    var str = "";
    var headerHtml =tableHeader.html();
    var bodyHtml = tableBody.html();
    if(headerHtml == null || headerHtml == 'null')
    headerHtml ="";
        if(bodyHtml == null || bodyHtml=='null'){
      bodyHtml="";
        }
        //if(mxtgrid.hasClass('dataTable')){
    //  str+="<table class='table-header-print table-header-print-dataTable' border='0' cellspacing='0' cellpadding='0'>"
    //}else{
            str+="<table class='table-header-print' border='0' cellspacing='0' cellpadding='0'>"
        //}
        str+="<thead>";
        str+=headerHtml;
    str+="</thead>";
        str+="<tbody>";
        str+=bodyHtml;
        str+="</tbody>";
        str+="</table>";
        var parentObj = mxtgrid.parent();
        mxtgrid.remove();
        parentObj.html(str);
  } 
}
</script>
<style type="text/css">
	#section_tab td{
		text-align:center;
	}
      .stadic_head_height{
          height:30px;
      }
      .stadic_body_top_bottom{
       bottom: 0px;
          top: 0px;
      }
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}"/>">
<script>
$(document).ready(function(){
    var isSection="${isSection}";
	if(isSection =='true'){
		$("#scrollListDiv").height($("body").height());
	}else{
		$("#scrollListDiv").height($("body").height()-90);
	}
})

</script>
</head>
<body class="page_color" style="overflow: hidden;padding-top: 0px; padding-right: 5px; padding-bottom: 0px; padding-left: 5px;">
<div class="main_div_row3">
  <div class="right_div_row3 " style="_padding:0;">
    <div class="top_div_row3" style="height:55px; _position:static;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td id="heep_td" valign="top">
					<div class="portal-layout-cell">
						<form id="searchForm" action="" method="post">
								<input type="hidden" id="appType" name="appType" value=""/>
								<input type="hidden" id="templeteId" name="templeteId" value=""/>
								<input type="hidden" id="templete" name="templete" value="1"/>
								<input type="hidden" id="beginDate" name="beginDate" value=""/>
								<input type="hidden" id="endDate" name="endDate" value=""/>
						</form>
						<table border="0" cellSpacing="0" cellPadding="0"  class="portal-layout-cell-right">
							<tr>
								<td class="sectionTitleLine sectionTitleLineBackground">
									<span style="height:15px;float:left;padding-top:0px" class="searchSectionTitle"><fmt:message key='common.statistic.result.label' /></span>
								</td>
								<td >
									<div class="div-float-right" style="margin-right: 20px;" >
										<form id="searchForm" action="" method="post">
                      <%--转发协同--%>
                      <td>
                        <span id="ExcportExcel1Div"  style="width: 16px; height: 16px; display: block;" class="ico16 forwarding_16 margin_r_5" onclick='javascript:forwardToCol()'></span>     
                      </td>
                      <td>
                       <span style="height:15px;float:left;padding-top:3px"><a onclick="forwardToCol()">${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}</a>&nbsp;&nbsp;&nbsp;</span>
                      </td>
                      <td>
                        <span id="ExcportExcel1Div" style="width: 16px; height: 16px; display: block;" class="ico16 export_excel_16 margin_r_5" onclick='javascript:exportComprehensiveExcel()'></span> <!-- title="<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />" -->    
                      </td>
						<td>
							<span style="height:15px;float:left;padding-top:3px"><a onclick="exportComprehensiveExcel()">${ctp:i18n('performanceReport.queryMain.tools.reportToExcel')}</a>&nbsp;&nbsp;&nbsp;&nbsp;</span>
						</td>
						<td>
							<span id="printButton1Div" class="ico16 print_16 margin_r_5" style="display: block;" onclick='printContent()'></span><!-- title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />"  -->
						</td>
						<td>
							<span style="height:15px;float:left;padding-top:3px"><a onclick="printContent()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a></span>
						</td>
						<td>
							&nbsp;&nbsp;&nbsp;
						</td>
						<td>
							<span id="helpButton" class="help cursor-hand margin_r_5" style="display: block;" onclick="showHelpDescription('${path}','comprehensive')" ></span>	<!-- title="<fmt:message key='common.wfanalysis.help.label'/>" -->
						</td>
						<td>
							<span style="height:15px;float:left;padding-top:3px"><a onclick="showHelpDescription('${path}','comprehensive')" >${ctp:i18n('performanceReport.queryMain_js.help.title')}</a></span>
						</td>
										</form>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
		<div id="tabs_head" class="common_tabs clearfix">
            <ul class="left" id="ul_tab">
                <li class="current"><a hidefocus="true" class="border_b" href="javascript:void(0)" id="tableResult"><span>${ctp:i18n('performanceReport.workFlowAnalysis.common.table')}</span></a></li>
                <li><a hidefocus="true" class="last_tab" href="javascript:void(0)" id="chartResult"><span>${ctp:i18n('performanceReport.workFlowAnalysis.common.chart')}</span></a></li>
            </ul>
        </div> 
    </div>  
	<div class="center_div_row3 border_b bg_color_white" id="scrollListDiv" style="top:55px;_position:static;">
        <div id="chartDiv" class="align_center border_all hidden common_tabs_body stadic_layout_body stadic_body_top_bottom">
            <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="12" align="center" class="font_size12" id="chart">
                        <input type="radio" onclick="analysisTypeClick(1);" name="analysisType" id="analysisType1" value="1" checked="checked">${ctp:i18n('performanceReport.workFlowAnalysis.chartUseRadio')}&nbsp;&nbsp; 
                        <input type="radio" onclick="analysisTypeClick(2);" name="analysisType" id="analysisType2" value="2">${ctp:i18n('performanceReport.workFlowAnalysis.charEfficiency')}&nbsp;&nbsp; 
                        <input type="radio" onclick="analysisTypeClick(3);" name="analysisType" id="analysisType3" value="3">${ctp:i18n('performanceReport.workFlowAnalysis.chartOverTimeRatio')}
                    </td>
                </tr>
                <tr>
                    <td class="bg_color_white" width="100%" align="center" >
                        <div align="center">
                            <div id="chart1" style="height:185px"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="bg_color_white" width="100%" align="center" >
                        <div align="center">
                            <div id="chart2" style="height:185px"></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
          <div class="common_tabs_body border_lr" id="tabs_body" >
        		<form method="get" >
        			<div id="dataListDiv">
        			<div class="hDivBox" id="hDivBox">
        			<c:if test="${isSection == false or empty isSection}">
        				<v3x:table htmlId="dataListTable"	data="${workFlowAnalysis}" var="data" isChangeTRColor="false"  className="sort ellipsis">
        					<v3x:column width="20%" type="String" label="common.template.process.label" alt="${data.templeteSubject}" >
        						 <a onclick="rift('${data.templeteId}','${data.templeteSubject }')">${data.templeteSubject}</a></v3x:column>
        					<v3x:column width="10%" type="String" label="common.the.personal.label" alt="${v3x:showMemberNameOnly(data.templeteMemberId)}">
        						${v3x:showMemberNameOnly(data.templeteMemberId)}</v3x:column>
        					<v3x:column width="7%" type="String" label="common.the.number.of.calls.label" alt="${data.caseCount }">
        						${data.caseCount }</v3x:column>
        					<v3x:column width="8%" type="String" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.useRadio')}" alt="${v3x:showNumber2Percent(data.useRadio) }">
        						${v3x:showNumber2Percent(data.useRadio)}</v3x:column>
        					<v3x:column width="8%" type="String" label="common.reference.time.label" alt="${v3x:showDateByWork(data.standardTime)}">
        						${v3x:showDateByNature(data.standardTime)} 
        					</v3x:column>
        					<v3x:column width="10%" type="String" label="common.average.run.length.label" alt="${v3x:showDateByWork(data.avgRunTime)}">
        						${v3x:showDateByWork(data.avgRunTime)}
        					</v3x:column>
        					<v3x:column width="10%" type="Percent" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.efficiency')}" alt="${v3x:showNumber2Percent(data.efficiency) }">
        						${v3x:showNumber2Percent(data.efficiency) }</v3x:column>
        					<v3x:column width="8%" type="Percent" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.overCaseCount')}" alt="${data.overCaseCount }">
        						${data.overCaseCount }</v3x:column>
        					<v3x:column width="8%" type="Percent" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.overTimeRatio')}" alt="${v3x:showNumber2Percent(data.overTimeRatio) }">
        						${v3x:showNumber2Percent(data.overTimeRatio) }
        						<c:if test="${empty allCaseCount or allCaseCount lt data.allCaseCount}">
        							<c:set var="allCaseCount" value="${data.allCaseCount }" />
        						</c:if>
        					</v3x:column>
        					<v3x:column width="10%" type="String" label="common.the.average.length.of.overtime.label" alt="${v3x:showDateByWork(data.avgOverTime)}">
        						${v3x:showDateByWork(data.avgOverTime)}</v3x:column>
        				</v3x:table>
				</c:if>
				
				<c:if test="${isSection == true}">
					<v3x:table htmlId="dataListTable"	data="${workFlowAnalysis}" var="data" isChangeTRColor="false"  className="sort ellipsis" showPager="false" subHeight="-35">
        					<v3x:column width="20%" type="String" label="common.template.process.label" alt="${data.templeteSubject}" >
        						 <a onclick="rift('${data.templeteId}','${data.templeteSubject }')">${data.templeteSubject}</a></v3x:column>
        					<v3x:column width="10%" type="String" label="common.the.personal.label" alt="${v3x:showMemberNameOnly(data.templeteMemberId)}">
        						${v3x:showMemberNameOnly(data.templeteMemberId)}</v3x:column>
        					<v3x:column width="12%" type="String" label="common.the.number.of.calls.label" alt="${data.caseCount }">
        						${data.caseCount }</v3x:column>
        					<v3x:column width="12%" type="String" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.useRadio')}" alt="${v3x:showNumber2Percent(data.useRadio) }">
        						${v3x:showNumber2Percent(data.useRadio)}</v3x:column>
        					<v3x:column width="12%" type="String" label="common.reference.time.label" alt="${v3x:showDateByWork(data.standardTime)}">
        						${v3x:showDateByNature(data.standardTime)} 
        					</v3x:column>
        					<v3x:column width="18%" type="String" label="common.average.run.length.label" alt="${v3x:showDateByWork(data.avgRunTime)}">
        						${v3x:showDateByWork(data.avgRunTime)}
        					</v3x:column>
        					<v3x:column width="15%" type="Percent" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.efficiency')}" alt="${v3x:showNumber2Percent(data.efficiency) }">
        						${v3x:showNumber2Percent(data.efficiency) }</v3x:column>
        					<v3x:column width="12%" type="Percent" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.overCaseCount')}" alt="${data.overCaseCount }">
        						${data.overCaseCount }</v3x:column>
        					<v3x:column width="12%" type="Percent" label="${ctp:i18n('performanceReport.workFlowAnalysis.comprehensiveList.overTimeRatio')}" alt="${v3x:showNumber2Percent(data.overTimeRatio) }">
        						${v3x:showNumber2Percent(data.overTimeRatio) }
        						<c:if test="${empty allCaseCount or allCaseCount lt data.allCaseCount}">
        							<c:set var="allCaseCount" value="${data.allCaseCount }" />
        						</c:if>
        					</v3x:column>
        					<v3x:column width="18%" type="String" label="common.the.average.length.of.overtime.label" alt="${v3x:showDateByWork(data.avgOverTime)}">
        						${v3x:showDateByWork(data.avgOverTime)}</v3x:column>
        				</v3x:table>
				</c:if>
        		</div>
        	</div>
        </form>
       </div>
      </div>
    <div class="cDrag" id="cDragdataListTable" style="top: 1px;"></div>
    <div class="bottom_div_row3" id="lastLine" style="line-height:30px;">
		<fmt:message key="common.process.total.number.label">
			<fmt:param value="${empty allCaseCount ? 0 : allCaseCount}"/>
		</fmt:message>
    </div>
  </div>
</div>
<iframe name="temp_iframe" id="temp_iframe" style="display:none;">&nbsp;</iframe>
</body>
</html>