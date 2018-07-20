<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<html>
<head>
<title>Insert title here</title>
<script type="text/javascript">
	function fillCondition(pt){
		if(pt){
			switch(Constants_report_id){
			case WORKDAILYSTATISTICS://日常工作统计条件区
			 $("#appType").val(pt["appType"]);
			 changeType();
			 $("#status").val(pt["status"]);
			 fillTime(pt);
			 fillPerson(pt);
			break;
			case PLANRETURNSTATISTICS://计划提交回复统计
			 $("#planType").val(pt["planType"]);
			 var reportCategory=$("#reportCategory").val();
			 if(reportCategory=='1'||personGroupTab=='1'){
			 	planTimeIntervalChange();
			 }
			 fillTime(pt);
			 fillPerson(pt);
			break;
			case MEETINGJOINSTATISTICS://会议参加情况统计
			 fillTime(pt);
			 fillPerson(pt);
			break;
			case MEETINGJOINROLESTATISTICS://会议参加角色情况统计
			 fillTime(pt);
			 fillPerson(pt);
			break;
			case TASKBURNDOWNSTATISTICS://任务燃尽图
			 $("#taskInfo").val(pt["taskInfo"]);
			 $("#task_id").val(pt["task_id"]);
			break;
			case KNOWLEDGEINCREASESTATISTICS://知识增长趋势
				fillTime(pt);
			break;
			case KNOWLEDGESCORESTATISTICS://知识积分排行榜
				fillTime(pt);
			 	fillPerson(pt);
			break;
			case KNOWLEDGEACTIVITYSTATISTICS://知识社区活跃度
				fillTime(pt);
			    fillPerson(pt);
		    break;
			case ONLINESTATISTICS://在线人数趋势
			   $("#radio11").attr("checked",pt["radio11"]==0?true:false);
			   $("#radio12").attr("checked",pt["radio12"]==1?true:false);
			   onlineStatisticsChange();
			   fillTime(pt);
			break;	
			case ONLINETIMESTATISTICS://在线时间分析
		   		fillTime(pt);
			    fillPerson(pt);
			break;
			case EVENTSTATISTICS://事项统计
				fillTime(pt);
			    fillPerson(pt);
			break;	
			case PROJECTSCHEDULESTATISTICS://项目进度统计
				$("#projectName").val(pt['projectName']);
				$("#projectManager").val(pt['projectManager']);
				$("#selfRole").val(pt['selfRole']);
				$("#projectStatus").val(pt['projectStatus']);
			break;
			case STORAGESPACESTATISTICS://存储空间统计
				fillPerson(pt);
			break;
			case FLOWSENTANDCOMPLETEDSTATISTICS://流程已办已发统计
				$("#flowType").val(pt["flowType"]);
				flowTypeChange();
				$("#Checkbox1").attr("checked",pt["Checkbox1"]!=''&&pt["Checkbox1"]!='null'?true:false);
				$("#Checkbox2").attr("checked",pt["Checkbox2"]!=''&&pt["Checkbox2"]!='null'?true:false);
				$("#flowStatus").val(pt["flowStatus"]);
		   		$("#flowTemplateNum").val(pt["flowTemplateNum"]);
		       	fillTime(pt);
		       	fillPerson(pt);
			break;		
			case FLOWOVERTIMESTATISTICS://流程超期统计
		    	$("#flowType").val(pt["flowType"]);
		    	$("#flowOverTimeStatus").val(pt["flowOverTimeStatus"]);
		   		overTimeStatusChange();
		    	var flowOverTimeStatus=$("#flowOverTimeStatus").val();
		    	if(flowOverTimeStatus!=1){
		       		fillTime(pt);
		       	}
		       	fillPerson(pt);
			break;
			case EFFICIENCYANALYSIS://效率分析
				fillTemplete(pt);
			   	fillTime(pt);
			break;
			case NODEANALYSIS://节点分析
				fillTemplete(pt);
			   	fillTime(pt);
			break;
			case OVERTIMEANALYSIS://超时分析
				fillTemplete(pt);
				if("flowstate0" in pt&&pt["flowstate0"]!=''&&pt["flowstate0"]!='null'){
					$("#flowstate0").attr("checked",true);
				}else{
					$("#flowstate0").attr("checked",false);
				}
				if("flowstate1" in pt&&pt["flowstate1"]!=''&&pt["flowstate1"]!='null'){
					$("#flowstate1").attr("checked",true);
				}else{
					$("#flowstate1").attr("checked",false);
				}
				if("flowstate3" in pt&&pt["flowstate3"]!=''&&pt["flowstate3"]!='null'){
					$("#flowstate3").attr("checked",true);
				}else{
					$("#flowstate3").attr("checked",false);
				}
			   	fillTime(pt);
		       	//$("#queryCondition table").eq(0).attr('width','85%');
			break;
 			case IMPROVEMENTANALYSIS://改进分析
 				fillTemplete(pt);
 				$("#start_time1").val(pt["start_time1"]);
 				$("#end_time1").val(pt["end_time1"]);
 				$("#start_time2").val(pt["start_time2"]);
 				$("#end_time2").val(pt["end_time2"]);
 			break;
			case COMPREHENSIVEANALYSIS://综合分析
				$("#flowType").val(pt["flowType"]);
				if(pt["allTemplete"]==""||pt["allTemplete"]=="null"){
                	 $("#chooseTemplete").attr("checked",true);
                	 $("#templeteName").show();
	                 $("#specTempleteDiv").show();
                	 fillTemplete(pt);
                }
				fillTime(pt);
			break;
			case PROCESSPERFORMANCEANALYSIS://流程统计
				$("#condition").val(pt["condition"]);
				$("#appType").val(pt["appType"]);
                if(pt["allTemplete"]==""||pt["allTemplete"]=='null'){
                	 $("#chooseTemplete").attr("checked",true);
                	 $("#templeteName").attr("disabled",false);
                	 $("#templeteName").show();
	                 $("#specTempleteDiv").show();
					fillTemplete(pt);
                }
                if("toPer" in pt&&pt["toPer"]!=''&&pt["toPer"]!='null'){
                	$("#toPer").attr("checked",true);
                	$("#toPer").val(pt["toPer"]);
                	switchIt(document.getElementById("toPer"));
                	$("#person").val(pt["person"]);
                	$("#personIds").val(pt["personIds"]);
                }else if("toDep" in pt&&pt["toDep"]!=''&&pt["toDep"]!='null'){
                	$("#toDep").attr("checked",true);
                	$("#toDep").val(pt["toDep"]);
                	switchIt(document.getElementById("toDep"));
                	$("#department").val(pt["department"]);
                	$("#departmentIds").val(pt["departmentIds"]);
                }
    			//流程统计,给statType,statWhat赋值
    			processStatType();
				fillTime(pt);
				if(tableChartTab=="2"){
 					//隐藏统计信息
 					$("#result").hide();
 				}
			break;
			default:
				fillTime(pt);
			    fillPerson(pt);
			    break;
	 	 }
	  }
	 }
	  //回填模板
	function fillTemplete(pt){
		if(pt["templeteName"]){
			var templeteName=pt["templeteName"].replaceAll("\\|",",",false);
			var templeteId=pt["templeteId"].replaceAll("\\|",",",false);
			$("#templeteName").val(templeteName);
			$("#templeteId").val(templeteId);
		}
	}
	//回填时间
	function fillTime(pt){
		if(pt["time"]||pt["start_time"]){
			 $("#time").val(pt["time"]!='null'?pt["time"]:$("#time").val());
			 timeChange();
			 $("#start_time").val(pt["start_time"]!='null'?pt["start_time"]:$("#start_time").val());
		   	 $("#end_time").val(pt["end_time"]!='null'?pt["end_time"]:$("#end_time").val());
		}
	}       
	//回填人员
	function fillPerson(pt){
		if(pt["managerRange"]){
			$("#managerRange").val(pt["managerRange"]);
			$("#managerRangeIds").val(pt["managerRangeIds"]);
		}
	}
</script>
</head>
<body>
</body>
</html>