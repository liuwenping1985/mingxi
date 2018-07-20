<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.tree.move.title'/></title>
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
</script>
</head>
<body bgColor="#f6f6f6" scroll="no">
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
						<fmt:message key='doc.tree.move.move' />
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
                <c:if test="${param.isrightworkspace == 'move' && (v3x:getSystemProperty('system.ProductId') == '1' || v3x:getSystemProperty('system.ProductId') == '2')}">
                    <font color="white"><fmt:message key='doc.jsp.alert.collect.msg'/></font>
                </c:if>
            </td>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" class="button-default_emphasize" onclick="toMove()" name="b1" id="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" id="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		</c:if>
	</table>
</body>
</html>