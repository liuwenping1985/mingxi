    /**
     * 初始化工具条
     */
    function initToolBar() {
        var proId = getUrlPara("projectId");
        phaseObj = taskAjax.getProjectPhase(proId);
        toolbar = $("#toolbar").toolbar({
            borderTop:false,
            toolbar : contactToolBar()
        });
        selectedBtnByTaskType(getUrlPara("from"));
        hiddenSelect("selectProjectPhase");
    }

	function contactToolBar(){
		var toolbar=new Array();
		toolbar.push(initSubToolBar([{id:"new",name:$.i18n('common.toolbar.new.label'),className:"ico16",click:function(){newTask(null,null,null,reloadPersonalTaskList)}}]));
		toolbar.push(initSubToolBar([{id:"delete",name:$.i18n('common.toolbar.delete.label'),className:"ico16 del_16",click:deleteTask}]));
		if(formType=="Manage"){
			//OA-71049目标管理--工作任务--任务管理，菜单栏的【导入/导出】应该为【导出Excel】
			toolbar.push(initSubToolBar([{id:"importOrExport",name:$.i18n('common.toolbar.exportExcel.label'),className:"ico16 export_excel_16",click:exportToExcelOld}]));
		}else{
			//我的任务
			toolbar.push(initSubToolBar([{id:"importOrExport",name:$.i18n('export.or.import'),className:"ico16 import_16",subMenu:[{name:$.i18n('application.95.label'),click:importExcelFile},{name:$.i18n('org.template.excel.download'),click:downTaskTemplate},{name:$.i18n('common.toolbar.exportExcel.label'),click:exportToExcelOld}]}]));
		}
		toolbar.push(initSubToolBar([{id:"personal",name:$.i18n('taskmanage.personal.label'),className:"ico16 personal_tasks_16",click:choosePersonalTasks}]));
		toolbar.push(initSubToolBar([{id:"sent",name:$.i18n('taskmanage.sent.label'),className:"ico16 has_been_distributed_16",click:chooseSentTasks}]));
		toolbar.push(initSubToolBar([{id:"show_type",type:"select",value:"0",text:$.i18n('taskmanage.view.list'),onchange:chooseShowType,items:[{text:$.i18n('taskmanage.view.tree'),value:"1"}]}]));
		toolbar.push(initSubToolBar([{id:"selectProjectPhase",type:"select",value:"1",text:$.i18n('taskmanage.all'),onchange:chooseProjectPhase,items:phaseObj}]));
		return toolbar;
	}
	/**
	*将json组装成object数组
	*/
	function initSubToolBar(jsonData){
		var subToolBar=new Object();
		jsonData=eval(jsonData);
		if(checkJson(jsonData)){
			analysisJsonData(subToolBar,jsonData);
		}
		for(var i=0;i<jsonData.length;i++){
			analysisJsonData(subToolBar,jsonData[i]);
		}
		return subToolBar;
	}
	/**
	*解析json数据
	*/
	function analysisJsonData(subToolBar,jsonData){
		for(var key in jsonData){
			subToolBar[key]=getToolBar(jsonData[key]);
		}
	}
	/**
	*针对json中嵌套json数据的解析
	*/
	function getToolBar(subJsonData){
		var jsonList=new Array();
		if(subJsonData instanceof Array){
			for(var i=0;i<subJsonData.length;i++){
				if(checkJson(subJsonData[i])){
					jsonList.push(initSubToolBar(subJsonData[i]));
				}
			}
		}else{
			return subJsonData
		}
		return jsonList;
	}
	//判断是否是json数据
	var checkJson = function(obj){
    	var isjson = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;
    	return isjson;
	}
    /**
     * 初始化搜索框
     */
    function initSearchDiv() {
        searchobj = $.searchCondition({
            top:2,
            right:10,
            searchHandler: function(){
                var returnValue = searchobj.g.getReturnValue();
                if(returnValue != null){
                    var obj = setQueryParamses(returnValue);
                    if(obj.listShowType == 1) {
                        obj.listShowType = 0;
                        $("#show_type").val(obj.listShowType);
                        isDisabledImportExcelBtn(obj.listShowType);
//                         if (obj.listShowType == 1) {
//                             listDataObj.grid.toggleCol("2", true);
//                         } else {
//                             listDataObj.grid.toggleCol("2", false);
//                         }
                    }
                    $("#taskInfoList").ajaxgridLoad(obj);
                    showTaskDescription();
                    if(listDataObj != null) {
                        listDataObj.grid.resizeGridUpDown('down');
                    }
                }
            },
            conditions: [{
                id: 'title',
                name: 'title',
                type: 'input',
                text: $.i18n('common.subject.label'),
                value: 'subject'
            }, {
                id: 'starttime',
                name: 'starttime',
                type: 'datemulti',
                text: $.i18n('taskmanage.starttime'),
                value: 'plannedStartTime',
                ifFormat:"%Y-%m-%d",
                dateTime: false
            }, {
                id: 'endtime',
                name: 'endtime',
                type: 'datemulti',
                text: $.i18n('common.date.endtime.label'),
                value: 'plannedEndTime',
                ifFormat:"%Y-%m-%d",
                dateTime: false
            }, {
                id: 'importent',
                name: 'importent',
                type: 'select',
                text: $.i18n('common.importance.label'),
                value: 'importantLevel',
                codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"
            }, {
                id: 'statusselect',
                name: 'statusselect',
                type: 'select',
                text: $.i18n('taskmanage.status'),
                value: 'status',
                codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'",
                items: [{
                    text: $.i18n('taskmanage.status.unfinished'),
                    value: '1,2,3'
                }, {
                    text: $.i18n('common.all.label'),
                    value: '1,2,3,4,5'
                }]
            }, {
                id: 'risk',
                name: 'risk',
                type: 'select',
                text: $.i18n('taskmanage.risk'),
                value: 'riskLevel',
                codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"
            }, {
                id: 'createUserText',
                name: 'createUserText',
                type: 'input',
                text: $.i18n('common.creater.label'),
                value: 'createUser'
            }, {
                id: 'managersText',
                name: 'managersText',
                type: 'input',
                text: $.i18n('taskmanage.manager'),
                value: 'managers'
            }, {
                id: 'participatorsText',
                name: 'participatorsText',
                type: 'input',
                text: $.i18n('taskmanage.participator'),
                value: 'participators'
            }, {
                id: 'inspectorsText',
                name: 'inspectorsText',
                type: 'input',
                text: $.i18n('taskmanage.inspector'),
                value: 'inspectors'
            }]
        });
        searchobj.g.setCondition('statusselect','1,2,3');
    }
    
    /**
     * 初始化任务里列表数据
     */
    function initData() {
        initListData();
    }
    
    /**
     * 初始化列表数据
     */
    function initListData() {
        listDataObj = $("#taskInfoList").ajaxgrid(
                        {
                            render: render,
                            isHaveIframe:true,
                            colModel : [
                                    {
                                        display : 'id',
                                        name : 'id',
                                        width : '5%',
                                        align : 'center',
                                        type : 'checkbox'
                                    }, {
                                        display : $.i18n('common.subject.label'),
                                        name : 'subject',
                                        sortable : true,
                                        width : '25%'
                                    },  {
                                        display : $.i18n('taskmanage.weight'),
                                        name : 'weight',
                                        sortable : true,
                                        width : '5%'
                                    }, {
                                        display : $.i18n('common.state.label'),
                                        name : 'status',
                                        width : '8%',
                                        sortable : true,
                                        codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
                                    }, {
                                        display : $.i18n('taskmanage.finishrate'),
                                        name : 'finishRate',
                                        sortable : true,
                                        sortType : 'number',
                                        width : '18%'
                                    }, {
                                        display : $.i18n('taskmanage.starttime'),
                                        name : 'plannedStartTime',
                                        sortable : true,
                                        width : '12%'
                                    }, {
                                        display : $.i18n('common.date.endtime.label'),
                                        name : 'plannedEndTime',
                                        sortable : true,
                                        width : '12%'
                                    }, {
                                        display : $.i18n('taskmanage.manager'),
                                        name : 'managerNames',
                                        sortable : true,
                                        width : '14%'
                                    } ],
                            click : clickEvent,
                            dblclick : openTaskDetailPage,
                            vChange: true,
                            vChangeParam: {
                                overflow: "hidden",
                                autoResize:true
                            },
                            showTableToggleBtn: false,
                            slideToggleBtn: true,
                            parentId: $('.layout_center').eq(0).attr('id'),
                            managerName : "taskInfoManager",
                            managerMethod : "selectTaskList",
                            onCurrentPageSort : true,
                            onSuccess : filterDeletePurview,
                            onChangeSort:function(sortname, sortorder,sortType){
                            //alert(openArray.join(','))
                                var dddddd = $('.table_add_16');
                                if(dddddd.size()>0){
                                setOpen(openArray,sortname, sortorder,sortType);
                                }

                                
                            }
                        });
//         var type = $("#show_type").val();
//         if (type == 1) {
//             listDataObj.grid.toggleCol("2", true);
//         } else {
//             listDataObj.grid.toggleCol("2", false);
//         }
    }
    function setOpen(array,sortname, sortorder,sortType){   
        /**
        $('.table_add_16').each(function(){
            toggleTreeOrder(this,event,sortname,sortorder,sortType);
        });
        var dddddd = $('.table_add_16');
        if(dddddd.size()>0){
            setOpen(sortname, sortorder,sortType);
        }**/
        
        var openArrayTemp = [];
        for(var i = 0;i<array.length;i++){
            var _id = array[i];
            var _obj = $('#'+_id);
            if(_obj.size()>0){
                toggleTreeOrder(_obj,event,sortname,sortorder,sortType);
            }else{
                openArrayTemp.push(_id);
            }
        }
        array = openArrayTemp;
        if(array.length>0){
            setOpen(array,sortname, sortorder,sortType)
        }
        
    }
    function clickEvent(data, r, c,id) {
        if(id) {
            var idStr = null;
            if(id.indexOf("row") > -1) {
                idStr = id.substring(3,id.length);
            }
            viewTaskInfoByIframe(idStr);
        }
        else if(data){
            viewTaskInfoByIframe(data.id);
        }
    }
    
    function doubleClickEvent(data, r, c,id) {
        if(id) {
            var idStr = null;
            if(id.indexOf("row") > -1) {
                idStr = id.substring(3,id.length);
            }
            viewTaskInfoDialog(idStr);
        }
        else if(data){
            viewTaskInfoDialog(data.id);
        }
    }
    
    function openTaskDetailPage(data, r, c,id){
     	var idStr = null;
    	if(id){
            if(id.indexOf("row") > -1) {
                idStr = id.substring(3,id.length);
            }
         }else if(data){
         	idStr=data.id;
         }
    	openCtpWindow({'url':_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&taskId="+idStr});
    }
    
    /**
     * 筛选删除权限
     */
    function filterDeletePurview(){
        $("#taskInfoList").formobj({
            gridFilter : function(data, row) {
                var currentUserId = $.ctx.CurrentUser.id;
                if(data.createUser.indexOf(currentUserId) < 0 && data.managers.indexOf(currentUserId) < 0){
                    $("input:checkbox", $("#row"+data.id))[0].disabled = true;
                }
            }
        });
        if(childTaskList.length > 0) {
            for(var i=0; i<childTaskList.length; i++){
                var taskData = childTaskList[i];
                var currentUserId = $.ctx.CurrentUser.id;
                if(taskData.createUser.indexOf(currentUserId) < 0 && taskData.managers.indexOf(currentUserId) < 0){
                    if($("input:checkbox", $("#row"+taskData.id))[0] != undefined) {
                        $("input:checkbox", $("#row"+taskData.id))[0].disabled = true;
                    }
                }
            }
        }
    }
    /**
     * 处理列表中所显示的数据
     * @param text 列表显示信息
     * @param row 列对象
     * @param rowIndex 列索引
     * @param colIndex 行索引
     * @param col 行对象
     */
    function render(text, row, rowIndex, colIndex,col){
        if(col.name == "subject"){
            return taskNameIconDisplay(text,row);
        }
        if(col.name == "finishRate") {
            return processFinishRateData(text, row);
        } else {
            return text;
        }   
    }
 
    /**
     * 任务标题中所显示图标处理
     * @param text 列表显示信息
     * @param row 列对象
     */
    function taskNameIconDisplay(text,row){
        var iconStr = "";
        //根节点图标
        if(row.haschild==true && row.ischild != true) {    
            iconStr += "<span root='true' class='ico16 table_add_16' onclick='toggleTree(this,event)' id='open_"+row.id+"' parentId='"+row.id+"' index='"+row.index+"'> </span>";
        }
        //重要程度图标
        if(row.importantLevel == "2") {
            iconStr += "<span class='ico16 important_16'></span>";
        } else if(row.importantLevel == "3"){
            iconStr += "<span class='ico16 much_important_16'></span>";
        }
        //里程碑
        if(row.milestone == "1") {    
            iconStr += "<span class='ico16 milestone'></span>";
        }
        //风险图标
        if(row.riskLevel == "1") {
            iconStr += "<span class='ico16 l_risk_16'></span>";
        } else if(row.riskLevel == "2"){
            iconStr += "<span class='ico16 risk_16'></span>";
        } else if(row.riskLevel == "3"){
            iconStr += "<span class='ico16 h_risk_16'></span>";
        }
        iconStr += text;
        //附件图标
        if(row.has_attachments == true || row.has_attachments == "true") {    
            iconStr += "<span class='ico16 affix_16'></span>";
        } 
        //判断是否是子节点
        if(row.ischild==true){
                var index;
                if(row.index > 0){
                    index = row.index-1;
                } else {
                    index = row.index;
                }
                var margin=index*20+"px";
                if(row.haschild==true){//判断是否存在二级子节点
                    //iconStr = "<a href='javascript:void(0)' class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";text-decoration : none;color: black;cursor: default;'><span class='ico16 table_add_16' onclick='toggleTree(this,event)' parentId='"+row.id+"' index='"+row.index+"'> </span>"+iconStr+"</a>";
                    iconStr = "<span style='width:"+margin+";display:inline-block'>&nbsp;</span><span class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";'><span class='ico16 table_add_16' onclick='toggleTree(this,event)' id='open_"+row.id+"' parentId='"+row.id+"' index='"+row.index+"'> </span>"+iconStr+"</span>";
                } else {
                    //iconStr = "<a href='javascript:void(0)' class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";text-decoration : none;color: black;cursor: default;'>"+iconStr+"</a>";
                    iconStr = "<span style='width:"+margin+";display:inline-block'>&nbsp;</span><span id='open_"+row.id+"' class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";'>"+iconStr+"</span>";
                }
        }
        return iconStr;
    }
    
    /**
     * 对完成率显示内容进行处理
     * @param text 列表显示信息
     * @param row 列对象
     */
    function processFinishRateData(text,row){
            var percent=parseInt(text);//百分数
            var color_class="rate_process";
            if(row.status == "4") color_class="rate_filish"; //已完成
            if(row.status == "3") color_class="rate_delay"; //已延期
            if(row.status == "5") color_class="rate_canel"; //已取消
            return "<span class='right margin_l_5' style='width:40px;'>"+ text+"%</span><p class='task_rate adapt_w' style=''><a href='#' class='"+color_class+"' style='width:"+percent+"%;'></a></p>";
    }
    /**
     * 设置初始化查询参数
     */ 
    function setInitParams() {
        var obj = new Object();
        obj.listType = getUrlPara("from");
        if(obj.listType == "Manage") {
            obj.userId = getUrlPara("userId");
        } else {
            obj.userId = $.ctx.CurrentUser.id;
        }
        obj.condition = "status";
        obj.queryValue = "1,2,3";
        return obj;
    }
    
    /**
     * 初始化图形界面
     */ 
    function initUI(){
        initToolbarUI();
        showTaskDescription();
    }
    
    /**
     * 初始化工具条界面
     */ 
    function initToolbarUI(){
       var from = getUrlPara("from");
       if(from == "Manage") {
           toolbar.hideBtn("new");
           toolbar.hideBtn("personal");
           toolbar.hideBtn("sent");
           hiddenSelect("show_type");
           if(cntType == "Project" && phaseObj != null && phaseObj.length > 0) {
               showSelect("selectProjectPhase");
           }
       }
    }
    
    function hiddenSelect(id) {
        var tar = $('#'+id);
        if(tar.length>0){
            tar.hide();
            var sp = tar.next();
            if(sp.hasClass('seperate')){
                sp.hide();
            }
        }
    }
    
    function showSelect(id) {
        var tar = $('#'+id);
        if(tar.length>0){
            tar.show();
            var sp = tar.next();
            if(sp.hasClass('seperate')){
                sp.show();
            }
        }
    }
    /**
     * 显示任务描述
     */
    function showTaskDescription() {
        var from = getUrlPara("from");
        var total = 0;
        if (listDataObj != null) {
            if (listDataObj.p.total) {
                total = listDataObj.p.total;
            }
        }
        var url = _ctxPath + "/taskmanage/taskinfo.do?method=taskDescription&from=" + from + "&total=" + total;
        $("#taskinfo_iframe").attr("src",url);
    }
    
    /**
     * 禁用除当前组件启用方法外的其他被触发方法
     * @param obj 当前组件对象
     */ 
    function disableAnotherMethod(obj,evt) {
        var e = (evt) ? evt : window.event;
        if (window.event) {
            //使用IE的方式来取消事件冒泡
            e.cancelBubble=true; 
        } else {
            e.stopPropagation(); 
        }
    }
    
    /**
     * 刷新页面
     * 
     */ 
    function refreshPage() {
        $("#taskInfoList").ajaxgridLoad();
        showTaskDescription();
        if(listDataObj != null && listDataObj != undefined) {
            listDataObj.grid.resizeGridUpDown('down');
        }
    }