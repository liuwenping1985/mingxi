/* 文档历史版本管理js方法 */
/**
 * 在历史版本列表页面按照修改人姓名查询时，选人界面值回传
 */
function setDocVersionPeopleFields(elements){
	document.getElementById("userId").value = getIdsString(elements, false);	
	document.getElementById("userName").value = getNamesString(elements);
	document.getElementById("userName").title = getNamesString(elements);
}

/**
 * 查看历史版本记录内容
 * @param docVersionId	历史版本记录ID
 */
function viewHistoryVersion(docVersionId,entranceType,viewHistoryVersion) {
  var widths,heights,topWindow =  getA8Top().document.documentElement;
	var widths = topWindow.clientWidth - 20,heights = topWindow.clientHeight - 20;
	if (widths <= 0 || heights <= 0) {
		widths = document.body.clientWidth-20, heights = document.body.clientHeight-20;
	}
  var windowParam = {
      "id" : 'viewHistoryVersion',
      "url" : "/seeyon/doc.do?method=knowledgeBrowse&docVersionId="+docVersionId+"&v="+viewHistoryVersion+"&entranceType="+entranceType + "&versionFlag=HistoryVersion",
      "width": widths,
      "height": heights,
      "targetWindow" :getA8Top(),
      "title" : v3x.getMessage('DocLang.doc_browse_history'),
      "model" : false
  };
  
  if(typeof($) !== 'undefined' && $.dialog) {
    windowParam.top = 10;
    windowParam.height -= 30;
    windowParam.checkMax = false;
    windowParam.closeParam.show = true;
    $.dialog(windowParam);
  } else {
  	new MxtWindow(windowParam);
  }
}
/**
 * 根据当前用户的权限，初始化查看历史版本记录内容时，工具栏的菜单按钮出现或置灰(docOpenMenu.jsp)
 */
function initHistoryViewMenuACL(all, edit, add, readonly, browse, list, isBorrowOrShare, isUploadFile) {
	if(all == 'false' && edit == 'false' && readonly == 'false') {
		if(isUploadFile == 'false') {
			document.getElementById("print").disabled = true;
		}
		document.getElementById("download").disabled = true;
	}
}
/**
 * 根据当前用户的权限，在查看历史版本记录的列表页面时，工具栏的菜单按钮出现或置灰(docResHistories.jsp)
 */
function initVersionListMenuACL(all, edit, add, readonly, browse, list, isBorrowOrShare, isUploadFile) {
	if(all == "false") {
		docDisable("delete");
		//document.getElementById("delete").disabled = true;
	}
	
	if(all == "false" && edit == "false") {
//		document.getElementById("renew").disabled = true;
//		document.getElementById("editComment").disabled = true;
		docDisable("renew");
		docDisable("editComment");
	}
}
/**
 * AJAX校验文档历史版本是否还存在
 */
function validHistoryVersionExist(docVersionId) {
	var requestCaller = new XMLHttpRequestCaller(this, "docVersionInfoManager", "isDocVersionExist", false);
    requestCaller.addParameter(1 ,"Long", docVersionId) ;
    var has = requestCaller.serviceRequest();
    return has == "true" || has == true;
}
/**
 * 修改选中历史版本记录的版本注释内容
 * @param docVersionId	历史版本记录ID
 */
var editCommentItem = {};
function toEditComment(id) {
	var surl = "/seeyon/genericController.do?ViewPage=apps/doc/history/editVersionComment&docVersionId=";
	var result;
	if(id) {
		result = id;
	} else {
		result = getSelectId(v3x.getMessage("DocLang.doc_spaces_alter_not_select"), v3x.getMessage("DocLang.doc_space_alter_select_one"));
		if(result == false)
			return;
	}
	editCommentItem.result = result;
	getA8Top().docEditCommentWin = getA8Top().$.dialog({
        title:" ",
        transParams:{'parentWin':window},
        url: surl += result,
        width:320,
        height:240,
        isDrag:false
    });
}

function editCommentCollBack (rv) {
	getA8Top().docEditCommentWin.close();
	if(rv && rv.length == 2 && rv[0] == 'true') {
		document.getElementById("versionCommentDiv_" + editCommentItem.result).title = rv[1];
		document.getElementById("versionCommentLabel_" +  editCommentItem.result).innerHTML = rv[1].getLimitLength(40, "...").escapeHTML();
		
		var requestCaller = new XMLHttpRequestCaller(this, "docVersionInfoManager", "updateVersionComment", false);
	    requestCaller.addParameter(1 ,"Long", editCommentItem.result);
	    requestCaller.addParameter(2 ,"String", rv[1]);
	    requestCaller.serviceRequest();
	}
}
/**
 * 删除选中的历史版本记录
 * @return
 */
function deleteDocResHistory() {
	var ids = getSelectId(v3x.getMessage("DocLang.doc_select_delete_history_alert"));
	if(ids == false || !window.confirm(v3x.getMessage("DocLang.doc_delete_history_confirm")))
		return;

	deleteIframe.location = jsURL + "?method=deleteDocVersions&docVersionIds=" + ids;
}
/**
 * 将选中的历史版本记录恢复为最新版本
 * @return
 */
function replace2Latest(docResId) {
	var result = getSelectId(v3x.getMessage("DocLang.doc_replace_alter_not_select"), v3x.getMessage("DocLang.doc_replace_alter_select_one"));
	if(result == false || !window.confirm(v3x.getMessage('DocLang.doc_replace_confirm')))
		return;
	
	if(checkLock(docResId, false) == false) {
		return;
	}
	
	startProc(v3x.getMessage("DocLang.doc_replace_process"));
	
	// 进行替换操作时加锁
	lockWhenAct(docResId);
	
	var requestCaller = new XMLHttpRequestCaller(this, "docVersionInfoManager", "replaceVersion2Latest", true);
    requestCaller.addParameter(1, "Long", result);
    requestCaller.addParameter(2, "Long", docResId);
    
	this.invoke = function(ds) {
		//历史版本被删除
	    if(ds && ds.length == 2) {
		    if(ds[0] == "false") {
				endProc();
		    	alert(v3x.getMessage("DocLang.doc_history_not_exist"));
		    	window.location.href = window.location;
		    	return;
		    }
		    
		    
		    if(ds[1] == "false" || (ds[0] == "true" && ds[1] == "true")) {
		    	endProc();
		    	//主文档被删除
		    	if(ds[1] == "false")
		    		alert(v3x.getMessage("DocLang.doc_history_and_resource_not_exist"));
		    	//成功恢复
				else
				alert(v3x.getMessage("DocLang.doc_replace_ok"));
		    	parent.window.transParams.parentWin.docHisCollBack("true");
				return;
		    }
	    }
	    else {
	    	endProc();
	    	alert(v3x.getMessage("DocLang.doc_replace_exception"));
	    	window.location.href = window.location;
	    }
	}
	requestCaller.serviceRequest();
	
	// 替换完成之后解锁
	unlockAfterAction(docResId);
}
