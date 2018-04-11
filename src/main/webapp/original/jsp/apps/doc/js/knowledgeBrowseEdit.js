<%@ page contentType="text/html; charset=UTF-8"%>
var cPageData = new Object();
var jsURL="${path}/doc.do";
var docURL= jsURL ;
var defaultNameText = $.i18n('doc.log.default.word');
var tout = null;
$(function() {
    if (!window.dialogArguments) {
        new inputChange($("#name"), defaultNameText);
    }
    cPageData.ajaxPageManager = new knowledgePageManager();
    cPageData.ajaxKnowledgeManager = new knowledgeManager();
    cPageData.ajaxDocHierarchyManager = new docHierarchyManager();
    fnPageInit();   
    fnFileUploadCallBack();
    //关闭时解锁
    $(window).unload(function(){
      cPageData.ajaxDocHierarchyManager.unLockAfterAct('${doc.id}');
    });
});
/**
 * 页面初始化
 */
function fnPageInit(){
    cPageData.toolbar =  $("#toolbar").toolbar({
        borderTop : false,
        borderRight : false,
        borderLeft : false,
        isPager : false,
        toolbar : [{
            id : "toolbar_subscribeDoc",
            name : $.i18n('common.toolbar.insert.label'),
            className : "ico16 affix_16",
            subMenu : [{
                id : "aFileUploadId",
                name : $.i18n('common.toolbar.insert.localfile.label'),
                click : function() {
                    insertAttachment();
                }               
            }, {
                id : "associateFile",
                name : $.i18n('doc.jsp.open.label.rel'),
                click : function() {
                    quoteDocument('position1');
                }
             }
            ]
        },{
            id : "toolbar_properties",
            name : $.i18n('doc.jsp.open.label.prop'),
            click : fnSetProperties
        }]
    });
    $("#contentTypeId").change(fnSelectChange);
    //附件有可能显示不出
    /*if('${uploadFileBodyType == null}' === 'false') {
        cPageData.toolbar.hideBtn('aFileUploadId');
    }*/
	//OA-78209
    if("${isCanEditOnline && isUploadFile}" == "true"){
    	OfficeObjExt.setIframeId("officeFrameDiv");
    }else{
    	OfficeObjExt.setIframeId("docContent");
    }
}

function fnFileUploadCallBack(){
    fnReSizeWindow();
}
/**
 * 界面样式适配方法，调整界面布局，修改部分样式
 */
function fnReSizeWindow(){
    var assdoc = $("#assdoc");
    if (assdoc.find(".attachment_block").size()>0) {
        assdoc.show();
    }else {
        assdoc.hide();
    }
    var assdoc = $("#fileUpload");
    if (assdoc.find(".attachment_block").size()>0) {
        assdoc.show();
    }else {
        assdoc.hide();
    }
    $("#layout").layout().setNorth($("#layoutN_height").height());
    //绑定删除附件按钮
    $(".affix_del_16").unbind().click(function(){
        fnReSizeWindow();
    });
}

/**
 * 保存按钮的事件
 * @returns
 */
function fnSave(){
	if('${isCanEditOnline && isUploadFile}' !== 'true') {
		if(docContent.saveContent) {
			if(!(docContent.CKEDITOR || docContent.officeEditorFrame)) {
				$.alert($.i18n('doc.alert.content.loading'));
        		return;
			}
        } else {
            if(!(document.getElementById("docContent") && document.getElementById("docContent").contentWindow && document.getElementById("docContent").contentWindow.saveContent
        			&& (document.getElementById("docContent").contentWindow.CKEDITOR || document.getElementById("docContent").contentWindow.officeEditorFrame))) {
        		$.alert($.i18n('doc.alert.content.loading'));
        		return;
        	}
        }
    }
	var btnSave = $("#hrefFnSaveId");
    cPageData.proce = $.progressBar();
    //禁用保存按钮
    btnSave.removeAttr("onClick");
	btnSave.unbind("click");
    if('${!isIE && isOffice}' === 'true') {
    	btnSave.bind("click",fnSave);
        cPageData.proce.close();
        return;
    }
    var newName = $("#name").val().trim();
    var isNoChange = cPageData.ajaxDocHierarchyManager.docResourceNoChange("${doc.id}", "${doc.logicalPath}");
    if(isNoChange === "move" || isNoChange === "delete") {
        $.alert($.i18n('doc.alert.document.delete'));   
        getCtpTop()._docDialog.close();
        getCtpTop()._docDialog=null;
        cPageData.proce.close();
        return;        
    }
    
    if (newName === defaultNameText
            || newName.length === 0) {
        cancelName();
    }
    
    if(!$("#name").validate()){
    	btnSave.bind("click",fnSave);
        cPageData.proce.close();
        return
    }
    
    if(newName != "${ctp:toHTML(doc.frName)}") {
        var hasSameName = cPageData.ajaxDocHierarchyManager.hasSameNameAndSameTypeDr("${doc.parentFrId}",'${doc.id}',newName,"${doc.frType}");
        if(hasSameName) {
            $.alert($.i18n('doc.alert.document.rename'));
            btnSave.bind("click",fnSave);
            cPageData.proce.close();
            return;
        }
    }
    
    if(!checkForm(mainForm)) {
        fnSetProperties();
        btnSave.bind("click",fnSave);
        cPageData.proce.close();
        return;
    }
    
    unlockAfterAction("${doc.id}");
    if('${isCanEditOnline && isUploadFile}' === 'true') {
        fnSaveUploadFile();
    } else {
        if(docContent.saveContent) {
            docContent.saveContent("${doc.id}",newName,fnSaveCallback,fnFailedCallBack);
        } else {
            document.getElementById("docContent").contentWindow.saveContent("${doc.id}",newName,fnSaveCallback,fnFailedCallBack);
        }
    }   
}

function cancelName() {
    $("#name").val("");
}
/**
 * 对于可编辑的上传文档的保存
 * @param clearCtp
 * @returns
 */
function fnSaveUploadFile() {
    saveOffice();
    $("#fileId").val(fileId);
    var sUrl = "${path}/doc.do?method=theNewModifyDoc&docContent=${uploadFileContent}&docResId=${doc.id}&docLibType=${docLib.type}&isUploadFile=${v3x:escapeJavascript(param.isUploadFile)}&bodyCreateDate=${uploadFileCreateDate}&isCanEditOnline=${isCanEditOnline}&frType=${doc.frType}&originalFileId=${originalFileId}&fileId"+fileId;
    $("#dataSubmitDomain").jsonSubmit({
        action : sUrl,
        domains : ["contentDiv","extendDiv","frName","contentTypeId","attachment1","attachment2"],        
        callback : function(oReturn) {
            getA8Top().window.close();
            if (v3x.getParentWindow() && v3x.getParentWindow().getA8Top()) {
                v3x.getParentWindow().getA8Top().fnRefresh();
            }
        }
    });
}
/**
 * 保存成功的回调函数
 * @param param
 * @returns
 */
function fnSaveCallback(param) {
    var sUrl = "${path}/doc.do?method=theNewModifyDoc&docResId=${doc.id}&docLibType=${docLib.type}&isFile=${v3x:escapeJavascript(param.isUploadFile)}&isCanEditOnline=${isCanEditOnline}&frType=${doc.frType}";
    $("#dataSubmitDomain").jsonSubmit({
        action : sUrl,
        domains : ["contentDiv","extendDiv","frName","contentTypeId","attachment1","attachment2"],     
        callback : function(oReturn) {
            getA8Top().window.close();
            if (v3x.getParentWindow() && v3x.getParentWindow().getA8Top()) {
                v3x.getParentWindow().getA8Top().fnRefresh();
            }
        }
    });
}

function fnFailedCallBack(param) {
    $.alert($.i18n('ocx.alert.savefail.label'));
    //解除按钮禁用功能
    cPageData.proce.close();
}
/**
 * 属性事件
 * @returns
 */
function fnSetProperties() {
    editDocProperties('${doc.id}');
}

function fnSelectChange(){
    var oParam={contentTypeId: $(this).val(),docResId:'${doc.id}',oldCTypeId:$('#oldCTypeId').val()};
    $("#fromAction").jsonSubmit({
        action: jsURL+'?method=changeContentType&isJsonSubmit=true',
        paramObj:oParam,
        callback: function(json) {
             $("#extendDiv").html(json);
        }
    });
}

function fnCloseDialog() {
        var _dialog = getA8Top()._dialog;
        getA8Top()._dialog = null;
        cPageData.proce.close();
        _dialog.close();    
}

function dialogCloseUnlock() {
  if("${param.method}" == "editDoc"){
    return;
  }
  if(window.parentDialogObj || parent.parentDialogObj) {
        getA8Top()._dialog.targetWindow.$('#' + getA8Top()._dialog.id + '_close').click(function(){
          unlockAfterAction('${doc.id}');
        });
  } else {
    if(getA8Top()._dialog && getA8Top()._dialog.targetWindow){
      var _closeBtn = getA8Top()._dialog.getClass("span","mxt-window-head-close")[0];
      try {
        if (_closeBtn.removeEventListener) {
          _closeBtn.removeEventListener("click",getA8Top()._dialog.closeParam.handler);
            } else {
              _closeBtn.detachEvent("onclick", getA8Top()._dialog.closeParam.handler);
            }
            if (_closeBtn.addEventListener) {
              _closeBtn.addEventListener("click", function(){
                unlockAfterAction('${doc.id}');
            parent.fnIsRefresh();
          }, false);
            } else{
                _closeBtn.attachEvent("onclick", function(){
                  unlockAfterAction('${doc.id}');
              parent.fnIsRefresh();
            });
            }
        } 
        catch (e) {
        }
    }
  }
}