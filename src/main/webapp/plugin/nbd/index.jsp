<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>A82Other好</title>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo">A82Other配置管理</div>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">
            <%--<li class="layui-nav-item"><a href="">配置管理</a></li>--%>
            <%--<li class="layui-nav-item"><a href="">商品管理</a></li>--%>
            <%--<li class="layui-nav-item"><a href="">用户</a></li>--%>
            <%--<li class="layui-nav-item">--%>
                <%--<a href="javascript:;">其它系统</a>--%>
                <%--<dl class="layui-nav-child">--%>
                    <%--<dd><a href="">邮件管理</a></dd>--%>
                    <%--<dd><a href="">消息管理</a></dd>--%>
                    <%--<dd><a href="">授权管理</a></dd>--%>
                <%--</dl>--%>
            <%--</li>--%>
        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item">
                <a href="javascript:;">
                    <img src="http://t.cn/RCzsdCq" class="layui-nav-img">
                    配置管理员
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="">基本资料</a></dd>
                    <dd><a href="">安全设置</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item"><a href="">退出</a></li>
        </ul>
    </div>

    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree"  lay-filter="test">
                <li data-name="template" class="layui-nav-item layui-nav-itemed">
                    <a class="" href="javascript:;">数据连接配置</a>
                    <dl class="layui-nav-child">
                        <dd><a id="config_list_btn" href="javascript:;">配置列表</a></dd>
                    
                    </dl>
                </li>
                <li data-name="app" class="layui-nav-item">
                    <a href="javascript:;">数据转化</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;">A82other</a></dd>
                        <dd><a href="javascript:;">Other2A8</a></dd>
                        <dd><a href="javascript:;">日志</a></dd>
                      
                      
                    </dl>
                </li>
               
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <div id="dash_bord" style="padding: 15px;">

                <span class="layui-breadcrumb">
                        <a href="">首页</a>
                        <a href="">运行概况</a>
                      </span>

        </div>
        <!-- 内容主体区域 -->
        <div id="link_config" style="padding: 15px;display:none">
            <span class="layui-breadcrumb">
                <a href="">首页</a>
                <a href="">数据连接配置</a>
                <a><cite>配置列表</cite></a>
              </span>
              <br>
              <br>
              <div class="layui-btn-group">
                <button class="layui-btn layui-btn-sm">新建</button>
                <button class="layui-btn layui-btn-normal layui-btn-sm">编辑</button>
                <button class="layui-btn layui-btn-danger layui-btn-sm">删除</button>
              </div>
              <fieldset class="layui-elem-field">
                <legend>配置列表</legend>
                <div class="layui-field-box">
                  内容区域
                </div>
              </fieldset>

        </div>
        <div id="a82other" style="padding:15px;display:none">
            <span class="layui-breadcrumb">
                <a href="">首页</a>
                <a href="">数据转换</a>
                <a><cite>A82other</cite></a>
              </span>

        </div>

        <div id="other2a8" style="padding:15px;display:none">
            <span class="layui-breadcrumb">
                <a href="">首页</a>
                <a href="">数据转换</a>
                <a><cite>Other2A8</cite></a>
              </span>

        </div>
    </div>

    <div class="layui-footer">
        <!-- 底部固定区域 -->
        共能配置使用5张表单，已使用0张
    </div>
</div>
<script src="/seeyon/apps_res/nbd/layui/layui.all.js"></script>
<script>
    //JavaScript代码区域
    var $ =jQuery =layui.jquery;
    layui.use('element', function(){
        var element = layui.element;

    });
    layui.use('layer', function(){
        var layer = layui.layer;
  
        //layer.msg('hello');
    });  
    $("#config_list_btn").click(function(){
        alert("btn_click");

    });
</script>
</body>
</html>