<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-16
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
	原因：
		由于引用了公用的common_footer.jsp中line:93行的问题main.do?method=headerjs设置了cookie导致M1跳转会话丢失
	marked by ouyp 2017/04/06
	
<%@ include file="/WEB-INF/jsp/common/common.jsp"%> 
--%>
<%@ include file="/WEB-INF/jsp/apps/seeyonreport/common.jsp"%>

<script type="text/javascript" src="${path}/common/seeyonreport/seeyonreport.js${ctp:resSuffix()}"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表数据综合分析</title>

<script type="text/javascript">
	//集群相关信息
	var isCluster = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().isClusterEnabled()%>";
	var mainHost = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().getClusterMainHost()%>";
	var mainHostPort = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().getClusterMainHostPort()%>";
	var oahost_ip = "${oahost_ip}";
	var oahost_port = "${oahost_port}";
	var report_host_ip = "${report_host_ip}";
	var report_host_port = "${report_host_port}";
	var templateId = "${templateId}";
	var srcFrom = "${srcFrom}";
	var conditionJSON = ${conditionJSON};
	//模板名称
	var reportlet = "${reportlet}";
	var userId = "${CurrentUser.id}";
	$(function(){
		//表单提交
		formSubmit();
		
		$("#iframeId").load(function(){
			//隐藏‘邮件’按钮
			//增加判断,iframe加载完毕后再进行隐藏邮件按钮  2016-06-25 yliang
			<%--注释理由：进入iframe的load的时候可以理解为首屏已经完成
			if("complete" == $("#iframeId").readyState){
				var doc = $("#iframeId").contents().find(".fr-btn-text.x-emb-email");
				var email = doc.parent().closest("div.fr-btn");
				email.hide();
			}
			--%>
			//判断iframe是否加载完成：$("#iframeId").contents()[0].readyState
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
            <form id="reportShow" method="post" target="iframeId">
            	<%@include file="seeyonReportDataParameters.jsp"%>
            </form>
        </div>
     </div>
</body>
</html>