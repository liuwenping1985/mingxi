<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
<script type="text/javascript">
	var dialogDealColl;//双击弹出协同处理框
	var page_types = {
		//待发  已发 
	    'draft' : 'draft',
	    'sent' : 'sent',
	    'pending' : 'pending',
	    'finish' : 'finish'
	};
	function deleteItems(pageType,grid,tableId){
		var fromMethod="${param.method}";
		if (!pageType || !page_types[pageType]) {
		    $.alert('pageType is illegal:' + pageType);
	        return true;
	    }
		var rows = grid.grid.getSelectRows();
		var affairIds ="";
		if(rows.length <= 0) {
            //请选择要删除的协同。
		    $.alert("${ctp:i18n('collaboration.grid.selectDelete')}");
		    return true;
		 }
	    var obj;
	    for (var i = 0; i < rows.length; i++) {
        	obj = rows[i];
            //指定回退状态状态不能删除
            if(pageType == "draft"){
                 if(obj.affair.subState == '16' ){
                    $.alert("${ctp:i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack')}");
                    obj.checked = false;
                    return true;
                  }
             }
            
            if(pageType == "pending"){
            	if( obj.templeteId){
                    //未办理的模板协同不允许直接归档或删除!
            	    $.alert("${ctp:i18n('collaboration.template.notHandle.notDeleteArchive')}" + "<br><br>" + "&lt;"+obj.summary.subject+">");
            		obj.checked = false;
        			return true;
            	}

                var lockWorkflowRe = checkWorkflowLock(obj.summary.processId, '${CurrentUser.id}');
                if(lockWorkflowRe[0] == "false"){
                    $.alert(lockWorkflowRe[1] + "<br><br>" + "<"+obj.summary.subject+">");
            		obj.checked = false;
                    return true;
                }
                //以下事项要求意见不能为空，不能直接归档或删除:
                if(!obj.canDeleteORarchive){
            		$.alert("${ctp:i18n('collaboration.template.notDeleteArchive.nullOpinion')}" + "<br><br>" + "<"+obj.summary.subject+">");
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

		//end
		var confirm = $.confirm({
            //该操作不能恢复，是否进行删除操作
		    'msg': "${ctp:i18n('collaboration.confirmDelete')}",
		    ok_fn: function () {
		        for(var count = 0 ; count < rows.length; count ++){
	                if(count == rows.length -1){
	                    affairIds += rows[count].affairId;
	                }else{
	                    affairIds += rows[count].affairId +"*";
	                }
	            }
	            //table提交
	             var callerResponder = new CallerResponder();
	            //实例化Spring BS对象
	            var collManager = new colManager();

	            var obj = new Object();
	            obj.pageType=pageType;
	            obj.affairIds = affairIds;
	            obj.fromMethod= fromMethod;
	            collManager.checkCanDelete(obj,{
	                success : function(flag){
	                    if("success" == flag){
                            //循环删除，隔离后台的事务，否则多个流程事务一起提交工作流部分的数据可能会出错
                            var ids = affairIds.split("*");
                            for(var i=0 ;i<ids.length;i++){
                               collManager.deleteAffair(pageType,ids[i]);
                            }
	                    
	                        //成功删除，并刷新列表
	                        $.messageBox({
	                            'title':"${ctp:i18n('system.prompt.js')}",
	                            'type': 0,
	                            'msg': "${ctp:i18n('link.prompt.deletesuccess')}",
	                            'imgType':0,
	                            ok_fn:function(){
	                                var totalNum = grid.p.total - 1;
	                                $('#summary').attr("src","collaboration.do?method=listDesc&type="+tableId+"&size="+totalNum);
                                    $("#"+tableId).ajaxgridLoad();
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
	
	function editFromWaitSend(grid){
		var rows = grid.grid.getSelectRows();
		var count;
		count= rows.length;
		if(count == 0){
            //请选择要编辑的事项
			$.alert(" ${ctp:i18n('collaboration.grid.alert.selectEdit')}");
			return;
		}
		if(count > 1){
            //只能选择一项事项进行编辑
			$.alert("${ctp:i18n('collaboration.grid.alert.selectOneEdit')}");
			return;
		}
		if(count == 1){
			var obj = rows[0];
			var affairId = obj.affairId;
			var summaryId= obj.summary.id;
			var subState = obj.subState;
			if(!$.ctx.resources.contains('F01_newColl')) {
			    $.alert("${ctp:i18n('collaboration.listWaitSend.noNewCol')}");
                return false;
            }
			editCol(affairId,summaryId,subState);
		}
	}
	
	function editCol(affairId,summaryId,subState){
	    window.location = _ctxPath + "/collaboration/collaboration.do?method=newColl&summaryId="+summaryId+"&affairId="+affairId+"&from=waitSend&subState="+subState;
	}

	function checkTemplateCanUse(templateId){
		 var callerResponder = new CallerResponder();
	     var collManager = new colManager();	
	     var strFlag = collManager.checkTemplateCanUse(templateId);
		 if(strFlag.flag =='cannot'){
		 	return false;
		 }else{
		    return true;
	    }
	 }

	//待发列表发送
	function sendFromWaitSend(grid) {
		var rows = grid.grid.getSelectRows();
		if(rows.length > 1){
            //只能选择一项协同进行发送
			$.alert("${ctp:i18n('collaboration.grid.alert.selectOneSend')}");
			return;
		}
		if(rows.length < 1){
			$.alert("${ctp:i18n('collaboration.grid.alert.selectSend')}");
			return;
		}
	    var obj = rows[0];
	    var processId = obj.summary.processId;
		var bodyType = obj.bodyType;
		var summaryId =obj.summary.id;
		var affairId = obj.affairId;
		$("#summaryId").val(summaryId);
		$("#affairId").val(affairId);
		var templeteId = obj.templeteId;
		var newflowType = obj.summary.newflowType;
		//自动触发的新流程  不校验,指定回退不校验
		if(templeteId != "" && obj.subState != '16' && newflowType != '2'){
			if(!(checkTemplateCanUse(templeteId))){
	              $.alert("${ctp:i18n('template.cannot.use')}");
	              return;
	          }
		}
		
		sendFromWaitSendList(bodyType,processId,templeteId);
	}
	//待发列表发送 抽取方法 
	function sendFromWaitSendList(bodyType,processId,templeteId){
	    if(bodyType == "20" || bodyType == 20){
            //表单流程请双击进入新建页面进行发送
            $.alert("${ctp:i18n('collaboration.grid.alert.dclickSendFrom')}");
            return;
       }
	   if(processId){//这个优先级应更高
	     if( !processId||processId == ""){
           $.alert("${ctp:i18n('collaboration.send.fromSend.noWrokFlow')}");
           return;
         }
         preSendOrHandleWorkflow(window, '-1', '-1',processId,
                 'start', '${CurrentUser.id}', '-1', '${CurrentUser.accountId}',
                 '', 'collaboration','', window);
	   } else if(templeteId){
           isTemplate = true;
           var callerResponder = new CallerResponder();
           var collManager = new colManager();
           var sflag = collManager.getTemplateId(templeteId);//根据模板ID去查询出流程的Id,顺便判断权限问题
           if(sflag.wflag =='cannot'){
               $.alert(" ${ctp:i18n('collaboration.send.fromSend.templeteDelete')}");//模板已经被删除，或者您已经没有该模板的使用权限三
               return;
           }else if(sflag.wflag =='noworkflow'){
               //协同没有流程,不能发送
               $.alert("${ctp:i18n('collaboration.send.fromSend.noWrokFlow')}");
               return;
           }
           if(sflag.wflag =='isTextTemplate'){
              if(!processId){
            	  $.alert("${ctp:i18n('collaboration.send.fromSend.noWrokFlow')}");
                  return;
              }
			  processId = processId;
			  preSendOrHandleWorkflow(window, '-1', '-1',processId,
	                    'start', '${CurrentUser.id}', '-1', '${CurrentUser.accountId}',
	                    '', 'collaboration','', window);
           }else{
	           processId = sflag.wflag;
           	   preSendOrHandleWorkflow(window, '-1',processId, '-1',
                     'start', '${CurrentUser.id}', '-1', '${CurrentUser.accountId}',
                     '', 'collaboration','', window);
           }
        }else{
            if( !processId||processId == ""){
                $.alert("${ctp:i18n('collaboration.send.fromSend.noWrokFlow')}");
                return;
            }
            preSendOrHandleWorkflow(window, '-1', '-1',processId,
                    'start', '${CurrentUser.id}', '-1', '${CurrentUser.accountId}',
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
			$.alert("${ctp:i18n('collaboration.grid.send.selectRepeatCol')}");
			return;
		}
		if(rows.length >1){
            //只能选择一项协同进行重复发起
			$.alert("${ctp:i18n('collaboration.grid.send.selectOneRepeatCol')}");
			return;
		}
   		var isNewflow = false;
   		var summaryId = null;
  	  	var checkedObj =rows[0];
        summaryId = checkedObj.summary.id;
  		if(checkedObj.summary.newflowType && checkedObj.summary.newflowType == '1'){
            //该流程为自动触发的子流程，不能重发
            $.alert("${ctp:i18n('collaboration.send.workFlow.notResend')}");
        	return;
        } 
        //MainBodyType 里面20的时候表明是 表单格式正文 
		if(checkedObj.bodyType && checkedObj.bodyType =='20'){
            //表单协同不能被重复发起
			$.alert("${ctp:i18n('collaboration.send.fromSend.notResend')}");
			return;
		}
		/*if(checkedObj.bodyType && (checkedObj.bodyType == '41' || checkedObj.bodyType == '42' || 
				checkedObj.bodyType == '43'|| checkedObj.bodyType == '44'|| checkedObj.bodyType == '45')){
				 && !$.browser.msie){
            //表单协同不能被重复发起
			$.alert("${ctp:i18n('common.body.type.officeNotSupported')}");
			return;
		}*/
		
   		window.location ="collaboration.do?method=newColl&summaryId="+summaryId+"&from=resend";
	}
	
	//已发列表编辑流程 
	function _designWorkflow(grid){
		var editFlowForm = document.getElementsByName('editFlowForm')[0];
		if(!editFlowForm) return;
		
		var rows  =  grid.grid.getSelectRows();
		if(rows.length < 1){
            //请选择要编辑的协同
	        $.alert("${ctp:i18n('collaboration.sendGrid.selectColEdit')}");
	        return;
		}
		if(rows.length >1){
            //只能选择一项协同进行编辑
			$.alert("${ctp:i18n('collaboration.sendGrid.selectOneColEdit')}");
			return;
		}
		var selObj = rows[0];
		var caseId = selObj.caseId;
		var processId = selObj.summary.processId;
		var deadline = selObj.summary.deadline;
		var advanceRemind = selObj.summary.advanceRemind;
		var templeteId = selObj.templeteId;
        
		if((selObj.flowFinished || selObj.flowFinished == 'true') || templeteId){
            //该流程已结束或为模板流程不允许修改
			$.alert("${ctp:i18n('collaboration.sendGrid.workFlowEndAndTemplate.notEdit')}");
			return;
		}
		//将processId,advanceRemind,deadline设置到隐藏域中
		//editFlowForm.document.getElementById("processId").value = processId;
		//editFlowForm.document.getElementById("deadline").value = deadline;
		//editFlowForm.document.getElementById("advanceRemind").value = advanceRemind;
		$("#processId",editFlowForm).val(processId);
		$("#deadline",editFlowForm).val(deadline);
		$("#advanceRemind",editFlowForm).val(advanceRemind);
		var currentUserAccountId='${CurrentUser.loginAccount}';
		editWFCDiagram(window.parent,caseId,processId,window,'collaboration',false,currentUserAccountId,'collaboration','协同');
		return;
	}	
        
	function doubleClick(url,title){
	    showSummayDialogByURL(url,title);
    }
    
	//打开正文内容,专门给事件中调用这个方法。
	function showSummayToEventDialog(url,title){
		var width = $(getA8Top().document).width() - 60;
		var height = $(getA8Top().document).height() - 50;
		dialogDealColl = $.dialog({
	        url: url,
	        width: width,
	        height: height,
	        title: title,
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
	        title : "${ctp:i18n('collaboration.sendGrid.findAllLog')}", //查看明细日志
	        targetWindow:getCtpTop(),
	        buttons : [{
	            text : "${ctp:i18n('common.button.close.label')}",
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
	        	result = pigeonhole(appName, null, false, false);
	    	}else{
	    		result = pigeonhole(appName,null);
	    	}
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
	        	$.alert(v3x.getMessage("collaborationLang.collaboration_alertPigeonholeItemFailure"));
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
	}
	
  //归档
  function doPigeonhole(pageType, grid, tableId) {
    var v = $("#"+tableId).formobj({
      gridFilter : function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length === 0) {
      $.alert("${ctp:i18n('collaboration.pighole.alert.select')}");
      return;
    }
    var ids = new Array();
    var check = false;
    $(v).each(function(index, elem) {
        //待办的逻辑(还需要翟峰多查询几个条件)
        if(pageType == "pending"){
            if(elem.templeteId){
                //未办理的模板协同不允许直接归档或删除
                $.alert(" ${ctp:i18n('collaboration.template.notHandle.notDeleteArchive')}" + "<br><br>" + "<"+elem.subject+">");
                check = true;
                return false;
            }
            
            var lockWorkflowRe = checkWorkflowLock(elem.processId, '${CurrentUser.id}');
            if(lockWorkflowRe[0] == "false"){
                $.alert(lockWorkflowRe[1] + "<br><br>"+ "<"+elem.subject+">");
                check = true;
                return false;
            }
            
            if(!elem.canDeleteORarchive){
                //以下事项要求意见不能为空，不能直接归档或删除
                $.alert("${ctp:i18n('collaboration.template.notDeleteArchive.nullOpinion')}"+"<br><br>" + "<"+elem.subject+">");
                check = true;
                return false;
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
    if(check){
      return;
    }
    var callerResponder = new CallerResponder();
    callerResponder.success = function(jsonObj) {
      if(jsonObj != ""){
        $.alert(jsonObj);
      }else{
        doPigeonholeCheck(ids, pageType, tableId, grid);
      }
    };
    var cm = new colManager();
    cm.getPigeonholeRight(ids, callerResponder);
  }
  
  function doPigeonholeCol(ids, folder, pageType, tableId, grid){
    var cm = new colManager();
    for(var i = 0;i<ids.length;i++){
      cm.transPigeonhole(ids[i], folder[0], pageType);
    }
    //归档成功
    $.infor("${ctp:i18n('collaboration.grid.alert.archiveSuccess')}");
    //删除重复的文档
    cm.transPigeonholeDeleteStepBackDoc(ids, folder[0]);
    $("#"+tableId).ajaxgridLoad();
    grid.grid.resizeGridUpDown("down");
    if(tableId === "listPending"){
      $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total);          
    }
  }
  
  // 检查是否已存在归档协同
  function doPigeonholeCheck(ids, pageType, tableId, grid){
    var result = pigeonhole();
    if (result && result != "cancel") {
      var folder = result.split(",");
      var callerResponder = new CallerResponder();
      callerResponder.success = function(jsonObj) {
        if(jsonObj === "" || confirm(jsonObj)){
          doPigeonholeCol(ids, folder, pageType, tableId, grid);
        }
      }
      var cm = new colManager();
      cm.getIsSamePigeonhole(ids, folder[0], callerResponder);
    }
  }
  
  //转发协同
  function transmitColFromGrid(grid){
      // 需要判断是否只勾选了一项，并给出相应的提示   
      var selectBox = grid.grid.getSelectRows();
      if (selectBox.length === 0) {
          //请选择要转发的协同
          $.alert("${ctp:i18n('collaboration.grid.alert.transmitCol')}");
          return;
      }
      else if(selectBox.length > 20) {
          //只能选择20项协同进行转发
          $.alert("${ctp:i18n('collaboration.grid.alert.transmitColOnly20')}");
          return;
      }
      for(var i=0; i<selectBox.length; i++){
         var selectedObj = selectBox[i];
         var app = selectedObj.applicationCategoryKey || selectedObj.app;
         if(app == 19 || app == 20 || app == 21){
             //公文不允许转发协同
             $.alert("${ctp:i18n('collaboration.grid.alert.DocumentNotForwardCol')}");
             return;
         }
      }
      
      var data = [];
      for(var i = 0; i < selectBox.length; i++){
          var summaryId = null;
          var affairId = null;
          if(selectBox[i].summary){
              summaryId = selectBox[i].summary.id;
              affairId = selectBox[i].affairId;
          }
          else{//首页待办更多是Affair对象
              summaryId = selectBox[i].objectId;
              affairId = selectBox[i].id;
          }
          
          data[i] = {"summaryId": summaryId, "affairId": affairId};
      }
      
      transmitColById(data);
   }
   
   function transmitColById(data){
      var dataStr = "";
      for(var i = 0; i < data.length; i++){
          dataStr += data[i]["summaryId"] + "_" + data[i]["affairId"] + ",";
      }
      
      var cm = new colManager();
      var r = cm.checkForwardPermission(dataStr);
      if(r && (r instanceof Array) && r.length > 0){
          //以下协同不能转发，请重新选择
          $.alert(" ${ctp:i18n('collaboration.grid.alert.thisSelectNotForward')}"+"<br><br>" + r.join("<br>"));
          return;
      }
      
      var dialog = $.dialog({
          id : "showForwardDialog",
          url : "<c:url value='/collaboration/collaboration.do' />?method=showForward&data=" + dataStr,
          title : "${ctp:i18n('common.toolbar.transmit.col.label')}",
          targetWindow:getCtpTop(),
          transParams:{
              commentContent : ""
          },
          buttons: [{
              id : "okButton",
              text: $.i18n("common.button.ok.label"),
              handler: function () {
              	  var rv = dialog.getReturnValue();
              },
              OKFN : function(){
                  dialog.close();
                  try{
                      $("#listSent").ajaxgridLoad();
                  }
                  catch(e){
                  }
              }
          }, {
              id:"cancelButton",
              text: $.i18n("common.button.cancel.label"),
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
             $.alert("${ctp:i18n('collaboration.grid.alert.transmitCol')}");
             return;
         } else if(selectBox.length > 1) {
             //只能选择一项协同进行转发
             $.alert("${ctp:i18n('collaboration.grid.alert.transmitColOnlyOne')}");
             return;
         }
         for(var i=0; i<selectBox.length; i++){
             var selectedObj = selectBox[i];
             var app = selectedObj.applicationCategoryKey || selectedObj.app;
             if(app == "19" || app == "20" || app == "21"){
                 //公文不允许转发协同
                 $.alert("${ctp:i18n('collaboration.grid.alert.DocumentNotForwardEmail')}");
                 return;
             }
          }
         
         var summaryId = "";
         var affairId = "";
         if(selectBox[0].summary){
           summaryId = selectBox[0].summary.id;
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
             $.alert(" ${ctp:i18n('collaboration.grid.alert.thisSelectNotForward')}"+"<br><br>" + r.join("<br>"));
             return;
         }
         
         //处理自己的相关逻辑
         window.location.href =_ctxPath + "/collaboration/collaboration.do?method=forwordMail&id=" +summaryId;
     }
 }
</script>