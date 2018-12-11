<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>A82Other配置管理后台</title>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
</head>

<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo">A82Other配置管理</div>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">

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
            <ul class="layui-nav layui-nav-tree" lay-filter="test">
                <li data-name="template" class="layui-nav-item layui-nav-itemed">
                    <a class="" href="javascript:;">数据连接配置</a>
                    <dl class="layui-nav-child">
                        <dd><a id="config_list_btn" href="javascript:;">配置列表</a></dd>

                    </dl>
                </li>
                <li data-name="app" class="layui-nav-item">
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
        <div class="nbd_content" id="dash_bord" style="padding: 15px;display:none">

                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">运行概况</a>
                </span>

        </div>
        <!-- 内容主体区域 -->
        <div id="link_config" class="nbd_content" style="padding: 15px">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">数据连接配置</a>
                    <a><cite>配置列表</cite></a>
                </span>
            <br>
            <br>
            <div class="layui-btn-group">
                <button id="data_link_create" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe654;</i>新建</button>
                <button id="data_link_update" class="layui-btn layui-btn-normal layui-btn-sm"><i class='layui-icon'>&#xe642;</i>编辑</button>
                <button id="data_link_delete" class="layui-btn layui-btn-danger layui-btn-sm"><i class="layui-icon">&#xe640;</i>删除</button>
            </div>
            <fieldset class="layui-elem-field">
                <legend>配置列表</legend>
                <div class="layui-field-box">
                    <table class="layui-table">
                        <colgroup>
                            <col width="40">
                            <col width="150">
                            <col width="200">
                            <col width="150">
                            <col width="150">
                            <col width="200">
                            <col width="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th></th>
                            <th>连接名称</th>
                            <th>地址</th>
                            <th>端口</th>
                            <th>数据类型</th>
                            <th>用户名</th>
                            <th>数据库名</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody id="data_link_list_body">

                        </tbody>
                    </table>

                </div>
            </fieldset>

        </div>

        <div id="link_create" class="nbd_content" style="padding: 15px;width:500px;display:none">
            <form class="layui-form" id="data_link_form" action="">
                <div class="layui-form-item">
                    <label class="layui-form-label">连接名称</label>
                    <div class="layui-input-block">
                        <input type="text" name="extString1" required lay-verify="required" placeholder="请输入名称"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">连接地址</label>
                    <div class="layui-input-inline">
                        <input type="text" name="host" required lay-verify="required" placeholder="请输入地址"
                               autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">IP地址</div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">端口</label>
                    <div class="layui-input-inline">
                        <input type="text" name="extString2" required lay-verify="required" placeholder="请输入端口"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">数据库类型</label>
                    <div class="layui-input-block">
                        <select name="dbType" lay-verify="required">
                            <option value="0">Mysql</option>
                            <option value="1">Oracle</option>
                            <option value="2">SQLServer</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <input type="hidden" name="id" value />
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="user" required lay-verify="required" placeholder="请输入用户名"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">密码</label>
                    <div class="layui-input-block">
                        <input type="password" name="password" required lay-verify="required" autocomplete="off"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">数据库名</label>
                    <div class="layui-input-block">
                        <input type="text" name="dataBaseName" required lay-verify="required" placeholder="请输入数据库名"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>

            </form>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" id="data_link_submit">立即提交</button>
                    <button class="layui-btn" style="display:none" id="data_link_update_submit">立即提交</button>
                    <button class="layui-btn" id="data_link_return">返回</button>
                    <button class="layui-btn" id="data_link_test">连接测试</button>
                </div>
            </div>

        </div>
        <!-- 需要弹出的添加员工界面 -->
        <div class="layui-row" id="sql_console" style="display: none;">

            <div class="layui-col-md10" style="padding:20px;">
                <div class="layui-form-item">
                    <input type="hidden" class="sql_data_link_id" />
                    <div class="layui-input-block">
                        <textarea placeholder="输入SQL语句,一次一条，语句最后不要加;号" class="sql_input layui-textarea"></textarea>
                    </div>
                </div>
                <button class="sql_btn layui-btn layui-btn-danger layui-btn-sm" />执行</button>

                <div class="sql_result" style="width:100%;min-height:300px">


                </div>


            </div>
        </div>

        <div id="a8ToOtherConfigEntity" class="nbd_content" style="padding:15px;display:none">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">数据转换</a>
                    <a><cite>A82other</cite></a>
                </span>
            <br>
            <br>
            <div class="layui-btn-group">
                <button id="a82other_btn_create" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe654;</i>新建</button>
                <button id="a82other_btn_update" class="layui-btn layui-btn-normal layui-btn-sm"><i class='layui-icon'>&#xe642;</i>编辑</button>
                <button id="a82other_btn_delete" class="layui-btn layui-btn-danger layui-btn-sm"><i class="layui-icon">&#xe640;</i>删除</button>
            </div>
            <fieldset class="layui-elem-field">
                <legend>表单对接列表</legend>
                <div class="layui-field-box">
                    <table class="layui-table">
                        <colgroup>
                            <col width="40">
                            <col width="150">
                            <col width="200">
                            <col width="150">
                            <col width="150">

                            <col width="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th></th>
                            <th>名称</th>
                            <th>Other连接</th>
                            <th>传输方式</th>
                            <th>触发方式</th>
                            <th>表单模板编号</th>

                        </tr>
                        </thead>
                        <tbody id="a82other_list_body">

                        </tbody>
                    </table>

                </div>
            </fieldset>
        </div>
        <div id="a82other_create" class="nbd_content" style="padding:15px;display:none">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">数据转换</a>
                    <a><cite>A82other</cite></a>
                </span>
            <br><br>
            <form class="layui-form" id="a82other_form" action="">
                <div class="layui-form-item">
                    <label class="layui-form-label">名称</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" name="name" required lay-verify="required" placeholder="请输入名称"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">Other连接</label>
                    <div class="layui-input-block" style="width:300px">
                        <select id="a82other_data_link" name="linkId" lay-verify="required">


                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">传输方式</label>
                    <div class="layui-input-inline" style="width:300px">
                        <select name="exportType" lay-verify="required">
                            <option value="mid_table">中间表</option>
                            <option value="http">接口传输</option>
                            <option value="custom">自定义</option>
                            <!-- <option value="api">接口传输</option>
                                <option value="ws">WebService服务</option> -->

                        </select>
                    </div>
                    <div class="layui-form-mid layui-word-aux">
                        <input type="text" name="exportUrl" required lay-verify="required" placeholder="导出处理配置"
                                                                       autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">默认中间表:A8_TO_OTHER</div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">触发方式</label>
                    <div class="layui-input-block" style="width:300px">
                        <select name="triggerType" lay-verify="required">
                            <option value="process_start">流程开始</option>
                            <option value="process_end">流程结束</option>
                            <!-- <option value="api">接口传输</option>
                                                    <option value="ws">WebService服务</option> -->

                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">A8表单模板编号</label>
                    <div class="layui-input-inline">
                        <select id="a82other_affair_type" name="affairType" lay-verify="required" lay-filter="affairTypeSelect">
                            <!-- <option value="api">接口传输</option>
                            <option value="ws">WebService服务</option> -->

                        </select>

                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline" style="width:88%">
                        <fieldset class="layui-elem-field">
                            <legend>表单字段映射</legend>
                            <div>
                                <div style="width:100%;margin-left:30px">
                                    <div style="color:red">
                                        <p style="font-weight:bold">注意:</p>
                                        <p>1、"other字段"不填写时如果传输将按照字段名称映射，例如“field0001:张三”将原样映射为“field0001:张三”。</p>
                                        <p>2、是否传输选择为"否"时改字段将不会被映射。</p>
                                        <p>3、数据类型为"子表"时，由于一个主表数据可能会对应多个主表数据，所以会映射为数组方式。</p>
                                    </div>

                                </div>
                            </div>
                            <div class="layui-field-box">
                                <table class="layui-table">
                                    <colgroup>
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">

                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>字段</th>
                                        <th>字段显示名称</th>
                                        <th>字段类型</th>
                                        <th>数据类型(主表/子表)</th>
                                        <th>是否传输</th>
                                        <th>转换方式</th>
                                        <th>other字段</th>


                                    </tr>
                                    </thead>
                                    <tbody id="a82other_field_list_body">

                                    </tbody>
                                </table>

                            </div>
                        </fieldset>
                    </div>
                </div>


            </form>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" id="a82other_submit">立即提交</button>
                    <button class="layui-btn" style="display:none" id="a82other_update_submit">立即提交</button>
                    <button class="layui-btn" id="a82other_return">返回</button>

                </div>
            </div>
        </div>
        <div id="other2a8" class="nbd_content" style="padding:15px;display:none">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">数据转换</a>
                    <a><cite>Other2A8</cite></a>
                </span>
            <br>
            <br>
            <div class="layui-btn-group">
                <button id="other2a8_btn_create" class="layui-btn layui-btn-sm">新建</button>
                <button id="other2a8_btn_update" class="layui-btn layui-btn-normal layui-btn-sm">编辑</button>
                <button id="other2a8_btn_delete" class="layui-btn layui-btn-danger layui-btn-sm">删除</button>
            </div>
            <fieldset class="layui-elem-field">
                <legend>表单对接列表</legend>
                <div class="layui-field-box">
                    <table class="layui-table">
                        <colgroup>
                            <col width="40">
                            <col width="150">
                            <col width="200">
                            <col width="150">
                            <col width="150">

                            <col width="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th></th>
                            <th>表单名称</th>
                            <th>触发机制</th>
                            <th>数据连接</th>
                            <th>数据对接方式</th>
                            <th>表单模板编号</th>

                        </tr>
                        </thead>
                        <tbody id="a82other_list_body">

                        </tbody>
                    </table>

                </div>
            </fieldset>
        </div>
        <div id="other2a8_create" class="nbd_content" style="padding:15px;display:none">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">数据转换</a>
                    <a><cite>Other2A8</cite></a>
                </span>
            <br><br>
            <form class="layui-form" id="other2a8_form" action="">
                <div class="layui-form-item">
                    <label class="layui-form-label">名称</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" name="name" required lay-verify="required" placeholder="请输入名称"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">Other连接</label>
                    <div class="layui-input-block" style="width:300px">
                        <select id="other2a8_data_link" name="linkId" lay-verify="required">


                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">传输方式</label>
                    <div class="layui-input-inline" style="width:300px">
                        <select name="exportType" lay-verify="required">
                            <option value="mid_table">中间表</option>
                            <!-- <option value="api">接口传输</option>
                                                <option value="ws">WebService服务</option> -->

                        </select>
                    </div>

                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">中间表名称</label>
                    <div class="layui-input-inline" style="width:300px">
                        <input type="text" name="tableName" required lay-verify="required" placeholder="请输入中间表名称"
                               autocomplete="off" class="layui-input">
                    </div>

                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">获取方式</label>
                    <div class="layui-input-block" style="width:300px">
                        <select name="triggerType" lay-verify="required">
                            <option value="schedule">定时</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">定时时间(秒)</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" name="period" required lay-verify="required" placeholder="定时时间（单位秒）"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">是否触发流程</label>
                    <div class="layui-input-block" style="width:300px">
                        <select name="triggerType" lay-verify="required">
                            <option value="1">是</option>
                            <option value="0">否</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">A8表单模板编号</label>
                    <div class="layui-input-inline">
                        <select id="other2a8_affair_type" name="affairType" lay-verify="required" lay-filter="affairTypeSelect">
                            <!-- <option value="api">接口传输</option>
                                            <option value="ws">WebService服务</option> -->

                        </select>

                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline" style="width:88%">
                        <fieldset class="layui-elem-field">
                            <legend>表单字段映射</legend>
                            <div>
                                <!-- <div style="width:100%;margin-left:30px">
                                    <div style="color:red">
                                        <p style="font-weight:bold">注意:</p>
                                        <p>1、"other字段"不填写时如果传输将按照字段名称映射，例如“field0001:张三”将原样映射为“field0001:张三”。</p>
                                        <p>2、是否传输选择为"否"时改字段将不会被映射。</p>
                                        <p>3、数据类型为"子表"时，由于一个主表数据可能会对应多个主表数据，所以会映射为数组方式。</p>
                                    </div>

                                </div> -->
                            </div>
                            <div class="layui-field-box">
                                <table class="layui-table">
                                    <colgroup>
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">
                                        <col width="">

                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>字段</th>
                                        <th>字段显示名称</th>
                                        <th>字段类型</th>
                                        <th>数据类型(主表/子表)</th>
                                        <th>是否传输</th>
                                        <th>转换方式</th>
                                        <th>other字段</th>


                                    </tr>
                                    </thead>
                                    <tbody id="other2a8_field_list_body">

                                    </tbody>
                                </table>

                            </div>
                        </fieldset>
                    </div>
                </div>


            </form>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" id="other2a8_submit">立即提交</button>
                    <button class="layui-btn" style="display:none" id="other2a8_update_submit">立即提交</button>
                    <button class="layui-btn" id="other2a8_return">返回</button>

                </div>
            </div>
        </div>
        <div id="log" class="nbd_content" style="padding:15px;display:none">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a><cite>日志</cite></a>
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
    var $ = jQuery = layui.jquery;
    layui.use('element', function () {
        var element = layui.element;
    });
    window.$ = $;
    // window.layui = layui;
</script>
<script src="/seeyon/apps_res/nbd/layui/apps/app.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/nav.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/data_link.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/a8ToOtherConfigEntity.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/other2a8.js"></script>
<script>
    //Demo
    // layui.use('form', function () {
    //     var form = layui.form;
    //     //监听提交
    //     form.on('submit(formDemo)', function (data) {
    //         layer.msg(JSON.stringify(data.field));
    //         Dao.add("data_link",data,function(ret){
    //             console.log(ret);
    //             // Dao.getList("data_link",function(ret){
    //             //     $(".nbd_content").hide();
    //             //     $("#link_config").show();
    //             //     DataLink.renderList(ret);
    //             // });
    //         })
    //         return false;
    //     });
    // });
</script>
<script>
    $(document).ready(function () {
        Dao.getList("data_link", function (ret) {
            $(".nbd_content").hide();
            $("#link_config").show();
            DataLink.renderList(ret);
        });
        Dao.getTemplateNumber({}, function (data) {
            if (data && data.result && data.items) {
                var items = data.items;
                A82OTHER.TN = items;
                $(items).each(function (index, item) {
                    var nno = item.templete_number;
                    if (nno) {
                        $("#a82other_affair_type").append("<option value='" + nno + "'>" +
                            nno + "(" + item.subject + ")</option>");
                        $("#other2a8_affair_type").append("<option value='" + nno + "'>" +
                            nno + "(" + item.subject + ")</option>");
                    }
                    layui.use('form', function () {
                        var form = layui.form; //高版本建议把括号去掉，有的低版本，需要加()
                        form.render();
                    });
                });

            }

        });
    });
</script>
</body>

</html>