<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2016/12/23
  Time: 16:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>移动看板制作</title>
</head>
<script type="text/javascript">
    $(document).ready(function() {
        //初始化工具栏
        initToolbar();
        //初始化查询条件
        initSearch();
        //构建初始化列表
        initTable();
    });
</script>
<script type="text/javascript" src="${path}/common/form/bizDashboard/bizDashboardList.js${ctp:resSuffix()}"></script>
<body>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <!-- 面包屑 -->
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_bizDashboard'"></div>
    <!-- 按钮区 -->
    <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
        <div id="toolbar"></div>
    </div>
    <!-- 列表区 -->
    <div class="layout_center" id="center" style="overflow: hidden;">
        <table class="flexme3" style="display: none" id="mytable"></table>
        <div id='grid_detailxxx'>
            <iframe id="viewFrame" frameborder="0" src="${path }/form/bizDashboard.do?method=helpInfo&total=0"  style="width: 100%;height:100%;"></iframe>
        </div>
    </div>
</div>
</body>
</html>
