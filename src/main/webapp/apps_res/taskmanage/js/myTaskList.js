function initToolBar() {
    toolbar = $("#toolbar").toolbar({
        toolbar : []
    });
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

function OK(){
        var rvArr = new Array();
        var array = new Array();
        var ids = null;
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
        if(ids == null || ids.length == 0) {
            return null;
        } else {
            rvArr[0] = ids;
            array[0] = rvArr;
            return array;
        }
}

/**
 * 初始化列表数据
 */
function initListData() {
    listDataObj = $("#taskInfoList").ajaxgrid(
                    {
                        render: render,
                        isHaveIframe:true,
                        resizable:false,
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
                                }, {
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
                        onSuccess:bindCheckBoxEvent,
                        singleSelect:false,
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "taskInfoManager",
                        managerMethod : "selectTaskList"
                    });
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
    return iconStr;
}