<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>A82Other配置管理后台-DBCONSOLE</title>
    <!--[if lt IE 9]>
    <script src="/seeyon/apps_res/nbd/layui/html5.min.js"></script>
    <script src="/seeyon/apps_res/nbd/layui/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/seeyon/apps_res/nbd/vue/vue.min.js"></script>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
</head>

<body class="layui-layout-body">

    <div class="layui-row" id="sql_console">

        <div class="layui-col-md12" style="padding:20px;">
            <div class="layui-form-item">
                <input type="hidden" class="sql_data_link_id" />
                <div class="layui-input-block">
                    <textarea v-model="sqlInput" placeholder="输入SQL语句,一次一条" class="sql_input layui-textarea"></textarea>
                </div>
            </div>
            <button @click="onQuery" style="margin:0 auto" class="sql_btn layui-btn layui-btn-danger layui-btn-sm" />执行</button>

            <div class="sql_result" style="width:100%;min-height:300px">
                <table class="layui-table">
                       <thead><tr>
                            <th v-for="column in sqlColumns">{{column}}</th>
                       </tr>
                    </thead>
                    <tbody>
                            <tr v-for="(item,dataIndex) in sqlResult">
                                <td v-for="key in sqlColumns">
                                    <span>{{item[key]}}</span>
                                </td>
                            </tr>
        
                        </tbody>

                </table>

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
<script src="/seeyon/apps_res/nbd/app/dbconsole.js"></script>
</body>

</html>