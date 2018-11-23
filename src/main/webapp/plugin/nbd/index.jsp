<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>生态环境部环境发展中心</title>
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
    <!-- <link rel="stylesheet" href="css/bootstrap3.css"> -->

    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/global.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/zrzx.css">
    <script src="/seeyon/apps_res/nbd/layui/layui.js"></script>

</head>

<body>
<div class="fly-header zr_hrader">
    <div class="layui-container">
        <div class="">
            <div class="zr_hrader_centre">
                <span id="top_date">2018年11月08日 </span><span class="zr_hrader_centre_span">欢迎<span style="font-weight:bold;color:#1E9FFF">艾志</span>来到生态环境部环境发展中心工作平台
                        ！</span>
                <div class="zr_hrader_centre_R">

                </div>
            </div>
        </div>

    </div>
</div>
<div class="fly-header zr_header_second">

    <div class="layui-container logo_box lx-layout-width">
            <span class="lx-layout-logo-area">
                <img src="/seeyon/apps_res/nbd/images/logo5.png" style="height:70px;width:70px" alt=""><img style="height:60px;width:568px"
                                                                                                            src="/seeyon/apps_res/nbd/images/1541744075_843646.png" alt="">
            </span>
        <div style="display:none">
            <div class="zr_search">
                <div style="display:inline-block"><img src="/seeyon/apps_res/nbd/images/logoUser.jpg" style="margin-top:-50px"
                                                       class="zr_person_img"></div>
                <div style="color:#6666CC;display:inline-block;font-size:18px;"><span style="font-weight:bold;">艾志</span><span>&nbsp;&nbsp;办公室</span><br>
                    <span style="line-height:35px;color:gray;font-size:16px;">电话:</span><span style="color:gray;font-size:16px;">010-67543210</span><br>
                    <span style="line-height:35px;color:gray;font-size:16px;">邮箱:</span><span style="color:gray;font-size:16px;">aiaiai@126.com</span>
                </div>
            </div>
            <div id="btn_groups">
                <fieldset class="layui-elem-field site-demo-button">
                    <legend style="color:black">功能区</legend>
                    <div>
                        <div style="" class="layui-row">
                            <div style="height:90px;vertical-align:middle" class="layui-col-md2 ">
                                <div id="cell_uuid" class="lx-layout-cell">
                                    <div style="width:100%;margin:0 auto;text-align:center;padding-top:25px;">
                                        <button style="background-color: #5484ff;display:inline-block;text-align:center"
                                                class="layui-btn layui-btn-warm layui-btn-radius">发起公文</button>
                                    </div>
                                </div>
                            </div>
                            <div style="height:90px" class="layui-col-md2 ">
                                <div id="cell_uuid" class="lx-layout-cell">
                                    <div style="width:100%;margin:0 auto;text-align:center;padding-top:25px;">
                                        <button style="background-color:#5484ff;display:inline-block;text-align:center"
                                                class="layui-btn layui-btn-warm layui-btn-radius">我要请假</button>
                                    </div>
                                </div>
                            </div>
                            <div style="height:90px" class="layui-col-md2 ">
                                <div id="cell_uuid" class="lx-layout-cell">
                                    <div style="width:100%;margin:0 auto;text-align:center;padding-top:25px;">
                                        <button style="background-color:#5484ff;display:inline-block;text-align:center"
                                                class="layui-btn layui-btn-warm layui-btn-radius">我的日程</button>
                                    </div>
                                </div>
                            </div>
                            <div style="height:90px" class="layui-col-md2 ">
                                <div id="cell_uuid" class="lx-layout-cell">
                                    <div style="width:100%;margin:0 auto;text-align:center;padding-top:25px;">
                                        <button style="background-color:#5484ff;display:inline-block;text-align:center;min-width:92px"
                                                class="layui-btn layui-btn-warm layui-btn-radius">停车单</button></div>
                                </div>
                            </div>
                            <div style="height:90px" class="layui-col-md2 ">
                                <div id="cell_uuid" class="lx-layout-cell">
                                    <div style="width:100%;margin:0 auto;text-align:center;padding-top:25px;">
                                        <button style="background-color:#5484ff;display:inline-block;text-align:center"
                                                class="layui-btn layui-btn-warm layui-btn-radius">外事公示</button>
                                    </div>
                                </div>
                            </div>
                            <div style="height:90px" class="layui-col-md2 ">
                                <div id="cell_uuid" class="lx-layout-cell">
                                    <div style="width:100%;margin:0 auto;text-align:center;padding-top:25px;">
                                        <button style="background-color:#5484ff;display:inline-block;text-align:center;"
                                                class="layui-btn layui-btn-warm layui-btn-radius">我的工资</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
            <div id="pending_main_area">
                <fieldset class="layui-elem-field site-demo-button" style="margin-top: 5px;">
                    <legend style="color:black">工作区</legend>
                    <div id="pending_main_body">

                    </div>
                </fieldset>

            </div>
        </div>

    </div>

    <div>
        <center>
            <ul class="layui-nav layui-bg-blue" lay-filter="">
                <li style="font-weight:bold" class="layui-nav-item layui-this">
                    <a onclick="window.open('/seeyon/nbd.do?method=goPage&page=index')">
                        <table>
                            <tr>
                                <td><i class="layui-icon layui-icon-home lx-layout-icon"></i></td>
                                <td><span style="font-weight:bold;white-space:nowrap;">工作首页</span></td>
                            </tr>
                        </table>
                    </a>
                </li>
                <li class="layui-nav-item " style="font-weight:bold">
                    <a href="">
                        <table>
                            <tr>
                                <td><i class="layui-icon layui-icon-flag lx-layout-icon"></i></td>
                                <td><span style="font-weight:bold;white-space:nowrap;">党建工作</span></td>
                            </tr>
                        </table>
                    </a>
                </li>
                <li style="font-weight:bold" class="layui-nav-item">
                    <a href="">
                        <table>
                            <tr>
                                <td><i class="layui-icon layui-icon-component lx-layout-icon"></i></td>
                                <td><span style="font-weight:bold;white-space:nowrap;">资源中心</span></td>
                            </tr>
                        </table>
                    </a>
                </li>
                <li style="font-weight:bold" class="layui-nav-item">
                    <a href="javascript:;">
                        <table>
                            <tr>
                                <td><i class="layui-icon layui-icon-read lx-layout-icon"></i></td>
                                <td><span style="font-weight:bold;white-space:nowrap;">自助专区</span></td>
                            </tr>
                        </table>
                    </a>
                </li>
                <li style="font-weight:bold" class="layui-nav-item">
                    <a onclick="window.open('/seeyon/nbd.do?method=goPage&page=report')">
                        <table>
                            <tr>
                                <td><i class="layui-icon layui-icon-layouts lx-layout-icon"></i></td>
                                <td><span style="font-weight:bold;white-space:nowrap;">报表中心</span></td>
                            </tr>
                        </table>
                    </a>
                </li>
            </ul>
        </center>

    </div>
</div>

<div class="layui-container" id="root_body">



</div>
<div class="lx-layout-menu">
    <ul style="font-size:30px">
        <li class="layui-icon layui-fixbar-top" lay-type="top" style="background-color: #1E9FFF; display: list-item;"></li>
        <li class="layui-icon layui-fixbar-top" lay-type="top" style="background-color: #1E9FFF; display: list-item;"></li>
    </ul>
</div>
<ul class="layui-fixbar">

    <li class="layui-icon layui-fixbar-top" lay-type="top" style="background-color: #1E9FFF; display: list-item;"></li>
</ul>

<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/layout.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/index.js"></script>
</body>


</html>