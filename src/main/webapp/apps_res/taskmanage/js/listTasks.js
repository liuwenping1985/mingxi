var taskAjax = new taskAjaxManager();
/**
 * 初始化工具条
 */
function initToolBar() {
    var toolbar = $("#toolbar").toolbar({
        borderTop:false,
        toolbar : [ {
            id : "forwardCol",
            name : $.i18n('report.queryReport.index_right.toolbar.synergy'),
            className : "ico16 forwarding_16",
            click : function() {
                taskListForwardCol();
            }
        }, {
            id : "importExcel",
            name : $.i18n('common.toolbar.exportExcel.label'),
            className : "ico16 export_excel_16",
            click : function() {
                exportToExcel();
            }
        }, {
            id : "print",
            name : $.i18n('common.toolbar.print.label'),
            className : "ico16 print_16",
            click : function() {
                printTaskList();
            }
        }]
    });
}

/**
 * 初始化列表数据
 */
function initListData() {
   var listDataObj = $("#taskInfoList").ajaxgrid(
                    {
                        render: render,
                        isHaveIframe:true,
                        colModel : [
                                {
                                    display : $.i18n('common.subject.label'),
                                    name : 'subject',
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
                                    width : '19%'
                                } ],
                        click : clickEvent,
                        resizable:false,
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "taskInfoManager",
                        managerMethod : "selectTaskList"
                    });
}

function clickEvent(data, r, c) {
    if (data) {
        if(hasViewRight(data.id)){
            viewTaskInfoDialog(data.id,0,1,1);
        }else{
            return;
        }
    }
}
function hasViewRight(id){
    var isView = taskAjax.validateTaskView(id);
    if(isView != null && !isView) {
       $.alert($.i18n('taskmanage.alert.no_auth_view_task'));
       return false;
    }
    return true;
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
    }
    if (col.name == "finishRate") {
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

//报表转发协同
function taskListForwardCol(){
    var contentHtml=""; 
    contentHtml=convertTable();
	contentHtml = contentHtml.replace(/task_rate adapt_w/g,'task_rate adapt_w display_none');
	contentHtml = contentHtml.replace(/right/g,'');
    $('#task_list_content').val(contentHtml);
    $("#queryConditionForm").attr("action", _ctxPath + "/taskmanage/taskinfo.do?method=taskForwardCol");
    $("#queryConditionForm").submit();
}
  
    /**
 * 导出excel
 */
function exportToExcel() {
    var condParams = "";
    var count = $("#taskInfoList")[0].rows.length;
    if (count < 1) {
        $.alert($.i18n('taskmanage.alert.no_records_excel'));
        return false;
    }
    var url = _ctxPath + "/taskmanage/taskinfo.do?method=exportToExcel";
    condParams = "&listType="+ getUrlPara("listType") +"&userId="+ getUrlPara("userId") +"&status=" + getUrlPara("status")
               + "&startTime="+ getUrlPara("startTime") +"&endTime="+ getUrlPara("endTime") +"&roleType="+ getUrlPara("roleType") 
               +"&source="+ getUrlPara("source")+"&isReport="+$("#isReport").val();
    url =  url + condParams;          
    $("#queryConditionForm").attr("action", url);
    $("#queryConditionForm").jsonSubmit({});
}

//打印列表
function printTaskList(){
    var printSubject ="";
    var printsub = "";
    printsub = "<center><span style='font-size:24px;line-height:24px;'>"+printsub.escapeHTML()+"</span><hr style='height:1px' class='Noprint'&lgt;</hr></center>";   
    var printColBody= $.i18n('performanceReport.queryMain_js.reportType.printTitle');
    var colBody ="";
    colBody = convertTable();   
    var printSubFrag = new PrintFragment(printColBody,printsub );
    var colBodyFrag= new PrintFragment(printSubject, colBody); 
    var cssList = new ArrayList();
    cssList.add("/apps_res/collaboration/css/collaboration.css");
      
    var pl = new ArrayList();
    //pl.add(printSubFrag);
    pl.add(colBodyFrag);
    printList(pl,cssList);
}

function convertTable(){
    var mxtgrid = $("#center");
    var str = "";
    if(mxtgrid.length > 0 ){
        var tableHeader = jQuery(".hDivBox thead");               
        var tableBody = jQuery(".bDiv tbody");
        var headerHtml =tableHeader.html();
        var bodyHtml = tableBody.html();
        if(headerHtml == null || headerHtml == 'null'){
            headerHtml ="";
        }
        if(bodyHtml == null || bodyHtml=='null'){
            bodyHtml="";
        }
        bodyHtml = bodyHtml.replace(/text_overflow/g,'word_break_all');
        str+="<table class='only_table edit_table font_size12' border='0' cellspacing='0' cellpadding='0'>"
        str+="<thead>";
        str+=headerHtml;
        str+="</thead>";
        str+="<tbody>";
        str+=bodyHtml;
        str+="</tbody>";
        str+="</table>";
    }
    return str;
}