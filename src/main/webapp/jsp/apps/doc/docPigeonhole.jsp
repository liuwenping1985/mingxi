
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.tree.move.pigeonhole'/></title>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js"></script>
<script type="text/javascript">
	function toMove(){
		if (typeof(treeMoveFrame.moveGo) == "undefined"){
			alert(parent.v3x.getMessage('DocLang.doc_tree_move_select_alert'));
			return false;
		}else
			treeMoveFrame.moveGo();
	}
	
	
	function newFOnPigeonhole(){
		
	}
	
	
	
	var winCreateFolder;
	var selectObj;
	var treeMoveObj;
	var focusFlag;
	function createFolderPigeonhole(parentVersionEnabled, parentCommentEnabled) {
		
		//获取到treeMoveFrame元素的windows对象
		treeMoveObj = document.getElementById("treeMoveFrame").contentWindow;
		//拿到当前点击的文档夹的id作为父id
		selectObj = treeMoveObj.root.getSelected();
		
		if(selectObj==null){
			selectObj = treeMoveObj.root.childNodes[0];
			selectObj.focus();
		}
		
		//如果点击的是文档中心的那个node，则不能新建;
<%--		if(selectObj.text == '文档中心' ){--%>
<%--			alert(v3x.getMessage('DocLang.doc_cannot_createfolder_doccenter'));--%>
<%--			return ;--%>
<%--		}else if(selectObj.text == 'Doc Center' ){--%>
<%--			alert(v3x.getMessage('DocLang.doc_cannot_createfolder_doccenter'));--%>
<%--			return ;--%>
<%--		}else if(selectObj.text = '文檔中心'){--%>
<%--			alert(v3x.getMessage('DocLang.doc_cannot_createfolder_doccenter'));--%>
<%--			return ;--%>
<%--		}--%>
			if(selectObj.id == 'webfx-tree-object-4' ){
				alert(v3x.getMessage('DocLang.doc_cannot_createfolder_doccenter'));
				return;
			}
		
		var parentId = null;
		if(selectObj!=null){
			parentId = selectObj.businessId;
		}
		//弹出窗口
		focusFlag = false;
		if (typeof(transParams) != 'undefined') {
			getA8Top().winCreateFolder = v3x.openDialog({
                title:"<fmt:message key='doc.jsp.createf.title' />",
                transParams:{'parentWin':window},
                url: jsURL + "?method=createFOnPigeonhole&parentId=" + parentId ,
                width: 380,
                height: 160,
                isDrag:false
            });
		} else {
			getA8Top().winCreateFolder = v3x.openWindow({
	            id : "createFolder",
	            title : "<fmt:message key='doc.jsp.createf.title' />",
	            url : jsURL + "?method=createFOnPigeonhole&parentId=" + parentId ,
	            width : 380,
	            height : 180,
	            type : 'html',
	            resizable :'no'
	        });
			if(focusFlag){
	            selectObj.getFirst().focus();
	        }
		}
		
 		
	}
	
	function collBaclFun () {
		getA8Top().winCreateFolder.close();
		if(focusFlag){
            selectObj.getFirst().focus();
        }
	}
	
	function cencol () {
		if (typeof(transParams) != 'undefined') {
			transParams.parentWin.pigeonholeChromeCollBack("cancel");
		} else {
			window.close();
		}
	}
	
	function search(){
		var frName = document.getElementById("frName").value;
		if(frName.trim() == "" || frName == "<fmt:message key='doc.jsp.search.label'/>"){
			document.getElementById("treeMoveFrame").src = "${detailURL}?method=listRoots&isrightworkspace=pigeonhole&appName=${v3x:toHTML(param.appName)}&atts=${v3x:toHTML(param.atts)}&validAcl=${v3x:toHTML(param.validAcl)}&pigeonholeType=${v3x:toHTML(param.pigeonholeType)}&departPigeonhole=${param.departPigeonhole}";
		}else{
			document.getElementById("treeMoveFrame").src = "${detailURL}?method=listRoots&isrightworkspace=pigeonhole&appName=${v3x:toHTML(param.appName)}&atts=${v3x:toHTML(param.atts)}&validAcl=${v3x:toHTML(param.validAcl)}&pigeonholeType=${v3x:toHTML(param.pigeonholeType)}&departPigeonhole=${param.departPigeonhole}&frName="+encodeURIComponent(frName);
		}
		
	}
	
	function on_return(){
		if(window.event.keyCode == 13){
			search();
		}
	}

// 	function focusNode(selectObj){
// 		selectObj.getFirst().focus();
// 	}
</script>

</head>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"></c:set>

<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()">
	<table class="popupTitleRight" class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle">
				<fmt:message key='doc.tree.move.title'/>
			</td>
			<td height="20" class="PopupTitle" align="right">
			    <c:if test="${isNotAdmin}">
					<input id="createFOnPigeonhole" class="button-default_emphasize button-default-disable"  type="button" onclick="createFolderPigeonhole('', '');" name="b3" id="b3" value="<fmt:message key='doc.jsp.createf.title' />" style="margin-right:10px" disabled="disabled">
			    </c:if>
			</td>
			<td height="20" class="PopupTitle" align="right" colspan="2" >
				<input type="text" name="<fmt:message key='doc.search.title.label'/>" id="frName" value="<fmt:message key='doc.jsp.search.label'/>"  onfocus="if(value==defaultValue) {this.value='';this.style.color='#000'}" onblur="if(value==''){value='<fmt:message key='doc.jsp.search.label'/>';this.style.color='#999'}" style="width: 100px;color:#999999" class="validate" onkeydown="on_return()" validate="type:'string',avoidChar:'&&quot;&lt;&gt;'"/>
			</td>
			<td height="20"  align="right">
				<div id="sub" onclick="javascript:search()"  class="div-float condition-search-button"></div>
			</td>
		</tr>

		<tr>
			<td valign="top" class="bg-advance-middel" colspan="5">  
				<iframe src="${detailURL}?method=listRoots&isrightworkspace=pigeonhole&appName=${v3x:toHTML(param.appName)}&atts=${v3x:toHTML(param.atts)}&validAcl=${v3x:toHTML(param.validAcl)}&pigeonholeType=${v3x:toHTML(param.pigeonholeType)}&departPigeonhole=${param.departPigeonhole}" width="100%" height="100%" frameborder="1" name="treeMoveFrame" id="treeMoveFrame" marginheight="0" marginwidth="0" scrolling="yes">
				</iframe>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom" colspan="5">
				<input type="button" name="b1" id="b1" onclick="toMove()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" id="b2" onclick="cencol()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</body>
</html>