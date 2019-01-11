<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>生态环境部环境发展中心</title>
    <!--[if lt IE 9]>
    <script src="/seeyon/apps_res/nbd/layui/html5.min.js"></script>
    <script src="/seeyon/apps_res/nbd/layui/respond.min.js"></script>
    <![endif]-->
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/bootstrap3.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/skin_menhu.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/icon.css">
    <script src="/seeyon/apps_res/nbd/layui/layui.js"></script>
    <style>
        .btn-color{
            height: 30px;
            width:90px;

        }
    </style>


</head>

<body class="lx-body">

<div class="lx-header">
    <div class="lx-top-menu">
        <div class="lx-content">
            <div class="lx-inline-block h78px w100percent">
                <div class="lx-inline-block">
                    <img src="/seeyon/apps_res/nbd/images/logo5.png" class="lx-logo">

                </div>
                <div class="lx-inline-block">
                    <div class="font-size-30 lx-color font-family-YH">环境发展中心工作管理平台</div>
                    <div class="lx-color">Work Management Platform Of Environmental Development Center</div>
                </div>
                <div class="lx-inline-block lx-online-banner">
                    <div class="lx-color font-size-14">142人</div>
                    <div class="lx-color font-size-14 lx-weight" style="height:22px"><span style="width:40px"
                                                                                           class="layui-btn layui-btn-xs layui-btn-radius lx-bg-color">V2.0</span>
                    </div>
                </div>

            </div>
            <div class="lx-search-btn">
                <div class="input-group  w250px">
                    <input type="text" class="form-control" placeholder="全文检索" aria-describedby="basic-addon2">
                    <span class="input-group-addon" id="basic-addon2"><span class="lx-color glyphicon glyphicon-search"
                                                                            aria-hidden="true"></span></span>
                </div>
            </div>

        </div>

        <div id="page_menu" class="lx-bg-color lx-page-menu-nav">
            <div class="lx-content">

                <div class="lx-nav-item lx-nav-this"><p>平台首页</p>
                    <p id="triangle-pointer" class="lx-pointer-triangle"></p></div>
                <div class="lx-nav-item"><p>党建中心</p></div>
                <div class="lx-nav-item"><p>资源中心</p></div>
                <div class="lx-nav-item"><p>自助专区</p></div>
                <div class="lx-nav-item"><p>报表中心</p></div>

            </div>

        </div>
        <div class="lx-user-area">
            <div class="lx-user-img-wrapper">
                <img class="lx-user-img" src="/seeyon/apps_res/nbd/images/logoUser.jpg"/>
            </div>
            <div class="lx-inline-block" style="margin-top:10px;color:white">
                <div><span class="lx-weight">爱因斯坦</span> <span class="font-size-14 lx-weight">普通员工</span></div>
                <div class="font-size-14 lx-weight">宣教中心音响室</div>
            </div>
            <span class="lx-inline-block">
               <span class="icon_logout glyphicon glyphicon-log-out"></span>
            </span>
        </div>
    </div>
    <div class="lx-top-user">

    </div>
</div>
<div id="lx-left-menu" class="lx-left-menu">
    <div class="lx-menu-item lx-menu-item-bg-color">协同<br>管理</div>
    <div  class="lx-menu-item ">公文<br>管理</div>
    <div  class="lx-menu-item lx-menu-item-bg-color">任务<br>管理</div>
    <div  class="lx-menu-item">会议<br>管理</div>
    <div class="lx-menu-item lx-menu-item-bg-color">日程<br>管理</div>
    <div class="lx-menu-item">行为<br>绩效</div>
    <div class="lx-menu-item lx-menu-item-bg-color">个人<br>中心</div>
    <div class="lx-menu-item" style="padding-top:15px">通讯录</div>
    <div style="background-color:rgb(76,140,193);"><span class="layui-icon " lay-type="top" style="font-size:50px;color:white;font-weight:bold"></span></div>
</div>
<div id="lx-right-menu" class="lx-right-menu">
    <div class="lx-menu-item lx-menu-item-bg-color2">收文<br>督办</div>
    <div  class="lx-menu-item lx-menu-item-bg-color3">领导<br>批阅</div>
    <div  class="lx-menu-item lx-menu-item-bg-color2">领导<br>日程</div>
    <div  class="lx-menu-item lx-menu-item-bg-color3"><span style="font-size:33px;padding-top:8px;" class="glyphicon glyphicon-arrow-right"></span></div>

</div>

<div class="lx-root">
    <div id="root_body" class="lx-content lx-root-body">


    </div>
    <div style="display:none">

        <div id="quick_enter_btns">
            <div style="display: flex;justify-content: space-between;margin:30px auto">
                <button class="btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#21A097">办公室</button>
                <button class="btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#DD8056">党委办公室</button>
                <button class="btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#D2B02B">人事处</button>
                <button class="btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#6FA980">财务处</button>
                <button class="btn-color" style="background-color:#7BCCDD">国际处</button>
                <button class="btn-color" style="background-color:#A9ADB9">会议/物业</button>

            </div>
            <div style="display: flex;justify-content: space-between;margin:30px auto">
                <button class="btn-color" style="background-color:#299AC6">新建协网</button>
                <button class="btn-color" style="background-color:#299AC6">新建公文</button>
                <button class="btn-color" style="background-color:#299AC6">新建任务</button>
                <button class="btn-color" style="background-color:#299AC6">新建日程</button>
                <button class="btn-color" style="background-color:#299AC6">规章制度</button>
                <button class="btn-color" style="background-color:#299AC6">学术委员会</button>
            </div>


        </div>
    </div>
</div>

<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/main.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/menhu.js"></script>
</body>