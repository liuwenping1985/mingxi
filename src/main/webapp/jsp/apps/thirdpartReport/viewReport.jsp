<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title> 
<script>
     if("${canConnect}" == "false"){
    	 alert("报表服务没有启动！");
    	 window.close();
     }else{
    	 window.location.href="${thirdpartReportHost}?op=fs";
     }
     
</script>
</head>
<body>
</body>
</html>

