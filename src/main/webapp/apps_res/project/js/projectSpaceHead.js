

/**
 * 修改阶段
 */
function modifyPhase(projectId, phaseId) {
	var projectId = $("#projectId").val();
	var phaseId = $("#phaseId").val();

    var dialog = $.dialog({
        id: "setPhase",
        title: $.i18n('project.body.phase.label'),
        url: _ctxPath + "/project/project.do?method=setPhase&projectId=" + projectId + "&phaseId=" + phaseId,
        targetWindow: getCtpTop(),
        width: "320",
        height: "120",
        buttons: [{
            text: $.i18n('common.button.ok.label'),
            isEmphasize: true,
            handler: function() {
                var returnObj = dialog.getReturnValue();
                var projectAjax = new projectAjaxManager(); //调用ajax修改当前项目的阶段
                projectAjax.updataProjectByField(projectId, 'phaseId', returnObj.phaseId);
                
                $("#phaseName").text(cutPhaseName(returnObj.phaseName));
                $("#phaseName").attr("title",returnObj.phaseName);
                $("#phaseId").val(returnObj.phaseId);
                $("#changePhase").val(returnObj.phaseId);
                changePhaseCallBack(returnObj.phaseId);
                dialog.close();
            }
        },
        {
            text: $.i18n('common.button.cancel.label'),
            handler: function() {
                dialog.close();
            }
        }]
    });
}

/**
*切换项目阶段
*/
function changePhase(){
	if(typeof changePhaseCallBack == "function"){
		changePhaseCallBack($("#changePhase").val());
	}
}
	
/**
* 弹出人员卡片
*/
function displayMemberInfo(memberId) {
    $.PeopleCard({
        memberId: memberId
    });
}
/**
 * 修改进度
 */
function modifyProcess() {
    $("#showTD").addClass("hidden");
    $("#editTd").removeClass("hidden");
    if($.isNull($("#percentageEdit").attr("disabled"))){//没有置灰的情况 就获取焦距，由于ie8 不兼容，添加的判断
	    $("#percentageEdit").focus();
    }
    $("#percentageEdit").select();
}

/**
 * 确定修改
 */
  function keyDown(event) {
    var e = event ? event: window.event
    if (e.keyCode == 13) {
    	$("#percentageEdit").removeAttr("onBlur");
    	modifyFinish();
    }
  }
/**
* 修改完成
*/
function modifyFinish() {
	var projectId = $("#projectId").val();
	var projectProcess = $("#projectProcess").val();
	var projectIsOver = $("#projectIsOver").val();
		var reg = "^\\d+$";
		var re = $("#percentageEdit").val().match( reg );
		var value = Number(re);
		if ('0' !== $("#percentageEdit").val() &&(!value || value < 0 || value > 100)) {
			$("#percentageEdit").val(projectProcess);
			$(".percentage_edit").addClass("percentage_edit_error");
			$("#percentage_edit_error_div").show();
			$("#percentageEdit").attr("disabled","disabled");
			setTimeout(function(){
				$("#percentageEdit").removeAttr("onBlur");
				$("#percentageEdit").attr("onBlur","modifyFinish();");//bind 没有绑定上 所有用的这种方式
				$(".percentage_edit").removeClass("percentage_edit_error");
				$("#percentageEdit").removeAttr("disabled");
				$("#percentageEdit").select();
				$("#percentage_edit_error_div").hide();
				$("#showTD").removeClass("hidden");
				$("#editTd").addClass("hidden");
			},2000);
		} else if($("#percentageEdit").val() != projectProcess){
			$("#percentage").text(value + "%");
			var projectAjax = new projectAjaxManager(); //调用ajax修改当前项目的进度
			if ("false" == projectIsOver &&　value == 100) {
				var random = $.messageBox({
					'type': 100,
					'msg': '<span class="ico16 help_16"></span>'+'&nbsp;&nbsp;'+$.i18n('project.create.processState'),
					close_fn:function() {
						projectAjax.updataProjectByField(projectId, 'projectProcess', value + "");
						location.reload();
					},
					buttons: [{
						id:'btn1',
						text: $.i18n('message.ok.js'),
						handler: function () {
							projectAjax.updataProjectByField(projectId, 'projectProcess.projectState', value + "");
							setTimeout(function() {
								location.reload();
							},500);
						}
					}, {
						id:'btn2',
						text: $.i18n('message.cancel.js'),
						handler: function () {
							projectAjax.updataProjectByField(projectId, 'projectProcess', value + "");
							location.reload();
						}
					}]
				});
				$("#showTD").removeClass("hidden");
				$("#editTd").addClass("hidden");
			} else {
				projectAjax.updataProjectByField(projectId, 'projectProcess', value + "");
				location.reload();
				$("#showTD").removeClass("hidden");
				$("#editTd").addClass("hidden");
			}
		}else{
			$("#showTD").removeClass("hidden");
			$("#editTd").addClass("hidden");
		}
}
/**
 * 查看或者设置项目
 */
  function viewOrSetProgect(data){
  	var title = $.i18n('project.set.label');
	if(data.canEditorDel && 0 == data.projectIState){
		var url = _ctxPath + '/project/project.do?method=viewProject&type=update&projectId='+data.id;
		var action = 'update';
		var callBack = reflashPage;
		openDialog(url ,title ,data ,action ,callBack);
	}else{
		var url = _ctxPath + '/project/project.do?method=viewProject&type=view&projectId='+data.id;
		var action = 'view';
		var callBack = restarteProjectCallBack;
		openDialog(url ,title,data ,action ,callBack);
	}
  }
  
/**
 * 回调刷新页面
 */
  function reflashPage(dialog){
  	dialog.close();
  	parent.location.reload();
  }
  /**
 * 点击重启项目后回调
 */
  function restarteProjectCallBack(data ,dialog){
	dialog.close();
  	viewOrSetProgect(data);
 }
  
  /**
   *手动编写截取标题长度js
   */
  function cutString(pStr,pLen){
 	 return getNewStr(pStr,pLen);
   }
/**
   *手动截取项目阶段标题长度  有两个地方使用 统一长度
   */
  function cutPhaseName(phaseName){
 	 return getNewStr(phaseName,12);
  }
 function getNewStr(pStr,afterLen){
 	var _RelLenth;
 	var _newStr;
 	for(var i=0;i<pStr.length&&afterLen>0;i++){
 		if(pStr.charCodeAt(i)>127 || pStr.charCodeAt(i)==94){
 			if(afterLen>1){
 				afterLen-=2;
 			}else{
 				break;
 			}
 		}else{
 			afterLen--;
 		}
 	}
 	_newStr=pStr.substring(0,i);
 	if(i<pStr.length){
 		_newStr=_newStr+"...";
 	}
 	return _newStr;
 }
