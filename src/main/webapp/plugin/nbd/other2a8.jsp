<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>other2a8配置管理后台</title>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
     <!--[if lt IE 9]>
    <script src="/seeyon/apps_res/nbd/layui/html5.min.js"></script>
    <script src="/seeyon/apps_res/nbd/layui/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/seeyon/apps_res/nbd/vue/vue.min.js"></script>
</head>

<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
   
        <div id="other2a8_create" class="nbd_content" style="padding:15px;">
                <span class="layui-breadcrumb">
                    <a href="">首页</a>
                    <a href="">数据转换</a>
                    <a><cite>Other2a8</cite></a>
                </span>
            <br><br>
            <form class="layui-form" id="other2a8_form" action="">
                <div class="layui-form-item">
                    <label class="layui-form-label">名称</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" v-model="name" name="name"  required lay-verify="required" placeholder="请输入名称"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">获取方式</label>
                    <div class="layui-input-block" style="width:300px">
                        <select v-model="exportType" lay-filter="exportType" name="exportType" lay-verify="required">
                            <option value="schedule">定时从数据库获取</option>
                            <option value="api_receive">外部调用A8接口传入</option>
                            <option value="api_get">A8调用外部接口获取</option>
                        </select>
                    </div>
                    <div v-if="exportType=='api_receive'" class="layui-form-mid layui-word-aux">外部调用接口地址【POST】/seeyon/form/receive.do</div>
                </div>
                <div v-show="exportType=='api_receive'&&extString2!='form'" class="layui-form-item">
                    <label class="layui-form-label">业务标识</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" v-model="extString5" name="extString5"  required lay-verify="required" placeholder="请输入表名（other端）"
                               autocomplete="off" class="layui-input">
                    </div>
                    <div v-if="exportType=='api_receive'" class="layui-form-mid layui-word-aux">必填，字段为affairType</div>
               
                </div>
                <div v-show="exportType=='schedule'" class="layui-form-item">
                    <label class="layui-form-label">Other连接</label>
                    <div class="layui-input-block" style="width:300px">
                        <select v-show="exportType=='schedule'" v-model="sLinkId" id="other2a8_data_link" name="linkId" lay-filter="sLinkId" lay-verify="required">
                               
                        </select>
                    </div>
                </div>

                <div v-if="exportType=='schedule'"  class="layui-form-item">
                    <label class="layui-form-label">other表名</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" v-model="extString1" name="extString1"  required lay-verify="required" placeholder="请输入表名（other端）"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div v-if="exportType=='api_get'"  class="layui-form-item">
                    <label class="layui-form-label">调用地址</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" v-model="exportUrl" name="exportUrl"  required lay-verify="required" placeholder="调用地址"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div v-if="exportType=='schedule'||exportType=='api_get'"  class="layui-form-item">
                    <label v-if="exportType=='schedule'" class="layui-form-label">获取周期</label>
                    <label v-if="exportType=='api_get'" class="layui-form-label">调用周期</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" v-model="period" name="period"  required lay-verify="required" placeholder="请输入调用周期（秒）,不填只调用一次"
                               autocomplete="off" class="layui-input">
                    </div>
                </div>
                
                
                
                <div class="layui-form-item">
                    <label class="layui-form-label">唯一主键</label>
                    <div class="layui-input-block" style="width:300px">
                        <input type="text" v-model="extString3" name="extString3"    placeholder="唯一主键"
                               autocomplete="off" class="layui-input">
                               <div  class="layui-form-mid layui-word-aux">不设置均为全量新增</div>
                    </div>
                   
             
                </div>
               
                <div class="layui-form-item">
                    <label class="layui-form-label">A8存储类型</label>
                    <div class="layui-input-block" style="width:300px">
                        <select lay-filter="extString2" v-model="extString2" name="extString2" lay-verify="required">
                            <option value="normal">普通表</option>
                            <option value="formmain">底表</option>
                            <option value="form">表单</option>
                            <!-- <option value="api">接口传输</option>
                                                    <option value="ws">WebService服务</option> -->

                        </select>
                    </div>
                </div>
                <div v-show="extString2 !='form'"  class="layui-form-item">
                    <label v-if="extString2 =='normal'" class="layui-form-label">普通表表名</label>
                    <label v-if="extString2 =='formmain'" class="layui-form-label">底表表名</label>
                    <div class="layui-input-inline" style="width:300px">
                        <input type="text" v-model="extString4" name="extString4"  required lay-verify="required" placeholder="表名"
                               autocomplete="off" class="layui-input">
                              
                    </div>
                   
                    <div  class="layui-form-mid layui-word-aux">不映射不处理</div>
                    <a class="layui-btn layui-btn" @click="fetchTableMapping">映射</a>

                </div>
                <div v-show="extString2=='form'" class="layui-form-item">
                    <label class="layui-form-label">是否触发流程</label>
                    <div class="layui-input-block" style="width:300px">
                        <select name="triggerProcess" v-model="triggerProcess" lay-verify="required">
                            <option value="1">是</option>
                            <option value="0">否</option>
                        </select>
                    </div>
                </div>
                <div v-show="extString2=='form'" class="layui-form-item">
                    <label class="layui-form-label">表单模板编号</label>
                    <div class="layui-input-inline">
                        <select id="other2a8_affair_type" name="affairType" lay-verify="required" lay-filter="affairType">
                            <!-- <option value="api">接口传输</option>
                            <option value="ws">WebService服务</option> -->

                        </select>

                    </div>
                </div>
                <div v-show="extString2=='form'" class="layui-form-item">
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
                                    <tbody id="other2a8_field_list_body2">

                                    </tbody>
                                </table>

                            </div>
                        </fieldset>
                    </div>
                </div>

                <div v-show="extString2!='form'">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline" style="width:88%">
                        <fieldset class="layui-elem-field">
                            <legend>表字段映射</legend>
                            <div class="layui-field-box">
                                <table class="layui-table">
                                    <thead>
                                    <tr>
                                       
                                        <th>a8字段</th>
                                        <th>a8字段类型</th>
                                        <th>是否存储</th>
                                        <th>转换方式</th>
                                     
                                        <th>other字段</th>
                                       

                                    </tr>
                                    </thead>
                                    <tbody id="other2a8_table_field_list_body">

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
<script src="/seeyon/apps_res/nbd/app/other2a8.js"></script>
</body>

</html>