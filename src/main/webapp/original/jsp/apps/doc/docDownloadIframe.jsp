<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>



</head>
<body>

<form  target="_blank" method="get" name="downloadForm" action="" >
<input type="hidden" name="method" value="docDownloadNew">
<input type="hidden" name="id" value="${param.id}">
</form>

<script type="text/javascript">
<!--
	if('true' == '${flag}'){
		parent.parent.docOpenBodyFrame.endProc();
		document.all.downloadForm.action = jsURL;
		document.all.downloadForm.submit();
	}else{
		parent.docOpenBodyFrame.endProc();
		alert(parent.v3x.getMessage("DocLang.doc_alert_download_failure"));
	}

//-->
</script>

</body>
</html>