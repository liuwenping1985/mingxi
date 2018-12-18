<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html >

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

    <script src="/seeyon/apps_res/nbd/layui/apps/zrzx/shensuo.js"></script>
    <style>

        #flex{

            position:relative;
        }

        .flex {
            margin-left:70px;

            display: flex;

            overflow: hidden;
        }

        .left{
            margin-right: 20px;
            background: lightblue;
            z-index:200
        }

        .nav-item {

        }

        .nav-all {
            transition: .3s all;
            z-index:190
        }

        .move-left {
            transform: translateX(-1500px)
        }

        .move-right {
            transform: translateX(0)
        }

    </style>

</head>

<body style="background-color:#F5F5F5;margin-top: 0px;overflow-y: hidden;padding-bottom:50px">
<div style="width: 1366px;margin: 0 auto;text-align: center  ">

    <div style="height: 60px">
    <div id="flex" class="flex  " style="width: 1225px;overflow:hidden;z-index: 1;margin-bottom: 40px">
        <div class="left" style="margin-left:0;margin-right:0">
            <div style="height:42px;width:130px;font-size: 20px;line-height: 42px;" class="layui-bg-blue " onclick="shensuo()">报表中心
                <i class="layui-icon" style="">&#xe602</i></div>
        </div>
        <div style="overflow:hidden;margin-left:0;margin-right:0;line-height: 40px;width:1100px;background: dodgerblue" class="nav-all move-left " >
            <nav style="margin: 0 auto;width: 1000px;display: flex;justify-content: space-between;text-align: center">
            <span class="nav-item">&nbsp&nbsp&nbsp&nbsp<a href="xuncha" style="font-size:20px;color:white">  人&nbsp&nbsp事&nbsp&nbsp</a></span>
            <span class="nav-item"><a href="dangjian" style="font-size:20px;color:white">/&nbsp党&nbsp&nbsp建&nbsp</a></span>
            <span class="nav-item"><a href="xuncha" style="font-size:20px;color:white">/&nbsp巡&nbsp&nbsp查&nbsp</a></span>
            <span class="nav-item"><a href="niandu" style="font-size:20px;color:white">/&nbsp年&nbsp&nbsp度&nbsp</a></span>
            <span class="nav-item"><a href="hudong" style="font-size:20px;color:white">/&nbsp财&nbsp&nbsp务&nbsp</a></span>
            <span class="nav-item"><a href="dongtai" style="font-size:20px;color:white">/&nbsp动&nbsp&nbsp态&nbsp</a></span>
            <span class="nav-item"><a href="zhuanbao" style="font-size:20px;color:white">/&nbsp专&nbsp&nbsp报&nbsp</a></span>
            <span class="nav-item"><a href="gongwen" style="font-size:20px;color:white">/&nbsp公&nbsp&nbsp文&nbsp</a></span>
            <span class="nav-item"><a href="yongzhang" style="font-size:20px;color:white">/&nbsp用&nbsp&nbsp章&nbsp</a></span>
            <span class="nav-item"><a href="hudong" style="font-size:20px;color:white">/&nbsp资&nbsp&nbsp产&nbsp</a></span>
            <span class="nav-item"><a href="huiyi" style="font-size:20px;color:white">/&nbsp会&nbsp&nbsp议&nbsp</a></span>
            <span class="nav-item"><a href="hudong" style="font-size:20px;color:white">/&nbsp&nbsp系&nbsp&nbsp统&nbsp</a></span>
            <span class="nav-item"><a href="hudong" style="font-size:20px;color:white">/&nbsp合&nbsp&nbsp同&nbsp</a></span>

            </nav>

        </div>
    </div>
</div>






    <div class="layui-container" id="root_body" style="width: 90%">

</div>

<ul class="layui-fixbar">

    <li class="layui-icon layui-fixbar-top" lay-type="top" style="background-color: #1E9FFF; display: list-item;"></li>
</ul>
    <script src="/seeyon/apps_res/nbd/layui/lx.js"></script>

    <script src="/seeyon/apps_res/nbd/layui/apps/zrzx/report.js"></script>
</div>


</body>


</html>