/** 将知识管理模块Controller中的JS代码集中转至此处，便于日后调试和修改 **/

/* public ModelAndView move(HttpServletRequest request, HttpServletResponse response) 移动文档、文档夹  Start */
/** 移动文档、文档夹过程中出现异常(存在重名文档)时的处理：按钮置为可用、给出提示信息、刷新目的地选择页面 */
function handleExceptionWhenMoveDocs(expMsg, param) {
	parent.window.returnValue = "false";
	enableButtonsAndAlertMsg(expMsg, param);
	window.location.href = window.location;
}
function handleConcurrencyWhenMoveDocs(expMsg, param) {
	enableButtonsAndAlertMsg(expMsg, param);
	parent.window.returnValue = "true";
	parent.window.close();
}
/** 被移动的对象包括文档夹时，目的地文档夹需在操作完成之后重载，以便同步树型结构的展现 */
function afterMoveDocs(folderMoved, destIdStr) {
	if(folderMoved == 'true')
		refreshTreeAfterFolderMoved(destIdStr, true);
	returnValueAndClose('true');
}
/** 当文档夹被移动到目的地之后，同步树型结构的展现 */
function refreshTreeAfterFolderMoved(docResIdStr, reload) {
	var tree;
	if(parent.dialogArguments == null){
		if(parent.parent.parent.treeFrame){
			tree = parent.parent.parent.treeFrame.webFXTreeHandler;
		}else if(parent.parent.treeFrame){
			tree = parent.parent.treeFrame.webFXTreeHandler;
		}else if(parent.treeFrame){
			tree = parent.treeFrame.webFXTreeHandler;
		}else{
			tree = treeFrame.webFXTreeHandler;
		}
	} else {
		tree = parent.dialogArguments.parent.treeFrame.webFXTreeHandler;
	}
	var node = tree.all[tree.getIdByBusinessId(docResIdStr)];
	if(typeof eval(node) != 'undefined') {
		try {
			if(reload) {
				node.reload();
			} else {
				node.remove();
			}
		} catch(e){}
	}
}
/* public ModelAndView move(HttpServletRequest request, HttpServletResponse response) 移动文档、文档夹  End */

/* public ModelAndView createFolder(HttpServletRequest request, HttpServletResponse response) 创建文档夹 Start */
/** 将确定、取消按钮置为可用，给出提示信息 */
function enableButtonsAndAlertMsg(expMsg) {
	var b1;
	var b2;
	if(v3x.getBrowserFlag('openWindow')){
		b1 = parent.window.document.getElementById("b1");
		b2 = parent.window.document.getElementById("b2"); 
	} else {
		b1 = top.document.getElementById('b1');
		b2 = top.document.getElementById('b2');
	}
	if(b1)
		b1.disabled = false;
	if(b2)
		b2.disabled = false;
	var msg = expMsg;
	if(expMsg.indexOf('DocLang.') == -1)
		msg = 'DocLang.' + expMsg;
	if(arguments.length>1){
		alert(parent.v3x.getMessage(msg, arguments[1]));
	}else{
		alert(parent.v3x.getMessage(msg));
	}
}
/** 创建文档夹后，同步树型结构的展现 */
function afterCreateFolder(parentDocId) {
	afterMoveDocs('true', parentDocId);
}
function handleParentDelWhenCreateFolder(parentId) {
	refreshTreeAfterFolderMoved(parentId);
	closeAndRefresh('doc_alert_source_deleted_folder');
}
/**
 * 在删除文档夹的时候，同步将树型结构中的节点删除
 */
function removeTreeNode(docResId) {
	var obj = parent.treeFrame;
	if(typeof obj.webFXTreeHandler.all[obj.webFXTreeHandler.getIdByBusinessId(docResId)] != undefined) {
		try {
			obj.webFXTreeHandler.all[obj.webFXTreeHandler.getIdByBusinessId(docResId)].remove();
		} catch(e){}
	}
}
/**
 * 给出提示信息，关闭当前页面，刷新父级页面
 * @param expMsg 提示信息key
 */
function closeAndRefresh(expMsg, msgParam) {
	if(arguments.length>1)
		alert(v3x.getMessage("DocLang." + expMsg, arguments[1]));
	else
		alert(v3x.getMessage("DocLang." + expMsg));
	if(window.dialogArguments) {
		window.dialogArguments.parent.parent.location.reload(true);
		window.close();
	} else {
		parent.winCreateFolder.close();
	}	
	
}
/* public ModelAndView createFolder(HttpServletRequest request, HttpServletResponse response) 创建文档夹 End */

/** 模态对话框返回值并关闭 */
function returnValueAndClose(isParent) {
	if(v3x.getBrowserFlag('openWindow') == false && parent.parent.winMove){
		parent.window.transParams.parentWin.openDialog4IpadCollBack(isParent);
	}else{
		var obj = isParent && isParent == 'true' ? window.parent : window;
		obj.returnValue = "true";
		obj.close();
	}
	if(parent.winCreateFolder || parent.winEdocCreateFolder){
			parent.window.location.href=parent.window.location;
			if(parent.winCreateFolder)
				parent.winCreateFolder.close();
			if(parent.winEdocCreateFolder)
				parent.winEdocCreateFolder.close();
		}
}
/**
 * 在添加或修改文档库时，文档库重名时的js动作响应
 */
function handleDocLibName(msg) {
//	alert(v3x.getMessage('DocLang.doc_lib_add_doclib'));
	alert(msg);
	try {
		getA8Top().endProc();
	} catch(e){}
	document.getElementById('b1').disabled = false;
	document.getElementById('b2').disabled = false;
}
function handleExceptionWhenSaveDocLib(msgKey) {
	var msg = v3x.getMessage(msgKey);
	if(!msg || msg == '' || msg.trim() == '') {
		msg = v3x.getMessage('DocLang.' + msgKey);
		if(!msg  || msg == '' || msg.trim() == '') {
			msg = v3x.getMessage('DocLang.exception_save_doclib');
		}
	}
	alert(msg);
	try {
		getA8Top().endProc();
	} catch(e){}
	document.getElementById('b1').disabled = false;
	document.getElementById('b2').disabled = false;
}