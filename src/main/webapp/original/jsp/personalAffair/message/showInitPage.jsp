<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
<!--
#titleDiv{
	position: absolute;
	left: 30px;
	top: 28px;
	width: 440px;
	z-index:2;
}
.title{
	font-size: 26px;
	font-family: Verdana;
	font-weight: bolder;
	color: #969696;
	padding-right: 20px;
}
#Layer1 {
	font-size: 12px;
	position: absolute;
	width: 400px;
	height: 78px;
	z-index: 1;
	left: 30px;
	top: 80px;
	color: #999999;
}
#imgDiv{
    height: 70px;
    width: 160px;
}
//-->
</style>
</head>
<body>
	<div id="allDiv">
		<div id="titleDiv">
			<span id="titlePlace" class="title"><fmt:message key="message.historyMessageLink.label" /></span>
			<span id="countPlace"></span>
		</div>
		
		<div id="Layer1">
			<ul id="descriptionPlace">
				<script type="text/javascript">
					document.write(v3x.getMessage("MainLang.detail_info_9108"));
					document.close();
				</script>
			</ul>
		</div>
	</div>
</body>
</html>