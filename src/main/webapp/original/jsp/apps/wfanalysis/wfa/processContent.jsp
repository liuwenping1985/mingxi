<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="dataContain">
	<%-- 没有数据显示 --%>
	<div class="nodata hidden">
		<div class="have_a_rest_area"><span class="msg" style="color: #999999"></span></div>
	</div>
	
	<div class="dataBase marLeftRight hidden">
		
		<div class="titleSpan">
			<span>${ctp:i18n("wfanalysis.process.content.tspan") }</span>
			<span class="titleSpan_title">
				<em class="ico16 help_16 help_16_red"></em>
				<em class="em_title em_title_bg"></em>
				<em class="em_title em_title_content">
					${ctp:i18n("wfanalysis.process.content.help") }
				</em>
			</span>
		</div>
		
		<%-- 图显示区域 --%>
		<div id="chartDiv"></div>
		
		<%-- 列表显示区域   --%>
		<div>
			<%-- label  and  tips   --%>
			<div class="left">
				<div class="titleSpan">
					<span>${ctp:i18n("wfanalysis.process.content.detail") }</span>
					<span class="titleSpan_title">
						<em class="ico16 help_16 help_16_red"></em>
						<em class="em_title em_title_bg"></em>
						<em class="em_title em_title_content">
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t1") }</span>${ctp:i18n("wfanalysis.process.content.d1") }
							<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t2") }</span>${ctp:i18n("wfanalysis.process.content.d2") }
							<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t3") }</span>${ctp:i18n("wfanalysis.process.content.d3") }<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t4") }</span>${ctp:i18n("wfanalysis.process.content.d4") }<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t5") }</span>${ctp:i18n("wfanalysis.process.content.d5") }<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t6") }</span>${ctp:i18n("wfanalysis.process.content.d6") }<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t7") }</span>${ctp:i18n("wfanalysis.process.content.d7") }<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t8") }</span>${ctp:i18n("wfanalysis.process.content.d8") }<br/>
							<span class="tips_blue">${ctp:i18n("wfanalysis.process.content.t9") }</span>${ctp:i18n("wfanalysis.process.content.d9") }
						</em>
					</span>
				</div>
			</div>
			
			<%-- 导出excel   --%>
			<div class="right" style="position: relative; top: 10px">
				<form action="" id="excelCon" class="hidden">
				</form>
				<span class="hand" onclick="Wfefficiency.exportExcel()" title="${ctp:i18n("wfanalysis.common.exportexcel") }">
					<span class="ico16 xls_16" style="margin-top:-3px;"></span>${ctp:i18n("wfanalysis.common.exportexcel")}
				</span>
			</div>
			
		</div>
		
		<input id="orderKey" name="orderKey" type="hidden"> 
		<input id="orderBy" name="orderBy" type="hidden">
		<%-- 表格	 --%>
		<div style="clear: both;"></div>
		<div id="tableData"></div>
		<%-- 没有数据    AND  使用最多的 --%>
		<p class="display_none color_2b2b2b  w100b noDataTemplate"  id="template-info">
			<span >
			<c:if test = "${wfaParam.searchRange eq 'account'}">
				${ctp:i18n("wfanalysis.common.condition.account") }
			</c:if>
			<c:if test = "${wfaParam.searchRange eq 'group'}">
				${ctp:i18n("wfanalysis.common.condition.group") }
			</c:if>
			${ctp:i18n("wfanalysis.process.content.t10") }<span class="case-count"></span>${ctp:i18n("wfanalysis.common.times") }</span><br/>
			<span class="no-data-template"></span>
		</p>
	</div>
</div>
<%@include file="/WEB-INF/jsp/apps/wfanalysis/common/wfanalysisTpl.jsp" %>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/echarts-all.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-table-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-echarts-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/wfa-common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/wfa-process-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function(){
	/*无数据时不再执行后续逻辑*/
	if ($(".dataBase").is(":hidden")) {
		return;
	}
	/* 页面初始化  */
	Wfefficiency.init('${empty param.chart ? "" : param.chart }');
});
</script>