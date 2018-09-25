function OK(obj) {
        var selectStr = getCheckedBox();
        return selectStr;
}

/**
 * 获取选中的任务
 */
function getCheckedBox(){
    var checked = "";
    $("input[name='chk_task_id']:checked").each(function(){ 
        checked = $(this).val();
    });
    return checked;
}

/**
 * 选择对应的任务
 */
function operaCheckBox(e){
    var checkedObj = $(e.target).closest("input");
    if ( e && e.stopPropagation ) {
        e.stopPropagation();
    } else {
        //否则，我们需要使用IE的方式来取消事件冒泡
        window.event.cancelBubble = true;
    }
    $("input[name=chk_task_id]").each(function(){
        $(this).prop("checked", false);
    });
    if($("#checked_id").val() != checkedObj.val()){
        checkedObj.prop("checked",true);
        $("#checked_id").val(checkedObj.val());
    }else{
        $("#checked_id").val("");
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
        minSize : 0,
        callback : function(ret) {
            if (ret) {
                $("#" + textId).val(ret.text);
                $("#" + valueId).val(ret.value);
            }
        }
    });
}

/**
 * 切换页签
 * @param event 页签事件对象
 */
function changeTab(event) {
    var val = $(event).attr("value");
    $("#tab_list").find("li.current").removeClass("current");
    $(event).parent().addClass("current");
    changeDataList(val);
}

/**
 * 切换列表数据内容
 * @param val 数据参数
 */
function changeDataList(val) {
    var obj = new Object();
    obj.listType = val;
    obj.userId = $.ctx.CurrentUser.id;
    obj.condition = "status";
    obj.queryValue = "1,2,3";
    obj.isFromParent = "1";
    var projectId = getUrlPara("projectId");
    var projectPhaseId= getUrlPara("projectPhaseId");
    if(projectId != null && projectId.length > 0){
        obj.projectId = projectId;
    }
    if(projectPhaseId != null && projectPhaseId.length > 0){
        obj.projectPhaseId = projectPhaseId;
    }
    var tId = getUrlPara("taskId") == null ? "-1" : getUrlPara("taskId");
    if(tId != -1) {
        obj.taskId = tId;
    }
    $("#taskInfoList").ajaxgridLoad(obj);
    if(searchobj && searchobj != null) {
        searchobj.g.setCondition('statusselect','1,2,3');
    }
}