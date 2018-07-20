<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
<title><fmt:message key="inquiry.auditor.manage.label"></fmt:message></title>
<script type="text/javascript">
refreshAndCloseWhenInvalid("${dataExist}" == "false", "${param.from}", _("InquiryLang.inquiry_invalid"));
refreshAndCloseWhenInvalid("${dataLocked}" == "true", "${param.from}", "${alertMsg}");
</script>
</head>
 	<frameset rows="${param.from!='list'?'0':'10'},*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	  <frame noresize="noresize" src='<c:url value="/common/detail.jsp" />' scrolling="no">
	  <frameset  rows="*" cols="*,45" framespacing="1" id="zy" name="zy">
	    <frame frameborder="no" src="${basicURL}?method=survey_check&description=left&bid=${param.bid}&group=${param.group}&from=${param.from}&auditFlag=${param.auditFlag}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
	    <frame frameborder="no" src="${basicURL}?method=survey_check&description=right&bid=${param.bid}&group=${param.group}&from=${param.from}&auditFlag=${param.auditFlag}" name="detailRightFrame" scrolling="no" id="detailRightFrame" />
	  </frameset>
	</frameset>
</html>