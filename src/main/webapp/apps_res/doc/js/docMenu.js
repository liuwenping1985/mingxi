/**
 * 该文件用于生成文档操作菜单。
 * @Author: 薛国伟
 * @Date: 2007年4月1日
 */

var i = 0;

var contextPath = "";

function DocResource(docResId, docResName, parentFrId, isFolder, isFile, isLink, 
	isLocked, lockedUserId, isPig, isFolderLink, 
	isLearningDoc, appEnumKey, isSysInit, mimeType, frType, versionEnabled, recommendEnabled) {
	
	this.docResId = docResId;
	this.docResName = docResName;
	this.parentFrId = parentFrId;
	this.isFolder = isFolder;
	this.isFile = isFile;
//	if(isLink == 'true' || isFolderLink == 'true')
//		this.isLink = 'true';
//	else
//		this.isLink = 'false';
	this.isLink = isLink;
	this.isFolderLink = isFolderLink;

	this.isLocked = isLocked;
	this.lockedUserId = lockedUserId;
	this.isPig = isPig; // if it is an archived document,such as info,edoc,news,bulletin,...
	this.isLearningDoc = isLearningDoc;
	
	this.appEnumKey = appEnumKey;
	this.frType = frType;
	
	this.isSysInit = isSysInit;
	if(arguments[13]!=null){
		this.mimeType = arguments[13];
	}
	if(arguments[14]!=null)
		this.versionEnabled = arguments[14];
	if(arguments[15]!=null)
		this.recommendEnabled = arguments[15];
}

var allAcl1 = "false";
var editAcl1 = "false";
var addAcl1 = "false";
var readonlyAcl1 = "false";
var browseAcl1 = "false";
var listAcl1 = "false";
function DocAcl(all, edit, write, readonly, browse, list,isCreater,lenPotent) {
	allAcl1 = this.all = all;
	editAcl1 = this.edit = edit;
	addAcl1 = this.write = write;
	readonlyAcl1 = this.readonly = readonly;
	browseAcl1 = this.browse = browse;
	listAcl1 = this.list = list;
	this.lenPotent=lenPotent;
	this.isCreater = isCreater;
}

/**
 * 主函数。
 */
function RightMenu(_contextPath) {
	contextPath = _contextPath || "";
	this.AddExtendMenu = AddExtendMenu;
	this.AddItem = AddItem;
	this.GetMenu = GetMenu;
	this.HideAll = HideAll;
	this.I_OnMouseOver = I_OnMouseOver;
	this.I_OnMouseOut = I_OnMouseOut;
	this.I_OnMouseUp = I_OnMouseUp;
	this.P_OnMouseOver = P_OnMouseOver;
	this.P_OnMouseOut = P_OnMouseOut;

	A_rbpm = new Array();
	HTMLstr  = "";
	HTMLstr += "<!-- RightButton PopMenu -->\n";
	HTMLstr += "\n";
	HTMLstr += "<!-- PopMenu Starts -->\n";
	HTMLstr += "<div id='E_rbpm' class='rm_div'>\n";
		// rbpm = right button pop menu
	HTMLstr += "<table width='100' border='0' cellspacing='0' id='docMenuTable' ";
	HTMLstr += "style='background-repeat: repeat-y;'";
	HTMLstr += ">";
	HTMLstr += "<!-- Insert A Extend Menu or Item On Here For E_rbpm -->\n";
	HTMLstr += "</table>\n";
	HTMLstr += "</div>\n";
	HTMLstr += "<!-- Insert A Extend_Menu Area on Here For E_rbpm -->";
	HTMLstr += "\n";
	HTMLstr += "<!-- PopMenu Ends -->\n";
} 

/**
 * 增加子菜单项。
 * popup为true，按钮事件从parent中取，一般情况不需要这个参数，用于createPopup时。
 */
function AddExtendMenu(id, name, icon, parent, popup) {
	var TempStr = "";
	if(HTMLstr.indexOf("<!-- Extend Menu Area : E_" + id + " -->") != -1)
	{
		alert("E_" + id + "already exist!");
		return;
	}
	eval("A_" + parent + ".length++");
	eval("A_" + parent + "[A_" + parent + ".length-1] = id");  // 将此项注册到父菜单项的ID数组中去
	TempStr += "<!-- Extend Menu Area : E_" + id + " -->\n";
	TempStr += "<div id='E_" + id + "' class='rm_div'>\n";
	TempStr += "<table width='100%' border='0' cellspacing='0' ";
	TempStr += "style='background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_items_bg.gif);background-repeat: repeat-y;'";
	TempStr += ">\n";
	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + id + " -->";
	TempStr += "</table>\n";
	TempStr += "</div>\n";
	TempStr += "<!-- Insert A Extend_Menu Area on Here For E_" + id + " -->";
	TempStr += "<!-- Insert A Extend_Menu Area on Here For E_" + parent + " -->";
	HTMLstr = HTMLstr.replace("<!-- Insert A Extend_Menu Area on Here For E_" + parent + " -->", TempStr);

	eval("A_" + id + " = new Array()");
	TempStr  = "";
	TempStr += "<!-- Extend Item : P_" + id + " -->\n";

	var style1 = "padding:2px 4px 0px " + (icon ? "0" : "24") + "px;";
	var styleOver = style1 + "background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_select_bg.gif);background-position: center center;background-repeat: repeat-x;";

	TempStr += "<tr id='P_" + id + "' style='cursor: hand;FONT-SIZE: 12px; height: 22px;' "		
		+ "onmouseup='window.v3x.getEvent().cancelBubble=true;' "
		+ "onclick='window.v3x.getEvent().cancelBubble=true;' "
	
	TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\";"
		if(popup){
			TempStr += "parent.P_OnMouseOver(\"" + id + "\",\"" + parent + "\");' "
		} else {
			TempStr += "P_OnMouseOver(\"" + id + "\",\"" + parent + "\");' "
		}
		TempStr += "onmouseout='this.style.cssText=\"" + style1 + "\";" 
		if(popup){
			TempStr += "parent.P_OnMouseOut(\"" + id + "\",\"" + parent + "\");' " + ">"
		} else {
			TempStr += "P_OnMouseOut(\"" + id + "\",\"" + parent + "\");' " + ">"
		}
		
		//icon坐标
		if(typeof(icon) == 'object'){
	        var y = parseInt(icon[0],10)-1;
	        var x = parseInt(icon[1],10)-1;
	        //var g =  contextPath + '/common/images/toolbar/toolbar.trip.gif';
			TempStr += "<div style='background-image: url(/seeyon/common/skin/default/images/xmenu/arrow.right.png);background-position: right center;background-repeat: no-repeat;' >"
				+ '<IMG src="'+contextPath+'/common/images/space.gif" style="margin-right: 6px;margin-left:6px;vertical-align: middle; BACKGROUND-POSITION: -'+ (x*16) +'px -' + (y*16) + 'px;" height=16; width=16; border=0; class="toolbar-button-icon" align="absmiddle">'
				+ name
				+ "</div>"
				+ "</td></tr>\n";
		}else{
			TempStr += "<div style='background-image: url(/seeyon/common/skin/default/images/xmenu/arrow.right.png);background-position: right center;background-repeat: no-repeat;'>"
				+ (icon ? "<img src='" + icon + "' border='0' height=16 style='margin-right: 6px;margin-left:6px;vertical-align: middle;'>" : "")
				+ name
				+ "</div>"
				+ "</td></tr>\n";
		}

	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";
	HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
}
/**
 * 增加菜单项。
 * popup为true，按钮事件从parent中取，一般情况不需要这个参数，用于createPopup时。
 */
function AddItem(id, name, icon, parent, location, flag, popup) {
	var TempStr = "";

	var ItemStr = "<!-- ITEM : I_" + id + i +" -->";
	if(id.indexOf("separator") != -1)
	{
	  TempStr += ItemStr + "\n";
	  TempStr += "<tr id='I_" + id + i + "' style='height:5px;' onclick='window.v3x.getEvent().cancelBubble=true;' onmouseup='window.v3x.getEvent().cancelBubble=true;'><td><hr></td></tr>";
	  TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";
	  HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
	  i++;
	  return;
	}
	if(HTMLstr.indexOf(ItemStr) != -1)
	{
	  alert("I_" + id + "already exist!");
	  return;
	}

	var style1 = "padding:2px 4px 0px " + (icon ? "0" : "24") + "px;";
	var styleOver = style1 + "background-image: url("+contextPath+"/common/skin/default/images/xmenu/toolbar_select_bg.gif);background-position: center center;background-repeat: repeat-x;";

	TempStr += ItemStr + "\n";
	TempStr += "<tr id='I_" + id + "' style='cursor: hand;FONT-SIZE: 12px; height: 22px;' "
	if(popup){
		//TempStr += "onclick='parent.window.v3x.getEvent().cancelBubble=true;' "
		TempStr += "onmouseover='parent.I_OnMouseOver(\"" + id + "\",\"" + parent + "\")' ";
		TempStr += "onmouseout='parent.I_OnMouseOut(\"" + id + "\")' ";
		if(location == null)
			TempStr += "onmouseup='parent.I_OnMouseUp(\"" + id + "\",\"" + parent + "\",null)' ";
		else
			TempStr += "onmouseup='parent.I_OnMouseUp(\"" + id + "\",\"" + parent + "\",\"" + location + "\",\"" + flag + "\")' ";
	} else { 
		TempStr += "onclick='window.v3x.getEvent().cancelBubble=true;' "
		TempStr += "onmouseover='I_OnMouseOver(\"" + id + "\",\"" + parent + "\")' ";
		TempStr += "onmouseout='I_OnMouseOut(\"" + id + "\")' ";
		if(location == null)
			TempStr += "onmouseup='I_OnMouseUp(\"" + id + "\",\"" + parent + "\",null)' ";
		else
			TempStr += "onmouseup='I_OnMouseUp(\"" + id + "\",\"" + parent + "\",\"" + location + "\",\"" + flag + "\")' ";
	}

	
	//icon坐标
	if(typeof(icon) == 'object'){
        var y = parseInt(icon[0],10)-1;
        var x = parseInt(icon[1],10)-1;
        //var g =  contextPath + '/common/images/toolbar/toolbar.trip.gif';
		TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\"' "
		+ "onmouseout='this.style.cssText=\"" + style1 + "\"' " + ">"
		+ '<IMG src="'+contextPath+'/common/images/space.gif" style="margin-right: 6px;margin-left:6px;vertical-align: middle; BACKGROUND-POSITION: -'+ (x*16) +'px -' + (y*16) + 'px;" height=16; width=16; border=0; class="toolbar-button-icon" align="absmiddle">'
		+ name 		
		+ "</td></tr>\n"
	}else{
		TempStr	+= "><td nowrap='nowrap' style=\"" + style1 + "\" " 
		+ "onmouseover='this.style.cssText=\"" + styleOver + "\"' "
		+ "onmouseout='this.style.cssText=\"" + style1 + "\"' " + ">"
		+ (icon ? "<img src='" + icon + "' border='0' height=16 style='margin-right: 6px;margin-left:6px;vertical-align: middle;'>" : "")
		+ name 		
		+ "</td></tr>\n"
	}
		
	TempStr += "<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->";

	HTMLstr = HTMLstr.replace("<!-- Insert A Extend Menu or Item On Here For E_" + parent + " -->", TempStr);
}
function GetMenu() {
	return HTMLstr;
}
function I_OnMouseOver(id, parent)
{
	var Item;
	if(parent != "rbpm")
	{
		var ParentItem;
		ParentItem = document.getElementById("P_" + parent);
	}
	Item = document.getElementById("I_" + id);
	HideAll(parent, 1);
}
function I_OnMouseOut(id)
{
	var Item;
	Item = document.getElementById("I_" + id);
}
function I_OnMouseUp(id, parent, location, flag) {
	var name = id;
	if(name == 'forward' || name == 'sendto')
		name = 'P_' + name;
	else
		name = "I_" + name;
	if(document.getElementById(name).isDisabled)
		return;
	
	var ParentMenu;
	var event = window.v3x.getEvent(); 
	if(event)
		cancelBubble = true;
	OnClick()
	ParentMenu = document.getElementById("E_" + parent);	
	ParentMenu.display = "none";

	var docMenuTable = document.getElementById("docMenuTable");	
	var rowid = docMenuTable.className;
	var entranceType = docMenuTable.entranceType;
	var isPig = docMenuTable.isPig;
	var mainForm = document.getElementById("mainForm");	
	var objname = mainForm.oname.value;
	var vForDocPropertyIframe = docMenuTable.vForDocPropertyIframe;
	var vForBorrow = docMenuTable.vForBorrow;
	var vForDocDownload = docMenuTable.vForDocDownload;

	var m = 0;

	var isFolder = mainForm.is_folder.value;
	var isPersonalLib = mainForm.isPersonalLib.value;
	var parentId = mainForm.parentId.value;
	var docLibId = mainForm.docLibId.value;
	var docLibType = mainForm.docLibType.value;
	
	var isGroupLib = window.isGroupLib;

	if(location == null)
	{
	  eval("Do_" + id + "()");
	}
	else
	{
		// 检查选中的记录是否存在
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExist", false);
		requestCaller.addParameter(1, "Long", rowid);
			
		var existFlag = requestCaller.serviceRequest();
		if(existFlag == 'false') {
			if(isFolder == 'true'){
				alert(v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
			}else{
				alert(v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
			}
			window.location.reload(true);
			return;
		}
		
		var surl = "";
		if(flag == "move") {		
			selectDestFolder(rowid, parentId, docLibId, docLibType, "move");
		}
		else if(flag == "del") {	
			delF(rowid, "self", isFolder);
		}
		else if(flag == "properties") {
			var propEditValue = document.getElementById("prop_edit_"+rowid).value;//eval("prop_edit_" + rowid);
			location+="&all="+allAcl1+"&edit="+editAcl1+"&add="+addAcl1+"&readonly="+readonlyAcl1+"&browse="+browseAcl1+"&list="+listAcl1+"&isPig="+isPig+"";
			var v;
			if(id === 'lend') {
				v = vForBorrow;
			} else {
				// 个人共享/公共库共享/属性都使用一个值
				v = vForDocPropertyIframe;
			}
			docProperties(location, rowid, isFolder, isPersonalLib, propEditValue, rowdata.all, window.frType,v);
		}
		else if(flag == "rename") {		
			surl = location + "&rowid=" + rowid;			
			rename(surl, isFolder, rowid);
		}
		else if(flag == "mygrant") {	
			surl = location + "&docResId=" + rowid;
			v3xOpenWindow(surl,v3x.getMessage('DocLang.doc_jsp_properties_title'));
		}
		else if(flag == "docgrant") {					
			surl = location + "&docResId=" + rowid;
			v3xOpenWindow(surl,v3x.getMessage('DocLang.doc_jsp_properties_title'));
		}	
		else if(flag == "link")	{
			selectDestFolder(rowid, parentId, docLibId, docLibType, "link");
		}
		else if(flag == "replace") {
			docReplace(rowid, rowdata.docLibType, rowdata.objName,parentId,rowdata.frType);
		}
		else if(flag == "logView") {
			logView(rowid,isFolder,objname);
		}
		else if (flag == "lock") {
			lockDoc(rowid);
		}
		else if (flag == "unlock") {
			unlockDoc(rowid, window.currentUserId);
		}
		else if (flag == "alert") {
			alertview(rowid, isFolder);
		}
		else if (flag == "favorite") {
			addMyFavorite(rowid);
		}
		else if (flag == "publish") {
			publishDoc(rowid);
		} 
		else if(id == "info") {
			sendToColl(location, rowid,entranceType);
		}
		else if (flag == "edit") {
			editDoc(rowid,objname);
		}
		else if(flag == "docHistory"){
			// 历史版本入口 
			entranceType = 10;
			docHistory(rowid, all, edit, add, readonly, browse, list, isShareAndBorrowRoot, docLibId, docLibType, objname,entranceType);
		}
		else if (id == "mail"){
			sendToMail(location, rowid);
		}
		else if (id == "deptDoc"){
			sendToDeptDoc(depAdminSize, 'pop')
		}
		else if (id == "learning"){
			readyToPersonalLearn('pop');
		}
		else if (id == "deptLearn"){
			sendToDeptLearn(depAdminSize, 'pop');
		}
		else if (id == "accountLearn"){
			sendToAccountLearn('pop');
		}				
		else if (id == "learnHistory"){
			learnHistoryView(rowid, isGroupLib);
		}	
		else if (id == "group"){
			sendToGroup(rowid);
		}	
		else if (id == "groupLearn"){
			sendToGroupLearn('pop');
		}else if(id == 'download'){
			menuDownload(rowid, objname,vForDocDownload);
		}  else if(id == 'sendToCollFromOpen'){
			sendToCollFromOpen(rowid,entranceType);
		} else if(id == 'sendToMailFromOpen'){
			sendToMailFromOpen(rowid);
		} else if(id == 'collect'){
			favorite_old('3', rowid, false,'3',0,true,true);
		}else if(id == 'uncollect'){
		    cancelFavorite_old('3', rowid, false,'3',0,true,'',true);
        }  else if(id == 'recommend'){
			doc_recommend_old(rowid,true);
		}  else if(id == 'openToZone'||id == 'openToZoneCancel'){
			openToSquare_old(rowid,isFolder);
		}else if(flag == 'secretLevel'){
			setDocSecretLevel(location,rowid);
		}    		
	}
}
function setDocSecretLevel(location,rowid){
	var surl = location + "&docResId=" + rowid;
	var result=v3x.openWindow({
		 url: surl,
		 width: 260,
     	 height: 190,
     	 resizable: "no"
	  });
	if(result == true || result == 'true'){
		window.location.reload(true);
	}
}
function menuDownload(rowid, objname,vForDownload){
	var isUploadFile = document.getElementById("isUploadFile_"+rowid).value;//eval("isUploadFile_" + rowid);
	ajaxRecordOptionLog(rowid,"downLoadFile");	
	if(isUploadFile == 'true'){
		var fileId = document.getElementById("sourceId_"+rowid).value;//eval("sourceId_" + rowid);
		var theDate = document.getElementById("createDate_"+rowid).value;//eval("createDate_" + rowid);
		empty.location.href="/seeyon/fileDownload.do?method=download&viewMode=download&fileId="+fileId+"&createDate="+theDate+"&filename=" + encodeURIComponent(objname)+"&v="+vForDownload;
	}else{
		top.startProc(v3x.getMessage("DocLang.doc_alert_compress_progesss"));
			
		// 压缩
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docDownloadCompress", true);
		requestCaller.addParameter(1, "long", rowid);
		
		var flag = 'false';
		this.invoke = function(ds) {
			flag = 'true';
			top.endProc();
			empty.location.href = "/seeyon/doc.do?method=docDownloadNew&id="+rowid;
		}
			
		requestCaller.serviceRequest();
	}
}


function sendToColl(location, rowid, entrance) {
	var appEnumKey = document.getElementById("appEnumKey_"+rowid).value;//eval("appEnumKey_" + rowid);
	var pigData = new appEnumData();
	if(appEnumKey == pigData.doc){
		var surl = location + "&docResId=" + rowid + "&docLibId=" + docLibId + "&entrance=" + entrance;
		parent.location.href = surl;
		getA8Top().showLeftNavigation();
	}else if(appEnumKey == pigData.collaboration || appEnumKey == pigData.form){
		//检查源协同是否存在
		//var existFlag = pigSourceExist(appEnumKey, rowid);
		var existFlag = pigSourceExistById(rowid,appEnumKey);
	    if(existFlag == 'false') {		
		    alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
		    return;
	     }
				// 记录转发日志
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
			requestCaller.addParameter(1, "String", "false");
			requestCaller.addParameter(2, "Long", rowid);
				
			requestCaller.serviceRequest();
		
		try {
			var affairId = document.getElementById("sourceId_"+rowid).value;//eval("sourceId_" + rowid);
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getSummaryIdByAffairId", false);
			requestCaller.addParameter(1, "long", affairId);
			var summaryId = requestCaller.serviceRequest();
			
			//判断是否允许转发协同或邮件
			try{
		    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission", false);
		    	requestCaller.addParameter(1, "String", summaryId + '_' + affairId);
		    	var ds = requestCaller.serviceRequest();
		    	if(ds.length !== 0){
		    		alert(v3x.getMessage("collaborationLang.unallowed_forward_affair"));
		    		return;
		    	}
		    }catch(e){
		    }
		    getA8Top().toCollWin = getA8Top().$.dialog({
	            title: v3x.getMessage('DocLang.doc_knowledge_forward_collaboration'),
	            transParams:{'parentWin':window},
	            url: jsColURL + "?method=showForward&showType=model&data=" + summaryId + "_" + affairId,
	            width: 360,
	            height: 430,
	            isDrag:false
	        });
		}catch (ex1) {
			alert("Exception : " + ex1.message);
		}
	}else if(appEnumKey == pigData.mail){
						// 记录转发日志
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
			requestCaller.addParameter(1, "String", "false");
			requestCaller.addParameter(2, "Long", rowid);
				
			requestCaller.serviceRequest();
		
		var mailId = document.getElementById("sourceId_"+rowid).value;//eval("sourceId_" + rowid);
		var surl = jsMailURL + "?method=convertToCol&id=" + mailId;
		parent.location.href = surl;	
	}
	
}

function sendToMail(location, rowid) {
	var appEnumKey = document.getElementById("appEnumKey_"+rowid).value;//eval("appEnumKey_" + rowid);
	var pigData = new appEnumData();
	if(appEnumKey == pigData.doc){
		var surl = location + "&docResId=" + rowid + "&docLibId=" + docLibId;
		parent.location.href = surl;
	}else if(appEnumKey == pigData.collaboration || appEnumKey == pigData.form){
		//检查源协同是否存在
		//var existFlag = pigSourceExist(appEnumKey, rowid);
		var existFlag = pigSourceExistById(rowid,appEnumKey);
	    if(existFlag == 'false') {		
		    alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
		    return;
	     }
								// 记录转发日志
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
			requestCaller.addParameter(1, "String", "true");
			requestCaller.addParameter(2, "Long", rowid);
			requestCaller.serviceRequest();
		
		try {
			var affairId = document.getElementById("sourceId_"+rowid).value;//eval("sourceId_" + rowid);
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getSummaryIdByAffairId", false);
			requestCaller.addParameter(1, "long", affairId);
			var summaryId = requestCaller.serviceRequest();
    
    		//判断是否允许转发协同或邮件
			try{			    
		    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission", false);
		    	requestCaller.addParameter(1, "String", summaryId + '_' + affairId);
		    	var ds = requestCaller.serviceRequest();
		    	if(ds && ds.length != 0){
		    		alert(v3x.getMessage("collaborationLang.unallowed_forward_affair"));
		    		return;
		    	}
		    }catch(e){
		    }
			var surl = jsColURL + "?method=forwordMail&id=" + summaryId;
			parent.location.href = surl;	
			
		}catch (ex1) {
			alert("Exception : " + ex1.message);
		}
	}else if(appEnumKey == pigData.mail){
								// 记录转发日志
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
			requestCaller.addParameter(1, "String", "true");
			requestCaller.addParameter(2, "Long", rowid);
			requestCaller.serviceRequest();
		
		var mailId = document.getElementById("sourceId_"+rowid).value;//eval("sourceId_" + rowid);
		var surl = jsMailURL + "?method=autoToMail&id=" + mailId;
		parent.location.href = surl;	
	}
}

function P_OnMouseOver(id, parent) {
	var Item;
	var Extend;
	var Parent;
	if(parent != "rbpm")
	{
		var ParentItem;
		ParentItem = document.getElementById("P_" + parent);
		//ParentItem.className = "over";
	}
	HideAll(parent, 1);
	Item = document.getElementById("P_" + id);
	Extend = document.getElementById("E_" + id);
	Parent = document.getElementById("E_" + parent);
	//Item.className = "over";
  Extend.style.display = "block";
  Extend.style.left = (parseInt(document.body.scrollLeft) + parseInt(Parent.offsetLeft) + parseInt(Parent.offsetWidth)-10)+"px";
  if(parseInt(Extend.style.left) + parseInt(Extend.offsetWidth) > parseInt(document.body.scrollLeft) + parseInt(document.body.clientWidth))
    Extend.style.left = (parseInt(Extend.style.left) - parseInt(Parent.offsetWidth) - parseInt(Extend.offsetWidth) + 8)+"px";
  if(parseInt(Extend.style.left) < 0) 
    Extend.style.left = (parseInt(document.body.scrollLeft) + parseInt(Parent.offsetLeft) + parseInt(Parent.offsetWidth))+"px";

  Extend.style.top = (parseInt(Parent.offsetTop) + parseInt(Item.offsetTop))+"px";
  if(parseInt(Extend.style.top) + parseInt(Extend.offsetHeight) > parseInt(document.body.scrollTop) + parseInt(document.body.clientHeight))
    Extend.style.top = (parseInt(document.body.scrollTop) + parseInt(document.body.clientHeight) - parseInt(Extend.offsetHeight))+"px";
  if(Extend.style.top < 0)
    Extend.style.top = "0px";
}
function P_OnMouseOut(id, parent)
{
}
function HideAll(id, flag) {
	var Area;
	var Temp;
	var i;
	if(!flag)
	{
		//Temp = eval("E_" + id);
		Temp = document.getElementById("E_" + id);
		Temp.style.display = "none";
	}
	Area = eval("A_" + id);
	if(Area.length)
	{
		for(i = 0; i < Area.length; i++)
		{
			HideAll(Area[i], 0);
			//Temp = eval("E_" + Area[i]);
			Temp = document.getElementById("E_" + Area[i]);
			Temp.style.display = "none";
			//Temp = eval("P_" + Area[i]);
			Temp = document.getElementById("P_" + Area[i]);
			//Temp.className = "out";
		}
	}
}
// 保存页面传来的行数据
function rowdata() {
}
document.onmouseup = OnClick;
var isUploadFileMimeType = '0';
function OnMouseUp(docRes, docAcl,entranceType,isCollect,vForDocPropertyIframe,vForBorrow,isOpenSquare,vForDocDownload,isCollect,onlyA6,onlyA6s,isGovVer) {
	var docResId = docRes.docResId;
	var objName = docRes.docResName;
	var parentFrId = docRes.parentFrId;
	var isFolder = docRes.isFolder;
	var isFile = docRes.isFile;
	isUploadFileMimeType = '0';
	if(isFile == 'true' && docRes.mimeType != null) {
		isUploadFileMimeType = docRes.mimeType;
	}
	var isLink = docRes.isLink;
	var isFolderLink = docRes.isFolderLink;
	var isLocked = docRes.isLocked;
	var lockedUserId = docRes.lockedUserId;
	var isPig = docRes.isPig;
	var isLearningDoc = docRes.isLearningDoc;
	var appEnumKey = docRes.appEnumKey;
	var isSysInit = docRes.isSysInit;
	var versionEnabled = docRes.versionEnabled;
	var recommendEnabled = docRes.recommendEnabled;
	var all = docAcl.all;
	var edit = docAcl.edit;
	var write = docAcl.write;
	var readonly = docAcl.readonly;
	var browse = docAcl.browse;
	var list = docAcl.list;
	// 如果是我借出，则权限上只有浏览 duanyl
	if(entranceType === '3') {
		all = edit = write = readonly = 'false';
		browse = list = 'true';
	}
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocAclManager", "getBorrowPotent", false);
		requestCaller.addParameter(1, "long", docResId);
	var lentpotent2 = requestCaller.serviceRequest();
	rowdata.all = all;
	rowdata.docLibType = docLibType;
	rowdata.docResId = docResId;
	rowdata.objName = objName;
	rowdata.frType = docRes.frType;
	var isPersonal = "false";
	if (docLibType == DocLib_Type_Private) {
		isPersonal = "true";
	}	
	var mainForm = document.getElementById('mainForm');

	mainForm.oname.value = objName;
	mainForm.is_folder.value = isFolder;
	mainForm.isPersonalLib.value = isPersonal;
	mainForm.selectedRowId.value = docResId;
	
	var isAdministrator = window.isAdministrator;
	var depAdminSize = window.depAdminSize;
	var noShare = window.noShare;
	var isShareAndBorrowRoot = window.isShareAndBorrowRoot;
	var canNewColl = window.canNewColl;
	var canNewMail = window.canNewMail;
	var isEdocLib = window.isEdocLib;

	/** add by handy,2007-5-29 **/
	document.getElementById("I_separator1").style.display = "";
	if(document.getElementById("I_separator2"))
		document.getElementById("I_separator2").style.display = "";
	/**
	 * docDisplay 显示
	 * docNoneDisplay 不显示
	 */
	if (isFolder == "true") {
		docDisplay("P_sendto");
		docDisplay("I_favorite");
		docDisplay("I_publish");
		docDisplay("I_group");
		docDisplay("I_deptDoc");
		docDisplay("I_log");
		docDisplay("I_alert");
		docDisplay("I_property");
		docDisplay("I_move");
		docDisplay("I_del");
		docDisplay("I_rename");
		docDisplay("I_share");
		docDisplay("I_share_pub");
		if(hasSecretPlugins){
			docNoneDisplay("I_secretLevel");
		}
		docNoneDisplay("I_lend");
		docNoneDisplay("P_forward");
		docNoneDisplay("I_info");
		docNoneDisplay("I_mail");
		docNoneDisplay("I_replace");
		docNoneDisplay("I_lock");
		docNoneDisplay("I_unlock");
		docNoneDisplay("I_collect");
		docNoneDisplay("I_uncollect");
		docNoneDisplay("I_recommend");
		docNoneDisplay("I_openToZone");
		docNoneDisplay("I_openToZoneCancel");

		docNoneDisplay("I_edit");
		docNoneDisplay("I_download");
		docNoneDisplay("I_learning");
		docNoneDisplay("I_deptLearn");
		docNoneDisplay("I_accountLearn");
		docNoneDisplay("I_groupLearn");
		docNoneDisplay("I_learnHistory");
		docNoneDisplay("I_link");
		docNoneDisplay("I_docHistory");

		if (isPersonal == "true") {
			docNoneDisplay("I_log");
			docNoneDisplay("I_alert");
			docNoneDisplay("I_publish");
			docNoneDisplay("I_group");
			docNoneDisplay("I_deptDoc");
			docNoneDisplay("I_share_pub");
			if (all == "false") {
				if(frType !== '110') {
					docDisable("I_share");
				}			
			}
			if(isShareAndBorrowRoot != "true" && docAcl.isCreater== "true"){
			    showOrHideOpernSquare(isOpenSquare);
			}
		}
		else {
			docNoneDisplay("I_share");
			if (all == "false") {
				docDisable("I_log");
				docDisable("I_share_pub");
			}
			if(isAdministrator == 'false'){
				docDisable("I_publish");				
			}	
			if(depAdminSize == '0'){
				docDisable("I_deptDoc");
			}
			if(isGroupAdmin == 'false'){
				docDisable("I_group");	
			}
			if(isGroupLib == 'false'){
				docNoneDisplay("I_group");
			}
		}

		if (all == "false" && edit == "false" && readonly == "false" && add=="false") {
			if(browse == 'false') {
				if(list == 'false'){
					docDisable("I_property");
				}
				docDisable("P_sendto");
				docDisable("I_favorite");
			}
			// 浏览权限，文档夹允许发送到常用文档
			else {
				docDisplay("P_sendto");
				docDisplay("I_favorite");
			}
			docDisable("I_link");
			docDisable("I_alert");
		}

		if (all == "false") {	
			docDisable("I_move");
			docDisable("I_del");			
		}	
		if (all == "false" && edit == "false") {
			docDisable("I_rename");
		}
		
		if(isSysInit == 'true'){
			docNoneDisplay("I_move");
			docNoneDisplay("I_del");
			docNoneDisplay("I_rename");
			document.getElementById("I_separator1").style.display = "none";
		}
	}
	else  {
		docDisplay("I_rename");
		docDisplay("P_sendto");
		docDisplay("I_favorite");
		docDisplay("I_publish");
		docDisplay("I_deptDoc");
		docDisplay("I_learning");
		docDisplay("I_deptLearn");
		docDisplay("I_accountLearn");
		docDisplay("I_group");
		docDisplay("I_groupLearn");
		docDisplay("P_forward");
		docDisplay("I_info");
		docDisplay("I_mail");
		docDisplay("I_log");
		
		if(hasSecretPlugins){
			docDisplay("I_secretLevel");
			//end
			//分保--- 文档密级按钮控制
			if(docAcl.isCreater == "false"){
				docNoneDisplay("I_secretLevel");
			}
		}
		docDisplay("I_learnHistory");
		docDisplay("I_docHistory");
		docDisplay("I_alert");
		docDisplay("I_move");
		docDisplay("I_del");
		
		docDisplay("I_link");
		docDisplay("I_replace");
		docDisplay("I_lend");
		docDisplay("I_lock");
		docDisplay("I_unlock");
		docDisplay("I_edit");
		docEnable("I_edit");//默认开启
		docDisplay("I_download");
		docDisplay("I_property");
		
		toggleCollect(isCollect);
		
		docDisplay("I_recommend");
		docNoneDisplay("I_openToZone");
		docNoneDisplay("I_openToZoneCancel");
		docNoneDisplay("I_share");
		docNoneDisplay("I_share_pub");

		if (isFile == "false") {
			docNoneDisplay("I_replace");
		}
		
		if(isLearningDoc == 'false'){
			docNoneDisplay("I_learnHistory");
		}
		
		if(versionEnabled == 'false' || isPig == 'true' || isLink == 'true' || isPersonal == "true") {
			docNoneDisplay("I_docHistory");
		}
		
		if(isFolderLink == 'true'){
			docNoneDisplay("I_link");
			docNoneDisplay("P_forward");
			docNoneDisplay("I_info");
			docNoneDisplay("I_mail");
			docNoneDisplay("I_lock");
			docNoneDisplay("I_unlock");
			docNoneDisplay("I_edit");
			docNoneDisplay("I_download");
			docNoneDisplay("I_alert");
			
			docNoneDisplay("I_learning");
			docNoneDisplay("I_deptLearn");
			docNoneDisplay("I_accountLearn");
			docNoneDisplay("I_groupLearn");
			docNoneDisplay("I_collect");
			docNoneDisplay("I_uncollect");
			docNoneDisplay("I_recommend");
			
			docNoneDisplay("I_lend");
			document.getElementById("I_separator2").style.display = "none";
		}

//		if (isLink == "true") {
//			docNoneDisplay("I_link");
//			docNoneDisplay("P_forward")
//			docNoneDisplay("I_info");
//			docNoneDisplay("I_mail");
//			docNoneDisplay("I_lock");
//			docNoneDisplay("I_unlock");
//			docNoneDisplay("I_edit");
//			docNoneDisplay("I_download");
//			docNoneDisplay("I_alert");
//			
//			docNoneDisplay("I_deptLearn");
//			docNoneDisplay("I_accountLearn");
//			docNoneDisplay("I_learning");
//			docNoneDisplay("I_groupLearn");
//			docNoneDisplay("I_collect");
//			
//			docNoneDisplay("I_lend");
//			docNoneDisplay("I_rename");
//
//			document.getElementById("I_separator2").style.display = "none";
//		}

		// 2007.09.04
		// 协同可以转发：协同、邮件
		// 邮件可以转发：协同、邮件
		// 其他暂时不处理
		if (isPig == "true") {
			if(hasSecretPlugins){
				docNoneDisplay("I_secretLevel");
			}
			var pigData = new appEnumData();
			if(appEnumKey == pigData.edoc) {
				if(isShareAndBorrowRoot=="true") {
				     docDisable("P_sendto");
				     docDisable("I_favorite");
				     docDisable("I_link");
				     docDisable("I_learning");
				
				     docNoneDisplay("P_forward");
				     docNoneDisplay("I_info");
				     docNoneDisplay("I_mail");
				     
					 document.getElementById("I_separator0").style.display = "none";
			  	}
			} else if(appEnumKey != pigData.collaboration && appEnumKey != pigData.form && appEnumKey != pigData.mail) {
				docNoneDisplay("P_forward");
				docNoneDisplay("I_info");
				docNoneDisplay("I_mail");
			}
			docNoneDisplay("I_lock");
			docNoneDisplay("I_unlock");
			docNoneDisplay("I_edit");
			docNoneDisplay("I_download");
			docNoneDisplay("I_alert");
			
			openOrDisabelOpenSquare(isOpenSquare);
		}
		//TODO 此处权限控制待确定，add == 'false'应该不是逻辑条件之一
		if (all == "false" && edit == "false" && readonly == "false" && add=="false") {
			docDisable("P_forward");
			docDisable("I_info");
			docDisable("I_mail");
		}
		
		// 借阅需要只读才能查看历史版本，共享则只需浏览权限
		if((isShareAndBorrowRoot == 'false' && all == "false" && edit == "false" && readonly == "false" && browse == "false" && add == "false") 
			|| (isShareAndBorrowRoot == 'true' && readonly == "false")) {
			docDisable("I_docHistory");
		}

		if (all == "false" && edit == "false" && readonly == "false" && add == "false") {
			if(browse == 'false') {
				docDisable("P_sendto");
				docDisable("I_favorite");
				docDisable("I_learning");
				docDisable("I_link");
				docDisable("I_publish");
				docDisable("I_accountLearn");
				docDisable("I_groupLearn");
				docDisable("I_group");
				docDisable("I_collect");
				docNoneDisplay("I_uncollect");				
			}
			else {
				docDisplay("P_sendto");
				docDisplay("I_favorite");
				docDisplay("I_learning");
				if(isPersonal != "true" && isAdministrator == 'true') {
					docDisplay("I_publish");
					docDisplay("I_accountLearn");
				}
				
				if(isGroupAdmin == 'true' && isGroupLib == 'true') {
					docDisplay("I_groupLearn");
					docDisplay("I_group");
				}
			}
			docDisable("I_alert");
			docDisable("I_download");
			docDisable("I_link");
		}

		if (isPersonal == "true") {
			docNoneDisplay("I_log");
			docNoneDisplay("I_alert");
			docNoneDisplay("I_lock");
			docNoneDisplay("I_unlock");
			docNoneDisplay("I_publish");
			docNoneDisplay("I_deptDoc");
			docNoneDisplay("I_deptLearn");
			docNoneDisplay("I_accountLearn");
			docNoneDisplay("I_group");
			docNoneDisplay("I_groupLearn");
			docNoneDisplay("I_collect");
			docNoneDisplay("I_uncollect");
			if(isShareAndBorrowRoot != "true" && docAcl.isCreater== "true" ){
			    showOrHideOpernSquare(isOpenSquare);
			}
			if(isShareAndBorrowRoot == "true" && docAcl.isCreater!= "true" ){
			    toggleCollect(isCollect);
			}
			if(isLink=="true" || isFolderLink=="true" ||isPig == "true"){
			    openOrDisabelOpenSquare(isOpenSquare);
				docDisable("I_collect");
				docNoneDisplay("I_uncollect");
			}
			//是归档，并且有浏览以上权限
			if(isShareAndBorrowRoot == "true" && docAcl.isCreater!= "true" && isPig == "true"){
			    if(all == "true" || edit == "true" ||  browse == "true" || readonly === 'true' || browse == 'true'){
			        toggleCollect(isCollect);
			    }
            }
		}
		else {
			if (isLocked == "true") {
				docNoneDisplay("I_lock");
			}
			else {
				docNoneDisplay("I_unlock");
			}			

			if (all == "false") {
				docDisable("I_log");
			}				
			
			if (all == "false" && edit == "false") {
				docDisable("I_lock");
				docDisable("I_unlock");
			}	
			
			if (isLocked == "true" && lockedUserId != currentUserId) {
				docDisable("I_edit");
				docDisable("I_unlock");
				docDisable("I_replace");
				docDisable("I_rename");
				docDisable("I_move");
				docDisable("I_del");
			}
			if(isAdministrator == 'false') {
				docDisable("I_publish");
				docDisable("I_accountLearn");
			}	
			if(depAdminSize == '0'){
				docDisable("I_deptDoc");
				docDisable("I_deptLearn");
			}
			if(isGroupAdmin == 'false'){
				docDisable("I_group");	
				docDisable("I_groupLearn");
			}
			if(isGroupLib == 'false'){
				docNoneDisplay("I_group");
				docNoneDisplay("I_groupLearn");
			}
		}

		if (all == "false") {
			docDisable("I_move");
			docDisable("I_del");
			if(frType != 111) {  
				docDisable("I_lend");
			}
		}				
		
		if (all == "false" && edit == "false") {
			docDisable("I_replace");
			docDisable("I_rename");
			docDisable("I_edit");
		}
		
		if('false' == canNewColl) {
			if('false' == canNewMail){
				docNoneDisplay("P_forward");
				docNoneDisplay("I_info");
				docNoneDisplay("I_mail");
			} else {
				docNoneDisplay("I_info");
			}
		} else if('false' == canNewMail) {
			docNoneDisplay("I_mail");
		}	
	}

	//only add acl
	if(all== "false" && edit== "false" && readonly== "false" && browse== "false" && docAcl.isCreater == "false"){
		if(add== "true" && list== "false"){
			docNoneDisplay("P_sendto");
			docNoneDisplay("P_forward");
			docDisable("I_download")
			docDisable("I_move")
			docDisable("I_del")
			docDisable("I_rename")
			docDisable("I_property")
			docDisable("I_share")
			docDisable("I_share_pub")
			docDisable("I_lock");
			docDisable("I_unlock");
			docDisable("I_log");
			docDisable("I_alert");
			docDisable("I_docHistory");
		}else if(add== "true" && list== "true"){
			docDisable("I_download");
		}else if(add== "false"){
		    docDisable("I_collect");
		    docNoneDisplay("I_uncollect");
		}
	}
	// 2008.06.17 个人共享，借阅屏蔽掉发送
	if(isShareAndBorrowRoot == "true") {
		if(hasSecretPlugins){
			docNoneDisplay("I_secretLevel");
		}
		docNoneDisplay("P_sendto");
		docNoneDisplay("I_favorite");
		docNoneDisplay("I_publish");
		docNoneDisplay("I_deptDoc");
		docNoneDisplay("I_learning");
		docNoneDisplay("I_deptLearn");
		docNoneDisplay("I_accountLearn");
		docNoneDisplay("I_group");
		docNoneDisplay("I_groupLearn");
		
      	if(lentpotent2 != null && lentpotent2.substring(0, 1) != "1") {
	  		docDisable("I_download");
      	}
		if (isFolder == "true") {
			document.getElementById("I_separator0").style.display = "none";
		}
	}
	
	if(isEdocLib == 'true'){
		docNoneDisplay("P_sendto");
		docNoneDisplay("P_forward");
		if(hasSecretPlugins){
			docNoneDisplay("I_secretLevel");
		}
		document.getElementById("I_separator0").style.display = "none";
	}
	if(recommendEnabled!='true'){
		docNoneDisplay("I_recommend");
	}
	if(appEnumKey == appData.edoc){
		docNoneDisplay("P_forward");
	}
//	if(frType == '42'&& isAdministrator == 'true'){
//		docDisplay("I_share_pub");
//	}
	if(all === 'false' && edit === 'false' && readonly === 'false' && browse === 'false' && add === 'false') {
		docDisable("I_favorite");
		docDisable("I_publish");		
		docDisable("I_learning");
		docDisable("I_accountLearn");
		docDisable("I_group");
		docDisable("I_groupLearn");
		docDisable("I_deptDoc");
		docDisable("I_deptLearn")
		docDisable("I_link");
	}
	if (isLink == "true") {
		docNoneDisplay("I_link");
		docNoneDisplay("P_forward")
		docNoneDisplay("I_info");
		docNoneDisplay("I_mail");
		docNoneDisplay("I_lock");
		docNoneDisplay("I_unlock");
		docNoneDisplay("I_edit");
		docNoneDisplay("I_download");
		docNoneDisplay("I_alert");
		
		docNoneDisplay("I_deptLearn");
		docNoneDisplay("I_accountLearn");
		docNoneDisplay("I_learning");
		docNoneDisplay("I_groupLearn");
		docNoneDisplay("I_collect");
		docNoneDisplay("I_uncollect");
		
		docNoneDisplay("I_lend");
		docNoneDisplay("I_rename");

		document.getElementById("I_separator2").style.display = "none";
		if(isCollect === 'true') {
			docDisable("I_favorite");
			docNoneDisplay("I_deptDoc");
			docNoneDisplay("I_deptLearn");
			docNoneDisplay("I_accountLearn");
			docNoneDisplay("I_group");
			docNoneDisplay("I_groupLearn");
			docNoneDisplay("I_publish");
		}
	}
	
	if(isDocNoneDisplay("P_sendto") && isDocNoneDisplay("P_forward") && isDocNoneDisplay("I_download")){
	    docNoneDisplay("I_separator0");
	}
	
	var PopMenu;
	//PopMenu = eval("E_rbpm");
	PopMenu = document.getElementById("E_rbpm");
	var docMenuTable = document.getElementById("docMenuTable");
	docMenuTable.className = docResId;
	docMenuTable.entranceType = entranceType;
	docMenuTable.isPig = isPig;
	docMenuTable.vForDocPropertyIframe = vForDocPropertyIframe;
	docMenuTable.vForBorrow = vForBorrow;
	docMenuTable.vForDocDownload = vForDocDownload;
	HideAll("rbpm", 0);
	PopMenu.style.display = "block";
	var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);    
	var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
	var popLeft = document.getElementById("_" + docResId).getBoundingClientRect().left + 8 + scrollLeft;
	var popTop = document.getElementById("_" + docResId).getBoundingClientRect().top + 8 + scrollTop;
	if(popLeft + PopMenu.offsetWidth > document.body.clientWidth){
		popLeft -= PopMenu.offsetWidth;
	}
	if(popTop + PopMenu.offsetHeight > document.body.clientHeight){
		popTop -= PopMenu.offsetHeight;
	}
	PopMenu.style.left = popLeft < 0 ? (0+"px") : (popLeft+"px");
	PopMenu.style.top = popTop < 0 ? (0+"px") : (popTop+"px");
	
	//判断文档类型与浏览器类型决定是否显示编辑按钮 youhb
    if (docRes.mimeType == '101' || docRes.mimeType == '120' || docRes.mimeType == '102' || docRes.mimeType == '121'||
    		docRes.mimeType == '23' || docRes.mimeType == '24' || docRes.mimeType == '25' || docRes.mimeType == '26') {
    	if (!v3x.isOfficeSupport()) {
    		docDisable("I_edit");
    	}
    }
    
    //a6版本时，去掉发送到部门学习区，部门知识文档
	if(onlyA6==='true' && onlyA6s==='true'){
		docNoneDisplay("I_deptDoc");
		docNoneDisplay("I_deptLearn");
		
	}
	if(isGovVer == 'true'){
	  	docNoneDisplay("I_openToZone");
	  	docNoneDisplay("I_openToZoneCancel");
	  	docNoneDisplay("I_recommend");	
		docNoneDisplay("I_collect");	
	}
}

function OnClick() {
	HideAll("rbpm",0);
}

function toggleCollect(isCollect){
    if(isCollect === 'true'){
        docNoneDisplay("I_collect");
        docDisplay("I_uncollect");
    }else{
        docNoneDisplay("I_uncollect");
        docDisplay("I_collect");
    }
}

function openOrDisabelOpenSquare(isOpenSquare){
    if(isOpenSquare === 'true'){
        docNoneDisplay("I_openToZone");
        docDisable("I_openToZoneCancel");
    }else{
        docDisable("I_openToZone");
        docNoneDisplay("I_openToZoneCancel");
    }
}

function showOrHideOpernSquare(isOpenSquare){
    if(isOpenSquare === 'true'){
        docNoneDisplay("I_openToZone");
        docDisplay("I_openToZoneCancel");
    }else{
        docDisplay("I_openToZone");
        docNoneDisplay("I_openToZoneCancel");
    }
}

function docProperties(location, rowid, isFolder, isPersonalLib, propEditValue, all, frType,v){
	var url = location + "&docResId=" + rowid + "&isFolder=" + isFolder + "&isPersonalLib=" + isPersonalLib + 
		"&propEditValue=" + propEditValue + "&allAcl=" + all + "&frType=" + frType + "&v=" + v;
	var returnValue = v3xOpenWindow(url,v3x.getMessage("DocLang.doc_jsp_properties_title"));
	if(returnValue) {
		getA8Top().frames["main"].frames["rightFrame"].location.reload(true)
	}
}