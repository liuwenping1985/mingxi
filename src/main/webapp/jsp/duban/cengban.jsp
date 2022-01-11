<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/vendor/layui/css/layui.css">
    <script type="text/javascript" src="/seeyon/apps_res/duban/vendor/layui/layui.js"></script>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/css/xad.css">
</head>
<body>

<table class="layui-hide" id="test" lay-filter="test"></table>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm xad_filter_btn layui-btn-normal" lay-event="getRunningTask" lay-data="duban">进行中</button>
        <button class="layui-btn layui-btn-sm xad_filter_btn " lay-event="getFinishedTask" lay-data="duban">已完成</button>
        <button class="layui-btn layui-btn-sm xad_filter_btn " lay-event="getAllTask" lay-data="duban" >全部事项</button>
        <button class="layui-btn layui-btn-sm" lay-event="searchAll"><i class="layui-icon">&#xe615;</i>查询</button>
       
    </div>
</script>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="openView">查看</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="feedback">汇报</a>
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="finish">办结</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delay">延期</a>
</script>

<script src="/seeyon/apps_res/duban/vendor//layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/DubanDao.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/cengban.js"></script>

</body>


</html>