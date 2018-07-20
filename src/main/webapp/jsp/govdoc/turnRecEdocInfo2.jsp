<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function showSummary(summaryId){
    window.parent.showDetail(summaryId);
}
</script>
</head>
<body>
	<table  cellpadding="0" cellspacing="0" border="0" class="only_table" width="100%">
		<tr>
			<th>来文日期</th>
		</tr>
		<tr>
			<td>${createDate }</td>
		</tr>
		<tr>
			<th>来文单位</th>
		</tr>
		<tr>
			<td><c:if test="${chuantouchakan2 }"><span style="color:blue;cursor:pointer;" onclick="showSummary('${summaryId}')">${createUnit }</span></c:if>
			<c:if test="${!chuantouchakan2 }">${createUnit }</c:if></td>
		</tr>
		<tr>
			<th>办理意见</th>
		</tr>
		<tr>
			<td>${opinion }</td>
		</tr>
	</table>
</body>
</html>