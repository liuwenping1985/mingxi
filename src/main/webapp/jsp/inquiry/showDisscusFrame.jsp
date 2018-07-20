<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<c:set var="titleKey" value="${param.singleMany!='2' ? 'inquiry.look.review.label' : 'inquiry.look.answer.label'}" />
<title><fmt:message key="${titleKey}" /></title>
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<iframe id="showDisscusFrame" name="showDisscusFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>
</table>
<script type="text/javascript">
<!--
	showDisscusFrame.window.location.href = "${basicURL}?method=discuss_detail&bid=${param.bid}&qid=${param.qid}&tid=${param.tid}&manager_ID=${param.manager_ID}&cryptonym=${param.cryptonym}&isInquiry_createUser=${param.isInquiry_createUser }&singleMany=${param.singleMany}&qname="+encodeURIComponent("${v3x:toHTML(param.qname)}");
//-->
</script>
</body>
</html>