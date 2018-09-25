var listDataObj;

function initLayout() {
    new MxtLayout({
        'id' : 'layout',
        'northArea' : {
            'id' : 'north',
            'height' : 35,
            'sprit' : false,
            'border' : false
        },
        'centerArea' : {
            'id' : 'center',
            'border' : false,
            'minHeight' : 20
        }
    });
}

function initSearch() {
    var searchobj = $
            .searchCondition({
                top : 5,
                right : 5,
                searchHandler : function() {
                    var returnValue = searchobj.g.getReturnValue();
                    if (returnValue != null) {
                        var obj = setQueryParams(returnValue);
                        $("#departmentTask").ajaxgridLoad(obj);
                    }
                },
                conditions : [
                        {
                            id : 'title',
                            name : 'title',
                            type : 'input',
                            text : $.i18n('common.subject.label'),
                            value : 'subject'
                        },
                        {
                            id : 'starttime',
                            name : 'starttime',
                            type : 'datemulti',
                            text : $.i18n('taskmanage.starttime'),
                            value : 'plannedStartTime',
                            ifFormat : "%Y-%m-%d",
                            dateTime : false
                        },
                        {
                            id : 'endtime',
                            name : 'endtime',
                            type : 'datemulti',
                            text : $.i18n('common.date.endtime.label'),
                            value : 'plannedEndTime',
                            ifFormat : "%Y-%m-%d",
                            dateTime : false
                        },
                        {
                            id : 'importent',
                            name : 'importent',
                            type : 'select',
                            text : $.i18n('common.importance.label'),
                            value : 'importantLevel',
                            codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"
                        },
                        {
                            id : 'statusselect',
                            name : 'statusselect',
                            type : 'select',
                            text : $.i18n('taskmanage.status'),
                            value : 'status',
                            items : [ {
                                text : $.i18n('taskmanage.status.unfinished'),
                                value : '1,2,3'
                            }, {
                                text : $.i18n('taskmanage.status.notstarted'),
                                value : '1'
                            }, {
                                text : $.i18n('taskmanage.status.marching'),
                                value : '2'
                            }, {
                                text : $.i18n('taskmanage.status.delayed'),
                                value : '3'
                            } ]
                        },
                        {
                            id : 'risk',
                            name : 'risk',
                            type : 'select',
                            text : $.i18n('taskmanage.risk'),
                            value : 'riskLevel',
                            codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"
                        },
                        {
                            id : 'createUserText',
                            name : 'createUserText',
                            type : 'input',
                            text : $.i18n('common.creater.label'),
                            value : 'createUser'
                        },
                        {
                            id : 'managersText',
                            name : 'managersText',
                            type : 'input',
                            text : $.i18n('taskmanage.manager'),
                            value : 'managers'
                        },
                        {
                            id : 'participatorsText',
                            name : 'participatorsText',
                            type : 'input',
                            text : $.i18n('taskmanage.participator'),
                            value : 'participators'
                        }, {
                            id : 'inspectorsText',
                            name : 'inspectorsText',
                            type : 'input',
                            text : $.i18n('taskmanage.inspector'),
                            value : 'inspectors'
                        } ]
            });
    searchobj.g.setCondition('statusselect', '1,2,3');
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
    if (condition.length == 0) {
        obj.condition = "none";
        obj.queryValue = "";
    }
    return obj;
}

/**
 * 设置初始化查询参数
 */
function setInitParams() {
    var obj = new Object();
    obj.listType = "Department";
    obj.depMemberIds = $("#dep_member_id").val();
    obj.userId = $.ctx.CurrentUser.id;
    return obj;
}

function initDataList() {
    listDataObj = $("#departmentTask")
            .ajaxgrid(
                    {
                        click : dblclk,//单击事件
                        render : rend,
                        resizable : false,
                        colModel : [
                                {
                                    display : $.i18n('common.subject.label'),
                                    name : 'subject',
                                    sortable : true,
                                    width : '25%'
                                },
                                {
                                    display : $.i18n('taskmanage.weight'),
                                    name : 'weight',
                                    sortable : true,
                                    width : '5%'
                                },
                                {
                                    display : $.i18n('common.state.label'),
                                    name : 'status',
                                    width : '10%',
                                    sortable : true,
                                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
                                },
                                {
                                    display : $.i18n('taskmanage.finishrate'),
                                    name : 'finishRate',
                                    sortable : true,
                                    width : '18%'
                                },
                                {
                                    display : $.i18n('taskmanage.starttime'),
                                    name : 'plannedStartTime',
                                    sortable : true,
                                    width : '12%'
                                },
                                {
                                    display : $.i18n('common.date.endtime.label'),
                                    name : 'plannedEndTime',
                                    sortable : true,
                                    width : '12%'
                                },
                                {
                                    display : $.i18n('taskmanage.manager'),
                                    name : 'managerNames',
                                    sortable : true,
                                    width : '17%'
                                } ],
                        parentId : $('.layout_center').eq(0).attr('id'),
                        managerName : "taskInfoManager",
                        managerMethod : "selectTaskList"
                    });
}

function rend(text, row, rowIndex, colIndex, col) {
    if (col.name == "subject") {
        return taskNameIconDisplay(text, row);
    }
    if (col.name == "finishRate") {
        return processFinishRateData(text, row);
    } else {
        return text;
    }
}

function dblclk(data, r, c, id) {
    if (id) {
        var idStr;
        if (id.indexOf("row") > -1) {
            idStr = id.substring(3, id.length);
        }
        viewTaskInfoDialog(idStr);
    } else if (data) {
        viewTaskInfoDialog(data.id);
    }
}

/**
 * 任务标题中所显示图标处理
 * @param text 列表显示信息
 * @param row 列对象
 */
function taskNameIconDisplay(text, row) {
    var iconStr = "";
    //根节点图标
    if (row.haschild == true && row.ischild != true) {
        iconStr += "<span root='true' class='ico16 table_add_16' onclick='toggleTree(this)' parentId='"
                + row.id + "' index='" + row.index + "'> </span>";
    }
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
    //判断是否是子节点
    if (row.ischild == true) {
        var index;
        if (row.index > 0) {
            index = row.index - 1;
        } else {
            index = row.index;
        }
        var margin = index * 20 + "px";
        if (row.haschild == true) {//判断是否存在二级子节点
            iconStr = "<a href='javascript:void(0)' class='row"
                    + row.parentId
                    + " treeNode' style='margin-left:"
                    + margin
                    + ";'><span class='ico16 table_add_16' onclick='toggleTree(this)' parentId='"
                    + row.id + "' index='" + row.index + "'> </span>"
                    + iconStr + "</a>";
        } else {
            iconStr = "<a href='javascript:void(0)'  class='row"
                    + row.parentId + " treeNode' style='margin-left:"
                    + margin + ";'>" + iconStr + "</a>";
        }
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
    var color_class = "rate_process";
    if (row.status == "4")
        color_class = "rate_filish"; //已完成
    if (row.status == "3")
        color_class = "rate_delay"; //已延期
    if (row.status == "5")
        color_class = "rate_canel"; //已取消
    return "<span class='right margin_l_5' style='width:40px;'>"
            + text
            + "%</span><p class='task_rate adapt_w' style=''><a href='#' class='"
            + color_class + "' style='width:" + percent + "%;'></a></p>";
}

/**
 * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
 * @param id 任务编号
 */
function viewTaskInfoByIframe(id) {
    var taskAjax = new taskAjaxManager();
    var isTask = taskAjax.validateTask(id);
    if (isTask != null && !isTask) {
        $.alert({
            'msg' : $.i18n('taskmanage.task_deleted'),
            ok_fn : function() {
                $("#departmentTask").ajaxgridLoad();
            }
        });
        return;
    }
    $("#taskinfo_iframe").attr(
            "src",
            _ctxPath + '/taskmanage/taskinfo.do?method=taskDetailIndex&id='
                    + id + "&viewType=1");
}

/**
 * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
 * @param id 任务编号
 */
function viewTaskInfoDialog(id) {
    var title = $.i18n('taskmanage.content');
    var taskAjax = new taskAjaxManager();
    var isTask = taskAjax.validateTask(id);
    if (isTask != null && !isTask) {
        $.alert({
            'msg' : $.i18n('taskmanage.task_deleted'),
            ok_fn : function() {
                $("#departmentTask").ajaxgridLoad();
            }
        });
        return;
    }
    var isView = taskAjax.validateTaskView(id);
    if(!isView) {
       $.alert($.i18n('taskmanage.alert.no_auth_view_task'));
       return;
    }
    dialog = $
            .dialog({
                url : _ctxPath
                        + '/taskmanage/taskinfo.do?method=taskDetailIndex&id='
                        + id +"&from=departmentTask",
                width : $(getCtpTop()).width() - 100,
                height : $(getCtpTop()).height() - 100,
                title : title,
                targetWindow : getCtpTop(),
                closeParam : {
                    'show' : true,
                    autoClose : false,
                    handler : function() {
                        dialog.getClose({'dialogObj' : dialog ,'runFunc' : refreshGrid});
                    }
                },
                buttons : [ {
                    text : "关闭",
                    handler : function() {
                        dialog.getClose({'dialogObj' : dialog ,'runFunc' : refreshGrid});
                    }
                } ]
            });
}

function refreshGrid() {
    $("#departmentTask").ajaxgridLoad();
}