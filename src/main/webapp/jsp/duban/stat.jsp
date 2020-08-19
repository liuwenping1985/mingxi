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
        padding: 3px 3px;
    }
</style>
<body style="background-color: white">

<div class="layui-container" style="width:80% !important;">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>时间范围（时间段内有汇报的部门）</legend>
    </fieldset>

    <div class="layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">开始时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="start" placeholder="开始时间">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">结束时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="end" placeholder="结束时间">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">结束时间</label>
                <div class="layui-input-inline">
                    <button id="okBtn" type="button" class="layui-btn layui-btn-lg layui-btn-normal">确定</button>
                </div>
            </div>

        </div>
    </div>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>统计数据</legend>
    </fieldset>
    <table class="layui-table">
        <colgroup>
            <col width="150">
            <col width="150">
            <col width="200">
            <col>
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


<script src="/seeyon/apps_res/duban/verdor/layui/lx.js"></script>
<script type="text/javascript" src="/seeyon/apps_res/duban/js/stat.js"></script>

</body>
</html>