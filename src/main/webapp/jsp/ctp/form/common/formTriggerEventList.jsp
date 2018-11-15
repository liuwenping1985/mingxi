<%--
  Created by IntelliJ IDEA.
  User: yangz
  Date: 2017/5/3
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="common.js.jsp" %>
<html>
<head>
    <title>表单待触发列表</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formTriggerManager"></script>
    <script type="text/javascript" src="${path}/common/form/common/formTriggerEventList.js${ctp:resSuffix()}"></script>
</head>
<body>
<div>
    <!-- 面包屑 -->
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_showTriggerList'"></div>
    <div id="toolbar" style="height: 35px;">
        <div id="toolbarArea">
        </div>
    </div>
    <div id="listContent">
        <table id="mytable"></table>
    </div>
</div>
</body>
</html>
