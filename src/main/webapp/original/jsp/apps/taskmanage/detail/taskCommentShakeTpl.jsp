<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%-- 这里是震荡回复 --%>
<c:if test="${success }">
	<li class="tabs_reply_content_list">
		<div class="tabs_reply_content_list_title clearfix">
			<span class="left">
			    <a name="memberName" onclick="showPropleCard('${comment.presonId}')" style="cursor:${comment.personCursor};color:${comment.textColor};" title="${comment.personNameAll }"><c:out value="${comment.personName }" escapeXml="false"/></a>
			    <span class="margin_l_10">${comment.createTime }</span>
		    </span>
		</div>
		<p class="tabs_reply_content_list_content"><c:out value="${comment.content }" escapeXml="false"/></p>
	</li>
</c:if>
