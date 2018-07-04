<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path }/apps_res/wfanalysis/css/wf-detail.css${ctp:resSuffix()}"/>
	<script type="text/javascript" src="${path }/common/js/echarts-all.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfd-table-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfd-echart-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfd-process-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		$(function(){
			//选项
			var options = window.parentDialogObj["workflowDetail"].getTransParams();
			//初始换对象
			var wf = new WfDetail(options);
		});
	</script>
</head>
<body>
	<div class="content">
		<div class="title_area"></div>
		
		<div class="tool_box  display_none chart_tool_box">
			<span class="help_area">
				${ctp:i18n("wfanalysis.workflowDetail.wf.liuchengslfb") }
			</span>
			<span class="h_ico">
				<span class="ico16 help_16 help_16_red"></span>
				<span class="h_bg"></span>
				<span class="h_txt"></span>
			</span>
		</div>
		<%-- 显示图 --%>
		<div class="p_chart_area">
			<div class="wf_chart_area display_none" id="wf_chart_area">${ctp:i18n("wfanalysis.workflowDetail.wf.cannotdisplayechart") }</div>
		</div>
		<!-- <div class="sep_line display_none chart_sep_line"></div> -->
		
		<div class="tool_box">
			<span class="help_area">${ctp:i18n("wfanalysis.workflowDetail.wf.liuchengslmx") }</span>
			
			<span class="h_ico h_content">
				<span class="ico16 help_16 help_16_red"></span>
				<span class="h_bg"></span>
				<span class="h_txt"></span>
			</span>
			
			<span class="tool_box_right">
				<span class="forward_col" title="${ctp:i18n("wfanalysis.common.forwardcoll") }">
					<span class="ico16 forwarding_16"></span>
					${ctp:i18n("wfanalysis.common.forwardcoll") }
				</span>&ensp;
				
				<span class="export_excel" title="${ctp:i18n("wfanalysis.common.exportexcel") }">
					<span class="ico16 xls_16"></span>
					${ctp:i18n("wfanalysis.common.exportexcel") }
				</span>&ensp;
				
				<span class="print_table" title="${ctp:i18n("wfanalysis.common.print") }">
					<span class="ico16 print_16"></span>
					${ctp:i18n("wfanalysis.common.print") }
				</span>
			</span>
		</div>
		<div class="box_tab">
			<span class="tool_box_tab"></span>
		</div>
		<%-- 显示列表 --%>
		<div id="workflowDetailList_p" class="workflowDetail_list"></div>
	</div>
	<form action="" id="download" style="display: none;">
		<input name="templateId"/>
		<input name="rptYear">
		<input name="rptMonth"/>
		<input name="processEffType"/>
		<input name="detailType" value="processflowDetail"/>
		<input name="sortName" value="startDate"/>
		<input name="sortType" value="asc"/>
		<input name="title" />
		<input name="searchRange">
	</form>
</body>
</html>
