<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <link rel="stylesheet" href="/seeyon/apps_res/duban/css/xad.css">
    <link rel="stylesheet" href="/seeyon/apps_res/duban/vendor/layui/css/layui.css">
    <script type="text/javascript" src="/seeyon/apps_res/duban/vendor/layui/layui.js"></script>
    <script type="text/javascript" src="/seeyon/apps_res/duban/vendor/echarts/echarts.min.js"></script>
</head>
<body style="background-color: white">
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>督办事项统计</legend>
</fieldset>


<div id="queryDiv" style="width:90%;margin:15px">
    <form class="layui-form" id="queryForm" lay-filter="queryForm" action="">

        <div class="layui-form-item">
            <label class="layui-form-label">任务来源</label>
            <div id="taskSource" class="layui-input-block">

            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">任务分级</label>
            <div id="taskLevel" class="layui-input-block">

            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">立项时间</label>
                <div class="layui-input-inline" style="width: 100px;">
                    <input id="time_min" type="text" name="time_min" placeholder="起始时间" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid">-</div>
                <div class="layui-input-inline" style="width: 100px;">
                    <input id="time_max" type="text" name="time_max" placeholder="结束时间" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">部门</label>
            <div class="layui-input-block">
                <textarea id="deptSelectTextArea" STYLE="WIDTH:409PX;height:65px" type="text" readonly name="deptShowName" lay-verify="title" autocomplete="off" placeholder="点击选择部门，不选择默认为所有部门"
                          class="layui-input"></textarea>
                <input id ="deptValueInput" type="hidden" name="deptValue"/>
            </div>
        </div>
        <div class="layui-input-block">
            <button id="fire" class="layui-btn layui-btn-normal" type="button" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题"
                    class="layui-input">统计</button>
            <button class="layui-btn layui-btn-normal" type="reset" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题"
                    class="layui-input">重置</button>
            <button id="hideQuery" class="layui-btn layui-btn-normal" type="button" lay-verify="title" autocomplete="off"
                    class="layui-input">隐藏</button>
        </div>
    </form>
</div>
<div id="showQueryDiv" style="display:none;width:90%;margin:15px">
    <button id="showQuery" class="layui-btn layui-btn-normal" type="button" lay-verify="title" autocomplete="off"
            class="layui-input">显示查询条件</button>

</div>
<table style="width:90%;margin:auto">
    <tr><td colspan="2"><div>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
            <legend>工作任务总体统计</legend>
        </fieldset>
    </div></td></tr>
    <tr>
        <td style="width:50%"><div id="main" style="width:100%;height:400px;"></div></td>
        <td style="width:50%"><div id="main2" style="width:100%;height:400px;"></div></td>

    </tr>
    <tr>
        <td colspan="2" style="width:90%;margin:15px"><div  style="height:20px;"></div></td>


    </tr>
    <tr>
        <td colspan="2" style="width:90%;margin:15px">
            <div>
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                    <legend>部门工作任务统计</legend>
                </fieldset>
                <form class="layui-form" id="statForm" lay-filter="statForm">
                    <div class="layui-form-item">
                        <label class="layui-form-label">统计维度</label>
                        <div class="layui-input-block">
                            <!-- 工作量，任务数，完成率，任务总分-->
                            <input type="radio" lay-filter="statForm" name="statType" value="taskAmount" title="任务量" checked="">
                            <input type="radio" lay-filter="statForm" name="statType" value="taskCount" title="任务数">
                            <input type="radio" lay-filter="statForm" name="statType" value="taskFinished" title="完成率">
                            <input type="radio" lay-filter="statForm" name="statType" value="taskScore" title="任务得分">
                        </div>
                    </div>
                </form>
            </div>
            <div id="main3" style="width:100%;height:400px;"></div>
        </td>


    </tr>
    <tr>
        <td colspan="2" style="width:100%;margin:15px">
            <div style="width:100%;margin:15px">

                <table class="layui-table">
                    <colgroup>
                        <col width="20%">
                        <col width="15%">
                        <col width="25%">
                        <col width="25%">
                        <col width="15%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>部门</th>
                        <th>任务量</th>
                        <th>相关任务数(A类任务数)</th>
                        <th>完成任务数(完成百分比)</th>
                        <th>任务最终得分</th>
                    </tr>
                    </thead>
                    <tbody id="dataBody">


                    </tbody>
                </table>
            </div>
        </td>


    </tr>
</table>



<script src="/seeyon/apps_res/duban/vendor//layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/DubanDao.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/taskStatAll.js"></script>
<div id="deptSelectedContainer" style="display:none;">

    <div id="deptSelected" style="padding:15px">



    </div>
    <center>
        <button id="deptSelectedOk" class="layui-btn layui-btn-normal" type="button" lay-verify="title" autocomplete="off"
                class="layui-input">确认</button>
        <button id="deptSelectedCancel" class="layui-btn layui-btn-primary" type="button" lay-verify="title" autocomplete="off"
                class="layui-input">取消</button>
    </center>

</div>

</body>


</html>