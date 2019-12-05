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
<body style="background-color: white">
<input type="hidden" id="havingLeaderTask" value="${havingLeaderTask}"/>
<div class="layui-container" style="width:98% !important;">

    <div class="layui-row">
        <div class="layui-col-md6">
            <h1 class="site-h1">工作任务台账</h1>
        </div>
        <div class="layui-col-md6">
            <div class="layui-row site-h1">
                <div class="layui-col-md3">
                    <button type="button" class="layui-btn layui-btn-normal">已完成任务</button>
                </div>
                <div class="layui-col-md3">
                    <button type="button" class="layui-btn layui-btn-normal">全部任务</button>
                </div>
                <div class="layui-col-md6">
                    <button type="button" class="layui-btn layui-btn-normal">查询搜索</button>
                </div>


            </div>
        </div>
    </div>
    <div class="layui-row" style="min-height: 300px">
        <div class="layui-col-md1">

            <div class="layui-row">
                <div class="layui-col-md12">
                    <button id="myduban" type="button" class="layui-btn layui-btn-normal">我的督办</button>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12" style="height:30px">

                </div>
            </div>
            <div class="layui-row">

                <div class="layui-col-md12">
                    <button id="mycengban" type="button" class="layui-btn layui-btn-normal">我的承办</button>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12" style="height:30px">

                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12">
                    <button id="myxieban" type="button" class="layui-btn layui-btn-normal">我的协办</button>
                </div>
            </div>
        </div>
        <div class="layui-col-md11">
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
                    <th>权重</th>
                    <th>负责人</th>
                    <th>操作</th>

                </tr>
                </thead>
                <tbody id="nakedBody">

                </tbody>
            </table>
        </div>
    </div>

    <div class="layui-row">
        <div class="layui-col-md6">
            <div style="height:1px;width:1px"></div>
        </div>

        <div class="layui-col-md6">
            <div id="paging" style="float:right"></div>
        </div>
    </div>
</div>
<script src="/seeyon/apps_res/duban/verdor/layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/duban.js"></script>

</body>
</html>