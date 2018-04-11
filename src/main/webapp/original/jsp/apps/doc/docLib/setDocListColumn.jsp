<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doclib.jsp.editcolumns'/></title>
<script type="text/javascript">
//支持ipad
function OK(){
	modifyDocListColumn("${isEdoc}");
}
</script>
</head>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/doc/js/docManager.js${v3x:resSuffix()}' />"></script>
<body scroll="no">
<c:set var="default1" value="${v3x:_(pageContext, defalutValue)}"/>
<form name="mainForm" id="mainForm" method="post" target="empty">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center" valign="top" class="bg-advance-middel">
				<table width="90%" border="0" cellspacing="0" cellpadding="0">
					<tr height="10"><td colspan="4"></td></tr>
					<tr height="30">
                      <td colspan="4">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
    						<td width="60"><fmt:message key='doclib.jsp.column.all.label'/></td>
    						<td width="20"><input type="text" id="searchTxt" onkeyup="fnQuery();" style="width: 90px;"></td><td width="88"><div class="div-float condition-search-button" onclick="fnQuery();"/></td>
    						<td><fmt:message key='doclib.jsp.column.selected.label'/></td>
                        </table>
                      </td>
					</tr>
					<tr>
						<td>
							<select multiple="multiple" size="12" name="checkout" ondblclick="addNewItem();" id="checkout" style="width:170px;">
  							   <c:forEach items="${metadataDefs}" var="metadataDef">
  								 <option value="${metadataDef.id}" class="test">${v3x:toHTML(metadataDef.showName)}</option>
  							   </c:forEach>
							</select>	
						</td>
						<td valign="middle" align="center" style="width:50px;">
							<img src="<c:url value="/common/images/arrow_a.gif"/>" alt='<fmt:message key="common.button.add.label" bundle="${v3xCommonI18N}"/>' width="15" height="12" class="cursor-hand" onClick="addNewItem();"><br><br>
							<img src="<c:url value="/common/images/arrow_del.gif"/>" alt='<fmt:message key="common.button.delete.label" bundle="${v3xCommonI18N}"/>' width="15" height="12" class="cursor-hand" onClick="removeItem('${default1}');">
						</td>
						<td>
							<select multiple="multiple" size="12" name="checkin" ondblclick="removeItem('${default1}')"  id="checkin" style="width:170px;">
							<c:forEach items="${columns}" var="column">
								<option value="${column.id }">${v3x:_(pageContext, v3x:toHTML(column.showName))}</option>
							</c:forEach>
							</select>	
						</td>
						<td valign="middle">
							<img src="<c:url value="/common/images/arrow_u.gif"/>" alt='<fmt:message key="common.button.up.label" bundle="${v3xCommonI18N}"/>' width="12" height="15" class="cursor-hand" onClick="doChoiceUp();"><br><br>
							<img src="<c:url value="/common/images/arrow_d.gif"/>" alt='<fmt:message key="common.button.down.label" bundle="${v3xCommonI18N}"/>' width="12" height="15" class="cursor-hand" onClick="doChoiceDown();">							
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" onclick="modifyDocListColumn('${isEdoc}');" name="b1" id="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" id="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		</c:if>
	</table>
	<div id="columnIds"></div>
	<div id="columnName"></div>
	<input type="hidden" name="docLibId" id="docLibId" value="${param.docLibId}"/>
</form>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</body>
</html>