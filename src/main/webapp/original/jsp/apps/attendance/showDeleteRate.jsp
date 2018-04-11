<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
	#delete-info{font-size:16px;color:#333;padding-top:5px;text-align: center;line-height: 30px;}
	.d-error{color: red;}
	.d-success{color: #5cb85c;}
</style>
</head>
<body class="h100b">
	<div id="delete-info"></div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/apps_res/attendance/js/showDeletePage.js${ctp:resSuffix()}"></script>
</html>