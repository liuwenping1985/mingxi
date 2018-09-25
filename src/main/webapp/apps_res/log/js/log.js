////////////////////////////////////////////////
////////////////////////////////////////////////
////////////常用链接JS  edit by zf///////////////
	function addLink(){
		var categoryId=document.getElementById("categoryId").value;
		if(categoryId == "-1") {			
			alert(v3x.getMessage("LinkLang.link_alert_category_select"));
			return;
		}
		parent.theBottom.location.href=_linkURL+"?method=getAddLinkPage&flag=true&categoryId="+categoryId;
	}
	
	//高级选项
	function advanceOption(){
		var methodInfo=document.getElementById("methodInfo").style.display;
		var listTable=document.getElementById("listTable").style.display;
		var operatorTable=document.getElementById("operatorTable").style.display;
		var _theCategory=document.getElementById("theCategory").value;
		
		if(methodInfo == "none" && listTable =="none" && operatorTable == "none" ){
			document.getElementById("methodInfo").style.display="";
			if(_theCategory != '1'){
				document.getElementById("listTable").style.display="";
				document.getElementById("operatorTable").style.display="";
			}
		}else{
			document.getElementById("methodInfo").style.display="none";
			document.getElementById("listTable").style.display="none";
			document.getElementById("operatorTable").style.display="none";
		}
		
	}
	
	function addParam(){
		var paramTable=document.getElementById("paramTable");		//获取表名
		var tr=paramTable.insertRow();
		var td1=tr.insertCell();
		td1.innerHTML="<input type='checkbox' name='id' id='id' />";
		td1.align = "center";
		td1.className="sort";
		var td2=tr.insertCell();
		td2.innerHTML="<input type=\"text\" id=\"paramName\" name=\"paramName\" size='18' >";		//参数名称
		td2.className="sort";
		var td3=tr.insertCell();
		td3.innerHTML="<input type=\"text\" id=\"paramSign\" name=\"paramSign\" size='15'>";		//参数标记
		td3.className="sort";
		var td4=tr.insertCell();
		td4.innerHTML="<input type=\"text\" id=\"initValue\" name=\"initValue\" size='18'>";		//参数预设值
		td4.className="sort";
		var td5=tr.insertCell();
		td5.align = "center";
		td5.innerHTML="<input type='checkbox' id='isPassWord' name='isPassWord' onclick='getPassword();' ><input type=hidden id='hidPassword' name='hidPassword' value='0' >";					//是否是密码字段
		td5.className="sort";
		
		
	}
	
	function getPassword(){
		var isPassWord=document.getElementsByName("isPassWord");
		var hidPassword=document.getElementsByName("hidPassword");
		for(var i=0;i<isPassWord.length;i++){
			if(isPassWord[i].checked){
				hidPassword[i].value="1";
			}else{
				hidPassword[i].value="0";
			}
		}
	}
	
	function deleteParam(){
		var theId=document.getElementsByName("id");
		var count = 0;
		for(var i=0;i<document.getElementsByName("id").length;i++){
			if(theId[i].checked && theId[i].parentNode.parentNode.tagName == "TR"){
				count++;
				
				if(count == 1){
					if(!confirm(v3x.getMessage("LinkLang.link_alert_param_delete_confirm")))
						return;
				}
				
				theId[i].parentNode.parentNode.removeNode(true);

				i--;
			}
		}
		
		if(count == 0){
			alert(v3x.getMessage("LinkLang.link_alert_param_delete_select"));
		}
	}
	
	//选择分类
	function getCategory(){
		var theValue="";
		var linkCategory=document.getElementById("linkCategory");	//分类
		for(var i=0;i<linkCategory.length;i++){
			if(linkCategory.options[i].selected){
				theValue=linkCategory.options[i].value;
				break;
			}
		}
		if(theValue == '1'){		//常用链接
			document.getElementById("doAdd").disabled="disabled";
			document.getElementById("doDelete").disabled="disabled";
			document.getElementById("methodInfo").style.display="none";
			document.getElementById("listTable").style.display="none";
			document.getElementById("operatorTable").style.display="none";
			for(var k=1;k<document.getElementById("paramTable").rows.length;k++){
				if(document.getElementById("paramTable").rows[k].tagName == "TR"){
					document.getElementById("paramTable").rows[k].removeNode(true);
					k--;
				}
			}
		}else if(theValue != ""){
			document.getElementById("doAdd").disabled="";
			document.getElementById("doDelete").disabled="";
			document.getElementById("methodInfo").style.display="";
			document.getElementById("listTable").style.display="";
			document.getElementById("operatorTable").style.display="";
		}else{
			document.getElementById("doAdd").disabled="";
			document.getElementById("doDelete").disabled="";
			document.getElementById("methodInfo").style.display="none";
			document.getElementById("listTable").style.display="none";
			document.getElementById("operatorTable").style.display="none";
		}
		document.getElementById("theCategory").value=theValue;		//保存选择得分类
	}
	
	//验证输入得参数
	// return true: 没有通过验证
	function validateParam(){
		var whitespace="\t\n\r";
		var paramName=document.getElementsByName("paramName");
		var paramSign=document.getElementsByName("paramSign");
		
		var nameList = new Properties();
		var signList = new Properties();
		
		var bool=false;
		var flag = "good";
		var temp = "";
		for(var i=0;i<paramName.length;i++){
			if(paramName[i] == null || paramName[i].value.length == 0 || paramSign[i]==null || paramSign[i].value.length == 0){
				bool = true;
				flag = "empty";
				break;
			}
			for(var k=0;k<paramName[i].value.length;k++){
				var c=paramName[i].value.charAt(k);
				if(whitespace.indexOf(c) == -1){
					bool=false;
				}else{
					bool=true;
					flag = "empty";
					break;
				}
			}
			if(bool)
				break;
				
			temp = nameList.get(paramName[i].value);
			if(temp != null){
				bool = true;
				flag = "dupliName";
				break;
			}
			nameList.put(paramName[i].value, "");
			
			
			for(var j=0;j<paramSign[i].value.length;j++){
				var c=paramSign[i].value.charAt(j);
				if(whitespace.indexOf(c) == -1){
					bool=false;
				}else{
					bool=true;
					flag = "empty";
					break;
				}
			}
			if(bool)
				break;
			temp = signList.get(paramSign[i].value);
			if(temp != null){
				bool = true;
				flag = "dupliSign";
				break;
			}
			signList.put(paramSign[i].value, "");
			
		}
		

		if(bool && flag == 'dupliName')
			alert(v3x.getMessage("LinkLang.link_alert_param_dupli_name"));
		else if(bool && flag == 'dupliSign')
			alert(v3x.getMessage("LinkLang.link_alert_param_dupli_sign"));
		else if(bool)
			alert(v3x.getMessage("LinkLang.link_alert_param_input"));
		
		return bool;
	}
	
	/**
	 * 测试url有效性
	 */
	function validateURL(){
		theForm.target="linkIframe";
		theForm.action=_linkURL+"?method=validateUrl";
		theForm.submit();
	}
	function openValidateUrlWindow(){
		var log = v3x.openWindow({
			url : _linkURL+"?method=validateUrlView",
			workSpace : 'yes',
			resizable : "false"
		});
	}
	
	function hasSameSystem(sname, categoryId, systemId){
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxOuterlinkManager",
				 "hasSameNameSystem", false);
			requestCaller.addParameter(1, "String", sname);
			requestCaller.addParameter(2, "Long", categoryId);
			requestCaller.addParameter(3, "Long", systemId);
					
			var flag = requestCaller.serviceRequest();
			
			return flag;
		}
		catch (ex1) {
			alert("Exception : " + ex1.message);
			return 'false';
		}
	}
	
	function doLink(flag,theId){
		var theForm=document.getElementById("theForm");	
		if(!checkForm(theForm))
			return false;
		
		var linkName=document.getElementById("linkName");			//名称
		var linkManager=document.getElementById("linkManager");		//管理员
		var linkURL=document.getElementById("linkURL");				//链接地址
		var categoryId=document.getElementById("theCategory");	
//		var validateUrl = document.getElementById("chk_test_valid").checked;
		
//		var theCategory=document.getElementById("theCategory").value;	//分类
		
//		if(linkName.value == linkName.deaultValue){
//			alert(v3x.getMessage("LinkLang.link_alert_link_name_input"));
//			return ;
//		}
////		if(theCategory == null || theCategory == ""){
////			alert('请选择一个分类');
////			return ;
////		}
//		if(linkManager.value == linkManager.deaultValue){
//			alert(v3x.getMessage("LinkLang.link_alert_user_select"));
//			return ;
//		}
//		if(linkURL.value == linkURL.deaultValue){
//			alert(v3x.getMessage("LinkLang.link_alert_link_address_not_null"));
//			return ;
//		}
		if(validateParam()){			
			return ;
		}
				
			// 利用ajax实现url验证
//			alert("jsp:" + linkURL.value)
		var valid = isValidUrl(linkURL.value);
		if(valid == 'false'){
			alert(v3x.getMessage("LinkLang.link_alert_url_invalid"));
			return false;
		}

		var _theId = '0';
		if(flag == 'modify')
			_theId = theId;
		var flagExist = hasSameSystem(linkName.value, categoryId.value, _theId);
		if(flagExist == 'true'){
			alert(v3x.getMessage("LinkLang.link_exception_name_used"));
			return ;
		}
				
		saveAttachment();	//保存附件
		
//		var urlRet = false;
//		if(validateUrl){
//			urlRet = validateURL();
//		}


		
//		if(urlRet){
			theForm.target="linkIframe";
			if(flag == 'addNew'){			//表示添加
				theForm.action=_linkURL+"?method=addLink";
				theForm.submit();
			}else if(flag == 'modify'){
				theForm.action=_linkURL+"?method=modifyLink&linkId="+theId;
				theForm.submit();
			}
//		}
		
		
	}
	
	// 利用ajax验证url有效性
	function isValidUrl(str){
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxOuterlinkManager",
				 "isValidUrl", false);
			requestCaller.addParameter(1, "String", str);
					
			var flag = requestCaller.serviceRequest();
			
			return flag;
		}
		catch (ex1) {
			alert("Exception : " + ex1.message);
			return 'true';
		}
	}
	
	//删除链接
	function deleteLink(){
		var theId=parent.theTop.document.getElementsByName("id");
		var theForm=document.getElementById("theForm");
		var number=0;
		var str="";
		for(var i=0;i<theId.length;i++){
			if(theId[i].checked){
				str+=theId[i].value;
				str+=",";
				number=number+1;
			}
		}
		
		if(number == 0){
			alert(v3x.getMessage("LinkLang.link_alert_delete_select"));
			return ;
		}
		str=str.substring(0,str.length-1);
		theForm.target="linkIframe";
		
		var userconfirm = false;
		if(number > 1)
			userconfirm = window.confirm(v3x.getMessage("LinkLang.link_alert_delete_confirm"));
		else
			userconfirm = window.confirm(v3x.getMessage("LinkLang.link_alert_delete_confirm_single"));
		
		if(userconfirm){
			theForm.action=_linkURL+"?method=deleteLink&deleteId="+str;
			theForm.submit();
		}
	}
	
	//进入修改页面
	function modifyLink(){
		var theId=parent.theTop.document.getElementsByName("id");
	//	var theForm=document.getElementById("topMenu");
		var number=0;
		var linkId="";
		for(var i=0;i<theId.length;i++){
			if(theId[i].checked){
				linkId=theId[i].value;
				number=number+1;
			}
		}
		if(number == 0){
			alert(v3x.getMessage("LinkLang.link_alert_update_select"));
			return ;
		}
		if(number >1){
			alert(v3x.getMessage("LinkLang.link_alert_update_multi_items"));
			return ;
		}
		parent.theBottom.location.href=_linkURL+"?method=getModifyLink&linkId="+linkId+"&flag=true";
	}
	
	function doBack(){
		parent.bottom.location.href=_linkURL+"?method=index";
	}
	
	function setUserLink(userId){
		var theId=document.getElementsByName("id");
		var str="";
		var number=0;
		var hasOptions = 'false';
		for(var i=0;i<theId.length;i++){
			if(theId[i].checked){
				str=theId[i].value;
				hasOptions = theId[i].hasOptions;
				number=number+1;
			}
		}
		
		if(number == 0){
			alert(v3x.getMessage("LinkLang.link_alert_conig_select"));
			return ;
		}
		if(number >1){
			alert(v3x.getMessage("LinkLang.link_alert_config_multi_items"));
			return ;
		}
		
		if(hasOptions == 'false'){
			alert(v3x.getMessage("LinkLang.link_alert_no_param_set"));		
			parent.bottom.location.href=_linkURL+"?method=userLinkOperator&linkSystemId="+str+"&userId="+userId;
		}else
			parent.bottom.location.href=_linkURL+"?method=userLinkOperator&linkSystemId="+str+"&userId="+userId+"&dbClick=true";
	}
	
	function addOptionValue(userId){
		var theValue=document.getElementsByName("theValue");
		var theForm=document.getElementById("theForm");
		var str="";
		for(var i=0;i<theValue.length;i++){
			if(i != theValue.length-1){
				str+=theValue[i].value;
				str+=",";
				str+=theValue[i].optionId;
				str+=";";
			}else{
				str+=theValue[i].value;
				str+=",";
				str+=theValue[i].optionId;
			}
		}
		theForm.target="optionValueIframe";
		theForm.action=_linkURL+"?method=addLinkOptionValue&userId="+userId+"&optionValue="+str;
		theForm.submit();
	}
	
	function addLinkCategory(flag){
		var str="";
		if(flag == 'modify'){
			var categoryId=document.getElementById("categoryId").value;
			if(categoryId == "-1") {
				alert(v3x.getMessage("LinkLang.link_alert_category_select"));
				return;
			}
			var isSystem=document.getElementById("isSystem").value;
			str=_linkURL+"?method=getCategory&categoryId="+categoryId+"&isSystem="+isSystem+"&isModify=true";
		}else{
			str=_linkURL+"?method=getCategory&isModify=false";
		}
		
		var returnvalue = v3x.openWindow({
			url : str,
			width : "380",
			height : "200",
			resizable : "no",
			scrollbars : "no"
		});
		
		if(returnvalue == 'true'){
			parent.linkTree.location.reload(true);
		}
	}
	
	function hasSameCategory(cname, categoryId){
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxOuterlinkManager",
				 "hasSameNameCategory", false);
			requestCaller.addParameter(1, "String", cname);
			requestCaller.addParameter(2, "Long", categoryId);		
			var flag = requestCaller.serviceRequest();
			
			return flag;
		}
		catch (ex1) {
			alert("Exception : " + ex1.message);
			return 'false';
		}
	}
	

	
	//添加类别
	function addCategory(){
		
		var categoryName=document.getElementById("categoryName");
		var categoryManager=document.getElementById("categoryManager");
		var mainForm=document.getElementById("mainForm");
		
		if(categoryName.value == categoryName.deaultValue){
			alert(v3x.getMessage("LinkLang.link_alert_name_not_null"));
			return ;
		}
		if(categoryManager.value == categoryManager.deaultValue){
			alert(v3x.getMessage("LinkLang.link_alert_user_select"));
			return ;
		}
		
		var flag = hasSameCategory(categoryName.value, '0');
		if(flag == 'true'){
			alert(v3x.getMessage("LinkLang.link_exception_category_name"));
			return ;
		}
		
		mainForm.target="linkIframe";
		mainForm.action=_linkURL+"?method=addCategory";
		mainForm.submit();
		
		
	}
	/////////修改///////////
	function modifyLinkCategory(categoryId){
		var mainForm=document.getElementById("mainForm");
		var categoryName=document.getElementById("categoryName");
		var categoryManager=document.getElementById("categoryManager");
		
		if(isSystem != 'true'){
			if(categoryName.value == categoryName.deaultValue){
				alert(v3x.getMessage("LinkLang.link_alert_name_not_null"));
				return ;
			}
		}
		if(categoryManager.value == categoryManager.deaultValue){
			alert(v3x.getMessage("LinkLang.link_alert_user_select"));
			return ;
		}
		
		var flag = hasSameCategory(categoryName.value, categoryId);
		if(flag == 'true'){
			alert(v3x.getMessage("LinkLang.link_exception_category_name"));
			return ;
		}
		
		mainForm.target="linkIframe";
		mainForm.action=_linkURL+"?method=addCategory&categoryId="+categoryId+"&isModify=true";
		mainForm.submit();
	}
	
	function deleteLinkCategory(){
		var categoryId=document.getElementById("categoryId").value;
		var categoryName=document.getElementById("categoryName").value;
		var isSystem=document.getElementById("isSystem").value;
		var theForm=document.getElementById("theForm");
		if(categoryId == null || categoryId == ""){
			alert(v3x.getMessage("LinkLang.link_alert_delete_select"));
			return ;
		}
		if(isSystem == '1'){
			alert(v3x.getMessage("LinkLang.link_alert_category_system_delete"));
			return ;
		}
		theForm.target="linkIframe";
//		alert(parent.linkTree.tree.getSelected())
		if(window.confirm(v3x.getMessage("LinkLang.link_alert_delete_confirm_category",categoryName))){
			theForm.action=_linkURL+"?method=deleteCategory&categoryId="+categoryId;
			theForm.submit();
		}
		
	}
	
	function editSomething(){	
		if(currentFocus == 'category'){
			addLinkCategory('modify');
		}else{
			modifyLink();
		}	
	}
	function deleteSomething(){
		if(currentFocus == 'category'){
			deleteLinkCategory();
		}else{
			deleteLink();
		}
	}
	
function showUser(elements,sysFlag){
  		if(elements){
  			if(sysFlag == 'GROUP') {
	 			document.getElementById("userName").value = getNameString(elements,true);
				document.getElementById("users").value = getIdsString(elements, true); 				
  			}else{
 	 			document.getElementById("userName").value = getNameString(elements,false);
				document.getElementById("users").value = getIdsString(elements, true); 	 				
  			}

  		}
	}

function getNameString(elements,systemFlag){
	if(!elements){
		return "";
	}
	
	var sp = v3x.getMessage("V3XLang.common_separator_label");
	
	var names = [];
	for(var i = 0; i < elements.length; i++) {
		var e = elements[i];
		var _name = null;
		if(e.accountShortname && systemFlag){
			_name = e.name + "(" + e.accountShortname + ")";
		}
		else{
			_name = e.name;
		}
		
		names[names.length] = _name;
	}
	
	return names.join(sp);
}
	
/**
 * 
 */
function doDetailSearch(){
	var startDay = document.getElementById("startDay").value;
	var endDay = document.getElementById("endDay").value;

	if(startDay != "" && endDay != ""){
		if(compareDate(startDay,endDay)>0){
			alert(v3x.getMessage("LogLang.log_search_overtime"))		
			return false;
		}
	}
	var ip1 = document.getElementById("ip1").value;
	var ip2 = document.getElementById("ip2").value;
	var ip3 = document.getElementById("ip3").value;
	var ip4 = document.getElementById("ip4").value;
	var or = ip1 != "" || ip2 != "" || ip3 != "" || ip4 != "";
	if(or==true){
		var and = ip1 != "" && ip2 != "" && ip3 != "" && ip4 != "";
		if(and == true)
			document.getElementById("ipAddress").value = ip1 + "." + ip2 + "." + ip3 + "." + ip4;
		else{
			alert(v3x.getMessage("LogLang.logon_alertIP"));
			return;
		}
	}
	document.getElementById("userName").disabled=true;
	var form1 = document.forms["form1"];
	if(form1){
		form1.isExprotExcel.value = "false" ;
		form1.target = "";
		form1.action = logonLog + "?method=detailSearch&from=audit";
		form1.submit();
	}
}

/**
 * 清除日志
 */
function clearLogs(type){
	//if(!confirm(v3x.getMessage("LogLang.logon_del"))){
	//	return;
	//}
	if(type == "LogonLog"){ //登录日志
		var rv = v3x.openWindow({
			url: logonLog + "?method=showClearLogsDlg&type=logon",
			width: 320,
			height: 200, 
			scrollbars:"no"
		});
		if(!rv) return;
		location.href = logonLog + "?method=clearLogs&dateCondition=" + rv;
	}
	else if(type == "AppLog"){
		var rv = v3x.openWindow({
			url: logonLog + "?method=showClearLogsDlg&type=app",
			width: 320,
			height: 200, 
			scrollbars:"no"
		});
		if(!rv) return;
		location.href = appLog + "?method=delAppLog&dateCondition=" + rv;
	}
}

/**
 * 导出Excel
 */
function exportExcel(type){
	if(type == "AppLog"){ 
		pageQueryMap = dataIFrame.pageQueryMap;
	}
	if(pageQueryMap){
		if(parseInt(pageQueryMap.get('count')) > 10000){
			alert(v3x.getMessage("LogLang.logon_logs_beyond_maximum", 10000));
			return false;
		}
		else if(parseInt(pageQueryMap.get('count')) > 2000){
			if(!confirm(v3x.getMessage("LogLang.logon_to_excel"))){
				return;
			}
		}
	}
	if(type == "LogonLog"){ //登录日志
		var startDay = document.getElementById("startDay").value;
		var endDay = document.getElementById("endDay").value;

		if(startDay != "" && endDay != ""){
			if(compareDate(startDay,endDay)>0){
				alert(v3x.getMessage("LogLang.log_search_overtime"))		
				return false;
			}
		}
		var ip1 = document.getElementById("ip1").value;
		var ip2 = document.getElementById("ip2").value;
		var ip3 = document.getElementById("ip3").value;
		var ip4 = document.getElementById("ip4").value;
		var or = ip1 != "" || ip2 != "" || ip3 != "" || ip4 != "";
		if(or==true){
			var and = ip1 != "" && ip2 != "" && ip3 != "" && ip4 != "";
			if(and == true)
				document.getElementById("ipAddress").value = ip1 + "." + ip2 + "." + ip3 + "." + ip4;
			else{
				alert(v3x.getMessage("LogLang.logon_alertIP"));
				return;
			}
		}
		var theForm = document.forms["form1"];
		if(theForm){
		    var beginDate = document.getElementById("startDay").value;
			var endDate = document.getElementById("endDay").value;
			if(compareDate(endDate, beginDate) < 0){
				alert(v3x.getMessage("LogLang.log_search_overtime")) ;
				return false;
			}
		    theForm.target = "HiddenFrame" ;
		    theForm.action = logonLog + "?method=exportExcel" ;
		    theForm.submit(); 
		}
	}
	else if(type == "AppLog"){ //应用日志
		var theForm = document.getElementById("appLogForm");
		if(theForm) {
	    	var beginDate = pageQueryMap.get("beginDate") ||'';
			var endDate = pageQueryMap.get("endDate")||'';
			var selectPersonIds = pageQueryMap.get("selectPersonIds")||'';
			var moduleId = pageQueryMap.get("moduleId")||'';
		    theForm.target = "appLogDataExportExcel" ;
			var pageFrame = window.dataIFrame;
			var pageUri = pageFrame.location.href;
			var pageMethod = getUriParam(pageUri, "method");
			theForm.action = appLog + "?method=appLogDataExportExcel&pageMethod=" + pageMethod +"&moduleId=" + moduleId +"&beginDate=" + beginDate +"&endDate=" + endDate +"&selectPersonIds=" + selectPersonIds;
		    theForm.submit() ;
		}
	}
}

/**
 * 导出Excel后的处理
 */
function exportOK(){
    try{
		myBar.enabled("exportExcel");
    }
    catch(e){}	
}

/**
 * 打印
 */
function doPrint(type){
	var pagerTd = document.getElementById("pagerTd");
	var printObj = document.getElementById("dataList");
	if(type == "AppLog"){
		pagerTd = dataIFrame.document.getElementById("pagerTd");
		printObj = dataIFrame.document.getElementById("scrollListDiv");
	}
	if(type == "onLineLog"){
		pagerTd = listIframe.document.getElementById("pagerTd");
		printObj = listIframe.document.getElementById("scrollListDiv");
	}	
	if(pagerTd){
		pagerTd.style.display = 'none';
	}
	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/apps_res/collaboration/css/collaboration.css");
	cssList.add(v3x.baseURL + "/common/css/default.css");
	cssList.add(v3x.baseURL + "/common/skin/default/skin.css");
	var pl = new ArrayList();
	
	if(printObj){
		var html = printObj.innerHTML;
		html = html.replace(/like-a/gi,"").replace(/openList\S*\)/gi,"");
		var printObjFrag = new PrintFragment("", html);
		pl.add(printObjFrag);
		printList(pl,cssList);
	}
	if(pagerTd){
		pagerTd.style.display = '';
	}
}