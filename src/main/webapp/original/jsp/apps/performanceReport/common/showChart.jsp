<!-- 此文件已废弃，使用showChart.js -->
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script>
<!-- echarts.js和seeyon.ui.echarts2.js暂时采用此方法加载 -->
<script type="text/javascript" src="${path}/common/report/chart/echarts/seeyon.ui.chart2.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/report/chart/echarts/source/echarts.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/report/chart/echarts/seeyon.ui.echarts2.js${ctp:resSuffix()}"></script>

<script type="text/javascript">
var comprehensiveChart;
var chartIndex=0;

//绩效报表主题
var theme = {
    // 默认色板
    color: [
        '#1D8BD1','#F1683C','#2AD62A','#DBDC25',
        '#8FBC8B','#D2B48C'
    ],
    // 图例
    legend: {
        orient: 'horizontal',
        x: 'center',
        y: '5',
        borderWidth:0,
        //padding: [5,20,5,5],
        textStyle: {
        	fontFamily: 'Microsoft YaHei',
        	fontSize: 12,
            color: '#A3A3A3'          // 主标题文字颜色
        },
    },
    // 提示框
    tooltip: {
    	trigger: 'item',
    	backgroundColor: 'rgba(0,0,0,0)',     // 提示背景颜色，默认为透明度为0.7的黑色
    	borderColor: 'rgba(138,130,109,0.7)',
    	borderWidth:1,
    	axisPointer : {            // 坐标轴指示器，坐标轴触发有效
            type : 'line',         // 默认为直线，可选为：'line' | 'shadow'
            lineStyle : {          // 直线指示器样式设置
                color: '#6B6455',
                type: 'dashed'
            },
            crossStyle: {          //十字准星指示器
                color: '#A6A299'
            },
            shadowStyle : {                     // 阴影指示器样式设置
                color: 'rgba(200,200,200,0.3)'
            }
        },
        textStyle: {
        	fontFamily: 'Microsoft YaHei',
        	fontSize: 12,
            fontWeight: 'bold',
            color: '#414141'          // 主标题文字颜色
        },
        formatter: function(param)
        {
        	var fm;
        	switch(param.series.type)
        	{
        		case 'scatter':
        		{
        			fm = param.value[0] + '-' + param.seriesName + '-' + param.value[1];
        			break;
        		}
        		case 'line':
        		case 'bar':
        		default:
        		{
        			fm = param.name + '-' + param.seriesName + '-' + param.value;
        		}
        	}
        	return fm;
        },
        position: function(p) { return [p[0]-20, p[1]-30]; }
    },
    // 网格
    grid: {
        borderWidth:0,
        x: 80,
	    y: 30,
	    x2: 80,
	    y2: 30
    },
    dataZoom: {
        dataBackgroundColor: '#efefff',            // 数据背景颜色
        fillerColor: 'rgba(182,162,222,0.2)',   // 填充颜色
        handleColor: '#008acd',    // 手柄颜色
        height: 29,
        //zoomLock: true
    },
 	// 类目轴
    categoryAxis: {
        axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                color: '#008acd'
            }
        },
        splitLine: {           // 分隔线
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: ['#eee']
            }
        }
    },

    // 数值型坐标轴默认参数
    valueAxis: {
        axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                color: '#008acd'
            }
        },
        splitArea : {
            show : true,
            areaStyle : {
                color: ['rgba(250,250,250,0.1)','rgba(200,200,200,0.1)']
            }
        },
        splitLine: {           // 分隔线
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: ['#eee']
            }
        }
    },
    // 柱形图默认参数
    bar: {
        itemStyle: {
            normal: {
                barBorderRadius: 0,
                label: {
                    show: true,
                    textStyle: {
                    	color: '#232323',
                    	fontSize: 12
                    }
                }
            },
            emphasis: {
                barBorderRadius: 0,
                label: {
                    show: true,
                    textStyle: {
                    	color: '#232323',
                    	fontSize: 12
                    }
                }
            }
        }
    },

    // 折线图默认参数
   	line: {
        itemStyle: {
            normal: {
                // color: 各异,
                label: {
                    show: true,
                    textStyle: {
                    	color: '#232323',
                    	fontSize: 12
                    }
                }
            },
            emphasis: {
                // color: 各异,
                label: {
                    show: true,
                    textStyle: {
                    	color: '#232323',
                    	fontSize: 12
                    }
                }
            },
            tooltip : {
                trigger: 'item'
            },
        },
        smooth : true,
        symbol: 'emptyCircle',  // 拐点图形类型
        symbolSize: 3           // 拐点图形大小
    },
    //饼图默认参数
    pie: {
    	startAngle: 180,
    	center: ['50%', '55%'],
    	radius: [0, '80%'], 
    	minAngle: 0,
    	selectedMode:'single',
    	clockWise: false,
    	itemStyle: {
            normal: {
                label: {
                    show: true,
                    position: 'inside',
                    textStyle: {
			        	fontFamily: 'Microsoft YaHei',
			        	fontSize: 12,
			            fontWeight: 'bold',
			            color: '#414141'          // 主标题文字颜色
			        },
			        formatter: function(seriesName) {
                    	return seriesName.value
                    }
                },
                labelLine : {
                    show : false
                }
            },
            emphasis: {
                label: {
                    show: true,
                    position: 'inside',
                    textStyle: {
			        	fontFamily: 'Microsoft YaHei',
			        	fontSize: 12,
			            fontWeight: 'bold',
			            color: '#414141'          // 主标题文字颜色
			        },
                    formatter: function(seriesName) {
                    	return seriesName.value
                    }
                }
            }
        }
    },
    
    // 仪表盘默认参数
    gauge: {
    	axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                width: 8
            }
        },
        axisTick: {            // 坐标轴小标记
            show: false,
        	splitNumber: 10,   // 每份split细分多少段
            length :12,        // 属性length控制线长
            lineStyle: {       // 属性lineStyle控制线条样式
                color: 'auto'
            }
        },
        axisLabel: {           // 坐标轴文本标签，详见axis.axisLabel
            textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                color: 'auto'
            }
        },
        splitLine: {           // 分隔线
            show: true,        // 默认显示，属性show控制显示与否
            length :30,         // 属性length控制线长
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: 'auto'
            }
        },
        pointer : {
            width : 5
        },
        title : {
            show : true,
            offsetCenter: [0, '-110%'],       // x, y，单位px
            textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                fontWeight: 'bolder',
                fontSize: 12
            }
        },
        detail : {
            formatter:'{value}%',
            textStyle: {
                fontSize : 14
            }
        },
        tooltip: {
            show: false
        }
    },
    
    scatter: {
    	symbolSize: 6
    },
    textStyle: {
        fontFamily: '微软雅黑, Arial, Verdana, sans-serif',
        fontSize: 12,
    },
    noDataLoadingOption: {
    	textStyle: {
            fontSize: 12,
            fontWeight: 'normal',
            color: 'black'          // 主标题文字颜色
        }
    }
};

//绩效报表穿透标题
var _performance_title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";

//生成图
function drawingDefualt(personGroupTab){
	  if(!$.isNull(result)){
	      if(result.length == 0){
	      	if(isPortal!='true'){
	        	inputNoDataInfo(Constants_report_id);
	        }else{
	        	$("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>${ctp:i18n('report.chart.noData')}</div>");
	        }
	        return;
	      }
        if(Constants_report_id == WORKDAILYSTATISTICS) {
        	if(isPortal){
        		var personGroupTab=param.substring(param.indexOf("personGroupTab")+15,param.indexOf("personGroupTab")+16);
        		var appType=param.substring(param.indexOf("appType")+8,param.indexOf("appType")+9);
        		if(personGroupTab=='2' && (appType=='5'||appType=='6'||appType=='7')){
            		$("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>${ctp:i18n('performanceReport.section.notSupportCharts')}</div>");
            		return '';
            	}
        	}else{
            	var appType=$("#appType").val();
            	if(personGroupTab=='2' && (appType=='5'||appType=='6'||appType=='7')){
            		$("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>${ctp:i18n('performanceReport.section.notSupportCharts')}</div>");
            		return '';
            	}
            }
        }
		  var chartWidth=reportParams.chartWidth;
		  var chartHeight=reportParams.chartHeight;
		  var className='left';
		  if(Constants_report_id!=PROJECTSCHEDULESTATISTICS){
			  className+=' w100b';
		  }
		  var styles='';
		  if(chartObjS!=null){chartObjS = [];}
		  chartVosOption = JSON.parse(result);
		  for(var i=0; i<chartVosOption.length; i++)
		  {
			if(chartVosOption.length==1) {//如果只有一个图
				className="";//h100b会导致出现无谓的滚动条
				styles="width:100%;height:98%";
			}else{
				styles="width:100%;height:49%;";//如果不止一个图,每个图高度为50%
			}
			if(Constants_report_id==PROJECTSCHEDULESTATISTICS){//如果是项目进度统计,图的宽度和高度缩小
				styles="width:200px;height:200px";
			}
			var chartDiv="queryResult"+i;//如果不止一个图
			$("#queryResult").append("<div class='one_row "+className+"' style='background:#fff; "+styles+"' name='chart' id='"+chartDiv+"'></div>");
			var chartVoOption = chartVosOption[i]; 
			if (chartVoOption.type) { //echarts部分
				var chartVoOption = chartVosOption[i]; 
				chartObjS.push(chartDiv); //用于图表打印
			    var click = function(params) { //项目进度统计进度点击事件
					var data = new Object();
			        data.projectIState=0;
			        data.canEditorDel=false;
				    var dialog = $.dialog({
		            	id : 'newProjectWin',
		            	url : _ctxPath +"/"+ encodeURI(params.data.url+"&reportName="+Constants_report_Name),
		            	width : 556,
		            	height : 450,
		            	title : _performance_title,
		            	targetWindow : getCtpTop(),
		            	transParams:{ 
		            		selectData:data,
		            		action:'view'
		            	},
		            	buttons : [{
		                	text : "${ctp:i18n('common.button.close.label')}",
		                	handler : function() {
		                    	dialog.close();
		                }
		            	}] 
			        });
				};
				
				//------------------------------------START 图表参数调整
				var option = typeof chartVoOption.option == 'string' ? $.parseJSON(chartVoOption.option) : chartVoOption.option;
				//会议参与情况统计：多柱状图->饼图
				if (Constants_report_id == '4769314421021230492' && personGroupTab == 1) {
					var data = [];
					$.each(option.series, function(i, s){
						$.each(s.data, function(j, d){
							if (d.value != '-') { data.push({name: s.name, value: d.value, url: d.url}) }
						});
					});
					serie = {name: Constants_report_Name, type: 'pie', data: data};
					chartVoOption.option = {series: [serie]};
				}
				//知识贡献榜+在线人数趋势：单位平均分改为使用辅助线
				if (Constants_report_id == '5209305990769035961' || Constants_report_id == '-3648914008719078167') {
					if (option.series) {
						option.series[0].markLine = {
								data: [{type: 'average', name: '平均值'}],
								tooltip: {
						          	show: true,
						            formatter: function(p){ return p.data.name + '：' + p.value; }
						        },
								itemStyle: { normal: { color: "red" },  emphasis: { color: "red" } }
						};
					}
					option.series.pop();
					chartVoOption.option = option;
				}
				//日常工作统计+知识活跃度 :部门平均值改为折线
				if ((Constants_report_id == '6463442791594018643' && personGroupTab == 1)
						|| (Constants_report_id == '1024992466047550297' && personGroupTab == 1)) {
					if (option.series) { option.series[1].type = 'line'; }
					chartVoOption.option = option;
				}
				//存储空间统计+会议的角色统计(团队) 改为堆积样式
				if (Constants_report_id == '-914397298665307869' 
						|| (Constants_report_id == '4769314421021230492' && personGroupTab == 2) ){
					if (option.series) {
						$.each(option.series, function(i, s){
							if (s.type == 'bar') { s.stack = 'group01'; }
						});
					}
					chartVoOption.option = option;
				}
				//任务燃尽图：添加理想线
				if (Constants_report_id == '2922611975991610507') {
					if (option.series) {
						var start = option.series[0].data[0].value;
						var xAxisData = option.xAxis[0].data;
						var markLine = {
							data: [
							       [
							        	{name: '起点', xAxis: 0, yAxis: option.series[0].data[0].value},
							        	{name: '终点', xAxis: xAxisData[xAxisData.length-1].value, yAxis: 0}
							       ]
							],
							tooltip:{ show: false },
							itemStyle: {
								normal: {
			                        color: "red",
			                        label: {
			                        	show: true,
			                        	formatter: "理想线"
			                        }
			                    }, 
			                    emphasis: {
			                        color: "red",
			                        label: {
			                        	show: true,
			                        	formatter: "理想线"
			                        }
			                    }
							}
						};
						option.series[0].markLine = markLine;
						option.xAxis[0].boundaryGap = false;
						chartVoOption.option = option;
					}
				}
				//计划提交回复统计
				if (Constants_report_id == '4655353227031169793' || Constants_report_id == '1942728482375027918') 
				{
					var itemStyle = {
						normal: {
							   label: {
								   show: true, 
								   formatter: function(param){return param.value + '%';}
				   				}
						   },
						   emphasis: {
							   label: {
								   show: true, 
								   formatter: function(param){return param.value + '%';}
				   				}
						   }
					};
				    $.each(option.series, function(i, s)
				    {
					   if (s.type == 'line') {
						   $.each(s.data, function(i, d){d.value = d.value * 100;});
						   s.itemStyle = $.extend(s.itemStyle||{}, itemStyle);
					   }
				    });
				    option.tooltip = option.tooltip || {};
					option.tooltip.formatter = function(param){
					   return param.series.type == 'line' 
					   		? param.name + '-' + param.seriesName + '-' + param.value + '%'
					   	    : param.name + '-' + param.seriesName + '-' + param.value;
					}
					chartVoOption.option = option;
				}
				//------------------------------------END 图表参数调整
				
				var paramter = {
						dom: chartDiv,
						theme: theme,
						click: Constants_report_id == '9081960473256084643' ? click : null,
						func: function(p) { //对部分图表参数进行微调
							switch(Constants_report_id) {
							   case FLOWOVERTIMESTATISTICS: //流程超期统计
							   {
								   var format = function(params) {
									   return params.name + ' ' + params.value + ' ' + Number(params.percent).toFixed(0) + '%'; 
								   }
								   $.each(p.option.series, function(i, s)
								   {
									   if (s.itemStyle)
									   {
										   if (s.itemStyle.normal && s.itemStyle.normal.label) {
											   s.itemStyle.normal.label.formatter = format;
										   }
										   if (s.itemStyle.emphasis && s.itemStyle.emphasis.label) {
											   s.itemStyle.emphasis.label.formatter = format;
										   }
									   }
								   });
								   break;
							   }
							   case '3569160983850797390': //在线人数趋势
							   {
								   $.each(p.option.series, function(i, s){
									  $.extend(s.markLine, {tooltip: {
								          	show: true,
								            formatter: function(p){ return p.data.name + '：' + p.value; }
								        }}); 
								   });
								   break;
							   }
							   case '2745198015260806201': //事项统计
							   {
								   $.each(p.option.series, function(i, s){
									   if (s.type == 'bar') {
										   var itemStyle = {
												   normal: { label: {show: false}},
												   emphasis: {label: {show: false}}
											};
										   s.itemStyle = $.extend(true, s.itemStyle, itemStyle);
									   }
								   });
								   break;
							   }
							   case '9081960473256084643': //项目统计
							   {
								   $.each(p.option.series, function(i, s){
									   if(s.type == 'gauge') {
										   $.each(s.data, function(i,d)
										   {
											   var getSub = function (val, max) {
												   var len = 0;
												   var str = '';
												   for (var i = 0; i < val.length; i++) 
												   {
													   if (val[i].match(/[^\x00-\xff]/ig) != null) {  len += 2; }	//全角	
													   else { len += 1; }
													   str += val[i];
													   if (len >= max) {
														   str = (len == max ? str : str.substring(str, 0, str.len - 1)) + '...';
														   break;
													   }
												   };
												   return str;
											   }
											   if (d.name) { d.name = getSub(d.name, 16); }
										   });
									   }
								   });
								   break;
							   }
							   case '4769314421021230492':
							   {
								   if(personGroupTab == 1) {break;}
							   }
							   case '-914397298665307869': //存储空间统计
							   case '6463442791594018643': //知识活跃度
							   {
								   $.each(p.option.series, function(i, s) {
									   if (s.itemStyle) {
										   s.itemStyle.normal = s.itemStyle.normal || {};
										   s.itemStyle.normal.label = s.itemStyle.normal.label || {show: false};
										   
										   s.itemStyle.emphasis = s.itemStyle.emphasis || {};
										   s.itemStyle.emphasis.label = s.itemStyle.emphasis.label || {show: false};
									   } else {
										   s.itemStyle = {
												normal: {label: {show: false}},
												emphasis: {label: {show: false}}
										   };
									   }
								   });
								   break;
							   }
							}
							//默认工具栏
							if (Constants_report_id != '9081960473256084643') {
								p.option.toolbox = {show : true, feature : { restore : {show: true}, saveAsImage : {show: true} } };
							}
							return p;
						},
						option: chartVoOption.option,
						args: { title: _performance_title }
				};
				new SeeyonUiChart2().render(paramter);
			}
		  }
	  }
}

var count=0;
var currentIndex=0;
function drawProject(index){
	//每六个图一组加载
	currentIndex = index+6;
	for(var i=index; i<index+6;i++){
		if(i>result.length-1||(isPortal=="true"&&i>=showNumber)){
			return;
		}
		if(reportParams.dataList.length==0){
			styles="width:100%;height:100%";
		}else{
			styles="width:200px;height:200px";
		}
		var chartDiv="queryResult"+i;//如果不止一个图
		$("#queryResult").append("<li class='one_row left' style='background:#fff; "+styles+"' name='chart' id='"+chartDiv+"'></li>");
		//var anyChartDefualt = new Object();
		//anyChartDefualt.htmlId = chartDiv;
		//anyChartDefualt.chartJson = result[i];
		//anyChartDefualt.fromReport = true; //特别标识：针对报表会设定许多默认参数
		//anyChartDefualt.debugge = true;
		//anyChartDefualt.event = [{name:"pointClick",func:onPointClick},{name:"draw",func:function(){
		//	count++;
		//	if(count%6==0 && result.length > currentIndex){
		//		drawProject(currentIndex);
		//	}
		//}}];
		//chartObjS[i]=new SeeyonChart(anyChartDefualt);
		var chartVoOption = chartVosOption[i];
		if (chartVoOption != null) {
			chartObjS.push(chartDiv); //用于图表打印
			//new SeeyonUiChart2().render(chartDiv, chartVoOption.type, chartVoOption.option, {title: _performance_title});
			var paramter = {
					dom: chartDiv,
					theme: theme,
					option: chartVoOption.option,
					args: {
						title: _performance_title
					},
					click: function(params)
					{
						var data = new Object();
				        data.projectIState=0;
				        data.canEditorDel=false;
					    var dialog = $.dialog({
			            	id : 'newProjectWin',
			            	url : _ctxPath +"/"+ encodeURI(params.data.url+"&reportName="+Constants_report_Name),
			            	width : 556,
			            	height : 450,
			            	title : _performance_title,
			            	targetWindow : getCtpTop(),
			            	transParams:{ 
			            		selectData:data,
			            		action:'view'
			            	},
			            	buttons : [{
			                	text : "${ctp:i18n('common.button.close.label')}",
			                	handler : function() {
			                    	dialog.close();
			                }
			            	}] 
				        });
					}
			};
			new SeeyonUiChart2().render(paramter);
		}
		
	}
}

var analysisType=1;
function analysisTypeClick(index){
	analysisType=$(":input[name='analysisType'][checked]").val();
	$("#queryResult").html('');
	chartIndex=analysisType-1;
	drawComprehensive();
	$(":input[name='analysisType'][value='"+analysisType+"']").attr("checked",true);
}

 //渲染综合分析默认值的图(默认值为柱状图第一个值)
function drawInit(){
		try{
			 var chartDatas = comprehensiveChart.chart.getInformation();
			 var id=chartDatas.Series[0].Points[0].ID;
			 drawChart(id,analysisType);
		 }catch(e){
			   
		 }
}

//综合分析获取下方图的数据
function drawChart(id,analysisType){
	  var manager = new workFlowAnalysisManager();
	  manager.getAnalysisChartData(flowType,id,start_time,end_time,analysisType,false,{
		     success:function(result){
		       childChart = renderChildChart(result , id,analysisType);
		       chartObject=childChart;
		       $("#queryResult0").css("height","48%");
		       $("#chart2").css("height","48%");
		     }});
}

//渲染下方的图表(analysisType表示对应的图的位置索引)
function renderChildChart(anyChart , id,analysisType) {
	    return new SeeyonChart({
	      htmlId : "chart",
	      width : "100%",
	      height : "100%",
	      chartJson : anyChart,
	      event : [ {
	          name : "pointClick",
	          func : function(e){
	              showDetail(id,anyChart.title,e.data.Name,e.data.Name);
	          }
	        }]
	    });
}

	//图的穿透
  function onPointClick(e){
	  if(Constants_report_id==COMPREHENSIVEANALYSIS){
		  //综合分析
		  drawChart(e.data.ID,$(":input[name='analysisType'][checked]").val());
	  }else if(Constants_report_id==EFFICIENCYANALYSIS){
		  //效率分析
		  openDetailWindow("${path}",e.data.ID,e.data.Name,appTypeName,"efficiency");
	  }else if(Constants_report_id==OVERTIMEANALYSIS){
		  //超时分析
		  openDetailWindow("${path}",e.data.ID,e.data.Name,appTypeName,"timeout");
	  }else if(Constants_report_id==NODEANALYSIS){
		  //节点分析
		  var url = e.data.ID;
		  if(!$.isNull(url)){
		 	eval(e.data.ID);
		  }
	  }else if(Constants_report_id==PROCESSPERFORMANCEANALYSIS){
		  //流程统计
			var url = e.data.ID;
			//协同V5.0 OA-32079 值为0，不穿透
			var value = e.data.YValue;
			if(value != 0 && !$.isNull(url)){
				eval(e.data.ID);
			}
	  }else{
		  var url = e.data.ID;
		  if($.isNull(url)){//对仪表盘的操作
		    url = e.data.name;
		  }
		  if(!$.isNull(url)&&Constants_report_id!=ONLINESTATISTICS&&Constants_report_id!=ONLINEMONTHSTATISTICS){
			  throughQueryDialog(url);
		  }
	  }
  }
  //流程统计穿透
  function openList(appType,entityType,entityId,state,beginDate,endDate,templateId,appName,statScope){
  		var title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
  		getA8Top().up = window;
  		queryDialog =$.dialog({
	          id : 'url',
	          url: encodeURI("${path}/performanceReport/WorkFlowAnalysisController.do?method=statResultListMain&appType=" + appType + "&entityId="
	         + entityId + "&entityType=" + encodeURIComponent(entityType) + "&state=" + state 
	         + "&beginDate=" + beginDate + "&endDate=" + endDate + "&templateId=" + (templateId==null||templateId=='null' ?　''　:　templateId)
	         + "&appName=" + appName+"&statScope="+statScope),
	          width : $(getCtpTop().document).width()-100,
	          height : $(getCtpTop().document).height()-100,
	          title : title,
	          targetWindow : getCtpTop(),
	          transParams: {
	        	pwindow : window,
				closeAndForwordToCol: throughListForwardCol
	          },
	          buttons : [ {
	              text : "${ctp:i18n('performanceReport.queryMain_js.button.close')}",//关闭
	              handler : function() {
	            	  queryDialog.close();
	              }
	          } ]
	      });
	}
  
  //节点分析穿透
  function openNodeAccessDetailWindow(id, policyName, memberName, overRadio, avgRunWorkTime) {
  		var title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
		var templeteId = templeteId_;
		var beginDate = start_time;
		var endDate = end_time;
		  getA8Top().up = window;
	      queryDialog = $.dialog({
	          id : 'url',
	          url: encodeURI("${path}/performanceReport/WorkFlowAnalysisController.do?method=nodeAnalysiszNodeAccessFrame&templeteId="+templeteId_+"&nodeId="+id
		        		+"&policyName="+policyName+"&memberName="+memberName+"&beginDate="+beginDate+"&endDate="+endDate
		        		+"&overRadio="+overRadio+"&avgRunWorkTime="+avgRunWorkTime),
	          width : $(getCtpTop().document).width()-100,
	          height : $(getCtpTop().document).height()-100,
	          title : title,
	          targetWindow : getCtpTop(),
	          transParams: {
	        	pwindow : window,
				closeAndForwordToCol: throughListForwardCol
	          },
	          buttons : [ {
	              text : "${ctp:i18n('performanceReport.queryMain_js.button.close')}",//关闭
	              handler : function() {
	            	  queryDialog.close();
	              }
	          } ]
	      });
	}
  
  //效率分析,超时分析穿透
  function openDetailWindow(baseUrl,summaryId,subject,_appEnumStr,from) {
  		var title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
		var templeteId = "";
		try{
			templeteId = templeteId_;
		}catch(e){
			var hstr = self.location.href;
			templeteId = workflowAnalysisParseParam(hstr,"templeteId");
		}
		if (templeteId == "") {
			alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
			return ;
		}
		var queryParamsAboutApp = "";
		if (_appEnumStr && (_appEnumStr == 'recEdoc' || _appEnumStr == 'sendEdoc'|| _appEnumStr == 'signReport' || 
				_appEnumStr == 'edocSend' || _appEnumStr == 'edocRec' || _appEnumStr == 'edocSign' 
			)) {
			queryParamsAboutApp = "&appName=4&appTypeName="+_appEnumStr;
		}
	  	  getA8Top().up = window;
	      queryDialog = $.dialog({
	          id : 'url',
	          url: baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=showFlowNodeDetailFrame&summaryId="+summaryId
				+"&pageFlag="+from+"&templeteId="+templeteId
				+"&subject="+encodeURI(subject)+queryParamsAboutApp,
	          width : $(getCtpTop().document).width()-100,
	          height : $(getCtpTop().document).height()-100,
	          title :title,
	          targetWindow : getCtpTop(),
	          transParams: {
	        	pwindow : window,
				closeAndForwordToCol: throughListForwardCol
	          },
	          buttons : [ {
	              text : "${ctp:i18n('performanceReport.queryMain_js.button.close')}",//关闭
	              handler : function() {
	            	  queryDialog.close();
	              }
	          } ]
	      });
	}
  
  //穿透查询事件
  var queryDialog;
  function throughQueryDialog(throughQueryUrl){
  	  var title;
  	 getA8Top().up = window;
  	  if(throughQueryUrl.charAt(0)=="\/"){
		   throughQueryUrl=throughQueryUrl.substring(1,throughQueryUrl.length);
	  }
  	  if(Constants_report_id==PROJECTSCHEDULESTATISTICS){//项目进度统计
	  	  title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表
		  var action = 'view';
		  var data = new Object();
          data.projectIState=0;
          data.canEditorDel=false;
		  var dialog = $.dialog({
            id : 'newProjectWin',
            url : _ctxPath +"/"+ encodeURI(throughQueryUrl+"&reportName="+Constants_report_Name),
            width : 556,
            height : 450,
            title : title ,
            targetWindow : getCtpTop(),
            transParams:{ selectData:data,
            			  action:action},
            buttons : [{
                text : "${ctp:i18n('common.button.close.label')}",
                handler : function() {
                    dialog.close();
                }
            }] 
        });
        return;
	  }else if(Constants_report_id==TASKBURNDOWNSTATISTICS){
	      var id = $("#task_id").val();
		  var detailUrl="${path}/taskmanage/taskinfo.do?method=openTaskDetailPage&from=bnOperate&taskId="+id;
		  var contentUrl="${path}/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+id;
		  var treeUrl="";
		  var hideBtnC = true;
		  if(new taskDetailTreeManager().checkTaskTree(id)){
		      hideBtnC = false;
			  treeUrl="${path}/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+id;
		  }
		  new projectTaskDetailDialog({"url1":detailUrl,"url2":contentUrl,"url3":treeUrl,"openB":true,"hideBtnC":hideBtnC,"animate":false});
	  	  return;
	  }else{
	  	  if(Constants_report_id==TASKBURNDOWNSTATISTICS){
  	  		//任务燃尽图
		 	title="${ctp:i18n('performanceReport.queryMain.task.content')}";
		  }else{
  	  	  	title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表
  	  	  }
  	  	  width=$(getCtpTop().document).width()-100;
  	  	  height=$(getCtpTop().document).height()-100;
	  }
      queryDialog = $.dialog({
          id : 'url',
          url : _ctxPath +"/"+ encodeURI(throughQueryUrl+"&reportName="+Constants_report_Name),
          width : width,
          height : height,
          title : title,
          targetWindow : getCtpTop(),
          transParams: {
        	pwindow : window,
			closeAndForwordToCol: throughListForwardCol
          },
          closeParam:{ 
                'show':true, 
                autoClose:false, 
                handler:function(){ 
                   if(Constants_report_id==TASKBURNDOWNSTATISTICS){
                   //OA-49979.任务燃尽图-穿透查看任务窗口，修改任务未点击确定前关闭任务窗口，未提示是否保存当前修改.
            	  	  queryDialog.getClose({'dialogObj' : queryDialog ,'runFunc' : refreshPage}); 
            	  }else{
            		  queryDialog.close();
            	  }
            	  if(Constants_report_id==MEETINGJOINSTATISTICS){
            	  	//OA-50968 绩效查询--会议参加情况统计，查看到未回执的会议，穿透直接回执会议不参加，回到报表没有立即更新数据，需要重新进入才会更新，统计不及时
            	  		refreshPage();
            	  }
                } 
            }, 
            buttons: [{ 
                text: "${ctp:i18n('common.button.close.label')}", 
                handler: function () { 
                   if(Constants_report_id==TASKBURNDOWNSTATISTICS){
                   //OA-49979.任务燃尽图-穿透查看任务窗口，修改任务未点击确定前关闭任务窗口，未提示是否保存当前修改.
            	  	queryDialog.getClose({'dialogObj' : queryDialog ,'runFunc' : refreshPage}); 
            	  }else{
            		  queryDialog.close();
            	  }
            	  if(Constants_report_id==MEETINGJOINSTATISTICS){
            	  	//OA-50968 绩效查询--会议参加情况统计，查看到未回执的会议，穿透直接回执会议不参加，回到报表没有立即更新数据，需要重新进入才会更新，统计不及时
            	  		refreshPage();
            	  }
                } 
            }] 
      });
  }
  
  function refreshPage(){
	  executeStatistics();
  }
  
   function showDetail(id,subject,beginDate,endDate){
  		var title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
	    var templeteSubject=subject;
	    getA8Top().up = window;
	    var url="${path}/performanceReport/WorkFlowAnalysisController.do?method=getDetailAccount&templeteId="+id+"&beginDate="+beginDate+"&endDate="+endDate+"&templeteSubject="+templeteSubject;
	    var dialog = $.dialog({
		    id: 'url',
		    url: url,
		    width: 750,
		    height: 500,
		    targetWindow:getCtpTop(),
		    title: title
		});
	}
	
  //穿透页面转协同
  function closeAndForwardToCol(subject, content){
  	$("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
      $('#reportContent').val(content);
      $('#reportTitle').val(subject.replace(/(^\s*)|(\s*$)/g, ""));
      $("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
      $("#queryConditionForm").submit();
  }
  
   function transmitColSreach(reportTitle,contentHtml){ 
      queryDialog.close();
      $('#reportTitleId').val(reportTitle);
      $('#contentHtmlId').val(contentHtml);
      $("#queryConditionForm").attr("action", "${path}/collaboration/collaboration.do?method=reportForwardColl");
      $("#queryConditionForm").submit();
  }
</script>