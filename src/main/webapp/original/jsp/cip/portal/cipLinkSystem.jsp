<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <script type="text/javascript">
 	function excute(){ 
	 	document.charset="${datacharset}"; 
		var form = document.getElementById("addForm");
		form.action = "${url}";
		form.submit();
 	}
 </script>

</head>
<body onload="excute();">
	<form name="addForm" id="addForm" method="${httpMethod}">
		<input type='hidden' name='${userField}' value='${userValue}'>
		<input type='hidden' name='${pwdField}' value='${pwdValue}'>
	</form>
</body>
</html>