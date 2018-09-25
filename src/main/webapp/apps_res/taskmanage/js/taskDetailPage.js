/**
*调整附件和关联文档的高度和其他样式
*/
function setAttachCss(){
	//设置附件div最大高度(自适应),去掉滚动条
	$("#attachmentArea").css({"max-height":"1500px","overflow":"hidden","height":""});
	//设置每个关联文档的高度
	$("#attachment2Areaposition1 .attachment_block ").css({"height":"28px","padding-left":"10px"});
	$("#attachmentArea .attachment_block").css({"font-size":"12px","padding-left":"10px"});
	$("#attachmentTR").css({"color":"#8d8d8d","font-size":"12px","height":"20px","padding-top":"5px"});
	$("#attachment2NumberDivposition1").parent().css({"color":"#8d8d8d","height":"20px","font-size":"12px","padding-top":"5px"});
	$("#attachmentArea .attachment_block").css("color","gray");
	$("#attachment2Areaposition1 .attachment_block a,#task_source a").css("color","gray").live("mouseover",function(){
    	$(this).css("color","#318ed9");
    }).live("mouseout",function(){
    	$(this).css("color","gray");
    });
}

var taskMenuClass=new TaskMenuClass();

function loadMenu(){
	taskMenuClass.initMenu();
}

/*
*任务详情菜单对象
*/
function TaskMenuClass(){};
/*
*初始化菜单
*/
TaskMenuClass.prototype.initMenu=function(){
	if(from!=""){
		getCtpTop().fromType=from;
	}
	taskMenuClass.meun=[{
		name: $.i18n('taskmanage.update.label'),//修改
		handle: function (json) {
			taskMenuClass.url= _ctxPath + "/taskmanage/taskinfo.do?method=updateTask&id=" + taskId+"&projectId="+$("#projectId").val()
			+ "&optype=update&from=Edit";
			taskMenuClass.operate="modify";
			taskMenuClass.callBack=refreshTaskDetailAndList;
			taskMenuClass.title = $.i18n('taskmanage.modify.task.js');
			getCtpTop().operationType=taskMenuClass.operate;
			taskMenuClass.bottomHTML = '<div class="common_checkbox_box clearfix" style="display:none"><label class="margin_r_10 hand" for="continuous_add"><input id="continuous_add" class="radio_com" name="continuous" value="0" type="checkbox">&nbsp;&nbsp;'+ $.i18n("taskmanage.add.continue") +'</label></div>';
			//调用任务编辑方法
			taskMenuClass.newTask();
		}
	}];
	if($("#isNew").val()=="true"&&$("#task_finish_rate_data").val()<100 &&!($("#task_status_num").val()==4||$("#task_status_num").val()==5)){
		taskMenuClass.meun.push({
            name: $.i18n('taskmanage.decompose'),//分解
            handle: function (json) {
               taskMenuClass.url = _ctxPath + "/taskmanage/taskinfo.do?method=newTaskInfo&from=Decompose&parentTaskId="+taskId+"&optype=new&flag=9"+"&projectId="+$("#projectId").val();
               taskMenuClass.operate="Decompose";
               taskMenuClass.callBack=refreshTaskTreeAndList;
               //连续添加
               taskMenuClass.bottomHTML = '<div class="common_checkbox_box clearfix "><label class="margin_r_10 hand" for="continuous_add"><input id="continuous_add" class="radio_com" name="continuous" value="0" type="checkbox">&nbsp;&nbsp;'+ $.i18n("taskmanage.add.continue") +'</label></div>';
               taskMenuClass.title = $.i18n('taskmanage.decompose.task.js');
               getCtpTop().operationType=taskMenuClass.operate;
               //调用任务分解方法
               taskMenuClass.newTask();
            }
        });
	}
	taskMenuClass.meun.push({
        name: $.i18n('taskmanage.delete.label'),//删除
        handle: function (json) {
           taskMenuClass.operate="delete";
           getCtpTop().operationType=taskMenuClass.operate;
           taskMenuClass.deleteTaskInfo(taskId);
        }
    });
	$("#taskSet").menuSimple({
			event:"mouseenter",
			width:50,
			disabled:"BL",
            data:taskMenuClass.meun
    });
}
/**
 * 新建任务功能,修改
 */
TaskMenuClass.prototype.newTask=function(){
	var _height =397;
		if(taskMenuClass.operate=="modify"){
			_height =460;
		}
    	dialog = $.dialog({
	    	id : 'new_task_'+Date.parse(new Date()),
	    	'url' :taskMenuClass.url,
	    	width : 554,
	    	height : _height,
	    	top:40,
	        title:taskMenuClass.title,
	        targetWindow : getCtpTop(),
	        bottomHTML : taskMenuClass.bottomHTML,
	        closeParam:{
	            'show':true,
	            handler:function(){
	                dialog.close();
	            }
	        },
	        buttons : [ {
	            text : $.i18n('common.button.ok.label'),isEmphasize:true,
	            id : 'ok',
	            handler : function() {
	        			//isChecked  是否连续添加
			        	var ret = dialog.getReturnValue({'dialogObj': dialog ,
			        									 'isChecked': dialog.getObjectById("continuous_add")[0].checked,
			        									 "operate":taskMenuClass.operate , 
			        									 'runFunc' : taskMenuClass.callBack});
	            }
	        }, {
	            text : $.i18n('common.button.cancel.label'),
	            handler : function() {
	            	getCtpTop().operationType="";
	                dialog.close();
	            }
	        } ]
    });
}	

/**
 * 删除任务信息操作
 */
TaskMenuClass.prototype.deleteTaskInfo=function(idValues) {
	var taskAjax = new taskAjaxManager();
    if (idValues == null || idValues.length == 0) {
        $.alert($.i18n('taskmanage.alert.delete.select'));
    } else {
        var bool = checkIfChildExist(idValues);
        var ret = bool == true || bool == "true" ? $.i18n('taskmanage.confirm.delete.contain_childs')
                : $.i18n('taskmanage.confirm.delete');
        var confirm = $.confirm({
            'msg' : ret,
            ok_fn : function() {
                taskAjax.deleteTask(idValues, {
                    success : function(bool) {
                        if (bool == true || bool == "true") {
                        	if(from=="msg"){
           						parent.window.close();
           					}
                        	projectTaskDetailDialog_close();
                        	
                            try{
                            	refreshTaskList();
                            }catch(e){}
                            
                            try{
                            	refreshTaskPortalListAndTime();
                            }catch(e){}
                            
                        }
                    },
                    error : function(request, settings, e) {
                        $.error($.i18n('taskmanage.error.delete.server'));
                    }
                });
            },
            cancel_fn : function() {
            }
        });
    }
} 

/**
 * 删除任务之前，判断选中的任务中是否包含有子任务
 * @param id 任务Id
 */
function checkIfChildExist(id) {
    var bool = false;
	var taskAjax = new taskAjaxManager();
    bool = taskAjax.checkIfChildExist(id);
    return bool;
}

/*
 *刷新任务详情页或者栏目
 */
 function refreshTaskPortalListAndTime(){
 	var from=getCtpTop().fromType;
 	if(from=="taskSection"){
 		try{
	 		//个人空间 我的任务栏目
	 		getCtpTop().$("#main")[0].contentWindow.sectionHandler.reload("taskMySection",true);
 		}catch(e){}
 		
 		try{
 			//项目空间 项目任务
	 		getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectTaskSection",true);
	 		getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectMemberTaskSection",true);
	 		getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectOverdueTaskSection",true);
	 		getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectTaskStatusSection",true);
	 		getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectTaskOverviewSection",true);
 		}catch(e){}
 	}else if(from=="timeLineDate"){
 		//时间视图
 		getCtpTop().$("#main")[0].contentWindow.location.reload(true);
 	}else if(timeLineTyoe=="2"){//也是时间视图
 		getCtpTop().$("#main")[0].contentWindow.location.reload(true);
 	}else{
	 	try{//刷新时间线
	 		getCtpTop().refleshTimeLinePage();
	 	}catch(e){}
 	}
 }
/*
*刷新任务详情页和任务列表或者栏目
*/
function refreshTaskDetailAndList(){
	//刷新任务详情页或者栏目
	/**
	 * 加延时原因：dialog组件关闭会有100ms延时，如果父级元素已经改变则无法关闭窗口
	 * BUG_紧急_A8_V5.6SP1_贵州宏立城房地产开发有限公司_任务修改导致浏览器崩溃 
	 */
	setTimeout(function(){
		refreshTaskInfo(taskId);
	}, 150);
	//刷新任务列表
	refreshTaskList();
}
/**
*刷新任务列表
*/
function refreshTaskList(){
	try{
 		//任务统计穿透和更多
 		getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.refreshPageData();
	}catch(e){}
		
	try{
		//我的任务更多
		getCtpTop().$("#main")[0].contentWindow.$("#list_content_iframe")[0].contentWindow.refreshPageData();
	}catch(e){}
}
 /*
 *刷新任务详细信息
 */
 function refreshTaskInfo(taskId){
	 var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&from="+from+"&taskId="+taskId;
	 var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&from="+from+"&taskId="+taskId;
	 treeUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+taskId;
	 var taskDetailTreeManager_=new taskDetailTreeManager();
	 var exitTree=taskDetailTreeManager_.checkTaskTree(taskId);
	 if (getCtpTop() != null) {
		 if(!exitTree){
		 	//模拟点击事件
		 	if(getCtpTop().$(".projectTask_detailDialog_c_iframe").width()>0
		 	&&getCtpTop().$(".projectTask_detailDialogBtn_c").css("display")!="none"){
		 		getCtpTop().$(".projectTask_detailDialogBtn_c").trigger("click").hide();
		 	}
		 }else if(from!='msg'){
		 	getCtpTop().$(".projectTask_detailDialogBtn_c").show();
		 }
		 //暂时不做iframe刷新
		 projectTaskDetailDialog_reload(detailUrl,contentUrl,from!='msg'?treeUrl:"");
	 }
 }
/*
*刷新任务树页和任务列表或者栏目
*/
function refreshTaskTreeAndList(){
	//刷新任务详情页或者栏目
	refreshTaskTree(taskId);
	//刷新任务列表
	refreshTaskList();
}
 /*
 *刷新任务树
 */
 function refreshTaskTree(taskId){
 	if(from!='msg'){
	 	getCtpTop().$(".projectTask_detailDialogBtn_c").show();
	 	treeUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+taskId;
	 	projectTaskDetailDialog_reload(undefined,undefined,treeUrl);
 	}
 }
 /**
 *刷新数据和关闭详情页面
 */
 function refreshAndClose(){
 	projectTaskDetailDialog_close();
 	if(getCtpTop().operationType!=""){
	 	//刷新任务列表
	  	refreshTaskPortalListAndTime();
  		getCtpTop().operationType="";
  	}
	getCtpTop().fromType="";
 }