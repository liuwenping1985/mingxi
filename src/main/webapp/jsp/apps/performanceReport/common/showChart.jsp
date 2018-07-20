<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script>
<script type="text/javascript">
var comprehensiveChart;
var chartIndex=0;
//综合分析渲染图
function drawComprehensive(){
  	if(!$.isNull(result)){
	      if(result.length == 0){
	      	if(isPortal!='true'){
	        	inputNoDataInfo(Constants_report_id);
	        }else{
	        	$("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>${ctp:i18n('report.chart.noData')}</div>");
	        }
	        return;
	      }
		  var chartWidth=reportParams.chartWidth;
		  var chartHeight=reportParams.chartHeight;
		  var className='left';
		  if(Constants_report_id!=PROJECTSCHEDULESTATISTICS){
			  className+=' w100b';
		  }
		  var styles='';
		  if(chartObjS!=null){
			  for(var i=0;i<chartObjS.length;i++){
			  try{
					chartObjS[i].chart.remove();
				}catch(e){}
			  }
		  }
		  if(Constants_report_id==COMPREHENSIVEANALYSIS){
				$("#queryResult").append("<li style='background:#fff;font-size:12px;text-align:center' id='chooseChart'><input type='radio' onclick='analysisTypeClick(0);' id='analysisType1' name='analysisType' value='1' checked='checked'>${ctp:i18n('performanceReport.workFlowAnalysis.chartUseRadio')}&nbsp;&nbsp; <input type='radio' onclick='analysisTypeClick(1);' id='analysisType2' name='analysisType' value='2'>${ctp:i18n('performanceReport.workFlowAnalysis.charEfficiency')}&nbsp;&nbsp;<input type='radio'onclick='analysisTypeClick(2);' id='analysisType3' name='analysisType' value='3'>${ctp:i18n('performanceReport.workFlowAnalysis.chartOverTimeRatio')}</td></li>");
			}
			if(result.length==1) {//如果只有一个图
				className="";//h100b会导致出现无谓的滚动条
				styles="width:100%;height:98%";
			}else{
				styles="width:100%;height:48%;";//如果不止一个图,每个图高度为48%
			}
			if(Constants_report_id==PROJECTSCHEDULESTATISTICS){//如果是项目进度统计,图的宽度和高度缩小
				styles="width:129px;height:129px";
			}
			var chartDiv="queryResult"+i;//如果不止一个图
			$("#queryResult").append("<li class='one_row "+className+"' style='background:#fff; "+styles+"' name='chart' id='"+chartDiv+"'></li>");
			if(Constants_report_id==COMPREHENSIVEANALYSIS){
				$("#queryResult").append("<li class='one_row "+className+"' style='background:#fff; "+styles+"' id='chart'></li>");
			}
			var anyChartDefualt = new Object();
			if(!$.isNull(chartWidth)){
				anyChartDefualt.width =parseInt(chartWidth);
			}
			if(!$.isNull(chartHeight)){
				anyChartDefualt.heigth =parseInt(chartHeight);
			}
			anyChartDefualt.htmlId = chartDiv;
			anyChartDefualt.chartJson = result[chartIndex];
			anyChartDefualt.fromReport = true; //特别标识：针对报表会设定许多默认参数
			anyChartDefualt.event = [{name:"pointClick",func:onPointClick},{name:"draw",func:function(e){drawInit()}}];
			anyChartDefualt.debugge = true;
			comprehensiveChart=new SeeyonChart(anyChartDefualt);
	  }
}

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
		  if(chartObjS!=null){
			  for(var i=0;i<chartObjS.length;i++){
			  try{
					chartObjS[i].chart.remove();
				}catch(e){}
			  }
		  }
		  if(Constants_report_id===PROJECTSCHEDULESTATISTICS){
		  		//项目进度统计
		  		drawProject(0);
		  }else{
		  for(var i=0;i<result.length;i++){
			if(result.length==1) {//如果只有一个图
				className="";//h100b会导致出现无谓的滚动条
				styles="width:100%;height:98%";
			}else{
				styles="width:100%;height:48%;";//如果不止一个图,每个图高度为48%
			}
			if(Constants_report_id==PROJECTSCHEDULESTATISTICS){//如果是项目进度统计,图的宽度和高度缩小
				styles="width:129px;height:129px";
			}
			var chartDiv="queryResult"+i;//如果不止一个图
			$("#queryResult").append("<li class='one_row "+className+"' style='background:#fff; "+styles+"' name='chart' id='"+chartDiv+"'></li>");
			var anyChartDefualt = new Object();
			if(!$.isNull(chartWidth)){
				anyChartDefualt.width =parseInt(chartWidth);
			}
			if(!$.isNull(chartHeight)){
				anyChartDefualt.heigth =parseInt(chartHeight);
			}
				anyChartDefualt.htmlId = chartDiv;
				anyChartDefualt.chartJson = result[i];
				anyChartDefualt.fromReport = true; //特别标识：针对报表会设定许多默认参数
				anyChartDefualt.event = [{name:"pointClick",func:onPointClick}];
				anyChartDefualt.debugge = true;
				chartObjS[i]=new SeeyonChart(anyChartDefualt);
			}
			}
	  }
}

var count=0;
var currentIndex=0;
function drawProject(index){
	//每六个图一组加载
	currentIndex = index+6;
	for(var i=index;i<index+6;i++){
		if(i>result.length-1||(isPortal=="true"&&i>=showNumber)){
			return;
		}
		if(reportParams.dataList.length==0){
			styles="width:100%;height:100%";
		}else{
			styles="width:129px;height:129px";
		}
		var chartDiv="queryResult"+i;//如果不止一个图
		$("#queryResult").append("<li class='one_row left' style='background:#fff; "+styles+"' name='chart' id='"+chartDiv+"'></li>");
		var anyChartDefualt = new Object();
		anyChartDefualt.htmlId = chartDiv;
		anyChartDefualt.chartJson = result[i];
		anyChartDefualt.fromReport = true; //特别标识：针对报表会设定许多默认参数
		anyChartDefualt.debugge = true;
		anyChartDefualt.event = [{name:"pointClick",func:onPointClick},{name:"draw",func:function(){
			count++;
			if(count%6==0 && result.length > currentIndex){
				drawProject(currentIndex);
			}
		}}];
		chartObjS[i]=new SeeyonChart(anyChartDefualt);
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
	      if(!id){
	    	  //不常用功能,二月修复包bug,偷懒解决了
			  id = throughQueryUrl.split("&")[1].split("=")[1];
	      }
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
		  }else if(Constants_report_id==PROCESSPERFORMANCEANALYSIS){
			  title = '${ctp:i18n("performanceReport.queryMain_js.processPerformanceAnalysis.through.title")}';
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
  
    //穿透列表转发协同 --xiangfan
  function throughListForwardCol(content, reportTitle){
	 if(queryDialog)
	 queryDialog.close();
     $("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
     $('#reportContent').val(content);
     $('#reportTitle').val(reportTitle);
	 $("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
	 $("#queryConditionForm").submit();
  }
</script>