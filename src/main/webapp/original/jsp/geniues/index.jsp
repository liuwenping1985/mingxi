<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="w100b h100b">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title></title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/skin/default/skin.css${v3x:resSuffix()}" />">
	<script type="text/javascript" src="${path}/common/SelectPeople/js/orgDataCenter.js"></script>
	<script type="text/javascript" src="${path}/main/common/js/frame-ajax.js"></script>
	<script type="text/javascript">
		var isGeniusTopWindow = true;
		<%--关闭窗口,操作成功后回调--%>
		function closeWindow() {
			if (window.dialogArguments) {
				window.returnValue = "true";
				window.close();
			} else {
				window.close();
			}
		}
		
		$(document).ready(function() {
		    if ("${url}".indexOf("/") == 0) {
		        $("#main").attr("src", "${path}${url}");
		    } else {
		        $("#main").attr("src", "${path}/${url}");
		    }
		});
	</script>
</head>
<body scroll="no" class="w100b h100b">
	<iframe src="" id="main" name="main" frameborder="0" class="w100b h100b" style="position: fixed;"></iframe>
</body>
</html>