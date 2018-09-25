/**
 * 2007-9-28 by xut
 */

//   不回显的人员数组
var  excludeElements_toUserIdsArray = new Array();
var  excludeElements_ccUserIdsArray = new Array();
var  excludeElements_apprizeUserIdsArray = new Array();

var  excludeElements_toUserIds;
var  excludeElements_ccUserIds;
var  excludeElements_apprizeUserIds;

//	todo  有时间考虑合并
function selectToUserIds(){
	isNeedCheckLevelScope_toUserIds = false;
//	将不显示的人员数组合并
	excludeElements_toUserIds = joinArrays("toUserIds",excludeElements_ccUserIdsArray,excludeElements_apprizeUserIdsArray);
	selectPeopleFun_toUserIds();
}

function selectToCcUserIds(){
	isNeedCheckLevelScope_ccUserIds = false;
	excludeElements_ccUserIds = joinArrays("ccUserIds",excludeElements_toUserIdsArray,excludeElements_apprizeUserIdsArray);
	selectPeopleFun_ccUserIds();
}

function selectToApprizeUserIds(){
	isNeedCheckLevelScope_apprizeUserIds = false;
	excludeElements_apprizeUserIds = joinArrays("apprizeUserIds",excludeElements_toUserIdsArray,excludeElements_ccUserIdsArray);
	selectPeopleFun_apprizeUserIds();
}

function joinArrays(jionArr,arr1,arr2){

		var arr = new Array();
		excludeElements_toUserIds = new Array();
   		excludeElements_ccUserIds = new Array();
   		excludeElements_apprizeUserIds = new Array();
   		
		if(arr1&&arr2){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr2);
		}else if(arr1){
			arr = eval("excludeElements_"+jionArr).concat(arr1);
		}else if(arr2){
			arr = eval("excludeElements_"+jionArr).concat(arr2);
		}
		
		return arr;
}

//	todo  有时间考虑合并
function setToUserIds(elements){

	if(!elements){
		return;
	}
	
	document.getElementById("toUserNames").value = getNamesString(elements);
	document.getElementById("toUserIdsValue").value = getIdsString(elements, false);
	excludeElements_toUserIdsArray = elements; 
}

function setCcUserIds(elements){

	if(!elements){
		return;
	}
	
	document.getElementById("ccUserNames").value = getNamesString(elements);
	document.getElementById("ccUserIdsValue").value = getIdsString(elements, false);
	excludeElements_ccUserIdsArray = elements; 
}

function setApprizeUserIds(elements){

	if(!elements){
		return;
	}
	
	document.getElementById("apprizeUserNames").value = getNamesString(elements);
	document.getElementById("apprizeUserIdsValue").value = getIdsString(elements, false);
	excludeElements_apprizeUserIdsArray = elements;
	
}

function setDepartmentFields(elements){
	if(!elements){
		return;
	}
	document.getElementById("refDepartmentName").value=getNamesString(elements);	
	document.getElementById("refDepartmentId").value=getIdsString(elements,false);
}

function getSelectId(){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
				break;
			}
		}
		return id;
}

	function getSelectId(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
				break;
			}
		}
		return id;
	}
	
function quoteDocument() {
    var atts = v3x.openWindow({
        url: v3x.baseURL + '/ctp/common/associateddoc/assdocFrame.do?isBind=1',
        height: 600,
        width: 800
    });
    if (atts) {
		deleteAllAttachment(2);
        for (var i = 0; i < atts.length; i++) {
            var att = atts[i]
            //addAttachment(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone, description)
            addAttachment(att.type, att.filename, att.mimeType, att.createDate, att.size, att.fileUrl, true, false, att.description, null, att.mimeType + ".gif", att.reference, att.category)
        }
    }
}


function openDetail(subject, _url) {
    _url = colURL + "?method=detail&" + _url;
    var rv = v3x.openWindow({
        url: _url,
        workSpace: 'yes'
    });

} 
	