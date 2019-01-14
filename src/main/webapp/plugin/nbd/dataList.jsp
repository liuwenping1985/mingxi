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
<div id="dataList" class="nbd_content" style="padding:15px;display:none">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">{{dataType}}</a>
                    <a><cite>{{dataName}}</cite></a>
                </span>
    <br>
    <br>
    <div class="layui-btn-group">
        <button @click="createItem" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe654;</i>新建</button>
        <button @click="updateItem" class="layui-btn layui-btn-normal layui-btn-sm"><i class='layui-icon'>&#xe642;</i>编辑</button>
        <button @click="deleteItem" class="layui-btn layui-btn-danger layui-btn-sm"><i class="layui-icon">&#xe640;</i>删除</button>
    </div>
    <fieldset class="layui-elem-field">
        <legend>{{legendName}}</legend>
        <div class="layui-field-box">
            <table class="layui-table">

                <thead>
                <tr>
                    <th v-for="column in columns">{{column.name}}</th>
                </tr>
                </thead>
                <tbody>
                    <tr v-for="(item,dataIndex) in items">
                        <td v-for="key in keys">
                            <button class="layui-btn layui-btn-sm" value="" v-if="key.name == 'op'" @click="onQuery(dataIndex)" >在线查询</button>
                            <span v-if="key.name == 'id'"><input type="checkbox" value="" @click="onSelected(dataIndex)" ></span>
                            <span v-else-if="key.render!=undefined">{{key.render(item[key.name])}}</span>
                            <span v-else>{{item[key.name]}}</span>
                        </td>
                    </tr>

                </tbody>
            </table>

        </div>
    </fieldset>
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
<script src="/seeyon/apps_res/nbd/app/dataList.js"></script>
</body>

</html>