<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>A82Other配置管理后台</title>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
     <!--[if lt IE 9]>
    <script src="/seeyon/apps_res/nbd/layui/html5.min.js"></script>
    <script src="/seeyon/apps_res/nbd/layui/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/seeyon/apps_res/nbd/vue/vue.min.js"></script>
</head>

<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
   
        <div id="a82other_create" class="nbd_content" style="padding:15px;">
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
                        <input type="text" v-model="name" name="name"  required lay-verify="required" placeholder="请输入名称"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">Other连接</label>
                    <div class="layui-input-block" style="width:300px">
                        <select v-model="sLinkId" id="a82other_data_link" name="linkId" lay-filter="sLinkId" lay-verify="required">
                               
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">传输方式</label>
                    <div class="layui-input-inline" style="width:300px">
                        <select v-model="exportType" name="exportType" lay-filter="exportType" lay-verify="required">
                            <option value="mid_table">中间表</option>
                            <option value="http">接口传输</option>
                            <option value="custom">自定义</option>
                            <!-- <option value="api">接口传输</option>
                                <option value="ws">WebService服务</option> -->

                        </select>
                    </div>
                    <div v-if="exportType=='http'" class="layui-input-inline" style="width:300px">
                            <input v-model="exportUrl" style="width:300px" type="text" name="exportUrl" required lay-verify="required" placeholder="接口地址"
                                   autocomplete="off" class="layui-input">
                        </div>
                        <div v-if="exportType=='custom'" class="layui-input-inline" style="width:300px">
                            <input v-model="extString3" style="width:300px" type="text" name="extString3" required lay-verify="required" placeholder="处理类"
                                   autocomplete="off" class="layui-input">
                        </div>
                    
                </div>
                <div v-if="exportType=='mid_table'" class="layui-form-item">
                        <label class="layui-form-label">存储方式</label>
                        <div class="layui-input-inline" style="width:300px">
                            <select v-model="extString1" name="extString1" lay-filter="extString1" lay-verify="required">
                                <option value="default">默认中间表(A8_TO_OTHER)</option>
                                <option value="custom">自定义表</option>
                                <!-- <option value="api">接口传输</option>
                                    <option value="ws">WebService服务</option> -->
                                    
                            </select>
                        </div>
                        <div v-if="exportType=='mid_table'&&extString1=='custom'" class="layui-input-inline" style="width:300px">
                                <input style="width:300px" type="text" v-model="extString2" name="extString2" required lay-verify="required" placeholder="自定义表名"
                                       autocomplete="off" class="layui-input">
                            </div>
                        <div class="layui-form-mid layui-word-aux">默认中间表表名为:A8_TO_OTHER</div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">触发方式</label>
                    <div class="layui-input-block" style="width:300px">
                        <select lay-filter="triggerType" name="triggerType" lay-verify="required">
                            <option value="process_start">流程开始</option>
                            <option value="process_end">流程结束</option>
                            <!-- <option value="api">接口传输</option>
                                                    <option value="ws">WebService服务</option> -->

                        </select>
                    </div>
                </div>
                
                <div class="layui-form-item">
                    <label class="layui-form-label">绑定A8表单模板编号</label>
                    <div class="layui-input-inline">
                        <select id="a82other_affair_type" name="affairType" lay-verify="required" lay-filter="affairType">
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
                    <button class="layui-btn"  v-if="mode=='create'" @click="createSubmit">立即提交</button>
                    <button class="layui-btn"  v-if="mode=='update'" @click="updateSubmit">立即提交</button>
                    <button class="layui-btn" @click="goBack">返回</button>

                </div>
            </div>
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
<script src="/seeyon/apps_res/nbd/app/a82other.js"></script>
</body>

</html>