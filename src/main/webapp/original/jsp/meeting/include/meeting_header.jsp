<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%@ include file="../../migrate/INC/noCache.jsp" %>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/bulletin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/meeting.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/meetingCommon.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/include.js${v3x:resSuffix()}" />"></script>
<html:link renderURL="/edocController.do" var="quoteEdocDetailUrl" />
<script type="text/javascript">
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
	v3x.loadLanguage("/apps_res/meeting/js/i18n");
	v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
	_ = v3x.getMessage;
	
	var meetingURL = '${meetingURL}';
	var mtMeetingUrl = '${mtMeetingURL}';
	var docURL = '${docURL}';
	var colURL = '${colURL}';
	var edocURL ='${edocURL}';
	var _edocFlag = ${_viewEdocFlag eq '1'};
	var edocDetailURL = '${quoteEdocDetailUrl}';
	
	var pigeonholeURL = "${pigeonholeDetailURL}";
	
	try {
		getA8Top().endProc('');
	} catch(e) {}
</script>
