<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>

<%--谁再敢再正文组件里，乱写代码，把代码搞的很多，很乱，弄死， 王峰留 --%>
<%if(request.getParameter("isFullPage")!=null){ %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${ctp_contextPath}/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/isignaturehtml/js/isignaturehtml.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/license.js${ctp:resSuffix()}"></script>
<html>
<head>
<%
String path = request.getContextPath();//获取项目名
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; //获得项目url
%>
<% if(request.getAttribute("isGovdocForm")!=null){%>
<style>
	.link-blue{
		display:inline-block;
		cursor:pointer;
		color:#296fbe!important;
	}
</style>
${hwjs }
<%} %>
<script>
	var isGovdocForm = "${isGovdocForm}";
	var opinionType = "${opinionType}";
	var url1 = "<%=basePath%>PDFServlet.jsp";
	var url2 = "<%=basePath%>AipServlet.jsp";
	var _fileType = "${fileType}";
	var isTakeback="${param.isTakeback}";
</script>
<link href="${ctp_contextPath}/common/content/content.css" rel="stylesheet" type="text/css" />
<title></title>
<!-- 重置样式， 公文发文拟文表单中日期控件问题 -->
<style type="text/css">
	.calendar{ background:#fff}
	.calendar table{ background:#fff}
</style>
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
		var ols =  "${ols}";
		var allowEditInForm = "${allowEditInForm}";
		${opinionsJs}
		var senderOpinion = "${senderOpinion}";
	</script>
	<script type="text/javascript" src="${ctp_contextPath}/common/content/content_js_end.js${ctp:resSuffix()}"></script>
<%if(request.getParameter("isFullPage")!=null){ %>
</div>
<% if(request.getAttribute("isGovdocForm")!=null){%>
<div style="visibility:hidden" id="opinionDivGetVal"></div>
<!-- 
<table align="center" width="800px" border="0" cellspacing="0" cellpadding="0" id="printOtherOpinionsTable" <c:if test="${param.from eq'Pending' }">style="padding-top:40px"</c:if>>
	<tr id="dealOpinionTitleDiv" style="display:none">
		<td>
			<hr style="width:100%;border-bottom:1px solid #a4a4a4; border-top:none;border-left:none;" size="1">
			<div class="div-float">
				<div class="div-float body-detail-su"  id="dealOpinionTitle"><fmt:message key="edoc.element.comment"  /></div>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div  class="wordbreak" id="displayOtherOpinions" name="displayOtherOpinions" style="visibility:hidden;"></div>
		</td>
	</tr>
</table>-->
<%} %>
</body>
</html>
<%} %>
<%--谁再敢再正文组件里，乱写代码，把代码搞的很多，很乱，弄死， 王峰留 --%>