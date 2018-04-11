<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/templete.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
//getA8Top().showLocation(1601);
// function selectTemplete() {
// 	var appType = document.getElementById("appType").value;
// 	var url = "templete.do?method=showTempleteFrame&isMultiSelect=true&isComprehensivePage=true&isWorkflowAnalysiszPage=true&appType="+appType+"&data=MemberAnalysis";
// 	v3x.openWindow({
// 		url		: url,
// 		width	: 600,
// 		height	: 417,
// 		resizable	: "false"
// 	});
// 	document.getElementById("specTempleteDiv").style.display="block";
// }
var beginDate4List='';// 开始时间，供comprehensiveAnaysisList.jsp使用，在本页面最后初始化
var endDate4List='';// 结束时间，供comprehensiveAnaysisList.jsp使用，在本页面最后初始化

$(function(){
	var params="${params}";
	var url="${path}/performanceReport/WorkFlowAnalysisController.do?method=comprehensiveAnalysiszListPage";
	if(params!=null||params!=''){
		var array=params.split(",");
		var arr=new Array();
		var tableChart="${tableChart}";
		for(var i=0;i<array.length;i++){
			var p_array=array[i].split("=");
			arr[i]=p_array;
			if(p_array[0]=='beginDate'&&$.isNull(p_array[1])){
				url+="&beginDate="+getLastYearMonth('${productUpgrageDate }');
			}else if(p_array[0]=='endDate'&&$.isNull(p_array[1])){
			   url+="&endDate="+getLastYearMonth('${productUpgrageDate }');
			}else{
			url+="&"+array[i];
			}
		}
		url+="&tableChart="+tableChart;
		reOnload_section(arr);
	}
	$("#dataIFrame").attr("src",url);
	$("#appType").change(changeAppType);
	breadcrumb();
})
	//应用类型改变时，指定模板应清空
	function changeAppType(){
		document.getElementById("templeteName").style.display = "none";
		document.getElementById("templeteName").value = "";
		templateOrginalData = null;
	}
	
	function reOnload_section(arr){
    	//回填数据操作,循环select元素
    	var section_select=$("#tab_compre select");
    	for(var j=0;j<arr.length;j++){
    		$.each(section_select,function(i,n){
    			var item=$(n);
    			if(item.attr("id")==arr[j][0]){
    				item.val(arr[j][1]);
    			}
    		})
    	}
    	
  		var section_input=$("#tab_compre input");
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
        				} else if(arr[j][0]=='beginDate'){
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
    	if($("#chooseTemplete").attr("checked")=='checked'){
    		$("#templeteName").css("display","block").val(templeteName);
    	}
  	}
  	
function resetData() {
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("templeteName").value="";
	document.getElementById("templeteId").value="";
	document.getElementById("allTemplete").checked=true;
	document.getElementById("specTempleteDiv").style.display="none";
	templateOrginalData = null; //该变量来自于chooseTemplate方法，用于缓存上一次选择的数据，reset方法需要清空上一次的数据
}

function submitData() {
	
	var beginDate = getDocValue("beginDate");
	var endDate = getDocValue("endDate");
	if(beginDate!=''){//如果开始时间不为空，才给beginDate4List赋值；否则保持之前的赋值
		beginDate4List = beginDate;
	}
	if(endDate!=''){//同开始时间
		endDate4List = endDate;
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
	if (judgeOneYearDate(beginDate+"-1",endDate+"-1"))
		return ;
	$('#querySave').attr('disabled',true);
	document.getElementById("workflowForm").submit();
}

function hiddenTemplete() {
	document.getElementById("templeteName").style.display = "none";
}
function templateChooseCallback(id,name){
	if(document.getElementById("specTempleteDiv").style.display=="none"){
		document.getElementById("specTempleteDiv").style.display="";
	}
	$("#templeteName").css("display","block").val(name);
	$("#templeteId").val(id);
}
function selectTemplate(){
    templateChoose(templateChooseCallback,$("#appType").val(),true,'','MemberAnalysis','','${reportId}');
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
<table id="tab_compre" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border border_r">
	<tr >
		<td height="70">	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
						<tr>
							<td class="sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" target="dataIFrame" action="${path}/performanceReport/WorkFlowAnalysisController.do?method=comprehensiveAnalysiszListPage">
									<table width="100%" height="100%" border="0px" class="noWrap">
										<tr>
											<td align="right" width="12%"><fmt:message key="common.application.type.label" /> : </td>
											<td >
												<select name="appType" id="appType" style="width: 100%;">
												<c:if test="${(v3x:hasPlugin('form') && v3x:getSysFlagByName('sys_isGovVer')=='true') || v3x:getSysFlagByName('sys_isGovVer')!='true'}">
													<option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option>
												</c:if>
													<option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option>
													<option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
												</select>
											</td>
											<td align="right" width="12%"><fmt:message key="common.template.process.label" /> : </td>
											<td width="40%" valign="middle">
												<div style="float: left;height: 25px;" class="padding_t_5">
													<label for="allTemplete">
														<input type="radio" id="allTemplete" name="templete" onclick="hiddenTemplete();" checked="checked" value="1">
														<fmt:message key='common.all.templete.label' bundle='${v3xCommonI18N}'/>&nbsp;&nbsp;&nbsp;&nbsp;
													</label>
													<label for="chooseTemplete">
														<input type="radio" id="chooseTemplete" name="templete" onclick="selectTemplate()" value="2">
														<fmt:message key='common.the.specified.template.label' />
													</label>
												</div>
												<div id="specTempleteDiv" style="float: left;height: 25px;">
													<input type="text" id="templeteName" name="templeteName" title="" value="" onclick="selectTemplate()" readonly="readonly" style="width:98%;display: none;">
													<input type="hidden" id="templeteId" name="templeteId" value="">
													<input type="hidden" name="tableChart" id="tableChart" />
												</div>
											</td>
										</tr>
										<tr>
											<td align="right"><fmt:message key="common.endtime.label" /> : </td>
											<td >
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												 <input class="cursor-hand" type="text" name="beginDate" id="beginDate" validate="notNull" readonly="true" value='<fmt:formatDate value="${beginDate }" type="Date" dateStyle="full" pattern="yyyy-MM"/>'
												onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate }',true);" style="width: 46%"/>	
												<input class="cursor-hand" type="text" name="endDate" id="endDate" validate="notNull" readonly="true" value='<fmt:formatDate value="${endDate }" type="Date" dateStyle="full" pattern="yyyy-MM"/>'
												onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate }',true);" style="width: 46%"/>
											</td>
										</tr>
									</table>
									<div class='align_center clear padding_t_5' nowrap="nowrap" colspan="0" width="100%">
										<input type="button" id="querySave" onclick="submitData()" value='<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}'/>' class="button-default-2">
										<input type="button" onclick="resetData()" value='<fmt:message key="common.button.reset.label" bundle="${v3xCommonI18N}" />' class="button-default-2">
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
	        <iframe name="dataIFrame" id="dataIFrame"
	                frameborder="0" marginheight="0" marginwidth="0" height="99%" width="100%" scrolling="auto">
	        </iframe>
	    </div>    
	    </td>
	</tr>
</table>
<script type="text/javascript">
<!-- 
var presentTime = "${presentTime}";
var yearMonth = getLastYearMonth('${productUpgrageDate }');
if(document.getElementById("beginDate").value == ""){
	document.getElementById("beginDate").value=yearMonth;
}
if(document.getElementById("endDate").value == ""){
	document.getElementById("endDate").value=yearMonth;
}
beginDate4List = yearMonth;
endDate4List = yearMonth;
initIe10AutoScroll("content",100);
//-->
</script>
</body>
</html>