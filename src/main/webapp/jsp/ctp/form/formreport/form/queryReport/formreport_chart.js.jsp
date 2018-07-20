<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/report/chart/echarts/echarts-all.js${ctp:resSuffix()}"></script>
<script type="text/javascript">

/**
 * chartType 图表类型 1-柱状图、3-折线图、7-饼图、11-雷达图
 * chartDataStr 图的数据
 * dom 显示的位置
 */
function drawingChart2(chartType,option,dom){
	var et = null;
	var hasData = false;//是否有数据;
	if(option.series.length != 0 ){
		for(var i=0;i<option.series.length;i++){
			if(undefined != option.series[i].data){
				var d = option.series[i].data;
				for(var j=0;j<d.length;j++){
					var value = d[j].value;
					if(value != 0 && value != "0"){
						hasData = true;
						break;
					}
				}
				break;
			}
		}
	}
	
	if(!hasData){//没有数据
		et = drawingEmptyChart2(dom);
	}else{
		var newOption = new Object();
		var toolbox = {show : true,feature : {},x:"right"};
		switch(parseInt(chartType))
		{
		case 3://折线图
			for(var i=0;i<option.series.length;i++){
				option.series[i].type = "line";
			}
			
			newOption = optionDataAdjustment(option,dom);
			newOption.legend.selectedMode = false;
			for(var i=0;i<newOption.series.length;i++){
				delete newOption.series[i].xAxis ;
				delete newOption.series[i].yAxis ;
			}
			delete newOption.yAxis[0].boundaryGap;
			
// 			var dataZoom = {show : true,title : {dataZoom : "区域缩放",dataZoomReset : "取消缩放"}};
// 			toolbox.feature.dataZoom = dataZoom;
			
			newOption = getBarOrLineOption(option,dom);
			break;
		case 7://饼图
			var newOption = new Object();
			var newseries = new Array();
			var newsObj = new Object();
			
			var legData = new Array();
			var newsData = new Array();
			var oldxData = option.xAxis[0].data;
			if(option.series.length == 1){
				var oldsData = option.series[0].data;
				for(var i=0;i<oldxData.length;i++){
					var name = oldxData[i].value;
					legData[i] = name;
					newsData[i] = {"name": name,"value": oldsData[i].value,"display":oldsData[i].display};
				}
			}else{
				var sersTh = option.series.length;
				for(var j=0;j<sersTh;j++){
					if(typeof(oldxData[j]) =="undefined"){
						continue;
					}
					var name = oldxData[j].value;
					legData[j] = name;
					var oldsData = option.series[j].data;
					for(var i=0;i<oldxData.length;i++){
						if(0 != oldsData[i].value){
							newsData[newsData.length] = {"name": name,"value": oldsData[i].value};
						}
					}
				}
			}
			newOption.legend = option.legend;
			newOption.legend.data = legData;
			if(oldxData.length > 30){
				//newOption.legend.show = false;
			}
			newOption.legend.selectedMode = false;
			newOption.legend.orient = "vertical";
			newOption.legend.x = "right";
			newOption.legend.y = "30";
			
			newsObj.data = newsData;
			newsObj.selectedMode = "multiple";
			var itemStyle = new Object();
			var normal = {"label": {"formatter": "{c}", "position":"inner","distance":0.8,"show": true},"labelLine":{"show":false}};
			normal.label.formatter = seriesFormatter;
			
			itemStyle.normal = normal;
			itemStyle.emphasis = normal;
			newsObj.itemStyle = itemStyle;
			newsObj.type = "pie";
			newsObj.radius = "90%";
			newsObj.center = ['50%', '50%'];
			newseries[0] = newsObj;
			
			newOption.series = newseries;
			var oldsName = option.series[0].name;
			var tooltip =  { "formatter": tooltipFormatter };
			newOption.tooltip = tooltip;
			break;
		case 11://雷达图
			var newOption = new Object();
			newOption.legend = option.legend;
			newOption.legend.orient = "vertical";
			newOption.legend.x = "right";
			newOption.legend.y = "30";
			
			newOption.noDataText = option.noDataText;
			var tooltip = new Object();
			tooltip.formatter = radarTooltipFormatter;
			tooltip.trigger = "item";
			newOption.tooltip = tooltip;
			//设置series
			var minVal = 0;
			var maxVal = 0;
			var series = new Array();
			var ser = new Object();
			ser.type = "radar";
			var newSerData = new Array();
			var oldser = option.series;
			for(var i=0;i<oldser.length;i++){
				var dataValue = new Object();
				dataValue.name = oldser[i].name;
				var value = new Array();
				var oldSData = option.series[i].data;//原来图的series.data
				for(var j=0;j<oldSData.length;j++){
					var val = parseFloat(oldSData[j].value);
					if(val > maxVal){
						maxVal = val;
					}
					if(val < minVal){
						minVal = val;
					}
					value[j] = {value:val,display:oldSData[j].display};
				}
				dataValue.value = value;
				var itemStyle = {normal: {label: {show: true,formatter:seriesFormatter}}};
				dataValue.itemStyle = itemStyle;
				newSerData[i] = dataValue;
			}
			ser.data = newSerData;
			series[0] = ser;
			newOption.series = series;
			//设置雷达图的极
			var polar = new Array();
			var indicator = new Object();
			var texts = new Array();
			var xData = option.xAxis[0].data;
			for(var i=0;i<xData.length;i++){
				var text = {"text":xData[i].value,min:minVal, max: 1.2*maxVal};
				texts[i] = text;
			}
			indicator.indicator = texts;
			indicator.radius = "70%";
			indicator.center = ['50%', '55%'];
			polar[0] = indicator;
			newOption.polar = polar;
			newOption.legend.selectedMode = true;
			break;
		default://柱状图
			newOption = optionDataAdjustment(option,dom);
			newOption.legend.selectedMode = false;
			
			for(var i=0;i<newOption.series.length;i++){
				delete newOption.series[i].xAxis ;
				delete newOption.series[i].yAxis ;
			}
			delete newOption.yAxis[0].boundaryGap;
		
// 			var dataZoom = {show : true,title : {dataZoom : "区域缩放",dataZoomReset : "取消缩放"}};
// 			toolbox.feature.dataZoom = dataZoom;
			newOption = getBarOrLineOption(option,dom);
		}
// 	var saveAsImage = {show: true};
// 	toolbox.feature.saveAsImage = saveAsImage;
// 	newOption.toolbox = toolbox;
		
		newOption.color = [
	                   '#44B7D3','#E42B6D','#F4E24E','#FE9616','#8AED35',
	                   '#ff69b4','#ba55d3','#cd5c5c','#ffa500','#40e0d0',
	                   '#E95569','#ff6347','#7b68ee','#00fa9a','#ffd700',
	                   '#6699FF','#ff6666','#3cb371','#b8860b','#30e0e0'
	                   ];
		newOption.tooltip.textStyle = {fontSize:12};
		et = echarts.init(document.getElementById(dom));
		et.setOption(newOption);
	}
	return et;
}
/** ------柱状图或者折线图数据------- */
function getBarOrLineOption(option,dom){
	var newOption = optionDataAdjustment(option,dom);
	newOption.tooltip.formatter = tooltipFormatter;
	newOption.legend.selectedMode = false;
	for(var i=0;i<newOption.series.length;i++){
		newOption.series[i].itemStyle.normal.label.formatter = seriesFormatter;
		delete newOption.series[i].xAxis ;
		delete newOption.series[i].yAxis ;
	}
	delete newOption.yAxis[0].boundaryGap;
	
	return newOption;
}
function seriesFormatter(params){ 
	return params.data.display == undefined? "": params.data.display;
}
function tooltipFormatter(p){
	var tip = p.name + " " + p.seriesName ;
	if(undefined != p.data.display){
		tip = tip + " " + p.data.display;
	}
	return tip;
}
function radarTooltipFormatter(params){
	var index = params.indicator;
	var tip = params.name + " " + params.seriesName;
	if(undefined != params.value[index] && undefined != params.value[index].display){
		tip = tip + " " + params.value[index].display;
	}
	return tip;
}
/** -------计算图的滚动条-------- */
function optionDataAdjustment(option,dom){
	//维度1：根据xAxis坐标轴的分类域的数据值:label字符串长度 * 字体大小 * 数据域个数 > $(dom).width() - grid.x - grid.x2
	var _x = (option.grid && option.grid.x) ||  80;   //直角坐标系内绘图网格左上角横坐标
	var _x2 = (option.grid && option.grid.x2) ||  80; //直角坐标系内绘图网格右下角横坐标
	var _actualWidth = $("#"+dom).width() - _x - _x2; //实际可用宽度
	
	var _y = (option.grid && option.grid.y) || 60;   //直角坐标系内绘图网格左上角纵坐标
	var _y2 = (option.grid && option.grid.y2) ||  40; //直角坐标系内绘图网格右下角横坐标
	var _actualHeight = $("#"+dom).height() - _y - _y2; //实际可用高度
	
	var _baseWidth = 40;
	var _allWidth = 0;
	option.xAxis && $.each(option.xAxis, function(i, axis){
		if (axis.type == 'category') {//直角坐标系
			var seriesSize = option.series.length;
			if(seriesSize > 1){
				if(option.series[0].type == 'bar'){
					_baseWidth = _baseWidth * seriesSize;
				}
			}
			_allWidth = _baseWidth * axis.data.length;
			if( 1.1 * _actualWidth < _allWidth){
				var _end = (_actualWidth/_allWidth) * 100;
				option.dataZoom = {
					show: true,
					z: 1,
					height:25,
					orient: 'horizontal',
					xAxisIndex: 0,
					start: 0,
					end: _end
				};
				
				_y2 = option.dataZoom.height + 40;
			}
			option.grid = {
					x:_x,
					x2:_x2,
					y:_y,
					y2:_y2
			};
			
			//x轴坐标文字显示
			axis.scale = true;
			
			var axisLabel = {
				interval:0,
                formatter: function (value){
                	return xAxisLabelShow(value,this);}
            };
            axis.axisLabel = axisLabel;
		}
	});
	return option;
}
/** -------x轴坐标上的文字显示-------- */
function xAxisLabelShow(value,_this){
	//var ss = _this._option.dataZoom.end - _this._option.dataZoom.start;
	var _option = _this._option;
	var chartWidth = $(_this.dom).width() - _option.grid.x - _option.grid.x2;
	
	var xAxisLength = 0;
	_option.xAxis && $.each(_option.xAxis, function(i, axis){
		xAxisLength = axis.data.length;
	});
	var size = Math.floor(chartWidth/(xAxisLength * 12));
	
	return dataNewline(value,size);
}

/**
 * X轴坐标换行
 */
function dataNewline(val,size){
	var baseSize = 1;
	if(0 != size){
		baseSize = baseSize * size;
	}
	var v = val;
	if(val != undefined && val.length > baseSize){
		v = val.substr(0, baseSize) + "\n";
		val = val.substr(baseSize, val.length);
		if( val.length > baseSize-1){
			v = v +val.substr(0, baseSize-1)+"...";
		}else{
			v = v +val.substr(0, baseSize-1);
		}
	}
	return v;
}
/**
 * 无数据图展示
 */
function drawingEmptyChart2(dom){
	var et = echarts.init(document.getElementById(dom));
	et.showLoading({
	    text : '暂无数据',
	    effect : 'bubble',
	    textStyle : {
	        fontSize : 24
	    }
	});
	return null;
}

</script>