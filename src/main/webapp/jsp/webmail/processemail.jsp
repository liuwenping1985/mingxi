<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create</title>
<%@ include file="webmailheader.jsp" %>
<script type="text/javascript">
//emailAddress
	var to = parent.document.getElementById(parent.addFlag);
	var emails = "";
	<c:forEach items="${list}" var="bean">
		if("${bean.emailAddress}".length > 0){
			if(emails.length > 0){
				emails += ","
			}
			if(to.value.indexOf("${bean.emailAddress}") == -1){
				emails += "${bean.emailAddress}";
			}
		}
	</c:forEach>
	if(emails.length > 0){
		if(to.value.length > 0){
			to.value += "," + emails;
		}else{
			to.value = emails;
		}
	}
</script>
</head>
<body scroll="no" class="webmail-padding">
</body>
</html>