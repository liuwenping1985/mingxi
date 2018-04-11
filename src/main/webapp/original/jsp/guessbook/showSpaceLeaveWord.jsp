<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />"></script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="170px">
			<div class="scrollList">
				<div id="showLeaveWordsDIV" style="height: 100%;word-break: break-all"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td class="tr-bottom-button">
			<a href="javascript:showLeaveWordDlg('${departmentId}')">[<fmt:message key="guestbook.leaveword.label"/>]</a>&nbsp;&nbsp;
				<a href="<html:link renderURL="/guestbook.do?method=moreLeaveWord&departmentId=${departmentId}" psml="default-page.psml" />">[<fmt:message key="common.more.label" bundle="${v3xCommonI18N}"/>]</a>
		</td>
	</tr>
</table>

<script>
var datetimePattern = "MM/dd HH:mm";
var leaveWordsArray = [];
<c:forEach items="${leaveWordList}" var="leaveWord">         
leaveWordsArray[leaveWordsArray.length] = new LEAVE_WORD(
	                                                     "${v3x:escapeJavascript(v3x:showMemberName(leaveWord.creatorId))}",
                                                         "${v3x:escapeJavascript(leaveWord.content)}",
                                                         "${leaveWord.createTime.time}"
                                                        );
</c:forEach>
  
loadLeaveWords();
</script>