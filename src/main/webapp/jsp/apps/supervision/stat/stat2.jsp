<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>表单统计</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/apps_res/supervision/css/stat2.css${v3x:resSuffix()}" />">
</head>
<body>

	<div id="context" class="absolute h100b" width="100%" height="100%"
		style="top: 0px; bottom: 0px; left: 0; right: 0; background: #fff;">
		<c:if test="${not empty rowData}">
			<div class="reportTitle" id="reportName">单位督办事项完成率统计</div>
		</c:if>
		<c:if test="${empty rowData}">
			<div class="reportTitle">单位督办事项完成率统计</div>
		</c:if>
		<table border="1" class="only_table"
			style="width: 100%; border-left: none; border-right: none; border-bottom: none;"
			border="0" cellSpacing="0" cellPadding="0" id="fthead">
			<thead>
				<c:if test="${not empty columnData}">
					<tr>
						<td rowspan="2">单位</td>
						<c:forEach items="${columnData }" var="column">
							<td colspan="3">${column.showvalue }</td>
						</c:forEach>
					</tr>
					<tr>
						<c:forEach items="${columnData }" var="column">
							<td>事项数</td>
							<td>完成数</td>
							<td>完成率</td>
						</c:forEach>
					</tr>
				</c:if>
				<c:if test="${empty columnData}">
					<tr>
						<td rowspan="2">单位</td>
						<td colspan="3">合计</td>
						<td colspan="3">上级交办</td>
						<td colspan="3">会议议定</td>
						<td colspan="3">来文办件</td>
						<td colspan="3">领导批示</td>
					</tr>
					<tr>
						<td>事项数</td>
						<td>完成数</td>
						<td>完成率</td>
						<td>事项数</td>
						<td>完成数</td>
						<td>完成率</td>
						<td>事项数</td>
						<td>完成数</td>
						<td>完成率</td>
						<td>事项数</td>
						<td>完成数</td>
						<td>完成率</td>
						<td>事项数</td>
						<td>完成数</td>
						<td>完成率</td>
					</tr>
				</c:if>
			</thead>
			<tbody>
				<c:if test="${not empty rowData}">
					<c:forEach items="${rowData }" var="row">
						<tr>
							<td>${row.value[0].departmentName }</td>
							<c:forEach items="${row.value }" var="row1" varStatus="step">
								<td <c:if test="${row1.allItems gt 0 }"> class="td_content" style="cursor:pointer;"
									onclick="showDetail('${row1.departmentId}','${columnData[step.index].id}','1,2',${row1.allItems})" </c:if>>${row1.allItems}</td>
								<td  <c:if test="${row1.endItems gt 0 }"> class="td_content" style="cursor:pointer;"
									onclick="showDetail('${row1.departmentId}','${columnData[step.index].id}','2',${row1.endItems})" </c:if>>${row1.endItems}</td>
								<td>${row1.itemPercentage }%</td>
							</c:forEach>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty rowData}">
					<script type="text/javascript">
					function writeTr(){
						var parent = window.parent.document;
						var departmentText;
						if($(parent).find("input[name=tjfw]:checked").val()=='1'){
							departmentText = '${currentAccountName}';
						}else{
							departmentText = $(parent).find("#departmentText").val();
						}
						if(departmentText != ''){
							var array = departmentText.split('、');
							for(var i=0;i<array.length;i++){
									document.write('<tr>');
									document.write('<td>'+array[i]+'</td>');
									document.write('<td>0</td>');
									document.write('<td>0</td>');
									document.write('<td>0%</td>');
									document.write('<td>0</td>');
									document.write('<td>0</td>');
									document.write('<td>0%</td>');
									document.write('<td>0</td>');
									document.write('<td>0</td>');
									document.write('<td>0%</td>');
									document.write('<td>0</td>');
									document.write('<td>0</td>');
									document.write('<td>0%</td>');
									document.write('<td>0</td>');
									document.write('<td>0</td>');
									document.write('<td>0%</td>');
									document.write('</tr>');
							}
						}
					}
					writeTr();
					
				</script>
				</c:if>
			</tbody>
		</table>
	</div>

</body>
<script type="text/javascript">
	function showDetail(departmentValue,mbly,sxzt,length){
		if(length == '0'){
			return;
		}
		var url = _ctxPath+"/supervision/supervisionStatController.do?method=openShowDetail&type=2&departmentValue="+departmentValue+"&mbly="+mbly+"&sxzt="+sxzt;
		//增加表单参数
		//时间
		var parent = window.parent.document;
		var fromDate = "&fromdate="+$(parent).find("#fromdate").val();
		var toDate = "&todate="+$(parent).find("#todate").val();
		var tjfw = "&tjfw="+$(parent).find("input[name=tjfw]:checked").val();
		//办理性质
		var bb = "";  
	     var temp = "";  
	     var a = window.parent.document.getElementsByName("blxz");  
	     for ( var i = 0; i < a.length; i++) {  
	     if (a[i].checked) {  
	     temp = a[i].value; 
	     if(bb==""){
	    	 bb = temp;
	     }else{
	     	bb = bb + "," +temp;  
	     }
	     }  
	     }  
	     var blxz="&blxz="+bb;
	     url+=fromDate;
	     url+=toDate;
	     url+=blxz;
	     url+=tjfw;
		//这里为什么传参数不传id,因为需要分页查询
		var dialog = $.dialog({
			title : "显示明细----事项概况",
			minParam : 'false',
			maxParam : 'false',
			isDrag : 'false',
			id : 'frOpenDialog',
			url : url,
			width : $(getCtpTop()).width() - 200,
			height : $(getCtpTop()).height() - 100,
			'targetWindow' : getCtpTop()
		});
	};
	
</script>
</html>
