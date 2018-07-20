<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryCommon.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/section/portalHtml_js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common/fillCondition.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common/reportOption.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" src="${path }/apps_res/hr/js/date.js"></script>
<script type="text/javascript" src="${path }/apps_res/workFlowAnalysis/js/workflowAnalysis.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=performanceQueryManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=workFlowAnalysisManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=reportAuthManager"></script>
<script type="text/javascript">
//执行查询后返回的参数
   var reportParams={};
   //报表id
    var Constants_report_id="${reportId}";
    var tabPerson=1;
    var tabGroup=2;
    var tabPersonGroup=3;
    var isPortal="${isPortal}";
    var isMore='';
    var old_flag=false;
    //是否为集团管理员
    var isGroupAdmin="${isGroupAdmin}";
    //是否为管理员
    var isAdministrator="${isAdministrator}";
    //同时隐藏个人和团队报表页签
    var hiddenAllTab="${hiddenAllTab}";
    var hiddenChartGridTab="${hiddenChartGridTab}";
    //个人团队页签
    var personGroupTab =(("${personGroupTab}"=="")?1:parseInt("${personGroupTab}"));
   //查看团队报表标记
    var Constants_report_flag="${viewFlag}";
    //后台当前时间 "yyyy-MM-dd HH:mm:ss"
    var presentTime = "${presentTime}";
    $(function () { 
    	reportInit();
    	$("#reportCategory").change(function(){
			var reportCategory=$(this).val();
			categoryChange(reportCategory);
		})
    }); 
    //work选择区
	function selectWorkSpace(){
	switch(Constants_report_id){
		case WORKDAILYSTATISTICS://日常工作统计条件区
		   //workTotal();	
		  workTotal_();
		  //workTotalChange();
		  $("#appType").change(changeType);
		  $("#coltype td").eq(0).attr("width","70%");
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.workTotal')}");
		break;
		case PLANRETURNSTATISTICS://计划提交回复统计
		  planReturn();
		  planReturnChange();
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.planReturn')}");
		break;
		case MEETINGJOINSTATISTICS://会议参加情况统计
		  meetingJoin();
		  $("#time").change(timeChange);
		  $("#time").val("2");
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.meetingJoin')}");
		break;
		case MEETINGJOINROLESTATISTICS://会议参加角色情况统计
		  meetingJoinRole();
		  $("#time").change(timeChange);
		  $("#time").val("2");
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.meetingJoinRole')}");
		break;
		case TASKBURNDOWNSTATISTICS://任务燃尽图
		  taskBurndown();
		  hideTab(tabGroup);
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.taskBurndown')}");
		  $("#taskInfo").click(taskInfoChange);
		break;
		case KNOWLEDGEINCREASESTATISTICS://知识增长趋势
		  knowledgeIncrease();
		  $(".mycal").each(function(){$(this).compThis();});
	        //var date=new Date();
	        var date = new Date(presentTime.replace(/-/,"/"));
	    	var fromDate=date.print("%Y-%m");
	    	toDate=date.print("%Y-%m");
	    	$("#start_time").val(timeMonthCal(12));
	    	$("#end_time").val(fromDate);
		  hideTab(tabGroup);
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.knowledgeIncrease')}");
		break;
		case KNOWLEDGESCORESTATISTICS://知识积分排行榜
		  knowledgeScore();
		  $("#time").change(timeChange);
		  hideTab(tabGroup);	
		  if(tableChartTab==1){
		  $(".common_over_page").show();
		  }
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.knowledgeScore')}");	  
		break;
		case KNOWLEDGEACTIVITYSTATISTICS://知识社区活跃度
		  knowledgeActivity();
		 // hideTab(tabPerson);
		 //if(personGroupTab==1){
			 //$("#managerRange").attr("disabled","disabled");
		 //}
		 $("#manager_range").children().eq(0).removeClass("common_txtbox_wrap");
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.knowledgeActivity')}");  
	    break;
		case ONLINESTATISTICS://在线人数趋势
		  onlineStatistics();
		//  $(".calendar_icon").css("display","none");
		  $(":radio").change(onlineStatisticsChange);
		  $(".mycal").each(function(){$(this).compThis();});
		  $("#start_time").attr("disabled",true);	  
		  hideTab(tabPerson);		
		  $(".calendar_icon").hide();
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.onlineStatistics')}");   
		break;	
		case ONLINEMONTHSTATISTICS://在线人数趋势(按月)
			  onlineStatistics();
			//  $(".calendar_icon").css("display","none");
			  $(":radio").change(onlineStatisticsChange);
			  $(".mycal").each(function(){$(this).compThis();});
			  $("#start_time").attr("disabled",true);		  
			  hideTab(tabPerson);		
			  $(".calendar_icon").hide();
			  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.onlineStatistics')}");   
			break;			
		case ONLINETIMESTATISTICS://在线时间分析
		  onlineTime();	  
		  $("#time").change(timeChange);
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.onlineTime')}"); 
		break;
		case EVENTSTATISTICS://事项统计
			eventStatistics();
			  $("#time").change(timeChange);	 
			  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventStatistics')}");  
		break;	
		case PROJECTSCHEDULESTATISTICS://项目进度统计
			projectScheduleStatistics();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.projectScheduleStatistics')}");  
		break;
		case STORAGESPACESTATISTICS://存储空间统计
			storageSpaceStatistics();
			 // $("#time").change(timeChange);	 
			 hideTab(tabPerson);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.storageSpaceStatistics')}");  
		break;
		case FLOWSENTANDCOMPLETEDSTATISTICS://流程已办已发统计
			eventSentAndCompletedStatistics();
			SentAndCompletedChange();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventSentAndCompletedStatistics')}");  
		break;		
		case FLOWSENTANDCOMPLETEDSTATISTICSFORM://流程已办已发统计(表单)
			eventSentAndCompletedStatistics();
			SentAndCompletedChange();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventSentAndCompletedStatistics')}");  			
		break;		
		case FLOWSENTANDCOMPLETEDSTATISTICSEDOC://流程已办已发统计(公文)
			eventSentAndCompletedStatistics();
			SentAndCompletedChange();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventSentAndCompletedStatistics')}");  			
		break;
		case FLOWOVERTIMESTATISTICS://流程超期统计
			flowOverTimeStatistics();
			flowOverTimeChange();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.flowOverTimeStatistics')}");  
		break;		
		case FLOWOVERTIMESTATISTICSFORM://流程超期统计-表单
			flowOverTimeStatistics();
			flowOverTimeChange();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.flowOverTimeStatistics')}");  
		break;			
		case FLOWOVERTIMESTATISTICSEDOC://流程超期统计-公文
			flowOverTimeStatistics();
			flowOverTimeChange();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.flowOverTimeStatistics')}");  
		break;
		case EFFICIENCYANALYSIS://效率分析
			effeiciencyAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time").val(getNowDay());
			$("#Category").remove();
			old_flag=true;
			$("#personGroupTab").val(1);
		break;
		case NODEANALYSIS://节点分析
			nodeAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time").val(getNowDay());
			$("#Category").remove();
			old_flag=true;
			$("#personGroupTab").val(1);
		break;
		case OVERTIMEANALYSIS://超时分析
			overTimeAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time").val(getNowDay());
			$("#queryCondition div").eq(0).removeClass("form_area set_search one_row");
			$("#Category").remove();
			old_flag=true;
			$("#personGroupTab").val(1);
		break;
		case IMPROVEMENTANALYSIS://改进分析
			improvementAnalysis();
			var date = new Date(presentTime.replace(/-/,"/"));
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time1").val(getFirstDayOfMonth('${productUpgrageDate}',true));
			$("#end_time1").val(date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',true)));
			$("#start_time2").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time2").val(date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',false)));
			$("#Category").remove();
			old_flag=true;
			$("#personGroupTab").val(1);
		break;
		case COMPREHENSIVEANALYSIS://综合分析
			comprehensiveAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getLastYearMonth('${productUpgrageDate }'));
			$("#end_time").val(getLastYearMonth('${productUpgrageDate }'));
			$("#flowType").parent().parent().attr("width","");
			$("#Category").remove();
			old_flag=true;
			$("#personGroupTab").val(1);
			$("#flowType").change(clearTempChoose);
		break;
		case PROCESSPERFORMANCEANALYSIS://流程统计
			processAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val('${defaultBeginDate }');
			$("#end_time").val('${defaultEndDate }');
			$("#flowType").parent().parent().attr("width","");
			$("#Category").remove();
			old_flag=true;
			$("#personGroupTab").val(1);
		break;
	  }
	  
	  if(Constants_report_id!=FLOWSENTANDCOMPLETEDSTATISTICS&&Constants_report_id!=FLOWOVERTIMESTATISTICS&&Constants_report_id!=PLANRETURNSTATISTICS
    	&&Constants_report_id!=WORKDAILYSTATISTICS&&Constants_report_id!=EVENTSTATISTICS&&Constants_report_id!=ONLINETIMESTATISTICS&&Constants_report_id!=MEETINGJOINSTATISTICS
    	&&Constants_report_id!=PLANRETURNSTATISTICSGROUP&&Constants_report_id!=EVENTSTATISTICSGROUP&&Constants_report_id!=MEETINGJOINROLESTATISTICS&&Constants_report_id!=KNOWLEDGEACTIVITYSTATISTICS){
    		//$("#tabs_head").html('');
    	}else{
    		if(Constants_report_flag==false||Constants_report_flag=='false'){
		  		$("#managerRange").val($.ctx.CurrentUser.name);
		  		$("#managerRange").attr("disabled",'true');
		  	}else{
		  		var reportCategory=$("#reportCategory").val();
		  		if(reportCategory=='1'){
		  			$("#managerRange").val($.ctx.CurrentUser.name);
		  			$("#managerRangeIds").val('Member|'+$.ctx.CurrentUser.id);
		  		}
	  		}
    	}
		//去除保存和重置按钮
		$("#button_div").remove();
	}
//初始化
  function reportInit(){
	  //默认不显示分页控件        
	        $(".common_over_page").hide();
	    	//动态生成栏目下拉列表
			if(Constants_report_flag!="false"){
				//报表类型:个人报表,团队报表
				if(Constants_report_id!=ONLINESTATISTICS && Constants_report_id != ONLINETIMESTATISTICS && Constants_report_id != EVENTSTATISTICS){
						var hh="<table><tr><td><span style='font-size:12px'>${ctp:i18n('performanceReport.queryMain_js.reportType.title')}:</span></td>"+
						"<td><select id='reportCategory'><option value='1' selected='selected'>${ctp:i18n('performanceReport.queryMain_js.reportType.personalReport')}"+
						"</option><option value='2'>${ctp:i18n('performanceReport.queryMain_js.reportType.teamReport')}</option></select></td></tr></table>";
						$("#Category").html(hh);
				}
			}
	      	//初始化条件区域
		    selectWorkSpace();
	        $("#managerRange").live("click",function(){
	        	selectPerson();
	        });
			fillPortalChange();
			if(hiddenChartGridTab=='true'){
				$("body").removeClass("page_color");
			}
  }

 
    function displayReportName(name){
    	 $("#reportName").html(name);
    }  
     //日常工作统计类型切换事件
    function changeType(){
    	var type=$("#appType").val();
    	$("#rowOcc").next().html("");
    	var hh='';
    	if(type=='6'){
    		//全部待办
    		hh=getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='100%'><div class='common_selectbox_wrap' id='timeDiv'><select id='time'><option value='3' selected>${ctp:i18n('performanceReport.queryMain.all.Cumulative')}</option></select></div></td>";
    		$("#coltype").html(hh);
    	}else if(type=='0'||type=='1'){
    		//协同/公文
    			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+
	    		"<td width='70%'><div class='common_selectbox_wrap'><select id='status'>"+
	    		"<option value='0' width='100%' selected>${ctp:i18n('performanceReport.queryMainHtml.typeDone')}</option>"+
	    		"<option value='1' >${ctp:i18n('performanceReport.queryMainHtml.typeSent')}</option>"+
	    		"<option value='2' >${ctp:i18n('performanceReport.queryMainHtml.typeUndo')}</option>"+
	    		"<option value='3' >${ctp:i18n('performanceReport.queryMainHtml.typeTempUndo')}</option>"+
	    		"<option value='4' >${ctp:i18n('performanceReport.queryMainHtml.typeArchived')}</option>"+
	    		"</select></div></td>";
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	//$("#rowOcc").html(hh);
		    	//$('#rowTime').html(getTime_());
		    	//$("#status").change(statusChange);
    	}else if(type=='2'){
    		//计划
    			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+
	    		"<td width='70%'><div class='common_selectbox_wrap'><select id='status'>"+
	    		"<option value='0' width='100%' selected>${ctp:i18n('performanceReport.queryMainHtml.typePublished')}</option>"+
	    		"<option value='1' >${ctp:i18n('performanceReport.queryMainHtml.typeReceived')}</option>"+
	    		"<option value='2' >${ctp:i18n('performanceReport.queryMainHtml.typeReplied')}</option>"+
	    		"<option value='3' >${ctp:i18n('performanceReport.queryMainHtml.typeUnreply')}</option>"+
	    		"<option value='4' >${ctp:i18n('performanceReport.queryMainHtml.typeArchived')}</option>"+
	    		"</select></div></td>";
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	//$("#rowOcc").html(hh);
		    	//$('#rowTime').html(getTime_());
		    	//$("#status").change(statusChange);
    	}else if(type=='3'){
    		//会议
    			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+
	    		"<td width='70%'><div class='common_selectbox_wrap'><select id='status'><option value='0' width='100%' selected>${ctp:i18n('performanceReport.queryMainHtml.typeSent')}</option>"+
	    		"<option value='1' >${ctp:i18n('performanceReport.queryMain.start.label')}</option>"+
	    		"<option value='2' >${ctp:i18n('performanceReport.queryMain.ready.start')}</option>"+
	    		"<option value='3' >${ctp:i18n('performanceReport.queryMainHtml.typeArchived')}</option>"+
	    		"</select></div></td>"
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	//$("#rowOcc").html(hh);
		    	//$('#rowTime').html(getTime_());
		    	//$("#status").change(statusChange);
    	}else if(type=='4'){
    		//任务
    			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+
	    		"<td width='70%'><div class='common_selectbox_wrap'><select id='status'>"+
	    		"<option value='0' width='100%' selected>${ctp:i18n('performanceReport.queryMainHtml.typeFinish')}</option>"+
	    		"<option value='1' >${ctp:i18n('performanceReport.queryMainHtml.typeInProgress')}</option>"+
	    		"<option value='3' >${ctp:i18n('performanceReport.queryMainHtml.typeUnstart')}</option>"+
	    		"<option value='4' >${ctp:i18n('performanceReport.queryMainHtml.typeCanceled')}</option>"+
	    		"<option value='5' >${ctp:i18n('performanceReport.queryMain.create.label')}</option>"+
	    		"<option value='6' >${ctp:i18n('performanceReport.queryMain.unfinished')}</option>"+
	    		"</select></div></td>";
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	//$("#rowOcc").html(hh);
		    	//$('#rowTime').html(getTime_());
		    	//$("#status").change(statusChange);
    	}else{
    		hh=getTime_();
    		$("#coltype").html(hh);
    	}
    	if(personGroupTab==2&&$(".error-title").attr('class')!=undefined){
    		$("#type_td table tr").eq(0).html(getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true));
    		$("#querySave").attr('disabled',false).removeClass('common_button_disable');
    	}
    	hiddenTab();
    }
    
    function statusChange(){
    	var status=$("#status").val();
    	var appType=$("#appType").val();
    	var hh=getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='65%'><div class='common_selectbox_wrap' id='timeDiv'><select id='time'><option value='3' selected>${ctp:i18n('performanceReport.queryMain.all.Cumulative')}</option></select></div></td>";
    	if(((status=='2'||status=='3')&&(appType=='0'||appType=='1'))//协同,公文   	
    	||(status=='3'&&appType=='2')//计划
    	||(status=='2'&&appType=='3')//	会议
    	||(appType=='4'&&status=='6')){//任务
    			$("#rowOcc").next().html(hh);
    			$("#timeDiv").parent().prev().children().removeClass('margin_r_10');
    			$("#appType").css('width','100%');
    	}else{
    			$("#rowOcc").next().html(getTime_());
    			$("#timeAll").removeAttr('width');
    			$("#timeDiv").parent().prev().children().removeClass('margin_r_10');
    	}
    }
  //时间任意选择框
  function timeChange(){
	  var swidth='150';
 	 if(hiddenChartGridTab=='true'){
 		 swidth='60'
 	 }
	  var time=$("#time").val();
	  if(time=="4"){
		  if($("#start_time").length>0)return; 
		  var hh="";
		  if(hiddenChartGridTab=='true'){
			  hh+="<td width='60' nowrap='nowrap' id='start_time_td'><input id='start_time' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></td>";
	         	 hh+="<td id='mid'>-</td>"+"<td width='60' nowrap='nowrap'  id='end_time_td'><input  id='end_time' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></td>";  
		  }else{
			  hh+="<td width='120' nowrap='nowrap' id='start_time_td'><div class='common_txtbox_wrap'><input id='start_time' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
	         	 hh+="<td id='mid'>-</td>"+"<td width='120' nowrap='nowrap'  id='end_time_td'><div class='common_txtbox_wrap'><input  id='end_time' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
	          
		  }
		  $("#timeAll").after(hh);
		  $("#manager_range").attr("width", "108px");
		  $(".mycal").each(function(){$(this).compThis();});
		  if(hiddenChartGridTab=='true'){
			  $("#timeAll").attr("width","");
			  $("#start_time_td").attr("class","padding_l_5");
			  $("#end_time_td").attr("width","100%");
			  $("#time_td").attr("width","");
			  $(".form_area_content").attr("width","");
		  }else{
		    //解决IE7下不显示下拉选择的问题
		  	$("#timeAll").attr("width","80");
		  	if(Constants_report_id==WORKDAILYSTATISTICS){
		  		var appType=$("#appType").val();
		  		if(appType==5||appType==7){
		  			$("#type_td table").css('width','300px');
		  			$("#managerRange").css('width','200px');
		  			$("#manager_range").attr('width','200px');
		  			$("#manager_range").attr('colSpan','5');
		  			$("#rowOcc td").attr('width','100%');
		  			$("#time").css('width','50px');
		  			$("#timeAll").attr('width','50px');
		  		}else{
		  			$("#appType").css('width','32%');
		  		}
		  	}
		  }
		  $("#ff_td").css("width","260px");
		  //$("#timeAll").attr("width","");
	  }else{
		  $("#timeAll").nextAll().remove();
		  $("#timeDiv").addClass("common_selectbox_wrap");
		  //$("#end_time_td,#mid,#end_time,#start_time_td,#end_time_td,.calendar_icon").remove();//.css("display","none");
		  //$("#timeAll").attr("width","100%");
		  $("#manager_range").attr("width", "108px");
		  if(Constants_report_id==WORKDAILYSTATISTICS){
		  		var appType=$("#appType").val();
		  		if(appType==5||appType==7){
		  			$("#type_td table").css('width','');
		  			$("#managerRange").css('width','100px');
		  			$("#manager_range").attr('colSpan','5');
		  			$("#rowOcc td").attr('width','113px');
		  			$("#time").css('width','113px');
		  			$("#timeAll").removeAttr('width');
		  		}else{
		  			$("#appType").css('width','100%');
		  		}
		  }
	  }
	  if(Constants_report_id==KNOWLEDGESCORESTATISTICS){//知识积分排行榜
		  $("#manager_range div").removeClass("common_txtbox_wrap");
	  }
  }
//========================================================栏目相关js begin=======================================================
		
	function fillPortalChange(){
		var pt=new Object();
		var pv = getA8Top().paramValue;
		var st=pv.split(",");
		for(var i=0;i<st.length;i++){
			var mt=st[i].split("=");
			if(mt.length>=2){
				pt[mt[0]]=mt[1];
			}else{
				pt[mt[0]]="";
			}
			if(st[i].indexOf('Member')!=-1&&st[i].indexOf('personIds')==-1&&'personIds' in pt){
				//仅流程统计选择多人
				pt["personIds"]=pt["personIds"]+","+mt[0];
			}else if(st[i].indexOf('departmentIds')==-1&&'departmentIds' in pt){
				//流程统计选择多部门,id
				pt["departmentIds"]=pt["departmentIds"].replaceAll('、',',',false);
			}else if(st[i].indexOf('department')==-1&&'department' in pt){
				//流程统计选择多部门,名称
				pt["department"]=pt["department"].replaceAll('、',',',false);
			}else if(st[i].indexOf('managerRangeIds')==-1&&'managerRangeIds' in pt){
				//团队报表选择多人,多部门
				pt["managerRangeIds"]=pt["managerRangeIds"].replaceAll('、',',',false);
			}
		}
		if(pt["reportCategory"]&&pt['reportCategory']=='2'){
			$("#reportCategory").val(pt["reportCategory"]);
			categoryChange(reportCategory);
			delete pt.reportCategory;
		} 
	   if(pv!=''){
	   	  if(pt["templeteId"]!=undefined&&pt["templeteId"]!=''&&pt["templeteName"]==undefined){
	   	  	var performanceQueryManager_=new performanceQueryManager;
	   	  	var templeteIds=pt["templeteId"];
	   	  	performanceQueryManager_.getTemplateNameByIds(templeteIds,{success:
	   	  		function(retObj){
	   	  			var str=retObj.templateName;
	   	  			pt["templeteName"]=str;
	   	  			fillCondition(pt);
	   	  		}
	   	  	})
	   	  }else{
	   	  	fillCondition(pt);
	   	  }
	   }
	   if(old_flag==true){
			if($("#allTemplete").attr("checked")!="checked"){
				//栏目更多,去除流程统计置灰效果
				$("#templeteName").show().attr("disabled",false);
				$("#specTempleteDiv").show();
			}
		}
	  hiddenTab();
	}
    function categoryChange(reportCategory){
		if(reportCategory=="1"){
            personGroupTab = 1;
            selectWorkSpace();
            hiddenTab();  
		}else{
	         personGroupTab = 2;
	         selectWorkSpace();
	         //$("#personManagerRange").removeClass("hidden");
	         hiddenTab(); 
		}
    }
    
    //检测日常工作统计团队报表人员值
    function checkInput(){
    		var checkTemplate=$("#templeteName").validate();
    		var checkPerson=$("#managerRange").validate();
    		var checkTaskInfo=$("#taskInfo").validate();
    		if(checkTemplate==true&&checkPerson==true&&checkTaskInfo==true){
    			return true;
    		}else{
    			if(Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS){
    			//知识社区活跃度
    				$("#managerRange").parent().css("width",'100px');
    			}
    			return false;
    		}
    }
 	//解析栏目条件
    function OK(){	
    	if(!checkInput()){
    		return false;
    	}
    	if(Constants_report_id==PROCESSPERFORMANCEANALYSIS){
    		//流程统计,给statType,statWhat赋值
    		processStatType();
    	}
    	var content=$("#tabs input");
    	var select=$("#tabs select");
    	var staTime = $("#start_time").val();
    	var enTime = $("#end_time").val();
    	if(checkInputValue()&&checkStartEndDate(staTime,enTime)&&checkStatus()&&checkDate(staTime,enTime)){
	    	var array=new Array();
	    	var arr=new Array();
	    	var j=0;
	    	$.each(content,function(i,n){
	    		var item=$(n);
	    		if(item.attr("type")=='hidden'){
	    			//设置好条件区后单独处理一下选人界面
	    			if(item.attr("id")=="managerRangeIds"||item.attr("id")=="departmentIds"){
	    				var managerRangeIds=item.val();
	    				array[j]=""+item.attr('id')+"="+managerRangeIds.replaceAll(',','、',false);
	    			}else if(item.attr("id")=="templeteId"){
	    				//替换模板名称和模板Id的","为"|"
	    				var value=item.val().replaceAll(",","|",false);
	    				array[j]=""+item.attr("id")+"="+value;
	    			}else{
		    			array[j]=""+item.attr("id")+"="+item.val();
	    			}
	    			j++;
	    		}
	   			if(item.attr("type")=='checkbox'||item.attr("type")=='radio'){
	   				if(item.attr("checked")=='checked'){
		   				array[j]=""+item.attr("id")+"="+item.val();
		   				j++;
	   				}else{
		   				array[j]=""+item.attr("id")+"=";
		   				j++;
	   				}
	   			}
	    		if(item.attr("type")=='text'){
	    			if(item.attr("id")=="department"){
	    				array[j]=""+item.attr("id")+"="+item.val().replaceAll(',','、',false);
	    				j++;
	    			}else if(item.attr("id")!="templeteName"){
		    			array[j]=""+item.attr("id")+"="+item.val();
	    				j++;
		    		}
	    		}
	    	})
	    	$.each(select,function(i,n){
	    		var item=$(n);
	    		array[j]=""+item.attr("id")+"="+item.val();
	    		j++;
	    	})
	    	array[j]="reportId="+$("#reportId").val();
	    	arr[0]=array;
	    	return arr;
    	}
    }
  	
  //栏目,改变样式
    function hiddenTab(){
    	var reportCategory=$("#reportCategory").val();
    	if($("#reportCategory").attr("id")!=undefined){
    		$("#queryCondition table").eq(0).removeClass("common_center");
    		$("#queryCondition table td").eq(0).removeClass("padding_lr_10");
    		$(".th_name").eq(0).removeClass("margin_r_10").css("margin-right","2px");
    	}
		//去除同一行css效果
		var section_div=$("#queryCondition div");
		$("#button_div").hide();
		$.each(section_div,function(i,n){
			$(n).removeClass("one_row").removeClass("common_selectbox_wrap select");
		})
		//给文本框添加宽度
		var section_input=$("#queryCondition input");
		$.each(section_input,function(i,n){
			if($(n).attr("type")=='text'){
				$(n).css("width","100px");
			}
		})
		//给下拉列表添加宽度
		var section_input=$("#queryCondition select");
		$.each(section_input,function(i,n){
				$(n).css("width","100px");
		})
		
		var section_tab=$("#queryCondition td");
    		$.each(section_tab,function(i,n){
    			$(n).attr("width","");
    		})
    	$("#timeAll").removeAttr("width");
    	$("#time").css("width",'113px');
    	$("#manager_range").removeAttr('width');
    	switch(Constants_report_id){
    		case PLANRETURNSTATISTICS:
    			  //处理计划提交回复团队报表 类型选择框不对齐
					$(".th_name").eq(0).css("margin-left","2px");
					$(".th_name").eq(1).attr("style","margin-right:2px");
					//$('#timeDiv').css('padding-left','2px');
					$("#planType").css('width','100%');
	         	break;
			case WORKDAILYSTATISTICS://日常工作统计
				$("#radiosort3").parent().removeClass('margin_r_10');
				$("#queryCondition div").css('margin-left','');
				$("#type_td table").css('width','');
					$(".th_name").eq(0).css("margin-left","3px");
					$(".th_name").eq(1).css("margin-left","");
    	        	$("#Category table").css('margin-left',"1px");
    	        	$("#rowOcc td").attr('width','113px');
    	        	$("#status,#appType").css('width','113px');
    	        	//$("#rowTime th label").css("padding-right","2px");
    	        	$("#Worktab").attr('width','90%');
    	        	$("#appType").css('width','100%');
    	        	$("#type_td").next().attr('width','70%');
    	        	var appType=$("#appType").val();
		  			if((appType==5||appType==7)&&$("#time").val()==4){
    	        		$("#time").css('width','60px');
    	        		$("#rowOcc td").attr('width','100%');
    	        		$("#managerRange").css('width','100%');
    	        		$("#start_time,#end_time").css('width','90px');
    	        	}
    	        $(".th_name").removeClass("margin_r_10");
			break;
			case FLOWOVERTIMESTATISTICS://流程超期
				$("#flowOverTimeStatus").css('width','100%');
				$("#flowType").css('width','115px');
				$(".th_name").eq(0).css("margin-left","2px");
				$(".th_name").eq(1).css("margin-left","2px");
				$(".th_name").removeClass("margin_r_10");
			break;
			case STORAGESPACESTATISTICS://存储空间统计
				$("#Category").hide();
				//$(".th_name").removeClass("margin_r_10");
				//$(".th_name").css("margin-left","5px");
			break;
			case KNOWLEDGEACTIVITYSTATISTICS://知识社区活跃度
				$(".th_name").eq(0).css("margin-left","2px");
				$(".th_name").eq(1).css("margin-right","2px");
				$("#time").css('width','100%');
    	        $(".th_name").removeClass("margin_r_10");
			break;
			case FLOWSENTANDCOMPLETEDSTATISTICS://流程已发已办
				//$("#flowTemplateNum").css('width','100%');
				//$("#flowTemplateNum").parent().parent().attr('width','100%');
				$("#start_time").css('width','90px');
				$("#end_time").css('width','90px');
				$("#flowStatus").css('width','100%');
				$(".th_name").eq(0).css("margin-left","2px");
				$(".th_name").eq(1).css("margin-left","2px");
				$(".th_name").removeClass("margin_r_10");
				$("#flowType").css('width','102px').css('margin-left','2px');
				break;
			default:
				if(Constants_report_id==MEETINGJOINSTATISTICS||Constants_report_id==MEETINGJOINROLESTATISTICS
				||Constants_report_id==EVENTSTATISTICS||Constants_report_id==ONLINETIMESTATISTICS){
					//$("#timeAll").prev().children().eq(0).css("margin-left","10px");
					$(".th_name").eq(0).css("margin-left","2px");
					$(".th_name").eq(1).css("margin-left","2px");
					$('#timeDiv').css('padding-left','2px');
					$(".th_name").removeClass("margin_r_10");
				}
				break;
    	}
    }
</script>
</head>
<body>
<div id="tabs" class="margin_t_5 margin_r_5 ">
<div id="Category">
</div>
<div class="form_area"  id="queryCondition" ></div>  
<input type="hidden" id="reportId" class="hidden" value="${reportId}"/>   
<input type="hidden" id="personGroupTab" />
<input type="hidden" id="tableChartTab" />
<input type="hidden" id="hiddenAllTab"/>
<input type="hidden" id="hiddenChartGridTab"/>
</div>
</body>
</html>