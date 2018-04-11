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
	    <div class="before">${ctp:i18n('weixin.system.menu.appIntegratedConfig')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.appWechatEnterprise')}</span>
	</div>
	<div class="set">
	    <div class="setContent" style="font-size: 14px;color: #000;">
	        <span>配置说明：</span>
	    </div>
	    <div class="setContent" style="margin-top: 17px;">
	        <span>1、请确认您的企业已经注册企业微信，并且已经通过“认证”</span>
	    </div>
	    <div class="setContent" style="margin-top: 5px;">
	        <span>2、请确认协同系统的访问地址是公网地址，必须是备案过的域名（微信安全策略强制要求）</span>
	    </div>
	    <div class="setContent" style="margin-top: 5px;">
	        <span>3、请确认协同系统可以访问外网</span>
	    </div>
	</div>
	<div class="wei-process">
	    <div class="firstStep">
	        <div class="blocks">
	            <div class="block">
	                <span style="margin-top: 25px;display: inline-block;">登录企业微信后台</span>
	            </div>
	            <div class="leftTag">
	                <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
	                    <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
	                </div>
	            </div>
	            <div class="block">
	                <span style="margin-top: 25px;display: inline-block;">安装微协同应用</span>
	            </div>
	            <div class="leftTag">
	                <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
	                    <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
	                </div>
	            </div>
	            <div class="block">
	                <span style="margin-top: 25px;display: inline-block;">授权使用范围</span>
	            </div>
	            <div style="clear: both;"></div>
	        </div>
	        <div class="content">
	            <span>登录企业微信操作</span>
	        </div>
	    </div>
	</div>
	<div class="wei-button">
	    <div class="install" style="cursor: pointer;">
	        <span>开始安装并授权</span>
	    </div>
	    <div class="goto">
	        <span>点击按钮进入企业微信</span>
	    </div>
	</div>
</body>
<script type="text/javascript">
$().ready(function(){
	$(".install").bind("click", function() {
		openCtpWindow({
			url:"http://weixin.seeyon.com/company2QRcode.jsp"
		})
	});
})
</script>
</html>