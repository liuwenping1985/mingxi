<%--
 $Author: wuym $
 $Rev: 1066 $
 $Date:: 2012-09-25 09:29:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>资源权限测试</title>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
资源权限控制定义：class="resCode" resCode="xxx"。class为resCode，resCode属性值为priv_resource表中的resource_code，
如果当前登录用户具有该资源权限则显示当前界面元素，否则隐藏。此规则对按钮、div或其它任何支持jQuery的hiden和show的元素均可。（注：开发模式不受此限制）<br/>
    <input class="resCode" resCode="samples_m1_btn1" type="button" value="按钮1">
<br>插件判定，class="resCode" pluginId="plugin_id"，class为resCode，pluginId属性值为插件id，如协同：collaboration。
pluginId和resCode可以混合使用，插件判定优先。<br>
    <input class="resCode" resCode="samples_m1_btn2" pluginId="samples" type="button" value="按钮2">
    <input class="resCode" pluginId="samples" type="button" value="按钮3">
</body>
</html>
