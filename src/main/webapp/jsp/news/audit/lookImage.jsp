<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../include/header.jsp" %>
</head>
<body>
<img style="padding:0px; border:0px solid #cccccc;" name="imageId" id="imageId" />
</body>
<script type="text/javascript">
	var newsObj = v3x.getParentWindow();
	var imageId = newsObj.document.getElementById("imageId").value;
	var createDate = newsObj.document.getElementById("imageDate") ? newsObj.document.getElementById("imageDate").value : newsObj.document.getElementById("createDate").value;
	if(createDate.length > 10){
		createDate = createDate.substring(0, 10);
	}
	document.getElementById("imageId").src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=" + imageId + "&createDate=" + createDate + "&type=image";
</script>
</html>