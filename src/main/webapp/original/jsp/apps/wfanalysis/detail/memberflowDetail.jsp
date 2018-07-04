<%@ page language="java" contentType="text/html; charset=UTF-8"%>																												<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfd-member-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		$(function(){
			var queryoptions = null;
			<c:choose>  
				<c:when test="${nodeOrgType eq 'user'}">
			   		queryoptions = ${conditions};
				</c:when>  
			   	<c:otherwise>
			   		queryoptions = window.parentDialogObj["workflowDetail"].getTransParams();
			   	</c:otherwise>  
			</c:choose> 
			queryoptions.detailType = "memberflowDetail";
			var mf = new MfDetail(queryoptions);
		});
	</script>
</head>
<body>
	<div class="content">
		<div class="title_area"></div>
	
		<div class="tool_box  display_none nf_chart_tool_box">
			<span class="help_area">${ctp:i18n("wfanalysis.workflowDetail.wf.liuchengslfb") }</span>
			<span class="h_ico">
				<span class="ico16 help_16 help_16_red"></span>
				<span class="h_bg"></span>
				<span class="h_txt"></span>
			</span>
		</div>
		
		<div class="p_chart_area">
			<div id="mf_chart_div"></div>
		</div>
		
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
		<div id="nf_list"></div>
	</div>
	<form action="" id="download_form" style="display: none;">
		<input name="processEffType"/>
		<input name="rptYear"/>
		<input name="rptMonth"/>
		<input name="templateIds"/>
		<input name="memberId"/>
		<input name="detailType" value="memberflowDetail"/>
		<input name="sortName"/>
		<input name="sortType"/>
		<input name="title"/>
		<input name="activityIds"/>
		<input name="permissionOption"/>
		<input name="searchRange">
	</form>
</body>
</html>
