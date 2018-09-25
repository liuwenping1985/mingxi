var dialogDealColl;// 双击弹出协同处理框
var page_types = {
  // 待发 已发
    'draft' : 'draft',
    'sent' : 'sent',
    'pending' : 'pending',
    'finish' : 'finish'
};
//获取指定url里面参数的值，没有则返回空
function GetQueryString(url,name){
    if(null == name || "" == name || undefined == name
        || null == url || "" == url || undefined == url){
        return null;
    }
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = url.substr(1).match(reg);
    if(r!=null)return  unescape(r[2]); return null;
}
//向指定对象封装参数
function setParamsToObject(o,url){
	o.app = GetQueryString(url,"app");
    o.sub_app = GetQueryString(url,"sub_app");
    o.finishstate = GetQueryString(url,"finishstate");
    o.listCfgId = GetQueryString(url,"listCfgId");
    var srcFrom = GetQueryString(url,"srcFrom");
    if( srcFrom && srcFrom == "bizconfig" ){
    	if(_paramTemplateIds && _paramTemplateIds!=null && _paramTemplateIds != ""){
        	o.templeteIds = $.trim(_paramTemplateIds);
        }
    }
}
function deleteItems(pageType,grid,tableId,fromMethod,deleteFrom){
  if (!pageType || !page_types[pageType]) {
      $.alert('pageType is illegal:' + pageType);
        return true;
    }
  var rows = grid.grid.getSelectRows();
  var affairIds ="";
  if(rows.length <= 0) {
          // 请选择要删除的公文。
//	  区分公文还是协同，默认为协同
	  deleteErrMsg=$.i18n('collaboration.grid.selectDelete');
	  if(deleteFrom&&deleteFrom=="govdoc"){
		  var deleteErrMsg=$.i18n('collaboration.govdoc.grid.selectDelete');
	  }
	  $.alert(deleteErrMsg);
      return true;
   }
    var obj;
    for (var i = 0; i < rows.length; i++) {
        obj = rows[i];
        try{closeOpenMultyWindow(obj.affairId,false);}catch(e){};
          // 指定回退状态状态不能删除
          if(pageType == "draft"){
               if(obj.subState == '16' ){
                  $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
                  obj.checked = false;
                  return true;
                }
           }

          if(pageType == "pending"){
            if( obj.templeteId){
                  // 未办理的模板协同不允许直接归档或删除!
                $.alert($.i18n('collaboration.template.notHandle.notDeleteArchive') + "<br><br>" + "&lt;"+obj.subject+">");
                obj.checked = false;
                return true;
            }

              var lockWorkflowRe = checkWorkflowLock(obj.processId, $.ctx.CurrentUser.id,14);
              if(lockWorkflowRe[0] == "false"){
                  $.alert(lockWorkflowRe[1] + "<br><br>" + "<"+obj.subject+">");
                  obj.checked = false;
                  return true;
              }
              // 以下事项要求意见不能为空，不能直接归档或删除:
              if(!obj.canDeleteORarchive){
              $.alert($.i18n('collaboration.template.notDeleteArchive.nullOpinion') + "<br><br>" + "<"+obj.subject+">");
              obj.checked = false;
                  return true;
            }
              // 指定回退时不能处理
              var canSubmitWorkFlowRe= canSubmitWorkFlow(obj.workitemId);
              if(canSubmitWorkFlowRe[0]== "false"){
                $.alert(canSubmitWorkFlowRe[1]);
                check = true;
                return false;
              }
          }
    }

  // end
  var confirm = $.confirm({
          // 该操作不能恢复，是否进行删除操作
      'msg': $.i18n('collaboration.confirmDelete'),
      ok_fn: function () {
          for(var count = 0 ; count < rows.length; count ++){
                if(count == rows.length -1){
                    affairIds += rows[count].affairId;
                }else{
                    affairIds += rows[count].affairId +"*";
                }
            }
            // table提交
             var callerResponder = new CallerResponder();
            // 实例化Spring BS对象
            var collManager = new colManager();

            var obj = new Object();
            obj.pageType=pageType;
            obj.affairIds = affairIds;
            obj.fromMethod= fromMethod;
            collManager.checkCanDelete(obj,{
                success : function(flag){
                    if("success" == flag){
                          // 循环删除，隔离后台的事务，否则多个流程事务一起提交工作流部分的数据可能会出错
                          var ids = affairIds.split("*");
                          for(var i=0 ;i<ids.length;i++){
                             collManager.deleteAffair(pageType,ids[i]);
                          }
                          //关闭已经删除了事项打开的子页面
                          for (var i = 0 ; i<ids.length;i++) {
                              try{closeOpenMultyWindow(ids[i],false);}catch(e){}
                          }

                        // 成功删除，并刷新列表
                        $.messageBox({
                            'title':$.i18n('collaboration.system.prompt.js'),
                            'type': 0,
                            'msg': $.i18n('collaboration.link.prompt.deletesuccess'),
                            'imgType':0,
                            ok_fn:function(){
                                var totalNum = grid.p.total - 1;
                                $('#summary').attr("src","collaboration.do?method=listDesc&type="+tableId+"&size="+totalNum);
                                var url = window.location.search;
                                var o = new Object();
                                setParamsToObject(o,url);
                                $("#"+tableId).ajaxgridLoad(o);
                            },
                            cancel_fn: function(){
                            	var totalNum = grid.p.total - 1;
                                $('#summary').attr("src","collaboration.do?method=listDesc&type="+tableId+"&size="+totalNum);
                                var url = window.location.search;
                                var o = new Object();
                                setParamsToObject(o,url);
                                $("#"+tableId).ajaxgridLoad(o);
                            }
                        });
                    }else{
                        $.alert(flag);
                    }
                },
                error : function(request, settings, e){
                    $.alert(e);
                }
            });
      }
  });
}

function addURLPara(obj){
	var _urlPara = window.location.href;
	if(_urlPara.indexOf("&condition=templeteAll&textfield=all") != -1){
		obj.templeteAll="all";
	}

	if(_urlPara.indexOf("condition=templeteCategorys&textfield=") != -1){
		obj.templeteCategorys = $("#bisnissMap").val();
	}
	if(_urlPara.indexOf("condition=templeteIds&textfield=") != -1
			&& window.location.href.indexOf("srcFrom=bizconfig") == -1 ){
		obj.templeteIds = $("#bisnissMap").val();
	}
	if(_urlPara.indexOf("srcFrom=bizconfig&condition=templeteIds&textfield=") != -1){
		obj.templeteIds = $("#frombizconfigIds").val();
	}
	return obj;
}

function editFromWaitSend(grid,app,sub_app){
  var rows = grid.grid.getSelectRows();
  var count;
  count= rows.length;
  if(count == 0){
    // 请选择要编辑的事项
    $.alert($.i18n('collaboration.grid.alert.selectEdit'));
    return;
  }
  if(count > 1){
    // 只能选择一项事项进行编辑
    $.alert($.i18n('collaboration.grid.alert.selectOneEdit'));
    return;
  }
  if(count == 1){
    var obj = rows[0];
    var affairId = obj.affairId;
    var summaryId= obj.summaryId;
    var subState = obj.subState;
    var govdocType = obj.govdocType;
    if(!checkSecret(summaryId,$.i18n('secret.alert.open.cannot'))){
    	return false;
    }
    if(!$.ctx.resources.contains('F01_newColl')&&!$.ctx.resources.contains('F20_newSend')&&!$.ctx.resources.contains('F20_newDengji') && !obj.templeteId) {
          $.alert($.i18n('collaboration.listWaitSend.noNewCol'));
          return false;
    }
    if(govdocType){
    	editCol2(affairId,summaryId,subState,app,sub_app,govdocType);
    }else{
    	editCol(affairId,summaryId,subState,app,sub_app);
    }
  }
}



function editCol(affairId,summaryId,subState,app,sub_app){
    var url = _ctxPath + "/collaboration/collaboration.do?method=newColl&summaryId="+summaryId+"&affairId="+affairId+"&from=waitSend&subState="+subState+"&app="+app+"&sub_app="+sub_app;
    openCtpWindow({'url':url,'id':affairId});
}
function editCol2(affairId,summaryId,subState,app,sub_app,govdocType){
	var url = _ctxPath + "/collaboration/collaboration.do?method=newColl&summaryId="+summaryId+"&affairId="+affairId+"&from=waitSend&subState="+subState+"&app="+app+"&sub_app="+govdocType;
	openCtpWindow({'url':url,'id':affairId});
}

function checkTemplateCanUse(templateId){
   var colMan = new colManager();
   var strFlag = colMan.checkTemplateCanUse(templateId);
   if(strFlag.flag =='cannot'){
      return false;
   }else{
      return true;
   }
 }

// 待发列表发送
function sendFromWaitSend(grid) {
  var rows = grid.grid.getSelectRows();
  if(rows.length > 1){
          // 只能选择一项协同进行发送
    $.alert($.i18n('collaboration.grid.alert.selectOneSend'));
    return;
  }
  if(rows.length < 1){
    $.alert($.i18n('collaboration.grid.alert.selectSend'));
    return;
  }
  var obj = rows[0];
  //若有分保插件，且 密级>1 给出提示，不允许在此发送
  if($.ctx.plugins.contains('secret')&&!(obj.secretLevel==""||obj.secretLevel=="1")){
	  $.alert("当前数据高于普通密级,请点击编辑或双击进入新建页面进行发送!");
	 return;
  }
  var processId = obj.processId;
  var bodyType = obj.bodyType;
  var summaryId =obj.summaryId;
  var orgAccountId = obj.orgAccountId;
  var affairId = obj.affairId;
  var deadlineDatetime=obj.processDeadLineName;
  if(!checkSecret(summaryId,$.i18n('secret.alert.send.cannot'))){
	  return false
  }
  //检查流程期限是不是比当前日期早
  if(typeof(deadlineDatetime)!="undefined"){
    var nowDatetime=new Date();
    if(deadlineDatetime && (nowDatetime.getTime()+server2LocalTime) > new Date(deadlineDatetime.replace(/-/g,"/")).getTime()){
      $.alert($.i18n('collaboration.deadline.sysAlert'));
      return;
    }
  }
  $("#summaryId").val(summaryId);
  $("#affairId").val(affairId);
  var templeteId = null;
  if(obj.subState != '16'){
    templeteId= obj.templeteId;
  }
  var newflowType = obj.newflowType;
  // 自动触发的新流程 不校验,指定回退不校验
  if(templeteId != null && templeteId != "" && obj.subState != '16' && newflowType != '2'){
    if(!(checkTemplateCanUse(templeteId))){
            $.alert($.i18n('template.cannot.use'));
            return;
        }
  }
  if(!$.ctx.resources.contains('F01_newColl') && !templeteId){
	   $.alert($.i18n('collaboration.listWaitSend.noNewCol'));
	   return;
  }
  try{closeOpenMultyWindow(affairId,false);}catch(e){}
  sendFromWaitSendList(bodyType,processId,templeteId,summaryId);
}

function checkSecret(summaryId,msg){
	if($.ctx.plugins.contains('secret')){//判断
		var collManager = new colManager();
		var summary = collManager.getSummaryById(summaryId);
		var orggManager = new orgManager();
		var member = orggManager.getMemberById($.ctx.CurrentUser.id)
		if(member.secretLevel == null && summary.secretLevel != null){
			$.alert(msg);
			return false;
		}
		if(member.secretLevel != null && summary.secretLevel > member.secretLevel){
			$.alert(msg);
			return false;
		}
	}
	return true;
}
//待发列表发送 抽取方法
function sendFromWaitSendList(bodyType,processId,templeteId,summaryId){
    if(bodyType == "20" || bodyType == 20){
          //表单流程请双击进入新建页面进行发送
          $.alert($.i18n('collaboration.grid.alert.dclickSendFrom'));
          return;
     }
   var collManager = new colManager();
   if(templeteId){
         isTemplate = true;
         var callerResponder = new CallerResponder();
         var sflag = collManager.getTemplateId(templeteId);//根据模板ID去查询出流程的Id,顺便判断权限问题
         if(sflag.wflag =='cannot'){
             $.alert($.i18n('collaboration.send.fromSend.templeteDelete'));//模板已经被删除，或者您已经没有该模板的使用权限三
             return;
         }else if(sflag.wflag =='noworkflow'){
             //协同没有流程,不能发送
             $.alert($.i18n('collaboration.send.fromSend.noWrokFlow'));
             return;
         }
         if(sflag.wflag =='isTextTemplate'){
            if(!processId){
              $.alert($.i18n('collaboration.send.fromSend.noWrokFlow'));
                return;
            }
            processId = processId;
            preSendOrHandleWorkflow(window, '-1', '-1',processId,
                    'start', $.ctx.CurrentUser.id, '-1', $.ctx.CurrentUser.loginAccount,
                    '', 'collaboration','', window);
         }else{
             processId = sflag.wflag;
             preSendOrHandleWorkflow(window, '-1',processId, '-1',
                   'start',$.ctx.CurrentUser.id, '-1', $.ctx.CurrentUser.loginAccount,
                   '', 'collaboration','', window);
         }
      } else if(processId){//这个优先级应更高
	     if( !processId||processId == ""){
	         $.alert($.i18n('collaboration.send.fromSend.noWrokFlow'));
	         return;
	       }
	       preSendOrHandleWorkflow(window, '-1', '-1',processId,
	               'start', $.ctx.CurrentUser.id, '-1',$.ctx.CurrentUser.loginAccount,
	               '', 'collaboration','', window);
	   }else{
          var newProcessId = "";
          if(!processId||processId == ""){
              newProcessId = collManager.getProcessId(summaryId);
          }
          if(!newProcessId || newProcessId == ""){
              $.alert($.i18n('collaboration.send.fromSend.noWrokFlow'));
              return;
          } else{
              $.alert($.i18n('collaboration.waitSend.noProcessRefresh')); //请刷新列表后再发送!
              return;
          }
          preSendOrHandleWorkflow(window, '-1', '-1',processId,
                  'start', $.ctx.CurrentUser.id, '-1', $.ctx.CurrentUser.loginAccount,
                  '', 'collaboration','', window);
      }
}

$.content.callback.workflowNew = function() {
     $("<input type='hidden' id='workflow_node_peoples_input' name='workflow_node_peoples_input' value='"+$("#workflow_node_peoples_input",window.document)[0].value+"' />").appendTo($("#sendForm"));
     $("<input type='hidden' id='workflow_node_condition_input' name='workflow_node_condition_input' value='"+$("#workflow_node_condition_input",window.document)[0].value+"' />").appendTo($("#sendForm"));
     $("<input type='hidden' id='workflow_newflow_input' name='workflow_newflow_input' value='"+$("#workflow_newflow_input",window.document)[0].value+"' />").appendTo($("#sendForm"));
     $("#sendForm").attr("action","collaboration.do?method=sendImmediate");
     $("#sendForm").jsonSubmit();
};




//已发列表 重复发起
function resend(grid) {
  var rows = grid.grid.getSelectRows();
  if(rows.length < 1){
          //请选择要重复发起的协同
    $.alert($.i18n('collaboration.grid.send.selectRepeatCol'));
    return;
  }
  if(rows.length >1){
          //只能选择一项协同进行重复发起
    $.alert($.i18n('collaboration.grid.send.selectOneRepeatCol'));
    return;
  }
    var isNewflow = false;
    var summaryId = null;
      var checkedObj =rows[0];
      summaryId = checkedObj.summaryId;
    if(checkedObj.newflowType && checkedObj.newflowType == '1'){
        //该流程为自动触发的子流程，不能重发
        $.alert($.i18n('collaboration.send.workFlow.notResend'));
        return;
      }
      //MainBodyType 里面20的时候表明是 表单格式正文
  if(checkedObj.bodyType && checkedObj.bodyType =='20'){
          //表单协同不能被重复发起
    $.alert($.i18n('collaboration.send.fromSend.notResend'));
    return;
  }
  if (checkedObj.parentformSummaryid != null && !checkedObj.canEdit) {
      //转发表单不允许重复发起！
      $.alert($.i18n('collaboration.send.fromSend.forwardFrom'));
      return;
  }
  /*if(checkedObj.bodyType && (checkedObj.bodyType == '41' || checkedObj.bodyType == '42' ||
      checkedObj.bodyType == '43'|| checkedObj.bodyType == '44'|| checkedObj.bodyType == '45')
      && !$.browser.msie){
      //当前浏览器不支持Office正文，请您使用IE浏览器并安装Office控件
    $.alert($.i18n('common.body.type.officeNotSupported'));
    return;
  }*/

    url ="collaboration.do?method=newColl&summaryId="+summaryId+"&from=resend";
    openCtpWindow({'url': url});
}



//已发列表编辑流程
function _designWorkflow(grid,callback){
  var editFlowForm = document.getElementsByName('editFlowForm')[0];
  if(!editFlowForm) return;

  var rows  =  grid.grid.getSelectRows();
  if(rows.length < 1){
          //请选择要编辑的协同
        $.alert($.i18n('collaboration.sendGrid.selectColEdit'));
        return;
  }
  if(rows.length >1){
          //只能选择一项协同进行编辑
    $.alert($.i18n('collaboration.sendGrid.selectOneColEdit'));
    return;
  }
  var selObj = rows[0];
  var caseId = selObj.caseId;
  var processId = selObj.processId;
  var deadline = selObj.deadline;
  var advanceRemind = selObj.advanceRemind;
  var templeteId = selObj.templeteId;
  //fb 获取记录的密级
  if($("#secretLevel")){
	  $("#secretLevel").val(selObj.secretLevel);
  }

  if((selObj.flowFinished || selObj.flowFinished == 'true') || templeteId){
          //该流程已结束或为模板流程不允许修改
    $.alert($.i18n('collaboration.sendGrid.workFlowEndAndTemplate.notEdit'));
    return;
  }
  $("#processId",editFlowForm).val(processId);
  $("#deadline",editFlowForm).val(deadline);
  $("#advanceRemind",editFlowForm).val(advanceRemind);
  editWFCDiagram(window.parent,caseId,processId,window,'collaboration',false,$.ctx.CurrentUser.loginAccount,'collaboration','协同',callback);
  return;
}

function doubleClick(url,title){
    var parmas = [$('#summary'),$('.slideDownBtn'),$('#listPending'),$('#listSent'),$('#listDone'),$('#WaitSend')];
    getCtpTop().showSummayDialogByURL(url,title,parmas);
}

//打开正文内容,专门给事件中调用这个方法。
function showSummayToEventDialog(url,title){
    var width = $(getA8Top().document).width() - 60;
    var height = $(getA8Top().document).height() - 50;
    dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: escapeStringToHTML(title),
        targetWindow:getCtpTop()
    });
}


/**
* 获取打开正文详细信息页面的url
* affairId 事项表id
* openFrom 从哪里打开，用来设置是否显示右侧处理区域
*/
function getShowSummaryURL(affairId,openFrom){
    var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom="+openFrom+"&affairId='"+affairId+"'";
    return url;
}



/**
 * 明细日志 弹出对话框
 * showFlag  初始化时 显示的内容 1:显示处理明细 2:显示流程日志 3:显示催办(督办)日志
 */
function showDetailLogDialog(summaryId,processId,showFlag){
    var dialog = $.dialog({
        url : _ctxPath+'/detaillog/detaillog.do?method=showDetailLog&summaryId='+summaryId+'&processId='+processId+"&showFlag="+showFlag,
        width : 800,
        height : 400,
        title : $.i18n('collaboration.sendGrid.findAllLog'), //查看明细日志
        targetWindow:getCtpTop(),
        buttons : [{
            text : $.i18n('collaboration.button.close.label'),
            handler : function() {
              dialog.close();
            }
        }]
    });
}

/**
* 预归档
* 模板页面和新建页面都走这里
*/
function doPigeonhole_pre(flag, appName, from) {

    if (flag == "no") {
        //TODO 清空信息
    }
    else if (flag == "new") {
        var result;
        if(from == "templete"){
            result = pigeonhole(appName, null, false, false,'templeteManage', "doPigeonhole_preCallback");
        }else{
            result = pigeonhole(appName,null, "", "", "", "doPigeonhole_preCallback");
        }
    }
}

/**
 * doPigeonhole_pre归档回调
 */
function doPigeonhole_preCallback(result){

    var theForm = document.getElementsByName("sendForm")[0];
    if(result == "cancel"){
        var oldPigeonholeId = theForm.archiveId.value;
        var selectObj = theForm.colPigeonhole;
        if(oldPigeonholeId != "" && selectObj.options.length >= 3){
            selectObj.options[2].selected = true;
        }
        else{
            var oldOption = document.getElementById("defaultOption");
            oldOption.selected = true;
        }
        return;
    }
    var pigeonholeData = result.split(",");
    pigeonholeId = pigeonholeData[0];
    pigeonholeName = pigeonholeData[1];
    if(pigeonholeId == "" || pigeonholeId == "failure"){
        theForm.archiveName.value = "";
        $.alert($.i18n("collaboration.alert.pigeonhole.failure"));
    }
    else{
        var oldPigeonholeId = theForm.archiveId.value;
        theForm.archiveId.value = pigeonholeId;
        if(document.getElementById("prevArchiveId")){
            document.getElementById("prevArchiveId").value = pigeonholeId;
        }
        var selectObj = document.getElementById("colPigeonhole");
        var option = document.createElement("OPTION");
        option.id = pigeonholeId;
        option.text = pigeonholeName;
        option.value = pigeonholeId;
        option.selected = true;
        if(oldPigeonholeId == "" && selectObj.options.length<=2){
            selectObj.options.add(option, selectObj.options.length);
        }
        else{
            selectObj.options[selectObj.options.length-1] = option;
        }
    }
}



  //归档
  function doPigeonhole(pageType, grid, tableId) {
    var v = $("#"+tableId).formobj({
      gridFilter : function(data, row) {
    	if(row!=null){
    		return $("input:checkbox", row)[0].checked;
    	}else{
    		return true;
    	}
      }
    });
//	  var v =  $();
//	  $("#"+tableId+" :checkbox").each(function(){
//		  if($(this).prop("checked")){
//			  v = v.add($(this));
//		  }
//	  });
//	  if("sent" == pageType){
//		   v = $("#"+tableId).formobj({
//		      gridFilter : function(data, row) {
//		        return $("input:checkbox", row)[0].checked;
//		      }
//		    });
//	  }

    if (v.length === 0) {
      if(pageType.indexOf("govdoc")==0){
    	  $.alert($.i18n('collaboration.govdoc.alert.select'));
      }else{
    	  $.alert($.i18n('collaboration.pighole.alert.select'));
      }
      return;
    }
    var ids = new Array();
    var check = false;
    var archiveSubject='';
    var workflowSubject='';
    var opinionSubject='';
    var lockWorkflowRe;
    $(v).each(function(index, elem) {
//    	//老公文 屏蔽该功能
//    	if(elem.app > 4){
//    		$.alert("《"+elem.subject+"》 为旧公文数据,"+$.i18n('edoc.alert.oldEdocSummary.noFunction'));
//			check = true;
//    		return false;
//    	}
        //待办的逻辑(还需要翟峰多查询几个条件)
        if(pageType == "pending"){
            if(elem.templeteId){
                //未办理的模板协同不允许直接归档或删除
                check = true;
                archiveSubject += "<br><"+elem.subject+">";
            }

            lockWorkflowRe = checkWorkflowLock(elem.processId, $.ctx.CurrentUser.id,14);
            if(lockWorkflowRe[0] == "false"){
                check = true;
                workflowSubject += "<br><"+elem.subject+">";
            }

            if(!elem.canDeleteORarchive){
                //以下事项要求意见不能为空，不能直接归档或删除
                check = true;
                opinionSubject += "<br><"+elem.subject+">";
            }
            // 指定回退时不能处理
            var canSubmitWorkFlowRe= canSubmitWorkFlow(elem.workitemId);
            if(canSubmitWorkFlowRe[0]== "false"){
              $.alert(canSubmitWorkFlowRe[1]);
              check = true;
              return false;
            }
        }
        ids.push(elem.affairId);
    });
    if(archiveSubject.length > 1){
    	$.alert($.i18n('collaboration.template.notHandle.notDeleteArchive') + "<br>" + archiveSubject);
    	return;
    }
    if(workflowSubject.length > 1){
    	$.alert(lockWorkflowRe[1] + "<br>"+ workflowSubject);
    	return;
    }
    if(opinionSubject.length > 1){
    	$.alert($.i18n('collaboration.template.notDeleteArchive.nullOpinion')+"<br>" + opinionSubject);
    	return;
    }
    if(check){
      return;
    }
    var callerResponder = new CallerResponder();
    callerResponder.success = function(jsonObj) {
      if(jsonObj != ""){
    	  $.alert(escapeStringToHTML(jsonObj));
      }else{
        doPigeonholeCheck(ids, pageType, tableId, grid);
      }
    };
    var cm = new colManager();
    cm.getPigeonholeRight(ids, callerResponder);
  }

  function doPigeonholeCol(ids, folder, pageType, tableId, grid){
    var cm = new colManager();
  //增加判断当前文档是否已经归档了
    var res = cm.checkPigeonhole(ids, folder[0], pageType);
	if(res.length > 0){
		var alertObj = $.alert(res);

        //BDGW-540 已发列表，选择多条数据归档，对于已经归档过的公文给出提示后将勾选框取消，参照原公文
        if("govdocsent"==pageType){
            for (var i = 0 ; i < ids.length;i++) {
                var affairId = ids[i];
                var subject = $("input[value="+ids[i]+"]").closest("tr").find("td[abbr=subject]").find("div").attr("title");
                if(res.indexOf(subject)>-1){
                    $("input[value="+ids[i]+"]").prop("checked",false);
                }
            }
        }
		return;
	}
    for(var i = 0;i<ids.length;i++){
      cm.transPigeonhole(ids[i], folder[0], pageType);
    }
    //归档成功
    var alertObj = $.infor($.i18n('collaboration.grid.alert.archiveSuccess'));
    //删除重复的文档
    cm.transPigeonholeDeleteStepBackDoc(ids, folder[0]);
	if('govdocsent' != pageType){
		var url = window.location.search;
		var o = new Object();
		setParamsToObject(o,url);
		$("#"+tableId).ajaxgridLoad(o);
		grid.grid.resizeGridUpDown("down");
		if(tableId === "listPending"){
			$('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total);
		}
		//归档后关闭子页面打开的协同
		for (var i = 0 ; i < ids.length;i++) {
		   var affairId = ids[i];
			try{closeOpenMultyWindow(affairId);}catch(e){}
		}
	}
      //BDGW-540 已发列表，选择多条数据归档，对于已经归档过的公文给出提示后将勾选框取消，参照原公文
      if("govdocsent"==pageType){
          var url = window.location.search;
          var o = new Object();
          setParamsToObject(o,url);
          $("#"+tableId).ajaxgridLoad(o);
      }

  }

  // 检查是否已存在归档协同
  var doPigeonholeCheckCallbackIds = "";
  var doPigeonholeCheckCallbackPageType = "";
  var doPigeonholeCheckCallbackTableId = "";
  var doPigeonholeCheckCallbackGrid = "";
  function doPigeonholeCheck(ids, pageType, tableId, grid){

      doPigeonholeCheckCallbackIds = ids;
      doPigeonholeCheckCallbackPageType = pageType;
      doPigeonholeCheckCallbackTableId = tableId;
      doPigeonholeCheckCallbackGrid = grid;

      var result = pigeonhole(null, null, null, null, pageType, "doPigeonholeCheckCallback");
  }


    /**
     * doPigeonholeCheck归档回调
     */
    function doPigeonholeCheckCallback(result) {
        if (result && result != "cancel") {
            var folder = result.split(",");
            var callerResponder = new CallerResponder();
            callerResponder.success = function(jsonObj) {
                    doPigeonholeCol(doPigeonholeCheckCallbackIds, folder,
                            doPigeonholeCheckCallbackPageType,
                            doPigeonholeCheckCallbackTableId,
                            doPigeonholeCheckCallbackGrid);
            }
            var cm = new colManager();
            cm.getIsSamePigeonhole(doPigeonholeCheckCallbackIds, folder[0], callerResponder);
        }
    }

  //转发协同
  function transmitColFromGrid(grid){
      // 需要判断是否只勾选了一项，并给出相应的提示
      var selectBox = grid.grid.getSelectRows();
      if (selectBox.length === 0) {
          //请选择要转发的协同
          $.alert($.i18n('collaboration.grid.alert.transmitCol'));
          return;
      }
      else if($.ctx.plugins.contains('secret') && selectBox.length > 1) {//分保---将转发改为只能转发一条
          //只能选择1项协同进行转发
          $.alert($.i18n('collaboration.grid.alert.transmitColOnlyOne'));
          return;
      }else if(selectBox.length > 20) {
          //只能选择20项协同进行转发
          $.alert($.i18n('collaboration.grid.alert.transmitColOnly20'));
          return;
      }
      for(var i=0; i<selectBox.length; i++){
         var selectedObj = selectBox[i];
         var app = selectedObj.applicationCategoryKey || selectedObj.app;
         if(app == 19 || app == 20 || app == 21){
             //公文不允许转发协同
             $.alert($.i18n('collaboration.grid.alert.DocumentNotForwardCol'));
             return;
         }else if(app=='32') {
			 //信息报送不允许转发协同
			 $.alert($.i18n('collaboration.grid.alert.InfoNotForwardCol'));
			 return;
		 }
      }

      var data = [];
      for(var i = 0; i < selectBox.length; i++){
          var summaryId = null;
          var affairId = null;
          if(selectBox[i].summaryId && selectBox[i].affairId){
              summaryId = selectBox[i].summaryId;
              affairId = selectBox[i].affairId;
          }
          else{//首页待办更多是Affair对象
              summaryId = selectBox[i].objectId;
              affairId = selectBox[i].id;
          }
          data[i] = {"summaryId": summaryId, "affairId": affairId};
      }

      transmitColById(data,grid);
   }

   function transmitColById(data,grid){
      var dataStr = "";
      for(var i = 0; i < data.length; i++){
          dataStr += data[i]["summaryId"] + "_" + data[i]["affairId"] + ",";
      }
      var cm = new colManager();
      var r = cm.checkForwardPermission(dataStr);
      if(r && (r instanceof Array) && r.length > 0){
          //以下协同不能转发，请重新选择
          $.alert($.i18n('collaboration.grid.alert.thisSelectNotForward')+"<br><br>" + r.join("<br>"));
          return;
      }

      //分保---传密级参数
      var selectBox = grid.grid.getSelectRows();

      var dialog = $.dialog({
          id : "showForwardDialog",
          height:"415",
          url : _ctxPath+"/collaboration/collaboration.do?method=showForward&data=" + dataStr+"&secretLevel="+selectBox[0].secretLevel,//分保---密级添加参数
          title : $.i18n('collaboration.transmit.col.label'),
          targetWindow:getCtpTop(),
          isClear:false,
          transParams:{
              commentContent : ""
          },
          buttons: [{
              id : "okButton",
              text: $.i18n("collaboration.button.ok.label"),
              btnType:1,
              handler: function () {
                  var rv = dialog.getReturnValue();
              },
              OKFN : function(){
                  dialog.close();
                  try{
                      $("#"+grid.id).ajaxgridLoad();
                  }
                  catch(e){
                  }
              }
          }, {
              id:"cancelButton",
              text: $.i18n("collaboration.button.cancel.label"),
              handler: function () {
                  dialog.close();
              }
          }]
      });
   }

   //ajax判断事项是否可用。
   function isAffairValid(affairId){
     var cm = new colManager();
     var msg = cm.checkAffairValid(affairId);
     if($.trim(msg) !=''){
          $.alert(msg);
          return false;
     }
     return true;
   }

   function transmitMail(){
     if($.ctx.plugins.contains('webmail')){
         //需要判断是否只勾选了一项，并给出相应的提示
         var selectBox =grid.grid.getSelectRows();
         if (selectBox.length === 0) {
             //请选择要转发的协同!
             $.alert($.i18n('collaboration.grid.alert.transmitCol'));
             return;
         } else if(selectBox.length > 1) {
             //只能选择一项协同进行转发
             $.alert($.i18n('collaboration.grid.alert.transmitColOnlyOne'));
             return;
         }
         for(var i=0; i<selectBox.length; i++){
             var selectedObj = selectBox[i];
             var app = selectedObj.applicationCategoryKey || selectedObj.app;
             //公文不能转邮件
             var bgory= selectedObj.bodyType || selectedObj.app;
 			 if(bgory=="20" && (app=="4" || app == "19" || app == "20" || app == "21")){
 				 $.alert($.i18n('collaboration.grid.alert.transmitColNoZYJ'));
         		 return ;
     		 }
             if(app == "19" || app == "20" || app == "21"){
                 //公文不允许转发协同
                 $.alert($.i18n('collaboration.grid.alert.DocumentNotForwardEmail'));
                 return;
             } else if(app=='32') {
				 //信息报送不允许转发邮件
                 $.alert($.i18n('collaboration.grid.alert.InfoNotForwardEmail'));
                 return;
			 }
          }

         var summaryId = "";
         var affairId = "";
         if(selectBox[0].summaryId && selectBox[0].affairId){
           summaryId = selectBox[0].summaryId;
           affairId = selectBox[0].affairId;
         }
         else{//首页待办更多是Affair对象
           summaryId = selectBox[0].objectId;
           affairId = selectBox[0].id;
         }

         var cm = new colManager();
         var r = cm.checkForwardPermission(summaryId + "_" + affairId);
         if(r && (r instanceof Array) && r.length > 0){
             //以下协同不能转发，请重新选择
             $.alert($.i18n('collaboration.grid.alert.thisSelectNotForward')+"<br><br>" + r.join("<br>"));
             return;
         }

         //处理自己的相关逻辑
         window.location.href =_ctxPath + "/collaboration/collaboration.do?method=forwordMail&id=" +summaryId;
     }
 }
function setTrack(obj){
     var text = $(obj).text();
     var affairId = $(obj).attr("affairId");
     var summaryId = $(obj).attr("summaryId");
     var dialog = $.dialog({
          targetWindow:getCtpTop(),
          id: 'trackDialog',
          url: _ctxPath+'/collaboration/collaboration.do?method=openTrackDetail&objectId='+$(obj).attr("summaryId")+
                 '&affairId='+$(obj).attr("affairId"),
          width: 200,
          height: 100,
          title: $.i18n('collaboration.listDone.traceSettings'),
          buttons: [{
              id : "trackSubmit",
              text: $.i18n('collaboration.pushMessageToMembers.confirm'), //确定
              handler: function () {
                 var returnValue = dialog.getReturnValue();
                 if( returnValue && returnValue != null){//返回值到父页面
                     if(returnValue == '1' || returnValue =='2'){
                         $(obj).text($.i18n('message.yes.js')); //是
                     } else {
                         $(obj).text($.i18n('message.no.js')); //否
                     }
                     try{
                         $("#trackType",window.summaryF.document).val(newTrackType);
                     }catch(e){}
                     dialog.close();
                 }
              }
          }, {
              text: $.i18n('collaboration.pushMessageToMembers.cancel'), //取消
              handler: function () {
                  dialog.close();
              }
          }]
      });
 }
var queryDialog;
var o = new Object();
function openQueryViews(openForm){
	var _url = _ctxPath + "/collaboration/collaboration.do?method=combinedQuery&openForm="+openForm;
	if(window.location.href.indexOf("condition=templeteAll&textfield=all") != -1){
		_url += "&condition=templeteAll&textfield=all";
	}
	if(window.location.href.indexOf("condition=templeteCategorys&textfield=") != -1){
		_url += "&condition=templeteCategorys&textfield="+$("#bisnissMap").val();
	}
	if(window.location.href.indexOf("condition=templeteIds&textfield=") != -1
			&& window.location.href.indexOf("srcFrom=bizconfig") == -1 ){
		_url += "&bisnissMap=1&condition=templeteIds&textfield="+$("#bisnissMap").val();
	}
	if(window.location.href.indexOf("srcFrom=bizconfig&condition=templeteIds&textfield=") != -1){
		_url += "&srcFrom=bizcofnig&condition=templeteIds&textfield="+$("#frombizconfigIds").val();
	}
	var _hasDedupCheck =  $("#deduplication").attr("checked");
    if (_hasDedupCheck) {
    	_url +="&deduplication=true";
        //o.deduplication = "true";
    }
	searchobj.g.clearCondition();
    queryDialog = $.dialog({
        url:  _url,
        width: 400,
        height: 250,
        title: '高级查询', //高级查询
        id:'queryDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
                queryDialog.close({isFormItem:true});
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            handler: function () {
    		   o = queryDialog.getReturnValue({type:1});
    		   var cloneParam = new Object();
    		   cloneParam.subject = o.subject ;
    		   cloneParam.importantLevel = o.importantLevel
    		   cloneParam.startMemberName  =  o.startMemberName
    		   cloneParam.createDate  = o.createDate;

			   if(typeof(o.receiveDate)!='undefined'){
				   cloneParam.receiveDate = o.receiveDate
               }
			   if(typeof(o.expectprocesstime)!='undefined'){
				   cloneParam.expectprocesstime = o.expectprocesstime;
               }
			   if(typeof(o.subState)!='undefined'){
				   cloneParam.subState = o.subState
               }
			   if(typeof(o.condition)!='undefined'){
				   cloneParam.condition = o.condition
               }
			   if(typeof(o.dealDate)!='undefined'){
				   cloneParam.dealDate = o.dealDate
               }
			   if(typeof(o.deduplication)!='undefined'){
				   cloneParam.deduplication = o.deduplication
               }
			   if(typeof(o.workflowState)!='undefined'){
				   cloneParam.workflowState = o.workflowState
               }
			   if(typeof(o.templeteCategorys)!='undefined'){
				   cloneParam.templeteCategorys = o.templeteCategorys
               }
			   if(typeof(o.templeteAll)!='undefined'){
				   cloneParam.templeteAll = o.templeteAll
               }
               if(typeof(o.templeteIds)!='undefined'){
				   cloneParam.templeteIds = o.templeteIds
               }

           	    queryDialog.close();

           	    var $listPending = $("#listPending");
        		var $listDone = $("#listDone");

        	    if($listPending.length>0){

        	    	$listPending.ajaxgridLoad(cloneParam);

        	    }else if($listDone.length > 0 ) {

        	    	$listDone.ajaxgridLoad(cloneParam);

        	    }

           }
        }, {
            id:"cancelButton",
            text: '重置',
            handler: function () {
        		queryDialog.getReturnValue({type:2});
            }
        }]
    });
}
