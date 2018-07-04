<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="Collaborationheader.jsp" %>
<%-- <%@ include file="../../common/INC/noCache.jsp"%> --%>
<%@include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/workFlowAnalysis/js/workflowAnalysis.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
</head>
<script language="javascript">
function openList(appType,entityType,entityId,state,beginDate,endDate,templateId,appName,statScope){
	var rv = v3x.openWindow({
        url: "${path}/performanceReport/WorkFlowAnalysisController.do?method=statResultListMain&appType=" + appType + "&entityId="
         + entityId + "&entityType=" + encodeURIComponent(entityType) + "&state=" + state 
         + "&beginDate=" + beginDate + "&endDate=" + endDate + "&templateId=" + (templateId==null||templateId=='null' ?　''　:　templateId)
         + "&appName=" + appName+"&statScope="+statScope,
        height: 590,
        width: 770,
        resizable:'no'
    });
}

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


var reportType = 1;
$(function(){
    initButton();
	var isSection="${isSection}";
	var tableChart="${tableChart}";
	if(isSection=='true'){
		$("#heep_td,#tabs_head,#top_head,#bottom_sort,#lastLine").css("display","none");
		if(tableChart=='2'){
	        $("#chartDiv").show();
	        $("#tabs_body").hide();
	        showChart(${workflowChart});
		}
		$("#scrollListDiv").css("top","0px");
		$("#scrollListDiv").css("bottom","0px");
		$("#chartDiv").removeClass("border_all");
	}else{
		 if(tableChart!=null&&tableChart!=''){
    		 if(tableChart == "1"){
    		        $($("#ul_tab li")[0]).attr("class","current");
    		        $($("#ul_tab li")[1]).attr("class","");
    		        $("#tabs_body").show();
    		        $("#chartDiv").hide();
    		        reportType = 1;
             }else if(tableChart == "2"){
            	 $($("#ul_tab li")[0]).attr("class","");
            	 $($("#ul_tab li")[1]).attr("class","current");
                 $("#chartDiv").show();
                 $("#tabs_body").hide();
                 reportType = 2;
                 showChart(${workflowChart});
             }
    	 }
	}
	window.parent.window.$('#querySave').attr('disabled',false);
})

function initButton(){
    $("#tableResult").click(function(){
        $("#ul_tab li").toggleClass("current");
        $("#tabs_body").show();
        $("#chartDiv").hide();
        $(".sort").show();
        reportType = 1;
        parent.document.getElementById("tableChart").value=1;        
    });
    $("#chartResult").click(function(){
        $("#ul_tab li").toggleClass("current");
        $("#chartDiv").show();
        $("#tabs_body").hide();
        $(".sort").hide();
        showChart(${workflowChart});
        reportType = 2;
        parent.document.getElementById("tableChart").value=2;
    });
}

//var simpleDataList_id = new Array();
function showChart(improvementChart) {
	var seriesNames = new Array("${ctp:i18n('performanceReport.queryMainHtml.typeSent')}",
			"${ctp:i18n('performanceReport.queryMainHtml.typeDone')}",
			"${ctp:i18n('performanceReport.queryMainHtml.typeUndo')}",
			"${ctp:i18n('performanceReport.queryMainHtml.typeOverDue')}");//已发,已办,待办,超期
	chartObject = new SeeyonChart({
	    htmlId:"chartDiv",
	    width : "100%",
	    height: "100%",
	    chartJson : improvementChart,
	    event : [{name:"pointClick",func:onPointClick}]
	  });
}
function onPointClick(e){
	var url = e.data.ID;
	//协同V5.0 OA-32079 值为0，不穿透
	var value = e.data.YValue;
	if(value != 0 && !$.isNull(url)){
		eval(e.data.ID);
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
    //  }
    }
  }else{
    convertTable();
    contentHtml = "<div style='height:300px;'>"+$("#dataListDiv").html()+"</div>";
  }
  parent.window.closeAndForwardToCol("流程统计", contentHtml);
    
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
      .stadic_head_height{
          height:30px;
      }
      .stadic_body_top_bottom{
       bottom: 0px;
          top: 0px;
          overflow:hidden;
      }
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}"/>">
<script>
$(document).ready(function(){
    var isSection="${isSection}";
	if(isSection =='true'){
		$("#scrollListDiv").height($("body").height());
	}else{
		$("#scrollListDiv").height($("body").height()-100);
	}
	$("#lastLine").css("height","40px");
})
</script>
<style>.mxt-grid-header{padding-bottom: 0px;}</style>
<body class="page_color" style="overflow: hidden;padding-top: 0px; padding-right: 5px; padding-bottom: 0px; padding-left: 5px;" class="h100b">
<div class="main_div_row3 ">
	<div class="right_div_row3" style="_padding:0;height:97%">
	<div class="top_div_row3" id="top_head" style="height:50px; _position:static;">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr >
			<td id="heep_td" valign="top" class="border-padding">
				<div class="">
					<div class="" style="float: left;" >
						<span style="height:15px;float:left;padding-top:0px;margin-right: 10px;">${ctp:i18n('performanceReport.queryMain.result')}</span>
					</div>
					<span style="margin-right: 20px; float: left;" >
						<form id="searchForm" action="" method="post">
							<%--转发协同--%>
							<td>
								<c:choose>
								<c:when test="${isGroupAdmin || isAdministrator}">
								</c:when>
								<c:otherwise>
								<span id="ExcportExcel1Div"  style="width: 16px; height: 16px; display: block;" class="ico16 forwarding_16 margin_r_5" onclick='javascript:forwardToCol()'></span>			
								</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
								<c:when test="${isGroupAdmin || isAdministrator}">
								</c:when>
								<c:otherwise>
									<span style="height:15px; padding-top:3px; margin-right: 20px; float: left"><a onclick="forwardToCol()">${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}</a></span>
								</c:otherwise>
								</c:choose>
							</td>
							<td>
								<span id="exportExcel" style="width: 16px; height: 16px; display: block;" class="ico16 export_excel_16 margin_r_5" onclick='javascript:parent.exportExcel()'></span>			
							</td>
							<td>
								<span style="height:15px;float:left;padding-top:3px;margin-right:20px"><a onclick="javascript:parent.exportExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a></span>
							</td>
							<td>
								<span id="printButton1Div" class="ico16 print_16 margin_r_5" style="display: block;" onclick='printContent()'></span>
							</td>
							<td>
								<span style="height:15px;float:left;padding-top:3px;margin-right:20px"><a onclick="printContent()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a></span>
							</td>
							<td>
								<span id="helpButton" class="help cursor-hand margin_r_5" style="display: block;" onclick="showHelpDescription('${path}','flow')" ></span>	
							</td>
							<td>
								<span style="height:15px;float:left;padding-top:3px;margin-right:20px"><a onclick="showHelpDescription('${path}','flow')" >${ctp:i18n('performanceReport.queryMain_js.help.title')}</a></span>
							</td>
						</form>
					</span>
				</div>	
			</td>
			</tr>
		</table>
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left" id="ul_tab">
				<li class="current"><a hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe" id="tableResult"><span>${ctp:i18n('performanceReport.queryMain.result.tableResult')}</span></a></li>
				<li><a hidefocus="true" class="last_tab" href="javascript:void(0)" tgt="tab2_iframe" id="chartResult"><span>${ctp:i18n('performanceReport.queryMain.result.chartResult')}</span></a></li>
            </ul>
        </div>
    </div>
    <div class="center_div_row3  bg_color_white" id="scrollListDiv" style="top:50px;_position:static;"> 
			<c:choose>
				<c:when test="${isGroupAdmin||param.isGroupAdmin}">
					<c:choose>
						<c:when test="${param.statType=='Member'}">
							<c:set var="width" value="15%"/>
						</c:when>
						<c:otherwise>
							<c:set var="width" value="25%"/>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:set var="width" value="15%"/>
				</c:otherwise>
			</c:choose>
			<c:set var="isGroup" value="${param.statScope=='group'}" />
			<%--
			 <c:set var="appType" value="${v3x:getApplicationCategoryName(param.appType, pageContext) }"/>
			 --%> 
            <div id="chartDiv" class="align_center border_all hidden common_tabs_body stadic_layout_body stadic_body_top_bottom"></div>
            <div id="tabs_body" class="common_tabs_body border_lr border_b">
				<form method="get" >
				<div id="dataListDiv">
        		<div class="hDivBox">
        		<c:choose>
					<c:when test="${isSection == true }"> 	
						<v3x:table width="100%" htmlId="dataListTable" data="${result }" var="row" isChangeTRColor="false" className="sort ellipsis" showPager="false" subHeight="-35">
							<c:set var="count" value="${count+1 }" />
							<!-- 第一列 -->
							<c:if test="${!isGroupAdmin && !param.isGroupAdmin}">
								<c:if test="${!isGroup }">
									<c:choose>
										<c:when test="${(row[9]=='collaboration' || row[9]=='edoc')&&row[0]==null}">
											<fmt:message key='self.create.workflow' var="typeTitle"/>
										</c:when>
										<c:otherwise>
											<c:set var="typeTitle" value="${row[1]==null ? '&nbsp;' : row[1] }"/>
										</c:otherwise>
									</c:choose>
								</c:if>
								<v3x:column width="15%" align="left" type="String" label="common.operation.type" alt="${isGroup ? appType : typeTitle}">
									<c:if test="${isGroup }">
										${appType }
									</c:if>
									<c:if test="${!isGroup }">
										${typeTitle }
									</c:if>
								</v3x:column>
							</c:if>
							
							<!-- 第二列-->
							<v3x:column width="${width}" type="String" align="left" label="${isGroupAdmin && param.statWhat=='Account' ? 'org.account.label' : 'org.department.label'}" alt="${showMemberTitle }">
								<c:if test="${isGroup }">
									<c:choose>
										<c:when test="${param.statType=='Account'|| param.statType=='Department'}">
											<c:set var="showMemberTitle" value="${v3x:showOrgEntitiesOfIds(row[0],param.statType,pageContext)}"/>
											<c:set var="showMember" value="${v3x:getLimitLengthString(showMemberTitle,30,'...')}"/>
										</c:when>
										<c:when test="${param.statType=='Member'}">
											<c:set var="member" value="${v3x:getOrgEntity('Member',row[1]) }"/>
											<c:set var="showMemberTitle" value="${v3x:showOrgEntitiesOfIds(member.orgDepartmentId,'Department',pageContext)}"/>
											<c:set var="showMember" value="${v3x:getLimitLengthString(showMemberTitle,30,'...')}"/>
										</c:when>
										<c:otherwise>
											<c:set var="showMemberTitle" value=""/>
											<c:set var="showMember" value="&nbsp;"/>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if test="${!isGroup }">
									<c:set var="showMember" value="${row[2]==null ? '' : v3x:showOrgEntitiesOfIds(row[2],'Department',pageContext) }"/>
								</c:if>
								${showMember }
							</v3x:column>
							
							<!-- 第三列-->
							<c:if test="${param.statType=='Member' }">
							<v3x:column width="13%" type="String" align="left" label="org.member.label" alt="">
								<c:if test="${isGroup }">
									${row[1]==null?"&nbsp;" : v3x:showMemberName(row[1]) }
								</c:if>
								<c:if test="${!isGroup }">
									${row[3]==null?"&nbsp;" : v3x:showMemberName(row[3]) }
								</c:if>
							</v3x:column>
							</c:if>
							<!-- 第四列-->
							<v3x:column width="13%" align="left" label="stat.sent.count" alt="" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[2]!= null && row[2]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','2','${param.beginDate }','${param.endDate }','','','${param.statScope }')"
									</c:if>
									>
									${row[2]==null?0 : row[2] }
									</span>
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[4]!= null && row[4]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','2','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[4]==null?0 : row[4] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第五列-->
							<v3x:column width="13%" align="left" label="stat.done.count" alt="" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[3]!= null && row[3]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','4','${param.beginDate }','${param.endDate }','','','${param.statScope }')"
									</c:if>
									>
									${row[3]==null?0 : row[3] }
									</span>
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[5]!= null && row[5]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','4','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[5]==null?0 : row[5] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第六列-->
							<v3x:column width="13%" align="left" label="stat.pending.count" alt="" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[4]!= null && row[4]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','3','${param.beginDate }','${param.endDate }','','','${param.statScope }')"
									</c:if>
									>
									${row[4]==null?0 : row[4] }
									</span>	
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[6]!= null && row[6]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','3','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[6]==null?0 : row[6] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第七列-->
							<c:set value="${isGroup ? (row[5]==null?'&nbsp;' : row[5]) : (row[7]==null?'&nbps;' : row[7]) }" var="severTitle" />
							<v3x:column width="13%" align="left" label="stat.deadline.count" alt="${severTitle}" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[5]!= null && row[5]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','-1','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[5]==null?'&nbsp;' : row[5]}
									</span>
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[7]!= null && row[7]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','-1','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[7]==null?'&nbps;' : row[7] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第八列 -->
							<v3x:column width="20%" align="left" className="sort" label="stat.deadline.totalTime" alt="${row[6]}">
								${isGroup ? (empty row[6] ? '-' : row[6]) : (row[8])}
							</v3x:column>
						</v3x:table>
					</c:when>
					<c:otherwise>
						<v3x:table width="100%" htmlId="dataListTable" data="${result }" var="row" isChangeTRColor="false" className="sort ellipsis">
							<c:set var="count" value="${count+1 }" />
							<!-- 第一列 -->
							<c:if test="${!isGroupAdmin && !param.isGroupAdmin}">
								<c:if test="${!isGroup }">
									<c:choose>
										<c:when test="${(row[9]=='collaboration' || row[9]=='edoc')&&row[0]==null}">
											<fmt:message key='self.create.workflow' var="typeTitle"/>
										</c:when>
										<c:otherwise>
											<c:set var="typeTitle" value="${row[1]==null ? '&nbsp;' : row[1] }"/>
										</c:otherwise>
									</c:choose>
								</c:if>
								<v3x:column width="25%" align="left" type="String" label="common.operation.type" alt="${isGroup ? appType : typeTitle}">
									<c:if test="${isGroup }">
										${appType }
									</c:if>
									<c:if test="${!isGroup }">
										${typeTitle }
									</c:if>
								</v3x:column>
							</c:if>
							
							<!-- 第二列-->
							<v3x:column width="${width}" type="String" align="left" label="${isGroupAdmin && param.statWhat=='Account' ? 'org.account.label' : 'org.department.label'}" alt="${showMemberTitle }">
								<c:if test="${isGroup }">
									<c:choose>
										<c:when test="${param.statType=='Account'|| param.statType=='Department'}">
											<c:set var="showMemberTitle" value="${v3x:showOrgEntitiesOfIds(row[0],param.statType,pageContext)}"/>
											<c:set var="showMember" value="${v3x:getLimitLengthString(showMemberTitle,30,'...')}"/>
										</c:when>
										<c:when test="${param.statType=='Member'}">
											<c:set var="member" value="${v3x:getOrgEntity('Member',row[1]) }"/>
											<c:set var="showMemberTitle" value="${v3x:showOrgEntitiesOfIds(member.orgDepartmentId,'Department',pageContext)}"/>
											<c:set var="showMember" value="${v3x:getLimitLengthString(showMemberTitle,30,'...')}"/>
										</c:when>
										<c:otherwise>
											<c:set var="showMemberTitle" value=""/>
											<c:set var="showMember" value="&nbsp;"/>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if test="${!isGroup }">
									<c:set var="showMember" value="${row[2]==null ? '' : v3x:showOrgEntitiesOfIds(row[2],'Department',pageContext) }"/>
								</c:if>
								${showMember }
							</v3x:column>
							
							<!-- 第三列-->
							<c:if test="${param.statType=='Member' }">
							<v3x:column width="15%" type="String" align="left" label="org.member.label" alt="">
								<c:if test="${isGroup }">
									${row[1]==null?"&nbsp;" : v3x:showMemberName(row[1]) }
								</c:if>
								<c:if test="${!isGroup }">
									${row[3]==null?"&nbsp;" : v3x:showMemberName(row[3]) }
								</c:if>
							</v3x:column>
							</c:if>
							<!-- 第四列-->
							<v3x:column width="9%" align="left" label="stat.sent.count" alt="" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[2]!= null && row[2]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','2','${param.beginDate }','${param.endDate }','','','${param.statScope }')"
									</c:if>
									>
									${row[2]==null?0 : row[2] }
									</span>
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[4]!= null && row[4]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','2','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[4]==null?0 : row[4] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第五列-->
							<v3x:column width="9%" align="left" label="stat.done.count" alt="" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[3]!= null && row[3]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','4','${param.beginDate }','${param.endDate }','','','${param.statScope }')"
									</c:if>
									>
									${row[3]==null?0 : row[3] }
									</span>
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[5]!= null && row[5]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','4','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[5]==null?0 : row[5] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第六列-->
							<v3x:column width="9%" align="left" label="stat.pending.count" alt="" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[4]!= null && row[4]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','3','${param.beginDate }','${param.endDate }','','','${param.statScope }')"
									</c:if>
									>
									${row[4]==null?0 : row[4] }
									</span>	
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[6]!= null && row[6]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','3','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[6]==null?0 : row[6] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第七列-->
							<c:set value="${isGroup ? (row[5]==null?'&nbsp;' : row[5]) : (row[7]==null?'&nbps;' : row[7]) }" var="severTitle" />
							<v3x:column width="9%" align="left" label="stat.deadline.count" alt="${severTitle}" className="sort">
								<c:if test="${isGroup }">
									<span 
									<c:if test="${row[5]!= null && row[5]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department' || entityType=='Account'?row[0] : row[1] }','-1','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[5]==null?'&nbsp;' : row[5]}
									</span>
								</c:if>
								<c:if test="${!isGroup }">
									<span 
									<c:if test="${row[7]!= null && row[7]!= 0}">
										class="like-a" onclick="openList('${param.appType }','${entityType }','${entityType=='Department'?row[2] : row[3] }','-1','${param.beginDate }','${param.endDate }','${row[0] }','${row[9] }','${param.statScope }')"
									</c:if>
									>
										${row[7]==null?'&nbps;' : row[7] }
									</span>
								</c:if>
							</v3x:column>
							<!-- 第八列 -->
							<v3x:column width="10%" align="left" className="sort" label="stat.deadline.totalTime" alt="${row[6]}">
								${isGroup ? (empty row[6] ? '-' : row[6]) : (row[8])}
							</v3x:column>
						</v3x:table>
					</c:otherwise>
				</c:choose>					
				</div>
				</div>
				</form>
			</div>
        </div>
    	<div class="bottom_div_row3" id="lastLine" >
		<table id="bottom_sort" class="ellipsis" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tbody>
		<tr class="sort">
			<c:choose>
				<c:when test="${isGroupAdmin || param.isGroupAdmin}">
					<c:if test="${param.statType=='Member'}">
						<td class="sort" width=30% colspan="${param.statType=='Member'?'2':'1' }"><fmt:message key="stat.all"/>：</td>														
					</c:if>
					<c:if test="${param.statType!='Member'}">
						<td class="sort" width=25% colspan="${param.statType=='Member'?'2':'1' }"><fmt:message key="stat.all"/>：</td>											
					</c:if>
				</c:when>
				<c:otherwise>
					<td class="sort" width="24%" colspan="${param.statType=='Member'?'3':'2' }"><fmt:message key="stat.all"/>：</td>
					<td class="sort" width="15%">&nbsp;</td>	
					<c:if test="${param.statType=='Member'}">
						<td class="sort" width="14%">&nbsp;</td>	
					</c:if>
				</c:otherwise>
			</c:choose>
			
			<td class="sort" width="9%" align="left">${total[0]==null?"&nbsp;" : total[0] }</td>
			<td class="sort" width="9%" align="left">${total[1]==null?"&nbsp;" : total[1] }</td>
			<td class="sort" width="9%" align="left">${total[2]==null?"&nbsp;" : total[2] }</td>
			<td class="sort" width="9%" align="left">${total[3]==null?"&nbsp;" : total[3] }</td>
			<td class="sort" width="9%">&nbsp;</td>
			<td class="sort" width="9%">&nbsp;</td>
			<td class="sort" width="">&nbsp;</td>
		</tr>
		</tbody>
		</table>
	</div>
	</div> 
</div>
</body>
</html>