<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>

<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 

<%@ include file="/WEB-INF/jsp/apps/collaboration/new_print.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_addData_js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<%@ include file="/WEB-INF/jsp/bulletin/bulletin_issue_js.jsp" %>
<%@ include file="/WEB-INF/jsp/news/news_issue_js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<div name="govdocPdfContentDiv" id="govdocPdfContentDiv"
			style="width: 0px; height: 0px; overflow: hidden; position: absolute;">
			<v3x:editor htmlId="pdfcontent" editType="4,0"
				content="${govdocCtpContentAll.content== null ? '' : govdocCtpContentAll.content}"
				type="${govdocPdfType}"
				originalNeedClone="false" createDate="${govdocPdfContentCreateTime}"
				category="4" />
   </div>
</body>
</html>