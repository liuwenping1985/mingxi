<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>${ctp:toHTML(magazineVO.infoMagazine.subject)}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script>

/** 页面加载 */
$(document).ready(function () {
	//正文加载
	proce = $.progressBar();
	hasOffice(getDefaultContentType());
});

</script>
</head>

<body class="h100b over_hidden page_color"  onunload="">

	<div id="componentDiv" name="componentDiv" align="left" style="width:100%;height:100%;">
		<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
	</div>
</body>
