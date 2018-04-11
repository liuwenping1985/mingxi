<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript">
	$(function() {
		infoReadFormDisplay();
		$("#html").attr("align", "left");
		$("#html").find("table").css("width", "100%");
	});
</script>
<!-- 查看处理页面 -->
<title>${ctp:i18n('collaboration.summary.pageTitle')}</title>
</head>
<body class="h100b page_color">
	<div id="componentDiv" name="componentDiv" align="left">
		<%@ include file="/WEB-INF/jsp/apps/gov/govform/form_show.jsp"%>
	</div>
</body>
</html>

