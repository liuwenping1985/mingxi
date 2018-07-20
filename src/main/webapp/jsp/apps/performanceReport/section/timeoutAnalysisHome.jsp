<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>超时分析</title>
<script type="text/javascript">
<!--
//getA8Top().showLocation(1605);

// function selectTemplete() {
// 	var url = "templete.do?method=showTempleteFrame&isMultiSelect=false&isWorkflowAnalysiszPage=true&data=MemberAnalysis";;
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
	for(var i=0;i<array.length;i++){
		var p_array=array[i].split("=");
		arr[i]=p_array;
	}
	for(var i=0;i<arr.length;i++){
		if(arr[i][0]=='templeteName'){
			$("#templeteName").val(arr[i][1]);
		}else if(arr[i][0]=='beginDate'){
			if(arr[i][1]==""||arr[i][1]==null){
				$("#beginDate").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			}else{
				$("#beginDate").val(arr[i][1]);
			}
		}else if(arr[i][0]=='endDate'){
			if(arr[i][1]==""||arr[i][1]==null){
				$("#endDate").val(getNowDay());
			}else{
				$("#endDate").val(arr[i][1]);
			}
		}else if(arr[i][0]=='templeteId'){
			$("#templeteId").val(arr[i][1]);
		}else if(arr[i][0]=='flowstate'){
				var flowstate=$("input[name='flowstate']");
				//将所有的checkbox设置为未选中
				$.each(flowstate,function(i,n){
					$(n).attr("checked",false);
				})
				var fv=arr[i][1].split("|");
				for(var j=0;j<fv.length;j++){
					$("input[name='flowstate'][value="+fv[j]+"]").attr("checked",true);
				}
		}
	}
})
function OK(){
	//submitData();
	var array=new Array();
	var arr=new Array();
	array[0]="templeteId="+$("#templeteId").val();
	array[1]="beginDate="+$("#beginDate").val();
	array[2]="endDate="+$("#endDate").val();
	array[3]="templeteName="+$("#templeteName").val();
	var flowstate=$("input[name='flowstate']");
	var str='';
	var flowstateValue='';
	if(flowstate!=null){
		$.each(flowstate,function(i,n){
			var f=$(n);
			flowstateValue=f.attr("name");
			if(f.attr("checked")=='checked'){
				str+=f.val()+"|";
			}
		})
	}
	
	var radioFlag=$("input[name='flowstate']:checked");
	if($.isNull(radioFlag)||radioFlag.length==0){
		alert(v3x.getMessage("V3XLang.common_select_process_state_label"));
		return ;
	}
	str=str.substring(0, str.length-1);
	array[4]=""+flowstateValue+"="+str;
	arr[0]=array;
	return arr;
}
function reset() {
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
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
	<tr height="70">
		<td style="">	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table id="tab_condition" border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
							<tr>
								
							</tr>
							<tr>
							<td class="sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" action="${path }/performanceReport/WorkFlowAnalysisController.do?method=timeoutAnalysiszListPage" target="dataIFrame">
									<table width="100%" height="100%" border="0" class="noWrap">
										<tr>
											<td width="17%" align="left"><fmt:message key="common.template.process.label"/> : </td>
											<td width="40%" align="left">
												<input type="text" id="templeteName" name="templeteName" value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" onclick="selectTemplate()" readonly="readonly" style="width: 150px;">
												<input type="hidden" id="templeteId" name="templeteId" value="" style="width: 200px;">
											</td>
										</tr>
										<tr>
											<td width="8%" align="right"><fmt:message key="common.process.state.label" /> : </td>
											<td width="60%" align="left">
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
										<tr>
											<td width="12%" align="right"><fmt:message key="common.start.date.label" /> : </td>
											<td width="50%" align="left">
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												<input type="text" name="beginDate" id="beginDate" class="input-date" style="width:95px"
												 value='<fmt:formatDate value="${beginDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
												-
												<input type="text" name="endDate" id="endDate" class="input-date" style="width:95px" 
												value='<fmt:formatDate value="${endDate}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate}',false);" readonly >
											</td>
											<td align="left" >&nbsp;</td>
											<td width="20%" align="center">&nbsp;</td>
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