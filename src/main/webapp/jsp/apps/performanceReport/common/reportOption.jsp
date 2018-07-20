<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript">
	//任务选择器
    function taskInfoChange(){
    	var title = "${ctp:i18n('taskmanage.parentTask.select')}";
        var dialog = $.dialog({
            id : 'url',
            url : _ctxPath + '/taskmanage/taskinfo.do?method=listParentTasks&isReport=1&parentId='+$("#task_id").val(),
            width : $(getCtpTop()).width()-100,
            height : $(getCtpTop()).height()-100,
            title : title,
            targetWindow : getCtpTop(),
            buttons : [ {
                text : "${ctp:i18n('performanceReport.queryMain.button.confirm')}",
                handler : function() {
                    var ret = dialog.getReturnValue();
                    var taskAjax = new taskAjaxManager();
                    var taskDetailData = null;
                    taskDetailData = taskAjax.taskInfoDetailed(ret);
                    if(taskDetailData != null) {
                        $("#taskInfo").val(taskDetailData.subject);
                        $("#task_id").val(taskDetailData.id);
                        dialog.close();
                        RemoveCheckMsg($("#taskInfo"));
                        $('#querySave').attr('disabled',false);
                        $('#querySave').removeClass('common_button_disable');
                    }else{
                    	 $.alert("${ctp:i18n('performanceReport.queryMain_js.errorTaskCheckInputValue')}");
                    	 return false;
                    }
                }
            }, {
                text : "${ctp:i18n('performanceReport.authorize.person.button.cancel')}",
                handler : function() {
                    dialog.close();
                }
            } ]
        });
    }
    
	  	//字符串实例方法,类似java字符串的replaceAll
      String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {   
   	 	if (!RegExp.prototype.isPrototypeOf(reallyDo)) {   
        	return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);   
    	} else {   
        	return this.replace(reallyDo, replaceWith);   
    	}   
	} 
	
	//单位/部门条件
	function dataToColony(elements,which){
	    if (!elements) {
	        return false;
	    }
	    var memberIds = getIdsString(elements);
	    var memberNames = getNamesString(elements);
	    var statType = "";
	    var typeCount = 0;
	    for(var i=0; i<elements.length; i++){
	    	var person = elements[i];
	        //memberIds += person.type + "|" + person.id + ",";
	        if(statType != person.type)
	        	typeCount++;
	        statType = person.type;	
	    }
	    if(typeCount>1){
	    	alert(v3x.getMessage("collaborationLang.workflowStat_onlySelectOne"));
	    	return;
	    }
	    if(which == "department"){
		    document.getElementById("departmentIds").value = memberIds;
		    document.getElementById("department").value = memberNames;
		    <c:if test="${!isGroupAdmin}">
		    document.getElementById("toDep").value = statType;
		    </c:if>
	    }else if(which == "person"){
	    	document.getElementById("personIds").value = memberIds;
	    	document.getElementById("person").value = memberNames;
	    }
	}
	
	function clearTempChoose(){
		  var tId = $("#templeteId").val();
		  if(tId!=1 && tId!=-1){//1表示当前选的是全部模板或自建流程，不需要做数据清理
			 templateChooseCallback("","");
		  }
		  //弹出框组件将已选项存放在全局变量rv中，这里选择全部模板后，将rv置空
		  templateOrginalData = null;
		}
		
	function changeAppType(){
	    //协同V5.0 OA-31984 切换
	    clearTempChoose();
	    
		var theForm = document.getElementById("queryCondition");
		var selectedAppEnumKey = $("#condition").val();
		if (isGroupAdmin=='true' || isAdministrator=='true') {
			if(selectedAppEnumKey == 2){
				$("#oneselfCreate").attr("disabled",true);
				if(isAdministrator==='true'){
					$("#allTemplete").attr("disabled",true);
				}
				var operationTypeArr = $("input[name='operationType']");
				for(var i=0; i<operationTypeArr.length; i++){
					var operationType = operationTypeArr[i].value;
					if(operationType == "template"){
						operationTypeArr[i].checked = true;
						$("#templeteName").attr("disabled",false);
						$("#templeteName").val("点击选择");
						$("#templeteId").val("");
					}
				}
			}else{
				$("#oneselfCreate").attr("disabled",false);
				if(isAdministrator==='true'){
					$("#allTemplete").attr("disabled",false);
				}
				var operationTypeArr = $("input[name='operationType']");
			    for(var i=0; i<operationTypeArr.length; i++){
					if(operationTypeArr[i].checked){
						var operationType = operationTypeArr[i].value;
						if(operationType == "template"){
							operationTypeArr[0].checked = true;
							$("#templeteName").attr("disabled",true);
							$("#templeteName").val("点击选择");
							$("#templeteId").val("${!isGroupAdmin and !isAdministrator ? '1' : '-1'}");
						}
					}
				}
			}
		}
		$("#templeteName").attr("title","");
		$("#appType").val($("#condition").val());
	}
	
	function switchIt(obj){
		var toDep = document.getElementById("toDep");
		var toPer = document.getElementById("toPer");
		var statType = document.getElementById("statType");
		
		var department = document.getElementById("department");
		var person = document.getElementById("person");
		if(obj.id=="toDep" || obj.id=="toAccount"){
			$("#depLabel").show();
			$("#depContent").show();
			$("#perLabel").hide();
			$("#perContent").hide();
			$("#acldem").show();
			if(obj.id=="toAccount"){
				statType.value = document.getElementById("toAccount").value;
			}else{
				statType.value = toDep.value;
			}
			$("#department").val("点击选择");
		}else if(obj.id=="toPer"){
			$("#depLabel").hide();
			$("#depContent").hide();
			$("#acldem").hide();
			$("#perLabel").show();
			$("#perContent").show();
			statType.value = toPer.value;
			$("#person").val("点击选择");
		}
	}
	
	function selectPeopleDA(){
		if(document.getElementById("toAccount") && document.getElementById("toAccount").checked){
			//selectPeopleFun_colonyAccount();
			var values = $("#departmentIds").val();
			var txt = $("#department").val();
			if("${accountId }"==values||values.indexOf('Department')!=-1){
				txt='';
				values='';
			}
			$.selectPeople({
	        	type : 'selectPeople',
	        	panels : 'Account',
	        	selectType : 'Account',
	        	onlyLoginAccount : userAuth(),
	        	hiddenOtherMemberOfTeam:true,
		    	params : {
		    		text : txt,
		        	value : values
		    	},
		    	callback : function(ret) {
			  		$("#department").val(ret.text);
		      		$("#departmentIds").val(ret.value);
		      		if(ret.obj!= null){
		      			dataToColony(ret.obj,'department');
        			}
		    	}
			});
		}
		else{
			//selectPeopleFun_colony();
			var values = $("#departmentIds").val();
			var txt = $("#department").val();
			if("${accountId }"==values||values.indexOf('Account')!=-1){
				txt='';
				values='';
			}
			$.selectPeople({
	        	type : 'selectPeople',
	        	panels : 'Department,Outworker',
	        	selectType : selectType(),
	        	onlyLoginAccount : userAuth(),
	        	hiddenOtherMemberOfTeam:true,
		    	params : {
		    		text : txt,
		        	value : values
		    	},
		    	callback : function(ret) {
			  		$("#department").val(ret.text);
		      		$("#departmentIds").val(ret.value);
		      		if(ret.obj!= null){
		      			dataToColony(ret.obj,'department');
        			}
		    	}
			});
			
		}
	}
	
	function selectType(){
		if(isGroupAdmin=='true'){
			return "Department";
		}
		return 'Account,Department';
	}
	$("#person").live("click",function(){
		var values = $("#personIds").val();
		var txt = $("#person").val();
		$.selectPeople({
	        type : 'selectPeople',
	        panels : 'Department,Team,Post,Level,Outworker',
	        selectType : 'Member',
	        onlyLoginAccount : userAuth(),
	        hiddenOtherMemberOfTeam:true,
	        maxSize:getMaxSize(),
		    params : {
		    	text : txt,
		        value : values
		    },
		    callback : function(ret) {
			  $("#person").val(ret.text);
		      $("#personIds").val(ret.value);
		    }
		});
	})
	function userAuth(){
		if(isAdministrator=='true'){
			return true;
		}
		if(isGroupAdmin=='true'){
			return false;
		}
	}
	
	var oldtempleteName="";
	$("#templeteName").live("click",function(){
	//模板选择器回填操作
		var  template = [];
		var templeteName=new Array();
		templeteName=$("#templeteName").val().split(",");
		template["ids"]=$("#templeteId").val();
		template["names"]=templeteName;
		template["namesDisplay"]=oldtempleteName;
		templateOrginalData =template;
		//流程统计选人 appType(4,1,2)
		var appType=$("#appType").val();
		if(appType==4){
		  /**
		   *模板左右选择组件,参数没有就传null
		   *@param callback 回调函数
		   *@param isMul 是否支持多选，默认为true
		   *@param moduleType 模板分类，取ModuleType的枚举值Key
		   *@param accountId 单位ID，默认为当前登录单位ID
		   *@param scope 数据范围：枚举值["MemberUse","MaxScope","MemberAnalysis"]
		   *@param excludeTemplateIds : 不包含的模板ID，以，分隔的字符串，eg:123232,12121,43,21212 不宜太多，10个以下为好
		   *@param reportId:报表ID，F8专用
		   */
	 		templateChoose(templateChooseCallback,4,true,'','MemberAnalysis','','${reportId}');
		}else if(appType==2){
			templateChoose(templateChooseCallback,2,true,'','MemberAnalysis','','${reportId}');
		}else if(appType==1){
			templateChoose(templateChooseCallback,1,true,'','MemberAnalysis','','${reportId}');
		}else{
			selectTemplate();
		}
	})
	
	function hiddenTemplete() {
		$("#specTempleteDiv").hide();
		document.getElementById("templeteName").style.display = "none";
	}
	
	function selectTemplate(){
		//模板选择器回填操作
		var  template = [];
		var templeteName=new Array();
		templeteName=oldtempleteName.split(",");
		$("#templeteName").show();
		template["ids"]=$("#templeteId").val();
		template["names"]=templeteName;
		template["namesDisplay"]=oldtempleteName;
		templateOrginalData =template;
		if(Constants_report_id==COMPREHENSIVEANALYSIS){
			templateChoose(templateChooseCallback,$("#flowType").val(),true,'','MemberAnalysis','','${reportId}');
			$("#specTempleteDiv").show();
		}else{
			templateChoose(templateChooseCallback,'',false,'','MemberAnalysis','','${reportId}');
			$("#specTempleteDiv").show();
			$("#querySave").removeAttr("disabled","false");
			$('#querySave').removeClass('common_button_disable');
		}
	}
	
	function templateChooseCallback(id,name){
		$("#templeteName").css("display","block").val(name);
		//增加冒泡提示
		$("#templeteName").attr("title",name);
		$("#templeteId").val(id);
		RemoveCheckMsg($("#templeteName"));
	}
	//提交前部分报表需要输入验证
    function checkInputValue(){
    	var reportId=$("#reportId").val();
    	if(reportId==FLOWSENTANDCOMPLETEDSTATISTICS){
    		var checkflag=false;
    		 $(":checkbox").each(function(){    				
    					if($(this).attr("checked")=="checked"){
    						checkflag= true;
    					}
    				});
    		if(!checkflag){
   			 $.alert("${ctp:i18n('performanceReport.queryMain_js.errorCheckInputValue')}");//自由协同和模板协同 至少选择一个!
   			 return false;
    		}
    	}else if(reportId==FLOWSENTANDCOMPLETEDSTATISTICSEDOC){
    		var checkflag=false;
    		 $(":checkbox").each(function(){    				
    					if($(this).attr("checked")=="checked"){
    						checkflag= true;
    					}
    				});
    		if(!checkflag){
   			 $.alert("${ctp:i18n('performanceReport.queryMain.chooseOne')}");//自建流程和模板流程 至少选择一个!
   			 return false;
    		}
    	}else if(reportId==PROJECTSCHEDULESTATISTICS){
    		var projectName=$("#projectName").val();
    		var projectManager=$("#projectManager").val();
    		if(!$.isNull(projectName)){return checkInputString(projectName,"${ctp:i18n('performanceReport.queryMainHtml.projectName')}");}//项目名称
    		if(!$.isNull(projectManager)){return checkInputString(projectManager,"${ctp:i18n('performanceReport.queryMainHtml.projectManager')}");}//项目负责人
    	}else if(reportId==PROCESSPERFORMANCEANALYSIS){
    		if(isPortal!="true"){
    			if(number>0){
    				//单位管理员或者集团管理员验证统计范围
    				var radioId=$("#statisticsRange").find(":radio[checked]").attr("id");
    				var departmentIds=$("#departmentIds").val();
    				var personIds=$("#personIds").val();
    				var isNull=false;
    				if((radioId=="toAccount"||radioId=="toDep")&&($.isNull(departmentIds)||departmentIds=='-1')){
    					isNull=true;
    				}else{
    					if(radioId=="toPer"&&$.isNull(personIds)){
    						isNull=true;
    					}
    				}
    				if(isNull==true){
    					$.alert("${ctp:i18n('performanceReport.queryMain_js.statisticsRange.label')}");
    					return false;
    				}
    			}
    		
    			if(isGroupAdmin!="true"){
    				//单位管理员或者一般人员验证统计模板
    				var templeteId=$("#templeteId").val();
    				if(templeteId!=undefined&&$.isNull(templeteId)){
    					$.alert("${ctp:i18n('performanceReport.queryMain.chooseTemplate')}");
    					return false;
    				}
    			}
    		}
    	}
		return true;
    }
    
    //特殊字符检查（公用的检查机制在此处不适用）
    function checkInputString(valInput,strAlert)
    {
      //var valInput = objInput.value;
      var findex;
      if((findex=valInput.indexOf("\""))>=0
      || (findex=valInput.indexOf("\'"))>=0
      || (findex=valInput.indexOf("\n"))>=0
      || (findex=valInput.indexOf("\r"))>=0
      || (findex=valInput.indexOf("\\"))>=0
      || (findex=valInput.indexOf("<"))>=0
      || (findex=valInput.indexOf(">"))>=0
      || (findex=valInput.indexOf("/"))>=0
      )
      {//"\r\n第"+(findex+1)+"个字符为非法字符:"+valInput.charAt(findex)+"\n\r非法字符包括:\" \' \\ < > / 回车 换行"
    	var findex1=findex+1;//longt
        var szTemp=$.i18n('performanceReport.queryMain_js.errorCheckInputString',findex1,findex);
         $.alert(strAlert+szTemp);
        return false;
      }
      else
      {
        return true;
      }
    }
    
    	function checkDate(d1, d2){
	  	if(Constants_report_id!=PROCESSPERFORMANCEANALYSIS){
		  	return true;
	  	}
		var year = d1.substring(0,d1.indexOf("-"));
		var month = d1.substring(d1.indexOf("-")+1,d1.lastIndexOf("-"))-1;
		var date = d1.substring(d1.lastIndexOf("-")+1);
		var date1 = new Date(year,month,date);
		
		year = d2.substring(0,d2.indexOf("-"));
		month = d2.substring(d2.indexOf("-")+1,d2.lastIndexOf("-"))-1;
		date = d2.substring(d2.lastIndexOf("-")+1);
		var date2 = new Date(year,month,date);
		var minus = date2-date1;
		// 时间范围不能超过一年
		if(minus>31536000000){
			alert("时间范围不能超过一年");
			return false;
		}
		// 时间范围最好不要超过三个月(当然也可以超过)
 		if(minus>7948800000&&isPortal!='true'){
 			if(!confirm("因时间跨度过大,为不影响系统运行速度,建议下班后统计。点击确定将立刻进行统计,点击取消将稍后进行")){
				return false;
 			}		
 		}
		return true;
	}
    //日期开始结束时间比较
    function checkStartEndDate(startTime,endTime){
    	try{
    	if(typeof(reportId)!="undefined" && reportId==PROCESSPERFORMANCEANALYSIS){
    		if($.isNull(startTime)&&$.isNull(endTime)){
    			$.alert("${ctp:i18n('performanceReport.queryMain_js.time.label')}");
    			return false;
    		}else if($.isNull(startTime)){
    			$.alert("${ctp:i18n('performanceReport.queryMain_js.starttime.label')}");
    			return false;
    		}else if($.isNull(endTime)){
    			$.alert("${ctp:i18n('performanceReport.queryMain_js.endtime.label')}");
    			return false;
    		}
    	}
    	//报表选择的时间不能在升级时间之前
		var compareDate="2012-04-01";// 升级时间
		upgrageDate = new Date(compareDate.replace(/-/g, "/"));
    	//老报表
    	Constants_report_id = $("#reportId").val();
    	if(Constants_report_id ==  COMPREHENSIVEANALYSIS  || Constants_report_id == OVERTIMEANALYSIS
    			|| Constants_report_id ==  NODEANALYSIS || Constants_report_id == PROCESSPERFORMANCEANALYSIS || Constants_report_id == EFFICIENCYANALYSIS){
    		var date1=new Date(startTime.replace(/-/g, "/"));
			var date2=new Date(endTime.replace(/-/g, "/"));
			if(Constants_report_id ==  COMPREHENSIVEANALYSIS){
				var d1 = startTime+"-01";
				var d2 = endTime+"-01";
				date1=new Date(d1.replace(/-/g, "/"));
				date2=new Date(d2.replace(/-/g, "/"));
			}
			if(upgrageDate > date1 || upgrageDate > date2){
				$.alert("${ctp:i18n('performanceReport.queryMain.errorEarly')}");//统计时间不能早于2012-04-01
				return false;
			}
   			var minus = date2-date1;
			// 时间范围不能超过一年
			if(minus>31536000000){
				$.alert("${ctp:i18n('performanceReport.queryMain.errorAYear')}");//时间范围不能超过一年
				return false;
			}
    	}
    	
    	if($("#start_time1").val()!=undefined){
			var st1=new Date($("#start_time1").val().replace(/-/g, "/"));
			var et1=new Date($("#end_time1").val().replace(/-/g, "/"));
			var st2=new Date($("#start_time2").val().replace(/-/g, "/"));
			var et2=new Date($("#end_time2").val().replace(/-/g, "/"));
			
			if(upgrageDate > st1 || upgrageDate > st2 || upgrageDate > et1 || upgrageDate > et2 ){
				$.alert("${ctp:i18n('performanceReport.queryMain.errorEarly')}");
				return false;
			}else if(Date.parse(et1)-Date.parse(st1)<=0 || Date.parse(et2)-Date.parse(st2)<=0){
				if(Constants_report_id===IMPROVEMENTANALYSIS){
					$.alert("${ctp:i18n('performanceReport.queryMain.errorStartTime1')}");
				}else{
					$.alert("${ctp:i18n('performanceReport.queryMain.errorStartTime')}");
				}
				return false;
			}else if(Date.parse(et1)-Date.parse(st1) > 31536000000 || Date.parse(et2)-Date.parse(st2) > 31536000000 ){
				$.alert("${ctp:i18n('performanceReport.queryMain.errorAYear')}");//时间范围不能超过一年
				return false;
			}else{
				return true;
			}
    	}
    	if(startTime == undefined || endTime == undefined){
    		if(Constants_report_id == 8963724485985847875 || (Constants_report_id == -3648914008719078167 &&$('#radio12').attr('checked')=='checked' )
    			|| Constants_report_id == 8187033991580765988){
    			//var d = new Date();
    			var d = new Date(presentTime.replace(/-/,"/"));
    			if(startTime.split('-').length>0){
    				if(startTime.split('-')[0] > d.getFullYear()){
    					$.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
    					return false;
    				}
    			}
    			if(startTime.split('-').length>1){
    				if(startTime.split('-')[0] == d.getFullYear()
    					&& ((startTime.split('-')[1] > d.getMonth()+1 && Constants_report_id != 8187033991580765988)
    						||(startTime.split('-')[1] >= d.getMonth()+1 && Constants_report_id == 8187033991580765988))){
    					$.alert("${ctp:i18n('performanceReport.queryMain.errorTime1')}");
    					return false;
    				}
    			}
    			if(startTime.split('-').length>2){
    				if(startTime.split('-')[0] == d.getFullYear()
    					&& startTime.split('-')[1] == d.getMonth()+1
    					&& startTime.split('-')[2] > d.getDate()){
    					$.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
    					return false;
    				}
    			}
    		}
    		return true;
    	} else {
    		if(Constants_report_id == 8963724485985847875 || (Constants_report_id == 3569160983850797390 && $('#radio12').attr('checked')=='checked' ) ||
    			Constants_report_id == 7728786349204325388 || Constants_report_id == 8187033991580765988 || Constants_report_id == 4832723163238252625 || 
    			Constants_report_id == 516519058127931295 || Constants_report_id == -2118631663956308322 || Constants_report_id == 8841211418965788869){
    			//var d = new Date();
    			var d = new Date(presentTime.replace(/-/,"/"));
    			if(endTime.split('-').length>0){
    				if(endTime.split('-')[0] > d.getFullYear()){
    					$.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
    					return false;
    				}
    			}
    			if(endTime.split('-').length>1){
    				if(endTime.split('-')[0] == d.getFullYear()
    					&& ((endTime.split('-')[1] > d.getMonth()+1 && Constants_report_id != 8187033991580765988)
    						||(endTime.split('-')[1] >= d.getMonth()+1 && 
    						(Constants_report_id == 8187033991580765988 || Constants_report_id == 4832723163238252625 || Constants_report_id == 7728786349204325388)))){
    					if(Constants_report_id == 8187033991580765988 || Constants_report_id == 4832723163238252625 || Constants_report_id == 7728786349204325388){
    						$.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
    					}else{
    						if(Constants_report_id===FLOWOVERTIMESTATISTICS){
    							$.alert("${ctp:i18n('performanceReport.queryMain.errorTime1')}");
    						}else{
    							$.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
    						}
    					}
    					return false;
    				}
    			}
    			if(endTime.split('-').length>2){
    				if(endTime.split('-')[0] == d.getFullYear()
    					&& endTime.split('-')[1] == d.getMonth()+1
    					&& endTime.split('-')[2] > d.getDate()){
    					$.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
    					return false;
    				}
    			}
    		}
    		
    		if($("#flowOverTimeStatus").val() == '1'){//为‘当前待办’ 不进行时间的判断
    			return true;
    		}
			
    		if(startTime.split('-').length==1){
    			startTime +="-01-01";
    			endTime +="-01-01"
    		}else if(startTime.split('-').length==2){
    			startTime +="-01";
    			endTime +="-01"
    		}
    		var d1 = new Date(startTime.replace(/-/g, "/"));   
			var d2 = new Date(endTime.replace(/-/g, "/"));   
			if(Date.parse(d2) - Date.parse(d1) >=0){
				return true;
			}else{
				$.alert("${ctp:i18n('performanceReport.queryMain.errorStartTime')}");
				return false;
			} 	
    	}
    	}catch(e){
    		return true;
    	}
    }
    
    function checkStatus(){
    	if(Constants_report_id==OVERTIMEANALYSIS){
    		var flowstates = document.getElementsByName("flowstate");
    		if(flowstates.length>0){
    			var flowstateFlag=false;
	    		for (var i = 0 ; i < flowstates.length ; i ++) {
	    			if (flowstates[i].checked)
	    			flowstateFlag = true ;
	    		}
	    		if(flowstateFlag==false){
	    			$.alert("${ctp:i18n('performanceReport.queryMain.processState')}");//请选择流程状态
		    		return false;
	    		}else{
	    			return true;
	    		}
    		}else{
    			return true;
    		}
    	}
    	return true;
    }
    
     function processStatType(){
    	var toDep = document.getElementById("toDep");
		var toPer = document.getElementById("toPer");
		var toAccount = document.getElementById("toAccount");
		var statType = document.getElementById("statType");
		var statWhat=document.getElementById("statWhat");
		if(toAccount && toAccount.checked==true && toAccount.value){
			statType.value = toAccount.value;
			statWhat.value=toAccount.value;
		}else if(toDep && toDep.checked==true && toDep.value){
			if(isGroupAdmin==='false'){
				//不是管理员
				statType.value = 'Department';
				statWhat.value='Department';
			}else{
				statType.value = toDep.value;
				statWhat.value=toDep.value;
			}
		}else if(toPer && toPer.checked==true && toPer.value){
			statType.value = toPer.value;
			if(isGroupAdmin==="true"){
				$("#statWhat").val("Account");
			}
		}
    }
    
    //重置
    function resetResult(){
    	if($("#reportId").val()==FLOWSENTANDCOMPLETEDSTATISTICSFORM || $("#reportId").val()==FLOWSENTANDCOMPLETEDSTATISTICSEDOC){
    		$("#reportId").val(FLOWSENTANDCOMPLETEDSTATISTICS);
    	}else if($("#reportId").val()== ONLINEMONTHSTATISTICS){
    		$("#reportId").val(ONLINESTATISTICS);
    	}
    	templateOrginalData = null;
    	elements=null;
    	elements_user=null;
    	elements_colony=null;
    	elements_colonyAccount=null;
    	isReset=true;
    	selectWorkSpace();
    	//OA-38190 去掉对统计的点击事件的重复绑定
        //$("#querySave").click(executeStatistics);
    }
    
    //选择管理范围
    function selectPerson(){
        	//ajax提取查看范围
            var reportAuthManager_ = new reportAuthManager;
            var values = $("#managerRangeIds").val();
    		var txt = $("#managerRange").val();
    		var checkId=$("#reportId").val();
    		reportAuthManager_.findAuthMemberByValueAndReportId($.ctx.CurrentUser.id,$("#reportId").val(),true,{
                success : function(result){
                    $.selectPeople({
                        type : 'selectPeople',
                        panels: getPanels(result),
                        selectType:getSelectType(checkId,result),
                        isCanSelectGroupAccount:false,
                        onlyLoginAccount:true,
                        unallowedSelectEmptyGroup:true,
                        hiddenPostOfDepartment:true,
                        hiddenOtherMemberOfTeam:true,
                        showRecent:true,
                        isAllowContainsChildDept:((checkId==KNOWLEDGESCORESTATISTICS)?true:false),
                        params : {
            		    	text : txt,
            		        value : values
            		    },
                        includeElements : result.join(","),
                        maxSize:getMaxSize(),
                        callback : function(ret) {
                        	
                            $("#managerRange").val(ret.text);
                            $("#managerRangeIds").val(ret.value);  
                            RemoveCheckMsg($("#managerRange"));
                        	$('#querySave').attr('disabled',false);
    			     		$('#querySave').removeClass('common_button_disable');
                        }
                    });
                	}
            });
    }
    
    function isShow(){
    	if(Constants_report_id===KNOWLEDGESCORESTATISTICS){
    		return true;
    	}else{
    		return false;
    	}
    }
    function getPanels(result){
    	 return 'Department,Team,Post,Level,Outworker';
    }
    
    function getSelectType(checkId,result){
         if(personGroupTab=='2'||Constants_report_id==STORAGESPACESTATISTICS){
         	if(Constants_report_id==EVENTSTATISTICS||Constants_report_id==ONLINETIMESTATISTICS){
         		//事项统计,在线时间分析
         		return 'Member';
         	}else{
    	 		return 'Account,Member,Department,Team,Post,Level,Outworker';
    	 	}
    	 }else{
    	 	return ((checkId==KNOWLEDGESCORESTATISTICS)?'Account,Member,Department,Team,Post,Level,Outworker':'Member');
    	 }
    }
    
    function getMaxSize(){
    	if(Constants_report_id==FLOWSENTANDCOMPLETEDSTATISTICS||Constants_report_id==FLOWOVERTIMESTATISTICS||Constants_report_id==PLANRETURNSTATISTICS
    	||Constants_report_id==WORKDAILYSTATISTICS||Constants_report_id==EVENTSTATISTICS||Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==MEETINGJOINSTATISTICS
    	||Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS)
    	{
    		 var myReport=$("#myReport").parent().attr('class');
    		 var reportCategory=$("#reportCategory").val();
    		 //var groupReport=$("#groupReport").parent().attr('class');
    		 if(myReport=='current'||reportCategory=='1'){
    		 	return 1;
    		 }else{
    		 	if(Constants_report_id==EVENTSTATISTICS||Constants_report_id==ONLINETIMESTATISTICS){
    		 		return 1;
    		 	}
    		 }
    	}else{
    		if(isPortal=='true'){
    			//栏目选人不得超过50人
    			return 50;
    		}
    	}
    }
    
    function onlineStatisticsChange(){
    	if($("input[name='option']:checked").val()=="1"){
    	  $("#start_time").attr("disabled",false);
	    	  if($("#start_time").val()==""){
	    	  $("#start_time").val(currentYearMonth());
	    	  }
   		  $(".calendar_icon").show();
   		 $("#reportId").val(ONLINEMONTHSTATISTICS);
   		
    	}else{
    	  resetResult();
    	 /* $("#start_time").attr("disabled",true);
    	  $("#start_time").val("");
   		  $(".calendar_icon").hide();*/
    	  $("#reportId").val(ONLINESTATISTICS);    		
    	}
    }
    
        //计划回复报表onchange事件
    function planReturnChange(){
    	var reportCategory=$("#reportCategory").val();
    	//OA-79859
    	if(personGroupTab=='1' || personGroupTab=='2'||reportCategory=='1'){
    		$("#planType").change(timeIntervalChange);
    	}
    	timeIntervalChange();
    }
    //已发已办change事件
    function SentAndCompletedChange(){
    	$(".mycal").each(function(){$(this).compThis();});
      //  var date=new Date();
      	var date = new Date(presentTime.replace(/-/,"/"));
        date.setDate(1);
        //当前月之前的6个月
        date.setMonth(date.getMonth() - 1);
    	var fromDate=date.print("%Y-%m");
	    $("#start_time").val(timeMonthCal(7));
	    $("#end_time").val(fromDate);
    	$(":checkbox").attr("checked",true);
    	$("#flowType").change(flowTypeChange);    	
    	if($("#reportId").val()==FLOWSENTANDCOMPLETEDSTATISTICSFORM){
    		$("#flowContentReplace").html("<th nowrap='nowrap'><label class='margin_r_10' for='text'>${ctp:i18n('performanceReport.queryMain_js.mostUsed')}</label></th>" +flowTemplateNum()+"<td width='60' nowrap='nowrap'>${ctp:i18n('performanceReport.queryMain_js.templetes')}</td>");  		
    	}
    }
    //根据流程类型改变后面的显示
    function flowTypeChange(){
    	if($("#flowType").val()==0){
    		$("#flowContentReplace").html("<th nowrap='nowrap'><label class='margin_r_10' for='text'>&nbsp;</label></th>" +flowContentType());
    		$(":checkbox").attr("checked",true);
    		$("#reportId").val(FLOWSENTANDCOMPLETEDSTATISTICS);
    		//$("#queryCondition table").eq(0).attr('width','80%');
    	}else if($("#flowType").val()==1){
			var flowTNum=$("#flowTemplateNum").val();
    		$("#flowContentReplace").html("<th nowrap='nowrap'><label class='margin_r_10' for='text'>${ctp:i18n('performanceReport.queryMain_js.mostUsed')}</label></th><td><table width='100%'><tbody><tr>" +flowTemplateNum()+"<td nowrap='nowrap'>${ctp:i18n('performanceReport.queryMain_js.templetes')}</td></td></tr></tbody></table>");  
			if(!isNaN(parseInt(flowTNum))&&parseInt(flowTNum)!=''){
    			$("#flowTemplateNum").val(flowTNum);	
    		}
    		$("#reportId").val(FLOWSENTANDCOMPLETEDSTATISTICSFORM);
    		//$("#flowContentReplace").html('');
    		//$("#queryCondition table").eq(0).attr('width','60%');
    	} else{
    		$("#flowContentReplace").html("<th nowrap='nowrap'><label class='margin_r_10' for='text'>&nbsp;</label></th>" +edocFlowContentType());
	    	$(":checkbox").attr("checked",true);
    		$("#reportId").val(FLOWSENTANDCOMPLETEDSTATISTICSEDOC);
    		//$("#queryCondition table").eq(0).attr('width','80%');
    	}
    }
    //流程超期初始化赋值
    function flowOverTimeChange(){
    	$(".mycal").each(function(){$(this).compThis();});
      //  var date=new Date();
        var date = new Date(presentTime.replace(/-/,"/"));
        //当前月之前的6个月
        //这里不用减去1，结束日期也不用加1
        //date.setMonth(date.getMonth() - 1);
        date.setMonth(date.getMonth());
    	var fromDate=date.print("%Y-%m");
    	//fromDate=modify(fromDate);
	    $("#start_time").val(timeMonthCal(6));
	    $("#end_time").val(fromDate);
    	$("#flowType").change(overTimeChange);
    	$("#flowOverTimeStatus").change(overTimeStatusChange);
    	if(isPortal=='true'){
    		$("#start_time").css("width","100px");
    		$("#end_time").css("width","100px");
    		$("#flowOverTimeDateId td[nowrap='nowrap']").each(function(){$(this).attr("width","")});
    	}
  		//$("#reportId").val(FLOWOVERTIMESTATISTICS); 
    	overTimeChange();
    }
    //结束日期增加一个月
    function modify(date){
    	var time=date.split('-');
    	var day=parseInt(time[1])+1;
    	return time[0]+"-0"+day;
    }
    //流程超期onchange事件
  function overTimeChange(){
    var flowType=$("#flowType").val();
  	if(flowType==0){
  		$("#reportId").val(FLOWOVERTIMESTATISTICS); 
  	}else if(flowType==1){
  		$("#reportId").val(FLOWOVERTIMESTATISTICSFORM);		
  	} else if(flowType==2){
  		$("#reportId").val(FLOWOVERTIMESTATISTICSEDOC);	
  	}  	
  }
  var startTime;
  var endTime;
  //流程超期状态onchange事件
  function overTimeStatusChange(){
    var flowOverTimeStatus=$("#flowOverTimeStatus").val();
    if(isMore!='true'){
		if(flowOverTimeStatus==1){
		 	$("#start_time").val("");
		 	$("#end_time").val("");
		 	$("#start_time").attr("disabled","disabled");
		 	$("#end_time").attr("disabled","disabled");
		 	$(".calendar_icon").hide();
		}else{
		 	$("#start_time").attr("disabled",false);
		 	$("#end_time").attr("disabled",false);
		 	$("#flowOverTimeDateId").html('');
		 	$("#flowOverTimeDateId").append(getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+getTimeInterval("%Y-%m",true));
	     	flowOverTimeChange();
		}
	}else{
		if(flowOverTimeStatus==1){
		 	$("#start_time").val("");
		 	$("#end_time").val("");
		 	$("#start_time").attr("disabled","disabled");
		 	$("#end_time").attr("disabled","disabled");
		 	$(".calendar_icon").hide();
	 	}
	}
  }
  
  //日期计算：返回当前月之前的月份
  function timeMonthCal(num){
	  //var date = new Date();
	  var date = new Date(presentTime.replace(/-/,"/")); 
	  var curYear = date.getFullYear();  
	  var curMonth = date.getMonth() + 1;  
	  for(var i=1;i<num;i++){
		  if (curMonth == 1) {  
		        curYear--;  
		        curMonth = 12;  
		    } else {  
		        curMonth--;  
		    }  
	  }
	  return curYear+"-"+(curMonth<10?"0"+curMonth:curMonth);
  }
  //日期计算：返回当前年月
  function currentYearMonth(){
	  //var date = new Date();
	  var date = new Date(presentTime.replace(/-/,"/")); 
	  var curYear = date.getFullYear();  
	  var curMonth = date.getMonth() + 1;  
	  return curYear+"-"+(curMonth<10?("0"+curMonth):curMonth);
  }
  //获取当前月第一天和最后一天
  function getFirstAndLastDay(){
  	var date = new Date(presentTime.replace(/-/,"/"));
	  var year=date.getFullYear();
	  var month=date.getMonth()+1;
	  var   firstdate = year + '-' + month + '-01';
      var  day = new Date(year,month,0); 
      var lastdate = year + '-' + month + '-' + day.getDate();
      var array=new Array(firstdate,lastdate);
      return array;
  }
  
   //执行日期验证
function timeCheck(obj){
	var checkReport=$("#reportId").val();
	var start_time=$("#start_time").val();
	var end_time=$("#end_time").val();
	if(checkReport==ONLINEMONTHSTATISTICS||checkReport==ONLINESTATISTICS||checkReport==KNOWLEDGEINCREASESTATISTICS){
		if(start_time>currentYearMonth()){
			 $.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
			 $("#start_time").val("");
			 return false;
		}
		if(end_time>currentYearMonth()){
			 $.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");
			 $("#end_time").val("");
			 return false;
		}
	}
	if(checkReport==FLOWSENTANDCOMPLETEDSTATISTICS||checkReport==FLOWSENTANDCOMPLETEDSTATISTICSFORM||checkReport==FLOWSENTANDCOMPLETEDSTATISTICSEDOC){//||checkReport=="516519058127931295"||checkReport=="-2118631663956308322"
		if(start_time>=currentYearMonth()){
			 $.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");//不可选择当前月及当前月之后的月份，请重新输入
			 $("#start_time").val("");
			 return false;
		}
		if(end_time>=currentYearMonth()){
			 $.alert("${ctp:i18n('performanceReport.queryMain.errorTime')}");//不可选择当前月及当前月之后的月份，请重新输入
			 $("#end_time").val("");
			 return false;
		}
	}
	if(!$.isNull(start_time)&&!$.isNull(end_time)){
		if(start_time>end_time){
			 $.alert("${ctp:i18n('performanceReport.queryMain.errorStartTime')}");//开始时间不能大于结束时间，请重新输入!
			 $("#start_time").val("");
			 return false;
		}
	}
	/*if(checkReport==ONLINEMONTHSTATISTICS&&!$.isNull(PRODUCTINSTALLDATE)){		
		var proYear=PRODUCTINSTALLDATE.split("-")[0];
		var proMonth=PRODUCTINSTALLDATE.split("-")[1];	
	if(!$.isNull(start_time)){
		if(start_time+"-01"<PRODUCTINSTALLDATE){
			 $.alert("不能统计"+proYear+"年"+proMonth+"月之前的数据!");
			 $("#start_time").val();
			 return false;
		}
		if(end_time+"-01"<PRODUCTINSTALLDATE){
			 $.alert("不能统计"+proYear+"年"+proMonth+"月之前的数据!");
			 $("#end_time").val();
			 return false;
		}
	}
  }*/
}

/**
 * 显示流程模版流程图
 * @tWindow 目标窗口window对象
 * @ptemplateId 流程模版ID
 * @vWindow 值回写window对象
 */
function showWFTDiagram(tWindow,ptemplateId,vWindow){
  var returnValueWindow= tWindow;
  if(vWindow){
    returnValueWindow= vWindow;
  }
  if(typeof(workfowFlashDialog) != "undefined" && workfowFlashDialog){
    workfowFlashDialog.isHide = false;
    workfowFlashDialog.close();
  }
  var dwidth= $(tWindow).width();
  var dheight= $(tWindow).height();
  workfowFlashDialog = $.dialog({
    isHide : true,
    url : '<c:url value="/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=true&processId="/>'+ptemplateId,
    width :  dwidth-30,
    height :  dheight-100,
    title : ' ',
    transParams : {
      dwidths: dwidth,
      dheights: dheight-20,
      returnValueWindow:returnValueWindow
    },
    minParam:{show:false},
    maxParam:{show:false},
    buttons : [ {
      text : "${ctp:i18n('workflow.designer.page.button.close')}",
      handler : function() {
        if(!$.browser.msie){
          workfowFlashDialog.close();  
        }else{
          workfowFlashDialog.hideDialog();
        }
      }
    } ],
    targetWindow: tWindow
  });
}

    function changeOperationType(){
		var theForm = document.getElementById("queryCondition");
		var operationTypeArr = $("input[name='operationType']");
		var templeteId = document.getElementById("templeteId");
	    for(var i=0; i<operationTypeArr.length; i++){
			if(operationTypeArr[i].checked){
				var operationType = operationTypeArr[i].value;
				var isTemplate = operationType == "template";
				document.getElementById("templeteName").value = "点击选择";
				document.getElementById("templeteName").disabled = !isTemplate;
				templeteId.value = isTemplate ? "" : "${!isGroupAdmin and !isAdministrator ? '1': '-1'}";	
			}
		}
	}
</script>
</head>
<body>
</body>
</html>