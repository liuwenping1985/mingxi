<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>DEE任务绑定</title>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_west" layout="width:200,minWidth:50,maxWidth:300">
        <div id="deeTree"></div>
    </div>
    <div class="layout_center" layout="border:false">
        <div id="toolbars"></div>
        <table id="deeTable" class="flexme3" style="display: none;"></table>
    </div>
</div>
<%@ include file="deeTaskTree.js.jsp" %>
</body>
</html>