var excludeElements_emcee;
var excludeElements_confereesSelect;
var excludeElements_recorder;
var excludeElements_approves;
var excludeElements_leaderSelect;
var excludeElements_impartSelect;//告知
var _timeLineCloseFlag = false;//时间线关闭页面标识

try {
	getA8Top().endProc();
} catch(e) {
}
//验证与会人，记录人，主持人是否重复
function setMtPeopleFields(elements,idElem,nameElem){
//	var elementsIds = getIdsString(elements,false);
//	支持按照部门，组发布会议
	if(idElem=="conferees" || idElem=="scopes" || idElem=="impart"){
		elementsIds = getIdsString(elements,true);
	}else{
		elementsIds = getIdsString(elements,false);
	}
	var emceeIds = document.getElementById('emceeId').value;

	var recorderIds = 0;
	if(document.getElementById('recorderId')){
		recorderIds = document.getElementById('recorderId').value;
	}
	var confereesIds = document.getElementById('conferees').value;
	var result = true;
	var confereesArray = confereesIds.split(",");
	if(elementsIds.trim()!='') {
		var elementsIdsArray = elementsIds.split(",");
		if(document.getElementById(idElem).name=="conferees"){//参会人员
			for(var i = 0 ; i<elementsIdsArray.length ; i++){
				if(elementsIdsArray[i]==emceeIds){
					alert(v3x.getMessage("meetingLang.emcee_conferee_repeat"));
					result = false;
				}else if(elementsIdsArray[i]==recorderIds){
					alert(v3x.getMessage("meetingLang.recorder_conferee_repeat"));
					result = false;
				}
			}
		}else if(document.getElementById(idElem).name=="scopes"){//实际参会人员
			if(elementsIdsArray[i]==emceeIds){
				alert(v3x.getMessage("meetingLang.emcee_scope_repeat"));
				result = false;
			}else if(elementsIdsArray[i]==recorderIds){
				alert(v3x.getMessage("meetingLang.recorder_scope_repeat"));
				result = false;
			}
		}else{
			for(var i = 0 ; i<confereesArray.length ; i++){
				//alert("与会人ID"+confereesArray[i]+"主持人"+emceeIds+"记录人"+recorderIds)
				if(confereesArray[i]==elementsIds){
					alert(v3x.getMessage("meetingLang.emcee_conferee_repeat"));
					result = false;
				}else if(confereesArray[i]==elementsIds){
					alert(v3x.getMessage("meetingLang.recorder_conferee_repeat"));
					result = false;
				}
			}
		}
		if(result){
			document.getElementById(idElem).value=elementsIds;
			document.getElementById(nameElem).value=getNamesString(elements);
		}
		if(idElem=="emceeId"){
			elements_emceeArr = elements;
		}else if(idElem=="conferees"){
			elements_confereesSelectArr = elements;
		}else if(idElem=="recorderId"){
			elements_recorderArr = elements;
		}else if(idElem=="scopes"){
			elements_scopesArr = elements;
		}else if(idElem=="leader"){
			elements_leaderSelectArr = elements;
		}else if (idElem == "impart"){
			elements_impartSelectArr = elements;
		}
	} else {
		document.getElementById(idElem).value=elementsIds;
		document.getElementById(nameElem).value=getNamesString(elements);
		elements_recorderArr = elements;
	}
	if(typeof(formChange) == 'function')
		formChange();
}

function Hashtable(){
    	this._hash = new Object();
   	 	this.add  = function(key,value){
                        if(typeof(key)!="undefined"){
                            if(this.contains(key)==false){
                                this._hash[key]=typeof(value)=="undefined"?null:value;
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            return false;
                        }
                    }
    	this.remove = function(key){delete this._hash[key];}
    	this.count = function(){var i=0;for(var k in this._hash){i++;} return i;}
    	this.items = function(key){return this._hash[key];}
    	this.contains = function(key){ return typeof(this._hash[key])!="undefined";}
    	this.clear = function(){for(var k in this._hash){delete this._hash[k];}}

}

var mtPigeonholeCallbackIds = "";
var mtPigeonholeCallbackListType = "";
var mtPigeonholeCallbackListMethod = "";
var mtPigeonholeCallbackMenuId = "";
function mtPigeonhole(appName, listType, listMethod, menuId) {
    mtPigeonholeCallbackIds = getSelectId(true);
    if (mtPigeonholeCallbackIds != "") {
        mtPigeonholeCallbackIds = mtPigeonholeCallbackIds.substring(0,
                mtPigeonholeCallbackIds.length - 1);
    }
    var idA = mtPigeonholeCallbackIds.split(',');
    var atts = getSelectAtts();
    if (atts != "") {
        atts = atts.substring(0, atts.length - 1);
    }
    var result = "";
    if (mtPigeonholeCallbackIds == '') {
        alert(v3x.getMessage("meetingLang.choose_item_from_list"));
        return;
    }
    // if(!confirm(v3x.getMessage("meetingLang.pigeonhole_validate"))) return;
    for (var i = 0; i < idA.length; i++) {
        // alert(userInternalID+"----------"+createUserIdTable.items(idA[i]));
        if (ht.items(idA[i]) == 0 || ht.items(idA[i]) == 10
                || ht.items(idA[i]) == 20) {
            alert(v3x.getMessage("meetingLang.meeting_no_pigeonhole"));
            return;
        } else if (ht.items(idA[i]) == -10) {
            alert(v3x
                    .getMessage("meetingLang.meeting_list_toolbar_not_cancel_pigeonhole"));
            return;
        } else if (userInternalID == createUserIdTable.items(idA[i])) {
            mtPigeonholeCallbackListType = listType;
            mtPigeonholeCallbackListMethod = listMethod;
            mtPigeonholeCallbackMenuId = menuId;
            result = pigeonhole(appName, mtPigeonholeCallbackIds, atts, "", "",
                    "mtPigeonholeCallback");
            return;
        } else {
            alert(v3x.getMessage("meetingLang.you_can_not_pigeonhole"));
            return;
        }
    }
}

/**
 * mtPigeonhole归档回调函数
 */
function mtPigeonholeCallback(result) {
    if (result == 'failure') {
        alert(v3x.getMessage("meetingLang.pigeonhole_failure"));
    } else if (result == 'cancel') {

    } else {
        parent.location.href = baseUrl + "pigeonhole" + '&id='
                + mtPigeonholeCallbackIds + "&folders=" + result + "&listType="
                + mtPigeonholeCallbackListType + "&listMethod="
                + mtPigeonholeCallbackListMethod + "&menuId="
                + mtPigeonholeCallbackMenuId;
    }
}

function displayMyDetail(id,proxy,proxyId, openType) {
	var openFromUC = parent.parent.openFromUC;
  if(openType==0) {
    parent.detailFrame.location.href = baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId+"&openFromUC="+openFromUC;
  } else {
     var rv = v3x.openWindow({
         url: baseUrl+'myDetailFrame&id='+id+'&proxy='+proxy+"&proxyId="+proxyId+"&openfrom=meetingsummary&openFromUC="+openFromUC,
         workSpace: 'yes',
         FullScrean: 'yes',
         dialogType : 'open'
     });
     if(rv != null) {
       if(rv[0] == 'summaryToCollOrEdoc'){
       	  parentObj = window.dialogArguments;
       	  if(parentObj == undefined){
                parentObj = parent.window.dialogArguments;
          }
          if(parentObj == undefined){
                parentObj = parent.parent.window.dialogArguments;
          }
       	  parentObj.getA8Top().main.location.href=rv[1];
       	  window.close();
       }else {
          window.location.reload();
       }
     }
  }
}



function showMtSummary(recordId, mId, openType , hiddenAuditOpinion, listType) {
	if(!openType || openType==0){
		parent.detailFrame.location.href = 'mtSummary.do?method=mydetail&recordId='+recordId+"&mId="+mId;
	}else{
		 var rv = v3x.openWindow({//xiangfan 添加openType参数 修复GOV-2376，//xiangfan 添加listType参数，主要为了修复GOV-2539.我的会议-查看会议纪要时，不应该能看到审核领导了
			 url: 'mtSummary.do?method=mydetail&recordId='+recordId+"&mId="+mId+"&hiddenAuditOpinion="+hiddenAuditOpinion+"&openType="+openType+"&listType="+listType,
		     workSpace: 'yes',
		     dialogType: v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
		});
	}
}

var notApprove = 0;
function displayMyDetailApp(id,proxy,proxyId,openType){
	if(notApprove == 2){
		if(!openType || openType==0){

			parent.detailFrame.location.href = baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId+"&notApprove=2";
		}else{
			 var rv = v3x.openWindow({
			     url: baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId+"&notApprove=2",
			     FullScrean: 'yes',
			     dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1"
			});
		}
	}
	else{
		var   w=screen.availWidth-10;
		var   h=screen.availHeight-80;
		if(!openType || openType==0){
			parent.detailFrame.location.href = baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId;
		}else{
			// var rv = v3x.openWindow({
			//     url: baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId,
			//     workSpace: 'yes',
			//     dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1"
			//});
			//xiangfan 修改成window.open方式，修复 无法复制内容的问题GOV-2047
			//window.open(baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId, "" , "fullscreen=0,width="+w+",height="+h);
			//xiangfan 添加 2012-04-11
			var rv = v3x.openWindow({
			     url: baseUrl+'mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId,
			     FullScrean: 'yes',
			     dialogType : 'open'
			});
			if (rv == "true") {//xiangfan 修改，处理页面后关闭并刷新父页面
				if(getA8Top().document.contentFrame!=null && getA8Top().document.contentFrame.mainFrame!=null){
        			getA8Top().document.contentFrame.mainFrame.location.href.reload();
				}else {
					getA8Top().reFlesh();
				}
			}
		}
	}

}

function selectMtPeople(elemId,idElem){
	
	
	var arr = new Array();
	try {
		if ($("#impart").val() == ""){
			elements_impartSelectArr = "";
		}
		if ($("#leader").val() == "") {
			elements_leaderSelectArr = "";
		}
	}catch(e){}
	if(elemId == 'confereesSelect'){
		excludeElements_confereesSelect = new Array();
		try{
			elements_leaderSelectArr;
		}catch(e){
			elements_leaderSelectArr = new Array();
		}
		if(elements_emceeArr){
			arr = arr.concat(elements_emceeArr);
		}
		if(elements_recorderArr){
			arr = arr.concat(elements_recorderArr);
		}
		if(elements_leaderSelectArr){
			arr = arr.concat(elements_leaderSelectArr);
		}
		if(elements_impartSelectArr) {
				arr = arr.concat(elements_impartSelectArr);
		}
		excludeElements_confereesSelect = arr;
	}else if(elemId == 'scopes'){
		excludeElements_scopes = new Array();
		if(elements_emceeArr&&elements_recorderArr){
			arr = excludeElements_scopes.concat(elements_emceeArr,elements_recorderArr);
		}else if(elements_emceeArr){
			arr = excludeElements_scopes.concat(elements_emceeArr);
		}else if(elements_recorderArr){
			arr = excludeElements_scopes.concat(elements_recorderArr);
		}
		if (elements_impartSelectArr) {
			arr = arr.concat(elements_impartSelectArr);
		}
		excludeElements_scopes = arr;
	}else if(elemId == 'emcee'){
		excludeElements_emcee = new Array();
		try{
			elements_leaderSelectArr
		}catch(e){
			elements_leaderSelectArr = new Array();
		}

		if(elements_leaderSelectArr){
			arr = arr.concat(elements_leaderSelectArr);
		}
		if(elements_confereesSelectArr){
			arr = arr.concat(elements_confereesSelectArr);
		}
		if (elements_impartSelectArr) {
			arr = arr.concat(elements_impartSelectArr);
		}
		excludeElements_emcee = arr;
	}else if(elemId == 'recorder'){
		excludeElements_recorder = new Array();
		try{
			elements_leaderSelectArr
		}catch(e){
			elements_leaderSelectArr = new Array();
		}

		if(elements_leaderSelectArr){
			arr = arr.concat(elements_leaderSelectArr);
		}
		if(elements_confereesSelectArr){
			arr = arr.concat(elements_confereesSelectArr);
		}
		if (elements_impartSelectArr) {
			arr = arr.concat(elements_impartSelectArr);
		}
		excludeElements_recorder = arr;
	}else if(elemId == 'approves'){
		excludeElements_approves = new Array();
		if(elements_emceeArr&&elements_recorderArr){
			arr = excludeElements_approves.concat(elements_emceeArr,elements_recorderArr);
		}else if(elements_emceeArr){
			arr = excludeElements_approves.concat(elements_emceeArr);
		}else if(elements_recorderArr){
			arr = excludeElements_approves.concat(elements_recorderArr);
		}
		if (elements_impartSelectArr) {
			arr = arr.concat(elements_impartSelectArr);
		}
		excludeElements_confereesSelect = arr;
	}else if(elemId == 'leaderSelect'){
		excludeElements_leaderSelect = new Array();
		if(elements_emceeArr){
			arr = arr.concat(elements_emceeArr);
		}
		if(elements_recorderArr){
			arr = arr.concat(elements_recorderArr);
		}
		if(elements_confereesSelectArr){
			arr = arr.concat(elements_confereesSelectArr);
		}
		if (elements_impartSelectArr) {
			arr = arr.concat(elements_impartSelectArr);
		}
		excludeElements_leaderSelect = arr;
	} else if (elemId == 'impartSelect') {  //告知
		try{
			elements_leaderSelectArr;
		}catch(e){
			elements_leaderSelectArr = new Array();
		}
		if(elements_leaderSelectArr){
			arr = arr.concat(elements_leaderSelectArr);
		}
		excludeElements_impart = new Array();
		if(elements_emceeArr){
			arr = arr.concat(elements_emceeArr);
		}
		if (elements_createUserSelectArr) {
			arr = arr.concat(elements_createUserSelectArr);
		}
		if(elements_recorderArr){
			arr = arr.concat(elements_recorderArr);
		}
		if(elements_confereesSelectArr){
			arr = arr.concat(elements_confereesSelectArr);
		}
		excludeElements_impartSelect = arr;
	}
	eval('selectPeopleFun_'+elemId+'()');
}

function deleteMtRecord(baseUrl, flag){
		var ids=document.getElementsByName('id');
		var id='';
		var isCan = false;
		var num = 0;
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				//只有创建者可以删除会议
				/*if(userInternalID!=createUserIdTable.items(idCheckBox.value)){
					alert(v3x.getMessage("meetingLang.you_not_creater"));
					return;
				}*/
				if((idCheckBox.getAttribute("state")==10 || idCheckBox.getAttribute("state")==20) && flag!='cancel') {//未结束
					alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_4"));
					return;
				}
				if(idCheckBox.getAttribute("state")!=10  && flag=='cancel') {//已召开
					alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_2"));
					return;
				}
				if(idCheckBox.getAttribute("recordState")==1 && idCheckBox.getAttribute("state")==20) {//已做会议纪要
					alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_5"));//alert("该会议已做过会议纪要，不允许撤销。");
					return;
				}
				if(idCheckBox.getAttribute("state")==-10 && flag=='cancel') {//已归档
					alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_3"));
					return;
				}
				id=id+idCheckBox.value+',';
				num++;
			}
		}
		if(id==''){
			if(flag=='cancel') {
				alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			} else {
				alert(v3x.getMessage("meetingLang.choose_item_to_delete"));
			}
			return;
		}
		if(flag=='cancel' && num > 1){
			alert(v3x.getMessage("meetingLang.not_choose_more_item_from_list"));
			return;
		}

		var confirmMsg = v3x.getMessage("meetingLang.sure_to_delete");
		if(flag=='cancel') {
			confirmMsg = v3x.getMessage("meetingLang.sure_to_cancel_sent_meetings");
		}
		if(confirm(confirmMsg)) {
			if(this.name=='listFrame') {
				window.location.href=baseUrl+'&id='+id+'&flag='+flag;
			} else {
				parent.window.location.href=baseUrl+'&id='+id+'&flag='+flag;
			}
		}
}

function editMtTemplate(ajaxMethod, listType){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}
		if(validateCheckbox("id")>1){
			alert(v3x.getMessage("meetingLang.meeting_list_toolbar_only_choose_one_toEdit"));
			return;
		}

		if(userInternalID!=createUserIdTable.items(id)){
			alert(v3x.getMessage("meetingLang.you_not_creater"));
			return;
		}

		//状态判断:只有模板、暂存待发及已发起未召开的会议可以编辑
		if(!ajaxMethod) {
			ajaxMethod = "ajaxMtMeetingManager";
		}
		if(!validateCanEdit(id, ajaxMethod)) {
			alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
			//parent.getA8Top().reFlesh();
			return;
		}
		if(this.name=='listFrame') {
				//这里传参数加上了location=mymeeting，主要为了解决从我发布的会议列表中选择会议进行编辑的时候，导航栏显示的还是我发布的会议
				location.href=baseUrl+"edit"+'&id='+id+'&flag=editMeeting&location=mymeeting&listType='+listType;
		} else {
				parent.location.href=baseUrl+"edit"+'&id='+id+'&flag=editMeeting&listType='+listType;
		}
}
/**
 * 校验当前会议是否允许进行修改
 */
function validateCanEdit(meetingId, ajaxMethod) {
	if(!ajaxMethod) {
		//ajaxMethod = "ajaxMtAppMeetingManager";
		ajaxMethod = "mtAppMeetingManager";
	}
	var requestCaller = new XMLHttpRequestCaller(this, ajaxMethod, "canEditMeeting", false);
	requestCaller.addParameter(1, "Long", meetingId);
	var result4Edit = requestCaller.serviceRequest();
	return result4Edit=='true' || result4Edit==true;
}
//关联文档
function quoteDocument() {
	 if(getA8Top().isCtpTop || getA8Top()._ctxPath){
        getA8Top().addassDialog = getA8Top().$.dialog({
       		title:v3x.getMessage("V3XLang.assdoc_title"),
	        transParams:{'parentWin':window},
	        url: v3x.baseURL + '/ctp/common/associateddoc/assdocFrame.do?isBind=1,3',
	        targetWindow:getA8Top(),
	        width:"800",
	        height:"500"
        });
        
    }else{
	    getA8Top().addassDialog = getA8Top().v3x.openDialog({
	        title:v3x.getMessage("V3XLang.assdoc_title"),
	        transParams:{'parentWin':window},
	        url: v3x.baseURL + '/ctp/common/associateddoc/assdocFrame.do?isBind=1,3',
	        targetWindow:getA8Top(),
	        width:"800",
	        height:"500"
	    });
    }

}

/**
 * 插入关联文档窗口回调函数
 */
function quoteDocumentCallback(atts) {
    if (atts) {
        deleteAllAttachment(2);
        for (var i = 0; i < atts.length; i++) {
            var att = atts[i]
            addAttachment(att.type, att.filename, att.mimeType, att.createDate, att.size, att.fileUrl, true, false, att.description, null, att.mimeType + ".gif", att.reference, att.category)
        }
    }
}


function openDetail(subject, _url) {
    _url = colURL + "?method=summary&" + _url;
    var rv = v3x.openWindow({
        url: _url,
        workSpace: 'yes',
        dialogType: "open"
    });

}
/**
 * 显示某种特定状态的会议，区分未召开、暂存待发和已召开（包含已结束、已总结）三种状态
 */
function showCertainStateMeetings(state) {
	parent.location.href='mtMeeting.do?method=listMain&stateStr=' + state;
	setMenuState(state);
}
/**
 * 高亮显示当前选中会议状态所对应的菜单按钮
 */
function setMenuState(stateStr) {
	document.getElementById('sentButNotConvoked').className="webfx-menu--button";
	document.getElementById('toSend').className="webfx-menu--button";
	document.getElementById('convoked').className="webfx-menu--button";
	var state = stateStr=='' ? 10 : parseInt(stateStr);
	var menuId;
	switch(state) {
		case 0:
		menuId = "toSend";
		disableButton('pigeonholeBtn');
		break;
		case 10:
		menuId = "sentButNotConvoked";
		disableButton('pigeonholeBtn');
		break;
		case 20:
		case 30:
		case 40:
		menuId = "convoked";
		break;
	}
	var menuDiv = document.getElementById(menuId);
	if(menuDiv!=null) {
	    menuDiv.className = 'webfx-menu--button-sel';
	    menuDiv.firstChild.className="webfx-menu--button-content-sel";
	    menuDiv.onmouseover = '';
	    menuDiv.onmouseout = '';
	}
}
/**
 * 查看会议记录时，如果被删除或不可访问，给出提示信息并关闭页面或刷新列表页面
 */
function refreshIfInvalid() {
	alert(v3x.getMessage("meetingLang.the_meeting_has_been_canceled"));
	if(window.dialogArguments) {
		try {
			window.dialogArguments.getA8Top().reFlesh();
		} catch(e) {}
		window.close();
	} else {
		try {
			parent.getA8Top().reFlesh();
		} catch(e) {}
	}
}
/**
 * 保存会议模板成功之后，将按钮置为可用，并给出保存成功的提示信息
 */
function enableBtnAndPrintMsg() {
	enableButton('save');
	enableButton('send');
	enableButton('saveAs');
	alert(v3x.getMessage("meetingLang.save_meeting_template_success"));
}

//回执会议：Controller执行完毕后关闭窗口或刷新界面
function closeMtWindow(oper){
	/** xiangfan 添加 2012-04-11 start 会议管理-会议审核 打开单条信息审核，点击'确定'后关闭页面 并刷新父页面 */
	if(oper == "saveMtAppReply" || oper == "MtSummaryAudit"){
		if(window.opener){
			window.opener.location.reload();
			window.close();
			return;
		}
		if (window.dialogArguments) {
	  	    window.returnValue = "true";
	  	    getA8Top().close();
	    }
	}

	var parentWindow = window.dialogArguments;
	var isModel = true;
	if(parentWindow == undefined) {
		parentWindow = parent.window.dialogArguments;
		isModel = false;
		if(this.name=='mtFrame') {
			isModel = true;
		}
	}
	if(parentWindow == undefined) {
		parentWindow = parent.parent.window.dialogArguments;
		isModel = false;
	}
	
	/** xiangfan 添加 2012-04-11 end */
	//这里应该不会再执行了
	if(parentWindow) {
		//从时间线/时间视图中打开的待办页面，处理后  ->showTimeLineData.js方法openEdocByStatus
	   if(parentWindow.diaClose!=null && typeof(parentWindow.diaClose)=='function') {
		   try {
			   parentWindow.diaClose();
		   } catch(e) {}
		   if(parentWindow.window && parentWindow.window.dialogDealColl) {
			   parentWindow.window.dialogDealColl.close();
		   }
		   _timeLineCloseFlag = true;

	   } else {
		   	if(parentWindow.callbackOfPendingSection != null && parentWindow.callbackOfPendingSection) {
		   		parentWindow.callbackOfPendingSection();
		   	} else if(parentWindow.callback != null && parentWindow.callback) {
				parentWindow.callback();
			} else if(isModel){
			   window.returnValue = "true";
			   getA8Top().close();
			} else{//从绩效列表打开会议进行回执
				var listReportFrame = parent.listFrame;
				if(listReportFrame){
					listReportFrame.location.reload();
				}
			}
		}
	} else {
	    
	    //一步一步改，这里是时间线
	    var a8TopWin = getA8Top();
	    if(a8TopWin.dialogDealColl) {
           try {
               a8TopWin.diaClose();
           } catch(e) {}
           
           a8TopWin.dialogDealColl.close();
           _timeLineCloseFlag = true;
           
       }else if(parent.parent.parent.fromPage == "isearch"){//这里是全文检索，综合查询回执
           
           if(a8TopWin._dialog){
               a8TopWin._dialog.close(); 
           }else{
               alert("没有找到弹出窗口对象，请手动关闭窗口");
           }
           
           _timeLineCloseFlag = true;
           
       }else{
           
           var parentListFrame = parent.listFrame;
           if(parentListFrame == undefined) {
               parentListFrame = parent.parent.listFrame;
           }
           if(parentListFrame) {
               parentListFrame.location.reload();
           } else {
               if(getA8Top().window.dialogArguments){
                   getA8Top().close();
               } else if(getA8Top().window.opener){
                   getA8Top().close();
               }
           }
       }
	}
	//刷新我的提醒栏目
	try{
		var _win = window.top.opener.$("#main")[0].contentWindow;
    	if (_win != undefined && _win.location.href.indexOf("plan.do?method=forwordCol") == -1) {
    		_win.sectionHandler.reload("collaborationRemindSection",true);
    	}
	}catch(e){
	}
	
}


//点击页签事件（即使选中状态下也可以跳转）
function meeting_changeMenuTab(clickDiv)
{
  var menuDiv=document.getElementById("menuTabDiv");
  var clickDivStyle=clickDiv.className;
  //if(clickDivStyle=="tab-tag-middel-sel"){return;}
  var divs=menuDiv.getElementsByTagName("div");
  var i;
  for(i=0;i<divs.length;i++)
  {
  	clickDivStyle=divs[i].className;
  	if(clickDivStyle.substr(clickDivStyle.length-4)=="-sel")
  	{
  		divs[i].className=clickDivStyle.substr(0,clickDivStyle.length-4);
  	}
  }
  for(i=0;i<divs.length;i++)
  {
        if(clickDiv==divs[i])
  	    {
  	      divs[i-1].className=divs[i-1].className+"-sel";
  	      divs[i].className=divs[i].className+"-sel";
  	      divs[i+1].className=divs[i+1].className+"-sel";
  	    }
  }
  var detailIframe=document.getElementById('mainIframe').contentWindow;
  detailIframe.location.href=clickDiv.getAttribute('url');
}

//会议审核后删除操作
function deleteMtPerm(){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.value+',';
		}
	}
	if(id==''){
		alert(v3x.getMessage("meetingLang.choose_item_to_delete"));
		return;
	}

	var confirmMsg = v3x.getMessage("meetingLang.sure_to_delete");

	if(confirm(confirmMsg)) {
    	var myform = document.getElementsByName("myform")[0];
    	myform.action =  "mtAppMeetingController.do?method=deleteAppPerm";
    	myform.method =  "post";
    	myform.submit();

	}
}

function getSelectId(flag){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			if(flag==true) {
				id=id+idCheckBox.value+',';
			} else {
				id=idCheckBox.value;
				break;
			}
		}
	}
	return id;
}

function getSelectPeriodicityInfoId(){
	var ids=document.getElementsByName('id');
	var pid='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			pid = idCheckBox.getAttribute("periodicityInfoId");
			break;
		}
	}
	return pid;
}


function getSelectAtts(){
	var ids=document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=id+idCheckBox.getAttribute('attFlag')+',';
		}
	}
	return id;
}

/** xiangfan 添加打印功能 修复GOV-2051 2012-04-23 */
function Print(type){
	try {
		var printSubject = v3x.getMessage("meetingLangg.meeting_name");//"会议名称";
		var printsub = document.getElementById("printsubject").innerHTML;
		printsub = "<center><span style='font-size:24px;line-height:24px;'>"+printsub+"</span></center>";
		//标题文字样式与查时不一样.
		var printSubFrag = new PrintFragment(printSubject, printsub);
	} catch (e) {
	}
	try {
		var printTimeInfo = v3x.getMessage("meetingLang.meeting_time");//"会议时间";
		var printTime = document.getElementById("printTimeInfo").innerHTML;
		printTime = "<center><span style='font-size:12px;line-height:16px;'>" + printTimeInfo + "：" + printTime + "</span></center>";
		var printTimeFrag = new PrintFragment(printTimeInfo, printTime);
	} catch (e) {
	}
	try {
		var printSenderInfo = v3x.getMessage("meetingLang.meeting_creater");//"发起人";
		var printSender = document.getElementById("printSenderInfo").innerHTML;
		printSender = "<center><span style='font-size:12px;line-height:16px;'>" + printSenderInfo + "：" + printSender + "</span></center>";
		var printSenderFrag = new PrintFragment(printSenderInfo, printSender);
	} catch (e) {
	}
	if(type == "mtSummary"){
		try {
			var printAuditerInfo = v3x.getMessage("meetingLang.meeting_audit_leadership");//"审核领导";
			var printAuditer = document.getElementById("printAuditerInfo").innerHTML;
			printAuditer = "<center><span style='font-size:12px;line-height:16px;'>" + printAuditerInfo + "：" + printAuditer + "</span></center>";
			var printAuditerFrag = new PrintFragment(printAuditerInfo, printAuditer);
		} catch (e) {
		}
	}
	try {
		var printAddressInfo = v3x.getMessage("meetingLang.meeting_address");//"会议地址";
		var printAddress = document.getElementById("printAddressInfo").innerHTML;
		if(printAddress == "" || printAddress == null){
			printAddress = v3x.getMessage("meetingLang.meeting_no");//"无";
		}
		printAddress = "<center><span style='font-size:12px;line-height:16px;'>" + printAddressInfo + "：" + printAddress + "</span></center>";
		var printAddressFrag = new PrintFragment(printAddressInfo, printAddress);
	} catch (e) {
	}
	try {
		var printColBody= "";
		var colcontext     =	parent.detailMainFrame.contentIframe.document.getElementById("col-contentText");
		var colBody;
		if(colcontext != null){
			//这两行代码是用来ISIgnatureHTML签章定位的
			colBody='<input id="inputPosition" type="text" style="border:0px;width:1px;height:0.01px" onfocus="javascript:return false;" onclick="return false;"/>\r\n';
			colBody+='<div id="iSignatureHtmlDiv" name="iSignatureHtmlDiv"  width=\'1px\' height=\'1px\'></div>';
			//---

			colBody+= "<div class='contentText' style='margin:0 10px;width:100%'>"+colcontext.innerHTML+"</div>";
		}else{
			colBody="";
		}
		var colBodyFrag = new PrintFragment(printColBody, colBody);
	} catch (e) {
	}

//	try {
//		//var printColOpinion = _("collaborationLang.print_senderNote");
//		//var colOpinion = document.getElementById("senderOpinion").innerHTML;
//		//colOpinion = cleanSpecial(colOpinion);
//		//var sendOpinionFrag = new PrintFragment(printColOpinion, colOpinion);
//	} catch (e) {
//	}
//
//	try {
		//var printColOpinion = _("collaborationLang.print_opinion");
//		var printColOpinion = "处理人意见";
		//隐藏回复框
//		var oReplyTable = document.getElementById('reply-table');
//		if(oReplyTable!=null){
//			oReplyTable.style.display="none";
//		}
		//var colOpinion = "<br>"+document.getElementById("colOpinion").innerHTML;
//		var colOpinion = "<br>" + parent.detailMainFrame.contentIframe.document.getElementsByTagName("table")[1].innerHTML
//		colOpinion = cleanSpecial(colOpinion);
//		var colOpinionFrag = new PrintFragment(printColOpinion, colOpinion);
//	} catch (e) {
//	}
//
//	var isForward = false;
//	try {
//		var forwardOriginalOpinion = document.getElementById("forwardOriginalOpinion");
//		// 对原意见隐藏后不打印
//		if (forwardOriginalOpinion.style.display!="none") {
//			var printForwardOriginalOpinion = _("collaborationLang.print_forwardOpinion");
//			var forwardContext = document.getElementById("forwardOriginalOpinion");
//
//			var forwardOriginalOpinion;
//			if(forwardContext != null){
//				isForward = true;
//				forwardOriginalOpinion= "<br>" + forwardContext.innerHTML;
//			}else{
//				forwardOriginalOpinion="";
//			}
//			forwardOriginalOpinion = cleanSpecial(forwardOriginalOpinion);
//			var forwardOriginalOpinionFrag = new PrintFragment(printForwardOriginalOpinion, forwardOriginalOpinion);
//		}
//	} catch (e) {
//	}
//
//    try {
//		var printColMydocument =  _("collaborationLang.print_mydocument");
//                var att2Number = parent.document.getElementById("attachment2NumberDiv").innerHTML;
//                var colMydocument = "";
//                if(att2Number!=0){
//                    colMydocument = "<div class='div-float body-detail-su'>"+_("collaborationLang.print_mydocument")+" : ("+att2Number+")</div><br>"+getSenderAttachmentName(summary_id,2);
//                    colMydocument=colMydocument+"<br>";
//                    colMydocument = cleanSpecial(colMydocument);
//                }
//		var colAttachment2Frag = new PrintFragment(printColMydocument, colMydocument);
//	} catch (e) {
//	}
//        try {
//		var printAttachment =  _("collaborationLang.print_attachment");
//		var attNumber =parent.document.getElementById("attachmentNumberDiv").innerHTML;
//                var colAttachment = "";
//                if(attNumber!=0){
//                    colAttachment ="<table><tr><td valign='top'><div class='div-float' style='color: #335186; font-weight: bolder; font-size: 12px;'>"+ _("collaborationLang.print_attachment")+" : ("+attNumber+")</div></td><td valign='top'>"+getSenderAttachmentName(summary_id,0) + "</td></tr></table>";
//                    colAttachment="<br>"+colAttachment+"<br>";
//                    colAttachment = cleanSpecial(colAttachment);
//                }
//		var colAttachment1Frag = new PrintFragment(printAttachment, colAttachment);
//	} catch (e) {
//	}
	var cssList = new ArrayList();
	//cssList.add(v3x.baseURL + "/apps_res/collaboration/css/collaboration.css")
	//cssList.add(v3x.baseURL + "/apps_res/meeting/css/meeting.css")
	//cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea5Show.css")
	//cssList.add(v3x.baseURL + "/apps_res/form/css/SeeyonForm.css")
	var pl = new ArrayList();
	pl.add(printSubFrag);
	pl.add(printSenderFrag);
	pl.add(printTimeFrag);
	if(type == "mtSummary"){
		pl.add(printAuditerFrag);
	}
	pl.add(printAddressFrag);
	pl.add(colBodyFrag);
	//pl.add(colAttachment2Frag);
	//pl.add(colAttachment1Frag);
	//if(isForward){pl.add(forwardOriginalOpinionFrag);}
	//pl.add(sendOpinionFrag);
//	pl.add(colOpinionFrag);

	printList(pl,cssList);
}
function _officePrint(){
	if(v3x.isFirefox){
		var frame = window.contentIframe.document.all("officeEditorFrame").contentWindow;
	}else{
		var frame = window.contentIframe.document.officeEditorFrame;
	}
	if(frame.officePrint && (frame.document.getElementById("WebOffice")!=null)){
		//调用office.js中的printOffice
		window.contentIframe.officePrint();
	}else{
		setTimeout('_officePrint()',15);
	}
}
/** xiangfan 添加打印功能样式调整 修复GOV-3767 2012-06-8 */
function printResult(type, isHtmldataFormat){/* isHtmldataFormat:true,表示正文是HTML格式，反之则是Excel或World格式 */
	/**xiangfan 添加，修复world和Excel正文打印错误，GOV-4062*/
   var officefra = window.contentIframe.document.all("officeEditorFrame");
   if(officefra != null && isHtmldataFormat != "true"){
       //officefra.officePrint();
       if(officefra.contentWindow.document.getElementById("WebOffice") != null){
           
           _officePrint();
           
       }else if(window.contentIframe.loadOfficeControll){
           window.contentIframe.loadOfficeControll();
           //将officeFrameDiv外层的table设置为隐藏
           window.contentIframe.document.all("officeFrameDiv").parentElement.parentElement.parentElement.parentElement.setAttribute("style","width:0px;height:0px;overflow:hidden; position: absolute;");
           _officePrint();
       }
   }else {
	   var printDiv = document.getElementById("print");
	   var videoButtonObj = document.getElementById("joinBtn");
	   printDiv.style.visibility="hidden";
	   if(videoButtonObj) videoButtonObj.style.display="none";
	   //var tr1 = document.getElementById("tr1");
	   //tr1.style.visibility="hidden";
	   //var timeLabelCopyObj = document.getElementById("timeLabelCopy");
	   //var printTimeInfoCopyObj = document.getElementById("printTimeInfoCopy");
	   //timeLabelCopyObj.style.display = "";
	   //printTimeInfoCopyObj.style.display = "";
	   try {
			var printSubject = "";
			var printsub = document.getElementById("printsubject").innerHTML;
			var partten = /bodyType_videoConf inline-block/g
			printsub = printsub.replace(partten, "");
			printsub = "<center><span style='font-size:20px;line-height:24px;'>"+printsub+"</span></center>";
			var printSubFrag = new PrintFragment(printSubject, printsub);
		} catch (e) {
		}
	   try {
			var printColBody= "";
			var colcontext     =	window.contentIframe.document.getElementById("col-contentText");
			var colBody;
			if(colcontext != null){
				var str = colcontext.innerHTML;
				var pObj = /<p>/g
				str = str.replace(pObj, "<p style='font-size: 16px;'>");
				colBody='<input id="inputPosition" type="text" style="border:0px;width:1px;height:0.01px" onfocus="javascript:return false;" onclick="return false;"/>\r\n';
				colBody+='<div id="iSignatureHtmlDiv" name="iSignatureHtmlDiv"  width=\'1px\' height=\'1px\'></div>';
				colBody+= "<div class='contentText' style='margin:0 10px;width:100%;font-size:16px'>"+str+"</div>";
			}else{
				colBody="";
			}
			var colBodyFrag = new PrintFragment(printColBody, colBody);
		} catch (e) {
		}
	   var p = document.getElementById("paddId");
	   var result = p.innerHTML;
	   //去掉附件区滚动条
	   result = result.replace(/attachment-all-80/g,"");

	   //去掉附件的下载连接
	   var clickRegExp = /<a([\s\S]*?)onclick[\s\S]*?=[\s\S]*?".*?"([\s\S]*?)>/ig;
	   result = result.replace(clickRegExp, "<a$1 $2>");
	   var hrefRegExp = /<a([\s\S]*?)href[\s\S]*?=[\s\S]*?".*?"([\s\S]*?)>/ig;
	   result = result.replace(hrefRegExp, "<a$1href=\"#\"$3>");

	   var re = /bodyType_videoConf inline-block/g;
	   result = result.replace(re, "");
	   var re = /detail-subject/g;
     result = result.replace(re, "");
	   var re = /bg-gray/g;
//	   result = result.replace(re, "bg-gray detail-subject");
	   //bg-gray detail-subject  这个样式有点问题，导致不能对齐表格
	   result = result.replace(re, "");
	   var mm = "<div style='width: 100%;height:auto !important;min-height:10px;'>"+result+"</div>";
	   var list1 = new PrintFragment("",mm);
	   var tlist = new ArrayList();
	   tlist.add(printSubFrag);
	   tlist.add(list1);
	   tlist.add(colBodyFrag);
	   var cssList=new ArrayList();
	   cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea4Show.css");
	   printList(tlist,cssList);
	   printDiv.style.visibility="";
	   if(videoButtonObj) videoButtonObj.style.display="";
	   //tr1.style.visibility="";
	   //timeLabelCopyObj.style.display = "none";
	   //printTimeInfoCopyObj.style.display = "none";
   }
}

//加载office相关组件
function _loadOfficeControll(){
	var frame;
	if(v3x.isFirefox){
		frame = window.contentIframe.document.all("officeEditorFrame").contentWindow;
	}else{
		frame = window.contentIframe.document.officeEditorFrame;
	}
	if((frame.document.getElementById("WebOffice")!=null) && frame){
		popupContentWin();
		return ;
	}
	if(window.contentIframe.loadOfficeControll){
	    window.contentIframe.loadOfficeControll();
	    //将officeFrameDiv外层的table设置为隐藏
        window.contentIframe.document.all("officeFrameDiv").parentElement.parentElement.parentElement.parentElement.setAttribute("style","width:0px;height:0px;overflow:hidden; position: absolute;");
	    popupContentWin();
	}
}

//调用office，先调用_loadOfficeControll 加载office相关
function popupContentWin(){
	var frame;
	if(v3x.isFirefox){
		frame = window.contentIframe.document.all("officeEditorFrame").contentWindow;
	}else{
		frame = window.contentIframe.document.officeEditorFrame;
	}
	if(frame.FullSize && (frame.document.getElementById("WebOffice")!=null)){
		frame.FullSize();
	}else{//如果组件还没加载完，多次调用
		setTimeout('popupContentWin()',15);
	}
}

//基础数据添加onUnload事件
function UnLoad_detailFrameDown() {
	if(parent.detailFrame!=null){
		parent.detailFrame.location.href = 'common/detail.jsp?direction=Down';
	}
}
/**
 * 会议震荡回复 --xiangfan
 */
var currentOpinionId = "";

function hiddenReplyDiv(){
  var obj_ = document.getElementById("replyDiv_" + currentOpinionId);
  if(obj_){
    obj_.innerHTML = "";
    obj_.style.display = "none";
    currentOpinionId = "";
  }
  //fileUploadAttachments.clear();
}

function opinion_reply(opinionId){
   if(currentOpinionId != null && currentOpinionId != "" && opinionId != currentOpinionId){
     return ;
   }
   var replyDiv = document.getElementById("replyDiv_" + opinionId);
   if(replyDiv && replyDiv.innerHTML != ""){
     return;
   }
   if(replyDiv){
     replyDiv.innerHTML = document.getElementById("replyCommentHTML").innerHTML;
     replyDiv.style.display = "";
     var replyObj = document.getElementById("reply-table");
     if(replyObj!=null){
       replyObj.style.display='';//打印的时候将这里设置为不可见了。
     }
     var theForm = document.getElementsByName("repform")[0];
     var replySpan = document.getElementById("replySpan" + opinionId);
     if(replySpan){
       var messageReceiver = theForm.messageReceiver;
       if(messageReceiver){
         messageReceiver.value = replySpan.getAttribute("replyUserId");
       }
       var messageReceiverName = theForm.messageReceiverName;
       if(messageReceiverName){
         messageReceiverName.value = replySpan.innerText;
       }
     }
     //theForm.isHidden.id = "isHidden";
     //try{
     //  theForm.isSendMessage.id = "isSendMessage";
     //}
     //catch(e){
     //}
     //if(isHidden){
     //   document.getElementById("isHiddenDiv").style.display = "none";
     //}
     //焦点下移显示出回复按钮
     if(theForm.b11) {
       theForm.b11.focus();
     }
     theForm.content.focus();
     theForm.replyId.value = opinionId;
     //if(writeMemberId){
     //  theForm.memberId.value = writeMemberId;
     //}
   }
   currentOpinionId = opinionId;
 }
function doReplay(f){
  if(checkReplyForm(f) && saveAttachment()){
    if(document.getElementById("replyDiv_" + currentOpinionId)){
      document.getElementById("replyDiv_" + currentOpinionId).style.display = 'none';
    }
    f.b11.disabled = true;
    f.b12.disabled = true;

    return true;
  }
  else{
    return false;
  }
}
function MtReplyCommentOK(ReplyData,proxy){
  var theForm = document.getElementsByName("repform")[0];
  var str = "";
  var proxystr = v3x.getMessage("meetingLang.meeting_proxy_reply",currentUserName);
  if(proxy && proxy != ""){
  	proxy = proxy.split("|");
  	str += '<div class="reply_message_con"><div class="comment4-div-mercury"><span class="reply_member"  onclick="showV3XMemberCardWithOutButton(\''+proxy[1]+'\')">' + proxy[0] + "<font color='red' style='font-weight: lighter;'>"+proxystr+"</font>:</span> <span  class='reply_data'>" + ReplyData + '</span></div>';
  }else{
    str += '<div class="reply_message_con"><div class="comment4-div-mercury"><span class="reply_member"  onclick="showV3XMemberCardWithOutButton(\''+currentUserId+'\')">' + currentUserName + ":</span> <span  class='reply_data'>" + ReplyData + '</span></div>';
  }
  str += '  <div class="comment-content-cols wordbreak clearFloat"  style="width: 678px; word-break: break-all; word-wrap: break-word;">';
  //意见隐藏了
  if(theForm.isHidden.checked){
    str += '<span class="commentContent-hidden">[' + opinionHidden + ']</span> ';
  }
  str += escapeStringToHTML(theForm.content.value);
  //if(proxyString != ""){
  //  str += "<div class='opinion-agent'>" + proxyString + "</div>";
  //}

  str += "</div><div class='wordbreak'>";

  if(!fileUploadAttachments.isEmpty()){
    var atts = fileUploadAttachments.values();
    var attachmentList = new ArrayList();
    var myDocumentList = new ArrayList();
    for(var i=0; i<atts.size(); i++){
      if(atts.get(i).type == 0){
        attachmentList.add(atts.get(i));
      }else{
        myDocumentList.add(atts.get(i));
      }
    }

    var attSize = attachmentList.size();
    if(attSize>0) {
      str += '  <div class="div-float attsContent" style="width:98%">';
      str += '    <div class="atts-label">' + attachmentLabel + ' :(<span class="font-12px">'+attSize+'</span>)&nbsp;&nbsp;</div>';
      for(var i = 0; i < attachmentList.size(); i++) {
        str += attachmentList.get(i).toString(true, false);
      }
      str += '  </div>';
    }

    var docSize = myDocumentList.size();
    if(docSize > 0) {
      str += '  <div class="div-float attsContent" style="width:98%">';
      str += '    <div class="atts-label">' + mydocumentLabel + ' :(<span class="font-12px">'+docSize+'</span>)&nbsp;&nbsp;</div>';
      for(var i = 0; i < myDocumentList.size(); i++) {
        str += myDocumentList.get(i).toString(true, false);
      }
      str += '  </div>';
    }
  }
  str += '</div></div>';
  document.getElementById("replyCommentDiv" + currentOpinionId).innerHTML += str;
  document.getElementById("replyDiv_" + currentOpinionId).innerHTML = "";
  document.getElementById("opinDiv"  + currentOpinionId).className = "comment-div-mercury";
  currentOpinionId = null;
  fileUploadAttachments.clear();
}
//显示“是否对发起者隐藏”选项
function showMoreHiddenOption(v,hiddenId){
  var showToIdSpan = document.getElementById(hiddenId);
  if(v.checked){
    if(showToIdSpan){
      showToIdSpan.style.display = "inline-block";
    }
  }else{
    if(showToIdSpan){
      showToIdSpan.style.display = "none";
    }
  }
}

var callbackObj = null;
function showMessager(obj,meetingId,mtCreateUserId){
  window.showMessagerWin = getA8Top().v3x.openDialog({
	  // 选择推送人员
      title:v3x.getMessage("meetingLang.meeting_choose_message_recevier"),
      transParams:{'parentWin':window},
      url: 'mtMeeting.do?method=showCommenter&meetingId=' + meetingId + '&mtCreateUserId=' + mtCreateUserId,
      width:"300",
      height:"350"
  });
  callbackObj = obj;
}

/**
 * 消息推送回调函数
 */
function showMessagerCallback(rv){
    if(rv){
        callbackObj.value = rv[1];
        var form = callbackObj.form;
        if(form){
          var messageReceiver = form.messageReceiver;
          if(messageReceiver){
            messageReceiver.value = rv[0];
          }
        }
      }
}

//检查是否为主窗口，平台没有提供，无奈得很
function _isMainWin(win){
    var ret = false;
    
    if(win){
        var mainIframe = win.document.getElementById("main");
        if(mainIframe && mainIframe.nodeName.toLocaleLowerCase() == "iframe"){
            ret = true;
        }
    }
    
    return ret;
}

//处理会议回执或会议室审批后，需要调用的刷新方法
function doMeeetingSign_pending(affairId) {
	try{
		//办公桌面
    	try{
	    	if(typeof(window.top)!='undefined'
	    		&& typeof(window.top.opener)!='undefined'
	    		&& typeof(window.top.opener.getCtpTop)!='undefined'
	    		&& typeof(window.top.opener.getCtpTop().refreshDeskTopPendingList) !='undefined'){
	    			//window.top.opener.getCtpTop().refreshDeskTopPendingList();
	    	}
    	}catch(e){
    		//alert(99);
    	}
    	
		//判断当前页面是否是主窗口页面
	    //if(getA8Top().isCtpTop ){ 
    	if(_isMainWin(getA8Top())){
	    	//时间线打开等
	    } else {
			var _win = window.top.opener.$("#main")[0].contentWindow;
		    if (_win != undefined) {
		        //判断当前是否是首页栏目
		        if (_win.sectionHandler != undefined) {
		            //首页栏目（当点击了统计图条件后处理）
		            if (_win.params != undefined && _win.params.selectChartId != "") {
		                _win._collCloseAndFresh(_win.params.iframeSectionId,_win.params.selectChartId,_win.params.dataNameTemp);
		            } else {
		                //进入首页待办栏目直接处理
		                _win.sectionHandler.reload("pendingSection",true);
		            }
		        } else {
		            //刷新列表
		            //_win.location = _win.location;
		        	var url = _win.location.href;
                    if (!(url.indexOf("collaboration.do") != -1)  &&  url.indexOf("plan.do?method=forwordCol") == -1) {
                        _win.location =  _win.location;
                    }
		        }
		    } else {  //刷新公文待办列表
		    	_win = window.top.opener.$("#main")[0];
		    	if (_win != undefined) {
		    		//刷新列表
		            _win.location = _win.location;
		    	}
		    }
		    //删除多窗口记录
		    if (affairId) {
		    	removeCtpWindow(affairId,2);
		    }

	    }
	} catch (e){}

	//判断时间线
	if(!_timeLineCloseFlag){
		getA8Top().close();
	}
}

var _openNewWinList = {};
var _lastTime = 0;
function meetingOpenNewWin(config){
    
    //该方法执行时间间隔设置成300ms, 防止快速点击, 特列，ff下双击执行的是两次单击
    var tempNow = new Date();
    var currentTime = tempNow.getTime();
    if(_lastTime == 0){
        _lastTime = currentTime;
    }else {
        var interval = currentTime - _lastTime;//时间差
        _lastTime = currentTime;
        if(interval < 300){
            return;
        }
    }
    
    if(!config.url){
        alert("请配置新打开窗口的URL");
        return;
    }
    var winId = config.id;
    if(!winId){
        winId = "newWin" + new Date().getTime();
    }
    
    var newWin = _openNewWinList[winId];
    if(newWin && !newWin.closed){
        alert(v3x.getMessage("V3XLang.window_already_exit"));
    }else{
        var winFeather = 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ',top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no';
        newWin = getA8Top().open(config.url, "meetingDetail" + new Date().getTime(), winFeather);
        _openNewWinList[winId] = newWin;
        newWin.focus();
    }
}

/**
 * Office转换成HTML，需要重新计算高度，保存纵向只有一条滚动条
 * @param parentId
 */
function resetTransOfficeHeight(parentId, widthElId){

    var contentTd = document.getElementById(parentId);
    if(contentTd){
        var tdChilds = contentTd.childNodes;
        for(var i = 0; i < tdChilds.length; i++){
            var tempChild = tdChilds[i];
            if(tempChild.nodeName.toLocaleLowerCase() == "iframe" && tempChild.contentWindow){
                
                var htmlIframeObj = tempChild.contentWindow.document.getElementById("htmlFrame");
                if(htmlIframeObj){
                    
                    var htmlIframeDoc = htmlIframeObj.contentWindow.document;
                    var htmlIframeHeight = 0;
                    var htmlIframeWidth = 0;
                    
                    //excel转换
                    var excelFrames = htmlIframeDoc.getElementsByName("frSheet");
                    if(excelFrames && excelFrames.length > 0){
                        var excelFrame = excelFrames[0];
                        htmlIframeDoc = excelFrame.contentWindow.document;
                        htmlIframeHeight = 38;
                    }else{
                        //Word
                    }
                    
                    var htmlIframeHTML = htmlIframeDoc.documentElement;
                    var htmlIframeBody = htmlIframeDoc.body;
                    
                    htmlIframeHeight += Math.max( htmlIframeBody.scrollHeight, htmlIframeBody.offsetHeight, 
                            htmlIframeHTML.clientHeight, htmlIframeHTML.scrollHeight, htmlIframeHTML.offsetHeight);
                    htmlIframeWidth  += Math.max( htmlIframeBody.scrollWidth, htmlIframeBody.offsetWidth, 
                            htmlIframeHTML.clientWidth, htmlIframeHTML.scrollWidth, htmlIframeHTML.offsetWidth);
                    
                    htmlIframeWidth = htmlIframeWidth * (100/99) + 24;
                    
                    htmlIframeBody.style.overflow = "visible";
                    contentTd.style.height = htmlIframeHeight + "px";
                    
                    if(widthElId){
                        var widthEl = document.getElementById(widthElId);
                        if(widthEl){
                            widthEl.style.width = htmlIframeWidth + "px";
                        }
                    }
                    break;
                }
             }
        }
    }
}
