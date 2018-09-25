var errMessage = _("USBKeyLang.cannot_use_alert");
/**
 * 初始化USB-Key
 * 进入制作狗页面的时候验证狗头
 */
function checkDogHead(){
	var dogObj;
	try{
		dogObj = new ActiveXObject("A8identifyDog.A8Identify");
	}
	catch(e1){
		dogObj = null;
		alert(_("USBKeyLang.cannot_create_dog"));
		return false;
	}
	//验证狗头
	if(dogObj != null){
		getA8Top().dogHeadId = dogObj.getDogHeadID();
		var theDogHeadId = getA8Top().dogHeadId;
		if(theDogHeadId.indexOf("ERR:") != -1 || theDogHeadId.indexOf("Err:") != -1){
			//var errMsg = dogHeadId.substring(4);
			//errMsg += errMessageEnd;
			var errorMessage = getErrorDogMessage(theDogHeadId);
			if("" == errorMessage){
				errorMessage = errMessage;
			}
			alert(errorMessage);
			return false;
		}
		else{
			var requestCaller = new XMLHttpRequestCaller(this, "identificationManager", "checkDogHead", false);
			requestCaller.addParameter(1, "String", theDogHeadId);
			var result = requestCaller.serviceRequest();
			if(result == "false" || result == false){
				alert(_("USBKeyLang.dogId_not_same"));
				return false;
			}
		}
	}
	getA8Top().passedCheck = true;
	return true;
}

/**
 * 制作USB-Key
 */
function makeUSBKey(){
	getA8Top().enterCount++;
	var enterCountNumber = getA8Top().enterCount;
	if(enterCountNumber <= 1){ //第一次进入
		 if(checkDogHead()){
			parent.detailFrame.location.href = identificationURL + "?method=makeUSBKey";
		 }
	}
	else{
		if(getA8Top().passedCheck == true){
			parent.detailFrame.location.href = identificationURL + "?method=makeUSBKey";
		}
		else{
			if(checkDogHead()){
				parent.detailFrame.location.href = identificationURL + "?method=makeUSBKey";
		 	}
		 	else{
				//alert(errMessage);
				return false;
		 	}
		}
	}
}

/**
 * 取得所选的一个checkbox的值
 */
function getSelectId(){
	var dogIds = document.getElementsByName('dogIds');
	for(var i=0; i<dogIds.length; i++){
		var idCheckBox = dogIds[i];
		if(idCheckBox.checked){
			return idCheckBox.value;
		}
	}
}

/**
 * 更新USB-Key
 */
function updateUSBKey(USBKeyId){
	if(USBKeyId){
		parent.detailFrame.location.href = identificationURL + "?method=editUSBKey&dogId=" + USBKeyId + "&disabled=true";
	}
	else{
		var count = validateCheckbox("dogIds");
		switch(count){
			case 0:
					alert(_("sysMgrLang.choose_item_from_list"));  
					return false;
					break;
			case 1:
					var dogId = this.getSelectId();
					parent.detailFrame.location.href = identificationURL + "?method=editUSBKey&dogId=" + dogId + "&disabled=false";
					break;
			default:
					alert(_("sysMgrLang.choose_one_only"));
					return false;
		}
	}
}


/**
 * 启用/停用USB-Key
 */
function enableUSBKey(stateFlag){
	var count = validateCheckbox("dogIds");
	if(count <= 0){
		alert(_("sysMgrLang.choose_item_from_list")); 
		return false;
	}
	document.all.enabled.value = stateFlag;
	document.forms["USBKeyMgrForm"].submit();
}


/**
 * 删除USB-Key
 */
function deleteUSBKey(){
	var count = validateCheckbox("dogIds");
	if(count <= 0){
		alert(_("sysMgrLang.choose_item_from_list")); 
		return false;
	}
	else{
		if(confirm(_("sysMgrLang.delete_sure"))){
			document.all.method.value = "deleteUSBKey";
			document.forms["USBKeyMgrForm"].method.value="deleteUSBKey";
			document.forms["USBKeyMgrForm"].submit();
		}
		else{
			return false;
		}
	}
}

/**
 * 显示/隐藏非通狗的设置行
 */
function displaySetOwnerTR(flag){
	var TRObj = document.getElementById("setOwnerTR");
	TRObj.style.display = flag? "":"none";
}

/**
 * 处理选人返回结果
 */
function showSelMember(elements){
	if(!elements){
		return;
	}
	document.all.memberName.value = elements[0].name;
	document.all.memberId.value = elements[0].id;
}

/**
 * 新建/编辑USB-Key的FORM校验
 */
function editUSBKeyOK(formName, isNewFlag){
	if(checkForm(formName)){
		if(document.getElementById("isGenericRadio2").checked){
			if(document.all.memberName.value == ""){
				alert(_("USBKeyLang.must_set_USBKey_owner"));
				selectPeopleFun_selMember();
				return false;
			}
		}
	}
	else{
		return false;		
	}
	//新建的时候取得newDogId
	if(isNewFlag == true){
		var newDogObj;
		try{
			newDogObj = new ActiveXObject("A8identifyDog.A8Identify");
		}
		catch(e1){
			newDogObj = null;
			alert(e1);
			return false;
		}
		if(newDogObj != null){
			var isDogHead = newDogObj.getDogHeadID();
			if(isDogHead.indexOf("ERR:") == -1 && isDogHead.indexOf("Err:") == -1){
				alert(_("USBKeyLang.cannot_write_dogHead"));
				return false;
			}
			else{
				var dogId = newDogObj.getDogID();
				if(dogId.indexOf("ERR:") == -1 && dogId.indexOf("Err:") == -1){
					var requestCaller = new XMLHttpRequestCaller(this, "identificationManager", "checkDogIsUsed", false);
					requestCaller.addParameter(1, "String", dogId);
					var result = requestCaller.serviceRequest();
					if(result != null && result != ""){
						var confirmText = "";
						if(result == "GENERIC_DOG"){
							confirmText = _("USBKeyLang.delete_the_genericDog");
						}
						else{
							confirmText = _("USBKeyLang.delete_the_usedDog", result);	
						}
						if(confirm(confirmText)){
							var requestCaller2 = new XMLHttpRequestCaller(this, "identificationManager", "deleteDogByEncodeId", false);
							requestCaller2.addParameter(1, "String", dogId);
							requestCaller2.serviceRequest();
						}else{
							return false;
						}
					}
				}
	
				//新版验证狗必须传入整型值才可以，不能直接传入getA8Top().dogHeadId
				var	theDogHeadId = getA8Top().dogHeadId;
				var newDogId = newDogObj.newDogID(theDogHeadId);
				if(newDogId.indexOf("ERR:") != -1 || newDogId.indexOf("Err:") != -1){
					var errorMessage = getErrorDogMessage(newDogId);
					if("" == errorMessage){
						errorMessage = newDogId.substring(4);
					}
					alert(errorMessage);
				 	return false;
				 }
				 else{
				 	document.all.dogId.value = newDogId;
				 }
			}
		 }
	}
	document.all.submitBtn.disabled = true;
}

/**
 * 显示隐藏IP设置行
 */
function displayIPTR(){
	var isMustUseDogObj = document.getElementById("isMustUseDogLogin");
	document.getElementById("setNoCheckIpTR").style.display = isMustUseDogObj.checked? "":"none";
}

function checkCanAccessMobile(){
	var mustUseDog = document.getElementById("isMustUseDog1");
	var canAccessMobileLabel = document.getElementById("canAccessMobileLabel");
	if(mustUseDog && canAccessMobileLabel){
		var canAccessMobile = document.getElementById("canAccessMobile");
		if(mustUseDog.checked){
			canAccessMobileLabel.style.display='';
		}else{
			canAccessMobileLabel.style.display='none';
		}
	}
}
/**
 * 添加IP
 */
function addIPOption(optionValue){
	if(optionValue == ""){
		alert(_("USBKeyLang.IP_is_null"));
		return;
	}
	var selectObj = document.all.IPSelect;
	if(selectObj){
		var oOption = document.createElement("option");
		oOption.text = optionValue;
		oOption.value = optionValue;
		selectObj.add(oOption);
	}
}

/**
 * 移除IP
 */
function removeIPOption(){
	var selectedIP = false;
	var selectObj = document.all.IPSelect;
    for(var i=0; i<selectObj.options.length; i++){
        if(selectObj.options[i].selected){
        	selectedIP = true;
        	if(confirm(_("USBKeyLang.sure_to_remove", selectObj.options[i].value))){
        		selectObj.removeChild(selectObj.options[i]);
        	}
        	break;
        }
    }
    if(selectedIP == false){
		alert(_("USBKeyLang.selectIP_to_remove"));
		return;
	}
}

/**
 * 全局配置首页FORM校验
 */
function configIdentificationOK(){
	var isMustUseDogObj = document.getElementById("isMustUseDogLogin");
	if(isMustUseDogObj.checked){
		var noCheckIpStr = "";
		var selectObj = document.all.IPSelect;
	    for(var i=0; i<selectObj.options.length; i++){
	        noCheckIpStr += selectObj.options[i].value;
	        if(i!=selectObj.options.length-1){
	        	noCheckIpStr += ";";
	        }
	    }
		document.all.noCheckIp.value = noCheckIpStr;
		return true;
	}
}

function getErrorDogMessage(errorId){
	var errorMessage = "";
	switch(errorId){
		case "Err:101":
			errorMessage = _("USBKeyLang.dog_error_101");
			break;
		case "Err:102":
			errorMessage = _("USBKeyLang.dog_error_102");
			break;
		case "Err:103":
			errorMessage = _("USBKeyLang.dog_error_103");
			break;
		case "Err:104":
			errorMessage = _("USBKeyLang.dog_error_104");
			break;
		case "Err:105":
			errorMessage = _("USBKeyLang.dog_error_105");
			break;
		case "Err:106":
			errorMessage = _("USBKeyLang.dog_error_106");
			break;
		case "Err:107":
			errorMessage = _("USBKeyLang.dog_error_107");
			break;
		case "Err:108":
			errorMessage = _("USBKeyLang.dog_error_108");
			break;
		case "Err:109":
			errorMessage = _("USBKeyLang.dog_error_109");
			break;
	}
	return errorMessage;
}