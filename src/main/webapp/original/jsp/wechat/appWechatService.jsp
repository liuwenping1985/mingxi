<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
</head>
<body class="h100b over_hidden">
	<div class="crumbly">
	    <div class="before">${ctp:i18n('weixin.system.menu.appIntegratedConfig')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.appWechatService')}</span>
	</div>
	<div class="w-server-set">
	    <div class="setContent" style="font-size: 14px;color: #000;">
	        <span>配置说明：</span>
	    </div>
	    <div class="setContent" style="margin-top: 5px;">
	        <span>1、请确认协同系统的访问地址是公网地址，必须是备案过的域名，端口必须使用80或443（微信安全策略强制要求）</span>
	    </div>
	    <div class="setContent" style="margin-top: 5px;">
	        <span>2、请确认协同系统可以访问外网</span>
	    </div>
	</div>
	<div class="qrcode">
	    <div class="code"><img src="${path}/apps_res/weixin/img/qrcode.jpg" width="95%"></div>
	    <div class="detail">
	        <div class="title">
	            <span>致远微协同 服务号</span>
	        </div>
	        <div class="content">
	            <span>零成本、零实施、零维护，一键关注致远微协同服务号，绑定您的协同系统，即可立即体验移动办公“云”服务带来的简单易用！</span>
	        </div>
	        <div class="content">
	            <span>扫描二维码，或在微信公众号中搜索“致远微协同”，即刻体验全新的移动办公方式。</span>
	        </div>
	    </div>
	</div>
</body>
<script type="text/javascript">
    
</script>
</html>