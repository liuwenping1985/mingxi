<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="dataContain">
	<div class="nodata hidden">
		<div class="have_a_rest_area"><span class="msg" style="color: #999999"></span></div>
	</div>
	<div class="dataBase marLeftRight hidden" >
		<div class="titleSpan">
			<span>${ctp:i18n("wfanalysis.department.dataBase.t1") }</span>
			<span class="titleSpan_title">
				<em class="ico16 help_16 help_16_red"></em>
				<em class="em_title em_title_bg"></em>
				<em class="em_title em_title_content">${ctp:i18n("wfanalysis.department.dataBase.hovor1") }</em>
			</span>
			<c:if test="${empty isThrough || isThrough eq false}">
				<ul class="name_node_filter">
					<li style="border-radius: 25px 0 0 25px;" onclick="departmentAnalysis.chooseNodeName();">
						<span class="ico16 search_16 search"></span>
						<c:set var="selectedData" value="${ctp:i18n('wfanalysis.process.selected.data') }" />
						<c:set var="departmentName" value="${ctp:i18n('wfanalysis.department.dataBase.departmentName') }" />
						<span class="text" title="${wfaParam.nameTextCondition}">${!empty wfaParam.nameTextCondition ? selectedData :departmentName }</span>
					</li>
					<li style="border-radius: 0 25px 25px 0;"  onclick="chooseNodePlocy();">
						<span class="ico16 search_16 search"></span>
						<c:set var="nodePolicyName" value="${ctp:i18n('wfanalysis.node.policy.name') }" />
						<span class="text" title="${selectedPName}">${!empty selectedPName ? selectedData : nodePolicyName }</span>
					</li>
				</ul>
			</c:if>
		</div>
		
		<%-- 图表 --%>
		<div id="chartDiv"></div>
		
		<div>
			<%-- 左边提示 --%>
			<div class="left">
				<div class="titleSpan">
					<span>${ctp:i18n("wfanalysis.department.dataBase.t2") }</span>
					<span class="titleSpan_title">
						<em class="ico16 help_16 help_16_red"></em>
						<em class="em_title em_title_bg"></em>
						<em class="em_title em_title_content">${ctp:i18n("wfanalysis.department.dataBase.hovor2") }</em>
					</span>
				</div>
			</div>
			
			<%-- Excel导出 --%>
			<div class="right" style="position:relative;top:10px">
				<form id="excelCon" class="hidden">
				</form>
				<span class="hand" onclick="departmentAnalysis.toExcel()" title="${ctp:i18n("wfanalysis.common.exportexcel") }">
					<span class="ico16 xls_16" style="margin-top:-3px;"></span>${ctp:i18n("wfanalysis.common.exportexcel")}
				</span>
			</div>
		</div>
		<%--页面隐藏属性：用于查询或页面跳转使用 --%>
		<input type="hidden" id="includeChildDepartment" value="${includeChildDepartment}" >
		<input type="hidden" id="nodeOrgType" value="${nodeOrgType}" >
		<input type="hidden" id="orderKey" name="orderKey" value="${orderKey}" > 
		<input type="hidden" id="orderBy" name="orderBy" value="${orderBy}" >
		<%-- 表格 --%>
		<div style="clear: both;"></div>
		<div id="tableData"></div>
		
	</div>
</div>
<%@ include file="/WEB-INF/jsp/apps/wfanalysis/common/nodePolicy.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/wfanalysis/common/wfanalysisTpl.jsp"%>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-echarts-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/echarts-all.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/wfa-common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-department-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-table-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(function(){
		/*无数据时不再执行后续逻辑*/
		if ($(".dataBase").is(":hidden")) {
			return;
		}
		/* 初始化 */
		departmentAnalysis.init('${empty param.chart ? "" : param.chart }');
	});
</script>