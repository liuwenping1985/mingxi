<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<%@include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>
<script type="text/javascript">
<!--
var reportType = 1;
$(function(){  
    initButton();
	var isSection="${isSection}";
	var tableChart="${tableChart}";
	if(isSection=='true'){
		$("#scrollListDiv").css("top","0px");
		$("#scrollListDiv").css("bottom","0px");
		$("#heep_td,#tabs_head,#lastLine").css("display","none");
		$("#chartDiv").removeClass("border_all");
		if(tableChart=='2'){
	        $("#chartDiv").show();
	        $("#tabs_body").hide();
	        showChart(${timeoutChart});
		}
	}else{
		 if(tableChart!=null&&tableChart!=''){
    		 if(tableChart == "1"){
    			 $("#tableResult").parent().addClass('current').siblings().removeClass('current');
    		        $("#tabs_body").show();
    		        $("#chartDiv").hide();
             }else if(tableChart == "2"){
            	 $("#chartResult").parent().addClass('current').siblings().removeClass('current');
                 $("#chartDiv").show();
                 $("#tabs_body").hide();
                 showChart(${timeoutChart});
             }
    	 }
	}
});


var chartObject;
function printContent(){
  //debugger;
  if($("#chartDiv").is(":hidden")){//图隐藏
    popprint();
  }else{//图显示
    var chartObjS = new Array();
    chartObjS.push(chartObject);
    printFlashChart2IMG(chartObjS);
  }
}

var baseUrl="${path}";
function exportTimeoutExcel() {
	document.getElementById("templeteId").value = parent.document.getElementById("templeteId").value;
	var flowstate = parent.document.getElementsByName("flowstate");
	for (var i = 0 ; i < flowstate.length ; i ++) {
		if (flowstate[i].checked) {
			document.getElementById("flowstate"+i).value = flowstate[i].value;
		}else{
			document.getElementById("flowstate"+i).disabled = true;
		}
	}
	document.getElementById("beginDate").value = parent.document.getElementById("beginDate").value;
	document.getElementById("endDate").value = parent.document.getElementById("endDate").value;

	var searchForm = document.getElementById("searchForm");
	searchForm.action = ""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=exportTimeoutExcel";
	searchForm.target = "temp_iframe";
	searchForm.submit();
}

function initButton(){
    $("#tableResult").click(function(){
        $("#ul_tab li").toggleClass("current");
        $("#tabs_body").show();
        $("#chartDiv").hide();
        reportType = 1;
        parent.document.getElementById("tableChart").value=1;

    });
    $("#chartResult").click(function(){
        $("#ul_tab li").toggleClass("current");
        $("#chartDiv").show();
        $("#tabs_body").hide();
        showChart(${timeoutChart});
        reportType = 2;
        parent.document.getElementById("tableChart").value=2;
    });
}

//var simpleDataList_id = new Array();
function showChart(improvementChart) {
  //debugger;
  	reportType = 2;
	var seriesTypes = new Array(ChartType.column_cylinder,ChartType.line_vertical);
	var seriesNames = new Array("${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.runTime')}",
			"${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.workFlowDeadline')}");//"运行时长","流程期限"
	chartObject = new SeeyonChart({
	  	//title: "超时分析统计图",
	    htmlId:"chartDiv",
	    width : "100%",
	    height: "100%",
	    border : false,
	    animation : true,
	    legend : "true",   //显示图例
	    toolTip : "{%Name}-{%SeriesName}-{%Value}{trailingZeros:false}${ctp:i18n('performanceReport.time.hour')}",
	    outsideLabel : "{%Value}{trailingZeros:false}${ctp:i18n('performanceReport.time.hour')}",
	    yLabels : {format:"{%Value}{trailingZeros:false}${ctp:i18n('performanceReport.time.hour')}"},
	    seriesTypes : seriesTypes,
	    seriesNames : seriesNames,
	    chartJson : improvementChart,
	    event : [{name:"pointClick",func:onPointClick}],
	    fromReport : true
	  });
}
function onPointClick(e){
	var url = e.data.ID;
	if(!$.isNull(url)){
		openDetailWindow(baseUrl,e.data.ID,e.data.Name,"${appTypeName}","timeout");
	}
}
function forwardToCol(){
	var contentHtml="";
    if(reportType==2){
 		if(chartObject!=null){
 		if ( $.browser.msie ){
   		if($.browser.version<8){//对不起，当前您的浏览器版本过低无法支持图表的打印与转发，请升级至IE8及以上版本
   			$.alert("${ctp:i18n('report.chart.ie7.info')}");
   			return;
   		}
   	}
 		//for(var i=0;i<chartObject.length;i++){
 				contentHtml+="<img src='data:image/gif;base64,"+chartObject.chart.getPNG()+"'>";
 		//	}
 		}
 	}else{
 		convertTable();
 		contentHtml = "<div style='height:300px;'>"+$("#dataListDiv").html()+"</div>";
 	}
 	parent.window.closeAndForwardToCol("超时分析", contentHtml);
    
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
		//	str+="<table class='table-header-print table-header-print-dataTable' border='0' cellspacing='0' cellpadding='0'>"
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
//-->
</script>
<style type="text/css">
      .stadic_head_height{
          height:30px;
      }
      .stadic_body_top_bottom{
       bottom: 0px;
          top: 0px;
          overflow:hidden;
      }
</style>
<script>
$(document).ready(function(){
    var isSection="${isSection}";
	if(isSection =='true'){
		$("#scrollListDiv").height($("body").height());
	}else{
		$("#scrollListDiv").height($("body").height()-90);
	}
	window.parent.window.$('#querySave').attr('disabled',false);
})
</script>
</head>
<body class="page_color" style="overflow: hidden;padding-top: 0px; padding-right: 5px; padding-bottom: 0px; padding-left: 5px;">
<div class="main_div_row3">
  <div class="right_div_row3"  style="_padding:0;">
    <div class="top_div_row3" style="height:55px; _position:static;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td id="heep_td" valign="top">
					<div class="portal-layout-cell ">		  	
						<div class="portal-layout-cell_head">
							<div class="portal-layout-cell_head_l"></div>
							<div class="portal-layout-cell_head_r"></div>
						</div>
						<form id="searchForm" action="" method="post">
							<div style="display: none;">
								<input type="checkbox" name="flowstate" id="flowstate0" checked="checked" />
								<input type="checkbox" name="flowstate" id="flowstate1" checked="checked" />
								<input type="checkbox" name="flowstate" id="flowstate2" checked="checked" />
							</div>
							<input type="hidden" id="templeteId" name="templeteId" value=""/>
							<input type="hidden" id="beginDate" name="beginDate" value=""/>
							<input type="hidden" id="endDate" name="endDate" value=""/>
						</form>
						<table border="0" cellSpacing="0" cellPadding="0" >
							<tr>
								<td class="sectionTitleLine sectionTitleLineBackground">
									<span class="searchSectionTitle"><fmt:message key='common.statistic.result.label' /></span>
								</td>
								<td>
									&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<%--转发协同--%>
								<td>
									<span id="ExcportExcel1Div"  style="width: 16px; height: 16px; display: block;" class="ico16 forwarding_16 margin_r_5" onclick='javascript:forwardToCol()'></span>			
								</td>
								<td>
									<a onclick="forwardToCol()">${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}</a>&nbsp;&nbsp;&nbsp;
								</td>
								<td>
									<span id="ExcportExcel1Div" style="width: 16px; height: 16px; display: block;" class="ico16 export_excel_16 margin_r_5" onclick='javascript:exportTimeoutExcel()'></span>			
								</td>
								<td>
									<a onclick="exportTimeoutExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td>
									<span id="printButton1Div" class="ico16 print_16 margin_r_5" style="display: block;" onclick='printContent()'></span>
								</td>
								<td>
									<a onclick="printContent()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
								</td>
								<td>
									&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td>
									<span id="helpButton" class="help cursor-hand margin_r_5" style="display: block;" onclick="showHelpDescription('${path}','timeout')" ></span>	
								</td>
								<td>
									<a  onclick="showHelpDescription('${path}','timeout')">${ctp:i18n('performanceReport.queryMain_js.help.title')}</a>
								</td>	
							</tr>
						</table>
					</div>  
				</td>
			</tr>
		</table>
		<div id="tabs_head" class="common_tabs clearfix">
            <ul class="left" id="ul_tab">
                <li class="current"><a hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe" id="tableResult"><span>${ctp:i18n('performanceReport.workFlowAnalysis.common.table')}</span></a></li>
                <li><a hidefocus="true" class="last_tab" href="javascript:void(0)" tgt="tab2_iframe" id="chartResult"><span>${ctp:i18n('performanceReport.workFlowAnalysis.common.chart')}</span></a></li>
            </ul>
        </div> 
    </div>
    <div class="center_div_row3  bg_color_white" id="scrollListDiv" style="top:55px;_position:static;">
        <div id="chartDiv" class="align_center hidden border_all common_tabs_body stadic_layout_body stadic_body_top_bottom"></div>
       	<div id="tabs_body" class="common_tabs_body border_lr border_b">
       		<div>
				<form method="get" id="listForm" name="listForm">
				<div id="dataListDiv">
				<c:choose>
					<c:when test="${isSection == true }"> 
						<v3x:table width="100%" htmlId="dataListTable" data="${simpleSummaryModel}" var="data" isChangeTRColor="false" className="sort ellipsis"  showPager="false" subHeight="-45">
							<v3x:column width="30%" type="String" label="common.process.header.label" alt="${data.subject}" >
								<a onclick="openDetailWindow(baseUrl,'${data.id}','${data.subject }','${data.appTypeName }','timeout')">${data.subject}</a></v3x:column>
							<v3x:column width="20%" type="String" label="common.running.time.label">
								${v3x:showDateByWork(data.runWorkTime)}
							</v3x:column>
							<v3x:column width="25%" type="String" label="common.timeouts.label" >
								${v3x:showDateByWork(data.overWorkTime)}
							</v3x:column>
							<v3x:column width="24%" type="String" label="process.cycle.label" >
								${v3x:showDateByNature(data.deadline)}
							</v3x:column>
						</v3x:table>
					</c:when>
					<c:otherwise>
						<v3x:table width="100%" htmlId="dataListTable" data="${simpleSummaryModel}" var="data" isChangeTRColor="false" className="sort ellipsis">
							<v3x:column width="30%" type="String" label="common.process.header.label" alt="${data.subject}" >
								<a onclick="openDetailWindow(baseUrl,'${data.id}','${data.subject }','${data.appTypeName }','timeout')">${data.subject}</a></v3x:column>
							<v3x:column width="20%" type="String" label="common.running.time.label">
								${v3x:showDateByWork(data.runWorkTime)}
							</v3x:column>
							<v3x:column width="25%" type="String" label="common.timeouts.label" >
								${v3x:showDateByWork(data.overWorkTime)}
							</v3x:column>
							<v3x:column width="24%" type="String" label="process.cycle.label" >
								${v3x:showDateByNature(data.deadline)}
							</v3x:column>
						</v3x:table>
					</c:otherwise>
				</c:choose>
				</div>
				</form>
               </div>
   		</div>
	</div>
    <div class="bottom_div_row3" id="lastLine" style="line-height:30px;">
		<table>
			<tr style="height: 20px;display:${empty simpleSummaryModel ?'none':''}">
				<td>
				&nbsp;&nbsp;
				<fmt:message key="common.note.3.label">
					<fmt:param>${v3x:showDateByWork(avgRunWorkTime)}</fmt:param>
					<fmt:param>${v3x:showNumber2Percent(radio)}</fmt:param>
				</fmt:message>
				</td>
			</tr>			 
		</table>
    </div>
  </div>
</div>

<iframe name="temp_iframe" id="temp_iframe" style="display:none;">&nbsp;</iframe>
</body>
</html>