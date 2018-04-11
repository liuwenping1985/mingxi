<%@ page contentType="text/html; charset=UTF-8"%>
var cPageData = new Object();
var defaultNameText = $.i18n('doc.log.default.word');
var contentTypeId = null;
var jsURL="${path}/doc.do";
var docURL= jsURL ;
var tout = null;
//全局变量，确保保存的时候，只执行一次
var firstSave = true;
$(function() {
    $.confirmClose();
    if('${isProject}' === 'true') {
      showCtpLocation('F04_docIndex');
    }   
    if (!window.dialogArguments) {
        new inputChange($("#name"), defaultNameText);
    }
    cPageData.keyword="";
    cPageData.description="";
    cPageData.ajaxPageManager = new knowledgePageManager();
    cPageData.ajaxKnowledgeManager = new knowledgeManager();
    cPageData.ajaxDocHierarchyManager = new docHierarchyManager();   
    if("${param.isDialog}"==="true"){
        $("#dataSubmitDomainTabId").removeClass("border_r border_l border_t");
        $("#divFreamId").removeClass("border_r");
    }
    fnPageInit();
    //tout=setTimeout("fnReSizeOfficeWindow()",500);
});

/**
 * 页面初始化
 */
function fnPageInit(){
    $("#toolbar").toolbar({
      borderBottom:false,
      borderTop:false,
      borderRight:false,
      borderLeft:false,
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
    //增加文档类型属性事件
    $("#contentTypeId").change(fnSelectChange);
    fnFileUploadCallBack();
	
	//OA-78209
	getCtpTop().OfficeObjExt.showExt = showOfficeObjExt;
}
/**
 * 提供对Dialog弹出窗中含office插件的隐藏问题
 */
getCtpTop().OfficeObjExt.showDialogOffice =function(_tpWin,isChrome){
	var isDialog = false;	  
	if(_tpWin.isOffice && _tpWin.officeObj && _tpWin.officeObj.length>0){
	  for(var i = 0; i<_tpWin.officeObj.length;i++){
		  
		var _temp = _tpWin.officeObj[i]; 
		if(_temp.getAttribute("isDialog") ==false){
			continue;
		}
		isDialog = true;
		if(_temp && _temp.style){
		  _temp.style.visibility = 'visible';
		}
	  }
	}
	
	if(isChrome && isDialog){
	  window.setTimeout(showOfficeObjExt,1);
	}
}; 
/**
 * 显示office控件的扩展函数
 */
function showOfficeObjExt(){
	    var iframe = document.getElementById("docContent");
		var h;
		if(OfficeObjExt.firstHeight == null){
			h = iframe.style.height;
			OfficeObjExt.firstHeight = h;
		}else{
			h= OfficeObjExt.firstHeight; 
		}
		var height=h;
		if(h.indexOf("%")>0){
			height = h.substring(0,h.length-1);
			height = parseInt(height);
			height = height -2;
			iframe.style.height = height+"%";
		}else if(h.indexOf("px")>0){
			height = h.substring(0,h.length-2);
			height = parseInt(height);
			height = height -2;
			iframe.style.height = height+"px";
		}else{
			h= $(iframe).height();
			OfficeObjExt.firstHeight = h+"px"; 
			iframe.style.height = (h-2)+"px";
		}
		window.setTimeout(function(){
			iframe.style.height = h;
		}, 2);
	try{
		getCtpTop().OfficeObjExt._tempShowExt =  getCtpTop().OfficeObjExt.showExt;
		getCtpTop().OfficeObjExt.showExt = OfficeObjExt.showExt ; 
		window.onunload = function(){
			getCtpTop().OfficeObjExt.showExt =getCtpTop().OfficeObjExt._tempShowExt;
			getCtpTop().OfficeObjExt._tempShowExt = null; 
		}
	}catch(e){
		
	}
}

function fnFileUploadCallBack(){
  fnReSizeOfficeWindow();
}
/**
 * 界面样式适配方法
 */
function fnReSizeOfficeWindow(){
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
        fnReSizeOfficeWindow();
    });
    return;
}


function fnSelectChange(){
    var oParam={contentTypeId: $(this).val(),docResId:'${docId}',oldCTypeId:$('#oldCTypeId').val()};
    $("#fromAction").jsonSubmit({
        action: jsURL+'?method=changeContentType&isJsonSubmit=true',
        paramObj:oParam,
        callback: function(json) {
             $("#extendDiv").html(json);
        }
    });
}
/**
 * 保存按钮的事件
 * @returns
 */
function fnSave(){
	// 如果正文编辑器没加载完，提示等待
	if(!(document.getElementById("docContent") && document.getElementById("docContent").contentWindow && document.getElementById("docContent").contentWindow.saveContent
			&& (document.getElementById("docContent").contentWindow.CKEDITOR || document.getElementById("docContent").contentWindow.officeEditorFrame))) {
		$.alert($.i18n('doc.alert.content.loading'));
		return;
	}
	
	var btnSave = $("#hrefFnSaveId");
	var progressBar;
	try{
	    progressBar = $.progressBar();
	}catch(e){}
	
    var newName = $("#name").val().trim();
    if("${contentTypeFlag}" === "true") {
        contentTypeId = $("#contentTypeId").val();
    } else {
        contentTypeId = 21;
    }
    
    if (newName === defaultNameText
            || newName.length === 0) {
        cancelName();
    }
    
    if(!$("#name").validate()){
        try{
            if(progressBar) {
                progressBar.close();
            }
        }catch(e){}
        return;
    }
    
    if(newName != "${doc.frName}") {
        var hasSameName = cPageData.ajaxDocHierarchyManager.hasSameNameAndSameTypeDr("${parentDr.id}",'${docId}',newName,contentTypeId);
        if(hasSameName) {
            $.alert($.i18n('doc.alert.document.rename'));
            try{
                if(progressBar) {
                    progressBar.close();
                }
            }catch(e){}
            return;
        }
    }
    
    if(!checkForm(mainForm)) {
	    fnSetProperties();
	    try{
	        if(progressBar) {
                progressBar.close();
            }
	    }catch(e){}
	    return;
    }
    
    isFormSubmit = false;
    if(firstSave){
	    firstSave = false;
	    document.getElementById("docContent").contentWindow.saveContent("${docId}",newName,fnSaveCallback,fnFailedCallBack);
    }
}

function cancelName() {
    $("#name").val("");
}

/**
 * 保存成功的回调函数
 * @param param
 * @returns
 */
function fnSaveCallback(param) {
    var p = parent.frames["treeFrame"];
    var isNewView = p == undefined ? "false" : parent.frames["treeFrame"].document.getElementById("isNewView").value;
    if (isNewView == "true") {
        isNewView = 1;
    } else {
        isNewView = 0;
    }
    var sUrl = "${path}/doc.do?method=theNewAddVariousDocument&docId=${docId}&mimeTypeId=${mimeTypeId}&docLibId=${docLibId}&docLibType=${docLib.type}" +
        "&all=${v3x:escapeJavascript(param.all)}&edit=${v3x:escapeJavascript(param.edit)}&add=${v3x:escapeJavascript(param.add)}&readonly=${v3x:escapeJavascript(param.readonly)}&browse=${v3x:escapeJavascript(param.browse)}&list=${v3x:escapeJavascript(param.list)}&parentCommentEnabled=${v3x:escapeJavascript(param.parentCommentEnabled)}" +
        "&parentRecommendEnable=${v3x:escapeJavascript(param.parentRecommendEnable)}&frType=${v3x:escapeJavascript(param.frType)}&resId=${parentDr.id}&openFrom=${openFrom}" +
        "&parentVersionEnabled=${v3x:escapeJavascript(param.parentVersionEnabled)}&projectId=${param.projectId}&projectPhaseId=${param.projectPhaseId}&from=${param.from}&contentTypeId=" + contentTypeId + "&personalShare=${param.personalShare}";
    $("#dataSubmitDomain").jsonSubmit({
        action: sUrl + "&isNew=" + isNewView,
        domains: ["attachment1", "attachment2", "contentDiv", "extendDiv", "frName"],
        callback: function(oReturn) {
            getA8Top().window.close();
            if (v3x.getParentWindow() && v3x.getParentWindow().getA8Top()) {
                v3x.getParentWindow().getA8Top().fnRefresh();
            }
        }
    });
}

function fnFailedCallBack(param) {
  $.alert($.i18n('ocx.alert.savefail.label'));
  try{
      if(progressBar) {
          progressBar.close();
      }
  }catch(e){}
}
/**
 * 属性事件
 * @returns
 */
function fnSetProperties() {
	firstSave = true;
    editDocProperties('${doc.id}');
}