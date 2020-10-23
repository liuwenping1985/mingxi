<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>督办台账</title>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/vendor/layui/css/layui.css">
    <script type="text/javascript" src="/seeyon/apps_res/duban/vendor/layui/layui.js"></script>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/css/xad.css">
</head>
<body>
<div id="leaderOpinionArea" style="display:none">
    <div>
        <input id="leader_first_name" type="hidden" value="苗" />
        <input id="leader_task_id" type="hidden" value="" />
        <form class="layui-form">

            <div class="layui-form-item layui-inline">
                <div class="layui-inline">
                    <div class="xad_leader_title">
                        <table class="layui-table">
                            <tr><td width="80px">标题</td><td><span title="" id="leader_op_name" style="width:210px" class="xad_table_span_text"></span></td><td width="80px">任务来源</td><td><span style="width:120px" id="leader_op_task_source"></span></td></tr>
                            <tr><td>任务级别</td><td><span id="leader_op_task_level"></span></td><td>办理时限</td><td><span id="leader_op_deadline"></span></td></tr>
                            <tr><td>承办部门</td><td><span id="leader_op_main_dept"></span></td><td>当前进度</td><td><span class="xad_table_span_text" id="leader_op_process"></span></td></tr>

                        </table>
                    </div>

                    <textarea id="xad_leader_op_input" class="xad_leader_op" placeholder="请批示" class="layui-input"  ></textarea>
                </div>
            </div>

            <div class="layui-form-item">
                <div>
                    <center>
                        <button type="button" data-index="1" id="leader_op_ok_btn" class="layui-btn">提交</button>
                        <button type="button" id="leader_op_cancel_btn" class="layui-btn layui-btn-danger">取消</button>
                    </center>
                </div>
            </div>

        </form>
    </div>


</div>
<div id="searchArea" style="padding-top:15px;display:none">
    <div>
        <form class="layui-form" id="form_query_form" lay-filter="form_query_form">
            <div class="layui-form-item layui-inline layui-form-item-original">
                <div class="layui-inline">
                    <label class="layui-form-label">查询字段</label>
                    <div class="layui-input-inline">
                        <select name="condition_1" lay-filter="condition_1">

                            <option value="name" selected="">任务名称</option>
                            <option value="taskSource">任务来源</option>
                            <option value="taskLevel" >任务级别</option>
                            <option value="period">周期</option>
                            <option value="mainProcess">进度</option>
                            <option value="mainLeader">责任领导</option>
                            <option value="mainDeptName">承办部门</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item layui-inline layui-form-item-original">
                <div class="layui-inline">
                    <input style="width:300px" placeholder="请输入查询关键字" name="condition_1_input" class="layui-input" type="text" />
                </div>
            </div>
            <div id="condition_panel_2" style="display:none">
                <div class="layui-form-item layui-form-item-original">
                    <label class="layui-form-label">关联条件</label>
                    <div class="layui-input-inline">
                        <select name="condition_join_1" lay-filter="condition_join_1">
                            <option value="0">或者(OR)</option>
                            <option value="1" selected="">并且(AND)</option>
                        </select>
                    </div>
                </div>

                <div class="layui-form-item layui-inline">
                    <div class="layui-inline">
                        <label class="layui-form-label">查询条件</label>
                        <div class="layui-input-inline">
                            <select name="condition_2" lay-filter="condition_2">
                                <option value="name" >任务名称</option>
                                <option value="taskSource" selected="">任务来源</option>
                                <option value="taskLevel"  >任务级别</option>
                                <option value="period">周期</option>
                                <option value="mainProcess">进度</option>
                                <option value="mainLeader">责任领导</option>
                                <option value="mainDeptName">承办部门</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-inline">
                    <div class="layui-inline">
                        <input style="width:300px" placeholder="请输入查询内容,不输入值不生效" class="layui-input" name="condition_2_input" type="text" />
                    </div>
                </div>
            </div>
            <div id="condition_panel_3" style="margin-top:15px;display:none">
                <div class="layui-form-item layui-form-item-original">
                    <label class="layui-form-label">关联条件</label>
                    <div class="layui-input-inline">
                        <select name="condition_join_2" lay-filter="condition_join_2">
                            <option value="0">或者(OR)</option>
                            <option value="1" selected="">并且(AND)</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item layui-inline">
                    <div class="layui-inline">
                        <label class="layui-form-label">查询条件</label>
                        <div class="layui-input-inline">
                            <select name="condition_3" lay-filter="condition_3">
                                <option value="name" >任务名称</option>
                                <option value="taskSource"  >任务来源</option>
                                <option value="taskLevel"  selected="">任务级别</option>

                                <option value="period">周期</option>
                                <option value="mainProcess">进度</option>
                                <option value="mainLeader">责任领导</option>
                                <option value="mainDeptName">承办部门</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-inline">
                    <div class="layui-inline">
                        <input style="width:300px" placeholder="请输入查询内容,不输入值不生效"  name="condition_3_input" lay-verify="required" class="layui-input" type="text" />
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block layui-input-block-original">
                    <p>最多能有3个条件</p>
                    <button type="button" id="add_condition" data-index="1" class="layui-btn layui-btn-sm">新增条件</button>
                    <button type="button" id="search_fire_btn" class="layui-btn layui-btn-normal layui-btn-sm">查询</button>
                </div>
            </div>

        </form>
    </div>


</div>
<div class="xad_container">
    <button type="button" onclick="window.open('/seeyon/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=0&isNew=true&formTemplateId=-7318607877652200777&formId=1483769518542572937&moduleType=37&viewId=3540500392450935036&rightId=-2795613803648693781')" class="layui-btn"><i class="layui-icon"></i>督办立项</button>

    <button type="button" id="stat_entrance" class="layui-btn"><i class="layui-icon"></i>督办统计</button>
    <fieldset class="layui-elem-field site-demo-button" style="margin-top: 15px;padding:10px;height:100%">
        <legend>督办台账</legend>
        <div class="layui-row" style="height:100%">
            <div class="layui-col-md12" style="height:100%">
                <div class="layui-tab layui-tab-brief" style="height:100%" lay-filter="docDemoTabBrief">
                    <ul class="layui-tab-title">
                        <li id="leader_content_li">领导督办</li>
                        <li id="supervisor_content_li">督办事项</li>
                        <li id="watcher_content_li">我的观察</li>
                        <li class="layui-this">我的承办</li>

                        <li>我的协办</li>
                    </ul>
                    <div class="layui-tab-content" style="padding:0px;height:100%;">
                        <div id="leader_content"  class="layui-tab-item" style="height:100%">
                            <iframe style="width:100%;height:100%" frameborder="0" src="/seeyon/duban.do?method=goPage&page=leader&mode=leader"></iframe>
                        </div>
                        <div id="supervisor_content"  class="layui-tab-item" style="height:100%">
                            <iframe style="width:100%;height:100%" frameborder="0" src="/seeyon/duban.do?method=goPage&page=duban&mode=duban"></iframe>
                        </div>
                        <div   class="layui-tab-item" style="height:100%">
                            <iframe style="width:100%;height:100%" frameborder="0" src="/seeyon/duban.do?method=goPage&page=watcher&mode=watcher"></iframe>
                        </div>
                        <div class="layui-tab-item layui-show" style="height:100%">
                            <iframe style="width:100%;height:100%" frameborder="0" src="/seeyon/duban.do?method=goPage&page=cengban&mode=cengban"></iframe>
                        </div>
                        <div class="layui-tab-item" style="height:100%">
                            <iframe style="width:100%;height:100%" frameborder="0" src="/seeyon/duban.do?method=goPage&page=xieban&mode=xieban"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </fieldset>


</div>
<script src="/seeyon/apps_res/duban/vendor//layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/DubanDao.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/dash.js"></script>

</body>

</html>