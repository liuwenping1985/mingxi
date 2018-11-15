<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
boolean isMacOS = false;
boolean isWeblogic = response.getClass().getName().startsWith("weblogic");
String userAgent = request.getHeader("User-Agent");
if(userAgent!=null && userAgent.indexOf("Macintosh")>0)isMacOS = true;
String encoding = isMacOS ? "UTF-8":"GBK";
encoding= "UTF-8";
String doUrl = "/fileUpload.do";
if(!Boolean.TRUE.equals((Boolean)request.getAttribute("isHTML"))){
	String p = "";
	java.util.Map<String, String> ps = (java.util.Map<String, String>)request.getAttribute("ps");
	java.util.Set<java.util.Map.Entry<String, String>> en = ps.entrySet();
	for(java.util.Map.Entry<String, String> entry : en){
		//p += entry.getKey() + "=" + java.net.URLEncoder.encode(new String(entry.getValue().getBytes("iso8859-1"),"UTF-8"),encoding) + "&"; //处理标准url
		String value = entry.getValue();
		if(isWeblogic){
			//value = new String(value.getBytes("utf-8"),"iso-8859-1");
		}
		p += entry.getKey() + "=" + java.net.URLEncoder.encode(value,encoding) + "&";
        if("v".equals(entry.getKey())) {
            doUrl = "/fileDownload.do";
        }
		//p += entry.getKey() + "=" +entry.getValue()+ "&";
	}
	
	response.sendRedirect(request.getContextPath() + doUrl + "?method=doDownload&" + p);
}
else{
%>
<form target="_blank" method="get" name="downloadForm" >
<input name="method" type="hidden" value="doDownload4html" />
<input name="from" type="hidden" value="blank" />

<c:forEach items="${v3x:mapKeys(ps)}" var="p">
<input name="${p}" type="hidden" value="<c:out value="${ps[p]}" escapeXml="true"/>" />
</c:forEach>
</form>

<script type="text/javascript">
<!--
document.all.downloadForm.action = "<c:url value='/fileUpload.do;jsessionid=' />" + "<%=session.getId()%>";
document.all.downloadForm.submit();
//-->
</script>

<%
}
%>
</body>
</html>