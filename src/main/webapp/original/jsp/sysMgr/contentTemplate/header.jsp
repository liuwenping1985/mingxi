<%@ include file="../../common/INC/noCache.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/meeting/css/meeting.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>
<!-- TODO youhb jqueryError <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script> -->
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/meeting.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
	v3x.loadLanguage("/apps_res/meeting/js/i18n");
	v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
	_ = v3x.getMessage;
	var meetingUrl = '${mtMeetingURL}' ;
	var docURL = '${docURL}' ;
	var colURL = '${colURL}' ;
</script>
