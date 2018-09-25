var idStr = getUrlPara("id");
var isUpdate = getUrlPara("isUpdate");
var isFeedback = getUrlPara("sourceFeedback");
var isLocation = getUrlPara("msgLocation");
var from = getUrlPara("from");
/**
 * 关闭弹出窗口执行的事件
 * 
 */
function CLOSE(obj){
    var bool = false;
    try{        
        var updateIframeObj = $("#taskDetail_content_iframe").contents().find("#update_iframe");
        if(updateIframeObj.length >0 && updateIframeObj.attr("src").indexOf("updateTask") > -1) {
            $.confirm({
                'msg' : $.i18n('taskmanage.save.confirm'),
                ok_fn : function() {
                    if(updateIframeObj[0].contentWindow.updateSubmit) {
                        var bool = updateIframeObj[0].contentWindow.updateSubmit(obj);
                        if(bool == false || bool == "false") {
                            return;
                        }
                        if(obj.runFunc) {
	                        if(obj.sectionId) {
	                            obj.runFunc(obj.sectionId);
	                        } else {
	                            obj.runFunc();
	                        }
                    	}
                        if ((navigator.userAgent.indexOf('MSIE') >= 0)||document.all) {		                   
                        	if(obj.dialogObj) {
                        		obj.dialogObj.close();
                        	}
                        }
                    }
                    
                },
                cancel_fn : function() {
                    if(obj.dialogObj) {
                        obj.dialogObj.close();
                    }
                }
            });
        } else {
            if(isUpdate == 1 || $("#is_update").val() == "1") {
                bool = true;
                if(obj.runFunc) {
                    if(obj.sectionId) {
                        obj.runFunc(obj.sectionId);
                    } else {
                        obj.runFunc();
                    }
                }
                if(obj.dialogObj) {
                    obj.dialogObj.close();
                }
            } else {
                if(obj.dialogObj) {
                    obj.dialogObj.close();
                }
            }
        }
    } catch (e) {}
    return bool;
}

/**
 * 改变iframe显示页面地址
 * @param url 页面路径地址
 */
function contentIframeSrc(url) {
    var contentIframe = $("#taskDetail_content_iframe");
    contentIframe.attr("src", url);
}

/**
 * 选择对应功能页签切换
 * @param event 按钮事件
 */
function changeMenuTab(event) {
    var url = $(event).attr("url");
    $("#tab_list").find("li.current").removeClass("current").find("a").removeClass("border_b");
    $(event).addClass("border_b");
    $(event).parent().addClass("current");
    contentIframeSrc(url);
}
/**
 * 初始化显示任务详细信息的页面
 */
function initTaskInfoDatailPage() {
    var url;
    var feedBackId = getUrlPara("feedBackId");
    if(isFeedback == 1 || isLocation == "Feedback") {
        $("#tab_list").find("li.current").removeClass("current").find("a").removeClass("border_b");
        $("#tab_list").find("li").eq(2).find("a").addClass("border_b");
        $("#tab_list").find("li").eq(2).addClass("current");
        url = $("#tab_list").find("li").eq(2).find("a").attr("url");
        if(feedBackId != null) {
          url += "&feedBackId=" + feedBackId;
        }
    } else {
        url = $("#tab_list").find("li").eq(0).find("a").attr("url");
    }
    contentIframeSrc(url);
    //OA-69401 IE7：目标管理--工作任务--我的任务，点击任务回复按钮无反应
    $("#task_reply_btn").bind("click",showReplyForm);
}

function showReplyForm(){
    $("#replyFormArea").slideDown();
}
function submitReplyForm(){
    var contentStr = $("#replyContent").val();
    var isValidate =  validateTask();
    if(isValidate == false) {
      return false;
    }
    if(contentStr==""||contentStr.length==0){
      $.alert($.i18n('taskmanage.alert.enter_reply_content'));
      return false;
    }
    if(contentStr.length > 500){
        $.alert($.i18n('taskmanage.alert.reply_content_more_than_500',contentStr.length));
        return false;
    }
    
    $("#replyForm #content").val(contentStr);
    $("#replyForm #pushMessage").val($("#sendMessage")[0].checked);
    var obj = $("#replyForm").formobj();
    var tmgr = new taskInfoManager();
    tmgr.saveComment(obj,
        {
            success:function(ret){
                var comment =$.parseJSON(ret);
                $("#replyFormArea").slideUp();
                $("#replyContent").val("");
                showNewComment(comment);
            }
        });

    
}
function closeReplyForm(){
    $("#replyContent").val("");
    $("#replyFormArea").slideUp();
}
function showNewComment(comment){
    var divStr="<ul style='background: #fff;margin-bottom:10px;' class=' border_all  font_size12'> <li class='padding_5 border_b bg_color' style='height:20px;background:#ebf3fd;'><span class='left'><a class='showPeopleCard color_blue' onclick='$.PeopleCard({memberId:\""
           +comment.createId+"\"})'>"
           +comment.createName
           +"</a>"
           +"<span class='w1em'></span><span class='align_right color_gray2'>"
           +comment.createDateStr
           +"</span></span><span onclick=\"commentShowReply('"
           +comment.id+"')\"; class='add_new right padding_t_5'><a href='javascript:void(0)'>"+ $.i18n("taskmanage.reply.action") +"</a></span></li>"
           +"<input type='hidden' id='mcp_"+comment.id+"' value='"
           +comment.maxChildPath+"'>"
           +"<input type='hidden' id='cp_"+comment.id+"' value='"
           +comment.path+"'><li style='background: #fff;' class='padding_5 word_break_all'>"
           +comment.escapedContent+"</li><li id='replyContent_"
           +comment.id+"' class='padding_5 display_none'><div class='padding_lr_10 bg_color padding_tb_5'  style='background:#ebf3fd; border-top:1px solid #b6b6b6; border-right:1px solid #b6b6b6; border-left:1px solid #b6b6b6;'>"+ $.i18n("collaboration.opinion.replyOpinion") +"</div></li><li id='reply_"
           +comment.id+"' class='form_area display_none w90b'><input type='hidden' id='pid' value='"
           +comment.id+"'><input type='hidden' id='clevel' value='"
           +comment.clevel+1+"'><input type='hidden' id='path'><input type='hidden' id='moduleType' value='"
           +comment.moduleType+"'><input type='hidden' id='moduleId' value='"
           +comment.moduleId+"'><input type='hidden' id='ctype' value='1'><input type='hidden' id='affairId' value='"+$("#contxt_affairId").val()
           +"'><div class='common_txtbox clearfix margin_l_5'><textarea style='resize: none;' id='content' name='回复内容' class='validate' validate='notNull:true,maxLength:500' cols='35' rows='5'></textarea></div>"
           +"<div class='common_checkbox_box clearfix margin_t_5'><label class='margin_l_5 hand'><input id='pushMessage' class='radio_com' name='pushMessage' value='true' type='checkbox'>发送消息</label>"
           +"<span class='green right'>500个字以内</span></div><div class='bt' align='right'><a class='common_button common_button_gray padding_5 margin_r_5 margin_b_5'  onclick='commentReply(\""
           +comment.id+"\")' href='javascript:void(0)'>确定</a><a onclick='commentHideReply(\""
           +comment.id+"\")' class='common_button common_button_gray padding_5 margin_b_5' href='javascript:void(0)'>取消</a></div></li></ul>";
    $("#replyAreaDiv").prepend(divStr);
    $("#replyCount").html(parseInt($("#replyCount").html())+1);
}

/**
 * 判断如果没有检查人的情况下，隐藏检查人显示
 */
function judgeHiddenInspectors() {
    var inspectors = $("#inspectors_name_text").val();
    if(inspectors.length == 0) {
        $("#inspectors").addClass("hidden");
    }
}
function initPersonName() {
    if($("#manager_name_text").val().length > 0) {
        $("#managerNames").html($("#manager_name_text").val());
        $("#managerNames").attr("title", $("#manager_name_text").val());
    }
    if($("#inspectors_name_text").val().length > 0) {
        $("#inspectors_name").html($("#inspectors_name_text").val());
        $("#inspectors_name").attr("title", $("#inspectors_name_text").val());
    }
}

function closeDialog1(){
    var dialog = window.parentDialogObj['viewTask'];
    if(dialog.close) {
        dialog.close();
    }
}

function loadTaskDetail (){
    var taskId = getUrlPara("id");
    var taskAjax = new taskAjaxManager();
    var obj = taskAjax.findTaskDetail(taskId);
    $("#head_task_name").html(obj.head_task_name);
    $("#status_text").html(obj.status_text);
    $("#finish_rate").html(obj.finish_rate);
    $("#finish_rate_text").html(obj.finish_rate_text);
    $("#manager_name_text").val(obj.manager_name_text);
    $("#actual_tasktime_text").html(obj.actual_tasktime_text);
    $("#inspectors_name_text").val(obj.inspectors_name_text);
    initPersonName();
}
  
function closeDialog() {
    var viewType = getUrlPara("viewType") == null ? "2" : getUrlPara("viewType");
    if(viewType == 2) {
        try {
            var iframeObj = getCtpTop().frames["main"].frames["content_iframe"];
            if(iframeObj) {
                iframeObj.refreshPage();
            }
        }catch (e) {}
        if(closeAllDlg){
            closeAllDlg(getCtpTop());
        }
    } else {
        window.parent.refreshPage();
        if(getCtpTop().$('.dialog_box') && getCtpTop().$('.dialog_box').length > 0) {
            closeAllDlg(getCtpTop());
        }
    }
}

function validateTask() {
    return validateTaskInfo(idStr, from, closeDialog);
}

function initUIEvent(){
    $("#taskDetail_content_iframe").height($("#static_layout_body").height());
    $(window).resize(function(){
        $("#taskDetail_content_iframe").height($("#static_layout_body").height());
    });
    var viewType = getUrlPara("viewType") == null ? "2" : getUrlPara("viewType");
    $("body").bind("click", validateTask);
    if($("#is_task_reply").val() == 0) {
        $("#task_reply_btn").addClass("common_button_disable");
        $("#task_reply_btn").attr("onclick","");
    } else {
        $("#task_reply_btn").removeClass("common_button_disable");
        $("#task_reply_btn").attr("onclick","showReplyForm()");
    }
    var isFromTree = getUrlPara("isFromTree");
    if (isFromTree == 2) {
        var treeObj = $("#tab_list").find("li").eq(1).find("a");
        treeObj.removeAttr("onclick");
        treeObj.addClass("disable");
    }
}