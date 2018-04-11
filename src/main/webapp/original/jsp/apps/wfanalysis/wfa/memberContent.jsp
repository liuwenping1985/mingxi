<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="dataContain">
	<%-- 没有数据 --%>
	<div class="nodata hidden">
		<div class="have_a_rest_area"><span class="msg" style="color: #999999"></span></div>
	</div>
	<div class="dataBase marLeftRight hidden" >
		<div class="titleSpan">
		
			<%-- 左侧的名称 + 问号  --%>
			<span>${ctp:i18n("wfanalysis.member.dataBase.t1") }</span>
			<span class="titleSpan_title">
				<em class="ico16 help_16 help_16_red"></em>
				<em class="em_title em_title_bg"></em>
				<em class="em_title em_title_content">${ctp:i18n("wfanalysis.member.dataBase.hovor1") }</em>
			</span>
			
			<%-- 节点名称过滤 --%>
			<c:if test="${empty isThrough || isThrough eq false}">
				<ul class="name_node_filter">
					<li style="border-radius: 25px 0 0 25px;" onclick="memberAnalysis.chooseNodeName();">
						<span class="ico16 search_16 search"></span>
						<c:set var="selectedData" value="${ctp:i18n('wfanalysis.process.selected.data') }" />
						<c:set var="nodeMemberName" value="${ctp:i18n('wfanalysis.member.dataBase.nodeMemberName') }" />
						<span class="text" title="${wfaParam.nameTextCondition}">${!empty wfaParam.nameTextCondition ? selectedData :nodeMemberName }</span>
					</li>
					<li style="border-radius: 0 25px 25px 0;"  onclick="chooseNodePlocy();">
						<span class="ico16 search_16 search"></span>
						<c:set var="nodePolicyName" value="${ctp:i18n('wfanalysis.node.policy.name') }" />
						<span class="text" title="${selectedPName}">${!empty selectedPName ? selectedData : nodePolicyName }</span>
					</li>
				</ul>
			</c:if>
			
		</div>
		
		<%-- 图 --%>
		<div id="chartDiv"></div>
		
		<div>
			<%-- 左边提示 --%>			
			<div class="left">
				<div class="titleSpan">
					<span>${ctp:i18n("wfanalysis.member.dataBase.t2") }</span>
					<span class="titleSpan_title">
						<em class="ico16 help_16 help_16_red"></em>
						<em class="em_title em_title_bg"></em>
						<em class="em_title em_title_content">${ctp:i18n("wfanalysis.member.dataBase.hovor2") }</em>
					</span>
				</div>
			</div>
			<%-- 右边的导出excel --%>
			<div class="right" style="position:relative;top:10px">
				<span class="hand" onclick="memberAnalysis.toExcel()" title="${ctp:i18n("wfanalysis.common.exportexcel") }">
					<span class="ico16 xls_16" style="margin-top:-3px;"></span>${ctp:i18n("wfanalysis.common.exportexcel")}
				</span>
				<form action="" id="excelCon" class="hidden">
				</form>
			</div>
			<%--页面隐藏属性：用于查询或页面跳转使用 --%>
			<input type="hidden" id="orderKey" name="orderKey" value="${orderKey}" > 
			<input type="hidden" id="orderBy" name="orderBy" value="${orderBy}" >
			<input type="hidden" id="departmentId" name="departmentId" value="${departmentId}">
		</div>
		
		<%-- 底部表格 --%>
		<div style="clear: both;"></div>
		<div id="tableData"></div>
	</div>
</div>
<%@ include file="/WEB-INF/jsp/apps/wfanalysis/common/nodePolicy.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/wfanalysis/common/wfanalysisTpl.jsp"%>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/echarts-all.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-echarts-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/wfa-common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-table-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-member-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(function(){
		/*无数据时不再执行后续逻辑*/
		if ($(".dataBase").is(":hidden")) {
			return;
		}
		/*  页面初始化 */
		memberAnalysis.init('${empty param.chart ? "" : param.chart }');
	});
</script>
