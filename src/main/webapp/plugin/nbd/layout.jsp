<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>生态环境部环境发展中心</title>
    <!--[if lt IE 9]>
    <script src="layui/html5.min.js"></script>
    <script src="layui/respond.min.js"></script>
    <![endif]-->
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/bootstrap3.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/layui/css/layui.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/skin_menhu.css">
    <link rel="stylesheet" href="/seeyon/apps_res/nbd/css/icon.css">
    
    <script src="/seeyon/apps_res/nbd/layui/layui.js"></script>



</head>

<body class="lx-body">

<div class="lx-header">
    <div class="lx-top-menu">
        <div class="lx-content">
            <div class="lx-inline-block h78px w100percent">
                <div class="lx-inline-block">
                    <img src="/seeyon/apps_res/nbd/images/newlogo.png" class="lx-logo">

                </div>
               <!--  <div class="lx-inline-block">
                    <div class="font-size-30 lx-color font-family-YH">生态环境部环境发展中心</div>
                    <div class="lx-color">Environmental Development Centre of Ministry of Ecology and Environment</div>
                </div> -->
                <div class="lx-inline-block lx-online-banner">
                    <div id="onlineNumSpan" class="lx-color font-size-14"></div>
                    <div class="lx-color font-size-14 lx-weight" style="height:22px">
                        <span style="width:40px" class="layui-btn layui-btn-xs layui-btn-radius lx-bg-color">V2.0</span>
                        <span style="width:105px" onclick="window.location.href='/seeyon/main.do?method=main'" class="layui-btn layui-btn-xs">返回旧版OA</span>

                    </div>
                </div>

            </div>
            <div class="lx-search-btn">
                <div class="input-group  w250px">
                    <input type="text" class="form-control" id="keyWordSearchInput" placeholder="全文检索" aria-describedby="basic-addon2">
                    <span class="input-group-addon" id="basic-addon2"><span id="keyWordSearch" class="lx-color glyphicon glyphicon-search"
                                                                            aria-hidden="true" style="cursor:pointer"></span></span>
                </div>
            </div>

        </div>

        <div id="page_menu" class="lx-bg-color lx-page-menu-nav">
            <div class="lx-content">

                <div class="lx-nav-item lx-nav-this"><p data-link="/seeyon/nbd.do?method=goPage&page=pageMain" data-height="1799px" data-mode="location" >平台首页</p>
                    <p id="triangle-pointer" class="lx-pointer-triangle" style="margin-bottom:-1px"></p></div>
                <!-- <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=dangjian">党建中心</p></div> -->
                <div class="lx-nav-item"><p data-link="/seeyon/main.do?method=main&openType=menhu&type=docCenter" data-mode="new">文档中心</p></div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=pageAss" data-height="1210px" data-mode="location">处室专区</p></div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=report" data-mode="new">报表中心</p></div>

            </div>

        </div>
        <div class="lx-user-area">
                <!-- <div class="lx-user-img-wrapper">
                        <img class="lx-user-img" src="/seeyon/apps_res/nbd/images/logoUser.jpg"/>
                    </div>
                    <div class="lx-inline-block" style="margin-top:10px;color:white">
                        <div><span class="lx-weight lx-user-name">爱因斯坦</span> <span class="font-size-14 lx-weight lx-user-type">普通员工</span></div>
                         <div class="font-size-14 lx-weight lx-user-dept">宣教中心音响室</div>
                    </div> -->
            <div class="lx-user-img-wrapper">
                <img class="lx-user-img" src="${userLogoImage}" onclick="window.open('/seeyon/portal/portalController.do?method=personalInfoFrame&path=/personalAffair.do?method=personalInfo')"/>
            </div>
            <div class="lx-inline-block" style="margin-top:10px;color:white">
                <div><span class="lx-weight lx-user-name">${userName}</span> <span class="font-size-14 lx-weight lx-user-type">${userType}</span></div>
                 <div class="font-size-14 lx-weight lx-user-dept">${userDepartment}</div>
            </div>
            <span class="lx-inline-block">
               <span class="icon_logout glyphicon glyphicon-log-out"></span>
            </span>
        </div>
    </div>
    <input type="hidden"  id="userId" value="${userId}"/>
    <div class="lx-top-user">

    </div>
</div>
<div id="lx-left-menu" class="lx-left-menu">
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq lx-dropdownzq-zq">协同<br>管理
        <ul class="lx-contentzq-zq">
            <li  class="lx-menu-item-zq" onclick="window.open('/seeyon/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl')">发起协同</li>
            <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=daifaxietong')">待发协同 </li>
            <li class="lx-menu-item-zq " onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=yifaxietong')">已发协同</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=daibanxietong')">待办协同</li>
            <li class="lx-menu-item-zq " onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=yibanxietong')">已办协同</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=dubanxietong')">督办协同</li>
        </ul>
    </div>
    <div  class="lx-menu-item lx-left-menu-zq lx-dropdownzq-zq">公文<br>管理
        <ul class="lx-contentzq-zq" style="top:55px">
            <li  class="lx-menu-item-zq" onclick="window.open('/seeyon/edocController.do?method=listIndex&from=newEdoc&edocType=0&listType=newEdoc')">发文管理</li>
            <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/edocController.do?method=entryManager&entry=recManager&_resourceCode=F07_recManager')">收文管理 </li>
            <li class="lx-menu-item-zq" onclick="window.open('/seeyon/edocController.do?method=listIndex&edocType=2&listType=newEdoc')">签报管理</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/edocController.do?method=edocSearchMain&_resourceCode=F07_edocSearch')">公文查询</li>
            <li class="lx-menu-item-zq" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=gongwenduban')">公文督办</li>
            
        </ul>
       </div>
    <!-- <div  class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq lx-dropdownzq-zq">任务<br>管理
        <ul class="lx-contentzq-zq" style="top:110px">
                <li  class="lx-menu-item-zq" onclick="window.open('')">发起任务</li>
                <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('')">已发任务 </li>
                <li class="lx-menu-item-zq " onclick="window.open('')">待办任务</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('')">公文统计</li>
                <li class="lx-menu-item-zq " onclick="window.open('')">已完成任务</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('')">任务查询</li>
                <li class="lx-menu-item-zq " onclick="window.open('')">任务督办</li>
            </ul>
        
    </div> -->
    <div  class="lx-menu-item lx-left-menu-zq lx-dropdownzq-zq">会议<br>管理
        <ul class="lx-contentzq-zq" style="top:110px">
                <li  class="lx-menu-item-zq" onclick="window.open('/seeyon/meeting.do?method=create&listMethod=listMyMeeting&listType=listSendMeeting')">发起会议</li>
                <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingPending&_resourceCode=F09_meetingPending')">待开会议 </li>
                <li class="lx-menu-item-zq " onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingDone&_resourceCode=F09_meetingDone')">已开会议</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/meetingroom.do?method=createApp&list=yesApp')">会议室申请</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingArrange&_resourceCode=F09_meetingArrange')">会议管理</li>
                
            </ul>
        </div>
    <div class="lx-menu-item lx-left-menu-zq " onclick="window.open('/seeyon/behavioranalysis.do?method=personalindex&_resourceCode=F08_personalbehavioranalysis')">行为<br>绩效</div>
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq" id="modify_pwd">修改<br>密码</div>
    <div class="lx-menu-item lx-left-menu-zq" style="padding-top:15px" onclick="window.open('/seeyon/addressbook.do?method=homeEntry&_resourceCode=F12_addressbook')">通讯录</div>
    <div id="to_top" style="background-color:rgb(76,140,193);cursor:pointer"><center><span class="layui-icon " lay-type="top" style="font-size:50px;color:white;font-weight:bold" href="#row1119"></span></center></div>
</div> -->
<div id="lx-right-menu" class="lx-right-menu">
   <!-- <div class="lx-menu-item lx-menu-item-bg-color2 lx-right-menu-zq" onclick="window.open('http://10.10.204.107:8080/v2018bi/reportJsp/showReportsw.jsp?rpx=/biao/swxiangxi.rpx')">收文<br>督办</div> -->
    <div  class="lx-menu-item lx-menu-item-bg-color3 lx-right-menu-zq" onclick="window.open('edocController.do?method=listIndex&from=listDone&edocType=0&listType=listDoneAll')">已阅<br>公文</div>
    <div  class="lx-menu-item lx-menu-item-bg-color2 lx-right-menu-zq" onclick="window.open('/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=-8401178635628098112')">外出<br>请示</div>
    <div  class="lx-menu-item lx-menu-item-bg-color3 lx-right-menu-zq"><span style="font-size:33px;padding-top:8px;" class="glyphicon glyphicon-arrow-right"></span></div>

</div>

<div class="lx-root">
  <iframe id="pageLocator"  width="100%" frameborder=0 height="1799px"scrolling="no" src="/seeyon/nbd.do?method=goPage&page=pageMain"></iframe>
 
</div>







</div>

<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/main.js"></script>
</body>