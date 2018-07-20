<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title><fmt:message key="bbs.query.label" /></title>
<script type="text/javascript">
function ok(){
	// dosomething()
	window.close();
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0"
	cellpadding="0" align="center">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="bbs.query.label" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" colspan="2">
		<table width="100%">
			<tr>
				<td align="right" width="20%"><fmt:message key="bbs.subject.key.label"/>:&nbsp;&nbsp;</td>
				<td width="80%"><input type="text" name="articleWord" value=""   class="input-50per">
				</td>
			</tr>

			<tr>
				<td align="right"><fmt:message key="bbs.content.key.label"/>:&nbsp;&nbsp;</td>
				<td><input type="text" name="contentWord" value=""  class="input-50per">&nbsp;&nbsp;
				<label for="a"><input type="radio" name="" value="0" id="a" checked="checked"><fmt:message key="bbs.all.post"/></label>

				<label for="b"><input type="radio" name="" value="1" id="b"><fmt:message key="bbs.post.label"/></label>

				<label for="c"><input type="radio" name="" value="2" id="c"><fmt:message key="bbs.replyPost.label"/></label>
				</td>
			</tr>

			<tr>
				<td align="right">
					<fmt:message key="common.issuer.label" bundle="${v3xCommonI18N}" /><fmt:message key="bbs.department.label"/>:&nbsp;&nbsp;
				</td>
				<td>
					<select name="issueDepartment"  class="condition">
						<option selected="selected">--<fmt:message key="bbs.select.label"/><fmt:message key="bbs.department.label"/>--</option>
						<c:forEach var="board" items="${boardList}">
							<option value="${board.id}">{board.name}</option>
						</c:forEach>
					</select>	
				</td>
			</tr>

			<tr>
				<td align="right"><fmt:message key="common.issuer.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;</td>
				<td><input type="text" name="issueName" value=""  class="input-50per">
				</td>
			</tr>

			<tr>
				<td align="right"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;</td>
				<td><input type="text" name="issueTime1"
					class="input-date"
					onclick="whenstart('${pageContext.request.contextPath}',this,190,442);"
					readonly> - <input type="text" name="issueTime2"
					class="input-date"
					onclick="whenstart('${pageContext.request.contextPath}',this,275,442);"
					readonly></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr>
		<td height="42" align="right" class="bg-advance-bottom" colspan="2">
		<input type="button" onclick="ok()"
			value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2">&nbsp; <input type="button"
			onclick="window.close()"
			value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2"></td>
	</tr>
</table>
</body>
</html>
