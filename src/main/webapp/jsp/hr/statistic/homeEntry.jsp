<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<frameset rows="30,*" id="main" framespacing="0">
    <frame noresize="noresize" frameborder="no" src="${urlHrStatistic}?method=toolBar" name="toolbarFrame" id="toolbarFrame" scrolling="no" />
    <frameset id="treeandlist" rows="*" cols="20%,*" framespacing="5" frameborder="yes" bordercolor="#ececec">
    	<frame frameborder="0" src="${urlHrStatistic}?method=statisticTree" scrolling="no" name="statisticTree" id="statisticTree"/>
		<frame src="${urlHrStatistic}?method=initStatisticFrame" id="statisticFrame" name="statisticFrame" frameborder="no" scrolling="no" />
	</frameset>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>

</html>