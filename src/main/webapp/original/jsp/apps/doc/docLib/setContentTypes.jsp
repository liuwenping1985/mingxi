<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doclib.jsp.editcontenttype'/></title>
</head>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/doc/js/docManager.js${v3x:resSuffix()}'/>"></script>
<body scroll="no">
<form name="mainForm" id="mainForm" method="post">
<c:set value="${definition.id}" var="define"/>
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle"><fmt:message key='doclib.jsp.editcontenttype'/></td>
		</tr>
		<tr>
			<td align="center" valign="top" class="bg-advance-middel">
				<table width="90%" border="0" cellspacing="0" cellpadding="0">
					<tr height="30"><td colspan="4"></td></tr>
					<tr>
						<td><fmt:message key='doclib.jsp.contenttype.all.label'/></td>
						<td>&nbsp;</td>
						<td><fmt:message key='doclib.jsp.contenttype.selected.label'/></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<select multiple="multiple" size="12" name="checkout" ondblclick="addNewItem();" id="checkout" style="width:170px;">
							<c:forEach items="${docTypes}" var="docType">
								<option value="${docType.id}">${v3x:_(pageContext, v3x:toHTML(docType.name))}</option>
							</c:forEach>
							</select>	
						</td>
						<td valign="middle" align="center" style="width:50px;">
							<img src="<c:url value="/common/images/arrow_a.gif"/>" alt='<fmt:message key="common.button.add.label" bundle="${v3xCommonI18N}"/>' width="15" height="12" class="cursor-hand" onClick="addNewItem();"><br><br>
							<img src="<c:url value="/common/images/arrow_del.gif"/>" alt='<fmt:message key="common.button.delete.label" bundle="${v3xCommonI18N}"/>' width="15" height="12" class="cursor-hand" onClick="removeItem();">
						</td>
						<td>
							<select multiple="multiple" size="12" name="checkin" ondblclick="removeItem('${define}')" id="checkin" style="width:170px">
							<c:forEach items="${checked}" var="_docType">
								<option value="${_docType.id }"  class="test">${v3x:_(pageContext, v3x:toHTML(_docType.name))}</option>
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
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" onclick="updateContentTypes();" name="b1" id="b1" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" id="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">
			</td>
		</tr>
	</table>
	<div id="columnIds"></div>
	<div id="docTypeName"></div>
	<input type="hidden" name="docLibId" id="docLibId" value="${param.docLibId}"/>
</form>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</body>
</html>