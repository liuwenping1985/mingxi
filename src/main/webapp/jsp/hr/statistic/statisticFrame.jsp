<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
window.onload=function(){
	var statisticSrc = "${hrStatisticURL }?method=statisticOfQuantityByAge";
	var detailSrc = "${hrStatisticURL }?method=ageDistributing&newOrChanged=noChanged&noCh=<%=(Math.random() * 100000)%>";
	window.frames["statisticTable"].location.href = statisticSrc;
	setTimeout(
		function(){	
			window.frames["detailFrame"].location.href = detailSrc;
		},
		100
	);
}
</script>
</head>
<frameset rows="35%,*" id='sx' cols="*" frameborder="no" >
	<frame frameborder="no" src="" name="statisticTable" id="statisticTable" scrolling="no" id="statisticTable" />
	<frame src="" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>