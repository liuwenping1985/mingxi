<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>A82Other配置管理后台</title>
    <!--[if lt IE 9]>
    <script src="/seeyon/apps_res/nbd/layui/html5.min.js"></script>
    <script src="/seeyon/apps_res/nbd/layui/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/seeyon/apps_res/nbd/vue/vue.min.js"></script>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
</head>

<body class="layui-layout-body">


<div id="link_create" class="nbd_content" style="padding: 15px;width:500px;">
<form class="layui-form" id="data_link_form"  action="" >
<div class="layui-form-item">
    <label class="layui-form-label">连接名称</label>
    <div class="layui-input-block">
        <input type="text" v-model="item.name" required lay-verify="required" placeholder="请输入名称"
               autocomplete="off" class="layui-input">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">连接地址</label>
    <div class="layui-input-inline">
        <input type="text" v-model="item.host"  required lay-verify="required" placeholder="请输入地址"
               autocomplete="off" class="layui-input">
    </div>
    <div class="layui-form-mid layui-word-aux">IP地址</div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">端口</label>
    <div class="layui-input-inline">
        <input type="text" v-model="item.port"   required lay-verify="required" placeholder="请输入端口"
               autocomplete="off" class="layui-input">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">数据库类型</label>
    <div class="layui-input-block">
        <select id="dbType" name="dbType" v-model="item.dbType" lay-verify="required">
            <option value="0">Mysql</option>
            <option value="1">Oracle</option>
            <option value="2">SQLServer</option>
        </select>
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">用户名</label>
    <div class="layui-input-inline">
        <input type="text" v-model="item.userName" required lay-verify="required" placeholder="请输入用户名"
               autocomplete="off" class="layui-input">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">密码</label>
    <div class="layui-input-block">
        <input type="password" v-model="item.password"  required lay-verify="required" autocomplete="off"
               class="layui-input">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">数据库名</label>
    <div class="layui-input-block">
        <input type="text" v-model="item.dataBaseName" required lay-verify="required" placeholder="请输入数据库名"
               autocomplete="off" class="layui-input">
    </div>
</div>

</form>
<div class="layui-form-item">
    <div class="layui-input-block">
        <button class="layui-btn" v-if="mode=='create'" @click="createSubmit">立即提交</button>
        <button class="layui-btn" v-if="mode=='update'" @click="updateSubmit">立即提交</button>
        <button class="layui-btn" @click="goBack">返回</button>
        <button class="layui-btn" @click="testConnection">连接测试</button>
    </div>
</div>

</div>

<script src="/seeyon/apps_res/nbd/layui/layui.all.js"></script>
<script>
    //JavaScript代码区域
    var $ = jQuery = layui.jquery;
    layui.use('element', function () {
        var element = layui.element;
    });
    window.$ = $;
    // window.layui = layui;
</script>
<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/app/dao.js"></script>
<script src="/seeyon/apps_res/nbd/app/datalink.js"></script>
</body>