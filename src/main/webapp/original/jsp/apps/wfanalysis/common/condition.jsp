<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<div class="header headerHR  marLeftRight">
	<div class="search_div right ">
		<form id="conditionForm" action="${path}/wfanalysis.do?method=${wfaParam.view}" method="post">
			<div class="left">
				<span class="search_span left">${ctp:i18n("wfanalysis.common.condition.template") }<!-- 模板 --></span> 
				<div class="search_click left">
					<span class="span_txt left" id="templateShow" onclick="selectTemplate();" style="white-space: nowrap; text-overflow: ellipsis; overflow: hidden;" title="${ctp:toHTML(wfaParam.templateNames)}"> ${empty wfaParam.templateNames ? "&ensp;" : ctp:toHTML(wfaParam.templateNames)}</span>
					<span class="ico16 form_temp_16" onclick="selectTemplate()"></span>
				</div>
				<input id="templateNames" type="hidden" value="${ctp:toHTML(wfaParam.templateNames)}">
				<input id="templateIds" type="hidden" value="${wfaParam.templateIds}">
			</div>
			<div class="left view_flow_div">
				<a href="javascript:void(0)" onclick="showWorkflowDiv();" class="view_flow">${ctp:i18n("wfanalysis.common.condition.viewflow")}<!-- 查看流程图 --></a>
			</div>
			<c:if test = "${isA8Group eq 'true' }">
				<div class="left padding_l_20">
					<label>${ctp:i18n("wfanalysis.common.condition.statsrange")}<!-- 统计范围 --></label>
					<input type="radio" name="searchRange" onchange="changeRange(this)" value="group"/>
						${ctp:i18n("wfanalysis.common.condition.group")}<!-- 全集团 -->
					<input type="radio" name="searchRange" onchange="changeRange(this)" value="account"/>
						${ctp:i18n("wfanalysis.common.condition.account")}<!-- 本单位 -->
					<em id="select_help" class="ico16 help_16 help_16_red"></em>
					<em class="em_title em_title_bg" style="height: 40px; display: none;"></em>
					<em class="em_title em_title_content" style="display: none;">
						${ctp:i18n("wfanalysis.common.condition.tips")}
						<%--- 
						流程绩效的统计范围:</br>
	                    1.当选择的流程模板,均为本单位创建的模板时：</br>
						&nbsp;&nbsp;&nbsp;支持查看全集团范围内,已选择模板的总体使用情况及各单位的使用情况。</br>
						&nbsp;&nbsp;&nbsp;支持查看本单位范围内,已选择模板的使用情况。</br>
						2.当选择的流程模板中,含有外单位授权的模板时:</br>
						&nbsp;&nbsp;&nbsp;仅支持查看本单位范围内，已选择模板的使用情况。</br>
						--%>
					</em>
				</div>
			</c:if>
			<input type="hidden" id="templateRange" name="templateRange" value="${wfaParam.searchRange}"/>
			<div class="left margin_l_15">
				<span class="search_span left">${ctp:i18n("wfanalysis.common.condition.time") }<!-- 时间 --></span> 
				<div class="search_click left">
					<span class="span_txt left" id="selectDate">${wfaParam.rptTimeDisplay}</span>
					<span class="ico_selectDate calendar_icon" ></span>
				</div>
				<input id="rptYear" type="hidden" value="${wfaParam.rptYear}">
				<input id="rptMonth" type="hidden" value="${wfaParam.rptMonth}">
			</div>
			
			<input id="viewPage" name="viewPage" type="hidden" value="${wfaParam.view}">
			<input type="hidden" id="permissionOption" name="permissionOption" value="${ctp:toHTMLWithoutSpaceEscapeQuote(wfaParam.permissionOption)}"/><!-- 节点权限 -->
			<input type="hidden" id="activityIdOption" name="activityIdOption"/>
			<input type="hidden" id="nameCondition" name="nameCondition" value="${wfaParam.nameCondition}"/>
			<input type="hidden" id="nameTextCondition" name="nameTextCondition" value="${wfaParam.nameTextCondition}"/>
		</form>
	</div>
</div>

<div id="workflowDiv" class="button_showDiv hide" style="width:390px;">
	<div class="overflow showDiv_nav">
		<div class="left"><span>${ctp:i18n("wfanalysis.common.condition.selected.template") }<!-- 已选模板 --></span></div>
		<div class="right" style="cursor: pointer;" onclick="hideWorkflowDiv();"><em class="em_hide"></em></div>
	</div>
	<div class="showDiv_body workflow-list-data">
		<dl>
			<dd>
				<span class="col_01">${ctp:i18n("wfanalysis.common.condition.no") }<!-- 序号 --></span>
				<span class="col_02">${ctp:i18n("wfanalysis.common.condition.templatename") }<!-- 模板名称 --></span>
				<span class="col_03">${ctp:i18n("wfanalysis.common.condition.flowmap") }<!-- 流程图 --></span>
			</dd>
			<c:forEach var="temp" varStatus="status" items="${wfaParam.templateList}">
			<dt>
				<span class="col_01">${status.index+1}</span>
				<span class="col_02"  title="${ctp:toHTML(temp.subject) }<c:if test="${temp.orgAccountId != CurrentUser.loginAccount}" >(${v3x:getAccount(temp.orgAccountId).shortName })</c:if>">${ctp:toHTML(temp.subject) }<c:if test="${temp.orgAccountId != CurrentUser.loginAccount}" >(${v3x:getAccount(temp.orgAccountId).shortName })</c:if></span>
				<span class="col_03" style="cursor: pointer;" onclick="workflowChart('','${temp.workflowId}');"><span class="ico16 flow_view_16"></span></span>
			</dt>
			</c:forEach>
		</dl>
	</div>
</div>
<script type="text/javascript">
var isA8Group = "${isA8Group}";
$(function(){
	if(isA8Group == "true"){
		//初始化默认选中
		$("input[name='searchRange'][value='${wfaParam.searchRange}']").attr("checked",true);
		var wfa = new wfanalysisAjaxManager();
		wfa.checkOtherAccountTemplate($("#templateIds").val(),{success:
			function(retObj){ 
				if(retObj){
					//包含外单位模板
					$("input[name='searchRange'][value='group']").attr("disabled",true);
				}
			}
		});
	}
	$(".ico_selectDate").off("click").on("click",function(){
			$("#selectDate").click();
	});
	htDate = $("#selectDate").htDate({
		callback:function(selectValue){
			var year = selectValue.year;
			var type = selectValue.type;
			var typevalue = selectValue.typevalue;
			var month = typevalue;
			if(type === "year"){
				if(typevalue === "0"){
					month = 13;
				}else if(typevalue === "1"){
					month = 14;
				}else{
					month = 15;
				}
			}else if(type === "quarter"){
				if(typevalue === "1"){
					month = 16;
				}else if(typevalue === "2"){
					month = 17;
				}else if(typevalue === "3"){
					month = 18;
				}else{
					month = 19;
				}
			}
			$("#selectDate").text(getDateDisplay(year, month));
			var rptAjaxWfAnalysis = new wfanalysisAjaxManager();
			if(rptAjaxWfAnalysis.checkHasWfaReport(year, month)){
				$("#rptYear").val(year);
				$("#rptMonth").val(month);
				query(); //日期选择确定则立即执行查询
			}else{
				oldValue = getDefaultDateValue($("#rptYear").val(), $("#rptMonth").val());
				htDate.setSelectValue(oldValue.year, oldValue.type, oldValue.typevalue);
				var close = function () {
					win.close();
                	$("#selectDate").text(getDateDisplay($("#rptYear").val(), $("#rptMonth").val()));
				}
				var win = new MxtMsgBox({
					'type': 0,
	                'imgType':2,
	                'msg': $("#selectDate").text()+"${ctp:i18n("wfanalysis.common.condition.nostats") }",//"，没有流程绩效报告。",
	                close_fn: close,
	                ok_fn: close
            	});
			}
		},
		defaultValue: getDefaultDateValue($("#rptYear").val(),$("#rptMonth").val())
	});
	 $(window).resize(function(){
		 resizeWindow();
	 });
	 resizeWindow();
});
</script>
