<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<%@include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>改进分析</title>
<script type="text/javascript">
<!--
function exportImprovementExcel() {
	
	document.getElementById("templeteId").value = parent.document.getElementById("templeteId").value;
	document.getElementById("beginDate1").value = parent.document.getElementById("beginDate1").value;
	document.getElementById("beginDate2").value = parent.document.getElementById("beginDate2").value;
	document.getElementById("endDate1").value = parent.document.getElementById("endDate1").value;
	document.getElementById("endDate2").value = parent.document.getElementById("endDate2").value;
	var baseUrl="${path}";
	var searchForm = document.getElementById("searchForm");
	searchForm.action = ""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=exportImprovementExcel";
	searchForm.target = "temp_iframe";
	searchForm.submit();
}
//-->
</script>
<script type="text/javascript">
var reportType = 1;
 $(function(){  
     	initButton();
		var isSection="${isSection}";
		var tableChart="${tableChart}";
		if(isSection=='true'){
			$("#tabs_head,#heep_td,#lastLine").css("display","none");
			 $("#scrollListDiv").css("top","0px");
			 $("#scrollListDiv").css("bottom","0px");
			 $("#chartDiv").removeClass("border_all");
			if(tableChart=='2'){
				 $("#ul_tab li").toggleClass("current");
	        	 $("#chartDiv").show();
	             $("#tabs_body").hide();
	             showChart(${chart});
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
	                 showChart(${chart});
	             }
	    	 }
		}
 });
 
 
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
             showChart(${chart});
             reportType = 2;
             parent.document.getElementById("tableChart").value=2;
         }
     });
 }

 function showChart(improvementChart) {
 	reportType = 2;
     var seriesTypes = new Array(ChartType.line_vertical,ChartType.column,ChartType.line_vertical);
     var seriesNames = new Array("${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.standard')}",
    		 "${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.runTime')}",
    		 "${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.runEff')}");//"基准时长","运行时长","运行效率"
     chartObject = new SeeyonChart({
       htmlId:"chartDiv",
       width : "100%",
       height: "100%",
       border : false,
       animation : true,
       legend : "true",   //显示图例
       seriesTypes : seriesTypes,
       seriesNames : seriesNames,
       chartJson : improvementChart,
       extraYaxisNameList : ["","","a"],
       extraYaxisNodeList : [{
             name : "a",
             yLabels : {
               format : "{%Value}{numDecimals:0}%"
             }
       }],
       fromReport : true,
       debugge : false
     });
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
 	parent.window.closeAndForwardToCol("改进分析", contentHtml);
    
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
<body class="page_color" style="overflow: hidden; padding-top: 0px; padding-right: 5px; padding-bottom: 0px; padding-left: 5px;">
<div class="main_div_row3">
  <div class="right_div_row3" style="_padding:0;">
    <div class="top_div_row3" style="height:55px; _position:static;">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<div class="portal-layout-cell ">		  	
						<form id="searchForm" action="" method="post">
							<input type="hidden" id="templeteId" name="templeteId" value=""/>
							<input type="hidden" id="beginDate1" name="beginDate1" value=""/>
							<input type="hidden" id="beginDate2" name="beginDate2" value=""/>
							<input type="hidden" id="endDate1" name="endDate1" value=""/>
							<input type="hidden" id="endDate2" name="endDate2" value=""/>
						</form>
						<table border="0">
							<tr id="heep_td">
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
									<span id="ExcportExcel1Div" style="width: 16px; height: 16px; display: block;" class="ico16 export_excel_16 margin_r_5" onclick='javascript:exportImprovementExcel()'></span>			
								</td>
								<td>
									<a onclick="exportImprovementExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
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
									<span id="helpButton" class="help cursor-hand margin_r_5" style="display: block;" onclick="showHelpDescription('${path}','improvement')" ></span>	
								</td>
								<td>
									<a onclick="showHelpDescription('${path}','improvement')">${ctp:i18n('performanceReport.queryMain_js.help.title')}</a>
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
	<div  class="center_div_row3 bg_color_white"  id="scrollListDiv" style="top:60px;_position:static;">
	    <div id="chartDiv" class="align_center border_all hidden common_tabs_body stadic_layout_body stadic_body_top_bottom"></div>
	    <div id="tabs_body" class="common_tabs_body border_lr border_b">
	     		<form method="get" >
	    			<div id="dataListDiv">
	                 <div class="hDivBox">
	                 <c:choose> 
       					<c:when test="${isSection == true }"> 
							<v3x:table width="100%"  htmlId="dataListTable" varIndex="num" data="${compareModelList}" var="data" isChangeTRColor="false" className="sort ellipsis" showPager="false" subHeight="-45">
	    					<v3x:column width="15%" type="String" label="common.contrast.range.table.label" alt="${wf.depName}" >
	    						 <c:if test="${num == 0 }">
	    						 	<fmt:message key="common.contrast.range.label" />
	    						 </c:if>
	    						 <c:if test="${num == 1 }">
	    						 	<fmt:message key="common.contrast.interval.two.label" />
	    						 </c:if>
	    						</v3x:column>
	    					<v3x:column width="20%" type="String" label="common.average.run.length.label">
	    						${v3x:showDateByWork(data.avgRunTime)}
	    						 <c:if test="${num == 0 }">
	    						 	<c:set value="${data.avgRunTime }" var="avgRunTime1" />
	    						 </c:if>
	    						 <c:if test="${num == 1 }">
	    						 	<c:set value="${data.avgRunTime }" var="avgRunTime2" />
	    						 </c:if>
	    						</v3x:column>
	    							
	    					<v3x:column width="16%" type="Date" label="common.the.longest.time.label" >
	    						${v3x:showDateByWork(data.maxRunTime)}</v3x:column>
	    					<v3x:column width="16%" type="Date" label="common.the.shortest.period.label" >
	    						${v3x:showDateByWork(data.minRunTime)}</v3x:column>
	    					<v3x:column width="16%" type="Date" label="common.reference.time.label" >
	    						${v3x:showDateByNature(data.standarduaration)}</v3x:column>
	    					<v3x:column width="16%" type="Date" label="common.operating.efficiency.label" >
	    						${v3x:showNumber2Percent(data.efficiency) }
	    						 <c:if test="${num == 0 }">
	    						 	<c:set value="${data.efficiency }" var="efficiency1" />
	    						 </c:if>
	    						 <c:if test="${num == 1 }">
	    						 	<c:set value="${data.efficiency }" var="efficiency2" />
	    						 </c:if>
	    					</v3x:column>
	    				</v3x:table>
				       </c:when> 
				       <c:otherwise>
				       	<v3x:table width="100%"  htmlId="dataListTable" varIndex="num" data="${compareModelList}" var="data" isChangeTRColor="false" showPager = 'false' className="sort ellipsis">
	    					<v3x:column width="15%" type="String" label="common.contrast.range.table.label" alt="${wf.depName}" >
	    						 <c:if test="${num == 0 }">
	    						 	<fmt:message key="common.contrast.range.label" />
	    						 </c:if>
	    						 <c:if test="${num == 1 }">
	    						 	<fmt:message key="common.contrast.interval.two.label" />
	    						 </c:if>
	    						</v3x:column>
	    					<v3x:column width="20%" type="String" label="common.average.run.length.label">
	    						${v3x:showDateByWork(data.avgRunTime)}
	    						 <c:if test="${num == 0 }">
	    						 	<c:set value="${data.avgRunTime }" var="avgRunTime1" />
	    						 </c:if>
	    						 <c:if test="${num == 1 }">
	    						 	<c:set value="${data.avgRunTime }" var="avgRunTime2" />
	    						 </c:if>
	    						</v3x:column>
	    							
	    					<v3x:column width="16%" type="Date" label="common.the.longest.time.label" >
	    						${v3x:showDateByWork(data.maxRunTime)}</v3x:column>
	    					<v3x:column width="16%" type="Date" label="common.the.shortest.period.label" >
	    						${v3x:showDateByWork(data.minRunTime)}</v3x:column>
	    					<v3x:column width="16%" type="Date" label="common.reference.time.label" >
	    						${v3x:showDateByNature(data.standarduaration)}</v3x:column>
	    					<v3x:column width="16%" type="Date" label="common.operating.efficiency.label" >
	    						${v3x:showNumber2Percent(data.efficiency) }
	    						 <c:if test="${num == 0 }">
	    						 	<c:set value="${data.efficiency }" var="efficiency1" />
	    						 </c:if>
	    						 <c:if test="${num == 1 }">
	    						 	<c:set value="${data.efficiency }" var="efficiency2" />
	    						 </c:if>
	    					</v3x:column>
	    				</v3x:table>
				       </c:otherwise> 
					</c:choose>
	    			</div>
	             </div>
	    	</form>
	    </div>
    </div>
    <div class="bottom_div_row3" id="lastLine" style="line-height:30px;">
		<table width="100%" border="0" style="display: ${empty compareModelList ? 'none' : 'block'}">
			<tr style="height: 30px;">
				<td style="padding-left: 20px;" colspan="2">
					<fmt:message key="common.compare.results.label" />：
					
					<fmt:message key="common.average.run.length.label" />
					<c:choose>
						<c:when test="${(avgRunTime1 - avgRunTime2) < 0 }">
							 <fmt:message key="common.promote.label">
							 	<fmt:param value="${v3x:showDateByWork(avgRunTime2 - avgRunTime1) }" />
							 </fmt:message>；
						</c:when>
						<c:otherwise>
							<fmt:message key="common.reduce.label">
							 	<fmt:param value="${v3x:showDateByWork(avgRunTime1 - avgRunTime2) }" />
							 </fmt:message>；
						</c:otherwise>
					</c:choose>
					<fmt:message key="common.operating.efficiency.label" />
					<fmt:formatNumber value="${efficiency1}" type="number" pattern="0.0000" var="e1"/>
					<fmt:formatNumber value="${efficiency2}" type="number" pattern="0.0000" var="e2"/>
					<c:choose>
					
						<c:when test="${(efficiency1 - efficiency2) < 0 }">
							<fmt:message key="common.promote.percent.label">
							 	<fmt:param value="${(e2 - e1) * 100}" />
							 </fmt:message>
						</c:when>
						<c:otherwise>
							<fmt:message key="common.reduce.percent.label">
							 	<fmt:param value="${(e1 - e2) * 100}" />
							 </fmt:message>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			
		</table>
    </div>
  </div>
</div>
<iframe name="temp_iframe" id="temp_iframe" style="display:none;">&nbsp;</iframe>
</body>
</html>