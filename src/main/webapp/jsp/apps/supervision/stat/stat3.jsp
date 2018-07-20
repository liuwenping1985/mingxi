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
			<div class="reportTitle" id="reportName">单位督办事项超期率统计</div>
		</c:if>
		<c:if test="${empty rowData}">
			<div class="reportTitle">单位督办事项超期率统计</div>
		</c:if>
		<table border="1" class="only_table"
			style="width: 100%; border-left: none; border-right: none; border-bottom: none;"
			border="0" cellSpacing="0" cellPadding="0" id="fthead">
			<thead>
				<c:if test="${not empty columnData}">
					<tr>
						<td rowspan="2">单位</td>
						<c:forEach items="${columnData }" var="column">
							<td colspan="2">${column.showvalue }</td>
						</c:forEach>
					</tr>
					<tr>
						<c:forEach items="${columnData }" var="column">
							<td>及时率</td>
							<td>超期率</td>
						</c:forEach>
					</tr>
				</c:if>
				<c:if test="${empty columnData}">
					<tr>
						<td rowspan="2">单位</td>
						<td colspan="2">合计</td>
						<td colspan="2">上级交办</td>
						<td colspan="2">会议议定</td>
						<td colspan="2">来文办件</td>
						<td colspan="2">领导批示</td>
					</tr>
					<tr>
						<td>及时率</td>
						<td>超期率</td>
						<td>及时率</td>
						<td>超期率</td>
						<td>及时率</td>
						<td>超期率</td>
						<td>及时率</td>
						<td>超期率</td>
						<td>及时率</td>
						<td>超期率</td>
					</tr>
				</c:if>
			</thead>
			<tbody>
				<c:if test="${not empty rowData}">
					<c:forEach items="${rowData }" var="row">
						<tr>
							<td>${row.value[0].departmentName }</td>
							<c:forEach items="${row.value }" var="row1" varStatus="step">
								<td>${row1.jsPercentage }%</td>
								<td>${row1.cqPercentage }%</td>
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
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
									document.write('<td>0%</td>');
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
</html>
