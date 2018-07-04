<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%@ include file="docHeader.jsp" %>
<html>
<head>
<style type="text/css">
.border_t {
  border-top: 1px solid #b6b6b6;
}
.mxtgrid div.hDiv {
   border-top-width: 0px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="docLibRightMenu.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body scroll="no" class="padding5">
<span id="nowLocation"></span>
<div class="main_div_row2">
  <div class="right_div_row2">
<%@ include file="libTable.jsp"%>
</div></div>
<iframe name="theFrame" frameBorder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
</body>
<script language="javascript">
	var isAdvancedQuery = ${param.method eq 'advancedQuery'};
	showCtpLocation('F04_docLibsConfig');
</script>
</html>