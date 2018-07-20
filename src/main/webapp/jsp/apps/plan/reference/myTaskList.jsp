<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
var toolbar = null;
var searchobj = null;
function initToolBar() {
    toolbar = $("#toolbar").toolbar({
        toolbar : [ {
            id : "personal",
            name : "${ctp:i18n('taskmanage.personal.label')}",
            className : "ico16 personal_tasks_16",
            click : function() {
                chooseTaskList('Personal');
            }
        }, {
            id : "sent",
            name : "${ctp:i18n('taskmanage.sent.label')}",
            className : "ico16 has_been_distributed_16",
            click : function() {
                chooseTaskList('Sent');
            }
        }]
    });
    selectedBtnByTaskType('Personal');
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
 * 初始化搜索框
 */
function initSearchDiv() {
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
            text: "${ctp:i18n('common.subject.label')}",
            value: 'subject'
        }, {
            id: 'starttime',
            name: 'starttime',
            type: 'datemulti',
            text: "${ctp:i18n('common.date.begindate.label')}",
            value: 'plannedStartTime',
            ifFormat:"%Y-%m-%d",
            dateTime: true
        }, {
            id: 'endtime',
            name: 'endtime',
            type: 'datemulti',
            text: "${ctp:i18n('common.date.enddate.label')}",
            value: 'plannedEndTime',
            ifFormat:"%Y-%m-%d",
            dateTime: true
        }, {
            id: 'importent',
            name: 'importent',
            type: 'select',
            text: "${ctp:i18n('common.importance.label')}",
            value: 'importantLevel',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"
        }, {
            id: 'statusselect',
            name: 'statusselect',
            type: 'select',
            text: "${ctp:i18n('taskmanage.status')}",
            value: 'status',           
            items: [{
                text: "${ctp:i18n('taskmanage.status.unfinished')}",
                value: '1,2'
            },{
              text: "${ctp:i18n('taskmanage.status.notstarted')}",
              value: '1'
            },{
              text: "${ctp:i18n('taskmanage.status.marching')}",
              value: '2'
            },{
              text: "${ctp:i18n('taskmanage.overdue.yes')}",
              value: '-1'
            }]
        }, {
            id: 'risk',
            name: 'risk',
            type: 'select',
            text: "${ctp:i18n('taskmanage.risk')}",
            value: 'riskLevel',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"
        }, {
            id: 'createUserText',
            name: 'createUserText',
            type: 'input',
            text: "${ctp:i18n('common.creater.label')}",
            value: 'createUser'
        }, {
            id: 'managersText',
            name: 'managersText',
            type: 'input',
            text: "${ctp:i18n('taskmanage.manager')}",
            value: 'managers'
        }, {
            id: 'participatorsText',
            name: 'participatorsText',
            type: 'input',
            text: "${ctp:i18n('taskmanage.participator')}",
            value: 'participators'
        }, {
            id: 'inspectorsText',
            name: 'inspectorsText',
            type: 'input',
            text: "${ctp:i18n('taskmanage.inspector')}",
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
                        resizable:false,
                        colModel : [
                                {
                                    display : 'id',
                                    name : 'id',
                                    width : '5%',
                                    align : 'center',
                                    type : 'checkbox'
                                }, {
                                    display : "${ctp:i18n('common.subject.label')}",
                                    name : 'subject',
                                    sortable : true,
                                    width : '25%'
                                }, {
                                    display : "${ctp:i18n('taskmanage.weight')}",
                                    name : 'weight',
                                    sortable : true,
                                    width : '5%'
                                }, {
                                    display : "${ctp:i18n('common.state.label')}",
                                    name : 'status',
                                    width : '8%',
                                    sortable : true,
                                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
                                }, {
                                    display : "${ctp:i18n('taskmanage.finishrate')}",
                                    name : 'finishRate',
                                    sortable : true,
                                    sortType : 'number',
                                    width : '18%'
                                }, {
                                    display : "${ctp:i18n('common.date.begindate.label')}",
                                    name : 'plannedStartTime',
                                    sortable : true,
                                    width : '12%'
                                }, {
                                    display : "${ctp:i18n('common.date.enddate.label')}",
                                    name : 'plannedEndTime',
                                    sortable : true,
                                    width : '12%'
                                }, {
                                    display : "${ctp:i18n('taskmanage.manager')}",
                                    name : 'managerNames',
                                    sortable : true,
                                    width : '14%'
                                } ],
                        dblclick : doubleClickEvent,        
                        onSuccess:bindCheckBoxEvent,
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "taskInfoManager",
                        managerMethod : "selectTaskList",
                        sortname: "createTime",
                        sortorder: "desc"
                    });
}
function doubleClickEvent(data, r, c) {
    viewTaskInfo(data.id,0,1);
}
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
function processFinishRateData(text,row){
    var percent=parseInt(text);//百分数
    var color_class="rate_process";
    if(row.status == "4") color_class="rate_filish"; //已完成
    if(row.status == "3") color_class="rate_delay"; //已延期
    if(row.status == "5") color_class="rate_canel"; //已取消
    return "<span class='right margin_l_5' style='width:40px;'>"+ text+"%</span><p class='task_rate adapt_w' style=''><a href='#' class='"+color_class+"' style='width:"+percent+"%;'></a></p>";
}

function taskNameIconDisplay(text,row){
    var iconStr = "";
    //根节点图标
    if(row.haschild==true && row.ischild != true) {    
        iconStr += "<span root='true' class='ico16 table_add_16' onclick='toggleTree(this)' parentId='"+row.id+"' index='"+row.index+"'> </span>";
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
                iconStr = "<a href='javascript:void(0)' class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";'><span class='ico16 table_add_16' onclick='toggleTree(this)' parentId='"+row.id+"' index='"+row.index+"'> </span>"+iconStr+"</a>";        
            } else {
                iconStr = "<a href='javascript:void(0)'  class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";'>"+iconStr+"</a>";   
            }
    }
    return iconStr;
}

/**
 * 设置初始化查询参数
 */ 
function setInitParams() {
    var obj = new Object();
    obj.listType = $("#list_type").val();
    obj.userId = $.ctx.CurrentUser.id;
    obj.condition = "status";
    obj.queryValue = "1,2,3";
    return obj;
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
    $("#list_type").val(taskType);
}

/**
 * 根据任务类型选择任务的显示内容
 * @param type 任务类型
 */
function chooseTaskList(type) {
    selectedBtnByTaskType(type);
    var obj = setInitParams();
    $("#taskInfoList").ajaxgridLoad(obj);
    searchobj.g.setCondition('statusselect','1,2,3');
}
</script>

<script type="text/javascript">
    $(document).ready(function() {
        initSearchDiv();
        initToolBar();
        initData();
    }); 
</script>
<body>
 	<div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
            <input type="hidden" id="list_type" name="list_type" />
            <div id="toolbar"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="taskInfoList" class="flexme3" style="display: none"></table>
        </div>
   	</div>
</body>
</html>