<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocBar.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
onLoadLeft();

$(function(){ 
	　　$('a').click(function(){
	　　$(this).addClass("active").siblings().removeClass();
	    }); 
	}); 

window.onunload = function() {
	unLoadLeft();
}
</script>

</head>
<frameset id="treeandlist" rows="*" cols="${isAgent?'0':'16' }%,*" frameBorder="1" frameSpacing="5" bordercolor="#ececec">
		<frame src="edocSupervise.do?method=superviseLeft&edocType=${edocType}" name="treeFrame" frameborder="0" scrolling="yes"  id="treeFrame"/>
<frameset rows="30%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="supervise/supervise.do?method=listSupervise&app=4" name="listFrame" scrolling="no" id="listFrame" />
	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</c:if>
</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>
<!-- <frameset cols="13%,*" framespacing="0" frameborder="no" border="0" scrolling="no">
<frame  frameborder="no" src="edocSupervise.do?method=superviseLeft" name="treeFrame" scrolling="yes" id="treeFrame"/>
	<frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  <frame frameborder="no" src="edocSupervise.do?method=list" name="mainIframe" scrolling="auto" id="mainIframe" />
	  <frame frameborder="no" src="<c:url value="/common/detail_edoc.html" />" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>-->