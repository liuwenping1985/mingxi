	var taskAjax = new taskAjaxManager();
	function OK(obj) {
      return saveTaskFeedback(obj);
    }
	/**
	 * 保存汇报信息
	 */
	function saveTaskFeedback(obj) {
		// 置灰按钮
		$("#btn_ok").removeClass("common_button_emphasize").addClass("common_button_gray").unbind("click");
		var valid = $("#task_feedback_form").validate();
		if ((valid == true || valid == "true") && checkTaskContetnNum(500)) {
			var content = $.i18n("taskmanage.feedback.input.content") + "(" + $.i18n("taskmanage.feeback.range_500") + ")";
			if ($("#content").val() == content) {
				$("#content").val('');
			}
			/**
			 * 需求单：KFZX2016120526277
			 * 现在方案是：
			 * 1. 是否填写了说明，填写了说明则直接生成汇报，否则走2；
			 * 2. 任务状态, 完成率, 风险, 当前耗时”是否发生改变，如果有改变则直接生成汇报，否则走3；
			 * 3. 给出提示框【本次进展内容与上次完全一致，是否提交？】，若【确定】则提交，否则取消当前操作
			 */
			var isMistack = $("#content").val().length == 0;
			if (isMistack) {//状态
				isMistack = $("#back_status").val() == $("#status").val();
			}
			if (isMistack) {//完成率
				isMistack = $("#back_finishrate_text").val() == $("#finishrate_text").val();
			}
			if (isMistack) {//风险
				isMistack = $("#back_select_risk").val() == $("#select_risk").val();
			}
			if (isMistack) {//当前耗时
				isMistack = $("#back_elapsed_time_text").val() == $("#elapsed_time_text").val();
			}
			if (isMistack) {
				var confirm = $.confirm({
					msg: $.i18n('taskmanage.confirm.feedback.add'),
					ok_fn: function () {
						submitFeedback(obj);
					},
					cancel_fn:function(){
						$("#btn_ok").removeClass("common_button_gray").addClass("common_button_emphasize").unbind("click").bind("click", saveTaskFeedback);
					}
				});
			} else {
				submitFeedback(obj);
			}
			return valid;
		} else {
			$("#btn_ok").removeClass("common_button_gray").addClass("common_button_emphasize").unbind("click").bind("click", saveTaskFeedback);
			return valid;
		}
	}
	/*提交汇报表单*/
	function submitFeedback(obj){
		$("#task_feedback_form").jsonSubmit({
			domains : [ "domain_task_feedback" ],
			debug : false,
			callback : function(res) {
				if (res.indexOf("1") > -1) {
					res = 1;
				}
				if (res == 1) {
					var isDialog = $("#isDialog").val();
					var isPortal = $("#isPortal").val();
					if (isPortal == "1") {
						if (obj && obj != null) {
							obj.dialogObj.close();
							if ("projectTaskSection" == obj.stId) {
								obj.stHandler.reload("projectMemberTaskSection", true);
								obj.stHandler.reload("projectTaskStatusSection", true);
								obj.stHandler.reload("projectOverdueTaskSection", true);
								obj.stHandler.reload("projectTaskOverviewSection", true);
							}
							obj.stHandler.reload(obj.stId, true);
						}
					} else if (isDialog == "1") {
						window.dialogArguments.callBack();
						window.parentDialogObj['newFeedbackDialog'].close();
					} else {
						window.parent.refreshPage();
					}
				}
			}
		});
	}
    
    /**
     * 根据任务状态改变完成率
     */    
    function setFinishRate() {
        var taskId = $("#task_id").val();
//        if (taskAjax.checkIfChildExist(taskId)&&$("#canhandwrite").val()=="0") {
//           var value = $("#old_status").val();
//            $("#status").val(value);
//            if (value == '1' || value == '4') {                
//                $.alert($.i18n('taskmanage.alret.feedback.not_allowed_2'));
//                $("#status").val($("#old_status").val());
//                return;
//            }
//            var newValue = $("#status").val();
//            var finishrateVal = $("#finishrate_text").val();
//            if ((newValue == '1' && finishrateVal != 0) || newValue == '4') {                
//                $.alert($.i18n('taskmanage.alret.feedback.not_allowed'));
//                $("#status").val($("#old_status").val());
//                return;
//            }
//        } else 
		if ($("#canhandwrite").val()=="1") {
            var value = $("#status").val();
            if (value == '1') {
            $("#finishrate_text").val(0);
                $("#finishrate_text").attr({
                    "disabled" : "disabled"
                });
/*                var newValue = $("#status").val();
            	var finishrateVal = $("#finishrate_text").val();
            	if (newValue == '1' && finishrateVal != 0) {                
                $.alert($.i18n('taskmanage.alret.feedback.not_allowed'));
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
        } else {
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
	var broswer=window.navigator.userAgent;
	if(em.hasClass("arrow_2_t")){
		em.removeClass("rolling_btn_t").addClass("rolling_btn_b");
		em.removeClass("arrow_2_t").addClass("arrow_2_b");
		$("#btn_area").css("margin-right","58px");
		$(".extendClass").hide();
		fnGetDialog(118);
	}else{
		em.removeClass("rolling_btn_b").addClass("rolling_btn_t");
		em.removeClass("arrow_2_b").addClass("arrow_2_t");
		$(".extendClass").show();
		//就没有统一点的样式么,老是对浏览器做兼容
		if(broswer.indexOf("Chrome")!=-1){
			$("#projectTask_reply").width("470px");
			$("#btn_area").css("margin-right","50px");
			fnGetDialog(338);
		}else{ 
			$("#btn_area").css("margin-right","50px");
			fnGetDialog(335);
		}
	}
}


function fnGetDialog(dialogHeight){
	try {
		var dialog = window.parent.document.getElementById("task_feedback_iframe");
		dialog.setAttribute("height",dialogHeight+55);
		$("#feadbackList",window.parent.document).height($(".tabs_area_body",window.parent.document).height()+dialogHeight+50);
    	$("#feedbackAreaIframe",window.parent.parent.document).height($("#feadbackList",window.parent.document).height());
    	$("#tabs_area",window.parent.parent.document).height($("#feadbackList",window.parent.document).height());
    	parent.setHeight();
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
	var content = $.i18n("taskmanage.feedback.input.content")+"("+$.i18n("taskmanage.feeback.range_500")+")";
	if(0==type && $("#content").val() == content){
		$("#content").val('');
		$("#content").removeClass("color_gray");
	}else if(1==type && $("#content").val().trim() == ''){
		$("#content").val(content);
		$("#content").addClass("color_gray");
	}
}