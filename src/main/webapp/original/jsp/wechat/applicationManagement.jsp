<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
	<link rel="stylesheet" href="${path}/apps_res/weixin/css/wechatApp.css"/>
</head>
<body class="h100b" style="overflow-y: auto;">
	<div class="crumbly">
		<span class="current">${ctp:i18n('weixin.system.menu.applicationManagement')}</span>
	</div>
	<div id="AppManage">
	    <div>
	        <div class="choosing">
	            <div class="cNav">
	                <div class="appTab standard active">
	                    <span>${ctp:i18n("weixin.app.label.standard")}</span>
	                </div>
	                <div class="fast appTab fastCut">
	                    <span>${ctp:i18n("weixin.app.label.shortCut")}</span>
	                </div>
	                <div style="clear: both;"></div>
	            </div>
	            <div class="appContent standard">
	                <div class="chooseAll">
	                    <input type="checkbox" style="display:none;"><i class="iconCheckbox iconfont">&#xe6ba;</i><span>${ctp:i18n("weixin.app.label.checkAll")}</span>
	                </div>
	                <div class="allLogo"></div>
	            </div>
	            <div class="appContent fastCut hidden">
					<div class="chooseAll">
						<input type="checkbox" style="display:none;"><i class="iconCheckbox iconfont">&#xe6ba;</i><span>${ctp:i18n("weixin.app.label.checkAll")}</span>
					</div>
					<div class="allLogo"></div>
				</div>
	        </div>
	        <div class="cTag">
	            <div class="cLeft">
	                <span class="iconfont icon-right">&#xe6b9;</span>
	            </div>
	            <div class="cRight">
					<span class="iconfont icon-left">&#xe6b8;</span>
	            </div>
	        </div>
	        <div class="choosed">
	            <div class="cNav">
	                <span>${ctp:i18n("weixin.app.label.selected")}</span>
	            </div>
	            <div class="appContent">
					<div class="banner-container">
						<div class="bannerBottom">
							<img src="${path}/apps_res/weixin/img/IMG_5053.png"/>
						</div>
						<div class="banner"></div>
						<div class="banner-upload">
							<a id="uploadBtn" href="javascript:void(0)" class="common_button common_button_emphasize">${ctp:i18n("weixin.app.label.editImage")}</a>
						</div>
					</div>
					<div class="banner-tips">
						<span>${ctp:i18n("weixin.app.label.suggestedSize")}</span>
					</div>
	                <div class="chooseAll">
						<input type="checkbox" style="display:none;"><i class="iconCheckbox iconfont">&#xe6ba;</i><span>${ctp:i18n("weixin.app.label.checkAll")}</span>
	                </div>
					<div class="allLogo"></div>
	            </div>
	        </div>
	        <div style="clear: both;"></div>
	    </div>
	    <div>
	        <div class="abtns">
	            <div class="submit">
	                <span>${ctp:i18n("weixin.app.label.confirm")}</span>
	            </div>
	            <div class="cancel">
	                <span>${ctp:i18n("weixin.app.label.cancel")}</span>
	            </div>
	            <div style="clear: both;"></div>
	        </div>
	    </div>
	</div>

	<%--模版--%>
	<script type="text/html" id="appItemTpl">
		{{# for(var i = 0;i < d.length;i++){ }}
		{{# var item = d[i]; }}
		<div id="app_{{= item.appId }}" class="logoBlock">
			<div class="logoBack" style="background-color: {{= wechatApp.getAppBgColor(item.appId)}}">
				<i class="iconfont">{{= wechatApp.getIconUnicode(item.appId) }}</i>
				<div class="appChoose">
					<i class="iconfont icon-check-the-number">&#xe6d3;</i>
				</div>
			</div>
			<div class="name">
				<span>{{= wechatApp.getAppName(item.appId) }}</span>
			</div>
		</div>
		{{# } }}
	</script>
</body>
<script type="text/javascript" src="${path}/apps_res/weixin/js/jquery-ui-sortable.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/weixin/js/jquery.slide.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/weixin/js/wechatApp.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/weixin/js/wechatBanner.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(function(){
		wechatApp.init();
		wechatBanner.init();
    })
</script>
</html>