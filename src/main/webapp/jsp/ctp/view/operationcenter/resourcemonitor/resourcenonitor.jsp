<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>info</title>
        <%@ include file="/WEB-INF/jsp/ctp/view/platview_common.jsp" %>
        <%@ include file="/WEB-INF/jsp/ctp/view/platview_header.jsp" %>
        <script type="text/javascript" src="${path}/common/js/echarts-all.js"></script>
        <script type="text/javascript">
        $(function(){
        	//界面效果 开始
        	$(".show_hide_table").hide();
        	   $("#show_hide_tables").on("click",function(){
        	        if($("#show_hide_tables").attr("checked")=="checked"){
        	            $(".show_hide_table").slideDown(500);
        	            $(".tables_hide").html("隐藏表格<em class='icon16 pc_up_16'></em>");
        	        }else{
        	            $(".show_hide_table").slideUp(500);
        	            $(".tables_hide").html("查看表格<em class='icon16 pc_down_16'></em>");
        	        }
        	       
        	   })
        	   $(".tables_hide").on("click",function(){
        	        if($(this).siblings(".show_hide_table").css("display")=="none"){
        	            $(this).siblings(".show_hide_table").slideDown(500);
        	            $(this).html("隐藏表格<em class='icon16 pc_up_16'></em>");
        	        }else{
        	            $(this).siblings(".show_hide_table").slideUp(500);
        	            $(this).html("查看表格<em class='icon16 pc_down_16'></em>");
        	        }
        	        
        	    })
        	  
        	   var _meter_length = $(".info_body .servise_info").length;;
        	   var _meter_width = $(".meter_infos").width();
        	   for(var i = 1; i<_meter_length; i++){
        	        var _meter_len = $(".servise_info").eq(2).find(".meter_img").length;
        	        var _num = Math.floor(_meter_width/350);
        	        var _right = Math.floor(_meter_width/_num)-284-10;
        	        $(".servise_info").eq(i).find(".meter_img").css("margin-right",_right);
        	        
        	    }
        	   
        	   
        	    window.onresize = function(){
        	        var _meter_length = $(".servise_info").length;
        	        var _meter_width = $(".meter_infos").width();
        	        for(var i = 1; i<_meter_length; i++){
        	            var _meter_len = $(".servise_info").eq(i).find(".meter_img").length;
        	            var _num = Math.floor(_meter_width/350);
        	            var _right = Math.floor(_meter_width/_num)-284;
        	            $(".servise_info").eq(i).find(".meter_img").css("margin-right",_right);
        	            
        	        }
        	   }
        	//界面效果 结束
        	var myChart = echarts.init(document.getElementById('onlineUser'), "macarons");
            var option = {
                tooltip : { formatter: "{a} <br/>{b} : {c}" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    max:${servernum},
                    min:0,
                    splitNumber:${onlineSplitNumber},
                    type:'gauge', 
                    detail : { formatter:'{value}' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}'
                    },
                    data:[{
                        value:${onlineUserNumber4Server}, 
                        name: 'PC在线用户数'
                    }]
                }]
            };
            myChart.setOption(option);
            <c:if test="${m1num > 0}">
            var myChart2 = echarts.init(document.getElementById('onlineUserM1'), "macarons");
            var option2 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'',
                    min:0,
                    splitNumber:${m1SplitNumber},
                    max:${m1num},
                    type:'gauge', 
                    detail : { formatter:'{value}' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}'
                    },
                    data:[{
                        value:${onlineUserNumber4ServerM1}, 
                        name: 'M1在线用户数'
                    }]
                }]
            };
            myChart2.setOption(option2);
            </c:if>
            var myChart3 = echarts.init(document.getElementById('physicalMem'), "macarons");
            var option3 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    type:'gauge', 
                    detail : { formatter:'{value}%' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}%'
                    },
                    data:[{
                        value:"${physicalMemValue}", 
                        name: 'OS物理内存'
                    }]
                }]
            };
            myChart3.setOption(option3);
            var myChart4 = echarts.init(document.getElementById('swapMem'), "macarons");
            var option4 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    type:'gauge', 
                    detail : { formatter:'{value}%' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}%'
                    },
                    data:[{
                        value:"${swapMemVaue}", 
                        name: 'OS交换内存空间'
                    }]
                }]
            };
            myChart4.setOption(option4);
            var myChart5 = echarts.init(document.getElementById('heapMemory'), "macarons");
            var option5 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    type:'gauge', 
                    detail : { formatter:'{value}%' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}%'
                    },
                    data:[{
                        value:${oldPerc}, 
                        name: 'JVM堆内存'
                    }]
                }]
            };
            myChart5.setOption(option5);
            var myChart6 = echarts.init(document.getElementById('unheapMemory'), "macarons");
            var option6 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    type:'gauge', 
                    detail : { formatter:'{value}%' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}%'
                    },
                    data:[{
                        value:${perPerc}, 
                        name: 'JVM非堆内存'
                    }]
                }]
            };
            myChart6.setOption(option6);
            <c:if test="${ctpConMax>0}">
            var myChart7 = echarts.init(document.getElementById('conarea'), "macarons");
            var option7 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    max:${ctpConMax},
                    min:0,
                    splitNumber:${onlineSplitNumber},
                    type:'gauge', 
                    detail : { formatter:'{value}' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}'
                    },
                    data:[{
                        value:${ctpConNouse}, 
                        name: '数据库连接空闲率'
                    }]
                }]
            };
            myChart7.setOption(option7);
            </c:if>
            <c:if test="${attFlag }">
            var myChart8 = echarts.init(document.getElementById('attarea'), "macarons");
            var option8 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    type:'gauge', 
                    detail : { formatter:'{value}%' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}%'
                    },
                    data:[{
                        value:${attRatio}, 
                        name: '附件空间使用率'
                    }]
                }]
            };
            myChart8.setOption(option8);
            </c:if>
            <c:if test="${appFlag }">
            var myChart9 = echarts.init(document.getElementById('apparea'), "macarons");
            var option9 = {
                tooltip : { formatter: "{a} <br/>{b} : {c}%" },
                series : [{ 
                    startAngle:180,
                    endAngle:0,
                    radius:[0,'100%'],
                    name:'', 
                    type:'gauge', 
                    detail : { formatter:'{value}%' },
                    detail:{
                        show : true,
                        offsetCenter: [0, '5%'],
                        formatter: '{value}%'
                    },
                    data:[{
                        value:${appRatio}, 
                        name: '应用程序空间使用率'
                    }]
                }]
            };
            myChart9.setOption(option9);
            </c:if>
        });
        </script>
    </head>
    <body class="body_infos">
        <div class="info_body">
            <span class="hide_table_handle">
                <input type="checkbox" id="show_hide_tables">
                查看所有隐藏表格
            </span>
            <div class="servise_info">
                <h1>服务运行信息</h1>
                 <table class="info_table" border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="blue_td">当前系统时间</td>
                        <td>${currentDateString }</td>
                    </tr>
                     <tr>
                        <td class="blue_td">服务启动时间</td>
                        <td>${serverStartTimeString }</td>
                    </tr>
                     <tr>
                        <td class="blue_td">运行时长</td>
                        <td>${serverRunTimeString }</td>
                    </tr>
                     <tr>
                        <td class="blue_td">CPU时长</td>
                        <td>${processCPUTimeString }</td>
                    </tr>
                </table>
            </div>
             <div class="servise_info">
                <h1>在线信息</h1>
                <div class="meter_infos">
                    <span class="meter_img echartsarea">
                        <!-- <img src="${path}/common/platview/img/meter.png"> -->
                        <div id="onlineUser" style="height:300px;width:310px;"></div>
                    </span>
                    <span class="meter_img echartsarea">
                        <div id="onlineUserM1" style="height:300px;width:310px;"></div>
                    </span>
                </div>
                <span class="tables_hide">查看表格<em class="icon16 pc_up_16"></em></span>
                <table class="info_table show_hide_table" border="0" cellspacing="0" cellpadding="0" width="100%">
                     <tr>
                        <td class="blue_td" width="16%">操作系统</td>
                        <td class="blue_td" width="28%">版本</td>
                        <td class="blue_td" width="28%">位数</td>
                        <td class="blue_td" width="28%">CPU个数（核心数）</td>
                    </tr>
                    <tr>
                        <td>${osname }</td>
                        <td>${osversion }</td>
                        <td>${osarch }</td>
                        <td>${processors }</td>
                    </tr>
                </table>
            </div>
            <div class="servise_info">
                <h1>内存信息</h1>
                <div class="meter_infos">
                    <span class="meter_img echartsarea">
                        <div id="physicalMem" style="height:300px;width:310px;"></div>
                    </span>
                    <span class="meter_img echartsarea">
                        <div id="swapMem" style="height:300px;width:310px;"></div>
                    </span>
                    <span class="meter_img echartsarea">
                        <div id="heapMemory" style="height:300px;width:310px;"></div>
                    </span>
                    <span class="meter_img echartsarea">
                        <div id="unheapMemory" style="height:300px;width:310px;"></div>
                    </span>
                </div>
                <span class="tables_hide">查看表格<em class="icon16 pc_down_16"></em></span>
                <table class="info_table show_hide_table" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="blue_td" width='10%'>类型</td>
                        <td class="blue_td" width='12%'>详细</td>
                        <td class="blue_td" width='11%'>初始值</td>
                        <td class="blue_td" width='11%'>已使用</td>
                        <td class="blue_td" width='11%'>最大值</td>
                        <td class="blue_td" width='11%'>提交值</td>
                        <td class="blue_td" width='11%'>峰值</td>
                        <td class="blue_td" width='11%'>使用率</td>
                        <td class="blue_td" width='11%'>峰值率</td>
                    </tr>
                    <c:forEach items="${memPoolList }" var="tempm">
                         <tr>
                             <td>${tempm[0] }</td>
                             <td>${tempm[1] }</td>
                             <td>${tempm[2] }</td>
                             <td>${tempm[3] }</td>
                             <td>${tempm[4] }</td>
                             <td>${tempm[5] }</td>
                             <td>${tempm[6] }</td>
                             <td>${tempm[7] }</td>
                             <td>${tempm[8] }</td>
                         </tr>
                    </c:forEach>
                </table>
            </div>
            <div class="servise_info">
                <h1>空间监控信息</h1>
                <div class="meter_infos">
                    <c:if test="${ctpConMax>0}">
                    <span class="meter_img echartsarea">
                        <div id="conarea" style="height:300px;width:310px;"></div>
                    </span>
                    </c:if>
                    <span class="meter_img echartsarea">
                        <div id="attarea" style="height:300px;width:310px;"></div>
                    </span>
                    <span class="meter_img echartsarea">
                        <div id="apparea" style="height:300px;width:310px;"></div>
                    </span>
                </div>
                <c:if test="${ctpConMax>0}">
                <span class="tables_hide">查看表格<em class="icon16 pc_up_16"></em></span>
                <table class="info_table show_hide_table" border="0" cellspacing="0" cellpadding="0" width="100%">
                     <tr>
                        <td class="blue_td" width="16%">Type</td>
                        <td class="blue_td" width="28%">Max threads</td>
                        <td class="blue_td" width="28%">Current count</td>
                        <td class="blue_td" width="28%">Current busy</td>
                    </tr>
                    <c:forEach items="${threadmsg }" var="thm">
                    <tr>
                        <td>${thm[0] }</td>
                        <td>${thm[1] }</td>
                        <td>${thm[2] }</td>
                        <td>${thm[3] }</td>
                    </tr>
                    </c:forEach>
                </table>
                </c:if>
            </div>
        </div>
    </body>
</html>
