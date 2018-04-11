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
$(function(){
	//获取回填数据
	var pv = getA8Top().paramValue;
	//解析数据
	var array=pv.split(",");
	var arr=new Array();
	for(var i=0;i<array.length;i++){
		var p_array=array[i].split("=");
		arr[i]=p_array;
	}
	reOnload_section(arr);
})
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
        				}else{
	        				item.val(arr[j][1]);
        				}
        			}
        		}
        	})
		}
		if($("#beginDate").val()==""||$("#beginDate").val()==null){
			$("#beginDate").val(getLastYearMonth('${productUpgrageDate }'));
		}
		if($("#endDate").val()==""||$("#endDate").val()==null){
			$("#endDate").val(getLastYearMonth('${productUpgrageDate }'));
		}
    	if($("#chooseTemplete").attr("checked")=='checked'){
    		$("#templeteName").css("display","block").val(templeteName);
    	}
  	}
//解析栏目条件
    function OK(){
    	var content=$("#tab_compre input");
    	var select=$("#tab_compre select");
    	var array=new Array();
    	var arr=new Array();
    	var j=0;
    	var beginDate="";
    	var endDate="";
    	$.each(content,function(i,n){
    		var item=$(n);
    		if(item.attr("type")=='hidden'){
    			array[j]=""+item.attr("id")+"="+item.val();
    			j++;
    		}
    		if(item.attr("type")=='radio'){
    			if(item.attr("checked")=='checked'){
    				array[j]=""+item.attr("id")+"="+item.val();
    				j++;
    			}
    		}
    		if(item.attr("type")=='text'){
    			array[j]=""+item.attr("id")+"="+item.val();
    			if(item.attr("id")=="beginDate"){
    				beginDate=item.val();
    			}
    			if(item.attr("id")=="endDate"){
    				endDate=item.val();
			}
    			j++;
    		}
    	})
    	
	if (!judgeOneYearDate(beginDate+"-1",endDate+"-1")){		
    	$.each(select,function(i,n){
    		var item=$(n);
    		array[j]=""+item.attr("id")+"="+item.val();
    		j++;
    	})
    	arr[0]=array;
    	return arr;
	}
    }

function resetData() {
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("templeteName").value="";
	document.getElementById("templeteId").value="";
	document.getElementById("allTemplete").checked=true;
	document.getElementById("specTempleteDiv").style.display="none";
}

function submitData() {
	var beginDate = getDocValue("beginDate");
	var endDate = getDocValue("endDate");
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
}

function hiddenTemplete() {
	document.getElementById("templeteName").style.display = "none";
	document.getElementById("templeteName").value="";
	document.getElementById("templeteId").value="";
}
function templateChooseCallback(id,name){
	$("#templeteName").css("display","block").val(name);
	$("#templeteId").val(id.replace(/\,/g,"|"));
}
function selectTemplate(){
// 	var appType=$("#appType").val();
// 	if(appType==2){
//  		templateChoose(templateChooseCallback,2,'','','maxScope');
// 	}else if(appType==1){
// 		templateChoose(templateChooseCallback,1,'','','maxScope');
// 	}else if(appType==4){
// 		templateChoose(templateChooseCallback,4,'','','maxScope'); 
// 	}
  templateChoose(templateChooseCallback,$("#appType").val(),true,'','MemberAnalysis','','${reportId}');
}
//-->
</script>
<style type="text/css">
	#tab_condition tr td{
		padding:5px;
	}
</style>
</head>
<body scroll="no" class="padding5 page_color">
<table id="tab_compre" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
	<tr >
		<td height="70">	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
					<table id="tab_condition" border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
						<tr>
							<td class="sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" target="dataIFrame" action="${path}/performanceReport/WorkFlowAnalysisController.do?method=comprehensiveAnalysiszListPage">
									<table border="0px" style="float:left">
										<tr>
											<td ><fmt:message key="common.application.type.label" /> : </td>
											<td>
												<select name="appType" id="appType" style="float:left">
												<c:if test="${(v3x:hasPlugin('form') && v3x:getSysFlagByName('sys_isGovVer')=='true') || v3x:getSysFlagByName('sys_isGovVer')!='true'}">
													<option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option>
												</c:if>
													<option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option>
													<option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
												</select>
											</td>
										</tr>
										<tr>
											<td><fmt:message key="common.template.process.label" /> : </td>
											<td>
												<div style="float:left;height:25px">
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
												</div>
											</td>
										</tr>
										<tr>
											<td><fmt:message key="common.endtime.label" /> : </td>
											<td >
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												 <input class="cursor-hand" type="text" name="beginDate" id="beginDate" validate="notNull" readonly="true" value=""
												onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate }',true);" style="width: 46%"/>	
												<input class="cursor-hand" type="text" name="endDate" id="endDate" validate="notNull" readonly="true" value="${endDate }" value=""
												onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate }',true);" style="width: 46%"/>
											</td>
											<td align="left" nowrap="nowrap"></td>
										</tr>
									</table>
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
</table>
<script type="text/javascript">
<!-- 
var yearMonth = getLastYearMonth('${productUpgrageDate }');
document.getElementById("beginDate").value=yearMonth;
document.getElementById("endDate").value=yearMonth;
beginDate4List = yearMonth;
endDate4List = yearMonth;
//-->
</script>
</body>
</html>