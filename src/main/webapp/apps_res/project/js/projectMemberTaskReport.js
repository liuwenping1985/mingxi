var reportResult;
function initTaskReport(){
	var taskInfoReportManager_=new taskInfoReportManager();
	var obj=$("#drillDownDiv").formobj();
	reportResult=taskInfoReportManager_.getReportByAjax(obj);
	var showContent = $("#showContent").val();
	if(showContent == "10"){
		showGrid();
	}else if(showContent == "20"){
		showChart();
	}
}

function drillDownDetail(url){
	var body=$('#body', parent.parent.document);
	if(body.length>0){
		body.attr("src",_ctxPath+url);
		body.parent().css("margin-top","-8px");
	}
	var moreBody=$('#body', parent.document);
	if(moreBody.length>0){
		moreBody.attr("src",_ctxPath+url);
		moreBody.parent().css("margin-top","-8px");
	}
}

/**显示表*/
function showGrid(){
	hideChart();
	if($("#taskGridReport").length > 0){
		$("#taskGridReport").show();
	}
	
	$("#taskGridReport").html(reportResult.gridData.table);
	if($("#taskGridReport td").length==0){
		var str="<tr><td colspan='6' style='text-align:center'>没有可以显示的数据！</td></tr>";
		$("#taskGridReport tr").after(str);
	}
	$("[name='overdueT3'] a").css("color","red");
}

function hideGrid(){
	$("#taskGridReport").hide();
}

/**显示图*/
var currentChart = new Object();

function hideChart(){
	if(currentChart.seeyonChart != undefined){
		$("#taskChartReport").hide();
	}
}

/**
 * 显示图数据
 */
function showChart(){
	hideGrid();
	if(currentChart.seeyonChart != undefined){
		$("#taskChartReport").show();
		return;
	}
	
	//图自定义颜色样式配置
	var barItemStyle = {
			normal:{
				color:function(p){//color可以是函数也可以是具体颜色的值
					//如果该功能用的多可以适当的封装，只传递数组
					//定义一个二维数组通过回调函数的参数，得到对应的颜色
					mycolors = [["#FE7C1A","#8DC42A","#1B8CCE","#B62008"]];
					var  arrc= mycolors[0];
					return arrc[p.seriesIndex];
				}
			}
	};
	
	//图的数据
	var barData ={
			category : [ '张伟', '彭州', '李艳', '李洋', '刘洋' ],
			data:[{
				type:"bar",
				name:"未完成",
				data:[{value:1,attr:"特殊属性"},{value:2,attr:"test"},{value:2},{value:3},{value:5}],
				stack:"任务",
				itemStyle:barItemStyle
			},{
				type:"bar",
				name:"已完成",
				data:[10,3,10,3,10],
				stack:"任务",
				itemStyle:barItemStyle
			},{
				type:"bar",
				name:"已取消",
				data:[0,2,3,1,4],
				stack:"任务",
				itemStyle:barItemStyle
			},{
				type:"line",
				name:"已超期",
				data:[0,1,0,1,2],
				itemStyle:barItemStyle
	}]};
	
	//饼图的选项
	var barOptions ={
			align:"v",//设置对齐方式，默认为H，为自添加的参数，为实现，数据格式的统一性
			//图例
			legend:{
				show:true,//图例显示开关
                orient :"vertical",//图例排列方式
                x:"right",//可是使用像素，如：12
                y:"center"//可是使用像素，如：12
			},
			xAxis:{
				position: 'top'
			},
			//穿透的单击事件
			itemClick : function(itemParams) {
				if(itemParams.data.attr){
					drillDownDetail(itemParams.data.attr);
				}
			}
	};
	
	/**
	 * @param cdiv :图表的容器，div的element对象、div的id、jquery对象
	 * @param datas :传递过来的数据
	 * @param options ：图标的选项
	 * @returns {"chart":图对象,"options":图的选项}
	 */
	currentChart.seeyonChart = $.seeyoncharts(document.getElementById("taskChartReport"),barData,barOptions);
}
