<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
//getA8Top().showLocation(1602);

// function selectTemplete() {
// 	var url = "templete.do?method=showTempleteFrame&isMultiSelect=false&isWorkflowAnalysiszPage=true&appType=&data=MemberAnalysis";
// 	v3x.openWindow({
// 		url		: url,
// 		width	: 600,
// 		height	: 417,
// 		resizable	: "false"
// 	});
// }
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
        				}else{
	        				item.val(arr[j][1]);
        				}
        			}
        		}
        	})
		}
		if($("#beginDate").val()==""||$("#beginDate").val()==null){
			$("#beginDate").val(getFirstDayOfMonth('${productUpgrageDate}',false));
		}
		if($("#endDate").val()==""||$("#endDate").val()==null){
			$("#endDate").val(getNowDay());
		}
	    $("#templeteName").css("display","block").val(templeteName);
  	}
//解析栏目条件
    function OK(){
    	var content=$("#tab_eff input");
    	var select=$("#tab_eff select");
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
function reset() {
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
		return false;
	}
	if (beginDate == "") {
		alert(v3x.getMessage("V3XLang.common_start_date_not_null_label"));
		return false;
	}
	if (endDate == "") {
		alert(v3x.getMessage("V3XLang.common_end_date_not_null_label"));
		return false;
	}
	
	// 日期跨年判断
	if (judgeOneYearDate(beginDate,endDate))
		return false;
	
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
</script>
<style type="text/css">
	#tab_condition tr td{
		padding:5px;
	}
</style>
</head>
<body scroll="no" class="padding5 page_color">
<table id="tab_eff" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
	<tr height="70">
		<td >	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table id="tab_condition" border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
							<tr>
							<td class=" sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" action="${path }/performanceReport/WorkFlowAnalysisController.do?method=efficiencyAnalysiszListPage" target="dataIFrame" >
									<input type="hidden" name="flowstate" id="flowstate3"  value="${terminate}" />
									<input type="hidden" name="flowstate" id="flowstate0"  value="${finish}" />
									<table width="100%" height="100%" border="0" class="noWrap">
										<tr>
											<td width="16%" align="right"><fmt:message key="common.template.process.label"/> : </td>
											<td width="25%" style="text-align:left">
												<input type="text" id="templeteName" name="templeteName" value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" onclick="selectTemplate();" readonly="readonly" style="width: 47%;">
												<input type="hidden" id="templeteId" name="templeteId" value="" />
											</td>
											<td  align="center">&nbsp;</td>
										</tr>
										<tr>
											<td width="16%" align="right">
												<fmt:message key="common.start.date.label" /> : 
											</td>
											<td width="40%" align="left">
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												&nbsp;<input type="text" name="beginDate" id="beginDate" class="input-date" style="width:35%;float:left"
												 value='<fmt:formatDate value="${beginDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
												-
												<input type="text" name="endDate" id="endDate" class="input-date" style="width:35%;" 
												value='<fmt:formatDate value="${endDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
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
document.getElementById("beginDate").value = getFirstDayOfMonth('${productUpgrageDate}',false);
document.getElementById("endDate").value = getNowDay();
//-->
</script>
</body>
</html>