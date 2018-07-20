<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
	var all = '${param.all}';
	var edit = '${param.edit}';
	var add = '${param.add}';
	var readonly = '${param.readonly}';
	var browse = '${param.browse}';
	var list = '${param.list}';

	var isPrivateLib = '${isPrivateLib}';
	var isGroupLib = '${isGroupLib}';
	var isAdministrator = '${param.isAdministrator}';
	var isGroupAdmin = '${param.isGroupAdmin}';
	var depAdminSize = '${param.depAdminSize}';
	
	var isShareAndBorrowRoot = '${param.isShareAndBorrowRoot}';
	
	var libName = '${param.libName}';
	
	var isLibOwner = "${param.isLibOwner}";
	
	var folderEnabled = '${folderEnabled}';
	var a6Enabled = '${a6Enabled}';
	var officeEnabled = "${v3x:hasPlugin('officeOcx') && officeEnabled}";
	var uploadEnabled = '${uploadEnabled}';
	
	var isEdocLib = '${isEdocLib}';
	
	var docResId = '${param.resId}';
	var parentPath = '${parent.logicalPath}';
	var parentCommentEnabled = '${parent.commentEnabled}';
	var parentRecommendEnable = '${parent.recommendEnable}';
	var frType = '${param.frType}';
	var docLibId = '${param.docLibId}';
	var docLibType = '${param.docLibType}';
	
	function readyToPersonalLearn(){
		if(hasSelectedData())
			selectPeopleFun_perLearn();
		else
			return;
	}
	
		// 菜单权限
	var canNewColl = "${v3x:hasNewCollaboration()}";
	var canNewMail = "${v3x:hasNewMail()}";
	
	window.onload = function(){
		if('${param.queryFlag}' == 'true'){
			var qm = '${param.queryMethod}';
			var conditionValue = '';
			var textfieldValue = '';
			var textfield1Value = '';
			if('docQueryByName' == qm){
				textfieldValue = "${v3x:escapeJavascript(param.name)}";
				conditionValue = 'subject';
			}else if('docQueryByType' == qm){
				textfieldValue = '${param.type}';	
				conditionValue = 'searchtype';			
			}else if('docQueryByCreater' == qm){
				textfieldValue = '${param.creater}';	
				conditionValue = 'creator';		
			}else if('docQueryByCreateTime' == qm){
				textfieldValue = '${param.beginTime}';
				textfield1Value = '${param.endTime}';	
				conditionValue = 'createDate';			
			}else if('docQueryByKeywords' == qm){
				textfieldValue = "${v3x:escapeJavascript(param.keywords)}";	
				conditionValue = 'keywords';			
			}
			docMenuShowCondition(conditionValue, textfieldValue, textfield1Value);
		}
	}
	
	function docMenuShowCondition(condition, value, value1){
		var conditionObj = document.getElementById("condition");
		selectUtil(conditionObj, condition);
	    showNextCondition(conditionObj);
	    setFlag(condition);
		
		if(condition == 'subject'){
			document.getElementById("name").value = value;
		}else if(condition == 'searchtype'){
			var typeObj = document.getElementById("type");
			selectUtil(typeObj, value);
		}else if(condition == 'keywords'){
			document.getElementById("keywords").value = value;
		}else if(condition == 'createDate'){
			document.getElementById("beginTime").value = value;
			document.getElementById("endTime").value = value1;
		}else if(condition == 'creator'){
			document.getElementById("creater").value = value;
		}
	}

//-->
</script>

	<v3x:selectPeople id="perLearn" panels="Department,Team,Outworker" selectType="Member"
		departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
		jsFunction="sendToLearn(elements)" minSize="1" />
	<script type="text/javascript">
	if('${isGroupLib}' != 'true')
		onlyLoginAccount_perLearn = true;
    showOriginalElement_perLearn = false;
	</script>
	


</head>
<body>
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" class="page2-list-border">
	<tr>
		<td class="webfx-menu-bar  page2-list-header">
<script>
	//知识管理工具栏菜单
	
	//新建二级菜单
	var newSubItems = new WebFXMenu; //定义WebFXMenu对象
	//新建二级菜单项
	newSubItems.add(new WebFXMenuItem("html", "<fmt:message key='doc.menu.new.document.label'/>", "createDoc('<%=Constants.EDITOR_TYPE_HTML%>');", "<c:url value='/apps_res/doc/images/docIcon/html_small.gif'/>", "", ""));
	newSubItems.add(new WebFXMenuItem("word", "<fmt:message key='doc.menu.new.word.label'/>", "createDoc('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>');", "<c:url value='/apps_res/doc/images/docIcon/doc_small.gif'/>", "", ""));
	newSubItems.add(new WebFXMenuItem("excel", "<fmt:message key='doc.menu.new.excel.label'/>", "createDoc('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>');", "<c:url value='/apps_res/doc/images/docIcon/xls_small.gif'/>", "", ""));
	newSubItems.add(new WebFXMenuItem("wpsword", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}'/>", "createDoc('<%=Constants.EDITOR_TYPE_WPS_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
	newSubItems.add(new WebFXMenuItem("wpsexcel", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}'/>", "createDoc('<%=Constants.EDITOR_TYPE_WPS_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>"));
	newSubItems.add(new WebFXMenuItem("folder", "<fmt:message key='doc.menu.new.folder.label'/>", "createFolder();", "<c:url value='/apps_res/doc/images/docIcon/folder_close.gif'/>"));	
	if(isEdocLib == 'true') {
		newSubItems.add(new WebFXMenuItem("edocFolder", "<fmt:message key='doc.menu.new.folder.edoc'/>", "createEdocFolder();", ""));
	}
	
	
	//文档设置下拉二级菜单
	//var grant = new WebFXMenu; //定义WebFXMenu对象
	//添加下拉项

	
	// 发送到二级菜单
	var sendToSubItems = new WebFXMenu;
	sendToSubItems.add(new WebFXMenuItem("favorite", "<fmt:message key='doc.menu.sendto.favorite.label'/>", "addMyFavorite('undefined');", ""));
	sendToSubItems.add(new WebFXMenuItem("deptDoc", "<fmt:message key='doc.menu.sendto.deptDoc.label'/>", "sendToDeptDoc('${param.depAdminSize}')", ""));
	sendToSubItems.add(new WebFXMenuItem("publish", "<fmt:message key='doc.menu.sendto.space.label'/>", "publishDoc('undefined');", ""));	
	sendToSubItems.add(new WebFXMenuItem("group", "<fmt:message key='doc.menu.sendto.group'/>", "sendToGroup('undefined');", ""));	

	sendToSubItems.add(new WebFXMenuItem("learning", "<fmt:message key='doc.menu.sendto.learning.label'/>", "readyToPersonalLearn()", ""));	
	sendToSubItems.add(new WebFXMenuItem("deptLearn", "<fmt:message key='doc.menu.sendto.deptLearn.label'/>", "sendToDeptLearn('${param.depAdminSize}')", ""));
	sendToSubItems.add(new WebFXMenuItem("accountLearn", "<fmt:message key='doc.menu.sendto.accountLearn.label'/>", "sendToAccountLearn()", ""));	
	sendToSubItems.add(new WebFXMenuItem("groupLearn", "<fmt:message key='doc.menu.sendto.group.learning'/>", "sendToGroupLearn()", ""));	

	sendToSubItems.add(new WebFXMenuItem("link", "<fmt:message key='doc.menu.sendto.other.label'/>", "selectDestFolder('undefined','${param.resId}','${param.docLibId}','${param.docLibType}','link');", ""));

	// 转发
	var forwardSubItems = new WebFXMenu;
	forwardSubItems.add(new WebFXMenuItem("col", "<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />", "sendToCollFromMenu()", "/seeyon/apps_res/doc/images/docIcon/DoFlow_big_new_s.gif"));
	forwardSubItems.add(new WebFXMenuItem("mail", "<fmt:message key='common.toolbar.transmit.mail.label' bundle='${v3xCommonI18N}' />", "sendToMailFromMenu()", "/seeyon/apps_res/doc/images/docIcon/exe_small.gif"));
	

	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	myBar.add(new WebFXMenuButton("new", "<fmt:message key='doc.menu.new.label'/>", "", "<c:url value='/common/images/toolbar/new.gif'/>","<fmt:message key='doc.menu.new.label'/>", newSubItems));
	myBar.add(new WebFXMenuButton("upload", "<fmt:message key='doc.menu.upload.label'/>", "fileUpload('upload');", "<c:url value='/apps_res/doc/images/upload.gif'/>","<fmt:message key='doc.menu.upload.label'/>", null));
	myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='doc.menu.sendto.label'/>", "", "<c:url value='/apps_res/doc/images/sendto.gif'/>","<fmt:message key='doc.menu.sendto.label'/>", sendToSubItems));
	myBar.add(new WebFXMenuButton("forward", "<fmt:message key='doc.menu.forward.label'/>", "", "<c:url value='/apps_res/doc/images/sendto.gif'/>","<fmt:message key='doc.menu.forward.label'/>", forwardSubItems));
	myBar.add(new WebFXMenuButton("move", "<fmt:message key='doc.menu.move.label'/>", "selectDestFolder('undefined','${param.resId}','${param.docLibId}','${param.docLibType}','move');", "<c:url value='/common/images/toolbar/move.gif'/>","<fmt:message key='doc.menu.move.label'/>", null));
	myBar.add(new WebFXMenuButton("del", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delF('topOperate','topOperate')", "<c:url value='/common/images/toolbar/delete.gif'/>","<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));
	myBar.add(new WebFXMenuButton("show", "<fmt:message key='doc.menu.hidden.label'/>", "showOrhidden()", "<c:url value='/common/images/toolbar/switch.view.gif'/>","<fmt:message key='doc.menu.hidden.label'/>", null));	
	
	document.write(myBar);
	
	// 控制菜单操作权限
	initFun(all, edit, add, readonly, browse, list, isPrivateLib, folderEnabled, a6Enabled, officeEnabled, uploadEnabled, isGroupLib, isEdocLib, isShareAndBorrowRoot);

	if('${param.queryFlag}' == 'true'){
		docDisable('new');
		docDisable('upload');
	}

</script>
		</td>
		<td class="webfx-menu-bar">
		<form action="" name="searchForm" id="searchForm" method="post"
			onsubmit="return false" style="margin: 0px" target="parent.parent.rightFrame">
			<input type="hidden"  name="flag">
		<div class="div-float-right">
		<div class="div-float" style="margin-top: 2px;"><select name="condition" id="condition"
			onChange="setFlag(this.value);showNextCondition(this)" class="condition">
			<option value=""><fmt:message
				key="doc.search.label" /></option>
			<option value="subject"><fmt:message
				key="doc.metadata.def.name" /></option>
			<option value="searchtype"><fmt:message
				key="doc.metadata.def.type" /></option>
			<option value="keywords"><fmt:message
				key="doc.metadata.def.keywords" /></option>
			<option value="createDate"><fmt:message
				key="doc.metadata.def.createtime" /></option>
			<option value="creator"><fmt:message
				key="doc.metadata.def.creater" /></option>			
		</select></div>
		<!-- div id="searchDiv" class="div-float"><input type="hidden"
			name="searchname" class="textfield"
			onkeydown="javascript:if(event.keyCode==13)return false;" onblur="setFlag('search');" onfocus="clearFlag();">
		</div -->
			
		<div id="subjectDiv" class="div-float hidden"><input type="text"
			name="name" id="name" class="textfield"
			onkeydown="javascript:if(event.keyCode==13)return false;" >
		</div>
		<div id="searchtypeDiv" class="div-float hidden">
		<select name="type" id="type" >
		<option value="notype"><fmt:message
				key="doc.search.category.default" /></option>
		<c:forEach items="${types}" var="t">
			<option value="${t.id}" title="${v3x:_(pageContext, t.name)}">${v3x:getLimitLengthString(v3x:_(pageContext, t.name), 10,'...')}</option>
		</c:forEach>
						
		</select>
		</div>
			
		<div id="creatorDiv" class="div-float hidden"><input
			type="text" id="creater"
			deaultvalue=""
			value=""
			inputName="<fmt:message key='doc.search.creator.label' />" name="creater"
			size="20" ></div>
		<div id="createDateDiv" class="div-float hidden">
		
			<input type="text" name="beginTime" id="beginTime" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
			
			<input type="text" name="endTime" id="endTime" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly >
			  	
		</div>
		
		<div id="keywordsDiv" class="div-float hidden"><input type="text"
			name="keywords" class="textfield" id="keywords"
			onkeydown="javascript:if(event.keyCode==13)return false;" >
		</div>
			
		<div onclick="docDoSearch('${detailURL}', '${param.flag}')" class="condition-search-button"></div>
		</div>
		</form>
		
		</td>
	</tr>
	
</table>
<form action="" name="theForm" id="theForm" method="post" style='display: none'>
<v3x:fileUpload applicationCategory="3" />
</form>
<iframe name="delIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>