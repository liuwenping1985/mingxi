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



<div style="position:absolute;width:100%">
    <div id="root_body" class="lx-content lx-root-body">


    </div>
    <div style="display:none">
            <div id="calendar_container" class="layui-col-xs12">
                    <table style="padding:0px;margin:0px" class="layui-col-xs12"><tr><td>
                        <div  id="cal_date_picker" class="layui-inline"></div>
                    </td><td>
                        <div  id="cal_leader_container" class="layui-inline" >



                        </div>
                    </td></tr></table>
                    
                   
                     <div id="my_cal">
                     </div>
                      <div id="s_leader_cal" class="layui-col-xs12" style="vertical-align:text-top;width:100%">
                          <div id="s_leader_cal_left" style="padding-right:10px;text-align:top" class="layui-inline layui-col-xs6"></div>
                          <div id="s_leader_cal_right" style="padding-left:10px;text-align:top" class="layui-inline layui-col-xs6"></div>
                     </div>
                      <div id="m_leader_cal" class="layui-col-xs12">
                     </div>

            </div>
            <div class="layui-col-xs12" id="tpl_all">
                    <div class="layui-col-xs6" id="tpl_one"></div>

                    <div class="layui-col-xs6" id="tpl_two"></div>
            </div>
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
                                <span class="lx-text-style">中心动态</span>
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
            <div class="layui-col-xs12" id="jianbao">
                <div class="layui-col-xs6" id="jianbao1"></div>
            
                <div class="layui-col-xs6" id="jianbao2"></div>
            </div>
            <div class="layui-col-xs12" id="zhuanbao">
                <div class="layui-col-xs6" id="zhuanbao1"></div>
            
                <div class="layui-col-xs6" id="zhuanbao2"></div>
            </div>
            <div class="layui-col-xs12" id="tongbao">
                <div class="layui-col-xs6" id="tongbao1"></div>
            
                <div class="layui-col-xs6" id="tongbao2"></div>
            </div>
            <div id="quick_enter_btns" class="layui-col-xs12">
                <div class="layui-col-xs12" style="margin-top:7px;height:39px;">
                    <div class="layui-col-xs2 lx-btn-group" >
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=bgs')" style="background-color:#21A097">办公室</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=bgs')" style="background-color:#DD8056">党委办公室</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=rsc')" style="background-color:#D2B02B">人事处</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=cwc')"  style="background-color:#6FA980">财务处</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=gjc')"  style="background-color:#7BCCDD">国际处</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/main.do?method=main&openType=menhu&type=huiyi')" style="background-color:#A9ADB9">会议/物业</button>
                    </div>
                </div>
                <div class="layui-col-xs12" >
                
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl')" style="background-color:#299AC6">新建协同</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/edocController.do?method=entryManager&entry=sendManager&_resourceCode=F07_sendManager')" style="background-color:#299AC6">新建公文</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl')"  style="background-color:#299AC6">新建任务</button>
                </div>
                <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal"  onclick="window.open('/seeyon/meetingNavigation.do?method=entryManager&entry=meetingArrange&_resourceCode=F09_meetingArrange')"   style="background-color:#299AC6">新建会议</button>
                    </div>
                    <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/form/queryResult.do?method=queryIndex&_resourceCode=T05_formQuery')"  style="background-color:#299AC6">流程查询</button>
                    </div>
                    <div class="layui-col-xs2 lx-btn-group">
                    <button class=" btn-color layui-btn layui-btn-lg layui-btn-normal" onclick="window.open('/seeyon/form/formData.do?method=unflowForm&formType=2&_resourceCode=T05_unflowInfoData')" style="background-color:#299AC6;">数据维护</button>
                </div>
                
                </div>


            </div>
            <div class="layui-col-xs12" id="bangonghui">
            <div class="layui-col-xs2" id="time" >
                        <div class="lx-box-style">
                                <span class="lx-line-style"></span>
                                <span class="lx-text-style">会议时间</span>
                                <span class="lx-line-style"></span>
                        </div>
            </div>
            
             <div class="layui-col-xs4" id="mingcheng" >
                        <div class="lx-box-style">
                                <span class="lx-line-style"></span>
                                <span class="lx-text-style">会议名称</span>
                                <span class="lx-line-style"></span>
                        </div>
            </div>
            <div class="layui-col-xs4" id="yicheng" >
                    <div class="lx-box-style">
                            <span class="lx-line-style"></span>
                            <span class="lx-text-style">主要议程</span>
                            <span class="lx-line-style"></span>
                    </div>
            </div>
            <div class="layui-col-xs2" id="zhuchiren" >
                <div class="lx-box-style">
                        <span class="lx-line-style"></span>
                        <span class="lx-text-style">主持人</span>
                        <span class="lx-line-style"></span>
                </div>
            </div>
            </div>
            <div class="layui-col-xs12" id="lingdaobanzi">
                <div class="layui-col-xs2" id="time" >
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">会议时间</span>
                                    <span class="lx-line-style"></span>
                            </div>
                </div>
                
                 <div class="layui-col-xs4" id="mingcheng" >
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">会议名称</span>
                                    <span class="lx-line-style"></span>
                            </div>
                </div>
                <div class="layui-col-xs4" id="yicheng" >
                        <div class="lx-box-style">
                                <span class="lx-line-style"></span>
                                <span class="lx-text-style">主要议程</span>
                                <span class="lx-line-style"></span>
                        </div>
                </div>
                <div class="layui-col-xs2" id="zhuchiren" >
                    <div class="lx-box-style">
                            <span class="lx-line-style"></span>
                            <span class="lx-text-style">主持人</span>
                            <span class="lx-line-style"></span>
                    </div>
                </div>
                </div>
            <div class="layui-col-xs12" id="zhongxinzuxuexi">
                    <div class="layui-col-xs2" id="time" >
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">会议时间</span>
                                        <span class="lx-line-style"></span>
                                </div>
                    </div>
                    
                     <div class="layui-col-xs4" id="mingcheng" >
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">会议名称</span>
                                        <span class="lx-line-style"></span>
                                </div>
                    </div>
                    <div class="layui-col-xs4" id="yicheng" >
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">主要议程</span>
                                    <span class="lx-line-style"></span>
                            </div>
                    </div>
                    <div class="layui-col-xs2" id="zhuchiren" >
                        <div class="lx-box-style">
                                <span class="lx-line-style"></span>
                                <span class="lx-text-style">主持人</span>
                                <span class="lx-line-style"></span>
                        </div>
                    </div>
             </div>
            <div class="layui-col-xs12" id="zhurenzhutihui">
                        <div class="layui-col-xs2" id="time" >
                                    <div class="lx-box-style">
                                            <span class="lx-line-style"></span>
                                            <span class="lx-text-style">会议时间</span>
                                            <span class="lx-line-style"></span>
                                    </div>
                        </div>
                        
                         <div class="layui-col-xs4" id="mingcheng" >
                                    <div class="lx-box-style">
                                            <span class="lx-line-style"></span>
                                            <span class="lx-text-style">会议名称</span>
                                            <span class="lx-line-style"></span>
                                    </div>
                        </div>
                        <div class="layui-col-xs4" id="yicheng" >
                                <div class="lx-box-style">
                                        <span class="lx-line-style"></span>
                                        <span class="lx-text-style">主要议程</span>
                                        <span class="lx-line-style"></span>
                                </div>
                        </div>
                        <div class="layui-col-xs2" id="zhuchiren" >
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">主持人</span>
                                    <span class="lx-line-style"></span>
                            </div>
                        </div>
            </div>
            <div class="layui-col-xs12" id="dangweihui">
                <div class="layui-col-xs2" id="time" >
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">会议时间</span>
                                    <span class="lx-line-style"></span>
                            </div>
                </div>
                
                 <div class="layui-col-xs4" id="mingcheng" >
                            <div class="lx-box-style">
                                    <span class="lx-line-style"></span>
                                    <span class="lx-text-style">会议名称</span>
                                    <span class="lx-line-style"></span>
                            </div>
                </div>
                <div class="layui-col-xs4" id="yicheng" >
                        <div class="lx-box-style">
                                <span class="lx-line-style"></span>
                                <span class="lx-text-style">主要议程</span>
                                <span class="lx-line-style"></span>
                        </div>
                </div>
                <div class="layui-col-xs2" id="zhuchiren" >
                    <div class="lx-box-style">
                            <span class="lx-line-style"></span>
                            <span class="lx-text-style">主持人</span>
                            <span class="lx-line-style"></span>
                    </div>
                </div>
    </div>
    </div>







</div>

<script src="/seeyon/apps_res/nbd/layui/lx.js"></script>
<script src="/seeyon/apps_res/nbd/layui/apps/zrzx/menhu.js"></script>
</body>