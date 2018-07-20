<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<html style="height:100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="docHeader.jsp"%>
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var docPigeonhole = false;
function moveGo() {
	var b1;
	var b2;
	var isrightworkspace = "${v3x:escapeJavascript(param.isrightworkspace)}";
	var flag = "false";
	var parentIds;
	
	var obj  = window.parent.parent;
	var hiddenstr = "";	
	var srcLibId = "";
	var srcLibType = "";
	var destResId = "";
	var destLogicalPath = "";
	var destLibId = "";
	var destLibType = "";	
	
	var all;
	var edit;
	var add;	
	var commentEnabled;
	//判断当前文件夹是否有新建文件夹权限
	//if(!docPigeonhole){
	//	alert('当前文件夹没有新建文件夹权限!');
	//	return;
	//}
	
	//调用v3x.openWindow
	if(v3x.getBrowserFlag('openWindow')){
		b1 = parent.window.document.getElementById("b1");
		b2 = parent.window.document.getElementById("b2"); 
	} else {//v3x.openDialog
		b1 = top.document.getElementById('b1');
		b2 = top.document.getElementById('b2');
	}
	
	btnEnableOrDisAble(b1,b2,true);
	
	if(self.getA8Top().dialogArguments != null){
		obj = self.getA8Top().dialogArguments;
	}
	
	var selected = root.getSelected(); 
	if(selected && typeof selected.src == "string") {	
		var url = selected.src;
		
		all = getMultyWindowId("all",url);
		edit = getMultyWindowId("edit",url);
		add = getMultyWindowId("add",url);
		
		// 对选中的文档夹的写入权限判断
		if ('${param.validAcl}' != 'false') {
		    if (all == 'false' && edit == 'false' && add == 'false') {
		        alert(parent.v3x.getMessage('DocLang.doc_move_dest_no_acl_failure_alert'));
		        btnEnableOrDisAble(b1, b2, false);
		        return;
		    }
		} else {
		    //表单-应用绑定-预归档，限制项目文档根目录
		    if (isrightworkspace == "pigeonhole" && selected.businessId == "900") {
		        alert(parent.v3x.getMessage('DocLang.doc_move_dest_no_acl_failure_alert'));
		        btnEnableOrDisAble(b1, b2, false);
		        return;
		    }
		}
	  var sbdf = getMultyWindowId("resId",url);
	  
		destResId = getMultyWindowId("resId",url); // 目标文档夹id
		destLibId = getMultyWindowId("docLibId",url); // 目标文档库id	
		destLibType = getMultyWindowId("docLibType",url); 	
		destLogicalPath = getMultyWindowId("logicalPath",url);
		commentEnabled = getMultyWindowId("commentEnabled",url);
	}else {
		alert(v3x.getMessage('DocLang.doc_tree_move_select_alert'));
		btnEnableOrDisAble(b1,b2,false);
		return false;
	}	
	
	// 目标文档夹有效性检查
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExist", false);
	requestCaller.addParameter(1, "Long", destResId);
	var existflag = requestCaller.serviceRequest();
	if(existflag == 'false') {
		alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));
		window.location.href = window.location.href;
		btnEnableOrDisAble(b1,b2,false);
		return ;
	}
		
	if(isrightworkspace != "pigeonhole") {
		flag = "${v3x:escapeJavascript(param.flag)}";
		if (flag == "false") {
  			parentIds = obj.document.getElementsByName('id');
  			if(parentIds.length === 0) {
  				parentIds=getA8Top().frames["main"].frames["rightFrame"].document.getElementsByName('id');
  			}
		}
	}

	if(isrightworkspace == "link") { // 映射操作
		var lpArray = destLogicalPath.split(".");
		if (flag == "true") {
			hiddenstr = "<input type=hidden name=id value='${param.id}'>";
			// 判断是否映射到自身
			for(var j = 0; j < lpArray.length; j++) {
				if(lpArray[j] == '${param.id}') {
					alert(parent.parent.v3x.getMessage('DocLang.doc_tree_link_dest_is_self_alert',selected.showName));
					btnEnableOrDisAble(b1,b2,false);
					return; 
				}			
			}
		}else {
			if(!parentIds) {
				btnEnableOrDisAble(b1,b2,false);
				return ;
			}
			
			for(var i = 0; i < parentIds.length; i++) {				
				var parentId = parentIds[i];
				if(parentId.checked) {
					// 判断是否映射到自身
					for(var j = 0; j < lpArray.length; j++) {
						if(lpArray[j] == parentId.value) {
							alert(parent.parent.v3x.getMessage('DocLang.doc_tree_link_dest_is_self_alert',selected.showName));
							btnEnableOrDisAble(b1,b2,false);
							return; 
						}
					}
					hiddenstr += "<input type=hidden name=id value=" + parentId.value + ">";
				}
			}
		}
		document.getElementById('hiddenid').innerHTML = hiddenstr;				
		document.getElementById('mainForm').target = "moveIframe";
		document.getElementById('mainForm').action = "${detailURL}?method=createLink&destLibId=" + destLibId 
			+ "&destResId=" + destResId + "&destLibType=" + destLibType + "&destName=" + encodeURIComponent(encodeURIComponent(selected.showName));
		fnSubmitByjQNew('mainForm');
    	return true;
	}else if(isrightworkspace == "pigeonhole") { // 归档操作
		var opener = null;
	    if (parent.window.transParams) {
	         opener = parent.window.transParams.parentWin;
	    } else {
	    	 opener = window.parent.dialogArguments || window.parent.opener;
	    }
	    if (b1 == null || b2 == null) {
	    	b1 = parent.window.document.getElementById("b1");
	        b2 = parent.window.document.getElementById("b2");
	    }
		if(opener.newIdes==null) {
			if (parent.window.transParams) { 
				parent.window.transParams.parentWin.pigeonholeChromeCollBack(destResId + "," + selected.showName.escapeJavascript());
			} else {
				parent.window.returnValue = destResId + "," + selected.showName.escapeJavascript();
	            parent.close();
			}
		}else{	
			var appName = '${v3x:escapeJavascript(param.appName)}';
			var sourceIdString = opener.newIdes;//归档到文档中的sourceId，也就是v3x_affair表中的主键id
			hiddenstr = "<input type=hidden id='ids' name='ids' value='"+sourceIdString+"'>";	
			var exist = false;
			if(sourceIdString && sourceIdString.trim() != '') {
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "judgeSamePigeonhole", false);
				requestCaller.addParameter(1, "Long", destResId);
				var docAppName = '<%=ApplicationCategoryEnum.collaboration.getKey()%>';
				if(appName == '32') {
					docAppName = appName;//信息报送
				}else if(appName == '4'){
					docAppName = appName;//公文
				}
				requestCaller.addParameter(2, "Integer", docAppName);
				var selectedBoxes = opener.document.getElementsByName("id");
				var colIds = "";
				for(var i=0; i<selectedBoxes.length; i++) {
					if(selectedBoxes[i].checked == true) {
						colIds += ',' + selectedBoxes[i].value;
					}
				}
				if(appName == '32') {
					colIds = '';
					selectedBoxes = opener.grid.grid.getSelectRows();
					for(var i=0; i<selectedBoxes.length; i++) {
						colIds += selectedBoxes[i].id;
						colIds += ',';
					}
					if(colIds != '') {
						colIds = colIds.substring(0, colIds.length-1);
					}
				}
				
				if(!colIds){//公文待办页面不是列表形式
					colIds = opener.pigeonholeObjectId;//调用页面定义特殊的ctp_affair的objectId
				}
				
				requestCaller.addParameter(3, "String", colIds);
				
				var result = requestCaller.serviceRequest();
				if(result  == 'true') {
					exist = true;
				}
			}
			
			document.getElementById('hiddenid').innerHTML = hiddenstr;
			//当存在已经归档的时候
			if(exist){
				if(appName == '4'){//公文直接提示重复
					btnEnableOrDisAble(b1,b2,false);
					alert(v3x.getMessage('DocLang.doc_move_dupli_name_failure_gov_alert'));
					return;
				}else{
					var ret = confirm(v3x.getMessage("DocLang.doc_upload_dupli_col_confirm"));
				    if(ret){
					    var theForm = document.getElementById("mainForm");
					    theForm.target = "moveIframe";				
					    theForm.action = "${detailURL}?method=pigeonhole&pigeonhole=${param.pigeonholeType}&destLibId=" + destLibId 
					    + "&destResId=" + destResId + "&appName=${v3x:escapeJavascript(param.appName)}&atts=${v3x:escapeJavascript(param.atts)}" 
					    + "&destLibType=" + destLibType + "&destName=" + encodeURI(encodeURI(selected.showName));
					    theForm.submit();
				    } else {
					    btnEnableOrDisAble(b1,b2,false);
					    return;
				    }
				}				
			}else{//正常归档
				var theForm = document.getElementById("mainForm");
				theForm.target = "moveIframe";				
				theForm.action = "${detailURL}?method=pigeonhole&pigeonhole=${param.pigeonholeType}&destLibId=" + destLibId 
					+ "&destResId=" + destResId + "&appName=${v3x:escapeJavascript(param.appName)}&atts=${v3x:escapeJavascript(param.atts)}" 
					+ "&destLibType=" + destLibType + "&destName=" + encodeURI(encodeURI(selected.showName))
					+ "&departPigeonhole=${v3x:escapeJavascript(param.departPigeonhole)}";
				fnSubmitByjQNew('mainForm');
			}	
		}						    
	}else if (isrightworkspace == "move") { // 移动操作 		
		var lpArray = destLogicalPath.split(".");
		var chooseIds  = new Array();
		if (flag == "true") {
			// 从列表过来
			hiddenstr = "<input type=hidden name=id value='${param.id}'>";
			for(var j = 0; j < lpArray.length; j++) {
				if(lpArray[j] == '${param.id}') {
					alert(parent.parent.v3x.getMessage('DocLang.doc_tree_move_dest_is_self_alert',selected.showName));
					btnEnableOrDisAble(b1,b2,false);
					return; 
				}			
			}				
		}else {// 从菜单过来		
			if(!parentIds) {
				if(v3x.getBrowserFlag('openWindow') == true){
					btnEnableOrDisAble(b1,b2,false);
				}
				return ;
			}
			
			for(var i = 0; i < parentIds.length; i++) {				
				var parentId = parentIds[i];
				if(parentId.checked) {
					for(var j = 0; j < lpArray.length; j++) {
						if(lpArray[j] == parentId.value) {
							alert(parent.parent.v3x.getMessage('DocLang.doc_tree_move_dest_is_self_alert',selected.showName));
							btnEnableOrDisAble(b1,b2,false);
							return; 
						}
					}
					chooseIds.push(parentId.value);
					hiddenstr += "<input type=hidden name=id value=" + parentId.value + ">";
				}
			}		
		}
		//检查目标文件夹是否已经存在该affair 的公文归档
		var requestCaller2 = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExistInFile", false);
		requestCaller2.addParameter(1, "Long", destResId);
		requestCaller2.addParameter(2, "String", chooseIds.join(','));
		var existflag = requestCaller2.serviceRequest();
		if(existflag != "-1"){
			alert(existflag+" 在目标文件夹已经存在");
			 btnEnableOrDisAble(b1,b2,false);
			 return;
		}
		document.getElementById('hiddenid').innerHTML = hiddenstr;
		srcLibId = "${v3x:escapeJavascript(param.docLibId)}"; // 源文档库id
		srcLibType = "${v3x:escapeJavascript(param.docLibType)}";
		document.getElementById('mainForm').target = "moveIframe";
		document.getElementById('mainForm').action = "${detailURL}?method=move&srcLibId=" + srcLibId 
				+ "&destResId="	+ destResId + "&destLibId=" + destLibId
				+ "&srcLibType=" + srcLibType + "&destLibType=" + destLibType
				+ "&commentEnabled=" + commentEnabled + "&destName=" + encodeURIComponent(encodeURIComponent(selected.showName));
		fnSubmitByjQNew('mainForm',destResId);
	}
}

function pigeonholeCollBacks (returnValue) {
	if (parent.window.transParams) { 
		parent.window.transParams.parentWin.pigeonholeChromeCollBack(returnValue);
    } else {
        parent.window.returnValue = returnValue;
        parent.close();
    }
}
/**
 * 处理safier问题
 */
function fnSubmitByjQNew(id,destResId){
	if (fnSubmitByjQ(id)) {
	      if (!v3x.isFirefox) {
	      	if(top.document.getElementById('main') != null){
	      		var frameObj = top.document.getElementById('main').contentWindow.document.getElementById('rightFrame');
		        if (frameObj) {
		        	frameObj.contentWindow.location.reload();
		        }
	      	}
	      	if(typeof(parent.parent.winMove) != "undefined"){
	        	parent.parent.winMove.close();
	      	}else{
	      	  	var windowOpener = parent.opener;
	     		windowOpener.parent.location.reload();
	      		parent.parent.close();
	      	}
	      } else {
	      	  //已开会议归档
	          var frameObj = window.parent.top.opener;
	          if (frameObj) {
	              frameObj.location.reload();
	          }
	          parent.window.close();
	      }
	}
}
/**
 * 利用jQuery重写的submit
 */
function fnSubmitByjQ(id) {
	var theform=$('#'+id);
    if(v3x.isSafari) {
    	//这里肯定会存在问题，不会回调muyunxing
//     	$.ajax({
//             url : document.getElementById(id).action,
//             data: theform.serialize(), 
//             async : false,
//             type : "POST",
//             success: function(data, textStatus){
//             	if (textStatus == 'success') {
//             		return true;
//             	}
//             }
//         });
		document.getElementById(id).submit();
//     	return true;
    } else {
    	document.getElementById(id).submit();
    }
    return false;
}

function btnEnableOrDisAble(b1,b2,enabled){
	if(b1)
		b1.disabled = enabled;
	if(b2)
		b2.disabled = enabled;
}

//两方法重复，为了维护方便，取到，在dilaog的时候会回调此方法；根据v3x.getBrowserFlag('openWindow')为false时调用OK方法
function OK() {
	moveGo();
}

//业务生成器-业务配置
function getSelectedNodes() {
    var node = root.getSelected();
    if (!node || !node.businessId || node.businessId == "900") {
        return null;
    }
    var retr = {};
    retr.id = node.businessId;
    retr.name = node.showName;
    var data = {};
    data.id = node.businessId;
    data.name = node.showName;
    data.sourceType = 6;
    data.sourceValue = node.businessId;
    data.formAppmainId = 0;
    data.sourctTypeName = "<fmt:message key='doc.center.lable'/>";
    retr.data = data;
    return retr;
}

window.onload = function () {
	<c:forEach items="${roots}" var="root" begin="0" end="0">
		validateAcl4New(${root.allAcl},${root.editAcl},${root.addAcl});
	</c:forEach>
}
//-->
</script>
</head>
<body onkeydown="listenerKeyESC()" style="background: #ffffff;height: 100%;">
<div class="scrollList">
<form name='mainForm' id="mainForm" method='post'>
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
		<tr valign="top">
			<td>
				<div id="hiddenid" class="hidden"></div>
<div style="margin-left: 10px; margin-top: 10px; margin-bottom: 10px;">
<script type="text/javascript">
	var frName = "${frName}";
	<c:if test="${empty frName}">
    webFXTreeConfig.openRootIcon = "<c:url value='/apps_res/doc/images/docIcon/root.gif'/>";
    webFXTreeConfig.defaultText = "<fmt:message key='doc.tree.struct.lable'/>";
    var root = new WebFXTree();
    root.target = "moveIframe";
    var rootSize=0;
    <c:forEach items="${roots}" var="root">
    	<c:choose>
    		<c:when test="${root.otherAccountId!=0}" > 
    			<c:set value="(${v3x:toHTML(v3x:getAccount(root.otherAccountId).shortName)})" var="otherAccountShortName" />
    		</c:when>
    		<c:otherwise>
    			<c:set value="" var="otherAccountShortName" />
    		</c:otherwise>
    	</c:choose>
    	
    	var tree_${root.docResource.id} = new WebFXLoadTreeItem("${root.docResource.id}", "${v3x:escapeJavascript(root.frName)}${otherAccountShortName}", null, "validateAcl4New(${root.allAcl},${root.editAcl},${root.addAcl});", null, null, "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${root.openIcon}'/>");
    	tree_${root.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspMove&pigeonholeType=${v3x:escapeJavascript(param.pigeonholeType)}&resId=${root.docResource.id}&frType=${root.docResource.frType}&docLibId=${root.docResource.docLibId}&docLibType=${root.docLibType}&isShareAndBorrowRoot=false&logicalPath=${root.docResource.logicalPath}&all=${root.allAcl}&edit=${root.editAcl}&add=${root.addAcl}&commentEnabled=${root.docResource.commentEnabled}&validAcl=${v3x:escapeJavascript(param.validAcl)}'/>";
    	tree_${root.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>";
    	
    	tree_${root.docResource.id}.target = "moveIframe";
    		
    	root.add(tree_${root.docResource.id});
    	rootSize = rootSize+1;
    </c:forEach>
    if(rootSize <1)
    	parent.document.getElementById('createFOnPigeonhole').disabled="disabled";
    document.write(root);
    </c:if>
	<c:if test="${ not empty frName}">
		if (document.getElementById) {
			webFXTreeConfig.openRootIcon = "<c:url value='/apps_res/doc/images/docIcon/root.gif'/>";
   			webFXTreeConfig.defaultText = "<fmt:message key='doc.tree.struct.lable'/>";
			webFXTreeConfig.usePersistence = false;
			var root = new WebFXTree();
			root.setBehavior('classic');
			<c:forEach items="${roots}" var="rootNew">
				<c:choose>
					<c:when test="${rootNew.docResource.parentFrId==0}">
						var tree_${rootNew.docResource.id} = new WebFXTreeItem("${rootNew.docResource.id}", "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}",  "validateAcl4New(${rootNew.allAcl},${rootNew.editAcl},${rootNew.addAcl});", null, root, "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${rootNew.openIcon}'/>");
    			
						tree_${rootNew.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspMove&pigeonholeType=${v3x:escapeJavascript(param.pigeonholeType)}&resId=${rootNew.docResource.id}&frType=${rootNew.docResource.frType}&docLibId=${rootNew.docResource.docLibId}&docLibType=${rootNew.docLibType}&isShareAndBorrowRoot=false&logicalPath=${rootNew.docResource.logicalPath}&all=${rootNew.allAcl}&edit=${rootNew.editAcl}&add=${rootNew.addAcl}&commentEnabled=${rootNew.docResource.commentEnabled}&validAcl=${v3x:escapeJavascript(param.validAcl)}'/>";
    				
						tree_${rootNew.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>";
    	
    					tree_${rootNew.docResource.id}.target = "moveIframe";

						tree_${rootNew.docResource.id}.showName = "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}";		
					</c:when>
					<c:otherwise>				
						<c:choose>
							<c:when test="${not empty rootNew.docResource.sourceId }">
								<c:if test="${rootNew.docResource.logicalPath=='900.900'}">

									var tree_${rootNew.docResource.id} = new WebFXTreeItem("${rootNew.docResource.id}", "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}",  "validateAcl4New(${rootNew.allAcl},${rootNew.editAcl},${rootNew.addAcl});", null, tree_${rootNew.docResource.parentFrId}, "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${rootNew.openIcon}'/>");

									tree_${rootNew.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspMove&pigeonholeType=${v3x:escapeJavascript(param.pigeonholeType)}&resId=${rootNew.docResource.id}&frType=${rootNew.docResource.frType}&docLibId=${rootNew.docResource.docLibId}&docLibType=${rootNew.docLibType}&isShareAndBorrowRoot=false&logicalPath=900&all=${rootNew.allAcl}&edit=${rootNew.editAcl}&add=${rootNew.addAcl}&commentEnabled=${rootNew.docResource.commentEnabled}&validAcl=${v3x:escapeJavascript(param.validAcl)}'/>";
    				
									tree_${rootNew.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>";
    	
    							tree_${rootNew.docResource.id}.target = "moveIframe";
	
								tree_${rootNew.docResource.id}.showName = "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}";
								</c:if>
								<c:if test="${rootNew.docResource.frType==38}">
									<c:forEach items="${roots}" var="rootNews">
										<c:if test="${rootNew.docResource.projectTypeId == rootNews.docResource.id}">
											var  tree_${rootNew.docResource.id} =  new WebFXTreeItem("${rootNew.docResource.id}", "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}",  "validateAcl4New(${rootNew.allAcl},${rootNew.editAcl},${rootNew.addAcl});", null, tree_${rootNew.docResource.projectTypeId}, "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${rootNew.openIcon}'/>");

											tree_${rootNew.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspMove&pigeonholeType=${v3x:escapeJavascript(param.pigeonholeType)}&resId=${rootNew.docResource.id}&frType=${rootNew.docResource.frType}&docLibId=${rootNew.docResource.docLibId}&docLibType=${rootNew.docLibType}&isShareAndBorrowRoot=false&logicalPath=${rootNew.docResource.logicalPath}&all=${rootNew.allAcl}&edit=${rootNew.editAcl}&add=${rootNew.addAcl}&commentEnabled=${rootNew.docResource.commentEnabled}&validAcl=${v3x:escapeJavascript(param.validAcl)}'/>";
    				
											tree_${rootNew.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>";
    	
    										tree_${rootNew.docResource.id}.target = "moveIframe";

											tree_${rootNew.docResource.id}.showName = "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}";
										</c:if>

									</c:forEach>
								</c:if>
								<c:if test="${rootNew.docResource.frType==39}">
									var  tree_${rootNew.docResource.id} =  new WebFXTreeItem("${rootNew.docResource.id}", "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}",  "validateAcl4New(${rootNew.allAcl},${rootNew.editAcl},${rootNew.addAcl});", null, tree_${rootNew.docResource.parentFrId}, "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${rootNew.openIcon}'/>");

									tree_${rootNew.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspMove&pigeonholeType=${v3x:escapeJavascript(param.pigeonholeType)}&resId=${rootNew.docResource.id}&frType=${rootNew.docResource.frType}&docLibId=${rootNew.docResource.docLibId}&docLibType=${rootNew.docLibType}&isShareAndBorrowRoot=false&logicalPath=${rootNew.docResource.logicalPath}&all=${rootNew.allAcl}&edit=${rootNew.editAcl}&add=${rootNew.addAcl}&commentEnabled=${rootNew.docResource.commentEnabled}&validAcl=${v3x:escapeJavascript(param.validAcl)}'/>";
    				
									tree_${rootNew.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>";
    	
    								tree_${rootNew.docResource.id}.target = "moveIframe";

									tree_${rootNew.docResource.id}.showName = "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}";
								</c:if>
							</c:when>
						<c:otherwise>
							var  tree_${rootNew.docResource.id} = new WebFXTreeItem("${rootNew.docResource.id}", "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}",  "validateAcl4New(${rootNew.allAcl},${rootNew.editAcl},${rootNew.addAcl});", null, tree_${rootNew.docResource.parentFrId}, "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${rootNew.openIcon}'/>");

							tree_${rootNew.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspMove&pigeonholeType=${v3x:escapeJavascript(param.pigeonholeType)}&resId=${rootNew.docResource.id}&frType=${rootNew.docResource.frType}&docLibId=${rootNew.docResource.docLibId}&docLibType=${rootNew.docLibType}&isShareAndBorrowRoot=false&logicalPath=${rootNew.docResource.logicalPath}&all=${rootNew.allAcl}&edit=${rootNew.editAcl}&add=${rootNew.addAcl}&commentEnabled=${rootNew.docResource.commentEnabled}&validAcl=${v3x:escapeJavascript(param.validAcl)}'/>";
    				
							tree_${rootNew.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${rootNew.closeIcon}'/>";
    	
    						tree_${rootNew.docResource.id}.target = "moveIframe";

							tree_${rootNew.docResource.id}.showName = "${v3x:escapeJavascript(rootNew.frName)}${otherAccountShortName}";
						</c:otherwise>
					</c:choose>
				</c:otherwise>	
			</c:choose>
		</c:forEach>
		parent.document.getElementById('createFOnPigeonhole').disabled="disabled";
		document.write(root);
		}
		root.expandAll();
	</c:if>

    function validateAcl4New(allAcl,editAcl,addAcl){

    	if(frName.trim()!=""){//不为空，把新建按钮置灰---不进行新建文件夹操作
			parent.document.getElementById('createFOnPigeonhole').disabled="disabled";
            parent.$("#createFOnPigeonhole").addClass("button-default-disable");
		}else{
    		if(parent.document.getElementById('createFOnPigeonhole')){
    	    	if (!(parseBool(allAcl) || parseBool(editAcl) || parseBool(addAcl))) {
                	parent.document.getElementById('createFOnPigeonhole').disabled="disabled";
                	parent.$("#createFOnPigeonhole").addClass("button-default-disable");
            	}else {
                	parent.document.getElementById('createFOnPigeonhole').disabled="";
                	parent.$("#createFOnPigeonhole").removeClass("button-default-disable");
            	}
    		}
		}
    }
    
    function parseBool(arg){
        if(typeof(arg)==='undefined'){
            return false;
        }else if(typeof(arg)=='boolean'){
            return arg;
        }else if(typeof(arg)=='string'){
            return arg==='true';
        }else if(typeof(arg)=='number'){
            return arg == 1;
        }
        return false;
    }
</script>
</div>
			</td>
		</tr>		
	</table>
</form>
</div>
<iframe name="moveIframe" frameborder="0"	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"/>
<div id="procDiv1" style="display:none;"></div>
</body>
<script type="text/javascript">
root.getFirst().focus();
</script>
</html>
