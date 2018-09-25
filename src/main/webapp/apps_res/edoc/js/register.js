


//检查标题是否含有特殊字符并且不能为空
function checkRegisterSubject(theForm){
    if(theForm.subject.value=="")	 {
		alert(_("edocLang.edoc_inputSubject"));
		if(theForm.elements["subject"].disabled==true) {
			alert(_("edocLang.edoc_alertSetPerm"));
			return false;
		}    		
		theForm.elements["subject"].focus();
		return false;
	}
	if(!(/^[^\|"']*$/.test(theForm.elements["subject"].value))){
		alert(_("edocLang.edoc_inputSpecialChar"));
		if(theForm.elements["subject"].disabled==true) {
			alert(_("edocLang.edoc_alertSetPerm"));
			return false;
		}    		
		theForm.elements["subject"].focus();
		return false;
	}
	return true;
}


//检查主送单位、抄送单位的是否设置有值
function checkRegisterSendTo(theForm){
	var sendAccount = theForm.sendTo;
	if(sendAccount && edocType == 0){
		if(theForm.elements["sendTo"].value.trim()==""){
			alert(_("edocLang.edoc_inputSendTo"));
	  		if(theForm.elements["sendTo"].disabled==true){
				alert(_("edocLang.edoc_alertSetSendTo"));
				return false;
			}	  
	 		theForm.elements["sendTo"].focus();
			return false;	
		}
	}
	if(theForm.sendTo.value==sendlt) {
		theForm.sendTo.value = "";
	}
	if(theForm.copyTo.value==copylt) {
		theForm.copyTo.value = "";
	}
	
	return true;
}

function formOnfocus(name) {
	var srcValue = "";
	var toValue = $("#sendForm").find("[@name='"+name+"']");
	if(name == "sendTo") {
		srcValue = sendlt;
	} else if(name == "copyTo") {
		srcValue = copylt;
	}
	if(toValue.val() == srcValue) {	
		toValue.val("");
		$(toValue).css("color", "gray");
	} else {
		$(toValue).css("color", "black");
	}
	toValue.css("color", "black");
}

function formOnblur(name) {
	var srcValue = "";
	var toValue = $("#sendForm").find("[@name='"+name+"']");
	if(name == "sendTo") {
		srcValue = sendlt;
	} else if(name == "copyTo") {
		srcValue = copylt;
	}
	if(toValue.val() == "") {
		toValue.val(srcValue);
		toValue.css("color", "gray");
	}
}


function changeValue(name) {
	var srcValue = "";
	var toValue = $("#sendForm").find("[@name='"+name+"']");
	if(name == "sendTo") {
		srcValue = sendlt;
	} else if(name == "copyTo") {
		srcValue = copylt;
	}
	if(toValue.val() == srcValue) {	
		toValue.val('');
	}
}




//是否有分发权限
function isEdocDistribute(theForm) {
	var distributerId = theForm.distributerId.value;
	var orgAccountId = document.getElementById("orgAccountId").value;
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "isEdocCreateRole", false);
	requestCaller.addParameter(1, "Long", distributerId); 
	requestCaller.addParameter(2, "Long", orgAccountId); 
	requestCaller.addParameter(3, "int", 3); 
	var ds = requestCaller.serviceRequest(); 
	if(ds!="true") {
	  	alert(_("edocLang.alert_no_edocDistributeRole", distributer));
	    return false;
	}
	return true;	  
} 




//保存按钮设置为不可用
function disableRegisterButtons() {	
	$("#save").attr("disabled", true);
	$("#saveAs").attr("disabled", true);
	$("#insert").attr("disabled", true);
	$("#content1").attr("disabled", true);
	if($("#bodyTypeSelector")) {
		$("#bodyTypeSelector").attr("disabled", true);
	}
	$("#back").attr("disabled", true);
}

//保存按钮设置为可用
function enabledRegisterButtons() {	
	$("#save").attr("disabled", false);
	$("#saveAs").attr("disabled", false);
	$("#insert").attr("disabled", false);
	$("#content1").attr("disabled", false);
	if($("#bodyTypeSelector")) {
		$("#bodyTypeSelector").attr("disabled", false);
	}
	$("#back").attr("disabled", false);
}


/**
 * 考虑到如果客户端没有安装word等软件，默认类型需要调整，查找的顺序是OfficeWord、WpsWord、HTML
 * 由于只有公文是默认word类型，所以不在组件中修改，放在公文代码中
 */
function initBodyType() {
	if (window.bodyTypeSelector) {
		var bodyTypeObj = document.getElementById("bodyType");
		var bodyType;
		if (bodyTypeObj) {
			bodyType = bodyTypeObj.value;
			if (bodyTypeSelector.contains("menu_bodytype_OfficeWord")
					&& bodyType == 'OfficeWord') {
				bodyTypeObj.value = "OfficeWord";
				bodyTypeSelector.disabled("menu_bodytype_OfficeWord");
			} else if (bodyTypeSelector.contains("menu_bodytype_WpsWord")
					&& bodyType == 'WpsWord') {
				bodyTypeObj.value = "WpsWord";
				bodyTypeSelector.disabled("menu_bodytype_WpsWord");
			} else if (bodyTypeSelector.contains("menu_bodytype_HTML")
					&& bodyType == 'HTML') {
				bodyTypeObj.value = "HTML";
				bodyTypeSelector.disabled("menu_bodytype_HTML");
			} else if (bodyTypeSelector.contains("menu_bodytype_Pdf")
					&& bodyType == 'Pdf') {
				bodyTypeObj.value = "Pdf";
				bodyTypeSelector.disabled("menu_bodytype_Pdf");
			}
		}
	}
}