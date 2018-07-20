<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
window.onload = function(){
}
	
    //-->
</script>
</head>
<body onload="">
<div class="main_div_row2">
<div class="right_div_row2">
<div class="center_div_row2" id="scrollListDiv" style="top:0;">
<form name="listForm" id="listForm" method="post" style="margin: 0px">

<v3x:table htmlId="listTable" data="list" var="bean" >
	<script>
			
		</script>
	<v3x:column width="35%" type="String" label="mt.showlog.record_person" className="cursor-hand sort" maxLength="45" symbol="...">
		${v3x:showMemberName(bean.userId)}
	</v3x:column>

	<v3x:column width="35%" type="String" label="mt.showlog.record_time" className="cursor-hand sort" maxLength="45" symbol="...">
		<fmt:formatDate pattern="${datePattern}" value="${bean.lookTime}" />
	</v3x:column>

	<v3x:column width="30%" type="String" label="mt.showlog.state" className="cursor-hand sort" maxLength="45" symbol="...">
		<fmt:message key='mt.mtReply.feedback_flag.${bean.lookState}'/>
	</v3x:column>

</v3x:table>
</form>
</div>
</div>
</div>
<%--
<%@ include file="../../doc/pigeonholeHeader.jsp"%>
 //TODO
 --%>
<jsp:include page="../include/deal_exception.jsp" />
<script type="text/javascript">
<!--
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
//-->
</script>

</body>
</html>