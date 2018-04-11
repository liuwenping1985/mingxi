<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
	<link rel="stylesheet" href="/seeyon/apps_res/m3/css/index.css">
    <title></title>
    <script src="/seeyon/apps_res/m3/js/echarts.js"></script>
</head>
<body class="h100b">
<div class="comp" comp="type:'breadcrumb',code:'m3_monitoring'"></div> 
	<!-- 内容容器 start-->
	<div class="container">
		<!-- 第一部分——整体概要 start -->
		<div class="outline">
			<div class="outline_top">
				<p>${ctp:i18n('MobileStatistic.som.index.outline_top')}</p>
				<span class="outline_top_time"></span>
				<span>${ctp:i18n('MobileStatistic.som.index.outline_top_time')}：</span>
			</div>
			<div class="outline_bottom">
				<ul>
					<li class="outline_bottom_li1">
						<p class="outline_bottom_num1"></p>
						<span>${ctp:i18n('MobileStatistic.som.index.cumulativeUsers')}</span>
					</li>
					<li class="outline_bottom_li2">
						<p class="outline_bottom_num2"></p>
						<span>${ctp:i18n('MobileStatistic.som.index.sevenDaysActiveUsers')}</span>
					</li>
					<li class="outline_bottom_li3">
						<p class="outline_bottom_num3"></p>
						<span>${ctp:i18n('MobileStatistic.som.index.30DaysActiveUsers')}</span>
					</li>
					<li class="outline_bottom_li4">
						<p class="outline_bottom_num4"></p>
						<span>${ctp:i18n('MobileStatistic.som.index.7DaysAverageActiveUser')}</span>
					</li>
				</ul>
			</div>
		</div>
		<!-- 第一部分——整体概要 enf -->
		<!-- 第二部分——实时统计 start -->
		<div class="statistics">
			<div class="sta_top">
				<p>${ctp:i18n('MobileStatistic.som.index.AccessRealTimeStatistics')}</p>
				<div>
					<em class="refresh"></em>
				</div>
			</div>
			<div class="sta_bottom">
				<div class="sta_bottom_left">
					<ul>
						<li class="sta_bottom_right_li1" data-i="yesterday">${ctp:i18n('MobileStatistic.login.record.date.yesterday')}</li>
						<li class="sta_bottom_right_li2 hover" data-i="today">${ctp:i18n('MobileStatistic.login.record.date.today')}</li>
					</ul>
				</div>
				<div class="sta_bottom_right">
					<ul>
						<li>
							<span>${ctp:i18n('MobileStatistic.som.index.numberOfStarts')}</span>
							<span class="someDay">(${ctp:i18n('MobileStatistic.login.record.date.today')})：</span>
							<span class="num1"></span>
						</li>
						<li>
							<span>${ctp:i18n('MobileStatistic.som.index.newUsers')}</span>
							<span class="someDay">(${ctp:i18n('MobileStatistic.login.record.date.today')})：</span>
							<span class="num2"></span>
						</li>
						<li>
							<span>${ctp:i18n('MobileStatistic.som.index.activeUser')}</span>
							<span class="someDay">(${ctp:i18n('MobileStatistic.login.record.date.today')})：</span>
							<span class="num3"></span>
						</li>
					</ul>
				</div>
				<div class="lineChart1" id="chart1"></div>
			</div>
		</div>
		<!-- 第二部分——实时统计 end -->
		<!-- 第三部分——整体趋势 start -->
		<div class="trend">
			<div class="trend_top">
				<p>${ctp:i18n('MobileStatistic.som.index.accessOverallTrend')}</p>
				<div class="timeControl">
				${ctp:i18n('MobileStatistic.som.index.startTime')}：<input id="fromdate" type="text"  class="comp" comp="type:'calendar',dateString:'2012-12-16 17:59',onUpdate:checkfrom,ifFormat:'%Y-%m-%d %H:%M',showsTime:true,cache:false"/>
${ctp:i18n('MobileStatistic.som.index.endTime')}：<input id="todate" type="text" value="2012-12-16 17:59" class="comp" comp="type:'calendar',onUpdate:checkto,ifFormat:'%Y-%m-%d %H:%M',showsTime:true,cache:false"/>
				</div>
			</div>
			<div class="trend_bottom">
				<div class="trend_bottom_top">
					<ul>
						<li class="trend_bottom_top_li1 hover" data-i="day7">${ctp:i18n('MobileStatistic.som.index.lastSevenDays')}</li>
						<li data-i="day30">${ctp:i18n('MobileStatistic.som.index.nearly30Days')}</li>
						<li data-i="day60">${ctp:i18n('MobileStatistic.som.index.nearly60Days')}</li>
					</ul>
				</div>
				<div class="trend_bottom_bottom">
					<ul>
						<li class="hover" data-i="startupCount">
							<span>${ctp:i18n('MobileStatistic.som.index.numberOfStarts')}</span>
						</li>
						<li data-i="activeUser">
							<span>${ctp:i18n('MobileStatistic.som.index.activeUser')}</span>
						</li>
						<li data-i="becomeUser">
							<span>${ctp:i18n('MobileStatistic.som.index.newUsers')}</span>
						</li>
					</ul>
				</div>
				<div class="lineChart2" id="chart2"></div>
			</div>
		</div>
		<!-- 第三部分——整体趋势 end -->
		<!-- 第四部分——排行 start -->
		<div class="number">
			<div class="num_top">
				<p>${ctp:i18n('MobileStatistic.som.index.ranking')}</p>
			</div>
			<div class="num_bottom">
				<div class="num_bottom_left">
					<ul>
						<li class="num_bottom_left_top">
							<div class="num_bm_lt_tp_tp">
								<p>
									<em></em>
									<span>${ctp:i18n('MobileStatistic.som.index.applicationAccessRanking')}</span>
								</p>
								<ul class="number_ul1">
									<li class="num_bm_lt_tp_tp_li1" data-i="yesterday">${ctp:i18n('MobileStatistic.login.record.date.yesterday')}</li>
									<li class="hover" data-i="today">${ctp:i18n('MobileStatistic.login.record.date.today')}</li>
									<li data-i="day7">${ctp:i18n('MobileStatistic.som.index.lastSevenDays')}</li>
									<li class="num_bm_lt_tp_tp_li4" data-i="day30">${ctp:i18n('MobileStatistic.som.index.nearly30Days')}</li>
								</ul>
							</div>
							<div class="num_bm_lt_tp_bm width_500">
								<ul>
									<li class="num_bm_lt_tp_bm_li1">${ctp:i18n('MobileStatistic.som.index.ranking')}</li>
									<li class="num_bm_lt_tp_bm_li2">${ctp:i18n('MobileStatistic.som.index.application')}</li>
									<li class="num_bm_lt_tp_bm_li3">${ctp:i18n('MobileStatistic.som.index.numberOfVisits')}</li>
									<li class="num_bm_lt_tp_bm_li4"><a>${ctp:i18n('MobileStatistic.som.index.viewAll')}</a></li>
								</ul>
							</div>
						</li>
						<li class="num_bottom_left_bottom" id="table_bar1"></li>
						<div class="lineChart3" id="chart3_1"></div>
					</ul>
				</div>
				<div class="num_bottom_right">
					<ul>
						<li class="num_bottom_left_top">
							<div class="num_bm_lt_tp_tp">
								<p>
									<em></em>
									<span class="isGroup"></span>
								</p>
								<ul class="number_ul2">
									<li class="num_bm_lt_tp_tp_li1" data-i="yesterday">${ctp:i18n('MobileStatistic.login.record.date.yesterday')}</li>
									<li class="hover" data-i="today">${ctp:i18n('MobileStatistic.login.record.date.today')}</li>
									<li data-i="day7">${ctp:i18n('MobileStatistic.som.index.lastSevenDays')}</li>
									<li data-i="day30">${ctp:i18n('MobileStatistic.som.index.nearly30Days')}</li>
								</ul>
							</div>
							<div class="num_bm_lt_tp_bm width_463">
								<ul>
									<li class="num_bm_lt_tp_bm_li1">${ctp:i18n('MobileStatistic.som.index.ranking')}</li>
									<li class="num_bm_lt_tp_bm_li2"></li>
									<li class="num_bm_lt_tp_bm_li3">${ctp:i18n('MobileStatistic.som.index.numberOfVisits')} </li>
									<li class="num_bm_lt_tp_bm_li4"><a>${ctp:i18n('MobileStatistic.som.index.viewAll')}</a></li>
								</ul>
							</div>
						</li>
						<li class="num_bottom_left_bottom" id="table_bar2"></li>
						<div class="lineChart3" id="chart3_2"></div>
					</ul>
				</div>
			</div>
		</div>
		<!-- 第四部分——排行 end -->
		<!-- 第五部分——访问分布 start -->
		<div class="distribution">
			<div class="distr_top">
				<p>${ctp:i18n('MobileStatistic.som.index.clientAccessDistribution')}</p>
			</div>
			<div class="distr_bottom">
				<div class="distr_bottom_top">
					<ul>
						<li class="distr_bottom_top_li1" data-i="yesterday">${ctp:i18n('MobileStatistic.login.record.date.yesterday')}</li>
						<li class="hover" data-i="today">${ctp:i18n('MobileStatistic.login.record.date.today')}</li>
						<li data-i="day7">${ctp:i18n('MobileStatistic.som.index.lastSevenDays')}</li>
						<li data-i="day30">${ctp:i18n('MobileStatistic.som.index.nearly30Days')}</li>
					</ul>
				</div>
				<div class="lineChart4" id="chart4"></div>
			</div>
		</div>
		<!-- 第五部分——访问分布 end -->
	</div>
	<!-- 内容容器 end-->
</body>
<script type="text/javascript"
src="${path}/ajax.do?managerName=orgManager"></script>
<script type="text/javascript">
	var fromClientType = "${fromClientType}";
	
	var http = location.href.split("//")[0];
	var href = location.href.split("//")[1].split("/")[0];

	var fDate = null , tDate = null;

	ajax("get",http+"//"+href+"/seeyon/rest/m3/statistics/isGroup",true,true,"json",function(res){
		var isGroup = res.data.isGroup;
		var sp = $(".isGroup");
		var li = $(".width_463").find(".num_bm_lt_tp_bm_li2");
		if(isGroup == "true"){
			sp.html("${ctp:i18n('MobileStatistic.som.index.companiesActiveRanking')}");
			li.html("${ctp:i18n('MobileStatistic.som.index.company')}");
		}else{
			sp.html("${ctp:i18n('MobileStatistic.som.index.departmentActiveRanking')}");
			li.html("${ctp:i18n('MobileStatistic.som.index.department')}");
		}
	});

	//加载时间控件
	$(function(){
	    var date=new Date();
	    var fromDate=date.print("%Y-%m-%d %H:%M");
	    toDate=date.getTime() + 1800000;//结束时间：默认显示当前时间加30分钟
	    $("#fromdate").val(fromDate);//开始时间：默认显示当前时间
	    $("#todate").val(new Date(toDate).print("%Y-%m-%d %H:%M"));
	})
	function checkfrom(obj){
	    var beginDate = $("#fromdate").attr("value");//初始时间 string
	    var endDate = $("#todate").attr("value");//结束时间 string
	    var p=obj.params;
	    var format=p.ifFormat;//日期格式
	    var now=new Date().print(format);//当前时间
	    var formDate=obj.date;//开始时间对象
	    var update = (obj.dateClicked || p.electric);
	    if (update && p.singleClick && obj.dateClicked){//判断日历是否关闭
	        if(beginDate>now&&beginDate!=endDate){      //如果开始时间大于当前时间且不等于结束时间  
	            var toDate=formDate.getTime() + 1800000//结束时间加30分钟
	            $("#todate").val(new Date(toDate).print(format));
	        }
	    }
	    fDate = formDate.getTime()+'';
	    if(!fDate){
	    	alert("${ctp:i18n('MobileStatistic.som.index.selectStartTime')}");
	    }
	}
	function checkto(obj){
	    var endDate = $("#todate").attr("value");//结束时间 string
	    var p=obj.params;
	    var format=p.ifFormat;//日期格式
	    var now=new Date().print(format);//当前时间
	    var toDate=initDate(endDate);//结束时间对象
	    var update = (obj.dateClicked || p.electric);
	    if (update && p.singleClick && obj.dateClicked){//判断日历是否关闭
	        if(endDate<now){    //如果结束时间小于开始时间      
	            var formDate=toDate.getTime() - 1800000//开始时间减30分钟
	            $("#fromdate").val(new Date(formDate).print(format))
	        }
	    }
	    tDate = toDate.getTime()+'';
	    //发送给后台用户选取的时间段
	    if(tDate&&fDate&&(tDate-fDate>86400000)){
	    	var n = null;//用来传递状态：启动次数，活跃用户，新增用户
		    $(".trend_bottom_bottom>ul>li").each(function(){
		    	if($(this).attr("class")=='hover'){
		    		var data_i = $(this).attr("data-i");
		    		switch(data_i){
		    			case 'startupCount':
		    				n = 0;
		    				break;
		    			case 'activeUser':
		    				n = 2;
		    				break;
		    			case 'becomeUser':
		    				n = 1;
		    				break;
		    		}
		    	}
		    });
		    ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=5&searchType="+n+"&startDate="+fDate+"&endDate="+tDate+"&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
	    }else if(!tDate){
	    	alert("${ctp:i18n('MobileStatistic.som.index.selectEndTime')}");
	    }else{
	    	alert("${ctp:i18n('MobileStatistic.som.index.leastOneDay')}");
	    }
	}
	

	//以下为加载图表

    function chart(id,option){
		// 基于准备好的dom，初始化echarts实例
	    var myChart = echarts.init(document.getElementById(id));

	    // 指定图表的配置项和数据
	    var option = option;

	    // 使用刚指定的配置项和数据显示图表。
	    myChart.setOption(option);
	}
    function ajax(type,url,async,cache,dataType,fun){
  		$.ajax({
		    type:type,
		    url:url,
		    async:async||true,
		    cache:cache,
		    dataType:dataType,
		    success:fun,
		    error:function(res){
		    	alert("${ctp:i18n('MobileStatistic.som.index.dataException')}");
		    }
		});
  	}
  	function application_success(data){
  		$(".outline_top_time").html(data.data.statisticStartTime);
    	$(".outline_bottom_num1").html(data.data.totalUser);
    	$(".outline_bottom_num2").html(data.data.ActiveUser_7);
    	$(".outline_bottom_num3").html(data.data.ActiveUser_30);
    	$(".outline_bottom_num4").html(data.data.AverageActiveUser_7);
  	}
  	function line1_today_success(data){
  		$('#chart1').html("");
  		$(".sta_bottom_right .num1").html(data.data.startups);
    	$(".sta_bottom_right .num2").html(data.data.increaments);
    	$(".sta_bottom_right .num3").html(data.data.actives);
    	var xAxis_data = [];
    	var series_data = [];
    	var option = {
    		grid:{
    			show:false,
    			left:80,
    			right:60
    		},
	  	  	tooltip : {
		        trigger: 'item',
		        showDelay: 0,
		        hideDelay: 50,
		        transitionDuration:0,
		        backgroundColor : 'rgba(251,251,251,1)',
		        borderColor : '#6eb5e5',
		        borderRadius : 5,
		        borderWidth: 2,
		        padding: 5,    // [5, 10, 15, 20]
		        position : function(p) {
		            // 位置回调
		            return [p[0] + 10, p[1] - 10];
		        },
		        axisPointer:{
		        	type:'cross'
		        },
		        formatter: '{b} : {c}',
		        textStyle : {
		            color: '#2b3e4f',
		            decoration: 'none',
		            fontSize: 12,
		            fontWeight: 'bold'
		        }
			},
	    	//设置坐标轴
	      	xAxis : {
	      		type : 'category',
	      		axisTick : {
	      			show:false,	
	      		},
	      		boundaryGap : false,
	      		axisLabel : {
	      			show : true,
	      			interval : 'auto',
	      			margin:15,
	      			textStyle:{
	      				color:'#999'
	      			}
	      		},
	      		axisLine:{
	      			show:true,
	      			onZero:true,
	      			lineStyle:{
	      				color:'#eee'
	      			}
	      		},
	      		data : xAxis_data
	    	},
	      	yAxis : {
	      		type : 'value',
	      		min : 0,
	      		max : 0,
	      		axisTick : {
	      			show:false,	
	      		},
	      		axisLabel : {
	      			show : true,
	      			interval : 'auto',
	      			textStyle:{
	      				color:'#999'
	      			}
	      		},
	      		axisLine:{
	      			show:true,
	      			onZero:true,
	      			lineStyle:{
	      				color:'#eee'
	      			}
	      		},
	      		splitNumber : 5,
	    	},
	      	//设置数据
	      	series : [
	        	{
	          		type:"line",
	          		lineStyle:{
	          			normal: {
				      		type:'solid',
				    		width:4,
				    		color:"#92cbf1"
				    	}
			    	},
					areaStyle: {
						normal:{
							color:'#dcedf8'
						}
					},
					smooth:true,
					symbol:'emptyCircle',
					symbolSize:10,
					showAllSymbol:true,
					itemStyle:{
						normal:{
							color:"#92cbf1"
						}
					},
					markLine:{
						lineStyle:{
							normal:{
								color:'#eee'
							}
						}
					},
					data:series_data
	        	}
	      	]
	    };
    	for(var i=0;i<data.data.data.length;i++){
    		for(var key in data.data.data[i]){
    			xAxis_data.push(key+"${ctp:i18n('MobileStatistic.som.index.hour')}");
    			series_data.push(data.data.data[i][key]);
    		}
    	}
    	if(data.data.maxY>5){
			switch(data.data.maxY%5){
				case 0 :
					option.yAxis.max = data.data.maxY;
    				break;
    			case 1 :
    				option.yAxis.max = data.data.maxY+4;
    				break;
    			case 2 :
    				option.yAxis.max = data.data.maxY+3;
    				break;
    			case 3 :
    				option.yAxis.max = data.data.maxY+2;
    				break;
    			case 4 :
    				option.yAxis.max = data.data.maxY+1;
    				break;
			}
    	}else{
    		option.yAxis.max = 5;
    	}
    	chart('chart1',option);
  	}
  	function line2_day7_success(data){
  		$('#chart2').html("");
  		var xAxis_data = [];
    	var series_data = [];
    	var option = {
    		grid:{
    			show:false,
    			left:80,
    			right:60
    		},
	  	  	tooltip : {
		        trigger: 'item',
		        showDelay: 0,
		        hideDelay: 50,
		        transitionDuration:0,
		        backgroundColor : 'rgba(251,251,251,1)',
		        borderColor : '#6eb5e5',
		        borderRadius : 5,
		        borderWidth: 2,
		        padding: 5,    // [5, 10, 15, 20]
		        position : function(p) {
		            // 位置回调
		            return [p[0] + 10, p[1] - 10];
		        },
		        axisPointer:{
		        	type:'cross'
		        },
		        formatter: '{b} : {c}',
		        textStyle : {
		            color: '#2b3e4f',
		            decoration: 'none',
		            fontSize: 12,
		            fontWeight: 'bold'
		        }
			},
	    	//设置坐标轴
	      	xAxis : {
	      		type : 'category',
	      		axisTick : {
	      			show:false,	
	      		},
	      		boundaryGap : false,
	      		axisLabel : {
	      			show : true,
	      			interval : 'auto',
	      			margin:15,
	      			textStyle:{
	      				color:'#999'
	      			}
	      		},
	      		axisLine:{
	      			show:true,
	      			onZero:true,
	      			lineStyle:{
	      				color:'#eee'
	      			}
	      		},
	      		data : xAxis_data
	    	},
	      	yAxis : {
	      		type : 'value',
	      		min : 0,
	      		max : 0,
	      		axisTick : {
	      			show:false,	
	      		},
	      		axisLabel : {
	      			show : true,
	      			interval : 'auto',
	      			textStyle:{
	      				color:'#999'
	      			}
	      		},
	      		axisLine:{
	      			show:true,
	      			onZero:true,
	      			lineStyle:{
	      				color:'#eee'
	      			}
	      		},
	      		splitNumber : 5,
	    	},
	      	//设置数据
	      	series : [
	        	{
	          		type:"line",
	          		lineStyle:{
	          			normal: {
				      		type:'solid',
				    		width:4,
				    		color:"#f98a74"
				    	}
			    	},
					areaStyle: {
						normal:{
							color:'#f9c3ba'
						}
					},
					smooth:true,
					symbol:'emptyCircle',
					symbolSize:10,
					showAllSymbol:true,
					itemStyle:{
						normal:{
							color:"#f98a74"
						}
					},
					markLine:{
						lineStyle:{
							normal:{
								color:'#eee'
							}
						}
					},
					data:series_data
	        	}
	      	]
	    };
		if(data.data.maxY>5){
			switch(data.data.maxY%5){
				case 0 :
					option.yAxis.max = data.data.maxY;
    				break;
    			case 1 :
    				option.yAxis.max = data.data.maxY+4;
    				break;
    			case 2 :
    				option.yAxis.max = data.data.maxY+3;
    				break;
    			case 3 :
    				option.yAxis.max = data.data.maxY+2;
    				break;
    			case 4 :
    				option.yAxis.max = data.data.maxY+1;
    				break;
			}
    	}else{
    		option.yAxis.max = 5;
    	}
		for(var i=0;i<data.data.data.length;i++){
    		for(var key in data.data.data[i]){
    			xAxis_data.push(key);
    			series_data.push(data.data.data[i][key]);
    		}
    	}
    	chart('chart2',option);
  	}
  	function bar1_today_success(data){
  		$("#chart3_1").html("");
  		var yAxis_data = [];
    	var series_data = [];
    	var option = {
    		grid:{
    			show:false,
    			left:80
    		},
	    	//设置坐标轴
	      	xAxis : {
	      		type : 'value',
	      		show : false,
	      		min : 0,
	      		max : 0,
	      		axisLine:{
	      			show:false
	      		},
	      		splitLine:{
	      			show:false
	      		},
	      		axisTick:{
	      			show:false
	      		}
	    	},
	      	yAxis : {
	      		type : 'category',
	      		show : false,
	      		boundaryGap : 'false',
	      		splitLine:{
	      			show:false
	      		},
	      		axisLine:{
	      			show:false
	      		},
	      		position:'left',
	      		axisTick:{
	      			show:false
	      		},
	      		data : yAxis_data
	    	},
	      	//设置数据
	      	series : [
	        	{
	        		type:"bar",
	          		label:{
	          			normal:{
	          				show:true,
	          				position:'insideBottomRight',
	          				textStyle:{
				        		color:'#fff',
				        		fontSize:16,
				        		fontWeight:'bold'
				        	}
	          			},
	          			emphasis: {
					        textStyle:{
				        		color:'#fff',
				        		fontSize:16,
				        		fontWeight:'bold'
				        	}
					    }
			        },
	          		itemStyle: {
					    normal: {
					        color:'#5793f3'
					    },
					    emphasis: {
					        color:'#d24a61'
					    }
					},
					barMaxWidth:18,
					data:series_data
	        	}
	      	]
	    };
	    if(data.data.length){
	    	var arr = data.data.slice(0,5);
	  		for(var i=0,tr="";i<arr.length;i++){
	  			tr=tr+"<tr><td class='bar1_td1'>"+(i+1)+"</td><td class='bar1_td2'>"+arr[i].appName+"</td><td class='bar1_td3'></td>";
	  		}
	  		var html = $("#table_bar1")[0].innerHTML = "<table class='bar1_table'><tbody>"+tr+"</tbody></table>";
	  		option.xAxis.max = data.data[0].count;
	  		for(var i=arr.length;i>=arr.length-5;i--){
	  			for(var key in arr[i]){
	    			if(key=='appName'){
	    				yAxis_data.push(arr[i][key]);
	    			}else if(key=='count'){
	    				series_data.push(arr[i][key]);
	    			}
	    		}
	    	}
	    	$(".lineChart3").height($(".bar1_table").height() + 117 + 'px');
	    	chart('chart3_1',option);
	    }else{
	    	$("#table_bar1").css({
	          'padding-top':'140px',
	          'text-align':'center',
	        }).html("${ctp:i18n('MobileStatistic.som.index.noData')}");
	    }
  	}
  	function bar2_today_success(data){
  		$("#chart3_2").html("");
  		var yAxis_data = [];
    	var series_data = [];
    	var option = {
    		grid:{
    			show:false,
    			left:80
    		},
	    	//设置坐标轴
	      	xAxis : {
	      		type : 'value',
	      		show : false,
	      		min : 0,
	      		max : 0,
	      		axisLine:{
	      			show:false
	      		},
	      		splitLine:{
	      			show:false
	      		},
	      		axisTick:{
	      			show:false
	      		}
	    	},
	      	yAxis : {
	      		type : 'category',
	      		show : false,
	      		boundaryGap : 'false',
	      		splitLine:{
	      			show:false
	      		},
	      		axisLine:{
	      			show:false
	      		},
	      		position:'left',
	      		axisTick:{
	      			show:false
	      		},
	      		data : yAxis_data
	    	},
	      	//设置数据
	      	series : [
	        	{
	        		type:"bar",
	          		label:{
	          			normal:{
	          				show:true,
	          				position:'insideBottomRight',
	          				textStyle:{
				        		color:'#fff',
				        		fontSize:16,
				        		fontWeight:'bold'
				        	}
	          			},
	          			emphasis: {
					        textStyle:{
				        		color:'#fff',
				        		fontSize:16,
				        		fontWeight:'bold'
				        	}
					    }
			        },
	          		itemStyle: {
					    normal: {
					        color:'#5793f3'
					    },
					    emphasis: {
					        color:'#d24a61'
					    }
					},
					barMaxWidth:18,
					data:series_data
	        	}
	      	]
	    };
		if(data.data.length){
	    	var arr = data.data.slice(0,5);
	  		for(var i=0,tr="";i<arr.length;i++){
	  			tr=tr+"<tr><td class='bar2_td1'>"+(i+1)+"</td><td class='bar2_td2'>"+arr[i].departmentName+"</td><td class='bar2_td3'></td>";
	  		}
	  		var html = $("#table_bar2")[0].innerHTML = "<table class='bar2_table'><tbody>"+tr+"</tbody></table>";
	  		option.xAxis.max = data.data[0].count;
	  		for(var i=arr.length;i>=arr.length-5;i--){
	  			for(var key in arr[i]){
	    			if(key=='departmentName'){
	    				yAxis_data.push(arr[i][key]);
	    			}else if(key=='count'){
	    				series_data.push(arr[i][key]);
	    			}
	    		}
	    	}
	    	$(".lineChart3").height($(".bar2_table").height() + 117 + 'px');
  			chart('chart3_2',option);
	    }else{
	    	$("#table_bar2").css({
	          'padding-top':'140px',
	          'text-align':'center',
	        }).html("${ctp:i18n('MobileStatistic.som.index.noData')}");
	    }
  	}
  	function pie_today_success(data){
  		$('#chart4').html("");
  		pie_series_data = [];
  		var option = {
	    	color:['#fd4b63','#9a8ccc'],
	    	tooltip : {
	    		trigger: 'item',
		        showDelay: 0,
		        hideDelay: 50,
		        transitionDuration:0,
		        backgroundColor : 'rgba(251,251,251,1)',
		        borderColor : '#9182c8',
		        borderRadius : 0,
		        borderWidth: 1,
		        padding: 10,    // [5, 10, 15, 20]
		        position : function(p) {
		            // 位置回调
		            return [p[0] + 10, p[1] - 10];
		        },
		        axisPointer:{
		        	type:'cross'
		        },
		        textStyle : {
		            color: '#2b3e4f',
		            decoration: 'none', 
		            fontSize: 14,
		            
		        },
		        formatter: '<span style="font-size:16px;">{b}</span><br/>${ctp:i18n("MobileStatistic.som.index.quantity")}:{c} | ${ctp:i18n("MobileStatistic.som.index.proportion")}:({d}%)'
	    	},
	      	//设置数据
	      	series : [
	        	{
	                type:'pie',
	                center: ['50%', '45%'],
	                radius: ['25%','50%'],
	                selectedMode:'single',
	                data:pie_series_data,
	                itemStyle: {
					    normal: {
					        borderColor:"#e9e6f4",
					        borderWidth:4
					    }
					},
					label:{
						normal:{
							show:true,
				        	position:'outside',
				        	textStyle:{
				        		fontSize:16,
				        		fontWeight:'bold'
				        	}
						}
			        },
			        labelLine:{
			        	normal:{
			        		show:true,
			        		length:20,
			        		smooth:0.5
			        	}
			        }
	        	}
	      	],

	    };
	    var obj1 = {}, obj2 = {};
  		obj1.name = 'Android';
  		obj1.value = data.data.android;
  		obj2.name = 'IOS';
  		obj2.value = data.data.ios;
  		pie_series_data.push(obj1);
  		pie_series_data.push(obj2);
	    chart('chart4',option);
  	}
  	

    //接口1：应用整体概要
  	ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/whole/1?fromClientType="+fromClientType,true,true,"json",application_success);

  	//接口2：访问实时统计
	ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=1&searchType=0&fromClientType=${fromClientType}",true,true,"json",line1_today_success);

    //接口2：访问整体趋势
    ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=2&searchType=0&fromClientType=${fromClientType}",true,true,"json",line2_day7_success);

	//接口3：排行左半边
    ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/appClick/0?dateType=1&fromClientType=${fromClientType}",true,true,"json",bar1_today_success);

    //接口4：排行右半边
    ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/departActive/0?dateType=1&fromClientType=${fromClientType}",true,true,"json",bar2_today_success);

    //接口5：客户端访问分布
    ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/clientType/-1?dateType=1&fromClientType=${fromClientType}",true,true,"json",pie_today_success);
					

    //访问实时统计图表切换
    $(".sta_bottom_left>ul>li").on('click',function(){
    	//切换字体颜色
    	$(this).parent().children("li").removeClass("hover");
    	!$(this).hasClass("hover")&&$(this).addClass("hover");
    	//图表切换
    	switch($(this).attr("data-i")){
			case 'today':
				$("#chart1").html("");
				ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=1&searchType=0&fromClientType="+fromClientType,false,true,"json",line1_today_success);
				break;
			case 'yesterday':
				$("#chart1").html("");
				ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=0&searchType=0&fromClientType="+fromClientType,false,true,"json",line1_today_success);
				break;
		}
    	
    });
    //访问实时统计图表刷新
    $(".refresh").on('click',function(){
    	$(".sta_bottom_left>ul>li").each(function(){
    		if($(this).hasClass("hover")){
    			switch($(this).attr("data-i")){
    				case 'today':
    					$("#chart1").html("");
    					ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=1&searchType=0&fromClientType="+fromClientType,false,true,"json",line1_today_success);
    					break;
    				case 'yesterday':
    					$("#chart1").html("");
    					ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=0&searchType=0&fromClientType="+fromClientType,false,true,"json",line1_today_success);
    					break;
    			}
    		}
    	});
    	ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType=1&searchType=0&fromClientType="+fromClientType,false,true,"json",line1_today_success);
    });


    //访问整体趋势图表切换————天数切换
    $('.trend_bottom_top>ul>li').click(function(){
    	//切换字体颜色
    	$(this).parent().children("li").removeClass("hover");
    	!$(this).hasClass("hover")&&$(this).addClass("hover");
    	//图表切换
    	var data_i_sta = $(this).attr("data-i");
    	var data_i_day = $(".trend_bottom_bottom .hover").attr("data-i");
		switch(data_i_sta){
    		case 'day7':
    			static(2);
    			break;
    		case 'day30':
    			static(3);
    			break;
    		case 'day60':
    			static(4);
    			break;
    	}
    	function static(n){
	    	switch(data_i_day){
	    		case 'startupCount':
	    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType="+n+"&searchType=0&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
	    			break;
	    		case 'activeUser':
	    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType="+n+"&searchType=2&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
	    			break;
	    		case 'becomeUser':
	    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType="+n+"&searchType=1&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
	    			break;
	    	}
    	}
    	
    });
	//访问整体趋势图表切换————二级状态切换(启动次数，活跃用户，新增用户)
	$(".trend_bottom_bottom>ul>li").on("click",function(){
		//切换字体颜色
    	$(this).parent().children("li").removeClass("hover");
    	!$(this).hasClass("hover")&&$(this).addClass("hover");
    	var data_i_sta = $(this).attr("data-i");
    	var data_i_day = $(".trend_bottom_top .hover").attr("data-i");
    	function static(n){
    		switch(data_i_sta){
				case 'startupCount':
					ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType="+n+"&searchType=0&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
    				break;
    			case 'activeUser':
					ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType="+n+"&searchType=2&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
    				break;
    			case 'becomeUser':
					ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/realTime/-1?dateType="+n+"&searchType=1&fromClientType="+fromClientType,false,true,"json",line2_day7_success);
    				break;
			}
    	}
    	switch(data_i_day){
    		case 'day7':
    			static(2);
    			break;
    		case 'day30':
    			static(3);
    			break;
    		case 'day60':
    			static(4);
    			break;
    	}
	});
	//	排行左边图表切换		
	$(".number_ul1>li").on('click',function(){
		//切换字体颜色
    	$(this).parent().children("li").removeClass("hover");
    	!$(this).hasClass("hover")&&$(this).addClass("hover");
    	var data_i = $(this).attr("data-i");
    	switch(data_i){
    		case 'yesterday':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/appClick/0?dateType=0&fromClientType="+fromClientType,false,true,"json",bar1_today_success);
    			break;
    		case 'today':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/appClick/0?dateType=1&fromClientType="+fromClientType,false,true,"json",bar1_today_success);
    			break;
    		case 'day7':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/appClick/0?dateType=2&fromClientType="+fromClientType,false,true,"json",bar1_today_success);
    			break;
    		case 'day30':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/appClick/0?dateType=3&fromClientType="+fromClientType,false,true,"json",bar1_today_success);
    			break;
    	}
	});

	$(".width_500 a").on('click',function(){
		var n = null;
		$(".number_ul1>li").each(function(){
			if($(this).hasClass("hover")){
				switch($(this).attr("data-i")){
					case 'yesterday':
						n = 0;
						break;
					case 'today':
						n = 1;
						break;
					case 'day7':
						n = 2;
						break;
					case 'day30':
						n = 3;
						break;
				}
			};
		});
		window.open("/seeyon/m3/monitoringController.do?method=visite&type=1&n="+n+"&fromClientType="+fromClientType,"_blank");
	});

	//	排行右边图表切换		
	$(".number_ul2>li").on('click',function(){
		//切换字体颜色
    	$(this).parent().children("li").removeClass("hover");
    	!$(this).hasClass("hover")&&$(this).addClass("hover");
    	//图表切换
    	var data_i = $(this).attr("data-i");
    	switch(data_i){
    		case 'yesterday':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/departActive/0?dateType=0&fromClientType="+fromClientType,false,true,"json",bar2_today_success);
    			break;
    		case 'today':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/departActive/0?dateType=1&fromClientType="+fromClientType,false,true,"json",bar2_today_success);
    			break;
    		case 'day7':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/departActive/0?dateType=2&fromClientType="+fromClientType,false,true,"json",bar2_today_success);
    			break;
    		case 'day30':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/departActive/0?dateType=3&fromClientType="+fromClientType,false,true,"json",bar2_today_success);
    			break;
    	}
	});

	$(".width_463 a").on('click',function(){
		var n = null;
		$(".number_ul2>li").each(function(){
			if($(this).hasClass("hover")){
				switch($(this).attr("data-i")){
					case 'yesterday':
						n = 0;
						break;
					case 'today':
						n = 1;
						break;
					case 'day7':
						n = 2;
						break;
					case 'day30':
						n = 3;
						break;
				}
			};
		});
		window.open("/seeyon/m3/monitoringController.do?method=visite&type=2&n="+n+"&fromClientType="+fromClientType,"_blank");
	});

	//客户端访问分布图表切换
	$(".distr_bottom_top>ul>li").on('click',function(){
		//切换字体颜色
    	$(this).parent().children("li").removeClass("hover");
    	!$(this).hasClass("hover")&&$(this).addClass("hover");
    	//图表切换
    	var data_i = $(this).attr("data-i");
    	switch(data_i){
    		case 'yesterday':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/clientType/-1?dateType=0&fromClientType="+fromClientType,false,true,"json",pie_today_success);
    			break;
    		case 'today':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/clientType/-1?dateType=1&fromClientType="+fromClientType,false,true,"json",pie_today_success);
    			break;
    		case 'day7':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/clientType/-1?dateType=2&fromClientType="+fromClientType,false,true,"json",pie_today_success);
    			break;
    		case 'day30':
    			ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/clientType/-1?dateType=3&fromClientType="+fromClientType,false,true,"json",pie_today_success);
    			break;
    	}
	});
		
</script>
</html>