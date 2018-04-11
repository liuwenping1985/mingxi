<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>电话会议管控</title>
</head>
<script type="text/javascript">
	function load(){
		if("${errorMsg}"!=''){
			$.alert("${errorMsg}");
		}else{
			document.getElementById("multicallform").submit();
		}
	}
</script>
<body onload="load();">
	<form id="multicallform" action="http://meeting.commchina.net/zhiyuan/api/agent_api.php" method="POST">
		<input type="hidden" id="action" name="action" value="openManagement">
		<input type="hidden" id="company_id" name="company_id" value="${company_id}">
		<input type="hidden" id="call_time" name="call_time" value="${call_time}">
		<input type="hidden" id="signature" name="signature" value="${signature}">
		<input type="hidden" id="user_name" name="user_name" value="${user_name}">
		<input type="hidden" id="user_phone" name="user_phone" value="${user_phone}">
		<input type="hidden" id="user_role" name="user_role" value="${user_role}">
	</form>
</body>
</html>