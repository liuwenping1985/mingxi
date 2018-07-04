
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="${flag == 'open' ? 'blog.article.view' : 'blog.article.update'}"/></title>
<script type="text/javascript">
		
		var exist = '${dataExist}';
		try{
		if('false' == exist){	
			alert(v3x.getMessage("BlogLang.blog_data_delete_alert"));
			getA8Top().showFrameWin.close();
		}}catch(e){}
</script>
<script> 
window.onunload = function() 
{ 

	if ((function() 
	{ 
	  var a = 0; 
	  var b = 0; 
	  if(parseInt(navigator.appVersion) > 3) 
	  { 
	    if(navigator.appName == "Netscape") 
	   { 
	    a = window.innerWidth; 
	    b = window.innerHeight; 
	   } 
	if(navigator.appName.indexOf("Microsoft") != - 1) 
	{ 
	  a = top.window.document.body.offsetWidth; 
	  b = top.window.document.body.offsetHeight; 
	 } 
	  } 
	   return(event.clientY < 0 && event.screenX > (a - 25)); 
	  } 
	  )()) { 
	  getA8Top().showFrameWin.close();
	} 
} 
function closeAndShow(url) {

	showPostIframe.location.href = url;
}
</script> 
</head>
<body scroll=no>
<c:if test = "${param.flag == 'open'}">
	<IFRAME name="showPostIframe" id="showPostIframe" frameborder="0" width="100%" height="100%" src="${detailURL}?method=showPost&articleId=${param.articleId}&familyId=${param.familyId}&resourceMethod=docHomepage&where=${param.where}&v=${ctp:digest_4(param.articleId,param.familyId,'docHomepage',param.where)}"></IFRAME>
</c:if>

<c:if test = "${flag == 'update'}">
	<IFRAME name="showPostIframe" id="showPostIframe" frameborder="0" width="100%" height="100%" src="${detailURL}?method=updateBlog&blogId=${param.articleId}&familyId=${param.familyId}&resourceMethod=docHomepage"></IFRAME>
</c:if>
</body>
</html>
