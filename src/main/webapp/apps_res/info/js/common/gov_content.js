
function dealPopupContentWinWhenDraft(contentNum) {
	//if(canUpdateContent){contentUpdate=true;}
	dealPopupContentWin(contentNum);
}

function dealPopupContentWin() {
	try{
		if(window.document.readyState!="complete") {return false;}
		//var bodyType = document.getElementById("bodyType").value;
		var bodyType = "HTML";
		if(bodyType=="HTML") {
			popupContentWin();
		} else if(bodyType=='Pdf') {
			popupContentWin();
		} else {
			/*var contentNum = document.getElementById("currContentNum").value;
			var forwordtosend=document.getElementById("forwordtosend").value;//办文转起草标识
			var newOfficeId=contentOfficeId.get(contentNum,null);
			if(newOfficeId && forwordtosend && (forwordtosend != '1')){
				if(newOfficeId!=getOfficeOcxCurVerRecordID()) {
					setOfficeOcxRecordID(newOfficeId);
					//为保证印章有效，控件FileName参数属性必须和改章的时候的参数一样，所以复制一份后要想保证原来印章有效，这个参数不能变化
					document.getElementById("contentNameId").value=contentOfficeId.get("0",null);
					contentUpdate=false;
				}
			}*/
			popupContentWin();
		}
	}catch(e){}
}

function updateInfoContent(needLock,isNew) {
	var contentDiv = getMainBodyDataDiv$();
	$("#viewState",contentDiv).val('1');
	$("#modifyFlag").val('1');
    popupContentWin(needLock,isNew);
}

/**
弹出正文窗口
**/
var contentDialog;
function popupContentWin(needLock,isNew) {
	//if(window.document.readyState!="complete") {return false;}
	if(!needLock && needLock!=false) {
		var lockWorkflowRe = lockWorkflow(summaryId, _currentUserId, 15);
	    if(lockWorkflowRe[0] == "false"){
	    	$.alert(lockWorkflowRe[1]);
	        return;
	    }
	}
	var bodyType = "HTML";
	var contentDiv = getMainBodyDataDiv$();
	var contentType = $("#contentType",contentDiv).val();
	var contentId = $("#id",contentDiv).val();
	var moduleId = $("#moduleId",contentDiv).val();
	var contentViewState = $("#viewState",contentDiv).val();
	var newBusiness = $("#newBusiness").val();
	var action = $("#action").val();
	//var templateView = document.getElementById("templateView").value;
	if(contentType == "10") {//HTML
		contentDialog = $.dialog({
			 targetWindow:getCtpTop(),
		     id: 'openContent',
		     url: _ctxPath + "/info/info.do?method=openContentDialog&contentViewState="+contentViewState+"&newBusiness="+newBusiness+"&action="+action+"&moduleId="+moduleId+"&contentType="+contentType+"&contentId="+contentId+"&summaryId="+$("#summaryId").val(),
		     width: screen.availWidth,
		     height: screen.availHeight,
		     transParams: window,
		     title: $.i18n('infosend.label.text')  //正文
		 });
		contentUpdate=true;
	} else {
		contentUpdate=true;
		fullSize(isNew);
	}
	//releaseWorkflowByAction(summaryId, _currentUserId, 15);
	/*if(bodyType=="HTML") {
		var isFromTemplete = false;
		for(var i = 0; i < arguments.length; i++) {
			var tempArg = arguments[i];
			if(tempArg == 'isFromTemplete'){
				isFromTemplete = true;
				break;
			}
		}
		var tempUrl=fullEditorURL;
		if(typeof(sendEdocId)!="undefined"){
			tempUrl=tempUrl + "&sendEdocId=" + sendEdocId  ;
		}
		if(isFromTemplete){
			//来自公文模板，不检查正文是否被并发修改；
			if(contentUpdate==false){tempUrl+="&canEdit=false";}
			else{tempUrl+="&canEdit=true";}
			tempUrl+="&isFromTemplete=true";
		} else{
			//非公文模板，检查正文是否被并发修改；
			if(contentUpdate==false || (checkConcurrentModifyForHtmlContent(summaryId) && (summaryId!=-1 && summaryId!=0))){tempUrl+="&canEdit=false";}
			else{tempUrl+="&canEdit=true";}
		}

		if(typeof(officecanPrint)!="undefined" && officecanPrint!=null) {
			tempUrl+="&canPrint="+officecanPrint;
		} else {
			tempUrl+="&canPrint=true";
		}
		var rv = v3x.openWindow({url: tempUrl,workSpace: 'yes'});
		if(document.getElementById("content")!=null && (typeof(oFCKeditor) != "undefined")) {
			if(rv==null){return;}
			oFCKeditor.SetContent(rv);
			oFCKeditor.remove();//提交的时候不在拷贝编辑区域到输入text;
			CKEDITOR.instances['content'].setData(rv);
		} else {
			if(rv==null){return;}
			if(typeof(htmlContentIframe) != "undefined")
				htmlContentIframe.document.getElementById("edoc-contentText").innerHTML=rv;
			else
				document.getElementById("edoc-contentText").innerHTML=rv;
		}
	}else if(bodyType=="Pdf"){
		pdfFullSize();
	}else{
		fullSize();
	}*/
}


function fillContent(content) {
	$.content.setContent(content);
	$("#contentDiv").contents().find("div.content_text").html(content);
}

function getParentContent() {
	return $.content.getContent();
}


function  isOffice(bodyType){
	if($.trim(bodyType) == ""){
		return false;
	}else if(parseInt(bodyType) >= 41 && parseInt(bodyType) <=45){
		return true;
	}else{
		return false;
	}
}
