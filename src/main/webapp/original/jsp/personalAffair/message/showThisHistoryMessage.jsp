<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
/***layout*row1+row2+row3****/
.main_div_row3 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row3 {
 width: 100%;
 height: 100%;
 _padding:22px 0px 22px 0px;
}
.main_div_row3>.right_div_row3 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row3 {
 width: 100%;
 height: 375px;
 overflow-x:hidden;
 overflow-y:auto; 
}
.right_div_row3>.center_div_row3 {
 height:auto;
 position:absolute;
 top:22px;
 bottom:22px;
}
.top_div_row3 {
 height:22px;
 width:100%;
 background-color:#ededed;
 position:absolute;
 top:0px;
}
.bottom_div_row3 {
 height:22px;
 width:100%;
 text-align:right;
 background-color:#ededed;
 position:absolute;
 bottom:0px;
 _bottom:-1px; /*-- for IE6.0 --*/
}
/***layout*row1+row2+row3**end**/
</style>
</head>
<body>
<div class="main_div_row3">
  <div class="right_div_row3">
    <div class="top_div_row3">
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<c:choose>
					<c:when test="${!v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}">
						<c:set value="whenstart('${pageContext.request.contextPath}', this, null, null, null, null, 220, 250)" var="onClick"/>
						<c:set value="/seeyon/apps_res/v3xmain/images/message/16/search.gif" var="imgUrl"/>
					</c:when>
					<c:otherwise>
						<c:set value="" var="onClick"/>
						<c:set value="/seeyon/apps_res/v3xmain/images/message/16/clock.gif" var="imgUrl"/>
					</c:otherwise>
				</c:choose>
				<td width="100" valign="middle">
					<input id="createDate" name="createDate" type="text" class="cursor-hand" style="width: 100px; padding: 0px 3px;" readonly value="${param.createDate}" onclick="${onClick}">
				</td>
				<td width="40">
					&nbsp;<img src="${imgUrl}" align="absmiddle" class="cursor-hand" onclick="selectDateTime('${pageContext.request.contextPath}', '${param.type}', '${param.id}', '${v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}');" />
				</td>
				<td align="right">&nbsp;</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row3">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<c:forEach items="${messageList}" var="message">
				<tr>
					<td style="padding: 5px 10px;" valign="top">
		        		<span style="color: green;">${message.senderName}:</span>&nbsp;&nbsp;
		        		<font class="col-reply-date"><fmt:formatDate value="${message.creationDate}" pattern="yyyy-MM-dd HH:mm:ss" /></font>
					</td>
				</tr>
				<tr>
					<td style="padding: 5px 30px;" valign="top">
						${message.messageContent}
					</td>
				</tr>
			</c:forEach>
		</table>
    </div>
    <div class="bottom_div_row3">
		<c:if test="${nowPage != 1}"><a href="javascript:firstPage('${param.type}', '${param.id}');"></c:if>
		<img src="/seeyon/apps_res/v3xmain/images/message/16/pagination_first.gif" border="0" align="absmiddle" class="cursor-hand" alt="<fmt:message key='taglib.list.table.page.first.label' bundle='${v3xCommonI18N}'/>" />
		</a>
		<c:if test="${nowPage != 1}"><a href="javascript:prevPage('${param.type}', '${param.id}', '${nowPage}')"></c:if>
		<img src="/seeyon/apps_res/v3xmain/images/message/16/pagination_prev.gif" border="0" align="absmiddle" class="cursor-hand" alt="<fmt:message key='taglib.list.table.page.prev.label' bundle='${v3xCommonI18N}'/>" />
		</a>
		<fmt:message key="taglib.list.table.page.current" bundle="${v3xCommonI18N}"/>&nbsp;<input maxlength="3" type="text" id="nowPage" name="nowPage" value="${nowPage}" onkeydown="changePage('${param.type}', '${param.id}', '${pages}')" style="width: 20px; height: 15px;">&nbsp;<fmt:message key="taglib.list.table.page.total" bundle="${v3xCommonI18N}"/>&nbsp;/&nbsp;${pages}&nbsp;<fmt:message key="taglib.list.table.page.total" bundle="${v3xCommonI18N}"/>
		<c:if test="${nowPage != pages && size != 0}"><a href="javascript:nextPage('${param.type}', '${param.id}', '${nowPage}')"></c:if>
		<img src="/seeyon/apps_res/v3xmain/images/message/16/pagination_next.gif" border="0" align="absmiddle" class="cursor-hand" alt="<fmt:message key='taglib.list.table.page.next.label' bundle='${v3xCommonI18N}'/>" />
		</a>
		<c:if test="${nowPage != pages && size != 0}"><a href="javascript:endPage('${param.type}', '${param.id}', '${pages}');"></c:if>
		<img src="/seeyon/apps_res/v3xmain/images/message/16/pagination_last.gif" border="0" align="absmiddle" class="cursor-hand" alt="<fmt:message key='taglib.list.table.page.last.label' bundle='${v3xCommonI18N}'/>" />
		</a>
    </div>
  </div>
</div>
</body>
</html>