var listDataObj;
var searchobj = null;
/**
 * 初始化搜索框
 */
function initSearchDiv() {
    var isReport = getUrlPara("isReport");
    if(isReport != 1) {
        searchobj = $.searchCondition({
            top:2,
            right:10,
            searchHandler: function(){
                var returnValue = searchobj.g.getReturnValue();
                if(returnValue != null){
                    var obj = setQueryParams(returnValue);
                    $("#taskInfoList").ajaxgridLoad(obj);
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
                items: [{
                    text: $.i18n('taskmanage.status.unfinished'),
                    value: '1,2'
                } , {
                    text: $.i18n('taskmanage.status.notstarted'),
                    value: '1'
                } ,{
                    text: $.i18n('taskmanage.status.marching'),
                    value: '2'
                } , {
                    text: $.i18n('taskmanage.overdue.yes'),
                    value: '-1'
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
                text: $.i18n('taskmanage.notice.js'),
                value: 'inspectors'
            }]
        });
        searchobj.g.setCondition('statusselect','1,2,3');
    } else {
        searchobj = $.searchCondition({
            top:2,
            right:10,
            searchHandler: function(){
                var returnValue = searchobj.g.getReturnValue();
                if(returnValue != null){
                    var obj = setQueryParams(returnValue);
                    $("#taskInfoList").ajaxgridLoad(obj);
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
                items: [ {
                    text: $.i18n('taskmanage.status.notstarted'),
                    value: '1'
                } ,{
                    text: $.i18n('taskmanage.status.marching'),
                    value: '2'
                } ,{
                    text: $.i18n('taskmanage.status.finished'),
                    value: '4'
                },{
                    text: $.i18n('taskmanage.overdue.yes'),
                    value: '-1'
                },{
                    text: $.i18n('taskmanage.status.canceled'),
                    value: '5'
                },{
                    text: $.i18n('taskmanage.status.unfinished'),
                    value: '1,2'
                } , {
                    text: $.i18n('common.all.label'),
                    value: '1,2,4,5'
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
                text: $.i18n('taskmanage.notice.js'),
                value: 'inspectors'
            }]
        });
        searchobj.g.setCondition('statusselect','1,2,4,5');
    }
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
                        resizable:false,
                        colModel : [
                                {
                                    display : $.i18n('taskmanage.select.label'),
                                    name : 'id',
                                    width : '5%',
                                    align : 'center'
                                }, {
                                    display : $.i18n('common.subject.label'),
                                    name : 'subject',
                                    width : '30%',
                                    sortable : true
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
                                    align : 'center',
                                    width : 150
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
                                    width : '14%'
                                } ],
                        dblclick : clickEvent,
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "taskInfoManager",
                        usepager:isReport=="1"?false:true,
                        managerMethod : "selectTaskList",
                        onSuccess : bindCheckBoxEvent
                    });
}

function clickEvent(data, r, c) {
    if (data) {
        //viewTaskInfoDialog(data.id,0,1,1);
    	viewTaskInfoWindow(data.id);
    }
}

function viewTaskInfoWindow(id) {
	window.open(_ctxPath+"/taskmanage/taskinfo.do?method=openTaskMsg&from=bnOperate&drillDown=true&taskId=" + id);
}
/**
 * 筛选删除权限
 */
function filterDeletePurview() {
    $("#taskInfoList").formobj(
    {
        gridFilter : function(data, row) {
            var currentUserId = $.ctx.CurrentUser.id;
            if(data.createUser.indexOf(currentUserId) < 0 && data.managers.indexOf(currentUserId) < 0){
                if($("input:checkbox", row)[0].value == data.id){
                    $("input:checkbox", row)[0].disabled = true;
                }
            }
        }
    });
}
/**
 * 处理列表中所显示的数据
 * @param text 列表显示信息
 * @param row 列对象
 * @param rowIndex 列索引
 * @param colIndex 行索引
 * @param col 行对象
 */
function render(text, row, rowIndex, colIndex, col) {
    if (col.name == "subject") {
        return taskNameIconDisplay(text, row);
    }else if (col.name == "id") {
        var idStr = "<input type='checkbox' id='chk_task_id_"+text+"' name='chk_task_id' value='"+text+"'/>";
        return idStr;
    }else  if (col.name == "finishRate") {
        return processFinishRateData(text, row);
    }else if(col.name == "plannedEndTime" && row.status == "3"){
    	return "<span class='color_red'>"+text+"</span>";
    } else {
        return text;
    }
}

/**
 * 任务标题中所显示图标处理
 * @param text 列表显示信息
 * @param row 列对象
 */
function taskNameIconDisplay(text, row) {
    var iconStr = "";

    //重要程度图标
    if (row.importantLevel == "2") {
        iconStr += "<span class='ico16 important_16'></span>";
    } else if (row.importantLevel == "3") {
        iconStr += "<span class='ico16 much_important_16'></span>";
    }
    //里程碑
    if (row.milestone == "1") {
        iconStr += "<span class='ico16 milestone'></span>";
    }
    //风险图标
    if (row.riskLevel == "1") {
        iconStr += "<span class='ico16 l_risk_16'></span>";
    } else if (row.riskLevel == "2") {
        iconStr += "<span class='ico16 risk_16'></span>";
    } else if (row.riskLevel == "3") {
        iconStr += "<span class='ico16 h_risk_16'></span>";
    }
    iconStr += text;
    //附件图标
    if (row.has_attachments == true || row.has_attachments == "true") {
        iconStr += "<span class='ico16 affix_16'></span>";
    }
    return iconStr;
}

/**
 * 对完成率显示内容进行处理
 * @param text 列表显示信息
 * @param row 列对象
 */
function processFinishRateData(text, row) {
    var percent = parseInt(text);//百分数
    var color_class = "rateProgress_blue",fontClass="";
    if (row.status == "3"){//已延期
    	 color_class = "rateProgress_red"; 
    	 fontClass = "class='color_red'";
    }else if(row.status == "4"){//已完成
    	color_class = "rateProgress_green"; 
    }else if(row.status == "5"){//已取消
    	color_class = "rateProgress_gray";
    }
    return "<div class='common_rateProgress clearfix left margin_t_5'><span class='rateProgress_box'>"
    	+"<span class="+color_class+" style='width:"+percent+"%'></span></span><span "+fontClass+" style='line-height:1.2;'>"+
    	text +" %</span></div>";
}
/**
 * 设置初始化查询参数
 */
function setInitParams() {
    var isReport = getUrlPara("isReport");
    var obj = new Object();
    if(isReport == "1") {
        obj.listType = "All";
        obj.userId = $.ctx.CurrentUser.id;
        obj.condition = "status";
        obj.queryValue = "1,2,3,4,5";
        obj.isReport = "1";
    } else {
        obj.listType = "Parent";
        obj.userId = $.ctx.CurrentUser.id;
        obj.condition = "status";
        obj.queryValue = "1,2,3";
        obj.isFromParent = "1";
        var projectId = getUrlPara("projectId");
        var projectPhaseId= getUrlPara("projectPhaseId");
        if(projectId != null && projectId.length > 0){
            obj.projectId = projectId;
        }
        if(projectPhaseId !=null && projectPhaseId.length > 0){
            obj.projectPhaseId = projectPhaseId;
        }
        var tId = getUrlPara("taskId") == null ? "-1" : getUrlPara("taskId");
        if(tId != -1) {
            obj.taskId = tId;
        }
    }
    return obj;
}

/**
 * 设置查询条件
 */
function setQueryParams(returnValue) {
    var condition = returnValue.condition;
    var value = returnValue.value;
    var obj = new Object();
    if (listDataObj != null) {
        if (listDataObj.p.params) {
            obj = listDataObj.p.params;
            delete obj.isOverdue;
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
    if(obj.listType == "Sent") {
        obj.isParentList = 1;
    }
     if(condition=="status"&&value=="-1"){
    	//已超期
    	obj.isOverdue=1;
    	obj.queryValue="1,2";
    }
    $("#conditionText").val(obj.condition);
    $("#firstQueryValueText").val(obj.queryValue);
    $("#secondQueryValueText").val(obj.queryValue1);
    return obj;
}

/**
 * 初始化已选择的上级任务
 */
function initCheckedTask(){
    var parentId = getUrlPara("parentId");
    if(parentId != null && parentId.length > 0) {
        $("input[name=chk_task_id]").each(function(){
            if($(this).val() == parentId){
                $(this).prop("checked", true);
            }
        })
        $("#checked_id").val(parentId);
    }
}

/**
 * 绑定CheckBox事件
 */
function bindCheckBoxEvent () {
    $("input[name='chk_task_id']").bind("click" , operaCheckBox);
}

/**
 * 初始化页面展现
 */
function initUI() {
    var isReport = getUrlPara("isReport");
    if(isReport == "1") {
        $('#tab_area').addClass("hidden");
    }
}