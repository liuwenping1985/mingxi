
function initStepBack() {
	var isStepBackWaitToDo = false; 
	if(subState == "15" || subState == "16" || subState == "17") {
		isStepBackWaitToDo = true;
	}
	//被退回人按钮屏蔽
	if(isStepBackWaitToDo) {
		setButtonCanUseReady(subState);
	}
}

//指定回退
function specifiesReturnFunc() {
  var lockWorkflowRe = lockWorkflow(_contextProcessId,_currentUserId, 9);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        return;
    }
    disableOperation();
    if ($.content.callback.specifiesReturnFunc) {
        $.content.callback.specifiesReturnFunc();
    }
}
    
// 是否是指定回退
function isSpecifiesReturn(type){
    // type === 1表示被回退者不限制
    if(!type || type === 1){
        if(subState == "15" || subState == "17"){
            $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
            enableOperation();
            setButtonCanUseReady();
            return true;
        }
    }
    if(!type){
        if(subState == "16" || subState == "17"){
            $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
            enableOperation();
            setButtonCanUseReady();
            return true;
        }
    }
    return false;
}
 
function setButtonCanUseReady(){
    //其他节点(待办),并发的两个节点，其中一个节点做了指定回退，另外一个的状态就是这个分支
	try{
	    if(inInSpecialSB){
	        setButtonCanUse('_concurrentBranch');
	    }else if(affairState =='3' && (subState == "15" || subState == "16" || subState == "17")){
	        setButtonCanUse(subState);
	    }
	}catch(e){}
}

//是否指定回退被回退者
function isSpecifiesBacked(){
    if(subState == "16"){
        $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
        enableOperation();
        setButtonCanUseReady();
        return true;
    }
}

//是否指定回退者
function isSpecifiesBack(){
    if(subState == "15" || subState == "17"){
        $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
        enableOperation();
        setButtonCanUseReady();
        return true;
    }
}

//指定回退
function specifiesReturn() {
	// 指定回退状态
	if(isSpecifiesBack()){
		enableOperation();
		setButtonCanUseReady();
		return;
	}
	if (!dealCommentTrue()){
		enableOperation();
		setButtonCanUseReady();
		return;
	}
	stepBackToTargetNode(getCtpTop(), getCtpTop(),
       _summaryItemId,_summaryProcessId,
       _summaryCaseId, _summaryActivityId,
       stepBackToTargetNodeCallBack,
       show1, show2,isFromTemplate);
}

function stepBackToTargetNodeCallBack(workitemId, processId, caseId, activityId, theStepBackNodeId, submitStyle, falshDialog) {
	falshDialog.close();
	var domains = [];
	if($.content.getContentDealDomains(domains)) {
		domains.push("colSummaryData");
	   	domains.push("govFormData");
	   	domains.push("attachments");
	   	domains.push("attFileDomain1");
	   	domains.push("assDocDomain1");
	   	domains.push("assDocDomain");
	   	domains.push("attFileDomain");
	   	saveAttachmentPart("attFileDomain1");
	    saveAttachmentPart("assDocDomain1");
	    saveAttachmentPart("assDocDomain");
	    saveAttachmentPart("attFileDomain");
	   var jsonSubmitCallBack = function(){
		   $("#layout").jsonSubmit({
			   action : _ctxPath+ "/info/infoDetail.do?method=appointStepBack"
			   +"&workitemId="+workitemId
			   +"&processId="+processId
			   +"&caseId="+caseId
			   +"&activityId="+activityId
			   +"&theStepBackNodeId="+theStepBackNodeId
			   +"&submitStyle="+submitStyle
			   +"&summaryId="+summaryId
			   +"&affairId="+affairId,
			   domains : domains,
			   callback:function(data) {
				   closeInfoDealPage("listInfoPending");
			   }
		   });
	   };
	   jsonSubmitCallBack();
	}
}


/********************* 回退 *******************************/

//回退（用于处理协同的业务逻辑处理）
function stepBackCallBack(){
	//置灰
	disableOperation();
	var confirm = "";
	if (!dealCommentTrue()) {
		enableOperation();
		setButtonCanUseReady();
      return;
	}
	//调用工作流函数判断是否能够回退
	var obj = canStepBack(_contextItemId,_contextProcessId,_contextActivityId,_contextCaseId);
	//不能回退
	if(obj[0] === 'false'){
		$.alert(obj[1]);
		enableOperation();
		setButtonCanUseReady();
		return;
	}
	var lockWorkflowRe = lockWorkflow(_contextProcessId,_currentUserId, 9);
	if(lockWorkflowRe[0] == "false"){
		$.alert(lockWorkflowRe[1]);
		enableOperation();
		setButtonCanUseReady();
		return;
	}
  
	if(!isAffairValid(affairId)) return;
  
	confirm = $.confirm({
		'msg':$.i18n('collaboration.confirmStepBackItem'),
		ok_fn: function () {
			
			//保存意见附件信息
			saveAttachmentPart("attFileDomain1");
		    saveAttachmentPart("assDocDomain1");
		    
	        $.content.getContentDomains(function(domains) {
	        	if($.content.getContentDealDomains(domains)) {
	        		domains.push("colSummaryData");
	        		domains.push("attFileDomain1");
	        	   	domains.push("assDocDomain1");
	        	   	
	        		var jsonSubmitCallBack = function(){
			        	 $("#layout").jsonSubmit({
		                        action : _ctxPath + '/info/infoDetail.do?method=stepBack&affairId='+affairId+'&summaryId='+summaryId,
		                        domains : domains,
		                        validate:false,
		                        callback:function(data){
		                        	closeInfoDealPage();
		                        }
		                 });
			        };
				    jsonSubmitCallBack();
	        	}
	        },'stepBack');
		},
		cancel_fn:function(){
			releaseWorkflowByAction(_contextProcessId, _currentUserId, 9);
			enableOperation();
			setButtonCanUseReady();
			confirm.close();
		},
		close_fn:function(){
			enableOperation();
			setButtonCanUseReady();
		}
	});
}


function setButtonCanUse(subState){
    if(subState == "15") {//协同-待办-主动指定回退的状态，我指定回退给别人，这是我的状态
        
      //禁用按钮
        disableDealBtns(["specifies_return","step_back","submit","zcdb","add_flow_node"
                         ,"del_flow_node","current_assign","more_assign","modify_text","modify_att"
                         ,"push_msg", "track","pigeonhole"]);
        
    }else if(subState == "16") {//协同-待办--被指定回退到的事项，别人回退给我，这是我的状态

      //禁用按钮
        disableDealBtns(["step_back","zcdb","add_flow_node","del_flow_node","current_assign"
                         ,"more_assign"]);
        //取回(待办下无此操作)
          
    } else if(subState == "17") {//协同-待办--被指定回退到的事项，又指定回退给别人，中间事项的状态，比如A->B->C->D，D指定回退给C，C又制定回退给B。那么此时C的状态就是17
        
        //禁用按钮
        disableDealBtns(["modify_text","modify_att","specifies_return","step_back","zcdb"
                         ,"add_flow_node","del_flow_node","current_assign","more_assign","push_msg","track","pigeonhole"
                         ,"submit"]);
        
        //取回(待办下无此操作)
        
    }else if(subState =='_concurrentBranch') {//与回退节点并发的节点
        
      //禁用按钮
        disableDealBtns(["specifies_return","step_back"]);
    }
}