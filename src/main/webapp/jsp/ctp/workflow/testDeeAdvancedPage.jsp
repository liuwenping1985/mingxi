<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">

function OK(){
	var jsonObj = {};
	jsonObj.id = "DEEDATAID";
	jsonObj.label = "DEE已经设置好的数据";
	return jsonObj;
}
</script>
</head>
<body>
<form id="theForm" name="theForm" action="" method="post">
processId:${param.processId}
</form>
</body>
</html>