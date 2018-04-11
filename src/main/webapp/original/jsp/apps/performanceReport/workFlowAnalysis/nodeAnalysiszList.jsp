<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<%@include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>节点分析</title>
<script type="text/javascript">
<!--
var reportType = 1;
$(function(){
    initButton();
	var isSection="${isSection}";
	var tableChart="${tableChart}";
	if(isSection=='true'){
		$("#heep_td,#tabs_head").css("display","none");
		$("#scrollListDiv").css("top","0px");
		 $("#scrollListDiv").css("bottom","0px");
		 $("#chartDiv").removeClass("border_all");
		if(tableChart=='2'){
	        $("#chartDiv").show();
	        $("#tabs_body").hide();
	        showChart(${chartNode});
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
                showChart(${chartNode});
            }
   		 }
	}
})

var chartObject;
function printContent(){
  if($("#chartDiv").is(":hidden")){//图隐藏
    popprint();
  }else{//图显示
    var chartObjS = new Array();
    chartObjS.push(chartObject);
    printFlashChart2IMG(chartObjS);
  }
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
        showChart(${chartNode});
        reportType = 2;
        parent.document.getElementById("tableChart").value=2;
    });
}

var baseUrl="${path}";
function openNodeAccessDetailWindow(id, policyName, memberName, overRadio, avgRunWorkTime) {
	var params = fetchParam4Detail();
	var templeteId = params[0];
	var beginDate = params[1];
	var endDate = params[2];
	
	v3x.openWindow({
        url: encodeURI(""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=nodeAnalysiszNodeAccessFrame&templeteId="+templeteId+"&nodeId="+id
        		+"&policyName="+policyName+"&memberName="+memberName+"&beginDate="+beginDate+"&endDate="+endDate
        		+"&overRadio="+overRadio+"&avgRunWorkTime="+avgRunWorkTime),
        dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1",
        width: "750",
        height: "500"
    });
}

function fetchParam4Detail(){
	var tempInput = parent.document.getElementById("templeteId");
	var templeteId = '';
	var beginDate = '';
	var endDate = '';
	var temps = '';
	var urlPart = '';
	if(tempInput==null){//当不能从父页面取到数据的时候，从页面的url里面取（目前已知出现在首页栏目的场景下）
		// 从url获取模板id,beginDate,endDate
    	var hstr = self.location.href;
    	var params = hstr.split("&");
    	for(var pi=0; pi < params.length; pi++){
    		urlPart=params[pi];
    		if(urlPart.indexOf("templeteId")>=0){
    			temps = urlPart.split("=");
    			templeteId = temps[1];
    		}else if(urlPart.indexOf("beginDate")>=0){
    			temps = urlPart.split("=");
    			beginDate = temps[1];
	    	}else if(urlPart.indexOf("endDate")>=0){
	    		temps = urlPart.split("=");
	    		endDate = temps[1];
	    	}
    	}
	}else{
		templeteId = parent.document.getElementById("templeteId").value;
		beginDate = parent.document.getElementById("beginDate").value;
		endDate = parent.document.getElementById("endDate").value;
	}
	
	return [templeteId,beginDate, endDate];
}

function openNodeNameDetailWindow(id,memberName) {
	var params = fetchParam4Detail();
	var templeteId = params[0];
	var beginDate = params[1];
	var endDate = params[2];
	
	v3x.openWindow({
        url: encodeURI(""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=nodeAnalysiszNodeNameFrame&templeteId="+templeteId+"&nodeId="+id+"&beginDate="
        		+beginDate+"&endDate="+endDate+"&memberName="+memberName),
        dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1",
        width: "750",
        height: "500"
    });
}

function exportNodeExcel() {
	document.getElementById("templeteId").value = parent.document.getElementById("templeteId").value;
	document.getElementById("beginDate").value = parent.document.getElementById("beginDate").value;
	document.getElementById("endDate").value = parent.document.getElementById("endDate").value;
	
	var searchForm = document.getElementById("searchForm");
	searchForm.action = ""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=exportNodeExcel";
	searchForm.target = "temp_iframe";
	searchForm.submit();
}

function showDigarm() {
	var templeteId = parent.document.getElementById("templeteId").value;
	if (templeteId == "") {
		alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
		return ;
	}
	$.post(""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=viewWorkflow",{templeteId:templeteId},function(data){
		var ptemplateId=data;
		showWFTDiagram(parent.window,ptemplateId,window);
	});
}
/**
 * 显示流程模版流程图
 * @tWindow 目标窗口window对象
 * @ptemplateId 流程模版ID
 * @vWindow 值回写window对象
 */
function showWFTDiagram(tWindow,ptemplateId,vWindow){
  var returnValueWindow= tWindow;
  if(vWindow){
    returnValueWindow= vWindow;
  }
  if(typeof(workfowFlashDialog) != "undefined" && workfowFlashDialog){
    workfowFlashDialog.isHide = false;
    workfowFlashDialog.close();
  }
  var dwidth= $(tWindow).width();
  var dheight= $(tWindow).height();

  workfowFlashDialog = $.dialog({
    isHide : true,
    url : '<c:url value="/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=true&processId="/>'+ptemplateId,
    width : 770,
    height : 350,
    title : ' ',
    transParams : {
      dwidths: 800,
      dheights: 450,
      returnValueWindow:returnValueWindow
    },
    minParam:{show:false},
    maxParam:{show:false},
    buttons : [ {
      text : "${ctp:i18n('workflow.designer.page.button.close')}",
      handler : function() {
        if(!$.browser.msie){
          workfowFlashDialog.close();  
        }else{
          workfowFlashDialog.hideDialog();
        }
      }
    } ],
    targetWindow: tWindow
  });
}

function showChart(improvementChart) {
	reportType = 2;
	var seriesNames = new Array("${ctp:i18n('performanceReport.workFlowAnalysis.nodeAnalysiszList.aveProcessTime')}",
			"${ctp:i18n('performanceReport.workFlowAnalysis.chartOverTimeRatio')}");//"平均处理时长","超时率"
	var seriesTypes = new Array(ChartType.column,ChartType.line_vertical,ChartType.line_vertical);
	chartObject = new SeeyonChart({
		  	//title: "节点分析统计图",
		    htmlId:"chartDiv",
		    width : "100%",
		    height: "100%",
		    chartJson : improvementChart,
		    event : [{name:"pointClick",func:onPointClick}]
		  });
}
function onPointClick(e){
	var url = e.data.ID;
	if(!$.isNull(url)){//协同V5.0 OA-32227 将穿透方法在后台准备好，前端直接通过eval运行js方法
	    eval(url);
// 		openNodeAccessDetailWindow(e.data.ID,'${data.policyName}',e.data.Name,'${data.overRadio }','${data.avgRunWorkTime }');
	}
}
$(document).ready(function(){
    var isSection="${isSection}";
	if(isSection =='true'){
		$("#scrollListDiv").height($("body").height());
	}else{
		$("#scrollListDiv").height($("body").height()-90);
	}
	window.parent.window.$('#querySave').attr('disabled',false);
})
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
 	parent.window.closeAndForwardToCol("节点分析", contentHtml);
    
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
</head>
<body class="page_color" style="overflow: hidden;padding-top: 0px; padding-right: 5px; padding-bottom: 0px; padding-left: 5px;">
<div class="main_div_row2">
  <div class="right_div_row2" style="_padding:0;">
    <div class="top_div_row2" id="hidden_div" style="height:55px; _position:static;">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td id="heep_td" valign="top">
					<div class="portal-layout-cell ">		  	
						<form id="searchForm" action="" method="post">
							<input type="hidden" id="templeteId" name="templeteId" value=""/>
							<input type="hidden" id="beginDate" name="beginDate" value=""/>
							<input type="hidden" id="endDate" name="endDate" value=""/>
						</form>
						<table border="0" cellSpacing="0" cellPadding="0" class="portal-layout-cell-right">
							<tr>
								<td class="sectionTitleLine sectionTitleLineBackground">
									<span class="searchSectionTitle"><fmt:message key='common.statistic.result.label' /></span>
								</td>
								<td nowrap>
									&nbsp;&nbsp;&nbsp;
								</td>
								<%--转发协同--%>
								<td>
									<span id="ExcportExcel1Div"  style="width: 16px; height: 16px; display: block;" class="ico16 forwarding_16 margin_r_5" onclick='javascript:forwardToCol()'></span>			
								</td>
								<td>
									<a onclick="forwardToCol()">${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}</a>&nbsp;&nbsp;&nbsp;
								</td>
								<td nowrap>
									<span class="icon_com display_block flow_com margin_r_5"  onclick="showDigarm()"></span>
								</td>
								<td nowrap>
									<a onclick="showDigarm()"><fmt:message key='common.view.the.processflow.label' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td nowrap>
									<span id="ExcportExcel1Div" style="width: 16px; height: 16px; display: block;" class="ico16 export_excel_16 margin_r_5" onclick='javascript:exportNodeExcel()'></span>			
								</td>
								<td nowrap>
									<a onclick="exportNodeExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td nowrap>
									<span id="printButton1Div" class="ico16 print_16 margin_r_5" style="display: block;" onclick='printContent()'></span>
								</td>
								<td nowrap>
									<a onclick="printContent()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
								</td>
								<td nowrap>
									&nbsp;&nbsp;&nbsp;
								</td>
								<td nowrap>
									<span id="helpButton" class="help cursor-hand margin_r_5" style="display: block;" onclick="showHelpDescription('${path}','node')" ></span>	
								</td>
								<td>
									<a onclick="showHelpDescription('${path}','node')">${ctp:i18n('performanceReport.queryMain_js.help.title')}</a>
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
    <div class="center_div_row2 bg_color_white" id="scrollListDiv" style="top:55px;_position:static;" >
    	<div id="chartDiv" class="align_center border_all hidden common_tabs_body stadic_layout_body stadic_body_top_bottom"></div>
       	<div id="tabs_body" class="common_tabs_body border_lr border_b">
       		<div>
       			<form method="get" >
					<div id="dataListDiv">
					<c:choose> 
       					<c:when test="${isSection == true }"> 
							<v3x:table width="100%" htmlId="dataListTable"	data="${nodeAnalysis}" var="data" isChangeTRColor="false" className="sort ellipsis" showPager="false" subHeight="-45">
							<v3x:column width="25%" type="String" label="common.node.access.label" alt="${data.policyName}" >
								<a onclick="openNodeAccessDetailWindow('${data.id }','${data.policyName}','${data.name}','${data.overRadio }','${data.avgRunWorkTime }')">${data.policyName}</a></v3x:column>
							<v3x:column width="25%" type="String" label="common.node.name.label">
								<a onclick="openNodeNameDetailWindow('${data.id }','${data.name}')">${data.name}</a></v3x:column>
							<v3x:column width="25%" type="String" label="common.overtime.rate.label" >
								${v3x:showNumber2Percent(data.overRadio)}</v3x:column>
							<v3x:column width="24%" type="String" label="common.average.handling.time.label" >
								${v3x:showDateByWork(data.avgRunWorkTime) }</v3x:column>
							</v3x:table>
						</c:when> 
				       	<c:otherwise>
				       		<v3x:table width="100%" htmlId="dataListTable"	data="${nodeAnalysis}" var="data" isChangeTRColor="false" className="sort ellipsis" >
							<v3x:column width="25%" type="String" label="common.node.access.label" alt="${data.policyName}" >
								<a onclick="openNodeAccessDetailWindow('${data.id }','${data.policyName}','${data.name}','${data.overRadio }','${data.avgRunWorkTime }')">${data.policyName}</a></v3x:column>
							<v3x:column width="25%" type="String" label="common.node.name.label">
								<a onclick="openNodeNameDetailWindow('${data.id }','${data.name}')">${data.name}</a></v3x:column>
							<v3x:column width="25%" type="String" label="common.overtime.rate.label" >
								${v3x:showNumber2Percent(data.overRadio)}</v3x:column>
							<v3x:column width="24%" type="String" label="common.average.handling.time.label" >
								${v3x:showDateByWork(data.avgRunWorkTime) }</v3x:column>
							</v3x:table>
				       	</c:otherwise>
				       	</c:choose>
					</div>
				</form>
			</div>
       	</div>
    </div>
  </div>
</div>
<iframe name="temp_iframe" id="temp_iframe" style="display:none;">&nbsp;</iframe>
</body>
</html>