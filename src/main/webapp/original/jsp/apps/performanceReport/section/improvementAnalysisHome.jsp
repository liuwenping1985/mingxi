<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
$(function(){
	//获取回填数据
	var pv = getA8Top().paramValue;
	//解析数据
	var array=pv.split(",");
	var arr=new Array();
	var reportCategory=new Array();
	for(var i=0;i<array.length;i++){
		var p_array=array[i].split("=");
		arr[i]=p_array;
	}
	reOnload_section(arr);
})
	function reOnload_section(arr){
    	//回填数据操作,循环select元素
    	var section_select=$("#tab_impro select");
    	for(var j=0;j<arr.length;j++){
    		$.each(section_select,function(i,n){
    			var item=$(n);
    			if(item.attr("id")==arr[j][0]){
    				item.val(arr[j][1]);
    			}
    		})
    	}
    	
  		var section_input=$("#tab_impro input");
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
		if($("#beginDate1").val()==""||$("#beginDate1").val()==null){
			$("#beginDate1").val(getFirstDayOfMonth('${productUpgrageDate}',true));
		}
		if($("#endDate1").val()==""||$("#endDate").val()==null){
			$("#endDate1").val(date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',true)));
		}
		if($("#beginDate2").val()==""||$("#beginDate2").val()==null){
			$("#beginDate2").val(getFirstDayOfMonth('${productUpgrageDate}',false));
		}
		if($("#endDate2").val()==""||$("#endDate2").val()==null){
			$("#endDate2").val(date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',false)));
		}
	    $("#templeteName").css("display","block").val(templeteName);
  	}
//解析栏目条件
    function OK(){
    	var content=$("#tab_impro input");
    	var select=$("#tab_impro select");
    	var array=new Array();
    	var arr=new Array();
    	var j=0;
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
    			j++;
    		}
    	})
    	$.each(select,function(i,n){
    		var item=$(n);
    		array[j]=""+item.attr("id")+"="+item.val();
    		j++;
    	})
    	arr[0]=array;
    	return arr;
    }
<!--
//getA8Top().showLocation(1603);

// function selectTemplete() {
// 	var url = "templete.do?method=showTempleteFrame&isMultiSelect=false&isWorkflowAnalysiszPage=true&data=MemberAnalysis";
// 	var rv = v3x.openWindow({
// 		url		: url,
// 		width	: 600,
// 		height	: 417,
// 		resizable	: "false"
// 	});
	
// }
function reset() {
	document.getElementById("templeteId").value="";
	document.getElementById("beginDate1").value="";
	document.getElementById("beginDate2").value="";
	document.getElementById("endDate1").value="";
	document.getElementById("endDate2").value="";
}

function submitData() {
	var templeteId = getDocValue("templeteId");
	var beginDate1 = getDocValue("beginDate1");
	var endDate1 = getDocValue("endDate1");
	var beginDate2 = getDocValue("beginDate2");
	var endDate2 = getDocValue("endDate2");
	
	if (templeteId == "") {
		alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
		return ;
	}
	if (beginDate1 == "" || beginDate2 == "") {
		alert(v3x.getMessage("V3XLang.common_start_date_not_null_label"));
		return ;
	}
	if (endDate1 == "" || endDate2 == "") {
		alert(v3x.getMessage("V3XLang.common_end_date_not_null_label"));
		return ;
	}
	
	// 日期跨年判断
	if (judgeOneYearDate(beginDate1,endDate1))
		return ;
	if (judgeOneYearDate(beginDate2,endDate2))
		return ;
	
}
function templateChooseCallback(id,name){
	$("#templeteName").css("display","block").val(name);
	$("#templeteId").val(id);
}
function selectTemplate(){
  templateChoose(templateChooseCallback,'',false,'','MemberAnalysis','','${reportId}');
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
<table id="tab_impro" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
	<tr height="75" >
		<td style="">	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table id="tab_condition"border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
						<tr>
							
							</tr>
							<tr>
							<td class="sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" target="dataIFrame" action="${path }/performanceReport/WorkFlowAnalysisController.do?method=improvementAnalysiszListPage">
									<table width="100%" height="100%" border="0" class="noWrap">
										<tr>
											<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
										</tr>
										<tr>
											<td align="right" width="21%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<fmt:message key="common.template.process.label" /> : </td>
											<td align="left">
												<input type="text" id="templeteName" name="templeteName" value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" onclick="selectTemplate()">
												<input type="hidden" id="templeteId" name="templeteId" value="" />
											</td>
										</tr>
										<tr>
											<td  align="right" width="12%">&nbsp;&nbsp;<fmt:message key="common.contrast.range.one.label" /> : </td>
											<td  colspan="0" align="left">
												<input type="text" name="beginDate1" id="beginDate1" class="input-date" style="width:95px"
												 value='<fmt:formatDate value="${beginDate1}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
												-
												<input type="text" name="endDate1" id="endDate1" class="input-date" style="width:95px" 
												value='<fmt:formatDate value="${endDate1}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
											</td>
										</tr>
										<tr>
											<td width="12%" align="right"><fmt:message key="common.contrast.range.two.label" /> : </td>
											<td  colspan="0" align="left">
												 <input type="text" name="beginDate2" id="beginDate2" class="input-date" style="width:95px"
												 value='<fmt:formatDate value="${beginDate2}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
												-
												<input type="text" name="endDate2" id="endDate2" class="input-date" style="width:95px" 
												value='<fmt:formatDate value="${endDate2}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
											</td>
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
var date = new Date();
document.getElementById("beginDate1").value = getFirstDayOfMonth('${productUpgrageDate}',true);
document.getElementById("endDate1").value = date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',true));
document.getElementById("beginDate2").value = getFirstDayOfMonth('${productUpgrageDate}',false);
document.getElementById("endDate2").value = date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',false));
//-->
</script>
</body>
</html>