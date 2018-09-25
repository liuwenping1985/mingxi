//隐藏树结构
function toggleContents(display) {
  if (display) { 
    parent.document.getElementById("treeandlist").cols = "20%,*";
  } else {
    parent.document.getElementById("treeandlist").cols = "0,*";
  }
}

//得到选中的checkbox
function getSelectIds(frame, notShowMe){
	var ids = frame.document.getElementsByName('id');
	var id = '';
	var names = '';
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			if(notShowMe){
				if(idCheckBox.getAttribute('value') == currentUserId) continue;
			}
			if(id == ''){
				id = idCheckBox.getAttribute('value');
				names = idCheckBox.getAttribute('userName');
			}else{
				id += ',' + idCheckBox.getAttribute('value');
				names += '、' + idCheckBox.getAttribute('userName');
			}
		}
	}
	return [id, names];
}

/**
 * 发送消息
 */
function sendMessageForAddress(){
	var result = getSelectIds(this, true);
	receiveIds = result[0];
	receiveNames = result[1];
	sendMessageForCard(true, "");
}

//发送Email
function sendMail(mail) {
	if(mail!=""){
	    var url = addressbookURL+"?method=sendMail&mailAdd="+mail;
        openCtpWindow({'url':url});
	}else{
		alert("没有电子邮件！无法发送！");
		return;
	}
}

//发送短信
function sendSMS(){
	var receiverIds = getSelectIds(this, false);
	sendSMSV3X(receiverIds[0]);
}
	//给私人通讯录发送短信
	function sendSMSByPhoneNum(){
		var phones = document.getElementsByName('id');
		var mobilePhoneStr = '';
		var recNamesStr = '';
		var count = 0;
		for(var i=0;i<phones.length;i++){
			var idCheckBox=phones[i];
			if(idCheckBox.checked){
				count++;
				if(idCheckBox.getAttribute('mobilePhone')!=""){
					if(mobilePhoneStr == ''){
						mobilePhoneStr = idCheckBox.getAttribute('mobilePhone');
						recNamesStr  = idCheckBox.getAttribute('nameStr');
					}
					else{
						mobilePhoneStr += ',' + idCheckBox.getAttribute('mobilePhone');
						recNamesStr  += ',' + idCheckBox.getAttribute('nameStr');
					}
				}
			}
		}
		if(count == 0){			
			alert(v3x.getMessage("ADDRESSBOOKLang.alert_noSelectMember"));
			return;
		}
		if(mobilePhoneStr == ''){
			alert(v3x.getMessage("ADDRESSBOOKLang.alert_noPhoneMember"));
			return;
		}
		var linkURL = getBaseURL() + "/message.do?method=showSendPersonalSMSDlg&phoneMembers="+ mobilePhoneStr + "&names=" + encodeURIComponent(recNamesStr);
		
		if (getA8Top().isCtpTop) {
			getA8Top().senSmsWin = getA8Top().$.dialog({
		        title:"发送短信",
		        transParams:{'parentWin':window},
		        url: linkURL,
		        width: 420,
		        height: 240,
		        isDrag:false
		    });
		} else {
			getA8Top().senSmsWin = v3x.openDialog({
		        title:"发送短信",
		        transParams:{'parentWin':window},
		        url: linkURL,
		        width: 420,
		        height: 240,
		        isDrag:false
		    });
		}
	}

//新建联系人	
var member_add_win;
function newMember() {
	getA8Top().newMemberWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: addressbookURL+"?method=viewMember&addressbookType=2&tId="+parent.treeFrame.document.getElementById("tId").value,
        width: 680,
        height: 490,
        isDrag:false
    });
}

function newMemberCollBack (returnValue) {
	getA8Top().newMemberWin.close();
	if (returnValue) {
		parent.listFrame.location.href=parent.listFrame.location.href;
	}
}

//新建联系组
var category_add_win;
function newCategory() {
	getA8Top().newCategoryWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: addressbookURL+"?method=viewOwnTeam&addressbookType=2",
        width: 350,
        height: 280,
        isDrag:false
    });
}


function newCategoryCollBack (returnValue) {
	getA8Top().newCategoryWin.close();
	parent.treeFrame.location.reload();
}
//删除联系组、联系人
function removeEntity(){
	var selectedMember = getSelectIds(parent.listFrame)[0];
	if(selectedMember!=''){
		var mIds = getSelectIds(parent.listFrame)[0];
		if (!mIds || mIds == '') {
			alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_add_team_members_message"));
			return false;
		}
		if(!confirm(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_destroy_member_confirm_message"))){
			return false;
		}
		parent.listFrame.location.href = addressbookURL+"?method=destroyMember&addressbookType=2&mIds="+mIds;
	}else{
		if (parent.treeFrame.document.getElementById("tId").value == -1) {
			alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_remove_choose_message", v3x.getMessage("ADDRESSBOOKLang.addressbook_zu_label")));
			return false;
		}
		if(!confirm(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_destroy_category_confirm_message"))){
			return false;
		}
		parent.treeFrame.location.href = addressbookURL+"?method=destroyOwnTeam&addressbookType=2&tId="+parent.treeFrame.document.getElementById("tId").value;
	}
}
	
//修改联系组
var category_modify_win;
function modifyCategory(){
  if (parent.treeFrame.document.getElementById("tId") != null) {
	if (parent.treeFrame.document.getElementById("tId").value == -1) {
		alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_modify_choose_message", v3x.getMessage("ADDRESSBOOKLang.addressbook_zu_label")));
		return false;
	}
	getA8Top().newCategoryWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: addressbookURL+"?method=viewOwnTeam&addressbookType=2&tId="+parent.treeFrame.document.getElementById("tId").value,
        width: 350,
        height: 280,
        isDrag:false
    });
  }
}

//新建个人组
var ownteam_add_win;
function newOwnTeam() {
	getA8Top().newCategoryWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: addressbookURL+"?method=viewOwnTeam&addressbookType=1",
        width: 450,
        height: 350,
        isDrag:false
    });
}

//修改个人组
var ownteam_modify_win;
function modifyOwnTeam(){
	if (parent.treeFrame.document.getElementById("tId") != null) {
		if(parent.treeFrame.document.getElementById("tId").value == -1){
			alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_modify_choose_message", v3x.getMessage("ADDRESSBOOKLang.addressbook_form_ownteam")));
			return false;
		}
		getA8Top().newCategoryWin = v3x.openDialog({
	        title:" ",
	        transParams:{'parentWin':window},
	        url: addressbookURL+"?method=viewOwnTeam&addressbookType=1&tId="+parent.treeFrame.document.getElementById("tId").value,
	        width: 450,
	        height: 350,
	        isDrag:false
	    });
	}
}

//解散个人组
function removeOwnTeam() {
	if (parent.treeFrame.document.getElementById("tId") != null) {
		if(parent.treeFrame.document.getElementById("tId").value == -1){
			alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_destroy_choose_message"));
			return false;
		}
		if(!confirm(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_destroy_ownteam_confirm_message"))){
			return false;
		}
		parent.treeFrame.location.href = addressbookURL+"?method=destroyOwnTeam&addressbookType=4&tId="+parent.treeFrame.document.getElementById("tId").value;
	}
}

/**
 * 导出（excel/csv）。依赖/common/js/util/URI.js中的getUriParam()及processUriParam()
 * @param exportType 导出类型：excel/csv
 */
function exportAs(exportType,accountId,deptId,addressbookType) {
	var pageFrame = window;
	var exportFrame = theLogIframe;
	var pageUri = pageFrame.location.href;
	var pageMethod = getUriParam(pageUri, "method");
	var exportUri = pageUri;
	exportUri = processUriParam(exportUri, "method", "export");
	exportUri = processUriParam(exportUri, "exportType", exportType);
	exportUri = processUriParam(exportUri, "pageMethod", pageMethod);
	exportUri = processUriParam(exportUri, "exp_accountId", accountId);
	exportUri = processUriParam(exportUri, "exp_deptId", deptId);
	exportUri = processUriParam(exportUri, "exp_addressbookType", addressbookType);
	exportFrame.location.href = exportUri;
}

//导出EXCEL
function download(accountId,deptId,addressbookType) {
	exportAs("excel",accountId,deptId,addressbookType);
/*
	var click  = document.getElementById("click").value;
	var deptId  = document.getElementById("deptId").value;
	var otId  = document.getElementById("otId").value;
	var sysId  = document.getElementById("sysId").value;
	var mem = document.getElementById("mem").value;
	theLogIframe.location.href= hrefDownload+"&type="+paramAddressbookType+"&condition="+paramCondition+"&textfield="+encodeURI(paramTextfield)+"&click="+click+"&deptId="+deptId+"&otId="+otId+"&sysId="+sysId+"&mem="+mem+"&accountId="+accountIdDownload;
*/
}

//导出vCARD
function savevCard(type,accountId,deptId,addressbookType) {
	var mId = getSelectId(this);
	if(mId && mId !=''){
		theLogIframe.location.href= addressbookURL+"?method=vcard&addressbookType="+type+"&memberId="+mId+"&exp_accountId="+accountId+"&exp_deptId="+deptId;
	}
}

//导出vCARD得到选中的checkbox
function getSelectId(frame, notShowMe){
	var ids = frame.document.getElementsByName('id');
	var id = '';
	var num = 0;
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id = idCheckBox.value;
			num += 1;
		}
	}
	if(num == 0 ){
		alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_vcard_export_least_one"));
		return '';
	}else if(num > 1){
		alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_vcard_export_many_forbidden"));
		return '';
	}
	return id;
}

//导出CSV
function saveCsv(type,accountId,deptId,addressbookType){
	exportAs("csv",accountId,deptId,addressbookType);
/*
	var click = document.getElementById("click").value;
	var deptId = document.getElementById("deptId").value;
	var otId = document.getElementById("otId").value;
	var mem = document.getElementById("mem").value;
	document.getElementById("mem").value="";
	parent.treeFrame.location.href = addressbookURL+"?method=csvExport&condition="+paramCondition+"&click="+click+"&accountId="+accountId+"&textfield="+encodeURI(paramTextfield)+"&type="+type+"&deptId="+deptId+"&otId="+otId+"&mem="+mem;
*/
}

//打印
function print() {
	try{
	   //document.getElementById('hTablememberlist').childNodes[0].childNodes[0].childNodes[0].style.background = '#ffffff';
	   var aa= "";
	   var mm = parent.listFrame.memberform.innerHTML;
	   mm = mm.replace(/onmouseover=/g,"")
	   mm = mm.replace(/onmouseout=/g,"")
	   mm = mm.replace(/div-float/g,"")
	   mm = mm.replace(/<INPUT.*?checkbox.*?>/gi,"")
	   mm = mm.replace(/<TFOOT>[\s\S]*<\/TFOOT>/gi,"")
	   var list1 = new PrintFragment(aa,mm);
	   var tlist = new ArrayList();
	   tlist.add(list1);
	   var cssList=new ArrayList();
	   if(skinCss){
	   	   cssList.add(skinCss);
	   }
	   cssList.add(v3x.baseURL + "/apps_res/addressbook/css/default.css");
	   printList(tlist,cssList);
	   //document.getElementById('hTablememberlist').childNodes[0].childNodes[0].childNodes[0].style.background = 'url('+v3x.baseURL +'/apps_res/addressbook/images/table_head_bg.gif) repeat-x bottom';
	}catch(e){
	    alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_print_label")+e.getMessage());
	    parent.listFrame.location.reload();
	}
}

//视图切换
function change(){
	var obj = parent.document.getElementById("treeandlist");
	if(obj == null){
		return;
	}
	if(parent.document.getElementById("listFrame").getAttribute("test")!="test"){
		parent.document.getElementById("treeandlist").removeAttribute("cols");
		parent.document.getElementById("treeandlist").setAttribute("rows", "*");
		parent.document.getElementById("treeandlist").removeAttribute("rows");
		parent.document.getElementById("treeandlist").setAttribute("cols", "0,*");
		//parent.document.getElementById("treeandlist").cols="0,*";
		//parent.document.frames["listFrame"].location.reload();
		parent.document.getElementById("listFrame").setAttribute("src",parent.document.getElementById("listFrame").src);
		parent.document.getElementById("listFrame").setAttribute("test","test");
		//flag = 1;
	}else{
		parent.document.getElementById("treeandlist").removeAttribute("cols");
		parent.document.getElementById("treeandlist").setAttribute("rows", "*");
		parent.document.getElementById("treeandlist").removeAttribute("rows");
		parent.document.getElementById("treeandlist").setAttribute("cols", "20%,*");
		//parent.document.getElementById("treeandlist").cols="20%,*";
		parent.document.getElementById("listFrame").setAttribute("test","");
		//flag = 0;
	}
}

//设置职务级别
function setLevel(elements){
    if (!elements) {
        return;
    }
    document.getElementById("level_name").value = getNamesString(elements);
    document.getElementById("orgLevelId").value = getIdsString(elements,false);
}

//查询
function search(type){
	var condition = document.getElementById("condition").value;
	var textfield = "";
	if(condition == 'subject'){
		return false;
	}else if(condition == 'name'){
		textfield = document.getElementById("name").value;
	}else if(condition == 'tel'){
		textfield = document.getElementById("tel").value;
	}else if(condition == 'level'){
		if(type != 2){
			textfield = document.getElementById("level_id").value;
		}else{
			textfield = document.getElementById("level_name").value;
		}
	}
	if(textfield == '' || textfield == null){
		alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_search_no_content"));
		return false;
	}
	var deptId  = document.getElementById("deptIds").value;
	if(!deptId){
		 deptId = document.getElementById("deptId").value;
	}
	parent.listFrame.location.href = addressbookURL+"?method=search&addressbookType="+type+"&textfield="+encodeURI(textfield.trim())+"&condition="+condition+"&accountId="+accountIdSearch+"&click=dept&mem=all&deptId="+deptId;
}
function sonDepartmentMembers(formId,flag){
	var isDepartment="0";
	if(flag){
		isDepartment="1";
	}
	parent.isDepartment = isDepartment;
	var searchForm = document.getElementById(formId);
	var et = searchForm.expressionType.value;
	var ev;
	if (et === "") {
		ev = "";
	} else {
		ev = searchForm.elements[et2itMap[et]].value;
		//if (ev === "") {
		//	alert(_("V3XLang.index_input_error"));
		//	return;
		//}
	}
	var newUri = windowToLoad.location.href;
	newUri = processUriParam(newUri, expressionTypeParamName,  et);
	newUri = processUriParam(newUri, expressionValueParamName, ev);
	if(newUri.indexOf('isDepartment')>-1){
		newUri=newUri.replace('&isDepartment=0','');
		newUri=newUri.replace('&isDepartment=1','');
		windowToLoad.location.href = newUri+"&isDepartment="+isDepartment;
	}else{
		windowToLoad.location.href = newUri+"&isDepartment="+isDepartment;
	}
}






