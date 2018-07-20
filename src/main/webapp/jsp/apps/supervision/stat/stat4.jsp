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
			<div class="reportTitle" id="reportName">单位督办事项考核统计</div>
		</c:if>
		<c:if test="${empty rowData}">
			<div class="reportTitle">单位督办事项考核统计</div>
		</c:if>
		<table border="1" class="only_table"
			style="width: 100%; border-left: none; border-right: none; border-bottom: none;"
			border="0" cellSpacing="0" cellPadding="0" id="fthead">
			<thead>
				<tr>
					<td width="30%" style="text-align: center">单位</td>
					<td style="text-align: center">优</td>
					<td style="text-align: center">良</td>
					<td style="text-align: center">中</td>
					<td style="text-align: center">差</td>
				</tr>

			</thead>
			<tbody>
				<c:if test="${not empty rowData}">
					<c:forEach items="${rowData }" var="row">
						<tr>
							<td>${row.departmentName }</td>
							<td <c:if test="${row.veryGoodLength gt 0 }"> class="td_content" style="cursor:pointer;"
								onclick="showDetail('${row.departmentId}','${veryGoodEnum }',${row.veryGoodLength })" </c:if>>${row.veryGoodLength
								}</td>
							<td <c:if test="${row.goodLength gt 0 }"> class="td_content" style="cursor:pointer;"
								onclick="showDetail('${row.departmentId}','${goodEnum }',${row.goodLength })" </c:if>>${row.goodLength
								}</td>
							<td <c:if test="${row.generalLength gt 0 }"> class="td_content" style="cursor:pointer;"
								onclick="showDetail('${row.departmentId}','${GeneralEnum }',${row.generalLength })" </c:if>>${row.generalLength
								}</td>
							<td <c:if test="${row.badLength gt 0 }"> class="td_content" style="cursor:pointer;"
								onclick="showDetail('${row.departmentId}','${badEnum }',${row.badLength })" </c:if>>${row.badLength
								}</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty rowData}">
					<script type="text/javascript">
					function writeTr(){
						var parent = window.parent.document;
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
									document.write('<td>0</td>');
									document.write('<td>0</td>');
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
	function showDetail(departmentValue,level,length){
		if(length == '0'){
			return;
		}
		var url = _ctxPath+"/supervision/supervisionStatController.do?method=openShowDetail&type=4&departmentValue="+departmentValue+"&level="+level;
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
	     var sxzt = "";  
	     var a = window.parent.document.getElementsByName("sxzt");  
	     for ( var i = 0; i < a.length; i++) {  
	     if (a[i].checked) {  
	     temp = a[i].value; 
	     if(sxzt==""){
	    	 sxzt = temp;
	     }else{
	     	sxzt = sxzt + "," +temp;  
	     }
	     }  
	     }  
	     sxzt="&sxzt="+sxzt;
	     url+=fromDate;
	     url+=toDate;
	     url+=blxz;
	     url+=sxzt;
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
