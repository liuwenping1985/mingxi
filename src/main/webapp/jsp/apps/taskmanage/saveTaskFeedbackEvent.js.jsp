<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-22 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    function OK(obj) {
    
      return saveTaskFeedback(obj);
    }
    /**
     * 保存汇报信息
     */
    function saveTaskFeedback(obj) {
        var valid = $("#task_feedback_form").validate();
        if ((valid == true || valid == "true") && checkTaskContetnNum(500)) {
    		var content = '${ctp:i18n("taskmanage.feedback.input.content")}'+"("+'${ctp:i18n("taskmanage.feeback.range_500")}'+")";
			if($("#content").val() == content){
				$("#content").val('');
			}
            $("#task_feedback_form").jsonSubmit({
                domains : [ "domain_task_feedback" ],
                debug : false,
                callback : function(res) {
                    if(res.indexOf("1") > -1 ) {
                        res = 1;
                    }
                    if (res == 1) {
                      if(isPortal == "1") {
                        if(obj && obj != null) {
                          obj.dialogObj.close();
                          obj.stHandler.reload(obj.stId,true);
                        }
                      } else if(isDialog == "1") {
						window.dialogArguments.callBack();
						window.parentDialogObj['newFeedbackDialog'].close();
                      } else {
                        window.parent.refreshPage();
                      }
                    }
                }
            });
            return valid;
        }else{
        	return valid
        }
    }
    
    /**
     * 根据任务状态改变完成率
     */    
    function setFinishRate() {
        var taskId = '${param.taskId}';
        var taskAjax = new taskAjaxManager();
        if (taskAjax.checkIfChildExist(taskId)&&$("#canhandwrite").val()=="0") {
            var value = $("#old_status").val();
            if (value == '1' || value == '4') {                
                $.alert("${ctp:i18n('taskmanage.alret.feedback.not_allowed_2')}");
                $("#status").val($("#old_status").val());
                return;
            }
            var newValue = $("#status").val();
            var finishrateVal = $("#finishrate_text").val();
            if ((newValue == '1' && finishrateVal != 0) || newValue == '4') {                
                $.alert("${ctp:i18n('taskmanage.alret.feedback.not_allowed')}");
                $("#status").val($("#old_status").val());
                return;
            }
        } else if($("#canhandwrite").val()=="1"){
            var value = $("#status").val();
            if (value == '1') {
            $("#finishrate_text").val(0);
                $("#finishrate_text").attr({
                    "disabled" : "disabled"
                });
/*                var newValue = $("#status").val();
            	var finishrateVal = $("#finishrate_text").val();
            	if (newValue == '1' && finishrateVal != 0) {                
                $.alert("${ctp:i18n('taskmanage.alret.feedback.not_allowed')}");
                $("#status").val($("#old_status").val());
                return;
            }*/	
            } else if (value == '4') {
                $("#finishrate_text").val(100);
                $("#finishrate_text").attr({
                    "disabled" : "disabled"
                });
            } else {
                if ($("#finishrate_text").val() == 100) {
                    $("#finishrate_text").val(0);
                }
                $("#finishrate_text").removeAttr("disabled").removeAttr(
                        "readonly");
            }
        }else{
        	var value = $("#status").val();
            if (value == '1') {
                $("#finishrate_text").val(0);
                $("#finishrate_text").attr({
                    "disabled" : "disabled"
                });
            } else if (value == '4') {
                $("#finishrate_text").val(100);
                $("#finishrate_text").attr({
                    "disabled" : "disabled"
                });
            } else {
                if ($("#finishrate_text").val() == 100) {
                    $("#finishrate_text").val(0);
                }
                $("#finishrate_text").removeAttr("disabled").removeAttr(
                        "readonly");
            }
        }
    }

    /**
     * 根据完成率改变任务状态
     */
    function setStatus() {
        var value = $("#finishrate_text").val();
        if (value == 100) {
            $("#status").val(4);
        } else {
            if ($("#status").val() == 4) {
                if(value == 0) {
                    $("#status").val(1);
                } else {
                    $("#status").val(2);
                }
            }
        }
    }
    
/**
 * 缩放
 */
function fnToggleDialog(){
	var em = $("#topEm");
	if(em.hasClass("arrow_2_t")){
		em.removeClass("arrow_2_t").addClass("arrow_2_b");
		$(".extendClass").hide();
		fnGetDialog(105);
	}else{
		em.removeClass("arrow_2_b").addClass("arrow_2_t");
		$(".extendClass").show();
		fnGetDialog(360);
	}
}


function fnGetDialog(dialogHeight){
	try {
		var dialog = window.parent.document.getElementById("task_feedback_iframe");
		dialog.setAttribute("height",dialogHeight+50);
		$("#feadbackList",window.parent.document).height($(".tabs_area_body",window.parent.document).height()+dialogHeight+50);
    	$("#feedbackAreaIframe",window.parent.parent.document).height($("#feadbackList",window.parent.document).height());
    	$("#tabs_area",window.parent.parent.document).height($("#feadbackList",window.parent.document).height());
	} catch (e) {}
	if (!dialog) {
		try {
			var dialog = window.parentDialogObj["newFeedbackDialog"];
			dialog.reSize({height:dialogHeight,positionFix:true});
		} catch (e) {}
	}
	return dialog;
}

function doFeebackDesc(type){
	var content = '${ctp:i18n("taskmanage.feedback.input.content")}'+"("+'${ctp:i18n("taskmanage.feeback.range_500")}'+")";
	if(0==type && $("#content").val() == content){
		$("#content").val('');
		$("#content").removeClass("color_gray");
	}else if(1==type && $("#content").val().trim() == ''){
		$("#content").val(content);
		$("#content").addClass("color_gray");
	}
}
</script>