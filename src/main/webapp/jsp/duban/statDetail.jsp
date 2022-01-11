<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>督办</title>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/verdor/layui/css/layui.css">
    <script type="text/javascript" src="/seeyon/apps_res/duban/verdor/layui/layui.js"></script>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/css/duban.css">
</head>
<style>


    .td_no_padding {
        padding: 3px 3px;
    }
</style>
<body style="background-color: white">

<div class="layui-container" style="width:98% !important;">
    <table class="layui-table">

        <thead>
        <tr>
            <th>状态</th>
            <th>任务名称</th>
            <th>任务来源</th>
            <th>任务级别</th>
            <th>办理时限</th>
            <th>周期</th>
            <th>进度</th>
            <th>责任领导</th>
            <th>承办部门</th>
            <th>分数</th>
            <th>最新汇报</th>
            <th>负责人</th>
          

        </tr>
        </thead>
        <tbody id="nakedBodyMore">

        </tbody>
    </table>



</div>


<script src="/seeyon/apps_res/duban/verdor/layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/DubanDao.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/statdetail.js"></script>


</body>
</html>