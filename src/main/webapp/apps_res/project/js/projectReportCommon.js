//任务统计，唯一的公共变量
var classReport = new ClassReport();
/**公共方法*/
function showReportChart(){//显示图表
	showMenuClass("chart");
	classReport.showChart();
}

function showReportGrid(){//显示表格
	showMenuClass("grid");
	classReport.showGrid();
}

function forwardReport(){//转发协同
	var content = getCurrHtml();
	if(content == null){
		return;
	}
	$("#forwardToCol input[name='title']").val(classReport.options.reportResult.reportName);
	$("#forwardToCol input[name='content']").val(content);
	$("#forwardToCol").submit();
}

function printReport(){//打印页面
	var content = getCurrHtml();
	if(content == null){
		return;
	}
	var colBodyFrag= new PrintFragment("", content);
	
	var title = classReport.options.reportResult.reportName;
	var printsub = "<center><span style='font-size:24px;line-height:24px;'>"+title.escapeHTML()+"</span><hr style='height:1px' class='Noprint'&lgt;</hr><input type='hidden' name='rrsu' id='rrsu' value="+1+" /></center>";	
	var printSubFrag = new PrintFragment($.i18n('project.title'),printsub);
	var cssList = new ArrayList();
	cssList.add("/apps_res/collaboration/css/collaboration.css");
	
	var pl = new ArrayList();
	pl.add(printSubFrag);
	pl.add(colBodyFrag);
	printList(pl,cssList)
}

function exportReport(){//导出数据
	var _obj = getCurrExportParam();
	var _url = _ctxPath + "/project/project.do?method=exportReport";
	$('#exportExcel').jsonSubmit({
		action: _url,
		paramObj: _obj,
		callback:function(rval){}
	});
}

function getCurrExportParam(){
	var param;
	var current = getCurrMenu(); //判断当前是图还是表格
	if(current == "grid"){
		param = $("#"+classReport.options.conditionId).formobj();
		param.exportType = "excel";
		return param;
	}else if(current == "chart"){
		if(classReport.seeyonChart == undefined){
			$.alert($.i18n('project.report.export.nodata.chart'));
			return null;
		}
		param = new Object();
		param.reportName = classReport.options.reportResult.reportName;
		param.base64 = classReport.seeyonChart.chart.getDataURL("png");
		if($.isNull(param.base64)){
			$.alert($.i18n('project.report.chart.base64.disable'));
			return null;
		}
		param.exportType = "chart";
	}
	return param;
}

function getCurrHtml(){
	var current = getCurrMenu(); //判断当前是图还是表格
	if(current == "grid"){
		//克隆表格对象
		var gridDom = $("#taskGridReport").clone();
		//删除<a>标签下所有onclick属性
		gridDom.find("a").removeAttr("onclick");
		return gridDom.html();
	}else if(current == "chart"){
		if(classReport.seeyonChart == undefined){
			return $("#taskChartReport").html();
		}
		var base64 = classReport.seeyonChart.chart.getDataURL("jpeg");
		if($.isNull(base64)){
			$.alert($.i18n('project.report.chart.base64.disable'));
			return null;
		}
		return "<img src='"+base64+"'/>";
	}
}


function getCurrMenu(){
	if($(".projectTask_dimensionTab").find("#gridLi").hasClass("current")){
		return "grid";
	}else if($(".projectTask_dimensionTab").find("#chartLi").hasClass("current")){
		return "chart";
	}
}

function showMenuClass(type){//切换图/表图表选中
	var gridLi = $(".projectTask_dimensionTab").find("#gridLi");
	if(gridLi[0] == undefined){
		//如果是undefined则表示没有切换菜单，直接返回
		return;
	}
	var gridEm = $(".projectTask_dimensionTab").find("#gridEm");
	var chartLi = $(".projectTask_dimensionTab").find("#chartLi");
	var chartEm = $(".projectTask_dimensionTab").find("#chartEm");
	if(type == "chart"){
		gridLi.removeClass("current");
		chartLi.addClass("current");
		gridEm.removeClass("switchView_table_current_16");gridEm.addClass("switchView_table_16");
		chartEm.removeClass("switchView_chart_16");chartEm.addClass("switchView_chart_current_16");
	}else if(type = "grid"){
		gridLi.addClass("current");
		chartLi.removeClass("current");
		gridEm.removeClass("switchView_table_16");gridEm.addClass("switchView_table_current_16");
		chartEm.removeClass("switchView_chart_current_16");chartEm.addClass("switchView_chart_16");
	}
}

/**执行穿透操作*/
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

function initTaskReport(options){//获取报表数据
	var taskInfoReportManager_ = new taskInfoReportManager();
	if(options.conditionId){
		var obj=$("#"+options.conditionId).formobj();
		taskInfoReportManager_.getReportByAjax(obj,{
			success:function(result){
				options.reportResult = result;
				classReport.options = options;
				if(options.showContent == "10"){
					showReportGrid();
					//对表格中的姓名进行截取
					var table = $("#reportGrid td[name='nameT1']");
					for(var i=0;i<table.length&&table.length>0;i++){
						$("#taskGridReport td[name='nameT1']")[i].innerHTML =getSubString(table[i].innerHTML,0,10);
					}
				}else if(options.showContent == "20"){
					showReportChart();
				}
				bindReportTitle(options.reportId);
			}
		});
	}
}
/**
*绑定报表名称
*/
function bindReportTitle(reportId){
	if(PEOPLETASKREPORT==reportId){
		//人员任务统计
		$("#reportTitle").html($.i18n('taskmanage.report.peopleTask.label'));
	}else if(OVERDUETASKREPORT==reportId){
		//超期任务统计
		$("#reportTitle").html($.i18n('taskmanage.report.overdue.label'));
	}
}
/**
 * 按像素截取字符串
 * @author shuqi
 * @param string
 * @param start
 * @param length
 * @returns
 */
function getSubString(string,start,length){
	var len = 0;
	for(var i=start;len<length&&i<string.length;i++){
		if(!string.charCodeAt(i))  
            break;  
		if(string.charCodeAt(i)>255)
			len+=2;
		else
			len+=1;
		if(len>=length&&i+1==string.length){
			return string;
		}else if(len>=length){
			return string.substring(start,i)+"..";
		}
	}
	return string.substring(start,length);
}
/**报表类*/
function ClassReport(){}

/**显示表格方法*/
ClassReport.prototype.showGrid = function(){
	this.hideChart();
	if(classReport.options.gridId == undefined){
		return;
	}
	
	$("#"+classReport.options.gridId).show();
	if($("#"+classReport.options.gridId).html() != ""){
		return;
	}
	if(typeof classReport.options.funShowGrid == "function"){
		classReport.options.funShowGrid(classReport.options.reportResult);
	}else{
		this.showCommonGrid(classReport.options);
	}
}

ClassReport.prototype.hideGrid = function(){
	if(classReport.options.gridId){
		$("#"+classReport.options.gridId).hide();
	}
}

ClassReport.prototype.showChart = function(){
	this.hideGrid();
	if(classReport.options.chartId == undefined){
		return;
	}
	
	$("#"+classReport.options.chartId).show();
	if($("#"+classReport.options.chartId).html() != ""){
		return;
	}
	if(typeof classReport.options.funShowChart == "function"){
		classReport.options.funShowChart(classReport.options.reportResult);
	}
}

ClassReport.prototype.hideChart = function(){
	if(classReport.options.chartId){
		$("#"+classReport.options.chartId).hide();
	}
}

/**常用的显示表*/
ClassReport.prototype.showCommonGrid = function(options){
	var gridId = options.gridId;
	var jqueryDom = $("#"+gridId);
	if(!options.reportResult.hasResultData){//没有数据
		if(options.reportId==PEOPLETASKREPORT){
			jqueryDom.html("<center>"+$.i18n('project.has.not.task')+"</center>");
		}else{
			jqueryDom.html("<center>"+$.i18n('project.has.not.voerTime.task')+"</center>");
		}
		jqueryDom.css("padding-top",$("#taskChartReport").height()/2-10);
	}else{
		jqueryDom.html(options.reportResult.gridData.table);
		if(jqueryDom.find("td").length==0){
			var str="<tr><td colspan='6' style='text-align:center'>"+$.i18n('report.chart.noData')+"</td></tr>";
			jqueryDom.find("tr").after(str);
		}
		$("[name='overdueT3'] a").css("color","red");
		$("[name='overdueT2'] a").css("color","red");
		$("table td,table th").css("text-align","center");
	}
}
//人员任务统计和超期任务统计更多
function drillowReportUrl(preUrl){
	var body=$('#body', parent.parent.document);
	body.attr("src",preUrl);
	body.parent().css("margin-top","-8px");
}