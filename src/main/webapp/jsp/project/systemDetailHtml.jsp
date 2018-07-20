<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@include file="projectHeader.jsp"%>
<title>Insert title here</title>
</head>
<script type="text/javascript">
//getA8Top().showLocation(3309);
</script>

<style>
<!--
#titleDiv{
	position: absolute;
	left: 140px;
	top: 28px;
	width: 700px;
	z-index:2;
}

.title{
	font-size: 26px;
	font-family: Verdana;
	font-weight: bolder;
	color: #6699cc;
	padding-right: 20px;
}

#Layer1 {
	font-size: 12px;
	position: absolute;
	width: 660px;
	height: 78px;
	z-index: 1;
	left: 220px;
	top: 80px;
	color: #999999;
}
//-->
</style>
<body scroll="no">
<div id="allDiv">
		<div id="titleDiv">
			<span id="titlePlace"><label class="title"><fmt:message key='work.area.setup.project' bundle='${v3xMainI18N}'/></label></span>
			<span id="countPlace"></span>
		</div>
		<img id="img" alt="" src='<c:url value= "/common/images/detailBannner/102.gif"/>' height="70" width="160"> 
		<div id="Layer1">
		  &nbsp;
		</div>
    </div>
</body>
</html>	