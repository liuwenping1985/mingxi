<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function OK(){
	var returnObj = new Object();
	returnObj.phaseName = $("#phaseId option:selected").text();
	returnObj.phaseId = $("#phaseId").val();
	return returnObj;
}
</script>
</head>
<body style="overflow: hidden;">
 <div id="setPhase">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<tr>
		<td align="center" >
			<select id="phaseId" name="phaseId" class="condition" style="margin-top:40px;width:150px;">
				<c:forEach var="phase" varStatus="status" items="${phaseSet}">
					<option value="${phase.id}" ${phaseId == phase.id ? 'selected' : ''}>${phase.phaseName}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	</table>
  </div>
</body>
</html>