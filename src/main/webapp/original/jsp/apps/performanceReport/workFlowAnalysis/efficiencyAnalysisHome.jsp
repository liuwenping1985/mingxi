<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
$(function(){
	var params="${params}";
	if(params!=null||params!=''){
		var array=params.split(",");
		var arr=new Array();
		var tableChart="${tableChart}";
		var url="${path}/performanceReport/WorkFlowAnalysisController.do?method=efficiencyAnalysiszListPage";
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
		reOnload_section(arr);
		$("#dataIFrame").attr("src",url);
	}
	breadcrumb();
})

	function reOnload_section(arr){
    	//回填数据操作,循环select元素
    	var section_select=$("#tab_eff select");
    	for(var j=0;j<arr.length;j++){
    		$.each(section_select,function(i,n){
    			var item=$(n);
    			if(item.attr("id")==arr[j][0]){
    				item.val(arr[j][1]);
    			}
    		})
    	}
    	
  		var section_input=$("#tab_eff input");
  		var templeteName='';
    	//回填数据操作,循环input元素
    	for(var j=0;j<arr.length;j++){
    		$.each(section_input,function(i,n){
        		var item=$(n);
        		if(item.attr("type")=="radio"){
        			if(item.attr("id")==arr[j][0]){
        				item.attr("checked","checked");
        			}
        		}else{
        			if(item.attr("id")==arr[j][0]){
        				if(arr[j][0]=='templeteName'){
        					templeteName=arr[j][1];
        				}else if(arr[j][0]=='beginDate'){
        					if(arr[j][1]!=""){
        						$("#beginDate").val(arr[j][1]);
        					}
            			}else if(arr[j][0]=='endDate'){
            				if(arr[j][1]!=""){
            				    $("#endDate").val(arr[j][1]);
            				}
            			}else{
	        				item.val(arr[j][1]);
        				}
        			}
        		}
        	})
		}
	    $("#templeteName").css("display","block").val(templeteName);
  	}
function reset2() {
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("templeteId").value="";
	document.getElementById("templeteName").value="";
}

function submitData() {
	var templeteId = getDocValue("templeteId");
	var beginDate = getDocValue("beginDate");
	var endDate = getDocValue("endDate");
	
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
<body scroll="no" class="padding5 page_color" style="height:100%">
	 <div style="height: 19px; display: block;" id="queryMainCrumbs" class="bg_color border_b hidden">
       <span style="display: inline;" id="nowLocation" class="common_crumbs "><span class="margin_r_10">${ctp:i18n('seeyon.top.nowLocation.label')}</span>
       <a href="${path}/portal/spaceController.do?method=showThemSpace&amp;themType=23">${ctp:i18n('system.menuname.CollaborationMonitor')}</a>
       <span class="common_crumbs_next margin_lr_5">-</span>
       <a href="javascript:location.reload()">${ctp:i18n('system.menuname.PerformanceQuery')}</a>
       </span>
      </div>
    <form action="#" id="queryConditionForm"  method="post" target="main">
	</form>
<table id="tab_eff" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border border_r">
	<tr height="70">
		<td >	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
							<tr>
							<td class=" sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" action="${path }/performanceReport/WorkFlowAnalysisController.do?method=efficiencyAnalysiszListPage" target="dataIFrame" >
									<!--协同V5.0 OA-40527 现在统一不统计终止状态的数据，只统计正常结束的数据-->
									<!--<input type="hidden" name="flowstate" id="flowstate3"  value="${terminate}" />-->
									<input type="hidden" name="flowstate" id="flowstate0"  value="${finish}" />
									<input type="hidden" name="tableChart" id="tableChart" />
									<table width="100%" height="100%" border="0" class="noWrap">
										<tr>
											<td width="8%" align="right"><fmt:message key="common.template.process.label"/> : </td>
											<td width="15%">
												<input type="text" id="templeteName" name="templeteName" value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" onclick="selectTemplate();" readonly="readonly" style="width: 90%;">
												<input type="hidden" id="templeteId" name="templeteId" value="" />
											</td>
											<td width="8%" align="right">
												<fmt:message key="common.start.date.label" /> : 
											</td>
											<td width="30%" align="left" nowrap>
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												<input type="text" name="beginDate" id="beginDate" class="input-date" style="width:47%"
												 value='<fmt:formatDate value="${beginDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
												-
												<input type="text" name="endDate" id="endDate" class="input-date" style="width:47%" 
												value='<fmt:formatDate value="${endDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
											</td>
										</tr>
									</table>
									<div class='align_center clear padding_t_5' nowrap="nowrap" colspan="0" width="100%">
										<input type="button" id="querySave" onclick="submitData()" value='<fmt:message key="common.toolbar.statistics.label"/>' class="button-default-2">
										&nbsp;
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
	    <td colspan="5" valign="top">
	    <div style="width:100%;height:100%" id="content">
		
	        <iframe src="${path}/performanceReport/WorkFlowAnalysisController.do?method=efficiencyAnalysiszListPage" name="dataIFrame" id="dataIFrame"
	                frameborder="0" marginheight="0" marginwidth="0" height="99%" width="100%" scrolling="no">
	        </iframe>
	    </div>    
	    </td>
	</tr>
</table>
<script type="text/javascript">
var presentTime = "${presentTime}";
<!--
document.getElementById("beginDate").value = getFirstDayOfMonth('${productUpgrageDate}',false);
document.getElementById("endDate").value = getNowDay();
initIe10AutoScroll("content",100);
//-->
</script>
</body>
</html>