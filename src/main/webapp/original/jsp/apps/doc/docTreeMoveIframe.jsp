<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.tree.move.title'/></title>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js"></script>
<script type="text/javascript">
	function toMove(){
		if (typeof(treeMoveFrame.moveGo) == "undefined"){
			alert(parent.v3x.getMessage('DocLang.doc_tree_move_select_alert'));
			return false;
		}else{
			return treeMoveFrame.moveGo();
		}
	}
	
	function OK(){
		return toMove();
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
	            height : 100,
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
</script>
</head>
<body scroll="no" style="background: rgb(250,250,250);">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<c:choose>
		<c:when test="${param.newFlag == 'true'}"></c:when>
		<c:otherwise>
			<tr>
				<td height="20" class="PopupTitle bg_color"><c:choose>
					<c:when test="${param.isrightworkspace == 'link'}">
						<fmt:message key='doc.tree.move.createlink' />
					</c:when>
					<c:otherwise>
						<c:if test="${(param.isrightworkspace == 'move' && (v3x:getSystemProperty('system.ProductId') == '1' || v3x:getSystemProperty('system.ProductId') == '2')) || (param.docLibId==1&&param.parentId==1) }">
                    		<input id="createFOnPigeonhole" class="button-default_emphasize button-default-disable "  type="button" onclick="createFolderPigeonhole('', '');" name="b3" id="b3" value="<fmt:message key='doc.jsp.createf.title' />" style="margin-left:5px;float:left;" disabled="disabled">&nbsp;&nbsp;&nbsp;
                    		<font size="1px;"  color="red"><fmt:message key='doc.jsp.alert.collect.msg'/></font>
                		</c:if>
					</c:otherwise>
				</c:choose></td>
			</tr>
		</c:otherwise>
	</c:choose>
	<tr>
			<td valign="top" colspan="2">
				<iframe src="${detailURL}?method=listRoots&isrightworkspace=${param.isrightworkspace}&flag=${param.flag}&id=${param.id}&docLibId=${param.docLibId}&docLibType=${param.docLibType}" width="100%" height="100%" frameborder="0" name="treeMoveFrame" id="treeMoveFrame" marginheight="0" marginwidth="0" scrolling="yes">
				</iframe>
			</td>
		</tr>
		<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
		<tr>
            <td align="left" style="padding-left:5px;" class="bg-advance-bottom">
            </td>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" class="button-default_emphasize" onclick="toMove();" name="b1" id="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" id="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		</c:if>
	</table>
</body>
</html>