<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查看日志</title>	
<script type="text/javascript">

</script>


</head>

<body scroll="no" style="overflow: no">
<iframe name="" src="${basicURL}?method=viewLogIfame&projectId=${param.projectId}" style="width:100%;height:100%"></iframe>
</body>
</html>