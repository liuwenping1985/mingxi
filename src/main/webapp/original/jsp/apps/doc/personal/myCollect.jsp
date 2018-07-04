<%--
 $Author:
 $Rev: 
 $Date:: 
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<html>
<head>
<title></title>
<script type="text/javascript"
	src="${path}/WEB-INF/jsp/apps/doc/js/docSubscribe.js"></script>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<script type="text/javascript">
</script>
</head>
<body class="over_hidden ">
	<div id="tabs" class="comp" comp="type:'tab'">
		<div id="tabs_head" class="common_tabs clearfix page_color">
			<ul class="left">
				<li class="current"><a hideFocus="true"
					href="javascript:void(0)" tgt="tab1_iframe" onclick="javascript:void(0);"><span>${ctp:i18n('doc.jsp.knowledge.my.collection')}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body">
			<iframe id="tab1_iframe" border="0"
				src="${path}/doc/knowledgeController.do?method=getMyDocCollect" frameBorder="no" width="100%"></iframe>
		</div>
	</div>
</body>
</html>

