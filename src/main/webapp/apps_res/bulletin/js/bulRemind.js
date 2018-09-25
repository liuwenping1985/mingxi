
function fnSelectAll(allCheckBox, targetName){
	var objcts = document.getElementsByName(targetName);
	if(objcts != null){
		for(var i = 0; i < objcts.length; i++){
			if(objcts[i].disabled == true){
				continue;
			}
			objcts[i].checked = allCheckBox.checked;
		}
	}
}
	
function fnGetSelectedIds(){
	var objcts = document.getElementsByName("id");
	var memberIds = new Array();
	if(objcts != null){
		for(var i = 0; i < objcts.length; i++){
			if(objcts[i].disabled == true){
				continue;
			}
			if(objcts[i].checked){
				memberIds.push(objcts[i].value);
			}
		}
	}
	return memberIds.toString();
}

function fnGetSelectType(){
	var objcts = document.getElementsByName("type");
	if(objcts != null && objcts.length > 0){
		return objcts[0].value;
	}
	return "";
}

//催办
function fnRemind(bulletinId){
	var remindNum = fnGetSelectedIds().length;
	if (remindNum < 1) {
		alert(i18nRemindSelect);
	}
	
	var requestCaller = new XMLHttpRequestCaller(this, "bulDataManager", "messageRemind", false);
    requestCaller.addParameter(1, "String", bulletinId);//公告id
    requestCaller.addParameter(2, "String", fnGetSelectType());//催办类型，memeber，dept，account
    requestCaller.addParameter(3, "String", fnGetSelectedIds());//ids
    
    var data = requestCaller.serviceRequest();
    if(data == 'true'){
    	alert(i18nRemindSuccess);
    }
}