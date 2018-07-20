<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>人员定密设置</title>
<script type="text/javascript">
function OK(){
	var fileIds="${fileIds}";
	var selectValue = document.getElementById("secretSelect").value;
	return fileIds+"&"+selectValue;
}
</script>
</head>
<body>
<form id="sendForm" class="sendForm">
<span style="font-size: 15px;">${ctp:i18n('secret.user.set.label')}：<br><br></span>
<div></div>
<div align="center">
<span style="font-size: 15px;">${ctp:i18n('secret.user.set.secret')}：</span>
<SELECT id="secretSelect" style="width:300" name="state" selectedIndex="$!{state}">
<c:forEach var="secretdata" items="${secretLevelList}" varStatus="status">
<OPTION value="${secretdata.value }"<c:if test="${param.secretLevel != null && secretdata.label eq param.secretLevel}" > selected="selected"</c:if> >${secretdata.label }</OPTION>
</c:forEach>
</SELECT>
</div>
</form>
</body>
</html>