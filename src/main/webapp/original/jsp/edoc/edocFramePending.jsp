<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp"%>

${v3x:showAlert(pageContext)}


</head>

	<frameset id="treeandlist" rows="*" cols="100%" frameBorder="1" frameSpacing="5" bordercolor="#ececec">
		<!--
		<frame src="${edoc}?method=listLeft&edocType=1&from=listDistribute&list=listDistribute" name="treeFrame" frameborder="0" scrolling="yes"  id="treeFrame"/>
		-->
<frameset rows="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request) ? '*,9' : '*'}" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
  <frame frameborder="no" src="${edoc}?method=newEdoc&edocType=1&id=${param.id}&source=pendingSection" name="listFrame" scrolling="no" id="listFrame" />
</frameset>
	</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>
<!--${edoc}?method=listDistribute&edocType=1&list=listDistribute-->
<!--${edoc}?method=newEdoc&edocType=1&id=${id}-->