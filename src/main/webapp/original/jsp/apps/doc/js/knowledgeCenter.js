<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
var jsURL = "${path}/doc.do";
var docLibType = "1";
var isUploadFileMimeType = '0';
var sendTOlearnDoc,winRename;
var ajaxKnowledgePageManager = new knowledgePageManager();

/**
 * 使用弹出式菜单进行操作时，进行锁（包括应用锁和并发锁）状态校验
 */
function checkDocLock(docId, isFolder) {
	var msg_status = getLockMsgAndStatus(docId);
    if(msg_status && msg_status[0] != LOCK_MSG_NONE && msg_status[1] != LockStatus_None) {
        // 如果是应用锁定或文档已被删除，需刷新列表显示
        if(msg_status[1] == LockStatus_DocInvalid || msg_status[1] == LockStatus_AppLock) {
            if(msg_status[1] == LockStatus_DocInvalid) {
                if(isFolder == 'true') {
                    $.alert('${ctp:i18n("doc.jsp.knowledge.sourceDoc.deleted")}');
                } else {
                    $.alert('${ctp:i18n("doc.jsp.knowledge.sourceDoc.deleted")}');
                }
            } else {
                $.alert(msg_status[0]);
            }
            window.location.reload(true);
        } else {
            // 隐藏弹出菜单之后弹出提示信息
            $.alert(msg_status[0]);
        }
        return false;
    }
    return true;
}

// 发送到常用文档弹出框
function sendToCommonDoc(docId) {
    var knowledgeManagerAjax = new knowledgeManager();
    var param = new Object();
    param.docId = docId;
    knowledgeManagerAjax.sendToCommonDoc(param, {success:
        function(result){
            if(result) {
            	$.infor("${ctp:i18n('doc.knowledge.send.common')}");
            }
        }
    });
}

// 发送到个人学习弹出框
function sendToMyStudy(docId) {
	sendTOlearnDoc = docId;
    selectPeopleFun_perLearnPop();
}

// 发送到个人学习区
function sendToPersonalLearn(elements, flag){
	if(!elements) {
		return;
	}
	var ids = "";
	for(var i = 0; i < elements.length; i++) {								
		ids += "," + elements[i].id+'|'+elements[i].type;	
	}
	
	var url = jsURL + "?method=sendToLearn&docId=" + sendTOlearnDoc + "&userIds=" + encodeURIComponent(ids.substring(1, ids.length)) + "&userType=member";
    AjaxDataLoader.load(url, null, function(str){
        $.infor("${ctp:i18n('doc.learning.personal.success.alert')}");
    }); 
}

// 发送到指定位置弹出框
function sendToSpecificLocation(docId, parentId, docLibId) {
    selectDestFolder(docId, parentId, docLibId, "1", "link");

}

// 下载弹出框
function downloadDoc(docId, docName, docMimeType, sourceId, createDate,vForDownload) {
    // menuDownload(docId, docName, true);
    var isUploadFile = 'false';
    if(docMimeType != 22 && docMimeType != 23 && docMimeType != 24 && docMimeType != 25 && docMimeType != 26) {
        isUploadFile = 'true';
    }
    ajaxRecordOptionLog(docId,"downLoadFile");
    if(isUploadFile == 'true'){
        location.href="${path}/fileDownload.do?method=download&viewMode=download&fileId="+sourceId+"&createDate="+createDate+"&filename=" + encodeURIComponent(docName)+"&v="+vForDownload;
    }else{
        var proce = $.progressBar();
        // 压缩
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docDownloadCompress", true);
        requestCaller.addParameter(1, "long", docId);
        var flag = 'false';
        this.invoke = function(ds) {
            flag = 'true';
            proce.close();
            location.href = "${path}/doc.do?method=docDownloadNew&id="+docId;
        }
        requestCaller.serviceRequest();
    }
}

// 编辑弹出框
function edit(docId, docName, docMimeType) {
	isUploadFileMimeType = '0';
    if(docMimeType != 22 && docMimeType != 23 && docMimeType != 24 && docMimeType != 25 && docMimeType != 26) {
        isUploadFileMimeType = docMimeType;
    }
    fnEditDocFromToolbar(docId, docName);
}

// 移动弹出框
function moveDoc(docId, parentId, docLibId) {
    selectDestFolder(docId, parentId, docLibId, "1", "move");
}

// 替换弹出框
var replaceDocItem = {};
function replaceDoc(docId, parentId, docName) {
	replaceDocItem.docName = docName;
	replaceDocItem.parentId = parentId;
	replaceDocItem.docId = docId;
    //docReplace(docId, "1", docName, parentId, "false");
    if(checkLock(docId, false) == false) {
        return;
    }
    fileUploadQuantity = 1;
    fileUploadAttachments.clear(); // 清空缓存
    insertAttachment();
}

function callbackInsertAttachmentReplace () {
	if(fileUploadAttachments.isEmpty() == false) {
        var keys=fileUploadAttachments.keys();
        var attach=fileUploadAttachments.get(keys.get(0), null); // 附件对象
        
        if(replaceDocItem.docName != attach.filename){
        	if(!window.confirm("${ctp:i18n('doc.knowledge.mylib.replace')}")){
        		fileUploadAttachments.clear();
                return;
        	}
        	
//            var confirm = $.confirm({ 'msg': "${ctp:i18n('doc.knowledge.mylib.replace')}", 
//                ok_fn: function () { },
//                cancel_fn:function(){ fileUploadAttachments.clear(); return; } 
//                });
             
            var typeId = 21;// 21 说明是文件的比较
            var exist = dupliName(replaceDocItem.parentId,attach.filename,typeId,false);
            if('true' == exist){
                $.alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert',attach.filename));
                return;
            }
        }
        saveAttachment();
        var theForm = document.mainForm;
        theForm.target = "emptyIframe";
        var url = jsURL + "?method=docReplace&docLibType=1&isNew=true&docResId=" + replaceDocItem.docId;
        theForm.action = url;
        theForm.submit();
        //$('#myKnowledgeLib').click();
        //AjaxDataLoader.load(url, null, function(str){
            // alert(999);
        //}); 
    }
}

// 删除弹出框
function deleteDoc(docId) {
    var confirm = $.confirm({
        'msg': "${ctp:i18n('doc.knowledge.mylib.delete')}",
        ok_fn: function () {
            if (checkDocLock(docId, false) == false) {
                return;
            }
            var knowledgeManagerAjax = new knowledgeManager();
            var param = new Object();
            param.docId = docId;
            knowledgeManagerAjax.deleteDoc(param, {success:
                function(result){
                    if (result == 0) {
                        // $.infor("${ctp:i18n('doc.knowledge.mylib.success')}");
                    } else if (result == 1) {
                        $.alert("${ctp:i18n('doc.knowledge.mylib.lock')}");
                    } else {
                        $.alert("${ctp:i18n('doc.knowledge.mylib.delete.error')}");
                    }
                    
                    var myKnowledgeLib = top.frames.main.document.getElementById("myKnowledgeLib");
                    if(myKnowledgeLib){
                        myKnowledgeLib.click();
                    }else{
                        window.location.reload(true);
                    }
                }
            });
        },
        cancel_fn:function(){
        }
    });
    
}

// 重命名弹出框
function renameDoc(docId) {
    var renameUrl = "${path}/doc.do?method=reName&from=knowledgeCenter&rowid="+docId;
    // rename(renameUrl, "false", docId)
    var isFolder = false;
    if(checkDocLock(docId, isFolder) == false) {
        return;
    }
    
    if($.dialog){
    winRename = $.dialog({
        id : "rename",
        title : '${ctp:i18n("doc.jsp.rename.title")}',
        url : renameUrl,
        width : 380,
        height : 120,
        targetWindow:getA8Top(),
        buttons : [{
            id:'btn1',
            isEmphasize:true,
            text: v3x.getMessage("DocLang.submit"),
            handler:fnReNameSubmit
        }, {
            id:'btn2',
            text: v3x.getMessage("DocLang.cancel"),
            handler: function(){
                winRename.close();
            }
        }]
    
    });
    } else {
    var returnvalue = v3x.openWindow({
        url : renameUrl,
        width : "380",
        height : "200",
        resizable : "yes"
    });
    if(returnvalue) {
        var docResId = returnvalue[0];
        var newName = returnvalue[1];
        var myKnowledgeLib = top.frames.main.document.getElementById("myKnowledgeLib");
        if(myKnowledgeLib){
            myKnowledgeLib.click();
        }else{
            window.location.reload(true);
        }
        if (isFolder == "true") {       
            var obj = parent.treeFrame;
            if (obj.webFXTreeHandler.getIdByBusinessId(docResId) != undefined) {            
                obj.webFXTreeHandler.all[obj.webFXTreeHandler.getIdByBusinessId(docResId)].setText(newName);
            }
        }
    }
    }
}

/**
 * 重命名提交
 */
function fnReNameSubmit(){
    winRename.getReturnValue();
    setTimeout(
 		function(){
 			winRename.close();
 			$("#myKnowledgeLib").trigger("click");
 		},100);
}

// 借阅弹出框
function borrowDoc(docId,v) {
    var borrowUrl = "${path}/doc.do?method=docPropertyIframe&isP=false&isB=true&isM=false&isC=false&docLibType=1&isShareAndBorrowRoot=false&all=true&edit=true&add=true&readonly=true&browse=true&list=true&isFolder=false&isPersonalLib=true&propEditValue=true&allAcl=true&docResId="+docId+"&v=" +v;
    v3xOpenWindow(borrowUrl,"${ctp:i18n('doc.menu.admin.properties')}");
}

// 属性弹出框
function docProperties(docId,isPig,v) {
    var propertyUrl = "${path}/doc.do?method=docPropertyIframe&isP=true&isB=false&isM=false&isC=false&docLibType=1&frType=40&parentCommentEnabled=&parentRecommendEnable=&flag=&isShareAndBorrowRoot=false&all=true&edit=true&add=true&readonly=true&browse=true&list=true&isFolder=false&isPersonalLib=true&propEditValue=true&allAcl=true&docResId="+docId+"&isPig="+isPig+"&v=" +v;
    v3xOpenWindow(propertyUrl,"${ctp:i18n('doc.menu.admin.properties')}");
}