<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-16
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/seeyonreport/seeyonreport.js${ctp:resSuffix()}"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表数据综合分析</title>

<script type="text/javascript">
	//集群相关信息
	var isCluster = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().isClusterEnabled()%>";

	 var mainHost ="${ctp:escapeJavascript(host_ip)}";
	 var mainHostPort =  "${ctp:escapeJavascript(host_port)}";
	var oahost_ip = "${ctp:escapeJavascript(oahost_ip)}";
	var oahost_port = "${ctp:escapeJavascript(oahost_port)}";
	var templateId = "${ctp:escapeJavascript(templateId)}";
	var srcFrom = "${ctp:escapeJavascript(srcFrom)}";
	var conditionJSON = ${conditionJSON};
	//模板名称
	var reportlet = "${ctp:escapeJavascript(reportlet)}";
	var userId = "${ctp:escapeJavascript(CurrentUser.id)}";
	$(function(){
		//表单提交
		formSubmit();
		
		$("#iframeId").load(function(){
			//隐藏‘邮件’按钮
			var doc = $("#iframeId").contents().find(".fr-btn-text.x-emb-email");
			var email = doc.parent().closest("div.fr-btn");
			email.hide();
			
		});
		
	});
</script>

</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
    
        <div class="layout_center" id="center" layout="border:true" style="overflow:hidden">
        	<iframe id="iframeId" name="iframeId" width="100%" height="100%" frameborder="0" >
        	</iframe>
            <form id="reportShow" method="post" target="iframeId"></form>
        </div>
     </div>
</body>
</html>