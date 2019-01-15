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

                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=main">平台首页</p></div>
                <div class="lx-nav-item lx-nav-this"><p data-link="/seeyon/nbd.do?method=goPage&page=dangjian">党建中心</p>
                  <p id="triangle-pointer" class="lx-pointer-triangle" style="margin-bottom:-1px"></p>
                </div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=ziyuan">资源中心</p></div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=zizhu">自助专区</p></div>
                <div class="lx-nav-item"><p data-link="/seeyon/nbd.do?method=goPage&page=report">报表中心</p></div>

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
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq">协同<br>管理</div>
    <div  class="lx-menu-item lx-left-menu-zq ">公文<br>管理</div>
    <div  class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq">任务<br>管理</div>
    <div  class="lx-menu-item lx-left-menu-zq">会议<br>管理</div>
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq">日程<br>管理</div>
    <div class="lx-menu-item lx-left-menu-zq">行为<br>绩效</div>
    <div class="lx-menu-item lx-menu-item-bg-color lx-left-menu-zq">个人<br>中心</div>
    <div class="lx-menu-item lx-left-menu-zq" style="padding-top:15px">通讯录</div>
    <div style="background-color:rgb(76,140,193);"><span class="layui-icon " lay-type="top" style="font-size:50px;color:white;font-weight:bold"></span></div>
</div>
<div id="lx-right-menu" class="lx-right-menu">
    <div class="lx-menu-item lx-menu-item-bg-color2 lx-right-menu-zq">收文<br>督办</div>
    <div  class="lx-menu-item lx-menu-item-bg-color3 lx-right-menu-zq">领导<br>批阅</div>
    <div  class="lx-menu-item lx-menu-item-bg-color2 lx-right-menu-zq">领导<br>日程</div>
    <div  class="lx-menu-item lx-menu-item-bg-color3 lx-right-menu-zq"><span style="font-size:33px;padding-top:8px;" class="glyphicon glyphicon-arrow-right"></span></div>

</div>

<div class="lx-root">
    <div id="root_body" class="lx-content lx-root-body">
    </div>
    <div style="display:none">
            <div>
                <div class="layui-col-xs12" id="yian">                                
                        <div class="layui-col-xs6" id="yian1">
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">上级精神</span>
                                        <span class="lx-line-style"></span>
                                </div>
                                
                        </div>          
                        <div class="layui-col-xs6" id="yian2">
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">中心动态</span>
                                        <span class="lx-line-style"></span>
                                </div>
                        </div>
                </div>
                <div class="layui-col-xs12" id="shijiuda">
                    <div class="layui-col-xs6" id="shijiuda1">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">上级精神</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                
                    <div class="layui-col-xs6" id="shijiuda2">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">上级精神</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                </div>
                <div class="layui-col-xs12" id="sanyan">
                        <div class="layui-col-xs6" id="sanyan1">
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">上级精神</span>
                                        <span class="lx-line-style"></span>
                                </div>
                        </div>
                
                        <div class="layui-col-xs6" id="sanyan2">
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">中心动态</span>
                                        <span class="lx-line-style"></span>
                                </div>
                        </div>
                        
                </div>
                <div class="layui-col-xs12" id="liangxue">
                    <div class="layui-col-xs6" id="liangxue1">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">上级精神</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                
                    <div class="layui-col-xs6" id="liangxue2">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">中心动态</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                </div>
                <div class="layui-col-xs12" id="shibada">
                    <div class="layui-col-xs6" id="shibada1">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">上级精神</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                
                    <div class="layui-col-xs6" id="shibada2">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">中心动态</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                </div>
                <div class="layui-col-xs12" id="sanhui">
                    <div class="layui-col-xs6" id="sanhui1">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">上级精神</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                
                    <div class="layui-col-xs6" id="sanhui2">
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">中心动态</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                </div>     
            </div>      
            <div id="quick_enter_btns" class="layui-col-xs12">
                <div class="layui-col-xs12" style="margin-top:20px;height:39px;">
                    <div class="layui-col-xs2 lx-btn-group" >
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#21A097" > 信息报送</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#DD8056">信息表送</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#D2B02B">党员管理</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#6FA980">党员收缴</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#7BCCDD">召开会议</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" style="background-color:#A9ADB9">关系调用</button>
                    </div>
                </div>
            </div>
            <div id="leader_table" style="margin-top:20px">
                <table style="width:100%;height:100px"  >
                        <tr>
                            <td class="lx-table-zq">党委书记：&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp程春明</td>
                            <td class="lx-table-zq">副书记：&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp任勇</td>
                             </tr>

                        <tr>
                          <td class="lx-table-zq">宣教支部书记：&nbsp&nbsp&nbsp贾峰</td>
                          <td class="lx-table-zq">科技支部书记：&nbsp&nbsp&nbsp辛志伟</td>
                         </tr>
                         <tr>
                            <td class="lx-table-zq">分测支部书记：&nbsp&nbsp&nbsp黄业茹</td>
                            <td class="lx-table-zq">环管支部书记：&nbsp&nbsp&nbsp王亚男</td>
                         </tr>
                        
                      </table>
                      <span class="lx-line-style"></span>
                      <hr align=center width:100% color=red size=2>
                 <table style="width:100%;height:100px">
                            <tr>
                                    <td class="lx-table-zq">标样支部书记：&nbsp&nbsp&nbsp田洪海</td>
                                    <td class="lx-table-zq">中环支部书记:&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp张小丹</td>
                               </tr>
                               <tr>
                                    <td class="lx-table-zq">会物支部书记：&nbsp&nbsp&nbsp张琦</td>
                                    <td class="lx-table-zq">机关支部书记：&nbsp&nbsp&nbsp&nbsp张耀东</td>
                                </tr>
                                <tr>
                                        <td class="lx-table-zq">离退休支部书记：张太生</td>
                                        <td class="lx-table-zq"></td>
                                    </tr>
                      </table>
        </div>
            
    </div>







</div>

<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/main.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/dangjian.js"></script>
</body>