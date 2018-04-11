<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/index.css"/>
</head>
<body class="h100b over_hidden">
<div class="frame-layout">
        <div class="left-layout">
            <div class="title">
                <i class="iconfont icon-WeChat title-icon">&#xe6af;</i>
                <span>致远微协同平台</span>
            </div>
            <div class="menu">
                <div class="menu-list"></div>
            </div>
        </div>
        <div class="right-layout">
            <iframe name="mainIframe" id="mainIframe" class="iframe-layout" width="100%" height="100%" style="border: none;" src="" frameBorder="0"></iframe>
        </div>
        <div style="clear: both;"></div>
    </div>
    <script src="${path}/apps_res/weixin/js/index.js"></script>
</body>
<script type="text/javascript">
var json = ${menus};
$().ready(function() {
    init();
    firstMenuCli(null,0,"/wechat/wechatSet.do?method=platformOverview","main");
});
function reloadIframe(){
    mainIframe.window.location.reload()
}
</script>
</html>