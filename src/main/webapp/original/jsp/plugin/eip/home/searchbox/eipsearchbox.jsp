<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="height: 100%">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>首页</title>
</head>
<body style="overflow: hidden;height: 100%">
<iframe marginheight="0" marginwidth="0" height="100%" style="height: 100%;" src="\seeyon\isearch.do?method=index&_resourceCode=F12_isearch" name="dataIFrame0" scroll="no" id="dataIFrame0" width="100%" frameborder="0"></iframe>
<script type="text/javascript">
window.onload=function(){ 
	window.frames["dataIFrame0"].cursorTag(1);//containerFrame
	setTimeout("a()", 200);
}
function a (){
	if(window.frames["dataIFrame0"].frames["containerFrame"].document.getElementById("simpleSearch")){
		window.frames["dataIFrame0"].frames["containerFrame"].document.getElementById("simpleSearch").value = "${context}";
		window.frames["dataIFrame0"].frames["containerFrame"].searchAction();
	}else{
		setTimeout("a()", 200);
	}
}
</script>
</body>
</html>