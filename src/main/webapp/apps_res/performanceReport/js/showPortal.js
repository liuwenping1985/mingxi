//协同V5.0 OA-28833
function inputNoDataInfo(){
  if(PROJECTSCHEDULESTATISTICS === Constants_report_id){
	  if(param.indexOf("selfRole") === -1){
          //项目进度统计
    	  $("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>" + $.i18n('report.chart.noData') + "</div>");
	  	  return false;
	  }
  }else if(Constants_report_id === TASKBURNDOWNSTATISTICS){
    //任务燃尽图输入条件为空，特殊处理
    if(param.indexOf("task_id") === -1){
      $("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>" + $.i18n('report.chart.noData') + "</div>");
      return false;
    }
  }else if(Constants_report_id === EFFICIENCYANALYSIS || Constants_report_id === NODEANALYSIS 
		  || Constants_report_id === OVERTIMEANALYSIS || Constants_report_id === IMPROVEMENTANALYSIS){
  	//超时分析,效率分析,节点分析,改进分析
  	if(param.indexOf("templeteId") === -1){
      $("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>" + $.i18n('report.chart.noData') + "</div>");
      return false;
    }
  }else if(Constants_report_id === STORAGESPACESTATISTICS || Constants_report_id===KNOWLEDGESCORESTATISTICS){
  	if(param.indexOf("managerRangeIds")==-1){
  		//存储空间统计,知识积分排行榜默认人员为空,特殊处理
  		$("#queryResult").html("<div class='h100b' style='line-height:190px;text-align:center;font-size:12px'>" + $.i18n('report.chart.noData') + "</div>");
        return false;
  	}
  }
}

function executeStatistics(){
	var performanceQueryManager_ = new performanceQueryManager;
	 performanceQueryManager_.getReportByPortal(param,{success:
		   function(retObj){
			 reportParams=retObj;
			 if(!$.isNull(retObj.task_id)){
			 	$("#task_id").val(retObj.task_id);
			 }
			 if(!$.isNull(retObj.isNull)){
		       	if(retObj.isNull==true){
			   		$.alert($.i18n('统计人员为空,不能进行统计!'));//统计人员为空,不能进行统计
			   		return;
			  	}
		   		}
			 if(!$.isNull(retObj.OutOfRange)){
			      if(retObj.OutOfRange==true){
				   $.alert($.i18n('performanceReport.portal.selectOvercrowding'));//由于统计人数过多，为了不影响统计速度，请您选择50人之内！
				  }
			 }
		     //报表id
			 Constants_report_id = retObj.reportId;
			 Constants_report_Name = retObj.reportName;
			 //查看团队报表标记
			 Constants_report_flag = retObj.viewFlag;
			 //同时隐藏个人和团队报表页签
			 hiddenAllTab = retObj.hiddenAllTab;
			 hiddenChartGridTab = retObj.hiddenChartGridTab; 
			 //form回填标记（执行统计后要保存工作区）
			 reOnloadflag = retObj.ffqueryConditionForm;
			 //个人团队页签不需要回填
			 personGroupTab =($.isNull(retObj.personGroupTab)?1:parseInt(retObj.personGroupTab));
			 //列表总条数，分页使用
			 pageTotle = retObj.pageTotle;
			 if(Constants_report_id == KNOWLEDGESCORESTATISTICS){// 如果是知识积分排行榜，则设置分页组件的页数和条数
			     configPageTotalAndSize();
			 } else if(Constants_report_id === KNOWLEDGEACTIVITYSTATISTICS && reportParams.pageTotle === 3){//OA-40886
			     if(reportParams.dataObjectList.length>1){
			         reportParams.dataObjectList[reportParams.dataObjectList.length-1][0].display='平均值';
			     	}
			 } else if(Constants_report_id === ONLINESTATISTICS){
                 if(reportParams.dataObjectList.length>1){
                   reportParams.dataObjectList[reportParams.dataObjectList.length-1][0].display='平均值';
                 }
             } 
             //六张老报表所需参数
	         flowType=retObj.flowType;
	         start_time=retObj.start_time;
	         end_time=retObj.end_time;
	         appTypeName=retObj.appTypeName;
	         templeteId_=retObj.templeteId;
			 //栏目更多按钮标志
			 isMore=retObj.isMore;
			 //以后切换图形时需要动态获取图形数据
			 if(!$.isNull(retObj.report)){ result = retObj.report.chartList; }   
			 $("#queryResult").html("");
			 if(tableChartTab == 2){
	             if(Constants_report_id === COMPREHENSIVEANALYSIS){ 
	             	drawComprehensive(); 
	             }
	             else{ 
	             	drawingDefualt(personGroupTab); 
	             }
		     	 //OA-72336表单应用主题空间，常用表单 栏目 在ie7下 有两个纵向滚动条
		     	 if("7.0" === $.browser.version){ $("#queryResult li").css("width","95%"); } } else { drawGrid(); }
			     hideTab(1); 
		     }
		});
}
 
//增加一个页面销毁操作，一定程序缓解页面内存溢出问题
function removeChart(){ try{$("body").empty();}catch(e){} }


