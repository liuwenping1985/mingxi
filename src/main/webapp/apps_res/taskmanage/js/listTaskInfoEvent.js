    var dialog;
    var searchobj;
    var toolbar;
    var taskAjax = new taskAjaxManager();
    var listDataObj;
    var showListType = 0;
    var isLoadChildTask = "";
    var childTaskList = new Array();
    var isContinuous = false;
    var cntType = getUrlPara("contextType");
    var phaseObj = null;
    
    /**
     * 新建任务功能,修改
     */
    function newTask(arg,url,operate,callBack){
    		var _url = _ctxPath + '/taskmanage/taskinfo.do?method=newTaskInfo&from='+getUrlPara("from")+'&optype=new&flag=0&projectId='+getUrlPara("projectId")+"&projectPhaseId="+getUrlPara("projectPhaseId");
    		var _bottomHTML = "<div class='common_checkbox_box margin_l_10 clearfix'><label class='hand' for='continueAdd'><input id='continueAdd' class='radio_com' name='continuous' value='0' type='checkbox'>"
    			+ $.i18n('taskmanage.add.continue') +"</label></div>";
    		var _height = 397;
    		var _title = $.i18n('menu.taskmanage.new');
    		if('modify'== operate){
    			_url = url;
    			_bottomHTML = "";
    			_height = 460;
    			_title = $.i18n('taskmanage.modify.task.js');
    		}
    		if("Decompose"==operate){
    			_url=url;
    			_bottomHTML = "";
    			_height = _height;
    			_title = $.i18n('taskmanage.modify.task.js');
    		}
    		//项目空间更多页面的新建任务
    		if(getCtpTop().$("#main")[0].contentWindow.$("#head").length==1&&!('modify'== operate||"Decompose"==operate)){
    			var beginDate = getCtpTop().$("#main")[0].contentWindow.$("#head")[0].contentWindow.$("#beginDate").val();
    			var endDate = getCtpTop().$("#main")[0].contentWindow.$("#head")[0].contentWindow.$("#endDate").val();
    			var phaseBeginDate = getCtpTop().$("#main")[0].contentWindow.$("#head")[0].contentWindow.$("#phaseBeginDate").val();
    			var phaseEndDate = getCtpTop().$("#main")[0].contentWindow.$("#head")[0].contentWindow.$("#phaseEndDate").val();
    			_url = _ctxPath + '/taskmanage/taskinfo.do?method=newTaskInfo&from=project&optype=new&flag=0&projectId='+getUrlPara("projectId")+"&projectPhaseId="+getUrlPara("projectPhaseId") +"&beginDate=" + (phaseBeginDate?phaseBeginDate:beginDate) + "&endDate=" + (phaseEndDate?phaseEndDate:endDate);
    			_title = $.i18n('project.task.addProjectTask');
    		}
        dialog = $.dialog({id : 'new_task','url' :_url,width : 554,height :_height,top:40,
            title:_title,
            targetWindow : getCtpTop(),
            bottomHTML : _bottomHTML,
            transParams : {
            	isExtend : null,
            	DiaObjoffsetTop :null
            },
            closeParam:{
                'show':true,
                handler:function(){
                    if(isContinuous) {
						if (typeof callBack == "function") {
							callBack();
						}
                    }
                }
            },
            buttons : [ {
                text : $.i18n('common.button.ok.label'),isEmphasize:true,
                id : 'ok',
                handler : function() {
	                  var isChecked = dialog.getObjectById("continueAdd").is(":checked");
	                  var ret = dialog.getReturnValue({'dialogObj': dialog , 'isChecked': isChecked,"operate":operate , 'runFunc' : callBack});
	                  isContinuous = (isChecked && ret);
                }
            }, {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    if(isContinuous) {
						if (typeof callBack == "function") {
							callBack();
						}
                    }
                    dialog.close();
                }
            } ]
        });
    }
    
    function reloadPersonalTaskList(){
    	 var url = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=Personal';
    	 parent.location.href = url;
    }
    
    /**
     * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
     * @param id 任务编号
     */
    function viewTaskInfoDialog(id) {
        var title = $.i18n('taskmanage.content');
        var isTask = taskAjax.validateTask(id);
        if(isTask != null && !isTask) {
            $.alert({
                'msg' : $.i18n('taskmanage.task_deleted'),
                ok_fn : function() {
                    refreshPage();
                }
            });
            return;
        }
        var type = $("#show_type").val();
        if (type != 1 && cntType != "Project") {
            var isView = taskAjax.validateTaskView(id);
            if(isView != null && !isView) {
               $.alert($.i18n('taskmanage.alert.no_auth_view_task'));
               return;
            }
        }
        var fromTree = "";
        if(type == 1) {
            fromTree = "&isFromTree=1";
        }
        dialog = $.dialog({
            url : _ctxPath + '/taskmanage/taskinfo.do?method=taskDetailIndex&id='+ id +"&from=" + getUrlPara("from") + fromTree,
            width : $(getCtpTop()).width()-100,
            height : $(getCtpTop()).height()-100,
            title : title,
            targetWindow : getCtpTop(),
            closeParam:{
                'show':true,
                autoClose:false,
                handler:function(){
                    dialog.getClose({'dialogObj' : dialog ,'runFunc' : refreshPage});
                }
            },
            buttons: [{
                text: $.i18n('common.button.close.label'),
                handler: function () {
                    dialog.getClose({'dialogObj' : dialog ,'runFunc' : refreshPage});
                }
            }]
        });
    }
    
    /**
     * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
     * @param id 任务编号
     */
    function viewTaskInfoByIframe(id) {
        var isTask = taskAjax.validateTask(id);
        if(isTask != null && !isTask) {
            $.alert({
                'msg' : $.i18n('taskmanage.task_deleted'),
                ok_fn : function() {
                    refreshPage();
                }
            });
            return;
        }
        var type = $("#show_type").val();
        if (type != 1 && cntType != "Project") {
            var isView = taskAjax.validateTaskView(id);
            if(isView != null && !isView) {
               $.alert($.i18n('taskmanage.alert.no_auth_view_task'));
               return;
            }
        }
        var fromTree = "";
        if(type == 1) {
            fromTree = "&isFromTree=1";
        }
        $("#taskinfo_iframe").attr("src", _ctxPath + '/taskmanage/taskinfo.do?method=taskDetailIndex&id='+id+"&viewType=1&from=" + getUrlPara("from") + fromTree);
    }
    /**
     * 获取列表中选中的id
     */
    function getCheckedId() {
        var ids = null;
        var type = $("#show_type").val();
        if(type == 1) {
            $("#taskInfoList").find("input:checkbox").each(function(){
                if ($(this).attr("checked")) {
                    if(ids == null || ids == "null") {
                        ids = $(this).attr("value");
                    } else {
                        ids += "," + $(this).attr("value");
                    }   
                }
            });
        } else {
            var idValue = $("#taskInfoList").formobj({
                gridFilter : function(data, row) {
                    return $("input:checkbox", row)[0].checked;
                }
            });
            for ( var i = 0; i < idValue.length; i++) {
                if (i == 0) {
                    ids = idValue[i].id;
                } else {
                    ids += "," + idValue[i].id;
                }
            }
        }
        return ids;
    }
    /**
     * 删除任务之前，判断选中的任务中是否包含有子任务
     * @param id 任务Id
     */
    function checkIfChildExist(id) {
        var bool = false;
        bool = taskAjax.checkIfChildExist(id);
        return bool;
    }
    /**
     * 删除任务信息操作
     */
    function deleteTask() {
        var idValues = getCheckedId();
        if (idValues == null || idValues.length == 0) {
            $.alert($.i18n('taskmanage.alert.delete.select'));
        } else if (taskAjax.checkTaskIsFinished(idValues)) {
            var retMsg = $.i18n('taskmanage.alert.delete.no_delete');
            if(idValues.indexOf(",") > -1) {
                retMsg = $.i18n('taskmanage.alert.delete.contain_no_delete');
            }
            $.alert(retMsg);
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
                                refreshPage();
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
     * 根据任务类型选择我的任务的显示内容
     * @param type 任务类型
     */
    function chooseMyTasks(type) {
        selectedBtnByTaskType(type);
        parent.location.href = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=' + type;
    }
	 /**
     * 根据任务类型选择我的任务的显示内容(个人)
     */
	function choosePersonalTasks(){
		var type="Personal";
		selectedBtnByTaskType(type);
	    parent.location.href = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=' + type;
	}
	/**
     * 根据任务类型选择我的任务的显示内容(已分派)
     */
	function chooseSentTasks(){
		var type="Sent";
		selectedBtnByTaskType(type);
	  parent.location.href = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=' + type;
	}
	
    /**
     * 根据任务类型选中对应类型按钮
     * @param taskType 任务类型
     */
    function selectedBtnByTaskType(taskType) {
        if (taskType == "Personal") {
            toolbar.selected("personal");
            toolbar.unselected("sent");
        } else {
            toolbar.unselected("personal");
            toolbar.selected("sent");
        }
    }

    /**
     * 导入Excel方法
     */
    function importExcelFile () {
    	var urlPath =  _ctxPath + '/taskmanage/taskinfo.do?method=importExcelFile';
    	var  importExcelDialog = $.dialog({
            id : 'importExcel',
            url : urlPath,
            width : 600,
            height : 180,
            title : $.i18n('application.95.label'),
            targetWindow : getCtpTop(),
            closeParam:{
                'show':true,
                handler:function(){
                	refreshPage();
                }
            },
            buttons : [ {
				id: 'ok',
                text : $.i18n('common.button.ok.label'),isEmphasize:true,
                handler : function() {
                	importExcelDialog.getReturnValue({'dialogObj' : importExcelDialog});
                }
            }, {
				id: 'cancel',
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    importExcelDialog.close();
                }
            } ]
        });
    }
    
	/**
     * 模板下载
     */
	function downTaskTemplate() {
		 $("#exportExcelIframe").attr("src", _ctxPath + "/taskmanage/taskinfo.do?method=downTaskTemplate");
	}
	
    /**
     * 导出excel
     */
    function exportToExcelOld() {
        var count = $("#taskInfoList")[0].rows.length;
        //         logger.debug(count);
        if (count < 1) {
            $.alert($.i18n('taskmanage.alert.no_records_excel'));
            return false;
        }
        //var projectPhaseId = "${empty param.projectPhaseId ? 1 : param.projectPhaseId}";
        var projectPhaseId = getUrlPara("projectPhaseId") == null ? "1" : getUrlPara("projectPhaseId");
        if($("#selectProjectPhase").val() != undefined) {
            projectPhaseId = $("#selectProjectPhase").val();
        }
        var url = _ctxPath
                + "/taskmanage/taskinfo.do?method=exportToExcel&from=" + getUrlPara("from") + "&userId="+ getUrlPara("userId") +"&projectId="+ getUrlPara("projectId") +"&projectPhaseId="+projectPhaseId+"&condition="
                + $("#conditionText").val() + "&queryValue="
                + encodeURIComponent($("#firstQueryValueText").val()) + "&queryValue1="
                + $("#secondQueryValueText").val() + "&source=mytask";
        var exportExcelIframe = $("#exportExcelIframe");
        exportExcelIframe.attr("src", url);
    }

    /**
     * 弹出窗口的关闭事件
     */
    function listenerKeyESC() {
        if (event.keyCode == 27) {
            dialog.close();
        }
    }

    /**
     * 选人界面的操作
     */
    function selectPerson(valueId, textId, retText, retValue) {
        $.selectPeople({
            type : 'selectPeople',
            panels : 'Department,Team',
            selectType : 'Member',
            isNeedCheckLevelScope : false,
            text : $.i18n('common.default.selectPeople.value'),
            params : {
                text : retText,
                value : retValue
            },
            maxSize : 1,
            callback : function(ret) {
                if (ret) {
                    $("#" + textId).val(ret.text);
                    $("#" + valueId).val(ret.value);
                }
            }
        });
    }

    /**
     * 设置查询条件
     */
    function setQueryParamses(returnValue) {
        var condition = returnValue.condition;
        var value = returnValue.value;
        var obj = new Object();
        if (listDataObj != null) {
            if (listDataObj.p.params) {
                obj = listDataObj.p.params;
            }
        }
        if (obj.listType == undefined || obj.userId == undefined) {
            obj = setInitParams();
        }
        obj.condition = condition;
        if (condition == "plannedStartTime" || condition == "plannedEndTime") {
            if (value.length > 0) {
                obj.queryValue = value[0];
                obj.queryValue1 = value[1];
            }
        } else {
            obj.queryValue = value;
        }
        $("#conditionText").val(obj.condition);
        $("#firstQueryValueText").val(obj.queryValue);
        $("#secondQueryValueText").val(obj.queryValue1);
        return obj;
    }

    /**
     * 根据列表展示类型判断是否启用导出excel按钮
     * @param type 列表展示类型
     */
    function isDisabledImportExcelBtn(type) {
        if (type == 1) {
            toolbar.disabled("importOrExport");
        } else {
            toolbar.enabled("importOrExport");
        }
    }

    /**
     * 根据列表展示类型选中对应选项
     * @param type 列表展示类型
     */
    function selectedBtnByTaskListType(type) {
        $("#show_type").val(type);
    }
    
    /**
     * 切换树形列表执行的条件
     *
     */
    function chooseShowType() {
        var type = $("#show_type").val();
        var obj = new Object();
        obj.listType = getUrlPara("from");
        obj.userId = $.ctx.CurrentUser.id;
        obj.condition = "status";   
        isDisabledImportExcelBtn(type);
        if (type == 1) {
            obj.listShowType = type;
//             listDataObj.grid.toggleCol("2", true);
            obj.queryValue = "1,2,3,4,5";
            searchobj.g.clearCondition();
        } else {
            obj.listShowType = type;
//             listDataObj.grid.toggleCol("2", false);
            obj.queryValue = "1,2,3";
            searchobj.g.setCondition('statusselect','1,2,3');
        }
        $("#taskInfoList").ajaxgridLoad(obj);
        showTaskDescription();
        if(listDataObj != null && listDataObj != undefined) {
            listDataObj.grid.resizeGridUpDown('down');
        }
    }

    /**
     * 切换树形列表执行的条件
     *
     */
    function chooseProjectPhase() {
        var phaseId = $("#selectProjectPhase").val();
        var obj = new Object();
        obj.listType = getUrlPara("from");
        obj.userId = $.ctx.CurrentUser.id;
        obj.condition = "status";   
        obj.queryValue = "1,2,3";
        obj.projectId = getUrlPara("projectId");
        obj.projectPhaseId = phaseId;
        searchobj.g.setCondition('statusselect','1,2,3');
        $("#taskInfoList").ajaxgridLoad(obj);
        showTaskDescription();
        if(listDataObj != null && listDataObj != undefined) {
            listDataObj.grid.resizeGridUpDown('down');
        }
        //parent.location.href = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=${param.from}';
    }
    
    /**
     * 显示任务树
     * @param taskId 当前任务Id
     */
    function viewTaskTree(taskId) {
        var title = $.i18n('taskmanage.tree');
        dialog = $.dialog({
            id : 'viewTree',
            url : _ctxPath + '/taskmanage/taskinfo.do?method=viewTaskTree&id='
                    + taskId + "&isBtnEidt=1",
            width : $(getCtpTop()).width() - 100,
            height : $(getCtpTop()).height() - 100,
            title : title,
            targetWindow : getCtpTop(),
            closeParam : {
                'show' : true,
                handler : function() {
                    var ret = dialog.getClose();
                    if (ret == true || ret == "true") {
                        refreshPage();
                    }
                }
            },
            buttons : [ {
                text : $.i18n('common.button.close.label'),
                handler : function() {
                    var rv = dialog.getClose();
                    if (rv == true || rv == "true") {
                        refreshPage();
                    }
                    dialog.close();
                }
            } ]
        });
    }
    
    // 隐藏显示树
    var openArray = [];
    function toggleTree(obj,evt) {
        var target = $(obj);
        var root = target.attr("root");
        var parentId = target.attr("parentId");
        var index = target.attr("index");
        var id = target.parents("tr").attr("id");
        disableAnotherMethod(obj,evt);
        if (index == 5) {
            var taskId = null;
            if (id.indexOf("row") > -1) {
                taskId = id.substring(3, id.length);
            }
            viewTaskTree(taskId);
        } else {
            if ($(".treeNode").parents("tr").length == 0) {
                isLoadChildTask = "";
            }
            if (isLoadChildTask.indexOf(parentId) < 0) {
                if (isLoadChildTask.length == 0) {
                    isLoadChildTask = parentId;
                } else {
                    isLoadChildTask += "," + parentId;
                }
                var childTaskData = taskAjax.selectChildTaskInfoes(parentId);
                if(childTaskData !=null && childTaskData.rows){
                    var len = childTaskData.rows.length;
                    for(var i = 0;i < len;i++){
                        childTaskList.push(childTaskData.rows[i]);
                    }
                }
                listDataObj.grid.addNewData(childTaskData, id);
            }

            var hiddentr = $("." + id).parents("tr");
            hiddentr.toggleClass("hidden");
            if(hiddentr.hasClass("hidden")) {
                target.attr("class","ico16 table_add_16");
            } else {
                target.attr("class","ico16 table_plus_16");
            }
            if (hiddentr.hasClass("hidden")) {
                hiddenChildTask(hiddentr);
            }
        }
        openArray = [];
        $('.table_plus_16').each(function(){
            openArray.push(this.id);
        });
        openArray = uniqueArr(openArray);
    }
    
    // 树列表排序
    function toggleTreeOrder(obj,evt,name,order,type) {
        var target = $(obj);
        var parentId = target.attr("parentId");
        var id = target.parents("tr").attr("id");

        var childTaskData = taskAjax.selectChildTaskInfoes(parentId);
        if(order == "asc") {
            order = "desc";
        }else{
            order = "asc";
        }
        if(type == undefined) {type = "string";}
        childTaskData.rows.sort(function (a, b) {
                var valueA=a[name]; //默认按字符串排序
                var valueB=b[name];
                if(type=="date"){//日期排序
                    valueA=Date.parse(valueA);
                    valueB=Date.parse(valueB);
                }
                if(type=='number'){//数字排序
                    valueA=Number(valueA);
                    valueB=Number(valueB);
                }
                 if (order == "desc") {//降序                   
                     if (valueA < valueB) return -1;
                     if (valueA > valueB) return 1;
                     return 0;
                 }
                 if (order == "asc") {//升序
                     if (valueA > valueB) return -1;
                     if (valueA < valueB) return 1;
                     return 0;
                 }
            });
                 
            listDataObj.grid.addNewData(childTaskData, id);

            var hiddentr = $("." + id).parents("tr");
            hiddentr.toggleClass("hidden");
            if(hiddentr.hasClass("hidden")) {
                target.attr("class","ico16 table_add_16");
            } else {
                target.attr("class","ico16 table_plus_16");
            }
            if (hiddentr.hasClass("hidden")) {
                hiddenChildTask(hiddentr);
            }
    }
    
    /**
     * 隐藏子任务
     * @param hiddentr 子任务对象
     */
    function hiddenChildTask(hiddentr){
        hiddentr.each(function(index) {
            //alert(index + ': ' + $(this).text()+"---" + $(this).find("span").hasClass("table_plus_16"));
            $(this).addClass("hidden");
            if($(this).find("span").hasClass("table_plus_16")) {
                $(this).find(".table_plus_16").attr("class","ico16 table_add_16");
            }
            var hiddentr = $("." + $(this).attr("id")).parents("tr");
            if(hiddentr.length > 0) {
                hiddenChildTask(hiddentr);
            }
        });
    }
    
	function uniqueArr(a) {
	  temp = new Array();
	  for (i = 0; i < a.length; i++) {
	    if (!containsArray(temp, a[i])) {
	      temp.length += 1;
	      temp[temp.length - 1] = a[i];
	    }
	  }
	  return temp.sort();
	}
	
	function containsArray(a, e) {
	  for (j = 0; j < a.length; j++) if (a[j] == e) return true;
	  return false;
	}