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
    <span class="current">${ctp:i18n('weixin.system.menu.appIntegratedConfig')}</span>
</div>
<div class="wei-server">
    <div class="name">
        <span>微信服务号</span>
    </div>
    <div class="firstStep">
        <div class="blocks">
            <div class="block">
                <span style="margin-top: 25px;display: inline-block;">无需配置，关注即可使用</span>
            </div>
            <div style="clear: both;"></div>
        </div>
    </div>
    <div style="clear: both;"></div>
</div>
<div class="wei-qiye-process">
    <div class="name">
        <span>企业微信</span>
    </div>
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
    <div style="clear: both;"></div>
</div>
<div class="process">
    <div class="name">
        <span>钉钉</span>
    </div>
    <div class="firstStep">
        <div class="blocks">
            <div class="block">
                <span style="margin-top: 25px;display: inline-block;">登录钉钉后台</span>
            </div>
            <div class="leftTag">
                <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
                    <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
                </div>
            </div>
            <div class="block">
                <span style="margin-top: 15px;display: inline-block;">获取企业账号信息</span><br>
                <span>（CorpID，CorpSecret）</span>
            </div>
            <div class="leftTag">
                <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
                    <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
                </div>
            </div>
            <div class="block">
                <span style="margin-top: 15px;display: inline-block;">新建微协同应用</span><br>
                <span>（获取AgentID）</span>
            </div>
            <div style="clear: both;"></div>
        </div>
        <div class="content">
            <span>步骤一：登录钉钉操作</span>
        </div>
    </div>
    <div class="secondStep">
        <div style="position: absolute;left: -26px;top: 10px;">
            <div class="leftTag">
                <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
                    <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
                </div>
            </div>
        </div>
        <div class="blocks">
            <div class="block">
                <span style="margin-top: 25px;display: inline-block;">绑定</span>
            </div>
        </div>
        <div class="content">
            <span>步骤二：绑定</span>
        </div>
    </div>
    <div style="clear: both;"></div>
</div>
</body>
<script type="text/javascript">
    
</script>
</html>