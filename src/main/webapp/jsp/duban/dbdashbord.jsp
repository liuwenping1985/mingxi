<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>督办台账</title>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/verdor/layui/css/layui.css">
    <script type="text/javascript" src="/seeyon/apps_res/duban/verdor/layui/layui.js"></script>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/css/duban.css">
</head>
<style>


    .td_no_padding {
        text-overflow: ellipsis;
        white-space: nowrap;/*不让文本换行*/
        overflow: hidden;
        padding: 3px 3px;
    }
</style>
<body style="background-color: white">

<div class="layui-container" style="width:98% !important;">

    <div class="layui-tab" lay-filter="mainTab">
        <ul class="layui-tab-title">
            <li id="leader" style="display:none" lay-id="leader">领导督办</li>
            <li id="duban" style="display:none" lay-id="duban" class="layui-this">我的督办</li>
            <li lay-id="cengban">我的承办</li>
            <li lay-id="xieban">我的协办</li>
            <div style="height:30px;width:500px;float:right;">
                <div class="layui-row">

                    <div class="layui-col-md3">


                                <select style="font-size:15px;width:120px;height:30px" name="query_field" id="query_field" >

                                    <option value="name" selected>标题</option>
                                    <option value="taskId">任务编号</option>
                                    <option value="mainLeader">责任领导</option>

                                </select>


                    </div>
                    <div class="layui-col-md4">

                        <input type="text" style="font-size:15px;height:30px" name="query_field_value"  id="query_field_value" />


                    </div>
                    <div class="layui-col-md5">
                        <div class=" layui-form-item ">
                            <button type="button" style="height:33px" class="layui-btn" onclick="dbcx_click()" id="query_btn_ok">查询</button>
                        </div>

                    </div>
                </div>

            </div>
        </ul>
        <div class="layui-tab-content">
            <div id="leader_content" class="layui-tab-item"></div>
            <div id="duban_content" class="layui-tab-item layui-show"></div>
            <div id="cengban_content" class="layui-tab-item"></div>
            <div id="xieban_content" class="layui-tab-item"></div>

        </div>
    </div>

    <div id="mainContent" class="layui-row" style="min-height: 300px;display:none">
        <div class="layui-col-md1">
            <div class="layui-row">
                <div class="layui-col-md12">
                    <div style="height:54px;width:1px"></div>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12">
                    <button id="running_task_list" type="button" style="width:92px"
                            class="layui-btn layui-btn-normal task_list_btn">进行中
                    </button>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12" style="height:30px">

                </div>
            </div>
            <div class="layui-row">

                <div class="layui-col-md12">
                    <button id="done_task_list" style="width:92px" type="button"
                            class="layui-btn layui-btn-primary task_list_btn">已完成
                    </button>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12" style="height:30px">

                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12">
                    <button id="all_task_list" type="button" class="layui-btn layui-btn-primary task_list_btn">全部任务
                    </button>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md12" style="height:30px">

                </div>
            </div>
            <%--<div class="layui-row">--%>
            <%--<div class="layui-col-md12">--%>
            <%--<button id="query" type="button" style="width:92px" class="layui-btn layui-btn-warm">查询</button>--%>
            <%--</div>--%>
            <%--</div>--%>
        </div>
        <div id="normal_table" class="layui-col-md11">
            <table class="layui-table">

                <thead>
                <tr>
                    <th>状态</th>
                    <th>任务名称</th>
                    <th>任务来源</th>
                    <th>级别</th>
                    <th>办理时限</th>
                    <th>周期</th>
                    <th>进度</th>
                    <th>责任领导</th>
                    <th>承办部门</th>

                    <th>最新汇报</th>
                    <th>负责人</th>
                    <th>操作</th>

                </tr>
                </thead>
                <tbody id="nakedBody">

                </tbody>
            </table>
        </div>
        <div id="supervisor_table" class="layui-col-md11" style="display:none">
            <table class="layui-table">

                <thead>
                <tr>
                    <th>状态</th>
                    <th>任务名称</th>
                    <th>任务来源</th>
                    <th>任务级别</th>
                    <th>办理时限</th>
                    <th>周期</th>
                    <th>进度</th>
                    <th>责任领导</th>
                    <th>承办部门</th>
                    <th>分数</th>
                    <th>最新汇报</th>
                    <th>负责人</th>
                    <th>操作</th>

                </tr>
                </thead>
                <tbody id="nakedBodyMore">

                </tbody>
            </table>
        </div>
    </div>
    <div class="layui-row">
        <div class="layui-col-md6">
            <div style="color:#666;font-size:14px">

            </div>
        </div>

        <div class="layui-col-md6">
            <div id="paging" style="float:right"></div>
        </div>
    </div>


</div>
<div id="form_home" style="display: none">
<div>

    <textarea style="width:415px;height:124px" resizeable="false" id="leader_op">


    </textarea>
    <br>
    <center><button id="l_op_o" class="layui-btn layui-btn-normal" onclick="l_op_o_click()" type="button">确认</button><button class="layui-btn layui-btn-primary" onclick="l_op_c_click()" id="l_op_c" type="button">取消</button></center>
</div>


</div>

<script src="/seeyon/apps_res/duban/verdor/layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/DubanDao.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/taskDetail.js"></script>


</body>
</html>