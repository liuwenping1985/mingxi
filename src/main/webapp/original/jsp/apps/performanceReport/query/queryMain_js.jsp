<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryCommon.jsp" %>
<!-- 执行初始化js -->
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" src="${path }/apps_res/hr/js/date.js"></script>
<script type="text/javascript" src="${path }/apps_res/workFlowAnalysis/js/workflowAnalysis.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=performanceQueryManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=workFlowAnalysisManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=reportAuthManager"></script>
<script type="text/javascript">
//执行查询后返回的参数
   var reportParams={};
   //是否为集团管理员
   var isGroupAdmin="${isGroupAdmin}";
   //是否为管理员
   var isAdministrator="${isAdministrator}";
   //报表id
    var Constants_report_id="${reportId}";
    //是否为老报表
    var old_flag=false;
    var flowType="";
    var isPortal='';
    var end_time="";
    var start_time="";
    var templeteId_=""
   //查看团队报表标记
    var Constants_report_flag="${viewFlag}";
    //同时隐藏个人和团队报表页签
    var hiddenAllTab="${hiddenAllTab}";
    var hiddenChartGridTab="${hiddenChartGridTab}"; 
    //form回填标记（执行统计后要保存工作区）
    var reOnloadflag="${ffqueryConditionForm}";
    //个人团队页签
    var personGroupTab =(("${personGroupTab}"=="")?1:parseInt("${personGroupTab}"));
    var tabPerson=1;
    var tabGroup=2;
    var tabPersonGroup=3;
    //列表总条数，分页使用
    var pageTotle="${pageTotle}";
    //栏目更多按钮标志resetResult
    var isMore="${isMore}";
    //以后切换图形时需要动态获取图形数据
    var result = eval(${chartList});
    //报表图对象，打印转发时使用
    var chartObjS=[];
    //综合分析下方渲染图
    var chartObject="";
    var appTypeName="";
    var isReset=false;
    //图表页签
    var tableChartTab=(("${tableChartTab}"=="")?1:parseInt("${tableChartTab}"));
    //后台当前时间 "yyyy-MM-dd HH:mm:ss"
    var presentTime = "${presentTime}";
    $(function () { 
    	var Constants_report_Name;
    	if(Constants_report_flag=="false"){
	    	$("#myReport").addClass("last_tab");
    	}
    	$("#center1").removeClass("margin_l_5");
    	$("#center1").css("border-right-color","white");
    	$("#dataReport").click(function(){
    		window.top.$("#main").attr("src","${path}/datareport/excel.do");
    	})
        $("#myReport").click(function () {
            $(this).parent().addClass('current').siblings().removeClass('current');
            personGroupTab = 1;
            selectWorkSpace();
            $("#queryResult").html("");
            executeStatistics();
            result="";
        });
        $("#groupReport").click(function () {
            $(this).parent().addClass('current').siblings().removeClass('current');
            personGroupTab = 2;
            selectWorkSpace();
            $("#queryResult").html("");
            result="";
            if(Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS){
            	$('#personManagerRange').show();
            }
            $("#queryResult").css("border-top-color","#b6b6b6");
        });
        $("#tableResult").click(function () {
            $(this).parent().addClass('current').siblings().removeClass('current');
            tableChartTab = 1;
            changeChartGrid(1);
            if(Constants_report_id==KNOWLEDGESCORESTATISTICS || Constants_report_id==COMPREHENSIVEANALYSIS || Constants_report_id==EFFICIENCYANALYSIS
            	|| Constants_report_id==IMPROVEMENTANALYSIS || Constants_report_id==NODEANALYSIS || Constants_report_id==OVERTIMEANALYSIS ){
            	if(!$.isNull(result)){
            		$("#queryResult").css('bottom','35px').css('border-bottom-color','');
            		$("#resultComp,#proHr,#pageContent").show();
            	}
            }
            if( Constants_report_id==PROCESSPERFORMANCEANALYSIS ){
            	$("#queryResult").css('bottom','60px').css('border-bottom-color','');
            	$("#resultComp,#proHr,#pageContent").show();
            }
            if(Constants_report_id==MEETINGJOINSTATISTICS){
            	$('#layout').layout().setNorth(140);
            }
            $("#queryResult").css('border-top-color','');
            $("#chooseChart").hide();
           if("9.0"===$.browser.version||"10.0"===$.browser.version){
            		$("#reportResult").find("div[name='tabs']").css('height','100%');
        	}
         	if(Constants_report_id===KNOWLEDGESCORESTATISTICS||Constants_report_id===EFFICIENCYANALYSIS||Constants_report_id===PROCESSPERFORMANCEANALYSIS
        	||Constants_report_id===NODEANALYSIS||Constants_report_id==IMPROVEMENTANALYSIS||Constants_report_id===OVERTIMEANALYSIS||Constants_report_id===COMPREHENSIVEANALYSIS){
        		$("#reportResult").find("div[name='tabs']").css('height','95%');
        	}
        	
        	if(Constants_report_id===WORKDAILYSTATISTICS||Constants_report_id===EVENTSTATISTICS||Constants_report_id===STORAGESPACESTATISTICS
        	||Constants_report_id===ONLINETIMESTATISTICS||Constants_report_id==ONLINESTATISTICS){
        		$("#reportResult").find("div[name='tabs']").css('height','97%');
        	}
        });
        $("#chartResult").click(function () {
            $(this).parent().addClass('current').siblings().removeClass('current');
            changeChartGrid(2);
            tableChartTab = 2;
            if(Constants_report_id==PROCESSPERFORMANCEANALYSIS){
            	$("#queryResult").css("bottom","35px");
				$("#resultComp").hide();
            }
            $("#pageContent").hide();
            $("#queryResult").css("border-top-color","#b6b6b6");
            $("#chooseChart").show();
            if(Constants_report_id==MEETINGJOINSTATISTICS){
            	$('#layout').layout().setNorth(0);
            }
            $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
            $("#resultComp,#proHr,#pageContent").hide();
           	if("9.0"===$.browser.version||"10.0"===$.browser.version){
            		$("#reportResult").find("div[name='tabs']").css('height','90%');
        	}
        });       
        if(!$.ctx.resources.contains('F01_newColl')){
        	$("#reportForwardCol").hide();
        }
        reportInit();
        $("#center1").css('border-top-color','white').css('border-left-color','white');
        if("9.0"===$.browser.version||"10.0"===$.browser.version){
            	$("#reportResult").find("div[name='tabs']").css('height','100%');
        }
        if(Constants_report_id===KNOWLEDGESCORESTATISTICS||Constants_report_id===EFFICIENCYANALYSIS||Constants_report_id===PROCESSPERFORMANCEANALYSIS
        	||Constants_report_id===NODEANALYSIS||Constants_report_id==IMPROVEMENTANALYSIS||Constants_report_id===OVERTIMEANALYSIS||Constants_report_id===COMPREHENSIVEANALYSIS){
        		$("#reportResult").find("div[name='tabs']").css('height','95%');
        }
        
        if(Constants_report_id===WORKDAILYSTATISTICS||Constants_report_id===EVENTSTATISTICS||Constants_report_id===STORAGESPACESTATISTICS
        	||Constants_report_id===ONLINETIMESTATISTICS||Constants_report_id==ONLINESTATISTICS){
        		$("#reportResult").find("div[name='tabs']").css('height','97%');
        }
        //计算出center1的高度
        $("#center1").css("height",$("#layout").height()-$("#layoutNorth").height()-$("#northSp_layout").height());
    });
    
    var layout;
    $(document).ready(function () {
		layout = $('#layout').layout();
		
		$(".spiretBarHidden4").live("click",function(){
			layout.setNorth(0);
		})
		$(".spiretBarHidden3").live("click",function(){
			if(Constants_report_id==COMPREHENSIVEANALYSIS||Constants_report_id==OVERTIMEANALYSIS
			||Constants_report_id==IMPROVEMENTANALYSIS||Constants_report_id==PROCESSPERFORMANCEANALYSIS
			||Constants_report_id==PROJECTSCHEDULESTATISTICS||Constants_report_id==MEETINGJOINSTATISTICS
			||Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS
			||Constants_report_id==FLOWSENTANDCOMPLETEDSTATISTICS||Constants_report_id==FLOWOVERTIMESTATISTICS){
				layout.setNorth(110);
			}else if(Constants_report_id==EFFICIENCYANALYSIS||Constants_report_id==NODEANALYSIS
			||Constants_report_id==TASKBURNDOWNSTATISTICS||Constants_report_id==KNOWLEDGESCORESTATISTICS
			||Constants_report_id==KNOWLEDGEINCREASESTATISTICS||Constants_report_id==EVENTSTATISTICS
			||Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==STORAGESPACESTATISTICS){
			    if(Constants_report_id==KNOWLEDGEINCREASESTATISTICS){
			    	var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
					if (isChrome) {
        				layout.setNorth(110);
    				} else {
        				layout.setNorth(90);
    				}
			    }else{
					layout.setNorth(80);
				}
			}
		})
		$("#groupReport").css("border-left","1px solid #b6b6b6");
    });
  //初始化
  function reportInit(){
	  	  //默认不显示分页控件        
	        $(".common_over_page").hide();
	      //初始化条件区域
		    selectWorkSpace();
	        //是否隐藏个人及团队页签
	        if(hiddenAllTab=="true"){
	            hideTab(tabPersonGroup);   
	        }
	        //根据权限确定是否能查看团队页签
	        viewGroupCheck();
	        $("#managerRange").live("click",function(){
	        	selectPerson();
	        });
	        //$("#querySave").bind("click",function(){
	        	//executeStatistics();
	        //})
	        $("#printReport").click(printReport);
	        $("#reportToExcel").click(reportToExcel);        
	        $("#reportForwardCol").click(reportForwardCol);
	       // $("#queryReset").click(selectWorkSpace);
		   //条件区域数据回填-事件
			 fillformChange();
			 if(hiddenChartGridTab=='true'){
				 $("body").removeClass("page_color");
			 }
			 checkResource();
			 breadcrumb();
			 if(isAdministrator=='true'||isGroupAdmin=='true'){
			 	//OA-51991.后台管理员的流程统计不应该有说明.
			 	$("#showHelp").hide();
			 }
  }
  //从工作统计等其他地方过来的链接，需要显示面包屑
  function breadcrumb(){
	  if(${ctp:getSystemProperty('system.ProductId')} == 0 || ${ctp:getSystemProperty('system.ProductId')} == 12){
		//  resetCtpLocation() ;
		if(getCtpTop().hideLocation){
		  getCtpTop().hideLocation();
		  getCtpTop().$('#content_layout_body_left_content').addClass("border_all");
		}
	  }
	  if(parent.location.href.indexOf("queryIndex")==-1&&hiddenChartGridTab!='true'){
	  	  if(isGroupAdmin=='true'||isAdministrator=='true'&&Constants_report_id==PROCESSPERFORMANCEANALYSIS){
		  		$("#tabs_head").hide();
		  		$("#queryMainCrumbs").hide();
		  		//$("#queryGroupCrumbs").hide();
		  		//$("#queryUnitCrumbs").hide();
		  	}
		  	//else{
		  		//$("#queryMainCrumbs").show();
		  		//$("#layout").height($(document.body).height()-20);
          		//var h = $("#center1").height();
          		//$("#center1").height(h-20);//面包屑占了20px的高度,需要减去
		  		//if(productId=="0"){
			  		//$("#colMonitor").hide();
			  		//$("#curmbsSplit").hide();
			  	//$("#performanceCrumb").html("${ctp:i18n('performanceReport.queryMain.reportName')}");
		  		//}
		  	//}
	  }else {
		  $("#queryMainCrumbs").hide();
	  }
	  if(${ctp:getSystemProperty('system.ProductId')} ==0 || ${ctp:getSystemProperty('system.ProductId')}== 7 || ${ctp:getSystemProperty('system.ProductId')}== 12){
	  	 $("#queryMainCrumbs").hide();
	  }
  }
  //判断菜单资源
  function checkResource(){
	  if(!$.ctx.resources.contains('F01_newColl')){
		  $("#reportForwardCol").hide();
	  }
  }
  //日常工作统计类型切换事件
  function changeType(){
    	var type=$("#appType").val();
    	$("#rowOcc").next().html("");
    	var hh='';
    	if(type=='6'){
    		//全部待办
    		hh=getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='75%'><div class='common_selectbox_wrap' id='timeDiv'><select id='time'><option value='3' selected>${ctp:i18n('performanceReport.queryMain.all.Cumulative')}</option></select></div></td>";
    		$("#coltype").html(hh);
    		//hh="<th><label class='margin_r_10 th_name' for='text'></th><td></td>"
    		//$("#rowOcc").html(hh);
    		$("#managerRange").addClass('validate');
    		$("#type_td table").css('width','250px');
    		$("#rowOcc td").attr('width','78%');
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
		    	$("#type_td table").css('width','250px');
		    	$("#manager_range").removeAttr('width');
		    	$("#type_td").css("width","");
		    	$("#rowOcc td").attr('width','78%');
    	}else if(type=='2'){
    		//计划
    			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+
	    		"<td width='70%'><div class='common_selectbox_wrap'><select id='status'>"+
	    		"<option value='0' width='100%' selected>${ctp:i18n('performanceReport.queryMainHtml.typePublished')}</option>"+
	    		"<option value='1' >${ctp:i18n('performanceReport.queryMainHtml.typeReceived')}</option>"+
	    		"<option value='2' >${ctp:i18n('performanceReport.queryMainHtml.typeReplied')}</option>"+
	    		"<option value='3' >${ctp:i18n('performanceReport.queryMainHtml.typeUnreply')}</option>"+
	    		"</select></div></td>";
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	$("#type_td table").css('width','250px');
		    	$("#rowOcc td").attr('width','78%');
    	}else if(type=='3'){
    		//会议
    			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+
	    		"<td width='70%'><div class='common_selectbox_wrap'><select id='status'><option value='0' width='100%' selected>${ctp:i18n('performanceReport.queryMainHtml.typeSent')}</option>"+
	    		"<option value='1' >${ctp:i18n('performanceReport.queryMain.start.label')}</option>"+
	    		"<option value='2' >${ctp:i18n('performanceReport.queryMain.ready.start')}</option>"+
	    		"<option value='3' >${ctp:i18n('performanceReport.queryMainHtml.typeArchived')}</option>"+
	    		"</select></div></td>";
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	$("#type_td table").css('width','250px');
		    	$("#rowOcc td").attr('width','78%');
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
	    		"</select></div></td>"
	    		$("#timeAll").remove();
	    		$("#coltype").html(hh);
	    		$("#rowOcc").after("<tr>"+getTime_()+"</tr>");
		    	$("#status").change(statusChange);
		    	$("#type_td table").css('width','250px');
		    	$("#rowOcc td").attr('width','78%');
    	}else{
    		hh=getTime_();
    		$("#coltype").html(hh);
    		//hh="<th><label class='margin_r_10 th_name' for='text'></th><td></td>"
    		//$("#rowOcc").html(hh);
    		$("#managerRange").addClass('validate');
    		$("#type_td table").css('width','250px');
    		$("#rowOcc td").attr('width','78%');
    	}
    	if(personGroupTab==2&&$("#querySave").attr('disabled')=='disabled'){
    		$("#type_td table tr").eq(0).html(getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true));
    		$("#querySave").attr('disabled',false).removeClass('common_button_disable');
    	}
    }
    
    //日常工作统计状态更改事件
    function statusChange(){
    	var status=$("#status").val();
    	var appType=$("#appType").val();
    	var hh=getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='75%'><div class='common_selectbox_wrap' id='timeDiv'><select id='time'><option value='3' selected>${ctp:i18n('performanceReport.queryMain.all.Cumulative')}</option></select></div></td>";
    	if(((status=='2'||status=='3')&&(appType=='0'||appType=='1'))//协同,公文   	
    	||(status=='3'&&appType=='2')//计划
    	||(status=='2'&&appType=='3')//	会议
    	||(appType=='4'&&status=='6')){//任务
    		$("#rowOcc").next().html(hh);
    	}else{
    		$("#rowOcc").next().html(getTime_());
    	}
    }
    
    function fillformChange(){
	   //日出厂工作统计状态栏要单独处理
	   var workStatus="";
	   //日常工作统计状态和时间
	   var status="";
	   var time='';
	   var start_time='';
	   var end_time='';
	   //条件区域数据回填
	   var ffqueryConditionFormOld="${ffqueryConditionForm}";
	   ffqueryConditionFormOld=ffqueryConditionFormOld.substring(0,ffqueryConditionFormOld.length);
	   if(ffqueryConditionFormOld.length>0){
	   var st=ffqueryConditionFormOld.split(",");
	   	var pt=new Object();
	   	for(var i=0;i<st.length;i++){
			var mt=st[i].split("=");
			//key中有空格
			mt[0]=mt[0].trim();
			if(mt.length>=2){
				pt[mt[0]]=mt[1];
			}else{
				pt[mt[0]]="";
			}
			if(st[i].indexOf('Member')!=-1&&st[i].indexOf('personIds')==-1&&'personIds' in pt){
				//仅流程统计选择多人
				pt["personIds"]=pt["personIds"]+","+mt[0];
			}else if(st[i].indexOf('departmentIds')==-1&&'departmentIds' in pt){
				//选择多部门,id
				pt["departmentIds"]=pt["departmentIds"].replaceAll('、',',',false);
			}else if(st[i].indexOf('department')==-1&&'department' in pt){
				//选择多部门,名称
				pt["department"]=pt["department"].replaceAll('、',',',false);
			}else if(st[i].indexOf('managerRangeIds')==-1&&'managerRangeIds' in pt){
				//团队报表选择多人,多部门
				pt["managerRangeIds"]=pt["managerRangeIds"].replaceAll('、',',',false);
			}
	   	}
	   if(isMore=='true'){
	   	if(pt["templeteId"]!=undefined&&pt["templeteId"]!=''&&pt["templeteName"]==undefined){
	   	  	var performanceQueryManager_=new performanceQueryManager;
	   	  	var templeteIds=pt["templeteId"];
	   	  	var retObj = performanceQueryManager_.getTemplateNameByIds(templeteIds);
	   	  	pt["templeteName"]=retObj.templateName;
	   	  	fillCondition(pt);
	   	  	if(Constants_report_id==EFFICIENCYANALYSIS||Constants_report_id==NODEANALYSIS
	      		||Constants_report_id==OVERTIMEANALYSIS||Constants_report_id==IMPROVEMENTANALYSIS){
	      		//超时分析,效率分析,节点分析,改进分析\
	    		executeStatistics();
	      	}
	   	  }else{
	   	  	fillCondition(pt);
	   	  }
	   		//解决流程超期和流程已发已办等同一报表不同id的情况
	   		$("#reportId").val(pt["reportId"]);
	   }
	   }
		/*if($("#reportId").val()==FLOWOVERTIMESTATISTICS
				&&$("#flowOverTimeStatus").val()==1){
			overTimeStatusChange();
		}*/
	   if(reOnloadflag!=""||hiddenChartGridTab=="true"||isMore=="true"){
	   //页签回填
	    if(personGroupTab==2){
	    	 $("#groupReport").parent().addClass('current').siblings().removeClass('current');
	    }else{
	    	 $("#myReport").parent().addClass('current').siblings().removeClass('current');
	    }
	    if(tableChartTab==2){
	    	$("#chartResult").parent().addClass('current').siblings().removeClass('current');
	    }else{
	    	$("#tableResult").parent().addClass('current').siblings().removeClass('current');
	    }
	   } else{
		   //增加默认查询功能
		   if(Constants_report_id!=undefined){
			   //任务燃尽图条件区必须输入，去掉默认统计功能
			   if(Constants_report_id != TASKBURNDOWNSTATISTICS&&Constants_report_id!==KNOWLEDGESCORESTATISTICS&&Constants_report_id!=STORAGESPACESTATISTICS&& hiddenChartGridTab != 'true' && isMore != 'true'){
    				//效率分析、超时分析、改进分析、节点分析需要选择的模板,去掉默认统计功能
    				if(Constants_report_id != EFFICIENCYANALYSIS && Constants_report_id != OVERTIMEANALYSIS 
    					&& Constants_report_id != IMPROVEMENTANALYSIS && Constants_report_id != NODEANALYSIS){
			   	 		executeStatistics();
    				}else{
    					//影藏分页组件
    					$("#pageContent").hide();
    				}
			   }
		   }		  
	   }
	   //来至portal则执行ajax请求
	   if(isMore=='true'){
		   if(Constants_report_id==TASKBURNDOWNSTATISTICS){
	    		var task_id=$("#task_id").val();
	    		if(!$.isNull(task_id)) {
	    			executeStatistics();;
	    		}
	    		inputNoDataInfo();
	    	}else if(Constants_report_id==EFFICIENCYANALYSIS||Constants_report_id==NODEANALYSIS
	      	||Constants_report_id==OVERTIMEANALYSIS||Constants_report_id==IMPROVEMENTANALYSIS){
	      	//超时分析,效率分析,节点分析,改进分析\
	      		var templeteName=$("#templeteName").val();
	      		if(!$.isNull(templeteName)) {
	    			executeStatistics();;
	    		}
	    		inputNoDataInfo();
	      	}else if(Constants_report_id===KNOWLEDGESCORESTATISTICS||Constants_report_id==STORAGESPACESTATISTICS){
	      		var managerRangeIds=$("#managerRangeIds").val();
	      		if(!$.isNull(managerRangeIds)) {
	    			executeStatistics();;
	    		}
	      	}
	    	else{
	    		$("#personManagerRange").removeClass("hidden");
	    		executeStatistics();
	    	}	   		
	   }
   } 
 //根据权限确定是否能查看团队页签
   function viewGroupCheck(){
	   if(Constants_report_flag=="false"){
		   hideTab(tabGroup);
	   }
   }
    //构造团队条件区
    function changeChartGrid(index) {
    	 tableChartTab=index;
         var qr=$("#queryResult").html();  
         if(tableChartTab==1){
         	if(!$.isNull(qr)&&qr.indexOf("only_table")!=-1){
         		$("#queryResult .only_table").show();
         	}else{
         		drawGrid();
         		$("#queryResult").css("border-top-color","white");
         	}
         	$("#queryResult .one_row").hide();        	
         }else{
         	if(!$.isNull(qr)&&qr.indexOf("queryResult0")!=-1){
         		$("#queryResult .one_row").show();
         	}else{
         		if(Constants_report_id==COMPREHENSIVEANALYSIS){
         			drawComprehensive();
         		}else{
         			drawingDefualt(personGroupTab);
         		}
         	}
         	$("#queryResult .only_table").hide();
         }
    }
    function displayReportName(name){
    	 $("#reportName").html(name);
    }
    
    //work选择区
	function selectWorkSpace(){
	switch(Constants_report_id){
		case WORKDAILYSTATISTICS://日常工作统计条件区
		  //workTotal();	
		  workTotal_();
		  //workTotalChange();
		  $("#appType").change(changeType);
		  //if(personGroupTab==2){
		  	//$("#coltype td").eq(0).attr("width","70%");
		  //}
		  $("#rowOcc td").attr("width","78%");
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.workTotal')}");
		break;
		case PLANRETURNSTATISTICS://计划提交回复统计
		  planReturn();
		  planReturnChange();
		  $("#queryCondition table").eq(0).attr('width','68%');
		  $("#queryCondition table td").eq(0).attr('width','40%');
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.planReturn')}");
		break;
		case PLANRETURNSTATISTICSGROUP://计划提交回复统计(团队)
		  planReturn();
		  planReturnChange();
		  $("#queryCondition table").eq(0).attr('width','60%');
		  $("#queryCondition table td").eq(0).attr('width','40%');
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.planReturn')}");
		break;
		case MEETINGJOINSTATISTICS://会议参加情况统计
		  meetingJoin();
		  $("#time").change(timeChange);
		  $("#time").val("2");
		  $("#manager_range,#timeAll").attr('width','82%');
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.meetingJoin')}");
		break;
		case MEETINGJOINROLESTATISTICS://会议参加角色情况统计
		  meetingJoinRole();
		  $("#time").change(timeChange);
		  $("#time").val("2");
		  $("#manager_range,#timeAll").attr('width','82%');
		 $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.meetingJoinRole')}");
		break;
		case TASKBURNDOWNSTATISTICS://任务燃尽图
		  taskBurndown();
		  hideTab(tabGroup);
		  $("#queryCondition table").eq(0).attr('width','70%');
		  $("#queryCondition table td").eq(0).attr('width','80%');
		  $("#queryCondition table th").eq(0).before('<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>');
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.taskBurndown')}");
		  $("#taskInfo").click(taskInfoChange);
		break;
		case KNOWLEDGEINCREASESTATISTICS://知识增长趋势
		  knowledgeIncrease();
		  $(".mycal").each(function(){$(this).compThis();});
	       // var date=new Date();
	        var date = new Date(presentTime.replace(/-/,"/"));
	    	var fromDate=date.print("%Y-%m");
	    	toDate=date.print("%Y-%m");
	    	$("#start_time").val(timeMonthCal(12));
	    	$("#end_time").val(fromDate);
		  $("#queryResult").css('border-bottom-color','white');
		  hideTab(tabGroup);
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.knowledgeIncrease')}");
		  //v5 v6.0  知识增长趋势面包屑
		  var bh = '<span class="nowLocation_ico"><img src="/seeyon/main/skin/frame/harmony/menuIcon/personal.png"></span><span class="nowLocation_content" style="color: rgb(255, 255, 255);"><a style="color: rgb(255, 255, 255);">'
		  +  $.i18n("performanceReport.doc.knowledge") 
		  + '</a> &gt; <a  style="color: rgb(255, 255, 255);">'
		  + $.i18n("performanceReport.doc.trend") + '</a></span>';
		  getA8Top().showLocation(bh);
		break;
		case KNOWLEDGESCORESTATISTICS://知识积分排行榜
		  knowledgeScore();
		  $("#time").change(timeChange);
		  pageInit();
		  hideTab(tabGroup);	
		  if(tableChartTab==1){
		  	$(".common_over_page").show();
		  }
		   $("#manager_range,#timeAll").attr('width','82%');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.knowledgeScore')}");	
		//v5 v6.0  知识积分排行榜面包屑
		  var bh = '<span class="nowLocation_ico"><img src="/seeyon/main/skin/frame/harmony/menuIcon/personal.png"></span><span class="nowLocation_content" style="color: rgb(255, 255, 255);"><a style="color: rgb(255, 255, 255);">'
		  +  $.i18n("performanceReport.doc.knowledge") 
		  + '</a> &gt; <a  style="color: rgb(255, 255, 255);">'
		  + $.i18n("performanceReport.doc.top") + '</a></span>';
		  getA8Top().showLocation(bh);
		break;
		case KNOWLEDGEACTIVITYSTATISTICS://知识社区活跃度
		  knowledgeActivity();
		 // hideTab(tabPerson);
		 $("#time").val('2');
		 $("#manager_range,#timeAll").attr('width','82%');
		 $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
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
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
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
		  $("#manager_range,#timeAll").attr('width','82%');
		  $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
		  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.onlineTime')}"); 
		break;
		case EVENTSTATISTICS://事项统计
			eventStatistics();
			  $("#time").change(timeChange);	 
			$("#manager_range,#timeAll").attr('width','82%');
		    $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
			  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventStatistics')}"); 
		break;	
		case EVENTSTATISTICSGROUP://事项统计团队
			eventStatistics();
			  $("#time").change(timeChange);	 
			$("#manager_range,#timeAll").attr('width','82%');
		    $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
			  displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventStatistics')}"); 
		break;
		case PROJECTSCHEDULESTATISTICS://项目进度统计
			projectScheduleStatistics();
			 // $("#time").change(timeChange);	 
			 hideTab(tabGroup);
			 $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
			 if($.browser.chrome || $.browser.safari){// OA-78541 safari 下滚动条问题
			 	$("#queryResult").removeClass("stadic_layout_body");
			 	$("#queryResult").height($("#layout").height()-$("#layoutNorth").height()-$("#oper").height()-30);
			 }
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.projectScheduleStatistics')}"); 
			 $("#queryResult").removeClass("stadic_layout_body");
		break;
		case STORAGESPACESTATISTICS://存储空间统计
			storageSpaceStatistics();
			 // $("#time").change(timeChange);	 
			 $("#queryCondition table").eq(0).attr('width','70%');
			 hideTab(tabPerson);
			 $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.storageSpaceStatistics')}");  
		break;
		case FLOWSENTANDCOMPLETEDSTATISTICS://流程已办已发统计
			eventSentAndCompletedStatistics();
			SentAndCompletedChange();
			 // $("#time").change(timeChange);	 
			 //hideTab(tabGroup);
			 $("#queryCondition table").eq(0).attr('width','70%');
			 //$("#queryCondition table").eq(0).attr('width','80%');
			 $("#queryCondition table td").eq(0).attr('width','45%');
			 $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventSentAndCompletedStatistics')}");  
		break;		
		case FLOWSENTANDCOMPLETEDSTATISTICSFORM://流程已办已发统计(表单)
			eventSentAndCompletedStatistics();
			SentAndCompletedChange();
			 // $("#time").change(timeChange);	 
			 //hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventSentAndCompletedStatistics')}");  			
		break;		
		case FLOWSENTANDCOMPLETEDSTATISTICSEDOC://流程已办已发统计(公文)
			eventSentAndCompletedStatistics();
			SentAndCompletedChange();
			 // $("#time").change(timeChange);	 
			 //hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.eventSentAndCompletedStatistics')}");  			
		break;
		case FLOWOVERTIMESTATISTICS://流程超期统计
			flowOverTimeStatistics();
			flowOverTimeChange();
			 // $("#time").change(timeChange);	 
			 //hideTab(tabGroup);
			 $("#queryCondition table").eq(0).attr('width','65%');
			 $("#queryCondition table td").eq(0).attr('width','45%');
			 $("#queryResult").css('bottom','0px').css('border-bottom-color','white');
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.flowOverTimeStatistics')}");  
		break;		
		case FLOWOVERTIMESTATISTICSFORM://流程超期统计-表单
			flowOverTimeStatistics();
			flowOverTimeChange();
			 // $("#time").change(timeChange);	 
			 //hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.flowOverTimeStatistics')}");  
		break;			
		case FLOWOVERTIMESTATISTICSEDOC://流程超期统计-公文
			flowOverTimeStatistics();
			flowOverTimeChange();
			 // $("#time").change(timeChange);	 
			// hideTab(tabGroup);
			 displayReportName("${ctp:i18n('performanceReport.queryMain.reports.flowOverTimeStatistics')}");  
		break;
		case EFFICIENCYANALYSIS://效率分析
			effeiciencyAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time").val(getNowDay());
			Constants_report_flag='false';
			$("#myReport").addClass("last_tab");
			old_flag=true;
			pageInit();
			if(tableChartTab==1){
		  		$(".common_over_page").show();
		  	}
		  	$("#type_td").attr('width','45%');
		  	$("#queryResult").css('border-bottom-color','white');
			displayReportName("${ctp:i18n('performanceReport.queryMain.reports.effeiciencyAnalysis')}"); 
		break;
		case NODEANALYSIS://节点分析
			//显示[查看流程]图标
			$("#showDigarm").show();
			nodeAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time").val(getNowDay());
			Constants_report_flag='false';
			$("#myReport").addClass("last_tab");
			old_flag=true;
			pageInit();
			if(tableChartTab==1){
		  		$(".common_over_page").show();
		  	}
		  	$("#type_td").attr('width','45%');
		  	$("#queryResult").css('border-bottom-color','white');
			displayReportName("${ctp:i18n('performanceReport.queryMain.reports.nodeAnalysis')}"); 
		break;
		case OVERTIMEANALYSIS://超时分析
			overTimeAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time").val(getNowDay());
			Constants_report_flag='false';
			$("#myReport").addClass("last_tab");
			//OA-49493.超时分析统计结束时间文本框比开始时间小，显示不完整.
			$("#type_td").attr('width','55%');
			old_flag=true;
			pageInit();
			if(tableChartTab==1){
		  		$(".common_over_page").show();
		  	}
		  	$("#start_time_td,#end_time_td").attr('width','130px');
		  	$("#queryResult").css('border-bottom-color','white');
			$("#queryCondition div").eq(0).removeClass("form_area set_search one_row");
			displayReportName("${ctp:i18n('performanceReport.queryMain.reports.timeoutAnalysis')}"); 
		break;
		case IMPROVEMENTANALYSIS://改进分析
			improvementAnalysis();
			var date = new Date(presentTime.replace(/-/,"/"));
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time1").val(getFirstDayOfMonth('${productUpgrageDate}',true));
			$("#end_time1").val(date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',true)));
			$("#start_time2").val(getFirstDayOfMonth('${productUpgrageDate}',false));
			$("#end_time2").val(date.getMonthEnd(getFirstDayOfMonth('${productUpgrageDate}',false)));
			Constants_report_flag='false';
			$("#myReport").addClass("last_tab");
			old_flag=true;
			pageInit();
			if(tableChartTab==1){
		  		$(".common_over_page").show();
		  	}
		  	$("#type_td").attr('width','45%');
		  	$("#queryResult").css('border-bottom-color','white');
			displayReportName("${ctp:i18n('performanceReport.queryMain.reports.improvementAnalysis')}"); 
		break;
		case COMPREHENSIVEANALYSIS://综合分析
			comprehensiveAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val(getLastYearMonth('${productUpgrageDate }'));
			$("#end_time").val(getLastYearMonth('${productUpgrageDate }'));
			Constants_report_flag='false';
			$("#myReport").addClass("last_tab");
			$("#flowType").parent().parent().attr("width","");
			old_flag=true;
			$("#result").html('');
			$("#result").html("${ctp:i18n('performanceReport.queryMain_js.totalOfCalls')}0${ctp:i18n('performanceReport.queryMain_js.times')}</td>");
			$("#resultComp").show();
			pageInit();
			if(tableChartTab==1){
		  		$(".common_over_page").show();
		  	}
		  	$("#flowType").change(clearTempChoose);
			displayReportName("${ctp:i18n('performanceReport.queryMain.reports.comprehensiveAnalysis')}");
		break;
		case PROCESSPERFORMANCEANALYSIS://流程统计
			processAnalysis();
			$(".mycal").each(function(){$(this).compThis();});
			$("#start_time").val('${defaultBeginDate }');
			$("#end_time").val('${defaultEndDate }');
			Constants_report_flag='false';
			$("#myReport").addClass("last_tab");
			//$("#flowType").parent().parent().attr("width","");
			old_flag=true;
			pageInit();
			if(tableChartTab==1){
		  		$(".common_over_page").show();
		  	}
		  	$("#queryResult").css('bottom','60px');
		  	$("#resultComp").css('bottom','35px');
		  	$("#proHr").show();
		  	$("#condition").css('width','100%');
		  	$("#start_time_td,#end_time_td").attr('width','130px');
			displayReportName("${ctp:i18n('performanceReport.queryMain.reports.processPerformanceAnalysis')}"); 
		break;
	  }
	   if(Constants_report_id!=FLOWSENTANDCOMPLETEDSTATISTICS&&Constants_report_id!=FLOWOVERTIMESTATISTICS&&Constants_report_id!=PLANRETURNSTATISTICS
    	&&Constants_report_id!=WORKDAILYSTATISTICS&&Constants_report_id!=EVENTSTATISTICS&&Constants_report_id!=ONLINETIMESTATISTICS&&Constants_report_id!=MEETINGJOINSTATISTICS
    	&&Constants_report_id!=PLANRETURNSTATISTICSGROUP&&Constants_report_id!=EVENTSTATISTICSGROUP&&Constants_report_id!=MEETINGJOINROLESTATISTICS&&Constants_report_id!=KNOWLEDGEACTIVITYSTATISTICS){
    		$("#tabs").find("div[name='personGroup']").remove();
    		if(isReset==false){
    			$("#center1").css({"top":"115px","height":"88%"});
    		}
    		if(Constants_report_id==COMPREHENSIVEANALYSIS||Constants_report_id==OVERTIMEANALYSIS
    		||Constants_report_id==IMPROVEMENTANALYSIS||Constants_report_id==PROCESSPERFORMANCEANALYSIS
    		||Constants_report_id==PROJECTSCHEDULESTATISTICS){
    			var layout=$("#layout").layout();
    			layout.setNorth(110);
    			$("#northSp_layout").css("top","110px");
    		}else if(Constants_report_id==EFFICIENCYANALYSIS||Constants_report_id==NODEANALYSIS
    		||Constants_report_id==TASKBURNDOWNSTATISTICS||Constants_report_id==KNOWLEDGESCORESTATISTICS
    		||Constants_report_id==KNOWLEDGEINCREASESTATISTICS||Constants_report_id==STORAGESPACESTATISTICS
    		||Constants_report_id==ONLINESTATISTICS){
    			if(Constants_report_id==KNOWLEDGEINCREASESTATISTICS){
    				var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
        			var layout=$("#layout").layout();
					if (isChrome) {
        				layout.setNorth(110);
    					$("#northSp_layout").css("top","110px");
    				} else {
    					layout.setNorth(90);
    					$("#northSp_layout").css("top","90px");
    				}
    			}else{
    				var layout=$("#layout").layout();
    				layout.setNorth(80);
    				$("#northSp_layout").css("top","80px");
    			}
    		}
    	}else{
    		if(Constants_report_id==MEETINGJOINSTATISTICS||Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==FLOWOVERTIMESTATISTICS||Constants_report_id==FLOWSENTANDCOMPLETEDSTATISTICS
    		||Constants_report_id==EVENTSTATISTICS||Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS){
    			if(Constants_report_id==EVENTSTATISTICS||Constants_report_id==ONLINETIMESTATISTICS){
    				$("#tabs").find("div[name='personGroup']").remove();
    				if(isReset==false){
    					  $("#center1").css({"top":"115px","height":"80%"});
    				}
    				var layout=$("#layout").layout();
    				layout.setNorth(80);
    				$("#northSp_layout").css("top","80px");
    			}else{
    				if(Constants_report_id==FLOWOVERTIMESTATISTICS||Constants_report_id==FLOWSENTANDCOMPLETEDSTATISTICS){
    					$("#tabs").find("div[name='personGroup']").remove();
    					if(isReset==false){
    						$("#center1").css({"top":"115px","height":"80%"});
    					}
    				}
    				var layout=$("#layout").layout();
    				layout.setNorth(110);
    				$("#northSp_layout").css("top","110px");
    			}
    		}
    		//debugger
    		if(Constants_report_flag==false||Constants_report_flag=='false'){
		  		$("#managerRange").val("${ctp:currentUser().name}");
		  		$("#managerRange").attr("disabled",'true');
		  		$("#managerRange").parent().css('background-color', '#f8f8f8');
		  	}else{
		  		if(personGroupTab=='1'){
		  			$("#managerRange").val("${ctp:currentUser().name}");
		  			$("#managerRangeIds").val('Member|${ctp:currentUser().id}');
		  		}
	  		}
    	}
	}
	
	function resolveExecel(obj){
		var hh='';
		for(var o in obj){
			hh+="<input type='hidden' name='"+o+"' value='"+obj[o]+"'/>";
		}
		$("#execelCondition").html(hh);
	}
	var number=0;
    //执行统计
    function executeStatistics(){
    	//var tabInfo="&personGroupTab="+personGroupTab+"&tableChartTab="+tableChartTab+"&hiddenAllTab="+hiddenAllTab+"&hiddenChartGridTab="+hiddenChartGridTab;
    	//$("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=showReportGridAndChat"+tabInfo);
    	$("#personGroupTab").val(personGroupTab);
    	$("#tableChartTab").val(tableChartTab);
    	$("#hiddenAllTab").val(hiddenAllTab);
    	$("#hiddenChartGridTab").val(hiddenChartGridTab);
    	//OA-118995 协同驾驶舱-系统数据-在线时间分析，时间选择任意，不填写时间点击统计，时间控件样式问题，感叹号不要换行
    	var time = $("#time").val();
    	if(time && time == 4){
    		$("#start_time_td,#end_time_td").width("140px");
    		$("#start_time_td,#end_time_td").find("div").width("100px");
    	}
    	var staTime = $("#start_time").val();
    	var enTime = $("#end_time").val();
    	if(checkInputValue()&&checkStartEndDate(staTime,enTime)&&checkStatus()&&checkDate(staTime,enTime)){
    		//$("#queryConditionForm").jsonSubmit({});
    		if(Constants_report_id==PROCESSPERFORMANCEANALYSIS){
    			//流程统计,给statType,statWhat赋值
    			processStatType();
    		}
    		$("#reportContent").remove();
    		var obj = $("#queryConditionForm").formobj();
    		//OA-70859 转发协同后,偶发obj变成了数组 
    		if(typeof(obj[0]) != "undefined"){
    			obj=obj[0];
    		}
    		resolveExecel(obj);
    		oldtempleteName=$("#templeteName").val();
    		var reportId=$("#reportId").val();
    		if(reportId==PROCESSPERFORMANCEANALYSIS){
    			//流程统计
    			var radioId=$("#statisticsRange").find(":radio[checked]").attr("id");
    			var personIds=$("#personIds").val();
    			var departmentIds=$("#departmentIds").val();
    			if(radioId=="toDep"&&departmentIds!="-1"){
    				//统计范围是部门,需要判断子部门是否超过1000,如果超过1000,给出提示,然后分批统计
    				var workFlowAnalysisManager_=new workFlowAnalysisManager();
    				var departmentList=workFlowAnalysisManager_.getChildDeparentmentIds(departmentIds);
    				if(departmentList.length>=950){
    					confirmReport(departmentList,obj);
    				}else{
    					queryReport(obj);
    				}
    			}else if(radioId=="toPer"&&!$.isNull(personIds)){
    				var personIdList=personIds.split(",");
    				if(personIdList.length>=950){
    					confirmReport(personIdList,obj);
    				}else{
    					queryReport(obj);
    				}
    			}else{
    				queryReport(obj);
    			}
    		}else{
    			queryReport(obj);
    		}
    		
    }
    
    
    function confirmReport(idList,obj){
    	if(idList.length>=950){
    			$.confirm({
        			'msg': '统计数据量过大，需要耐心等待',
        			ok_fn: function () { 
        				queryReport(obj);
        			},
        			cancel_fn:function(){}
    			});
    		}
    }
    function queryReport(obj){
    	 $('#querySave').attr('disabled',true);
    	 $('#querySave').addClass('common_button_disable');
    	 var performanceQueryManager_ = new performanceQueryManager;
    		 performanceQueryManager_.getReportByAjax(obj,{success:
    		   function(retObj){
    			  reportParams=retObj;
    			  number++;
    			   if(!$.isNull(retObj.isNull)){
				       if(retObj.isNull==true){
					   $.alert("${ctp:i18n('统计人员为空,不能进行统计!')}");//统计人员为空,不能进行统计
				       $('#querySave').attr('disabled',false);
					   $('#querySave').removeClass('common_button_disable');
					   $("#queryResult").html("").css("border-top-color","#b6b6b6");
					   return;
					  }
				   }
				   if(!$.isNull(retObj.OutOfRange)){
				       if(retObj.OutOfRange==true){
					   $.alert("${ctp:i18n('performanceReport.queryMain_js.selectOvercrowding')}");//由于统计人数过多，为了不影响统计速度，请您选择200人之内！
					  	return;
					  }
				   }
    		      	//报表id
    			     Constants_report_id=retObj.reportId;
    			     Constants_report_Name=retObj.reportName;
    			   	//查看团队报表标记
    			     Constants_report_flag=retObj.viewFlag;
    			    //同时隐藏个人和团队报表页签
    			     hiddenAllTab=retObj.hiddenAllTab;
    			     hiddenChartGridTab=retObj.hiddenChartGridTab; 
    			    //个人团队页签不需要回填
    			     //personGroupTab =($.isNull(retObj.personGroupTab)?1:parseInt(retObj.personGroupTab));
    			     tabPerson=1;
    			     tabGroup=2;
    			     tabPersonGroup=3;
    			     
    			     //列表总条数，分页使用
    			     pageTotle=retObj.pageTotle;
    			     $("#pageSize").val('20');
    			     $("#pageNo").val('1');
					 chartIndex=0;
					 analysisType=1;
    			     
    			     if(Constants_report_id==KNOWLEDGESCORESTATISTICS||Constants_report_id==COMPREHENSIVEANALYSIS
    			     ||Constants_report_id==EFFICIENCYANALYSIS||Constants_report_id==NODEANALYSIS
    			     ||Constants_report_id==OVERTIMEANALYSIS||Constants_report_id==IMPROVEMENTANALYSIS||Constants_report_id==PROCESSPERFORMANCEANALYSIS){// 如果是知识积分排行榜，则设置分页组件的页数和条数
    			    	 if(tableChartTab == 1){
    			    	 	$("#pageContent").show();
    			    	 	$("#queryResult").css('border-bottom-color','');
    			    	 }
    			    	 configPageTotalAndSize();
    			     } else if(Constants_report_id==6463442791594018643 && reportParams.pageTotle==3){//OA-40886
    			     	if(reportParams.dataObjectList.length>1){
    			     		reportParams.dataObjectList[reportParams.dataObjectList.length-1][0].display="${ctp:i18n('performanceReport.queryMain_js.average')}";
    			     	}
    			     } else if(Constants_report_id==3569160983850797390){
                        if(reportParams.dataObjectList.length>1){
                            reportParams.dataObjectList[reportParams.dataObjectList.length-1][0].display="${ctp:i18n('performanceReport.queryMain_js.average')}";
                        }
                     } 
                     var isTable=$("#tableResult").parent().attr("class");
                     if(isTable.indexOf("current")!=-1){
    			  		$("#resultComp").show();
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
    			    if(!$.isNull(retObj.report)){
    			    	//result = retObj.report.chartList;
    			    	result = retObj.chartList; //ouyp anyChart 替换为echarts
    			    }   
    			    $("#queryResult").html("");
    			    if(tableChartTab == 2){
    			     	if(Constants_report_id==COMPREHENSIVEANALYSIS){
    			     		drawComprehensive();
    			     	}else{
		        			drawingDefualt(personGroupTab);
    			     	}
		        	}else{
		        		drawGrid();
		        		$("#queryResult").css("border-top-color","white");
		        	}
		        	//----------总计的内容--
		        	if(Constants_report_id==COMPREHENSIVEANALYSIS&&retObj.dataList.length==0){
    			      	$("#result").html("<td>${ctp:i18n('performanceReport.queryMain_js.totalOfCalls')}0${ctp:i18n('performanceReport.queryMain_js.times')}</td>");
    			    }
    			    if(Constants_report_id==IMPROVEMENTANALYSIS&&retObj.dataList.length>=2){
    			     	//改进分析对比区间结果
    			     	$("#resultComp").remove();
    			  		var avgRunTime=retObj.dataList[0][retObj.dataList[0].length-2];
    			  		var efficiency=retObj.dataList[0][retObj.dataList[0].length-1];
    			  		var hh="<div id='resultComp' style='display:none' class=' align_right stadic_layout_footer stadic_footer_height'>"+
    			  			"<table border='0'>"+
    			  			"<tr style='height: 30px;'>"+
    			  				"<td>${ctp:i18n('performanceReport.queryMain_js.resultsOfComparison')}${ctp:i18n('performanceReport.queryMain_js.referenceLength')}"+avgRunTime+";</td>";
    			  				hh+="<td>${ctp:i18n('performanceReport.workFlowAnalysis.charEfficiency')}"+efficiency+"</td>";
    			  			"</tr></table></div>";
    			  			$("#queryResult").after(hh);
    			  			$("#tableResult").click();
    			  	}else if(Constants_report_id==COMPREHENSIVEANALYSIS&&retObj.dataList.length>0){
    			  		//综合分析页脚总结结果
    			  		var no=3;
    			  		var allCaseCount=retObj.dataList[0][retObj.dataList[0].length-1];
    			  		 $("#result").html("<td>${ctp:i18n('performanceReport.queryMain_js.totalOfCalls')}"+allCaseCount+"${ctp:i18n('performanceReport.queryMain_js.times')}</td>"); 
    			  	}else if(Constants_report_id==EFFICIENCYANALYSIS&&retObj.dataList.length>0){
    			  		//效率分析页脚总结结果
    			  		var avgRunWorkTime=retObj.dataList[0][retObj.dataList[0].length-2];
    			  		var standarduration=retObj.dataList[0][1];
    			  		var radio=retObj.dataList[0][retObj.dataList[0].length-1];
    			  		var hh="<td>${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.standard')}:"+standarduration+";${ctp:i18n('performanceReport.queryMain_js.referenceLength')}"+avgRunWorkTime+";${ctp:i18n('performanceReport.queryMain_js.among')}"+radio+"${ctp:i18n('performanceReport.queryMain_js.belowRadio')}</td>";
    			  		$("#result").html(hh);
    			  	}else if(Constants_report_id==OVERTIMEANALYSIS&&retObj.dataList.length>0){
    			  		//超时分析页脚总结结果
    			  		var avgRunWorkTime=retObj.dataList[0][retObj.dataList[0].length-2];
    			  		var radio=retObj.dataList[0][retObj.dataList[0].length-1];
    			  		var hh="<td>${ctp:i18n('performanceReport.queryMain_js.referenceLength')}"+avgRunWorkTime+"&nbsp;&nbsp;${ctp:i18n('performanceReport.queryMain_js.among')}"+radio+"${ctp:i18n('performanceReport.queryMain_js.timeout')}</td>";
    			  		$("#result").html(hh);
    			  	}else if(Constants_report_id==PROCESSPERFORMANCEANALYSIS&&retObj.dataList.length>0){
    			  		//流程统计页脚总结结果
    			  		var total0=retObj.dataList[0][retObj.dataList[0].length-4];
    			  		var total1=retObj.dataList[0][retObj.dataList[0].length-3];
    			  		var total2=retObj.dataList[0][retObj.dataList[0].length-2];
    			  		var total3=retObj.dataList[0][retObj.dataList[0].length-1];
    			  		var statType=$("#statType").val();
    			  		$("#resultComp table").attr('width','100%');
    			  			
    			  		var hhh = "";
    			  		var text = "";
    			  		var index = 1;
    			  		var allIndex = retObj.headList[0].length;
    			  		$("#knowledgeLeader tr:eq(0) th").each(function(){
    			  			var s = "align='center' width='"+$(this).width()+"'";
    			  			if(index == 1){
    			  				s = "align='left' width='"+$(this).width()+"'";
    			  				text = "${ctp:i18n('performanceReport.authorize.person.totals')}：";
    			  			}else if(index == (allIndex-1)){
    			  				text = total3;
    			  			}else if(index == (allIndex-2)){
    			  				text = total2;
    			  			}else if(index == (allIndex-3)){
    			  				text = total1;
    			  			}else if(index == (allIndex-4)){
    			  				text = total0;
    			  			}
    			  			hhh += "<td class='sort' "+s+" colspan='1'>"+text+"</td>";
    			  			index++;
    			  			text = "";
    			  		});
    			  			
    			  		$("#result").html(hhh);
    			  	}else if(Constants_report_id==PROCESSPERFORMANCEANALYSIS&&retObj.dataList.length==0){
    			  		var hh="<td align='left'>${ctp:i18n('performanceReport.authorize.person.totals')}:</td>";
    			  		$("#result").html(hh);
    			  	}
		        	//----------总计的内容--
		        	$('#querySave').attr('disabled',false);
    			    $('#querySave').removeClass('common_button_disable');
    		 	 	$("#queryReset").focus();
    		   }
    		});
    		
    		//协同V5.0 OA-28833
    		inputNoDataInfo();
    	}
    }
    //协同V5.0 OA-28833
    function inputNoDataInfo(reportId){
      if(PROJECTSCHEDULESTATISTICS == reportId){
          //项目进度统计
          //$("#queryResult").html("${ctp:i18n('report.chart.noData')}");
    	  $("#queryResult").html("<div class='h100b' style='line-height:190px;vertical-align:middle;'>${ctp:i18n('report.chart.noData')}</div>");
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
			  		hh+="<td width='120' nowrap='nowrap' id='start_time_td'><div class='common_txtbox_wrap left'><input id='start_time' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
	         	 	hh+="<td id='mid'>-</td>"+"<td width='120' nowrap='nowrap'  id='end_time_td'><div class='common_txtbox_wrap left'><input  id='end_time' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
		  }
		  $("#timeAll").after(hh);
		  $("#manager_range").attr("width", "300");
		  if(Constants_report_id==KNOWLEDGESCORESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS){
		  	//知识贡献榜,知识活跃度不对齐问题
		  	$("#manager_range").attr('width','100%');
		  }
		  
		  if(Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==MEETINGJOINSTATISTICS){
		  		$("#manager_range").attr('width','82%');
		  }
		  $(".mycal").each(function(){$(this).compThis();});
		  //$("#rowOcc td").attr('width','30%');
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
		  			$("#type_td table").css('width','');
		  			$("#manager_range").attr('colSpan','5');
		  			$("#type_td").css("width","57%");
		  			$("#type_td").prev().css("width","43%");
		  			$("#rowOcc td").attr('width','80%');
		  		}else{
		  			$("#rowOcc td").attr('width','20%');
		  		}
		  	}
		  }
	  }else{
		  $("#timeAll").nextAll().remove();
		  $("#timeDiv").addClass("common_selectbox_wrap");
		//  $("#end_time_td,#mid,#end_time,#start_time_td,#end_time_td,.calendar_icon").remove();//.css("display","none");
		 if($("#reportId").val()==WORKDAILYSTATISTICS){
		  	$("#timeAll").attr("width","75%");
		  }
		  if(hiddenChartGridTab!='true'){
		  	 $("#manager_range").attr("width", "100%");
		  }
		  if($("#reportId").val()==ONLINETIMESTATISTICS||$("#reportId").val()==KNOWLEDGESCORESTATISTICS
		  ||$("#reportId").val()==MEETINGJOINSTATISTICS||$("#reportId").val()==MEETINGJOINROLESTATISTICS
		  ||$("#reportId").val()==KNOWLEDGEACTIVITYSTATISTICS||$("#reportId").val()==EVENTSTATISTICS){
		  		$("#manager_range").attr("width", "82%");
		  		$("#timeAll").attr('width','82%');
		  }
		  if(Constants_report_id==WORKDAILYSTATISTICS){
		  		var appType=$("#appType").val();
		  		if(appType==5||appType==7){
		  			$("#type_td table").css('width','250px');
		  			if($("#manager_range").attr("colSpan")!=undefined){
		  				$("#manager_range").removeAttr("colSpan");
		  			}
		  			$("#rowOcc td").attr('width','75%');
		  		}
		  	}
	  }
	  
  }
  //报表转发协同
  function reportForwardCol(){
	 $("#knowledgeLeader").css("border-left-color","#b6b6b6");
	 $("#reportGrid").css("border-left-color","#b6b6b6");
	 $("#onlineAnalysis").css("border-left-color","#b6b6b6");
     var contentHtml="";//$('#queryResult').html();
     if(tableChartTab==2)
     {
    	var performanceQueryManager_ = new performanceQueryManager();
    	if(Constants_report_id == COMPREHENSIVEANALYSIS)
    	{
    		var analysisType=$(":input[name='analysisType'][checked]").val();
    		//contentHtml+="<img src='data:image/gif;base64,"+comprehensiveChart.chart.getPNG()+"'>";
    		//var imgId = performanceQueryManager_.saveImage(SeeyonUiChart2.getImage(htmlId),1);
    		//contentHtml+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
    		var base64 = seeyonUiChartApi.getImage(htmlId);
    		if (base64 == '') {
    			$.alert($.i18n('report.reportResult.Browser.too.low'));
    			return;
    		}
    		contentHtml += "<img src='" + base64 + "'/>";
    		if(chartObject!=''&&chartObject!=null)
    		{
    			//contentHtml+="<img src='data:image/gif;base64,"+chartObject.chart.getPNG()+"'>";
    			var imgId = performanceQueryManager_.saveImage(seeyonUiChartApi.getImage(htmlId),1);
    			contentHtml+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
    		}
    	}
    	else
    	{
		 	if(chartObjS!=null&&chartObjS.length>0)
		 	{
		 		//if ( $.browser.msie ){
		    	//	if($.browser.version<8){//对不起，当前您的浏览器版本过低无法支持图表的打印与转发，请升级至IE8及以上版本
		    	//		$.alert("${ctp:i18n('report.chart.ie7.info')}");
		    	//		return;
		    	//	}
		    	//}
		    	//OA-44998 解决ie7下打印和转发协同的问题
	 			for(var i=0;i<chartObjS.length;i++){
	 	 			//var htmlId = chartObjS[i].htmlId;
	 	 			var htmlId = chartObjS[i];
	 	 			if($("#"+htmlId+"").css("display")=='none'){ continue; }
	  				//var html = "\<script\>if($.browser.msie){document.write(\"\<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/\>\");}else{document.write(\"\<img src='data:image/gif;base64,"+chartObjS[i].chart.getPNG()+"'/\>\");}\</script\>";
	  				//var base64 = seeyonUiChartApi.getImage(htmlId);
	  				//var imgId = performanceQueryManager_.saveImage(base64,1);
	  				//var imgId = performanceQueryManager_.saveImage(chartObjS[i].chart.getPNG(),1);
	    			//contentHtml+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
	    			var base64 = seeyonUiChartApi.getImage(htmlId);
		    		if (base64 == '') {
		    			$.alert($.i18n('report.reportResult.Browser.too.low'));
		    			return;
		    		}
    				contentHtml += "<img src='" + base64 + "'/>";
	 			 }
		 	}
		}
	 }
     else
     {
		//去掉链接
		//var reportContent=$("#queryResult a").contents().unwrap();
		//OA-51031日常工作统计表格展现时转发协同，协同正文中表格缩得太小			
		//$('#queryResult table').removeAttr("width");
		//contentHtml=$('#queryResult').html();
		//OA-84808 绩效查询，流程超期统计，统计页面，转发协同后，统计结果变为了不可穿透
		contentHtml = $('#queryResult').clone(true).find("a").contents().unwrap().end().end().html();
	 }
     var colParam = 
     {
    		 subject : $("#reportName").html(),
    		 bodyContent : contentHtml
     };
     collaborationApi.newColl(colParam);
     
     //$("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
     //$('#reportContent').val(contentHtml);
     //$('#reportTitle').val($("#reportName").html());
     //$("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
     //配置到首页的绩效报表转发，要还原到当前页
   /*  if(parent.window.location.href.indexOf("performanceQuery.do")==-1){
    	 $("#queryConditionForm").attr("target","");
     }*/
     //$("#queryConditionForm").submit();//jsonSubmit({});
  }

  //报表打印
  function printReport(){
	 $("#knowledgeLeader").css("border-left-color","#b6b6b6");
	 $("#reportGrid").css("border-left-color","#b6b6b6");
	 $("#onlineAnalysis").css("border-left-color","#b6b6b6");
	  var printSubject ="";
		var printsub = $('#reportName').html();
		printsub = "<center><span style='font-size:24px;line-height:24px;'>"+printsub.escapeHTML()+"</span><hr style='height:1px' class='Noprint'&lgt;</hr><input type='hidden' name='rrsu' id='rrsu' value="+result+" /></center>";
		
		var printColBody = "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
		var colBody ="";// $('#queryResult').html();
		if(tableChartTab==2){
		var imgId;
		var performanceQueryManager_ = new performanceQueryManager;
		if(Constants_report_id==COMPREHENSIVEANALYSIS){
    		var analysisType=$(":input[name='analysisType'][checked]").val();
    		//colBody+="<img src='data:image/gif;base64,"+comprehensiveChart.chart.getPNG()+"'>";
    		var base64 = seeyonUiChartApi.getImage(htmlId);
    		if (base64 == '') {
    			$.alert($.i18n('report.reportResult.Browser.too.low'));
    			return;
    		}
    		colBody += "<img src='" + base64 + "'/>";
			//var imgId = performanceQueryManager_.saveImage(seeyonUiChartApi.getImage(htmlId),2);
			//colBody+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
			if(chartObject!=''&&chartObject!=null){   		
    			//colBody+="<img src='data:image/gif;base64,"+chartObject.chart.getPNG()+"'>";
				var imgId = performanceQueryManager_.saveImage(seeyonUiChartApi.getImage(htmlId),2);
				colBody+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
			}
    	}else{
		if(chartObjS!=null&&chartObjS.length>0){
		//if ( $.browser.msie ){
    		//if($.browser.version<8){//对不起，当前您的浏览器版本过低无法支持图表的打印与转发，请升级至IE8及以上版本
    		//	$.alert("${ctp:i18n('report.chart.ie7.info')}");
    		//	return;
    		//}
    	//}
    	//OA-44998 解决ie7下打印和转发协同的问题
		for (var i = 0; i < chartObjS.length; i++)
		{
			var htmlId = chartObjS[i];
			var base64 = seeyonUiChartApi.getImage(htmlId);
    		if (base64 == '') {
    			$.alert($.i18n('report.reportResult.Browser.too.low'));
    			return;
    		}
    		colBody += "<img src='" + base64 + "'/>";
			//var imgId = performanceQueryManager_.saveImage(seeyonUiChartApi.getImage(htmlId),2);
    			//colBody+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
				//colBody+="<img src='data:image/gif;base64,"+chartObjS[i].chart.getPNG()+"'>";
			//colBody+="<img src='${path}/performanceReport/performanceQuery.do?method=toImageForIe&imgId="+imgId+"'/>";
		}
		}
		}
		}else{
			colBody=$('#queryResult').html();
		}	
		var  colBodyFrag= new PrintFragment(printSubject, colBody);	
		var printSubFrag = new PrintFragment(printColBody,printsub );	
		var cssList = new ArrayList();
		
		var pl = new ArrayList();
		pl.add(printSubFrag);
		pl.add(colBodyFrag);
		printList(pl,cssList)
		$("#knowledgeLeader").css("border-left-color","white");
		$("#reportGrid").css("border-left-color","white");
		$("#onlineAnalysis").css("border-left-color","white");
  }

  //导出excel
function reportToExcel(){
	if(tableChartTab==2){
		 $.alert("${ctp:i18n('performanceReport.queryMain_js.errorExcel')}");//对不起，图表无法导出，您可以右键保存到本地！
    	 return false;
	}
	 var dataList=reportParams.dataObjectList;;
     if($.isNull(dataList)||dataList=="[]"||$.isNull(result)){//&&!$.isNull(reOnloadflag)
    	 $.alert("${ctp:i18n('performanceReport.queryMain_js.errorNoDataToExcel')}");//没有可以导出的数据！
    	 return false;
     }
	var tabInfo="&personGroupTab="+personGroupTab+"&tableChartTab="+tableChartTab;
	$("#resolveExecel").attr("action", "${path}/performanceReport/performanceQuery.do?method=exportToExcel"+tabInfo);
	$("#resolveExecel").jsonSubmit({});
}

//查看流程
function showDigarm() {
	var templeteId = $("#templeteId").val();
	if (templeteId == "") {
		$.error("${ctp:i18n('performanceReport.queryMain.chooseTemplate')}");//请选择模板
		return ;
	}
	$.post(_ctxPath+"/performanceReport/WorkFlowAnalysisController.do?method=viewWorkflow",{templeteId:templeteId},function(data){
		var ptemplateId=data;
		showWFTDiagram(getCtpTop(),ptemplateId,window);
	});
}

 /**
     * 查看帮助信息 13-4-18 longt
     */
    function showHelpDescription(baseUrl,from){
    	if(from =='7728786349204325388' || from == '4832723163238252625'){
    		from='8187033991580765988';
    	}else if(from =='-2118631663956308322' || from == '8841211418965788869'){
    		from='516519058127931295';
    	}else if(from =='-3648914008719078167' ){
    		from='3569160983850797390';
    	}
    	var _url = baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=showHelpDescription&reportId="+Constants_report_id+"&from=" + from + "&performanceQuery=" + from;
    	var dialog = $.dialog({
    	    id: 'url',
    	    url: _url,
    	    width: 340,
    	    height: 280,
    	    targetWindow:getCtpTop(),
    	    title: "${ctp:i18n('performanceReport.queryMain_js.help.title')}",
    	    buttons: [{
    	        text: "${ctp:i18n('performanceReport.queryMain_js.button.close')}",
    	        handler: function () {
    	           dialog.close();
    	        }
    	    }]
    	});
    }

</script>
<script type="text/javascript">
//绩效报表主题
var theme = {
	backgroundColor: '#FFFFFF',
	/* color: [
        '#1D8BD1','#F1683C','#2AD62A','#DBDC25',
        '#8FBC8B','#D2B48C'
    ], */
    // 提示框
    tooltip: {
        formatter: function(param) {
        	var fm;
        	switch(param.series.type) {
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
        x: 80,
	    y: 50,
	    x2: 80,
	    y2: 30
    },
    //滚动条
    dataZoom: { height: 29 },
 	// 柱状图
    bar: {
        itemStyle: {
            normal: { label: { show: true, } },
            emphasis: { label: { show: true, } }
        }
    },
    //饼状图
    pie: {
		startAngle: 180,
		center: ['50%', '50%'],
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
                },
                labelLine : {
                    show : false
                }
            }
    	}
    },
    //仪表盘
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
};
</script>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common/fillCondition.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common/reportOption.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showTable.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showChart.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager${v3x:resSuffix()}"></script>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryMainHtml_js.jsp"%>
<c:if test="${ctp:hasPlugin('collaboration')}">
<script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
</c:if>
