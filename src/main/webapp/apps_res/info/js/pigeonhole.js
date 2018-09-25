function doPigeonholeWindow(flag, appName, from,obj) {
	doPigeonhole(flag, appName, from);
}

//预归档
var doPigeonholeCallbackParam = {};
function doPigeonhole(flag, appName, from) {
    doPigeonholeCallbackParam.flag = flag;
    doPigeonholeCallbackParam.appName = appName;
    doPigeonholeCallbackParam.from = from;
    
    if (flag == "no") {
        //TODO 清空信息
    }
    else if (flag == "new") {
        var result;
    	if(from == "templete"){
        	result = pigeonhole(appName, null, false, false);
    	}else{
    		result = pigeonhole(appName,null);
    	}
    }
}

/**
 * 归档回调
 * @param result
 */
function doPigeonholeCallback(result){
    var flag = doPigeonholeCallbackParam.flag;
    var appName = doPigeonholeCallbackParam.appName;
    var from = doPigeonholeCallbackParam.from;
    
    var theForm = document.getElementsByName("sendForm")[0];
    if(result == "cancel"){
        var oldPigeonholeId = theForm.archiveId.value;
        var selectObj = theForm.colPigeonhole;
        if(oldPigeonholeId != "" && selectObj.options.length >= 3){
            selectObj.options[2].selected = true;
        }
        else{
            var oldOption = document.getElementById("defaultOption");
            oldOption.selected = true;
        }
        return;
    }
    var pigeonholeData = result.split(",");
    pigeonholeId = pigeonholeData[0];
    pigeonholeName = pigeonholeData[1];
    if(pigeonholeId == "" || pigeonholeId == "failure"){
        theForm.archiveName.value = "";
        $.alert(pipeinfo1);
    }
    else{
        var oldPigeonholeId = theForm.archiveId.value;
        theForm.archiveId.value = pigeonholeId;
        if(document.getElementById("prevArchiveId")){
            document.getElementById("prevArchiveId").value = pigeonholeId;
        }
        var selectObj = document.getElementById("colPigeonhole");
        var option = document.createElement("OPTION");
        option.id = pigeonholeId;
        option.text = pigeonholeName;
        option.value = pigeonholeId;
        option.selected = true;
        if(oldPigeonholeId == "" && selectObj.options.length<=2){
            selectObj.options.add(option, selectObj.options.length);
        }
        else{
            selectObj.options[selectObj.options.length-1] = option;
        }
    }
}

function pigeonholeEvent(obj){
	var theForm = document.getElementsByName("sendForm")[0];
	switch(obj.selectedIndex){
		case 0 :
			var oldArchiveId = theForm.archiveId.value;
			if(oldArchiveId != ""){
				theForm.archiveId.value = "";
			}
			theForm.archiveId.value = "";
			break;
		case 1 : 
			doPigeonholeWindow('new', '1', 'info',obj);
			break;
		default :
			theForm.archiveId.value = document.getElementById("prevArchiveId").value;
			return;
	}
}