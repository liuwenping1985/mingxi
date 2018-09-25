try {
    getA8Top().endProc();
}
catch(e) {
}
/**
 * Greate 2007-3-21 by xuegw xml中特殊字符对应的实体 < &lt; & &amp; > &gt; " &quot; ' &apos;
 */
/*------------------------------------------ JS常量定义 Start ------------------------------------------*/
/**
 * 系统类型定义（用于归档文件的类型判断）
 */
function appEnumData() {
	this.global = '0'; // 全局
	this.collaboration = '1'; // 协同应用
	this.form = '2'; // 表单
	this.doc = '3'; // 知识管理
	this.edoc = '4'; // 公文
	this.plan = '5'; // 计划
	this.meeting = '6'; // 会议
	this.bulletin = '7'; // 公告
	this.news = '8'; // 新闻
	this.bbs = '9'; // 讨论
	this.inquiry = '10'; // 调查
	this.mail = '12'; // 邮件
	this.organization = '13'; // 组织模型
	this.info = '32'; // 信息报送
	this.infoStat = '33'; // 信息报送统计
}
var appData = new appEnumData();

/**
 * 文档库类型定义
 */
var DocLib_Type_Custom = 0; // 自定义文档库类型
var DocLib_Type_Private = 1; // 个人文档库
var DocLib_Type_Public = 2; // 单位文档库
var DocLib_Type_Edoc = 3; // 公文档案
var DocLib_Type_Project = 4; // 项目文档库

/*------------------------------------------ JS常量定义 End -------------------------------------------*/
function v3xOpenWindow(surl,title) {
	var _title = title?title:'';
	getA8Top().LibPropWin = getA8Top().$.dialog({
        title:_title,
        transParams:{'parentWin':window,'showButton':true},
        url: surl,
        width: 500,
        height: 560,
        isDrag:false
	});
}

/**
 * docMenu页面javascript函数
 */
function setFlag(flag) {
	searchForm.flag.value = flag;
}
function clearFlag() {
	searchForm.flag.value = "";	
}
function docSimpleSearchEnter(isQuote) {
	var evt = v3x.getEvent();
    if(evt.keyCode == 13){
    	if(isQuote == true || isQuote == 'true') {
    		seachDocRel();
    	} else {
	    	docSimpleSearch();
    	}
    }
}
/**
 * 文档简单属性查询
 * 
 * @see com.seeyon.v3x.doc.webmodel.SimpleDocQueryModel中关于查询输入数据延伸名称的常量定义
 * @see com.seeyon.v3x.doc.util.Constants中关于元数据类型部分的常量定义
 */
function docSimpleSearch() {
	if(!checkForm(searchForm)) {
		return;
	}
	var fvalue = searchForm.flag.value;
	var method = "";
	if(fvalue && fvalue != '') {
		method = "simpleQuery&propertyNameAndType=" + fvalue;
		var name_type = fvalue.split('|');
		try {
			var propName = name_type[0];
			var propType = name_type[1];
			var isDefault = name_type[2];
			if(propType == '4' || propType == '5') {
				var startDate = document.getElementById(propName + "beginTime");
				var endDate = document.getElementById(propName + "endTime");
				//时间校验
				if(startDate.value != '' && endDate.value != ''){
					var setDate;
					var result = compareDate(startDate.value, endDate.value);
					if(result > 0){
						setDate = parseDate(startDate.value);
						//endDate.value = formatDate(setDate.dateAdd(startDate.value, 7));
						alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
						return;
					}
				}
				
				method += "&" + propName + "beginTime=" + startDate.value;
				method += "&" + propName + "endTime=" + endDate.value;
			}else {
				// frType页面中已有全局变量定义，避免重复
				var appendFlag= "";
				if(propType == '10') {
					if(document.getElementById("frTypeValue").value == -1) {
						alert(v3x.getMessage("DocLang.doc_type_alter_not_select"));
						return;
					}
					appendFlag = "Value";
				}
				var value = document.getElementById(propName + appendFlag).value;
				if(value && !/^[^\|\\"'<>]*$/.test(value)){
					alert(v3x.getMessage("V3XLang.formValidate_specialCharacter", value))
					return;
				}
				method += "&" + propName + appendFlag + "=" + encodeURIComponent(value);
				if(propType == '9') {
					method += "&" + propName + "Name=" + encodeURIComponent(document.getElementById(propName + "Name").value);
				}
			}
			method += ("&" + propName + "IsDefault=" + isDefault);
		} catch(e) {
			// -> Ignore
		}
	}else {
	    method = "simpleQuery&propertyNameAndType=frName|1|true";
	}
	docResId = window.docResId;
	docLibId = window.docLibId;
	docLibType = window.docLibType;
	isShareAndBorrowRoot = window.isShareAndBorrowRoot;
	isLibOwner = window.isLibOwner;

	var docUrl = jsURL + "?method=" + method + "&queryFlag=true&resId=" + docResId + "&docLibId=" + docLibId 
		+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=" + isShareAndBorrowRoot
		+ "&all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list
		+ "&depAdminSize=" + depAdminSize + "&isAdministrator=" + isAdministrator
		+ "&isGroupAdmin=" + isGroupAdmin + "&libName=" + encodeURI(libName) + "&isLibOwner=" + isLibOwner + "&frType=" + window.frType + "&flag=" + fvalue;
	
	//IE10页面加载不出来问题，注释掉
	/*try{
		// 文档查询后，frameset，恢复到默认宽度且不可拖动，点击‘返回’按钮，恢复默认状态
		if(parent.layout){
			if(parent.layout.cols != "0,*") {
				parent.layout.cols="140,*";
				//parent.document.getElementById("treeFrame").noResize=true;		
			}	
		}
	}catch(e){}*/
	
	location.href = docUrl;
}
/**
 * 高级查询模式下改为get，将参数直接拼接在url地址中，避免post模式下，页面属性时导致form重新提交
 */
function getSearchConditionUrl() {
	var nameAndTypes = document.getElementsByName('propertyNameAndType');
	var nameAndTypeUrl = new StringBuffer();
	var valueUrl = new StringBuffer();
	if(nameAndTypes && nameAndTypes.length > 0) {
		for(var i = 0; i < nameAndTypes.length; i++ ) {
			var nameAndType = nameAndTypes[i].value;
			var arr = nameAndType.split('|');
			var propName = arr[0];
			var propType = arr[1];
			var propIsDefault = document.getElementById(propName + 'IsDefault').value;
			
			
			// 日期(时间)
			if(propType == '4' || propType == '5') {
				if(document.getElementById(propName + 'beginTime2') && document.getElementById(propName + 'endTime2') && 
				   (document.getElementById(propName + 'beginTime2').value != '' || 
				    document.getElementById(propName + 'endTime2').value != '')) {
					
					nameAndTypeUrl.append(nameAndType + '|' + propIsDefault + ',');
					valueUrl.append(propName + 'beginTime=' + document.getElementById(propName + 'beginTime2').value + '&');
					valueUrl.append(propName + 'endTime=' + document.getElementById(propName + 'endTime2').value + '&');
					valueUrl.append(propName + 'IsDefault=' + propIsDefault + '&');
				}
			}
			else {
				var doms = document.getElementsByName(propName);
				if(doms && doms.length > 0) {
					var spValue = doms[doms.length - 1].value;
					if(spValue && spValue.trim() != '') {
						nameAndTypeUrl.append(nameAndType + '|' + propIsDefault + ',');
						// 历史原因，在查询条件为文档类型的情况下，变量名加上'Value'，避免与url中的frType变量重名冲突
						valueUrl.append(propName + (propType == '10' ? 'Value' : '') + '=' + encodeURIComponent(spValue) + '&');
						valueUrl.append(propName + 'IsDefault=' + propIsDefault + '&');
					}
				}
			}
		}
		
		if(nameAndTypeUrl.toString().trim() != '') {
			valueUrl.append('propertyNameAndTypes=' + nameAndTypeUrl.toString());
		}
	}
	return valueUrl.toString();
}
function docAdvancedSearchEnter() {
	var evt = v3x.getEvent();
    if(evt.keyCode == 13) {
    	docAdvancedSearch();
    }
}
/**
 * 文档高级查询
 */
function docAdvancedSearch() {
	if(!checkForm(advancedSearchForm)) {
		return;
	}
	
	docResId = window.docResId;
	docLibId = window.docLibId;
	docLibType = window.docLibType;
	isShareAndBorrowRoot = window.isShareAndBorrowRoot;
	isLibOwner = window.isLibOwner;

	var docUrl = jsURL + "?method=advancedQuery&queryFlag=true&resId=" + docResId + "&docLibId=" + docLibId 
		+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=" + isShareAndBorrowRoot
		+ "&all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list
		+ "&depAdminSize=" + depAdminSize + "&isAdministrator=" + isAdministrator
		+ "&isGroupAdmin=" + isGroupAdmin + "&libName=" + encodeURI(libName) + "&isLibOwner=" + isLibOwner + "&frType=" + window.frType;
	/*IE10渲染不出来的问题
	try{
		// 文档查询后，frameset，恢复到默认宽度且不可拖动，点击‘返回’按钮，恢复默认状态
		if(parent.layout){
			if(parent.layout.cols != "0,*") {
				parent.layout.cols="140,*";
				//parent.document.getElementById("treeFrame").noResize=true;		
			}	
		}
	}catch(e){}*/
	
	var conditionUrl = getSearchConditionUrl();
	if(conditionUrl == '') {
		alert(v3x.getMessage('DocLang.no_advanced_search_condition'));
		return;
	}
	// Url路径超长问题处理(get模式下url最长允许2048)
	if(conditionUrl.length > 2024) {
		alert(v3x.getMessage('DocLang.advanced_search_url_too_long', conditionUrl.length + 24));
		return;
	}
	document.getElementById("advancedSearchButton").disabled = true;
	dataIFrame.location.href = docUrl + '&' + conditionUrl;
}
function showOrHideAdvancedSearch() {
	var as = document.getElementById("advancedSearch");
	var mainTable = document.getElementById('ScrollDIV');
	var menuBar = document.getElementById('rightMenuBar');
	var dataIFrame = document.getElementById('dataIFrame');
	
	if(as.style.display == "none") {
		as.style.display = "block";
		mainTable.style.display = "none";
		dataIFrame.style.display = "block";
		menuBar.style.display = "none";
	} else {
		as.style.display = "none";
		mainTable.style.display = "block";
		dataIFrame.style.display = "none";
		menuBar.style.display = "block";
	}
	
	var topHeight=document.getElementById("scrollListDiv").clientHeight;
    var searchHeight=document.getElementById("advancedSearch").clientHeight;
    document.getElementById("dataIFrame").style.height=(topHeight-searchHeight)*100/topHeight+"%";
	
	var asButton = document.getElementById("advancedSearchImg");
	if(asButton.className == "advanceSearchUp"){
	    asButton.className = "advanceSearchDown";
	}else{
	    asButton.className = "advanceSearchUp";
	}
}
/**
 * 文档查询中，选择组织模型相关信息进行查询（比如：人员、部门等情况）
 */
function setDocSearchPeopleFields(orgName, elements) {
	// 简单属性处也存在同名dom，此处应当将高级查询处的属性设值
	var aform = document.getElementById("advancedSearchForm");
	var doms = aform.elements[orgName];
	if(doms) {
		doms.value = getIdsString(elements, false);
	}
	document.getElementById(orgName + "ASName").value = getNamesString(elements);
	document.getElementById(orgName + "ASName").title = getNamesString(elements);
}
function setSimpleDocSearchPeopleFields(orgName, elements) {
	document.getElementById(orgName).value = getIdsString(elements, false);	
	document.getElementById(orgName + "Name").value = getNamesString(elements);
	document.getElementById(orgName + "Name").title = getNamesString(elements);
}
/***********************************************************************************************************************
 * create folder begin
 */
var winCreateFolder;
function createFolder(parentVersionEnabled, parentCommentEnabled, parentRecommendEnable) {
	var parentId = window.docResId;
	var docLibId = window.docLibId;
	var docLibType = window.docLibType;
	winCreateFolder = v3x.openDialog({
		id : "createFolder",
		title : v3x.getMessage("DocLang.doc_jsp_createf_title"),
		url : jsURL + "?method=createF&parentId=" + parentId + "&docLibId" + docLibId + "&docLibType=" + docLibType + 
			  '&parentVersionEnabled=' + parentVersionEnabled + '&parentCommentEnabled=' + parentCommentEnabled +"&parentRecommendEnable=" + parentRecommendEnable,
		width : 380,
		height : 200,
		buttons : [{
			id:'btn1',
    	    text: v3x.getMessage("DocLang.submit"),
    	    emphasize:"button-default_emphasize",
    	    handler: function(){
	    	    var returnValues = winCreateFolder.getReturnValue();
	    	    
	        }
		}, {
    		id:'btn2',
    	    text: v3x.getMessage("DocLang.cancel"),
    	    handler: function(){
    	    	winCreateFolder.close();
    	    }
		}]
	
	});
	
	}

function createFolder0() {
 alert("设置了门户栏目的文件夹，暂不支持建子文件夹！");		
}
var winEdocCreateFolder;
function createEdocFolder(parentCommentEnabled, parentRecommendEnable,sTitle) {
	var parentId = window.docResId;
	var docLibId = window.docLibId;
	var _sTitle = sTitle==null? "": sTitle;
	winEdocCreateFolder = v3x.openDialog({
		id : "edocCreateFolder",
		title : _sTitle,
		url : jsURL + "?method=createEdocFolder&parentId=" + parentId + "&docLibId" + docLibId + '&parentCommentEnabled=' + parentCommentEnabled + "&parentRecommendEnable=" + parentRecommendEnable,
		width : 460,
		height : 250,
		buttons : [{
			id:'btn1',
    	    text: v3x.getMessage("DocLang.submit"),
    	    handler: function(){
	    	    var returnValues = winEdocCreateFolder.getReturnValue();
	        }
		}, {
    		id:'btn2',
    	    text: v3x.getMessage("DocLang.cancel"),
    	    handler: function(){
    	    	winEdocCreateFolder.close();
    	    }
		}]
	
	});
}
/**
 * 创建文件夹页面 greate by xuegw
 */
function newCreate(detailurl) {
	if(!checkForm(mainForm)){
		return false;
	}
	
 	var obj = self.dialogArguments; 
	var parentId = obj.window.docResId;
	var docLibId = obj.window.docLibId;
	var docLibType = obj.window.docLibType;
	mainForm.action = detailurl + "?method=createFolder&parentId=" + parentId + "&docLibId=" + docLibId + "&docLibType=" + docLibType;
}

function newCreateEdoc(detailurl) {
	if(document.all.title.value!="") {  
 		var obj = self.dialogArguments; 
		var parentId = obj.window.docResId;
		var docLibId = obj.window.docLibId;
		mainForm.action = detailurl + "?method=doCreateEdocFolder&parentId=" + parentId + "&docLibId=" + docLibId;
	}
	else{
		alert(v3x.getMessage("DocLang.doc_jsp_createf_null_failure_alert"));
		document.all.title.focus();
		return false;
	}
}
/**
 * 使用弹出式菜单进行操作时，进行锁（包括应用锁和并发锁）状态校验
 */
function checkLock(docId, isFolder) {
	var msg_status = getLockMsgAndStatus(docId);
	if(msg_status && msg_status[0] != LOCK_MSG_NONE && msg_status[1] != LockStatus_None) {
		// 如果是应用锁定或文档已被删除，需刷新列表显示
		if(msg_status[1] == LockStatus_DocInvalid || msg_status[1] == LockStatus_AppLock) {
			if(msg_status[1] == LockStatus_DocInvalid) {
				if(isFolder == 'true') {
					alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
				} else {
					alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
				}
			}
			else {
				alert(msg_status[0]);
			}
			window.location.reload(true);
		}
		else {
			// 隐藏弹出菜单之后弹出提示信息
			try {
				setTimeout("HideAll('rbpm', 0)", 100);
			} catch(e) {
				// -> Ignore
			}
			alert(msg_status[0]);
		}
		return false;
	}
	return true;
}
/**
 * 重命名文档或文档夹。
 */
var winRename; 
function rename(surl, isFolder, docId) {
	if(checkLock(docId, isFolder) == false) {
		return;
	}
	
	if(v3x.getBrowserFlag('openWindow') == false){
	winRename = v3x.openDialog({
		id : "rename",
		title : "rename",
		url : surl,
		width : 380,
		height : 200,
		type : 'panel',
		buttons : [{
			id:'btn1',
    	    text: v3x.getMessage("DocLang.submit"),
    	    handler: function(){
	    	    var returnValues = winRename.getReturnValue();
	
	        }
		}, {
    		id:'btn2',
    	    text: v3x.getMessage("DocLang.cancel"),
    	    handler: function(){
    	    	winRename.close();
    	    }
		}]
	
	});
	} else {
	var returnvalue = v3x.openWindow({
		url : surl,
		width : "380",
		height : "200",
		resizable : "yes"
	});
	if(returnvalue) {
		var docResId = returnvalue[0];
		var newName = returnvalue[1];
		window.location.reload(true);
		if (isFolder == "true") {		
			var obj = parent.treeFrame;
			if (obj.webFXTreeHandler.getIdByBusinessId(docResId) != undefined) {			
				obj.webFXTreeHandler.all[obj.webFXTreeHandler.getIdByBusinessId(docResId)].setText(newName);
			}
		}
	}
	}
}
function readyToRename(parentId, frType, oldname){
	var name = document.getElementById('newName').value;
	if(name.trim() == oldname){
		window.close();
		return false;
	}
	
	if(!checkForm(mainForm))
		return false;

	if(dupliName(parentId, name, frType, false) == 'true'){
		if(frType != null && frType == "31"){
				alert(v3x.getMessage('DocLang.doc_upload_dupli_name_folder_failure_alert',name));
		}else{
				alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert',name));
		}
		document.mainForm.newName.focus();
		return false;
	}
	return true;
}
/**
 * 删除
 */
function delF(checkedid, flag, isFolder) {
	var parentId = window.docResId;
	var docLibType = window.docLibType;
	var mainForm = document.getElementById("mainForm");
	
	if(checkedid != "topOperate" && checkLock(checkedid, isFolder) == false) {
		return;
	}

	if(flag == "self") {
		delOk(checkedid,mainForm, jsURL, "delete&parentId=" + parentId + "&docLibType=" + docLibType + "&id=" + checkedid, '', isFolder);
	}
	else {		
		delOk(checkedid, document.mainForm, jsURL, "delete&parentId=" + parentId + "&docLibType=" + docLibType, document.mainForm.id);
	}
}

/**
 * 批量下载
 */
function doloadFile(userId){
  var downloadIncoludeFolder = false;
	if(getA8Top().xmlDoc == null){
		getA8Top().$.alert(v3x.getMessage("V3XLang.batch_download_control_error"));
		return;
	}
// getA8Top().contentFrame.topFrame.showDowloadPicture("doc");
	var ipUrl = window.location.href;
	var startUrl = ipUrl.substring(0, ipUrl.indexOf("/seeyon")) + "/seeyon";
	var ids = document.getElementsByName("id");
	var size = 0;
	var pigCount = 0;
	var hasFolder = false;
	for (var i = 0; i < ids.length; i ++) {
		if (ids[i].checked) {
			size += 1;
			var id = ids[i].value;
			var downloadFrName = document.getElementById(id + "_Name").value;
			var downloadFrSize = 0;
			if(document.getElementById(id + "_Size")){
				downloadFrSize = document.getElementById(id + "_Size").value;
			}
			var downloadIsFolder = document.getElementById("isFolder" + id).value;
			var downloadIsPig = document.getElementById(id + "_IsPig").value;
			var vForDocDownloadElE = document.getElementById(id+"_UploadFileV");
			var vForDocDownload = vForDocDownloadElE.value;
			if(downloadIsPig == true || downloadIsPig == "true") {
				pigCount ++;
				continue;
			}
			var url;
			var result;
			if(downloadIsFolder != "true"){// 文件
				var isBorrow = isShareAndBorrowRoot == "true" && (frType == "102" || frType == "103");
				var downloadIsUploadFile = document.getElementById("isUploadFile_"+id).value;
				if (downloadIsUploadFile != "true") {// 复合文档
					downloadFrName += ".zip";
				}
				url = startUrl + "/doc.do?method=checkFile&docId=" + id + "&isBorrow=" + isBorrow+"&v="+vForDocDownload;
				result = getA8Top().xmlDoc.AddDownloadFile(userId, downloadFrSize, downloadFrName, url);
			}else{// 文件夹
			  downloadIncoludeFolder = true;
				url = startUrl + "/doc.do?method=getFilesFromFolder&folderId=" + id+"&v="+vForDocDownload;
				result = getA8Top().xmlDoc.AddDownloadFolder(userId, downloadFrName, url);
			}
			if("FD_ERROR_USER_NO_FIND" == result){
				getA8Top().$.alert(_("V3XLang.batch_download_no_user"));
				return;
			}
		}
	}
	
	if(pigCount > 0||downloadIncoludeFolder){
		getA8Top().$.alert(_("DocLang.batch_download_not_pig"));
	}
	
	if(size == 0){
		getA8Top().$.alert(_("V3XLang.selectPeople_alert_minSize", 1, 0));
		return;
	}
}

function delOk(checkedid, mainForm, actionname, methodname, checkid, isFolder) {
	var isalert =	document.getElementById("isalert").value ;
	mainForm.action = actionname + "?method=" + methodname;
	if(checkedid == "topOperate") {
		var len = checkid.length;
		var size = 0;	
		var chkboxval;	
		if(!checkid[0]){ // 页面中没有或只有一项内容
			if(checkid.checked == undefined){
				alert(v3x.getMessage("DocLang.doc_delete_no_content_alert"))
				return;
			}else if(checkid.checked) {
				size = 1;
				chkboxval = checkid.value;
			}else {
				size = 0;
			}
		} else {
			for (i = 0; i <len; i++) {
				if (checkid[i].checked) {
					size += 1;
					chkboxval = checkid[i].value;
				}
			}
		}
		
		if (size == 0) {
			alert(v3x.getMessage("DocLang.doc_delete_select_alert"));
			return false;
		}
		else {
			var ss = " " + size + v3x.getMessage("DocLang.doc_delete_items");
			if(size == 1){
				var isf = eval("document.mainForm.isFolder" + chkboxval).value;
				var ret;
				if(isf == 'true')
					ret = confirm(v3x.getMessage("DocLang.doc_delete_confirm_folder"));
				else
					ret = confirm(v3x.getMessage("DocLang.doc_delete_confirm_doc"));
				if(ret){
					mainForm.target = "empty";
					mainForm.submit();
				}	
			}else{
				if(confirm(v3x.getMessage("DocLang.doc_delete_confirm_head") + ss + v3x.getMessage("DocLang.doc_delete_confirm_tail"))) {	
					mainForm.target = "empty";
					mainForm.submit();
				}
			}
		}
	}
	else {
		var ret = false;
		if(isFolder == 'true') {
			ret = confirm(v3x.getMessage("DocLang.doc_delete_confirm_folder"));
			if(ret){
		       mainForm.target = "empty";
		       mainForm.submit();
			}
		} else if(isalert=="true"){
		    ret = confirm(v3x.getMessage("DocLang.doc_delete_confirm_doc"));
	        if(ret){
		       mainForm.target = "empty";
		       mainForm.submit();
	        }
		} else {
			mainForm.target = "empty";
			mainForm.submit();
		}
	}
}
function validateParent(parentId, path){
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceNoChange", false);
		requestCaller.addParameter(1, "Long", parentId);
		requestCaller.addParameter(2, "String", path);
				
		var flag = requestCaller.serviceRequest();
		return flag;
	}
	catch (ex1) {
		alert("Exception : " + ex1.message);
	}
}
function showNoHidden() {
	if(parent.layout){
		if(parent.layout.cols == "0,*") {
			parent.layout.cols = "140,*";
			getA8Top().contentFrame.LeftRightFrameSet.cols = "0,*";
			try{
				if(parent.document.getElementById("treeFrame")!=null){
					parent.document.getElementById("treeFrame").noResize=false;	
				}
			}catch(e){}
		}
	}
}

/**
 * 新建文档
 */
function createDoc(bodyType) {
	showNoHidden();
	
	var parentId = window.docResId;
	var parentPath = window.parentPath;
	
	var existFlag = validateParent(parentId, parentPath);
	if(existFlag == 'delete'){
		alert(v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
		parent.location.reload(true);
		return;
	}else if(existFlag == 'move'){
		alert(v3x.getMessage('DocLang.doc_alert_source_move_folder'));
		parent.location.reload(true);
		return;
	}
	
	var docMimeType = 22;
    if(bodyType == 41){
    	docMimeType = 23;
    }else if(bodyType == 42){
    	docMimeType = 24;
    }else if(bodyType == 43){
    	docMimeType = 25;
    }else if(bodyType == 44){
        docMimeType = 26;
    }else if(bodyType == 45){
        docMimeType = 103;
    }
	var frType = window.frType;
	var docLibId = window.docLibId;
	var docLibType = window.docLibType;
	var parentCommentEnabled = window.parentCommentEnabled;
	var parentVersionEnabled = window.parentVersionEnabled;
	var parentRecommendEnable = window.parentRecommendEnable;
	var currentUserId = window.currentUserId;
	//检查个人空间大小并提示
	if(docLibType==1){//个人文档库
		var spaceSize = getLeftSpaceByType(0,currentUserId)
		if(spaceSize < 10*1024 && spaceSize > 500){
			var cfm = confirm(v3x.getMessage("DocLang.personal_storage_not_enough_alert"));
			if(!cfm){
				return;
			}
		}else if(spaceSize<=500){
			alert(v3x.getMessage("DocLang.personal_storage_not_enough"));
			return;
		}
	}
	
	var url = jsURL + "?method=theNewAddDoc&parentId=" + parentId + "&frType=" + frType + "&docLibId=" + docLibId 
		+ "&docLibType=" + docLibType + "&docMimeType=" + docMimeType + "&bodyType="+bodyType + "&all=" + all + "&edit=" + edit 
		+ "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list + "&parentRecommendEnable=" + parentRecommendEnable
		+ "&parentCommentEnabled=" + parentCommentEnabled + "&parentVersionEnabled=" + parentVersionEnabled + "&parentPath=" + parentPath + "&isShareAndBorrowRoot=false";
	location.href = url;
}

function createDocWithoutHidden(bodyType) {
	var parentId = window.docResId;
	var parentPath = window.parentPath;
	
	var existFlag = validateParent(parentId, parentPath);
	if(existFlag == 'delete'){
		alert(v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
		parent.location.reload(true);
		return;
	}else if(existFlag == 'move'){
		alert(v3x.getMessage('DocLang.doc_alert_source_move_folder'));
		parent.location.reload(true);
		return;
	}
	var frType = window.frType;
	var docLibId = window.docLibId;
	var docLibType = window.docLibType;
	var parentCommentEnabled = window.parentCommentEnabled;
	var parentVersionEnabled = window.parentVersionEnabled;
	var parentRecommendEnable = window.parentRecommendEnable;
	var url = jsURL + "?method=theNewAddDoc&parentId=" + parentId + "&frType=" + frType + "&docLibId=" + docLibId 
		+ "&docLibType=" + docLibType + "&bodyType="+bodyType + "&all=" + all + "&edit=" + edit 
		+ "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list + "&parentRecommendEnable=" + parentRecommendEnable
		+ "&parentCommentEnabled=" + parentCommentEnabled + "&parentVersionEnabled=" + parentVersionEnabled + "&parentPath=" + parentPath + "&flag=formBizConfig";
	location.href = url;
}
// 执行上传文件操作
function fileUpload(flag) {
	var contentMenuObj = document.getElementById(flag);
	if(contentMenuObj && contentMenuObj.disabled) return;
	var docResId = window.docResId;
	var docLibId = window.docLibId;
	var docLibType = window.docLibType;
	var parentCommentEnabled = window.parentCommentEnabled;
	var parentVersionEnabled = window.parentVersionEnabled;
	var parentRecommendEnable = window.parentRecommendEnable;
	
	if(window.add=='false'){
		return;
	}
	
	fileUploadQuantity = 5;
	// 清空缓存
	fileUploadAttachments.clear();		
	insertAttachment(null, null, 'callbackInsertAttachment', 'false');
}

function callbackInsertAttachment(){
	if(fileUploadAttachments.isEmpty() == false) {
		saveAttachment();
		var the_form = document.getElementById("mainForm");
		the_form.target = "delIframe";
		the_form.action = jsURL + "?method=docUpload&docResourceId=" + docResId + "&docLibId=" + docLibId + "&parentRecommendEnable=" + parentRecommendEnable
				+ "&docLibType=" + docLibType + "&parentCommentEnabled=" + parentCommentEnabled + "&parentVersionEnabled=" + parentVersionEnabled;
		the_form.submit();			
	}
}
// 新建文档保存
var whitespace = " \t\n\r";
function addDocument(docLibId,docLibType,folderId,frType,all,edit,add,readonly,browse,list,parentCommentEnabled,parentRecommendEnable,bodyType, parentPath, flag, parentVersionEnabled,methodName) {
	disableDocButtons('false');
	var existFlag = validateParent(folderId, parentPath);
	if(existFlag == 'delete'){
		alert(v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
				isFormSumit = true;
		enableDocButtons('false');
		parent.location.reload(true);
		return;
	}else if(existFlag == 'move'){
		alert(v3x.getMessage('DocLang.doc_alert_source_move_folder'));
				isFormSumit = true;
		enableDocButtons('false');
		parent.location.reload(true);
		return;
	}
	
	if(!checkForm(addDoc)){
		if(V3X.checkFormAdvanceAttribute=="docAdvance"){
			editDocProperties('0');
		}
		enableDocButtons('false');
		return;
	}
// getA8Top().startProc();
	if(!saveOffice()){
		enableDocButtons('false');
		return;	
	}
	
	var ctid = 21;
	if(window.contentSelect == 'true')
		ctid = document.getElementById("contentTypeId").value;
		var exist = dupliName(folderId, document.addDoc.docName.value, ctid, false);
		
		if(exist == 'false'){
			isFormSumit = true;	
			var contentTypeFlag = 'true';
			if(docLibType != '1'){
				
				contentTypeFlag = contentTypeExist(ctid);
			}

			if(contentTypeFlag == 'false'){
				alert(v3x.getMessage("DocLang.doc_alert_doctype_deleted"));
				window.history.back(-1);
			}else{	
			    methodName=(methodName===undefined)?"addDocument":methodName;
				saveAttachment();
				document.addDoc.action = jsURL + "?method="+methodName+"&docLibId=" + docLibId + "&docLibType=" + docLibType
				+ "&resId=" + folderId + "&frType=" + frType + "&isShareAndBorrowRoot=false" + "&all=" + all + "&edit=" + edit 
				+ "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list + "&parentRecommendEnable=" + parentRecommendEnable
				+ "&parentCommentEnabled=" + parentCommentEnabled + "&flag="+flag + "&parentVersionEnabled=" + parentVersionEnabled;
				document.addDoc.submit();
			}
		}else{
			alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert',document.addDoc.docName.value));
			enableDocButtons('false');
			document.addDoc.docName.focus();
		}
		if(methodName==="addDocument"){
		    if(parent.layout){
		        if(parent.layout.cols == "0,*") {
		            parent.layout.cols = "140,*";
		            parent.document.getElementById("treeFrame").noResize=false; 
		        }
		        else {
		            parent.document.getElementById("treeFrame").noResize=false; 
		        }
		    }
		}else{
		    
		}
}
function addProDocument(docLibId,docLibType,folderId,frType,bodyType,commentEnabled,versionEnabled, recommendEnable,projectId, projectPhaseId){	
	if(!checkForm(addDoc)){
		if(V3X.checkFormAdvanceAttribute=="docAdvance"){
			editDocProperties('0');
		}
		return;
	}	
	
    isFormSumit = true;
	if(!saveOffice()){
		   enableDocButtons('false');
           return;	
	 } 
    var ctid = 21;
        ctid = document.getElementById("contentTypeId").value;
 	var exist = dupliName(folderId, document.addDoc.docName.value, ctid, false);
	if(exist == 'false') {
		   var contentTypeFlag = 'true';
	       saveAttachment();
		   document.addDoc.action = jsURL + "?method=addProDocument&docLibId=" + docLibId + "&docLibType=" + docLibType + "&parentRecommendEnable=" + recommendEnable
		      + "&resId=" + folderId + "&frType=" + frType + "&isShareAndBorrowRoot=false&parentCommentEnabled="+commentEnabled+"&parentVersionEnabled="+versionEnabled + "&projectId=" + projectId + "&projectPhaseId="+projectPhaseId;
	       disableDocButtons('false');
		   document.addDoc.submit();
	} else {
		alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert',document.addDoc.docName.value));
	    enableDocButtons('false');
	    document.addDoc.docName.focus();
	}
	
	if(parent.layout) {
		if(parent.layout.cols == "0,*") {
			parent.layout.cols = "140,*";
			parent.document.getElementById("treeFrame").noResize=false;	
		}
		else {
			parent.document.getElementById("treeFrame").noResize=false;	
		}
	}
}
function contentTypeExist(typeid) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "contentTypeExist", false);
		requestCaller.addParameter(1, "long", typeid);
		var flag = requestCaller.serviceRequest();
		return flag;
	}
	catch (ex1) {
		return 'false';
	}
}
/**
 * 控制文档新建，修改页面的button
 */
function disableDocButtons(edit){
	try{
		disableButton('save');
		disableButton('insert');
		if(edit == 'false')
			disableButton('back');	
	}catch(e){}
}
function enableDocButtons(edit){
	try{
		enableButton('save');
		enableButton('insert');
		if(edit == 'false')
			enableButton('back');	
		getA8Top().endProc();
	}catch(e){}
}
// 判断当前文档夹是否存在同名同类型文档 ajax实现
function dupliName(parentId, name, type, stringType) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "hasSameNameAndSameTypeDr", false);
		requestCaller.addParameter(1, "Long", parentId);
		requestCaller.addParameter(2, "String", name);
		if(stringType)
			requestCaller.addParameter(3, "String", type);
		else
			requestCaller.addParameter(3, "Long", type);
				
		var flag = requestCaller.serviceRequest();
		return flag;
	}
	catch (ex1) {
		alert("Exception : " + ex1.message);
	}
}
// 执行替换文件操作 ，点击操作lable的替换就执行此方法
var docReplaceItem = {};
function docReplace(docResId, docLibType, objName,parentId,frtype) {
	docReplaceItem.docResId = docResId;
	docReplaceItem.docLibType = docLibType;
	docReplaceItem.objName = objName;
	docReplaceItem.parentId = parentId;
	docReplaceItem.frtype = frtype;
	if(checkLock(docResId, false) == false) {
		return;
	}
	
	fileUploadQuantity = 1;
	fileUploadAttachments.clear();		// 清空缓存
	insertAttachment(null, null, 'callbackInsertAttachmentReplace', 'false');
}

function callbackInsertAttachmentReplace () {
	if(fileUploadAttachments.isEmpty() == false) {
		var keys=fileUploadAttachments.keys();
		var attach=fileUploadAttachments.get(keys.get(0),null);	// 附件对象
		
		if(docReplaceItem.objName != attach.filename){
			if(!window.confirm(v3x.getMessage('DocLang.doc_replace_different_name_confirm'))){
				fileUploadAttachments.clear();	
				return;
			}
			var typeId = 21;// 21 说明是文件的比较
	
			var exist = dupliName(docReplaceItem.parentId,attach.filename,typeId,false);
	
			if('true' == exist){
				alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert',attach.filename));
				return;
			}
		}
		
		saveAttachment();
		var theForm = document.mainForm;
		theForm.target = "empty";
		theForm.action = jsURL + "?method=docReplace&docLibType=" + docReplaceItem.docLibType + "&docResId=" + docReplaceItem.docResId;
		theForm.submit();
	}
}
// 查看文档日志
function logView(id, isFolder, name) {
	var theURL = jsURL + "?method=docLogViewIframe&docResId=" + id + "&docLibId=" + docLibId + "&isFolder=" + isFolder ;
	var openArgs = {};
	openArgs["url"] = theURL;
	if(v3x.getBrowserFlag('openWindow') == false){
		openArgs["dialogType"] = "open";
	}
	openArgs["workSpace"] = 'yes';
	openArgs["resizable"] = 'false';

	var log = v3x.openWindow(openArgs);
}
/***********************************************************************************************************************
 * grant beigin
 */
function grantFunction() {	  	

	var docResId = window.docResId;
	var docLibType = window.docLibType;
 				
	var flagisM = "false";
	var flagisC = "false";			
	if(docLibType == DocLib_Type_Private) {
		flagisM = "true";			
	}
	else {
		flagisC = "true";
	}
	var surl = baseurl + "/doc.do?method=docPropertyIframe&isP=false&isB=false&isM=" + flagisM + "&isC=" + flagisC
			 + "&docResId=" + docResId + "&docLibType=" + docLibType + "&isFolder=true";					 
	
	var movevalue = v3x.openWindow({
		url : surl,
		width : "500",
		height : "500",
		resizable : "false"
	});
	if(movevalue == "true") {
		window.location.reload(true);
	}
	
}
/***********************************************************************************************************************
 * grant end
 **********************************************************************************************************************/

/***********************************************************************************************************************
 * myDocument Grant begin create by xuegw
 */
var MyPeoplemap = new Properties();
function setMyPeopleFields(elements, accountId) {
	if(!elements) {
		return;
	}
 
	var grantT = document.getElementById("mygrantgrantId");	
	var elementSize  = myOriginalElements.size();

	for(var i = 0 ;i < elementSize ; i ++){
		if(document.getElementById("mygrantuid"+i)==null){
              elementSize++;//有bug，当一直找不到对象时，死循环了，muyx
			  continue;
		 }
		var mygrantuserid = document.getElementById("mygrantuid"+i).value;	
		MyPeoplemap.put(mygrantuserid,mygrantuserid);
	}
	ucfPersonalShare = true;
	myOriginalElements = new ArrayList() ;
	if(myOriginalElements != null) {
		var osize = myOriginalElements.size();
		var len = window.perShareNum;
		for(var i = 0; i < elements.length; i++) {			 
			
			for(var j = 0; j < osize; j++) {
							
				if(myOriginalElements.contains(elements[i].id)) {
					
					continue;
				}
				var theName = getNameString(elements[i], accountId);	
				if(MyPeoplemap.get(elements[i].id) == null){
				var tr = grantT.insertRow(-1);
				tr.id = elements[i].id;
				var td0 = tr.insertCell(-1);
							td0.align = "center";
				td0.innerHTML = "<input type='checkbox'  name='mygrantid' value='" + elements[i].id + "' />";
				td0.className = "sort";
				var td = tr.insertCell(-1);
					
				td.innerHTML = theName + "<input type='hidden' name='mygrantusername' value='" + theName + "'> "
							+ "<input type='hidden' name=mygrantuid" + len + " id='mygrantuid" +len+ "' value='" + elements[i].id + "'>"
							+ "<input type='hidden' name=mygrantutype" + len +" id='mygrantutype" +len+  "' value='" + elements[i].type + "'>"
							+ "<input type='hidden' name=mygrantinherit" + len +" id='mygrantinherit" +len+  "' value='false'>"
							+ "<input type='hidden' name=mygrantalert" + len +" id='mygrantalert" +len+  "' value='false'>	"	
							+ "<input type='hidden' name=mygrantaclid" + len +" id='mygrantaclid" +len+  "' value='0'>	"		
							+ "<input type='hidden' id=mygrantalertnew" + len + " name=mygrantalertnew" + len + " value='false'>	"	
							+ "<input type='hidden' name=mygrantalertid" + len +" id='mygrantalertid" +len+  "' value=''>	";	
				
				// alert(td.innerHTML)
				myOriginalElements.add("" + elements[i].id + "");
				
				td.className = "sort";	
				
				var td1 = tr.insertCell(-1);
							td1.align = "center";
				td1.innerHTML = "<input type='checkbox' id='mygrantalertckb" + len + "' name='mygrantalertckb" + len +"' value='" + elements[i].id 
						+ "' onchange=\"userChange('ucfPersonalShare')\""
						+ " onclick=\"mygrantalert('" + len + "')\"/>";
				td1.className = "sort";													
				
				len += 1;
			} // end for-loop
			}
		}	// end for-loop
		window.perShareNum = len;
	} // end if
	
	if(myOriginalElements.size() == 0) {
	    var len = window.perShareNum;
		for(var i = 0; i < elements.length; i++){
			var theName = getNameString(elements[i], accountId);	
			if(MyPeoplemap.get(elements[i].id) == null){
			var tr = grantT.insertRow(-1);
			tr.id = elements[i].id;
			var td0 = tr.insertCell(-1);
						td0.align = "center";
			td0.innerHTML = "<input type='checkbox' name='mygrantid' value='" + elements[i].id + "' />";
			td0.className = "sort";
			var td = tr.insertCell(-1);
				
			td.innerHTML = theName + "<input type='hidden' name='mygrantusername' value='" + theName + "'> "
						+ "<input type='hidden' name=mygrantuid" + (len+i) + " value='" + elements[i].id + "'>"
						+ "<input type='hidden' name=mygrantutype" + (len+i) + " value='" + elements[i].type + "'>"
						+ "<input type='hidden' name=mygrantinherit" + (len+i) + " value='false'>	"
						+ "<input type='hidden' name=mygrantalert" + (len+i) + " value='false'>	"	
						+ "<input type='hidden' name=mygrantaclid" + (len+i) + " value='0'>	"		
						+ "<input type='hidden' id=mygrantalertnew" + (len+i) + " name=mygrantalertnew" + (len+i) + " value='false'>	"	
						+ "<input type='hidden' name=mygrantalertid" + (len+i) + " value=''>	";	
			myOriginalElements.add("" + elements[i].id + "");
			// alert(td.innerHTML)
			td.className = "sort";	
			
			var td1 = tr.insertCell(-1);
			td1.align = "center";
				td1.innerHTML = "<input type='checkbox' id='mygrantalertckb" + (len+i) + "' name='mygrantalertckb" + (len+i) +"' value='" + elements[i].id 
					+ "' onchange=\"userChange('ucfPersonalShare')\""
					+ " onclick=\"mygrantalert('" + (len+i) + "')\"/>";
			td1.className = "sort";		
			}
			// window.perShareNum = i + 1;
		}
		window.perShareNum = len+elements.length
		
	} // end if
}
function mygrantdeleteUser() {
  var checkedids = document.getElementsByName('mygrantid');
  var len = checkedids.length;
  var count = 0;
  for(var i = 0; i < len; i++) {
  		var checkedid = checkedids[i];
		
		if(checkedid && checkedid.checked && checkedid.parentNode.parentNode.tagName == "TR"){			
			checkedid.parentNode.parentNode.parentNode.removeChild(checkedid.parentNode.parentNode);
			myOriginalElements.remove("" + checkedid.value + "");
			i--;
			count++;
		}
	}
	
	if(count == 0){
   		alert(v3x.getMessage("DocLang.doc_delete_select_alert"));
   }else{
		ucfPersonalShare = true;
   }
}
/***********************************************************************************************************************
 * myDocument Grant end create by xuegw
 **********************************************************************************************************************/
 
/***********************************************************************************************************************
 * docgrant begin create by xuegw
 */
 
var grantsetpepomap = new Properties();
function docGrantSetPeopleFields(elements, accountId) {
	if(!elements) {
		return;
	}		
	ucfPublicShare = true;
	var elementSize  = originalElements.size();
	
	var grantT = document.getElementById("grantId");
	//这个代码只有第一次添加时是逻辑正确的。连续添加时，直接修改缓存吧。
	for(var i = 0 ; i < elementSize ; i++ ){
		 // grantT.deleteRow(1) ;
		 if(document.getElementById("uid"+i)==null){
              elementSize++;
			  continue;
		 }
		 var uid = document.getElementById("uid"+i).value;
		 grantsetpepomap.put(uid,uid);
	}
	//originalElements = new ArrayList() ;
	var isGroupRes = window.isGroupLib;
		
	if(originalElements != null) {
		var osize = originalElements.size();
		var len = window.deptShareNum;
		// 下面的这个嵌套for，根本就不可能执行
		for(var i = 0; i < elements.length; i++) {
		 		
			for(var j = 0; j < osize; j++) {
							
				if(originalElements.contains(elements[i].id)) {					
					continue;
				}
				if(grantsetpepomap.get(elements[i].id) == null){
				var tr = grantT.insertRow(-1);
				tr.id = elements[i].id;
				var td0 = tr.insertCell(-1);
				td0.align = "center";
				td0.innerHTML = "<input type='checkbox' name='id' value='" + elements[i].id + "' />";
				td0.className = "sort";
				var td = tr.insertCell(-1);
				
				var theName = getNameString(elements[i], accountId);	
				if(isGroupRes == 'true'){
					var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
						 "getEntityNameWithAccountShort", false);
					requestCaller.addParameter(1, "String", elements[i].type);
					requestCaller.addParameter(2, "Long", elements[i].id);
							
					theName = requestCaller.serviceRequest();
				}
				
				td.innerHTML = theName + "<input type='hidden' name='username' value='" + theName + "'> "
							+ "<input type='hidden' id=uid" + len + " name=uid" + len + " value='" + elements[i].id + "'>"
							+ "<input type='hidden' name=utype" + len + " value='" + elements[i].type + "'>"
							+ "<input type='hidden' name=inherit" + len + " value='false'>	";
				
				originalElements.add("" + elements[i].id + "");
				
				td.className = "sort";
				
				var td1 = tr.insertCell(-1);
				td1.align = "center";
				td1.innerHTML = '<input type="checkbox" name="cAll' + len + '" id="cAll' + len 
					+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" >';
				
				td1.className = "sort";
				
				var td2 = tr.insertCell(-1);
				td2.align = "center";
				td2.innerHTML = '<input type="checkbox" name="cEdit' + len + '" id="cEdit' + len 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" >';
				
				td2.className = "sort";
				
				var td3 = tr.insertCell(-1);
				td3.align = "center";
				td3.innerHTML = '<input type="checkbox" name="cAdd' + len + '" id="cAdd' + len 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" >';
				
				td3.className = "sort";
				
				var td4 = tr.insertCell(-1);
				td4.align = "center";
				td4.innerHTML = '<input type="checkbox" name="cRead' + len + '" id="cRead' + len 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" checked>';
				
				td4.className = "sort";
				
				var td5 = tr.insertCell(-1);
				td5.align = "center";
				td5.innerHTML = '<input type="checkbox" name="cBrowse' + len + '" id="cBrowse' + len 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" checked>';
				
				td5.className = "sort";
				
				var td6 = tr.insertCell(-1);
				td6.align = "center";
				td6.innerHTML = '<input type="checkbox" name="cList' + len + '" id="cList' + len 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" checked>';
				
				td6.className = "sort";
				
				var td7 = tr.insertCell(-1);
				td7.align = "center";
				td7.innerHTML = '<input type="checkbox" name="cAlert' + len + '" id="cAlert' + len 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + len + '\')"'
					+ ' value="true" >';
				
				td7.className = "sort";
										
				len += 1;
			}
			}
		}	
		window.deptShareNum = len;
	}

	if(originalElements.size() == 0) {
    	 var len = window.deptShareNum;
		for(var i = 0; i < elements.length; i++){
			if(grantsetpepomap.get(elements[i].id) == null){
			var tr = grantT.insertRow(-1);
			tr.id = elements[i].id;
			var td0 = tr.insertCell(-1);
			td0.align = "center";
			td0.innerHTML = "<input type='checkbox' id='docGrant"+(len+i)+"' name='id' value='" + elements[i].id + "' />";
			td0.className = "sort";
			var td = tr.insertCell(-1);
			
			var theName = getNameString(elements[i], accountId);	
			if(isGroupRes == 'true'){
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
					 "getEntityNameWithAccountShort", false);
				requestCaller.addParameter(1, "String", elements[i].type);
				requestCaller.addParameter(2, "Long", elements[i].id);
						
				theName = requestCaller.serviceRequest();
			}
			
			td.innerHTML = theName + "<input type='hidden' name='username' value='" + theName + "'> "
						+ "<input type='hidden' name=uid" + (len+i) + " value='" + elements[i].id + "'>"
						+ "<input type='hidden' name=utype" + (len+i) + " value='" + elements[i].type + "'>"
						+ "<input type='hidden' name=inherit" +(len+i)+ " value='false'>	";
			originalElements.add("" + elements[i].id + "");
			
			td.className = "sort";
			
			var td1 = tr.insertCell(-1);
			td1.align = "center";
			td1.innerHTML = '<input type="checkbox"  name="cAll' + (len+i) + '" id="cAll' +(len+i) 
										+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + (len+i) + '\')"'
					+ ' value="true" >';
			
			td1.className = "sort";
			
			var td2 = tr.insertCell(-1);
			td2.align = "center";
			td2.innerHTML = '<input type="checkbox" name="cEdit' + (len+i) + '" id="cEdit' +(len+i)
															+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + (len+i) + '\')"'
					+ ' value="true" >';
			
			td2.className = "sort";
			
			var td3 = tr.insertCell(-1);
			td3.align = "center";
			td3.innerHTML = '<input type="checkbox" name="cAdd' + (len+i) + '" id="cAdd' + (len+i) 
															+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + (len+i) + '\')"'
					+ ' value="true" >';
			
			td3.className = "sort";
			
			var td4 = tr.insertCell(-1);
			td4.align = "center";
			td4.innerHTML = '<input type="checkbox" name="cRead' + (len+i) + '" id="cRead' + (len+i) 
															+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + (len+i) + '\')"'
					+ ' value="true" checked>';
			
			td4.className = "sort";
			
			var td5 = tr.insertCell(-1);
			td5.align = "center";
			td5.innerHTML = '<input type="checkbox" name="cBrowse' +(len+i) + '" id="cBrowse' + (len+i) 
															+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + (len+i) + '\')"'
					+ ' value="true" checked>';
			
			td5.className = "sort";
			
			var td6 = tr.insertCell(-1);
			td6.align = "center";
			td6.innerHTML = '<input type="checkbox" name="cList' +(len+i) + '" id="cList' +(len+i) 
															+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' +(len+i) + '\')"'
					+ ' value="true" checked>';
			
			td6.className = "sort";
			
			var td7 = tr.insertCell(-1);
			td7.align = "center";
			td7.innerHTML = '<input type="checkbox" name="cAlert' + (len+i) + '" id="cAlert' + (len+i) 
														+ '" onchange="userChange(\'ucfPublicShare\')"'
					+ ' onclick="validateAcl(\'' + (len+i) + '\')"'
				+ ' value="true" >';
			
			td7.className = "sort";
			grantsetpepomap.put(elements[i].id,elements[i].id);
			}
			// window.deptShareNum = i + 1;
		}
		// 这有没有考虑添加不成功的情况呢？
		window.deptShareNum = len + elements.length 
	}
 	
}
// -->
function docGrantdeleteUser() {
  var checkedids = document.getElementsByName('id');
  var len = checkedids.length;
  var count = 0;
  for(var i = 0; i < len; i++) {
  		var checkedid = checkedids[i];
		
		if(checkedid && checkedid.checked && checkedid.parentNode.parentNode.tagName == "TR"){			
			checkedid.parentNode.parentNode.parentNode.removeChild(checkedid.parentNode.parentNode);
			originalElements.remove("" + checkedid.value + "");
			i--;
			count++;
			try {
				grantsetpepomap.remove(checkedid.value);
			}catch(e){
				//不用做处理
			}		
		}
	}
   
   if(count == 0){
   		alert(v3x.getMessage("DocLang.doc_delete_select_alert"));
   }else{
	// alert("doc.js ucf::Prop--" + ucfProp+"ucf::Public--" + ucfPublicShare+"ucf::Personal--" +
    // ucfPersonalShare+"ucf::Borrow--" + ucfBorrow)
	ucfPublicShare = true;
   }
}
/**
 * 根据element得到名称，自动判断是否添加单位简称
 */
function getNameString(e, accountId){
		var _name = null;
		if(e.accountId != accountId){
			if(e.accountShortname)
				_name = e.name + "(" + e.accountShortname + ")";
			else{
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
					 "getEntityNameWithAccountShort", false);
				requestCaller.addParameter(1, "String", e.type);
				requestCaller.addParameter(2, "Long", e.id);
						
				_name = requestCaller.serviceRequest();
			}			
		}
		else{
			_name = e.name;
		}
		return _name;
}
var mapdatafield = new Properties();
function borrowSetPeopleFields(elements, accountId) {
	if(!elements) {
		return;
	}
	ucfBorrow = true;

	var borrowgrantT = document.getElementById("borrowgrantId");
	var endTimeLable = v3x.getMessage("DocLang.doc_time_end_lable");
	var startTimeLable = v3x.getMessage("DocLang.doc_time_start_lable");
	for(var i = 0 ; i<originalElementsborrow.size(); i++) {
		var borrowuid ;
		if(document.getElementById("borrowuid"+i)) { 
			borrowuid = document.getElementById("borrowuid"+i).value;
		//增加防护，防止为空	
		} else if(document.getElementById("borrowuid"+(i+1))){
			borrowuid = document.getElementById("borrowuid"+(i+1)).value;
		}
		//增加防护，防止为空	
		if(borrowuid)
		mapdatafield.put(borrowuid,borrowuid);
	}
	originalElementsborrow = new ArrayList();
	
	var isGroupRes = window.isGroupLib;
	var len = window.borrowNum;
	for(var i = 0; i < elements.length; i++) {
		var theName = getNameString(elements[i], accountId);
		if(isGroupRes == 'true') {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getEntityNameWithAccountShort", false);
			requestCaller.addParameter(1, "String", elements[i].type);
			requestCaller.addParameter(2, "Long", elements[i].id);
			theName = requestCaller.serviceRequest();
		}
		if(mapdatafield.get(elements[i].id) == null){
			var tr = borrowgrantT.insertRow(-1);
			tr.id = elements[i].id; 
			var td0 = tr.insertCell(-1);
			td0.align = "center";
			td0.innerHTML = "<input type='checkbox' name='borrowid' value='" + elements[i].id + "' />";
			td0.className = "sort";
			var td = tr.insertCell(-1);
			td.title = theName;
			td.innerHTML = theName.getLimitLength(16,"..") + "<input type='hidden' name='borrowusername' value='" + theName + "'><input type='hidden' name=borrowusername" + (len + i) + " id='borrowusername"+(len + i)+"' value='" + theName + "'> "
						+ "<input type='hidden' name=borrowuid" + (len + i) + " id='borrowuid"+(len + i)+"' value='" + elements[i].id + "'>"
						+ "<input type='hidden' name=borrowutype" + (len + i) + " id='borrowutype"+(len + i)+"' value='" + elements[i].type + "'>";
			originalElementsborrow.add("" + elements[i].id + "");
			mapdatafield.put("" + elements[i].id + "", "" + elements[i].id + "");
			
			td.className = "sort";
			var dateWidth = "";
			if(doc_fr_type=="2")// 公文增加借阅权限
			{
				var td3=tr.insertCell(-1); 
				td3.innerHTML="<select name='lenPotent"+(len + i)+"'><option value='1'>"+lenPotentLan_all+"</option><option value='2' selected>"+lenPotentLan_content+"</option></select>";
				td3.className = "sort";
				var td4=tr.insertCell(-1); 
				td4.innerHTML="<input type='checkbox' name='lenPotent2a"+(len + i)+"' value='1'>"+lenPotentLan_save+" <input type='checkbox' name='lenPotent2b"+(len + i)+"' value='2'>"+lenPotentLan_print;
				td4.className = "sort";
				dateWidth = ' style=\"width:72px\" ';
				var td1 = tr.insertCell(-1);

				td1.innerHTML = '<input readonly="readonly" type=text validate="notNull" inputName=\"'+startTimeLable+'" name=begintime' + (len + i) + ' value=' + dtb.substring(0, 10) + dateWidth
				
				+ ' onclick=\'whenstart(\"' + contpath + '\",this,300,200,"date");userChangeCalendar(this,"'+dtb+'")\'>';
			
			td1.className = "sort";
			
			var td2 = tr.insertCell(-1);
			td2.innerHTML = '<input readonly="readonly" validate="notNull" inputName=\"'+endTimeLable+'" type=text name=endtime' + (len + i) + ' value=' + dte.substring(0, 10) + dateWidth
				
				+ ' onclick=\'whenstart(\"' + contpath + '\",this,300,200,"date");userChangeCalendar(this,"'+dte+'")\'>';
			
			td2.className = "sort";	
						
			}else{
			var td1=tr.insertCell(-1);
				td1.innerHTML='<input type="checkbox" name=\"bRead'+ (len + i) + '\" id=\"bRead' +(len + i) +'\" value="true" checked>';
				td1.className = "sort";

		    var td2=tr.insertCell(-1); 
				td2.innerHTML='<input type="checkbox" name=\"bBrowse'+ (len + i) + '\" id=\"bBrowse' +(len + i) +'\" value="true" checked>';
				td2.className = "sort";
			
			dateWidth = ' style=\"width:90px\" ';
			
			var td3 = tr.insertCell(-1);

				td3.innerHTML = '<input readonly="readonly" type=text validate="notNull" inputName=\"'+startTimeLable+'" name=begintime' + (len + i) + ' value=' + dtb.substring(0, 10) + dateWidth
				
				+ ' onclick=\'whenstart(\"' + contpath + '\",this,300,200,"date");userChangeCalendar(this,"'+dtb+'")\'>';
			
			    td3.className = "sort";
			
			var td4 = tr.insertCell(-1);
			    td4.innerHTML = '<input readonly="readonly" validate="notNull" inputName=\"'+endTimeLable+'" type=text name=endtime' + (len + i) + ' value=' + dte.substring(0, 10) + dateWidth
				
				+ ' onclick=\'whenstart(\"' + contpath + '\",this,300,200,"date");userChangeCalendar(this,"'+dte+'")\'>';
			
			    td4.className = "sort";	
			}
						
		}			
			

	}
	window.borrowNum = elements.length + len;	
}
/***********************************************************************************************************************
 * borrow grant create by xuegw end
 **********************************************************************************************************************/

/**
 * 发送文档或文档夹到常用文档。
 */
function addMyFavorite(rowid){
	var aUrl = jsURL + "?method=sendToFavorites&userType=member";
	var checkid = rowid;
	var mainForm = document.getElementById("mainForm");
	if (checkid == "undefined"){
		mainForm.target = "empty";
		mainForm.action = aUrl;
		if(hasSelectedData()){
			if(!fnValidInfo(rowid)){
				return;
			}	
			mainForm.submit();
		}else{
			return;
		}
	}
	else {
		mainForm.target = "empty";
		mainForm.action = aUrl + "&docId=" + rowid;
		if(!fnValidInfo(rowid)){
			return;
		}
		mainForm.submit();
	}

}

/**
 * 判断是否选了列表数据，菜单项使用
 */
function hasSelectedData(){
	var chkid = document.getElementsByName('id');// alert(chkid)
	var checked = false;
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			checked = true;
			break;
		}
	}
	// alert(checked)
	if(!checked) {
		alert(v3x.getMessage("DocLang.doc_more_select_alert"))
		return false;
	}else
		return true;
	    
}
/*
 * 得到选中的条数
 */
function getSelectedCount(){
	var chkid = document.getElementsByName('id');// alert(chkid)
	var count = 0;
	var id;
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			count++;
			id = chkid[i].value;
		}
	}
	
	return count;    
}
/**
 * 得到选中的id串
 */
 function getSelectedIds(){
	var chkid = document.getElementsByName('id');// alert(chkid)
// var count = 0;
	var ids = "";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
// count++;
			ids += "," + chkid[i].value;
		}
	}
	
	if(ids != "")
		ids = ids.substring(1, ids.length);
	return ids;    
}


// 发送到部门文档
function sendToDeptDoc(depAdminSize, flag){
	if('right' == flag){// alert(111)
		document.mainForm.target = "empty";
		document.mainForm.action = jsURL + "?method=sendToFavorites&docId=&userIds=&userType=dept";
		
		if(!hasSelectedData()){
			return;
		}
			
		if(!fnValidInfo('undefined')){
			return;
		}
		
		if(depAdminSize == '1'){
			document.mainForm.submit();
		}else{
			var theURL = jsURL + "?method=selectDepts";
	    	getA8Top().selectDeptWin = getA8Top().$.dialog({
	            title:v3x.getMessage('DocLang.doc_send_to_dept'),
	            transParams:{'parentWin':window,'type':'doc'},
	            url: theURL,
	            width: 360,
	            height: 240,
	            isDrag:false
	        });
		}
	}else{
		if(!fnValidInfo('undefined')){
			return;
		}
	   // if(!hasSelectedData())
		// return;
		if(depAdminSize == '1'||false){
			mainForm.target = "empty";
			mainForm.action = jsURL + "?method=sendToFavorites&docId=" + mainForm.selectedRowId.value  
				+ "&userIds=&userType=dept";
			mainForm.submit();
		}else{
			var theURL = jsURL + "?method=selectDepts";
	    	getA8Top().selectDeptWin = getA8Top().$.dialog({
	            title:v3x.getMessage('DocLang.doc_send_to_dept'),
	            transParams:{'parentWin':window,'type':'doc'},
	            url: theURL,
	            width: 360,
	            height: 240,
	            isDrag:false
	        });
		}
	}
	
}

function sendToDeptDocCollBack(depts,types) {
	getA8Top().selectDeptWin.close();
	if(depts == "" || depts == undefined)
		return;
	mainForm.target = "empty";
	if (types == 'doc') {
		mainForm.action = jsURL + "?method=sendToFavorites&docId=" + mainForm.selectedRowId.value  
			+ "&userIds="+ depts +"&userType=dept";
	} else if (types == 'lean') {
		mainForm.action = jsURL + "?method=sendToLearn&docId=" + mainForm.selectedRowId.value  
			+ "&userIds="+ depts +"&userType=dept";
		if(!fnValidInfo(mainForm.selectedRowId.value)){
			return;
		}
	}
	mainForm.submit();
}

/**
 * 发布文档或文档夹到单位空间
 */
function publishDoc(rowid) {
	var aUrl = jsURL + "?method=sendToFavorites&userType=account";
	var checkid = rowid;
	if (checkid == "undefined"){
		document.mainForm.target = "empty";
		document.mainForm.action = aUrl;

		if(!hasSelectedData()){
			return;		
		}
		
		if(!fnValidInfo(rowid)){
			return;
		}
		document.mainForm.submit();
	}else {
		mainForm.target = "empty";
		mainForm.action = aUrl + "&docId=" + rowid;
		if(!fnValidInfo(rowid)){
			return;
		}
		mainForm.submit();
	}
}

// 发送到个人学习区
function sendToLearn(elements, flag){
	if(!elements) {
		return;
	}
	var ids = "";
	for(var i = 0; i < elements.length; i++) {								
		ids += "," + elements[i].id+'|'+elements[i].type;	
	}
	//右键菜单
	if('pop' == flag){
		document.mainForm.target = "empty";
		mainForm.action = jsURL + "?method=sendToLearn&docId=" + mainForm.selectedRowId.value 
		+ "&userIds=" + ids.substring(1, ids.length) + "&userType=member";
		
		if(!fnValidInfo(mainForm.selectedRowId.value)){
			return;
		}
		
		document.mainForm.submit();

	}else{
		mainForm.target = "empty";
		mainForm.action = jsURL + "?method=sendToLearn&userIds=" + ids.substring(1, ids.length) + "&userType=member";
		if(!fnValidInfo('undefined')){
			return;
		}
		mainForm.submit();
	}


}

// 发送到单位学习区
function sendToAccountLearn(flag){
	if('right' == flag){
		document.mainForm.target = "empty";
		document.mainForm.action = jsURL + "?method=sendToLearn&docId=&userIds=&userType=account";

		if(!hasSelectedData())
			return;
		if(!fnValidInfo('undefined')){
			return;
		}
		document.mainForm.submit();
	}else{
		mainForm.target = "empty";
		mainForm.action = jsURL + "?method=sendToLearn&docId=" + mainForm.selectedRowId.value 
			+ "&userIds=&userType=account";
		if(!fnValidInfo(mainForm.selectedRowId.value)){
			return;
		}
		mainForm.submit();
	}
	

}

// 发送到部门学习区
function sendToDeptLearn(depAdminSize, flag){
	// var mf = document.getElementById('mainForm');
	// mainForm 在 打开页面菜单、右键弹出菜单 可以拿到
	// 在 列表菜单 拿不到
	if('right' == flag){
		document.mainForm.target = "empty";
		document.mainForm.action = jsURL + "?method=sendToLearn&docId=&userIds=&userType=dept";

		if(!hasSelectedData())
			return;
			
		if(depAdminSize == '1'){
			if(!fnValidInfo('undefined')){
				return;
			}
			document.mainForm.submit();
		}else{
			var theURL = jsURL + "?method=selectDepts";
			getA8Top().selectDeptWin = getA8Top().$.dialog({
	            title:v3x.getMessage('DocLang.doc_send_to_dept'),
	            transParams:{'parentWin':window,'type':'lean'},
	            url: theURL,
	            width: 360,
	            height: 240,
	            isDrag:false
	        });
		}

	}else{
	
	 	// if(!hasSelectedData())
		// return;
		if(depAdminSize == '1'){
			mainForm.target = "empty";
			mainForm.action = jsURL + "?method=sendToLearn&docId=" + mainForm.selectedRowId.value  
				+ "&userIds=&userType=dept";
			if(!fnValidInfo(mainForm.selectedRowId.value)){
				return;
			}
			mainForm.submit();
		}else{
			var theURL = jsURL + "?method=selectDepts";
	    	
			getA8Top().selectDeptWin = getA8Top().$.dialog({
	            title:v3x.getMessage('DocLang.doc_send_to_dept'),
	            transParams:{'parentWin':window,'type':'lean'},
	            url: theURL,
	            width: 360,
	            height: 240,
	            isDrag:false
	        });
		}
	}
	
}

/**
 * 发送到集团首页
 */
 function sendToGroup(rowid) {
	var aUrl = jsURL + "?method=sendToFavorites&userType=group";
	var checkid = rowid;
	if (checkid == "undefined"){
		document.mainForm.target = "empty";
		document.mainForm.action = aUrl;

		if(!hasSelectedData()){
			return;
		}
		
		if(!fnValidInfo(rowid)){
			return;
		}
		
		document.mainForm.submit();

	}else{
		mainForm.target = "empty";
		mainForm.action = aUrl + "&docId=" + rowid;
		
		if(!fnValidInfo(rowid)){
			return;
		}
		mainForm.submit();
	}
}
/**
 * 发送到集团学习区
 */
 function sendToGroupLearn(flag){
	if('right' == flag){
		document.mainForm.target = "empty";
		document.mainForm.action = jsURL + "?method=sendToLearn&docId=&userIds=&userType=group";

		if(!hasSelectedData())
			return;
		
		if(!fnValidInfo('undefined')){
			return;
		}
		document.mainForm.submit();

	}else{
		mainForm.target = "empty";
		mainForm.action = jsURL + "?method=sendToLearn&docId=" + mainForm.selectedRowId.value 
			+ "&userIds=&userType=group";
		if(!fnValidInfo(mainForm.selectedRowId.value)){
			return;
		}
		mainForm.submit();
	}
}

// 学习记录查看
function learnHistoryView(docid, isGroupLib){
	var theURL = jsURL + "?method=docLearningHistoryIframe&docId=" + docid + "&isGroupLib=" + isGroupLib;
	var openArgs = {};
	openArgs["url"] = theURL;
	openArgs["width"] = '800';
	openArgs["height"] = '700';
	if(v3x.getBrowserFlag('openWindow') == false){
		openArgs["dialogType"] = "open";
	} 
	v3x.openWindow(openArgs);
}
function openDialog4Ipad(url){
	 window.top.winMove=getA8Top().$.dialog({
    	 id:"moveDoc",
    	 title:v3x.getMessage('DocLang.doc_move_to'),
    	 url : url,
    	 width: 500,
    	 height: 500,
    	 targetWindow:window.top,
    	 transParams:{"parentWin":window},
    	 // relativeElement:obj,
    	 buttons:[{
    	 id:'b1',
    	 text: v3x.getMessage("DocLang.submit"),
    	 handler: function(){
    	        var returnValue = top.winMove.getReturnValue();
//    	        if(returnValue) {
//    	        	winMove.close();
//    	        }
	     }
    	            
    	 }, {
    	 id:'b2',
    	 text: v3x.getMessage("DocLang.cancel"),
    	 handler: function(){
    	    top.winMove.close();
    	 }
    	 }]
    });
}

function openDialog4IpadCollBack (returnValue) {
	if (selectDestFolderItems.action == "move" && returnValue == "true") {
		var myKnowledgeLib = top.frames.main.document.getElementById("myKnowledgeLib");
        if(myKnowledgeLib){
            myKnowledgeLib.click();
        }else{
            window.location.reload(true);
        }
	}
	window.top.winMove.close();
}

function closeSendWindow(){
	if(parent.parent.winMove){
		parent.parent.winMove.close();
	}
}
/**
 * 选择目标文档夹。 移动、映射、归档时调用此方法。
 * 
 * @param action [move | link | pigeonhole]
 * @param flag 是否从文档工作区操作
 */
var selectDestFolderItems = {};
function selectDestFolder(rowid, parentId, docLibId, docLibType, action) {
	selectDestFolderItems.action = action;
	var surl = jsURL + "?method=docTreeMoveIframe&parentId=" + parentId	+ "&isrightworkspace=" + action 
			+ "&docLibId=" + docLibId + "&docLibType=" + docLibType;
	var result = "false";
	// flag是否从工作区进行操作!!!
	var checkid = rowid;
	if (checkid == "undefined") {		
		surl += "&flag=false";
		checkid = document.mainForm.id;
		if (checkid == "mainForm") {
			alert(v3x.getMessage('DocLang.doc_more_select_alert'));
			return;
		}
		// alert(checkid.length);
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {			
			if (!checkid.checked) {
				alert(v3x.getMessage('DocLang.doc_more_select_alert'));
				return;
			}
			else {
				if(action == "move"){
				    if(!window.confirm(v3x.getMessage('DocLang.doc_move_alert')))    return;
				}
				//检测是否为收藏，如果为收藏，则追加id
				if(checkid.getAttribute("isCollect")==='true'){
				    surl += "&id="+checkid.value;
				}
				
				if(v3x.getBrowserFlag('openWindow') == false){
					openDialog4Ipad(surl);
				} else {
					result = v3x.openWindow({url:surl, width:"500", height:"500", resizable:"false"});
				}
			}
		} else {
		    var collectId = -1;
		    var collects = document.mainForm.isCollect;
			for (i = 0; i <len; i++) {				
				if (checkid[i].checked == true) {
					if(!checked){
					    checked = true;
					}
					if(collects && collects[i].value == 'true' && collectId == -1){
					    collectId = checkid[i].value;
	                }
					//如果是文档夹，且为个人库时（收藏仅在个人库中），查询文档夹下是否有文档为收藏，有返回
					if((docLibType == 1||docLibType == '1')){
					    var docId = checkid[i].value;
					    var oIsFolder = document.getElementById("isFolder"+docId);
					    
					    if(oIsFolder != null && (oIsFolder.value === 'true') && docId!=null && collectId == -1){
					        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "hasFavoriteDoc", false);
	                        requestCaller.addParameter(1, "Long", docId);
	                        var sDocId = requestCaller.serviceRequest();
	                        if(sDocId !== '-1'){
	                            collectId = sDocId;
	                        }
					    }
					}
				}
			}
			if (!checked) {
				alert(v3x.getMessage('DocLang.doc_more_select_alert'));
				return ;
			}
			else {
				if(action == "move"){
				    if(!window.confirm(v3x.getMessage('DocLang.doc_move_alert')))    return;
				}
				if(collectId!=-1){
				    surl += "&id=" + collectId;
				}
				if(v3x.getBrowserFlag('openWindow') == false){
					openDialog4Ipad(surl);
				} else {
					result = v3x.openWindow({url:surl, width:"500", height:"500", resizable:"false"});
				}
			}
		}
	}
	else {
		surl += "&id=" + checkid + "&flag=true";
				if(action == "move"){
				if(!window.confirm(v3x.getMessage('DocLang.doc_move_alert')))    return;
				}
				if(v3x.getBrowserFlag('openWindow') == false){
					openDialog4Ipad(surl);
				} else {
					result = v3x.openWindow({url:surl, width:"500", height:"500", resizable:"false"});
				}
	}

	if (result == "true" && action == "move") {
	    var myKnowledgeLib = top.frames.main.document.getElementById("myKnowledgeLib");
        if(myKnowledgeLib){
            myKnowledgeLib.click();
        }else{
            window.location.reload(true);
        }
	}
}

function getCollectId(docLibType){
    var collectId = -1;
    var collects = document.mainForm.isCollect;
    for (i = 0; i <len; i++) {              
        if (checkid[i].checked == true) {
            if(!checked){
                checked = true;
            }
            if(collects && collects[i].value == 'true' && collectId == -1){
                collectId = checkid[i].value;
            }
            //如果是文档夹，且为个人库时（收藏仅在个人库中），查询文档夹下是否有文档为收藏，有返回
            if((docLibType == 1||docLibType == '1')){
                var docId = checkid[i].value;
                var oIsFolder = document.getElementById("isFolder"+docId);
                
                if(oIsFolder != null && (oIsFolder.value === 'true') && docId!=null && collectId == -1){
                    var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "hasFavoriteDoc", false);
                    requestCaller.addParameter(1, "Long", docId);
                    var sDocId = requestCaller.serviceRequest();
                    if(sDocId !== '-1'){
                        collectId = sDocId;
                    }
                }
            }
        }
    }
    return collectId;
}
// 锁定文档操作
function lockDoc(rowid) {
	if(checkLock(rowid, false) == false) {
		return;
	}
	
	mainForm.action = jsURL + "?method=lockDoc&docResId=" + rowid;
	mainForm.target = "empty";
	mainForm.submit();
}

// 解除文档锁操作
function unlockDoc(rowid, userId) {
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "isDocAppUnlocked", false);
		requestCaller.addParameter(1, "Long", rowid);
		requestCaller.addParameter(2, "Long", userId);
	var flag = requestCaller.serviceRequest();
	if('true' == flag || true == flag) {
		alert(v3x.getMessage("DocLang.doc_alert_unlocked_again"));
		window.location.reload(true);
		return;
	}
	
	mainForm.action = jsURL + "?method=unlockDoc&docResId=" + rowid;
	mainForm.target = "empty";
	mainForm.submit();
}


/***********************************************************************************************************************
 * open move tree
 **********************************************************************************************************************/ 
  
/**
 * tr innerHTML disable || enable
 */
function docDisable(id) {
    var contentMenuObj=document.getElementById(id);
    if(contentMenuObj != null){
	    var onclick = contentMenuObj.getAttribute("onclick");
	    contentMenuObj.setAttribute("onclick","");
	    contentMenuObj.setAttribute("onclick1",onclick);
	    contentMenuObj.disabled = true;
	    addClass(contentMenuObj,"disabled");
	    //ie10及多浏览器兼容
	    disableElement(contentMenuObj);
    }
}

function docEnable(id) {
    var contentMenuObj=document.getElementById(id);
    if(contentMenuObj != null){
        var onclick = contentMenuObj.getAttribute("onclick1");
        if(onclick!='' && onclick!= null && onclick.length>0){
            contentMenuObj.setAttribute("onclick",onclick);
        }
        contentMenuObj.disabled = false;
        removeClass(contentMenuObj,"color_gray");
        //ie10及多浏览器兼容
        enableElement(contentMenuObj);
	}
}

function docDisplay(id) {
	var ele = document.getElementById(id);
	if(ele) {
		ele.style.display = "";
		ele.disabled = false;
		removeClass(ele,"disabled");
	}
}
/**
 * 删除当前节点所有子节点的事件
 */
function disableElement(element){
    if (v3x.isMSIE && !v3x.isMSIE10 && !v3x.isMSIE11) {
    	return;
    }
    
    if(element){
        var cDiv = element.firstChild;
        //1.找当前节点的子节点
        while(cDiv){
            if(cDiv.firstChild){
                var siblingNode = cDiv.firstChild;
                while(siblingNode!=null){
                    clearEvent(siblingNode);
                    addClass(siblingNode,"color_gray");
                    
                    siblingNode=siblingNode.nextSibling;
                }
            }
            
            addClass(cDiv,"color_gray");
            clearEvent(cDiv);
            cDiv=cDiv.nextSibling;
        }
        clearEvent(element);
        addClass(element,"color_gray");
    }
}

function enableElement(element){
	if (v3x.isMSIE && !v3x.isMSIE10 && !v3x.isMSIE11) {
    	return;
    }
    
    if(element){
        var cDiv = element.firstChild;
        //1.找当前节点的子节点
        while(cDiv){
            if(cDiv.firstChild){
                var siblingNode = cDiv.firstChild;
                while(siblingNode!=null){
                    returnEvent(siblingNode);
                    removeClass(siblingNode,"color_gray");
                    
                    siblingNode = siblingNode.nextSibling;
                }
            }
            returnEvent(cDiv);
            removeClass(cDiv,"color_gray");
            cDiv=cDiv.nextSibling;
        }
        
        returnEvent(element);
        removeClass(element,"color_gray");
    }
}

function clearEvent(element){
    var attrNames=['onmouseover','onmouseout','onmouseup','onclick'];
    if(element.setAttribute){
        for(var i=0; i<attrNames.length ;i++){
            var key = attrNames[i]+'1';
            if(element.getAttribute(attrNames[i])!= null && element.getAttribute(attrNames[i]) != ''){
                element.setAttribute(key,element.getAttribute(attrNames[i]));
                element.setAttribute(attrNames[i],"");
            }
        }
    }
}

function returnEvent(element){
    var attrNames=['onmouseover','onmouseout','onmouseup','onclick'];
    if(element.setAttribute){
        for(var i=0; i<attrNames.length ;i++){
            var key=attrNames[i]+'1';
            if(element.getAttribute(key)!= null && element.getAttribute(key) != ''){
                element.setAttribute(attrNames[i],element.getAttribute(key));
            }
        }
    }
}

function addClass(obj, cls){ 
    if (!this.hasClass(obj, cls)){
        obj.className += " " + cls;
    }
}

function removeClass(obj, cls){
    if (hasClass(obj, cls)) {
        var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
        obj.className = obj.className.replace(reg, ' ');
    }
}

function hasClass(obj, cls) {
    if(obj&&obj.className){
       return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
    }
    return false;
}


function docNoneDisplay(id) {
	var ele = document.getElementById(id);
	if(ele){
		ele.style.display = "none";
		if(ele.parentNode.nextSibling){ele.parentNode.nextSibling.style.display = "none";}
		//ie10兼容
        enableElement(ele);
	}
}

function isDocNoneDisplay(id){
    var ele = document.getElementById(id);
    var isDisplay = false;
    if(ele){
        isDisplay = (ele.style.display == "none");
    }
    return isDisplay;
}

function initFun(all, edit, add, readonly, browse, list, isPrivateLib, folderEnabled, a6Enabled, officeEnabled, uploadEnabled, isGroupLib, isEdocLib, isShareOrBorrow,onlyA6,onlyA6s) {	
	// 控制菜单项显示
	if (isPrivateLib == "true") {
		sendToSubItems.hidden("deptDoc");
		sendToSubItems.hidden("deptLearn");
		sendToSubItems.hidden("accountLearn");
		sendToSubItems.hidden("publish");
		sendToSubItems.hidden("groupLearn");
		sendToSubItems.hidden("group");
		
		if (officeEnabled == "false") {
			newSubItems.hidden("word");
			newSubItems.hidden("excel");
			newSubItems.hidden("wpsword");
			newSubItems.hidden("wpsexcel");
		}
	} 
	else {
		if(isAdministrator == 'false'){
			sendToSubItems.disabled("publish");	
			sendToSubItems.disabled("accountLearn");			
		}	
		if(isGroupAdmin == 'false'){
			sendToSubItems.disabled("group");	
			sendToSubItems.disabled("groupLearn");			
		}
		if(depAdminSize == '0'){
			sendToSubItems.disabled("deptDoc");
			sendToSubItems.disabled("deptLearn");
		}
		
		if(isGroupLib == 'false'){
			sendToSubItems.hidden("groupLearn");
			sendToSubItems.hidden("group");
		}
		if (folderEnabled == "false") {
			newSubItems.hidden("folder");
		}

		if (a6Enabled == "false") {
			newSubItems.hidden("html");
		}

		if (officeEnabled == "false") {
			newSubItems.hidden("word");
			newSubItems.hidden("excel");
			newSubItems.hidden("wpsword");
			newSubItems.hidden("wpsexcel");
		}

		if (folderEnabled == "false" && a6Enabled == "false" && officeEnabled == "false" && isEdocLib == 'false') {
			docNoneDisplay("new");
		}

		// 控制上传文件菜单显示
		if (uploadEnabled == "false") {
			docNoneDisplay("upload");
		}	
		
		if(isEdocLib == 'true') {
			docNoneDisplay("sendto");
			// 公文、预归档也要求排序(具有权限)
			if(all != 'true') {
				docNoneDisplay("forward");
			}
		}
	}	

	// 根据权限设置文档菜单操作是否可用
	if(all == "true") {
		docEnable("move");
		docEnable("del");
	}
	else {
		docDisable("move");
		docDisable("del");	
	}
	
	if(all == "true" || edit == "true" || add == "true") {		
		docEnable("new");
		docEnable("upload");
	}
	else {
		docDisable("new");
		newSubItems.hidden("html");
		newSubItems.hidden("folder");
		if (officeEnabled == "true") {
		     newSubItems.hidden("word");
		    newSubItems.hidden("word");
			newSubItems.hidden("excel");
			newSubItems.hidden("wpsword");
			newSubItems.hidden("wpsexcel");
		 }
		docDisable("upload");
	}
	if(all == "true" || edit == "true" || readonly == "true" || (isShareOrBorrow == "true" && (frType == "102" || frType == "103"))){
		docEnable("downloadFile");
	}else{
		docDisable("downloadFile");
	}
	if (all == "true" || edit == "true"  || readonly == "true" || add == "true" ) {
		docEnable("sendto");
		docEnable("forward");
	}
	else {
		docDisable("sendto");
		docDisable("forward");
		forwardSubItems.disabled("col");
	    forwardSubItems.disabled("mail");
	}
	
	var canNewColl = window.canNewColl;
	var canNewMail = window.canNewMail;
		if('false' == canNewColl){
			if('false' == canNewMail){
				forwardSubItems.hidden("mail");
			}
			forwardSubItems.hidden("col");
		}else if('false' == canNewMail){
			forwardSubItems.hidden("mail");
		}
		
	if(isShareOrBorrow == 'true'){
		docDisable("sendto");
		forwardSubItems.disabled("mail");
		forwardSubItems.disabled("col");
	}

	// only add acl
	if (all == "false" && edit == "false"  && readonly == "false" && browse == "false" && list == "false" && add == "true" ) {
			docDisable("sendto");
			docDisable("forward");
	}
	if (all == "false" && edit == "false" && readonly == "false" && add=="false") {
		forwardSubItems.disabled("mail");
		forwardSubItems.disabled("col");
	}
	
	//a6版本时，去掉发送到部门学习区，部门知识文档
	if(onlyA6==='true' && onlyA6s==='true'){
		sendToSubItems.hidden("deptLearn");
		sendToSubItems.hidden("deptDoc");
	}
}




/**
 * 顶部菜单权限控制
 */
 
 function docListAcl(all, edit, add, read, browse, list, folder, folderLink, link, appKey, isSysInit,isCreater,isCollect,onlyA6,onlyA6s){
 	this.all = all;
 	this.edit = edit;
 	this.add = add;
 	this.read = read;
 	this.browse = browse;
 	this.list = list;
 	
 	this.folder = folder;
 	this.folderLink = folderLink;
 	this.link = link;
 	this.appKey = appKey;
 	
 	this.isSysInit = isSysInit;
 	this.isCreater = isCreater;
 	this.isCollect = isCollect;
 	this.onlyA6 = onlyA6;
 	this.onlyA6s = onlyA6s;
 	
 	 if(all=="false"&&edit=="false"&&readonly=="false")  docDisable("forward");
 }
 docListAcl.prototype.toString = function(){
	var str = this.all + "," + this.edit + "," + this.add + ","
			+ this.read + "," + this.browse + "," + this.list
			+ "," + this.folder + "," + this.folderLink + "," + this.link;
	return str;
 }
 var docListAclMap = new Properties();
 
function chkMenuGrantControl(all, edit, add, readonly, browse, list, ele, folder, folderLink, link, appKey, isSysInit,isCreater,isCollect,onlyA6,onlyA6s) {
	if(!ele)
		return;

	if(ele.checked){
		if(docListAclMap.containsKey('parent'))
			docListAclMap.remove('parent');
		docListAclMap.put(ele.value, new docListAcl(all, edit, add, readonly, browse, 
				list, folder, folderLink, link, appKey, isSysInit,isCreater,isCollect,onlyA6,onlyA6s));
	}
	else{
		docListAclMap.remove(ele.value);
		if(docListAclMap.size() == 0)
			docListAclMap.put('parent', new docListAcl(parentAclAll, parentAclEdit, parentAclAdd, 
					parentAclReadonly, parentAclBrowse, parentAclList, 
					'false', 'false', 'false', appData.doc, 'false',isCreater,isCollect,onlyA6,onlyA6s));
	}

	ctrlDocMenuByAclMap(appKey);		

}
var docListAclAll;
function ctrlDocMenuByAclMap(appKey){	
	docListAclAll = true;
	var docListAclEdit = true;
	var docListAclAdd = true;
	var docListAclReadonly = true;
	var docListAclBrowse = true;
	var docListAclList = true;
	var docListIsCreater = true;
	var isFolder = false;
	var isFolderLink = false;
	var isLink = false;
	var isCreater = false;
	var isCollectLink = false;
	var isSysInit = false;
	var onlyA6 = false;
	var onlyA6s = false;
	var values = docListAclMap.values();
	
	
	var isShareAndBorrowRoot=window.isShareAndBorrowRoot;
	for(var i = 0; i < values.size(); i++){
		var obj = values.get(i);
		
		onlyA6 = (obj.onlyA6 == 'true');
		onlyA6s = (obj.onlyA6s == 'true');
		isFolder = (isFolder || (obj.folder == 'true'));
		isFolderLink = (isFolderLink || (obj.folderLink == 'true'));
		isLink = (isLink || (obj.link == 'true'));
		isSysInit = (isSysInit || (obj.isSysInit == 'true'));
		isCreater = (obj.isCreater == 'true');
		isCollectLink = (isCollectLink || (obj.isCollect == 'true' && isLink));
		if(obj.all == 'true')
			continue;
		docListAclAll = false;
		var edit = (obj.edit == 'true');
		var add = (obj.add == 'true');
		var read = (obj.read == 'true');
		var browse = (obj.browse == 'true');
		var list = (obj.list == 'true');
		if(browse){
			list = true;
		}	
		if(read){
			browse = true;
			list = true;
		}
		if(edit){
			read = true;
			browse = true;
			list = true;
		}

		docListAclEdit = (docListAclEdit && edit);
		docListAclAdd = (docListAclAdd && add);
		docListAclReadonly = (docListAclReadonly && read);
		docListAclBrowse = (docListAclBrowse && browse);
		docListAclList = (docListAclList && list);
		docListIsCreater = (docListIsCreater && isCreater);
	}
	
	if(docListAclAll && !isSysInit) {
	    docEnable("move");
	    docEnable("del");
	}else {
	    docDisable("move");
		// 公文预归档夹允许删除 2010-11-30
		if(isSysInit && appKey != 3){
		    docDisable("del");
		}
	}

	var canNewColl = window.canNewColl;
	var canNewMail = window.canNewMail;

	var forward = window.forwardSubItems;
	var sendto = window.sendToSubItems;
	docEnable("sendto");
	sendto.display("favorite");
	sendto.enabled("favorite");
	sendto.display("deptDoc");
	sendto.enabled("deptDoc");
	sendto.display("publish");
	sendto.enabled("publish");
	sendto.display("learning");
	sendto.enabled("learning");
	sendto.display("deptLearn");
	sendto.enabled("deptLearn");
	sendto.display("accountLearn");
	sendto.enabled("accountLearn");
	sendto.display("group");
	sendto.enabled("group");
	sendto.display("groupLearn");
	sendto.enabled("groupLearn");
	sendto.display("link");
	sendto.enabled("link");
	
	docEnable("forward");
	forward.display("col");
	forward.enabled("col");
	forward.display("mail");
	forward.enabled("mail");

	if(window.depAdminSize == '0'){
		sendto.disabled("deptDoc");
		sendto.disabled("deptLearn");
	}	
	if(isAdministrator == 'false'){
		sendto.disabled("accountLearn");
		sendto.disabled("publish");		
	}
	if(window.isGroupLib == 'false'){
		sendto.hidden("group");
		sendto.hidden("groupLearn");
	}
	if(isGroupAdmin == 'false'){
		sendto.disabled("group");
		sendto.disabled("groupLearn");			
	}
	// only add acl
	if(!docListAclAll && !docListAclEdit && !docListAclReadonly && !docListAclBrowse && !docListAclList && docListAclAdd){
		if(!docListIsCreater){
			docDisable("sendto");
			docDisable("forward");
		}
	}	
	if (docListAclAll || docListAclEdit || docListAclReadonly || docListAclAdd) {
		
		if(isPersonalLib == 'true'){
			sendto.hidden("deptDoc");
			sendto.hidden("deptLearn");
			sendto.hidden("accountLearn");
			sendto.hidden("publish");
			sendto.hidden("group");
			sendto.hidden("groupLearn");
		}
		
		if(isFolder || isLink || isFolderLink) {
			sendto.hidden("learning");
			sendto.hidden("deptLearn");
			sendto.hidden("accountLearn");
			sendto.hidden("groupLearn");
			sendto.hidden("link");
		}
		
		if(isFolder || isLink || isFolderLink){
			forward.disabled("col");
			forward.disabled("mail");	
		} else {
			if(getSelectedCount() == 1){		
				var appKey = values.get(0).appKey;
				if(appKey != appData.doc && appKey != appData.collaboration && appKey != appData.form && appKey != appData.mail){
					forward.disabled("col");
					forward.disabled("mail");
				}
			} else if(getSelectedCount() > 1){
				forward.disabled("col");
				forward.disabled("mail");
			}
		}
		
		if('false' == canNewColl){
			if('false' == canNewMail){
				forward.hidden("col");
				forward.hidden("mail");
			} else {
				forward.hidden("col");
			}
		} else if('false' == canNewMail){
			forward.hidden("mail");
		}
	}
	else {
		if (docListAclBrowse)	{
			if(isFolder || isLink || isFolderLink) {
				sendto.hidden("learning");
				sendto.hidden("deptLearn");
				sendto.hidden("accountLearn");
				sendto.hidden("groupLearn");
				sendto.hidden("link");
			}
		} else {
			docDisable("sendto");
		}
		forward.disabled("col");
		forward.disabled("mail");
		sendto.disabled("link");
	}
	// 同步docMenu.js如下调整：2008.06.17 个人共享，借阅屏蔽掉发送
	if(isShareAndBorrowRoot == 'true'){
		docDisable("sendto");
	}
	
	if (!docListAclAll && !docListAclEdit && !docListAclReadonly && !docListAclAdd) {
		forward.disabled("col");
		forward.disabled("mail");
	}
	
	if (docListAclAll || docListAclEdit || docListAclReadonly){
		forward.enabled("downloadFile");
	}else if((!docListAclAll && !docListAclEdit && !docListAclReadonly
			&& !docListAclBrowse && !docListAclList && docListAclAdd)&&docListIsCreater){// only add acl
		forward.enabled("downloadFile");
	}else{
		forward.disabled("downloadFile");
	}
	
	if(isCollectLink) {
		sendto.hidden("deptLearn");
		sendto.hidden("accountLearn");
		sendto.hidden("groupLearn");
		sendto.hidden("deptDoc");
		sendto.hidden("publish");
		sendto.hidden("group");
		sendto.disabled("favorite");
	}
	
	var disabledCount = 0;
	var fmenuItems = forward._menuItems;
	//检查是否全部disabled
	for(var i=0;i<fmenuItems.length;i++){
		if(fmenuItems[i]&&fmenuItems[i].disabled){
			disabledCount ++;
		}
	}
	
	if(onlyA6 && onlyA6s){//部门学习区，在a6s下去掉
		sendto.hidden("deptLearn");
		sendto.hidden("deptDoc");
	}
	
	if(disabledCount === fmenuItems.length){
		docDisable("forward");
	}
}
function showOrhidden() {
	var parentLayout = parent.document.getElementById("layout");
	if(parentLayout){
		if(parentLayout.cols == "0,*") {
			parentLayout.cols = "140,*";
// getA8Top().contentFrame.document.getElementById('LeftRightFrameSet').cols = "0,*";
		}
		else {
			parentLayout.cols = "0,*";
// getA8Top().contentFrame.leftFrame.closeLeft();
		}
	}
}



/**
 * *********************************begin 属性页相关函数
 */ 
function borrowDeleteUser() {
  var checkedids = document.getElementsByName('borrowid');
  var len = checkedids.length;
  var count = 0;
  for(var i = 0; i < len; i++) {
  		var checkedid = checkedids[i];
		
		if(checkedid && checkedid.checked && checkedid.parentNode.parentNode.tagName == "TR"){			
			checkedid.parentNode.parentNode.parentNode.removeChild(checkedid.parentNode.parentNode);
			originalElementsborrow.remove("" + checkedid.value + "");
			// OA-45079 删除后不能重复选人 ;删人时也删除mapdatafield域
			mapdatafield.remove("" + checkedid.value + "");
			i--;
			count++;
		}
	}

   if(count == 0){
   		alert(v3x.getMessage("DocLang.doc_delete_select_alert"));
   }else{
	// alert("doc.js ucf::Prop--" + ucfProp+"ucf::Public--" + ucfPublicShare+"ucf::Personal--" +
    // ucfPersonalShare+"ucf::Borrow--" + ucfBorrow)
	ucfBorrow = true;
   }
}


/***********************************************************************************************************************
 * 属性页相关函数 end
 **********************************************************************************************************************/
// 弹出文档打开窗口
function docOpenFun(id, name, all, edit, add, readonly, browse,isBorrowOrShare, list, isLink) {
	if((isBorrowOrShare == false || isBorrowOrShare == 'false') && !hasOpenAcl(all,edit,add,readonly,browse,list)){
	return;	
	}
	var exist = true;// 判断文件是否存在
	if(isLink == 'true') {
		exist = docExist(id,false);// 如果是链接类型，判断源文件是否仍存在
	}
	if(exist == 'false'){
		return; 
	}

	var surl = jsURL + "?method=docOpenIframe&docResId=" + id  + "&all=" + all 
		+ "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse +"&isBorrowOrShare=" + isBorrowOrShare
		+ "&list=" + list + "&docLibId=" + docLibId + "&docLibType=" + docLibType + "&isLink=" + isLink;
	var openArgs = {};
	openArgs["url"] = surl;
	
	if(v3x.getBrowserFlag('openWindow') == false){
		openArgs["dialogType"] = "open";
	}
	if((arguments[10] !=null && arguments[10]==true) && (arguments[11]!=null && arguments[11]!='101' && arguments[11]!='102' && arguments[11]!='120' && arguments[11]!='121')){
		openArgs["workSpaceRight"] = 'yes';
	} else if(!v3x.isIpad){
		openArgs["workSpace"] = 'yes';
	}
	
	var ret = v3x.openWindow(openArgs);
	if(ret == true || 'true' == ret){	
		try{
			window.location.reload(true);
		}
		catch(e){}
	}
}

// 得到打开类型
function openType(id) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "getTheOpenType", false);
		requestCaller.addParameter(1, "Long", id);
				
		var flag = requestCaller.serviceRequest();
		
		return flag;
	}
	catch (ex1) {
		alert("Exception : " + ex1.message);
	}

}
// 判断文档链接的源文件是否存在
function docExist(id, folderLink) {
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExist", false);
        	requestCaller.addParameter(1, "Long", id);

        var flag = requestCaller.serviceRequest();
        if (flag == 'false') {
            if (folderLink) {
                alert(v3x.getMessage('DocLang.doc_source_folder_no_exist'));
            } else {
                alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
            }
        }

        return flag;
    }
    catch(ex1) {
        alert("Exception : " + ex1.message);
    }
}
/**
 * 验证是否有查看权限
 */
 function hasOpenAcl(all,edit,add,readonly,browse,list){
 	if('true' == all || 'true' == edit || 'true' == readonly || 'true' == browse || 'true' == add)
 		return true;
 	else{
 		alert(v3x.getMessage('DocLang.doc_open_no_acl_alert'))
 		return false;
 	}
 }

/**
 * 从文档列表中打开文档夹。
 */
function folderOpenFun(id, frType, all, edit, add, readonly, browse, list, isFolderLink,v,projectTypeId) {
	var exist = 'true';
	if(isFolderLink == 'true') {
		exist = docExist(id, true);
	}
	if(exist == 'false')
		return; 
	
	var surl = jsURL + "?method=rightNew&resId=" + id + "&frType=" + frType + "&docLibId=" + docLibId
		+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=" + isShareAndBorrowRoot + "&all=" + all 
		+ "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list
		+ "&isFolderLink=" + isFolderLink + "&v=" + v+"&projectTypeId="+projectTypeId;
	var query = document.getElementById('method').value == 'advancedQuery';
	if(query) {
		parent.location.href = surl;
	}
	else {
		location.href = surl;
	}
}
function folderOpenFunById(id,frType,projectTypeId){
	location.href = jsURL + "?method=docHomepageIndex&docResId=" + id + "&frType=" + frType + "&projectTypeId=" + projectTypeId + "&t="+new Date();
}

function folderOpenFunWithoutAcl(id,frType,v,projectTypeId) {
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocAclManager", "getAclString", false);
		requestCaller.addParameter(1, "long", id);
	var flag = requestCaller.serviceRequest();
	
	if (frType == "40") {
	    isShareAndBorrowRoot = false;
	    flag = "all=true&edit=true&add=true&readonly=false&browse=false&list=true"
	}
	
	if (frType == "110") {
	    isShareAndBorrowRoot = false;
	}
	if(!v3x.isMSIE11){
		try {
			$.confirmClose(false);
		} catch (e) {
		}
	}
	/*try {暂时注释，IE11下，这里导致不弹是否离开的框
		$.confirmClose(false);
	} catch (e) {
	}*/
 	var surl = jsURL + "?method=rightNew&resId=" + id + "&frType=" + frType + "&docLibId=" + docLibId + "&docLibType=" + docLibType 
 	+ "&isShareAndBorrowRoot=" + isShareAndBorrowRoot + "&" + flag + "&isFolderLink=false&v=" + v+"&projectTypeId="+projectTypeId;
	location.href = surl;
}
/**
 * 从主页打开文档夹
 */
function folderOpenFunHomepage(id, frType, all, edit, add, readonly, browse, list, isFolderLink, docLibId, docLibType,v) {
	var exist;
	if (isFolderLink == 'true') {
	    exist = docExist(id, true);
	}
	if (exist == 'false') 
		return;
	
	var surl = jsURL + "?method=rightNew&resId=" + id + "&frType=" + frType + "&docLibId=" + docLibId + "&docLibType=" + docLibType + "&isShareAndBorrowRoot=false&all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list + "&isFolderLink=" + isFolderLink + "&v=" + v;
	var dest = parent.rightFrame;
	if (dest) {
	    parent.rightFrame.location.href = surl;
	}
	else if (parent.parent.rightFrame) {
	    parent.parent.rightFrame.location.href = surl;
	}
	else {
	    window.location = jsURL + "?method=docHomepageIndex&docResId=" + id;
	}
}

/**
 * 从關聯打开文档夹
 */
function folderOpenFunQuote(id,frType,all,edit,add,readonly,browse,list,isFolderLink, docLibId, docLibType,referenceId,projectTypeId) {
	var exist;
	var isQuote = "";
	if(isFolderLink == 'true') {
		exist = docExist(id, true);
	}else{
		isQuote = "true";
	}
	if(exist == 'false')
		return; 
	
	if(parent.listFrame){
		var surl = jsURL + "?method=listDocs4Quote&resId=" + id + "&frType=" + frType + "&docLibId=" + docLibId
			+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=false&all=" + all 
			+ "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list
			+ "&isFolderLink=" + isFolderLink + "&isQuote=" + isQuote+"&referenceId="+referenceId+"&projectTypeId="+projectTypeId + "&from=" + paramFrom;
 		parent.listFrame.location.href = surl;
 	}
}
// 弹出文档修改窗口
function docBodyEdit(id) {
 	
	var returnflag = v3x.openWindow({
		url : jsURL + "?method=editDoc&id=" + id,
		workSpace : 'yes',
		resizable : "false"		
	});
	
	if(returnflag == "true") {				
		window.dialogArguments.window.location.reload(true);	
	}
}


/**
 * 编辑文档(从弹出菜单进入)。
 */
function editDoc(id, filename) {
	if(checkLock(id, false) == false) {
		return;
	}
	var isUploadFile = false;
	if(isUploadFileMimeType !== '0') {
		isUploadFile = true;
    }
	if(isUploadFileMimeType!='0' && isUploadFileMimeType!='101' && isUploadFileMimeType!='102' && isUploadFileMimeType!='120' && isUploadFileMimeType!='121'){
		dialog = new MxtWindow({
			id : "uploadFileDialog" ,
			url : jsURL + "?method=editDoc&docResId=" + id + "&docLibType=" + docLibType+"&isUploadFileMimeType=true&isUploadFile=true&openFrom=docCenterEdit",
			width: 400,
		    height: 420,
		    isDrag: true ,
		    targetWindow: window.parent.top,
		    title: v3x.getMessage('DocLang.doc_knowledge_edit'),
		    buttons: [{
            	id : 'ok',
                text: v3x.getMessage('DocLang.submit'),
                emphasize:"button-default_emphasize",
                handler: function () {
                	var returnValue = dialog.getReturnValue();
                	if(returnValue) {
                		if(getA8Top().frames['main'] && getA8Top().frames['main'].frames['rightFrame']) {
                			// 刷新文档中心
                			getA8Top().frames['main'].frames['rightFrame'].location.reload();
                		} else {
                			// 防护
                			dialog.close();
                		}
                	}               	
                }
            }, {
            	id : 'cancel',
                text: v3x.getMessage('DocLang.cancel'),
                handler: function () {
                    dialog.close();
                }
            }]
			});
	}else{
		dialog = new MxtWindow({
			id : "docOpenDialogOnlyId" ,
			url : jsURL + "?method=editDoc&docResId=" + id + "&docLibType=" + docLibType+ "&isUploadFile=" + isUploadFile +"&openFrom=docCenter",
			width: getA8Top().document.documentElement.clientWidth-20,
		    height: getA8Top().document.documentElement.clientHeight-20,
		    isDrag: true ,
		    targetWindow: getA8Top(),
  	        closeParam: {
              handler:function(){
                unlockAfterAction(id);
              	dialog.close();
              }
            },
		    title: v3x.getMessage('DocLang.doc_knowledge_edit')
		});
	}
	getA8Top()._dialog = dialog;
}
// 归档源存在判断，根据rowId
function pigSourceExistById(rowId,appEnumKey){
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "docHierarchyManager",
			 "isExist", false);
		requestCaller.addParameter(1, "Long", rowId);		
		var flag = requestCaller.serviceRequest();
		return flag;
	}
	catch (ex1) {
		// alert("Exception : " + ex1.message);
		return 'false';
	}

}

// 归档源存在的判断
function pigSourceExist(appEnumKey, sourceId){
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "docFilingManager",
			 "hasPigeonholeSource", false);
		requestCaller.addParameter(1, "Integer", appEnumKey);
		requestCaller.addParameter(2, "Long", sourceId);
				
		var flag = requestCaller.serviceRequest();

		
		return flag;
	}
	catch (ex1) {
		// alert("Exception : " + ex1.message);
		return 'false';
	}
}

//// 判断修改订阅的源文件是否有权限
function aclExist(id){
	try{
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocAlertManager",
			 "hasAlert", false);
		requestCaller.addParameter(1, "String", id);
				
		var flag = requestCaller.serviceRequest();
		
		return flag;
	}catch (ex1) {
		alert("Exception : " + ex1.message);
	}
}

// ///////////日志打印//////////////////////////////

function printFileLog(){
	var theName="";
	if(document.getElementById("pagerTd")){
		document.getElementById("pagerTd").style.display="none";
	}
	var theContent=document.getElementById("scrollListDiv").innerHTML;
	var list=new PrintFragment(theName, theContent);
	
	 var klist = new ArrayList();
	 var theCss="/apps_res/doc/css/doc.css";
	 klist.add("/seeyon/common/skin/default/skin.css");
	 klist.add(theCss);
	 
	var tlist = new ArrayList();
	tlist.add(list);
	
	printList(tlist,klist);
	if(document.getElementById("pagerTd")){
		document.getElementById("pagerTd").style.display="block";
	}
}

function printDoc(){
	var bodyType = document.getElementById("docOpenBodyFrame").contentWindow.document.getElementById("bodyTypeInput").value;
	// 在线office或PDF的打印通过调用编辑器组件的打印实现
	if(bodyType == 'OfficeWord' || bodyType == 'OfficeExcel' || bodyType == 'WpsWord' || bodyType == 'WpsExcel'){
		document.getElementById("docOpenBodyFrame").contentWindow.officeEditorFrame.officePrint();
		return;
	}
	if(bodyType == 'Pdf') {
		document.getElementById("docOpenBodyFrame").contentWindow.officeEditorFrame.pdfPrint();
		return;
	}
	
	var titleContent = document.getElementById("docPrintTitle").innerHTML;
	 
	var theBody=v3x.getMessage('DocLang.doc_print_body');
	var bodyContent=document.getElementById("docOpenBodyFrame").contentWindow.document.getElementById("docBody").innerHTML;
	var list = new PrintFragment("", titleContent + bodyContent);
	
	var mainList=new ArrayList();
	mainList.add(list);
	
	var cssList=new ArrayList();
	cssList.add("../../common/RTE/editor/css/fck_editorarea4Show.css");
	printList(mainList, cssList);
}

function exportExcel(the_flag,theId,name){

	if(the_flag == 'file'){
		var logView=document.getElementById("logView");
		logView.target="theLogIframe";
		logView.action=jsURL+"?method=fileLogToExcel&docResourceId="+theId+"&flag=fileLog&trueName=" + encodeURI(name);
		logView.submit();
	}
	else{
		var folderLog=document.getElementById("folderLog");
		folderLog.target="theLogIframe";
		folderLog.action=jsURL+"?method=fileLogToExcel&docResourceId="+theId+"&flag=folderLog&trueName=" + encodeURI(name);
		folderLog.submit();
	}	
	
}

function exportExcelNew(the_flag,theId,name,isGroupLib){
	var aflag = "folderLog";
	if(the_flag == 'file'){
		aflag = "fileLog";	
	}
	
	theLogIframe.location.href = "/seeyon/doc.do?method=fileLogToExcel&docResourceId="+theId+"&flag="+aflag+"&isGroupLib="+isGroupLib;
                                          
}
	

// 文档提醒设置
function docalert(docResId, isFolder) {
	var msgchk = document.getElementById("check_box_message");

	var message = msgchk.checked;
	mainForm.action = jsURL + "?method=docAlert&docResId=" + docResId + "&isFolder=" + isFolder 
			+ "&message=" + message;
	
	mainForm.submit();
}

function validateExistence(docId) {
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExist", false);
	requestCaller.addParameter(1, "Long", docId);
			
	var flag = requestCaller.serviceRequest();
	if(flag == 'false') {
		alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
		window.location.reload(true);
		return false;
	}
	return true;
}

/**
 * 归档至档案系统
 */
function pigeonholeArchive(){
	var rowid = getSelectedIds();
	if(rowid == ""){
		alert(v3x.getMessage("DocLang.doc_only_no_select"));
		return false;
	}
	var docIds = rowid.split(",");
	var hasFolder=false,notOnlyEdoc=false;
	for (var i = 0; i < docIds.length; i++) {
	  if(document.getElementById("isFolder"+docIds[i]).value =="true"){
	  	hasFolder = true;
	  }
	  if(document.getElementById("appEnumKey_"+docIds[i]).value !="4"){
	  	notOnlyEdoc = true;
	  }
  }
	
	if(hasFolder){
		alert(v3x.getMessage('DocLang.doc_only_select_edoc_pig'));
		return;
	}
	
	if(notOnlyEdoc){
		alert(v3x.getMessage('DocLang.doc_only_type_not_true'));
		return;
	}
	
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "isPigeonholeArchive", false);
	requestCaller.addParameter(1, "String", rowid);
	var rVal = requestCaller.serviceRequest();
	var ajaxPigeonhole = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "updatePigeonholeArchive", false);
	ajaxPigeonhole.addParameter(1, "String", rowid);
	ajaxPigeonhole.addParameter(2, "String", "true");
	if(typeof(rVal)=="object" && rVal.size() > 0 ){
		var message = rVal.get("message");
		var type = rVal.get("type");
		if(type == "error"){
				alert(message);
		}else if(type == "confirm"){
			if(confirm(v3x.getMessage('DocLang.doc_work_flow_not_finish',message))){
					rVal = ajaxPigeonhole.serviceRequest();
					handleMessage(rVal);
			}
		}else{
			rVal = ajaxPigeonhole.serviceRequest();
			handleMessage(rVal);
		}
	}
}

/**
 * 档案集成，归档成功后，消息提示
 */
function handleMessage(resultMap){
	alert(resultMap.get("alert"));
	window.location.reload(true);
}

function sendToCollFromMenu() {
	var rowid = getSelectedIds();
	if(rowid == ""){
		alert(v3x.getMessage("DocLang.doc_forward_no_select"));
		return false;
	}
	if(rowid.indexOf(",") != -1)
		return;
// alert(eval('window'))
	var appEnumKey = document.getElementById("appEnumKey_"+rowid).value;//eval("window.appEnumKey_" + rowid);
	var pigData = new appEnumData();
	
	if(!validateExistence(rowid)) {
		return;
	}
	
	if(appEnumKey == pigData.doc){
		var surl = jsURL + "?method=sendToColl&docResId=" + rowid + "&docLibId=" + docLibId;
		parent.location.href = surl;	
		getA8Top().showLeftNavigation();
	}else if(appEnumKey == pigData.collaboration || appEnumKey == pigData.form){
		// 检查源协同是否存在
		// var existFlag = pigSourceExist(appEnumKey, rowid);
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
			var affairId = document.getElementById("sourceId_"+rowid).value;//eval("window.sourceId_" + rowid);
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getSummaryIdByAffairId", false);
			requestCaller.addParameter(1, "long", affairId);
				
			var summaryId = requestCaller.serviceRequest();
			
								// 判断是否允许转发协同或邮件
			try{
		    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission", false);
		    	requestCaller.addParameter(1, "String", summaryId + "_" + affairId);
		    	var ds = requestCaller.serviceRequest();
		    	if(ds.length !== 0){
		    		alert(v3x.getMessage("DocLang.doc_unallowed_forward_affair"));
		    		return;
		    	}
		    }catch(e){
		    }
		    getA8Top().toCollWin = getA8Top().$.dialog({
	            title:v3x.getMessage('DocLang.doc_knowledge_forward_collaboration'),
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
		
		var mailId = document.getElementById("sourceId_"+rowid).value;//eval("window.sourceId_" + rowid);
		var surl = jsMailURL + "?method=convertToCol&id=" + mailId;
		parent.location.href = surl;	
	}
	
}

function sendToMailFromMenu() {
	var rowid = getSelectedIds();
	if(rowid == ""){
		alert(v3x.getMessage("DocLang.doc_forward_no_select"));
		return false;
	}
	if(rowid.indexOf(",") != -1)
		return;
	var appEnumKey = document.getElementById("appEnumKey_"+rowid).value;//eval("window.appEnumKey_" + rowid);
	var pigData = new appEnumData();

	if(appEnumKey == pigData.doc){
		var surl = jsURL + "?method=sendToWebMail&docResId=" + rowid + "&docLibId=" + docLibId;
		parent.location.href = surl;	
	}else if(appEnumKey == pigData.collaboration || appEnumKey == pigData.form){
		// 检查源协同是否存在
		// var existFlag = pigSourceExist(appEnumKey, rowid);
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
			var affairId = document.getElementById("sourceId_"+rowid).value;//eval("window.sourceId_" + rowid);
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getSummaryIdByAffairId", false);
			requestCaller.addParameter(1, "long", affairId);
				
			var summaryId = requestCaller.serviceRequest();
			
								// 判断是否允许转发协同或邮件
			try{
		    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission", false);
		    	requestCaller.addParameter(1, "String", summaryId + "_" + affairId);
		    	var ds = requestCaller.serviceRequest();
		    	if(ds && ds.length !== 0){
                    alert(v3x.getMessage("DocLang.doc_unallowed_forward_affair"));
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
		
		var mailId = document.getElementById("sourceId_"+rowid).value;//eval("window.sourceId_" + rowid);
		var surl = jsMailURL + "?method=autoToMail&id=" + mailId;
		parent.location.href = surl;	
	}
	

}

// 从打开页面发送到协同
function sendToCollFromOpen(id,entrance) {	
		// 验证文档是否存在
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "docResourceExist", false);
		requestCaller.addParameter(1, "Long", id);
		var existflag = requestCaller.serviceRequest();
		if(existflag == 'false') {
			alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
			
			window.dialogArguments.parent.location.reload(true);
			parent.close();
			return ;
		}
	
	
			var dialogArguments = getA8Top().window.dialogArguments;
			// 精灵打开
			if(!dialogArguments){
				getA8Top().showLeftNavigation();
				getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
				window.close();				
				return ;
			}
			
			var loc = getA8Top().window.dialogArguments.location.href;

			var pos = loc.indexOf('rightNew');

			if(pos != -1) {// alert('list');alert(parent.parent.parent.window.dialogArguments.top.contentFrame)
				// 列表打开
				
				// parent.parent.parent.window.dialogArguments.top.contentFrame.LeftRightFrameSet.cols = "140,*";
				if(window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*")		
					window.dialogArguments.getA8Top().contentFrame.leftFrame.closeLeft();		
				window.dialogArguments.getA8Top().showLeftNavigation();
				window.dialogArguments.getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
				window.close();
			}else if(getA8Top().window.dialogArguments.contentFrame){// alert('portal')
				// portal 打开
				
				if(window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "140,*"||window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*"){								
				window.dialogArguments.contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
				setTimeout(" getA8Top().window.close()",1000); 
				}else{
					// getA8Top().window.dialogArguments.contentFrame.mainFrame.document.getElementById("refreshFlag").value="false";
					getA8Top().showLeftNavigation();
					window.dialogArguments.contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
				window.close();

				}   
			} else{
				if(window.dialogArguments.getA8Top().contentFrame){
					window.dialogArguments.getA8Top().showLeftNavigation();
					if(window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "140,*"||window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*"){								
						window.dialogArguments.parent.getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
						setTimeout(" getA8Top().window.close()",1000); 
					}else{
						window.dialogArguments.getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
						setTimeout("top.close()",1000); 
					}
				}else{
					getA8Top().showLeftNavigation();
					if(getA8Top().contentFrame.LeftRightFrameSet.cols == "140,*"||getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*"){								
						getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
						setTimeout(" getA8Top().window.close()",1000); 
					}else{
						getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToColl&docResId=" + id + "&docLibId=" + docLibId + "&entrance=" + entrance;
						window.close();
					}
				}
			} 

}

// 从打开页面发送到邮件
function sendToMailFromOpen(id) {
			// 验证文档是否存在
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "docResourceExist", false);
		requestCaller.addParameter(1, "Long", id);
				
		var existflag = requestCaller.serviceRequest();
		if(existflag == 'false') {
			alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
			
			window.dialogArguments.parent.location.reload(true);
			parent.close();
			return ;
		}
	
			var dialogArguments = getA8Top().window.dialogArguments;
			// 精灵打开
			if(!dialogArguments){
				getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
				window.close();				
				return ;
			}
			var loc = getA8Top().window.dialogArguments.location.href;

			var pos = loc.indexOf('rightNew');

			if(pos != -1) {// alert('list');alert(parent.parent.parent.window.dialogArguments.top.contentFrame)
				// 列表打开
				
				if(window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*")
					window.dialogArguments.getA8Top().contentFrame.leftFrame.closeLeft();
				window.dialogArguments.getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
				window.close();
			}else if(getA8Top().window.dialogArguments.contentFrame){// alert('portal')
				// portal 打开
				
				if(window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "140,*"||window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*"){								
				window.dialogArguments.contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
				setTimeout(" getA8Top().window.close()",1000); 
				}else{
					// getA8Top().window.dialogArguments.contentFrame.mainFrame.document.getElementById("refreshFlag").value="false";
					getA8Top().window.dialogArguments.contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
				window.close();

				}
			} else{
				if(window.dialogArguments.getA8Top().contentFrame){
					if(window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "140,*"||window.dialogArguments.getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*"){								
						window.dialogArguments.parent.getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
						setTimeout(" getA8Top().window.close()",1000); 
					}else{
						window.dialogArguments.getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
						setTimeout("top.close()", 1000);
					}
				}else{
					if(getA8Top().contentFrame.LeftRightFrameSet.cols == "140,*"||getA8Top().contentFrame.LeftRightFrameSet.cols == "0,*"){								
						getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
						setTimeout(" getA8Top().window.close()",1000); 
					}else{
						getA8Top().contentFrame.mainFrame.location.href = jsURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=" + docLibId;
						window.close();
					}
				}
			} 

}
	
	function docResourcesOrder(docResId,frType,isNeedSort){
		// alert(docResId+"-"+frType+"-"+docLibId+"-"+docLibType+"-"+shareAndBorrow+"-"+all+"-"+edit+"-"+add+"-"+readonly+"-"+browse+"-"+list);
		if(isNeedSort == 'false'){// 当文档个数不超过2个时
			alert(v3x.getMessage('DocLang.doc_not_need_sort_alert'));
			return;
		}
		var theURL = jsURL + "?method=sortPropertyIframe&resId=" + docResId + "&frType=" + frType;
		// alert(theURL);
		if(v3x.getBrowserFlag('openWindow') == false){
			 var win=v3x.openDialog({
    	 					id:"order",
    						title:"",
    	 					url : theURL,
    	 					width: 650,
					    	height: 450,
					    	closeParam:{'show':true,handler:function(){
					    		win.close();
					    	    window.location.reload(true);
					    	}},
					    	// type:'panel',
					    	 // relativeElement:obj,
					    	buttons:[{
					    	 id:'btn1',
					    	 text: v3x.getMessage('DocLang.close'),
					    	 handler: function(){
					    	    win.close();
					    	    window.location.reload(true);
					    	 }
					    	 }]
					    });
		} else {
			var toSort = v3x.openWindow({
				url : theURL,
				width : 650,
				height : 650,
				resizable : "true"
			});
			 if(toSort == 1 )  window.location.reload(true);
		 }
	}

/*--------------------------------------- 关联文档 Start --------------------------------------*/
	
// 添加关联文档
function addDocLinks(docLibId, sourceId) {
	// 在做保存前，删除得关联文档
	var the_delDocLinkId = document.getElementById("delDocLinkId").value;
	var flag = "edit";
	if(sourceId == '')
		flag = "edit";		
	var theInfo = v3x.openWindow({
		url : jsURL + "?method=docRelAddIfram&sourceId=" + sourceId + "&flag=" + flag +"&deletedId=" + the_delDocLinkId + "&docLibId=" + docLibId,
		width : 800,
		height : 600,
		resizable : "true"
	});
	
	if( theInfo == null || theInfo == "") {
		return ;
	}
	else {
		var addString = "";
		var tempString = "";
		var boolString = theInfo.split(":");
		var bool = boolString[1];				// 标志是否原来就有关联文档
		
		var stringArray = boolString[0].split(";");
		
		for(var i = 0; i < stringArray.length; i++) {
			var temp_bool = false;
			var lastString = stringArray[i].split(",");
			if(lastString == null || lastString == "") {
				continue;
			}
			else {
				if(i != stringArray.length - 1) {
					addString += lastString[0];
					addString += ",";
				}
				else {
					addString += lastString[0];
				}
				var _bool = isContain(lastString[0]);
				if( _bool == true) {
					if(document.getElementById("doclink_" + lastString[0]) == null) {
						tempString += "<span id=\"doclink_" + lastString[0] + "\" style=\"\">" ;
						tempString += "<img src=\"/seeyon/apps_res/doc/images/docIcon/"+lastString[2]+"\" />";
						tempString += "<a href=\"#\" onclick=\"fnOpenKnowledge('"+lastString[0]+"')\">"+lastString[1]+"</a>";
						tempString += "<img src=\"/seeyon/common/images/attachmentICON/delete.gif\" onclick=\"deleteDocLink( 'doclink_"+lastString[0]+ "','"+lastString[1] + "','"+lastString[0]+ "')\"/>";
						tempString += "</span>" ;
					}
					else if(document.getElementById("doclink_" + lastString[0]).style.display == "none") {
						document.getElementById("doclink_" + lastString[0]).style.display = "";
					}
				}

			}
		}
		tempString += document.getElementById("initSpan").innerHTML;
		document.getElementById("delDocLinkId").value = boolString[3];	// 最后要删除的ID
		document.getElementById("sourceId").value = boolString[4];		
		
		// 要添加的关联文档ID
		lastAddString(addString);
		// 更新关联文档的数量
		var theNumber=getNumber();		// 关联文档的数量
		document.getElementById("currentNumber").value = theNumber;
		// 设置数量显示
		document.getElementById("allDocLinkNumber").innerHTML = theNumber;
		document.getElementById("doclink").style.display = "";
		document.getElementById("initSpan").innerHTML = tempString;		
	}
}


// 删除关联文档
function deleteDocLink(theFlag, theName, theId) {
	
	if(window.confirm(v3x.getMessage('DocLang.doc_rel_delete_confirm') + theName + "'?")) {
		var docLinkId = document.getElementById(theFlag);
		docLinkId.style.display = "none";
		// 更改关联文档个数
		var the_allDocLinkNumber = document.getElementById("allDocLinkNumber");	
		var _currentNumber = document.getElementById("currentNumber").value; 	// 当前的关联文档个数
		var tempNumber = _currentNumber-1;
		document.getElementById("currentNumber").value = tempNumber;  // 更新关联文档个数
		if(tempNumber > 0) {
			the_allDocLinkNumber.innerHTML = tempNumber;
		}
		else {
			the_allDocLinkNumber.innerHTML = "";
			document.getElementById("doclink").style.display = "none";
		}
		
		var theValue = document.getElementById("delDocLinkId").value;
		if(theValue == null || theValue == "") {
			document.getElementById("delDocLinkId").value = theId;
		}
		else {
			theValue += ",";
			theValue += theId;
			document.getElementById("delDocLinkId").value = theValue;		// 得到删除了的关联文档的ID值
		}
		
		deleteAddLink(theId);		// 更新要保存的关联文档ID

	}
	
}
	
// 判断当前ID是否已经存在于删除得ID中
function isContain(temp_id) {
	var deleteId = document.getElementById("delDocLinkId").value;
	var the_delete = deleteId.split(",");
	for(var i = 0; i < the_delete.length; i++) {
		if(temp_id == the_delete[i]) {
			document.getElementById("doclink_" + the_delete[i]).style.display = "";
			return false;
		}
	}
	return true;
	
}
// 从要添加得关联ID串中，移出不需要添加的ID:the_id
function deleteAddLink(the_id) {
	var theLink = document.getElementById("addDocLink").value;
	var the_link = theLink.split(",");
	var str = "";
	for(var i = 0; i < the_link.length; i++) {
		if(the_link[i] == the_id) {
			continue;
		}
			str += the_link[i];
			str += ",";
	}
	document.getElementById("addDocLink").value = str.substring(0, str.length - 1);
}
function lastAddString(_addString) {
	var temp = document.getElementById("addDocLink").value;
	if(temp == null || temp == "") {
		document.getElementById("addDocLink").value = _addString;
	}
	else {
		var temp_length = temp.split(",");
		var addString_length = _addString.split(",");
		for(var i = 0; i < addString_length.length; i++) {
			var number = 0;
			for(var j = 0; j < temp_length.length; j++) {
				if(addString_length[i] == temp_length[j]) {
					break;		// 要添加的ID已经存在，跳出
				}
				else {
					number = number + 1;
				}
			}
			
			// 要添加的ID不存在时
			if(number == temp_length.length) {		
				temp += ",";
				temp += addString_length[i];
				document.getElementById("addDocLink").value = temp;
			}
		}
	}
}
// 获取当前得关联文档数
function getNumber() {
	var addString = document.getElementById("addDocLink").value;
	var addString_len = addString.split(",");
	var number = addString_len.length
	return number;
}
// 新建或编辑文档时，设置文档属性界面
function editDocProperties(flag) {
	var surl = "";
	if (jsURL && jsURL != "") {
		surl = jsURL + "?method=editDocPropertiesPage&flag=" + flag;
	} else {
		surl = "/seeyon/doc.do?method=editDocPropertiesPage&flag=" + flag;
	}
	getA8Top().docPropertiesWin = getA8Top().$.dialog({
		title: v3x.getMessage('DocLang.doc_jsp_properties_title'),
		transParams:{'parentWin':window},
		url: surl,
		width: 500,
		height: 500,
		isDrag:false
	});
	//查找了几处代码都没有发现需要返回值的地方，，发现再说吧....
//	// result为dialog关闭后的返回值
//	if (result != undefined) {
//		document.getElementById("contentDiv").innerHTML = result[0];
//		document.getElementById("extendDiv").innerHTML = result[1];
//		if(document.getElementById("button1")){
//			document.getElementById("button1").disabled = false ;
//		}
//		
//	}
}
/*--------------------------------------- 关联文档 End --------------------------------------*/
var winDocAlert;
// 进入文档提醒页面
function alertview(docResId, isFolder){
	var surl = jsURL + "?method=docAlertView&docResId=" + docResId + "&isFolder=" + isFolder;
	if(v3x.getBrowserFlag('openWindow') == false){
			  winDocAlert=v3x.openDialog({
    	 			id:"alertview",
    				title:"",
    	 			url : surl,
    	 			width: 400,
					height: 270,
					// type:'panel',
					// relativeElement:obj,
					 buttons:[{
			    	 id:'btn1',
			    	 text: v3x.getMessage("DocLang.submit"),
			    	 handler: function(){
			    	       winDocAlert.getReturnValue();
					        // win.close();
				     }
			    	            
			    	 }, {
			    	 id:'btn2',
			    	 text: v3x.getMessage("DocLang.cancel"),
			    	 handler: function(){
			    	    winDocAlert.close();
			    	 }
			    	 }]
			});
		} else {
			v3x.openWindow({
				url : surl,
				width : "400",
				height : "270",
				resizable : "true"
			});
		}
}

function openDetail(subject, _url) {
    _url = jsColURL + "?method=detail&" + _url;
    var rv = v3x.openWindow({
        url: _url,
        workSpace: 'yes',
        dialogType: 'open'
    });
}

function enableEle(id){
	try{
		var ele = document.getElementById(id);
		if(ele)
			ele.disabled = false;
	}catch(e){alert("ex: " + e)}
}
function disableEle(id){
	try{
		var ele = document.getElementById(id);
		if(ele)
			ele.disabled = true;
	}catch(e){}
}
/**
 * AJAX记录操作日志 fileId 文档的id logType 操作的类型
 */
function ajaxRecordOptionLog(fileId,logType){
	try{
	  var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "recoidopertionLog", false);
	      requestCaller.addParameter(1 ,"String" ,fileId) ;
	      requestCaller.addParameter(2 ,"String" ,logType) ;
	      if(arguments.length > 2)
	      		requestCaller.addParameter(3 ,"boolean" ,arguments[2]) ;
	      requestCaller.serviceRequest() ;	
	}catch(e){
	}
}
/**
 * 获取当前文档的锁定状态和反馈信息
 */
function getLockMsgAndStatus(docId) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getLockMsgAndStatus", false);
			requestCaller.addParameter(1, "Long", docId);
			if(arguments && arguments.length == 2) {
				requestCaller.addParameter(2, "Long", arguments[1]);
			}
			requestCaller.needCheckLogin = false;
			
		return requestCaller.serviceRequest();
	}
	catch(e) {
		alert(e);
		return [LOCK_MSG_NONE, LockStatus_None];
	}
}
function lockWhenAct(docResId) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "docHierarchyManager", "lockWhenAct", false);
			requestCaller.addParameter(1, "Long", docResId);
		requestCaller.serviceRequest();
	}
	catch(e) {
		// -> Ignore
	}
}
function unlockAfterAction(docId) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "unLockAfterAct", false);
			requestCaller.addParameter(1, "Long", docId);
			requestCaller.needCheckLogin = false;
		requestCaller.serviceRequest();
	}
	catch(e) {
		// -> Ignore
	}
}
/**
 * 文档历史版本，此方法调用有两个入口： 1.文档右键菜单中的"历史版本"； 2.打开文档之后，顶部的功能菜单中的"历史版本"。
 */
var docHisItem = {};
function docHistory(docResId, all, edit, add, readonly, browse, list, isBorrowOrShare, docLibId, docLibType, docResName,entranceType) {
	var requestCaller = new XMLHttpRequestCaller(this, "docVersionInfoManager", "hasDocVersion", false);
    requestCaller.addParameter(1 ,"Long", docResId) ;
    var has = requestCaller.serviceRequest() ;	

    if(has == "false" || has == false){
    	alert(v3x.getMessage('DocLang.doc_has_no_history_alert'));
    	return;
    }
    
	var url = jsURL + "?method=listAllDocVersionsFrame&docResId=" + docResId + "&all=" + all + "&edit=" + edit + "&add=" + add + 
				"&readonly=" + readonly + "&browse=" + browse + "&list=" + list + "&isBorrowOrShare=" + isBorrowOrShare +
			  	"&docLibId=" + docLibId + "&docLibType=" + docLibType + "&docResName=" + encodeURI(docResName) + "&entranceType=" + entranceType;
	var fromTopMenu = arguments[arguments.length - 1] == "TopMenu";
	docHisItem.fromTopMenu = fromTopMenu;
	getA8Top().docHisWin = getA8Top().$.dialog({
        title:v3x.getMessage("DocLang.doc_menu_history_label"),
        transParams:{'parentWin':window},
        url: url,
        width:window.screen.width,
        height:window.screen.height,
        isDrag:false
    });
}

function docHisCollBack (refresh) {
	getA8Top().docHisWin.close();
	if(refresh == "true"){
		if(docHisItem.fromTopMenu) {
			getA8Top().window.returnValue = "true";
			getA8Top().window.close();
		} else {
			try{
				window.location.reload(true);
			} catch(e){}
		}
	}
}
/**
 * 文档(库)列表名称栏处的操作图标，点击之后显示操作菜单
 */
function editImg(id) {
	if(isAdvancedQuery == true || isAdvancedQuery == 'true')
		return;
	
	var menudiv = document.getElementById("_" + id);
	if(menudiv == null){
		return;
	}	
	menudiv.parentNode.style.position = "relative";
	menudiv.className = "editContentOver";
}
/**
 * 隐藏文档(库)列表名称栏处的操作图标
 */
function removeEditImg(id){
	if(isAdvancedQuery == true || isAdvancedQuery == 'true')
		return;
		
	var menudiv = document.getElementById("_" + id);
	if(menudiv == null){
		return;
	}	
	menudiv.parentNode.style.position = "static";
	menudiv.className = "editContent";
}
/**
 * 显示当前位置
 */
function showLocation(itemId) {
// var item = null ;//getA8Top().contentFrame.topFrame.findMenuItem(itemId);
	var text = "";
	var locations = [];
// if(item != null){
// locations[locations.length] = item.parentMenu.name
// locations[locations.length] = item.name;
// try{
// var parentMenuId = item.parentMenu.id;
// if(parentMenuId){
// //getA8Top().contentFrame.topFrame.showMenuItems(parentMenuId);
// }
// }catch(e){}
// }
	
	if(arguments.length > 1){
		for(var i = 1; i < arguments.length; i++){
			if(arguments[i]){
				locations[locations.length] = arguments[i];
			}
		}
	}
	showLocationText(locations.join(" - "));
}
/**
 * 显示文档右侧列表的当前路径，也可用于其它类似页面结构的当前位置显示
 */
function showLocationText(text){
// var obj = getA8Top().contentFrame.document.all.navigationFrameset;
// if(obj == null){
// return;
// }
//	
// obj.rows = "0,*";
  try{
	document.getElementById("nowLocation").innerHTML = text;
  }catch(e){}
}
function insertAttachmentAndActiveOcx(){
	insertAttachment();
	activeOcx();
}
/**
 * 将焦点设置到office控件上，否则容易出现因为打开模态对话框以后 office控件焦点丢失不能编辑的问题。
 */
function activeOcx(){
	try{
		activeOfficeOcx();
	}catch(e){
		
	}
}
/**
 * 根据入口值，匹配从哪里打开
 */
function fnTransIntoOpenFrom(entranceType) {
	entranceType = parseInt(entranceType);
	if (entranceType >= 1 && entranceType <=5) {
		return 'docCenter';
	} else if (entranceType === 7) {
		return 'docLearningMore';
	} else if(entranceType === 8) {
		return 'glwd';
	} else {
		return 'others';
	}
}

function fnCloseRecommendDialog() {
	var _dialog = top.frames['main']._dialog;
	top.frames['main']._dialog = null;
	 //刷新知识查看
	 if(top.docOpenDialogOnlyId_main_iframe && top.docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse){
         top.docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse();
     }
	_dialog.close();
}

/**
 * 检查文档有效性
 */
function fnValidInfo(rowId){
	var ids = "";
	if (rowId == "undefined" || rowId == null || rowId == "") {
		$("input[name=id]").each(function(){
			if(this.checked){
				ids += $(this).attr("value")+",";
			}
		});
	}else{
		ids = rowId;
	}
	
	if(ids!=""){
		var requestCaller = new XMLHttpRequestCaller(this, "docHierarchyManager", "getValidInfo", false);
		requestCaller.addParameter(1, "String", ids);
		ret = requestCaller.serviceRequest();
		if(ret !== '0') {
		    fnAlert(fnI18n('doc.prompt.inexistence'));
		    return false;
	    }else{
	    	return true;
	    }
	}
	return false;
}