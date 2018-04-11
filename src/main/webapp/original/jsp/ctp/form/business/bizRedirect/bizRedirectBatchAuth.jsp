<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2017/6/22
  Time: 17:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>业务包导入批量授权</title>
</head>
<script type="text/javascript" src="${path}/common/form/bizconfig/bizRedirectBatchAuth.js${ctp:resSuffix()}"></script>
<script>
    var toolbarObj;//工具栏对象
    var searchObj;//查询组件对象
    var locationEnum = [];//位置枚举
    var authData = [];//授权信息
    var currentuser = "${CurrentUser.id}";
    $(document).ready(function() {
        <c:forEach items="${locationEnum}" var="location" varStatus="status">
            locationEnum[locationEnum.length] = {"value":"${location.key}","text":"${location.text}"};
        </c:forEach>
        initToolbar();
        initSearch();
        getAuthData();
        initAuthTable();
    });
</script>
<body>
<div id="data" class="hidden">
    <textarea id="authData" name="authData">${batchAuth}</textarea>
</div>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <!-- 按钮区 -->
    <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
        <div id="toolbar"></div>
    </div>
    <!-- 授权 -->
    <div class="layout_center" id="center" style="overflow: auto;padding-right: 3px;">
        <div id="authorization" style="width: 895px;">

        </div>
    </div>
</div>
</body>
</html>
