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
                    <img src="/seeyon/apps_res/nbd/images/logo5.png" class="lx-logo">

                </div>
                <div class="lx-inline-block">
                    <div onclick="window.location.href=window.location.href" style="cursor:pointer" class="font-size-30 lx-color font-family-YH">环境发展中心工作管理平台</div>
                    <div class="lx-color">Work Management Platform Of Environmental Development Center</div>
                </div>
                <div class="lx-inline-block lx-online-banner">
                    <div class="lx-color font-size-14">142人</div>
                    <div class="lx-color font-size-14 lx-weight" style="height:22px">
                   <span style="width:40px" class="layui-btn layui-btn-xs layui-btn-radius lx-bg-color  font-size-14" lx-color font-size-14>V2.0</span>
                        <span style="width:105px;height:30px;line-height:30px;font-size:16px" onclick="window.location.href='/seeyon/main.do?method=main'" class="layui-btn layui-btn-xs">切回老版风格</span>
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

                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=main">平台首页</p></div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=dangjian">党建中心</p></div>
                <div class="lx-nav-item-zq"><p onclick="window.open('/seeyon/doc.do?method=docIndex&openLibType=1&_resourceCode=F04_docIndex')">资源中心</p></div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=zizhu">自助专区</p>
                    <p id="triangle-pointer" class="lx-pointer-triangle" style="margin-bottom:-1px"></p></div>
                    <div class="lx-nav-item-zq"><p onclick="window.open('/seeyon/nbd.do?method=goPage&page=report')">报表中心</p></div>
                </div>
              


            </div>

        </div>
        <div class="lx-user-area">
            <div class="lx-user-img-wrapper">
                <img class="lx-user-img" src="${userLogoImage}"/>
            </div>
            <div class="lx-inline-block" style="margin-top:10px;color:white">
                <div><span class="lx-weight">${userName}</span> <span class="font-size-14 lx-weight">${userType}</span></div>
                 <div class="font-size-14 lx-weight">${userDepartment}</div>
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
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq lx-dropdownzq-zq">协同<br>管理
        <ul class="lx-contentzq-zq">
            <li  class="lx-menu-item-zq" onclick="window.open('/seeyon/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl')">发起协同</li>
            <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/collaboration/collaboration.do?method=listWaitSend&_resourceCode=F01_listWaitSend')">待发协同 </li>
            <li class="lx-menu-item-zq " onclick="window.open('/seeyon/collaboration/collaboration.do?method=listSent&_resourceCode=F01_listSent')">已发协同</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/collaboration/collaboration.do?method=listPending&_resourceCode=F01_listPending')">待办协同</li>
            <li class="lx-menu-item-zq " onclick="window.open('/seeyon/collaboration/collaboration.do?method=listDone&_resourceCode=F01_listDone')">已办协同</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/supervise/supervise.do?method=listSupervise&app=1&_resourceCode=F01_supervise')">督办协同</li>
        </ul>
    </div>
    <div  class="lx-menu-item lx-left-menu-zq lx-dropdownzq-zq">公文<br>管理
        <ul class="lx-contentzq-zq" style="top:55px">
            <li  class="lx-menu-item-zq" onclick="window.open('/seeyon/edocController.do?method=entryManager&entry=sendManager&_resourceCode=F07_sendManager')">发文管理</li>
            <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/edocController.do?method=entryManager&entry=recManager&_resourceCode=F07_recManager')">收文管理 </li>
            <li class="lx-menu-item-zq" onclick="window.open('/seeyon/edocController.do?method=entryManager&entry=signReport&_resourceCode=F07_signReport')">签报管理</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/edocStat.do?method=mainEntry&_resourceCode=F07_edocStat/seeyon/exchangeEdoc.do?method=listMainEntry&_resourceCode=F07_edocExchange')">公文统计</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/edocController.do?method=edocSearchMain&_resourceCode=F07_edocSearch')">公文查询</li>
            <li class="lx-menu-item-zq" onclick="window.open('/seeyon/supervise/supervise.do?method=listSupervise&app=4&_resourceCode=F07_edocSupervise')">公文督办</li>
            <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('')">公文交换</li>
        </ul>
       </div>
    <div  class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq lx-dropdownzq-zq">任务<br>管理
        <ul class="lx-contentzq-zq" style="top:110px">
                <li  class="lx-menu-item-zq" onclick="window.open('')">发起任务</li>
                <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('')">已发任务 </li>
                <li class="lx-menu-item-zq " onclick="window.open('')">待办任务</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('')">公文统计</li>
                <li class="lx-menu-item-zq " onclick="window.open('')">已完成任务</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('')">任务查询</li>
                <li class="lx-menu-item-zq " onclick="window.open('')">任务督办</li>
            </ul>
        
    </div>
    <div  class="lx-menu-item lx-left-menu-zq lx-dropdownzq-zq">会议<br>管理
        <ul class="lx-contentzq-zq" style="top:165px">
                <li  class="lx-menu-item-zq" onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingArrange&_resourceCode=F09_meetingArrange')">发起会议</li>
                <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingPending&_resourceCode=F09_meetingPending')">待开会议 </li>
                <li class="lx-menu-item-zq " onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingDone&_resourceCode=F09_meetingDone')">已开会议</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/meetingroom.do?method=index&_resourceCode=F09_meetingRoom')">会议资源</li>
                
            </ul>
        </div>
    <div class="lx-menu-item lx-left-menu-zq lx-dropdownzq-zq">行为<br>绩效
        <ul class="lx-contentzq-zq" style="top:225px">
                <li  class="lx-menu-item-zq " onclick="window.open('/seeyon/wfanalysis.do?method=overview&_resourceCode=F08_wfanalysis')">流程绩效</li>
                <li class="lx-menu-item-zq lx-bg-color-zq " onclick="window.open('/seeyon/behavioranalysis.do?method=orgindex&_resourceCode=F08_orgbehavioranalysis')">组织行为绩效 </li>
                <li class="lx-menu-item-zq " onclick="window.open('/seeyon/behavioranalysis.do?method=personalindex&_resourceCode=F08_personalbehavioranalysis')">个人行为绩效</li>
                <li class="lx-menu-item-zq lx-bg-color-zq" onclick="window.open('/seeyon/performanceReport/performanceQuery.do?method=queryIndex&_resourceCode=F08_systemreport')">系统数据</li>  
            </ul>
        </div>
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq" onclick="window.open('/seeyon/portal/portalController.do?method=personalInfoFrame&path=/personalAffair.do?method=personalInfo')">个人<br>中心</div>
    <div class="lx-menu-item lx-left-menu-zq" style="padding-top:15px" onclick="window.open('/seeyon/addressbook.do?method=homeEntry&_resourceCode=F12_addressbook')">通讯录</div>
    <div style="background-color:rgb(76,140,193)"><span class="layui-icon " lay-type="top" style="font-size:50px;color:white;font-weight:bold"></span></div>
</div> 
<div id="lx-right-menu" class="lx-right-menu">
        <!--<div class="lx-menu-item lx-menu-item-bg-color2 lx-right-menu-zq" onclick="window.open('http://10.10.204.107:8080/v2018bi/reportJsp/showReportsw.jsp?rpx=/biao/swxiangxi.rpx')">收文<br>督办</div>-->
    <div  class="lx-menu-item lx-menu-item-bg-color3 lx-right-menu-zq" onclick="window.open('/seeyon/edocController.do?method=edocFrame&from=listDoneAll&edocType=0&track=&listType=listDoneAll&recListType=&sendUnitId=&id=&meetingSummaryId=&comm=&edocId=&recieveId=&forwordType=&checkOption=&newContactReceive=&subType=&exchangeId=&templeteId=&affairId=&app=&transmitSendNewEdocId=&registerId=&recAffairId=&modelType=&summaryId=&backBoxToEdit=&canOpenTemplete=&registerType=&openFrom=')">已阅<br>公文</div>
    <div  class="lx-menu-item lx-menu-item-bg-color2 lx-right-menu-zq" onclick="window.open('/seeyon/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=-8401178635628098112')">司局级<br>外出请示</div>
    <div  class="lx-menu-item lx-menu-item-bg-color3 lx-right-menu-zq"><span style="font-size:33px;padding-top:8px;" class="glyphicon glyphicon-arrow-right"></span></div>

</div>

<div class="lx-root">
    <div id="root_body" class="lx-content lx-root-body">
            <div class="layui-col-xs12 lx-top-menu-zq" >
                    <div class="layui-col-xs2 lx-btn-group" >
                    <button id="bangongshi" class=" btn-color layui-btn layui-btn-normal lx-changeFont-zq lx-nav-font"> 办公室</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button id="dangwei" class=" btn-color layui-btn layui-btn-normal lx-changeFont-zq" >党委办公室</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button id="renshi" class=" btn-color layui-btn layui-btn-normal  lx-changeFont-zq" >人事处</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button id="caiwu" class=" btn-color layui-btn layui-btn-normal  lx-changeFont-zq">财务处</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button  id="guoji" class=" btn-color layui-btn layui-btn-normal  lx-changeFont-zq" >国际处</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button id="huiyi" class=" btn-color layui-btn layui-btn-lg layui-btn-normal  lx-changeFont-zq" >会议/物业</button>
                    </div>
                </div>
    </div>
    <div style="display:none">   
            <div id="quick_enter_btns" class="layui-col-xs12">
                <div class="layui-col-xs12" style="margin-top:20px;height:39px;">
                    <div class="layui-col-xs2 lx-btn-group" >
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#21A097">发文</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#DD8056">签报</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#D2B02B">借用证明</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#6FA980">动态报送</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#7BCCDD">专报报送</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#A9ADB9">428会议室</button>
                    </div>
                </div>
                <div class="layui-col-xs12" style="margin-top:20px;height:39px;">
                    <div class="layui-col-xs2 lx-btn-group" >
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#21A097">信息化需求</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#DD8056">申请盖章</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#D2B02B">因公外出</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#6FA980">部请假</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#7BCCDD">通讯录</button>
                </div>
                </div>
            
            
    
            </div>
            <!-- <div class="layui-col-xs12"  id="zizhu">
                    <div id="zizhu1" class="layui-col-xs2"></div>
                    <div id="zizhu2" class="layui-col-xs2"></div>
                    <div id="zizhu3"  class="layui-col-xs2"></div>
                    <div id="zizhu4" class="layui-col-xs2"></div>
                    <div id="zizhu5"  class="layui-col-xs2"></div>
                    <div id="zizhu6" ></div>
            </div> -->







</div>

<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/main.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/zizhu.js"></script>
</body>