<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>督办台账</title>
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

<div class="layui-container" style="width:50% !important;">
    <form id="task_submit_form">
    <!-- #bfbfbf -->
    <div class="layui-row">
        <div class="layui-col-md12">
    <table class="layui-table">

        <thead>
        <tr>
            <th style="width:250px">任务来源</th>
            <th style="width:250px">分数</th>
        </tr>
        </thead>
        <tbody id="task_source_body">

        </tbody>
    </table>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md12">
    <table class="layui-table">

        <thead>
        <tr>
            <th style="width:250px">任务分级</th>
            <th style="width:250px">相对系数</th>
        </tr>
        </thead>
        <tbody id="task_level_body">

        </tbody>
    </table>
        </div></div>
    <div class="layui-row">
        <div class="layui-col-md12">
    <table class="layui-table">

        <thead>
        <tr>
            <th style="width:250px">任务角色</th>
            <th style="width:250px">相对系数</th>
        </tr>
        </thead>
        <tbody id="task_role_body">

        </tbody>
    </table>
        </div>
    </div>
    </form>
    <div class="layui-row">
        <div class="layui-col-md12">
    <center><button id="task_score_config_btn" class="layui-btn layui-btn-normal" onclick="t_s_c_click()" type="button">保存</button></center>
        </div></div>
</div>


<script src="/seeyon/apps_res/duban/verdor/layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/score.js"></script>

</body>
</html>