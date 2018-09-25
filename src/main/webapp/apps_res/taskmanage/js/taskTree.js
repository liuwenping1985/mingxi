/**
 * 初始化工具条
 */
function initToolBar() {
    var toolbar = $("#toolbar").toolbar({
        searchHtml : '',
        toolbar : [ {
            id : "decompose",
            name : $.i18n('taskmanage.decompose'),
            className : "ico16 decomposition_16",
            click : function() {
                var viewType = getUrlPara("viewType");
                if(viewType == 2) {
                    var bool = window.parent.validateTask();
                    if(!bool) {
                        return;
                    }
                }
                decomposeTask();
            }
        }, {
            id : "delete",
            name : $.i18n('common.toolbar.delete.label'),
            className : "ico16 del_16",
            click : deleteTask
        } ]
    });
    isPageBtnEidt(toolbar);
}

/**
 * 页面按钮是否可以使用
 * @param obj 工具条对象
 */
function isPageBtnEidt(obj){
    var isBtnEidt = getUrlPara("isBtnEidt");
    if(isBtnEidt == 0) {
        obj.disabled("decompose");
        obj.disabled("delete");
    }
}
/**
 * 初始化列表数据
 */
function initListData() {
   listDataObj = $("#taskInfoList").ajaxgrid(
                    {
                        dblclick : doubleClickEvent,
                        render: render,
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
                                    width : '24%'
                                },  {
                                    display : $.i18n('taskmanage.weight'),
                                    name : 'weight',
                                    width : '5%'
                                }, {
                                    display : $.i18n('common.state.label'),
                                    name : 'status',
                                    width : '8%',
                                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
                                }, {
                                    display : $.i18n('taskmanage.finishrate'),
                                    name : 'finishRate',
                                    width : '18%'
                                }, {
                                    display : $.i18n('taskmanage.starttime'),
                                    name : 'plannedStartTime',
                                    width : '12%'
                                }, {
                                    display : $.i18n('common.date.endtime.label'),
                                    name : 'plannedEndTime',
                                    width : '12%'
                                }, {
                                    display : $.i18n('taskmanage.manager'),
                                    name : 'managerNames',
                                    width : '15%'
                                } ],
                        resizable:false,
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "taskInfoManager",
                        managerMethod : "selectTaskTree",
                        usepager: false,
                        onSuccess : filterDeletePurview
                    });
}

/**
 * 筛选删除权限
 */
function filterDeletePurview(){
    $("#taskInfoList").formobj({
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
        iconStr += "<span root='true' class='ico16 table_plus_16' onclick='toggleTree(this)' parentId='"+row.id+"'> </span>";
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
                iconStr = "<span style='width:"+margin+";display:inline-block'>&nbsp;</span><span class='row"+row.parentId+" treeNode'><span class='ico16 table_plus_16' onclick='toggleTree(this)' parentId='"+row.id+"'> </span>"+iconStr+"</span>";        
            } else {
                iconStr = "<span style='width:"+margin+";display:inline-block'>&nbsp;</span><span class='row"+row.parentId+" treeNode'>"+iconStr+"</span>";   
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
 * 获取列表中选中的id
 */
function getCheckedId() {
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
    return ids;
}

/**
 * 删除任务之前，判断选中的任务中是否包含有子任务
 * @param id 任务Id
 */
function checkIfChildExist(id) {
    var bool = false;
    var taskAjax = new taskAjaxManager();
    bool = taskAjax.checkIfChildExist(id);
    taskAjax = null;
    return bool;
}