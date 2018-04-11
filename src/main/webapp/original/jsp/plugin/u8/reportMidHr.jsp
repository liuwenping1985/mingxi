<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<script type="text/javascript">
<!--
$(function(){
	var keys = ["reportType","retType"];
	var values = ["${reportType}","${retType}"];
	openSmallWindow("/seeyon/u8ReportHr.do?method=reportLink", "", keys, values);
	selfShutDown();
});
function selfShutDown(){ 
//	window.opener = ""; 
	window.close(); 
} 


function openSmallWindow(url, name, keys, values) {
    var newWindow = window.open('', name, 'top=180,left=290,toolbar=no,menubar=no,location=yes,resizable=yes,status=yes,Width=1000,height=500');
    if (!newWindow) return false;
    var html = "";
    html += "<html><head></head><body><form id='postformid' method='post' action='" + url + "'>";
    if (keys && values && (keys.length == values.length)) {
        for (var i = 0; i < keys.length; i++)
            html += "<input type='hidden' name='" + keys[i] + "' value='" + values[i] + "'/>";
    }
    html += "</form><script type='text/javascript'>document.getElementById(\"postformid\").submit()</script></body></html>";
    newWindow.document.write(html);
    return newWindow;
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>U8</title>
</head>
<body>
</body>
</html>