var parentWindowData;
var parentDialog;
var isValidate = false;
var stageList=new Array();
var stageAddList=new Array();
var stageUpdateList=new Array();
var stageDeleteList=new Array();
var ajaxProjectConfig = new projectConfigManager();
var projectAjax = new projectConfigManager();

function init(){
	parentDialog = window.parentDialogObj['newProjectWin'] || window.parentDialogObj['editProjectWin'];
	parentWindowData = window.dialogArguments;
	if("update" == parentWindowData.action){
		$("#stateProcessTh").removeClass("display_none");
		$("#stateProcessTr").removeClass("display_none");
		if(""!=$("#initPashList").val()){
			stageList=$.parseJSON($("#initPashList").val());
		}
	}else if("view" == parentWindowData.action){
		if(!(2 == parentWindowData.selectData.projectIState
			&& parentWindowData.selectData.canEditorDel)){
			$("#restarteProject").removeClass("common_button");
			$("#restarteProject").removeClass("common_button_gray");
			$("#restarteProject").addClass("display_none");
		}
	}
	$("#projectName,#begintime,#closetime").addClass("validate");
}
/**
 * 选择人员
 */
function selectProjectPersion(inputName){
	
	var values = $("#"+inputName);
	var txt = $("#"+inputName+"_text");
	$.selectPeople({
        type : 'selectPeople',
        panels : 'Department,Outworker',
        selectType : 'Member',
        hiddenOtherMemberOfTeam: true,
        maxSize: getMaxPersionSize(inputName),
        minSize: getMinPersionSize(inputName),
        excludeElements : getExcludeElements(inputName),
	    params : {
	    	text : txt.val(),
	        value : values.val()
	    },
	    callback : function(ret) {
		  txt.val(ret.text);
	      values.val(ret.value);
	    }
	});
}

/**
 * 参看人员权限解释
 */
function showDescription(){
	var dialog = $.dialog({
            id : 'description',
            url : _ctxPath + '/genericController.do?ViewPage=project/nodeDescription',
            width : 600,
            height : 500,
            title : $.i18n('project.toolbar.comment.label'),
            targetWindow : getCtpTop(),
            buttons : [  {
                text : $.i18n('common.button.close.label'),
                handler : function() {
                    dialog.close();
                }
            } ]
        });
}
/**
 * 选择模板
 */
function setProjectTemplete(isSpace){
	var selectTemplateIds = $("#templates").val();
	var projectTempleteWin =  $.dialog({
		id: "projectTempleteWin",
		title: $.i18n('project.body.templates.label.select'),
		url: _ctxPath + "/template/template.do?method=templateChooseMul&moduleType=1,2&isMul=true&scope=MemberUse&_tids="+selectTemplateIds,
		width: 600,
        height: 500,
        isIframe:true,
        isDrag:false,
        targetWindow:getA8Top(),
	    buttons:[{
	    	id:'ok',
	        text: $.i18n('common.button.ok.label'),
	        isEmphasize:true,
	        handler: function(){
	        	try{
		    		var rv = projectTempleteWin.getReturnValue();
		    		var templeteIds = rv.ids.split(",");
		    		var templeteNames = rv.names;
		    		var ids = "";
		    		var names = "";
		    		for(var i = 0; i < templeteIds.length; i++){
		    			if(templeteIds[i] !=null && templeteIds[i]!=""){
		    				ids += templeteIds[i] + ",";
			    			names += templeteNames[i] + "、";
		    			}
		    		}
		    		ids = ids.substring(0, ids.length - 1);
		    		if(isSpace == 'true'){
		    			$.ajax({
							async: false,
							type: "POST",
							url: projectUrl + "?method=setTemplete",
							data: {"projectId": $("#hiddenProjectId").val(), "templates": ids},
							success: function(){
								projectTempleteWin.close();
								window.location.reload(true);
							}
						});
		    		}else{
		    			paramValue = ids;
			    		$("#templates").val(ids);
			    		$("#templatesWeb").val(names.substring(0, names.length - 1));
			    		projectTempleteWin.close();
		    		}
	        	}catch(e){
	        		projectTempleteWin.close();
	        	}
	        }
	    },
	    {
			id:'cancel',
	        text: $.i18n('common.button.cancel.label'),
	        handler: function(){
	    		projectTempleteWin.close();
	        }
		}]
	});
}
/**
 *选择人员上限
 */
function getMaxPersionSize(inputName){
	if(inputName == "managers" || inputName == "assistant" || inputName == "charges"){
		return 5;
	} else {
		return -1;
	}
}
/**
 *选择人员下限
 */
function getMinPersionSize(inputName){
	if(inputName == "managers"){
		return 1;
	}else{
		return 0;
	}
}
/**
 * 获取已选择人员
 */
function getExcludeElements(inputId){
	var hiddens = $("input:hidden");
	var excludeElements="";
	for(var i=0;i<hiddens.length;i++){
		var val=$(hiddens[i]).val();
		if(val.indexOf("Member") >= 0 && $(hiddens[i]).attr("id") != inputId){
			excludeElements+=$(hiddens[i]).val()+",";
		}
	}
	return excludeElements.substring(0,excludeElements.length-1); 
}
/**
 * 新建\修改\删除项目阶段
 */
 function stageOperation(type){
 	var index = 0;
 	var phaseId;
 	var title;
 	if('delete' == type){
		deletePhase();
		return;
 	}
 	if($("#begintime").val() == "" || $("#closetime").val() == ""){
 		$.alert({
 			'msg':$.i18n('project.phase.startdate.cannot.null'),
	 		ok_fn:function(){
	 			changeTab();
	 		}
 		});
 		return;
 	}
 	if(compareDate($("#begintime").val(),$("#closetime").val())>0){
 		$.alert({
 			'msg':$.i18n('project.phase.begindate.cannot.late.enddate'),
 			ok_fn:function(){
	 			changeTab();
	 		}
 		});
 		return;
 	}
 	
 	if('add' != type){
 		var trNum = $("#stageList").find('input[type="checkbox"]:checked').length;
 		if(trNum<1){
 			$.alert($.i18n("project.please.choose.on.data"));
 			return;
 		}else if(trNum>1){
 			$.alert($.i18n("project.please.choose.one.data.only"));
 			return;
 		}
 		$.each($("#stageList").find('input[type="checkbox"]'), function(i,item){
 			if($(item).attr("checked")=="checked"){
 				index=i;
 				phaseId=$(item).val();
 			}
 		});
 		title = $.i18n('project.body.phase.modify.label');
 	}else{
 		title = $.i18n('project.body.phase.label');
 	}
	var projectStageWin =  $.dialog({
		id: "projectStageWin",
		title: title,
		url: _ctxPath + "/project/project.do?method=displayProjectStage",
		width: 600,
        height: 350,
        isIframe:true,
        isDrag:false,
        targetWindow:getA8Top(),
        transParams:{	pwindow:window,
        				affterAddPhase:affterAddPhase,
        				index:index,
        				beginTime:$("#begintime").val(),
        				endTime:$("#closetime").val(),
        				stageList:stageList},
	    buttons:[{
	    	id:'ok',
	        text: $.i18n('common.button.ok.label'),
	        isEmphasize:true,
	        handler: function(){
	        	try{
		    		var phase = projectStageWin.getReturnValue();
		    		affterAddPhase(phase ,index ,projectStageWin);
	        	}catch(e){
	        		projectStageWin.close();
	        	}
	        }
	    },
	    {
			id:'cancel',
	        text: $.i18n('common.button.cancel.label'),
	        handler: function(){
	        	projectStageWin.close();
	        }
		}]
	});
 }
 function selectAll(obj){
 	if($(obj).attr("checked") == "checked"){
 		$("#stageList").find('input[type="checkbox"]').attr("checked","checked");
 		$($("#stageList").find('input[type="checkbox"]')[0]).removeAttr("checked");
 	}else{
 		$("#stageList").find('input[type="checkbox"]:checked').removeAttr("checked");
 	}
 }
 function affterAddPhase(phase ,index ,projectStageWin){
 	if(phase != null){
 		backFilingArray();
 		var newPhase=new Object();
 		for(var p in phase){
 			newPhase[p]=phase[p];
 		}
		displayProjectStage(newPhase ,index);
		hiddenProjectStage(newPhase ,index);
		projectStageWin.close();
	}
 }
 /**
 * 保存项目
 */
 function OK(){
 	$("#projectName").val($.trim($("#projectName").val()));
 	$("#projectNum").val($.trim($("#projectNum").val()));
 	
 	if(compareDate($("#begintime").val(), $("#closetime").val()) > 0){
 		$.alert({
 			'msg':$.i18n('project.begindate.cannot.late.enddate'),
 			ok_fn:function(){
 				changeTab();
 			}
 		});
 		return;
 	}
 	if($.isNull($("#projectType").val())){
 		$.error($.i18n("project.error.has.nontypes"));
 		return;
 	}
 	for(var i = 0; i < stageList.length; i++){
 		if(compareDate(stageList[i].phaseBegintime, $("#begintime").val()) < 0){
			$.alert({
 				'msg':$.i18n("project.phase.startdate.than.project.startdate"),
 				ok_fn:function(){
 					changeTab();
 				}
 			});
			return;
		}else if(compareDate(stageList[i].phaseBegintime, $("#closetime").val()) > 0){
			$.alert({
 				'msg':$.i18n("project.phase.startdate.than.project.enddate"),
 				ok_fn:function(){
 					changeTab();
 				}
 			});
			return;
		}
		if(compareDate(stageList[i].phaseClosetime, $("#begintime").val()) < 0){
			$.alert({
 				'msg':$.i18n("project.phase.enddate.than.project.startdate"),
 				ok_fn:function(){
 					changeTab();
 				}
 			});
			return;
		}else if(compareDate(stageList[i].phaseClosetime, $("#closetime").val()) > 0){
			$.alert({
 				'msg':$.i18n("project.phase.enddate.than.project.enddate"),
 				ok_fn:function(){
 					changeTab();
 				}
 			});
			return;
		}
 	}
 	if($("#page1").hasClass("current") && $("#formObj").validate()){
		isValidate = true;
 	}else if(!$("#page1").hasClass("current")){
 		isValidate = true;
 	}else{
 		isValidate = false;
 	}
	if(isValidate){
		var exsitType = ajaxProjectConfig.isExsitProjectTypeById($("#projectType").val());
		if(false == exsitType){
			var alert =$.alert({
				'msg': $.i18n("project.type.deleted"),
        		ok_fn: function () {
					parentWindowData.newProject(parentDialog);
				}
			});
			return;
        }
		var isExsit = ajaxProjectConfig.isExsitSameProjectNameOrNumber($("#projectName").val(),$("#projectNum").val(),$("#projectId").val());
		if(""!=isExsit){
			$.alert(isExsit);
			return;
		}
		var opeaType = getUrlPara("type");
		if (opeaType != "update") {
			var isRepeatTeam = ajaxProjectConfig.isRepeatTeam($("#projectName").val());
			if (isRepeatTeam == true || isRepeatTeam == "true") {
				$.alert("已存在相同名称的组，请重新输入！");
				return;
			}
		}
		$("#projectTypeName").val($("#projectType option[value='"+$("#projectType").val()+"']").text());
    	if("add" == parentWindowData.action){
			$("#formObj").attr("action", _ctxPath+"/project/project.do?method=saveProject");
			doFormSubmit();
		}else if("update" == parentWindowData.action){
			$("#formObj").attr("action", _ctxPath+"/project/project.do?method=updateProject");
			var projectProcessOld = $("#projectProcessOld").val();
			var projectProcessNew = $("#projectProcess").val();
			if(100 == projectProcessNew && 0 == $("#projectState").val() && projectProcessNew != projectProcessOld){
        		var confirm =$.confirm({
        			'msg': $.i18n("project.create.processState"),
	        		ok_fn: function () {
	        			$("#projectState").val(2);
	        			doFormSubmit();
					 },
	        		cancel_fn:function(){
	        			doFormSubmit();
					}
				});	
        	}else{
        		doFormSubmit();
        	}
		}else{
			return ;
		}
	}
 }
 
 function doFormSubmit(){
 	var proce = $.progressBar();
	 if(parentDialog){
			parentDialog.disabledBtn('ok');
		}
 	if("" == $("#phaseAddList").val()){
		$("#phaseAddList").val($.toJSON(stageAddList));
	}
	if("" == $("#phaseUpdateList").val()){
		$("#phaseUpdateList").val($.toJSON(stageUpdateList));
	}
	if("" == $("#phaseDeleteList").val()){
		$("#phaseDeleteList").val($.toJSON(stageDeleteList));
	}
	//获取新的项目背景
	var oldBackGround = $("#backGround").val();
	var backGroundList =["#006aff","#15a4fa","#0dab60","#06a8a9","#dd0865","#18a10f"];
	var newBackGround  = "#006aff";
	for(colors in backGroundList) {
		if(backGroundList[colors]==oldBackGround){
			for(var i=0;i<backGroundList.length;i++){
				if(oldBackGround == backGroundList[i]){
					newBackGround = backGroundList[i+1];
				}
			}
		}
	}
	//获取选中的当前项目阶段--用以回填选中信息
	var currentPhaseId = $("#currentPhaseId  option:selected").val();
	//提交
	var isChecked = parentDialog.getObjectById("continueAdd").is(":checked");
	if(isChecked){
		$("#formObj").jsonSubmit({
			callback : function() {
				proce.close();
				parentDialog.enabledBtn("ok");
			}
		});
		//清空下拉框
		$("#currentPhaseId").find("option").remove();
		//重新赋值项目阶段ID
		for(var p=0;p< stageList.length;p++){
			var old_slid = stageList[p].phaseId;
			stageList[p].phaseId = projectAjax.getUUID().uuid;
			if(old_slid !=null){
				$("input[value='"+old_slid+"']").val(stageList[p].phaseId);
			}
			if(stageList[p].phaseName != null ){
				$("#currentPhaseId").append("<option value='"+stageList[p].phaseId+"'>"+stageList[p].phaseName+"</option>");
			}
			if(currentPhaseId == old_slid){
				$("#currentPhaseId option[value='"+stageList[p].phaseId+"']").attr("selected","selected");
			}
		}
		$("#phaseAddList").val($.toJSON(stageList));
		$("#initPashList").val($.toJSON(stageList));
		//赋予新的项目背景色
		$("#backGroundDiv").attr("style","background:"+newBackGround);
		$("#backGround").val(newBackGround);
		//切换到页签-“基础信息”
		doValidate(1);
	} else {
		$("#formObj").jsonSubmit({
			callback : function() {
				proce.close();
				parentWindowData.callBack(parentDialog);
			}
		});
	}
 }
 //增加、修改前台展现
 function displayProjectStage(phase ,index){
 	if(0 == index){
	 	var newPhase = $("#demo").clone();
	 	newPhase.removeClass("display_none");
	 	newPhase.removeAttr("id");
	 	var phasetd= newPhase.children();
	 	$(phasetd[0]).find("input").val(phase.phaseId);
	 	$(phasetd[1]).text(phase.phaseName);
	 	$(phasetd[2]).text(phase.phaseBegintime+" ~ "+phase.phaseClosetime);
	 	newPhase.appendTo($("#stageList"));
	 	
	 	$("#currentPhaseId").append("<option value='"+phase.phaseId+"'>"+phase.phaseName+"</option>");
	 	$("#phaseIdTitle").removeClass("display_none");
	 	$("#phaseIdDiv").removeClass("display_none");
 	}else{
 		$("#displayStage tbody tr:eq("+index+") td:eq(1)").text(phase.phaseName);
 		$("#displayStage tbody tr:eq("+index+") td:eq(2)").text(phase.phaseBegintime+" ~ "+phase.phaseClosetime);
 		
 		$("#currentPhaseId option[value='"+phase.phaseId+"']").text(phase.phaseName);
 	}
 }
 //设置增加、修改隐藏数据
 function hiddenProjectStage(phase ,index){
 	if(0 == index){
 		stageList.push(phase);
 	}else{
 		stageList[index-1]=phase;
 	}
 	$("#initPashList").val($.toJSON(stageList));
 	
 	if(phase.isAdd){
 		var indexAdd = isExsitProjectPhase(stageAddList,phase);
 		if(-1 == indexAdd){
 			stageAddList.push(phase);
 		} else {
 			stageAddList[indexAdd]=phase;
 		}
 		$("#phaseAddList").val($.toJSON(stageAddList));
 	} else {
 		var indexUpdate = isExsitProjectPhase(stageUpdateList,phase);
 		if(-1 == indexUpdate){
 			stageUpdateList.push(phase);
 		} else {
 			stageUpdateList[indexUpdate]=phase;
 		}
 		$("#phaseUpdateList").val($.toJSON(stageUpdateList));
 	}
 }
 //删除操作
 function deletePhase(){
 	var trNum = $("#stageList").find('input[type="checkbox"]:checked').length;
	if(trNum<1){
		$.alert($.i18n("project.please.choose.on.data"));
		return;
	}else{
		$.confirm({	
			'msg': $.i18n("project.grid.select.delete.phase.label"),
    		ok_fn: function () {
    			var index=0;
    			var promptInfo="";
    			var phaseObjList=new Array();
    			$.each($("#stageList").find('input[type="checkbox"]:checked'), function(i,item){
					//ajax验证阶段下是否包含文档,新框架不能使用
					//var v = ajaxDocHierarchy.hasDocsInProject($(item).val());
					//根据项目节点的ID查询项目阶段下是否存在文档
					var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "hasDocsInProject", false);
					requestCaller.addParameter(1, "long", $(item).val());
					var rv = requestCaller.serviceRequest();
					var currentIndex = $("#stageList").find('input[type="checkbox"]').index($(item));
					if("true" == rv){
						promptInfo+=stageList[currentIndex-1].phaseName+$.i18n("project.period.exist.doc")+"</br>";
					}
					phaseObjList.push({"index":currentIndex,"item":$(item).val()});
				});
				
				if(!$.isNull(promptInfo)){
					$.confirm({
						'msg': promptInfo,
			    		ok_fn: function () {
			    			deleteSelectPhase();
						},
			    		cancel_fn:function(){
			    		}
					});
				}else{
					deleteSelectPhase();
				}
			 },
    		cancel_fn:function(){
    		}
		});
 	}
 }
 
 function deleteSelectPhase(){
 	$.each($("#stageList").find('input[type="checkbox"]:checked'), function(i,item){
 		var index=$("#stageList").find('input[type="checkbox"]').index($(item));
 		if(stageList[index-1].isAdd){
			setDeletePhase(index, $(item).val());
		}else{	
			//ajax验证阶段下是否包含文档,新框架不能使用
			//var v = ajaxDocHierarchy.hasDocsInProject($(item).val());
			//根据项目节点的ID查询项目阶段下是否存在文档
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "hasDocsInProject", false);
			requestCaller.addParameter(1, "long", $(item).val());
			var rv = requestCaller.serviceRequest();
			var currentIndex = $("#stageList").find('input[type="checkbox"]').index($(item));
			setDeletePhase(currentIndex, $(item).val());
		}
	});
 }
 function setDeletePhase(index,phaseId){
 	//设置隐藏数据
	if(!stageList[index-1].isAdd){
		stageDeleteList.push(phaseId);
		$("#phaseDeleteList").val($.toJSON(stageDeleteList));
		var indexUpdate = isExsitProjectPhase(stageUpdateList,phaseId);
		if(-1 != indexUpdate){
			stageUpdateList.splice(indexUpdate,1);
			$("#phaseUpdateList").val($.toJSON(stageUpdateList));
		}
	}else{
		var indexAdd = isExsitProjectPhase(stageAddList,phaseId);
		if(-1 != indexAdd){
			stageAddList.splice(indexAdd,1);
			$("#phaseAddList").val($.toJSON(stageAddList));
		}
	}
	stageList.splice(index-1,1);
	$("#initPashList").val($.toJSON(stageList));
	
	//处理前台展现
	$("#displayStage tbody tr:eq("+index+")").remove();
	$("#currentPhaseId option[value='"+phaseId+"']").remove();
	if(0 == stageList.length){
		$("#phaseIdTitle").addClass("display_none");
		$("#phaseIdDiv").addClass("display_none");
	}
 }
 
/**
 * 是否存在项目阶段
 */
function isExsitProjectPhase(array ,phase){
	for(var i=0;i<array.length;i++){
		if((undefined == phase.phaseId && array[i].phaseId == phase)
			|| array[i].phaseId == phase.phaseId){
			return i;
		}
	}
	return -1;
}
//重启项目
function restarteProject(){
	var obj = new Object();
    obj.id = $("#projectId").val();
    obj.projectIState=0;
    obj.canEditorDel=true;
	parentWindowData.callBack(obj, parentDialog)
}
/**
 * 调用调试面板
 */
function doChangeColor(){
	new MxtColorPanel({
        targetId: "backGroundDiv",
        onChange: function(p){
        	$("#backGroundDiv").attr("style","background:"+p.listColor);
            $("#backGround").val(p.listColor);
        }
    });
}

function changeTab(){
	$("#page2").removeClass("current");
	$("#page3").removeClass("current");
	$("#page1").addClass("current");
	$("#tab2_div").addClass("hidden");
	$("#tab3_div").addClass("hidden");
	$("#tab1_div").removeClass("hidden");
}

function backFilingArray(){
	try{
		$.toJSON(stageList);
	}catch(e){
		stageList=$.parseJSON($("#initPashList").val());
	}
	try{
		$.toJSON(stageAddList);
	}catch(e){
		stageAddList=$.parseJSON($("#phaseAddList").val());
	}
	try{
		$.toJSON(stageUpdateList);
	}catch(e){
		stageUpdateList=$.parseJSON($("#phaseUpdateList").val());
	}
	try{
		$.toJSON(stageDeleteList);
	}catch(e){
		stageDeleteList=$.parseJSON($("#phaseDeleteList").val());
	}
}

function doValidate(num){
	if($("#page1").hasClass("current")){
		if($("#formObj").validate()){
			isValidate = true;
			$("#page1").removeClass("current");
			$("#tab1_div").addClass("hidden");
		}else{
			return;
		}
	}else if($("#page2").hasClass("current")){
		$("#page2").removeClass("current");
		$("#tab2_div").addClass("hidden");
	}else if($("#page3").hasClass("current")){
		$("#page3").removeClass("current");
		$("#tab3_div").addClass("hidden");
	}
	$("#page"+num).addClass("current");
	$("#tab"+num+"_div").removeClass("hidden");
}