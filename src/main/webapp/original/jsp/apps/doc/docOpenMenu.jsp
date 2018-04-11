<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<base target="_self">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docVersion.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/docMenu.css${v3x:resSuffix()}' />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	var docResourceName = "${v3x:escapeJavascript(dr.frName)}";
	var isLocked = "${isLocked}";
	<c:set value="${sessionScope['com.seeyon.current_user'].id}" var="currentUserId" />
	var currentUserId = '${currentUserId}';
	var docResId = "${param.docResId}";
	var docLibId = "${param.docLibId}";
	var docLibType = "${param.docLibType}";
	var prop_edit_${dr.id} = "${param.all || param.edit}";
	var name = docResourceName;
	
	var all = '${param.all}';
	var edit = '${param.edit}';
	var add = '${param.add}';
	var readonly = '${param.readonly}';
	var browse = '${param.browse}';
	var list = '${param.list}';
	
	var isPrivateLib = '${isPrivateLib}';
	var isGroupLib = '${isGroupLib}';
	var isAdministrator = '${isAdministrator}';
	var isGroupAdmin = '${isGroupAdmin}';
	var depAdminSize = '${depAdminSize}';
	
	var isShareAndBorrowRoot = '${param.isBorrowOrShare}';

	// 菜单权限
	var canNewColl = "${v3x:hasNewCollaboration()}";
	var canNewMail = "${v3x:hasNewMail()}";
	
	var openFrom="docLib";
	var isEdocLib = '${isEdocLib}';
	if(isShareAndBorrowRoot=="true"){openFrom="lenPotent";}
	if(isEdocLib=="true"){openFrom="edocDocLib";}

	function addComment() {
		validExist();
		var result = v3x.openWindow({
			url : jsURL + "?method=docForumAddView&docResId=${param.docResId}&docLibType=${param.docLibType}&all=${param.all}&docLibId=${param.docLibId}",
			width : "380",
			height : "200",
			resizable : "no"			
		});
	}

	function editDocFromOpen() {
		if(isLocked == 'true') {
			alert("${lockMsg}");
			return;
		}
		
		//if(isOffice2007(docResourceName) && !confirmToOffice2003())
			//return;
		
		validExist();
		var result = "false";
		var msg_status = getLockMsgAndStatus('${param.docResId}', currentUserId);
		if(msg_status && msg_status[0] != LOCK_MSG_NONE && msg_status[1] != LockStatus_None) {
			alert(msg_status[0]);
			return;
		}	
		if('${isUploadFile}'=='true' && '${dr.mimeTypeId}'!='101' && '${dr.mimeTypeId}'!='102' && '${dr.mimeTypeId}' != '120' && '${dr.mimeTypeId}' != '121'){
			result = v3x.openWindow({
				url : jsURL+"?method=editDoc&docResId=${param.docResId}&docLibType=${param.docLibType}&projectId=${param.projectId}"+"&isUploadFileMimeType=true",
				width:"500",
				height:"450"
				});
				if(result=='true'){
					parent.location.href=parent.location;
				} 
				//编辑期间文件被他人删除
				else if(result=='false') {
					parent.window.returnValue =true;
					parent.window.close();
				}
		}else if('${dr.mimeTypeId}'=='23' || '${dr.mimeTypeId}'=='24' || '${dr.mimeTypeId}'=='25' || '${dr.mimeTypeId}'=='26' || '${dr.mimeTypeId}'=='101' || '${dr.mimeTypeId}'=='102' || '${dr.mimeTypeId}' == '120' || '${dr.mimeTypeId}' == '121'){
			result = v3x.openWindow({
				url : jsURL+"?method=editDoc&docResId=${param.docResId}&docLibType=${param.docLibType}&projectId=${param.projectId}",
				workSpace:'yes'
				});
				if(result=='true'){
					parent.location.href=parent.location;
				}else if(result=='false') {//编辑期间文件被他人删除
					parent.window.returnValue =true;
					parent.window.close();
				}
		}else{
			parent.location.href=jsURL+"?method=editDoc&docResId=${param.docResId}&docLibType=${param.docLibType}&projectId=${param.projectId}";
			result = 'true';	
		}
		top.result = result;
	}
	// 验证用户是否具有编辑权限
	function validEdit(){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceEdit", false);
		requestCaller.addParameter(1, "Long", '${param.docResId}');
				
		var existflag = requestCaller.serviceRequest();
		if(existflag == 'true') {
			alert(parent.v3x.getMessage('DocLang.doc_alert_source_editing_doc'));
			document.getElementById("edit").disabled = true;
			return false;
		}else
			return true;
		
	}
	// 验证文档是否存在
	function validExist(){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExist", false);
			requestCaller.addParameter(1, "Long", '${param.docResId}');
		var existflag = requestCaller.serviceRequest();
		
		if(existflag == 'false') {
			alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
			window.dialogArguments.parent.location.reload(true);
			parent.close();
			return ;
		}
	}

	function validBorrowAcl(){
	   if('${isPrivateLib}' == 'true'&&'${param.all}' !='true'){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocAclManager",
			 "getBorrowPotent", false);
		    requestCaller.addParameter(1, "long", '${param.docResId}');
			
		     var lentpotent2 = requestCaller.serviceRequest();
			

		     if(lentpotent2!=null&&lentpotent2.substring(0, 1)!="1"){   
				 if( "${isUploadFile}"=='false')	   
					 document.getElementById("print").disabled = true;
			 	 document.getElementById("download").disabled = true;
			 	 
				 // 与doc.js中initDocViewFun方法中对权限的控制保持一致
			   	 document.getElementById("forward").disabled = true;
				 forwardSubItems.disabled("coll");
				 forwardSubItems.disabled("mail");
			 }
		}
	}

	var downloading = false;
	function docDownLoad(uploadFile,fileId,fileName,theDate){
		var isHistory = "${isHistory}" == "true";
		if(isHistory) {
			validHistoryVersionExist('${param.docVersionId}');
		} else {
			validExist();	
            ajaxRecordOptionLog('${param.docResId}',"downLoadFile");
        }			
		
		if(uploadFile == 'true') {
			emptyIframeMenu.location.href="/seeyon/fileUpload.do?method=download&viewMode=download&fileId="+fileId+"&createDate="+theDate+"&filename="+encodeURIComponent(docResourceName);
		} else {
			try{
				if(downloading == true){
					alert(v3x.getMessage("DocLang.doc_downloading"));
					return;
				}
				
				downloading = true;
				
				document.getElementById("docOpenBodyFrame").contentWindow.startProc(v3x.getMessage("DocLang.doc_alert_compress_progesss"));
					
				// 压缩
				var methodName = isHistory ? "docHistoryDownloadCompress" : "docDownloadCompress";
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", methodName, true);
				requestCaller.addParameter(1, "long", fileId);
				
				this.invoke = function(ds) {
					document.getElementById("docOpenBodyFrame").contentWindow.endProc();
					empty.location.href = "/seeyon/doc.do?method=docDownloadNew&id="+fileId;
					downloading = false;
				}
				
				requestCaller.serviceRequest();
			}catch(e){
				downloading = false;
			}
		}
	}
	
	function docOpenDownload(existflag, fileId){
			if('true' == existflag){
				parent.docOpenBodyFrame.endProc();
				empty.location.href = v3x.baseURL+"/doc.do?method=docDownloadNew&id="+fileId;
			}else{
				parent.docOpenBodyFrame.endProc();
				alert(v3x.getMessage("DocLang.doc_alert_download_failure"));
			}
	}
	
	function printDocLog() {
	  if("${isHistory}" != "true") {
	  	ajaxRecordOptionLog('${param.docResId}', "docPrint") ;
	  }
	  printDoc() ;
	}
	
	// 下载页面的属性对象 label-标签（包含冒号） value-值
	// 两个值都需要做转义: (") 转为 (\")
	function DownloadProperties(label, value) {
		this.label = label;
		this.value = value;
	}
	
	// 组装得到下载页面的html源码
	// title-标题  propArray-属性对象数组 body-正文内容
	function getHtml(title, propArray, body) {
		var inner = "<html><head><title>";
		inner += title;
		inner += "</title></head><body><div id=\"propDiv\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"80%\" height=\"5%\" align=\"center\">";
		inner += "<tr><td height=\"10\" style=\"repeat-x;background-color: f6f6f6;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" align=\"center\">";
		for(var i = 0; i < propArray.length; i++) {
			inner += "<tr><td width=\"90\" height=\"28\" nowrap style=\"text-align: right;	padding-right: 5px;	font-size: 12px;height: 24px; padding-top: 10px;\">";
			inner += propArray[i].label;
			inner += "</td>	<td style=\"padding-top: 10px; font-size: 12px;\">";
			inner += propArray[i].value;
			inner += "</td></tr>";
		}
		inner += "</table></td></tr><tr><td height=\"5\" style=\" repeat-x;	background-color: #f6f6f6;\"></td></tr></table></div>";
		inner += "<div id=\"bodyDiv\"><table width=\"100%\" border=\"0\" height=\"10%\" cellspacing=\"0\" cellpadding=\"0\" style=\"\"><tr>";
    	inner += "<td style=\" repeat-y;	width: 20px;\"><img src=\"\" height=\"1\" width=\"20px\"></td> <td align=\"center\"><div style=\"height: 100%;	border: solid 1px #999999; width: 561.5;\" align=\"left\" id=\"\">";
    	inner += body;
    	inner += "</div></td> <td style=\" repeat-y;width: 20px;\"><img src=\"\" height=\"1\" width=\"20px\"></td></tr></table>";
    	inner += "</body></html>";
    	
    	return inner;
	}
	
	var len = 0;
	var browserFlag = false;
	if(navigator.userAgent.indexOf("MSIE")>0){
		browserFlag = true;
	}
	<c:set value="${v3x:getSysFlagByName('sys_isGovVer') ? '.rep' : ''}" var="govLabel" />
	var menu = new RightMenu("${pageContext.request.contextPath}");
	menu.AddItem("favorite","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.favorite.label'/>","","rbpm","","favorite", browserFlag);
	menu.AddItem("deptDoc","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.deptDoc.label'/>","","rbpm","","deptDoc", browserFlag);
	menu.AddItem("publish","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.space.label'/>","","rbpm","","publish", browserFlag);
	menu.AddItem("group","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.group${govLabel}'/>","","rbpm","","group",browserFlag);
	menu.AddItem("learning","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.learning.label'/>","","rbpm","","learning", browserFlag);
	menu.AddItem("deptLearn","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.deptLearn.label'/>","","rbpm","","deptLearn", browserFlag);
	menu.AddItem("accountLearn","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.accountLearn.label'/>","","rbpm","","accountLearn", browserFlag);
	menu.AddItem("groupLearn","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.group.learning'/>","","rbpm","","groupLearn", browserFlag);
	menu.AddItem("link","<fmt:message key='doc.menu.sendto.label'/><fmt:message key='doc.menu.sendto.other.label'/>","","rbpm","","link", browserFlag);
	len += 9;
	<c:if test="${param.openFrom ne 'glwd'}">
		menu.AddItem("separator","","","rbpm",null);
		menu.AddItem("sendToCollFromOpen","<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />","","rbpm","","",browserFlag);
		menu.AddItem("sendToMailFromOpen","<fmt:message key='common.toolbar.transmit.mail.label' bundle='${v3xCommonI18N}' />","","rbpm","","",browserFlag);
		len += 3;
	</c:if>
	if("${dr.versionEnabled}" == "true") {
		menu.AddItem("separator","","","rbpm",null);
		menu.AddItem("docHistory","<fmt:message key='doc.menu.history.label'/>","","rbpm","","docHistory",browserFlag);
		len += 2;
	}
	menu.AddItem("separator","","","rbpm",null);
	<c:set value="${detailURL}?method=docPropertyIframe&isP=true&isB=false&isM=false&isC=false&docLibType=${param.docLibType}&docLibId=${param.docLibId}&docResId=${param.docResId}&frType=${param.frType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&parentCommentEnabled=${param.parentCommentEnabled}&parentRecommendEnable=${param.parentRecommendEnable}&flag=${param.flag}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}" var="propUrl" />
	menu.AddItem("property","<fmt:message key='doc.menu.properties.label'/>","","rbpm","${propUrl}","properties",browserFlag);
	len += 2;
	document.writeln(menu.GetMenu());

	function viewHistoryDocProperties() {
		var movevalue = v3x.openWindow({
			url : "${propUrl}&versionFlag=HistoryVersion&docVersionId=${param.docVersionId}&isFolder=false",
			width : "500",
			height : "500",
			resizable : "false"
		});
	}
	
	if('${isAdministrator}' == 'false'){
		docDisable("I_publish");	
		docDisable("I_accountLearn");
	}	
	if('${isGroupAdmin}' == 'false'){
		docDisable("I_group");	
		docDisable("I_groupLearn");
	}
	if('${depAdminSize}' == '0'){
		docDisable("I_deptDoc");
		docDisable("I_deptLearn");
	}
	if('${isPrivateLib}' == 'true' || isShareAndBorrowRoot == 'true'){
		docNoneDisplay('I_deptDoc');
		docNoneDisplay('I_publish');
		docNoneDisplay('I_deptLearn');
		docNoneDisplay('I_accountLearn');
		len -= 4;
	}
	if('${isGroupLib}' == 'false' || '${isPrivateLib}' == 'true' || isShareAndBorrowRoot == 'true'){
		docNoneDisplay('I_group');
		docNoneDisplay('I_groupLearn');
		len -= 2;
	}
	if(isShareAndBorrowRoot == 'true') {
		docNoneDisplay('I_favorite');
		docNoneDisplay('I_learning');
		docNoneDisplay('I_link');
		len -= 3;
	}
	if (all == "false" && edit == "false" && readonly == "false") {
		if(add == 'false' || currentUserId != '${dr.createUserId}') {
			docDisable("I_sendToCollFromOpen");
			docDisable("I_sendToMailFromOpen");
		}
		<%-- 借阅：只读权限才能查看历史版本；共享：浏览权限即可查看历史版本 --%>
		if((isShareAndBorrowRoot == 'false' && browse == "false" && (add == "false" || currentUserId != '${dr.createUserId}')) || (isShareAndBorrowRoot == 'true' && readonly == "false"))
			docDisable("I_docHistory");
	}else {
		if(canNewColl == "false") {
			docDisable("I_sendToCollFromOpen");
		}
		if(canNewMail == "false") {
			docDisable("I_sendToMailFromOpen");
		}
	}
	
	function openMoreMenu(){
		
		var PopMenu;
		PopMenu = eval("E_rbpm");
		docMenuTable.className = '${param.docResId}';
	
		var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);    
		var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
		var popLeft = document.getElementById("more").getBoundingClientRect().left + 8 + scrollLeft;
		var popTop = document.getElementById("more").getBoundingClientRect().top + 8 + scrollTop;
		var height = (len * 22) - len/2 -2;
		var oPopup;
		if(navigator.userAgent.indexOf("MSIE")>0){
			oPopup = window.createPopup();
			var oPopBody = oPopup.document.body;
			oPopBody.style.border = "1px solid #C5C5C5";
			oPopBody.innerHTML = PopMenu.innerHTML;
			oPopup.show(popLeft, popTop, 140, height, document.body);
		} else {
			HideAll("rbpm", 0);
			PopMenu.style.display = "block";
			if(popLeft + PopMenu.offsetWidth > document.body.clientWidth){
				popLeft -= PopMenu.offsetWidth;
			}
			if(popTop + PopMenu.offsetHeight > document.body.clientHeight){
				popTop -= PopMenu.offsetHeight;
			}
			PopMenu.style.left = popLeft < 0 ? 0 : popLeft;
			PopMenu.style.top = popTop < 0 ? 0 : popTop;
			PopMenu.style.width = "140px";
			document.getElementById("docOpenBodyFrame").contentWindow.document.onmouseup = OnClick;
			parent.document.getElementById("docOpenLabelFrame").contentWindow.document.onmouseup = OnClick;
		}
	}
	//查看源文档 用于office文件
	function popupContentWin(){
		document.getElementById("docOpenBodyFrame").contentWindow.fullSize();
	}
//-->
</script>
<v3x:selectPeople id="perLearnPop" panels="Account,Department,Member,Team,Post,Level,Outworker"
	selectType="Team,Post,Level,Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	jsFunction="validExist(),sendToLearn(elements, 'open')" minSize="1" />
<script type="text/javascript">
if('${isGroupLib}' != 'true')
	onlyLoginAccount_perLearnPop = true;
    showOriginalElement_perLearn = false;
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center" style="table-layout: fixed;">
	<input type="hidden" name="currContentNum" id="currContentNum" value="0">
	<tr>
		<td height="55">
		<div id="docPrintTitle" style="display: none; width: 0px; height: 0px;">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="50" align="center">
				<tr>
					<td height="10" class="detail-summary">
						<table border="0" cellpadding="0" cellspacing="0" width="100%" class="sort ellipsis" align="center">
							<tr>
								<td id="nameLabelTD" width="90" height="28" nowrap class="bg-gray font-size-12 detail-subject">
									<fmt:message key='doc.jsp.open.body.name' />:
								</td>
								<td id="nameValueTD" title="${v3x:toHTML(dr.frName)}" class="detail-subject font-size-12 breakWord">
									<c:out value="${dr.frName}" escapeXml="true" />
								</td>
								<td></td>
							</tr>
							<tr>
								<td id="createrLabelTD" height="22" nowrap class="bg-gray font-size-12">
									<fmt:message key='doc.metadata.def.creater' />:
								</td>
								<td id="createrValueTD" height="22" nowrap class="font-size-12">
									<span class="cursor-hand" onclick="showV3XMemberCard('${dr.createUserId}')">
									${v3x:showMemberName(dr.createUserId)}
									</span>
									(<fmt:formatDate value='${isHistory ? dr.lastUpdate : dr.createTime}' pattern='${datetimePattern}' />)
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>	
		</div>
		<div id="docTitle">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="50" align="center">
			<tr>
				<td height="10" class="detail-summary">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" class="ellipsis"
					align="center">
					<tr>
						<td id="nameLabelTD" width="90" height="28" nowrap
							class="bg-gray font-size-12 detail-subject"><fmt:message
							key='doc.jsp.open.body.name' />:</td>
						<td id="nameValueTD" title="${v3x:toHTML(dr.frName)}" class="detail-subject-bold font-size-12 breakWord">
							<c:out value="${dr.frName}" escapeXml="true" />
						</td>
						<td></td>
					</tr>
					<tr>
						<td id="createrLabelTD" height="22" nowrap class="bg-gray font-size-12 detail-subject">
							<fmt:message key='doc.metadata.def.creater' />:
						</td>
						<td id="createrValueTD" height="22" nowrap class="font-size-12"  valign="bottom"> 
							<span class="click-link cursor-hand" onclick="showV3XMemberCard('${dr.createUserId}')">
							${v3x:showMemberName(dr.createUserId)}
							</span>
							(<fmt:formatDate value='${isHistory ? dr.lastUpdate : dr.createTime}' pattern='${datetimePattern}' />)
						</td>
						<td align="right"><span style="padding-right: 24px"> 
						<c:if test="${('OfficeWord' eq bodyType or 'OfficeExcel' eq bodyType) and v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request) and v3x:isOfficeTran()}">
							<a href="javascript:popupContentWin()">
								<fmt:message key="doc.show.original.document" />
							</a>
						</c:if>
						<c:if test="${isHistory == false && param.openFrom ne 'glwd'}">
							<c:if test="${v3x:getBrowserFlagByRequest('Office', pageContext.request) || 'HTML' eq bodyType}">
							<c:if test="${param.all == 'true' || param.edit == 'true'}">
								<a href="javascript:editDocFromOpen()" class="font-12px" style="padding-left:12px"><fmt:message
									key='doc.menu.edit.label' /></a>
							</c:if>
							</c:if>
							<c:if test="${v3x:getBrowserFlagByRequest('HideMenu', pageContext.request)}">
							<c:if test="${param.all == 'true' || param.edit == 'true' || param.readonly == 'true' || (param.add == 'true' && dr.createUserId == currentUserId)}">
							<a
								href="javascript:docDownLoad('${isUploadFile}','${downloadId}',name,'${createDate}')"
								class="font-12px" style="padding-left:12px"><fmt:message key='doc.menu.download.label' /></a>
							</c:if>
							</c:if>
							<c:if test="${isPrivateLib != 'true'&& param.all=='true'}">
							<a href="javascript:logView('${param.docResId}',false,name)"
								class="font-12px" style="padding-left:16px"><fmt:message key='doc.menu.viewlog.label' /></a>
							</c:if>
							<c:if test="${commentEnabled == 'true' }">
								<a href="javascript:addComment()" class="font-12px" style="padding-left:12px"><fmt:message
									key='doc.menu.forum.label' /></a>
							</c:if>
						</c:if> 
						<c:if test="${isHistory == true && (param.all == 'true' || param.edit == 'true' || param.readonly == 'true')}">
							<c:if test="${v3x:getBrowserFlagByRequest('HideMenu', pageContext.request)}">
							<a href="javascript:docDownLoad('${isUploadFile}','${downloadId}',name,'${createDate}')"
								class="font-12px" style="padding-left:12px"><fmt:message key='doc.menu.download.label' /></a>
							</c:if>
						</c:if> 
						<c:if test="${(!isUploadFile || canPrint4Upload) && (param.all == 'true' || param.edit == 'true' || param.readonly == 'true'  || (param.add == 'true' && dr.createUserId == currentUserId)) && param.openFrom ne 'glwd'}">
							<c:if test="${v3x:getBrowserFlagByRequest('HideMenu', pageContext.request)}">
							<a href="javascript:printDocLog()" class="font-12px" style="padding-left:12px"><fmt:message
								key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
							</c:if>
						</c:if> 
						<c:if test="${isHistory == false}">
							<c:if test="${param.openFrom eq 'glwd'}">
								<a href="javascript:docProperties('${propUrl}', '${param.docResId}', '${dr.isFolder}', '', '${param.all || param.edit}')" class="font-12px" style="padding-left:12px">
									<fmt:message key='doc.menu.properties.label'/>
								</a>
							</c:if>
							<c:if test="${param.openFrom ne 'glwd'}">
								<a onclick="javascript:openMoreMenu()" id="more" class="font-12px" style="padding-left:12px">&gt;&gt;</a> 
							</c:if>
						</c:if>
						<c:if test="${isHistory == true}">
							<a onclick="javascript:viewHistoryDocProperties()" id="more" class="font-12px" style="padding-left:12px"><fmt:message key='doc.menu.properties.label'/></a> 
						</c:if>
						</span></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td height="5" class="detail-summary-separator"></td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td><c:choose>
			<c:when test="${param.versionFlag eq 'HistoryVersion'}">
				<iframe
					src="${detailURL}?method=docOpenBody&versionFlag=${param.versionFlag}&docVersionId=${param.docVersionId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}"
					name="docOpenBodyFrame" id="docOpenBodyFrame" frameborder="0"
					height="100%" width="100%" scrolling="no" marginheight="0"
					marginwidth="0"></iframe>
			</c:when>
			<c:otherwise>
				<iframe
					src="${detailURL}?method=docOpenBody&docResId=${param.docResId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isLink=${param.isLink}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&openFrom=${param.openFrom}&baseObjectId=${param.baseObjectId }&baseApp=${param.baseApp }"
					name="docOpenBodyFrame" id="docOpenBodyFrame" frameborder="0"
					height="100%" width="100%" scrolling="no" marginheight="0"
					marginwidth="0"></iframe>
			</c:otherwise>
		</c:choose></td>
	</tr>
</table>
<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
<form action="" id="mainForm" method="post">
<input id="inner" name="inner" type="hidden" />
<input id="selectedRowId" name="selectedRowId" type="hidden" value="${isHistory ? param.docVersionId : param.docResId}" />
<input type="hidden" name="oname" value=""> 
<input type="hidden" name="is_folder" value="${dr.isFolder}">
<input type="hidden" name="isPersonalLib" value="">
<input type="hidden" name="parentId" value="${param.resId}">
<input type="hidden" name="docLibId" value="${param.docLibId}">
<input type="hidden" name="docLibType" value="${param.docLibType}">
</form>
<iframe id="emptyIframeMenu" name="emptyIframeMenu" frameborder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>