<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>超时分析</title>
<script type="text/javascript">
<!--
$(function(){
	//获取回填数据
	var params= "${params}";
	//解析数据
	if(params!=null&&params!=''){
		var array=params.split(",");
		var arr=new Array();
		var tableChart="${tableChart}";
		var url="${path}/performanceReport/WorkFlowAnalysisController.do?method=timeoutAnalysiszListPage";
		for(var i=0;i<array.length;i++){
			var p_array=array[i].split("=");
			arr[i]=p_array;
			if(p_array[0]=='beginDate'&&$.isNull(p_array[1])){
				url+="&beginDate="+getFirstDayOfMonth('${productUpgrageDate}',false);
			}else if(p_array[0]=='endDate'&&$.isNull(p_array[1])){
			   url+="&endDate="+getNowDay();
			}else{
			url+="&"+array[i];
			}
		}
		url+="&tableChart="+tableChart;
		$("#dataIFrame").attr("src",url);
		
		for(var i=0;i<arr.length;i++){
			if(arr[i][0]=='templeteName'){
				$("#templeteName").val(arr[i][1]);
			}else if(arr[i][0]=='beginDate' && arr[i][1]!=""){
				$("#beginDate").val(arr[i][1]);
			}else if(arr[i][0]=='endDate' && arr[i][1]!=""){
				$("#endDate").val(arr[i][1]);
			}else if(arr[i][0]=='templeteId'){
				$("#templeteId").val(arr[i][1]);
			}else if(arr[i][0]=='flowstate'){
				var flowstate=$("input[name='flowstate']");
				//将所有的checkbox设置为未选中
				$.each(flowstate,function(i,n){
					$(n).attr("checked",false);
				});
				var fv=arr[i][1].split("|");
				for(var j=0;j<fv.length;j++){
					$("input[name='flowstate'][value="+fv[j]+"]").attr("checked",true);
				}
			}else{
				$("input[name='flowstate'][value="+arr[i][0]+"]").attr("checked",true);
			}
			
		}
	}else{
		$("#dataIFrame").attr("src","${path }/performanceReport/WorkFlowAnalysisController.do?method=timeoutAnalysiszListPage&tableChart=${tableChart}&params="+encodeURI("${params}"));
	}
	breadcrumb();
})
function reset2() {
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("templeteName").value="";
	document.getElementById("templeteId").value="";
}

function submitData() {
	var templeteId = getDocValue("templeteId");
	var beginDate = getDocValue("beginDate");
	var endDate = getDocValue("endDate");
	var flowstateFlag = false ;
	
	var flowstates = document.getElementsByName("flowstate");
	for (var i = 0 ; i < flowstates.length ; i ++) {
		if (flowstates[i].checked)
			flowstateFlag = true ;
	}
	
	if (templeteId == "") {
		alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
		return ;
	}
	if (beginDate == "") {
		alert(v3x.getMessage("V3XLang.common_start_date_not_null_label"));
		return ;
	}
	if (endDate == "") {
		alert(v3x.getMessage("V3XLang.common_end_date_not_null_label"));
		return ;
	}
	if (!flowstateFlag) {
		alert(v3x.getMessage("V3XLang.common_select_process_state_label"));
		return ;
	}
	
	// 日期跨年判断
	if (judgeOneYearDate(beginDate,endDate))
		return ;
	$('#querySave').attr('disabled',true);
	document.getElementById("workflowForm").submit();
	
}
function templateChooseCallback(id,name){
	$("#templeteName").css("display","block").val(name);
	$("#templeteId").val(id);
}
function selectTemplate(){
    templateChoose(templateChooseCallback,'',false,'','MemberAnalysis','','${reportId}');
}
//穿透页面转协同
function closeAndForwardToCol(subject, content){
	$("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
    $('#reportContent').val(content);
    $('#reportTitle').val(subject.replace(/(^\s*)|(\s*$)/g, ""));
    $("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
    $("#queryConditionForm").submit();
}
//-->
</script>
</head>
<body scroll="no" class="padding5 page_color">
	 <div style="height: 19px; display: block;" id="queryMainCrumbs" class="bg_color border_b hidden">
       <span style="display: inline;" id="nowLocation" class="common_crumbs "><span class="margin_r_10">${ctp:i18n('seeyon.top.nowLocation.label')}</span>
       <a href="${path}/portal/spaceController.do?method=showThemSpace&amp;themType=23">${ctp:i18n('system.menuname.CollaborationMonitor')}</a>
       <span class="common_crumbs_next margin_lr_5">-</span>
       <a href="javascript:location.reload()">${ctp:i18n('system.menuname.PerformanceQuery')}</a>
       </span>
      </div>
    <form action="#" id="queryConditionForm"  method="post" target="main">
	</form>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border border_r">
	<tr height="80">
		<td style="">	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
							<tr>
							<td class="sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" action="${path }/performanceReport/WorkFlowAnalysisController.do?method=timeoutAnalysiszListPage" target="dataIFrame">
									<table width="100%" height="100%" border="0" class="noWrap">
										<tr height="30px">
											<td width="12%" align="right"><fmt:message key="common.template.process.label"/> : </td>
											<td width="15%">
												<input type="text" id="templeteName" name="templeteName" value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" onclick="selectTemplate()" readonly="readonly" style="width: 200px; height:18px">
												<input type="hidden" id="templeteId" name="templeteId" value="" style="width: 200px;">
									            <input type="hidden" name="tableChart" id="tableChart" />
											</td>
											<td width="12%" align="right"><fmt:message key="common.process.state.label" /> : </td>
											<td width="35%" align="left">
												<label for="flowstate0">
													<input type="checkbox" name="flowstate" id="flowstate0" checked="checked" value="${finish}" />
													<fmt:message key="common.has.ended.label" />
												</label>
												&nbsp;&nbsp;
												<label for="flowstate1">
													<input type="checkbox" name="flowstate" id="flowstate1" checked="checked" value="${run}" />
													<fmt:message key="common.no.end.label" />
												</label>
												&nbsp;&nbsp;
												<label for="flowstate3">
													<input type="checkbox" name="flowstate" id="flowstate3" checked="checked" value="${terminate}" />
													<fmt:message key="common.termination.label" />
												</label>
							        		</td>
										</tr>
									
										<tr height="28px">
											<td width="12%" align="right"><fmt:message key="common.start.date.label" /> : </td>
											<td width="15%" nowrap>
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												<input type="text" name="beginDate" id="beginDate" class="input-date" style="width:95px"
												 value='<fmt:formatDate value="${beginDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
												-
												<input type="text" name="endDate" id="endDate" class="input-date" style="width:95px" 
												value='<fmt:formatDate value="${endDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
											</td>
										</tr>
									</table>
									<div class='align_center clear padding_t_5' nowrap="nowrap" colspan="0" width="100%">
										<input type="button" id="querySave" onclick="submitData()" value='<fmt:message key="common.toolbar.statistics.label" />' class="button-default-2">
										<input type="button" onclick="reset2()" value='<fmt:message key="common.button.reset.label" bundle="${v3xCommonI18N}" />' class="button-default-2">
									</div>
								</form>
							</td>
						</tr>
					</table>
					<div class="portal-layout-cell_footer">
						<div class="portal-layout-cell_footer_l"></div>
						<div class="portal-layout-cell_footer_r"></div>
					</div>
				</div>  
			
		</td>
	</tr>
	<tr id="workflowDetail" >
	    <td colspan="5">
		<div style="width:100%;height:100%" id="content">
	        <iframe src="" name="dataIFrame" id="dataIFrame"
	                frameborder="0" marginheight="0" marginwidth="0" height="99%" width="100%" scrolling="no">
	        </iframe>
	    </div>    
	    </td>
	</tr>
</table>
<script type="text/javascript">
<!--
var presentTime = "${presentTime}";
document.getElementById("beginDate").value = getFirstDayOfMonth('${productUpgrageDate}',false);
document.getElementById("endDate").value = getNowDay();
initIe10AutoScroll("content",100);
//-->
</script>
</body>
</html>