<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/css/xad.css">
    <link rel="stylesheet" href="/seeyon/apps_res/duban/vendor/layui/css/layui.css">
    <script type="text/javascript" src="/seeyon/apps_res/duban/vendor/layui/layui.js"></script>
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
</script>
<script type="text/html" id="switchTpl">
    <!-- 这里的 checked 的状态只是演示 -->
    <input type="checkbox" name="sex" value="{{d.id}}" lay-skin="switch" lay-text="女|男" lay-filter="sexDemo" {{ d.id == 10003 ? 'checked' : '' }}>
</script>
<script src="/seeyon/apps_res/duban/vendor//layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/DubanDao.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/watcher.js"></script>

</body>


</html>