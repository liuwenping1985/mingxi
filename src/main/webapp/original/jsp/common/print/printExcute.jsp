<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>


<html>
<%if(request.getParameter("isFullPage")!=null){ %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${ctp_contextPath}/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/isignaturehtml/js/isignaturehtml.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/license.js${ctp:resSuffix()}"></script>
<html>
<head>
<link href="${ctp_contextPath}/common/content/content.css" rel="stylesheet" type="text/css" />
<title></title>
</head>
<body onkeydown="_keyDown()">
<div id="bodyBlock" class=" content_view " style="background:#FFF;">
<%}%>
<%if(request.getParameter("isFullPage")==null){ %>
<script type="text/javascript" src="${ctp_contextPath}/common/isignaturehtml/js/isignaturehtml.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/license.js${ctp:resSuffix()}"></script>
<%}%>
<%@ include file="/WEB-INF/jsp/common/content/include/include_variables.jsp"%><%--必要的JS变量--%>
<c:if test="${contentList[0].contentType==20}">
        <div id="mainbodyDiv" class="mainbodyDiv" style="background:#FFF;line-height:normal;">
        <%@ include file="/WEB-INF/jsp/common/content/include/include_changeModel.jsp"%><%--切换查看模式区域--%>
</c:if>
<c:if test="${contentList[0].contentType!=20}">
    <div id="mainbodyDiv" class="mainbodyDiv h100b" >
</c:if>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_mainbody.jsp"%><%--正文区域--%>
</div>
    <c:if test="${contentCfg.useWorkflow}">
        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" /><%--工作流相关--%>
    </c:if>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_html_hw.jsp"%><%--HTML签章相关--%>
	<script type="text/javascript">
		var content = {};
		content.contentType = "${contentList[0].contentType}";
		content.moduleType = "${contentList[0].moduleType}";
		content.style = "${style}";
	</script>
	<script type="text/javascript" src="${ctp_contextPath}/common/content/content_js_end.js${ctp:resSuffix()}"></script>
<%if(request.getParameter("isFullPage")!=null){ %>
</div>
</body>
</html>
<%} %>