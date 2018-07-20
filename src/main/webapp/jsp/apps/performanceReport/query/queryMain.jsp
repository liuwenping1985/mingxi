<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryMain_js.jsp"%>
 <!DOCTYPE html>
<html class="h100b over_hidden">            
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <title>Insert title here</title>
	      <style>
			.stadic_head_height{
			    height:30px;
			}
			.stadic_body_top_bottom{
			 bottom: 0px;
			    top: 30px;
			}
		</style>
	</head>
	<body class="page_color">
      	<div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_queryindex'"></div>
     <div style="height: 19px; display: none;" id="queryGroupCrumbs" class="bg_color border_b">
     	<div class="comp" comp="type:'breadcrumb',code:'F13_groupWorkflow'"></div>
     </div>
     <div style="height: 19px; display: none;" id="queryUnitCrumbs" class="bg_color border_b">
     	<div class="comp" comp="type:'breadcrumb',code:'F13_unitWorkflow'"></div>
     </div>
	<div id='layout' class="comp bg_color" comp="type:'layout'">
		<c:if test="${isSection == false or empty isSection}">
		<div id='layoutNorth' class="layout_north" style="margin-top:2px;" layout="height:140,minHeight:100,maxHeight:200,spiretBar:{show:true,type:2,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(140);}},border:false">
		</c:if>
		<c:if test="${isSection == true}">
		<div id='layoutNorth' class="layout_north" layout="height:0,minHeight:0,maxHeight:0,spiretBar:false,border:false">
		</c:if>
			<div id="tabs" class="">
				<div id="tabs_head" class="common_tabs clearfix" name='personGroup'>
				    <ul class="left">
				        <li class="current"><a hidefocus="true" href="javascript:void(0)" id="myReport">
				        	<span>${ctp:i18n('performanceReport.queryMain.tabs.personReport')}</span></a>
						</li>
						<li><a hidefocus="true" href="javascript:void(0)" id="groupReport">
							<span>${ctp:i18n('performanceReport.queryMain.tabs.groupReport')}</span></a><!-- class="last_tab" -->
				        </li>
				    </ul>
				</div>
				<div class="border_t" id="qt">
				<form action="#" id="queryConditionForm"  style="margin:0;padding:0; height:105px" method="post" target="main">
					<div class="form_area padding_t_10 padding_b_10"  id="queryCondition">
					</div>
					<input type="hidden" id="reportId" class="hidden" value="${reportId}"/>  
					<input type="hidden" id="personGroupTab" />
		         	<input type="hidden" id="tableChartTab" />
		         	<input type="hidden" id="hiddenAllTab"/>
		         	<input type="hidden" id="hiddenChartGridTab"/>
	         	</form>
	         	<form action="#" id="resolveExecel">
	         		<div id="execelCondition"></div>
	         	</form>
	         	</div>
         	</div>
         	
        </div>
        <c:choose>
        	<c:when test="${isSection == true}">
        		<div class="layout_center stadic_layout" layout="border:false" >
        	</c:when>
        	<c:otherwise>
        		<div class="layout_center stadic_layout margin_l_5" layout="border:true" style='overflow-y:hidden'>
        	</c:otherwise>
        </c:choose>
		
		    <div class=" padding_lr_10  set_search align_left" id="oper">
		        <table>
		            <tr>
		                <td>
		                	<span class="left">${ctp:i18n('performanceReport.queryMain.result')}：
							<a class="img-button margin_r_5" href="javascript:void(0)" id="showDigarm" style="display:none;" onclick="showDigarm()"><em class="ico16 "></em>${ctp:i18n('performanceReport.queryMain.checkProcess')}</a> 
							<a class="img-button margin_r_5" href="javascript:void(0)" id="reportForwardCol"><em class="ico16 forwarding_16"></em>${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}</a> 
							<a class="img-button margin_r_5" href="javascript:void(0)" id="reportToExcel"><em class="ico16 export_excel_16"></em>${ctp:i18n('performanceReport.queryMain.tools.reportToExcel')}</a> 
							<a class="img-button margin_r_5" href="javascript:void(0)" id="printReport"><em class="ico16 print_16"></em>${ctp:i18n('performanceReport.queryMain.tools.printReport')}</a> 
							<a class="img-button margin_r_5" href="javascript:void(0)" id="showHelp" onclick="showHelpDescription('${path}','${reportId}')" title="${ctp:i18n('performanceReport.queryMain_js.help.title')}"><em class="ico16 help_16"></em>${ctp:i18n('performanceReport.queryMain_js.help.title')}</a>
							</span>
						</td>
					</tr>
				</table>
			</div>
			<div class="stadic_layout_body stadic_body_top_bottom" id="reportResult">
				<div id="tabs" name="tabs" class="stadic_layout" style="*position:absolute;height:90%;width:100%">
					<div id="tabs_head" class="common_tabs clearfix stadic_layout_head stadic_head_height" style="25px;">
					    <ul class="" id="ul_tab">
					        <li class="current"><a hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe" id="tableResult">
								<span>${ctp:i18n('performanceReport.queryMain.result.tableResult')}</span></a>
							</li>
							<li><a hidefocus="true" href="javascript:void(0)" tgt="tab2_iframe" id="chartResult">
								<span>${ctp:i18n('performanceReport.queryMain.result.chartResult')}</span></a>
					    	</li>
						</ul>
						<ul class="align_center">
					    	<li id="reportName">${ctp:i18n('performanceReport.queryMain.reportName')}</li>
					    </ul>
					</div>
		 			          
					<ul id="queryResult" class="align_center border_tb common_tabs_body stadic_body_top_bottom stadic_layout_body" style="width:100%;top:25px;bottom:35px;overflow:auto; background:#fff;">
					</ul>
					<div id='resultComp' style='display:none' class=' align_right stadic_layout_footer stadic_footer_height'>
    			  		<table border='0'>
    			  			<tr style='height: 20px;' id='result'>
    			  			</tr>
    			  		</table>
    			  		<hr style='margin-bottom:15px;display:none' id="proHr">
    			  	</div>
		            <!-- 奇怪啊，分页组件居然会造成内存泄漏 -->
		            <c:if test="${isSection != true}">
					<div class="common_over_page align_right stadic_layout_footer stadic_footer_height" id="pageContent">
						${ctp:i18n('performanceReport.queryMain.page.eachPage')}<input class="common_over_page_txtbox" type="text" value="" id="pageSize">
						<span id="totleItem">${ctp:i18n_1('performanceReport.queryMain_js.unitTotal',0) }</span>
						<a title="${ctp:i18n('performanceReport.queryMain.page.firstPage')}" class="common_over_page_btn" href="#" id="firstPage"><em class="pageFirst"></em></a>
						<a title="${ctp:i18n('performanceReport.queryMain.page.up')}" class="common_over_page_btn" href="#" id="prevPage"><em class="pagePrev"></em></a>
						<span>${ctp:i18n('performanceReport.queryMain.page.the')}</span>
						<input class="common_over_page_txtbox" type="text" value="" id="pageNo"><span id="totlePage">${ctp:i18n_1('performanceReport.queryMain_js.pageTotal',1)}</span>
						<a title="${ctp:i18n('performanceReport.queryMain.page.down')}" class="common_over_page_btn" href="#" id="nextPage"><em class="pageNext"></em></a>
						<a title="${ctp:i18n('performanceReport.queryMain.page.lastPage')}" class="common_over_page_btn" href="#" id="lastPage"><em class="pageLast"></em></a>
						<a id="grid_go" class="common_button common_button_gray margin_r_10" href="javascript:void(0)">go</a>
					</div>
					</c:if>
				</div>
			</div>
		</div>
	</body>        
</html>