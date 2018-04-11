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
	function changeSrc(path,n){
		if(n==1){
			$("#tab1_iframe").attr("src",path);
		}
		if(n==2){
			$("#tab2_iframe").attr("src",path);
		}
	}
	//初始化rss页面，隐藏一些不需要的dom
	function initRss(){
		var tb2Frame = $(window.frames["tab2_iframe"].document);
		tb2Frame.find("#toolbar").attr("class","hidden");
		var dom = tb2Frame.find("td a[id^=href_expand_]");
		try{
			$(window.parent.document).contents().find("#tab2_iframe")[0].contentWindow.toolbarTree();
		}catch(e){}
	}
</script>
</head>
<body class="over_hidden ">
	<div id="tabs" class="comp" comp="type:'tab'">
		<div id="tabs_head" class="common_tabs clearfix page_color">
			<ul class="left">
				<li class="current"><a hideFocus="true"
					href="javascript:void(0)" tgt="tab1_iframe" onclick="javascript:changeSrc('${path}/doc/knowledgeController.do?method=getMyDocSubscribe',1);"><span>${ctp:i18n('doc.jsp.alert.title')}</span></a></li>
				<li><a hideFocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" onclick="javascript:changeSrc('${path}/rss/rssController.do?method=main&isPerson=true',2);"><span>${ctp:i18n('doc.jsp.home.label.rss')}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body">
			<iframe id="tab1_iframe" border="0"
				src="${path}/doc/knowledgeController.do?method=getMyDocSubscribe" frameBorder="no" width="100%"></iframe>
			<iframe id="tab2_iframe" class="hidden"  border="0" onreadystatechange="javascript:initRss();"
				frameBorder="no" width="100%" ></iframe>
		</div>
	</div>
</body>
</html>

