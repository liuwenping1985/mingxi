<%@ page language="java" contentType="text/html; charset=UTF-8" session="false" pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", 0);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ctrip</title>
</head>
<form action="https://ct.ctrip.com/m/SingleSignOn/H5SignInfo" method="post" name="SSOLoginForm"> 
<input type="hidden" name="accessuserid" value="${param.accessuserid}" />
<input type="hidden" name="employeeid" value="${param.employeeid}" />
<input type="hidden" name="token" value="${param.token}"/>
<input type="hidden" name="appid" value="${param.appid}" />
<input type="hidden" name="initpage" value="Home"/>
<input type="hidden" name="Callback" value=""/>
</form> 
<script type="text/javascript">

	window.onload = function() {
		
		if ("${param.isOpend}" == "false") {
			alert("${ctp:i18n('xc.internate.set.open')}");
			window.history.go(-1);
		} else if("${param.token}" == ""){
			alert("${ctp:i18n('xc.internate.set.take')}");
			window.history.go(-1);
		}else {
			document.SSOLoginForm.submit();
		}
	}
</script>
        </html>