<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="\seeyon\main\login\V56Show\js\jquery-1.8.3.min.js"></script>
</head>
<body>
<form name="myForm" id="myForm" >
<title>默认模板设置</title>
<body>
<h4>请选择单位默认模板</h4>
<br>
<br>

<p1>发文模板:</p1>
<select id="fawen" name="fawen"  style="width:150px;">
<c:choose>
<c:when test="${not empty fwxzlist}">
<c:forEach items="${fwxzlist }" var="bean">
<option value="${bean.id}" selected>${bean.subject}</option>
</c:forEach>
<option value="0">------无------</option>
</c:when>
<c:otherwise>
<option value="0">------无------</option>
</c:otherwise>
</c:choose>

<c:forEach items="${fawenlist}" var="bean">
	<option value="${bean.id}">${bean.subject}</option>
</c:forEach>
</select> 
<br>


<p2>收文模板:</p2>
<select id="shouwen" name="shouwen" style="width:150px;" >
 <c:choose>
<c:when test="${not empty swxzlist}">
<c:forEach items="${swxzlist}" var="bean">
<option value="${bean.id}" selected>${bean.subject}</option>
</c:forEach>
<option value="0">------无------</option>
</c:when>
<c:otherwise>
<option value="0" >------无------</option>
</c:otherwise>
</c:choose> 
<c:forEach items="${shouwenlist}" var="bean">
	<option value="${bean.id}">${bean.subject}</option>
</c:forEach>
</select>
<br>

<p3>签报模板:</p3>
<select id="qianbao" name="qianbao" style="width:150px;">
 <c:choose>
<c:when test="${not empty qbxzlist}">
<c:forEach items="${qbxzlist }" var="bean">
<option value="${bean.id}" selected>${bean.subject}</option>
</c:forEach>
<option value="0">------无------</option>
</c:when>
<c:otherwise>
<option value="0" >------无------</option>
</c:otherwise>
</c:choose>
<c:forEach items="${qianbaolist}" var="bean">
<option value="${bean.id}">${bean.subject}</option>
</c:forEach>
</select>
<br>
<br>

</form>
</body>
<script type="text/javascript">
/* function myFormSubmit(){
	var myForm = document.getElementById("myForm");
	myForm.action = "/seeyon/defaultTemplate.do?method=depDefaultTemplate";
	myForm.submit(); 
	$.ajax({
		url : "/seeyon/defaultTemplate.do?method=depDefaultTemplate",
		success : function(data){
			alert(data);
		}
	});
} */
function OK(){
	var obj = new Object();
	obj = document.getElementById("myForm");
	//obj.submit();
	return obj;
}
</script>
</html>
