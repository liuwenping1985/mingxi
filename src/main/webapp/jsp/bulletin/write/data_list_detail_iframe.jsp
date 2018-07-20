<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<html style="height:100%">
<head>
<%@ include file="../include/header.jsp" %>
</head>
<script type="text/javascript">
if("${param.from}" == "list"){
  getDetailPageBreak();
}
</script>
<body class="detailBody" style="height:100%">
	<div class="scrollList">
		<%@ include file="../include/dataDetail.jsp" %>
	</div>
</body>
</html>

