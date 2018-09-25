/**
 * Created by Zhangfeng
 * Modified by Handy at 2007-7-3
 */

try {
    getA8Top().endProc();
}
catch(e) {
}


/*--------------------------------------- 文档库管理 start ------------------------------------------*/

// 进入创建文档库页面
function createDocLib() {
	parent.bottom.location.href = managerURL + "?method=addDocLibPage";
}

// 添加一个文档库
function addDocLib() {	
	document.body.onunload=null;	
	if(!checkForm(myform))
		return;
	
	var members = document.getElementById("members");
	if(members == null || members.value == "") {		
		if(myform.docManager.value == myform.docManager.deaultValue) {
			alert(v3x.getMessage("DocLang.doc_lib_alter_manager"));
			return ;
		}
	}
	
	getA8Top().startProc();

	myform.target = "empty";
	myform.action = managerURL + "?method=addDocLib" + addParam4Uncheckedbox();
	myform.submit();
}
var checkArray = ['columnEditable', 'searchConditionEditable', 'logView', 'downloadLog', 'printLog', 'folderEnabled', 'a6Enabled', 'officeEnabled', 'uploadEnabled'];
function addParam4Uncheckedbox() {
	var ret = "";
	for(var i=0; i<checkArray.length; i++) {
		if(document.getElementById(checkArray[i]).checked == false) {
			ret += ("&" + checkArray[i] + "=0");
		}
	}
	return ret;
}
// 进入编辑文档库页面
function editDocLib(id, flag) {
	var aUrl = managerURL + "?method=editDocLibPage&flag=" + flag;
	var checkid = id;
	if (checkid == "undefined") {
		checkid = mainForm.id;
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {
			if (!checkid.checked) {
				alert(v3x.getMessage("DocLang.doc_lib_alter_not_select"));
				return ;
			}	
			else {
				var aId = mainForm.id.value;
				aUrl += "&id=" + aId;
			}
		}
		else {
			var j = 0;
			for (i = 0; i <len; i++) {
				if (checkid[i].checked == true) {
					aUrl += "&id=" + checkid[i].value;
					j++;
				}
			}
			if (j == 0) {
				alert(v3x.getMessage("DocLang.doc_lib_alter_not_select"));
				return ;
			}
			else if (j > 1){
				alert(v3x.getMessage("DocLang.doc_lib_alter_select_one"));
				return ;
			}
		}
	}
	else {
		aUrl += "&id=" + id;
	}
	parent.bottom.location.href = aUrl;
}

// 修改文档库信息
function modifyDocLib(docLibId) {
	if(!checkForm(myform))
		return;
	getA8Top().startProc();//提交阻塞
	myform.target = "empty";
	myform.action = managerURL + "?method=updateDocLib&docLibId=" + docLibId + addParam4Uncheckedbox();
	myform.submit();
}


// 删除文档库
function deleteDocLib() {		
	var docLibIds = document.getElementsByName("id");
	var _docLibType = new Array();
	var _docLibId = new Array();
	var temp = 0;
	var bool = false;
	var _deleteInfo = document.getElementById("deleteInfo");
	var str = "";
	_deleteInfo.innerHTML = "";
	for(var i = 0; i < docLibIds.length; i++) {
		if(docLibIds[i].checked) {
			_deleteInfo.innerHTML += "<input type=hidden name=docLibId value=" + docLibIds[i].value + ">";
			_docLibId[temp] = docLibIds[i].value;
			_docLibType[temp] = docLibIds[i].attributes['docLibType'].nodeValue;
			temp = temp + 1;
		}
	}
	
	if(temp == 0) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_select_deleted"));
		return ;
	}
	
	for(var i = 0; i < _docLibType.length; i++) {
		if(_docLibType[i] != 0) {
			bool = true;
			break;
		}
	}
	if(bool) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_delete_system_type_disabled"));
		return ;
	}
	
	if(window.confirm(v3x.getMessage("DocLang.doc_lib_alter_delete_confirm"))){	
		getA8Top().startProc();
					
		mainForm.target = "empty";
		mainForm.action = managerURL + "?method=deleteDocLib";
		mainForm.submit();
	}
	
}

// 进入显示栏目设置页面
function setDocListColumn(id) {		
	var surl = managerURL + "?method=setDocListColumn&docLibId=" + id;
	var returnValue=v3x.openWindow({
		url : surl,
		width : "500",
		height : "400",
		resizable : "false"
	});

	if(returnValue != null && returnValue != undefined){
		var tempValue=returnValue.split(",");
		var str="<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">";
		for(var i=0;i<tempValue.length;i++){
			str+="<tr height=\"18\"><td width=\"30%\" nowrap align=\"left\" valign=\"top\">&nbsp;&nbsp;&nbsp;"+tempValue[i]+"</td></tr>";
		}
		str+="</table>";
		
		document.getElementById("columTable").innerHTML=str;
		
		document.getElementById("listColumnDefault").style.display = "block";
	}
}

function getLimitLength(str, len){
	try{
		if(str.length > len){
			var newStr = str.substring(0, len);
			newStr += '...';
			return newStr;
		}else{
			return str;
		}
	}catch(e){
		return str;
	}
}

/**
 * 回复文档库显示栏目为默认
 */
function setDocListColumnDefault(id) {		
	getA8Top().startProc();
	
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocLibManager",
		 "setListColumnToDefault", false);
	requestCaller.addParameter(1, "Long", id);
			
	var columnNames = requestCaller.serviceRequest();
	
	//alert(columnNames);

	var str="<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">";
	for(var i = 0; i < columnNames.length; i++){
		str+="<tr height=\"18\"><td width=\"30%\" nowrap align=\"left\" valign=\"top\">&nbsp;&nbsp;&nbsp;"+columnNames[i]+"</td></tr>";
	}
	str+="</table>";
	
	document.getElementById("columTable").innerHTML=str;

	document.getElementById("listColumnDefault").style.display = "none";
	getA8Top().endProc();
}

// 修改列表显示栏目
function modifyDocListColumn() {
	var str = "";
	var strName = "";
	var _temp = mainForm.checkin.length;
	var var_id = "";
	var flag = false;

  for (var i = 0; i<_temp; i++ )  {
		 if (flag == false) {
			str_id = mainForm.checkin.options[i].value;
			// 名称的栏目ID为2
			if (str_id == "2") {
				flag = true;
			}
		}
 }
  
 if (flag == false) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_not_select_name"));
		return;
	}
	
	if(_temp == 0) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_select_column"));
		return ;
	}
	else if(_temp > 20) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_select_column_too_more", 20));
		return ;
	}
	
	if(v3x.getBrowserFlag('openWindow') == true){
		document.getElementById("b1").disabled = true;
		document.getElementById("b2").disabled = true;
	}


	

        //   alert(str);



	for(var i = 0; i <_temp; i++) {
		if(i != _temp - 1) {
			str += mainForm.checkin.options[i].value;
			str += ",";
			str += i;
			str += ";";
			
			strName+=mainForm.checkin.options[i].text;
			strName+=","
		}
		else {
			str += mainForm.checkin.options[i].value;
			str += ",";
			str += i;
			
			strName+=mainForm.checkin.options[i].text;
		}
	}



 


	  

	 //if (flag==false){
//
	    //   if(!window.confirm(parent.v3x.getMessage('DocLang.doc_lib_alter_not_select_name'))){
			 //    return;
		//   }
	      
		//return;
		//getA8Top().startProc();

	//  }
	
	var hiddenInput = document.getElementById("columnIds");
	hiddenInput.innerHTML = "<input type='hidden' name=selectedColumn id=selectedColumn value='" + str + "' />";
	document.getElementById("columnName").innerHTML="<input type='hidden' name=choiceName id=choiceName value='" + strName + "' />"
	mainForm.action = managerURL + "?method=updateDocListColumn";
	mainForm.target = "empty";
	
	mainForm.submit();
}
// 进入文档库内容类型设置页面
function setContentType(id) {
	var surl = managerURL + "?method=setContentTypes&docLibId=" + id;
	var returnValue=v3x.openWindow({
		url : surl,
		width : "500",
		height : "400",
		resizable : "false"
	});
	
	if(returnValue != null && returnValue != undefined){
		var theValue=returnValue.split(",");
		var str="<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">";
		for(var i=0;i<theValue.length;i++){
			str+="<tr height=\"18\"><td width=\"30%\" nowrap align=\"left\" valign=\"top\" title=\"" 
				+ theValue[i] + "\">&nbsp;&nbsp;&nbsp;"
				+ getLimitLength(theValue[i], 16) + "</td></tr>";
		}
		str+="</table>";
		document.getElementById("typeTable").innerHTML=str;
	}
}


// 文档库内容类型设置保存	
function updateContentTypes() {			
	var str = "";
	var typeName="";
	var _temp = mainForm.checkin.length;
//	if(_temp == 0) {
//		alert(v3x.getMessage("DocLang.doc_lib_alter_select_content_type"));
//		return ;
//	}

	document.getElementById("b1").disabled = true;
	document.getElementById("b2").disabled = true;
	
	for(var i = 0; i < _temp; i++) {
		if(i != _temp-1) {
			str += mainForm.checkin.options[i].value;
			str += ",";
			str += i;
			str += ";";
			
			typeName+=mainForm.checkin.options[i].text;
			typeName+=",";
		}
		else {
			str += mainForm.checkin.options[i].value;
			str += ",";
			str += i;
			
			typeName+=mainForm.checkin.options[i].text;
		}
	}
	var hiddenInput = document.getElementById("columnIds");
	hiddenInput.innerHTML = "<input type='hidden' name=contentTypeIds id=contentTypeId value='" + str + "' />";
	document.getElementById("docTypeName").innerHTML="<input type='hidden' name=docTypeNames id=docTypeNames value='" + encodeURIComponent(typeName) + "' />"
	mainForm.action = managerURL + "?method=updateContentTypes";
	mainForm.target = "empty";
	
	mainForm.submit();
}

// 文档库内容类型设置 : 右移
function addNewItem() {
	for(var i = 0; i < mainForm.checkout.length; i++) {
		if(mainForm.checkout.options[i].selected  == true ) {
			var flag = true;
			for (var j = 0; j < mainForm.checkin.length; j++){
				if (mainForm.checkin.options[j].value == mainForm.checkout.options[i].value) {
					flag = false;
				}
			}	
			if (flag == true){
				mainForm.checkin.options[mainForm.checkin.length] = new Option(mainForm.checkout.options[i].text, mainForm.checkout.options[i].value);				
			}								
			mainForm.checkout.options[i].selected = false;
		}
	}
}

// 文档库内容类型设置 : 左移
function removeItem() {		

	for(var j = 0; j < mainForm.checkin.length; j++) {
		if(mainForm.checkin.options[j].selected  == true ) {
			mainForm.checkin.options.remove(j);
			j--;
		}
	}
}

// 文档库内容类型设置 : 上移	
function doChoiceUp() {		
	var the_length = mainForm.checkin.length;
	for(var i = 0; i < the_length; i++) {
		if(mainForm.checkin.options[i].selected == true) {
			if(i != 0) {
				var temp_text = mainForm.checkin.options[i].text;
				var temp_value = mainForm.checkin.options[i].value;
				mainForm.checkin.options[i].text = mainForm.checkin.options[i - 1].text;
				mainForm.checkin.options[i].value = mainForm.checkin.options[i - 1].value;
				mainForm.checkin.options[i - 1].text = temp_text;
				mainForm.checkin.options[i - 1].value = temp_value;
				mainForm.checkin.options[i - 1].selected = true;
				mainForm.checkin.options[i].selected = false;
				break;
			}
		}
	}
}

// 文档库内容类型设置 : 下移
function doChoiceDown() {			
	var the_length = mainForm.checkin.length;
	for(var i = 0; i < the_length; i++) {
		if(mainForm.checkin.options[i].selected == true) {
			if(i != the_length - 1) {
				var temp_text = mainForm.checkin.options[i].text;
				var temp_value = mainForm.checkin.options[i].value;
				mainForm.checkin.options[i].text = mainForm.checkin.options[i + 1].text;
				mainForm.checkin.options[i].value = mainForm.checkin.options[i + 1].value;
				mainForm.checkin.options[i + 1].text = temp_text;
				mainForm.checkin.options[i + 1].value = temp_value;
				mainForm.checkin.options[i + 1].selected = true ;
				mainForm.checkin.options[i].selected = false;
				break;
			}
		}
	}
}

// 进入文档库排序界面--首先判断是否有可排序的信息
function sort() {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocLibManager", "isEmpty", false);
		var ds = requestCaller.serviceRequest();
		if(ds=='false'){
			var surl = managerURL + "?method=changeDocLibOrderIframeView";
			var returnValue=v3x.openWindow({
				url : surl,
				width : "350",
				height : "317",
				resizable : "false"
			});
			if(returnValue)
				window.location.reload();
		}else{
			alert(v3x.getMessage('DocLang.doc_alert_no_oderlibs'));
		}
}

// 调整文档库显示顺序
function doSort(id,type) {
	window.returnValue = true;    //如果调用dosort（），则返回一个值，在sort（）中进行判断
	mainForm.action = managerURL + "?method=changeDocLibOrder&id="+id+"&type="+type;
	mainForm.target = "empty";
	mainForm.submit();
}
//修改文档文档排序的方法
function saveOrderRep(){
	var oSelect = document.getElementById("projectsObj");
	if(!oSelect) return false;
	var ids = [];
	for(var selIndex=0; selIndex<oSelect.options.length; selIndex++)
     {
        ids[selIndex] = oSelect.options[selIndex].value;
        var element = document.createElement('input');
        element.setAttribute('type', 'hidden');
        element.setAttribute('name', 'ids');
        element.setAttribute('value', oSelect.options[selIndex].value);
	    mainForm.appendChild(element);
     }
	mainForm.action = managerURL + "?method=changeDocLibOrderRep" ;
	mainForm.target = "empty";
	mainForm.submit();
	window.returnValue = true ;
	window.close() ;
	
}

/*--------------------------------------- 文档库管理 End -------------------------------------------*/

/*--------------------------------------- 内容类型管理 Start -------------------------------------------*/

// 进入新建文档类型界面
function createDocType() {
	parent.bottom.location.href = managerURL + "?method=addDocTypePage";
}

// 添加一个文档类型
function addDocType() {
		if(!checkForm(mainForm))
		return;
	
	doTransction();
	/*var a = mainForm.addString.value;
	if (a == ""){
		alert(v3x.getMessage("DocLang.doc_type_alter_prop_null"));
		return ;
	}*/
	var sId = mainForm.sId;
	if (sId == undefined){
		alert(v3x.getMessage("DocLang.doc_type_alter_prop_null"));
		return ;
	}

//	var name = mainForm.theName.value;
//	var the_name = mainForm.theName.deaultValue;
//	if(name == "" || name.length == 0) {
//		alert(v3x.getMessage("DocLang.doc_type_alter_name_null"));
//		return ;
//	}
//	var bool = true;
//	
//	if(bool == false  || name == the_name) {
//		alert(v3x.getMessage("DocLang.doc_type_alter_name_null"));
//		return ;
//	}
	
	getA8Top().startProc();
	
		document.getElementById("b1").disabled = true;
	document.getElementById("b2").disabled = true;
	
	mainForm.action = managerURL + "?method=addDocType";
	mainForm.target = "empty";
	mainForm.submit();
}

// 进入文档类型设置页面		
function editDocType(id, flag, createdByCurrentAccount, isSystem, used) {
	var aUrl = managerURL + "?method=editDocTypePage&flag=" + flag;
	var viewUrl = managerURL + "?method=editDocTypePage&flag=view";
	var checkid = id;
	var theSelId = "0";
	var ckbUsedFlag = '';
	if (checkid == "undefined") {
		checkid = mainForm.id;
		if(typeof(checkid) !== 'object') {
			alert(v3x.getMessage("DocLang.doc_type_alter_not_select"));
			return ;
		}
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {
			if (!checkid.checked) {
				alert(v3x.getMessage("DocLang.doc_type_alter_not_select"));
				return ;
			}	
			else {
				var aId = mainForm.id.value;
				aUrl += "&docTypeId=" + aId;
				viewUrl += "&docTypeId=" + aId;
				ckbUsedFlag = mainForm.id.usedFlag;
				theSelId = aId;
			}			
		}
		else {
			var j = 0;
			for (i = 0; i <len; i++) {
				if (checkid[i].checked == true) {
					aUrl += "&docTypeId=" + checkid[i].value;
					viewUrl += "&docTypeId=" + checkid[i].value;
					ckbUsedFlag = checkid[i].usedFlag;
					theSelId = checkid[i].value;
					j++;
				}
			}
			if (j == 0) {
				alert(v3x.getMessage("DocLang.doc_type_alter_not_select"));
				return ;
			}
			else if (j > 1){
				alert(v3x.getMessage("DocLang.doc_type_alter_select_one"));
				return ;
			}
		}
	}
	else {
		aUrl += "&docTypeId=" + id;
		viewUrl += "&docTypeId=" + id;
		theSelId = id;
	}
	
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxContentTypeManager",
		 "isUsed", false);
	requestCaller.addParameter(1, "long", theSelId);			
	var usedFlag = requestCaller.serviceRequest();
	
	if(isSystem == 'true' && flag == 'edit'){
		alert(v3x.getMessage("DocLang.doc_type_edit_system"));
	}else if(createdByCurrentAccount == 'false' && flag == 'edit'){
		alert(v3x.getMessage("DocLang.doc_type_edit_no_acl"));
//		parent.bottom.location.href = viewUrl;
	}else if(usedFlag == 'true' && flag == 'edit'){
		//alert(v3x.getMessage("DocLang.doc_type_edit_used"));
		parent.bottom.location.href = aUrl;
	}else
		parent.bottom.location.href = aUrl;
}	


function updateDocType() {
		if(!checkForm(mainForm))
		return;
	
	doTransction();
	/*var a = mainForm.addString.value;
	if (a == ""){
		alert(v3x.getMessage("DocLang.doc_type_alter_prop_null"));
		return ;
	}*/
	var sId = mainForm.sId;
	if (sId == undefined){
		alert(v3x.getMessage("DocLang.doc_type_alter_prop_null"));
		return ;
	}

//	var name = mainForm.theName.value;
//	var the_name = mainForm.theName.deaultValue;
//	if(name == "" || name.length == 0) {
//		alert(v3x.getMessage("DocLang.doc_type_alter_name_null"));
//		return ;
//	}
//	var bool = true;
//	
//	if(bool == false  || name == the_name) {
//		alert(v3x.getMessage("DocLang.doc_type_alter_name_null"));
//		return ;
//	}
	
	
	document.getElementById("b1").disabled = true;
	document.getElementById("b2").disabled = true;
	
	getA8Top().startProc();
	
	mainForm.action = managerURL + "?method=updateDocType";		
	mainForm.target = "empty";
	mainForm.submit();
}

//删除文档类型	
function deleteDocType() {		
	var theDoc = document.getElementsByName("id");
	var temp = new Array();
	var _temp = new Array();
	var j = 0;
	var str = "";
	for(var i = 0; i < theDoc.length; i++) {
		if(theDoc[i].checked) {
			temp[j] = theDoc[i].value;
			_temp[j] = theDoc[i].title;
			j = j + 1;
		}
	}
	if(j == 0) {
		alert(v3x.getMessage("DocLang.doc_type_alter_select_deleted"));
		return ;
	}
	if(j == 1){
		
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxContentTypeManager",
		 "isUsed", false);
	  requestCaller.addParameter(1, "long", temp[0]);			
	  var usedFlag = requestCaller.serviceRequest();
	  if(usedFlag == "true")  {
		  alert(v3x.getMessage("DocLang.doc_type_edit_used"));
		  return;
	  } 

	}
	for(var k = 0; k < _temp.length; k++) {
		if(_temp[k] == "true") {
			alert(v3x.getMessage("DocLang.doc_type_alter_delete_system_type_disabled"));
			return ;
		}
	}
	for(var m = 0; m < temp.length; m++) {
		if(m != (temp.length-1)) {
			str += temp[m];
			str += ",";
		}
		else {
			str += temp[m];
		}
	}
	if(window.confirm(v3x.getMessage("DocLang.doc_type_alter_delete_confirm"))) {
		var _docTypeIds = document.getElementById("docTypeIds");
		_docTypeIds.innerHTML = "<input type=hidden name=theIds id=theIds value=" + str+ " />"
		mainForm.action = managerURL + "?method=deleteDocType";
		
		getA8Top().startProc();
		mainForm.submit();
	}	
}


//弹出元数据选择页面
function addNewMeta() {
	var theStr=v3x.openWindow({
		url : managerURL + "?method=selectDocProperties",
		width : "600",
		height : "350",
		resizable : "false"
	});
	if(theStr == null || theStr == "") {
		return ;
	}
	var tempStr = theStr.split(":");
	var loc = theStr.lastIndexOf(":");
	var inputStr = theStr.substring(0, loc);
	var theIdStr = theStr.substring(loc + 1, theStr.length);

	document.getElementById("tempMetadata").innerHTML = inputStr;
	addRowAndCell(theIdStr);
}

function addRowAndCell(theIdStr) {
	theIdStr = refreshString(theIdStr);
	var theTable = document.getElementById("metadataHtmlId");
	//取得要发生变化得表对象
	var theIds = theIdStr.split(",");											//要添加得ID串
	for(var i = 0; i < theIds.length; i++) { 
		var lastInput = document.getElementById("metadata" + theIds[i]);		//取出要生成表行得隐藏数据
		//var readOnly = lastInput.isReadOnly;									//判断该元数据是否是只读		
		theArrayList.add(theIds[i]);
		//生成一行
		var tr = theTable.insertRow();
		tr.id = "tr" + theIds[i];
		var td1 = tr.insertCell();		//插入第一列
		td1.align = "center";
		td1.width="35";
		td1.innerHTML = "<input type='checkbox' name='sId' id='sId' value='" + theIds[i] + "'/>";
		td1.className = "sort";
		var td2 = tr.insertCell();
		td2.innerHTML = lastInput.getAttribute('metaName').escapeHTML();
		td2.className = "sort";
		/*var td3 = tr.insertCell();
		td3.innerHTML = v3x.getMessage(lastInput.getAttribute('category').escapeHTML());
		td3.className = "sort";*/
		var td4 = tr.insertCell();
		td4.width="20%";
		td4.innerHTML = lastInput.getAttribute('typeKey').escapeHTML();
		td4.className = "sort";
		var td5 = tr.insertCell();	
		td5.width="15%";	
		td5.innerHTML = "<input type='checkbox'  name='isEditable" + theIds[i] + "' id='isEditable" + theIds[i] + "' value='1'/>";		
		
		td5.className = "sort";
		td5.align = "center";
		var td6 = tr.insertCell();
		td6.width="15%";		
		td6.innerHTML = "<input type='checkbox' checked name='nullable" + theIds[i] + "' id='nullable" + theIds[i] + "' value='1'/>";		
		
		td6.className = "sort";
		td6.align = "center";
	}
	
}
	
//过滤已经选择了的项
function refreshString(theIdStr) {
	var temp_ids = theIdStr.split(",");
	var str = "";
	for(var i = 0; i < temp_ids.length; i++) {
		if(!theArrayList.contains(temp_ids[i])) {
			str += temp_ids[i];
			str += ",";
		}
	}
	
	if(str != "") {
		str = str.substring(0, str.length - 1);
	}
	return str;
}
	
//删除选中的项
function deleteChoiceMeta() {
	var theId=document.getElementsByName("sId");
	var num = 0;
	for(var i=0;i<document.getElementsByName("sId").length;i++){
		if(theId[i].checked && theId[i].parentNode.parentNode.tagName == "TR") {
			if(theId[i].value == null || theId[i].value== "") {
				continue;
			}
			num++;
			theArrayList.remove(theId[i].value);				//先移出集合中得具体值再移出结点
			theId[i].parentNode.parentNode.removeNode(true);
			i--;
		}
	}
	
	if(num == 0){
		alert(v3x.getMessage("DocLang.doc_property_alter_select_deleted"));
	}
}
	
//向上、下移动一行
function choiceMetaIndex(flag) {
	var theTable = document.getElementById("metadataHtmlId");
	var theId = document.getElementsByName("sId");
	var temp = 0;
	var ids = "";
	var tempId = "";
	for(var i = 0; i < theId.length; i++) {
		if(theId[i].checked) {
			ids = theId[i].value;
			tempId = theId[i].value;
			temp = temp + 1;
		}
	}
	ids = "tr" + ids;
	if(temp == 0) {
		alert(v3x.getMessage("DocLang.doc_property_alter_not_select"));
		return ;
	}
	if(temp > 1) {
		alert(v3x.getMessage("DocLang.doc_type_alter_select_one_prop"));
		return ;
	}
	for(var k = 0; k < theTable.rows.length; k++) {
		if(theTable.rows[k].id == ids ) {			//得到选中的行	
			if(k == 0) {
				return;
			}
			if(flag == 'up') {
				if(k == 1) {
					//theTable.rows[k].swapNode(theTable.rows[theTable.rows.length - 1]);
					//break;
					alert(v3x.getMessage("DocLang.doc_property_already_top_alert"));
					return ;
				}
				theTable.rows[k].swapNode(theTable.rows[k - 1]);
				break;
			}
			else if(flag == 'down') {
				if(k == theTable.rows.length - 1) {
					//theTable.rows[k].swapNode(theTable.rows[1]);
					//break;
					alert(v3x.getMessage("DocLang.doc_property_already_end_alert"));
					return ;
				}
				theTable.rows[k].swapNode(theTable.rows[k + 1]);
				break;
			}
			
		}
	}
	
	for(var j = 0; j < theId.length; j++) {
		if(theId[j].value == tempId) {
			theId[j].checked = "checked";
			break;
		}
	}
}
	
	
//添加选择得元数据，并把其组成原表得一行
function addChoiceMeta() {
	var list = window.dialogArguments.theArrayList;
	var theId = metaIframe.document.getElementsByName("id");
	var str = "";
	var theValue = "";
	var flag = false;
	for(var i = 0; i < theId.length; i++) {
		if(theId[i].checked) {
			if (!list.contains(theId[i].value)) {			
				flag = true;
				//保存选择得值
				str += "<input type='hidden' id='metadata" + theId[i].value + "'  value='" + theId[i].value 
					+ "'  metaName='" + theId[i].getAttribute("metaName") + "' category='" + theId[i].getAttribute("category") + "' typeKey='" 
					+ theId[i].getAttribute("typeKey") + "' />" ;
				theValue += theId[i].value;
				theValue += ",";
			}
		}
	}
	if (flag) {
		theValue = theValue.substring(0, theValue.length - 1);
		str += ":";
		str += theValue;
	}	
	
	window.returnValue = str;
	window.close();
}
	
//整理得到集合的最终顺序
function getLastOrder() {
	var theId = document.getElementsByName("sId");
	lastList = new ArrayList();
	for(var i = 0; i < theId.length; i++) {
		//if(theArrayList.contains(theId[i].value)) {
		lastList.add(theId[i].value);			//往最终集合里面存储id
		//}
	}	
}
	
//保存前，进行最后的封装
function doTransction() {
	getLastOrder();
	var str = "";
	for(var i = 0; i < lastList.size(); i++) {			//最终要添加的ID集合
		var id = lastList.get(i);
		str += id;
		str += ",";
		var isEditable = document.getElementById("isEditable" + id);
		//对于系统默认只能是只读得项
		if(isEditable == null || isEditable == "") {
			str += "true";
		}
		else {
			if(isEditable.checked) {
				str += "true";
			}
			else {
				str += "false";
			}
		}
		
		str += ",";
		var nullable = document.getElementById("nullable" + id);
		//对于系统默认只能是只读得项
		if(nullable){
			if(nullable.checked) {
				str += "true";
			}
			else {
				str += "false";
			}
		}else
			str += "true";
		
		if(i != lastList.size() - 1) {
			str += ":";
		}
	}
	document.getElementById("addString").value = str;	
}

	
//获取类别
function getCategory(obj) {
	var category = "";
	for(var i = 0; i < obj.options.length; i++) {
		if(obj.options[i].selected) {
			category = obj.options[i].value;
		}
	}
	if(category == null || category == "") {
		return ;
	}
	if(category == 'default') {
		document.getElementById("metaCategory").value = "";
		return ;
	}
	
	document.getElementById("metaCategory").value = category;   //更新选择的类别
}


/*--------------------------------------- 文档属性管理 Start --------------------------------------*/	

// 进入新建文档属性界面
function createDocProperty() {
	parent.bottom.location.href = managerURL + "?method=addDocPropertyPage";
}

// 新建一个文档属性
function addDocProperty() {	
	if(!checkForm(mainForm))
		return;
	var theName = mainForm.theName.value;
	var the_type = mainForm.meta_type.value;				//类型				
	var newCategory = mainForm.newCategory; //是否新建类别
	var addContent = mainForm.addContent;	
	var dvalue = mainForm.defaultValue.value;   //默認值
	if(theName != null && theName == mainForm.theName.deaultValue) {			
		alert(v3x.getMessage("DocLang.doc_property_alter_name_null"));
		return ;
	}
	if (newCategory[1].checked){
		if(mainForm.category_name.value == "") {
			alert(v3x.getMessage("DocLang.doc_property_alter_category_null"));
			return ;
		}else{
			// 判断类别名重复
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataDefManager",
				 "hasSameCategory", false);
			requestCaller.addParameter(1, "String", mainForm.category_name.value);			
			var flag = requestCaller.serviceRequest();
			if('true' == flag){
				alert(v3x.getMessage("DocLang.doc_property_category_exists"));
				return ;
			}
		}
	}	
	if(the_type == '13') {		//枚举类型
		var str = "";
		for(var i = 0; i < addContent.options.length; i++) {
			if(i != addContent.options.length - 1) {
				str += addContent.options[i].value;
				str += ",";
			}
			else {
				str += addContent.options[i].value;
			}
		}
		mainForm.theContent.value = str;
		if (str == "") {
			alert(v3x.getMessage("DocLang.doc_property_alter_input_option"));
			return ;
		}
	}
	
	if(the_type=='1'&&(dvalue.length>6)){   //文本型		
		alert(v3x.getMessage("DocLang.doc_default_value"));
		return;		
	}
	
	getA8Top().startProc();
	
	mainForm.target = "empty";
	mainForm.action = managerURL + "?method=addDocProperty";
	mainForm.submit();	
}

// 进入编辑文档属性界面
function editDocProperty(id,flag, isSystem, creater, used) {
	var aUrl = managerURL + "?method=editDocPropertyPage&flag=" + flag;
	var checkid = id;
	var ckbUsedFlag = 'false';
	var theSelId = '0';
	if (checkid == "undefined") {
		checkid = mainForm.id;
		if(typeof(checkid) !== 'object') {
			alert(v3x.getMessage("DocLang.doc_property_alter_not_select"));
			return ;
		}
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {
			if (!checkid.checked) {
				alert(v3x.getMessage("DocLang.doc_property_alter_not_select"));
				return ;
			}	
			else {
				var aId = mainForm.id.value;
				ckbUsedFlag = mainForm.id.usedFlag;
				aUrl += "&theId=" + aId;
				theSelId = aId;
			}			
		}
		else {
			var j = 0;
			for (i = 0; i <len; i++) {
				if (checkid[i].checked == true) {
					aUrl += "&theId=" + checkid[i].value;
					ckbUsedFlag = checkid[i].usedFlag;
					theSelId = checkid[i].value;
					j++;
				}
			}
			if (j == 0) {
				alert(v3x.getMessage("DocLang.doc_property_alter_not_select"));
				return ;
			}
			else if (j > 1){
				alert(v3x.getMessage("DocLang.doc_property_alter_select_one"));
				return ;
			}
		}
	}
	else {
		aUrl += "&theId=" + id;
		theSelId = id;
	}
	
//	var usedFlag = 'false';
//	if(used)
//		usedFlag = used;
//	else
//		usedFlag = ckbUsedFlag;

	// 取得是否使用标记
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataDefManager",
		 "getUsedFlagOfDef", false);
	requestCaller.addParameter(1, "Long", theSelId);
			
	var usedFlag = requestCaller.serviceRequest();
	
	if(isSystem == 'true' && flag == 'edit'){
		alert(v3x.getMessage("DocLang.doc_property_edit_system"));
	}else if(creater == 'false' && flag == 'edit'){
		alert(v3x.getMessage("DocLang.doc_property_edit_no_acl"));
//		parent.bottom.location.href = viewUrl;
	}else if(usedFlag == 'true' && flag == 'edit'){
		alert(v3x.getMessage("DocLang.doc_property_edit_used"));
	}else
		parent.bottom.location.href = aUrl;

}


// 修改文档属性
function updateDocProperty() {	
	if(!checkForm(mainForm)) {
		return;
	}
	var metadataId = mainForm.metadataId.value;
	var theName = mainForm.theName.value;
	var the_type = mainForm.type.value;
	var addContent = mainForm.addContent;
	var newCategory = mainForm.newCategory; //是否新建类别
	if(theName != null && theName == mainForm.theName.deaultValue) {			
		alert(v3x.getMessage("DocLang.doc_property_alter_name_null"));
		return ;
	}
	if (newCategory[1].checked){
		if(mainForm.category_name.value == "") {
			alert(v3x.getMessage("DocLang.doc_property_alter_category_null"));
			return ;
		}else{
			// 判断类别名重复
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataDefManager",
				 "hasSameCategory", false);
			requestCaller.addParameter(1, "String", mainForm.category_name.value);			
			var flag = requestCaller.serviceRequest();
			if('true' == flag){
				alert(v3x.getMessage("DocLang.doc_property_category_exists"));
				return ;
			}
		}
	}	
	if(the_type == '13') {		//枚举类型
		var str = "";
		for(var i = 0; i < addContent.options.length; i++) {
			if(i != addContent.options.length - 1) {
				str += addContent.options[i].value;
				str += ",";
			}
			else {
				str += addContent.options[i].value;
			}
		}
		mainForm.theContent.value = str;
		if (str == "") {
			alert(v3x.getMessage("DocLang.doc_property_alter_input_option"));
			return ;
		}
	}
	
	//
	document.getElementById("b1").disabled = true;
	document.getElementById("b2").disabled = true;
	
	getA8Top().startProc();
	
	mainForm.target = "empty";
	mainForm.action = managerURL + "?method=updateDocProperty&metadataId=" + metadataId;
	mainForm.submit();	
}

// 删除文档属性
function deleteDocProperty() {
	var theId = document.getElementsByName("id");
	var theForm = document.getElementById("theForm");
	var temp = 0;
	var bool = "";
	var str = "";
	for(var i = 0; i < theId.length; i++) {
		if(theId[i].checked) {
			str += theId[i].value;
			str += ",";
			temp = temp + 1;
			if(theId[i].isSystem == 'true') {
				bool = "true";
				break;
			}			
		}
	}
	
	if(temp == 0) {
		alert(v3x.getMessage("DocLang.doc_property_alter_select_deleted"));
		return ;
	}
	if(bool == "true") {
		alert(v3x.getMessage("DocLang.doc_property_alter_delete_system_type_disabled"));
		return ;
	}

	if(window.confirm(v3x.getMessage("DocLang.doc_property_alter_delete_confirm"))) {
		getA8Top().startProc();
		
		str = str.substring(0, str.length - 1);
		mainForm.target = "mainFrame";
		mainForm.action = managerURL + "?method=deleteDocProperty&deleteId=" + str;
		mainForm.submit();
	}
}
	
	
// 更改文档属性类型
function changeType(obj) {
	var value = obj.options[obj.options.selectedIndex].value;
	var _defaultValue = document.getElementById("defaultValue"); // 默认值
	var _defaultValue_int = document.getElementById("defaultValue_int"); // 默认值
	var _defaultValue_decimal = document.getElementById("defaultValue_decimal"); // 默认值
	//var _nullable = document.getElementById("nullable"); // 是否允许为空
	var _datetime = document.getElementById("datetime"); // 日期时间	
	var _yesOrNo = document.getElementById("yesOrNo"); // 是|否
	var _list = document.getElementById("list"); //枚举
	var _number = document.getElementById("number"); // 数字
			document.getElementById("defaultValue_int_input").value = "";
		document.getElementById("defaultValue_decimal_input").value = "";
	if (value == 1) { // 单行文本
		_defaultValue.style.display = "";
		_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "none";
		//_nullable.style.display = "";
		_datetime.style.display = "none";
		_number.style.display = "none";
		_yesOrNo.style.display = "none";
		_list.style.display = "none";
	}
	else if (value == 6) { // 多行文本
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "none";
		//_nullable.style.display = "";
		_datetime.style.display = "none";
		_number.style.display = "none";
		_yesOrNo.style.display = "none";
		_list.style.display = "none";
	}
	else if (value == 2 ) { // 数字(整數)
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "";
		_defaultValue_decimal.style.display = "none";;
		//_nullable.style.display = "";
		_datetime.style.display = "none";
		_number.style.display = "";
		_yesOrNo.style.display = "none";
		_list.style.display = "none";
	}
	else if (value == 3) { // 数字（小數）
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "";
		//_nullable.style.display = "";
		_datetime.style.display = "none";
		_number.style.display = "";
		_yesOrNo.style.display = "none";
		_list.style.display = "none";
	}
	else if (value == 4 || value == 5) { // 日期时间		
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "none";
		//_nullable.style.display = "";
		_datetime.style.display = "";
		_number.style.display = "none";
		_yesOrNo.style.display = "none";
		_list.style.display = "none";
	}
	else if (value == 7) { // 是|否
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "none";
		//_nullable.style.display = "none";
		_datetime.style.display = "none";
		_number.style.display = "none";
		_yesOrNo.style.display = "";
		_list.style.display = "none";
	}
	else if (value == 13) { //枚举类型
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "none";
		_datetime.style.display = "none";
		_number.style.display = "none";
		_yesOrNo.style.display = "none";
		_list.style.display = "";
	}
	else if (value == 8 || value == 9) { //用户或部门
		_defaultValue.style.display = "none";
				_defaultValue_int.style.display = "none";
		_defaultValue_decimal.style.display = "none";
		//_nullable.style.display = "";
		_datetime.style.display = "none";
		_number.style.display = "none";
		_yesOrNo.style.display = "none";
		_list.style.display = "none";
	}
}
	
//添加列表选项
function addOption() {
	var enumE = document.getElementById("enmuName");
	if(!notNull(enumE))
		return;
	//临时加 特殊字符限制
	enumE.setAttribute("validate", "isWord");
	if(!isWord(enumE)) {
		enumE.removeAttribute("validate");
		return;
	}
	var enmuName = enumE.value;
	var addContent = document.getElementById("addContent");
	
	if(enmuName == null || enmuName == "") {
		return ;
	}
	var option= new Option(enmuName, enmuName);
	//设置title属性
	option.title=enmuName;
	addContent.options[addContent.options.length] = option;
	document.getElementById("enmuName").value = "";
}

// 添加列表选项	
function removeOption() {
	var addContent = document.getElementById("addContent");
	
	if(addContent.options.length == 0) {
		return ;
	}
	var j=0;	
	for(var i = 0; i < addContent.options.length; i++) {
		if(addContent.options[i].selected) {
			j++;
			addContent.options.remove(i);
			i--;
		}
	}
	if (j==0){
		alert(v3x.getMessage("DocLang.doc_property_alter_remove_option_no_select"));
	}
}

function changeCategory() {
	if (document.all.newCategory[1].checked==true){
		document.all.meta_category.disabled = true;
		document.all.category_name.disabled = false;
	}
	else {
		document.all.meta_category.disabled = false;
		document.all.category_name.disabled = true;
	}
}
var aArrayDefault = [];
function saveDefaultValue(){
	for(var i=0;i<arguments.length;i++){
		var oTemp = document.getElementById(arguments[i]);
		if(oTemp!=null){
			aArrayDefault[aArrayDefault.length] = oTemp.value;
		}else{
			return;
		}
	}
}
function checkDefaultValue(){
	var flag = false;
	for(var i=0;i<arguments.length;i++){
		var oTemp = document.getElementById(arguments[i]);
		if(oTemp!=null){
			if(oTemp.value!=aArrayDefault[i]){
				flag = true;
			}
		}
	}
	if(flag){
		if(confirm(v3x.getMessage("DocLang.docType_add_edit_save_or_no"))){
			addDocLib();
		}
	}else{
		return true;
	}
}
function viewDocLibs(status) {
	window.location.href = managerURL + "?method=docLibTopFrame&status=" + status;
}
function disableDocLibs() {
	var ids = getSelectId(v3x.getMessage("DocLang.pls_select_doc_libs_to_disable"));
	if(ids == false || !window.confirm(v3x.getMessage("DocLang.doc_lib_disable_confirm")))
		return;
	window.location.href = managerURL + "?method=disableDocLibs&docLibIds=" + ids;
}
function enableDocLibs() {
	var ids = getSelectId(v3x.getMessage("DocLang.pls_select_doc_libs_to_enable"));
	if(ids == false || !window.confirm(v3x.getMessage("DocLang.doc_lib_enable_confirm")))
		return;
	window.location.href = managerURL + "?method=enableDocLibs&docLibIds=" + ids;
}
/**
 * 完成文档查询条件设置修改
 */
function modifyDocSearchConfig(docLibId,docLibType) {
	var str = "";
	var strName="";
	var _temp = mainForm.checkin.length;
	
	if(_temp == 0) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_select_search_condition"));
		return ;
	}else if(docLibType == '3'){
		if(_temp > 20){
			alert(v3x.getMessage("DocLang.doc_lib_alter_select_search_condition_too_more",20));
			return ;
		}
	}else if(_temp > 8) {
		alert(v3x.getMessage("DocLang.doc_lib_alter_select_search_condition_too_more", 8));
		return ;
	}
	if(v3x.getBrowserFlag('openWindow') == true){
		document.getElementById("b1").disabled = true;
		document.getElementById("b2").disabled = true;
	}

	var newIds = "";
	for(var i = 0; i <_temp; i++) {
		if(i != _temp - 1) {
			newIds += (mainForm.checkin.options[i].value + ',');
			strName += (mainForm.checkin.options[i].text + ',');
		}
		else {
			newIds += mainForm.checkin.options[i].value;
			strName += mainForm.checkin.options[i].text;
		}
	}
	
	var hiddenInput = document.getElementById("columnIds");
	hiddenInput.innerHTML = "<input type='hidden' name=selectedSearchConditions id=selectedSearchConditions value='" + newIds + "' />";
	document.getElementById("columnName").innerHTML="<input type='hidden' name=choiceName id=choiceName value='" + strName + "' />"
	mainForm.action = managerURL + "?method=updateDocSearchConditions";
	mainForm.target = "empty";
	mainForm.submit();
}
/**
 * 将选定的文档库查询条件设置恢复为默认值
 */
function setDocSearchConfigDefault(docLibId) {
	getA8Top().startProc();
	var requestCaller = new XMLHttpRequestCaller(this, "docLibManager", "setSearchConditions2Default", false);
	requestCaller.addParameter(1, "Long", docLibId);
	var columnNames = requestCaller.serviceRequest();

	if(arguments.length == 2 && arguments[1] && arguments[1] == 'Menu') {
		alert(v3x.getMessage("DocLang.doc_lib_searchcondition_default_success"));
		window.location.reload(true);
	} else {
		var str="<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">";
		for(var i = 0; i < columnNames.length; i++){
			str+="<tr height=\"18\"><td width=\"30%\" nowrap align=\"left\" valign=\"top\">&nbsp;&nbsp;&nbsp;"+columnNames[i]+"</td></tr>";
		}
		str+="</table>";
		document.getElementById("searchConditionTable").innerHTML=str;
		document.getElementById("listSearchConfigDefault").style.display = "none";
	}
	
	getA8Top().endProc();
}
/**
 * 进入文档库查询条件设置页面
 */
var winSearchCondition;
function setDocSearchConfig(docLibId) {
	var surl = managerURL + "?method=setDocSearchConditions&docLibId=" + docLibId;
	if(v3x.getBrowserFlag('openWindow') == false){
	winSearchCondition = v3x.openDialog({
		id : "searchCondition",
		title : "",
		url : surl,
		width : 500,
		height : 400,
		//type : 'panel',
		buttons : [{
			id:'btn1',
    	    text: v3x.getMessage("DocLang.submit"),
    	    handler: function(){
	    	   	winSearchCondition.getReturnValue();
	        }
		}, {
    		id:'btn2',
    	    text: v3x.getMessage("DocLang.cancel"),
    	    handler: function(){
    	    	winSearchCondition.close();
    	    }
		}]
	
	});
	} else {
	var returnValue = v3x.openWindow({
		url : surl,
		width : "500",
		height : "400",
		resizable : "false"
	});
	
	if(arguments.length == 2 && arguments[1] && arguments[1] == 'Menu') {
		window.location.reload(true);
		return;
	}

	if(returnValue != null && returnValue != undefined){
		var tempValue = returnValue.split(",");
		var str="<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">";
		for(var i=0; i<tempValue.length; i++){
			str += "<tr height=\"18\"><td width=\"30%\" nowrap align=\"left\" valign=\"top\">&nbsp;&nbsp;&nbsp;" + tempValue[i] + "</td></tr>";
		}
		str += "</table>";
		
		document.getElementById("searchConditionTable").innerHTML = str;
		document.getElementById("listSearchConfigDefault").style.display = "block";
	}
	}
}

function changeValue(element) {
	element.value = element.checked == true ? 1 : 0;
}

function setPeopleFields(elements) {
	if(!elements) {
		return;
	}
	document.getElementById("docManager").value = getNamesString(elements);
	document.getElementById("docManager").title = getNamesString(elements);
	var theid = getIdsString(elements, false);
	document.getElementById("memberId").innerHTML = "<input type=hidden id=members name=members value=" + theid + " />"
}

var pTemp = {};

function fnQuery(){
	var searchTxt = document.getElementById("searchTxt");
	var checkout = document.getElementById("checkout");
	if(!pTemp.options){//初始化一次
		pTemp.options = [];
		for(var i=0; i < checkout.options.length ;i++){
			var opt = new Option(checkout.options[i].text,checkout.options[i].value);
			pTemp.options.push(opt);
		}
	}
	//清空所有选项
	checkout.options.length = 0;
	for(var i=0; i < pTemp.options.length ;i++){
		var optTxt = pTemp.options[i].text;
		if(optTxt.indexOf(searchTxt.value)!=-1){
			checkout.options.add(pTemp.options[i]);
		}
	}
}

/*--------------------------------------- 文档属性管理 End --------------------------------------*/	