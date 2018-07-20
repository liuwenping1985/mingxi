<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>意见保留设置</title>
<%@ include file="/WEB-INF/jsp/edoc/edocHeader.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script>
	function OK(){
		var radios = document.getElementsByName("optionWay");
		var returnVal = "";
		for(var i =0;i<radios.length;i++){
			if(radios[i].checked){
				returnVal = radios[i].value;
			}
		}
		return returnVal;
	}
</script>
</head>
<body>
	<form id="opinionForm" action="">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='edoc.form.flowperm.setup'/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- lijl添加(意见保留设置 ) -->
					<input type="hidden" name="opinionType" id="opinionType" value="${opinionType}">
					<input type="hidden" name="optionId"   id="optionId" value="${optionId}">
					<input type="hidden" name="summaryId"   id="summaryId" value="${summaryId}">
					<input type="hidden" name="policy"   id="policy" value="${policy}">
					<input type="hidden" name="affairId"   id="affairId" value="${affairId}">
					<fmt:message key="edoc.form.flowperm.setup" />:
				</td>
				<td>
					<!-- lijl添加(只保留最后一次处理意见 )-->
					<input type="radio" id="optionType3" name="optionWay" value="1" checked="checked"/>
					<LABEL for="optionType3"><fmt:message key="edoc.form.flowperm.showLastOptionOnly-s" /></LABEL>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<!-- lijl添加(保留所有意见) -->
					<input type="radio" id="optionType4" name="optionWay" value="2" />
					<LABEL for="optionType4"><fmt:message key="edoc.form.flowperm.all-s" /></LABEL>
				</td>
			</tr>
			</table>
			</td>
		</tr>
		</table>
	</form>
</body>
</html>