<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<div class="clearfix">
	<span class='left margin_l_5'>
		<ul class="projectTask_dimensionTab">
			<li id="gridLi" title="${ctp:i18n('report.queryReport.index_right.statResult.grid')}" class="current" onclick="showReportGrid()"><em id="gridEm" class="ico16 switchView_table_current_16"></em></li>
			<li id="chartLi" title="${ctp:i18n('report.queryReport.index_right.statResult.chart')}" onclick="showReportChart()"><em id="chartEm" class="ico16 switchView_chart_16"></em></li>
		</ul>
	</span> 
	<span id="reportTitle" style="font-family: 'Microsoft YaHei', SimSun, Arial, Helvetica, sans-serif; font-size: 14px; width: 80%; text-align: center; color: #414141" class="margin_t_10 left"> </span> 
	<span class="right margin_t_10 margin_r_20"> 
		<span title="${ctp:i18n('report.queryReport.index_right.toolbar.synergy')}" class="ico24 project_forward_24 margin_r_10" onclick="forwardReport()"></span> 
		<span title="${ctp:i18n('report.toolbar.export')}" class="ico24 project_card_24 margin_r_10" onclick="exportReport()"></span>
		<span title="${ctp:i18n('report.queryReport.index_right.toolbar.print')}" class="ico24 project_print_24 margin_r_10" onclick="printReport()"></span>
	</span>
</div>
<form id="exportExcel" method="post" target="_blank"></form>
<form id="forwardToCol" method="post" action="${path}/project/project.do?method=forwardToCol4Report" target="main">
	<input name="title" type="hidden" /> 
	<input name="content" type="hidden" />
</form>