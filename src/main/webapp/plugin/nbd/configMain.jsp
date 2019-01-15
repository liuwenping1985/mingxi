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
<div class="layui-layout layui-layout-admin">

    <div class="layui-header">
        <div class="layui-logo">A82Other配置管理</div>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">

        </ul>
        <ul id="pageHeader" class="layui-nav layui-layout-right">
            <li class="layui-nav-item">
                <a href="javascript:;">
                    <img src="http://t.cn/RCzsdCq" class="layui-nav-img">
                    {{userName}}
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="">基本资料</a></dd>
                    <dd><a href="">安全设置</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item"><a href="">退出</a></li>
        </ul>
    </div>
    <div id="pageNav" class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree"  lay-filter="test">
                <li data-name="template" class="layui-nav-item layui-nav-itemed">
                    <a class="" href="javascript:;">数据连接配置</a>
                    <dl class="layui-nav-child">
                        <dd class="layui-this"><a id="config_list_btn"  href="javascript:;">配置列表</a></dd>

                    </dl>
                </li>
                <li data-name="app" class="layui-nav-item layui-nav-itemed">
                    <a href="javascript:;">数据转化</a>
                    <dl class="layui-nav-child">
                        <dd><a id="a82other_list_btn" href="javascript:;">A82other</a></dd>
                        <dd><a id="other2a8_list_btn" href="javascript:;">Other2A8</a></dd>
                        <dd><a id="log_list_btn" href="javascript:;">日志</a></dd>


                    </dl>
                </li>

            </ul>
        </div>
    </div>
    <div class="layui-body">
        <iframe id="pageLayout" frameborder="0" height="100%" width="100%" src="/seeyon/nbd.do?method=goPage&page=dataList&data_type=data_link"></iframe>
    </div>

    <div class="layui-footer">
        <!-- 底部固定区域 -->
        共能配置使用5张表单，已使用0张
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
<script src="/seeyon/apps_res/nbd/app/main.js"></script>
<script>
        Dao.getTemplateNumber({}, function (data) {
          
                //init cache do not deleted!!!!!!!!!
        });

        function reinitIframe(){
var iframe = document.getElementById("pageLayout");
try{
var bHeight = iframe.contentWindow.document.body.scrollHeight;
var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
var height = Math.max(bHeight, dHeight);
iframe.height = height;
//console.log(height);
}catch (ex){}
}
window.setInterval("reinitIframe()", 500);
</script>
</body>

</html>